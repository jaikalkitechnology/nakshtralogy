import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../widgets/session_review_dialog.dart';
import '../../widgets/recharge_sheet.dart';

class CallScreen extends StatefulWidget {
  final String callId;
  final String channelName;
  final String agoraToken;
  final String agoraAppId;
  final String callType; // voice | video
  final String astrologerName;
  final double ratePerMin;
  final int eligibleMinutes;
  final int maxCallSeconds;

  const CallScreen({
    super.key,
    required this.callId,
    required this.channelName,
    required this.agoraToken,
    required this.agoraAppId,
    required this.callType,
    required this.astrologerName,
    required this.ratePerMin,
    this.eligibleMinutes = 0,
    this.maxCallSeconds = 0,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> with WidgetsBindingObserver {
  final _api = ApiService();
  RtcEngine? _engine;
  String _status = 'ringing';
  int _seconds = 0;
  Timer? _timer;
  Timer? _maxTimer;
  Timer? _pollTimer;
  Timer? _rtcGraceTimer;         // grace window before ending on a remote drop
  bool _peerReconnecting = false;
  // Server-authoritative billing (from GET /call/{id}) — replaces the local
  // timer's cost estimate, which drifts on a backgrounded web tab.
  Timer? _billingTimer;
  double _serverBilled = -1;     // <0 = not yet received
  double _serverBalance = 0;
  int _serverRemaining = -1;
  bool _lowWarned = false;
  bool _low = false;             // persistent low-balance banner (mid-call recharge)
  String _currency = 'INR';      // 'USD' for international callers (5× rule)
  double _fx = 0;                // INR per 1 USD (from server meter)
  bool _isMuted = false;
  bool _isSpeaker = false;
  bool _isVideoEnabled = true;
  bool _remoteJoined = false;
  int? _remoteUid;
  bool _ending = false;
  // Set when Agora fails to initialize in a browser (unsupported web A/V).
  // Chat/auth are never blocked by this — only this call screen degrades.
  bool _webAvUnavailable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initAgora();
    _startPollingCallStatus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Only end the call when the app is really being torn down (detached).
    // 'paused' fires for a notification pull-down, a screen lock, or an
    // app-switch — ending on that killed calls the moment the user glanced
    // away. On web 'paused' isn't reliably delivered for a backgrounded tab
    // anyway, so we keep the RTC connection through background and let the
    // user return to the live call.
    if (state == AppLifecycleState.detached) {
      _endCall(fromLifecycle: true);
    } else if (state == AppLifecycleState.resumed) {
      // Returning to the foreground: verify the call is still live. If the
      // astrologer ended it while we were away, close now instead of waiting
      // for the next billing poll (and never leave a dead call on screen).
      _refreshCallOnResume();
    }
  }

  Future<void> _refreshCallOnResume() async {
    if (_ending) return;
    try {
      final r = await _api.getCall(widget.callId);
      final st = (r['status'] ?? '').toString();
      if (st.isNotEmpty && st != 'active' && st != 'ringing') {
        if (mounted) _endCall();
      }
    } catch (_) {/* transient — billing poll will catch it */}
  }

  /// Poll backend every 2s to detect when call becomes active/completed.
  /// This handles the case where Agora onUserJoined doesn't fire (dev tokens).
  void _startPollingCallStatus() {
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (_status == 'active' || _ending) { _pollTimer?.cancel(); return; }
      try {
        final resp = await _api.getCall(widget.callId);
        final callStatus = resp['status'] ?? '';
        if (callStatus == 'active' && _status != 'active') {
          setState(() => _status = 'active');
          _startTimer();
          _startMaxTimer();
          _startBillingRefresh();
          _pollTimer?.cancel();
        } else if (callStatus == 'missed' || callStatus == 'rejected' || callStatus == 'cancelled' || callStatus == 'expired') {
          _pollTimer?.cancel();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Call $callStatus')));
            _endCall();
          }
        }
      } catch (_) {}
    });
  }

  Future<void> _initAgora() async {
    // Request permissions. `permission_handler` is a native plugin and throws
    // on web — the browser prompts for mic/cam itself when the engine joins,
    // so we skip explicit requests on web.
    if (!kIsWeb) {
      if (widget.callType == 'video') {
        await [Permission.camera, Permission.microphone].request();
      } else {
        await Permission.microphone.request();
      }
    }

    try {
      // Create RTC engine
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(
        appId: widget.agoraAppId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));

    // Register event handlers
    _engine!.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        debugPrint('User joined channel: ${connection.channelId}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Joined channel ${connection.channelId}'),
            backgroundColor: AppColors.success, duration: const Duration(seconds: 2),
          ));
        }
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        debugPrint('Remote user joined: $remoteUid');
        // Cancel any in-flight reconnect grace — the peer is back.
        _rtcGraceTimer?.cancel();
        if (_peerReconnecting && mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
        setState(() {
          _remoteJoined = true;
          _remoteUid = remoteUid;
          _status = 'active';
          _peerReconnecting = false;
        });
        _pollTimer?.cancel();
        _startTimer();
        _startMaxTimer();
        _startBillingRefresh();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)?.callActive ?? 'Call active'),
            backgroundColor: AppColors.success, duration: const Duration(seconds: 2),
          ));
        }
      },
      onUserOffline: (connection, remoteUid, reason) {
        debugPrint('Remote user left: $remoteUid reason=$reason');
        // The astrologer intentionally hung up (quit) → end cleanly and say so,
        // instead of showing "Reconnecting…" for the whole grace window. Only a
        // genuine network drop gets the reconnect grace.
        if (reason == UserOfflineReasonType.userOfflineQuit) {
          _endCall(endedBy: 'astrologer');
          return;
        }
        setState(() {
          _remoteJoined = false;
          _remoteUid = null;
          _peerReconnecting = true;
        });
        // Grace window: a brief network blip shouldn't end the call. Wait for the
        // peer to rejoin; only end if they don't come back in time.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Reconnecting…'),
            duration: Duration(seconds: 20), backgroundColor: AppColors.card));
        }
        _rtcGraceTimer?.cancel();
        _rtcGraceTimer = Timer(const Duration(seconds: 20), () {
          if (mounted && _peerReconnecting) _endCall(endedBy: 'astrologer');
        });
      },
      onConnectionStateChanged: (connection, state, reason) {
        debugPrint('Agora connection: state=$state reason=$reason');
        if (mounted && state == ConnectionStateType.connectionStateFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Connection failed: $reason. Check Agora credentials.'),
            backgroundColor: AppColors.error, duration: const Duration(seconds: 5),
          ));
        }
      },
      onError: (err, msg) {
        debugPrint('Agora error: $err $msg');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Agora error: $err${msg.isNotEmpty ? " — $msg" : ""}'),
            backgroundColor: AppColors.error, duration: const Duration(seconds: 4),
          ));
        }
      },
    ));

    // Configure audio/video
    if (widget.callType == 'video') {
      await _engine!.enableVideo();
      await _engine!.startPreview();
    } else {
      await _engine!.disableVideo();
    }
    // Audio routing is a mobile concept; the call throws on web — skip it.
    if (!kIsWeb) {
      await _engine!.setDefaultAudioRouteToSpeakerphone(false);
    }

    // Join channel as UID=1 (caller)
    await _engine!.joinChannel(
      token: widget.agoraToken,
      channelId: widget.channelName,
      uid: 1,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishMicrophoneTrack: true,
        publishCameraTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
    } catch (e) {
      debugPrint('Agora init error: $e');
      if (kIsWeb) {
        // Web A/V unavailable in this browser — degrade gracefully rather than
        // trapping the user on a dead call screen.
        if (mounted) setState(() => _webAvUnavailable = true);
        return;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Agora init failed: $e'),
          backgroundColor: AppColors.error, duration: const Duration(seconds: 5),
        ));
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  void _startMaxTimer() {
    if (widget.maxCallSeconds > 0) {
      // Warn 60s before max
      final warnAt = widget.maxCallSeconds - 60;
      _maxTimer = Timer(Duration(seconds: widget.maxCallSeconds), () {
        _endCall();
      });
      // Also set up a warning timer
      if (warnAt > 0) {
        Timer(Duration(seconds: warnAt), () {
          if (mounted && _status == 'active') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)?.lessThanOneMin ?? 'Less than 1 minute remaining'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        });
      }
    }
  }

  /// Poll the server's authoritative meter every 10s during an active call:
  /// render the real billed amount, warn on low balance, and auto-end when the
  /// funded time runs out (a client backstop to the server watchdog).
  void _startBillingRefresh() {
    _billingTimer?.cancel();
    _billingTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      if (!mounted || _status != 'active' || _ending) return;
      try {
        final r = await _api.getCall(widget.callId);
        if (!mounted) return;
        if (r['status'] != null && r['status'] != 'active') { _endCall(); return; }
        setState(() {
          _serverBilled = (r['billed_so_far'] as num?)?.toDouble() ?? _serverBilled;
          _serverBalance = (r['user_balance'] as num?)?.toDouble() ?? _serverBalance;
          _serverRemaining = (r['remaining_seconds'] as num?)?.toInt() ?? _serverRemaining;
          _currency = r['currency']?.toString() ?? _currency;
          _fx = (r['fx_rate'] as num?)?.toDouble() ?? _fx;
        });
        final low = r['low_balance'] == true;
        if (mounted) setState(() => _low = low);
        if (low && !_lowWarned && mounted) {
          _lowWarned = true;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)?.lessThanOneMin ?? 'Balance low — under a minute left'),
            backgroundColor: Colors.orange, duration: const Duration(seconds: 5)));
        }
        if (_serverRemaining == 0) _endCall();
      } catch (_) {}
    });
  }

  /// Mid-call recharge: open the recharge sheet WITHOUT ending the call. On
  /// success, clear the low-balance state and immediately refresh billing so the
  /// new balance extends the remaining time and the call keeps going.
  Future<void> _rechargeMidCall() async {
    final ok = await showRechargeSheet(context, suggested: (widget.ratePerMin * 5));
    if (!mounted) return;
    if (ok) {
      setState(() { _low = false; _lowWarned = false; });
      try {
        final r = await _api.getCall(widget.callId);
        if (!mounted) return;
        setState(() {
          _serverBalance = (r['user_balance'] as num?)?.toDouble() ?? _serverBalance;
          _serverRemaining = (r['remaining_seconds'] as num?)?.toInt() ?? _serverRemaining;
          _low = r['low_balance'] == true;
        });
      } catch (_) {}
    }
  }

  String get _formattedTime {
    final min = _seconds ~/ 60;
    final sec = _seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  double get _currentCost =>
      _serverBilled >= 0 ? _serverBilled : (_seconds / 60).ceil() * widget.ratePerMin;

  /// Format an INR-ledger amount in the caller's display currency. International
  /// callers (5× rule) see USD = ₹amount ÷ fx; India keeps ₹.
  String _money(double inr) => (_currency == 'USD' && _fx > 0)
      ? '\$${(inr / _fx).toStringAsFixed(2)}'
      : '₹${inr.toStringAsFixed(0)}';

  int get _remainingSeconds {
    if (widget.maxCallSeconds <= 0) return 9999;
    return widget.maxCallSeconds - _seconds;
  }

  String get _remainingTime {
    final rem = _remainingSeconds;
    if (rem > 9000) return '';
    final min = rem ~/ 60;
    final sec = rem % 60;
    return '${min}m ${sec}s left';
  }

  Future<void> _toggleMute() async {
    setState(() => _isMuted = !_isMuted);
    await _engine?.muteLocalAudioStream(_isMuted);
  }

  Future<void> _toggleSpeaker() async {
    setState(() => _isSpeaker = !_isSpeaker);
    // setEnableSpeakerphone is a mobile-only audio-route API — calling it on
    // web can throw. The browser manages the output device itself.
    if (kIsWeb) return;
    try {
      await _engine?.setEnableSpeakerphone(_isSpeaker);
    } catch (_) {/* audio route not switchable on this platform */}
  }

  Future<void> _toggleVideo() async {
    if (widget.callType != 'video') return;
    setState(() => _isVideoEnabled = !_isVideoEnabled);
    await _engine?.muteLocalVideoStream(!_isVideoEnabled);
  }

  Future<void> _switchCamera() async {
    if (widget.callType != 'video') return;
    await _engine?.switchCamera();
  }

  Future<void> _endCall({bool fromLifecycle = false, String? endedBy}) async {
    if (_ending) return;
    _ending = true;
    // Stop EVERYTHING that could keep showing "Reconnecting…" or re-poll behind
    // the review dialog: all timers, the reconnect grace, and any live snackbar.
    _timer?.cancel();
    _maxTimer?.cancel();
    _pollTimer?.cancel();
    _billingTimer?.cancel();
    _rtcGraceTimer?.cancel();
    _peerReconnecting = false;
    if (mounted) ScaffoldMessenger.of(context).clearSnackBars();

    try {
      await _engine?.leaveChannel();
      await _engine?.release();
    } catch (_) {}

    bool wasConnected = false;
    try {
      wasConnected = (_status == 'active' || _remoteJoined);
      final action = wasConnected ? 'end' : 'cancel';
      await _api.callAction(widget.callId, action);
    } catch (_) {}

    // Tell the user who ended (the peer hung up) so it isn't a silent drop.
    if (endedBy != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Call ended by ${endedBy == 'astrologer' ? widget.astrologerName : endedBy}'),
        backgroundColor: AppColors.card, duration: const Duration(seconds: 4)));
    }

    // Prompt for a rating only for calls that actually connected — never for a
    // cancelled/unanswered call. Skippable; not shown when ended by lifecycle.
    if (wasConnected && !fromLifecycle && mounted) {
      await showSessionReviewDialog(
        context,
        sessionType: widget.callType,   // voice | video
        sessionId: widget.callId,
        astrologerName: widget.astrologerName,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _maxTimer?.cancel();
    _pollTimer?.cancel();
    _rtcGraceTimer?.cancel();
    _billingTimer?.cancel();
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = widget.callType == 'video';

    // Graceful web fallback when Agora A/V can't initialize in this browser.
    if (_webAvUnavailable) {
      final l = AppLocalizations.of(context);
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.videocam_off, color: AppColors.textSecondary, size: 56),
                const SizedBox(height: 16),
                Text(
                  l?.awVideoUnsupported ??
                      "Video calls aren't supported in this browser. Please use our mobile app or a supported desktop browser.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _endCall(),
                  child: Text(l?.awClose ?? 'Close'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Video views (only for video calls)
            if (isVideo && _status == 'active') ...[
              // Remote video (full screen)
              if (_remoteJoined && _remoteUid != null)
                Positioned.fill(
                  child: AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _engine!,
                      canvas: VideoCanvas(uid: _remoteUid!),
                      connection: RtcConnection(channelId: widget.channelName),
                    ),
                  ),
                )
              else
                const Positioned.fill(
                  child: Center(child: Text('Waiting for video...', style: TextStyle(color: AppColors.textSecondary))),
                ),
              // Local video (small PIP)
              Positioned(
                top: 16,
                right: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 120,
                    height: 160,
                    child: _isVideoEnabled
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: _engine!,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          )
                        : Container(
                            color: AppColors.card,
                            child: const Center(child: Icon(Icons.videocam_off, color: AppColors.textSecondary, size: 32)),
                          ),
                  ),
                ),
              ),
            ],

            // Overlay content
            Column(
              children: [
                if (!isVideo || _status != 'active') ...[
                  const Spacer(flex: 2),
                  // Cosmic Avatar with ripple
                  Container(
                    width: 140, height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(colors: [AppColors.saffron, AppColors.cosmicPink]),
                      border: Border.all(color: AppColors.gold.withOpacity(0.5), width: 3),
                      boxShadow: [BoxShadow(color: AppColors.cosmicPink.withOpacity(0.4), blurRadius: 40, spreadRadius: 5)],
                    ),
                    child: Center(child: Text(
                      widget.astrologerName.isNotEmpty ? widget.astrologerName[0].toUpperCase() : 'A',
                      style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w700, color: Colors.white),
                    )),
                  ),
                  const SizedBox(height: 20),
                  Text(widget.astrologerName, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.ivory, fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(isVideo ? 'Video Call' : 'Voice Call', style: const TextStyle(color: AppColors.smoke, fontSize: 14)),
                  const SizedBox(height: 16),
                ] else ...[
                  const Spacer(flex: 1),
                ],

                // Timer & Cost
                if (_status == 'active') ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('\u25cf CONNECTED', style: TextStyle(color: AppColors.success, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 2)),
                      const SizedBox(height: 4),
                      Text(_formattedTime, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w500, fontFamily: 'monospace')),
                      Text('${_money(_currentCost)} \u00b7 ${_money(widget.ratePerMin)}/min',
                          style: const TextStyle(color: AppColors.gold, fontSize: 12)),
                      if (_remainingTime.isNotEmpty)
                        Text(_remainingTime, style: TextStyle(
                          color: _remainingSeconds < 120 ? AppColors.error : AppColors.textSecondary,
                          fontSize: 12, fontWeight: _remainingSeconds < 120 ? FontWeight.bold : FontWeight.normal,
                        )),
                    ]),
                  ),
                  if (widget.eligibleMinutes > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text('Max ${widget.eligibleMinutes} min (${_money((widget.eligibleMinutes * widget.ratePerMin).toDouble())} balance)',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ),
                  // Mid-call low-balance banner → recharge without dropping the call.
                  if (_low)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.error.withOpacity(0.5)),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.account_balance_wallet_outlined, size: 16, color: AppColors.error),
                          const SizedBox(width: 8),
                          const Flexible(child: Text('Low balance — under a minute left',
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _rechargeMidCall,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.gold, foregroundColor: AppColors.midnight,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(0, 32), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                            child: const Text('Add money', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                          ),
                        ]),
                      ),
                    ),
                ] else ...[
                  Text(_status == 'ringing' ? 'Ringing...' : _status,
                      style: const TextStyle(color: AppColors.primary, fontSize: 18)),
                  const SizedBox(height: 8),
                  const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                  if (widget.eligibleMinutes > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text('Balance: ${widget.eligibleMinutes} min available',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ),
                ],

                const Spacer(flex: 3),

                // Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _controlBtn(
                        icon: _isMuted ? Icons.mic_off : Icons.mic,
                        label: _isMuted ? 'Unmute' : 'Mute',
                        color: _isMuted ? AppColors.error.withOpacity(0.3) : AppColors.surface,
                        onTap: _toggleMute,
                      ),
                      if (isVideo)
                        _controlBtn(
                          icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                          label: 'Camera',
                          color: !_isVideoEnabled ? AppColors.error.withOpacity(0.3) : AppColors.surface,
                          onTap: _toggleVideo,
                        ),
                      GestureDetector(
                        onTap: () => _endCall(),
                        child: Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.error,
                            boxShadow: [BoxShadow(color: AppColors.error.withOpacity(0.5), blurRadius: 20, spreadRadius: 2)],
                          ),
                          child: const Icon(Icons.call_end, color: Colors.white, size: 24),
                        ),
                      ),
                      _controlBtn(
                        icon: _isSpeaker ? Icons.volume_up : Icons.volume_down,
                        label: 'Speaker',
                        color: _isSpeaker ? AppColors.primary.withOpacity(0.3) : AppColors.surface,
                        onTap: _toggleSpeaker,
                      ),
                      if (isVideo)
                        _controlBtn(
                          icon: Icons.cameraswitch,
                          label: 'Flip',
                          color: AppColors.surface,
                          onTap: _switchCamera,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlBtn({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.15),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9)),
      ]),
    );
  }
}
