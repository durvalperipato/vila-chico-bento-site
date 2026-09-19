import 'package:nano_core/nano_core.dart';
import '../../modules/admin/presentation/guard/admin_guard_page.dart';
import '../../modules/home/presentation/home_page.dart';

/// Central declarative router configuration using [NanoRouter] and [NanoRoute].
final appRouter = NanoRouter(
  routes: [
    NanoRoute(
      path: '/',
      builder: (context, args) => const HomePage(),
    ),
    NanoRoute(
      path: '/admin',
      builder: (context, args) => const AdminGuardPage(),
    ),
  ],
);
