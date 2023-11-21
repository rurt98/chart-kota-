import 'package:custom_data_table/custom_data_table.dart';
import 'package:final_project_ba_char/models/product.dart';
import 'package:final_project_ba_char/models/sale.dart';

import 'package:final_project_ba_char/models/vat.dart';
import 'package:final_project_ba_char/providers/sales_provider.dart';
import 'package:final_project_ba_char/providers/vat_provider.dart';
import 'package:final_project_ba_char/styles/colors.dart';

import 'package:final_project_ba_char/styles/styles.dart';
import 'package:final_project_ba_char/templates/page_template.dart';
import 'package:final_project_ba_char/utilities/forms_utils.dart';
import 'package:final_project_ba_char/utilities/show_dialog.dart';
import 'package:final_project_ba_char/utilities/show_snackbar.dart';
import 'package:final_project_ba_char/widgets/custom_error.dart';
import 'package:final_project_ba_char/widgets/page_loading_absorb_pointer.dart';
import 'package:final_project_ba_char/widgets/search_products_widget.dart';
import 'package:final_project_ba_char/widgets/text_count_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  late SalesProvider provider;

  @override
  void initState() {
    provider = context.read<SalesProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      provider.obtenerLista(
        onError: (e) => ShowSnackBar.showError(context, message: e),
      );
      context.read<VatProvider>().obtenerLista(
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
          onPressed: () {
            final folio = provider.generateFolio();

            ShowDialog.showSimpleRightDialog(
              context,
              child: FormSaleWidget(
                sale: Sale(
                  folio: folio,
                  products: [],
                ),
              ),
            );
          },
        ),
      ],
      child: Selector<SalesProvider, (bool, PaginatorInfo, List<Sale>?)>(
        selector: (_, provider) =>
            (provider.loading, provider.paginatorInfo, provider.sales),
        shouldRebuild: (previous, next) => true,
        builder: (context, values, child) {
          final obteniendo = values.$1;
          final paginatorInfo = values.$2;
          final sales = values.$3;

          if (sales == null && obteniendo) {
            return const Center(child: CircularProgressIndicator());
          } else if (sales == null && !obteniendo) {
            return const Center(child: CustomError());
          }

          return PageLoadingAbsorbPointer(
            isLoading: obteniendo,
            child: CustomDataTable<Sale>(
              dataTableTheme: dataTableTheme,
              data: sales!,
              columns: [
                ColumnInfo(
                  name: 'Folio',
                  key: 'folio',
                  flex: 1,
                  width: 300,
                ),
                ColumnInfo(
                  name: 'Total',
                  key: 'total',
                  width: 250,
                ),
                ColumnInfo(
                  name: 'IVA',
                  key: 'vat',
                  width: 250,
                ),
                ColumnInfo(
                  name: 'Método de pago',
                  key: 'pay_method',
                  width: 250,
                ),
                ColumnInfo(
                  name: 'Fecha',
                  key: 'date',
                  width: 300,
                ),
                ColumnInfo(
                  name: 'Productos',
                  key: 'products',
                  width: 300,
                ),
              ],
              toMap: (element) => element.toDataTable(),
              paginatorInfo: paginatorInfo,
              onNextPage: () => provider.fetchNextPage(),
              onPreviousPage: () => provider.fetchPreviosPage(),
              cell: (element, map, key) {
                if (key == 'products') {
                  return TextCountWidget(
                    hasItems: element.products!.isNotEmpty,
                    txt: element.products?.length.toString() ?? '0',
                    onTap: () => _showProducts(element.products!),
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

  void _showProducts(List<Product> products) => ShowDialog.showPopUpDialog(
        context,
        FractionallySizedBox(
          heightFactor: 0.65,
          widthFactor: 0.90,
          child: ClipRRect(
            borderRadius: borderRadiusCard,
            child: ProductsDataTable(products: products),
          ),
        ),
      );
}

class FormSaleWidget extends StatefulWidget {
  final Sale sale;
  const FormSaleWidget({super.key, required this.sale});

  @override
  FormSaleWidgetState createState() => FormSaleWidgetState();
}

class FormSaleWidgetState extends State<FormSaleWidget> {
  ScrollController scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  late Sale sale;

  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);

  @override
  void initState() {
    sale = widget.sale;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _loading,
      builder: (BuildContext context, bool isLoading, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Nueva venta\nFolio: ${sale.folio ?? '-'}"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Forms.dropdown(
                    context,
                    value: sale.payMethod,
                    labelText: "Método de pago",
                    isRequired: true,
                    onChanged: (v) => sale.payMethod = v,
                    items: PayMethod.values
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.method),
                            ))
                        .toList(),
                  ),
                  SearchProductsWidget(
                    productSelected: null,
                    isRequired: false,
                    label: 'Productos (Buscar por código de barras)',
                    productsSelected:
                        sale.products?.map((e) => e.uid!).toList(),
                    onSelected: (v) {
                      v.quantity = 1;
                      setState(() {
                        sale.products ??= [];
                        sale.products!.add(v);
                      });
                    },
                    bottomPadding: 0,
                  ),
                  Expanded(
                    child: sale.products?.isNotEmpty == true
                        ? ListView.separated(
                            itemCount: sale.products?.length ?? 0,
                            itemBuilder: (BuildContext context, int i) {
                              return _buildProductSelected(sale.products![i]);
                            },
                            separatorBuilder: (_, __) => const Divider(),
                          )
                        : Column(
                            children: [
                              Lottie.asset(
                                'assets/lotties/empty_list.json',
                                width: 200,
                                repeat: true,
                                fit: BoxFit.fitWidth,
                              ),
                              const Text('No hay productos seleccionados'),
                            ],
                          ),
                  ),
                  _buildSummary(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductSelected(Product product) {
    final total = (product.price ?? 0) * (product.quantity ?? 1);
    return Card(
      key: GlobalKey(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () async {
                final res = await ShowDialog.showConfirmDialog(context,
                    title:
                        '¿Seguro que deseas eliminar el producto seleccionado?');

                if (res != true) return;

                sale.products?.removeWhere((e) => e.uid == product.uid);
                setState(() {});
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text("\$${product.price}"),
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: product.quantity! <= 1
                          ? null
                          : () {
                              product.quantity = product.quantity! - 1;

                              setState(() {});
                            },
                      icon: const Icon(Icons.remove),
                    ),
                    Text(product.quantity?.toString() ?? '0'),
                    IconButton(
                      onPressed: product.quantity! >= product.stock!
                          ? null
                          : () {
                              product.quantity = product.quantity! + 1;

                              setState(() {});
                            },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                Text('\$$total')
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Selector<VatProvider, (bool, Vat?)>(
      selector: (_, provider) => (provider.loading, provider.vat),
      shouldRebuild: (previous, next) => true,
      builder: (context, values, child) {
        final obteniendo = values.$1;
        final vat = values.$2;

        if (vat == null && obteniendo) {
          return const Center(child: CircularProgressIndicator());
        } else if (vat == null && !obteniendo) {
          return const Center(child: CustomError());
        }

        final subtotal = _getSubTotal();
        final iva = _getIva(subtotal, vat!.vat!);
        final total = _getTotal(subtotal, iva);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            _buildPayInfo('SUBTOTAL', '\$$subtotal'),
            const Divider(),
            _buildPayInfo('IVA', '\$$iva'),
            const Divider(),
            _buildPayInfo('TOTAL A PAGAR', '\$$total'),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _onPressSave(vat),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Pagar"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  double _getSubTotal() {
    double subtotal = 0.0;

    for (var product in (sale.products ?? <Product>[])) {
      final total = (product.price ?? 0) * (product.quantity ?? 1);
      subtotal = subtotal + total;
    }

    return subtotal;
  }

  double _getIva(double subtotal, int iva) {
    double ivaTem = iva / 100;
    double totalIva = subtotal * ivaTem;

    return double.parse(totalIva.toStringAsFixed(2));
  }

  double _getTotal(double subtotal, double iva) => subtotal + iva;

  Widget _buildPayInfo(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: darkGreyApp),
        ),
        Text(
          price,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }

  Future _onPressSave(Vat vat) async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() != true) return;

    _formKey.currentState?.save();

    if (sale.products?.isNotEmpty != true) {
      ShowSnackBar.showError(
        context,
        message: 'Es necesario agregar productos',
      );
      return;
    }

    _loading.value = true;

    final successful = await context.read<SalesProvider>().create(
          sale: sale,
          vat: vat,
          onError: (e) => ShowSnackBar.showError(context, message: e),
        );

    _loading.value = false;

    if (!successful) return;
    if (!mounted) return;

    context.pop();

    ShowSnackBar.showSuccessful(context);
  }
}

class ProductsDataTable extends StatefulWidget {
  final List<Product> products;
  const ProductsDataTable({
    super.key,
    required this.products,
  });

  @override
  State<ProductsDataTable> createState() => _ProductsDataTableState();
}

class _ProductsDataTableState extends State<ProductsDataTable> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      showTitle: true,
      withSizedBoxInTitle: false,
      child: CustomDataTable<Product>(
        dataTableTheme: dataTableTheme,
        data: widget.products,
        columns: [
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
            flex: 1,
            width: 300,
          ),
          ColumnInfo(
            name: 'Precio',
            key: 'price',
            width: 250,
          ),
          ColumnInfo(
            name: 'Cantidad',
            key: 'quantity',
            width: 250,
          ),
          ColumnInfo(
            name: 'Total',
            key: 'total',
            width: 250,
          ),
        ],
        toMap: (element) => element.toDataTable(),
        paginatorInfo: PaginatorInfo(
          total: 0,
          currentPage: 1,
          lastPage: 1,
          perPage: 15,
        ),
        onNextPage: () {
          // provider.fetchNextPage();
        },
        onPreviousPage: () {
          // provider.fetchPreviosPage();
        },
        cell: (element, map, key) {
          return null;
        },
      ),
    );
  }
}
