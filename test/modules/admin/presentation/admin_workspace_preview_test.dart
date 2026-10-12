import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/l10n/generated/app_localizations.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/entities/content_bundle.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/auth_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/site_content_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/storage_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/schema/vila_chico_bento_schema.dart';
import 'package:vila_chico_bento_site/modules/admin/infrastructure/services/site_content_service.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/workspace/admin_workspace_controller.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/workspace/admin_workspace_state.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/workspace/admin_workspace_view.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/workspace/widgets/admin_live_preview.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/workspace/widgets/admin_preview_toolbar.dart';
import '../admin_test_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSiteContentRepository mockRepo;
  late MockAuthRepository mockAuth;
  late MockStorageRepository mockStorage;
  late SiteContentService contentService;

  Widget buildTestableApp({required Widget child}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('pt'),
      home: child,
    );
  }

  const testBundleMap = {
    'hero': {
      'badge': '🐾 O Segundo Lar do Seu Cãozinho',
      'title': 'Amor, liberdade e enriquecimento ambiental para o seu pet',
      'subtitle': 'Creche diária (Day Care), hotelzinho acolhedor',
      'cta_whatsapp_text': 'Agendar Adaptação no WhatsApp',
      'banner_image':
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b',
    },
    'about': {
      'badge': 'Nossa Proposta & Cuidado',
      'title': 'Mais que uma creche, uma extensão do seu lar',
      'description': 'Na Vila Chico Bento...',
    },
    'services': {
      'badge': 'O Que Fazemos de Melhor',
      'title': 'Serviços pensados para a rotina',
      'subtitle': 'Atividades diárias',
      'items': [
        {'title': 'Day Care', 'description': 'Recreação'},
      ],
    },
    'gallery': {
      'badge': 'Momentos Felizes',
      'title': 'A alegria que transborda',
      'images': ['https://images.unsplash.com/photo-1548199973-03cce0bbc87b'],
    },
    'location': {
      'badge': 'Onde Estamos',
      'title': 'Venha nos visitar em Pinhais',
      'address': 'R. Clóvis Beviláqua, 579',
      'hours': 'Segunda a Sexta: 07h às 19h',
    },
    'contact': {
      'whatsapp_number': '(41) 99252-3108',
      'instagram_handle': '@vilachicobento',
    },
  };

  setUp(() async {
    await GetIt.I.reset();
    mockRepo = MockSiteContentRepository();
    mockAuth = MockAuthRepository()
      ..userId = 'uid-operator'
      ..userEmail = 'operator@vilachicobento.com.br';
    mockStorage = MockStorageRepository();

    contentService = SiteContentService(
      repository: mockRepo,
      siteId: VilaChicoBentoSchema.siteId,
      initialBundle: ContentBundle.fromMap(testBundleMap),
    );

    GetIt.I
      ..registerSingleton<AuthRepository>(mockAuth)
      ..registerSingleton<SiteContentRepository>(mockRepo)
      ..registerSingleton<StorageRepository>(mockStorage)
      ..registerSingleton<SiteContentService>(contentService);
  });

  tearDown(() async {
    contentService.dispose();
    await GetIt.I.reset();
  });

  group('Admin Workspace Preview & Publishing Unit Tests', () {
    test('AdminWorkspaceController sets preview device and mobile view mode',
        () {
      final controller = AdminWorkspaceController(
        siteContentService: contentService,
        authRepository: mockAuth,
        storageRepository: mockStorage,
      );

      expect(controller.viewState.previewDevice, PreviewDeviceType.desktop);
      expect(controller.viewState.viewMode, AdminViewMode.editor);

      controller
        ..setPreviewDevice(PreviewDeviceType.mobile)
        ..setPreviewDevice(PreviewDeviceType.tablet)
        ..setViewMode(AdminViewMode.preview);

      expect(controller.viewState.previewDevice, PreviewDeviceType.tablet);
      expect(controller.viewState.viewMode, AdminViewMode.preview);

      controller.dispose();
    });

    test('AdminWorkspaceState copyWith immutability', () {
      const state = AdminWorkspaceState();
      final updated = state.copyWith(
        previewDevice: PreviewDeviceType.tablet,
        viewMode: AdminViewMode.preview,
        hasUnsavedChanges: true,
      );

      expect(updated.previewDevice, PreviewDeviceType.tablet);
      expect(updated.viewMode, AdminViewMode.preview);
      expect(updated.hasUnsavedChanges, isTrue);
      expect(state.previewDevice, PreviewDeviceType.desktop);
    });

    test('Matrix Scenario 5: Save draft action persists working draft',
        () async {
      final controller = AdminWorkspaceController(
        siteContentService: contentService,
        authRepository: mockAuth,
        storageRepository: mockStorage,
      )..updateField('about.title', 'Novo Título Sobre Nós');
      expect(controller.viewState.hasUnsavedChanges, isTrue);

      await controller.saveDraft();

      expect(mockRepo.storedDraft, isNotNull);
      expect(mockRepo.storedDraft?['about.title'], 'Novo Título Sobre Nós');
      expect(controller.state, isA<SuccessState<AdminWorkspaceState>>());

      controller.dispose();
    });

    test('Matrix Scenario 6: Publish live commits and resets unsaved indicator',
        () async {
      final controller = AdminWorkspaceController(
        siteContentService: contentService,
        authRepository: mockAuth,
        storageRepository: mockStorage,
      )..updateField('contact.whatsapp_number', '(41) 99999-8888');
      expect(controller.viewState.hasUnsavedChanges, isTrue);

      await controller.publish();

      expect(
        mockRepo.storedContent['contact.whatsapp_number'],
        '(41) 99999-8888',
      );
      expect(controller.viewState.hasUnsavedChanges, isFalse);
      expect(controller.state, isA<SuccessState<AdminWorkspaceState>>());

      controller.dispose();
    });
  });

  group('Admin Workspace Preview Widget Tests', () {
    testWidgets(
        'Matrix Scenario 1: Desktop viewport renders split-screen layout',
        (tester) async {
      tester.view
        ..physicalSize = const Size(1280, 800)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestableApp(child: const AdminWorkspaceView()),
      );
      await tester.pumpAndSettle();

      // Form Editor is present
      expect(find.text('Seção Inicial (Hero)'), findsOneWidget);
      expect(find.text('Sobre Nós & Cuidados'), findsOneWidget);

      // Live Preview and toolbar are simultaneously present on desktop
      expect(find.byType(AdminLivePreview), findsOneWidget);
      expect(find.byType(AdminPreviewToolbar), findsOneWidget);
      expect(find.text('Pré-visualização ao vivo'), findsOneWidget);
    });

    testWidgets(
        'Matrix Scenario 2: Mobile viewport switches between Editor & Preview',
        (tester) async {
      tester.view
        ..physicalSize = const Size(600, 900)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestableApp(child: const AdminWorkspaceView()),
      );
      await tester.pumpAndSettle();

      // In mobile editor mode by default
      expect(find.text('Editor'), findsOneWidget);
      expect(find.text('Pré-visualizar'), findsOneWidget);
      expect(find.text('Seção Inicial (Hero)'), findsOneWidget);
      expect(find.byType(AdminLivePreview), findsNothing);

      // Tap 'Pré-visualizar' segment
      await tester.tap(find.text('Pré-visualizar'));
      await tester.pumpAndSettle();

      // In preview mode: live preview visible, form sections hidden
      expect(find.byType(AdminLivePreview), findsOneWidget);
      expect(find.text('Seção Inicial (Hero)'), findsNothing);

      // Tap back to 'Editor' segment
      await tester.tap(find.text('Editor'));
      await tester.pumpAndSettle();

      expect(find.text('Seção Inicial (Hero)'), findsOneWidget);
      expect(find.byType(AdminLivePreview), findsNothing);
    });

    testWidgets(
        'Matrix Scenario 3: Keystroke update immediately updates live preview',
        (tester) async {
      tester.view
        ..physicalSize = const Size(1280, 800)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestableApp(child: const AdminWorkspaceView()),
      );
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);

      const updatedBadge = '🐾 Novo Selo de Qualidade';
      await tester.enterText(textFields.first, updatedBadge);
      await tester.pumpAndSettle();

      // The live preview immediately reflects the entered text
      expect(
        find.descendant(
          of: find.byType(AdminLivePreview),
          matching: find.text(updatedBadge),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'Matrix Scenario 4: Viewport simulation toolbar toggles devices',
        (tester) async {
      tester.view
        ..physicalSize = const Size(1280, 800)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestableApp(child: const AdminWorkspaceView()),
      );
      await tester.pumpAndSettle();

      // Tap Mobile preview icon
      final mobileIcon = find.byIcon(Icons.phone_iphone_rounded);
      expect(mobileIcon, findsOneWidget);
      await tester.tap(mobileIcon);
      await tester.pumpAndSettle();

      // Tap Tablet preview icon
      final tabletIcon = find.byIcon(Icons.tablet_mac_rounded);
      expect(tabletIcon, findsOneWidget);
      await tester.tap(tabletIcon);
      await tester.pumpAndSettle();

      // Tap Desktop preview icon
      final desktopIcon = find.byIcon(Icons.desktop_windows_rounded);
      expect(desktopIcon, findsOneWidget);
      await tester.tap(desktopIcon);
      await tester.pumpAndSettle();
    });

    testWidgets('Live preview renders all sections with fallback content',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdminLivePreview(
              bundle: ContentBundle.empty(),
              previewDevice: PreviewDeviceType.desktop,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('preview_hero_section')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('preview_about_section')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('preview_services_section')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('preview_gallery_section')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('preview_location_section')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('preview_footer_section')),
        findsOneWidget,
      );
    });
  });
}
