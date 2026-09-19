import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import '../auth/admin_login_page.dart';
import '../workspace/admin_workspace_view.dart';
import 'admin_guard_controller.dart';
import 'admin_guard_injections.dart';
import 'admin_guard_state.dart';

/// Route guard component for `/admin` redirecting unauthenticated visitors to login.
class AdminGuardPage extends StatefulWidget {
  const AdminGuardPage({super.key});

  @override
  State<AdminGuardPage> createState() => _AdminGuardPageState();
}

class _AdminGuardPageState
    extends NanoStatePage<AdminGuardPage, AdminGuardController> {
  @override
  NanoInjections get injections => const AdminGuardInjections();

  @override
  Widget build(BuildContext context) {
    return NanoScaffold<AdminGuardState, NanoMessageKey>(
      controller: controller,
      builder: (context, nanoState) {
        final state = nanoState.data ?? controller.viewState;

        if (state.userId == null) {
          return const AdminLoginPage();
        }

        return const AdminWorkspaceView();
      },
    );
  }
}
