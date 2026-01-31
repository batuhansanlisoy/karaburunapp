class ActivityPlaceDistanceModel {
  final int id;
  final int activityId;
  final int placeId;
  final double distanceMeter;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActivityPlaceDistanceModel({
    required this.id,
    required this.activityId,
    required this.placeId,
    required this.distanceMeter,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON'dan model nesnesi oluşturma
  factory ActivityPlaceDistanceModel.fromJson(Map<String, dynamic> json) {
    return ActivityPlaceDistanceModel(
      id: json['id'] as int,
      activityId: json['activity_id'] as int,
      placeId: json['place_id'] as int,
      distanceMeter: (json['distance_meter'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
