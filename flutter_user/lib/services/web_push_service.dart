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
  // When the currently-registered token was obtained. Used to ignore the iOS
  // Safari token rotation that fires shortly after the permission grant — that
  // rotated token is not yet valid for delivery, so we keep the grant-time one.
  DateTime? _tokenAt;

  String? get token => _token;
  bool get isInitialized => _initialized;

  /// True on web whenever the browser hasn't GRANTED notification permission —
  /// so the UI can offer an "Enable" prompt while it's still 'default' or was
  /// 'denied'. When 'granted' we never prompt (the token registers silently on
  /// login). See [permissionState] for the exact value.
  bool get needsWebEnable => kIsWeb && webNotificationPermission() != 'granted';

  /// 'granted' | 'denied' | 'default' | 'unsupported'.
  String get permissionState => kIsWeb ? webNotificationPermission() : 'unsupported';

  /// True when we're an iOS browser that is NOT an installed PWA. iOS only
  /// allows web push from a home-screen (standalone) PWA, so in this state the
  /// user must "Add to Home Screen" first — enabling from a Safari tab can't work.
  bool get iosNeedsInstall => kIsWeb && webIsIos() && !webIsStandalonePwa();

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
    // The token obtained right here, from the permission grant, is the one that
    // actually works on iOS Safari. We register it ONCE and then keep it — we do
    // NOT re-fetch a new token afterwards, because on iOS the token fetched a
    // little later (e.g. when the dashboard loads) is a different, not-yet-valid
    // token that would overwrite this good one and break delivery.
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
      messaging.onTokenRefresh.listen((t) async {
        // On iOS Safari a rotation fires within seconds of the permission grant,
        // handing us a token that is NOT yet valid for delivery. Ignore refreshes
        // that arrive right after we registered the working grant-time token;
        // honour genuine later rotations.
        if (_tokenAt != null && DateTime.now().difference(_tokenAt!) < const Duration(seconds: 90)) {
          debugPrint('Web push: ignoring post-grant token rotation (iOS)');
          return;
        }
        if (t == _token) return;
        _token = t;
        _tokenAt = DateTime.now();
        await _register();
      });

      // Firebase web + the foreground handler are ready. We do NOT register a
      // token here: the push token is registered ONCE by the login/signup call
      // (FcmService().getToken()). Registering a second token from the dashboard
      // is exactly what broke iOS delivery (the device holds only one push
      // registration). This service now only handles Firebase init, permission
      // (Enable tap), and foreground display.
      _initialized = true;
    } catch (e) {
      _initError = 'web push init: $e';
      debugPrint(_initError!);
    }
  }

  /// Re-register the RECENT grant-time token if we have one, otherwise fetch a
  /// fresh token. The persisted token is only re-used for a short window (15 min)
  /// so a login → dashboard hop / quick PWA reopen keeps the working iOS token;
  /// after that we fetch a fresh token (getToken returns the current valid one,
  /// which handles genuine rotation / expiry so we never cling to a dead token).
  static const Duration _tokenReuseWindow = Duration(minutes: 15);
  Future<void> _registerPersistedOrFetch() async {
    final saved = webLoadToken();
    final savedAt = webTokenSavedAtMs();
    final fresh = saved != null && saved.isNotEmpty && savedAt != null &&
        (DateTime.now().millisecondsSinceEpoch - savedAt) < _tokenReuseWindow.inMilliseconds;
    if (fresh) {
      _token = saved;
      _tokenAt = DateTime.now();
      await _register();
    } else {
      await _getAndRegisterToken();
    }
  }

  /// Get the web token and register it. Assumes permission is already granted —
  /// does NOT request it (see [enableFromGesture] for the request path). The
  /// obtained token is persisted so later opens re-use it instead of refetching.
  Future<void> _getAndRegisterToken() async {
    final m = _messaging;
    if (m == null) return;
    try {
      _token = await m.getToken(vapidKey: _vapidKey);
      _tokenAt = DateTime.now();
      _initError = _token == null ? 'token not issued (check VAPID / service worker)' : null;
      if (_token != null && _token!.isNotEmpty) webSaveToken(_token!);
      debugPrint('Web push token: ${_token != null ? "${_token!.substring(0, 12)}..." : "null"}');
      await _register();
    } catch (e) {
      _initError = 'web push token fetch: $e';
      debugPrint(_initError!);
    }
  }

  /// Call after every login. If we already hold a token in memory, re-register
  /// that SAME token. Otherwise re-register the PERSISTED grant-time token — we
  /// only fetch a brand-new token when none exists, because on iOS Safari a
  /// freshly fetched token right after grant is not yet valid and would replace
  /// the working one.
  Future<void> registerAfterLogin() async {
    if (!kIsWeb) return;
    if (webNotificationPermission() != 'granted') return;
    if (_token != null && _token!.isNotEmpty) {
      await _register();           // re-bind the in-memory token
      return;
    }
    // Ensure Firebase is initialised, THEN actually fetch + register the token.
    // (init() only sets up Firebase + handlers; it does NOT register — so the old
    // code left the token unregistered whenever we weren't initialised yet at
    // login, e.g. when the web-push config was only configured after first boot.)
    if (!_initialized || _messaging == null) {
      await init();
    }
    if (_messaging != null) {
      await _registerPersistedOrFetch();
    }
  }

  /// Call on logout: forget the token (memory + persisted) so the next account
  /// starts clean. The backend token is cleared separately by the logout API.
  void clearOnLogout() {
    _token = null;
    _tokenAt = null;
    webClearToken();
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
