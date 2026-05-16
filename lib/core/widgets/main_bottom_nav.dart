import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class MainBottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const MainBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 45 + bottomPadding,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Symbols.home_rounded),
            _buildNavItem(1, Symbols.bookmark_rounded),
            _buildNavItem(2, Symbols.travel_explore_rounded),
            _buildNavItem(3, Symbols.settings_rounded),
          ],
        ),
      )
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          size: 26,
          weight: 700,
          grade: 40,
          fill: 1,
          color: Colors.white,
        ),
      ),
    );
  }
}