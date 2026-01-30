import 'package:karaburun/features/activity/data/models/activity_beach_distance_model.dart';
import '../services/activity_beach_distance_service.dart';

class ActivityBeachDistanceRepository {
    final ActivityBeachDistanceService _service = ActivityBeachDistanceService();

    Future<List<ActivityBeachDistance>> fetchActivity({
      required int activityId,
    }) {
        return _service.getNearestBeaches(
            activityId: activityId
        );
    }
}