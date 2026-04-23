import '../models/village_model.dart';
import '../services/village_service.dart';

class VillageRepository {
  final VillageService _service = VillageService();

  static List<Village>? _cachedVillages;

  Future<List<Village>> fetchVillages() async{
    
    if (_cachedVillages != null && _cachedVillages!.isNotEmpty) {
      return _cachedVillages!;
    }

    try {
      final villages = await _service.getVillages();
      _cachedVillages = villages;

      return _cachedVillages!;
    } catch (e) {
      rethrow;
    }
  }

  void clearCache() {
    _cachedVillages = null;
  }
}
