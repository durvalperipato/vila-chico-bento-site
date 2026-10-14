import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/constants/app_assets.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';
import 'package:vila_chico_bento_site/core/widgets/brand_icons.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_state.dart';
import 'mobile_nav_link.dart';
// TODO(durval): Para o MVP sera usado por enquanto apenas portugues - BR
// import 'navbar_language_selector.dart';

/// Modal bottom sheet para navegação em dispositivos mobile.
class NavbarMobileMenuSheet extends StatelessWidget {
  const NavbarMobileMenuSheet({
    required this.controller,
    super.key,
  });

  final HomeController controller;

  /// Exibe o menu móvel com efeito de desfoque e transição suave.
  static Future<void> show(
    BuildContext context,
    HomeController controller,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => NavbarMobileMenuSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = context.theme.isDark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(
            top: BorderSide(color: AppColors.borderSubtle(context), width: 1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barra sutil de arrastar
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted(context).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),

            // Topo da Gaveta com Logo e Fechar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(AppAssets.logo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vila Chico Bento',
                          style: AppTypography.titleMedium(
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        Text(
                          l10n.brandTagline,
                          style: AppTypography.labelSmall(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Divider(color: AppColors.borderSubtle(context)),
            const SizedBox(height: 12),

            // Links de Navegação Mobile
            MobileNavLink(
              icon: Icons.home_rounded,
              label: l10n.navHome,
              onTap: () {
                Navigator.pop(context);
                controller.navigateToSection(
                  HomeNavSection.hero,
                  controller.heroKey,
                );
              },
            ),
            MobileNavLink(
              icon: Icons.favorite_rounded,
              label: l10n.navAbout,
              onTap: () {
                Navigator.pop(context);
                controller.navigateToSection(
                  HomeNavSection.about,
                  controller.aboutKey,
                );
              },
            ),
            MobileNavLink(
              icon: Icons.sports_baseball_rounded,
              label: l10n.navServices,
              onTap: () {
                Navigator.pop(context);
                controller.navigateToSection(
                  HomeNavSection.services,
                  controller.servicesKey,
                );
              },
            ),
            MobileNavLink(
              icon: Icons.photo_camera_rounded,
              label: l10n.navGallery,
              onTap: () {
                Navigator.pop(context);
                controller.navigateToSection(
                  HomeNavSection.gallery,
                  controller.galleryKey,
                );
              },
            ),
            MobileNavLink(
              icon: Icons.place_rounded,
              label: l10n.navLocation,
              onTap: () {
                Navigator.pop(context);
                controller.navigateToSection(
                  HomeNavSection.location,
                  controller.locationKey,
                );
              },
            ),
            MobileNavLink(
              icon: Icons.chat_rounded,
              label: l10n.navContact,
              onTap: () {
                Navigator.pop(context);
                controller.navigateToSection(
                  HomeNavSection.contact,
                  controller.contactKey,
                );
              },
            ),

            const SizedBox(height: 24),

            // TODO(durval): Para o MVP sera usado por enquanto apenas
            // portugues - BR.
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       'Idioma: ',
            //       style: TextStyle(
            //         fontSize: 14,
            //         color: AppColors.textSecondary(context),
            //       ),
            //     ),
            //     NavbarLanguageSelector(controller: controller),
            //   ],
            // ),
            // const SizedBox(height: 20),

            // Botão CTA Grande no Mobile
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  controller.openWhatsApp();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.whatsapp,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                icon: BrandIcons.whatsapp(color: Colors.white),
                label: Text(
                  l10n.navCtaSchedule,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
