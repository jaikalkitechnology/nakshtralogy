/// Web-safe file access: `dart:io` on native, a stub on web. Lets chat compile
/// and run on Flutter Web where `dart:io` is unavailable.
export 'native_file_stub.dart' if (dart.library.io) 'native_file_io.dart';
