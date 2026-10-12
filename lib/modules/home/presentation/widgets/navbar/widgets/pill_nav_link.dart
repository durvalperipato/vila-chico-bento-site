import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';

/// Link pill interativo com micro-animação de hover para a barra
/// de navegação Desktop.
class PillNavLink extends StatefulWidget {
  const PillNavLink({
    required this.label,
    required this.onTap,
    this.isActive = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  State<PillNavLink> createState() => _PillNavLinkState();
}

class _PillNavLinkState extends State<PillNavLink> {
  bool _isHovered = false;

  Color _resolveBgColor(bool isDark) {
    if (widget.isActive) {
      return AppColors.primary.withValues(alpha: 0.18);
    }
    if (_isHovered) {
      return isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05);
    }
    return Colors.transparent;
  }

  Color _resolveTextColor(BuildContext context, bool isDark) {
    if (widget.isActive) {
      return isDark ? const Color(0xFFFBBF24) : AppColors.primary;
    }
    if (_isHovered) {
      return AppColors.textPrimary(context);
    }
    return AppColors.textSecondary(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.isDark;
    final isSelected = widget.isActive;

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
            color: _resolveBgColor(isDark),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : Colors.transparent,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: _resolveTextColor(context, isDark),
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}
