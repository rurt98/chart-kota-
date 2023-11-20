// ignore_for_file: use_build_context_synchronously
import 'package:collection/collection.dart';

import 'package:final_project_ba_char/enum/enum_auth_status.dart';
import 'package:final_project_ba_char/enum/pages.dart';
import 'package:final_project_ba_char/layout/auth_layout.dart';
import 'package:final_project_ba_char/layout/dashboard_layout.dart';
import 'package:final_project_ba_char/providers/auth_provider.dart';
import 'package:final_project_ba_char/routes/custom_route_transition.dart';
import 'package:final_project_ba_char/routes/routes.dart';
import 'package:final_project_ba_char/screens/purchases_screen.dart';
import 'package:final_project_ba_char/screens/home_screen_BS.dart';
import 'package:final_project_ba_char/screens/login_screen.dart';
import 'package:final_project_ba_char/screens/no_page_found.dart';
import 'package:final_project_ba_char/screens/operators_screen.dart';
import 'package:final_project_ba_char/screens/products_screen.dart';
import 'package:final_project_ba_char/screens/suppliers_screen.dart';
import 'package:final_project_ba_char/screens/sales_screen.dart';
import 'package:final_project_ba_char/screens/vat_screen.dart';
import 'package:final_project_ba_char/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

abstract class AppRouter {
  static GoRouter get goRouter => GoRouter(
        routes: [
          GoRoute(
            path: Routes.rootRoute,
            builder: (context, state) => const SizedBox(),
            redirect: (context, state) async {
              final authStatus =
                  await context.read<AuthProvider>().isLoggedIn();

              if (authStatus == AuthStatus.authenticated) {
                return PageMenu.home.route;
              }

              if (authStatus == AuthStatus.notAuthenticated) {
                return Routes.loginRoute;
              }

              return null;
            },
          ),
          GoRoute(
            path: Routes.loginRoute,
            pageBuilder: (context, state) => CustomFadeTransitionPage(
              key: state.pageKey,
              child: const AuthLayout(child: LoginScreen()),
            ),
            redirect: (context, state) async {
              final authStatus =
                  await context.read<AuthProvider>().isLoggedIn();

              if (authStatus == AuthStatus.authenticated) {
                return Routes.homeRoute;
              }

              return null;
            },
          ),
          ShellRoute(
            navigatorKey: NavigationService.shellNavigatorKeyDashboard,
            builder: (context, state, child) {
              final currentRoute = PageMenu.values.firstWhereOrNull(
                  (element) => element.route == state.fullPath);

              // Se agrega el delay para asegurar que ya se haya direccionado a
              // la página que se va a mostrar. Esto para evitar que se le cambie
              // el nombre a a la página actual.

              Future.delayed(
                const Duration(seconds: 1),
                () => SystemChrome.setApplicationSwitcherDescription(
                  ApplicationSwitcherDescription(
                    label: currentRoute?.title ?? '',
                    primaryColor: Colors.white.value,
                  ),
                ),
              );

              return Selector<AuthProvider, AuthStatus>(
                selector: (_, provider) => provider.authStatus,
                builder: (context, value, _) {
                  if (value != AuthStatus.authenticated) {
                    context.go(Routes.rootRoute);
                    return const AuthLayout(child: LoginScreen());
                  }

                  return DashboardLayout(
                    currentPage: currentRoute,
                    child: child,
                  );
                },
              );
            },
            routes: [
              ...dashboard,
            ],
          ),
        ],
        errorPageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const NoPageFound(),
        ),
      );

  static final List<RouteBase> dashboard = [
    GoRoute(
      path: PageMenu.home.route,
      redirect: _authRedirect,
      pageBuilder: (context, state) {
        return CustomFadeTransitionPage(
          key: state.pageKey,
          child: const HomeScreenBS(),
        );
      },
    ),
    GoRoute(
      path: PageMenu.sales.route,
      redirect: _authRedirect,
      pageBuilder: (context, state) {
        return CustomFadeTransitionPage(
          key: state.pageKey,
          child: const SalesScreen(),
        );
      },
    ),
    GoRoute(
      path: PageMenu.purchases.route,
      redirect: _authRedirect,
      pageBuilder: (context, state) {
        return CustomFadeTransitionPage(
          key: state.pageKey,
          child: const PurchasesScreen(),
        );
      },
    ),
    GoRoute(
      path: PageMenu.products.route,
      redirect: _authRedirect,
      pageBuilder: (context, state) {
        return CustomFadeTransitionPage(
          key: state.pageKey,
          child: const ProductsScreen(),
        );
      },
    ),
    GoRoute(
      path: PageMenu.operators.route,
      redirect: _authRedirect,
      pageBuilder: (context, state) {
        return CustomFadeTransitionPage(
          key: state.pageKey,
          child: const OperatorsScreen(),
        );
      },
    ),
    GoRoute(
      path: PageMenu.suppliers.route,
      redirect: _authRedirect,
      pageBuilder: (context, state) {
        return CustomFadeTransitionPage(
          key: state.pageKey,
          child: const SuppliersScreen(),
        );
      },
    ),
    GoRoute(
      path: PageMenu.vat.route,
      redirect: _authRedirect,
      pageBuilder: (context, state) {
        return CustomFadeTransitionPage(
          key: state.pageKey,
          child: const VatScreen(),
        );
      },
    ),
  ];

  static Future<String?> _authRedirect(
      BuildContext context, GoRouterState state) async {
    final authStatus = await context.read<AuthProvider>().isLoggedIn();

    if (authStatus == AuthStatus.authenticated) {
      return null;
    }

    if (authStatus == AuthStatus.notAuthenticated) {
      return Routes.loginRoute;
    }

    return null;
  }
}
