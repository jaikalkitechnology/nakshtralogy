import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../insight_models.dart';
import '../report_files.dart';
import 'cosmic_labels.dart';
import 'full_response_view.dart';
import 'kundli_chart.dart';

/// Scrollable result sheet for a freshly generated insight. Renders the
/// curated per-service view (planet tables, chart diagram, scores, texts) and
/// offers the report PDF via url_launcher.
Future<void> showInsightResultSheet(
  BuildContext context, {
  required String kind, // 'daily' | 'kundli' | 'planet' | 'love' | 'number' | 'prediction'
  required String title,
  required Map<String, dynamic> response,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.indigoDeep,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, controller) => _InsightResultBody(
        kind: kind,
        title: title,
        response: response,
        controller: controller,
      ),
    ),
  );
}

class _InsightResultBody extends StatelessWidget {
  const _InsightResultBody({
    required this.kind,
    required this.title,
    required this.response,
    required this.controller,
  });

  final String kind;
  final String title;
  final Map<String, dynamic> response;
  final ScrollController controller;

  Map<String, dynamic> get _data =>
      response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : const {};

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final pdfUrl = pdfUrlOf(response);
    final charged = response['amount_charged'];
    final balance = response['wallet_balance'];
    // A zero charge (e.g. the free Detailed Kundli) reads "Free", not
    // "Charged ₹0".
    final isFree = (double.tryParse('${charged ?? ''}') ?? -1) == 0;

    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      children: [
        Text(title, style: AppTextStyles.heading(size: 20)),
        if (charged != null && balance != null) ...[
          const SizedBox(height: 4),
          Text(isFree ? l.insightFree : l.insightsChargedBalance(charged, balance),
              style: AppTextStyles.label(
                  size: 12, color: isFree ? AppColors.success : AppColors.gold)),
        ],
        const SizedBox(height: 16),
        ..._bodyFor(context, l),
        ..._fullReportButton(context),
        const SizedBox(height: 20),
        if (pdfUrl != null) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openPdf(context, pdfUrl),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: Text(l.insightDownloadPdf),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _sharePdf(context, pdfUrl),
              icon: const Icon(Icons.share_outlined),
              label: Text(l.insightSharePdf),
            ),
          ),
          const SizedBox(height: 10),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.commonClose),
          ),
        ),
      ],
    );
  }

  /// The complete localized Cosmic Services payload, when the backend included
  /// it (`data.full_response`). Absent on the stub/offline path.
  Map<String, dynamic>? get _fullResponse {
    final f = _data['full_response'];
    return f is Map<String, dynamic> && f.isNotEmpty ? f : null;
  }

  /// A prominent CTA that opens the full recursive report viewer — so the user
  /// sees the ENTIRE response, not just the curated sections above.
  List<Widget> _fullReportButton(BuildContext context) {
    final full = _fullResponse;
    if (full == null) return const [];
    final lang = Localizations.localeOf(context).languageCode;
    return [
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.copperLight,
            side: const BorderSide(color: AppColors.borderMid),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () => Navigator.of(context)
              .push(CosmicFullReportPage.route(title, full)),
          icon: const Icon(Icons.article_outlined),
          label: Text(cosmicUi('view_full', lang)),
        ),
      ),
    ];
  }

  List<Widget> _bodyFor(BuildContext context, AppLocalizations l) {
    final widgets = switch (kind) {
      'kundli' => _kundliBody(context, l),
      'planet' => _planetBody(l),
      'love' => _loveBody(l),
      'number' => _numberBody(l),
      'prediction' => _forecastBody(l),
      _ => _textBody(l),
    };
    if (widgets.isNotEmpty) return widgets;
    // Unknown/empty payload — never show a blank sheet after a paid call.
    return [
      Text(l.insightNoDetails,
          style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
    ];
  }

  // ── Detailed kundli ────────────────────────────────────────────────────

  /// The saved `KundliReport` id from the envelope's `report` block — the
  /// chart_id the full analysis viewer keys off. Null for older envelopes
  /// that carry no report block.
  String? get _chartId {
    final report = response['report'];
    if (report is Map<String, dynamic> && report['id'] != null) {
      return '${report['id']}';
    }
    return null;
  }

  List<Widget> _kundliBody(BuildContext context, AppLocalizations l) {
    final k = KundliResult.fromData(_data);
    final lagnaIdx = k.lagna?.signIdx;
    final chartId = _chartId;
    return [
      if (chartId != null) ...[
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.saffron,
              foregroundColor: AppColors.indigoVoid,
            ),
            onPressed: () {
              final router = GoRouter.of(context);
              Navigator.of(context).pop();
              router.push('/kundli/$chartId', extra: title);
            },
            icon: const Icon(Icons.auto_awesome),
            label: Text(l.kunOpenFullAnalysis),
          ),
        ),
        const SizedBox(height: 16),
      ],
      if (lagnaIdx != null && k.planets.isNotEmpty) ...[
        _SectionTitle(l.kundliChartTitle),
        KundliChart(lagnaSignIdx: lagnaIdx, planets: k.planets),
        const SizedBox(height: 6),
        Text(l.kundliRetroLegend,
            style: AppTextStyles.label(size: 11, color: AppColors.ivoryFaint)),
        const SizedBox(height: 16),
      ],
      if (k.lagna != null) ...[
        _KeyValueRow(
          label: l.kundliLagnaLabel,
          value: [
            k.lagna!.signFull,
            if (k.lagna!.degree != null) '${k.lagna!.degree!.toStringAsFixed(2)}°',
            if (k.lagna!.nakshatra != null)
              '${k.lagna!.nakshatra}${k.lagna!.pada != null ? ' ${l.colPada} ${k.lagna!.pada}' : ''}',
          ].whereType<String>().join(' · '),
        ),
        const SizedBox(height: 16),
      ],
      if (k.planets.isNotEmpty) ...[
        _SectionTitle(l.kundliPlanetsTitle),
        _PlanetTable(planets: k.planets, l: l),
        const SizedBox(height: 16),
      ],
      if (k.dashas.isNotEmpty) ...[
        _SectionTitle(l.kundliDashaTitle),
        for (final d in k.dashas) _DashaRow(dasha: d, l: l),
      ],
    ];
  }

  // ── Planet position ────────────────────────────────────────────────────

  List<Widget> _planetBody(AppLocalizations l) {
    // parseChartPlanets handles BOTH backend generations: the current shape
    // (data.planets is a name-keyed map incl. a "Lagna" entry) and the
    // older stub shape (data.planets is a LIST + top-level ascendant_sign).
    // Against an old server the previous map-only parsing produced an
    // almost-empty dark sheet — reported as a "black screen" — after the
    // wallet was already charged.
    final parsed = _data['planets'] == null && _data.values.any((v) => v is Map)
        ? parsePlanetMap(_data) // planets map arrived un-nested
        : parseChartPlanets(_data);
    if (parsed.planets.isEmpty && parsed.lagna == null) return const [];
    return [
      if (parsed.lagna?.signFull != null) ...[
        _KeyValueRow(label: l.kundliLagnaLabel, value: parsed.lagna!.signFull!),
        const SizedBox(height: 16),
      ],
      _SectionTitle(l.kundliPlanetsTitle),
      _PlanetTable(planets: parsed.planets, l: l),
      const SizedBox(height: 6),
      Text(l.kundliRetroLegend,
          style: AppTextStyles.label(size: 11, color: AppColors.ivoryFaint)),
    ];
  }

  // ── Love compatibility ─────────────────────────────────────────────────

  List<Widget> _loveBody(AppLocalizations l) {
    final m = LoveMatchResult.fromData(_data);
    if (m.isEmpty) return _textBody(l);
    return [
      if (m.partner1Name != null && m.partner2Name != null) ...[
        Text('${m.partner1Name} ♥ ${m.partner2Name}',
            style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
        const SizedBox(height: 12),
      ],
      if (m.unifiedScore != null) ...[
        _ScoreBadge(
          value: m.unifiedScore!,
          max: 100,
          label: l.loveScoreTitle,
          caption: m.unifiedGrade,
        ),
        const SizedBox(height: 16),
      ],
      if (m.verdict != null || m.plainStatement != null) ...[
        _SectionTitle(l.loveVerdictTitle),
        if (m.verdict != null)
          Text(m.verdict!,
              style: AppTextStyles.body(size: 15, weight: FontWeight.w700, color: AppColors.gold)),
        if (m.plainStatement != null) ...[
          const SizedBox(height: 6),
          Text(m.plainStatement!,
              style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
        ],
        if (m.verdictExplanation != null) ...[
          const SizedBox(height: 6),
          Text(m.verdictExplanation!,
              style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
        ],
        const SizedBox(height: 16),
      ],
      if (m.ashtakootScore != null || m.breakdown.isNotEmpty) ...[
        _SectionTitle(l.loveAshtakootTitle),
        if (m.ashtakootScore != null)
          _KeyValueRow(
            label: '${_trimNum(m.ashtakootScore!)}/36',
            value: m.ashtakootGrade ?? '',
          ),
        const SizedBox(height: 8),
        for (final g in m.breakdown) _GunRow(gun: g),
        const SizedBox(height: 16),
      ],
      if (m.strengths.isNotEmpty) ...[
        _SectionTitle(l.loveStrengthsTitle),
        for (final s in m.strengths) _Bullet(text: s),
      ],
    ];
  }

  // ── Birthday number ────────────────────────────────────────────────────

  List<Widget> _numberBody(AppLocalizations l) {
    final n = BirthdayNumberResult.fromData(_data);
    final sections = genericSections(_data);
    if (n.number == null && n.traits.isEmpty && sections.isEmpty) return const [];
    return [
      if (n.number != null) ...[
        Center(
          child: Container(
            width: 88,
            height: 88,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 2),
              color: AppColors.surface2,
            ),
            child: Text('${n.number}',
                style: AppTextStyles.display(size: 36, color: AppColors.gold)),
          ),
        ),
        const SizedBox(height: 16),
      ],
      if (n.lifePath != null && n.lifePath != n.number) ...[
        _KeyValueRow(label: l.numberLifePath, value: '${n.lifePath}'),
        const SizedBox(height: 12),
      ],
      if (n.traits.isNotEmpty) ...[
        _SectionTitle(l.numberTraitsTitle),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in n.traits)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Text(t, style: AppTextStyles.body(size: 13)),
              ),
          ],
        ),
        const SizedBox(height: 16),
      ],
      for (final s in sections) _SectionBlock(section: s),
    ];
  }

  // ── Daily prediction (forecast) ────────────────────────────────────────

  List<Widget> _forecastBody(AppLocalizations l) {
    final f = ForecastResult.fromData(_data);
    if (f.isEmpty) return _textBody(l);
    return [
      if (f.targetDate != null || f.weekday != null) ...[
        Text([f.weekday, f.targetDate].whereType<String>().join(' · '),
            style: AppTextStyles.mono(size: 12, color: AppColors.ivoryDim)),
        const SizedBox(height: 10),
      ],
      if (f.grade != null || f.qualityScore != null) ...[
        Row(
          children: [
            if (f.grade != null)
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderMid),
                  ),
                  child: Text(f.grade!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.label(size: 13, color: AppColors.gold)),
                ),
              ),
            if (f.qualityScore != null) ...[
              const SizedBox(width: 10),
              Text('${_trimNum(f.qualityScore!)}/100',
                  style: AppTextStyles.mono(size: 13, color: AppColors.ivoryDim)),
            ],
          ],
        ),
        const SizedBox(height: 12),
      ],
      if (f.summary != null) ...[
        Text(f.summary!, style: AppTextStyles.body(size: 15)),
        const SizedBox(height: 16),
      ],
      if (f.actions.isNotEmpty) ...[
        _SectionTitle(l.predictionActionsTitle),
        for (final a in f.actions) _Bullet(text: a, color: AppColors.success),
        const SizedBox(height: 12),
      ],
      if (f.cautions.isNotEmpty) ...[
        _SectionTitle(l.predictionCautionsTitle),
        for (final c in f.cautions) _Bullet(text: c, color: AppColors.danger),
      ],
    ];
  }

  // ── Horoscope & fallback texts ─────────────────────────────────────────

  List<Widget> _textBody(AppLocalizations l) =>
      [for (final s in genericSections(_data)) _SectionBlock(section: s)];

  /// Report id used to name the on-device copy — falls back to a hash of
  /// the URL when the envelope carries no report block.
  String get _reportId {
    final report = response['report'];
    if (report is Map<String, dynamic> && report['id'] != null) {
      return '${report['id']}';
    }
    return '${pdfUrlOf(response).hashCode}';
  }

  /// Downloads the PDF to the device on first use (after which it opens
  /// OFFLINE from local storage) and shows it in the system PDF viewer.
  Future<void> _openPdf(BuildContext context, String url) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final wasLocal = await ReportFiles.localIfExists(_reportId) != null;
      final file =
          await ReportFiles.ensureDownloaded(reportId: _reportId, url: url);
      if (!wasLocal) {
        messenger.showSnackBar(SnackBar(content: Text(l.reportSavedOffline)));
      }
      if (await ReportFiles.open(file)) return;
      final uri = Uri.tryParse(url);
      final opened = uri != null &&
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) {
        messenger.showSnackBar(SnackBar(content: Text(l.insightPdfOpenFailed)));
      }
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.insightPdfOpenFailed)));
    }
  }

  /// System share sheet (WhatsApp / Email / Telegram / …) for the saved
  /// PDF, downloading it first if needed.
  Future<void> _sharePdf(BuildContext context, String url) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final file =
          await ReportFiles.ensureDownloaded(reportId: _reportId, url: url);
      await ReportFiles.share(file, text: title);
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.insightPdfOpenFailed)));
    }
  }
}

String _trimNum(double v) =>
    v == v.roundToDouble() ? '${v.round()}' : v.toStringAsFixed(1);

// ── Shared building blocks ───────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: AppTextStyles.label(size: 13, color: AppColors.copperLight)),
      );
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(label,
                style: AppTextStyles.body(size: 14, weight: FontWeight.w700)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
          ),
        ],
      );
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({required this.section});
  final InsightSection section;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(section.title),
            if (section.text != null)
              Text(section.text!,
                  style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
            for (final b in section.bullets) _Bullet(text: b),
          ],
        ),
      );
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Icon(Icons.circle, size: 6, color: color ?? AppColors.gold),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text,
                  style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
            ),
          ],
        ),
      );
}

/// Planet | Sign | Degree | Nakshatra | Pada, with an "(R)" marker on
/// retrograde planets.
class _PlanetTable extends StatelessWidget {
  const _PlanetTable({required this.planets, required this.l});
  final List<InsightPlanet> planets;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    TableRow row(List<Widget> cells, {BoxDecoration? decoration}) => TableRow(
          decoration: decoration,
          children: [
            for (final c in cells)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: c,
              ),
          ],
        );

    Text header(String s) =>
        Text(s, style: AppTextStyles.label(size: 11, color: AppColors.ivoryFaint));
    Text cell(String s, {Color? color, FontWeight? weight}) => Text(s,
        style: AppTextStyles.body(
            size: 12.5, color: color ?? AppColors.ivoryDim, weight: weight ?? FontWeight.w500));

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.5),
          1: FlexColumnWidth(1.3),
          2: FlexColumnWidth(1.0),
          3: FlexColumnWidth(1.7),
          4: FlexColumnWidth(0.7),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          row([
            header(l.colPlanet),
            header(l.colSign),
            header(l.colDegree),
            header(l.colNakshatra),
            header(l.colPada),
          ]),
          for (final p in planets)
            row([
              cell(
                '${planetLocalName(p.name, lang)}${p.vakri ? ' (R)' : ''}',
                color: AppColors.ivory,
                weight: FontWeight.w700,
              ),
              cell(p.signFull ?? p.sign ?? '—'),
              cell(p.degree == null ? '—' : '${p.degree!.toStringAsFixed(2)}°'),
              cell(p.nakshatra ?? '—'),
              cell('${p.pada ?? '—'}'),
            ]),
        ],
      ),
    );
  }
}

class _DashaRow extends StatelessWidget {
  const _DashaRow({required this.dasha, required this.l});
  final DashaPeriod dasha;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final span = [dasha.start, dasha.end].whereType<String>().join(' – ');
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              dasha.years == null
                  ? dasha.planet
                  : '${dasha.planet} · ${l.cardYears(_trimNum(dasha.years!))}',
              style: AppTextStyles.body(size: 13, weight: FontWeight.w700),
            ),
          ),
          if (span.isNotEmpty)
            Text(span,
                style: AppTextStyles.mono(size: 11.5, color: AppColors.ivoryDim)),
        ],
      ),
    );
  }
}

class _GunRow extends StatelessWidget {
  const _GunRow({required this.gun});
  final GunScore gun;

  @override
  Widget build(BuildContext context) {
    final max = gun.max ?? 0;
    final score = gun.score ?? 0;
    final fraction = max > 0 ? (score / max).clamp(0.0, 1.0) : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(gun.gun,
                    style: AppTextStyles.body(size: 13, weight: FontWeight.w700)),
              ),
              Text('${_trimNum(score)}/${_trimNum(max)}',
                  style: AppTextStyles.mono(size: 12, color: AppColors.gold)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 5,
              backgroundColor: AppColors.surface2,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.saffron),
            ),
          ),
          if (gun.status != null || gun.meaning != null) ...[
            const SizedBox(height: 4),
            Text(gun.status ?? gun.meaning!,
                style: AppTextStyles.body(size: 12, color: AppColors.ivoryFaint)),
          ],
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({
    required this.value,
    required this.max,
    required this.label,
    this.caption,
  });

  final double value;
  final double max;
  final String label;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 110,
            height: 110,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: (value / max).clamp(0.0, 1.0),
                  strokeWidth: 7,
                  backgroundColor: AppColors.surface2,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.saffron),
                ),
                Center(
                  child: Text(_trimNum(value),
                      style: AppTextStyles.display(size: 30, color: AppColors.gold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.label(size: 12, color: AppColors.ivoryDim)),
          if (caption != null)
            Text(caption!,
                style: AppTextStyles.body(size: 14, weight: FontWeight.w700)),
        ],
      ),
    );
  }
}
