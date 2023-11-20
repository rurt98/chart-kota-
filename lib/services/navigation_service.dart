import 'package:flutter/material.dart';

class NavigationService {
  static final _instance = NavigationService._();
  factory NavigationService() => _instance;
  NavigationService._();

  static GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> shellNavigatorKeyAuth =
      GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> shellNavigatorKeyDashboard =
      GlobalKey<NavigatorState>();
}
