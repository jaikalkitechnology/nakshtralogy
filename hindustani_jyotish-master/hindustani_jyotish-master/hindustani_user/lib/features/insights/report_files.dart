/// On-device report PDFs: download-once storage, offline opening, and the
/// system share sheet (WhatsApp / Email / Telegram / …).
///
/// Files live under `<app documents>/reports/report-<reportId>.pdf` — once
/// downloaded a report opens offline without touching the network (and
/// without regenerating anything server-side).
library;

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hj_core/hj_core.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReportFiles {
  static Future<File> _fileFor(String reportId) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/reports');
    if (!await dir.exists()) await dir.create(recursive: true);
    return File('${dir.path}/report-$reportId.pdf');
  }

  /// The already-downloaded copy, or null if this report was never saved.
  static Future<File?> localIfExists(String reportId) async {
    final f = await _fileFor(reportId);
    return (await f.exists() && await f.length() > 0) ? f : null;
  }

  /// Returns the local copy, downloading it first if needed. Offline with a
  /// saved copy → returns instantly; offline without one → throws an
  /// [ApiException] carrying the standard friendly no-connection message.
  static Future<File> ensureDownloaded({
    required String reportId,
    required String url,
  }) async {
    final f = await _fileFor(reportId);
    if (await f.exists() && await f.length() > 0) return f;
    try {
      final res = await Dio().get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      final bytes = res.data;
      if (bytes == null || bytes.isEmpty) {
        throw ApiException(0, 'The report PDF could not be downloaded.');
      }
      await f.writeAsBytes(bytes, flush: true);
      return f;
    } on DioException {
      throw ApiException(
        0,
        'No internet connection. Please check your internet connection and try again.',
      );
    }
  }

  /// Opens the saved PDF with the device's PDF viewer.
  static Future<bool> open(File file) async {
    final res = await OpenFilex.open(file.path, type: 'application/pdf');
    return res.type == ResultType.done;
  }

  /// System share sheet for the saved PDF.
  static Future<void> share(File file, {String? text}) {
    return SharePlus.instance.share(ShareParams(
      files: [XFile(file.path, mimeType: 'application/pdf')],
      text: text,
    ));
  }
}
