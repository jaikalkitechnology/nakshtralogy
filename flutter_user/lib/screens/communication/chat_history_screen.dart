import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});
  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final _api = ApiService();
  List<dynamic> _sessions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _sessions = await _api.getChatHistory(limit: 50);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat History')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _sessions.isEmpty
              ? _emptyView()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _sessions.length,
                    itemBuilder: (_, i) => _sessionCard(_sessions[i]),
                  ),
                ),
    );
  }

  Widget _emptyView() => RefreshIndicator(
    onRefresh: _load,
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 80),
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 2),
            ),
            child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.accent, size: 46),
          ),
        ),
        const SizedBox(height: 18),
        const Center(
          child: Text('No Chat Sessions Yet',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text('Your conversations with astrologers will appear here. Pull down to refresh.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/astrologers'),
            icon: const Icon(Icons.search, size: 18),
            label: const Text('Browse Astrologers'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _sessionCard(dynamic session) {
    final s = session as Map;
    final status = s['status']?.toString() ?? '';
    final billing = s['billing_mode']?.toString() ?? 'per_session';
    final dur = (s['duration_sec'] as num?)?.toInt() ?? 0;
    final amount = (s['total_amount'] as num?)?.toDouble() ?? 0;
    final msgCount = (s['user_message_count'] as num?)?.toInt() ?? 0;
    final msgLimit = (s['session_message_limit'] as num?)?.toInt() ?? 45;
    final date = s['created_at']?.toString() ?? '';
    final sessionId = s['id']?.toString() ?? '';
    final statusColor = status == 'completed' ? AppColors.success
        : status == 'expired' ? Colors.orange
        : status == 'cancelled' ? AppColors.error
        : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: sessionId.isNotEmpty ? () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => _ChatMessagesView(sessionId: sessionId),
        )) : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.chat_bubble_outline, color: AppColors.accent, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(billing == 'per_session' ? 'Chat Session' : 'Chat (per min)',
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                  child: Text(status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ]),
              const SizedBox(height: 4),
              Text('$msgCount/$msgLimit msgs  ${dur > 0 ? '${dur ~/ 60}m' : ''}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              Text(_formatDate(date), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              if (amount > 0) Text('\u20b9${amount.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
              const Icon(Icons.chevron_right, color: AppColors.primary, size: 20),
            ]),
          ]),
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}


class _ChatMessagesView extends StatefulWidget {
  final String sessionId;
  const _ChatMessagesView({required this.sessionId});
  @override
  State<_ChatMessagesView> createState() => _ChatMessagesViewState();
}

class _ChatMessagesViewState extends State<_ChatMessagesView> {
  final _api = ApiService();
  List<dynamic> _messages = [];
  bool _loading = true;
  String? _myUserId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final me = await _api.getMe();
    _myUserId = me['id']?.toString();
    _messages = await _api.getChatMessages(widget.sessionId, limit: 200);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Messages')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _messages.isEmpty
              ? const Center(child: Text('No messages', style: TextStyle(color: AppColors.textSecondary)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (_, i) => _msgBubble(_messages[i]),
                ),
    );
  }

  Widget _msgBubble(dynamic msg) {
    final m = msg as Map;
    final isMe = m['sender_id']?.toString() == _myUserId;
    final content = m['content']?.toString() ?? '';
    final type = m['message_type']?.toString() ?? 'text';
    final time = m['created_at']?.toString() ?? '';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary.withOpacity(0.2) : AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isMe ? 14 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 14),
          ),
          border: Border.all(color: isMe ? AppColors.primary.withOpacity(0.4) : AppColors.border),
        ),
        child: Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
          if (type == 'text')
            Text(content, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13))
          else
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(type == 'image' ? Icons.image : Icons.attach_file, size: 14, color: AppColors.accent),
              const SizedBox(width: 4),
              Flexible(child: Text(m['file_name']?.toString() ?? content, style: const TextStyle(color: AppColors.accent, fontSize: 12), overflow: TextOverflow.ellipsis)),
            ]),
          const SizedBox(height: 4),
          Text(_formatTime(time), style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
        ]),
      ),
    );
  }

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}
