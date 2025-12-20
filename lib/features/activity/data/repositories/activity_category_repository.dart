import '../models/activity_category_model.dart';
import '../services/activity_category_service.dart';

class ActivityCategoryRepository {
  final ActivityCategoryService _service = ActivityCategoryService();

  Future<List<ActivityCategory>> fetchCategories() {
    return _service.getCategories();
  }
}