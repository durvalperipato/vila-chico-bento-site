import 'package:nano_core/nano_core.dart';
import '../../modules/admin/domain/repositories/auth_repository.dart';
import '../../modules/admin/infrastructure/repositories/firebase_auth_repository.dart';

/// Central application dependency injection container via [NanoInjections].
class AppInjections extends NanoInjections {
  const AppInjections({super.scope = 'app'});

  @override
  void binds(GetIt i) {
    i.registerLazySingleton<AuthRepository>(FirebaseAuthRepository.new);
  }
}
