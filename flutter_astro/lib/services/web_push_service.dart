import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'api_service.dart';
import '../utils/web_notification.dart';

/// Web-only push notifications for the astrologer web app.
///
/// Firebase is initialised on web using the PUBLIC config returned by
/// `GET /config/webpush?role=astrologer` (Firebase web keys + VAPID public
/// key). No keys are hardcoded — the admin panel owns them server-side.
///
/// Background delivery is handled by `web/firebase-messaging-sw.js`; this class
/// handles permission, the web token (registered with `platform:"web"`), and
/// the foreground message handler. All work is a no-op off the web platform.
class WebPushService {
  static final WebPushService _instance = WebPushService._internal();
  factory WebPushService() => _instance;
  WebPushService._internal();

  bool _initialized = false;
  String? _token;
  String? _error;
  // Kept after a successful Firebase init so the token can be re-fetched later
  // (e.g. once the user grants permission, or after login) without re-running
  // the whole init — which the _initialized guard would otherwise block.
  FirebaseMessaging? _messaging;
  String? _vapid;

  String? get token => _token;
  bool get isInitialized => _initialized;
  String? get error => _error;

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
        _error = 'notifications blocked in browser';
        return false;
      }
    } catch (_) {}
    await _getAndRegisterToken();
    // iOS often ROTATES the web token a few seconds after the first grant,
    // invalidating the one we just registered. Re-register the rotated token so
    // the backend ends up with the currently-valid one.
    Future.delayed(const Duration(seconds: 6), () {
      if (kIsWeb) _getAndRegisterToken();
    });
    return _token != null && _token!.isNotEmpty;
  }

  /// Initialise Firebase web messaging from the public config, request
  /// permission, fetch the web token and (if logged in) register it.
  Future<void> init() async {
    if (!kIsWeb || _initialized) return;

    final cfg = await ApiService().getWebPushConfig();
    if (cfg == null) {
      _error = 'Web push config unavailable';
      debugPrint('WebPush: $_error');
      return;
    }

    final apiKey = cfg['web_api_key'] as String?;
    final appId = cfg['web_app_id'] as String?;
    final projectId = cfg['web_project_id'] as String?;
    final sender = cfg['web_messaging_sender_id'] as String?;
    final authDomain = cfg['web_auth_domain'] as String?;
    final vapid = cfg['vapid_public_key'] as String?;

    if ([apiKey, appId, projectId, sender].any((e) => e == null || e.isEmpty)) {
      _error = 'Web push config incomplete (needs admin upload)';
      debugPrint('WebPush: $_error');
      return;
    }

    try {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: apiKey!,
          appId: appId!,
          projectId: projectId!,
          messagingSenderId: sender!,
          authDomain: authDomain,
        ),
      );

      final messaging = FirebaseMessaging.instance;
      _messaging = messaging;
      _vapid = vapid;

      // Foreground messages (background handled by the service worker).
      FirebaseMessaging.onMessage.listen((message) {
        // Flutter web does NOT auto-display foreground messages — show one via
        // the browser Notification API. Background messages are shown by the SW.
        final title = message.notification?.title ?? message.data['title'] ?? 'Nakshatralogy';
        final body = message.notification?.body ?? message.data['body'] ?? '';
        debugPrint('WebPush foreground: $title');
        showWebNotification(title, body);
      });

      messaging.onTokenRefresh.listen((newToken) async {
        _token = newToken;
        await _register();
      });

      // Only fetch the token if permission is ALREADY granted — never
      // auto-request the browser prompt here (that only happens on the user's
      // Enable tap). Same behaviour on Android + iOS.
      _initialized = true;
      if (webNotificationPermission() == 'granted') {
        await _getAndRegisterToken();
      }
    } catch (e) {
      _error = 'WebPush init error: $e';
      debugPrint(_error!);
    }
  }

  /// Get the web token and register it. Assumes permission is already granted —
  /// does NOT request it (see [enableFromGesture] for the request path).
  Future<void> _getAndRegisterToken() async {
    final m = _messaging;
    if (m == null) return;
    try {
      _token = await m.getToken(vapidKey: _vapid);
      _error = _token == null ? 'Token not issued (check VAPID / service worker)' : null;
      debugPrint('WebPush token: ${_token != null ? "${_token!.substring(0, 12)}..." : "NULL"}');
      await _register();
    } catch (e) {
      _error = 'WebPush token fetch error: $e';
      debugPrint(_error!);
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
    if (_token == null || _token!.isEmpty) return;
    if (!ApiService().isLoggedIn) return; // register once authenticated
    try {
      final res = await ApiService().registerPushToken(_token!, platform: 'web');
      debugPrint('WebPush register: ${res['statusCode']}');
    } catch (e) {
      debugPrint('WebPush register failed: $e');
    }
  }
}
