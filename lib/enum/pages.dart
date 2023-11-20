import 'package:final_project_ba_char/routes/routes.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

enum PageMenu {
  home(
    'Home',
    Icons.home_outlined,
    Icons.home,
    Routes.homeRoute,
  ),
  sales(
    'Ventas',
    Icons.alt_route_outlined,
    Icons.alt_route,
    Routes.salesRoute,
  ),
  purchases(
    'Compras',
    Icons.groups_outlined,
    Icons.groups,
    Routes.purchasesRoute,
  ),
  products(
    'Productos',
    Icons.inventory_outlined,
    Icons.inventory,
    Routes.productsRoute,
  ),
  operators(
    'Operadores',
    Icons.group,
    Icons.group,
    Routes.suppliersRoute,
  ),
  suppliers(
    'Proveedores',
    Icons.paid_outlined,
    Icons.paid,
    Routes.operatorsRoute,
  ),
  vat(
    'IVA',
    Icons.local_shipping_outlined,
    Icons.local_shipping,
    Routes.vatRoute,
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
        PageMenu.sales,
        PageMenu.purchases,
        PageMenu.products,
        PageMenu.operators,
        PageMenu.suppliers,
        PageMenu.vat,
      ];

  PageMenu? get baseRoute => PageMenu.values.firstWhereOrNull(
      (element) => element == this || route.startsWith(element.route));
}
