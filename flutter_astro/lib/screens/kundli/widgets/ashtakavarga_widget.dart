import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '../../../utils/kundli_names.dart';
import '_section_loader.dart';
import '../../../l10n/gen/app_localizations.dart';

class AshtakavargaWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const AshtakavargaWidget({super.key, required this.chartId, this.initial});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliAshtakavarga(chartId),
      builder: (ctx, data) {
        final l = AppLocalizations.of(ctx)!;
        final sav = (data['sav'] as Map? ?? {}).cast<String, dynamic>();
        final savTotal = (data['sav_total'] as num?)?.toInt() ?? 337;
        final planetsBav = (data['planets_bav'] as Map? ?? {}).cast<String, dynamic>();
        final signs = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi'];

        return ListView(padding: const EdgeInsets.all(16), children: [
          KundliSectionCard(
            title: l.ashtakavargaSavTitle,
            icon: Icons.table_chart, color: AppColors.primary,
            subtitle: l.ashtakavargaSavSubtitle(savTotal.toString(), (savTotal / 12).toStringAsFixed(1)),
            child: Wrap(spacing: 8, runSpacing: 8, children: signs.map((s) {
              final v = (sav[s] as num?)?.toInt() ?? 0;
              return Container(
                width: 60, padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: _barColor(v, savTotal / 12), borderRadius: BorderRadius.circular(8)),
                child: Column(children: [
                  Text(s, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  Text('$v', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                ]),
              );
            }).toList()),
          ),
          ...planetsBav.entries.map((e) {
            final p = e.key;
            final d = (e.value as Map).cast<String, dynamic>();
            final bav = (d['bav_per_sign'] as Map? ?? {}).cast<String, dynamic>();
            final total = (d['total_rekha'] as num?)?.toInt() ?? 0;
            final natalScore = (d['natal_sign_score'] as num?)?.toInt() ?? 0;
            return KundliSectionCard(
              title: l.ashtakavargaPlanetBavTitle(KundliNames.planet(p, Localizations.localeOf(ctx))),
              subtitle: l.ashtakavargaPlanetBavSubtitle(total.toString(), natalScore.toString()),
              child: Wrap(spacing: 6, runSpacing: 6, children: signs.map((s) {
                final v = (bav[s] as num?)?.toInt() ?? 0;
                return Container(
                  width: 50, padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: _barColor(v, 4), borderRadius: BorderRadius.circular(6)),
                  child: Column(children: [
                    Text(s, style: const TextStyle(color: Colors.white, fontSize: 10)),
                    Text('$v', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                  ]),
                );
              }).toList()),
            );
          }),
        ]);
      },
    );
  }

  Color _barColor(int v, num avg) {
    if (v >= avg * 1.3) return AppColors.success;
    if (v >= avg) return Colors.green.shade700;
    if (v >= avg * 0.7) return Colors.amber.shade700;
    return AppColors.error;
  }
}
