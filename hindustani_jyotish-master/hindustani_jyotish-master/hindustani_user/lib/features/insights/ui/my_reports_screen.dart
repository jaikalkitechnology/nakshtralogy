import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/premium_ui.dart';
import '../../../shared/responsive.dart';
import '../insight_models.dart';
import '../insights_repository.dart';
import '../report_files.dart';
import 'insight_result_sheet.dart';

/// Paged reports state — the loaded rows plus enough bookkeeping for
/// infinite scroll (same shape as [AstrologersState] in discovery).
class _ReportsState {
  const _ReportsState({
    this.items,
    this.error,
    this.loadingMore = false,
    this.hasMore = true,
    this.page = 1,
  });

  final List<InsightReport>? items;
  final String? error;
  final bool loadingMore;
  final bool hasMore;
  final int page;
}

/// Incrementally loads `GET /kundli/reports` 20 rows a page: page 1 on
/// load/refresh, and the next page whenever the list nears its end while the
/// last fetch returned a full page.
class _ReportsCubit extends Cubit<_ReportsState> {
  _ReportsCubit(this._repo) : super(const _ReportsState());

  final InsightsRepository _repo;

  static const int _pageSize = 20;

  Future<void> load() async {
    try {
      final items = await _repo.myReports(page: 1, pageSize: _pageSize);
      emit(_ReportsState(
        items: items,
        page: 1,
        hasMore: items.length >= _pageSize,
      ));
    } on ApiException catch (e) {
      emit(_ReportsState(items: state.items, error: e.message));
    }
  }

  /// Pull-to-refresh: resets to page 1.
  Future<void> refresh() => load();

  Future<void> loadMore() async {
    if (state.loadingMore || !state.hasMore || state.items == null) return;
    final nextPage = state.page + 1;
    emit(_ReportsState(
      items: state.items,
      page: state.page,
      hasMore: true,
      loadingMore: true,
    ));
    try {
      final more = await _repo.myReports(page: nextPage, pageSize: _pageSize);
      emit(_ReportsState(
        items: [...state.items!, ...more],
        page: nextPage,
        hasMore: more.length >= _pageSize,
      ));
    } on ApiException {
      // Keep what we have; scrolling again retries the same page.
      emit(_ReportsState(
        items: state.items,
        page: state.page,
        hasMore: true,
      ));
    }
  }
}

/// Past paid insight reports (`GET /kundli/reports`) with pull-to-refresh,
/// infinite scroll and an open-PDF action per row.
class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<_ReportsCubit>(
      create: (_) => _ReportsCubit(getIt<InsightsRepository>())..load(),
      child: const _ReportsView(),
    );
  }
}

class _ReportsView extends StatelessWidget {
  const _ReportsView();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.insightsMyReports)),
      body: SafeArea(
        child: CenteredMaxWidth(
          maxWidth: Responsive.readableMaxWidth,
          child: BlocBuilder<_ReportsCubit, _ReportsState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () => context.read<_ReportsCubit>().refresh(),
                color: AppColors.saffron,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n.metrics.pixels >= n.metrics.maxScrollExtent - 400) {
                      context.read<_ReportsCubit>().loadMore();
                    }
                    return false;
                  },
                  child: _body(context, l, state),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, AppLocalizations l, _ReportsState state) {
    final items = state.items;
    if (items == null) {
      final err = state.error;
      if (err != null) {
        return _scrollMessage(
          icon: Icons.error_outline,
          tone: TileTone.saffron,
          text: err,
          color: AppColors.danger,
        );
      }
      return const Center(
        child: CircularProgressIndicator(color: AppColors.saffron),
      );
    }
    if (items.isEmpty) {
      return _scrollMessage(
        icon: Icons.auto_stories_outlined,
        tone: TileTone.gold,
        text: l.reportsEmpty,
        color: AppColors.ivoryDim,
      );
    }
    // index 0 is the section header; the trailing slot is the load-more spinner.
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      itemCount: items.length + 1 + (state.loadingMore ? 1 : 0),
      itemBuilder: (_, i) {
        if (i == 0) {
          return SectionLabel(
            l.insightsMyReports,
            trailing: StatusChip('${items.length}', tone: ChipTone.warn),
          );
        }
        final idx = i - 1;
        if (idx >= items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.saffron),
            ),
          );
        }
        return _ReportRow(report: items[idx]);
      },
    );
  }

  Widget _scrollMessage({
    required IconData icon,
    required TileTone tone,
    required String text,
    required Color color,
  }) =>
      ListView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        children: [
          const SizedBox(height: 140),
          Center(child: IconTile(icon, tone: tone, size: 68)),
          const SizedBox(height: 18),
          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(color: color),
            ),
          ),
        ],
      );
}

/// Service key → localized display name (falls back to a title-cased key for
/// any future service the app doesn't know yet).
String reportTypeName(AppLocalizations l, String type) => switch (type) {
      'detailed_kundli' => l.insightDetailedKundli,
      'daily_horoscope' => l.insightDailyHoroscope,
      'planet_position' => l.insightPlanetPosition,
      'love_compatibility' => l.insightLoveCompatibility,
      'birthday_number' => l.insightBirthdayNumber,
      'daily_prediction' => l.insightDailyPrediction,
      _ => titleCaseKey(type),
    };

IconData _reportIcon(String type) => switch (type) {
      'detailed_kundli' => Icons.grid_4x4,
      'daily_horoscope' => Icons.wb_sunny_outlined,
      'planet_position' => Icons.public,
      'love_compatibility' => Icons.favorite_border,
      'birthday_number' => Icons.cake_outlined,
      'daily_prediction' => Icons.auto_graph,
      _ => Icons.description_outlined,
    };

class _ReportRow extends StatelessWidget {
  const _ReportRow({required this.report});
  final InsightReport report;

  String? _dateLabel() {
    final dt = report.createdAt?.toLocal();
    if (dt == null) return null;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year} · ${two(dt.hour)}:${two(dt.minute)}';
  }

  /// Downloads the PDF to the device on first use (after which it opens
  /// OFFLINE from local storage) and shows it in the system PDF viewer.
  /// Falls back to the browser if no on-device viewer can handle it.
  Future<void> _openPdf(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final wasLocal = await ReportFiles.localIfExists(report.id) != null;
      final file = await ReportFiles.ensureDownloaded(
          reportId: report.id, url: report.pdfUrl!);
      if (!wasLocal) {
        messenger.showSnackBar(SnackBar(content: Text(l.reportSavedOffline)));
      }
      if (await ReportFiles.open(file)) return;
      // No PDF viewer installed — try the browser as a last resort.
      final uri = Uri.tryParse(report.pdfUrl!);
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

  /// Shares the saved PDF via the system share sheet (WhatsApp, Email,
  /// Telegram, …), downloading it first if needed.
  Future<void> _sharePdf(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final file = await ReportFiles.ensureDownloaded(
          reportId: report.id, url: report.pdfUrl!);
      await ReportFiles.share(file, text: reportTypeName(l, report.type));
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.insightPdfOpenFailed)));
    }
  }

  /// Kind key the result sheet renders with, from the stored service type.
  static String _kindOf(String type) => switch (type) {
        'detailed_kundli' => 'kundli',
        'planet_position' => 'planet',
        'daily_horoscope' => 'daily',
        'daily_prediction' => 'prediction',
        'love_compatibility' => 'love',
        'birthday_number' => 'number',
        _ => 'generic',
      };

  /// Reopens the stored report from the DB (no astrology-API call, nothing
  /// charged) in the same result sheet a fresh generation uses. Rows from
  /// before data storage existed 404 — fall back to their PDF.
  Future<void> _open(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    // A detailed kundli reopens in the rich full-analysis viewer (keyed off
    // the report id = chart_id); every other report type uses the result
    // sheet as before.
    if (report.type == 'detailed_kundli') {
      context.push('/kundli/${report.id}', extra: report.subjectName);
      return;
    }
    Map<String, dynamic> res;
    try {
      res = await getIt<InsightsRepository>().reportDetail(report.id);
    } on ApiException catch (e) {
      if (e.statusCode == 404 && report.pdfUrl != null) {
        if (context.mounted) await _openPdf(context);
        return;
      }
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      return;
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.reportOpenFailed)));
      return;
    }
    if (!context.mounted) return;
    await showInsightResultSheet(
      context,
      kind: _kindOf(report.type),
      title: reportTypeName(l, report.type),
      response: res,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final date = _dateLabel();
    return InkWell(
      onTap: () => _open(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderMid),
      ),
      child: Row(
        children: [
          Icon(_reportIcon(report.type), color: AppColors.saffron),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Planet Position — Rahul Sharma": the subject's name sits
                // IN the title line, so whose report it is reads at a
                // glance without opening the PDF. The name half is gold to
                // stand apart from the service name.
                RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: [
                    TextSpan(
                      text: reportTypeName(l, report.type),
                      style: AppTextStyles.body(
                          size: 15, weight: FontWeight.w700),
                    ),
                    if (report.subjectName != null)
                      TextSpan(
                        text: ' — ${report.subjectName}',
                        style: AppTextStyles.body(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AppColors.gold),
                      ),
                  ]),
                ),
                if (date != null) ...[
                  const SizedBox(height: 2),
                  Text(date,
                      style: AppTextStyles.mono(size: 12, color: AppColors.ivoryDim)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (report.amount != null)
            Text('₹${report.amount}',
                style: AppTextStyles.mono(size: 13, color: AppColors.ivory)),
          if (report.pdfUrl != null) ...[
            const SizedBox(width: 4),
            IconButton(
              tooltip: l.reportsOpenPdf,
              icon: const Icon(Icons.picture_as_pdf_outlined,
                  color: AppColors.gold),
              onPressed: () => _openPdf(context),
            ),
            IconButton(
              tooltip: l.insightSharePdf,
              icon: const Icon(Icons.share_outlined,
                  color: AppColors.copperLight),
              onPressed: () => _sharePdf(context),
            ),
          ],
        ],
      ),
      ),
    );
  }
}
