import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/constants/app_assets.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_state.dart';
import 'widgets/navbar_mobile_menu.dart';
import 'widgets/navbar_theme_toggle.dart';
import 'widgets/pill_nav_link.dart';

/// Barra de navegação flutuante premium da Vila Chico Bento com
/// glassmorphism adaptativo.
class Navbar extends StatelessWidget {
  const Navbar({required this.controller, super.key});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = context.theme.isDark;
    final isDesktop = context.screen.isDesktop;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
        vertical: 10,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDesktop ? 100 : 20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 66,
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 20 : 16,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F172A).withValues(alpha: 0.88)
                      : Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(isDesktop ? 100 : 20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.black.withValues(alpha: 0.08),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
                      blurRadius: 28,
                      offset: const Offset(0, 10),
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand / Logo com Anel Luminoso
                    InkWell(
                      onTap: () => controller.navigateToSection(
                        HomeNavSection.hero,
                        controller.heroKey,
                      ),
                      borderRadius: BorderRadius.circular(100),
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryGlow,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withValues(alpha: isDark ? 0.5 : 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(2),
                            child: ClipOval(
                              child: Image.asset(
                                AppAssets.logo,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vila Chico Bento',
                                style: AppTypography.titleMedium(
                                  color: AppColors.textPrimary(context),
                                ).copyWith(letterSpacing: -0.2),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.accentGreen,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    l10n.brandTagline,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Links no Desktop (Pills Ativas)
                    if (isDesktop)
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: ListenableBuilder(
                            listenable: controller,
                            builder: (context, _) {
                              final active = controller.activeSection;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.04)
                                      : Colors.black.withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.06)
                                        : Colors.black.withValues(alpha: 0.04),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    PillNavLink(
                                      label: l10n.navHome,
                                      isActive: active == HomeNavSection.hero,
                                      onTap: () => controller.navigateToSection(
                                        HomeNavSection.hero,
                                        controller.heroKey,
                                      ),
                                    ),
                                    PillNavLink(
                                      label: l10n.navAbout,
                                      isActive: active == HomeNavSection.about,
                                      onTap: () => controller.navigateToSection(
                                        HomeNavSection.about,
                                        controller.aboutKey,
                                      ),
                                    ),
                                    PillNavLink(
                                      label: l10n.navServices,
                                      isActive:
                                          active == HomeNavSection.services,
                                      onTap: () => controller.navigateToSection(
                                        HomeNavSection.services,
                                        controller.servicesKey,
                                      ),
                                    ),
                                    PillNavLink(
                                      label: l10n.navGallery,
                                      isActive:
                                          active == HomeNavSection.gallery,
                                      onTap: () => controller.navigateToSection(
                                        HomeNavSection.gallery,
                                        controller.galleryKey,
                                      ),
                                    ),
                                    PillNavLink(
                                      label: l10n.navLocation,
                                      isActive:
                                          active == HomeNavSection.location,
                                      onTap: () => controller.navigateToSection(
                                        HomeNavSection.location,
                                        controller.locationKey,
                                      ),
                                    ),
                                    PillNavLink(
                                      label: l10n.navContact,
                                      isActive:
                                          active == HomeNavSection.contact,
                                      onTap: () => controller.navigateToSection(
                                        HomeNavSection.contact,
                                        controller.contactKey,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    // Ações (Tema, Idioma, CTA no Desktop ou Hambúrguer
                    // no Mobile)
                    if (isDesktop)
                      NavbarThemeToggle(controller: controller)
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NavbarThemeToggle(controller: controller),
                          const SizedBox(width: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.black.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () => NavbarMobileMenuSheet.show(
                                  context, controller),
                              tooltip: 'Menu',
                              icon: Icon(
                                Icons.menu_rounded,
                                color: AppColors.textPrimary(context),
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
