import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Past-Life Karma Linkage report — premium AI karmic-linkage coach
/// redesign, for the N-way (2-5 chart) karma linkage specialist.
///
/// Presentation only. Receives the already-loaded `karma_linkage`
/// specialist result (`runKarmaLinkage`, a Moola-Dasha multi-chart
/// analysis) and re-presents it; every score, karmic factor, dasha window,
/// debt and confidence value comes straight from the engine. Constructor
/// unchanged so the multi-chart picker does not need to change.
class KarmaLinkageReportScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final List<String> participants;
  const KarmaLinkageReportScreen({super.key, required this.data, required this.participants});
  @override
  State<KarmaLinkageReportScreen> createState() => _KarmaLinkageReportState();
}

class _KarmaLinkageReportState extends State<KarmaLinkageReportScreen> {
  Map<String, dynamic> get _data => widget.data;

  // ── typed accessors (type-checked, never throw on unexpected shapes) ──
  double _sc(String k) { final v = _data[k]; return v is num ? v.toDouble() : 0; }
  double _scOf(Map m, String k) { final v = m[k]; return v is num ? v.toDouble() : 0; }
  String _str(String k) { final v = _data[k]; return (v == null || v is List || v is Map) ? '' : v.toString(); }
  String _strOf(Map m, String k) { final v = m[k]; return (v == null || v is List || v is Map) ? '' : v.toString(); }
  Map<String, dynamic> _map(String k) { final v = _data[k]; return v is Map ? v.cast<String, dynamic>() : {}; }
  Map<String, dynamic> _mapOf(Map m, String k) { final v = m[k]; return v is Map ? v.cast<String, dynamic>() : {}; }
  List _list(String k) { final v = _data[k]; return v is List ? v : const []; }
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
          Text(l.klSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
        ]),
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 40), children: _sections(l)),
    );
  }

  List<Widget> _sections(AppLocalizations l) {
    const gap = SizedBox(height: 18);
    return [
      _breadcrumb(l),
      const SizedBox(height: 10),
      _snapshot(l),           // 1
      gap, _chartProfiles(l),    // 2
      gap, _perChartFoundation(l), // 3
      gap, _pairwiseLinkages(l), // 4
      gap, _groupPattern(l),     // 5
      gap, _pastLifeGoals(l),    // 6
      gap, _currentLifeLearning(l), // 7
      gap, _karmicDebts(l),      // 8
      gap, _moolaTiming(l),      // 9
      gap, _auditTable(l),       // 10
      gap, _summary(l),          // 11
      gap, _reliability(l),      // 12
      gap, _discussAi(l),        // 13
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.klTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — KARMIC LINKAGE SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _map('overall_linkage_probability');
    final score = _scOf(overall, 'overall_linkage_score');
    final col = _col(score);
    final grade = _strOf(overall, 'linkage_grade');
    final comps = _mapOf(overall, 'score_components');
    final summary = _strOf(overall, 'linkage_verdict').isNotEmpty ? _strOf(overall, 'linkage_verdict') : _str('confidence_explanation');
    final gauges = <List<Object>>[
      [l.klGaugePairwise, _scOf(comps, 'avg_pairwise_linkage')],
      [l.klGaugeCohesion, _scOf(comps, 'group_cohesion')],
      [l.klGaugeRahuKetu, _scOf(comps, 'rahu_ketu_axis_resonance')],
      [l.klGaugeAtmakaraka, _scOf(comps, 'atmakaraka_resonance')],
      [l.klGaugeD60, _scOf(comps, 'd60_group_resonance')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.klSnapshotHeader.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
    if (_scOf(comps, 'atmakaraka_resonance') >= 50) out.add(l.klChipSoulResonance);
    if (_scOf(comps, 'd60_group_resonance') >= 50) out.add(l.klChipD60Resonance);
    if (_scOf(comps, 'group_cohesion') >= 50) out.add(l.klChipCohesiveGroup);
    final debts = _listOf(_map('karmic_debts_resolutions'), 'debts_detected');
    if (debts.isEmpty) out.add(l.klChipNoDebts);
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
  //  2 — CHART PROFILES
  // ══════════════════════════════════════════════════════════════════
  Widget _chartProfiles(AppLocalizations l) {
    final header = _map('analysis_header');
    final charts = _listOf(header, 'charts').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (charts.isEmpty) return const SizedBox.shrink();
    final colors = [KColors.blue, KColors.purple, AppColors.gold, KColors.green, KColors.orange];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.people_alt_rounded, title: l.klProfilesTitle, subtitle: l.riProfilesSubtitle(charts.length.toString()), color: KColors.blue),
      ...charts.asMap().entries.map((e) {
        final p = e.value;
        final c = colors[e.key % colors.length];
        return Container(
          margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p['name']?.toString() ?? '?', style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Wrap(spacing: 8, runSpacing: 6, children: [
              if (p['lagna'] != null) _pill('${l.cpLagnaSuffix}: ${p['lagna']}', c),
              if (p['moon_sign'] != null) _pill('${l.cpMoonSuffix}: ${p['moon_sign']}', c),
              if (p['atmakaraka'] != null) _pill('AK: ${p['atmakaraka']}', c),
            ]),
            if (p['ketu_position'] != null || p['rahu_position'] != null) Padding(padding: const EdgeInsets.only(top: 8),
              child: Text('${l.klKetuAt}: ${p['ketu_position'] ?? ''} · ${l.klRahuAt}: ${p['rahu_position'] ?? ''}', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5))),
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  3 — PER-CHART KARMIC FOUNDATION
  // ══════════════════════════════════════════════════════════════════
  Widget _perChartFoundation(AppLocalizations l) {
    final foundations = _list('per_chart_karmic_foundation').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (foundations.isEmpty) return const SizedBox.shrink();
    final colors = [KColors.blue, KColors.purple, AppColors.gold, KColors.green, KColors.orange];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.history_edu_rounded, title: l.klFoundationTitle, subtitle: l.klFoundationSubtitle, color: KColors.purple),
      ...foundations.asMap().entries.map((e) {
        final f = e.value;
        final c = colors[e.key % colors.length];
        final ketu = _mapOf(f, 'ketu_mastery');
        final rahu = _mapOf(f, 'rahu_growth');
        final ak = _mapOf(f, 'atmakaraka');
        final saturn = _mapOf(f, 'saturn_karma');
        final ninth = _mapOf(f, 'ninth_house_punya');
        final d60 = _mapOf(f, 'd60_signature');
        return Container(
          margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(f['chart_name']?.toString() ?? '?', style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w800)),
            if (f['individual_karmic_summary'] != null) Padding(padding: const EdgeInsets.only(top: 6, bottom: 8),
              child: Text(_cap(f['individual_karmic_summary'].toString()), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45))),
            Row(children: [
              if (ketu.isNotEmpty) Expanded(child: _statTile(l.klKetuMastery, _scOf(ketu, 'mastery_score'))),
              if (ketu.isNotEmpty && rahu.isNotEmpty) const SizedBox(width: 8),
              if (rahu.isNotEmpty) Expanded(child: _statTile(l.klRahuGrowth, _scOf(rahu, 'growth_score'))),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              if (ninth.isNotEmpty) Expanded(child: _statTile(l.klNinthHousePunya, _scOf(ninth, 'bhava_score'))),
              if (ninth.isNotEmpty && d60.isNotEmpty) const SizedBox(width: 8),
              if (d60.isNotEmpty) Expanded(child: _statTile(l.klD60Depth, _scOf(d60, 'karmic_depth_score'))),
            ]),
            _advanced(l, [
              if (ketu.isNotEmpty) '${l.klKetuMastery}: H${ketu['house']} ${ketu['sign']} · ${ketu['interpretation'] ?? ''}',
              if (rahu.isNotEmpty) '${l.klRahuGrowth}: H${rahu['house']} ${rahu['sign']} · ${rahu['interpretation'] ?? ''}',
              if (ak.isNotEmpty) '${l.klAtmakarakaAgenda}: ${ak['planet']} · ${ak['soul_agenda'] ?? ''}',
              if (saturn.isNotEmpty) '${l.klSaturnKarma}: H${saturn['house']} ${saturn['sign']} · ${saturn['karmic_duty'] ?? ''}',
              if (ninth.isNotEmpty) ninth['accumulated_merit']?.toString() ?? '',
              if (d60.isNotEmpty) d60['interpretation']?.toString() ?? '',
            ]),
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — PAIRWISE KARMIC LINKAGES
  // ══════════════════════════════════════════════════════════════════
  Widget _pairwiseLinkages(AppLocalizations l) {
    final pairs = _list('pairwise_karmic_linkages').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (pairs.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.compare_arrows_rounded, title: l.klPairwiseTitle, subtitle: l.riPairwiseSubtitle(pairs.length.toString()), color: KColors.blue),
      ...pairs.map((p) {
        final score = _scOf(p, 'linkage_strength_score');
        final col = _col(score);
        final factors = _listOf(p, 'linkage_factors').whereType<Map>().map((e) => e.cast<String, dynamic>()).where((m) => m['present'] == true).toList();
        return Container(
          margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(18), border: Border.all(color: col.withOpacity(0.24))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(p['pair']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w800))),
              Column(children: [
                Text(score.toStringAsFixed(0), style: TextStyle(color: col, fontSize: 20, fontWeight: FontWeight.w800)),
                if (p['linkage_probability'] != null) Text(p['linkage_probability'].toString(), style: TextStyle(color: col, fontSize: 9, fontWeight: FontWeight.w700)),
              ]),
            ]),
            const SizedBox(height: 6),
            if (p['karmic_relationship_type'] != null) Wrap(spacing: 6, runSpacing: 6, children: [
              _pill(_titleCase(p['karmic_relationship_type'].toString()), KColors.purple),
            ]),
            if (p['relationship_type_meaning'] != null) Padding(padding: const EdgeInsets.only(top: 8),
              child: Text(_cap(p['relationship_type_meaning'].toString()), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
            if (p['what_they_teach_each_other'] != null) Padding(padding: const EdgeInsets.only(top: 8),
              child: Text('🎓 ${p['what_they_teach_each_other']}', style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
            _advanced(l, [
              if (p['past_life_connection'] != null) p['past_life_connection'].toString(),
              if (p['current_life_dynamic'] != null) p['current_life_dynamic'].toString(),
              '${l.klActiveFactors}: ${factors.length}',
              ...factors.take(5).map((f) => '${f['factor']}: ${f['meaning'] ?? ''}'),
            ]),
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  5 — GROUP KARMIC PATTERN
  // ══════════════════════════════════════════════════════════════════
  Widget _groupPattern(AppLocalizations l) {
    final g = _map('group_karmic_pattern');
    if (g.isEmpty) return const SizedBox.shrink();
    final ketuPattern = _mapOf(g, 'collective_ketu_pattern');
    final rahuPattern = _mapOf(g, 'collective_rahu_pattern');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.diversity_3_rounded, title: l.klGroupPatternTitle, color: AppColors.gold),
      if (_strOf(g, 'group_karmic_theme').isNotEmpty)
        Container(padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.14), AppColors.card.withOpacity(0.4)]),
            borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.gold.withOpacity(0.28))),
          child: Text(_cap(_strOf(g, 'group_karmic_theme')), style: const TextStyle(color: AppColors.ivory, fontSize: 13, height: 1.45, fontWeight: FontWeight.w600))),
      const SizedBox(height: 10),
      if (_strOf(g, 'shared_past_life_setting').isNotEmpty)
        _iconTile('🏛️', l.klSharedSetting, _cap(_strOf(g, 'shared_past_life_setting'))),
      const SizedBox(height: 10),
      _statTile(l.klCohesionScore, _scOf(g, 'karmic_cohesion_score')),
      if (_strOf(g, 'cohesion_interpretation').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: Text(_strOf(g, 'cohesion_interpretation'), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
      if (_strOf(g, 'group_soul_contract').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: Text(_cap(_strOf(g, 'group_soul_contract')), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
      _advanced(l, [
        if (ketuPattern.isNotEmpty) ketuPattern['interpretation']?.toString() ?? '',
        if (rahuPattern.isNotEmpty) rahuPattern['interpretation']?.toString() ?? '',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  6 — PAST-LIFE GOALS
  // ══════════════════════════════════════════════════════════════════
  Widget _pastLifeGoals(AppLocalizations l) {
    final p = _map('past_life_goals');
    if (p.isEmpty) return const SizedBox.shrink();
    final individual = _listOf(p, 'individual_past_goals').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.flag_circle_rounded, title: l.klPastGoalsTitle, color: KColors.purple),
      if (_strOf(p, 'shared_past_life_goal').isNotEmpty)
        _card(child: Text(_cap(_strOf(p, 'shared_past_life_goal')), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.5))),
      const SizedBox(height: 10),
      ...individual.map((m) => Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: KColors.purple.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.purple.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(m['chart_name']?.toString() ?? '', style: const TextStyle(color: KColors.purple, fontSize: 12.5, fontWeight: FontWeight.w800))),
            if (m['completion_status'] != null) _pill(_titleCase(m['completion_status'].toString()), KColors.purple),
          ]),
          if (m['past_life_goal'] != null) Padding(padding: const EdgeInsets.only(top: 6),
            child: Text(_cap(m['past_life_goal'].toString()), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
          if (m['carryover_to_now'] != null) Padding(padding: const EdgeInsets.only(top: 6),
            child: Text(m['carryover_to_now'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 10.5, height: 1.35, fontStyle: FontStyle.italic))),
        ]))),
      if (_strOf(p, 'goal_completion_assessment').isNotEmpty)
        Text(_strOf(p, 'goal_completion_assessment'), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.4)),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — CURRENT-LIFE LEARNING
  // ══════════════════════════════════════════════════════════════════
  Widget _currentLifeLearning(AppLocalizations l) {
    final c = _map('current_life_learning');
    if (c.isEmpty) return const SizedBox.shrink();
    final lessons = _listOf(c, 'individual_lessons').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final teaching = _listOf(c, 'mutual_teaching_map').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.school_rounded, title: l.klLearningTitle, color: KColors.blue),
      if (_strOf(c, 'shared_group_lesson').isNotEmpty)
        _card(child: Text(_cap(_strOf(c, 'shared_group_lesson')), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.5))),
      const SizedBox(height: 10),
      ...lessons.map((m) => Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: KColors.blue.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.blue.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(m['chart_name']?.toString() ?? '', style: const TextStyle(color: KColors.blue, fontSize: 12.5, fontWeight: FontWeight.w800))),
            if (m['lesson_house'] != null) _pill('H${m['lesson_house']}', KColors.blue),
          ]),
          if (m['new_lesson'] != null) Padding(padding: const EdgeInsets.only(top: 6),
            child: Text(_cap(m['new_lesson'].toString()), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
          if (m['how_to_grow'] != null) Padding(padding: const EdgeInsets.only(top: 6),
            child: Text('✓ ${m['how_to_grow']}', style: const TextStyle(color: KColors.green, fontSize: 10.5, height: 1.35))),
          if (m['moola_dasha_activation'] != null) Padding(padding: const EdgeInsets.only(top: 4),
            child: Text(m['moola_dasha_activation'].toString(), style: const TextStyle(color: AppColors.smoke, fontSize: 9.5, fontStyle: FontStyle.italic))),
        ]))),
      if (teaching.isNotEmpty) ...[const SizedBox(height: 6),
        _catLabel('🎓', l.klTeachingMap, KColors.gold),
        ...teaching.map((t) => Container(
          margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.06), borderRadius: BorderRadius.circular(10)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${t['teacher']} → ${t['student']}', style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700)),
            if (t['subject'] != null) Text(t['subject'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 10.5, height: 1.3)),
          ]))),
      ],
      if (_strOf(c, 'group_growth_direction').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
        child: Text(_strOf(c, 'group_growth_direction'), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.4))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — KARMIC DEBTS & RESOLUTIONS
  // ══════════════════════════════════════════════════════════════════
  Widget _karmicDebts(AppLocalizations l) {
    final d = _map('karmic_debts_resolutions');
    if (d.isEmpty) return const SizedBox.shrink();
    final debts = _listOf(d, 'debts_detected').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.account_balance_rounded, title: l.klDebtsTitle, color: KColors.orange),
      if (debts.isEmpty)
        Container(padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: KColors.green.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.green.withOpacity(0.2))),
          child: Row(children: [const Icon(Icons.check_circle_rounded, size: 17, color: KColors.green), const SizedBox(width: 10),
            Expanded(child: Text(l.klNoDebtsDetected, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5)))]))
      else ...debts.map((dm) {
        final severity = _strOf(dm, 'severity');
        final col = severity.toLowerCase().contains('high') || severity.toLowerCase().contains('severe') ? KColors.red
            : severity.toLowerCase().contains('moderate') ? KColors.orange : KColors.yellow;
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.24))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text('${dm['debtor']} → ${dm['creditor']}', style: TextStyle(color: col, fontSize: 13, fontWeight: FontWeight.w800))),
              if (severity.isNotEmpty) _pill(_titleCase(severity), col),
            ]),
            if (dm['debt_type'] != null) Padding(padding: const EdgeInsets.only(top: 4),
              child: Text(_titleCase(dm['debt_type'].toString()), style: const TextStyle(color: AppColors.smoke, fontSize: 10.5))),
            if (dm['resolution_path'] != null) Padding(padding: const EdgeInsets.only(top: 6),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('✓ ', style: const TextStyle(color: KColors.green, fontWeight: FontWeight.w800)),
                Expanded(child: Text(dm['resolution_path'].toString(), style: const TextStyle(color: KColors.green, fontSize: 11, height: 1.35))),
              ])),
            _advanced(l, [
              if (dm['debt_basis'] != null) dm['debt_basis'].toString(),
              if (dm['moola_dasha_timing'] != null) dm['moola_dasha_timing'].toString(),
            ]),
          ]),
        );
      }),
      if (_strOf(d, 'resolution_summary').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4),
        child: Text(_strOf(d, 'resolution_summary'), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.4))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — MOOLA DASHA KARMIC TIMING
  // ══════════════════════════════════════════════════════════════════
  Widget _moolaTiming(AppLocalizations l) {
    final t = _map('moola_dasha_karmic_timing');
    if (t.isEmpty) return const SizedBox.shrink();
    final perChart = _listOf(t, 'per_chart_timing').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.hourglass_bottom_rounded, title: l.klTimingTitle, color: KColors.green),
      if (_strOf(t, 'group_karmic_window').isNotEmpty)
        _card(child: Text(_cap(_strOf(t, 'group_karmic_window')), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.5))),
      const SizedBox(height: 10),
      ...perChart.map((m) {
        final moola = _mapOf(m, 'current_moola');
        final activation = _strOf(m, 'karmic_activation');
        final col = activation.toLowerCase().contains('intense') ? KColors.orange : activation.toLowerCase().contains('active') ? KColors.blue : KColors.green;
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(m['chart_name']?.toString() ?? '', style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w800))),
              if (activation.isNotEmpty) _pill(_titleCase(activation), col),
            ]),
            if (moola['md'] != null) Padding(padding: const EdgeInsets.only(top: 6),
              child: Text('${l.mahadashaLabel}: ${moola['md']} · ${l.antardashaLabel}: ${moola['ad']} · ${l.pratyantardashaLabel}: ${moola['pd']}', style: const TextStyle(color: AppColors.ivory, fontSize: 10.5))),
            if (m['karmic_phase'] != null) Padding(padding: const EdgeInsets.only(top: 6),
              child: Text(m['karmic_phase'].toString(), style: const TextStyle(color: AppColors.gold, fontSize: 10.5, fontWeight: FontWeight.w600))),
            _advanced(l, [if (m['reasoning'] != null) m['reasoning'].toString()]),
          ]),
        );
      }),
      if (_strOf(t, 'timing_synthesis').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4),
        child: Text(_strOf(t, 'timing_synthesis'), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.4))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — DEEP AUDIT TABLE
  // ══════════════════════════════════════════════════════════════════
  Widget _auditTable(AppLocalizations l) {
    final a = _map('deep_audit_parameter_table');
    if (a.isEmpty) return const SizedBox.shrink();
    final params = _listOf(a, 'audited_parameters').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList()
      ..sort((x, y) => ((y['score'] is num ? y['score'] as num : null) ?? 0).compareTo((x['score'] is num ? x['score'] as num : null) ?? 0));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.fact_check_rounded, title: l.klAuditTitle, subtitle: l.klAuditSubtitle(_strOf(a, 'total_parameters_audited')), color: KColors.blue),
      _card(child: Column(children: params.take(10).map((p) {
        final score = (p['score'] is num ? p['score'] as num : null)?.toDouble() ?? 0;
        final c = _col(score);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
          Expanded(flex: 3, child: Text(p['parameter']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 10.5), maxLines: 1, overflow: TextOverflow.ellipsis)),
          Expanded(flex: 2, child: ClipRRect(borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
          const SizedBox(width: 6),
          SizedBox(width: 30, child: Text(score.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700))),
        ]));
      }).toList())),
      if (_strOf(a, 'audit_completeness').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: Text(_strOf(a, 'audit_completeness'), style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontStyle: FontStyle.italic))),
      _advanced(l, params.skip(10).map((p) => '${p['parameter']}: ${(p['score'] is num ? p['score'] as num : null)?.toStringAsFixed(0) ?? ''} (${p['classical_basis'] ?? ''})').toList()),
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
    final topics = <String>[l.klTopicLinkage, l.klTopicPairwise, l.klTopicDebts, l.klTopicLessons, l.klTopicTiming, l.klTopicGroup];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.forum_rounded, title: l.crDiscussAi, color: AppColors.gold),
      ReportAiChatCta(domainKey: 'life_path_luck', label: 'Life Path & Luck', emoji: '🌟'),
      const SizedBox(height: 14),
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
        Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w700)),
        Text(AppLocalizations.of(context)!.openLink, style: const TextStyle(color: AppColors.smoke, fontSize: 7, letterSpacing: 1)),
      ])))));

  void _copyTopic(String topic) {
    final q = '$topic — based on the past-life karma linkage report for ${widget.participants.join(' & ')}.\n\n${_buildPrompt(_data)}';
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

  Widget _catLabel(String emoji, String t, Color c) => Padding(padding: const EdgeInsets.only(bottom: 8, top: 2),
    child: Row(children: [Text(emoji, style: const TextStyle(fontSize: 13)), const SizedBox(width: 6),
      Text(t, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800))]));

  Widget _iconTile(String emoji, String label, String value, {Color? color}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 17)), const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
      Text(value, style: TextStyle(color: color ?? AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w800), maxLines: 3, overflow: TextOverflow.ellipsis),
    ]),
  );

  Widget _statTile(String label, double score) {
    final c = _col(score);
    return Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 16, fontWeight: FontWeight.w800)),
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
    final overall = _mapOf(d, 'overall_linkage_probability');
    final score = overall['overall_linkage_score'] ?? '?';
    final grade = overall['linkage_grade'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic past-life karma and multi-chart linkage advisor. Analyze this report for ${widget.participants.join(' & ')} and provide actionable insights.

Key highlights:
- Overall karmic linkage: $score/100 ($grade)

Full report data (JSON):
$jsonStr

Please explain the group's past-life connections in simple language, highlight the strongest karmic bonds, and suggest how each person can use this awareness practically.''';
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.copiedOpening(ai)), duration: const Duration(seconds: 3)));
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
