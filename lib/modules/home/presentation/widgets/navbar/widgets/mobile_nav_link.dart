import 'package:flutter/material.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';

/// Item de navegação individual exibido na gaveta/sheet mobile.
class MobileNavLink extends StatelessWidget {
  const MobileNavLink({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(
        label,
        style: AppTypography.titleMedium(
          color: AppColors.textPrimary(context),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textMuted(context),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}
