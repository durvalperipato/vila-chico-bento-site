import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/repositories/auth_repository.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/admin_guard_page.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/auth/admin_login_controller.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/auth/admin_login_page.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/auth/admin_login_state.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/auth/admin_messages.dart';

class MockAuthRepository implements AuthRepository {
  String? _userId;
  String? _userEmail;
  final _controller = StreamController<String?>.broadcast();
  bool shouldThrow = false;
  String errorMessage = 'Auth Error';

  @override
  Stream<String?> get authStateChanges => _controller.stream;

  @override
  String? get currentUserId => _userId;

  @override
  String? get currentUserEmail => _userEmail;

  @override
  bool get isAuthenticated => _userId != null;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (shouldThrow) throw errorMessage;
    _userId = 'uid-123';
    _userEmail = email;
    _controller.add(_userId);
  }

  @override
  Future<void> signOut() async {
    _userId = null;
    _userEmail = null;
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}

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

    setUp(() async {
      await GetIt.I.reset();
      mockAuth = MockAuthRepository();
      GetIt.I.registerSingleton<AuthRepository>(mockAuth);
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
        .._userId = 'uid-123'
        .._userEmail = 'admin@vilachicobento.com.br';

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminGuardPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdminLoginPage), findsNothing);
      expect(find.text('Vila Chico Bento | Painel Admin'), findsOneWidget);
      expect(find.text('admin@vilachicobento.com.br'), findsOneWidget);
      expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
    });
  });
}
