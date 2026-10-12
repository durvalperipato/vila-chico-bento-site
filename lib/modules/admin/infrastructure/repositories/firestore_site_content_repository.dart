import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nano_core/nano_core.dart';
import '../../domain/repositories/site_content_repository.dart';

/// Concrete Firestore implementation of [SiteContentRepository].
class FirestoreSiteContentRepository implements SiteContentRepository {
  FirestoreSiteContentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _siteDoc(String siteId) {
    return _firestore.collection('sites').doc(siteId);
  }

  DocumentReference<Map<String, dynamic>> _draftDoc(String siteId) {
    return _siteDoc(siteId).collection('drafts').doc('current');
  }

  @override
  Future<Map<String, dynamic>> getContent(String siteId) async {
    try {
      final snapshot = await _siteDoc(siteId).get();
      if (snapshot.exists && snapshot.data() != null) {
        return Map<String, dynamic>.from(snapshot.data()!);
      }
      return <String, dynamic>{};
    } catch (e, stack) {
      NanoLogger.warning(
        'Failed to fetch Firestore content for site "$siteId", using fallback.',
        error: e,
        stackTrace: stack,
      );
      return <String, dynamic>{};
    }
  }

  @override
  Stream<Map<String, dynamic>> watchContent(String siteId) {
    return _siteDoc(siteId).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return Map<String, dynamic>.from(snapshot.data()!);
      }
      return <String, dynamic>{};
    }).handleError((error, stackTrace) {
      NanoLogger.warning(
        'Error in watchContent stream for site "$siteId", '
        'falling back to empty stream.',
        error: error,
        stackTrace: stackTrace,
      );
      return <String, dynamic>{};
    });
  }

  @override
  Future<void> saveContent(String siteId, Map<String, dynamic> data) async {
    final payload = Map<String, dynamic>.from(data);
    payload['updated_at'] = FieldValue.serverTimestamp();

    await _siteDoc(siteId)
        .set(payload, SetOptions(merge: true))
        .timeout(const Duration(seconds: 4));
  }

  @override
  Future<void> saveDraft(String siteId, Map<String, dynamic> data) async {
    final payload = Map<String, dynamic>.from(data);
    payload['updated_at'] = FieldValue.serverTimestamp();

    await _draftDoc(siteId)
        .set(payload, SetOptions(merge: true))
        .timeout(const Duration(seconds: 4));
  }

  @override
  Future<Map<String, dynamic>?> getDraft(String siteId) async {
    try {
      final snapshot =
          await _draftDoc(siteId).get().timeout(const Duration(seconds: 4));
      if (snapshot.exists && snapshot.data() != null) {
        return Map<String, dynamic>.from(snapshot.data()!);
      }
      return null;
    } catch (e, stack) {
      NanoLogger.warning(
        'Failed to fetch Firestore draft for site "$siteId".',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }
}
