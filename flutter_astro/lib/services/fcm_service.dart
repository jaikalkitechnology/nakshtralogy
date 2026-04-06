import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/communication/chat_screen.dart';
import '../screens/communication/incoming_call_screen.dart';
import '../screens/communication/active_call_screen.dart';
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
  'incoming_calls',
  'Incoming Calls',
  description: 'Incoming voice and video call notifications',
  importance: Importance.max,
  playSound: true,
  enableVibration: true,
);

// ── Notification Action IDs ────────────────────────────────────────

const _replyActionId = 'reply_chat';
const _acceptCallActionId = 'accept_call';
const _rejectCallActionId = 'reject_call';

// ── Background handlers ────────────────────────────────────────────

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('FCM background: ${message.messageId}');
  final data = message.data;
  final type = data['type'] ?? '';

  if (type == 'incoming_call') {
    await _showCallNotification(data);
  } else if (type == 'chat_request') {
    await _showChatRequestNotification(data);
  }
}

Future<void> _showChatRequestNotification(Map<String, dynamic> data) async {
  final userName = data['user_name'] ?? data['sender_name'] ?? 'User';

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  await _localNotifications.initialize(
    const InitializationSettings(android: androidInit),
    onDidReceiveNotificationResponse: _onNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: _onNotificationResponse,
  );

  final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  if (androidPlugin != null) {
    await androidPlugin.createNotificationChannel(_callChannel);
  }

  await _localNotifications.show(
    data['session_id'].hashCode,
    'Chat Request from $userName',
    data['billing_mode'] == 'per_session'
        ? '\u20b9${data['rate_per_session'] ?? '0'}/session'
        : '\u20b9${data['rate_per_min'] ?? '0'}/min',
    NotificationDetails(
      android: AndroidNotificationDetails(
        _callChannel.id, _callChannel.name,
        channelDescription: _callChannel.description,
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
        timeoutAfter: 60000,
        fullScreenIntent: true,
        actions: const [
          AndroidNotificationAction('accept_chat', 'Accept', showsUserInterface: true, cancelNotification: true),
          AndroidNotificationAction('decline_chat', 'Decline', cancelNotification: true),
        ],
      ),
      iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
    ),
    payload: jsonEncode(data),
  );
}

Future<void> _showCallNotification(Map<String, dynamic> data) async {
  final callerName = data['caller_name'] ?? 'User';
  final callType = data['call_type'] ?? 'voice';

  // Ensure local notifications is initialized for background isolate
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  await _localNotifications.initialize(
    const InitializationSettings(android: androidInit),
    onDidReceiveNotificationResponse: _onNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: _onNotificationResponse,
  );

  final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  if (androidPlugin != null) {
    await androidPlugin.createNotificationChannel(_callChannel);
  }

  await _localNotifications.show(
    data['call_id'].hashCode,
    'Incoming ${callType == 'video' ? 'Video' : 'Voice'} Call',
    '$callerName is calling you • \u20b9${data['rate_per_min'] ?? '0'}/min',
    NotificationDetails(
      android: AndroidNotificationDetails(
        _callChannel.id,
        _callChannel.name,
        channelDescription: _callChannel.description,
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        ongoing: true,
        autoCancel: false,
        category: AndroidNotificationCategory.call,
        fullScreenIntent: true,
        icon: '@mipmap/ic_launcher',
        timeoutAfter: 60000, // auto-dismiss after 60 seconds
        actions: [
          const AndroidNotificationAction(
            _acceptCallActionId,
            'Accept',
            icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            showsUserInterface: true,
            cancelNotification: true,
          ),
          const AndroidNotificationAction(
            _rejectCallActionId,
            'Reject',
            icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            cancelNotification: true,
          ),
        ],
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

// ── Notification response handler ──────────────────────────────────

@pragma('vm:entry-point')
void _onNotificationResponse(NotificationResponse response) {
  debugPrint('Notification response: actionId=${response.actionId} payload=${response.payload}');
  if (response.payload == null) return;

  final data = jsonDecode(response.payload!) as Map<String, dynamic>;
  final type = data['type'] ?? '';

  // ── Handle call Accept from notification action ──
  if (response.actionId == _acceptCallActionId) {
    _handleAcceptCallFromNotification(data);
    return;
  }

  // ── Handle call Reject from notification action ──
  if (response.actionId == _rejectCallActionId) {
    _handleRejectCallFromNotification(data);
    return;
  }

  // ── Handle chat Accept from notification action ──
  if (response.actionId == 'accept_chat') {
    final sessionId = data['session_id'];
    if (sessionId != null) {
      ApiService().loadTokens().then((_) {
        ApiService().chatAction(sessionId, 'accept').then((resp) {
          if (resp['statusCode'] == 200 || resp['statusCode'] == 201) {
            navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (_) => AstroChatScreen(
                sessionId: sessionId,
                userName: data['user_name'] ?? data['sender_name'] ?? 'User',
                ratePerMin: double.tryParse(data['rate_per_min']?.toString() ?? '0') ?? 0,
                ratePerSession: double.tryParse(data['rate_per_session']?.toString() ?? '0') ?? 0,
                billingMode: data['billing_mode'] ?? 'per_session',
                sessionMessageLimit: int.tryParse(data['session_message_limit']?.toString() ?? '45') ?? 45,
              ),
            ));
          }
        });
      });
    }
    return;
  }

  // ── Handle chat Decline from notification action ──
  if (response.actionId == 'decline_chat') {
    final sessionId = data['session_id'];
    if (sessionId != null) {
      ApiService().loadTokens().then((_) {
        ApiService().chatAction(sessionId, 'cancel').catchError((e) {
          debugPrint('Decline chat failed: $e');
        });
      });
    }
    return;
  }

  // ── Handle inline chat reply ──
  if (response.actionId == _replyActionId && response.input != null && response.input!.isNotEmpty) {
    final sessionId = data['session_id'];
    if (sessionId != null) {
      ApiService().sendChatMessageViaApi(sessionId, response.input!).catchError((e) {
        debugPrint('Inline reply failed: $e');
      });
    }
    return;
  }

  // ── Handle notification tap (no specific action) ──
  _navigateFromNotification(data);
}

void _handleAcceptCallFromNotification(Map<String, dynamic> data) {
  final callId = data['call_id'];
  if (callId == null) return;

  ApiService().loadTokens().then((_) {
    ApiService().callAction(callId, 'accept').then((resp) {
      if (resp['statusCode'] == 200 || resp['statusCode'] == 201) {
        final callerName = data['caller_name'] ?? 'User';
        final callType = data['call_type'] ?? 'voice';
        final ratePerMin = double.tryParse(data['rate_per_min']?.toString() ?? '0') ?? 0;

        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => ActiveCallScreen(
            callId: callId,
            channelName: resp['channel_name'] ?? data['channel_name'] ?? '',
            agoraToken: resp['agora_token'] ?? data['agora_token'] ?? '',
            agoraAppId: resp['agora_app_id'] ?? data['agora_app_id'] ?? '',
            callType: callType,
            peerName: callerName,
            ratePerMin: ratePerMin,
            isAstrologer: true,
          ),
        ));
      } else {
        // Call expired or error
        debugPrint('Accept call failed: ${resp['detail']}');
      }
    });
  });
}

void _handleRejectCallFromNotification(Map<String, dynamic> data) {
  final callId = data['call_id'];
  if (callId == null) return;

  ApiService().loadTokens().then((_) {
    ApiService().callAction(callId, 'reject').catchError((e) {
      debugPrint('Reject call failed: $e');
    });
  });
}

// ── Navigation router ──────────────────────────────────────────────

void _navigateFromNotification(Map<String, dynamic> data) {
  final type = data['type'];

  // Incoming call → open ringing screen
  if (type == 'incoming_call') {
    final callId = data['call_id'];
    if (callId != null) {
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => IncomingCallScreen(
          callId: callId,
          callerName: data['caller_name'] ?? 'User',
          callType: data['call_type'] ?? 'voice',
          ratePerMin: double.tryParse(data['rate_per_min']?.toString() ?? '0') ?? 0,
        ),
      ));
    }
    return;
  }

  // Chat notifications → open chat screen
  if (type == 'chat_message' || type == 'chat_request' || type == 'chat_accepted') {
    final sessionId = data['session_id'];
    if (sessionId != null) {
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => AstroChatScreen(
          sessionId: sessionId,
          userName: data['sender_name'] ?? data['user_name'] ?? 'User',
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
  bool _initialized = false;
  String? _initError;

  String? get fcmToken => _fcmToken;
  bool get isInitialized => _initialized;
  String? get initError => _initError;

  Future<void> init() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      _initError = 'Firebase init: $e';
      debugPrint('Firebase init error: $e');
      return;
    }

    try {
      _messaging = FirebaseMessaging.instance;

      final settings = await _messaging!.requestPermission(
        alert: true, badge: true, sound: true, provisional: false,
      );
      debugPrint('FCM permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        _initError = 'Notification permission denied. Enable in device settings.';
        debugPrint(_initError!);
      }

      FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

      await _initLocalNotifications();

      await _fetchAndSaveToken();

      _messaging!.onTokenRefresh.listen((newToken) async {
        debugPrint('FCM token refreshed: ${newToken.substring(0, 20)}...');
        _fcmToken = newToken;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', newToken);
        _sendTokenToBackend(newToken);
      });

      FirebaseMessaging.onMessage.listen(_onForegroundMessage);

      FirebaseMessaging.onMessageOpenedApp.listen((msg) {
        _navigateFromNotification(Map<String, dynamic>.from(msg.data));
      });

      final initialMessage = await _messaging!.getInitialMessage();
      if (initialMessage != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _navigateFromNotification(Map<String, dynamic>.from(initialMessage.data));
        });
      }

      _initialized = true;
    } catch (e) {
      _initError = 'FCM setup error: $e';
      debugPrint(_initError!);
    }
  }

  Future<void> _fetchAndSaveToken() async {
    try {
      _fcmToken = await _messaging?.getToken();
      debugPrint('FCM Token: ${_fcmToken != null ? "${_fcmToken!.substring(0, 20)}..." : "NULL"}');
      if (_fcmToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', _fcmToken!);
      } else {
        _initError = 'FCM token is null. Check google-services.json and internet.';
        debugPrint(_initError!);
      }
    } catch (e) {
      _initError = 'FCM getToken error: $e';
      debugPrint(_initError!);
    }
  }

  Future<String?> getToken() async {
    if (_fcmToken != null && _fcmToken!.isNotEmpty) return _fcmToken;
    final prefs = await SharedPreferences.getInstance();
    _fcmToken = prefs.getString('fcm_token');
    if (_fcmToken != null && _fcmToken!.isNotEmpty) return _fcmToken;
    if (_messaging != null) {
      await _fetchAndSaveToken();
      return _fcmToken;
    }
    try {
      await Firebase.initializeApp();
      _messaging = FirebaseMessaging.instance;
      await _fetchAndSaveToken();
    } catch (e) {
      debugPrint('FCM getToken retry failed: $e');
    }
    return _fcmToken;
  }

  void _sendTokenToBackend(String token) {
    ApiService().loadTokens().then((_) {
      if (ApiService().isLoggedIn) {
        ApiService().updateMeFields({'fcm_token': token}).then((res) {
          debugPrint('FCM token sent to backend: ${res['statusCode']}');
        }).catchError((e) {
          debugPrint('Failed to send FCM token to backend: $e');
        });
      }
    });
  }

  Future<void> ensureTokenSynced() async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      _sendTokenToBackend(token);
    } else {
      debugPrint('FCM token not available for sync');
    }
  }

  String getStatusMessage() {
    if (_fcmToken != null && _fcmToken!.isNotEmpty) return 'FCM active';
    if (_initError != null) return _initError!;
    if (!_initialized) return 'FCM not initialized. Check Firebase config.';
    return 'FCM token not generated. Check google-services.json and internet connection.';
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

    // ── Incoming call while app is in foreground → navigate directly ──
    if (type == 'incoming_call') {
      final callId = data['call_id'];
      if (callId != null) {
        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => IncomingCallScreen(
            callId: callId,
            callerName: data['caller_name'] ?? 'User',
            callType: data['call_type'] ?? 'voice',
            ratePerMin: double.tryParse(data['rate_per_min']?.toString() ?? '0') ?? 0,
          ),
        ));
      }
      return;
    }

    // ── Chat request in foreground → show notification with Accept/Decline ──
    if (type == 'chat_request') {
      final title2 = 'Chat Request from ${data['user_name'] ?? 'User'}';
      final body2 = data['billing_mode'] == 'per_session'
          ? '\u20b9${data['rate_per_session'] ?? '0'}/session'
          : '\u20b9${data['rate_per_min'] ?? '0'}/min';
      _localNotifications.show(
        data['session_id'].hashCode,
        title2,
        body2,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _callChannel.id, _callChannel.name,
            channelDescription: _callChannel.description,
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
            timeoutAfter: 60000,
            actions: const [
              AndroidNotificationAction('accept_chat', 'Accept', showsUserInterface: true, cancelNotification: true),
              AndroidNotificationAction('decline_chat', 'Decline', cancelNotification: true),
            ],
          ),
          iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
        ),
        payload: jsonEncode(data),
      );
      return;
    }

    // ── Other notifications (chat messages etc.) → show local notification ──
    final title = notification?.title ?? data['title'] ?? 'Nakshtralogy Astro';
    final body = notification?.body ?? data['body'] ?? '';

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

  Future<void> clearToken() async {
    _fcmToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('fcm_token');
  }
}
