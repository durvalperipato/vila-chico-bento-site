import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';

/// Botão circular para alternância de tema Claro / Escuro com feedback tátil e visual.
class NavbarThemeToggle extends StatelessWidget {
  const NavbarThemeToggle({
    required this.controller,
    super.key,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: controller.toggleTheme,
        tooltip: isDark ? 'Ativar Tema Solar Acolhedor' : 'Ativar Modo Escuro',
        icon: Icon(
          isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
          color: isDark ? const Color(0xFFFBBF24) : AppColors.primary,
          size: 18,
        ),
      ),
    );
  }
}
