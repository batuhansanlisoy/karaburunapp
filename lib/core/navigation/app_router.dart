import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karaburun/core/layout/main_layout.dart';
import 'package:karaburun/features/activity/data/models/activity_model.dart';
import 'package:karaburun/features/activity/presentation/pages/activity_detail.dart';
import 'package:karaburun/features/beach/data/models/beach_model.dart';
import 'package:karaburun/features/beach/presentation/pages/beach_detail.dart';
import 'package:karaburun/features/favorite/presentation/pages/favorite_page.dart';
import 'package:karaburun/features/home/presentation/pages/home_page.dart';
import 'package:karaburun/features/beach/presentation/pages/beach_page.dart';
import 'package:karaburun/features/organization/data/models/organization_model.dart';
import 'package:karaburun/features/organization/presentation/pages/organization_detail.dart';
import 'package:karaburun/features/organization/presentation/pages/organization_page.dart';
import 'package:karaburun/features/place/presentation/pages/place_page.dart';
import 'package:karaburun/features/activity/presentation/pages/activity_page.dart';
// SplashScreen'i import etmeyi unutma, yolu nereye açtıysan ona göre düzelt
import 'package:karaburun/core/widgets/splash_screen.dart';
import 'package:karaburun/features/setting/presentation/pages/setting_page.dart';
import 'package:karaburun/features/local_producer/presentation/pages/local_producer_page.dart'; 

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
          routes: [
            GoRoute(
              path: 'detail',
              builder: (context, state) {
                final org = state.extra as OrganizationModel;
                return OrganizationDetail(organization: org);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/setting',
          builder: (context, state) => const SettingPage(),
        ),
        GoRoute(
          path: '/favorite',
          builder: (context, state) => const FavoritePage(),
        ),
        GoRoute(
          path: '/place',
          builder: (context, state) => const PlacePage(),
        ),
        GoRoute(
          path: '/activity',
          builder: (context, state) => const ActivityPage(),
          routes: [
            GoRoute(
              path: 'detail',
              builder: (context, state) {
                final activity = state.extra as Activity; 
                return ActivityDetailPage(activity: activity);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/beach',
          builder: (context, state) => const BeachPage(),
          routes: [
            GoRoute(
              path: 'detail',
              builder: (context, state) {
                final beach = state.extra as Beach;
                return BeachDetail(beach: beach);
              }
            )
          ]
        ),
        GoRoute(
          path: '/local_producer',
          builder: (context, state) => const LocalProducerPage(),
        ),
      ],
    ),
  ],
);