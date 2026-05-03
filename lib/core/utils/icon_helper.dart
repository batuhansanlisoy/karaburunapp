import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class IconHelper {
  static IconData getIcon(dynamic data) {
    if (data == null || data.toString().isEmpty) return Symbols.category;
    
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
      case 'hotel': return Symbols.hotel;
      case 'local_cafe': return Symbols.local_cafe;
      case 'beach_access': return Symbols.beach_access;
      case 'directions_run': return Symbols.directions_run;
      case 'shopping_cart': return Symbols.shopping_cart;
      case 'home': return Symbols.home;
      case 'restaurant': return Symbols.restaurant;
      case 'construction': return Symbols.construction;
      case 'bed': return Symbols.bed;
      case 'storefront': return Symbols.storefront;
      case 'directions_bus': return Symbols.directions_bus;
      case 'medical_services': return Symbols.medical_services;
      default: return Symbols.category;
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