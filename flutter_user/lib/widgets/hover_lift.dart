import 'package:flutter/material.dart';

/// A subtle desktop hover interaction: lifts (and optionally scales) its child
/// on pointer-enter. Inert on touch devices (no pointer hover), so it is safe
/// to use in shared widgets across mobile and desktop. Presentation only.
class HoverLift extends StatefulWidget {
  final Widget child;
  final double liftY;
  final double hoverScale;
  const HoverLift({
    super.key,
    required this.child,
    this.liftY = -3,
    this.hoverScale = 1.0,
  });

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? widget.hoverScale : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? widget.liftY : 0, 0),
          child: widget.child,
        ),
      ),
    );
  }
}
