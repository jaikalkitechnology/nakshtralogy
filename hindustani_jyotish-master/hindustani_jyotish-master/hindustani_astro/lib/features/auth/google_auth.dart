import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

/// Compiled-in fallback OAuth "Web" client id for the astrologer app (see
/// `credentials/clientid.txt`, "for web astro") — used as the audience the
/// backend verifies against, so `authentication.idToken` is returned on
/// Android. MUST be the WEB client id, never the Android one: passing the
/// Android client id (`...pfuom5`, as this constant originally did) fails
/// with the exact same DEVELOPER_ERROR 10 as a missing SHA-1 registration.
/// The Android client id lives in google-services.json against this app's
/// package + SHA-1 and is matched by Play Services automatically.
///
/// The PRIMARY source is the admin-fed `google_astro_web_client_id` from
/// `GET /v1/public/app-config` (see `AppConfigRepository`); this constant
/// only kicks in when that is unset or unreachable.
const kAstroGoogleWebClientId =
    '892936615659-1ba3hqq7bmnj1hcukjreq2n805kaj3du.apps.googleusercontent.com';

/// Holds the single [GoogleSignIn] instance for the whole app so that login
/// (which builds it with the resolved `serverClientId`) and logout (which
/// must sign out the SAME cached account) always operate on one object.
/// Keyed by the client id it was built with, so an admin-side change picked
/// up on a later fetch replaces the instance instead of being ignored.
class AstroGoogleSignIn {
  GoogleSignIn? _instance;
  String? _serverClientId;

  /// The client id the cached instance was built with — null until login
  /// resolves one (admin-fed or compiled fallback) and builds the instance.
  String? get serverClientId => _serverClientId;

  GoogleSignIn forServerClientId(String serverClientId) {
    if (_instance == null || _serverClientId != serverClientId) {
      _serverClientId = serverClientId;
      // `GoogleSignIn(serverClientId: ...)` hard-asserts on web
      // (`google_sign_in_web`'s `initWithParams`) because the underlying GIS
      // SDK has no separate "server" audience concept there — the SAME OAuth
      // **Web** client id must instead be passed as `clientId` so the GIS
      // credential flow (see google_web_button_web.dart) mints an idToken
      // whose audience matches it. Mobile keeps `serverClientId` exactly as
      // before, which is what makes `authentication.idToken` backend-verifiable.
      _instance = kIsWeb
          ? GoogleSignIn(clientId: serverClientId, scopes: const ['email'])
          : GoogleSignIn(serverClientId: serverClientId, scopes: const ['email']);
    }
    return _instance!;
  }

  /// Signs out whichever instance login built. No-op when Google sign-in
  /// was never used this session (nothing to sign out of).
  Future<void> signOut() async {
    try {
      await _instance?.signOut();
    } catch (_) {/* not signed in via Google — ignore */}
  }
}
