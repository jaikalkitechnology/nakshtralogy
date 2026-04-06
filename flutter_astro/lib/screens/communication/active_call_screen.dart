import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

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

class _ActiveCallScreenState extends State<ActiveCallScreen> {
  final _api = ApiService();
  RtcEngine? _engine;
  int _seconds = 0;
  Timer? _timer;
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
    if (widget.callType == 'video') {
      await [Permission.camera, Permission.microphone].request();
    } else {
      await Permission.microphone.request();
    }

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: widget.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _engine!.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        debugPrint('Astro joined channel: ${connection.channelId}');
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        debugPrint('Remote user joined: $remoteUid');
        setState(() {
          _remoteJoined = true;
          _remoteUid = remoteUid;
        });
        _startTimer();
      },
      onUserOffline: (connection, remoteUid, reason) {
        debugPrint('Remote user left: $remoteUid');
        setState(() {
          _remoteJoined = false;
          _remoteUid = null;
        });
        _endCall();
      },
      onError: (err, msg) {
        debugPrint('Agora error: $err $msg');
      },
    ));

    if (widget.callType == 'video') {
      await _engine!.enableVideo();
      await _engine!.startPreview();
    } else {
      await _engine!.disableVideo();
    }
    await _engine!.setDefaultAudioRouteToSpeakerphone(false);

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

  Future<void> _endCall() async {
    if (_ending) return;
    _ending = true;
    _timer?.cancel();

    try {
      await _engine?.leaveChannel();
      await _engine?.release();
    } catch (_) {}

    try {
      await _api.callAction(widget.callId, 'end');
    } catch (_) {}

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
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
                const Positioned.fill(
                  child: Center(child: Text('Waiting for video...', style: TextStyle(color: AppColors.textSecondary))),
                ),
              Positioned(
                top: 16, right: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 120, height: 160,
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

            // Overlay
            Column(
              children: [
                if (!isVideo) ...[
                  const Spacer(flex: 2),
                  Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.card,
                      border: Border.all(color: AppColors.success.withOpacity(0.5), width: 3),
                    ),
                    child: const Center(child: Text('\u{1F9D1}', style: TextStyle(fontSize: 48))),
                  ),
                  const SizedBox(height: 20),
                  Text(widget.peerName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(isVideo ? 'Video Call' : 'Voice Call', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  const SizedBox(height: 16),
                ] else ...[
                  const Spacer(),
                ],

                // Timer & earnings
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(_formattedTime, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                    Text('\u20b9${widget.ratePerMin.toInt()}/min • Earning: \u20b9${_earning.toStringAsFixed(0)}',
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
                      _controlBtn(icon: _isMuted ? Icons.mic_off : Icons.mic, label: _isMuted ? 'Unmute' : 'Mute',
                          color: _isMuted ? AppColors.error.withOpacity(0.3) : AppColors.surface, onTap: _toggleMute),
                      if (isVideo)
                        _controlBtn(icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off, label: 'Camera',
                            color: !_isVideoEnabled ? AppColors.error.withOpacity(0.3) : AppColors.surface, onTap: _toggleVideo),
                      GestureDetector(
                        onTap: _endCall,
                        child: Container(
                          width: 72, height: 72,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.error),
                          child: const Icon(Icons.call_end, color: Colors.white, size: 32),
                        ),
                      ),
                      _controlBtn(icon: _isSpeaker ? Icons.volume_up : Icons.volume_down, label: 'Speaker',
                          color: _isSpeaker ? AppColors.primary.withOpacity(0.3) : AppColors.surface, onTap: _toggleSpeaker),
                      if (isVideo)
                        _controlBtn(icon: Icons.cameraswitch, label: 'Flip', color: AppColors.surface, onTap: _switchCamera),
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
