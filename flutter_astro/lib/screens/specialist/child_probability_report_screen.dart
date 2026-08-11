import 'dart:convert';
import 'package:flutter/material.dart';
import '../../widgets/desktop_center.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Child Probability report — premium AI progeny-timing coach redesign.
///
/// Presentation only. Receives the already-loaded `child_probability`
/// specialist result (`runChildProbability`, a 2-chart Moola-Dasha analysis)
/// and re-presents it; every score, house/karaka analysis, dasha window,
/// dosha, remedy and confidence value comes straight from the engine.
/// Constructor unchanged so the multi-chart picker does not need to change.
class ChildProbabilityReportScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final List<String> participants;
  const ChildProbabilityReportScreen({super.key, required this.data, required this.participants});
  @override
  State<ChildProbabilityReportScreen> createState() => _ChildProbabilityReportState();
}

class _ChildProbabilityReportState extends State<ChildProbabilityReportScreen> {
  Map<String, dynamic> get _data => widget.data;

  // ── typed accessors (type-checked, never throw on unexpected shapes) ──
  double _sc(String k) { final v = _data[k]; return v is num ? v.toDouble() : 0; }
  double _scOf(Map m, String k) { final v = m[k]; return v is num ? v.toDouble() : 0; }
  String _str(String k) { final v = _data[k]; return (v == null || v is List || v is Map) ? '' : v.toString(); }
  String _strOf(Map m, String k) { final v = m[k]; return (v == null || v is List || v is Map) ? '' : v.toString(); }
  Map<String, dynamic> _map(String k) { final v = _data[k]; return v is Map ? v.cast<String, dynamic>() : {}; }
  Map<String, dynamic> _mapOf(Map m, String k) { final v = m[k]; return v is Map ? v.cast<String, dynamic>() : {}; }
  List _listOf(Map m, String k) { final v = m[k]; return v is List ? v : const []; }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.participants.join(' & '), style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(l.cpSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
        ]),
      ),
      body: DesktopCenter(maxWidth: 1000, child: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 40), children: _sections(l))),
    );
  }

  List<Widget> _sections(AppLocalizations l) {
    const gap = SizedBox(height: 18);
    return [
      _breadcrumb(l),
      const SizedBox(height: 10),
      _snapshot(l),          // 1
      gap, _partners(l),        // 2
      gap, _numberOfChildren(l), // 3
      gap, _timing(l),          // 4
      gap, _fifthHouse(l),      // 5
      gap, _jupiter(l),         // 6
      gap, _d7(l),              // 7
      gap, _beejaKshetra(l),    // 8
      gap, _dosha(l),           // 9
      gap, _remedies(l),        // 10
      gap, _summary(l),         // 11
      gap, _reliability(l),     // 12
      gap, _discussAi(l),       // 13
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.cpTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — PROGENY PROBABILITY SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _mapOf(_data, 'overall_probability');
    final score = _scOf(overall, 'overall_probability_score');
    final col = _col(score);
    final grade = _strOf(overall, 'probability_grade');
    final band = _strOf(overall, 'probability_band');
    final comps = _mapOf(overall, 'score_components');
    final summary = _strOf(overall, 'combined_verdict').isNotEmpty ? _strOf(overall, 'combined_verdict') : _str('confidence_explanation');
    final fifthAvg = ((_scOf(comps, 'partner1_5th_house_strength') + _scOf(comps, 'partner2_5th_house_strength')) / 2);
    final jupiterAvg = ((_scOf(comps, 'partner1_jupiter_strength') + _scOf(comps, 'partner2_jupiter_strength')) / 2);
    final d7Avg = ((_scOf(comps, 'partner1_d7_strength') + _scOf(comps, 'partner2_d7_strength')) / 2);
    final sphutaAvg = ((_scOf(comps, 'beeja_sphuta_score') + _scOf(comps, 'kshetra_sphuta_score')) / 2);
    final gauges = <List<Object>>[
      [l.cpGauge5thHouse, fifthAvg],
      [l.cpGaugeJupiter, jupiterAvg],
      [l.cpGaugeD7, d7Avg],
      [l.cpGaugeSphuta, sphutaAvg],
      [l.cpGaugeTiming, _scOf(comps, 'dasha_timing_favorability')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.cpSnapshotHeader.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: score / 100), duration: const Duration(milliseconds: 900), curve: Curves.easeOutCubic,
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
        if (grade.isNotEmpty) Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
          child: Text(grade, style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
        if (band.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
          child: Text(band, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5), textAlign: TextAlign.center)),
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
        Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: _snapshotChips(l, comps).map((t) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(color: KColors.green.withOpacity(0.10), borderRadius: BorderRadius.circular(20), border: Border.all(color: KColors.green.withOpacity(0.28))),
          child: Text('✓ $t', style: const TextStyle(color: KColors.green, fontSize: 11.5, fontWeight: FontWeight.w700)),
        )).toList()),
      ]),
    );
  }

  List<String> _snapshotChips(AppLocalizations l, Map comps) {
    final out = <String>[];
    if (_scOf(comps, 'partner1_jupiter_strength') >= 70 && _scOf(comps, 'partner2_jupiter_strength') >= 70) out.add(l.cpChipStrongPutrakaraka);
    if (_scOf(comps, 'combined_dosha_penalty') < 15) out.add(l.cpChipLowDoshaPenalty);
    if (_scOf(comps, 'dasha_timing_favorability') >= 60) out.add(l.cpChipFavorableTiming);
    final doshas = _listOf(_map('dosha_analysis'), 'doshas_detected');
    if (doshas.isEmpty) out.add(l.cpChipNoDoshas);
    return out.toSet().take(6).toList();
  }

  Widget _miniGauge(String label, double score) {
    final col = _col(score);
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
  //  2 — PARTNER SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _partners(AppLocalizations l) {
    final header = _map('analysis_header');
    final p1 = _mapOf(header, 'partner1');
    final p2 = _mapOf(header, 'partner2');
    if (p1.isEmpty && p2.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.people_alt_rounded, title: l.cpPartnersTitle, color: KColors.blue),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (p1.isNotEmpty) Expanded(child: _partnerCard(l, p1, KColors.purple)),
        if (p1.isNotEmpty && p2.isNotEmpty) const SizedBox(width: 10),
        if (p2.isNotEmpty) Expanded(child: _partnerCard(l, p2, KColors.blue)),
      ]),
    ]);
  }

  Widget _partnerCard(AppLocalizations l, Map p, Color c) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (p['role'] != null) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: c.withOpacity(0.16), borderRadius: BorderRadius.circular(8)),
        child: Text(_titleCase(p['role'].toString()), style: TextStyle(color: c, fontSize: 9, fontWeight: FontWeight.w700))),
      const SizedBox(height: 6),
      Text(p['name']?.toString() ?? '?', style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      Text('${p['lagna'] ?? ''} ${l.cpLagnaSuffix}', style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
      if (p['moon_sign'] != null) Text('${p['moon_sign']} ${l.cpMoonSuffix}', style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
    ]));

  // ══════════════════════════════════════════════════════════════════
  //  3 — NUMBER OF CHILDREN & GENDER TENDENCY
  // ══════════════════════════════════════════════════════════════════
  Widget _numberOfChildren(AppLocalizations l) {
    final n = _map('number_of_children');
    if (n.isEmpty) return const SizedBox.shrink();
    final first = _mapOf(n, 'first_child_indications');
    final tendency = _strOf(first, 'likely_gender_tendency');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.child_care_rounded, title: l.cpNumberTitle, color: AppColors.gold),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.14), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.gold.withOpacity(0.28))),
        child: Column(children: [
          Text(l.cpProbableNumber, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(_strOf(n, 'probable_number'), style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          if (_strOf(n, 'number_reasoning').isNotEmpty) ...[const SizedBox(height: 8),
            Text(_cap(_strOf(n, 'number_reasoning')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.5), textAlign: TextAlign.center)],
        ])),
      const SizedBox(height: 10),
      if (tendency.isNotEmpty) _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(l.cpFirstChildTendency, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w800))),
          _pill(_titleCase(tendency), tendency.toLowerCase().contains('son') ? KColors.blue : KColors.purple),
        ]),
        if (_strOf(first, 'gender_reasoning').isNotEmpty) ...[const SizedBox(height: 8),
          Text(_cap(_strOf(first, 'gender_reasoning')), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.4))],
        if (_strOf(first, 'd7_first_child_signature').isNotEmpty) ...[const SizedBox(height: 8),
          Text(_strOf(first, 'd7_first_child_signature'), style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, height: 1.35, fontStyle: FontStyle.italic))],
      ])),
      if (_strOf(n, 'spacing_note').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: _iconTile('📏', l.cpSpacing, _strOf(n, 'spacing_note'))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — TIMING (MOOLA DASHA)
  // ══════════════════════════════════════════════════════════════════
  Widget _timing(AppLocalizations l) {
    final t = _map('timing_moola_dasha');
    if (t.isEmpty) return const SizedBox.shrink();
    final combinedScore = _scOf(t, 'combined_timing_score');
    final windows = _listOf(t, 'favorable_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.hourglass_bottom_rounded, title: l.cpTimingTitle, color: KColors.green),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(l.cpCombinedTiming, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w800))),
          Text('${combinedScore.toStringAsFixed(0)}%', style: TextStyle(color: _col(combinedScore), fontSize: 18, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: (combinedScore / 100).clamp(0, 1), minHeight: 7, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(_col(combinedScore)))),
        if (_strOf(t, 'timing_verdict').isNotEmpty) ...[const SizedBox(height: 10),
          Text(_cap(_strOf(t, 'timing_verdict')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
      ])),
      const SizedBox(height: 10),
      _dashaPartnerBlock(l, widget.participants.isNotEmpty ? widget.participants[0] : l.partnerOneLabel, _mapOf(t, 'current_dasha_partner1')),
      const SizedBox(height: 8),
      _dashaPartnerBlock(l, widget.participants.length > 1 ? widget.participants[1] : l.partnerTwoLabel, _mapOf(t, 'current_dasha_partner2')),
      if (windows.isNotEmpty) ...[const SizedBox(height: 10),
        ...windows.map((w) => _windowCard(l, w))],
      if (_strOf(t, 'next_favorable_window').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4),
        child: Container(padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: KColors.green.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: KColors.green.withOpacity(0.25))),
          child: Row(children: [
            const Icon(Icons.event_available_rounded, size: 16, color: KColors.green), const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.cpNextWindow, style: const TextStyle(color: KColors.green, fontSize: 9.5, fontWeight: FontWeight.w700)),
              Text(_strOf(t, 'next_favorable_window'), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, fontWeight: FontWeight.w600)),
            ])),
          ]))),
    ]);
  }

  Widget _dashaPartnerBlock(AppLocalizations l, String name, Map pd) {
    if (pd.isEmpty) return const SizedBox.shrink();
    final moola = _mapOf(pd, 'moola');
    final favScore = _scOf(pd, 'favorability_score');
    final col = _col(favScore);
    final activating = _listOf(pd, 'progeny_activating_planets').map((e) => e.toString()).toList();
    return Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(name, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w800))),
          if (_strOf(pd, 'progeny_favorability').isNotEmpty) _pill(_titleCase(_strOf(pd, 'progeny_favorability')), col),
        ]),
        const SizedBox(height: 6),
        if (moola['md'] != null) Text('${l.mahadashaLabel}: ${moola['md']} (${moola['md_start']} — ${moola['md_end']})', style: const TextStyle(color: AppColors.ivory, fontSize: 10.5)),
        if (moola['ad'] != null) Text('${l.antardashaLabel}: ${moola['ad']} (${moola['ad_start']} — ${moola['ad_end']})', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5)),
        if (moola['pd'] != null) Text('${l.pratyantardashaLabel}: ${moola['pd']}', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5)),
        const SizedBox(height: 6),
        ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (favScore / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
        if (_strOf(pd, 'reasoning').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
          child: Text(_strOf(pd, 'reasoning'), style: const TextStyle(color: AppColors.parchment, fontSize: 10.5, height: 1.35, fontStyle: FontStyle.italic))),
        if (activating.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
          child: Wrap(spacing: 5, runSpacing: 4, children: activating.map((p) => _pill(p, AppColors.gold)).toList())),
      ]));
  }

  Widget _windowCard(AppLocalizations l, Map<String, dynamic> w) {
    final strength = _strOf(w, 'strength');
    final col = strength.toLowerCase().contains('strong') ? KColors.green : strength.toLowerCase().contains('moderate') ? KColors.blue : KColors.purple;
    return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: col.withOpacity(0.22))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(w['period']?.toString() ?? '', style: TextStyle(color: col, fontSize: 12, fontWeight: FontWeight.w800))),
          if (strength.isNotEmpty) _pill(_titleCase(strength), col),
        ]),
        if (w['start_date'] != null || w['end_date'] != null) Padding(padding: const EdgeInsets.only(top: 3),
          child: Text('${w['start_date'] ?? ''} — ${w['end_date'] ?? ''}', style: const TextStyle(color: AppColors.smoke, fontSize: 10))),
        if (w['activating_factor'] != null) Padding(padding: const EdgeInsets.only(top: 4),
          child: Text(w['activating_factor'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 10.5, height: 1.3))),
        if (w['applies_to'] != null) Padding(padding: const EdgeInsets.only(top: 2),
          child: Text('→ ${w['applies_to']}', style: const TextStyle(color: AppColors.smoke, fontSize: 10))),
      ]));
  }

  // ══════════════════════════════════════════════════════════════════
  //  5 — 5TH HOUSE ANALYSIS (per person)
  // ══════════════════════════════════════════════════════════════════
  Widget _fifthHouse(AppLocalizations l) {
    final fifth = _map('fifth_house_analysis');
    if (fifth.isEmpty) return const SizedBox.shrink();
    final colors = [KColors.purple, KColors.blue];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.home_rounded, title: l.cp5thHouseTitle, subtitle: l.cp5thHouseSubtitle, color: KColors.purple),
      ...fifth.entries.toList().asMap().entries.map((e) {
        final key = e.value.key;
        final m = e.value.value is Map ? (e.value.value as Map).cast<String, dynamic>() : <String, dynamic>{};
        final c = colors[e.key % colors.length];
        final score = _scOf(m, 'house_strength_score');
        final occupants = _listOf(m, 'occupants').map((o) => o.toString()).toList();
        final benefics = _listOf(m, 'benefic_aspects').map((o) => o.toString()).toList();
        final malefics = _listOf(m, 'malefic_aspects').map((o) => o.toString()).toList();
        return Container(
          margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(_personLabel(key), style: TextStyle(color: c, fontSize: 13.5, fontWeight: FontWeight.w800))),
              Text('${m['sign_english'] ?? m['sign'] ?? ''}', style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _statTile(l.lordLabel, score, valueOverride: m['lord']?.toString())),
              const SizedBox(width: 10),
              Expanded(child: _statTile(l.houseStrengthLabel, score)),
            ]),
            if (m['lord_in_dusthana'] == true) Padding(padding: const EdgeInsets.only(top: 8), child: _pill(l.lordInDusthana, KColors.red)),
            if (occupants.isNotEmpty) ...[const SizedBox(height: 8), _chipBlock('🪐', l.occupants, occupants, KColors.blue)],
            if (benefics.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('✓', l.beneficAspects, benefics, KColors.green)],
            if (malefics.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('⚠️', l.maleficAspects, malefics, KColors.red)],
            if (_strOf(m, 'interpretation').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
              child: Text(_strOf(m, 'interpretation'), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.4))),
            _advanced(l, [
              '${l.lordPlacementLabel}: ${m['lord_placement_house']}H · ${l.lordDignityLabel}: ${m['lord_dignity']}',
            ]),
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  6 — JUPITER / PUTRAKARAKA ANALYSIS
  // ══════════════════════════════════════════════════════════════════
  Widget _jupiter(AppLocalizations l) {
    final jup = _map('jupiter_analysis');
    if (jup.isEmpty) return const SizedBox.shrink();
    final colors = [KColors.purple, KColors.blue];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.stars_rounded, title: l.cpJupiterTitle, subtitle: l.cpJupiterSubtitle, color: AppColors.gold),
      ...jup.entries.toList().asMap().entries.map((e) {
        final key = e.value.key;
        final m = e.value.value is Map ? (e.value.value as Map).cast<String, dynamic>() : <String, dynamic>{};
        final c = colors[e.key % colors.length];
        final strength = _scOf(m, 'strength');
        return Container(
          margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(_personLabel(key), style: TextStyle(color: c, fontSize: 13.5, fontWeight: FontWeight.w800))),
              Text('${m['sign'] ?? ''} · ${m['house'] ?? ''}H', style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 8),
            _statTile(l.dignityLabel, strength, valueOverride: m['dignity']?.toString()),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              _pill(m['retrograde'] == true ? l.retrograde : l.directBadge, m['retrograde'] == true ? KColors.orange : KColors.green),
              _pill(m['combust'] == true ? l.combust : l.notCombustBadge, m['combust'] == true ? KColors.orange : KColors.green),
              if (m['in_5th_house'] == true) _pill(l.in5thHouseBadge, KColors.green),
              if (m['aspects_5th_house'] == true) _pill(l.aspects5thBadge, KColors.green),
              if (m['in_5th_house'] != true && m['aspects_5th_house'] != true) _pill(l.no5thConnectionBadge, AppColors.smoke),
            ]),
            if (_strOf(m, 'interpretation').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
              child: Text(_strOf(m, 'interpretation'), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.4))),
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — D7 SAPTAMSA ANALYSIS
  // ══════════════════════════════════════════════════════════════════
  Widget _d7(AppLocalizations l) {
    final d7 = _map('d7_saptamsa_analysis');
    if (d7.isEmpty) return const SizedBox.shrink();
    final colors = [KColors.purple, KColors.blue];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.grid_view_rounded, title: l.cpD7Title, subtitle: l.cpD7Subtitle, color: KColors.blue),
      ...d7.entries.toList().asMap().entries.map((e) {
        final key = e.value.key;
        final m = e.value.value is Map ? (e.value.value as Map).cast<String, dynamic>() : <String, dynamic>{};
        final c = colors[e.key % colors.length];
        final strength = _scOf(m, 'd7_strength');
        final signs = _mapOf(m, 'd7_planet_signs');
        return Container(
          margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(_personLabel(key), style: TextStyle(color: c, fontSize: 13.5, fontWeight: FontWeight.w800))),
              Text('${m['d7_lagna_sign_english'] ?? m['d7_lagna_sign'] ?? ''} ${l.cpLagnaSuffix}', style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 8),
            _statTile(l.cpD7Strength, strength),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              if (m['d7_fifth_sign'] != null) _pill('5H: ${m['d7_fifth_sign']}', KColors.blue),
              if (m['jupiter_d7_house'] != null) _pill('${l.jupiterInD7Label}: ${m['jupiter_d7_house']}H', AppColors.gold),
            ]),
            if (signs.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
              child: Wrap(spacing: 6, runSpacing: 6, children: signs.entries.map((pe) => _pill('${pe.key}: ${pe.value}', c)).toList())),
            if (_strOf(m, 'interpretation').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
              child: Text(_strOf(m, 'interpretation'), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.4))),
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — BEEJA & KSHETRA SPHUTA
  // ══════════════════════════════════════════════════════════════════
  Widget _beejaKshetra(AppLocalizations l) {
    final bk = _map('beeja_kshetra_sphuta');
    if (bk.isEmpty) return const SizedBox.shrink();
    final beeja = _mapOf(bk, 'beeja_sphuta');
    final kshetra = _mapOf(bk, 'kshetra_sphuta');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.spa_rounded, title: l.cpSphutaTitle, color: KColors.purple),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (beeja.isNotEmpty) Expanded(child: _sphutaCard(l.cpBeejaSphuta, KColors.blue, beeja)),
        if (beeja.isNotEmpty && kshetra.isNotEmpty) const SizedBox(width: 10),
        if (kshetra.isNotEmpty) Expanded(child: _sphutaCard(l.cpKshetraSphuta, KColors.purple, kshetra)),
      ]),
      if (_strOf(bk, 'combined_fertility_indication').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: _card(child: Text(_strOf(bk, 'combined_fertility_indication'), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4)))),
    ]);
  }

  Widget _sphutaCard(String title, Color c, Map sp) {
    final score = _scOf(sp, 'strength_score');
    final col = _col(score);
    final factors = _listOf(sp, 'factors').map((f) => f.toString()).toList();
    return Container(padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.22))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: c, fontSize: 11.5, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Row(children: [
          Text(score.toStringAsFixed(0), style: TextStyle(color: col, fontSize: 22, fontWeight: FontWeight.w800)),
          Text('/100', style: TextStyle(color: col.withOpacity(0.6), fontSize: 10)),
        ]),
        ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
        if (sp['sign'] != null) Padding(padding: const EdgeInsets.only(top: 6),
          child: Text('${sp['sign']} ${sp['degree'] ?? ''}', style: const TextStyle(color: AppColors.smoke, fontSize: 10))),
        if (factors.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
          child: Wrap(spacing: 4, runSpacing: 4, children: factors.map((f) => _pill(f, c)).toList())),
        if (sp['interpretation'] != null) Padding(padding: const EdgeInsets.only(top: 6),
          child: Text(sp['interpretation'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 10, height: 1.35))),
      ]));
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — DOSHA ANALYSIS
  // ══════════════════════════════════════════════════════════════════
  Widget _dosha(AppLocalizations l) {
    final d = _map('dosha_analysis');
    if (d.isEmpty) return const SizedBox.shrink();
    final doshas = _listOf(d, 'doshas_detected').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final penalty = _scOf(d, 'total_dosha_penalty');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.warning_amber_rounded, title: l.cpDoshaTitle, color: KColors.orange),
      if (doshas.isEmpty)
        Container(padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: KColors.green.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.green.withOpacity(0.2))),
          child: Row(children: [const Icon(Icons.check_circle_rounded, size: 17, color: KColors.green), const SizedBox(width: 10),
            Expanded(child: Text(l.cpNoDoshasDetected, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5)))]))
      else ...[
        Container(padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: KColors.orange.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.orange.withOpacity(0.2))),
          child: Row(children: [
            Expanded(child: Text(l.totalDoshaPenalty, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w700))),
            Text('-${penalty.toStringAsFixed(1)}', style: const TextStyle(color: KColors.orange, fontSize: 16, fontWeight: FontWeight.w800)),
          ])),
        if (_strOf(d, 'dosha_summary').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
          child: Text(_strOf(d, 'dosha_summary'), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
        const SizedBox(height: 8),
        ...doshas.map((dm) {
          final severity = _strOf(dm, 'severity');
          final col = severity.toLowerCase().contains('high') || severity.toLowerCase().contains('severe') ? KColors.red
              : severity.toLowerCase().contains('moderate') ? KColors.orange : KColors.yellow;
          return Container(
            margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.24))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(dm['dosha_name']?.toString() ?? '', style: TextStyle(color: col, fontSize: 13, fontWeight: FontWeight.w800))),
                if (severity.isNotEmpty) _pill(severity, col),
              ]),
              if (dm['present_in'] != null) Padding(padding: const EdgeInsets.only(top: 4),
                child: Text('${l.presentInLabel}: ${dm['present_in']}', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5))),
              if (dm['description'] != null) Padding(padding: const EdgeInsets.only(top: 6),
                child: Text(dm['description'].toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
              if (dm['cancellation_factors'] != null) Padding(padding: const EdgeInsets.only(top: 6),
                child: Container(padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(color: KColors.green.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                  child: Text(dm['cancellation_factors'].toString(), style: const TextStyle(color: KColors.green, fontSize: 10.5, height: 1.35)))),
            ]),
          );
        }),
      ],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — REMEDIES
  // ══════════════════════════════════════════════════════════════════
  Widget _remedies(AppLocalizations l) {
    final r = _map('remedies');
    final list = _listOf(r, 'recommended_remedies').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (list.isEmpty && _strOf(r, 'general_guidance').isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.healing_rounded, title: l.cpRemediesTitle, color: KColors.green),
      ...list.map((m) => Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: KColors.purple.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.purple.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            if (m['remedy_type'] != null) _pill(_titleCase(m['remedy_type'].toString()), KColors.purple),
            const Spacer(),
            if (m['for_whom'] != null) Text(_titleCase(m['for_whom'].toString()), style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
          ]),
          const SizedBox(height: 6),
          Text(_cap(m['remedy']?.toString() ?? ''), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45)),
          if (m['addresses'] != null) Padding(padding: const EdgeInsets.only(top: 6),
            child: Text('${l.cpAddresses}: ${m['addresses']}', style: const TextStyle(color: AppColors.parchment, fontSize: 10.5, height: 1.3))),
          _advanced(l, [if (m['classical_basis'] != null) m['classical_basis'].toString()]),
        ]),
      )),
      if (_strOf(r, 'general_guidance').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4),
        child: Text(_strOf(r, 'general_guidance'), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.4, fontStyle: FontStyle.italic))),
      if (_strOf(r, 'medical_note').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: Text(_strOf(r, 'medical_note'), style: const TextStyle(color: AppColors.smoke, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  11 — SUMMARY & KEY INSIGHTS
  // ══════════════════════════════════════════════════════════════════
  Widget _summary(AppLocalizations l) {
    final s = _map('summary');
    final insights = _listOf(s, 'key_insights').map((e) => e.toString()).toList();
    final human = _strOf(s, 'human_summary');
    if (insights.isEmpty && human.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.summarize_rounded, title: l.summary, color: AppColors.gold),
      if (human.isNotEmpty) _card(child: Text(_cap(human), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.5))),
      if (insights.isNotEmpty) ...[const SizedBox(height: 10),
        ...insights.map((s2) => Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.gold.withOpacity(0.2))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.check_circle_rounded, size: 15, color: AppColors.gold), const SizedBox(width: 9),
            Expanded(child: Text(_cap(s2), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
          ]))),
      ],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  12 — PREDICTION RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final explain = _str('confidence_explanation');
    final disclaimer = _str('engine_disclaimer');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.crReliability, color: KColors.blue),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          KStars(filled: kStars(pct), size: 20, color: AppColors.gold), const Spacer(),
          Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 4),
        Text(band, style: const TextStyle(color: KColors.green, fontSize: 13, fontWeight: FontWeight.w800)),
        if (explain.isNotEmpty) ...[const SizedBox(height: 10),
          Text(_cap(explain), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5))],
      ])),
      if (disclaimer.isNotEmpty) ...[const SizedBox(height: 10),
        Text(disclaimer, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, height: 1.4, fontStyle: FontStyle.italic))],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  13 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.cpTopicTiming, l.cpTopicNumber, l.cpTopicDosha, l.cpTopicRemedies, l.cpTopicFifthHouse, l.cpTopicJupiter];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.forum_rounded, title: l.crDiscussAi, color: AppColors.gold),
      Row(children: [
        _aiBtn('ChatGPT', '🤖', () => _launchAi(_data, 'chatgpt')),
        _aiBtn('Claude', '✳️', () => _launchAi(_data, 'claude')),
        _aiBtn('Gemini', '💎', () => _launchAi(_data, 'gemini')),
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
    final q = '$topic — based on the child-probability report for ${widget.participants.join(' & ')}.\n\n${_buildPrompt(_data)}';
    Clipboard.setData(ClipboardData(text: q));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.crTopicCopied), duration: const Duration(seconds: 2)));
  }

  // ══════════════════════════════════════════════════════════════════
  //  shared widgets / helpers
  // ══════════════════════════════════════════════════════════════════
  Widget _card({required Widget child}) => Container(padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.06))), child: child);

  Widget _pill(String t, Color c) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: c.withOpacity(0.25))),
    child: Text(t, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w600)));

  Widget _chipBlock(String emoji, String title, List<String> items, Color c) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 4), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(emoji, style: const TextStyle(fontSize: 13)), const SizedBox(width: 6),
        Text(title, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800))]),
      const SizedBox(height: 7),
      Wrap(spacing: 6, runSpacing: 6, children: items.take(8).map((e) => _pill(_cap(e), c)).toList()),
    ]));
  }

  Widget _iconTile(String emoji, String label, String value, {Color? color}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 17)), const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
      Text(value, style: TextStyle(color: color ?? AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis),
    ]),
  );

  Widget _statTile(String label, double score, {String? valueOverride}) {
    final c = _col(score);
    return Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(valueOverride ?? '${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
      ]));
  }

  Widget _advanced(AppLocalizations l, List<String>? lines, {String? customTitle, Widget? customChild}) {
    final valid = lines?.where((s) => s.trim().isNotEmpty).toList() ?? const [];
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

  String _personLabel(String key) => _titleCase(key.split('_').first);

  Color _col(double s) {
    if (s >= 75) return KColors.green;
    if (s >= 60) return KColors.blue;
    if (s >= 45) return KColors.yellow;
    if (s >= 30) return KColors.orange;
    return KColors.red;
  }
  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .where((w) => w.isNotEmpty).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── AI prompt / launch (unchanged behaviour) ──
  String _buildPrompt(Map<String, dynamic> d) {
    final overall = _mapOf(d, 'overall_probability');
    final score = overall['overall_probability_score'] ?? '?';
    final grade = overall['probability_grade'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic child-probability and progeny-timing advisor. Analyze this report for ${widget.participants.join(' & ')} and provide actionable insights.

Key highlights:
- Overall progeny probability: $score/100 ($grade)

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the most favorable timing windows, and suggest practical next steps.''';
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.reportCopiedOpeningAi(ai)), duration: const Duration(seconds: 3)));
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
