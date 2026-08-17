import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/premium_ui.dart';
import '../../../shared/responsive.dart';
import '../insights_repository.dart';
import 'insight_preflight.dart';
import 'insight_result_sheet.dart';

/// Service key → price string from `GET /cosmic-services` (admin-configured;
/// disabled services are absent).
typedef _ServicesCubit = DataCubit<Map<String, String>>;

/// The Cosmic Insights grid (6 paid tiles) + "My Reports". Tapping a tile
/// first completes any missing birth identity via the pre-flight sheet (saved
/// back to the profile), then runs the insight and shows the curated result;
/// the wallet is debited server-side. Prices come from `GET /cosmic-services`;
/// the values below are only the fallback shown while loading or if the fetch
/// fails (so the screen never blanks).
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  static const _tiles = [
    ('₹29', Icons.wb_sunny_outlined, 'daily'),
    ('₹99', Icons.grid_4x4, 'kundli'),
    ('₹79', Icons.public, 'planet'),
    ('₹19', Icons.favorite_border, 'love'),
    ('₹19', Icons.cake_outlined, 'number'),
    ('₹29', Icons.auto_graph, 'prediction'),
  ];

  /// Tile kind → backend service key. Tiles whose key is missing from the
  /// server response are admin-disabled and hidden.
  static const _serviceKeys = {
    'daily': 'daily_horoscope',
    'kundli': 'detailed_kundli',
    'planet': 'planet_position',
    'love': 'love_compatibility',
    'number': 'birthday_number',
    'prediction': 'daily_prediction',
  };

  static String _tileTitle(AppLocalizations l, String kind) => switch (kind) {
        'daily' => l.insightDailyHoroscope,
        'kundli' => l.insightDetailedKundli,
        'planet' => l.insightPlanetPosition,
        'love' => l.insightLoveCompatibility,
        'number' => l.insightBirthdayNumber,
        _ => l.insightDailyPrediction,
      };

  /// "99.00" → "₹99"; "149.50" → "₹149.50" (matches the hardcoded style).
  static String _rupees(String price) =>
      '₹${price.endsWith('.00') ? price.substring(0, price.length - 3) : price}';

  /// Price chip label: a 0 (admin-set) price reads "Free", any other price as
  /// "₹N". `raw` is the admin price string (null while the catalog loads → use
  /// `fallback`, which is already a display string like "₹99").
  static String _priceLabel(AppLocalizations l, String? raw,
      {required String fallback}) {
    if (raw == null) return fallback;
    final v = double.tryParse(raw);
    if (v == null) return raw;
    return v == 0 ? l.insightFree : _rupees(raw);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BlocProvider<_ServicesCubit>(
      create: (_) =>
          DataCubit(() => getIt<InsightsRepository>().cosmicServices())..load(),
      child: SafeArea(
        // Builder: RefreshIndicator's onRefresh needs a context BELOW the
        // BlocProvider above to reach the cubit.
        child: CenteredMaxWidth(
          maxWidth: Responsive.readableMaxWidth,
          child: Builder(
          builder: (context) => RefreshIndicator(
            color: AppColors.saffron,
            // refresh() (not load()) keeps the current prices on screen while
            // re-fetching instead of dropping back to the fallback grid.
            onRefresh: () => context.read<_ServicesCubit>().refresh(),
            child: ListView(
              // The content is shorter than the viewport on most phones;
              // without this the list can't over-scroll, so pull-to-refresh
              // would never trigger.
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                HeroGradientCard(
                  child: Row(
                    children: [
                      const IconTile(Icons.auto_awesome,
                          tone: TileTone.saffron, size: 56),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(l.insightsSubtitle,
                            style: AppTextStyles.heading(
                                size: 18, color: AppColors.ivory)),
                      ),
                    ],
                  ),
                ),
                SectionLabel(l.insightsTitle),
                BlocBuilder<_ServicesCubit, DataState<Map<String, String>>>(
                  builder: (context, state) {
                    // null while loading / after a failed fetch → show every
                    // tile with its fallback price rather than blanking the
                    // grid.
                    final services = state.dataOrNull;
                    // Keep the tile HEIGHT roughly constant regardless of
                    // width: a fixed 1.4 ratio bottom-overflowed the tiles on
                    // slim (~320px) screens where each tile gets very narrow.
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final tileWidth = (constraints.maxWidth - 12) / 2;
                        return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: tileWidth / 140,
                          children: [
                            for (final t in _tiles)
                              if (services == null ||
                                  services.containsKey(_serviceKeys[t.$3]))
                                _InsightTile(
                                  title: _tileTitle(l, t.$3),
                                  // Any service priced 0 by the admin shows
                                  // "Free" instead of "₹0" — Detailed Kundli is
                                  // free by default (sourced from the
                                  // Nakshatralogy developer API at no user cost),
                                  // but this now follows the admin price so a
                                  // non-zero price would display correctly too.
                                  price: _priceLabel(
                                    l,
                                    services == null
                                        ? (t.$3 == 'kundli' ? '0' : null)
                                        : services[_serviceKeys[t.$3]],
                                    fallback: t.$1,
                                  ),
                                  icon: t.$2,
                                  onTap: () =>
                                      _run(context, t.$3, _tileTitle(l, t.$3)),
                                ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                _MyReportsCard(
                  icon: Icons.folder_open_outlined,
                  title: l.insightsMyReports,
                  subtitle: l.insightsMyReportsSubtitle,
                  onTap: () => context.push('/insights/reports'),
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }

  /// Birth-identity fields each insight needs. The chart-derived services need
  /// the full set; the birthday number only needs who + when born.
  static Set<InsightField> _requiredFields(String kind) => kind == 'number'
      ? const {InsightField.name, InsightField.gender, InsightField.dob}
      : const {
          InsightField.name,
          InsightField.gender,
          InsightField.dob,
          InsightField.time,
          InsightField.place,
        };

  Future<void> _run(BuildContext context, String kind, String title) async {
    final repo = getIt<InsightsRepository>();
    final messenger = ScaffoldMessenger.of(context);
    final l = AppLocalizations.of(context);

    // Every generation starts with the details sheet: all the fields this
    // service needs, PRE-FILLED from the profile but fully editable (a
    // report can be generated for someone else). The API fires only on the
    // explicit Generate tap below — dismissing the sheet makes no call.
    final subject = await showGenerateDetailsSheet(
      context, fields: _requiredFields(kind),
    );
    if (subject == null || !context.mounted) return;

    final dob = subject.dob;
    final time = subject.time;

    // Love match additionally needs the partner's details (not persisted).
    PartnerDetails? partner;
    if (kind == 'love') {
      partner = await showPartnerDetailsSheet(context);
      if (partner == null || !context.mounted) return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: AppColors.saffron)),
    );
    // showDialog pushes onto the ROOT navigator (its useRootNavigator
    // defaults to true), but this screen lives inside a StatefulShellBranch
    // with its own NESTED navigator — so the dialog must be dismissed with
    // rootNavigator: true. A bare Navigator.of(context).pop() resolves to
    // the branch navigator instead: it popped the InsightsScreen page
    // itself (black hole under the shell) while the dialog's dark barrier
    // stayed up forever on the root — the reported "black screen" after
    // every generation. Covered by test/insights_flow_test.dart, which
    // rebuilds the nested-navigator structure.
    void popLoadingDialog() =>
        Navigator.of(context, rootNavigator: true).pop();

    // This try/catch wraps ONLY the network call — nothing that runs after
    // the loading dialog is popped (e.g. showInsightResultSheet) is inside
    // it, so a second, wrong Navigator.pop() can never fire from here.
    Map<String, dynamic> res;
    try {
      switch (kind) {
        case 'daily':
          res = await repo.dailyHoroscope(
              dob: dob,
              time: time,
              place: subject.place,
              name: subject.name,
              gender: subject.gender);
        case 'prediction':
          res = await repo.dailyHoroscope(
              dob: dob,
              time: time,
              place: subject.place,
              name: subject.name,
              gender: subject.gender,
              prediction: true);
        case 'love':
          res = await repo.compatibility(
            person1: subject.toJson(),
            person2: partner!.toJson(),
          );
        case 'number':
          res = await repo.birthdayNumber(
              dob: dob, name: subject.name, gender: subject.gender);
        case 'planet':
          res = await repo.planetPosition(
              dob: dob,
              time: time,
              place: subject.place,
              name: subject.name,
              gender: subject.gender);
        default:
          res = await repo.generateKundli(
              dob: dob,
              time: time,
              place: subject.place,
              name: subject.name,
              gender: subject.gender);
      }
    } on ApiException catch (e) {
      if (context.mounted) popLoadingDialog();
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      return;
    } catch (e, st) {
      // Catch-all: anything besides ApiException (a bad cast, a parsing
      // error, an unwrapped network error, …) must still close the loading
      // dialog — otherwise the barrier is stuck forever ("black screen").
      debugPrint('[Insights] $kind generation failed: $e\n$st');
      if (context.mounted) popLoadingDialog();
      messenger.showSnackBar(SnackBar(content: Text(l.commonErrorGeneric)));
      return;
    }

    // Cheap shape log to help diagnose "wrong shape" issues without ever
    // printing the (potentially large) payload itself.
    debugPrint('[Insights] $kind response keys: ${res.keys.toList()}');
    if (context.mounted) {
      popLoadingDialog();
      await showInsightResultSheet(context,
          kind: kind, title: title, response: res);
    }
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile(
      {required this.title, required this.price, required this.icon, required this.onTap});
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
          IconTile(icon, tone: TileTone.gold, size: 38),
          const Spacer(),
          Text(title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(size: 14, weight: FontWeight.w700)),
          const SizedBox(height: 8),
          StatusChip(price, tone: ChipTone.warn),
        ],
      ),
    );
  }
}

class _MyReportsCard extends StatelessWidget {
  const _MyReportsCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      child: Row(
        children: [
          IconTile(icon, tone: TileTone.saffron, size: 46),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.body(size: 15, weight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style:
                        AppTextStyles.body(size: 12.5, color: AppColors.ivoryDim)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.chevron_right, color: AppColors.ivoryFaint),
        ],
      ),
    );
  }
}
