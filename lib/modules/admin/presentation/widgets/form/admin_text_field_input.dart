import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/domain.dart';

/// Reactive form input widget for [AdminFieldType.text] fields.
class AdminTextFieldInput extends StatefulWidget {
  const AdminTextFieldInput({
    required this.field,
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  final AdminField field;
  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<AdminTextFieldInput> createState() => _AdminTextFieldInputState();
}

class _AdminTextFieldInputState extends State<AdminTextFieldInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant AdminTextFieldInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text && !_focusNode.hasFocus) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxLength = widget.field.maxLength;

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
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),

          // Input Field with Live Keystroke Dispatch
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: widget.field.maxLines,
            maxLength: maxLength,
            onChanged: widget.onChanged,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textPrimary(context),
            ),
            buildCounter: (
              context, {
              required currentLength,
              required isFocused,
              maxLength,
            }) {
              if (maxLength == null) return null;
              final isNearLimit = currentLength > (maxLength * 0.9);
              return Text(
                '$currentLength / $maxLength',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isNearLimit
                      ? Colors.orangeAccent
                      : AppColors.textMuted(context),
                ),
              );
            },
            decoration: InputDecoration(
              hintText: 'Digite o conteúdo de ${widget.field.label}...',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textMuted(context),
              ),
              filled: true,
              fillColor: AppColors.bgSurface(context),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.borderSubtle(context),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.borderSubtle(context),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
