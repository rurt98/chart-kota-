import 'package:final_project_ba_char/providers/suppliers_provider.dart';
import 'package:final_project_ba_char/utilities/show_snackbar.dart';
import 'package:final_project_ba_char/widgets/custom_auto_complete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project_ba_char/models/user.dart' as model;

class SearchSupplier extends StatelessWidget {
  final model.User? userSelected;
  final void Function(model.User) onSelected;
  final bool isRequired;
  final String label;
  final double bottomPadding;

  const SearchSupplier({
    super.key,
    this.userSelected,
    required this.onSelected,
    this.isRequired = true,
    required this.label,
    required this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: CustomAutoComplete<model.User>(
        initialValue: userSelected,
        onChanged: (p0) {},
        isRequired: isRequired,
        label: label,
        optionsBuilder: (textEditingValue) async {
          final suppliers = await context.read<SuppliersProvider>().search(
                names: textEditingValue.text,
                onError: (e) => ShowSnackBar.showError(context, message: e),
              );

          return suppliers;
        },
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Buscar proveedor',
        ),
        validator: (v) {
          if (isRequired != true) return null;
          if (userSelected?.uid == null || v == null || v.isEmpty) {
            return "Campo requerido";
          }

          return null;
        },
        onSelected: onSelected,
      ),
    );
  }
}
