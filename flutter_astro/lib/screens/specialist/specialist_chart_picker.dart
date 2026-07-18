import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'specialist_report_screen.dart';
import 'career_report_screen.dart';
import '../../l10n/gen/app_localizations.dart';

class SpecialistChartPicker extends StatefulWidget {
  final String specialistKey, specialistLabel, specialistEmoji;
  const SpecialistChartPicker({super.key, required this.specialistKey,
    required this.specialistLabel, required this.specialistEmoji});

  @override
  State<SpecialistChartPicker> createState() => _SpecialistChartPickerState();
}

class _SpecialistChartPickerState extends State<SpecialistChartPicker> {
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
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(children: [
          Text(widget.specialistEmoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(widget.specialistLabel, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
        ]),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _charts.isEmpty
              ? Center(child: Text(l.noChartsCreateFirst, style: const TextStyle(color: AppColors.textSecondary)))
              : Column(children: [
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(14),
                    color: AppColors.primary.withOpacity(0.06),
                    child: Text(l.selectBirthChartToAnalyze, style: const TextStyle(color: AppColors.primary, fontSize: 13)),
                  ),
                  Expanded(child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _charts.length,
                    itemBuilder: (ctx, i) {
                      final c = _charts[i];
                      final id = c['id']?.toString() ?? '';
                      final name = c['name']?.toString() ?? l.unknownName;
                      final dob = c['dob']?.toString() ?? '';
                      final place = c['place']?.toString() ?? '';
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => widget.specialistKey == 'career'
                              ? CareerReportScreen(chartId: id, chartName: name)
                              : SpecialistReportScreen(
                                  specialistKey: widget.specialistKey,
                                  specialistLabel: widget.specialistLabel,
                                  specialistEmoji: widget.specialistEmoji,
                                  chartId: id,
                                  chartName: name,
                                ),
                        )),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border)),
                          child: Row(children: [
                            const CircleAvatar(radius: 18, backgroundColor: Colors.white12,
                              child: Icon(Icons.person, size: 18, color: AppColors.textSecondary)),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                              Text('$dob • $place', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                            ])),
                            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                          ]),
                        ),
                      );
                    },
                  )),
                ]),
    );
  }
}
