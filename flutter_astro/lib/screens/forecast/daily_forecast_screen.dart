import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
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
    final grade = d['day_grade']?.toString() ?? '';
    final summary = d['day_summary']?.toString() ?? '';
    final weekday = d['target_weekday']?.toString() ?? '';
    final targetDate = d['target_date']?.toString() ?? '';
    final actions = (d['key_actions_today'] as List?) ?? [];
    final cautions = (d['key_cautions_today'] as List?) ?? [];
    final houses = (d['house_event_probabilities'] as Map?)?.cast<String, dynamic>() ?? {};
    final flags = (d['critical_event_flags'] as List?) ?? [];
    final confluence = (d['three_layer_confluence'] as Map?)?.cast<String, dynamic>() ?? {};
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
        // Day score hero
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
            if (summary.isNotEmpty) ...[const SizedBox(height: 12),
              Text(summary, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.5))],
          ])),
        // Actions + cautions
        if (actions.isNotEmpty) ...[
          ReportHeader('Key', 'Actions', '${actions.length}'),
          ...actions.take(5).map((a) => Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.06), borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.success.withOpacity(0.2))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('✓ ', style: TextStyle(color: AppColors.success, fontSize: 12)),
              Expanded(child: Text(a.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4))),
            ]))),
        ],
        if (cautions.isNotEmpty) ...[
          ReportHeader('Key', 'Cautions', '${cautions.length}'),
          ...cautions.take(5).map((c) => Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.06), borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.warning.withOpacity(0.2))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('⚠ ', style: TextStyle(color: AppColors.warning, fontSize: 12)),
              Expanded(child: Text(c.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4))),
            ]))),
        ],
        // House probabilities
        if (houses.isNotEmpty) ...[
          ReportHeader('House', 'Probabilities', '12 HOUSES'),
          Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
            child: Column(children: houses.entries.take(12).map((e) {
              final info = e.value is Map ? (e.value as Map).cast<String, dynamic>() : <String, dynamic>{};
              final prob = (info['probability'] as num?)?.toDouble() ?? (e.value is num ? (e.value as num).toDouble() : 0);
              final hc = prob >= 70 ? AppColors.success : prob >= 50 ? AppColors.gold : prob >= 30 ? AppColors.warning : AppColors.error;
              return Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
                SizedBox(width: 50, child: Text(titleCase(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 9))),
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(value: prob / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(hc)))),
                const SizedBox(width: 6),
                SizedBox(width: 28, child: Text('${prob.toStringAsFixed(0)}%', textAlign: TextAlign.right,
                  style: TextStyle(color: hc, fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
              ]));
            }).toList())),
        ],
        // Critical flags
        if (flags.isNotEmpty) ...[
          ReportHeader('Critical', 'Flags', '${flags.length}'),
          ...flags.take(5).map((f) => Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.error.withOpacity(0.06), borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.error.withOpacity(0.2))),
            child: Text(f is Map ? (f as Map)['description']?.toString() ?? f.toString() : f.toString(),
              style: const TextStyle(color: AppColors.ivory, fontSize: 11)))),
        ],
        // Confluence
        if (confluence.isNotEmpty) ...[
          ReportHeader('Three-Layer', 'Confluence', 'SYNTHESIS'),
          Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:
              confluence.entries.where((e) => e.value is String || e.value is num).take(8).map((e) =>
                Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
                  Expanded(child: Text(titleCase(e.key), style: const TextStyle(color: AppColors.smoke, fontSize: 9))),
                  Text(e.value.toString(), textAlign: TextAlign.right,
                    style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w600)),
                ]))).toList())),
        ],
        const SizedBox(height: 30),
      ])),
    ]);
  }
}
