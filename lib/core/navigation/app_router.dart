import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karaburun/core/layout/main_layout.dart';
import 'package:karaburun/features/home/presentation/pages/home_page.dart';
import 'package:karaburun/features/beach/presentation/pages/beach_page.dart';
import 'package:karaburun/features/organization/presentation/pages/organization_page.dart';
import 'package:karaburun/features/place/presentation/pages/place_page.dart';
import 'package:karaburun/features/activity/presentation/pages/activity_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainLayout(child: child); 
      },
      routes: [
        // 1. ANA SAYFA - Artık tertemiz, parametre beklemiyor
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(), 
        ),

        // 2. ORGANİZASYONLAR / İŞLETMELER
        GoRoute(
          path: '/organization',
          builder: (context, state) {
            // URL'deki ?catId=... kısmını okur
            final catId = state.uri.queryParameters['catId'];
            return OrganizationPage(categoryId: int.tryParse(catId ?? ''));
          },
        ),

        // 3. TURİSTİK YERLER (Place)
        GoRoute(
          path: '/place',
          builder: (context, state) => const PlacePage(),
        ),

        // 4. ETKİNLİKLER (Activity)
        GoRoute(
          path: '/activity',
          builder: (context, state) => const ActivityPage(),
        ),

        // 5. PLAJLAR / KOYLAR (Beach)
        GoRoute(
          path: '/beach',
          builder: (context, state) => const BeachPage(),
        ),
      ],
    ),

    // --- DETAY SAYFALARI (Buraya eklenecek) ---
  ],
);
