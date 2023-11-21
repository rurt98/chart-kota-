import 'package:custom_data_table/custom_data_table.dart';
import 'package:final_project_ba_char/models/vat.dart';
import 'package:final_project_ba_char/providers/vat_provider.dart';
import 'package:final_project_ba_char/styles/styles.dart';
import 'package:final_project_ba_char/templates/formulario_template.dart';
import 'package:final_project_ba_char/templates/page_template.dart';
import 'package:final_project_ba_char/utilities/forms_utils.dart';
import 'package:final_project_ba_char/utilities/show_dialog.dart';
import 'package:final_project_ba_char/utilities/show_snackbar.dart';
import 'package:final_project_ba_char/utilities/string_extension.dart';
import 'package:final_project_ba_char/widgets/actions_buttons_widget.dart';
import 'package:final_project_ba_char/widgets/custom_error.dart';
import 'package:final_project_ba_char/widgets/page_loading_absorb_pointer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class VatScreen extends StatefulWidget {
  const VatScreen({super.key});

  @override
  State<VatScreen> createState() => _VatScreenState();
}

class _VatScreenState extends State<VatScreen> {
  late VatProvider provider;

  @override
  void initState() {
    provider = context.read<VatProvider>();
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
      child: Selector<VatProvider, (bool, PaginatorInfo, Vat?)>(
        selector: (_, provider) =>
            (provider.loading, provider.paginatorInfo, provider.vat),
        shouldRebuild: (previous, next) => true,
        builder: (context, values, child) {
          final obteniendo = values.$1;
          final paginatorInfo = values.$2;
          final vat = values.$3;

          if (vat == null && obteniendo) {
            return const Center(child: CircularProgressIndicator());
          } else if (vat == null && !obteniendo) {
            return const Center(child: CustomError());
          }

          return PageLoadingAbsorbPointer(
            isLoading: obteniendo,
            child: CustomDataTable<Vat>(
              dataTableTheme: dataTableTheme,
              data: [
                vat!,
                if (vat.history?.isNotEmpty == true) ...vat.history!
              ],
              columns: [
                ColumnInfo(
                  name: 'Acciones',
                  key: 'actions',
                  width: 100,
                ),
                ColumnInfo(
                  name: 'Iva',
                  key: 'vat',
                  flex: 1,
                  width: 300,
                ),
                ColumnInfo(
                  name: 'Fecha de actualización',
                  key: 'updated_at',
                  width: 300,
                ),
              ],
              toMap: (element) => element.toDataTable(),
              paginatorInfo: paginatorInfo,
              onNextPage: () {},
              onPreviousPage: () {},
              cell: (element, map, key) {
                if (key == 'actions') {
                  if (!(element.father ?? false)) return const SizedBox();
                  return Align(
                    alignment: Alignment.bottomLeft,
                    child: ActionButtonsWidget(
                      onPressedEdit: () => ShowDialog.showSimpleRightDialog(
                        context,
                        child: FormVatScreen(
                          vat: element,
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

class FormVatScreen extends StatefulWidget {
  final Vat vat;

  const FormVatScreen({super.key, required this.vat});

  @override
  FormVatScreenState createState() => FormVatScreenState();
}

class FormVatScreenState extends State<FormVatScreen> {
  ScrollController scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  late Vat vat;
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);

  @override
  void initState() {
    vat = widget.vat.copyWith();

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
          titulo: "Editar iva",
          onPressSave: _onPressSave,
          formKey: _formKey,
          onBack: () => widget.vat.vat == vat.vat,
          body: Column(
            children: [
              Forms.textField(
                hintText: "IVA",
                labelText: "IVA %",
                isRequired: true,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9.]'),
                  ),
                ],
                initialValue: vat.vat?.toString(),
                onChanged: (value) => vat.vat = int.tryParse(value),
                validators: (value) => value?.validatorLeesThan255,
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

    _loading.value = true;

    final successful = await context.read<VatProvider>().edit(
          newVat: vat,
          lastVat: widget.vat,
          onError: (e) => ShowSnackBar.showError(context, message: e),
        );

    _loading.value = false;

    if (!successful) return;
    if (!mounted) return;

    context.pop();

    ShowSnackBar.showSuccessful(context);
  }
}
