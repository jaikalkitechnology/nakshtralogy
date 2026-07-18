import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import 'north_indian_chart.dart';

/// Displays all 20 divisional charts from the new response shape:
///   divisionalsMap = { Sun: {D1:'Ar', D2:'Ta', ... D60:'Pi'}, Moon: {...}, ... }
/// Each row is tappable — opens the diamond chart for that division.
class DivisionalChartsWidget extends StatelessWidget {
  final String chartId;
  final Map<String, dynamic> divisionalsMap;

  const DivisionalChartsWidget({super.key, required this.chartId, required this.divisionalsMap});

  static const _charts = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, 20, 24, 27, 30, 40, 45, 60];

  static List<String> _metaFor(AppLocalizations l, int d) {
    switch (d) {
      case 1: return [l.divD1Name, l.divD1Desc];
      case 2: return [l.divD2Name, l.divD2Desc];
      case 3: return [l.divD3Name, l.divD3Desc];
      case 4: return [l.divD4Name, l.divD4Desc];
      case 5: return [l.divD5Name, l.divD5Desc];
      case 6: return [l.divD6Name, l.divD6Desc];
      case 7: return [l.divD7Name, l.divD7Desc];
      case 8: return [l.divD8Name, l.divD8Desc];
      case 9: return [l.divD9Name, l.divD9Desc];
      case 10: return [l.divD10Name, l.divD10Desc];
      case 11: return [l.divD11Name, l.divD11Desc];
      case 12: return [l.divD12Name, l.divD12Desc];
      case 16: return [l.divD16Name, l.divD16Desc];
      case 20: return [l.divD20Name, l.divD20Desc];
      case 24: return [l.divD24Name, l.divD24Desc];
      case 27: return [l.divD27Name, l.divD27Desc];
      case 30: return [l.divD30Name, l.divD30Desc];
      case 40: return [l.divD40Name, l.divD40Desc];
      case 45: return [l.divD45Name, l.divD45Desc];
      case 60: return [l.divD60Name, l.divD60Desc];
      default: return ['D-$d', ''];
    }
  }

  static const _planetOrder = ['Lagna','Sun','Moon','Mars','Mercury','Jupiter','Venus','Saturn','Rahu','Ketu'];
  static const _signShortList = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi'];

  int _signIdx(String sign) => _signShortList.indexOf(sign);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (divisionalsMap.isEmpty) {
      return Center(child: Text(l.noData, style: TextStyle(color: AppColors.textSecondary)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _charts.length,
      itemBuilder: (_, i) {
        final d = _charts[i];
        final meta = _metaFor(l, d);
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

    // Group planets by sign
    final byRashi = <int, List<Map<String, dynamic>>>{};
    signsByPlanet.forEach((planet, sign) {
      if (planet == 'Lagna') return;
      final si = _signIdx(sign);
      if (si < 0) return;
      byRashi.putIfAbsent(si, () => []).add({
        'planet': planet,
        'sign': sign,
        'degree': 0,
        'flags': const [],
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
              Text(AppLocalizations.of(context)!.planetPositions, style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
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
