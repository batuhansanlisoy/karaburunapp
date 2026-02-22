import 'package:flutter/material.dart';
import 'package:karaburun/core/widgets/custom_ad_dialog.dart';
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

  // Sayfaları saklayacağımız liste. Başta hepsi null.
  final List<Widget?> _pages = List.filled(6, null);

  @override
  void initState() {
    super.initState();
    // Reklamı 1 saniye geciktirerek uygulamanın açılış yükünü hafifletiyoruz
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) _showCustomAd(context);
    });
  }

  void _showCustomAd(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomAdDialog(
        imageUrl: "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=1000",
        onTap: () {},
      ),
    );
  }

  // Sayfa oluşturucu: Sadece tıklandığında sayfayı ayağa kaldırır
  Widget _getLazyPage(int index) {
    if (_pages[index] == null || (index == 1 && _selectedCategoryId != null)) {
      switch (index) {
        case 0:
          _pages[index] = HomePage(onPageChange: _onPageChange);
          break;
        case 1:
          // Kategori seçilince sayfayı her seferinde yeni ID ile oluşturur
          _pages[index] = OrganizationPage(categoryId: _selectedCategoryId);
          break;
        case 2:
          _pages[index] = const PlacePage();
          break;
        case 3:
          _pages[index] = const ActivityPage();
          break;
        case 4:
          _pages[index] = const BeachPage();
          break;
      }
    }
    return _pages[index]!;
  }

  void _onPageChange(int index, {int? categoryId}) {
    setState(() {
      _currentIndex = index;
      _selectedCategoryId = categoryId;
      // OrganizationPage index 1 olduğu için kategori değişince orayı sıfırlıyoruz ki yeniden oluşsun
      _pages[1] = null; 
    });
  }

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 1) {
        _selectedCategoryId = null;
        _pages[1] = null; // Filtresiz temiz sayfa için sıfırla
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: _MainAppBar(),
      ),
      // IndexedStack yerine tek sayfa render etmek (Lazy loading) cihazı çok rahatlatır
      body: _getLazyPage(_currentIndex),
      bottomNavigationBar: MainBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabChange,
      ),
    );
  }
}

// --- TASARIM WIDGETLARI (HİÇ DOKUNULMADI) ---

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