import 'package:equatable/equatable.dart';

enum ConsultationType { chat, call, video }

enum ConsultationStatus {
  requested,
  accepted,
  inProgress,
  completed,
  declined,
  cancelled,
  expired,
}

ConsultationType consultationTypeFrom(String s) =>
    ConsultationType.values.firstWhere((e) => e.name == s,
        orElse: () => ConsultationType.chat);

ConsultationStatus consultationStatusFrom(String s) {
  switch (s) {
    case 'in_progress':
      return ConsultationStatus.inProgress;
    default:
      return ConsultationStatus.values
          .firstWhere((e) => e.name == s, orElse: () => ConsultationStatus.requested);
  }
}

class Consultation extends Equatable {
  const Consultation({
    required this.id,
    required this.userId,
    required this.astrologerId,
    required this.type,
    required this.status,
    this.rate = '0.00',
    this.durationSeconds = 0,
    this.messageCount = 0,
    this.amountCharged = '0.00',
    this.astrologerPayout = '0.00',
    this.userRating,
    this.userName,
    this.userAvatarUrl,
    this.astrologerName,
    this.astrologerPhotoUrl,
    this.createdAt,
    this.startedAt,
    this.endedAt,
    this.requestExpiresAt,
  });

  final String id;
  final String userId;
  final String astrologerId;
  final ConsultationType type;
  final ConsultationStatus status;
  final String rate;
  final int durationSeconds;
  final int messageCount;
  final String amountCharged;

  /// The astrologer's net payout for this session — meaningful on the
  /// astrologer's own consultation-history view.
  final String astrologerPayout;

  final int? userRating;

  /// The seeker's display name, when the backend includes it (e.g. the
  /// astrologer's pending-requests endpoint). May be null.
  final String? userName;

  /// The seeker's avatar URL, when provided by the backend. May be null.
  final String? userAvatarUrl;

  /// The astrologer's display name, when the backend includes it (e.g. the
  /// seeker's own consultation-history endpoint). May be null.
  final String? astrologerName;

  /// The astrologer's photo URL, when provided by the backend. May be null.
  final String? astrologerPhotoUrl;

  final DateTime? createdAt;

  /// When the session actually started (the user joined after an accept).
  /// Null for a request that was never accepted.
  final DateTime? startedAt;

  /// When the session actually ended/completed. Null while still active or
  /// if it was declined/cancelled/expired before ever starting.
  final DateTime? endedAt;

  /// The most meaningful single timestamp for a history list: when it was
  /// actually handled (ended), falling back to when it started, falling
  /// back to when it was first requested.
  DateTime? get handledAt => endedAt ?? startedAt ?? createdAt;

  /// When a still-`requested` consultation auto-expires if the astrologer
  /// never responds. Null once it's moved past the requested state.
  final DateTime? requestExpiresAt;

  factory Consultation.fromJson(Map<String, dynamic> j) => Consultation(
        id: j['id'] as String,
        userId: j['user_id'] as String,
        astrologerId: j['astrologer_id'] as String,
        type: consultationTypeFrom(j['type'] as String),
        status: consultationStatusFrom(j['status'] as String),
        rate: '${j['rate'] ?? '0.00'}',
        durationSeconds: (j['duration_seconds'] as int?) ?? 0,
        messageCount: (j['message_count'] as int?) ?? 0,
        amountCharged: '${j['amount_charged'] ?? '0.00'}',
        astrologerPayout: '${j['astrologer_payout'] ?? '0.00'}',
        userRating: j['user_rating'] as int?,
        userName: j['user_name'] as String?,
        userAvatarUrl: j['user_avatar_url'] as String?,
        astrologerName: j['astrologer_name'] as String?,
        astrologerPhotoUrl: j['astrologer_photo_url'] as String?,
        createdAt: j['created_at'] != null
            ? DateTime.tryParse(j['created_at'] as String)
            : null,
        startedAt: j['started_at'] != null
            ? DateTime.tryParse(j['started_at'] as String)
            : null,
        endedAt: j['ended_at'] != null
            ? DateTime.tryParse(j['ended_at'] as String)
            : null,
        requestExpiresAt: j['request_expires_at'] != null
            ? DateTime.tryParse(j['request_expires_at'] as String)
            : null,
      );

  @override
  List<Object?> get props => [id, status, amountCharged, durationSeconds];
}

/// Agora RTC credentials returned by the consultation/live endpoints.
class AgoraGrant {
  const AgoraGrant({
    required this.appId,
    required this.channel,
    required this.uid,
    required this.token,
  });

  final String appId;
  final String channel;
  final int uid;
  final String token;

  /// True when this is a server-side dev/error placeholder, not a real Agora
  /// credential. Joining with it never reaches Agora — it fails deep inside
  /// the native SDK (e.g. AgoraRtcException -7 NOT_INITIALIZED) instead of a
  /// clear error, because the native engine silently fails to initialise with
  /// a bogus App ID.
  ///
  /// NOTE: an EMPTY [token] with a real [appId] is a VALID, intentional case
  /// (an Agora project with no certificate — "App-ID-only" auth) — only the
  /// specific placeholder markers below indicate an actual problem.
  bool get isPlaceholder =>
      appId.isEmpty ||
      appId == 'dev-app-id' ||
      token.startsWith('dev-token:') ||
      token.startsWith('unavailable-token:');

  factory AgoraGrant.fromJson(Map<String, dynamic> j) => AgoraGrant(
        appId: j['app_id'] as String,
        channel: j['channel'] as String,
        uid: j['uid'] as int,
        token: j['token'] as String,
      );
}
