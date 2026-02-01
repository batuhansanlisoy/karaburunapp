class PlaceBeachDistanceModel {
  final int id;
  final int placeId;
  final int beachId;
  final double distanceMeter;
  final DateTime createdAt;
  final DateTime updatedAt;

  PlaceBeachDistanceModel({
    required this.id,
    required this.placeId,
    required this.beachId,
    required this.distanceMeter,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON'dan model nesnesi oluşturma
  factory PlaceBeachDistanceModel.fromJson(Map<String, dynamic> json) {
    return PlaceBeachDistanceModel(
      id: json['id'] as int,
      placeId: json['place_id'] as int,
      beachId: json['beach_id'] as int,
      distanceMeter: (json['distance_meter'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
