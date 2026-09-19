import 'admin_field.dart';
import 'admin_section_group.dart';

/// Represents the complete schema contract for a website.
class SiteSchema {
  final String siteId;
  final List<AdminSectionGroup> sections;

  const SiteSchema({
    required this.siteId,
    required this.sections,
  });

  /// Retrieves a section group by its unique ID.
  AdminSectionGroup? getSection(String id) {
    for (final section in sections) {
      if (section.id == id) return section;
    }
    return null;
  }

  /// Searches for a field across all registered sections.
  AdminField? findField(String key) {
    for (final section in sections) {
      final field = section.findField(key);
      if (field != null) return field;
    }
    return null;
  }

  /// Returns all registered content keys across all sections.
  List<String> get allKeys {
    final keys = <String>[];
    for (final section in sections) {
      for (final field in section.fields) {
        keys.add(field.key);
      }
    }
    return List.unmodifiable(keys);
  }
}
