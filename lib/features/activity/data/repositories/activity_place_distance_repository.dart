import '../models/activity_place_distance_model.dart';
import '../services/activity_place_distance_service.dart';

class ActivityPlaceDistanceRepository {
    final ActivityPlaceDistanceService _service = ActivityPlaceDistanceService();

    Future<List<ActivityPlaceDistanceModel>> fetchNearestPlace({
      required int activityId,
    }) {
        return _service.getNearestPlace(
            activityId: activityId
        );
    }
}