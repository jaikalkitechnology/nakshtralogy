import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'engine_report_base.dart';
import 'report_components.dart';

class MentalReportScreen extends EngineReportBase {
  const MentalReportScreen({super.key, required super.chartId, required super.chartName, super.preloadedData})
      : super(engineKey: 'mental_stress', engineLabel: 'Mental & Stress');
  @override
  State<MentalReportScreen> createState() => _S();
}

class _S extends EngineReportBaseState<MentalReportScreen> {
  @override
  List<Widget> buildSections(Map<String, dynamic> d) {
    return [
      heroScores('🧠 MENTAL SCORES', [
        [n(d, 'mental_stability_score'), 'MENTAL\nSTABILITY'],
        [n(d, 'emotional_baseline_score'), 'EMOTIONAL\nBASELINE'],
        [n(d, 'mental_resilience_score'), 'RESILIENCE'],
      ], [
        [n(d, 'anxiety_vulnerability_score'), 'ANXIETY'], [n(d, 'depression_vulnerability_score'), 'DEPRESSION'],
        [n(d, 'emotional_regulation_score'), 'REGULATION'],
      ]),
      styleRows('Mental Profile', [
        ['CONSTITUTION', d['emotional_constitution']], ['STRESS DRIVER', d['primary_stress_driver']],
        ['STABILITY ANCHOR', d['primary_stability_anchor']], ['STRESS RESPONSE', d['stress_response_pattern']],
        ['ATTACHMENT STYLE', d['attachment_style_indicator']], ['BURNOUT STAGE', d['current_burnout_stage']],
      ]),
      if (d['karaka_mental_weight_table'] is Map) ...[
        ReportHeader('Mental', 'Karakas', '9 PLANETS'),
        karakaTable((d['karaka_mental_weight_table'] as Map).cast<String, dynamic>()),
      ],
      yogaLedger('Mental Yogas', (d['active_stress_yogas'] as List?) ?? [],
        (d['active_mental_protective_yogas'] as List?) ?? [],
        creatingLabel: 'STRESS PRESSURE', clearingLabel: 'PROTECTIVE'),
      // Anxiety types
      if (d['anxiety_type_scores'] is Map) _anxietyTypes(d),
      // Therapy modalities
      if (d['therapy_modality_fit_scores'] is Map) _therapyFit(d),
      yearlyTrend('Wellness Trend', (d['yearly_mental_wellness_trend'] as List?) ?? [], scoreKey: 'wellness'),
      // Coping
      chipsList('✓ HEALTHY COPING', (d['healthy_coping_mechanisms'] as List?) ?? [], AppColors.success),
      chipsList('⚠ UNHEALTHY RISKS', (d['unhealthy_coping_risks'] as List?) ?? [], AppColors.warning),
      chipsList('✦ RECOMMENDED ALTERNATIVES', (d['healthy_alternatives_chart_suggests'] as List?) ?? [], AppColors.aurora),
      statTiles([
        [n(d, 'sleep_quality_tendency_score'), 'SLEEP QUALITY'], [n(d, 'social_support_quality_score'), 'SOCIAL SUPPORT'],
        [n(d, 'burnout_vulnerability_score'), 'BURNOUT VULN'], [n(d, 'self_awareness_score'), 'SELF-AWARENESS'],
      ]),
      const SizedBox(height: 10),
      remedies((d['astrological_remedies'] as List?) ?? []),
      // Core theme
      if (d['core_mental_theme'] is Map) _coreTheme(d),
      verdictCard(d['overall_mental_wellness_verdict']?.toString() ?? '', d['next_most_supportive_action']?.toString(),
        subtitle: d['chart_reminds_you_that']?.toString()),
    ];
  }

  Widget _anxietyTypes(Map d) {
    final types = (d['anxiety_type_scores'] as Map).cast<String, dynamic>();
    final sorted = types.entries.where((e) => e.value is num).toList()..sort((a, b) => (b.value as num).compareTo(a.value as num));
    return Column(children: [
      ReportHeader('Anxiety', 'Types', '${sorted.length} PATTERNS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: sorted.take(8).map((e) {
          final v = (e.value as num).toDouble();
          final c = v >= 35 ? AppColors.error : v >= 25 ? AppColors.warning : AppColors.success;
          return Padding(padding: const EdgeInsets.only(bottom: 5), child: Row(children: [
            SizedBox(width: 80, child: Text(titleCase(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 10))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
            const SizedBox(width: 6),
            SizedBox(width: 26, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
          ]));
        }).toList())),
    ]);
  }

  Widget _therapyFit(Map d) {
    final fits = (d['therapy_modality_fit_scores'] as Map).cast<String, dynamic>();
    final sorted = fits.entries.where((e) => e.value is num).toList()..sort((a, b) => (b.value as num).compareTo(a.value as num));
    return Column(children: [
      ReportHeader('Therapy', 'Modality Fit', '${sorted.length} TYPES'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: sorted.take(9).toList().asMap().entries.map((e) {
          final v = (e.value.value as num).toDouble();
          final isTop = e.key < 3;
          final c = isTop ? AppColors.aurora : AppColors.smoke;
          return Padding(padding: const EdgeInsets.only(bottom: 5), child: Row(children: [
            SizedBox(width: 80, child: Text(titleCase(e.value.key), style: TextStyle(color: isTop ? AppColors.ivory : AppColors.smoke, fontSize: 10, fontWeight: isTop ? FontWeight.w600 : FontWeight.normal))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
            const SizedBox(width: 6),
            SizedBox(width: 26, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
          ]));
        }).toList())),
    ]);
  }

  Widget _coreTheme(Map d) {
    final theme = (d['core_mental_theme'] as Map).cast<String, dynamic>();
    final isGift = theme['is_gift'] == true;
    final c = isGift ? AppColors.success : AppColors.aurora;
    return Container(margin: const EdgeInsets.fromLTRB(16, 8, 16, 8), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(isGift ? '✦ CORE GIFT' : '● CORE THEME', style: TextStyle(color: c, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(theme['primary_theme']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
        if (theme['explanation'] != null) ...[const SizedBox(height: 4),
          Text(theme['explanation'].toString(), style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic))],
        if (theme['healing_direction'] != null) ...[const SizedBox(height: 6),
          Text('→ ${theme['healing_direction']}', style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w600))],
      ]));
  }
}
