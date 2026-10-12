import 'package:flutter/material.dart';
import 'gallery_photo_card.dart';

/// Carrossel horizontal de fotos para viewports compactas (mobile).
class GalleryHorizontalCarousel extends StatelessWidget {
  const GalleryHorizontalCarousel({
    required this.images,
    super.key,
  });

  final List<String> images;

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
            width: 280,
            child: GalleryPhotoCard(
              imageUrl: imageUrl,
            ),
          );
        },
      ),
    );
  }
}
