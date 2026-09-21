import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nano_core/nano_core.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/vila_chico_bento_schema.dart';
import '../widgets/form/dynamic_form_generator.dart';
import 'admin_workspace_controller.dart';
import 'admin_workspace_injections.dart';
import 'admin_workspace_state.dart';
import 'widgets/admin_live_preview.dart';
import 'widgets/admin_preview_toolbar.dart';

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

  static const double _desktopBreakpoint = 1024.0;

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

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= _desktopBreakpoint;

            if (isDesktop) {
              return _buildDesktopSplitScreen(context, state, isDark);
            }

            return _buildMobileAdaptiveLayout(context, state, isDark);
          },
        );
      },
    );
  }

  /// Desktop split-screen layout: Editor on left, Live Preview on right.
  Widget _buildDesktopSplitScreen(
    BuildContext context,
    AdminWorkspaceState state,
    bool isDark,
  ) {
    return Row(
      children: [
        // Left Column: Form Editor
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: AppColors.borderSubtle(isDark),
                ),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: _buildFormContent(context, state, isDark),
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Mobile/compact layout: Segmented tab switch between Editor and Preview.
  Widget _buildMobileAdaptiveLayout(
    BuildContext context,
    AdminWorkspaceState state,
    bool isDark,
  ) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        // Mobile Mode Switcher Bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.bgCard(isDark),
            border: Border(
              bottom: BorderSide(
                color: AppColors.borderSubtle(isDark),
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
                      child: _buildFormContent(context, state, isDark),
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
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  /// Reusable form content containing the status banner and dynamic form
  /// generator.
  Widget _buildFormContent(
    BuildContext context,
    AdminWorkspaceState state,
    bool isDark,
  ) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Information banner
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n?.adminBannerDescription ??
                      'Formulário gerado automaticamente a partir '
                          'do VilaChicoBentoSchema. '
                          'Qualquer caractere alterado atualiza o '
                          'rascunho instantaneamente.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textPrimary(isDark),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: state.hasUnsavedChanges
                      ? Colors.orange.withValues(alpha: 0.15)
                      : Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: state.hasUnsavedChanges
                        ? Colors.orange.withValues(alpha: 0.4)
                        : Colors.green.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      state.hasUnsavedChanges
                          ? Icons.circle_rounded
                          : Icons.check_circle_rounded,
                      size: 10,
                      color: state.hasUnsavedChanges
                          ? Colors.orange
                          : Colors.green,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      state.hasUnsavedChanges
                          ? (l10n?.adminStatusDraft ?? 'Rascunho não publicado')
                          : (l10n?.adminStatusPublished ?? 'Publicado'),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: state.hasUnsavedChanges
                            ? (Colors.orange[300] ?? Colors.orange)
                            : (Colors.green[300] ?? Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Dynamic Schema-Driven Form Generator
        DynamicFormGenerator(
          schema: VilaChicoBentoSchema.schema,
          bundle: state.bundle,
          onFieldChanged: controller.updateField,
          onUploadImage: controller.uploadGalleryImage,
        ),
      ],
    );
  }
}
