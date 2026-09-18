import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';
import 'package:vila_chico_bento_site/core/widgets/meandering_paw_trail.dart';
import 'package:vila_chico_bento_site/core/widgets/responsive_container.dart';
import 'package:vila_chico_bento_site/core/widgets/section_tag.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({required this.controller, super.key});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = controller.isDarkMode;
    final isDesktop = NanoDeviceType.isDesktop(context);
    final isMobile = NanoDeviceType.isMobile(context);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final minHeight =
        isDesktop ? (screenHeight - 86).clamp(650.0, 1400.0) : 0.0;

    return Container(
      key: controller.aboutKey,
      constraints: isDesktop ? BoxConstraints(minHeight: minHeight) : null,
      alignment: Alignment.center,
      color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Aurora Glow Superior Esquerdo (Âmbar Suave)
          Positioned(
            top: -30,
            left: -40,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary
                        .withValues(alpha: isDark ? 0.12 : 0.08),
                    blurRadius: 100,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),

          // Aurora Glow Inferior Direito (Verde Natureza Suave)
          Positioned(
            bottom: -30,
            right: -40,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGreen
                        .withValues(alpha: isDark ? 0.10 : 0.06),
                    blurRadius: 100,
                    spreadRadius: 25,
                  ),
                ],
              ),
            ),
          ),

          // Rastro Contínuo de Patinhas: entra pelo topo direito, faz curva e sai pela base esquerda (0.10)
          Positioned.fill(
            child: MeanderingPawTrail(
              start: const Offset(0.90, 0.0),
              control1: const Offset(0.90, 0.35),
              control2: const Offset(0.10, 0.75),
              end: const Offset(0.10, 1.0),
              pawCount: isMobile ? 8 : 14,
              baseSize: 32.0,
              opacity: isDark ? 0.38 : 0.50,
              color: AppColors.pawTrail,
              startWithRightFoot: false,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 48 : 64,
            ),
            child: ResponsiveContainer(
              child: Column(
                children: [
                  // Cabeçalho da Seção
                  SectionTag(
                    text: l10n.aboutBadge,
                    icon: Icons.favorite_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.aboutTitle,
                    textAlign: TextAlign.center,
                    style: isDesktop
                        ? AppTypography.displayMedium(
                            color: AppColors.textPrimary(isDark),
                          )
                        : AppTypography.displaySmall(
                            color: AppColors.textPrimary(isDark),
                          ),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 780),
                    child: Text(
                      l10n.aboutDescription,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge(
                        color: AppColors.textSecondary(isDark),
                      ),
                    ),
                  ),
                  const SizedBox(height: 52),

                  // 3 Pilares Visuais
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _AboutPillarCard(
                            icon: Icons.psychology_alt_rounded,
                            title: l10n.aboutPoint1Title,
                            description: l10n.aboutPoint1Desc,
                            accentColor: AppColors.primary,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _AboutPillarCard(
                            icon: Icons.verified_user_rounded,
                            title: l10n.aboutPoint2Title,
                            description: l10n.aboutPoint2Desc,
                            accentColor: AppColors.accentGreen,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _AboutPillarCard(
                            icon: Icons.nature_people_rounded,
                            title: l10n.aboutPoint3Title,
                            description: l10n.aboutPoint3Desc,
                            accentColor: AppColors.secondary,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _AboutPillarCard(
                          icon: Icons.psychology_alt_rounded,
                          title: l10n.aboutPoint1Title,
                          description: l10n.aboutPoint1Desc,
                          accentColor: AppColors.primary,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 20),
                        _AboutPillarCard(
                          icon: Icons.verified_user_rounded,
                          title: l10n.aboutPoint2Title,
                          description: l10n.aboutPoint2Desc,
                          accentColor: AppColors.accentGreen,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 20),
                        _AboutPillarCard(
                          icon: Icons.nature_people_rounded,
                          title: l10n.aboutPoint3Title,
                          description: l10n.aboutPoint3Desc,
                          accentColor: AppColors.secondary,
                          isDark: isDark,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutPillarCard extends StatefulWidget {
  const _AboutPillarCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.isDark,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color accentColor;
  final bool isDark;

  @override
  State<_AboutPillarCard> createState() => _AboutPillarCardState();
}

class _AboutPillarCardState extends State<_AboutPillarCard> {
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
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.bgCard(widget.isDark),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.5)
                : AppColors.borderSubtle(widget.isDark),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? widget.accentColor.withValues(alpha: 0.15)
                  : AppColors.cardShadow(widget.isDark),
              blurRadius: _isHovered ? 24 : 16,
              offset: Offset(0, _isHovered ? 12 : 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: widget.accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                widget.icon,
                size: 28,
                color: widget.accentColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: AppTypography.titleLarge(
                color: AppColors.textPrimary(widget.isDark),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              style: AppTypography.bodyMedium(
                color: AppColors.textSecondary(widget.isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
