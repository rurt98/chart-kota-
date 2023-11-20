import 'package:custom_data_table/custom_data_table.dart';
import 'package:final_project_ba_char/models/address.dart';
import 'package:final_project_ba_char/models/user.dart';
import 'package:final_project_ba_char/providers/operators_provider.dart';
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
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:final_project_ba_char/utilities/map_string_dynamic_extensions.dart';

class OperatorsScreen extends StatefulWidget {
  const OperatorsScreen({super.key});

  @override
  State<OperatorsScreen> createState() => _OperatorsScreenState();
}

class _OperatorsScreenState extends State<OperatorsScreen> {
  late OperatorsProvider provider;

  @override
  void initState() {
    provider = context.read<OperatorsProvider>();
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
            child: const FormOperatorsWidget(),
          ),
        ),
      ],
      child: Selector<OperatorsProvider, (bool, PaginatorInfo, List<User>?)>(
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
                  name: 'Roll',
                  key: 'role',
                  width: 250,
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
                  name: 'Genero',
                  key: 'gender',
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
                        child: FormOperatorsWidget(
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

class FormOperatorsWidget extends StatefulWidget {
  final User? user;

  const FormOperatorsWidget({super.key, this.user});

  @override
  FormOperatorsWidgetState createState() => FormOperatorsWidgetState();
}

class FormOperatorsWidgetState extends State<FormOperatorsWidget> {
  ScrollController scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  late bool edit;
  late User user;
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);

  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmationPasswordCtrl =
      TextEditingController();
  final showPassword = ValueNotifier<bool>(false);

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
          titulo: "${edit ? "Editar" : "Nuevo"} empleado",
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
                hintText: "Username",
                labelText: "Username",
                isRequired: true,
                initialValue: user.userName,
                onChanged: (value) => user.userName = value,
                validators: (value) => value?.validatorLeesThan255,
              ),
              Forms.textField(
                hintText: "Apellidos",
                labelText: "Apellidos",
                isRequired: true,
                initialValue: user.lastNames,
                onChanged: (value) => user.lastNames = value,
                validators: (value) => value?.validatorLeesThan255,
              ),
              Forms.dropdown(
                context,
                value: user.gender,
                labelText: "Genero",
                isRequired: true,
                onChanged: (v) => user.gender = v,
                items: GenderType.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.nombreEs),
                        ))
                    .toList(),
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
              Forms.dropdown(
                context,
                value: user.role,
                labelText: "Roll",
                isRequired: true,
                onChanged: (v) => user.role = v,
                items: RollType.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.nombreEs),
                        ))
                    .toList(),
              ),
              if (!edit) _buildPasswordSection(context),
              Divider(
                color: Colors.grey[300],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPasswordSection(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: showPassword,
      builder: (_, showPass, __) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Forms.textField(
                  hintText: 'Contraseña',
                  inRow: true,
                  isRequired: !edit,
                  controller: passwordCtrl,
                  obscureText: !showPass,
                  validators: (value) {
                    if (edit && passwordCtrl.text.isEmpty == true) return null;

                    if (value!.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return value.validatorLeesThan255;
                  },
                ),
                const SizedBox(width: 10),
                Forms.textField(
                  hintText: 'Confirma contraseña',
                  inRow: true,
                  obscureText: !showPass,
                  controller: confirmationPasswordCtrl,
                  isRequired: !edit,
                  validators: (value) {
                    if (passwordCtrl.text.isEmpty) return null;

                    if (passwordCtrl.text != value) {
                      return 'No coinciden las contraseñas';
                    }

                    return value?.validatorLeesThan255;
                  },
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: showPass,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (bool? v) => showPassword.value = v!,
                ),
                const Text(
                  'Ver contraseña',
                )
              ],
            ),
          ],
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
      successful = await context.read<OperatorsProvider>().edit(
            data: user.toJson().differences(widget.user!.toJson()),
            uid: widget.user!.uid!,
            onError: (e) => ShowSnackBar.showError(context, message: e),
          );
    } else {
      successful = await context.read<OperatorsProvider>().createOperator(
            password: passwordCtrl.text,
            email: user.email!,
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
