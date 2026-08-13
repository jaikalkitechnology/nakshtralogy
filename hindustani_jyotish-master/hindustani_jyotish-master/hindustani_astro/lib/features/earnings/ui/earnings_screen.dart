import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.indigoSoft, AppColors.indigoMid, AppColors.indigoDeep],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderMid),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.account_balance_wallet_outlined,
                        size: 18, color: AppColors.gold),
                  ),
                  const SizedBox(width: 10),
                  Text('Available balance', style: AppTextStyles.label(color: AppColors.ivoryDim)),
                ],
              ),
              const SizedBox(height: 12),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child:
                    Text('₹$available', style: AppTextStyles.display(size: 34, color: AppColors.success)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _row('This month', '₹${d['this_month_earnings']}', icon: Icons.calendar_month_outlined),
        _row('Lifetime', '₹${d['lifetime_earnings']}', icon: Icons.timeline_outlined),
        _row('Consults this month', '${d['consultations_this_month']}', icon: Icons.support_agent),
        const SizedBox(height: 24),
        ElevatedButton.icon(
      // Explicit full width: the shared theme no longer forces an
      // (invalid) infinite minimum width on every ElevatedButton.
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          onPressed: () => _withdraw(context, available),
          icon: const Icon(Icons.account_balance_wallet_outlined),
          label: const Text('Withdraw'),
        ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(String label, String value, {IconData? icon}) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.copperLight.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: AppColors.copperLight),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
            ),
            const SizedBox(width: 12),
            Text(value, style: AppTextStyles.body(size: 15, weight: FontWeight.w700)),
          ],
        ),
      );
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
