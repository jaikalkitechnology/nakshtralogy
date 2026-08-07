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
  // When the currently-registered token was obtained. Used to ignore the iOS
  // Safari token rotation that fires shortly after the permission grant — that
  // rotated token is not yet valid for delivery, so we keep the grant-time one.
  DateTime? _tokenAt;

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
    // The token obtained right here, from the permission grant, is the one that
    // actually works on iOS Safari. We register it ONCE and then keep it — we do
    // NOT re-fetch a new token afterwards, because on iOS the token fetched a
    // little later (e.g. when the dashboard loads) is a different, not-yet-valid
    // token that would overwrite this good one and break delivery.
    await _getAndRegisterToken();
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
        // On iOS Safari a rotation fires within seconds of the permission grant,
        // handing us a token that is NOT yet valid for delivery. Ignore refreshes
        // that arrive right after we registered the working grant-time token;
        // honour genuine later rotations.
        if (_tokenAt != null && DateTime.now().difference(_tokenAt!) < const Duration(seconds: 90)) {
          debugPrint('WebPush: ignoring post-grant token rotation (iOS)');
          return;
        }
        if (newToken == _token) return;
        _token = newToken;
        _tokenAt = DateTime.now();
        await _register();
      });

      // Firebase web + the foreground handler are ready. We do NOT register a
      // token here: the push token is registered ONCE by the login/signup call
      // (FcmService().getToken()). Registering a second token from the dashboard
      // is exactly what broke iOS delivery (the device holds only one push
      // registration). This service now only handles Firebase init, permission
      // (Enable tap), and foreground display.
      _initialized = true;
    } catch (e) {
      _error = 'WebPush init error: $e';
      debugPrint(_error!);
    }
  }

  /// Re-register the RECENT grant-time token if we have one, otherwise fetch a
  /// fresh token. The persisted token is only re-used for a short window (15 min)
  /// so a login → dashboard hop / quick PWA reopen keeps the working iOS token;
  /// after that we fetch a fresh token (getToken returns the current valid one,
  /// which handles genuine rotation / expiry so we never cling to a dead token).
  static const Duration _tokenReuseWindow = Duration(minutes: 15);
  Future<void> _registerPersistedOrFetch() async {
    final saved = webLoadToken();
    final savedAt = webTokenSavedAtMs();
    final fresh = saved != null && saved.isNotEmpty && savedAt != null &&
        (DateTime.now().millisecondsSinceEpoch - savedAt) < _tokenReuseWindow.inMilliseconds;
    if (fresh) {
      _token = saved;
      _tokenAt = DateTime.now();
      await _register();
    } else {
      await _getAndRegisterToken();
    }
  }

  /// Get the web token and register it. Assumes permission is already granted —
  /// does NOT request it (see [enableFromGesture] for the request path). The
  /// obtained token is persisted so later opens re-use it instead of refetching.
  Future<void> _getAndRegisterToken() async {
    final m = _messaging;
    if (m == null) return;
    try {
      _token = await m.getToken(vapidKey: _vapid);
      _tokenAt = DateTime.now();
      _error = _token == null ? 'Token not issued (check VAPID / service worker)' : null;
      if (_token != null && _token!.isNotEmpty) webSaveToken(_token!);
      debugPrint('WebPush token: ${_token != null ? "${_token!.substring(0, 12)}..." : "NULL"}');
      await _register();
    } catch (e) {
      _error = 'WebPush token fetch error: $e';
      debugPrint(_error!);
    }
  }

  /// Call after every login. If we already hold a token obtained THIS session
  /// (e.g. from the user's Enable tap), just re-register that SAME token for the
  /// new account — do NOT fetch a new one, because on iOS Safari a freshly
  /// fetched token right after grant is not yet valid and would replace the
  /// working one. Only when we have no token yet (returning user whose grant
  /// happened in a previous session, so rotation already settled) do we fetch.
  Future<void> registerAfterLogin() async {
    if (!kIsWeb) return;
    if (webNotificationPermission() != 'granted') return;
    if (_token != null && _token!.isNotEmpty) {
      await _register();           // re-bind the in-memory token
      return;
    }
    if (!_initialized || _messaging == null) {
      await init();                // init() re-registers the persisted token
    } else {
      await _registerPersistedOrFetch();
    }
  }

  /// Call on logout: forget the token (memory + persisted) so the next account
  /// starts clean. The backend token is cleared separately by the logout API.
  void clearOnLogout() {
    _token = null;
    _tokenAt = null;
    webClearToken();
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
