import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/l10n/generated/app_localizations.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/entities/content_bundle.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/site_content_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/infrastructure/services/site_content_service.dart';
import 'package:vila_chico_bento_site/modules/home/domain/entities/home_view_content.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_page.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_state.dart';

class MockSiteContentRepository implements SiteContentRepository {
  @override
  Future<Map<String, dynamic>> getContent(String siteId) async => {};

  @override
  Future<void> saveContent(String siteId, Map<String, dynamic> data) async {}

  @override
  Future<Map<String, dynamic>?> getDraft(String siteId) async => null;

  @override
  Future<void> saveDraft(String siteId, Map<String, dynamic> data) async {}

  @override
  Stream<Map<String, dynamic>> watchContent(String siteId) =>
      const Stream.empty();
}

void main() {
  group('Home Strongly Typed Content & State Tests', () {
    test('HomeState initializes with provided ContentBundle', () {
      final state = HomeState(
        contentBundle: ContentBundle.fromMap({
          'hero': {'title': 'Hero Title', 'badge': 'Hero Badge'},
          'about': {'title': 'About Title', 'description': 'About Desc'},
          'services': {'title': 'Services Title'},
          'gallery': {'title': 'Gallery Title'},
          'location': {'title': 'Location Title'},
          'contact': {'title': 'Contact Title'},
          'footer': {'about_text': 'Footer Text'},
        }),
      );

      expect(state.hero, isA<HeroViewContent>());
      expect(state.hero.title, equals('Hero Title'));
      expect(state.hero.badge, equals('Hero Badge'));

      expect(state.about, isA<AboutViewContent>());
      expect(state.about.title, equals('About Title'));
      expect(state.about.description, equals('About Desc'));

      expect(state.services, isA<ServicesViewContent>());
      expect(state.services.title, equals('Services Title'));

      expect(state.gallery, isA<GalleryViewContent>());
      expect(state.gallery.title, equals('Gallery Title'));

      expect(state.location, isA<LocationViewContent>());
      expect(state.location.title, equals('Location Title'));

      expect(state.contact, isA<ContactViewContent>());
      expect(state.contact.title, equals('Contact Title'));

      expect(state.footer, isA<FooterViewContent>());
      expect(state.footer.aboutText, equals('Footer Text'));
    });

    test('HeroViewContent extracts strongly typed values from custom bundle',
        () {
      final customBundle = ContentBundle.fromMap({
        'hero.title': 'Titulo Personalizado',
        'hero.badge': '🐾 Badge Teste',
        'hero.main_image': 'https://exemplo.com/hero.jpg',
        'hero.subtitle': 'Subtitulo Teste',
        'hero.cta_whatsapp_text': 'Fale Conosco',
        'hero.cta_secondary': 'Servicos Teste',
      });

      final hero = HeroViewContent.fromBundle(customBundle);

      expect(hero.title, equals('Titulo Personalizado'));
      expect(hero.badge, equals('Badge Teste'));
      expect(hero.mainImage, equals('https://exemplo.com/hero.jpg'));
      expect(hero.subtitle, equals('Subtitulo Teste'));
      expect(hero.ctaWhatsappText, equals('Fale Conosco'));
      expect(hero.ctaServicesText, equals('Servicos Teste'));
    });

    test(
        'HeroViewContent provides empty safe strings when bundle keys are absent',
        () {
      const emptyBundle = ContentBundle.empty();
      final hero = HeroViewContent.fromBundle(emptyBundle);

      expect(hero.title, isEmpty);
      expect(hero.badge, isEmpty);
      expect(hero.subtitle, isEmpty);
      expect(hero.ctaWhatsappText, isEmpty);
      expect(hero.ctaServicesText, isEmpty);
    });

    test('HomeController updates HomeState when SiteContentService notifies',
        () async {
      final repo = MockSiteContentRepository();
      final service = SiteContentService(
        repository: repo,
        siteId: 'vila-chico-bento',
        initialBundle: ContentBundle.fromMap({
          'hero': {'title': 'Initial Title'},
        }),
      );
      final controller = HomeController(siteContentService: service);
      await controller.init(null);

      expect(controller.viewState.hero.title, equals('Initial Title'));

      service.updatePreview({
        'hero.title': 'Titulo Atualizado em Tempo Real',
      });

      expect(
        controller.viewState.hero.title,
        equals('Titulo Atualizado em Tempo Real'),
      );

      controller.dispose();
      service.dispose();
    });
  });

  group('HomePage Widget Rendering with NanoScaffold', () {
    testWidgets('renders HomePage with strongly typed sections',
        (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('pt'),
          home: HomePage(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(HomePage), findsOneWidget);
      expect(
        find.byType(NanoScaffold<HomeState, NanoMessageKey>),
        findsOneWidget,
      );
    });
  });
}
