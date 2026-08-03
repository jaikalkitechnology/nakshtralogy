/// Web stub — there is no `dart:io` File on web. Callers gate file upload
/// behind `!kIsWeb`, so this should never decide a real code path on web.
Future<bool> nativeFileExists(String path) async => false;
