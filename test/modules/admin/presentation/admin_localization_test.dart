import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/l10n/generated/app_localizations.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/entities/content_bundle.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/auth_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/site_content_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/storage_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/domain.dart';
import 'package:vila_chico_bento_site/modules/admin/infrastructure/services/site_content_service.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/auth/admin_messages.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/workspace/admin_workspace_view.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/workspace/workspace_messages.dart';
import '../admin_test_mocks.dart';

void main() {
  group('Admin Localization Tests (EN & PT-BR)', () {
    testWidgets('WorkspaceMessages resolves translated strings in EN and PT',
        (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pt'),
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Portuguese translations
      expect(
        WorkspaceMessages.draftSaved.message(capturedContext),
        'Rascunho salvo com sucesso!',
      );
      expect(
        WorkspaceMessages.published.message(capturedContext),
        'Conteúdo publicado no site oficial com sucesso!',
      );
      expect(
        WorkspaceMessages.error.message(capturedContext),
        'Falha ao processar alterações.',
      );
      expect(
        AdminMessages.emptyFields.message(capturedContext),
        'Por favor, preencha e-mail e senha.',
      );
      expect(
        AdminMessages.invalidCredentials.message(capturedContext),
        'E-mail ou senha incorretos.',
      );

      // Switch to English locale
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify English translations
      expect(
        WorkspaceMessages.draftSaved.message(capturedContext),
        'Draft saved successfully!',
      );
      expect(
        WorkspaceMessages.published.message(capturedContext),
        'Content published to live website successfully!',
      );
      expect(
        WorkspaceMessages.error.message(capturedContext),
        'Failed to process changes.',
      );
      expect(
        AdminMessages.emptyFields.message(capturedContext),
        'Please fill in both email and password.',
      );
      expect(
        AdminMessages.invalidCredentials.message(capturedContext),
        'Incorrect email or password.',
      );
    });

    testWidgets('AdminWorkspaceView renders in English when locale is en',
        (tester) async {
      await GetIt.I.reset();
      final mockRepo = MockSiteContentRepository();
      final mockAuth = MockAuthRepository()
        ..userId = 'uid-operator'
        ..userEmail = 'operator@vilachicobento.com.br';

      GetIt.I.registerSingleton<AuthRepository>(mockAuth);
      GetIt.I.registerSingleton<SiteContentRepository>(mockRepo);
      GetIt.I.registerSingleton<StorageRepository>(MockStorageRepository());
      GetIt.I.registerSingleton<SiteContentService>(
        SiteContentService(
          repository: mockRepo,
          siteId: VilaChicoBentoSchema.siteId,
          initialBundle: ContentBundle.fromMap({
            'hero.title': 'Vila Chico Bento',
          }),
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: AdminWorkspaceView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Vila Chico Bento | Content Editor'), findsOneWidget);
      expect(find.text('Save Draft'), findsOneWidget);
      expect(find.text('Publish Live'), findsOneWidget);
      expect(find.text('Published'), findsOneWidget);

      await GetIt.I.reset();
    });
  });
}
