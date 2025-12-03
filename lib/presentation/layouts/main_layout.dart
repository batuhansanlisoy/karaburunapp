import 'package:flutter/material.dart';
import 'package:karaburun/presentation/pages/home/home_page.dart';
import 'package:karaburun/presentation/pages/organization_page.dart';
import 'package:karaburun/presentation/pages/beach/beach_page.dart';
import 'package:karaburun/presentation/pages/cafe/cafe_page.dart';
import 'package:karaburun/presentation/pages/activity/activity_page.dart';
import 'package:karaburun/presentation/pages/activity/activity_detail.dart';
import 'package:karaburun/presentation/pages/restouran/restouran_page.dart';
import 'package:karaburun/presentation/pages/village/village_page.dart';
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
      HomePage(onPageChange: (index) {
        setState(() => _currentIndex = index);
      }),
      const RestouranPage(),
      const BeachPage(),
      const CafePage(),
      const ActivityPage(),
      const VillagePage(),
      const OrganizationPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
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
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Karaburun",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0,
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
                ),
                const CircleAvatar(
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
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
