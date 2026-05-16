import 'package:flutter/material.dart';
import 'package:karaburun/features/activity/data/models/activity_category_model.dart';
import 'package:karaburun/features/activity/data/models/activity_model.dart';
import 'package:karaburun/features/activity/data/repositories/activity_category_repository.dart';
import 'package:karaburun/features/activity/data/repositories/activity_repository.dart';

class ActivityController {
  final ActivityRepository _repository = ActivityRepository();
  final ActivityCategoryRepository _activityCategoryRepository = ActivityCategoryRepository();

  // En yakın etkinliği getiren ana fonksiyon
  Future<List<Activity>> getUpcomingEvents() async {
    try {
      final List<Activity> data = await _repository.fetchActivity();
      if (data.isEmpty) return [];

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Sadece bugünden sonraki etkinlikleri filtrele ve tarihe göre sırala
      List<Activity> futureEvents = data
          .where((e) => e.end.isAfter(today) || e.end.isAtSameMomentAs(today))
          .toList()
        ..sort((a, b) => a.end.compareTo(b.end));

      return futureEvents;
    } catch (e) {
      debugPrint('ActivityController Hatası: $e');
      return [];
    }
  }

  Future<List<ActivityCategory>> getActivityCategories() async {
  try {
    return await _activityCategoryRepository.fetchCategories(); 
  } catch (e) {
    return [];
  }
}
}