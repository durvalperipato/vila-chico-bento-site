import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../home/presentation/home_controller.dart';
import '../../../../home/presentation/home_state.dart';
import '../../../../home/presentation/widgets/floating/whatsapp_floating.dart';
import '../../../../home/presentation/widgets/navbar/navbar.dart';
import '../../../../home/presentation/widgets/sections/about_section.dart';
import '../../../../home/presentation/widgets/sections/contact_cta_section.dart';
import '../../../../home/presentation/widgets/sections/footer_section.dart';
import '../../../../home/presentation/widgets/sections/gallery_section.dart';
import '../../../../home/presentation/widgets/sections/hero_section.dart';
import '../../../../home/presentation/widgets/sections/location_section.dart';
import '../../../../home/presentation/widgets/sections/services_section.dart';
import '../../../domain/entities/content_bundle.dart';
import '../admin_workspace_state.dart';

/// Live preview pane rendering the ACTUAL site sections in real time based on
/// the operator's working draft [bundle].
class AdminLivePreview extends StatefulWidget {
  const AdminLivePreview({
    required this.bundle,
    required this.previewDevice,
    this.selectedSectionNotifier,
    super.key,
  });

  final ContentBundle bundle;
  final PreviewDeviceType previewDevice;
  final ValueNotifier<String?>? selectedSectionNotifier;

  @override
  State<AdminLivePreview> createState() => _AdminLivePreviewState();
}

class _AdminLivePreviewState extends State<AdminLivePreview> {
  late final HomeController _previewController;
  final GlobalKey _footerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _previewController = HomeController();
    widget.selectedSectionNotifier?.addListener(_handleSectionSelected);
  }

  @override
  void didUpdateWidget(covariant AdminLivePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedSectionNotifier != widget.selectedSectionNotifier) {
      oldWidget.selectedSectionNotifier?.removeListener(_handleSectionSelected);
      widget.selectedSectionNotifier?.addListener(_handleSectionSelected);
    }
  }

  @override
  void dispose() {
    widget.selectedSectionNotifier?.removeListener(_handleSectionSelected);
    _previewController.dispose();
    super.dispose();
  }

  void _handleSectionSelected() {
    final sectionId = widget.selectedSectionNotifier?.value;
    if (sectionId == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final targetKey = switch (sectionId) {
        'hero' => _previewController.heroKey,
        'about' => _previewController.aboutKey,
        'services' => _previewController.servicesKey,
        'gallery' => _previewController.galleryKey,
        'location' => _previewController.locationKey,
        'contact' => _previewController.contactKey,
        'footer' => _footerKey,
        _ => null,
      };
      final targetContext = targetKey?.currentContext;
      if (targetContext != null) {
        Scrollable.ensureVisible(
          targetContext,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
          alignment: 0.05,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final homeState = HomeState(
      isDarkMode: isDark,
      contentBundle: widget.bundle,
    );

    final (
      double maxWidth,
      double deviceBorderRadius,
      EdgeInsets outerPadding,
    ) = switch (widget.previewDevice) {
      PreviewDeviceType.desktop => (double.infinity, 0.0, EdgeInsets.zero),
      PreviewDeviceType.tablet => (768.0, 18.0, const EdgeInsets.all(16)),
      PreviewDeviceType.mobile => (390.0, 36.0, const EdgeInsets.all(16)),
    };

    final isConstrained = widget.previewDevice != PreviewDeviceType.desktop;

    return Padding(
      padding: outerPadding,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgPrimary(context),
              borderRadius: BorderRadius.circular(deviceBorderRadius),
              border: isConstrained
                  ? Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1),
                      width: widget.previewDevice == PreviewDeviceType.mobile
                          ? 8
                          : 6,
                    )
                  : null,
              boxShadow: isConstrained
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 28,
                        offset: const Offset(0, 12),
                      ),
                    ]
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final simulatedWidth = switch (widget.previewDevice) {
                  PreviewDeviceType.mobile => 390.0,
                  PreviewDeviceType.tablet => 768.0,
                  PreviewDeviceType.desktop => constraints.maxWidth >= 1024
                      ? constraints.maxWidth
                      : 1200.0,
                };

                final simulatedMediaQuery = MediaQuery.of(context).copyWith(
                  size: Size(simulatedWidth, constraints.maxHeight),
                );

                return MediaQuery(
                  data: simulatedMediaQuery,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        key: const ValueKey('live_preview_scroll_view'),
                        controller: _previewController.scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Navbar(controller: _previewController),
                            HeroSection(
                              state: homeState,
                              controller: _previewController,
                            ),
                            AboutSection(
                              state: homeState,
                              controller: _previewController,
                            ),
                            ServicesSection(
                              state: homeState,
                              controller: _previewController,
                            ),
                            GallerySection(
                              state: homeState,
                              controller: _previewController,
                            ),
                            LocationSection(
                              state: homeState,
                              controller: _previewController,
                            ),
                            ContactCtaSection(
                              state: homeState,
                              controller: _previewController,
                            ),
                            KeyedSubtree(
                              key: _footerKey,
                              child: FooterSection(
                                state: homeState,
                                controller: _previewController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Positioned(
                        bottom: 24,
                        right: 24,
                        child: WhatsappFloating(),
                      ),
                      if (widget.previewDevice == PreviewDeviceType.mobile)
                        Positioned(
                          top: 8,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 90,
                              height: 14,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFF334155),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
