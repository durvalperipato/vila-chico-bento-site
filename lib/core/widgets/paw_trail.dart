import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';

/// Divisor de seção e elemento lúdico que representa um rastro de patinhas
/// de cãozinho cruzando a tela com rotações e opacidades orgânicas.
class PawTrailDivider extends StatelessWidget {
  const PawTrailDivider({
    super.key,
    this.color = AppColors.primary,
    this.height = 48.0,
    this.pawsCount = 7,
  });

  final Color color;
  final double height;
  final int pawsCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(pawsCount, (index) {
            final isEven = index % 2 == 0;
            // Opacidade em sino (mais forte no meio, suave nas pontas)
            final normalizedPos =
                (index - (pawsCount / 2)).abs() / (pawsCount / 2);
            final opacity =
                (0.35 * (1.0 - (normalizedPos * 0.75))).clamp(0.08, 0.40);
            final rotation = isEven ? -14.0 : 18.0;
            final yOffset = isEven ? 5.0 : -5.0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Transform.translate(
                offset: Offset(0, yOffset),
                child: Transform.rotate(
                  angle: rotation * (math.pi / 180),
                  child: Icon(
                    Icons.pets_rounded,
                    size: 18,
                    color: color.withValues(alpha: opacity),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// Decoração sutil de patinhas flutuantes para fundos de seções
class BackgroundPaws extends StatelessWidget {
  const BackgroundPaws({
    super.key,
    this.color = AppColors.primary,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 30,
          left: 40,
          child: Transform.rotate(
            angle: 25 * (math.pi / 180),
            child: Icon(
              Icons.pets_rounded,
              size: 26,
              color: color.withValues(alpha: 0.07),
            ),
          ),
        ),
        Positioned(
          top: 75,
          left: 85,
          child: Transform.rotate(
            angle: -15 * (math.pi / 180),
            child: Icon(
              Icons.pets_rounded,
              size: 24,
              color: color.withValues(alpha: 0.12),
            ),
          ),
        ),
        Positioned(
          top: 120,
          left: 130,
          child: Transform.rotate(
            angle: 20 * (math.pi / 180),
            child: Icon(
              Icons.pets_rounded,
              size: 26,
              color: color.withValues(alpha: 0.16),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          right: 60,
          child: Transform.rotate(
            angle: -30 * (math.pi / 180),
            child: Icon(
              Icons.pets_rounded,
              size: 28,
              color: AppColors.accentGreen.withValues(alpha: 0.08),
            ),
          ),
        ),
        Positioned(
          bottom: 85,
          right: 110,
          child: Transform.rotate(
            angle: 15 * (math.pi / 180),
            child: Icon(
              Icons.pets_rounded,
              size: 24,
              color: AppColors.accentGreen.withValues(alpha: 0.13),
            ),
          ),
        ),
      ],
    );
  }
}
