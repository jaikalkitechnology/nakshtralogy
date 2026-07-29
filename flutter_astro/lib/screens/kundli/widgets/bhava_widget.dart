import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '../../../utils/kundli_names.dart';
import '_section_loader.dart';
import 'kundli_ui.dart';

/// Redesigned BHAVA (houses) screen — Overview/Detailed tabs, a strength hero
/// card, expandable per-house cards, a strength ranking and an "Explain My
/// Houses" summary. Presentation only; scores/SAV/occupants/lord all come from
/// the API (bhava_strength). [planets]/[aspects]/[shadbala] are optional extra
/// context from /analysis/complete used for lord condition + aspects received.
class BhavaWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  final Map<String, dynamic>? planets;
  final Map<String, dynamic>? aspects;
  final Map<String, dynamic>? shadbala;
  const BhavaWidget({super.key, required this.chartId, this.initial, this.planets, this.aspects, this.shadbala});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliBhava(chartId),
      builder: (ctx, data) => _BhavaView(data: data, planets: planets, aspects: aspects, shadbala: shadbala),
    );
  }
}

const Color _cLightGreen = Color(0xFF8BC34A);

Color bhColor(num s) {
  if (s >= 75) return KColors.green;
  if (s >= 60) return _cLightGreen;
  if (s >= 45) return KColors.yellow;
  if (s >= 30) return KColors.orange;
  return KColors.red;
}

String bhLabel(num s, AppLocalizations l) {
  if (s >= 75) return l.gradeExcellent;
  if (s >= 60) return l.gradeGood;
  if (s >= 45) return l.gradeAverage;
  if (s >= 30) return l.gradeWeak;
  return l.avVeryWeak;
}

String houseNameOf(int h, AppLocalizations l) {
  switch (h) {
    case 1: return l.bhavaHouse1; case 2: return l.bhavaHouse2; case 3: return l.bhavaHouse3;
    case 4: return l.bhavaHouse4; case 5: return l.bhavaHouse5; case 6: return l.bhavaHouse6;
    case 7: return l.bhavaHouse7; case 8: return l.bhavaHouse8; case 9: return l.bhavaHouse9;
    case 10: return l.bhavaHouse10; case 11: return l.bhavaHouse11; default: return l.bhavaHouse12;
  }
}

String houseMeaningOf(int h, AppLocalizations l) {
  switch (h) {
    case 1: return l.plHouse1; case 2: return l.plHouse2; case 3: return l.plHouse3;
    case 4: return l.plHouse4; case 5: return l.plHouse5; case 6: return l.plHouse6;
    case 7: return l.plHouse7; case 8: return l.plHouse8; case 9: return l.plHouse9;
    case 10: return l.plHouse10; case 11: return l.plHouse11; default: return l.plHouse12;
  }
}

const List<String> _kSignsShort = ['Ar', 'Ta', 'Ge', 'Cn', 'Le', 'Vi', 'Li', 'Sc', 'Sg', 'Cp', 'Aq', 'Pi'];

// ═══════════════════════════════════════════════════════════════════════
class _BhavaView extends StatefulWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic>? planets;
  final Map<String, dynamic>? aspects;
  final Map<String, dynamic>? shadbala;
  const _BhavaView({required this.data, this.planets, this.aspects, this.shadbala});

  @override
  State<_BhavaView> createState() => _BhavaViewState();
}

class _BhavaViewState extends State<_BhavaView> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Map<int, Map<String, dynamic>> get _houses {
    final m = <int, Map<String, dynamic>>{};
    widget.data.forEach((k, v) {
      if (v is Map && (v['house'] ?? -1) is num) {
        m[(v['house'] as num).toInt()] = v.cast<String, dynamic>();
      }
    });
    return m;
  }

  double _scoreOf(int h) => (_houses[h]?['score'] as num?)?.toDouble() ?? 0;

  /// Planets aspecting a house (from aspect_matrix special_aspects + signs).
  List<String> _aspectsOnHouse(int houseSignIdx) {
    final special = (widget.aspects?['special_aspects'] as Map?)?.cast<String, dynamic>();
    final signs = (widget.aspects?['planet_signs'] as Map?)?.cast<String, dynamic>();
    if (special == null || signs == null) return const [];
    final out = <String>[];
    signs.forEach((p, v) {
      if (p == 'Lagna') return;
      final ps = (v as num?)?.toInt();
      final houses = (special[p] as List?)?.map((e) => (e as num).toInt()).toList();
      if (ps == null || houses == null) return;
      final rel = (houseSignIdx - ps) % 12 + 1;
      if (houses.contains(rel)) out.add(p);
    });
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      TabBar(
        controller: _tabs,
        indicatorColor: AppColors.gold,
        labelColor: AppColors.gold,
        unselectedLabelColor: AppColors.smoke,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        tabs: [Tab(text: l.bhOverview), Tab(text: l.bhDetailed)],
      ),
      Expanded(child: TabBarView(controller: _tabs, children: [_overview(l), _detailed(l)])),
    ]);
  }

  // ═════════════════════════ OVERVIEW ═════════════════════════════════
  Widget _overview(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    return ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 28), children: [
      KFadeIn(child: _explainButton(l)),
      const SizedBox(height: 14),
      KFadeIn(delayMs: 60, child: _heroCard(l)),
      const SizedBox(height: 18),
      KFadeIn(delayMs: 120, child: _legend(l)),
      const SizedBox(height: 18),
      KFadeIn(delayMs: 160, child: KSectionHeader(icon: Icons.leaderboard_rounded, title: l.bhRanking, color: KColors.blue)),
      KFadeIn(delayMs: 180, child: _ranking(l, loc)),
      const SizedBox(height: 18),
      KFadeIn(delayMs: 220, child: KSectionHeader(icon: Icons.home_rounded, title: l.bhavaHouses, color: KColors.purple)),
      ...List.generate(12, (i) {
        final h = i + 1;
        return KFadeIn(delayMs: 240 + i * 25, child: _HouseCard(
          house: h,
          data: _houses[h] ?? const {},
          planets: widget.planets,
          shadbala: widget.shadbala,
          aspectingPlanets: _aspectsForHouse(h),
        ));
      }),
    ]);
  }

  List<String> _aspectsForHouse(int h) {
    final hd = _houses[h];
    final sign = hd?['sign']?.toString();
    final si = sign != null ? _kSignsShort.indexOf(sign) : -1;
    if (si < 0) return const [];
    return _aspectsOnHouse(si);
  }

  Widget _explainButton(AppLocalizations l) {
    return Material(
      color: AppColors.gold,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => showExplainMyHouses(context, _houses),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('✨', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(l.bhExplain, style: const TextStyle(color: AppColors.midnight, fontSize: 14, fontWeight: FontWeight.w800)),
          ]),
        ),
      ),
    );
  }

  Widget _heroCard(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final scores = {for (int h = 1; h <= 12; h++) h: _scoreOf(h)};
    final avg = scores.values.fold(0.0, (a, b) => a + b) / 12;
    final sortedDesc = scores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final strong = sortedDesc.first.key;
    final weak = sortedDesc.last.key;
    final top2 = sortedDesc.take(2).map((e) => e.key).toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF2A2358), Color(0xFF1A1642)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('🏠', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(child: Text(l.bhStrengthOverview, style: const TextStyle(color: AppColors.goldBright, fontSize: 16.5, fontWeight: FontWeight.w800))),
        ]),
        const SizedBox(height: 16),
        // overall average gauge
        Row(children: [
          Text(l.bhOverallAverage, style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
          const Spacer(),
          Text('${avg.toStringAsFixed(0)}%', style: TextStyle(color: bhColor(avg), fontSize: 22, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: (avg / 100).clamp(0, 1)),
            duration: const Duration(milliseconds: 900), curve: Curves.easeOutCubic,
            builder: (_, v, __) => LinearProgressIndicator(value: v, minHeight: 11, backgroundColor: AppColors.ash.withOpacity(0.4), valueColor: AlwaysStoppedAnimation(bhColor(avg))),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(spacing: 10, runSpacing: 10, children: [
          _heroTile(l.bhStrongestHouse, '${kOrdinal(strong)} · ${houseNameOf(strong, l)}', bhColor(_scoreOf(strong))),
          _heroTile(l.bhWeakestHouse, '${kOrdinal(weak)} · ${houseNameOf(weak, l)}', bhColor(_scoreOf(weak))),
          _heroTile(l.bhBestArea, houseNameOf(strong, l), KColors.green),
          _heroTile(l.bhNeedsAttention, houseNameOf(weak, l), KColors.orange),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.18), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.lavender.withOpacity(0.25))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 15))),
            Expanded(child: Text(
              l.bhHeroSummary(kOrdinal(top2[0]), kOrdinal(top2[1]), houseNameOf(strong, l), houseNameOf(weak, l)),
              style: const TextStyle(color: AppColors.parchment, fontSize: 13, height: 1.5))),
          ]),
        ),
      ]),
    );
  }

  Widget _heroTile(String label, String value, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.35))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 9, letterSpacing: 0.5, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 3),
        Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
    );
  }

  Widget _legend(AppLocalizations l) {
    final items = [
      [KColors.green, l.gradeExcellent], [_cLightGreen, l.gradeGood], [KColors.yellow, l.gradeAverage],
      [KColors.orange, l.gradeWeak], [KColors.red, l.avVeryWeak],
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Wrap(spacing: 12, runSpacing: 7, alignment: WrapAlignment.center, children: items.map((it) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 11, height: 11, decoration: BoxDecoration(color: it[0] as Color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 5),
        Text(it[1] as String, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w600)),
      ])).toList()),
    );
  }

  Widget _ranking(AppLocalizations l, Locale loc) {
    final scores = [for (int h = 1; h <= 12; h++) MapEntry(h, _scoreOf(h))]..sort((a, b) => b.value.compareTo(a.value));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(children: List.generate(scores.length, (i) {
        final e = scores[i];
        final color = bhColor(e.value);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            SizedBox(width: 26, child: Text('#${i + 1}', style: const TextStyle(color: AppColors.smoke, fontSize: 11, fontWeight: FontWeight.w700))),
            SizedBox(width: 34, child: Text(kOrdinal(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w700))),
            Expanded(child: Text(houseNameOf(e.key, l), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.parchment, fontSize: 12))),
            SizedBox(width: 96, child: ClipRRect(borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: (e.value / 100).clamp(0, 1), minHeight: 6, backgroundColor: AppColors.ash.withOpacity(0.4), valueColor: AlwaysStoppedAnimation(color)))),
            const SizedBox(width: 8),
            SizedBox(width: 30, child: Text(e.value.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w800))),
          ]),
        );
      })),
    );
  }

  // ═════════════════════════ DETAILED ═════════════════════════════════
  Widget _detailed(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    Widget h(String t, int flex) => Expanded(flex: flex, child: Text(t, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)));
    return ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 28), children: [
      Container(
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Row(children: [
              h(l.house, 14), h(l.sign, 16), h(l.kunLord, 20), h(l.bhSav, 12), h(l.aspAspectWord, 12), h(l.plStrength, 18),
            ]),
          ),
          const Divider(height: 1),
          ...List.generate(12, (i) {
            final hn = i + 1;
            final hd = _houses[hn] ?? const {};
            final score = (hd['score'] as num?)?.toDouble() ?? 0;
            final sav = hd['sav']?.toString() ?? '—';
            final lord = hd['lord']?.toString() ?? '';
            final sign = hd['sign']?.toString() ?? '';
            final asp = _aspectsForHouse(hn).length;
            final occ = (hd['occupants'] as List? ?? const []);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Column(children: [
                Row(children: [
                  Expanded(flex: 14, child: Text(kOrdinal(hn), style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w700))),
                  Expanded(flex: 16, child: Text(sign.isEmpty ? '—' : KundliNames.rashiShort(sign, loc), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5))),
                  Expanded(flex: 20, child: Text(lord.isEmpty ? '—' : KundliNames.planet(lord, loc), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5))),
                  Expanded(flex: 12, child: Text(sav, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5))),
                  Expanded(flex: 12, child: Text('$asp', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5))),
                  Expanded(flex: 18, child: Row(children: [
                    Text(score.toStringAsFixed(0), style: TextStyle(color: bhColor(score), fontSize: 12.5, fontWeight: FontWeight.w800)),
                    const SizedBox(width: 4),
                    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: AppColors.ash.withOpacity(0.4), valueColor: AlwaysStoppedAnimation(bhColor(score))))),
                  ])),
                ]),
                if (occ.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Align(alignment: Alignment.centerLeft, child: Text(
                      '${l.kunPlanet}: ${occ.map((o) => KundliNames.planet(o.toString(), loc)).join(', ')}',
                      style: const TextStyle(color: AppColors.smoke, fontSize: 10.5))),
                  ),
                if (i < 11) Padding(padding: const EdgeInsets.only(top: 9), child: Divider(height: 1, color: AppColors.border.withOpacity(0.5))),
              ]),
            );
          }),
        ]),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Expandable house card
// ═══════════════════════════════════════════════════════════════════════
class _HouseCard extends StatefulWidget {
  final int house;
  final Map<String, dynamic> data;
  final Map<String, dynamic>? planets;
  final Map<String, dynamic>? shadbala;
  final List<String> aspectingPlanets;
  const _HouseCard({required this.house, required this.data, this.planets, this.shadbala, required this.aspectingPlanets});

  @override
  State<_HouseCard> createState() => _HouseCardState();
}

class _HouseCardState extends State<_HouseCard> {
  bool _open = false;

  double get _score => (widget.data['score'] as num?)?.toDouble() ?? 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context);
    final h = widget.house;
    final color = bhColor(_score);
    final occupants = (widget.data['occupants'] as List? ?? const []);
    final sign = widget.data['sign']?.toString();
    final lord = widget.data['lord']?.toString() ?? '';
    final sav = widget.data['sav'];

    // benefic / malefic influence among occupants + aspecting planets
    final influencers = <String>{...occupants.map((e) => e.toString()), ...widget.aspectingPlanets};
    final benefics = influencers.where(kIsBenefic).toList();
    final malefics = influencers.where((p) => !kIsBenefic(p) && p != 'Lagna').toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.35))),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              Row(children: [
                Container(width: 42, height: 42, alignment: Alignment.center,
                    decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: Text('$h', style: TextStyle(color: color, fontSize: 17, fontWeight: FontWeight.w800))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(houseNameOf(h, l), style: const TextStyle(color: AppColors.ivory, fontSize: 14.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text('${sign != null ? KundliNames.rashiShort(sign, loc) : '—'} · ${l.kunLord}: ${lord.isEmpty ? '—' : KundliNames.planet(lord, loc)}',
                      style: const TextStyle(color: AppColors.primary, fontSize: 11.5, fontWeight: FontWeight.w600)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(_score.toStringAsFixed(0), style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
                  Text(bhLabel(_score, l), style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(width: 6),
                AnimatedRotation(turns: _open ? 0.5 : 0, duration: const Duration(milliseconds: 240), child: Icon(Icons.expand_more, color: color)),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: KStars(filled: kStars(_score), size: 15, color: color)),
                if (sav != null) Text(l.bhSavContribution + ': $sav', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 8),
              ClipRRect(borderRadius: BorderRadius.circular(6),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: (_score / 100).clamp(0, 1)),
                    duration: const Duration(milliseconds: 800), curve: Curves.easeOutCubic,
                    builder: (_, v, __) => LinearProgressIndicator(value: v, minHeight: 7, backgroundColor: AppColors.ash.withOpacity(0.4), valueColor: AlwaysStoppedAnimation(color)))),
              if (occupants.isNotEmpty || benefics.isNotEmpty || malefics.isNotEmpty) ...[
                const SizedBox(height: 10),
                Align(alignment: Alignment.centerLeft, child: Wrap(spacing: 6, runSpacing: 6, children: [
                  if (occupants.isNotEmpty)
                    ...occupants.map((o) => _chip(KundliNames.planet(o.toString(), loc), AppColors.gold)),
                ])),
              ],
            ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: _expanded(l, loc, occupants, lord, benefics, malefics),
          crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 260),
          sizeCurve: Curves.easeInOut,
        ),
      ]),
    );
  }

  Widget _chip(String label, Color c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(color: c.withOpacity(0.14), borderRadius: BorderRadius.circular(20), border: Border.all(color: c.withOpacity(0.4))),
        child: Text(label, style: TextStyle(color: c, fontSize: 11.5, fontWeight: FontWeight.w600)),
      );

  Widget _expanded(AppLocalizations l, Locale loc, List occupants, String lord, List<String> benefics, List<String> malefics) {
    final h = widget.house;
    final meaning = houseMeaningOf(h, l);
    // lord condition
    String lordLine = lord.isEmpty ? '—' : KundliNames.planet(lord, loc);
    if (lord.isNotEmpty && widget.planets != null) {
      final lp = (widget.planets![lord] as Map?)?.cast<String, dynamic>();
      final lsi = (lp?['sign_idx'] as num?)?.toInt();
      if (lsi != null) {
        final rel = kSignRelation(lord, lsi, (lp?['dignity'] ?? '').toString());
        lordLine = l.bhLordLine(KundliNames.planet(lord, loc), kRelationLabel(rel, l));
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Divider(height: 1),
        const SizedBox(height: 12),
        _block(l.plHouseMeaning, meaning),
        _block(l.bhLordCondition, lordLine),
        if (widget.aspectingPlanets.isNotEmpty)
          _block(l.plAspectsReceived, widget.aspectingPlanets.map((e) => KundliNames.planet(e, loc)).join(', ')),
        // benefic / malefic influence
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: _influence(l.bhBenefic, benefics.map((e) => KundliNames.planet(e, loc)).toList(), KColors.green)),
          const SizedBox(width: 8),
          Expanded(child: _influence(l.bhMalefic, malefics.map((e) => KundliNames.planet(e, loc)).toList(), KColors.orange)),
        ]),
        const SizedBox(height: 10),
        _block(l.bhStrengthReasons, l.bhWhyLine((widget.data['sav'] ?? '—').toString())),
        _block(l.bhGoodEffects, l.bhGoodLine(meaning)),
        _block(l.bhChallenges, l.bhChallengeLine(meaning)),
        if (lord.isNotEmpty) _block(l.bhRemedies, l.bhRemedyLine(KundliNames.planet(lord, loc))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(color: AppColors.twilight.withOpacity(0.4), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.lavender.withOpacity(0.25))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 13))),
            Expanded(child: Text(l.bhCardAi(houseNameOf(h, l), bhLabel(_score, l), meaning), style: const TextStyle(color: AppColors.parchment, fontSize: 12.3, height: 1.45))),
          ]),
        ),
      ]),
    );
  }

  Widget _block(String title, String body) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: AppColors.gold, fontSize: 11.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(body, style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.4)),
        ]),
      );

  Widget _influence(String label, List<String> names, Color c) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: c.withOpacity(0.10), borderRadius: BorderRadius.circular(10), border: Border.all(color: c.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(names.isEmpty ? '—' : names.join(', '), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, fontWeight: FontWeight.w600)),
        ]),
      );
}

// ═══════════════════════════════════════════════════════════════════════
//  ✨ Explain My Houses
// ═══════════════════════════════════════════════════════════════════════
void showExplainMyHouses(BuildContext context, Map<int, Map<String, dynamic>> houses) {
  final l = AppLocalizations.of(context)!;
  final scores = {for (int h = 1; h <= 12; h++) h: (houses[h]?['score'] as num?)?.toDouble() ?? 0};
  final sorted = scores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  final strong = sorted.first.key, weak = sorted.last.key;
  final top2 = sorted.take(2).map((e) => e.key).toList();

  final bullets = <String>[
    l.bhHeroSummary(kOrdinal(top2[0]), kOrdinal(top2[1]), houseNameOf(strong, l), houseNameOf(weak, l)),
    l.bhCardAi(houseNameOf(strong, l), bhLabel(scores[strong]!, l), houseMeaningOf(strong, l)),
    l.bhCardAi(houseNameOf(weak, l), bhLabel(scores[weak]!, l), houseMeaningOf(weak, l)),
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.55, minChildSize: 0.4, maxChildSize: 0.9, expand: false,
      builder: (bctx, scroll) => Container(
        decoration: const BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
        child: ListView(controller: scroll, padding: const EdgeInsets.fromLTRB(18, 10, 18, 28), children: [
          Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.ash, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 14),
          Row(children: [
            const Text('✨', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(child: Text(l.bhExplain, style: const TextStyle(color: AppColors.goldBright, fontSize: 18, fontWeight: FontWeight.w800))),
          ]),
          const SizedBox(height: 6),
          Text(l.bhExplainSubtitle, style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
          const SizedBox(height: 16),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(padding: const EdgeInsets.only(top: 2, right: 10), child: Icon(Icons.auto_awesome, size: 15, color: AppColors.lavender.withOpacity(0.9))),
                  Expanded(child: Text(b, style: const TextStyle(color: AppColors.parchment, fontSize: 13.5, height: 1.5))),
                ]),
              )),
        ]),
      ),
    ),
  );
}
