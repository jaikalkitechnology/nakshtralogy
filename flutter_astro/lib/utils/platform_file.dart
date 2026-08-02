/// Cross-platform helpers for local file preview + existence checks.
///
/// Flutter web cannot import `dart:io`, so screens that preview/pick local
/// files import THIS facade instead. The concrete implementation is chosen at
/// compile time: `dart:io` on mobile/desktop, a web-safe stub on Flutter web.
export 'platform_file_io.dart'
    if (dart.library.html) 'platform_file_web.dart';
