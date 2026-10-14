import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';
import 'package:vila_chico_bento_site/core/widgets/brand_icons.dart';
import 'package:vila_chico_bento_site/core/widgets/meandering_paw_trail.dart';
import 'package:vila_chico_bento_site/core/widgets/responsive_container.dart';
import 'package:vila_chico_bento_site/core/widgets/section_tag.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_state.dart';
import 'widgets/interactive_map_preview.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({
    required this.state,
    required this.controller,
    super.key,
  });

  final HomeState state;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final location = state.location;
    final isDark = context.theme.isDark;
    final isDesktop = context.screen.isDesktop;
    final minHeight =
        isDesktop ? (context.screen.height - 86).clamp(600.0, 1000.0) : 0.0;
    final addressText = location.address;
    final hoursText = location.hours;

    return Container(
      key: controller.locationKey,
      constraints: isDesktop ? BoxConstraints(minHeight: minHeight) : null,
      alignment: Alignment.center,
      color: AppColors.bgSurface(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Rastro Contínuo de Patinhas
          Positioned.fill(
            child: NanoResponsiveLayout(
              desktop: (context) => MeanderingPawTrail(
                start: const Offset(0.10, 0.0),
                control1: const Offset(0.10, 0.25),
                control2: const Offset(0.50, 0.75),
                end: const Offset(0.50, 1.0),
                pawCount: 14,
                opacity: isDark ? 0.38 : 0.50,
                color: AppColors.pawTrail,
                startWithRightFoot: true,
              ),
              mobile: (context) => MeanderingPawTrail(
                start: const Offset(0.10, 0.0),
                control1: const Offset(0.10, 0.25),
                control2: const Offset(0.50, 0.75),
                end: const Offset(0.50, 1.0),
                pawCount: 8,
                opacity: isDark ? 0.38 : 0.50,
                color: AppColors.pawTrail,
                startWithRightFoot: true,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 26 : 40,
            ),
            child: ResponsiveContainer(
              maxWidth: 960,
              child: Column(
                children: [
                  SectionTag(
                    text: location.badge,
                    icon: Icons.place_rounded,
                  ),
                  const SizedBox(height: 10),
                  NanoResponsiveLayout(
                    desktop: (context) => Text(
                      location.title,
                      textAlign: TextAlign.center,
                      style: AppTypography.displayMedium(
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    mobile: (context) => Text(
                      location.title,
                      textAlign: TextAlign.center,
                      style: AppTypography.displaySmall(
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  SizedBox(height: isDesktop ? 20 : 32),

                  // Card Principal com Informações, Prévia de Mapa
                  // e Botões Oficiais
                  Container(
                    padding: EdgeInsets.all(isDesktop ? 22 : 18),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard(context),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: AppColors.borderSubtle(context),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cardShadow(context),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Dados Reais de Endereço e Horário
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on_rounded,
                                size: 28,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Endereço Oficial',
                                        style: AppTypography.labelLarge(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.white
                                                  .withValues(alpha: 0.08)
                                              : Colors.black
                                                  .withValues(alpha: 0.05),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Text(
                                          'Pinhais / PR',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary(
                                              context,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    addressText,
                                    style: AppTypography.titleMedium(
                                      color: AppColors.textPrimary(context),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_rounded,
                                        size: 16,
                                        color: AppColors.accentGreen,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          hoursText,
                                          style: AppTypography.bodyMedium(
                                            color: AppColors.textSecondary(
                                              context,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: isDesktop ? 16 : 20),

                        // 2. Container com Prévia Estilizada do Mapa
                        const InteractiveMapPreview(),

                        SizedBox(height: isDesktop ? 18 : 22),

                        // 3. Botões Oficiais de Navegação
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: controller.openGoogleMaps,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A73E8),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 26,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                elevation: 3,
                                shadowColor: const Color(0xFF1A73E8)
                                    .withValues(alpha: 0.4),
                              ),
                              icon: BrandIcons.googleMaps(
                                size: 18,
                                color: Colors.white,
                              ),
                              label: Text(
                                l10n.btnGoogleMaps,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: controller.openWaze,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF33CCFF),
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 26,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                elevation: 3,
                                shadowColor: const Color(0xFF33CCFF)
                                    .withValues(alpha: 0.4),
                              ),
                              icon: BrandIcons.waze(
                                size: 18,
                                color: Colors.black87,
                              ),
                              label: Text(
                                l10n.btnWaze,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
