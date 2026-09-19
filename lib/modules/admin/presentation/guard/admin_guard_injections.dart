import 'package:nano_core/nano_core.dart';
import '../../domain/repositories/auth_repository.dart';
import 'admin_guard_controller.dart';

/// Dependency injection bindings for Admin Guard via [NanoInjections].
class AdminGuardInjections extends NanoInjections {
  const AdminGuardInjections({super.scope = 'admin_guard'});

  @override
  void binds(GetIt i) {
    i.registerFactory<AdminGuardController>(
      () => AdminGuardController(i<AuthRepository>()),
    );
  }
}
