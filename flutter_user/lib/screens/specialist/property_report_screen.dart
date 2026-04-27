import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'engine_report_base.dart';
import 'report_components.dart';

class PropertyReportScreen extends EngineReportBase {
  const PropertyReportScreen({super.key, required super.chartId, required super.chartName, super.preloadedData})
      : super(engineKey: 'property', engineLabel: 'Property & Assets');
  @override
  State<PropertyReportScreen> createState() => _S();
}

class _S extends EngineReportBaseState<PropertyReportScreen> {
  @override
  List<Widget> buildSections(Map<String, dynamic> d) {
    return [
      heroScores('🏠 PROPERTY SCORES', [
        [n(d, 'property_acquisition_capacity_score'), 'ACQUISITION\nCAPACITY'],
        [n(d, 'home_ownership_probability_pct'), 'HOME\nOWNERSHIP %'],
        [n(d, 'real_estate_wealth_potential_score'), 'RE WEALTH\nPOTENTIAL'],
      ], [
        [n(d, 'rental_income_potential_score'), 'RENTAL'], [n(d, 'vehicle_ownership_quality_score'), 'VEHICLES'],
        [n(d, 'land_ownership_probability_pct'), 'LAND %'],
      ]),
      styleRows('Property Profile', [
        ['KARMA TYPE', d['property_karma_type']], ['ENVIRONMENT', d['preferred_property_environment']],
        ['STYLE', d['property_style_preference']], ['SIZE', d['property_size_tendency']],
        ['LOCATION', d['location_style']], ['ACTION NEXT 12M', d['recommended_property_action_next_12_months']],
      ]),
      if (d['karaka_property_table'] is Map) ...[
        ReportHeader('Property', 'Karakas', '9 PLANETS'),
        karakaTable(Map.fromEntries((d['karaka_property_table'] as Map).entries.map((e) =>
          MapEntry(e.key.toString(), (e.value is Map ? (e.value as Map)['strength'] : e.value) ?? 0)))),
      ],
      yogaLedger('Property Yogas', (d['active_property_doshas'] as List?) ?? [],
        (d['active_property_yogas'] as List?) ?? [],
        creatingLabel: 'DRAINS', clearingLabel: 'BOOSTERS'),
      yearlyTrend('Property Trend', (d['yearly_property_trend'] as List?) ?? [], scoreKey: 'favorability'),
      if ((d['buying_windows'] as List?)?.isNotEmpty == true)
        TimingWindowCard(title: 'Buying Windows ★', icon: '★', color: AppColors.gold, items: d['buying_windows'] as List, isPeak: true),
      if ((d['construction_or_renovation_windows'] as List?)?.isNotEmpty == true)
        TimingWindowCard(title: 'Construction Windows', icon: '▲', color: AppColors.aurora, items: d['construction_or_renovation_windows'] as List),
      // Inheritance
      statTiles([
        [n(d, 'maternal_inheritance_probability_pct'), 'MATERNAL INHER %'],
        [n(d, 'paternal_inheritance_probability_pct'), 'PATERNAL INHER %'],
        [n(d, 'multiple_homes_probability_pct'), 'MULTI-HOME %'],
        [n(d, 'investment_property_probability_pct'), 'INVESTMENT %'],
      ]),
      const SizedBox(height: 10),
      // Vehicles
      styleRows('Vehicle Profile', [
        ['COUNT', d['number_of_vehicles_tendency']], ['FIRST AGE', d['first_vehicle_age_band']],
        ['CATEGORY', d['preferred_vehicle_category']], ['LUXURY', '${n(d, 'luxury_vehicle_affinity_score').toStringAsFixed(0)}/100'],
      ]),
      risks((d['major_property_risks'] as List?) ?? []),
      remedies((d['astrological_remedies'] as List?) ?? []),
      verdictCard(d['property_life_verdict']?.toString() ?? '', d['recommended_property_strategy']?.toString(),
        subtitle: 'Lifetime count: ${d['lifetime_property_count_estimate'] ?? "?"} · Fulfillment: ${n(d, 'property_fulfillment_probability_pct').toStringAsFixed(0)}%'),
    ];
  }
}
