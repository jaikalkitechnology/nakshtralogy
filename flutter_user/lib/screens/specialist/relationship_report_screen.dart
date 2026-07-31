import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Relationship Intelligence report — premium AI group-dynamics coach
/// redesign, for the N-way (2-5 chart) relationship specialist.
///
/// Presentation only. Receives the already-loaded `relationship` specialist
/// result (`runRelationshipAnalysis`) and re-presents it; every score,
/// pairwise dimension, behavior pattern, karmic classification and
/// confidence value comes straight from the engine. Constructor unchanged
/// so the picker screen that navigates here does not need to change.
class RelationshipReportScreen extends StatefulWidget {
  final String names;
  final Map<String, dynamic> data;
  const RelationshipReportScreen({super.key, required this.names, required this.data});
  @override
  State<RelationshipReportScreen> createState() => _RelationshipReportState();
}

class _RelationshipReportState extends State<RelationshipReportScreen> {
  Map<String, dynamic> get _data => widget.data;

  // ── typed accessors (type-checked, never throw on unexpected shapes) ──
  double _sc(String k) { final v = _data[k]; return v is num ? v.toDouble() : 0; }
  double _scOf(Map m, String k) { final v = m[k]; return v is num ? v.toDouble() : 0; }
  String _str(String k) { final v = _data[k]; return (v == null || v is List || v is Map) ? '' : v.toString(); }
  String _strOf(Map m, String k) { final v = m[k]; return (v == null || v is List || v is Map) ? '' : v.toString(); }
  List _list(String k) { final v = _data[k]; return v is List ? v : const []; }
  Map<String, dynamic> _map(String k) { final v = _data[k]; return v is Map ? v.cast<String, dynamic>() : {}; }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.names, style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(l.riSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
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
      _snapshot(l),          // 1
      gap, _chartProfiles(l),   // 2
      gap, _groupDynamics(l),   // 3
      gap, _bestWorstPairs(l),  // 4
      gap, _pairwise(l),        // 5
      gap, _criticalPatterns(l), // 6
      gap, _groupRecs(l),       // 7
      gap, _individualGuidance(l), // 8
      gap, _coreTheme(l),       // 9
      gap, _reliability(l),     // 10
      gap, _discussAi(l),       // 11
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.riTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — GROUP SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final gd = _map('group_dynamics');
    final overall = _scOf(gd, 'group_overall_health_score');
    final col = _col(overall);
    final groupType = _strOf(_map('group_summary'), 'group_type');
    final summary = _str('human_summary').isNotEmpty ? '${_str('human_summary')} ${_str('actionable_advice')}' : _str('confidence_explanation');
    final gauges = <List<Object>>[
      [l.riGaugeCohesion, _scOf(gd, 'group_cohesion_score')],
      [l.riGaugeTrust, _scOf(gd, 'group_trust_climate_score')],
      [l.riGaugeProductivity, _scOf(gd, 'group_productivity_potential_score')],
      [l.riGaugeCreativity, _scOf(gd, 'group_creativity_potential_score')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.riSnapshotHeader.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
        if (groupType.isNotEmpty) Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
          child: Text(_titleCase(groupType), style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
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
    final cp = _map('critical_patterns');
    if (cp.values.every((v) => v is! List || v.isEmpty)) out.add(l.riChipNoAlerts);
    final gd = _map('group_dynamics');
    if (_scOf(gd, 'group_cohesion_score') >= 60) out.add(l.riChipStrongCohesion);
    if (_scOf(gd, 'group_trust_climate_score') >= 65) out.add(l.riChipHighTrust);
    if (gd['hidden_enemy_alert'] is Map && (gd['hidden_enemy_alert'] as Map)['present'] != true) out.add(l.riChipNoHiddenEnemy);
    if (_scOf(gd, 'group_overall_health_score') >= 65) out.add(l.riChipHealthyGroup);
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
    final charts = _list('charts_summary').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (charts.isEmpty) return const SizedBox.shrink();
    final colors = [KColors.blue, KColors.purple, AppColors.gold, KColors.green, KColors.orange];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.badge_rounded, title: l.riProfilesTitle, subtitle: l.riProfilesSubtitle(charts.length.toString()), color: KColors.blue),
      ...charts.asMap().entries.map((e) {
        final p = e.value;
        final c = colors[e.key % colors.length];
        return Container(
          margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(p['name']?.toString() ?? '?', style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w800))),
              Text('${p['lagna_sign_name'] ?? ''} ${l.riLagnaSuffix}', style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
            ]),
            if (p['character_archetype'] != null) Text(_titleCase(p['character_archetype'].toString()), style: TextStyle(color: c, fontSize: 11.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _miniBar(l.riIntegrity, _scOf(p, 'integrity_score'), c),
            _miniBar(l.riWarmth, _scOf(p, 'emotional_warmth_score'), c),
            _miniBar(l.riTrustworthiness, _scOf(p, 'trustworthiness_baseline_score'), c),
            _miniBar(l.riAssertiveness, _scOf(p, 'assertiveness_score'), c),
            const SizedBox(height: 4),
            Wrap(spacing: 6, runSpacing: 4, children: [
              if (p['atmakaraka_planet'] != null) _pill('AK: ${p['atmakaraka_planet']}', c),
              if (p['power_orientation'] != null) _pill(_titleCase(p['power_orientation'].toString()), c),
            ]),
          ]),
        );
      }),
    ]);
  }

  Widget _miniBar(String label, double v, Color c) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
    SizedBox(width: 78, child: Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10))),
    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
      child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
    const SizedBox(width: 6),
    SizedBox(width: 26, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700))),
  ]));

  // ══════════════════════════════════════════════════════════════════
  //  3 — GROUP DYNAMICS OVERVIEW
  // ══════════════════════════════════════════════════════════════════
  Widget _groupDynamics(AppLocalizations l) {
    final gd = _map('group_dynamics');
    if (gd.isEmpty) return const SizedBox.shrink();
    final hiddenEnemy = gd['hidden_enemy_alert'] is Map ? (gd['hidden_enemy_alert'] as Map).cast<String, dynamic>() : <String, dynamic>{};
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.diversity_3_rounded, title: l.riGroupDynamicsTitle, color: KColors.purple),
      Row(children: [
        if (_strOf(gd, 'most_supportive_member').isNotEmpty) Expanded(child: _iconTile('🤝', l.riMostSupportive, _strOf(gd, 'most_supportive_member'))),
        if (_strOf(gd, 'most_supportive_member').isNotEmpty && _strOf(gd, 'most_challenged_member').isNotEmpty) const SizedBox(width: 10),
        if (_strOf(gd, 'most_challenged_member').isNotEmpty) Expanded(child: _iconTile('🌱', l.riMostChallenged, _strOf(gd, 'most_challenged_member'))),
      ]),
      if (_strOf(gd, 'power_axis_in_group').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: _card(child: Text(_cap(_strOf(gd, 'power_axis_in_group')), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4)))),
      if (_strOf(gd, 'group_dynamics_signature').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: Text(_cap(_strOf(gd, 'group_dynamics_signature')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
      if (hiddenEnemy.isNotEmpty && hiddenEnemy['present'] == true) ...[const SizedBox(height: 10),
        Container(padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: KColors.red.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.red.withOpacity(0.3))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Icon(Icons.report_problem_rounded, size: 16, color: KColors.red), const SizedBox(width: 8),
              Text(l.riHiddenEnemyAlert, style: const TextStyle(color: KColors.red, fontSize: 12.5, fontWeight: FontWeight.w800))]),
            if (hiddenEnemy['identified_chart'] != null) Padding(padding: const EdgeInsets.only(top: 6),
              child: Text('${hiddenEnemy['identified_chart']}', style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w700))),
            if ((hiddenEnemy['explanation']?.toString() ?? '').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4),
              child: Text(hiddenEnemy['explanation'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.35))),
          ]))],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — BEST & MOST CHALLENGING PAIRS
  // ══════════════════════════════════════════════════════════════════
  Widget _bestWorstPairs(AppLocalizations l) {
    final gd = _map('group_dynamics');
    final best = gd['best_pair'] is Map ? (gd['best_pair'] as Map).cast<String, dynamic>() : <String, dynamic>{};
    final worst = gd['worst_pair'] is Map ? (gd['worst_pair'] as Map).cast<String, dynamic>() : <String, dynamic>{};
    final alliances = _list('most_likely_alliances').whereType<Map>().map((e) => e['pair_id']?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    final conflicts = _list('most_likely_conflicts').whereType<Map>().map((e) => e['pair_id']?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    if (best.isEmpty && worst.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.leaderboard_rounded, title: l.riBestWorstTitle, color: AppColors.gold),
      Row(children: [
        if (best.isNotEmpty) Expanded(child: _pairBadge(best['pair_id']?.toString() ?? '', (best['score'] is num ? best['score'] as num : null)?.toDouble() ?? 0,
          best['primary_strength']?.toString() ?? '', KColors.green, l.riBestPair)),
        if (best.isNotEmpty && worst.isNotEmpty) const SizedBox(width: 10),
        if (worst.isNotEmpty) Expanded(child: _pairBadge(worst['pair_id']?.toString() ?? '', (worst['score'] is num ? worst['score'] as num : null)?.toDouble() ?? 0,
          worst['primary_concern']?.toString() ?? '', KColors.orange, l.riWorstPair)),
      ]),
      if (alliances.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('🤝', l.riAlliances, alliances, KColors.green)],
      if (conflicts.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('⚡', l.riConflicts, conflicts, KColors.orange)],
    ]);
  }

  Widget _pairBadge(String pairId, double score, String note, Color c, String label) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.28))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: c, fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
      const SizedBox(height: 4),
      Text(pairId, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
      Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 15, fontWeight: FontWeight.w800)),
      if (note.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4),
        child: Text(note, style: const TextStyle(color: AppColors.parchment, fontSize: 9.5, height: 1.3), maxLines: 3, overflow: TextOverflow.ellipsis)),
    ]));

  // ══════════════════════════════════════════════════════════════════
  //  5 — PAIRWISE ANALYSIS
  // ══════════════════════════════════════════════════════════════════
  Widget _pairwise(AppLocalizations l) {
    final pairs = _list('pairwise_matrix').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (pairs.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.compare_arrows_rounded, title: l.riPairwiseTitle, subtitle: l.riPairwiseSubtitle(pairs.length.toString()), color: KColors.blue),
      ...pairs.map((p) => _pairCard(p, l)),
    ]);
  }

  Widget _pairCard(Map<String, dynamic> p, AppLocalizations l) {
    final n1 = p['partner1_name']?.toString() ?? '?';
    final n2 = p['partner2_name']?.toString() ?? '?';
    final unified = _scOf(p, 'unified_pair_score');
    final grade = p['unified_pair_grade']?.toString() ?? '';
    final type = p['primary_relationship_type']?.toString() ?? '';
    final relSum = p['relationship_summary'] is Map ? (p['relationship_summary'] as Map).cast<String, dynamic>() : <String, dynamic>{};
    final col = _col(unified);
    final rows = <List<Object>>[
      [l.character, _scOf(p, 'character_compat_score'), false],
      [l.love, _scOf(p, 'love_compat_score'), false],
      [l.businessWord, _scOf(p, 'business_compat_score'), false],
      [l.karmic, _scOf(p, 'karmic_intensity_score'), false],
      [l.trustWord, _scOf(p, 'trust_compatibility_score'), false],
      [l.enmityRisk, _scOf(p, 'enmity_risk_score'), true],
    ];
    return Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(18), border: Border.all(color: col.withOpacity(0.24))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('$n1 × $n2', style: const TextStyle(color: AppColors.ivory, fontSize: 14.5, fontWeight: FontWeight.w800))),
          Column(children: [
            Text(unified.toStringAsFixed(0), style: TextStyle(color: col, fontSize: 20, fontWeight: FontWeight.w800)),
            if (grade.isNotEmpty) Text(grade, style: TextStyle(color: col, fontSize: 9, fontWeight: FontWeight.w700)),
          ]),
        ]),
        const SizedBox(height: 6),
        Wrap(spacing: 6, runSpacing: 6, children: [
          if (type.isNotEmpty) _pill(_titleCase(type), KColors.purple),
          if (relSum['trust_level'] != null) _pill('${l.trustLabel}: ${relSum['trust_level']}', KColors.green),
          if (relSum['dhoka_risk'] != null) _pill('${l.dhokaRisk}: ${relSum['dhoka_risk']}', _riskColorForLabel(relSum['dhoka_risk']?.toString() ?? '')),
        ]),
        const SizedBox(height: 10),
        ...rows.map((r) {
          final v = r[1] as double;
          final isRisk = r[2] as bool;
          final c = isRisk ? _riskColor(v) : _col(v);
          return Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
            SizedBox(width: 74, child: Text(r[0] as String, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
            const SizedBox(width: 6),
            SizedBox(width: 28, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700))),
          ]));
        }),
        if (relSum['final_verdict'] != null) Padding(padding: const EdgeInsets.only(top: 4),
          child: Text(_cap(relSum['final_verdict'].toString()), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4, fontWeight: FontWeight.w600))),
        if (relSum['advice'] != null) Padding(padding: const EdgeInsets.only(top: 4),
          child: Text('🤖 ${relSum['advice']}', style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
        _advanced(l, [
          if (p['mutual_dynamic_signature'] != null) '${l.riDynamic}: ${p['mutual_dynamic_signature']}',
          if (p['karmic_link_classification'] != null) '${l.riKarmicLink}: ${_titleCase(p['karmic_link_classification'].toString())}',
          '${l.riMutualTrust}: ${_scOf(p, 'mutual_trust_score').toStringAsFixed(0)}% · ${l.riBetrayalRisk}: ${_scOf(p, 'betrayal_risk_probability').toStringAsFixed(0)}%',
          '${l.riPowerDistribution}: ${_titleCase(p['power_distribution']?.toString() ?? '')} · ${l.riPowerHealth}: ${_scOf(p, 'power_health_score').toStringAsFixed(0)}',
          if (p['type_explanation'] != null) p['type_explanation'].toString(),
        ]),
      ]),
    );
  }

  Color _riskColorForLabel(String s) {
    final v = s.toLowerCase();
    if (v.contains('high')) return KColors.red;
    if (v.contains('moderate') || v.contains('medium')) return KColors.orange;
    return KColors.green;
  }

  // ══════════════════════════════════════════════════════════════════
  //  6 — CRITICAL PATTERNS
  // ══════════════════════════════════════════════════════════════════
  Widget _criticalPatterns(AppLocalizations l) {
    final cp = _map('critical_patterns');
    final all = <String>[];
    for (final e in cp.entries) {
      if (e.value is List) {
        for (final item in e.value as List) {
          all.add('${_titleCase(e.key.replaceAll('_alerts', ''))}: $item');
        }
      }
    }
    if (all.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.report_problem_rounded, title: l.riCriticalPatternsTitle, color: KColors.red),
      ...all.take(6).map((a) => Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: KColors.red.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: KColors.red.withOpacity(0.2))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.warning_amber_rounded, size: 15, color: KColors.red), const SizedBox(width: 8),
          Expanded(child: Text(a, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
        ]))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — GROUP RECOMMENDATIONS
  // ══════════════════════════════════════════════════════════════════
  Widget _groupRecs(AppLocalizations l) {
    final gr = _map('group_recommendations');
    final practices = (gr['recommended_general_practices'] is List ? gr['recommended_general_practices'] as List : const [])
        .map((e) => e.toString()).toList();
    final comm = _strOf(gr, 'recommended_communication_style');
    final focus = _strOf(gr, 'recommended_growth_focus');
    if (practices.isEmpty && comm.isEmpty && focus.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.groups_rounded, title: l.riGroupRecsTitle, color: KColors.green),
      if (practices.isNotEmpty) _chipBlock('🤝', l.riSharedPractices, practices, KColors.green),
      if (comm.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: _iconTile('💬', l.riCommStyle, _cap(comm))),
      if (focus.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: _iconTile('🎯', l.riGrowthFocus, _cap(focus))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — INDIVIDUAL GUIDANCE
  // ══════════════════════════════════════════════════════════════════
  Widget _individualGuidance(AppLocalizations l) {
    final recs = _list('individual_recommendations').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (recs.isEmpty) return const SizedBox.shrink();
    final colors = [KColors.blue, KColors.purple, AppColors.gold, KColors.green, KColors.orange];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.person_search_rounded, title: l.riIndividualTitle, color: KColors.purple),
      ...recs.asMap().entries.map((e) {
        final r = e.value;
        final c = colors[e.key % colors.length];
        final strengths = (r['key_strengths_in_group'] is List ? r['key_strengths_in_group'] as List : const []).map((s) => s.toString()).toList();
        final growth = (r['key_growth_areas_in_group'] is List ? r['key_growth_areas_in_group'] as List : const []).map((s) => s.toString()).toList();
        final allies = (r['best_allies_in_group'] is List ? r['best_allies_in_group'] as List : const []).map((s) => s.toString()).toList();
        final careWith = (r['handle_with_care_with'] is List ? r['handle_with_care_with'] as List : const []).map((s) => s.toString())
            .where((s) => !s.toLowerCase().contains('no significant')).toList();
        return Container(
          margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r['name']?.toString() ?? '?', style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w800)),
            if (r['karmic_lesson_in_this_group'] != null) Padding(padding: const EdgeInsets.only(top: 4),
              child: Text('🕉️ ${r['karmic_lesson_in_this_group']}', style: const TextStyle(color: AppColors.lavender, fontSize: 11, height: 1.35, fontStyle: FontStyle.italic))),
            if (r['recommended_self_cultivation'] != null) Padding(padding: const EdgeInsets.only(top: 6),
              child: Text(_cap(r['recommended_self_cultivation'].toString()), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
            if (strengths.isNotEmpty) ...[const SizedBox(height: 8), _chipBlock('⭐', l.strengths, strengths, KColors.green)],
            if (growth.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🌱', l.growthAreas, growth, KColors.orange)],
            if (allies.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🤝', l.riBestAllies, allies, KColors.blue)],
            if (careWith.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('⚠️', l.riHandleWithCare, careWith, KColors.orange)],
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — CORE GROUP THEME
  // ══════════════════════════════════════════════════════════════════
  Widget _coreTheme(AppLocalizations l) {
    final theme = _map('core_group_theme');
    if (theme.isEmpty) return const SizedBox.shrink();
    final isGrowth = theme['is_growth_oriented'] == true;
    final c = isGrowth ? KColors.green : AppColors.gold;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.emoji_events_rounded, title: l.riCoreThemeTitle, color: c),
      Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [c.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: c.withOpacity(0.3))),
        child: Column(children: [
          Text(isGrowth ? '🌱' : '🔑', style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 8),
          Text(theme['primary_theme']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          if (theme['explanation'] != null) ...[const SizedBox(height: 8),
            Text(theme['explanation'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5), textAlign: TextAlign.center)],
          if (theme['collective_action_direction'] != null) ...[const SizedBox(height: 8),
            Text('✓ ${theme['collective_action_direction']}', style: TextStyle(color: c, fontSize: 11.5, fontWeight: FontWeight.w700), textAlign: TextAlign.center)],
        ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — PREDICTION RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    double layer(String k) { final v = b[k]; return v is Map ? ((v['strength'] is num ? v['strength'] as num : null)?.toDouble() ?? 0) : 0; }
    final layers = <List<Object>>[
      [l.riLayerPairwise, layer('pairwise_completeness')],
      [l.riLayerD1, layer('d1_signal')],
      [l.riLayerD9, layer('d9_signal')],
      [l.riLayerD10, layer('d10_signal')],
      [l.riLayerD30, layer('d30_signal')],
      [l.riLayerJaimini, layer('jaimini_signal')],
      [l.riLayerBehavior, layer('behavior_clarity')],
      [l.riLayerCoherence, layer('group_coherence')],
    ];
    final explain = _str('confidence_explanation');
    final disclaimer = _str('intelligence_disclaimer');
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
        _advanced(l, null, customTitle: l.crChartLayers, customChild: Column(children: layers.where((la) => (la[1] is num ? (la[1] as num).toDouble() : 0.0) > 0).map((la) {
          final v = la[1] as double;
          return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
            SizedBox(width: 130, child: Text(la[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(_col(v))))),
            const SizedBox(width: 8),
            Text('${v.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
          ]));
        }).toList())),
      ])),
      if (disclaimer.isNotEmpty) ...[const SizedBox(height: 10),
        Text(disclaimer, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, height: 1.4, fontStyle: FontStyle.italic))],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  11 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.riTopicDynamics, l.riTopicPairwise, l.riTopicAlerts, l.riTopicGrowth, l.riTopicRecs, l.riTopicTheme];
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
    final q = '$topic — based on the relationship-intelligence report for ${widget.names}.\n\n${_buildPrompt(_data)}';
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
  Color _riskColor(double s) {
    if (s >= 65) return KColors.red;
    if (s >= 45) return KColors.orange;
    if (s >= 30) return KColors.yellow;
    return KColors.green;
  }
  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .where((w) => w.isNotEmpty).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── AI prompt / launch (unchanged behaviour) ──
  String _buildPrompt(Map<String, dynamic> d) {
    final summary = d['human_summary'] ?? '';
    final confidence = d['confidence_score'] ?? '?';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic relationship-intelligence advisor. Analyze this multi-chart relationship report for ${widget.names} and provide actionable insights.

Key highlights:
- Summary: $summary
- Confidence: $confidence

Full report data (JSON):
$jsonStr

Please explain the group dynamics in simple language, highlight the strongest and weakest bonds, and suggest practical next steps.''';
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
}
