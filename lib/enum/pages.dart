import 'package:final_project_ba_char/routes/routes.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

enum PageMenu {
  sales(
    'Ventas',
    Icons.shopping_cart_outlined,
    Icons.shopping_cart,
    Routes.salesRoute,
  ),
  purchases(
    'Compras',
    Icons.add_shopping_cart_outlined,
    Icons.add_shopping_cart,
    Routes.purchasesRoute,
  ),
  products(
    'Productos',
    Icons.inventory_2_outlined,
    Icons.inventory_2,
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
    Icons.supervisor_account_outlined,
    Icons.supervisor_account,
    Routes.operatorsRoute,
  ),
  vat(
    'IVA',
    Icons.percent_outlined,
    Icons.percent,
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
