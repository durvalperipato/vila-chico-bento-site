import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nano_core/nano_core.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);

    return NanoScaffold<AdminWorkspaceState, NanoMessageKey>(
      controller: controller,
      backgroundColor: AppColors.bgPrimary(isDark),
      header: (context, _) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        return AppBar(
          backgroundColor: AppColors.bgCard(isDark),
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
                  l10n?.adminEditorTitle ??
                      'Vila Chico Bento | Editor de Conteúdo',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(isDark),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            if (screenWidth >= 700) ...[
              // Save Draft Action
              OutlinedButton.icon(
                onPressed: controller.saveDraft,
                icon: const Icon(Icons.save_outlined, size: 16),
                label: Text(
                  l10n?.adminSaveDraft ?? 'Salvar Rascunho',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary(isDark),
                  side: BorderSide(color: AppColors.borderSubtle(isDark)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Publish Live Action
              ElevatedButton.icon(
                onPressed: controller.publish,
                icon: const Icon(Icons.cloud_upload_rounded, size: 16),
                label: Text(
                  l10n?.adminPublishLive ?? 'Publicar no Site',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ] else ...[
              IconButton(
                tooltip: l10n?.adminSaveDraft ?? 'Salvar Rascunho',
                icon: const Icon(Icons.save_outlined, size: 20),
                onPressed: controller.saveDraft,
              ),
              IconButton(
                tooltip: l10n?.adminPublishLive ?? 'Publicar no Site',
                icon: const Icon(
                  Icons.cloud_upload_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                onPressed: controller.publish,
              ),
            ],
            const SizedBox(width: 8),

            // Operator Sign Out
            IconButton(
              tooltip: l10n?.adminSignOut ?? 'Sair da sessão',
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
}
