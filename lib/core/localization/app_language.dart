import 'package:flutter/material.dart';

enum AppLanguage {
  pt('pt', 'Português', '🇧🇷'),
  en('en', 'English', '🇺🇸');

  const AppLanguage(this.code, this.label, this.flag);

  final String code;
  final String label;
  final String flag;

  String get flagEmoji => flag;

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.pt,
    );
  }

  /// Detecta o idioma do navegador (Web) ou do sistema operacional (Mobile/Desktop).
  /// Caso o idioma do sistema/navegador seja inglês ('en'), adota EN.
  /// Para qualquer outro caso (ou fallback), adota o Português (PT-BR) como padrão oficial.
  static AppLanguage detectInitialLanguage() {
    try {
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final code = systemLocale.languageCode.toLowerCase();

      if (code.startsWith('en')) {
        return AppLanguage.en;
      }
    } catch (_) {
      // Fallback seguro em ambientes de teste ou erro de dispatcher
    }
    return AppLanguage.pt;
  }
}
