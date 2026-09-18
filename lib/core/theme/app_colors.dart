import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Cores Básicas Globais
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Cores de Acento & Identidade Vila Chico Bento
  static const Color primary =
      Color(0xFFE07A2A); // Laranja / Âmbar Quente e Acolhedor
  static const Color primaryHover = Color(0xFFC8661B);
  static const Color primaryLight = Color(0xFFFFF3E8);
  static const Color primaryGlow = Color(0xFFF59E0B);

  static const Color secondary = Color(0xFF0EA5E9); // Azul Céu Ensolarado
  static const Color secondaryHover = Color(0xFF0284C7);
  static const Color secondaryLight = Color(0xFFE0F2FE);

  static const Color accentGreen =
      Color(0xFF10B981); // Verde Gramado / Natureza
  static const Color accentGreenLight = Color(0xFFECFDF5);

  // Cor consistente marrom terra para a trilha contínua de patinhas
  static const Color pawTrail = Color(0xFF9E5727);

  static const Color whatsapp = Color(0xFF25D366);
  static const Color whatsappHover = Color(0xFF1EBE5D);

  static const Color instagram = Color(0xFFE1306C);
  static const Color waze = Color(0xFF33CCFF);
  static const Color googleMaps = Color(0xFF4285F4);

  // Paleta Light Mode (Tons quentes, orgânicos e acolhedores)
  static const Color lightBgPrimary = Color(0xFFFFFDF7);
  static const Color lightBgSurface = Color(0xFFF8F5EE);
  static const Color lightBgCard = Color(0xFFFFFFFF);
  static const Color lightBgCardHover = Color(0xFFFFFDF9);
  static const Color lightTextPrimary = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);
  static const Color lightBorderSubtle = Color(0x18000000);
  static const Color lightBorderActive = Color(0x30E07A2A);

  // Paleta Dark Mode (Ardósia elegante e suave)
  static const Color darkBgPrimary = Color(0xFF0F172A);
  static const Color darkBgSurface = Color(0xFF1E293B);
  static const Color darkBgCard = Color(0xFF182234);
  static const Color darkBgCardHover = Color(0xFF222F46);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextMuted = Color(0xFF94A3B8);
  static const Color darkBorderSubtle = Color(0x1FFFFFFF);
  static const Color darkBorderActive = Color(0x50F59E0B);

  // Helpers contextuais conforme o tema atual
  static Color bgPrimary(bool isDark) =>
      isDark ? darkBgPrimary : lightBgPrimary;
  static Color bgSurface(bool isDark) =>
      isDark ? darkBgSurface : lightBgSurface;
  static Color bgCard(bool isDark) => isDark ? darkBgCard : lightBgCard;
  static Color bgCardHover(bool isDark) =>
      isDark ? darkBgCardHover : lightBgCardHover;
  static Color textPrimary(bool isDark) =>
      isDark ? darkTextPrimary : lightTextPrimary;
  static Color textSecondary(bool isDark) =>
      isDark ? darkTextSecondary : lightTextSecondary;
  static Color textMuted(bool isDark) =>
      isDark ? darkTextMuted : lightTextMuted;
  static Color borderSubtle(bool isDark) =>
      isDark ? darkBorderSubtle : lightBorderSubtle;
  static Color borderActive(bool isDark) =>
      isDark ? darkBorderActive : lightBorderActive;
  static Color cardShadow(bool isDark) =>
      isDark ? black.withValues(alpha: 0.35) : const Color(0x12000000);
}
