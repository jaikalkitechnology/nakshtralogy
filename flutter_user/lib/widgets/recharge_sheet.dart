import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/app_mode.dart';
import '../utils/money.dart';
import '../utils/razorpay_checkout.dart';

/// Wallet recharge via a payment aggregator (Razorpay / PayU / PayPal).
/// Region-aware gateway list (India: PayU + Razorpay; International: + PayPal).
/// Opens the gateway's hosted checkout in the browser (works on web + mobile),
/// then polls the order until it's confirmed and refreshes the wallet.
Future<bool> showRechargeSheet(BuildContext context, {double? suggested}) async {
  final ok = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.card,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => _RechargeSheet(suggested: suggested),
  );
  return ok == true;
}

class _RechargeSheet extends StatefulWidget {
  final double? suggested;
  const _RechargeSheet({this.suggested});
  @override
  State<_RechargeSheet> createState() => _RechargeSheetState();
}

class _RechargeSheetState extends State<_RechargeSheet> {
  final _api = ApiService();
  final _amountCtrl = TextEditingController();
  bool _loading = true;
  bool _busy = false;
  String _currency = 'INR';
  List<Map<String, dynamic>> _gateways = [];
  String? _gateway;
  String? _status; // shown while polling
  Timer? _poll;

  static const _labels = {'razorpay': 'Razorpay', 'payu': 'PayU', 'paypal': 'PayPal'};

  @override
  void initState() {
    super.initState();
    if (widget.suggested != null && widget.suggested! > 0) {
      _amountCtrl.text = widget.suggested!.ceil().toString();
    }
    _load();
  }

  @override
  void dispose() {
    _poll?.cancel();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final r = await _api.getRechargeGateways();
    if (!mounted) return;
    setState(() {
      _currency = (r?['currency'] as String?) ?? (AppMode.instance.isInternational ? 'USD' : 'INR');
      _gateways = ((r?['gateways'] as List?) ?? []).map((e) => (e as Map).cast<String, dynamic>()).toList();
      _gateway = _gateways.isNotEmpty ? _gateways.first['gateway']?.toString() : null;
      _loading = false;
    });
  }

  Future<void> _pay() async {
    final amt = double.tryParse(_amountCtrl.text.trim()) ?? 0;
    if (amt <= 0 || _gateway == null) return;
    setState(() { _busy = true; _status = null; });
    final resp = await _api.createRechargeOrder(_gateway!, amt);
    if (!mounted) return;
    final ok = resp['statusCode'] == 200 || resp['statusCode'] == 201;
    if (!ok) {
      setState(() { _busy = false; _status = null; });
      _snack(resp['detail']?.toString() ?? 'Could not start payment', AppColors.error);
      return;
    }
    final checkout = (resp['checkout'] as Map?)?.cast<String, dynamic>() ?? {};
    final orderId = (resp['order'] as Map?)?['id']?.toString();
    final url = checkout['url']?.toString();

    // Preferred: native Razorpay Checkout — an in-app modal / in-page overlay
    // (no external browser). Falls back to the hosted link if unavailable.
    final rzpOrderId = checkout['razorpay_order_id']?.toString();
    final key = checkout['public_key']?.toString();
    if (_gateway == 'razorpay' && orderId != null &&
        rzpOrderId != null && rzpOrderId.isNotEmpty &&
        key != null && key.isNotEmpty) {
      try {
        final amountPaise = (checkout['amount_paise'] as num?)?.toInt()
            ?? (amt * 100).round();
        final result = await openRazorpayCheckout(RazorpayOptions(
          key: key, orderId: rzpOrderId, amountPaise: amountPaise,
          currency: checkout['currency']?.toString() ?? _currency,
        ));
        if (!mounted) return;
        if (result.success) {
          setState(() => _status = 'Confirming payment…');
          // Verify (credits immediately); the webhook also credits — idempotent.
          await _api.verifyRecharge(
            gateway: 'razorpay', orderRef: orderId,
            gatewayOrderId: result.orderId ?? rzpOrderId,
            gatewayPaymentId: result.paymentId, signature: result.signature);
          _startPolling(orderId);
        } else {
          setState(() { _busy = false; _status = null; });
          if (!result.cancelled) {
            _snack(result.error ?? 'Payment failed', AppColors.error);
          }
        }
        return;
      } catch (_) {
        // Fall through to the hosted-link flow below.
      }
    }

    if (url == null || url.isEmpty) {
      // The server normally refuses (502 + reason) before we get here.
      setState(() => _busy = false);
      _snack(checkout['error'] != null
          ? 'Could not open the payment page. Please try another payment method.'
          : 'This payment method is not available right now. Please try another.', AppColors.error);
      return;
    }
    // Fallback: open the hosted checkout, then poll the order until confirmed.
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (orderId != null) _startPolling(orderId);
  }

  void _startPolling(String orderId) {
    setState(() => _status = 'Waiting for payment confirmation…');
    int ticks = 0;
    _poll = Timer.periodic(const Duration(seconds: 4), (t) async {
      ticks++;
      final st = await _api.getRechargeOrderStatus(orderId);
      if (!mounted) { t.cancel(); return; }
      if (st == 'paid') {
        t.cancel();
        _snack('Wallet recharged successfully', AppColors.success);
        Navigator.pop(context, true);
      } else if (st == 'failed' || ticks > 60) {
        t.cancel();
        setState(() { _busy = false; _status = st == 'failed' ? 'Payment failed' : null; });
        if (st == 'failed') _snack('Payment failed or cancelled', AppColors.error);
      }
    });
  }

  void _snack(String msg, Color c) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg), backgroundColor: c));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: _loading
          ? const Padding(padding: EdgeInsets.all(30), child: Center(child: CircularProgressIndicator(color: AppColors.gold)))
          : Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Add money to wallet', style: TextStyle(color: AppColors.ivory, fontSize: 17, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              TextField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                enabled: !_busy,
                style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  prefixText: '${Money.symbol(_currency)} ',
                  prefixStyle: const TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.w700),
                  labelText: 'Amount',
                  labelStyle: const TextStyle(color: AppColors.smoke),
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.smoke)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.gold)),
                ),
              ),
              const SizedBox(height: 16),
              if (_gateways.isEmpty)
                const Text('No payment methods available right now. Please try again later.',
                    style: TextStyle(color: AppColors.error, fontSize: 12))
              else ...[
                const Text('Pay using', style: TextStyle(color: AppColors.smoke, fontSize: 12)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: _gateways.map((g) {
                  final code = g['gateway']?.toString() ?? '';
                  final sel = _gateway == code;
                  return ChoiceChip(
                    label: Text(_labels[code] ?? code, style: TextStyle(color: sel ? AppColors.midnight : AppColors.ivory, fontWeight: FontWeight.w700)),
                    selected: sel, selectedColor: AppColors.gold, backgroundColor: AppColors.nebula,
                    onSelected: _busy ? null : (_) => setState(() => _gateway = code),
                  );
                }).toList()),
              ],
              if (_status != null) Padding(padding: const EdgeInsets.only(top: 12),
                child: Row(children: [
                  const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_status!, style: const TextStyle(color: AppColors.smoke, fontSize: 12))),
                ])),
              const SizedBox(height: 18),
              SizedBox(width: double.infinity, height: 48, child: ElevatedButton(
                onPressed: (_busy || _gateways.isEmpty) ? null : _pay,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.midnight),
                child: _busy && _status == null
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.midnight))
                    : const Text('Proceed to pay', style: TextStyle(fontWeight: FontWeight.w800)),
              )),
              const SizedBox(height: 6),
              const Center(child: Text('Secured by your selected payment provider',
                  style: TextStyle(color: AppColors.smoke, fontSize: 10.5))),
            ]),
    );
  }
}
