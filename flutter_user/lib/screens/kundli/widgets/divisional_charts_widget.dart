import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// Displays all 20 divisional charts from the new response shape:
///   divisionalsMap = { Sun: {D1:'Ar', D2:'Ta', ... D60:'Pi'}, Moon: {...}, ... }
class DivisionalChartsWidget extends StatelessWidget {
  final String chartId;
  final Map<String, dynamic> divisionalsMap;

  const DivisionalChartsWidget({super.key, required this.chartId, required this.divisionalsMap});

  static const _charts = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, 20, 24, 27, 30, 40, 45, 60];
  static const _meta = {
    1: ['Rasi (D-1)', 'Physical existence, all matters'],
    2: ['Hora (D-2)', 'Wealth, money'],
    3: ['Drekkana (D-3)', 'Siblings, courage'],
    4: ['Chaturthamsa (D-4)', 'Property, residence, fortune'],
    5: ['Panchamsa (D-5)', 'Fame, authority, power'],
    6: ['Shashthamsa (D-6)', 'Health troubles'],
    7: ['Saptamsa (D-7)', 'Children, grandchildren'],
    8: ['Ashtamsa (D-8)', 'Sudden troubles, litigation'],
    9: ['Navamsha (D-9)', 'Marriage, spouse, dharma'],
    10: ['Dasamsha (D-10)', 'Career, profession'],
    11: ['Rudramsha (D-11)', 'Death, destruction'],
    12: ['Dwadasamsha (D-12)', 'Parents, blood-relatives'],
    16: ['Shodasamsha (D-16)', 'Vehicles, comforts, pleasures'],
    20: ['Vimsamsha (D-20)', 'Spiritual matters, religious'],
    24: ['Chaturvimsamsha (D-24)', 'Learning, knowledge, education'],
    27: ['Nakshatramsha (D-27)', 'Strengths, weaknesses, nature'],
    30: ['Trimsamsha (D-30)', 'Evils, sub-conscious, punishment'],
    40: ['Khavedamsha (D-40)', 'Auspicious/inauspicious (maternal)'],
    45: ['Akshavedamsha (D-45)', 'All matters (paternal)'],
    60: ['Shashtyamsha (D-60)', 'Past-life karma — MOST IMPORTANT'],
  };

  static const _planetOrder = ['Lagna','Sun','Moon','Mars','Mercury','Jupiter','Venus','Saturn','Rahu','Ketu'];

  @override
  Widget build(BuildContext context) {
    if (divisionalsMap.isEmpty) {
      return const Center(child: Text('No divisional data', style: TextStyle(color: AppColors.textSecondary)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _charts.length,
      itemBuilder: (_, i) {
        final d = _charts[i];
        final meta = _meta[d] ?? ['D-$d', ''];
        final dKey = 'D$d';
        final signsByPlanet = <String, String>{};
        for (final p in _planetOrder) {
          final pm = divisionalsMap[p];
          if (pm is Map) {
            final s = pm[dKey];
            if (s != null) signsByPlanet[p] = s.toString();
          }
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Center(child: Text('D$d', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13))),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(meta[0], style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                Text(meta[1], style: const TextStyle(color: AppColors.textSecondary, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
            ]),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 4, children: signsByPlanet.entries.map<Widget>((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4)),
                child: Text('${e.key.substring(0, e.key.length > 3 ? 3 : e.key.length)}: ${e.value}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
              );
            }).toList()),
          ]),
        );
      },
    );
  }
}
