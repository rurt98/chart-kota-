import 'package:custom_data_table/custom_data_table.dart';
import 'package:final_project_ba_char/models/address.dart';
import 'package:final_project_ba_char/models/user.dart';
import 'package:final_project_ba_char/providers/suppliers_provider.dart';
import 'package:final_project_ba_char/styles/styles.dart';
import 'package:final_project_ba_char/templates/formulario_template.dart';
import 'package:final_project_ba_char/templates/page_template.dart';
import 'package:final_project_ba_char/utilities/forms_utils.dart';
import 'package:final_project_ba_char/utilities/show_dialog.dart';
import 'package:final_project_ba_char/utilities/show_snackbar.dart';
import 'package:final_project_ba_char/utilities/string_extension.dart';
import 'package:final_project_ba_char/widgets/actions_buttons_widget.dart';
import 'package:final_project_ba_char/widgets/custom_error.dart';
import 'package:final_project_ba_char/widgets/form_address_widget.dart';
import 'package:final_project_ba_char/widgets/page_loading_absorb_pointer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:final_project_ba_char/utilities/map_string_dynamic_extensions.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  late SuppliersProvider provider;

  @override
  void initState() {
    provider = context.read<SuppliersProvider>();
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
            child: const FormSupplierWidget(),
          ),
        ),
      ],
      child: Selector<SuppliersProvider, (bool, PaginatorInfo, List<User>?)>(
        selector: (_, provider) =>
            (provider.loading, provider.paginatorInfo, provider.users),
        shouldRebuild: (previous, next) => true,
        builder: (context, values, child) {
          final obteniendo = values.$1;
          final paginatorInfo = values.$2;
          final users = values.$3;

          if (users == null && obteniendo) {
            return const Center(child: CircularProgressIndicator());
          } else if (users == null && !obteniendo) {
            return const Center(child: CustomError());
          }

          return PageLoadingAbsorbPointer(
            isLoading: obteniendo,
            child: CustomDataTable<User>(
              dataTableTheme: dataTableTheme,
              data: users!,
              columns: [
                ColumnInfo(
                  name: 'Acciones',
                  key: 'actions',
                  width: 100,
                ),
                ColumnInfo(
                  name: 'Nombres',
                  key: 'names',
                  flex: 1,
                  width: 300,
                ),
                ColumnInfo(
                  name: 'Correo electrónico',
                  key: 'email',
                  width: 300,
                ),
                ColumnInfo(
                  name: 'Teléfono',
                  key: 'phone_number',
                  width: 300,
                ),
                ColumnInfo(
                  name: 'RFC',
                  key: 'rfc',
                  width: 250,
                ),
                ColumnInfo(
                  name: 'Dirección',
                  key: 'address',
                  width: 500,
                  flex: 1,
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
                        child: FormSupplierWidget(
                          user: element,
                        ),
                      ),
                    ),
                  );
                }
                if (key == 'address') {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(element.address?.toString() ?? '-'),
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

class FormSupplierWidget extends StatefulWidget {
  final User? user;

  const FormSupplierWidget({super.key, this.user});

  @override
  FormSupplierWidgetState createState() => FormSupplierWidgetState();
}

class FormSupplierWidgetState extends State<FormSupplierWidget> {
  ScrollController scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  late bool edit;
  late User user;
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);

  @override
  void initState() {
    edit = widget.user != null;
    user = widget.user?.copyWith() ??
        User(
          address: Address(),
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
          titulo: "${edit ? "Editar" : "Nuevo"} proveedor",
          onPressSave: _onPressSave,
          formKey: _formKey,
          onBack: () {
            if (!edit && user.toJson().isNotEmpty) {
              return false;
            } else if (!edit) {
              return true;
            }

            return widget.user == user;
          },
          body: Column(
            children: [
              Forms.textField(
                hintText: "Nombres",
                labelText: "Nombres",
                isRequired: true,
                initialValue: user.names,
                onChanged: (value) => user.names = value,
                validators: (value) => value?.validatorLeesThan255,
              ),
              Forms.textField(
                hintText: "Correo electrónico",
                labelText: "Correo electrónico",
                isRequired: true,
                initialValue: user.email,
                onChanged: (value) => user.email = value,
                validators: (value) => value?.isEmail,
              ),
              Forms.textField(
                labelText: "Teléfono",
                hintText: "Número telefónico",
                isRequired: true,
                keyboardType: TextInputType.number,
                initialValue: user.phoneNumber,
                onChanged: (v) => user.phoneNumber = v,
                inputFormatters: <TextInputFormatter>[
                  MaskTextInputFormatter(
                    mask: '## #### ####',
                    filter: {"#": RegExp(r'[0-9]')},
                  ),
                ],
                onSaved: (v) => user.phoneNumber = v!.replaceAll(' ', ''),
                validators: (v) {
                  v = v?.replaceAll(' ', '');
                  if ((v?.length ?? 0) <= 9) return 'Teléfono no válido';

                  final validated = v?.validatorLeesThan255;

                  if (validated != null) return validated;

                  return null;
                },
              ),
              Forms.textField(
                hintText: "RFC",
                labelText: "RFC",
                isRequired: true,
                initialValue: user.rfc,
                onChanged: (value) => user.rfc = value,
                validators: (value) => value?.validatorLeesThan255,
              ),
              Divider(
                color: Colors.grey[300],
              ),
              FormAddressWidget(address: user.address!),
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

    bool successful = false;

    if (edit) {
      successful = await context.read<SuppliersProvider>().edit(
            data: user.toJson().differences(widget.user!.toJson()),
            uid: widget.user!.uid!,
            onError: (e) => ShowSnackBar.showError(context, message: e),
          );
    } else {
      successful = await context.read<SuppliersProvider>().create(
            data: user.toJson(),
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
