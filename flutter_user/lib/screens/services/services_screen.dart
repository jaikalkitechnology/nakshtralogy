import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<dynamic> _services = [];
  bool _loading = true;
  String _selectedCategory = 'all';

  final _categories = ['all', 'kundli', 'report', 'ai'];

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _loading = true);
    final services = await ApiService().getServicePricing();
    setState(() {
      _services = services;
      _loading = false;
    });
  }

  List<dynamic> get _filteredServices {
    if (_selectedCategory == 'all') return _services;
    return _services.where((s) => s['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: _categories.map((cat) {
              final selected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    cat == 'all' ? 'All' : cat[0].toUpperCase() + cat.substring(1),
                    style: TextStyle(
                      color: selected ? Colors.black : AppColors.textSecondary,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  selected: selected,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                ),
              );
            }).toList(),
          ),
        ),

        // Services list
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : _filteredServices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('📜', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text('No services available', style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadServices,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredServices.length,
                        itemBuilder: (context, index) {
                          final s = _filteredServices[index];
                          final price = (s['price'] as num?)?.toDouble() ?? 0;
                          final origPrice = (s['original_price'] as num?)?.toDouble();
                          final features = (s['features_json'] as List?)?.cast<String>() ?? [];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
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
                                    Text(s['icon'] ?? '📜', style: const TextStyle(fontSize: 32)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            s['service_name'] ?? '',
                                            style: const TextStyle(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              if (price == 0)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.success.withOpacity(0.15),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: const Text('FREE', style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600)),
                                                )
                                              else ...[
                                                Text('₹${price.toInt()}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                                                if (origPrice != null && origPrice > price) ...[
                                                  const SizedBox(width: 6),
                                                  Text('₹${origPrice.toInt()}', style: const TextStyle(color: AppColors.textSecondary, decoration: TextDecoration.lineThrough, fontSize: 12)),
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
                                  const SizedBox(height: 10),
                                  Text(s['description'], style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                ],
                                if (features.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: features.map((f) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                                      ),
                                      child: Text(f, style: const TextStyle(color: AppColors.accent, fontSize: 11)),
                                    )).toList(),
                                  ),
                                ],
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
