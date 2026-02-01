class BeachActivityDistanceModel {
  final int id;
  final int activityId;
  final int beachId;
  final double distanceMeter;
  final DateTime createdAt;
  final DateTime updatedAt;

  BeachActivityDistanceModel({
    required this.id,
    required this.activityId,
    required this.beachId,
    required this.distanceMeter,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON'dan model nesnesi oluşturma
  factory BeachActivityDistanceModel.fromJson(Map<String, dynamic> json) {
    return BeachActivityDistanceModel(
      id: json['id'] as int,
      activityId: json['activity_id'] as int,
      beachId: json['beach_id'] as int,
      distanceMeter: (json['distance_meter'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
