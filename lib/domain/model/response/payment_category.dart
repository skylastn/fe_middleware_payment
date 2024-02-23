import 'dart:convert';

List<PaymentCategory> paymentCategoryFromJson(String str) =>
    List<PaymentCategory>.from(
      json.decode(str).map(
            (x) => PaymentCategory.fromJson(x),
          ),
    );

class PaymentCategory {
  int id;
  String key;
  String title;
  String detail;
  DateTime createdAt;
  DateTime updatedAt;

  PaymentCategory({
    required this.id,
    required this.key,
    required this.title,
    required this.detail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentCategory.fromJson(Map<String, dynamic> json) =>
      PaymentCategory(
        id: json["id"],
        key: json["key"],
        title: json["title"],
        detail: json["detail"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "title": title,
        "detail": detail,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
