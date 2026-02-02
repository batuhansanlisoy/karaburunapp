import 'package:flutter/material.dart';

class ColorHelper {
  static Color getColor(String? colorSource) {
    if (colorSource == null) return Colors.blueGrey;

    // 1. Sabit İsim Kontrolü
    switch (colorSource) {
      case 'Colors.orange': return Colors.orange;
      case 'Colors.blue': return Colors.blue;
      case 'Colors.green': return Colors.green;
      case 'Colors.purple': return Colors.purple;
      case 'Colors.red': return Colors.red;
    }

    // 2. Hex Kod Kontrolü (#FF5733 veya 0xFFFF5733)
    try {
      String hex = colorSource.replaceAll('#', '').replaceAll('0x', '');
      if (hex.length == 6) hex = 'FF' + hex; 
      return Color(int.parse('0x$hex'));
    } catch (e) {
      return Colors.blueGrey;
    }
  }
}