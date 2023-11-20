import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_ba_char/enum/enum_auth_status.dart';
import 'package:final_project_ba_char/providers/db_provider.dart';
import 'package:final_project_ba_char/utilities/show_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project_ba_char/models/user.dart' as model;

class AuthProvider with ChangeNotifier {
  AuthStatus authStatus = AuthStatus.checking;
  final FirebaseAuth auth = FirebaseAuth.instance;

  model.User? user;

  final DBProvider dbProvider;

  FirebaseFirestore get db => dbProvider.db;

  AuthProvider(this.dbProvider);

  bool get loading => _isLoading;
  bool _isLoading = false;

  set loading(bool valor) {
    _isLoading = valor;
    notifyListeners();
  }

  Future<AuthStatus> isLoggedIn() async {
    if (authStatus != AuthStatus.checking) return authStatus;

    try {
      auth.authStateChanges().listen((User? res) async {
        if (res == null) {
          await clearSession();
          return;
        }

        if (authStatus == AuthStatus.authenticated && user != null) return;

        user = await getUserAdditionalData(res.uid);

        authStatus = AuthStatus.authenticated;
        notifyListeners();
      });
    } catch (_) {}
    await Future.delayed(const Duration(milliseconds: 700));
    return authStatus;
  }

  Future<bool> login({
    required String email,
    required String password,
    Function(String)? onError,
  }) async {
    loading = true;
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      authStatus = AuthStatus.authenticated;
      loading = false;
      return true;
    } on FirebaseAuthException catch (e) {
      onError?.call(e.code);
    }
    loading = false;
    return false;
  }

  Future logout(
    BuildContext context, {
    Function()? onError,
  }) async {
    try {
      final res = await ShowDialog.showConfirmDialog(
        context,
        title: '¿Estas seguro de cerrar sesión?',
      );

      if (res != true) return;

      loading = true;

      await auth.signOut();

      loading = false;

      return;
    } catch (e) {
      onError?.call();
    }

    loading = false;
  }

  Future<void> clearSession() async {
    user = null;

    if (authStatus == AuthStatus.notAuthenticated) return;
    await Future.delayed(const Duration(milliseconds: 550));

    authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
  }

  Future<model.User?> getUserAdditionalData(String uid) async {
    try {
      final DocumentSnapshot userDoc =
          await db.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return model.User.fromJson(userDoc.data() as Map<String, dynamic>);
      }

      clearSession();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
    return null;
  }

  // Future<bool> editar(
  //   Map<String, dynamic> data, {
  //   Function(DioException e)? onError,
  //   required String id,
  // }) async {
  //   if (data.isEmpty) return true;
  //   try {
  //     loading = true;
  //     await httpService.dio.put(
  //       endpoint,
  //       data: data,
  //     );

  //     await _getUser();

  //     loading = false;

  //     return true;
  //   } on DioException catch (e) {
  //     onError?.call(e);
  //   } catch (_) {}

  //   loading = false;
  //   return false;
  // }

  // Future<types.User?> _getUser() async {
  //   try {
  //     final result = await GraphQLBaseHelperService.getData(
  //       document: MeQueries.getMe,
  //       client: httpService.client,
  //     );

  //     if (result == null || result['me'] == null) {
  //       clearSession();
  //       return null;
  //     }

  //     user = types.User.fromJson(result['me']);

  //     notifyListeners();

  //     return user;
  //   } on OperationException catch (_) {
  //   } catch (_) {}

  //   clearSession();
  //   return null;
  // }

  // Future<bool> changePassword({
  //   required Map<String, dynamic> body,
  //   Function(DioException e)? onError,
  // }) async {
  //   loading = true;
  //   try {
  //     await httpService.dio.put(
  //       endpoint,
  //       data: body,
  //     );

  //     loading = false;
  //     return true;
  //   } on DioException catch (e) {
  //     onError?.call(e);
  //   } catch (_) {}
  //   loading = false;
  //   return false;
  // }

  // Future connectWs(BuildContext context) async {
  //   if (user!.getRole.wsChannel == null) return;

  //   final channel = user?.isAdmin == true
  //       ? user!.getRole.wsChannel!
  //       : user!.getRole.wsChannel!.replaceAll('{id}', user!.id);

  //   WsUserService service = WsUserService.getInstance(channel: channel);

  //   service.connectSocket(context);
  // }

  // Future disconnectWs() async {
  //   WsUserService? service = WsUserService.instance;

  //   service?.closeSocket();
  // }

  // void saveTokenInDio(String token) => httpService.setToken(token);

  // void removeTokenInDio() => httpService.removeToken();

  // Future<void> clearSession() async {
  //   await _removeToken();

  //   await _removeTokenRecaptcha();

  //   removeTokenInDio();

  //   user = null;

  //   if (authStatus == AuthStatus.notAuthenticated) return;

  //   authStatus = AuthStatus.notAuthenticated;
  //   notifyListeners();
  // }

  // // SessionsController
  // // Future<String?> _getToken() async => await SessionsController.getToken();
  // // void _saveToken(String token) => SessionsController.put("token", token);
  // // Future _removeToken() async => await SessionsController.delete("token");

  // // SharePreferences
  // Future<String?> _getToken() async =>
  //     LocalStorage.prefs.getString("token_sembrador");
  // void _saveToken(String token) =>
  //     LocalStorage.prefs.setString("token_sembrador", token);
  // Future _removeToken() async => LocalStorage.prefs.remove("token_sembrador");

  // Future _removeTokenRecaptcha() async =>
  //     LocalStorage.prefs.remove("token_recaptcha");
}
