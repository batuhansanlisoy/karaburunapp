import 'package:karaburun/core/theme/app_colors.dart';
import 'package:material_symbols_icons/symbols.dart';

class AppCategory {
  static const List<Map<String, dynamic>> staticCategories = [
    {
      "icon": Symbols.add_a_photo,
      "title": "Turistik",
      "color": AppColors.iconOrange,
      "path": "/place", // Adresimiz belli
    },
    {
      "icon": Symbols.celebration,
      "title": "Etkinlik",
      "color": AppColors.iconPurple,
      "path": "/activity",
    },
    {
      "icon": Symbols.beach_access,
      "title": "Koylar",
      "color": AppColors.iconGreen,
      "path": "/beach",
    }
  ];
}