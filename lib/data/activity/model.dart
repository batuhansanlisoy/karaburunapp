class Activity {
    final int id;
    final int villageId;
    final String name;
    final Map<String, dynamic>? content;
    final String? logoUrl;
    final List<String>? gallery;
    final String address;
    final double? latitude;
    final double? longitude;
    final DateTime createdAt;
    final DateTime updatedAt;

    Activity({
        required this.id,
        required this.villageId,
        required this.name,
        required this.content,
        required this.logoUrl,
        required this.gallery,
        required this.address,
        required this.latitude,
        required this.longitude,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Activity.fromJson(Map<String, dynamic> json) {

        final content = json['content'] != null
            ? Map<String, dynamic>.from(json['content'])
            : null;

        final galleryList = json['gallery'] != null
            ? List<String>.from(json['gallery'])
            : null;

        return Activity(
          id: json['id'],
          villageId: json['village_id'],
          name: json['name'],
          content: content,
          logoUrl: json['logo_url'],
          gallery: galleryList,
          address: json['address'],
          latitude: json['latitude'] == null ? null : double.tryParse(json['latitude'].toString()),
          longitude: json['longitude'] == null ? null : double.tryParse(json['longitude'].toString()),
          createdAt: DateTime.parse(json['created_at']),
          updatedAt: DateTime.parse(json['updated_at']),
        );
    }
}
