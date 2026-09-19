import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/entities/content_bundle.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/site_content_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/infrastructure/services/site_content_service.dart';

class MockSiteContentRepository implements SiteContentRepository {
  Map<String, dynamic> store = {};
  Map<String, dynamic>? draftStore;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  @override
  Future<Map<String, dynamic>> getContent(String siteId) async =>
      Map.from(store);

  @override
  Stream<Map<String, dynamic>> watchContent(String siteId) =>
      _controller.stream;

  @override
  Future<void> saveContent(String siteId, Map<String, dynamic> data) async {
    store = Map.from(data);
    _controller.add(Map.from(data));
  }

  @override
  Future<void> saveDraft(String siteId, Map<String, dynamic> data) async {
    draftStore = Map.from(data);
  }

  @override
  Future<Map<String, dynamic>?> getDraft(String siteId) async =>
      draftStore == null ? null : Map.from(draftStore!);

  void dispose() {
    _controller.close();
  }
}

void main() {
  group('ContentBundle Tests', () {
    test('resolves flat keys and dot-separated nested keys', () {
      final bundle = ContentBundle.fromMap({
        'flatKey': 'Flat Value',
        'hero': {
          'title': 'Nested Hero Title',
          'views': 42,
          'rating': 4.9,
          'active': true,
        },
        'gallery': {
          'images': ['img1.webp', 'img2.webp'],
        },
        'services': {
          'items': [
            {'name': 'Day Care'},
            {'name': 'Hotelzinho'},
          ],
        },
      });

      // Flat
      expect(bundle.getString('flatKey', fallback: 'fb'), 'Flat Value');

      // Nested
      expect(
          bundle.getString('hero.title', fallback: 'fb'), 'Nested Hero Title');
      expect(bundle.getInt('hero.views', fallback: 0), 42);
      expect(bundle.getDouble('hero.rating', fallback: 1.0), 4.9);
      expect(bundle.getBool('hero.active', fallback: false), isTrue);
      expect(
        bundle.getStringList('gallery.images', fallback: []),
        ['img1.webp', 'img2.webp'],
      );
      expect(
        bundle.getListMap('services.items', fallback: []).length,
        2,
      );
    });

    test('returns fallbacks on missing or mismatched types', () {
      final bundle = ContentBundle.fromMap({
        'blankString': '   ',
        'invalidInt': 'not-a-number',
        'emptyList': [],
      });

      expect(bundle.getString('missingKey', fallback: 'Default Title'),
          'Default Title');
      expect(bundle.getString('blankString', fallback: 'Default Title'),
          'Default Title');
      expect(bundle.getInt('invalidInt', fallback: 10), 10);
      expect(bundle.getDouble('missingDouble', fallback: 3.14), 3.14);
      expect(bundle.getBool('missingBool', fallback: true), isTrue);
      expect(bundle.getStringList('emptyList', fallback: ['fallback.png']),
          ['fallback.png']);
    });

    test('immutability with set and copyWith', () {
      final original = ContentBundle.fromMap({'title': 'Old'});
      final updated = original.set('title', 'New');

      expect(original.getString('title', fallback: ''), 'Old');
      expect(updated.getString('title', fallback: ''), 'New');

      final merged = original.copyWith({'badge': 'New Badge'});
      expect(merged.getString('title', fallback: ''), 'Old');
      expect(merged.getString('badge', fallback: ''), 'New Badge');
    });
  });

  group('SiteContentService Tests', () {
    late MockSiteContentRepository mockRepo;
    late SiteContentService service;

    setUp(() {
      mockRepo = MockSiteContentRepository();
      service = SiteContentService(
        repository: mockRepo,
        siteId: 'test-site',
      );
    });

    tearDown(() {
      service.dispose();
      mockRepo.dispose();
    });

    test('init loads data and listens to updates', () async {
      mockRepo.store = {'hero.title': 'Initial Title'};
      await service.init();

      expect(service.bundle.getString('hero.title', fallback: ''),
          'Initial Title');

      // Update in repository stream
      await mockRepo.saveContent('test-site', {'hero.title': 'Streamed Title'});
      await pumpEventQueue();

      expect(service.bundle.getString('hero.title', fallback: ''),
          'Streamed Title');
    });

    test('updatePreview updates value without saving to repository', () {
      service.updatePreview({'hero.title': 'Preview Title'});

      expect(service.bundle.getString('hero.title', fallback: ''),
          'Preview Title');
      expect(mockRepo.store.isEmpty, isTrue); // Not written to store
    });

    test('publish commits to repository and updates bundle', () async {
      await service.publish({'hero.title': 'Published Title'});

      expect(service.bundle.getString('hero.title', fallback: ''),
          'Published Title');
      expect(mockRepo.store['hero.title'], 'Published Title');
    });

    test('saveDraft and loadDraft manage draft lifecycle', () async {
      expect(await service.loadDraft(), isNull);

      await service.saveDraft({'hero.title': 'Draft Title'});
      final loaded = await service.loadDraft();

      expect(loaded, isNotNull);
      expect(loaded!.getString('hero.title', fallback: ''), 'Draft Title');
    });
  });
}
