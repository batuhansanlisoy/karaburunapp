import 'package:karaburun/core/theme/app_colors.dart';
import 'package:material_symbols_icons/symbols.dart';

class AppCategory {
  static const List<Map<String, dynamic>> staticCategories = [
    {
      "icon": Symbols.photo_camera_rounded,
      "title": "Turistik",
      "color": AppColors.iconOrange,
      "path": "/place", // Adresimiz belli
    },
    {
      "icon": Symbols.star_shine_rounded,
      "title": "Etkinlik",
      "color": AppColors.iconYellow,
      "path": "/activity",
    },
    {
      "icon": Symbols.beach_access_rounded,
      "title": "Koylar",
      "color": AppColors.iconBlue,
      "path": "/beach",
    }
  ];
}