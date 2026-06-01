import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

/// Shared paywall logic: checks if a kundli section is free for the user,
/// and if not, shows a purchase dialog that debits the wallet before unlocking.
///
/// Each section maps to a `service_key` from SERVICE_PRICING (seed_data).
/// If price=0 or is_free=true → grant immediately.
/// If paid → show confirm dialog → POST /service/purchase → on success unlock.
class PaywallService {
  PaywallService._();
  static final instance = PaywallService._();

  /// Map tab/section name → SERVICE_PRICING service_key
  static const sectionServiceKey = <String, String>{
    'summary': 'kundli_summary',
    'planets': 'kundli_planets',
    'kundli': 'kundli_chart',
    'divisions': 'divisional_charts',
    'vimshottari': 'vimshottari_dasha',
    'moola': 'moola_dasha',
    'gochar': 'gochar_today',
    'dosh': 'dosh_analysis',
    'yoga': 'yoga_analysis',
    'shadbala': 'shadbala',
    'ashtakavarga': 'ashtakavarga',
    'aspects': 'aspects_matrix',
    'life_areas': 'life_areas',
    'bhava': 'bhava_strength',
    'chakra': 'chakra_health',
    'dasha_activation': 'dasha_activation',
  };

  /// Cache: chart_id + section → unlocked?
  final _unlockCache = <String, bool>{};
  /// Cache: service_key → pricing info
  final _pricingCache = <String, Map<String, dynamic>>{};

  String _k(String chartId, String section) => '$chartId::$section';

  void markUnlocked(String chartId, String section) {
    _unlockCache[_k(chartId, section)] = true;
  }

  bool isUnlocked(String chartId, String section) => _unlockCache[_k(chartId, section)] ?? false;

  /// Returns true if user may view the section (either free or purchased).
  /// Shows a dialog for paid sections and handles purchase.
  Future<bool> check(BuildContext context, String chartId, String section) async {
    if (isUnlocked(chartId, section)) return true;

    final serviceKey = sectionServiceKey[section];
    if (serviceKey == null) return true; // unknown section — allow

    // Fetch pricing if not cached
    Map<String, dynamic>? pricing = _pricingCache[serviceKey];
    pricing ??= await ApiService().getServicePricingByKey(serviceKey);
    if (pricing == null) {
      // No pricing row — treat as free
      markUnlocked(chartId, section);
      return true;
    }
    _pricingCache[serviceKey] = pricing;

    final price = (pricing['price'] as num?)?.toDouble() ?? 0;
    final isFree = pricing['is_free'] == true || price == 0;
    if (isFree) {
      markUnlocked(chartId, section);
      return true;
    }

    // Show purchase dialog
    final purchased = await _showPurchaseDialog(context, pricing, chartId);
    if (purchased) markUnlocked(chartId, section);
    return purchased;
  }

  Future<bool> _showPurchaseDialog(BuildContext context, Map<String, dynamic> pricing, String chartId) async {
    final price = (pricing['price'] as num?)?.toDouble() ?? 0;
    final orig = (pricing['original_price'] as num?)?.toDouble();
    final features = (pricing['features_json'] as List?)?.cast<String>() ?? const [];

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setS) {
        bool purchasing = false;
        return AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(children: [
            Text(pricing['icon']?.toString() ?? '📜', style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 10),
            Expanded(child: Text(pricing['service_name']?.toString() ?? 'Premium Section',
                style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w700))),
          ]),
          content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (pricing['description'] != null)
              Text(pricing['description'].toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 14),
            Row(children: [
              Text('₹${price.toStringAsFixed(0)}',
                  style: const TextStyle(color: AppColors.primary, fontSize: 28, fontWeight: FontWeight.w700)),
              if (orig != null && orig > price) ...[
                const SizedBox(width: 10),
                Text('₹${orig.toStringAsFixed(0)}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, decoration: TextDecoration.lineThrough)),
              ],
            ]),
            const SizedBox(height: 10),
            if (features.isNotEmpty) ...features.take(5).map((f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(children: [
                const Icon(Icons.check_circle, color: AppColors.success, size: 14),
                const SizedBox(width: 6),
                Expanded(child: Text(f, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12))),
              ]),
            )),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                const Icon(Icons.account_balance_wallet, color: AppColors.accent, size: 16),
                const SizedBox(width: 6),
                Expanded(child: Text(AppLocalizations.of(context)?.walletDeduction ?? 'Amount deducted',
                    style: TextStyle(color: AppColors.accent, fontSize: 11))),
              ]),
            ),
          ]),
          actions: [
            TextButton(
              onPressed: purchasing ? null : () => Navigator.pop(ctx, false),
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton.icon(
              onPressed: purchasing ? null : () async {
                setS(() => purchasing = true);
                final resp = await ApiService().purchaseKundliSection(pricing['id'] as String, chartId);
                if (!ctx.mounted) return;
                if (resp['statusCode'] == 200 || resp['statusCode'] == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(AppLocalizations.of(context)?.unlocked ?? 'Unlocked!'),
                    backgroundColor: AppColors.success,
                  ));
                  Navigator.pop(ctx, true);
                } else {
                  setS(() => purchasing = false);
                  final err = resp['detail']?.toString() ?? 'Purchase failed';
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                    content: Text(err),
                    backgroundColor: AppColors.error,
                  ));
                  // Insufficient balance — offer to recharge
                  if (err.toLowerCase().contains('balance') || err.toLowerCase().contains('402')) {
                    // close dialog, let caller redirect to wallet
                    Future.delayed(const Duration(milliseconds: 1200), () {
                      if (ctx.mounted) Navigator.pop(ctx, false);
                    });
                  }
                }
              },
              icon: purchasing
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                  : const Icon(Icons.lock_open, size: 16),
              label: Text(purchasing ? 'Processing...' : 'Unlock ₹${price.toStringAsFixed(0)}'),
            ),
          ],
        );
      }),
    ) ?? false;
  }
}
