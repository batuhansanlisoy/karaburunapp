import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const AppChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    // Renkleri AppColors'tan veya doğrudan ColorScheme'den alalım
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(right: 12, top: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.secondary
              : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorScheme.secondary.withOpacity(0.5)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13, // Sığması için sabit tutabiliriz
                ),
          ),
        ),
      ),
    );
  }
}