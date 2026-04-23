import 'dart:convert';

class LocalProducerModel {
    final int id;
    final String name;
    final String? email;
    final String phone;
    final String title;
    final Map<String, dynamic>? extra;
    final int villageId;
    final String address;
    final bool isActive;
    final bool highlight;
    final Map<String, dynamic>? cover;
    final List<String>? gallery;
    final DateTime createdAt;
    final DateTime updatedAt;

    LocalProducerModel({
        required this.id,
        required this.name,
        this.email,
        required this.phone,
        required this.title,
        required this.extra,
        required this.villageId,
        required this.address,
        required this.isActive,
        required this.highlight,
        required this.cover,
        required this.gallery,
        required this.createdAt,
        required this.updatedAt,
    });

    factory LocalProducerModel.fromJson(Map<String, dynamic> json) {

        final extraMap = json['extra'] != null
            ? Map<String, dynamic>.from(json['extra'])
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

        return LocalProducerModel(
          id: json['id'],
          name: json['name'],
          email: json['email'],
          phone: json['phone'],
          title: json['title'],
          extra: extraMap,
          villageId: json['village_id'],
          address: json['address'],
          isActive: json['is_active'] == true || json['is_active'] == 1,
          highlight: json['highlight'] == true || json['highlight'] == 1,
          cover: coverMap,
          gallery: galleryList,
          createdAt: DateTime.parse(json['created_at']),
          updatedAt: DateTime.parse(json['updated_at'])
        );
    }
}
