import 'package:nano_core/nano_core.dart';
import '../../../core/localization/app_language.dart';
import '../../admin/domain/entities/content_bundle.dart';

import '../domain/entities/home_view_content.dart';

enum HomeNavSection {
  hero,
  about,
  services,
  gallery,
  location,
  contact,
}

/// Estado imutável da Home da Vila Chico Bento gerenciado pelo
/// [HomeController].
class HomeState extends NanoViewState {
  HomeState({
    this.isDarkMode = true,
    this.currentLanguage = AppLanguage.pt,
    this.activeSection = HomeNavSection.hero,
    ContentBundle? contentBundle,
  }) : contentBundle = contentBundle ?? const ContentBundle.empty();

  final bool isDarkMode;
  final AppLanguage currentLanguage;
  final HomeNavSection activeSection;
  final ContentBundle contentBundle;

  HeroViewContent get hero => HeroViewContent.fromBundle(contentBundle);
  AboutViewContent get about => AboutViewContent.fromBundle(contentBundle);
  ServicesViewContent get services =>
      ServicesViewContent.fromBundle(contentBundle);
  GalleryViewContent get gallery =>
      GalleryViewContent.fromBundle(contentBundle);
  LocationViewContent get location =>
      LocationViewContent.fromBundle(contentBundle);
  ContactViewContent get contact =>
      ContactViewContent.fromBundle(contentBundle);
  FooterViewContent get footer => FooterViewContent.fromBundle(contentBundle);

  HomeState copyWith({
    bool? isDarkMode,
    AppLanguage? currentLanguage,
    HomeNavSection? activeSection,
    ContentBundle? contentBundle,
  }) {
    return HomeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      activeSection: activeSection ?? this.activeSection,
      contentBundle: contentBundle ?? this.contentBundle,
    );
  }

  @override
  List<Object?> get props => [
        isDarkMode,
        currentLanguage,
        activeSection,
        contentBundle,
      ];
}
