import 'dart:convert';

extension StringExtension on String {
  String get naturalCapitalized => toLowerCase().replaceAllMapped(
        RegExp("(^|\\.\\s)(\\w)"),
        (match) => "${match.group(1)}${match.group(2)?.toUpperCase()}",
      );

  String? get validatorLeesThan255 => customCountValidator(255);

  String? customCountValidator(int leesThan) {
    final value = this;
    value.trim();

    if (value.isEmpty) {
      return "El campo es obligatorio.";
    }

    if (value.length > leesThan) {
      return "No debe ser mayor a $leesThan caracteres.";
    }

    if (RegExp(
      "^[ ]",
    ).hasMatch(this)) {
      return "No se aceptan espacios en blanco al inicio.";
    }

    return null;
  }

  String get convertStringToCode => base64Url.encode(utf8.encode(this));

  String get convertCodeToString => utf8.decode(base64Url.decode(this));

  String? get isEmail {
    if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(this)) return null;

    return 'El valor no es un correo electrónico válido';
  }
}
