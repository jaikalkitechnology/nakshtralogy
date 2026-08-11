import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/forecast_labels.dart';
import '../../utils/kundli_names.dart';
import '../../services/api_service.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Today Forecast — premium, beginner-friendly redesign.
///
/// Presentation only: every card is derived from the existing daily-forecast
/// engine payload (`/forecast/daily/{chart_id}`). No calculation, scoring,
/// probability, dasha or transit logic is changed here.
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
      if (r['statusCode'] == 200 && r['status'] == 'success') {
        setState(() { _d = (r['data'] as Map).cast<String, dynamic>(); _loading = false; });
      } else {
        setState(() { _error = r['detail']?.toString() ?? AppLocalizations.of(context)?.failedToLoad ?? 'Failed'; _loading = false; });
      }
    } catch (e) { if (!mounted) return; setState(() { _error = e.toString(); _loading = false; }); }
  }

  // ── data accessors ────────────────────────────────────────────────
  Map<String, dynamic> get _confluence =>
      (_d?['three_layer_confluence'] as Map?)?.cast<String, dynamic>() ?? {};
  Map<String, dynamic> get _houseEvents =>
      (_d?['house_event_probabilities'] as Map?)?.cast<String, dynamic>() ?? {};

  double _conf(int h) => ((_confluence['$h'] as Map?)?['confluence_score'] as num?)?.toDouble() ?? 50;

  // Strongest / weakest life area (by confluence) — drives hero + focus.
  int _topHouse() {
    int best = 1; double bv = -1;
    for (var h = 1; h <= 12; h++) { final v = _conf(h); if (v > bv) { bv = v; best = h; } }
    return best;
  }
  int _weakHouse() {
    int worst = 1; double wv = 999;
    for (var h = 1; h <= 12; h++) { final v = _conf(h); if (v < wv) { wv = v; worst = h; } }
    return worst;
  }
  List<int> _rankedHouses({bool ascending = false}) {
    final hs = [for (var h = 1; h <= 12; h++) h];
    hs.sort((a, b) => ascending ? _conf(a).compareTo(_conf(b)) : _conf(b).compareTo(_conf(a)));
    return hs;
  }

  // ── build ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: (_d == null) ? null : FloatingActionButton.extended(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.midnight,
        icon: const Text('✨', style: TextStyle(fontSize: 16)),
        label: Text(l.fdAskAi, style: const TextStyle(fontWeight: FontWeight.w800)),
        onPressed: _showAskAi,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null ? _errV() : _d != null ? _report(l) : const SizedBox.shrink(),
    );
  }

  Widget _errV() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.error_outline, color: AppColors.error, size: 48), const SizedBox(height: 12),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(_error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center)),
    const SizedBox(height: 16),
    ElevatedButton(onPressed: _load, child: Text(AppLocalizations.of(context)?.retry ?? 'Retry')),
  ]));

  Widget _report(AppLocalizations l) {
    final d = _d!;
    final weekday = d['target_weekday']?.toString() ?? '';
    final targetDate = d['target_date']?.toString() ?? '';
    var i = 0;
    Widget fade(Widget w) => KFadeIn(delayMs: (i++ * 60).clamp(0, 600), child: w);

    return CustomScrollView(slivers: [
      SliverAppBar(
        backgroundColor: AppColors.background, pinned: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.chartName.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1.4, fontWeight: FontWeight.w700)),
          Text(l.forecast, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 17, fontWeight: FontWeight.w700)),
        ]),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.ivory, size: 18),
            tooltip: l.downloadPdf,
            onPressed: () => downloadReportPdf(
                context, 'forecast/${widget.chartId}', 'forecast-${widget.chartName}'),
          ),
          IconButton(icon: const Icon(Icons.refresh, color: AppColors.ivory, size: 18), onPressed: _load),
        ],
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        sliver: SliverList(delegate: SliverChildListDelegate([
          fade(_statusChips(l)),
          const SizedBox(height: 14),
          fade(_hero(l, weekday, targetDate)),
          const SizedBox(height: 18),
          fade(_focusCard(l)),
          const SizedBox(height: 18),
          fade(_bestToDo(l)),
          const SizedBox(height: 18),
          fade(_avoidToday(l)),
          const SizedBox(height: 18),
          fade(_highlights(l)),
          const SizedBox(height: 18),
          fade(_lifeAreas(l)),
          const SizedBox(height: 18),
          fade(_financial(l)),
          const SizedBox(height: 18),
          fade(_relationships(l)),
          const SizedBox(height: 18),
          fade(_oppRisk(l)),
          const SizedBox(height: 18),
          fade(_timing(l)),
          const SizedBox(height: 18),
          fade(_confidence(l)),
          const SizedBox(height: 20),
        ])),
      ),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  QUICK STATUS CHIPS
  // ══════════════════════════════════════════════════════════════════
  Widget _statusChips(AppLocalizations l) {
    final chips = <List<Object>>[
      ['💼', l.fdCareer, _conf(10)],
      ['💰', l.fdMoney, (_conf(2) + _conf(11)) / 2],
      ['❤️', l.fdLove, (_conf(7) + _conf(5)) / 2],
      ['🌿', l.fdHealth, _conf(1)],
      ['✈️', l.fdTravel, _conf(9)],
      ['🏠', l.fdFamily, _conf(4)],
    ];
    return SizedBox(height: 34, child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: chips.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, idx) {
        final c = chips[idx];
        final score = c[2] as double;
        final col = _statusColor(score);
        final dot = score >= 60 ? '🟢' : score >= 42 ? '🟡' : '🔴';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: col.withOpacity(0.10), borderRadius: BorderRadius.circular(20),
            border: Border.all(color: col.withOpacity(0.32))),
          child: Row(children: [
            Text(dot, style: const TextStyle(fontSize: 10)),
            const SizedBox(width: 5),
            Text(c[1] as String, style: TextStyle(color: col, fontSize: 12, fontWeight: FontWeight.w700)),
          ]),
        );
      },
    ));
  }

  // ══════════════════════════════════════════════════════════════════
  //  HERO
  // ══════════════════════════════════════════════════════════════════
  Widget _hero(AppLocalizations l, String weekday, String date) {
    final d = _d!;
    final score = (d['day_quality_score'] as num?)?.toDouble() ?? 0;
    final col = _statusColor(score);
    final status = _status(score, l);
    final top = _topHouse(), weak = _weakHouse();
    final ranked = _rankedHouses();
    final fin = _incomeLikelihood() ?? '';
    final aiSummary = fin.isNotEmpty
        ? l.fdAiSummaryLine(_areaName(top, l), _areaName(weak, l), fin)
        : l.fdThemeFocusLine(_areaName(top, l));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: col.withOpacity(0.32)),
      ),
      child: Column(children: [
        Text('${_weekdayShort(weekday)}  ·  $date', style: TextStyle(color: col, fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        // circular gauge
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: score / 100),
          duration: const Duration(milliseconds: 900), curve: Curves.easeOutCubic,
          builder: (_, v, __) => SizedBox(width: 132, height: 132, child: Stack(alignment: Alignment.center, children: [
            SizedBox(width: 132, height: 132, child: CircularProgressIndicator(
              value: v, strokeWidth: 11, strokeCap: StrokeCap.round,
              backgroundColor: Colors.white.withOpacity(0.07), valueColor: AlwaysStoppedAnimation(col))),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text((v * 100).toStringAsFixed(0), style: TextStyle(color: col, fontSize: 40, fontWeight: FontWeight.w800, height: 1)),
              Text('/100', style: TextStyle(color: col.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w600)),
            ]),
          ])),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
          child: Text(status, style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: 16),
        // theme chips
        Align(alignment: Alignment.centerLeft, child: Text(l.fdTheme, style: const TextStyle(color: AppColors.smoke, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: .5))),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          _themeChip('${_areaEmoji(ranked[0])} ${_areaName(ranked[0], l)}', KColors.green),
          _themeChip('${_areaEmoji(ranked[1])} ${_areaName(ranked[1], l)}', KColors.blue),
          _themeChip('⚠ ${_areaName(weak, l)}', KColors.orange),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.midnight.withOpacity(0.35), borderRadius: BorderRadius.circular(14)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('🤖', style: TextStyle(fontSize: 15)),
            const SizedBox(width: 10),
            Expanded(child: Text(aiSummary, style: const TextStyle(color: AppColors.ivory, fontSize: 13, height: 1.5))),
          ]),
        ),
        const SizedBox(height: 14),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: col.withOpacity(0.16), foregroundColor: col,
            elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: col.withOpacity(0.4)))),
          icon: const Text('✨', style: TextStyle(fontSize: 14)),
          label: Text(l.fdExplainToday, style: const TextStyle(fontWeight: FontWeight.w800)),
          onPressed: () => _showExplain(l),
        )),
      ]),
    );
  }

  Widget _themeChip(String text, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withOpacity(0.3))),
    child: Text(text, style: TextStyle(color: c, fontSize: 12.5, fontWeight: FontWeight.w700)),
  );

  // ══════════════════════════════════════════════════════════════════
  //  TODAY'S FOCUS (AI card)
  // ══════════════════════════════════════════════════════════════════
  Widget _focusCard(AppLocalizations l) {
    final ranked = _rankedHouses();
    final rec = _topRecommendation();
    final caution = _topCaution(l);
    return _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Text('🧭', style: TextStyle(fontSize: 16)), const SizedBox(width: 8),
        Flexible(child: Text(l.fdTodaysFocus, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 15.5, fontWeight: FontWeight.w800))),
        const Spacer(),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
          child: Text('⏱ ${l.fdReadingTime}: ${l.fdSeconds30}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.gold, fontSize: 9.5, fontWeight: FontWeight.w700))),
      ]),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (final h in ranked.take(4)) _themeChip('${_areaEmoji(h)} ${_areaName(h, l)}', _statusColor(_conf(h))),
      ]),
      const SizedBox(height: 14),
      _focusLine('✅', l.fdTopRecommendation, rec, KColors.green),
      const SizedBox(height: 8),
      _focusLine('⚠️', l.fdTopCaution, caution, KColors.orange),
    ]));
  }

  Widget _focusLine(String emoji, String label, String body, Color c) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(emoji, style: const TextStyle(fontSize: 14)), const SizedBox(width: 8),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w800)),
      const SizedBox(height: 2),
      Text(body, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.4)),
    ])),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  BEST THINGS TO DO
  // ══════════════════════════════════════════════════════════════════
  Widget _bestToDo(AppLocalizations l) {
    final opp = (_d?['opportunities_vs_risks'] as Map?)?.cast<String, dynamic>() ?? {};
    final today = (opp['opportunities_today'] as Map?)?.cast<String, dynamic>() ?? {};
    final domains = (today['top_opportunity_domains'] as List?) ?? [];
    final rec = today['recommended_action']?.toString() ?? '';
    final bestTime = _bestWindow();
    final extra = ((_d?['key_actions_today'] as List?) ?? []).map((e) => e.toString()).toList();

    final cards = <Widget>[];
    for (final o in domains.take(4)) {
      if (o is! Map) continue;
      final m = o.cast<String, dynamic>();
      final h = (m['house'] as num?)?.toInt() ?? 0;
      final sc = (m['score'] as num?)?.toDouble() ?? 0;
      cards.add(_actionCard(
        emoji: _areaEmoji(h), title: _areaName(h, l),
        pct: sc, pctLabel: l.fdConfidenceLabel, pctColor: KColors.green,
        bestTime: bestTime, reason: _prettyEvent(m['event']?.toString() ?? '', l),
        recLabel: l.fdRecommended, rec: rec, accent: KColors.green,
      ));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.check_circle_rounded, title: l.fdBestToDo, color: KColors.green),
      if (cards.isEmpty)
        _softNote(l.fdNoActions, KColors.green)
      else ...cards,
      if (extra.isNotEmpty) _moreSuggestions(l, extra, KColors.green),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  AVOID TODAY
  // ══════════════════════════════════════════════════════════════════
  Widget _avoidToday(AppLocalizations l) {
    final opp = (_d?['opportunities_vs_risks'] as Map?)?.cast<String, dynamic>() ?? {};
    final risks = (opp['risks_today'] as Map?)?.cast<String, dynamic>() ?? {};
    final domains = (risks['top_risk_domains'] as List?) ?? [];
    final protect = risks['recommended_protective_action']?.toString() ?? '';
    final flags = ((_d?['critical_event_flags'] as List?) ?? [])
        .whereType<Map>().map((e) => e.cast<String, dynamic>())
        .where((f) => f['type'] == 'depressed_probability').toList();
    final extra = ((_d?['key_cautions_today'] as List?) ?? []).map((e) => e.toString()).toList();

    final cards = <Widget>[];
    for (final o in domains.take(3)) {
      if (o is! Map) continue;
      final m = o.cast<String, dynamic>();
      final h = (m['house'] as num?)?.toInt() ?? 0;
      final sc = (m['score'] as num?)?.toDouble() ?? 0;
      cards.add(_actionCard(
        emoji: _areaEmoji(h), title: _areaName(h, l),
        pct: sc, pctLabel: l.fdRisk, pctColor: KColors.red,
        reason: _prettyEvent(m['event']?.toString() ?? '', l),
        recLabel: l.fdRecommendation, rec: protect, accent: KColors.orange,
      ));
    }
    for (final f in flags.take(2)) {
      cards.add(_actionCard(
        emoji: '⚠️', title: f['event']?.toString() ?? '',
        pct: (f['probability_score'] as num?)?.toDouble() ?? 0, pctLabel: l.fdRisk, pctColor: KColors.orange,
        recLabel: l.fdRecommendation, rec: f['recommended_action']?.toString() ?? '', accent: KColors.orange,
      ));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.report_gmailerrorred_rounded, title: l.fdAvoidToday, color: KColors.orange),
      if (cards.isEmpty)
        _softNote(l.fdNoCautions, KColors.blue)
      else ...cards,
      if (extra.isNotEmpty) _moreSuggestions(l, extra, KColors.orange),
    ]);
  }

  Widget _actionCard({
    required String emoji, required String title, required double pct,
    required String pctLabel, required Color pctColor, String? bestTime,
    String? reason, required String recLabel, required String rec, required Color accent,
  }) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: accent.withOpacity(0.06), borderRadius: BorderRadius.circular(16),
      border: Border.all(color: accent.withOpacity(0.22))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)), const SizedBox(width: 8),
        Expanded(child: Text(title, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w800))),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${pct.toStringAsFixed(0)}%', style: TextStyle(color: pctColor, fontSize: 17, fontWeight: FontWeight.w800, height: 1)),
          Text(pctLabel, style: TextStyle(color: pctColor.withOpacity(0.7), fontSize: 8.5, fontWeight: FontWeight.w600)),
        ]),
      ]),
      if (bestTime != null && bestTime.isNotEmpty) ...[
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.schedule_rounded, size: 13, color: AppColors.gold), const SizedBox(width: 5),
          Text(bestTime, style: const TextStyle(color: AppColors.gold, fontSize: 11.5, fontWeight: FontWeight.w700)),
        ]),
      ],
      if (reason != null && reason.isNotEmpty) ...[
        const SizedBox(height: 8),
        Text(reason, style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.4)),
      ],
      if (rec.isNotEmpty) ...[
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: accent.withOpacity(0.10), borderRadius: BorderRadius.circular(10)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Flexible(child: Text(recLabel, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: accent, fontSize: 10.5, fontWeight: FontWeight.w800))),
            const SizedBox(width: 8),
            Expanded(flex: 2, child: Text(rec, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
          ]),
        ),
      ],
    ]),
  );

  Widget _softNote(String text, Color c) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
    child: Row(children: [
      Icon(Icons.spa_rounded, size: 16, color: c), const SizedBox(width: 10),
      Expanded(child: Text(text, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.4))),
    ]),
  );

  Widget _moreSuggestions(AppLocalizations l, List<String> items, Color c) => Theme(
    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
      childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      iconColor: c, collapsedIconColor: c,
      title: Text(l.fdMoreSuggestions, style: TextStyle(color: c, fontSize: 12.5, fontWeight: FontWeight.w700)),
      children: items.map((s) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('•  ', style: TextStyle(color: c, fontSize: 12)),
          Expanded(child: Text(s, style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.4))),
        ]),
      )).toList(),
    ),
  );

  // ══════════════════════════════════════════════════════════════════
  //  TODAY'S HIGHLIGHTS  (critical_event_flags → readable cards)
  // ══════════════════════════════════════════════════════════════════
  Widget _highlights(AppLocalizations l) {
    final flags = ((_d?['critical_event_flags'] as List?) ?? [])
        .whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (flags.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.auto_awesome_rounded, title: l.fdHighlights, color: AppColors.gold),
      ...flags.take(5).map((f) {
        final sev = f['severity']?.toString() ?? 'ELEVATED';
        // Colour by VALENCE (is this a favourable event or a caution/risk),
        // not by raw intensity — otherwise a strongly positive day reads red
        // and a low-caution reads calm blue. Strength is still conveyed by the
        // badge label and the progress bar.
        final col = _flagColor(f);
        final prob = (f['probability_score'] as num?)?.toDouble() ?? 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(16),
            border: Border.all(color: col.withOpacity(0.22))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(_flagEmoji(f), style: const TextStyle(fontSize: 16)), const SizedBox(width: 8),
              Expanded(child: Text(f['event']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w800))),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                constraints: const BoxConstraints(maxWidth: 110),
                decoration: BoxDecoration(color: col.withOpacity(0.14), borderRadius: BorderRadius.circular(8)),
                child: FittedBox(fit: BoxFit.scaleDown, child: Text(_severityLabel(sev, l), maxLines: 1, style: TextStyle(color: col, fontSize: 9.5, fontWeight: FontWeight.w800)))),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(value: (prob / 100).clamp(0, 1), minHeight: 5,
                  backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col)))),
              const SizedBox(width: 8),
              Text('${prob.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 12, fontWeight: FontWeight.w800)),
            ]),
            if ((f['recommended_action']?.toString() ?? '').isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Flexible(child: Text('${l.fdWhatToDo}: ', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: col, fontSize: 11, fontWeight: FontWeight.w800))),
                Expanded(flex: 2, child: Text(f['recommended_action'].toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
              ]),
            ],
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  LIFE AREAS  (12 friendly domain cards → bottom sheet)
  // ══════════════════════════════════════════════════════════════════
  Widget _lifeAreas(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.grid_view_rounded, title: l.fdLifeAreas, subtitle: l.fdTapDetails, color: KColors.purple),
      GridView.count(
        crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.55,
        children: [for (var h = 1; h <= 12; h++) _areaCard(l, h)],
      ),
    ]);
  }

  Widget _areaCard(AppLocalizations l, int h) {
    final score = _conf(h);
    final col = _statusColor(score);
    return GestureDetector(
      onTap: () => _showHouseSheet(l, h),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: col.withOpacity(0.07), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: col.withOpacity(0.22))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Text(_areaEmoji(h), style: const TextStyle(fontSize: 17)),
            const Spacer(),
            Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 16, fontWeight: FontWeight.w800)),
          ]),
          Text(_areaName(h, l), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
          Row(children: [
            Expanded(child: Text(_status(score, l), style: TextStyle(color: col, fontSize: 10.5, fontWeight: FontWeight.w700))),
            const Icon(Icons.chevron_right_rounded, size: 15, color: AppColors.smoke),
          ]),
        ]),
      ),
    );
  }

  void _showHouseSheet(AppLocalizations l, int h) {
    final score = _conf(h);
    final col = _statusColor(score);
    final ev = (_houseEvents['$h'] as Map?)?.cast<String, dynamic>() ?? {};
    final conf = (_confluence['$h'] as Map?)?.cast<String, dynamic>() ?? {};
    final sig = ev['h${h}_event_signature']?.toString() ?? '';
    // Good For / Avoid derived from the house's own probability fields.
    final metrics = <MapEntry<String, double>>[];
    ev.forEach((k, v) {
      if (v is num && (k.contains('probability') || k.contains('score')) && !k.contains('event')) {
        metrics.add(MapEntry(k, v.toDouble()));
      }
    });
    metrics.sort((a, b) => b.value.compareTo(a.value));
    final goodFor = metrics.where((e) => e.value >= 55).take(3).toList();
    final avoid = metrics.reversed.where((e) => e.value <= 45).take(2).toList();
    // Planet support: transiting planets currently in this house (from lagna).
    final planets = ((_d?['gochar_today'] as Map?)?['transit_planets'] as List?) ?? [];
    final support = planets.whereType<Map>().map((e) => e.cast<String, dynamic>())
        .where((p) => (p['house_from_lagna'] as num?)?.toInt() == h).toList();
    final why = conf['explanation']?.toString() ?? '';
    final aiRec = conf['domain_emphasis']?.toString() ?? '';
    final locale = Localizations.localeOf(context);

    showModalBottomSheet(context: context, isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.72, minChildSize: 0.4, maxChildSize: 0.95, expand: false,
        builder: (_, sc) => ListView(controller: sc, padding: const EdgeInsets.fromLTRB(18, 12, 18, 28), children: [
          Center(child: Container(width: 42, height: 4, margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
          Row(children: [
            Text(_areaEmoji(h), style: const TextStyle(fontSize: 26)), const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_areaName(h, l), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 19, fontWeight: FontWeight.w800)),
              Text(_status(score, l), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: col, fontSize: 12.5, fontWeight: FontWeight.w700)),
            ])),
            Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 26, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 14),
          ClipRRect(borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 9,
              backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
          if (sig.isNotEmpty) ...[
            const SizedBox(height: 18),
            _sheetLabel(l.fdTodaysMeaning),
            const SizedBox(height: 6),
            Text(sig, style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, height: 1.5)),
          ],
          if (goodFor.isNotEmpty) ...[
            const SizedBox(height: 18),
            _sheetLabel(l.fdGoodFor),
            const SizedBox(height: 8),
            ...goodFor.map((e) => _bullet('✔', ForecastLabels.label(e.key, locale, _tc(e.key)), KColors.green)),
          ],
          if (avoid.isNotEmpty) ...[
            const SizedBox(height: 14),
            _sheetLabel(l.fdAvoid),
            const SizedBox(height: 8),
            ...avoid.map((e) => _bullet('✕', ForecastLabels.label(e.key, locale, _tc(e.key)), KColors.red)),
          ],
          const SizedBox(height: 18),
          _sheetLabel(l.fdPlanetSupport),
          const SizedBox(height: 8),
          if (support.isEmpty)
            Text(l.fdNoPlanetTransit, style: const TextStyle(color: AppColors.smoke, fontSize: 12.5))
          else ...support.map((p) {
            final name = KundliNames.planet(p['planet']?.toString() ?? '', locale);
            final qs = (p['gochar_quality_score'] as num?)?.toDouble() ?? 50;
            return Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
              Expanded(child: Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w600))),
              KStars(filled: kStars(qs), size: 15, color: _statusColor(qs)),
            ]));
          }),
          if (aiRec.isNotEmpty) ...[
            const SizedBox(height: 18),
            Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [const Text('✨', style: TextStyle(fontSize: 13)), const SizedBox(width: 6),
                  Text(l.fdAiRecommendation, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w800))]),
                const SizedBox(height: 6),
                Text(aiRec, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.5)),
              ])),
          ],
          if (why.isNotEmpty) ...[
            const SizedBox(height: 12),
            Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                iconColor: AppColors.smoke, collapsedIconColor: AppColors.smoke,
                title: Text(l.fdWhyPrediction, style: const TextStyle(color: AppColors.smoke, fontSize: 12.5, fontWeight: FontWeight.w700)),
                children: [Padding(padding: const EdgeInsets.only(bottom: 10),
                  child: Text(why, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.5)))],
              )),
          ],
        ]),
      ),
    );
  }

  Widget _sheetLabel(String t) => Text(t.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1));
  Widget _bullet(String mark, String text, Color c) => Padding(padding: const EdgeInsets.only(bottom: 6),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$mark  ', style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w700)),
      Expanded(child: Text(text, style: const TextStyle(color: AppColors.ivory, fontSize: 13, height: 1.4))),
    ]));

  // ══════════════════════════════════════════════════════════════════
  //  FINANCIAL OUTLOOK
  // ══════════════════════════════════════════════════════════════════
  Widget _financial(AppLocalizations l) {
    final data = (_d?['income_vs_expense'] as Map?)?.cast<String, dynamic>() ?? {};
    if (data.isEmpty) return const SizedBox.shrink();
    final inc = (data['income_forecast'] as Map?)?.cast<String, dynamic>() ?? {};
    final exp = (data['expense_forecast'] as Map?)?.cast<String, dynamic>() ?? {};
    final bal = (data['net_financial_balance_today'] as Map?)?.cast<String, dynamic>() ?? {};
    final incScore = (inc['composite_income_score'] as num?)?.toDouble() ?? 0;
    final expScore = (exp['composite_expense_score'] as num?)?.toDouble() ?? 0;
    final balScore = (bal['balance_score'] as num?)?.toDouble() ?? 0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.account_balance_wallet_rounded, title: l.fdFinancialOutlook, color: KColors.green),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: _bigStat('💵', l.fdIncomeProbability, incScore, _statusColor(incScore), inc['income_likelihood']?.toString())),
          const SizedBox(width: 10),
          Expanded(child: _bigStat('💳', l.fdExpenseProbability, expScore, expScore >= 55 ? KColors.orange : KColors.blue, exp['expense_likelihood']?.toString())),
        ]),
        const SizedBox(height: 14),
        _meterRow(l.fdNetBalance, balScore, _statusColor(balScore)),
        if ((inc['best_time_window_for_income']?.toString() ?? '').isNotEmpty)
          _kv('⏰', l.fdBestTime, inc['best_time_window_for_income'].toString(), KColors.green),
        if ((exp['expense_caution_window']?.toString() ?? '').isNotEmpty)
          _kv('🛑', l.fdAvoidSpending, exp['expense_caution_window'].toString(), KColors.orange),
        if ((bal['financial_advice']?.toString() ?? '').isNotEmpty) ...[
          const SizedBox(height: 10),
          _adviceBox(l.fdAiRecommendation, bal['financial_advice'].toString(), KColors.green),
        ],
      ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  RELATIONSHIP OUTLOOK
  // ══════════════════════════════════════════════════════════════════
  Widget _relationships(AppLocalizations l) {
    final data = (_d?['relationships_today'] as Map?)?.cast<String, dynamic>() ?? {};
    if (data.isEmpty) return const SizedBox.shrink();
    double g(String k) => (data[k] as num?)?.toDouble() ?? 0;
    final rows = <List<Object>>[
      [l.fdPartner, g('spouse_interaction_quality')],
      [l.fdFamily, g('family_harmony_today')],
      [l.fdRomance, g('romance_favourability')],
      [l.fdWorkplace, g('workplace_relationships')],
      [l.fdPublicImage, g('public_impression')],
    ];
    final overall = g('partnership_harmony_today');
    final best = data['best_domain_for_meetings']?.toString() ?? '';
    final avoidL = (data['domains_to_avoid_for_conversations'] as List?) ?? [];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.favorite_rounded, title: l.fdRelationshipOutlook, color: KColors.red),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _meterRow(l.fdOverallScore, overall, _statusColor(overall)),
        const SizedBox(height: 6),
        ...rows.map((r) => _meterRow(r[0] as String, r[1] as double, _statusColor(r[1] as double))),
        if (best.isNotEmpty) ...[const SizedBox(height: 6), _kv('🤝', l.fdBestActivity, best, KColors.green)],
        if (avoidL.isNotEmpty) _kv('⚠️', l.fdWeakArea, avoidL.map((e) => e.toString()).join(', '), KColors.orange),
      ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  OPPORTUNITIES vs RISKS
  // ══════════════════════════════════════════════════════════════════
  Widget _oppRisk(AppLocalizations l) {
    final data = (_d?['opportunities_vs_risks'] as Map?)?.cast<String, dynamic>() ?? {};
    if (data.isEmpty) return const SizedBox.shrink();
    final opp = (data['opportunities_today'] as Map?)?.cast<String, dynamic>() ?? {};
    final risk = (data['risks_today'] as Map?)?.cast<String, dynamic>() ?? {};
    final topOpp = ((opp['top_opportunity_domains'] as List?) ?? []).whereType<Map>().toList();
    final topRisk = ((risk['top_risk_domains'] as List?) ?? []).whereType<Map>().toList();
    final oM = topOpp.isNotEmpty ? topOpp.first.cast<String, dynamic>() : <String, dynamic>{};
    final rM = topRisk.isNotEmpty ? topRisk.first.cast<String, dynamic>() : <String, dynamic>{};
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _bigMoment('🌟', l.fdBiggestOpportunity,
        title: _prettyEvent(oM['event']?.toString() ?? '', l),
        prob: (oM['score'] as num?)?.toDouble() ?? (opp['new_opportunity_score'] as num?)?.toDouble() ?? 0,
        desc: oM.isNotEmpty ? _areaName((oM['house'] as num?)?.toInt() ?? 0, l) : '',
        recLabel: l.fdRecommendation, rec: opp['recommended_action']?.toString() ?? '', c: KColors.green),
      const SizedBox(height: 12),
      _bigMoment('⚠', l.fdBiggestRisk,
        title: _prettyEvent(rM['event']?.toString() ?? '', l),
        prob: (rM['score'] as num?)?.toDouble() ?? (risk['composite_risk_score'] as num?)?.toDouble() ?? 0,
        desc: rM.isNotEmpty ? _areaName((rM['house'] as num?)?.toInt() ?? 0, l) : '',
        recLabel: l.fdProtection, rec: risk['recommended_protective_action']?.toString() ?? '', c: KColors.red),
    ]);
  }

  Widget _bigMoment(String emoji, String header, {required String title, required double prob, required String desc, required String recLabel, required String rec, required Color c}) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [c.withOpacity(0.14), AppColors.card.withOpacity(0.3)]),
      borderRadius: BorderRadius.circular(18), border: Border.all(color: c.withOpacity(0.3))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)), const SizedBox(width: 8),
        Flexible(child: Text(header, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w800))),
        const Spacer(),
        Text('${prob.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 20, fontWeight: FontWeight.w800)),
      ]),
      if (title.isNotEmpty) ...[const SizedBox(height: 8),
        Text(title, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w700))],
      if (desc.isNotEmpty) ...[const SizedBox(height: 2),
        Text(desc, style: const TextStyle(color: AppColors.smoke, fontSize: 11.5))],
      if (rec.isNotEmpty) ...[const SizedBox(height: 10),
        Container(padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: c.withOpacity(0.10), borderRadius: BorderRadius.circular(10)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Flexible(child: Text('$recLabel  ', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w800))),
            Expanded(flex: 2, child: Text(rec, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
          ]))],
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  BEST TIME / AVOID DURING
  // ══════════════════════════════════════════════════════════════════
  Widget _timing(AppLocalizations l) {
    final data = (_d?['timing_windows'] as Map?)?.cast<String, dynamic>() ?? {};
    if (data.isEmpty) return const SizedBox.shrink();
    final best = ((data['best_time_windows'] as List?) ?? []).whereType<Map>().toList();
    final worst = ((data['worst_time_windows'] as List?) ?? []).whereType<Map>().toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.wb_twilight_rounded, title: l.fdBestTimeToday, color: AppColors.gold),
      ...best.take(4).map((w) => _windowRow(w.cast<String, dynamic>(), best: true, l: l)),
      if (worst.isNotEmpty) ...[
        const SizedBox(height: 14),
        KSectionHeader(icon: Icons.do_not_disturb_on_rounded, title: l.fdAvoidDuring, color: KColors.red),
        ...worst.take(3).map((w) => _windowRow(w.cast<String, dynamic>(), best: false, l: l)),
      ],
    ]);
  }

  Widget _windowRow(Map<String, dynamic> m, {required bool best, required AppLocalizations l}) {
    final c = best ? KColors.green : KColors.red;
    final qs = (m['quality_score'] as num?)?.toDouble() ?? 50;
    final acts = (m[best ? 'favoured_actions' : 'avoid_actions'] as List?) ?? [];
    final label = acts.isNotEmpty ? acts.first.toString() : '';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
      child: Row(children: [
        Flexible(child: Text(m['window']?.toString() ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w800))),
        const SizedBox(width: 12),
        Expanded(child: Text(_prettyEvent(label, l), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 8),
        if (best) KStars(filled: kStars(qs), size: 14, color: AppColors.gold),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  PREDICTION CONFIDENCE
  // ══════════════════════════════════════════════════════════════════
  Widget _confidence(AppLocalizations l) {
    final raw = _d?['confidence_score'];
    if (raw is! num) return const SizedBox.shrink();
    final pct = raw <= 1 ? raw.toDouble() * 100 : raw.toDouble();
    final stars = kStars(pct);
    final items = [l.fdConfNatal, l.fdConfTransit, l.fdConfDasha, l.fdConfStrength, l.fdConfHouse];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_rounded, title: l.fdPredictionConfidence, color: KColors.blue),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          KStars(filled: stars, size: 22, color: AppColors.gold),
          const Spacer(),
          Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 14),
        Text(l.fdConfBasis, style: const TextStyle(color: AppColors.smoke, fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: items.map((t) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: KColors.green.withOpacity(0.10), borderRadius: BorderRadius.circular(10), border: Border.all(color: KColors.green.withOpacity(0.25))),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_rounded, size: 13, color: KColors.green), const SizedBox(width: 5),
            Text(t, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, fontWeight: FontWeight.w600)),
          ]),
        )).toList()),
      ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  EXPLAIN TODAY  /  ASK AI  bottom sheets
  // ══════════════════════════════════════════════════════════════════
  void _showExplain(AppLocalizations l) {
    final d = _d!;
    final overall = (d['day_quality_overall'] as Map?)?.cast<String, dynamic>() ?? {};
    final parts = <String>[
      d['day_summary']?.toString() ?? '',
      overall['explanation']?.toString() ?? '',
      (d['moola_dasha_stack'] as Map?)?['explanation']?.toString() ?? '',
      (d['gochar_today'] as Map?)?['explanation']?.toString() ?? '',
    ].where((s) => s.isNotEmpty).toList();
    _infoSheet(l.fdExplainToday, '✨', parts);
  }

  void _showAskAi() {
    final l = AppLocalizations.of(context)!;
    final questions = <List<String>>[
      [l.fdQ1, _answerCareer(l)],
      [l.fdQ2, _answerBestTime(l)],
      [l.fdQ3, _answerMoney(l)],
      [l.fdQ4, _answerTravel(l)],
      [l.fdQ5, _answerAvoid(l)],
    ];
    showModalBottomSheet(context: context, isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        int? open;
        return StatefulBuilder(builder: (ctx, setInner) => ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(18, 12, 18, 28), children: [
          Center(child: Container(width: 42, height: 4, margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
          Row(children: [const Text('✨', style: TextStyle(fontSize: 20)), const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.fdAskAi, style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w800)),
              Text(l.fdAskAiSub, style: const TextStyle(color: AppColors.smoke, fontSize: 11.5)),
            ]))]),
          const SizedBox(height: 14),
          ...List.generate(questions.length, (idx) {
            final q = questions[idx];
            final isOpen = open == idx;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(isOpen ? 0.4 : 0.15))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => setInner(() => open = isOpen ? null : idx),
                  child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
                    Expanded(child: Text(q[0], style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w700))),
                    Icon(isOpen ? Icons.remove_circle_outline : Icons.add_circle_outline, size: 18, color: AppColors.gold),
                  ])),
                ),
                if (isOpen) Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: Text(q[1], style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, height: 1.5))),
              ]),
            );
          }),
        ]));
      },
    );
  }

  String _answerCareer(AppLocalizations l) {
    final score = _conf(10);
    final expl = (_confluence['10'] as Map?)?['explanation']?.toString() ?? '';
    final ev = (_houseEvents['10'] as Map?)?['h10_event_signature']?.toString() ?? '';
    return '${_areaName(10, l)}: ${score.toStringAsFixed(0)}% · ${_status(score, l)}.\n${[ev, expl].where((s) => s.isNotEmpty).join('\n')}';
  }
  String _answerBestTime(AppLocalizations l) {
    final w = _bestWindowMap();
    if (w == null) return l.fdNoActions;
    final acts = ((w['favoured_actions'] as List?) ?? []).map((e) => _prettyEvent(e.toString(), l)).join(', ');
    return '⭐ ${w['window']}\n$acts';
  }
  String _answerMoney(AppLocalizations l) {
    final data = (_d?['income_vs_expense'] as Map?)?.cast<String, dynamic>() ?? {};
    final expl = data['explanation']?.toString() ?? '';
    final advice = (data['net_financial_balance_today'] as Map?)?['financial_advice']?.toString() ?? '';
    return [expl, advice].where((s) => s.isNotEmpty).join('\n\n');
  }
  String _answerTravel(AppLocalizations l) {
    final score = _conf(9);
    final ev = (_houseEvents['9'] as Map?)?['h9_event_signature']?.toString() ?? '';
    final expl = (_confluence['9'] as Map?)?['explanation']?.toString() ?? '';
    return '${_areaName(9, l)}: ${score.toStringAsFixed(0)}% · ${_status(score, l)}.\n${[ev, expl].where((s) => s.isNotEmpty).join('\n')}';
  }
  String _answerAvoid(AppLocalizations l) {
    final risk = ((_d?['opportunities_vs_risks'] as Map?)?['risks_today'] as Map?)?.cast<String, dynamic>() ?? {};
    final protect = risk['recommended_protective_action']?.toString() ?? '';
    final worst = ((_d?['timing_windows'] as Map?)?['worst_time_windows'] as List?) ?? [];
    final worstLine = worst.whereType<Map>().isNotEmpty
        ? '🔴 ${worst.whereType<Map>().first['window']}' : '';
    return [protect, worstLine].where((s) => s.isNotEmpty).join('\n');
  }

  void _infoSheet(String title, String emoji, List<String> paragraphs) {
    showModalBottomSheet(context: context, isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6, minChildSize: 0.35, maxChildSize: 0.92, expand: false,
        builder: (_, sc) => ListView(controller: sc, padding: const EdgeInsets.fromLTRB(18, 12, 18, 28), children: [
          Center(child: Container(width: 42, height: 4, margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
          Row(children: [Text(emoji, style: const TextStyle(fontSize: 22)), const SizedBox(width: 8),
            Expanded(child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 19, fontWeight: FontWeight.w800)))]),
          const SizedBox(height: 16),
          ...paragraphs.map((p) => Padding(padding: const EdgeInsets.only(bottom: 14),
            child: Text(p, style: const TextStyle(color: AppColors.parchment, fontSize: 13.5, height: 1.6)))),
        ]),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  small shared widgets
  // ══════════════════════════════════════════════════════════════════
  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.06))),
    child: child,
  );

  Widget _bigStat(String emoji, String label, double score, Color c, String? sub) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$emoji $label', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 24, fontWeight: FontWeight.w800)),
      if (sub != null && sub.isNotEmpty) Text(sub, style: TextStyle(color: c.withOpacity(0.75), fontSize: 10.5, fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _meterRow(String label, double v, Color c) => Padding(padding: const EdgeInsets.symmetric(vertical: 5),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w600))),
        Text('${v.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 12.5, fontWeight: FontWeight.w800)),
      ]),
      const SizedBox(height: 4),
      ClipRRect(borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
    ]));

  Widget _kv(String emoji, String label, String value, Color c) => Padding(padding: const EdgeInsets.only(top: 8),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$emoji ', style: const TextStyle(fontSize: 12)),
      Flexible(child: Text('$label: ', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: c, fontSize: 11.5, fontWeight: FontWeight.w800))),
      Expanded(flex: 2, child: Text(value, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
    ]));

  Widget _adviceBox(String label, String body, Color c) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: c.withOpacity(0.09), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withOpacity(0.22))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const Text('✨', style: TextStyle(fontSize: 12)), const SizedBox(width: 6),
        Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w800)))]),
      const SizedBox(height: 5),
      Text(body, style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.5)),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  derivations & mapping helpers
  // ══════════════════════════════════════════════════════════════════
  String _topRecommendation() {
    final rec = ((_d?['opportunities_vs_risks'] as Map?)?['opportunities_today'] as Map?)?['recommended_action']?.toString();
    if (rec != null && rec.isNotEmpty) return rec;
    final acts = (_d?['key_actions_today'] as List?) ?? [];
    return acts.isNotEmpty ? acts.first.toString() : '';
  }
  String _topCaution(AppLocalizations l) {
    final protect = ((_d?['opportunities_vs_risks'] as Map?)?['risks_today'] as Map?)?['recommended_protective_action']?.toString();
    if (protect != null && protect.isNotEmpty) return protect;
    final cautions = (_d?['key_cautions_today'] as List?) ?? [];
    if (cautions.isNotEmpty) return cautions.first.toString();
    return (_confluence['${_weakHouse()}'] as Map?)?['domain_emphasis']?.toString() ?? '';
  }
  String? _incomeLikelihood() =>
      ((_d?['income_vs_expense'] as Map?)?['income_forecast'] as Map?)?['income_likelihood']?.toString();

  Map<String, dynamic>? _bestWindowMap() {
    final best = ((_d?['timing_windows'] as Map?)?['best_time_windows'] as List?) ?? [];
    final m = best.whereType<Map>().toList();
    return m.isNotEmpty ? m.first.cast<String, dynamic>() : null;
  }
  String _bestWindow() => _bestWindowMap()?['window']?.toString() ?? '';

  // free-text event phrase → sentence case, localised where a label exists.
  String _prettyEvent(String s, AppLocalizations l) {
    if (s.isEmpty) return s;
    final key = s.trim().toLowerCase().replaceAll(' ', '_');
    final locale = Localizations.localeOf(context);
    final mapped = ForecastLabels.label(key, locale, '');
    if (mapped.isNotEmpty) return mapped;
    return s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  }

  String _areaName(int h, AppLocalizations l) {
    switch (h) {
      case 1: return l.fdArea1; case 2: return l.fdArea2; case 3: return l.fdArea3;
      case 4: return l.fdArea4; case 5: return l.fdArea5; case 6: return l.fdArea6;
      case 7: return l.fdArea7; case 8: return l.fdArea8; case 9: return l.fdArea9;
      case 10: return l.fdArea10; case 11: return l.fdArea11; case 12: return l.fdArea12;
      default: return '';
    }
  }
  String _areaEmoji(int h) => const {
    1: '🌿', 2: '💰', 3: '🗣️', 4: '🏠', 5: '🎨', 6: '💼',
    7: '❤️', 8: '🔮', 9: '✈️', 10: '🏆', 11: '🌐', 12: '🧘',
  }[h] ?? '•';

  String _status(double s, AppLocalizations l) {
    if (s >= 75) return l.gradeExcellent;
    if (s >= 60) return l.gradeGood;
    if (s >= 48) return l.fdStatusAverage;
    if (s >= 38) return l.fdStatusMixed;
    if (s >= 28) return l.fdStatusChallenging;
    return l.doshCritical;
  }
  Color _statusColor(double s) {
    if (s >= 75) return KColors.green;
    if (s >= 60) return KColors.blue;
    if (s >= 48) return KColors.yellow;
    if (s >= 38) return KColors.orange;
    return KColors.red;
  }
  /// A highlight flag is a "caution" when it warns against pushing in a weak
  /// domain (backend type `depressed_probability`) or when it describes a
  /// risk/protective event (accident, expense-outflow, loss, medical, etc.).
  /// Everything else is a favourable/beneficial window. Presentation only —
  /// derived from the flag's own fields, no scoring change.
  bool _isCautionFlag(Map f) {
    if ((f['type']?.toString() ?? '') == 'depressed_probability') return true;
    final t = '${f['event'] ?? ''} ${f['recommended_action'] ?? ''}'.toLowerCase();
    const markers = [
      'risk', 'protective', 'protection', 'accident', 'expense', 'outflow',
      'hospitaliz', 'medical-procedure', 'surgery', 'defer', 'awareness', 'loss',
    ];
    return markers.any(t.contains);
  }

  /// Green for favourable windows; amber/red for cautions & risks (red only
  /// for the highest-severity risks). Strength is still shown by the badge.
  Color _flagColor(Map f) {
    if (_isCautionFlag(f)) {
      return (f['severity']?.toString().toUpperCase() == 'CRITICAL')
          ? KColors.red
          : KColors.orange;
    }
    return KColors.green;
  }

  String _flagEmoji(Map f) {
    if (_isCautionFlag(f)) {
      return (f['severity']?.toString().toUpperCase() == 'CRITICAL') ? '🚨' : '⚠️';
    }
    return '✨';
  }

  String _severityLabel(String sev, AppLocalizations l) {
    switch (sev.toUpperCase()) {
      case 'CRITICAL': return l.fdProbVeryHigh;
      case 'HIGH': return l.fdProbHigh;
      case 'ELEVATED': return l.fdProbElevated;
      default: return l.fdProbCaution;
    }
  }
  String _weekdayShort(String w) {
    final i = w.indexOf('(');
    return i > 0 ? w.substring(0, i).trim() : w;
  }
  static String _tc(String s) => s.replaceAll('_', ' ').split(' ')
    .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
}
