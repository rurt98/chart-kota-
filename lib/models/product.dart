import 'package:final_project_ba_char/models/user.dart';
import 'package:final_project_ba_char/utilities/date_time_extensions.dart';

class Product {
  String? uid;
  String? name;
  String? description;
  String? barcode;
  int? stock;
  double? price;
  double? purchasePrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? supplier;
  int? quantity;

  Product({
    this.uid,
    this.name,
    this.stock,
    this.price,
    this.purchasePrice,
    this.createdAt,
    this.updatedAt,
    this.supplier,
    this.description,
    this.barcode,
    this.quantity = 0,
  });

  Product copyWith({
    String? uid,
    String? name,
    int? stock,
    double? price,
    double? purchasePrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? supplier,
    String? description,
    String? barcode,
    int? quantity,
  }) =>
      Product(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        stock: stock ?? this.stock,
        price: price ?? this.price,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        supplier: supplier ?? this.supplier,
        description: description ?? this.description,
        barcode: barcode ?? this.barcode,
        quantity: quantity ?? this.quantity,
        purchasePrice: purchasePrice ?? this.purchasePrice,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        uid: json["uid"],
        name: json["name"],
        stock: json["stock"],
        price: json["price"] != null ? json["price"] / 100 : null,
        purchasePrice: json["purchase_price"] != null
            ? json["purchase_price"] / 100
            : null,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        description: json['description'],
        barcode: json["barcode"],
        quantity: json["quantity"],
        // supplier:
        //     json["supplier"] == null ? null : User.fromJson(json["supplier"]),
      );

  Map<String, dynamic> toJson() => {
        if (uid != null) "uid": uid,
        if (name != null) "name": name,
        if (stock != null) "stock": stock,
        if (price != null) "price": price! * 100,
        if (createdAt != null) "created_at": createdAt?.toIso8601String(),
        if (updatedAt != null) "updated_at": updatedAt?.toIso8601String(),
        if (supplier != null) "supplier": supplier!.toJson(),
        if (description != null) 'description': description,
      };

  Map<String, dynamic> toProductSale() => {
        if (barcode != null) "barcode": barcode,
        if (name != null) "name": name,
        if (price != null) "price": price! * 100,
        if (createdAt != null) "created_at": createdAt?.toIso8601String(),
        if (updatedAt != null) "updated_at": updatedAt?.toIso8601String(),
        if (supplier != null) "supplier": supplier!.toJson(),
        if (description != null) 'description': description,
        if ((quantity ?? 0) > 0) 'quantity': quantity,
        if (purchasePrice != null) 'purchase_price': purchasePrice! * 100,
      };

  Map<String, dynamic> toDataTable() => {
        "name": name ?? '-',
        "stock": stock ?? 0,
        "price": (price != null ? '\$$price' : null) ?? '-',
        "created_at": createdAt?.dateAndHour24ToString ?? '-',
        "updated_at": updatedAt?.dateAndHour24ToString ?? '-',
        "supplier": supplier?.toString() ?? '-',
        "description": description ?? '-',
        "barcode": barcode ?? '-',
        "quantity": quantity ?? 0,
        "total": '\$${_getTotal()}',
        'purchase_price':
            (purchasePrice != null ? '\$$purchasePrice' : null) ?? '-',
      };

  double _getTotal() => (price ?? 0) * (quantity ?? 1);

  @override
  String toString() {
    return '${barcode != null ? "$barcode /" : ""} ${name != null ? "$name /" : ""} ${price != null ? "\$$price" : ""}';
  }
}
