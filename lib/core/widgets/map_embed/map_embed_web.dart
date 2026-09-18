// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

web.HTMLIFrameElement? _currentIFrame;
bool _viewFactoryRegistered = false;
const String _viewTypeId = 'google-maps-vila-chico-bento';

Widget buildMapEmbedView({
  required String mapUrl,
  required double width,
  required double height,
  required BorderRadius borderRadius,
  required bool isDark,
  required bool isInteractive,
}) {
  if (!_viewFactoryRegistered) {
    ui_web.platformViewRegistry.registerViewFactory(
      _viewTypeId,
      (int viewId) {
        final iframe =
            web.document.createElement('iframe') as web.HTMLIFrameElement;
        iframe.src = mapUrl;
        iframe.style.border = '0';
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        iframe.style.borderRadius = '24px';
        iframe.style.pointerEvents = 'none';
        iframe.setAttribute('loading', 'lazy');
        iframe.setAttribute('allowfullscreen', 'true');
        iframe.setAttribute('referrerpolicy', 'no-referrer-when-downgrade');
        _currentIFrame = iframe;
        return iframe;
      },
    );
    _viewFactoryRegistered = true;
  }

  // Atualiza dinamicamente o pointer-events do iframe
  _currentIFrame?.style.pointerEvents = isInteractive ? 'auto' : 'none';

  return ClipRRect(
    borderRadius: borderRadius,
    child: const HtmlElementView(
      viewType: _viewTypeId,
    ),
  );
}
