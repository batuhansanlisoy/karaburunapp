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
    return BottomNavigationBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      currentIndex: currentIndex > 2 ? 1 : currentIndex,
      onTap: onTap,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Symbols.home,
            color: Colors.black45,
            weight: 800,
            fill: 0,
            opticalSize: 86,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Symbols.category,
            color: Colors.black45,
            weight: 800,
            fill: 0,
            opticalSize: 86,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Symbols.search,
            color: Colors.black45,
            weight: 800,
            fill: 0,
            opticalSize: 86,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Symbols.settings,
            color: Colors.black45,
            weight: 800,
            fill: 0,
            opticalSize: 86,
          ),
          label: '',
        ),
      ],
    );
  }
}
