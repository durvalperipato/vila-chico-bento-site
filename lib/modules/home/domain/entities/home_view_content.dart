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
    this.highlights = const [],
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

    final rawHighlights = bundle.getListMap(HeroKeys.highlights);
    final highlights = rawHighlights
        .map((item) => item['label']?.toString() ?? '')
        .where((text) => text.isNotEmpty)
        .toList();

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
      highlights: highlights,
    );
  }

  final String mainImage;
  final double bannerAlignmentY;
  final String badge;
  final String title;
  final String subtitle;
  final String ctaWhatsappText;
  final String ctaServicesText;
  final List<String> highlights;

  String get badgeDisplay =>
      badge.isNotEmpty ? badge : '[ Badge Superior ]';
  String get titleDisplay =>
      title.isNotEmpty ? title : '[ Título Principal ]';
  String get subtitleDisplay =>
      subtitle.isNotEmpty ? subtitle : '[ Subtítulo da Seção ]';
  String get ctaWhatsappDisplay =>
      ctaWhatsappText.isNotEmpty ? ctaWhatsappText : '[ Agendar Visita ]';
  String get ctaServicesDisplay =>
      ctaServicesText.isNotEmpty ? ctaServicesText : '[ Conhecer Serviços ]';
}

/// Pilar de cuidado da seção Sobre.
class AboutViewPillar {
  const AboutViewPillar({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  String get titleDisplay => title.isNotEmpty ? title : '[ Título do Pilar ]';
  String get descriptionDisplay =>
      description.isNotEmpty ? description : '[ Descrição do Pilar ]';
}

/// Modelo fortemente tipado para a seção Sobre (About).
class AboutViewContent {
  const AboutViewContent({
    required this.badge,
    required this.title,
    required this.description,
    this.image = '',
    this.pillars = const [],
    String? description1,
    String? description2,
  });

  factory AboutViewContent.fromBundle(ContentBundle bundle) {
    final desc = bundle.getString(
      AboutKeys.description,
      fallback: bundle.getString(AboutKeys.descriptionLegacy),
    );

    final rawPillars = bundle.getListMap(AboutKeys.pillars);
    final pillars = rawPillars.map((p) {
      return AboutViewPillar(
        title: p['title']?.toString() ?? '',
        description: p['description']?.toString() ?? '',
      );
    }).toList();

    return AboutViewContent(
      badge: bundle.getString(AboutKeys.badge),
      title: bundle.getString(AboutKeys.title),
      description: desc,
      image: bundle.getString(AboutKeys.image),
      pillars: pillars,
    );
  }

  final String badge;
  final String title;
  final String description;
  final String image;
  final List<AboutViewPillar> pillars;

  String get badgeDisplay => badge.isNotEmpty ? badge : '[ SOBRE NÓS ]';
  String get titleDisplay =>
      title.isNotEmpty ? title : '[ Título da Seção ]';
  String get descriptionDisplay => description.isNotEmpty
      ? description
      : '[ Conteúdo sobre a creche e cuidados ]';
  String get imageDisplay => image;

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
    this.image = '',
    this.actionText = '',
  });

  final String title;
  final String description;
  final String badge;
  final IconData icon;
  final Color accentColor;
  final String whatsappMessage;
  final String image;
  final String actionText;
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
    final items = rawList.asMap().entries.map((entry) {
      final index = entry.key;
      final map = entry.value;
      final title = (map['title'] as String?) ?? '';
      final desc = (map['description'] as String?) ?? '';
      final badge = (map['tag'] as String?) ?? (map['badge'] as String?) ?? '';
      final image = (map['image'] as String?) ?? '';
      final actionText = (map['action_text'] as String?) ?? '';
      final icon = defaultIcons[index % defaultIcons.length];
      final color = defaultColors[index % defaultColors.length];

      return ServiceItemContent(
        title: title,
        description: desc,
        badge: badge,
        icon: icon,
        accentColor: color,
        image: image,
        actionText: actionText,
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

  String get badgeDisplay => badge.isNotEmpty ? badge : '[ SERVIÇOS ]';
  String get titleDisplay =>
      title.isNotEmpty ? title : '[ Nossos Serviços ]';
  String get subtitleDisplay =>
      subtitle.isNotEmpty ? subtitle : '[ Subtítulo de Serviços ]';
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

  String get badgeDisplay =>
      badge.isNotEmpty ? badge : '[ MOMENTOS FELIZES ]';
  String get titleDisplay =>
      title.isNotEmpty ? title : '[ Galeria de Fotos ]';
  String get subtitleDisplay => subtitle;
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

  String get badgeDisplay => badge.isNotEmpty ? badge : '[ LOCALIZAÇÃO ]';
  String get titleDisplay =>
      title.isNotEmpty ? title : '[ Onde Estamos & Horários ]';
  String get addressDisplay =>
      address.isNotEmpty ? address : '[ Endereço Completo ]';
  String get hoursDisplay =>
      hours.isNotEmpty ? hours : '[ Horário de Funcionamento ]';
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

  String get badgeDisplay => badge.isNotEmpty ? badge : '[ FALE CONOSCO ]';
  String get titleDisplay =>
      title.isNotEmpty ? title : '[ Título de Contato ]';
  String get subtitleDisplay =>
      subtitle.isNotEmpty ? subtitle : '[ Subtítulo de Contato ]';
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

  String get aboutTextDisplay =>
      aboutText.isNotEmpty ? aboutText : '[ Texto sobre nós no rodapé ]';
}
