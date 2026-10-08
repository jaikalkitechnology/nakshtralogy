import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import '../../utils/ai_topics.dart';
import '../../l10n/gen/app_localizations.dart';

class AiSpecialistChatScreen extends StatefulWidget {
  /// Resume an existing chat (from the chat list / history). When set,
  /// chartId/domainKey/engineKey/label/emoji are ignored — they're loaded
  /// from the saved chat instead.
  final String? chatId;
  /// Legacy entry point (the 12-domain home-tab grid, a report screen's
  /// "Ask AI" button): one of the probability domains.
  final String? domainKey;
  /// New entry point: an explicit specialist/engine topic key, or null for
  /// a general/unscoped chat.
  final String? engineKey;
  /// Preselect a chart, skipping the chart picker (e.g. opened from a
  /// report screen that already has a chart in context).
  final String? chartId;
  final String? label;
  final String? emoji;

  const AiSpecialistChatScreen({
    super.key,
    this.chatId,
    this.domainKey,
    this.engineKey,
    this.chartId,
    this.label,
    this.emoji,
  });

  @override
  State<AiSpecialistChatScreen> createState() => _AiSpecialistChatScreenState();
}

class _AiSpecialistChatScreenState extends State<AiSpecialistChatScreen> {
  final _api = ApiService();
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  late AiTopic _topic;
  String get _topicLabel => widget.label ?? _topic.label;
  String get _topicEmoji => widget.emoji ?? _topic.emoji;

  List<dynamic> _charts = [];
  List<dynamic> _dbLanguages = [];  // loaded from DB via API
  String? _selectedChartId;
  String? _selectedChartName;
  String? _chatId;
  bool _loadingCharts = true;
  bool _resuming = false;
  bool _sending = false;
  String _language = 'auto';  // auto-detect by default
  String? _detectedLanguage;    // last detected language from server
  List<String> _followupSuggestions = []; // LLM-generated chips after each reply
  List<dynamic> _suggestedQuestions = []; // DB-loaded question chips per domain

  WebSocketChannel? _ws;
  bool _wsConnected = false;

  @override
  void initState() {
    super.initState();
    _chatId = widget.chatId;
    _topic = widget.engineKey != null
        ? topicForEngineKey(widget.engineKey)
        : topicForDomainKey(widget.domainKey);
    _loadLanguages();
    if (widget.chatId != null) {
      _resumeChat(widget.chatId!);
    } else {
      _loadCharts();
    }
  }

  /// The specialist/engine key sent to the backend for a NEW chat — an
  /// explicit engineKey wins; otherwise a legacy domainKey maps through to
  /// its specialist (see kDomainToSpecialist); null for a general chat.
  String? get _engineKeyForNewChat =>
      widget.engineKey ?? (widget.domainKey != null ? kDomainToSpecialist[widget.domainKey] : null);

  Future<void> _resumeChat(String chatId) async {
    setState(() => _resuming = true);
    final chats = _api.getMyCharts(limit: 50); // kick off in parallel
    final chat = await _api.getAgentChat(chatId);
    _charts = await chats;
    if (chat == null) {
      if (mounted) {
        setState(() => _resuming = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chat not found')));
        Navigator.of(context).maybePop();
      }
      return;
    }
    _topic = topicForEngineKey(chat['engine_key']?.toString());
    _selectedChartId = chat['chart_id']?.toString();
    final chartMatch = _charts.cast<Map?>().firstWhere(
          (c) => c?['id']?.toString() == _selectedChartId,
          orElse: () => null,
        );
    _selectedChartName = chartMatch?['name']?.toString() ?? 'Chart';
    final msgs = (chat['messages'] as List?) ?? [];
    for (final m in msgs) {
      final map = m as Map;
      _messages.add({
        'role': map['role'] == 'assistant' ? 'bot' : 'user',
        'text': map['content']?.toString() ?? '',
        'message_id': map['message_id']?.toString(),
        'feedback': 0,
      });
    }
    setState(() { _loadingCharts = false; _resuming = false; });
    _connectWs();
    _loadSuggestedQuestions();
    _scrollToBottom();
  }

  Future<void> _loadLanguages() async {
    try {
      final langs = await _api.getAiLanguages();
      if (mounted && langs.isNotEmpty) setState(() => _dbLanguages = langs);
    } catch (_) {}
  }

  Future<void> _loadSuggestedQuestions() async {
    final domainKey = _topic.domainKey;
    if (domainKey == null) return;
    try {
      final langCode = _language == 'auto' ? 'english' : _language;
      final qs = await _api.getAiQuestions(domainKey, lang: langCode);
      if (mounted && qs.isNotEmpty) setState(() => _suggestedQuestions = qs);
    } catch (_) {}
  }

  Future<void> _loadCharts() async {
    _charts = await _api.getMyCharts(limit: 50);
    if (widget.chartId != null) {
      final match = _charts.cast<Map?>().firstWhere(
            (c) => c?['id']?.toString() == widget.chartId,
            orElse: () => null,
          );
      if (match != null) {
        // Stay on the spinner (not the chart list) while auto-selecting.
        await _selectChart(match.cast<String, dynamic>());
        if (mounted) setState(() => _loadingCharts = false);
        return;
      }
    }
    if (mounted) setState(() => _loadingCharts = false);
  }

  @override
  void dispose() {
    _ws?.sink.close();
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _connectWs() {
    _ws?.sink.close();
    final token = _api.accessToken;
    if (token.isEmpty) return;
    final uri = Uri.parse('${ApiConstants.wsAgentChat}?token=$token');
    _ws = WebSocketChannel.connect(uri);
    _wsConnected = true;

    _ws!.stream.listen(
      (data) {
        final msg = jsonDecode(data as String) as Map<String, dynamic>;
        _handleWsMessage(msg);
      },
      onError: (e) {
        _wsConnected = false;
        if (mounted && _sending) {
          setState(() => _sending = false);
          _addBotMessage('⚠️ ${AppLocalizations.of(context)!.aiConnectionLost}');
        }
      },
      onDone: () => _wsConnected = false,
    );
  }

  void _handleWsMessage(Map<String, dynamic> msg) {
    final type = msg['type']?.toString();

    if (type == 'prob') {
      final d = msg['data'] as Map<String, dynamic>? ?? {};
      final detected = d['detected_language']?.toString();
      final serverChatId = d['chat_id']?.toString();
      if (serverChatId != null && serverChatId.isNotEmpty) _chatId = serverChatId;
      setState(() {
        if (detected != null && detected.isNotEmpty) {
          _detectedLanguage = detected;
        }
        _messages.add({
          'role': 'bot',
          'text': '',
          'streaming': true,
          'probability': (d['probability'] as num?)?.toDouble(),
          'band': d['band']?.toString(),
          'message_id': d['message_id']?.toString(),
          'domain': d['domain']?.toString(),
          'feedback': 0,  // 0 = none, +1 = up, -1 = down
        });
      });
      _scrollToBottom();
    } else if (type == 'token') {
      final text = msg['text']?.toString() ?? '';
      if (_messages.isNotEmpty && _messages.last['streaming'] == true) {
        setState(() {
          final current = (_messages.last['text'] ?? '') as String;
          final combined = current + text;
          // Hide the LLM's follow-up marker and everything after it from the bubble
          final markerIdx = combined.indexOf('---FOLLOWUPS---');
          _messages.last['text'] = markerIdx >= 0 ? combined.substring(0, markerIdx).trimRight() : combined;
        });
        _scrollToBottom();
      }
    } else if (type == 'followups') {
      final items = (msg['items'] as List?) ?? [];
      setState(() {
        _followupSuggestions = items.map((e) => e.toString()).toList();
      });
    } else if (type == 'done' || type == 'interrupted') {
      if (_messages.isNotEmpty && _messages.last['streaming'] == true) {
        setState(() {
          _messages.last.remove('streaming');
          if (type == 'interrupted') {
            final current = (_messages.last['text'] ?? '') as String;
            if (current.isNotEmpty) {
              _messages.last['text'] = '$current\n\n_[stopped]_';
            }
          }
          _sending = false;
        });
      }
    } else if (type == 'error') {
      setState(() => _sending = false);
      _addBotMessage('⚠️ ${msg['text'] ?? AppLocalizations.of(context)!.aiSomethingWrong}');
    }
  }

  Future<void> _selectChart(Map<String, dynamic> chart) async {
    final chartId = chart['id']?.toString();
    if (chartId == null) return;
    final created = await _api.createAgentChat(
      chartId: chartId,
      engineKey: _engineKeyForNewChat,
      language: _language == 'auto' ? null : _language,
    );
    if (created == null || created['id'] == null) {
      if (mounted) {
        final detail = (created?['detail'] ?? '').toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(detail.isNotEmpty ? detail : 'Could not start this chat'),
          backgroundColor: AppColors.error,
        ));
      }
      return;
    }
    setState(() {
      _selectedChartId = chartId;
      _selectedChartName = chart['name']?.toString() ?? 'Chart';
      _chatId = created['id']?.toString();
    });
    _connectWs();
    _loadSuggestedQuestions();
    _addBotMessage('$_topicEmoji Welcome! I\'m your **$_topicLabel** assistant.\n\nAnalyzing the birth chart of **$_selectedChartName**.\n\nAsk me anything about ${_topicLabel.toLowerCase()}!');
  }

  void _stopGeneration() {
    if (!_sending) return;
    if (_wsConnected && _ws != null) {
      _ws!.sink.add(jsonEncode({'type': 'interrupt'}));
    }
    if (_messages.isNotEmpty && _messages.last['streaming'] == true) {
      setState(() {
        _messages.last.remove('streaming');
        final current = (_messages.last['text'] ?? '') as String;
        if (current.isNotEmpty) {
          _messages.last['text'] = '$current\n\n_[stopped]_';
        }
        _sending = false;
      });
    } else {
      setState(() => _sending = false);
    }
  }

  Future<void> _sendMessage() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty || _selectedChartId == null || _sending) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _sending = true;
      _followupSuggestions = [];  // clear old suggestions
    });
    _msgCtrl.clear();
    _scrollToBottom();

    if (!_wsConnected || _ws == null) {
      _connectWs();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (_wsConnected && _ws != null) {
      _ws!.sink.add(jsonEncode({
        'chart_id': _selectedChartId,
        'chat_id': _chatId,
        'query': text,
        'domain': _topic.domainKey,
        'engine': _topic.engineKey,
        'language': _language,
      }));
    } else {
      try {
        final resp = await _api.agentChat(
          chartId: _selectedChartId!, query: text,
          domain: _topic.domainKey, language: _language,
        );
        if (resp['statusCode'] == 200) {
          _addBotMessage(resp['message']?.toString() ?? AppLocalizations.of(context)!.aiNoResponse,
              probability: (resp['probability'] as num?)?.toDouble(),
              band: resp['band']?.toString());
        } else {
          _addBotMessage('⚠️ ${resp['detail'] ?? AppLocalizations.of(context)!.aiSomethingWrong}');
        }
      } catch (e) {
        _addBotMessage('⚠️ ${AppLocalizations.of(context)!.aiConnectionError}');
      }
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _sendFeedback(Map<String, dynamic> msg, int rating) async {
    final messageId = msg['message_id']?.toString();
    if (messageId == null || messageId.isEmpty) return;
    if (msg['feedback'] == rating) return;  // already sent
    setState(() => msg['feedback'] = rating);

    // Find the user query that preceded this bot message
    String? userQuery;
    final idx = _messages.indexOf(msg);
    for (int i = idx - 1; i >= 0; i--) {
      if (_messages[i]['role'] == 'user') {
        userQuery = _messages[i]['text']?.toString();
        break;
      }
    }
    final responseText = msg['text']?.toString() ?? '';

    final ok = await _api.submitAgentFeedback(
      messageId: messageId,
      rating: rating,
      chartId: _selectedChartId,
      provider: 'ollama',
      domain: msg['domain']?.toString(),
      language: _detectedLanguage ?? _language,
      query: userQuery,
      responseSnippet: responseText.length > 300 ? responseText.substring(0, 300) : responseText,
    );
    if (!ok && mounted) {
      setState(() => msg['feedback'] = 0);  // revert on failure
    }
  }

  void _addBotMessage(String text, {double? probability, String? band}) {
    setState(() {
      _messages.add({
        'role': 'bot', 'text': text,
        if (probability != null) 'probability': probability,
        if (band != null) 'band': band,
      });
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (_resuming) {
      return Scaffold(
        backgroundColor: AppColors.cosmicVoid,
        body: const Center(child: CircularProgressIndicator(color: AppColors.gold)),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.cosmicVoid,
      appBar: AppBar(
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(_topicEmoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Flexible(child: Text(_topicLabel, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
        ]),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language, size: 20),
            color: AppColors.nebula,
            tooltip: _language == 'auto'
                ? (_detectedLanguage != null ? l.aiAutoArrow(_displayLang(_detectedLanguage!)) : l.aiAutoDetect)
                : l.aiLanguageLabel(_displayLang(_language)),
            onSelected: (v) => setState(() => _language = v),
            itemBuilder: (_) => [
              PopupMenuItem(value: 'auto', child: Row(children: [const Icon(Icons.auto_fix_high, size: 14), const SizedBox(width: 8), Text('🌐 ${l.aiAutoDetect}')])),
              const PopupMenuDivider(),
              // Dynamic from DB (fallback to hardcoded if DB empty)
              ...(_dbLanguages.isNotEmpty
                  ? _dbLanguages.map<PopupMenuEntry<String>>((lang) => PopupMenuItem(
                      value: lang['code']?.toString() ?? '',
                      child: Text('${lang['native_label'] ?? ''}  ${lang['label'] ?? ''}'),
                    ))
                  : <PopupMenuEntry<String>>[
                      const PopupMenuItem(value: 'english',   child: Text('English')),
                      const PopupMenuItem(value: 'hindi',     child: Text('हिंदी  Hindi')),
                      const PopupMenuItem(value: 'hinglish',  child: Text('Hinglish')),
                      const PopupMenuItem(value: 'bengali',   child: Text('বাংলা  Bengali')),
                      const PopupMenuItem(value: 'tamil',     child: Text('தமிழ்  Tamil')),
                      const PopupMenuItem(value: 'telugu',    child: Text('తెలుగు  Telugu')),
                      const PopupMenuItem(value: 'kannada',   child: Text('ಕನ್ನಡ  Kannada')),
                      const PopupMenuItem(value: 'malayalam', child: Text('മലയാളം  Malayalam')),
                      const PopupMenuItem(value: 'gujarati',  child: Text('ગુજરાતી  Gujarati')),
                      const PopupMenuItem(value: 'marathi',   child: Text('मराठी  Marathi')),
                      const PopupMenuItem(value: 'punjabi',   child: Text('ਪੰਜਾਬੀ  Punjabi')),
                    ]),
            ],
          ),
        ],
      ),
      body: _selectedChartId == null ? _chartSelector() : _chatView(),
    );
  }

  // ── Chart Selector ──────────────────────────────────────────────────

  Widget _chartSelector() {
    final l = AppLocalizations.of(context)!;
    if (_loadingCharts) return const Center(child: CircularProgressIndicator(color: AppColors.gold));
    if (_charts.isEmpty) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('\U0001f4dc', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        Text(l.aiNoBirthCharts, style: const TextStyle(color: AppColors.ivory, fontSize: 16)),
        const SizedBox(height: 4),
        Text(l.aiCreateChartFirst, style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
      ]));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$_topicEmoji $_topicLabel', style: const TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(l.aiSelectChartBegin, style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
        ]),
      ),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _charts.length,
          itemBuilder: (_, i) {
            final c = _charts[i] as Map;
            return GestureDetector(
              onTap: () => _selectChart(c.cast<String, dynamic>()),
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
                    width: 42, height: 42,
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]), borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text((c['name']?.toString() ?? 'C').substring(0, 1).toUpperCase(), style: const TextStyle(color: AppColors.midnight, fontSize: 18, fontWeight: FontWeight.w700))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(c['name']?.toString() ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600)),
                    Text('${c['dob']} · ${c['tob']} · ${c['place']}', style: const TextStyle(color: AppColors.smoke, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ])),
                  const Icon(Icons.arrow_forward_ios, color: AppColors.gold, size: 14),
                ]),
              ),
            );
          },
        ),
      ),
    ]);
  }

  // ── Chat View ───────────────────────────────────────────────────────

  Widget _chatView() {
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      // Chart info strip
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        color: AppColors.nebula.withOpacity(0.5),
        child: Row(children: [
          const Icon(Icons.auto_awesome, size: 12, color: AppColors.gold),
          const SizedBox(width: 6),
          Text(l.aiAnalyzingName(_selectedChartName ?? ''), style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        ]),
      ),
      // Messages
      Expanded(
        child: ListView.builder(
          controller: _scrollCtrl,
          padding: const EdgeInsets.all(16),
          itemCount: _messages.length,
          itemBuilder: (_, i) => _messageBubble(_messages[i]),
        ),
      ),
      // Streaming indicator
      if (_sending && (_messages.isEmpty || _messages.last['streaming'] != true))
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(children: [
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold)),
            const SizedBox(width: 8),
            Text(l.aiAnalyzingChart, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
          ]),
        ),
      // Initial sample suggestions (before any chat)
      if (_messages.length <= 1) _suggestions(),
      // LLM-generated follow-up chips (after each bot reply)
      if (_followupSuggestions.isNotEmpty && !_sending) _followupChips(),
      _inputBar(),
    ]);
  }

  // ── Input ─────────────────────────────────────────────────────────

  Widget _inputBar() {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
      decoration: BoxDecoration(
        color: AppColors.nebula,
        border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.15))),
      ),
      child: SafeArea(
        top: false,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Text input + send
          Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.gold.withOpacity(0.2)),
                ),
                child: TextField(
                  controller: _msgCtrl,
                  style: const TextStyle(color: AppColors.ivory, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: l.aiAskStarsHint,
                    hintStyle: const TextStyle(color: AppColors.smoke, fontSize: 12),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sending ? _stopGeneration : _sendMessage,
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _sending
                        ? [Colors.red.shade400, Colors.red.shade600]
                        : [AppColors.gold, AppColors.saffron],
                  ),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Icon(
                  _sending ? Icons.stop : Icons.send,
                  color: _sending ? Colors.white : AppColors.midnight,
                  size: 18,
                ),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  // ── Suggestions ─────────────────────────────────────────────────────

  Widget _suggestions() {
    // DB-loaded questions take priority, fallback to hardcoded
    List<String> chips;
    if (_suggestedQuestions.isNotEmpty) {
      chips = _suggestedQuestions.map<String>((q) =>
          (q is Map ? (q['short_label'] ?? q['text'] ?? '') : q).toString()
      ).where((s) => s.isNotEmpty).toList();
    } else {
      // Domain-specific starter questions so every AI specialist opens with
      // helpful prompts even before the DB list loads (covers all 12 agents).
      const samples = <String, List<String>>{
        'career_job': ['Will I get a promotion?', 'Job change kab hoga?', 'Best career field for me?', 'Government job yog?'],
        'business_startup': ['Should I start a business?', 'Best time to launch?', 'Partnership success?', 'Business growth kab?'],
        'education_career': ['Higher studies abroad?', 'Which field to study?', 'Exam success yog?', 'Concentration kaise badhe?'],
        'money_wealth': ['When will wealth increase?', 'Financial growth kab?', 'Best time to invest?', 'Savings improve kaise?'],
        'debt_recovery': ['Will my loan clear?', 'Kab tak debt-free?', 'Money stuck with someone?', 'Recover pending dues?'],
        'love_relationship': ['Will I find love?', 'Relationship mein kya hoga?', 'Is this the right partner?', 'Breakup ya patchup?'],
        'marriage_family': ['Marriage kab hogi?', 'Love or arranged?', 'Family harmony?', 'Childbirth yog?'],
        'health_wellness': ['Health concerns?', 'Swasthya kaisa rahega?', 'Chronic issue relief?', 'Best time for surgery?'],
        'mental_stress': ['Why so much stress?', 'Mann shaant kaise ho?', 'Anxiety kab kam hogi?', 'Peace of mind remedies?'],
        'property_assets': ['Will I buy a house?', 'Property kab milegi?', 'Good time for real estate?', 'Vehicle purchase yog?'],
        'legal_dispute': ['Will I win the case?', 'Court matter kab suljhega?', 'Settle or fight?', 'Property dispute result?'],
        'life_path_luck': ['Is Rajyog in my chart?', 'Bhagya kab chamkega?', 'My life purpose?', 'Lucky period ahead?'],
      };
      chips = samples[_topic.domainKey] ?? ['What does my chart say?', 'Future predictions', 'Best remedies for me?'];
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Wrap(spacing: 6, runSpacing: 6, children: chips.map((c) => GestureDetector(
        onTap: () {
          // For DB questions, send the full text (not just label)
          final fullText = _suggestedQuestions.isNotEmpty
              ? (_suggestedQuestions.firstWhere(
                  (q) => q is Map && ((q['short_label'] ?? q['text'] ?? '') == c),
                  orElse: () => {'text': c},
                ) as Map)['text']?.toString() ?? c
              : c;
          _msgCtrl.text = fullText;
          _sendMessage();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withOpacity(0.2)),
          ),
          child: Text(c, style: const TextStyle(color: AppColors.lavender, fontSize: 11)),
        ),
      )).toList()),
    );
  }

  // ── LLM-generated follow-up question chips ──────────────────────────

  Widget _followupChips() {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.lightbulb_outline, size: 12, color: AppColors.gold),
          const SizedBox(width: 4),
          Text(l.aiSuggestedFollowups, style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
        ]),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6, runSpacing: 6,
          children: _followupSuggestions.map((q) => GestureDetector(
            onTap: _sending ? null : () { _msgCtrl.text = q; _sendMessage(); },
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 32),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.15), AppColors.saffron.withOpacity(0.1)]),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gold.withOpacity(0.35)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Flexible(child: Text(q, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w500))),
                  const SizedBox(width: 4),
                  const Icon(Icons.north_east, size: 10, color: AppColors.gold),
                ]),
              ),
            ),
          )).toList(),
        ),
      ]),
    );
  }

  // ── Message Bubble ──────────────────────────────────────────────────

  Widget _messageBubble(Map<String, dynamic> msg) {
    final isUser = msg['role'] == 'user';
    final text = msg['text']?.toString() ?? '';
    final prob = msg['probability'] as double?;
    final band = msg['band']?.toString();
    final streaming = msg['streaming'] == true;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isUser ? const LinearGradient(colors: [AppColors.gold, AppColors.saffron]) : null,
          color: isUser ? null : AppColors.indigo.withOpacity(0.3),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: isUser ? null : Border.all(color: AppColors.lavender.withOpacity(0.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (prob != null && !isUser) ...[
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: _probColor(prob).withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                child: Text('${prob.toInt()}% $band', style: TextStyle(color: _probColor(prob), fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ]),
            const SizedBox(height: 8),
          ],
          if (text.isNotEmpty)
            isUser
                ? Text(text, style: const TextStyle(
                    color: AppColors.midnight,
                    fontSize: 13, fontWeight: FontWeight.w500, height: 1.4,
                  ))
                // Bot replies are selectable so any portion can be copied,
                // matching ChatGPT / Claude / Gemini.
                : SelectableText(text, style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 13, fontWeight: FontWeight.normal, height: 1.4,
                  )),
          if (streaming && text.isEmpty)
            Row(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold)),
              const SizedBox(width: 6),
              Text(AppLocalizations.of(context)!.aiThinking, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
            ]),
          if (streaming && text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: SizedBox(width: 8, height: 8, child: CircularProgressIndicator(strokeWidth: 1, color: AppColors.gold.withOpacity(0.5))),
            ),
          // Copy + 👍/👎 row on completed bot messages (copy is always
          // available; feedback shows only when the message has an id).
          if (!isUser && !streaming && text.isNotEmpty)
            _feedbackRow(msg, text),
        ]),
      ),
    );
  }

  Widget _feedbackRow(Map<String, dynamic> msg, String text) {
    final rating = (msg['feedback'] as int?) ?? 0;
    final hasId = msg['message_id'] != null;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _copyButton(text),
        if (hasId) ...[
          const SizedBox(width: 6),
          _thumbButton(
            icon: Icons.thumb_up_outlined, iconSelected: Icons.thumb_up,
            active: rating == 1, color: AppColors.success,
            onTap: () => _sendFeedback(msg, 1),
          ),
          const SizedBox(width: 6),
          _thumbButton(
            icon: Icons.thumb_down_outlined, iconSelected: Icons.thumb_down,
            active: rating == -1, color: AppColors.error,
            onTap: () => _sendFeedback(msg, -1),
          ),
          if (rating != 0) ...[
            const SizedBox(width: 8),
            Text(rating == 1 ? AppLocalizations.of(context)!.aiThanks : AppLocalizations.of(context)!.aiFeedbackNoted,
                style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
          ],
        ],
      ]),
    );
  }

  Widget _copyButton(String text) {
    return GestureDetector(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: text));
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.sumCopied),
          duration: const Duration(milliseconds: 1200),
          behavior: SnackBarBehavior.floating,
        ));
      },
      child: Tooltip(
        message: MaterialLocalizations.of(context).copyButtonLabel,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.lavender.withOpacity(0.25)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.copy_rounded, size: 13, color: AppColors.lavender),
            const SizedBox(width: 4),
            Text(MaterialLocalizations.of(context).copyButtonLabel,
                style: const TextStyle(color: AppColors.lavender, fontSize: 10, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    );
  }

  Widget _thumbButton({required IconData icon, required IconData iconSelected,
                       required bool active, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: active ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.18) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: active ? color : AppColors.smoke.withOpacity(0.3), width: 1),
        ),
        child: Icon(active ? iconSelected : icon, size: 13, color: active ? color : AppColors.smoke),
      ),
    );
  }

  Color _probColor(double p) {
    if (p >= 65) return AppColors.success;
    if (p >= 45) return AppColors.aurora;
    if (p >= 30) return AppColors.saffron;
    return AppColors.error;
  }

  static const _langDisplay = {
    'auto':      'Auto',
    'english':   'English',
    'hindi':     'हिंदी',
    'hinglish':  'Hinglish',
    'bengali':   'বাংলা',
    'tamil':     'தமிழ்',
    'telugu':    'తెలుగు',
    'kannada':   'ಕನ್ನಡ',
    'malayalam': 'മലയാളം',
    'gujarati':  'ગુજરાતી',
    'marathi':   'मराठी',
    'punjabi':   'ਪੰਜਾਬੀ',
    'odia':      'ଓଡ଼ିଆ',
  };

  String _displayLang(String code) => _langDisplay[code] ?? code;
}
