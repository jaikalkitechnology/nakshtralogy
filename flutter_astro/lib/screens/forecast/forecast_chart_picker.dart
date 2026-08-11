import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'daily_forecast_screen.dart';
import '../../widgets/desktop_center.dart';

class ForecastChartPicker extends StatefulWidget {
  const ForecastChartPicker({super.key});
  @override
  State<ForecastChartPicker> createState() => _S();
}

class _S extends State<ForecastChartPicker> {
  final _api = ApiService();
  List<Map<String, dynamic>> _charts = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await _api.getMyCharts(limit: 100);
      if (!mounted) return;
      setState(() { _charts = list.map((e) => (e as Map).cast<String, dynamic>()).toList(); _loading = false; });
    } catch (_) { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFF0A0A24),
      appBar: AppBar(backgroundColor: const Color(0xFF0A0A24),
        title: const Text.rich(TextSpan(children: [
          TextSpan(text: "Today's ", style: TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w600)),
          TextSpan(text: 'Forecast', style: TextStyle(color: AppColors.gold, fontSize: 18, fontStyle: FontStyle.italic)),
        ]))),
      body: DesktopCenter(
        maxWidth: 720,
        child: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _charts.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)?.noCharts ?? 'No charts', style: const TextStyle(color: AppColors.smoke)))
              : ListView.builder(padding: const EdgeInsets.all(12), itemCount: _charts.length,
                  itemBuilder: (ctx, i) {
                    final c = _charts[i];
                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => DailyForecastScreen(chartId: c['id']?.toString() ?? '', chartName: c['name']?.toString() ?? 'Chart'))),
                      child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.08), Colors.transparent]),
                          borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.gold.withOpacity(0.2))),
                        child: Row(children: [
                          Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                            child: const Center(child: Text('☀', style: TextStyle(fontSize: 18)))),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(c['name']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600)),
                            Text('${c['dob'] ?? ""} • ${c['place'] ?? ""}', style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
                          ])),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.smoke),
                        ])));
                  })),
    );
  }
}
