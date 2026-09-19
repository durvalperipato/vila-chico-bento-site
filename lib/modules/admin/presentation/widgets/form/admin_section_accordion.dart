import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/admin_section_group.dart';
import '../../../domain/admin_section_icon.dart';

/// Expandable accordion card wrapping fields of an [AdminSectionGroup].
class AdminSectionAccordion extends StatefulWidget {
  const AdminSectionAccordion({
    required this.section,
    required this.children,
    this.initiallyExpanded = true,
    super.key,
  });

  final AdminSectionGroup section;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  State<AdminSectionAccordion> createState() => _AdminSectionAccordionState();
}

class _AdminSectionAccordionState extends State<AdminSectionAccordion> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  IconData _resolveIcon(AdminSectionIcon icon) => switch (icon) {
        AdminSectionIcon.stars => Icons.star_rounded,
        AdminSectionIcon.pets => Icons.pets_rounded,
        AdminSectionIcon.category => Icons.grid_view_rounded,
        AdminSectionIcon.photoLibrary => Icons.photo_library_rounded,
        AdminSectionIcon.location => Icons.location_on_rounded,
        AdminSectionIcon.contactPhone => Icons.contact_phone_rounded,
        AdminSectionIcon.general => Icons.edit_note_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.bgCard(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isExpanded
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.borderSubtle(isDark),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header / Accordion Trigger
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _resolveIcon(widget.section.icon),
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.section.title,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary(isDark),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.section.fields.length} '
                          'campos configuráveis',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textMuted(isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary(isDark),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Collapsible Form Fields
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.children,
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
        ],
      ),
    );
  }
}
