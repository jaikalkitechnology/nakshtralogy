import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Result of compressing a picked photo for upload.
class CompressedImage {
  const CompressedImage({required this.bytes, required this.filename});

  final Uint8List bytes;

  /// Always ends in `.jpg` when compression succeeded, so the backend's
  /// allow-list (jpg/jpeg/png/webp) accepts it regardless of the source
  /// format (a HEIC camera shot, a screenshot, etc.).
  final String filename;
}

// Kept as an alias so existing callers using `CompressedAvatar` still compile.
typedef CompressedAvatar = CompressedImage;

const int _kAvatarTarget = 200 * 1024; // 200 KB

/// Args bundle so a target size + max dimension can cross the isolate boundary.
class _Args {
  const _Args(this.input, this.targetBytes, this.maxDim);
  final Uint8List input;
  final int targetBytes;
  final int maxDim;
}

/// Compress [input] to a JPEG at or under [targetBytes], off the UI isolate.
///
/// Takes ANY decodable image of ANY size and shrinks it (bound the longest side
/// to [maxDim], then step the JPEG quality / dimensions down) until it fits —
/// so a large or HEIC camera photo that the raw upload rejects (413 /
/// unsupported type) now uploads reliably. If the bytes can't be decoded as an
/// image (e.g. a PDF), returns null and the caller uploads the original.
Future<CompressedImage?> compressImage(
  Uint8List input, {
  int targetBytes = _kAvatarTarget,
  int maxDim = 1280,
  String filename = 'image.jpg',
}) async {
  try {
    final out = await compute(_compressToTarget, _Args(input, targetBytes, maxDim));
    if (out == null) return null;
    return CompressedImage(bytes: out, filename: filename);
  } catch (_) {
    return null; // never let compression block an upload
  }
}

/// Profile-photo compressor: ≤200 KB, bounded to 1280px, saved as avatar.jpg.
Future<CompressedImage?> compressAvatar(Uint8List input, {String? sourceName}) =>
    compressImage(input, targetBytes: _kAvatarTarget, maxDim: 1280, filename: 'avatar.jpg');

/// KYC-document compressor: ≤200 KB but bounded to a larger 1600px so ID text
/// stays legible, saved as document.jpg.
Future<CompressedImage?> compressKycImage(Uint8List input) =>
    compressImage(input, targetBytes: _kAvatarTarget, maxDim: 1600, filename: 'document.jpg');

/// Pure function (isolate-safe): decode → bound size → step quality/dimension
/// down until ≤ target. Returns null if the bytes aren't a decodable image.
Uint8List? _compressToTarget(_Args a) {
  final decoded = img.decodeImage(a.input);
  if (decoded == null) return null;

  img.Image im = decoded;
  if (im.width > a.maxDim || im.height > a.maxDim) {
    im = img.copyResize(
      im,
      width: im.width >= im.height ? a.maxDim : null,
      height: im.height > im.width ? a.maxDim : null,
    );
  }

  // 1) drop JPEG quality at the current size.
  for (final q in const [85, 72, 60, 48, 38, 28]) {
    final out = img.encodeJpg(im, quality: q);
    if (out.length <= a.targetBytes) return Uint8List.fromList(out);
  }

  // 2) still too big → progressively downscale and re-encode.
  int dim = im.width >= im.height ? im.width : im.height;
  while (dim > 320) {
    dim = (dim * 0.8).round();
    final smaller = img.copyResize(
      decoded,
      width: decoded.width >= decoded.height ? dim : null,
      height: decoded.height > decoded.width ? dim : null,
    );
    final out = img.encodeJpg(smaller, quality: 42);
    if (out.length <= a.targetBytes) return Uint8List.fromList(out);
  }

  // 3) best effort — return the smallest we produced.
  final last = img.copyResize(decoded, width: 320);
  return Uint8List.fromList(img.encodeJpg(last, quality: 35));
}
