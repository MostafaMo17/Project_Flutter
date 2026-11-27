import 'package:flutter/material.dart';

/// Shared color tokens for the app's cool, campus-inspired visual system.
abstract final class AppColors {
  static const midnight = Color(0xFF0F172A);
  static const indigo = Color(0xFF1E3A8A);
  static const teal = Color(0xFF0D9488);
  static const canvas = Color(0xFFF4F7FB);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE2E8F0);
  static const text = Color(0xFF0F172A);

  static const lostBackground = Color(0xFFFFE4E6);
  static const lostForeground = Color(0xFFE11D48);
  static const foundBackground = Color(0xFFD1FAE5);
  static const foundForeground = Color(0xFF059669);
  static const resolvedBackground = Color(0xFFE2E8F0);
  static const resolvedForeground = Color(0xFF475569);

  static const primaryGradient = LinearGradient(
    colors: [midnight, indigo, teal],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const cardShadow = BoxShadow(
    color: Color(0x0D1E3A8A),
    blurRadius: 24,
    offset: Offset(0, 8),
  );
}
