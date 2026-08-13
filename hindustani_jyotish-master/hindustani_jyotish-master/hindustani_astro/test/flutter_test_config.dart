import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

/// Runs before every test in this package (flutter_test convention).
///
/// `AppTextStyles`/`AppTheme` (hj_core) build their styles through
/// `google_fonts`, which fires an UNAWAITED real font-fetch Future the
/// first time each style is built. Inside `testWidgets`' fake-async zone
/// that pending real Future can never complete, so the zone never drains
/// and every test that builds any styled text hangs at teardown until the
/// 10-minute per-test ceiling — with zero output, indistinguishable from a
/// hang in the widget under test. Disabling runtime fetching makes
/// google_fonts fall back to the default bundled font synchronously.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  await testMain();
}
