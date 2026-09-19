# Epics and Stories: Vila Chico Bento Site & Admin Engine

## Epic 1: Schema-Driven Admin Module & Live Preview Engine

This epic delivers an in-project, Schema-Driven administrative panel for `vila-chico-bento-site` (piloting the future Nano Sites Admin Engine). It enables the business owner to update landing page copy, hero components, and gallery images with real-time live preview and resilient offline fallback, without altering the underlying Nano Core foundation.

### Story 1.1: Domain Models and Field Schema Catalog
Define immutable domain entities `AdminField` (text, image, gallery, list), `AdminSectionGroup`, and the concrete Vila Chico Bento schema definition under `lib/modules/admin/domain`. Keep models pure and decoupled from Flutter UI presentation.

### Story 1.2: Firestore Content Repository with Resilient Fallback
Implement `SiteContentRepository` to read and write content under `sites/{siteId}` in Cloud Firestore, providing automated fallback to local `AppConstants` when offline or encountering null entries, ensuring network drops never cause unhandled UI crashes.

### Story 1.3: Operator Authentication and Protected /admin Route
Implement the operator Login view and authentication flow with Firebase Auth, redirecting unauthenticated visitors and guarding administrative route transitions to `/admin`.

### Story 1.4: Dynamic Schema-Driven Form Generator
Build the administrative form renderer widget that converts declarative `AdminField` definitions into reactive inputs equipped with length limits, validation feedback, and character counters.

### Story 1.5: Gallery Image Upload and Management via Firebase Storage
Implement image selection, client-side size validation, upload to `sites/{siteId}/gallery/` in Firebase Storage, and gallery management for up to 10 photos with delete and reorder capabilities.

### Story 1.6: Split-Screen Live Preview and Publishing Workflow
Implement desktop split-screen layout with form inputs on the left and live real-time site preview on the right, maintaining a working draft until the operator explicitly clicks 'Publish'. Gracefully adapt to tabbed/modal preview on mobile.

### Story 1.7: Landing Page Integration with Content Service
Refactor existing HomePage widgets (Hero, Services, Gallery) to observe the reactive `SiteContentRepository` state while preserving default `AppConstants` fallback, followed by comprehensive visual and functional verification.
