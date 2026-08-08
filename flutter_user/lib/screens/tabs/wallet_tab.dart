import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/wallet/wallet_bloc.dart';
import '../../bloc/wallet/wallet_event.dart';
import '../../bloc/wallet/wallet_state.dart';
import '../../services/app_mode.dart';
import '../../widgets/recharge_sheet.dart';
import '../../utils/money.dart';

class WalletTab extends StatefulWidget {
  const WalletTab({super.key});

  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletBloc>().add(const WalletLoadRequested());
    });
  }

  void _openRechargeDialog() {
    final l = AppLocalizations.of(context)!;
    final amountCtrl = TextEditingController(text: '500');
    final noteCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dctx) => BlocProvider.value(
        value: context.read<WalletBloc>(),
        child: BlocListener<WalletBloc, WalletState>(
          listener: (ctx, state) {
            if (!state.recharging && state.successMessage != null) {
              Navigator.pop(dctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.success),
              );
            }
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
              );
            }
          },
          child: AlertDialog(
            backgroundColor: AppColors.card,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(l.addBalance, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
              ],
            ),
            content: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (ctx, setSt) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: amountCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Amount (₹)',
                          prefixText: '₹ ',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: [100, 500, 1000, 2000, 5000].map((v) {
                          return ActionChip(
                            label: Text('₹$v'),
                            backgroundColor: AppColors.surface,
                            labelStyle: const TextStyle(color: AppColors.primary, fontSize: 11),
                            side: const BorderSide(color: AppColors.primary),
                            onPressed: () => setSt(() => amountCtrl.text = '$v'),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: noteCtrl,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(labelText: 'Note (optional)'),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '💳 In production this will redirect to Razorpay/Stripe.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
                      ),
                    ],
                  );
                },
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dctx), child: Text(l.cancel)),
              BlocBuilder<WalletBloc, WalletState>(
                builder: (ctx, state) => ElevatedButton(
                  onPressed: state.recharging
                      ? null
                      : () {
                          final amt = double.tryParse(amountCtrl.text) ?? 0;
                          if (amt <= 0) return;
                          context.read<WalletBloc>().add(
                                WalletRechargeRequested(amount: amt, note: noteCtrl.text.isEmpty ? null : noteCtrl.text),
                              );
                        },
                  child: state.recharging
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l.addBalance),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        final wallet = state.wallet;
        final balance = (wallet?['balance'] as num?)?.toDouble() ?? 0.0;
        final totalCredit = (wallet?['total_credit'] as num?)?.toDouble() ?? 0.0;
        final totalDebit = (wallet?['total_debit'] as num?)?.toDouble() ?? 0.0;
        // International: show the balance in USD (display conversion via the
        // admin FX rate from the backend); the INR ledger is unchanged. Wallet
        // recharge is India-only — international tops up via store IAP instead.
        final displayCurrency = (wallet?['display_currency'] as String?) ??
            (AppMode.instance.isInternational ? 'USD' : 'INR');
        final displayBalance = (wallet?['display_balance'] as num?)?.toDouble() ?? balance;
        final fx = (wallet?['fx_rate_usd'] as num?)?.toDouble();
        final intl = displayCurrency.toUpperCase() == 'USD';
        final rechargeEnabled = (wallet?['recharge_enabled'] as bool?) ?? !intl;
        double conv(double inr) => (intl && fx != null && fx > 0) ? inr / fx : inr;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            context.read<WalletBloc>().add(WalletLoadRequested(page: 0, txnType: _filter));
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Balance card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.card, AppColors.primary.withValues(alpha: 0.12)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    Text(l.walletBalance,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(
                      Money.format(displayBalance, currency: displayCurrency, decimals: 2),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (rechargeEnabled)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final ok = await showRechargeSheet(context);
                            if (ok && context.mounted) {
                              context.read<WalletBloc>().add(WalletLoadRequested(page: 0, txnType: _filter));
                            }
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(l.addBalance),
                        ),
                      ),
                    if (rechargeEnabled) const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(l.totalCredit,
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
                              Text('+${Money.format(conv(totalCredit), currency: displayCurrency)}',
                                  style: const TextStyle(color: AppColors.success, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 30, color: AppColors.border),
                        Expanded(
                          child: Column(
                            children: [
                              Text(l.totalDebit,
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
                              Text('−${Money.format(conv(totalDebit), currency: displayCurrency)}',
                                  style: const TextStyle(color: AppColors.error, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Quick recharge chips (India-only — international tops up via IAP)
              if (rechargeEnabled) ...[
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [100, 500, 1000, 2000, 5000].map((amt) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: OutlinedButton(
                          onPressed: () async {
                            final ok = await showRechargeSheet(context, suggested: amt.toDouble());
                            if (ok && context.mounted) {
                              context.read<WalletBloc>().add(WalletLoadRequested(page: 0, txnType: _filter));
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            side: const BorderSide(color: AppColors.border),
                          ),
                          child: Text('+ ₹$amt',
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 11)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Filter + statement
              Row(
                children: [
                  Text(l.statement,
                      style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  DropdownButton<String>(
                    value: _filter,
                    dropdownColor: AppColors.card,
                    underline: const SizedBox.shrink(),
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 11),
                    items: [
                      DropdownMenuItem(value: 'all', child: Text(l.allTypes)),
                      DropdownMenuItem(value: 'recharge', child: Text(l.recharge)),
                      DropdownMenuItem(value: 'bonus', child: Text(l.bonus)),
                      DropdownMenuItem(value: 'consultation_debit', child: Text(l.serviceLabel)),
                      DropdownMenuItem(value: 'refund', child: Text(l.refund)),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => _filter = v);
                      context.read<WalletBloc>().add(WalletLoadRequested(page: 0, txnType: v));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (state.loading && state.transactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                )
              else if (state.transactions.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(l.noTransactions,
                        style: const TextStyle(color: AppColors.textSecondary)),
                  ),
                )
              else
                ...state.transactions.map((t) {
                  final isCredit = t['direction'] == 'credit';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (isCredit ? AppColors.success : AppColors.error).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                            color: isCredit ? AppColors.success : AppColors.error,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t['label'] ?? t['txn_type'] ?? '—',
                                style: const TextStyle(
                                    color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              if (t['description'] != null)
                                Text(
                                  t['description'] as String,
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              Text(
                                (t['created_at'] as String?)?.substring(0, 16) ?? '',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${isCredit ? '+' : '−'}${Money.format(conv((t['amount'] as num?)?.toDouble() ?? 0), currency: displayCurrency)}',
                              style: TextStyle(
                                color: isCredit ? AppColors.success : AppColors.error,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Bal ${Money.format(conv((t['balance_after'] as num?)?.toDouble() ?? 0), currency: displayCurrency)}',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 9),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

              // Pagination
              if (state.total > WalletBloc.pageSize) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Page ${state.page + 1} of ${((state.total - 1) ~/ WalletBloc.pageSize) + 1}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: state.page > 0
                              ? () => context
                                  .read<WalletBloc>()
                                  .add(WalletLoadRequested(page: state.page - 1, txnType: _filter))
                              : null,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(70, 32),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          child: Text(l.prev, style: const TextStyle(fontSize: 11)),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: (state.page + 1) * WalletBloc.pageSize < state.total
                              ? () => context
                                  .read<WalletBloc>()
                                  .add(WalletLoadRequested(page: state.page + 1, txnType: _filter))
                              : null,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(70, 32),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          child: Text(l.next, style: const TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
