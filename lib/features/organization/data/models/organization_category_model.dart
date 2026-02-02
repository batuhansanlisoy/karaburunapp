class OrganizationCategoryModel {
  final int id;
  final String name;
  final Map<String, dynamic> extra;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrganizationCategoryModel({
    required this.id,
    required this.name,
    required this.extra,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrganizationCategoryModel.fromJson(Map<String, dynamic> json) {

    final extraMap = json['extra'] = Map<String, dynamic>.from(json['extra']);

    return OrganizationCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      extra: extraMap,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
