import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_data_table/custom_data_table.dart';
import 'package:final_project_ba_char/models/sale.dart';
import 'package:final_project_ba_char/models/vat.dart';

import 'package:final_project_ba_char/providers/auth_provider.dart' as provider;
import 'package:final_project_ba_char/providers/db_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project_ba_char/models/user.dart' as model;

class SalesProvider with ChangeNotifier {
  final DBProvider dbProvider;
  final provider.AuthProvider authProvider;

  FirebaseFirestore get db => dbProvider.db;
  FirebaseAuth get auth => authProvider.auth;

  SalesProvider(this.dbProvider, this.authProvider);

  List<Sale>? sales;

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

  Future<List<Sale>?> obtenerLista({
    Function(String)? onError,
  }) async {
    loading = true;
    try {
      paginatorInfo.lastPage = 1;
      final first =
          db.collection("sales").orderBy("date").limit(paginatorInfo.perPage!);

      final documentSnapshots = await first.get();

      if (documentSnapshots.docs.isEmpty) {
        paginatorInfo.lastPage = paginatorInfo.currentPage;
        sales = [];
        loading = false;
        return sales;
      }

      sales = await getProducts(documentSnapshots);

      lastDocument = documentSnapshots.docs.last;
      firstDocument = documentSnapshots.docs.first;

      paginatorInfo.currentPage = 1;
      paginatorInfo.lastPage = (paginatorInfo.currentPage ?? 1) + 1;

      loading = false;

      return sales;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    } catch (_) {}
    loading = false;
    return null;
  }

  Future<List<Sale>?> fetchNextPage({
    Function(String)? onError,
  }) async {
    if (lastDocument == null) return sales;
    try {
      final next = db
          .collection("sales")
          .orderBy("date")
          .startAfterDocument(lastDocument!)
          .limit(paginatorInfo.perPage!);

      final nextDocumentSnapshots = await next.get();

      if (nextDocumentSnapshots.docs.isEmpty) {
        paginatorInfo.lastPage = paginatorInfo.currentPage;
        loading = false;
        return sales;
      }

      sales = await getProducts(nextDocumentSnapshots);

      lastDocument = nextDocumentSnapshots.docs.last;
      firstDocument = nextDocumentSnapshots.docs.first;

      paginatorInfo.currentPage = (paginatorInfo.currentPage ?? 1) + 1;
      paginatorInfo.lastPage = (paginatorInfo.lastPage ?? 1) + 1;

      loading = false;

      return sales;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    }
    loading = false;
    return sales;
  }

  Future<List<Sale>?> fetchPreviosPage({
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
          .collection("sales")
          .orderBy("date")
          .endBeforeDocument(firstDocument!)
          .limitToLast(paginatorInfo.perPage!);

      final documentSnapshots = await previous.get();

      sales = await getProducts(documentSnapshots);

      lastDocument = documentSnapshots.docs.last;
      firstDocument = documentSnapshots.docs.first;

      paginatorInfo.currentPage =
          (paginatorInfo.currentPage ?? 1) - 1; // Actualizar la página actual
      paginatorInfo.lastPage = (paginatorInfo.currentPage ?? 1) + 1;

      loading = false;
      return sales;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    } catch (_) {}
    loading = false;
    return null;
  }

  Future<List<Sale>?> getProducts(
      QuerySnapshot<Map<String, dynamic>> documentSnapshots) async {
    return Future.wait(
      documentSnapshots.docs.map(
        (e) async {
          var saleData = e.data();
          var sale = Sale.fromJson(saleData);

          if (saleData.containsKey('operator') &&
              saleData['operator'] is DocumentReference) {
            DocumentReference operatorRef =
                saleData['operator'] as DocumentReference;

            DocumentSnapshot operatorSnapshot = await operatorRef.get();

            if (operatorSnapshot.exists) {
              sale.saleOperator = model.User.fromJson(
                  operatorSnapshot.data() as Map<String, dynamic>);
            }
          }

          return sale;
        },
      ),
    );
  }

  Future<bool> create({
    required Sale sale,
    required Vat vat,
    Function(String)? onError,
  }) async {
    loading = true;
    try {
      DocumentReference saleRef = db.collection('sales').doc();

      String uid = saleRef.id;

      vat.history = null;
      sale.vat = vat;

      final data = sale.toJson();

      data['uid'] = uid;
      data['date'] = DateTime.now().toString();

      await saleRef.set(data).then((_) async {
        for (var product in sale.products!) {
          DocumentReference productRef =
              db.collection('products').doc(product.uid);

          final stock = product.stock! - product.quantity!;

          await productRef.update({
            'stock': stock,
          });
        }
      });

      DocumentReference operatorRef =
          db.collection('users').doc(authProvider.user!.uid);

      await saleRef.update({
        'operator': operatorRef,
      });

      await obtenerLista(onError: onError);

      loading = false;

      return true;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    }
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
