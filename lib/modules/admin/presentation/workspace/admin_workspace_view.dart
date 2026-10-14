import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import '../../../../core/theme/app_colors.dart';
import 'admin_workspace_controller.dart';
import 'admin_workspace_injections.dart';
import 'admin_workspace_state.dart';
import 'widgets/admin_desktop_split_screen.dart';
import 'widgets/admin_mobile_adaptive_layout.dart';

/// Full administrative workspace rendering the schema-driven form generator
/// and real-time live site preview.
class AdminWorkspaceView extends StatefulWidget {
  const AdminWorkspaceView({super.key});

  @override
  State<AdminWorkspaceView> createState() => _AdminWorkspaceViewState();
}

class _AdminWorkspaceViewState
    extends NanoStatePage<AdminWorkspaceView, AdminWorkspaceController> {
  @override
  NanoInjections get injections => const AdminWorkspaceInjections();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;

    return NanoScaffold<AdminWorkspaceState, NanoMessageKey>(
      controller: controller,
      backgroundColor: AppColors.bgPrimary(context),
      loadingWidget: const SizedBox.shrink(),
      header: (context, _) {
        final isMobile = NanoDeviceType.isMobile(context);
        return AppBar(
          backgroundColor: AppColors.bgCard(context),
          elevation: 0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.pets_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  l10n.adminEditorTitle,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            if (!isMobile) ...[
              // Revert/Discard Draft
              TextButton.icon(
                onPressed: () => _confirmDiscard(context, controller),
                icon: const Icon(Icons.restore_rounded, size: 16),
                label: const Text('Reverter'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Save Draft Action with NanoCommandBuilder
              NanoCommandBuilder<void>(
                command: controller.saveDraftCommand,
                builder: (context, cmdState) {
                  final isSaving = cmdState is LoadingState;
                  return OutlinedButton.icon(
                    onPressed:
                        isSaving ? null : controller.saveDraftCommand.run,
                    icon: isSaving
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined, size: 16),
                    label: Text(l10n.adminSaveDraft),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary(context),
                      side: BorderSide(color: AppColors.borderSubtle(context)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),

              // Publish Live Action with NanoCommandBuilder
              NanoCommandBuilder<void>(
                command: controller.publishCommand,
                builder: (context, cmdState) {
                  final isPublishing = cmdState is LoadingState;
                  return ElevatedButton.icon(
                    onPressed:
                        isPublishing ? null : controller.publishCommand.run,
                    icon: isPublishing
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.cloud_upload_rounded, size: 16),
                    label: Text(l10n.adminPublishLive),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  );
                },
              ),
            ] else ...[
              IconButton(
                tooltip: 'Reverter para Publicado',
                icon: const Icon(
                  Icons.restore_rounded,
                  size: 20,
                  color: Colors.redAccent,
                ),
                onPressed: () => _confirmDiscard(context, controller),
              ),
              NanoCommandBuilder<void>(
                command: controller.saveDraftCommand,
                builder: (context, cmdState) {
                  final isSaving = cmdState is LoadingState;
                  return IconButton(
                    tooltip: l10n.adminSaveDraft,
                    icon: isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined, size: 20),
                    onPressed:
                        isSaving ? null : controller.saveDraftCommand.run,
                  );
                },
              ),
              NanoCommandBuilder<void>(
                command: controller.publishCommand,
                builder: (context, cmdState) {
                  final isPublishing = cmdState is LoadingState;
                  return IconButton(
                    tooltip: l10n.adminPublishLive,
                    icon: isPublishing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            Icons.cloud_upload_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                    onPressed:
                        isPublishing ? null : controller.publishCommand.run,
                  );
                },
              ),
            ],
            const SizedBox(width: 8),

            // Operator Sign Out
            IconButton(
              tooltip: l10n.adminSignOut,
              icon: const Icon(Icons.logout_rounded, size: 20),
              onPressed: controller.signOut,
            ),
            const SizedBox(width: 8),
          ],
        );
      },
      builder: (context, nanoState) {
        final state = nanoState.data ?? controller.viewState;

        return NanoResponsiveLayout(
          desktop: (context) => AdminDesktopSplitScreen(
            state: state,
            controller: controller,
            isDark: isDark,
          ),
          tablet: (context) => AdminMobileAdaptiveLayout(
            state: state,
            controller: controller,
            isDark: isDark,
          ),
          mobile: (context) => AdminMobileAdaptiveLayout(
            state: state,
            controller: controller,
            isDark: isDark,
          ),
        );
      },
    );
  }

  void _confirmDiscard(
    BuildContext context,
    AdminWorkspaceController controller,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Descartar alterações?'),
        content: const Text(
          'Todas as alterações não publicadas serão descartadas e o editor '
          'voltará ao conteúdo atualmente publicado no site.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              controller.discardDraft();
            },
            child: const Text('Sim, reverter'),
          ),
        ],
      ),
    );
  }
}
