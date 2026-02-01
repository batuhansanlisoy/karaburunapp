class BeachPlaceDistanceModel {
  final int id;
  final int beachId;
  final int placeId;
  final double distanceMeter;
  final DateTime createdAt;
  final DateTime updatedAt;

  BeachPlaceDistanceModel({
    required this.id,
    required this.beachId,
    required this.placeId,
    required this.distanceMeter,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON'dan model nesnesi oluşturma
  factory BeachPlaceDistanceModel.fromJson(Map<String, dynamic> json) {
    return BeachPlaceDistanceModel(
      id: json['id'] as int,
      beachId: json['beach_id'] as int,
      placeId: json['place_id'] as int,
      distanceMeter: (json['distance_meter'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
