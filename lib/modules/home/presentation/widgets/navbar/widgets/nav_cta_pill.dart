import 'package:flutter/material.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/widgets/brand_icons.dart';

/// Botão pill de destaque (WhatsApp) com gradiente e elevação dinâmica
/// na Navbar.
class NavCtaPill extends StatefulWidget {
  const NavCtaPill({
    required this.label,
    required this.onTap,
    super.key,
  });

  final String label;
  final VoidCallback onTap;

  @override
  State<NavCtaPill> createState() => _NavCtaPillState();
}

class _NavCtaPillState extends State<NavCtaPill> {
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
