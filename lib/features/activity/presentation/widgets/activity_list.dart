import 'package:flutter/material.dart';
import '../../data/models/activity_model.dart';
import 'package:karaburun/core/widgets/app_card.dart';

class ActivityList extends StatelessWidget {
  final List<Activity> list;
  final String baseUrl;
  final Function(Activity) onTap;

  const ActivityList({
    super.key,
    required this.list,
    required this.baseUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final item = list[i];
        return AppCard(
          title: item.name,
          address: item.address,
          imageUrl: item.cover != null ? "$baseUrl${item.cover!['url']}" : null,
          onTap: () => onTap(item),
        );
      },
    );
  }
}
