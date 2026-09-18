import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/constants/app_assets.dart';
import 'package:vila_chico_bento_site/core/extensions/build_context_extension.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'package:vila_chico_bento_site/core/theme/app_typography.dart';
import 'package:vila_chico_bento_site/core/widgets/meandering_paw_trail.dart';
import 'package:vila_chico_bento_site/core/widgets/responsive_container.dart';
import 'package:vila_chico_bento_site/core/widgets/section_tag.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';

class GallerySection extends StatelessWidget {
  const GallerySection({required this.controller, super.key});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = controller.isDarkMode;
    final isDesktop = NanoDeviceType.isDesktop(context);
    final isMobile = NanoDeviceType.isMobile(context);

    final crossAxisCount =
        isDesktop ? 3 : (NanoDeviceType.isTablet(context) ? 2 : 1);

    final screenHeight = MediaQuery.sizeOf(context).height;
    final minHeight =
        isDesktop ? (screenHeight - 86).clamp(600.0, 1400.0) : 0.0;

    return Container(
      key: controller.galleryKey,
      constraints: isDesktop ? BoxConstraints(minHeight: minHeight) : null,
      alignment: Alignment.center,
      color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Rastro Contínuo de Patinhas: continua de Serviços (0.90) e desce até base esquerda (0.10)
          Positioned.fill(
            child: MeanderingPawTrail(
              start: const Offset(0.90, 0.0),
              control1: const Offset(0.90, 0.25),
              control2: const Offset(0.10, 0.75),
              end: const Offset(0.10, 1.0),
              pawCount: isMobile ? 8 : 14,
              baseSize: 32.0,
              opacity: isDark ? 0.38 : 0.50,
              color: AppColors.pawTrail,
              startWithRightFoot: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 44 : 28,
            ),
            child: ResponsiveContainer(
              child: Column(
                children: [
                  SectionTag(
                    text: l10n.galleryBadge,
                    icon: Icons.photo_camera_rounded,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.galleryTitle,
                    textAlign: TextAlign.center,
                    style: isDesktop
                        ? AppTypography.displayMedium(
                            color: AppColors.textPrimary(isDark),
                          ).copyWith(fontSize: 32)
                        : AppTypography.displaySmall(
                            color: AppColors.textPrimary(isDark),
                          ),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Text(
                      l10n.gallerySubtitle,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge(
                        color: AppColors.textSecondary(isDark),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Grid no Desktop / Carrossel Horizontal no Mobile
                  if (isDesktop)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: AppAssets.galleryImages.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        childAspectRatio: isDesktop ? 1.75 : 1.4,
                      ),
                      itemBuilder: (context, index) {
                        final imageUrl = AppAssets.galleryImages[index];
                        return _GalleryPhotoCard(
                          imageUrl: imageUrl,
                          isDark: isDark,
                        );
                      },
                    )
                  else
                    _GalleryHorizontalCarousel(
                      images: AppAssets.galleryImages,
                      isDark: isDark,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryHorizontalCarousel extends StatelessWidget {
  const _GalleryHorizontalCarousel({
    required this.images,
    required this.isDark,
  });

  final List<String> images;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: images.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final imageUrl = images[index];
          return SizedBox(
            width: 320,
            child: _GalleryPhotoCard(
              imageUrl: imageUrl,
              isDark: isDark,
            ),
          );
        },
      ),
    );
  }
}

class _GalleryPhotoCard extends StatefulWidget {
  const _GalleryPhotoCard({
    required this.imageUrl,
    required this.isDark,
  });

  final String imageUrl;
  final bool isDark;

  @override
  State<_GalleryPhotoCard> createState() => _GalleryPhotoCardState();
}

class _GalleryPhotoCardState extends State<_GalleryPhotoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.6)
                : AppColors.borderSubtle(widget.isDark),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.25)
                  : AppColors.cardShadow(widget.isDark),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return NanoSkeleton.box(
                borderRadius: BorderRadius.circular(16),
                color: widget.isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
                highlightColor: widget.isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFF1F5F9),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: widget.isDark
                    ? AppColors.darkBgCard
                    : AppColors.lightBgSurface,
                child: Center(
                  child: Icon(
                    Icons.pets_rounded,
                    size: 32,
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
