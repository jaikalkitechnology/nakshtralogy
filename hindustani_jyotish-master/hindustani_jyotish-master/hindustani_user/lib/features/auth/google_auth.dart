import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/di.dart';
import '../config/app_config_repository.dart';

/// Compiled-in fallback: this app's OAuth "Web" client id (see
/// `credentials/clientid.txt`, "for web user") — NOT the Android client id.
/// On Android the Web client id is what makes `google_sign_in` mint an
/// `idToken` whose audience the backend (`POST /auth/google`) accepts.
/// Passing the ANDROID client id here fails with the exact same
/// DEVELOPER_ERROR 10 as a missing SHA-1 registration, which makes the two
/// misconfigurations indistinguishable in the field. The Android client id
/// (`...igns22`) lives in google-services.json against this app's package +
/// SHA-1 and is matched automatically by Play Services; it is never passed
/// in code.
const String kFallbackGoogleWebClientId =
    '892936615659-edoq5gafttfj1qs5mruv2ajppget8vlm.apps.googleusercontent.com';

GoogleSignIn? _cached;

/// The one shared [GoogleSignIn] for the seeker app, built lazily so its
/// `serverClientId` can come from the admin console (`GET /public/app-config`
/// → `google_user_web_client_id`) instead of only a compiled constant:
///
/// - Remote id present → use it.
/// - Remote id absent, or the config fetch fails (offline / server down) →
///   fall back to [kFallbackGoogleWebClientId] silently, so login still works.
/// - Returns `null` ONLY when the backend was reached, reports
///   `google_login_configured == false`, and there is no client id at all
///   (neither remote nor compiled) — the caller should then show a friendly
///   "not configured yet" message instead of a cryptic DEVELOPER_ERROR.
///
/// The instance is cached: sign-in and sign-out MUST operate on the same
/// object, or logout would not clear the account the login flow cached.
Future<GoogleSignIn?> obtainGoogleSignIn() async {
  final existing = _cached;
  if (existing != null) return existing;

  String? remoteId;
  var remoteSaysUnconfigured = false;
  try {
    final cfg = await getIt<AppConfigRepository>().fetch();
    // Per-platform: Android and web usually need DIFFERENT OAuth clients
    // (only the web one carries Authorized JavaScript origins). The server
    // falls back to the web id when no Android-specific one is configured.
    remoteId = cfg.googleClientIdFor(isWeb: kIsWeb);
    remoteSaysUnconfigured = !cfg.googleLoginConfigured;
  } catch (e) {
    debugPrint('[google] app-config fetch failed ($e) — '
        'falling back to the compiled Web client id.');
  }

  final clientId = remoteId ?? kFallbackGoogleWebClientId;
  if (remoteId == null && remoteSaysUnconfigured && clientId.isEmpty) {
    debugPrint('[google] backend says Google login is not configured and no '
        'compiled fallback client id exists.');
    return null;
  }
  // The OAuth client id is the SAME value (the app's "Web" client) on both
  // platforms, but google_sign_in requires it under a different named
  // parameter per platform: web hard-asserts on `serverClientId` (it's not
  // supported there — see google_sign_in_web's `initWithParams`) and instead
  // needs it as `clientId`, while mobile needs `serverClientId` so the
  // returned `idToken`'s audience is this Web client id (see the constant's
  // doc comment above) rather than the platform-specific client.
  return _cached = kIsWeb
      ? GoogleSignIn(
          clientId: clientId,
          scopes: const ['email'],
        )
      : GoogleSignIn(
          serverClientId: clientId,
          scopes: const ['email'],
        );
}

/// Clears the cached Google account so the next login re-prompts. Uses the
/// same cached instance as [obtainGoogleSignIn]; failures (offline, never
/// signed in, plugin unavailable) are logged and swallowed — sign-out of our
/// own session must never be blocked by Google.
Future<void> googleSignOut() async {
  try {
    final google = _cached ?? await obtainGoogleSignIn();
    await google?.signOut();
  } catch (e) {
    debugPrint('[google] signOut failed (ignored): $e');
  }
}
