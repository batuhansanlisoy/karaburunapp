import '../models/place_model.dart';
import '../services/place_service.dart';

class PlaceRepository {
  final PlaceService _service = PlaceService();

  Future<Place?> fetchSinglePlace(int placeId) {
    return _service.getSingle(placeId);
  }

  Future<List<Place>> fetchPlaces({ int? villageId, List<int>? ids }) {
    return _service.getPlaces(
      villageId: villageId,
      ids: ids
    );
  }
}
