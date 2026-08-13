import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/session_ended_view.dart';
import '../../portal/portal_repository.dart';

/// Astrologer-side audio/video call over Agora. The astrologer joins the channel
/// created at accept-time; the user's per-minute charges settle to the
/// astrologer's balance server-side.
///
/// Lifecycle-aware: backgrounding the app never tears the call down (a real
/// phone/video call keeps running natively regardless of the Flutter app's
/// foreground state, same as any other call app) — but on RESUMING, this
/// screen re-syncs the consultation's status from the server. The backend
/// now auto-ends a consultation whose user-side heartbeat goes silent for
/// 150s, so this app can otherwise be left sitting on a call screen for a
/// session the server has already completed; the re-sync catches that and
/// swaps to [SessionEndedView] instead of leaving a dead call UI up.
class AttendCallScreen extends StatefulWidget {
  const AttendCallScreen({
    super.key,
    required this.grant,
    required this.video,
    required this.consultationId,
    this.userName,
    @visibleForTesting this.agoraOverride,
  });
  final AgoraGrant grant;
  final bool video;
  final String consultationId;

  /// The seeker's display name, shown in the header. Falls back to "Seeker".
  final String? userName;

  /// Widget tests inject an already-"joined" [AgoraCallService] here so the
  /// in-call UI (elapsed timer, controls, back-button guard) can be driven
  /// deterministically without the real Agora native engine — mirrors
  /// `AttendChatScreen.socketFactory` / `GoLiveScreen.cubitOverride`.
  /// Production always leaves this null.
  final AgoraCallService? agoraOverride;

  @override
  State<AttendCallScreen> createState() => _AttendCallScreenState();
}

class _AttendCallScreenState extends State<AttendCallScreen> with WidgetsBindingObserver {
  AgoraCallService? _agora;
  String? _note;
  final _wakelock = getIt<WakelockService>();

  /// Best-effort "earnings so far" for this session, from the astrologer's
  /// own consultation record (`Consultation.astrologerPayout`). The server
  /// only updates it as the SEEKER's heartbeat/messages land (this app never
  /// bills), so it is refreshed opportunistically — right after joining and
  /// on every resume — not live/continuously. Null until the first
  /// successful fetch; never fabricated.
  String? _payout;

  DateTime? _connectedAt;
  Duration _elapsed = Duration.zero;
  Timer? _elapsedTicker;

  /// True once a server re-sync (see [_resync]) finds the consultation is no
  /// longer active — swaps the whole screen to [SessionEndedView].
  bool _sessionEnded = false;
  Timer? _endedPopTimer;

  /// Speaker vs earpiece routing. Agora exposes no getter for the CURRENT
  /// route, so this only tracks what this screen has explicitly set — seeded
  /// with a reasonable default per call type (video calls conventionally
  /// default to loudspeaker; voice calls to the earpiece) rather than ever
  /// querying/assuming the live device state.
  late bool _speakerOn = widget.video;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _join();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_resync());
  }

  Future<void> _join() async {
    final override = widget.agoraOverride;
    if (override != null) {
      // Test-only path — see [agoraOverride]'s doc.
      override.remoteUid.addListener(_refresh);
      override.joined.addListener(_refresh);
      if (!mounted) return;
      setState(() => _agora = override);
      unawaited(_wakelock.acquire());
      unawaited(_resync());
      return;
    }

    final ok = await AgoraCallService.requestPermissions(video: widget.video);
    if (!mounted) return;
    if (!ok) {
      setState(() => _note =
          'Microphone${widget.video ? ' and camera' : ''} permission is required to take this call. Enable it in Settings and try again.');
      return;
    }
    // A placeholder grant from the server (empty/dev app id, or a dev/
    // unavailable token) will never authenticate against Agora and would
    // leave a silent black screen (or crash the native SDK) — surface it
    // clearly instead of attempting to join. NOTE: an empty token with a
    // real app id is a valid App-ID-only Agora project, not a placeholder —
    // AgoraGrant.isPlaceholder already accounts for that.
    if (widget.grant.isPlaceholder) {
      setState(() => _note =
          'Astrologer A/V not available — server Agora token missing.');
      return;
    }
    try {
      final agora = AgoraCallService();
      await agora.init(widget.grant.appId);
      agora.remoteUid.addListener(_refresh);
      agora.joined.addListener(_refresh);
      await agora.join(widget.grant, video: widget.video);
      if (!mounted) return;
      setState(() => _agora = agora);
      // Keep the screen awake only once the call has actually connected.
      unawaited(_wakelock.acquire());
      unawaited(_resync());
    } catch (e, st) {
      debugPrint('[call] Agora join failed: $e\n$st');
      if (!mounted) return;
      setState(() => _note = 'Could not connect the call: $e');
    }
  }

  /// Re-syncs the consultation's status from the server — called right after
  /// joining (to seed [_payout]) and on every app resume (to catch a session
  /// the server ended while this app was backgrounded).
  Future<void> _resync() async {
    try {
      final c = await getIt<PortalRepository>().activeConsultation(widget.consultationId);
      if (!mounted) return;
      if (c == null) {
        await _handleSessionEnded();
        return;
      }
      setState(() => _payout = c.astrologerPayout);
    } on ApiException catch (_) {
      // Best-effort — a re-sync failure must not disrupt an otherwise-live call.
    }
  }

  /// The server says this consultation is no longer active. Tears the call
  /// down immediately (nothing left to show/hear) and swaps to
  /// [SessionEndedView], which auto-returns to Requests shortly after.
  Future<void> _handleSessionEnded() async {
    if (_sessionEnded || !mounted) return;
    _elapsedTicker?.cancel();
    await _agora?.leave();
    await _agora?.dispose();
    unawaited(_wakelock.release());
    if (!mounted) return;
    setState(() => _sessionEnded = true);
    _endedPopTimer = Timer(const Duration(seconds: 2), _backToRequestsNow);
  }

  void _backToRequestsNow() {
    _endedPopTimer?.cancel();
    if (mounted && Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  void _refresh() {
    if (!mounted) return;
    if (_agora?.remoteUid.value != null) _maybeStartElapsedTimer();
    setState(() {});
  }

  void _maybeStartElapsedTimer() {
    if (_connectedAt != null) return;
    _connectedAt = DateTime.now();
    _elapsedTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsed = DateTime.now().difference(_connectedAt!));
    });
  }

  /// Whether there is a live/in-progress call attempt worth protecting from
  /// an accidental back-press — true from the moment permissions/join start
  /// until either a fatal [_note] (nothing left to protect) or the session
  /// is confirmed ended.
  bool get _callActive => _note == null && !_sessionEnded;

  Future<void> _toggleSpeaker() async {
    final agora = _agora;
    if (agora == null) return;
    final next = !_speakerOn;
    await agora.engine?.setEnableSpeakerphone(next);
    if (mounted) setState(() => _speakerOn = next);
  }

  /// "End this call?" confirmation — shared by the End button and the
  /// back-button intercept in [build] so neither can drop a live session
  /// silently. Mirrors `GoLiveScreen._confirmAndEnd`.
  Future<void> _confirmAndEnd() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End this call?'),
        content: const Text(
            "The seeker will be disconnected and this session will end. This can't be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('End', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed == true) await _end();
  }

  Future<void> _end() async {
    _elapsedTicker?.cancel();
    await _agora?.leave();
    unawaited(_wakelock.release());
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _elapsedTicker?.cancel();
    _endedPopTimer?.cancel();
    _agora?.dispose();
    // Unconditional — WakelockPlus.disable() is idempotent, safe even if
    // never acquired (e.g. the join failed before it connected).
    unawaited(_wakelock.release());
    super.dispose();
  }

  String _fmtElapsed(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (_sessionEnded) {
      return Scaffold(
        body: CosmicBackground(
          child: SafeArea(child: SessionEndedView(onBackNow: _backToRequestsNow)),
        ),
      );
    }

    final agora = _agora;
    final remoteJoined = agora?.remoteUid.value != null;
    final connecting = agora == null || !agora.joined.value;
    // The join attempt failed outright (no Agora credentials, permission
    // denied, SDK error) — distinct from "still trying".
    final failed = _note != null && !remoteJoined;
    final seekerName =
        (widget.userName != null && widget.userName!.trim().isNotEmpty) ? widget.userName! : 'Seeker';

    return PopScope(
      // Guard the back button for the whole life of a call attempt (from the
      // moment permissions/join start through an active call) — only free to
      // pop once there's a fatal note (nothing live left to protect) or the
      // session's confirmed ended. Mirrors `GoLiveScreen`'s PopScope guard.
      canPop: !_callActive,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _confirmAndEnd();
      },
      child: Scaffold(
        body: CosmicBackground(
          child: Stack(
            children: [
              Positioned.fill(
                child: (widget.video && remoteJoined)
                    ? agora!.remoteView()
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const DiyaLogo(size: 96),
                            const SizedBox(height: 16),
                            Text(
                              // A fatal note means the attempt is over, so
                              // don't keep claiming it's still connecting —
                              // the reason is spelled out in the banner below.
                              failed
                                  ? "Couldn't connect"
                                  : connecting
                                      ? 'Connecting…'
                                      : (remoteJoined
                                          ? 'Connected'
                                          : 'Waiting for the seeker…'),
                              style: AppTextStyles.body(color: AppColors.ivoryDim),
                            ),
                            if (remoteJoined) ...[
                              const SizedBox(height: 10),
                              Text(_fmtElapsed(_elapsed),
                                  style: AppTextStyles.mono(size: 22, color: AppColors.success)),
                            ],
                          ],
                        ),
                      ),
              ),
              if (widget.video && agora != null && agora.videoEnabled.value)
                Positioned(
                  right: 16,
                  top: 60,
                  width: 108,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: agora.localView(),
                  ),
                ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.video ? 'Video Call' : 'Audio Call',
                                    style: AppTextStyles.heading(size: 18)),
                                Text(seekerName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Always in the header (not just the central visual)
                          // so the elapsed timer stays visible once a video
                          // call is connected and the centre fills with the
                          // remote camera feed instead of the status text.
                          _ConnectionPill(
                            connecting: connecting,
                            remoteJoined: remoteJoined,
                            failed: _note != null && !remoteJoined,
                            elapsedLabel: remoteJoined ? _fmtElapsed(_elapsed) : null,
                          ),
                        ],
                      ),
                    ),
                    if (_payout != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Earnings so far: ₹$_payout',
                              style: AppTextStyles.mono(size: 12, color: AppColors.success)),
                        ),
                      ),
                    if (_note != null)
                      Container(
                        width: double.infinity,
                        color: AppColors.danger.withValues(alpha: 0.14),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Text(_note!, style: AppTextStyles.body(size: 13, color: AppColors.danger)),
                      ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (agora != null) ...[
                            _CallBtn(
                              icon: agora.muted.value ? Icons.mic_off : Icons.mic,
                              onTap: () async {
                                await agora.toggleMute();
                                _refresh();
                              },
                            ),
                            _CallBtn(
                              icon: _speakerOn ? Icons.volume_up : Icons.hearing,
                              onTap: _toggleSpeaker,
                            ),
                            if (widget.video) ...[
                              _CallBtn(icon: Icons.cameraswitch, onTap: agora.switchCamera),
                              _CallBtn(
                                icon: agora.videoEnabled.value ? Icons.videocam : Icons.videocam_off,
                                onTap: () async {
                                  await agora.toggleVideo();
                                  _refresh();
                                },
                              ),
                            ],
                          ],
                          _CallBtn(
                            icon: Icons.call_end,
                            danger: true,
                            onTap: _note == null ? _confirmAndEnd : _end,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small pill in the header summarising connection state at a glance.
class _ConnectionPill extends StatelessWidget {
  const _ConnectionPill({
    required this.connecting,
    required this.remoteJoined,
    this.failed = false,
    this.elapsedLabel,
  });
  final bool connecting;
  final bool remoteJoined;

  /// The join failed outright (no Agora credentials, permission denied, SDK
  /// error). Without this the pill kept saying "Connecting" forever directly
  /// above the red error banner explaining that it could not connect — the
  /// astrologer had no way to tell it had actually given up.
  final bool failed;

  /// Formatted elapsed-time string (e.g. `"02:15"`), shown appended to the
  /// "Live" label once the seeker has joined. Null while not yet connected.
  final String? elapsedLabel;

  @override
  Widget build(BuildContext context) {
    final Color color = failed
        ? AppColors.danger
        : connecting
            ? AppColors.gold
            : (remoteJoined ? AppColors.success : AppColors.info);
    final String label = failed
        ? "Can't connect"
        : connecting
            ? 'Connecting'
            : (remoteJoined ? 'Live · ${elapsedLabel ?? ''}' : 'Waiting');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.mono(size: 11, color: color)),
        ],
      ),
    );
  }
}

class _CallBtn extends StatelessWidget {
  const _CallBtn({required this.icon, required this.onTap, this.danger = false});
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: danger ? AppColors.danger : AppColors.surface2,
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Icon(icon, color: danger ? Colors.white : AppColors.ivory),
      ),
    );
  }
}
