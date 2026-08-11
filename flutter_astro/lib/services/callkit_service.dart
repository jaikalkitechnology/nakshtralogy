import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import 'api_service.dart';
import 'fcm_service.dart' show navigatorKey;
import '../screens/communication/active_call_screen.dart';

/// CallKit / VoIP integration for the astrologer app.
///
/// On iOS a killed or backgrounded app cannot present a full-screen incoming
/// call from an ordinary FCM notification — Apple reserves that for a VoIP
/// (PushKit) push surfaced through CallKit. This service:
///
///   1. registers the device's PushKit VoIP token with the backend, so the
///      server's APNs-VoIP sender (app/services/voip_push.py) can wake the app;
///   2. presents the native CallKit incoming-call UI (also used on Android,
///      where it shows a full-screen ConnectionService call);
///   3. bridges the native Accept / Decline buttons back to our REST call
///      actions and routes an accepted call into [ActiveCallScreen].
///
/// IMPORTANT (native setup required, cannot be done from Dart / this env):
///   • iOS: add the Push Notifications + Background Modes (Voice over IP) caps,
///     an Apple *VoIP Services* certificate/key, and PushKit wiring in
///     AppDelegate that forwards the VoIP push to
///     `SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming`.
///   • Android: `USE_FULL_SCREEN_INTENT` permission (already relying on the
///     FCM full-screen intent today; CallKit here is additive/optional).
/// Run `flutter pub get`, then a real device build + Apple cert are needed to
/// exercise this end to end.
class CallkitService {
  CallkitService._internal();
  static final CallkitService _instance = CallkitService._internal();
  factory CallkitService() => _instance;

  StreamSubscription<dynamic>? _sub;
  bool _initialized = false;
  String? _lastVoipToken;

  /// Wire the CallKit event stream and register the VoIP token. Safe to call on
  /// every app start / login; a no-op on web and after the first init.
  Future<void> init() async {
    if (kIsWeb || _initialized) return;
    _initialized = true;

    try {
      _sub = FlutterCallkitIncoming.onEvent.listen(_onEvent);
    } catch (e) {
      debugPrint('CallKit onEvent listen failed: $e');
    }

    // iOS gives us the PushKit token; Android has no VoIP token (uses FCM).
    await _syncVoipToken();
  }

  /// Fetch the current PushKit VoIP token and push it to the backend. Also
  /// re-invoked from the actionDidUpdateDevicePushTokenVoIP event so a rotated
  /// token is always kept in sync.
  Future<void> _syncVoipToken() async {
    // VoIP tokens are an iOS/PushKit concept only.
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return;
    try {
      final token = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
      await _sendVoipToken(token);
    } catch (e) {
      debugPrint('getDevicePushTokenVoIP failed: $e');
    }
  }

  Future<void> _sendVoipToken(String? token) async {
    final tok = (token ?? '').trim();
    if (tok.isEmpty || tok == _lastVoipToken) return;
    _lastVoipToken = tok;
    try {
      await ApiService().loadTokens();
      if (ApiService().isLoggedIn) {
        await ApiService().registerVoipToken(tok);
        debugPrint('VoIP token registered with backend');
      }
    } catch (e) {
      debugPrint('registerVoipToken failed: $e');
    }
  }

  /// Clear the VoIP token on logout so a signed-out device never rings.
  Future<void> clearVoipToken() async {
    _lastVoipToken = null;
    try {
      if (ApiService().isLoggedIn) {
        await ApiService().registerVoipToken('');
      }
      await FlutterCallkitIncoming.endAllCalls();
    } catch (e) {
      debugPrint('clearVoipToken failed: $e');
    }
  }

  /// Present the native CallKit incoming-call UI from a data payload (the same
  /// shape the FCM/VoIP push carries). On iOS the killed-app case is driven by
  /// the native PushKit handler; this is for the foreground/Android path and as
  /// a Dart-side trigger.
  Future<void> showIncomingCall(Map<String, dynamic> data) async {
    if (kIsWeb) return;
    final callId = (data['call_id'] ?? '').toString();
    if (callId.isEmpty) return;
    final callType = (data['call_type'] ?? 'voice').toString();
    final callerName = (data['caller_name'] ?? 'User').toString();

    final params = CallKitParams(
      id: callId,
      nameCaller: callerName,
      appName: 'Nakshtralogy',
      handle: (data['rate_per_min'] != null)
          ? '₹${data['rate_per_min']}/min'
          : 'Incoming call',
      type: callType == 'video' ? 1 : 0,
      duration: 60000, // ring window ~60s, matches backend CALL_RING_TIMEOUT_SEC
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: false,
        subtitle: 'Missed call',
      ),
      // Everything the accept handler needs to open the live call, so we don't
      // depend on any in-memory state surviving a cold start.
      extra: <String, dynamic>{
        'call_id': callId,
        'call_type': callType,
        'caller_name': callerName,
        'channel_name': data['channel_name'] ?? '',
        'agora_token': data['agora_token'] ?? '',
        'agora_app_id': data['agora_app_id'] ?? '',
        'rate_per_min': data['rate_per_min']?.toString() ?? '0',
      },
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0B0B1F',
        actionColor: '#D4AF37',
        isShowCallID: false,
        isImportant: true,
        isBot: false,
      ),
      ios: const IOSParams(
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        supportsDTMF: false,
        supportsHolding: false,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );

    try {
      await FlutterCallkitIncoming.showCallkitIncoming(params);
    } catch (e) {
      debugPrint('showCallkitIncoming failed: $e');
    }
  }

  /// End/cancel a displayed CallKit call (e.g. caller cancelled, or the call
  /// was answered on another device).
  Future<void> endCall(String callId) async {
    try {
      await FlutterCallkitIncoming.endCall(callId);
    } catch (e) {
      debugPrint('endCall failed: $e');
    }
  }

  // ── Event bridge ─────────────────────────────────────────────────────

  void _onEvent(dynamic event) {
    if (event is! CallEvent) return;
    final body = Map<String, dynamic>.from(event.body ?? {});
    final extra = Map<String, dynamic>.from(body['extra'] ?? {});
    // Merge top-level + extra so we can read call fields regardless of source.
    final data = <String, dynamic>{...body, ...extra};

    switch (event.event) {
      case Event.actionDidUpdateDevicePushTokenVoIP:
        _sendVoipToken((body['deviceTokenVoIP'] ?? body['token'])?.toString());
        break;
      case Event.actionCallAccept:
        _onAccept(data);
        break;
      case Event.actionCallDecline:
      case Event.actionCallTimeout:
        _onDecline(data);
        break;
      case Event.actionCallEnded:
        // Native hang-up while ringing → treat as decline; if already in the
        // live screen, that screen owns the real end.
        break;
      default:
        break;
    }
  }

  void _onAccept(Map<String, dynamic> data) {
    final callId = (data['call_id'] ?? data['id'] ?? '').toString();
    if (callId.isEmpty) return;

    ApiService().loadTokens().then((_) {
      ApiService().callAction(callId, 'accept').then((resp) {
        final ok = resp['statusCode'] == 200 || resp['statusCode'] == 201;
        if (!ok) {
          // Call already gone (cancelled / taken over / expired) → clear UI.
          endCall(callId);
          return;
        }
        final callType = (data['call_type'] ?? 'voice').toString();
        final callerName = (data['caller_name'] ?? 'User').toString();
        final ratePerMin =
            double.tryParse(data['rate_per_min']?.toString() ?? '0') ?? 0;
        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => ActiveCallScreen(
            callId: callId,
            channelName:
                (resp['channel_name'] ?? data['channel_name'] ?? '').toString(),
            agoraToken:
                (resp['agora_token'] ?? data['agora_token'] ?? '').toString(),
            agoraAppId:
                (resp['agora_app_id'] ?? data['agora_app_id'] ?? '').toString(),
            callType: callType,
            peerName: callerName,
            ratePerMin: ratePerMin,
            isAstrologer: true,
          ),
        ));
      }).catchError((e) {
        debugPrint('CallKit accept -> callAction failed: $e');
        endCall(callId);
      });
    });
  }

  void _onDecline(Map<String, dynamic> data) {
    final callId = (data['call_id'] ?? data['id'] ?? '').toString();
    if (callId.isEmpty) return;
    ApiService().loadTokens().then((_) {
      ApiService().callAction(callId, 'reject').catchError((e) {
        debugPrint('CallKit decline -> callAction failed: $e');
        return <String, dynamic>{};
      });
    });
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
