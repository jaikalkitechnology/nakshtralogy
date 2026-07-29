import 'package:flutter/material.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/kundli_names.dart';
import 'north_indian_chart.dart';

/// Displays all 20 divisional charts from the new response shape:
///   divisionalsMap = { Sun: {D1:'Ar', D2:'Ta', ... D60:'Pi'}, Moon: {...}, ... }
/// Each row is tappable — opens the diamond chart for that division.
///
/// [planetsMap] is the D1 planet data ({Sun:{longitude,vakri,combust,...}}) used
/// to derive each planet's degree-in-varga and intrinsic position flags
/// (retrograde / combust / vargottam) so the opened chart is not blank.
class DivisionalChartsWidget extends StatelessWidget {
  final String chartId;
  final Map<String, dynamic> divisionalsMap;
  final Map<String, dynamic> planetsMap;

  const DivisionalChartsWidget({
    super.key,
    required this.chartId,
    required this.divisionalsMap,
    this.planetsMap = const {},
  });

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
  static const _signShortList = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi'];

  int _signIdx(String sign) => _signShortList.indexOf(sign);

  @override
  Widget build(BuildContext context) {
    if (divisionalsMap.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)?.noData ?? 'No data', style: TextStyle(color: AppColors.textSecondary)));
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

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: signsByPlanet.isEmpty ? null : () => _openChart(context, d, meta[0], meta[1], signsByPlanet),
          child: Container(
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
                const Icon(Icons.chevron_right, color: AppColors.primary, size: 20),
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
          ),
        );
      },
    );
  }

  void _openChart(BuildContext context, int d, String name, String purpose, Map<String, String> signsByPlanet) {
    // Build houses list for the North Indian chart based on this division's signs.
    // Lagna sign becomes the reference — house 1 = lagna sign.
    final lagnaSignIdx = _signIdx(signsByPlanet['Lagna'] ?? 'Ar');
    final base = lagnaSignIdx < 0 ? 0 : lagnaSignIdx;

    final loc = Localizations.localeOf(context);
    // Group planets by sign. Degree-in-varga is derived from the D1 sidereal
    // longitude: each 30° sign splits into `d` equal parts, so the position
    // within the varga sign = ((lonInSign) * d) % 30. Retrograde / combust /
    // vargottam are intrinsic planet states carried over from D1.
    final byRashi = <int, List<Map<String, dynamic>>>{};
    signsByPlanet.forEach((planet, sign) {
      if (planet == 'Lagna') return;
      final si = _signIdx(sign);
      if (si < 0) return;
      final p = (planetsMap[planet] as Map?)?.cast<String, dynamic>();
      num? vargaDeg;
      final flags = <String>[];
      if (p != null) {
        final lon = (p['longitude'] as num?)?.toDouble();
        if (lon != null) vargaDeg = ((lon % 30) * d) % 30;
        if (p['vakri'] == true) flags.add('R');
        if (p['combust'] == true) flags.add('C');
        if (p['vargottam'] == true) flags.add('V');
      }
      byRashi.putIfAbsent(si, () => []).add({
        'planet': KundliNames.planet(planet, loc),
        'sign': sign,
        if (vargaDeg != null) 'degree': vargaDeg,
        'flags': flags,
      });
    });

    final houses = List.generate(12, (h) {
      final ri = (base + h) % 12;
      return {
        'house': h + 1,
        'rashi_idx': ri,
        'rashi_short': _signShortList[ri],
        'rashi': _signShortList[ri],
        'planets': byRashi[ri] ?? [],
        'is_lagna': h == 0,
      };
    });

    Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
          Text(purpose, style: const TextStyle(color: AppColors.primary, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          NorthIndianChartWidget(houses: houses, chartTitle: 'D-$d'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppLocalizations.of(context)?.planetPositions ?? 'Planet Placements', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...signsByPlanet.entries.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(children: [
                  SizedBox(width: 80, child: Text(e.key, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
                  Text(e.value, style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                ]),
              )),
            ]),
          ),
        ]),
      ),
    )));
  }
}
