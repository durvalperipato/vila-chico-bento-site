import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  // Headings (GoogleFonts.outfit - amigável, arredondado e acolhedor)
  static TextStyle displayLarge({required Color color}) => GoogleFonts.outfit(
        fontSize: 44,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle displayMedium({required Color color}) => GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.4,
        color: color,
      );

  static TextStyle displaySmall({required Color color}) => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: color,
      );

  static TextStyle titleLarge({required Color color}) => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
      );

  static TextStyle titleMedium({required Color color}) => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: color,
      );

  // Body & Labels (GoogleFonts.inter - máxima legibilidade em qualquer dispositivo)
  static TextStyle bodyLarge({required Color color}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: color,
      );

  static TextStyle bodyMedium({required Color color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  static TextStyle labelLarge({required Color color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: color,
      );

  static TextStyle labelMedium({required Color color}) => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        color: color,
      );

  static TextStyle labelSmall({required Color color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: color,
      );
}
