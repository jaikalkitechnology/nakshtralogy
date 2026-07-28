import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/forecast_labels.dart';
import '../../services/api_service.dart';
import '../specialist/report_components.dart';

class DailyForecastScreen extends StatefulWidget {
  final String chartId, chartName;
  const DailyForecastScreen({super.key, required this.chartId, required this.chartName});
  @override
  State<DailyForecastScreen> createState() => _S();
}

class _S extends State<DailyForecastScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _d;
  bool _loading = true;
  String? _error;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final r = await _api.getDailyForecast(widget.chartId);
      if (!mounted) return;
      if (r['statusCode'] == 200 && r['status'] == 'success')
        setState(() { _d = (r['data'] as Map).cast<String, dynamic>(); _loading = false; });
      else setState(() { _error = r['detail']?.toString() ?? 'Failed'; _loading = false; });
    } catch (e) { if (!mounted) return; setState(() { _error = e.toString(); _loading = false; }); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFF0A0A24),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null ? _errV() : _d != null ? _report() : const SizedBox.shrink());
  }

  Widget _errV() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.error_outline, color: AppColors.error, size: 48), const SizedBox(height: 12),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(_error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center)),
    const SizedBox(height: 16), ElevatedButton(onPressed: _load, child: Text(AppLocalizations.of(context)?.retry ?? 'Retry')),
  ]));

  Widget _report() {
    final l = AppLocalizations.of(context)!;
    final d = _d!;
    final dayScore = (d['day_quality_score'] as num?)?.toDouble() ?? 0;
    final dayOverall = (d['day_quality_overall'] as Map?)?.cast<String, dynamic>() ?? {};
    final grade = dayOverall['day_grade']?.toString() ?? d['day_grade']?.toString() ?? '';
    final theme = dayOverall['day_theme']?.toString() ?? '';
    final summary = d['day_summary']?.toString() ?? '';
    final weekday = d['target_weekday']?.toString() ?? '';
    final targetDate = d['target_date']?.toString() ?? '';
    final actions = (d['key_actions_today'] as List?) ?? [];
    final cautions = (d['key_cautions_today'] as List?) ?? [];
    // house_event_probabilities is a DICT keyed "1"-"12"
    final housesRaw = d['house_event_probabilities'];
    final houses = <Map<String, dynamic>>[];
    if (housesRaw is Map) {
      housesRaw.forEach((k, v) { if (v is Map) houses.add(v.cast<String, dynamic>()); });
    }
    final flags = (d['critical_event_flags'] as List?) ?? [];
    final timing = (d['timing_windows'] as Map?)?.cast<String, dynamic>() ?? {};
    final relationships = (d['relationships_today'] as Map?)?.cast<String, dynamic>() ?? {};
    final opportunities = (d['opportunities_vs_risks'] as Map?)?.cast<String, dynamic>() ?? {};
    final income = (d['income_vs_expense'] as Map?)?.cast<String, dynamic>() ?? {};
    final c = dayScore >= 70 ? AppColors.success : dayScore >= 50 ? AppColors.gold : dayScore >= 35 ? AppColors.warning : AppColors.error;

    return CustomScrollView(slivers: [
      SliverAppBar(backgroundColor: const Color(0xFF0A0A24), pinned: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.chartName.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace')),
          Text.rich(TextSpan(children: [
            const TextSpan(text: "Today's ", style: TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w600)),
            TextSpan(text: l.forecast, style: TextStyle(color: c, fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
          ])),
        ]),
        centerTitle: true, actions: [IconButton(icon: const Icon(Icons.refresh, color: AppColors.ivory, size: 18), onPressed: _load)]),
      SliverList(delegate: SliverChildListDelegate([
        // Day hero
        Container(margin: const EdgeInsets.fromLTRB(16, 12, 16, 12), padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [c.withOpacity(0.15), const Color(0xFF4A3B8C).withOpacity(0.1)]),
            borderRadius: BorderRadius.circular(20), border: Border.all(color: c.withOpacity(0.3))),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 16, height: 1, color: c.withOpacity(0.4)), const SizedBox(width: 6),
              Text('☀ $weekday · $targetDate', style: TextStyle(color: c, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              const SizedBox(width: 6), Container(width: 16, height: 1, color: c.withOpacity(0.4)),
            ]),
            const SizedBox(height: 14),
            SizedBox(width: 100, height: 100, child: Stack(alignment: Alignment.center, children: [
              SizedBox(width: 100, height: 100, child: CircularProgressIndicator(value: dayScore / 100, strokeWidth: 8,
                backgroundColor: Colors.white.withOpacity(0.08), valueColor: AlwaysStoppedAnimation(c))),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text(dayScore.toStringAsFixed(0), style: TextStyle(color: c, fontSize: 28, fontWeight: FontWeight.w700, fontFamily: 'serif')),
                Text(grade, style: TextStyle(color: c, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              ]),
            ])),
            if (theme.isNotEmpty) ...[const SizedBox(height: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Text(theme, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w600)))],
            if (summary.isNotEmpty) ...[const SizedBox(height: 8),
              Text(summary, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.5))],
          ])),
        // Actions
        if (actions.isNotEmpty) ...[
          ReportHeader(l.fcKey, l.fcActions, '${actions.length}'),
          ...actions.take(6).map((a) => Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.06), borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.success.withOpacity(0.2))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('✓ ', style: TextStyle(color: AppColors.success, fontSize: 12)),
              Expanded(child: Text(a.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4))),
            ]))),
        ],
        // Cautions
        if (cautions.isNotEmpty) ...[
          ReportHeader(l.fcKey, l.fcCautions, '${cautions.length}'),
          ...cautions.take(6).map((a) => Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.06), borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.warning.withOpacity(0.2))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('⚠ ', style: TextStyle(color: AppColors.warning, fontSize: 12)),
              Expanded(child: Text(a.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4))),
            ]))),
        ],
        // 12 House probabilities
        if (houses.isNotEmpty) ...[
          ReportHeader(l.fc12House, l.fcProbabilities, '${houses.length} ${l.fcHousesCaps}'),
          ...houses.map((h) {
            final hNum = h['house']?.toString() ?? '?';
            final domain = h['domain']?.toString() ?? '';
            final sig = h['h${hNum}_event_signature']?.toString() ?? h['event_signature']?.toString() ?? '';
            // Find the main probability score
            final scores = h.entries.where((e) => e.value is num && e.key.contains('probability')).toList();
            final topScore = scores.isNotEmpty ? scores.map((e) => (e.value as num).toDouble()).reduce((a, b) => a > b ? a : b) : 50.0;
            final hc = topScore >= 70 ? AppColors.success : topScore >= 50 ? AppColors.gold : topScore >= 35 ? AppColors.warning : AppColors.error;
            return GestureDetector(
              onTap: () => _showHouseDetail(h, hc),
              child: Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: hc.withOpacity(0.06), borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: hc.withOpacity(0.2))),
                child: Row(children: [
                  Container(width: 32, height: 32, decoration: BoxDecoration(color: hc.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                    child: Center(child: Text('H$hNum', style: TextStyle(color: hc, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace')))),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(ForecastLabels.label(domain, Localizations.localeOf(context), domain), style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w600)),
                    if (sig.isNotEmpty) Text(sig, style: TextStyle(color: hc, fontSize: 9, fontStyle: FontStyle.italic)),
                  ])),
                  Text('${topScore.toStringAsFixed(0)}%', style: TextStyle(color: hc, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, size: 14, color: AppColors.smoke),
                ])));
          }),
        ],
        // Income vs expense
        if (income.isNotEmpty) _incomeCard(income),
        // Relationships
        if (relationships.isNotEmpty) _relationshipsCard(relationships),
        // Opportunities
        if (opportunities.isNotEmpty) _opportunitiesCard(opportunities),
        // Timing windows
        if (timing.isNotEmpty) _timingCard(timing),
        // Critical flags
        if (flags.isNotEmpty) ...[
          ReportHeader(l.fcCritical, l.fcFlags, '${flags.length}'),
          ...flags.take(5).map((f) {
            final text = f is Map ? (f as Map)['description']?.toString() ?? f.toString() : f.toString();
            return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.error.withOpacity(0.06), borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.error.withOpacity(0.2))),
              child: Text(text, style: const TextStyle(color: AppColors.ivory, fontSize: 11)));
          }),
        ],
        // Confidence
        if (d['confidence_score'] is num) ...[
          ReportHeader(l.fcAnalysis, l.fcConfidence, l.fcQualityCaps),
          ConfidenceBlock(score: (d['confidence_score'] as num).toDouble(),
            statement: d['confidence_explanation']?.toString(),
            breakdown: (d['confidence_breakdown'] is Map) ? (d['confidence_breakdown'] as Map).cast<String, dynamic>() : {}),
        ],
        const SizedBox(height: 30),
      ])),
    ]);
  }

  Widget _incomeCard(Map<String, dynamic> data) {
    final l = AppLocalizations.of(context)!;
    final inc = (data['income_forecast'] as Map?)?.cast<String, dynamic>() ?? {};
    final exp = (data['expense_forecast'] as Map?)?.cast<String, dynamic>() ?? {};
    final bal = (data['net_financial_balance_today'] as Map?)?.cast<String, dynamic>() ?? {};
    final expl = data['explanation']?.toString() ?? '';
    final incScore = (inc['composite_income_score'] as num?)?.toDouble() ?? 0;
    final expScore = (exp['composite_expense_score'] as num?)?.toDouble() ?? 0;
    final balScore = (bal['balance_score'] as num?)?.toDouble() ?? 0;
    final ic = incScore >= 60 ? AppColors.success : AppColors.gold;
    final ec = expScore >= 60 ? AppColors.error : AppColors.warning;
    final bc = balScore >= 60 ? AppColors.success : balScore >= 40 ? AppColors.gold : AppColors.error;
    return Column(children: [
      ReportHeader(l.fcIncomeVs, l.fcExpense, l.fcFinance),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: _miniScore(l.fcIncomeCaps, incScore, ic, inc['income_likelihood']?.toString())),
            Container(width: 1, height: 50, color: Colors.white12),
            Expanded(child: _miniScore(l.fcExpenseCaps, expScore, ec, exp['expense_likelihood']?.toString())),
          ]),
          const SizedBox(height: 8),
          _kvRow(l.fcNetBalance, '${balScore.toStringAsFixed(0)}', bc),
          if (bal['balance_signature'] != null) _kvRow(l.fcSignature, bal['balance_signature'].toString(), AppColors.lavender),
          if (bal['financial_advice'] != null) Padding(padding: const EdgeInsets.only(top: 4),
            child: Text(bal['financial_advice'].toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.3, fontStyle: FontStyle.italic))),
          if (inc['best_time_window_for_income'] != null) ...[const SizedBox(height: 6),
            _kvRow(l.fcBestTimeForIncome, inc['best_time_window_for_income'].toString(), AppColors.success)],
          if (exp['expense_caution_window'] != null)
            _kvRow(l.fcExpenseCaution, exp['expense_caution_window'].toString(), AppColors.warning),
          if (inc['income_drivers'] is List) ...[const SizedBox(height: 4),
            Wrap(spacing: 4, runSpacing: 4, children: (inc['income_drivers'] as List).take(3).map((d) => _chip(d.toString(), AppColors.success)).toList())],
          if (exp['expense_drivers'] is List)
            Wrap(spacing: 4, runSpacing: 4, children: (exp['expense_drivers'] as List).take(3).map((d) => _chip(d.toString(), AppColors.warning)).toList()),
          if (expl.isNotEmpty) ...[const SizedBox(height: 6),
            Text(expl, style: const TextStyle(color: AppColors.smoke, fontSize: 9, height: 1.3))],
        ])),
    ]);
  }

  Widget _relationshipsCard(Map<String, dynamic> data) {
    final l = AppLocalizations.of(context)!;
    final scores = <MapEntry<String, double>>[];
    data.forEach((k, v) { if (v is num) scores.add(MapEntry(k, v.toDouble())); });
    final bestDomain = data['best_domain_for_meetings']?.toString();
    final avoid = data['domains_to_avoid_for_conversations'];
    final expl = data['explanation']?.toString() ?? '';
    return Column(children: [
      ReportHeader(l.fcRelationships, l.today, '${scores.length} ${l.fcAreasCaps}'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ...scores.map((e) {
            final sc = e.value >= 70 ? AppColors.success : e.value >= 50 ? AppColors.gold : e.value >= 30 ? AppColors.warning : AppColors.error;
            return Padding(padding: const EdgeInsets.only(bottom: 6), child: Column(children: [
              Row(children: [
                Expanded(child: Text(ForecastLabels.label(e.key, Localizations.localeOf(context), _tc(e.key)), style: const TextStyle(color: AppColors.ivory, fontSize: 10))),
                Text(e.value.toStringAsFixed(0), style: TextStyle(color: sc, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
              ]),
              const SizedBox(height: 2),
              ClipRRect(borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(value: (e.value / 100).clamp(0, 1), minHeight: 3, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(sc))),
            ]));
          }),
          if (bestDomain != null) ...[const SizedBox(height: 4), _kvRow(l.fcBestForMeetings, bestDomain, AppColors.success)],
          if (avoid is List && avoid.isNotEmpty && avoid.first != 'none flagged')
            Wrap(spacing: 4, runSpacing: 4, children: [
              Text('${AppLocalizations.of(context)?.weaknesses ?? 'Avoid'}: ', style: const TextStyle(color: AppColors.warning, fontSize: 9)),
              ...avoid.take(3).map((a) => _chip(a.toString(), AppColors.warning)),
            ]),
          if (expl.isNotEmpty) ...[const SizedBox(height: 6),
            Text(expl, style: const TextStyle(color: AppColors.smoke, fontSize: 9, height: 1.3))],
        ])),
    ]);
  }

  Widget _opportunitiesCard(Map<String, dynamic> data) {
    final l = AppLocalizations.of(context)!;
    final opp = (data['opportunities_today'] as Map?)?.cast<String, dynamic>() ?? {};
    final risk = (data['risks_today'] as Map?)?.cast<String, dynamic>() ?? {};
    final expl = data['explanation']?.toString() ?? '';
    final oppScore = (opp['new_opportunity_score'] as num?)?.toDouble() ?? 0;
    final riskScore = (risk['composite_risk_score'] as num?)?.toDouble() ?? 0;
    final oc = oppScore >= 60 ? AppColors.success : AppColors.gold;
    final rc = riskScore >= 60 ? AppColors.error : AppColors.warning;
    final topOpp = (opp['top_opportunity_domains'] as List?) ?? [];
    final topRisk = (risk['top_risk_domains'] as List?) ?? [];
    return Column(children: [
      ReportHeader(l.fcOpportunitiesVs, l.fcRisks, l.fcOutlook),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: _miniScore(l.fcOpportunityCaps, oppScore, oc, opp['opportunity_signature']?.toString())),
            Container(width: 1, height: 50, color: Colors.white12),
            Expanded(child: _miniScore(l.fcRiskCaps, riskScore, rc, risk['risk_signature']?.toString())),
          ]),
          if (topOpp.isNotEmpty) ...[const SizedBox(height: 8),
            Text(AppLocalizations.of(context)?.topOpportunities ?? 'TOP OPPORTUNITIES', style: const TextStyle(color: AppColors.success, fontSize: 8, letterSpacing: 1)),
            const SizedBox(height: 4),
            ...topOpp.take(3).map((o) {
              if (o is! Map) return const SizedBox.shrink();
              final m = (o as Map).cast<String, dynamic>();
              return Padding(padding: const EdgeInsets.only(bottom: 3), child: Row(children: [
                const Text('+ ', style: TextStyle(color: AppColors.success, fontSize: 10)),
                Expanded(child: Text('${ForecastLabels.label((m['domain'] ?? '').toString(), Localizations.localeOf(context), (m['domain'] ?? '').toString())}: ${m['event'] ?? ''}', style: const TextStyle(color: AppColors.ivory, fontSize: 10), overflow: TextOverflow.ellipsis, maxLines: 2)),
                if (m['score'] is num) Text('${(m['score'] as num).toStringAsFixed(0)}', style: TextStyle(color: oc, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
              ]));
            }),
          ],
          if (topRisk.isNotEmpty) ...[const SizedBox(height: 8),
            Text(AppLocalizations.of(context)?.topRisks ?? 'TOP RISKS', style: const TextStyle(color: AppColors.error, fontSize: 8, letterSpacing: 1)),
            const SizedBox(height: 4),
            ...topRisk.take(3).map((o) {
              if (o is! Map) return const SizedBox.shrink();
              final m = (o as Map).cast<String, dynamic>();
              return Padding(padding: const EdgeInsets.only(bottom: 3), child: Row(children: [
                const Text('- ', style: TextStyle(color: AppColors.error, fontSize: 10)),
                Expanded(child: Text('${ForecastLabels.label((m['domain'] ?? '').toString(), Localizations.localeOf(context), (m['domain'] ?? '').toString())}: ${m['event'] ?? ''}', style: const TextStyle(color: AppColors.ivory, fontSize: 10), overflow: TextOverflow.ellipsis, maxLines: 2)),
                if (m['score'] is num) Text('${(m['score'] as num).toStringAsFixed(0)}', style: TextStyle(color: rc, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
              ]));
            }),
          ],
          if (opp['recommended_action'] != null) ...[const SizedBox(height: 6),
            _kvRow(l.fcAction, opp['recommended_action'].toString(), AppColors.success)],
          if (risk['recommended_protective_action'] != null)
            _kvRow(l.fcProtect, risk['recommended_protective_action'].toString(), AppColors.warning),
          if (expl.isNotEmpty) ...[const SizedBox(height: 6),
            Text(expl, style: const TextStyle(color: AppColors.smoke, fontSize: 9, height: 1.3))],
        ])),
    ]);
  }

  Widget _timingCard(Map<String, dynamic> data) {
    final l = AppLocalizations.of(context)!;
    final best = (data['best_time_windows'] as List?) ?? [];
    final worst = (data['worst_time_windows'] as List?) ?? [];
    final expl = data['explanation']?.toString() ?? '';
    return Column(children: [
      ReportHeader(l.fcTiming, l.fcWindows, '${best.length + worst.length} ${l.fcSlotsCaps}'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (best.isNotEmpty) ...[
            Text(AppLocalizations.of(context)?.bestWindows ?? 'BEST WINDOWS', style: const TextStyle(color: AppColors.success, fontSize: 8, letterSpacing: 1)),
            const SizedBox(height: 4),
            ...best.take(3).map((w) {
              if (w is! Map) return const SizedBox.shrink();
              final m = (w as Map).cast<String, dynamic>();
              final qs = (m['quality_score'] as num?)?.toDouble() ?? 0;
              final qc = qs >= 70 ? AppColors.success : AppColors.gold;
              return Container(margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.06), borderRadius: BorderRadius.circular(8)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(m['window']?.toString() ?? '', style: TextStyle(color: qc, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
                    const Spacer(),
                    Text('${qs.toStringAsFixed(0)}', style: TextStyle(color: qc, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'serif')),
                  ]),
                  if (m['driver'] != null) Text(m['driver'].toString(), style: const TextStyle(color: AppColors.smoke, fontSize: 8, height: 1.3)),
                  if (m['favoured_actions'] is List) Wrap(spacing: 4, runSpacing: 3, children:
                    (m['favoured_actions'] as List).take(3).map((a) => _chip(a.toString(), AppColors.success)).toList()),
                ]));
            }),
          ],
          if (worst.isNotEmpty) ...[const SizedBox(height: 6),
            Text(AppLocalizations.of(context)?.worstWindows ?? 'WORST WINDOWS', style: const TextStyle(color: AppColors.error, fontSize: 8, letterSpacing: 1)),
            const SizedBox(height: 4),
            ...worst.take(3).map((w) {
              if (w is! Map) return const SizedBox.shrink();
              final m = (w as Map).cast<String, dynamic>();
              final qs = (m['quality_score'] as num?)?.toDouble() ?? 0;
              final qc = qs >= 40 ? AppColors.warning : AppColors.error;
              return Container(margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.error.withOpacity(0.06), borderRadius: BorderRadius.circular(8)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(m['window']?.toString() ?? '', style: TextStyle(color: qc, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
                    const Spacer(),
                    Text('${qs.toStringAsFixed(0)}', style: TextStyle(color: qc, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'serif')),
                  ]),
                  if (m['driver'] != null) Text(m['driver'].toString(), style: const TextStyle(color: AppColors.smoke, fontSize: 8, height: 1.3)),
                  if (m['avoid_actions'] is List) Wrap(spacing: 4, runSpacing: 3, children:
                    (m['avoid_actions'] as List).take(3).map((a) => _chip(a.toString(), AppColors.error)).toList()),
                ]));
            }),
          ],
          if (expl.isNotEmpty) ...[const SizedBox(height: 6),
            Text(expl, style: const TextStyle(color: AppColors.smoke, fontSize: 9, height: 1.3))],
        ])),
    ]);
  }

  Widget _miniScore(String label, double score, Color c, String? sub) => Column(children: [
    Text(label, style: TextStyle(color: c, fontSize: 8, letterSpacing: 1, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
    const SizedBox(height: 4),
    Text(score.toStringAsFixed(0), style: TextStyle(color: c, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'serif')),
    if (sub != null) Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(sub, style: TextStyle(color: c.withOpacity(0.7), fontSize: 8), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)),
  ]);

  Widget _kvRow(String label, String value, Color vc) => Padding(padding: const EdgeInsets.only(bottom: 3),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 100, child: Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace'))),
      Expanded(child: Text(value, style: TextStyle(color: vc, fontSize: 10, fontWeight: FontWeight.w600), maxLines: 3, overflow: TextOverflow.ellipsis)),
    ]));

  Widget _chip(String text, Color c) => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: c.withOpacity(0.25))),
    child: Text(text, style: TextStyle(color: c, fontSize: 8, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis));

  void _showHouseDetail(Map<String, dynamic> h, Color c) {
    final hNum = h['house']?.toString() ?? '?';
    final domain = h['domain']?.toString() ?? '';
    showModalBottomSheet(context: context, isScrollControlled: true,
      backgroundColor: const Color(0xFF0A0A24),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7, minChildSize: 0.4, maxChildSize: 0.95, expand: false,
        builder: (_, sc) => ListView(controller: sc, padding: const EdgeInsets.all(16), children: [
          Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
          Text('${AppLocalizations.of(context)!.fcHouse} $hNum · ${ForecastLabels.label(domain, Localizations.localeOf(context), domain)}', style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'serif')),
          const SizedBox(height: 12),
          ...h.entries.where((e) => e.key != 'house' && e.key != 'domain').map((e) {
            if (e.value is num) {
              final v = (e.value as num).toDouble();
              final bc = v >= 70 ? AppColors.success : v >= 50 ? AppColors.gold : v >= 30 ? AppColors.warning : AppColors.error;
              return Padding(padding: const EdgeInsets.only(bottom: 6), child: Column(children: [
                Row(children: [
                  Expanded(child: Text(ForecastLabels.label(e.key, Localizations.localeOf(context), _tc(e.key)), style: const TextStyle(color: AppColors.ivory, fontSize: 10))),
                  Text(v.toStringAsFixed(1), style: TextStyle(color: bc, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
                ]),
                ClipRRect(borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(bc))),
              ]));
            }
            if (e.value is String && (e.value as String).isNotEmpty) {
              return Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 90, child: Text(ForecastLabels.label(e.key, Localizations.localeOf(context), _tc(e.key)), style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace'))),
                Expanded(child: Text(e.value.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.3))),
              ]));
            }
            return const SizedBox.shrink();
          }),
        ])));
  }

  static String _tc(String s) => s.replaceAll('_', ' ').split(' ')
    .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
}
