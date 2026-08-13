import 'package:hj_core/hj_core.dart';

import 'broadcast_models.dart';

/// Wraps the `/broadcasts/*` endpoints for the seeker-facing broadcast
/// viewer. Astrologer broadcasts, users join and watch, and both sides chat —
/// Super Chat and Gifts let viewers send the astrologer paid highlights.
class BroadcastRepository {
  BroadcastRepository(this._api);
  final ApiClient _api;

  /// Astrologers broadcasting right now. Anonymous-friendly.
  Future<List<BroadcastNowItem>> now() async {
    final res = await _api.get('/broadcasts/now');
    return (res as List)
        .map((e) => BroadcastNowItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Recorded astrologer videos (`GET /astrologer-videos`, public). Their own
  /// table, separate from the Home promo-video carousel. Entries with
  /// `is_live` true duplicate a stream already returned by [now], so callers
  /// should skip them.
  Future<List<AstrologerVideo>> videos() async {
    final res = await _api.get('/astrologer-videos');
    return (res as List)
        .map((e) => AstrologerVideo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Join a broadcast as a viewer — returns the broadcast record + Agora
  /// grant. May throw [ApiException] 409 if it isn't live/is stale.
  Future<BroadcastJoin> join(String id) async {
    final res = await _api.post('/broadcasts/$id/join');
    return BroadcastJoin.fromJson(res as Map<String, dynamic>);
  }

  /// The gift catalog — public, no auth needed.
  Future<List<BroadcastGift>> gifts() async {
    final res = await _api.get('/broadcasts/gifts');
    return (res as List)
        .map((e) => BroadcastGift.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Sends a preset-amount Super Chat. `amount` must be an exact match to
  /// one of the target astrologer's `super_chat_presets`. May throw
  /// [ApiException]: 400 (no presets configured / amount doesn't match any
  /// preset), 402 (insufficient wallet balance), 409 (broadcast not live).
  Future<void> superChat(String id, {required String amount, String? message}) {
    final trimmed = message?.trim();
    return _api.post(
      '/broadcasts/$id/super-chat',
      body: {
        'amount': amount,
        if (trimmed != null && trimmed.isNotEmpty) 'message': trimmed,
      },
    );
  }

  /// Sends a gift from the catalog. Same error codes as [superChat].
  Future<void> gift(String id, String giftKey) {
    return _api.post('/broadcasts/$id/gift', body: {'gift_key': giftKey});
  }
}
