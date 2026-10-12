import 'dart:convert';
import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

final Map<String, ImageProvider> _imageProviderCache = {};

/// Extension on [String] to cleanly resolve any image path
/// (HTTP URL, Base64 Data URI, or asset) into a native Flutter [ImageProvider].
extension ImageProviderExtension on String {
  ImageProvider toImageProvider() {
    final trimmed = trim();
    if (trimmed.isEmpty) {
      return const AssetImage(AppAssets.logo);
    }

    final cached = _imageProviderCache[trimmed];
    if (cached != null) {
      return cached;
    }

    final ImageProvider provider;
    if (trimmed.startsWith('data:image')) {
      final commaIndex = trimmed.indexOf(',');
      final base64Data =
          commaIndex != -1 ? trimmed.substring(commaIndex + 1) : trimmed;
      provider = MemoryImage(base64Decode(base64Data));
    } else if (trimmed.startsWith('assets/')) {
      provider = AssetImage(trimmed);
    } else {
      provider = NetworkImage(trimmed);
    }

    if (_imageProviderCache.length >= 60) {
      _imageProviderCache.remove(_imageProviderCache.keys.first);
    }
    _imageProviderCache[trimmed] = provider;
    return provider;
  }
}
