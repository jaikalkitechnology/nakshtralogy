import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '_section_loader.dart';

class DashaActivationWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const DashaActivationWidget({super.key, required this.chartId, this.initial});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliDashaActivation(chartId),
      builder: (ctx, data) {
        final md = data['current_md']?.toString() ?? data['md']?.toString() ?? '-';
        final ad = data['current_ad']?.toString() ?? data['ad']?.toString() ?? '-';
        final activeYogas = (data['active_yogas'] as List? ?? data['triggered_yogas'] as List? ?? []);
        final activeDoshas = (data['active_doshas'] as List? ?? data['triggered_doshas'] as List? ?? []);
        final queryDate = data['query_date']?.toString() ?? data['date']?.toString() ?? 'Today';

        return ListView(padding: const EdgeInsets.all(16), children: [
          // Current dasha header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.2), AppColors.accent.withOpacity(0.1)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withOpacity(0.4)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.flash_on, color: AppColors.primary, size: 22),
                SizedBox(width: 10),
                Text(AppLocalizations.of(context)?.dashaActive ?? 'Current Dasha Period', style: TextStyle(color: AppColors.primary, fontSize: 15, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                _chip('MD', md, AppColors.primary),
                const SizedBox(width: 8),
                _chip('AD', ad, AppColors.accent),
              ]),
              const SizedBox(height: 6),
              Text('As of: $queryDate', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ]),
          ),
          const SizedBox(height: 12),
          KundliSectionCard(
            title: 'Active Yogas in Current Period (${activeYogas.length})',
            icon: Icons.auto_awesome, color: AppColors.success,
            child: activeYogas.isEmpty
                ? Text(AppLocalizations.of(context)?.noYogasActive ?? 'No yogas triggered', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))
                : Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: activeYogas.map<Widget>((y) => Padding(padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• ${y is Map ? (y['name'] ?? y.toString()) : y}', style: const TextStyle(color: AppColors.success, fontSize: 12)))).toList()),
          ),
          KundliSectionCard(
            title: 'Active Doshas in Current Period (${activeDoshas.length})',
            icon: Icons.warning, color: AppColors.error,
            child: activeDoshas.isEmpty
                ? Text(AppLocalizations.of(context)?.noData ?? 'No doshas triggered', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))
                : Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: activeDoshas.map<Widget>((d) => Padding(padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• ${d is Map ? (d['name'] ?? d.toString()) : d}', style: const TextStyle(color: AppColors.error, fontSize: 12)))).toList()),
          ),
        ]);
      },
    );
  }

  Widget _chip(String label, String value, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(color: c.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: c.withOpacity(0.5))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text('$label: ', style: TextStyle(color: c, fontSize: 11)),
      Text(value, style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w700)),
    ]),
  );
}
