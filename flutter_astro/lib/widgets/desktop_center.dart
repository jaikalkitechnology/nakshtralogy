import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// Centres and width-caps its child on desktop/tablet so full-screen pages
/// (forms, lists, detail views) don't stretch edge-to-edge on wide monitors.
/// On mobile it returns the child unchanged. Presentation only — wraps a page
/// body without touching its content, scrolling, or logic.
class DesktopCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const DesktopCenter({super.key, required this.child, this.maxWidth = 900});

  @override
  Widget build(BuildContext context) {
    if (!Responsive.isDesktop(context)) return child;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
