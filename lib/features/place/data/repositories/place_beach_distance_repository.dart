import 'package:karaburun/features/place/data/models/place_beach_distance_model.dart';
import '../services/place_beach_distance_service.dart';

class PlaceBeachDistanceRepository {
    final PlaceBeachDistanceService _service = PlaceBeachDistanceService();

    Future<List<PlaceBeachDistanceModel>> fetchNearestBeaches({
      required int placeId,
    }) {
        return _service.getNearestBeaches(
            placeId: placeId
        );
    }
}