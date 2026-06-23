import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.bgLight,
        onPrimary: Colors.white,
        onSurface: AppColors.textLightPrimary,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        bodyLarge: const TextStyle(color: AppColors.textLightPrimary, fontSize: 16, height: 1.5),
        bodyMedium: const TextStyle(color: AppColors.textLightSecondary, fontSize: 14, height: 1.5),
        titleLarge: const TextStyle(color: AppColors.textLightPrimary, fontWeight: FontWeight.bold, fontSize: 22),
        titleMedium: const TextStyle(color: AppColors.textLightPrimary, fontWeight: FontWeight.w600, fontSize: 16),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textLightPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textLightPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.bgDark,
        onPrimary: Colors.white,
        onSurface: AppColors.textDarkPrimary,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme).copyWith(
        bodyLarge: const TextStyle(color: AppColors.textDarkPrimary, fontSize: 16, height: 1.5),
        bodyMedium: const TextStyle(color: AppColors.textDarkSecondary, fontSize: 14, height: 1.5),
        titleLarge: const TextStyle(color: AppColors.textDarkPrimary, fontWeight: FontWeight.bold, fontSize: 22),
        titleMedium: const TextStyle(color: AppColors.textDarkPrimary, fontWeight: FontWeight.w600, fontSize: 16),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textDarkPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textDarkPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // TextStyle helpers for Arabic text
  static TextStyle arabicStyle({double fontSize = 28, Color? color}) {
    return GoogleFonts.scheherazadeNew(
      fontSize: fontSize,
      height: 1.8, // Elegant height for Arabic calligraphy
      fontWeight: FontWeight.w500,
      color: color,
    );
  }
}
