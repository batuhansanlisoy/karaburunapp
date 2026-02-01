class PlaceActivityDistanceModel {
  final int id;
  final int placeId;
  final int activityId;
  final double distanceMeter;
  final DateTime createdAt;
  final DateTime updatedAt;

  PlaceActivityDistanceModel({
    required this.id,
    required this.placeId,
    required this.activityId,
    required this.distanceMeter,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON'dan model nesnesi oluşturma
  factory PlaceActivityDistanceModel.fromJson(Map<String, dynamic> json) {
    return PlaceActivityDistanceModel(
      id: json['id'] as int,
      placeId: json['place_id'] as int,
      activityId: json['activity_id'] as int,
      distanceMeter: (json['distance_meter'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
