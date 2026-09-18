import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vila_chico_bento_site/core/constants/app_constants.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/widgets/brand_icons.dart';

class WhatsappFloating extends StatefulWidget {
  const WhatsappFloating({super.key});

  @override
  State<WhatsappFloating> createState() => _WhatsappFloatingState();
}

class _WhatsappFloatingState extends State<WhatsappFloating> {
  bool _isHovered = false;

  void _openWhatsApp() {
    const defaultMsg =
        'Olá! Conheci o site da Vila Chico Bento e gostaria de agendar uma visita e o período de adaptação para o meu cãozinho!';
    final url = AppConstants.buildWhatsAppUrl(defaultMsg);
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _openWhatsApp,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          height: 56,
          padding: EdgeInsets.symmetric(
            horizontal: _isHovered ? 20 : 16,
          ),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.whatsappHover : AppColors.whatsapp,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: AppColors.whatsapp
                    .withValues(alpha: _isHovered ? 0.5 : 0.35),
                blurRadius: _isHovered ? 20 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BrandIcons.whatsapp(size: 24, color: Colors.white),
                  if (_isHovered) ...[
                    const SizedBox(width: 8),
                    const Text(
                      'Fale Conosco 🐾',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
              // Patinha decorativa animada no topo
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFF0F172A), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.6),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.pets_rounded,
                    color: Colors.white,
                    size: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
