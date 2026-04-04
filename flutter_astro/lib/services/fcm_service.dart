import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Background message handler — must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('FCM background: ${message.messageId}');
}

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  /// Initialize Firebase & FCM. Call once in main().
  Future<void> init() async {
    await Firebase.initializeApp();

    final settings = await _messaging.requestPermission(
      alert: true, badge: true, sound: true, provisional: false,
    );
    debugPrint('FCM permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    _fcmToken = await _messaging.getToken();
    debugPrint('FCM Token: $_fcmToken');

    if (_fcmToken != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', _fcmToken!);
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      _fcmToken = newToken;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', newToken);
      debugPrint('FCM Token refreshed: $newToken');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM foreground: ${message.notification?.title} — ${message.notification?.body}');
      // Astrologer: handle incoming_call, chat_request notifications here
      // Show overlay / ringtone for calls
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('FCM opened app: ${message.data}');
      _handleNotificationTap(message.data);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage.data);
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    final type = data['type'];
    debugPrint('Notification tap: type=$type data=$data');
    // incoming_call -> IncomingCallScreen
    // chat_request -> ChatScreen
  }

  Future<String?> getToken() async {
    if (_fcmToken != null) return _fcmToken;
    final prefs = await SharedPreferences.getInstance();
    _fcmToken = prefs.getString('fcm_token');
    return _fcmToken;
  }
}
