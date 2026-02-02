import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart'; // Symbols sınıfı için

class IconHelper {
  static IconData getIcon(dynamic data) {
    if (data == null || data.toString().isEmpty) return Symbols.category; // Varsayılanı da Symbol yapalım
    
    String strData = data.toString().trim();

    // 0x ile başlıyorsa veya hex koduysa (e887 gibi) direkt koda git
    if (strData.startsWith('0x') || _isHexCode(strData)) {
      return _getIconFromCode(strData);
    }
    
    return _getIconByName(strData);
  }

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

  static IconData _getIconByName(String name) {
    final cleanName = name.replaceFirst('Icons.', '').replaceFirst('Symbols.', '').trim();
    
    // Proje içinde MaterialSymbols kullanmaya karar verdiysen 
    // statik isimleri de Symbols üzerinden döndürmek görsel uyumu sağlar.
    switch (cleanName) {
      case 'restaurant': return Symbols.restaurant;
      case 'hotel': return Symbols.hotel;
      case 'local_cafe': return Symbols.local_cafe;
      case 'beach_access': return Symbols.beach_access;
      case 'celebration': return Symbols.celebration;
      case 'landscape': return Symbols.landscape;
      case 'shopping_basket': return Symbols.shopping_basket;
      default: return Symbols.category;
    }
  }
}