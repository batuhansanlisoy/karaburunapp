import '../models/beach_model.dart';
import '../services/beach_service.dart';

class BeachRepository {
  final BeachService _service = BeachService();

  Future<List<Beach>> fetchBeachs() {
    return _service.getBeach();
  }
}