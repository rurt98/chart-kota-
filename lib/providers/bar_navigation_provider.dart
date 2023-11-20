import 'package:flutter/material.dart';

class BarNavigationProvider extends ChangeNotifier {
  final drawerDuration = const Duration(milliseconds: 150);

  // Esta variable sirve para hacer un delayed al par de milliseconds de drawerDuration
  bool _expanded = false;
  bool get expanded => _expanded;
  set expanded(bool valor) {
    Future.delayed(drawerDuration, () {
      _expanded = valor;
      notifyListeners();
    });
  }

  bool _barExpanded = false;
  bool get barExpanded => _barExpanded;
  set barExpanded(bool valor) {
    expanded = valor;
    _barExpanded = valor;
    notifyListeners();
  }
}
