import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/constants/app_constants.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';
import 'package:vila_chico_bento_site/core/widgets/brand_icons.dart';
import 'package:vila_chico_bento_site/core/widgets/map_embed/map_embed.dart';
import 'package:vila_chico_bento_site/core/widgets/meandering_paw_trail.dart';
import 'package:vila_chico_bento_site/core/widgets/responsive_container.dart';
import 'package:vila_chico_bento_site/core/widgets/section_tag.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({required this.controller, super.key});
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
      key: controller.locationKey,
      constraints: isDesktop ? BoxConstraints(minHeight: minHeight) : null,
      alignment: Alignment.center,
      color: isDark ? AppColors.darkBgPrimary : AppColors.lightBgPrimary,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Rastro Contínuo de Patinhas: continua de Galeria (0.10) e desce até o centro da base (0.50)
          Positioned.fill(
            child: MeanderingPawTrail(
              start: const Offset(0.10, 0.0),
              control1: const Offset(0.10, 0.25),
              control2: const Offset(0.50, 0.75),
              end: const Offset(0.50, 1.0),
              pawCount: isMobile ? 8 : 14,
              baseSize: 32.0,
              opacity: isDark ? 0.38 : 0.50,
              color: AppColors.pawTrail,
              startWithRightFoot: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 56 : 72,
            ),
            child: ResponsiveContainer(
              maxWidth: 960,
              child: Column(
                children: [
                  SectionTag(
                    text: l10n.locationBadge,
                    icon: Icons.place_rounded,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.locationTitle,
                    textAlign: TextAlign.center,
                    style: isDesktop
                        ? AppTypography.displayMedium(
                            color: AppColors.textPrimary(isDark),
                          )
                        : AppTypography.displaySmall(
                            color: AppColors.textPrimary(isDark),
                          ),
                  ),
                  const SizedBox(height: 40),

                  // Card Principal com Informações, Prévia de Mapa e Botões Oficiais
                  Container(
                    padding: EdgeInsets.all(isMobile ? 20 : 36),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard(isDark),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: AppColors.borderSubtle(isDark),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cardShadow(isDark),
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
                                            color:
                                                AppColors.textSecondary(isDark),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    AppConstants.fullAddress,
                                    style: AppTypography.titleMedium(
                                      color: AppColors.textPrimary(isDark),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_filled_rounded,
                                        size: 15,
                                        color: AppColors.textMuted(isDark),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        AppConstants.openingHours,
                                        style: AppTypography.bodyMedium(
                                          color:
                                              AppColors.textSecondary(isDark),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // 2. Container com Prévia Estilizada do Mapa e Pin da Vila Chico Bento
                        _InteractiveMapPreview(
                          controller: controller,
                          isDark: isDark,
                          isMobile: isMobile,
                        ),

                        const SizedBox(height: 28),

                        // 3. Botões Oficiais de Navegação (Google Maps e Waze)
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            // Botão Oficial Google Maps
                            ElevatedButton.icon(
                              onPressed: controller.openGoogleMaps,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A73E8),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 20 : 28,
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

                            // Botão Oficial Waze
                            ElevatedButton.icon(
                              onPressed: controller.openWaze,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF33CCFF),
                                foregroundColor: const Color(0xFF0F172A),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 20 : 28,
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
                                color: const Color(0xFF0F172A),
                              ),
                              label: Text(
                                l10n.btnWaze,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
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

/// Container com Prévia Visual Estilizada do Mapa e Pin Marcador
class _InteractiveMapPreview extends StatelessWidget {
  const _InteractiveMapPreview({
    required this.controller,
    required this.isDark,
    required this.isMobile,
  });

  final HomeController controller;
  final bool isDark;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final height = isMobile ? 260.0 : 360.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: RealMapEmbed(
        mapUrl: AppConstants.googleMapsEmbedUrl,
        height: height,
        isDark: isDark,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
