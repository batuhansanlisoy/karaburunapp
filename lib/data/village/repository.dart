import 'model.dart';
import 'service.dart';

class VillageRepository {
  final VillageService _service = VillageService();

  Future<List<Village>> fetchVillages() {
    return _service.getVillages();
  }
}
