import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import 'package:vila_chico_bento_site/core/extensions/image_provider_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';
import 'package:vila_chico_bento_site/core/widgets/meandering_paw_trail.dart';
import 'package:vila_chico_bento_site/core/widgets/responsive_container.dart';
import 'package:vila_chico_bento_site/core/widgets/section_tag.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_state.dart';

/// Seção Sobre Nós em layout Split Editorial com tipografia rica e foto de destaque
class AboutSection extends StatelessWidget {
  const AboutSection({
    required this.state,
    required this.controller,
    super.key,
  });

  final HomeState state;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final about = state.about;
    final isDark = context.theme.isDark;
    final isDesktop = context.screen.isDesktop;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final minViewportHeight = (screenHeight - 86).clamp(600.0, 920.0);

    final photoUrl = state.gallery.images.isNotEmpty
        ? state.gallery.images.first
        : 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=1200&q=80';

    return Container(
      key: controller.aboutKey,
      constraints:
          isDesktop ? BoxConstraints(minHeight: minViewportHeight) : null,
      alignment: Alignment.center,
      color: AppColors.bgPrimary(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Aurora Glow Superior Esquerdo
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

          // Aurora Glow Inferior Direito
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

          // Rastro de Patinhas Adaptativo
          Positioned.fill(
            child: NanoResponsiveLayout(
              desktop: (context) => MeanderingPawTrail(
                start: const Offset(0.95, 0.0),
                control1: const Offset(0.95, 0.45),
                control2: const Offset(0.05, 0.65),
                end: const Offset(0.05, 1.0),
                pawCount: 14,
                opacity: isDark ? 0.35 : 0.45,
                color: AppColors.pawTrail,
              ),
              mobile: (context) => MeanderingPawTrail(
                start: const Offset(0.95, 0.0),
                control1: const Offset(0.95, 0.45),
                control2: const Offset(0.05, 0.65),
                end: const Offset(0.05, 1.0),
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
              child: isDesktop
                  ? _buildDesktopLayout(
                      context,
                      l10n,
                      about,
                      photoUrl,
                    )
                  : _buildMobileLayout(
                      context,
                      l10n,
                      about,
                      photoUrl,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Layout Desktop: Tipografia ampla, confortável e legível, com foto proporcional
  Widget _buildDesktopLayout(
    BuildContext context,
    dynamic l10n,
    dynamic about,
    String photoUrl,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Coluna Esquerda: Texto editorial + Pilares com excelente legibilidade
        Expanded(
          flex: 6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTag(
                text: about.badge,
                icon: Icons.pets_rounded,
              ),
              const SizedBox(height: 14),
              Text(
                about.title,
                style: AppTypography.displayMedium(
                  color: AppColors.textPrimary(context),
                ).copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  height: 1.18,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                about.description,
                style: AppTypography.bodyMedium(
                  color: AppColors.textSecondary(context),
                ).copyWith(
                  height: 1.6,
                  fontSize: 15.5,
                ),
              ),
              const SizedBox(height: 22),

              // 3 Indicadores de Confiança / Cuidado Canino
              _buildTrustPill(
                context: context,
                icon: Icons.sports_baseball_rounded,
                accentColor: AppColors.primary,
                title: l10n.aboutPoint1Title,
                description: l10n.aboutPoint1Desc,
              ),
              const SizedBox(height: 12),
              _buildTrustPill(
                context: context,
                icon: Icons.favorite_rounded,
                accentColor: AppColors.accentGreen,
                title: l10n.aboutPoint2Title,
                description: l10n.aboutPoint2Desc,
              ),
              const SizedBox(height: 12),
              _buildTrustPill(
                context: context,
                icon: Icons.park_rounded,
                accentColor: AppColors.secondary,
                title: l10n.aboutPoint3Title,
                description: l10n.aboutPoint3Desc,
              ),
            ],
          ),
        ),

        const SizedBox(width: 52),

        // Coluna Direita: Fotografia Acolhedora com presença e proporção bonita
        Expanded(
          flex: 5,
          child: _buildPhotoCard(context, photoUrl, height: 490),
        ),
      ],
    );
  }

  /// Layout Mobile: Fluxo vertical natural e harmonioso
  Widget _buildMobileLayout(
    BuildContext context,
    dynamic l10n,
    dynamic about,
    String photoUrl,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTag(
          text: about.badge,
          icon: Icons.pets_rounded,
        ),
        const SizedBox(height: 14),
        Text(
          about.title,
          style: AppTypography.displaySmall(
            color: AppColors.textPrimary(context),
          ).copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 20),
        _buildPhotoCard(context, photoUrl, height: 280),
        const SizedBox(height: 20),
        Text(
          about.description,
          style: AppTypography.bodyMedium(
            color: AppColors.textSecondary(context),
          ).copyWith(
            height: 1.6,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 24),
        _buildTrustPill(
          context: context,
          icon: Icons.sports_baseball_rounded,
          accentColor: AppColors.primary,
          title: l10n.aboutPoint1Title,
          description: l10n.aboutPoint1Desc,
        ),
        const SizedBox(height: 12),
        _buildTrustPill(
          context: context,
          icon: Icons.favorite_rounded,
          accentColor: AppColors.accentGreen,
          title: l10n.aboutPoint2Title,
          description: l10n.aboutPoint2Desc,
        ),
        const SizedBox(height: 12),
        _buildTrustPill(
          context: context,
          icon: Icons.park_rounded,
          accentColor: AppColors.secondary,
          title: l10n.aboutPoint3Title,
          description: l10n.aboutPoint3Desc,
        ),
      ],
    );
  }

  /// Indicador de confiança com tipografia legível, padding confortável e sombra sutil
  Widget _buildTrustPill({
    required BuildContext context,
    required IconData icon,
    required Color accentColor,
    required String title,
    required String description,
  }) {
    final isDark = context.theme.isDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFF1EAE2),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF8A532B).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 20,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium(
                    color: AppColors.textPrimary(context),
                  ).copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: AppTypography.bodyMedium(
                    color: AppColors.textSecondary(context),
                  ).copyWith(
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fotografia Acolhedora com proporção destacada e linhas orgânicas
  Widget _buildPhotoCard(
    BuildContext context,
    String photoUrl, {
    required double height,
  }) {
    // Curvatura orgânica amigável (estilo seixo/pebble natural)
    const organicBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(72),
      topRight: Radius.circular(28),
      bottomLeft: Radius.circular(28),
      bottomRight: Radius.circular(84),
    );

    // Curvatura complementar da camada de fundo
    const backdropBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(32),
      topRight: Radius.circular(76),
      bottomLeft: Radius.circular(80),
      bottomRight: Radius.circular(28),
    );

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // 1. Camada de Fundo Decorativa Deslocada (Backdrop com tom quente)
          Positioned(
            top: 10,
            left: 10,
            right: -10,
            bottom: -10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: backdropBorderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.18),
                    AppColors.secondary.withValues(alpha: 0.10),
                  ],
                ),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
            ),
          ),

          // 2. Card Principal com a Foto
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: organicBorderRadius,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: organicBorderRadius,
                    child: Image(
                      image: photoUrl.toImageProvider(),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return NanoSkeleton.box(
                          borderRadius: organicBorderRadius,
                          color: AppColors.bgCard(context),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          color: AppColors.bgCard(context),
                          borderRadius: organicBorderRadius,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.pets_rounded,
                          size: 56,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  // Gradiente suave no rodapé da imagem
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 100,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(84),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.42),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Floating Chip de carinho no rodapé da foto
                  Positioned(
                    left: 18,
                    bottom: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            AppColors.bgCard(context).withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.pets_rounded,
                            size: 15,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Amor & Cuidado Diário',
                            style: AppTypography.labelLarge(
                              color: AppColors.textPrimary(context),
                            ).copyWith(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Selo Flutuante com Ícone de Patinha no Canto Superior Direito
          Positioned(
            top: -12,
            right: -8,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.pets_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
