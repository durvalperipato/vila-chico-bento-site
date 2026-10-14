# Declarative Field Catalog (Schema-Driven Engine)

This catalog specifies the declarative data structures consumed by the dynamic Admin Form Generator and the public Landing Page.

## Schema Architecture

Each website defines a declarative configuration file (e.g., `lib/modules/admin/domain/site_schema.dart`) containing a list of `AdminSectionGroup` items:

```dart
class AdminSectionGroup {
  final String id;
  final String title;
  final String icon;
  final List<AdminField> fields;

  const AdminSectionGroup({
    required this.id,
    required this.title,
    required this.icon,
    required this.fields,
  });
}
```

## Supported Field Types

### 1. `AdminField.text`
- **Purpose:** Headlines, subheadings, taglines, URLs, and phone numbers.
- **Parameters:**
  - `key` (String): Content lookup key (e.g., `'hero.title'`).
  - `label` (String): Label displayed in the form input.
  - `maxLength` (int): Maximum character length limit.
  - `maxLines` (int): Input field line count (1 for titles, 3-4 for paragraphs).
  - `required` (bool): Whether the field cannot be submitted blank.

### 2. `AdminField.image`
- **Purpose:** Featured image, logo, or main hero banner.
- **Parameters:**
  - `key` (String): Content lookup key (e.g., `'hero.banner_url'`).
  - `label` (String): Form upload label.
  - `maxSizeMB` (double): File size limit (default 2.0MB).
  - `allowedExtensions` (List<String>): Valid image formats (`['jpg', 'jpeg', 'png', 'webp']`).

### 3. `AdminField.gallery`
- **Purpose:** Photo gallery for facilities, spaces, or past work.
- **Parameters:**
  - `key` (String): Content lookup key (e.g., `'gallery.images'`).
  - `label` (String): Gallery section heading.
  - `maxItems` (int): Maximum allowable uploaded photos (default 10).
  - `maxSizeMB` (double): Max file size per photo (2.0MB).

### 4. `AdminField.list`
- **Purpose:** Repeating item cards (e.g., Services, Highlights, Features).
- **Parameters:**
  - `key` (String): Content lookup key (e.g., `'services.items'`).
  - `label` (String): Section heading.
  - `itemFields` (List<AdminField>): Schema definition for each item (e.g., title and description).
  - `maxItems` (int): Maximum number of allowable items in the list.

## Consumption Pattern on Landing Page

Landing Page widgets read content via a reactive content service with mandatory fallback:

```dart
content.getString('hero.title', fallback: AppConstants.heroTitle);
content.getString('hero.subtitle', fallback: AppConstants.heroSubtitle);
content.getImageUrl('hero.banner_url', fallback: 'assets/images/hero.webp');
content.getStringList('gallery.images', fallback: AppConstants.defaultGalleryImages);
```
