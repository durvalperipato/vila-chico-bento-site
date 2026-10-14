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
  })  : _defaultBundle = initialBundle ?? const ContentBundle.empty(),
        super(initialBundle ?? const ContentBundle.empty());

  final SiteContentRepository repository;
  final String siteId;
  final ContentBundle _defaultBundle;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  /// Returns the current active content bundle.
  ContentBundle get bundle => value;

  ContentBundle _mergeWithDefault(Map<String, dynamic> data) {
    if (_defaultBundle.toMap().isEmpty) {
      return ContentBundle.fromMap(data);
    }
    final merged = Map<String, dynamic>.from(_defaultBundle.toMap())
      ..addAll(data);
    return ContentBundle.fromMap(merged);
  }

  /// Loads the initial published content and begins streaming real-time
  /// updates.
  Future<void> init() async {
    final initialData = await repository.getContent(siteId);
    if (initialData.isNotEmpty) {
      value = _mergeWithDefault(initialData);
    }

    await _subscription?.cancel();
    _subscription = repository.watchContent(siteId).listen((data) {
      if (data.isNotEmpty) {
        value = _mergeWithDefault(data);
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

  /// Loads existing draft data, if any, merging on top of current published
  /// content and canonical defaults.
  Future<ContentBundle?> loadDraft() async {
    final draft = await repository.getDraft(siteId);
    if (draft != null && draft.isNotEmpty) {
      final hasContent = draft.keys.any((k) =>
          k != 'adminEmails' &&
          k != 'siteName' &&
          k != 'updated_at' &&
          k != 'created_at');
      if (!hasContent) return null;
      final merged = Map<String, dynamic>.from(value.toMap())..addAll(draft);
      return ContentBundle.fromMap(merged);
    }
    return null;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
