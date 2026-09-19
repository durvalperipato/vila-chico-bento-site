import 'dart:async';
import 'package:nano_core/nano_core.dart';
import '../../domain/repositories/auth_repository.dart';
import 'admin_guard_state.dart';

/// Controller observing operator authentication status via [NanoController].
class AdminGuardController extends NanoController<AdminGuardState> {
  AdminGuardController(this._authRepository)
      : super(initialState: const AdminGuardState());

  final AuthRepository _authRepository;
  StreamSubscription<String?>? _sub;

  @override
  Future<void> init(String? id) async {
    emitLoaded(AdminGuardState(
      userId: _authRepository.currentUserId,
      userEmail: _authRepository.currentUserEmail,
    ));

    _sub = _authRepository.authStateChanges.listen((userId) {
      emitLoaded(AdminGuardState(
        userId: userId,
        userEmail: _authRepository.currentUserEmail,
      ));
    });
  }

  /// Signs out current operator.
  Future<void> signOut() => _authRepository.signOut();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
