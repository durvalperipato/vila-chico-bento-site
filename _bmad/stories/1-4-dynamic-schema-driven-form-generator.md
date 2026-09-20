---
title: 'Story 1.4: Dynamic Schema-Driven Form Generator'
type: 'feature'
created: '09-19-2026'
status: 'completed'
route: 'oneshot'
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The administrative workspace needs a dynamic form generator that parses any `SiteSchema` (specifically `VilaChicoBentoSchema`) and generates reactive, schema-driven input widgets with length validation, character counters, and live draft updates on keystroke, eliminating the need to write custom form screens for each site.

**Approach:**
1. Implement `DynamicFormGenerator` and dedicated field input widgets (`AdminTextFieldInput`, `AdminListFieldInput`, `AdminSectionAccordion`) under `lib/modules/admin/presentation/widgets/form/`.
2. Ensure inputs dispatch changes directly to `SiteContentService` on keystroke (`updatePreview(key, value)`), providing instant reactivity for the upcoming split-screen preview.
3. Build `AdminWorkspaceController`, `AdminWorkspaceState`, and `AdminWorkspaceInjections` utilizing canonical Nano Core patterns (`NanoStatePage`, `NanoController`, `NanoInjections`, `NanoScaffold`).
4. Mount `DynamicFormGenerator` in `AdminGuardPage` / `AdminWorkspaceView` replacing the temporary placeholder.
5. Create comprehensive widget and unit tests verifying dynamic schema rendering, character counting, and validation feedback.

</frozen-after-approval>

## Implementation Notes

- Implemented `AdminTextFieldInput` (`lib/modules/admin/presentation/widgets/form/admin_text_field_input.dart`):
  - Live keystroke dispatch via `onChanged`.
  - Enforces `maxLength` bounds with visible character counter `${currentLength} / ${maxLength}`.
  - Multi-line support and dark/light mode thematic styling.
- Implemented `AdminSectionAccordion` (`lib/modules/admin/presentation/widgets/form/admin_section_accordion.dart`):
  - Collapsible card container with animated arrow rotation and section field count badge.
- Implemented `DynamicFormGenerator` (`lib/modules/admin/presentation/widgets/form/dynamic_form_generator.dart`):
  - Iterates over schema sections and fields.
  - Generates reactive inputs for `text`, `image`, and nested `list` fields, with informative notice cards for gallery fields.
- Implemented canonical Nano Core workspace structure:
  - `AdminWorkspaceState` with immutable `bundle` and `hasUnsavedChanges` flag.
  - `WorkspaceMessages` implementing `NanoMessageKey`.
  - `AdminWorkspaceController` managing `updateField`, `saveDraft`, `publish`, and `signOut` via `NanoController.execute` and `emitLoaded`/`emitSuccess`.
  - `AdminWorkspaceInjections` configuring scoped singletons (`SiteContentRepository`, `SiteContentService`, `AdminWorkspaceController`).
  - `AdminWorkspaceView` built with `NanoStatePage` and `NanoScaffold`.
- Mounted `AdminWorkspaceView` in `AdminGuardPage` when user is authenticated.
- Unit and widget tests:
  - 26 tests in `test/modules/admin/` covering schema generation, accordion toggling, keystroke dispatch, draft saving, publishing, and workspace UI.
  - 100% test pass rate across the full project test suite.
  - 0 linter issues in `lib/modules/admin/` and `test/modules/admin/`.

- **Course Correction (2026-09-20 / CAP-7):**
  - Integrated `VilaChicoBentoDefaultContent.bundle` as seed fallback in `SiteContentService` and `AdminWorkspaceController`.
  - When opening `/admin` without existing Firestore document or draft, form fields load pre-filled with the official live site copy and assets instead of empty blanks.

