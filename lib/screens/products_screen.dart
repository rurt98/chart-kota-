import 'package:custom_data_table/custom_data_table.dart';
import 'package:final_project_ba_char/models/product.dart';
import 'package:final_project_ba_char/models/user.dart';

import 'package:final_project_ba_char/providers/products_provider.dart';
import 'package:final_project_ba_char/styles/styles.dart';
import 'package:final_project_ba_char/templates/formulario_template.dart';
import 'package:final_project_ba_char/templates/page_template.dart';
import 'package:final_project_ba_char/utilities/forms_utils.dart';
import 'package:final_project_ba_char/utilities/map_string_dynamic_extensions.dart';
import 'package:final_project_ba_char/utilities/show_dialog.dart';
import 'package:final_project_ba_char/utilities/show_snackbar.dart';
import 'package:final_project_ba_char/utilities/string_extension.dart';
import 'package:final_project_ba_char/widgets/actions_buttons_widget.dart';
import 'package:final_project_ba_char/widgets/custom_error.dart';
import 'package:final_project_ba_char/widgets/page_loading_absorb_pointer.dart';
import 'package:final_project_ba_char/widgets/search_supplier_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late ProductsProvider provider;

  @override
  void initState() {
    provider = context.read<ProductsProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      provider.obtenerLista(
        onError: (e) => ShowSnackBar.showError(context, message: e),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      showTitle: true,
      withSizedBoxInTitle: false,
      actions: [
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Agregar'),
          onPressed: () => ShowDialog.showSimpleRightDialog(
            context,
            child: const FormProductWidget(),
          ),
        ),
      ],
      child: Selector<ProductsProvider, (bool, PaginatorInfo, List<Product>?)>(
        selector: (_, provider) =>
            (provider.loading, provider.paginatorInfo, provider.products),
        shouldRebuild: (previous, next) => true,
        builder: (context, values, child) {
          final obteniendo = values.$1;
          final paginatorInfo = values.$2;
          final products = values.$3;

          if (products == null && obteniendo) {
            return const Center(child: CircularProgressIndicator());
          } else if (products == null && !obteniendo) {
            return const Center(child: CustomError());
          }

          return PageLoadingAbsorbPointer(
            isLoading: obteniendo,
            child: CustomDataTable<Product>(
              dataTableTheme: dataTableTheme,
              data: products!,
              columns: [
                ColumnInfo(
                  name: 'Acciones',
                  key: 'actions',
                  width: 100,
                ),
                ColumnInfo(
                  name: 'Código de barras',
                  key: 'barcode',
                  flex: 1,
                  width: 300,
                ),
                ColumnInfo(
                  name: 'Nombre',
                  key: 'name',
                  flex: 1,
                  width: 300,
                ),
                ColumnInfo(
                  name: 'Descripción',
                  key: 'description',
                  flex: 2,
                  width: 300,
                ),
                ColumnInfo(
                  name: 'Precio',
                  key: 'price',
                  width: 250,
                ),
                ColumnInfo(
                  name: 'Stock',
                  key: 'stock',
                  width: 250,
                ),
                ColumnInfo(
                  name: 'Fecha de registro',
                  key: 'created_at',
                  width: 300,
                ),
                ColumnInfo(
                  name: 'Fecha de ultima actualización',
                  key: 'updated_at',
                  width: 300,
                ),
                ColumnInfo(
                  name: 'Proveedor',
                  key: 'supplier',
                  width: 250,
                ),
              ],
              toMap: (element) => element.toDataTable(),
              paginatorInfo: paginatorInfo,
              onNextPage: () => provider.fetchNextPage(),
              onPreviousPage: () => provider.fetchPreviosPage(),
              cell: (element, map, key) {
                if (key == 'actions') {
                  return Align(
                    alignment: Alignment.bottomLeft,
                    child: ActionButtonsWidget(
                      onPressedEdit: () => ShowDialog.showSimpleRightDialog(
                        context,
                        child: FormProductWidget(
                          product: element,
                        ),
                      ),
                    ),
                  );
                }

                return null;
              },
            ),
          );
        },
      ),
    );
  }
}

class FormProductWidget extends StatefulWidget {
  final Product? product;
  final Function(Product)? onPressed;

  const FormProductWidget({
    super.key,
    this.product,
    this.onPressed,
  });

  @override
  FormProductWidgetState createState() => FormProductWidgetState();
}

class FormProductWidgetState extends State<FormProductWidget> {
  ScrollController scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  late bool edit;
  late Product product;
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);

  @override
  void initState() {
    edit = widget.product != null;
    product = widget.product?.copyWith() ??
        Product(
          supplier: User(),
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _loading,
      builder: (BuildContext context, bool isLoading, Widget? child) {
        return FormTemplate(
          scrollController: scrollController,
          loading: isLoading,
          titulo: "${edit ? "Editar" : "Nuevo"} producto",
          onPressSave: _onPressSave,
          formKey: _formKey,
          onBack: () {
            if (!edit && product.toJson().isNotEmpty) {
              return false;
            } else if (!edit) {
              return true;
            }

            return widget.product?.name == product.name;
          },
          body: Column(
            children: [
              Forms.textField(
                hintText: "Nombre",
                labelText: "Nombre",
                isRequired: true,
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validators: (value) => value?.validatorLeesThan255,
              ),
              SizedBox(
                height: 300,
                child: Forms.textFieldExpanded(
                  labelText: "Descripción",
                  isRequired: true,
                  initialValue: product.description,
                  onChanged: (value) => product.description = value,
                  validators: (value) => value?.validatorLeesThan255,
                ),
              ),
              Forms.textField(
                hintText: "Stock",
                labelText: "Stock",
                isRequired: true,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]'),
                  ),
                ],
                initialValue: product.stock?.toString(),
                onChanged: (value) => product.stock = int.tryParse(value),
                validators: (value) => value?.validatorLeesThan255,
              ),
              if (widget.onPressed != null)
                Forms.textField(
                  hintText: "Precio de compra",
                  labelText: "Precio de compra",
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9.]'),
                    ),
                  ],
                  initialValue: product.purchasePrice?.toString(),
                  onChanged: (value) =>
                      product.purchasePrice = double.tryParse(value),
                  validators: (value) => value?.validatorLeesThan255,
                ),
              Forms.textField(
                hintText: "Precio de venta",
                labelText: "Precio de venta",
                isRequired: true,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9.]'),
                  ),
                ],
                initialValue: product.price?.toString(),
                onChanged: (value) => product.price = double.tryParse(value),
                validators: (value) => value?.validatorLeesThan255,
              ),
              if (widget.onPressed == null)
                StatefulBuilder(
                  builder: (_, setState) {
                    return SearchSupplier(
                      userSelected: product.supplier,
                      label: 'Proveedor (Buscar por nombres)',
                      onSelected: (v) => setState(() => product.supplier = v),
                      bottomPadding: 300,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future _onPressSave() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() != true) return;

    _formKey.currentState?.save();

    if (widget.onPressed != null) {
      widget.onPressed!.call(product);
      context.pop();
      return;
    }

    _loading.value = true;

    bool successful = false;

    if (edit) {
      successful = await context.read<ProductsProvider>().edit(
            supplierId: product.supplier!.uid!,
            data: product.toJson().differences(widget.product!.toJson()),
            uid: widget.product!.uid!,
            onError: (e) => ShowSnackBar.showError(context, message: e),
          );
    } else {
      successful = await context.read<ProductsProvider>().create(
            supplierId: product.supplier!.uid!,
            data: product.toJson(),
            onError: (e) => ShowSnackBar.showError(context, message: e),
          );
    }

    _loading.value = false;

    if (!successful) return;
    if (!mounted) return;

    context.pop();

    ShowSnackBar.showSuccessful(context);
  }
}
