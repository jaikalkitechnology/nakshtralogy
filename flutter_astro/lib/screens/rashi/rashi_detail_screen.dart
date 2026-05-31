import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../kundli/widgets/north_indian_chart.dart';

/// Detail page for a single rashi. Loads `/rashi/{idx}/full` and
/// `/rashi/{idx}/predictions` and renders:
///   - hero card with emoji, name, lord
///   - today's gochar score
///   - detailed life-area predictions (career, health, love, wealth,
///     family, conflict, ego, aggression, mind, spiritual)
///   - rashi diamond chart showing current planet transits
///   - metadata grid, traits, weekly & monthly trends
class RashiDetailScreen extends StatefulWidget {
  final int rashiIdx;
  final String? initialName;
  const RashiDetailScreen({super.key, required this.rashiIdx, this.initialName});

  @override
  State<RashiDetailScreen> createState() => _RashiDetailScreenState();
}

class _RashiDetailScreenState extends State<RashiDetailScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _full;
  Map<String, dynamic>? _predictions;
  bool _loading = true;
  String? _error;

  static const _signShortList = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi'];

  // Life area metadata (order, icon, color)
  static const _areaMeta = [
    {'key': 'career',     'label': 'Career',     'emoji': '\u{1F4BC}'},
    {'key': 'health',     'label': 'Health',     'emoji': '\u2695'},
    {'key': 'love',       'label': 'Love',       'emoji': '\u{1F495}'},
    {'key': 'wealth',     'label': 'Wealth',     'emoji': '\u{1F4B0}'},
    {'key': 'family',     'label': 'Family',     'emoji': '\u{1F46A}'},
    {'key': 'mind',       'label': 'Mind',       'emoji': '\u{1F9E0}'},
    {'key': 'ego',        'label': 'Ego',        'emoji': '\u{1F451}'},
    {'key': 'aggression', 'label': 'Aggression', 'emoji': '\u{1F525}'},
    {'key': 'conflict',   'label': 'Conflict',   'emoji': '\u2694'},
    {'key': 'spiritual',  'label': 'Spiritual',  'emoji': '\u{1F54A}'},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      // Parallel load full + predictions
      final results = await Future.wait([
        _api.getRashiFull(widget.rashiIdx),
        _api.getRashiPredictions(widget.rashiIdx),
      ]);
      if (!mounted) return;
      final fullResp = results[0];
      final predResp = results[1];
      if (fullResp['statusCode'] == 200 && fullResp['status'] == 'success') {
        _full = (fullResp['data'] as Map).cast<String, dynamic>();
      }
      if (predResp['statusCode'] == 200 && predResp['status'] == 'success') {
        _predictions = (predResp['data'] as Map).cast<String, dynamic>();
      }
      setState(() { _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = _full;
    return Scaffold(
      backgroundColor: AppColors.cosmicVoid,
      appBar: AppBar(
        title: Text(d?['name']?.toString() ?? widget.initialName ?? 'Rashi',
            style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null
              ? _errView()
              : d == null
                  ? const SizedBox.shrink()
                  : ListView(padding: const EdgeInsets.all(16), children: [
                      _header(d),
                      const SizedBox(height: 14),
                      _todayCard(d),
                      const SizedBox(height: 14),
                      if (_predictions != null) ...[
                        _transitChart(),
                        const SizedBox(height: 14),
                        _predictionsSection(),
                        const SizedBox(height: 14),
                      ],
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
          colors: [AppColors.gold.withOpacity(0.2), AppColors.indigo.withOpacity(0.08)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold.withOpacity(0.4)),
      ),
      child: Row(children: [
        Text(d['emoji']?.toString() ?? '', style: const TextStyle(fontSize: 52)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d['name']?.toString() ?? '',
              style: const TextStyle(color: AppColors.ivory, fontSize: 22, fontWeight: FontWeight.w700)),
          Text('${d['sanskrit']} \u2022 ${d['symbol']}',
              style: const TextStyle(color: AppColors.gold, fontSize: 12)),
          const SizedBox(height: 2),
          Text('Ruled by ${d['lord']}',
              style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
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
      decoration: BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.15))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Icon(Icons.today, color: AppColors.gold, size: 18),
          SizedBox(width: 8),
          Text('Today\'s Gochar', style: TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w700)),
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
              minHeight: 6, backgroundColor: AppColors.twilight,
              valueColor: AlwaysStoppedAnimation(color),
            )),
        if (flags.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(spacing: 6, runSpacing: 4, children: flags.map((f) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.indigo.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
            child: Text(f, style: const TextStyle(color: AppColors.lavender, fontSize: 10)),
          )).toList()),
        ],
      ]),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // TRANSIT DIAMOND CHART — shows current planet positions in houses
  // relative to native Moon sign
  // ─────────────────────────────────────────────────────────────
  Widget _transitChart() {
    final chart = (_predictions!['transit_chart'] as Map?)?.cast<String, dynamic>() ?? {};
    final housesData = (chart['houses'] as List?) ?? [];
    if (housesData.isEmpty) return const SizedBox.shrink();

    final houses = housesData.map((h) {
      final m = (h as Map).cast<String, dynamic>();
      final planets = (m['planets'] as List?) ?? [];
      return {
        'house': m['house'],
        'rashi_idx': m['sign_idx'],
        'rashi_short': _signShortList[(m['sign_idx'] as num).toInt() % 12],
        'planets': planets.map((p) => {
          'planet': p,
          'flags': const [],
          'degree': 0,
        }).toList(),
        'is_lagna': m['house'] == 1,
      };
    }).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.15))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Icon(Icons.grid_view, color: AppColors.gold, size: 18),
          SizedBox(width: 8),
          Text('Today\'s Transit Chart', style: TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 4),
        const Text('Current planet positions with your sign as house 1',
            style: TextStyle(color: AppColors.smoke, fontSize: 11)),
        const SizedBox(height: 12),
        NorthIndianChartWidget(houses: houses, chartTitle: 'Transit'),
      ]),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // LIFE-AREA PREDICTIONS
  // ─────────────────────────────────────────────────────────────
  Widget _predictionsSection() {
    final preds = (_predictions!['predictions'] as Map?)?.cast<String, dynamic>() ?? {};
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.15))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Icon(Icons.auto_awesome, color: AppColors.gold, size: 18),
          SizedBox(width: 8),
          Text('Life Area Predictions', style: TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 4),
        const Text('Based on current planetary transits',
            style: TextStyle(color: AppColors.smoke, fontSize: 11)),
        const SizedBox(height: 12),
        ..._areaMeta.map((meta) {
          final data = (preds[meta['key']] as Map?)?.cast<String, dynamic>();
          if (data == null) return const SizedBox.shrink();
          return _predictionRow(meta, data);
        }),
      ]),
    );
  }

  Widget _predictionRow(Map<String, dynamic> meta, Map<String, dynamic> data) {
    final score = (data['score'] as num?)?.toDouble() ?? 0;
    final grade = data['grade']?.toString() ?? '';
    final desc = data['description']?.toString() ?? '';
    final factors = (data['factors'] as List?)?.cast<String>() ?? const [];
    final color = _predictionColor(score);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(meta['emoji'] as String, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(child: Text(meta['label'] as String,
              style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: color.withOpacity(0.18), borderRadius: BorderRadius.circular(6)),
            child: Text(grade, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          ),
          const SizedBox(width: 6),
          Text('${score.toInt()}', style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: (score / 100).clamp(0.0, 1.0),
            minHeight: 4, backgroundColor: AppColors.twilight,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: 8),
        Text(desc, style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4)),
        if (factors.isNotEmpty) ...[
          const SizedBox(height: 6),
          Wrap(spacing: 4, runSpacing: 3, children: factors.map((f) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: AppColors.twilight, borderRadius: BorderRadius.circular(4)),
            child: Text(f, style: const TextStyle(color: AppColors.smoke, fontSize: 9)),
          )).toList()),
        ],
      ]),
    );
  }

  Color _predictionColor(double s) {
    if (s >= 75) return AppColors.success;
    if (s >= 60) return AppColors.aurora;
    if (s >= 45) return AppColors.goldBright;
    if (s >= 30) return AppColors.saffron;
    return AppColors.error;
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
      decoration: BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.15))),
      child: Column(children: rows.map((r) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          SizedBox(width: 110, child: Text(r[0]?.toString() ?? '',
              style: const TextStyle(color: AppColors.smoke, fontSize: 12))),
          Expanded(child: Text(r[1]?.toString() ?? '',
              style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w500))),
        ]),
      )).toList()),
    );
  }

  Widget _traitsCard(Map<String, dynamic> d) {
    final s = (d['strengths'] as List?)?.cast<String>() ?? const [];
    final w = (d['weaknesses'] as List?)?.cast<String>() ?? const [];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.15))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Icon(Icons.thumb_up_alt_outlined, color: AppColors.success, size: 16),
          SizedBox(width: 6),
          Text('Strengths', style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 6),
        Wrap(spacing: 6, runSpacing: 4, children: s.map((x) => _chip(x, AppColors.success)).toList()),
        const SizedBox(height: 12),
        Row(children: const [
          Icon(Icons.thumb_down_alt_outlined, color: AppColors.error, size: 16),
          SizedBox(width: 6),
          Text('Weaknesses', style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w700)),
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
      decoration: BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.15))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.trending_up, color: AppColors.gold, size: 16),
          const SizedBox(width: 6),
          Text(title, style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w700)),
          const Spacer(),
          Text('avg ${avg.toStringAsFixed(2)}',
              style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
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
          Text('Best ${maxS.toStringAsFixed(1)}', style: const TextStyle(color: AppColors.success, fontSize: 10)),
          const Spacer(),
          Text('Worst ${minS.toStringAsFixed(1)}', style: const TextStyle(color: AppColors.error, fontSize: 10)),
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
    if (s >= 0.5) return AppColors.aurora;
    if (s >= -1.5) return AppColors.goldBright;
    if (s >= -3.5) return AppColors.saffron;
    return AppColors.error;
  }

  Widget _errView() => Center(child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, color: AppColors.error, size: 40),
      const SizedBox(height: 12),
      Text(_error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center),
      const SizedBox(height: 12),
      ElevatedButton(onPressed: _load, child: Text(AppLocalizations.of(context)?.retry ?? 'Retry')),
    ]),
  ));
}
