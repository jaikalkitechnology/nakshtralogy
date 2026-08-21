import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/premium_ui.dart';
import '../../../shared/responsive.dart';
import '../insight_models.dart';
import '../insights_repository.dart';
import 'insight_preflight.dart';
import 'insight_result_sheet.dart';

/// The catalog of available specialist report types (`GET
/// /insights/reports/catalog`; admin-priced, admin-toggleable).
typedef _CatalogCubit = DataCubit<List<SpecialReportType>>;

/// Localized display name for a specialist report type; falls back to the
/// admin-configured (English) catalog name for any type the app doesn't know.
String specialReportName(AppLocalizations l, SpecialReportType r) => switch (r.type) {
      'career' => l.reportCareer,
      'business' => l.reportBusiness,
      'education' => l.reportEducation,
      'wealth' => l.reportWealth,
      'debt_recovery' => l.reportDebtRecovery,
      'love' => l.reportLove,
      'marriage' => l.reportMarriage,
      'health' => l.reportHealth,
      'mental_stress' => l.reportMentalStress,
      'property' => l.reportProperty,
      'legal' => l.reportLegal,
      'life_path' => l.reportLifePath,
      'character' => l.reportCharacter,
      'past_life' => l.reportPastLife,
      _ => r.name,
    };

IconData _reportIcon(String type) => switch (type) {
      'career' => Icons.work_outline,
      'business' => Icons.storefront_outlined,
      'education' => Icons.school_outlined,
      'wealth' => Icons.savings_outlined,
      'debt_recovery' => Icons.account_balance_outlined,
      'love' => Icons.favorite_border,
      'marriage' => Icons.diversity_1_outlined,
      'health' => Icons.health_and_safety_outlined,
      'mental_stress' => Icons.self_improvement_outlined,
      'property' => Icons.home_work_outlined,
      'legal' => Icons.gavel_outlined,
      'life_path' => Icons.route_outlined,
      'character' => Icons.psychology_outlined,
      'past_life' => Icons.history_edu_outlined,
      _ => Icons.description_outlined,
    };

/// Grid of the specialist "Special Reports" (Phase J). Each tile shows the
/// localized report name + its admin price (or "Free"); tapping runs the same
/// birth-details preflight → generate → result-sheet flow the cosmic insights
/// use. The wallet is debited server-side at the admin price; kundli/insights
/// design tokens and the shared result sheet are reused.
class SpecialReportsScreen extends StatelessWidget {
  const SpecialReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.specialReportsTitle)),
      body: BlocProvider<_CatalogCubit>(
        create: (_) =>
            DataCubit(() => getIt<InsightsRepository>().reportsCatalog())..load(),
        child: SafeArea(
          child: CenteredMaxWidth(
            maxWidth: Responsive.readableMaxWidth,
            child: Builder(
              builder: (context) => RefreshIndicator(
                color: AppColors.saffron,
                onRefresh: () => context.read<_CatalogCubit>().refresh(),
                child: BlocBuilder<_CatalogCubit, DataState<List<SpecialReportType>>>(
                  builder: (context, state) {
                    final reports = state.dataOrNull;
                    if (reports == null) {
                      if (state.errorMessage != null) {
                        return _message(l.specialReportsEmpty);
                      }
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.saffron),
                      );
                    }
                    if (reports.isEmpty) return _message(l.specialReportsEmpty);
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                      children: [
                        SectionLabel(
                          l.specialReportsTitle,
                          trailing: StatusChip('${reports.length}',
                              tone: ChipTone.warn),
                        ),
                        Text(l.specialReportsSubtitle,
                            style:
                                AppTextStyles.body(color: AppColors.ivoryDim)),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final tileWidth = (constraints.maxWidth - 12) / 2;
                            return GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: tileWidth / 150,
                              children: [
                                for (final r in reports)
                                  _ReportTile(
                                    title: specialReportName(l, r),
                                    price: r.free
                                        ? l.insightFree
                                        : _rupees(r.price),
                                    icon: _reportIcon(r.type),
                                    onTap: () => _run(context, r),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _rupees(String? price) {
    if (price == null || price.isEmpty) return '';
    return '₹${price.endsWith('.00') ? price.substring(0, price.length - 3) : price}';
  }

  Widget _message(String text) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 28),
        children: [
          const SizedBox(height: 140),
          const Center(
            child: IconTile(Icons.auto_awesome_outlined,
                tone: TileTone.gold, size: 68),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(text,
                textAlign: TextAlign.center,
                style: AppTextStyles.body(color: AppColors.ivoryDim)),
          ),
        ],
      );

  Future<void> _run(BuildContext context, SpecialReportType report) async {
    final repo = getIt<InsightsRepository>();
    final messenger = ScaffoldMessenger.of(context);
    final l = AppLocalizations.of(context);
    final title = specialReportName(l, report);

    // Every specialist report needs the full birth identity — reuse the shared
    // generate-details sheet (pre-filled from the profile, fully editable so a
    // report can be run for someone else). The API fires only on Generate.
    final subject = await showGenerateDetailsSheet(
      context,
      fields: const {
        InsightField.name,
        InsightField.gender,
        InsightField.dob,
        InsightField.time,
        InsightField.place,
      },
    );
    if (subject == null || !context.mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.saffron),
      ),
    );
    // The loading dialog goes on the ROOT navigator — dismiss it there (this
    // screen may sit under a nested navigator).
    void popLoading() => Navigator.of(context, rootNavigator: true).pop();

    Map<String, dynamic> res;
    try {
      res = await repo.generateReport(
        type: report.type,
        dob: subject.dob,
        time: subject.time,
        place: subject.place,
        name: subject.name,
        gender: subject.gender,
        lang: subject.language,
      );
    } on ApiException catch (e) {
      if (context.mounted) popLoading();
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      return;
    } catch (e, st) {
      debugPrint('[SpecialReports] ${report.type} failed: $e\n$st');
      if (context.mounted) popLoading();
      messenger.showSnackBar(SnackBar(content: Text(l.commonErrorGeneric)));
      return;
    }

    if (context.mounted) {
      popLoading();
      await showInsightResultSheet(
        context,
        kind: 'generic',
        title: title,
        response: res,
      );
    }
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({
    required this.title,
    required this.price,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String price;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(icon, tone: TileTone.gold, size: 40),
          const Spacer(),
          Text(title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(size: 14, weight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (price.isNotEmpty)
            StatusChip(price, tone: ChipTone.warn)
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
