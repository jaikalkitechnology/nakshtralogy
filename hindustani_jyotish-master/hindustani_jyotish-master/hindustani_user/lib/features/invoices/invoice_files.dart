/// Authenticated download + offline open for GST invoice PDFs.
///
/// Unlike report PDFs (served from a public media URL), the invoice download
/// endpoint is ownership-checked and needs the bearer token, so this builds
/// the request against the API base URL with the current access token.
library;

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hj_core/hj_core.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/di.dart';

class InvoiceFiles {
  static Future<File> _fileFor(String invoiceId) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/invoices');
    if (!await dir.exists()) await dir.create(recursive: true);
    return File('${dir.path}/invoice-$invoiceId.pdf');
  }

  /// Downloads (once) the invoice PDF and opens it with the device viewer.
  static Future<bool> downloadAndOpen(String invoiceId) async {
    final f = await _fileFor(invoiceId);
    if (!(await f.exists() && await f.length() > 0)) {
      final config = getIt<AppConfig>();
      final tokens = getIt<TokenStore>();
      final base = config.apiBaseUrl.replaceAll(RegExp(r'/+$'), '');
      try {
        final res = await Dio().get<List<int>>(
          '$base/invoices/$invoiceId/download',
          options: Options(
            responseType: ResponseType.bytes,
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              if (tokens.accessToken != null)
                'Authorization': 'Bearer ${tokens.accessToken}',
            },
          ),
        );
        final bytes = res.data;
        if (bytes == null || bytes.isEmpty) {
          throw ApiException(0, 'The invoice PDF could not be downloaded.');
        }
        await f.writeAsBytes(bytes, flush: true);
      } on DioException {
        throw ApiException(
          0,
          'No internet connection. Please check your internet connection and try again.',
        );
      }
    }
    final res = await OpenFilex.open(f.path, type: 'application/pdf');
    return res.type == ResultType.done;
  }
}
