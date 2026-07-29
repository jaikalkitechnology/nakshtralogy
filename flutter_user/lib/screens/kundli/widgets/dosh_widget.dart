import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '../../../utils/kundli_names.dart';
import '_section_loader.dart';
import 'kundli_ui.dart';

/// Redesigned DOSH screen — reassuring hero, Overview / Detailed / Remedies
/// tabs, expandable dosha cards with severity, affected areas, timeline and
/// remedies, plus a detail bottom sheet and an "Explain My Doshas" summary.
///
/// Presentation only — scores/severity/factors/cancels come from the API
/// (dosh_analysis). Remedies are derived from each dosha's primary planet
/// (standard Vedic constants) since the backend does not provide them.
class DoshWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const DoshWidget({super.key, required this.chartId, this.initial});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliDosh(chartId),
      builder: (ctx, data) => _DoshView(data: data),
    );
  }
}

// ── severity (per dosha, by score) ───────────────────────────────────────
Color doshColor(num s) {
  if (s >= 80) return KColors.red;
  if (s >= 60) return KColors.orange;
  if (s >= 40) return KColors.yellow;
  return KColors.green;
}

String doshSeverityLabel(num s, AppLocalizations l) {
  if (s >= 80) return l.doshSevere;
  if (s >= 60) return l.sumStrong;
  if (s >= 40) return l.avModerate;
  return l.doshVeryMild;
}

int doshStars(num s) => (s / 20).ceil().clamp(1, 5);

// ── planet extraction + constants ────────────────────────────────────────
const List<String> _kPlanets = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn', 'Rahu', 'Ketu'];

String? doshPrimaryPlanet(String name, List factors) {
  final hay = '$name ${factors.join(' ')}';
  for (final p in _kPlanets) {
    if (hay.contains(p)) return p;
  }
  final n = name.toLowerCase();
  if (n.contains('mangal') || n.contains('kuja') || n.contains('angarak')) return 'Mars';
  if (n.contains('pitra') || n.contains('surya')) return 'Sun';
  if (n.contains('chandra') || n.contains('grahan') || n.contains('shakat')) return 'Moon';
  if (n.contains('shani') || n.contains('sade') || n.contains('shrapit')) return 'Saturn';
  if (n.contains('guru') || n.contains('chandal')) return 'Jupiter';
  if (n.contains('kaal sarp') || n.contains('rahu')) return 'Rahu';
  if (n.contains('ketu')) return 'Ketu';
  return null;
}

const Map<String, List<String>> _kPlanetAreas = {
  'Sun': ['career', 'health'], 'Moon': ['mind', 'health'], 'Mars': ['marriage', 'health'],
  'Mercury': ['finance', 'mind'], 'Jupiter': ['children', 'finance'], 'Venus': ['marriage', 'finance'],
  'Saturn': ['career', 'health'], 'Rahu': ['mind', 'career'], 'Ketu': ['mind', 'health'],
};

String areaLabel(String t, AppLocalizations l) {
  switch (t) {
    case 'career': return l.careerWord;
    case 'marriage': return l.lifeAreaMarriage;
    case 'health': return l.lifeHealth;
    case 'finance': return l.avFinance;
    case 'children': return l.doshAreaChildren;
    default: return l.doshAreaMind;
  }
}

// planet → remedy set (proper-noun constants; mantras are Sanskrit/universal)
const Map<String, Map<String, String>> _kRemedies = {
  'Sun': {'mantra': 'Om Sūryāya Namaḥ', 'gem': 'Ruby', 'donate': 'Wheat, jaggery', 'temple': 'Sun / Shiva', 'fast': 'Sunday'},
  'Moon': {'mantra': 'Om Chandrāya Namaḥ', 'gem': 'Pearl', 'donate': 'Rice, milk, silver', 'temple': 'Shiva', 'fast': 'Monday'},
  'Mars': {'mantra': 'Om Maṅgalāya Namaḥ', 'gem': 'Red Coral', 'donate': 'Red lentils, jaggery', 'temple': 'Hanuman', 'fast': 'Tuesday'},
  'Mercury': {'mantra': 'Om Budhāya Namaḥ', 'gem': 'Emerald', 'donate': 'Green gram, books', 'temple': 'Vishnu', 'fast': 'Wednesday'},
  'Jupiter': {'mantra': 'Om Gurave Namaḥ', 'gem': 'Yellow Sapphire', 'donate': 'Turmeric, gram, gold', 'temple': 'Vishnu / Brihaspati', 'fast': 'Thursday'},
  'Venus': {'mantra': 'Om Śukrāya Namaḥ', 'gem': 'Diamond / Opal', 'donate': 'White cloth, sugar, ghee', 'temple': 'Lakshmi', 'fast': 'Friday'},
  'Saturn': {'mantra': 'Om Śanaiścarāya Namaḥ', 'gem': 'Blue Sapphire', 'donate': 'Black sesame, mustard oil', 'temple': 'Shani / Hanuman', 'fast': 'Saturday'},
  'Rahu': {'mantra': 'Om Rāhave Namaḥ', 'gem': 'Hessonite', 'donate': 'Mustard, blanket, coconut', 'temple': 'Durga / Bhairava', 'fast': 'Saturday'},
  'Ketu': {'mantra': 'Om Ketave Namaḥ', 'gem': "Cat's Eye", 'donate': 'Multi-grain, blanket', 'temple': 'Ganesha', 'fast': 'Saturday'},
};

// ═══════════════════════════════════════════════════════════════════════
class _DoshView extends StatefulWidget {
  final Map<String, dynamic> data;
  const _DoshView({required this.data});
  @override
  State<_DoshView> createState() => _DoshViewState();
}

class _DoshViewState extends State<_DoshView> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  int get _total => (widget.data['total'] as num?)?.toInt() ?? 0;

  List<Map<String, dynamic>> get _active {
    final list = (widget.data['doshas'] as List? ?? []).cast<dynamic>();
    return list.map((e) => (e as Map).cast<String, dynamic>()).where((d) => d['present'] == true).toList()
      ..sort((a, b) => ((b['score'] as num?) ?? 0).compareTo((a['score'] as num?) ?? 0));
  }

  double get _avgScore {
    final a = _active;
    if (a.isEmpty) return 0;
    return a.map((d) => (d['score'] as num?)?.toDouble() ?? 0).fold(0.0, (x, y) => x + y) / a.length;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      TabBar(
        controller: _tabs,
        indicatorColor: AppColors.gold, labelColor: AppColors.gold, unselectedLabelColor: AppColors.smoke,
        labelStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
        tabs: [Tab(text: l.bhOverview), Tab(text: l.bhDetailed), Tab(text: l.bhRemedies)],
      ),
      Expanded(child: TabBarView(controller: _tabs, children: [_overview(l), _detailed(l), _remediesTab(l)])),
    ]);
  }

  Color _overallColor() => _active.isEmpty ? KColors.green : doshColor(_avgScore);

  String _overallLabel(AppLocalizations l) {
    if (_active.isEmpty) return l.doshLow;
    final s = _avgScore;
    if (s >= 80) return l.doshCritical;
    if (s >= 60) return l.doshHigh;
    if (s >= 40) return l.avModerate;
    return l.doshLow;
  }

  // ═════════════════════════ OVERVIEW ═════════════════════════════════
  Widget _overview(AppLocalizations l) {
    final active = _active;
    return ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 28), children: [
      KFadeIn(child: _explainButton(l)),
      const SizedBox(height: 14),
      KFadeIn(delayMs: 60, child: _hero(l)),
      const SizedBox(height: 18),
      KFadeIn(delayMs: 120, child: _legend(l)),
      const SizedBox(height: 18),
      if (active.isEmpty)
        _emptyState(l)
      else ...[
        KFadeIn(delayMs: 160, child: KSectionHeader(icon: Icons.list_alt_rounded, title: l.dosh, color: KColors.orange)),
        ...List.generate(active.length, (i) => KFadeIn(delayMs: 180 + i * 25, child: _compactCard(l, active[i]))),
      ],
    ]);
  }

  Widget _explainButton(AppLocalizations l) => Material(
        color: AppColors.gold, borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _showExplain(l),
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('✨', style: TextStyle(fontSize: 15)),
              const SizedBox(width: 8),
              Flexible(child: Text(l.doshExplain, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.midnight, fontSize: 13.5, fontWeight: FontWeight.w800))),
            ])),
        ),
      );

  Widget _hero(AppLocalizations l) {
    final active = _active.length;
    final color = _overallColor();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF2A2358), Color(0xFF1A1642)]),
        borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('🛡️', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(child: Text(l.doshSummaryTitle, style: const TextStyle(color: AppColors.goldBright, fontSize: 16.5, fontWeight: FontWeight.w800))),
        ]),
        const SizedBox(height: 16),
        Wrap(spacing: 10, runSpacing: 10, children: [
          _tile(l.doshActiveDoshas, '$active', KColors.orange),
          _tile(l.doshTotalChecked, '$_total', KColors.blue),
          _tile(l.doshOverallSeverity, _overallLabel(l), color),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.18), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.lavender.withOpacity(0.25))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 15))),
            Expanded(child: Text(l.doshHeroSummary('$active', '$_total'), style: const TextStyle(color: AppColors.parchment, fontSize: 13, height: 1.5))),
          ]),
        ),
      ]),
    );
  }

  Widget _tile(String label, String value, Color color) => Container(
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.35))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 9, letterSpacing: 0.5, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 3),
          Text(value, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
        ]),
      );

  Widget _legend(AppLocalizations l) {
    final items = [
      [KColors.green, l.doshVeryMild], [KColors.yellow, l.avModerate], [KColors.orange, l.sumStrong], [KColors.red, l.doshSevere],
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Wrap(spacing: 14, runSpacing: 7, alignment: WrapAlignment.center, children: items.map((it) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 11, height: 11, decoration: BoxDecoration(color: it[0] as Color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 5),
        Text(it[1] as String, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w600)),
      ])).toList()),
    );
  }

  Widget _emptyState(AppLocalizations l) => Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(color: KColors.green.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: KColors.green.withOpacity(0.3))),
        child: Column(children: [
          const Icon(Icons.verified_rounded, color: KColors.green, size: 40),
          const SizedBox(height: 10),
          Text(l.doshNoneActive, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w700)),
        ]),
      );

  Widget _compactCard(AppLocalizations l, Map<String, dynamic> d) {
    final score = (d['score'] as num?)?.toDouble() ?? 0;
    final color = doshColor(score);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showDetail(l, d),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.3))),
        child: Row(children: [
          Container(width: 6, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_doshName(d), style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w800)),
            const SizedBox(height: 3),
            Text('${d['category'] ?? ''}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            KStars(filled: doshStars(score), size: 13, color: color),
            const SizedBox(height: 4),
            Text(doshSeverityLabel(score, l), style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
          ]),
          const Icon(Icons.chevron_right, color: AppColors.smoke, size: 20),
        ]),
      ),
    );
  }

  // ═════════════════════════ DETAILED ═════════════════════════════════
  Widget _detailed(AppLocalizations l) {
    final active = _active;
    if (active.isEmpty) return ListView(padding: const EdgeInsets.all(16), children: [_emptyState(l)]);
    return ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        children: List.generate(active.length, (i) => KFadeIn(delayMs: i * 25, child: _DoshCard(data: active[i], onDetail: () => _showDetail(l, active[i])))));
  }

  // ═════════════════════════ REMEDIES ═════════════════════════════════
  Widget _remediesTab(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final active = _active;
    if (active.isEmpty) return ListView(padding: const EdgeInsets.all(16), children: [_emptyState(l)]);
    final byPlanet = <String, List<String>>{};
    for (final d in active) {
      final p = doshPrimaryPlanet(_doshName(d), (d['factors'] as List? ?? []));
      if (p == null) continue;
      byPlanet.putIfAbsent(p, () => []).add(_doshName(d));
    }
    if (byPlanet.isEmpty) return ListView(padding: const EdgeInsets.all(16), children: [Text(l.noData, style: const TextStyle(color: AppColors.textSecondary))]);
    return ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 28), children: byPlanet.entries.map((e) {
      return KFadeIn(child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.spa_rounded, color: KColors.green, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(KundliNames.planet(e.key, loc), style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w800))),
          ]),
          const SizedBox(height: 4),
          Text(e.value.join(' · '), style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
          const SizedBox(height: 12),
          ..._remedyRows(l, e.key),
        ]),
      ));
    }).toList());
  }

  List<Widget> _remedyRows(AppLocalizations l, String planet) {
    final r = _kRemedies[planet];
    if (r == null) return const [];
    final rows = <List<String>>[
      [l.remMantra, r['mantra']!],
      [l.remGemstone, r['gem']!],
      [l.remDonation, r['donate']!],
      [l.remTemple, r['temple']!],
      [l.remFasting, r['fast']!],
      [l.remLifestyle, l.remLifestyleGeneric],
    ];
    return rows.map((row) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 92, child: Text(row[0], style: const TextStyle(color: KColors.green, fontSize: 12, fontWeight: FontWeight.w700))),
            Expanded(child: Text(row[1], style: const TextStyle(color: AppColors.parchment, fontSize: 12.5))),
          ]),
        )).toList();
  }

  // ── Explain sheet ─────────────────────────────────────────────────────
  void _showExplain(AppLocalizations l) {
    final active = _active.length;
    final bullets = <String>[l.doshHeroSummary('$active', '$_total'), l.doshExplainReassure];
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5, minChildSize: 0.35, maxChildSize: 0.85, expand: false,
        builder: (bctx, scroll) => Container(
          decoration: const BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
          child: ListView(controller: scroll, padding: const EdgeInsets.fromLTRB(18, 10, 18, 28), children: [
            Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.ash, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Row(children: [const Text('✨', style: TextStyle(fontSize: 20)), const SizedBox(width: 10),
              Expanded(child: Text(l.doshExplain, style: const TextStyle(color: AppColors.goldBright, fontSize: 17, fontWeight: FontWeight.w800)))]),
            const SizedBox(height: 6),
            Text(l.doshExplainSubtitle, style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
            const SizedBox(height: 16),
            ...bullets.map((b) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(padding: const EdgeInsets.only(top: 2, right: 10), child: Icon(Icons.auto_awesome, size: 15, color: AppColors.lavender.withOpacity(0.9))),
              Expanded(child: Text(b, style: const TextStyle(color: AppColors.parchment, fontSize: 13.5, height: 1.5))),
            ]))),
          ]),
        ),
      ),
    );
  }

  // ── Detail bottom sheet ───────────────────────────────────────────────
  void _showDetail(AppLocalizations l, Map<String, dynamic> d) {
    final loc = Localizations.localeOf(context);
    final score = (d['score'] as num?)?.toDouble() ?? 0;
    final color = doshColor(score);
    final factors = (d['factors'] as List? ?? []);
    final cancels = (d['cancels'] as List? ?? []);
    final planet = doshPrimaryPlanet(_doshName(d), factors);
    final areas = planet == null ? <String>[] : (_kPlanetAreas[planet] ?? const []);

    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.78, minChildSize: 0.5, maxChildSize: 0.95, expand: false,
        builder: (bctx, scroll) => Container(
          decoration: const BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
          child: ListView(controller: scroll, padding: const EdgeInsets.fromLTRB(18, 10, 18, 28), children: [
            Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.ash, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Row(children: [
              Container(width: 6, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_doshName(d), style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w800)),
                Text('${d['category'] ?? ''}', style: const TextStyle(color: AppColors.smoke, fontSize: 11.5)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                KStars(filled: doshStars(score), size: 14, color: color),
                Text('${score.toStringAsFixed(0)}% · ${doshSeverityLabel(score, l)}', style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
              ]),
            ]),
            const SizedBox(height: 16),
            if ((d['description'] ?? '').toString().isNotEmpty)
              _sheetBlock(l.doshDefinition, d['description'].toString()),
            if (factors.isNotEmpty)
              _sheetBlock(l.doshFormationRule, factors.join('\n')),
            if (planet != null)
              _sheetBlock(l.doshSupportingPlanets, KundliNames.planet(planet, loc)),
            if (areas.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(l.doshAffectedAreas, style: const TextStyle(color: AppColors.gold, fontSize: 12.5, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: areas.map((a) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(color: color.withOpacity(0.14), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.4))),
                child: Text(areaLabel(a, l), style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w600)),
              )).toList()),
              const SizedBox(height: 8),
            ],
            _sheetBlock(l.plStrength, '${score.toStringAsFixed(0)}% · ${doshSeverityLabel(score, l)}'),
            _sheetBlock(l.doshCancellation, cancels.isEmpty ? l.doshNoCancellation : cancels.join(', ')),
            if (planet != null) ...[
              const SizedBox(height: 6),
              Text(l.bhRemedies, style: const TextStyle(color: KColors.green, fontSize: 12.5, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              ..._remedyRows(l, planet),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.twilight.withOpacity(0.4), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.lavender.withOpacity(0.25))),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 14))),
                Expanded(child: Text(
                  planet == null ? l.doshAiGeneric : l.doshAiLine(areas.map((a) => areaLabel(a, l)).join(', '), KundliNames.planet(planet, loc)),
                  style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, height: 1.45))),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _sheetBlock(String title, String body) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: AppColors.gold, fontSize: 12.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(body, style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, height: 1.45)),
        ]),
      );

  String _doshName(Map<String, dynamic> d) => (d['name_local'] ?? d['name'] ?? '').toString();
}

// ═══════════════════════════════════════════════════════════════════════
//  Expandable dosha card (Detailed tab)
// ═══════════════════════════════════════════════════════════════════════
class _DoshCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDetail;
  const _DoshCard({required this.data, required this.onDetail});
  @override
  State<_DoshCard> createState() => _DoshCardState();
}

class _DoshCardState extends State<_DoshCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context);
    final d = widget.data;
    final score = (d['score'] as num?)?.toDouble() ?? 0;
    final color = doshColor(score);
    final name = (d['name_local'] ?? d['name'] ?? '').toString();
    final factors = (d['factors'] as List? ?? []);
    final planet = doshPrimaryPlanet(name, factors);
    final areas = planet == null ? <String>[] : (_kPlanetAreas[planet] ?? const []);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.35))),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(width: 6, height: 42, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 14.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Row(children: [
                  KStars(filled: doshStars(score), size: 12, color: color),
                  const SizedBox(width: 8),
                  Text(doshSeverityLabel(score, l), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
                ]),
              ])),
              Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(width: 6),
              AnimatedRotation(turns: _open ? 0.5 : 0, duration: const Duration(milliseconds: 240), child: Icon(Icons.expand_more, color: color)),
            ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Divider(height: 1),
              const SizedBox(height: 10),
              _row(l.doshCategory, (d['category'] ?? '—').toString()),
              if (planet != null) _row(l.doshSupportingPlanets, KundliNames.planet(planet, loc)),
              _row(l.doshConfidence, '${score.toStringAsFixed(0)}%'),
              if ((d['description'] ?? '').toString().isNotEmpty) ...[
                const SizedBox(height: 6),
                Text((d['description']).toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 12.3, height: 1.4)),
              ],
              if (factors.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(l.doshWhyFormed, style: const TextStyle(color: AppColors.gold, fontSize: 11.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(factors.join('\n'), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.4)),
              ],
              if (areas.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(l.doshAffectedAreas, style: const TextStyle(color: AppColors.gold, fontSize: 11.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Wrap(spacing: 6, runSpacing: 6, children: areas.map((a) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(color: color.withOpacity(0.14), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.4))),
                  child: Text(areaLabel(a, l), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                )).toList()),
              ],
              if (planet != null) ...[
                const SizedBox(height: 10),
                Text(l.doshTimeline, style: const TextStyle(color: AppColors.gold, fontSize: 11.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(l.doshTimelineLine(KundliNames.planet(planet, loc)), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.4)),
              ],
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(color: AppColors.twilight.withOpacity(0.4), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.lavender.withOpacity(0.25))),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 13))),
                  Expanded(child: Text(
                    planet == null ? l.doshAiGeneric : l.doshAiLine(areas.map((a) => areaLabel(a, l)).join(', '), KundliNames.planet(planet, loc)),
                    style: const TextStyle(color: AppColors.parchment, fontSize: 12.3, height: 1.45))),
                ]),
              ),
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: TextButton.icon(
                onPressed: widget.onDetail,
                icon: const Icon(Icons.arrow_forward, size: 15, color: AppColors.gold),
                label: Text(l.doshDefinition, style: const TextStyle(color: AppColors.gold, fontSize: 12.5, fontWeight: FontWeight.w700)),
              )),
            ]),
          ),
          crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 260), sizeCurve: Curves.easeInOut,
        ),
      ]),
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 110, child: Text(k, style: const TextStyle(color: AppColors.smoke, fontSize: 12))),
          Expanded(child: Text(v, style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, fontWeight: FontWeight.w600))),
        ]),
      );
}
