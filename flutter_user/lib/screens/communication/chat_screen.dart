import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';

class ChatScreen extends StatefulWidget {
  final String sessionId;
  final String astrologerName;
  final double ratePerMin;

  const ChatScreen({
    super.key,
    required this.sessionId,
    required this.astrologerName,
    required this.ratePerMin,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  WebSocketChannel? _channel;
  String? _myUserId;
  int _seconds = 0;
  Timer? _timer;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<void> _connect() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final userData = prefs.getString('user_data');
    if (userData != null) {
      _myUserId = jsonDecode(userData)['id'];
    }

    final uri = Uri.parse('${ApiConstants.wsChat}/${widget.sessionId}?token=$token');
    _channel = WebSocketChannel.connect(uri);

    _channel!.stream.listen(
      (raw) {
        final data = jsonDecode(raw as String);
        if (data['type'] == 'message') {
          setState(() => _messages.add(data));
          _scrollToBottom();
        } else if (data['type'] == 'session_info' && data['status'] == 'active') {
          setState(() => _connected = true);
          _startTimer();
        }
      },
      onDone: () => setState(() => _connected = false),
      onError: (_) => setState(() => _connected = false),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  String get _formattedTime {
    final min = _seconds ~/ 60;
    final sec = _seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  double get _currentCost => (_seconds / 60).ceil() * widget.ratePerMin;

  void _sendMessage() {
    if (_msgCtrl.text.trim().isEmpty || _channel == null) return;
    _channel!.sink.add(jsonEncode({
      'type': 'message',
      'content': _msgCtrl.text.trim(),
      'message_type': 'text',
    }));
    _msgCtrl.clear();
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
    _timer?.cancel();
    _channel?.sink.close();
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Header
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.astrologerName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
            Text(
              _connected ? '$_formattedTime \u2022 \u20b9${_currentCost.toStringAsFixed(0)}' : 'Connecting...',
              style: TextStyle(color: _connected ? AppColors.primary : AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('\u20b9${widget.ratePerMin.toInt()}/min', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),

      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                final isMe = msg['sender_id'] == _myUserId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primary : AppColors.card,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 16),
                      ),
                      border: isMe ? null : Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg['content'] ?? '', style: TextStyle(color: isMe ? Colors.black : AppColors.textPrimary, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(
                          msg['timestamp']?.toString().substring(11, 16) ?? '',
                          style: TextStyle(color: isMe ? Colors.black54 : AppColors.textSecondary, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(color: AppColors.card, border: Border(top: BorderSide(color: AppColors.border))),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                    child: const Icon(Icons.send, color: Colors.black, size: 20),
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
