import 'package:flutter/foundation.dart';

/// Immutable container for site content supporting dot-separated key traversal
/// and resilient type-safe fallbacks.
class ContentBundle {
  const ContentBundle(Map<String, dynamic> data) : _data = data;

  const ContentBundle.empty() : _data = const {};

  factory ContentBundle.fromMap(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return const ContentBundle.empty();
    return ContentBundle(Map<String, dynamic>.unmodifiable(data));
  }
  final Map<String, dynamic> _data;

  Map<String, dynamic> toMap() => Map<String, dynamic>.from(_data);

  /// Resolves a value by key. Supports flat keys (`'hero.title'`) or
  /// nested maps (`{ 'hero': { 'title': '...' } }`).
  dynamic getRaw(String key) {
    // 1. Direct flat key lookup
    if (_data.containsKey(key)) {
      return _data[key];
    }

    // 2. Nested traversal for dot-separated keys
    final segments = key.split('.');
    dynamic current = _data;

    for (final segment in segments) {
      if (current is Map<String, dynamic> && current.containsKey(segment)) {
        current = current[segment];
      } else if (current is Map && current.containsKey(segment)) {
        current = current[segment];
      } else {
        return null;
      }
    }

    return current;
  }

  /// Returns a string value or the provided [fallback] if null, non-string,
  /// or empty. Defaults to empty string `''`.
  String getString(String key, {String fallback = ''}) {
    final val = getRaw(key);
    if (val is String && val.trim().isNotEmpty) return val;
    return fallback;
  }

  /// Returns the raw string value (even if empty) if present, or [fallback]
  /// only if null/missing. Defaults to empty string `''`.
  String getOptionalString(String key, {String fallback = ''}) {
    final val = getRaw(key);
    if (val is String) return val;
    return fallback;
  }

  /// Returns an int value or the provided [fallback]. Defaults to `0`.
  int getInt(String key, {int fallback = 0}) {
    final val = getRaw(key);
    if (val is int) return val;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? fallback;
    return fallback;
  }

  /// Returns a double value or the provided [fallback]. Defaults to `0.0`.
  double getDouble(String key, {double fallback = 0.0}) {
    final val = getRaw(key);
    if (val is double) return val;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? fallback;
    return fallback;
  }

  /// Returns a bool value or the provided [fallback]. Defaults to `false`.
  bool getBool(String key, {bool fallback = false}) {
    final val = getRaw(key);
    if (val is bool) return val;
    if (val is String) {
      final lower = val.toLowerCase().trim();
      if (lower == 'true' || lower == '1') return true;
      if (lower == 'false' || lower == '0') return false;
    }
    return fallback;
  }

  /// Returns a `List<String>` or the provided [fallback].
  /// Defaults to `const []`.
  List<String> getStringList(String key, {List<String> fallback = const []}) {
    final val = getRaw(key);
    if (val is List) {
      final result = val
          .map((e) => e?.toString())
          .whereType<String>()
          .where((e) => e.trim().isNotEmpty)
          .toList();
      if (result.isNotEmpty) return result;
    }
    return fallback;
  }

  /// Returns a `List<Map<String, dynamic>>` or the provided [fallback].
  /// Defaults to `const []`.
  List<Map<String, dynamic>> getListMap(
    String key, {
    List<Map<String, dynamic>> fallback = const [],
  }) {
    final val = getRaw(key);
    if (val is List) {
      final result = <Map<String, dynamic>>[];
      for (final item in val) {
        if (item is Map<String, dynamic>) {
          result.add(item);
        } else if (item is Map) {
          result.add(Map<String, dynamic>.from(item));
        }
      }
      if (result.isNotEmpty) return result;
    }
    return fallback;
  }

  /// Returns a new [ContentBundle] with [key] set to [value].
  ContentBundle set(String key, dynamic value) {
    final updated = Map<String, dynamic>.from(_data);
    updated[key] = value;
    return ContentBundle(updated);
  }

  /// Returns a new [ContentBundle] merging the provided [updates].
  ContentBundle copyWith(Map<String, dynamic> updates) {
    final updated = Map<String, dynamic>.from(_data)..addAll(updates);
    return ContentBundle(updated);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentBundle &&
          runtimeType == other.runtimeType &&
          mapEquals(_data, other._data);

  @override
  int get hashCode => Object.hashAll(_data.entries);
}
