import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'add_client_chart_screen.dart';

class ClientChartsScreen extends StatefulWidget {
  const ClientChartsScreen({super.key});

  @override
  State<ClientChartsScreen> createState() => _ClientChartsScreenState();
}

class _ClientChartsScreenState extends State<ClientChartsScreen> {
  List<dynamic> _charts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCharts();
  }

  Future<void> _loadCharts() async {
    setState(() => _loading = true);
    final charts = await ApiService().getMyCharts();
    setState(() {
      _charts = charts;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Client Charts', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 20)),
              ElevatedButton.icon(
                onPressed: () async {
                  final created = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddClientChartScreen()));
                  if (created == true) _loadCharts();
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Chart'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40)),
              ),
            ],
          ),
        ),

        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : _charts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('📜', style: TextStyle(fontSize: 56)),
                          const SizedBox(height: 16),
                          const Text('No charts created yet', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text('Create a chart for your client', style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadCharts,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _charts.length,
                        itemBuilder: (context, i) {
                          final c = _charts[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(child: Text('📜', style: TextStyle(fontSize: 22))),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(c['name'] ?? '', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${c['dob']} ${c['tob']} \u2022 ${c['place']}',
                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                // action buttons
                                IconButton(
                                  icon: const Icon(Icons.timeline, color: AppColors.primary, size: 20),
                                  tooltip: 'Dasha',
                                  onPressed: () async {
                                    final result = await ApiService().computeDasha(c['id']);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(result['statusCode'] == 200 ? 'Dasha computed' : 'Error')),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                  onPressed: () async {
                                    await ApiService().deleteChart(c['id']);
                                    _loadCharts();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}
