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
    final header = (d['day_header'] as Map?)?.cast<String, dynamic>() ?? {};
    final grade = (d['day_grade'] as Map?)?.cast<String, dynamic>() ?? {};
    final score = (grade['day_score'] as num?)?.toDouble() ?? 0;
    final gradeLabel = grade['day_grade']?.toString() ?? '';
    final weekday = header['weekday']?.toString() ?? '';
    final dateStr = header['date']?.toString() ?? '';
    final vara = header['vara']?.toString() ?? '';
    final tithi = header['tithi']?.toString() ?? '';
    final nak = header['nakshatra']?.toString() ?? '';
    final sunrise = header['sunrise']?.toString() ?? '';
    final sunset = header['sunset']?.toString() ?? '';
    final rahuKaal = header['rahu_kaal']?.toString() ?? '';
    final moola = 'MD=${header['moola_dasha_md'] ?? "?"} · AD=${header['moola_dasha_ad'] ?? "?"} · PD=${header['moola_dasha_pd'] ?? "?"}';
    final favorable = (d['favorable_fields'] as List?) ?? [];
    final challenging = (d['challenging_fields'] as List?) ?? [];
    final doToday = (d['do_today'] as List?) ?? [];
    final avoidToday = (d['avoid_today'] as List?) ?? [];
    final hourly = (d['hourly_windows'] as Map?)?.cast<String, dynamic>() ?? {};
    final alerts = (d['alerts'] as List?) ?? [];
    final cgm = (d['color_gemstone_mantra'] as Map?)?.cast<String, dynamic>() ?? {};
    final summary = (d['summary'] as Map?)?.cast<String, dynamic>() ?? {};
    final c = score >= 70 ? AppColors.success : score >= 50 ? AppColors.gold : score >= 35 ? AppColors.warning : AppColors.error;

    return CustomScrollView(slivers: [
      SliverAppBar(backgroundColor: const Color(0xFF0A0A24), pinned: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.chartName.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace')),
          Text.rich(TextSpan(children: [
            const TextSpan(text: "Today's ", style: TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w600)),
            TextSpan(text: 'Forecast', style: TextStyle(color: c, fontSize: 18, fontStyle: FontStyle.italic)),
          ])),
        ]),
        centerTitle: true, actions: [IconButton(icon: const Icon(Icons.refresh, color: AppColors.ivory, size: 18), onPressed: _load)]),
      SliverList(delegate: SliverChildListDelegate([
        // ═══ DAY SCORE HERO ═══
        Container(margin: const EdgeInsets.fromLTRB(16, 12, 16, 12), padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [c.withOpacity(0.15), const Color(0xFF4A3B8C).withOpacity(0.1)]),
            borderRadius: BorderRadius.circular(20), border: Border.all(color: c.withOpacity(0.3))),
          child: Column(children: [
            Text('$weekday · $dateStr', style: TextStyle(color: c, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            SizedBox(width: 100, height: 100, child: Stack(alignment: Alignment.center, children: [
              SizedBox(width: 100, height: 100, child: CircularProgressIndicator(value: score / 100, strokeWidth: 8,
                backgroundColor: Colors.white.withOpacity(0.08), valueColor: AlwaysStoppedAnimation(c))),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text(score.toStringAsFixed(0), style: TextStyle(color: c, fontSize: 28, fontWeight: FontWeight.w700, fontFamily: 'serif')),
                Text(gradeLabel, style: TextStyle(color: c, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              ]),
            ])),
            const SizedBox(height: 12),
            // Panchanga row
            Wrap(spacing: 8, runSpacing: 4, alignment: WrapAlignment.center, children: [
              _tag(vara, AppColors.gold), _tag(tithi, AppColors.lavender),
              _tag(nak, AppColors.aurora),
            ]),
            const SizedBox(height: 8),
            Text(moola, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace')),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('☀ $sunrise', style: const TextStyle(color: AppColors.smoke, fontSize: 8)),
              const SizedBox(width: 12),
              Text('🌙 $sunset', style: const TextStyle(color: AppColors.smoke, fontSize: 8)),
              const SizedBox(width: 12),
              Text('⚠ Rahu: $rahuKaal', style: const TextStyle(color: AppColors.error, fontSize: 8)),
            ]),
          ])),
        // ═══ BEST/WORST HOURS ═══
        if (hourly.isNotEmpty) Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Expanded(child: Column(children: [
              const Text('BEST HOUR', style: TextStyle(color: AppColors.success, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              Text(hourly['best_hour_today']?.toString() ?? '—', textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
            ])),
            Container(width: 1, height: 30, color: Colors.white12),
            Expanded(child: Column(children: [
              const Text('WORST HOUR', style: TextStyle(color: AppColors.error, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              Text(hourly['worst_hour_today']?.toString() ?? '—', textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
            ])),
          ])),
        // ═══ DO TODAY ═══
        if (doToday.isNotEmpty) ...[
          ReportHeader('Do', 'Today', '${doToday.length}'),
          ...doToday.take(6).map((a) => _actionCard(a.toString(), AppColors.success, '✓')),
        ],
        // ═══ AVOID TODAY ═══
        if (avoidToday.isNotEmpty) ...[
          ReportHeader('Avoid', 'Today', '${avoidToday.length}'),
          ...avoidToday.take(6).map((a) => _actionCard(a.toString(), AppColors.error, '✗')),
        ],
        // ═══ FAVORABLE FIELDS ═══
        if (favorable.isNotEmpty) ...[
          ReportHeader('Favorable', 'Fields', '${favorable.length}'),
          ...favorable.take(5).map((f) {
            if (f is! Map) return const SizedBox.shrink();
            final fld = (f as Map).cast<String, dynamic>();
            final fScore = (fld['score'] as num?)?.toDouble() ?? 0;
            final fc = fScore >= 70 ? AppColors.success : AppColors.gold;
            return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: fc.withOpacity(0.06), borderRadius: BorderRadius.circular(12),
                border: Border.all(color: fc.withOpacity(0.2))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(fld['field']?.toString() ?? '', style: TextStyle(color: fc, fontSize: 12, fontWeight: FontWeight.w700))),
                  Text('${fScore.toStringAsFixed(0)}', style: TextStyle(color: fc, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
                ]),
                if (fld['reason'] != null) Text(fld['reason'].toString(), maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.lavender, fontSize: 9, height: 1.3, fontStyle: FontStyle.italic)),
                if (fld['what_to_do'] is List) ...[const SizedBox(height: 4),
                  Wrap(spacing: 4, runSpacing: 4, children: (fld['what_to_do'] as List).take(3).map((w) => _tag(w.toString(), fc)).toList())],
              ]));
          }),
        ],
        // ═══ CHALLENGING FIELDS ═══
        if (challenging.isNotEmpty) ...[
          ReportHeader('Challenging', 'Fields', '${challenging.length}'),
          ...challenging.take(4).map((f) {
            if (f is! Map) return const SizedBox.shrink();
            final fld = (f as Map).cast<String, dynamic>();
            return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.06), borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning.withOpacity(0.2))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(fld['field']?.toString() ?? '', style: const TextStyle(color: AppColors.warning, fontSize: 12, fontWeight: FontWeight.w700))),
                  Text('${(fld['score'] as num?)?.toStringAsFixed(0) ?? "?"}', style: const TextStyle(color: AppColors.warning, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
                ]),
                if (fld['reason'] != null) Text(fld['reason'].toString(), maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.lavender, fontSize: 9, height: 1.3, fontStyle: FontStyle.italic)),
                if (fld['what_to_avoid'] is List) ...[const SizedBox(height: 4),
                  Wrap(spacing: 4, runSpacing: 4, children: (fld['what_to_avoid'] as List).take(3).map((w) => _tag(w.toString(), AppColors.warning)).toList())],
              ]));
          }),
        ],
        // ═══ COLOR/GEMSTONE/MANTRA ═══
        if (cgm.isNotEmpty) ...[
          ReportHeader('Today\'s', 'Remedy', '3 KEYS'),
          Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
            child: Column(children: [
              if (cgm['color'] != null) _remedyRow('🎨 COLOR', cgm['color'].toString()),
              if (cgm['gemstone'] != null) _remedyRow('💎 GEMSTONE', cgm['gemstone'].toString()),
              if (cgm['mantra'] != null) _remedyRow('🕉 MANTRA', cgm['mantra'].toString()),
            ])),
        ],
        // ═══ ALERTS ═══
        if (alerts.isNotEmpty) ...[
          ReportHeader('Daily', 'Alerts', '${alerts.length}'),
          ...alerts.take(5).map((a) {
            final text = a is Map ? (a as Map)['alert']?.toString() ?? a.toString() : a.toString();
            return _actionCard(text, AppColors.cosmicPink, '⚡');
          }),
        ],
        // ═══ SUMMARY ═══
        if (summary.isNotEmpty) Container(margin: const EdgeInsets.fromLTRB(16, 12, 16, 12), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.06), borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold.withOpacity(0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('DAY SUMMARY', style: TextStyle(color: AppColors.gold, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            if (summary['one_line'] != null) Text(summary['one_line'].toString(),
              style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w600, height: 1.4)),
            if (summary['detailed'] != null) ...[const SizedBox(height: 4),
              Text(summary['detailed'].toString(), style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.4))],
          ])),
        const SizedBox(height: 30),
      ])),
    ]);
  }

  Widget _actionCard(String text, Color c, String icon) => Container(
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(10),
      border: Border.all(color: c.withOpacity(0.2))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$icon ', style: TextStyle(color: c, fontSize: 12)),
      Expanded(child: Text(text, style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4))),
    ]));

  Widget _remedyRow(String label, String value) => Padding(padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      SizedBox(width: 80, child: Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace'))),
      Expanded(child: Text(value, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w600))),
    ]));

  Widget _tag(String text, Color c) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(6),
      border: Border.all(color: c.withOpacity(0.3))),
    child: Text(text, style: TextStyle(color: c, fontSize: 8, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis));
}
