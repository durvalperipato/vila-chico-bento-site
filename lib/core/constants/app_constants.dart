/// Constantes de negócio, contato oficial e links externos da Vila Chico Bento.
class AppConstants {
  AppConstants._();

  static const String appName = 'Vila Chico Bento';
  static const String phoneDisplay = '(41) 99252-3108';
  static const String phoneRaw = '5541992523108';

  static const String instagramUsername = '@vilachicobento';
  static const String instagramUrl = 'https://instagram.com/vilachicobento';

  static const String fullAddress =
      'R. Clóvis Beviláqua, 579 - Vargem Grande, Pinhais - PR, 83321-110';
  static const String openingHours = 'Segunda a Sexta: 07h às 19h';

  static const String googleMapsUrl =
      'https://www.google.com/maps/search/?api=1&query=R.+Cl%C3%B3vis+Bevil%C3%A1qua%2C+579+-+Vargem+Grande%2C+Pinhais+-+PR%2C+83321-110';

  static const String googleMapsEmbedUrl =
      'https://maps.google.com/maps?q=R.+Cl%C3%B3vis+Bevil%C3%A1qua,+579+-+Vargem+Grande,+Pinhais+-+PR&t=&z=16&ie=UTF8&iwloc=&output=embed';

  static const String wazeUrl =
      'https://waze.com/ul?q=R.+Cl%C3%B3vis+Bevil%C3%A1qua%2C+579+-+Vargem+Grande%2C+Pinhais+-+PR%2C+83321-110&navigate=yes';

  static const String developerName = 'NanoDevs';
  static const String developerUrl = 'https://nanodevs.com.br';

  /// Gera a URL do WhatsApp com mensagem opcional codificada.
  static String buildWhatsAppUrl(String message) {
    final encodedMessage = Uri.encodeComponent(message);
    return 'https://wa.me/$phoneRaw?text=$encodedMessage';
  }
}
