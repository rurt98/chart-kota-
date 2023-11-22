import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_data_table/custom_data_table.dart';
import 'package:final_project_ba_char/models/product.dart';
import 'package:final_project_ba_char/providers/auth_provider.dart' as provider;
import 'package:final_project_ba_char/providers/db_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project_ba_char/models/user.dart' as model;

class ProductsProvider with ChangeNotifier {
  final DBProvider dbProvider;
  final provider.AuthProvider authProvider;

  FirebaseFirestore get db => dbProvider.db;
  FirebaseAuth get auth => authProvider.auth;

  ProductsProvider(this.dbProvider, this.authProvider);

  List<Product>? products;
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

  Future<List<Product>?> obtenerLista({
    Function(String)? onError,
  }) async {
    loading = true;
    try {
      paginatorInfo.lastPage = 1;
      final first = db
          .collection("products")
          .orderBy("name")
          .limit(paginatorInfo.perPage!);

      final documentSnapshots = await first.get();

      if (documentSnapshots.docs.isEmpty) {
        paginatorInfo.lastPage = paginatorInfo.currentPage;
        products = [];
        loading = false;
        return products;
      }

      products = await getProducts(documentSnapshots);

      lastDocument = documentSnapshots.docs.last;
      firstDocument = documentSnapshots.docs.first;

      paginatorInfo.currentPage = 1;
      paginatorInfo.lastPage = (paginatorInfo.currentPage ?? 1) + 1;

      loading = false;

      return products;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    } catch (_) {}
    loading = false;
    return null;
  }

  Future<List<Product>?> fetchNextPage({
    Function(String)? onError,
  }) async {
    if (lastDocument == null) return products;
    try {
      final next = db
          .collection("products")
          .orderBy("name")
          .startAfterDocument(lastDocument!)
          .limit(paginatorInfo.perPage!);

      final nextDocumentSnapshots = await next.get();

      if (nextDocumentSnapshots.docs.isEmpty) {
        paginatorInfo.lastPage = paginatorInfo.currentPage;
        loading = false;
        return products;
      }

      products = await getProducts(nextDocumentSnapshots);

      lastDocument = nextDocumentSnapshots.docs.last;
      firstDocument = nextDocumentSnapshots.docs.first;

      paginatorInfo.currentPage = (paginatorInfo.currentPage ?? 1) + 1;
      paginatorInfo.lastPage = (paginatorInfo.lastPage ?? 1) + 1;

      loading = false;

      return products;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    }
    loading = false;
    return products;
  }

  Future<List<Product>?> fetchPreviosPage({
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
          .collection("products")
          .orderBy("name")
          .endBeforeDocument(firstDocument!)
          .limitToLast(paginatorInfo.perPage!);

      final documentSnapshots = await previous.get();

      products = await getProducts(documentSnapshots);

      lastDocument = documentSnapshots.docs.last;
      firstDocument = documentSnapshots.docs.first;

      paginatorInfo.currentPage =
          (paginatorInfo.currentPage ?? 1) - 1; // Actualizar la página actual
      paginatorInfo.lastPage = (paginatorInfo.currentPage ?? 1) + 1;

      loading = false;
      return products;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    } catch (_) {}
    loading = false;
    return null;
  }

  Future<List<Product>?> getProducts(
          QuerySnapshot<Map<String, dynamic>> documentSnapshots) async =>
      Future.wait(
        documentSnapshots.docs.map(
          (e) async {
            var productData = e.data();
            var product = Product.fromJson(productData);

            if (productData.containsKey('supplier') &&
                productData['supplier'] is DocumentReference) {
              DocumentReference supplierRef =
                  productData['supplier'] as DocumentReference;

              DocumentSnapshot supplierSnapshot = await supplierRef.get();

              if (supplierSnapshot.exists) {
                product.supplier = model.User.fromJson(
                    supplierSnapshot.data() as Map<String, dynamic>);
              }
            }

            return product;
          },
        ),
      );

  Future<List<Product>> search({
    String? barcode,
    Function(String)? onError,
  }) async {
    try {
      final query = db
          .collection("products")
          .where('barcode', isGreaterThanOrEqualTo: barcode)
          .where('barcode', isLessThanOrEqualTo: '$barcode\uf8ff');

      final documentSnapshots = await query.get();

      if (documentSnapshots.docs.isEmpty) {
        return [];
      }

      return List.from(
        documentSnapshots.docs.map(
          (e) => Product.fromJson(
            e.data(),
          ),
        ),
      );
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    } catch (_) {}
    return [];
  }

  Future<bool> create({
    required Map<String, dynamic> data,
    required String supplierId,
    String? barcode,
    Function(String)? onError,
  }) async {
    loading = true;
    try {
      DocumentReference productRef = db.collection('products').doc();

      String uid = productRef.id;

      final date = DateTime.now().toString();

      data['uid'] = uid;
      data["barcode"] = barcode ?? generateBarcode(uid);
      data['created_at'] = date;
      data['updated_at'] = date;

      await productRef.set(data);

      DocumentReference supplierRef =
          db.collection('suppliers').doc(supplierId);

      await productRef.update({
        'supplier': supplierRef,
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

  Future<bool> edit({
    required Map<String, dynamic> data,
    required String uid,
    required String supplierId,
    Function(String)? onError,
  }) async {
    if (data.isEmpty) return true;
    loading = true;
    try {
      DocumentReference supplierRef =
          db.collection('suppliers').doc(supplierId);

      data['updated_at'] = DateTime.now().toString();

      await db.collection('products').doc(uid).update({
        ...data,
        'supplier': supplierRef,
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

  String generateBarcode(String uid) {
    // Generar una cadena aleatoria alfanumérica de longitud 5
    String caracteresPermitidos =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String codigoBarras = '';

    String uidFirstChar = uid[0];
    String uidLastChar = uid[uid.length - 1];

    Random random = Random();
    for (int i = 0; i < 5; i++) {
      codigoBarras +=
          caracteresPermitidos[random.nextInt(caracteresPermitidos.length)];
    }

    return ('$uidFirstChar$codigoBarras$uidLastChar').toUpperCase();
  }
}
