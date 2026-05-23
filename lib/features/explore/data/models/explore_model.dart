class ExploreModel {
    final int id;
    final String itemType;
    final int itemId;
    final String title;
    final String videoUrl;
    final int score;
    final bool isActive;
    final DateTime createdAt;
    final DateTime updatedAt;

    ExploreModel({
        required this.id,
        required this.itemType,
        required this.itemId,
        required this.title,
        required this.videoUrl,
        required this.score,
        required this.isActive,
        required this.createdAt,
        required this.updatedAt,
    });

    factory ExploreModel.fromJson(Map<String, dynamic> json) {
        return ExploreModel(
          id: json['id'],
          itemType: json['item_type'],
          itemId: json['item_id'],
          title: json['title'],
          videoUrl: json['video_url'],
          score: json['score'],
          isActive: json['is_active'] == 1 || json['is_active'] == true,
          createdAt: DateTime.parse(json['created_at']),
          updatedAt: DateTime.parse(json['updated_at'])
        );
    }
}
