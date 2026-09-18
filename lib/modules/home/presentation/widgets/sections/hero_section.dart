import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/constants/app_assets.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/widgets/brand_icons.dart';
import 'package:vila_chico_bento_site/core/widgets/responsive_container.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_state.dart';

/// Hero Section em formato Cinemático Full-Bleed (Estilo Apple / Airbnb Luxury).
/// Imersão visual total de ponta a ponta com fotografia panorâmica em alta resolução,
/// vinhetas cinematográficas e dock flutuante de confiança.
class HeroSection extends StatelessWidget {
  const HeroSection({required this.controller, super.key});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = controller.isDarkMode;
    final isDesktop = NanoDeviceType.isDesktop(context);
    final isMobile = NanoDeviceType.isMobile(context);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final minHeight = (screenHeight - 86).clamp(700.0, 1100.0);

    return Container(
      key: controller.heroKey,
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.14),
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Fotografia Panorâmica de Fundo (Full Bleed com acabamento escultural)
          Positioned.fill(
            child: Image.network(
              AppAssets.heroMainImage,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return NanoSkeleton.box(
                  color: const Color(0xFF0F172A),
                  highlightColor: const Color(0xFF1E293B),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF0F172A),
              ),
            ),
          ),

          // 2. Camadas de Vinheta Cinematográfica para Contraste e Legibilidade
          // 2.1. Base de escurecimento equilibrada (mantém os cães vivos e solares)
          Positioned.fill(
            child: Container(
              color: const Color(0xFF0F172A).withValues(alpha: 0.52),
            ),
          ),

          // 2.2. Vinheta Radial suave (foco no centro com atmosfera cinematográfica)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.15,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF0F172A).withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
          ),

          // 2.3. Gradiente Superior Suave (proteção da Navbar flutuante)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0F172A).withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 3. Conteúdo Central de Alto Impacto
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24,
              vertical: isMobile ? 60 : 80,
            ),
            child: ResponsiveContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Selo Acolhedor Artesanal (Identidade Exclusiva Vila Chico Bento)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 22,
                          vertical: isMobile ? 8 : 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFE07A2A).withValues(alpha: 0.35),
                              const Color(0xFFF59E0B).withValues(alpha: 0.22),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color:
                                const Color(0xFFF59E0B).withValues(alpha: 0.65),
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF59E0B)
                                  .withValues(alpha: 0.25),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.pets_rounded,
                              size: 16,
                              color: Color(0xFFFDE047),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.heroBadge.replaceAll('🐾 ', ''),
                              style: GoogleFonts.outfit(
                                fontSize: isMobile ? 13 : 14.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: const Color(0xFFFEF3C7),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '✨',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // TÍTULO EDITORIAL GIGANTE
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 920),
                    child: Text(
                      l10n.heroTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: isDesktop ? 54 : (isMobile ? 32 : 42),
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        letterSpacing: -1.0,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.60),
                            blurRadius: 24,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SUBTÍTULO DESCRITIVO E ENVOLVENTE
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Text(
                      l10n.heroSubtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: isDesktop ? 18 : 15,
                        fontWeight: FontWeight.w400,
                        height: 1.65,
                        color: Colors.white.withValues(alpha: 0.88),
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.50),
                            blurRadius: 16,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // GRUPO DE CTAs
                  Wrap(
                    spacing: 16,
                    runSpacing: 14,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Botão Principal WhatsApp com Glow
                      ElevatedButton.icon(
                        onPressed: controller.openWhatsApp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.whatsapp,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 24 : 32,
                            vertical: isMobile ? 18 : 22,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 6,
                          shadowColor:
                              AppColors.whatsapp.withValues(alpha: 0.5),
                        ),
                        icon:
                            BrandIcons.whatsapp(size: 22, color: Colors.white),
                        label: Text(
                          l10n.heroCtaWhatsapp,
                          style: TextStyle(
                            fontSize: isMobile ? 15 : 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),

                      // Botão Secundário Glassmorphic
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: OutlinedButton.icon(
                            onPressed: () => controller.navigateToSection(
                              HomeNavSection.services,
                              controller.servicesKey,
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.08),
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.35),
                                width: 1.5,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 22 : 28,
                                vertical: isMobile ? 18 : 22,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            icon: const Icon(
                              Icons.arrow_downward_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            label: Text(
                              l10n.heroCtaServices,
                              style: TextStyle(
                                fontSize: isMobile ? 15 : 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  // Destaques de Confiança (Leves, sem container, direto na atmosfera da foto)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: isMobile ? 18 : 28,
                      runSpacing: 10,
                      children: const [
                        _PillarBadge(
                          icon: Icons.park_rounded,
                          label: 'Área Verde ao Ar Livre',
                          color: AppColors.accentGreen,
                        ),
                        _PillarBadge(
                          icon: Icons.favorite_rounded,
                          label: '100% Livre de Baias',
                          color: AppColors.primary,
                        ),
                        _PillarBadge(
                          icon: Icons.shield_rounded,
                          label: 'Supervisão Atenta',
                          color: Colors.amber,
                        ),
                        _PillarBadge(
                          icon: Icons.location_on_rounded,
                          label: 'Pinhais / PR',
                          color: Colors.cyanAccent,
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

class _PillarBadge extends StatelessWidget {
  const _PillarBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
          shadows: const [
            Shadow(
              color: Colors.black87,
              blurRadius: 6,
              offset: Offset(0, 1),
            ),
          ],
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: const [
              Shadow(
                color: Colors.black87,
                blurRadius: 8,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
