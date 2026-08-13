import 'package:hj_core/hj_core.dart';

/// A GST invoice for a paid consultation (kundli is free). List + PDF download.
class Invoice {
  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.totalAmount,
    required this.taxableValue,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.igstAmount,
    required this.currency,
    this.createdAt,
  });

  final String id;
  final String invoiceNumber;
  final double totalAmount;
  final double taxableValue;
  final double cgstAmount;
  final double sgstAmount;
  final double igstAmount;
  final String currency;
  final DateTime? createdAt;

  double get taxAmount => cgstAmount + sgstAmount + igstAmount;

  static double _d(dynamic v) =>
      v is num ? v.toDouble() : double.tryParse('$v') ?? 0;

  factory Invoice.fromJson(Map<String, dynamic> j) => Invoice(
        id: j['id'] as String,
        invoiceNumber: (j['invoice_number'] ?? '') as String,
        totalAmount: _d(j['total_amount']),
        taxableValue: _d(j['taxable_value']),
        cgstAmount: _d(j['cgst_amount']),
        sgstAmount: _d(j['sgst_amount']),
        igstAmount: _d(j['igst_amount']),
        currency: (j['currency'] ?? 'INR') as String,
        createdAt: j['created_at'] != null
            ? DateTime.tryParse(j['created_at'] as String)
            : null,
      );
}

class InvoiceRepository {
  InvoiceRepository(this._api);
  final ApiClient _api;

  Future<List<Invoice>> myInvoices({int skip = 0, int limit = 50}) async {
    final res = await _api.get('/me/invoices', query: {
      'skip': skip,
      'limit': limit,
    });
    final items = (res as Map<String, dynamic>)['items'] as List? ?? const [];
    return items
        .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
