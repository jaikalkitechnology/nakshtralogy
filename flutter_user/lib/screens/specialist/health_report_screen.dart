import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../l10n/gen/app_localizations.dart';
import 'engine_report_base.dart';
import 'report_components.dart';

class HealthReportScreen extends EngineReportBase {
  const HealthReportScreen({super.key, required super.chartId, required super.chartName, super.preloadedData})
      : super(engineKey: 'health', engineLabel: 'Health & Wellness');
  @override
  State<HealthReportScreen> createState() => _S();
}

class _S extends EngineReportBaseState<HealthReportScreen> {
  @override
  List<Widget> buildSections(Map<String, dynamic> d) {
    final l = AppLocalizations.of(context)!;
    return [
      heroScores(l.healthScoresHeader, [
        [n(d, 'vitality_score'), l.healthVitalityStat],
        [n(d, 'immunity_strength_score'), l.healthImmunityStat],
      ], [
        [n(d, 'recovery_capacity_score'), l.healthRecoveryStat], [n(d, 'mental_wellness_strength_score'), l.healthMentalStat],
        [n(d, 'stress_tolerance_score'), l.healthStressTolStat],
      ]),
      // Constitution
      _constitution(d),
      if (d['karaka_body_map'] is Map) _bodyMap(d),
      yogaLedger(l.healthYogasTitle, (d['active_disease_creating_yogas'] as List?) ?? [],
        (d['active_protective_yogas'] as List?) ?? [],
        creatingLabel: l.healthDiseasePressureLabel, clearingLabel: l.protectiveLabel),
      if (d['body_area_vulnerability_scores'] is Map) _bodyZones(d),
      if (d['disease_category_susceptibility_scores'] is Map) _diseaseHeat(d),
      yearlyTrend(l.healthTrendTitle, (d['yearly_health_trend'] as List?) ?? [], scoreKey: 'vitality'),
      periodCards(l.healthRecoveryWindowsTitle, (d['recovery_windows'] as List?) ?? [],
        l.healthCautionPeriodsTitle, (d['acute_event_risk_windows'] as List?) ?? []),
      _lifestyle(d),
      statTiles([
        [n(d, 'fertility_indicator_score'), l.healthFertilityStat], [n(d, 'burnout_vulnerability_score'), l.healthBurnoutRiskStat],
        [n(d, 'addiction_vulnerability_score'), l.healthAddictionVulnStat], [d['work_life_balance_health_score'] ?? 0, l.healthWorkLifeBalStat],
      ]),
      const SizedBox(height: 10),
      risks((d['major_health_risks'] as List?) ?? []),
      remedies((d['astrological_remedies'] as List?) ?? []),
      verdictCard(d['overall_health_verdict']?.toString() ?? '', d['recommended_health_strategy']?.toString()),
    ];
  }

  Widget _constitution(Map d) {
    final l = AppLocalizations.of(context)!;
    final type = d['constitutional_type']?.toString() ?? '';
    final dominant = d['dominant_dosha']?.toString() ?? '';
    final secondary = d['secondary_dosha']?.toString() ?? '';
    final notes = d['ayurvedic_body_type_notes']?.toString() ?? '';
    if (type.isEmpty) return const SizedBox.shrink();
    final colors = {'vata': AppColors.aurora, 'pitta': AppColors.saffron, 'kapha': AppColors.success};
    final c = colors[dominant] ?? AppColors.gold;
    return Column(children: [
      ReportHeader(l.healthAyurvedicWord, l.healthConstitutionSuffix, '3 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [c.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.1)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(titleCase(type), style: TextStyle(color: c, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'serif')),
          Row(children: [
            Text(l.dominantLabel(titleCase(dominant)), style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w600)),
            if (secondary.isNotEmpty) Text(l.secondaryLabel(titleCase(secondary)), style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
          ]),
          if (notes.isNotEmpty) ...[const SizedBox(height: 6),
            Text(notes, style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic))],
        ])),
    ]);
  }

  Widget _bodyMap(Map d) {
    final l = AppLocalizations.of(context)!;
    final map = (d['karaka_body_map'] as Map).cast<String, dynamic>();
    return Column(children: [
      ReportHeader(l.healthBodyWord, l.healthSystemMapSuffix, '9 PLANETS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: map.entries.take(9).map((e) {
          final info = (e.value is Map) ? (e.value as Map).cast<String, dynamic>() : <String, dynamic>{};
          final v = (info['strength'] as num?)?.toDouble() ?? 50;
          final system = info['body_system']?.toString() ?? '';
          final c = v >= 65 ? AppColors.success : v >= 45 ? AppColors.gold : AppColors.warning;
          return Padding(padding: const EdgeInsets.only(bottom: 5), child: Row(children: [
            SizedBox(width: 50, child: Text(e.key, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w600))),
            Expanded(child: Text(system, style: const TextStyle(color: AppColors.smoke, fontSize: 8), maxLines: 1, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 4),
            SizedBox(width: 40, child: ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: v / 100, minHeight: 3, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
            SizedBox(width: 24, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right,
              style: TextStyle(color: c, fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
          ]));
        }).toList())),
    ]);
  }

  Widget _bodyZones(Map d) {
    final l = AppLocalizations.of(context)!;
    final zones = (d['body_area_vulnerability_scores'] as Map).cast<String, dynamic>();
    final sorted = zones.entries.where((e) => e.value is num).toList()..sort((a, b) => (b.value as num).compareTo(a.value as num));
    return Column(children: [
      ReportHeader(l.healthBodyZoneWord, l.healthVulnerabilitySuffix, '12 ZONES'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: sorted.take(12).map((e) {
          final v = (e.value as num).toDouble();
          final c = v >= 30 ? AppColors.error : v >= 20 ? AppColors.warning : AppColors.success;
          return Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
            Expanded(child: Text(e.key, style: const TextStyle(color: AppColors.ivory, fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis)),
            SizedBox(width: 50, child: ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: v / 100, minHeight: 3, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
            SizedBox(width: 24, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right,
              style: TextStyle(color: c, fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
          ]));
        }).toList())),
    ]);
  }

  Widget _diseaseHeat(Map d) {
    final l = AppLocalizations.of(context)!;
    final cats = (d['disease_category_susceptibility_scores'] as Map).cast<String, dynamic>();
    final sorted = cats.entries.where((e) => e.value is num).toList()..sort((a, b) => (b.value as num).compareTo(a.value as num));
    return Column(children: [
      ReportHeader(l.healthDiseaseWord, l.healthSusceptibilitySuffix, '${sorted.length} CATEGORIES'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: sorted.take(13).map((e) {
          final v = (e.value as num).toDouble();
          final c = v >= 40 ? AppColors.error : v >= 30 ? AppColors.warning : AppColors.success;
          return Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
            SizedBox(width: 80, child: Text(titleCase(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 9))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
            const SizedBox(width: 6),
            SizedBox(width: 24, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right,
              style: TextStyle(color: c, fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
          ]));
        }).toList())),
    ]);
  }

  Widget _lifestyle(Map d) {
    final l = AppLocalizations.of(context)!;
    return styleRows(l.healthLifestyleFactorsTitle, [
      [l.healthSleepDisciplineLabel, '${n(d, 'sleep_discipline_impact_score').toStringAsFixed(0)}/100'],
      [l.healthDietDisciplineLabel, '${n(d, 'diet_discipline_impact_score').toStringAsFixed(0)}/100'],
      [l.healthExerciseNeedLabel, '${n(d, 'exercise_need_score').toStringAsFixed(0)}/100'],
      [l.healthSunlightNeedLabel, '${n(d, 'sunlight_need_score').toStringAsFixed(0)}/100'],
      [l.healthSocialTypeLabel, d['social_energy_type']],
      [l.healthHealingSpeedLabel, d['healing_speed_tendency']],
    ]);
  }
}
