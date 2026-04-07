import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

/// Single live stream viewer — full screen, chat overlay, gifts, super chat.
class LiveViewerScreen extends StatefulWidget {
  final String streamId;
  final String title;
  final String hostName;
  final String? hostAvatar;
  final double superChatRate;

  const LiveViewerScreen({
    super.key,
    required this.streamId,
    required this.title,
    required this.hostName,
    this.hostAvatar,
    this.superChatRate = 50,
  });

  @override
  State<LiveViewerScreen> createState() => _LiveViewerScreenState();
}

class _LiveViewerScreenState extends State<LiveViewerScreen> {
  final _api = ApiService();
  final _questionCtrl = TextEditingController();
  RtcEngine? _engine;
  String? _agoraToken;
  String? _agoraAppId;
  String? _channelName;
  int _agoraUid = 0;
  List<dynamic> _questions = [];
  List<dynamic> _superChats = [];
  List<dynamic> _gifts = [];
  List<dynamic> _recentGiftAnimations = []; // for gift overlay
  int _viewerCount = 0;
  bool _joined = false;
  int? _remoteUid;
  Timer? _pollTimer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _joinStream();
    _loadGifts();
  }

  Future<void> _joinStream() async {
    final resp = await _api.joinLiveStream(widget.streamId);
    if (resp['statusCode'] != 200) {
      if (mounted) setState(() => _error = resp['detail'] ?? 'Failed to join stream');
      return;
    }

    _agoraToken = resp['agora_token'];
    _agoraAppId = resp['agora_app_id'];
    _channelName = resp['channel_name'];
    _agoraUid = resp['agora_uid'] ?? 0;

    // Mark as joined immediately so chat/gifts are visible
    setState(() => _joined = true);
    _startPolling();

    // Try Agora connection (may fail with dev tokens — that's OK, chat still works)
    try {
      await _initAgora();
    } catch (e) {
      debugPrint('Agora init failed (chat still works): $e');
    }
  }

  Future<void> _initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: _agoraAppId!,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine!.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        debugPrint('Viewer joined channel: ${connection.channelId}');
        setState(() => _joined = true);
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        debugPrint('Host video available: $remoteUid');
        setState(() => _remoteUid = remoteUid);
      },
      onUserOffline: (connection, remoteUid, reason) {
        debugPrint('Host left: $remoteUid');
        setState(() => _remoteUid = null);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stream ended')));
          _leaveStream();
        }
      },
      onError: (err, msg) => debugPrint('Agora error: $err $msg'),
    ));

    // Audience role — subscribe to remote audio+video, don't publish local
    await _engine!.setClientRole(role: ClientRoleType.clientRoleAudience);
    await _engine!.enableVideo(); // MUST enable video to receive remote video
    await _engine!.enableAudio();

    // Join channel with the UID assigned by backend
    await _engine!.joinChannel(
      token: _agoraToken!,
      channelId: _channelName!,
      uid: _agoraUid,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishMicrophoneTrack: false, // don't publish local audio
        publishCameraTrack: false,     // don't publish local video
        clientRoleType: ClientRoleType.clientRoleAudience,
      ),
    );
  }

  Future<void> _loadGifts() async {
    final gifts = await _api.getGifts();
    if (mounted) setState(() => _gifts = gifts);
  }

  void _startPolling() {
    // Initial load
    _poll();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _poll());
  }

  Future<void> _poll() async {
    if (!mounted) return;
    final v = await _api.getLiveViewers(widget.streamId);
    final q = await _api.getLiveQuestions(widget.streamId);
    final sc = await _api.getLiveSuperChats(widget.streamId);
    if (!mounted) return;
    setState(() {
      _viewerCount = v['total'] ?? 0;
      _questions = q;
      _superChats = sc;
    });
  }

  Future<void> _sendQuestion() async {
    if (_questionCtrl.text.trim().isEmpty) return;
    await _api.sendLiveQuestion(widget.streamId, _questionCtrl.text.trim());
    _questionCtrl.clear();
    _poll(); // refresh immediately
  }

  Future<void> _sendGift(Map<String, dynamic> gift) async {
    final resp = await _api.sendLiveGift(widget.streamId, gift['id']);
    if (mounted) {
      if (resp['statusCode'] == 200) {
        // Show gift animation overlay
        setState(() => _recentGiftAnimations.add({'icon': gift['icon'], 'name': gift['name'], 'sender': 'You'}));
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() { if (_recentGiftAnimations.isNotEmpty) _recentGiftAnimations.removeAt(0); });
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${gift['icon']} ${gift['name']} sent!'), backgroundColor: AppColors.success, duration: const Duration(seconds: 1)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['detail'] ?? 'Failed to send gift'), backgroundColor: AppColors.error));
      }
    }
  }

  void _showSuperChatDialog() {
    final minRate = widget.superChatRate;
    final msgCtrl = TextEditingController();
    final amountCtrl = TextEditingController(text: '${minRate.toInt()}');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Super Chat', style: TextStyle(color: AppColors.primary)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Send a paid pinned message (min \u20b9${minRate.toInt()})', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 12),
          TextField(controller: msgCtrl, maxLength: 300, decoration: const InputDecoration(labelText: 'Message', prefixIcon: Icon(Icons.message))),
          const SizedBox(height: 10),
          TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Amount (min \u20b9${minRate.toInt()})', prefixIcon: const Icon(Icons.currency_rupee))),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: (() {
            final amounts = <int>{minRate.toInt(), 100, 200, 500}.where((a) => a >= minRate).toList()..sort();
            return amounts.take(4).map<Widget>((a) => ActionChip(
              label: Text('\u20b9$a'),
              onPressed: () => amountCtrl.text = '$a',
              backgroundColor: AppColors.surface,
              labelStyle: const TextStyle(color: AppColors.primary),
            )).toList();
          })()),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountCtrl.text.trim());
              final message = msgCtrl.text.trim();
              if (amount == null || amount < minRate || message.isEmpty) {
                if (amount != null && amount < minRate) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Minimum amount is \u20b9${minRate.toInt()}'), backgroundColor: AppColors.error));
                }
                return;
              }
              Navigator.pop(ctx);
              final resp = await _api.sendSuperChat(widget.streamId, message, amount);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(resp['statusCode'] == 200 ? 'Super Chat sent!' : resp['detail'] ?? 'Failed'),
                  backgroundColor: resp['statusCode'] == 200 ? AppColors.success : AppColors.error,
                ));
                if (resp['statusCode'] == 200) _poll();
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showGiftSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('Send a Gift', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text('${_gifts.length} gifts', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ]),
          const SizedBox(height: 16),
          if (_gifts.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No gifts available', style: TextStyle(color: AppColors.textSecondary))))
          else
            Wrap(spacing: 12, runSpacing: 12, children: _gifts.map((g) {
              return GestureDetector(
                onTap: () { Navigator.pop(ctx); _sendGift(g); },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Center(child: Text(g['icon'] ?? '', style: const TextStyle(fontSize: 28))),
                  ),
                  const SizedBox(height: 4),
                  Text(g['name'] ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                  Text('\u20b9${(g['price'] as num).toInt()}', style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600)),
                ]),
              );
            }).toList()),
          const SizedBox(height: 12),
        ]),
      ),
    );
  }

  Future<void> _leaveStream() async {
    _pollTimer?.cancel();
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
    await _api.leaveLiveStream(widget.streamId);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _questionCtrl.dispose();
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Error state
    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Go Back')),
        ])),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        // Remote video (astrologer's stream) full screen
        if (_remoteUid != null && _engine != null)
          Positioned.fill(
            child: AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _engine!,
                canvas: VideoCanvas(uid: _remoteUid!),
                connection: RtcConnection(channelId: _channelName!),
              ),
            ),
          )
        else
          Positioned.fill(
            child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (!_joined) ...[
                const CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: 12),
                const Text('Connecting to stream...', style: TextStyle(color: Colors.white60, fontSize: 14)),
              ] else ...[
                const Text('\u{1F52E}', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                const Text('Waiting for host video...', style: TextStyle(color: Colors.white60, fontSize: 14)),
              ],
            ])),
          ),

        // Gift animation overlay (right side)
        if (_recentGiftAnimations.isNotEmpty)
          Positioned(
            right: 16, top: MediaQuery.of(context).padding.top + 100,
            child: Column(children: _recentGiftAnimations.map((g) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.8), borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(g['icon'] ?? '', style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 6),
                Text('${g['sender']} sent ${g['name']}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ]),
            )).toList()),
          ),

        // Top bar
        Positioned(
          top: 0, left: 0, right: 0,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.card,
                  backgroundImage: widget.hostAvatar != null ? NetworkImage(widget.hostAvatar!) : null,
                  child: widget.hostAvatar == null ? const Text('\u{1F52E}', style: TextStyle(fontSize: 16)) : null,
                ),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text(widget.hostName, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(widget.title, style: const TextStyle(color: Colors.white60, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(6)),
                  child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.people, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text('$_viewerCount', style: const TextStyle(color: Colors.white, fontSize: 13)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _leaveStream,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.white12, shape: BoxShape.circle),
                    child: const Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
              ]),
            ),
          ),
        ),

        // Pinned super chats
        if (_superChats.isNotEmpty)
          Positioned(
            top: MediaQuery.of(context).padding.top + 50, left: 8, right: 8,
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

        // Chat messages overlay (bottom-left)
        Positioned(
          bottom: 70, left: 8, right: 80,
          child: SizedBox(
            height: 220,
            child: _questions.isEmpty
                ? const SizedBox()
                : ListView.builder(
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

        // Bottom input bar
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.black54], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _questionCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Say something...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true, fillColor: Colors.white12,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                    ),
                    onSubmitted: (_) => _sendQuestion(),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _sendQuestion,
                  child: Container(width: 38, height: 38, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary), child: const Icon(Icons.send, color: Colors.black, size: 18)),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _showGiftSheet,
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white12, border: Border.all(color: Colors.white24)),
                    child: const Icon(Icons.card_giftcard, color: AppColors.accent, size: 18),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _showSuperChatDialog,
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withOpacity(0.2), border: Border.all(color: AppColors.primary.withOpacity(0.5))),
                    child: const Icon(Icons.attach_money, color: AppColors.primary, size: 18),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}


/// Reels-style vertical scroll through all active live streams.
class LiveReelsScreen extends StatefulWidget {
  const LiveReelsScreen({super.key});
  @override
  State<LiveReelsScreen> createState() => _LiveReelsScreenState();
}

class _LiveReelsScreenState extends State<LiveReelsScreen> {
  final _api = ApiService();
  List<dynamic> _streams = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStreams();
  }

  Future<void> _loadStreams() async {
    final streams = await _api.getActiveLiveStreams();
    setState(() { _streams = streams; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }
    if (_streams.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Live Streams')),
        body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.live_tv, size: 56, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          const Text('No live streams right now', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: _loadStreams, child: const Text('Refresh')),
        ])),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _streams.length,
        itemBuilder: (_, i) {
          final s = _streams[i];
          return LiveViewerScreen(
            streamId: s['id'],
            title: s['title'] ?? '',
            hostName: s['host_name'] ?? 'Astrologer',
            hostAvatar: s['host_profile_image'] ?? s['host_avatar'],
            superChatRate: (s['super_chat_rate'] as num?)?.toDouble() ?? 50,
          );
        },
      ),
    );
  }
}
