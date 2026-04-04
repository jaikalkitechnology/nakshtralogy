import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/chart/chart_bloc.dart';
import '../../bloc/chart/chart_event.dart';
import '../../bloc/chart/chart_state.dart';
import 'add_chart_screen.dart';

class MyChartsScreen extends StatelessWidget {
  const MyChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // load on first build
    final bloc = context.read<ChartBloc>();
    if (bloc.state is ChartInitial) {
      bloc.add(ChartLoadRequested());
    }

    return BlocConsumer<ChartBloc, ChartState>(
      listener: (context, state) {
        if (state is ChartCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Birth chart created!'), backgroundColor: AppColors.success),
          );
        } else if (state is ChartFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      builder: (context, state) {
        if (state is ChartLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final charts = state is ChartLoaded ? state.charts : <dynamic>[];

        if (charts.isEmpty) {
          return Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('\U0001f4dc', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 16),
              const Text('No birth charts yet', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
              const SizedBox(height: 4),
              Text('Create your first Janam Kundli', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddChartScreen())),
                icon: const Icon(Icons.add),
                label: const Text('Create Chart'),
              ),
            ]),
          );
        }

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async => context.read<ChartBloc>().add(ChartLoadRequested()),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: charts.length,
              itemBuilder: (context, i) {
                final c = charts[i];
                final isPrimary = c['is_primary'] == true;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card, borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isPrimary ? AppColors.primary.withOpacity(0.5) : AppColors.border),
                  ),
                  child: Row(children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text(c['gender'] == 'F' ? '\U0001f469' : '\U0001f9d1', style: const TextStyle(fontSize: 24))),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text(c['name'] ?? '', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                          if (isPrimary) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                              child: const Text('PRIMARY', style: TextStyle(color: AppColors.primary, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ]),
                        const SizedBox(height: 4),
                        Text('${c['dob']} ${c['tob']} \u2022 ${c['place']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis),
                      ]),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: AppColors.card,
                            title: const Text('Delete Chart?', style: TextStyle(color: AppColors.textPrimary)),
                            content: const Text('This cannot be undone.', style: TextStyle(color: AppColors.textSecondary)),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  context.read<ChartBloc>().add(ChartDeleteRequested(chartId: c['id']));
                                },
                                child: const Text('Delete', style: TextStyle(color: AppColors.error)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ]),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddChartScreen())),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: Colors.black),
          ),
        );
      },
    );
  }
}
