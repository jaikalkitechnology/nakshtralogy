import 'dart:convert';
import 'package:flutter/material.dart';
import '../../widgets/desktop_center.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/kundli_names.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Business & Startup report — premium AI business-coach redesign.
///
/// Presentation only. Loads the `business` specialist
/// (`runSpecialist('business')`) unchanged and re-presents it; every score,
/// Jaimini karaka, house, divisional, yoga, timing, risk, remedy and
/// confidence value comes straight from the engine.
class BusinessReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const BusinessReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});
  @override
  State<BusinessReportScreen> createState() => _BizState();
}

class _BizState extends State<BusinessReportScreen> {
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
      final resp = await _api.runSpecialist('business', widget.chartId);
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
          Text(l.bzSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
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
    // Sections render directly (no staggered fade wrapper) — the hero is tall
    // enough that lower sections lazy-build past the viewport; an entrance
    // animation there can stay stuck at opacity 0 and blank the report.
    const gap = SizedBox(height: 18);
    return [
      _breadcrumb(l),
      const SizedBox(height: 10),
      _snapshot(l),         // 1
      gap, _whatsWorking(l),   // 2
      gap, _founderType(l),    // 3
      gap, _soulBusiness(l),   // 4
      gap, _foundation(l),     // 5
      gap, _verification(l),   // 6
      gap, _founderSkills(l),  // 7
      gap, _domains(l),        // 8
      gap, _style(l),          // 9
      gap, _partnership(l),    // 10
      gap, _funding(l),        // 11
      gap, _timeline(l),       // 12
      gap, _risks(l),          // 13
      gap, _remedies(l),       // 14
      gap, _roadmap(l),        // 15
      gap, _confidence(l),     // 16
      gap, _discussAi(l),      // 17
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.bzTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — BUSINESS SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _sc('overall_business_strength_score');
    final col = _bizColor(overall);
    final summary = _str('plain_statement').isNotEmpty ? _str('plain_statement') : _str('business_verdict_explanation');
    final gauges = <List<Object>>[
      [l.bzEntrepreneurship, _sc('entrepreneurship_potential_score')],
      [l.bzVenture, _sc('venture_success_potential_score')],
      [l.bzWealth, _sc('wealth_generation_through_business_score')],
      [l.bzRiskAppetite, _sc('risk_taking_capacity_score')],
      [l.bzLongevity, _sc('business_longevity_score')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.bzBusinessPotential.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
          child: Text(_potentialStatus(overall, l), style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
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
    if (_data?['lakshmi_yoga_present'] == true) out.add(l.bzChipWealthMagnet);
    if (_data?['dhana_yoga_present'] == true) out.add(l.bzChipMoneyYoga);
    if (_data?['raja_yoga_present'] == true) out.add(l.bzChipLeadership);
    if (_sc('partnership_viability_score') >= 60) out.add(l.bzChipPartnerFit);
    if (_sc('gains_potential_score') >= 60) out.add(l.bzChipGains);
    if (_sc('investor_attraction_score') >= 60) out.add(l.bzChipInvestor);
    out.add(l.bzChipFounder);
    return out.toSet().take(6).toList();
  }

  Widget _miniGauge(String label, double score) {
    final col = _bizColor(score);
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
  //  2 — WHAT'S WORKING FOR YOU
  // ══════════════════════════════════════════════════════════════════
  Widget _whatsWorking(AppLocalizations l) {
    final gifts = _list('business_gift_yogas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final classics = <List<Object>>[
      ['Dhana Yoga', _data?['dhana_yoga_present'] == true],
      ['Lakshmi Yoga', _data?['lakshmi_yoga_present'] == true],
      ['Raja Yoga', _data?['raja_yoga_present'] == true],
      ['Budha Aditya', _data?['budha_aditya_yoga_present'] == true],
      ['Chandra Mangal', _data?['chandra_mangal_yoga_present'] == true],
    ];
    final theme = _map('core_business_theme');
    final themeDesc = theme['description']?.toString() ?? '';
    if (gifts.isEmpty && !classics.any((c) => c[1] == true) && themeDesc.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.emoji_objects_rounded, title: l.bzWhatsWorking, subtitle: l.bzWhatsWorkingSub, color: AppColors.gold),
      if (themeDesc.isNotEmpty) Container(
        margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.purple.withOpacity(0.14), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: KColors.purple.withOpacity(0.28))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('✨', style: TextStyle(fontSize: 16)), const SizedBox(width: 9),
          Expanded(child: Text(_cap(themeDesc), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.45))),
        ])),
      ...gifts.map((m) => Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: KColors.green.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.green.withOpacity(0.2))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.auto_awesome_rounded, size: 17, color: KColors.green), const SizedBox(width: 10),
          Expanded(child: Text(_titleCase(m['name']?.toString() ?? ''), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.4, fontWeight: FontWeight.w700))),
        ]),
      )),
      const SizedBox(height: 4),
      Text(l.bzClassicYogas, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
      const SizedBox(height: 7),
      Wrap(spacing: 6, runSpacing: 6, children: classics.map((c) {
        final present = c[1] as bool;
        final cc = present ? KColors.green : AppColors.smoke;
        return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: cc.withOpacity(present ? 0.12 : 0.05), borderRadius: BorderRadius.circular(10), border: Border.all(color: cc.withOpacity(present ? 0.4 : 0.16))),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(present ? '✓' : '·', style: TextStyle(color: cc, fontSize: 12, fontWeight: FontWeight.w800)), const SizedBox(width: 6),
            Text(c[0] as String, style: TextStyle(color: cc, fontSize: 10.5, fontWeight: present ? FontWeight.w700 : FontWeight.w500)),
          ]));
      }).toList()),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  3 — YOUR FOUNDER TYPE
  // ══════════════════════════════════════════════════════════════════
  Widget _founderType(AppLocalizations l) {
    final arch = _titleCase(_str('founder_archetype'));
    if (arch.isEmpty) return const SizedBox.shrink();
    final verdict = _str('overall_business_verdict');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.rocket_launch_rounded, title: l.bzFounderType, color: KColors.purple),
      Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.purple.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.purple.withOpacity(0.3))),
        child: Column(children: [
          const Text('🚀', style: TextStyle(fontSize: 34)),
          const SizedBox(height: 8),
          Text(arch, style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          if (verdict.isNotEmpty) ...[const SizedBox(height: 8),
            Text('🤖 ${_titleCase(verdict)}', style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5), textAlign: TextAlign.center)],
        ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — SOUL & BUSINESS PURPOSE
  // ══════════════════════════════════════════════════════════════════
  Widget _soulBusiness(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final soul = _str('atmakaraka_planet');
    final biz = _str('amatyakaraka_planet');
    final align = _sc('business_direction_strength_score');
    final col = _bizColor(align);
    final alignText = align >= 60 ? l.bzAlignStrong : align >= 40 ? l.bzAlignModerate : l.bzAlignLow;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.self_improvement_rounded, title: l.bzSoulBusiness, color: KColors.purple),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _planetCard('🕉️', l.bzSoulPlanet, KundliNames.planet(soul, loc), '', KColors.purple)),
        const SizedBox(width: 10),
        Expanded(child: _planetCard('💼', l.bzBusinessPlanet, KundliNames.planet(biz, loc), _str('amatyakaraka_business_direction'), KColors.blue)),
      ]),
      const SizedBox(height: 12),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(l.bzDirectionStrength, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w800))),
          Text('${align.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 18, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: (align / 100).clamp(0, 1), minHeight: 7, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
        const SizedBox(height: 10),
        Text('🤖 $alignText', style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.4)),
      ])),
      _advanced(l, [
        '${l.bzTechAtmakaraka}: ${KundliNames.planet(soul, loc)}',
        '${l.bzTechAmatyakaraka}: ${KundliNames.planet(biz, loc)} · ${l.crDignity}: ${_str('amatyakaraka_dignity')}',
        'D10 ${l.crDignity}: ${_str('amatyakaraka_d10_dignity')} · ${l.crHouseLabel}: ${_sc('amatyakaraka_house').toStringAsFixed(0)}',
        'Nakshatra: ${_str('amatyakaraka_nakshatra')} (${_str('amatyakaraka_nakshatra_deity')})',
      ]),
    ]);
  }

  Widget _planetCard(String emoji, String label, String planet, String meaning, Color c) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(emoji, style: const TextStyle(fontSize: 16)), const SizedBox(width: 6),
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)))]),
      const SizedBox(height: 6),
      Text(planet, style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.w800)),
      if (meaning.isNotEmpty) ...[const SizedBox(height: 4),
        Text(_cap(meaning), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.35))],
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  5 — BUSINESS FOUNDATION
  // ══════════════════════════════════════════════════════════════════
  Widget _foundation(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final h10 = _sc('tenth_house_strength_score');
    final h11 = _sc('eleventh_house_strength_score');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.foundation_rounded, title: l.bzFoundation, color: KColors.blue),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _houseCard(l, '🏛️', l.bzCareerHouse, _str('tenth_house_sign_name'), KundliNames.planet(_str('tenth_lord_planet'), loc), h10)),
        const SizedBox(width: 10),
        Expanded(child: _houseCard(l, '💰', l.bzGainsHouse, _str('eleventh_house_sign_name'), KundliNames.planet(_str('eleventh_lord_planet'), loc), h11)),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _iconTile('📈', l.bzGainsPotential, '${_sc('gains_potential_score').toStringAsFixed(0)}%', color: _bizColor(_sc('gains_potential_score')))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🤝', l.bzNetwork, '${_sc('network_strength_score').toStringAsFixed(0)}%', color: _bizColor(_sc('network_strength_score')))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🛡️', l.bzRecovery, '${_sc('failure_recovery_capacity_score').toStringAsFixed(0)}%', color: _bizColor(_sc('failure_recovery_capacity_score')))),
      ]),
      _advanced(l, [
        '${l.bzCareerHouse} ${l.crDignity}: ${_str('tenth_lord_dignity')} · D10: ${_str('tenth_lord_d10_dignity')}',
        '${l.bzGainsHouse} ${l.crDignity}: ${_str('eleventh_lord_dignity')} · D11: ${_str('eleventh_lord_d11_dignity')}',
        '${l.bzGainsHouse} ${l.crHouseLabel}: ${_sc('eleventh_lord_house').toStringAsFixed(0)}',
      ]),
    ]);
  }

  Widget _houseCard(AppLocalizations l, String emoji, String label, String sign, String lord, double strength) {
    final col = _bizColor(strength);
    return Container(padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: col.withOpacity(0.07), borderRadius: BorderRadius.circular(16), border: Border.all(color: col.withOpacity(0.22))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Text(emoji, style: const TextStyle(fontSize: 15)), const SizedBox(width: 6),
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9.5, fontWeight: FontWeight.w700)))]),
        const SizedBox(height: 8),
        Text(sign, style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
        Text('${l.bzLord}: $lord', style: const TextStyle(color: AppColors.parchment, fontSize: 11)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (strength / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col)))),
          const SizedBox(width: 8),
          Text('${strength.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 12, fontWeight: FontWeight.w800)),
        ]),
      ]));
  }

  Widget _iconTile(String emoji, String label, String value, {Color? color}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 17)), const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w600)),
      Text(value, style: TextStyle(color: color ?? AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  6 — CROSS-CHART VERIFICATION
  // ══════════════════════════════════════════════════════════════════
  Widget _verification(AppLocalizations l) {
    final d10 = _map('d10_validation'), d11 = _map('d11_validation'), d9 = _map('d9_validation'), d60 = _map('d60_validation');
    final standing = (d10['d10_overall_business_standing']?.toString() ?? '').toLowerCase();
    final d10Score = standing.contains('strong') ? 75.0 : standing.contains('moderate') ? 50.0 : 30.0;
    final d11Score = (d11['d11_gains_quality_score'] is num ? d11['d11_gains_quality_score'] as num : null)?.toDouble() ?? 0;
    final d9Score = (d9['d9_dharmic_business_score'] is num ? d9['d9_dharmic_business_score'] as num : null)?.toDouble() ?? 0;
    final d60Score = (d60['d60_past_life_business_capital_score'] is num ? d60['d60_past_life_business_capital_score'] as num : null)?.toDouble() ?? 0;
    final cards = <Widget>[];
    if (d10.isNotEmpty) cards.add(_chartCard(l, l.bzD10, d10Score, d10['d10_primary_venture_signature']?.toString() ?? '',
      ['D10 10L: ${d10['d10_10_lord_dignity']}', 'AmK: ${d10['d10_amatyakaraka_dignity']} · DK: ${d10['d10_darakaraka_dignity']}']));
    if (d11.isNotEmpty) cards.add(_chartCard(l, l.bzD11, d11Score, d11['d11_labhamsha_signature']?.toString() ?? '',
      ['D11 11L: ${d11['d11_11_lord_dignity']}', 'Jupiter: ${d11['d11_jupiter_dignity']} · Venus: ${d11['d11_venus_dignity']}']));
    if (d9.isNotEmpty) cards.add(_chartCard(l, l.bzD9, d9Score, d9['d9_business_dharma_signature']?.toString() ?? '',
      ['D9 10L: ${d9['d9_10_lord_dignity']}', 'AmK: ${d9['d9_amatyakaraka_dignity']}']));
    if (d60.isNotEmpty) cards.add(_chartCard(l, l.bzD60, d60Score, d60['d60_business_past_life_signature']?.toString() ?? '',
      ['D60 AmK: ${d60['d60_amatyakaraka_dignity']}']));
    if (cards.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_rounded, title: l.bzVerification, color: KColors.green),
      ...cards,
    ]);
  }

  Widget _chartCard(AppLocalizations l, String title, double score, String explain, List<String> tech) {
    final col = _bizColor(score);
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
  //  7 — FOUNDER SKILLS
  // ══════════════════════════════════════════════════════════════════
  Widget _founderSkills(AppLocalizations l) {
    final rows = <List<Object>>[
      [l.bzSkillStrategy, _sc('strategic_thinking_score')],
      [l.bzSkillExecution, _sc('execution_capacity_score')],
      [l.bzSkillPeople, _sc('people_management_score')],
      [l.bzSkillSales, _sc('sales_persuasion_score')],
      [l.bzSkillFinance, _sc('financial_acumen_score')],
      [l.bzSkillOps, _sc('operational_discipline_score')],
    ].where((r) => (r[1] is num ? (r[1] as num).toDouble() : 0.0) > 0).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    rows.sort((a, b) => (b[1] is num ? (b[1] as num).toDouble() : 0.0).compareTo(a[1] as double));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.psychology_rounded, title: l.bzFounderSkills, color: KColors.blue),
      ...List.generate(rows.length, (idx) {
        final r = rows[idx];
        final score = r[1] as double;
        final isBest = idx == 0;
        final col = isBest ? KColors.green : _bizColor(score);
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: col.withOpacity(isBest ? 0.10 : 0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(isBest ? 0.4 : 0.18))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(r[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700))),
              if (isBest) Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: KColors.green.withOpacity(0.18), borderRadius: BorderRadius.circular(6)),
                child: Text('⭐ ${l.bzTopSkill}', style: const TextStyle(color: KColors.green, fontSize: 8.5, fontWeight: FontWeight.w800))),
              Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 15, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 7),
            ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — BEST BUSINESS FIELDS
  // ══════════════════════════════════════════════════════════════════
  Widget _domains(AppLocalizations l) {
    final list = _list('recommended_business_types').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (list.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.storefront_rounded, title: l.bzDomains, subtitle: l.bzDomainsSub, color: AppColors.gold),
      ...List.generate(list.length > 6 ? 6 : list.length, (i) {
        final item = list[i];
        final domain = _titleCase(item['domain']?.toString() ?? '');
        final score = (item['score'] is num ? item['score'] as num : null)?.toDouble() ?? 0;
        final isTop = i == 0;
        final col = isTop ? AppColors.gold : _bizColor(score);
        return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: col.withOpacity(isTop ? 0.10 : 0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(isTop ? 0.4 : 0.18))),
          child: Row(children: [
            Container(width: 26, height: 26, alignment: Alignment.center,
              decoration: BoxDecoration(color: col.withOpacity(0.18), borderRadius: BorderRadius.circular(8)),
              child: Text('${i + 1}', style: TextStyle(color: col, fontSize: 12, fontWeight: FontWeight.w800))),
            const SizedBox(width: 12),
            Expanded(child: Text(domain, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w700))),
            const SizedBox(width: 8),
            Text('${score.toStringAsFixed(0)}', style: TextStyle(color: col, fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(width: 2),
            Text(l.bzFit, style: TextStyle(color: col.withOpacity(0.7), fontSize: 8, fontWeight: FontWeight.w700)),
          ]));
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — BUSINESS STYLE
  // ══════════════════════════════════════════════════════════════════
  Widget _style(AppLocalizations l) {
    final rows = <List<Object>>[
      ['🏭', l.bzStyleService, _str('service_vs_product_orientation')],
      ['🎯', l.bzStyleMarket, _str('b2b_vs_b2c_signature')],
      ['⚙️', l.bzStyleTech, _str('tech_vs_traditional_signature')],
      ['🧭', l.bzStyleLeadership, _str('leadership_style')],
      ['🤝', l.bzStylePartnership, _str('solo_vs_partnership_signature')],
    ].where((r) => (r[2] as String).isNotEmpty).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.tune_rounded, title: l.bzBusinessStyleHdr, color: KColors.purple),
      _card(child: Column(children: rows.map((r) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(r[0] as String, style: const TextStyle(fontSize: 15)), const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r[1] as String, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(_cap(r[2] as String), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.35)),
          ])),
        ]),
      )).toList())),
      _advanced(l, [
        '${l.bzWhereBuild}: ${_str('domestic_vs_international_business_signature')}',
        '${l.bzExpansion}: ${_str('expansion_geography_signature')}',
        '${l.bzSetup}: ${_str('location_setup_signature')}',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — PARTNERSHIP & TEAM
  // ══════════════════════════════════════════════════════════════════
  Widget _partnership(AppLocalizations l) {
    final partnerSig = _str('darakaraka_business_partner_signature');
    final cofounder = _str('ideal_cofounder_archetype');
    final gauges = <List<Object>>[
      [l.bzPartnerViability, _sc('partnership_viability_score')],
      [l.bzTeamBuilding, _sc('team_building_capacity_score')],
    ];
    if (partnerSig.isEmpty && cofounder.isEmpty && gauges.every((g) => (g[1] is num ? (g[1] as num).toDouble() : 0.0) == 0)) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.groups_rounded, title: l.bzPartnership, color: KColors.blue),
      if (cofounder.isNotEmpty) Container(
        margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.blue.withOpacity(0.14), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: KColors.blue.withOpacity(0.28))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.bzIdealCofounder, style: const TextStyle(color: KColors.blue, fontSize: 10.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(_titleCase(cofounder), style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w800)),
          if (partnerSig.isNotEmpty) ...[const SizedBox(height: 6),
            Text(_cap(partnerSig), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
        ])),
      Row(children: gauges.map((g) => Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: _meterTile(g[0] as String, g[1] as double)))).toList()),
      _advanced(l, [
        '${l.bzTechDarakaraka}: ${KundliNames.planet(_str('darakaraka_planet'), Localizations.localeOf(context))} · ${l.crDignity}: ${_str('darakaraka_dignity')}',
        '${l.bzCofounderFit}: ${_str('cofounder_compatibility_signature')}',
        '${l.bzAdvisorNetwork}: ${_str('advisor_network_signature')}',
      ]),
    ]);
  }

  Widget _meterTile(String label, double score) {
    final col = _bizColor(score);
    return Container(padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.18))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Row(children: [
          Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 16, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
      ]));
  }

  // ══════════════════════════════════════════════════════════════════
  //  11 — FUNDING & MONEY
  // ══════════════════════════════════════════════════════════════════
  Widget _funding(AppLocalizations l) {
    final path = _str('bootstrap_vs_funded_signature');
    final gauges = <List<Object>>[
      [l.bzInvestorAttract, _sc('investor_attraction_score')],
      [l.bzFamilyBacking, _sc('family_wealth_backing_score')],
      [l.bzHybridViability, _sc('hybrid_career_business_viability_score')],
      [l.bzFallback, _sc('employment_as_fallback_strength_score')],
    ];
    if (path.isEmpty && gauges.every((g) => (g[1] is num ? (g[1] as num).toDouble() : 0.0) == 0)) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.savings_rounded, title: l.bzFunding, color: KColors.green),
      if (path.isNotEmpty) Container(
        margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.green.withOpacity(0.14), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: KColors.green.withOpacity(0.28))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.bzRecommendedPath, style: const TextStyle(color: KColors.green, fontSize: 10.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(_cap(path), style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w700, height: 1.35)),
        ])),
      Wrap(spacing: 10, runSpacing: 10, children: gauges.where((g) => (g[1] is num ? (g[1] as num).toDouble() : 0.0) > 0).map((g) =>
        SizedBox(width: (MediaQuery.of(context).size.width - 32 - 10) / 2, child: _meterTile(g[0] as String, g[1] as double))).toList()),
      _advanced(l, ['${l.bzDebtStyle}: ${_str('debt_risk_tolerance_signature')}']),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  12 — BUSINESS TIMELINE
  // ══════════════════════════════════════════════════════════════════
  Widget _timeline(AppLocalizations l) {
    final launch = _list('entrepreneurship_launch_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final scale = _list('scale_growth_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final cards = <Widget>[];
    final phase = _str('current_business_phase_signature');
    if (phase.isNotEmpty) cards.add(_timelineCard(l, l.bzCurrentPhase, '', '', phase, KColors.green));
    for (final m in launch.take(2)) {
      cards.add(_timelineCard(l, l.bzLaunchWindow, m['window']?.toString() ?? '', m['dasha']?.toString() ?? '', m['note']?.toString() ?? '', KColors.blue));
    }
    for (final m in scale.take(1)) {
      cards.add(_timelineCard(l, l.bzScaleWindow, m['window']?.toString() ?? '', m['dasha']?.toString() ?? '', m['note']?.toString() ?? '', AppColors.gold));
    }
    final peak = _str('peak_business_age_range');
    if (peak.isNotEmpty) cards.add(_timelineCard(l, l.bzPeakAge, peak, '', _str('optimal_venture_start_signature'), KColors.purple));
    if (cards.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.timeline_rounded, title: l.bzTimeline, color: AppColors.gold),
      ...cards,
    ]);
  }

  Widget _timelineCard(AppLocalizations l, String title, String window, String dasha, String note, Color col) {
    final loc = Localizations.localeOf(context);
    final planet = dasha.isNotEmpty ? KundliNames.planet(dasha.split(' ').first, loc) : '';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 13, 13, 13),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.28))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: col, shape: BoxShape.circle, border: Border.all(color: col.withOpacity(0.35), width: 3))),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(color: col, fontSize: 12.5, fontWeight: FontWeight.w800))),
          if (window.isNotEmpty) Flexible(child: Text(window, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.right)),
        ]),
        if (planet.isNotEmpty) ...[const SizedBox(height: 4),
          Text('🪐 $planet', style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700))],
        if (note.isNotEmpty) ...[const SizedBox(height: 6),
          Text(_cap(note), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))],
        if (dasha.isNotEmpty) _advanced(l, ['${l.crViewDasha}: $dasha']),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  13 — CHALLENGES TO WATCH
  // ══════════════════════════════════════════════════════════════════
  Widget _risks(AppLocalizations l) {
    final rows = <List<Object>>[
      [l.bzRiskFinancial, _sc('financial_loss_risk_score'), l.bzFinancialExp, l.bzFinancialFix],
      [l.bzRiskBurnout, _sc('burnout_risk_score'), l.bzBurnoutExp, l.bzBurnoutFix],
      [l.bzRiskTeam, _sc('team_conflict_risk_score'), l.bzTeamExp, l.bzTeamFix],
      [l.bzRiskLegal, _sc('legal_regulatory_risk_score'), l.bzLegalExp, l.bzLegalFix],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.shield_outlined, title: l.bzChallenges, color: KColors.orange),
      ...rows.map((r) {
        final score = r[1] as double;
        final col = _riskColor(score);
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: col.withOpacity(0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.18))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(r[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700))),
              Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 6),
            ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
            const SizedBox(height: 8),
            Text(r[2] as String, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.35)),
            const SizedBox(height: 6),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('🛡️ ${l.crPrevention}: ', style: const TextStyle(color: KColors.green, fontSize: 10.5, fontWeight: FontWeight.w800)),
              Expanded(child: Text(r[3] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.35))),
            ]),
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  14 — IMPROVEMENT PLAN (remedies)
  // ══════════════════════════════════════════════════════════════════
  Widget _remedies(AppLocalizations l) {
    final astro = _list('astrological_remedies').map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    final practical = _list('practical_solutions').map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    if (astro.isEmpty && practical.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.spa_rounded, title: l.bzImprovementPlan, color: KColors.green),
      if (practical.isNotEmpty) ...[
        _catLabel('🎯', l.crCatPractical, KColors.blue),
        ...practical.map((s) => _remedyCard('', s, KColors.blue)),
      ],
      if (astro.isNotEmpty) ...[
        const SizedBox(height: 6),
        _catLabel('🕉️', l.crCatPlanetary, KColors.purple),
        ...astro.map((s) => _remedyCard('', s, KColors.purple)),
      ],
    ]);
  }

  Widget _catLabel(String emoji, String t, Color c) => Padding(padding: const EdgeInsets.only(bottom: 8, top: 2),
    child: Row(children: [Text(emoji, style: const TextStyle(fontSize: 13)), const SizedBox(width: 6),
      Text(t, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800))]));

  Widget _remedyCard(String title, String body, Color c) => Container(
    margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(c == KColors.purple ? Icons.self_improvement_rounded : Icons.check_circle_outline_rounded, size: 16, color: c),
      const SizedBox(width: 10),
      Expanded(child: Text(_cap(body), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45))),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  15 — GROWTH ROADMAP
  // ══════════════════════════════════════════════════════════════════
  Widget _roadmap(AppLocalizations l) {
    final avoid = _list('low_affinity_business_domains').map((e) => _titleCase(e.toString())).where((s) => s.isNotEmpty).join(' · ');
    final rows = <List<String>>[
      ['🎯', l.bzBestDirection, _cap(_str('primary_business_direction_recommendation'))],
      ['🧱', l.bzStrategy, _cap(_str('venture_integration_strategy'))],
      ['🏆', l.bzTopFields, _list('top_3_business_domains').map((e) => _titleCase(e.toString())).join(' · ')],
      ['⚖️', l.bzEmploymentPath, _cap(_str('employment_vs_business_signature'))],
      ['⚠️', l.fdAvoid, avoid],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.map_rounded, title: l.bzRoadmap, subtitle: l.bzRoadmapSub, color: KColors.purple),
      _card(child: Column(children: rows.where((r) => r[2].isNotEmpty).map((r) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(r[0], style: const TextStyle(fontSize: 15)), const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r[1], style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(r[2], style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4)),
          ])),
        ]),
      )).toList())),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  16 — PREDICTION RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _confidence(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    double layer(String k) { final v = b[k]; if (v is Map && v['strength'] is num) return (v['strength'] is num ? v['strength'] as num : 0).toDouble(); return 0; }
    final layers = <List<Object>>[
      [l.bzLayerBirth, layer('d1')],
      [l.bzLayerNavamsa, layer('d9')],
      [l.bzLayerDashamsa, layer('d10')],
      [l.bzLayerLabhamsa, layer('d11')],
      [l.bzLayerShashtiamsa, layer('d60')],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.bzReliability, color: KColors.blue),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          KStars(filled: kStars(pct), size: 20, color: AppColors.gold), const Spacer(),
          Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 4),
        Text(band, style: const TextStyle(color: KColors.green, fontSize: 13, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Text(l.crReliabilityExplain, style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5)),
        _advanced(l, null, customTitle: l.crChartLayers, customChild: Column(children: layers.where((la) => (la[1] is num ? (la[1] as num).toDouble() : 0.0) > 0).map((la) {
          final v = la[1] as double;
          return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
            SizedBox(width: 130, child: Text(la[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(_bizColor(v))))),
            const SizedBox(width: 8),
            Text('${v.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
          ]));
        }).toList())),
      ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  17 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.bzTopicStart, l.bzTopicIdea, l.bzTopicPartner, l.bzTopicFunding, l.bzTopicScale, l.bzTopicRisk, l.bzTopicJob, l.bzTopicTiming];
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
    final q = '$topic — based on my Vedic business report for ${widget.chartName}.\n\n${_buildPrompt(_data!)}';
    Clipboard.setData(ClipboardData(text: q));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.crTopicCopied), duration: const Duration(seconds: 2)));
  }

  // ══════════════════════════════════════════════════════════════════
  //  shared widgets / helpers
  // ══════════════════════════════════════════════════════════════════
  Widget _card({required Widget child}) => Container(padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.06))), child: child);

  Widget _advanced(AppLocalizations l, List<String>? lines, {String? customTitle, Widget? customChild}) {
    final valid = lines?.where((s) => s.trim().isNotEmpty && !s.trim().endsWith(': ') && !s.trim().endsWith(':')).toList() ?? const [];
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

  Color _bizColor(double s) {
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
  String _potentialStatus(double s, AppLocalizations l) {
    if (s >= 75) return l.crStatusStrong;
    if (s >= 60) return l.crStatusGood;
    if (s >= 45) return l.crStatusModerate;
    if (s >= 30) return l.crStatusDeveloping;
    return l.crStatusChallenging;
  }
  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .where((w) => w.isNotEmpty).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── AI prompt / launch (unchanged behaviour) ──
  String _buildPrompt(Map<String, dynamic> d) {
    final name = widget.chartName;
    final overall = d['overall_business_strength_score'] ?? '?';
    final archetype = d['founder_archetype'] ?? '';
    final verdict = d['overall_business_verdict'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic business advisor. Analyze this business report for $name and provide actionable insights.

Key highlights:
- Overall business strength: $overall/100
- Founder archetype: $archetype
- Business verdict: $verdict

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the most important timing windows, and suggest practical next steps.''';
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
