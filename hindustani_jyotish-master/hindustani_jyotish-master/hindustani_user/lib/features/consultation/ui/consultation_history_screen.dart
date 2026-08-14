import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../shared/premium_ui.dart';
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
      if (err != null) {
        return _emptyState(
          icon: Icons.error_outline,
          tone: TileTone.saffron,
          title: err,
          subtitle: 'Pull down to try again.',
          titleColor: AppColors.danger,
        );
      }
      return const Center(
        child: CircularProgressIndicator(color: AppColors.saffron),
      );
    }
    if (items.isEmpty) {
      return _emptyState(
        icon: Icons.history,
        tone: TileTone.gold,
        title: 'No consultations yet.',
        subtitle: 'Your past chats, calls and video sessions will appear here.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _HistoryRow(item: items[i]),
      ),
    );
  }

  Widget _emptyState({
    required IconData icon,
    required TileTone tone,
    required String title,
    required String subtitle,
    Color? titleColor,
  }) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
      children: [
        const SizedBox(height: 120),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTile(icon, tone: tone, size: 64),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading(
                  size: 17,
                  color: titleColor ?? AppColors.ivory,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.body(size: 13, color: AppColors.ivoryFaint),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.item});
  final ActivityItem item;

  ({IconData icon, TileTone tone}) get _typeVisual => switch (item.type) {
    ConsultationType.chat => (
      icon: Icons.chat_bubble_outline,
      tone: TileTone.info,
    ),
    ConsultationType.call => (icon: Icons.call, tone: TileTone.saffron),
    ConsultationType.video => (
      icon: Icons.videocam_outlined,
      tone: TileTone.gold,
    ),
    null => (icon: Icons.chat_bubble_outline, tone: TileTone.info),
  };

  ({String label, ChipTone tone})? get _status => switch (item.status) {
    ConsultationStatus.completed => (label: 'Completed', tone: ChipTone.success),
    ConsultationStatus.declined => (label: 'Declined', tone: ChipTone.warn),
    ConsultationStatus.cancelled => (label: 'Cancelled', tone: ChipTone.warn),
    ConsultationStatus.expired => (label: 'Expired', tone: ChipTone.muted),
    ConsultationStatus.inProgress => (
      label: 'In progress',
      tone: ChipTone.info,
    ),
    ConsultationStatus.accepted => (label: 'Accepted', tone: ChipTone.info),
    ConsultationStatus.requested => (label: 'Pending', tone: ChipTone.muted),
    null => null,
  };

  String _dateLabel() {
    final local = item.timestamp.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} · ${two(local.hour)}:${two(local.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;
    final visual = _typeVisual;
    return PremiumCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconTile(visual.icon, tone: visual.tone),
          const SizedBox(width: 14),
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
                  style: AppTextStyles.body(size: 15.5, weight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  _dateLabel(),
                  style: AppTextStyles.mono(
                    size: 12,
                    color: AppColors.ivoryFaint,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (status != null)
                StatusChip(status.label, tone: status.tone),
              const SizedBox(height: 8),
              Text(
                '₹${item.displayAmount}',
                style: AppTextStyles.mono(
                  size: 13.5,
                  weight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
