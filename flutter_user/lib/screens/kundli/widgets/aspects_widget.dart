import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '_section_loader.dart';

class AspectsWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const AspectsWidget({super.key, required this.chartId, this.initial});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliAspects(chartId),
      builder: (ctx, data) {
        final graha = (data['graha_drishti'] as Map? ?? {}).cast<String, dynamic>();
        final rashi = (data['rashi_drishti'] as Map? ?? {}).cast<String, dynamic>();
        final lagnaAsp = (data['lagna_aspects_received'] as Map? ?? {}).cast<String, dynamic>();

        return ListView(padding: const EdgeInsets.all(16), children: [
          KundliSectionCard(
            title: 'Graha Drishti (Planet Aspects)',
            icon: Icons.hub, color: AppColors.primary,
            subtitle: 'Who aspects whom (%)',
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: graha.entries.map<Widget>((e) {
              final targets = (e.value as Map).cast<String, dynamic>();
              if (targets.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(e.key, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 4),
                  Wrap(spacing: 6, runSpacing: 4, children: targets.entries.map<Widget>((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4)),
                    child: Text('${t.key}: ${(t.value as num).toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                  )).toList()),
                ]),
              );
            }).toList()),
          ),
          if (lagnaAsp.isNotEmpty)
            KundliSectionCard(
              title: 'Lagna Aspects Received',
              icon: Icons.wb_twilight, color: AppColors.accent,
              child: Wrap(spacing: 6, runSpacing: 4, children: lagnaAsp.entries.map<Widget>((e) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                child: Text('${e.key}: ${(e.value as num).toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w600)),
              )).toList()),
            ),
          KundliSectionCard(
            title: 'Rashi Drishti (Sign Aspects)',
            icon: Icons.circle, color: AppColors.success,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: rashi.entries.map<Widget>((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(children: [
                SizedBox(width: 28, child: Text(e.key, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700))),
                const Icon(Icons.arrow_right_alt, color: AppColors.textSecondary, size: 14),
                Expanded(child: Text((e.value as List).join(', '), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))),
              ]),
            )).toList()),
          ),
        ]);
      },
    );
  }
}
