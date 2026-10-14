import 'package:flutter/widgets.dart';
import 'package:nano_core/nano_core.dart';
import '../../../../core/extensions/build_context_extension.dart';

/// Semantic message keys for administrative authentication.
/// Implements [NanoMessageKey] for automatic internationalization.
enum AdminMessages implements NanoMessageKey {
  emptyFields,
  invalidCredentials,
  unknownError;

  @override
  String Function(BuildContext) get message => (context) => switch (this) {
        AdminMessages.emptyFields => context.l10n.adminAuthEmptyFields,
        AdminMessages.invalidCredentials =>
          context.l10n.adminAuthInvalidCredentials,
        AdminMessages.unknownError => context.l10n.adminAuthUnknownError,
      };
}

/// Dynamic message wrapper implementing [NanoMessageKey] for
/// runtime exceptions that carry custom text.
class AdminDynamicMessage implements NanoMessageKey {
  const AdminDynamicMessage(this.text);
  final String text;

  @override
  String Function(BuildContext) get message => (_) => text;
}
