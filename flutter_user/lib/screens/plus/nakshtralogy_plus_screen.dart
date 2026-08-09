import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/money.dart';
import '../../utils/plus_labels.dart';
import '../../utils/coupon_labels.dart';
import '../../widgets/recharge_sheet.dart';

/// NakshtralogyPlus — all-access membership plans (7 / 15 / 30 days).
/// Region-priced (₹ India / $ international). Optional coupon (discount or
/// 100% free). Subscribes via the wallet; offers Add money when short.
class NakshtralogyPlusScreen extends StatefulWidget {
  const NakshtralogyPlusScreen({super.key});

  @override
  State<NakshtralogyPlusScreen> createState() => _NakshtralogyPlusScreenState();
}

class _NakshtralogyPlusScreenState extends State<NakshtralogyPlusScreen> {
  final _api = ApiService();
  bool _loading = true;
  bool _busy = false;
  List<Map<String, dynamic>> _plans = [];
  Map<String, dynamic>? _current;
  String _currency = 'INR';
  int _selected = 0;

  final _couponCtrl = TextEditingController();
  String? _couponCode;
  double _couponDiscount = 0; // ₹ off the selected plan
  String? _couponMsg;
  bool _couponOk = false;
  bool _couponBusy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _couponCtrl.dispose();
    super.dispose();
  }

  String _L(String k) => PlusLabels.of(context, k);

  Future<void> _load() async {
    final r = await _api.getPlusPlans();
    if (!mounted) return;
    setState(() {
      _plans = ((r?['plans'] as List?) ?? []).cast<Map<String, dynamic>>();
      _current = (r?['current'] as Map?)?.cast<String, dynamic>();
      _currency = (r?['currency'] as String?) ?? 'INR';
      // default to the middle/best-value plan when present
      _selected = _plans.length >= 2 ? 1 : 0;
      _loading = false;
    });
  }

  Map<String, dynamic>? get _plan =>
      (_selected >= 0 && _selected < _plans.length) ? _plans[_selected] : null;

  double get _basePrice => ((_plan?['price'] as num?)?.toDouble() ?? 0);
  double get _netPrice => (_basePrice - _couponDiscount).clamp(0, double.infinity).toDouble();
  bool get _isIntl => _currency.toUpperCase() == 'USD';

  String _priceLabel(Map<String, dynamic> p) {
    final amt = (p['session_amount'] as num?)?.toDouble() ?? (p['price'] as num?)?.toDouble() ?? 0;
    return Money.format(amt, currency: _currency, decimals: _isIntl ? 2 : 0);
  }

  Future<void> _applyCoupon() async {
    final code = _couponCtrl.text.trim();
    final plan = _plan;
    if (code.isEmpty || plan == null) return;
    setState(() { _couponBusy = true; _couponMsg = null; });
    final r = await _api.validateCoupon(
      code: code, scope: 'product', serviceKey: plan['code']?.toString(),
      baseAmount: _basePrice);
    if (!mounted) return;
    if (r['valid'] == true) {
      setState(() {
        _couponCode = code;
        _couponDiscount = (r['discount_amount'] as num?)?.toDouble() ?? 0;
        _couponOk = true; _couponBusy = false;
        _couponMsg = CouponLabels.of(context, 'applied');
      });
    } else {
      setState(() {
        _couponCode = null; _couponDiscount = 0; _couponOk = false; _couponBusy = false;
        _couponMsg = CouponLabels.of(context, 'reason_${r['reason'] ?? 'invalid'}');
      });
    }
  }

  Future<void> _subscribe() async {
    final plan = _plan;
    if (plan == null) return;
    setState(() => _busy = true);
    final resp = await _api.purchasePlus(plan['code'].toString(), couponCode: _couponCode);
    if (!mounted) return;
    final code = resp['statusCode'];
    if (code == 200) {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(resp['message']?.toString() ?? _L('activated')), backgroundColor: AppColors.success));
      _couponCode = null; _couponDiscount = 0; _couponCtrl.clear(); _couponMsg = null; _couponOk = false;
      await _load();
    } else if (code == 402) {
      // Low wallet — offer to add money (India), then retry.
      setState(() => _busy = false);
      final recharged = await showRechargeSheet(context, suggested: _netPrice);
      if (recharged == true && mounted) _subscribe();
    } else {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(resp['detail']?.toString() ?? 'Failed'), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _current?['active'] == true;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.ivory),
        title: Text(_L('plus'), style: const TextStyle(color: AppColors.ivory, fontWeight: FontWeight.w700)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                _hero(active),
                const SizedBox(height: 18),
                if (_plans.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: Text('Plans coming soon.', style: TextStyle(color: AppColors.smoke))),
                  )
                else ...[
                  Text(_L('choosePlan'), style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
                  const SizedBox(height: 8),
                  ...List.generate(_plans.length, (i) => _planCard(i)),
                  const SizedBox(height: 14),
                  _couponField(),
                  const SizedBox(height: 14),
                  _benefits(),
                  const SizedBox(height: 18),
                  _cta(active),
                  const SizedBox(height: 10),
                  Text(_L('excluded'), textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
                  const SizedBox(height: 24),
                ],
              ]),
            ),
    );
  }

  Widget _hero(bool active) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.18), AppColors.nebula.withOpacity(0.5)]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold.withOpacity(0.4)),
      ),
      child: Row(children: [
        const Text('✨', style: TextStyle(fontSize: 34)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_L('plus'), style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          if (active)
            Text('${_L('memberUntil')} ${_fmtDate(_current?['expires_at'])} · ${_current?['days_left'] ?? 0} ${_L('daysLeft')}',
                style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600))
          else
            Text(_L('notMember'), style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
        ])),
      ]),
    );
  }

  Widget _planCard(int i) {
    final p = _plans[i];
    final sel = i == _selected;
    final days = (p['duration_days'] as num?)?.toInt() ?? 0;
    final amt = (p['session_amount'] as num?)?.toDouble() ?? 0;
    final perDay = days > 0 ? amt / days : amt;
    final strike = (p['original_price'] as num?)?.toDouble();
    final best = _plans.length >= 3 && i == 1; // middle plan = best value
    return GestureDetector(
      onTap: () => setState(() { _selected = i; _couponCode = null; _couponDiscount = 0; _couponMsg = null; _couponOk = false; _couponCtrl.clear(); }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: sel ? AppColors.gold.withOpacity(0.12) : AppColors.nebula.withOpacity(0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: sel ? AppColors.gold : AppColors.gold.withOpacity(0.15), width: sel ? 1.5 : 1),
        ),
        child: Row(children: [
          Icon(sel ? Icons.radio_button_checked : Icons.radio_button_off, color: sel ? AppColors.gold : AppColors.smoke, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('${p['icon'] ?? ''} $days ${_L('days')}',
                  style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700)),
              if (best) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(6)),
                  child: Text(_L('bestValue'), style: const TextStyle(color: AppColors.midnight, fontSize: 8, fontWeight: FontWeight.w900)),
                ),
              ],
            ]),
            const SizedBox(height: 2),
            Text('${Money.format(perDay, currency: _currency, decimals: _isIntl ? 2 : 0)}${_L('perDay')}',
                style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(_priceLabel(p), style: const TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.w800)),
            if (strike != null && strike > 0)
              Text(Money.format(_isIntl ? (strike * 5 / 83) : strike, currency: _currency, decimals: _isIntl ? 2 : 0),
                  style: const TextStyle(color: AppColors.smoke, fontSize: 11, decoration: TextDecoration.lineThrough)),
          ]),
        ]),
      ),
    );
  }

  Widget _couponField() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.nebula.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: (_couponOk ? AppColors.success : AppColors.gold.withOpacity(0.15))),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.local_activity_outlined, color: AppColors.gold, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _couponCtrl,
              enabled: _couponCode == null && !_couponBusy,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(color: AppColors.ivory, fontSize: 13),
              decoration: InputDecoration(
                isDense: true, border: InputBorder.none,
                hintText: CouponLabels.of(context, 'enterCode'),
                hintStyle: const TextStyle(color: AppColors.smoke, fontSize: 12),
              ),
            ),
          ),
          _couponCode == null
              ? TextButton(
                  onPressed: _couponBusy ? null : _applyCoupon,
                  child: _couponBusy
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold))
                      : Text(CouponLabels.of(context, 'apply'), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)))
              : TextButton(
                  onPressed: () => setState(() { _couponCode = null; _couponDiscount = 0; _couponMsg = null; _couponOk = false; _couponCtrl.clear(); }),
                  child: Text(CouponLabels.of(context, 'remove'), style: const TextStyle(color: AppColors.smoke))),
        ]),
        if (_couponMsg != null)
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 2),
            child: Text(
              _couponOk ? '${CouponLabels.of(context, 'applied')} · −${Money.format(_couponDiscount, currency: 'INR')}' : _couponMsg!,
              style: TextStyle(color: _couponOk ? AppColors.success : AppColors.error, fontSize: 11)),
          ),
      ]),
    );
  }

  Widget _benefits() {
    final items = ['b1', 'b2', 'b3', 'b4', 'b5'];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.nebula.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withOpacity(0.12)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_L('benefitsTitle'), style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
        const SizedBox(height: 8),
        ...items.map((k) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(children: [
                const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(_L(k), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5))),
              ]),
            )),
      ]),
    );
  }

  Widget _cta(bool active) {
    final isFree = _couponCode != null && _netPrice <= 0;
    final label = isFree
        ? '${_L(active ? 'renew' : 'subscribe')} · ${_L('free')}'
        : '${_L(active ? 'renew' : 'subscribe')} · ${Money.format(_isIntl ? _basePriceUsdNet() : _netPrice, currency: _currency, decimals: _isIntl ? 2 : 0)}';
    return SizedBox(
      width: double.infinity, height: 52,
      child: ElevatedButton(
        onPressed: _busy || _plan == null ? null : _subscribe,
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.midnight),
        child: _busy
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.midnight))
            : Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
      ),
    );
  }

  // Display-only USD of the net (coupon is a ₹ discount; convert for the label).
  double _basePriceUsdNet() {
    final p = _plan;
    final usd = (p?['session_amount'] as num?)?.toDouble() ?? 0;
    if (_basePrice <= 0) return usd;
    final ratio = _netPrice / _basePrice;
    return usd * ratio;
  }

  String _fmtDate(dynamic iso) {
    if (iso == null) return '';
    try {
      final d = DateTime.parse(iso.toString());
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return '';
    }
  }
}
