import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Badge representativo dos pilares de confiança exibidos no Hero.
class HeroPillarBadge extends StatelessWidget {
  const HeroPillarBadge({
    required this.icon,
    required this.label,
    required this.color,
    super.key,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
          shadows: const [
            Shadow(
              color: Colors.black87,
              blurRadius: 6,
              offset: Offset(0, 1),
            ),
          ],
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: const [
              Shadow(
                color: Colors.black87,
                blurRadius: 8,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
