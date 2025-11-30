import 'model.dart';
import 'service.dart';

class ActivityRepository {
  final ActivityService _service = ActivityService();

  Future<List<Activity>> fetchActivity({
    int? villageId,
    int? categoryId
  }) {
    return _service.getActivity(
      villageId: villageId,
      categoryId: categoryId
    );
  }
}