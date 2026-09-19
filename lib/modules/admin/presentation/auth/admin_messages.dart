import 'package:flutter/widgets.dart';
import 'package:nano_core/nano_core.dart';

/// Semantic message keys for administrative authentication.
enum AdminMessages implements NanoMessageKey {
  emptyFields('Por favor, preencha e-mail e senha.'),
  invalidCredentials('E-mail ou senha incorretos.');

  const AdminMessages(this._text);
  final String _text;

  @override
  String Function(BuildContext) get message => (_) => _text;
}

/// Dynamic message wrapper implementing [NanoMessageKey] for
/// runtime exceptions.
class AdminDynamicMessage implements NanoMessageKey {
  const AdminDynamicMessage(this.text);
  final String text;

  @override
  String Function(BuildContext) get message => (_) => text;
}
