import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/ai_topics.dart';
import '../../widgets/ai_agent_paywall.dart';
import '../../widgets/responsive_center.dart';
import 'ai_specialist_chat_screen.dart';

/// ChatGPT-style AI chat home: "New Chat" + resumable chat history.
/// Durable server-side history (AIChat/AIChatMessage) — every chat started
/// here, or from a report screen's "Ask AI" button, shows up in this list.
class AiChatListScreen extends StatefulWidget {
  const AiChatListScreen({super.key});

  @override
  State<AiChatListScreen> createState() => _AiChatListScreenState();
}

class _AiChatListScreenState extends State<AiChatListScreen> {
  final _api = ApiService();
  List<dynamic> _chats = [];
  List<dynamic> _charts = [];
  Map<String, dynamic> _agentMeta = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      _api.listAgentChats(),
      _api.getMyCharts(limit: 50),
      _api.getAiAgents(),
    ]);
    if (!mounted) return;
    setState(() {
      _chats = results[0] as List<dynamic>;
      _charts = results[1] as List<dynamic>;
      _agentMeta = results[2] as Map<String, dynamic>;
      _loading = false;
    });
  }

  String _chartName(String? chartId) {
    if (chartId == null) return '';
    final m = _charts.cast<Map?>().firstWhere((c) => c?['id']?.toString() == chartId, orElse: () => null);
    return m?['name']?.toString() ?? '';
  }

  String _relativeTime(String? iso) {
    if (iso == null) return '';
    DateTime? t;
    try {
      t = DateTime.parse(iso).toLocal();
    } catch (_) {
      return '';
    }
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${t.day}/${t.month}/${t.year}';
  }

  Future<void> _deleteChat(String chatId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Delete chat?', style: TextStyle(color: AppColors.ivory)),
        content: const Text('This chat and its messages will be permanently deleted.',
            style: TextStyle(color: AppColors.smoke, fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete', style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _chats.removeWhere((c) => c['id'] == chatId));
    await _api.deleteAgentChat(chatId);
  }

  Future<void> _openChat(String chatId) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AiSpecialistChatScreen(chatId: chatId),
    ));
    _loadAll();
  }

  Future<void> _startNewChat() async {
    if (_charts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Create a birth chart first to start an AI chat.'),
      ));
      return;
    }
    final topic = await _pickTopic();
    if (topic == null) return;
    Map<String, dynamic>? chart = _charts.length == 1 ? (_charts.first as Map).cast<String, dynamic>() : await _pickChart();
    if (chart == null) return;

    final unlocked = await _ensureUnlocked(topic);
    if (!unlocked) return;

    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AiSpecialistChatScreen(
        chartId: chart['id']?.toString(),
        domainKey: topic.domainKey,
        engineKey: topic.engineKey,
        label: topic.label,
        emoji: topic.emoji,
      ),
    ));
    _loadAll();
  }

  /// Visible topics for this user: General is always available; the rest
  /// must be published (or testing + I'm a tester) per the admin's AI Chat
  /// Agents control — mirrors the filtering on the home tab's 12-tile grid.
  List<AiTopic> get _visibleTopics =>
      kAiChatTopics.where((t) => t.isGeneral || _agentMeta.containsKey(t.metaKey)).toList();

  Future<AiTopic?> _pickTopic() {
    return showModalBottomSheet<AiTopic>(
      context: context,
      backgroundColor: AppColors.nebula,
      constraints: const BoxConstraints(maxWidth: 640),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (ctx) {
        final topics = _visibleTopics;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Choose a topic', style: TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text('What would you like to talk about?', style: TextStyle(color: AppColors.smoke, fontSize: 12)),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.55),
                child: GridView.builder(
                  shrinkWrap: true,
                  // 3 columns on phones, more on wider sheets; tile height
                  // follows the user's text size so labels never clip.
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 132, mainAxisSpacing: 10, crossAxisSpacing: 10,
                    mainAxisExtent: 100 * tileTextScale(ctx),
                  ),
                  itemCount: topics.length,
                  itemBuilder: (_, i) {
                    final t = topics[i];
                    final meta = t.metaKey != null ? _agentMeta[t.metaKey] as Map<String, dynamic>? : null;
                    final locked = meta != null && meta['is_paid'] == true && meta['unlocked'] != true;
                    return GestureDetector(
                      onTap: () => Navigator.pop(ctx, t),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                        ),
                        child: Stack(children: [
                          Center(
                            child: Column(mainAxisSize: MainAxisSize.min, children: [
                              Text(t.emoji, style: const TextStyle(fontSize: 26)),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(t.label, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: AppColors.ivory, fontSize: 10.5, fontWeight: FontWeight.w600)),
                              ),
                            ]),
                          ),
                          if (locked)
                            const Positioned(top: 6, right: 6, child: DecoratedBox(
                              decoration: BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.lock, size: 10, color: AppColors.midnight),
                              ),
                            )),
                        ]),
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _pickChart() {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: AppColors.nebula,
      constraints: const BoxConstraints(maxWidth: 640),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Whose chart?', style: TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.5),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _charts.length,
                itemBuilder: (_, i) {
                  final c = (_charts[i] as Map).cast<String, dynamic>();
                  return ListTile(
                    leading: const Icon(Icons.person, color: AppColors.gold),
                    title: Text(c['name']?.toString() ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.ivory)),
                    subtitle: Text('${c['dob']} · ${c['place']}', maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
                    onTap: () => Navigator.pop(ctx, c),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  /// Paid-topic unlock flow (shared paywall): one-time unlock — wallet
  /// (India) or store IAP (international) — or a time-pass plan from the
  /// wallet. Returns true if the topic is free, already unlocked/has time
  /// left, or becomes unlocked.
  Future<bool> _ensureUnlocked(AiTopic topic) async {
    final key = topic.metaKey;
    if (key == null) return true;
    final meta = _agentMeta[key] as Map<String, dynamic>?;
    final access = await ensureAiAgentAccess(context, key: key, meta: meta, label: topic.label, emoji: topic.emoji);
    if (access == null) return false;
    if (meta != null) _agentMeta = {..._agentMeta, key: access};
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cosmicVoid,
      appBar: AppBar(
        title: const Text('AI Chat', style: TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAll)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startNewChat,
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.midnight,
        icon: const Icon(Icons.add),
        label: const Text('New Chat', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _chats.isEmpty
              ? _emptyState()
              : RefreshIndicator(
                  color: AppColors.gold,
                  onRefresh: _loadAll,
                  child: ResponsiveCenter(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
                      itemCount: _chats.length,
                      itemBuilder: (_, i) => _chatCard(_chats[i] as Map<String, dynamic>),
                    ),
                  ),
                ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('💬', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        const Text('No chats yet', style: TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text('Start a new chat to ask about your chart', textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.smoke, fontSize: 12)),
        ),
      ]),
    );
  }

  Widget _chatCard(Map<String, dynamic> chat) {
    final topic = topicForEngineKey(chat['engine_key']?.toString());
    final chartId = chat['chart_id']?.toString();
    final title = (chat['title'] as String?)?.trim();
    final displayTitle = (title == null || title.isEmpty) ? topic.label : title;
    return Dismissible(
      key: ValueKey(chat['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: AppColors.error.withOpacity(0.8), borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        await _deleteChat(chat['id'].toString());
        return false; // we remove it from the list ourselves after confirming
      },
      child: GestureDetector(
        onTap: () => _openChat(chat['id'].toString()),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold.withOpacity(0.15)),
          ),
          child: Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppColors.indigo.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text(topic.emoji, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(displayTitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(
                (chat['last_message_preview'] as String?)?.isNotEmpty == true
                    ? chat['last_message_preview'].toString()
                    : _chartName(chartId),
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.smoke, fontSize: 11),
              ),
            ])),
            const SizedBox(width: 8),
            Text(_relativeTime(chat['updated_at']?.toString()), style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
          ]),
        ),
      ),
    );
  }
}
