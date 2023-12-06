import 'package:final_project_ba_char/models/product.dart';
import 'package:final_project_ba_char/models/user.dart';
import 'package:final_project_ba_char/models/vat.dart';
import 'package:final_project_ba_char/utilities/date_time_extensions.dart';

enum PurchaseStatus {
  completed('Compra realizada'),
  pending('Pendiente');

  final String type;
  const PurchaseStatus(this.type);
}

class Purchase {
  String? id;
  String? folio;
  DateTime? date;
  PurchaseStatus? status;
  User? purchaseOperator;
  User? supplier;
  List<Product>? products;
  Vat? vat;

  Purchase({
    this.id,
    this.date,
    this.status,
    this.purchaseOperator,
    this.supplier,
    this.products,
    this.folio,
    this.vat,
  });

  Purchase copyWith({
    String? id,
    DateTime? date,
    PurchaseStatus? status,
    User? purchaseOperator,
    User? supplier,
    List<Product>? products,
    String? folio,
    Vat? vat,
  }) =>
      Purchase(
        id: id ?? this.id,
        date: date ?? this.date,
        status: status ?? this.status,
        purchaseOperator: purchaseOperator ?? this.purchaseOperator,
        supplier: supplier ?? this.supplier,
        products: products ?? this.products,
        folio: folio ?? this.folio,
        vat: vat ?? this.vat,
      );

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
        id: json["id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),

        //     json["operator"] == null ? null : User.fromJson(json["operator"]),
        // supplier:
        //     json["supplier"] == null ? null : User.fromJson(json["supplier"]),
        status: json["status"] == null
            ? null
            : PurchaseStatus.values.firstWhere(
                (e) => e.name == json["status"],
                orElse: () => PurchaseStatus.pending,
              ),
        vat: json["vat"] == null ? null : Vat.fromJson(json["vat"]),
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
        folio: json["folio"],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        "date": DateTime.now().toString(),
        if (status != null) "status": status!.name,
        if (purchaseOperator != null) "operator": purchaseOperator?.toJson(),
        if (supplier != null) "supplier": supplier?.toJson(),
        if (folio != null) "folio": folio,
        if (products != null)
          "products": products == null
              ? []
              : List<dynamic>.from(products!.map((x) => x.toProductSale())),
        "vat": vat?.toJson(),
      };

  Map<String, dynamic> toDataTable() {
    final totals = _getTotals();
    return {
      "date": date?.dateAndHour24ToString ?? '-',
      "status": status?.type ?? '',
      "operator": purchaseOperator?.toString() ?? '-',
      "supplier": supplier?.toString() ?? '-',
      "folio": folio ?? "",
      "vat": '${vat?.toString() ?? '-'} (\$${totals.$2})',
      "total": '\$${totals.$1}',
      "products": products == null
          ? []
          : List<dynamic>.from(products!.map((x) => x.toProductSale())),
    };
  }

  (double, double) _getTotals() {
    double subtotal = 0.0;

    for (var product in (products ?? <Product>[])) {
      final total = (product.purchasePrice ?? 0) * (product.quantity ?? 1);
      subtotal = subtotal + total;
    }

    final iva = _getIva(subtotal);

    return (subtotal + iva, iva);
  }

  double _getIva(double subtotal) {
    double ivaTem = (vat?.vat ?? 0.0) / 100;
    double totalIva = subtotal * ivaTem;

    return double.parse(totalIva.toStringAsFixed(2));
  }
}
