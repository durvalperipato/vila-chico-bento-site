import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/admin_field.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/admin_section_group.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/admin_section_icon.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/entities/content_bundle.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/auth_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/site_content_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/storage_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/site_schema.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/vila_chico_bento_schema.dart';
import 'package:vila_chico_bento_site/modules/admin/infrastructure/services/site_content_service.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/widgets/form/admin_section_accordion.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/widgets/form/dynamic_form_generator.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/workspace/admin_workspace_controller.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/workspace/admin_workspace_state.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/workspace/admin_workspace_view.dart';
import '../admin_test_mocks.dart';

void main() {
  group('DynamicFormGenerator Unit & Widget Tests', () {
    final testSchema = SiteSchema(
      siteId: 'test-site',
      sections: [
        AdminSectionGroup(
          id: 'hero',
          title: 'Hero Section',
          icon: AdminSectionIcon.stars,
          fields: [
            AdminField.text(
              key: 'hero.title',
              label: 'Hero Title',
              maxLength: 50,
              required: true,
            ),
            AdminField.text(
              key: 'hero.subtitle',
              label: 'Hero Subtitle',
              maxLength: 100,
            ),
          ],
        ),
      ],
    );

    testWidgets('renders sections and fields according to schema',
        (tester) async {
      final bundle = ContentBundle.fromMap({
        'hero.title': 'Original Title',
        'hero.subtitle': 'Original Subtitle',
      });

      String? updatedKey;
      dynamic updatedVal;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormGenerator(
                schema: testSchema,
                bundle: bundle,
                onFieldChanged: (key, val) {
                  updatedKey = key;
                  updatedVal = val;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hero Section'), findsOneWidget);
      expect(find.text('Hero Title'), findsOneWidget);
      expect(find.text('Hero Subtitle'), findsOneWidget);
      expect(find.text('Original Title'), findsOneWidget);
      expect(find.text('14 / 50'), findsOneWidget); // character counter

      // Enter text into Hero Title
      await tester.enterText(
        find.widgetWithText(TextField, 'Original Title'),
        'Updated Brand Title',
      );
      await tester.pump();

      expect(updatedKey, 'hero.title');
      expect(updatedVal, 'Updated Brand Title');
    });

    testWidgets('AdminSectionAccordion collapses and expands on tap',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdminSectionAccordion(
              section: AdminSectionGroup(
                id: 'test',
                title: 'Test Section',
                icon: AdminSectionIcon.pets,
                fields: [],
              ),
              children: [Text('Child Content')],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Child Content'), findsOneWidget);

      // Tap accordion header to collapse
      await tester.tap(find.text('Test Section'));
      await tester.pumpAndSettle();

      // Tap again to re-expand
      await tester.tap(find.text('Test Section'));
      await tester.pumpAndSettle();
      expect(find.text('Child Content'), findsOneWidget);
    });
  });

  group('AdminWorkspaceController Tests', () {
    late MockSiteContentRepository mockRepo;
    late SiteContentService contentService;
    late MockAuthRepository mockAuth;
    late AdminWorkspaceController controller;

    setUp(() async {
      await GetIt.I.reset();
      mockRepo = MockSiteContentRepository();
      mockAuth = MockAuthRepository();
      final mockStorage = MockStorageRepository();
      contentService = SiteContentService(
        repository: mockRepo,
        siteId: 'test-site',
        initialBundle: ContentBundle.fromMap({'hero.title': 'Hello'}),
      );
      controller = AdminWorkspaceController(
        siteContentService: contentService,
        authRepository: mockAuth,
        storageRepository: mockStorage,
      );
    });

    tearDown(() async {
      controller.dispose();
      contentService.dispose();
      await GetIt.I.reset();
    });

    test('updateField updates bundle and triggers updatePreview immediately',
        () {
      expect(
        controller.viewState.bundle.getString('hero.title', fallback: ''),
        'Hello',
      );
      expect(controller.viewState.hasUnsavedChanges, isFalse);

      controller.updateField('hero.title', 'World');

      expect(
        controller.viewState.bundle.getString('hero.title', fallback: ''),
        'World',
      );
      expect(controller.viewState.hasUnsavedChanges, isTrue);
      expect(
        contentService.bundle.getString('hero.title', fallback: ''),
        'World',
      );
    });

    test('saveDraft persists working draft and emits success', () async {
      controller.updateField('hero.title', 'Draft Title');

      await controller.saveDraft();

      expect(mockRepo.storedDraft?['hero.title'], 'Draft Title');
      expect(controller.state, isA<SuccessState<AdminWorkspaceState>>());
    });

    test('publish commits content to repository and marks unsaved as false',
        () async {
      controller.updateField('hero.title', 'Published Title');

      await controller.publish();

      expect(mockRepo.storedContent['hero.title'], 'Published Title');
      expect(controller.viewState.hasUnsavedChanges, isFalse);
      expect(controller.state, isA<SuccessState<AdminWorkspaceState>>());
    });
  });

  group('AdminWorkspaceView Widget Tests', () {
    late MockSiteContentRepository mockRepo;
    late MockAuthRepository mockAuth;

    setUp(() async {
      await GetIt.I.reset();
      mockRepo = MockSiteContentRepository();
      mockAuth = MockAuthRepository()
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
            'hero.title': 'Vila Chico Bento Pet Hotel',
          }),
        ),
      );
    });

    tearDown(() async {
      await GetIt.I.reset();
    });

    testWidgets('renders workspace with full VilaChicoBentoSchema sections',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminWorkspaceView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Vila Chico Bento | Editor de Conteúdo'),
        findsOneWidget,
      );
      expect(find.text('Salvar Rascunho'), findsOneWidget);
      expect(find.text('Publicar no Site'), findsOneWidget);
      expect(find.text('Seção Inicial (Hero)'), findsOneWidget);
      expect(find.text('Sobre Nós & Cuidados'), findsOneWidget);
      expect(find.text('Serviços Oferecidos'), findsOneWidget);
    });
  });
}
