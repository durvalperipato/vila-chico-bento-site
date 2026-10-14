import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/constants/app_assets.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';

/// Mascote 3D SOLTO no layout (sem caixa/container fechado), respirando e descansando feliz no final da trilha!
class Free3DMascotDog extends StatefulWidget {
  const Free3DMascotDog({super.key});

  @override
  State<Free3DMascotDog> createState() => _Free3DMascotDogState();
}

class _Free3DMascotDogState extends State<Free3DMascotDog>
    with TickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathAnim;
  late final AnimationController _zzzController;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _breathAnim = CurvedAnimation(
      parent: _breathController,
      curve: Curves.easeInOutSine,
    );

    _zzzController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void dispose() {
    _breathController.dispose();
    _zzzController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isMobile = context.screen.isMobile;
    final isDark = context.theme.isDark;
    final dogWidth = isMobile ? 260.0 : 330.0;

    final bubbleBg = isDark
        ? const Color(0xFF0F172A).withValues(alpha: 0.90)
        : Colors.white.withValues(alpha: 0.96);
    final bubbleBorder =
        AppColors.primary.withValues(alpha: isDark ? 0.40 : 0.30);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Balão de Fala estilo História em Quadrinhos / Cartoon Moderno
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? 310 : 460,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 22,
                  vertical: isMobile ? 12 : 14,
                ),
                decoration: BoxDecoration(
                  color: bubbleBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: bubbleBorder,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.35)
                          : AppColors.primary.withValues(alpha: 0.10),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            l10n.mascotBadge,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                AppColors.accentGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color:
                                  AppColors.accentGreen.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            l10n.mascotBattery,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '"${l10n.mascotSpeech}"',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 13.5 : 14.5,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.mascotStatus,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),

              // Biquinho triangular do balão apontando para o cachorrinho
              CustomPaint(
                size: const Size(20, 10),
                painter: _SpeechBubblePointerPainter(
                  color: bubbleBg,
                  borderColor: bubbleBorder,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // 2. Cachorrinho 3D SOLTO com Respiração Animada,
        // Sombra de Contato e Zzz
        SizedBox(
          width: dogWidth,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              // Sombra de Contato Realista no Chão
              AnimatedBuilder(
                animation: _breathAnim,
                builder: (context, child) {
                  final scale = 0.95 + 0.05 * _breathAnim.value;
                  return Transform.scale(
                    scaleX: scale,
                    scaleY: scale,
                    child: Container(
                      width: dogWidth * 0.78,
                      height: isMobile ? 16 : 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(
                              dogWidth * 0.78, isMobile ? 16 : 22),
                        ),
                        gradient: RadialGradient(
                          radius: 0.85,
                          colors: [
                            Colors.black
                                .withValues(alpha: isDark ? 0.40 : 0.22),
                            Colors.black
                                .withValues(alpha: isDark ? 0.15 : 0.06),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Figura 3D Recortada do Cãozinho
              AnimatedBuilder(
                animation: _breathAnim,
                builder: (context, child) {
                  final breathScale = 0.985 + (0.025 * _breathAnim.value);
                  return Transform.scale(
                    scaleY: breathScale,
                    alignment: Alignment.bottomCenter,
                    child: child,
                  );
                },
                child: Image.asset(
                  AppAssets.mascotDogSleeping,
                  width: dogWidth,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),

              // Efeito de Sono: Zzz
              Positioned(
                top: isMobile ? -6 : -14,
                left: isMobile ? 40 : 70,
                child: _AnimatedZzzStream(controller: _zzzController),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpeechBubblePointerPainter extends CustomPainter {
  const _SpeechBubblePointerPainter({
    required this.color,
    required this.borderColor,
  });

  final Color color;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final borderPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0);
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _SpeechBubblePointerPainter oldDelegate) =>
      color != oldDelegate.color || borderColor != oldDelegate.borderColor;
}

class _AnimatedZzzStream extends StatelessWidget {
  const _AnimatedZzzStream({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = controller.value;

        return SizedBox(
          width: 60,
          height: 50,
          child: Stack(
            children: [
              _SingleZ(
                label: 'z',
                fontSize: 12,
                progress: (t + 0.0) % 1.0,
                startX: 8,
              ),
              _SingleZ(
                label: 'z',
                fontSize: 15,
                progress: (t + 0.33) % 1.0,
                startX: 22,
              ),
              _SingleZ(
                label: 'Z',
                fontSize: 18,
                progress: (t + 0.66) % 1.0,
                startX: 36,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SingleZ extends StatelessWidget {
  const _SingleZ({
    required this.label,
    required this.fontSize,
    required this.progress,
    required this.startX,
  });

  final String label;
  final double fontSize;
  final double progress;
  final double startX;

  @override
  Widget build(BuildContext context) {
    final dy = -35.0 * progress;
    final dx = startX + (4.0 * progress);
    final opacity = (progress < 0.2
            ? progress / 0.2
            : (progress > 0.7 ? (1.0 - progress) / 0.3 : 1.0))
        .clamp(0.0, 1.0);

    return Positioned(
      left: dx,
      top: 30 + dy,
      child: Opacity(
        opacity: opacity,
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            shadows: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
