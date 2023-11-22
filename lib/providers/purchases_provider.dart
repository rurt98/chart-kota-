import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_data_table/custom_data_table.dart';
import 'package:final_project_ba_char/models/purchase.dart';

import 'package:final_project_ba_char/providers/auth_provider.dart' as provider;
import 'package:final_project_ba_char/providers/db_provider.dart';
import 'package:final_project_ba_char/providers/products_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project_ba_char/models/user.dart' as model;
import 'package:provider/provider.dart';

class PurchasesProvider with ChangeNotifier {
  final DBProvider dbProvider;
  final provider.AuthProvider authProvider;

  FirebaseFirestore get db => dbProvider.db;
  FirebaseAuth get auth => authProvider.auth;

  PurchasesProvider(this.dbProvider, this.authProvider);

  List<Purchase>? purchases;

  PaginatorInfo paginatorInfo = PaginatorInfo(
    total: 0,
    currentPage: 1,
    lastPage: 1,
    perPage: 15,
  );

  bool get loading => _isLoading;
  bool _isLoading = false;
  set loading(bool valor) {
    _isLoading = valor;
    notifyListeners();
  }

  DocumentSnapshot? lastDocument;
  DocumentSnapshot? firstDocument;

  Future<List<Purchase>?> obtenerLista({
    Function(String)? onError,
  }) async {
    loading = true;
    try {
      paginatorInfo.lastPage = 1;
      final first = db
          .collection("purchases")
          .orderBy("date")
          .limit(paginatorInfo.perPage!);

      final documentSnapshots = await first.get();

      if (documentSnapshots.docs.isEmpty) {
        paginatorInfo.lastPage = paginatorInfo.currentPage;
        purchases = [];
        loading = false;
        return purchases;
      }

      purchases = await getPurchases(documentSnapshots);

      lastDocument = documentSnapshots.docs.last;
      firstDocument = documentSnapshots.docs.first;

      paginatorInfo.currentPage = 1;
      paginatorInfo.lastPage = (paginatorInfo.currentPage ?? 1) + 1;

      loading = false;

      return purchases;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    } catch (_) {}
    loading = false;
    return null;
  }

  Future<List<Purchase>?> fetchNextPage({
    Function(String)? onError,
  }) async {
    if (lastDocument == null) return purchases;
    try {
      final next = db
          .collection("purchases")
          .orderBy("date")
          .startAfterDocument(lastDocument!)
          .limit(paginatorInfo.perPage!);

      final nextDocumentSnapshots = await next.get();

      if (nextDocumentSnapshots.docs.isEmpty) {
        paginatorInfo.lastPage = paginatorInfo.currentPage;
        loading = false;
        return purchases;
      }

      purchases = await getPurchases(nextDocumentSnapshots);

      lastDocument = nextDocumentSnapshots.docs.last;
      firstDocument = nextDocumentSnapshots.docs.first;

      paginatorInfo.currentPage = (paginatorInfo.currentPage ?? 1) + 1;
      paginatorInfo.lastPage = (paginatorInfo.lastPage ?? 1) + 1;

      loading = false;

      return purchases;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    }
    loading = false;
    return purchases;
  }

  Future<List<Purchase>?> fetchPreviosPage({
    Function(String)? onError,
  }) async {
    loading = true;
    try {
      if (firstDocument == null) {
        // Si no hay primer documento, no se puede obtener la página anterior
        loading = false;
        return null;
      }

      final previous = db
          .collection("purchases")
          .orderBy("date")
          .endBeforeDocument(firstDocument!)
          .limitToLast(paginatorInfo.perPage!);

      final documentSnapshots = await previous.get();

      purchases = await getPurchases(documentSnapshots);

      lastDocument = documentSnapshots.docs.last;
      firstDocument = documentSnapshots.docs.first;

      paginatorInfo.currentPage =
          (paginatorInfo.currentPage ?? 1) - 1; // Actualizar la página actual
      paginatorInfo.lastPage = (paginatorInfo.currentPage ?? 1) + 1;

      loading = false;
      return purchases;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    } catch (_) {}
    loading = false;
    return null;
  }

  Future<List<Purchase>?> getPurchases(
      QuerySnapshot<Map<String, dynamic>> documentSnapshots) async {
    return Future.wait(
      documentSnapshots.docs.map(
        (e) async {
          var purchaseData = e.data();
          var purchase = Purchase.fromJson(purchaseData);

          if (purchaseData.containsKey('operator') &&
              purchaseData['operator'] is DocumentReference) {
            DocumentSnapshot operatorSnapshot =
                await (purchaseData['operator'] as DocumentReference).get();

            if (operatorSnapshot.exists) {
              purchase.purchaseOperator = model.User.fromJson(
                  operatorSnapshot.data() as Map<String, dynamic>);
            }
          }

          if (purchaseData.containsKey('supplier') &&
              purchaseData['supplier'] is DocumentReference) {
            DocumentSnapshot operatorSnapshot =
                await (purchaseData['supplier'] as DocumentReference).get();

            if (operatorSnapshot.exists) {
              purchase.supplier = model.User.fromJson(
                  operatorSnapshot.data() as Map<String, dynamic>);
            }
          }

          return purchase;
        },
      ),
    );
  }

  Future<bool> create(
    BuildContext context, {
    required Purchase purchase,
    Function(String)? onError,
  }) async {
    loading = true;
    try {
      DocumentReference purchaseRef = db.collection('purchases').doc();

      String uid = purchaseRef.id;

      final data = purchase.toJson();

      data['uid'] = uid;

      await purchaseRef.set(data).then((_) async {
        Future.wait([
          ...purchase.products!
              .map((e) => context.read<ProductsProvider>().create(
                    data: e.toJson(),
                    supplierId: purchase.supplier!.uid!,
                    barcode: e.uid,
                  ))
              .toList()
        ]);
      });

      await purchaseRef.update({
        'supplier': db.collection('suppliers').doc(purchase.supplier!.uid!),
      });

      await purchaseRef.update({
        'operator': db.collection('users').doc(authProvider.user!.uid),
      });

      await obtenerLista(onError: onError);

      loading = false;

      return true;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    } catch (_) {}
    loading = false;
    return false;
  }

  String generateFolio() {
    String caracteresPermitidos =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String folio = '';
    final date = DateTime.now().toString();

    String uidFirstChar = date[0];
    String uidLastChar = date[date.length - 1];

    Random random = Random();
    for (int i = 0; i < 4; i++) {
      folio +=
          caracteresPermitidos[random.nextInt(caracteresPermitidos.length)];
    }

    return ('$uidFirstChar$folio$uidLastChar').toUpperCase();
  }
}
