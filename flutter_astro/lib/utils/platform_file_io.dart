import 'dart:io';
import 'package:flutter/widgets.dart';

/// Mobile/desktop implementation backed by `dart:io`.

/// Preview a local file path as an image.
Widget localImage(String path, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
  return Image.file(File(path), width: width, height: height, fit: fit);
}

/// Whether a local file path exists on disk.
Future<bool> localFileExists(String path) => File(path).exists();
