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
    this.from,
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
    String? from,
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
        from: from ?? this.from,
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
      from: json['from']?.toString(),
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
        'from': from,
        'image': image,
        'image_url': imageUrl,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'bankCode': bankCode,
        'category': category?.toJson(),
      };
}
