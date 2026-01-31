import 'package:flutter/material.dart';
import 'package:karaburun/core/widgets/app_card.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import '../../data/models/beach_model.dart';

class BeachList extends StatelessWidget {
  final List<Beach> list;
  final String baseUrl;
  final Map<int, Village> villageMap;

  const BeachList({
    super.key,
    required this.list,
    required this.baseUrl,
    required this.villageMap
  });

 @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final item = list[i];
        final village = villageMap[item.villageId];

        return AppCard(
          title: item.name,
          address: item.address,
          imageUrl: item.cover != null ? "$baseUrl${item.cover!['url']}" : null,
          villageName: village?.name,
        );
      },
    );
  }
}
