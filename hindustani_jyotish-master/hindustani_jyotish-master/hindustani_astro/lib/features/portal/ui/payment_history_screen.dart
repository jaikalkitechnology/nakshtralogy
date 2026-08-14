import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../shared/premium_ui.dart';
import '../../../shared/responsive.dart';
import '../portal_repository.dart';

typedef _PayoutsCubit = DataCubit<List<Map<String, dynamic>>>;

/// The astrologer's payout/withdrawal request history.
class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<_PayoutsCubit>(
      create: (_) => DataCubit(() => getIt<PortalRepository>().payouts())..load(),
      child: const _PaymentHistoryView(),
    );
  }
}

class _PaymentHistoryView extends StatelessWidget {
  const _PaymentHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment History')),
      body: SafeArea(
        top: false,
        child: CenteredMaxWidth(
          maxWidth: 640,
          child: BlocBuilder<_PayoutsCubit, DataState<List<Map<String, dynamic>>>>(
            builder: (context, state) {
              final items = state.dataOrNull;
              return RefreshIndicator(
                onRefresh: () => context.read<_PayoutsCubit>().refresh(),
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
    DataState<List<Map<String, dynamic>>> state,
    List<Map<String, dynamic>>? items,
  ) {
    if (items == null) {
      final err = state.errorMessage;
      if (err != null) return _scrollMessage(err, AppColors.danger);
      return const Center(child: CircularProgressIndicator(color: AppColors.saffron));
    }
    if (items.isEmpty) {
      return _emptyState(Icons.account_balance_wallet_outlined, 'No withdrawal requests yet.');
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      itemCount: items.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) {
          return SectionLabel(
            'Withdrawals',
            trailing: StatusChip('${items.length}', tone: ChipTone.muted),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _PayoutRow(p: items[i - 1]),
        );
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

  /// Friendly empty state — a glowing gold medallion above the message.
  Widget _emptyState(IconData icon, String text) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        children: [
          const SizedBox(height: 120),
          Center(child: IconTile(icon, tone: TileTone.gold, size: 76)),
          const SizedBox(height: 22),
          Text(text,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
          const SizedBox(height: 6),
          Text('Your payout requests will appear here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 12.5, color: AppColors.ivoryFaint)),
        ],
      );
}

class _PayoutRow extends StatelessWidget {
  const _PayoutRow({required this.p});
  final Map<String, dynamic> p;

  /// Status pill. The shared [StatusChip] has no danger tone, so 'failed'
  /// renders as an inline danger-toned pill matching the same shape.
  Widget _statusChip() {
    final status = '${p['status'] ?? ''}';
    return switch (status) {
      'paid' => const StatusChip('Paid', tone: ChipTone.success, icon: Icons.check_circle_rounded),
      'processing' =>
        const StatusChip('Processing', tone: ChipTone.warn, icon: Icons.autorenew_rounded),
      'failed' => _dangerChip('Failed', Icons.error_rounded),
      _ => const StatusChip('Requested', tone: ChipTone.info, icon: Icons.schedule_rounded),
    };
  }

  Widget _dangerChip(String label, IconData icon) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.danger.withValues(alpha: 0.32)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.danger),
            const SizedBox(width: 5),
            Text(label,
                style: AppTextStyles.label(size: 11, weight: FontWeight.w700, color: AppColors.danger)),
          ],
        ),
      );

  String _dateLabel() {
    final raw = p['paid_at'] ?? p['created_at'];
    if (raw == null) return '';
    final d = DateTime.tryParse('$raw')?.toLocal();
    if (d == null) return '';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} · ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final last4 = p['bank_account_last4'] as String?;
    final title = (last4 != null && last4.isNotEmpty) ? 'Bank ••••$last4' : 'Withdrawal';
    final date = _dateLabel();
    return PremiumCard(
      child: Row(
        children: [
          // A payout is money leaving the balance → outbound saffron arrow.
          const IconTile(Icons.arrow_upward_rounded, tone: TileTone.saffron, size: 42),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(size: 15, weight: FontWeight.w700),
                ),
                if (date.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 12, color: AppColors.ivoryFaint),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.mono(size: 11.5, color: AppColors.ivoryDim),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Payout amount is an outflow → neutral ivory tabular figures.
              Text('₹${p['amount'] ?? '0.00'}',
                  style: AppTextStyles.mono(
                      size: 15, weight: FontWeight.w700, color: AppColors.ivory)),
              const SizedBox(height: 6),
              _statusChip(),
            ],
          ),
        ],
      ),
    );
  }
}
