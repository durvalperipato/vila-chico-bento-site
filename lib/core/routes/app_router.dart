import 'package:nano_core/nano_core.dart';
import '../../modules/admin/admin_routes.dart';
import '../../modules/home/presentation/home_page.dart';

/// Central declarative router configuration using [NanoRouter] and [NanoRoute].
final appRouter = NanoRouter(
  routes: [
    ...AdminRoutes.routes,
    NanoRoute(
      path: '/',
      builder: (context, args) => const HomePage(),
    ),
  ],
);
