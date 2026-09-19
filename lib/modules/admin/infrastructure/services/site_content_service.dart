import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/content_bundle.dart';
import '../../domain/repositories/site_content_repository.dart';

/// Reactive service holding the currently active site content bundle.
class SiteContentService extends ValueNotifier<ContentBundle> {
  SiteContentService({
    required this.repository,
    required this.siteId,
    ContentBundle? initialBundle,
  }) : super(initialBundle ?? const ContentBundle.empty());
  final SiteContentRepository repository;
  final String siteId;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  /// Returns the current active content bundle.
  ContentBundle get bundle => value;

  /// Loads the initial published content and begins streaming real-time
  /// updates.
  Future<void> init() async {
    final initialData = await repository.getContent(siteId);
    if (initialData.isNotEmpty) {
      value = ContentBundle.fromMap(initialData);
    }

    await _subscription?.cancel();
    _subscription = repository.watchContent(siteId).listen((data) {
      if (data.isNotEmpty) {
        value = ContentBundle.fromMap(data);
      }
    });
  }

  /// Manually updates the current bundle (e.g. during live preview in the
  /// admin editor).
  void updatePreview(Map<String, dynamic> previewData) {
    value = ContentBundle.fromMap(previewData);
  }

  /// Publishes changes to Firestore.
  Future<void> publish(Map<String, dynamic> data) async {
    await repository.saveContent(siteId, data);
    value = ContentBundle.fromMap(data);
  }

  /// Saves a working draft without publishing.
  Future<void> saveDraft(Map<String, dynamic> data) async {
    await repository.saveDraft(siteId, data);
  }

  /// Loads existing draft data, if any.
  Future<ContentBundle?> loadDraft() async {
    final draft = await repository.getDraft(siteId);
    if (draft != null && draft.isNotEmpty) {
      return ContentBundle.fromMap(draft);
    }
    return null;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
