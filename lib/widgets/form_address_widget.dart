import 'package:final_project_ba_char/models/address.dart';
import 'package:final_project_ba_char/utilities/forms_utils.dart';
import 'package:final_project_ba_char/utilities/string_extension.dart';
import 'package:flutter/material.dart';

class FormAddressWidget extends StatelessWidget {
  final Address address;
  const FormAddressWidget({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Forms.textField(
          hintText: "País",
          labelText: "País",
          isRequired: true,
          initialValue: address.country,
          onChanged: (value) => address.country = value,
          validators: (value) => value?.validatorLeesThan255,
        ),
        Forms.textField(
          hintText: "Estado",
          labelText: "Estado",
          isRequired: true,
          initialValue: address.state,
          onChanged: (value) => address.state = value,
          validators: (value) => value?.validatorLeesThan255,
        ),
        Forms.textField(
          hintText: "Ciudad",
          labelText: "Ciudad",
          isRequired: true,
          initialValue: address.city,
          onChanged: (value) => address.city = value,
          validators: (value) => value?.validatorLeesThan255,
        ),
        Forms.textField(
          hintText: "Vecindario",
          labelText: "Vecindario",
          isRequired: true,
          initialValue: address.neighborhood,
          onChanged: (value) => address.neighborhood = value,
          validators: (value) => value?.validatorLeesThan255,
        ),
        Forms.textField(
          hintText: "Calle",
          labelText: "Calle",
          isRequired: true,
          initialValue: address.street,
          onChanged: (value) => address.street = value,
          validators: (value) => value?.validatorLeesThan255,
        ),
        Forms.textField(
          hintText: "Numero exterior",
          labelText: "Numero exterior",
          isRequired: true,
          initialValue: address.numExt,
          onChanged: (value) => address.numExt = value,
          validators: (value) => value?.validatorLeesThan255,
        ),
        Forms.textField(
          hintText: "Numero interior",
          labelText: "Numero interior",
          initialValue: address.numInt,
          onChanged: (value) => address.numInt = value,
          validators: (value) => value?.validatorLeesThan255,
        ),
      ],
    );
  }
}
