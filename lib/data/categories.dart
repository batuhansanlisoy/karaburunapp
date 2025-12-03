import 'package:flutter/material.dart';
import 'package:karaburun/presentation/pages/beach/beach_page.dart';
import 'package:karaburun/presentation/pages/village/village_page.dart';
import 'package:karaburun/presentation/pages/place/place_page.dart';
import 'package:karaburun/presentation/pages/food/food_page.dart';

final List<Map<String, dynamic>> categories = [
  {
    "icon": Icons.restaurant_menu_outlined,
    "title": "Yemek",
    "color":const Color(0xFFFF6F61),
    "builder": (context) => const FoodPage(),
    "pageIndex": 1
  },
  {
    "icon": Icons.hotel_outlined,
    "title": "Konaklama",
    "color": const Color(0xFF4FC3F7),
    // "builder": (context) => const FoodPage(),
  },
  {
    "icon": Icons.landscape_outlined,
    "title": "Turistik",
    "color": const  Color(0xFFFFB74D),
    // "builder": (context) => const FoodPage(),
  },
  {
    "icon": Icons.celebration,
    "title": "Etkinlik",
    "color": const Color(0xFFBA68C8),
    "pageIndex": 4
  },
  {
    "icon": Icons.beach_access,
    "title": "Koy & Plaj",
    "color": const  Color(0xFF4DB6AC),
    "builder": (context) => const BeachPage(),
    "pageIndex": 2
  },
  {
    "icon": Icons.local_grocery_store,
    "title": "Market",
    "color": const  Color(0xFF81C784),
    // "builder": (context) => const FoodPage(),
  },
  {
    "icon": Icons.local_hospital,
    "title": "Sağlık",
    "color": const Color(0xFFFF8A65),
    // "builder": (context) => const FoodPage(),
  },
  {
    "icon": Icons.directions_bus,
    "title": "Ulaşım",
    "color": const  Color(0xFF90A4AE),
    // "builder": (context) => const FoodPage(),
  },
  {
    "icon": Icons.build,
    "title": "Hizmetler",
    "color": const Color(0xFFA1887F),
    // "builder": (context) => const FoodPage(),
  },
];
