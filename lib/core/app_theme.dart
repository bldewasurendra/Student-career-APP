import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
            titleLarge: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            bodyMedium: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withAlpha(25), width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: Colors.white,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.outfit(
              color: const Color(0xFF1A1A1A),
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
            titleLarge: GoogleFonts.outfit(
              color: const Color(0xFF1A1A1A),
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            bodyMedium: GoogleFonts.outfit(
              color: const Color(0xFF4A4A4A),
              fontSize: 16,
            ),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
        titleTextStyle: GoogleFonts.outfit(
          color: const Color(0xFF1A1A1A),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
