import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/gen/app_localizations.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../services/api_service.dart';
import '../../widgets/session_review_dialog.dart';

class ChatScreen extends StatefulWidget {
  final String sessionId;
  final String astrologerName;
  final double ratePerMin;
  final double ratePerSession;
  final String billingMode;
  final int sessionMessageLimit;

  const ChatScreen({
    super.key,
    required this.sessionId,
    required this.astrologerName,
    this.ratePerMin = 0,
    this.ratePerSession = 0,
    this.billingMode = 'per_session',
    this.sessionMessageLimit = 45,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _api = ApiService();
  final List<Map<String, dynamic>> _messages = [];
  WebSocketChannel? _channel;
  String? _myUserId;
  int _seconds = 0;
  Timer? _timer;
  Timer? _pollTimer;
  bool _connected = false;
  int _userMessageCount = 0;
  int _remainingMessages = 0;
  bool _uploading = false;
  // Connecting screen: wait up to 60s for the astrologer to accept.
  bool _ended = false;              // guards a single end/cancel (no double refund)
  Timer? _connectTimer;
  int _connectRemaining = 60;
  // Auto-heal: once a chat has been active we keep the socket alive with pings
  // and reconnect it (with backoff) on a drop, instead of dying on the initial
  // "Connecting…" screen while the server session keeps billing.
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  bool _wasActive = false;          // ever reached "active" — controls reconnect + end-vs-cancel
  bool _reconnecting = false;
  int _reconnectAttempts = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _remainingMessages = widget.sessionMessageLimit;
    _connect();
    _startConnectCountdown();
  }

  void _startConnectCountdown() {
    _connectTimer?.cancel();
    _connectRemaining = 60;
    _connectTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_connected) { t.cancel(); return; }
      if (!mounted) { t.cancel(); return; }
      setState(() => _connectRemaining--);
      if (_connectRemaining <= 0) {
        t.cancel();
        _cancelAndLeave(reason: 'No answer — request cancelled, amount refunded');
      }
    });
  }

  void _onConnected() {
    _connectTimer?.cancel();
    _reconnectTimer?.cancel();
    _wasActive = true;
    _reconnectAttempts = 0;
    if (!_connected || _reconnecting) {
      setState(() { _connected = true; _reconnecting = false; });
    }
    _startTimer();
    _startPing();
    _pollTimer?.cancel();
    // Pull any messages that were broadcast while our socket was down (initial
    // connect window or a reconnect). Without this, messages sent during that
    // gap never appear in the live view — only later in history.
    _syncHistory();
  }

  /// Fetch persisted messages and merge any we don't already show (dedup by id).
  Future<void> _syncHistory() async {
    try {
      final history = await _api.getChatMessages(widget.sessionId, limit: 200);
      if (!mounted || history.isEmpty) return;
      final seen = _messages.map((m) => m['id']?.toString()).toSet();
      final fresh = <Map<String, dynamic>>[];
      for (final h in history) {
        final m = Map<String, dynamic>.from(h as Map);
        m['timestamp'] ??= m['created_at'];        // history uses created_at
        m['is_astrologer'] ??= (m['sender_id'] != _myUserId);
        if (!seen.contains(m['id']?.toString())) fresh.add(m);
      }
      if (fresh.isEmpty) return;
      setState(() {
        final all = <Map<String, dynamic>>[...fresh, ..._messages];
        all.sort((a, b) => (a['timestamp']?.toString() ?? '')
            .compareTo(b['timestamp']?.toString() ?? ''));
        _messages
          ..clear()
          ..addAll(all);
      });
      _scrollToBottom();
    } catch (_) {/* best-effort */}
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      try { _channel?.sink.add(jsonEncode({'type': 'ping'})); } catch (_) {}
    });
  }

  /// Socket closed/errored. If the chat was active and we didn't end it, keep
  /// the session and reconnect with backoff rather than dropping to a dead
  /// "Connecting…" screen (the server session is still live and billing).
  void _onSocketClosed() {
    _pingTimer?.cancel();
    if (_ended || !mounted) return;
    if (_wasActive) {
      setState(() { _connected = false; _reconnecting = true; });
      _scheduleReconnect();
    } else {
      setState(() => _connected = false);
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    const backoff = [2, 4, 8, 16, 30];
    final delay = backoff[_reconnectAttempts.clamp(0, backoff.length - 1)];
    _reconnectAttempts++;
    _reconnectTimer = Timer(Duration(seconds: delay), () {
      if (_ended || !mounted) return;
      _connect();
    });
  }

  /// Cancel a still-connecting request exactly once and leave (single refund).
  void _cancelAndLeave({required String reason}) {
    _sendEndSession(); // guarded — fires cancel at most once
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(reason), backgroundColor: AppColors.nebula));
      Navigator.pop(context);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _sendEndSession();
    }
  }

  void _sendEndSession() {
    // Fire once only — dispose() runs after an explicit end/back, so without
    // this guard a cancel would be sent twice and the block refunded twice.
    if (_ended) return;
    _ended = true;
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    // Use _wasActive (not the momentary _connected) so a session that is active
    // but mid-reconnect ends via end_session — NOT a refund-cancel of an
    // already-charged session.
    if (!_wasActive) {
      // Still in "waiting" state — cancel via REST API to get the (single) refund
      _api.chatAction(widget.sessionId, 'cancel').catchError((_) {});
    } else {
      try {
        _channel?.sink.add(jsonEncode({'type': 'end_session'}));
      } catch (_) {}
    }
  }

  Future<void> _connect() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final userData = prefs.getString('user_data');
    if (userData != null) {
      _myUserId = jsonDecode(userData)['id'];
    }

    try { _channel?.sink.close(); } catch (_) {}
    final uri = Uri.parse('${ApiConstants.wsChat}/${widget.sessionId}?token=$token');
    _channel = WebSocketChannel.connect(uri);

    _channel!.stream.listen(
      (raw) {
        final data = jsonDecode(raw as String);
        switch (data['type']) {
          case 'message':
            setState(() {
              _messages.add(data);
              _userMessageCount = data['user_message_count'] ?? _userMessageCount;
              _remainingMessages = data['remaining_messages'] ?? _remainingMessages;
            });
            _scrollToBottom();
            break;
          case 'session_info':
            final isActive = data['status'] == 'active';
            setState(() {
              _connected = isActive;
              _userMessageCount = data['user_message_count'] ?? 0;
              _remainingMessages = (data['session_message_limit'] ?? widget.sessionMessageLimit) - _userMessageCount;
            });
            if (isActive) {
              _onConnected();
            } else {
              // Session is still "waiting" — poll backend to detect acceptance
              _startPollingForAcceptance();
            }
            break;
          case 'session_accepted':
            // Backend pushed acceptance notification through WS
            _onConnected();
            break;
          case 'session_ended':
            _timer?.cancel();
            _pollTimer?.cancel();
            if (mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppColors.card,
                  title: const Text('Session Ended', style: TextStyle(color: AppColors.primary)),
                  content: Text(data['reason'] ?? 'Chat session has ended', style: const TextStyle(color: AppColors.textPrimary)),
                  actions: [
                    ElevatedButton(onPressed: () { Navigator.pop(ctx); _reviewThenPop(); }, child: Text(AppLocalizations.of(context)?.ok ?? 'OK')),
                  ],
                ),
              );
            }
            break;
          case 'typing':
            // Could show typing indicator
            break;
          case 'ping':
            try { _channel?.sink.add(jsonEncode({'type': 'pong'})); } catch (_) {}
            break;
          case 'pong':
            break;
          case 'billing_tick':
            // Server-authoritative cost — replaces the local timer estimate.
            final billed = (data['billed_so_far'] as num?)?.toDouble();
            if (billed != null) setState(() => _serverBilled = billed);
            break;
          case 'session_taken_over':
            _ended = true; // don't fire cancel/end for a takeover
            _pingTimer?.cancel();
            _reconnectTimer?.cancel();
            _timer?.cancel();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(data['message'] ?? 'Chat opened on another device'),
                backgroundColor: AppColors.nebula));
              Navigator.pop(context);
            }
            break;
        }
      },
      onDone: _onSocketClosed,
      onError: (_) => _onSocketClosed(),
    );
  }

  void _startPollingForAcceptance() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      try {
        final resp = await _api.getChatSession(widget.sessionId);
        final status = resp['status'] ?? '';
        if (status == 'active') {
          _pollTimer?.cancel();
          // The socket that connected during "waiting" is already registered on
          // the server and receives all broadcasts once the session is active —
          // so just mark connected. (Previously we closed + reconnected here,
          // which raced the server's one-socket-per-user takeover and dropped
          // messages in BOTH directions.)
          _onConnected();
        } else if (status == 'expired' || status == 'cancelled') {
          _pollTimer?.cancel();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Chat request $status'), backgroundColor: AppColors.error));
            Navigator.pop(context);
          }
        }
      } catch (_) {}
    });
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

  double _serverBilled = -1;   // from server billing_tick; <0 = not yet received

  double get _currentCost {
    if (_serverBilled >= 0) return _serverBilled;
    if (widget.billingMode == 'per_session') return widget.ratePerSession;
    return (_seconds / 60).ceil() * widget.ratePerMin;
  }

  void _sendMessage() {
    if (_msgCtrl.text.trim().isEmpty || _channel == null) return;
    _channel!.sink.add(jsonEncode({
      'type': 'message',
      'content': _msgCtrl.text.trim(),
      'message_type': 'text',
    }));
    _msgCtrl.clear();
  }

  Future<void> _reportMessage(int index) async {
    if (index < 0 || index >= _messages.length) return;
    final id = _messages[index]['id']?.toString();
    if (id == null || id.isEmpty) return;
    setState(() => _messages[index]['reported'] = true); // optimistic
    try {
      await _api.reportChatMessage(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Reported. Never pay an astrologer outside the app."),
          backgroundColor: AppColors.nebula,
        ));
      }
    } catch (_) {
      if (mounted) setState(() => _messages[index]['reported'] = false);
    }
  }

  void _sendFileMessage(String mediaUrl, String fileName, int fileSize, String fileType) {
    _channel?.sink.add(jsonEncode({
      'type': 'message',
      'content': fileType == 'pdf' ? '📄 $fileName' : '📷 Photo',
      'message_type': fileType,
      'media_url': mediaUrl,
      'file_name': fileName,
      'file_size': fileSize,
    }));
  }

  Future<void> _pickAndUploadFile(String type) async {
    // Real byte-based picker (file_picker withData) — works on web and mobile.
    Uint8List? bytes;
    String? fileName;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: type == 'image'
            ? const ['jpg', 'jpeg', 'png', 'webp', 'gif']
            : const ['pdf'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      bytes = result.files.first.bytes;
      fileName = result.files.first.name;
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Picker error: $e')));
      return;
    }
    if (bytes == null || fileName == null) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.fileNotFound ?? 'Could not read the selected file')));
      return;
    }

    setState(() => _uploading = true);
    try {
      final resp = await _api.uploadChatFile(bytes, fileName);
      if (resp['statusCode'] == 200) {
        _sendFileMessage(resp['media_url'] ?? '', resp['file_name'] ?? 'file', resp['file_size'] ?? 0, resp['file_type'] ?? 'pdf');
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['detail'] ?? 'Upload failed')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload error: $e')));
    } finally {
      setState(() => _uploading = false);
    }
  }

  void _endSession() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('End Chat?', style: TextStyle(color: AppColors.primary)),
        content: const Text('Are you sure you want to end this chat session?', style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _sendEndSession();
              _reviewThenPop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(AppLocalizations.of(context)?.endChat ?? 'End Chat'),
          ),
        ],
      ),
    );
  }

  /// After a chat ends, prompt for a rating + review (skippable) then leave the
  /// screen. Guards against reviewing twice in one exit.
  bool _reviewPrompted = false;
  Future<void> _reviewThenPop() async {
    if (!mounted) return;
    if (!_reviewPrompted) {
      _reviewPrompted = true;
      await showSessionReviewDialog(
        context,
        sessionType: 'chat',
        sessionId: widget.sessionId,
        astrologerName: widget.astrologerName,
      );
    }
    if (mounted) Navigator.pop(context);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sendEndSession();
    _timer?.cancel();
    _pollTimer?.cancel();
    _connectTimer?.cancel();
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  /// Full-screen "connecting" view shown until the astrologer accepts (max 60s).
  Widget _connectingView() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 96, height: 96,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [AppColors.indigo, AppColors.lavender]),
                ),
                child: Center(
                  child: Text(
                    widget.astrologerName.isNotEmpty ? widget.astrologerName[0].toUpperCase() : '?',
                    style: const TextStyle(color: AppColors.ivory, fontSize: 40, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(widget.astrologerName,
                  style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(_reconnecting ? 'Reconnecting…' : 'Connecting…',
                  style: const TextStyle(color: AppColors.smoke, fontSize: 14)),
              const SizedBox(height: 20),
              const SizedBox(width: 26, height: 26, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.gold)),
              const SizedBox(height: 20),
              Text(_reconnecting
                      ? 'Connection lost — restoring your chat…'
                      : 'Waiting for the astrologer to accept · ${_connectRemaining}s',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
              if (!_reconnecting) ...[
                const SizedBox(height: 6),
                const Text('If not accepted, your amount is refunded automatically.',
                    textAlign: TextAlign.center, style: TextStyle(color: AppColors.smoke, fontSize: 11)),
              ],
              const Spacer(),
              // While reconnecting an ACTIVE session, don't offer a refund-cancel
              // (the session is already charged). Only offer cancel pre-accept.
              if (!_reconnecting)
                SizedBox(
                  width: double.infinity, height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => _cancelAndLeave(reason: 'Request cancelled — amount refunded'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    icon: const Icon(Icons.close),
                    label: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show the connecting screen until the astrologer accepts (both connected).
    if (!_connected) return _connectingView();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.midnight,
            border: Border(bottom: BorderSide(color: AppColors.twilight, width: 1)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.ivory),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Astrologer avatar gradient circle
                  Container(
                    width: 40, height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.indigo, AppColors.lavender],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.astrologerName.isNotEmpty ? widget.astrologerName[0].toUpperCase() : '?',
                        style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Astrologer name + status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.astrologerName, style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w600)),
                        Text(
                          _connected ? 'Online' : 'Connecting...',
                          style: TextStyle(color: _connected ? AppColors.success : AppColors.smoke, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  // Timer badge (gold border, mono font)
                  if (_connected)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gold, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formattedTime,
                        style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'monospace'),
                      ),
                    ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.call_end, color: AppColors.error, size: 22),
                    onPressed: _endSession,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Session info strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.indigo.withOpacity(0.2),
              border: const Border(bottom: BorderSide(color: AppColors.twilight, width: 0.5)),
            ),
            child: Row(children: [
              const Icon(Icons.auto_awesome, size: 14, color: AppColors.lavender),
              const SizedBox(width: 6),
              Expanded(child: Text(
                widget.billingMode == 'per_session'
                    ? 'Session: $_userMessageCount/${widget.sessionMessageLimit} msgs ($_remainingMessages left)'
                    : 'Duration: $_formattedTime',
                style: const TextStyle(color: AppColors.lavender, fontSize: 12),
              )),
              // Rate badge (gold-saffron gradient)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.billingMode == 'per_session'
                      ? '\u20b9${widget.ratePerSession.toInt()}/sess'
                      : '\u20b9${_currentCost.toStringAsFixed(0)}',
                  style: const TextStyle(color: AppColors.midnight, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ]),
          ),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _MessageBubble(
                message: _messages[i],
                isMe: _messages[i]['sender_id'] == _myUserId,
                baseUrl: ApiConstants.baseUrl,
                token: _api.accessToken,
                onReport: () => _reportMessage(i),
              ),
            ),
          ),

          // Upload progress
          if (_uploading)
            Container(
              padding: const EdgeInsets.all(8),
              color: AppColors.nebula,
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold)),
                SizedBox(width: 8),
                Text('Uploading file...', style: TextStyle(color: AppColors.smoke, fontSize: 12)),
              ]),
            ),

          // Input bar — cosmic pill style
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.nebula,
              border: Border(top: BorderSide(color: AppColors.twilight)),
            ),
            child: Row(
              children: [
                // Attach button — now works on web too (file_picker + bytes).
                PopupMenuButton<String>(
                    onSelected: _pickAndUploadFile,
                    icon: const Icon(Icons.attach_file, color: AppColors.gold),
                    color: AppColors.nebula,
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'image', child: Row(children: [
                        Icon(Icons.image, color: AppColors.gold, size: 20),
                        SizedBox(width: 8),
                        Text('Photo', style: TextStyle(color: AppColors.ivory)),
                      ])),
                      const PopupMenuItem(value: 'pdf', child: Row(children: [
                        Icon(Icons.picture_as_pdf, color: AppColors.saffron, size: 20),
                        SizedBox(width: 8),
                        Text('PDF', style: TextStyle(color: AppColors.ivory)),
                      ])),
                    ],
                  ),
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    style: const TextStyle(color: AppColors.ivory, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: AppColors.smoke),
                      filled: true, fillColor: AppColors.nebula,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.gold, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: AppColors.gold.withOpacity(0.4), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44, height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [AppColors.gold, AppColors.saffron]),
                    ),
                    child: const Icon(Icons.send, color: AppColors.midnight, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;
  final String baseUrl;
  final String token;
  final VoidCallback? onReport;
  const _MessageBubble({required this.message, required this.isMe, required this.baseUrl, this.token = '', this.onReport});

  /// Absolute, authenticated URL for a chat media file. The download endpoint
  /// needs a JWT, and Image.network / web <img> cannot set an Authorization
  /// header — so the token rides as a query param instead.
  String _mediaUrl(String url) {
    final abs = url.startsWith('http') ? url : '$baseUrl$url';
    if (token.isEmpty) return abs;
    return abs + (abs.contains('?') ? '&' : '?') + 'token=$token';
  }

  @override
  Widget build(BuildContext context) {
    final msgType = message['message_type'] ?? 'text';
    final content = message['content'] ?? '';
    final mediaUrl = message['media_url'];
    final fileName = message['file_name'] ?? '';
    final fileSize = message['file_size'] ?? 0;
    final timestamp = message['timestamp']?.toString().substring(11, 16) ?? '';
    final senderName = message['sender_name'] ?? '';

    // In user app: isMe = user (gold-saffron gradient, right-aligned)
    //              !isMe = astrologer (indigo glass, left-aligned)
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // Timestamp centered, smoke color, mono font
          if (timestamp.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                timestamp,
                style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontFamily: 'monospace'),
              ),
            ),
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              decoration: BoxDecoration(
                // User (me): gold-saffron gradient
                // Astrologer (!me): indigo glass
                gradient: isMe
                    ? const LinearGradient(colors: [AppColors.gold, AppColors.saffron])
                    : null,
                color: isMe ? null : const Color(0xFF4A3B8C).withOpacity(0.4),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                border: isMe ? null : Border.all(color: AppColors.lavender.withOpacity(0.2)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (!isMe && senderName.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(senderName, style: const TextStyle(
                      color: AppColors.lavender,
                      fontSize: 11, fontWeight: FontWeight.w600,
                    )),
                  ),

                // Image message
                if (msgType == 'image' && mediaUrl != null)
                  GestureDetector(
                    onTap: () => _showFullImage(context, _mediaUrl(mediaUrl)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _mediaUrl(mediaUrl),
                        width: 200, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 200, height: 100,
                          color: AppColors.nebula,
                          child: const Icon(Icons.broken_image, color: AppColors.smoke),
                        ),
                      ),
                    ),
                  )
                // PDF message
                else if (msgType == 'pdf' && mediaUrl != null)
                  GestureDetector(
                    onTap: () => launchUrl(Uri.parse(_mediaUrl(mediaUrl)),
                        mode: LaunchMode.externalApplication),
                    child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (isMe ? AppColors.midnight : AppColors.nebula).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(children: [
                      Icon(Icons.picture_as_pdf, color: isMe ? AppColors.midnight : AppColors.saffron, size: 32),
                      const SizedBox(width: 8),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(fileName, style: TextStyle(color: isMe ? AppColors.midnight : AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
                        if (fileSize > 0)
                          Text(_formatFileSize(fileSize), style: TextStyle(color: isMe ? AppColors.midnight.withOpacity(0.6) : AppColors.smoke, fontSize: 11)),
                      ])),
                      Icon(Icons.download, color: isMe ? AppColors.midnight.withOpacity(0.6) : AppColors.gold, size: 22),
                    ]),
                  ))
                // Text message
                else
                  Text(
                    content,
                    style: TextStyle(
                      color: isMe ? AppColors.midnight : AppColors.ivory,
                      fontSize: 14,
                      fontWeight: isMe ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
              ]),
            ),
          ),

          // Chat-guard: safety warning under a flagged astrologer message.
          if (!isMe && message['flagged'] == true)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withOpacity(0.4)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Row(children: [
                    Icon(Icons.shield_outlined, color: AppColors.error, size: 15),
                    SizedBox(width: 6),
                    Expanded(child: Text(
                      'This looks like a request to pay or talk outside the app. Never pay an astrologer directly — pay only inside Nakshatralogy.',
                      style: TextStyle(color: AppColors.error, fontSize: 11.5, height: 1.35),
                    )),
                  ]),
                  if (onReport != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: message['reported'] == true ? null : onReport,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          minimumSize: const Size(0, 28),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: Icon(message['reported'] == true ? Icons.check : Icons.flag_outlined, size: 14, color: AppColors.error),
                        label: Text(message['reported'] == true ? 'Reported' : 'Report',
                            style: const TextStyle(color: AppColors.error, fontSize: 11.5, fontWeight: FontWeight.w600)),
                      ),
                    ),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  void _showFullImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: InteractiveViewer(
          child: Image.network(url.startsWith('http') ? url : '$baseUrl$url'),
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
