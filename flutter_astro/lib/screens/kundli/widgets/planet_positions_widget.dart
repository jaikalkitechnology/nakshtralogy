import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/kundli_names.dart';
import 'kundli_ui.dart';

/// Redesigned PLANETS tab — expandable planet cards with state badges, a
/// strength meter, aspects, house/nakshatra meaning and an AI interpretation.
///
/// Presentation only. [planetsMap] is chart.planets; [complete] is the
/// prefetched /analysis/complete bundle (shadbala + aspect_matrix). Sign
/// relationships (friend/enemy/neutral), nature, element and gender are fixed
/// Vedic constants derived on the client — no backend calculation is changed.
class PlanetPositionsWidget extends StatefulWidget {
  final Map<String, dynamic> planetsMap;
  final Map<String, dynamic>? complete;
  const PlanetPositionsWidget({super.key, required this.planetsMap, this.complete});

  @override
  State<PlanetPositionsWidget> createState() => _PlanetPositionsWidgetState();
}

class _PlanetPositionsWidgetState extends State<PlanetPositionsWidget> {
  static const _order = ['Lagna', 'Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn', 'Rahu', 'Ketu'];
  static const _signsShort = ['Ar', 'Ta', 'Ge', 'Cn', 'Le', 'Vi', 'Li', 'Sc', 'Sg', 'Cp', 'Aq', 'Pi'];
  String _query = '';

  int get _lagnaIdx => ((widget.planetsMap['Lagna'] as Map?)?['sign_idx'] as num?)?.toInt() ?? 0;

  Map<String, dynamic>? get _shadbala =>
      ((widget.complete?['shadbala'] as Map?)?['planets'] as Map?)?.cast<String, dynamic>();
  Map<String, dynamic>? get _aspects =>
      (widget.complete?['aspect_matrix'] as Map?)?.cast<String, dynamic>();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context);

    final items = <Map<String, dynamic>>[];
    for (final name in _order) {
      final p = widget.planetsMap[name];
      if (p is Map) items.add({'_name': name, ...p.cast<String, dynamic>()});
    }
    // search filter (planet name in any form, or sign)
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty ? items : items.where((p) {
      final name = (p['_name'] ?? '').toString().toLowerCase();
      final local = (p['planet_local'] ?? '').toString().toLowerCase();
      final sign = (p['sign_full'] ?? '').toString().toLowerCase();
      return name.contains(q) || local.contains(q) || sign.contains(q);
    }).toList();

    if (items.isEmpty) {
      return Center(child: Text(l.noData, style: const TextStyle(color: AppColors.textSecondary)));
    }

    return Column(children: [
      // search
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
        child: TextField(
          onChanged: (v) => setState(() => _query = v),
          style: const TextStyle(color: AppColors.ivory, fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            hintText: l.plSearchHint,
            prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.smoke),
            suffixIcon: q.isEmpty ? null : IconButton(
              icon: const Icon(Icons.close, size: 18, color: AppColors.smoke),
              onPressed: () => setState(() => _query = ''),
            ),
          ),
        ),
      ),
      Expanded(
        child: filtered.isEmpty
            ? Center(child: Text(l.plNoResults, style: const TextStyle(color: AppColors.textSecondary)))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final p = filtered[i];
                  final name = p['_name']?.toString() ?? '';
                  return KFadeIn(
                    delayMs: (i * 35).clamp(0, 280),
                    child: _PlanetCard(
                      key: ValueKey(name),
                      planet: name,
                      data: p,
                      lagnaIdx: _lagnaIdx,
                      score: (name == 'Lagna') ? null : (_shadbala?[name]?['score_100'] as num?)?.toDouble(),
                      aspects: _aspects,
                      allPlanets: widget.planetsMap,
                      loc: loc,
                    ),
                  );
                },
              ),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════
class _PlanetCard extends StatefulWidget {
  final String planet;
  final Map<String, dynamic> data;
  final int lagnaIdx;
  final double? score;
  final Map<String, dynamic>? aspects;
  final Map<String, dynamic> allPlanets;
  final Locale loc;
  const _PlanetCard({
    super.key,
    required this.planet,
    required this.data,
    required this.lagnaIdx,
    required this.score,
    required this.aspects,
    required this.allPlanets,
    required this.loc,
  });

  @override
  State<_PlanetCard> createState() => _PlanetCardState();
}

class _PlanetCardState extends State<_PlanetCard> {
  bool _open = false;

  static const _signsShort = ['Ar', 'Ta', 'Ge', 'Cn', 'Le', 'Vi', 'Li', 'Sc', 'Sg', 'Cp', 'Aq', 'Pi'];

  int get _signIdx => (widget.data['sign_idx'] as num?)?.toInt() ?? 0;
  int get _house => (_signIdx - widget.lagnaIdx) % 12 + 1;

  String _symbol(String name) {
    const s = {'Sun': '☉', 'Moon': '☾', 'Mars': '♂', 'Mercury': '☿', 'Jupiter': '♃',
      'Venus': '♀', 'Saturn': '♄', 'Rahu': '☊', 'Ketu': '☋', 'Lagna': '↑'};
    return s[name] ?? '✦';
  }

  String _karakatva(AppLocalizations l, String p) {
    switch (p) {
      case 'Sun': return l.aspTraitSun;
      case 'Moon': return l.aspTraitMoon;
      case 'Mars': return l.aspTraitMars;
      case 'Mercury': return l.aspTraitMercury;
      case 'Jupiter': return l.aspTraitJupiter;
      case 'Venus': return l.aspTraitVenus;
      case 'Saturn': return l.aspTraitSaturn;
      case 'Rahu': return l.aspTraitRahu;
      case 'Ketu': return l.aspTraitKetu;
      default: return '';
    }
  }

  String _houseMeaning(AppLocalizations l, int h) {
    switch (h) {
      case 1: return l.plHouse1; case 2: return l.plHouse2; case 3: return l.plHouse3;
      case 4: return l.plHouse4; case 5: return l.plHouse5; case 6: return l.plHouse6;
      case 7: return l.plHouse7; case 8: return l.plHouse8; case 9: return l.plHouse9;
      case 10: return l.plHouse10; case 11: return l.plHouse11; default: return l.plHouse12;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final loc = widget.loc;
    final p = widget.data;
    final planet = widget.planet;
    final isLagna = planet == 'Lagna';
    final name = (p['planet_local'] ?? planet).toString();
    final signName = (p['sign_full_local'] ?? p['sign_full'] ?? '').toString();
    final degree = (p['degree'] as num?)?.toStringAsFixed(2) ?? '—';
    final dignity = (p['dignity'] ?? '').toString();
    final rel = isLagna ? '' : kSignRelation(planet, _signIdx, dignity);
    final relColor = rel.isEmpty ? AppColors.smoke : kRelationColor(rel);

    // badges
    final badges = <Widget>[];
    if (p['vakri'] == true) badges.add(_badge(l.sumRetrograde, KColors.blue, 'retrograde'));
    if (p['combust'] == true) badges.add(_badge(l.sumCombust, KColors.orange, 'combust'));
    if (p['vargottam'] == true) badges.add(_badge(l.sumVargottama, KColors.purple, 'vargottama'));
    if (rel.isNotEmpty && rel != 'neutral') {
      badges.add(_badge(kRelationLabel(rel, l), relColor,
          rel == 'own' ? 'ownsign' : rel == 'exalted' ? 'exalted' : rel == 'debilitated' ? 'debilitated' : null));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (isLagna ? AppColors.gold : relColor).withOpacity(0.3)),
      ),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              Row(children: [
                Container(
                  width: 44, height: 44, alignment: Alignment.center,
                  decoration: BoxDecoration(color: relColor.withOpacity(0.15), shape: BoxShape.circle),
                  child: Text(_symbol(planet), style: const TextStyle(fontSize: 20, color: AppColors.ivory)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 15.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text('$signName · ${l.house} $_house · $degree°',
                      style: const TextStyle(color: AppColors.primary, fontSize: 12.5, fontWeight: FontWeight.w600)),
                ])),
                AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 240),
                  child: Icon(Icons.expand_more, color: relColor),
                ),
              ]),
              if (badges.isNotEmpty) ...[
                const SizedBox(height: 10),
                Align(alignment: Alignment.centerLeft, child: Wrap(spacing: 6, runSpacing: 6, children: badges)),
              ],
            ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Divider(height: 1),
              const SizedBox(height: 12),
              // quick facts grid
              Wrap(spacing: 8, runSpacing: 8, children: [
                _fact(l.planetNakPada('${p['nakshatra_local'] ?? p['nakshatra']}', '${p['pada']}'), term: 'nakshatra'),
                _fact(l.planetNakLord('${p['nak_lord_local'] ?? p['nak_lord']}')),
                _fact(l.planetLongitude((p['longitude'] as num?)?.toStringAsFixed(2) ?? '')),
              ]),
              if (!isLagna) ...[
                const SizedBox(height: 14),
                // strength meter
                _strengthMeter(l),
                const SizedBox(height: 14),
                _attrRow(l.plNature, kNatureLabel(planet, l)),
                _attrRow(l.plElement, kPlanetElementLabel(planet, l)),
                _attrRow(l.plGender, kGenderLabel(planet, l)),
                _attrRowTerm(l.plKarakatva, _karakatva(l, planet)),
                _attrRow(l.plLordship, _lordship(l)),
                const SizedBox(height: 6),
                _aspectRow(l),
                _conjunctionRow(l),
              ],
              const SizedBox(height: 12),
              _meaningBlock(l.plHouseMeaning, '${kOrdinal(_house)} ${l.house} — ${_houseMeaning(l, _house)}'),
              if (!isLagna)
                _meaningBlock(l.plNakshatraMeaning,
                    l.plNakMeaning('${p['nak_lord_local'] ?? p['nak_lord']}', _nakLordTrait(l, (p['nak_lord'] ?? '').toString()))),
              if (!isLagna) ...[
                const SizedBox(height: 8),
                _aiBlock(l),
              ],
            ]),
          ),
          crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 260),
          sizeCurve: Curves.easeInOut,
        ),
      ]),
    );
  }

  Widget _badge(String label, Color c, String? term) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: c.withOpacity(0.16), borderRadius: BorderRadius.circular(7), border: Border.all(color: c.withOpacity(0.5))),
      child: Text(label, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700)),
    );
    if (term == null) return chip;
    final l = AppLocalizations.of(context)!;
    return Tooltip(
      message: kGlossary(term, l),
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 4),
      preferBelow: false,
      decoration: BoxDecoration(color: AppColors.twilight, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
      textStyle: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4),
      child: chip,
    );
  }

  Widget _fact(String text, {String? term}) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(7), border: Border.all(color: AppColors.border)),
      child: Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
    );
    if (term == null) return chip;
    final l = AppLocalizations.of(context)!;
    return Tooltip(
      message: kGlossary(term, l),
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 4),
      preferBelow: false,
      decoration: BoxDecoration(color: AppColors.twilight, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
      textStyle: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4),
      child: chip,
    );
  }

  Widget _strengthMeter(AppLocalizations l) {
    final s = widget.score ?? 0;
    final color = KColors.forScore(s);
    final stars = kStars(s);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.10), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.35))),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.plStrength, style: const TextStyle(color: AppColors.smoke, fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          KStars(filled: stars, size: 16, color: color),
        ]),
        const Spacer(),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${s.toStringAsFixed(0)}%', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
          Text(kStrengthLabel(s, l), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        ]),
      ]),
    );
  }

  Widget _attrRow(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 118, child: Text(k, style: const TextStyle(color: AppColors.smoke, fontSize: 12))),
          Expanded(child: Text(v, style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, fontWeight: FontWeight.w600))),
        ]),
      );

  Widget _attrRowTerm(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 118, child: Text(k, style: const TextStyle(color: AppColors.smoke, fontSize: 12))),
          Expanded(child: Text(v, style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic))),
        ]),
      );

  String _lordship(AppLocalizations l) {
    final owns = kOwnSigns(widget.planet);
    if (owns.isEmpty) return '—';
    final houses = owns.map((s) => (_signsShort.indexOf(s) - widget.lagnaIdx) % 12 + 1).toList()..sort();
    return l.plLordOfHouses(houses.map(kOrdinal).join(', '));
  }

  Widget _aspectRow(AppLocalizations l) {
    final given = ((widget.aspects?['graha_drishti'] as Map?)?[widget.planet] as Map?)?.keys.toList() ?? const [];
    final recv = ((widget.aspects?['graha_drishti_received'] as Map?)?[widget.planet] as Map?)?.keys.toList() ?? const [];
    String names(List l2) => l2.isEmpty ? '—' : l2.map((e) => KundliNames.planet(e.toString(), widget.loc)).join(', ');
    return Column(children: [
      _attrRow(l.plAspectsGiven, names(given)),
      _attrRow(l.plAspectsReceived, names(recv)),
    ]);
  }

  Widget _conjunctionRow(AppLocalizations l) {
    final conj = <String>[];
    widget.allPlanets.forEach((k, v) {
      if (k == widget.planet || k == 'Lagna') return;
      final si = ((v as Map)['sign_idx'] as num?)?.toInt();
      if (si != null && si == _signIdx) conj.add(k);
    });
    return _attrRow(l.plConjunction, conj.isEmpty ? '—' : conj.map((e) => KundliNames.planet(e, widget.loc)).join(', '));
  }

  Widget _meaningBlock(String title, String body) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: AppColors.gold, fontSize: 11.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(body, style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.4)),
        ]),
      );

  String _nakLordTrait(AppLocalizations l, String lord) => _karakatva(l, lord);

  Widget _aiBlock(AppLocalizations l) {
    final planet = widget.planet;
    final name = (widget.data['planet_local'] ?? planet).toString();
    final signName = (widget.data['sign_full_local'] ?? widget.data['sign_full'] ?? '').toString();
    final karak = _karakatva(l, planet);
    final s = widget.score ?? 50;
    final dignity = (widget.data['dignity'] ?? '').toString().toLowerCase();

    final parts = <String>[
      l.plAiPlace(name, signName, kOrdinal(_house)),
      s >= 55 ? l.plAiKarakStrong(karak) : l.plAiKarakWeak(karak),
    ];
    if (dignity.contains('uch') || dignity.contains('exalt')) parts.add(l.plAiExalted(name));
    else if (dignity.contains('neech') || dignity.contains('debil')) parts.add(l.plAiDebilitated(name));
    else if (widget.data['combust'] == true) parts.add(l.plAiCombust(name));
    else if (widget.data['vargottam'] == true) parts.add(l.plAiVargottama(name));
    else if (widget.data['vakri'] == true) parts.add(l.plAiRetrograde(name));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.twilight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lavender.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('🔮', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Text(l.plAiInterpretation, style: const TextStyle(color: AppColors.lavender, fontSize: 11.5, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 6),
        Text(parts.join(' '), style: const TextStyle(color: AppColors.parchment, fontSize: 12.3, height: 1.45)),
      ]),
    );
  }
}
