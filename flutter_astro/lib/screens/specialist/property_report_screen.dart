import 'dart:convert';
import 'package:flutter/material.dart';
import '../../widgets/desktop_center.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Property & Assets report — premium AI property-coach redesign.
///
/// Presentation only. Loads the `property` specialist
/// (`runSpecialist('property')`) unchanged and re-presents it; every score,
/// karaka, yoga, dosha, timing window, remedy and confidence value comes
/// straight from the engine.
class PropertyReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const PropertyReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});
  @override
  State<PropertyReportScreen> createState() => _PropertyState();
}

class _PropertyState extends State<PropertyReportScreen> {
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
      final resp = await _api.runSpecialist('property', widget.chartId);
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
          Text(widget.chartName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700)),
          Text(l.prSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
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
      gap, _yogasDoshas(l),      // 4
      gap, _verification(l),     // 5
      gap, _journey(l),          // 6
      gap, _inheritance(l),      // 7
      gap, _landInvestment(l),   // 8
      gap, _vehicles(l),         // 9
      gap, _legalRisk(l),        // 10
      gap, _dueDiligence(l),     // 11
      gap, _improvementPlan(l),  // 12
      gap, _reliability(l),      // 13
      gap, _discussAi(l),        // 14
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.prTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — PROPERTY SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _sc('property_acquisition_capacity_score');
    final col = _col(overall);
    final theme = _map('core_property_theme');
    final summary = theme['explanation']?.toString().isNotEmpty == true ? theme['explanation'].toString() : _str('property_life_verdict');
    final gauges = <List<Object>>[
      [l.prAcquisitionCapacity, overall],
      [l.prHomeOwnership, _sc('home_ownership_probability_pct')],
      [l.prWealthPotential, _sc('real_estate_wealth_potential_score')],
      [l.prRentalIncome, _sc('rental_income_potential_score')],
      [l.prLandOwnership, _sc('land_ownership_probability_pct')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.prSnapshotHeader.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
    if (_sc('home_ownership_probability_pct') >= 60) out.add(l.prChipHomeOwner);
    if (_sc('real_estate_wealth_potential_score') >= 65) out.add(l.prChipWealthBuilder);
    if (_sc('land_ownership_probability_pct') >= 60) out.add(l.prChipLandOwner);
    if (_sc('property_as_investment_affinity_score') >= 55) out.add(l.prChipInvestor);
    if (_sc('maternal_inheritance_probability_pct') >= 55 || _sc('paternal_inheritance_probability_pct') >= 55) out.add(l.prChipInheritance);
    if (_sc('vehicle_ownership_quality_score') >= 55) out.add(l.prChipVehicle);
    if (_sc('nri_asset_affinity_score') >= 55) out.add(l.prChipGlobalAsset);
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
  //  2 — PROPERTY PROFILE & STYLE
  // ══════════════════════════════════════════════════════════════════
  Widget _profile(AppLocalizations l) {
    final karmaType = _str('property_karma_type');
    if (karmaType.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.home_work_rounded, title: l.prProfileTitle, color: AppColors.gold),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.14), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.gold.withOpacity(0.28))),
        child: Column(children: [
          Text(_titleCase(karmaType), style: const TextStyle(color: AppColors.gold, fontSize: 19, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Wrap(alignment: WrapAlignment.center, spacing: 6, runSpacing: 6, children: [
            if (_str('property_style_preference').isNotEmpty) _pill(_titleCase(_str('property_style_preference')), KColors.blue),
            if (_str('property_size_tendency').isNotEmpty) _pill(_titleCase(_str('property_size_tendency')), KColors.purple),
            if (_str('preferred_property_environment').isNotEmpty) _pill(_titleCase(_str('preferred_property_environment')), KColors.green),
            if (_str('location_style').isNotEmpty) _pill(_titleCase(_str('location_style')), KColors.orange),
            if (_str('climate_type_fit').isNotEmpty) _pill(_titleCase(_str('climate_type_fit')), AppColors.gold),
          ]),
        ])),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.prHomeAesthetics, _sc('home_aesthetics_priority_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.prHomeSanctuary, _sc('home_as_sanctuary_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.prComfortInvestment, _sc('home_comfort_investment_tendency_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.prVastuPriority, _sc('vastu_compliance_priority_score'))),
      ]),
      if (_str('natural_elements_preference').isNotEmpty || _str('recommended_property_action_next_12_months').isNotEmpty) ...[
        const SizedBox(height: 10),
        _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (_str('natural_elements_preference').isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 6),
            child: Text('🌿 ${l.prNaturalElements}: ${_titleCase(_str('natural_elements_preference'))}', style: const TextStyle(color: AppColors.ivory, fontSize: 12))),
          if (_str('recommended_property_action_next_12_months').isNotEmpty)
            Text('🎯 ${l.prNextActionLabel}: ${_titleCase(_str('recommended_property_action_next_12_months'))}', style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w700)),
        ])),
      ],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  3 — YOUR PROPERTY PLANETS
  // ══════════════════════════════════════════════════════════════════
  Widget _karakaTable(AppLocalizations l) {
    final map = _map('karaka_property_table');
    if (map.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.hub_rounded, title: l.prKarakaTitle, subtitle: l.prKarakaSubtitle, color: KColors.purple),
      Row(children: [
        Expanded(child: _iconTile('🪐', l.prPrimaryKaraka, _str('primary_property_karaka'))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🏛️', l.prDurableAsset, _str('durable_asset_karaka'))),
      ]),
      const SizedBox(height: 10),
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
  //  4 — PROPERTY YOGAS & DOSHAS
  // ══════════════════════════════════════════════════════════════════
  Widget _yogasDoshas(AppLocalizations l) {
    final yogas = _list('active_property_yogas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final doshas = _list('active_property_doshas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (yogas.isEmpty && doshas.isEmpty) return const SizedBox.shrink();
    final phase = _str('current_property_phase');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.auto_awesome_rounded, title: l.prYogasTitle, color: AppColors.gold),
      if (phase.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 10),
        child: _pill('${l.prCurrentPhase}: ${_titleCase(phase)}', KColors.blue)),
      if (yogas.isNotEmpty) ...[
        _catLabel('🛡️', l.prBoosters, KColors.green),
        ...yogas.take(6).map((m) => _yogaRow(m['name']?.toString() ?? '', (m['score'] is num ? m['score'] as num : null)?.toDouble() ?? 0, KColors.green)),
        const SizedBox(height: 6),
      ],
      if (doshas.isNotEmpty) ...[
        _catLabel('⚠️', l.prDrains, KColors.orange),
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
  //  5 — VERIFICATION ACROSS CHARTS (D4 / D16)
  // ══════════════════════════════════════════════════════════════════
  Widget _verification(AppLocalizations l) {
    final d4 = _map('d4_validation'), d16 = _map('d16_validation');
    if (d4.isEmpty && d16.isEmpty) return const SizedBox.shrink();
    final d4Score = (d4['d4_score'] is num ? d4['d4_score'] as num : null)?.toDouble() ?? 0;
    final d16Score = (d16['d16_validation_score'] is num ? d16['d16_validation_score'] as num : null)?.toDouble() ?? 0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_rounded, title: l.prVerificationTitle, color: KColors.green),
      if (d4.isNotEmpty) _chartCard(l, l.prD4Property, d4Score, _titleCase(d4['d4_property_karma_type']?.toString() ?? ''),
        ['D4 4L: ${d4['d4_4_lord_dignity']}', 'D4 Venus: ${d4['d4_venus_dignity']} · Mars: ${d4['d4_mars_dignity']}']),
      if (d16.isNotEmpty) _chartCard(l, l.prD16Vehicle, d16Score, _titleCase(d16['vehicle_luck_quality']?.toString() ?? ''),
        ['D16 ${l.prVehicleFit}: ${_titleCase(d16['vehicle_type_fit']?.toString() ?? '')}']),
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
  //  6 — OWNERSHIP JOURNEY & TIMELINE
  // ══════════════════════════════════════════════════════════════════
  Widget _journey(AppLocalizations l) {
    final firstWindow = _map('first_major_property_window');
    final nextWindow = _map('next_property_opportunity_window');
    final buying = _list('buying_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final construction = _list('construction_or_renovation_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.timeline_rounded, title: l.prJourneyTitle, color: AppColors.gold),
      Row(children: [
        Expanded(child: _iconTile('🏡', l.prFirstHomeAge, _str('first_home_age_band'))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🔑', l.prFirstHomeType, _titleCase(_str('first_home_type_tendency')))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.prMultipleHomes, _sc('multiple_homes_probability_pct'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.prNewPropertySoon, _sc('new_property_probability_next_24_months_pct'))),
      ]),
      if (firstWindow.isNotEmpty) ...[const SizedBox(height: 10), _timelineCard(l, l.prFirstMajorWindow, firstWindow, KColors.green)],
      if (buying.isNotEmpty) _timelineCard(l, l.prBuyingWindow, buying.first, AppColors.gold),
      if (construction.isNotEmpty) _timelineCard(l, l.prConstructionWindow, construction.first, KColors.purple),
      if (nextWindow.isNotEmpty && nextWindow['window'] != firstWindow['window']) _timelineCard(l, l.prNextOpportunity, nextWindow, KColors.blue),
      const SizedBox(height: 6),
      _pill('${l.prLifetimePropertyCount}: ${_str('lifetime_property_count_estimate')}', AppColors.gold),
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
  //  7 — INHERITANCE & FAMILY PROPERTY
  // ══════════════════════════════════════════════════════════════════
  Widget _inheritance(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.family_restroom_rounded, title: l.prInheritanceTitle, color: KColors.purple),
      Row(children: [
        Expanded(child: _statTile(l.prMaternalInheritance, _sc('maternal_inheritance_probability_pct'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.prPaternalInheritance, _sc('paternal_inheritance_probability_pct'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.prAncestralProperty, _sc('ancestral_property_receipt_probability_pct'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.prFamilyDisputeRisk, _sc('family_property_disputes_risk_pct'))),
      ]),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_str('inheritance_timing_band').isNotEmpty) _pill('${l.prInheritanceTiming}: ${_titleCase(_str('inheritance_timing_band'))}', AppColors.gold),
        if (_str('inheritance_type_tendency').isNotEmpty) _pill('${l.prInheritanceType}: ${_titleCase(_str('inheritance_type_tendency'))}', KColors.blue),
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — LAND, INVESTMENT & GLOBAL PROPERTY
  // ══════════════════════════════════════════════════════════════════
  Widget _landInvestment(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.landscape_rounded, title: l.prLandInvestTitle, color: KColors.green),
      Row(children: [
        Expanded(child: _statTile(l.prLandOwnership, _sc('land_ownership_probability_pct'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.prPropertyInvestor, _sc('property_as_investment_affinity_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.prAppreciationLuck, _sc('property_appreciation_luck_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.prInvestorMindset, _sc('real_estate_investor_mindset_score'))),
      ]),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_str('land_type_affinity').isNotEmpty) _pill('${l.prLandType}: ${_titleCase(_str('land_type_affinity'))}', KColors.green),
        if (_str('rental_property_count_tendency').isNotEmpty) _pill('${l.prRentalCount}: ${_str('rental_property_count_tendency')}', KColors.blue),
        if (_sc('multiple_land_parcels_probability_pct') > 0) _pill('${l.prMultipleLand}: ${_sc('multiple_land_parcels_probability_pct').toStringAsFixed(0)}%', KColors.purple),
        if (_sc('farm_or_estate_probability_pct') > 0) _pill('${l.prFarmEstate}: ${_sc('farm_or_estate_probability_pct').toStringAsFixed(0)}%', AppColors.gold),
      ]),
      const SizedBox(height: 12),
      Text(l.prGlobalPropertyLabel, style: const TextStyle(color: AppColors.smoke, fontSize: 11, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: _statTile(l.prForeignProperty, _sc('foreign_property_probability_pct'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.prNriAffinity, _sc('nri_asset_affinity_score'))),
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — VEHICLES
  // ══════════════════════════════════════════════════════════════════
  Widget _vehicles(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.directions_car_filled_rounded, title: l.prVehiclesTitle, color: KColors.blue),
      Row(children: [
        Expanded(child: _iconTile('🚗', l.prVehicleCount, _str('number_of_vehicles_tendency'))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🏁', l.prVehicleFirstAge, _str('first_vehicle_age_band'))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🚙', l.prVehicleCategory, _titleCase(_str('preferred_vehicle_category')))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.prVehicleQuality, _sc('vehicle_ownership_quality_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.prLuxuryAffinity, _sc('luxury_vehicle_affinity_score'))),
      ]),
      const SizedBox(height: 10),
      _riskTile(l.prVehicleLossRisk, _sc('vehicle_loss_or_damage_risk_score')),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — LEGAL & RISK WATCH
  // ══════════════════════════════════════════════════════════════════
  Widget _legalRisk(AppLocalizations l) {
    final risks = _list('major_property_risks').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final protective = _list('legal_protective_factors').map((e) => e.toString()).toList();
    final chronic = _list('chronic_vulnerability_areas').map((e) => e.toString())
        .where((s) => !s.toLowerCase().contains('no structural')).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.shield_outlined, title: l.prLegalRiskTitle, color: KColors.orange),
      Wrap(spacing: 10, runSpacing: 10, children: [
        _riskChip(l.prBoundaryDisputes, _sc('boundary_disputes_risk_pct')),
        _riskChip(l.prPartitionDisputes, _sc('partition_disputes_risk_pct')),
        _riskChip(l.prTitleIssues, _sc('title_documentation_issues_risk_pct')),
        _riskChip(l.prTenantConflict, _sc('tenant_landlord_conflict_risk_pct')),
        _riskChip(l.prForcedSale, _sc('forced_sale_risk_score')),
        _riskChip(l.prPropertyDamage, _sc('property_damage_risk_score')),
      ]),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_str('insurance_priority_level').isNotEmpty) _pill('${l.prInsurancePriority}: ${_titleCase(_str('insurance_priority_level'))}', KColors.blue),
        if (_sc('asset_protection_strategy_urgency_score') > 0) _pill('${l.prProtectionUrgency}: ${_sc('asset_protection_strategy_urgency_score').toStringAsFixed(0)}%', KColors.orange),
      ]),
      if (protective.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('🛡️', l.prProtectiveFactors, protective, KColors.green)],
      if (chronic.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🔁', l.prChronicVulnerabilities, chronic, KColors.orange)],
      ...risks.map((r) {
        final desc = r['description']?.toString() ?? '';
        final mitigation = r['mitigation']?.toString() ?? '';
        if (desc.isEmpty) return const SizedBox.shrink();
        return Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: KColors.orange.withOpacity(0.05), borderRadius: BorderRadius.circular(13), border: Border.all(color: KColors.orange.withOpacity(0.18))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_cap(desc), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4)),
            if (mitigation.isNotEmpty) ...[const SizedBox(height: 5),
              Text('🛡️ $mitigation', style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.35))],
          ]));
      }),
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
  //  11 — DUE DILIGENCE CHECKLIST
  // ══════════════════════════════════════════════════════════════════
  Widget _dueDiligence(AppLocalizations l) {
    final priorities = _list('preventive_measures_priority').map((e) => e.toString()).toList();
    final checklist = _list('due_diligence_priorities').map((e) => e.toString()).toList();
    if (priorities.isEmpty && checklist.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.checklist_rounded, title: l.prDueDiligenceTitle, color: AppColors.gold),
      if (checklist.isNotEmpty) _card(child: Column(children: checklist.map((c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.check_circle_outline_rounded, size: 15, color: KColors.blue), const SizedBox(width: 8),
          Expanded(child: Text(c, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
        ]),
      )).toList())),
      if (priorities.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('📋', l.prPreventiveMeasures, priorities, KColors.orange)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  12 — IMPROVEMENT PLAN (remedies)
  // ══════════════════════════════════════════════════════════════════
  Widget _improvementPlan(AppLocalizations l) {
    final practical = _list('practical_solutions').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final planetary = _list('astrological_remedies').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.self_improvement_rounded, title: l.prImprovementTitle, color: KColors.green),
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
  //  13 — RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    double layer(String k) { final v = b[k]; return v is num ? v.toDouble() * 100 : 0; }
    final layers = <List<Object>>[
      [l.prLayerD1, layer('d1')],
      [l.prLayerD4, layer('d4')],
      [l.prLayerD16, layer('d16')],
      [l.prLayerDasha, layer('dasha')],
      [l.prLayerTransit, layer('transit')],
    ];
    final plain = _str('plain_statement');
    final disclaimer = _str('property_disclaimer').isNotEmpty ? _str('property_disclaimer') : _str('disclaimer');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.prReliabilityTitle, color: KColors.blue),
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
  //  14 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.prTopicBuying, l.prTopicInherit, l.prTopicVehicle, l.prTopicRental, l.prTopicLand, l.prTopicLegal, l.prTopicForeign, l.prTopicTiming];
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
    final q = '$topic — based on my Vedic property report for ${widget.chartName}.\n\n${_buildPrompt(_data!)}';
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
    if (s >= 75) return l.prStatusExcellent;
    if (s >= 60) return l.prStatusStrong;
    if (s >= 45) return l.prStatusModerate;
    if (s >= 30) return l.prStatusDeveloping;
    return l.prStatusChallenging;
  }
  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .where((w) => w.isNotEmpty).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── AI prompt / launch (unchanged behaviour) ──
  String _buildPrompt(Map<String, dynamic> d) {
    final name = widget.chartName;
    final overall = d['property_acquisition_capacity_score'] ?? '?';
    final verdict = d['property_life_verdict'] ?? '';
    final karmaType = d['property_karma_type'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic property & real-estate advisor. Analyze this property report for $name and provide actionable insights.

Key highlights:
- Property acquisition capacity: $overall/100
- Property karma type: $karmaType
- Property life verdict: $verdict

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the best buying/timing windows, and suggest practical next steps.''';
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
