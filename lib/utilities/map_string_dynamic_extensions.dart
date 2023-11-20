extension MapStringDynamicExtension on Map<String, dynamic> {
  Map<String, dynamic> differences(Map<String, dynamic> other) =>
      this..removeWhere((key, value) => value == other[key]);
}
