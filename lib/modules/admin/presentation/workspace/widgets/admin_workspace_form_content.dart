import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/l10n/generated/app_localizations.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/vila_chico_bento_schema.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/widgets/form/dynamic_form_generator.dart';
import '../admin_workspace_controller.dart';
import '../admin_workspace_state.dart';

/// Reusable form content widget containing the status banner
/// and dynamic form generator.
class AdminWorkspaceFormContent extends StatelessWidget {
  const AdminWorkspaceFormContent({
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
