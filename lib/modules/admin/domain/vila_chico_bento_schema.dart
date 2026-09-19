import 'admin_field.dart';
import 'admin_section_group.dart';
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
        icon: 'stars',
        fields: [
          AdminField.text(
            key: 'hero.badge',
            label: 'Badge Superior',
            maxLength: 50,
          ),
          AdminField.text(
            key: 'hero.title',
            label: 'Título Principal',
            maxLength: 80,
            required: true,
          ),
          AdminField.text(
            key: 'hero.subtitle',
            label: 'Subtítulo',
            maxLength: 180,
            maxLines: 3,
            required: true,
          ),
          AdminField.text(
            key: 'hero.cta_whatsapp_text',
            label: 'Texto do Botão WhatsApp',
            maxLength: 40,
          ),
          AdminField.image(
            key: 'hero.banner_image',
            label: 'Fotografia Panorâmica de Fundo',
            maxSizeMB: 3.0,
          ),
        ],
      ),
      AdminSectionGroup(
        id: 'about',
        title: 'Sobre Nós & Cuidados',
        icon: 'pets',
        fields: [
          AdminField.text(
            key: 'about.badge',
            label: 'Badge',
            maxLength: 40,
          ),
          AdminField.text(
            key: 'about.title',
            label: 'Título da Seção',
            maxLength: 80,
          ),
          AdminField.text(
            key: 'about.description_1',
            label: 'Primeiro Parágrafo',
            maxLines: 4,
            maxLength: 350,
          ),
          AdminField.text(
            key: 'about.description_2',
            label: 'Segundo Parágrafo',
            maxLines: 4,
            maxLength: 350,
          ),
        ],
      ),
      AdminSectionGroup(
        id: 'services',
        title: 'Serviços Oferecidos',
        icon: 'category',
        fields: [
          AdminField.text(
            key: 'services.badge',
            label: 'Badge',
            maxLength: 40,
          ),
          AdminField.text(
            key: 'services.title',
            label: 'Título de Serviços',
            maxLength: 80,
          ),
          AdminField.text(
            key: 'services.subtitle',
            label: 'Subtítulo de Serviços',
            maxLength: 180,
            maxLines: 2,
          ),
          AdminField.list(
            key: 'services.items',
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
        icon: 'photo_library',
        fields: [
          AdminField.text(
            key: 'gallery.badge',
            label: 'Badge',
            maxLength: 40,
          ),
          AdminField.text(
            key: 'gallery.title',
            label: 'Título da Galeria',
            maxLength: 80,
          ),
          AdminField.gallery(
            key: 'gallery.images',
            label: 'Fotos do Espaço e Cães',
            maxItems: 10,
            maxSizeMB: 2.0,
          ),
        ],
      ),
      AdminSectionGroup(
        id: 'location',
        title: 'Localização & Horários',
        icon: 'location_on',
        fields: [
          AdminField.text(
            key: 'location.badge',
            label: 'Badge',
            maxLength: 40,
          ),
          AdminField.text(
            key: 'location.title',
            label: 'Título Localização',
            maxLength: 80,
          ),
          AdminField.text(
            key: 'location.address',
            label: 'Endereço Completo',
            maxLength: 140,
            maxLines: 2,
          ),
          AdminField.text(
            key: 'location.hours',
            label: 'Horário de Funcionamento',
            maxLength: 80,
          ),
        ],
      ),
      AdminSectionGroup(
        id: 'contact',
        title: 'Contato & Redes',
        icon: 'contact_phone',
        fields: [
          AdminField.text(
            key: 'contact.whatsapp_number',
            label: 'Número WhatsApp Oficial',
            maxLength: 25,
          ),
          AdminField.text(
            key: 'contact.instagram_handle',
            label: 'Usuário do Instagram',
            maxLength: 40,
          ),
        ],
      ),
    ],
  );
}
