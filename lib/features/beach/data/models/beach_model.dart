import 'dart:convert';

class Beach {
    final int id;
    final int villageId;
    final String name;
    final Map<String, dynamic>? extra;
    final Map<String, dynamic>? cover;
    final List<String>? gallery;
    final bool highlight;
    final String address;
    final double? latitude;
    final double? longitude;
    final DateTime createdAt;
    final DateTime updatedAt;

    Beach({
        required this.id,
        required this.villageId,
        required this.name,
        required this.extra,
        required this.cover,
        required this.gallery,
        required this.highlight,
        required this.address,
        required this.latitude,
        required this.longitude,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Beach.fromJson(Map<String, dynamic> json) {
      Map<String, dynamic>? coverMap;
      if (json['cover'] != null) {
        if (json['cover'] is Map<String, dynamic>) {
          coverMap = json['cover'];
        } else if (json['cover'] is String) {
          try {
            coverMap = jsonDecode(json['cover']);
          } catch (e) {
            coverMap = null;
          }
        }
      }

      List<String>? galleryList;
      if (json['gallery'] != null && json['gallery'] is List) {
        galleryList = (json['gallery'] as List)
            .map((item) => item.toString())
            .toList();
      }

      return Beach(
        id: json['id'] as int,
        villageId: json['village_id'] as int,
        name: json['name'] as String,
        extra: json['extra'] is Map<String, dynamic> ? json['extra'] : null,
        cover: coverMap,
        gallery: galleryList,
        // Backend'den 1 veya 0 gelirse diye sağlama alıyoruz
        highlight: json['highlight'] == 1 || json['highlight'] == true,
        address: json['address'] ?? '',
        latitude: double.tryParse(json['latitude']?.toString() ?? ''),
        longitude: double.tryParse(json['longitude']?.toString() ?? ''),
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
    }
}
