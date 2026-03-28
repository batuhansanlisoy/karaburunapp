import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karaburun/core/layout/main_layout.dart';
import 'package:karaburun/features/home/presentation/pages/home_page.dart';
import 'package:karaburun/features/beach/presentation/pages/beach_page.dart';
import 'package:karaburun/features/organization/presentation/pages/organization_page.dart';
import 'package:karaburun/features/place/presentation/pages/place_page.dart';
import 'package:karaburun/features/activity/presentation/pages/activity_page.dart';
// SplashScreen'i import etmeyi unutma, yolu nereye açtıysan ona göre düzelt
import 'package:karaburun/core/widgets/splash_screen.dart'; 

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/splash', // Uygulama splash ile başlasın
  navigatorKey: _rootNavigatorKey,
  routes: [
    // --- Splash Screen (ShellRoute dışında!) ---
    GoRoute(
      path: '/splash',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SplashScreen(),
    ),

    // --- Uygulama Ana Yapısı ---
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainLayout(child: child); 
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(), 
        ),
        GoRoute(
          path: '/organization',
          builder: (context, state) {
            final catId = state.uri.queryParameters['catId'];
            return OrganizationPage(categoryId: int.tryParse(catId ?? ''));
          },
        ),
        GoRoute(
          path: '/place',
          builder: (context, state) => const PlacePage(),
        ),
        GoRoute(
          path: '/activity',
          builder: (context, state) => const ActivityPage(),
        ),
        GoRoute(
          path: '/beach',
          builder: (context, state) => const BeachPage(),
        ),
      ],
    ),
  ],
);