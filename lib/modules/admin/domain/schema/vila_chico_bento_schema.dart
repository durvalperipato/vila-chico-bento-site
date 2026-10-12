import 'package:vila_chico_bento_site/modules/home/domain/constants/content_keys.dart';
import 'admin_field.dart';
import 'admin_section_group.dart';
import 'admin_section_icon.dart';
import 'site_schema.dart';

/// Concrete schema configuration for the Vila Chico Bento website.
class VilaChicoBentoSchema {
  VilaChicoBentoSchema._();

  static const String siteId = 'vila-chico-bento';

  static final SiteSchema schema = SiteSchema(
    siteId: siteId,
    sections: [
      AdminSectionGroup(
        id: 'hero',
        title: 'Seção Inicial (Hero)',
        icon: AdminSectionIcon.stars,
        fields: [
          AdminField.text(
            key: HeroKeys.badge,
            label: 'Badge Superior',
            maxLength: 50,
          ),
          AdminField.text(
            key: HeroKeys.title,
            label: 'Título Principal',
            maxLength: 80,
            required: true,
          ),
          AdminField.text(
            key: HeroKeys.subtitle,
            label: 'Subtítulo',
            maxLength: 180,
            maxLines: 3,
            required: true,
          ),
          AdminField.text(
            key: HeroKeys.ctaWhatsapp,
            label: 'Texto do Botão WhatsApp',
            maxLength: 40,
          ),
          AdminField.image(
            key: HeroKeys.bannerImage,
            label: 'Fotografia Panorâmica de Fundo',
            maxSizeMB: 3.0,
          ),
        ],
      ),
      AdminSectionGroup(
        id: 'about',
        title: 'Sobre Nós & Cuidados',
        icon: AdminSectionIcon.pets,
        fields: [
          AdminField.text(
            key: AboutKeys.badge,
            label: 'Badge',
            maxLength: 40,
          ),
          AdminField.text(
            key: AboutKeys.title,
            label: 'Título da Seção',
            maxLength: 80,
            required: true,
          ),
          AdminField.text(
            key: AboutKeys.description,
            label: 'Conteúdo',
            maxLines: 6,
            maxLength: 700,
            required: true,
          ),
        ],
      ),
      AdminSectionGroup(
        id: 'services',
        title: 'Serviços Oferecidos',
        icon: AdminSectionIcon.category,
        fields: [
          AdminField.text(
            key: ServicesKeys.badge,
            label: 'Badge',
            maxLength: 40,
          ),
          AdminField.text(
            key: ServicesKeys.title,
            label: 'Título de Serviços',
            maxLength: 80,
            required: true,
          ),
          AdminField.text(
            key: ServicesKeys.subtitle,
            label: 'Subtítulo de Serviços',
            maxLength: 180,
            maxLines: 2,
            required: true,
          ),
          AdminField.list(
            key: ServicesKeys.items,
            label: 'Cards de Serviços',
            maxItems: 6,
            itemFields: [
              AdminField.text(
                key: 'title',
                label: 'Nome do Serviço',
                maxLength: 40,
                required: true,
              ),
              AdminField.text(
                key: 'description',
                label: 'Descrição',
                maxLength: 160,
                maxLines: 2,
              ),
            ],
          ),
        ],
      ),
      AdminSectionGroup(
        id: 'gallery',
        title: 'Galeria de Fotos',
        icon: AdminSectionIcon.photoLibrary,
        fields: [
          AdminField.text(
            key: GalleryKeys.badge,
            label: 'Badge',
            maxLength: 40,
          ),
          AdminField.text(
            key: GalleryKeys.title,
            label: 'Título da Galeria',
            maxLength: 80,
            required: true,
          ),
          AdminField.gallery(
            key: GalleryKeys.images,
            label: 'Fotos do Espaço e Cães',
          ),
        ],
      ),
      AdminSectionGroup(
        id: 'location',
        title: 'Localização & Horários',
        icon: AdminSectionIcon.location,
        fields: [
          AdminField.text(
            key: LocationKeys.badge,
            label: 'Badge',
            maxLength: 40,
          ),
          AdminField.text(
            key: LocationKeys.title,
            label: 'Título Localização',
            maxLength: 80,
            required: true,
          ),
          AdminField.text(
            key: LocationKeys.address,
            label: 'Endereço Completo',
            maxLength: 140,
            maxLines: 2,
            required: true,
          ),
          AdminField.text(
            key: LocationKeys.hours,
            label: 'Horário de Funcionamento',
            maxLength: 80,
            required: true,
          ),
        ],
      ),
      AdminSectionGroup(
        id: 'contact',
        title: 'Contato & Redes',
        icon: AdminSectionIcon.contactPhone,
        fields: [
          AdminField.text(
            key: ContactKeys.whatsappNumber,
            label: 'Número WhatsApp Oficial',
            maxLength: 25,
            required: true,
          ),
          AdminField.text(
            key: ContactKeys.instagramHandle,
            label: 'Usuário do Instagram',
            maxLength: 40,
            required: true,
          ),
        ],
      ),
    ],
  );
}
