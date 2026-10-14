---
title: 'Story 1.5: Gallery Image Upload and Management via Firebase Storage'
type: 'feature'
created: '2026-09-21'
status: 'completed'
baseline_commit: 'a99d0a199cace6cf776dd3f6327b57843a1c149d'
route: 'dispatch'
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The administrative form generator currently displays a static notice card for `AdminFieldType.gallery` fields without supporting interactive photo selection, client-side size/format validation, direct upload to Firebase Storage, or reordering/deletion for up to 10 gallery photos.

**Approach:**
1. Create `StorageRepository` interface in domain and implement `FirebaseStorageRepository` in infrastructure with unit test mocks.
2. Build an `AdminGalleryFieldInput` widget replacing the temporary gallery notice in `DynamicFormGenerator`.
3. Provide client-side file validation (max 2MB, allowed extensions: jpg, jpeg, png, webp) and direct upload to `sites/{siteId}/gallery/` in Firebase Storage.
4. Support gallery item management: visual thumbnail preview, deletion, reordering (drag-and-drop or reorder controls), and enforcing the 10-photo maximum limit.
5. Dispatch updated photo URL lists on changes to `AdminWorkspaceController` / `SiteContentService`.

## Boundaries & Constraints

**Always:**
- Strictly enforce client-side file validation: max 2MB (`2 * 1024 * 1024` bytes) and allowed formats (`jpg`, `jpeg`, `png`, `webp`).
- Enforce the maximum item limit (up to 10 photos) according to `AdminField.maxItems`.
- Follow Nano Core layered architecture (`lib/modules/admin/domain`, `infrastructure`, `presentation`).
- Keep public storage paths scoped under `sites/{siteId}/gallery/`.

**Never:**
- Never block or crash the UI during upload failures; show inline snackbar/error feedback.
- Never exceed 10 items in the gallery list.
- Never modify unrelated landing page widgets or `nano_core` library code.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Select valid image | File <= 2MB, format jpg/png/webp | Uploads to Firebase Storage, appends URL to gallery list, updates draft | Show upload progress / spinner |
| File exceeds 2MB | File > 2MB | Rejects upload immediately before network request | Inline error: "Arquivo excede o limite de 2MB" |
| Invalid format | File with ext .gif, .pdf, .svg | Rejects upload immediately | Inline error: "Formato não suportado. Use JPG, PNG ou WebP" |
| Gallery limit reached | 10 photos already present | Upload button disabled or rejected | Notice: "Limite máximo de 10 fotos atingido" |
| Reorder images | Drag item from position A to B | Reorders list in state and dispatches change to workspace draft | Reverts order if error occurs |
| Delete image | Tap delete on thumbnail | Removes URL from gallery list and dispatches change | Prompt or immediate removal from active list |

</frozen-after-approval>

## Code Map

- `lib/modules/admin/domain/repositories/storage_repository.dart` -- Domain contract for storage uploads and deletion
- `lib/modules/admin/infrastructure/repositories/firebase_storage_repository.dart` -- Implementation utilizing `firebase_storage` package
- `lib/modules/admin/presentation/widgets/form/admin_gallery_field_input.dart` -- Interactive gallery management widget (grid/list, upload, reorder, delete)
- `lib/modules/admin/presentation/widgets/form/dynamic_form_generator.dart` -- Mount `AdminGalleryFieldInput` for `AdminFieldType.gallery`
- `lib/modules/admin/presentation/workspace/admin_workspace_injections.dart` -- Register `StorageRepository` / dependencies
- `test/modules/admin/admin_test_mocks.dart` -- Add mock for `StorageRepository`
- `test/modules/admin/presentation/widgets/admin_gallery_field_input_test.dart` -- Widget and unit tests for gallery validation, upload flow, reorder, delete

## Tasks & Acceptance

**Execution:**
- [x] `lib/modules/admin/domain/repositories/storage_repository.dart` -- Define `StorageRepository` interface -- Decouples media storage from UI and specific vendor
- [x] `lib/modules/admin/infrastructure/repositories/firebase_storage_repository.dart` -- Implement Firebase Storage uploads under `sites/{siteId}/gallery/` -- Vendor adapter
- [x] `lib/modules/admin/presentation/widgets/form/admin_gallery_field_input.dart` -- Create gallery widget with thumbnails, upload button, drag-and-drop/reorder, and delete -- UI for Story 1.5
- [x] `lib/modules/admin/presentation/widgets/form/dynamic_form_generator.dart` -- Wire `AdminGalleryFieldInput` into `_buildField` for `AdminFieldType.gallery` -- Replaces placeholder notice
- [x] `lib/modules/admin/presentation/workspace/admin_workspace_injections.dart` -- Register `StorageRepository` in Nano DI container -- Inversion of control
- [x] `test/modules/admin/presentation/widgets/admin_gallery_field_input_test.dart` -- Unit and widget tests for gallery management -- Ensure regression-free implementation

**Acceptance Criteria:**
- Given an operator in `/admin`, when viewing the Galeria section, then an interactive gallery manager is displayed with existing photos.
- Given a selected image <= 2MB with allowed format, when uploaded, then it appears in the gallery and updates the working draft.
- Given a file > 2MB or invalid format, when selected, then it is blocked before upload with clear feedback.
- Given up to 10 photos, when reordered or deleted, then the changes are reflected immediately in the preview state.

## Implementation Notes

- Defined `StorageRepository` in domain layer (`lib/modules/admin/domain/repositories/storage_repository.dart`) with `uploadImage` and `deleteImage`.
- Implemented `FirebaseStorageRepository` in infrastructure layer (`lib/modules/admin/infrastructure/repositories/firebase_storage_repository.dart`) with `firebase_storage` package uploading to `sites/{siteId}/gallery/`.
- Created `AdminGalleryFieldInput` widget (`lib/modules/admin/presentation/widgets/form/admin_gallery_field_input.dart`) with:
  - Client-side size validation (<= 2MB, rejects with inline warning).
  - Client-side format validation (`.jpg`, `.jpeg`, `.png`, `.webp`, rejects unsupported formats).
  - Item bound enforcement (up to 10 photos, disables upload when reached).
  - Thumbnail previews for remote HTTP URLs and local fallback assets.
  - Reordering (move up/down) and delete action buttons.
  - Testable `ImagePickerAdapter` interface.
- Mounted `AdminGalleryFieldInput` in `DynamicFormGenerator` for `AdminFieldType.gallery`, replacing the temporary placeholder card.
- Registered `StorageRepository` in `AppInjections` and added fallback binding in `AdminWorkspaceInjections`.
- Added `MockStorageRepository` and `MockImagePickerAdapter` in `test/modules/admin/admin_test_mocks.dart`.
- Added 9 unit/widget tests in `test/modules/admin/presentation/widgets/admin_gallery_field_input_test.dart` testing empty state, thumbnail list, format validation, size validation, 10-photo limit, reordering, deletion, and `DynamicFormGenerator` integration.
- 100% test pass rate across 38 admin tests, 0 linter issues.

## Spec Change Log

## Review Triage Log

## Verification

**Commands:**
- `flutter test test/modules/admin/` -- expected: All admin tests pass (100%)
- `flutter analyze` -- expected: 0 issues found
