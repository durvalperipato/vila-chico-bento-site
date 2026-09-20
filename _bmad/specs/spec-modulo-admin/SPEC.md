---
id: SPEC-modulo-admin
companions:
  - schema-catalog.md
  - security-rules.md
sources:
  - ../../forge/painel-admin/forged-idea.md
---

> **Canonical contract.** This SPEC and the files in `companions:` are the complete, preservation-validated contract for what to build, test, and validate. Source documents listed in frontmatter are for traceability — consult them only if you need narrative rationale or prose color this contract intentionally omits.

# Schema-Driven Admin Module (Nano Sites Engine)

## Why

Clients of institutional websites frequently request autonomy to update copy, contact details, and photo galleries without depending on developer turnaround for routine edits. Conventional solutions (such as WordPress or full visual page builders) introduce maintenance bloat, recurring cloud infrastructure costs, and high risk of broken responsive layouts. This module provides a built-in, Schema-Driven administrative panel isolated within the Nano Core architectural pattern, delivering guarded editing with real-time live preview while preserving the visual fidelity and responsiveness of the original design.

## Capabilities

- **CAP-1**
  - **intent:** Authenticated site operator accesses the protected administrative area at `/admin` via Firebase Auth.
  - **success:** Unauthenticated requests to `/admin` are intercepted and redirected to the login view; valid credentials load the administrative workspace; clicking logout terminates the active session immediately.

- **CAP-2**
  - **intent:** The admin panel dynamically renders editing forms from a declarative catalog of typed fields (`AdminField`), decoupled from Landing Page layout widgets.
  - **success:** Adding or modifying fields in the site schema generates corresponding reactive form inputs without creating custom manual screens.

- **CAP-3**
  - **intent:** Operator edits section texts, titles, subtitles, and contact information subject to strict character bounds and validation rules.
  - **success:** Submitting valid form inputs persists to the Firestore document for the site (`sites/{siteId}`) and updates the Landing Page; empty required inputs or values exceeding limits are rejected with inline feedback.

- **CAP-4**
  - **intent:** Operator uploads, reorders, and deletes up to 10 gallery images via direct upload to Firebase Storage.
  - **success:** Images matching valid formats (JPEG, PNG, WebP) up to 2MB are uploaded to `sites/{siteId}/gallery/`, receive public URLs, and populate the gallery; invalid formats or items beyond 10 photos are rejected with clear error indicators.

- **CAP-5**
  - **intent:** Operator previews changes in real time before publishing modifications to the live public site.
  - **success:** Field modifications trigger immediate live preview updates on desktop (split-screen) and mobile (modal/tab); public visitors only observe modifications after an explicit "Publish" action is confirmed.

- **CAP-6**
  - **intent:** Public Landing Page renders default static fallback values whenever network connectivity is lost or remote fields are empty.
  - **success:** In offline mode or when Firestore documents are absent, the Landing Page renders 100% intact using local defaults from `AppConstants` without rendering errors or broken layouts.

- **CAP-7**
  - **intent:** The admin panel workspace initializes form inputs pre-populated with the official current site copy and assets if no Firestore data or draft has been saved yet.
  - **success:** Opening `/admin` displays all section fields pre-filled with the actual production copy, allowing the operator to review and make minor edits without starting from blank inputs.

## Constraints

- Module code must reside strictly under `lib/modules/admin/` and conform to canonical `nano_core` conventions (`NanoStatePage`, `NanoController`, `NanoInjections`).
- The `nano_core` foundation package must remain agnostic, lean, and free of Firebase or Admin UI dependencies.
- Firestore and Storage access must be enforced by Security Rules scoped strictly to the authenticated operator's `siteId`.
- Visual layout structure remains governed by Landing Page widgets; operators edit content data only.

## Non-goals

- Free-form drag-and-drop page builder (WYSIWYG layout editor like Elementor/Wix).
- Complex role-based access control (RBAC with granular per-field permissions).
- Creating or publishing an isolated standalone Dart package to pub.dev during this pilot phase.
- E-commerce cart, checkout, or billing gateway features.

## Success signal

The owner of Vila Chico Bento signs into `/admin`, updates the Hero headline, uploads a new canine photo to the gallery, reviews the result in the live preview panel, and publishes changes to the live site in under 2 minutes without technical assistance.
