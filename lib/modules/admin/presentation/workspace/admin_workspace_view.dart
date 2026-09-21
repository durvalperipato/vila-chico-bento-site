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

/// Full administrative workspace rendering the schema-driven form generator.
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

    return NanoScaffold<AdminWorkspaceState, NanoMessageKey>(
      controller: controller,
      backgroundColor: AppColors.bgPrimary(isDark),
      header: (context, _) {
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
                  AppLocalizations.of(context)?.adminEditorTitle ??
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
            // Save Draft Action
            OutlinedButton.icon(
              onPressed: controller.saveDraft,
              icon: const Icon(Icons.save_outlined, size: 16),
              label: Text(
                AppLocalizations.of(context)?.adminSaveDraft ??
                    'Salvar Rascunho',
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
                AppLocalizations.of(context)?.adminPublishLive ??
                    'Publicar no Site',
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
            const SizedBox(width: 16),

            // Operator Sign Out
            IconButton(
              tooltip: AppLocalizations.of(context)?.adminSignOut ??
                  'Sair da sessão',
              icon: const Icon(Icons.logout_rounded, size: 20),
              onPressed: controller.signOut,
            ),
            const SizedBox(width: 12),
          ],
        );
      },
      builder: (context, nanoState) {
        final state = nanoState.data ?? controller.viewState;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Column(
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
                            AppLocalizations.of(context)
                                    ?.adminBannerDescription ??
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
                                    ? (AppLocalizations.of(context)
                                            ?.adminStatusDraft ??
                                        'Rascunho não publicado')
                                    : (AppLocalizations.of(context)
                                            ?.adminStatusPublished ??
                                        'Publicado'),
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
              ),
            ),
          ),
        );
      },
    );
  }
}
