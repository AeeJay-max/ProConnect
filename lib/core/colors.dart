import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0A2540);
  static const Color secondary = Color(0xFF00C896);
  static const Color accent = Color(0xFF3B82F6);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceTint = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color danger = Color(0xFFEF4444);
  static const Color divider = Color(0xFFD1D5DB);
  static const Color success = Color(0xFF10B981);
  static const Color info = Color(0xFF3B82F6);
  static const Color sky = Color(0xFFE0F2FE);
  static const Color link = Color(0xFF3B82F6);
  static const Color routeFrom = Color(0xFF0A2540);
  static const Color routeTo = Color(0xFF00C896);
  static const Color dark = Color(0xFF0A2540);

  static const LinearGradient royalGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
