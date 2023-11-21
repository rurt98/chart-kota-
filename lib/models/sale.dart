import 'package:final_project_ba_char/models/product.dart';
import 'package:final_project_ba_char/models/user.dart';
import 'package:final_project_ba_char/models/vat.dart';
import 'package:final_project_ba_char/utilities/date_time_extensions.dart';

enum PayMethod {
  cash('Efectivo');

  final String method;

  const PayMethod(this.method);
}

class Sale {
  String? uid;
  String? folio;
  PayMethod? payMethod;
  User? saleOperator;
  DateTime? date;
  Vat? vat;
  List<Product>? products;

  Sale({
    this.uid,
    this.payMethod,
    this.saleOperator,
    this.date,
    this.vat,
    this.products,
    this.folio,
  });

  Sale copyWith({
    String? uid,
    PayMethod? payMethod,
    User? saleOperator,
    DateTime? date,
    Vat? vat,
    List<Product>? products,
    String? folio,
  }) =>
      Sale(
        uid: uid ?? this.uid,
        payMethod: payMethod ?? this.payMethod,
        saleOperator: saleOperator ?? this.saleOperator,
        date: date ?? this.date,
        vat: vat ?? this.vat,
        products: products ?? this.products,
        folio: folio ?? this.folio,
      );

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
        uid: json["uid"],
        payMethod: json["pay_method"] == null
            ? null
            : PayMethod.values.firstWhere(
                (e) => e.name == json["pay_method"],
                orElse: () => PayMethod.cash,
              ),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        vat: json["vat"] == null ? null : Vat.fromJson(json["vat"]),
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
        folio: json['folio'],
      );

  Map<String, dynamic> toJson() => {
        "pay_method": payMethod?.name,
        "vat": vat?.toJson(),
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toProductSale())),
        "folio": folio,
      };

  (double, double) _getTotals() {
    double subtotal = 0.0;

    for (var product in (products ?? <Product>[])) {
      final total = (product.price ?? 0) * (product.quantity ?? 1);
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

  Map<String, dynamic> toDataTable() {
    final totals = _getTotals();
    return {
      "total": '\$${totals.$1}',
      "pay_method": payMethod?.method ?? '-',
      "date": date?.dateAndHour24ToString ?? '-',
      "vat": '${vat?.toString() ?? '-'} (\$${totals.$2})',
      "products": products?.length.toString() ?? '0',
      'folio': folio ?? '-',
    };
  }
}
