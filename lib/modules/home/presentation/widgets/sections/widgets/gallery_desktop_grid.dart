import 'package:flutter/material.dart';
import 'gallery_photo_card.dart';

/// Grid adaptativo e inteligente de fotos da galeria:
/// Suporta de 1 a N fotos sem nunca quebrar o layout nem deixar vazios
/// estranhos.
class GalleryDesktopGrid extends StatelessWidget {
  const GalleryDesktopGrid({
    required this.images,
    this.crossAxisCount = 3,
    super.key,
  });

  final List<String> images;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();
    // Caso 1 foto: Destaque fotográfico imponente centralizado
    if (images.length == 1) {
      return Center(
        child: SizedBox(
          width: 700,
          height: 420,
          child: GalleryPhotoCard(
            imageUrl: images.first,
            index: 1, // coxim central
          ),
        ),
      );
    }

    // Caso 2 fotos: 2 colunas amplas
    if (images.length == 2) {
      return Row(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.35,
              child: GalleryPhotoCard(imageUrl: images[0]),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.35,
              child: GalleryPhotoCard(imageUrl: images[1], index: 2),
            ),
          ),
        ],
      );
    }

    // Caso 3 fotos: 3 colunas com proporção equilibrada (não achatada)
    if (images.length == 3) {
      return Row(
        children: [
          for (int i = 0; i < 3; i++) ...[
            if (i > 0) const SizedBox(width: 20),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.22,
                child: GalleryPhotoCard(
                  imageUrl: images[i],
                  index: i,
                ),
              ),
            ),
          ],
        ],
      );
    }

    // Caso 4 fotos: Grid equilibrado 2x2
    if (images.length == 4) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.45,
        ),
        itemBuilder: (context, index) {
          return GalleryPhotoCard(
            imageUrl: images[index],
            index: index,
          );
        },
      );
    }

    // Caso 5 ou mais fotos: Grid rico em 3 colunas
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: crossAxisCount >= 3 ? 1.25 : 1.35,
      ),
      itemBuilder: (context, index) {
        return GalleryPhotoCard(
          imageUrl: images[index],
          index: index,
        );
      },
    );
  }
}
