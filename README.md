# 🐾 Vila Chico Bento — Canine Day Care & Hotel Landing Page

> A modern, responsive, high-converting one-page web application for **Vila Chico Bento**, a premier canine day care and dog hotel in Pinhais, Paraná (Greater Curitiba, Brazil).

[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![NanoCore](https://img.shields.io/badge/Architecture-NanoCore-FF6F00)](https://pub.dev/packages/nano_core)
[![Firebase](https://img.shields.io/badge/Hosting-Firebase-FFA611?logo=firebase&logoColor=white)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)](#)

---

## 🐶 About the Project

**Vila Chico Bento** is designed with pet safety, comfort, and joy at its heart. The web app provides prospective clients with a warm, transparent, and seamless experience across all devices:

- 📱 **Mobile-First Experience**: Optimized card-peeking horizontal carousels for services and photo gallery on smartphones.
- 🎨 **Warm & Cohesive Visual Identity**: Curated earthy and playful palette (`#FAF6EE`, `#FF8C42`, `#2E7D32`), paired with typography from Google Fonts (*Fredoka* & *Outfit*).
- 🐾 **Meandering Paw Trail**: An organic, mathematically computed cubic Bézier paw trail that connects every section without layout shifts or abrupt cuts.
- 📍 **Embedded Real Google Maps**: Interactive Google Maps embed with scroll-trap prevention (pointer events disabled by default until user interaction).
- 🌐 **Full Internationalization (l10n)**: Native bilingual support for Brazilian Portuguese (`pt-BR`) and English (`en`).
- 💬 **Instant Communication Integrations**: Persistent floating WhatsApp button with pre-filled messages, plus one-tap links to Waze, Google Maps, and Instagram.

---

## 🏗️ Tech Stack & Architecture

- **Framework**: [Flutter Web](https://flutter.dev)
- **State Management & DI**: [`nano_core`](https://pub.dev/packages/nano_core) (`NanoStatePage`, `NanoController`, `NanoInjections`)
- **Typography**: [`google_fonts`](https://pub.dev/packages/google_fonts) (*Fredoka*, *Outfit*)
- **Official Brand Icons**: [`font_awesome_flutter`](https://pub.dev/packages/font_awesome_flutter) (WhatsApp, Instagram, Waze, Google Maps)
- **Hosting & Infrastructure**: [Firebase Hosting](https://firebase.google.com/docs/hosting)

---

## 📁 Project Structure

```text
lib/
├── core/
│   ├── constants/       # Asset paths, URLs, location constants
│   ├── extensions/      # BuildContext and l10n extensions
│   ├── theme/           # AppColors, AppTypography, design tokens
│   └── widgets/         # ResponsiveContainer, MeanderingPawTrail, BrandIcons, RealMapEmbed
├── l10n/
│   ├── arb/             # ARB localization files (app_en.arb, app_pt.arb)
│   └── generated/       # Generated Dart localization classes
└── modules/
    └── home/
        ├── presentation/
        │   ├── widgets/
        │   │   ├── floating/    # WhatsAppFloating button
        │   │   ├── navbar/      # Responsive Navbar with language & theme toggles
        │   │   └── sections/    # Hero, About, Services, Gallery, Location, Contact, Footer
        │   ├── home_controller.dart
        │   ├── home_injections.dart
        │   ├── home_page.dart
        │   └── home_state.dart
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.24 or later)
- Google Chrome

### Running Locally
```bash
# 1. Clone the repository
git clone https://github.com/durvalperipato/vila-chico-bento-site.git
cd vila-chico-bento-site

# 2. Install dependencies
flutter pub get

# 3. Start development server
flutter run -d chrome
```

---

## 🧪 Code Quality & Tests

```bash
# Static code analysis with zero warnings
dart analyze --fatal-infos

# Run unit and widget tests
flutter test
```

---

## 📦 Production Build & Deployment

```bash
# 1. Build the production-optimized web bundle
flutter build web --release

# 2. Deploy to Firebase Hosting
firebase deploy --only hosting
```

Live preview:
👉 **[https://vila-chico-bento.web.app/](https://vila-chico-bento.web.app/)**

---

## 📄 License
All rights reserved © Vila Chico Bento. Proprietary software.
