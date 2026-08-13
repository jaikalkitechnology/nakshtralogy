import 'package:flutter/material.dart';

/// Device-size buckets used across the app.
enum ScreenType { mobile, tablet, desktop }

/// Central place for responsive breakpoints and layout helpers.
///
/// Breakpoints: mobile < 600, tablet 600–1024, desktop > 1024. Screens read
/// these via [Responsive.of] / [Responsive.typeOf] (both backed by the
/// enclosing [MediaQuery]) or wrap themselves in [CenteredMaxWidth] so content
/// stays comfortably readable on very wide desktop windows.
class Responsive {
  const Responsive._();

  static const double mobileMax = 600;
  static const double tabletMax = 1024;

  /// Max content width used by the centered scaffold wrapper on wide screens.
  static const double contentMaxWidth = 1100;

  /// A narrower cap for single-column, form-like content (auth, chat, wallet).
  static const double readableMaxWidth = 640;

  static ScreenType typeOf(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);

  static ScreenType fromWidth(double width) {
    if (width < mobileMax) return ScreenType.mobile;
    if (width < tabletMax) return ScreenType.tablet;
    return ScreenType.desktop;
  }

  static bool isMobile(BuildContext context) =>
      typeOf(context) == ScreenType.mobile;
  static bool isTablet(BuildContext context) =>
      typeOf(context) == ScreenType.tablet;
  static bool isDesktop(BuildContext context) =>
      typeOf(context) == ScreenType.desktop;

  /// Picks a value per screen size, falling back to the next-smaller bucket.
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (typeOf(context)) {
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.mobile:
        return mobile;
    }
  }

  /// Column count for the astrologer grid at the current width.
  static int gridColumns(double width) {
    if (width >= 1400) return 4;
    if (width >= tabletMax) return 3;
    if (width >= mobileMax) return 2;
    return 1;
  }
}

/// Constrains [child] to a max width and centers it on wide (tablet/desktop)
/// screens; on mobile it is a transparent pass-through. Use this app-wide so
/// full-bleed mobile layouts don't stretch awkwardly across a desktop browser.
class CenteredMaxWidth extends StatelessWidget {
  const CenteredMaxWidth({
    super.key,
    required this.child,
    this.maxWidth = Responsive.contentMaxWidth,
  });

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
