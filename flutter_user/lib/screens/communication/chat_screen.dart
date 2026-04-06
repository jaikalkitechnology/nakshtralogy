import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../services/api_service.dart';

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

class _ChatScreenState extends State<ChatScreen> {
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

  @override
  void initState() {
    super.initState();
    _remainingMessages = widget.sessionMessageLimit;
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
            setState(() {
              _connected = data['status'] == 'active';
              _userMessageCount = data['user_message_count'] ?? 0;
              _remainingMessages = (data['session_message_limit'] ?? widget.sessionMessageLimit) - _userMessageCount;
            });
            if (_connected) _startTimer();
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
                    ElevatedButton(onPressed: () { Navigator.pop(ctx); Navigator.pop(context); }, child: const Text('OK')),
                  ],
                ),
              );
            }
            break;
          case 'typing':
            // Could show typing indicator
            break;
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

  double get _currentCost {
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
    // For now, use a simple file path input dialog
    // In production, integrate image_picker / file_picker packages
    final ctrl = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Send ${type == 'image' ? 'Photo' : 'PDF'}', style: const TextStyle(color: AppColors.primary)),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            labelText: type == 'image' ? 'Image file path' : 'PDF file path',
            hintText: type == 'image' ? '/path/to/photo.jpg' : '/path/to/file.pdf',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, ctrl.text.trim()), child: const Text('Upload')),
        ],
      ),
    );

    if (result == null || result.isEmpty) return;
    final file = File(result);
    if (!await file.exists()) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File not found')));
      return;
    }

    setState(() => _uploading = true);
    try {
      final resp = await _api.uploadChatFile(result, result.split('/').last);
      if (resp['statusCode'] == 200) {
        _sendFileMessage(resp['media_url'], resp['file_name'], resp['file_size'], resp['file_type']);
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
              _channel?.sink.add(jsonEncode({'type': 'end_session'}));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('End Chat'),
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
              _connected
                  ? widget.billingMode == 'per_session'
                      ? '$_formattedTime • $_remainingMessages msgs left'
                      : '$_formattedTime • ₹${_currentCost.toStringAsFixed(0)}'
                  : 'Connecting...',
              style: TextStyle(color: _connected ? AppColors.primary : AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(
              widget.billingMode == 'per_session'
                  ? '₹${widget.ratePerSession.toInt()}/sess'
                  : '₹${widget.ratePerMin.toInt()}/min',
              style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call_end, color: AppColors.error, size: 22),
            onPressed: _endSession,
          ),
        ],
      ),
      body: Column(
        children: [
          // Session info banner
          if (widget.billingMode == 'per_session')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: AppColors.accent.withOpacity(0.1),
              child: Row(children: [
                const Icon(Icons.info_outline, size: 14, color: AppColors.accent),
                const SizedBox(width: 6),
                Expanded(child: Text(
                  'Session: $_userMessageCount/${widget.sessionMessageLimit} messages used',
                  style: const TextStyle(color: AppColors.accent, fontSize: 12),
                )),
                Text('$_remainingMessages left', style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
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
              ),
            ),
          ),

          // Upload progress
          if (_uploading)
            Container(
              padding: const EdgeInsets.all(8),
              color: AppColors.card,
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                SizedBox(width: 8),
                Text('Uploading file...', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ]),
            ),

          // Input bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: const BoxDecoration(color: AppColors.card, border: Border(top: BorderSide(color: AppColors.border))),
            child: Row(
              children: [
                // Attach button
                PopupMenuButton<String>(
                  onSelected: _pickAndUploadFile,
                  icon: const Icon(Icons.attach_file, color: AppColors.primary),
                  color: AppColors.card,
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'image', child: Row(children: [
                      Icon(Icons.image, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text('Photo', style: TextStyle(color: AppColors.textPrimary)),
                    ])),
                    const PopupMenuItem(value: 'pdf', child: Row(children: [
                      Icon(Icons.picture_as_pdf, color: AppColors.error, size: 20),
                      SizedBox(width: 8),
                      Text('PDF', style: TextStyle(color: AppColors.textPrimary)),
                    ])),
                  ],
                ),
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: AppColors.textSecondary),
                      filled: true, fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44, height: 44,
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


class _MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;
  final String baseUrl;
  const _MessageBubble({required this.message, required this.isMe, required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    final msgType = message['message_type'] ?? 'text';
    final content = message['content'] ?? '';
    final mediaUrl = message['media_url'];
    final fileName = message['file_name'] ?? '';
    final fileSize = message['file_size'] ?? 0;
    final timestamp = message['timestamp']?.toString().substring(11, 16) ?? '';
    final senderName = message['sender_name'] ?? '';
    final isAstrologer = message['is_astrologer'] == true;

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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(senderName, style: TextStyle(
                color: isAstrologer ? AppColors.accent : AppColors.textSecondary,
                fontSize: 11, fontWeight: FontWeight.w600,
              )),
            ),

          // Image message
          if (msgType == 'image' && mediaUrl != null)
            GestureDetector(
              onTap: () => _showFullImage(context, mediaUrl),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  mediaUrl.startsWith('http') ? mediaUrl : '$baseUrl$mediaUrl',
                  width: 200, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 200, height: 100,
                    color: AppColors.surface,
                    child: const Icon(Icons.broken_image, color: AppColors.textSecondary),
                  ),
                ),
              ),
            )
          // PDF message
          else if (msgType == 'pdf' && mediaUrl != null)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isMe ? Colors.black : AppColors.surface).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                Icon(Icons.picture_as_pdf, color: isMe ? Colors.black87 : AppColors.error, size: 32),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(fileName, style: TextStyle(color: isMe ? Colors.black : AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (fileSize > 0)
                    Text(_formatFileSize(fileSize), style: TextStyle(color: isMe ? Colors.black54 : AppColors.textSecondary, fontSize: 11)),
                ])),
                Icon(Icons.download, color: isMe ? Colors.black54 : AppColors.primary, size: 22),
              ]),
            )
          // Text message
          else
            Text(content, style: TextStyle(color: isMe ? Colors.black : AppColors.textPrimary, fontSize: 14)),

          const SizedBox(height: 2),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(timestamp, style: TextStyle(color: isMe ? Colors.black54 : AppColors.textSecondary, fontSize: 10)),
          ),
        ]),
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
