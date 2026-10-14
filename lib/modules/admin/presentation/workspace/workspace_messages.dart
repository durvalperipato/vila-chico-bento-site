import 'package:flutter/widgets.dart';
import 'package:nano_core/nano_core.dart';
import '../../../../core/extensions/build_context_extension.dart';

/// Semantic message keys for workspace actions.
/// Implements [NanoMessageKey] for automatic internationalization.
enum WorkspaceMessages implements NanoMessageKey {
  draftSaved,
  published,
  draftDiscarded,
  validationError,
  error;

  @override
  String Function(BuildContext) get message => (context) => switch (this) {
        WorkspaceMessages.draftSaved => context.l10n.adminWorkspaceDraftSaved,
        WorkspaceMessages.published => context.l10n.adminWorkspacePublished,
        WorkspaceMessages.draftDiscarded =>
          'Alterações descartadas. Conteúdo restaurado para a versão no ar.',
        WorkspaceMessages.validationError =>
          'Não é possível publicar: preencha todos os campos obrigatórios.',
        WorkspaceMessages.error => context.l10n.adminWorkspaceError,
      };
}
