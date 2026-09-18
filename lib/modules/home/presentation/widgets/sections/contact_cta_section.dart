import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/constants/app_assets.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';
import 'package:vila_chico_bento_site/core/widgets/brand_icons.dart';
import 'package:vila_chico_bento_site/core/widgets/meandering_paw_trail.dart';
import 'package:vila_chico_bento_site/core/widgets/responsive_container.dart';
import 'package:vila_chico_bento_site/core/widgets/section_tag.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';

class ContactCtaSection extends StatelessWidget {
  const ContactCtaSection({required this.controller, super.key});
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
      key: controller.contactKey,
      constraints: isDesktop ? BoxConstraints(minHeight: minHeight) : null,
      alignment: Alignment.center,
      color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Rastro Contínuo de Patinhas: chega de Location (0.50) e caminha até o cachorrinho descansando
          Positioned.fill(
            child: MeanderingPawTrail(
              start: const Offset(0.50, 0.0),
              control1: const Offset(0.50, 0.20),
              control2: const Offset(0.50, 0.40),
              end: const Offset(0.50, 0.52),
              pawCount: 7,
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
              maxWidth: 920,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 48,
                  vertical: isMobile ? 32 : 52,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            const Color(0xFF1E293B),
                            const Color(0xFF0F172A),
                          ]
                        : [
                            const Color(0xFFFFF7ED),
                            const Color(0xFFFEF3C7),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SectionTag(
                      text: l10n.contactBadge,
                      icon: Icons.chat_rounded,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.contactTitle,
                      textAlign: TextAlign.center,
                      style: isDesktop
                          ? AppTypography.displaySmall(
                              color: AppColors.textPrimary(isDark),
                            )
                          : AppTypography.titleLarge(
                              color: AppColors.textPrimary(isDark),
                            ),
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child: Text(
                        l10n.contactSubtitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyLarge(
                          color: AppColors.textSecondary(isDark),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Botões de Conversão
                    Wrap(
                      spacing: 16,
                      runSpacing: 14,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.openWhatsApp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.whatsapp,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            elevation: 4,
                            shadowColor:
                                AppColors.whatsapp.withValues(alpha: 0.4),
                          ),
                          icon: BrandIcons.whatsapp(
                              size: 20, color: Colors.white),
                          label: Text(
                            l10n.btnWhatsapp,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: controller.openInstagram,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary(isDark),
                            side: BorderSide(
                              color: AppColors.instagram.withValues(alpha: 0.6),
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          icon: BrandIcons.instagram(size: 20),
                          label: Text(
                            l10n.btnInstagram,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

                    // Cãozinho 3D SOLTO no final da trilha: percorreu todo o site e agora descansa feliz!
                    _Free3DMascotDog(
                      isDark: isDark,
                      isMobile: isMobile,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mascote 3D SOLTO no layout (sem caixa/container fechado), respirando e descansando feliz no final da trilha!
class _Free3DMascotDog extends StatefulWidget {
  const _Free3DMascotDog({
    required this.isDark,
    required this.isMobile,
  });

  final bool isDark;
  final bool isMobile;

  @override
  State<_Free3DMascotDog> createState() => _Free3DMascotDogState();
}

class _Free3DMascotDogState extends State<_Free3DMascotDog>
    with TickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathAnim;

  late final AnimationController _zzzController;

  @override
  void initState() {
    super.initState();
    // Respiração suave e reconfortante do filhotinho dormindo
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _breathAnim = CurvedAnimation(
      parent: _breathController,
      curve: Curves.easeInOutSine,
    );

    // Flutuação contínua dos Zzz de sono
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
    final isMobile = widget.isMobile;
    final isDark = widget.isDark;
    final dogWidth = isMobile ? 290.0 : 420.0;

    final bubbleBg = isDark
        ? const Color(0xFF0F172A).withValues(alpha: 0.90)
        : Colors.white.withValues(alpha: 0.96);
    final bubbleBorder =
        AppColors.primary.withValues(alpha: isDark ? 0.40 : 0.30);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Balão de Fala estilo História em Quadrinhos / Cartoon Moderno
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? 330 : 540,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 18 : 26,
                  vertical: isMobile ? 14 : 18,
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
                              width: 1,
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
                              width: 1,
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
                        color: AppColors.textPrimary(isDark),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.mascotStatus,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary(isDark),
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

        // 2. Cachorrinho 3D SOLTO com Respiração Animada, Sombra de Contato e Zzz
        SizedBox(
          width: dogWidth,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              // Sombra de Contato Realista no Chão (deformada pela respiração)
              AnimatedBuilder(
                animation: _breathAnim,
                builder: (context, child) {
                  final scale = 0.95 + 0.05 * _breathAnim.value;
                  return Transform.scale(
                    scaleX: scale,
                    scaleY: scale,
                    alignment: Alignment.center,
                    child: Container(
                      width: dogWidth * 0.78,
                      height: isMobile ? 16 : 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(
                              dogWidth * 0.78, isMobile ? 16 : 22),
                        ),
                        gradient: RadialGradient(
                          center: Alignment.center,
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

              // Figura 3D Recortada do Cãozinho (Respiração Suave de Soneca)
              AnimatedBuilder(
                animation: _breathAnim,
                builder: (context, child) {
                  // Respiração: elevação sutil no peito/barriga
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

              // Efeito de Sono: Letrinhas "Zzz" subindo suavemente da cabecinha do cachorro
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

/// Ponteiro do balão de fala apontando para a cabeça do cachorrinho
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

/// Animação dos Zzz de sono flutuando suavemente
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
              _buildSingleZ(
                label: 'z',
                fontSize: 12,
                progress: (t + 0.0) % 1.0,
                startX: 8,
              ),
              _buildSingleZ(
                label: 'z',
                fontSize: 15,
                progress: (t + 0.33) % 1.0,
                startX: 22,
              ),
              _buildSingleZ(
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

  Widget _buildSingleZ({
    required String label,
    required double fontSize,
    required double progress,
    required double startX,
  }) {
    final dy = -35.0 * progress;
    final dx = startX + (4.0 * progress);
    // Aparece suavemente no início e desvanece no topo
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
