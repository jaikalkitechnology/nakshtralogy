import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../insight_models.dart';
import '../insights_repository.dart';
import 'kundli_chart.dart';
import 'kundli_section_scaffold.dart';

// ═══════════════════════════════════════════════════════════════════════
//  SUMMARY
// ═══════════════════════════════════════════════════════════════════════

class KundliSummaryView extends StatelessWidget {
  const KundliSummaryView({super.key, required this.chart, this.complete});
  final Map<String, dynamic> chart;
  final Map<String, dynamic>? complete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final k = KundliResult.fromData(chart);
    final planets = parseChartPlanets(chart).planets;
    InsightPlanet? byName(String n) {
      for (final p in planets) {
        if (p.name == n) return p;
      }
      return null;
    }

    final moon = byName('Moon');
    final sun = byName('Sun');

    final dosh = complete?['dosh_analysis'] is Map
        ? AnalysisSummary.fromData(
            (complete!['dosh_analysis'] as Map).cast<String, dynamic>(), 'doshas')
        : null;
    final yoga = complete?['yoga_analysis'] is Map
        ? AnalysisSummary.fromData(
            (complete!['yoga_analysis'] as Map).cast<String, dynamic>(), 'yogas')
        : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.surface2, AppColors.copperGlow],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderMid),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${chart['name'] ?? ''}',
                style: AppTextStyles.display(size: 20)),
            const SizedBox(height: 2),
            Text([chart['dob'], chart['tob'], chart['place']]
                .whereType<String>()
                .where((s) => s.isNotEmpty)
                .join(' · '),
                style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
          ]),
        ),
        const SizedBox(height: 14),
        Wrap(spacing: 12, runSpacing: 12, children: [
          if (k.lagna != null)
            _stat(l.summaryLagna, k.lagna!.signFull ?? k.lagna!.sign ?? '—', AppColors.gold),
          if (moon != null)
            _stat(l.summaryMoon, moon.signFull ?? moon.sign ?? '—', AppColors.info),
          if (sun != null)
            _stat(l.summarySun, sun.signFull ?? sun.sign ?? '—', AppColors.saffron),
          if (dosh != null)
            _stat(l.summaryActiveDoshas, '${dosh.active}/${dosh.total}', AppColors.danger),
          if (yoga != null)
            _stat(l.summaryActiveYogas, '${yoga.active}/${yoga.total}', AppColors.success),
        ]),
        const SizedBox(height: 14),
        if (k.lagna?.signIdx != null && k.planets.isNotEmpty)
          KundliSectionCard(
            title: l.kundliChartTitle,
            icon: Icons.grid_on,
            child: KundliChart(lagnaSignIdx: k.lagna!.signIdx!, planets: k.planets),
          ),
      ],
    );
  }

  Widget _stat(String label, String value, Color color) => Container(
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label(size: 9.5, color: AppColors.ivoryFaint)),
          const SizedBox(height: 3),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(size: 14, weight: FontWeight.w700, color: color)),
        ]),
      );
}

// ═══════════════════════════════════════════════════════════════════════
//  PLANETS
// ═══════════════════════════════════════════════════════════════════════

class KundliPlanetsView extends StatelessWidget {
  const KundliPlanetsView({super.key, required this.chart});
  final Map<String, dynamic> chart;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final parsed = parseChartPlanets(chart);
    final all = [if (parsed.lagna != null) parsed.lagna!, ...parsed.planets];
    if (all.isEmpty) {
      return Center(
          child: Text(l.kunNoData,
              style: AppTextStyles.body(color: AppColors.ivoryFaint)));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        KundliSectionCard(
          title: l.kundliPlanetsTitle,
          icon: Icons.public,
          subtitle: l.kundliRetroLegend,
          child: Column(children: [for (final p in all) _PlanetRow(p: p, l: l)]),
        ),
      ],
    );
  }
}

class _PlanetRow extends StatelessWidget {
  const _PlanetRow({required this.p, required this.l});
  final InsightPlanet p;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final badges = <Widget>[
      if (p.vakri) KundliBadge(text: 'R', color: AppColors.info),
      if (p.combust) KundliBadge(text: 'C', color: AppColors.saffron),
      if (p.vargottam) KundliBadge(text: 'Vgt', color: AppColors.gold),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kundliPlanetColor(p.name).withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Text(kundliPlanetSymbols[p.name] ?? p.abbr,
                style: TextStyle(color: kundliPlanetColor(p.name), fontSize: 15)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(p.name,
                    style: AppTextStyles.body(size: 13.5, weight: FontWeight.w700)),
                const SizedBox(width: 8),
                for (final b in badges) ...[b, const SizedBox(width: 4)],
              ]),
              const SizedBox(height: 2),
              Text(
                [
                  p.signFull ?? p.sign,
                  if (p.degree != null) '${p.degree!.toStringAsFixed(2)}°',
                  if (p.nakshatra != null)
                    '${p.nakshatra}${p.pada != null ? ' · ${l.colPada} ${p.pada}' : ''}',
                  if (p.dignity != null) p.dignity,
                ].whereType<String>().join('  ·  '),
                style: AppTextStyles.body(size: 11.5, color: AppColors.ivoryDim),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  GOCHAR (transit scores)
// ═══════════════════════════════════════════════════════════════════════

class KundliGocharView extends StatelessWidget {
  const KundliGocharView({super.key, required this.chartId, this.moonSign});
  final String chartId;
  final int? moonSign;

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      loader: () => getIt<InsightsRepository>().gocharToday(moonSign: moonSign),
      builder: (ctx, data) => _GocharBody(data: data, moonSign: moonSign),
    );
  }
}

class _GocharBody extends StatelessWidget {
  const _GocharBody({required this.data, this.moonSign});
  final Map<String, dynamic> data;
  final int? moonSign;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final g = GocharResult.fromData(data);
    if (g.isEmpty) {
      return Center(
          child: Text(l.kunNoData,
              style: AppTextStyles.body(color: AppColors.ivoryFaint)));
    }
    final maxAbs = g.rashis
        .map((r) => (r.score ?? 0).abs())
        .fold<double>(1, (a, b) => a > b ? a : b);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        Row(children: [
          Expanded(child: _hl(l.gocharBest, g.best ?? '—', AppColors.success)),
          const SizedBox(width: 12),
          Expanded(child: _hl(l.gocharWorst, g.worst ?? '—', AppColors.danger)),
        ]),
        const SizedBox(height: 14),
        KundliSectionCard(
          title: l.kunGochar,
          icon: Icons.wb_sunny,
          subtitle: g.date,
          child: Column(children: [
            for (final r in g.rashis)
              _rashiRow(l, r, maxAbs,
                  highlight: moonSign != null && r.rashiIdx == moonSign),
          ]),
        ),
      ],
    );
  }

  Widget _hl(String label, String value, Color color) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label.toUpperCase(),
              style: AppTextStyles.label(size: 10, color: AppColors.ivoryFaint)),
          const SizedBox(height: 3),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(size: 15, weight: FontWeight.w700, color: color)),
        ]),
      );

  Widget _rashiRow(AppLocalizations l, GocharRashi r, double maxAbs,
      {required bool highlight}) {
    final score = r.score ?? 0;
    final color = kundliGradeColor((score + maxAbs), max: maxAbs * 2);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: highlight ? AppColors.goldGlow : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: highlight
            ? Border.all(color: AppColors.gold.withValues(alpha: 0.4))
            : null,
      ),
      child: Row(children: [
        SizedBox(
          width: 96,
          child: Text(highlight ? '★ ${r.rashi}' : r.rashi,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(
                  size: 12.5,
                  weight: FontWeight.w600,
                  color: highlight ? AppColors.gold : AppColors.ivory)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: ((score + maxAbs) / (maxAbs * 2)).clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: AppColors.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 46,
          child: Text('${score > 0 ? '+' : ''}${score.toStringAsFixed(0)}',
              textAlign: TextAlign.right,
              style: AppTextStyles.mono(size: 12, weight: FontWeight.w700, color: color)),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  DOSH / YOGA (shared list)
// ═══════════════════════════════════════════════════════════════════════

class KundliDoshView extends StatelessWidget {
  const KundliDoshView({super.key, required this.chartId, this.initial});
  final String chartId;
  final Map<String, dynamic>? initial;

  @override
  Widget build(BuildContext context) => SectionLoader(
        initial: initial,
        loader: () => getIt<InsightsRepository>().kundliDosh(chartId),
        builder: (ctx, data) => _FindingsBody(data: data, itemsKey: 'doshas', isDosh: true),
      );
}

class KundliYogaView extends StatelessWidget {
  const KundliYogaView({super.key, required this.chartId, this.initial});
  final String chartId;
  final Map<String, dynamic>? initial;

  @override
  Widget build(BuildContext context) => SectionLoader(
        initial: initial,
        loader: () => getIt<InsightsRepository>().kundliYoga(chartId),
        builder: (ctx, data) => _FindingsBody(data: data, itemsKey: 'yogas', isDosh: false),
      );
}

class _FindingsBody extends StatelessWidget {
  const _FindingsBody({required this.data, required this.itemsKey, required this.isDosh});
  final Map<String, dynamic> data;
  final String itemsKey;
  final bool isDosh;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = AnalysisSummary.fromData(data, itemsKey);
    final active = s.activeItems;
    final accent = isDosh ? AppColors.saffron : AppColors.success;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        Row(children: [
          Expanded(
              child: _stat(isDosh ? l.doshActive : l.yogaActive, '${s.active}', accent)),
          const SizedBox(width: 12),
          Expanded(child: _stat(l.kunChecked, '${s.total}', AppColors.info)),
        ]),
        const SizedBox(height: 14),
        if (active.isEmpty)
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Column(children: [
              const Icon(Icons.verified_rounded, color: AppColors.success, size: 38),
              const SizedBox(height: 10),
              Text(isDosh ? l.doshNone : l.yogaNone,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(size: 13.5, weight: FontWeight.w700)),
            ]),
          )
        else
          for (final item in active) _FindingCard(item: item, accent: accent, l: l),
      ],
    );
  }

  Widget _stat(String label, String value, Color color) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label.toUpperCase(),
              style: AppTextStyles.label(size: 9.5, color: AppColors.ivoryFaint)),
          const SizedBox(height: 3),
          Text(value,
              style: AppTextStyles.display(size: 22, color: color)),
        ]),
      );
}

class _FindingCard extends StatefulWidget {
  const _FindingCard({required this.item, required this.accent, required this.l});
  final AnalysisItem item;
  final Color accent;
  final AppLocalizations l;

  @override
  State<_FindingCard> createState() => _FindingCardState();
}

class _FindingCardState extends State<_FindingCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final score = item.score ?? 0;
    final color = kundliGradeColor(score);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                  width: 6,
                  height: 40,
                  decoration:
                      BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(size: 14, weight: FontWeight.w700)),
                  if (item.category != null) ...[
                    const SizedBox(height: 2),
                    Text(item.category!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body(size: 11, color: AppColors.ivoryFaint)),
                  ],
                ]),
              ),
              Text('${score.toStringAsFixed(0)}%',
                  style: AppTextStyles.mono(
                      size: 14, weight: FontWeight.w700, color: color)),
              AnimatedRotation(
                turns: _open ? 0.5 : 0,
                duration: const Duration(milliseconds: 220),
                child: Icon(Icons.expand_more, color: color),
              ),
            ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Divider(height: 1, color: AppColors.borderSoft),
              const SizedBox(height: 10),
              ScoreBar(
                  label: widget.l.colStrength,
                  value: score,
                  color: color,
                  valueText: '${score.toStringAsFixed(0)}%'),
              if (item.description != null) ...[
                const SizedBox(height: 8),
                Text(item.description!,
                    style: AppTextStyles.body(size: 12.5, color: AppColors.ivoryDim)),
              ],
              if (item.factors.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(widget.l.kunFactors,
                    style: AppTextStyles.label(size: 11, color: AppColors.copperLight)),
                const SizedBox(height: 4),
                Text(item.factors.join('\n'),
                    style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
              ],
              if (item.cancels.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(widget.l.kunCancellation,
                    style: AppTextStyles.label(size: 11, color: AppColors.success)),
                const SizedBox(height: 4),
                Text(item.cancels.join('\n'),
                    style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
              ],
            ]),
          ),
          crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 240),
          sizeCurve: Curves.easeInOut,
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  SHADBALA
// ═══════════════════════════════════════════════════════════════════════

class KundliShadbalaView extends StatelessWidget {
  const KundliShadbalaView({super.key, required this.chartId, this.initial});
  final String chartId;
  final Map<String, dynamic>? initial;

  @override
  Widget build(BuildContext context) => SectionLoader(
        initial: initial,
        loader: () => getIt<InsightsRepository>().kundliShadbala(chartId),
        builder: (ctx, data) => _ShadbalaBody(data: data),
      );
}

class _ShadbalaBody extends StatelessWidget {
  const _ShadbalaBody({required this.data});
  final Map<String, dynamic> data;

  static const _balaLabels = {
    'sthana_bala': 'Sthana', 'dig_bala': 'Dig', 'kala_bala': 'Kala',
    'chesta_bala': 'Chesta', 'naisargika_bala': 'Naisargika', 'drik_bala': 'Drik',
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final r = ShadbalaResult.fromData(data);
    if (r.isEmpty) {
      return Center(
          child: Text(l.kunNoData,
              style: AppTextStyles.body(color: AppColors.ivoryFaint)));
    }
    final ranked = [...r.planets]
      ..sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        KundliSectionCard(
          title: l.shadbalaRanking,
          icon: Icons.emoji_events_outlined,
          child: Column(children: [
            for (final p in ranked)
              ScoreBar(
                label: p.planet,
                value: p.score ?? 0,
                max: 130,
                color: kundliGradeColor(p.score ?? 0, max: 130),
              ),
          ]),
        ),
        for (final p in ranked) _planetCard(l, p),
      ],
    );
  }

  Widget _planetCard(AppLocalizations l, ShadbalaPlanet p) {
    final score = p.score ?? 0;
    final color = kundliGradeColor(score, max: 130);
    return KundliSectionCard(
      title: p.planet,
      icon: null,
      trailing: Text(
        '${score.toStringAsFixed(0)} · ${(p.totalRupas ?? 0).toStringAsFixed(2)} ${l.shadbalaRupas}',
        style: AppTextStyles.mono(size: 11.5, weight: FontWeight.w700, color: color),
      ),
      child: Column(children: [
        for (final e in p.balas.entries)
          ScoreBar(
            label: _balaLabels[e.key] ?? e.key,
            value: e.value,
            max: 6,
            valueText: e.value.toStringAsFixed(2),
          ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  ASHTAKAVARGA
// ═══════════════════════════════════════════════════════════════════════

class KundliAshtakavargaView extends StatelessWidget {
  const KundliAshtakavargaView({super.key, required this.chartId, this.initial});
  final String chartId;
  final Map<String, dynamic>? initial;

  @override
  Widget build(BuildContext context) => SectionLoader(
        initial: initial,
        loader: () => getIt<InsightsRepository>().kundliAshtakavarga(chartId),
        builder: (ctx, data) => _AshtakavargaBody(data: data),
      );
}

class _AshtakavargaBody extends StatelessWidget {
  const _AshtakavargaBody({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final av = AshtakavargaResult.fromData(data);
    if (av.isEmpty) {
      return Center(
          child: Text(l.kunNoData,
              style: AppTextStyles.body(color: AppColors.ivoryFaint)));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        KundliSectionCard(
          title: l.avSavTitle,
          icon: Icons.grid_view,
          subtitle: av.savTotal != null ? l.avSavTotal('${av.savTotal}') : null,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final code in kSignShort)
                if (av.sav[code] != null) _savCell(code, av.sav[code]!),
            ],
          ),
        ),
        if (av.planetsBav.isNotEmpty)
          KundliSectionCard(
            title: l.avBavTitle,
            icon: Icons.bar_chart,
            child: Column(children: [
              for (final e in av.planetsBav.entries)
                ScoreBar(
                  label: e.key,
                  value: (e.value['total_rekha'] as num?)?.toDouble() ?? 0,
                  max: 56,
                  color: kundliPlanetColor(e.key),
                  valueText: '${e.value['total_rekha'] ?? '—'}',
                ),
            ]),
          ),
      ],
    );
  }

  Widget _savCell(String code, int value) {
    final color = kundliGradeColor(value.toDouble(), max: 40);
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(children: [
        Text(code,
            style: AppTextStyles.label(size: 10, color: AppColors.ivoryDim)),
        const SizedBox(height: 2),
        Text('$value',
            style: AppTextStyles.body(size: 15, weight: FontWeight.w800, color: color)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  ASPECTS
// ═══════════════════════════════════════════════════════════════════════

class KundliAspectsView extends StatelessWidget {
  const KundliAspectsView({super.key, required this.chartId, this.initial});
  final String chartId;
  final Map<String, dynamic>? initial;

  @override
  Widget build(BuildContext context) => SectionLoader(
        initial: initial,
        loader: () => getIt<InsightsRepository>().kundliAspects(chartId),
        builder: (ctx, data) => _AspectsBody(data: data),
      );
}

class _AspectsBody extends StatelessWidget {
  const _AspectsBody({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final graha = (data['graha_drishti'] as Map?)?.cast<String, dynamic>() ?? const {};
    final rashi = (data['rashi_drishti'] as Map?)?.cast<String, dynamic>() ?? const {};
    if (graha.isEmpty && rashi.isEmpty) {
      return Center(
          child: Text(l.kunNoData,
              style: AppTextStyles.body(color: AppColors.ivoryFaint)));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        KundliSectionCard(
          title: l.aspectsGraha,
          icon: Icons.hub_outlined,
          child: Column(children: [
            for (final e in graha.entries)
              if (e.value is Map && (e.value as Map).isNotEmpty)
                _grahaRow(e.key, (e.value as Map).cast<String, dynamic>()),
          ]),
        ),
        if (rashi.isNotEmpty)
          KundliSectionCard(
            title: l.aspectsRashi,
            icon: Icons.change_history,
            child: Column(children: [
              for (final e in rashi.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(
                        width: 40,
                        child: Text(e.key,
                            style: AppTextStyles.body(
                                size: 12.5, weight: FontWeight.w700, color: AppColors.gold))),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                          (e.value is List)
                              ? (e.value as List).join('  ·  ')
                              : '${e.value}',
                          style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
                    ),
                  ]),
                ),
            ]),
          ),
      ],
    );
  }

  Widget _grahaRow(String aspector, Map<String, dynamic> targets) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kundliPlanetColor(aspector).withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
          child: Text(kundliPlanetSymbols[aspector] ?? aspector.characters.first,
              style: TextStyle(color: kundliPlanetColor(aspector), fontSize: 14)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final t in targets.entries)
                KundliBadge(
                  text: t.value is Map && (t.value as Map)['house'] != null
                      ? '${t.key} (${(t.value as Map)['house']})'
                      : t.key,
                ),
            ],
          ),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  BHAVA (house strength)
// ═══════════════════════════════════════════════════════════════════════

class KundliBhavaView extends StatelessWidget {
  const KundliBhavaView({super.key, required this.chartId, this.initial});
  final String chartId;
  final Map<String, dynamic>? initial;

  @override
  Widget build(BuildContext context) => SectionLoader(
        initial: initial,
        loader: () => getIt<InsightsRepository>().kundliBhava(chartId),
        builder: (ctx, data) => _BhavaBody(data: data),
      );
}

class _BhavaBody extends StatelessWidget {
  const _BhavaBody({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final b = BhavaResult.fromData(data);
    if (b.isEmpty) {
      return Center(
          child: Text(l.kunNoData,
              style: AppTextStyles.body(color: AppColors.ivoryFaint)));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        for (final h in b.houses) _houseCard(l, h),
      ],
    );
  }

  Widget _houseCard(AppLocalizations l, BhavaHouse h) {
    final score = h.score ?? 0;
    final color = kundliGradeColor(score);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Text('${h.house}',
                style: AppTextStyles.display(size: 18, color: color)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.bhavaHouse('${h.house}'),
                  style: AppTextStyles.body(size: 13.5, weight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(
                [
                  if (h.sign != null) h.sign,
                  if (h.lord != null) '${l.bhavaLord}: ${h.lord}',
                  if (h.sav != null) 'SAV ${h.sav}',
                ].whereType<String>().join('  ·  '),
                style: AppTextStyles.body(size: 11.5, color: AppColors.ivoryDim),
              ),
            ]),
          ),
          Text(score.toStringAsFixed(0),
              style: AppTextStyles.mono(size: 14, weight: FontWeight.w700, color: color)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: (score / 100).clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: AppColors.surface2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        if (h.occupants.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [for (final o in h.occupants) KundliBadge(text: o)],
          ),
        ],
      ]),
    );
  }
}
