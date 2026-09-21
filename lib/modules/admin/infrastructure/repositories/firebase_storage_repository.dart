import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/repositories/storage_repository.dart';

/// Firebase Storage implementation of [StorageRepository].
class FirebaseStorageRepository implements StorageRepository {
  FirebaseStorageRepository({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  @override
  Future<String> uploadImage({
    required String path,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final ref = _storage.ref(path);
    final metadata = SettableMetadata(
      contentType: contentType,
      cacheControl: 'public, max-age=31536000',
    );
    final uploadTask = await ref.putData(bytes, metadata);
    return await uploadTask.ref.getDownloadURL();
  }

  @override
  Future<void> deleteImage(String urlOrPath) async {
    Reference ref;
    if (urlOrPath.startsWith('http://') || urlOrPath.startsWith('https://')) {
      ref = _storage.refFromURL(urlOrPath);
    } else {
      ref = _storage.ref(urlOrPath);
    }
    await ref.delete();
  }
}
