import 'dart:convert';

class Organization {
  final int id;
  final int categoryId;
  final String name;
  final String email;
  final String phone;
  final String? content; // backend string ya da null
  final String? website;
  final Map<String, dynamic>? cover;
  final String? gallery; // backend string ya da null
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
    required this.cover,
    required this.gallery,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryName,
  });


  factory Organization.fromJson(Map<String, dynamic> json) {
    // content ve gallery null ise null bırakıyoruz, değilse string olarak alıyoruz
    final contentString = json['content'] !=null ? json['content'].toString() : null;
    final galleryString = json['gallery'] !=null ? json['gallery'].toString() : null;

    Map<String, dynamic>? coverMap;
    if (json['cover'] != null) {
      try {
        final decoded = jsonDecode(json['cover']);
        if (decoded is Map<String, dynamic>) {
          coverMap = decoded;
        }
      } catch (e) {
        coverMap = null;
      }
    }

    return Organization(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      content: contentString,
      website: json['website'],
      cover: coverMap,
      gallery: galleryString,
      address: json['address'],
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      categoryName: json['category_name'] ?? '',
    );
  }
}
