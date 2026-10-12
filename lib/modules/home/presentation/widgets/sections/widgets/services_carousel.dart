import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/modules/home/domain/entities/home_view_content.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';
import 'service_card.dart';

typedef ServiceItemData = ServiceItemContent;

class ServicesCarousel extends StatefulWidget {
  const ServicesCarousel({
    required this.services,
    required this.controller,
    super.key,
  });

  final List<ServiceItemContent> services;
  final HomeController controller;

  @override
  State<ServicesCarousel> createState() => _ServicesCarouselState();
}

class _ServicesCarouselState extends State<ServicesCarousel> {
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
    final isDark = context.theme.isDark;

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
                child: ServiceCard(
                  icon: service.icon,
                  title: service.title,
                  description: service.description,
                  badge: service.badge,
                  accentColor: service.accentColor,
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
                        : (isDark ? Colors.white24 : Colors.black12),
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
