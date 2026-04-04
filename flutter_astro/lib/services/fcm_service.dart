import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('FCM background: ${message.messageId}');
}

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  FirebaseMessaging? _messaging;
  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  Future<void> init() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Firebase already initialized or error: $e');
    }

    _messaging = FirebaseMessaging.instance;

    final settings = await _messaging!.requestPermission(
      alert: true, badge: true, sound: true, provisional: false,
    );
    debugPrint('FCM permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    _fcmToken = await _messaging!.getToken();
    debugPrint('FCM Token: $_fcmToken');

    if (_fcmToken != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', _fcmToken!);
    }

    _messaging!.onTokenRefresh.listen((newToken) async {
      _fcmToken = newToken;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', newToken);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM foreground: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('FCM opened app: ${message.data}');
    });

    final initialMessage = await _messaging!.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('FCM cold start: ${initialMessage.data}');
    }
  }

  Future<String?> getToken() async {
    if (_fcmToken != null) return _fcmToken;
    final prefs = await SharedPreferences.getInstance();
    _fcmToken = prefs.getString('fcm_token');
    return _fcmToken;
  }

  Future<void> clearToken() async {
    _fcmToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('fcm_token');
  }
}
