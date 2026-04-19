import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/astro_wallet/astro_wallet_bloc.dart';
import '../../bloc/astro_wallet/astro_wallet_event.dart';
import '../../bloc/astro_wallet/astro_wallet_state.dart';

class EarningsTab extends StatefulWidget {
  const EarningsTab({super.key});
  @override
  State<EarningsTab> createState() => _EarningsTabState();
}

class _EarningsTabState extends State<EarningsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AstroWalletBloc>().add(const AstroWalletLoadRequested());
    });
  }

  void _showWithdrawDialog() {
    final l = AppLocalizations.of(context)!;
    final amountCtrl = TextEditingController();
    final upiCtrl = TextEditingController();
    final bankNameCtrl = TextEditingController();
    final bankAccCtrl = TextEditingController();
    final bankIfscCtrl = TextEditingController();
    bool isUpi = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setDialogState) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: Text(l.requestWithdrawal, style: const TextStyle(color: AppColors.primary)),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount (₹)', prefixIcon: Icon(Icons.currency_rupee)),
            ),
            const SizedBox(height: 14),
            // UPI / Bank toggle
            Row(children: [
              Expanded(child: GestureDetector(
                onTap: () => setDialogState(() => isUpi = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isUpi ? AppColors.primary.withOpacity(0.2) : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isUpi ? AppColors.primary : AppColors.border),
                  ),
                  child: Center(child: Text('UPI', style: TextStyle(color: isUpi ? AppColors.primary : AppColors.textSecondary, fontWeight: FontWeight.w600))),
                ),
              )),
              const SizedBox(width: 10),
              Expanded(child: GestureDetector(
                onTap: () => setDialogState(() => isUpi = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: !isUpi ? AppColors.primary.withOpacity(0.2) : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: !isUpi ? AppColors.primary : AppColors.border),
                  ),
                  child: Center(child: Text('Bank Transfer', style: TextStyle(color: !isUpi ? AppColors.primary : AppColors.textSecondary, fontWeight: FontWeight.w600))),
                ),
              )),
            ]),
            const SizedBox(height: 14),
            if (isUpi)
              TextField(controller: upiCtrl, decoration: const InputDecoration(labelText: 'UPI ID', prefixIcon: Icon(Icons.account_balance)))
            else ...[
              TextField(controller: bankNameCtrl, decoration: const InputDecoration(labelText: 'Account Holder Name', prefixIcon: Icon(Icons.person))),
              const SizedBox(height: 10),
              TextField(controller: bankAccCtrl, decoration: const InputDecoration(labelText: 'Account Number', prefixIcon: Icon(Icons.numbers))),
              const SizedBox(height: 10),
              TextField(controller: bankIfscCtrl, decoration: const InputDecoration(labelText: 'IFSC Code', prefixIcon: Icon(Icons.code))),
            ],
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel, style: const TextStyle(color: AppColors.textSecondary))),
            BlocBuilder<AstroWalletBloc, AstroWalletState>(builder: (context, state) {
              return ElevatedButton(
                onPressed: state.withdrawing ? null : () {
                  final amount = double.tryParse(amountCtrl.text.trim());
                  if (amount == null || amount <= 0) return;
                  context.read<AstroWalletBloc>().add(AstroWithdrawRequested(
                    amount: amount,
                    upiId: isUpi ? upiCtrl.text.trim() : null,
                    bankAccountName: !isUpi ? bankNameCtrl.text.trim() : null,
                    bankAccountNumber: !isUpi ? bankAccCtrl.text.trim() : null,
                    bankIfsc: !isUpi ? bankIfscCtrl.text.trim() : null,
                  ));
                  Navigator.pop(ctx);
                },
                child: state.withdrawing ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l.submit),
              );
            }),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocConsumer<AstroWalletBloc, AstroWalletState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.success));
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!), backgroundColor: AppColors.error));
        }
      },
      builder: (context, state) {
        if (state.loading && state.wallet == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        final wallet = state.wallet ?? {};
        final balance = wallet['balance'] ?? 0;
        final totalEarned = wallet['total_earned'] ?? 0;
        final totalWithdrawn = wallet['total_withdrawn'] ?? 0;
        final withdrawable = wallet['withdrawable'] ?? 0;
        final minWithdraw = wallet['withdrawal_config']?['minimum_amount'] ?? 500;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => context.read<AstroWalletBloc>().add(AstroWalletLoadRequested(page: state.page, kind: state.kind)),
          child: ListView(padding: const EdgeInsets.all(16), children: [
            // ── Gold Hero Card ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.gold, AppColors.saffron],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('THIS MONTH', style: TextStyle(
                  fontSize: 9, letterSpacing: 2,
                  color: AppColors.midnight.withOpacity(0.7), fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('\u20b9$balance', style: const TextStyle(color: AppColors.midnight, fontSize: 40, fontWeight: FontWeight.w700, height: 1)),
                const SizedBox(height: 14),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _WalletStat(label: 'Total Earned', value: '₹$totalEarned'),
                  Container(width: 1, height: 30, color: AppColors.border),
                  _WalletStat(label: 'Withdrawn', value: '₹$totalWithdrawn'),
                  Container(width: 1, height: 30, color: AppColors.border),
                  _WalletStat(label: 'Withdrawable', value: '₹$withdrawable'),
                ]),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _showWithdrawDialog,
                  icon: const Icon(Icons.account_balance_wallet),
                  label: Text('Withdraw (min ₹$minWithdraw)'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 46)),
                ),
              ]),
            ),
            const SizedBox(height: 20),

            // ── Filter chips ──
            Text(l.statement, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: ['all', 'consultation_credit', 'withdrawal', 'bonus', 'refund'].map((k) {
                final selected = state.kind == k;
                final label = k == 'all' ? l.all : k == 'consultation_credit' ? l.credits : k == 'withdrawal' ? l.withdrawals : k == 'bonus' ? l.bonus : l.refunds;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: selected,
                    label: Text(label),
                    labelStyle: TextStyle(color: selected ? Colors.black : AppColors.textSecondary, fontSize: 13),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
                    onSelected: (_) => context.read<AstroWalletBloc>().add(AstroWalletLoadRequested(page: 0, kind: k)),
                  ),
                );
              }).toList()),
            ),
            const SizedBox(height: 12),

            // ── Transactions ──
            if (state.transactions.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Center(child: Text(l.noTransactions, style: const TextStyle(color: AppColors.textSecondary))),
              )
            else
              ...state.transactions.map((txn) => _TxnRow(txn: txn as Map<String, dynamic>)),

            // ── Pagination ──
            if (state.total > 10)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                    onPressed: state.page > 0 ? () => context.read<AstroWalletBloc>().add(AstroWalletLoadRequested(page: state.page - 1, kind: state.kind)) : null,
                    icon: const Icon(Icons.chevron_left),
                    color: AppColors.primary,
                  ),
                  Text('Page ${state.page + 1}', style: const TextStyle(color: AppColors.textSecondary)),
                  IconButton(
                    onPressed: (state.page + 1) * 10 < state.total ? () => context.read<AstroWalletBloc>().add(AstroWalletLoadRequested(page: state.page + 1, kind: state.kind)) : null,
                    icon: const Icon(Icons.chevron_right),
                    color: AppColors.primary,
                  ),
                ]),
              ),

            const SizedBox(height: 20),

            // ── Withdrawal History ──
            if (state.withdrawals.isNotEmpty) ...[
              Text(l.withdrawalHistory, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              ...state.withdrawals.map((w) => _WithdrawalRow(withdrawal: w as Map<String, dynamic>)),
            ],
          ]),
        );
      },
    );
  }
}

class _WalletStat extends StatelessWidget {
  final String label;
  final String value;
  const _WalletStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
      Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
    ]);
  }
}

class _TxnRow extends StatelessWidget {
  final Map<String, dynamic> txn;
  const _TxnRow({required this.txn});

  @override
  Widget build(BuildContext context) {
    final type = txn['txn_type'] ?? '';
    final amount = txn['amount'] ?? 0;
    final createdAt = txn['created_at'] ?? '';
    final desc = txn['description'] ?? type;
    final isCredit = type == 'consultation_credit' || type == 'bonus' || type == 'refund';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.gold.withOpacity(0.08)))),
      child: Row(children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
            color: (isCredit ? AppColors.success : AppColors.error).withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(isCredit ? Icons.arrow_downward : Icons.arrow_upward, color: isCredit ? AppColors.success : AppColors.error, size: 14),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(desc.toString(), style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
          Text(createdAt.toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ])),
        Text('${isCredit ? '+' : '-'}₹$amount', style: TextStyle(color: isCredit ? AppColors.success : AppColors.error, fontWeight: FontWeight.w600, fontSize: 14)),
      ]),
    );
  }
}

class _WithdrawalRow extends StatelessWidget {
  final Map<String, dynamic> withdrawal;
  const _WithdrawalRow({required this.withdrawal});

  @override
  Widget build(BuildContext context) {
    final amount = withdrawal['amount'] ?? 0;
    final status = withdrawal['status'] ?? 'pending';
    final createdAt = withdrawal['created_at'] ?? '';
    final method = withdrawal['upi_id'] != null ? 'UPI: ${withdrawal['upi_id']}' : 'Bank Transfer';

    Color statusColor;
    switch (status) {
      case 'approved':
      case 'paid':
        statusColor = AppColors.success;
        break;
      case 'rejected':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = Colors.amber;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('₹$amount', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 2),
          Text(method, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          Text(createdAt.toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
          child: Text(status.toString().toUpperCase(), style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}
