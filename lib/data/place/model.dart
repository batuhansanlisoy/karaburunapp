import 'dart:convert';

class Place {
  final int id;
  final int villageId;
  final String name;
  final String explanation;
  final String detail;
  final String? logoUrl;
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
    required this.explanation,
    required this.detail,
    required this.logoUrl,
    required this.gallery,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.villageName
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    // content JSON'unu decode et
    final contentMap = jsonDecode(json["content"]);

    // gallery null değilse decode et
    final galleryList = json["gallery"] != null
        ? List<String>.from(jsonDecode(json["gallery"]))
        : null;

    return Place(
      id: json["id"],
      villageId: json["village_id"],
      name: json["name"],
      explanation: contentMap["explanation"] ?? "",
      detail: contentMap["detail"] ?? "",
      logoUrl: json["logo_url"],
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
