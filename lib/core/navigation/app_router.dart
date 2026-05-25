import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karaburun/core/layout/main_layout.dart';
import 'package:karaburun/features/activity/data/models/activity_model.dart';
import 'package:karaburun/features/activity/presentation/pages/activity_detail.dart';
import 'package:karaburun/features/beach/data/models/beach_model.dart';
import 'package:karaburun/features/beach/presentation/pages/beach_detail.dart';
import 'package:karaburun/features/explore/pages/explore_page.dart';
import 'package:karaburun/features/favorite/presentation/pages/favorite_page.dart';
import 'package:karaburun/features/home/presentation/pages/home_page.dart';
import 'package:karaburun/features/beach/presentation/pages/beach_page.dart';
import 'package:karaburun/features/notification/presentation/pages/notif_page.dart';
import 'package:karaburun/features/organization/data/models/organization_model.dart';
import 'package:karaburun/features/organization/presentation/pages/organization_detail.dart';
import 'package:karaburun/features/organization/presentation/pages/organization_page.dart';
import 'package:karaburun/features/place/data/models/place_model.dart';
import 'package:karaburun/features/place/presentation/pages/place_detail.dart';
import 'package:karaburun/features/place/presentation/pages/place_page.dart';
import 'package:karaburun/features/activity/presentation/pages/activity_page.dart';
import 'package:karaburun/features/setting/presentation/pages/setting_page.dart';
import 'package:karaburun/features/local_producer/presentation/pages/local_producer_page.dart'; 

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/home', // Uygulama splash ile başlasın
  navigatorKey: _rootNavigatorKey,
  routes: [

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
              path: 'detail/:id',
              builder: (context, state) {
                if (state.extra != null && state.extra is OrganizationModel) {
                  return OrganizationDetail(organization: state.extra as OrganizationModel);
                }

                final idParam = state.pathParameters['id'];
                final organizationId = int.tryParse(idParam ?? '');

                if (organizationId != null) {
                  return OrganizationDetail(organizationId: organizationId);
                }

                return const Center(
                  child: Text(
                    "İşletme bulunamadı!"
                  )
                );
              }
            ),
          ],
        ),
        GoRoute(
          path: '/setting',
          builder: (context, state) => const SettingPage(),
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExplorePage(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotifPage(),
        ),
        GoRoute(
          path: '/favorite',
          builder: (context, state) => const FavoritePage(),
        ),
        GoRoute(
          path: '/place',
          builder: (context, state) => const PlacePage(),
          routes: [
            GoRoute(
              path: 'detail/:id',
              builder: (context, state) {
                if (state.extra != null && state.extra is Place) {
                  return PlaceDetail(place: state.extra as Place);
                }

                final idParam = state.pathParameters['id'];
                final placeId = int.tryParse(idParam ?? '');

                if (placeId != null) {
                  return PlaceDetail(placeId: placeId);
                }

                return const Center(
                  child: Text(
                    "Veri bulunamadı!"
                  )
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/activity',
          builder: (context, state) => const ActivityPage(),
          routes: [
            GoRoute(
              path: 'detail/:id',
              builder: (context, state) {
                if (state.extra != null && state.error is Activity) {
                  return ActivityDetailPage(activity: state.extra as Activity);
                }

                final idParam = state.pathParameters['id'];
                final activityId = int.tryParse(idParam ?? '');

                if (activityId != null) {
                  return ActivityDetailPage(activityId: activityId);
                }

                return const Center(
                  child: Text(
                    "Etkinlik bilgisi bulunamadı!"
                  )
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/beach',
          builder: (context, state) => const BeachPage(),
          routes: [
            GoRoute(
              path: 'detail/:id',
              builder: (context, state) {
                if (state.extra !=null && state.extra is Beach) {
                  return BeachDetail(beach: state.extra as Beach);
                }

                final idParam = state.pathParameters['id'];
                final beachId = int.tryParse(idParam ?? '');

                if (beachId != null) {
                  return BeachDetail(beachId: beachId);
                }

                return const Center(
                  child: Text(
                    "Plaj bilgisi bulunamadı!"
                  )
                );
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