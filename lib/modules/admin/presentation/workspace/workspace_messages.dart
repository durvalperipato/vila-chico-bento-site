import 'package:flutter/widgets.dart';
import 'package:nano_core/nano_core.dart';
import '../../../../core/extensions/build_context_extension.dart';

/// Semantic message keys for workspace actions.
/// Implements [NanoMessageKey] for automatic internationalization.
enum WorkspaceMessages implements NanoMessageKey {
  draftSaved,
  published,
  error;

  @override
  String Function(BuildContext) get message => (context) => switch (this) {
        WorkspaceMessages.draftSaved => context.l10n.adminWorkspaceDraftSaved,
        WorkspaceMessages.published => context.l10n.adminWorkspacePublished,
        WorkspaceMessages.error => context.l10n.adminWorkspaceError,
      };
}
