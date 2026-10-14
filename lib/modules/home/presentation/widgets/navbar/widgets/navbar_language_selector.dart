import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/localization/app_language.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';

/// Seletor de idioma em formato pill com suporte a bandeiras emoji e
/// troca reativa.
class NavbarLanguageSelector extends StatelessWidget {
  const NavbarLanguageSelector({
    required this.controller,
    super.key,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.isDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AppLanguage>(
          value: controller.currentLanguage,
          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 15,
            color: AppColors.textMuted(context),
          ),
          focusColor: Colors.transparent,
          items: AppLanguage.values.map((lang) {
            return DropdownMenuItem<AppLanguage>(
              value: lang,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(lang.flagEmoji, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 4),
                  Text(
                    lang.code.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (lang) {
            if (lang != null) controller.setLanguage(lang);
          },
        ),
      ),
    );
  }
}
