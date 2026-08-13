import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../l10n/gen/app_localizations.dart';

/// Shared active call screen used by astrologer after accepting a call.
/// Also usable by user app if needed.
class ActiveCallScreen extends StatefulWidget {
  final String callId;
  final String channelName;
  final String agoraToken;
  final String agoraAppId;
  final String callType;
  final String peerName;
  final double ratePerMin;
  final bool isAstrologer;

  const ActiveCallScreen({
    super.key,
    required this.callId,
    required this.channelName,
    required this.agoraToken,
    required this.agoraAppId,
    required this.callType,
    required this.peerName,
    required this.ratePerMin,
    this.isAstrologer = false,
  });

  @override
  State<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<ActiveCallScreen> with WidgetsBindingObserver {
  final _api = ApiService();
  RtcEngine? _engine;
  int _seconds = 0;
  Timer? _timer;
  Timer? _rtcGraceTimer;
  bool _peerReconnecting = false;
  bool _isMuted = false;
  bool _isSpeaker = false;
  bool _isVideoEnabled = true;
  bool _localVideoOn = false;      // true once the local camera is actually capturing
  bool _camStarting = false;
  bool _remoteJoined = false;
  int? _remoteUid;
  bool _ending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Start timer immediately since call is already accepted
    _startTimer();
    _initAgora();
  }

  Future<void> _initAgora() async {
    // permission_handler is a no-op / unsupported on web; the browser prompts
    // for mic/cam when Agora accesses the devices.
    if (!kIsWeb) {
      if (widget.callType == 'video') {
        await [Permission.camera, Permission.microphone].request();
      } else {
        await Permission.microphone.request();
      }
    }

    try {
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(
        appId: widget.agoraAppId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));

      _engine!.registerEventHandler(RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint('Astro joined channel: ${connection.channelId}');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.callJoinedChannel(connection.channelId ?? '')),
              backgroundColor: AppColors.success, duration: const Duration(seconds: 2),
            ));
          }
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint('Remote user joined: $remoteUid');
          _rtcGraceTimer?.cancel();
          if (_peerReconnecting && mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
          setState(() {
            _remoteJoined = true;
            _remoteUid = remoteUid;
            _peerReconnecting = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.callUserConnected),
              backgroundColor: AppColors.success, duration: const Duration(seconds: 2),
            ));
          }
        },
        onLocalVideoStateChanged: (source, state, reason) {
          // Track whether our camera is really capturing so the web "tap to
          // start camera" fallback can hide once it's on.
          final on = state == LocalVideoStreamState.localVideoStreamStateCapturing ||
              state == LocalVideoStreamState.localVideoStreamStateEncoding;
          if (mounted && on != _localVideoOn) setState(() => _localVideoOn = on);
        },
        onUserOffline: (connection, remoteUid, reason) {
          debugPrint('Remote user left: $remoteUid reason=$reason');
          // Already tearing down (we hit End). leaveChannel() makes Agora report
          // the peer offline — often not as a clean "quit" on web — which would
          // otherwise pop a stray "Reconnecting…" right after our own end.
          if (_ending || !mounted) return;
          // The user intentionally hung up (quit) → end cleanly and say so,
          // instead of showing "Reconnecting…". Only a network drop gets grace.
          if (reason == UserOfflineReasonType.userOfflineQuit) {
            _endCall(endedBy: 'user');
            return;
          }
          setState(() { _remoteJoined = false; _remoteUid = null; _peerReconnecting = true; });
          // Grace window — a blip shouldn't end the call. End only if the peer
          // doesn't rejoin in time.
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Reconnecting…'),
              duration: Duration(seconds: 20), backgroundColor: AppColors.card));
          }
          _rtcGraceTimer?.cancel();
          _rtcGraceTimer = Timer(const Duration(seconds: 20), () {
            if (mounted && _peerReconnecting) _endCall(endedBy: 'user');
          });
        },
        onConnectionStateChanged: (connection, state, reason) {
          debugPrint('Agora connection: state=$state reason=$reason');
          if (mounted && state == ConnectionStateType.connectionStateFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.callConnectionFailed(reason.toString())),
              backgroundColor: AppColors.error, duration: const Duration(seconds: 5),
            ));
          }
        },
        onError: (err, msg) {
          debugPrint('Agora error: $err $msg');
          if (mounted) {
            // On web a permission error means the user blocked mic/cam.
            final isWebPerm = kIsWeb && '$err $msg'.toLowerCase().contains('permission');
            final text = isWebPerm
                ? AppLocalizations.of(context)!.callWebPermissionDenied
                : AppLocalizations.of(context)!.callAgoraError('$err${msg.isNotEmpty ? " — $msg" : ""}');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(text),
              backgroundColor: AppColors.error, duration: const Duration(seconds: 4),
            ));
          }
        },
      ));

      if (widget.callType == 'video') {
        // Try to start the camera. On iOS Safari/PWA this getUserMedia call is
        // NOT inside a user gesture, so it may be blocked (→ no preview). The
        // "Tap to start your camera" overlay (web) lets the astrologer start it
        // from a real tap. On native/Android this just works.
        await _startLocalCamera();
      } else {
        await _engine!.disableVideo();
      }
      // Audio routing is a mobile concept; the call throws on web — skip it so
      // web calls don't fall into the "unsupported" catch after the SDK loads.
      if (!kIsWeb) {
        await _engine!.setDefaultAudioRouteToSpeakerphone(false);
      }

      // Join as UID=2 (astrologer/receiver)
      await _engine!.joinChannel(
        token: widget.agoraToken,
        channelId: widget.channelName,
        uid: 2,
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
      if (mounted) {
        // On web, an init failure usually means the browser doesn't support the
        // Agora Web SDK (or WebRTC is blocked) — show a graceful fallback rather
        // than a raw error, and never block the rest of the app.
        final msg = kIsWeb
            ? AppLocalizations.of(context)!.callBrowserUnsupported
            : AppLocalizations.of(context)!.callAgoraInitFailed(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: AppColors.error, duration: const Duration(seconds: 6),
        ));
      }
    }
  }

  /// Enable video + start the local camera preview. On web this MUST run from a
  /// user gesture (iOS Safari blocks getUserMedia otherwise), so it's also wired
  /// to the "Tap to start your camera" overlay. Safe to call more than once.
  Future<void> _startLocalCamera() async {
    if (_engine == null || _camStarting || _localVideoOn) return;
    _camStarting = true;
    if (mounted) setState(() {});
    try {
      await _engine!.enableVideo();
      await _engine!.startPreview();
      // Make sure the camera track is actually published to the peer.
      await _engine!.muteLocalVideoStream(false);
    } catch (e) {
      debugPrint('startLocalCamera error: $e');
    } finally {
      _camStarting = false;
      if (mounted) setState(() {});
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  String get _formattedTime {
    final min = _seconds ~/ 60;
    final sec = _seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  double get _earning {
    final minutes = (_seconds / 60).ceil();
    final total = minutes * widget.ratePerMin;
    return total * 0.7; // approx earning (70% after commission)
  }

  Future<void> _toggleMute() async {
    setState(() => _isMuted = !_isMuted);
    await _engine?.muteLocalAudioStream(_isMuted);
  }

  Future<void> _toggleSpeaker() async {
    setState(() => _isSpeaker = !_isSpeaker);
    await _engine?.setEnableSpeakerphone(_isSpeaker);
  }

  Future<void> _toggleVideo() async {
    if (widget.callType != 'video') return;
    setState(() => _isVideoEnabled = !_isVideoEnabled);
    await _engine?.muteLocalVideoStream(!_isVideoEnabled);
  }

  Future<void> _switchCamera() async {
    await _engine?.switchCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Only end on a real teardown (detached). 'paused' fires for a
    // notification pull-down / screen lock / app-switch and previously killed
    // the astrologer's live call the instant they glanced away.
    if (state == AppLifecycleState.detached) {
      _endCall();
    }
  }

  Future<void> _endCall({String? endedBy}) async {
    if (_ending) return;
    _ending = true;
    // Stop the reconnect grace + clear any "Reconnecting…" snackbar so it can't
    // linger after the call has ended.
    _timer?.cancel();
    _rtcGraceTimer?.cancel();
    _peerReconnecting = false;
    if (mounted) ScaffoldMessenger.of(context).clearSnackBars();

    try {
      await _engine?.leaveChannel();
      await _engine?.release();
    } catch (_) {}

    try {
      await _api.callAction(widget.callId, 'end');
    } catch (_) {}

    // Tell the astrologer who ended (the user hung up), then return.
    if (endedBy != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Call ended by ${widget.peerName.isNotEmpty ? widget.peerName : endedBy}'),
        backgroundColor: AppColors.card, duration: const Duration(seconds: 3)));
      await Future.delayed(const Duration(milliseconds: 1200));
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _rtcGraceTimer?.cancel();
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isVideo = widget.callType == 'video';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Video views
            if (isVideo) ...[
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
                Positioned.fill(
                  child: Center(child: Text(l.callWaitingForVideo, style: const TextStyle(color: AppColors.textSecondary))),
                ),
              Positioned(
                top: 16, right: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 120, height: 160,
                    child: Stack(fit: StackFit.expand, children: [
                      _isVideoEnabled
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
                      // iOS Safari/PWA blocks the camera unless it starts from a
                      // tap — show a tap-to-start overlay until it's capturing.
                      if (kIsWeb && _isVideoEnabled && !_localVideoOn)
                        GestureDetector(
                          onTap: _startLocalCamera,
                          child: Container(
                            color: Colors.black.withOpacity(0.72),
                            child: Center(
                              child: Column(mainAxisSize: MainAxisSize.min, children: [
                                _camStarting
                                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold))
                                    : const Icon(Icons.videocam, color: AppColors.gold, size: 26),
                                const SizedBox(height: 6),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  child: Text('Tap to start\nyour camera',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w600)),
                                ),
                              ]),
                            ),
                          ),
                        ),
                    ]),
                  ),
                ),
              ),
            ],

            // Overlay
            Column(
              children: [
                if (!isVideo) ...[
                  const Spacer(flex: 2),
                  Container(
                    width: 140, height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(colors: [AppColors.saffron, AppColors.cosmicPink]),
                      border: Border.all(color: AppColors.gold.withOpacity(0.5), width: 3),
                      boxShadow: [BoxShadow(color: AppColors.cosmicPink.withOpacity(0.5), blurRadius: 60)],
                    ),
                    child: Center(child: Text(
                      widget.peerName.isNotEmpty ? widget.peerName[0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w700, color: Colors.white),
                    )),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(widget.peerName, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 4),
                  Text(isVideo ? l.callVideoCall : l.callVoiceCall, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  const SizedBox(height: 16),
                ] else ...[
                  const Spacer(),
                ],

                // Timer & earnings
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.3))),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(_formattedTime, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                    Text(l.callRateEarning('\u20b9${widget.ratePerMin.toInt()}', '\u20b9${_earning.toStringAsFixed(0)}'),
                        style: const TextStyle(color: AppColors.success, fontSize: 13)),
                  ]),
                ),

                const Spacer(flex: 3),

                // Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _controlBtn(icon: _isMuted ? Icons.mic_off : Icons.mic, onTap: _toggleMute),
                      const SizedBox(width: 14),
                      if (isVideo) ...[
                        _controlBtn(icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off, onTap: _toggleVideo),
                        const SizedBox(width: 14),
                      ],
                      GestureDetector(
                        onTap: _endCall,
                        child: Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.error,
                            boxShadow: [BoxShadow(color: AppColors.error.withOpacity(0.5), blurRadius: 20)],
                          ),
                          child: const Icon(Icons.call_end, color: Colors.white, size: 24),
                        ),
                      ),
                      const SizedBox(width: 14),
                      _controlBtn(icon: _isSpeaker ? Icons.volume_up : Icons.volume_down, onTap: _toggleSpeaker),
                      if (isVideo) ...[
                        const SizedBox(width: 14),
                        _controlBtn(icon: Icons.cameraswitch, onTap: _switchCamera),
                      ],
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

  Widget _controlBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.15),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
