import 'package:flutter/material.dart';
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
            _NotificationIcon(),
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

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Icon(
        Symbols.notifications,
        fill: 1.0, // İçi dolu
        color: Color.fromARGB(234, 255, 171, 45),
        size: 22,
      ),
    );
  }
}