import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';
import 'package:vila_chico_bento_site/core/widgets/brand_icons.dart';
import 'package:vila_chico_bento_site/core/widgets/meandering_paw_trail.dart';
import 'package:vila_chico_bento_site/core/widgets/responsive_container.dart';
import 'package:vila_chico_bento_site/core/widgets/section_tag.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_state.dart';
import 'widgets/free_3d_mascot_dog.dart';

class ContactCtaSection extends StatelessWidget {
  const ContactCtaSection({
    required this.state,
    required this.controller,
    super.key,
  });

  final HomeState state;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final contact = state.contact;
    final isDark = context.theme.isDark;
    final isDesktop = context.screen.isDesktop;
    final isMobile = context.screen.isMobile;
    final minHeight =
        isDesktop ? (context.screen.height - 86).clamp(580.0, 1000.0) : 0.0;

    return Container(
      key: controller.contactKey,
      constraints: isDesktop ? BoxConstraints(minHeight: minHeight) : null,
      alignment: Alignment.center,
      color: AppColors.bgPrimary(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Card Container Principal
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 26 : 36,
            ),
            child: ResponsiveContainer(
              maxWidth: 920,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 44,
                  vertical: isMobile ? 22 : 30,
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
                      text: contact.badgeDisplay,
                      icon: Icons.chat_rounded,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      contact.titleDisplay,
                      textAlign: TextAlign.center,
                      style: isDesktop
                          ? AppTypography.displaySmall(
                              color: AppColors.textPrimary(context),
                            )
                          : AppTypography.titleLarge(
                              color: AppColors.textPrimary(context),
                            ),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child: Text(
                        contact.subtitleDisplay,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyLarge(
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ),
                    SizedBox(height: isDesktop ? 20 : 28),

                    // Botões de Conversão
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.openWhatsApp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.whatsapp,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 24 : 20,
                              vertical: isDesktop ? 15 : 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            elevation: 4,
                            shadowColor:
                                AppColors.whatsapp.withValues(alpha: 0.4),
                          ),
                          icon: BrandIcons.whatsapp(color: Colors.white),
                          label: Text(
                            l10n.btnWhatsapp,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: controller.openInstagram,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary(context),
                            side: BorderSide(
                              color: AppColors.instagram.withValues(alpha: 0.6),
                              width: 1.5,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 22 : 18,
                              vertical: isDesktop ? 15 : 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          icon: BrandIcons.instagram(),
                          label: Text(
                            l10n.btnInstagram,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isDesktop ? 20 : 28),

                    // Cãozinho 3D SOLTO no final da trilha
                    const Free3DMascotDog(),
                  ],
                ),
              ),
            ),
          ),

          // 2. Rastro Contínuo de Patinhas:
          // Conecta no ponto da seção anterior (0.50, 0.0), contorna o card
          // pela direita e termina exatamente no cãozinho adormecido!
          Positioned.fill(
            child: IgnorePointer(
              child: NanoResponsiveLayout(
                desktop: (context) => MeanderingPawTrail(
                  start: const Offset(0.50, 0.0),
                  control1: const Offset(0.92, 0.28),
                  control2: const Offset(0.88, 0.72),
                  end: const Offset(0.50, 0.86),
                  pawCount: 14,
                  opacity: isDark ? 0.38 : 0.50,
                  color: AppColors.pawTrail,
                  startWithRightFoot: true,
                ),
                mobile: (context) => MeanderingPawTrail(
                  start: const Offset(0.50, 0.0),
                  control1: const Offset(0.95, 0.28),
                  control2: const Offset(0.92, 0.72),
                  end: const Offset(0.50, 0.86),
                  pawCount: 10,
                  opacity: isDark ? 0.38 : 0.50,
                  color: AppColors.pawTrail,
                  startWithRightFoot: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
