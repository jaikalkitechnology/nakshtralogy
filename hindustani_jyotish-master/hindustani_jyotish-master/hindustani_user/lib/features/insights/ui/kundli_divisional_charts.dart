import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../l10n/app_localizations.dart';
import '../insight_models.dart';
import 'kundli_chart.dart';

/// Grid of the 20 classical divisional (varga) charts (D1..D60), each drawn
/// with the existing North-Indian [KundliChart] painter. Tapping a thumbnail
/// opens a large view of that varga.
class KundliDivisionalCharts extends StatelessWidget {
  const KundliDivisionalCharts({super.key, required this.chart});

  /// The `/chart` payload: `{planets: {...}, divisionals: {...}, ...}`.
  final Map<String, dynamic> chart;

  static const _labels = {
    'D1': 'Rashi', 'D2': 'Hora', 'D3': 'Drekkana', 'D4': 'Chaturthamsha',
    'D5': 'Panchamsha', 'D6': 'Shashthamsha', 'D7': 'Saptamsha', 'D8': 'Ashtamsha',
    'D9': 'Navamsha', 'D10': 'Dashamsha', 'D11': 'Rudramsha', 'D12': 'Dwadashamsha',
    'D16': 'Shodashamsha', 'D20': 'Vimshamsha', 'D24': 'Chaturvimshamsha',
    'D27': 'Bhamsha', 'D30': 'Trimshamsha', 'D40': 'Khavedamsha',
    'D45': 'Akshavedamsha', 'D60': 'Shashtiamsha',
  };

  Map<String, dynamic> get _divisionals =>
      (chart['divisionals'] as Map?)?.cast<String, dynamic>() ?? const {};
  Map<String, dynamic> get _planets =>
      (chart['planets'] as Map?)?.cast<String, dynamic>() ?? const {};

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    if (_divisionals.isEmpty) {
      return Center(
          child: Text(l.kunNoData,
              style: AppTextStyles.body(color: AppColors.ivoryFaint)));
    }
    return LayoutBuilder(builder: (context, constraints) {
      final cols = constraints.maxWidth >= 620 ? 3 : 2;
      final spacing = 12.0;
      final tileW = (constraints.maxWidth - 40 - spacing * (cols - 1)) / cols;
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          Text(l.divChartsSubtitle,
              style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
          const SizedBox(height: 14),
          Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final code in kDivisionalCodes)
                if (_divisionals.values.any((v) =>
                    v is Map && (v.cast<String, dynamic>())[code] != null))
                  SizedBox(
                    width: tileW,
                    child: _DivTile(
                      code: code,
                      name: divisionalDisplayName(code, _labels[code] ?? code, lang),
                      divisionals: _divisionals,
                      planets: _planets,
                    ),
                  ),
            ],
          ),
        ],
      );
    });
  }
}

class _DivTile extends StatelessWidget {
  const _DivTile({
    required this.code,
    required this.name,
    required this.divisionals,
    required this.planets,
  });

  final String code;
  final String name;
  final Map<String, dynamic> divisionals;
  final Map<String, dynamic> planets;

  @override
  Widget build(BuildContext context) {
    final parsed = divisionalPlanets(divisionals, planets, code);
    final lagnaIdx = parsed.lagnaIdx ?? 0;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openLarge(context, parsed.lagnaIdx, parsed.planets),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(code,
                  style: AppTextStyles.mono(
                      size: 12, weight: FontWeight.w700, color: AppColors.gold)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label(size: 11, color: AppColors.copperLight)),
              ),
            ]),
            const SizedBox(height: 8),
            KundliChart(lagnaSignIdx: lagnaIdx, planets: parsed.planets),
          ],
        ),
      ),
    );
  }

  void _openLarge(BuildContext context, int? lagnaIdx, List<InsightPlanet> planets) {
    final l = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.indigoDeep,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$code · $name', style: AppTextStyles.heading(size: 18)),
            const SizedBox(height: 4),
            Text(l.kundliRetroLegend,
                style: AppTextStyles.label(size: 11, color: AppColors.ivoryFaint)),
            const SizedBox(height: 16),
            KundliChart(lagnaSignIdx: lagnaIdx ?? 0, planets: planets),
          ],
        ),
      ),
    );
  }
}
