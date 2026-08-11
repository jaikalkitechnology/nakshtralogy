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

/// Love & Relationships report — premium AI love-coach redesign.
///
/// Presentation only. Loads the `love` specialist (`runSpecialist('love')`)
/// unchanged and re-presents it; every score, karaka, probability, timing
/// window, remedy and confidence value comes straight from the engine.
class LoveReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const LoveReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});
  @override
  State<LoveReportScreen> createState() => _LoveState();
}

class _LoveState extends State<LoveReportScreen> {
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
      final resp = await _api.runSpecialist('love', widget.chartId);
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
  List<String> _strs(String k) => _list(k).map((e) => e.toString()).where((s) => s.isNotEmpty).toList();

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
          Text(l.lvSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
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
    const gap = SizedBox(height: 18);
    return [
      _breadcrumb(l),
      const SizedBox(height: 10),
      _snapshot(l),          // 1
      gap, _loveStyle(l),       // 2
      gap, _lovePlanets(l),     // 3
      gap, _pathToLove(l),      // 4
      gap, _idealPartner(l),    // 5
      gap, _loveStory(l),       // 6
      gap, _commitIntimacy(l),  // 7
      gap, _emotional(l),       // 8
      gap, _timing(l),          // 9
      gap, _challenges(l),      // 10
      gap, _healing(l),         // 11
      gap, _remedies(l),        // 12
      gap, _reliability(l),     // 13
      gap, _discussAi(l),       // 14
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.lvTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — LOVE SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _sc('love_capacity_score');
    final col = _lvColor(overall);
    final summary = _str('healing_direction').isNotEmpty && _str('healing_direction').length > 20
        ? _str('healing_direction') : _str('plain_statement');
    final gauges = <List<Object>>[
      [l.lvEmotionalAvail, _sc('emotional_availability_score')],
      [l.lvAttraction, _sc('romantic_attraction_score')],
      [l.lvCommitment, _sc('commitment_readiness_score')],
      [l.lvCommunication, _sc('communication_in_love_score')],
      [l.lvFidelity, _sc('fidelity_capacity_score')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.lvLovePotential.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
          child: Text(_str('love_life_verdict').isNotEmpty ? _titleCase(_str('love_life_verdict')) : _potentialStatus(overall, l),
            style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
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
    if (_sc('fidelity_capacity_score') >= 60) out.add(l.lvChipLoyal);
    if (_sc('emotional_availability_score') >= 60) out.add(l.lvChipOpenHeart);
    if (_sc('communication_in_love_score') >= 60) out.add(l.lvChipCommunicator);
    if (_str('conflict_resolution_style').toLowerCase().contains('mature')) out.add(l.lvChipMature);
    if (_sc('emotional_intelligence_score') >= 60) out.add(l.lvChipEmotionallyWise);
    final style = _str('love_style');
    if (style.isNotEmpty) out.add(_titleCase(style));
    return out.toSet().take(6).toList();
  }

  Widget _miniGauge(String label, double score) {
    final col = _lvColor(score);
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
  //  2 — LOVE STYLE & LANGUAGES
  // ══════════════════════════════════════════════════════════════════
  Widget _loveStyle(AppLocalizations l) {
    final style = _str('love_style');
    final given = _str('primary_love_language_given');
    final received = _str('primary_love_language_received');
    final notes = _str('love_language_compatibility_notes');
    if (style.isEmpty && given.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.favorite_rounded, title: l.lvLoveStyle, color: KColors.purple),
      if (style.isNotEmpty) Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.purple.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.purple.withOpacity(0.3))),
        child: Column(children: [
          const Text('💗', style: TextStyle(fontSize: 30)),
          const SizedBox(height: 6),
          Text(_titleCase(style), style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w800)),
          if (_str('attraction_style').isNotEmpty) ...[const SizedBox(height: 4),
            Text('${l.lvAttractionStyle}: ${_titleCase(_str('attraction_style'))}', style: const TextStyle(color: AppColors.parchment, fontSize: 12))],
        ])),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _iconTile('🎁', l.lvLangGiven, _titleCase(given))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('💝', l.lvLangReceived, _titleCase(received))),
      ]),
      if (notes.isNotEmpty) ...[const SizedBox(height: 10),
        _card(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('🤖', style: TextStyle(fontSize: 13)), const SizedBox(width: 9),
          Expanded(child: Text(_cap(notes), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.45))),
        ]))],
    ]);
  }

  Widget _iconTile(String emoji, String label, String value, {Color? color}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 17)), const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w600)),
      Text(value.isEmpty ? '—' : value, style: TextStyle(color: color ?? AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  3 — YOUR LOVE PLANETS
  // ══════════════════════════════════════════════════════════════════
  Widget _lovePlanets(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final table = _map('karaka_strength_table');
    final rows = table.entries.where((e) => e.value is num).map((e) => [e.key, (e.value is num ? e.value as num : 0).toDouble()]).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    rows.sort((a, b) => (b[1] is num ? (b[1] as num).toDouble() : 0.0).compareTo(a[1] as double));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.brightness_7_rounded, title: l.lvLovePlanets, color: AppColors.gold),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _planetCard('💕', l.lvLoveKaraka, KundliNames.planet(_str('primary_love_karaka'), loc), KColors.purple)),
        const SizedBox(width: 8),
        Expanded(child: _planetCard('🌙', l.lvEmotionKaraka, KundliNames.planet(_str('emotional_karaka'), loc), KColors.blue)),
        const SizedBox(width: 8),
        Expanded(child: _planetCard('🔥', l.lvPassionKaraka, KundliNames.planet(_str('passion_karaka'), loc), KColors.orange)),
      ]),
      const SizedBox(height: 10),
      _card(child: Column(children: rows.take(6).map((r) {
        final planet = KundliNames.planet(r[0] as String, loc);
        final score = r[1] as double;
        final col = _lvColor(score);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
          SizedBox(width: 76, child: Text(planet, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w600))),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col)))),
          const SizedBox(width: 8),
          Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 11.5, fontWeight: FontWeight.w700)),
        ]));
      }).toList())),
    ]);
  }

  Widget _planetCard(String emoji, String label, String planet, Color c) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 15)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w700)),
      Text(planet.isEmpty ? '—' : planet, style: TextStyle(color: c, fontSize: 15, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  4 — YOUR PATH TO LOVE
  // ══════════════════════════════════════════════════════════════════
  Widget _pathToLove(AppLocalizations l) {
    final loveP = _sc('love_marriage_probability_pct');
    final arrP = _sc('arranged_marriage_probability_pct');
    if (loveP == 0 && arrP == 0) return const SizedBox.shrink();
    final loveBigger = loveP >= arrP;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.route_rounded, title: l.lvPathToLove, subtitle: l.lvPathSub, color: KColors.blue),
      Row(children: [
        Expanded(child: _pathCard('💘', l.lvLoveMarriage, loveP, loveBigger ? KColors.green : KColors.blue, loveBigger)),
        const SizedBox(width: 10),
        Expanded(child: _pathCard('🤝', l.lvArrangedMarriage, arrP, !loveBigger ? KColors.green : KColors.blue, !loveBigger)),
      ]),
      const SizedBox(height: 10),
      Wrap(spacing: 10, runSpacing: 10, children: [
        [l.lvParentalAccept, _sc('parental_acceptance_probability_pct')],
        [l.lvInterCaste, _sc('inter_caste_inter_religion_likelihood_pct')],
      ].map((r) => SizedBox(width: (MediaQuery.of(context).size.width - 32 - 10) / 2, child: _meterTile(r[0] as String, r[1] as double))).toList()),
    ]);
  }

  Widget _pathCard(String emoji, String label, double pct, Color c, bool best) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: c.withOpacity(best ? 0.12 : 0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(best ? 0.4 : 0.2))),
    child: Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 22)),
      const SizedBox(height: 4),
      Text('${pct.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 22, fontWeight: FontWeight.w800)),
      Text(label, style: const TextStyle(color: AppColors.parchment, fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
    ]),
  );

  Widget _meterTile(String label, double score) {
    final col = _lvColor(score);
    return Container(padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.18))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 6),
        Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
      ]));
  }

  // ══════════════════════════════════════════════════════════════════
  //  5 — YOUR IDEAL PARTNER
  // ══════════════════════════════════════════════════════════════════
  Widget _idealPartner(AppLocalizations l) {
    final traits = _strs('astrological_ideal_partner_traits');
    final priorities = _strs('compatibility_priority_order');
    final phys = _str('physical_type_preference');
    final pers = _str('personality_type_preference');
    if (traits.isEmpty && phys.isEmpty && pers.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.person_search_rounded, title: l.lvIdealPartner, color: AppColors.gold),
      if (phys.isNotEmpty || pers.isNotEmpty) _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (pers.isNotEmpty) _kvRow('🧠', l.lvPersonality, _cap(pers)),
        if (phys.isNotEmpty) _kvRow('👀', l.lvAppearance, _cap(phys)),
      ])),
      const SizedBox(height: 10),
      _chipBlock('💫', l.lvIdealTraits, traits, KColors.blue),
      _chipBlock('📋', l.lvWhatMatters, priorities.map(_titleCase).toList(), KColors.purple),
      _advanced(l, [
        if (_strs('attraction_to_archetypes').isNotEmpty) '${l.lvDrawnTo}: ${_strs('attraction_to_archetypes').map(_cap).join(', ')}',
        if (_strs('partner_dealbreakers_in_chart').isNotEmpty) '${l.lvDealbreakers}: ${_strs('partner_dealbreakers_in_chart').map(_cap).join(', ')}',
        if (_strs('what_partner_will_find_attractive_in_self').isNotEmpty) '${l.lvYourAppeal}: ${_strs('what_partner_will_find_attractive_in_self').map(_cap).join(', ')}',
      ]),
    ]);
  }

  Widget _kvRow(String emoji, String label, String value) => Padding(padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 14)), const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
        Text(value, style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.35)),
      ])),
    ]));

  Widget _chipBlock(String emoji, String title, List<String> items, Color c) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(emoji, style: const TextStyle(fontSize: 13)), const SizedBox(width: 6),
        Text(title, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800))]),
      const SizedBox(height: 7),
      Wrap(spacing: 6, runSpacing: 6, children: items.take(8).map((e) => _pill(_cap(e), c)).toList()),
    ]));
  }

  Widget _pill(String t, Color c) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: c.withOpacity(0.25))),
    child: Text(t, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w600)));

  // ══════════════════════════════════════════════════════════════════
  //  6 — YOUR LOVE STORY (history)
  // ══════════════════════════════════════════════════════════════════
  Widget _loveStory(AppLocalizations l) {
    final facts = <List<String>>[
      ['💓', l.lvFirstLove, '${_titleCase(_str('first_love_age_band'))} · ${_titleCase(_str('first_love_intensity'))}'],
      ['🔢', l.lvRelationCount, _titleCase(_str('estimated_significant_relationships_count'))],
      ['⏳', l.lvDuration, _cap(_str('average_relationship_duration_tendency'))],
      ['🌊', l.lvDepth, _titleCase(_str('emotional_depth_per_relationship'))],
      ['🔁', l.lvDatingPattern, _titleCase(_str('serial_monogamy_vs_pluralistic_signal'))],
    ].where((r) => r[2].trim().isNotEmpty && r[2].trim() != '·').toList();
    if (facts.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.auto_stories_rounded, title: l.lvLoveStory, subtitle: l.lvLoveStorySub, color: KColors.purple),
      _card(child: Column(children: facts.map((f) => _kvRow(f[0], f[1], f[2])).toList())),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — COMMITMENT & INTIMACY
  // ══════════════════════════════════════════════════════════════════
  Widget _commitIntimacy(AppLocalizations l) {
    final commit = _strs('what_makes_them_commit');
    final flee = _strs('what_makes_them_flee');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.link_rounded, title: l.lvCommitIntimacy, color: KColors.blue),
      Wrap(spacing: 10, runSpacing: 10, children: [
        [l.lvCommitReady, _sc('commitment_readiness_score')],
        [l.lvIntimacyDrive, _sc('physical_intimacy_drive_score')],
        [l.lvSensuality, _sc('sensuality_score')],
        [l.lvEmpathy, _sc('empathy_in_relationships_score')],
      ].where((r) => (r[1] is num ? (r[1] as num).toDouble() : 0.0) > 0).map((r) => SizedBox(width: (MediaQuery.of(context).size.width - 32 - 10) / 2, child: _meterTile(r[0] as String, r[1] as double))).toList()),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _iconTile('🔗', l.lvCommitStyle, _titleCase(_str('commitment_style')))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('💞', l.lvChemistry, _titleCase(_str('sexual_compatibility_style')))),
      ]),
      const SizedBox(height: 10),
      _chipBlock('💚', l.lvMakesCommit, commit, KColors.green),
      _chipBlock('🚪', l.lvMakesFlee, flee, KColors.orange),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — EMOTIONAL INTELLIGENCE
  // ══════════════════════════════════════════════════════════════════
  Widget _emotional(AppLocalizations l) {
    final rows = <List<Object>>[
      [l.lvEmotionalIQ, _sc('emotional_intelligence_score')],
      [l.lvEmpathy, _sc('empathy_in_relationships_score')],
      [l.lvCommunication, _sc('communication_in_love_score')],
    ].where((r) => (r[1] is num ? (r[1] as num).toDouble() : 0.0) > 0).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.psychology_rounded, title: l.lvEmotional, color: KColors.green),
      _card(child: Column(children: [
        ...rows.map((r) {
          final score = r[1] as double;
          final col = _lvColor(score);
          return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(r[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w600))),
              Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 13, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 5),
            ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
          ]));
        }),
        if (_str('conflict_resolution_style').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
          child: Row(children: [Text('🕊️ ${l.lvConflictStyle}: ', style: const TextStyle(color: AppColors.smoke, fontSize: 11, fontWeight: FontWeight.w700)),
            Text(_titleCase(_str('conflict_resolution_style')), style: const TextStyle(color: KColors.green, fontSize: 12, fontWeight: FontWeight.w800))])),
      ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — LOVE TIMING
  // ══════════════════════════════════════════════════════════════════
  Widget _timing(AppLocalizations l) {
    final newLove = _sc('new_love_probability_next_12_months_pct');
    final energy = _sc('relationship_energy_now');
    final phase = _str('current_relationship_phase');
    final peaks = _strs('peak_romance_years');
    final windows = _list('new_relationship_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final cards = <Widget>[];
    for (final m in windows.take(3)) {
      cards.add(_timelineCard(l, l.lvNewLoveWindow, m['window']?.toString() ?? '', m['dasha']?.toString() ?? '', _cap(m['note']?.toString() ?? ''), KColors.green));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.event_rounded, title: l.lvTiming, color: AppColors.gold),
      _card(child: Row(children: [
        Expanded(child: Column(children: [
          Text('${newLove.toStringAsFixed(0)}%', style: TextStyle(color: _lvColor(newLove), fontSize: 20, fontWeight: FontWeight.w800)),
          Text(l.lvNewLove12, style: const TextStyle(color: AppColors.smoke, fontSize: 9.5, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ])),
        Container(width: 1, height: 40, color: Colors.white12),
        Expanded(child: Column(children: [
          Text('${energy.toStringAsFixed(0)}%', style: TextStyle(color: _lvColor(energy), fontSize: 20, fontWeight: FontWeight.w800)),
          Text(l.lvEnergyNow, style: const TextStyle(color: AppColors.smoke, fontSize: 9.5, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ])),
        if (phase.isNotEmpty) ...[
          Container(width: 1, height: 40, color: Colors.white12),
          Expanded(child: Column(children: [
            Text(_titleCase(phase), style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
            Text(l.lvPhaseNow, style: const TextStyle(color: AppColors.smoke, fontSize: 9.5, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ])),
        ],
      ])),
      if (peaks.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: _card(child: Row(children: [const Text('💞', style: TextStyle(fontSize: 15)), const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.lvPeakRomance, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
            Text(peaks.join(' · '), style: const TextStyle(color: KColors.green, fontSize: 14, fontWeight: FontWeight.w800)),
          ]))]))),
      if (cards.isNotEmpty) ...[const SizedBox(height: 10), ...cards],
    ]);
  }

  Widget _timelineCard(AppLocalizations l, String title, String window, String dasha, String note, Color col) {
    final loc = Localizations.localeOf(context);
    final planet = dasha.isNotEmpty ? KundliNames.planet(dasha.split('/').first.split(' ').first, loc) : '';
    return Container(
      margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.fromLTRB(14, 13, 13, 13),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.28))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: col, shape: BoxShape.circle, border: Border.all(color: col.withOpacity(0.35), width: 3))),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(color: col, fontSize: 12.5, fontWeight: FontWeight.w800))),
          if (window.isNotEmpty) Flexible(child: Text(window, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.right)),
        ]),
        if (planet.isNotEmpty) ...[const SizedBox(height: 4), Text('🪐 $planet', style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700))],
        if (note.isNotEmpty) ...[const SizedBox(height: 6), Text(note, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))],
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — CHALLENGES TO WATCH
  // ══════════════════════════════════════════════════════════════════
  Widget _challenges(AppLocalizations l) {
    final rows = <List<Object>>[
      [l.lvRiskHeartbreak, _sc('heartbreak_vulnerability_score')],
      [l.lvRiskSabotage, _sc('self_sabotage_in_love_score')],
      [l.lvRiskCommitFear, _sc('commitment_fear_score')],
      [l.lvRiskRepeat, _sc('repeat_heartbreak_pattern_probability_pct')],
      [l.lvRiskWorkaholic, _sc('workaholic_risk_in_relationships_score')],
    ].where((r) => (r[1] is num ? (r[1] as num).toDouble() : 0.0) > 0).toList();
    final flags = _strs('red_flags_to_watch_in_partners');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.shield_outlined, title: l.lvChallenges, color: KColors.orange),
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
          ]),
        );
      }),
      if (flags.isNotEmpty) Container(
        margin: const EdgeInsets.only(top: 2), padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: KColors.orange.withOpacity(0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.orange.withOpacity(0.18))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('🚩 ${l.lvRedFlags}', style: const TextStyle(color: KColors.orange, fontSize: 11, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          ...flags.map((s) => Padding(padding: const EdgeInsets.only(bottom: 3),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('• ', style: TextStyle(color: AppColors.smoke, fontSize: 12)),
              Expanded(child: Text(_cap(s), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.35))),
            ]))),
        ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  11 — WHAT TO HEAL
  // ══════════════════════════════════════════════════════════════════
  Widget _healing(AppLocalizations l) {
    final t = _map('core_love_theme');
    final theme = t['primary_theme']?.toString() ?? _str('primary_love_block');
    final explain = t['explanation']?.toString() ?? '';
    final dir = t['healing_direction']?.toString() ?? _str('healing_direction');
    if (theme.isEmpty && dir.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.healing_rounded, title: l.lvHealing, color: KColors.blue),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (theme.isNotEmpty) ...[
          Text(l.lvFocusArea, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(_cap(theme), style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
        ],
        if (explain.isNotEmpty) Text(_cap(explain), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5)),
        if (dir.isNotEmpty) ...[const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('🌱 ${l.lvHealDir}: ', style: const TextStyle(color: KColors.green, fontSize: 10.5, fontWeight: FontWeight.w800)),
            Expanded(child: Text(_cap(dir), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
          ])],
      ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  12 — IMPROVEMENT PLAN (remedies)
  // ══════════════════════════════════════════════════════════════════
  Widget _remedies(AppLocalizations l) {
    final practical = _list('practical_solutions').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final astro = _list('astrological_remedies').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (practical.isEmpty && astro.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.spa_rounded, title: l.lvImprovementPlan, color: KColors.green),
      if (practical.isNotEmpty) ...[
        _catLabel('🎯', l.crCatPractical, KColors.blue),
        ...practical.map((m) => _remedyCard(_titleCase(m['category']?.toString() ?? ''), m['advice']?.toString() ?? '', KColors.blue)),
      ],
      if (astro.isNotEmpty) ...[
        const SizedBox(height: 6),
        _catLabel('🕉️', l.crCatPlanetary, KColors.purple),
        ...astro.map((m) => _remedyCard(m['planet']?.toString() ?? '', m['remedy']?.toString() ?? '', KColors.purple)),
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
  //  13 — PREDICTION RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    double layer(String k) { final v = b[k]; return v is num ? v.toDouble() * 100 : 0; }
    final layers = <List<Object>>[
      [l.lvLayerBirth, layer('d1')],
      [l.lvLayerNavamsa, layer('d9')],
      [l.lvLayerSaptamsa, layer('d7')],
      [l.lvLayerDasha, layer('dasha')],
      [l.lvLayerTransit, layer('transit')],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.lvReliability, color: KColors.blue),
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
            SizedBox(width: 140, child: Text(la[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(_lvColor(v))))),
            const SizedBox(width: 8),
            Text('${v.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
          ]));
        }).toList())),
      ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  14 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.lvTopicWhen, l.lvTopicSoulmate, l.lvTopicCurrent, l.lvTopicHeal, l.lvTopicCommit, l.lvTopicLoveVsArranged, l.lvTopicHeartbreak, l.lvTopicConfidence];
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
    final q = '$topic — based on my Vedic love & relationships report for ${widget.chartName}.\n\n${_buildPrompt(_data!)}';
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

  Color _lvColor(double s) {
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
    final overall = d['love_capacity_score'] ?? '?';
    final verdict = d['love_life_verdict'] ?? '';
    final style = d['love_style'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic love and relationships advisor. Analyze this love report for $name and provide actionable insights.

Key highlights:
- Love capacity: $overall/100
- Verdict: $verdict
- Love style: $style

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the most important love timing windows, and suggest practical next steps.''';
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
