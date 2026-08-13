import 'package:hj_core/hj_core.dart';

/// The unauthenticated `GET /v1/public/app-config` bootstrap payload — every
/// credential the app needs BEFORE sign-in, fed live from the admin console
/// (Settings → Google Login etc.) so a credential change never requires an
/// app rebuild. Secrets are never present here, only public ids and
/// readiness flags.
class RemoteAppConfig {
  const RemoteAppConfig({
    this.googleUserWebClientId,
    this.googleAstroAndroidClientId,
    this.googleAstroWebClientId,
    this.googleLoginConfigured = false,
    this.razorpayKeyId,
    this.paymentsConfigured = false,
    this.paymentsDevMode = false,
    this.agoraConfigured = false,
  });

  factory RemoteAppConfig.fromJson(Map<String, dynamic> json) => RemoteAppConfig(
        googleUserWebClientId: json['google_user_web_client_id'] as String?,
        googleAstroAndroidClientId: json['google_astro_android_client_id'] as String?,
        googleAstroWebClientId: json['google_astro_web_client_id'] as String?,
        googleLoginConfigured: json['google_login_configured'] == true,
        razorpayKeyId: json['razorpay_key_id'] as String?,
        paymentsConfigured: json['payments_configured'] == true,
        paymentsDevMode: json['payments_dev_mode'] == true,
        agoraConfigured: json['agora_configured'] == true,
      );

  /// The seeker app's OAuth Web client id — unused here, kept for parity
  /// with the endpoint shape.
  final String? googleUserWebClientId;

  /// THIS app's client id for ANDROID, passed to Google Sign-In as
  /// `serverClientId`. Still an OAuth *Web application* client (Android's
  /// own client is matched via google-services.json), but often a DIFFERENT
  /// one from [googleAstroWebClientId] — only the web client carries
  /// Authorized JavaScript origins. The server falls back to the web id when
  /// this isn't configured separately.
  final String? googleAstroAndroidClientId;

  /// THIS app's client id for WEB, passed to Google Sign-In as `clientId`.
  /// Null when the admin hasn't configured one — the login flow then falls
  /// back to the compiled-in default.
  final String? googleAstroWebClientId;

  /// The client id for THIS app on the current platform — keeps the platform
  /// choice in one place instead of each call site re-deriving it.
  ///
  /// Android falls back to the web id, mirroring the server's own
  /// resolution. That matters beyond convenience: an app build newer than
  /// the backend would see NO `google_astro_android_client_id` key at all,
  /// and without this fallback it would silently drop to the compiled-in
  /// client id and ignore the admin's configuration.
  String? googleClientIdFor({required bool isWeb}) => isWeb
      ? googleAstroWebClientId
      : (googleAstroAndroidClientId ?? googleAstroWebClientId);

  /// False when the backend has no Google client ids at all (admin console
  /// AND env both empty) — sign-in would be rejected server-side, so the
  /// app shows a clear "not configured" message instead of attempting it.
  final bool googleLoginConfigured;

  final String? razorpayKeyId;
  final bool paymentsConfigured;
  final bool paymentsDevMode;
  final bool agoraConfigured;
}

/// Fetches and caches [RemoteAppConfig]. One successful fetch is reused for
/// the whole app session (the config only changes when an admin edits it;
/// a restart picks that up). Failures are NOT cached — callers may retry,
/// and are expected to fall back to compiled defaults when this throws.
class AppConfigRepository {
  AppConfigRepository(this._api);

  final ApiClient _api;
  RemoteAppConfig? _cached;

  Future<RemoteAppConfig> fetch() async {
    final cached = _cached;
    if (cached != null) return cached;
    final res = await _api.get('/public/app-config');
    return _cached = RemoteAppConfig.fromJson((res as Map).cast<String, dynamic>());
  }
}
