import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'add_chart_screen.dart';

class MyChartsScreen extends StatefulWidget {
  const MyChartsScreen({super.key});

  @override
  State<MyChartsScreen> createState() => _MyChartsScreenState();
}

class _MyChartsScreenState extends State<MyChartsScreen> {
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

  Future<void> _deleteChart(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Delete Chart?', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text('This cannot be undone.', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ApiService().deleteChart(id);
      _loadCharts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _charts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('📜', style: TextStyle(fontSize: 56)),
                      const SizedBox(height: 16),
                      const Text('No birth charts yet', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Create your first Janam Kundli', style: TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final created = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddChartScreen()));
                          if (created == true) _loadCharts();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Create Chart'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadCharts,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _charts.length,
                    itemBuilder: (context, i) {
                      final c = _charts[i];
                      final isPrimary = c['is_primary'] == true;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isPrimary ? AppColors.primary.withOpacity(0.5) : AppColors.border),
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
                              child: Center(
                                child: Text(
                                  c['gender'] == 'M' ? '🧑' : c['gender'] == 'F' ? '👩' : '🧑',
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(c['name'] ?? '', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                                      if (isPrimary) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text('PRIMARY', style: TextStyle(color: AppColors.primary, fontSize: 9, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${c['dob']} ${c['tob']} • ${c['place']}',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                              onPressed: () => _deleteChart(c['id']),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: _charts.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                final created = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddChartScreen()));
                if (created == true) _loadCharts();
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.black),
            )
          : null,
    );
  }
}
