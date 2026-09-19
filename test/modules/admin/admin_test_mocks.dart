import 'dart:async';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/auth_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/site_content_repository.dart';

class MockAuthRepository implements AuthRepository {
  String? userId;
  String? userEmail;
  final _controller = StreamController<String?>.broadcast();
  bool shouldThrow = false;
  String errorMessage = 'Auth Error';

  @override
  Stream<String?> get authStateChanges => _controller.stream;

  @override
  String? get currentUserId => userId;

  @override
  String? get currentUserEmail => userEmail;

  @override
  bool get isAuthenticated => userId != null;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (shouldThrow) throw errorMessage;
    userId = 'uid-123';
    userEmail = email;
    _controller.add(userId);
  }

  @override
  Future<void> signOut() async {
    userId = null;
    userEmail = null;
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}

class MockSiteContentRepository implements SiteContentRepository {
  Map<String, dynamic> storedContent = {};
  Map<String, dynamic>? storedDraft;

  @override
  Future<Map<String, dynamic>> getContent(String siteId) async => storedContent;

  @override
  Stream<Map<String, dynamic>> watchContent(String siteId) =>
      Stream.value(storedContent);

  @override
  Future<void> saveContent(String siteId, Map<String, dynamic> data) async {
    storedContent = Map<String, dynamic>.from(data);
  }

  @override
  Future<void> saveDraft(String siteId, Map<String, dynamic> data) async {
    storedDraft = Map<String, dynamic>.from(data);
  }

  @override
  Future<Map<String, dynamic>?> getDraft(String siteId) async => storedDraft;
}
