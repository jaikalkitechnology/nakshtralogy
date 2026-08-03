import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

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

  String? get token => _token;
  bool get isInitialized => _initialized;
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
      final settings = await messaging.requestPermission(alert: true, badge: true, sound: true);
      debugPrint('Web push permission: ${settings.authorizationStatus}');
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        _initError = 'notifications blocked in browser';
        return;
      }

      _token = await messaging.getToken(vapidKey: _vapidKey);
      debugPrint('Web push token: ${_token != null ? "${_token!.substring(0, 12)}..." : "null"}');

      FirebaseMessaging.onMessage.listen((msg) {
        debugPrint('Web push foreground: ${msg.notification?.title ?? msg.data['title']}');
      });
      messaging.onTokenRefresh.listen((t) {
        _token = t;
        registerAfterLogin();
      });

      _initialized = true;
    } catch (e) {
      _initError = 'web push init: $e';
      debugPrint(_initError!);
    }
  }

  /// Register the acquired web token with the backend. Call once a session is
  /// live (the register endpoint is authenticated). Safe to call repeatedly.
  Future<void> registerAfterLogin() async {
    if (!kIsWeb) return;
    final t = _token;
    if (t == null || t.isEmpty) return;
    try {
      await _api.registerPushToken(token: t, platform: 'web');
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
