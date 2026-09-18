import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/settings/app_settings.dart';
import 'home_state.dart';

/// Controller reativo da Home gerenciando o estado via [NanoController].
class HomeController extends NanoController<HomeState> {
  HomeController()
      : super(
          initialState: HomeState(
            isDarkMode: true,
            currentLanguage: AppSettings.initialLanguage,
          ),
        );

  final ScrollController scrollController = ScrollController();

  // Chaves de Scroll para navegação por âncoras
  final GlobalKey heroKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey servicesKey = GlobalKey();
  final GlobalKey galleryKey = GlobalKey();
  final GlobalKey locationKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  @override
  Future<void> init(String? id) async {
    scrollController.addListener(_onScroll);
    emitLoaded(viewState);
  }

  void _onScroll() {
    updateActiveSectionOnScroll();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  bool get isDarkMode => AppSettings.themeModeNotifier.value == ThemeMode.dark;

  void toggleTheme() {
    AppSettings.toggleTheme();
    emitLoaded(viewState.copyWith(isDarkMode: isDarkMode));
  }

  AppLanguage get currentLanguage => viewState.currentLanguage;
  HomeNavSection get activeSection => viewState.activeSection;

  void setLanguage(AppLanguage language) {
    if (viewState.currentLanguage != language) {
      emitLoaded(viewState.copyWith(currentLanguage: language));
      AppSettings.localeNotifier.value = language.locale;
    }
  }

  void navigateToSection(HomeNavSection section, GlobalKey key) {
    emitLoaded(viewState.copyWith(activeSection: section));
    scrollToSection(key);
  }

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  /// Detecta automaticamente qual seção está visível na tela conforme o
  /// usuário rola a página.
  void updateActiveSectionOnScroll() {
    const threshold = 180.0;
    var detected = HomeNavSection.hero;

    final sections = [
      (HomeNavSection.contact, contactKey),
      (HomeNavSection.location, locationKey),
      (HomeNavSection.gallery, galleryKey),
      (HomeNavSection.services, servicesKey),
      (HomeNavSection.about, aboutKey),
      (HomeNavSection.hero, heroKey),
    ];

    for (final entry in sections) {
      final context = entry.$2.currentContext;
      if (context != null && context.mounted) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize) {
          final pos = box.localToGlobal(Offset.zero);
          if (pos.dy <= threshold) {
            detected = entry.$1;
            break;
          }
        }
      }
    }

    if (viewState.activeSection != detected) {
      emitLoaded(viewState.copyWith(activeSection: detected));
    }
  }

  /// Abre o WhatsApp com a mensagem padrão de agendamento de adaptação.
  Future<void> openWhatsApp({String? customMessage}) async {
    final message = customMessage ??
        'Olá! Conheci o site da Vila Chico Bento e gostaria de agendar uma visita e o período de adaptação para o meu cãozinho!';
    final url = AppConstants.buildWhatsAppUrl(message);
    await launchUrlString(url);
  }

  /// Abre o perfil oficial no Instagram.
  Future<void> openInstagram() async {
    await launchUrlString(AppConstants.instagramUrl);
  }

  /// Abre o Google Maps com o endereço em Pinhais.
  Future<void> openGoogleMaps() async {
    await launchUrlString(AppConstants.googleMapsUrl);
  }

  /// Abre o Waze navegando para a creche.
  Future<void> openWaze() async {
    await launchUrlString(AppConstants.wazeUrl);
  }

  Future<void> launchUrlString(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
