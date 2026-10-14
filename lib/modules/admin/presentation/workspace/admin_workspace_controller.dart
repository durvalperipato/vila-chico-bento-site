import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:nano_core/nano_core.dart';
import '../../domain/entities/content_bundle.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/storage_repository.dart';
import '../../domain/schema/vila_chico_bento_schema.dart';
import '../../infrastructure/services/site_content_service.dart';
import 'admin_workspace_state.dart';
import 'workspace_messages.dart';

/// Controller managing administrative editing, draft updates, and publishing.
class AdminWorkspaceController extends NanoController<AdminWorkspaceState> {
  AdminWorkspaceController({
    required SiteContentService siteContentService,
    required AuthRepository authRepository,
    required StorageRepository storageRepository,
  })  : _siteContentService = siteContentService,
        _authRepository = authRepository,
        _storageRepository = storageRepository,
        super(
          initialState: AdminWorkspaceState(
            bundle: siteContentService.bundle,
          ),
        );

  final SiteContentService _siteContentService;
  final AuthRepository _authRepository;
  final StorageRepository _storageRepository;

  /// Current operator email address.
  String? get operatorEmail => _authRepository.currentUserEmail;

  @override
  Future<void> init(String? id) async {
    await execute<ContentBundle>(
      () async {
        await _siteContentService.init();
        final draft = await _siteContentService.loadDraft();
        final initialBundle = draft ?? _siteContentService.bundle;
        return initialBundle;
      },
      onSuccess: (initialBundle) {
        emitLoaded(
          viewState.copyWith(
            bundle: initialBundle,
            hasUnsavedChanges: false,
          ),
        );
      },
      onError: (_) {
        emitLoaded(viewState);
      },
    );
  }

  final NanoDebouncer _debouncer =
      NanoDebouncer(duration: const Duration(milliseconds: 180));
  Map<String, dynamic>? _pendingMap;

  @override
  void dispose() {
    _debouncer.dispose();
    selectedSectionNotifier.dispose();
    super.dispose();
  }

  void _flushPendingUpdates() {
    _debouncer.cancel();
    if (_pendingMap == null) return;

    final updatedMap = _pendingMap!;
    _pendingMap = null;
    final updatedBundle = ContentBundle.fromMap(updatedMap);

    _siteContentService.updatePreview(updatedMap);

    emitLoaded(
      viewState.copyWith(
        bundle: updatedBundle,
        hasUnsavedChanges: true,
      ),
    );
  }

  /// Updates a field value with a gentle 180ms debounce to guarantee
  /// 120 FPS buttery-smooth typing in the form editor.
  void updateField(String key, dynamic value) {
    _pendingMap ??= Map<String, dynamic>.from(viewState.bundle.toMap());
    _pendingMap![key] = value;

    _debouncer.run(_flushPendingUpdates);
  }

  /// Validates all fields marked as required in the schema.
  List<String> validateRequiredFields() {
    _flushPendingUpdates();
    final missing = <String>[];
    final bundle = viewState.bundle;
    for (final section in VilaChicoBentoSchema.schema.sections) {
      for (final field in section.fields) {
        if (field.required) {
          final val = bundle.getString(field.key);
          if (val.trim().isEmpty) {
            missing.add(field.label);
          }
        }
      }
    }
    return missing;
  }

  /// Command that persists working draft with built-in loading and debounce.
  late final saveDraftCommand = nanoCommand0<void>(
    () async {
      _flushPendingUpdates();
      await _siteContentService.saveDraft(viewState.bundle.toMap());
    },
    onSuccess: (_) {
      emitSuccess(
        key: WorkspaceMessages.draftSaved,
        data: viewState.copyWith(hasUnsavedChanges: true),
      );
    },
    onError: (_) {
      emitError(key: WorkspaceMessages.error);
    },
  );

  /// Command that publishes working draft to the live site.
  /// Strictly blocks publication if any required field is empty.
  late final publishCommand = nanoCommand0<void>(
    () async {
      _flushPendingUpdates();
      final missing = validateRequiredFields();
      if (missing.isNotEmpty) {
        throw StateError('missing_required_fields');
      }
      await _siteContentService.publish(viewState.bundle.toMap());
    },
    onSuccess: (_) {
      emitSuccess(
        key: WorkspaceMessages.published,
        data: viewState.copyWith(hasUnsavedChanges: false),
      );
    },
    onError: (error) {
      if (error is StateError && error.message == 'missing_required_fields') {
        emitError(key: WorkspaceMessages.validationError);
      } else {
        emitError(key: WorkspaceMessages.error);
      }
    },
  );

  /// Command that discards uncommitted draft modifications and reverts
  /// cleanly to the live published site bundle.
  late final discardDraftCommand = nanoCommand0<void>(
    () async {
      _debouncer.cancel();
      _pendingMap = null;

      final liveBundle = _siteContentService.bundle;
      await _siteContentService.saveDraft(liveBundle.toMap());
      _siteContentService.updatePreview(liveBundle.toMap());
    },
    onSuccess: (_) {
      final liveBundle = _siteContentService.bundle;
      emitSuccess(
        key: WorkspaceMessages.draftDiscarded,
        data: viewState.copyWith(
          bundle: liveBundle,
          hasUnsavedChanges: false,
        ),
      );
    },
    onError: (_) {
      emitError(key: WorkspaceMessages.error);
    },
  );

  /// Convenience wrapper to trigger [saveDraftCommand].
  Future<void> saveDraft() => saveDraftCommand.run();

  /// Convenience wrapper to trigger [publishCommand].
  Future<void> publish() => publishCommand.run();

  /// Convenience wrapper to trigger [discardDraftCommand].
  Future<void> discardDraft() => discardDraftCommand.run();

  /// Uploads a gallery photo to Storage and returns its public URL.
  Future<String> uploadGalleryImage({
    required Uint8List bytes,
    required String fileName,
    required String contentType,
  }) async {
    final uniqueName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
    final path = 'sites/${_siteContentService.siteId}/gallery/$uniqueName';
    return _storageRepository.uploadImage(
      path: path,
      bytes: bytes,
      contentType: contentType,
    );
  }

  /// Changes the simulated preview device type (desktop, tablet, mobile).
  void setPreviewDevice(PreviewDeviceType device) {
    emitLoaded(viewState.copyWith(previewDevice: device));
  }

  /// Changes the active mobile view mode (editor or preview).
  void setViewMode(AdminViewMode mode) {
    emitLoaded(viewState.copyWith(viewMode: mode));
  }

  /// Notifier broadcasting the currently focused section ID for synchronized
  /// auto-scrolling.
  final ValueNotifier<String?> selectedSectionNotifier =
      ValueNotifier<String?>(null);

  /// Selects a section to trigger auto-scrolling on the live preview pane.
  void selectSection(String sectionId) {
    if (selectedSectionNotifier.value == sectionId) {
      selectedSectionNotifier.value = null;
    }
    selectedSectionNotifier.value = sectionId;
  }

  /// Ends operator session and navigates to login.
  Future<void> signOut() async {
    await _authRepository.signOut();
    await NanoRouter.toReplacementNamed('/admin/login');
  }
}
