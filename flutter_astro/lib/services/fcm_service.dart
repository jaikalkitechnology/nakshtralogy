import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/communication/chat_screen.dart';
import '../screens/communication/incoming_call_screen.dart';
import '../services/api_service.dart';

/// Global navigator key — set in MaterialApp so FCM can navigate from anywhere.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Flutter local notifications plugin instance.
final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

/// Notification channel for chat messages (Android).
const _chatChannel = AndroidNotificationChannel(
  'chat_messages',
  'Chat Messages',
  description: 'Notifications for incoming chat messages',
  importance: Importance.high,
  playSound: true,
);

/// Reply action key.
const _replyActionId = 'reply_chat';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('FCM background: ${message.messageId}');
}

@pragma('vm:entry-point')
void _onNotificationResponse(NotificationResponse response) {
  debugPrint('Notification response: ${response.actionId} payload=${response.payload}');
  if (response.payload == null) return;

  final data = jsonDecode(response.payload!);

  // Handle inline reply
  if (response.actionId == _replyActionId && response.input != null && response.input!.isNotEmpty) {
    _handleInlineReply(data, response.input!);
    return;
  }

  // Handle notification tap — navigate to chat
  _navigateFromNotification(data);
}

void _handleInlineReply(Map<String, dynamic> data, String replyText) {
  final sessionId = data['session_id'];
  if (sessionId == null) return;
  ApiService().sendChatMessageViaApi(sessionId, replyText).then((_) {
    debugPrint('Inline reply sent for session $sessionId');
  }).catchError((e) {
    debugPrint('Inline reply failed: $e');
  });
}

void _navigateFromNotification(Map<String, dynamic> data) {
  final type = data['type'];

  // Handle incoming call — navigate to ringing screen
  if (type == 'incoming_call') {
    final callId = data['call_id'];
    final callerName = data['caller_name'] ?? 'User';
    final callType = data['call_type'] ?? 'voice';
    final ratePerMin = double.tryParse(data['rate_per_min']?.toString() ?? '0') ?? 0;

    if (callId != null) {
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => IncomingCallScreen(
          callId: callId,
          callerName: callerName,
          callType: callType,
          ratePerMin: ratePerMin,
        ),
      ));
    }
    return;
  }

  if (type == 'chat_message' || type == 'chat_request' || type == 'chat_accepted') {
    final sessionId = data['session_id'];
    final senderName = data['sender_name'] ?? data['user_name'] ?? 'User';
    final ratePerMin = double.tryParse(data['rate_per_min']?.toString() ?? '0') ?? 0;
    final ratePerSession = double.tryParse(data['rate_per_session']?.toString() ?? '0') ?? 0;
    final billingMode = data['billing_mode'] ?? 'per_session';
    final msgLimit = int.tryParse(data['session_message_limit']?.toString() ?? '45') ?? 45;

    if (sessionId != null) {
      // For chat_request, astrologer needs to accept first — navigate to chat
      // which will show the session in waiting state
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => AstroChatScreen(
          sessionId: sessionId,
          userName: senderName,
          ratePerMin: ratePerMin,
          ratePerSession: ratePerSession,
          billingMode: billingMode,
          sessionMessageLimit: msgLimit,
        ),
      ));
    }
  }
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

    // Initialize local notifications
    await _initLocalNotifications();

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

    // ── Foreground messages → show local notification ──
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // ── Tap on notification while app in background ──
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // ── Cold start from terminated state ──
    final initialMessage = await _messaging!.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _navigateFromRemoteMessage(initialMessage);
      });
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _onNotificationResponse,
    );

    final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(_chatChannel);
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('FCM foreground: ${message.notification?.title}');
    final data = message.data;
    final notification = message.notification;

    if (notification == null && data.isEmpty) return;

    final title = notification?.title ?? data['title'] ?? 'Nakshtralogy Astro';
    final body = notification?.body ?? data['body'] ?? '';
    final type = data['type'] ?? '';

    List<AndroidNotificationAction> actions = [];
    if (type == 'chat_message' || type == 'chat_request') {
      actions = [
        const AndroidNotificationAction(
          _replyActionId,
          'Reply',
          icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          inputs: [AndroidNotificationActionInput(label: 'Type a reply...')],
        ),
      ];
    }

    _localNotifications.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _chatChannel.id,
          _chatChannel.name,
          channelDescription: _chatChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          icon: '@mipmap/ic_launcher',
          actions: actions,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(data),
    );
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('FCM opened app: ${message.data}');
    _navigateFromRemoteMessage(message);
  }

  void _navigateFromRemoteMessage(RemoteMessage message) {
    _navigateToChat(Map<String, dynamic>.from(message.data));
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
