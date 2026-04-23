import 'package:flutter/material.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/core/widgets/app_chip.dart';
import 'package:karaburun/utils/string_helpers.dart';

class VillageBar extends StatelessWidget {
  final List<Village> villages;
  final int? selectedVillageId;
  final Function(int?) onSelect;

  const VillageBar({
    super.key,
    required this.villages,
    required this.selectedVillageId,
    required this.onSelect
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: villages.length + 1, //hepsi için
        itemBuilder: (_, i) {
          if (i==0) {
            final isSelected = selectedVillageId == null;
            return AppChip(
              title: "Hepsi",
              isSelected: isSelected,
              onTap: () => onSelect(null),
            );
          }
          final village = villages[i-1];
          final isSelected = selectedVillageId == village.id;

          return AppChip(
            title: village.name.capitalize(),
            isSelected: isSelected,
            onTap: () => onSelect(village.id)
          );
        },
      ),
    );
  }
}

