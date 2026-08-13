/// A normalised API error carrying the HTTP status and a human message.
class ApiException implements Exception {
  ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  bool get isUnauthorized => statusCode == 401;
  bool get isPaymentRequired => statusCode == 402;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
