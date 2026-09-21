import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/admin_field.dart';
import '../../../domain/admin_field_type.dart';
import '../../../domain/admin_section_group.dart';
import '../../../domain/entities/content_bundle.dart';
import '../../../domain/site_schema.dart';
import 'admin_gallery_field_input.dart';
import 'admin_section_accordion.dart';
import 'admin_text_field_input.dart';

/// Dynamic schema-driven form generator converting [SiteSchema]
/// into reactive inputs.
class DynamicFormGenerator extends StatelessWidget {
  const DynamicFormGenerator({
    required this.schema,
    required this.bundle,
    required this.onFieldChanged,
    this.onUploadImage,
    this.imagePickerAdapter,
    super.key,
  });

  final SiteSchema schema;
  final ContentBundle bundle;
  final void Function(String key, dynamic value) onFieldChanged;
  final GalleryImageUploader? onUploadImage;
  final ImagePickerAdapter? imagePickerAdapter;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: schema.sections.length,
      itemBuilder: (context, index) {
        final section = schema.sections[index];
        return _buildSection(context, section);
      },
    );
  }

  Widget _buildSection(BuildContext context, AdminSectionGroup section) {
    return AdminSectionAccordion(
      key: ValueKey(section.id),
      section: section,
      children: section.fields.map((field) {
        return _buildField(context, field);
      }).toList(),
    );
  }

  Widget _buildField(BuildContext context, AdminField field) {
    switch (field.type) {
      case AdminFieldType.text:
        final initialValue = bundle.getString(field.key, fallback: '');
        return AdminTextFieldInput(
          key: ValueKey(field.key),
          field: field,
          initialValue: initialValue,
          onChanged: (value) => onFieldChanged(field.key, value),
        );

      case AdminFieldType.image:
        final initialValue = bundle.getString(field.key, fallback: '');
        return AdminTextFieldInput(
          key: ValueKey(field.key),
          field: field,
          initialValue: initialValue,
          onChanged: (value) => onFieldChanged(field.key, value),
        );

      case AdminFieldType.gallery:
        final initialUrls = bundle.getStringList(field.key, fallback: const []);
        return AdminGalleryFieldInput(
          key: ValueKey(field.key),
          field: field,
          initialUrls: initialUrls,
          onUploadImage: onUploadImage ??
              ({
                required bytes,
                required fileName,
                required contentType,
              }) async {
                throw UnsupportedError(
                  'onUploadImage was not provided.',
                );
              },
          imagePickerAdapter:
              imagePickerAdapter ?? const DefaultImagePickerAdapter(),
          onChanged: (value) => onFieldChanged(field.key, value),
        );

      case AdminFieldType.list:
        return _buildListField(context, field);
    }
  }


  Widget _buildListField(BuildContext context, AdminField field) {
    final isDark = Theme.of(context).brightness == Theme.of(context).brightness;
    final items = bundle.getListMap(field.key, fallback: const []);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                field.label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(isDark),
                ),
              ),
              const Spacer(),
              Text(
                '${items.length} itens cadastrados',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textMuted(isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.asMap().entries.map((entry) {
            final idx = entry.key;
            final itemMap = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgCard(isDark),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderSubtle(isDark)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item ${idx + 1}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...field.itemFields.map((subField) {
                    final subKey = subField.key;
                    final subVal = itemMap[subKey]?.toString() ?? '';

                    return AdminTextFieldInput(
                      key: ValueKey('${field.key}_${idx}_$subKey'),
                      field: subField,
                      initialValue: subVal,
                      onChanged: (newSubVal) {
                        final updatedList = List<Map<String, dynamic>>.from(
                          items.map(Map<String, dynamic>.from),
                        );
                        while (updatedList.length <= idx) {
                          updatedList.add(<String, dynamic>{});
                        }
                        updatedList[idx][subKey] = newSubVal;
                        onFieldChanged(field.key, updatedList);
                      },
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
