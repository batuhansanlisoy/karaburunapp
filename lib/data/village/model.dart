import 'dart:convert';

class Village {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Village({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      id: json["id"],
      name: json["name"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}
