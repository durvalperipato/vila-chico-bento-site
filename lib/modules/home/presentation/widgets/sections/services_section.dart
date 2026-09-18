import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';
import 'package:vila_chico_bento_site/core/widgets/meandering_paw_trail.dart';
import 'package:vila_chico_bento_site/core/widgets/responsive_container.dart';
import 'package:vila_chico_bento_site/core/widgets/section_tag.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({required this.controller, super.key});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = controller.isDarkMode;
    final isDesktop = NanoDeviceType.isDesktop(context);
    final isMobile = NanoDeviceType.isMobile(context);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final minHeight =
        isDesktop ? (screenHeight - 86).clamp(600.0, 1400.0) : 0.0;

    return Container(
      key: controller.servicesKey,
      constraints: isDesktop ? BoxConstraints(minHeight: minHeight) : null,
      alignment: Alignment.center,
      color: isDark ? AppColors.darkBgPrimary : AppColors.lightBgPrimary,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Aurora Glow Superior Direito (Verde Esmeralda)
          Positioned(
            top: -20,
            right: -30,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGreen
                        .withValues(alpha: isDark ? 0.12 : 0.08),
                    blurRadius: 100,
                    spreadRadius: 25,
                  ),
                ],
              ),
            ),
          ),

          // Aurora Glow Inferior Esquerdo (Âmbar Acolhedor)
          Positioned(
            bottom: -20,
            left: -30,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary
                        .withValues(alpha: isDark ? 0.12 : 0.08),
                    blurRadius: 100,
                    spreadRadius: 25,
                  ),
                ],
              ),
            ),
          ),

          // Rastro Contínuo de Patinhas: continua de onde About acabou (0.10) e sai na base direita (0.90)
          Positioned.fill(
            child: MeanderingPawTrail(
              start: const Offset(0.10, 0.0),
              control1: const Offset(0.10, 0.25),
              control2: const Offset(0.90, 0.75),
              end: const Offset(0.90, 1.0),
              pawCount: isMobile ? 8 : 14,
              baseSize: 32.0,
              opacity: isDark ? 0.38 : 0.50,
              color: AppColors.pawTrail,
              startWithRightFoot: true,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 44 : 48,
            ),
            child: ResponsiveContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SectionTag(
                    text: l10n.servicesBadge,
                    icon: Icons.sports_baseball_rounded,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.servicesTitle,
                    textAlign: TextAlign.center,
                    style: isDesktop
                        ? AppTypography.displayMedium(
                            color: AppColors.textPrimary(isDark),
                          ).copyWith(fontSize: 32)
                        : AppTypography.displaySmall(
                            color: AppColors.textPrimary(isDark),
                          ),
                  ),
                  const SizedBox(height: 28),

                  // Grid 2x2 dos Serviços Compacto e Elegante
                  if (isDesktop)
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _ServiceCard(
                                icon: Icons.wb_sunny_rounded,
                                title: l10n.serviceDaycareTitle,
                                description: l10n.serviceDaycareDesc,
                                badge: 'Diário & Socialização',
                                accentColor: AppColors.primary,
                                isDark: isDark,
                                onCtaTap: () => controller.openWhatsApp(
                                  customMessage:
                                      'Olá! Gostaria de saber mais informações sobre o Day Care (Creche Canina) da Vila Chico Bento!',
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _ServiceCard(
                                icon: Icons.night_shelter_rounded,
                                title: l10n.serviceHotelTitle,
                                description: l10n.serviceHotelDesc,
                                badge: 'Pernoite & Viagens',
                                accentColor: AppColors.secondary,
                                isDark: isDark,
                                onCtaTap: () => controller.openWhatsApp(
                                  customMessage:
                                      'Olá! Gostaria de consultar vagas e valores para a Hospedagem / Hotelzinho na Vila Chico Bento!',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _ServiceCard(
                                icon: Icons.handshake_rounded,
                                title: l10n.serviceAdaptationTitle,
                                description: l10n.serviceAdaptationDesc,
                                badge: 'Cuidado & Segurança',
                                accentColor: AppColors.accentGreen,
                                isDark: isDark,
                                onCtaTap: () => controller.openWhatsApp(
                                  customMessage:
                                      'Olá! Gostaria de agendar o Período de Adaptação para o meu pet na Vila Chico Bento!',
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _ServiceCard(
                                icon: Icons.schedule_rounded,
                                title: l10n.serviceRoutineTitle,
                                description: l10n.serviceRoutineDesc,
                                badge: 'Saúde & Equilíbrio',
                                accentColor: const Color(0xFF8B5CF6),
                                isDark: isDark,
                                onCtaTap: () => controller.openWhatsApp(
                                  customMessage:
                                      'Olá! Gostaria de saber mais detalhes sobre a Rotina Estruturada e horários na Vila Chico Bento!',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    _ServicesCarousel(
                      services: [
                        _ServiceItem(
                          icon: Icons.wb_sunny_rounded,
                          title: l10n.serviceDaycareTitle,
                          description: l10n.serviceDaycareDesc,
                          badge: 'Diário & Socialização',
                          accentColor: AppColors.primary,
                          whatsappMessage:
                              'Olá! Gostaria de saber mais informações sobre o Day Care (Creche Canina) da Vila Chico Bento!',
                        ),
                        _ServiceItem(
                          icon: Icons.night_shelter_rounded,
                          title: l10n.serviceHotelTitle,
                          description: l10n.serviceHotelDesc,
                          badge: 'Pernoite & Viagens',
                          accentColor: AppColors.secondary,
                          whatsappMessage:
                              'Olá! Gostaria de consultar vagas e valores para a Hospedagem / Hotelzinho na Vila Chico Bento!',
                        ),
                        _ServiceItem(
                          icon: Icons.handshake_rounded,
                          title: l10n.serviceAdaptationTitle,
                          description: l10n.serviceAdaptationDesc,
                          badge: 'Cuidado & Segurança',
                          accentColor: AppColors.accentGreen,
                          whatsappMessage:
                              'Olá! Gostaria de agendar o Período de Adaptação para o meu pet na Vila Chico Bento!',
                        ),
                        _ServiceItem(
                          icon: Icons.schedule_rounded,
                          title: l10n.serviceRoutineTitle,
                          description: l10n.serviceRoutineDesc,
                          badge: 'Saúde & Equilíbrio',
                          accentColor: const Color(0xFF8B5CF6),
                          whatsappMessage:
                              'Olá! Gostaria de saber mais detalhes sobre a Rotina Estruturada e horários na Vila Chico Bento!',
                        ),
                      ],
                      controller: controller,
                      isDark: isDark,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.badge,
    required this.accentColor,
    required this.isDark,
    required this.onCtaTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final String badge;
  final Color accentColor;
  final bool isDark;
  final VoidCallback onCtaTap;

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.bgCard(widget.isDark),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.6)
                : AppColors.borderSubtle(widget.isDark),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? widget.accentColor.withValues(alpha: 0.16)
                  : AppColors.cardShadow(widget.isDark),
              blurRadius: _isHovered ? 20 : 12,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 24,
                    color: widget.accentColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    widget.badge,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: widget.accentColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              widget.title,
              style: AppTypography.titleMedium(
                color: AppColors.textPrimary(widget.isDark),
              ).copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: AppTypography.bodyMedium(
                color: AppColors.textSecondary(widget.isDark),
              ).copyWith(fontSize: 13.5, height: 1.45),
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: widget.onCtaTap,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Consultar detalhes',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: widget.accentColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 15,
                      color: widget.accentColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceItem {
  const _ServiceItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.badge,
    required this.accentColor,
    required this.whatsappMessage,
  });

  final IconData icon;
  final String title;
  final String description;
  final String badge;
  final Color accentColor;
  final String whatsappMessage;
}

class _ServicesCarousel extends StatefulWidget {
  const _ServicesCarousel({
    required this.services,
    required this.controller,
    required this.isDark,
  });

  final List<_ServiceItem> services;
  final HomeController controller;
  final bool isDark;

  @override
  State<_ServicesCarousel> createState() => _ServicesCarouselState();
}

class _ServicesCarouselState extends State<_ServicesCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 295,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.services.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final service = widget.services[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: _ServiceCard(
                  icon: service.icon,
                  title: service.title,
                  description: service.description,
                  badge: service.badge,
                  accentColor: service.accentColor,
                  isDark: widget.isDark,
                  onCtaTap: () => widget.controller.openWhatsApp(
                    customMessage: service.whatsappMessage,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Dots indicadores interativos
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.services.length,
            (index) {
              final isActive = _currentPage == index;
              return GestureDetector(
                onTap: () => _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : (widget.isDark ? Colors.white24 : Colors.black12),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
