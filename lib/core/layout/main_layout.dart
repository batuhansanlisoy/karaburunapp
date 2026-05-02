import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karaburun/core/widgets/main_bottom_nav.dart';
import 'package:karaburun/core/config/launch_popup_manager.dart'; // Menajeri ekle

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  void initState() {
    super.initState();

    // Sayfa ilk açıldığında menajere haber veriyoruz
    // WidgetsBinding kullanarak BuildContext'in hazır olduğundan emin oluyoruz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LaunchPopupManager().checkAndShow(context);
    });
  }

  // BURADAKİ _showCustomAd FONKSİYONUNU SİLDİK
  // Çünkü artık tüm logic LaunchPopupManager içinde dönüyor.

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/favorite')) return 1;
    if (location.startsWith('/setting')) return 2;
    return 0;
  }

  void _onTabChange(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/favorite');
        break;
      case 2:
        context.go('/setting');
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
      body: widget.child,
      bottomNavigationBar: MainBottomNav(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onTabChange(index, context),
      ),
    );
  }
}

// --- TASARIM WIDGETLARI ---

class _MainAppBar extends StatelessWidget {
  const _MainAppBar();

  @override
  Widget build(BuildContext context) {
    // AppBar tasarımı (Senin mevcut kodun)
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
          color: Colors.white,
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