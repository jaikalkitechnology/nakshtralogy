import 'dart:async';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'razorpay_checkout_types.dart';

/// Mobile/desktop: open the native Razorpay Checkout modal via the SDK.
Future<RazorpayResult> openRazorpayCheckout(RazorpayOptions o) {
  final completer = Completer<RazorpayResult>();
  final rzp = Razorpay();

  void finish(RazorpayResult r) {
    if (!completer.isCompleted) completer.complete(r);
    rzp.clear();
  }

  rzp.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse r) {
    finish(RazorpayResult(
      success: true, paymentId: r.paymentId, orderId: r.orderId, signature: r.signature));
  });
  rzp.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse r) {
    final cancelled = r.code == Razorpay.PAYMENT_CANCELLED;
    finish(RazorpayResult(success: false, cancelled: cancelled, error: r.message ?? 'Payment failed'));
  });
  rzp.on(Razorpay.EVENT_EXTERNAL_WALLET, (_) {});

  rzp.open(<String, dynamic>{
    'key': o.key,
    'order_id': o.orderId,
    'amount': o.amountPaise,
    'currency': o.currency,
    'name': o.name,
    'description': o.description,
    'theme': {'color': '#E8B547'},
    if (o.prefillEmail != null || o.prefillContact != null)
      'prefill': {'email': o.prefillEmail ?? '', 'contact': o.prefillContact ?? ''},
  });
  return completer.future;
}
