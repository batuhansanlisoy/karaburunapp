import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class IconHelper {
  static IconData getIcon(dynamic data) {
    if (data == null || data.toString().isEmpty) return Symbols.category_rounded;
    
    String name = data.toString().trim();
    
    // Artık sadece isme göre ikon döndürüyoruz
    return _getIconByName(name);
  }

  static IconData _getIconByName(String name) {
    final cleanName = name
        .replaceFirst('Icons.', '')
        .replaceFirst('Symbols.', '')
        .trim()
        .toLowerCase();
    
    switch (cleanName) {
      case 'hotel': return Symbols.hotel_rounded;
      case 'local_cafe': return Symbols.local_cafe_rounded;
      case 'beach_access': return Symbols.beach_access_rounded;
      case 'directions_run': return Symbols.directions_run_rounded;
      case 'shopping_cart': return Symbols.shopping_cart_rounded;
      case 'home': return Symbols.home_rounded;
      case 'restaurant': return Symbols.restaurant_rounded;
      case 'construction': return Symbols.construction_rounded;
      case 'bed': return Symbols.bed_rounded;
      case 'storefront': return Symbols.storefront_rounded;
      case 'directions_bus': return Symbols.directions_bus_rounded;
      case 'medical_services': return Symbols.medical_services_rounded;
      default: return Symbols.category_rounded;
    }
  }

  // --- İLERİDE LAZIM OLURSA DİYE YORUM SATIRINA ALINAN HEX MANTIĞI ---
  /*
  static bool _isHexCode(String s) {
    return RegExp(r'^[0-9a-fA-F]{4,5}$').hasMatch(s);
  }

  static IconData _getIconFromCode(dynamic iconCode) {
    try {
      String codeStr = iconCode.toString().replaceAll('0x', '').replaceAll('#', '').trim();
      int code = int.parse(codeStr, radix: 16); 
      
      return IconData(
        code, 
        fontFamily: 'MaterialSymbolsRounded',
        fontPackage: 'material_symbols_icons',
      );
    } catch (e) {
      return Symbols.category;
    }
  }
  */
}