import 'package:flutter/material.dart';

/// Layout breakpoints shared across the astrologer app so screens read the same
/// way on a phone, a tablet, and a desktop browser window.
///
/// - mobile:  width < 600
/// - tablet:  600 ≤ width ≤ 1024
/// - desktop: width > 1024
enum FormFactor { mobile, tablet, desktop }

class Breakpoints {
  const Breakpoints._();

  static const double tablet = 600;
  static const double desktop = 1024;

  static FormFactor of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);

  static FormFactor fromWidth(double width) {
    if (width < tablet) return FormFactor.mobile;
    if (width <= desktop) return FormFactor.tablet;
    return FormFactor.desktop;
  }

  static bool isMobile(BuildContext context) =>
      of(context) == FormFactor.mobile;
  static bool isTablet(BuildContext context) =>
      of(context) == FormFactor.tablet;
  static bool isDesktop(BuildContext context) =>
      of(context) == FormFactor.desktop;
}

/// Convenience helpers on [BuildContext] for terse breakpoint checks.
extension ResponsiveContext on BuildContext {
  FormFactor get formFactor => Breakpoints.of(this);
  bool get isMobile => Breakpoints.isMobile(this);
  bool get isTablet => Breakpoints.isTablet(this);
  bool get isDesktop => Breakpoints.isDesktop(this);

  /// Pick a value per form factor, falling back to the mobile value.
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    switch (formFactor) {
      case FormFactor.mobile:
        return mobile;
      case FormFactor.tablet:
        return tablet ?? mobile;
      case FormFactor.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

/// Centers [child] and caps its width on wide (tablet/desktop) viewports so the
/// content stays readable on a desktop browser while remaining full-bleed on a
/// phone. Use this to wrap a scrolling body.
///
/// On mobile the child is returned untouched (full width, single column). On
/// wider screens it is constrained to [maxWidth] and horizontally centered.
class CenteredMaxWidth extends StatelessWidget {
  const CenteredMaxWidth({
    super.key,
    required this.child,
    this.maxWidth = 720,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
