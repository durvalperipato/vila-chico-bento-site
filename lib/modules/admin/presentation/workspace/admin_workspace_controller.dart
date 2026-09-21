import 'dart:typed_data';
import 'package:nano_core/nano_core.dart';
import '../../domain/entities/content_bundle.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/storage_repository.dart';
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

  /// Updates a field value in real time on keystroke.
  void updateField(String key, dynamic value) {
    final currentMap = viewState.bundle.toMap();
    final updatedMap = Map<String, dynamic>.from(currentMap)..[key] = value;
    final updatedBundle = ContentBundle.fromMap(updatedMap);

    // Live preview update
    _siteContentService.updatePreview(updatedMap);

    emitLoaded(
      viewState.copyWith(
        bundle: updatedBundle,
        hasUnsavedChanges: true,
      ),
    );
  }

  /// Persists working draft without publishing to live visitors.
  Future<void> saveDraft() async {
    await execute(
      () => _siteContentService.saveDraft(viewState.bundle.toMap()),
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
  }

  /// Publishes changes to the public website in Cloud Firestore.
  Future<void> publish() async {
    await execute(
      () => _siteContentService.publish(viewState.bundle.toMap()),
      onSuccess: (_) {
        emitSuccess(
          key: WorkspaceMessages.published,
          data: viewState.copyWith(hasUnsavedChanges: false),
        );
      },
      onError: (_) {
        emitError(key: WorkspaceMessages.error);
      },
    );
  }

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

  /// Ends operator session.
  Future<void> signOut() => _authRepository.signOut();
}
