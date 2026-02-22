import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karaburun/core/widgets/custom_ad_dialog.dart';
import 'package:karaburun/core/widgets/main_bottom_nav.dart';

class MainLayout extends StatefulWidget {
  final Widget child; // GoRouter o anki sayfayı buraya enjekte eder

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  void initState() {
    super.initState();
    // Reklam geciktirme mantığın aynen duruyor
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

  // URL'den hangi BottomNav ikonunun seçili olduğunu hesaplayan mantık
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/organization')) return 1;
    if (location.startsWith('/place')) return 2;
    if (location.startsWith('/activity')) return 3;
    if (location.startsWith('/beach')) return 4;
    return 0;
  }

  // Navbardaki ikonlara basınca sayfayı değiştiren fonksiyon
  void _onTabChange(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/organization');
        break;
      case 2:
        context.go('/place');
        break;
      case 3:
        context.go('/activity');
        break;
      case 4:
        context.go('/beach');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: _MainAppBar(),
      ),
      // GoRouter'ın yönettiği aktif sayfa buraya gelir
      body: widget.child,
      bottomNavigationBar: MainBottomNav(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onTabChange(index, context),
      ),
    );
  }
}

// --- TASARIM WIDGETLARI (DEĞİŞMEDİ) ---

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
          letterSpacing: -0.5,
        ),
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