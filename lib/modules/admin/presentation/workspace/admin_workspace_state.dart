import 'package:nano_core/nano_core.dart';
import '../../domain/entities/content_bundle.dart';

/// Immutable state for the Admin Content Workspace.
class AdminWorkspaceState extends NanoViewState {
  const AdminWorkspaceState({
    this.bundle = const ContentBundle.empty(),
    this.hasUnsavedChanges = false,
  });

  final ContentBundle bundle;
  final bool hasUnsavedChanges;

  AdminWorkspaceState copyWith({
    ContentBundle? bundle,
    bool? hasUnsavedChanges,
  }) {
    return AdminWorkspaceState(
      bundle: bundle ?? this.bundle,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
    );
  }

  @override
  List<Object?> get props => [bundle, hasUnsavedChanges];
}
