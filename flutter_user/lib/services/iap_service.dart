import 'dart:async';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'api_service.dart';

/// Store IAP purchases for INTERNATIONAL (INTL) users.
///
/// International paid digital goods must go through App Store / Google Play IAP
/// tiers (store policy) — NOT the card wallet. Flow:
///   1. queryProducts(productIds) — resolve store products for the service tiers.
///   2. buy(product, ...) — start the store purchase; results arrive on the
///      purchase stream.
///   3. on a purchased/restored result → POST /service/iap/verify (backend
///      verifies the receipt — SCAFFOLD until the PAPG phase — and grants a
///      ServiceOrder), then completePurchase().
///
/// India keeps the existing wallet flow and never touches this service.
/// Never verifies receipts on-device; the backend is the source of truth.
class IapResult {
  final bool ok;
  final String? orderId;
  final String? error;
  const IapResult({required this.ok, this.orderId, this.error});
}

class IapService {
  IapService._();
  static final IapService instance = IapService._();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  // Context for the in-flight purchase so the stream handler can verify it
  // against the right service/chart. Keyed by product id.
  final Map<String, _PendingBuy> _pending = {};
  final Map<String, Completer<IapResult>> _completers = {};

  bool _listening = false;

  /// Whether the store billing is available on this device.
  Future<bool> available() async {
    try {
      return await _iap.isAvailable();
    } catch (_) {
      return false;
    }
  }

  void _ensureListening() {
    if (_listening) return;
    _listening = true;
    _sub = _iap.purchaseStream.listen(
      _onPurchaseUpdates,
      onDone: () => _sub?.cancel(),
      onError: (_) {},
    );
  }

  /// Resolve store products for the given product ids (from ServicePricing
  /// iap_product_id). Returns the found ProductDetails.
  Future<List<ProductDetails>> queryProducts(Set<String> productIds) async {
    if (productIds.isEmpty) return const [];
    try {
      final resp = await _iap.queryProductDetails(productIds);
      return resp.productDetails;
    } catch (_) {
      return const [];
    }
  }

  /// Buy a service by its store product id. Resolves when the purchase has been
  /// verified + granted by the backend (or on failure/cancel).
  Future<IapResult> buy({
    required String productId,
    required String servicePricingId,
    String? chartId,
  }) async {
    _ensureListening();
    if (!await available()) {
      return const IapResult(ok: false, error: 'store_unavailable');
    }
    final products = await queryProducts({productId});
    if (products.isEmpty) {
      return const IapResult(ok: false, error: 'product_not_found');
    }
    final product = products.first;
    final completer = Completer<IapResult>();
    _completers[productId] = completer;
    _pending[productId] = _PendingBuy(servicePricingId: servicePricingId, chartId: chartId);

    final param = PurchaseParam(productDetails: product);
    try {
      // Digital goods → consumable/non-consumable buy. Reports are one-time
      // unlocks per chart, so a non-consumable makes sense; the backend grant is
      // the real entitlement so we buy non-consumable.
      await _iap.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      _pending.remove(productId);
      _completers.remove(productId);
      return IapResult(ok: false, error: e.toString());
    }
    return completer.future;
  }

  Future<void> _onPurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      if (p.status == PurchaseStatus.pending) continue;

      if (p.status == PurchaseStatus.error) {
        _finish(p.productID, IapResult(ok: false, error: p.error?.message ?? 'purchase_error'));
        if (p.pendingCompletePurchase) await _iap.completePurchase(p);
        continue;
      }

      if (p.status == PurchaseStatus.canceled) {
        _finish(p.productID, const IapResult(ok: false, error: 'canceled'));
        if (p.pendingCompletePurchase) await _iap.completePurchase(p);
        continue;
      }

      if (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored) {
        final ctx = _pending[p.productID];
        final platform = defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
        final txnId = p.purchaseID ??
            p.verificationData.serverVerificationData.hashCode.toString();
        IapResult result;
        if (ctx == null) {
          // No local context (e.g. a restore on cold start) — acknowledge only.
          result = const IapResult(ok: false, error: 'no_context');
        } else {
          final resp = await ApiService().verifyIap(
            servicePricingId: ctx.servicePricingId,
            chartId: ctx.chartId,
            platform: platform,
            productId: p.productID,
            transactionId: txnId,
            receipt: p.verificationData.serverVerificationData,
          );
          final ok = resp['statusCode'] == 200 || resp['statusCode'] == 201;
          result = IapResult(
            ok: ok,
            orderId: ok ? resp['id']?.toString() : null,
            error: ok ? null : _errorOf(resp),
          );
        }
        _finish(p.productID, result);
        if (p.pendingCompletePurchase) await _iap.completePurchase(p);
      }
    }
  }

  String _errorOf(Map<String, dynamic> resp) {
    final d = resp['detail'];
    if (d is Map) return d['message']?.toString() ?? 'verify_failed';
    return d?.toString() ?? 'verify_failed';
  }

  void _finish(String productId, IapResult result) {
    _pending.remove(productId);
    final c = _completers.remove(productId);
    if (c != null && !c.isCompleted) c.complete(result);
  }

  void dispose() {
    _sub?.cancel();
    _listening = false;
  }
}

class _PendingBuy {
  final String servicePricingId;
  final String? chartId;
  const _PendingBuy({required this.servicePricingId, this.chartId});
}
