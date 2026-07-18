import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
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
    final l = AppLocalizations.of(context)!;
    return [
      heroScores('🏠 ${l.propertyScoresLabel}', [
        [n(d, 'property_acquisition_capacity_score'), l.acquisitionCapacityLabel],
        [n(d, 'home_ownership_probability_pct'), l.homeOwnershipPctLabel],
        [n(d, 'real_estate_wealth_potential_score'), l.reWealthPotentialLabel],
      ], [
        [n(d, 'rental_income_potential_score'), l.rentalWord], [n(d, 'vehicle_ownership_quality_score'), l.vehiclesWord],
        [n(d, 'land_ownership_probability_pct'), l.landPctLabel],
      ]),
      styleRows(l.propertyProfileTitle, [
        [l.karmaTypeLabel, d['property_karma_type']], [l.environmentLabel, d['preferred_property_environment']],
        [l.styleLabel, d['property_style_preference']], [l.sizeLabel, d['property_size_tendency']],
        [l.locationLabel, d['location_style']], [l.actionNext12mLabel, d['recommended_property_action_next_12_months']],
      ]),
      if (d['karaka_property_table'] is Map) ...[
        ReportHeader(l.propertyWord, l.karakasWord, '9 PLANETS'),
        karakaTable(Map.fromEntries((d['karaka_property_table'] as Map).entries.map((e) =>
          MapEntry(e.key.toString(), (e.value is Map ? (e.value as Map)['strength'] : e.value) ?? 0)))),
      ],
      yogaLedger(l.propertyYogasTitle, (d['active_property_doshas'] as List?) ?? [],
        (d['active_property_yogas'] as List?) ?? [],
        creatingLabel: l.drainsLabel, clearingLabel: l.boostersLabel),
      yearlyTrend(l.propertyTrendTitle, (d['yearly_property_trend'] as List?) ?? [], scoreKey: 'favorability'),
      if ((d['buying_windows'] as List?)?.isNotEmpty == true)
        TimingWindowCard(title: '${l.buyingWindowsTitle} ★', icon: '★', color: AppColors.gold, items: d['buying_windows'] as List, isPeak: true),
      if ((d['construction_or_renovation_windows'] as List?)?.isNotEmpty == true)
        TimingWindowCard(title: l.constructionWindowsTitle, icon: '▲', color: AppColors.aurora, items: d['construction_or_renovation_windows'] as List),
      // Inheritance
      statTiles([
        [n(d, 'maternal_inheritance_probability_pct'), l.maternalInherPctLabel],
        [n(d, 'paternal_inheritance_probability_pct'), l.paternalInherPctLabel],
        [n(d, 'multiple_homes_probability_pct'), l.multiHomePctLabel],
        [n(d, 'investment_property_probability_pct'), l.investmentPctLabel],
      ]),
      const SizedBox(height: 10),
      // Vehicles
      styleRows(l.vehicleProfileTitle, [
        [l.countLabel, d['number_of_vehicles_tendency']], [l.firstAgeLabel, d['first_vehicle_age_band']],
        [l.categoryLabel, d['preferred_vehicle_category']], [l.luxuryLabel, '${n(d, 'luxury_vehicle_affinity_score').toStringAsFixed(0)}/100'],
      ]),
      risks((d['major_property_risks'] as List?) ?? []),
      remedies((d['astrological_remedies'] as List?) ?? []),
      verdictCard(d['property_life_verdict']?.toString() ?? '', d['recommended_property_strategy']?.toString(),
        subtitle: l.lifetimeCountFulfillmentLabel(d['lifetime_property_count_estimate']?.toString() ?? "?", n(d, 'property_fulfillment_probability_pct').toStringAsFixed(0))),
    ];
  }
}
