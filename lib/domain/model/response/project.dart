class Project {
  int id;
  String name;
  String type;
  String key;
  String secure;
  String value;
  String callback;
  DateTime? createdAt;
  DateTime? updatedAt;
  String slug;

  Project({
    required this.id,
    required this.name,
    required this.type,
    required this.key,
    required this.secure,
    required this.value,
    required this.callback,
    required this.createdAt,
    required this.updatedAt,
    required this.slug,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        key: json['key'],
        secure: json['secure'],
        value: json['value'],
        callback: json['callback'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        slug: json['slug'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'key': key,
        'secure': secure,
        'value': value,
        'callback': callback,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'slug': slug,
      };
  ProjectType get projectType {
    switch (slug) {
      case 'spnpay':
        return ProjectType.spnpay;
      case 'duitku':
        return ProjectType.duitku;
      case 'midtrans':
        return ProjectType.midtrans;
      default:
    }
    return ProjectType.spnpay;
  }
}

enum ProjectType {
  spnpay,
  duitku,
  midtrans,
  xendit,
}
