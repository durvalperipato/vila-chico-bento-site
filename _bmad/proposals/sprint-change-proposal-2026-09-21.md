# Sprint Change Proposal: Canonical Responsiveness and Clean Widget Architecture

**Date:** 2026-09-21  
**Project:** Vila Chico Bento Site  
**Status:** Approved  
**Scope:** Minor / Direct Implementation (Developer)  

---

## 1. Issue Summary

During the development and testing of Epic 1 (**Schema-Driven Admin Module & Live Preview Engine**), two important architectural advancements were integrated into the project:
1. **`NanoResponsiveLayout` Availability in `nano_core` (v1.0.8):** A new canonical layout component was introduced to handle multiplatform adaptive views (`mobile < 600dp`, `tablet 600..1023dp`, `desktop >= 1024dp`) and dynamic axis switching (`NanoResponsiveLayout.flex`).
2. **Component Architecture Rule (Elimination of `Widget _build...()` Boilerplate):** Visual components were historically using helper methods returning `Widget` within the main view class. To comply with clean architecture principles, views must avoid `Widget _build...()` methods and instead compose dedicated, modular `StatelessWidget` / `StatefulWidget` classes placed under `{feature}/widgets/`.

---

## 2. Impact Analysis

- **Epic Impact:** Epic 1 remains 100% viable. The change strengthens the codebase maintainability, readibility, and future-proofs the admin module for the broader Nano Sites Engine.
- **Story Impact:**
  - **Story 1.6 (Split-Screen Live Preview and Publishing Workflow):** Formally updated to document `NanoResponsiveLayout` and modular widgets.
  - **Story 1.7 (Landing Page Integration with Content Service and Canonical Responsiveness):** Expanded to incorporate `NanoResponsiveLayout` across public landing page sections.
- **Artifacts Modified:**
  - `pubspec.yaml`: `nano_core` updated to local development path `/Users/durvalperipatoneto/Projects/nano-core` (v1.0.8-dev).
  - `_bmad/specs/spec-modulo-admin/SPEC.md`: Added **CAP-8** and explicit architecture constraint forbidding `Widget _build...()` methods.
  - `_bmad/epics.md`: Updated Story 1.7 scope.
  - `_bmad/stories/1-6-split-screen-live-preview-and-publishing-workflow.md`: Synchronized implementation notes.
  - `lib/modules/admin/presentation/workspace/`:
    - `admin_workspace_view.dart`: Clean declarative `NanoResponsiveLayout` composition.
    - `widgets/admin_desktop_split_screen.dart`: Dedicated desktop split-screen widget.
    - `widgets/admin_mobile_adaptive_layout.dart`: Dedicated mobile adaptive layout widget.
    - `widgets/admin_workspace_form_content.dart`: Dedicated reusable form generator container.

---

## 3. Recommended Approach

- **Direct Adjustment:** Implement the changes directly within the active codebase and existing stories without replanning epics or modifying sprint status.
- Extract view helper methods into isolated components in `lib/modules/admin/presentation/workspace/widgets/`.
- Validate via full automated test suite (`flutter test test/modules/admin/`) and static analysis (`flutter analyze`).

---

## 4. Verification & Results

- **Automated Tests:** 47/47 unit and widget tests passed (100% pass rate).
- **Static Analysis:** `flutter analyze` reports 0 issues.
- **Functional Fidelity:** Desktop split-screen (>= 1024px) and mobile adaptive segmented control (< 1024px) maintain 100% behavioral parity with existing UX specifications.

---

## 5. Implementation Handoff

- **Recipient:** Developer Agent (`Amelia`).
- **Next Steps:** Proceed to implementation of **Story 1.7** (Landing Page Integration with Content Service and Canonical Responsiveness) following the newly established architectural constraints.
