---
title: 'Story 1.1: Domain Models and Field Schema Catalog'
type: 'feature'
created: '09-19-2026'
status: 'done'
route: 'oneshot'
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The project lacks domain abstractions to model editable administrative fields, section groups, and declarative schemas for content updates.

**Approach:** Implement immutable domain models (`AdminField`, `AdminFieldType`, `AdminSectionGroup`, and `SiteSchema`) under `lib/modules/admin/domain/`, supply the concrete `VilaChicoBentoSchema`, and provide unit tests verifying domain validation and constraints.

</frozen-after-approval>

## Implementation Notes

- Created `AdminFieldType` enum (`text`, `image`, `gallery`, `list`).
- Created `AdminField` immutable domain model with typed factory constructors (`.text`, `.image`, `.gallery`, `.list`), business validation (`validate(dynamic value)`), equality, and hashCode.
- Created `AdminSectionGroup` representing logical section clusters and recursive field lookup (`findField`).
- Created `SiteSchema` domain container with section retrieval (`getSection`), global field lookup (`findField`), and immutable key listing (`allKeys`).
- Created `VilaChicoBentoSchema` providing canonical declarations for all 6 site sections: Hero, About, Services, Gallery, Location, and Contact.
- Created `domain.dart` barrel export under `lib/modules/admin/domain/`.
- Created comprehensive unit tests in `test/modules/admin/domain/admin_domain_test.dart` (7/7 tests passing).
- Validated with `flutter analyze` (0 issues).

## Review Triage Log

- All review layers passed with zero critical, medium, or tolerable findings. Code is pure Dart, decoupled from UI, fully tested, and statically verified.
