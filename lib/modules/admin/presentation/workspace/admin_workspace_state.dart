import 'package:nano_core/nano_core.dart';
import '../../domain/entities/content_bundle.dart';

/// Simulated device type in the live preview pane.
enum PreviewDeviceType {
  desktop,
  tablet,
  mobile,
}

/// Active view mode in mobile/compact viewports.
enum AdminViewMode {
  editor,
  preview,
}

/// Immutable state for the Admin Content Workspace.
class AdminWorkspaceState extends NanoViewState {
  const AdminWorkspaceState({
    this.bundle = const ContentBundle.empty(),
    this.hasUnsavedChanges = false,
    this.previewDevice = PreviewDeviceType.desktop,
    this.viewMode = AdminViewMode.editor,
  });

  final ContentBundle bundle;
  final bool hasUnsavedChanges;
  final PreviewDeviceType previewDevice;
  final AdminViewMode viewMode;

  AdminWorkspaceState copyWith({
    ContentBundle? bundle,
    bool? hasUnsavedChanges,
    PreviewDeviceType? previewDevice,
    AdminViewMode? viewMode,
  }) {
    return AdminWorkspaceState(
      bundle: bundle ?? this.bundle,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      previewDevice: previewDevice ?? this.previewDevice,
      viewMode: viewMode ?? this.viewMode,
    );
  }

  @override
  List<Object?> get props => [
        bundle,
        hasUnsavedChanges,
        previewDevice,
        viewMode,
      ];
}
