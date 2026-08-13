import 'package:hj_core/hj_core.dart';

/// Client bootstrap config (`GET /public/app-config`) — the admin-configured
/// credentials/flags the app needs BEFORE anyone signs in. Public, no auth;
/// secrets (Razorpay key secret, Agora certificate, …) are never exposed here.
class RemoteAppConfig {
  const RemoteAppConfig({
    this.googleUserAndroidClientId,
    this.googleUserWebClientId,
    this.googleAstroWebClientId,
    this.googleLoginConfigured = false,
    this.razorpayKeyId,
    this.paymentsConfigured = false,
    this.paymentsDevMode = false,
    this.agoraConfigured = false,
  });

  factory RemoteAppConfig.fromJson(Map<String, dynamic> j) => RemoteAppConfig(
        googleUserAndroidClientId: _nonEmpty(j['google_user_android_client_id']),
        googleUserWebClientId: _nonEmpty(j['google_user_web_client_id']),
        googleAstroWebClientId: _nonEmpty(j['google_astro_web_client_id']),
        googleLoginConfigured: j['google_login_configured'] == true,
        razorpayKeyId: _nonEmpty(j['razorpay_key_id']),
        paymentsConfigured: j['payments_configured'] == true,
        paymentsDevMode: j['payments_dev_mode'] == true,
        agoraConfigured: j['agora_configured'] == true,
      );

  /// Normalises `null`/`""`/whitespace to `null` so callers can rely on
  /// "non-null means usable".
  static String? _nonEmpty(Object? v) {
    if (v is! String) return null;
    final s = v.trim();
    return s.isEmpty ? null : s;
  }

  /// This (seeker) app's client id for ANDROID, passed to Google Sign-In as
  /// `serverClientId`. Still an OAuth *Web application* client (Android's own
  /// client is matched via google-services.json), but often a DIFFERENT one
  /// from [googleUserWebClientId] — only the web client carries Authorized
  /// JavaScript origins. The server already falls back to the web id when
  /// this isn't separately configured, so it is non-null whenever either is.
  final String? googleUserAndroidClientId;

  /// This (seeker) app's client id for WEB, passed to Google Sign-In as
  /// `clientId`. Null when the admin hasn't configured it.
  final String? googleUserWebClientId;

  /// The client id for THIS app on the current platform — the one the app
  /// should actually use. Keeps the platform choice in one place instead of
  /// each call site re-deriving it.
  ///
  /// Android falls back to the web id, mirroring the server's own
  /// resolution. That matters beyond convenience: an app build newer than
  /// the backend would see NO `google_user_android_client_id` key at all,
  /// and without this fallback it would silently drop to the compiled-in
  /// client id and ignore the admin's configuration.
  String? googleClientIdFor({required bool isWeb}) => isWeb
      ? googleUserWebClientId
      : (googleUserAndroidClientId ?? googleUserWebClientId);

  /// The astrologer app's Web client id — unused here, carried for parity
  /// with the endpoint's shape.
  final String? googleAstroWebClientId;
  final bool googleLoginConfigured;

  /// PUBLIC Razorpay key id for the checkout sheet (never the secret).
  final String? razorpayKeyId;
  final bool paymentsConfigured;
  final bool paymentsDevMode;
  final bool agoraConfigured;
}

/// Wraps `GET /public/app-config` with an in-memory cache: the config is
/// fetched at most once per app run (first successful fetch wins). Failures
/// are NOT cached, so a later call can retry once the network is back.
class AppConfigRepository {
  AppConfigRepository(this._api);
  final ApiClient _api;

  RemoteAppConfig? _cache;

  Future<RemoteAppConfig> fetch() async {
    final cached = _cache;
    if (cached != null) return cached;
    final res = await _api.get('/public/app-config');
    return _cache = RemoteAppConfig.fromJson(res as Map<String, dynamic>);
  }
}
