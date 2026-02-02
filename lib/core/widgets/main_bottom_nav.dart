import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

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
    return Container(
      // Marginleri daralttık, alt boşluğu bir tık azalttık
      margin: const EdgeInsets.fromLTRB(40, 0, 40, 20), 
      height: 55, // Yüksekliği 70'ten 55'e çektik, çok daha kibar durur
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(25), // Yüksekliğe göre yuvarlaklığı güncelledik
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Symbols.home),
          _buildNavItem(1, Symbols.bookmark_heart),
          _buildNavItem(2, Symbols.settings),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          // Seçili olanın arkasındaki o hafif renk dokunuşu
          color: isSelected ? Colors.white.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          size: 24,
          weight: isSelected ? 700 : 400, // Seçili olan bir tık daha kalın olsun
          fill: 1, // İkonlar her zaman dolu (istediğin gibi)
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.4), // Seçili olmayan daha sönük
        ),
      ),
    );
  }
}