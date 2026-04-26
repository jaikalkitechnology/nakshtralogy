import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class SpecialistReportScreen extends StatefulWidget {
  final String specialistKey, specialistLabel, specialistEmoji, chartId, chartName;
  final Map<String, dynamic>? preloadedData;

  const SpecialistReportScreen({super.key, required this.specialistKey,
    required this.specialistLabel, required this.specialistEmoji,
    required this.chartId, required this.chartName, this.preloadedData});

  SpecialistReportScreen.fromData({super.key,
    required this.specialistLabel, required this.specialistEmoji,
    required this.chartName, required Map<String, dynamic> data})
      : specialistKey = '', chartId = '', preloadedData = data;

  @override
  State<SpecialistReportScreen> createState() => _ReportState();
}

class _ReportState extends State<SpecialistReportScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedData != null) { _data = widget.preloadedData; _loading = false; }
    else { _load(); }
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = await _api.runSpecialist(widget.specialistKey, widget.chartId);
      if (!mounted) return;
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        setState(() { _data = (resp['data'] as Map).cast<String, dynamic>(); _loading = false; });
      } else {
        setState(() { _error = resp['detail']?.toString() ?? 'Analysis failed'; _loading = false; });
      }
    } catch (e) { if (!mounted) return; setState(() { _error = e.toString(); _loading = false; }); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('${widget.specialistEmoji} ${widget.specialistLabel}',
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
          Text(widget.chartName, style: const TextStyle(color: AppColors.primary, fontSize: 11)),
        ]),
        actions: [if (widget.specialistKey.isNotEmpty) IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? _errorView()
              : _data != null ? _SmartReport(data: _data!) : const SizedBox.shrink(),
    );
  }

  Widget _errorView() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.error_outline, color: AppColors.error, size: 48),
    const SizedBox(height: 12),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(_error!, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center)),
    const SizedBox(height: 16),
    ElevatedButton(onPressed: _load, child: const Text('Retry')),
  ]));
}

// ═══════════════════════════════════════════════════════════════════
// Smart report renderer — detects content type and renders cleanly
// ═══════════════════════════════════════════════════════════════════
class _SmartReport extends StatelessWidget {
  final Map<String, dynamic> data;
  const _SmartReport({required this.data});

  static const _summaryKeys = {'human_summary', 'actionable_advice', 'human_readable',
    'one_liner_advice', 'advice', 'relationship_summary_text', 'core_group_theme_text'};
  static const _confidenceKeys = {'confidence_score', 'confidence', 'confidence_pct'};
  static const _skipKeys = {'version', 'disclaimer', 'domain', '_schema_valid',
    '_schema_violations', 'computation_errors', 'name', 'intelligence_disclaimer',
    'chart_count', 'relationship_context'};

  @override
  Widget build(BuildContext context) {
    // 1. Extract summary texts
    final summaries = <String>[];
    for (final k in _summaryKeys) {
      final v = data[k];
      if (v is String && v.isNotEmpty) summaries.add(v);
    }

    // 2. Extract confidence
    double? confidence;
    String? confExplanation;
    for (final k in _confidenceKeys) {
      if (data[k] is num) {
        final raw = (data[k] as num).toDouble();
        confidence = raw <= 1.0 ? raw * 100 : raw;
      }
    }
    if (data['confidence_explanation'] is String) confExplanation = data['confidence_explanation'].toString();

    // 3. Collect key scores (top-level numeric _score fields, max 6)
    final scores = <_ScoreEntry>[];
    for (final e in data.entries) {
      if (_skipKeys.contains(e.key) || _summaryKeys.contains(e.key) || _confidenceKeys.contains(e.key)) continue;
      if (e.value is num && _isScore(e.key)) {
        final raw = (e.value as num).toDouble();
        final display = (e.key.contains('confidence') && raw <= 1.0) ? raw * 100 : raw;
        scores.add(_ScoreEntry(e.key, display.clamp(0, 100).toDouble()));
      }
    }

    // 4. Collect sections (maps, lists, long strings)
    final sections = <_Section>[];
    for (final e in data.entries) {
      if (_skipKeys.contains(e.key) || _summaryKeys.contains(e.key) || _confidenceKeys.contains(e.key)) continue;
      if (e.value is num && _isScore(e.key)) continue;
      if (e.value is Map && (e.value as Map).isNotEmpty) {
        sections.add(_Section(e.key, e.value));
      } else if (e.value is List && (e.value as List).isNotEmpty) {
        sections.add(_Section(e.key, e.value));
      } else if (e.value is String && (e.value as String).length >= 80) {
        sections.add(_Section(e.key, e.value));
      } else if (e.value is String && (e.value as String).isNotEmpty && !_isScore(e.key)) {
        sections.add(_Section(e.key, e.value));
      }
    }

    return ListView(padding: const EdgeInsets.all(16), children: [
      // ── Confidence badge ──
      if (confidence != null) _confidenceBadge(confidence, confExplanation),
      if (confidence != null) const SizedBox(height: 14),

      // ── Summary card ──
      if (summaries.isNotEmpty) _summaryCard(summaries),
      if (summaries.isNotEmpty) const SizedBox(height: 14),

      // ── Key scores (max 6, clean grid) ──
      if (scores.isNotEmpty) _scoresSection(scores.take(6).toList()),
      if (scores.isNotEmpty) const SizedBox(height: 14),

      // ── Remaining scores (collapsed) ──
      if (scores.length > 6) _moreScores(scores.skip(6).toList()),
      if (scores.length > 6) const SizedBox(height: 14),

      // ── Content sections ──
      ...sections.map((s) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _renderSection(s),
      )),
      const SizedBox(height: 24),
    ]);
  }

  Widget _confidenceBadge(double pct, String? explanation) {
    final color = pct >= 75 ? Colors.green : pct >= 50 ? Colors.blue : Colors.orange;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.12), Colors.transparent]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(children: [
        SizedBox(width: 52, height: 52, child: Stack(alignment: Alignment.center, children: [
          CircularProgressIndicator(value: pct / 100, strokeWidth: 4,
            backgroundColor: Colors.white12, valueColor: AlwaysStoppedAnimation(color)),
          Text('${pct.toStringAsFixed(0)}%', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
        ])),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Analysis Confidence', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)),
          if (explanation != null) ...[
            const SizedBox(height: 3),
            Text(explanation, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11), maxLines: 3, overflow: TextOverflow.ellipsis),
          ],
        ])),
      ]),
    );
  }

  Widget _summaryCard(List<String> texts) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primary.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
          SizedBox(width: 8),
          Text('Summary', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 10),
        ...texts.map((t) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(t, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, height: 1.5)),
        )),
      ]),
    );
  }

  Widget _scoresSection(List<_ScoreEntry> scores) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Key Scores', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      ...scores.map((s) => _scoreRow(s)),
    ]);
  }

  Widget _scoreRow(_ScoreEntry s) {
    final color = s.value >= 70 ? Colors.green : s.value >= 45 ? Colors.amber : s.value >= 25 ? Colors.orange : Colors.red;
    final label = _fmt(s.key);
    final grade = s.value >= 80 ? 'Excellent' : s.value >= 65 ? 'Good'
        : s.value >= 50 ? 'Moderate' : s.value >= 35 ? 'Below Avg' : 'Needs Attention';
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
      SizedBox(width: 36, height: 36, child: Stack(alignment: Alignment.center, children: [
        CircularProgressIndicator(value: s.value / 100, strokeWidth: 3,
          backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(color)),
        Text('${s.value.toStringAsFixed(0)}', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
      ])),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
        Text(grade, style: TextStyle(color: color, fontSize: 10)),
      ])),
      Container(
        width: 80,
        child: ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: s.value / 100, minHeight: 6,
            backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(color))),
      ),
    ]));
  }

  Widget _moreScores(List<_ScoreEntry> scores) {
    return _ExpandCard(title: 'All Scores (${scores.length} more)', icon: Icons.bar_chart,
      child: Column(children: scores.map((s) => _scoreRow(s)).toList()));
  }

  Widget _renderSection(_Section s) {
    if (s.value is String) return _textSection(s.key, s.value as String);
    if (s.value is List) return _listSection(s.key, s.value as List);
    if (s.value is Map) return _mapSection(s.key, (s.value as Map).cast<String, dynamic>());
    return const SizedBox.shrink();
  }

  Widget _textSection(String key, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_fmt(key), style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, height: 1.5)),
      ]),
    );
  }

  Widget _listSection(String key, List items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return _ExpandCard(title: '${_fmt(key)} (${items.length})', icon: Icons.list,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:
        items.take(15).map<Widget>((item) {
          if (item is Map) return _mapTile(item.cast<String, dynamic>());
          return Padding(padding: const EdgeInsets.only(bottom: 4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('•  ', style: TextStyle(color: AppColors.primary, fontSize: 11)),
              Expanded(child: Text(item.toString(), style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, height: 1.4))),
            ]));
        }).toList()));
  }

  Widget _mapSection(String key, Map<String, dynamic> map) {
    final innerScores = <_ScoreEntry>[];
    final innerTexts = <MapEntry<String, String>>[];
    final innerLists = <MapEntry<String, List>>[];
    final innerMaps = <MapEntry<String, Map>>[];

    for (final e in map.entries) {
      if (e.value is num && _isScore(e.key)) {
        final raw = (e.value as num).toDouble();
        final v = (e.key.contains('confidence') && raw <= 1.0) ? raw * 100 : raw;
        innerScores.add(_ScoreEntry(e.key, v.clamp(0, 100).toDouble()));
      } else if (e.value is String && (e.value as String).isNotEmpty) {
        innerTexts.add(MapEntry(e.key, e.value.toString()));
      } else if (e.value is List && (e.value as List).isNotEmpty) {
        innerLists.add(MapEntry(e.key, e.value as List));
      } else if (e.value is Map && (e.value as Map).isNotEmpty) {
        innerMaps.add(MapEntry(e.key, e.value as Map));
      }
    }

    return _ExpandCard(
      title: _fmt(key),
      icon: Icons.folder_open,
      topScore: innerScores.isNotEmpty ? innerScores.first.value : null,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (innerScores.isNotEmpty) ...innerScores.take(5).map((s) => _scoreRow(s)),
        if (innerTexts.isNotEmpty) ...innerTexts.take(10).map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_fmt(e.key), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(e.value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, height: 1.4),
                maxLines: 6, overflow: TextOverflow.ellipsis),
          ]))),
        if (innerLists.isNotEmpty) ...innerLists.take(3).map((e) => Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 4),
            Text(_fmt(e.key), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
            ...e.value.take(5).map<Widget>((item) => Padding(padding: const EdgeInsets.only(left: 8, top: 3),
              child: item is Map
                  ? _mapTile(item.cast<String, dynamic>())
                  : Text('•  $item', style: const TextStyle(color: AppColors.textPrimary, fontSize: 10, height: 1.3)))),
          ])),
        if (innerMaps.isNotEmpty) ...innerMaps.take(3).map((e) => Padding(
          padding: const EdgeInsets.only(top: 8),
          child: _mapSection(e.key, e.value.cast<String, dynamic>()))),
      ]),
    );
  }

  Widget _mapTile(Map<String, dynamic> item) {
    final title = item['name'] ?? item['factor'] ?? item['type'] ?? item['planet'] ?? '';
    final score = item.entries.where((e) => e.value is num && _isScore(e.key)).map((e) => (e.value as num).toDouble()).toList();
    final texts = item.entries.where((e) => e.value is String && e.key != 'name' && e.key != 'factor' && e.key != 'type')
        .map((e) => '${_fmt(e.key)}: ${e.value}').take(3).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (title.toString().isNotEmpty) Row(children: [
          Expanded(child: Text(title.toString(), style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w600))),
          if (score.isNotEmpty) Text('${score.first.clamp(0, 100).toStringAsFixed(0)}%',
              style: TextStyle(color: score.first >= 65 ? Colors.green : score.first >= 40 ? Colors.amber : Colors.red,
                  fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
        ...texts.map((t) => Text(t, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10), maxLines: 2, overflow: TextOverflow.ellipsis)),
      ]),
    );
  }

  static String _fmt(String key) => key.replaceAll('_', ' ').split(' ')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  static bool _isScore(String k) =>
      k.endsWith('_score') || k.endsWith('_pct') || k.endsWith('_percentage') ||
      k.contains('confidence') || k.contains('probability') || k.contains('_index');
}

class _ScoreEntry {
  final String key;
  final double value;
  const _ScoreEntry(this.key, this.value);
}

class _Section {
  final String key;
  final dynamic value;
  const _Section(this.key, this.value);
}

class _ExpandCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final double? topScore;
  final Widget child;
  const _ExpandCard({required this.title, required this.icon, this.topScore, required this.child});

  @override
  State<_ExpandCard> createState() => _ExpandCardState();
}

class _ExpandCardState extends State<_ExpandCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.topScore != null
        ? (widget.topScore! >= 70 ? Colors.green : widget.topScore! >= 45 ? Colors.amber : Colors.orange)
        : AppColors.primary;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [c.withOpacity(0.06), Colors.transparent]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withOpacity(0.15))),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          borderRadius: BorderRadius.circular(12),
          child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [
            Icon(widget.icon, color: c, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(widget.title, style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w700))),
            if (widget.topScore != null) ...[
              Text('${widget.topScore!.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(width: 4),
            ],
            Icon(_open ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary, size: 20),
          ])),
        ),
        if (_open) ...[
          const Divider(color: Colors.white10, height: 1),
          Padding(padding: const EdgeInsets.all(12), child: widget.child),
        ],
      ]),
    );
  }
}
