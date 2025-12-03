import 'dart:convert';

class Activity {
  final int id;
  final int villageId;
  final String name;
  final Content? content; // <-- Burayı Map yerine Content objesi yaptık
  final Map<String, dynamic>? cover; // Bu aynı kaldı
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
    required this.cover,
    required this.gallery,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {

    // content
    Content? content;
    if (json['content'] != null) {
      content = Content.fromJson(Map<String, dynamic>.from(json['content']));
    }

    Map<String, dynamic>? coverMap;
    if (json['cover'] != null) {
      try {
        final decoded = jsonDecode(json['cover']);
        if (decoded is Map<String, dynamic>) {
          coverMap = decoded;
        }
      } catch (e) {
        coverMap = null;
      }
    }

    // gallery
    final galleryList = json['gallery'] != null
        ? List<String>.from(json['gallery'])
        : null;

    return Activity(
      id: json['id'],
      villageId: json['village_id'],
      name: json['name'],
      content: content,
      cover: coverMap,
      gallery: galleryList,
      address: json['address'],
      latitude: json['latitude'] == null
          ? null
          : double.tryParse(json['latitude'].toString()),
      longitude: json['longitude'] == null
          ? null
          : double.tryParse(json['longitude'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Content {
  final String? explanation;
  final List<DayTimeline>? timeline;

  Content({this.explanation, this.timeline});

  factory Content.fromJson(Map<String, dynamic> json) {
    List<DayTimeline>? timeline;
    if (json['timeline'] != null) {
      timeline = (json['timeline'] as List)
          .map((e) => DayTimeline.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return Content(
      explanation: json['explanation'],
      timeline: timeline,
    );
  }
}

class DayTimeline {
  final String date;
  final List<Event> events;

  DayTimeline({required this.date, required this.events});

  factory DayTimeline.fromJson(Map<String, dynamic> json) {
    List<Event> events = [];
    if (json['events'] != null) {
      events = (json['events'] as List)
          .map((e) => Event.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return DayTimeline(
      date: json['date'],
      events: events,
    );
  }
}

class Event {
  final String time;
  final String title;

  Event({required this.time, required this.title});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      time: json['time'],
      title: json['title'],
    );
  }
}
