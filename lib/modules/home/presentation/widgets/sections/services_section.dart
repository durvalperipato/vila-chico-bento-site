import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/extensions/image_provider_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';
import 'package:vila_chico_bento_site/core/widgets/meandering_paw_trail.dart';
import 'package:vila_chico_bento_site/core/widgets/responsive_container.dart';
import 'package:vila_chico_bento_site/core/widgets/section_tag.dart';
import 'package:vila_chico_bento_site/modules/home/domain/entities/home_view_content.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_state.dart';

/// Seção Serviços no formato Opção 2 (Triptych com Mini-Fotos Reais):
/// 3 colunas bem distribuídas no Desktop (Esquerda, Meio, Direita),
/// com fotografias reais dos cães em cada serviço, contraste sutil de fundo
/// em relação à seção anterior e botões de ação personalizados para cada
/// serviço.
class ServicesSection extends StatelessWidget {
  const ServicesSection({
    required this.state,
    required this.controller,
    super.key,
  });

  final HomeState state;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final services = state.services;
    final isDark = context.theme.isDark;
    final isDesktop = context.screen.isDesktop;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final minViewportHeight = (screenHeight - 86).clamp(620.0, 940.0);

    return Container(
      key: controller.servicesKey,
      constraints:
          isDesktop ? BoxConstraints(minHeight: minViewportHeight) : null,
      alignment: Alignment.center,
      // Fundo ligeiramente contrastante com a seção anterior
      color: AppColors.bgSurface(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Aurora Glow Superior Direito
          Positioned(
            top: -20,
            right: -30,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGreen
                        .withValues(alpha: isDark ? 0.12 : 0.08),
                    blurRadius: 100,
                    spreadRadius: 25,
                  ),
                ],
              ),
            ),
          ),

          // Aurora Glow Inferior Esquerdo
          Positioned(
            bottom: -20,
            left: -30,
            child: Container(
              width: 300,
              height: 300,
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

          // Rastro Contínuo de Patinhas
          Positioned.fill(
            child: NanoResponsiveLayout(
              desktop: (context) => MeanderingPawTrail(
                start: const Offset(0.08, 0.0),
                control1: const Offset(0.08, 0.45),
                control2: const Offset(0.92, 0.65),
                end: const Offset(0.92, 1.0),
                pawCount: 14,
                opacity: isDark ? 0.35 : 0.45,
                color: AppColors.pawTrail,
              ),
              mobile: (context) => MeanderingPawTrail(
                start: const Offset(0.08, 0.0),
                control1: const Offset(0.08, 0.45),
                control2: const Offset(0.92, 0.65),
                end: const Offset(0.92, 1.0),
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
                    text: services.badgeDisplay,
                    icon: Icons.pets_rounded,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    services.titleDisplay,
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
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Text(
                      services.subtitleDisplay,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium(
                        color: AppColors.textSecondary(context),
                      ).copyWith(
                        fontSize: 15.5,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 3 Cards em Colunas no Desktop (Esquerda, Meio, Direita) ou
                  // Coluna no Mobile
                  if (isDesktop)
                    _buildDesktopColumns(context, services.items)
                  else
                    _buildMobileStack(context, services.items),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 3 Colunas perfeitamente distribuídas (Esquerda, Centro, Direita)
  Widget _buildDesktopColumns(
    BuildContext context,
    List<ServiceItemContent> items,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 24),
            Expanded(
              child: _ServicePhotoCard(
                service: items[i],
                photoUrl: items[i].image,
                chipLabel: items[i].badge,
                ctaLabel: items[i].actionText,
                controller: controller,
                isFeatured: i == 0,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Mobile: Cards empilhados naturalmente
  Widget _buildMobileStack(
    BuildContext context,
    List<ServiceItemContent> items,
  ) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 20),
          _ServicePhotoCard(
            service: items[i],
            photoUrl: items[i].image,
            chipLabel: items[i].badge,
            ctaLabel: items[i].actionText,
            controller: controller,
            isFeatured: i == 0,
          ),
        ],
      ],
    );
  }
}

/// Card de Serviço com Mini-Foto Real no topo, tipografia aconchegante e CTA
/// exclusivo
class _ServicePhotoCard extends StatefulWidget {
  const _ServicePhotoCard({
    required this.service,
    required this.photoUrl,
    required this.chipLabel,
    required this.ctaLabel,
    required this.controller,
    this.isFeatured = false,
  });

  final ServiceItemContent service;
  final String photoUrl;
  final String chipLabel;
  final String ctaLabel;
  final HomeController controller;
  final bool isFeatured;

  @override
  State<_ServicePhotoCard> createState() => _ServicePhotoCardState();
}

class _ServicePhotoCardState extends State<_ServicePhotoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.isDark;
    final service = widget.service;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -6 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.bgCard(context),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered
                ? service.accentColor.withValues(alpha: 0.45)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFF1EAE2)),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? service.accentColor.withValues(alpha: 0.14)
                  : (isDark
                      ? Colors.black.withValues(alpha: 0.25)
                      : const Color(0xFF8A532B).withValues(alpha: 0.05)),
              blurRadius: _isHovered ? 24 : 14,
              offset: Offset(0, _isHovered ? 10 : 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Fotografia Temática do Serviço com Micro-Chip
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.photoUrl.isNotEmpty)
                    Image(
                      image: widget.photoUrl.toImageProvider(),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return NanoSkeleton.box(
                          color: AppColors.bgCard(context),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: service.accentColor.withValues(alpha: 0.1),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.pets_rounded,
                          size: 40,
                          color: service.accentColor,
                        ),
                      ),
                    )
                  else
                    Container(
                      color: service.accentColor.withValues(alpha: 0.1),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.pets_rounded,
                        size: 40,
                        color: service.accentColor,
                      ),
                    ),

                  // Gradiente sutil na base da foto
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 60,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.40),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Micro-Chip de Destaque
                  if (widget.chipLabel.isNotEmpty)
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color:
                              AppColors.bgCard(context).withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.chipLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: service.accentColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 2. Conteúdo do Serviço
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: service.accentColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.pets_rounded,
                          size: 16,
                          color: service.accentColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          service.title,
                          style: AppTypography.titleMedium(
                            color: AppColors.textPrimary(context),
                          ).copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    service.description,
                    style: AppTypography.bodyMedium(
                      color: AppColors.textSecondary(context),
                    ).copyWith(
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                  // 3. Link de Ação Editorial Elegante com Seta Animada
                  if (widget.ctaLabel.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () => widget.controller.openWhatsApp(
                        customMessage: service.whatsappMessage,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.ctaLabel,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: service.accentColor,
                                letterSpacing: -0.1,
                              ),
                            ),
                            const SizedBox(width: 6),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              transform: Matrix4.translationValues(
                                _isHovered ? 4 : 0,
                                0,
                                0,
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: service.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
