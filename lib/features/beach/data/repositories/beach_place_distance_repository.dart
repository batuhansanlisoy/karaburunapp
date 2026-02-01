import 'package:karaburun/features/beach/data/models/beach_place_distance_model.dart';
import '../services/beach_place_distance_service.dart';

class BeachPlaceDistanceRepository {
    final BeachPlaceDistanceService _service = BeachPlaceDistanceService();

    Future<List<BeachPlaceDistanceModel>> fetchNearestPlaces({
      required int beachId,
    }) {
        return _service.getNearestPlaces(
            beachId: beachId
        );
    }
}