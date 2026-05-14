import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.surface,
    ),

    // Typography
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary),
        displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary),
        displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary),
        headlineLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
        headlineMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
        headlineSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textPrimary),
        bodySmall: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.primary,
      titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary),
      iconTheme: IconThemeData(color: AppColors.primary),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        minimumSize: const Size(double.infinity, 50),
        maximumSize: const Size(double.infinity, 50),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 50),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      hintStyle: const TextStyle(color: AppColors.textHint),
    ),

    // Card Theme
    cardTheme: const CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      color: AppColors.card,
      margin: EdgeInsets.all(0),
    ),

    // Dialog Theme
    dialogTheme: const DialogThemeData(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      elevation: 4,
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle:
          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),

    // Tab Bar Theme
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      indicatorColor: AppColors.primary,
      dividerColor: Colors.transparent,
      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle:
          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),

    // Progress Indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      circularTrackColor: AppColors.border,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: Color(0xFF1E293B),
    ),
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFF1F5F9)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFCBD5E1)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xFF1E293B),
      foregroundColor: AppColors.primaryLight,
    ),
    cardTheme: const CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      color: Color(0xFF1E293B),
    ),
  );
}
