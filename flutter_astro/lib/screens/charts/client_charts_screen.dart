import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/chart/chart_bloc.dart';
import '../../bloc/chart/chart_event.dart';
import '../../bloc/chart/chart_state.dart';
import '../../services/api_service.dart';
import 'add_client_chart_screen.dart';
import '../kundli/kundli_viewer_screen.dart';

class ClientChartsScreen extends StatelessWidget {
  const ClientChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bloc = context.read<ChartBloc>();
    if (bloc.state is ChartInitial) bloc.add(ChartLoadRequested());

    return BlocConsumer<ChartBloc, ChartState>(
      listener: (context, state) {
        if (state is ChartCreated) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Client chart created!'), backgroundColor: AppColors.success));
        else if (state is ChartFailure) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
      },
      builder: (context, state) {
        final charts = state is ChartLoaded ? state.charts : <dynamic>[];
        final loading = state is ChartLoading;

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(l.clientCharts, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 20)),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddClientChartScreen())),
                icon: const Icon(Icons.add, size: 18), label: Text(l.newChart),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40)),
              ),
            ]),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : charts.isEmpty
                    ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Text('\U0001f4dc', style: TextStyle(fontSize: 56)),
                        const SizedBox(height: 16),
                        Text(l.noChartsCreated, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                      ]))
                    : RefreshIndicator(
                        onRefresh: () async => context.read<ChartBloc>().add(ChartLoadRequested()),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: charts.length,
                          itemBuilder: (context, i) {
                            final c = charts[i];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => KundliViewerScreen(chartId: c['id'], clientName: c['name'] ?? 'Client'),
                                )),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(children: [
                                    Container(
                                      width: 48, height: 48,
                                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                                      child: const Center(child: Text('\U0001f4dc', style: TextStyle(fontSize: 22))),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(c['name'] ?? '', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                                      const SizedBox(height: 4),
                                      Text('${c['dob']} ${c['tob']} \u2022 ${c['place']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 6),
                                      Row(children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                                          child: Text(l.viewKundli, style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
                                        ),
                                      ]),
                                    ])),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                      onPressed: () => context.read<ChartBloc>().add(ChartDeleteRequested(chartId: c['id'])),
                                    ),
                                    const Icon(Icons.chevron_right, color: AppColors.primary),
                                  ]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ]);
      },
    );
  }
}
