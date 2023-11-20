import 'package:final_project_ba_char/routes/routes.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

enum PageMenu {
  home(
    'Home',
    Icons.home_outlined,
    Icons.home,
    Routes.home,
  ),
  routes(
    'Rutas',
    Icons.alt_route_outlined,
    Icons.alt_route,
    Routes.routes,
  ),
  clients(
    'Clientes',
    Icons.groups_outlined,
    Icons.groups,
    Routes.clients,
  ),
  packages(
    'Paquetes',
    Icons.inventory_outlined,
    Icons.inventory,
    Routes.packages,
  ),
  rates(
    'Tarifas',
    Icons.paid_outlined,
    Icons.paid,
    Routes.rates,
  ),
  operators(
    'Operadores',
    Icons.group,
    Icons.group,
    Routes.operators,
  ),
  vehicles(
    'Vehículos',
    Icons.local_shipping_outlined,
    Icons.local_shipping,
    Routes.vehicles,
  );

  final String title;
  final IconData iconOutlined;
  final IconData icon;
  final String route;

  const PageMenu(this.title, this.iconOutlined, this.icon, this.route);
}

extension PageMenuExtension on PageMenu {
  static List<PageMenu> get navigationBarrancoSoft => [
        PageMenu.home,
        PageMenu.routes,
        PageMenu.clients,
        PageMenu.packages,
        PageMenu.rates,
        PageMenu.operators,
        PageMenu.vehicles,
      ];

  PageMenu? get baseRoute => PageMenu.values.firstWhereOrNull(
      (element) => element == this || route.startsWith(element.route));
}
