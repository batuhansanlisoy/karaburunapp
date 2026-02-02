import 'package:karaburun/core/theme/app_colors.dart';
import 'package:material_symbols_icons/symbols.dart';

class AppCategory {
  static const List<Map<String, dynamic>> staticCategories = [
    {
      "icon": Symbols.add_a_photo,
      "title": "Turistik",
      "color": AppColors.iconOrange,
      "pageIndex": 2,
    },
    {
      "icon": Symbols.celebration,
      "title": "Etkinlik",
      "color": AppColors.iconPurple,
      "pageIndex": 3,
    },
    {
      "icon": Symbols.beach_access,
      "title": "Koy & Plaj",
      "color": AppColors.iconGreen,
      "pageIndex": 4,
    },
  ];
}