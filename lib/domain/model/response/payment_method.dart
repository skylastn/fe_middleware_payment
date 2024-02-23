import 'dart:convert';
import 'payment_category.dart';

List<PaymentMethod> paymentMethodFromJson(String str) => List<PaymentMethod>.from(json.decode(str).map((x) => PaymentMethod.fromJson(x)));

String paymentMethodToJson(List<PaymentMethod> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentMethod {
    int id;
    String key;
    String value;
    String type;
    String name;
    String from;
    DateTime createdAt;
    DateTime updatedAt;
    String bankCode;
    PaymentCategory? category;

    PaymentMethod({
        required this.id,
        required this.key,
        required this.value,
        required this.type,
        required this.name,
        required this.from,
        required this.createdAt,
        required this.updatedAt,
        required this.bankCode,
        this.category,
    });

    factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"],
        key: json["key"],
        value: json["value"],
        type: json["type"],
        name: json["name"],
        from: json["from"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        bankCode: json["bankCode"],
        category: json["category"] == null ? null: PaymentCategory.fromJson(json["category"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value,
        "type": type,
        "name": name,
        "from": from,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "bankCode": bankCode,
        "category": category?.toJson(),
    };
}