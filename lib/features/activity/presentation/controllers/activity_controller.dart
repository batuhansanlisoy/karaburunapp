import 'package:flutter/material.dart';
import 'package:karaburun/features/activity/data/models/activity_category_model.dart';
import 'package:karaburun/features/activity/data/models/activity_model.dart';
import 'package:karaburun/features/activity/data/repositories/activity_category_repository.dart';
import 'package:karaburun/features/activity/data/repositories/activity_repository.dart';

class ActivityController {
  final ActivityRepository _repository = ActivityRepository();
  final ActivityCategoryRepository _activityCategoryRepository = ActivityCategoryRepository();

  // En yakın etkinliği getiren ana fonksiyon
  Future<Activity?> getUpcomingEvent() async {
    try {
      final List<Activity> data = await _repository.fetchActivity();
      if (data.isEmpty) return null;

      final now = DateTime.now();

      // Mantık (Logic) burada: Filtrele ve Sırala
      List<Activity> futureEvents = data.where((e) => e.begin.isAfter(now)).toList();
      
      // Eğer gelecek etkinlik yoksa, test için en sonuncuyu al (Opsiyonel)
      if (futureEvents.isEmpty) {
        data.sort((a, b) => b.begin.compareTo(a.begin));
        return data.first;
      }

      futureEvents.sort((a, b) => a.begin.compareTo(b.begin));
      return futureEvents.first;
    } catch (e) {
      debugPrint('ActivityController Hatası: $e');
      return null;
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