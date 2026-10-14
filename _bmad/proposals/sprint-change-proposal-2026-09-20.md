# Sprint Change Proposal: Default Content Seeding in Admin Workspace

**Date:** 2026-09-20
**Project:** Vila Chico Bento Site
**Status:** Approved
**Scope:** Minor / Direct Implementation (Developer)

---

## 1. Issue Summary

During interactive visual testing of the administrative panel (**Story 1.4: Dynamic Schema-Driven Form Generator**), an important UX enhancement was identified:
- When an operator accesses the editor for the first time or before remote Firestore documents are committed, form fields load empty.
- This creates anxiety and friction for business operators who want to perform minor edits (e.g., updating holiday hours or tweaking a headline) without feeling they need to rewrite the entire website from scratch.

---

## 2. Impact Analysis

- **Epic Impact:** Epic 1 remains 100% viable. This change enriches the schema engine with a canonical default content provider.
- **Story Impact:**
  - **Story 1.4:** Enriched with default fallback data seeding when no Firestore document or working draft exists.
  - **Story 1.6 (Live Preview):** Massive direct benefit. Split-screen live preview will immediately render the complete, rich website rather than empty placeholder sections.
  - **Story 1.7 (Landing Page Integration):** Seamless parity between default institutional copy and dynamic content overrides.
- **Architecture & Technical Impact:**
  - Pure domain additions: `VilaChicoBentoDefaultContent.bundle` containing 1:1 representations of current production copy (`app_pt.arb`, `AppConstants`, `AppAssets`).
  - Resilient loading in `SiteContentService.init()` and `AdminWorkspaceController.init()`: if Firestore returns empty and no draft exists, seed initial state with `VilaChicoBentoDefaultContent.bundle`.
  - Zero breaking changes to existing models, APIs, or database schemas.

---

## 3. Recommended Approach

- **Direct Adjustment:** Implement `VilaChicoBentoDefaultContent` within `lib/modules/admin/domain/vila_chico_bento_default_content.dart`.
- Configure `SiteContentService` to use `VilaChicoBentoDefaultContent.bundle` as default fallback.
- Update `VilaChicoBentoSchema` and `SiteContentService` test suites to verify default content initialization.

---

## 4. Detailed Artifact Changes

### 4.1 Spec Update (`_bmad/specs/spec-modulo-admin/SPEC.md`)
Added capability **CAP-7**:
- **intent:** The admin panel workspace initializes form inputs pre-populated with the official current site copy and assets if no Firestore data or draft has been saved yet.
- **success:** Opening `/admin` displays all section fields pre-filled with the actual production copy, allowing the operator to review and make minor edits without starting from blank inputs.

### 4.2 Story 1.4 Supplement (`_bmad/stories/1-4-dynamic-schema-driven-form-generator.md`)
- Added acceptance requirement: *Inputs initialize populated with `VilaChicoBentoDefaultContent.bundle` when remote content is not yet populated.*

---

## 5. Implementation Handoff

- **Recipient:** Developer Agent (`Amelia`).
- **Success Criteria:**
  1. Opening `/admin` in browser immediately shows all fields in accordions populated with the real Vila Chico Bento texts and links.
  2. Character counters reflect the loaded length of each pre-filled text.
  3. All tests in `test/modules/admin/` pass (100%).
  4. `flutter analyze` reports 0 issues.
