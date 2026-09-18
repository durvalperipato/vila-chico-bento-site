import 'package:nano_core/nano_core.dart';
import '../../../core/localization/app_language.dart';

enum HomeNavSection {
  hero,
  about,
  services,
  gallery,
  location,
  contact,
}

/// Estado imutável da Home da Vila Chico Bento gerenciado pelo [HomeController].
class HomeState extends NanoViewState {
  const HomeState({
    this.isDarkMode = true,
    this.currentLanguage = AppLanguage.pt,
    this.activeSection = HomeNavSection.hero,
  });

  final bool isDarkMode;
  final AppLanguage currentLanguage;
  final HomeNavSection activeSection;

  HomeState copyWith({
    bool? isDarkMode,
    AppLanguage? currentLanguage,
    HomeNavSection? activeSection,
  }) {
    return HomeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      activeSection: activeSection ?? this.activeSection,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, currentLanguage, activeSection];
}
