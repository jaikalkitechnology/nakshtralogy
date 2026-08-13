import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../shared/responsive.dart';
import '../models/portal_activity_item.dart';
import '../portal_repository.dart';

typedef _HistoryCubit = DataCubit<List<PortalActivityItem>>;

/// The astrologer's own past chat/call/video consultations plus Super
/// Chat/Gift income received during their live streams, merged into one
/// chronologically-sorted feed by the backend — mirrors the seeker-side
/// ConsultationHistoryScreen in the user app.
class ConsultationHistoryScreen extends StatelessWidget {
  const ConsultationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<_HistoryCubit>(
      create: (_) => DataCubit(() => getIt<PortalRepository>().activity())..load(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultation History')),
      body: SafeArea(
        top: false,
        child: CenteredMaxWidth(
          maxWidth: 640,
          child: BlocBuilder<_HistoryCubit, DataState<List<PortalActivityItem>>>(
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
      BuildContext context, DataState<List<PortalActivityItem>> state, List<PortalActivityItem>? items) {
    if (items == null) {
      final err = state.errorMessage;
      if (err != null) return _scrollMessage(err, AppColors.danger);
      return const Center(child: CircularProgressIndicator(color: AppColors.saffron));
    }
    if (items.isEmpty) {
      return _emptyState(Icons.history, 'No consultations yet.');
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        return item.isConsultation ? _HistoryRow(item: item) : _GiftRow(item: item);
      },
    );
  }

  Widget _scrollMessage(String text, Color color) => ListView(
        children: [
          const SizedBox(height: 160),
          Center(
            child: Text(text, textAlign: TextAlign.center, style: AppTextStyles.body(color: color)),
          ),
        ],
      );

  /// Refined empty state — icon medallion + message instead of a bare Text.
  Widget _emptyState(IconData icon, String text) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        children: [
          const SizedBox(height: 140),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface2,
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Icon(icon, size: 40, color: AppColors.ivoryFaint),
            ),
          ),
          const SizedBox(height: 18),
          Text(text,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
        ],
      );
}

String _dateLabel(DateTime? d) {
  if (d == null) return '';
  final local = d.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(local.day)}/${two(local.month)}/${local.year} · ${two(local.hour)}:${two(local.minute)}';
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.item});
  final PortalActivityItem item;

  IconData get _icon => switch (item.type) {
        ConsultationType.call => Icons.call,
        ConsultationType.video => Icons.videocam_outlined,
        _ => Icons.chat_bubble_outline,
      };

  ({String label, Color color}) get _statusInfo => switch (item.status) {
        ConsultationStatus.completed => (label: 'Completed', color: AppColors.success),
        ConsultationStatus.declined => (label: 'Declined', color: AppColors.danger),
        ConsultationStatus.cancelled => (label: 'Cancelled', color: AppColors.danger),
        ConsultationStatus.expired => (label: 'Expired', color: AppColors.ivoryFaint),
        ConsultationStatus.inProgress => (label: 'In progress', color: AppColors.gold),
        ConsultationStatus.accepted => (label: 'Accepted', color: AppColors.gold),
        _ => (label: 'Pending', color: AppColors.gold),
      };

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
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.saffron.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(_icon, size: 20, color: AppColors.saffron),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (item.counterpartName != null && item.counterpartName!.trim().isNotEmpty)
                      ? item.counterpartName!
                      : 'Seeker',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(size: 15, weight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(_dateLabel(item.timestamp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.mono(size: 12, color: AppColors.ivoryDim)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${item.displayAmount}',
                  style: AppTextStyles.mono(size: 13, color: AppColors.success)),
              const SizedBox(height: 4),
              Text(status.label,
                  style: AppTextStyles.label(size: 11, color: status.color)),
            ],
          ),
        ],
      ),
    );
  }
}

/// A Super Chat or Gift row — always a credit/earning from a seeker during
/// one of the astrologer's live streams. Styled consistently with
/// [_HistoryRow]'s payout styling (green/positive amount), but with a
/// distinct icon and no status badge (gifts/super-chats have no lifecycle).
class _GiftRow extends StatelessWidget {
  const _GiftRow({required this.item});
  final PortalActivityItem item;

  bool get _isGift => item.kind == PortalActivityKind.gift;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(_isGift ? Icons.card_giftcard : Icons.push_pin_outlined,
                size: 20, color: AppColors.gold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (item.counterpartName != null && item.counterpartName!.trim().isNotEmpty)
                      ? item.counterpartName!
                      : 'Seeker',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(size: 15, weight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  _isGift
                      ? (item.giftName != null ? 'Sent a gift · ${item.giftName}' : 'Sent a gift')
                      : 'Super Chat',
                  style: AppTextStyles.body(size: 12, color: AppColors.copperLight),
                ),
                if (!_isGift && item.message != null && item.message!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('"${item.message}"',
                      style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
                ],
                const SizedBox(height: 2),
                Text(_dateLabel(item.timestamp),
                    style: AppTextStyles.mono(size: 12, color: AppColors.ivoryDim)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('+₹${item.displayAmount}',
              style: AppTextStyles.mono(size: 13, color: AppColors.success)),
        ],
      ),
    );
  }
}
