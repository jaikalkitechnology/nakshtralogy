import 'package:equatable/equatable.dart';

import 'consultation.dart';

/// One row of `GET /me/activity` / `GET /astrologer/activity` — the
/// "Consultation History" screens. Consultation-only: the backend's old
/// merged feed (which also carried live super-chat/gift spending) was
/// removed along with the rest of that monetization surface.
class ActivityItem extends Equatable {
  const ActivityItem({
    required this.id,
    required this.timestamp,
    this.counterpartName,
    this.counterpartPhotoUrl,
    this.type,
    this.status,
    this.rate,
    this.durationSeconds,
    this.messageCount,
    this.amountCharged,
    this.userRating,
  });

  final String id;

  /// Server-resolved "most meaningful" instant for this item — already
  /// accounts for ended_at/started_at/created_at fallback, so this alone is
  /// enough to sort/label any item.
  final DateTime timestamp;

  /// The other party's display name/photo — the astrologer, from a user's
  /// own feed (or the seeker, from an astrologer's feed).
  final String? counterpartName;
  final String? counterpartPhotoUrl;

  final ConsultationType? type;
  final ConsultationStatus? status;
  final String? rate;
  final int? durationSeconds;
  final int? messageCount;
  final String? amountCharged;
  final int? userRating;

  /// The charge to show for this row.
  String get displayAmount => amountCharged ?? '0.00';

  factory ActivityItem.fromJson(Map<String, dynamic> j) => ActivityItem(
    id: j['id'] as String,
    timestamp: DateTime.tryParse(j['timestamp'] as String) ?? DateTime.now(),
    counterpartName: j['counterpart_name'] as String?,
    counterpartPhotoUrl: j['counterpart_photo_url'] as String?,
    type: j['type'] != null ? consultationTypeFrom(j['type'] as String) : null,
    status: j['status'] != null
        ? consultationStatusFrom(j['status'] as String)
        : null,
    rate: j['rate'] != null ? '${j['rate']}' : null,
    durationSeconds: j['duration_seconds'] as int?,
    messageCount: j['message_count'] as int?,
    amountCharged: j['amount_charged'] != null
        ? '${j['amount_charged']}'
        : null,
    userRating: j['user_rating'] as int?,
  );

  @override
  List<Object?> get props => [id, timestamp, displayAmount];
}
