import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/content_bundle.dart';
import '../../../domain/vila_chico_bento_default_content.dart';
import '../admin_workspace_state.dart';

/// Live preview pane rendering the site sections in real time based on
/// the operator's working draft [bundle].
class AdminLivePreview extends StatelessWidget {
  const AdminLivePreview({
    required this.bundle,
    required this.previewDevice,
    super.key,
  });

  final ContentBundle bundle;
  final PreviewDeviceType previewDevice;

  String _get(String key) {
    return bundle.getString(
      key,
      fallback: VilaChicoBentoDefaultContent.bundle.getString(
        key,
        fallback: '',
      ),
    );
  }

  List<String> _getGalleryImages() {
    return bundle.getStringList(
      'gallery.images',
      fallback: VilaChicoBentoDefaultContent.bundle.getStringList(
        'gallery.images',
        fallback: const [],
      ),
    );
  }

  List<Map<String, dynamic>> _getServices() {
    return bundle.getListMap(
      'services.items',
      fallback: VilaChicoBentoDefaultContent.bundle.getListMap(
        'services.items',
        fallback: const [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Viewport dimensions based on selected simulated device
    double? maxWidth;
    double? deviceBorderRadius;
    EdgeInsets outerPadding = const EdgeInsets.all(16);

    switch (previewDevice) {
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

    final isConstrained = previewDevice != PreviewDeviceType.desktop;

    final Widget previewContent = Container(
      decoration: BoxDecoration(
        color: AppColors.bgPrimary(isDark),
        borderRadius: BorderRadius.circular(deviceBorderRadius),
        border: isConstrained
            ? Border.all(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFCBD5E1),
                width: previewDevice == PreviewDeviceType.mobile ? 8 : 6,
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
                _buildHeroSection(isDark),
                _buildAboutSection(isDark),
                _buildServicesSection(isDark),
                _buildGallerySection(isDark),
                _buildLocationSection(isDark),
                _buildFooterSection(isDark),
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
                  ? Image.network(
                      bannerImage,
                      fit: BoxFit.cover,
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
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: previewDevice == PreviewDeviceType.mobile
                        ? 22
                        : 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: previewDevice == PreviewDeviceType.mobile
                        ? 13
                        : 15,
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

  Widget _buildAboutSection(bool isDark) {
    final badge = _get('about.badge');
    final title = _get('about.title');
    final desc1 = _get('about.description_1');
    final desc2 = _get('about.description_2');

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
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: previewDevice == PreviewDeviceType.mobile ? 18 : 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 14),
          if (desc1.isNotEmpty)
            Text(
              desc1,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary(isDark),
                height: 1.6,
              ),
            ),
          if (desc2.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              desc2,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary(isDark),
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildServicesSection(bool isDark) {
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
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: previewDevice == PreviewDeviceType.mobile ? 18 : 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(isDark),
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary(isDark),
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
                color: AppColors.bgCard(isDark),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.borderSubtle(isDark),
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
                            color: AppColors.textPrimary(isDark),
                          ),
                        ),
                        if (cardDesc.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            cardDesc,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary(isDark),
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

  Widget _buildGallerySection(bool isDark) {
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
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: previewDevice == PreviewDeviceType.mobile ? 18 : 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 18),
          if (images.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    previewDevice == PreviewDeviceType.mobile ? 2 : 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final url = images[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.bgCard(isDark),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            )
          else
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgCard(isDark),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                'Nenhuma foto na galeria',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary(isDark),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(bool isDark) {
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
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: previewDevice == PreviewDeviceType.mobile ? 18 : 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(isDark),
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
                    color: AppColors.textSecondary(isDark),
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
                    color: AppColors.textSecondary(isDark),
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
