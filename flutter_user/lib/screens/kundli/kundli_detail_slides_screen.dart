import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'widgets/north_indian_chart.dart';

/// Swipeable kundli detail view — 4 slides: Summary, Yog, Dosh, Career.
/// Reference: nakshtralogy-design.html SLIDE 01-04.
/// Uses PageView with tab indicator and page dots.
class KundliDetailSlidesScreen extends StatefulWidget {
  final String chartId;
  final String clientName;
  final String? dob;
  final String? tob;

  const KundliDetailSlidesScreen({
    super.key,
    required this.chartId,
    required this.clientName,
    this.dob,
    this.tob,
  });

  @override
  State<KundliDetailSlidesScreen> createState() => _KundliDetailSlidesScreenState();
}

class _KundliDetailSlidesScreenState extends State<KundliDetailSlidesScreen> {
  final _api = ApiService();
  final _page = PageController();
  int _idx = 0;

  Map<String, dynamic>? _chart;
  Map<String, dynamic>? _yoga;
  Map<String, dynamic>? _dosh;
  Map<String, dynamic>? _life;

  bool _loadingChart = true;
  bool _loadingYoga = true;
  bool _loadingDosh = true;
  bool _loadingLife = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    // Load chart first (needed for summary)
    final r = await _api.getKundliChart(widget.chartId);
    if (mounted && r['statusCode'] == 200 && r['status'] == 'success') {
      setState(() { _chart = (r['data'] as Map).cast<String, dynamic>(); _loadingChart = false; });
    } else if (mounted) {
      setState(() => _loadingChart = false);
    }

    // Parallel load the three analyses
    _api.getKundliYoga(widget.chartId).then((r) {
      if (mounted && r['statusCode'] == 200 && r['status'] == 'success') {
        setState(() { _yoga = (r['data'] as Map).cast<String, dynamic>(); _loadingYoga = false; });
      } else if (mounted) setState(() => _loadingYoga = false);
    });
    _api.getKundliDosh(widget.chartId).then((r) {
      if (mounted && r['statusCode'] == 200 && r['status'] == 'success') {
        setState(() { _dosh = (r['data'] as Map).cast<String, dynamic>(); _loadingDosh = false; });
      } else if (mounted) setState(() => _loadingDosh = false);
    });
    _api.getKundliLifeAreas(widget.chartId).then((r) {
      if (mounted && r['statusCode'] == 200 && r['status'] == 'success') {
        setState(() { _life = (r['data'] as Map).cast<String, dynamic>(); _loadingLife = false; });
      } else if (mounted) setState(() => _loadingLife = false);
    });
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cosmicVoid,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          Text.rich(TextSpan(children: [
            TextSpan(text: widget.clientName.split(' ').first, style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700)),
            if (widget.clientName.split(' ').length > 1)
              TextSpan(text: ' ${widget.clientName.split(' ').skip(1).join(' ')}', style: const TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic)),
          ])),
          if (widget.dob != null || widget.tob != null)
            Text('${widget.dob ?? ''} \u00b7 ${widget.tob ?? ''}',
                style: const TextStyle(color: AppColors.smoke, fontSize: 9, letterSpacing: 1.2)),
        ]),
        actions: const [
          Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.ios_share, size: 18, color: AppColors.ivory)),
        ],
        centerTitle: true,
        bottom: _slideTabs(),
      ),
      body: PageView(
        controller: _page,
        onPageChanged: (i) => setState(() => _idx = i),
        children: [
          _summarySlide(),
          _yogaSlide(),
          _doshSlide(),
          _careerSlide(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        color: AppColors.midnight.withOpacity(0.95),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(4, (i) {
          final active = i == _idx;
          return GestureDetector(
            onTap: () => _page.animateToPage(i, duration: const Duration(milliseconds: 220), curve: Curves.easeOut),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 20 : 6, height: 6,
              decoration: BoxDecoration(
                color: active ? AppColors.gold : AppColors.gold.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        })),
      ),
    );
  }

  PreferredSizeWidget _slideTabs() {
    const tabs = ['Summary', 'Yog', 'Dosh', 'Career'];
    return PreferredSize(
      preferredSize: const Size.fromHeight(44),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Row(children: List.generate(tabs.length, (i) {
          final active = i == _idx;
          return Expanded(child: GestureDetector(
            onTap: () => _page.animateToPage(i, duration: const Duration(milliseconds: 200), curve: Curves.easeOut),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: active ? const LinearGradient(colors: [AppColors.gold, AppColors.saffron]) : null,
                color: active ? null : Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: active ? Colors.transparent : AppColors.gold.withOpacity(0.15)),
              ),
              child: Center(child: Text(
                tabs[i],
                style: TextStyle(
                  color: active ? AppColors.midnight : AppColors.smoke,
                  fontSize: 11, fontWeight: FontWeight.w700,
                ),
              )),
            ),
          ));
        })),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SLIDE 1: SUMMARY
  // ─────────────────────────────────────────────────────────────
  Widget _summarySlide() {
    if (_loadingChart) return const Center(child: CircularProgressIndicator(color: AppColors.gold));
    if (_chart == null) return const Center(child: Text('No data', style: TextStyle(color: AppColors.smoke)));
    final planets = (_chart!['planets'] as Map? ?? {}).cast<String, dynamic>();
    final lagna = (planets['Lagna'] as Map?)?.cast<String, dynamic>();
    final moon = (planets['Moon'] as Map?)?.cast<String, dynamic>();
    final lagnaSignIdx = (lagna?['sign_idx'] as num?)?.toInt() ?? 0;

    // Build houses for mini chart
    final byRashi = <int, List<Map<String, dynamic>>>{};
    planets.forEach((name, data) {
      if (name == 'Lagna') return;
      final p = (data as Map).cast<String, dynamic>();
      final si = (p['sign_idx'] as num?)?.toInt() ?? 0;
      byRashi.putIfAbsent(si, () => []).add({
        'planet': name,
        'flags': [
          if (p['vakri'] == true) 'R',
          if (p['combust'] == true) 'C',
        ],
      });
    });
    final houses = List.generate(12, (h) {
      final ri = (lagnaSignIdx + h) % 12;
      return {
        'house': h + 1, 'rashi_idx': ri,
        'planets': byRashi[ri] ?? [],
        'is_lagna': h == 0,
      };
    });

    final summaryItems = <List<String>>[
      ['Ascendant', '${lagna?['sign_full'] ?? ''}'],
      ['Moon Sign', '${moon?['sign_full'] ?? ''}'],
      ['Nakshatra', '${moon?['nakshatra'] ?? ''} \u00b7 ${moon?['pada'] ?? ''}'],
      ['Current Dasha', _chart!['current_dasha']?.toString() ?? '\u2014'],
      ['Tithi', _chart!['tithi']?.toString() ?? '\u2014'],
      ['Yoga', _chart!['yoga']?.toString() ?? '\u2014'],
    ];

    return ListView(padding: const EdgeInsets.all(16), children: [
      NorthIndianChartWidget(houses: houses, chartTitle: 'Lagna'),
      const SizedBox(height: 16),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.6,
        children: summaryItems.map((it) => Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.gold.withOpacity(0.15)),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(it[0], style: const TextStyle(color: AppColors.smoke, fontSize: 9, letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(it[1], style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
          ]),
        )).toList(),
      ),
    ]);
  }

  // ─────────────────────────────────────────────────────────────
  // SLIDE 2: YOG
  // ─────────────────────────────────────────────────────────────
  Widget _yogaSlide() {
    if (_loadingYoga) return const Center(child: CircularProgressIndicator(color: AppColors.gold));
    if (_yoga == null) return const Center(child: Text('No data', style: TextStyle(color: AppColors.smoke)));
    final yogas = (_yoga!['yogas'] as List?) ?? [];
    final active = yogas.where((y) => (y as Map)['present'] == true).toList();
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text('\u2728 ${active.length} AUSPICIOUS YOGAS FOUND',
          style: const TextStyle(color: AppColors.smoke, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      if (active.isEmpty)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(12)),
          child: const Text('No active yogas in this chart.', style: TextStyle(color: AppColors.smoke, fontSize: 12)),
        )
      else
        ...active.map((y) {
          final m = (y as Map).cast<String, dynamic>();
          final score = (m['score'] as num?)?.toInt() ?? 0;
          final strength = score >= 70 ? 'STRONG' : score >= 40 ? 'MEDIUM' : 'ACTIVE';
          return _card(
            name: m['name']?.toString() ?? '',
            badge: strength,
            badgeColor: AppColors.success,
            description: m['description']?.toString() ?? '',
          );
        }),
    ]);
  }

  // ─────────────────────────────────────────────────────────────
  // SLIDE 3: DOSH
  // ─────────────────────────────────────────────────────────────
  Widget _doshSlide() {
    if (_loadingDosh) return const Center(child: CircularProgressIndicator(color: AppColors.gold));
    if (_dosh == null) return const Center(child: Text('No data', style: TextStyle(color: AppColors.smoke)));
    final doshas = (_dosh!['doshas'] as List?) ?? [];
    final active = doshas.where((d) => (d as Map)['present'] == true).toList();
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text('\u26a0 ${active.length} DOSHAS DETECTED \u00b7 REMEDIES AVAILABLE',
          style: const TextStyle(color: AppColors.smoke, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      if (active.isEmpty)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.success.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.success.withOpacity(0.25))),
          child: const Text('\u2713 No major doshas in this chart.', style: TextStyle(color: AppColors.success, fontSize: 12)),
        )
      else
        ...active.map((d) {
          final m = (d as Map).cast<String, dynamic>();
          final severity = m['severity']?.toString().toUpperCase() ?? 'MILD';
          return _card(
            name: m['name']?.toString() ?? '',
            badge: severity,
            badgeColor: AppColors.error,
            description: m['description']?.toString() ?? '',
            remedy: (m['remedies'] is List && (m['remedies'] as List).isNotEmpty)
                ? (m['remedies'] as List).first.toString()
                : null,
            isDosh: true,
          );
        }),
    ]);
  }

  // ─────────────────────────────────────────────────────────────
  // SLIDE 4: CAREER (Life Areas)
  // ─────────────────────────────────────────────────────────────
  Widget _careerSlide() {
    if (_loadingLife) return const Center(child: CircularProgressIndicator(color: AppColors.gold));
    if (_life == null) return const Center(child: Text('No data', style: TextStyle(color: AppColors.smoke)));
    final career = (_life!['Career'] as Map?)?.cast<String, dynamic>() ?? {};
    final wealth = (_life!['Wealth'] as Map?)?.cast<String, dynamic>() ?? {};
    final marriage = (_life!['Marriage'] as Map?)?.cast<String, dynamic>() ?? {};
    final health = (_life!['Health'] as Map?)?.cast<String, dynamic>() ?? {};
    final areas = [
      {'name': 'Career', 'emoji': '\u{1F4BC}', 'data': career, 'gradient': [AppColors.gold, AppColors.saffron]},
      {'name': 'Wealth', 'emoji': '\u{1F4B0}', 'data': wealth, 'gradient': [AppColors.cosmicPink, AppColors.saffron]},
      {'name': 'Marriage', 'emoji': '\u{1F495}', 'data': marriage, 'gradient': [AppColors.success, AppColors.indigo]},
      {'name': 'Health', 'emoji': '\u2695', 'data': health, 'gradient': [AppColors.aurora, AppColors.indigo]},
    ];

    return ListView(padding: const EdgeInsets.all(16), children: [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.15), AppColors.indigo.withOpacity(0.15)]),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withOpacity(0.3)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('LIFE AREA SCORES', style: TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(AppLocalizations.of(context)?.basedOnPlanetStrengths ?? 'Based on planetary strengths',
              style: TextStyle(color: AppColors.lavender, fontSize: 10)),
        ]),
      ),
      const SizedBox(height: 12),
      const Text('TOP AREAS', style: TextStyle(color: AppColors.smoke, fontSize: 10, letterSpacing: 1.2)),
      const SizedBox(height: 8),
      ...areas.map((a) {
        final data = a['data'] as Map<String, dynamic>;
        final score = (data['score'] as num?)?.toInt() ?? 0;
        final grad = a['gradient'] as List<Color>;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gold.withOpacity(0.12)),
          ),
          child: Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: grad),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(a['emoji'] as String, style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(a['name'] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (score.clamp(0, 100)) / 100,
                  minHeight: 5,
                  backgroundColor: AppColors.nebula,
                  valueColor: AlwaysStoppedAnimation(grad.first),
                ),
              ),
            ])),
            const SizedBox(width: 10),
            Text('$score',
                style: TextStyle(color: grad.first, fontSize: 20, fontWeight: FontWeight.w700)),
          ]),
        );
      }),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.success.withOpacity(0.3)),
        ),
        child: Row(children: const [
          Icon(Icons.auto_awesome, color: AppColors.success, size: 14),
          SizedBox(width: 8),
          Expanded(child: Text(AppLocalizations.of(context)?.favorablePeriodAdvice ?? 'Favorable period',
              style: TextStyle(color: AppColors.ivory, fontSize: 11))),
        ]),
      ),
    ]);
  }

  Widget _card({
    required String name,
    required String badge,
    required Color badgeColor,
    required String description,
    String? remedy,
    bool isDosh = false,
  }) {
    final bgOpacity = isDosh ? 0.15 : 0.04;
    final borderColor = isDosh ? AppColors.error.withOpacity(0.3) : AppColors.gold.withOpacity(0.15);
    final nameColor = isDosh ? AppColors.error : AppColors.ivory;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isDosh ? AppColors.error : Colors.white).withOpacity(bgOpacity),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(name, style: TextStyle(color: nameColor, fontSize: 13, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(color: badgeColor.withOpacity(0.18), borderRadius: BorderRadius.circular(4)),
            child: Text(badge, style: TextStyle(color: badgeColor, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          ),
        ]),
        const SizedBox(height: 6),
        Text(description, style: const TextStyle(color: AppColors.smoke, fontSize: 11, height: 1.4)),
        if (remedy != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('\u2713 REMEDY', style: TextStyle(color: AppColors.success, fontSize: 8, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(remedy, style: const TextStyle(color: AppColors.ivory, fontSize: 10)),
            ]),
          ),
        ],
      ]),
    );
  }
}
