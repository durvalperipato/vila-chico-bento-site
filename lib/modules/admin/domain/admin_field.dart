import 'admin_field_type.dart';

/// Immutable domain model representing a single configurable field in the schema.
class AdminField {
  final String key;
  final String label;
  final AdminFieldType type;
  final bool required;
  final int? maxLength;
  final int maxLines;
  final double? maxSizeMB;
  final List<String> allowedExtensions;
  final int? maxItems;
  final List<AdminField> itemFields;

  const AdminField({
    required this.key,
    required this.label,
    required this.type,
    this.required = false,
    this.maxLength,
    this.maxLines = 1,
    this.maxSizeMB,
    this.allowedExtensions = const ['jpg', 'jpeg', 'png', 'webp'],
    this.maxItems,
    this.itemFields = const [],
  });

  /// Factory constructor for text inputs (headlines, descriptions, phone numbers).
  factory AdminField.text({
    required String key,
    required String label,
    int? maxLength,
    int maxLines = 1,
    bool required = false,
  }) {
    return AdminField(
      key: key,
      label: label,
      type: AdminFieldType.text,
      maxLength: maxLength,
      maxLines: maxLines,
      required: required,
    );
  }

  /// Factory constructor for single image upload fields.
  factory AdminField.image({
    required String key,
    required String label,
    double maxSizeMB = 2.0,
    List<String> allowedExtensions = const ['jpg', 'jpeg', 'png', 'webp'],
    bool required = false,
  }) {
    return AdminField(
      key: key,
      label: label,
      type: AdminFieldType.image,
      maxSizeMB: maxSizeMB,
      allowedExtensions: allowedExtensions,
      required: required,
    );
  }

  /// Factory constructor for multi-image gallery fields.
  factory AdminField.gallery({
    required String key,
    required String label,
    int maxItems = 10,
    double maxSizeMB = 2.0,
    List<String> allowedExtensions = const ['jpg', 'jpeg', 'png', 'webp'],
  }) {
    return AdminField(
      key: key,
      label: label,
      type: AdminFieldType.gallery,
      maxItems: maxItems,
      maxSizeMB: maxSizeMB,
      allowedExtensions: allowedExtensions,
      required: false,
    );
  }

  /// Factory constructor for repeating item lists (e.g. services, cards).
  factory AdminField.list({
    required String key,
    required String label,
    required List<AdminField> itemFields,
    int maxItems = 10,
  }) {
    return AdminField(
      key: key,
      label: label,
      type: AdminFieldType.list,
      itemFields: itemFields,
      maxItems: maxItems,
    );
  }

  /// Validates a candidate value against this field's business rules.
  String? validate(dynamic value) {
    if (required) {
      if (value == null) return '$label is required.';
      if (value is String && value.trim().isEmpty) return '$label cannot be empty.';
      if (value is List && value.isEmpty) return '$label requires at least one item.';
    }

    if (value == null) return null;

    if (type == AdminFieldType.text && value is String) {
      if (maxLength != null && value.length > maxLength!) {
        return '$label cannot exceed $maxLength characters (currently ${value.length}).';
      }
    }

    if (type == AdminFieldType.gallery && value is List) {
      if (maxItems != null && value.length > maxItems!) {
        return '$label cannot contain more than $maxItems images.';
      }
    }

    if (type == AdminFieldType.list && value is List) {
      if (maxItems != null && value.length > maxItems!) {
        return '$label cannot contain more than $maxItems items.';
      }
    }

    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminField &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          label == other.label &&
          type == other.type &&
          required == other.required &&
          maxLength == other.maxLength &&
          maxLines == other.maxLines &&
          maxSizeMB == other.maxSizeMB &&
          maxItems == other.maxItems;

  @override
  int get hashCode =>
      key.hashCode ^
      label.hashCode ^
      type.hashCode ^
      required.hashCode ^
      maxLength.hashCode ^
      maxLines.hashCode ^
      maxSizeMB.hashCode ^
      maxItems.hashCode;
}
