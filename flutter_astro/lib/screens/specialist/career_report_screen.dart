import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/gen/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

/// Career & Job specialist report — matches nakshtralogy-career-detail.html design
class CareerReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const CareerReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});

  @override
  State<CareerReportScreen> createState() => _CareerReportState();
}

class _CareerReportState extends State<CareerReportScreen> {
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
      final resp = await _api.runSpecialist('career', widget.chartId);
      if (!mounted) return;
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        setState(() { _data = (resp['data'] as Map).cast<String, dynamic>(); _loading = false; });
      } else {
        setState(() { _error = resp['detail']?.toString() ?? 'Analysis failed'; _loading = false; });
      }
    } catch (e) { if (!mounted) return; setState(() { _error = e.toString(); _loading = false; }); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A24),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null
              ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _load, child: Text(AppLocalizations.of(context)?.retry ?? 'Retry')),
                ])))
              : _data != null
                  ? _buildReport()
                  : const SizedBox.shrink(),
    );
  }

  Widget _buildReport() {
    final d = _data!;
    return CustomScrollView(slivers: [
      _appBar(),
      SliverList(delegate: SliverChildListDelegate([
        _heroScores(d),
        _karakaSection(d),
        _houseSection(d),
        _divisionalSection(d),
        _archetypeSection(d),
        _workStructureSection(d),
        _timingSection(d),
        _risksSection(d),
        _remediesSection(d),
        _confidenceSection(d),
        _aiDiscussBar(d),
        const SizedBox(height: 30),
      ])),
    ]);
  }

  Widget _appBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFF0A0A24),
      pinned: true,
      leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
      title: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
        Text(widget.chartName.toUpperCase(),
            style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace')),
        const SizedBox(height: 2),
        const Text.rich(TextSpan(children: [
          TextSpan(text: 'Career ', style: TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w600)),
          TextSpan(text: 'Analysis', style: TextStyle(color: AppColors.gold, fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
        ])),
      ]),
      actions: [IconButton(icon: const Icon(Icons.refresh, color: AppColors.ivory, size: 18), onPressed: _load)],
      centerTitle: true,
    );
  }

  // ── HERO SCORES (3 main rings + 3 mini stats) ──
  Widget _heroScores(Map<String, dynamic> d) {
    final overall = (d['overall_career_strength_score'] as num?)?.toDouble() ?? 0;
    final stability = (d['career_stability_score'] as num?)?.toDouble() ?? 0;
    final growth = (d['career_growth_potential_score'] as num?)?.toDouble() ?? 0;
    final clarity = (d['career_clarity_score'] as num?)?.toDouble() ?? 0;
    final recognition = (d['career_recognition_score'] as num?)?.toDouble() ?? 0;
    final satisfaction = (d['career_satisfaction_score'] as num?)?.toDouble() ?? 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [const Color(0xFFE8B547).withOpacity(0.10), const Color(0xFFE07A3C).withOpacity(0.04)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.25)),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 1, height: 8, color: AppColors.gold.withOpacity(0.4)),
          const SizedBox(width: 6),
          const Text('CORE CAREER SCORES', style: TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          Container(width: 1, height: 8, color: AppColors.gold.withOpacity(0.4)),
        ]),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _scoreRing(overall, 'OVERALL\nSTRENGTH', AppColors.gold),
          _scoreRing(stability, 'STABILITY', AppColors.aurora),
          _scoreRing(growth, 'GROWTH', AppColors.cosmicPink),
        ]),
        const SizedBox(height: 14),
        Container(padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.2), width: 0.5))),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _miniScore(clarity, 'CLARITY'),
            _miniScore(recognition, 'RECOGNITION'),
            _miniScore(satisfaction, 'SATISFACTION'),
          ])),
      ]),
    );
  }

  Widget _scoreRing(double value, String label, Color color) {
    return Column(children: [
      SizedBox(width: 76, height: 76, child: Stack(alignment: Alignment.center, children: [
        SizedBox(width: 76, height: 76, child: CircularProgressIndicator(
          value: value / 100, strokeWidth: 6,
          backgroundColor: Colors.white.withOpacity(0.08), valueColor: AlwaysStoppedAnimation(color))),
        Text(value.toStringAsFixed(1),
          style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'serif')),
      ])),
      const SizedBox(height: 6),
      Text(label, textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.smoke, fontSize: 8, letterSpacing: 1, fontFamily: 'monospace', height: 1.2)),
    ]);
  }

  Widget _miniScore(double value, String label) {
    return Column(children: [
      Text(value.toStringAsFixed(1),
        style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 7, letterSpacing: 1, fontFamily: 'monospace')),
    ]);
  }

  // ── KARAKA SECTION ──
  Widget _karakaSection(Map<String, dynamic> d) {
    final atma = d['atmakaraka_planet']?.toString() ?? '—';
    final amatya = d['amatyakaraka_planet']?.toString() ?? '—';
    final soulAlign = (d['soul_career_alignment_score'] as num?)?.toDouble() ?? 0;
    final soulContract = d['atmakaraka_soul_career_contract']?.toString() ?? '';
    final amatyaTheme = d['amatyakaraka_career_theme']?.toString() ?? '';

    return Column(children: [
      _sectionHeader('Jaimini', 'Karakas', '8 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(children: [
          Expanded(child: _karakaCard('ATMAKARAKA', atma, 'Soul significator', soulContract)),
          const SizedBox(width: 8),
          Expanded(child: _karakaCard('AMATYAKARAKA', amatya, 'Career significator', amatyaTheme)),
        ])),
      // Soul alignment bar
      Container(margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF4A3B8C).withOpacity(0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.lavender.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Soul ↔ Career Alignment',
              style: TextStyle(color: AppColors.lavender, fontSize: 10, fontWeight: FontWeight.w600)),
            Text(soulAlign.toStringAsFixed(1),
              style: const TextStyle(color: AppColors.cosmicPink, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
          ]),
          const SizedBox(height: 8),
          ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: soulAlign / 100, minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(AppColors.cosmicPink))),
        ])),
    ]);
  }

  Widget _karakaCard(String tag, String planet, String meaning, String detail) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [const Color(0xFFE8B547).withOpacity(0.12), const Color(0xFFE8B547).withOpacity(0.02)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.25))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(tag, style: const TextStyle(color: AppColors.gold, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(planet, style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'serif', height: 1.0)),
        const SizedBox(height: 2),
        Text(meaning, style: const TextStyle(color: AppColors.smoke, fontSize: 8, height: 1.3)),
        if (detail.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(detail, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.lavender, fontSize: 8, height: 1.3, fontStyle: FontStyle.italic)),
        ],
      ]),
    );
  }

  Widget _sectionHeader(String prefix, String suffix, String tag) {
    return Container(padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text.rich(TextSpan(children: [
          TextSpan(text: '$prefix ', style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'serif')),
          TextSpan(text: suffix, style: const TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'serif', fontStyle: FontStyle.italic)),
        ])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.gold.withOpacity(0.15))),
          child: Text(tag, style: const TextStyle(color: AppColors.smoke, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace'))),
      ]));
  }

  // ── 10TH HOUSE BOX ──
  Widget _houseSection(Map<String, dynamic> d) {
    final sign = d['tenth_house_sign_name']?.toString() ?? '—';
    final lord = d['tenth_lord_planet']?.toString() ?? '—';
    final lordHouse = d['tenth_lord_house']?.toString() ?? '?';
    final lordDignity = d['tenth_lord_dignity']?.toString() ?? '—';
    final lordD9 = d['tenth_lord_d9_dignity']?.toString() ?? '—';
    final occupants = (d['tenth_house_occupants'] as List?)?.cast<dynamic>().join(', ') ?? '';
    final strength = (d['tenth_house_strength_score'] as num?)?.toDouble() ?? 0;
    final indication = d['tenth_lord_career_indication']?.toString() ?? '';
    final strengthColor = strength >= 70 ? AppColors.success : strength >= 50 ? AppColors.gold : AppColors.warning;

    return Column(children: [
      _sectionHeader('10th', 'House Analysis', '14 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1642).withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold.withOpacity(0.2))),
        child: Column(children: [
          _houseRow('SIGN', sign),
          _houseRow('LORD', lord),
          _houseRow('LORD PLACED IN', '${lordHouse}th house'),
          _houseRow('LORD DIGNITY', lordDignity),
          _houseRow('D9 DIGNITY', lordD9),
          _houseRow('OCCUPANTS', occupants.isEmpty ? 'Empty' : occupants),
          _houseRow('STRENGTH', '${strength.toStringAsFixed(1)} / 100', valueColor: strengthColor),
          if (indication.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8B547).withOpacity(0.08),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                border: const Border(left: BorderSide(color: AppColors.gold, width: 3))),
              child: Text(indication,
                style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.5, fontStyle: FontStyle.italic))),
          ],
        ])),
    ]);
  }

  Widget _houseRow(String key, String value, {Color? valueColor}) {
    return Container(padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x14FFFFFF), width: 0.5))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(key, style: const TextStyle(color: AppColors.smoke, fontSize: 9, letterSpacing: 1, fontFamily: 'monospace')),
        Flexible(child: Text(value, textAlign: TextAlign.right,
          style: TextStyle(color: valueColor ?? AppColors.gold, fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'serif'),
          maxLines: 2, overflow: TextOverflow.ellipsis)),
      ]));
  }

  // ── DIVISIONAL VALIDATION (D9/D10/D60 tabs) ──
  Widget _divisionalSection(Map<String, dynamic> d) {
    final d9 = (d['d9_validation'] as Map?)?.cast<String, dynamic>() ?? {};
    final d10 = (d['d10_validation'] as Map?)?.cast<String, dynamic>() ?? {};
    final d60 = (d['d60_career_validation'] as Map?)?.cast<String, dynamic>() ?? {};

    return Column(children: [
      _sectionHeader('Divisional', 'Validation', 'D9 · D10 · D60'),
      _divCard('D-10 KARMA · DASAMSHA', d10, [
        ['Lagna Lord', d10['d10_lagna_lord_dignity']?.toString()],
        ['Sun', d10['d10_sun_dignity']?.toString()],
        ['Saturn', d10['d10_saturn_dignity']?.toString()],
        ['Jupiter', d10['d10_jupiter_dignity']?.toString()],
        ['10th Lord', d10['d10_tenth_lord_dignity']?.toString()],
        ['Amatyakaraka', d10['d10_amatyakaraka_dignity']?.toString()],
      ], summary: d10['d10_overall_career_standing']?.toString(), notes: d10['d10_primary_career_signature']?.toString()),
      _divCard('D-9 DHARMA · NAVAMSA', d9, [
        ['10th Lord', d9['d9_tenth_lord_dignity']?.toString()],
        ['Amatyakaraka', d9['d9_amatyakaraka_dignity']?.toString()],
      ], summary: '${(d9['d9_career_dharma_alignment_score'] as num?)?.toStringAsFixed(0) ?? "?"}% alignment', notes: d9['d9_career_notes']?.toString()),
      _divCard('D-60 KARMIC · SHASHTYAMSA', d60, [
        ['10th Lord', d60['d60_tenth_lord_dignity']?.toString()],
        ['Amatyakaraka', d60['d60_amatyakaraka_dignity']?.toString()],
      ], summary: '${(d60['d60_past_life_work_capital_score'] as num?)?.toStringAsFixed(0) ?? "?"}% past-life capital', notes: d60['d60_career_past_life_signature']?.toString()),
    ]);
  }

  Widget _divCard(String title, Map<String, dynamic> data, List<List<dynamic>> rows, {String? summary, String? notes}) {
    return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1642).withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.15))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]),
            borderRadius: BorderRadius.circular(8)),
          child: Text(title, style: const TextStyle(color: AppColors.midnight, fontSize: 9, letterSpacing: 1, fontFamily: 'monospace', fontWeight: FontWeight.w700))),
        const SizedBox(height: 10),
        ...rows.where((r) => r[1] != null).map((r) => _dignityRow(r[0] as String, r[1] as String)),
        if (summary != null && summary.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6)),
            child: Row(children: [
              const Text('VERDICT', style: TextStyle(color: AppColors.smoke, fontSize: 8, letterSpacing: 1, fontFamily: 'monospace')),
              const Spacer(),
              Text(summary.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700)),
            ])),
        ],
        if (notes != null && notes.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(notes, style: const TextStyle(color: AppColors.lavender, fontSize: 9, height: 1.4, fontStyle: FontStyle.italic), maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ]));
  }

  Widget _dignityRow(String planet, String dignity) {
    Color color;
    final dl = dignity.toLowerCase();
    if (dl.contains('exalt') || dl.contains('moolatrikona')) color = AppColors.success;
    else if (dl.contains('own') || dl.contains('swakshetra')) color = AppColors.gold;
    else if (dl.contains('friend')) color = AppColors.aurora;
    else if (dl.contains('neech') || dl.contains('debilitat') || dl.contains('enemy')) color = AppColors.error;
    else color = AppColors.smoke;

    return Container(padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x0DFFFFFF), width: 0.5))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(planet, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'serif')),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color.withOpacity(0.4))),
          child: Text(dignity.toUpperCase(),
            style: TextStyle(color: color, fontSize: 8, letterSpacing: 0.8, fontFamily: 'monospace', fontWeight: FontWeight.w700))),
      ]));
  }

  // ── ARCHETYPE SECTION ──
  Widget _archetypeSection(Map<String, dynamic> d) {
    final archetype = d['primary_career_archetype']?.toString() ?? '';
    final category = d['primary_career_category']?.toString() ?? '';
    final roles = (d['specific_job_role_fits'] as List?)?.cast<dynamic>() ?? [];
    final strengths = (d['career_strengths'] as List?)?.cast<dynamic>() ?? [];
    final weaknesses = (d['career_weaknesses'] as List?)?.cast<dynamic>() ?? [];
    final industries = (d['best_industries'] as List?)?.cast<dynamic>() ?? [];

    if (archetype.isEmpty && roles.isEmpty) return const SizedBox.shrink();

    return Column(children: [
      _sectionHeader('Career', 'Archetype', '${roles.length + strengths.length + 2} KEYS'),
      // Archetype card
      if (archetype.isNotEmpty) Container(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [const Color(0xFFE8689C).withOpacity(0.15), const Color(0xFF4A3B8C).withOpacity(0.15)]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cosmicPink.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('PRIMARY ARCHETYPE',
            style: TextStyle(color: AppColors.cosmicPink, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(_titleCase(archetype),
            style: const TextStyle(color: AppColors.ivory, fontSize: 22, fontWeight: FontWeight.w600, fontFamily: 'serif')),
          if (category.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(_titleCase(category), style: const TextStyle(color: AppColors.lavender, fontSize: 11, fontStyle: FontStyle.italic)),
          ],
        ])),
      // Top role chips
      if (roles.isNotEmpty) ...[
        _chipsLabel('★ TOP ROLE FITS'),
        Container(margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(spacing: 6, runSpacing: 6, children: roles.take(10).map((r) => _chip(r.toString(), AppColors.gold, isTop: true)).toList())),
      ],
      // Strengths
      if (strengths.isNotEmpty) ...[
        _chipsLabel('● STRENGTHS'),
        Container(margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(spacing: 6, runSpacing: 6, children: strengths.take(8).map((s) => _chip(s.toString(), AppColors.success)).toList())),
      ],
      // Weaknesses
      if (weaknesses.isNotEmpty) ...[
        _chipsLabel('⚠ AREAS FOR GROWTH'),
        Container(margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(spacing: 6, runSpacing: 6, children: weaknesses.take(6).map((w) => _chip(w.toString(), AppColors.warning)).toList())),
      ],
      // Industries
      if (industries.isNotEmpty) ...[
        _chipsLabel('☆ BEST INDUSTRIES'),
        Container(margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(spacing: 6, runSpacing: 6, children: industries.take(8).map((i) => _chip(i.toString(), AppColors.aurora)).toList())),
      ],
    ]);
  }

  Widget _chipsLabel(String label) => Container(padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
    alignment: Alignment.centerLeft,
    child: Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w600)));

  Widget _chip(String text, Color color, {bool isTop = false}) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(isTop ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(isTop ? 0.5 : 0.3))),
      child: Text(text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: isTop ? FontWeight.w700 : FontWeight.w500)));
  }

  // ── WORK STRUCTURE SECTION ──
  Widget _workStructureSection(Map<String, dynamic> d) {
    final emp = (d['employment_fit_score'] as num?)?.toDouble() ?? 0;
    final ent = (d['entrepreneurship_fit_score'] as num?)?.toDouble() ?? 0;
    final freelance = (d['freelance_consulting_fit_score'] as num?)?.toDouble() ?? 0;
    final mixed = (d['mixed_portfolio_fit_score'] as num?)?.toDouble() ?? 0;
    final recommended = d['recommended_work_structure']?.toString() ?? '';
    final teamFit = (d['team_leadership_fit_score'] as num?)?.toDouble() ?? 0;
    final environment = d['ideal_work_environment']?.toString() ?? '';
    final orgSize = d['ideal_organization_size']?.toString() ?? '';

    return Column(children: [
      _sectionHeader('Work', 'Structure', '8 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Expanded(child: _structCard('🏢', 'Employment', emp, recommended == 'employment')),
          const SizedBox(width: 8),
          Expanded(child: _structCard('🚀', 'Entrepreneurship', ent, recommended == 'entrepreneurship')),
        ])),
      const SizedBox(height: 8),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Expanded(child: _structCard('💻', 'Freelance', freelance, recommended == 'freelance_consulting')),
          const SizedBox(width: 8),
          Expanded(child: _structCard('🎯', 'Portfolio', mixed, recommended == 'mixed_portfolio')),
        ])),
      const SizedBox(height: 8),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1642).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          _miniRow('Team Leadership', '${teamFit.toStringAsFixed(1)}'),
          if (environment.isNotEmpty) _miniRow('Ideal Environment', _titleCase(environment)),
          if (orgSize.isNotEmpty) _miniRow('Ideal Org Size', _titleCase(orgSize)),
        ])),
    ]);
  }

  Widget _structCard(String icon, String name, double score, bool recommended) {
    return Container(padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: recommended
          ? LinearGradient(colors: [AppColors.gold.withOpacity(0.15), AppColors.saffron.withOpacity(0.1)])
          : LinearGradient(colors: [Colors.white.withOpacity(0.04), Colors.white.withOpacity(0.02)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: recommended ? AppColors.gold.withOpacity(0.5) : AppColors.gold.withOpacity(0.15))),
      child: Column(children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(score.toStringAsFixed(1),
          style: TextStyle(color: recommended ? AppColors.gold : AppColors.lavender, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'serif')),
        Text(recommended ? 'RECOMMENDED ★' : 'FIT SCORE',
          style: TextStyle(color: recommended ? AppColors.gold : AppColors.smoke, fontSize: 7, letterSpacing: 1, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
      ]));
  }

  Widget _miniRow(String label, String value) {
    return Container(padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
        Text(value, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'serif')),
      ]));
  }

  // ── TIMING WINDOWS ──
  Widget _timingSection(Map<String, dynamic> d) {
    final launch = (d['career_launch_windows'] as List?) ?? [];
    final peak = (d['career_peak_windows'] as List?) ?? [];
    final promo = (d['promotion_recognition_windows'] as List?) ?? [];
    final risk = (d['career_risk_windows'] as List?) ?? [];

    if (launch.isEmpty && peak.isEmpty && promo.isEmpty && risk.isEmpty) return const SizedBox.shrink();

    return Column(children: [
      _sectionHeader('Timing', 'Windows', '${launch.length + peak.length + promo.length + risk.length} ENTRIES'),
      if (launch.isNotEmpty) _timingCard('Launch Windows', '→', AppColors.aurora, launch),
      if (peak.isNotEmpty) _timingCard('Peak Windows ★', '★', AppColors.gold, peak, isPeak: true),
      if (promo.isNotEmpty) _timingCard('Promotion Windows', '▲', AppColors.cosmicPink, promo),
      if (risk.isNotEmpty) _timingCard('Risk Windows', '⚠', AppColors.warning, risk),
    ]);
  }

  Widget _timingCard(String title, String icon, Color color, List items, {bool isPeak = false}) {
    return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: isPeak
          ? LinearGradient(colors: [AppColors.gold.withOpacity(0.10), AppColors.gold.withOpacity(0.02)])
          : null,
        color: isPeak ? null : const Color(0xFF1A1642).withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(isPeak ? 0.4 : 0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text.rich(TextSpan(children: [
            TextSpan(text: title.split(' ').first + ' ', style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'serif')),
            TextSpan(text: title.split(' ').sublist(1).join(' '), style: TextStyle(color: color, fontSize: 14, fontStyle: FontStyle.italic, fontFamily: 'serif')),
          ])),
          Container(width: 26, height: 26,
            decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
            child: Center(child: Text(icon, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)))),
        ]),
        const SizedBox(height: 8),
        ...items.take(3).map((item) {
          if (item is! Map) return const SizedBox.shrink();
          final w = (item).cast<String, dynamic>();
          return Container(margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(8)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Flexible(child: Text(w['dasha']?.toString() ?? '—',
                  style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'serif'))),
                Text(w['window']?.toString() ?? '',
                  style: const TextStyle(color: AppColors.smoke, fontSize: 9, letterSpacing: 0.5, fontFamily: 'monospace')),
              ]),
              if (w['note'] != null && w['note'].toString().isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(w['note'].toString(), maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.lavender, fontSize: 9, height: 1.3, fontStyle: FontStyle.italic)),
              ],
            ]));
        }),
      ]));
  }

  static String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── RISKS SECTION ──
  Widget _risksSection(Map<String, dynamic> d) {
    final risks = (d['major_career_risks'] as List?)?.where((r) => r is Map).toList() ?? [];
    final burnout = (d['burnout_risk_score'] as num?)?.toDouble() ?? 0;
    final stagnation = (d['career_stagnation_risk_score'] as num?)?.toDouble() ?? 0;
    final conflict = (d['workplace_conflict_risk_score'] as num?)?.toDouble() ?? 0;

    if (risks.isEmpty && burnout == 0 && stagnation == 0) return const SizedBox.shrink();

    return Column(children: [
      _sectionHeader('Career', 'Risks', '${risks.length + 3} KEYS'),
      ...risks.take(5).map((r) {
        final risk = (r as Map).cast<String, dynamic>();
        final severity = risk['severity']?.toString() ?? 'low';
        return _riskCard(
          type: _titleCase(risk['type']?.toString() ?? 'Risk'),
          severity: severity,
          desc: risk['description']?.toString() ?? '',
          mitigation: risk['mitigation']?.toString() ?? '',
        );
      }),
      // Risk score bars
      Container(margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1642).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.warning.withOpacity(0.2))),
        child: Column(children: [
          _riskBar('Burnout Risk', burnout),
          _riskBar('Career Stagnation', stagnation),
          _riskBar('Workplace Conflict', conflict),
        ])),
    ]);
  }

  Widget _riskCard({required String type, required String severity, required String desc, required String mitigation}) {
    Color color;
    final s = severity.toLowerCase();
    if (s == 'high' || s == 'notable') color = AppColors.error;
    else if (s == 'moderate' || s == 'med' || s == 'medium') color = AppColors.warning;
    else color = AppColors.aurora;

    return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.10), color.withOpacity(0.02)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(child: Text(type,
            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'serif'))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6)),
            child: Text(severity.toUpperCase(),
              style: TextStyle(color: color, fontSize: 8, letterSpacing: 1, fontFamily: 'monospace', fontWeight: FontWeight.w700))),
        ]),
        if (desc.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4)),
        ],
        if (mitigation.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.success.withOpacity(0.2))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('✓ MITIGATION',
                style: TextStyle(color: AppColors.success, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(mitigation, style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4)),
            ])),
        ],
      ]));
  }

  Widget _riskBar(String label, double value) {
    final color = value >= 60 ? AppColors.error : value >= 40 ? AppColors.warning : AppColors.success;
    return Container(padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(color: AppColors.ivory, fontSize: 10)),
          Text('${value.toStringAsFixed(0)}',
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
        ]),
        const SizedBox(height: 3),
        ClipRRect(borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(value: value / 100, minHeight: 4,
            backgroundColor: Colors.white.withOpacity(0.06),
            valueColor: AlwaysStoppedAnimation(color))),
      ]));
  }

  // ── REMEDIES SECTION ──
  Widget _remediesSection(Map<String, dynamic> d) {
    final remedies = (d['astrological_remedies'] as List?)?.where((r) => r is Map).toList() ?? [];
    final practical = (d['practical_solutions'] as List?)?.where((p) => p is Map).toList() ?? [];

    if (remedies.isEmpty && practical.isEmpty) return const SizedBox.shrink();

    return Column(children: [
      _sectionHeader('Astrological', 'Remedies', '${remedies.length} KEYS'),
      ...remedies.take(6).map((r) {
        final rem = (r as Map).cast<String, dynamic>();
        final deity = rem['deity']?.toString() ?? '';
        final text = rem['remedy']?.toString() ?? '';
        return _remedyCard(deity, text);
      }),
      if (practical.isNotEmpty) ...[
        _sectionHeader('Practical', 'Solutions', '${practical.length} KEYS'),
        ...practical.take(5).map((p) {
          final sol = (p as Map).cast<String, dynamic>();
          return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.aurora.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.aurora.withOpacity(0.2))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_titleCase(sol['category']?.toString() ?? '').toUpperCase(),
                style: const TextStyle(color: AppColors.aurora, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(sol['advice']?.toString() ?? '',
                style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4)),
            ]));
        }),
      ],
    ]);
  }

  Widget _remedyCard(String deity, String text) {
    final firstChar = deity.isNotEmpty ? deity.split(' ').first.substring(0, 1).toUpperCase() : '✦';
    return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1642).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withOpacity(0.2))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 38, height: 38,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]),
            borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(firstChar,
            style: const TextStyle(color: AppColors.midnight, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif')))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(deity, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'serif')),
          const SizedBox(height: 3),
          Text(text, style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4)),
        ])),
      ]));
  }

  // ── CONFIDENCE SECTION ──
  Widget _confidenceSection(Map<String, dynamic> d) {
    final score = (d['confidence_score'] as num?)?.toDouble() ?? 0;
    final pct = score <= 1.0 ? score * 100 : score;
    final breakdown = (d['confidence_breakdown'] as Map?)?.cast<String, dynamic>() ?? {};
    final statement = d['plain_statement']?.toString() ?? '';

    final layers = [
      {'name': 'D-1 (Natal)', 'val': breakdown['d1']},
      {'name': 'D-9 (Dharma)', 'val': breakdown['d9']},
      {'name': 'D-10 (Career)', 'val': breakdown['d10']},
      {'name': 'D-60 (Karmic)', 'val': breakdown['d60']},
      {'name': 'Amatyakaraka', 'val': breakdown['amatyakaraka']},
      {'name': 'Atmakaraka', 'val': breakdown['atmakaraka']},
    ].where((l) => l['val'] != null).toList();

    return Column(children: [
      _sectionHeader('Analysis', 'Confidence', 'QUALITY'),
      Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [AppColors.aurora.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.15)]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.aurora.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            SizedBox(width: 70, height: 70, child: Stack(alignment: Alignment.center, children: [
              SizedBox(width: 70, height: 70, child: CircularProgressIndicator(
                value: pct / 100, strokeWidth: 5,
                backgroundColor: Colors.white.withOpacity(0.08),
                valueColor: const AlwaysStoppedAnimation(AppColors.aurora))),
              Text('${pct.toStringAsFixed(0)}%',
                style: const TextStyle(color: AppColors.aurora, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif')),
            ])),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('CONFIDENCE',
                style: TextStyle(color: AppColors.aurora, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(_confidenceLabel(pct),
                style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'serif', height: 1.2)),
            ])),
          ]),
          if (statement.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(statement, style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.5)),
          ],
          if (layers.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...layers.map((l) {
              final v = ((l['val'] as num).toDouble() * 100).clamp(0, 100).toDouble();
              return Container(padding: const EdgeInsets.only(bottom: 6),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(l['name'] as String,
                      style: const TextStyle(color: AppColors.lavender, fontSize: 9)),
                    Text('${v.toStringAsFixed(0)}%',
                      style: const TextStyle(color: AppColors.gold, fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
                  ]),
                  const SizedBox(height: 3),
                  ClipRRect(borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(value: v / 100, minHeight: 3,
                      backgroundColor: Colors.white.withOpacity(0.06),
                      valueColor: const AlwaysStoppedAnimation(AppColors.aurora))),
                ]));
            }),
          ],
        ])),
    ]);
  }

  String _confidenceLabel(double pct) {
    if (pct >= 80) return 'Very High reliability across all chart layers.';
    if (pct >= 65) return 'High reliability across all chart layers.';
    if (pct >= 50) return 'Moderate reliability with mixed support.';
    return 'Low reliability — interpret as guidance, not certainty.';
  }

  // ── AI DISCUSS BAR ──
  Widget _aiDiscussBar(Map<String, dynamic> d) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFF1A1642).withOpacity(0.8), const Color(0xFF0A0A24)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.25))),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)),
          const SizedBox(width: 8),
          Text(AppLocalizations.of(context)?.discussWithAI ?? 'DISCUSS WITH AI',
            style: TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _aiBtn('G', 'ChatGPT', const LinearGradient(colors: [Color(0xFF10A37F), Color(0xFF1A7F64)]),
            () => _launchAi(d, 'chatgpt'))),
          const SizedBox(width: 8),
          Expanded(child: _aiBtn('C', 'Claude', const LinearGradient(colors: [Color(0xFFD97757), Color(0xFFB85B3F)]),
            () => _launchAi(d, 'claude'))),
          const SizedBox(width: 8),
          Expanded(child: _aiBtn('✦', 'Gemini', const LinearGradient(colors: [Color(0xFF4285F4), Color(0xFF9B72CB)]),
            () => _launchAi(d, 'gemini'))),
        ]),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _copyReportData(d),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.1))),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.copy, size: 14, color: AppColors.smoke),
              SizedBox(width: 6),
              Text('Copy full report data', style: TextStyle(color: AppColors.smoke, fontSize: 10)),
            ])),
        ),
      ]),
    );
  }

  Widget _aiBtn(String icon, String name, Gradient gradient, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withOpacity(0.2))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 26, height: 26,
            decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(icon,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)))),
          const SizedBox(height: 5),
          Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 9, fontWeight: FontWeight.w700)),
          const Text('OPEN ↗', style: TextStyle(color: AppColors.smoke, fontSize: 7, letterSpacing: 1, fontFamily: 'monospace')),
        ]),
      ),
    );
  }

  String _buildPrompt(Map<String, dynamic> d) {
    final name = widget.chartName;
    final overall = d['overall_career_strength_score'] ?? '?';
    final archetype = d['primary_career_archetype'] ?? '';
    final verdict = d['overall_career_verdict'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic career advisor. Analyze this career report for $name and provide actionable insights.

Key highlights:
- Overall career strength: $overall/100
- Career archetype: $archetype
- Career verdict: $verdict

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the most important timing windows, and suggest practical next steps.''';
  }

  void _copyReportData(Map<String, dynamic> d) {
    final prompt = _buildPrompt(d);
    Clipboard.setData(ClipboardData(text: prompt));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report data copied! Paste it into any AI chat.'),
        duration: Duration(seconds: 2)));
  }

  Future<void> _launchAi(Map<String, dynamic> d, String ai) async {
    final prompt = _buildPrompt(d);
    await Clipboard.setData(ClipboardData(text: prompt));

    String url;
    switch (ai) {
      case 'chatgpt':
        url = 'https://chat.openai.com/';
        break;
      case 'claude':
        url = 'https://claude.ai/new';
        break;
      case 'gemini':
        url = 'https://gemini.google.com/app';
        break;
      default:
        return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Report copied! Opening $ai — paste to discuss.'),
        duration: const Duration(seconds: 3)));

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}


