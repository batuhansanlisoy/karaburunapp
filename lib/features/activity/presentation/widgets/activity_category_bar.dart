import 'package:flutter/material.dart';
import '../../data/models/activity_category_model.dart';
import 'package:karaburun/utils/string_helpers.dart';

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
        itemCount: categories.length + 1, // 🔥 Hepsi
        itemBuilder: (_, i) {
          // 🔥 HEPSİ
          if (i == 0) {
            final isSelected = selectedCategoryId == null;
            return _chip(
              title: "Hepsi",
              isSelected: isSelected,
              onTap: () => onSelect(null),
            );
          }

          final ct = categories[i - 1];
          final isSelected = selectedCategoryId == ct.id;

          return _chip(
            title: ct.name.capitalize(),
            isSelected: isSelected,
            onTap: () => onSelect(ct.id),
          );
        },
      ),
    );
  }

  Widget _chip({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(right: 12, top: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 216, 66, 66)
              : const Color.fromARGB(255, 56, 101, 160),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
