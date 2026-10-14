import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/extensions/image_provider_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/domain.dart';
import 'admin_gallery_field_input.dart';

/// Reactive form input widget for single image fields ([AdminFieldType.image]).
/// Provides thumbnail preview, local compression upload, and removal.
class AdminImageFieldInput extends StatefulWidget {
  const AdminImageFieldInput({
    required this.field,
    required this.initialUrl,
    required this.onChanged,
    required this.onUploadImage,
    this.initialAlignmentY = 0.0,
    this.onAlignmentChanged,
    this.imagePickerAdapter = const DefaultImagePickerAdapter(),
    super.key,
  });

  final AdminField field;
  final String initialUrl;
  final ValueChanged<String> onChanged;
  final GalleryImageUploader onUploadImage;
  final double initialAlignmentY;
  final ValueChanged<double>? onAlignmentChanged;
  final ImagePickerAdapter imagePickerAdapter;

  @override
  State<AdminImageFieldInput> createState() => _AdminImageFieldInputState();
}

class _AdminImageFieldInputState extends State<AdminImageFieldInput> {
  late String _currentUrl;
  late double _alignmentY;
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.initialUrl;
    _alignmentY = widget.initialAlignmentY;
  }

  @override
  void didUpdateWidget(covariant AdminImageFieldInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialUrl != widget.initialUrl) {
      _currentUrl = widget.initialUrl;
    }
    if (oldWidget.initialAlignmentY != widget.initialAlignmentY) {
      _alignmentY = widget.initialAlignmentY;
    }
  }

  double get _maxSizeMB => widget.field.maxSizeMB ?? 3.0;
  List<String> get _allowedExtensions => widget.field.allowedExtensions;

  Future<void> _pickAndUploadImage() async {
    setState(() {
      _errorMessage = null;
      _isUploading = true;
    });

    try {
      final file = await widget.imagePickerAdapter.pickImage();
      if (file == null) {
        if (mounted) setState(() => _isUploading = false);
        return;
      }

      // 1. Validate file extension
      final fileName = file.name.isNotEmpty
          ? file.name
          : (file.path.isNotEmpty ? file.path.split('/').last : '');
      final extension =
          fileName.contains('.') ? fileName.split('.').last.toLowerCase() : '';
      if (!_allowedExtensions.contains(extension)) {
        final validList = _allowedExtensions.join(', ');
        if (mounted) {
          setState(() {
            _errorMessage = 'Formato inválido: .$extension. Use: $validList.';
            _isUploading = false;
          });
        }
        return;
      }

      // 2. Validate file size
      final bytes = await file.readAsBytes();
      final sizeInMB = bytes.lengthInBytes / (1024 * 1024);
      if (sizeInMB > _maxSizeMB) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Arquivo excede ${_maxSizeMB.toStringAsFixed(1)}MB '
                '(${sizeInMB.toStringAsFixed(2)}MB).';
            _isUploading = false;
          });
        }
        return;
      }

      // 3. Yield to paint loading frame before heavy compression
      await Future<void>.delayed(const Duration(milliseconds: 30));

      final uploadedUrl = await widget.onUploadImage(
        bytes: bytes,
        fileName: fileName.isEmpty ? 'hero_banner.jpg' : fileName,
        contentType: 'image/${extension == "jpg" ? "jpeg" : extension}',
      );

      if (mounted) {
        setState(() {
          _currentUrl = uploadedUrl;
          _isUploading = false;
        });
        widget.onChanged(uploadedUrl);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Falha ao processar imagem: $e';
          _isUploading = false;
        });
      }
    }
  }

  void _removeImage() {
    setState(() {
      _currentUrl = '';
      _alignmentY = 0.0;
      _errorMessage = null;
    });
    widget.onChanged('');
    widget.onAlignmentChanged?.call(0.0);
  }

  Widget _buildPresetChip(String label, double targetAlignment) {
    final isSelected = (_alignmentY - targetAlignment).abs() < 0.15;
    return InkWell(
      onTap: _isUploading
          ? null
          : () {
              setState(() => _alignmentY = targetAlignment);
              widget.onAlignmentChanged?.call(targetAlignment);
            },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.borderSubtle(context),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary(context),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _currentUrl.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label and Required Indicator
          Row(
            children: [
              Text(
                widget.field.label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
              if (widget.field.required) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),

          // Existing Image Preview with Loading Overlay
          if (hasImage)
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgCard(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.borderSubtle(context),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow(context),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragUpdate: _isUploading
                            ? null
                            : (details) {
                                final delta = details.primaryDelta ?? 0.0;
                                final nextAlignment =
                                    (_alignmentY - (delta / 80.0))
                                        .clamp(-1.0, 1.0);
                                setState(() => _alignmentY = nextAlignment);
                                widget.onAlignmentChanged?.call(nextAlignment);
                              },
                        child: MouseRegion(
                          cursor: _isUploading
                              ? SystemMouseCursors.basic
                              : SystemMouseCursors.grab,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image(
                                image: _currentUrl.toImageProvider(),
                                fit: BoxFit.cover,
                                alignment: Alignment(0.0, _alignmentY),
                                gaplessPlayback: true,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.bgCard(context),
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image_rounded,
                                      color: Colors.grey,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ),
                              if (!_isUploading)
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.black.withValues(alpha: 0.65),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.unfold_more_rounded,
                                          size: 13,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Arraste para enquadrar',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (_isUploading)
                                Container(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Otimizando fotografia...',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Comprimindo para '
                                          'carregamento rápido',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Alignment controls (Presets & Slider)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tune_rounded,
                                  size: 14,
                                  color: AppColors.textSecondary(context),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Enquadramento vertical',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildPresetChip('Topo', -1.0),
                                const SizedBox(width: 4),
                                _buildPresetChip('Centro', 0.0),
                                const SizedBox(width: 4),
                                _buildPresetChip('Base', 1.0),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 12,
                            ),
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: AppColors.borderSubtle(context),
                            thumbColor: AppColors.primary,
                          ),
                          child: Slider(
                            value: _alignmentY,
                            min: -1.0,
                            divisions: 20,
                            onChanged: _isUploading
                                ? null
                                : (val) {
                                    setState(() => _alignmentY = val);
                                    widget.onAlignmentChanged?.call(val);
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.borderSubtle(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _isUploading
                                ? 'Processando imagem...'
                                : 'Imagem Otimizada (Web)',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: _isUploading ? null : _pickAndUploadImage,
                          icon: _isUploading
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                )
                              : const Icon(
                                  Icons.refresh_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                          label: Text(
                            _isUploading ? 'Processando...' : 'Trocar',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          tooltip: 'Remover imagem',
                          onPressed: _isUploading ? null : _removeImage,
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          // Empty State / Picker Dropzone
          else
            InkWell(
              onTap: _isUploading ? null : _pickAndUploadImage,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: _isUploading
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Otimizando fotografia...',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Comprimindo para carregamento instantâneo',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textMuted(context),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add_photo_alternate_rounded,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Selecionar Fotografia de Fundo',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'JPG, PNG ou WebP até ${_maxSizeMB.toInt()}MB '
                              '(otimizada automaticamente)',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textMuted(context),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

          // Error Message Banner
          if (_errorMessage != null) ...[
            const SizedBox(height: 6),
            Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
