import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: items.length,
      itemBuilder: (_, i) => _PayoutRow(p: items[i]),
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

class _PayoutRow extends StatelessWidget {
  const _PayoutRow({required this.p});
  final Map<String, dynamic> p;

  ({String label, Color color}) get _statusInfo {
    final status = '${p['status'] ?? ''}';
    return switch (status) {
      'paid' => (label: 'Paid', color: AppColors.success),
      'processing' => (label: 'Processing', color: AppColors.gold),
      'failed' => (label: 'Failed', color: AppColors.danger),
      _ => (label: 'Requested', color: AppColors.info),
    };
  }

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
    final status = _statusInfo;
    final last4 = p['bank_account_last4'] as String?;
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
            child: const Icon(Icons.account_balance, size: 20, color: AppColors.saffron),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (last4 != null && last4.isNotEmpty) ? 'Bank ••••$last4' : 'Withdrawal',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(size: 15, weight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(_dateLabel(), style: AppTextStyles.mono(size: 12, color: AppColors.ivoryDim)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${p['amount'] ?? '0.00'}',
                  style: AppTextStyles.mono(size: 13, color: AppColors.ivory)),
              const SizedBox(height: 4),
              Text(status.label, style: AppTextStyles.label(size: 11, color: status.color)),
            ],
          ),
        ],
      ),
    );
  }
}
