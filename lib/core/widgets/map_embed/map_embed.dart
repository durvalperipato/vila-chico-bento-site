import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';

import 'map_embed_stub.dart' if (dart.library.js_interop) 'map_embed_web.dart'
    as impl;

/// Widget que renderiza o mapa real embutido do Google Maps com proteção contra
/// "Scroll Trap" (Mouse Wheel Hijack).
/// A rolagem da página continua fluida normalmente até que o usuário clique
/// para interagir diretamente com o mapa.
class RealMapEmbed extends StatefulWidget {
  const RealMapEmbed({
    required this.mapUrl,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.isDark = false,
    super.key,
  });

  final String mapUrl;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final bool isDark;

  @override
  State<RealMapEmbed> createState() => _RealMapEmbedState();
}

class _RealMapEmbedState extends State<RealMapEmbed> {
  bool _isInteractive = false;

  void _enableInteraction() {
    setState(() => _isInteractive = true);
  }

  void _disableInteraction() {
    if (_isInteractive) {
      setState(() => _isInteractive = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color:
              widget.isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          borderRadius: widget.borderRadius,
        ),
        child: const Center(
          child: Icon(
            Icons.map_rounded,
            size: 48,
            color: Colors.grey,
          ),
        ),
      );
    }

    return MouseRegion(
      onExit: (_) => _disableInteraction(),
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              // 1. O Mapa Google Maps Embutido (pointerEvents controlado)
              Positioned.fill(
                child: impl.buildMapEmbedView(
                  mapUrl: widget.mapUrl,
                  width: widget.width,
                  height: widget.height,
                  borderRadius: widget.borderRadius,
                  isDark: widget.isDark,
                  isInteractive: _isInteractive,
                ),
              ),

              // 2. Camada de proteção quando não interativo (permite rolar a página normalmente)
              if (!_isInteractive) ...[
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _enableInteraction,
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),

                // Selo de Dica de Interação (Translúcido e elegante no canto inferior)
                Positioned(
                  bottom: 14,
                  right: 14,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: (widget.isDark
                                ? const Color(0xFF0F172A)
                                : Colors.white)
                            .withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            size: 15,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Clique para interagir com o mapa',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: widget.isDark
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

              // 3. Botão para bloquear interação quando ativo
              if (_isInteractive)
                Positioned(
                  top: 14,
                  right: 14,
                  child: Material(
                    color:
                        (widget.isDark ? const Color(0xFF0F172A) : Colors.white)
                            .withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(100),
                    elevation: 3,
                    child: InkWell(
                      onTap: _disableInteraction,
                      borderRadius: BorderRadius.circular(100),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.lock_outline_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Travar rolagem',
                              style: GoogleFonts.outfit(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: widget.isDark
                                    ? Colors.white
                                    : const Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
