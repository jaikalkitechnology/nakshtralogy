/// Platform-agnostic types for the native Razorpay Checkout wrapper.
class RazorpayOptions {
  final String key;         // Razorpay key_id (public)
  final String orderId;     // razorpay order id (order_...)
  final int amountPaise;    // amount in the smallest unit
  final String currency;
  final String name;
  final String description;
  final String? prefillEmail;
  final String? prefillContact;
  const RazorpayOptions({
    required this.key,
    required this.orderId,
    required this.amountPaise,
    this.currency = 'INR',
    this.name = 'Nakshatralogy',
    this.description = 'Wallet recharge',
    this.prefillEmail,
    this.prefillContact,
  });
}

class RazorpayResult {
  final bool success;
  final String? paymentId;
  final String? orderId;
  final String? signature;
  final String? error;
  final bool cancelled;
  const RazorpayResult({
    required this.success,
    this.paymentId,
    this.orderId,
    this.signature,
    this.error,
    this.cancelled = false,
  });
}
