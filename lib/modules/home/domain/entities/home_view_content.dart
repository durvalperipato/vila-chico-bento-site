import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../admin/domain/entities/content_bundle.dart';
import '../constants/content_keys.dart';

/// Modelo fortemente tipado para a seção Hero.
class HeroViewContent {
  const HeroViewContent({
    required this.mainImage,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.ctaWhatsappText,
    required this.ctaServicesText,
    this.bannerAlignmentY = 0.0,
  });

  factory HeroViewContent.fromBundle(ContentBundle bundle) {
    final rawBadge = bundle.getString(HeroKeys.badge);
    final bannerAlignmentY = bundle.getDouble(
      HeroKeys.bannerAlignmentY,
      fallback: bundle.getDouble(HeroKeys.bannerAlignmentYLegacy),
    );

    final mainImage = bundle.getString(
      HeroKeys.bannerImage,
      fallback: bundle.getString(HeroKeys.mainImage),
    );

    return HeroViewContent(
      mainImage: mainImage,
      bannerAlignmentY: bannerAlignmentY,
      badge: rawBadge.replaceAll('🐾 ', ''),
      title: bundle.getString(HeroKeys.title),
      subtitle: bundle.getString(HeroKeys.subtitle),
      ctaWhatsappText: bundle.getString(
        HeroKeys.ctaWhatsapp,
        fallback: bundle.getString(HeroKeys.ctaPrimary),
      ),
      ctaServicesText: bundle.getString(HeroKeys.ctaSecondary),
    );
  }

  final String mainImage;
  final double bannerAlignmentY;
  final String badge;
  final String title;
  final String subtitle;
  final String ctaWhatsappText;
  final String ctaServicesText;
}

/// Modelo fortemente tipado para a seção Sobre (About).
class AboutViewContent {
  const AboutViewContent({
    required this.badge,
    required this.title,
    required this.description,
    String? description1,
    String? description2,
  });

  factory AboutViewContent.fromBundle(ContentBundle bundle) {
    final desc = bundle.getString(
      AboutKeys.description,
      fallback: bundle.getString(AboutKeys.descriptionLegacy),
    );

    return AboutViewContent(
      badge: bundle.getString(AboutKeys.badge),
      title: bundle.getString(AboutKeys.title),
      description: desc,
    );
  }

  final String badge;
  final String title;
  final String description;

  /// Retained for backwards compatibility if needed
  String get description1 => description;
  String get description2 => '';
}

/// Item tipado de serviço.
class ServiceItemContent {
  const ServiceItemContent({
    required this.title,
    required this.description,
    required this.badge,
    required this.icon,
    required this.accentColor,
    required this.whatsappMessage,
  });

  final String title;
  final String description;
  final String badge;
  final IconData icon;
  final Color accentColor;
  final String whatsappMessage;
}

/// Modelo fortemente tipado para a seção Serviços.
class ServicesViewContent {
  const ServicesViewContent({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.items,
  });

  factory ServicesViewContent.fromBundle(ContentBundle bundle) {
    final rawList = bundle.getListMap(ServicesKeys.items);
    const defaultIcons = [
      Icons.wb_sunny_rounded,
      Icons.night_shelter_rounded,
      Icons.handshake_rounded,
      Icons.schedule_rounded,
    ];
    const defaultColors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accentGreen,
      Color(0xFF8B5CF6),
    ];
    const defaultBadges = [
      'Mais Procurado',
      'Sem Gaiolas',
      'Cuidado & Segurança',
      'Bem-Estar Total',
    ];

    final items = rawList.asMap().entries.map((entry) {
      final index = entry.key;
      final map = entry.value;
      final title = (map['title'] as String?) ?? '';
      final desc = (map['description'] as String?) ?? '';
      final badge = (map['badge'] as String?) ??
          defaultBadges[index % defaultBadges.length];
      final icon = defaultIcons[index % defaultIcons.length];
      final color = defaultColors[index % defaultColors.length];

      return ServiceItemContent(
        title: title,
        description: desc,
        badge: badge,
        icon: icon,
        accentColor: color,
        whatsappMessage: 'Olá! Gostaria de saber mais sobre o serviço de '
            '"$title" na Vila Chico Bento!',
      );
    }).toList();

    return ServicesViewContent(
      badge: bundle.getString(ServicesKeys.badge),
      title: bundle.getString(ServicesKeys.title),
      subtitle: bundle.getString(ServicesKeys.subtitle),
      items: items,
    );
  }

  final String badge;
  final String title;
  final String subtitle;
  final List<ServiceItemContent> items;
}

/// Modelo fortemente tipado para a Galeria de Fotos.
class GalleryViewContent {
  const GalleryViewContent({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.images,
  });

  factory GalleryViewContent.fromBundle(ContentBundle bundle) {
    return GalleryViewContent(
      badge: bundle.getString(GalleryKeys.badge),
      title: bundle.getString(GalleryKeys.title),
      subtitle: bundle.getString(GalleryKeys.subtitle),
      images: bundle.getStringList(GalleryKeys.images),
    );
  }

  final String badge;
  final String title;
  final String subtitle;
  final List<String> images;
}

/// Modelo fortemente tipado para a seção Localização.
class LocationViewContent {
  const LocationViewContent({
    required this.badge,
    required this.title,
    required this.address,
    required this.hours,
    required this.mapEmbedUrl,
  });

  factory LocationViewContent.fromBundle(ContentBundle bundle) {
    return LocationViewContent(
      badge: bundle.getString(LocationKeys.badge),
      title: bundle.getString(LocationKeys.title),
      address: bundle.getString(LocationKeys.address),
      hours: bundle.getString(LocationKeys.hours),
      mapEmbedUrl: AppConstants.googleMapsEmbedUrl,
    );
  }

  final String badge;
  final String title;
  final String address;
  final String hours;
  final String mapEmbedUrl;
}

/// Modelo fortemente tipado para a seção Contato / CTA.
class ContactViewContent {
  const ContactViewContent({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.whatsappNumber,
    required this.instagramHandle,
  });

  factory ContactViewContent.fromBundle(ContentBundle bundle) {
    return ContactViewContent(
      badge: bundle.getString(ContactKeys.badge),
      title: bundle.getString(ContactKeys.title),
      subtitle: bundle.getString(ContactKeys.subtitle),
      whatsappNumber: bundle.getString(ContactKeys.whatsappNumber),
      instagramHandle: bundle.getString(ContactKeys.instagramHandle),
    );
  }

  final String badge;
  final String title;
  final String subtitle;
  final String whatsappNumber;
  final String instagramHandle;
}

/// Modelo fortemente tipado para o Rodapé (Footer).
class FooterViewContent {
  const FooterViewContent({
    required this.aboutText,
    required this.phone,
    required this.instagram,
    required this.address,
    required this.hours,
  });

  factory FooterViewContent.fromBundle(ContentBundle bundle) {
    return FooterViewContent(
      aboutText: bundle.getString(FooterKeys.aboutText),
      phone: bundle.getString(ContactKeys.whatsappNumber),
      instagram: bundle.getString(ContactKeys.instagramHandle),
      address: bundle.getString(LocationKeys.address),
      hours: bundle.getString(LocationKeys.hours),
    );
  }

  final String aboutText;
  final String phone;
  final String instagram;
  final String address;
  final String hours;
}
