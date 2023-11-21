import 'package:final_project_ba_char/models/product.dart';
import 'package:final_project_ba_char/providers/products_provider.dart';
import 'package:final_project_ba_char/utilities/show_snackbar.dart';
import 'package:final_project_ba_char/widgets/custom_auto_complete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchProductsWidget extends StatelessWidget {
  final Product? productSelected;
  final void Function(Product) onSelected;
  final bool isRequired;
  final String label;
  final List<String>? productsSelected;
  final double bottomPadding;

  const SearchProductsWidget({
    super.key,
    this.productSelected,
    required this.onSelected,
    this.isRequired = true,
    this.productsSelected,
    required this.label,
    required this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: CustomAutoComplete<Product>(
        initialValue: productSelected,
        onChanged: (p0) {},
        isRequired: isRequired,
        label: label,
        optionsBuilder: (textEditingValue) async {
          final products = await context.read<ProductsProvider>().search(
                barcode: textEditingValue.text,
                onError: (e) => ShowSnackBar.showError(context, message: e),
              );

          if (productsSelected != null) {
            products.removeWhere(
                (e) => productsSelected!.any((element) => element == e.uid));
          }

          return products;
        },
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Buscar producto',
        ),
        validator: (v) {
          if (isRequired != true) return null;
          if (productSelected?.uid == null || v == null || v.isEmpty) {
            return "Campo requerido";
          }

          return null;
        },
        onSelected: onSelected,
      ),
    );
  }
}
