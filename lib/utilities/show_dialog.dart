import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

abstract class ShowDialog {
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    String? txtCancelar,
    String? txtAceptar,
    Widget? content,
    bool scrollable = false,
    bool barrierDismissible = false,
  }) async =>
      showDialog<bool?>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(title),
            content: content,
            scrollable: scrollable,
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(txtCancelar ?? 'Cancelar'),
              ),
              TextButton(
                onPressed: () async => Navigator.of(context).pop(true),
                child: Text(txtAceptar ?? 'Aceptar'),
              )
            ],
          );
        },
      );

  static Future showInfoDialog(
    BuildContext context, {
    required String title,
    Widget? content,
    bool scrollable = true,
    List<Widget>? extraActions,
  }) async =>
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: scrollable,
            title: Text(title),
            content: content,
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cerrar'),
                  ),
                  if (extraActions != null) ...extraActions,
                ],
              ),
            ],
          );
        },
      );

  static Future showSuccessfulAction(
    BuildContext context, {
    required String title,
  }) async =>
      showDialog<bool?>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            scrollable: true,
            content: Column(
              children: [
                Center(
                  child: Lottie.asset('assets/lotties/success.json',
                      width: 200, frameRate: FrameRate(60), repeat: false),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const SizedBox(
                      width: 200,
                      child: Center(
                        child: Text('Aceptar'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

  static Future<T?> showSimpleRightDialog<T extends Object?>(
    BuildContext context, {
    required Widget child,
    AlignmentGeometry? alignment,
    double? width,
    Color? barrierColor,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierColor:
          barrierColor ?? Colors.black12.withOpacity(0.4), // background color
      barrierDismissible:
          barrierDismissible, // should dialog be dismissed when tapped outside
      barrierLabel: "Dialog", // label for barrier
      transitionDuration: const Duration(
        milliseconds: 400,
      ), // how long it takes to popup dialog after button click
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: alignment ?? Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(left: 50),
            child: SizedBox(
              width: width ?? 550,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<T?> showPopUpDialog<T extends Object?>(
      BuildContext context, Widget child,
      {bool barrier = true}) {
    return showGeneralDialog<T>(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.7), // background color
      barrierDismissible:
          barrier, // should dialog be dismissed when tapped outside
      barrierLabel: "Dialog", // label for barrier
      transitionDuration: const Duration(
        milliseconds: 200,
      ), // how long it takes to popup dialog after button click
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (_, __, ___) {
        return child;
      },
    );
  }
}
