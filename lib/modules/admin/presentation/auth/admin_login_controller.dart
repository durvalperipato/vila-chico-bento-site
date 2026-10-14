import 'package:nano_core/nano_core.dart';
import '../../domain/repositories/auth_repository.dart';
import 'admin_login_state.dart';
import 'admin_messages.dart';

/// Controller managing administrative login logic via [NanoController].
class AdminLoginController extends NanoController<AdminLoginState> {
  AdminLoginController(this._authRepository)
      : super(initialState: const AdminLoginState());

  final AuthRepository _authRepository;

  @override
  Future<void> init(String? id) async {
    emitLoaded(viewState);
  }

  /// Toggles visibility of the password field.
  void togglePasswordVisibility() {
    emitLoaded(
      viewState.copyWith(
        isPasswordVisible: !viewState.isPasswordVisible,
      ),
    );
  }

  /// Authenticates operator credentials.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty || password.isEmpty) {
      emitError(key: AdminMessages.emptyFields);
      return;
    }

    await execute(
      () => _authRepository.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      ),
      onSuccess: (_) {
        NanoRouter.toReplacementNamed('/admin');
      },
      onError: (error) {
        emitError(key: AdminDynamicMessage(error.toString()));
      },
    );
  }
}
