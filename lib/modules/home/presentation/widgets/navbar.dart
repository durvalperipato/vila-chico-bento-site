import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/constants/app_assets.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import 'package:vila_chico_bento_site/core/localization/app_language.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';
import 'package:vila_chico_bento_site/core/widgets/brand_icons.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_state.dart';

class Navbar extends StatelessWidget {
  const Navbar({required this.controller, super.key});
  final HomeController controller;

  void _openMobileMenu(BuildContext context) {
    final l10n = context.l10n;
    final isDark = controller.isDarkMode;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border(
                top: BorderSide(
                    color: AppColors.borderSubtle(isDark), width: 1.5),
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
                    color: AppColors.textMuted(isDark).withValues(alpha: 0.3),
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
                                color: AppColors.textPrimary(isDark),
                              ),
                            ),
                            Text(
                              'Creche & Hotel Canino',
                              style: AppTypography.labelSmall(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.textPrimary(isDark),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Divider(color: AppColors.borderSubtle(isDark)),
                const SizedBox(height: 12),

                // Links de Navegação Mobile
                _MobileNavLink(
                  icon: Icons.home_rounded,
                  label: l10n.navHome,
                  onTap: () {
                    Navigator.pop(ctx);
                    controller.navigateToSection(
                      HomeNavSection.hero,
                      controller.heroKey,
                    );
                  },
                  isDark: isDark,
                ),
                _MobileNavLink(
                  icon: Icons.favorite_rounded,
                  label: l10n.navAbout,
                  onTap: () {
                    Navigator.pop(ctx);
                    controller.navigateToSection(
                      HomeNavSection.about,
                      controller.aboutKey,
                    );
                  },
                  isDark: isDark,
                ),
                _MobileNavLink(
                  icon: Icons.sports_baseball_rounded,
                  label: l10n.navServices,
                  onTap: () {
                    Navigator.pop(ctx);
                    controller.navigateToSection(
                      HomeNavSection.services,
                      controller.servicesKey,
                    );
                  },
                  isDark: isDark,
                ),
                _MobileNavLink(
                  icon: Icons.photo_camera_rounded,
                  label: l10n.navGallery,
                  onTap: () {
                    Navigator.pop(ctx);
                    controller.navigateToSection(
                      HomeNavSection.gallery,
                      controller.galleryKey,
                    );
                  },
                  isDark: isDark,
                ),
                _MobileNavLink(
                  icon: Icons.place_rounded,
                  label: l10n.navLocation,
                  onTap: () {
                    Navigator.pop(ctx);
                    controller.navigateToSection(
                      HomeNavSection.location,
                      controller.locationKey,
                    );
                  },
                  isDark: isDark,
                ),
                _MobileNavLink(
                  icon: Icons.chat_rounded,
                  label: l10n.navContact,
                  onTap: () {
                    Navigator.pop(ctx);
                    controller.navigateToSection(
                      HomeNavSection.contact,
                      controller.contactKey,
                    );
                  },
                  isDark: isDark,
                ),

                const SizedBox(height: 24),

                // Seletor de Idioma Mobile
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Idioma: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary(isDark),
                      ),
                    ),
                    _LanguageSelector(controller: controller, isDark: isDark),
                  ],
                ),

                const SizedBox(height: 20),

                // Botão CTA Grande no Mobile
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
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
                    icon: BrandIcons.whatsapp(size: 20, color: Colors.white),
                    label: Text(
                      l10n.heroCtaWhatsapp,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = controller.isDarkMode;
    final isDesktop = NanoDeviceType.isDesktop(context);

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
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryGlow,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(AppAssets.logo),
                                  fit: BoxFit.cover,
                                ),
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
                                  color: AppColors.textPrimary(isDark),
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
                                    'Creche & Resort Canino',
                                    style: TextStyle(
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
                      ListenableBuilder(
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
                                _PillNavLink(
                                  label: l10n.navHome,
                                  isActive: active == HomeNavSection.hero,
                                  onTap: () => controller.navigateToSection(
                                    HomeNavSection.hero,
                                    controller.heroKey,
                                  ),
                                  isDark: isDark,
                                ),
                                _PillNavLink(
                                  label: l10n.navAbout,
                                  isActive: active == HomeNavSection.about,
                                  onTap: () => controller.navigateToSection(
                                    HomeNavSection.about,
                                    controller.aboutKey,
                                  ),
                                  isDark: isDark,
                                ),
                                _PillNavLink(
                                  label: l10n.navServices,
                                  isActive: active == HomeNavSection.services,
                                  onTap: () => controller.navigateToSection(
                                    HomeNavSection.services,
                                    controller.servicesKey,
                                  ),
                                  isDark: isDark,
                                ),
                                _PillNavLink(
                                  label: l10n.navGallery,
                                  isActive: active == HomeNavSection.gallery,
                                  onTap: () => controller.navigateToSection(
                                    HomeNavSection.gallery,
                                    controller.galleryKey,
                                  ),
                                  isDark: isDark,
                                ),
                                _PillNavLink(
                                  label: l10n.navLocation,
                                  isActive: active == HomeNavSection.location,
                                  onTap: () => controller.navigateToSection(
                                    HomeNavSection.location,
                                    controller.locationKey,
                                  ),
                                  isDark: isDark,
                                ),
                                _PillNavLink(
                                  label: l10n.navContact,
                                  isActive: active == HomeNavSection.contact,
                                  onTap: () => controller.navigateToSection(
                                    HomeNavSection.contact,
                                    controller.contactKey,
                                  ),
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                    // Ações (Tema, Idioma, CTA no Desktop ou Hambúrguer no Mobile)
                    if (isDesktop)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ThemeToggle(
                            controller: controller,
                            isDark: isDark,
                          ),
                          const SizedBox(width: 8),
                          _LanguageSelector(
                            controller: controller,
                            isDark: isDark,
                          ),
                          const SizedBox(width: 12),
                          _NavCtaPill(
                            label: 'Agendar Adaptação',
                            onTap: controller.openWhatsApp,
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ThemeToggle(
                            controller: controller,
                            isDark: isDark,
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            onPressed: controller.openWhatsApp,
                            tooltip: 'WhatsApp',
                            icon: BrandIcons.whatsapp(size: 22),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.black.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () => _openMobileMenu(context),
                              tooltip: 'Menu',
                              icon: Icon(
                                Icons.menu_rounded,
                                color: AppColors.textPrimary(isDark),
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

class _PillNavLink extends StatefulWidget {
  const _PillNavLink({
    required this.label,
    required this.onTap,
    required this.isDark,
    this.isActive = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final bool isActive;

  @override
  State<_PillNavLink> createState() => _PillNavLinkState();
}

class _PillNavLinkState extends State<_PillNavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isActive;

    final bgColor = isSelected
        ? AppColors.primary.withValues(alpha: 0.18)
        : (_isHovered
            ? (widget.isDark
                ? Colors.white10
                : Colors.black.withValues(alpha: 0.05))
            : Colors.transparent);

    final textColor = isSelected
        ? (widget.isDark ? const Color(0xFFFBBF24) : AppColors.primary)
        : (_isHovered
            ? AppColors.textPrimary(widget.isDark)
            : AppColors.textSecondary(widget.isDark));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: textColor,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavCtaPill extends StatefulWidget {
  const _NavCtaPill({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_NavCtaPill> createState() => _NavCtaPillState();
}

class _NavCtaPillState extends State<_NavCtaPill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isHovered
                  ? [AppColors.whatsappHover, const Color(0xFF16A34A)]
                  : [AppColors.whatsapp, AppColors.whatsappHover],
            ),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: AppColors.whatsapp
                    .withValues(alpha: _isHovered ? 0.5 : 0.3),
                blurRadius: _isHovered ? 16 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BrandIcons.whatsapp(size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileNavLink extends StatelessWidget {
  const _MobileNavLink({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(
        label,
        style: AppTypography.titleMedium(
          color: AppColors.textPrimary(isDark),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textMuted(isDark),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({required this.controller, required this.isDark});
  final HomeController controller;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AppLanguage>(
          value: controller.currentLanguage,
          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 15,
            color: AppColors.textMuted(isDark),
          ),
          focusColor: Colors.transparent,
          items: AppLanguage.values.map((lang) {
            return DropdownMenuItem<AppLanguage>(
              value: lang,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(lang.flagEmoji, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 4),
                  Text(
                    lang.code.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary(isDark),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (lang) {
            if (lang != null) controller.setLanguage(lang);
          },
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle({required this.controller, required this.isDark});
  final HomeController controller;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: controller.toggleTheme,
        tooltip: isDark ? 'Ativar Tema Solar Acolhedor' : 'Ativar Modo Escuro',
        icon: Icon(
          isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
          color: isDark ? const Color(0xFFFBBF24) : AppColors.primary,
          size: 18,
        ),
      ),
    );
  }
}
