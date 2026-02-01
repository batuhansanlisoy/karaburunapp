import 'package:karaburun/features/beach/data/models/beach_activity_distance_model.dart';
import '../services/beach_activity_distance_service.dart';

class BeachActivityDistanceRepository {
    final BeachActivityDistanceService _service = BeachActivityDistanceService();

    Future<List<BeachActivityDistanceModel>> fetchNearestActivities({
      required int beachId,
    }) {
        return _service.getNearestActivities(
            beachId: beachId
        );
    }
}