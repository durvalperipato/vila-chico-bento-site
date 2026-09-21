---
title: 'Story 1.6: Split-Screen Live Preview and Publishing Workflow'
type: 'feature'
created: '2026-09-21'
status: 'done'
baseline_commit: '44e73ecdfca72b5b184070d3229e0281e0b29198'
route: 'dispatch'
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The administrative panel at `/admin` currently presents only a single-column editing form without visual feedback. The operator cannot observe how their copy edits and gallery changes look on the actual site before publishing, increasing anxiety and risk of errors on the live website.

**Approach:**
1. Implement a responsive desktop split-screen layout in `AdminWorkspaceView`: form inputs on the left pane and real-time live site preview on the right pane.
2. Build an `AdminLivePreview` widget that subscribes to the reactive `SiteContentService` / `bundle` and renders site sections (Hero, About, Services, Gallery, Location, Contact CTA, Footer) with current draft values and fallback to default content.
3. Equip the preview pane with responsive viewport toggles (Desktop, Tablet, Mobile) allowing operators to verify visual layout across different screen sizes.
4. Provide graceful mobile/tablet adaptation: when viewport width is below desktop threshold (< 1024px), provide a toggle (e.g. segmented control or preview tab) to switch seamlessly between Editor and Preview modes.
5. Provide draft persistence and publishing workflow with clear visual indicators for unsaved changes vs published status, draft saving, and live publishing confirmation.

## Boundaries & Constraints

**Always:**
- Keep changes reactive: field edits immediately update the preview pane via `SiteContentService.updatePreview`.
- Maintain public visitor isolation: changes remain in working draft until the operator explicitly clicks 'Publish' (`SiteContentService.publish`).
- Follow Nano Core conventions (`NanoStatePage`, `NanoController`, `NanoInjections`) under `lib/modules/admin/`.
- Ensure responsive adaptation: seamless split-screen on desktop (>= 1024px) and clean tab/switch navigation on mobile (< 1024px).
- Provide visual fallback: if any bundle field is absent or empty, preview components render official defaults without throwing errors.

**Never:**
- Never modify production Firestore documents on field keystrokes (only on explicit "Publish").
- Never break or alter the core public `HomePage` code in this story (Story 1.7 is dedicated to landing page public integration).
- Never introduce dependencies on external webview plugins or iframe hacks; render native Flutter preview widgets.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Desktop viewport (>= 1024px) | Window width 1280px | Split-screen layout: Form on left, Live Preview on right | Preserves scroll positions independently |
| Mobile viewport (< 1024px) | Window width 600px | Single pane with segmented switch (Editor / Preview) | Allows toggling between editor and full preview |
| Real-time keystroke update | Operator types headline in Hero title field | Live preview immediately reflects updated text in Hero section | Fallback to default if text cleared |
| Viewport simulation toggle | Operator taps 'Mobile' icon in preview toolbar | Preview container constrains to mobile frame (e.g. 375px) with device styling | Centers frame with smooth transition |
| Save draft | Operator clicks 'Salvar Rascunho' | Persists draft to repository, shows success snackbar | Shows error snackbar if save fails |
| Publish live | Operator clicks 'Publicar no Site' | Shows confirmation or publishes to Firestore, sets hasUnsavedChanges to false | Shows error snackbar if publish fails |

</frozen-after-approval>

## Code Map

- `lib/modules/admin/presentation/workspace/admin_workspace_view.dart` -- Refactor layout to support desktop split-screen (Editor + Preview) and mobile mode switching (Editor / Preview tabs)
- `lib/modules/admin/presentation/workspace/admin_workspace_controller.dart` -- Add viewport simulation mode state (Desktop, Tablet, Mobile) and mobile view mode (Editor, Preview)
- `lib/modules/admin/presentation/workspace/admin_workspace_state.dart` -- Include preview mode and simulated device dimensions in state
- `lib/modules/admin/presentation/workspace/widgets/admin_live_preview.dart` -- Live preview container with device frame, zoom/scale or viewport sizing, and section renderer
- `lib/modules/admin/presentation/workspace/widgets/admin_preview_toolbar.dart` -- Toolbar with Desktop/Tablet/Mobile switcher and live preview indicator
- `lib/l10n/app_en.arb` & `lib/l10n/app_pt.arb` -- Localization strings for preview toolbar, viewport modes, and mobile view toggle
- `test/modules/admin/presentation/admin_workspace_preview_test.dart` -- Widget tests for split-screen layout, mobile toggle, live preview reactivity, and viewport simulation

## Tasks & Acceptance

**Execution:**
- [x] `lib/l10n/app_en.arb` & `lib/l10n/app_pt.arb` -- Add localization keys for live preview, viewport switcher, and mobile preview tabs
- [x] `lib/modules/admin/presentation/workspace/admin_workspace_state.dart` -- Add `PreviewDeviceType` and `AdminViewMode` to `AdminWorkspaceState`
- [x] `lib/modules/admin/presentation/workspace/admin_workspace_controller.dart` -- Add methods to switch preview device and mobile view mode
- [x] `lib/modules/admin/presentation/workspace/widgets/admin_preview_toolbar.dart` -- Build toolbar widget with device viewport toggles (Desktop, Tablet, Mobile)
- [x] `lib/modules/admin/presentation/workspace/widgets/admin_live_preview.dart` -- Build live preview widget rendering site sections with draft content bundle
- [x] `lib/modules/admin/presentation/workspace/admin_workspace_view.dart` -- Integrate split-screen layout on desktop and tabbed/segmented navigation on mobile
- [x] `test/modules/admin/presentation/admin_workspace_preview_test.dart` -- Comprehensive unit and widget tests for split-screen, reactivity, and responsiveness

**Acceptance Criteria:**
- Given a desktop viewport (>= 1024px), when navigating to `/admin`, then form inputs appear on the left and the live preview appears on the right.
- Given an operator modifying any form field, when typing, then the live preview pane immediately reflects the updated value in real time.
- Given the live preview toolbar, when toggling between Desktop, Tablet, and Mobile, then the preview frame resizes accordingly.
- Given a mobile viewport (< 1024px), when viewing `/admin`, then the operator can toggle between the Editor form and the Live Preview.
- Given unsaved edits, when clicking 'Salvar Rascunho', then the draft is saved; when clicking 'Publicar no Site', then changes are committed to Cloud Firestore.

## Implementation Notes

- Added localization strings in `lib/l10n/arb/app_pt.arb` and `lib/l10n/arb/app_en.arb` for live preview, device viewports (Desktop, Tablet, Mobile), and mobile navigation tabs (Editor / Preview). Regenerated Flutter localizations.
- Added `PreviewDeviceType` (desktop, tablet, mobile) and `AdminViewMode` (editor, preview) enums and properties to `AdminWorkspaceState`.
- Implemented `setPreviewDevice` and `setViewMode` on `AdminWorkspaceController`.
- Built `AdminPreviewToolbar` featuring a live preview indicator and responsive device frame toggles.
- Built `AdminLivePreview` which renders site sections (Hero, About, Services, Gallery, Location, Footer) reactively using the draft `ContentBundle` with automatic fallback to `VilaChicoBentoDefaultContent.bundle`. Supports simulated Desktop (full-bleed), Tablet (768px with frame), and Mobile (375px with smartphone bezel).
- Refactored `AdminWorkspaceView` using `LayoutBuilder`:
  - Desktop viewports (>= 1024px) render split-screen with the form editor on the left and the live preview on the right.
  - Mobile viewports (< 1024px) provide a segmented button to toggle smoothly between the form editor and live preview, with compact AppBar actions to avoid overflow.
- Authored 9 unit and widget tests in `test/modules/admin/presentation/admin_workspace_preview_test.dart` verifying all 6 matrix scenarios.
- 100% test pass rate across 47 admin tests, 0 analyzer issues in admin module.

## Spec Change Log

## Review Triage Log

## Verification

**Commands:**
- `flutter test test/modules/admin/` -- expected: All admin module unit and widget tests pass (100%)
- `flutter analyze` -- expected: 0 issues found
