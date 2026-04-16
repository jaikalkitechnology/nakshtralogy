import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'rashi_detail_screen.dart';

/// Rashi explorer for astrologers: grid of all 12 signs with today's
/// gochar score + grade, tappable to open the rashi detail screen.
class RashiListScreen extends StatefulWidget {
  const RashiListScreen({super.key});

  @override
  State<RashiListScreen> createState() => _RashiListScreenState();
}

class _RashiListScreenState extends State<RashiListScreen> {
  final _api = ApiService();
  List<Map<String, dynamic>> _rashis = const [];
  String? _date;
  String? _best;
  String? _worst;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = await _api.getRashiToday();
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        final data = (resp['data'] as Map).cast<String, dynamic>();
        setState(() {
          _date = data['date']?.toString();
          _best = data['best']?.toString();
          _worst = data['worst']?.toString();
          _rashis = ((data['rashis'] as List?) ?? []).map((e) => (e as Map).cast<String, dynamic>()).toList();
          _loading = false;
        });
      } else {
        setState(() { _error = resp['detail']?.toString() ?? 'Failed'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Color _scoreColor(num? s) {
    final v = (s ?? 0).toDouble();
    if (v >= 2.5) return AppColors.success;
    if (v >= 0.5) return Colors.lightGreen;
    if (v >= -1.5) return Colors.amber;
    if (v >= -3.5) return Colors.orange;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rashi Predictions',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? _errView()
              : Column(children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    color: AppColors.primary.withOpacity(0.08),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Gochar for ${_date ?? 'today'}',
                          style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('Best: ${_best ?? '-'}    Worst: ${_worst ?? '-'}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ]),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.25,
                      ),
                      itemCount: _rashis.length,
                      itemBuilder: (_, i) {
                        final z = _rashis[i];
                        final idx = (z['idx'] as num?)?.toInt() ?? i;
                        final score = (z['score'] as num?)?.toDouble();
                        final grade = z['grade']?.toString();
                        final color = _scoreColor(score);
                        return GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (_) => RashiDetailScreen(
                              rashiIdx: idx,
                              initialName: z['name']?.toString(),
                            ),
                          )),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: score != null ? color.withOpacity(0.5) : AppColors.border),
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                Text(z['emoji']?.toString() ?? '', style: const TextStyle(fontSize: 26)),
                                const Spacer(),
                                if (score != null) Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                                  child: Text(score.toStringAsFixed(1),
                                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
                                ),
                              ]),
                              const SizedBox(height: 6),
                              Text(z['name']?.toString() ?? '',
                                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                              Text('${z['sanskrit'] ?? ''} • ${z['lord'] ?? ''}',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              const Spacer(),
                              if (grade != null) Text(grade,
                                  style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                            ]),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
    );
  }

  Widget _errView() => Center(child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, color: AppColors.error, size: 40),
      const SizedBox(height: 12),
      Text(_error!, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
      const SizedBox(height: 12),
      ElevatedButton(onPressed: _load, child: const Text('Retry')),
    ]),
  ));
}
