import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/premium_ui.dart';
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
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                    children: [
                      Text(l.walletTitle, style: AppTextStyles.display(size: 26)),
                      const SizedBox(height: 18),
                      HeroGradientCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const IconTile(
                                  Icons.account_balance_wallet_outlined,
                                  tone: TileTone.gold,
                                  size: 38,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  l.walletBalance,
                                  style: AppTextStyles.label(
                                    size: 12.5,
                                    color: AppColors.ivoryDim,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '₹${w.balance}',
                              style: AppTextStyles.display(
                                size: 46,
                                weight: FontWeight.w700,
                                color: AppColors.success,
                              ).copyWith(
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SectionLabel(l.walletQuickRecharge),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final amt in WalletScreen._quick)
                            PremiumCard(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 14,
                              ),
                              onTap: _processing
                                  ? null
                                  : () => _recharge(int.parse(amt)),
                              child: Text(
                                '₹$amt',
                                style: AppTextStyles.body(
                                  size: 15,
                                  weight: FontWeight.w700,
                                  color: AppColors.gold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _customController,
                        enabled: !_processing,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: AppTextStyles.body(size: 15),
                        decoration: InputDecoration(
                          prefixText: '₹ ',
                          prefixStyle: AppTextStyles.body(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AppColors.gold,
                          ),
                          hintText: l.walletCustomAmount,
                          hintStyle: AppTextStyles.body(
                            color: AppColors.ivoryFaint,
                          ),
                          filled: true,
                          fillColor: AppColors.surface2,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: AppColors.borderSoft,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: AppColors.saffron,
                              width: 1.5,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: AppColors.borderSoft,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      PremiumPrimaryButton(
                        label: l.commonAdd,
                        icon: Icons.add_rounded,
                        onPressed: _processing ? null : _rechargeCustom,
                      ),
                      SectionLabel(
                        l.walletRecentTransactions,
                        trailing: w.transactions.isEmpty
                            ? null
                            : StatusChip(
                                '${w.transactions.length}',
                                tone: ChipTone.muted,
                              ),
                      ),
                      if (w.transactions.isEmpty)
                        PremiumCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 28,
                          ),
                          child: Column(
                            children: [
                              const IconTile(
                                Icons.receipt_long_outlined,
                                tone: TileTone.gold,
                                size: 52,
                              ),
                              const SizedBox(height: 14),
                              Text(
                                l.walletNoTransactions,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body(
                                  color: AppColors.ivoryDim,
                                ),
                              ),
                            ],
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            IconTile(
              credit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              tone: credit ? TileTone.gold : TileTone.saffron,
              size: 42,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn.type.replaceAll('_', ' '),
                    style: AppTextStyles.body(
                      size: 14.5,
                      weight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _dateLabel(),
                    style: AppTextStyles.mono(
                      size: 11,
                      color: AppColors.ivoryFaint,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${credit ? '+' : ''}₹${txn.amount}',
              style: AppTextStyles.mono(
                size: 14,
                weight: FontWeight.w700,
                color: credit ? AppColors.success : AppColors.ivory,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
