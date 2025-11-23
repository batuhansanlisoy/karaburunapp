import 'package:flutter/material.dart';
import 'package:karaburun/presentation/pages/category_page.dart';
import 'package:karaburun/presentation/pages/events/event_page.dart';
import 'package:karaburun/presentation/pages/foods/food_page.dart';
import 'package:karaburun/presentation/pages/home/home_page.dart';
import 'package:karaburun/presentation/pages/organization_page.dart';
import 'package:karaburun/presentation/pages/beach/beach_page.dart';
import 'package:karaburun/presentation/pages/place/place_page.dart';
import 'package:karaburun/presentation/widgets/main_bottom_nav.dart';

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
      const OrganizationPage(),
      // const PlacePage(),
      const BeachPage(), // burda ilk hangisi varsa başlangıç ekranı o oluyor
      HomePage(onPageChange: (index) {
        setState(() {
          _currentIndex = index;
        });
      }),
      CategoryPage(onPageChange: (index) {
        setState(() {
          _currentIndex = index;
        });
      }),
      const EventPage(),
      const FoodPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 45, 113, 214),
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
                Text(
                  "KaraburunHub",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/300",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: MainBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
