import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';

class AiSpecialistChatScreen extends StatefulWidget {
  final String domainKey;
  final String label;
  final String emoji;

  const AiSpecialistChatScreen({
    super.key,
    required this.domainKey,
    required this.label,
    required this.emoji,
  });

  @override
  State<AiSpecialistChatScreen> createState() => _AiSpecialistChatScreenState();
}

class _AiSpecialistChatScreenState extends State<AiSpecialistChatScreen> {
  final _api = ApiService();
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  List<dynamic> _charts = [];
  List<dynamic> _providers = [];
  String? _selectedChartId;
  String? _selectedChartName;
  String _selectedProvider = 'ollama-7b';
  bool _loadingCharts = true;
  bool _sending = false;
  String _language = 'auto';  // auto-detect by default
  String? _detectedLanguage;    // last detected language from server
  List<String> _followupSuggestions = []; // LLM-generated chips after each reply

  WebSocketChannel? _ws;
  bool _wsConnected = false;

  static const _providerIcons = {
    'ollama-3b': Icons.flash_on,
    'ollama-7b': Icons.memory,
    'groq': Icons.bolt,
    'gemini': Icons.auto_awesome,
    'openrouter': Icons.hub,
    'deepseek': Icons.psychology,
  };

  static const _providerShortNames = {
    'ollama-3b': 'Qwen 3B',
    'ollama-7b': 'Qwen 7B',
    'groq': 'Groq',
    'gemini': 'Gemini',
    'openrouter': 'Router',
    'deepseek': 'DeepSeek',
  };

  @override
  void initState() {
    super.initState();
    _loadCharts();
    _loadProviders();
  }

  Future<void> _loadCharts() async {
    _charts = await _api.getMyCharts(limit: 50);
    if (mounted) setState(() => _loadingCharts = false);
  }

  Future<void> _loadProviders() async {
    _providers = await _api.getAgentProviders();
    if (_providers.isEmpty) {
      _providers = [
        {'key': 'ollama-3b', 'label': 'Qwen 3B (Offline Fast)', 'model': 'qwen2.5:3b', 'available': true},
        {'key': 'ollama-7b', 'label': 'Qwen 7B (Offline Deep)', 'model': 'qwen2.5:7b-instruct-q4_K_M', 'available': true},
      ];
    }
    if (mounted) setState(() {});
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
          _addBotMessage('⚠️ Connection lost. Please try again.');
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
    } else if (type == 'done') {
      if (_messages.isNotEmpty && _messages.last['streaming'] == true) {
        setState(() {
          _messages.last.remove('streaming');
          _sending = false;
        });
      }
    } else if (type == 'error') {
      setState(() => _sending = false);
      _addBotMessage('⚠️ ${msg['text'] ?? 'Something went wrong'}');
    }
  }

  void _selectChart(Map<String, dynamic> chart) {
    setState(() {
      _selectedChartId = chart['id']?.toString();
      _selectedChartName = chart['name']?.toString() ?? 'Chart';
    });
    _connectWs();
    _addBotMessage('${widget.emoji} Welcome! I\'m your **${widget.label}**.\n\nAnalyzing the birth chart of **$_selectedChartName**.\n\nAsk me anything about ${widget.label.toLowerCase()}!');
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
        'query': text,
        'domain': widget.domainKey,
        'language': _language,
        'provider': _selectedProvider,
      }));
    } else {
      try {
        final resp = await _api.agentChat(
          chartId: _selectedChartId!, query: text,
          domain: widget.domainKey, language: _language,
        );
        if (resp['statusCode'] == 200) {
          _addBotMessage(resp['message']?.toString() ?? 'No response',
              probability: (resp['probability'] as num?)?.toDouble(),
              band: resp['band']?.toString());
        } else {
          _addBotMessage('⚠️ ${resp['detail'] ?? 'Something went wrong.'}');
        }
      } catch (e) {
        _addBotMessage('⚠️ Connection error. Please try again.');
      }
      if (mounted) setState(() => _sending = false);
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
    return Scaffold(
      backgroundColor: AppColors.cosmicVoid,
      appBar: AppBar(
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Flexible(child: Text(widget.label, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
        ]),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language, size: 20),
            color: AppColors.nebula,
            tooltip: _language == 'auto'
                ? (_detectedLanguage != null ? 'Auto → ${_displayLang(_detectedLanguage!)}' : 'Auto-detect')
                : 'Language: ${_displayLang(_language)}',
            onSelected: (v) => setState(() => _language = v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'auto',      child: Row(children: [Icon(Icons.auto_fix_high, size: 14), SizedBox(width: 8), Text('🌐 Auto-detect')])),
              PopupMenuDivider(),
              PopupMenuItem(value: 'english',   child: Text('English')),
              PopupMenuItem(value: 'hindi',     child: Text('हिंदी  Hindi')),
              PopupMenuItem(value: 'hinglish',  child: Text('Hinglish')),
              PopupMenuItem(value: 'bengali',   child: Text('বাংলা  Bengali')),
              PopupMenuItem(value: 'tamil',     child: Text('தமிழ்  Tamil')),
              PopupMenuItem(value: 'telugu',    child: Text('తెలుగు  Telugu')),
              PopupMenuItem(value: 'kannada',   child: Text('ಕನ್ನಡ  Kannada')),
              PopupMenuItem(value: 'malayalam', child: Text('മലയാളം  Malayalam')),
              PopupMenuItem(value: 'gujarati',  child: Text('ગુજરાતી  Gujarati')),
              PopupMenuItem(value: 'marathi',   child: Text('मराठी  Marathi')),
              PopupMenuItem(value: 'punjabi',   child: Text('ਪੰਜਾਬੀ  Punjabi')),
            ],
          ),
        ],
      ),
      body: _selectedChartId == null ? _chartSelector() : _chatView(),
    );
  }

  // ── Chart Selector ──────────────────────────────────────────────────

  Widget _chartSelector() {
    if (_loadingCharts) return const Center(child: CircularProgressIndicator(color: AppColors.gold));
    if (_charts.isEmpty) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('\U0001f4dc', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        const Text('No birth charts found', style: TextStyle(color: AppColors.ivory, fontSize: 16)),
        const SizedBox(height: 4),
        const Text('Create a birth chart first to chat with AI', style: TextStyle(color: AppColors.smoke, fontSize: 12)),
      ]));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${widget.emoji} ${widget.label}', style: const TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('Select a birth chart to begin analysis', style: TextStyle(color: AppColors.smoke, fontSize: 12)),
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
                    Text(c['name']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600)),
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
    return Column(children: [
      // Chart info strip
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        color: AppColors.nebula.withOpacity(0.5),
        child: Row(children: [
          const Icon(Icons.auto_awesome, size: 12, color: AppColors.gold),
          const SizedBox(width: 6),
          Text('Analyzing: $_selectedChartName', style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          const Spacer(),
          GestureDetector(
            onTap: () { _ws?.sink.close(); _wsConnected = false; setState(() { _selectedChartId = null; _selectedChartName = null; _messages.clear(); }); },
            child: const Text('Change', style: TextStyle(color: AppColors.smoke, fontSize: 10)),
          ),
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
            const Text('Analyzing your chart...', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
          ]),
        ),
      // Initial sample suggestions (before any chat)
      if (_messages.length <= 1) _suggestions(),
      // LLM-generated follow-up chips (after each bot reply)
      if (_followupSuggestions.isNotEmpty && !_sending) _followupChips(),
      // Input bar with provider selector
      _inputBar(),
    ]);
  }

  // ── Provider Selector + Input ───────────────────────────────────────

  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
      decoration: BoxDecoration(
        color: AppColors.nebula,
        border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.15))),
      ),
      child: SafeArea(
        top: false,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Provider chips row
          SizedBox(
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _providers.where((p) => p['available'] == true).map<Widget>((p) {
                final key = p['key']?.toString() ?? '';
                final shortName = _providerShortNames[key] ?? (p['label']?.toString() ?? key).split(' ').first;
                final selected = key == _selectedProvider;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: _sending ? null : () => setState(() => _selectedProvider = key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.gold.withOpacity(0.2) : Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: selected ? AppColors.gold : AppColors.smoke.withOpacity(0.3)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(_providerIcons[key] ?? Icons.smart_toy, size: 13, color: selected ? AppColors.gold : AppColors.smoke),
                        const SizedBox(width: 4),
                        Text(shortName, style: TextStyle(color: selected ? AppColors.gold : AppColors.smoke, fontSize: 10, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
                      ]),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
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
                  decoration: const InputDecoration(
                    hintText: 'Ask the stars anything...',
                    hintStyle: TextStyle(color: AppColors.smoke, fontSize: 12),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sending ? null : _sendMessage,
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Icon(_sending ? Icons.hourglass_top : Icons.send, color: AppColors.midnight, size: 18),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  // ── Suggestions ─────────────────────────────────────────────────────

  Widget _suggestions() {
    final samples = {
      'career_job': ['Will I get promotion?', 'Job change kab hoga?', 'Career growth'],
      'business_startup': ['Should I start business?', 'Partnership success?'],
      'money_wealth': ['When will wealth increase?', 'Financial growth kab?'],
      'love_relationship': ['Will I find love?', 'Relationship mein kya hoga?'],
      'marriage_family': ['Marriage kab hogi?', 'Family harmony?'],
      'health_wellness': ['Health concerns?', 'Swasthya kaisa rahega?'],
      'life_path_luck': ['Is Rajyog in my chart?', 'Bhagya kab chamkega?'],
    };
    final chips = samples[widget.domainKey] ?? ['What does my chart say?', 'Future predictions'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Wrap(spacing: 6, runSpacing: 6, children: chips.map((c) => GestureDetector(
        onTap: () { _msgCtrl.text = c; _sendMessage(); },
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.lightbulb_outline, size: 12, color: AppColors.gold),
          const SizedBox(width: 4),
          const Text('Suggested follow-ups', style: TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
        ]),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6, runSpacing: 6,
          children: _followupSuggestions.map((q) => GestureDetector(
            onTap: _sending ? null : () { _msgCtrl.text = q; _sendMessage(); },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.15), AppColors.saffron.withOpacity(0.1)]),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold.withOpacity(0.35)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(q, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w500)),
                const SizedBox(width: 4),
                const Icon(Icons.north_east, size: 10, color: AppColors.gold),
              ]),
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
            Text(text, style: TextStyle(
              color: isUser ? AppColors.midnight : AppColors.ivory,
              fontSize: 13, fontWeight: isUser ? FontWeight.w500 : FontWeight.normal, height: 1.4,
            )),
          if (streaming && text.isEmpty)
            Row(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold)),
              const SizedBox(width: 6),
              const Text('Thinking...', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
            ]),
          if (streaming && text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: SizedBox(width: 8, height: 8, child: CircularProgressIndicator(strokeWidth: 1, color: AppColors.gold.withOpacity(0.5))),
            ),
        ]),
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
