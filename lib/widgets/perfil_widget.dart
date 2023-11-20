import 'package:final_project_ba_char/models/user.dart';
import 'package:final_project_ba_char/providers/auth_provider.dart';
import 'package:final_project_ba_char/styles/colors.dart';
import 'package:final_project_ba_char/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

class PerfilWidget extends StatefulWidget {
  const PerfilWidget({super.key});

  @override
  State<PerfilWidget> createState() => _PerfilWidgetState();
}

class _PerfilWidgetState extends State<PerfilWidget> {
  final showPassword = ValueNotifier<bool>(false);
  final changePassword = ValueNotifier<bool>(false);

  String newPassword = "";
  String passwordConfirmation = "";

  @override
  Widget build(BuildContext context) {
    return Selector<AuthProvider, (bool, User?)>(
      shouldRebuild: (previous, next) => true,
      selector: (_, provider) => (provider.loading, provider.user),
      builder: (context, items, child) {
        final loading = items.$1;
        final user = items.$2;

        return Container(
          decoration: context.cardDecoration.copyWith(color: cardColor),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 70,
                  color: darkGreyApp,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(user?.toString() ?? 'Usuario',
                  style: Theme.of(context).textTheme.titleSmall),
              Text(
                user?.email ?? '',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.grey),
              ),
              Text(
                user?.phoneNumber ?? '',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.grey),
              ),
              const SizedBox(
                height: 15,
              ),
              _buildPerfilOption(
                colors: orangeApp,
                icon: Icons.login_rounded,
                text: 'Cerrar Sesión',
                textColor: Colors.white,
                onPressed: loading
                    ? () {}
                    : () {
                        context.pop();
                        context.read<AuthProvider>().logout(
                          context,
                          onError: () {
                            //  ShowSnackBar.showInternetError(context, e);
                          },
                        );
                      },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPerfilOption({
    required Color textColor,
    required Color colors,
    required Function() onPressed,
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: textColor,
            backgroundColor: colors,
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                ),
                const SizedBox(width: 5),
                Text(text),
              ],
            ),
          )),
    );
  }
}
