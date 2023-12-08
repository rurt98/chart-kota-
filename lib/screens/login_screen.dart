import 'package:final_project_ba_char/enum/pages.dart';
import 'package:final_project_ba_char/utilities/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:final_project_ba_char/helpers/responsive_helpers.dart';
import 'package:final_project_ba_char/providers/auth_provider.dart';
import 'package:final_project_ba_char/utilities/forms_utils.dart';
import 'package:final_project_ba_char/utilities/string_extension.dart';
import 'package:final_project_ba_char/widgets/page_loading_absorb_pointer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _showPassword = ValueNotifier<bool>(false);

  final Map<String, dynamic> bodyLogin = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<AuthProvider, bool>(
        selector: (_, provider) => provider.loading,
        builder: (_, loading, __) {
          return PageLoadingAbsorbPointer(
            isLoading: loading,
            child: _buildForm(),
          );
        },
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (context.screenSize != ScreenSize.large) ...[
                Center(
                  child: Image.asset(
                    'assets/logos/char[Kota].png',
                    width: 200,
                    fit: BoxFit.fitWidth,
                    color: Colors.black,
                  ),
                ),
              ] else ...[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Bienvenido de nuevo',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              const SizedBox(height: 40),
              Forms.textField(
                focusNode: _focusNode1,
                hintText: 'email@ejemplo.com',
                labelText: 'Correo electrónico',
                isRequired: true,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => bodyLogin['email'] = value,
                validators: (value) =>
                    value?.isEmail ?? value?.validatorLeesThan255,
                onFieldSubmitted: (value) {
                  _focusNode1.unfocus();
                  FocusScope.of(context).requestFocus(_focusNode2);
                },
              ),
              const SizedBox(height: 5),
              ValueListenableBuilder<bool>(
                valueListenable: _showPassword,
                builder: (_, showPassword, __) {
                  return TextFormField(
                    focusNode: _focusNode2,
                    onEditingComplete: () {
                      _focusNode2.unfocus();
                      _login();
                    },
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () => _showPassword.value = !showPassword,
                        icon: Icon(showPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                    validator: (value) => value?.validatorLeesThan255,
                    obscureText: !showPassword,
                    onSaved: (v) => bodyLogin['password'] = v ?? "",
                    autofillHints: const <String>[AutofillHints.password],
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: _login,
                child: const SizedBox(
                  height: 55,
                  child: Center(
                    child: Text(
                      'Ingresar',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text('v1.0.2'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() != true) return;

    _formKey.currentState?.save();

    final res = await context.read<AuthProvider>().login(
          email: bodyLogin['email'],
          password: bodyLogin['password'],
          onError: (e) => ShowSnackBar.showError(context, message: e),
        );

    if (res && mounted) context.go(PageMenu.sales.route);
  }
}
