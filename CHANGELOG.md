# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.0.2] - 2026-10-14

### Added
- **Admin Workspace & Live Preview**:
  - Interactive CMS split-screen live preview with real-time responsive simulation (Desktop, Tablet, Mobile).
  - NanoDebouncer integration for smooth text input without UI lag.
  - Multi-section accordion editor supporting Hero, About, Services, Gallery, Location, Contact, and Footer.
  - Live draft synchronization and one-click publishing flow to production.
  - Image upload and URL management for galleries and content sections.
- **Dynamic Content & Cloud Sync**:
  - Full schema-driven synchronization with Firebase Firestore (`sites/vila-chico-bento` and `drafts/current`).
  - Added support for rich About section pillars (`Environmental Enrichment`, `Safety & Supervision`, `Spacious Green Area`).
  - Added photo cards, badges, and custom WhatsApp CTA actions per service item.
  - Support for custom hero highlights and secondary CTAs directly managed from the cloud.
- **Section Enhancements**:
  - **Hero Section**: Dynamic high-resolution banner with custom alignment, secondary glassmorphic CTA, and cloud highlights.
  - **About Section**: Split Editorial layout with organic pebble photo card and interactive care pillars.
  - **Services Section**: Triptych layout featuring real dog photography, dynamic badges, and direct WhatsApp booking buttons.

### Changed
- **Pure Cloud-Driven Architecture**:
  - Completely eradicated all hardcoded fallback texts, default badge lists, and static placeholder URLs across Dart models and presentation widgets.
  - Live preview renders dynamically from active content bundle with contextual placeholders during empty states.

## [0.0.1] - 2026-09-18

### Added
- **Landing Page Architecture**: Initial production-ready Flutter Web application architected with [`nano_core`](https://pub.dev/packages/nano_core).
- **Hero Section**:
  - High-impact photographic visual with dark gradient overlay.
  - Straight bottom border transition.
  - Floating key value propositions (Green Area, Cage-Free, Loving Supervision, Pinhais/PR).
- **About Section ("Our Mission")**:
  - Interactive feature cards highlighting pet well-being, freedom, and tailored attention.
- **Services Section ("What We Offer")**:
  - Responsive horizontal swipe carousel with interactive dot indicators for mobile and tablet devices.
  - Comprehensive service coverage: Day Care, Canine Hotel, Environmental Enrichment, and Socialization.
- **Gallery Section ("Happy Moments")**:
  - Card-peeking horizontal carousel on mobile for frictionless photo discovery.
  - Clean card hover effects and subtle shadows on desktop.
- **Location Section ("Our Location")**:
  - Embedded real interactive Google Maps iframe (`R. Clóvis Beviláqua, 579 - Pinhais/PR`).
  - Native scroll-trap prevention with on-demand touch activation and auto-release.
  - Quick action buttons for Waze, Google Maps App, and Official Address copy.
- **Contact & Mascot Section**:
  - Resting mascot illustration with direct communication bubbles.
  - WhatsApp primary CTA with customizable pre-filled message.
  - Direct Instagram button.
- **Footer Section**:
  - Responsive layout with operating hours, full address, and branded circular social links.
  - Back-to-top floating button and theme/language triggers.
- **Meandering Paw Trail**:
  - Mathematically generated cubic Bézier paw trail that dynamically adjusts step density to viewport height.
  - Continuous vertical continuity tangents across section borders.
- **Localization (l10n)**:
  - Native bilingual support for Brazilian Portuguese (`pt-BR`) and English (`en`).
- **Icons & PWA Assets**:
  - Full icon and favicon suite generated across all required sizes (`favicon.ico`, `favicon.png`, `48x48`, `96x96`, `192x192`, `512x512`).
  - Open Graph / WhatsApp rich preview meta tags configured in `index.html`.
- **Infrastructure**:
  - Firebase Hosting deployment configuration in `firebase.json` and `.firebaserc`.
