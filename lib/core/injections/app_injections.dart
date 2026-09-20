import 'package:nano_core/nano_core.dart';
import '../../modules/admin/domain/repositories/auth_repository.dart';
import '../../modules/admin/domain/repositories/site_content_repository.dart';
import '../../modules/admin/domain/vila_chico_bento_default_content.dart';
import '../../modules/admin/domain/vila_chico_bento_schema.dart';
import '../../modules/admin/infrastructure/repositories/firebase_auth_repository.dart';
import '../../modules/admin/infrastructure/repositories/firestore_site_content_repository.dart';
import '../../modules/admin/infrastructure/services/site_content_service.dart';

/// Central application dependency injection container via [NanoInjections].
class AppInjections extends NanoInjections {
  const AppInjections({super.scope = 'app'});

  @override
  void binds(GetIt i) {
    i
      ..registerLazySingleton<AuthRepository>(FirebaseAuthRepository.new)
      ..registerLazySingleton<SiteContentRepository>(
        FirestoreSiteContentRepository.new,
      )
      ..registerLazySingleton<SiteContentService>(
        () => SiteContentService(
          repository: i<SiteContentRepository>(),
          siteId: VilaChicoBentoSchema.siteId,
          initialBundle: VilaChicoBentoDefaultContent.bundle,
        ),
      );
  }
}
