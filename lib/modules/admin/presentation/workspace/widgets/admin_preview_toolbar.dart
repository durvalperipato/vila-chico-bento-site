import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../admin_workspace_state.dart';

/// Top bar in the live preview pane allowing the operator to toggle
/// between simulated device viewports (Desktop, Tablet, Mobile).
class AdminPreviewToolbar extends StatelessWidget {
  const AdminPreviewToolbar({
    required this.selectedDevice,
    required this.onDeviceChanged,
    super.key,
  });

  final PreviewDeviceType selectedDevice;
  final ValueChanged<PreviewDeviceType> onDeviceChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard(isDark),
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderSubtle(isDark),
          ),
        ),
      ),
      child: Row(
        children: [
          // Live status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.blue.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.visibility_rounded,
                  size: 14,
                  color: Colors.blue,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n?.adminLivePreview ?? 'Pré-visualização ao vivo',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[300] ?? Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Viewport switch buttons
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.bgPrimary(isDark),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.borderSubtle(isDark),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DeviceButton(
                  icon: Icons.desktop_windows_rounded,
                  tooltip: l10n?.adminPreviewDesktop ?? 'Desktop',
                  isSelected: selectedDevice == PreviewDeviceType.desktop,
                  onTap: () => onDeviceChanged(PreviewDeviceType.desktop),
                ),
                const SizedBox(width: 2),
                _DeviceButton(
                  icon: Icons.tablet_mac_rounded,
                  tooltip: l10n?.adminPreviewTablet ?? 'Tablet',
                  isSelected: selectedDevice == PreviewDeviceType.tablet,
                  onTap: () => onDeviceChanged(PreviewDeviceType.tablet),
                ),
                const SizedBox(width: 2),
                _DeviceButton(
                  icon: Icons.phone_iphone_rounded,
                  tooltip: l10n?.adminPreviewMobile ?? 'Celular',
                  isSelected: selectedDevice == PreviewDeviceType.mobile,
                  onTap: () => onDeviceChanged(PreviewDeviceType.mobile),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceButton extends StatelessWidget {
  const _DeviceButton({
    required this.icon,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary(isDark),
          ),
        ),
      ),
    );
  }
}
