import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../router/app_router.dart';

/// Android notification channel used for local (foreground) notifications so
/// they show with the same high-priority behaviour as background FCM ones.
const String _kDefaultChannelId = 'hj_default_channel';
const String _kDefaultChannelName = 'Notifications';

/// Notification-action ids for the "new consultation request" push. Wired to
/// the same accept/decline flow as the in-app Requests screen buttons.
const String _kAcceptActionId = 'accept_request';
const String _kRejectActionId = 'reject_request';

/// Top-level background handler. Must be a top-level (or static) function
/// annotated with `@pragma('vm:entry-point')` so it survives tree-shaking and
/// can be invoked in a separate isolate when the app is backgrounded/terminated.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // A background isolate needs Firebase initialised before touching any
  // Firebase APIs. On Android config comes from google-services.json.
  await Firebase.initializeApp();
  debugPrint('[push] background message: ${message.messageId} ${message.data}');

  // Some push types (e.g. `consultation_request`) are sent data-only by the
  // backend on purpose — no `notification` block — so custom actions (Accept/
  // Reject) can be attached, which native FCM auto-display can't do. That
  // means Android never auto-displays anything for them, so this isolate is
  // the *only* place such a message is ever seen while the app isn't already
  // in the foreground: build and show the local notification ourselves.
  final plugin = FlutterLocalNotificationsPlugin();
  await _initLocalNotificationsPlugin(plugin);
  await _showLocalNotificationForMessage(plugin, message);
}

/// One-time `flutter_local_notifications` setup shared by the foreground
/// instance (main isolate) and the background handler (its own isolate),
/// each of which owns its own [FlutterLocalNotificationsPlugin] instance.
Future<void> _initLocalNotificationsPlugin(
  FlutterLocalNotificationsPlugin plugin, {
  void Function(NotificationResponse response)? onDidReceiveNotificationResponse,
}) async {
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await plugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );
  const channel = AndroidNotificationChannel(
    _kDefaultChannelId,
    _kDefaultChannelName,
    importance: Importance.high,
  );
  await plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

String _defaultTitleFor(String? type) => switch (type) {
      'consultation_request' => 'New consultation request',
      'consultation_ended' => 'Consultation ended',
      _ => 'Notification',
    };

/// Notification details for a push `type`. `consultation_request` gets
/// Accept/Reject actions since it's sent data-only (see [_kAcceptActionId]):
/// native auto-display can't add buttons, so the app must build the whole
/// notification itself, in every app state.
///
/// `showsUserInterface: true` is deliberate: tapping an action briefly opens
/// the app (rather than acting fully silently in the background), because the
/// astrologer app never persists its access token to disk (only the
/// securely-stored refresh token is — see `TokenStore`), so a headless
/// background isolate has no authenticated session to act with. Reusing the
/// already-running/resumed app's session sidesteps a separate token-refresh
/// dance for a background action.
NotificationDetails _notificationDetailsFor(String? type) {
  if (type == 'consultation_request') {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _kDefaultChannelId,
        _kDefaultChannelName,
        importance: Importance.high,
        priority: Priority.high,
        actions: [
          AndroidNotificationAction(_kAcceptActionId, 'Accept', showsUserInterface: true),
          AndroidNotificationAction(_kRejectActionId, 'Reject', showsUserInterface: true),
        ],
      ),
    );
  }
  return const NotificationDetails(
    android: AndroidNotificationDetails(
      _kDefaultChannelId,
      _kDefaultChannelName,
      importance: Importance.high,
      priority: Priority.high,
    ),
  );
}

/// Builds and raises a system-tray notification for [message] on [plugin].
/// Shared by the foreground handler and the background isolate handler so a
/// data-only message (e.g. `consultation_request`) is shown identically no
/// matter which one ends up handling it.
Future<void> _showLocalNotificationForMessage(
  FlutterLocalNotificationsPlugin plugin,
  RemoteMessage message,
) async {
  final data = message.data;
  final type = data['type'] as String?;
  final notification = message.notification;
  final title =
      notification?.title ?? data['title'] as String? ?? _defaultTitleFor(type);
  final body = notification?.body ?? data['body'] as String?;
  await plugin.show(
    message.hashCode,
    title,
    body,
    _notificationDetailsFor(type),
    payload: jsonEncode(data),
  );
}

/// Handles Firebase Cloud Messaging for the astrologer app: initialisation,
/// permission, token registration with the backend (and refresh), and light
/// foreground handling. All FCM calls are guarded so devices/emulators without
/// Google Play services never crash the app.
class PushService {
  PushService(this._api);

  final ApiClient _api;

  /// Used to surface a real system-tray notification while the app is in the
  /// foreground (FCM only auto-displays a system notification when the app is
  /// backgrounded/terminated; in the foreground we must show it ourselves).
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Fired when the astrologer taps Accept/Reject on a `consultation_request`
  /// system notification (see [_onLocalNotificationTapped]). Wired in
  /// `main.dart` to a [PendingRequestAction] hand-off, since this callback
  /// only has a `consultationId` — not the full `Consultation`/`BuildContext`
  /// that the Requests screen's existing accept/decline flow needs.
  void Function(String consultationId, bool accept)? onRequestAction;

  /// Web push requires a Web Push certificate (VAPID) key pair from the Firebase
  /// console (Cloud Messaging → Web configuration). Until that is provisioned we
  /// skip FCM entirely on web so the build/runtime never depend on it.
  ///
  /// TODO: set VAPID key — paste the "Web Push certificates" key pair here to
  /// enable web push notifications for astrologers.
  static const String? _webVapidKey = null;

  bool _messagingReady = false;
  String? _lastRegisteredToken;

  /// Admin-configured web-push VAPID key, captured while fetching the web
  /// Firebase options. Null until fetched / not configured.
  String? _serverVapidKey;

  /// Firebase WEB options from the admin console (`firebase_web.astro` in
  /// GET /public/app-config). Null when unreachable or not yet configured
  /// (api key + web app id are the two fields web init cannot do without).
  Future<FirebaseOptions?> _webOptionsFromServer() async {
    try {
      final data = await _api.get('/public/app-config') as Map<String, dynamic>;
      final all = data['firebase_web'];
      final fb = all is Map ? all['astro'] : null;
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

  /// Token registrations tag the platform so the backend can target correctly.
  String get _platform => kIsWeb ? 'web' : 'android';

  /// Call once at startup (before runApp). Safe to call even without a session;
  /// it only sets up Firebase + listeners. Token registration is deferred to
  /// [registerToken], which must run only when an astrologer is authenticated.
  Future<void> init() async {
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
        // Android reads the baked-in google-services.json.
        await Firebase.initializeApp();
      }
      // Background isolate handler is a native (non-web) concept.
      if (!kIsWeb) {
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
        await _initLocalNotifications();
      }

      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();

      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      // A tapped notification that brought the app to the foreground.
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);
      // A tap that cold-started the app from terminated state.
      final initial = await messaging.getInitialMessage();
      if (initial != null) _onMessageOpened(initial);
      messaging.onTokenRefresh.listen((token) {
        // Re-register on refresh, but only if we've already registered once
        // (i.e. a session exists / existed). Otherwise wait for registerToken.
        if (_lastRegisteredToken != null) {
          _sendToken(token);
        }
      });

      _messagingReady = true;
    } catch (e) {
      // Emulators without Play services, missing config, etc. — degrade quietly.
      debugPrint('[push] init skipped: $e');
    }
  }

  /// Fetch the current FCM token and register it with the backend. Requires an
  /// authenticated astrologer session (the endpoint is authed).
  Future<void> registerToken() async {
    if (!_messagingReady) return;
    try {
      // Admin-configured VAPID key (Firebase → Web app config) wins over the
      // compiled constant; web token minting silently no-ops without one.
      final vapidKey = _serverVapidKey ?? _webVapidKey;
      if (kIsWeb && vapidKey == null) {
        debugPrint('[push] web push token skipped: VAPID key not configured — '
            'add it in the admin console (Firebase → Web app config).');
        return;
      }
      final token = await FirebaseMessaging.instance
          .getToken(vapidKey: kIsWeb ? vapidKey : null);
      if (token == null) return;
      await _sendToken(token);
    } catch (e) {
      debugPrint('[push] registerToken failed: $e');
    }
  }

  /// Unregister the current device token (e.g. on logout). Best-effort —
  /// never blocks logout — but retries once on failure before giving up,
  /// since a single transient blip (the exact moment the access token is
  /// being cleared, a flaky connection, etc.) shouldn't leave a stale token
  /// registered server-side for a device that's actually signed out.
  Future<void> unregisterToken() async {
    if (!_messagingReady) return;
    try {
      final token = _lastRegisteredToken ??
          await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await _unregisterTokenWithRetry(token);
      _lastRegisteredToken = null;
    } catch (e) {
      debugPrint('[push] unregisterToken failed: $e');
    }
  }

  Future<void> _unregisterTokenWithRetry(String token) async {
    try {
      await _api.delete('/astrologer/device',
          body: {'token': token, 'platform': _platform});
    } catch (e) {
      debugPrint('[push] unregisterToken first attempt failed, retrying once: $e');
      await _api.delete('/astrologer/device',
          body: {'token': token, 'platform': _platform});
    }
  }

  Future<void> _sendToken(String token) async {
    try {
      await _api.post('/astrologer/device',
          body: {'token': token, 'platform': _platform});
      _lastRegisteredToken = token;
      debugPrint('[push] token registered');
    } catch (e) {
      debugPrint('[push] token register call failed: $e');
    }
  }

  /// Sets up `flutter_local_notifications` so foreground FCM messages can
  /// surface a real system-tray notification (FCM only auto-displays one when
  /// the app is backgrounded/terminated). Native-platform only (mirrors the
  /// `!kIsWeb` guard around the background handler).
  Future<void> _initLocalNotifications() async {
    await _initLocalNotificationsPlugin(
      flutterLocalNotificationsPlugin,
      onDidReceiveNotificationResponse: _onLocalNotificationTapped,
    );
  }

  /// A tap on a local notification we raised (for a foreground FCM message,
  /// or one shown by the background isolate handler and then tapped once the
  /// app resumed/launched). A tap on an Accept/Reject action routes through
  /// [onRequestAction] instead of navigating directly, since it needs a full
  /// `Consultation`/`BuildContext` that only the Requests screen has; a plain
  /// tap on the notification body routes exactly like [_onMessageOpened] does
  /// for background/terminated taps, by decoding the `data` payload we
  /// stashed on the notification.
  void _onLocalNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final data = Map<String, dynamic>.from(
          jsonDecode(payload) as Map<String, dynamic>);
      debugPrint(
          '[push] local notification tapped: actionId=${response.actionId} data=$data');

      final actionId = response.actionId;
      if (actionId == _kAcceptActionId || actionId == _kRejectActionId) {
        final consultationId = data['consultation_id'] as String?;
        if (consultationId != null) {
          onRequestAction?.call(consultationId, actionId == _kAcceptActionId);
        }
        // Same destination a plain tap on this notification type would use.
        _go('/requests');
        return;
      }

      final location = _locationForType(data['type'] as String?);
      if (location != null) _go(location);
    } catch (e) {
      debugPrint('[push] local notification payload decode failed: $e');
    }
  }

  /// Also raises a real system-tray notification, since FCM does not do this
  /// automatically while the app is in the foreground.
  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('[push] foreground message: ${message.data}');
    if (!kIsWeb) {
      unawaited(_showLocalNotificationForMessage(flutterLocalNotificationsPlugin, message));
    }
  }

  /// Handles a notification tap (foreground-open or cold-start launch): route
  /// by `data.type`. Resilient — a missing/unknown type simply does nothing.
  void _onMessageOpened(RemoteMessage message) {
    debugPrint('[push] notification tapped: ${message.data}');
    final location = _locationForType(message.data['type']);
    if (location != null) _go(location);
  }

  /// The in-app route for a given push `type`. Returns null for unknown types.
  String? _locationForType(String? type) => switch (type) {
        'consultation_request' => '/requests',
        'consultation_ended' => '/earnings',
        _ => null,
      };

  /// Navigate via the root navigator. When called before the first frame
  /// (cold-start launch), the router context isn't ready yet, so retry a few
  /// times on subsequent frames before giving up.
  void _go(String location, {int attempt = 0}) {
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      try {
        context.go(location);
      } catch (e) {
        debugPrint('[push] navigation to $location failed: $e');
      }
      return;
    }
    if (attempt >= 20) return;
    Future<void>.delayed(const Duration(milliseconds: 150),
        () => _go(location, attempt: attempt + 1));
  }
}
