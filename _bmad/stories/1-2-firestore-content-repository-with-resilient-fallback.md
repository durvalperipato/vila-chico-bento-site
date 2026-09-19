---
title: 'Story 1.2: Firestore Content Repository with Resilient Fallback'
type: 'feature'
created: '09-19-2026'
status: 'done'
route: 'oneshot'
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Landing Page and administrative components need a resilient repository abstraction to read and persist dynamic content in Cloud Firestore under `sites/{siteId}`, with automated fallback to default local values in `AppConstants` so network errors or missing documents never disrupt visitors.

**Approach:** Implement `SiteContentRepository` (interface and Firestore implementation) under `lib/modules/admin/infrastructure/`, along with a reactive `ContentState` or `ContentService` that serves type-safe getters (`getString`, `getImageUrl`, `getStringList`, `getListMap`) with fallback, and unit/mock tests to verify resilience.

</frozen-after-approval>

## Implementation Notes

- Added required Firebase packages (`cloud_firestore: ^6.10.0`, `firebase_auth: ^6.7.0`, `firebase_storage: ^13.6.0`) with clean pub dependency resolution.
- Defined `SiteContentRepository` domain contract supporting `getContent`, real-time `watchContent`, `saveContent`, `saveDraft`, and `getDraft`.
- Implemented `ContentBundle` immutable value object with dot-separated key traversal (`hero.title`), type-safe fallbacks (`getString`, `getInt`, `getDouble`, `getBool`, `getStringList`, `getListMap`), and map equality.
- Implemented `FirestoreSiteContentRepository` with automatic error trapping, warning logging via `NanoLogger`, and graceful empty map returns preventing unhandled runtime exceptions.
- Implemented `SiteContentService` as a reactive `ValueNotifier<ContentBundle>` with draft support, live preview updates, and Firestore streaming.
- Added comprehensive unit tests in `test/modules/admin/infrastructure/content_repository_test.dart` (7/7 passing).
- Cleaned lint rules and formatted codebase; `fvm flutter analyze` reports 0 issues.

## Review Triage Log

- Fixed `ContentBundle.==` to use `mapEquals` instead of comparing map lengths, ensuring `ValueNotifier` accurately triggers UI updates when content changes.
- All 15 project tests pass cleanly.
