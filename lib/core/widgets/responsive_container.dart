import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';

class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    required this.child,
    super.key,
    this.maxWidth = 1200,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = NanoDeviceType.isMobile(context)
        ? 16.0
        : (NanoDeviceType.isTablet(context) ? 24.0 : 32.0);

    final EdgeInsets effectivePadding;
    if (padding is EdgeInsets) {
      final p = padding as EdgeInsets;
      effectivePadding = EdgeInsets.only(
        top: p.top,
        bottom: p.bottom,
        left: p.left > 0 ? p.left : horizontalPadding,
        right: p.right > 0 ? p.right : horizontalPadding,
      );
    } else {
      effectivePadding = EdgeInsets.symmetric(horizontal: horizontalPadding);
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: effectivePadding,
          child: child,
        ),
      ),
    );
  }
}
