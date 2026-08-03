import 'package:flutter/widgets.dart';

/// Web implementation. Picked-file paths on web are blob/object URLs, so we
/// preview them with [Image.network] and skip the on-disk existence check.

/// Preview a local (blob URL) path as an image.
Widget localImage(String path, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
  return Image.network(path, width: width, height: height, fit: fit);
}

/// On web there is no filesystem to stat; the picker already guarantees the
/// blob exists, so treat it as present.
Future<bool> localFileExists(String path) async => path.isNotEmpty;
