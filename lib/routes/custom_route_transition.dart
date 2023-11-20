import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router/src/pages/custom_transition_page.dart';

class CustomFadeTransitionPage extends CustomTransitionPage {
  CustomFadeTransitionPage({required LocalKey key, required Widget child})
      : super(
          key: key,
          child: child,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
}
