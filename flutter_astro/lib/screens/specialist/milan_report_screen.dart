import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../l10n/gen/app_localizations.dart';
import 'report_components.dart';

class MilanReportScreen extends StatelessWidget {
  final String name1, name2;
  final Map<String, dynamic> data;
  const MilanReportScreen({super.key, required this.name1, required this.name2, required this.data});

  @override
  Widget build(BuildContext context) {
    final d = data;
    final l = AppLocalizations.of(context)!;
    return Scaffold(backgroundColor: const Color(0xFF0A0A24),
      body: CustomScrollView(slivers: [
        SliverAppBar(backgroundColor: const Color(0xFF0A0A24), pinned: true,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
          title: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
            Text('$name1 & $name2'.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace')),
            Text.rich(TextSpan(children: [
              TextSpan(text: '${l.milanTitlePrefix} ', style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w600)),
              TextSpan(text: l.milan, style: const TextStyle(color: AppColors.gold, fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
            ])),
          ]),
          centerTitle: true),
        SliverList(delegate: SliverChildListDelegate([
          _unifiedScore(d, l), _ashtakoot(d, l), _gunBreakdown(d, l), _mangalSection(d, l),
          _d9Cross(d, l), _domains(d, l), _timingWindows(d, l), _risks(d, l),
          _verdict(d, l), _confidence(d, l), _aiBar(d, context, l),
          const SizedBox(height: 30),
        ])),
      ]));
  }

  // ═══ UNIFIED SCORE ═══
  Widget _unifiedScore(Map d, AppLocalizations l) {
    final score = (d['unified_compatibility_score'] as num?)?.toDouble() ?? 0;
    final grade = d['unified_grade']?.toString() ?? '';
    final ashtakoot = (d['ashtakoot_total_score'] as num?)?.toDouble() ?? 0;
    final ashtakootGrade = d['ashtakoot_classical_grade']?.toString() ?? '';
    final c = score >= 70 ? AppColors.success : score >= 50 ? AppColors.gold : AppColors.warning;
    return Container(margin: const EdgeInsets.fromLTRB(16, 12, 16, 12), padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.cosmicPink.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.15)]),
        borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.cosmicPink.withOpacity(0.3))),
      child: Column(children: [
        _label('⚭ ${l.compatibilityLabel}'),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _bigRing(score, l.unifiedScoreLabel, c),
          Column(children: [
            Text('${ashtakoot.toStringAsFixed(1)}/36', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'serif')),
            Text(l.ashtakoot.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace', letterSpacing: 1)),
            const SizedBox(height: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: c.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
              child: Text(grade, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700))),
            const SizedBox(height: 4),
            Text(ashtakootGrade, style: const TextStyle(color: AppColors.smoke, fontSize: 9)),
          ]),
        ]),
        if (d['unified_signature'] != null) ...[const SizedBox(height: 10),
          Text(d['unified_signature'].toString(), textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic))],
      ]));
  }

  Widget _bigRing(double v, String label, Color c) => Column(children: [
    SizedBox(width: 90, height: 90, child: Stack(alignment: Alignment.center, children: [
      SizedBox(width: 90, height: 90, child: CircularProgressIndicator(value: v / 100, strokeWidth: 7,
        backgroundColor: Colors.white.withOpacity(0.08), valueColor: AlwaysStoppedAnimation(c))),
      Text('${v.toStringAsFixed(0)}', style: TextStyle(color: c, fontSize: 26, fontWeight: FontWeight.w700, fontFamily: 'serif')),
    ])),
    const SizedBox(height: 6),
    Text(label, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace', letterSpacing: 1, height: 1.2)),
  ]);

  // ═══ ASHTAKOOT SUMMARY ═══
  Widget _ashtakoot(Map d, AppLocalizations l) {
    final prob = (d['ashtakoot_total_probability'] as num?)?.toDouble() ?? 0;
    final nadi = d['nadi_dosh_present'] == true;
    final bhakoot = d['bhakoot_dosh_present'] == true;
    final gana = d['gana_dosh_signature']?.toString() ?? '';
    return Column(children: [
      ReportHeader(l.ashtakoot, l.summary, '36 MAX'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withOpacity(0.15))),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(l.probabilityLabel, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace')),
            Text('${prob.toStringAsFixed(1)}%', style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            _doshChip('Nadi', nadi), const SizedBox(width: 6),
            _doshChip('Bhakoot', bhakoot), const SizedBox(width: 6),
            if (gana.isNotEmpty) Expanded(child: Text(l.ganaLabel(gana), style: const TextStyle(color: AppColors.smoke, fontSize: 8), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
        ])),
    ]);
  }

  Widget _doshChip(String name, bool present) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: present ? AppColors.error.withOpacity(0.12) : AppColors.success.withOpacity(0.12),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: present ? AppColors.error.withOpacity(0.3) : AppColors.success.withOpacity(0.3))),
    child: Text('${present ? "⚠" : "✓"} $name', style: TextStyle(
      color: present ? AppColors.error : AppColors.success, fontSize: 9, fontWeight: FontWeight.w700)));

  // ═══ 8 GUN BREAKDOWN ═══
  Widget _gunBreakdown(Map d, AppLocalizations l) {
    final guns = (d['ashtakoot_breakdown'] as List?) ?? [];
    if (guns.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader(l.gunPrefixLabel, l.breakdownLabel, '${guns.length} GUNS'),
      ...guns.map((g) {
        if (g is! Map) return const SizedBox.shrink();
        final gun = g.cast<String, dynamic>();
        final score = (gun['score'] as num?)?.toDouble() ?? 0;
        final max = (gun['max'] as num?)?.toInt() ?? 1;
        final pct = max > 0 ? score / max : 0.0;
        final hasDosh = gun['has_dosha'] == true;
        final c = pct >= 0.75 ? AppColors.success : pct >= 0.5 ? AppColors.gold : AppColors.error;
        return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.withOpacity(0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('${gun['gun_num'] ?? ""}. ', style: TextStyle(color: c, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.w700)),
              Expanded(child: Text(gun['gun']?.toString() ?? '', style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'serif'))),
              Text('${score.toStringAsFixed(1)}/$max', style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'serif')),
              if (hasDosh) const Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.warning, color: AppColors.error, size: 12)),
            ]),
            ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: pct, minHeight: 3, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
            const SizedBox(height: 4),
            Row(children: [
              _valChip(gun['p1_val']?.toString() ?? '', AppColors.aurora),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Icon(Icons.compare_arrows, size: 12, color: AppColors.smoke)),
              _valChip(gun['p2_val']?.toString() ?? '', AppColors.cosmicPink),
            ]),
            if (gun['status'] != null) Text(gun['status'].toString(), style: TextStyle(color: c, fontSize: 9, fontWeight: FontWeight.w600)),
            if (hasDosh && gun['remedy'] != null && gun['remedy'].toString().isNotEmpty)
              Padding(padding: const EdgeInsets.only(top: 4),
                child: Text('✦ ${gun['remedy']}', style: const TextStyle(color: AppColors.gold, fontSize: 8, fontStyle: FontStyle.italic))),
          ]));
      }),
    ]);
  }

  Widget _valChip(String text, Color c) => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
    child: Text(text, style: TextStyle(color: c, fontSize: 8, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis));

  // ═══ MANGAL SECTION ═══
  Widget _mangalSection(Map d, AppLocalizations l) {
    final m1 = d['partner1_net_mangal_status']?.toString() ?? '';
    final m2 = d['partner2_net_mangal_status']?.toString() ?? '';
    final cross = d['mangal_cross_chart_signature']?.toString() ?? '';
    final compat = (d['mangal_compatibility_score'] as num?)?.toDouble() ?? 0;
    return Column(children: [
      ReportHeader(l.mangalLabel, l.dosh, '8 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Expanded(child: _mangalCard(name1, m1, (d['partner1_mangal_severity_score'] as num?)?.toDouble() ?? 0, l)),
          const SizedBox(width: 8),
          Expanded(child: _mangalCard(name2, m2, (d['partner2_mangal_severity_score'] as num?)?.toDouble() ?? 0, l)),
        ])),
      if (cross.isNotEmpty) Container(margin: const EdgeInsets.fromLTRB(16, 8, 16, 4), padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.06), borderRadius: BorderRadius.circular(8),
          border: const Border(left: BorderSide(color: AppColors.gold, width: 3))),
        child: Row(children: [
          Expanded(child: Text(cross, style: const TextStyle(color: AppColors.ivory, fontSize: 10, fontStyle: FontStyle.italic))),
          const SizedBox(width: 8),
          Text('${compat.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
        ])),
    ]);
  }

  Widget _mangalCard(String name, String status, double severity, AppLocalizations l) {
    final manglik = status.toLowerCase().contains('manglik') && !status.toLowerCase().contains('non');
    final c = manglik ? AppColors.error : AppColors.success;
    return Container(padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withOpacity(0.3))),
      child: Column(children: [
        Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Icon(manglik ? Icons.warning : Icons.check_circle, color: c, size: 20),
        Text(titleCase(status), style: TextStyle(color: c, fontSize: 9, fontWeight: FontWeight.w700)),
        if (manglik) Text(l.severityLabel(severity.toStringAsFixed(0)), style: TextStyle(color: c, fontSize: 8, fontFamily: 'monospace')),
      ]));
  }

  // ═══ D9 CROSS ═══
  Widget _d9Cross(Map d, AppLocalizations l) {
    final d9score = (d['d9_compatibility_score'] as num?)?.toDouble() ?? 0;
    final sig = d['d9_classical_signature']?.toString() ?? '';
    return Column(children: [
      ReportHeader(l.d9Label, l.crossChartLabel, 'NAVAMSA'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.lavender.withOpacity(0.2))),
        child: Column(children: [
          Row(children: [
            Text(l.d9CompatibilityLabel, style: const TextStyle(color: AppColors.lavender, fontSize: 9, fontFamily: 'monospace')),
            const Spacer(),
            Text('${d9score.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.lavender, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif')),
          ]),
          ClipRRect(borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(value: d9score / 100, minHeight: 4, backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation(d9score >= 60 ? AppColors.success : d9score >= 40 ? AppColors.gold : AppColors.warning))),
          if (sig.isNotEmpty) ...[const SizedBox(height: 6),
            Text(sig, style: const TextStyle(color: AppColors.lavender, fontSize: 9, fontStyle: FontStyle.italic, height: 1.4))],
          // Cross dignities
          if (d['partner1_d9_venus_dignity'] != null) ...[const SizedBox(height: 8),
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name1, style: const TextStyle(color: AppColors.aurora, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
                if (d['partner1_d9_venus_dignity'] != null) DignityBadge('Venus', d['partner1_d9_venus_dignity'].toString()),
                if (d['partner1_d9_darakaraka_dignity'] != null) DignityBadge('DK', d['partner1_d9_darakaraka_dignity'].toString()),
              ])),
              const SizedBox(width: 8),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name2, style: const TextStyle(color: AppColors.cosmicPink, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
                if (d['partner2_d9_venus_dignity'] != null) DignityBadge('Venus', d['partner2_d9_venus_dignity'].toString()),
                if (d['partner2_d9_darakaraka_dignity'] != null) DignityBadge('DK', d['partner2_d9_darakaraka_dignity'].toString()),
              ])),
            ])],
        ])),
    ]);
  }

  // ═══ DOMAIN COMPATIBILITY ═══
  Widget _domains(Map d, AppLocalizations l) {
    final items = [
      [l.domainEmotional, d['emotional_compatibility_score']], [l.domainIntellectual, d['intellectual_compatibility_score']],
      [l.domainSpiritual, d['spiritual_alignment_score']], [l.domainFinancial, d['financial_alignment_score']],
      [l.domainDomestic, d['domestic_living_compatibility_score']], [l.domainCommunication, d['communication_alignment_score']],
      [l.domainSharedDharma, d['shared_dharma_alignment_score']], [l.domainFamilyCreation, d['family_creation_alignment_score']],
    ].where((i) => i[1] is num).toList();
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader(l.domainLabel, l.compatibilitySuffixLabel, '${items.length} AXES'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: items.map((i) {
          final v = (i[1] as num).toDouble();
          final c = v >= 65 ? AppColors.success : v >= 50 ? AppColors.gold : AppColors.warning;
          return Padding(padding: const EdgeInsets.only(bottom: 5), child: Row(children: [
            SizedBox(width: 80, child: Text(i[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 10))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
            const SizedBox(width: 8),
            SizedBox(width: 28, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right,
              style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
          ]));
        }).toList())),
    ]);
  }

  // ═══ TIMING ═══
  Widget _timingWindows(Map d, AppLocalizations l) {
    final windows = (d['joint_marriage_windows'] as List?) ?? [];
    final engagement = (d['joint_engagement_windows'] as List?) ?? [];
    if (windows.isEmpty && engagement.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader(l.marriageLabel, l.timingLabel, '${windows.length + engagement.length} WINDOWS'),
      if (windows.isNotEmpty) TimingWindowCard(title: l.jointMarriageWindowsTitle, icon: '★', color: AppColors.gold, items: windows, isPeak: true),
      if (engagement.isNotEmpty) TimingWindowCard(title: l.engagementWindowsTitle, icon: '◉', color: AppColors.aurora, items: engagement),
      if (d['recommended_marriage_year_range'] != null) Container(
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 8), padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.06), borderRadius: BorderRadius.circular(8),
          border: const Border(left: BorderSide(color: AppColors.gold, width: 3))),
        child: Text(l.recommendedLabel(d['recommended_marriage_year_range'].toString()),
          style: const TextStyle(color: AppColors.ivory, fontSize: 10, fontStyle: FontStyle.italic))),
    ]);
  }

  // ═══ RISKS ═══
  Widget _risks(Map d, AppLocalizations l) {
    final top3 = (d['top_3_risks_to_address'] as List?) ?? [];
    if (top3.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader(l.key, l.risksLabel, '${top3.length} ITEMS'),
      ...top3.map((r) {
        if (r is! Map) return const SizedBox.shrink();
        final risk = r.cast<String, dynamic>();
        return RiskCard(
          type: risk['risk']?.toString() ?? '', severity: 'moderate',
          description: risk['mitigation']?.toString() ?? '');
      }),
    ]);
  }

  // ═══ VERDICT ═══
  Widget _verdict(Map d, AppLocalizations l) {
    final verdict = d['compatibility_verdict']?.toString() ?? '';
    final proceed = d['proceed_with_marriage_recommendation']?.toString() ?? '';
    final explanation = d['verdict_explanation']?.toString() ?? '';
    if (verdict.isEmpty) return const SizedBox.shrink();
    final c = proceed.toLowerCase().contains('recommended') ? AppColors.success : AppColors.gold;
    return Column(children: [
      ReportHeader(l.finalLabel, l.verdictLabel, 'DECISION'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [c.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.1)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label('★ ${l.marriageVerdictLabel} ★'),
          const SizedBox(height: 8),
          Text(titleCase(verdict), style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'serif')),
          const SizedBox(height: 4),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: c.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
            child: Text(titleCase(proceed), style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700))),
          if (explanation.isNotEmpty) ...[const SizedBox(height: 8),
            Text(explanation, style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic))],
        ])),
    ]);
  }

  // ═══ CONFIDENCE ═══
  Widget _confidence(Map d, AppLocalizations l) {
    final raw = (d['confidence_score'] as num?)?.toDouble() ?? 0;
    final pct = raw <= 1.0 ? raw * 100 : raw;
    final stmt = d['plain_statement']?.toString() ?? '';
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
        _label('★ ${l.discussReportWithAI} ★'), const SizedBox(height: 12),
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
    return 'You are a Vedic marriage compatibility advisor. Analyze this Kundli Milan for $name1 & $name2.\n\n'
        'Score: ${d['unified_compatibility_score'] ?? "?"}/100 (${d['unified_grade'] ?? ""})\n'
        'Ashtakoot: ${d['ashtakoot_total_score'] ?? "?"}/36\n'
        'Verdict: ${d['compatibility_verdict'] ?? ""}\n\nFull JSON:\n$j\n\nExplain and give actionable advice.';
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
