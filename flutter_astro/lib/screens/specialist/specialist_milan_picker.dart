import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'milan_report_screen.dart';

class SpecialistMilanPicker extends StatefulWidget {
  const SpecialistMilanPicker({super.key});

  @override
  State<SpecialistMilanPicker> createState() => _SpecialistMilanPickerState();
}

class _SpecialistMilanPickerState extends State<SpecialistMilanPicker> {
  final _api = ApiService();
  List<Map<String, dynamic>> _charts = [];
  bool _loading = true;
  bool _analyzing = false;
  final Set<String> _selected = {};

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

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) { _selected.remove(id); }
      else if (_selected.length < 2) { _selected.add(id); }
    });
  }

  Future<void> _proceed() async {
    if (_selected.length != 2) return;
    final ids = _selected.toList();
    final c1 = _charts.firstWhere((c) => c['id'] == ids[0]);
    final c2 = _charts.firstWhere((c) => c['id'] == ids[1]);
    final name1 = c1['name']?.toString() ?? 'Person 1';
    final name2 = c2['name']?.toString() ?? 'Person 2';

    setState(() => _analyzing = true);
    try {
      final resp = await _api.runSpecialistMilan(ids[0], ids[1]);
      if (!mounted) return;
      setState(() => _analyzing = false);
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => MilanReportScreen(
            name1: name1, name2: name2,
            data: (resp['data'] as Map).cast<String, dynamic>(),
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resp['detail']?.toString() ?? 'Analysis failed')));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _analyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Row(children: [
          Text('💑', style: TextStyle(fontSize: 20)),
          SizedBox(width: 8),
          Text('Kundli Milan Report', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
        ]),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _analyzing
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 16),
                  const Text('Running Milan analysis...', style: TextStyle(color: AppColors.textSecondary)),
                ]))
              : Column(children: [
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.pink.withOpacity(0.1), Colors.transparent]),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(AppLocalizations.of(context)?.selectChartsForMilan ?? 'Select 2 Charts',
                          style: TextStyle(color: Colors.pink, fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('${_selected.length}/2 selected',
                          style: TextStyle(color: _selected.length == 2 ? Colors.green : AppColors.textSecondary, fontSize: 12)),
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
                            color: isSelected ? Colors.pink.withOpacity(0.12) : AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? Colors.pink : AppColors.border, width: isSelected ? 2 : 1),
                          ),
                          child: Row(children: [
                            CircleAvatar(radius: 20,
                              backgroundColor: isSelected ? Colors.pink : Colors.white12,
                              child: isSelected
                                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                                  : Text(gender == 'M' ? '♂' : gender == 'F' ? '♀' : '?', style: const TextStyle(fontSize: 18))),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(name, style: TextStyle(color: isSelected ? Colors.pink : AppColors.textPrimary,
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                              Text('$dob • $place', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                            ])),
                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: Colors.pink.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                                child: Text(_selected.toList().indexOf(id) == 0 ? 'Person 1' : 'Person 2',
                                    style: const TextStyle(color: Colors.pink, fontSize: 10, fontWeight: FontWeight.w600)),
                              ),
                          ]),
                        ),
                      );
                    },
                  )),
                ]),
      bottomNavigationBar: _selected.length == 2
          ? SafeArea(child: Padding(padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _proceed,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Run Milan Analysis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              )))
          : null,
    );
  }
}
