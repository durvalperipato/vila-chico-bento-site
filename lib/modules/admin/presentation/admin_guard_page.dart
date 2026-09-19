import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nano_core/nano_core.dart';
import '../../../core/theme/app_colors.dart';
import 'auth/admin_login_page.dart';
import 'guard/admin_guard_controller.dart';
import 'guard/admin_guard_injections.dart';
import 'guard/admin_guard_state.dart';

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
        if (state.userId == null) return const AdminLoginPage();
        return _AdminWorkspacePlaceholder(
          userEmail: state.userEmail ?? 'Operador Autorizado',
          onSignOut: controller.signOut,
        );
      },
    );
  }
}

/// Placeholder workspace view displayed upon successful authentication
/// before the dynamic form editor in Story 1.4 is mounted.
class _AdminWorkspacePlaceholder extends StatelessWidget {
  const _AdminWorkspacePlaceholder({
    required this.userEmail,
    required this.onSignOut,
  });

  final String userEmail;
  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary(isDark),
      appBar: AppBar(
        backgroundColor: AppColors.bgCard(isDark),
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pets_rounded, color: AppColors.primary, size: 24),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                'Vila Chico Bento | Painel Admin',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(isDark),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                userEmail,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary(isDark),
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Sair da sessão',
            icon: const Icon(Icons.logout_rounded, size: 20),
            onPressed: onSignOut,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 580),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.bgCard(isDark),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderSubtle(isDark)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Sessão Autenticada com Sucesso!',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(isDark),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'A rota protegida /admin foi configurada e o operador '
                'está conectado via Firebase Auth. O próximo passo (Story 1.4) '
                'montará o gerador dinâmico de formulários de conteúdo.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.textMuted(isDark),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.toReplacementNamed('/'),
                icon: const Icon(Icons.home_rounded, size: 18),
                label: const Text('Ver Landing Page'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
