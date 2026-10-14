# Epic 1 Context: Schema-Driven Admin Module & Live Preview Engine

<!-- Compiled from planning artifacts. Edit freely. Regenerate with compile-epic-context if planning docs change. -->

## Goal

Deliver an in-project, schema-driven administrative panel for `vila-chico-bento-site` (piloting the future Nano Sites Admin Engine). It enables the business owner to update landing page copy, hero components, and gallery images with real-time live preview and resilient offline fallback, without altering the underlying Nano Core foundation.

## Stories

- Story 1.1: Domain Models and Field Schema Catalog
- Story 1.2: Firestore Content Repository with Resilient Fallback
- Story 1.3: Operator Authentication and Protected /admin Route
- Story 1.4: Dynamic Schema-Driven Form Generator
- Story 1.5: Gallery Image Upload and Management via Firebase Storage
- Story 1.6: Split-Screen Live Preview and Publishing Workflow
- Story 1.7: Landing Page Integration with Content Service

## Requirements & Constraints

- Administrative code must reside strictly under `lib/modules/admin/` and conform to canonical `nano_core` conventions (`NanoStatePage`, `NanoController`, `NanoInjections`).
- Nano Core package must remain agnostic, lean, and free of Firebase or Admin UI dependencies.
- Firestore and Storage access must be strictly scoped to the authenticated operator's `siteId` (`sites/{siteId}`).
- Visual layout structure remains governed by Landing Page widgets; operators edit content data only.
- In offline mode or when Firestore documents are absent, public Landing Page renders 100% intact using local defaults (`AppConstants`) without errors or broken layouts.
- Admin workspace initializes form inputs pre-populated with official current site copy (`VilaChicoBentoDefaultContent.bundle`) when no remote document or draft exists.

## Technical Decisions

- Architecture follows Nano Core layered approach: Domain (`AdminField`, `AdminSectionGroup`, `SiteSchema`, `VilaChicoBentoDefaultContent`), Data (`SiteContentRepository`), Service (`SiteContentService`), and Presentation (`NanoStatePage`, `NanoController`, `NanoInjections`, widgets).
- Storage uploads go to `sites/{siteId}/gallery/`, limited to 2MB per file with allowed extensions (jpg, jpeg, png, webp).
- Draft modifications are kept reactive and isolated until explicitly published to production Firestore collection.

## UX & Interaction Patterns

- Schema-driven inputs: Accordions for section groups, dynamic form fields with character bounds and inline counters.
- Gallery management: Grid/list supporting image selection, client-side validation (max 2MB, formats), reordering, deletion, and maximum item limit (10 photos).
- Split-screen live preview on desktop (editor on the left, live landing page preview on the right), with responsive adaptation for smaller viewports.

## Cross-Story Dependencies

- Stories 1.1 through 1.4 provide the foundational models, repository, authentication guard, and dynamic form generator.
- Story 1.5 adds gallery upload and management widgets integrated into `DynamicFormGenerator` and Firebase Storage.
- Story 1.6 integrates the live split-screen preview and publishing workflow using the form and content service.
- Story 1.7 refactors the public Landing Page widgets to consume the content service.
