import 'package:flutter/material.dart';

import 'package:karaburun/features/home/presentation/pages/home_page.dart';
import 'package:karaburun/features/organization/presentation/pages/organization_page.dart';
import 'package:karaburun/features/beach/presentation/pages/beach_page.dart';
import 'package:karaburun/features/activity/presentation/pages/activity_page.dart';
import 'package:karaburun/features/village/presentation/pages/village_page.dart';
import 'package:karaburun/features/place/presentation/pages/place_page.dart';
import 'package:karaburun/features/food/presentation/pages/food_page.dart';
import 'package:karaburun/core/widgets/main_bottom_nav.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomePage(
        onPageChange: (index) {
          setState(() => _currentIndex = index);
        },
      ),
      const PlacePage(),
      const FoodPage(),
      const BeachPage(),
      const ActivityPage(),
      const VillagePage(),
      const OrganizationPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: _MainAppBar(),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: MainBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabChange,
      ),
    );
  }

  void _onTabChange(int index) {
    setState(() => _currentIndex = index);
  }
}

class _MainAppBar extends StatelessWidget {
  const _MainAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 56, 101, 160),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Logo(),
            _ProfileAvatar(),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: "Karaburun",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: "GO",
            style: TextStyle(
              color: Color.fromARGB(255, 216, 66, 66),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 22,
      backgroundImage: NetworkImage(
        "https://i.pravatar.cc/300",
      ),
    );
  }
}
