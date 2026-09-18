import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vila_chico_bento_site/core/constants/app_assets.dart';
import 'package:vila_chico_bento_site/core/constants/app_constants.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';
import 'package:vila_chico_bento_site/core/widgets/brand_icons.dart';
import 'package:vila_chico_bento_site/core/widgets/responsive_container.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_state.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({required this.controller, super.key});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = controller.isDarkMode;
    final isMobile = NanoDeviceType.isMobile(context);
    final isDesktop = NanoDeviceType.isDesktop(context);

    return Container(
      padding: EdgeInsets.only(
        top: isMobile ? 48 : 64,
        bottom: 32,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF080D1A) : const Color(0xFFF1EDE6),
        border: Border(
          top: BorderSide(
            color: AppColors.borderSubtle(isDark),
          ),
        ),
      ),
      child: ResponsiveContainer(
        child: Column(
          children: [
            // Topo do Rodapé (Responsivo: Coluna no mobile, Linha no desktop)
            if (isMobile) ...[
              // Identidade
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(AppAssets.logo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Vila Chico Bento',
                    style: AppTypography.titleMedium(
                      color: AppColors.textPrimary(isDark),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Creche e Hospedagem para Cães com amor, liberdade e respeito em Pinhais/PR.',
                style: AppTypography.bodyMedium(
                  color: AppColors.textSecondary(isDark),
                ),
              ),
              const SizedBox(height: 24),

              // Redes e Contato (Mobile)
              Text(
                'Redes Sociais & Contato',
                style: AppTypography.labelLarge(
                  color: AppColors.textPrimary(isDark),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SocialCircleButton(
                    onPressed: controller.openWhatsApp,
                    tooltip: 'WhatsApp Oficial',
                    icon: BrandIcons.whatsapp(
                      size: 18,
                      color: Colors.white,
                    ),
                    backgroundColor: const Color(0xFF25D366),
                  ),
                  const SizedBox(width: 10),
                  _SocialCircleButton(
                    onPressed: controller.openInstagram,
                    tooltip: 'Instagram Oficial',
                    icon: BrandIcons.instagram(
                      size: 18,
                      color: Colors.white,
                    ),
                    backgroundColor: const Color(0xFFE1306C),
                  ),
                  const SizedBox(width: 10),
                  _SocialCircleButton(
                    onPressed: controller.openGoogleMaps,
                    tooltip: 'Google Maps',
                    icon: BrandIcons.googleMaps(
                      size: 18,
                      color: Colors.white,
                    ),
                    backgroundColor: const Color(0xFF1A73E8),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                AppConstants.phoneDisplay,
                style: AppTypography.bodyMedium(
                  color: AppColors.textSecondary(isDark),
                ),
              ),
            ] else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Identidade
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
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
                            Text(
                              'Vila Chico Bento',
                              style: AppTypography.titleMedium(
                                color: AppColors.textPrimary(isDark),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Creche e Hospedagem para Cães com amor,\nliberdade e respeito em Pinhais/PR.',
                          style: AppTypography.bodyMedium(
                            color: AppColors.textSecondary(isDark),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Redes e Contato (Desktop)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Redes Sociais & Contato',
                        style: AppTypography.labelLarge(
                          color: AppColors.textPrimary(isDark),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _SocialCircleButton(
                            onPressed: controller.openWhatsApp,
                            tooltip: 'WhatsApp Oficial',
                            icon: BrandIcons.whatsapp(
                              size: 18,
                              color: Colors.white,
                            ),
                            backgroundColor: const Color(0xFF25D366),
                          ),
                          const SizedBox(width: 10),
                          _SocialCircleButton(
                            onPressed: controller.openInstagram,
                            tooltip: 'Instagram Oficial',
                            icon: BrandIcons.instagram(
                              size: 18,
                              color: Colors.white,
                            ),
                            backgroundColor: const Color(0xFFE1306C),
                          ),
                          const SizedBox(width: 10),
                          _SocialCircleButton(
                            onPressed: controller.openGoogleMaps,
                            tooltip: 'Google Maps',
                            icon: BrandIcons.googleMaps(
                              size: 18,
                              color: Colors.white,
                            ),
                            backgroundColor: const Color(0xFF1A73E8),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppConstants.phoneDisplay,
                        style: AppTypography.bodyMedium(
                          color: AppColors.textSecondary(isDark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 40),
            Divider(color: AppColors.borderSubtle(isDark)),
            const SizedBox(height: 24),

            // Linha Final de Copyright & Assinatura NanoDevs
            if (isDesktop)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Copyright
                  Expanded(
                    flex: 4,
                    child: Text(
                      l10n.footerRights,
                      style: AppTypography.bodyMedium(
                        color: AppColors.textMuted(isDark),
                      ),
                    ),
                  ),

                  // Assinatura NanoDevs
                  const _DeveloperSignature(),

                  // Voltar ao Topo
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => controller.navigateToSection(
                          HomeNavSection.hero,
                          controller.heroKey,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Voltar ao topo',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_upward_rounded,
                              size: 15,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text(
                    l10n.footerRights,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium(
                      color: AppColors.textMuted(isDark),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _DeveloperSignature(),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => controller.navigateToSection(
                      HomeNavSection.hero,
                      controller.heroKey,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Voltar ao topo',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_upward_rounded,
                          size: 15,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Assinatura sutil e moderna da NanoDevs com micro-interação de hover.
class _DeveloperSignature extends StatefulWidget {
  const _DeveloperSignature();

  @override
  State<_DeveloperSignature> createState() => _DeveloperSignatureState();
}

class _DeveloperSignatureState extends State<_DeveloperSignature> {
  bool _isHovered = false;

  void _openDeveloperLink() {
    launchUrl(
      Uri.parse(AppConstants.developerUrl),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _openDeveloperLink,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _isHovered
                ? (isDark ? const Color(0x1F38BDF8) : const Color(0x140284C7))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: _isHovered
                  ? (isDark ? const Color(0x6638BDF8) : const Color(0x440284C7))
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Desenvolvido por ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textMuted(isDark),
                ),
              ),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: _isHovered
                      ? const Color(0xFF38BDF8)
                      : (isDark
                          ? const Color(0xFFE2E8F0)
                          : const Color(0xFF1E293B)),
                  decoration: _isHovered
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: const Color(0xFF38BDF8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('NanoDevs'),
                    SizedBox(width: 4),
                    Text('⚡', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botão social circular com cores de marca e micro-interação.
class _SocialCircleButton extends StatefulWidget {
  const _SocialCircleButton({
    required this.onPressed,
    required this.tooltip,
    required this.icon,
    required this.backgroundColor,
  });

  final VoidCallback onPressed;
  final String tooltip;
  final Widget icon;
  final Color backgroundColor;

  @override
  State<_SocialCircleButton> createState() => _SocialCircleButtonState();
}

class _SocialCircleButtonState extends State<_SocialCircleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedScale(
            scale: _isHovered ? 1.08 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor.withValues(
                      alpha: _isHovered ? 0.45 : 0.25,
                    ),
                    blurRadius: _isHovered ? 10 : 5,
                    offset: Offset(0, _isHovered ? 4 : 2),
                  ),
                ],
              ),
              child: Center(child: widget.icon),
            ),
          ),
        ),
      ),
    );
  }
}
