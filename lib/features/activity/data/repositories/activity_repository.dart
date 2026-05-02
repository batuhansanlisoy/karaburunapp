import '../models/activity_model.dart';
import '../services/activiy_service.dart';

class ActivityRepository {
    final ActivityService _service = ActivityService();

    Future<List<Activity>> fetchActivity({
        int? villageId,
        int? categoryId,
        List<int>? ids,
    }) {
        return _service.getActivity(
            villageId: villageId,
            categoryId: categoryId,
            ids: ids,
        );
    }
}