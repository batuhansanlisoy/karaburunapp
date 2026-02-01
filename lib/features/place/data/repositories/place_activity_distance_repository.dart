import 'package:karaburun/features/place/data/models/place_activity_distance_model.dart';
import '../services/place_activity_distance_service.dart';

class PlaceActivityDistanceRepository {
    final PlaceActivityDistanceService _service = PlaceActivityDistanceService();

    Future<List<PlaceActivityDistanceModel>> fetchNearestActivities({
      required int placeId,
    }) {
        return _service.getNearestActivities(
            placeId: placeId
        );
    }
}