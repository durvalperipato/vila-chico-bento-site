/// Strongly-typed canonical key definitions for site content sections.
/// Avoids magic strings and ensures compiler safety across CMS and landing
/// page.
library;

abstract final class HeroKeys {
  static const badge = 'hero.badge';
  static const title = 'hero.title';
  static const subtitle = 'hero.subtitle';
  static const mainImage = 'hero.main_image';
  static const bannerImage = 'hero.banner_image';
  static const bannerAlignmentY = 'hero.banner_image_alignment_y';
  static const bannerAlignmentYLegacy = 'hero.banner_alignment_y';
  static const ctaWhatsapp = 'hero.cta_whatsapp_text';
  static const ctaPrimary = 'hero.cta_primary';
  static const ctaSecondary = 'hero.cta_secondary';
  static const highlights = 'hero.highlights';
}

abstract final class AboutKeys {
  static const badge = 'about.badge';
  static const title = 'about.title';
  static const description = 'about.description';
  static const descriptionLegacy = 'about.description_1';
  static const image = 'about.image';
  static const pillars = 'about.pillars';
}

abstract final class ServicesKeys {
  static const badge = 'services.badge';
  static const title = 'services.title';
  static const subtitle = 'services.subtitle';
  static const items = 'services.items';
}

abstract final class GalleryKeys {
  static const badge = 'gallery.badge';
  static const title = 'gallery.title';
  static const subtitle = 'gallery.subtitle';
  static const images = 'gallery.images';
}

abstract final class LocationKeys {
  static const badge = 'location.badge';
  static const title = 'location.title';
  static const address = 'location.address';
  static const hours = 'location.hours';
}

abstract final class ContactKeys {
  static const badge = 'contact.badge';
  static const title = 'contact.title';
  static const subtitle = 'contact.subtitle';
  static const whatsappNumber = 'contact.whatsapp_number';
  static const instagramHandle = 'contact.instagram_handle';
}

abstract final class FooterKeys {
  static const aboutText = 'footer.about_text';
}
