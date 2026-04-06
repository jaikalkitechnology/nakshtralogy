import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/astrologer/astrologer_bloc.dart';
import '../../bloc/astrologer/astrologer_event.dart';
import '../../bloc/astrologer/astrologer_state.dart';
import '../../widgets/astrologer_profile_sheet.dart';

class AstrologersTab extends StatefulWidget {
  const AstrologersTab({super.key});

  @override
  State<AstrologersTab> createState() => _AstrologersTabState();
}

class _AstrologersTabState extends State<AstrologersTab> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AstrologerBloc>().add(const AstrologerLoadRequested(limit: 50));
      context.read<AstrologerBloc>().add(AstrologerSavedLoadRequested());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<AstrologerBloc>().add(AstrologerLoadRequested(limit: 50, search: q.isEmpty ? null : q));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchCtrl,
            onChanged: _onSearchChanged,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 18),
              hintText: 'Search astrologers...',
              hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              filled: true,
              fillColor: AppColors.card,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<AstrologerBloc, AstrologerState>(
            builder: (context, state) {
              if (state.loading && state.list.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              if (state.list.isEmpty) {
                return const Center(
                  child: Text('No astrologers found',
                      style: TextStyle(color: AppColors.textSecondary)),
                );
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  context.read<AstrologerBloc>().add(const AstrologerLoadRequested(limit: 50));
                },
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: state.list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _AstroRow(astro: state.list[i], saved: state.savedIds.contains(state.list[i]['id'])),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AstroRow extends StatelessWidget {
  final dynamic astro;
  final bool saved;
  const _AstroRow({required this.astro, required this.saved});

  @override
  Widget build(BuildContext context) {
    final rating = (astro['rating'] as num?)?.toDouble() ?? 0.0;
    final isOnline = astro['is_online'] == true && astro['is_busy'] != true;
    final isBusy = astro['is_busy'] == true;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => showAstrologerProfileSheet(context, astro['id'] as String),
      child: Container(
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
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.surface,
                      backgroundImage: astro['profile_image_url'] != null
                          ? NetworkImage(astro['profile_image_url'] as String)
                          : null,
                      child: astro['profile_image_url'] == null
                          ? const Text('🔮', style: TextStyle(fontSize: 22))
                          : null,
                    ),
                    if (isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.card, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              astro['display_name'] ?? '—',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isOnline)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('Online',
                                  style: TextStyle(color: AppColors.success, fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                          if (isBusy)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFACC15).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('Busy',
                                  style: TextStyle(color: Color(0xFFFACC15), fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ((astro['specializations'] as List?) ?? []).join(', '),
                        style: const TextStyle(color: AppColors.primary, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.primary, size: 11),
                          const SizedBox(width: 2),
                          Text('${rating.toStringAsFixed(1)} (${astro['total_reviews'] ?? 0})',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                          const SizedBox(width: 8),
                          Text('${astro['experience_years'] ?? 0} yrs',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    saved ? Icons.favorite : Icons.favorite_border,
                    color: saved ? AppColors.error : AppColors.textSecondary,
                    size: 22,
                  ),
                  onPressed: () {
                    context.read<AstrologerBloc>().add(AstrologerToggleSave(astro['id'] as String));
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Rate card
            Row(
              children: [
                _rateBox(Icons.chat_bubble_outline, 'Chat', (astro['rate_per_min_chat'] as num?)?.toDouble() ?? 0),
                const SizedBox(width: 6),
                _rateBox(Icons.call, 'Voice', (astro['rate_per_min_call'] as num?)?.toDouble() ?? 0),
                const SizedBox(width: 6),
                _rateBox(Icons.videocam, 'Video', (astro['rate_per_min_video'] as num?)?.toDouble() ?? 0),
              ],
            ),
            const SizedBox(height: 10),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      textStyle: const TextStyle(fontSize: 11),
                    ),
                    onPressed: isOnline ? () {} : null,
                    icon: const Icon(Icons.chat_bubble_outline, size: 13),
                    label: const Text('Chat'),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      textStyle: const TextStyle(fontSize: 11),
                    ),
                    onPressed: isOnline ? () {} : null,
                    icon: const Icon(Icons.call, size: 13),
                    label: const Text('Call'),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      textStyle: const TextStyle(fontSize: 11),
                    ),
                    onPressed: isOnline ? () {} : null,
                    icon: const Icon(Icons.videocam, size: 13),
                    label: const Text('Video'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rateBox(IconData icon, String label, double rate) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 12),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 8)),
            Text('₹${rate.toInt()}/m',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
