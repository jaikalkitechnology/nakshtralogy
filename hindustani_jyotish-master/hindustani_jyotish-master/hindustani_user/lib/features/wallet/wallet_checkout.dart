import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hj_core/hj_core.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'wallet_repository.dart';

/// Raised when the Razorpay checkout fails or is dismissed by the user.
class RechargeCancelled implements Exception {
  RechargeCancelled(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Owns the Razorpay instance and orchestrates the full recharge round-trip:
/// `/wallet/recharge/intent` → checkout sheet → `/wallet/recharge/verify`.
///
/// Keeping the plugin here (not in the widget tree) means the screen only ever
/// awaits a single [recharge] future. Device-only: on platforms without the
/// Razorpay channel this surfaces a [RechargeCancelled] instead of crashing.
class WalletCheckout {
  WalletCheckout(this._repo);

  final WalletRepository _repo;

  Razorpay? _razorpay;
  Completer<PaymentSuccessResponse>? _pending;

  /// Runs the recharge for [amountRupees].
  ///
  /// Returns the credited [WalletTransaction] on success; throws
  /// [RechargeCancelled] on dismissal/failure and [ApiException] on API errors.
  Future<WalletTransaction> recharge({
    required int amountRupees,
    String? name,
    String? email,
    String? contact,
  }) async {
    final amount = '$amountRupees';

    // 1) Ask the backend to create a Razorpay order.
    final order = await _repo.rechargeIntent(amount);

    // 2) Open the checkout sheet and wait for its success callback.
    final result = await _openCheckout(
      order,
      name: name,
      email: email,
      contact: contact,
    );

    // 3) Verify the signed payment server-side, which credits the wallet.
    return _repo.verifyRecharge(
      orderId: result.orderId ?? order['order_id'] as String,
      paymentId: result.paymentId ?? '',
      signature: result.signature ?? '',
      amount: amount,
    );
  }

  Future<PaymentSuccessResponse> _openCheckout(
    Map<String, dynamic> order, {
    String? name,
    String? email,
    String? contact,
  }) {
    final completer = Completer<PaymentSuccessResponse>();
    _pending = completer;

    final Razorpay rp;
    try {
      rp = Razorpay();
    } on MissingPluginException {
      return Future.error(
          RechargeCancelled('Payments are not available on this device.'));
    }
    _razorpay = rp
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _onError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);

    final prefill = <String, dynamic>{
      if (contact != null && contact.isNotEmpty) 'contact': contact,
      if (email != null && email.isNotEmpty) 'email': email,
    };

    try {
      rp.open(<String, dynamic>{
        'key': order['key_id'],
        'order_id': order['order_id'],
        'amount': order['amount'], // paise (int) from the intent
        'currency': order['currency'] ?? 'INR',
        'name': 'Hindustani Jyotish',
        'description': 'Wallet recharge',
        if (name != null && name.isNotEmpty) 'prefill.name': name,
        if (prefill.isNotEmpty) 'prefill': prefill,
      });
    } on MissingPluginException {
      _dispose();
      return Future.error(
          RechargeCancelled('Payments are not available on this device.'));
    } catch (e) {
      _dispose();
      return Future.error(RechargeCancelled('Could not open checkout: $e'));
    }

    return completer.future;
  }

  void _onSuccess(PaymentSuccessResponse response) {
    final pending = _pending;
    _dispose();
    if (pending != null && !pending.isCompleted) pending.complete(response);
  }

  void _onError(PaymentFailureResponse response) {
    final pending = _pending;
    _dispose();
    final message = response.message?.trim();
    if (pending != null && !pending.isCompleted) {
      pending.completeError(RechargeCancelled(
        (message == null || message.isEmpty) ? 'Payment cancelled' : message,
      ));
    }
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    // The user chose an external wallet; the SDK continues the flow and will
    // still fire success/error. Nothing to complete here.
  }

  void _dispose() {
    _razorpay?.clear();
    _razorpay = null;
    _pending = null;
  }

  /// Release the plugin if a checkout is still open (e.g. screen disposed).
  void dispose() => _dispose();
}
