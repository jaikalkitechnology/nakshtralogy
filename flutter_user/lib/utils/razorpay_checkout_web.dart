import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'razorpay_checkout_types.dart';

/// JS-interop binding for the global `Razorpay` constructor loaded by
/// checkout.js. Uses the modern `dart:js_interop` API (dart:js / dart:js_util
/// are deprecated in Dart 3.x).
@JS('Razorpay')
extension type _RazorpayJs._(JSObject _) implements JSObject {
  external factory _RazorpayJs(JSAny options);
  external void on(String event, JSFunction handler);
  external void open();
}

bool _razorpayReady() => globalContext.has('Razorpay');

String? _prop(JSObject o, String key) {
  final v = o.getProperty<JSAny?>(key.toJS);
  return v.isDefinedAndNotNull ? (v as JSString).toDart : null;
}

Future<void> _ensureScript() {
  if (_razorpayReady()) return Future.value();
  final c = Completer<void>();
  final existing = html.document.querySelector('script[src*="checkout.razorpay.com"]');
  if (existing != null) {
    // Poll briefly for the global to appear.
    int tries = 0;
    Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (_razorpayReady()) { t.cancel(); c.complete(); }
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

  void handler(JSObject resp) {
    if (!completer.isCompleted) {
      completer.complete(RazorpayResult(
        success: true,
        paymentId: _prop(resp, 'razorpay_payment_id'),
        orderId: _prop(resp, 'razorpay_order_id'),
        signature: _prop(resp, 'razorpay_signature'),
      ));
    }
  }

  void onDismiss() {
    if (!completer.isCompleted) {
      completer.complete(const RazorpayResult(success: false, cancelled: true));
    }
  }

  final options = <String, dynamic>{
    'key': o.key,
    'order_id': o.orderId,
    'amount': o.amountPaise,
    'currency': o.currency,
    'name': o.name,
    'description': o.description,
    'theme': {'color': '#E8B547'},
    'prefill': {'email': o.prefillEmail ?? '', 'contact': o.prefillContact ?? ''},
    'handler': handler.toJS,
    'modal': {'ondismiss': onDismiss.toJS},
  };

  final rzp = _RazorpayJs(options.jsify()!);
  rzp.on('payment.failed', ((JSObject resp) {
    if (!completer.isCompleted) {
      completer.complete(const RazorpayResult(success: false, error: 'Payment failed'));
    }
  }).toJS);
  rzp.open();
  return completer.future;
}
