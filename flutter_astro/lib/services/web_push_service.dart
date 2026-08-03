import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'api_service.dart';

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

  String? get token => _token;
  bool get isInitialized => _initialized;
  String? get error => _error;

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
      final settings = await messaging.requestPermission(
        alert: true, badge: true, sound: true,
      );
      debugPrint('WebPush permission: ${settings.authorizationStatus}');
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        _error = 'Notification permission denied';
        return;
      }

      _token = await messaging.getToken(vapidKey: vapid);
      debugPrint('WebPush token: ${_token != null ? "${_token!.substring(0, 12)}..." : "NULL"}');
      await _register();

      // Foreground messages (background handled by the service worker).
      FirebaseMessaging.onMessage.listen((message) {
        debugPrint('WebPush foreground: ${message.notification?.title} / ${message.data}');
      });

      messaging.onTokenRefresh.listen((newToken) async {
        _token = newToken;
        await _register();
      });

      _initialized = true;
    } catch (e) {
      _error = 'WebPush init error: $e';
      debugPrint(_error!);
    }
  }

  /// Register the current web token; safe to call again after login.
  Future<void> registerAfterLogin() async {
    if (!kIsWeb) return;
    if (_token == null || _token!.isEmpty) {
      await init();
    } else {
      await _register();
    }
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
