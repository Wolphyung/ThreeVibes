import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Style maquette
  static const Color primary = Color(0xFF1A73E8); // Bleu principal
  static const Color primaryLight = Color(0xFF4285F4);
  static const Color primaryDark = Color(0xFF0D47A1);

  // Secondary Colors
  static const Color secondary = Color(0xFF34A853); // Vert
  static const Color warning = Color(0xFFFBBC04); // Jaune/Orange
  static const Color error = Color(0xFFEA4335); // Rouge
  static const Color success = Color(0xFF34A853); // Vert (alias de secondary)

  // Status Colors
  static const Color pending = Color(0xFFFBBC04); // En cours - Orange
  static const Color inProgress = Color(0xFF1A73E8); // En traitement - Bleu
  static const Color resolved = Color(0xFF34A853); // Traité - Vert
  static const Color rejected = Color(0xFFEA4335); // Rejeté - Rouge

  // Neutral Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF202124);
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color textHint = Color(0xFF9AA0A6);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Border Colors
  static const Color border = Color(0xFFE8EAED);
  static const Color divider = Color(0xFFF1F3F4);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
}
