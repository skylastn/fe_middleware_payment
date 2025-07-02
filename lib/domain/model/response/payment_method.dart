// To parse this JSON data, do
//
//     final paymentResponse = paymentResponseFromMap(jsonString);

import 'dart:convert';

import 'payment_category.dart';

PaymentResponse paymentResponseFromMap(String str) =>
    PaymentResponse.fromMap(json.decode(str));

String paymentResponseToMap(PaymentResponse data) => json.encode(data.toMap());

class PaymentResponse {
  int? id;
  String? key;
  String? value;
  String? type;
  String? name;
  String? from;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? bankCode;
  PaymentCategory? category;

  PaymentResponse({
    this.id,
    this.key,
    this.value,
    this.type,
    this.name,
    this.from,
    this.createdAt,
    this.updatedAt,
    this.bankCode,
    this.category,
  });

  PaymentResponse copyWith({
    int? id,
    String? key,
    String? value,
    String? type,
    String? name,
    String? from,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? bankCode,
    PaymentCategory? category,
  }) =>
      PaymentResponse(
        id: id ?? this.id,
        key: key ?? this.key,
        value: value ?? this.value,
        type: type ?? this.type,
        name: name ?? this.name,
        from: from ?? this.from,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        bankCode: bankCode ?? this.bankCode,
        category: category ?? this.category,
      );

  factory PaymentResponse.fromMap(Map<String, dynamic> json) => PaymentResponse(
        id: json['id'],
        key: json['key'],
        value: json['value'],
        type: json['type'],
        name: json['name'],
        from: json['from'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        bankCode: json['bankCode'],
        category: json['category'] == null
            ? null
            : PaymentCategory.fromJson(json['category']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'key': key,
        'value': value,
        'type': type,
        'name': name,
        'from': from,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'bankCode': bankCode,
        'category': category?.toJson(),
      };
}
