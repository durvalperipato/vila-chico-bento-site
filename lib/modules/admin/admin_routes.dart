import 'package:nano_core/nano_core.dart';
import 'domain/repositories/auth_repository.dart';
import 'presentation/auth/admin_login_page.dart';
import 'presentation/workspace/admin_workspace_view.dart';

/// Declarative routes for the schema-driven admin module.
class AdminRoutes {
  AdminRoutes._();

  static const String admin = '/admin';
  static const String login = '/admin/login';

  /// Pre-configured routes ready to be spread into [NanoRouter].
  static List<NanoRouteBase> get routes => [
        NanoRoute(
          path: login,
          builder: (context, args) => const AdminLoginPage(),
        ),
        NanoProtectedRoute(
          path: admin,
          redirectTo: login,
          hasAccess: (context, args) {
            if (!GetIt.I.isRegistered<AuthRepository>()) return false;
            return GetIt.I<AuthRepository>().isAuthenticated;
          },
          routes: [
            NanoRoute(
              path: '',
              builder: (context, args) => const AdminWorkspaceView(),
            ),
          ],
        ),
      ];
}
