import 'dart:convert';
import 'package:flutter/material.dart';
import '../../widgets/desktop_center.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/kundli_names.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Marriage & Family report — premium AI relationship-coach redesign.
///
/// Presentation only. Loads the `marriage` specialist
/// (`runSpecialist('marriage')`) unchanged and re-presents it; every score,
/// karaka, house, divisional, dosha, timing, risk, remedy and confidence value
/// comes straight from the engine.
class MarriageReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const MarriageReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});
  @override
  State<MarriageReportScreen> createState() => _MarriageState();
}

class _MarriageState extends State<MarriageReportScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedData != null) { _data = widget.preloadedData; _loading = false; }
    else _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = await _api.runSpecialist('marriage', widget.chartId);
      if (!mounted) return;
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        setState(() { _data = (resp['data'] as Map).cast<String, dynamic>(); _loading = false; });
      } else {
        setState(() { _error = resp['detail']?.toString() ?? 'Analysis failed'; _loading = false; });
      }
    } catch (e) { if (!mounted) return; setState(() { _error = e.toString(); _loading = false; }); }
  }

  // ── typed accessors (type-checked, never throw on unexpected shapes) ──
  double _sc(String k) { final v = _data?[k]; return v is num ? v.toDouble() : 0; }
  String _str(String k) { final v = _data?[k]; return (v == null || v is List || v is Map) ? '' : v.toString(); }
  List _list(String k) { final v = _data?[k]; return v is List ? v : const []; }
  Map<String, dynamic> _map(String k) { final v = _data?[k]; return v is Map ? v.cast<String, dynamic>() : {}; }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.chartName, style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700)),
          Text(l.mrSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
        ]),
        actions: [IconButton(icon: const Icon(Icons.refresh, color: AppColors.ivory, size: 18), onPressed: _load)],
      ),
      body: DesktopCenter(maxWidth: 1000, child: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null ? _errView(l)
          : _data == null ? const SizedBox.shrink()
          : ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 40), children: _sections(l))),
    );
  }

  List<Widget> _sections(AppLocalizations l) {
    const gap = SizedBox(height: 18);
    return [
      _breadcrumb(l),
      const SizedBox(height: 10),
      _snapshot(l),           // 1
      gap, _spouse(l),           // 2
      gap, _soulPartnership(l),  // 3
      gap, _foundation(l),       // 4
      gap, _harmony(l),          // 5
      gap, _timing(l),           // 6
      gap, _journey(l),          // 7
      gap, _familyHome(l),       // 8
      gap, _verification(l),     // 9
      gap, _challenges(l),       // 10
      gap, _partnerGuide(l),     // 11
      gap, _remedies(l),         // 12
      gap, _reliability(l),      // 13
      gap, _discussAi(l),        // 14
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.mrTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — MARRIAGE SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _sc('overall_marriage_strength_score');
    final col = _mrColor(overall);
    final summary = _str('marriage_verdict_explanation').isNotEmpty ? _str('marriage_verdict_explanation') : _str('plain_statement');
    final gauges = <List<Object>>[
      [l.mrHarmony, _sc('marital_harmony_score')],
      [l.mrLongevity, _sc('marriage_longevity_score')],
      [l.mrSatisfaction, _sc('marital_satisfaction_score')],
      [l.mrStability, _sc('domestic_stability_score')],
      [l.mrClarity, _sc('marriage_clarity_score')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.mrMarriagePotential.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: overall / 100), duration: const Duration(milliseconds: 900), curve: Curves.easeOutCubic,
          builder: (_, v, __) => SizedBox(width: 140, height: 140, child: Stack(alignment: Alignment.center, children: [
            SizedBox(width: 140, height: 140, child: CircularProgressIndicator(value: v, strokeWidth: 12, strokeCap: StrokeCap.round,
              backgroundColor: Colors.white.withOpacity(0.07), valueColor: AlwaysStoppedAnimation(col))),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text((v * 100).toStringAsFixed(0), style: TextStyle(color: col, fontSize: 44, fontWeight: FontWeight.w800, height: 1)),
              Text('/100', style: TextStyle(color: col.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w600)),
            ]),
          ])),
        ),
        const SizedBox(height: 10),
        Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
          child: Text(_str('overall_marriage_verdict').isNotEmpty ? _titleCase(_str('overall_marriage_verdict')) : _potentialStatus(overall, l),
            style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
        if (summary.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(color: AppColors.midnight.withOpacity(0.35), borderRadius: BorderRadius.circular(14)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🤖', style: TextStyle(fontSize: 14)), const SizedBox(width: 9),
              Expanded(child: Text(_cap(summary), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.5))),
            ])),
        ],
        const SizedBox(height: 18),
        Wrap(alignment: WrapAlignment.center, spacing: 14, runSpacing: 14,
          children: gauges.map((g) => _miniGauge(g[0] as String, g[1] as double)).toList()),
        const SizedBox(height: 16),
        Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: _snapshotChips(l).map((t) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(color: KColors.green.withOpacity(0.10), borderRadius: BorderRadius.circular(20), border: Border.all(color: KColors.green.withOpacity(0.28))),
          child: Text('✓ $t', style: const TextStyle(color: KColors.green, fontSize: 11.5, fontWeight: FontWeight.w700)),
        )).toList()),
      ]),
    );
  }

  List<String> _snapshotChips(AppLocalizations l) {
    final out = <String>[];
    if (_sc('marital_harmony_score') >= 55) out.add(l.mrChipHarmony);
    if (_data?['mangal_dosh_present'] != true) out.add(l.mrChipNoMangal);
    if (_sc('marriage_longevity_score') >= 55) out.add(l.mrChipLongLasting);
    if (_sc('home_ownership_likelihood_score') >= 55) out.add(l.mrChipHome);
    if (_sc('in_law_relations_score') >= 55) out.add(l.mrChipInLaws);
    if (_sc('fertility_within_marriage_score') >= 55) out.add(l.mrChipChildren);
    return out.toSet().take(6).toList();
  }

  Widget _miniGauge(String label, double score) {
    final col = _mrColor(score);
    return SizedBox(width: 92, child: Column(children: [
      SizedBox(width: 62, height: 62, child: Stack(alignment: Alignment.center, children: [
        SizedBox(width: 62, height: 62, child: CircularProgressIndicator(value: (score / 100).clamp(0, 1), strokeWidth: 6, strokeCap: StrokeCap.round,
          backgroundColor: Colors.white.withOpacity(0.07), valueColor: AlwaysStoppedAnimation(col))),
        Text(score.toStringAsFixed(0), style: TextStyle(color: col, fontSize: 15, fontWeight: FontWeight.w800)),
      ])),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.parchment, fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 2),
    ]));
  }

  // ══════════════════════════════════════════════════════════════════
  //  2 — YOUR FUTURE SPOUSE
  // ══════════════════════════════════════════════════════════════════
  Widget _spouse(AppLocalizations l) {
    final arch = _str('spouse_primary_archetype');
    final desc = _str('spouse_description').isNotEmpty ? _str('spouse_description') : _str('darakaraka_spouse_signature');
    if (arch.isEmpty && desc.isEmpty) return const SizedBox.shrink();
    final traits = _list('spouse_personality_traits').map((e) => e.toString()).toList();
    final profs = _list('spouse_likely_profession_categories').map((e) => e.toString()).toList();
    final facts = <List<String>>[
      ['🎂', l.mrAgeDiff, _titleCase(_str('spouse_age_difference_signature'))],
      ['🌍', l.mrCulture, _cap(_str('spouse_cultural_background_signature'))],
      ['🎓', l.mrEducation, _titleCase(_str('spouse_education_level_signature'))],
      ['👨‍👩‍👧', l.mrFamilyBg, _cap(_str('spouse_family_background_signature'))],
    ].where((r) => r[2].isNotEmpty).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.favorite_rounded, title: l.mrSpouse, subtitle: l.mrSpouseSub, color: KColors.purple),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.purple.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.purple.withOpacity(0.3))),
        child: Column(children: [
          const Text('💑', style: TextStyle(fontSize: 30)),
          if (arch.isNotEmpty) ...[const SizedBox(height: 6),
            Text(_titleCase(arch), style: const TextStyle(color: AppColors.ivory, fontSize: 19, fontWeight: FontWeight.w800), textAlign: TextAlign.center)],
          if (desc.isNotEmpty) ...[const SizedBox(height: 8),
            Text('🤖 ${_cap(desc)}', style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5), textAlign: TextAlign.center)],
        ])),
      const SizedBox(height: 12),
      _chipBlock('✨', l.mrSpouseTraits, traits, KColors.blue),
      _chipBlock('💼', l.mrSpouseWork, profs, AppColors.gold),
      if (facts.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: _card(child: Column(children: facts.map((f) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(f[0], style: const TextStyle(fontSize: 14)), const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(f[1], style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
            Text(f[2], style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.35)),
          ])),
        ]),
      )).toList()))),
    ]);
  }

  Widget _chipBlock(String emoji, String title, List<String> items, Color c) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(emoji, style: const TextStyle(fontSize: 13)), const SizedBox(width: 6),
        Text(title, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800))]),
      const SizedBox(height: 7),
      Wrap(spacing: 6, runSpacing: 6, children: items.take(8).map((e) => _pill(_cap(e), c)).toList()),
    ]));
  }

  // ══════════════════════════════════════════════════════════════════
  //  3 — SOUL & PARTNERSHIP
  // ══════════════════════════════════════════════════════════════════
  Widget _soulPartnership(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final soul = _str('atmakaraka_planet');
    final spouse = _str('darakaraka_planet');
    final align = _sc('soul_partnership_alignment_score');
    final col = _mrColor(align);
    final alignText = align >= 60 ? l.mrAlignStrong : align >= 40 ? l.mrAlignModerate : l.mrAlignLow;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.self_improvement_rounded, title: l.mrSoulPartnership, color: KColors.purple),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _planetCard('🕉️', l.mrSelfPlanet, KundliNames.planet(soul, loc), _str('atmakaraka_self_in_partnership'), KColors.purple)),
        const SizedBox(width: 10),
        Expanded(child: _planetCard('💞', l.mrSpousePlanet, KundliNames.planet(spouse, loc), _str('darakaraka_spouse_signature'), KColors.blue)),
      ]),
      const SizedBox(height: 12),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(l.mrSoulAlignment, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w800))),
          Text('${align.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 18, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: (align / 100).clamp(0, 1), minHeight: 7, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
        const SizedBox(height: 10),
        Text('🤖 $alignText', style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.4)),
      ])),
      _advanced(l, [
        '${l.mrTechDarakaraka}: ${KundliNames.planet(spouse, loc)} · ${_sc('darakaraka_degrees').toStringAsFixed(1)}° · ${_str('darakaraka_sign_name')}',
        'D9 ${l.crDignity}: ${_str('darakaraka_d9_dignity')} · Nakshatra: ${_str('darakaraka_nakshatra')}',
        '${l.mrUpapada}: ${_str('upapada_lagna_sign_name')} · ${l.mrUpapadaLord}: ${KundliNames.planet(_str('upapada_lagna_lord'), loc)}',
      ]),
    ]);
  }

  Widget _planetCard(String emoji, String label, String planet, String meaning, Color c) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(emoji, style: const TextStyle(fontSize: 16)), const SizedBox(width: 6),
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)))]),
      const SizedBox(height: 6),
      Text(planet.isEmpty ? '—' : planet, style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.w800)),
      if (meaning.isNotEmpty) ...[const SizedBox(height: 4),
        Text(_cap(meaning), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.35))],
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  4 — MARRIAGE FOUNDATION (7th house)
  // ══════════════════════════════════════════════════════════════════
  Widget _foundation(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final strength = _sc('seventh_house_strength_score');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.foundation_rounded, title: l.mrFoundation, color: KColors.blue),
      Row(children: [
        Expanded(child: _iconTile('💍', l.mrMarriageSign, _str('seventh_house_sign_name'))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🪐', l.mrMarriageLord, KundliNames.planet(_str('seventh_lord_planet'), loc))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('💪', l.mrHouseStrength, '${strength.toStringAsFixed(0)}%', color: _mrColor(strength))),
      ]),
      const SizedBox(height: 10),
      if (_str('seventh_lord_marriage_indication').isNotEmpty) _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.mrPartnerHint, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(_cap(_str('seventh_lord_marriage_indication')), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.45)),
      ])),
      _advanced(l, [
        '${l.mrMarriageLord} ${l.crDignity}: ${_str('seventh_lord_dignity')} · D9: ${_str('seventh_lord_d9_dignity')}',
        '${l.mrMarriageLord} ${l.crHouseLabel}: ${_sc('seventh_lord_house').toStringAsFixed(0)}',
        if (_list('seventh_house_occupants').isNotEmpty) 'Occupants: ${_list('seventh_house_occupants').map((e) => KundliNames.planet(e.toString(), loc)).join(', ')}',
        'Venus: ${_str('venus_strength_score').isEmpty ? '' : '${_sc('venus_strength_score').toStringAsFixed(0)}%'} · Jupiter: ${_sc('jupiter_strength_score').toStringAsFixed(0)}%',
      ]),
    ]);
  }

  Widget _iconTile(String emoji, String label, String value, {Color? color}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 17)), const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w600)),
      Text(value.isEmpty ? '—' : value, style: TextStyle(color: color ?? AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  5 — COMPATIBILITY HARMONY
  // ══════════════════════════════════════════════════════════════════
  Widget _harmony(AppLocalizations l) {
    final rows = <List<Object>>[
      [l.mrEmotional, _sc('emotional_harmony_score')],
      [l.mrIntellectual, _sc('intellectual_compatibility_score')],
      [l.mrPhysical, _sc('physical_intimacy_harmony_score')],
      [l.mrFinancial, _sc('financial_alignment_score')],
      [l.mrCommunication, _sc('communication_harmony_score')],
      [l.mrSharedValues, _sc('shared_values_score')],
      [l.mrSpiritual, _sc('spiritual_alignment_score')],
      [l.mrConflictRes, _sc('conflict_resolution_capacity_score')],
    ].where((r) => (r[1] is num ? (r[1] as num).toDouble() : 0.0) > 0).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.favorite_border_rounded, title: l.mrHarmonyHdr, subtitle: l.mrHarmonySub, color: KColors.green),
      _card(child: Column(children: rows.map((r) {
        final score = r[1] as double;
        final col = _mrColor(score);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(r[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w600))),
            Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 13, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 5),
          ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
        ]));
      }).toList())),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  6 — MARRIAGE TIMING
  // ══════════════════════════════════════════════════════════════════
  Widget _timing(AppLocalizations l) {
    final age = _str('first_marriage_age_estimate_range');
    final readiness = _str('current_marriage_readiness_signature');
    final primary = _list('primary_marriage_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final secondary = _list('secondary_marriage_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final delay = _sc('marriage_delay_likelihood_score');
    final cards = <Widget>[];
    for (final m in primary.take(2)) {
      cards.add(_timelineCard(l, l.mrMarriageWindow, m['window']?.toString() ?? '', m['dasha']?.toString() ?? '', _cap(m['note']?.toString() ?? ''), KColors.green));
    }
    for (final m in secondary.take(2)) {
      cards.add(_timelineCard(l, l.mrSecondaryWindow, m['window']?.toString() ?? '', m['dasha']?.toString() ?? '', _cap(m['note']?.toString() ?? ''), KColors.blue));
    }
    if (readiness.isNotEmpty) cards.add(_timelineCard(l, l.mrCurrentReadiness, '', '', _cap(readiness), KColors.purple));
    if (age.isEmpty && cards.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.event_rounded, title: l.mrTiming, color: AppColors.gold),
      if (age.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 12),
        child: _card(child: Row(children: [const Text('💐', style: TextStyle(fontSize: 16)), const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.mrFirstMarriageAge, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
            Text(_cap(age), style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w800)),
          ])),
          Column(children: [
            Text('${delay.toStringAsFixed(0)}%', style: TextStyle(color: _riskColor(delay), fontSize: 15, fontWeight: FontWeight.w800)),
            Text(l.mrDelayChance, style: const TextStyle(color: AppColors.smoke, fontSize: 8.5, fontWeight: FontWeight.w600)),
          ]),
        ]))),
      ...cards,
    ]);
  }

  Widget _timelineCard(AppLocalizations l, String title, String window, String dasha, String note, Color col) {
    final loc = Localizations.localeOf(context);
    final planet = dasha.isNotEmpty ? KundliNames.planet(dasha.split(' ').first, loc) : '';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 13, 13, 13),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.28))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: col, shape: BoxShape.circle, border: Border.all(color: col.withOpacity(0.35), width: 3))),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(color: col, fontSize: 12.5, fontWeight: FontWeight.w800))),
          if (window.isNotEmpty) Flexible(child: Text(window, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.right)),
        ]),
        if (planet.isNotEmpty) ...[const SizedBox(height: 4),
          Text('🪐 $planet', style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700))],
        if (note.isNotEmpty) ...[const SizedBox(height: 6),
          Text(note, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))],
        if (dasha.isNotEmpty) _advanced(l, ['${l.crViewDasha}: $dasha']),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — MARRIAGE JOURNEY (phases)
  // ══════════════════════════════════════════════════════════════════
  Widget _journey(AppLocalizations l) {
    final t = _map('marriage_trajectory_by_phase');
    if (t.isEmpty) return const SizedBox.shrink();
    final phases = <List<Object>>[
      [l.mrPhaseEarly, _map('marriage_trajectory_by_phase')['early_marriage_phase']],
      [l.mrPhaseMid, _map('marriage_trajectory_by_phase')['mid_marriage_phase']],
      [l.mrPhaseMature, _map('marriage_trajectory_by_phase')['mature_marriage_phase']],
      [l.mrPhaseLate, _map('marriage_trajectory_by_phase')['late_marriage_phase']],
    ];
    final cards = <Widget>[];
    for (final p in phases) {
      final m = p[1];
      if (m is! Map) continue;
      final mm = m.cast<String, dynamic>();
      final score = (mm['strength_score'] is num ? mm['strength_score'] as num : null)?.toDouble() ?? 0;
      final col = _mrColor(score);
      cards.add(Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text('${p[0]}  ·  ${mm['years'] ?? ''}', style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w800))),
            Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
          if (mm['focus'] != null) ...[const SizedBox(height: 7),
            Text(_cap(mm['focus'].toString()), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.35))],
          if (mm['recommended'] != null) _advanced(l, ['${l.mrTip}: ${_cap(mm['recommended'].toString())}']),
        ]),
      ));
    }
    if (cards.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.timeline_rounded, title: l.mrJourney, subtitle: l.mrJourneySub, color: KColors.purple),
      ...cards,
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — FAMILY & HOME
  // ══════════════════════════════════════════════════════════════════
  Widget _familyHome(AppLocalizations l) {
    final rows = <List<Object>>[
      [l.mrInLaws, _sc('in_law_relations_score')],
      [l.mrFamilyHarmony, _sc('family_harmony_score')],
      [l.mrHomeOwnership, _sc('home_ownership_likelihood_score')],
      [l.mrDomesticPeace, _sc('domestic_peace_score')],
      [l.mrFertility, _sc('fertility_within_marriage_score')],
      [l.mrParenting, _sc('parenting_harmony_between_spouses_score')],
    ].where((r) => (r[1] is num ? (r[1] as num).toDouble() : 0.0) > 0).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    final children = _str('children_number_signature');
    final childTiming = _str('children_timing_within_marriage_signature');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.home_rounded, title: l.mrFamilyHome, color: KColors.blue),
      Wrap(spacing: 10, runSpacing: 10, children: rows.map((r) =>
        SizedBox(width: (MediaQuery.of(context).size.width - 32 - 10) / 2, child: _meterTile(r[0] as String, r[1] as double))).toList()),
      if (childTiming.isNotEmpty || children.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: _card(child: Row(children: [const Text('👶', style: TextStyle(fontSize: 15)), const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.mrChildren, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
            if (children.isNotEmpty) Text('${l.mrLikelyCount}: $children', style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w700)),
            if (childTiming.isNotEmpty) Text(_cap(childTiming), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.35)),
          ]))]))),
    ]);
  }

  Widget _meterTile(String label, double score) {
    final col = _mrColor(score);
    return Container(padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.18))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 6),
        Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
      ]));
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — CROSS-CHART VERIFICATION
  // ══════════════════════════════════════════════════════════════════
  Widget _verification(AppLocalizations l) {
    final d9 = _map('d9_validation'), d10 = _map('d10_marriage_validation'), d60 = _map('d60_marriage_validation');
    final standing = (d9['d9_overall_marriage_standing']?.toString() ?? '').toLowerCase();
    final d9Score = standing.contains('strong') || standing.contains('exceptional') ? 75.0 : standing.contains('moderate') || standing.contains('standard') ? 50.0 : 30.0;
    final d10Score = (d10['d10_dual_career_marriage_score'] is num ? d10['d10_dual_career_marriage_score'] as num : null)?.toDouble() ?? 0;
    final d60Score = (d60['d60_past_life_marriage_capital_score'] is num ? d60['d60_past_life_marriage_capital_score'] as num : null)?.toDouble() ?? 0;
    final cards = <Widget>[];
    if (d9.isNotEmpty) cards.add(_chartCard(l, l.mrD9, d9Score, d9['d9_primary_marriage_signature']?.toString() ?? '',
      ['D9 7L: ${d9['d9_seventh_lord_dignity']}', 'Venus: ${d9['d9_venus_dignity']} · Jupiter: ${d9['d9_jupiter_dignity']}', 'DK: ${d9['d9_darakaraka_dignity']}']));
    if (d10.isNotEmpty) cards.add(_chartCard(l, l.mrD10, d10Score, d10['d10_career_spouse_signature']?.toString() ?? '',
      ['D10 Venus: ${d10['d10_venus_dignity']} · 7L: ${d10['d10_seventh_lord_dignity']}']));
    if (d60.isNotEmpty) cards.add(_chartCard(l, l.mrD60, d60Score, d60['d60_marriage_past_life_signature']?.toString() ?? '',
      ['D60 DK: ${d60['d60_darakaraka_dignity']} · Venus: ${d60['d60_venus_dignity']}']));
    if (cards.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_rounded, title: l.mrVerification, color: KColors.green),
      ...cards,
    ]);
  }

  Widget _chartCard(AppLocalizations l, String title, double score, String explain, List<String> tech) {
    final col = _mrColor(score);
    final status = score >= 60 ? l.crStatusStrongSupport : score >= 40 ? l.crStatusModerateSupport : l.crStatusNeedsImprovement;
    return Container(
      margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: col.withOpacity(0.22))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(title, style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w800))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: TextStyle(color: col, fontSize: 10, fontWeight: FontWeight.w800))),
        ]),
        if (explain.isNotEmpty) ...[const SizedBox(height: 8),
          Text(_cap(explain), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
        _advanced(l, tech),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — CHALLENGES TO WATCH
  // ══════════════════════════════════════════════════════════════════
  Widget _challenges(AppLocalizations l) {
    final rows = <List<Object>>[
      [l.mrRiskConflict, _sc('marital_conflict_risk_score')],
      [l.mrRiskSeparation, _sc('separation_divorce_risk_score')],
      [l.mrRiskDistance, _sc('emotional_distance_risk_score')],
      [l.mrRiskInfidelity, _sc('infidelity_risk_score')],
      [l.mrRiskFinance, _sc('financial_disagreement_risk_score')],
    ].where((r) => (r[1] is num ? (r[1] as num).toDouble() : 0.0) > 0).toList();
    final mangal = _data?['mangal_dosh_present'] == true;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.shield_outlined, title: l.mrChallenges, color: KColors.orange),
      Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: (mangal ? KColors.orange : KColors.green).withOpacity(0.06), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: (mangal ? KColors.orange : KColors.green).withOpacity(0.22))),
        child: Row(children: [
          Icon(mangal ? Icons.warning_amber_rounded : Icons.check_circle_rounded, size: 18, color: mangal ? KColors.orange : KColors.green),
          const SizedBox(width: 10),
          Expanded(child: Text(mangal ? l.mrMangalPresent : l.mrMangalAbsent, style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4, fontWeight: FontWeight.w600))),
          if (mangal && _sc('mangal_dosh_severity') > 0) Text('${_sc('mangal_dosh_severity').toStringAsFixed(0)}%', style: const TextStyle(color: KColors.orange, fontSize: 13, fontWeight: FontWeight.w800)),
        ])),
      ...rows.map((r) {
        final score = r[1] as double;
        final col = _riskColor(score);
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: col.withOpacity(0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.18))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(r[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700))),
              Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 6),
            ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  11 — PARTNER GUIDE
  // ══════════════════════════════════════════════════════════════════
  Widget _partnerGuide(AppLocalizations l) {
    final seek = _list('partner_qualities_to_seek').map((e) => e.toString()).toList();
    final avoid = _list('partner_qualities_to_avoid').map((e) => e.toString()).toList();
    final priorities = _list('pre_marriage_matching_priorities').map((e) => e.toString()).toList();
    final direction = _str('primary_marriage_direction_recommendation');
    if (seek.isEmpty && avoid.isEmpty && direction.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.person_search_rounded, title: l.mrPartnerGuide, subtitle: l.mrPartnerGuideSub, color: AppColors.gold),
      if (direction.isNotEmpty) Container(
        margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.14), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.28))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('🎯', style: TextStyle(fontSize: 15)), const SizedBox(width: 9),
          Expanded(child: Text(_cap(direction), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45))),
        ])),
      _chipBlock('💚', l.mrSeek, seek, KColors.green),
      _chipBlock('⚠️', l.fdAvoid, avoid, KColors.orange),
      if (priorities.isNotEmpty) _advanced(l, priorities, customTitle: l.mrMatchingPriorities),
    ]);
  }

  Widget _pill(String t, Color c) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: c.withOpacity(0.25))),
    child: Text(t, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w600)));

  // ══════════════════════════════════════════════════════════════════
  //  12 — IMPROVEMENT PLAN (remedies)
  // ══════════════════════════════════════════════════════════════════
  Widget _remedies(AppLocalizations l) {
    final practical = _list('practical_solutions').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final astro = _list('astrological_remedies').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (practical.isEmpty && astro.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.spa_rounded, title: l.mrImprovementPlan, color: KColors.green),
      if (practical.isNotEmpty) ...[
        _catLabel('🎯', l.crCatPractical, KColors.blue),
        ...practical.map((m) => _remedyCard(_titleCase(m['category']?.toString() ?? ''), m['advice']?.toString() ?? '', KColors.blue)),
      ],
      if (astro.isNotEmpty) ...[
        const SizedBox(height: 6),
        _catLabel('🕉️', l.crCatPlanetary, KColors.purple),
        ...astro.map((m) => _remedyCard(m['deity']?.toString() ?? '', m['remedy']?.toString() ?? '', KColors.purple)),
      ],
    ]);
  }

  Widget _catLabel(String emoji, String t, Color c) => Padding(padding: const EdgeInsets.only(bottom: 8, top: 2),
    child: Row(children: [Text(emoji, style: const TextStyle(fontSize: 13)), const SizedBox(width: 6),
      Text(t, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800))]));

  Widget _remedyCard(String title, String body, Color c) => Container(
    margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (title.isNotEmpty) Text(title, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800)),
      if (title.isNotEmpty) const SizedBox(height: 4),
      Text(_cap(body), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45)),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  13 — PREDICTION RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    double layer(String k) { final v = b[k]; return v is num ? v.toDouble() * 100 : 0; }
    final layers = <List<Object>>[
      [l.mrLayerBirth, layer('d1')],
      [l.mrLayerNavamsa, layer('d9')],
      [l.mrLayerDashamsa, layer('d10')],
      [l.mrLayerShashtiamsa, layer('d60')],
      [l.mrLayerDarakaraka, layer('darakaraka')],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.mrReliability, color: KColors.blue),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          KStars(filled: kStars(pct), size: 20, color: AppColors.gold), const Spacer(),
          Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 4),
        Text(band, style: const TextStyle(color: KColors.green, fontSize: 13, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Text(l.crReliabilityExplain, style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5)),
        _advanced(l, null, customTitle: l.crChartLayers, customChild: Column(children: layers.where((la) => (la[1] is num ? (la[1] as num).toDouble() : 0.0) > 0).map((la) {
          final v = la[1] as double;
          return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
            SizedBox(width: 140, child: Text(la[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(_mrColor(v))))),
            const SizedBox(width: 8),
            Text('${v.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
          ]));
        }).toList())),
      ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  14 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.mrTopicWhen, l.mrTopicSpouse, l.mrTopicCompat, l.mrTopicDelay, l.mrTopicMangal, l.mrTopicChildren, l.mrTopicInLaws, l.mrTopicHarmony];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.forum_rounded, title: l.crDiscussAi, color: AppColors.gold),
      Row(children: [
        _aiBtn('ChatGPT', '🤖', () => _launchAi(_data!, 'chatgpt')),
        _aiBtn('Claude', '✳️', () => _launchAi(_data!, 'claude')),
        _aiBtn('Gemini', '💎', () => _launchAi(_data!, 'gemini')),
      ]),
      const SizedBox(height: 14),
      Text(l.crAskAbout, style: const TextStyle(color: AppColors.smoke, fontSize: 11.5, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: topics.map((t) => GestureDetector(
        onTap: () => _copyTopic(t),
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
          child: Text(t, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, fontWeight: FontWeight.w600))),
      )).toList()),
    ]);
  }

  Widget _aiBtn(String name, String emoji, VoidCallback onTap) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
    child: GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.2))),
      child: Column(children: [Text(emoji, style: const TextStyle(fontSize: 20)), const SizedBox(height: 5),
        Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w700)),
        const Text('OPEN ↗', style: TextStyle(color: AppColors.smoke, fontSize: 7, letterSpacing: 1)),
      ])))));

  void _copyTopic(String topic) {
    final q = '$topic — based on my Vedic marriage report for ${widget.chartName}.\n\n${_buildPrompt(_data!)}';
    Clipboard.setData(ClipboardData(text: q));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.crTopicCopied), duration: const Duration(seconds: 2)));
  }

  // ══════════════════════════════════════════════════════════════════
  //  shared widgets / helpers
  // ══════════════════════════════════════════════════════════════════
  Widget _card({required Widget child}) => Container(padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.06))), child: child);

  Widget _advanced(AppLocalizations l, List<String>? lines, {String? customTitle, Widget? customChild}) {
    final valid = lines?.where((s) => s.trim().isNotEmpty && !s.trim().endsWith(': ') && !s.trim().endsWith(':')).toList() ?? const [];
    if (customChild == null && valid.isEmpty) return const SizedBox.shrink();
    return Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero, childrenPadding: const EdgeInsets.only(bottom: 8),
        iconColor: AppColors.smoke, collapsedIconColor: AppColors.smoke,
        title: Text(customTitle ?? l.fdAdvancedDetails, style: const TextStyle(color: AppColors.smoke, fontSize: 11.5, fontWeight: FontWeight.w700)),
        children: customChild != null ? [customChild] : valid.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('• ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
            Expanded(child: Text(s, style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.35))),
          ]),
        )).toList(),
      ),
    );
  }

  Color _mrColor(double s) {
    if (s >= 75) return KColors.green;
    if (s >= 60) return KColors.blue;
    if (s >= 45) return KColors.yellow;
    if (s >= 30) return KColors.orange;
    return KColors.red;
  }
  Color _riskColor(double s) {
    if (s >= 65) return KColors.red;
    if (s >= 45) return KColors.orange;
    if (s >= 30) return KColors.yellow;
    return KColors.green;
  }
  String _potentialStatus(double s, AppLocalizations l) {
    if (s >= 75) return l.crStatusStrong;
    if (s >= 60) return l.crStatusGood;
    if (s >= 45) return l.crStatusModerate;
    if (s >= 30) return l.crStatusDeveloping;
    return l.crStatusChallenging;
  }
  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .where((w) => w.isNotEmpty).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── AI prompt / launch (unchanged behaviour) ──
  String _buildPrompt(Map<String, dynamic> d) {
    final name = widget.chartName;
    final overall = d['overall_marriage_strength_score'] ?? '?';
    final verdict = d['overall_marriage_verdict'] ?? '';
    final spouse = d['spouse_primary_archetype'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic marriage and relationship advisor. Analyze this marriage report for $name and provide actionable insights.

Key highlights:
- Overall marriage strength: $overall/100
- Verdict: $verdict
- Spouse archetype: $spouse

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the most important marriage timing windows, and suggest practical next steps.''';
  }

  Future<void> _launchAi(Map<String, dynamic> d, String ai) async {
    final prompt = _buildPrompt(d);
    await Clipboard.setData(ClipboardData(text: prompt));
    String url;
    switch (ai) {
      case 'chatgpt': url = 'https://chat.openai.com/'; break;
      case 'claude': url = 'https://claude.ai/new'; break;
      case 'gemini': url = 'https://gemini.google.com/app'; break;
      default: return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Report copied! Opening $ai — paste to discuss.'), duration: const Duration(seconds: 3)));
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _errView(AppLocalizations l) => Center(child: Padding(padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, color: AppColors.error, size: 44), const SizedBox(height: 12),
      Text(_error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center),
      const SizedBox(height: 16), ElevatedButton(onPressed: _load, child: Text(l.retry)),
    ])));
}
