import 'package:nano_core/nano_core.dart';

/// Immutable state for the Admin Guard view.
class AdminGuardState extends NanoViewState {
  const AdminGuardState({
    this.userId,
    this.userEmail,
  });

  final String? userId;
  final String? userEmail;

  AdminGuardState copyWith({
    String? userId,
    String? userEmail,
  }) {
    return AdminGuardState(
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  @override
  List<Object?> get props => [userId, userEmail];
}
