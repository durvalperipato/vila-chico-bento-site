/// Contract for administrative operator authentication.
abstract class AuthRepository {
  /// Emits the current user ID when authentication state changes.
  Stream<String?> get authStateChanges;

  /// Current authenticated user identifier, if signed in.
  String? get currentUserId;

  /// Current authenticated user email, if signed in.
  String? get currentUserEmail;

  /// Whether an operator is actively signed in.
  bool get isAuthenticated;

  /// Signs in with an operator email and password.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs out the active operator session.
  Future<void> signOut();
}
