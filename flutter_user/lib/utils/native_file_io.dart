import 'dart:io';

/// Native (mobile/desktop) file existence check.
Future<bool> nativeFileExists(String path) => File(path).exists();
