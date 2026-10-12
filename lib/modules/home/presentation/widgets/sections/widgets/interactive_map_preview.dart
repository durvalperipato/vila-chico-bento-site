import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/constants/app_constants.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/widgets/map_embed/map_embed.dart';

/// Container com Prévia Visual Estilizada do Mapa e Pin Marcador.
class InteractiveMapPreview extends StatelessWidget {
  const InteractiveMapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return NanoResponsiveLayout(
      desktop: (context) => const _MapContainer(height: 360.0),
      mobile: (context) => const _MapContainer(height: 260.0),
    );
  }
}

class _MapContainer extends StatelessWidget {
  const _MapContainer({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.isDark;
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
