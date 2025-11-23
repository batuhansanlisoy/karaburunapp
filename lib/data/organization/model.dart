class Organization {
  final int id;
  final int categoryId;
  final String name;
  final String email;
  final String phone;
  final String? content;
  final String? website;
  final String? logoUrl;
  final String? gallery;
  final String address;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String categoryName;

  Organization({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.email,
    required this.phone,
    required this.content,
    required this.website,
    required this.logoUrl,
    required this.gallery,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryName,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      content: json['content'],
      website: json['website'],
      logoUrl: json['logo_url'],
      gallery: json['gallery'],
      address: json['address'],
      latitude: json['latitude'] == null ? null : double.tryParse(json['latitude'].toString()),
      longitude: json['longitude'] == null ? null : double.tryParse(json['longitude'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      categoryName: json['category_name'],
    );
  }
}
