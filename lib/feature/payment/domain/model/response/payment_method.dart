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
  String? paymentGatewayId;
  String? paymentGatewayKey;
  bool? isActive;
  String? image;
  String? imageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? bankCode;
  PaymentCategory? category;

  PaymentCategoryKey get categoryKey =>
      PaymentCategoryKey.fromKey(category?.key);

  String get effectiveImageUrl {
    if (imageUrl != null && imageUrl!.isNotEmpty) return imageUrl!;
    if (image != null && image!.isNotEmpty) return image!;
    return '';
  }

  PaymentResponse({
    this.id,
    this.key,
    this.value,
    this.type,
    this.name,
    this.paymentGatewayId,
    this.paymentGatewayKey,
    this.isActive = true,
    this.image,
    this.imageUrl,
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
    String? paymentGatewayId,
    String? paymentGatewayKey,
    bool? isActive,
    String? image,
    String? imageUrl,
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
        paymentGatewayId: paymentGatewayId ?? this.paymentGatewayId,
        paymentGatewayKey: paymentGatewayKey ?? this.paymentGatewayKey,
        isActive: isActive ?? this.isActive,
        image: image ?? this.image,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        bankCode: bankCode ?? this.bankCode,
        category: category ?? this.category,
      );

  factory PaymentResponse.fromMap(dynamic rawJson) {
    if (rawJson == null || rawJson is! Map) {
      return PaymentResponse();
    }
    final json = Map<String, dynamic>.from(rawJson);
    return PaymentResponse(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0'),
      key: json['key']?.toString(),
      value: json['value']?.toString(),
      type: json['type']?.toString(),
      name: json['name']?.toString(),
      paymentGatewayId: json['payment_gateway_id']?.toString(),
      paymentGatewayKey: json['payment_gateway_key']?.toString() ??
          (json['gateway'] is Map ? json['gateway']['key']?.toString() : null),
      isActive: json['is_active'] == null ? true : (json['is_active'] == true || json['is_active'] == 1 || json['is_active'] == '1'),
      image: json['image']?.toString(),
      imageUrl: json['image_url'],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'].toString()),
      bankCode: json['bankCode']?.toString(),
      category: json['category'] != null && json['category'] is Map
          ? PaymentCategory.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'key': key,
        'value': value,
        'type': type,
        'name': name,
        'payment_gateway_id': paymentGatewayId,
        'payment_gateway_key': paymentGatewayKey,
        'is_active': isActive,
        'image': image,
        'image_url': imageUrl,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'bankCode': bankCode,
        'category': category?.toJson(),
      };
}
