import 'dart:typed_data';

/// Contract for media and image storage operations.
abstract class StorageRepository {
  /// Uploads raw image bytes to a target [path] with specified [contentType].
  /// Returns the publicly accessible download URL.
  Future<String> uploadImage({
    required String path,
    required Uint8List bytes,
    required String contentType,
  });

  /// Deletes an image given its [urlOrPath].
  Future<void> deleteImage(String urlOrPath);
}
