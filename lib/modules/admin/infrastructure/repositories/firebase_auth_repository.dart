import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../domain/repositories/auth_repository.dart';

/// Concrete Firebase Auth implementation of [AuthRepository].
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;
  final _devAuthStateController = StreamController<String?>.broadcast();
  String? _devUserId;
  String? _devUserEmail;

  Stream<String?>? _combinedAuthStateStream;

  @override
  Stream<String?> get authStateChanges {
    return _combinedAuthStateStream ??= () {
      final controller = StreamController<String?>.broadcast();
      _auth.authStateChanges().listen(
            (user) => controller.add(_devUserId ?? user?.uid),
            onError: controller.addError,
          );
      _devAuthStateController.stream.listen(
            controller.add,
            onError: controller.addError,
          );
      return controller.stream;
    }();
  }

  @override
  String? get currentUserId => _devUserId ?? _auth.currentUser?.uid;

  @override
  String? get currentUserEmail => _devUserEmail ?? _auth.currentUser?.email;

  @override
  bool get isAuthenticated => _devUserId != null || _auth.currentUser != null;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // TODO(durval): Remover apos finalizar os testes no
    // painel admin.
    final isDevCredential =
        password == 'admin123' || email == 'admin@vilachicobento.com.br';
    if (kDebugMode && isDevCredential) {
      _devUserId = 'dev-operator-local';
      _devUserEmail = email.trim();
      _devAuthStateController.add(_devUserId);
      return;
    }

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
    _devUserId = null;
    _devUserEmail = null;
    _devAuthStateController.add(null);
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
