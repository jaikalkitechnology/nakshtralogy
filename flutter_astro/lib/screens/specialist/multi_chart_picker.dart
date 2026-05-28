import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'multi_chart_report_screen.dart';
import 'child_probability_report_screen.dart';
import 'love_compatibility_report_screen.dart';
import 'karma_linkage_report_screen.dart';

class MultiChartPicker extends StatefulWidget {
  final String specialistKey;
  final String specialistLabel;
  final String specialistEmoji;
  final int maxCharts;

  const MultiChartPicker({
    super.key,
    required this.specialistKey,
    required this.specialistLabel,
    required this.specialistEmoji,
    this.maxCharts = 2,
  });

  @override
  State<MultiChartPicker> createState() => _MultiChartPickerState();
}

class _MultiChartPickerState extends State<MultiChartPicker> {
  final _api = ApiService();
  List<Map<String, dynamic>> _charts = [];
  bool _loading = true;
  bool _analyzing = false;
  final List<String> _selected = [];

  int get _minCharts => 2;

  Color get _accentColor {
    switch (widget.specialistKey) {
      case 'child_probability':
        return const Color(0xFFE8689C);
      case 'love_compatibility':
        return const Color(0xFFE85B8A);
      case 'karma_linkage':
        return AppColors.lavender;
      default:
        return AppColors.gold;
    }
  }

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
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_selected.length < widget.maxCharts) {
        _selected.add(id);
      }
    });
  }

  Future<void> _proceed() async {
    if (_selected.length < _minCharts) return;
    final ids = _selected.toList();

    // Collect participant names
    final participants = ids.map((id) {
      final c = _charts.firstWhere((c) => c['id'] == id, orElse: () => {'name': '?'});
      return c['name']?.toString() ?? '?';
    }).toList();

    setState(() => _analyzing = true);
    try {
      Map<String, dynamic> resp;
      if (widget.specialistKey == 'child_probability') {
        resp = await _api.runChildProbability(ids[0], ids[1]);
      } else if (widget.specialistKey == 'love_compatibility') {
        resp = await _api.runLoveCompatibility(ids[0], ids[1]);
      } else {
        resp = await _api.runKarmaLinkage(ids);
      }

      if (!mounted) return;
      setState(() => _analyzing = false);

      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        final reportData = (resp['data'] as Map).cast<String, dynamic>();
        final Widget screen;
        if (widget.specialistKey == 'child_probability') {
          screen = ChildProbabilityReportScreen(data: reportData, participants: participants);
        } else if (widget.specialistKey == 'love_compatibility') {
          screen = LoveCompatibilityReportScreen(data: reportData, participants: participants);
        } else if (widget.specialistKey == 'karma_linkage') {
          screen = KarmaLinkageReportScreen(data: reportData, participants: participants);
        } else {
          screen = MultiChartReportScreen(
            specialistKey: widget.specialistKey, specialistLabel: widget.specialistLabel,
            data: reportData, participants: participants);
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resp['detail']?.toString() ?? 'Analysis failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _analyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _accentColor;
    final isKarma = widget.specialistKey == 'karma_linkage';
    final selectionLabel = isKarma ? 'Select 2-${widget.maxCharts} Charts' : 'Select ${widget.maxCharts} Charts';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(children: [
          Text(widget.specialistEmoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.specialistLabel,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _analyzing
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    CircularProgressIndicator(color: color),
                    const SizedBox(height: 16),
                    Text(
                      'Running ${widget.specialistLabel} analysis...',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ]),
                )
              : Column(children: [
                  // Selection header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [color.withOpacity(0.1), Colors.transparent]),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            selectionLabel,
                            style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isKarma
                                ? 'Pick 2 to ${widget.maxCharts} charts to analyze karmic links'
                                : 'Pick a Male and Female chart',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                          ),
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _selected.length >= _minCharts
                              ? Colors.green.withOpacity(0.15)
                              : Colors.orange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${_selected.length}/${widget.maxCharts}',
                          style: TextStyle(
                            color: _selected.length >= _minCharts ? Colors.green : Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  // Chart list
                  Expanded(
                    child: ListView.builder(
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
                              color: isSelected ? color.withOpacity(0.12) : AppColors.card,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? color : AppColors.border,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: isSelected ? color : Colors.white12,
                                child: isSelected
                                    ? Text(
                                        '${selIdx + 1}',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                      )
                                    : Text(
                                        gender == 'M' ? '♂' : gender == 'F' ? '♀' : '?',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      color: isSelected ? color : AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '$dob  $place',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                                  ),
                                ]),
                              ),
                              if (isSelected && !isKarma)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    selIdx == 0 ? 'Person 1' : 'Person 2',
                                    style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              if (isSelected && isKarma)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '#${selIdx + 1}',
                                    style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
                                  ),
                                ),
                            ]),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
      bottomNavigationBar: _selected.length >= _minCharts
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _proceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Analyze ${_selected.length} Charts',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
