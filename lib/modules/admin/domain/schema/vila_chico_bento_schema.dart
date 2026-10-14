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
            required: true,
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
            required: true,
          ),
          AdminField.text(
            key: HeroKeys.ctaSecondary,
            label: 'Texto do Botão Secundário',
            maxLength: 40,
            required: true,
          ),
          AdminField.list(
            key: HeroKeys.highlights,
            label: 'Destaques de Confiança (Chips)',
            maxItems: 4,
            itemFields: [
              AdminField.text(
                key: 'label',
                label: 'Texto do Destaque',
                maxLength: 30,
                required: true,
              ),
            ],
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
            required: true,
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
          AdminField.image(
            key: AboutKeys.image,
            label: 'Foto de Destaque',
            maxSizeMB: 3.0,
          ),
          AdminField.list(
            key: AboutKeys.pillars,
            label: 'Pilares de Cuidado (Cards)',
            maxItems: 4,
            itemFields: [
              AdminField.text(
                key: 'title',
                label: 'Título do Pilar',
                maxLength: 40,
                required: true,
              ),
              AdminField.text(
                key: 'description',
                label: 'Descrição',
                maxLength: 160,
                maxLines: 2,
                required: true,
              ),
            ],
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
            required: true,
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
              AdminField.image(
                key: 'image',
                label: 'Foto do Serviço',
              ),
              AdminField.text(
                key: 'tag',
                label: 'Tag em Destaque (ex: Mais Procurado)',
                maxLength: 25,
              ),
              AdminField.text(
                key: 'action_text',
                label: 'Texto do Link de Ação (ex: Agendar Day Care)',
                maxLength: 30,
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
            required: true,
          ),
          AdminField.text(
            key: GalleryKeys.title,
            label: 'Título da Galeria',
            maxLength: 80,
            required: true,
          ),
          AdminField.text(
            key: GalleryKeys.subtitle,
            label: 'Subtítulo da Galeria',
            maxLength: 160,
            maxLines: 2,
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
            required: true,
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
            key: ContactKeys.badge,
            label: 'Badge',
            maxLength: 40,
            required: true,
          ),
          AdminField.text(
            key: ContactKeys.title,
            label: 'Título de Contato',
            maxLength: 80,
            required: true,
          ),
          AdminField.text(
            key: ContactKeys.subtitle,
            label: 'Subtítulo',
            maxLength: 200,
            maxLines: 3,
            required: true,
          ),
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
      AdminSectionGroup(
        id: 'footer',
        title: 'Rodapé (Footer)',
        icon: AdminSectionIcon.general,
        fields: [
          AdminField.text(
            key: FooterKeys.aboutText,
            label: 'Texto Sobre nós no Rodapé',
            maxLength: 350,
            maxLines: 4,
            required: true,
          ),
        ],
      ),
    ],
  );
}
