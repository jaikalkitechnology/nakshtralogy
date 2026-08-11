import 'package:flutter/material.dart';
import '../../widgets/desktop_center.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'report_components.dart';

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
  State<SpecialistReportScreen> createState() => _State();
}

class _State extends State<SpecialistReportScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  static const _skip = {'version','disclaimer','domain','_schema_valid','_schema_violations',
    'computation_errors','name','intelligence_disclaimer','chart_count','relationship_context'};

  @override
  void initState() {
    super.initState();
    if (widget.preloadedData != null) { _data = widget.preloadedData; _loading = false; }
    else _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = await _api.runSpecialist(widget.specialistKey, widget.chartId);
      if (!mounted) return;
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        setState(() { _data = (resp['data'] as Map).cast<String, dynamic>(); _loading = false; });
      } else { setState(() { _error = resp['detail']?.toString() ?? 'Failed'; _loading = false; }); }
    } catch (e) { if (!mounted) return; setState(() { _error = e.toString(); _loading = false; }); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFF0A0A24),
      body: DesktopCenter(maxWidth: 1000, child: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null ? _errView()
          : _data != null ? _report() : const SizedBox.shrink()));
  }

  Widget _errView() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.error_outline, color: AppColors.error, size: 48), const SizedBox(height: 12),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(_error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center)),
    const SizedBox(height: 16), ElevatedButton(onPressed: _load, child: Text(AppLocalizations.of(context)?.retry ?? 'Retry')),
  ]));

  Widget _report() {
    final d = _data!;
    // ── Classify data ──
    final scores = <String, double>{}; final summaries = <String, String>{};
    final sections = <String, dynamic>{}; final lists = <String, List>{};

    for (final e in d.entries) {
      if (_skip.contains(e.key)) continue;
      if (e.value is num && _isScore(e.key)) {
        double v = (e.value is num ? e.value as num : 0).toDouble();
        if (e.key.contains('confidence') && v <= 1.0) v *= 100;
        scores[e.key] = v;
      } else if (e.value is String && (e.value as String).isNotEmpty) {
        final s = e.value as String;
        if (_isSummaryKey(e.key) || s.length >= 60) summaries[e.key] = s;
        else summaries[e.key] = s;
      } else if (e.value is Map && (e.value as Map).isNotEmpty) {
        sections[e.key] = e.value;
      } else if (e.value is List && (e.value as List).isNotEmpty) {
        lists[e.key] = e.value as List;
      }
    }

    // ── Separate top scores (max 6) from rest ──
    final sortedScores = scores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topScores = sortedScores.take(6).toList();
    final otherScores = sortedScores.skip(6).toList();

    // ── Detect special keys ──
    final confScore = d['confidence_score'];
    final confBreakdown = d['confidence_breakdown'];
    final confStatement = d['plain_statement'] ?? d['confidence_explanation'];

    return CustomScrollView(slivers: [
      // App bar
      SliverAppBar(backgroundColor: const Color(0xFF0A0A24), pinned: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.chartName.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace')),
          Text.rich(TextSpan(children: [
            TextSpan(text: '${widget.specialistEmoji} ', style: const TextStyle(fontSize: 16)),
            TextSpan(text: widget.specialistLabel, style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w600)),
          ])),
        ]),
        centerTitle: true,
        actions: [if (widget.specialistKey.isNotEmpty) IconButton(icon: const Icon(Icons.refresh, color: AppColors.ivory, size: 18), onPressed: _load)],
      ),
      SliverList(delegate: SliverChildListDelegate([
        // ── Hero scores ──
        if (topScores.isNotEmpty) _heroSection(topScores),
        // ── Summary texts ──
        if (summaries.isNotEmpty) _summarySection(summaries),
        // ── Remaining scores ──
        if (otherScores.isNotEmpty) _otherScoresSection(otherScores),
        // ── Sections (maps) ──
        ...sections.entries.map((e) => _mapSection(e.key, (e.value as Map).cast<String, dynamic>())),
        // ── Lists ──
        ...lists.entries.map((e) => _listSection(e.key, e.value)),
        // ── Confidence ──
        if (confScore != null) ...[
          ReportHeader('Analysis', 'Confidence', 'QUALITY'),
          ConfidenceBlock(score: (confScore is num ? confScore as num : 0).toDouble(),
            statement: confStatement?.toString(),
            breakdown: (confBreakdown is Map) ? confBreakdown.cast<String, dynamic>() : {}),
        ],
        const SizedBox(height: 80),
      ])),
    ]);
  }

  Widget _heroSection(List<MapEntry<String, double>> top) {
    final mainRings = top.take(3).toList();
    final miniScores = top.skip(3).toList();
    final colors = [AppColors.gold, AppColors.aurora, AppColors.cosmicPink, AppColors.lavender, AppColors.saffron, AppColors.success];

    return Container(margin: const EdgeInsets.fromLTRB(16, 12, 16, 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.10), AppColors.saffron.withOpacity(0.04)]),
        borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 1, height: 8, color: AppColors.gold.withOpacity(0.4)), const SizedBox(width: 6),
          const Text('KEY SCORES', style: TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(width: 6), Container(width: 1, height: 8, color: AppColors.gold.withOpacity(0.4)),
        ]),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: mainRings.asMap().entries.map((e) =>
            ScoreRing(e.value.value, _shortLabel(e.value.key), colors[e.key % colors.length])).toList()),
        if (miniScores.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.2), width: 0.5))),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: miniScores.map((e) => Column(children: [
                Text(e.value.toStringAsFixed(1), style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
                Text(_shortLabel(e.key), style: const TextStyle(color: AppColors.smoke, fontSize: 7, letterSpacing: 1, fontFamily: 'monospace')),
              ])).toList())),
        ],
      ]));
  }

  Widget _summarySection(Map<String, String> texts) {
    final important = texts.entries.where((e) => _isSummaryKey(e.key) || (e.value).length >= 60).toList();
    final meta = texts.entries.where((e) => !_isSummaryKey(e.key) && (e.value).length < 60).toList();

    return Column(children: [
      if (important.isNotEmpty) Container(margin: const EdgeInsets.fromLTRB(16, 4, 16, 8), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.06), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ...important.take(4).map((e) => Padding(padding: const EdgeInsets.only(bottom: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(titleCase(e.key).toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(e.value, style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.5)),
            ]))),
        ])),
      if (meta.isNotEmpty) Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 8), padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(10)),
        child: Wrap(spacing: 12, runSpacing: 6, children: meta.take(8).map((e) =>
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text('${titleCase(e.key)}: ', style: const TextStyle(color: AppColors.smoke, fontSize: 9)),
            Flexible(child: Text(e.value, style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w600),
              maxLines: 1, overflow: TextOverflow.ellipsis)),
          ])).toList())),
    ]);
  }

  Widget _otherScoresSection(List<MapEntry<String, double>> scores) {
    return _ExpandSection(title: 'All Scores (${scores.length})',
      child: Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
        child: Column(children: scores.map((e) {
          final c = e.value >= 70 ? AppColors.success : e.value >= 45 ? AppColors.gold : e.value >= 25 ? const Color(0xFFE5A93A) : AppColors.error;
          return Padding(padding: const EdgeInsets.only(bottom: 6), child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Flexible(child: Text(titleCase(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 10))),
              Text('${e.value.toStringAsFixed(0)}', style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
            ]),
            const SizedBox(height: 3),
            ClipRRect(borderRadius: BorderRadius.circular(2), child: LinearProgressIndicator(
              value: (e.value / 100).clamp(0, 1), minHeight: 3,
              backgroundColor: Colors.white.withOpacity(0.06), valueColor: AlwaysStoppedAnimation(c))),
          ]));
        }).toList())));
  }

  Widget _mapSection(String key, Map<String, dynamic> map) {
    // Auto-detect risks
    if (_isRiskList(key, map)) return const SizedBox.shrink();

    final innerScores = <String, double>{};
    final innerTexts = <String, String>{};
    final innerLists = <String, List>{};

    for (final e in map.entries) {
      if (e.value is num && _isScore(e.key)) {
        double v = (e.value is num ? e.value as num : 0).toDouble();
        if (e.key.contains('confidence') && v <= 1.0) v *= 100;
        innerScores[e.key] = v;
      } else if (e.value is String && (e.value as String).isNotEmpty) {
        innerTexts[e.key] = e.value.toString();
      } else if (e.value is List && (e.value as List).isNotEmpty) {
        innerLists[e.key] = e.value as List;
      }
    }

    if (innerScores.isEmpty && innerTexts.isEmpty && innerLists.isEmpty) return const SizedBox.shrink();

    return _ExpandSection(title: titleCase(key), topScore: innerScores.values.isNotEmpty ? innerScores.values.first : null,
      child: Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ...innerScores.entries.take(6).map((e) {
            final c = e.value >= 70 ? AppColors.success : e.value >= 45 ? AppColors.gold : AppColors.error;
            return Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
              Expanded(child: Text(titleCase(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 10))),
              Text('${e.value.toStringAsFixed(0)}', style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
            ]));
          }),
          ...innerTexts.entries.take(6).map((e) => Padding(padding: const EdgeInsets.only(bottom: 6),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(titleCase(e.key), style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace')),
              const SizedBox(height: 2),
              Text(e.value, style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4), maxLines: 4, overflow: TextOverflow.ellipsis),
            ]))),
          ...innerLists.entries.take(3).map((e) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(titleCase(e.key), style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace')),
            ...e.value.take(5).map<Widget>((item) {
              if (item is Map) return _mapTile(item.cast<String, dynamic>());
              return Text('•  $item', style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4));
            }),
          ])),
        ])));
  }

  Widget _listSection(String key, List items) {
    // Auto-detect risk/remedy/timing lists
    if (items.isNotEmpty && items.first is Map) {
      final first = (items.first as Map).cast<String, dynamic>();
      if (first.containsKey('severity') || first.containsKey('risk_level')) {
        return Column(children: [
          ReportHeader(titleCase(key.split('_').first), titleCase(key.split('_').skip(1).join(' ')), '${items.length}'),
          ...items.take(5).map((r) {
            final risk = (r as Map).cast<String, dynamic>();
            return RiskCard(type: titleCase(risk['type']?.toString() ?? ''),
              severity: risk['severity']?.toString() ?? 'low',
              description: risk['description']?.toString() ?? '',
              mitigation: risk['mitigation']?.toString());
          }),
        ]);
      }
      if (first.containsKey('deity') || first.containsKey('remedy')) {
        return Column(children: [
          ReportHeader('Astrological', 'Remedies', '${items.length}'),
          ...items.take(6).map((r) {
            final rem = (r as Map).cast<String, dynamic>();
            return RemedyCard(deity: rem['deity']?.toString() ?? '', text: rem['remedy']?.toString() ?? rem['text']?.toString() ?? '');
          }),
        ]);
      }
      if (first.containsKey('window') || first.containsKey('dasha') || first.containsKey('start')) {
        return Column(children: [
          ReportHeader(titleCase(key.split('_').first), 'Windows', '${items.length}'),
          TimingWindowCard(title: titleCase(key), icon: '→', color: AppColors.aurora, items: items),
        ]);
      }
    }

    // Generic list
    return _ExpandSection(title: '${titleCase(key)} (${items.length})',
      child: Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: items.take(10).map<Widget>((item) {
          if (item is Map) return _mapTile(item.cast<String, dynamic>());
          return Padding(padding: const EdgeInsets.only(bottom: 4),
            child: Text('•  $item', style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4)));
        }).toList())));
  }

  Widget _mapTile(Map<String, dynamic> item) {
    final title = item['name'] ?? item['factor'] ?? item['type'] ?? item['planet'] ?? item['category'] ?? '';
    final desc = item['description'] ?? item['advice'] ?? item['text'] ?? item['note'] ?? item['remedy'] ?? '';
    final score = item.entries.where((e) => e.value is num && _isScore(e.key)).map((e) => (e.value is num ? e.value as num : 0).toDouble()).toList();

    return Container(margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (title.toString().isNotEmpty) Row(children: [
          Expanded(child: Text(title.toString(), style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'serif'))),
          if (score.isNotEmpty) Text('${score.first.clamp(0, 100).toStringAsFixed(0)}%',
            style: TextStyle(color: score.first >= 65 ? AppColors.success : score.first >= 40 ? AppColors.gold : AppColors.error,
              fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
        ]),
        if (desc.toString().isNotEmpty) Padding(padding: const EdgeInsets.only(top: 3),
          child: Text(desc.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4),
            maxLines: 3, overflow: TextOverflow.ellipsis)),
      ]));
  }

  // ── Helpers ──
  static bool _isScore(String k) => k.endsWith('_score') || k.endsWith('_pct') || k.endsWith('_percentage')
      || k.contains('confidence') || k.contains('probability') || k.contains('_index');
  static bool _isSummaryKey(String k) => const {'human_summary','actionable_advice','human_readable',
    'one_liner_advice','advice','core_theme','verdict','overall_verdict','career_verdict_explanation',
    'recommendation','primary_direction','soul_career_integration_strategy'}.contains(k);
  static bool _isRiskList(String k, Map m) => false;

  static String _shortLabel(String key) {
    return key.replaceAll('_score', '').replaceAll('_pct', '').replaceAll('overall_', '')
      .replaceAll('career_', '').replaceAll('_percentage', '').toUpperCase().replaceAll('_', '\n');
  }
}

class _ExpandSection extends StatefulWidget {
  final String title;
  final double? topScore;
  final Widget child;
  const _ExpandSection({required this.title, this.topScore, required this.child});

  @override
  State<_ExpandSection> createState() => _ExpandSectionState();
}

class _ExpandSectionState extends State<_ExpandSection> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.topScore != null
      ? (widget.topScore! >= 70 ? AppColors.success : widget.topScore! >= 45 ? AppColors.gold : const Color(0xFFE5A93A))
      : AppColors.gold;
    return Column(children: [
      InkWell(onTap: () => setState(() => _open = !_open),
        child: Padding(padding: const EdgeInsets.fromLTRB(16, 10, 16, 6), child: Row(children: [
          Expanded(child: Text(widget.title, style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'serif'))),
          if (widget.topScore != null) Text('${widget.topScore!.toStringAsFixed(0)}',
            style: TextStyle(color: c, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif')),
          const SizedBox(width: 4),
          Icon(_open ? Icons.expand_less : Icons.expand_more, color: AppColors.smoke, size: 20),
        ]))),
      if (_open) widget.child,
      if (_open) const SizedBox(height: 8),
    ]);
  }
}
