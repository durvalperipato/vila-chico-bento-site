/// Contract for fetching and persisting site content in Firestore.
abstract class SiteContentRepository {
  /// Fetches published content for a given [siteId].
  Future<Map<String, dynamic>> getContent(String siteId);

  /// Streams real-time published content updates for a given [siteId].
  Stream<Map<String, dynamic>> watchContent(String siteId);

  /// Persists published content for a given [siteId].
  Future<void> saveContent(String siteId, Map<String, dynamic> data);

  /// Saves an uncommitted working draft for a given [siteId].
  Future<void> saveDraft(String siteId, Map<String, dynamic> data);

  /// Fetches an existing working draft, if one exists.
  Future<Map<String, dynamic>?> getDraft(String siteId);
}
