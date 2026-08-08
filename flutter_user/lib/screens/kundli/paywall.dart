import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'report_paywall.dart';

/// Shared paywall logic for the kundli-viewer sections (dasha, gochar, dosh,
/// yoga, shadbala, …). Each section maps to a `service_key` from
/// SERVICE_PRICING. Free sections (price = 0 / is_free) pass through; paid
/// sections delegate the locked-card + purchase UX to [ensureReportUnlocked]
/// (report_paywall.dart) so a kundli section gets the SAME region-aware
/// treatment as the specialist reports:
///   • India       → ₹ price, wallet debit (/service/purchase)
///   • International → USD tier, store IAP (/service/iap/verify)
///
/// PRESENTATION + ACCESS ONLY — this never computes or alters a chart. Prices
/// are always read from ServicePricing (admin-editable); nothing is hardcoded.
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

  /// Returns true if user may view the section (free or purchased). For paid
  /// sections it shows the region-aware paywall and handles the purchase.
  Future<bool> check(BuildContext context, String chartId, String section) async {
    if (isUnlocked(chartId, section)) return true;

    final serviceKey = sectionServiceKey[section];
    if (serviceKey == null) return true; // unknown section — allow

    // Fetch pricing if not cached (for the section title/emoji + free check).
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

    final reportName = pricing['service_name']?.toString() ?? 'Premium Section';
    final iconRaw = pricing['icon']?.toString() ?? '';
    if (!context.mounted) return false;

    // Region-aware unlock: India → ₹/wallet, International → USD/store IAP.
    final ok = await ensureReportUnlocked(
      context,
      serviceKey: serviceKey,
      chartId: chartId,
      reportName: reportName,
      emoji: iconRaw.isNotEmpty ? iconRaw : '🔒',
    );
    if (ok) markUnlocked(chartId, section);
    return ok;
  }
}
