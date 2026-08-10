import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:js_util' as jsutil;
import 'razorpay_checkout_types.dart';

Future<void> _ensureScript() {
  if (js.context.hasProperty('Razorpay')) return Future.value();
  final c = Completer<void>();
  final existing = html.document.querySelector('script[src*="checkout.razorpay.com"]');
  if (existing != null) {
    // Poll briefly for the global to appear.
    int tries = 0;
    Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (js.context.hasProperty('Razorpay')) { t.cancel(); c.complete(); }
      else if (++tries > 50) { t.cancel(); c.completeError('Razorpay script not ready'); }
    });
    return c.future;
  }
  final s = html.ScriptElement()
    ..src = 'https://checkout.razorpay.com/v1/checkout.js'
    ..async = true;
  s.onLoad.listen((_) => c.complete());
  s.onError.listen((_) => c.completeError('Failed to load Razorpay'));
  html.document.head!.append(s);
  return c.future;
}

/// Web: open the Razorpay Checkout overlay in-page via checkout.js.
Future<RazorpayResult> openRazorpayCheckout(RazorpayOptions o) async {
  await _ensureScript();
  final completer = Completer<RazorpayResult>();

  final options = <String, dynamic>{
    'key': o.key,
    'order_id': o.orderId,
    'amount': o.amountPaise,
    'currency': o.currency,
    'name': o.name,
    'description': o.description,
    'theme': {'color': '#E8B547'},
    'prefill': {'email': o.prefillEmail ?? '', 'contact': o.prefillContact ?? ''},
    'handler': js.allowInterop((resp) {
      if (!completer.isCompleted) {
        completer.complete(RazorpayResult(
          success: true,
          paymentId: jsutil.getProperty(resp, 'razorpay_payment_id'),
          orderId: jsutil.getProperty(resp, 'razorpay_order_id'),
          signature: jsutil.getProperty(resp, 'razorpay_signature'),
        ));
      }
    }),
    'modal': {
      'ondismiss': js.allowInterop(() {
        if (!completer.isCompleted) {
          completer.complete(const RazorpayResult(success: false, cancelled: true));
        }
      }),
    },
  };

  final rzpCtor = js.context['Razorpay'] as js.JsFunction;
  final rzp = js.JsObject(rzpCtor, [jsutil.jsify(options)]);
  rzp.callMethod('on', [
    'payment.failed',
    js.allowInterop((resp) {
      if (!completer.isCompleted) {
        completer.complete(const RazorpayResult(success: false, error: 'Payment failed'));
      }
    })
  ]);
  rzp.callMethod('open');
  return completer.future;
}
