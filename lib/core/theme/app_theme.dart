import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart'; // Dosya ismine göre import et kanka

class AppTheme {
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.urbanistTextTheme().copyWith(
      titleLarge: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.bold),
      titleMedium: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w700),
      titleSmall: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.urbanist(fontSize: 14),
      bodyMedium: GoogleFonts.urbanist(fontSize: 13),
      labelSmall: GoogleFonts.urbanist(fontSize: 11),
    );

    return ThemeData(
      useMaterial3: true,
      textTheme: textTheme,

      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: Colors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E293B), 
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}