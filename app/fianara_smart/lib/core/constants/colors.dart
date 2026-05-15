import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1A237E);
  static const Color secondary = Color(0xFFE53935);
  static const Color error = Color(0xFFDC2626);
  static const Color warning = Color(0xFFFF9800);
  static const Color resolved = Color(0xFF4CAF50);
  static const Color inProgress = Color(0xFF2196F3);
  static const Color background = Color(0xFFF8F9FA);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A237E), Color(0xFF283593)],
  );

  static Color? get textHint => null;
}
