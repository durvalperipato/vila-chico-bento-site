import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';
import 'package:vila_chico_bento_site/core/widgets/meandering_paw_trail.dart';
import 'package:vila_chico_bento_site/core/widgets/responsive_container.dart';
import 'package:vila_chico_bento_site/core/widgets/section_tag.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_state.dart';
import 'widgets/gallery_desktop_grid.dart';
import 'widgets/gallery_horizontal_carousel.dart';

/// Seção Galeria (Momentos Felizes):
/// Fundo alternado em bgPrimary (creme suave), molduras orgânicas no formato
/// da almofadinha da pata (paw pad) e grade flexível inteligente de 1 a N fotos
/// sem buracos vazios.
class GallerySection extends StatelessWidget {
  const GallerySection({
    required this.state,
    required this.controller,
    super.key,
  });

  final HomeState state;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final gallery = state.gallery;
    final isDark = context.theme.isDark;
    final isDesktop = context.screen.isDesktop;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final minViewportHeight = (screenHeight - 86).clamp(600.0, 920.0);
    final images = gallery.images;

    return Container(
      key: controller.galleryKey,
      constraints:
          isDesktop ? BoxConstraints(minHeight: minViewportHeight) : null,
      alignment: Alignment.center,
      // Fundo alternado em relação aos Serviços (volta para tom iluminado
      // suave)
      color: AppColors.bgPrimary(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Aurora Glow Superior Esquerdo
          Positioned(
            top: -20,
            left: -30,
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
                    spreadRadius: 25,
                  ),
                ],
              ),
            ),
          ),

          // Aurora Glow Inferior Direito
          Positioned(
            bottom: -20,
            right: -30,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary
                        .withValues(alpha: isDark ? 0.10 : 0.06),
                    blurRadius: 100,
                    spreadRadius: 25,
                  ),
                ],
              ),
            ),
          ),

          // Rastro Contínuo de Patinhas
          Positioned.fill(
            child: NanoResponsiveLayout(
              desktop: (context) => MeanderingPawTrail(
                start: const Offset(0.92, 0.0),
                control1: const Offset(0.92, 0.35),
                control2: const Offset(0.08, 0.65),
                end: const Offset(0.08, 1.0),
                pawCount: 14,
                opacity: isDark ? 0.35 : 0.45,
                color: AppColors.pawTrail,
              ),
              mobile: (context) => MeanderingPawTrail(
                start: const Offset(0.92, 0.0),
                control1: const Offset(0.92, 0.35),
                control2: const Offset(0.08, 0.65),
                end: const Offset(0.08, 1.0),
                pawCount: 8,
                opacity: isDark ? 0.35 : 0.45,
                color: AppColors.pawTrail,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 36 : 48,
            ),
            child: ResponsiveContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cabeçalho da Seção com consistência visual
                  SectionTag(
                    text: gallery.badge.isNotEmpty
                        ? gallery.badge
                        : 'MOMENTOS FELIZES',
                    icon: Icons.pets_rounded,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    gallery.title,
                    textAlign: TextAlign.center,
                    style: AppTypography.displayMedium(
                      color: AppColors.textPrimary(context),
                    ).copyWith(
                      fontSize: isDesktop ? 34 : 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      height: 1.18,
                    ),
                  ),
                  if (gallery.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: Text(
                        gallery.subtitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium(
                          color: AppColors.textSecondary(context),
                        ).copyWith(
                          fontSize: 15.5,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),

                  // Galeria Adaptativa e Harmoniosa
                  NanoResponsiveLayout(
                    desktop: (context) => GalleryDesktopGrid(
                      images: images,
                    ),
                    tablet: (context) => GalleryDesktopGrid(
                      images: images,
                      crossAxisCount: 2,
                    ),
                    mobile: (context) => GalleryHorizontalCarousel(
                      images: images,
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
