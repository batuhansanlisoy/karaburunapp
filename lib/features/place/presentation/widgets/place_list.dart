import 'package:flutter/material.dart';
import 'package:karaburun/features/place/data/models/place_model.dart';
import 'package:karaburun/core/widgets/app_card.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/utils/string_helpers.dart'; // benim oluşturdugum bir yardımcı

class PlaceList extends StatelessWidget {
  final List<Place> list;
  final String baseUrl;
  final Map<int ,Village> villageMap;
  final Function(Place) onTap;

  const PlaceList({
    super.key,
    required this.list,
    required this.baseUrl,
    required this.villageMap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final item = list[i];
        final village = villageMap[item.villageId];

        return AppCard(
          title: item.name.capitalizeAll(),
          address: item.address.capitalize(),
          imageUrl: item.cover != null ? "$baseUrl${item.cover!['url']}" : null,
          villageName: village?.name,
          onTap: () => onTap(item),
        );
      },
    );
  }
}
