import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../services/app_mode.dart';
import '../../services/iap_service.dart';
import '../../utils/money.dart';
import '../../utils/coupon_labels.dart';

/// Reusable pay-per-report paywall for flutter_user.
///
/// PRESENTATION + ACCESS ONLY — it never computes or alters a report. It wraps
/// an already-built report screen: it asks the backend whether this
/// `serviceKey` is unlocked for `chartId` (GET /service/entitlements), and only
/// builds the wrapped screen (which runs the engine) once the user is entitled
/// — either because the service is free, already purchased, or just unlocked
/// here via the existing atomic /service/purchase wallet debit.
///
/// Prices are ALWAYS read from ServicePricing (admin-editable) — never
/// hardcoded here.
class PaywallGate extends StatefulWidget {
  /// ServicePricing.service_key that gates this report (e.g. "career").
  final String serviceKey;

  /// Chart the unlock applies to. For two-chart reports pass the first chart.
  final String chartId;

  /// Human report name for the "Unlock full X" copy.
  final String reportName;

  /// Emoji shown on the locked hero (falls back to the pricing row's icon).
  final String emoji;

  /// Built lazily — ONLY after the user is entitled, so the engine call inside
  /// never runs (and never 402s) behind the paywall.
  final WidgetBuilder builder;

  const PaywallGate({
    super.key,
    required this.serviceKey,
    required this.chartId,
    required this.reportName,
    required this.builder,
    this.emoji = '🔒',
  });

  @override
  State<PaywallGate> createState() => _PaywallGateState();
}

enum _GateState { loading, locked, unlocked }

class _PaywallGateState extends State<PaywallGate> {
  final _api = ApiService();
  _GateState _state = _GateState.loading;
  Map<String, dynamic>? _pricing; // full ServicePricing row for the locked card
  String? _error;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    setState(() { _state = _GateState.loading; _error = null; });
    try {
      // 1) already unlocked (free / purchased / privileged)?
      final ent = await _api.getEntitlement(widget.serviceKey, chartId: widget.chartId);
      if (!mounted) return;
      if (ent != null && ent['unlocked'] == true) {
        setState(() => _state = _GateState.unlocked);
        return;
      }
      // 2) locked — pull the admin-editable pricing row for the card.
      final pricing = await _api.getServicePricingByKey(widget.serviceKey);
      if (!mounted) return;
      if (pricing == null) {
        // No priced row → fail-open (mirrors backend). Show the report.
        setState(() => _state = _GateState.unlocked);
        return;
      }
      final price = (pricing['price'] as num?)?.toDouble() ?? 0;
      final isFree = pricing['is_free'] == true || price == 0;
      setState(() {
        _pricing = pricing;
        _state = isFree ? _GateState.unlocked : _GateState.locked;
      });
    } catch (e) {
      if (!mounted) return;
      // On a transient error, don't hard-block — let the wrapped screen load
      // (the backend 402 gate is still the real enforcement).
      setState(() { _error = e.toString(); _state = _GateState.unlocked; });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case _GateState.unlocked:
        return widget.builder(context);
      case _GateState.loading:
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            const CircularProgressIndicator(color: AppColors.gold),
            const SizedBox(height: 14),
            Text(AppLocalizations.of(context)?.pwLoadingAccess ?? 'Checking access…',
                style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
          ])),
        );
      case _GateState.locked:
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory),
                onPressed: () => Navigator.pop(context)),
            title: Text(widget.reportName,
                style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700)),
          ),
          body: ReportPaywallCard(
            pricing: _pricing!,
            chartId: widget.chartId,
            reportName: widget.reportName,
            emoji: widget.emoji,
            onUnlocked: () { if (mounted) setState(() => _state = _GateState.unlocked); },
          ),
        );
    }
  }
}

/// The locked "premium" card: teaser hero + one-time-unlock pitch + price +
/// wallet balance + Unlock (→ purchaseService) / Recharge (→ rechargeMyWallet).
class ReportPaywallCard extends StatefulWidget {
  final Map<String, dynamic> pricing;
  final String chartId;
  final String reportName;
  final String emoji;
  final VoidCallback onUnlocked;

  const ReportPaywallCard({
    super.key,
    required this.pricing,
    required this.chartId,
    required this.reportName,
    required this.onUnlocked,
    this.emoji = '🔒',
  });

  @override
  State<ReportPaywallCard> createState() => _ReportPaywallCardState();
}

class _ReportPaywallCardState extends State<ReportPaywallCard> {
  final _api = ApiService();
  double _balance = 0;
  bool _loadingBalance = true;
  bool _purchasing = false;

  // ── Coupon state ──────────────────────────────────────────────────
  final _couponCtrl = TextEditingController();
  bool _couponBusy = false;
  String? _couponCode;          // applied code
  double _couponDiscount = 0;   // INR discount on the product price
  String? _couponMsg;           // localized status message

  /// Effective INR price after any applied coupon.
  double get _effPrice => (_price - _couponDiscount).clamp(0, double.infinity).toDouble();
  bool get _couponFull => _couponCode != null && _effPrice <= 0;

  double get _price => (widget.pricing['price'] as num?)?.toDouble() ?? 0;
  double? get _orig => (widget.pricing['original_price'] as num?)?.toDouble();
  String get _pricingId => widget.pricing['id']?.toString() ?? '';
  List<String> get _features =>
      (widget.pricing['features_json'] as List?)?.map((e) => e.toString()).toList() ?? const [];

  /// Localized one-line product tagline from the backend card catalog
  /// (ServicePricing.description is overlaid per language). Falls back to the
  /// generic locked subtitle when a row carries no tagline.
  String _tagline(AppLocalizations l) {
    final d = (widget.pricing['description'] ?? '').toString().trim();
    return d.isNotEmpty ? d : l.pwLockedSubtitle;
  }

  // ── International (store IAP) vs India (wallet) ──────────────────────
  bool get _intl => AppMode.instance.isInternational;
  double get _usd =>
      (widget.pricing['price_usd'] as num?)?.toDouble() ??
      (widget.pricing['session_amount'] as num?)?.toDouble() ?? 0;
  String get _iapProductId => widget.pricing['iap_product_id']?.toString() ?? '';

  /// Currency-aware headline price for the current session.
  String get _displayPrice =>
      _intl ? Money.format(_usd, currency: 'USD') : Money.format(_price, currency: 'INR');

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  @override
  void dispose() {
    _couponCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadBalance() async {
    final b = await _api.getWalletBalance();
    if (!mounted) return;
    setState(() { _balance = b; _loadingBalance = false; });
  }

  /// Reason string for a coupon rejection code. Localized via CouponLabels
  /// (English base now; other locales filled in Phase 6).
  String _couponReason(String? reason) =>
      CouponLabels.of(context, 'reason_${reason ?? 'invalid'}');

  Future<void> _applyCoupon() async {
    final code = _couponCtrl.text.trim();
    if (code.isEmpty) return;
    setState(() { _couponBusy = true; _couponMsg = null; });
    final r = await _api.validateCoupon(
      code: code, scope: 'product',
      serviceKey: widget.pricing['service_key']?.toString(),
      baseAmount: _price,
    );
    if (!mounted) return;
    if (r['valid'] == true) {
      final disc = (r['discount_amount'] as num?)?.toDouble() ?? 0;
      final full = (_price - disc) <= 0;
      // International pays via the store (which owns pricing), so only a
      // full-cover (100%) coupon can apply for intl — it unlocks free via the
      // wallet grant path. Partial coupons apply on the India wallet flow.
      if (_intl && !full) {
        setState(() {
          _couponCode = null; _couponDiscount = 0;
          _couponMsg = CouponLabels.of(context, 'reason_not_applicable');
          _couponBusy = false;
        });
        return;
      }
      setState(() {
        _couponCode = code;
        _couponDiscount = disc;
        _couponMsg = CouponLabels.of(context, 'applied');
        _couponBusy = false;
      });
    } else {
      setState(() {
        _couponCode = null; _couponDiscount = 0;
        _couponMsg = _couponReason(r['reason']?.toString());
        _couponBusy = false;
      });
    }
  }

  /// A coupon covers the full price → grant free via the wallet purchase path
  /// (net 0, no debit), works in any region.
  Future<void> _unlockFree() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _purchasing = true);
    final resp = await _api.purchaseService(_pricingId, widget.chartId, couponCode: _couponCode);
    if (!mounted) return;
    final ok = resp['statusCode'] == 200 || resp['statusCode'] == 201;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l.pwUnlockedNow), backgroundColor: AppColors.success));
      widget.onUnlocked();
    } else {
      setState(() => _purchasing = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l.pwUnlockFailed), backgroundColor: AppColors.error));
    }
  }

  /// International purchase — store IAP tier → backend verify → grant. No
  /// wallet involved (store policy). India uses [_unlock] instead.
  Future<void> _buyIap() async {
    final l = AppLocalizations.of(context)!;
    if (_iapProductId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l.pwUnlockFailed), backgroundColor: AppColors.error));
      return;
    }
    setState(() => _purchasing = true);
    final res = await IapService.instance.buy(
      productId: _iapProductId,
      servicePricingId: _pricingId,
      chartId: widget.chartId,
    );
    if (!mounted) return;
    if (res.ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l.pwUnlockedNow), backgroundColor: AppColors.success));
      widget.onUnlocked();
    } else {
      setState(() => _purchasing = false);
      if (res.error != 'canceled') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_iapErrorMessage(res.error, l)), backgroundColor: AppColors.error));
      }
    }
  }

  /// Turn an [IapService] error code into a user-facing message. The internal
  /// codes (store not available on this device — e.g. web —, product tier not
  /// yet published in the store, no purchase context, generic purchase error)
  /// are opaque to users, so they collapse to the localized generic failure.
  /// Anything else is a human-readable message the backend already returned.
  String _iapErrorMessage(String? error, AppLocalizations l) {
    const opaque = {
      'store_unavailable', 'product_not_found', 'no_context',
      'purchase_error', 'verify_failed', 'canceled',
    };
    if (error == null || error.isEmpty || opaque.contains(error)) {
      return l.pwUnlockFailed;
    }
    return error;
  }

  Future<void> _unlock() async {
    final l = AppLocalizations.of(context)!;
    if (_balance < _effPrice) { _openRecharge(); return; }
    setState(() => _purchasing = true);
    final resp = await _api.purchaseService(_pricingId, widget.chartId, couponCode: _couponCode);
    if (!mounted) return;
    final ok = resp['statusCode'] == 200 || resp['statusCode'] == 201;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l.pwUnlockedNow), backgroundColor: AppColors.success));
      widget.onUnlocked();
    } else {
      setState(() => _purchasing = false);
      final detail = resp['detail'];
      final msg = (detail is Map ? detail['message']?.toString() : detail?.toString()) ?? l.pwUnlockFailed;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg), backgroundColor: AppColors.error));
      if (resp['statusCode'] == 402) _openRecharge();
    }
  }

  void _openRecharge() {
    final l = AppLocalizations.of(context)!;
    final suggested = (_effPrice - _balance).clamp(0, double.infinity);
    final ctrl = TextEditingController(
        text: suggested > 0 ? suggested.ceil().toString() : _price.ceil().toString());
    bool submitting = false;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(builder: (ctx, setS) => Padding(
        padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.account_balance_wallet, color: AppColors.gold),
            const SizedBox(width: 8),
            Text(l.pwRechargeToUnlock,
                style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 14),
          TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.ivory),
            decoration: InputDecoration(
              labelText: l.pwRechargeAmount,
              labelStyle: const TextStyle(color: AppColors.smoke),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.smoke)),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.gold)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: submitting ? null : () async {
              final amt = double.tryParse(ctrl.text.trim()) ?? 0;
              if (amt <= 0) return;
              setS(() => submitting = true);
              final r = await _api.rechargeMyWallet(amount: amt);
              final ok = r['statusCode'] == 200 || r['statusCode'] == 201;
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              if (ok) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(l.pwRechargeDone), backgroundColor: AppColors.success));
                await _loadBalance();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(l.pwRechargeFailed), backgroundColor: AppColors.error));
              }
            },
            child: submitting
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l.pwAddMoney),
          )),
        ]),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final icon = widget.pricing['icon']?.toString();
    final heroEmoji = (icon != null && icon.isNotEmpty) ? icon : widget.emoji;
    // International buys via the store (payment handled by the store), so the
    // CTA is always enabled; India still gates on wallet balance (net of coupon).
    final enough = _intl ? true : _balance >= _effPrice;

    return ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 40), children: [
      // ── Locked hero ──
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [AppColors.gold.withOpacity(0.16), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.gold.withOpacity(0.3)),
        ),
        child: Column(children: [
          Stack(alignment: Alignment.center, children: [
            Text(heroEmoji, style: const TextStyle(fontSize: 52)),
            Positioned(
              right: 0, bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: AppColors.midnight, shape: BoxShape.circle),
                child: const Icon(Icons.lock, color: AppColors.gold, size: 18)),
            ),
          ]),
          const SizedBox(height: 14),
          Text(l.pwPremiumTitle.toUpperCase(),
              style: const TextStyle(color: AppColors.smoke, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(widget.pricing['service_name']?.toString() ?? widget.reportName,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.ivory, fontSize: 19, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          // Localized product tagline (from the backend card catalog); falls
          // back to the generic locked-subtitle when a row has no tagline.
          Text(_tagline(l), textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.smoke, fontSize: 12, height: 1.4)),
          const SizedBox(height: 14),
          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(_displayPrice,
                style: const TextStyle(color: AppColors.gold, fontSize: 34, fontWeight: FontWeight.w800, height: 1)),
            // Strike-through original only in India (INR); store shows tier price.
            if (!_intl && _orig != null && _orig! > _price) ...[
              const SizedBox(width: 10),
              Padding(padding: const EdgeInsets.only(bottom: 5), child: Text(Money.format(_orig!, currency: 'INR'),
                  style: const TextStyle(color: AppColors.smoke, fontSize: 15, decoration: TextDecoration.lineThrough))),
            ],
          ]),
          const SizedBox(height: 4),
          Text(l.pwOneTime, textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.smoke, fontSize: 10.5)),
        ]),
      ),

      // ── What you get ──
      if (_features.isNotEmpty) ...[
        const SizedBox(height: 18),
        Text(l.pwWhatYouGet.toUpperCase(),
            style: const TextStyle(color: AppColors.gold, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        ..._features.take(8).map((f) => Padding(padding: const EdgeInsets.only(bottom: 8),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.only(top: 1),
                child: Icon(Icons.check_circle, color: AppColors.success, size: 16)),
            const SizedBox(width: 8),
            Expanded(child: Text(f, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.4))),
          ]))),
      ],

      // ── Coupon code ──
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gold.withOpacity(0.12))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: TextField(
              controller: _couponCtrl,
              enabled: _couponCode == null && !_couponBusy,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(color: AppColors.ivory, fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                hintText: CouponLabels.of(context, 'enterCode'),
                hintStyle: const TextStyle(color: AppColors.smoke, fontSize: 12),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.smoke)),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.gold)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            )),
            const SizedBox(width: 8),
            _couponCode == null
                ? TextButton(
                    onPressed: _couponBusy ? null : _applyCoupon,
                    child: _couponBusy
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold))
                        : Text(CouponLabels.of(context, 'apply'), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)))
                : TextButton(
                    onPressed: () => setState(() {
                      _couponCode = null; _couponDiscount = 0; _couponMsg = null; _couponCtrl.clear();
                    }),
                    child: Text(CouponLabels.of(context, 'remove'), style: const TextStyle(color: AppColors.smoke))),
          ]),
          if (_couponMsg != null) Padding(padding: const EdgeInsets.only(top: 4),
            child: Text(
              _couponCode != null
                  ? '${CouponLabels.of(context, 'applied')} · −${Money.format(_couponDiscount, currency: 'INR')}'
                  : _couponMsg!,
              style: TextStyle(color: _couponCode != null ? AppColors.success : AppColors.error, fontSize: 11))),
        ]),
      ),

      // ── Wallet balance (India only — international pays via the store) ──
      if (!_intl) ...[
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.06))),
          child: Row(children: [
            const Icon(Icons.account_balance_wallet, color: AppColors.gold, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(l.pwYourBalance, style: const TextStyle(color: AppColors.smoke, fontSize: 12))),
            _loadingBalance
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold))
                : Text(Money.format(_balance, currency: 'INR'),
                    style: TextStyle(color: enough ? AppColors.ivory : AppColors.error, fontSize: 15, fontWeight: FontWeight.w800)),
          ]),
        ),
        if (!_loadingBalance && !enough) Padding(padding: const EdgeInsets.only(top: 6),
          child: Text(l.pwInsufficient, style: const TextStyle(color: AppColors.error, fontSize: 11))),
      ],

      // ── CTA ──
      const SizedBox(height: 18),
      SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(
        onPressed: _purchasing
            ? null
            : (_couponFull ? _unlockFree : (_intl ? _buyIap : _unlock)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold, foregroundColor: AppColors.midnight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        icon: _purchasing
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.midnight))
            : Icon((enough || _couponFull) ? Icons.lock_open : Icons.account_balance_wallet, size: 18),
        label: Text(
          _purchasing
              ? l.pwProcessing
              : (_couponFull
                  ? CouponLabels.of(context, 'unlockFree')
                  : (_intl
                      ? l.pwUnlockPrice(Money.format(_usd, currency: 'USD'))
                      : (enough
                          ? l.pwUnlockPrice(Money.format(_effPrice, currency: 'INR'))
                          : l.pwRechargeToUnlock))),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
      )),
      const SizedBox(height: 10),
      Center(child: TextButton(
        onPressed: () => Navigator.of(context).maybePop(),
        child: Text(l.pwMaybeLater, style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
      )),
    ]);
  }
}

/// Full-screen paywall for the pickers that RUN the engine before navigating
/// (Milan / Relationship / multi-chart). Returns true only after the report is
/// unlocked (free, already purchased, or just bought here); false if the user
/// backs out. Callers should proceed to run the analysis only on `true`.
Future<bool> ensureReportUnlocked(
  BuildContext context, {
  required String serviceKey,
  required String chartId,
  required String reportName,
  String emoji = '🔒',
}) async {
  final api = ApiService();
  // Already entitled? (free / purchased / privileged / unpriced)
  final ent = await api.getEntitlement(serviceKey, chartId: chartId);
  if (ent != null && ent['unlocked'] == true) return true;
  final pricing = await api.getServicePricingByKey(serviceKey);
  if (pricing == null) return true; // no priced row → fail-open
  final price = (pricing['price'] as num?)?.toDouble() ?? 0;
  if (pricing['is_free'] == true || price == 0) return true;
  if (!context.mounted) return false;

  final unlocked = await Navigator.of(context).push<bool>(MaterialPageRoute(
    builder: (ctx) => Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory),
            onPressed: () => Navigator.pop(ctx, false)),
        title: Text(reportName,
            style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700)),
      ),
      body: ReportPaywallCard(
        pricing: pricing,
        chartId: chartId,
        reportName: reportName,
        emoji: emoji,
        onUnlocked: () => Navigator.pop(ctx, true),
      ),
    ),
  ));
  return unlocked == true;
}
