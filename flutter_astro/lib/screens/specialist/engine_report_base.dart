import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'report_components.dart';

/// Base class for all dedicated engine report screens.
/// Subclasses only override [buildSections] to define engine-specific layout.
abstract class EngineReportBase extends StatefulWidget {
  final String engineKey, engineLabel, chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const EngineReportBase({super.key, required this.engineKey, required this.engineLabel,
    required this.chartId, required this.chartName, this.preloadedData});
}

abstract class EngineReportBaseState<T extends EngineReportBase> extends State<T> {
  final api = ApiService();
  Map<String, dynamic>? d;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedData != null) { d = widget.preloadedData; loading = false; }
    else load();
  }

  Future<void> load() async {
    setState(() { loading = true; error = null; });
    try {
      final r = await api.runSpecialist(widget.engineKey, widget.chartId);
      if (!mounted) return;
      if (r['statusCode'] == 200 && r['status'] == 'success')
        setState(() { d = (r['data'] as Map).cast<String, dynamic>(); loading = false; });
      else setState(() { error = r['detail']?.toString() ?? 'Failed'; loading = false; });
    } catch (e) { if (!mounted) return; setState(() { error = e.toString(); loading = false; }); }
  }

  /// Override this to define engine-specific sections
  List<Widget> buildSections(Map<String, dynamic> data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFF0A0A24),
      body: loading ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : error != null ? _errV()
          : d != null ? _report() : const SizedBox.shrink());
  }

  Widget _errV() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.error_outline, color: AppColors.error, size: 48), const SizedBox(height: 12),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center)),
    const SizedBox(height: 16), ElevatedButton(onPressed: load, child: const Text('Retry')),
  ]));

  Widget _report() {
    return CustomScrollView(slivers: [
      SliverAppBar(backgroundColor: const Color(0xFF0A0A24), pinned: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.chartName.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace')),
          Text(widget.engineLabel, style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w600)),
        ]),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.refresh, color: AppColors.ivory, size: 18), onPressed: load)],
      ),
      SliverList(delegate: SliverChildListDelegate([
        ...buildSections(d!),
        _confidenceSection(d!),
        _aiBar(d!),
        const SizedBox(height: 30),
      ])),
    ]);
  }

  // ═══ SHARED: Hero Scores ═══
  Widget heroScores(String label, List<List<dynamic>> rings, List<List<dynamic>> minis) {
    final colors = [AppColors.gold, AppColors.aurora, AppColors.cosmicPink];
    return Container(margin: const EdgeInsets.fromLTRB(16, 12, 16, 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.10), AppColors.saffron.withOpacity(0.04)]),
        borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
      child: Column(children: [
        _labelRow(label),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: rings.asMap().entries.map((e) =>
            ScoreRing((e.value[0] as num).toDouble(), e.value[1] as String, colors[e.key % 3])).toList()),
        if (minis.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.2), width: 0.5))),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: minis.map((m) => _miniScore((m[0] as num).toDouble(), m[1] as String)).toList())),
        ],
      ]));
  }

  // ═══ SHARED: Karaka strength table ═══
  Widget karakaTable(Map<String, dynamic> table) {
    if (table.isEmpty) return const SizedBox.shrink();
    final sorted = table.entries.where((e) => e.value is num).toList()
      ..sort((a, b) => (b.value as num).compareTo(a.value as num));
    return Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
      child: Column(children: sorted.take(9).map((e) {
        final v = (e.value as num).toDouble();
        final c = v >= 70 ? AppColors.success : v >= 55 ? AppColors.gold : v >= 40 ? AppColors.warning : AppColors.error;
        return Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
          SizedBox(width: 60, child: Text(e.key, style: const TextStyle(color: AppColors.ivory, fontSize: 10, fontWeight: FontWeight.w600))),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
          const SizedBox(width: 8),
          SizedBox(width: 30, child: Text(v.toStringAsFixed(1), textAlign: TextAlign.right,
            style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
        ]));
      }).toList()));
  }

  // ═══ SHARED: Yoga ledger (creating + clearing) ═══
  Widget yogaLedger(String title, List creating, List clearing, {String creatingLabel = 'PRESSURE', String clearingLabel = 'PROTECTION'}) {
    if (creating.isEmpty && clearing.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader(title.split(' ').first, title.split(' ').skip(1).join(' '), '${creating.length + clearing.length} YOGAS'),
      if (creating.isNotEmpty) ...[
        Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
          child: Text(creatingLabel, style: TextStyle(color: AppColors.error.withOpacity(0.8), fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w600))),
        ...creating.take(5).map((y) => _yogaRow(y, false)),
      ],
      if (clearing.isNotEmpty) ...[
        Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(clearingLabel, style: TextStyle(color: AppColors.success.withOpacity(0.8), fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w600))),
        ...clearing.take(5).map((y) => _yogaRow(y, true)),
      ],
    ]);
  }

  Widget _yogaRow(dynamic y, bool isGood) {
    if (y is! Map) return const SizedBox.shrink();
    final m = (y as Map).cast<String, dynamic>();
    final name = m['name']?.toString() ?? '';
    final score = (m['score'] as num?)?.toDouble() ?? 0;
    final c = isGood ? AppColors.success : AppColors.error;
    return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 4), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Text(isGood ? '✓' : '⚠', style: TextStyle(color: c, fontSize: 11)),
        const SizedBox(width: 8),
        Expanded(child: Text(name, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w600))),
        Text(score.toStringAsFixed(0), style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
      ]));
  }

  // ═══ SHARED: 15-year trend ═══
  Widget yearlyTrend(String title, List trend, {String scoreKey = 'score', String noteKey = 'phase_note'}) {
    if (trend.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader(title.split(' ').first, title.split(' ').skip(1).join(' '), '${trend.length} YEARS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: trend.take(15).map((item) {
          if (item is! Map) return const SizedBox.shrink();
          final m = (item as Map).cast<String, dynamic>();
          final year = m['year']?.toString() ?? '';
          final score = (m[scoreKey] as num?)?.toDouble() ?? (m['fortune'] as num?)?.toDouble() ?? (m['vitality'] as num?)?.toDouble() ?? (m['wellness'] as num?)?.toDouble() ?? (m['favorability'] as num?)?.toDouble() ?? (m['love_intensity'] as num?)?.toDouble() ?? (m['debt_pressure'] as num?)?.toDouble() ?? (m['stress'] as num?)?.toDouble() ?? 50;
          final dasha = m['dasha']?.toString() ?? '';
          final note = m[noteKey]?.toString() ?? m['trend_note']?.toString() ?? m['note']?.toString() ?? m['phase']?.toString() ?? '';
          final isPeak = m['is_peak'] == true || m['is_peak_year'] == true;
          final isDip = m['is_dip_year'] == true || m['is_challenging'] == true || m['is_caution'] == true || m['is_clearance_year'] == true || m['is_debt_peak_year'] == true;
          final c = isPeak ? AppColors.gold : isDip ? AppColors.error : score >= 65 ? AppColors.success : score >= 45 ? AppColors.smoke : AppColors.warning;
          return Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
            SizedBox(width: 32, child: Text(year, style: TextStyle(color: c, fontSize: 10, fontWeight: isPeak || isDip ? FontWeight.w700 : FontWeight.normal, fontFamily: 'monospace'))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: score / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
            const SizedBox(width: 6),
            SizedBox(width: 28, child: Text(score.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
            const SizedBox(width: 6),
            if (isPeak) const Text('★', style: TextStyle(color: AppColors.gold, fontSize: 10))
            else if (isDip) const Text('⚠', style: TextStyle(color: AppColors.error, fontSize: 10))
            else const SizedBox(width: 10),
          ]));
        }).toList())),
    ]);
  }

  // ═══ SHARED: Good/Bad period cards ═══
  Widget periodCards(String goodTitle, List goodPeriods, String badTitle, List badPeriods) {
    if (goodPeriods.isEmpty && badPeriods.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      if (goodPeriods.isNotEmpty) TimingWindowCard(title: goodTitle, icon: '★', color: AppColors.success, items: goodPeriods, isPeak: true),
      if (badPeriods.isNotEmpty) TimingWindowCard(title: badTitle, icon: '⚠', color: AppColors.error, items: badPeriods),
    ]);
  }

  // ═══ SHARED: Stat tiles (2x2 or 3x1) ═══
  Widget statTiles(List<List<dynamic>> tiles) {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(spacing: 8, runSpacing: 8, children: tiles.map((t) {
        final v = (t[0] as num).toDouble();
        final label = t[1] as String;
        final c = v >= 70 ? AppColors.success : v >= 45 ? AppColors.gold : v >= 25 ? AppColors.warning : AppColors.error;
        return SizedBox(width: (MediaQuery.of(context).size.width - 48) / 2,
          child: Container(padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.withOpacity(0.2))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace', letterSpacing: 1)),
              Text(v.toStringAsFixed(1), style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'serif')),
              ClipRRect(borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
            ])));
      }).toList()));
  }

  // ═══ SHARED: Key-value style rows ═══
  Widget styleRows(String title, List<List<dynamic>> rows) {
    final valid = rows.where((r) => r[1] != null && r[1].toString().isNotEmpty).toList();
    if (valid.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader(title.split(' ').first, title.split(' ').skip(1).join(' '), '${valid.length} KEYS'),
      KeyValueBox(rows: { for (var r in valid) r[0] as String : titleCase(r[1].toString()) }),
    ]);
  }

  // ═══ SHARED: Remedies ═══
  Widget remedies(List list) {
    if (list.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader('Astrological', 'Remedies', '${list.length} KEYS'),
      ...list.take(5).map((r) {
        if (r is Map) {
          final m = r.cast<String, dynamic>();
          return RemedyCard(deity: m['deity']?.toString() ?? m['planet']?.toString() ?? '', text: m['remedy']?.toString() ?? m['text']?.toString() ?? '');
        }
        return RemedyCard(deity: '', text: r.toString());
      }),
    ]);
  }

  // ═══ SHARED: Risks ═══
  Widget risks(List list) {
    if (list.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader('Key', 'Risks', '${list.length} ITEMS'),
      ...list.take(5).map((r) {
        if (r is Map) {
          final m = r.cast<String, dynamic>();
          return RiskCard(type: titleCase(m['type']?.toString() ?? 'Risk'), severity: m['severity']?.toString() ?? 'moderate',
            description: m['description']?.toString() ?? '', mitigation: m['mitigation']?.toString());
        }
        return const SizedBox.shrink();
      }),
    ]);
  }

  // ═══ SHARED: Summary/verdict card ═══
  Widget verdictCard(String verdict, String? explanation, {String? subtitle}) {
    if (verdict.isEmpty) return const SizedBox.shrink();
    return Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.1)]),
        borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _labelRow('★ VERDICT ★'),
        const SizedBox(height: 8),
        Text(titleCase(verdict), style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'serif')),
        if (subtitle != null) ...[const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: AppColors.lavender, fontSize: 10, fontStyle: FontStyle.italic))],
        if (explanation != null && explanation.isNotEmpty) ...[const SizedBox(height: 6),
          Text(explanation, style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.4))],
      ]));
  }

  // ═══ SHARED: Chips list ═══
  Widget chipsList(String title, List items, Color color) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
        child: Text(title, style: TextStyle(color: color, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w600))),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(spacing: 6, runSpacing: 6, children: items.take(8).map((i) => InfoChip(i.toString(), color)).toList())),
    ]);
  }

  // ═══ CONFIDENCE ═══
  Widget _confidenceSection(Map<String, dynamic> data) {
    final confScore = data['confidence_score'];
    final confBreakdown = data['confidence_breakdown'];
    final confStatement = data['plain_statement'] ?? data['confidence_explanation'];
    if (confScore == null) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader('Analysis', 'Confidence', 'QUALITY'),
      ConfidenceBlock(score: (confScore as num).toDouble(),
        statement: confStatement?.toString(),
        breakdown: (confBreakdown is Map) ? confBreakdown.cast<String, dynamic>() : {}),
    ]);
  }

  // ═══ AI BAR ═══
  Widget _aiBar(Map<String, dynamic> data) {
    return Container(margin: const EdgeInsets.fromLTRB(16, 16, 16, 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF1A1642).withOpacity(0.8), const Color(0xFF0A0A24)]),
        borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
      child: Column(children: [
        _labelRow('★ DISCUSS WITH AI ★'), const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _aiBtn('G', 'ChatGPT', const LinearGradient(colors: [Color(0xFF10A37F), Color(0xFF1A7F64)]), () => _launchAi(data, 'chatgpt'))),
          const SizedBox(width: 8),
          Expanded(child: _aiBtn('C', 'Claude', const LinearGradient(colors: [Color(0xFFD97757), Color(0xFFB85B3F)]), () => _launchAi(data, 'claude'))),
          const SizedBox(width: 8),
          Expanded(child: _aiBtn('✦', 'Gemini', const LinearGradient(colors: [Color(0xFF4285F4), Color(0xFF9B72CB)]), () => _launchAi(data, 'gemini'))),
        ]),
        const SizedBox(height: 10),
        GestureDetector(onTap: () { Clipboard.setData(ClipboardData(text: _prompt(data)));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report copied!'))); },
          child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.copy, size: 14, color: AppColors.smoke), SizedBox(width: 6),
              Text('Copy full report data', style: TextStyle(color: AppColors.smoke, fontSize: 10))]))),
      ]));
  }

  Widget _aiBtn(String icon, String name, Gradient g, VoidCallback onTap) => GestureDetector(onTap: onTap,
    child: Container(padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.2))),
      child: Column(children: [
        Container(width: 26, height: 26, decoration: BoxDecoration(gradient: g, borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(icon, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)))),
        const SizedBox(height: 5), Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 9, fontWeight: FontWeight.w700)),
        const Text('OPEN ↗', style: TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace')),
      ])));

  String _prompt(Map data) {
    final j = const JsonEncoder.withIndent('  ').convert(data);
    return 'You are a Vedic ${widget.engineLabel} advisor. Analyze this report for ${widget.chartName}.\n\nFull JSON:\n$j\n\nExplain key findings and suggest next steps.';
  }

  Future<void> _launchAi(Map data, String ai) async {
    await Clipboard.setData(ClipboardData(text: _prompt(data)));
    final urls = {'chatgpt': 'https://chat.openai.com/', 'claude': 'https://claude.ai/new', 'gemini': 'https://gemini.google.com/app'};
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied! Opening $ai...'), duration: const Duration(seconds: 3)));
    final uri = Uri.parse(urls[ai]!); if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // ═══ HELPERS ═══
  double n(Map d, String k) => (d[k] as num?)?.toDouble() ?? 0;

  Widget _miniScore(double v, String label) => Column(children: [
    Text(v.toStringAsFixed(1), style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
    Text(label, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace', height: 1.2)),
  ]);

  Widget _labelRow(String text) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)), const SizedBox(width: 6),
    Text(text, style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
    const SizedBox(width: 6), Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)),
  ]);
}
