import 'dart:convert';

import 'package:karaburun/features/organization/data/models/organization_subcategory_model.dart';

class OrganizationModel {
  final int id;
  final int categoryId;
  final int? villageId;
  final String name;
  final String email;
  final String phone;
  final Map<String, dynamic>? content;
  final String? website;
  final Map<String, dynamic>? cover;
  final List<String> ? gallery;
  final bool highlight;
  final bool isActive;
  final String address;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String categoryName;
  final List<OrganizationSubcategoryModel>? subCategories;

  OrganizationModel({
    required this.id,
    required this.categoryId,
    this.villageId,
    required this.name,
    required this.email,
    required this.phone,
    required this.content,
    required this.website,
    required this.cover,
    required this.gallery,
    required this.address,
    required this.highlight,
    required this.isActive,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryName,
    this.subCategories
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    
    final contentMap = json['content'] != null
      ? Map<String, dynamic>.from(json['content'])
      : null;
    
    final subCategoriesList = json['sub_categories'] != null
      ? (json['sub_categories'] as List)
          .map((i) => OrganizationSubcategoryModel.fromJson(i))
          .toList()
      : null;

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

    final galleryList = json['gallery'] != null
      ? List<String>.from(json['gallery'])
      : null;

    return OrganizationModel(
      id: json['id'],
      categoryId: json['category_id'],
      villageId: json['village_id'] != null ? int.tryParse(json['village_id'].toString()) : null,
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      content: contentMap,
      website: json['website'],
      cover: coverMap,
      gallery: galleryList,
      highlight: json['highlight'] == true || json['highlight'] == 1,
      isActive: json['is_active'] == true || json['is_active'] == 1,
      address: json['address'],
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      categoryName: json['category_name'] ?? '',
      subCategories: subCategoriesList
    );
  }
}