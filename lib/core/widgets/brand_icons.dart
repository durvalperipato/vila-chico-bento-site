import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Ícones autênticos e de alta precisão baseados no FontAwesome oficial
class BrandIcons {
  BrandIcons._();

  /// Ícone oficial do WhatsApp
  static Widget whatsapp({double size = 20, Color? color}) {
    return FaIcon(
      FontAwesomeIcons.whatsapp,
      size: size,
      color: color ?? const Color(0xFF25D366),
    );
  }

  /// Ícone oficial do Instagram
  static Widget instagram({double size = 20, Color? color}) {
    return FaIcon(
      FontAwesomeIcons.instagram,
      size: size,
      color: color ?? const Color(0xFFE1306C),
    );
  }

  /// Ícone oficial do Waze
  static Widget waze({double size = 20, Color? color}) {
    return FaIcon(
      FontAwesomeIcons.waze,
      size: size,
      color: color ?? const Color(0xFF33CCFF),
    );
  }

  /// Ícone oficial do Google Maps
  static Widget googleMaps({double size = 20, Color? color}) {
    return FaIcon(
      FontAwesomeIcons.mapLocationDot,
      size: size,
      color: color ?? const Color(0xFF4285F4),
    );
  }
}
