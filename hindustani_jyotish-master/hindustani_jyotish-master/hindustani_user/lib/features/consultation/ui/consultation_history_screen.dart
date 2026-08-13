import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../shared/responsive.dart';
import '../consultation_repository.dart';

typedef _HistoryCubit = DataCubit<List<ActivityItem>>;

/// Past chat/call/video consultations — the "Chat/Call History" entry from
/// the profile menu. Read-only: no accept/decline here, that's the
/// astrologer side.
class ConsultationHistoryScreen extends StatelessWidget {
  const ConsultationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<_HistoryCubit>(
      create: (_) =>
          DataCubit(() => getIt<ConsultationRepository>().myActivity())..load(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat & Call History')),
      body: SafeArea(
        child: CenteredMaxWidth(
          maxWidth: Responsive.readableMaxWidth,
          child: BlocBuilder<_HistoryCubit, DataState<List<ActivityItem>>>(
            builder: (context, state) {
              final items = state.dataOrNull;
              return RefreshIndicator(
                onRefresh: () => context.read<_HistoryCubit>().refresh(),
                color: AppColors.saffron,
                child: _body(context, state, items),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    DataState<List<ActivityItem>> state,
    List<ActivityItem>? items,
  ) {
    if (items == null) {
      final err = state.errorMessage;
      if (err != null) return _scrollMessage(err, AppColors.danger);
      return const Center(
        child: CircularProgressIndicator(color: AppColors.saffron),
      );
    }
    if (items.isEmpty) {
      return _scrollMessage('No consultations yet.', AppColors.ivoryFaint);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: items.length,
      itemBuilder: (_, i) => _HistoryRow(item: items[i]),
    );
  }

  Widget _scrollMessage(String text, Color color) => ListView(
    children: [
      const SizedBox(height: 160),
      Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.body(color: color),
        ),
      ),
    ],
  );
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.item});
  final ActivityItem item;

  IconData get _icon => switch (item.type) {
    ConsultationType.chat => Icons.chat_bubble_outline,
    ConsultationType.call => Icons.call,
    ConsultationType.video => Icons.videocam_outlined,
    null => Icons.chat_bubble_outline,
  };

  ({String label, Color color}) get _statusInfo => switch (item.status) {
    ConsultationStatus.completed => (
      label: 'Completed',
      color: AppColors.success,
    ),
    ConsultationStatus.declined => (
      label: 'Declined',
      color: AppColors.danger,
    ),
    ConsultationStatus.cancelled => (
      label: 'Cancelled',
      color: AppColors.danger,
    ),
    ConsultationStatus.expired => (
      label: 'Expired',
      color: AppColors.ivoryFaint,
    ),
    ConsultationStatus.inProgress => (
      label: 'In progress',
      color: AppColors.gold,
    ),
    ConsultationStatus.accepted => (label: 'Accepted', color: AppColors.gold),
    ConsultationStatus.requested => (label: 'Pending', color: AppColors.gold),
    null => (label: '', color: AppColors.ivoryFaint),
  };

  String _dateLabel() {
    final local = item.timestamp.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} · ${two(local.hour)}:${two(local.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final status = _statusInfo;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderMid),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon, color: AppColors.saffron),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (item.counterpartName != null &&
                          item.counterpartName!.trim().isNotEmpty)
                      ? item.counterpartName!
                      : 'Astrologer',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(size: 15, weight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  _dateLabel(),
                  style: AppTextStyles.mono(
                    size: 12,
                    color: AppColors.ivoryDim,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${item.displayAmount}',
                style: AppTextStyles.mono(size: 13, color: AppColors.ivory),
              ),
              const SizedBox(height: 4),
              Text(
                status.label,
                style: AppTextStyles.label(size: 11, color: status.color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
