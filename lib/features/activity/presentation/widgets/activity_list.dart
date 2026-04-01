import 'package:flutter/material.dart';
import 'package:karaburun/features/activity/data/models/activity_category_model.dart';
import 'package:karaburun/core/widgets/app_card.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/core/helpers/map_launcher.dart';
import '../../data/models/activity_model.dart';

class ActivityList extends StatelessWidget {
  final List<Activity> list;
  final Map<int, ActivityCategory> categoryMap;
  final Map<int, Village> villageMap;
  final Function(Activity) onTap;

  const ActivityList({
    super.key,
    required this.list,
    required this.categoryMap,
    required this.villageMap,
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
          explanation: item.content?.explanation,
          address: item.address,
          imageUrl: item.cover?['url'] != null
            ? "${ApiRoutes.fileUrl}${item.cover!['url']}"
            : null,
          categoryName: category?.name,
          villageName: villageMap[item.villageId]?.name,
          begin: item.begin,
          end: item.end,
          onTap: () => onTap(item),
          onNavigationTap: () => MapLauncher.openMap(context, item.latitude, item.longitude)
        );
      },
    );
  }
}