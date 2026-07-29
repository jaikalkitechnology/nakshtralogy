import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '../../../utils/kundli_names.dart';
import '_section_loader.dart';
import 'kundli_ui.dart';

/// Redesigned YOGA screen — celebratory hero, category tabs, ranking and
/// expandable yoga cards with strength, benefits, affected areas and
/// activation, plus a detail bottom sheet and an "Explain My Yogas" summary.
///
/// Presentation only — scores/factors/enhancers/reducers come from the API
/// (yoga_analysis). Affected areas / activation are derived from each yoga's
/// primary planet (fixed Vedic constants) — no calculation is changed.
class YogaWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const YogaWidget({super.key, required this.chartId, this.initial});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliYoga(chartId),
      builder: (ctx, data) => _YogaView(data: data),
    );
  }
}

// ── strength (by score) — Gold/Green/Blue/Yellow/Gray ────────────────────
Color yogaColor(num s) {
  if (s >= 90) return KColors.gold;
  if (s >= 70) return KColors.green;
  if (s >= 50) return KColors.blue;
  if (s >= 30) return KColors.yellow;
  return AppColors.smoke;
}

String yogaStrengthLabel(num s, AppLocalizations l) {
  if (s >= 90) return l.gradeExcellent;
  if (s >= 70) return l.sumStrong;
  if (s >= 50) return l.yogaHelpful;
  if (s >= 30) return l.avModerate;
  return l.yogaInactive;
}

int yogaStars(num s) => (s / 20).ceil().clamp(1, 5);

const List<String> _kPlanets = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn', 'Rahu', 'Ketu'];

String? yogaPrimaryPlanet(String name, List factors) {
  final hay = '$name ${factors.join(' ')}';
  for (final p in _kPlanets) {
    if (hay.contains(p)) return p;
  }
  final n = name.toLowerCase();
  if (n.contains('hamsa') || n.contains('guru') || n.contains('gaja')) return 'Jupiter';
  if (n.contains('malavya') || n.contains('shukra')) return 'Venus';
  if (n.contains('bhadra') || n.contains('budh')) return 'Mercury';
  if (n.contains('ruchaka') || n.contains('mangal')) return 'Mars';
  if (n.contains('shasha') || n.contains('shani')) return 'Saturn';
  if (n.contains('sunapha') || n.contains('anapha') || n.contains('chandra') || n.contains('gajakesari')) return 'Moon';
  if (n.contains('surya') || n.contains('veshi')) return 'Sun';
  return null;
}

const Map<String, List<String>> _kPlanetAreas = {
  'Sun': ['career', 'health'], 'Moon': ['mind', 'health'], 'Mars': ['career', 'marriage'],
  'Mercury': ['education', 'finance'], 'Jupiter': ['education', 'children'], 'Venus': ['marriage', 'finance'],
  'Saturn': ['career', 'finance'], 'Rahu': ['career', 'mind'], 'Ketu': ['spiritual', 'mind'],
};

String yogaAreaLabel(String t, AppLocalizations l) {
  switch (t) {
    case 'career': return l.careerWord;
    case 'marriage': return l.lifeAreaMarriage;
    case 'health': return l.lifeHealth;
    case 'finance': return l.avFinance;
    case 'education': return l.educationWord;
    case 'children': return l.doshAreaChildren;
    case 'spiritual': return l.sumSpirituality;
    default: return l.doshAreaMind;
  }
}

// category -> tab-group token
String _tabOf(String category) {
  switch (category) {
    case 'Career Yoga': case 'Buddhi Yoga': return 'career';
    case 'Dhan Yoga': return 'money';
    case 'Marriage Yoga': return 'marriage';
    case 'Spiritual Yoga': case 'Moon Yoga': return 'spiritual';
    case 'Raj Yoga': case 'Special Yoga': return 'rare';
    default: return 'other';
  }
}

// ═══════════════════════════════════════════════════════════════════════
class _YogaView extends StatefulWidget {
  final Map<String, dynamic> data;
  const _YogaView({required this.data});
  @override
  State<_YogaView> createState() => _YogaViewState();
}

class _YogaViewState extends State<_YogaView> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 6, vsync: this);
  static const _tabTokens = ['overview', 'career', 'money', 'marriage', 'spiritual', 'rare'];

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  int get _total => (widget.data['total'] as num?)?.toInt() ?? 0;

  List<Map<String, dynamic>> get _active {
    final list = (widget.data['yogas'] as List? ?? []).cast<dynamic>();
    return list.map((e) => (e as Map).cast<String, dynamic>()).where((y) => y['present'] == true).toList()
      ..sort((a, b) => ((b['score'] as num?) ?? 0).compareTo((a['score'] as num?) ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      TabBar(
        controller: _tabs,
        isScrollable: true,
        indicatorColor: AppColors.gold, labelColor: AppColors.gold, unselectedLabelColor: AppColors.smoke,
        labelStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
        tabs: [
          Tab(text: l.bhOverview), Tab(text: l.careerWord), Tab(text: l.yogaTabMoney),
          Tab(text: l.lifeAreaMarriage), Tab(text: l.sumSpirituality), Tab(text: l.yogaTabRare),
        ],
      ),
      Expanded(child: TabBarView(controller: _tabs, children: _tabTokens.map((t) => _tab(l, t)).toList())),
    ]);
  }

  Widget _tab(AppLocalizations l, String token) {
    if (token == 'overview') return _overview(l);
    final items = _active.where((y) => _tabOf((y['category'] ?? '').toString()) == token).toList();
    if (items.isEmpty) {
      return Center(child: Padding(padding: const EdgeInsets.all(24),
          child: Text(l.yogaNoneInCategory, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary))));
    }
    return ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        children: List.generate(items.length, (i) => KFadeIn(delayMs: i * 25, child: _YogaCard(data: items[i], onDetail: () => _showDetail(l, items[i])))));
  }

  // fortune rating from strong active yogas
  String _fortune(AppLocalizations l) {
    final active = _active;
    if (active.isEmpty) return l.gradeAverage;
    final top = active.first;
    final strongCount = active.where((y) => ((y['score'] as num?) ?? 0) >= 70).length;
    if (strongCount >= 3 || ((top['score'] as num?) ?? 0) >= 95) return l.gradeExcellent;
    if (strongCount >= 1) return l.gradeGood;
    return l.gradeAverage;
  }

  Color _fortuneColor() {
    final active = _active;
    if (active.isEmpty) return KColors.yellow;
    final top = active.first;
    final strongCount = active.where((y) => ((y['score'] as num?) ?? 0) >= 70).length;
    if (strongCount >= 3 || ((top['score'] as num?) ?? 0) >= 95) return KColors.gold;
    if (strongCount >= 1) return KColors.green;
    return KColors.yellow;
  }

  // ═════════════════════════ OVERVIEW ═════════════════════════════════
  Widget _overview(AppLocalizations l) {
    final active = _active;
    final top5 = active.take(5).toList();
    return ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 28), children: [
      KFadeIn(child: _explainButton(l)),
      const SizedBox(height: 14),
      KFadeIn(delayMs: 60, child: _hero(l)),
      const SizedBox(height: 18),
      KFadeIn(delayMs: 120, child: _legend(l)),
      if (top5.isNotEmpty) ...[
        const SizedBox(height: 18),
        KFadeIn(delayMs: 150, child: KSectionHeader(icon: Icons.emoji_events_rounded, title: l.yogaRanking, color: KColors.gold)),
        KFadeIn(delayMs: 170, child: _ranking(l, top5)),
      ],
      const SizedBox(height: 18),
      if (active.isEmpty)
        Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(l.yogaNoneActive, style: const TextStyle(color: AppColors.textSecondary))))
      else ...[
        KFadeIn(delayMs: 200, child: KSectionHeader(icon: Icons.auto_awesome, title: l.yoga, color: KColors.green)),
        ...List.generate(active.length, (i) => KFadeIn(delayMs: 220 + i * 20, child: _compactCard(l, active[i]))),
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
              Flexible(child: Text(l.yogaExplain, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.midnight, fontSize: 13.5, fontWeight: FontWeight.w800))),
            ])),
        ),
      );

  Widget _hero(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final active = _active;
    final top = active.isEmpty ? null : active.first;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF2A2358), Color(0xFF1A1642)]),
        borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('✨', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(child: Text(l.yogaSummaryTitle, style: const TextStyle(color: AppColors.goldBright, fontSize: 16.5, fontWeight: FontWeight.w800))),
        ]),
        const SizedBox(height: 16),
        Wrap(spacing: 10, runSpacing: 10, children: [
          _tile(l.yogaActiveYogas, '${active.length}', KColors.green),
          _tile(l.yogaTotalYogas, '$_total', KColors.blue),
          _tile(l.yogaMostPowerful, top == null ? '—' : _name(top), KColors.gold),
          _tile(l.yogaFortuneRating, _fortune(l), _fortuneColor()),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.18), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.lavender.withOpacity(0.25))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 15))),
            Expanded(child: Text(l.yogaHeroSummary('${active.length}', _topPlanets(loc)), style: const TextStyle(color: AppColors.parchment, fontSize: 13, height: 1.5))),
          ]),
        ),
      ]),
    );
  }

  String _topPlanets(Locale loc) {
    final ps = <String>[];
    for (final y in _active.take(4)) {
      final p = yogaPrimaryPlanet(_name(y), (y['factors'] as List? ?? []));
      if (p != null && !ps.contains(p)) ps.add(p);
      if (ps.length >= 2) break;
    }
    if (ps.isEmpty) return '—';
    return ps.map((p) => KundliNames.planet(p, loc)).join(' & ');
  }

  Widget _tile(String label, String value, Color color) => Container(
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.35))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 9, letterSpacing: 0.5, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 3),
          Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
        ]),
      );

  Widget _legend(AppLocalizations l) {
    final items = [
      [KColors.gold, l.gradeExcellent], [KColors.green, l.sumStrong], [KColors.blue, l.yogaHelpful],
      [KColors.yellow, l.avModerate], [AppColors.smoke, l.yogaInactive],
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Wrap(spacing: 12, runSpacing: 7, alignment: WrapAlignment.center, children: items.map((it) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 11, height: 11, decoration: BoxDecoration(color: it[0] as Color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 5),
        Text(it[1] as String, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w600)),
      ])).toList()),
    );
  }

  Widget _ranking(AppLocalizations l, List<Map<String, dynamic>> top5) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(children: List.generate(top5.length, (i) {
        final y = top5[i];
        final s = (y['score'] as num?)?.toDouble() ?? 0;
        final color = yogaColor(s);
        final medal = i == 0 ? '🥇' : i == 1 ? '🥈' : i == 2 ? '🥉' : '${i + 1}';
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showDetail(l, y),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(children: [
              SizedBox(width: 28, child: Text(medal, style: const TextStyle(fontSize: 14))),
              Expanded(child: Text(_name(y), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700))),
              KStars(filled: yogaStars(s), size: 12, color: color),
              const SizedBox(width: 8),
              SizedBox(width: 34, child: Text(s.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800))),
            ]),
          ),
        );
      })),
    );
  }

  Widget _compactCard(AppLocalizations l, Map<String, dynamic> y) {
    final score = (y['score'] as num?)?.toDouble() ?? 0;
    final color = yogaColor(score);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showDetail(l, y),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.3))),
        child: Row(children: [
          Container(width: 6, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_name(y), style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w800)),
            const SizedBox(height: 3),
            Text('${y['category'] ?? ''}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            KStars(filled: yogaStars(score), size: 13, color: color),
            const SizedBox(height: 4),
            Text(yogaStrengthLabel(score, l), style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
          ]),
          const Icon(Icons.chevron_right, color: AppColors.smoke, size: 20),
        ]),
      ),
    );
  }

  // ── Explain sheet ─────────────────────────────────────────────────────
  void _showExplain(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final active = _active;
    final bullets = <String>[
      l.yogaHeroSummary('${active.length}', _topPlanets(loc)),
      l.yogaExplainReassure,
    ];
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
              Expanded(child: Text(l.yogaExplain, style: const TextStyle(color: AppColors.goldBright, fontSize: 17, fontWeight: FontWeight.w800)))]),
            const SizedBox(height: 6),
            Text(l.yogaExplainSubtitle, style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
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
  void _showDetail(AppLocalizations l, Map<String, dynamic> y) {
    final loc = Localizations.localeOf(context);
    final score = (y['score'] as num?)?.toDouble() ?? 0;
    final color = yogaColor(score);
    final factors = (y['factors'] as List? ?? []);
    final reducers = (y['reducers'] as List? ?? []);
    final planet = yogaPrimaryPlanet(_name(y), factors);
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
                Text(_name(y), style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w800)),
                Text('${y['category'] ?? ''}', style: const TextStyle(color: AppColors.smoke, fontSize: 11.5)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                KStars(filled: yogaStars(score), size: 14, color: color),
                Text('${score.toStringAsFixed(0)}% · ${yogaStrengthLabel(score, l)}', style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
              ]),
            ]),
            const SizedBox(height: 16),
            if ((y['description'] ?? '').toString().isNotEmpty)
              _block(l.yogaBenefits, y['description'].toString(), color),
            if (factors.isNotEmpty)
              _block(l.doshFormationRule, factors.join('\n'), AppColors.gold),
            if (planet != null)
              _block(l.yogaSupportingPlanets, KundliNames.planet(planet, loc), AppColors.gold),
            if (areas.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(l.doshAffectedAreas, style: const TextStyle(color: AppColors.gold, fontSize: 12.5, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: areas.map((a) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(color: color.withOpacity(0.14), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.4))),
                child: Text(yogaAreaLabel(a, l), style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w600)),
              )).toList()),
              const SizedBox(height: 8),
            ],
            _block(l.plStrength, '${score.toStringAsFixed(0)}% · ${yogaStrengthLabel(score, l)}', color),
            _block(l.doshCancellation, reducers.isEmpty ? l.doshNoCancellation : reducers.join(', '), AppColors.gold),
            if (planet != null)
              _block(l.doshTimeline, l.doshTimelineLine(KundliNames.planet(planet, loc)), AppColors.gold),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.twilight.withOpacity(0.4), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.lavender.withOpacity(0.25))),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 14))),
                Expanded(child: Text(
                  areas.isEmpty ? l.yogaAiGeneric : l.yogaAiLine(_name(y), areas.map((a) => yogaAreaLabel(a, l)).join(', ')),
                  style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, height: 1.45))),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _block(String title, String body, Color titleColor) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(color: titleColor, fontSize: 12.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(body, style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, height: 1.45)),
        ]),
      );

  String _name(Map<String, dynamic> y) => (y['name_local'] ?? y['name'] ?? '').toString();
}

// ═══════════════════════════════════════════════════════════════════════
//  Expandable yoga card (category tabs)
// ═══════════════════════════════════════════════════════════════════════
class _YogaCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDetail;
  const _YogaCard({required this.data, required this.onDetail});
  @override
  State<_YogaCard> createState() => _YogaCardState();
}

class _YogaCardState extends State<_YogaCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context);
    final y = widget.data;
    final score = (y['score'] as num?)?.toDouble() ?? 0;
    final color = yogaColor(score);
    final name = (y['name_local'] ?? y['name'] ?? '').toString();
    final factors = (y['factors'] as List? ?? []);
    final planet = yogaPrimaryPlanet(name, factors);
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
                  KStars(filled: yogaStars(score), size: 12, color: color),
                  const SizedBox(width: 8),
                  Text(yogaStrengthLabel(score, l), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
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
              _row(l.doshCategory, (y['category'] ?? '—').toString()),
              if (planet != null) _row(l.yogaSupportingPlanets, KundliNames.planet(planet, loc)),
              _row(l.doshConfidence, '${score.toStringAsFixed(0)}%'),
              if ((y['description'] ?? '').toString().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(l.yogaBenefits, style: const TextStyle(color: AppColors.gold, fontSize: 11.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text((y['description']).toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 12.3, height: 1.4)),
              ],
              if (factors.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(l.doshFormationRule, style: const TextStyle(color: AppColors.gold, fontSize: 11.5, fontWeight: FontWeight.w800)),
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
                  child: Text(yogaAreaLabel(a, l), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                )).toList()),
              ],
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(color: AppColors.twilight.withOpacity(0.4), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.lavender.withOpacity(0.25))),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 13))),
                  Expanded(child: Text(
                    areas.isEmpty ? l.yogaAiGeneric : l.yogaAiLine(name, areas.map((a) => yogaAreaLabel(a, l)).join(', ')),
                    style: const TextStyle(color: AppColors.parchment, fontSize: 12.3, height: 1.45))),
                ]),
              ),
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: TextButton.icon(
                onPressed: widget.onDetail,
                icon: const Icon(Icons.arrow_forward, size: 15, color: AppColors.gold),
                label: Text(l.doshFormationRule, style: const TextStyle(color: AppColors.gold, fontSize: 12.5, fontWeight: FontWeight.w700)),
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
