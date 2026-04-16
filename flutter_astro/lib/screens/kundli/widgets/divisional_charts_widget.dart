import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import 'kundli_grid_widget.dart';

/// Shows all 20 divisional charts (D-1 to D-60) as a scrollable list.
/// Tap a card to open that chart's kundli grid in detail.
class DivisionalChartsWidget extends StatelessWidget {
  final String chartId;
  final List<dynamic> divisionals;

  const DivisionalChartsWidget({super.key, required this.chartId, required this.divisionals});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: divisionals.length,
      itemBuilder: (_, i) {
        final d = divisionals[i] as Map;
        final division = (d['division'] as num?)?.toInt() ?? 1;
        final planets = (d['planets'] as Map?) ?? {};

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => _DivisionalDetailScreen(chartId: chartId, division: division, fullName: d['full_name']?.toString() ?? 'D-$division'),
            )),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                    child: Center(child: Text('D${division}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13))),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(d['full_name']?.toString() ?? '', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                    Text(d['purpose']?.toString() ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ])),
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ]),
                const SizedBox(height: 8),
                Wrap(spacing: 6, runSpacing: 4, children: planets.entries.map<Widget>((e) {
                  final planet = e.key.toString();
                  final sign = e.value as Map? ?? {};
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4)),
                    child: Text('${planet.substring(0, planet.length > 2 ? 3 : planet.length)}: ${sign['rashi_short']}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                  );
                }).toList()),
              ]),
            ),
          ),
        );
      },
    );
  }
}


class _DivisionalDetailScreen extends StatefulWidget {
  final String chartId;
  final int division;
  final String fullName;

  const _DivisionalDetailScreen({required this.chartId, required this.division, required this.fullName});

  @override
  State<_DivisionalDetailScreen> createState() => _DivisionalDetailScreenState();
}

class _DivisionalDetailScreenState extends State<_DivisionalDetailScreen> {
  Map<String, dynamic>? _grid;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final resp = await ApiService().getKundliDivision(widget.chartId, widget.division);
    if (resp['statusCode'] == 200) {
      setState(() { _grid = Map<String, dynamic>.from(resp)..remove('statusCode'); _loading = false; });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(widget.fullName)),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _grid == null
              ? const Center(child: Text('Failed to load', style: TextStyle(color: AppColors.error)))
              : ListView(padding: const EdgeInsets.all(16), children: [
                  Text(_grid!['purpose']?.toString() ?? '',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text('Lagna: ${_grid!['base_rashi']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  KundliGridWidget(houses: (_grid!['houses'] as List?) ?? []),
                ]),
    );
  }
}
