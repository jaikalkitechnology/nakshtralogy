import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'milan_viewer_screen.dart';

class MilanChartSelector extends StatefulWidget {
  const MilanChartSelector({super.key});

  @override
  State<MilanChartSelector> createState() => _MilanChartSelectorState();
}

class _MilanChartSelectorState extends State<MilanChartSelector> {
  final _api = ApiService();
  List<Map<String, dynamic>> _charts = [];
  bool _loading = true;
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await _api.getMyCharts(limit: 100);
      if (!mounted) return;
      setState(() {
        _charts = list.map((e) => (e as Map).cast<String, dynamic>()).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_selected.length < 2) {
        _selected.add(id);
      }
    });
  }

  void _proceed() {
    if (_selected.length != 2) return;
    final ids = _selected.toList();
    final c1 = _charts.firstWhere((c) => c['id'] == ids[0]);
    final c2 = _charts.firstWhere((c) => c['id'] == ids[1]);
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => MilanViewerScreen(
        chartId1: ids[0],
        chartId2: ids[1],
        name1: c1['name']?.toString() ?? 'Person 1',
        name2: c2['name']?.toString() ?? 'Person 2',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kundli Milan', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _charts.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)?.noCharts ?? 'No charts found.',
                  style: TextStyle(color: AppColors.textSecondary)))
              : Column(children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.1), Colors.transparent]),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(AppLocalizations.of(context)?.selectTwoCharts ?? 'Select 2 Charts for Matching',
                          style: TextStyle(color: AppColors.primary, fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('${_selected.length}/2 selected',
                          style: TextStyle(
                            color: _selected.length == 2 ? Colors.green : AppColors.textSecondary,
                            fontSize: 12,
                          )),
                    ]),
                  ),
                  Expanded(child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _charts.length,
                    itemBuilder: (ctx, i) {
                      final c = _charts[i];
                      final id = c['id']?.toString() ?? '';
                      final name = c['name']?.toString() ?? 'Unknown';
                      final dob = c['dob']?.toString() ?? '';
                      final place = c['place']?.toString() ?? '';
                      final gender = c['gender']?.toString() ?? '';
                      final isSelected = _selected.contains(id);
                      return GestureDetector(
                        onTap: () => _toggle(id),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.12) : AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: isSelected ? AppColors.primary : Colors.white12,
                              child: isSelected
                                  ? Icon(Icons.check, color: AppColors.background, size: 20)
                                  : Text(gender == 'M' ? '♂' : gender == 'F' ? '♀' : '?',
                                      style: const TextStyle(fontSize: 18)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(name, style: TextStyle(
                                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                fontSize: 14, fontWeight: FontWeight.w600,
                              )),
                              Text('$dob • $place',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                            ])),
                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _selected.toList().indexOf(id) == 0 ? 'Person 1' : 'Person 2',
                                  style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600),
                                ),
                              ),
                          ]),
                        ),
                      );
                    },
                  )),
                ]),
      bottomNavigationBar: _selected.length == 2
          ? SafeArea(child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _proceed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Start Kundli Milan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ))
          : null,
    );
  }
}
