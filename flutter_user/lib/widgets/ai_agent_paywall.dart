import 'package:flutter/material.dart';
import '../l10n/gen/app_localizations.dart';
import '../services/api_service.dart';
import '../services/app_mode.dart';
import '../services/iap_service.dart';
import '../theme/app_theme.dart';
import '../utils/money.dart';

/// Shared paywall for paid AI chat topics (admin "AI Chat Agents").
///
/// Two pricing modes come from the backend (`/ai/agents` → `pricing_mode`):
///  - "one_time": pay once from the ₹ wallet (India) or via store IAP
///    (international) for permanent access.
///  - "time": the admin's time plans, e.g. 10 min = ₹100, 20 min = ₹200.
///    The user picks a plan and pays from the ₹ wallet; buying again while
///    time is left adds to it.
///
/// Returns the topic's updated meta when the user can chat now (free,
/// already unlocked, or just paid), or null when they cancelled / payment
/// failed. Pass [refresh] to re-read the meta from the server first (e.g.
/// after the chat reported the time ran out).
Future<Map<String, dynamic>?> ensureAiAgentAccess(
  BuildContext context, {
  required String key,
  required Map<String, dynamic>? meta,
  required String label,
  required String emoji,
  bool refresh = false,
}) async {
  var m = meta;
  if (refresh || m == null) {
    final all = await ApiService().getAiAgents();
    m = (all[key] as Map<String, dynamic>?) ?? m;
  }
  if (m == null || m['is_paid'] != true || m['unlocked'] == true) {
    return m ?? <String, dynamic>{};
  }
  if (!context.mounted) return null;
  if (m['pricing_mode'] == 'time') {
    return _buyTime(context, key, m, label, emoji);
  }
  return _buyOneTime(context, key, m, label, emoji);
}

/// Minutes left on a time pass from a meta / access map, or null.
int? minutesLeftFrom(Map<String, dynamic>? m) {
  final secs = (m?['remaining_seconds'] as num?)?.toInt();
  if (secs == null || secs <= 0) return null;
  return (secs / 60).ceil();
}

void _snack(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), backgroundColor: AppColors.error),
  );
}

Future<Map<String, dynamic>?> _buyTime(
  BuildContext context, String key, Map<String, dynamic> m, String label, String emoji,
) async {
  final l = AppLocalizations.of(context)!;
  // Time passes are paid from the ₹ wallet only.
  if (m['pay_via'] == 'iap' || AppMode.instance.isInternational) {
    _snack(context, l.specialistNotAvailablePurchase);
    return null;
  }
  final plans = ((m['time_plans'] as List?) ?? [])
      .map((p) => Map<String, dynamic>.from(p as Map))
      .toList();
  if (plans.isEmpty) {
    _snack(context, l.specialistNotAvailablePurchase);
    return null;
  }
  final left = minutesLeftFrom(m);
  final intro = (m['free_intro'] ?? '').toString();

  final minutes = await showModalBottomSheet<int>(
    context: context,
    backgroundColor: AppColors.card,
    isScrollControlled: true,
    constraints: const BoxConstraints(maxWidth: 560),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) {
      var selected = (plans.first['minutes'] as num).toInt();
      return StatefulBuilder(builder: (ctx, setSheet) {
        final plan = plans.firstWhere((p) => (p['minutes'] as num).toInt() == selected);
        final payLabel = Money.format((plan['price'] as num).toDouble(), currency: 'INR');
        // Scrolls on short screens / large text instead of overflowing.
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Expanded(child: Text(label, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w700))),
              ]),
              const SizedBox(height: 12),
              Text(l.aiTimePassTitle,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
              if (left != null) ...[
                const SizedBox(height: 4),
                Text('⏱ ${l.aiTimeLeft(left)}', style: const TextStyle(color: AppColors.gold, fontSize: 12)),
              ],
              if (intro.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(intro, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
              const SizedBox(height: 12),
              ...plans.map((p) {
                final mins = (p['minutes'] as num).toInt();
                final isSel = mins == selected;
                return GestureDetector(
                  onTap: () => setSheet(() => selected = mins),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.gold.withOpacity(0.12) : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSel ? AppColors.gold : AppColors.border),
                    ),
                    child: Row(children: [
                      Icon(isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                          size: 18, color: isSel ? AppColors.gold : AppColors.textSecondary),
                      const SizedBox(width: 10),
                      Expanded(child: Text('⏱ ${l.aiTimePlanMinutes(mins)}',
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600))),
                      Text(Money.format((p['price'] as num).toDouble(), currency: 'INR'),
                          style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                );
              }),
              const SizedBox(height: 4),
              Text(l.aiTimePassHint, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              const SizedBox(height: 14),
              Row(children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(l.cancel, style: const TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, selected),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.midnight),
                  child: Text(l.aiTimePassPay(payLabel), maxLines: 1, overflow: TextOverflow.ellipsis),
                )),
              ]),
            ]),
          ),
        );
      });
    },
  );
  if (minutes == null || !context.mounted) return null;

  final resp = await ApiService().unlockAiAgent(key, minutes: minutes);
  if (!context.mounted) return null;
  if (resp['statusCode'] != 200) {
    final detail = resp['detail'];
    _snack(context, detail is String && detail.isNotEmpty ? detail : l.couldNotUnlockWalletBalance);
    return null;
  }
  return {
    ...m,
    'unlocked': true,
    'expired': false,
    'remaining_seconds': resp['remaining_seconds'],
    'expires_at': resp['expires_at'],
  };
}

Future<Map<String, dynamic>?> _buyOneTime(
  BuildContext context, String key, Map<String, dynamic> m, String label, String emoji,
) async {
  final l = AppLocalizations.of(context)!;
  // Region-aware: India pays ₹ from the wallet; international pays the USD
  // tier via store IAP.
  final intl = (m['pay_via'] == 'iap') || AppMode.instance.isInternational;
  final sessCurrency = (m['session_currency'] as String?) ?? (intl ? 'USD' : 'INR');
  final sessAmount = (m['session_amount'] as num?)?.toDouble() ??
      (intl ? (m['price_usd'] as num?)?.toDouble() ?? 0 : (m['price'] as num?)?.toDouble() ?? 0);
  final priceLabel = Money.format(sessAmount, currency: sessCurrency);
  final intro = (m['free_intro'] ?? '').toString();

  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.card,
      title: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        Expanded(child: Text(label, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.primary, fontSize: 16))),
      ]),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (intro.isNotEmpty)
          Padding(padding: const EdgeInsets.only(bottom: 12),
              child: Text(intro, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13))),
        Text(intl ? l.unlockAiSpecialistIntl(priceLabel) : l.unlockAiSpecialistWallet(priceLabel),
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel, style: const TextStyle(color: AppColors.textSecondary))),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.midnight),
          child: Text(l.unlockPriceLabel(priceLabel), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return null;

  if (intl) {
    final productId = (m['iap_product_id'] as String?) ?? '';
    if (productId.isEmpty) {
      _snack(context, l.specialistNotAvailablePurchase);
      return null;
    }
    final res = await IapService.instance.buyAgent(productId: productId, agentKey: key);
    if (!context.mounted) return null;
    if (!res.ok) {
      if (res.error != 'canceled') _snack(context, l.couldNotCompletePurchase);
      return null;
    }
  } else {
    final resp = await ApiService().unlockAiAgent(key);
    if (!context.mounted) return null;
    if (resp['statusCode'] != 200) {
      final detail = resp['detail'];
      _snack(context, detail is String && detail.isNotEmpty ? detail : l.couldNotUnlockWalletBalance);
      return null;
    }
  }
  return {...m, 'unlocked': true};
}
