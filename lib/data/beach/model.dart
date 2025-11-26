class Beach {
    final int id;
    final int villageId;
    final String name;
    final Map<String, dynamic>? extra;
    final String? logoUrl;
    final List<String>? gallery;
    final String address;
    final double? latitude;
    final double? longitude;
    final DateTime createdAt;
    final DateTime updatedAt;
    final String villageName;

    Beach({
        required this.id,
        required this.villageId,
        required this.name,
        required this.extra,
        required this.logoUrl,
        required this.gallery,
        required this.address,
        required this.latitude,
        required this.longitude,
        required this.createdAt,
        required this.updatedAt,
        required this.villageName,
    });

    factory Beach.fromJson(Map<String, dynamic> json) {

        final extraMap = json['extra'] != null
            ? Map<String, dynamic>.from(json['extra'])
            : null;

        final galleryList = json['gallery'] != null
            ? List<String>.from(json['gallery'])
            : null;

        return Beach(
          id: json['id'],
          villageId: json['village_id'],
          name: json['name'],
          extra: extraMap,
          logoUrl: json['logo_url'],
          gallery: galleryList,
          address: json['address'],
          latitude: json['latitude'] == null ? null : double.tryParse(json['latitude'].toString()),
          longitude: json['longitude'] == null ? null : double.tryParse(json['longitude'].toString()),
          createdAt: DateTime.parse(json['created_at']),
          updatedAt: DateTime.parse(json['updated_at']),
          villageName: json['village_name'],
        );
    }
}
