import 'package:nano_core/nano_core.dart';
import '../../domain/repositories/auth_repository.dart';
import 'admin_login_controller.dart';

/// Dependency injection bindings for Admin Login via [NanoInjections].
class AdminLoginInjections extends NanoInjections {
  const AdminLoginInjections({super.scope = 'admin_login'});

  @override
  void binds(GetIt i) {
    i.registerFactory<AdminLoginController>(
      () => AdminLoginController(i<AuthRepository>()),
    );
  }
}
