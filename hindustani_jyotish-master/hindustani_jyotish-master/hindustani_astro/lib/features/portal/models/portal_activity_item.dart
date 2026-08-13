import 'package:equatable/equatable.dart';
import 'package:hj_core/hj_core.dart';

/// The discriminator on `GET /astrologer/activity` — a merged,
/// chronologically-sorted feed of the astrologer's own consultations plus
/// Super Chat/Gift income received during their live streams.
enum PortalActivityKind { consultation, superChat, gift }

PortalActivityKind _kindFrom(String s) => switch (s) {
      'super_chat' => PortalActivityKind.superChat,
      'gift' => PortalActivityKind.gift,
      _ => PortalActivityKind.consultation,
    };

/// One row of the astrologer's combined activity feed.
///
/// Deliberately a local model (not the `hj_core` `ActivityItem` used by the
/// user app's own activity feed) — this view needs `astrologerPayout`
/// (the astrologer's net earning per consultation, distinct from
/// `amountCharged` which is what the seeker paid), which the seeker-facing
/// shared model doesn't carry. Kept local to `hindustani_astro` rather than
/// widening the shared model to avoid clashing with the shared-model work
/// landing in `hj_core` concurrently for the user app.
class PortalActivityItem extends Equatable {
  const PortalActivityItem({
    required this.id,
    required this.kind,
    required this.timestamp,
    this.counterpartName,
    this.counterpartPhotoUrl,
    // Consultation fields.
    this.type,
    this.status,
    this.astrologerPayout,
    // Gift / super-chat fields.
    this.amount,
    this.giftName,
    this.giftEmoji,
    this.message,
  });

  final String id;
  final PortalActivityKind kind;
  final DateTime timestamp;

  /// The seeker's name/photo, whichever kind this item is.
  final String? counterpartName;
  final String? counterpartPhotoUrl;

  // -- kind == consultation --
  final ConsultationType? type;
  final ConsultationStatus? status;

  /// The astrologer's net payout for a completed consultation.
  final String? astrologerPayout;

  // -- kind == superChat | gift --
  /// The gift/super-chat amount — always a credit to the astrologer.
  final String? amount;
  final String? giftName;
  final String? giftEmoji;

  /// The super-chat's pinned overlay message. Null for gifts/consultations.
  final String? message;

  bool get isConsultation => kind == PortalActivityKind.consultation;

  /// The amount to display for this row — the astrologer's payout for a
  /// consultation, or the gift/super-chat amount otherwise. Always a
  /// credit/earning from the astrologer's perspective.
  String get displayAmount => isConsultation ? (astrologerPayout ?? '0.00') : (amount ?? '0.00');

  factory PortalActivityItem.fromJson(Map<String, dynamic> j) => PortalActivityItem(
        id: j['id'] as String,
        kind: _kindFrom(j['kind'] as String),
        timestamp: DateTime.tryParse(j['timestamp'] as String) ?? DateTime.now(),
        counterpartName: j['counterpart_name'] as String?,
        counterpartPhotoUrl: j['counterpart_photo_url'] as String?,
        type: j['type'] != null ? consultationTypeFrom(j['type'] as String) : null,
        status: j['status'] != null ? consultationStatusFrom(j['status'] as String) : null,
        astrologerPayout:
            j['astrologer_payout'] != null ? '${j['astrologer_payout']}' : null,
        amount: j['amount'] != null ? '${j['amount']}' : null,
        giftName: j['gift_name'] as String?,
        giftEmoji: j['gift_emoji'] as String?,
        message: j['message'] as String?,
      );

  @override
  List<Object?> get props => [id, kind, timestamp, displayAmount];
}
