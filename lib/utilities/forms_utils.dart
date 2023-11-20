import 'dart:async';

import 'package:final_project_ba_char/utilities/custom_container.dart';
import 'package:final_project_ba_char/utilities/input_validators.dart';
import 'package:final_project_ba_char/widgets/custom_switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

// CLASE PARA MANEJAR WIDGETS PARA FORMULARIOS
class Forms {
  static Widget textField({
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    String? initialValue,
    int maxLines = 1,
    int? maxLenght,
    int? minLines,
    String? Function(String?)? validators,
    Function(String?)? onSaved,
    int flex = 1,
    bool inRow = false,
    bool isRequired = false,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    bool enabled = true,
    bool showLabel = true,
    bool obscureText = false,
    Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
    FocusNode? focusNode,
  }) {
    final tf = Expanded(
      flex: flex,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showLabel)
                _labelWithRequired(labelText ?? hintText ?? '', isRequired),
              TextFormField(
                focusNode: focusNode,
                enabled: enabled,
                controller: controller,
                initialValue: initialValue,
                maxLength: maxLenght,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  hintText: hintText ?? labelText,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                buildCounter: maxLenght != null ? _buildCounter : null,
                inputFormatters: inputFormatters,
                onSaved: onSaved,
                maxLines: maxLines,
                minLines: minLines,
                onChanged: onChanged,
                obscureText: obscureText,
                onFieldSubmitted: onFieldSubmitted,
                validator: (s) {
                  if (isRequired) {
                    final res = InputValidators.isNotEmpty(s);
                    if (res != null) {
                      return res;
                    }
                  }
                  if (validators != null && s?.isNotEmpty == true) {
                    return validators(s);
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
    if (!inRow) {
      return Row(
        children: [tf],
      );
    }
    return tf;
  }

  static Widget textFieldExpanded({
    TextEditingController? controller,
    String? labelText,
    int? maxLines,
    int? maxLenght,
    int? minLines,
    String? initialValue,
    String? Function(String?)? validators,
    Function(String)? onChanged,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          _labelWithRequired(labelText ?? '', isRequired),
          Expanded(
            child: TextFormField(
              initialValue: initialValue,
              controller: controller,
              keyboardType: TextInputType.multiline,
              maxLines: maxLines,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              onChanged: onChanged,
              validator: (s) {
                if (isRequired) {
                  final res = InputValidators.isNotEmpty(s);
                  if (res != null) {
                    return res;
                  }
                }
                if (validators != null && s?.isNotEmpty == true) {
                  return validators(s);
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                ),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // static Widget textFieldSearch<T extends Object>({
  //   required Future<List<T>> Function(String) optionsBuilder,
  //   required Function(T?) onSelected,
  //   dynamic Function(T?)? itemId,
  //   T? initialValue,
  //   String? Function(String?)? validators,
  //   String? hintText,
  //   String? labelText,
  //   int flex = 1,
  //   bool inRow = false,
  //   bool isRequired = false,
  //   bool enabled = true,
  // }) {
  //   final tf = Expanded(
  //     flex: flex,
  //     child: Padding(
  //       padding: const EdgeInsets.all(3.0),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _labelWithRequired(labelText ?? hintText ?? '', isRequired),
  //           CustomSearchWidget<T>(
  //             enabled: enabled,
  //             optionsBuilder: optionsBuilder,
  //             onSelected: onSelected,
  //             validator: validators,
  //             initialValue: initialValue,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  //   if (!inRow) {
  //     return Row(
  //       children: [tf],
  //     );
  //   }
  //   return tf;
  // }

  static Widget textFieldCount({
    required TextEditingController controller,
    String? labelText,
    String? hintText,
    String? initialValue,
    String? Function(String?)? validators,
    Function(String)? onChanged,
    Function(int?)? onSaved,
    int flex = 1,
    bool inRow = false,
    bool isRequired = false,
    bool enabled = true,
  }) {
    final tf = Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelWithRequired(labelText ?? hintText ?? '', isRequired),
            TextFormField(
              enabled: enabled,
              controller: controller,
              initialValue: initialValue,
              keyboardType: TextInputType.number,
              onChanged: onChanged,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                hintText: hintText,
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (controller.text.isEmpty) controller.text = '0';

                        int count = int.parse(controller.text);

                        controller.text = (++count).toString();
                      },
                      child: const Icon(Icons.keyboard_arrow_up_rounded),
                    ),
                    InkWell(
                      onTap: () {
                        if (controller.text.isEmpty || controller.text == '0') {
                          return;
                        }

                        int count = int.parse(controller.text);

                        controller.text = (--count).toString();
                      },
                      child: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  ],
                ),
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]')), // Solo permite caracteres numéricos
              ],
              onSaved: (v) {
                if (onSaved != null && v != null) onSaved(int.parse(v));
              },
              validator: (s) {
                if (validators != null) {
                  return validators(s);
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
    if (!inRow) {
      return Row(
        children: [tf],
      );
    }
    return tf;
  }

  static Widget timePicker(
    BuildContext context, {
    String? labelText,
    int flex = 1,
    bool isRequired = false,
    bool inRow = false,
    TimeOfDay? initialTime,
    required ValueChanged<TimeOfDay> timeChanged,
    bool enabled = true,
  }) {
    final tf = Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelWithRequired(labelText ?? '', isRequired),
            TextFormField(
              enabled: enabled,
              readOnly: true,
              onTap: () async {
                final TimeOfDay? timeOfDay = await showTimePicker(
                  context: context,
                  initialTime: initialTime ?? TimeOfDay.now(),
                );

                if (timeOfDay == null || timeOfDay == initialTime) return;
                timeChanged(timeOfDay);
              },
              decoration: InputDecoration(
                hintText:
                    initialTime == null ? 'HH:mm' : initialTime.format(context),
              ),
              validator: (_) {
                if (isRequired && initialTime == null) {
                  return 'El valor es nulo o vacío';
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
    if (!inRow) {
      return Row(
        children: [tf],
      );
    }
    return tf;
  }

  static Widget datePicker(
    BuildContext context, {
    String? labelText,
    int flex = 1,
    bool isRequired = false,
    DateTime? firstDate,
    bool inRow = false,
    DateTime? initialDate,
    bool enabled = true,
    required ValueChanged<DateTime> dateChanged,
    DateTime? lastDate,
  }) {
    final tf = Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelWithRequired(labelText ?? 'Fecha', isRequired),
            TextFormField(
              enabled: enabled,
              readOnly: true,
              onTap: () async {
                if (!enabled) return;
                final DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: initialDate ?? DateTime.now(),
                  firstDate: firstDate ?? DateTime(1900),
                  lastDate: lastDate ?? DateTime(2050),
                );

                if (date == null || date == initialDate) return;

                dateChanged(date);
              },
              decoration: InputDecoration(
                  hintText: initialDate == null
                      ? 'dd/MM/aaaa'
                      : DateFormat('dd/MM/yyyy').format(initialDate)),
              validator: (_) {
                if (isRequired && initialDate == null) {
                  return 'El valor es nulo o vacío';
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
    if (!inRow) {
      return Row(
        children: [tf],
      );
    }
    return tf;
  }

  static Widget dateRangePicker(
    BuildContext context, {
    String? labelText,
    int flex = 1,
    bool isRequired = false,
    DateTime? firstDate,
    DateTime? lastDate,
    bool inRow = false,
    DateTimeRange? initialDate,
    bool enabled = true,
    Function(DateTimeRange d)? onChanged,
  }) {
    final tf = Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelWithRequired(labelText ?? 'Fecha', isRequired),
            TextFormField(
              enabled: enabled,
              readOnly: true,
              onTap: () async {
                if (!enabled) return;

                final DateTimeRange? date = await showDateRangePicker(
                  context: context,
                  firstDate: firstDate ?? DateTime(1900),
                  lastDate: lastDate ?? DateTime(2050),
                  initialDateRange: initialDate,
                );

                if (date == null) return;
                onChanged?.call(date);
              },
              decoration: InputDecoration(
                  hintText: initialDate == null
                      ? 'Escoger fecha o rango de fechas'
                      : "${DateFormat('dd/MM/yyyy').format(initialDate.start)}${initialDate.end.isAtSameMomentAs(initialDate.start) ? '' : ' - ${DateFormat('dd/MM/yyyy').format(initialDate.end)}'}"),
              validator: (_) {
                if (isRequired && initialDate == null) {
                  return 'El valor es nulo o vacío';
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
    if (!inRow) {
      return Row(
        children: [tf],
      );
    }
    return tf;
  }

  static Widget checkbox({
    required bool value,
    required String label,
    Function(bool value)? onChanged,
    int flex = 1,
    bool inRow = false,
    bool enabled = true,
  }) {
    final w = Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            _labelWithRequired(label, false),
            StatefulBuilder(
              builder: (context, setstate) => InputContainer(
                suffix: Checkbox(
                  value: value,
                  onChanged: (s) {
                    if (!enabled) return;
                    value = !value;
                    onChanged?.call(value);
                    setstate(() {});
                  },
                ),
                child: Text(label),
                onTap: () {
                  if (!enabled) return;
                  value = !value;
                  onChanged?.call(value);
                  setstate(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
    if (!inRow) {
      return Row(
        children: [w],
      );
    }
    return w;
  }

  static Widget chip(
          {required String label,
          required bool selected,
          Function(bool)? onTap}) =>
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: StatefulBuilder(
          builder: (_, setstate) => ChoiceChip(
            onSelected: (s) {
              selected = !selected;
              onTap?.call(selected);
              setstate(() {});
            },
            label: Text(label),
            selected: selected,
          ),
        ),
      );

  static Widget switchField(BuildContext context,
      {required bool value,
      required String? label,
      int flex = 1,
      bool inRow = false,
      bool enabled = true,
      required Function(bool) onChange}) {
    final w = Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            // _labelWithRequired(label ?? '', false),
            StatefulBuilder(
              builder: (context, setstate) => InputContainer(
                onTap: () {
                  if (!enabled) return;
                  value = !value;
                  onChange(value);
                  setstate(() {});
                },
                suffix: CustomSwitchWidget(
                  value: value,
                  onChanged: (v) {
                    if (!enabled) return;
                    value = !value;
                    onChange(v);
                    setstate(() {});
                  },
                ),
                child: Text(
                  label ?? '',
                  style: TextStyle(
                    color:
                        Theme.of(context).inputDecorationTheme.hintStyle?.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (!inRow) {
      return Row(
        children: [w],
      );
    }
    return w;
  }

  static Widget dropdown<T>(
    BuildContext context, {
    required T? value,
    required String? labelText,
    required List<DropdownMenuItem<T>> items,
    String? Function(Object?)? validators,
    Function(T?)? onSaved,
    Function(T?)? onChanged,
    bool isRequired = false,
    int flex = 1,
    bool inRow = false,
    bool enabled = true,
  }) {
    final w = Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelWithRequired(labelText ?? '', isRequired),
            _validatorWidget(
              onSaved: onSaved,
              validator: (s) {
                if (isRequired) {
                  if (value == null) {
                    return "El campo es obligatorio";
                  }
                }
                if (validators != null) {
                  validators(s);
                }
                return null;
              },
              child: DropdownButtonFormField<T>(
                focusColor: Colors.transparent,
                isExpanded: true,
                hint: Text(
                  labelText ?? '',
                  style: TextStyle(
                    color:
                        Theme.of(context).inputDecorationTheme.hintStyle?.color,
                  ),
                ),
                items: items,
                value: value,
                onChanged: !enabled
                    ? null
                    : (s) {
                        if (s != null) {
                          value = s;
                        }
                        if (onChanged != null) onChanged(s);
                      },
              ),
            ),
          ],
        ),
      ),
    );
    if (!inRow) {
      return Row(
        children: [w],
      );
    }
    return w;
  }

  static Widget multiDropdown<T>(
    BuildContext context, {
    bool isMultiple = false,
    bool withLabel = true,
    required List<T> selecteds,
    required List<T> defaultOptions,
    required String? labelText,
    String? hintText,
    String? Function(Object?)? validators,
    Function(List<T>?)? onSaved,
    Function(List<T>?)? onSelect,
    required String Function(T) itemToString,
    bool Function(T)? itemSelectionable,
    required String Function(T) itemId,
    required Future<List<T>> Function(String text) onSearch,
    bool isRequired = false,
    int flex = 1,
    bool inRow = false,
    bool enabled = true,
  }) {
    Timer? debounceTimer;
    List<T> items = [];
    final TextEditingController ctrl = TextEditingController();
    final w = Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (withLabel) _labelWithRequired(labelText ?? '', isRequired),
            FormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              builder: (s) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: s.hasError
                            ? Border.all(color: Colors.red, width: 1.5)
                            : null,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: StatefulBuilder(
                      builder: (_, setState) => PopupMenuButton(
                        position: PopupMenuPosition.under,
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              padding: EdgeInsets.zero,
                              child: StatefulBuilder(
                                builder: (context, setstate) => Column(
                                  children: [
                                    Container(
                                      width: 300,
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextField(
                                          controller: ctrl,
                                          decoration: InputDecoration(
                                              labelStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .inputDecorationTheme
                                                    .hintStyle
                                                    ?.color,
                                              ),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never,
                                              fillColor: Colors.transparent,
                                              label: Row(
                                                children: [
                                                  Icon(Icons.search,
                                                      color: Theme.of(context)
                                                          .inputDecorationTheme
                                                          .hintStyle
                                                          ?.color),
                                                  const SizedBox(width: 5),
                                                  const Text("Buscar"),
                                                ],
                                              )),
                                          onChanged: (value) {
                                            if (!enabled) return;
                                            // Cancelar temporizador si ya está en marcha
                                            debounceTimer?.cancel();
                                            // Iniciar un nuevo temporizador
                                            debounceTimer = Timer(
                                                const Duration(
                                                    milliseconds: 500),
                                                () async {
                                              items = await onSearch(ctrl.text);
                                              for (int i = 0;
                                                  i < selecteds.length;
                                                  i++) {
                                                for (int j = 0;
                                                    j < items.length;
                                                    j++) {
                                                  if (itemId(selecteds[i]) ==
                                                      itemId(items[j])) {
                                                    items[j] = selecteds[i];
                                                  }
                                                }
                                              }
                                              setstate(() {});
                                            });
                                          }),
                                    ),
                                    ...(ctrl.text == ""
                                            ? defaultOptions
                                            : items)
                                        .map((e) {
                                      bool selectable =
                                          itemSelectionable != null
                                              ? itemSelectionable(e)
                                              : true;

                                      return Opacity(
                                        opacity: selectable ? 1 : 0.4,
                                        child: InkWell(
                                          onTap: () {
                                            if (!selectable) {
                                            } else {
                                              if (isMultiple) {
                                                if (selecteds.contains(e)) {
                                                  selecteds.remove(e);
                                                } else {
                                                  selecteds.add(e);
                                                }
                                              } else {
                                                selecteds = [e];
                                              }

                                              setstate(() {});
                                              setState(() {});
                                              if (onSelect != null) {
                                                onSelect(selecteds);
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(selecteds.contains(e)
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                    child:
                                                        Text(itemToString(e))),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                              ),
                            )
                          ];
                        },
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          tileColor: Colors.grey[200],
                          title: Text(
                            selecteds.any((e) => e != null) == false
                                ? (labelText ?? 'Selecciona opción')
                                : isMultiple
                                    ? (selecteds
                                        .map((e) => itemToString(e))
                                        .toList()
                                        .toString())
                                    : itemToString(selecteds.first),
                            style: TextStyle(
                              color: Theme.of(context)
                                  .inputDecorationTheme
                                  .hintStyle
                                  ?.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (s.hasError)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 14),
                      child: Text(
                        s.errorText ?? "Error de validación",
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              onSaved: onSaved,
              validator: (s) {
                if (isRequired) {
                  if (selecteds.isEmpty == true) {
                    return "El campo es obligatorio";
                  }
                }
                if (validators != null) {
                  validators(selecteds);
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
    if (!inRow) {
      return Row(
        children: [w],
      );
    }
    return w;
  }

  static Widget _validatorWidget<T>(
      {required Widget child,
      required void Function(T?)? onSaved,
      required String? Function(T?)? validator}) {
    return FormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (s) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              decoration: s.hasError
                  ? BoxDecoration(
                      border: Border.all(
                        width: 1.5,
                        color: Colors.pink,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              child: child),
          if (s.hasError)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
              child: Text(
                s.errorText ?? "Error de validación",
                style: TextStyle(
                  color: Colors.red[600],
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }

  static Widget autocomplete<T extends Object>({
    required List<String> items,
    T? initialValue,
    String? labelText,
    String? Function(Object?)? validators,
    Function(T)? onSaved,
    int flex = 1,
    bool inRow = false,
    bool isRequired = false,
  }) {
    final w = Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            _labelWithRequired(labelText ?? '', isRequired),
            Autocomplete<T>(
              initialValue: initialValue == null
                  ? null
                  : TextEditingValue(text: initialValue.toString()),
              optionsBuilder: (text) async => List.from(
                items
                    .where((e) =>
                        e.toLowerCase().contains(text.text.toLowerCase()))
                    .map((e) => e),
              ),
            ),
          ],
        ),
      ),
    );
    if (!inRow) {
      return Row(
        children: [w],
      );
    }
    return w;
  }

  static Timer? debounce; // Timer(Duration(milliseconds: 500), () { });

  static Widget futureAutocomplete<T extends Object>({
    T? initialValue,
    String? labelText,
    String? Function(Object?)? validators,
    required Future<List<T>> Function(String text) onSearch,
    required String Function(T option) itemToString,
    Function(T)? onSaved,
    int flex = 1,
    bool inRow = false,
    bool isRequired = false,
  }) {
    final w = Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            _labelWithRequired(labelText ?? '', isRequired),
            Autocomplete<T>(
                initialValue: initialValue == null
                    ? null
                    : TextEditingValue(text: initialValue.toString()),
                displayStringForOption: (option) => itemToString(option),
                optionsBuilder: (text) async {
                  List<T> items = [];
                  if (debounce == null || debounce?.isActive == false) {
                    debounce =
                        Timer(const Duration(milliseconds: 500), () async {
                      items = await onSearch(text.text);
                    });
                    return items;
                  }
                  return items;
                }),
          ],
        ),
      ),
    );
    if (!inRow) {
      return Row(
        children: [w],
      );
    }
    return w;
  }

  static ExpansionPanel expansionPanel<T>(
          {required String title, required List<T> options}) =>
      ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return Text(title);
          },
          body: Column(
            children: [...options.map((e) => Text(e.toString()))],
          ));

  static Widget title(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Text(
          text,
          textScaleFactor: 1.2,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  static Widget subtitle(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Text(
          text,
        ),
      );

  static Widget _labelWithRequired(String labelText, bool isRequired) =>
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            Expanded(
              flex: isRequired ? 0 : 1,
              child: Text(
                labelText,
              ),
            ),
            if (isRequired)
              Text(
                " *",
                style: TextStyle(
                  color: Colors.red[300],
                ),
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      );

  // Función para validar los forms
  static String? isValid(List<String?>? validators) {
    if (validators == null) return null;

    if (validators.isEmpty) return null;

    for (final v in validators) {
      if (v != null) return v;
    }

    return null;
  }
}

Widget? _buildCounter(BuildContext context,
    {required int currentLength,
    required int? maxLength,
    required bool isFocused}) {
  return const SizedBox();
}
