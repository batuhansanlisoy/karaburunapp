import 'model.dart';
import 'service.dart';

class BeachRepository {
  final BeachService _service = BeachService();

  Future<List<Beach>> fetchBeachs() {
    return _service.getBeach();
  }
}