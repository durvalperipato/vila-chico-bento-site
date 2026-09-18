import 'package:flutter/material.dart';
import '../localization/app_language.dart';

/// Controladores reativos globais para Idioma e Tema consumidos pelo [NanoApp].
class AppSettings {
  AppSettings._();

  static final initialLanguage = AppLanguage.detectInitialLanguage();

  static final localeNotifier = ValueNotifier<Locale>(initialLanguage.locale);

  // Tema Solar/Acolhedor padrão (Light Mode)
  static final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  /// Alterna entre modo claro solar e modo escuro.
  static void toggleTheme() {
    themeModeNotifier.value = themeModeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  /// Define um idioma específico.
  static void setLanguage(AppLanguage lang) {
    localeNotifier.value = lang.locale;
  }
}
