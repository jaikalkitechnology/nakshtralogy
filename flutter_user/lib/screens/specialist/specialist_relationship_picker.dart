import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'relationship_report_screen.dart';

class SpecialistRelationshipPicker extends StatefulWidget {
  const SpecialistRelationshipPicker({super.key});

  @override
  State<SpecialistRelationshipPicker> createState() => _State();
}

class _State extends State<SpecialistRelationshipPicker> {
  final _api = ApiService();
  List<Map<String, dynamic>> _charts = [];
  bool _loading = true;
  bool _analyzing = false;
  final List<String> _selected = [];
  String _context = 'general';

  static const _contexts = [
    {'key': 'general',    'label': 'General',     'icon': Icons.groups},
    {'key': 'love',       'label': 'Love',        'icon': Icons.favorite},
    {'key': 'business',   'label': 'Business',    'icon': Icons.business},
    {'key': 'family',     'label': 'Family',      'icon': Icons.family_restroom},
    {'key': 'team',       'label': 'Team',        'icon': Icons.group_work},
    {'key': 'friendship', 'label': 'Friendship',  'icon': Icons.handshake},
  ];

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
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_selected.length < 5) {
        _selected.add(id);
      }
    });
  }

  Future<void> _proceed() async {
    if (_selected.length < 2) return;
    setState(() => _analyzing = true);
    try {
      final resp = await _api.runRelationshipAnalysis(_selected, context: _context);
      if (!mounted) return;
      setState(() => _analyzing = false);
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        final names = _selected.map((id) {
          final c = _charts.firstWhere((c) => c['id'] == id, orElse: () => {'name': '?'});
          return c['name']?.toString() ?? '?';
        }).join(' & ');
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => RelationshipReportScreen(
            names: names,
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
          Text('🔗', style: TextStyle(fontSize: 20)),
          SizedBox(width: 8),
          Text('Relationship Intelligence', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
        ]),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _analyzing
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text('Analyzing ${_selected.length} charts...', style: const TextStyle(color: AppColors.textSecondary)),
                ]))
              : Column(children: [
                  // Context selector
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Relationship Context', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      const SizedBox(height: 6),
                      SizedBox(height: 34, child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _contexts.map((c) {
                          final sel = _context == c['key'];
                          return Padding(padding: const EdgeInsets.only(right: 6), child: GestureDetector(
                            onTap: () => setState(() => _context = c['key'] as String),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: sel ? AppColors.primary.withOpacity(0.15) : Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: sel ? AppColors.primary : Colors.white12),
                              ),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(c['icon'] as IconData, size: 14, color: sel ? AppColors.primary : AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(c['label'] as String, style: TextStyle(
                                  color: sel ? AppColors.primary : AppColors.textSecondary, fontSize: 11, fontWeight: sel ? FontWeight.w600 : FontWeight.normal)),
                              ]),
                            ),
                          ));
                        }).toList(),
                      )),
                    ]),
                  ),
                  // Selection header
                  Container(
                    width: double.infinity, padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.purple.withOpacity(0.1), Colors.transparent])),
                    child: Row(children: [
                      Expanded(child: Text('Select 2–5 Charts',
                          style: TextStyle(color: Colors.purple, fontSize: 14, fontWeight: FontWeight.w700))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _selected.length >= 2 ? Colors.green.withOpacity(0.15) : Colors.orange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6)),
                        child: Text('${_selected.length}/5',
                            style: TextStyle(color: _selected.length >= 2 ? Colors.green : Colors.orange, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ),
                  // Chart list
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
                      final selIdx = _selected.indexOf(id);
                      return GestureDetector(
                        onTap: () => _toggle(id),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.purple.withOpacity(0.12) : AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? Colors.purple : AppColors.border, width: isSelected ? 2 : 1)),
                          child: Row(children: [
                            CircleAvatar(radius: 20,
                              backgroundColor: isSelected ? Colors.purple : Colors.white12,
                              child: isSelected
                                  ? Text('${selIdx + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))
                                  : Text(gender == 'M' ? '♂' : gender == 'F' ? '♀' : '?', style: const TextStyle(fontSize: 18))),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(name, style: TextStyle(color: isSelected ? Colors.purple : AppColors.textPrimary,
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                              Text('$dob • $place', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                            ])),
                          ]),
                        ),
                      );
                    },
                  )),
                ]),
      bottomNavigationBar: _selected.length >= 2
          ? SafeArea(child: Padding(padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _proceed,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text('Analyze ${_selected.length} Charts', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              )))
          : null,
    );
  }
}
