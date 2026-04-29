import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../specialist/report_components.dart';

class DailyForecastScreen extends StatefulWidget {
  final String chartId, chartName;
  const DailyForecastScreen({super.key, required this.chartId, required this.chartName});
  @override
  State<DailyForecastScreen> createState() => _S();
}

class _S extends State<DailyForecastScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _d;
  bool _loading = true;
  String? _error;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final r = await _api.getDailyForecast(widget.chartId);
      if (!mounted) return;
      if (r['statusCode'] == 200 && r['status'] == 'success')
        setState(() { _d = (r['data'] as Map).cast<String, dynamic>(); _loading = false; });
      else setState(() { _error = r['detail']?.toString() ?? 'Failed'; _loading = false; });
    } catch (e) { if (!mounted) return; setState(() { _error = e.toString(); _loading = false; }); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFF0A0A24),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null ? _errV() : _d != null ? _report() : const SizedBox.shrink());
  }

  Widget _errV() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.error_outline, color: AppColors.error, size: 48), const SizedBox(height: 12),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(_error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center)),
    const SizedBox(height: 16), ElevatedButton(onPressed: _load, child: const Text('Retry')),
  ]));

  Widget _report() {
    final d = _d!;
    final dayScore = (d['day_quality_score'] as num?)?.toDouble() ?? 0;
    final dayOverall = (d['day_quality_overall'] as Map?)?.cast<String, dynamic>() ?? {};
    final grade = dayOverall['day_grade']?.toString() ?? d['day_grade']?.toString() ?? '';
    final theme = dayOverall['day_theme']?.toString() ?? '';
    final summary = d['day_summary']?.toString() ?? '';
    final weekday = d['target_weekday']?.toString() ?? '';
    final targetDate = d['target_date']?.toString() ?? '';
    final actions = (d['key_actions_today'] as List?) ?? [];
    final cautions = (d['key_cautions_today'] as List?) ?? [];
    // house_event_probabilities is a DICT keyed "1"-"12"
    final housesRaw = d['house_event_probabilities'];
    final houses = <Map<String, dynamic>>[];
    if (housesRaw is Map) {
      housesRaw.forEach((k, v) { if (v is Map) houses.add(v.cast<String, dynamic>()); });
    }
    final flags = (d['critical_event_flags'] as List?) ?? [];
    final timing = (d['timing_windows'] as Map?)?.cast<String, dynamic>() ?? {};
    final relationships = (d['relationships_today'] as Map?)?.cast<String, dynamic>() ?? {};
    final opportunities = (d['opportunities_vs_risks'] as Map?)?.cast<String, dynamic>() ?? {};
    final income = (d['income_vs_expense'] as Map?)?.cast<String, dynamic>() ?? {};
    final c = dayScore >= 70 ? AppColors.success : dayScore >= 50 ? AppColors.gold : dayScore >= 35 ? AppColors.warning : AppColors.error;

    return CustomScrollView(slivers: [
      SliverAppBar(backgroundColor: const Color(0xFF0A0A24), pinned: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.chartName.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace')),
          Text.rich(TextSpan(children: [
            const TextSpan(text: "Today's ", style: TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w600)),
            TextSpan(text: 'Forecast', style: TextStyle(color: c, fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
          ])),
        ]),
        centerTitle: true, actions: [IconButton(icon: const Icon(Icons.refresh, color: AppColors.ivory, size: 18), onPressed: _load)]),
      SliverList(delegate: SliverChildListDelegate([
        // Day hero
        Container(margin: const EdgeInsets.fromLTRB(16, 12, 16, 12), padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [c.withOpacity(0.15), const Color(0xFF4A3B8C).withOpacity(0.1)]),
            borderRadius: BorderRadius.circular(20), border: Border.all(color: c.withOpacity(0.3))),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 16, height: 1, color: c.withOpacity(0.4)), const SizedBox(width: 6),
              Text('☀ $weekday · $targetDate', style: TextStyle(color: c, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              const SizedBox(width: 6), Container(width: 16, height: 1, color: c.withOpacity(0.4)),
            ]),
            const SizedBox(height: 14),
            SizedBox(width: 100, height: 100, child: Stack(alignment: Alignment.center, children: [
              SizedBox(width: 100, height: 100, child: CircularProgressIndicator(value: dayScore / 100, strokeWidth: 8,
                backgroundColor: Colors.white.withOpacity(0.08), valueColor: AlwaysStoppedAnimation(c))),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text(dayScore.toStringAsFixed(0), style: TextStyle(color: c, fontSize: 28, fontWeight: FontWeight.w700, fontFamily: 'serif')),
                Text(grade, style: TextStyle(color: c, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              ]),
            ])),
            if (theme.isNotEmpty) ...[const SizedBox(height: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Text(theme, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w600)))],
            if (summary.isNotEmpty) ...[const SizedBox(height: 8),
              Text(summary, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.5))],
          ])),
        // Actions
        if (actions.isNotEmpty) ...[
          ReportHeader('Key', 'Actions', '${actions.length}'),
          ...actions.take(6).map((a) => Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.06), borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.success.withOpacity(0.2))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('✓ ', style: TextStyle(color: AppColors.success, fontSize: 12)),
              Expanded(child: Text(a.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4))),
            ]))),
        ],
        // Cautions
        if (cautions.isNotEmpty) ...[
          ReportHeader('Key', 'Cautions', '${cautions.length}'),
          ...cautions.take(6).map((a) => Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.06), borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.warning.withOpacity(0.2))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('⚠ ', style: TextStyle(color: AppColors.warning, fontSize: 12)),
              Expanded(child: Text(a.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4))),
            ]))),
        ],
        // 12 House probabilities
        if (houses.isNotEmpty) ...[
          ReportHeader('12 House', 'Probabilities', '${houses.length} HOUSES'),
          ...houses.map((h) {
            final hNum = h['house']?.toString() ?? '?';
            final domain = h['domain']?.toString() ?? '';
            final sig = h['h${hNum}_event_signature']?.toString() ?? h['event_signature']?.toString() ?? '';
            // Find the main probability score
            final scores = h.entries.where((e) => e.value is num && e.key.contains('probability')).toList();
            final topScore = scores.isNotEmpty ? scores.map((e) => (e.value as num).toDouble()).reduce((a, b) => a > b ? a : b) : 50.0;
            final hc = topScore >= 70 ? AppColors.success : topScore >= 50 ? AppColors.gold : topScore >= 35 ? AppColors.warning : AppColors.error;
            return GestureDetector(
              onTap: () => _showHouseDetail(h, hc),
              child: Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: hc.withOpacity(0.06), borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: hc.withOpacity(0.2))),
                child: Row(children: [
                  Container(width: 30, height: 30, decoration: BoxDecoration(color: hc.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                    child: Center(child: Text('H$hNum', style: TextStyle(color: hc, fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace')))),
                  const SizedBox(width: 8),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(domain, style: const TextStyle(color: AppColors.ivory, fontSize: 10, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (sig.isNotEmpty) Text(sig, style: TextStyle(color: hc, fontSize: 8, fontStyle: FontStyle.italic), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ])),
                  const SizedBox(width: 4),
                  Text('${topScore.toStringAsFixed(0)}%', style: TextStyle(color: hc, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'serif')),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right, size: 12, color: AppColors.smoke),
                ])));
          }),
        ],
        // Income vs expense
        if (income.isNotEmpty) _sectionCard('Income vs Expense', income),
        // Relationships
        if (relationships.isNotEmpty) _sectionCard('Relationships Today', relationships),
        // Opportunities
        if (opportunities.isNotEmpty) _sectionCard('Opportunities vs Risks', opportunities),
        // Timing windows
        if (timing.isNotEmpty) _sectionCard('Timing Windows', timing),
        // Critical flags
        if (flags.isNotEmpty) ...[
          ReportHeader('Critical', 'Flags', '${flags.length}'),
          ...flags.take(5).map((f) {
            final text = f is Map ? (f as Map)['description']?.toString() ?? f.toString() : f.toString();
            return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.error.withOpacity(0.06), borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.error.withOpacity(0.2))),
              child: Text(text, style: const TextStyle(color: AppColors.ivory, fontSize: 11)));
          }),
        ],
        // Confidence
        if (d['confidence_score'] is num) ...[
          ReportHeader('Analysis', 'Confidence', 'QUALITY'),
          ConfidenceBlock(score: (d['confidence_score'] as num).toDouble(),
            statement: d['confidence_explanation']?.toString(),
            breakdown: (d['confidence_breakdown'] is Map) ? (d['confidence_breakdown'] as Map).cast<String, dynamic>() : {}),
        ],
        const SizedBox(height: 30),
      ])),
    ]);
  }

  Widget _sectionCard(String title, Map<String, dynamic> data) {
    final parts = title.split(' ');
    final p1 = parts.first; final p2 = parts.skip(1).join(' ');
    return Column(children: [
      ReportHeader(p1, p2, '${data.length} KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:
          data.entries.where((e) => e.value is String || e.value is num || e.value is bool).take(10).map((e) {
            final v = e.value;
            Color? vc;
            if (v is num) {
              final d = v.toDouble();
              vc = d >= 70 ? AppColors.success : d >= 50 ? AppColors.gold : d >= 30 ? AppColors.warning : AppColors.error;
            }
            return Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
              Expanded(flex: 2, child: Text(_tc(e.key), style: const TextStyle(color: AppColors.smoke, fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 6),
              Flexible(child: Text(v is num ? '${v is double ? v.toStringAsFixed(1) : v}' : v.toString(),
                style: TextStyle(color: vc ?? AppColors.gold, fontSize: 10, fontWeight: FontWeight.w600),
                maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right)),
            ]));
          }).toList())),
    ]);
  }

  void _showHouseDetail(Map<String, dynamic> h, Color c) {
    final hNum = h['house']?.toString() ?? '?';
    final domain = h['domain']?.toString() ?? '';
    showModalBottomSheet(context: context, isScrollControlled: true,
      backgroundColor: const Color(0xFF0A0A24),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7, minChildSize: 0.4, maxChildSize: 0.95, expand: false,
        builder: (_, sc) => ListView(controller: sc, padding: const EdgeInsets.all(16), children: [
          Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
          Text('House $hNum · $domain', style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'serif')),
          const SizedBox(height: 12),
          ...h.entries.where((e) => e.key != 'house' && e.key != 'domain').map((e) {
            if (e.value is num) {
              final v = (e.value as num).toDouble();
              final bc = v >= 70 ? AppColors.success : v >= 50 ? AppColors.gold : v >= 30 ? AppColors.warning : AppColors.error;
              return Padding(padding: const EdgeInsets.only(bottom: 6), child: Column(children: [
                Row(children: [
                  Expanded(child: Text(_tc(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 10))),
                  Text(v.toStringAsFixed(1), style: TextStyle(color: bc, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
                ]),
                ClipRRect(borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(bc))),
              ]));
            }
            if (e.value is String && (e.value as String).isNotEmpty) {
              return Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 90, child: Text(_tc(e.key), style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace'))),
                Expanded(child: Text(e.value.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.3))),
              ]));
            }
            return const SizedBox.shrink();
          }),
        ])));
  }

  static String _tc(String s) => s.replaceAll('_', ' ').split(' ')
    .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
}
