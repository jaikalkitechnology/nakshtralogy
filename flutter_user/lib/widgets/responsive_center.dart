import 'package:flutter/widgets.dart';

/// Keeps content at a comfortable reading width on tablets and the web:
/// full width on phones, centred and capped at [maxWidth] on wider screens.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({super.key, required this.child, this.maxWidth = 760});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// Text-size factor for sizing fixed-height tiles so labels never clip when
/// the user has a larger font set (clamped to keep layouts sane).
double tileTextScale(BuildContext context, {double max = 1.5}) =>
    MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, max);
