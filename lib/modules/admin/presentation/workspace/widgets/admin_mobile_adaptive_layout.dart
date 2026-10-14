import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/l10n/generated/app_localizations.dart';
import '../admin_workspace_controller.dart';
import '../admin_workspace_state.dart';
import 'admin_live_preview.dart';
import 'admin_preview_toolbar.dart';
import 'admin_workspace_form_content.dart';

/// Mobile/compact layout: Segmented tab switch between Editor and Preview.
class AdminMobileAdaptiveLayout extends StatelessWidget {
  const AdminMobileAdaptiveLayout({
    required this.state,
    required this.controller,
    required this.isDark,
    super.key,
  });

  final AdminWorkspaceState state;
  final AdminWorkspaceController controller;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        // Mobile Mode Switcher Bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.bgCard(context),
            border: Border(
              bottom: BorderSide(
                color: AppColors.borderSubtle(context),
              ),
            ),
          ),
          child: Center(
            child: SegmentedButton<AdminViewMode>(
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.15),
                selectedForegroundColor: AppColors.primary,
              ),
              segments: [
                ButtonSegment<AdminViewMode>(
                  value: AdminViewMode.editor,
                  icon: const Icon(Icons.edit_note_rounded, size: 18),
                  label: Text(
                    l10n?.adminTabEditor ?? 'Editor',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),
                ButtonSegment<AdminViewMode>(
                  value: AdminViewMode.preview,
                  icon: const Icon(Icons.visibility_rounded, size: 18),
                  label: Text(
                    l10n?.adminTabPreview ?? 'Pré-visualizar',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              selected: {state.viewMode},
              onSelectionChanged: (selected) {
                if (selected.isNotEmpty) {
                  controller.setViewMode(selected.first);
                }
              },
            ),
          ),
        ),

        // Body Content based on active mode
        Expanded(
          child: state.viewMode == AdminViewMode.editor
              ? SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 820),
                      child: AdminWorkspaceFormContent(
                        state: state,
                        controller: controller,
                        isDark: isDark,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    AdminPreviewToolbar(
                      selectedDevice: state.previewDevice,
                      onDeviceChanged: controller.setPreviewDevice,
                    ),
                    Expanded(
                      child: AdminLivePreview(
                        bundle: state.bundle,
                        previewDevice: state.previewDevice,
                        selectedSectionNotifier:
                            controller.selectedSectionNotifier,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
