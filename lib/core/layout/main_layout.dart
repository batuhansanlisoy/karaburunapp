import 'package:flutter/material.dart';
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
  int? _selectedCategoryId; // Seçilen kategori ID'sini burada saklıyoruz

  // HomePage'den bir kategoriye tıklandığında çalışan fonksiyon
  void _onPageChange(int index, {int? categoryId}) {
    setState(() {
      _currentIndex = index;
      _selectedCategoryId = categoryId; // ID bilgisini kaydediyoruz
    });
  }

  // Alt menüden tıklandığında çalışan fonksiyon
  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
      // Eğer doğrudan "İşletmeler" tabına basılırsa filtreyi temizlemek isteyebilirsin:
      if (index == 1) _selectedCategoryId = null; 
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sayfaları her build anında güncel ID ile oluşturuyoruz
    final List<Widget> pages = [
      HomePage(onPageChange: _onPageChange),
      OrganizationPage(categoryId: _selectedCategoryId), // ID buraya paslanıyor
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
      body: IndexedStack( // currentIndex'e göre sayfayı gösterir
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

class _MainAppBar extends StatelessWidget {
  const _MainAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24), // Sol alt yuvarlak
          bottomRight: Radius.circular(24), // Sağ alt yuvarlak
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4), // Aşağı doğru hafif gölge
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
          const TextSpan(
            text: "Karaburun",
          ),
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
      backgroundImage: NetworkImage(
        "https://i.pravatar.cc/300",
      ),
    );
  }
}