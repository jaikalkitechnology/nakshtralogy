import 'dart:convert';
import 'package:flutter/material.dart';
import '../../widgets/desktop_center.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Legal & Disputes report — premium AI legal-coach redesign.
///
/// Presentation only. Loads the `legal` specialist
/// (`runSpecialist('legal')`) unchanged and re-presents it; every score,
/// karaka, yoga, dosha, timing window, remedy and confidence value comes
/// straight from the engine.
class LegalReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const LegalReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});
  @override
  State<LegalReportScreen> createState() => _LegalState();
}

class _LegalState extends State<LegalReportScreen> {
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
      final resp = await _api.runSpecialist('legal', widget.chartId);
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
          Text(l.lgSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
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
    // Sections render directly (no staggered fade wrapper) — a tall hero pushes
    // lower sections past the viewport, and a per-section entrance animation
    // there can stick at opacity 0 and leave the lower report blank.
    const gap = SizedBox(height: 18);
    return [
      _breadcrumb(l),
      const SizedBox(height: 10),
      _snapshot(l),           // 1
      gap, _profile(l),          // 2
      gap, _karakaTable(l),      // 3
      gap, _yogasProtections(l), // 4
      gap, _verification(l),     // 5
      gap, _victoryAnalysis(l),  // 6
      gap, _disputeCategories(l),// 7
      gap, _conflictStyle(l),    // 8
      gap, _criminalFinancial(l),// 9
      gap, _contractsNegotiation(l), // 10
      gap, _careerFit(l),        // 11
      gap, _timeline(l),         // 12
      gap, _risksVulnerabilities(l), // 13
      gap, _improvementPlan(l),  // 14
      gap, _reliability(l),      // 15
      gap, _discussAi(l),        // 16
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.lgTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — LEGAL SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _sc('legal_resilience_score');
    final col = _col(overall);
    final theme = _map('core_legal_theme');
    final summary = theme['explanation']?.toString().isNotEmpty == true ? theme['explanation'].toString() : _str('plain_statement');
    final safety = (100 - _sc('legal_issue_vulnerability_score')).clamp(0, 100).toDouble();
    final gauges = <List<Object>>[
      [l.lgResilience, overall],
      [l.lgResolutionCapacity, _sc('dispute_resolution_capacity_score')],
      [l.lgVictoryPotential, _sc('victory_potential_score')],
      [l.lgLegalSafety, safety],
      [l.lgNegotiationSkill, _sc('negotiation_skill_score')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.lgSnapshotHeader.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
          child: Text(_statusLabel(overall, l), style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
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
    if (_sc('dispute_resolution_capacity_score') >= 60) out.add(l.lgChipResolver);
    if (_sc('victory_potential_score') >= 65) out.add(l.lgChipWinner);
    if (_sc('negotiation_skill_score') >= 60) out.add(l.lgChipNegotiator);
    if (_sc('documentation_discipline_score') >= 60) out.add(l.lgChipDocumented);
    if (_sc('legal_issue_vulnerability_score') <= 25) out.add(l.lgChipLowRisk);
    if (_sc('moral_authority_capacity') >= 55) out.add(l.lgChipMoralAuthority);
    if (_sc('law_student_success_indicator_score') >= 65) out.add(l.lgChipLegalAptitude);
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
  //  2 — LEGAL PROFILE & KARMA
  // ══════════════════════════════════════════════════════════════════
  Widget _profile(AppLocalizations l) {
    final karmaType = _str('legal_karma_type');
    if (karmaType.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.gavel_rounded, title: l.lgProfileTitle, color: AppColors.gold),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.14), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.gold.withOpacity(0.28))),
        child: Column(children: [
          Text(_titleCase(karmaType), style: const TextStyle(color: AppColors.gold, fontSize: 19, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Wrap(alignment: WrapAlignment.center, spacing: 6, runSpacing: 6, children: [
            if (_str('primary_legal_driver').isNotEmpty) _pill('${l.lgPrimaryDriver}: ${_str('primary_legal_driver')}', KColors.blue),
            if (_str('conflict_approach_style').isNotEmpty) _pill(_titleCase(_str('conflict_approach_style')), KColors.purple),
            if (_str('optimal_legal_strategy').isNotEmpty) _pill(_titleCase(_str('optimal_legal_strategy')), KColors.green),
            if (_str('case_duration_tendency').isNotEmpty) _pill(_titleCase(_str('case_duration_tendency')), KColors.orange),
            if (_str('current_legal_status_phase').isNotEmpty) _pill(_titleCase(_str('current_legal_status_phase')), AppColors.gold),
          ]),
        ])),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.lgDharmaAnchor, _sc('dharma_anchor'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.lgAggressionMarker, _sc('aggression_marker'))),
      ]),
      const SizedBox(height: 10),
      _statTile(l.lgDocumentationKaraka, _sc('documentation_quality_karaka')),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  3 — YOUR LEGAL PLANETS
  // ══════════════════════════════════════════════════════════════════
  Widget _karakaTable(AppLocalizations l) {
    final map = _map('karaka_legal_table');
    if (map.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.hub_rounded, title: l.lgKarakaTitle, subtitle: l.lgKarakaSubtitle, color: KColors.purple),
      _card(child: Column(children: map.entries.map((e) {
        final info = e.value is Map ? (e.value as Map).cast<String, dynamic>() : <String, dynamic>{};
        final v = (info['strength'] is num ? info['strength'] as num : null)?.toDouble() ?? 0;
        final role = info['role']?.toString() ?? '';
        final c = _col(v);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
          SizedBox(width: 62, child: Text(e.key.toString(), style: TextStyle(color: c, fontSize: 11.5, fontWeight: FontWeight.w700))),
          Expanded(child: Text(_titleCase(role), style: const TextStyle(color: AppColors.parchment, fontSize: 10.5), maxLines: 1, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 8),
          SizedBox(width: 60, child: ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
          const SizedBox(width: 8),
          SizedBox(width: 28, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w800))),
        ]));
      }).toList())),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — LEGAL YOGAS & PROTECTIONS
  // ══════════════════════════════════════════════════════════════════
  Widget _yogasProtections(AppLocalizations l) {
    final yogas = _list('active_protective_legal_yogas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final doshas = _list('active_dispute_yogas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (yogas.isEmpty && doshas.isEmpty) return const SizedBox.shrink();
    final phase = _str('current_legal_status_phase');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.auto_awesome_rounded, title: l.lgYogasTitle, color: AppColors.gold),
      if (phase.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 10),
        child: _pill('${l.lgCurrentPhase}: ${_titleCase(phase)}', KColors.blue)),
      if (yogas.isNotEmpty) ...[
        _catLabel('🛡️', l.lgProtections, KColors.green),
        ...yogas.take(6).map((m) => _yogaRow(m['name']?.toString() ?? '', (m['score'] is num ? m['score'] as num : null)?.toDouble() ?? 0, KColors.green)),
        const SizedBox(height: 6),
      ],
      if (doshas.isNotEmpty) ...[
        _catLabel('⚠️', l.lgDisputePressures, KColors.orange),
        ...doshas.take(6).map((m) => _yogaRow(m['name']?.toString() ?? '', (m['score'] is num ? m['score'] as num : null)?.toDouble() ?? 0, KColors.orange)),
      ],
    ]);
  }

  Widget _yogaRow(String name, double score, Color c) => Container(
    margin: const EdgeInsets.only(bottom: 7), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withOpacity(0.2))),
    child: Row(children: [
      Expanded(child: Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w700))),
      Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 12.5, fontWeight: FontWeight.w800)),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  5 — VERIFICATION ACROSS CHARTS (D6 / D9)
  // ══════════════════════════════════════════════════════════════════
  Widget _verification(AppLocalizations l) {
    final d6 = _map('d6_validation');
    final d9Score = _sc('d9_dharmic_alignment_score');
    if (d6.isEmpty && d9Score == 0) return const SizedBox.shrink();
    final d6Score = (d6['d6_score'] is num ? d6['d6_score'] as num : null)?.toDouble() ?? 0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_rounded, title: l.lgVerificationTitle, color: KColors.green),
      if (d6.isNotEmpty) _chartCard(l, l.lgD6Litigation, d6Score, _titleCase(d6['d6_litigation_karma_type']?.toString() ?? ''),
        ['D6 6L: ${d6['d6_6_lord_dignity']}', 'D6 Mars: ${d6['d6_mars_dignity']} · Saturn: ${d6['d6_saturn_dignity']}']),
      if (d9Score > 0) _chartCard(l, l.lgD9Dharma, d9Score, _titleCase(_str('soul_level_legal_karma')),
        ['D9 Jupiter: ${_str('d9_jupiter_dignity')}', '${l.lgMoralAuthority}: ${_sc('moral_authority_capacity').toStringAsFixed(0)}']),
    ]);
  }

  Widget _chartCard(AppLocalizations l, String title, double score, String explain, List<String> tech) {
    final col = _col(score);
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
          Text(explain, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
        _advanced(l, tech),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  6 — VICTORY ANALYSIS
  // ══════════════════════════════════════════════════════════════════
  Widget _victoryAnalysis(AppLocalizations l) {
    final plaintiff = _sc('victory_probability_if_plaintiff_pct');
    final defendant = _sc('victory_probability_if_defendant_pct');
    if (plaintiff == 0 && defendant == 0) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.balance_rounded, title: l.lgVictoryTitle, color: AppColors.gold),
      Row(children: [
        Expanded(child: _victoryCard(l.lgAsPlaintiff, plaintiff, KColors.blue)),
        const SizedBox(width: 10),
        Expanded(child: _victoryCard(l.lgAsDefendant, defendant, AppColors.gold)),
      ]),
      const SizedBox(height: 10),
      _statTile(l.lgSettlementPreference, _sc('settlement_preference_score')),
    ]);
  }

  Widget _victoryCard(String label, double pct, Color c) => Container(padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.3))),
    child: Column(children: [
      Text(label, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
      const SizedBox(height: 8),
      Text('${pct.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 28, fontWeight: FontWeight.w800)),
    ]));

  // ══════════════════════════════════════════════════════════════════
  //  7 — DISPUTE CATEGORIES WATCH
  // ══════════════════════════════════════════════════════════════════
  Widget _disputeCategories(AppLocalizations l) {
    final cats = _map('dispute_category_susceptibility_scores');
    if (cats.isEmpty) return const SizedBox.shrink();
    final sorted = cats.entries.where((e) => e.value is num).toList()
      ..sort((a, b) => (b.value is num ? b.value as num : 0).compareTo(a.value as num));
    final lowRisk = _list('low_risk_legal_categories').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.category_rounded, title: l.lgDisputeCategoriesTitle, color: KColors.orange),
      _card(child: Column(children: sorted.take(12).map((e) {
        final v = (e.value is num ? e.value as num : 0).toDouble();
        final c = _riskColor(v);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
          SizedBox(width: 96, child: Text(_titleCase(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 11))),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
          const SizedBox(width: 8),
          SizedBox(width: 32, child: Text('${v.toStringAsFixed(0)}%', textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700))),
        ]));
      }).toList())),
      if (lowRisk.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('✓', l.lgLowRiskCategories, lowRisk, KColors.green)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — CONFLICT STYLE & ENEMIES
  // ══════════════════════════════════════════════════════════════════
  Widget _conflictStyle(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.psychology_rounded, title: l.lgConflictStyleTitle, color: KColors.purple),
      Row(children: [
        Expanded(child: _statTile(l.lgConfrontationComfort, _sc('confrontation_comfort_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.lgArgumentPersuasiveness, _sc('argument_persuasiveness_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.lgEmotionalRegulation, _sc('emotional_regulation_in_conflict_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.lgGrudgeHolding, _sc('long_term_grudge_holding_tendency_score'))),
      ]),
      const SizedBox(height: 12),
      Text(l.lgEnemyAnalysisLabel, style: const TextStyle(color: AppColors.smoke, fontSize: 11, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: _riskTile(l.lgVisibleEnemies, _sc('visible_enemies_tendency_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.lgHiddenEnemies, _sc('hidden_enemies_tendency_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _riskTile(l.lgWorkplaceEnemies, _sc('workplace_enemies_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.lgFamilyEnemies, _sc('family_enemies_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.lgLegalEnemies, _sc('legal_enemies_score'))),
      ]),
      const SizedBox(height: 10),
      _statTile(l.lgEnemyDefeatCapacity, _sc('enemy_defeat_capacity_score')),
      if (_str('typical_enemy_profile').isNotEmpty) ...[const SizedBox(height: 10),
        _card(child: Text(_cap(_str('typical_enemy_profile')), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.4)))],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — CRIMINAL & FINANCIAL RISK WATCH
  // ══════════════════════════════════════════════════════════════════
  Widget _criminalFinancial(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.shield_outlined, title: l.lgCriminalFinancialTitle, color: KColors.orange),
      Wrap(spacing: 10, runSpacing: 10, children: [
        _riskChip(l.lgCriminalRisk, _sc('criminal_matter_involvement_risk_score')),
        _riskChip(l.lgVictimOfCrime, _sc('victim_of_crime_probability_pct')),
        _riskChip(l.lgFalseAccusation, _sc('false_accusation_vulnerability_score')),
        _riskChip(l.lgImprisonmentRisk, _sc('imprisonment_risk_pct')),
        _riskChip(l.lgTaxDisputeRisk, _sc('tax_authority_dispute_risk_score')),
        _riskChip(l.lgFinancialFraudRisk, _sc('financial_fraud_vulnerability_score')),
        _riskChip(l.lgBusinessLitigationRisk, _sc('business_litigation_risk_score')),
        _riskChip(l.lgBankruptcyRisk, _sc('bankruptcy_legal_risk_score')),
        _riskChip(l.lgAuditVulnerability, _sc('audit_vulnerability_score')),
      ]),
      if (_str('legal_protection_priority_level').isNotEmpty) ...[const SizedBox(height: 10),
        _pill('${l.lgProtectionPriority}: ${_titleCase(_str('legal_protection_priority_level'))}', KColors.blue)],
    ]);
  }

  Widget _riskChip(String label, double score) {
    final c = _riskColor(score);
    return Container(width: 150, padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Row(children: [
          Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 15, fontWeight: FontWeight.w800)),
          const Spacer(),
          Icon(Icons.warning_amber_rounded, size: 14, color: c),
        ]),
      ]));
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — CONTRACTS & NEGOTIATION
  // ══════════════════════════════════════════════════════════════════
  Widget _contractsNegotiation(AppLocalizations l) {
    final issues = _list('typical_contract_issues').map((e) => e.toString())
        .where((s) => !s.toLowerCase().contains('no major')).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.description_rounded, title: l.lgContractsTitle, color: KColors.blue),
      Row(children: [
        Expanded(child: _statTile(l.lgContractClarity, _sc('contract_clarity_karma_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.lgDocumentationDiscipline, _sc('documentation_discipline_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.lgFinePrintAwareness, _sc('fine_print_awareness_score'))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('✍️', l.lgSignatureCaution, _titleCase(_str('signature_caution_level')))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.lgMediationReceptivity, _sc('mediation_receptivity_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.lgNegotiationSkillFull, _sc('negotiation_skill_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.lgCompromiseWillingness, _sc('compromise_willingness_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.lgFaceSavingNeeds, _sc('face_saving_needs_score'))),
      ]),
      if (_sc('mediator_hire_recommendation_score') > 0) ...[const SizedBox(height: 10),
        _pill('${l.lgMediatorHireRecommendation}: ${_sc('mediator_hire_recommendation_score').toStringAsFixed(0)}%', KColors.purple)],
      if (issues.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('📄', l.lgTypicalContractIssues, issues, KColors.orange)],
    ]);
  }

  Widget _iconTile(String emoji, String label, String value, {Color? color}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 17)), const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w600)),
      Text(value, style: TextStyle(color: color ?? AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  11 — LEGAL CAREER FIT
  // ══════════════════════════════════════════════════════════════════
  Widget _careerFit(AppLocalizations l) {
    final affinity = _sc('legal_profession_affinity_score');
    if (affinity == 0 && _str('specific_legal_role_fit').isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.school_rounded, title: l.lgCareerFitTitle, color: KColors.green),
      Row(children: [
        Expanded(child: _statTile(l.lgProfessionAffinity, affinity)),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('⚖️', l.lgRoleFit, _titleCase(_str('specific_legal_role_fit')))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.lgLawStudentSuccess, _sc('law_student_success_indicator_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.lgBarExamSuccess, _sc('bar_exam_success_tendency'))),
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  12 — LEGAL TIMELINE
  // ══════════════════════════════════════════════════════════════════
  Widget _timeline(AppLocalizations l) {
    final trend = _list('yearly_legal_stress_trend').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final peakYears = _list('peak_dispute_years').map((e) => e.toString()).toList();
    final clearYears = _list('legal_clarity_years').map((e) => e.toString()).toList();
    final avoidPeriods = _list('critical_avoidance_periods').map((e) => e.toString()).toList();
    final favorableWindows = _list('favorable_resolution_windows').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.timeline_rounded, title: l.lgTimelineTitle, color: AppColors.gold),
      Row(children: [
        Expanded(child: _statTile(l.lgNewMatterChance, _sc('new_legal_matter_probability_next_12_months_pct'))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('📋', l.lgOngoingCaseOutcome, _titleCase(_str('ongoing_case_outcome_tendency')))),
      ]),
      if (_str('recommended_legal_action_next_12_months').isNotEmpty) ...[const SizedBox(height: 10),
        _pill('🎯 ${l.lgRecommendedAction}: ${_titleCase(_str('recommended_legal_action_next_12_months'))}', AppColors.gold)],
      if (peakYears.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('⚠️', l.lgPeakDisputeYears, peakYears, KColors.orange)],
      if (clearYears.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('✓', l.lgClarityYears, clearYears, KColors.green)],
      if (avoidPeriods.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🚫', l.lgAvoidancePeriods, avoidPeriods, KColors.red)],
      if (favorableWindows.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🌟', l.lgFavorableWindows, favorableWindows, KColors.blue)],
      if (_str('legal_transit_summary').isNotEmpty) ...[const SizedBox(height: 10),
        _card(child: Text(_cap(_str('legal_transit_summary')), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.4)))],
      if (trend.isNotEmpty) ...[const SizedBox(height: 10), _trendChart(trend)],
    ]);
  }

  Widget _trendChart(List<Map<String, dynamic>> trend) {
    return _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: trend.take(10).map((y) {
      final year = y['year']?.toString() ?? '';
      final stress = (y['stress'] is num ? y['stress'] as num : null)?.toDouble() ?? 0;
      final peak = y['is_peak'] == true;
      final clear = y['is_clear'] == true;
      final c = peak ? KColors.red : clear ? KColors.green : _riskColor(stress);
      return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
        SizedBox(width: 40, child: Text(year, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w700))),
        Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (stress / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
        const SizedBox(width: 8),
        SizedBox(width: 30, child: Text(stress.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700))),
      ]));
    }).toList()));
  }

  // ══════════════════════════════════════════════════════════════════
  //  13 — RISKS & VULNERABILITIES
  // ══════════════════════════════════════════════════════════════════
  Widget _risksVulnerabilities(AppLocalizations l) {
    final risks = _list('major_legal_risks').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final chronic = _list('chronic_vulnerability_areas').map((e) => e.toString()).toList();
    final avoidDasha = _list('critical_dasha_avoidance_periods').map((e) => e.toString()).toList();
    final preventive = _list('preventive_legal_priorities').map((e) => e.toString()).toList();
    final redFlags = _list('red_flag_situations_to_avoid').map((e) => e.toString()).toList();
    if (risks.isEmpty && chronic.isEmpty && preventive.isEmpty && redFlags.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.report_problem_outlined, title: l.lgRisksTitle, color: KColors.orange),
      ...risks.map((r) {
        final desc = r['description']?.toString() ?? '';
        final mitigation = r['mitigation']?.toString() ?? '';
        if (desc.isEmpty) return const SizedBox.shrink();
        return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: KColors.orange.withOpacity(0.05), borderRadius: BorderRadius.circular(13), border: Border.all(color: KColors.orange.withOpacity(0.18))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_cap(desc), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4)),
            if (mitigation.isNotEmpty) ...[const SizedBox(height: 5),
              Text('🛡️ $mitigation', style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.35))],
          ]));
      }),
      if (chronic.isNotEmpty) _chipBlock('🔁', l.lgChronicVulnerabilities, chronic, KColors.orange),
      if (avoidDasha.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('📅', l.lgAvoidDashaPeriods, avoidDasha, KColors.red)],
      if (preventive.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('📋', l.lgPreventivePriorities, preventive, KColors.blue)],
      if (redFlags.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🚩', l.lgRedFlags, redFlags, KColors.red)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  14 — IMPROVEMENT PLAN (remedies)
  // ══════════════════════════════════════════════════════════════════
  Widget _improvementPlan(AppLocalizations l) {
    final practical = _list('practical_solutions').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final planetary = _list('astrological_remedies').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.self_improvement_rounded, title: l.lgImprovementTitle, color: KColors.green),
      if (practical.isNotEmpty) ...[
        _catLabel('🎯', l.crCatPractical, KColors.blue),
        ...practical.map((m) => _remedyCard(_titleCase(m['category']?.toString() ?? ''), m['advice']?.toString() ?? '', KColors.blue)),
      ],
      if (planetary.isNotEmpty) ...[
        const SizedBox(height: 6),
        _catLabel('🕉️', l.crCatPlanetary, KColors.purple),
        ...planetary.map((m) => _remedyCard(m['deity']?.toString() ?? '', m['remedy']?.toString() ?? '', KColors.purple)),
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
  //  15 — RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    double layer(String k) { final v = b[k]; return v is num ? v.toDouble() * 100 : 0; }
    final layers = <List<Object>>[
      [l.lgLayerD1, layer('d1')],
      [l.lgLayerD6, layer('d6')],
      [l.lgLayerD9, layer('d9')],
      [l.lgLayerDasha, layer('dasha')],
      [l.lgLayerTransit, layer('transit')],
    ];
    final plain = _str('plain_statement');
    final disclaimer = _str('legal_disclaimer').isNotEmpty ? _str('legal_disclaimer') : _str('disclaimer');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.lgReliabilityTitle, color: KColors.blue),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          KStars(filled: kStars(pct), size: 20, color: AppColors.gold), const Spacer(),
          Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 4),
        Text(band, style: const TextStyle(color: KColors.green, fontSize: 13, fontWeight: FontWeight.w800)),
        if (plain.isNotEmpty) ...[const SizedBox(height: 10),
          Text(_cap(plain), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5))],
        _advanced(l, null, customTitle: l.crChartLayers, customChild: Column(children: layers.where((la) => (la[1] is num ? (la[1] as num).toDouble() : 0.0) > 0).map((la) {
          final v = la[1] as double;
          return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
            SizedBox(width: 140, child: Text(la[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5))),
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
  //  16 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.lgTopicWinChance, l.lgTopicStrategy, l.lgTopicContract, l.lgTopicTiming, l.lgTopicSettlement, l.lgTopicEnemies, l.lgTopicProtection, l.lgTopicCareer];
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
    final q = '$topic — based on my Vedic legal report for ${widget.chartName}.\n\n${_buildPrompt(_data!)}';
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

  Widget _riskTile(String label, double score) {
    final c = _riskColor(score);
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
  Color _riskColor(double s) {
    if (s >= 40) return KColors.red;
    if (s >= 25) return KColors.orange;
    if (s >= 15) return KColors.yellow;
    return KColors.green;
  }
  String _statusLabel(double s, AppLocalizations l) {
    if (s >= 75) return l.lgStatusExcellent;
    if (s >= 60) return l.lgStatusStrong;
    if (s >= 45) return l.lgStatusModerate;
    if (s >= 30) return l.lgStatusDeveloping;
    return l.lgStatusChallenging;
  }
  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .where((w) => w.isNotEmpty).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── AI prompt / launch (unchanged behaviour) ──
  String _buildPrompt(Map<String, dynamic> d) {
    final name = widget.chartName;
    final resilience = d['legal_resilience_score'] ?? '?';
    final verdict = d['overall_legal_karma_verdict'] ?? '';
    final karmaType = d['legal_karma_type'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic legal-astrology advisor. Analyze this legal & disputes report for $name and provide actionable insights.

Key highlights:
- Legal resilience: $resilience/100
- Legal karma type: $karmaType
- Overall legal karma verdict: $verdict

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the best dispute-avoidance strategy and favorable resolution windows, and suggest practical next steps. Note this is astrological guidance, NOT legal advice.''';
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

  Widget _errView(AppLocalizations l) => Center(child: Padding(padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, color: AppColors.error, size: 44), const SizedBox(height: 12),
      Text(_error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center),
      const SizedBox(height: 16), ElevatedButton(onPressed: _load, child: Text(l.retry)),
    ])));
}
