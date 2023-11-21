import 'package:final_project_ba_char/styles/colors.dart';
import 'package:final_project_ba_char/styles/styles.dart';
import 'package:final_project_ba_char/utilities/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAutoComplete<T extends Object> extends StatefulWidget {
  final AutocompleteOptionsBuilder<T> optionsBuilder;
  final AutocompleteOnSelected<T>? onSelected;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final T? initialValue;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Color? suffixIconColor;

  final Widget? Function(T item)? itemBuilder;

  final AutocompleteOptionToString<T> displayStringForOption;

  final bool? isRequired;
  final String? label;
  final IconData? prefixIcon;

  const CustomAutoComplete({
    Key? key,
    required this.optionsBuilder,
    this.onSelected,
    this.decoration,
    this.validator,
    this.initialValue,
    this.onChanged,
    this.itemBuilder,
    this.inputFormatters,
    this.keyboardType,
    this.suffixIconColor,
    this.isRequired = false,
    this.label,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<CustomAutoComplete<T>> createState() => _CustomAutoCompleteState<T>();
}

class _CustomAutoCompleteState<T extends Object>
    extends State<CustomAutoComplete<T>> {
  DebouncerOptionsBuilder<T>? debouncer;

  String? lastSearch;
  Iterable<T>? lastResults;

  @override
  void initState() {
    debouncer = DebouncerOptionsBuilder<T>(
      milliseconds: 500,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: widget.label != null
          ? ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100, minHeight: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithRequired(),
                  Expanded(
                    child: _buildAutoComplete(context),
                  ),
                ],
              ),
            )
          : _buildAutoComplete(context),
    );
  }

  Widget _buildAutoComplete(BuildContext context) {
    return Autocomplete<T>(
      initialValue: widget.initialValue != null
          ? TextEditingValue(text: widget.initialValue?.toString() ?? "")
          : null,
      displayStringForOption: widget.displayStringForOption,
      optionsBuilder: (textEditingValue) async {
        final newSearch = textEditingValue.text;
        if (newSearch == lastSearch) return lastResults ?? [];

        lastSearch = newSearch;

        if (debouncer != null) {
          lastResults = await debouncer!.result(
            newSearch,
            (query) async => await widget.optionsBuilder(
              TextEditingValue(text: query),
            ),
          );
        } else {
          lastResults = await widget.optionsBuilder(textEditingValue);
        }

        return lastResults ?? [];
      },
      onSelected: (option) {
        widget.onSelected?.call(option);
        setState(() {});
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          decoration: (widget.decoration ?? const InputDecoration()).copyWith(
            suffixIcon: textEditingController.value.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      textEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.clear,
                      color: widget.suffixIconColor ?? Colors.white,
                      size: 20,
                    ),
                  ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: darkGreyApp,
                    size: 20,
                  )
                : null,
          ),
          validator: widget.validator,
          onChanged: (value) {
            widget.onChanged?.call(value);
            setState(() {});
          },
        );
      },
      optionsViewBuilder: (_, onSelected, options) {
        return Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: 300,
                margin: const EdgeInsets.only(top: 5),
                decoration:
                    context.cardDecoration.copyWith(color: Colors.white),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const Divider(height: 0),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.toList()[index];

                      return Material(
                        color: Theme.of(context).brightness == Brightness.light
                            ? null
                            : Colors.black45,
                        child: InkWell(
                          onTap: () {
                            onSelected(option);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: widget.itemBuilder?.call(option) ??
                                Text(option.toString()),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _labelWithRequired() => Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            Expanded(
              flex: widget.isRequired! ? 0 : 1,
              child: Text(
                widget.label!,
              ),
            ),
            if (widget.isRequired!)
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
}
