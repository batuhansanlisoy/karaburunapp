class OrganizationSubcategoryModel {
  final int id;
  final int itemId;
  final int organizationId;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrganizationSubcategoryModel({
    required this.id,
    required this.itemId,
    required this.organizationId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrganizationSubcategoryModel.fromJson(Map<String, dynamic> json) {

    return OrganizationSubcategoryModel(
      id: json['id'] as int,
      itemId: json['item_id'] as int,
      organizationId: json['organization_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
