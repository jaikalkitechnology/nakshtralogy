import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';
import 'api_service.dart';

/// Google sign-in / sign-up transport.
///
/// Per the locked orchestrator decision the **primary** path on web AND mobile
/// is the existing server-side redirect flow:
///   GET /google/login-url?role=user&return_to=<url>  →  Google  →
///   /google/callback  →  redirect to `return_to?token=&refresh=`.
/// Credentials live in the backend `platform_settings`, so the client never
/// holds a client secret and the admin owns the IDs.
///
///   * Web    → navigate the current tab to the Google URL; the callback lands
///              back on the SPA (`webAuthCallbackUrl`) with the tokens, read by
///              [WebAuthCallback] on next boot.
///   * Mobile → open the Google URL in an external browser; the callback lands
///              on the `nakshatralogy://auth/callback` deep link.
///
/// Additionally (mobile only, behind a `kIsWeb` split) the native
/// `google_sign_in` sheet can produce an `id_token` posted to
/// POST /google/verify — a native-friendly path that shares the same backend
/// source of truth. Never invoked on web.
class GoogleAuthService {
  GoogleAuthService._();
  static final GoogleAuthService instance = GoogleAuthService._();

  final ApiService _api = ApiService();

  /// Start the server-side redirect flow. Returns true when the browser was
  /// launched (the session then returns via callback / deep link), false on
  /// failure so the caller can surface an error.
  Future<bool> startRedirectFlow() async {
    final returnTo =
        kIsWeb ? ApiConstants.webAuthCallbackUrl : ApiConstants.mobileAuthCallback;
    final res = await _api.googleLoginUrl(returnTo: returnTo);
    if (res['statusCode'] != 200) return false;
    final url = res['url'];
    if (url is! String || url.isEmpty) return false;
    final uri = Uri.parse(url);
    if (kIsWeb) {
      // Replace the current tab so the OAuth round-trip returns to the SPA.
      return launchUrl(uri, webOnlyWindowName: '_self');
    }
    // Mobile: external browser; returns via the custom-scheme deep link.
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// Native mobile sign-in sheet → `id_token` → POST /google/verify.
  /// Never called on web (guard with `kIsWeb` at the call site). Returns the
  /// verify response map ({statusCode, token, refresh, is_new_user, ...}) or
  /// null when the user cancelled the sheet.
  Future<Map<String, dynamic>?> nativeVerify({String? fcmToken}) async {
    assert(!kIsWeb, 'nativeVerify must not be used on web');
    final googleUser = await GoogleSignIn(
      scopes: const ['email', 'profile'],
      // Web OAuth client ID whose audience the backend `/google/verify`
      // validates. Supplied at build time; backend stays the source of truth.
      serverClientId: const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID', defaultValue: '410358361509-5h98nfjhdc9bu92rq7o39idkq3r9nieh.apps.googleusercontent.com'),
    ).signIn();
    if (googleUser == null) return null; // cancelled
    final auth = await googleUser.authentication;
    final idToken = auth.idToken;
    if (idToken == null) {
      return {'statusCode': 400, 'detail': 'No ID token from Google sign-in.'};
    }
    return _api.googleVerify(idToken, fcmToken: fcmToken);
  }
}
