import '../models/local_producer_model.dart';
import '../services/local_producer_service.dart';

class LocalProducerRepository {
  final LocalProducerService _service = LocalProducerService();

  Future<List<LocalProducerModel>> fetchLocalProducer({ 
    bool? isActive,
    bool? highlight,
    int? villageId
  }) {
    return _service.getLocalProducer(
      isActive: isActive,
      highlight: highlight,
      villageId: villageId);
  }
}