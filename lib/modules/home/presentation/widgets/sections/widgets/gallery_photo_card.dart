import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/extensions/image_provider_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';

/// Card de foto interativo da galeria com curvatura orgânica inspirada na almofadinha da pata (paw pad).
class GalleryPhotoCard extends StatefulWidget {
  const GalleryPhotoCard({
    required this.imageUrl,
    this.index = 0,
    this.borderRadius,
    super.key,
  });

  final String imageUrl;
  final int index;
  final BorderRadius? borderRadius;

  @override
  State<GalleryPhotoCard> createState() => _GalleryPhotoCardState();
}

class _GalleryPhotoCardState extends State<GalleryPhotoCard> {
  bool _isHovered = false;

  /// Retorna o radius orgânico inspirado na pata canina
  BorderRadius _getOrganicRadius() {
    if (widget.borderRadius != null) return widget.borderRadius!;

    // Alterna a geometria sutil entre as fotos para criar um ritmo visual orgânico
    switch (widget.index % 3) {
      case 0:
        // Coxim lateral esquerdo (curvatura mais acentuada no topo esquerdo)
        return const BorderRadius.only(
          topLeft: Radius.circular(46),
          topRight: Radius.circular(22),
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(52),
        );
      case 1:
        // Coxim central (almofada principal da pata: topo mais suave e base acolhedora)
        return const BorderRadius.only(
          topLeft: Radius.circular(52),
          topRight: Radius.circular(52),
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        );
      case 2:
      default:
        // Coxim lateral direito (curvatura mais acentuada no topo direito)
        return const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(46),
          bottomLeft: Radius.circular(52),
          bottomRight: Radius.circular(22),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.isDark;
    final organicRadius = _getOrganicRadius();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -6 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: organicRadius,
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.5)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : const Color(0xFFF1EAE2)),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.20)
                  : (isDark
                      ? Colors.black.withValues(alpha: 0.25)
                      : const Color(0xFF8A532B).withValues(alpha: 0.05)),
              blurRadius: _isHovered ? 24 : 14,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: organicRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Imagem da foto com micro-zoom sutil no hover
              AnimatedScale(
                scale: _isHovered ? 1.04 : 1.0,
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                child: Image(
                  image: widget.imageUrl.toImageProvider(),
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return NanoSkeleton.box(
                      borderRadius: organicRadius,
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.bgCard(context),
                      child: Center(
                        child: Icon(
                          Icons.pets_rounded,
                          size: 36,
                          color: AppColors.primary.withValues(alpha: 0.5),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Gradiente sutil no rodapé no hover
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 60,
                child: AnimatedOpacity(
                  opacity: _isHovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.35),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Micro-selo flutuante de patinha no hover
              Positioned(
                bottom: 14,
                right: 14,
                child: AnimatedOpacity(
                  opacity: _isHovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard(context).withValues(alpha: 0.92),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.pets_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
