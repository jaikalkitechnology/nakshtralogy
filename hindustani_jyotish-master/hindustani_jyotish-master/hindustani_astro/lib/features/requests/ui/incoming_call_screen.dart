import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../router/app_router.dart';
import '../../portal/portal_repository.dart';
import 'attend_call_screen.dart';

/// Route names for the ringing + live attend-call screens. Naming them lets a
/// call accepted from OUTSIDE the app (an FCM notification tap or the CallKit
/// accept) clear any lingering ring/active-call route off the navigator stack,
/// so ending the call returns to the dashboard rather than a stale "previous
/// call" screen (see [openAttendCall]) — ported from Nakshtralogy's
/// `openAstroActiveCall`.
const String kIncomingCallRoute = 'astro_incoming_call';
const String kAttendCallRoute = 'astro_attend_call';

/// De-duplicates an incoming call that arrives over more than one channel.
/// The same call can be pushed by FCM (foreground message, notification tap)
/// AND — on iOS — by a VoIP/CallKit event, so without this the ring screen
/// could open twice. Every show-site asks [firstTime] before presenting; only
/// the first delivery for a `callId` (within the window) returns true.
class IncomingCallGuard {
  IncomingCallGuard._();
  static final Map<String, int> _seen = {};

  static bool firstTime(String callId) {
    if (callId.isEmpty) return true;
    final now = DateTime.now().millisecondsSinceEpoch;
    _seen.removeWhere((_, t) => now - t > 90000); // forget after 90s
    if (_seen.containsKey(callId)) return false;
    _seen[callId] = now;
    return true;
  }

  /// Forget a call so a later, genuinely-new ring for the same id is allowed
  /// (e.g. after the call ended and a fresh request arrives). Optional — the
  /// 90s window already expires stale entries on its own.
  static void forget(String callId) => _seen.remove(callId);
}

/// Presents the astrologer ring for [callId] if it hasn't already been shown
/// via another channel. Uses the root navigator so it works from a
/// `BuildContext`-less push handler. Safe to call from anywhere.
void presentIncomingCall({
  required String callId,
  required String callerName,
  required String callType, // 'call' | 'video'
  required double rate,
}) {
  if (callId.isEmpty) return;
  if (!IncomingCallGuard.firstTime(callId)) return;
  final nav = rootNavigatorKey.currentState;
  if (nav == null) return;
  nav.push(MaterialPageRoute(
    settings: const RouteSettings(name: kIncomingCallRoute),
    builder: (_) => IncomingCallScreen(
      consultationId: callId,
      callerName: callerName,
      callType: callType,
      rate: rate,
    ),
  ));
}

/// Opens the live [AttendCallScreen] after an accept that came from OUTSIDE the
/// in-app ring (an FCM notification / CallKit accept), pushing it while removing
/// any ring (and any previous attend-call) route still underneath — otherwise
/// ending this call would drop the astrologer back onto the old ring/live UI
/// instead of the dashboard. Only non-call routes are kept.
void openAttendCall({
  required AgoraGrant grant,
  required bool video,
  required String consultationId,
  String? userName,
}) {
  final nav = rootNavigatorKey.currentState;
  if (nav == null) return;
  nav.pushAndRemoveUntil(
    MaterialPageRoute(
      settings: const RouteSettings(name: kAttendCallRoute),
      builder: (_) => AttendCallScreen(
        grant: grant,
        video: video,
        consultationId: consultationId,
        userName: userName,
      ),
    ),
    (route) =>
        route.settings.name != kIncomingCallRoute &&
        route.settings.name != kAttendCallRoute,
  );
}

/// Full-screen ring shown to the astrologer for an incoming call/video request.
/// ~60s auto-decline countdown; Accept calls the same accept endpoint the
/// Requests screen uses and routes into [AttendCallScreen]; Decline calls the
/// decline endpoint. Themed with `hj_core` [AppColors] / [AppTextStyles]
/// (dark-only), adapted from Nakshtralogy's `IncomingCallScreen`.
class IncomingCallScreen extends StatefulWidget {
  const IncomingCallScreen({
    super.key,
    required this.consultationId,
    required this.callerName,
    required this.callType,
    required this.rate,
  });

  final String consultationId;
  final String callerName;
  final String callType; // 'call' | 'video'
  final double rate;

  bool get isVideo => callType == 'video';

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  final _repo = getIt<PortalRepository>();
  int _countdown = 60;
  Timer? _timer;
  bool _responding = false;
  bool _expired = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _checkStillRinging();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_countdown <= 1) {
        _timer?.cancel();
        setState(() {
          _countdown = 0;
          _expired = true;
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.of(context).maybePop();
        });
        return;
      }
      setState(() => _countdown--);
    });
  }

  /// The backend has no single-consultation GET; the active-list lookup tells
  /// us whether this request is still outstanding. Null → already handled
  /// elsewhere / expired, so surface the expired state instead of a dead ring.
  Future<void> _checkStillRinging() async {
    try {
      final c = await _repo.activeConsultation(widget.consultationId);
      if (!mounted || _responding) return;
      if (c == null) {
        _timer?.cancel();
        setState(() => _expired = true);
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.of(context).maybePop();
        });
      }
    } catch (_) {
      // Transient failure — leave the ring up; the countdown still protects us.
    }
  }

  Future<void> _accept() async {
    if (_responding || _expired) return;
    setState(() => _responding = true);
    _timer?.cancel();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l = AppLocalizations.of(context);
    try {
      final res = await _repo.accept(widget.consultationId);
      if (!mounted) return;
      final agoraRaw = res['agora'];
      if (agoraRaw is! Map<String, dynamic>) {
        messenger.showSnackBar(SnackBar(content: Text(l.callCouldNotStart)));
        navigator.maybePop();
        return;
      }
      final grant = AgoraGrant.fromJson(agoraRaw);
      // Replace the ring with the live call, clearing any other ring/active
      // route so ending the call returns to the dashboard.
      openAttendCall(
        grant: grant,
        video: widget.isVideo,
        consultationId: widget.consultationId,
        userName: widget.callerName,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      navigator.maybePop();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
      navigator.maybePop();
    }
  }

  Future<void> _decline() async {
    if (_responding) return;
    setState(() => _responding = true);
    _timer?.cancel();
    final navigator = Navigator.of(context);
    try {
      await _repo.decline(widget.consultationId);
    } catch (_) {
      // Best-effort — the server also auto-expires an unanswered request.
    }
    if (mounted) navigator.maybePop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final urgent = _countdown <= 10;
    return Scaffold(
      backgroundColor: AppColors.indigoVoid,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            _avatar(),
            const SizedBox(height: 24),
            if (!_expired) ...[
              Text(
                widget.isVideo ? l.callIncomingVideo : l.callIncomingVoice,
                style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  widget.callerName.trim().isNotEmpty ? widget.callerName : 'Seeker',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.display(size: 24, weight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l.callRatePerMin(widget.rate.toStringAsFixed(0)),
                style: AppTextStyles.mono(size: 15, color: AppColors.saffron),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: urgent ? AppColors.danger.withValues(alpha: 0.18) : AppColors.surface2,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: urgent ? AppColors.danger : AppColors.borderSoft,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer,
                        size: 16,
                        color: urgent ? AppColors.danger : AppColors.ivoryDim),
                    const SizedBox(width: 6),
                    Text(
                      l.callAutoDeclineIn(_countdown),
                      style: AppTextStyles.body(
                        size: 13,
                        weight: urgent ? FontWeight.w700 : FontWeight.w500,
                        color: urgent ? AppColors.danger : AppColors.ivoryDim,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 4),
              Text(l.callExpired,
                  style: AppTextStyles.display(size: 22, color: AppColors.danger)),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(l.callExpiredBody,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
              ),
            ],
            const Spacer(flex: 3),
            if (!_expired)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _action(
                      color: AppColors.danger,
                      icon: Icons.call_end,
                      label: l.callDecline,
                      onTap: _responding ? null : _decline,
                    ),
                    _action(
                      color: AppColors.success,
                      icon: widget.isVideo ? Icons.videocam : Icons.call,
                      label: _responding ? l.callConnecting : l.callAccept,
                      onTap: _responding ? null : _accept,
                    ),
                  ],
                ),
              )
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(200, 48)),
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(l.callDecline),
              ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    final expired = _expired;
    final ring = AnimatedBuilder(
      animation: _pulse,
      builder: (_, child) =>
          Transform.scale(scale: 1.0 + _pulse.value * 0.1, child: child),
      child: _avatarCircle(AppColors.saffron, Icons.person),
    );
    return expired
        ? _avatarCircle(AppColors.danger, Icons.call_end)
        : ring;
  }

  Widget _avatarCircle(Color color, IconData icon) => Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface2,
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
                color: color.withValues(alpha: 0.30),
                blurRadius: 30,
                spreadRadius: 5),
          ],
        ),
        child: Icon(icon, color: color, size: 48),
      );

  Widget _action({
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: onTap == null ? color.withValues(alpha: 0.4) : color,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.30), blurRadius: 12),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.mono(size: 12, color: color)),
      ],
    );
  }
}
