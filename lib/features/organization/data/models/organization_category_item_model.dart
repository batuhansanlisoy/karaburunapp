class OrganizationCategoryItemModel {
  final int id;
  final String name;
  final int organizationCategoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrganizationCategoryItemModel({
    required this.id,
    required this.name,
    required this.organizationCategoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrganizationCategoryItemModel.fromJson(Map<String, dynamic> json) {

    return OrganizationCategoryItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      organizationCategoryId: json['organization_category_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
