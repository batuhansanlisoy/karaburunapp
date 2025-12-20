import '../models/village_model.dart';
import '../services/village_service.dart';

class VillageRepository {
  final VillageService _service = VillageService();

  Future<List<Village>> fetchVillages() {
    return _service.getVillages();
  }
}
