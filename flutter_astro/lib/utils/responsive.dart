import 'package:flutter/widgets.dart';

/// Responsive breakpoints for the web/desktop app. Mobile keeps the existing
/// bottom-nav layout; tablet/desktop widths get the desktop shell (top nav,
/// centered max-width container) and multi-column grids.
///
/// Presentation only — no business logic. Screens read these helpers to pick a
/// layout; the underlying data/state/routes are unchanged.
class Responsive {
  Responsive._();

  static const double tabletMin = 768;   // >= tablet
  static const double desktopMin = 1024;  // >= desktop shell kicks in
  static const double wideMin = 1200;     // >= 3-column grids
  static const double maxContent = 1440;  // centered content cap on large screens

  static double width(BuildContext c) => MediaQuery.sizeOf(c).width;

  static bool isMobile(BuildContext c) => width(c) < tabletMin;
  static bool isTablet(BuildContext c) => width(c) >= tabletMin && width(c) < desktopMin;
  static bool isDesktop(BuildContext c) => width(c) >= desktopMin;
  static bool isWide(BuildContext c) => width(c) >= wideMin;

  /// Column count for report / service / quick-action grids.
  static int gridColumns(
    BuildContext c, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    final w = width(c);
    if (w >= wideMin) return desktop;
    if (w >= tabletMin) return tablet;
    return mobile;
  }

  /// Symmetric horizontal page padding that grows a little on desktop.
  static double pagePadding(BuildContext c) {
    final w = width(c);
    if (w >= desktopMin) return 24;
    if (w >= tabletMin) return 20;
    return 16;
  }
}
