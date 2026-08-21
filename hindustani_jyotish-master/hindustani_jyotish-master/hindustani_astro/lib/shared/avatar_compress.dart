import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Result of compressing a picked photo for upload.
class CompressedAvatar {
  const CompressedAvatar({required this.bytes, required this.filename});

  final Uint8List bytes;

  /// Always ends in `.jpg` when compression succeeded, so the backend's
  /// allow-list (jpg/jpeg/png/webp) accepts it regardless of the source
  /// format (a HEIC camera shot, a screenshot, etc.).
  final String filename;
}

const int _kTargetBytes = 200 * 1024; // 200 KB
const int _kMaxDim = 1280; // longest side after the first resize

/// Compress [input] to a ≤200 KB JPEG, off the UI isolate.
///
/// Takes ANY decodable image of ANY size and shrinks it (bound the longest
/// side, then step the JPEG quality / dimensions down) until it fits 200 KB —
/// so a large or HEIC camera photo that the raw upload rejects (413 / unsupported
/// type) now uploads reliably. If the bytes can't be decoded as an image (e.g.
/// a PDF), returns null and the caller uploads the original untouched.
Future<CompressedAvatar?> compressAvatar(Uint8List input, {String? sourceName}) async {
  try {
    final out = await compute(_compressToTarget, input);
    if (out == null) return null;
    return CompressedAvatar(bytes: out, filename: 'avatar.jpg');
  } catch (_) {
    return null; // never let compression block an upload
  }
}

/// Pure function (isolate-safe): decode → bound size → step quality/dimension
/// down until ≤200 KB. Returns null if the bytes aren't a decodable image.
Uint8List? _compressToTarget(Uint8List input) {
  final decoded = img.decodeImage(input);
  if (decoded == null) return null;

  img.Image im = decoded;
  if (im.width > _kMaxDim || im.height > _kMaxDim) {
    im = img.copyResize(
      im,
      width: im.width >= im.height ? _kMaxDim : null,
      height: im.height > im.width ? _kMaxDim : null,
    );
  }

  // 1) drop JPEG quality at the current size.
  for (final q in const [85, 72, 60, 48, 38, 28]) {
    final out = img.encodeJpg(im, quality: q);
    if (out.length <= _kTargetBytes) return Uint8List.fromList(out);
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
    if (out.length <= _kTargetBytes) return Uint8List.fromList(out);
  }

  // 3) best effort — return the smallest we produced.
  final last = img.copyResize(decoded, width: 320);
  return Uint8List.fromList(img.encodeJpg(last, quality: 35));
}
