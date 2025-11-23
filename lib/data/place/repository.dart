import 'model.dart';
import 'service.dart';

class PlaceRepository {
  final PlaceService _service = PlaceService();

  Future<List<Place>> fetchPlaces() {
    return _service.getPlaces();
  }
}
