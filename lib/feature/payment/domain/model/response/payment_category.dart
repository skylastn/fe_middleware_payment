import 'dart:convert';
import 'payment_method.dart';

List<PaymentCategory> paymentCategoryFromJson(dynamic data) {
  if (data == null) return [];
  if (data is String) {
    try {
      final decoded = json.decode(data);
      return paymentCategoryFromJson(decoded);
    } catch (_) {
      return [];
    }
  }
  if (data is List) {
    return List<PaymentCategory>.from(
      data.map((x) => PaymentCategory.fromJson(x)),
    );
  }
  return [];
}

class PaymentCategory {
  int id;
  String key;
  String title;
  String detail;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<PaymentResponse> paymentMethods;

  PaymentCategory({
    required this.id,
    required this.key,
    required this.title,
    required this.detail,
    this.createdAt,
    this.updatedAt,
    this.paymentMethods = const [],
  });

  factory PaymentCategory.fromJson(dynamic rawJson) {
    if (rawJson == null || rawJson is! Map) {
      return PaymentCategory(id: 0, key: '', title: '', detail: '');
    }
    final json = Map<String, dynamic>.from(rawJson);
    return PaymentCategory(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      key: json['key']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      detail: json['detail']?.toString() ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'].toString()),
      paymentMethods: json['payment_methods'] != null &&
              json['payment_methods'] is List
          ? List<PaymentResponse>.from(
              (json['payment_methods'] as List).map(
                (x) => PaymentResponse.fromMap(x),
              ),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'title': title,
        'detail': detail,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'payment_methods': paymentMethods.map((x) => x.toMap()).toList(),
      };
}
