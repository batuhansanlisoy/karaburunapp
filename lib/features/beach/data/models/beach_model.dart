import 'dart:convert';

class Beach {
    final int id;
    final int villageId;
    final String name;
    final Map<String, dynamic>? extra;
    final Map<String, dynamic>? cover;
    final List<String>? gallery;
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
        required this.address,
        required this.latitude,
        required this.longitude,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Beach.fromJson(Map<String, dynamic> json) {

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

        return Beach(
          id: json['id'],
          villageId: json['village_id'],
          name: json['name'],
          extra: extraMap,
          cover: coverMap,
          gallery: galleryList,
          address: json['address'],
          latitude: json['latitude'] == null ? null : double.tryParse(json['latitude'].toString()),
          longitude: json['longitude'] == null ? null : double.tryParse(json['longitude'].toString()),
          createdAt: DateTime.parse(json['created_at']),
          updatedAt: DateTime.parse(json['updated_at'])
        );
    }
}
