import 'package:nano_core/nano_core.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/site_content_repository.dart';
import '../../domain/vila_chico_bento_schema.dart';
import '../../infrastructure/repositories/firestore_site_content_repository.dart';
import '../../infrastructure/services/site_content_service.dart';
import 'admin_workspace_controller.dart';

/// Dependency injection bindings for Admin Content Workspace
/// via [NanoInjections].
class AdminWorkspaceInjections extends NanoInjections {
  const AdminWorkspaceInjections({super.scope = 'admin_workspace'});

  @override
  void binds(GetIt i) {
    if (!i.isRegistered<SiteContentRepository>()) {
      i.registerLazySingleton<SiteContentRepository>(
        FirestoreSiteContentRepository.new,
      );
    }

    if (!i.isRegistered<SiteContentService>()) {
      i.registerLazySingleton<SiteContentService>(
        () => SiteContentService(
          repository: i<SiteContentRepository>(),
          siteId: VilaChicoBentoSchema.siteId,
        ),
      );
    }

    i.registerFactory<AdminWorkspaceController>(
      () => AdminWorkspaceController(
        siteContentService: i<SiteContentService>(),
        authRepository: i<AuthRepository>(),
      ),
    );
  }
}
