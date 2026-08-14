import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/premium_ui.dart';
import '../../../shared/responsive.dart';
import '../../portal/portal_repository.dart';

typedef _EarningsCubit = DataCubit<Map<String, dynamic>>;

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<_EarningsCubit>(
      create: (_) => DataCubit(getIt<PortalRepository>().earnings)..load(),
      child: const _EarningsView(),
    );
  }
}

class _EarningsView extends StatelessWidget {
  const _EarningsView();

  /// Opens the withdraw sheet for the astrologer's REGISTERED payout method
  /// (from `GET /astrologer/kyc/status`): UPI shows their UPI ID, bank shows
  /// the bank name (+ masked account digits when available). Without a payout
  /// method on file, points them to KYC payout details instead.
  Future<void> _withdraw(BuildContext context, String available) async {
    final cubit = context.read<_EarningsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final Map<String, dynamic> kyc;
    try {
      kyc = await getIt<PortalRepository>().kycStatus();
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      return;
    }
    if (!context.mounted) return;
    final method = kyc['payout_method'] as String?;
    if (method != 'upi' && method != 'bank') {
      messenger.showSnackBar(const SnackBar(
        content: Text(
            'Add your payout details (UPI or bank account) in KYC before withdrawing.'),
      ));
      return;
    }
    final amount = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.indigoDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _WithdrawSheet(kyc: kyc, available: available),
    );
    if (amount == null || amount.isEmpty) return;
    try {
      final res = await getIt<PortalRepository>().requestPayout(amount);
      messenger.showSnackBar(SnackBar(content: Text('Payout ${res['status']} · ₹${res['amount']}')));
      await cubit.refresh();
    } on ApiException catch (e) {
      // Server-side messages (₹500 minimum, "Your previous withdrawal request
      // is still pending.", balance checks) surface verbatim.
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<_EarningsCubit, DataState<Map<String, dynamic>>>(
        builder: (context, state) {
          final d = state.dataOrNull;
          return RefreshIndicator(
            onRefresh: () => context.read<_EarningsCubit>().refresh(),
            color: AppColors.saffron,
            child: d == null
                ? _initial(state)
                : _content(context, d),
          );
        },
      ),
    );
  }

  Widget _initial(DataState<Map<String, dynamic>> state) {
    final err = state.errorMessage;
    if (err != null) {
      return ListView(children: [
        const SizedBox(height: 160),
        Center(child: Text(err, style: AppTextStyles.body(color: AppColors.danger))),
      ]);
    }
    return const Center(child: CircularProgressIndicator(color: AppColors.saffron));
  }

  Widget _content(BuildContext context, Map<String, dynamic> d) {
    final available = '${d['available_balance']}';
    final l = AppLocalizations.of(context);
    final panOnFile = d['pan_on_file'] != false; // default true if absent
    final tdsRate = ((d['tds_rate'] as num?) ?? 0) * 100;
    final tdsRateLabel = tdsRate % 1 == 0
        ? tdsRate.toStringAsFixed(0)
        : tdsRate.toStringAsFixed(1);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        CenteredMaxWidth(
          maxWidth: 640,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
        Text('Earnings', style: AppTextStyles.display(size: 24)),
        const SizedBox(height: 16),
        if (!panOnFile) ...[
          _panBanner(context, l),
          const SizedBox(height: 16),
        ],
        HeroGradientCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const IconTile(Icons.account_balance_wallet_outlined, size: 30),
                  const SizedBox(width: 10),
                  Text('Available balance',
                      style: AppTextStyles.label(color: AppColors.goldLight)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text('₹$available',
                          style: AppTextStyles.display(size: 40, color: AppColors.success)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Sparkline([2, 3.2, 2.8, 4.4, 3.8, 5.6, 5.1, 7]),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.trending_up, size: 15, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text('+₹${d['this_month_earnings']} this month',
                      style: AppTextStyles.label(
                          size: 12, weight: FontWeight.w700, color: AppColors.success)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _statTile('This month', '₹${d['this_month_earnings']}',
                  Icons.calendar_month_outlined,
                  money: true),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statTile('Lifetime', '₹${d['lifetime_earnings']}',
                  Icons.timeline_outlined),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _statTile('Consults this month', '${d['consultations_this_month']}',
            Icons.support_agent,
            tone: TileTone.saffron, wide: true),
        const SizedBox(height: 22),
        PremiumPrimaryButton(
          label: 'Withdraw earnings',
          icon: Icons.arrow_upward_rounded,
          onPressed: () => _withdraw(context, available),
        ),
        if (panOnFile && tdsRate > 0) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.info_outline,
                  size: 14, color: AppColors.gold.withValues(alpha: 0.8)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l.earningsTdsNote(tdsRateLabel),
                  style: AppTextStyles.label(size: 11, color: AppColors.ivoryFaint),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        _PayoutsSection(l: l),
            ],
          ),
        ),
      ],
    );
  }

  /// PAN-missing prompt — payouts are blocked without a valid PAN. Taps through
  /// to the bank & PAN details screen (Phase E) where the PAN is entered.
  Widget _panBanner(BuildContext context, AppLocalizations l) => InkWell(
        onTap: () => context.push('/profile/bank-pan'),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.danger.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.badge_outlined, size: 20, color: AppColors.danger),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.earningsAddPanTitle,
                        style: AppTextStyles.body(size: 14, weight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(l.earningsAddPanBody,
                        style: AppTextStyles.label(size: 12, color: AppColors.ivoryDim)),
                    const SizedBox(height: 8),
                    Text(l.earningsAddPanAction,
                        style: AppTextStyles.body(
                            size: 13,
                            weight: FontWeight.w700,
                            color: AppColors.saffron)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.ivoryFaint),
            ],
          ),
        ),
      );

  /// Premium stat tile: a compact card with an uppercase label, an icon tile,
  /// and a large (optionally money-green) value. [wide] lays it out as a single
  /// full-width row; otherwise it's a square-ish cell for a 2-up grid.
  Widget _statTile(String label, String value, IconData icon,
      {TileTone tone = TileTone.gold, bool money = false, bool wide = false}) {
    final valueText = Text(value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.display(
            size: 20, color: money ? AppColors.success : AppColors.ivory));
    final labelText = Text(label.toUpperCase(),
        style: AppTextStyles.label(size: 10.5, color: AppColors.ivoryFaint));
    if (wide) {
      return PremiumCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [labelText, const SizedBox(height: 6), valueText],
              ),
            ),
            IconTile(icon, tone: tone),
          ],
        ),
      );
    }
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [labelText, IconTile(icon, tone: tone, size: 28)],
          ),
          const SizedBox(height: 10),
          valueText,
        ],
      ),
    );
  }
}

/// Recent withdrawals with the TDS deducted and net paid per payout, so the
/// astrologer sees exactly what reached their bank. Loads `GET
/// /astrologer/payouts` once; failures fall back silently (the section hides).
class _PayoutsSection extends StatefulWidget {
  const _PayoutsSection({required this.l});
  final AppLocalizations l;

  @override
  State<_PayoutsSection> createState() => _PayoutsSectionState();
}

class _PayoutsSectionState extends State<_PayoutsSection> {
  final Future<List<Map<String, dynamic>>> _future =
      getIt<PortalRepository>().payouts();

  String _money(dynamic v) {
    final n = double.tryParse('${v ?? 0}') ?? 0;
    return n.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.l;
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }
        final payouts = snap.data ?? const [];
        if (payouts.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.earningsRecentPayouts,
                style: AppTextStyles.heading(size: 16)),
            const SizedBox(height: 12),
            ...payouts.take(10).map((p) => _payoutTile(l, p)),
          ],
        );
      },
    );
  }

  Widget _payoutTile(AppLocalizations l, Map<String, dynamic> p) {
    final gross = _money(p['amount']);
    final tds = _money(p['tds_amount']);
    final net = _money(p['net_paid'] ?? p['amount']);
    final status = '${p['status'] ?? ''}';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${l.earningsPayoutGross}: ₹$gross',
                  style: AppTextStyles.body(size: 14, weight: FontWeight.w700)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.copperLight.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status,
                    style: AppTextStyles.label(
                        size: 10, color: AppColors.copperLight)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text('${l.earningsPayoutTds}: −₹$tds',
                    style: AppTextStyles.label(
                        size: 12, color: AppColors.danger)),
              ),
              Expanded(
                child: Text('${l.earningsPayoutNet}: ₹$net',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.body(
                        size: 13,
                        weight: FontWeight.w700,
                        color: AppColors.success)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Amount entry for a withdrawal, headed by the astrologer's registered payout
/// destination (UPI ID or bank name + masked account). Pops the entered amount
/// string once it passes the client-side ₹500 minimum; the server re-validates
/// everything else.
class _WithdrawSheet extends StatefulWidget {
  const _WithdrawSheet({required this.kyc, required this.available});

  /// Raw `GET /astrologer/kyc/status` payload — `payout_method` is guaranteed
  /// "upi" or "bank" by the caller.
  final Map<String, dynamic> kyc;
  final String available;

  @override
  State<_WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends State<_WithdrawSheet> {
  static const _minWithdrawal = 500;

  late final TextEditingController _amount =
      TextEditingController(text: widget.available);
  String? _error;

  bool get _isUpi => widget.kyc['payout_method'] == 'upi';

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  /// "Bank name · A/C ••••1234" (whichever parts are on file), or the UPI ID.
  String get _destination {
    if (_isUpi) return (widget.kyc['upi_id'] as String?) ?? '';
    final bankName = (widget.kyc['bank_name'] as String?) ?? '';
    final last4 = (widget.kyc['bank_account_last4'] as String?) ?? '';
    return [
      if (bankName.isNotEmpty) bankName,
      if (last4.isNotEmpty) 'A/C ••••$last4',
    ].join(' · ');
  }

  void _submit() {
    final raw = _amount.text.trim();
    final value = double.tryParse(raw);
    if (value == null) {
      setState(() => _error = 'Enter a valid amount');
      return;
    }
    if (value < _minWithdrawal) {
      setState(() => _error = 'Minimum withdrawal is ₹$_minWithdrawal');
      return;
    }
    Navigator.pop(context, raw);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Keep the field above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(_isUpi ? 'Withdraw to UPI' : 'Withdraw to bank',
                  style: AppTextStyles.heading(size: 18)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface1,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Row(
                  children: [
                    Icon(_isUpi ? Icons.qr_code_2 : Icons.account_balance_outlined,
                        size: 20, color: AppColors.copperLight),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _destination.isEmpty
                            ? (_isUpi ? 'UPI' : 'Bank account')
                            : _destination,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body(size: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amount,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                decoration: InputDecoration(labelText: 'Amount (₹)', errorText: _error),
              ),
              const SizedBox(height: 8),
              Text('Minimum withdrawal: ₹$_minWithdrawal',
                  style: AppTextStyles.label(size: 11, color: AppColors.ivoryFaint)),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                onPressed: _submit,
                child: const Text('Withdraw'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
