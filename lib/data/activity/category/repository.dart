import 'model.dart';
import 'service.dart';

class ActivityCategoryRepository {
  final ActivityCategoryService _service = ActivityCategoryService();

  Future<List<ActivityCategory>> fetchCategories() {
    return _service.getCategories();
  }
}