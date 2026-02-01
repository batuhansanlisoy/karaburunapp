import 'package:flutter/material.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/features/food/presentation/pages/food_page.dart';
import 'package:karaburun/features/beach/presentation/pages/beach_page.dart';

final List<Map<String, dynamic>> categories = [
    {
        "icon": Icons.restaurant_menu_outlined,
        "title": "Yemek",
        "color": const Color(0xFFFF6F61),
        "builder": (context) => const FoodPage(),
        "pageIndex": 1
    },
    {
        "icon": Icons.hotel_outlined,
        "title": "Konaklama",
        "color": const Color(0xFF4FC3F7),
    },
    {
        "icon": Icons.landscape_outlined,
        "title": "Turistik",
        "color": AppColors.iconSoftOrange,
        "pageIndex": 2
    },
    {
        "icon": Icons.celebration,
        "title": "Etkinlik",
        "color": AppColors.iconPurple,
        "pageIndex": 3
    },
    {
        "icon": Icons.beach_access,
        "title": "Koy & Plaj",
        "color": AppColors.iconGreen,
        "builder": (context) => const BeachPage(),
        "pageIndex": 4
    },
    {
        "icon": Icons.local_grocery_store,
        "title": "Market",
        "color": const Color(0xFF81C784),
    },
    {
        "icon": Icons.local_hospital,
        "title": "Sağlık",
        "color": const Color(0xFFFF8A65),
    },
    {
        "icon": Icons.directions_bus,
        "title": "Ulaşım",
        "color": const Color(0xFF90A4AE),
    },
    {
        "icon": Icons.build,
        "title": "Hizmetler",
        "color": const Color(0xFFA1887F),
    },
];
