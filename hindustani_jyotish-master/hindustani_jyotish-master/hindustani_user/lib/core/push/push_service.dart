import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hj_core/hj_core.dart';

/// Channel used for the local system notification shown for a foreground FCM
/// message. Matches Android's own default-priority channel naming so a tap
/// behaves the same as the auto-displayed background/terminated notification.
const String _kDefaultChannelId = 'hj_default_channel';
const String _kDefaultChannelName = 'Notifications';

/// Web push (FCM JS SDK) needs a VAPID public key to mint a token. Until one is
/// configured we simply skip token registration on web so the build/run works
/// with notifications inactive rather than throwing at `getToken`.
///
/// TODO: set VAPID key — paste the "Web Push certificates" key pair public key
/// from the Firebase console (Project settings → Cloud Messaging) here.
const String? kWebPushVapidKey = null;

/// Handles a data/notification message while the app is backgrounded or
/// terminated. Must be a top-level (or static) function annotated with
/// `vm:entry-point` so the Flutter engine can find it in a separate isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // A fresh isolate is spun up here, so nothing from the main isolate (DI,
  // navigator, etc.) is available. Keep this minimal. Firebase must be
  // initialised before touching any Firebase API in this isolate.
  try {
    await Firebase.initializeApp();
  } catch (_) {
    /* already initialised or unavailable */
  }
  debugPrint('[push] background message: ${message.messageId} ${message.data}');
}

/// Thin wrapper around Firebase Cloud Messaging for the seeker app.
///
/// Degrades gracefully: on platforms/emulators without Google Play services
/// every call is wrapped so a failure only logs and never crashes the app.
class PushService {
  PushService(this._api);

  final ApiClient _api;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onOpenedSub;
  bool _initialised = false;
  int _notificationId = 0;

  /// Called when a notification is tapped (background tap or cold start) — the
  /// app layer routes based on `message.data['type']`.
  void Function(RemoteMessage message)? onOpened;

  /// Admin-configured web-push VAPID key, captured while fetching the web
  /// Firebase options. Null until fetched / not configured.
  String? _serverVapidKey;

  /// Firebase WEB options from the admin console (`firebase_web.user` in
  /// GET /public/app-config). Null when unreachable or not yet configured
  /// (api key + web app id are the two fields web init cannot do without).
  Future<FirebaseOptions?> _webOptionsFromServer() async {
    try {
      final data = await _api.get('/public/app-config') as Map<String, dynamic>;
      final all = data['firebase_web'];
      final fb = all is Map ? all['user'] : null;
      if (fb is! Map) return null;
      String field(String key) => '${fb[key] ?? ''}'.trim();
      final apiKey = field('api_key');
      final appId = field('app_id');
      if (apiKey.isEmpty || appId.isEmpty) return null;
      final vapid = field('vapid_key');
      _serverVapidKey = vapid.isEmpty ? null : vapid;
      return FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: field('messaging_sender_id'),
        projectId: field('project_id'),
        authDomain: field('auth_domain').isEmpty ? null : field('auth_domain'),
        storageBucket:
            field('storage_bucket').isEmpty ? null : field('storage_bucket'),
        measurementId:
            field('measurement_id').isEmpty ? null : field('measurement_id'),
      );
    } catch (e) {
      debugPrint('[push] could not fetch Firebase web config: $e');
      return null;
    }
  }

  /// One-time engine setup: init Firebase, register the background handler and
  /// wire up the foreground listener. Safe to call before a session exists.
  /// Call [registerToken] once the user is authenticated.
  Future<void> init() async {
    if (_initialised) return;
    _initialised = true;
    try {
      if (kIsWeb) {
        // Web has no google-services.json: Firebase.initializeApp() needs
        // explicit options, fetched LIVE from the admin console (Firebase →
        // Web app config, served via GET /public/app-config) so the web
        // build works without a rebuild when credentials change.
        final options = await _webOptionsFromServer();
        if (options == null) {
          debugPrint(
              '[push] Firebase web is not configured — add the web app config '
              '(api key + web app id) in the admin console (Firebase page).');
          return;
        }
        await Firebase.initializeApp(options: options);
      } else {
        await Firebase.initializeApp();
      }
      await _initLocalNotifications();
      // Background isolates don't exist on web — firebase_messaging's web
      // implementation handles background pushes via the service worker
      // (web/firebase-messaging-sw.js) instead.
      if (!kIsWeb) {
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      }
      _onMessageSub = FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      // Tapping a notification while the app is backgrounded (but alive).
      _onOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen((message) {
        debugPrint('[push] opened from background: data=${message.data}');
        onOpened?.call(message);
      });
    } catch (e) {
      debugPrint('[push] init skipped: $e');
    }
  }

  /// Sets up `flutter_local_notifications` so a foreground FCM message can be
  /// shown as a real system-tray notification (Android already auto-displays
  /// one for background/terminated messages; this covers the foreground gap).
  /// Best-effort — a platform without notification support (e.g. web/desktop
  /// in dev) should not crash the app.
  Future<void> _initLocalNotifications() async {
    try {
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidInit);
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onLocalNotificationTap,
      );

      const channel = AndroidNotificationChannel(
        _kDefaultChannelId,
        _kDefaultChannelName,
        description: 'General notifications from Hindustani Jyotish',
        importance: Importance.high,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } catch (e) {
      debugPrint('[push] local notifications init skipped: $e');
    }
  }

  /// Tapping the real system notification we raised for a foreground message.
  /// Rebuilds a [RemoteMessage] from the JSON-encoded `data` payload we stored
  /// and routes it through the exact same [onOpened] callback used for
  /// background/cold-start taps, so behaviour is identical either way.
  void _onLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      final data = decoded.map((k, v) => MapEntry(k, '$v'));
      debugPrint('[push] local notification tapped: data=$data');
      onOpened?.call(RemoteMessage(data: data));
    } catch (e) {
      debugPrint('[push] local notification tap payload decode failed: $e');
    }
  }

  /// If the app was launched cold by tapping a notification, deliver it to the
  /// [onOpened] handler once the UI is ready. Best-effort; never throws.
  Future<void> handleInitialMessage() async {
    try {
      final message = await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) {
        debugPrint('[push] cold-start from notification: data=${message.data}');
        onOpened?.call(message);
      }
    } catch (e) {
      debugPrint('[push] getInitialMessage failed: $e');
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    final n = message.notification;
    debugPrint(
      '[push] foreground message: ${n?.title ?? '(no title)'} - '
      '${n?.body ?? ''} data=${message.data}',
    );
    // A real system-tray notification only — no in-app bottom banner, since
    // Android only auto-shows a system notification for background/
    // terminated messages, a foreground one needs to be raised explicitly.
    _showLocalNotification(message);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final n = message.notification;
      final data = message.data;
      final title = n?.title ?? data['title']?.toString();
      final body = n?.body ?? data['body']?.toString();
      if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
        return;
      }

      const androidDetails = AndroidNotificationDetails(
        _kDefaultChannelId,
        _kDefaultChannelName,
        channelDescription: 'General notifications from Hindustani Jyotish',
        importance: Importance.high,
        priority: Priority.high,
      );
      const details = NotificationDetails(android: androidDetails);

      await _localNotifications.show(
        _notificationId++,
        title,
        body,
        details,
        payload: jsonEncode(data),
      );
    } catch (e) {
      debugPrint('[push] show local notification failed: $e');
    }
  }

  /// Ask for permission, fetch the current token and register it with the
  /// backend. Listens for refreshes so a rotated token is re-registered.
  /// Requires an authenticated session (the register call is auth'd).
  Future<void> registerToken() async {
    try {
      await init();

      // On web, getToken requires a VAPID key + registered service worker.
      // The admin-configured key (Firebase → Web app config) wins over the
      // compiled constant; with neither we skip cleanly so the app still
      // runs.
      final vapidKey = _serverVapidKey ?? kWebPushVapidKey;
      if (kIsWeb && vapidKey == null) {
        debugPrint('[push] web push skipped: VAPID key not configured — add '
            'it in the admin console (Firebase → Web app config).');
        return;
      }

      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();

      // APNS token can be null momentarily on iOS; guarded broadly anyway.
      final token = kIsWeb
          ? await messaging.getToken(vapidKey: vapidKey)
          : await messaging.getToken();
      if (token != null) {
        await _sendToken(token);
      }

      await _tokenRefreshSub?.cancel();
      _tokenRefreshSub = messaging.onTokenRefresh.listen((t) {
        _sendToken(t);
      });
    } catch (e) {
      debugPrint('[push] registerToken failed: $e');
    }
  }

  Future<void> _sendToken(String token) async {
    try {
      await _api.post(
        '/me/device',
        body: {'token': token, 'platform': _resolvePlatform()},
      );
      debugPrint('[push] device token registered');
    } catch (e) {
      // 401 before login, or offline: log and move on.
      debugPrint('[push] device token registration failed: $e');
    }
  }

  /// Best-effort unregister on logout — fire-and-forget from the caller's
  /// point of view (never blocks logout). Retries once after a transient
  /// failure so a single network hiccup doesn't leave a stale token
  /// registered server-side; a second failure is swallowed as before.
  Future<void> unregisterToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await _deleteDeviceToken(token);
      debugPrint('[push] device token unregistered');
    } catch (e) {
      debugPrint('[push] device token unregister failed, retrying once: $e');
      try {
        final token = await FirebaseMessaging.instance.getToken();
        if (token == null) return;
        await _deleteDeviceToken(token);
        debugPrint('[push] device token unregistered on retry');
      } catch (e2) {
        debugPrint('[push] device token unregister retry failed: $e2');
      }
    }
  }

  Future<void> _deleteDeviceToken(String token) => _api.delete(
        '/me/device',
        body: {'token': token, 'platform': _resolvePlatform()},
      );

  String _resolvePlatform() {
    if (kIsWeb) return 'web';
    // defaultTargetPlatform avoids dart:io so this file stays web-safe.
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
        return 'android';
      default:
        return 'android';
    }
  }

  Future<void> dispose() async {
    await _tokenRefreshSub?.cancel();
    await _onMessageSub?.cancel();
    await _onOpenedSub?.cancel();
  }
}
