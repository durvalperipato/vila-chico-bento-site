import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Vila Chico Bento | Creche e Hospedagem para Cães em Pinhais'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get navHome;

  /// No description provided for @navAbout.
  ///
  /// In pt, this message translates to:
  /// **'Sobre Nós'**
  String get navAbout;

  /// No description provided for @navServices.
  ///
  /// In pt, this message translates to:
  /// **'Serviços'**
  String get navServices;

  /// No description provided for @navGallery.
  ///
  /// In pt, this message translates to:
  /// **'Galeria'**
  String get navGallery;

  /// No description provided for @navLocation.
  ///
  /// In pt, this message translates to:
  /// **'Como Chegar'**
  String get navLocation;

  /// No description provided for @navContact.
  ///
  /// In pt, this message translates to:
  /// **'Contato'**
  String get navContact;

  /// No description provided for @heroBadge.
  ///
  /// In pt, this message translates to:
  /// **'🐾 O Segundo Lar do Seu Cãozinho'**
  String get heroBadge;

  /// No description provided for @heroTitle.
  ///
  /// In pt, this message translates to:
  /// **'Amor, liberdade e enriquecimento ambiental para o seu pet'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Creche diária (Day Care), hotelzinho acolhedor e rotina pensada com carinho em Pinhais e Região. Deixe seu melhor amigo brincar, socializar e gastar energia com total segurança!'**
  String get heroSubtitle;

  /// No description provided for @heroCtaWhatsapp.
  ///
  /// In pt, this message translates to:
  /// **'Agendar Adaptação no WhatsApp'**
  String get heroCtaWhatsapp;

  /// No description provided for @heroCtaServices.
  ///
  /// In pt, this message translates to:
  /// **'Ver Nossos Serviços'**
  String get heroCtaServices;

  /// No description provided for @aboutBadge.
  ///
  /// In pt, this message translates to:
  /// **'Nossa Proposta & Cuidado'**
  String get aboutBadge;

  /// No description provided for @aboutTitle.
  ///
  /// In pt, this message translates to:
  /// **'Mais que uma creche, uma extensão do seu lar'**
  String get aboutTitle;

  /// No description provided for @aboutDescription.
  ///
  /// In pt, this message translates to:
  /// **'Na Vila Chico Bento, cada cão é tratado com carinho e respeito às suas particularidades. Nosso foco é proporcionar um ambiente seguro onde eles possam correr livres, praticar atividades que estimulam a mente e relaxar com tranquilidade.'**
  String get aboutDescription;

  /// No description provided for @aboutPoint1Title.
  ///
  /// In pt, this message translates to:
  /// **'Enriquecimento Ambiental (EA)'**
  String get aboutPoint1Title;

  /// No description provided for @aboutPoint1Desc.
  ///
  /// In pt, this message translates to:
  /// **'Atividades cognitivas, olfativas e sensoriais que reduzem a ansiedade e aumentam a felicidade do seu pet.'**
  String get aboutPoint1Desc;

  /// No description provided for @aboutPoint2Title.
  ///
  /// In pt, this message translates to:
  /// **'Segurança & Supervisão Total'**
  String get aboutPoint2Title;

  /// No description provided for @aboutPoint2Desc.
  ///
  /// In pt, this message translates to:
  /// **'Monitoramento atencioso durante todo o dia com manejo positivo e cuidado com a saúde e higiene.'**
  String get aboutPoint2Desc;

  /// No description provided for @aboutPoint3Title.
  ///
  /// In pt, this message translates to:
  /// **'Espaço Amplo & Ao Ar Livre'**
  String get aboutPoint3Title;

  /// No description provided for @aboutPoint3Desc.
  ///
  /// In pt, this message translates to:
  /// **'Área verde e espaçosa com brinquedos interativos, sombra e proteção para dias de chuva.'**
  String get aboutPoint3Desc;

  /// No description provided for @servicesBadge.
  ///
  /// In pt, this message translates to:
  /// **'O Que Fazemos de Melhor'**
  String get servicesBadge;

  /// No description provided for @servicesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Serviços pensados para a rotina e o bem-estar do seu pet'**
  String get servicesTitle;

  /// No description provided for @serviceDaycareTitle.
  ///
  /// In pt, this message translates to:
  /// **'Day Care (Creche Canina)'**
  String get serviceDaycareTitle;

  /// No description provided for @serviceDaycareDesc.
  ///
  /// In pt, this message translates to:
  /// **'O dia inteiro com recreação orientada, socialização com outros cães, circuitos de brincadeiras e muito gasto de energia de forma saudável.'**
  String get serviceDaycareDesc;

  /// No description provided for @serviceHotelTitle.
  ///
  /// In pt, this message translates to:
  /// **'Hospedagem & Hotelzinho'**
  String get serviceHotelTitle;

  /// No description provided for @serviceHotelDesc.
  ///
  /// In pt, this message translates to:
  /// **'Vai viajar? Hospede seu cão com quem ama pets. Rotina de sono tranquila, alimentação supervisionada e atualizações frequentes por WhatsApp.'**
  String get serviceHotelDesc;

  /// No description provided for @serviceAdaptationTitle.
  ///
  /// In pt, this message translates to:
  /// **'Período de Adaptação'**
  String get serviceAdaptationTitle;

  /// No description provided for @serviceAdaptationDesc.
  ///
  /// In pt, this message translates to:
  /// **'Avaliação comportamental cuidadosa antes do início das atividades para garantir que seu pet se sinta seguro e confortável na matilha.'**
  String get serviceAdaptationDesc;

  /// No description provided for @serviceRoutineTitle.
  ///
  /// In pt, this message translates to:
  /// **'Rotina Estruturada'**
  String get serviceRoutineTitle;

  /// No description provided for @serviceRoutineDesc.
  ///
  /// In pt, this message translates to:
  /// **'Momentos dedicados para socialização, enriquecimento alimentar (picolés e frutas em dias quentes) e soneca relaxante pós-almoço.'**
  String get serviceRoutineDesc;

  /// No description provided for @galleryBadge.
  ///
  /// In pt, this message translates to:
  /// **'Momentos Felizes'**
  String get galleryBadge;

  /// No description provided for @galleryTitle.
  ///
  /// In pt, this message translates to:
  /// **'A alegria que transborda em cada latido'**
  String get galleryTitle;

  /// No description provided for @gallerySubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Confira um pouco da rotina, das brincadeiras e do carinho que nossos alunos e hóspedes recebem todos os dias!'**
  String get gallerySubtitle;

  /// No description provided for @locationBadge.
  ///
  /// In pt, this message translates to:
  /// **'Onde Estamos'**
  String get locationBadge;

  /// No description provided for @locationTitle.
  ///
  /// In pt, this message translates to:
  /// **'Venha nos visitar em Pinhais'**
  String get locationTitle;

  /// No description provided for @locationAddress.
  ///
  /// In pt, this message translates to:
  /// **'R. Clóvis Beviláqua, 579 - Vargem Grande, Pinhais - PR, 83321-110'**
  String get locationAddress;

  /// No description provided for @locationOpenHours.
  ///
  /// In pt, this message translates to:
  /// **'Segunda a Domingo: 07h às 20h'**
  String get locationOpenHours;

  /// No description provided for @btnGoogleMaps.
  ///
  /// In pt, this message translates to:
  /// **'Abrir no Google Maps'**
  String get btnGoogleMaps;

  /// No description provided for @btnWaze.
  ///
  /// In pt, this message translates to:
  /// **'Abrir no Waze'**
  String get btnWaze;

  /// No description provided for @contactBadge.
  ///
  /// In pt, this message translates to:
  /// **'Fale Conosco'**
  String get contactBadge;

  /// No description provided for @contactTitle.
  ///
  /// In pt, this message translates to:
  /// **'Pronto para agendar a adaptação do seu melhor amigo?'**
  String get contactTitle;

  /// No description provided for @contactSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Clique abaixo para conversar diretamente com a nossa equipe no WhatsApp ou nos siga no Instagram!'**
  String get contactSubtitle;

  /// No description provided for @btnWhatsapp.
  ///
  /// In pt, this message translates to:
  /// **'Conversar no WhatsApp'**
  String get btnWhatsapp;

  /// No description provided for @btnInstagram.
  ///
  /// In pt, this message translates to:
  /// **'Ver no Instagram'**
  String get btnInstagram;

  /// No description provided for @mascotBadge.
  ///
  /// In pt, this message translates to:
  /// **'🐾 Missão Cumprida!'**
  String get mascotBadge;

  /// No description provided for @mascotSpeech.
  ///
  /// In pt, this message translates to:
  /// **'Ufa! Percorri o site todinho correndo e brincando... Agora é hora daquela soneca gostosa! 💤 Traga seu melhor amigo para viver essa alegria na Vila Chico Bento!'**
  String get mascotSpeech;

  /// No description provided for @mascotBattery.
  ///
  /// In pt, this message translates to:
  /// **'Bateria: 0% | Felicidade: 100%'**
  String get mascotBattery;

  /// No description provided for @mascotStatus.
  ///
  /// In pt, this message translates to:
  /// **'Modo Soneca Pós-Creche Ativado 😴'**
  String get mascotStatus;

  /// No description provided for @footerRights.
  ///
  /// In pt, this message translates to:
  /// **'© Vila Chico Bento. Todos os direitos reservados. Pinhais - PR.'**
  String get footerRights;

  /// No description provided for @whatsappMessage.
  ///
  /// In pt, this message translates to:
  /// **'Olá! Conheci o site da Vila Chico Bento e gostaria de agendar uma visita e o período de adaptação para o meu cãozinho!'**
  String get whatsappMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
