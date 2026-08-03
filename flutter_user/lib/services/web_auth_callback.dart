import 'package:flutter/foundation.dart';
import 'api_service.dart';
import 'url_cleaner_stub.dart' if (dart.library.html) 'url_cleaner_web.dart';

/// Consumes the `?token=&refresh=` handed back by the Google server-side
/// redirect flow.
///
/// On web the backend `/google/callback` redirects the tab to
/// `https://app.nakshatralogy.com/auth/callback?token=&refresh=`; the Flutter
/// app reboots at that URL and [tryConsumeCallbackTokens] reads the query from
/// `Uri.base`, adopts the session, then scrubs the tokens out of the address
/// bar. On mobile the same helper is a harmless no-op unless a deep-link plugin
/// feeds it a callback URI (see [consumeFromUri]).
class WebAuthCallback {
  WebAuthCallback._();

  /// Read `Uri.base` for callback tokens (web). Returns the adoption result
  /// ({statusCode, user, is_new_user}) or null when there is nothing to do.
  static Future<Map<String, dynamic>?> tryConsumeCallbackTokens() async {
    try {
      final params = Uri.base.queryParameters;
      final err = params['google_error'];
      if (err != null && err.isNotEmpty) {
        cleanAuthQueryFromUrl();
        return {'statusCode': 400, 'detail': err};
      }
      final result = await consumeFromParams(params);
      if (result != null && kIsWeb) cleanAuthQueryFromUrl();
      return result;
    } catch (_) {
      return null;
    }
  }

  /// Adopt tokens from an already-parsed callback [uri] (mobile deep link).
  static Future<Map<String, dynamic>?> consumeFromUri(Uri uri) =>
      consumeFromParams(uri.queryParameters);

  static Future<Map<String, dynamic>?> consumeFromParams(
      Map<String, String> params) async {
    final token = params['token'];
    final refresh = params['refresh'];
    if (token == null || token.isEmpty || refresh == null || refresh.isEmpty) {
      return null;
    }
    return ApiService().adoptSessionTokens(token: token, refresh: refresh);
  }
}
