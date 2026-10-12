import 'package:flutter/material.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import '../admin_workspace_controller.dart';
import '../admin_workspace_state.dart';
import 'admin_live_preview.dart';
import 'admin_preview_toolbar.dart';
import 'admin_workspace_form_content.dart';

/// Desktop split-screen layout:
/// Form Editor on left, Live Real-Time Preview on right.
class AdminDesktopSplitScreen extends StatelessWidget {
  const AdminDesktopSplitScreen({
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
    return Row(
      children: [
        // Left Column: Form Editor
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: AppColors.borderSubtle(context),
                ),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: AdminWorkspaceFormContent(
                state: state,
                controller: controller,
                isDark: isDark,
              ),
            ),
          ),
        ),

        // Right Column: Live Real-Time Preview
        Expanded(
          child: Column(
            children: [
              AdminPreviewToolbar(
                selectedDevice: state.previewDevice,
                onDeviceChanged: controller.setPreviewDevice,
              ),
              Expanded(
                child: AdminLivePreview(
                  bundle: state.bundle,
                  previewDevice: state.previewDevice,
                  selectedSectionNotifier: controller.selectedSectionNotifier,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
