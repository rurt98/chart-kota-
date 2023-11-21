import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_data_table/custom_data_table.dart';
import 'package:final_project_ba_char/models/vat.dart';
import 'package:final_project_ba_char/providers/auth_provider.dart' as provider;
import 'package:final_project_ba_char/providers/db_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VatProvider with ChangeNotifier {
  final DBProvider dbProvider;
  final provider.AuthProvider authProvider;

  FirebaseFirestore get db => dbProvider.db;
  FirebaseAuth get auth => authProvider.auth;

  VatProvider(this.dbProvider, this.authProvider);

  Vat? vat;
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

  Future<Vat?> obtenerLista({
    Function(String)? onError,
  }) async {
    loading = true;
    try {
      paginatorInfo.lastPage = 1;
      final first = db.collection("vats").orderBy("vat").limit(1);

      final documentSnapshots = await first.get();

      if (documentSnapshots.docs.isEmpty) {
        loading = false;
        return vat;
      }

      vat = Vat.fromJson(documentSnapshots.docs.first.data());

      loading = false;

      return vat;
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
      DocumentReference clientsRef = db.collection('vats').doc();

      String uid = clientsRef.id;

      final date = DateTime.now().toString();

      data['uid'] = uid;
      data['created_at'] = date;
      data['updated_at'] = date;

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
    required Vat newVat,
    required Vat lastVat,
    Function(String)? onError,
  }) async {
    loading = true;
    try {
      final date = DateTime.now();

      lastVat.history = null;

      newVat.history ??= [];

      newVat.history!.add(lastVat);

      newVat.createdAt = date;
      newVat.updatedAt = date;

      final data = newVat.toJson();

      await db.collection('vats').doc(lastVat.uid).update(data);

      await obtenerLista(onError: onError);

      loading = false;

      return true;
    } on FirebaseException catch (e) {
      onError?.call(e.code);
    } catch (_) {}
    loading = false;
    return false;
  }
}
