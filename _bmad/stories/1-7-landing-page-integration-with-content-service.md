---
title: 'Story 1.7: Landing Page Integration with Content Service and Canonical Responsiveness'
type: 'feature'
created: '2026-09-21'
status: 'done'
baseline_commit: 'f076a513c28f5fdd912f7271d88c95f97ac414b3'
route: 'dispatch'
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The public `HomePage` sections currently rely entirely on hardcoded strings, local assets, and static constants (`AppConstants`), ignoring updates published through the administrative panel via `SiteContentService`. Additionally, several landing page sections still rely on manual `isMobile` / `isDesktop` conditionals and helper methods returning widgets rather than the canonical `NanoResponsiveLayout` and extracted modular widgets.

**Approach:** 
1. Connect `HomeController` to the reactive `SiteContentService` (injecting `ContentBundle` into `HomeState` with automatic fallback to `VilaChicoBentoDefaultContent.bundle`).
2. Refactor Landing Page sections (Hero, About, Services, Gallery, Location, Contact CTA, Footer) to read dynamic copy and images from `controller.contentBundle`.
3. Adopt `NanoResponsiveLayout` and `NanoResponsiveLayout.flex` across sections, eliminating manual `LayoutBuilder` / `MediaQuery` boilerplate in build methods.
4. Extract sub-components into modular `StatelessWidget` / `StatefulWidget` files in each section's directory, complying with the architectural constraint forbidding `Widget _build...()` methods.
5. Create comprehensive widget and integration tests in `test/modules/home/` verifying dynamic updates, resilient fallback, and responsive viewport behavior.

## Boundaries & Constraints

**Always:**
- Keep fallback 100% resilient: if any field in `ContentBundle` is empty, null, or missing, immediately fall back to `VilaChicoBentoDefaultContent.bundle` and `AppConstants` so the page never fails to render.
- Comply strictly with the newly established Widget Component Architecture: zero private `Widget _build...()` helper methods in sections. Extract modular widgets into child widget directories.
- Utilize canonical `NanoResponsiveLayout` and `NanoResponsiveLayout.flex` from `nano_core` v1.0.8 for viewport adaptability.
- Maintain clean reactive architecture with `NanoStatePage`, `NanoController`, and `NanoInjections`.

**Never:**
- Never break existing public styling, typography, brand colors, or SEO meta tags.
- Never introduce network latency blocking initial render: default content must render synchronously if remote Firestore has not returned yet.
- Never write ad-hoc helper methods returning `Widget` in the main view or section classes.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Published Firestore content | ContentBundle has custom headline & gallery | Landing Page displays dynamic headline and custom photo gallery | Falls back if individual key is corrupt |
| Empty or offline repository | Firestore offline or empty document | Landing Page displays default copy and local assets seamlessly | Zero errors, 100% visual fidelity |
| Real-time content update | SiteContentService emits updated bundle | HomePage rebuilds reactively showing new content without refresh | State remains stable |
| Desktop viewport (>= 1024px) | Screen width 1280px | Multi-column layouts (Hero split, Services grid, Footer row) render via NanoResponsiveLayout | Smooth layout adaptation |
| Mobile viewport (< 600dp) | Screen width 390px | Single-column stacked layouts render via NanoResponsiveLayout.flex and mobile builders | Zero horizontal overflow |

</frozen-after-approval>

## Code Map

- `lib/modules/home/domain/entities/home_view_content.dart` -- Strongly typed view models for every landing page section (`HeroViewContent`, `AboutViewContent`, `ServicesViewContent`, `GalleryViewContent`, `LocationViewContent`, `ContactViewContent`, `FooterViewContent`).
- `lib/modules/home/presentation/home_state.dart` -- Strongly typed getters (`state.hero`, `state.about`, etc.) with default fallback `VilaChicoBentoDefaultContent.bundle` directly in `HomeState` constructor.
- `lib/modules/home/presentation/home_controller.dart` -- Reactive binding to `SiteContentService` updating `HomeState` upon content changes.
- `lib/modules/home/presentation/home_page.dart` -- Uses `NanoScaffold<HomeState, NanoMessageKey>` passing typed view state into sections.
- `lib/modules/home/presentation/widgets/sections/` -- Sections refactored to consume typed view content, `context.screen`, and `context.theme`, eliminating magic numbers and `isDark` constructor drilling.
- `lib/modules/home/presentation/widgets/sections/widgets/free_3d_mascot_dog.dart` -- Extracted standalone mascot widget.
- `test/modules/home/home_content_integration_test.dart` -- Unit and widget integration tests verifying typed view content, resilient fallback, reactive updates, and responsive rendering.

## Tasks & Acceptance

**Execution:**
- [x] `lib/modules/home/presentation/home_state.dart` -- Add `contentBundle` field with fallback to `VilaChicoBentoDefaultContent.bundle` and strongly typed getters (`hero`, `about`, `services`, `gallery`, `location`, `contact`, `footer`)
- [x] `lib/modules/home/presentation/home_controller.dart` -- Listen to `SiteContentService` and emit updated bundle in `HomeState`
- [x] `lib/modules/home/presentation/widgets/sections/` -- Refactor Hero, About, Services, Gallery, Location, Contact CTA, and Footer sections to consume typed state models, apply `NanoResponsiveLayout`, and extract modular child widgets
- [x] `test/modules/home/home_content_integration_test.dart` -- Create test suite covering all matrix scenarios
- [x] `_bmad/sprint-status.yaml` -- Update Story 1.7 status to `done` and Epic 1 to `done`

**Acceptance Criteria:**
- Given a running application, when the operator publishes changes in `/admin`, then `HomePage` immediately reflects the new copy and images.
- Given an offline network condition or empty Firestore collection, when viewing `HomePage`, then all sections render complete default copy and photos without layout breakage.
- Given any landing page section, then all viewport adaptation uses `NanoResponsiveLayout` or `NanoResponsiveLayout.flex` without `Widget _build...()` helper methods in section classes.
- Given the complete test suite, when running `flutter test`, then 100% of tests pass (53/53 tests pass) and static analysis is verified.

## Implementation Notes
- Fully refactored `HomeState` to expose strongly typed content models (`state.hero.title`, `state.hero.badge`, `state.hero.mainImage`), eliminating dynamic key querying and string lookups in UI widgets.
- Cleaned code smells: replaced magic numbers (`services.length < 4`) with intention-revealing constants/variables (`minServicesForDualRowGrid`, `hasFewServicesForGrid`).
- Eliminated constructor prop drilling of `isDark` across all section sub-widgets, reading `context.theme.isDark` from `nano_core`.
- Decoupled `HomeController` from default content fallback by placing `VilaChicoBentoDefaultContent.bundle` default initialization directly inside `HomeState` constructor.

## Verification

**Commands:**
- `flutter test test/modules/home/` -- All home tests pass
- `flutter test` -- 53/53 tests pass across entire project
- `flutter analyze lib/modules/home/` -- 0 errors
