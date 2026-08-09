import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/kundli_names.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Past Life & Karma report — premium AI karma-coach redesign.
///
/// Presentation only. Loads the `past_life` specialist
/// (`runSpecialist('past_life')`) unchanged and re-presents it; every score,
/// karaka, yoga, timing window, remedy and confidence value comes straight
/// from the engine.
class PastLifeReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const PastLifeReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});
  @override
  State<PastLifeReportScreen> createState() => _PastLifeReportState();
}

class _PastLifeReportState extends State<PastLifeReportScreen> {
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
      final resp = await _api.runSpecialist('past_life', widget.chartId);
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
          Text(l.pkSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
        ]),
        actions: [IconButton(icon: const Icon(Icons.refresh, color: AppColors.ivory, size: 18), onPressed: _load)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null ? _errView(l)
          : _data == null ? const SizedBox.shrink()
          : ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 40), children: _sections(l)),
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
      _snapshot(l),          // 1
      gap, _ketuAxis(l),        // 2
      gap, _rahuAxis(l),        // 3
      gap, _profile(l),         // 4
      gap, _relationships(l),   // 5
      gap, _spiritualThen(l),   // 6
      gap, _karmicDebtsWealth(l), // 7
      gap, _echoes(l),          // 8
      gap, _resolution(l),      // 9
      gap, _verification(l),    // 10
      gap, _memory(l),          // 11
      gap, _timeline(l),        // 12
      gap, _risks(l),           // 13
      gap, _improvementPlan(l), // 14
      gap, _roadmap(l),         // 15
      gap, _reliability(l),     // 16
      gap, _discussAi(l),       // 17
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.pkTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — PAST-LIFE SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _sc('past_life_signature_strength_score');
    final col = _col(overall);
    final verdict = _str('overall_past_life_verdict');
    final theme = _titleCase(_str('primary_past_life_theme'));
    final relation = _titleCase(_str('current_life_relationship_to_past_life'));
    final summary = theme.isNotEmpty
        ? l.pkHeroSummary(theme, relation, _titleCase(_str('recommended_past_life_integration_strategy')))
        : _str('plain_statement');
    final gauges = <List<Object>>[
      [l.pkGaugeSignature, overall],
      [l.pkGaugeMasteryPreserved, _sc('past_life_mastery_preservation_score')],
      [l.pkGaugeClearingProgress, _sc('karma_clearing_progress_score')],
      [l.pkGaugeMaturity, _sc('past_life_maturity_score')],
      [l.pkGaugeMemoryAccess, _sc('past_life_memory_access_score')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.pkSnapshotHeader.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
        if (verdict.isNotEmpty) Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
          child: Text(_titleCase(verdict), style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
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
    if (_sc('karma_clearing_progress_score') >= 50) out.add(l.pkChipGoodProgress);
    if (_sc('total_karmic_debt_score') < 30) out.add(l.pkChipLowDebt);
    if (_sc('past_life_maturity_score') >= 50) out.add(l.pkChipMatureSoul);
    if (_map('core_past_life_theme')['is_gift'] == true) out.add(l.pkChipGiftedPast);
    if (_sc('past_life_accomplishment_level_score') >= 60) out.add(l.pkChipAccomplished);
    if (_sc('past_life_mastery_preservation_score') >= 50) out.add(l.pkChipMasteryPreserved);
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
  //  2 — KETU: YOUR PAST MASTERY
  // ══════════════════════════════════════════════════════════════════
  Widget _ketuAxis(AppLocalizations l) {
    final mastery = _str('past_life_mastery_domain');
    if (mastery.isEmpty) return const SizedBox.shrink();
    final skills = _list('skills_carried_forward').map((e) => e.toString()).toList();
    final instincts = _list('instinctual_capacities').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.history_edu_rounded, title: l.pkKetuTitle, subtitle: l.pkKetuSubtitle, color: KColors.purple),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.purple.withOpacity(0.14), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.purple.withOpacity(0.28))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_cap(mastery), style: const TextStyle(color: AppColors.ivory, fontSize: 13, height: 1.45, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _statTile(l.pkMasteryStrength, _sc('past_life_mastery_strength_score'))),
            const SizedBox(width: 10),
            Expanded(child: _iconTile('🏠', l.crHouseLabel, '${_sc('ketu_house').toStringAsFixed(0)}H')),
          ]),
        ])),
      if (skills.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('🛡️', l.pkSkillsCarried, skills, KColors.purple)],
      if (instincts.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('⚡', l.pkInstincts, instincts, KColors.blue)],
      _advanced(l, ['${l.pkKetuDignity}: ${_str('ketu_dignity')} · Nakshatra deity: ${_str('ketu_nakshatra_deity')}']),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  3 — RAHU: YOUR SOUL'S GROWTH EDGE
  // ══════════════════════════════════════════════════════════════════
  Widget _rahuAxis(AppLocalizations l) {
    final unfinished = _str('past_life_unfinished_domain');
    if (unfinished.isEmpty) return const SizedBox.shrink();
    final desires = _list('past_life_unmet_desires').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.trending_up_rounded, title: l.pkRahuTitle, subtitle: l.pkRahuSubtitle, color: KColors.orange),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.orange.withOpacity(0.14), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.orange.withOpacity(0.28))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_cap(unfinished), style: const TextStyle(color: AppColors.ivory, fontSize: 13, height: 1.45, fontWeight: FontWeight.w600)),
          if (_str('current_life_pull_toward').isNotEmpty) ...[const SizedBox(height: 8),
            Text('🧭 ${_cap(_str('current_life_pull_toward'))}', style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
        ])),
      if (desires.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('💭', l.pkUnmetDesires, desires, KColors.orange)],
      if (_str('rahu_shadow_pattern').isNotEmpty) ...[const SizedBox(height: 10),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: KColors.red.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: KColors.red.withOpacity(0.2))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.warning_amber_rounded, size: 15, color: KColors.red), const SizedBox(width: 8),
            Expanded(child: Text(_cap(_str('rahu_shadow_pattern')), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4)))
          ]))],
      _advanced(l, ['${l.crHouseLabel}: ${_sc('rahu_house').toStringAsFixed(0)}H · Nakshatra deity: ${_str('rahu_nakshatra_deity')}']),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — YOUR PAST LIFE PROFILE
  // ══════════════════════════════════════════════════════════════════
  Widget _profile(AppLocalizations l) {
    if (_str('primary_past_life_profession').isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.badge_rounded, title: l.pkProfileTitle, color: AppColors.gold),
      Row(children: [
        Expanded(child: _iconTile('👤', l.pkProfession, _titleCase(_str('primary_past_life_profession')))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🏛️', l.pkSocialStanding, _titleCase(_str('past_life_social_standing')))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _iconTile('🌍', l.pkRegion, _titleCase(_str('likely_past_life_region_signature')))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🎭', l.pkCulturalArchetype, _titleCase(_str('cultural_archetype')))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.pkAccomplishment, _sc('past_life_accomplishment_level_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.pkAuthority, _sc('past_life_authority_score'))),
      ]),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_str('past_life_gender_tendency').isNotEmpty) _pill(_titleCase(_str('past_life_gender_tendency')), KColors.blue),
        if (_str('past_life_family_role').isNotEmpty) _pill('${l.pkFamilyRole}: ${_titleCase(_str('past_life_family_role'))}', KColors.purple),
        if (_str('marital_status_past_life_signature').isNotEmpty) _pill(_titleCase(_str('marital_status_past_life_signature')), KColors.gold),
      ]),
      _advanced(l, [
        if (_str('secondary_past_life_profession').isNotEmpty) '${l.pkSecondaryProfession}: ${_titleCase(_str('secondary_past_life_profession'))}',
        '${l.pkClimateAffinity}: ${_titleCase(_str('climate_affinity'))} · ${l.pkForeignResidence}: ${_sc('foreign_residence_karma_score').toStringAsFixed(0)}',
        if (_str('past_life_lineage_responsibilities').isNotEmpty) _str('past_life_lineage_responsibilities'),
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  5 — PAST RELATIONSHIPS CARRIED FORWARD
  // ══════════════════════════════════════════════════════════════════
  Widget _relationships(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final types = _list('carried_forward_relationship_types').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.favorite_rounded, title: l.pkRelationshipsTitle, color: KColors.blue),
      Row(children: [
        Expanded(child: _statTile(l.pkSpouseConnection, _sc('spouse_past_life_connection_probability'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.pkChildrenConnection, _sc('children_past_life_connection_probability'))),
      ]),
      const SizedBox(height: 10),
      if (types.isNotEmpty) _chipBlock('🔗', l.pkCarriedRelationTypes, types, KColors.blue),
      if (_str('past_life_partner_archetype').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
        child: _iconTile('💞', l.pkPartnerArchetype, _cap(_str('past_life_partner_archetype')))),
      _advanced(l, [
        if (_str('darakaraka_planet').isNotEmpty) '${l.pkDarakaraka}: ${KundliNames.planet(_str('darakaraka_planet'), loc)}',
        if (_str('parents_past_life_karma_pattern').isNotEmpty) '${l.pkParentsKarma}: ${_str('parents_past_life_karma_pattern')}',
        if (_str('sibling_past_life_karma_pattern').isNotEmpty) '${l.pkSiblingKarma}: ${_str('sibling_past_life_karma_pattern')}',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  6 — SPIRITUAL LIFE THEN
  // ══════════════════════════════════════════════════════════════════
  Widget _spiritualThen(AppLocalizations l) {
    if (_str('past_life_spiritual_level').isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.spa_rounded, title: l.pkSpiritualTitle, color: KColors.purple),
      Row(children: [
        Expanded(child: _iconTile('🧘', l.pkSpiritualLevel, _titleCase(_str('past_life_spiritual_level')))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('📿', l.pkPracticeSignature, _titleCase(_str('specific_past_life_practice_signature')))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.pkMeditativeCapacity, _sc('past_life_meditative_capacity_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.pkDevotionalPractice, _sc('past_life_devotional_practice_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.pkYogicAttainment, _sc('past_life_yogic_attainment_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.pkMokshaProximity, _sc('past_life_moksha_proximity_score'))),
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — KARMIC DEBTS & WEALTH THEN
  // ══════════════════════════════════════════════════════════════════
  Widget _karmicDebtsWealth(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.account_balance_rounded, title: l.pkKarmicDebtsTitle, color: KColors.orange),
      Row(children: [
        Expanded(child: _riskTile(l.pkTotalKarmicDebt, _sc('total_karmic_debt_score'))),
        const SizedBox(width: 10),
        if (_str('primary_karmic_debt_type').isNotEmpty) Expanded(child: _iconTile('📌', l.pkPrimaryDebtType, _titleCase(_str('primary_karmic_debt_type')))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _riskTile(l.pkRelationshipDebt, _sc('relationship_karmic_debt_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.pkFinancialDebt, _sc('financial_karmic_debt_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _riskTile(l.pkServiceDebt, _sc('service_karmic_debt_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.pkDharmicDebt, _sc('dharmic_karmic_debt_score'))),
      ]),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_str('pitru_karma_status').isNotEmpty) _pill('${l.pkPitruKarma}: ${_titleCase(_str('pitru_karma_status'))}', KColors.blue),
        if (_str('matru_karma_status').isNotEmpty) _pill('${l.pkMatruKarma}: ${_titleCase(_str('matru_karma_status'))}', KColors.purple),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _iconTile('💰', l.pkWealthLevel, _titleCase(_str('past_life_wealth_level')))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.pkWealthKarmaCarried, _sc('wealth_karma_carried_forward_score'))),
      ]),
      if (_str('financial_karmic_pattern_in_this_life').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: Text(_cap(_str('financial_karmic_pattern_in_this_life')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
      _advanced(l, [
        if (_str('past_life_resource_management_pattern').isNotEmpty) '${l.pkResourcePattern}: ${_titleCase(_str('past_life_resource_management_pattern'))}',
        if (_str('past_life_gain_source').isNotEmpty) '${l.pkGainSource}: ${_titleCase(_str('past_life_gain_source'))}',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — ECHOES IN THIS LIFE
  // ══════════════════════════════════════════════════════════════════
  Widget _echoes(AppLocalizations l) {
    final attractions = _list('natural_attractions_list').map((e) => e.toString()).toList();
    final aversions = _list('natural_aversions_list').map((e) => e.toString()).toList();
    final fears = _list('unexplained_fears_list').map((e) => e.toString()).toList();
    final pulls = _list('magnetic_pulls_list').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.radar_rounded, title: l.pkEchoesTitle, color: KColors.blue),
      Row(children: [
        Expanded(child: _statTile(l.pkOnRelationships, _sc('past_life_influence_on_relationships_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.pkOnCareer, _sc('past_life_influence_on_career_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.pkOnHealth, _sc('past_life_influence_on_health_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.pkOnSpirituality, _sc('past_life_influence_on_spirituality_score'))),
      ]),
      if (_str('dominant_past_life_carryforward_area').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: _pill('${l.pkDominantArea}: ${_titleCase(_str('dominant_past_life_carryforward_area'))}', KColors.gold)),
      if (attractions.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('🧲', l.pkAttractions, attractions, KColors.green)],
      if (pulls.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('✨', l.pkMagneticPulls, pulls, KColors.purple)],
      if (fears.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('😰', l.pkUnexplainedFears, fears, KColors.red)],
      if (aversions.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🚫', l.pkAversions, aversions, KColors.orange)],
      if (_str('deja_vu_signature').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
        child: Text(_cap(_str('deja_vu_signature')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — KARMIC RESOLUTION & COMPLETION
  // ══════════════════════════════════════════════════════════════════
  Widget _resolution(AppLocalizations l) {
    final priorities = _list('karma_clearing_priority_areas').map((e) => e.toString())
        .where((s) => !s.toLowerCase().contains('balanced karma-cultivation')).toList();
    final practices = _list('resolution_acceleration_practices').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.task_alt_rounded, title: l.pkResolutionTitle, color: KColors.green),
      Row(children: [
        Expanded(child: _iconTile('🛤️', l.pkPrimaryPathway, _titleCase(_str('primary_resolution_pathway')))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🛤️', l.pkSecondaryPathway, _titleCase(_str('secondary_resolution_pathway')))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.pkClearingProgress, _sc('karma_clearing_progress_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.pkRemainingWork, _sc('remaining_karmic_work_intensity_score'))),
      ]),
      if (_str('karmic_debt_settlement_timeline').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: _pill('${l.pkSettlementTimeline}: ${_titleCase(_str('karmic_debt_settlement_timeline'))}', KColors.blue)),
      if (_str('past_life_transition_impact_on_this_life').isNotEmpty) ...[const SizedBox(height: 10),
        Text(_cap(_str('this_life_echo_of_past_transition').isNotEmpty ? _str('this_life_echo_of_past_transition') : _str('past_life_transition_impact_on_this_life')),
          style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
      if (practices.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('🎯', l.pkAccelerationPractices, practices, KColors.green)],
      if (priorities.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('📍', l.pkPriorityAreas, priorities, KColors.purple)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — VERIFIED ACROSS CHARTS (D60)
  // ══════════════════════════════════════════════════════════════════
  Widget _verification(AppLocalizations l) {
    final d60 = _map('d60_validation');
    if (d60.isEmpty) return const SizedBox.shrink();
    final standing = (d60['d60_overall_past_life_standing']?.toString() ?? '').toLowerCase();
    final score = standing.contains('exceptional') || standing.contains('strong') ? 75.0 : standing.contains('ordinary') ? 50.0 : 35.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_rounded, title: l.pkVerificationTitle, color: KColors.green),
      _chartCard(l, l.pkD60Label, score, d60['d60_past_life_era_signature']?.toString() ?? '', [
        'Sun: ${d60['d60_sun_dignity']} · Moon: ${d60['d60_moon_dignity']} · Jupiter: ${d60['d60_jupiter_dignity']}',
        '${l.pkD60Ketu}: ${d60['d60_ketu_placement']}',
        '${l.pkD60Standing}: ${_titleCase(d60['d60_overall_past_life_standing']?.toString() ?? '')}',
      ]),
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
          Text(_cap(explain), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
        _advanced(l, tech),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  11 — MEMORY & INTUITION
  // ══════════════════════════════════════════════════════════════════
  Widget _memory(AppLocalizations l) {
    final practices = _list('recommended_remembrance_practices').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.psychology_alt_rounded, title: l.pkMemoryTitle, color: KColors.purple),
      Row(children: [
        Expanded(child: _statTile(l.pkMemoryAccess, _sc('past_life_memory_access_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.pkRegressionFit, _sc('regression_receptivity_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.pkDreamVisits, _sc('dream_past_life_visitation_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.pkDejaVuFrequency, _sc('deja_vu_frequency_score'))),
      ]),
      if (_str('spontaneous_remembrance_tendency').isNotEmpty && _str('spontaneous_remembrance_tendency').toLowerCase() != 'none') Padding(
        padding: const EdgeInsets.only(top: 10), child: _pill('${l.pkSpontaneousRemembrance}: ${_titleCase(_str('spontaneous_remembrance_tendency'))}', KColors.blue)),
      if (practices.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('🌙', l.pkRemembrancePractices, practices, KColors.purple)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  12 — ACTIVATION TIMELINE
  // ══════════════════════════════════════════════════════════════════
  Widget _timeline(AppLocalizations l) {
    final gifts = _list('past_life_gifts_activation_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final surface = _list('active_past_life_surface_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (gifts.isEmpty && surface.isEmpty && _str('past_life_activation_current_dasha').isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.timeline_rounded, title: l.pkTimelineTitle, color: AppColors.gold),
      if (gifts.isNotEmpty) ...gifts.map((m) => _timelineCard(l, l.pkGiftsActivation, m, KColors.gold)),
      if (surface.isNotEmpty) ...surface.map((m) => _timelineCard(l, l.pkSurfaceWindow, m, KColors.purple)),
      if (_str('past_life_activation_current_dasha').isNotEmpty && !_str('past_life_activation_current_dasha').toLowerCase().contains('unavailable'))
        Text(_str('past_life_activation_current_dasha'), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4)),
    ]);
  }

  Widget _timelineCard(AppLocalizations l, String title, Map<String, dynamic> m, Color col) {
    final window = m['window']?.toString() ?? '';
    final dasha = m['dasha']?.toString() ?? '';
    final note = m['note']?.toString() ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 13, 13, 13),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.28))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: col, shape: BoxShape.circle, border: Border.all(color: col.withOpacity(0.35), width: 3))),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(color: col, fontSize: 12.5, fontWeight: FontWeight.w800))),
          if (window.isNotEmpty) Text(window, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w600)),
        ]),
        if (dasha.isNotEmpty) ...[const SizedBox(height: 4),
          Text('🪐 ${l.crViewDasha}: $dasha', style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700))],
        if (note.isNotEmpty) ...[const SizedBox(height: 6),
          Text(_cap(note), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))],
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  13 — RISKS & CHRONIC PATTERNS
  // ══════════════════════════════════════════════════════════════════
  Widget _risks(AppLocalizations l) {
    final chronic = _list('chronic_past_life_imprints').map((e) => e.toString())
        .where((s) => !s.toLowerCase().contains('no structural')).toList();
    final loops = _list('karmic_loop_indicators').map((e) => e.toString())
        .where((s) => !s.toLowerCase().contains('no dominant')).toList();
    final majorRisks = _list('major_past_life_carryover_risks').whereType<Map>().map((e) => e['description']?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    if (chronic.isEmpty && loops.isEmpty && majorRisks.isEmpty && _sc('past_life_trauma_residue_score') == 0) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.shield_outlined, title: l.pkRisksTitle, color: KColors.orange),
      Row(children: [
        Expanded(child: _riskTile(l.pkTraumaResidue, _sc('past_life_trauma_residue_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.pkSpiritualBypass, _sc('spiritual_bypass_risk_score'))),
      ]),
      if (majorRisks.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('⚠️', l.pkMajorRisks, majorRisks, KColors.red)],
      if (chronic.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🔁', l.pkChronicImprints, chronic, KColors.orange)],
      if (loops.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🌀', l.pkKarmicLoops, loops, KColors.red)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  14 — IMPROVEMENT PLAN (remedies)
  // ══════════════════════════════════════════════════════════════════
  Widget _improvementPlan(AppLocalizations l) {
    final practical = _list('practical_solutions').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final planetary = _list('astrological_remedies').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.healing_rounded, title: l.pkImprovementTitle, color: KColors.green),
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

  // ══════════════════════════════════════════════════════════════════
  //  15 — YOUR PAST-LIFE ROADMAP
  // ══════════════════════════════════════════════════════════════════
  Widget _roadmap(AppLocalizations l) {
    final theme = _map('core_past_life_theme');
    final verdict = _titleCase(_str('overall_past_life_verdict'));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.rocket_launch_rounded, title: l.pkRoadmapTitle, color: KColors.gold),
      if (verdict.isNotEmpty) Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.gold.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.gold.withOpacity(0.3))),
        child: Column(children: [
          Text(theme['is_gift'] == true ? '🎁' : '🔮', style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 8),
          Text(verdict, style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          if (_str('recommended_past_life_integration_strategy').isNotEmpty) ...[const SizedBox(height: 8),
            Text(_cap(_str('recommended_past_life_integration_strategy')), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5), textAlign: TextAlign.center)],
        ])),
      if (theme.isNotEmpty && theme['explanation'] != null) ...[const SizedBox(height: 10),
        _card(child: Text(theme['explanation'].toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45)))],
      const SizedBox(height: 10),
      _statTile(l.pkMaturity, _sc('past_life_maturity_score')),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  16 — PREDICTION RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    double layer(String k) { final v = b[k]; return v is num ? v.toDouble() * 100 : 0; }
    final layers = <List<Object>>[
      [l.pkLayerD1, layer('d1')],
      [l.pkLayerD9, layer('d9')],
      [l.pkLayerD60, layer('d60')],
      [l.pkLayerKetuDepth, layer('ketu_depth')],
      [l.pkLayerAtmakaraka, layer('atmakaraka')],
    ];
    final plain = _str('plain_statement');
    final disclaimer = _str('past_life_disclaimer').isNotEmpty ? _str('past_life_disclaimer') : _str('disclaimer');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.crReliability, color: KColors.blue),
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
  //  17 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.pkTopicMastery, l.pkTopicUnfinished, l.pkTopicRelationships, l.pkTopicDebts, l.pkTopicResolution, l.pkTopicMemory, l.pkTopicTiming, l.pkTopicProfile];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.forum_rounded, title: l.crDiscussAi, color: AppColors.gold),
      ReportPdfButton(path: 'report/past_life/${widget.chartId}', filename: 'report-${widget.chartName}'),
      const SizedBox(height: 10),
      ReportAiChatCta(domainKey: 'life_path_luck', label: 'Life Path & Luck', emoji: '🌟'),
      const SizedBox(height: 14),
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
    final q = '$topic — based on my Vedic past-life & karma report for ${widget.chartName}.\n\n${_buildPrompt(_data!)}';
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

  Widget _iconTile(String emoji, String label, String value, {Color? color}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 17)), const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w600)),
      Text(value, style: TextStyle(color: color ?? AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis),
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
    final name = widget.chartName;
    final overall = d['past_life_signature_strength_score'] ?? '?';
    final verdict = d['overall_past_life_verdict'] ?? '';
    final theme = d['primary_past_life_theme'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic past-life and karma advisor. Analyze this past-life & karma report for $name and provide actionable insights.

Key highlights:
- Past-life signature strength: $overall/100
- Overall verdict: $verdict
- Primary past-life theme: $theme

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the most important activation windows, and suggest practical next steps for karmic resolution.''';
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
