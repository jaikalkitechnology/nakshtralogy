import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../l10n/gen/app_localizations.dart';
import 'report_components.dart';

class RelationshipReportScreen extends StatelessWidget {
  final String names;
  final Map<String, dynamic> data;
  const RelationshipReportScreen({super.key, required this.names, required this.data});

  @override
  Widget build(BuildContext context) {
    final d = data;
    final l = AppLocalizations.of(context)!;
    return Scaffold(backgroundColor: const Color(0xFF0A0A24),
      body: CustomScrollView(slivers: [
        SliverAppBar(backgroundColor: const Color(0xFF0A0A24), pinned: true,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
          title: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
            Text(names.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace')),
            Text.rich(TextSpan(children: [
              TextSpan(text: '${l.relationshipTitlePrefix} ', style: const TextStyle(color: AppColors.ivory, fontSize: 17, fontWeight: FontWeight.w600)),
              TextSpan(text: l.relationshipTitleSuffix, style: const TextStyle(color: AppColors.gold, fontSize: 17, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
            ])),
          ]),
          centerTitle: true),
        SliverList(delegate: SliverChildListDelegate([
          _summaryBanner(d, l), _chartProfiles(d, l), _pairwiseCards(d, l),
          _criticalPatterns(d, l), _groupRecs(d, l), _individualRecs(d, l),
          _coreTheme(d, l), _confidence(d, l), _aiBar(d, context, l),
          const SizedBox(height: 30),
        ])),
      ]));
  }

  // ═══ SUMMARY BANNER ═══
  Widget _summaryBanner(Map d, AppLocalizations l) {
    final summary = d['human_summary']?.toString() ?? '';
    final advice = d['actionable_advice']?.toString() ?? '';
    final conf = (d['confidence_score'] as num?)?.toDouble() ?? 0;
    final pct = conf <= 1.0 ? conf * 100 : conf;
    final relSum = (d['relationship_summary'] as Map?)?.cast<String, dynamic>() ?? {};
    final type = relSum['relationship_type']?.toString() ?? '';
    final trust = relSum['trust_level']?.toString() ?? '';
    final dhoka = relSum['dhoka_risk']?.toString() ?? '';
    final power = relSum['power_dynamics']?.toString() ?? '';
    final c = pct >= 70 ? AppColors.success : pct >= 50 ? AppColors.gold : AppColors.warning;

    return Container(margin: const EdgeInsets.fromLTRB(16, 12, 16, 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.cosmicPink.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.15)]),
        borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.cosmicPink.withOpacity(0.3))),
      child: Column(children: [
        _label('🔗 ${l.relationshipIntelBannerLabel}'),
        const SizedBox(height: 10),
        if (summary.isNotEmpty) Text(summary, textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'serif', height: 1.4)),
        if (advice.isNotEmpty) ...[const SizedBox(height: 6),
          Text(advice, textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.lavender, fontSize: 10, fontStyle: FontStyle.italic))],
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _quickStat(type, l.typeLabel, AppColors.cosmicPink),
          _quickStat(trust, l.trustLabel, trust.toLowerCase() == 'high' ? AppColors.success : AppColors.gold),
          _quickStat(dhoka, l.dhokaRiskLabel, dhoka.toLowerCase() == 'low' ? AppColors.success : AppColors.error),
        ]),
        if (power.isNotEmpty) ...[const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), borderRadius: BorderRadius.circular(8)),
            child: Text('⚡ ${l.powerLabel(power)}', style: const TextStyle(color: AppColors.smoke, fontSize: 9)))],
      ]));
  }

  Widget _quickStat(String value, String label, Color c) => Column(children: [
    Text(value.isNotEmpty ? value : '—', style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
    Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace', letterSpacing: 1)),
  ]);

  // ═══ CHART PROFILES ═══
  Widget _chartProfiles(Map d, AppLocalizations l) {
    final charts = (d['charts_summary'] as List?) ?? [];
    if (charts.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader(l.chartProfilesPrefix, l.chartProfilesSuffix, '${charts.length} PERSONS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: charts.take(2).toList().asMap().entries.map((e) {
          final c = e.value is Map ? (e.value as Map).cast<String, dynamic>() : <String, dynamic>{};
          final isFirst = e.key == 0;
          final color = isFirst ? AppColors.aurora : AppColors.cosmicPink;
          return Expanded(child: Container(
            margin: EdgeInsets.only(right: isFirst ? 4 : 0, left: isFirst ? 0 : 4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.25))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c['name']?.toString() ?? '?', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'serif')),
              Text(l.lagnaSuffixLabel(c['lagna_sign_name']?.toString() ?? ''), style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace')),
              const SizedBox(height: 6),
              _miniBar(l.miniIntegrityLabel, (c['integrity_score'] as num?)?.toDouble() ?? 0, color),
              _miniBar(l.miniWarmthLabel, (c['emotional_warmth_score'] as num?)?.toDouble() ?? 0, color),
              _miniBar(l.miniTrustLabel, (c['trustworthiness_baseline_score'] as num?)?.toDouble() ?? 0, color),
              _miniBar(l.miniAssertLabel, (c['assertiveness_score'] as num?)?.toDouble() ?? 0, color),
              const SizedBox(height: 4),
              Text(l.akLabel(c['atmakaraka_planet']?.toString() ?? '?'), style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace')),
              Text(c['character_archetype']?.toString() ?? '', style: TextStyle(color: color, fontSize: 8, fontStyle: FontStyle.italic)),
            ])));
        }).toList())),
      if (charts.length > 2) ...[const SizedBox(height: 8),
        ...charts.skip(2).map((c) {
          if (c is! Map) return const SizedBox.shrink();
          final p = c.cast<String, dynamic>();
          return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gold.withOpacity(0.15))),
            child: Row(children: [
              Expanded(child: Text(p['name']?.toString() ?? '?', style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w600))),
              Text('${p['lagna_sign_name'] ?? ""} · AK: ${p['atmakaraka_planet'] ?? "?"}', style: const TextStyle(color: AppColors.smoke, fontSize: 9)),
            ]));
        }),
      ],
    ]);
  }

  Widget _miniBar(String label, double v, Color c) => Padding(padding: const EdgeInsets.only(bottom: 3), child: Row(children: [
    SizedBox(width: 40, child: Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 7))),
    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(1),
      child: LinearProgressIndicator(value: v / 100, minHeight: 3, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
    SizedBox(width: 20, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right,
      style: TextStyle(color: c, fontSize: 7, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
  ]));

  // ═══ PAIRWISE CARDS ═══
  Widget _pairwiseCards(Map d, AppLocalizations l) {
    final pairs = (d['pairwise_matrix'] as List?) ?? [];
    if (pairs.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader(l.pairwisePrefix, l.pairwiseSuffix, '${pairs.length} PAIRS'),
      ...pairs.map((p) {
        if (p is! Map) return const SizedBox.shrink();
        final pair = p.cast<String, dynamic>();
        return _pairCard(pair, l);
      }),
    ]);
  }

  Widget _pairCard(Map<String, dynamic> p, AppLocalizations l) {
    final n1 = p['partner1_name']?.toString() ?? '?';
    final n2 = p['partner2_name']?.toString() ?? '?';
    final unified = (p['unified_pair_score'] as num?)?.toDouble() ?? 0;
    final grade = p['unified_pair_grade']?.toString() ?? '';
    final type = p['primary_relationship_type']?.toString() ?? '';
    final trust = (p['mutual_trust_score'] as num?)?.toDouble() ?? 0;
    final betrayal = (p['betrayal_risk_probability'] as num?)?.toDouble() ?? 0;
    final c = unified >= 70 ? AppColors.success : unified >= 50 ? AppColors.gold : AppColors.warning;

    final scores = [
      ['Character', l.scoreCharacterLabel, (p['character_compat_score'] as num?)?.toDouble() ?? 0],
      ['Love', l.scoreLoveLabel, (p['love_compat_score'] as num?)?.toDouble() ?? 0],
      ['Business', l.scoreBusinessLabel, (p['business_compat_score'] as num?)?.toDouble() ?? 0],
      ['Karmic', l.scoreKarmicLabel, (p['karmic_intensity_score'] as num?)?.toDouble() ?? 0],
      ['Trust', l.scoreTrustLabel, (p['trust_compatibility_score'] as num?)?.toDouble() ?? 0],
      ['Enmity Risk', l.scoreEnmityRiskLabel, (p['enmity_risk_score'] as num?)?.toDouble() ?? 0],
    ];

    return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 10), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [c.withOpacity(0.08), const Color(0xFF1A1642).withOpacity(0.5)]),
        borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.25))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Row(children: [
          Expanded(child: Text('$n1 × $n2', style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif'))),
          Column(children: [
            Text(unified.toStringAsFixed(0), style: TextStyle(color: c, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'serif')),
            Text(grade, style: TextStyle(color: c, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          ]),
        ]),
        const SizedBox(height: 6),
        // Type + trust
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.cosmicPink.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
            child: Text(titleCase(type), style: const TextStyle(color: AppColors.cosmicPink, fontSize: 9, fontWeight: FontWeight.w700))),
          const SizedBox(width: 6),
          Text(l.trustPercentLabel(trust.toStringAsFixed(0)), style: const TextStyle(color: AppColors.success, fontSize: 9, fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(l.betrayalPercentLabel(betrayal.toStringAsFixed(0)), style: TextStyle(color: betrayal > 40 ? AppColors.error : AppColors.smoke, fontSize: 9)),
        ]),
        const SizedBox(height: 10),
        // Score bars
        ...scores.map((s) {
          final v = s[2] as double;
          final isRisk = (s[0] as String).contains('Risk');
          final barC = isRisk ? (v >= 40 ? AppColors.error : AppColors.success)
              : (v >= 65 ? AppColors.success : v >= 50 ? AppColors.gold : AppColors.warning);
          return Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
            SizedBox(width: 60, child: Text(s[1] as String, style: const TextStyle(color: AppColors.smoke, fontSize: 9))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(barC)))),
            const SizedBox(width: 6),
            SizedBox(width: 24, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right,
              style: TextStyle(color: barC, fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
          ]));
        }),
        // Behavior
        if (p['mutual_dynamic_signature'] != null) ...[const SizedBox(height: 6),
          Text(l.dynamicLabel(p['mutual_dynamic_signature'].toString()), style: const TextStyle(color: AppColors.lavender, fontSize: 9, fontStyle: FontStyle.italic))],
        // Karmic
        if (p['karmic_link_classification'] != null) ...[const SizedBox(height: 4),
          Text(l.karmicLabel(titleCase(p['karmic_link_classification'].toString())),
            style: const TextStyle(color: AppColors.cosmicPink, fontSize: 9, fontWeight: FontWeight.w600))],
      ]));
  }

  // ═══ CRITICAL PATTERNS ═══
  Widget _criticalPatterns(Map d, AppLocalizations l) {
    final cp = (d['critical_patterns'] as Map?)?.cast<String, dynamic>() ?? {};
    final all = <String>[];
    for (final e in cp.entries) {
      if (e.value is List) for (final item in e.value as List) all.add('${titleCase(e.key.replaceAll('_alerts', ''))}: $item');
    }
    if (all.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader(l.criticalPrefix, l.criticalSuffix, '${all.length} ALERTS'),
      ...all.take(5).map((a) => Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.error.withOpacity(0.06), borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.error.withOpacity(0.2))),
        child: Text(a, style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4)))),
    ]);
  }

  // ═══ GROUP RECOMMENDATIONS ═══
  Widget _groupRecs(Map d, AppLocalizations l) {
    final gr = (d['group_recommendations'] as Map?)?.cast<String, dynamic>() ?? {};
    final practices = (gr['recommended_couple_practices'] as List?) ?? [];
    final comm = gr['recommended_communication_style']?.toString() ?? '';
    final focus = gr['recommended_growth_focus']?.toString() ?? '';
    if (practices.isEmpty && comm.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader(l.groupPrefix, l.groupSuffix, '${practices.length + 2} ITEMS'),
      if (practices.isNotEmpty) Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.aurora.withOpacity(0.06), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.aurora.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.sharedPracticesLabel, style: const TextStyle(color: AppColors.aurora, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          ...practices.take(5).map((p) => Padding(padding: const EdgeInsets.only(bottom: 3),
            child: Text('• $p', style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4)))),
          if (comm.isNotEmpty) ...[const SizedBox(height: 6),
            Text(l.communicationLabel(comm), style: const TextStyle(color: AppColors.lavender, fontSize: 9, fontStyle: FontStyle.italic))],
          if (focus.isNotEmpty) ...[const SizedBox(height: 4),
            Text(l.focusLabel(focus), style: const TextStyle(color: AppColors.gold, fontSize: 9, fontWeight: FontWeight.w600))],
        ])),
    ]);
  }

  // ═══ INDIVIDUAL RECOMMENDATIONS ═══
  Widget _individualRecs(Map d, AppLocalizations l) {
    final recs = (d['individual_recommendations'] as List?) ?? [];
    if (recs.isEmpty) return const SizedBox.shrink();
    final colors = [AppColors.aurora, AppColors.cosmicPink, AppColors.gold, AppColors.lavender, AppColors.saffron];
    return Column(children: [
      ReportHeader(l.individualPrefix, l.individualSuffix, '${recs.length} PERSONS'),
      ...recs.take(5).toList().asMap().entries.map((e) {
        final r = e.value is Map ? (e.value as Map).cast<String, dynamic>() : <String, dynamic>{};
        final c = colors[e.key % colors.length];
        final strengths = (r['key_strengths_in_group'] as List?) ?? [];
        final growth = (r['key_growth_areas_in_group'] as List?) ?? [];
        return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 8), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.withOpacity(0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r['name']?.toString() ?? '?', style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'serif')),
            if (r['karmic_lesson_in_this_group'] != null) ...[const SizedBox(height: 4),
              Text(l.karmicLessonLabel(r['karmic_lesson_in_this_group'].toString()), style: const TextStyle(color: AppColors.lavender, fontSize: 9, fontStyle: FontStyle.italic))],
            if (strengths.isNotEmpty) ...[const SizedBox(height: 6),
              Text(l.strengths.toUpperCase(), style: const TextStyle(color: AppColors.success, fontSize: 7, fontFamily: 'monospace', letterSpacing: 1)),
              ...strengths.take(3).map((s) => Text('★ $s', style: const TextStyle(color: AppColors.ivory, fontSize: 9)))],
            if (growth.isNotEmpty) ...[const SizedBox(height: 4),
              Text(l.growthAreasLabel, style: const TextStyle(color: AppColors.warning, fontSize: 7, fontFamily: 'monospace', letterSpacing: 1)),
              ...growth.take(2).map((g) => Text('→ $g', style: const TextStyle(color: AppColors.smoke, fontSize: 9)))],
          ]));
      }),
    ]);
  }

  // ═══ CORE THEME ═══
  Widget _coreTheme(Map d, AppLocalizations l) {
    final theme = (d['core_group_theme'] as Map?)?.cast<String, dynamic>() ?? {};
    if (theme.isEmpty) return const SizedBox.shrink();
    final isGrowth = theme['is_growth_oriented'] == true;
    final c = isGrowth ? AppColors.success : AppColors.gold;
    return Column(children: [
      ReportHeader(l.corePrefix, l.coreSuffix, 'GROUP'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [c.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.1)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(isGrowth ? '✦ ${l.growthOrientedLabel}' : '● ${l.groupThemeLabel}',
            style: TextStyle(color: c, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(theme['primary_theme']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif')),
          if (theme['explanation'] != null) ...[const SizedBox(height: 4),
            Text(theme['explanation'].toString(), style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic))],
          if (theme['collective_action_direction'] != null) ...[const SizedBox(height: 6),
            Text('→ ${theme['collective_action_direction']}', style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w600))],
        ])),
    ]);
  }

  // ═══ CONFIDENCE ═══
  Widget _confidence(Map d, AppLocalizations l) {
    final raw = (d['confidence_score'] as num?)?.toDouble() ?? 0;
    final stmt = d['confidence_explanation']?.toString() ?? '';
    final bd = (d['confidence_breakdown'] as Map?)?.cast<String, dynamic>() ?? {};
    return Column(children: [
      ReportHeader(l.analysisPrefix, l.analysisConfidenceSuffix, 'QUALITY'),
      ConfidenceBlock(score: raw, statement: stmt, breakdown: bd),
    ]);
  }

  // ═══ AI BAR ═══
  Widget _aiBar(Map d, BuildContext ctx, AppLocalizations l) {
    return Container(margin: const EdgeInsets.fromLTRB(16, 16, 16, 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF1A1642).withOpacity(0.8), const Color(0xFF0A0A24)]),
        borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
      child: Column(children: [
        _label('★ ${l.discussWithAI} ★'), const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _aiBtn(ctx, l, 'G', 'ChatGPT', const LinearGradient(colors: [Color(0xFF10A37F), Color(0xFF1A7F64)]), () => _launchAi(ctx, d, 'chatgpt', l))),
          const SizedBox(width: 8),
          Expanded(child: _aiBtn(ctx, l, 'C', 'Claude', const LinearGradient(colors: [Color(0xFFD97757), Color(0xFFB85B3F)]), () => _launchAi(ctx, d, 'claude', l))),
          const SizedBox(width: 8),
          Expanded(child: _aiBtn(ctx, l, '✦', 'Gemini', const LinearGradient(colors: [Color(0xFF4285F4), Color(0xFF9B72CB)]), () => _launchAi(ctx, d, 'gemini', l))),
        ]),
        const SizedBox(height: 10),
        GestureDetector(onTap: () { Clipboard.setData(ClipboardData(text: _prompt(d)));
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(l.reportCopied))); },
          child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.copy, size: 14, color: AppColors.smoke), const SizedBox(width: 6),
              Text(l.copyFullReportData, style: const TextStyle(color: AppColors.smoke, fontSize: 10))]))),
      ]));
  }

  Widget _aiBtn(BuildContext ctx, AppLocalizations l, String icon, String name, Gradient g, VoidCallback onTap) => GestureDetector(onTap: onTap,
    child: Container(padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.2))),
      child: Column(children: [
        Container(width: 26, height: 26, decoration: BoxDecoration(gradient: g, borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(icon, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)))),
        const SizedBox(height: 5), Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 9, fontWeight: FontWeight.w700)),
        Text(l.openExternalLabel, style: const TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace')),
      ])));

  String _prompt(Map d) {
    final j = const JsonEncoder.withIndent('  ').convert(d);
    return 'You are a Vedic relationship advisor. Analyze this relationship intelligence report for $names.\n\n'
        'Summary: ${d['human_summary'] ?? ""}\nConfidence: ${d['confidence_score'] ?? "?"}\n\nFull JSON:\n$j\n\nExplain dynamics and give advice.';
  }

  Future<void> _launchAi(BuildContext ctx, Map d, String ai, AppLocalizations l) async {
    await Clipboard.setData(ClipboardData(text: _prompt(d)));
    final urls = {'chatgpt': 'https://chat.openai.com/', 'claude': 'https://claude.ai/new', 'gemini': 'https://gemini.google.com/app'};
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(l.copiedOpeningAi(ai)), duration: const Duration(seconds: 3)));
    final uri = Uri.parse(urls[ai]!); if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _label(String text) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)), const SizedBox(width: 6),
    Text(text, style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
    const SizedBox(width: 6), Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)),
  ]);
}
