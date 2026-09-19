import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/auth_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/site_content_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/infrastructure/services/site_content_service.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/auth/admin_login_controller.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/auth/admin_login_page.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/auth/admin_login_state.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/auth/admin_messages.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/guard/admin_guard_page.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/workspace/admin_workspace_view.dart';
import '../admin_test_mocks.dart';

void main() {
  group('AdminLoginController Tests', () {
    late MockAuthRepository mockAuth;
    late AdminLoginController controller;

    setUp(() {
      mockAuth = MockAuthRepository();
      controller = AdminLoginController(mockAuth);
    });

    tearDown(() {
      controller.dispose();
      mockAuth.dispose();
    });

    test('togglePasswordVisibility toggles isPasswordVisible', () {
      expect(controller.viewState.isPasswordVisible, isFalse);
      controller.togglePasswordVisibility();
      expect(controller.viewState.isPasswordVisible, isTrue);
    });

    test('signIn with empty fields sets error without calling repository',
        () async {
      await controller.signIn(email: '', password: '');
      expect(controller.state, isA<ErrorState<AdminLoginState>>());
      final errorState = controller.state as ErrorState<AdminLoginState>;
      expect(
        errorState.key,
        AdminMessages.emptyFields,
      );
      expect(mockAuth.isAuthenticated, isFalse);
    });

    test('signIn with valid credentials updates state and authenticates',
        () async {
      await controller.signIn(
        email: 'admin@vilachicobento.com.br',
        password: 'secretPassword',
      );

      expect(controller.state, isA<LoadedState<AdminLoginState>>());
      expect(mockAuth.isAuthenticated, isTrue);
      expect(mockAuth.currentUserId, 'uid-123');
    });

    test('signIn handles repository exception and emits error', () async {
      mockAuth
        ..shouldThrow = true
        ..errorMessage = 'Invalid email or password.';

      await controller.signIn(
        email: 'wrong@test.com',
        password: 'bad',
      );

      expect(controller.state, isA<ErrorState<AdminLoginState>>());
      final errorState = controller.state as ErrorState<AdminLoginState>;
      expect(
        (errorState.key! as AdminDynamicMessage).text,
        'Invalid email or password.',
      );
      expect(mockAuth.isAuthenticated, isFalse);
    });
  });

  group('AdminGuardPage Widget Tests', () {
    late MockAuthRepository mockAuth;
    late MockSiteContentRepository mockRepo;

    setUp(() async {
      await GetIt.I.reset();
      mockAuth = MockAuthRepository();
      mockRepo = MockSiteContentRepository();

      GetIt.I.registerSingleton<AuthRepository>(mockAuth);
      GetIt.I.registerSingleton<SiteContentRepository>(mockRepo);
      GetIt.I.registerSingleton<SiteContentService>(
        SiteContentService(
          repository: mockRepo,
          siteId: 'vila-chico-bento',
        ),
      );
    });

    tearDown(() async {
      mockAuth.dispose();
      await GetIt.I.reset();
    });

    testWidgets('renders AdminLoginPage when unauthenticated', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminGuardPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdminLoginPage), findsOneWidget);
      expect(find.text('Entrar no Painel'), findsOneWidget);
      expect(find.text('Painel Administrativo'), findsOneWidget);
    });

    testWidgets('renders workspace view when authenticated', (tester) async {
      mockAuth
        ..userId = 'uid-123'
        ..userEmail = 'admin@vilachicobento.com.br';

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminGuardPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdminLoginPage), findsNothing);
      expect(find.byType(AdminWorkspaceView), findsOneWidget);
      expect(
        find.text('Vila Chico Bento | Editor de Conteúdo'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
    });
  });
}
