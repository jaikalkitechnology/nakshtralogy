import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'engine_report_base.dart';
import 'report_components.dart';

class MarriageReportScreen extends EngineReportBase {
  const MarriageReportScreen({super.key, required super.chartId, required super.chartName, super.preloadedData})
      : super(engineKey: 'marriage', engineLabel: 'Marriage & Family');
  @override
  State<MarriageReportScreen> createState() => _S();
}

class _S extends EngineReportBaseState<MarriageReportScreen> {
  @override
  List<Widget> buildSections(Map<String, dynamic> d) {
    return [
      heroScores('💒 MARRIAGE SCORES', [
        [n(d, 'overall_marriage_strength_score'), 'OVERALL\nMARRIAGE'],
        [n(d, 'marital_harmony_score'), 'MARITAL\nHARMONY'],
        [n(d, 'domestic_stability_score'), 'DOMESTIC\nSTABILITY'],
      ], [
        [n(d, 'marriage_longevity_score'), 'LONGEVITY'],
        [n(d, 'marital_satisfaction_score'), 'SATISFACTION'],
        [n(d, 'marriage_clarity_score'), 'CLARITY'],
      ]),
      // Darakaraka (spouse)
      _darakaraka(d),
      // 7th house
      _seventhHouse(d),
      // Spouse profile
      _spouseProfile(d),
      // Harmony radar
      _harmonyScores(d),
      // Mangal dosh
      if (d['mangal_dosh_present'] == true) _mangalDosh(d),
      // Marriage windows
      if ((d['primary_marriage_windows'] as List?)?.isNotEmpty == true)
        TimingWindowCard(title: 'Marriage Windows', icon: '★', color: AppColors.gold,
          items: (d['primary_marriage_windows'] as List), isPeak: true),
      // Divisionals
      if (d['d9_validation'] is Map) _d9Card(d),
      yearlyTrend('Marriage Phases', [], scoreKey: 'score'),
      // Family dynamics
      statTiles([
        [n(d, 'in_law_relations_score'), 'IN-LAW RELATIONS'], [n(d, 'family_harmony_score'), 'FAMILY HARMONY'],
        [n(d, 'fertility_within_marriage_score'), 'FERTILITY'], [n(d, 'home_ownership_likelihood_score'), 'HOME OWNERSHIP'],
      ]),
      const SizedBox(height: 10),
      // Risk scores
      statTiles([
        [n(d, 'separation_divorce_risk_score'), 'DIVORCE RISK'], [n(d, 'infidelity_risk_score'), 'INFIDELITY'],
        [n(d, 'marital_conflict_risk_score'), 'CONFLICT'], [n(d, 'emotional_distance_risk_score'), 'DISTANCE'],
      ]),
      const SizedBox(height: 10),
      risks((d['major_marriage_risks'] as List?) ?? []),
      // Partner guide
      chipsList('★ SEEK IN PARTNER', (d['partner_qualities_to_seek'] as List?) ?? [], AppColors.success),
      chipsList('⚠ AVOID IN PARTNER', (d['partner_qualities_to_avoid'] as List?) ?? [], AppColors.error),
      remedies((d['astrological_remedies'] as List?) ?? []),
      verdictCard(d['overall_marriage_verdict']?.toString() ?? '', d['marriage_verdict_explanation']?.toString(),
        subtitle: 'Realization: ${n(d, 'marriage_realization_potential_score').toStringAsFixed(0)}%'),
    ];
  }

  Widget _darakaraka(Map d) {
    final planet = d['darakaraka_planet']?.toString() ?? '';
    final desc = d['darakaraka_spouse_signature']?.toString() ?? '';
    final d9dig = d['darakaraka_d9_dignity']?.toString() ?? '';
    if (planet.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader('Darakaraka', 'Spouse Karaka', '8 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.cosmicPink.withOpacity(0.15), const Color(0xFF4A3B8C).withOpacity(0.15)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cosmicPink.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('DARAKARAKA (DK)', style: TextStyle(color: AppColors.cosmicPink, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(children: [
            Text(planet, style: const TextStyle(color: AppColors.ivory, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'serif')),
            if (d9dig.isNotEmpty) ...[const SizedBox(width: 10), DignityBadge('D9', d9dig)],
          ]),
          if (desc.isNotEmpty) ...[const SizedBox(height: 6),
            Text(desc, style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic))],
        ])),
    ]);
  }

  Widget _seventhHouse(Map d) {
    return Column(children: [
      ReportHeader('7th', 'House', '10 KEYS'),
      KeyValueBox(rows: {
        'SIGN': d['seventh_house_sign_name']?.toString() ?? '—',
        'LORD': d['seventh_lord_planet']?.toString() ?? '—',
        'LORD IN': '${d['seventh_lord_house'] ?? "?"}H',
        'LORD DIGNITY': d['seventh_lord_dignity']?.toString() ?? '—',
        'OCCUPANTS': ((d['seventh_house_occupants'] as List?)?.join(', ') ?? 'Empty'),
        'STRENGTH': '${n(d, 'seventh_house_strength_score').toStringAsFixed(1)}/100',
      }, callout: d['seventh_lord_marriage_indication']?.toString()),
    ]);
  }

  Widget _spouseProfile(Map d) {
    final arch = d['spouse_primary_archetype']?.toString() ?? '';
    final traits = (d['spouse_personality_traits'] as List?) ?? [];
    final profs = (d['spouse_likely_profession_categories'] as List?) ?? [];
    if (arch.isEmpty && traits.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader('Spouse', 'Profile', '${traits.length + 3} KEYS'),
      if (arch.isNotEmpty) Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.cosmicPink.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cosmicPink.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(titleCase(arch), style: const TextStyle(color: AppColors.cosmicPink, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif')),
          if (d['spouse_physical_indicators'] != null) Text(d['spouse_physical_indicators'].toString(),
            style: const TextStyle(color: AppColors.lavender, fontSize: 10, fontStyle: FontStyle.italic)),
        ])),
      chipsList('★ SPOUSE TRAITS', traits, AppColors.aurora),
      chipsList('● LIKELY PROFESSIONS', profs, AppColors.gold),
    ]);
  }

  Widget _harmonyScores(Map d) {
    final items = [
      ['Emotional', n(d, 'emotional_harmony_score')], ['Intellectual', n(d, 'intellectual_compatibility_score')],
      ['Physical', n(d, 'physical_intimacy_harmony_score')], ['Financial', n(d, 'financial_alignment_score')],
      ['Spiritual', n(d, 'spiritual_alignment_score')], ['Communication', n(d, 'communication_harmony_score')],
      ['Shared Values', n(d, 'shared_values_score')], ['Conflict Resolution', n(d, 'conflict_resolution_capacity_score')],
    ];
    return Column(children: [
      ReportHeader('Harmony', 'Radar', '${items.length} AXES'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: items.map((i) {
          final v = i[1] as double;
          final c = v >= 65 ? AppColors.success : v >= 50 ? AppColors.gold : AppColors.warning;
          return Padding(padding: const EdgeInsets.only(bottom: 5), child: Row(children: [
            SizedBox(width: 80, child: Text(i[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 10))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
            const SizedBox(width: 8),
            SizedBox(width: 28, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right,
              style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
          ]));
        }).toList())),
    ]);
  }

  Widget _mangalDosh(Map d) {
    final sev = n(d, 'mangal_dosh_severity');
    final cancel = d['mangal_dosh_cancellation_signature']?.toString() ?? '';
    return Container(margin: const EdgeInsets.fromLTRB(16, 4, 16, 8), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.error.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('⚠ MANGAL DOSH', style: TextStyle(color: AppColors.error, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w700)),
          const Spacer(),
          Text('Severity: ${sev.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.w700)),
        ]),
        if (cancel.isNotEmpty) ...[const SizedBox(height: 6),
          Text('Cancellation: $cancel', style: const TextStyle(color: AppColors.aurora, fontSize: 10))],
      ]));
  }

  Widget _d9Card(Map d) {
    final d9 = (d['d9_validation'] as Map).cast<String, dynamic>();
    return Column(children: [
      ReportHeader('D-9', 'Navamsa', 'PRIMARY'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withOpacity(0.15))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (d9['d9_venus_dignity'] != null) DignityBadge('Venus', d9['d9_venus_dignity'].toString()),
          if (d9['d9_jupiter_dignity'] != null) DignityBadge('Jupiter', d9['d9_jupiter_dignity'].toString()),
          if (d9['d9_seventh_lord_dignity'] != null) DignityBadge('7th Lord', d9['d9_seventh_lord_dignity'].toString()),
          if (d9['d9_darakaraka_dignity'] != null) DignityBadge('Darakaraka', d9['d9_darakaraka_dignity'].toString()),
          if (d9['d9_primary_marriage_signature'] != null) ...[const SizedBox(height: 6),
            Text(d9['d9_primary_marriage_signature'].toString(), style: const TextStyle(color: AppColors.lavender, fontSize: 9, fontStyle: FontStyle.italic))],
        ])),
    ]);
  }
}
