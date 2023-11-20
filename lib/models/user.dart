import 'package:final_project_ba_char/models/address.dart';

enum GenderType {
  m('Masculino'),
  f('Femenino');

  final String nombreEs;

  const GenderType(this.nombreEs);
}

enum RollType {
  admin('Administrador'),
  systemOperator('Operador');

  final String nombreEs;

  const RollType(this.nombreEs);
}

class User {
  String? uid;
  DateTime? createdAt;
  String? phoneNumber;
  String? email;
  String? lastNames;
  String? userName;
  GenderType? gender;
  String? names;
  RollType? role;
  Address? address;
  String? rfc;

  User({
    this.uid,
    this.createdAt,
    this.phoneNumber,
    this.email,
    this.lastNames,
    this.gender,
    this.names,
    this.userName,
    this.role,
    this.address,
    this.rfc,
  });

  User copyWith({
    String? uid,
    DateTime? createdAt,
    String? phoneNumber,
    String? email,
    String? lastNames,
    GenderType? gender,
    String? names,
    RollType? role,
    Address? address,
    String? userName,
    String? rfc,
  }) =>
      User(
        createdAt: createdAt ?? this.createdAt,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        lastNames: lastNames ?? this.lastNames,
        gender: gender ?? this.gender,
        names: names ?? this.names,
        role: role ?? this.role,
        address: address ?? this.address,
        userName: userName ?? this.userName,
        rfc: rfc ?? this.rfc,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        phoneNumber: json["phone_number"],
        email: json["email"],
        lastNames: json["last_names"],
        gender: json["gender"] == null
            ? null
            : GenderType.values.firstWhere(
                (e) => e.name == json["gender"],
                orElse: () => GenderType.m,
              ),
        names: json["names"],
        role: json["role"] == null
            ? null
            : RollType.values.firstWhere(
                (e) => e.name == json["role"],
                orElse: () => RollType.systemOperator,
              ),
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        userName: json['user_name'],
        rfc: json['rfc'],
      );

  Map<String, dynamic> toJson() => {
        if (createdAt != null) "created_at": createdAt?.toIso8601String(),
        if (phoneNumber != null) "phone_number": phoneNumber,
        if (email != null) "email": email,
        if (lastNames != null) "last_names": lastNames,
        if (gender != null) "gender": gender!.name,
        if (names != null) "names": names,
        if (role != null) "role": role!.name,
        if (address != null) "address": address?.toJson(),
        if (userName != null) "user_name": userName!,
        if (rfc != null) 'rfc': rfc,
      };

  Map<String, dynamic> toDataTable() => {
        'names': toString(),
        'email': email ?? '-',
        'phone_number': phoneNumber ?? '-',
        'gender': gender?.nombreEs ?? '-',
        'role': role?.nombreEs ?? '-',
        'address': address?.toString() ?? '-',
        'userName': userName,
        'rfc': rfc,
      };

  @override
  String toString() =>
      '${names != null ? '$names ' : ''}${lastNames != null ? '$lastNames ' : ''}';
}
