import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../services/api_service.dart';

class AstroChatScreen extends StatefulWidget {
  final String sessionId;
  final String userName;
  final double ratePerMin;
  final double ratePerSession;
  final String billingMode;
  final int sessionMessageLimit;

  const AstroChatScreen({
    super.key,
    required this.sessionId,
    required this.userName,
    this.ratePerMin = 0,
    this.ratePerSession = 0,
    this.billingMode = 'per_session',
    this.sessionMessageLimit = 45,
  });

  @override
  State<AstroChatScreen> createState() => _AstroChatScreenState();
}

class _AstroChatScreenState extends State<AstroChatScreen> with WidgetsBindingObserver {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _api = ApiService();
  final List<Map<String, dynamic>> _messages = [];
  WebSocketChannel? _channel;
  String? _myUserId;
  int _seconds = 0;
  Timer? _timer;
  bool _connected = false;
  int _userMessageCount = 0;
  int _remainingMessages = 0;
  bool _uploading = false;
  // Auto-heal: keep the socket alive with pings and reconnect (with backoff) on
  // a drop instead of leaving the header stuck on "Connecting…".
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  bool _reconnecting = false;
  bool _closed = false;             // set on intentional end/leave — stops reconnect
  int _reconnectAttempts = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _remainingMessages = widget.sessionMessageLimit;
    _connect();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _sendEndSession();
    }
  }

  void _sendEndSession() {
    _closed = true;
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    try {
      _channel?.sink.add(jsonEncode({'type': 'end_session'}));
    } catch (_) {}
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      try { _channel?.sink.add(jsonEncode({'type': 'ping'})); } catch (_) {}
    });
  }

  void _onSocketClosed() {
    _pingTimer?.cancel();
    if (_closed || !mounted) return;
    setState(() { _connected = false; _reconnecting = true; });
    _reconnectTimer?.cancel();
    const backoff = [2, 4, 8, 16, 30];
    final delay = backoff[_reconnectAttempts.clamp(0, backoff.length - 1)];
    _reconnectAttempts++;
    _reconnectTimer = Timer(Duration(seconds: delay), () {
      if (_closed || !mounted) return;
      _connect();
    });
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
            final active = data['status'] == 'active';
            setState(() {
              _connected = active;
              _reconnecting = false;
              _userMessageCount = data['user_message_count'] ?? 0;
              _remainingMessages = (data['session_message_limit'] ?? widget.sessionMessageLimit) - _userMessageCount;
            });
            if (active) {
              _reconnectAttempts = 0;
              _startTimer();
              _startPing();
            }
            break;
          case 'ping':
            try { _channel?.sink.add(jsonEncode({'type': 'pong'})); } catch (_) {}
            break;
          case 'pong':
            break;
          case 'session_taken_over':
            _closed = true;
            _pingTimer?.cancel();
            _reconnectTimer?.cancel();
            _timer?.cancel();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(data['message'] ?? 'Chat opened on another device'),
                backgroundColor: AppColors.error));
              Navigator.pop(context);
            }
            break;
          case 'session_ended':
            _timer?.cancel();
            if (mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppColors.card,
                  title: const Text('Session Ended', style: TextStyle(color: AppColors.primary)),
                  content: Text(data['reason'] ?? 'Chat session has ended', style: const TextStyle(color: AppColors.textPrimary)),
                  actions: [
                    ElevatedButton(onPressed: () { Navigator.pop(ctx); Navigator.pop(context); }, child: Text(AppLocalizations.of(context)?.ok ?? 'OK')),
                  ],
                ),
              );
            }
            break;
        }
      },
      onDone: _onSocketClosed,
      onError: (_) => _onSocketClosed(),
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

  double get _currentEarning {
    double gross;
    if (widget.billingMode == 'per_session') {
      gross = widget.ratePerSession;
    } else {
      gross = (_seconds / 60).ceil() * widget.ratePerMin;
    }
    return gross * 0.7; // approx after 30% commission
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not read the selected file')));
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
        content: const Text('Are you sure you want to end this session?', style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _channel?.sink.add(jsonEncode({'type': 'end_session'}));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(AppLocalizations.of(context)?.endChat ?? 'End Chat'),
          ),
        ],
      ),
    );
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
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  // Client avatar gradient circle
                  Container(
                    width: 40, height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.gold, AppColors.saffron],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '?',
                        style: const TextStyle(color: AppColors.midnight, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Client name + status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.userName, style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w600)),
                        Text(
                          _connected ? 'Online' : (_reconnecting ? 'Reconnecting…' : 'Connecting...'),
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
          // Client kundli strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.indigo.withOpacity(0.2),
              border: const Border(bottom: BorderSide(color: AppColors.twilight, width: 0.5)),
            ),
            child: Row(children: [
              const Text(
                'CLIENT KUNDLI',
                style: TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(
                'Msgs: $_userMessageCount/${widget.sessionMessageLimit} ($_remainingMessages left)',
                style: const TextStyle(color: AppColors.lavender, fontSize: 12),
              )),
              // Earning badge (gold-saffron gradient)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.billingMode == 'per_session'
                      ? '\u20b9${_currentEarning.toStringAsFixed(0)}'
                      : '\u20b9${_currentEarning.toStringAsFixed(0)}',
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
              itemBuilder: (_, i) => _AstroMessageBubble(
                message: _messages[i],
                isMe: _messages[i]['sender_id'] == _myUserId,
                baseUrl: ApiConstants.baseUrl,
                token: _api.accessToken,
              ),
            ),
          ),

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
                // File attachment now works on web too (file_picker + bytes).
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


class _AstroMessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;
  final String baseUrl;
  final String token;
  const _AstroMessageBubble({required this.message, required this.isMe, required this.baseUrl, this.token = ''});

  /// Authenticated media URL — the download endpoint needs a JWT and
  /// Image.network can't set an Authorization header, so pass it as ?token=.
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

    // In astro app: isMe = astrologer (gold-saffron gradient, right-aligned)
    //               !isMe = client (indigo glass, left-aligned)
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
                // Astrologer (me): gold-saffron gradient
                // Client (!me): indigo glass
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
                    child: Text(senderName, style: const TextStyle(color: AppColors.lavender, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),

                if (msgType == 'image' && mediaUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _mediaUrl(mediaUrl),
                      width: 200, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 200, height: 100, color: AppColors.nebula,
                        child: const Icon(Icons.broken_image, color: AppColors.smoke),
                      ),
                    ),
                  )
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
                          Text(_formatSize(fileSize), style: TextStyle(color: isMe ? AppColors.midnight.withOpacity(0.6) : AppColors.smoke, fontSize: 11)),
                      ])),
                      Icon(Icons.download, color: isMe ? AppColors.midnight.withOpacity(0.6) : AppColors.gold, size: 22),
                    ]),
                  ))
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
        ],
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
