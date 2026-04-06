import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/communication/chat_screen.dart';
import '../screens/communication/call_screen.dart';
import '../services/api_service.dart';

/// Global navigator key — set in MaterialApp so FCM can navigate from anywhere.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Flutter local notifications plugin instance.
final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

// ── Notification Channels ──────────────────────────────────────────

const _chatChannel = AndroidNotificationChannel(
  'chat_messages',
  'Chat Messages',
  description: 'Notifications for incoming chat messages',
  importance: Importance.high,
  playSound: true,
);

const _callChannel = AndroidNotificationChannel(
  'call_status',
  'Call Status',
  description: 'Call accepted/rejected notifications',
  importance: Importance.max,
  playSound: true,
);

// ── Action IDs ─────────────────────────────────────────────────────

const _replyActionId = 'reply_chat';

// ── Background handler ─────────────────────────────────────────────

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('FCM background: ${message.messageId}');
}

// ── Notification response handler ──────────────────────────────────

@pragma('vm:entry-point')
void _onNotificationResponse(NotificationResponse response) {
  debugPrint('Notification response: actionId=${response.actionId} payload=${response.payload}');
  if (response.payload == null) return;

  final data = jsonDecode(response.payload!) as Map<String, dynamic>;

  // Handle inline chat reply
  if (response.actionId == _replyActionId && response.input != null && response.input!.isNotEmpty) {
    final sessionId = data['session_id'];
    if (sessionId != null) {
      ApiService().sendChatMessageViaApi(sessionId, response.input!).catchError((e) {
        debugPrint('Inline reply failed: $e');
      });
    }
    return;
  }

  // Handle notification tap
  _navigateFromNotification(data);
}

// ── Navigation router ──────────────────────────────────────────────

void _navigateFromNotification(Map<String, dynamic> data) {
  final type = data['type'];

  // Call accepted → fetch call details and navigate to CallScreen
  if (type == 'call_accepted') {
    final callId = data['call_id'];
    if (callId != null) {
      ApiService().loadTokens().then((_) {
        ApiService().getCall(callId).then((resp) {
          if (resp['statusCode'] == 200) {
            navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (_) => CallScreen(
                callId: resp['id'] ?? callId,
                channelName: resp['channel_name'] ?? '',
                agoraToken: resp['agora_token'] ?? '',
                agoraAppId: resp['agora_app_id'] ?? '',
                callType: resp['call_type'] ?? 'voice',
                astrologerName: data['astrologer_name'] ?? 'Astrologer',
                ratePerMin: (resp['rate_per_min'] as num?)?.toDouble() ?? 0,
                eligibleMinutes: resp['eligible_minutes'] ?? 0,
                maxCallSeconds: resp['max_call_seconds'] ?? 0,
              ),
            ));
          }
        });
      });
    }
    return;
  }

  // Chat notifications
  if (type == 'chat_message' || type == 'chat_accepted' || type == 'chat_request') {
    final sessionId = data['session_id'];
    if (sessionId != null) {
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => ChatScreen(
          sessionId: sessionId,
          astrologerName: data['sender_name'] ?? data['astrologer_name'] ?? 'Astrologer',
          ratePerMin: double.tryParse(data['rate_per_min']?.toString() ?? '0') ?? 0,
          ratePerSession: double.tryParse(data['rate_per_session']?.toString() ?? '0') ?? 0,
          billingMode: data['billing_mode'] ?? 'per_session',
          sessionMessageLimit: int.tryParse(data['session_message_limit']?.toString() ?? '45') ?? 45,
        ),
      ));
    }
  }
}


// ═══════════════════════════════════════════════════════════════════
//  FCM SERVICE CLASS
// ═══════════════════════════════════════════════════════════════════

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

    // ── Foreground messages ──
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // ── Background tap ──
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      _navigateFromNotification(Map<String, dynamic>.from(msg.data));
    });

    // ── Cold start ──
    final initialMessage = await _messaging!.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _navigateFromNotification(Map<String, dynamic>.from(initialMessage.data));
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
      await androidPlugin.createNotificationChannel(_callChannel);
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('FCM foreground: ${message.notification?.title}');
    final data = message.data;
    final notification = message.notification;
    if (notification == null && data.isEmpty) return;

    final type = data['type'] ?? '';
    final title = notification?.title ?? data['title'] ?? 'Nakshtralogy';
    final body = notification?.body ?? data['body'] ?? '';

    // ── Call accepted while user is on ringing screen → no notification needed,
    // the CallScreen is already polling/waiting for remote user to join via Agora.
    // But if user left the screen, show notification. ──
    if (type == 'call_accepted') {
      _localNotifications.show(
        data['call_id'].hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _callChannel.id, _callChannel.name,
            channelDescription: _callChannel.description,
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true,
          ),
        ),
        payload: jsonEncode(data),
      );
      return;
    }

    // ── Chat notifications ──
    List<AndroidNotificationAction> actions = [];
    if (type == 'chat_message') {
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
          _chatChannel.id, _chatChannel.name,
          channelDescription: _chatChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          icon: '@mipmap/ic_launcher',
          actions: actions,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true, presentBadge: true, presentSound: true,
        ),
      ),
      payload: jsonEncode(data),
    );
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
