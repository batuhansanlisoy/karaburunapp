import 'package:flutter/material.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  final NotificationRepository _repository = NotificationRepository();
  late Future<List<NotificationModel>> _notificationFuture;

  @override
  void initState() {
    super.initState();
    // Sayfa ilk açıldığında veriyi çekmeye başla
    _notificationFuture = _repository.fetchNotification(isActive: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Bildirimler",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
          ),
          Expanded(
            child: FutureBuilder<List<NotificationModel>>(
              future: _notificationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Veriler yüklenirken bir hata oluştu."),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("Henüz bir bildiriminiz bulunmuyor."),
                  );
                }

                final notifications = snapshot.data!;

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      leading: const CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.iconOrange,
                        child: Icon(
                          Symbols.notifications_rounded,
                          color: Colors.white,
                          size: 20,
                          weight: 700,
                          grade: 0,
                          fill: 1,
                          opticalSize: 24
                        ),
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMain
                        ),
                      ),
                      subtitle: Text(
                        item.message,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textMuted
                        ),
                      ),
                      onTap: () {
                        // Bildirim detayına gitmek istersen burayı kullanabilirsin
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}