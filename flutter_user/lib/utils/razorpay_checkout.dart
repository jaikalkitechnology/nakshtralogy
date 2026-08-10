// Native Razorpay Checkout that opens IN-APP (mobile SDK) or IN-PAGE overlay
// (web checkout.js) — no external browser. Conditional per platform.
export 'razorpay_checkout_types.dart';
export 'razorpay_checkout_io.dart'
    if (dart.library.html) 'razorpay_checkout_web.dart';
