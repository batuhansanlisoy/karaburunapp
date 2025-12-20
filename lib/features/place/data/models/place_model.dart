import 'dart:convert';

class Place {
  final int id;
  final int villageId;
  final String name;
  final Content? content;
  final Map<String, dynamic>? cover; // Bu aynı kaldı
  final List<String>? gallery;
  final String address;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String villageName;

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
    required this.updatedAt,
    required this.villageName
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    
    Content? content;
    if(json['content'] != null) {
      content = Content.fromJson(Map<String, dynamic>.from(json['content']));
    }

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

    // gallery null değilse decode et
    final galleryList = json["gallery"] != null
        ? List<String>.from(jsonDecode(json["gallery"]))
        : null;

    return Place(
      id: json["id"],
      villageId: json["village_id"],
      name: json["name"],
      content: content,
      cover: coverMap,
      gallery: galleryList,
      address: json["address"],
      latitude: json["latitude"] != null ? double.tryParse(json["latitude"].toString()) : null,
      longitude: json["longitude"] != null ? double.tryParse(json["longitude"].toString()) : null,
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      villageName: json['name'],
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
