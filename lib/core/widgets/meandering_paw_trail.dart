import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';

/// Trilha curva e contínua de patinhas calculada via Curvas de Bézier cúbicas.
/// As patinhas tocam exatamente as bordas superior (y=0.0) e inferior (y=1.0)
/// para que as seções fiquem literalmente "coladas" e unidas de ponta a ponta.
class MeanderingPawTrail extends StatelessWidget {
  const MeanderingPawTrail({
    super.key,
    required this.start,
    required this.control1,
    required this.control2,
    required this.end,
    this.pawCount = 12,
    this.color = AppColors.primary,
    this.baseSize = 32.0,
    this.opacity = 0.48,
    this.lateralOffset = 14.0,
    this.startWithRightFoot = false,
  });

  /// Ponto inicial relativo (0.0 a 1.0)
  final Offset start;

  /// Ponto de controle 1 relativo (0.0 a 1.0)
  final Offset control1;

  /// Ponto de controle 2 relativo (0.0 a 1.0)
  final Offset control2;

  /// Ponto final relativo (0.0 a 1.0)
  final Offset end;

  /// Quantidade de passos de patinhas ao longo da seção
  final int pawCount;

  /// Cor da patinha
  final Color color;

  /// Tamanho da patinha
  final double baseSize;

  /// Opacidade média
  final double opacity;

  /// Distância lateral entre a pata esquerda e direita
  final double lateralOffset;

  /// Alterna o primeiro pé para continuidade de passada entre seções
  final bool startWithRightFoot;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        if (width <= 0 || height <= 0) return const SizedBox.shrink();

        // Converte coordenadas relativas para absolutas
        final p0 = Offset(start.dx * width, start.dy * height);
        final p1 = Offset(control1.dx * width, control1.dy * height);
        final p2 = Offset(control2.dx * width, control2.dy * height);
        final p3 = Offset(end.dx * width, end.dy * height);

        final isSmallScreen = width < 680;
        // Passo constante em pixels:
        // - Mobile: 88.0 (já aprovado pelo usuário como perfeito)
        // - Telas maiores: 66.0 para passos mais próximos e contínuos, eliminando o vão entre seções
        final stepDistance = isSmallScreen ? 88.0 : 66.0;
        final effectivePawCount = (height / stepDistance).round().clamp(6, 36);

        final pawWidgets = <Widget>[];

        for (int i = 0; i < effectivePawCount; i++) {
          // Distribuição métrica com meio passo de respiro nas bordas para continuidade
          // perfeita e sem encavalamento de passos na junção entre seções consecutivas.
          final t = (i + 0.5) / effectivePawCount;
          final isEven = (i % 2 == 0) ^ startWithRightFoot;

          // Fórmula de Bézier Cúbica: B(t)
          final oneMinusT = 1.0 - t;
          final bX = math.pow(oneMinusT, 3) * p0.dx +
              3 * math.pow(oneMinusT, 2) * t * p1.dx +
              3 * oneMinusT * math.pow(t, 2) * p2.dx +
              math.pow(t, 3) * p3.dx;

          final bY = math.pow(oneMinusT, 3) * p0.dy +
              3 * math.pow(oneMinusT, 2) * t * p1.dy +
              3 * oneMinusT * math.pow(t, 2) * p2.dy +
              math.pow(t, 3) * p3.dy;

          // Derivada B'(t) para calcular o ângulo da tangente (direção da passada)
          final dX = 3 * math.pow(oneMinusT, 2) * (p1.dx - p0.dx) +
              6 * oneMinusT * t * (p2.dx - p1.dx) +
              3 * math.pow(t, 2) * (p3.dx - p2.dx);

          final dY = 3 * math.pow(oneMinusT, 2) * (p1.dy - p0.dy) +
              6 * oneMinusT * t * (p2.dy - p1.dy) +
              3 * math.pow(t, 2) * (p3.dy - p2.dy);

          // Ângulo tangencial da caminhada
          final tangentAngle = math.atan2(dY, dX) + (math.pi / 2);

          // Vetor normal para alternar passada esquerda e direita
          final length = math.sqrt(dX * dX + dY * dY);
          final normX = length > 0 ? -dY / length : 0.0;
          final normY = length > 0 ? dX / length : 0.0;

          final side = isEven ? -1.0 : 1.0;
          final responsiveBaseSize =
              isSmallScreen ? (baseSize * 0.68).clamp(18.0, 24.0) : baseSize;
          final responsiveOffset =
              isSmallScreen ? lateralOffset * 0.60 : lateralOffset;

          final rawPosX = bX + normX * responsiveOffset * side;
          final posY = bY + normY * responsiveOffset * side;

          // Margem de segurança para nunca cortar a patinha nas bordas da tela
          final safeMargin = (responsiveBaseSize / 2) + 14.0;
          final minX = safeMargin;
          final maxX = math.max(minX, width - safeMargin);
          final posX = rawPosX.clamp(minX, maxX);

          // Leve variação de tamanho para efeito orgânico
          final pawSize = responsiveBaseSize + (isEven ? 1.0 : -1.0);
          final stepAngle = tangentAngle + (side * 0.12);

          // Margem vertical: no desktop fica sutil (4px) para manter a cadência
          // de passos idêntica e sem lacuna entre a última pata de uma seção e a primeira da próxima
          final verticalGap = isSmallScreen ? 14.0 : 4.0;
          final verticalMargin = (pawSize / 2) + verticalGap;
          final clampedY = posY.clamp(
            verticalMargin,
            math.max(verticalMargin, height - verticalMargin),
          );

          pawWidgets.add(
            Positioned(
              left: posX - (pawSize / 2),
              top: clampedY - (pawSize / 2),
              child: IgnorePointer(
                child: Transform.rotate(
                  angle: stepAngle,
                  child: Icon(
                    Icons.pets_rounded,
                    size: pawSize,
                    color: color.withValues(alpha: opacity),
                  ),
                ),
              ),
            ),
          );
        }

        return Stack(
          clipBehavior: Clip.none,
          children: pawWidgets,
        );
      },
    );
  }
}
