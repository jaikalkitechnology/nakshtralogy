import 'package:equatable/equatable.dart';
import 'package:hj_core/hj_core.dart';

/// A currently-live astrologer broadcast, as returned by `GET /broadcasts/now`.
/// Feeds both the "currently live" list screen and the home-screen banner.
class BroadcastNowItem extends Equatable {
  const BroadcastNowItem({
    required this.id,
    required this.astrologerId,
    required this.title,
    required this.currentViewers,
    required this.astrologerName,
    this.astrologerPhoto,
  });

  final String id;
  final String astrologerId;
  final String title;
  final int currentViewers;
  final String astrologerName;
  final String? astrologerPhoto;

  factory BroadcastNowItem.fromJson(Map<String, dynamic> j) => BroadcastNowItem(
        id: '${j['id']}',
        astrologerId: '${j['astrologer_id']}',
        title: (j['title'] as String?)?.trim().isNotEmpty == true
            ? j['title'] as String
            : 'Live session',
        currentViewers: (j['current_viewers'] as num?)?.toInt() ?? 0,
        astrologerName: (j['astrologer_name'] as String?) ?? 'Astrologer',
        astrologerPhoto: j['astrologer_photo'] as String?,
      );

  @override
  List<Object?> get props => [id, currentViewers, title];
}

/// A single broadcast's full detail, as returned in `BroadcastJoin.broadcast`
/// (`POST /broadcasts/{id}/join`).
class BroadcastOut extends Equatable {
  const BroadcastOut({
    required this.id,
    required this.astrologerId,
    required this.title,
    required this.startedAt,
    this.endedAt,
    required this.currentViewers,
    required this.peakViewers,
    required this.astrologerName,
    this.astrologerPhoto,
    this.giftGoal = 0,
  });

  final String id;
  final String astrologerId;
  final String title;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int currentViewers;
  final int peakViewers;
  final String astrologerName;
  final String? astrologerPhoto;

  /// Host-set gifting goal in ₹ (0 when unset).
  final double giftGoal;

  factory BroadcastOut.fromJson(Map<String, dynamic> j) => BroadcastOut(
        id: '${j['id']}',
        astrologerId: '${j['astrologer_id']}',
        title: (j['title'] as String?)?.trim().isNotEmpty == true
            ? j['title'] as String
            : 'Live session',
        startedAt: j['started_at'] != null
            ? DateTime.tryParse(j['started_at'] as String)
            : null,
        endedAt: j['ended_at'] != null
            ? DateTime.tryParse(j['ended_at'] as String)
            : null,
        currentViewers: (j['current_viewers'] as num?)?.toInt() ?? 0,
        peakViewers: (j['peak_viewers'] as num?)?.toInt() ?? 0,
        astrologerName: (j['astrologer_name'] as String?) ?? 'Astrologer',
        astrologerPhoto: j['astrologer_photo'] as String?,
        giftGoal: double.tryParse('${j['gift_goal'] ?? ''}') ?? 0,
      );

  @override
  List<Object?> get props => [id, currentViewers, peakViewers, title, giftGoal];
}

/// Result of `POST /broadcasts/{id}/join`: the broadcast record plus Agora
/// credentials to join as an audience member.
class BroadcastJoin {
  const BroadcastJoin({required this.broadcast, required this.agora});

  final BroadcastOut broadcast;
  final AgoraGrant agora;

  factory BroadcastJoin.fromJson(Map<String, dynamic> j) => BroadcastJoin(
        broadcast: BroadcastOut.fromJson(j['broadcast'] as Map<String, dynamic>),
        agora: AgoraGrant.fromJson(j['agora'] as Map<String, dynamic>),
      );
}

/// A recorded astrologer video, as returned by the public
/// `GET /astrologer-videos`. These come from their own admin-curated table —
/// they are NOT the Home-screen promo videos. Entries flagged [isLive] belong
/// to an astrologer who is broadcasting right now, so the UI skips them (the
/// live list already shows that stream).
class AstrologerVideo extends Equatable {
  const AstrologerVideo({
    required this.id,
    this.astrologerId,
    this.astrologerName,
    this.astrologerPhoto,
    required this.isLive,
    required this.title,
    required this.videoUrl,
    this.thumbnailUrl,
  });

  final String id;
  final String? astrologerId;
  final String? astrologerName;
  final String? astrologerPhoto;
  final bool isLive;
  final String title;
  final String videoUrl;
  final String? thumbnailUrl;

  factory AstrologerVideo.fromJson(Map<String, dynamic> j) => AstrologerVideo(
        id: '${j['id']}',
        astrologerId: j['astrologer_id'] != null ? '${j['astrologer_id']}' : null,
        astrologerName: j['astrologer_name'] as String?,
        astrologerPhoto: j['astrologer_photo'] as String?,
        isLive: j['is_live'] == true,
        title: (j['title'] as String?)?.trim().isNotEmpty == true
            ? j['title'] as String
            : 'Recorded session',
        videoUrl: '${j['video_url']}',
        thumbnailUrl: j['thumbnail_url'] as String?,
      );

  @override
  List<Object?> get props => [id, isLive, title, videoUrl];
}

/// A single entry of the gift catalog, as returned by `GET /broadcasts/gifts`
/// (public, no auth needed). Feeds the gift-picker sheet.
class BroadcastGift extends Equatable {
  const BroadcastGift({
    required this.giftKey,
    required this.name,
    required this.price,
    this.emoji,
  });

  final String giftKey;
  final String name;

  /// Decimal string, e.g. `'20.00'`.
  final String price;
  final String? emoji;

  factory BroadcastGift.fromJson(Map<String, dynamic> j) => BroadcastGift(
        giftKey: '${j['gift_key']}',
        name: (j['name'] as String?) ?? '${j['gift_key']}',
        price: '${j['price'] ?? '0.00'}',
        emoji: j['emoji'] as String?,
      );

  @override
  List<Object?> get props => [giftKey, name, price, emoji];
}
