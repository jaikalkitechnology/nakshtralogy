import 'package:hj_core/hj_core.dart';

class WalletRepository {
  WalletRepository(this._api);
  final ApiClient _api;

  Future<Wallet> getWallet() async {
    final res = await _api.get('/wallet');
    return Wallet.fromJson(res as Map<String, dynamic>);
  }

  Future<List<WalletTransaction>> transactions({String? type, String? direction}) async {
    final query = <String, dynamic>{};
    if (type != null) query['type'] = type;
    if (direction != null) query['direction'] = direction;
    final res = await _api.get('/wallet/transactions', query: query);
    return (res as List)
        .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Create a Razorpay recharge order. Returns the order payload.
  /// (Biometric authentication was removed platform-wide — the backend no
  /// longer requires any attestation at any amount.)
  Future<Map<String, dynamic>> rechargeIntent(String amount) async {
    final res =
        await _api.post('/wallet/recharge/intent', body: {'amount': amount});
    return res as Map<String, dynamic>;
  }

  /// Verify a completed Razorpay payment and credit the wallet.
  Future<WalletTransaction> verifyRecharge({
    required String orderId,
    required String paymentId,
    required String signature,
    required String amount,
  }) async {
    final res = await _api.post('/wallet/recharge/verify', body: {
      'razorpay_order_id': orderId,
      'razorpay_payment_id': paymentId,
      'razorpay_signature': signature,
      'amount': amount,
    });
    return WalletTransaction.fromJson(res as Map<String, dynamic>);
  }
}
