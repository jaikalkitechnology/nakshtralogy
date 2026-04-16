import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

/// Detail page for a single rashi. Loads `/rashi/{idx}/full` and renders
/// metadata, today's gochar prediction, 7-day trend and 30-day trend.
class RashiDetailScreen extends StatefulWidget {
  final int rashiIdx;
  final String? initialName;
  const RashiDetailScreen({super.key, required this.rashiIdx, this.initialName});

  @override
  State<RashiDetailScreen> createState() => _RashiDetailScreenState();
}

class _RashiDetailScreenState extends State<RashiDetailScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = await _api.getRashiFull(widget.rashiIdx);
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        setState(() { _data = (resp['data'] as Map).cast<String, dynamic>(); _loading = false; });
      } else {
        setState(() { _error = resp['detail']?.toString() ?? 'Failed'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = _data;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(d?['name']?.toString() ?? widget.initialName ?? 'Rashi',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? _errView()
              : d == null
                  ? const SizedBox.shrink()
                  : ListView(padding: const EdgeInsets.all(16), children: [
                      _header(d),
                      const SizedBox(height: 14),
                      _todayCard(d),
                      const SizedBox(height: 14),
                      _metaGrid(d),
                      const SizedBox(height: 14),
                      _traitsCard(d),
                      const SizedBox(height: 14),
                      _trendCard('This Week', d['weekly'] as Map? ?? {}),
                      const SizedBox(height: 14),
                      _trendCard('This Month', d['monthly'] as Map? ?? {}),
                      const SizedBox(height: 24),
                    ]),
    );
  }

  Widget _header(Map<String, dynamic> d) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.2), AppColors.accent.withOpacity(0.08)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
      ),
      child: Row(children: [
        Text(d['emoji']?.toString() ?? '', style: const TextStyle(fontSize: 52)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['name']?.toString() ?? '',
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
          Text('${d['sanskrit']} • ${d['symbol']}',
              style: const TextStyle(color: AppColors.primary, fontSize: 12)),
          const SizedBox(height: 2),
          Text('Ruled by ${d['lord']}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ])),
      ]),
    );
  }

  Widget _todayCard(Map<String, dynamic> d) {
    final today = (d['today'] as Map? ?? {}).cast<String, dynamic>();
    final score = (today['score'] as num?)?.toDouble() ?? 0;
    final grade = today['grade']?.toString() ?? 'Normal';
    final flags = (today['flags'] as List?)?.cast<String>() ?? const [];
    final color = _scoreColor(score);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.today, color: AppColors.primary, size: 18),
          SizedBox(width: 8),
          Text('Today\'s Gochar', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Text(score.toStringAsFixed(2),
              style: TextStyle(color: color, fontSize: 34, fontWeight: FontWeight.w700)),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.5))),
            child: Text(grade, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ((score + 8) / 16).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation(color),
            )),
        if (flags.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(spacing: 6, runSpacing: 4, children: flags.map((f) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
            child: Text(f, style: const TextStyle(color: AppColors.accent, fontSize: 10)),
          )).toList()),
        ],
      ]),
    );
  }

  Widget _metaGrid(Map<String, dynamic> d) {
    final rows = [
      ['Element', d['element']],
      ['Quality', d['quality']],
      ['Lucky Color', d['lucky_color']],
      ['Lucky Day', d['lucky_day']],
      ['Lucky Number', '${d['lucky_number']}'],
      ['Gemstone', d['gem']],
      ['Body', d['body_part']],
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(children: rows.map((r) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          SizedBox(width: 110, child: Text(r[0]?.toString() ?? '',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
          Expanded(child: Text(r[1]?.toString() ?? '',
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500))),
        ]),
      )).toList()),
    );
  }

  Widget _traitsCard(Map<String, dynamic> d) {
    final s = (d['strengths'] as List?)?.cast<String>() ?? const [];
    final w = (d['weaknesses'] as List?)?.cast<String>() ?? const [];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.thumb_up_alt_outlined, color: AppColors.success, size: 16),
          const SizedBox(width: 6),
          const Text('Strengths', style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 6),
        Wrap(spacing: 6, runSpacing: 4, children: s.map((x) => _chip(x, AppColors.success)).toList()),
        const SizedBox(height: 12),
        Row(children: [
          const Icon(Icons.thumb_down_alt_outlined, color: AppColors.error, size: 16),
          const SizedBox(width: 6),
          const Text('Weaknesses', style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 6),
        Wrap(spacing: 6, runSpacing: 4, children: w.map((x) => _chip(x, AppColors.error)).toList()),
      ]),
    );
  }

  Widget _trendCard(String title, Map trendMap) {
    final days = ((trendMap['days'] as List?) ?? []).cast<Map>();
    final avg = (trendMap['avg'] as num?)?.toDouble() ?? 0;
    if (days.isEmpty) return const SizedBox.shrink();
    final maxS = days.map((d) => (d['score'] as num).toDouble()).reduce((a, b) => a > b ? a : b);
    final minS = days.map((d) => (d['score'] as num).toDouble()).reduce((a, b) => a < b ? a : b);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.trending_up, color: AppColors.primary, size: 16),
          const SizedBox(width: 6),
          Text(title, style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700)),
          const Spacer(),
          Text('avg ${avg.toStringAsFixed(2)}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ]),
        const SizedBox(height: 10),
        SizedBox(
          height: 70,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: days.map((day) {
            final s = (day['score'] as num).toDouble();
            final range = (maxS - minS).abs() < 0.01 ? 1.0 : (maxS - minS);
            final h = ((s - minS) / range).clamp(0.05, 1.0) * 60;
            final c = _scoreColor(s);
            return Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Tooltip(
                message: '${day['date']}: ${s.toStringAsFixed(2)}',
                child: Container(
                  height: h,
                  decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3)),
                ),
              ),
            ));
          }).toList()),
        ),
        const SizedBox(height: 6),
        Row(children: [
          Text('Best ${maxS.toStringAsFixed(1)}',
              style: const TextStyle(color: AppColors.success, fontSize: 10)),
          const Spacer(),
          Text('Worst ${minS.toStringAsFixed(1)}',
              style: const TextStyle(color: AppColors.error, fontSize: 10)),
        ]),
      ]),
    );
  }

  Widget _chip(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6), border: Border.all(color: color.withOpacity(0.3))),
    child: Text(label, style: TextStyle(color: color, fontSize: 10)),
  );

  Color _scoreColor(double s) {
    if (s >= 2.5) return AppColors.success;
    if (s >= 0.5) return Colors.lightGreen;
    if (s >= -1.5) return Colors.amber;
    if (s >= -3.5) return Colors.orange;
    return AppColors.error;
  }

  Widget _errView() => Center(child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, color: AppColors.error, size: 40),
      const SizedBox(height: 12),
      Text(_error!, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
      const SizedBox(height: 12),
      ElevatedButton(onPressed: _load, child: const Text('Retry')),
    ]),
  ));
}
