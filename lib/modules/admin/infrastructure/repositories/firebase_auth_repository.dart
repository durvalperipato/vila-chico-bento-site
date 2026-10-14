import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';

/// Concrete Firebase Auth implementation of [AuthRepository].
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  Stream<String?> get authStateChanges =>
      _auth.authStateChanges().map((user) => user?.uid);

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  String? get currentUserEmail => _auth.currentUser?.email;

  @override
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
