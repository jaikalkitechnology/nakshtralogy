import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/service/service_bloc.dart';
import '../../bloc/service/service_event.dart';
import '../../bloc/service/service_state.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _selectedCategory = 'all';
  final _categories = ['all', 'kundli', 'report', 'ai'];

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ServiceBloc>();
    if (bloc.state is ServiceInitial) {
      bloc.add(const ServiceLoadRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Category filter
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: _categories.map((cat) {
          final selected = _selectedCategory == cat;
          return Padding(padding: const EdgeInsets.only(right: 8), child: FilterChip(
            label: Text(cat == 'all' ? 'All' : cat[0].toUpperCase() + cat.substring(1), style: TextStyle(color: selected ? Colors.black : AppColors.textSecondary, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
            selected: selected, selectedColor: AppColors.primary, backgroundColor: AppColors.surface,
            side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
            onSelected: (_) {
              setState(() => _selectedCategory = cat);
              context.read<ServiceBloc>().add(ServiceLoadRequested(category: cat == 'all' ? null : cat));
            },
          ));
        }).toList()),
      ),

      // Services list
      Expanded(
        child: BlocBuilder<ServiceBloc, ServiceState>(
          builder: (context, state) {
            if (state is ServiceLoading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));

            final services = state is ServiceLoaded ? state.services : <dynamic>[];
            if (services.isEmpty) {
              return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('\U0001f4dc', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text('No services available', style: TextStyle(color: AppColors.textSecondary)),
              ]));
            }

            return RefreshIndicator(
              onRefresh: () async => context.read<ServiceBloc>().add(ServiceLoadRequested(category: _selectedCategory == 'all' ? null : _selectedCategory)),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final s = services[index];
                  final price = (s['price'] as num?)?.toDouble() ?? 0;
                  final origPrice = (s['original_price'] as num?)?.toDouble();
                  final features = (s['features_json'] as List?)?.cast<String>() ?? [];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(s['icon'] ?? '\U0001f4dc', style: const TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(s['service_name'] ?? '', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                          const SizedBox(height: 2),
                          Row(children: [
                            if (price == 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                                child: const Text('FREE', style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600)),
                              )
                            else ...[
                              Text('\u20b9${price.toInt()}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                              if (origPrice != null && origPrice > price) ...[
                                const SizedBox(width: 6),
                                Text('\u20b9${origPrice.toInt()}', style: const TextStyle(color: AppColors.textSecondary, decoration: TextDecoration.lineThrough, fontSize: 12)),
                              ],
                            ],
                          ]),
                        ])),
                      ]),
                      if (s['description'] != null) ...[const SizedBox(height: 10), Text(s['description'], style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))],
                      if (features.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(spacing: 6, runSpacing: 6, children: features.map((f) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.accent.withOpacity(0.2))),
                          child: Text(f, style: const TextStyle(color: AppColors.accent, fontSize: 11)),
                        )).toList()),
                      ],
                    ]),
                  );
                },
              ),
            );
          },
        ),
      ),
    ]);
  }
}
