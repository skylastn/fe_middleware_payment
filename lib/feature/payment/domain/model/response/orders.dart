import 'dart:convert';

import 'payment_method.dart';
import 'project.dart';

class Orders {
  String id;
  String type;
  String status;
  String reference;
  String mode;
  String? address;
  String? phone;
  String? email;
  String? notes;
  String? paymentMethod;
  String? value;
  String? request;
  String? response;
  String? callback;
  String url;
  DateTime? createdAt;
  DateTime? updatedAt;
  PaymentResponse? paymentMethods;
  Project? project;

  Orders({
    required this.id,
    required this.type,
    required this.status,
    required this.reference,
    required this.mode,
    required this.address,
    required this.phone,
    required this.email,
    required this.notes,
    required this.paymentMethod,
    this.value,
    required this.request,
    required this.response,
    required this.callback,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentMethods,
    required this.project,
  });

  factory Orders.fromJson(dynamic rawJson) {
    if (rawJson == null || rawJson is! Map) {
      return Orders(
        id: '',
        type: '',
        status: '',
        reference: '',
        mode: '',
        address: null,
        phone: null,
        email: null,
        notes: null,
        paymentMethod: null,
        request: null,
        response: null,
        callback: null,
        url: '',
        createdAt: null,
        updatedAt: null,
        paymentMethods: null,
        project: null,
      );
    }
    final json = Map<String, dynamic>.from(rawJson);
    return Orders(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
      mode: json['mode']?.toString() ?? '',
      address: json['address']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      notes: json['notes']?.toString(),
      paymentMethod: json['payment_method']?.toString(),
      value: json['value']?.toString(),
      request: json['request']?.toString(),
      response: json['response']?.toString(),
      callback: json['callback']?.toString(),
      url: json['url']?.toString() ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'].toString()),
      paymentMethods: json['payment_methods'] == null
          ? null
          : PaymentResponse.fromMap(json['payment_methods']),
      project: json['project'] == null
          ? null
          : Project.fromJson(
              json['project'],
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'status': status,
        'reference': reference,
        'mode': mode,
        'address': address,
        'phone': phone,
        'email': email,
        'notes': notes,
        'payment_method': paymentMethod,
        'value': value,
        'request': request,
        'response': response,
        'callback': callback,
        'url': url,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'payment_methods': paymentMethods?.toMap(),
        'project': project?.toJson(),
      };

  double get totalAmount {
    if ((request ?? '').isNotEmpty) {
      try {
        final decoded = jsonDecode(request!);
        if (decoded is Map<String, dynamic>) {
          if (decoded['paymentAmount'] != null) {
            return (decoded['paymentAmount'] as num).toDouble();
          }
          if (decoded['amount'] != null) {
            if (decoded['amount'] is num) {
              return (decoded['amount'] as num).toDouble();
            }
            if (decoded['amount'] is Map && decoded['amount']['value'] != null) {
              return double.tryParse(decoded['amount']['value'].toString()) ?? 0.0;
            }
          }
          if (decoded['transaction_details'] != null &&
              decoded['transaction_details']['gross_amount'] != null) {
            return (decoded['transaction_details']['gross_amount'] as num).toDouble();
          }
          if (decoded['line_items'] != null &&
              decoded['line_items'] is List &&
              (decoded['line_items'] as List).isNotEmpty) {
            final first = decoded['line_items'][0];
            if (first['price_data'] != null && first['price_data']['unit_amount'] != null) {
              return (first['price_data']['unit_amount'] as num).toDouble();
            }
          }
        }
      } catch (_) {}
    }
    return 0.0;
  }

  String get customerDisplayName {
    if ((request ?? '').isNotEmpty) {
      try {
        final decoded = jsonDecode(request!);
        if (decoded is Map<String, dynamic>) {
          if (decoded['viewName'] != null && decoded['viewName'].toString().isNotEmpty) {
            return decoded['viewName'].toString();
          }
          if (decoded['customerVaName'] != null && decoded['customerVaName'].toString().isNotEmpty) {
            return decoded['customerVaName'].toString();
          }
          final fn = decoded['firstName']?.toString() ??
              decoded['customerDetail']?['firstName']?.toString() ??
              '';
          final ln = decoded['lastName']?.toString() ??
              decoded['customerDetail']?['lastName']?.toString() ??
              '';
          final fullName = '$fn $ln'.trim();
          if (fullName.isNotEmpty) return fullName;
        }
      } catch (_) {}
    }
    return '-';
  }

  String get customerPhone {
    final rawPhone = (phone ?? '').trim();
    if (rawPhone.isNotEmpty) {
      return rawPhone.startsWith('0') || rawPhone.startsWith('+')
          ? rawPhone
          : '0$rawPhone';
    }
    if ((request ?? '').isNotEmpty) {
      try {
        final decoded = jsonDecode(request!);
        if (decoded is Map<String, dynamic>) {
          final p = decoded['phone']?.toString() ??
              decoded['phoneNumber']?.toString() ??
              decoded['customerDetail']?['phoneNumber']?.toString() ??
              decoded['customerDetail']?['phone']?.toString();
          if (p != null && p.isNotEmpty) {
            return p.startsWith('0') || p.startsWith('+') ? p : '0$p';
          }
        }
      } catch (_) {}
    }
    return '-';
  }

  String get customerEmail {
    final rawEmail = (email ?? '').trim();
    if (rawEmail.isNotEmpty) return rawEmail;
    if ((request ?? '').isNotEmpty) {
      try {
        final decoded = jsonDecode(request!);
        if (decoded is Map<String, dynamic>) {
          final e = decoded['email']?.toString() ??
              decoded['customerDetail']?['email']?.toString();
          if (e != null && e.isNotEmpty) return e;
        }
      } catch (_) {}
    }
    return '-';
  }

  String get customerAddress {
    final rawAddress = (address ?? '').trim();
    if (rawAddress.isNotEmpty) return rawAddress;
    if ((request ?? '').isNotEmpty) {
      try {
        final decoded = jsonDecode(request!);
        if (decoded is Map<String, dynamic>) {
          final a = decoded['address']?.toString() ??
              decoded['customerDetail']?['billingAddress']?['address']?.toString() ??
              decoded['customerDetail']?['shippingAddress']?['address']?.toString();
          if (a != null && a.isNotEmpty) return a;
        }
      } catch (_) {}
    }
    return '-';
  }

  String get orderNotes {
    final rawNotes = (notes ?? '').trim();
    if (rawNotes.isNotEmpty) return rawNotes;
    if ((request ?? '').isNotEmpty) {
      try {
        final decoded = jsonDecode(request!);
        if (decoded is Map<String, dynamic>) {
          final n = decoded['productDetails']?.toString() ??
              decoded['productDetail']?.toString() ??
              decoded['description']?.toString() ??
              decoded['itemDetails']?[0]?['name']?.toString();
          if (n != null && n.isNotEmpty) return n;
        }
      } catch (_) {}
    }
    return 'Item';
  }
}
