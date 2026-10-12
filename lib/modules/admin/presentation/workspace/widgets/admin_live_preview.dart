import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/extensions/image_provider_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../home/presentation/widgets/sections/widgets/gallery_desktop_grid.dart';
import '../../../../home/presentation/widgets/sections/widgets/gallery_horizontal_carousel.dart';
import '../../../domain/entities/content_bundle.dart';
import '../admin_workspace_state.dart';

/// Live preview pane rendering the site sections in real time based on
/// Live preview pane rendering the site sections in real time based on
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
  final Map<String, GlobalKey> _sectionKeys = {
    'hero': GlobalKey(),
    'about': GlobalKey(),
    'services': GlobalKey(),
    'gallery': GlobalKey(),
    'location': GlobalKey(),
    'contact': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  void _handleSectionSelected() {
    final sectionId = widget.selectedSectionNotifier?.value;
    if (sectionId == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final targetKey = _sectionKeys[sectionId];
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

  PreviewDeviceType get previewDevice => widget.previewDevice;
  ContentBundle get bundle => widget.bundle;

  String _get(String key) {
    return bundle.getOptionalString(key, fallback: '');
  }

  Widget _buildTextOrPlaceholder({
    required String text,
    required String placeholder,
    required TextStyle style,
    TextAlign textAlign = TextAlign.start,
  }) {
    final isBlank = text.trim().isEmpty;
    final displayText = isBlank ? '[$placeholder]' : text;
    return Text(
      displayText,
      textAlign: textAlign,
      style: isBlank
          ? style.copyWith(
              color: style.color?.withValues(alpha: 0.45) ?? Colors.white54,
              fontStyle: FontStyle.italic,
            )
          : style,
    );
  }

  List<String> _getGalleryImages() {
    return widget.bundle.getStringList(
      'gallery.images',
      fallback: const [],
    );
  }

  List<Map<String, dynamic>> _getServices() {
    return widget.bundle.getListMap(
      'services.items',
      fallback: const [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Viewport dimensions based on selected simulated device
    double? maxWidth;
    double? deviceBorderRadius;
    EdgeInsets outerPadding = const EdgeInsets.all(16);

    switch (widget.previewDevice) {
      case PreviewDeviceType.desktop:
        maxWidth = double.infinity;
        deviceBorderRadius = 0;
        outerPadding = EdgeInsets.zero;
        break;
      case PreviewDeviceType.tablet:
        maxWidth = 768;
        deviceBorderRadius = 18;
        break;
      case PreviewDeviceType.mobile:
        maxWidth = 375;
        deviceBorderRadius = 36;
        break;
    }

    final isConstrained = widget.previewDevice != PreviewDeviceType.desktop;

    final Widget previewContent = Container(
      decoration: BoxDecoration(
        color: AppColors.bgPrimary(context),
        borderRadius: BorderRadius.circular(deviceBorderRadius),
        border: isConstrained
            ? Border.all(
                color:
                    isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                width: widget.previewDevice == PreviewDeviceType.mobile ? 8 : 6,
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
      child: Stack(
        children: [
          SingleChildScrollView(
            key: const ValueKey('live_preview_scroll_view'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KeyedSubtree(
                  key: _sectionKeys['hero'],
                  child: _buildHeroSection(isDark),
                ),
                KeyedSubtree(
                  key: _sectionKeys['about'],
                  child: _buildAboutSection(context, isDark),
                ),
                KeyedSubtree(
                  key: _sectionKeys['services'],
                  child: _buildServicesSection(context, isDark),
                ),
                KeyedSubtree(
                  key: _sectionKeys['gallery'],
                  child: _buildGallerySection(context, isDark),
                ),
                KeyedSubtree(
                  key: _sectionKeys['location'],
                  child: _buildLocationSection(context, isDark),
                ),
                KeyedSubtree(
                  key: _sectionKeys['contact'],
                  child: _buildFooterSection(isDark),
                ),
              ],
            ),
          ),
          if (previewDevice == PreviewDeviceType.mobile)
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

    if (isConstrained) {
      return Container(
        color: isDark ? const Color(0xFF090D16) : const Color(0xFFE2E8F0),
        padding: outerPadding,
        alignment: Alignment.topCenter,
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: previewContent,
        ),
      );
    }

    return previewContent;
  }

  Widget _buildHeroSection(bool isDark) {
    final badge = _get('hero.badge');
    final title = _get('hero.title');
    final subtitle = _get('hero.subtitle');
    final ctaText = _get('hero.cta_whatsapp_text');
    final bannerImage = _get('hero.banner_image');
    final alignmentY = bundle.getDouble(
      'hero.banner_image_alignment_y',
      fallback: bundle.getDouble('hero.banner_alignment_y', fallback: 0.0),
    );

    return Container(
      key: const ValueKey('preview_hero_section'),
      constraints: const BoxConstraints(minHeight: 380),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.35,
              child: bannerImage.isNotEmpty
                  ? Image(
                      image: bannerImage.toImageProvider(),
                      fit: BoxFit.cover,
                      alignment: Alignment(0.0, alignmentY),
                      gaplessPlayback: true,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF1E293B),
                      ),
                    )
                  : Container(color: const Color(0xFF1E293B)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (badge.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      badge,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                _buildTextOrPlaceholder(
                  text: title,
                  placeholder: 'Título Principal do Hero',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize:
                        previewDevice == PreviewDeviceType.mobile ? 22 : 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                _buildTextOrPlaceholder(
                  text: subtitle,
                  placeholder: 'Subtítulo descritivo do Hero',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize:
                        previewDevice == PreviewDeviceType.mobile ? 13 : 15,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                if (ctaText.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  ElevatedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.chat_bubble_rounded, size: 16),
                    label: Text(ctaText),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF25D366),
                      disabledForegroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, bool isDark) {
    final badge = _get('about.badge');
    final title = _get('about.title');
    final desc = _get('about.description');

    return Container(
      key: const ValueKey('preview_about_section'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      color: isDark ? const Color(0xFF0F172A) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badge.isNotEmpty)
            Text(
              badge.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 1.1,
              ),
            ),
          const SizedBox(height: 6),
          _buildTextOrPlaceholder(
            text: title,
            placeholder: 'Título da Seção Sobre Nós',
            style: GoogleFonts.outfit(
              fontSize: previewDevice == PreviewDeviceType.mobile ? 18 : 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 14),
          _buildTextOrPlaceholder(
            text: desc,
            placeholder: 'Conteúdo descritivo sobre a Vila Chico Bento...',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary(context),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context, bool isDark) {
    final badge = _get('services.badge');
    final title = _get('services.title');
    final subtitle = _get('services.subtitle');
    final services = _getServices();

    return Container(
      key: const ValueKey('preview_services_section'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      color: isDark ? const Color(0xFF131D31) : const Color(0xFFF8FAFC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badge.isNotEmpty)
            Text(
              badge.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 1.1,
              ),
            ),
          const SizedBox(height: 6),
          _buildTextOrPlaceholder(
            text: title,
            placeholder: 'Título da Seção de Serviços',
            style: GoogleFonts.outfit(
              fontSize: previewDevice == PreviewDeviceType.mobile ? 18 : 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(context),
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
          const SizedBox(height: 18),
          ...services.map((item) {
            final cardTitle = (item['title'] ?? '').toString();
            final cardDesc = (item['description'] ?? '').toString();
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bgCard(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.borderSubtle(context),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.pets_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cardTitle,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        if (cardDesc.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            cardDesc,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGallerySection(BuildContext context, bool isDark) {
    final badge = _get('gallery.badge');
    final title = _get('gallery.title');
    final images = _getGalleryImages();

    return Container(
      key: const ValueKey('preview_gallery_section'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      color: isDark ? const Color(0xFF0F172A) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badge.isNotEmpty)
            Text(
              badge.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 1.1,
              ),
            ),
          const SizedBox(height: 6),
          _buildTextOrPlaceholder(
            text: title,
            placeholder: 'Momentos de pura diversão',
            style: GoogleFonts.outfit(
              fontSize: previewDevice == PreviewDeviceType.mobile ? 18 : 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 18),
          if (images.isNotEmpty)
            previewDevice == PreviewDeviceType.mobile
                ? GalleryHorizontalCarousel(images: images)
                : GalleryDesktopGrid(
                    images: images,
                    crossAxisCount:
                        previewDevice == PreviewDeviceType.tablet ? 2 : 3,
                  )
          else
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgCard(context),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                'Nenhuma foto na galeria',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context, bool isDark) {
    final badge = _get('location.badge');
    final title = _get('location.title');
    final address = _get('location.address');
    final hours = _get('location.hours');

    return Container(
      key: const ValueKey('preview_location_section'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      color: isDark ? const Color(0xFF131D31) : const Color(0xFFF8FAFC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badge.isNotEmpty)
            Text(
              badge.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 1.1,
              ),
            ),
          const SizedBox(height: 6),
          _buildTextOrPlaceholder(
            text: title,
            placeholder: 'Onde estamos e horários',
            style: GoogleFonts.outfit(
              fontSize: previewDevice == PreviewDeviceType.mobile ? 18 : 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hours,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(bool isDark) {
    final whatsapp = _get('contact.whatsapp_number');
    final instagram = _get('contact.instagram_handle');

    return Container(
      key: const ValueKey('preview_footer_section'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      color: isDark ? const Color(0xFF090D16) : const Color(0xFF0F172A),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              if (whatsapp.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.phone_rounded,
                      color: Colors.white70,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      whatsapp,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              if (instagram.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white70,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      instagram,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '© Vila Chico Bento • Todos os direitos reservados',
            style: GoogleFonts.inter(fontSize: 11, color: Colors.white38),
          ),
        ],
      ),
    );
  }
}
