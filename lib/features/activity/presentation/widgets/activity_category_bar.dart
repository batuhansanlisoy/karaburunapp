import 'package:flutter/material.dart';
import '../../data/models/activity_category_model.dart';
import 'package:karaburun/utils/string_helpers.dart';
import 'package:karaburun/core/widgets/app_chip.dart';

class ActivityCategoryBar extends StatelessWidget {
  final List<ActivityCategory> categories;
  final int? selectedCategoryId;
  final Function(int?) onSelect;

  const ActivityCategoryBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length + 1,
        itemBuilder: (_, i) {
          if (i == 0) {
            final isSelected = selectedCategoryId == null;
            return AppChip(
              title: "Hepsi",
              isSelected: isSelected,
              onTap: () => onSelect(null),
            );
          }

          final ct = categories[i - 1];
          final isSelected = selectedCategoryId == ct.id;

          return AppChip(
            title: ct.name.capitalize(),
            isSelected: isSelected,
            onTap: () => onSelect(ct.id),
          );
        },
      ),
    );
  }
}
