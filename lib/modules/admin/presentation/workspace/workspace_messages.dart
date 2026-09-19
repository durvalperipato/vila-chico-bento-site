import 'package:flutter/widgets.dart';
import 'package:nano_core/nano_core.dart';

/// Semantic message keys for workspace actions.
enum WorkspaceMessages implements NanoMessageKey {
  draftSaved('Rascunho salvo com sucesso!'),
  published('Conteúdo publicado no site oficial com sucesso!'),
  error('Falha ao processar alterações.');

  const WorkspaceMessages(this._text);
  final String _text;

  @override
  String Function(BuildContext) get message => (_) => _text;
}
