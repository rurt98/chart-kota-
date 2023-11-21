import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String onlyDateToString({String? separator = ' '}) =>
      DateFormat('dd${separator}MMMM${separator}yyyy').format(this);

  String dateAndHourToString() => DateFormat('dd MMMM yyyy hh:mm').format(this);

  String get dateAndHour24ToString =>
      DateFormat('dd MMMM yyyy HH:mm').format(this);

  String hourToString() => DateFormat('hh:mm').format(this);

  // Esta función nos retorna la fecha del dia lunes mas cercano.
  DateTime getMondayDate() {
    final currentWeekday = weekday;
    final daysUntilMonday = (currentWeekday - DateTime.monday) % 7;
    final mondayDate = subtract(Duration(days: daysUntilMonday));

    return mondayDate;
  }

  // Extensiones para enviar al back.
  String get onlyDateToStringToSend =>
      DateFormat('yyyy-MM-dd').format((this).toUtc());

  String dateAndHourToStringToSend() {
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format((this).toUtc());
    return '${formattedDate}Z';
  }

  String get dateAndHourToStringToSendInQueries =>
      DateFormat('yyyy-MM-dd hh:mm:ss').format((this).toUtc());

  String get dateTimeWithOffsetToSendInQueries {
    var formattedDateTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(this);
    final offset = timeZoneOffset;

// Convierte el offset en una cadena en el formato necesario.
    final offsetString =
        '${offset.isNegative ? '-' : '+'}${offset.inHours.abs().toString().padLeft(2, '0')}:${(offset.inMinutes.abs() % 60).toString().padLeft(2, '0')}';

// Agrega el offset a la cadena formateada.
    formattedDateTime += offsetString;

    return formattedDateTime;
  }

  // Extensiones para comparar.
  bool isAtSameMoment(DateTime other) =>
      month == other.month && day == other.day && year == other.year;
}
