import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/admin_field.dart';

/// Callback signature for uploading gallery images.
typedef GalleryImageUploader = Future<String> Function({
  required Uint8List bytes,
  required String fileName,
  required String contentType,
});

/// Adapter interface for image selection to enable mockability in tests.
abstract class ImagePickerAdapter {
  Future<XFile?> pickImage();
}

/// Default implementation utilizing [ImagePicker].
class DefaultImagePickerAdapter implements ImagePickerAdapter {
  const DefaultImagePickerAdapter();

  @override
  Future<XFile?> pickImage() {
    return ImagePicker().pickImage(source: ImageSource.gallery);
  }
}

/// Interactive gallery management widget supporting:
/// - Client-side validation (max size <= 2MB, allowed extensions)
/// - Delegated upload via [GalleryImageUploader]
/// - Max item bounds enforcement (up to 10 photos)
/// - Visual thumbnail previews
/// - Reordering and deletion with reactive callback dispatch
class AdminGalleryFieldInput extends StatefulWidget {
  const AdminGalleryFieldInput({
    required this.field,
    required this.initialUrls,
    required this.onChanged,
    required this.onUploadImage,
    this.imagePickerAdapter = const DefaultImagePickerAdapter(),
    super.key,
  });

  final AdminField field;
  final List<String> initialUrls;
  final ValueChanged<List<String>> onChanged;
  final GalleryImageUploader onUploadImage;
  final ImagePickerAdapter imagePickerAdapter;

  @override
  State<AdminGalleryFieldInput> createState() => _AdminGalleryFieldInputState();
}

class _AdminGalleryFieldInputState extends State<AdminGalleryFieldInput> {
  late List<String> _images;
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _images = List<String>.from(widget.initialUrls);
  }

  @override
  void didUpdateWidget(covariant AdminGalleryFieldInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialUrls != widget.initialUrls) {
      _images = List<String>.from(widget.initialUrls);
    }
  }

  int get _maxItems => widget.field.maxItems ?? 10;
  double get _maxSizeMB => widget.field.maxSizeMB ?? 2.0;
  List<String> get _allowedExtensions => widget.field.allowedExtensions;

  Future<void> _pickAndUploadImage() async {
    setState(() => _errorMessage = null);

    if (_images.length >= _maxItems) {
      setState(() {
        _errorMessage = 'Limite máximo de $_maxItems fotos atingido.';
      });
      return;
    }

    try {
      final file = await widget.imagePickerAdapter.pickImage();
      if (file == null) return;

      // 1. Validate file extension
      final fileName = file.name.isNotEmpty
          ? file.name
          : (file.path.isNotEmpty ? file.path.split('/').last : '');
      final extension =
          fileName.contains('.') ? fileName.split('.').last.toLowerCase() : '';
      if (!_allowedExtensions.contains(extension)) {
        setState(() {
          _errorMessage =
              'Formato não suportado. Use JPG, PNG ou WebP.';
        });
        return;
      }

      // 2. Validate file size
      final bytes = await file.readAsBytes();
      final maxSizeBytes = (_maxSizeMB * 1024 * 1024).toInt();
      if (bytes.lengthInBytes > maxSizeBytes) {
        setState(() {
          _errorMessage =
              'Arquivo excede o limite de ${_maxSizeMB.toInt()}MB.';
        });
        return;
      }

      // 3. Initiate upload via controller callback
      setState(() => _isUploading = true);

      final contentType = _resolveContentType(extension);
      final downloadUrl = await widget.onUploadImage(
        bytes: bytes,
        fileName: fileName,
        contentType: contentType,
      );

      final updatedList = List<String>.from(_images)..add(downloadUrl);
      setState(() {
        _images = updatedList;
        _errorMessage = null;
      });
      widget.onChanged(updatedList);
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao enviar foto: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  String _resolveContentType(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }

  void _reorderImage(int fromIndex, int toIndex) {
    if (toIndex < 0 || toIndex >= _images.length) return;
    final updated = List<String>.from(_images);
    final item = updated.removeAt(fromIndex);
    updated.insert(toIndex, item);

    setState(() => _images = updated);
    widget.onChanged(updated);
  }

  void _deleteImage(int index) {
    final updated = List<String>.from(_images)..removeAt(index);
    setState(() => _images = updated);
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLimitReached = _images.length >= _maxItems;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Label & Counts
          Row(
            children: [
              const Icon(
                Icons.photo_library_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.field.label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(isDark),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isLimitReached
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.bgCard(isDark),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isLimitReached
                        ? AppColors.primary
                        : AppColors.borderSubtle(isDark),
                  ),
                ),
                child: Text(
                  '${_images.length} / $_maxItems fotos',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isLimitReached
                        ? AppColors.primary
                        : AppColors.textMuted(isDark),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Máx. ${_maxSizeMB.toInt()}MB por foto • Formatos: JPG, PNG, WebP',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textMuted(isDark),
            ),
          ),
          const SizedBox(height: 16),

          // Error banner
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.redAccent.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    color: Colors.redAccent,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => setState(() => _errorMessage = null),
                  ),
                ],
              ),
            ),
          ],

          // Upload Button
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: (_isUploading || isLimitReached)
                    ? null
                    : _pickAndUploadImage,
                icon: _isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.add_photo_alternate_outlined, size: 18),
                label: Text(
                  _isUploading
                      ? 'Enviando foto...'
                      : (isLimitReached
                          ? 'Limite atingido'
                          : 'Adicionar Foto'),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      AppColors.borderSubtle(isDark).withValues(alpha: 0.3),
                  disabledForegroundColor: AppColors.textMuted(isDark),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Photos List / Grid
          if (_images.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.bgCard(isDark),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.borderSubtle(isDark),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.photo_outlined,
                    size: 36,
                    color: AppColors.textMuted(isDark).withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nenhuma foto adicionada à galeria.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textMuted(isDark),
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _images.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final url = _images[index];
                return _buildPhotoCard(context, index, url, isDark);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(
    BuildContext context,
    int index,
    String url,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.bgCard(isDark),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSubtle(isDark)),
      ),
      child: Row(
        children: [
          // Order Pill
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bgSurface(isDark),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.borderSubtle(isDark)),
            ),
            child: Text(
              '${index + 1}',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Image Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 56,
              height: 56,
              child: _buildThumbnailImage(url),
            ),
          ),
          const SizedBox(width: 12),

          // URL / Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  url.startsWith('http')
                      ? url.split('/').last.split('?').first
                      : url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  url.startsWith('http') ? 'URL Remota' : 'Asset Local',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textMuted(isDark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Reorder Buttons
          IconButton(
            icon: const Icon(Icons.arrow_upward, size: 18),
            tooltip: 'Mover para cima',
            color: index > 0
                ? AppColors.textPrimary(isDark)
                : AppColors.textMuted(isDark).withValues(alpha: 0.3),
            onPressed: index > 0 ? () => _reorderImage(index, index - 1) : null,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_downward, size: 18),
            tooltip: 'Mover para baixo',
            color: index < _images.length - 1
                ? AppColors.textPrimary(isDark)
                : AppColors.textMuted(isDark).withValues(alpha: 0.3),
            onPressed: index < _images.length - 1
                ? () => _reorderImage(index, index + 1)
                : null,
          ),

          // Delete Button
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            tooltip: 'Excluir foto',
            color: Colors.redAccent,
            onPressed: () => _deleteImage(index),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailImage(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image, size: 24, color: Colors.grey),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      );
    }

    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.image_outlined, size: 24, color: Colors.grey),
        ),
      );
    }

    return const Center(
      child: Icon(Icons.photo_outlined, size: 24, color: Colors.grey),
    );
  }
}
