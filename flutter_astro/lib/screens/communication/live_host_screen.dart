import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class LiveHostScreen extends StatefulWidget {
  final String streamId;
  final String channelName;
  final String agoraToken;
  final String agoraAppId;
  final String title;

  const LiveHostScreen({
    super.key,
    required this.streamId,
    required this.channelName,
    required this.agoraToken,
    required this.agoraAppId,
    required this.title,
  });

  @override
  State<LiveHostScreen> createState() => _LiveHostScreenState();
}

class _LiveHostScreenState extends State<LiveHostScreen> with WidgetsBindingObserver {
  final _api = ApiService();
  RtcEngine? _engine;
  List<dynamic> _questions = [];
  List<dynamic> _superChats = [];
  int _viewerCount = 0;
  int _peakViewers = 0;
  double _totalGifts = 0;
  bool _isLive = false;
  bool _isMuted = false;
  Timer? _pollTimer;
  int _seconds = 0;
  Timer? _durationTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initAgora();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached && _isLive) {
      _endStream();
    }
  }

  Future<void> _initAgora() async {
    // permission_handler is unsupported on web; the browser prompts for
    // mic/cam access when Agora accesses the devices.
    if (!kIsWeb) {
      await [Permission.camera, Permission.microphone].request();
    }

    try {
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(
        appId: widget.agoraAppId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));

      _engine!.registerEventHandler(RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) => debugPrint('Host joined channel'),
        onError: (err, msg) => debugPrint('Agora error: $err $msg'),
      ));

      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await _engine!.enableVideo();
      await _engine!.startPreview();
    } catch (e) {
      // Graceful fallback (e.g. unsupported browser) — don't crash the screen.
      debugPrint('Agora live init error: $e');
      if (mounted && kIsWeb) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.callBrowserUnsupported),
          backgroundColor: AppColors.error, duration: const Duration(seconds: 6),
        ));
      }
    }
  }

  Future<void> _goLive() async {
    await _engine!.joinChannel(
      token: widget.agoraToken,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        publishMicrophoneTrack: true,
        publishCameraTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );

    final resp = await _api.startLiveStream(widget.streamId);
    if (resp['statusCode'] == 200) {
      setState(() => _isLive = true);
      _startPolling();
      _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _seconds++));
    }
  }

  Future<void> _endStream() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('End Stream?', style: TextStyle(color: AppColors.primary)),
        content: const Text('This will disconnect all viewers.', style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), style: ElevatedButton.styleFrom(backgroundColor: AppColors.error), child: const Text('End')),
        ],
      ),
    );
    if (confirm != true) return;
    _pollTimer?.cancel();
    _durationTimer?.cancel();
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
    await _api.endLiveStream(widget.streamId);
    if (mounted) Navigator.pop(context);
  }

  List<dynamic> _giftAnimations = [];

  void _startPolling() {
    // Initial load
    _poll();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _poll());
  }

  Future<void> _poll() async {
    if (!_isLive || !mounted) return;
    final v = await _api.getLiveViewers(widget.streamId);
    final q = await _api.getLiveQuestions(widget.streamId);
    final sc = await _api.getLiveSuperChats(widget.streamId);
    if (!mounted) return;

    // Detect new gifts in super chats
    final oldCount = _superChats.length;
    setState(() {
      _viewerCount = v['total'] ?? 0;
      _peakViewers = v['peak'] ?? _peakViewers;
      _questions = q;
      _superChats = sc;
      // Update total gifts from super chats
      double total = 0;
      for (final c in sc) {
        total += (c['amount'] as num?)?.toDouble() ?? 0;
      }
      _totalGifts = total;
    });

    // Show animation for new super chats
    if (sc.length > oldCount && sc.isNotEmpty) {
      final latest = sc.first;
      setState(() => _giftAnimations.add(latest));
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() { if (_giftAnimations.isNotEmpty) _giftAnimations.removeAt(0); });
      });
    }
  }

  String get _formattedDuration {
    final m = (_seconds % 3600) ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollTimer?.cancel();
    _durationTimer?.cancel();
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(children: [
          // Camera preview
          if (_engine != null)
            Positioned.fill(
              child: AgoraVideoView(controller: VideoViewController(rtcEngine: _engine!, canvas: const VideoCanvas(uid: 0))),
            ),

          // Pre-live overlay
          if (!_isLive)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('\u{1F52E}', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text('Preview your camera before going live', style: TextStyle(color: Colors.white60, fontSize: 14)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _goLive,
                    icon: const Icon(Icons.videocam),
                    label: Text(AppLocalizations.of(context)?.goLive ?? 'Go Live'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, minimumSize: const Size(180, 52)),
                  ),
                ]),
              ),
            ),

          // Top bar
          if (_isLive)
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.black87, Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(6)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.circle, color: Colors.white, size: 8),
                      const SizedBox(width: 4),
                      Text('LIVE $_formattedDuration', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.people, color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Text('$_viewerCount', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  if (_totalGifts > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.3), borderRadius: BorderRadius.circular(6)),
                      child: Text('\u20b9${_totalGifts.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text('Peak: $_peakViewers', style: const TextStyle(color: Colors.white60, fontSize: 11)),
                ]),
              ),
            ),

          // Pinned super chats
          if (_isLive && _superChats.isNotEmpty)
            Positioned(
              top: 48, left: 8, right: 8,
              child: SizedBox(
                height: 56,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _superChats.length > 5 ? 5 : _superChats.length,
                  itemBuilder: (_, i) {
                    final sc = _superChats[i];
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(maxWidth: 200),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.85), AppColors.accent.withOpacity(0.7)]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                        Row(children: [
                          Text(sc['sender_name'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text('\u20b9${(sc['amount'] as num?)?.toStringAsFixed(0) ?? '0'}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                        ]),
                        Text(sc['message'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ]),
                    );
                  },
                ),
              ),
            ),

          // Gift received animation (right side)
          if (_isLive && _giftAnimations.isNotEmpty)
            Positioned(
              right: 16, top: 120,
              child: Column(children: _giftAnimations.map((g) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.85), borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('\u20b9', style: TextStyle(fontSize: 16, color: Colors.white)),
                  const SizedBox(width: 4),
                  Text('${g['sender_name'] ?? 'User'} • \u20b9${(g['amount'] as num?)?.toStringAsFixed(0) ?? '0'}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ]),
              )).toList()),
            ),

          // Questions chat overlay
          if (_isLive)
            Positioned(
              bottom: 80, left: 8, right: 80,
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  reverse: true,
                  itemCount: _questions.length,
                  itemBuilder: (_, i) {
                    final q = _questions[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(16)),
                        child: RichText(text: TextSpan(children: [
                          TextSpan(text: '${q['display_name'] ?? 'User'} ', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                          TextSpan(text: q['question'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ])),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Bottom controls
          if (_isLive)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.black87], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  _ctrl(Icons.flip_camera_ios, 'Flip', () => _engine?.switchCamera()),
                  _ctrl(_isMuted ? Icons.mic_off : Icons.mic, _isMuted ? 'Unmute' : 'Mute', () {
                    setState(() => _isMuted = !_isMuted);
                    _engine?.muteLocalAudioStream(_isMuted);
                  }),
                  GestureDetector(
                    onTap: _endStream,
                    child: Container(width: 56, height: 56, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.error), child: const Icon(Icons.stop, color: Colors.white, size: 28)),
                  ),
                ]),
              ),
            ),

          // Close (pre-live)
          if (!_isLive)
            Positioned(top: 8, right: 8, child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white, size: 28))),
        ]),
      ),
    );
  }

  Widget _ctrl(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white12, border: Border.all(color: Colors.white24)), child: Icon(icon, color: Colors.white, size: 20)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
      ]),
    );
  }
}
