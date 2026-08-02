import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_service.dart';
import '../utils/constants.dart';

/// Google authentication transport for the astrologer app.
///
/// Two paths, split by platform (all credentials live server-side in
/// `platform_settings`; the app never hardcodes a client id/secret):
///
///  * Web (`kIsWeb`): fetch the authorization URL from
///    `GET /google/login-url?role=astrologer&return_to=<astro web callback>`
///    and redirect the SAME browser tab to Google. After consent the backend
///    `/google/callback` redirects back to the astro web callback with
///    `?token=&refresh=`, which [main] captures at startup.
///
///  * Mobile: the primary in-app path uses the native `google_sign_in` sheet to
///    obtain an `id_token`, verified via `POST /google/verify` (see [AuthBloc]).
///    [startMobileServerRedirect] is the alternative server-side redirect that
///    opens the login URL in an external browser and returns through the deep
///    link `nakshatralogyastro://auth/callback` (capture requires a deep-link
///    plugin — see STATUS.md).
class GoogleAuthService {
  final ApiService _api = ApiService();

  /// Web: redirect the current tab to Google's consent screen.
  /// Returns true if the redirect was launched.
  Future<bool> startWebRedirect() async {
    final url = await _api.googleLoginUrl(returnTo: ApiConstants.astroWebCallback);
    if (url == null || url.isEmpty) return false;
    // `_self` redirects the current tab so the callback lands back in this app.
    return launchUrl(
      Uri.parse(url),
      webOnlyWindowName: '_self',
      mode: LaunchMode.platformDefault,
    );
  }

  /// Mobile (server-side redirect variant): open the login URL in the external
  /// browser; the backend returns through the deep link.
  Future<bool> startMobileServerRedirect() async {
    final url = await _api.googleLoginUrl(returnTo: ApiConstants.astroDeepLinkCallback);
    if (url == null || url.isEmpty) return false;
    return launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  /// Convenience: choose the right transport for the current platform.
  /// On web this triggers a full-page redirect (this call does not return with
  /// tokens; [main] captures them after the round-trip).
  Future<bool> start() =>
      kIsWeb ? startWebRedirect() : startMobileServerRedirect();
}
