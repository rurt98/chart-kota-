import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_data_table/custom_data_table.dart';
import 'package:final_project_ba_char/providers/auth_provider.dart' as provider;
import 'package:final_project_ba_char/providers/db_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project_ba_char/models/user.dart' as model;

class SuppliersProvider with ChangeNotifier {
  final DBProvider dbProvider;
  final provider.AuthProvider authProvider;

  FirebaseFirestore get db => dbProvider.db;
  FirebaseAuth get auth => authProvider.auth;

  SuppliersProvider(this.dbProvider, this.authProvider);

  List<model.User>? users;
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

  Future<List<model.User>?> obtenerLista({
    Function(String)? onError,
  }) async {
    loading = true;
    try {
      paginatorInfo.lastPage = 1;
      final first = db
          .collection("suppliers")
          .orderBy("names")
          .limit(paginatorInfo.perPage!);

      final documentSnapshots = await first.get();

      if (documentSnapshots.docs.isEmpty) {
        paginatorInfo.lastPage = paginatorInfo.currentPage;
        users = [];
        loading = false;
        return users;
      }

      users = List.from(
        documentSnapshots.docs.map(
          (e) => model.User.fromJson(
            e.data(),
          ),
        ),
      );

      lastDocument = documentSnapshots.docs.last;
      firstDocument = documentSnapshots.docs.first;

      paginatorInfo.currentPage = 1;
      paginatorInfo.lastPage = (paginatorInfo.currentPage ?? 1) + 1;

      loading = false;

      return users;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    } catch (_) {}
    return null;
  }

  Future<List<model.User>?> fetchNextPage({
    Function(String)? onError,
  }) async {
    if (lastDocument == null) return users;
    try {
      final next = db
          .collection("suppliers")
          .orderBy("names")
          .startAfterDocument(lastDocument!)
          .limit(paginatorInfo.perPage!);

      final nextDocumentSnapshots = await next.get();

      if (nextDocumentSnapshots.docs.isEmpty) {
        paginatorInfo.lastPage = paginatorInfo.currentPage;
        loading = false;
        return users;
      }

      users = List.from(
        nextDocumentSnapshots.docs.map(
          (e) => model.User.fromJson(
            e.data(),
          ),
        ),
      );

      lastDocument = nextDocumentSnapshots.docs.last;
      firstDocument = nextDocumentSnapshots.docs.first;

      paginatorInfo.currentPage = (paginatorInfo.currentPage ?? 1) + 1;
      paginatorInfo.lastPage = (paginatorInfo.lastPage ?? 1) + 1;

      loading = false;

      return users;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    }
    return users;
  }

  Future<List<model.User>?> fetchPreviosPage({
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
          .collection("suppliers")
          .orderBy("names")
          .endBeforeDocument(firstDocument!)
          .limitToLast(paginatorInfo.perPage!);

      final documentSnapshots = await previous.get();

      users = List.from(
        documentSnapshots.docs.map(
          (e) => model.User.fromJson(
            e.data(),
          ),
        ),
      );

      lastDocument = documentSnapshots.docs.last;
      firstDocument = documentSnapshots.docs.first;

      paginatorInfo.currentPage =
          (paginatorInfo.currentPage ?? 1) - 1; // Actualizar la página actual
      paginatorInfo.lastPage = (paginatorInfo.currentPage ?? 1) + 1;

      loading = false;
      return users;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    } catch (_) {}
    return null;
  }

  Future<bool> create({
    required Map<String, dynamic> data,
    Function(String)? onError,
  }) async {
    loading = true;
    try {
      DocumentReference clientsRef = db.collection('suppliers').doc();

      String uid = clientsRef.id;

      data['uid'] = uid;
      data['created_at'] = DateTime.now().toString();

      await clientsRef.set(data);

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
    Function(String)? onError,
  }) async {
    if (data.isEmpty) return true;
    loading = true;
    try {
      await db.collection('suppliers').doc(uid).update(data);

      await obtenerLista(onError: onError);

      loading = false;

      return true;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    }
    loading = false;
    return false;
  }
}
