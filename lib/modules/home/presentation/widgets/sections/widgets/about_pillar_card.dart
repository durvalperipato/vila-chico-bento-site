import 'package:flutter/material.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';

/// Card interativo dos pilares da seção Sobre Nós.
class AboutPillarCard extends StatefulWidget {
  const AboutPillarCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color accentColor;

  @override
  State<AboutPillarCard> createState() => _AboutPillarCardState();
}

class _AboutPillarCardState extends State<AboutPillarCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -6 : 0, 0),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.bgCard(context),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.35)
                : AppColors.borderSubtle(context).withValues(alpha: 0.7),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? widget.accentColor.withValues(alpha: 0.12)
                  : AppColors.cardShadow(context).withValues(alpha: 0.05),
              blurRadius: _isHovered ? 24 : 14,
              offset: Offset(0, _isHovered ? 10 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: widget.accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                widget.icon,
                size: 26,
                color: widget.accentColor,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              widget.title,
              style: AppTypography.titleLarge(
                color: AppColors.textPrimary(context),
              ).copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              style: AppTypography.bodyMedium(
                color: AppColors.textSecondary(context),
              ).copyWith(
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
