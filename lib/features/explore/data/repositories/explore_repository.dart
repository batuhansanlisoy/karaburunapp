import '../models/explore_model.dart';
import '../services/explore_service.dart';

class ExploreRepository {
  final ExploreService _service = ExploreService();

  Future<List<ExploreModel>> fetchExploreFeed({ 
      bool? shuffle,
      bool? isActive,
      String? itemType,
      int? itemId,
  }) {
      return _service.getExploreFeed(
        shuffle: shuffle,
        isActive: isActive,
        itemType: itemType,
        itemId: itemId,
      );
    }
}
