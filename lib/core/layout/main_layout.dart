import 'package:flutter/material.dart';
import 'package:karaburun/core/services/ad_manager.dart'; // 🌟 Import eklendi
import 'package:karaburun/features/home/presentation/pages/home_page.dart';
import 'package:karaburun/features/organization/presentation/pages/organization_page.dart';
import 'package:karaburun/features/beach/presentation/pages/beach_page.dart';
import 'package:karaburun/features/activity/presentation/pages/activity_page.dart';
import 'package:karaburun/features/place/presentation/pages/place_page.dart';
import 'package:karaburun/core/widgets/main_bottom_nav.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  int? _selectedCategoryId;
  int _clickCount = 0; // 📊 Reklam sıklığını kontrol etmek için sayaç

  // Reklamı belirli aralıklarla tetikleyen yardımcı fonksiyon
  void _checkAndShowAd() {
    _clickCount++;
    // Her 3 tıklamada bir reklam gösterir (Sayıyı değiştirebilirsin)
    if (_clickCount % 3 == 0) {
      AdManager.instance.showAd();
    }
  }

  // HomePage'den bir kategoriye tıklandığında çalışan fonksiyon
  void _onPageChange(int index, {int? categoryId}) {
    _checkAndShowAd(); // 🌟 Kategoriye tıklayınca reklam kontrolü
    setState(() {
      _currentIndex = index;
      _selectedCategoryId = categoryId;
    });
  }

  // Alt menüden tıklandığında çalışan fonksiyon
  void _onTabChange(int index) {
    if (_currentIndex != index) {
      _checkAndShowAd(); // 🌟 Sekme değiştirince reklam kontrolü
    }
    
    setState(() {
      _currentIndex = index;
      if (index == 1) _selectedCategoryId = null; 
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(onPageChange: _onPageChange),
      OrganizationPage(categoryId: _selectedCategoryId),
      const PlacePage(),
      const ActivityPage(),
      const BeachPage(),
    ];

    return Scaffold(
      extendBody: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: _MainAppBar(),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabChange,
      ),
    );
  }
}

// --- Alt Bileşenler (Değişmedi ama yapı bozulmasın diye ekledim) ---

class _MainAppBar extends StatelessWidget {
  const _MainAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    final baseStyle = Theme.of(context).textTheme.titleLarge;
    return RichText(
      text: TextSpan(
        style: baseStyle?.copyWith(
            fontSize: 22,
            color: const Color.fromARGB(221, 255, 255, 255),
            letterSpacing: -0.5),
        children: [
          const TextSpan(text: "Karaburun"),
          TextSpan(
            text: "GO",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w900,
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
      backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
    );
  }
}