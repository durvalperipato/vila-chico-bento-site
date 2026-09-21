import 'package:nano_core/nano_core.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/storage_repository.dart';
import '../../infrastructure/services/site_content_service.dart';
import 'admin_workspace_controller.dart';

/// Dependency injection bindings for Admin Content Workspace
/// via [NanoInjections].
class AdminWorkspaceInjections extends NanoInjections {
  const AdminWorkspaceInjections({super.scope = 'admin_workspace'});

  @override
  void binds(GetIt i) {
    i.registerFactory<AdminWorkspaceController>(
      () => AdminWorkspaceController(
        siteContentService: i<SiteContentService>(),
        authRepository: i<AuthRepository>(),
        storageRepository: i<StorageRepository>(),
      ),
    );
  }
}
