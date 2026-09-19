import 'package:flutter_test/flutter_test.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/domain.dart';

void main() {
  group('AdminField Tests', () {
    test('text field instantiation and validation', () {
      final field = AdminField.text(
        key: 'hero.title',
        label: 'Hero Title',
        maxLength: 20,
        required: true,
      );

      expect(field.key, 'hero.title');
      expect(field.label, 'Hero Title');
      expect(field.type, AdminFieldType.text);
      expect(field.required, isTrue);
      expect(field.maxLength, 20);

      // Validation
      expect(field.validate(null), isNotNull);
      expect(field.validate(''), isNotNull);
      expect(field.validate('   '), isNotNull);
      expect(field.validate('Valid Title'), isNull);
      expect(
        field.validate('A very long title that definitely exceeds twenty characters'),
        isNotNull,
      );
    });

    test('image field default parameters', () {
      final imageField = AdminField.image(
        key: 'hero.banner',
        label: 'Banner Image',
      );

      expect(imageField.type, AdminFieldType.image);
      expect(imageField.maxSizeMB, 2.0);
      expect(imageField.allowedExtensions, contains('webp'));
      expect(imageField.validate(null), isNull); // not required by default
    });

    test('gallery field enforces max items', () {
      final galleryField = AdminField.gallery(
        key: 'gallery.images',
        label: 'Gallery',
        maxItems: 3,
      );

      expect(galleryField.type, AdminFieldType.gallery);
      expect(galleryField.maxItems, 3);
      expect(galleryField.validate(['img1', 'img2']), isNull);
      expect(galleryField.validate(['img1', 'img2', 'img3']), isNull);
      expect(
        galleryField.validate(['img1', 'img2', 'img3', 'img4']),
        isNotNull,
      );
    });

    test('list field with nested itemFields', () {
      final listField = AdminField.list(
        key: 'services.items',
        label: 'Services',
        maxItems: 2,
        itemFields: [
          AdminField.text(key: 'title', label: 'Title', required: true),
          AdminField.text(key: 'desc', label: 'Desc'),
        ],
      );

      expect(listField.type, AdminFieldType.list);
      expect(listField.itemFields.length, 2);
      expect(listField.validate([{'title': 'S1'}]), isNull);
      expect(
        listField.validate([{'title': 'S1'}, {'title': 'S2'}, {'title': 'S3'}]),
        isNotNull,
      );
    });
  });

  group('AdminSectionGroup Tests', () {
    test('findField locates direct and nested item fields', () {
      final section = AdminSectionGroup(
        id: 'services',
        title: 'Services',
        icon: 'build',
        fields: [
          AdminField.text(key: 'services.title', label: 'Title'),
          AdminField.list(
            key: 'services.items',
            label: 'Items',
            itemFields: [
              AdminField.text(key: 'item.name', label: 'Item Name'),
            ],
          ),
        ],
      );

      expect(section.findField('services.title'), isNotNull);
      expect(section.findField('item.name'), isNotNull);
      expect(section.findField('non.existent'), isNull);
    });
  });

  group('SiteSchema Tests', () {
    test('allKeys collects registered keys from all sections', () {
      final schema = SiteSchema(
        siteId: 'test-site',
        sections: [
          AdminSectionGroup(
            id: 'sec1',
            title: 'Sec 1',
            icon: 'icon1',
            fields: [
              AdminField.text(key: 'sec1.f1', label: 'F1'),
              AdminField.text(key: 'sec1.f2', label: 'F2'),
            ],
          ),
          AdminSectionGroup(
            id: 'sec2',
            title: 'Sec 2',
            icon: 'icon2',
            fields: [
              AdminField.image(key: 'sec2.img', label: 'Img'),
            ],
          ),
        ],
      );

      expect(schema.siteId, 'test-site');
      expect(schema.allKeys, ['sec1.f1', 'sec1.f2', 'sec2.img']);
      expect(schema.getSection('sec1')?.title, 'Sec 1');
      expect(schema.getSection('sec3'), isNull);
      expect(schema.findField('sec2.img'), isNotNull);
    });
  });

  group('VilaChicoBentoSchema Concrete Tests', () {
    test('validates Vila Chico Bento canonical schema', () {
      final schema = VilaChicoBentoSchema.schema;

      expect(schema.siteId, 'vila-chico-bento');
      expect(schema.sections.length, 6);

      final sectionIds = schema.sections.map((s) => s.id).toList();
      expect(sectionIds, [
        'hero',
        'about',
        'services',
        'gallery',
        'location',
        'contact',
      ]);

      // Verify specific load-bearing fields
      expect(schema.findField('hero.title')?.required, isTrue);
      expect(schema.findField('hero.banner_image')?.type, AdminFieldType.image);
      expect(schema.findField('gallery.images')?.maxItems, 10);
      expect(schema.findField('services.items')?.maxItems, 6);
      expect(schema.findField('contact.whatsapp_number'), isNotNull);
    });
  });
}
