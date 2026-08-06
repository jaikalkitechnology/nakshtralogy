import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';
import '../utils/web_notification.dart';

/// Web push for Flutter Web.
///
/// Firebase is initialized on web from the **public** runtime config served by
/// `GET /api/v1/config/webpush?role=user` — no Firebase keys are hard-coded in
/// the client (secrets stay server-side per the locked decision). Flow:
///   1. fetch the public config,
///   2. `Firebase.initializeApp(options)` with the web config,
///   3. request notification permission,
///   4. `getToken(vapidKey:)` → the web push token,
///   5. after login, register it via `POST /user/push/register`
///      with `platform:"web"`,
///   6. foreground handler here; background handled by
///      `web/firebase-messaging-sw.js`.
///
/// A no-op on non-web platforms (mobile uses [FcmService]).
class WebPushService {
  static final WebPushService _instance = WebPushService._internal();
  factory WebPushService() => _instance;
  WebPushService._internal();

  final ApiService _api = ApiService();

  bool _initialized = false;
  String? _token;
  String? _vapidKey;
  String? _initError;
  // Retained after a successful Firebase init so the token can be (re)fetched
  // later — e.g. once the user grants permission or after login — without the
  // _initialized guard blocking recovery.
  FirebaseMessaging? _messaging;

  String? get token => _token;
  bool get isInitialized => _initialized;

  /// True on web whenever the browser hasn't GRANTED notification permission —
  /// so the UI can offer an "Enable" prompt while it's still 'default' or was
  /// 'denied'. When 'granted' we never prompt (the token registers silently on
  /// login). See [permissionState] for the exact value.
  bool get needsWebEnable => kIsWeb && webNotificationPermission() != 'granted';

  /// 'granted' | 'denied' | 'default' | 'unsupported'.
  String get permissionState => kIsWeb ? webNotificationPermission() : 'unsupported';

  /// Request permission + fetch/register the token IN RESPONSE TO A USER TAP.
  /// This is the ONLY place permission is ever requested — the same on Android
  /// and iOS — so we never trigger the browser prompt automatically during boot
  /// or login (which iOS Safari blocks / handles poorly). Returns true if a
  /// token was obtained.
  Future<bool> enableFromGesture() async {
    if (!kIsWeb) return false;
    if (!_initialized || _messaging == null) await init();
    final m = _messaging;
    if (m == null) return false;
    try {
      final settings = await m.requestPermission(alert: true, badge: true, sound: true);
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        _initError = 'notifications blocked in browser';
        return false;
      }
    } catch (_) {}
    await _getAndRegisterToken();
    return _token != null && _token!.isNotEmpty;
  }
  String? get initError => _initError;

  /// Initialize Firebase (web) from the public config and acquire a token.
  /// Never throws — records [initError] and returns on any missing config so
  /// auth/chat are never blocked.
  Future<void> init() async {
    if (!kIsWeb || _initialized) return;
    try {
      final cfg = await _api.getWebPushConfig();
      if (cfg['statusCode'] != 200) {
        _initError = 'webpush config unavailable (${cfg['statusCode']})';
        return;
      }
      final apiKey = _str(cfg['web_api_key']);
      final appId = _str(cfg['web_app_id']);
      final senderId = _str(cfg['web_messaging_sender_id']);
      final projectId = _str(cfg['web_project_id']);
      _vapidKey = _str(cfg['vapid_public_key']);
      if (apiKey.isEmpty || appId.isEmpty || senderId.isEmpty || projectId.isEmpty || _vapidKey!.isEmpty) {
        _initError = 'webpush config incomplete — admin must upload VAPID + web keys';
        debugPrint(_initError!);
        return;
      }

      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: senderId,
          projectId: projectId,
          authDomain: _strOrNull(cfg['web_auth_domain']),
        ),
      );

      final messaging = FirebaseMessaging.instance;
      _messaging = messaging;

      FirebaseMessaging.onMessage.listen((msg) {
        // Flutter web does NOT auto-display foreground messages — show one via
        // the browser Notification API. Background messages are shown by the SW.
        final title = msg.notification?.title ?? msg.data['title'] ?? 'Nakshatralogy';
        final body = msg.notification?.body ?? msg.data['body'] ?? '';
        debugPrint('Web push foreground: $title');
        showWebNotification(title, body);
      });
      messaging.onTokenRefresh.listen((t) {
        _token = t;
        registerAfterLogin();
      });

      // Firebase is ready; mark initialised. Only fetch the token if permission
      // is ALREADY granted — we never auto-request the browser prompt here (that
      // only happens on the user's Enable tap). Same behaviour on Android + iOS.
      _initialized = true;
      if (webNotificationPermission() == 'granted') {
        await _getAndRegisterToken();
      }
    } catch (e) {
      _initError = 'web push init: $e';
      debugPrint(_initError!);
    }
  }

  /// Get the web token and register it. Assumes permission is already granted —
  /// does NOT request it (see [enableFromGesture] for the request path).
  Future<void> _getAndRegisterToken() async {
    final m = _messaging;
    if (m == null) return;
    try {
      _token = await m.getToken(vapidKey: _vapidKey);
      _initError = _token == null ? 'token not issued (check VAPID / service worker)' : null;
      debugPrint('Web push token: ${_token != null ? "${_token!.substring(0, 12)}..." : "null"}');
      await _register();
    } catch (e) {
      _initError = 'web push token fetch: $e';
      debugPrint(_initError!);
    }
  }

  /// Call after every login. When permission is already granted, ALWAYS fetch a
  /// FRESH token from FCM and register it — never re-use the cached one, which
  /// can be stale after a logout/login or account switch (the cause of
  /// "device token is stale/invalid" in the admin panel). When permission is
  /// still 'default'/'denied', the UI's Enable prompt handles it.
  Future<void> registerAfterLogin() async {
    if (!kIsWeb) return;
    if (webNotificationPermission() != 'granted') return;
    if (!_initialized || _messaging == null) {
      await init(); // init() fetches + registers when already granted
    } else {
      await _getAndRegisterToken(); // fresh getToken + register
    }
  }

  /// Call on logout: forget the cached token so the next login re-fetches a
  /// fresh one for the new account. The backend token is cleared separately by
  /// the logout API call.
  void clearOnLogout() {
    _token = null;
  }

  Future<void> _register() async {
    final t = _token;
    if (t == null || t.isEmpty) return;
    if (!_api.isLoggedIn) return; // register once authenticated
    try {
      final res = await _api.registerPushToken(token: t, platform: 'web');
      debugPrint('Web push register: ${res['statusCode']}');
    } catch (e) {
      debugPrint('Web push register failed: $e');
    }
  }

  String _str(dynamic v) => (v ?? '').toString();
  String? _strOrNull(dynamic v) {
    final s = (v ?? '').toString();
    return s.isEmpty ? null : s;
  }
}
