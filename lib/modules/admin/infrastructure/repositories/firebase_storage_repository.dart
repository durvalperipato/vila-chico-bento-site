import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import '../../domain/repositories/storage_repository.dart';

/// Storage implementation that compresses images and stores them inline as
/// optimized Base64 Data URIs, bypassing the need for paid cloud bucket
/// storage.
class FirebaseStorageRepository implements StorageRepository {
  const FirebaseStorageRepository();

  @override
  Future<String> uploadImage({
    required String path,
    required Uint8List bytes,
    required String contentType,
  }) async {
    // 1. Try native engine codec (hardware-accelerated, async, zero UI freeze)
    try {
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: 800,
      );
      final frame = await codec.getNextFrame();
      final byteData = await frame.image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        final smallDecoded = img.decodePng(pngBytes);
        if (smallDecoded != null) {
          final jpgBytes = Uint8List.fromList(
            img.encodeJpg(smallDecoded, quality: 75),
          );
          final base64String = base64Encode(jpgBytes);
          return 'data:image/jpeg;base64,$base64String';
        }
        final base64String = base64Encode(pngBytes);
        return 'data:image/png;base64,$base64String';
      }
    } catch (_) {
      // Fallback to software decoder for test environments or raw buffers
    }

    // 2. Pure Dart fallback (used in unit tests / headless environments)
    final decodedImage = img.decodeImage(bytes);
    if (decodedImage == null) {
      final base64String = base64Encode(bytes);
      final mime = contentType.isNotEmpty ? contentType : 'image/jpeg';
      return 'data:$mime;base64,$base64String';
    }

    // 2. Resize maintaining aspect ratio (max 800px width/height)
    img.Image processedImage = decodedImage;
    const maxDimension = 800;
    if (decodedImage.width > maxDimension ||
        decodedImage.height > maxDimension) {
      if (decodedImage.width >= decodedImage.height) {
        processedImage = img.copyResize(decodedImage, width: maxDimension);
      } else {
        processedImage = img.copyResize(decodedImage, height: maxDimension);
      }
    }

    // 3. Compress to optimized JPEG (quality 75, typically 35-55 KB per photo)
    final compressedBytes = Uint8List.fromList(
      img.encodeJpg(processedImage, quality: 75),
    );
    final base64String = base64Encode(compressedBytes);

    return 'data:image/jpeg;base64,$base64String';
  }

  @override
  Future<void> deleteImage(String urlOrPath) async {
    // Inline Base64 Data URIs do not require remote bucket deletion.
  }
}
