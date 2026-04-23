import '../models/activity_category_model.dart';
import '../services/activity_category_service.dart';

class ActivityCategoryRepository {
  final ActivityCategoryService _service = ActivityCategoryService();

  static List<ActivityCategory>? _cachedActivityCategories;

  Future<List<ActivityCategory>> fetchCategories() async{

    if (_cachedActivityCategories != null && _cachedActivityCategories!.isNotEmpty) {
      return _cachedActivityCategories!;
    }

    try {
      final categories = await _service.getCategories();
      _cachedActivityCategories = categories;

      return _cachedActivityCategories!;
    } catch (e) {
      rethrow;
    }
  }

  void clearCache() {
    _cachedActivityCategories = null;
  }
}