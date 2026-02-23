import 'package:flutter/material.dart';
import 'package:karaburun/features/activity/data/models/activity_category_model.dart';
import 'package:karaburun/core/widgets/app_card.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import '../../data/models/activity_model.dart';

class ActivityList extends StatelessWidget {
  final List<Activity> list;
  final Map<int, ActivityCategory> categoryMap;
  final Function(Activity) onTap;

  const ActivityList({
    super.key,
    required this.list,
    required this.categoryMap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final item = list[i];
        final category = categoryMap[item.categoryId];
        return AppCard(
          title: item.name,
          address: item.address,
          imageUrl: item.cover?['url'] != null
            ? "${ApiRoutes.fileUrl}${item.cover!['url']}"
            : null,
          categoryName: category?.name,
          // villageId: item.villageId,
          begin: item.begin,
          end: item.end,
          onTap: () => onTap(item),
        );

      },
    );
  }
}
