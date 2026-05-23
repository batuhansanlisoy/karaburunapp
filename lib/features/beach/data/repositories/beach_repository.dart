import '../models/beach_model.dart';
import '../services/beach_service.dart';

class BeachRepository {
  final BeachService _service = BeachService();

  Future<Beach?> fetchSingleBeach(int beachId) {
    return _service.getSingle(beachId);
  }

  Future<List<Beach>> fetchBeachs({
    int? villageId,
    bool? highlight,
    List<int>? ids,
  }) {
    return _service.getBeach(
      villageId: villageId,
      highlight: highlight,
      ids: ids
    );
  }
}