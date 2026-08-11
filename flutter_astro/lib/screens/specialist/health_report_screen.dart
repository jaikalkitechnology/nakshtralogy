import 'dart:convert';
import 'package:flutter/material.dart';
import '../../widgets/desktop_center.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Health & Wellness report — premium AI health-coach redesign.
///
/// Presentation only. Loads the `health` specialist (`runSpecialist('health')`)
/// unchanged and re-presents it; every score, dosha, yoga, vulnerability,
/// timing window, remedy and confidence value comes straight from the engine.
/// This is astrological tendency-analysis, never medical diagnosis — the
/// engine's own disclaimer is always surfaced verbatim.
class HealthReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const HealthReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});
  @override
  State<HealthReportScreen> createState() => _HealthState();
}

class _HealthState extends State<HealthReportScreen> {
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
      final resp = await _api.runSpecialist('health', widget.chartId);
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
  String _flex(String k) {
    final v = _data?[k];
    if (v is String) return v;
    if (v is List && v.isNotEmpty) return v.map((e) => e.toString()).join(' · ');
    return '';
  }

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
          Text(l.hwSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
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
      gap, _constitution(l),     // 2
      gap, _bodyMap(l),          // 3
      gap, _yogas(l),            // 4
      gap, _bodyAreas(l),        // 5
      gap, _categories(l),       // 6
      gap, _mental(l),           // 7
      gap, _timeline(l),         // 8
      gap, _lifestyle(l),        // 9
      gap, _specialTopics(l),    // 10
      gap, _challenges(l),       // 11
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
    Flexible(child: Text(l.hwTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — HEALTH SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _sc('vitality_score');
    final col = _col(overall);
    final theme = _map('core_health_theme');
    final summary = theme['explanation']?.toString().isNotEmpty == true
        ? theme['explanation'].toString()
        : (_str('overall_health_verdict').isNotEmpty ? _str('recommended_health_strategy') : '');
    final gauges = <List<Object>>[
      [l.hwOverallVitality, overall],
      [l.hwImmunity, _sc('immunity_strength_score')],
      [l.hwRecovery, _sc('recovery_capacity_score')],
      [l.hwMentalWellness, _sc('mental_wellness_strength_score')],
      [l.hwStressTolerance, _sc('stress_tolerance_score')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.hwSnapshotHeader.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
    if (_sc('immunity_strength_score') >= 60) out.add(l.hwChipImmunity);
    if (_sc('recovery_capacity_score') >= 65) out.add(l.hwChipRecovery);
    if (_sc('mental_wellness_strength_score') >= 60) out.add(l.hwChipMentalBalance);
    if (_sc('stress_tolerance_score') >= 60) out.add(l.hwChipStressResilience);
    if (_sc('fertility_indicator_score') >= 65) out.add(l.hwChipFertility);
    if (_sc('work_life_balance_health_score') >= 65) out.add(l.hwChipWorkLife);
    if (_sc('addiction_vulnerability_score') <= 35) out.add(l.hwChipLowAddiction);
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
  //  2 — YOUR BODY TYPE (AYURVEDIC CONSTITUTION)
  // ══════════════════════════════════════════════════════════════════
  Widget _constitution(AppLocalizations l) {
    final type = _str('constitutional_type');
    final dominant = _str('dominant_dosha');
    final secondary = _str('secondary_dosha');
    final notes = _str('ayurvedic_body_type_notes');
    if (type.isEmpty) return const SizedBox.shrink();
    const colors = {'vata': KColors.blue, 'pitta': KColors.orange, 'kapha': KColors.green};
    final c = colors[dominant.toLowerCase()] ?? AppColors.gold;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.spa_rounded, title: l.hwConstitutionTitle, subtitle: l.hwConstitutionSubtitle, color: c),
      Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [c.withOpacity(0.16), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: c.withOpacity(0.3))),
        child: Column(children: [
          Text(_titleCase(type), style: TextStyle(color: c, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: [
            _pill('${l.hwDominantDosha}: ${_titleCase(dominant)}', c),
            if (secondary.isNotEmpty) _pill('${l.hwSecondaryDosha}: ${_titleCase(secondary)}', AppColors.smoke),
          ]),
          if (notes.isNotEmpty) ...[const SizedBox(height: 10),
            Text(_cap(notes), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5), textAlign: TextAlign.center)],
        ])),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _iconTile('🪐', l.hwPrimaryKaraka, _str('primary_health_karaka'))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('💪', l.hwStrongestSystem, _str('strongest_body_system'))),
      ]),
      const SizedBox(height: 10),
      _iconTile('🌱', l.hwWeakestSystem, _str('weakest_body_system')),
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
  //  3 — YOUR BODY'S PLANETARY MAP
  // ══════════════════════════════════════════════════════════════════
  Widget _bodyMap(AppLocalizations l) {
    final map = _map('karaka_body_map');
    if (map.isEmpty) return const SizedBox.shrink();
    final entries = map.entries.toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.hub_rounded, title: l.hwBodyMapTitle, subtitle: l.hwBodyMapSubtitle, color: KColors.purple),
      _card(child: Column(children: entries.map((e) {
        final info = e.value is Map ? (e.value as Map).cast<String, dynamic>() : <String, dynamic>{};
        final v = (info['strength'] is num ? info['strength'] as num : null)?.toDouble() ?? 0;
        final system = info['body_system']?.toString() ?? '';
        final c = _col(v);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
          SizedBox(width: 62, child: Text(e.key.toString(), style: TextStyle(color: c, fontSize: 11.5, fontWeight: FontWeight.w700))),
          Expanded(child: Text(_cap(system), style: const TextStyle(color: AppColors.parchment, fontSize: 10.5), maxLines: 1, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 8),
          SizedBox(width: 60, child: ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
          const SizedBox(width: 8),
          SizedBox(width: 28, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w800))),
        ]));
      }).toList())),
      _advanced(l, entries.map((e) {
        final info = e.value is Map ? (e.value as Map).cast<String, dynamic>() : <String, dynamic>{};
        return '${e.key}: ${info['dignity'] ?? ''}';
      }).toList()),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — HEALTH PATTERNS (YOGAS)
  // ══════════════════════════════════════════════════════════════════
  Widget _yogas(AppLocalizations l) {
    final creating = _list('active_disease_creating_yogas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final protective = _list('active_protective_yogas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (creating.isEmpty && protective.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.auto_awesome_rounded, title: l.hwYogaTitle, subtitle: l.hwYogaSubtitle, color: AppColors.gold),
      if (protective.isNotEmpty) ...[
        _catLabel('🛡️', l.protectiveLabel, KColors.green),
        ...protective.take(6).map((m) => _yogaRow(m['name']?.toString() ?? '', (m['score'] is num ? m['score'] as num : null)?.toDouble() ?? 0, KColors.green)),
        const SizedBox(height: 6),
      ],
      if (creating.isNotEmpty) ...[
        _catLabel('⚠️', l.hwDiseasePressureLabel, KColors.orange),
        ...creating.take(6).map((m) => _yogaRow(m['name']?.toString() ?? '', (m['score'] is num ? m['score'] as num : null)?.toDouble() ?? 0, KColors.orange)),
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
  //  5 — BODY AREAS TO WATCH
  // ══════════════════════════════════════════════════════════════════
  Widget _bodyAreas(AppLocalizations l) {
    final zones = _map('body_area_vulnerability_scores');
    if (zones.isEmpty) return const SizedBox.shrink();
    final sorted = zones.entries.where((e) => e.value is num).toList()..sort((a, b) => (b.value is num ? b.value as num : 0).compareTo(a.value as num));
    final protectedAreas = _list('protected_body_areas').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.warning_amber_rounded, title: l.hwAreasTitle, subtitle: l.hwAreasSubtitle, color: KColors.orange),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: sorted.take(12).map((e) {
        final v = (e.value is num ? e.value as num : 0).toDouble();
        final c = _riskColor(v);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
          Expanded(flex: 3, child: Text(_cap(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 11), maxLines: 2)),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
          const SizedBox(width: 8),
          SizedBox(width: 28, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700))),
        ]));
      }).toList())),
      if (protectedAreas.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('✅', l.hwProtectedAreas, protectedAreas, KColors.green)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  6 — DISEASE-CATEGORY WATCH
  // ══════════════════════════════════════════════════════════════════
  Widget _categories(AppLocalizations l) {
    final cats = _map('disease_category_susceptibility_scores');
    if (cats.isEmpty) return const SizedBox.shrink();
    final sorted = cats.entries.where((e) => e.value is num).toList()..sort((a, b) => (b.value is num ? b.value as num : 0).compareTo(a.value as num));
    final lowRisk = _list('low_risk_categories').map((e) => _titleCase(e.toString())).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.local_hospital_rounded, title: l.hwCategoriesTitle, subtitle: l.hwCategoriesSubtitle, color: KColors.red),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: sorted.take(13).map((e) {
        final v = (e.value is num ? e.value as num : 0).toDouble();
        final c = _riskColor(v);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
          Expanded(flex: 3, child: Text(_titleCase(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 11))),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
          const SizedBox(width: 8),
          SizedBox(width: 28, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700))),
        ]));
      }).toList())),
      if (lowRisk.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('🟢', l.hwLowRiskCategories, lowRisk, KColors.green)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — MENTAL & EMOTIONAL WELLNESS
  // ══════════════════════════════════════════════════════════════════
  Widget _mental(AppLocalizations l) {
    final vuln = _sc('mental_health_vulnerability_score');
    final strength = _sc('mental_wellness_strength_score');
    final stress = _sc('stress_tolerance_score');
    final regulation = _sc('emotional_regulation_capacity');
    final note = _str('mental_health_note');
    final tendencies = _list('specific_mental_tendencies').map((e) => e.toString()).toList();
    final support = _str('support_seeking_recommendation');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.psychology_rounded, title: l.hwMentalTitle, subtitle: l.hwMentalSubtitle, color: KColors.purple),
      Row(children: [
        Expanded(child: _statTile(l.hwMentalVulnerability, vuln, invert: true)),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.hwEmotionalRegulation, regulation)),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.hwStressTolerance, stress)),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🤝', l.hwSupportRec, _titleCase(support))),
      ]),
      if (note.isNotEmpty) ...[const SizedBox(height: 10),
        _card(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('🤖', style: TextStyle(fontSize: 14)), const SizedBox(width: 9),
          Expanded(child: Text(_cap(note), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.5))),
        ]))],
      if (tendencies.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('🧠', l.hwTendencies, tendencies, KColors.purple)],
    ]);
  }

  Widget _statTile(String label, double score, {bool invert = false}) {
    final col = invert ? _riskColor(score) : _col(score);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.22))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Row(children: [
          Text(score.toStringAsFixed(0), style: TextStyle(color: col, fontSize: 18, fontWeight: FontWeight.w800)),
          Text('/100', style: TextStyle(color: col.withOpacity(0.6), fontSize: 10)),
        ]),
        const SizedBox(height: 4),
        ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — HEALTH TIMELINE
  // ══════════════════════════════════════════════════════════════════
  Widget _timeline(AppLocalizations l) {
    final peakYears = _list('peak_wellness_years').map((e) => e.toString()).join(', ');
    final cautionYears = _list('health_caution_years').map((e) => e.toString()).join(', ');
    final checkupYears = _list('health_check_recommended_years').map((e) => e.toString()).join(', ');
    final recovery = _list('recovery_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final acute = _list('acute_event_risk_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final phase = _str('active_health_phase');
    final cards = <Widget>[];
    if (recovery.isNotEmpty) {
      final m = recovery.first;
      cards.add(_timelineCard(l, l.hwRecoveryWindow, m['window']?.toString() ?? '', m['dasha']?.toString() ?? '', m['note']?.toString() ?? '', KColors.green));
    }
    if (acute.isNotEmpty) {
      final m = acute.first;
      cards.add(_timelineCard(l, l.hwCautionYears, m['year']?.toString() ?? '', m['dasha']?.toString() ?? '', m['note']?.toString() ?? '', KColors.orange));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.timeline_rounded, title: l.hwTimelineTitle, subtitle: l.hwTimelineSubtitle, color: AppColors.gold),
      if (phase.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 10),
        child: _pill('${l.hwCurrentPhase}: ${_titleCase(phase)}', KColors.blue)),
      ...cards,
      if (peakYears.isNotEmpty || cautionYears.isNotEmpty || checkupYears.isNotEmpty)
        _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (peakYears.isNotEmpty) _yearRow('🌟', l.hwPeakYears, peakYears, KColors.green),
          if (cautionYears.isNotEmpty) _yearRow('⚠️', l.hwCautionYears, cautionYears, KColors.orange),
          if (checkupYears.isNotEmpty) _yearRow('🩺', l.hwCheckupYears, checkupYears, KColors.blue),
        ])),
    ]);
  }

  Widget _yearRow(String emoji, String label, String years, Color c) => Padding(padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 13)), const SizedBox(width: 8),
      SizedBox(width: 110, child: Text(label, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700))),
      Expanded(child: Text(years, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5))),
    ]));

  Widget _timelineCard(AppLocalizations l, String title, String window, String dasha, String note, Color col) {
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
  //  9 — YOUR LIFESTYLE GUIDE
  // ══════════════════════════════════════════════════════════════════
  Widget _lifestyle(AppLocalizations l) {
    final rows = <List<Object>>[
      [l.hwSleepDiscipline, _sc('sleep_discipline_impact_score')],
      [l.hwDietDiscipline, _sc('diet_discipline_impact_score')],
      [l.hwExerciseNeed, _sc('exercise_need_score')],
      [l.hwSunlightNeed, _sc('sunlight_need_score')],
      [l.hwStressSusceptibility, _sc('stress_susceptibility_score')],
      [l.hwHydrationSensitivity, _sc('hydration_sensitivity_score')],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.fitness_center_rounded, title: l.hwLifestyleTitle, subtitle: l.hwLifestyleSubtitle, color: KColors.blue),
      _card(child: Column(children: rows.map((r) {
        final score = r[1] as double;
        final c = _col(score);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
          Expanded(flex: 3, child: Text(r[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5))),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
          const SizedBox(width: 8),
          SizedBox(width: 30, child: Text(score.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700))),
        ]));
      }).toList())),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_str('social_energy_type').isNotEmpty) _pill('${l.hwSocialType}: ${_titleCase(_str('social_energy_type'))}', KColors.purple),
        if (_str('healing_speed_tendency').isNotEmpty) _pill('${l.hwHealingSpeed}: ${_titleCase(_str('healing_speed_tendency'))}', KColors.green),
        if (_str('response_to_treatment_tendency').isNotEmpty) _pill('${l.hwTreatmentResponse}: ${_titleCase(_str('response_to_treatment_tendency'))}', KColors.blue),
        if (_sc('alternative_healing_affinity_score') > 0) _pill('${l.hwAltHealing}: ${_sc('alternative_healing_affinity_score').toStringAsFixed(0)}%', AppColors.gold),
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — LIFE-STAGE & SPECIAL TOPICS
  // ══════════════════════════════════════════════════════════════════
  Widget _specialTopics(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.family_restroom_rounded, title: l.hwSpecialTitle, subtitle: l.hwSpecialSubtitle, color: KColors.gold),
      Row(children: [
        Expanded(child: _statTile(l.hwFertility, _sc('fertility_indicator_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.hwHormonalBalance, _sc('hormonal_balance_score'))),
      ]),
      const SizedBox(height: 10),
      _statTile(l.hwReproductiveStrength, _sc('reproductive_system_strength_score')),
      if (_str('reproductive_health_notes').isNotEmpty) ...[const SizedBox(height: 8),
        Text(_cap(_str('reproductive_health_notes')), style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, height: 1.4, fontStyle: FontStyle.italic))],
      const SizedBox(height: 14),
      Row(children: [
        Expanded(child: _statTile(l.hwChildhoodVuln, _sc('childhood_health_vulnerability_score'), invert: true)),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('👶', l.hwChildhoodStatus, _titleCase(_str('was_childhood_health_challenging')))),
      ]),
      if (_list('childhood_disease_tendency_areas').isNotEmpty) ...[const SizedBox(height: 8),
        _chipBlock('🧸', l.hwChildhoodStatus, _list('childhood_disease_tendency_areas').map((e) => e.toString()).toList(), KColors.blue)],
      const SizedBox(height: 14),
      Row(children: [
        Expanded(child: _statTile(l.hwAddictionVuln, _sc('addiction_vulnerability_score'), invert: true)),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.hwAddictionRecovery, _sc('recovery_from_addiction_capacity'))),
      ]),
      if (_str('addiction_support_note').isNotEmpty) ...[const SizedBox(height: 8),
        Text(_cap(_str('addiction_support_note')), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.4))],
      const SizedBox(height: 14),
      Row(children: [
        Expanded(child: _statTile(l.hwBurnoutVuln, _sc('burnout_vulnerability_score'), invert: true)),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.hwWorkLifeBalance, _sc('work_life_balance_health_score'))),
      ]),
      if (_list('stress_triggers').isNotEmpty) ...[const SizedBox(height: 8),
        _chipBlock('⚡', l.hwStressTriggers, _list('stress_triggers').map((e) => e.toString()).toList(), KColors.orange)],
      if (_list('burnout_protective_factors').isNotEmpty) ...[const SizedBox(height: 8),
        _chipBlock('🛡️', l.hwProtectiveFactors, _list('burnout_protective_factors').map((e) => e.toString()).toList(), KColors.green)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  11 — CHALLENGES TO WATCH
  // ══════════════════════════════════════════════════════════════════
  Widget _challenges(AppLocalizations l) {
    final risks = _list('major_health_risks').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final chronic = _list('chronic_vulnerability_areas').map((e) => e.toString()).toList();
    final priorities = _list('preventive_health_priorities').map((e) => e.toString()).toList();
    if (risks.isEmpty && chronic.isEmpty && priorities.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.shield_outlined, title: l.hwChallengesTitle, subtitle: l.hwChallengesSubtitle, color: KColors.orange),
      ...risks.map((r) {
        final sev = r['severity']?.toString().toLowerCase() ?? '';
        final col = sev == 'notable' ? KColors.red : sev == 'moderate' ? KColors.orange : KColors.yellow;
        final desc = r['description']?.toString() ?? '';
        final mitigation = r['mitigation']?.toString() ?? '';
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: col.withOpacity(0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.18))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(_cap(desc), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.4))),
              Container(margin: const EdgeInsets.only(left: 8), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(7)),
                child: Text(_titleCase(sev), style: TextStyle(color: col, fontSize: 9.5, fontWeight: FontWeight.w800))),
            ]),
            if (mitigation.isNotEmpty) ...[const SizedBox(height: 7),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🛡️ ${l.hwMitigation}: ', style: const TextStyle(color: KColors.green, fontSize: 10.5, fontWeight: FontWeight.w800)),
                Expanded(child: Text(mitigation, style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.35))),
              ])],
          ]),
        );
      }),
      if (chronic.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🔁', l.hwChronicAreas, chronic, KColors.orange)],
      if (priorities.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('📋', l.hwPreventivePriorities, priorities, KColors.blue)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  12 — YOUR WELLNESS PLAN (remedies)
  // ══════════════════════════════════════════════════════════════════
  Widget _improvementPlan(AppLocalizations l) {
    final practical = _list('practical_solutions').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final planetary = _list('astrological_remedies').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.self_improvement_rounded, title: l.hwImprovementTitle, subtitle: l.hwImprovementSubtitle, color: KColors.green),
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
  //  13 — RELIABILITY + MEDICAL DISCLAIMER
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    double layer(String k) { final v = b[k]; return v is num ? v.toDouble() * 100 : 0; }
    final layers = <List<Object>>[
      [l.hwLayerD1, layer('d1')],
      [l.hwLayerD6, layer('d6')],
      [l.hwLayerD30, layer('d30')],
      [l.hwLayerDasha, layer('dasha')],
      [l.hwLayerTransit, layer('transit')],
    ];
    final plain = _str('plain_statement');
    final disclaimer = _str('medical_disclaimer').isNotEmpty ? _str('medical_disclaimer') : _str('disclaimer');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.hwReliabilityTitle, color: KColors.blue),
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
            SizedBox(width: 150, child: Text(la[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(_col(v))))),
            const SizedBox(width: 8),
            Text('${v.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
          ]));
        }).toList())),
      ])),
      if (disclaimer.isNotEmpty) ...[const SizedBox(height: 10),
        Container(padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: KColors.orange.withOpacity(0.07), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.orange.withOpacity(0.22))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('⚕️', style: TextStyle(fontSize: 14)), const SizedBox(width: 9),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.hwDisclaimerLabel, style: const TextStyle(color: KColors.orange, fontSize: 11, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(disclaimer, style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.45)),
            ])),
          ]))],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  14 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.hwTopicImmunity, l.hwTopicSleep, l.hwTopicStress, l.hwTopicFertility, l.hwTopicDiet, l.hwTopicTiming, l.hwTopicMental, l.hwTopicPrevention];
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
    final q = '$topic — based on my Vedic health report for ${widget.chartName}.\n\n${_buildPrompt(_data!)}';
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
    if (s >= 28) return KColors.orange;
    if (s >= 18) return KColors.yellow;
    return KColors.green;
  }
  String _statusLabel(double s, AppLocalizations l) {
    if (s >= 75) return l.hwStatusThriving;
    if (s >= 60) return l.hwStatusGood;
    if (s >= 45) return l.hwStatusBalanced;
    if (s >= 30) return l.hwStatusNeedsCare;
    return l.hwStatusNeedsAttention;
  }
  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .where((w) => w.isNotEmpty).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── AI prompt / launch (unchanged behaviour) ──
  String _buildPrompt(Map<String, dynamic> d) {
    final name = widget.chartName;
    final overall = d['vitality_score'] ?? '?';
    final verdict = d['overall_health_verdict'] ?? '';
    final constitution = d['constitutional_type'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic health & wellness advisor. Analyze this health report for $name and provide actionable, non-medical, general-wellness insights (always recommend professional medical consultation for any real symptom).

Key highlights:
- Overall vitality: $overall/100
- Constitutional type: $constitution
- Overall verdict: $verdict

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the most supportive timing windows, and suggest practical lifestyle next steps. Always mention this is not a medical diagnosis.''';
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
