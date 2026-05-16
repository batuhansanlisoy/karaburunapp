import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:karaburun/core/widgets/main_bottom_nav.dart';
import 'package:karaburun/core/config/launch_popup_manager.dart';
import 'package:material_symbols_icons/symbols.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      LaunchPopupManager().checkAndShow(context);
    });
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/favorite')) return 1;
    if (location.startsWith('/explore')) return 2;
    if (location.startsWith('/setting')) return 3;
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
        context.go('/explore');
        break;
      case 3:
        context.go('/setting');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF1E293B),
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false
      ),
      child: Scaffold(
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
      )
    );
  }
}

// burası uygulama en üst ekranı
class _MainAppBar extends StatelessWidget {
  const _MainAppBar();

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: const SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Logo(),
            _NotificationIcon(),
          ],
        ),
      ),
    );
  }
}

// karaburun go yazısı
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

// main appbardaki notification ikonu
class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 1.0),
      child: GestureDetector( // Tıklama özelliği ekledik
        onTap: () {
          // GoRouter kullanıyorsan push ile yeni sayfaya gönderiyoruz
          context.push('/notifications'); 
        },
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 38, 40, 48).withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Symbols.notifications_rounded,
            fill: 1.0,
            color: Color.fromARGB(255, 255, 255, 255),
            size: 22,
            weight: 700,
            grade: 0,
            opticalSize: 24,
          ),
        ),
      ),
    );
  }
}