class Project {
  int id;
  String name;
  String type;
  String? key;
  String? secure;
  String value;
  String callback;
  DateTime? createdAt;
  DateTime? updatedAt;
  String slug;

  Project({
    required this.id,
    required this.name,
    required this.type,
    this.key,
    this.secure,
    required this.value,
    required this.callback,
    this.createdAt,
    this.updatedAt,
    required this.slug,
  });

  factory Project.fromJson(dynamic rawJson) {
    if (rawJson == null || rawJson is! Map) {
      return Project(
        id: 0,
        name: '',
        type: '',
        value: '',
        callback: '',
        slug: 'duitku',
      );
    }
    final json = Map<String, dynamic>.from(rawJson);
    return Project(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      key: json['key']?.toString(),
      secure: json['secure']?.toString(),
      value: json['value']?.toString() ?? '',
      callback: json['callback']?.toString() ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'].toString()),
      slug: json['slug']?.toString() ?? 'duitku',
    );
  }

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
    switch (slug.toLowerCase()) {
      case 'spnpay':
        return ProjectType.spnpay;
      case 'duitku':
        return ProjectType.duitku;
      case 'midtrans':
        return ProjectType.midtrans;
      case 'xendit':
        return ProjectType.xendit;
      case 'stripe':
        return ProjectType.stripe;
      case 'paprika':
        return ProjectType.paprika;
      default:
        return ProjectType.spnpay;
    }
  }
}

enum ProjectType {
  spnpay,
  duitku,
  midtrans,
  xendit,
  stripe,
  paprika,
}
