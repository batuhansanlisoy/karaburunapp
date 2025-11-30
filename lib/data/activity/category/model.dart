class ActivityCategory {
    final int id;
    final String name;
    final DateTime createdAt;
    final DateTime updatedAt;

    ActivityCategory({
        required this.id,
        required this.name,
        required this.createdAt,
        required this.updatedAt,
    });

    factory ActivityCategory.fromJson(Map<String, dynamic> json) {
        return ActivityCategory(
          id: json['id'],
          name: json['name'],
          createdAt: DateTime.parse(json['created_at']),
          updatedAt: DateTime.parse(json['updated_at']),
        );
    }
}
