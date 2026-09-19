import 'package:nano_core/nano_core.dart';

/// Immutable state for the Admin Login screen.
class AdminLoginState extends NanoViewState {
  const AdminLoginState({
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  final bool isLoading;
  final bool isPasswordVisible;
  final String? errorMessage;
  final bool isAuthenticated;

  AdminLoginState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    String? errorMessage,
    bool clearError = false,
    bool? isAuthenticated,
  }) {
    return AdminLoginState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isPasswordVisible,
        errorMessage,
        isAuthenticated,
      ];
}
