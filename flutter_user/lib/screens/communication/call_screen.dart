import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

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

class _CallScreenState extends State<CallScreen> {
  final _api = ApiService();
  RtcEngine? _engine;
  String _status = 'ringing';
  int _seconds = 0;
  Timer? _timer;
  Timer? _maxTimer;
  bool _isMuted = false;
  bool _isSpeaker = false;
  bool _isVideoEnabled = true;
  bool _remoteJoined = false;
  int? _remoteUid;
  bool _ending = false;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    // Request permissions
    if (widget.callType == 'video') {
      await [Permission.camera, Permission.microphone].request();
    } else {
      await Permission.microphone.request();
    }

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
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        debugPrint('Remote user joined: $remoteUid');
        setState(() {
          _remoteJoined = true;
          _remoteUid = remoteUid;
          _status = 'active';
        });
        _startTimer();
        _startMaxTimer();
      },
      onUserOffline: (connection, remoteUid, reason) {
        debugPrint('Remote user left: $remoteUid reason=$reason');
        setState(() {
          _remoteJoined = false;
          _remoteUid = null;
        });
        // Astrologer disconnected, end call
        _endCall();
      },
      onError: (err, msg) {
        debugPrint('Agora error: $err $msg');
      },
    ));

    // Configure audio/video
    if (widget.callType == 'video') {
      await _engine!.enableVideo();
      await _engine!.startPreview();
    } else {
      await _engine!.disableVideo();
    }
    await _engine!.setDefaultAudioRouteToSpeakerphone(false);

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
              const SnackBar(
                content: Text('⚠️ Less than 1 minute remaining based on your balance'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 5),
              ),
            );
          }
        });
      }
    }
  }

  String get _formattedTime {
    final min = _seconds ~/ 60;
    final sec = _seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  double get _currentCost => (_seconds / 60).ceil() * widget.ratePerMin;

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
    await _engine?.setEnableSpeakerphone(_isSpeaker);
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

  Future<void> _endCall() async {
    if (_ending) return;
    _ending = true;
    _timer?.cancel();
    _maxTimer?.cancel();

    try {
      await _engine?.leaveChannel();
      await _engine?.release();
    } catch (_) {}

    try {
      final action = (_status == 'active' || _remoteJoined) ? 'end' : 'cancel';
      await _api.callAction(widget.callId, action);
    } catch (_) {}

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _maxTimer?.cancel();
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = widget.callType == 'video';

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
                  // Avatar
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.card,
                      border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 3),
                    ),
                    child: const Center(child: Text('\u{1F52E}', style: TextStyle(fontSize: 48))),
                  ),
                  const SizedBox(height: 20),
                  Text(widget.astrologerName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(isVideo ? 'Video Call' : 'Voice Call', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  const SizedBox(height: 16),
                ] else ...[
                  const Spacer(flex: 1),
                ],

                // Timer & Cost
                if (_status == 'active') ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(_formattedTime, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                      Text('\u20b9${_currentCost.toStringAsFixed(0)} • \u20b9${widget.ratePerMin.toInt()}/min',
                          style: const TextStyle(color: AppColors.primary, fontSize: 13)),
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
                      child: Text('Max ${widget.eligibleMinutes} min (₹${(widget.eligibleMinutes * widget.ratePerMin).toInt()} balance)',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
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
                      // End call
                      GestureDetector(
                        onTap: _endCall,
                        child: Container(
                          width: 72, height: 72,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.error),
                          child: const Icon(Icons.call_end, color: Colors.white, size: 32),
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
          width: 52, height: 52,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: Border.all(color: AppColors.border)),
          child: Icon(icon, color: AppColors.textPrimary, size: 22),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
      ]),
    );
  }
}
