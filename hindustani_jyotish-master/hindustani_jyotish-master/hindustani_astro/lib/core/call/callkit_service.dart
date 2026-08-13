import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:hj_core/hj_core.dart';

import '../../features/portal/portal_repository.dart';
import '../../features/requests/ui/incoming_call_screen.dart';
import '../di.dart';

/// CallKit / VoIP integration for the astrologer app.
///
/// On iOS a killed or backgrounded app cannot present a full-screen incoming
/// call from an ordinary FCM notification — Apple reserves that for a VoIP
/// (PushKit) push surfaced through CallKit. This service:
///
///   1. presents the native CallKit incoming-call UI (also used on Android,
///      where it shows a full-screen ConnectionService call);
///   2. bridges the native Accept / Decline buttons back to our REST accept /
///      decline actions and routes an accepted call into [AttendCallScreen]
///      (clearing any ring/active-call route via [openAttendCall]).
///
/// IMPORTANT — native setup still required (cannot be done from Dart / here,
/// and NOT verifiable in this environment — see the report's "iOS CallKit
/// native steps" section):
///   • iOS: Push Notifications + Background Modes (Voice over IP) capabilities,
///     an Apple VoIP Services certificate/key, PushKit wiring in AppDelegate
///     forwarding the VoIP push to
///     `SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming`,
///     AND a backend APNs-VoIP sender + a VoIP-token registration endpoint
///     (neither exists yet — deferred).
///   • Android: `USE_FULL_SCREEN_INTENT` permission (added to the manifest).
class CallkitService {
  CallkitService._internal();
  static final CallkitService _instance = CallkitService._internal();
  factory CallkitService() => _instance;

  StreamSubscription<CallEvent?>? _sub;
  bool _initialized = false;

  PortalRepository get _repo => getIt<PortalRepository>();

  /// Wire the CallKit event stream. Safe to call on every app start / login;
  /// a no-op on web and after the first init.
  Future<void> init() async {
    if (kIsWeb || _initialized) return;
    _initialized = true;
    try {
      _sub = FlutterCallkitIncoming.onEvent.listen(_onEvent);
    } catch (e) {
      debugPrint('[callkit] onEvent listen failed: $e');
    }
    // NOTE: iOS VoIP-token registration is intentionally NOT wired to the
    // existing `/astrologer/device` endpoint — that feeds the FCM sender,
    // which cannot deliver to a PushKit token. A dedicated VoIP endpoint +
    // APNs-VoIP sender is required first (deferred; documented in the report).
  }

  /// Present the native CallKit incoming-call UI from a data payload (the same
  /// shape the FCM/VoIP push carries). On iOS the killed-app case is driven by
  /// the native PushKit handler; this is for the foreground/Android path and as
  /// a Dart-side trigger.
  Future<void> showIncomingCall(Map<String, dynamic> data) async {
    if (kIsWeb) return;
    final callId = (data['call_id'] ?? data['consultation_id'] ?? '').toString();
    if (callId.isEmpty) return;
    if (!IncomingCallGuard.firstTime(callId)) return;
    final callType = (data['call_type'] ?? 'call').toString();
    final callerName = (data['caller_name'] ?? 'Seeker').toString();

    final params = CallKitParams(
      id: callId,
      nameCaller: callerName,
      appName: 'Hindustani Jyotish',
      handle: data['rate'] != null ? '₹${data['rate']}/min' : 'Incoming call',
      type: callType == 'video' ? 1 : 0,
      duration: 60000, // ring window ~60s, matches the request-expiry ring
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: false,
        subtitle: 'Missed call',
      ),
      // Everything the accept handler needs, so it survives a cold start.
      extra: <String, dynamic>{
        'consultation_id': callId,
        'call_id': callId,
        'call_type': callType,
        'caller_name': callerName,
        'rate': data['rate']?.toString() ?? '0',
      },
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0B0B1E',
        actionColor: '#F4811F',
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
      debugPrint('[callkit] showCallkitIncoming failed: $e');
    }
  }

  /// End/cancel a displayed CallKit call (caller cancelled / answered elsewhere).
  Future<void> endCall(String callId) async {
    try {
      await FlutterCallkitIncoming.endCall(callId);
    } catch (e) {
      debugPrint('[callkit] endCall failed: $e');
    }
  }

  // ── Event bridge ─────────────────────────────────────────────────────

  void _onEvent(CallEvent? event) {
    if (event == null) return;
    final body = Map<String, dynamic>.from(event.body as Map? ?? {});
    final extra = Map<String, dynamic>.from(body['extra'] as Map? ?? {});
    final data = <String, dynamic>{...body, ...extra};

    // Match on the event NAME rather than the enum member: the exact member
    // spellings differ between flutter_callkit_incoming versions, and
    // referencing a missing one would be a compile error.
    final name = event.event.toString().split('.').last.toLowerCase();
    if (name.contains('accept')) {
      _onAccept(data);
    } else if (name.contains('decline') || name.contains('timeout')) {
      _onDecline(data);
    }
    // actionCallEnded while ringing needs no action; the live screen owns a
    // real end once accepted.
  }

  Future<void> _onAccept(Map<String, dynamic> data) async {
    final id = (data['consultation_id'] ?? data['call_id'] ?? data['id'] ?? '').toString();
    if (id.isEmpty) return;
    final callType = (data['call_type'] ?? 'call').toString();
    final callerName = (data['caller_name'] ?? 'Seeker').toString();
    try {
      final res = await _repo.accept(id);
      final agoraRaw = res['agora'];
      if (agoraRaw is! Map<String, dynamic>) {
        await endCall(id);
        return;
      }
      openAttendCall(
        grant: AgoraGrant.fromJson(agoraRaw),
        video: callType == 'video',
        consultationId: id,
        userName: callerName,
      );
    } catch (e) {
      debugPrint('[callkit] accept -> accept endpoint failed: $e');
      await endCall(id);
    }
  }

  Future<void> _onDecline(Map<String, dynamic> data) async {
    final id = (data['consultation_id'] ?? data['call_id'] ?? data['id'] ?? '').toString();
    if (id.isEmpty) return;
    try {
      await _repo.decline(id);
    } catch (e) {
      debugPrint('[callkit] decline -> decline endpoint failed: $e');
    }
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
