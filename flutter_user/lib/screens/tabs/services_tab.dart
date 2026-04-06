import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/service/service_bloc.dart';
import '../../bloc/service/service_event.dart';
import '../../bloc/service/service_state.dart';

class ServicesTab extends StatefulWidget {
  const ServicesTab({super.key});

  @override
  State<ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<ServicesTab> {
  String _category = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceBloc>().add(const ServiceLoadRequested());
    });
  }

  void _onCategoryChange(String cat) {
    setState(() => _category = cat);
    context.read<ServiceBloc>().add(ServiceLoadRequested(category: cat == 'all' ? null : cat));
  }

  @override
  Widget build(BuildContext context) {
    const categories = ['all', 'kundli', 'report', 'ai'];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((c) {
                final selected = _category == c;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: selected,
                    label: Text(c == 'all' ? 'All' : c[0].toUpperCase() + c.substring(1)),
                    onSelected: (_) => _onCategoryChange(c),
                    backgroundColor: AppColors.card,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: selected ? Colors.black : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, state) {
              if (state is ServiceLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              final services = state is ServiceLoaded ? state.services : <dynamic>[];
              if (services.isEmpty) {
                return const Center(
                  child: Text('No services available', style: TextStyle(color: AppColors.textSecondary)),
                );
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  context.read<ServiceBloc>().add(ServiceLoadRequested(category: _category == 'all' ? null : _category));
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: services.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final s = services[i];
                    final price = (s['price'] as num?)?.toDouble() ?? 0;
                    final orig = (s['original_price'] as num?)?.toDouble();
                    final isFree = s['is_free'] == true || price == 0;
                    final features = (s['features_json'] as List?)?.cast<String>() ?? const [];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(s['icon'] ?? '📜', style: const TextStyle(fontSize: 28)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s['service_name'] ?? '',
                                      style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        if (isFree)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.success.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Text('FREE',
                                                style: TextStyle(
                                                    color: AppColors.success,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold)),
                                          )
                                        else ...[
                                          Text('₹${price.toInt()}',
                                              style: const TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          if (orig != null && orig > price) ...[
                                            const SizedBox(width: 6),
                                            Text('₹${orig.toInt()}',
                                                style: const TextStyle(
                                                    color: AppColors.textSecondary,
                                                    fontSize: 11,
                                                    decoration: TextDecoration.lineThrough)),
                                          ],
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (s['description'] != null) ...[
                            const SizedBox(height: 8),
                            Text(s['description'] as String,
                                style: const TextStyle(
                                    color: AppColors.textSecondary, fontSize: 11, height: 1.4)),
                          ],
                          if (features.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: features
                                  .take(5)
                                  .map((f) => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.accent.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                                        ),
                                        child: Text(f,
                                            style: const TextStyle(
                                                color: AppColors.accent, fontSize: 9)),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
