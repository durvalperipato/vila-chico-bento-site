---
title: 'Story 1.3: Operator Authentication and Protected /admin Route'
type: 'feature'
created: '09-19-2026'
status: 'completed'
route: 'oneshot'
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Access to the administration workspace must be strictly restricted to authenticated operators, redirecting anonymous visitors to a branded login screen and supporting session sign-in/sign-out via Firebase Auth.

**Approach:** Implement `AuthRepository` (Firebase Auth backed), authentication state management via Nano Core (`AuthController`, `AuthState`, `AuthInjections`), a luxury branded `AdminLoginPage`, an `AdminGuardPage` routing `/admin`, and update `NanoApp` routes in `lib/main.dart` with unit and widget tests.

</frozen-after-approval>

## Implementation Notes

- **Pure Nano Architecture:**
  - Implemented `AuthRepository` in domain and `FirebaseAuthRepository` in infrastructure.
  - Initialized global `AppInjections` in `lib/main.dart` (`FirebaseAuthRepository.new`).
  - Implemented `AdminLoginController`, `AdminLoginState`, `AdminLoginInjections`, and `AdminMessages` (`NanoMessageKey`).
  - Cleaned `AdminLoginState` by removing legacy flags (`isLoading`, `errorMessage`) in favor of canonical `NanoState` (`InitialState`, `LoadingState`, `LoadedState`, `ErrorState`).
  - Refactored `AdminLoginPage` to utilize `NanoScaffold`'s automatic overlay and `NanoToast.showError`.
  - Refactored `AdminGuardPage` into a pure `NanoStatePage<AdminGuardPage, AdminGuardController>` using `AdminGuardInjections`.
  - Configured declarative `NanoRouter` and `NanoRoute` in `lib/core/routes/app_router.dart` and integrated into `NanoApp`.
  - Verified 100% test coverage with 20/20 passing tests in `test/modules/admin/presentation/admin_auth_test.dart`.
  - Passed `flutter analyze` with 0 issues.
