import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../shared/premium_ui.dart';
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

  /// Refined empty state — glowing icon tile + message instead of a bare Text.
  Widget _emptyState(IconData icon, String text) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        children: [
          const SizedBox(height: 140),
          Center(child: IconTile(icon, tone: TileTone.gold, size: 68)),
          const SizedBox(height: 20),
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

  /// Icon + tile tone reflecting the consultation TYPE.
  (IconData, TileTone) get _typeTile => switch (item.type) {
        ConsultationType.call => (Icons.call, TileTone.saffron),
        ConsultationType.video => (Icons.videocam_outlined, TileTone.gold),
        _ => (Icons.chat_bubble_outline, TileTone.info),
      };

  ({String label, ChipTone tone}) get _statusInfo => switch (item.status) {
        ConsultationStatus.completed => (label: 'Completed', tone: ChipTone.success),
        ConsultationStatus.declined => (label: 'Declined', tone: ChipTone.warn),
        ConsultationStatus.cancelled => (label: 'Cancelled', tone: ChipTone.warn),
        ConsultationStatus.expired => (label: 'Expired', tone: ChipTone.muted),
        ConsultationStatus.inProgress => (label: 'In progress', tone: ChipTone.info),
        ConsultationStatus.accepted => (label: 'Accepted', tone: ChipTone.info),
        _ => (label: 'Pending', tone: ChipTone.muted),
      };

  @override
  Widget build(BuildContext context) {
    final status = _statusInfo;
    final (icon, tone) = _typeTile;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        child: Row(
          children: [
            IconTile(icon, tone: tone),
            const SizedBox(width: 14),
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
                  const SizedBox(height: 4),
                  Text(_dateLabel(item.timestamp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.mono(size: 12, color: AppColors.ivoryDim)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹${item.displayAmount}',
                    style: AppTextStyles.mono(
                        size: 14, weight: FontWeight.w700, color: AppColors.success)),
                const SizedBox(height: 6),
                StatusChip(status.label, tone: status.tone),
              ],
            ),
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTile(_isGift ? Icons.card_giftcard : Icons.push_pin_outlined,
                tone: TileTone.gold),
            const SizedBox(width: 14),
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
                  const SizedBox(height: 3),
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
                  const SizedBox(height: 4),
                  Text(_dateLabel(item.timestamp),
                      style: AppTextStyles.mono(size: 12, color: AppColors.ivoryDim)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text('+₹${item.displayAmount}',
                style: AppTextStyles.mono(
                    size: 14, weight: FontWeight.w700, color: AppColors.success)),
          ],
        ),
      ),
    );
  }
}
