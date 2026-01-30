class ActivityBeachDistance {
  final int id;
  final int activityId;
  final int organizationId;
  final double distanceMeter;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActivityBeachDistance({
    required this.id,
    required this.activityId,
    required this.organizationId,
    required this.distanceMeter,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON'dan model nesnesi oluşturma
  factory ActivityBeachDistance.fromJson(Map<String, dynamic> json) {
    return ActivityBeachDistance(
      id: json['id'] as int,
      activityId: json['activity_id'] as int,
      organizationId: json['organization_id'] as int,
      distanceMeter: (json['distance_meter'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
