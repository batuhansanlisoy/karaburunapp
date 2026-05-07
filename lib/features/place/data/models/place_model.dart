import 'dart:convert';

class Place {
  final int id;
  final int villageId;
  final String name;
  final Content? content;
  final Map<String, dynamic>? cover;
  final List<String>? gallery;
  final String address;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  Place({
    required this.id,
    required this.villageId,
    required this.name,
    required this.content,
    required this.cover,
    required this.gallery,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt
  });

  factory Place.fromJson(Map<String, dynamic> json) {
  
    Content? content;
    if(json['content'] != null) {
      content = Content.fromJson(Map<String, dynamic>.from(json['content']));
    }

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
          .map((e) => e.toString())
          .toList();
    }

    return Place(
      id: json["id"],
      villageId: json["village_id"],
      name: json["name"],
      content: content,
      cover: coverMap,
      gallery: galleryList,
      address: json["address"] ?? '',
      latitude: json["latitude"] != null ? double.tryParse(json["latitude"].toString()) : null,
      longitude: json["longitude"] != null ? double.tryParse(json["longitude"].toString()) : null,
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}

class Content {
  final String? explanation;
  final String? details;

  Content({this.explanation, this.details});

  factory Content.fromJson(Map<String, dynamic> json) {

    return Content(
      explanation: json['explanation'],
      details: json['details'],
    );
  }
}
