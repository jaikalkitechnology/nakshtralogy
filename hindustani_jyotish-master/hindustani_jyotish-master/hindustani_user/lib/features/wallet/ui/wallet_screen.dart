import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/responsive.dart';
import '../wallet_checkout.dart';
import '../wallet_repository.dart';

typedef _WalletCubit = DataCubit<Wallet>;

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  static const _quick = ['100', '500', '1000', '2000'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<_WalletCubit>(
      create: (_) => DataCubit(getIt<WalletRepository>().getWallet)..load(),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatefulWidget {
  const _WalletView();

  @override
  State<_WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<_WalletView> {
  final _customController = TextEditingController();
  bool _processing = false;

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  Future<void> _rechargeCustom() async {
    final amount = int.tryParse(_customController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).walletEnterValidAmount)),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    await _recharge(amount);
    if (mounted) _customController.clear();
  }

  Future<void> _recharge(int amount) async {
    if (_processing) return;
    setState(() => _processing = true);

    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final cubit = context.read<_WalletCubit>();
    final auth = context.read<AuthCubit>();
    final user = auth.state.user;

    try {
      final txn = await getIt<WalletCheckout>().recharge(
        amountRupees: amount,
        name: user?.name,
        email: user?.email,
        contact: user?.mobile,
      );

      await auth.refreshMe();
      await cubit.refresh();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l.walletAddedToWallet(txn.amount.replaceAll('-', '')),
          ),
        ),
      );
    } on RechargeCancelled catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: CenteredMaxWidth(
        maxWidth: Responsive.readableMaxWidth,
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.saffron,
              onRefresh: () => context.read<_WalletCubit>().refresh(),
              child: BlocBuilder<_WalletCubit, DataState<Wallet>>(
                builder: (context, state) {
                  final w = state.dataOrNull;
                  if (w == null) {
                    final err = state.errorMessage;
                    return ListView(
                      children: [
                        const SizedBox(height: 200),
                        Center(
                          child: err != null
                              ? Text(
                                  err,
                                  style: AppTextStyles.body(
                                    color: AppColors.danger,
                                  ),
                                )
                              : const CircularProgressIndicator(
                                  color: AppColors.saffron,
                                ),
                        ),
                      ],
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    children: [
                      Text(l.walletTitle, style: AppTextStyles.display(size: 24)),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: AppColors.heroGradient,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.borderMid),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.goldHalo,
                              blurRadius: 26,
                              spreadRadius: -8,
                              offset: Offset(0, 10),
                            ),
                            BoxShadow(
                              color: AppColors.shadowSoft,
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: AppColors.goldLight,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  l.walletBalance,
                                  style: AppTextStyles.label(
                                    color: AppColors.ivoryDim,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹${w.balance}',
                              style: AppTextStyles.display(
                                size: 38,
                                weight: FontWeight.w700,
                                color: AppColors.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l.walletQuickRecharge,
                        style: AppTextStyles.heading(size: 16),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final amt in WalletScreen._quick)
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.borderMid,
                                ),
                                foregroundColor: AppColors.ivory,
                              ),
                              onPressed: _processing
                                  ? null
                                  : () => _recharge(int.parse(amt)),
                              child: Text('₹$amt'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _customController,
                              enabled: !_processing,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: AppTextStyles.body(),
                              decoration: InputDecoration(
                                prefixText: '₹ ',
                                prefixStyle: AppTextStyles.body(
                                  color: AppColors.gold,
                                ),
                                hintText: l.walletCustomAmount,
                                hintStyle: AppTextStyles.body(
                                  color: AppColors.ivoryFaint,
                                ),
                                filled: true,
                                fillColor: AppColors.surface1,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.borderSoft,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.saffron,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 56,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.saffron,
                                foregroundColor: AppColors.indigoVoid,
                              ),
                              onPressed: _processing ? null : _rechargeCustom,
                              child: Text(l.commonAdd),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l.walletRecentTransactions,
                        style: AppTextStyles.heading(size: 16),
                      ),
                      const SizedBox(height: 8),
                      if (w.transactions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            l.walletNoTransactions,
                            style: AppTextStyles.body(
                              color: AppColors.ivoryFaint,
                            ),
                          ),
                        )
                      else
                        for (final t in w.transactions) _TxnRow(txn: t),
                    ],
                  );
                },
              ),
            ),
            if (_processing)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x99000000),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.saffron),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TxnRow extends StatelessWidget {
  const _TxnRow({required this.txn});
  final WalletTransaction txn;

  String _dateLabel() {
    final d = DateTime.tryParse(txn.createdAt)?.toLocal();
    if (d == null) return '';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} · ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final credit = txn.isCredit;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(
        children: [
          Icon(
            credit ? Icons.south_west : Icons.north_east,
            color: credit ? AppColors.success : AppColors.copperLight,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.type.replaceAll('_', ' '),
                  style: AppTextStyles.body(size: 14, weight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  _dateLabel(),
                  style: AppTextStyles.mono(size: 11, color: AppColors.ivoryFaint),
                ),
              ],
            ),
          ),
          Text(
            '${credit ? '+' : ''}₹${txn.amount}',
            style: AppTextStyles.mono(
              size: 13,
              color: credit ? AppColors.success : AppColors.ivory,
            ),
          ),
        ],
      ),
    );
  }
}
