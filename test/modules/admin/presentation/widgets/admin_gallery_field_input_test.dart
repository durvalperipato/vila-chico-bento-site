import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/admin_field.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/admin_section_group.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/admin_section_icon.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/entities/content_bundle.dart';
import 'package:vila_chico_bento_site/modules/admin/domain/site_schema.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/widgets/form/admin_gallery_field_input.dart';
import 'package:vila_chico_bento_site/modules/admin/presentation/widgets/form/dynamic_form_generator.dart';
import '../../admin_test_mocks.dart';

void main() {
  group('AdminGalleryFieldInput Widget Tests', () {
    late MockStorageRepository mockStorage;
    late MockImagePickerAdapter mockPicker;
    late AdminField galleryField;

    setUp(() {
      mockStorage = MockStorageRepository();
      mockPicker = MockImagePickerAdapter();
      galleryField = AdminField.gallery(
        key: 'gallery.images',
        label: 'Fotos do Espaço e Cães',
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      );
    });

    Widget createWidget({
      List<String> initialUrls = const [],
      ValueChanged<List<String>>? onChanged,
      AdminField? field,
      GalleryImageUploader? onUploadImage,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: AdminGalleryFieldInput(
              field: field ?? galleryField,
              initialUrls: initialUrls,
              onUploadImage: onUploadImage ??
                  ({
                    required bytes,
                    required fileName,
                    required contentType,
                  }) =>
                      mockStorage.uploadImage(
                        path: 'sites/test/gallery/$fileName',
                        bytes: bytes,
                        contentType: contentType,
                      ),
              imagePickerAdapter: mockPicker,
              onChanged: onChanged ?? (_) {},
            ),
          ),
        ),
      );
    }

    testWidgets(
      'renders empty state when initialUrls is empty',
      (tester) async {
        await tester.pumpWidget(createWidget(initialUrls: []));
        await tester.pumpAndSettle();

        expect(find.text('Fotos do Espaço e Cães'), findsOneWidget);
        expect(find.text('0 / 10 fotos'), findsOneWidget);
        expect(find.text('Nenhuma foto adicionada à galeria.'), findsOneWidget);
        expect(find.text('Adicionar Foto'), findsOneWidget);
      },
    );

    testWidgets('renders photo cards for initial URLs', (tester) async {
      final initial = [
        'https://images.unsplash.com/photo-1?q=80',
        'https://images.unsplash.com/photo-2?q=80',
      ];

      await tester.pumpWidget(createWidget(initialUrls: initial));
      await tester.pumpAndSettle();

      expect(find.text('2 / 10 fotos'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsNWidgets(2));
      expect(find.byIcon(Icons.arrow_upward), findsNWidgets(2));
      expect(find.byIcon(Icons.arrow_downward), findsNWidgets(2));
    });

    testWidgets(
      'Matrix Scenario 1: Selects and uploads valid image <= 2MB with format',
      (tester) async {
      List<String>? updatedUrls;
      mockPicker.pickedFile = XFile.fromData(
        Uint8List.fromList(List.generate(1024, (i) => i % 256)), // 1 KB
        name: 'dog_playground.jpg',
        path: 'dog_playground.jpg',
      );

      await tester.pumpWidget(createWidget(
        initialUrls: ['https://example.com/existing.jpg'],
        onChanged: (urls) => updatedUrls = urls,
      ));
      await tester.pumpAndSettle();

      expect(find.text('1 / 10 fotos'), findsOneWidget);

      await tester.tap(find.text('Adicionar Foto'));
      await tester.pumpAndSettle();

      expect(mockStorage.uploadedPaths.length, 1);
      expect(mockStorage.uploadedPaths.first, contains('gallery/'));
      expect(mockStorage.uploadedPaths.first, contains('dog_playground.jpg'));

      expect(updatedUrls, isNotNull);
      expect(updatedUrls!.length, 2);
      expect(updatedUrls!.last, mockStorage.returnUrl);
      expect(find.text('2 / 10 fotos'), findsOneWidget);
    });

    testWidgets('Matrix Scenario 2: Rejects file exceeding 2MB before upload',
        (tester) async {
      // 2.5 MB file
      final largeBytes = Uint8List(2500 * 1024);
      mockPicker.pickedFile = XFile.fromData(
        largeBytes,
        name: 'huge_banner.jpg',
        path: 'huge_banner.jpg',
      );

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Adicionar Foto'));
      await tester.pumpAndSettle();

      expect(mockStorage.uploadedPaths, isEmpty);
      expect(find.text('Arquivo excede o limite de 2MB.'), findsOneWidget);
    });

    testWidgets('Matrix Scenario 3: Rejects invalid file format (e.g. .gif / .pdf)',
        (tester) async {
      mockPicker.pickedFile = XFile.fromData(
        Uint8List(500),
        name: 'animation.gif',
        path: 'animation.gif',
      );

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Adicionar Foto'));
      await tester.pumpAndSettle();

      expect(mockStorage.uploadedPaths, isEmpty);
      expect(
        find.text('Formato não suportado. Use JPG, PNG ou WebP.'),
        findsOneWidget,
      );
    });

    testWidgets('Matrix Scenario 4: Enforces gallery limit of 10 photos',
        (tester) async {
      final tenPhotos = List.generate(10, (i) => 'https://example.com/photo_$i.jpg');

      await tester.pumpWidget(createWidget(initialUrls: tenPhotos));
      await tester.pumpAndSettle();

      expect(find.text('10 / 10 fotos'), findsOneWidget);
      expect(find.text('Limite atingido'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('Matrix Scenario 5: Reorders images moving up and down',
        (tester) async {
      List<String>? updatedUrls;
      final initial = [
        'https://example.com/first.jpg',
        'https://example.com/second.jpg',
        'https://example.com/third.jpg',
      ];

      await tester.pumpWidget(createWidget(
        initialUrls: initial,
        onChanged: (urls) => updatedUrls = urls,
      ));
      await tester.pumpAndSettle();

      // Tap move down on item 1 (index 0)
      final downButtons = find.byTooltip('Mover para baixo');
      await tester.tap(downButtons.first);
      await tester.pumpAndSettle();

      expect(updatedUrls, isNotNull);
      expect(updatedUrls![0], 'https://example.com/second.jpg');
      expect(updatedUrls![1], 'https://example.com/first.jpg');
      expect(updatedUrls![2], 'https://example.com/third.jpg');

      // Tap move up on the new item 2 (formerly item 1)
      final upButtons = find.byTooltip('Mover para cima');
      await tester.tap(upButtons.at(1));
      await tester.pumpAndSettle();

      expect(updatedUrls![0], 'https://example.com/first.jpg');
      expect(updatedUrls![1], 'https://example.com/second.jpg');
    });

    testWidgets('Matrix Scenario 6: Deletes image when delete button is tapped',
        (tester) async {
      List<String>? updatedUrls;
      final initial = [
        'https://example.com/photo1.jpg',
        'https://example.com/photo2.jpg',
      ];

      await tester.pumpWidget(createWidget(
        initialUrls: initial,
        onChanged: (urls) => updatedUrls = urls,
      ));
      await tester.pumpAndSettle();

      expect(find.text('2 / 10 fotos'), findsOneWidget);

      final deleteButtons = find.byTooltip('Excluir foto');
      await tester.tap(deleteButtons.first);
      await tester.pumpAndSettle();

      expect(updatedUrls, isNotNull);
      expect(updatedUrls!.length, 1);
      expect(updatedUrls!.first, 'https://example.com/photo2.jpg');
      expect(find.text('1 / 10 fotos'), findsOneWidget);
    });

    testWidgets(
      'DynamicFormGenerator renders AdminGalleryFieldInput for gallery field',
      (tester) async {
        final schema = SiteSchema(
        siteId: 'test-site',
        sections: [
          AdminSectionGroup(
            id: 'gallery',
            title: 'Galeria',
            icon: AdminSectionIcon.photoLibrary,
            fields: [galleryField],
          ),
        ],
      );

      final bundle = ContentBundle.fromMap({
        'gallery': {
          'images': ['https://example.com/dog1.jpg'],
        },
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormGenerator(
                schema: schema,
                bundle: bundle,
                onUploadImage: ({
                  required bytes,
                  required fileName,
                  required contentType,
                }) =>
                    mockStorage.uploadImage(
                      path: 'sites/test/gallery/$fileName',
                      bytes: bytes,
                      contentType: contentType,
                    ),
                imagePickerAdapter: mockPicker,
                onFieldChanged: (_, __) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdminGalleryFieldInput), findsOneWidget);
      expect(find.text('1 / 10 fotos'), findsOneWidget);
    });
  });
}
