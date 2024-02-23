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
  String? request;
  String? response;
  String? callback;
  String url;
  DateTime? createdAt;
  DateTime? updatedAt;
  PaymentMethod? paymentMethods;
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
    required this.request,
    required this.response,
    required this.callback,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentMethods,
    required this.project,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        id: json["id"],
        type: json["type"],
        status: json["status"],
        reference: json["reference"],
        mode: json["mode"],
        address: json["address"],
        phone: json["phone"],
        email: json["email"],
        notes: json["notes"],
        paymentMethod: json["payment_method"],
        request: json["request"],
        response: json["response"],
        callback: json["callback"],
        url: json["url"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        paymentMethods: json["payment_methods"] == null
            ? null
            : PaymentMethod.fromJson(json["payment_methods"]),
        project: json["project"] == null
            ? null
            : Project.fromJson(
                json["project"],
              ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "status": status,
        "reference": reference,
        "mode": mode,
        'address': address,
        'phone': phone,
        'email': email,
        'notes': notes,
        "payment_method": paymentMethod,
        "request": request,
        "response": response,
        "callback": callback,
        "url": url,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "payment_methods": paymentMethods?.toJson(),
        "project": project?.toJson(),
      };
}
