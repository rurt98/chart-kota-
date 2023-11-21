import 'package:final_project_ba_char/utilities/date_time_extensions.dart';

class Vat {
  String? uid;
  int? vat;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Vat>? history;
  bool? father;

  Vat({
    this.uid,
    this.vat,
    this.createdAt,
    this.updatedAt,
    this.history,
    this.father = false,
  });

  Vat copyWith({
    String? uid,
    int? vat,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Vat>? history,
    bool? father,
  }) =>
      Vat(
        uid: uid ?? this.uid,
        vat: vat ?? this.vat,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        history: history ?? this.history,
        father: father ?? this.father,
      );

  factory Vat.fromJson(Map<String, dynamic> json) => Vat(
        uid: json["uid"],
        vat: json["vat"] != null ? json["vat"] * 100 : null,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        history: json["history"] == null
            ? null
            : List.from(json["history"].map((e) => Vat.fromJson(e))),
        father: json["father"],
      );

  Map<String, dynamic> toJson() => {
        if (vat != null) "vat": vat! / 100,
        if (createdAt != null) "created_at": createdAt.toString(),
        if (updatedAt != null) "updated_at": updatedAt.toString(),
        if (history != null)
          "history": history!.map((e) => e.toJson()).toList(),
      };
  Map<String, dynamic> toDataTable() => {
        "vat": toString(),
        "created_at": createdAt?.dateAndHour24ToString ?? '-',
        "updated_at": updatedAt?.dateAndHour24ToString ?? '-'
      };

  @override
  String toString() => vat != null ? "$vat %" : '-';
}
