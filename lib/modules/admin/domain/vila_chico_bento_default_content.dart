import 'entities/content_bundle.dart';

/// Canonical default content representing current production copy and assets.
/// Used to seed the administrative form generator and as the ultimate fallback.
class VilaChicoBentoDefaultContent {
  VilaChicoBentoDefaultContent._();

  static const Map<String, dynamic> rawMap = {
    // Hero
    'hero': {
      'badge': '🐾 O Segundo Lar do Seu Cãozinho',
      'title': 'Amor, liberdade e enriquecimento ambiental para o seu pet',
      'subtitle':
          'Creche diária (Day Care), hotelzinho acolhedor e rotina pensada '
          'com carinho em Pinhais e Região. Deixe seu melhor amigo brincar, '
          'socializar e gastar energia com total segurança!',
      'cta_whatsapp_text': 'Agendar Adaptação no WhatsApp',
      'banner_image':
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=1200&q=85',
    },

    // About
    'about': {
      'badge': 'Nossa Proposta & Cuidado',
      'title': 'Mais que uma creche, uma extensão do seu lar',
      'description_1':
          'Na Vila Chico Bento, cada cão é tratado com carinho e respeito '
          'às suas particularidades. Nosso foco é proporcionar um ambiente '
          'seguro onde eles possam correr livres, praticar atividades que '
          'estimulam a mente e relaxar com tranquilidade.',
      'description_2':
          'Contamos com monitores apaixonados por animais, enriquecimento '
          'ambiental diário e infraestrutura completa pensada para o '
          'bem-estar da matilha durante todo o dia.',
    },

    // Services
    'services': {
      'badge': 'O Que Fazemos de Melhor',
      'title': 'Serviços pensados para a rotina e o bem-estar do seu pet',
      'subtitle':
          'Atividades diárias, hospedagem afetuosa e cuidados dedicados em '
          'Pinhais.',
      'items': [
        {
          'title': 'Day Care (Creche Canina)',
          'description':
              'Recreação orientada, socialização com outros cães, circuitos '
              'de brincadeiras e gasto saudável de energia.',
        },
        {
          'title': 'Hospedagem & Hotelzinho',
          'description':
              'Rotina de sono tranquila, alimentação supervisionada e '
              'atualizações frequentes por fotos e vídeos no WhatsApp.',
        },
        {
          'title': 'Período de Adaptação',
          'description':
              'Avaliação comportamental cuidadosa antes do início para que '
              'seu pet se sinta 100% seguro e acolhido.',
        },
      ],
    },

    // Gallery
    'gallery': {
      'badge': 'Momentos Felizes',
      'title': 'A alegria que transborda em cada latido',
      'images': [
        'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1587300003388-59208cc962cb?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?auto=format&fit=crop&w=800&q=80',
      ],
    },

    // Location
    'location': {
      'badge': 'Onde Estamos',
      'title': 'Venha nos visitar em Pinhais',
      'address':
          'R. Clóvis Beviláqua, 579 - Vargem Grande, Pinhais - PR, 83321-110',
      'hours': 'Segunda a Sexta: 07h às 19h | Sábado: 08h às 14h',
    },

    // Contact
    'contact': {
      'whatsapp_number': '(41) 99252-3108',
      'instagram_handle': '@vilachicobento',
    },
  };

  /// Pre-built immutable [ContentBundle] seeded with default content.
  static final ContentBundle bundle = ContentBundle.fromMap(rawMap);
}
