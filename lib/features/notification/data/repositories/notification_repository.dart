import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationRepository {
  final NotificationService _service = NotificationService();

  Future<List<NotificationModel>> fetchNotification({
    bool? isActive,
    List<int>? ids,
  }) {
    return _service.getNotification(
      isActive: isActive,
      ids: ids
    );
  }
}