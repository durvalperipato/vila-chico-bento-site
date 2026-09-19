import 'admin_field.dart';

/// Represents a logical grouping of editable fields corresponding to a site section.
class AdminSectionGroup {
  final String id;
  final String title;
  final String icon;
  final List<AdminField> fields;

  const AdminSectionGroup({
    required this.id,
    required this.title,
    required this.icon,
    required this.fields,
  });

  /// Finds a field by its content key within this section group.
  AdminField? findField(String key) {
    for (final field in fields) {
      if (field.key == key) return field;
      for (final subField in field.itemFields) {
        if (subField.key == key) return subField;
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminSectionGroup &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          icon == other.icon;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ icon.hashCode;
}
