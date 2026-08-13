import 'package:equatable/equatable.dart';

class Astrologer extends Equatable {
  const Astrologer({
    required this.id,
    this.displayName,
    this.photoUrl,
    this.bio,
    this.skills = const [],
    this.languages = const [],
    this.yearsExperience = 0,
    this.rateChatPerMsg = '0.00',
    this.rateCallPerMin = '0.00',
    this.rateVideoPerMin = '0.00',
    this.superChatPresets = const [],
    this.isOnline = false,
    this.isLive = false,
    this.avgRating = '0.00',
    this.reviewCount = 0,
    this.followerCount = 0,
    this.kycStatus = 'pending',
    this.kycSubmittedAt,
    this.profileCompleted = false,
    this.pendingEdit,
    this.mobile,
    this.countryCode,
  });

  final String id;
  final String? displayName;
  final String? photoUrl;
  final String? bio;
  final List<String> skills;
  final List<String> languages;
  final int yearsExperience;
  final String rateChatPerMsg;
  final String rateCallPerMin;
  final String rateVideoPerMin;
  final bool isOnline;
  final bool isLive;
  final String avgRating;
  final int reviewCount;
  final int followerCount;
  final String kycStatus;

  /// Only ever populated on the astrologer's own `/astrologer/me` / OTP /
  /// Google-verify responses (`AstrologerMeOut`), never the public directory
  /// listing — null until the astrologer has actually submitted the KYC
  /// form, distinguishing "brand new, never touched KYC" from "genuinely
  /// submitted, awaiting review" (both otherwise look like `kycStatus ==
  /// 'pending'`).
  final DateTime? kycSubmittedAt;

  /// Same self-only scope as [kycSubmittedAt]. True once display_name,
  /// photo_url, bio, skills, languages, and all three rates are set —
  /// derived server-side, defaults to false for any other caller's payload
  /// (e.g. the public directory) that doesn't send this field at all.
  final bool profileCompleted;

  /// Decimal-string amounts (e.g. `'50.00'`) this astrologer has configured
  /// as selectable Super Chat presets — empty until they've set any up.
  /// `POST /broadcasts/{id}/super-chat` only accepts an exact match to one
  /// of these; there is no free-text amount entry.
  final List<String> superChatPresets;

  /// Self-only (`AstrologerMeOut`) — non-null when a KYC-approved
  /// astrologer's profile edit is awaiting (or was rejected by) admin
  /// review. Shape: `{"id", "status": "pending"|"rejected", "changes":
  /// {...}, "submitted_at", "reviewed_at", "reviewer_notes"}`. Kept as a
  /// raw map (parsed defensively — absent/malformed payloads yield null)
  /// so new backend fields don't require a model change.
  final Map<String, dynamic>? pendingEdit;

  /// Contact number + its dial code (e.g. `'9876543210'` / `'+91'`). Only on
  /// the astrologer's own `AstrologerMeOut` payloads (same self-only scope as
  /// [kycSubmittedAt]) — never in public listings, so both stay null there.
  /// Parsed defensively: any absent or non-string value yields null.
  final String? mobile;
  final String? countryCode;

  bool get isApproved => kycStatus == 'approved';

  static List<String> _strList(dynamic v) =>
      (v as List?)?.map((e) => '$e').toList() ?? const [];

  factory Astrologer.fromJson(Map<String, dynamic> j) => Astrologer(
        id: j['id'] as String,
        displayName: j['display_name'] as String?,
        photoUrl: j['photo_url'] as String?,
        bio: j['bio'] as String?,
        skills: _strList(j['skills']),
        languages: _strList(j['languages']),
        yearsExperience: (j['years_experience'] as int?) ?? 0,
        rateChatPerMsg: '${j['rate_chat_per_msg'] ?? '0.00'}',
        rateCallPerMin: '${j['rate_call_per_min'] ?? '0.00'}',
        rateVideoPerMin: '${j['rate_video_per_min'] ?? '0.00'}',
        isOnline: (j['is_online'] as bool?) ?? false,
        isLive: (j['is_live'] as bool?) ?? false,
        avgRating: '${j['avg_rating'] ?? '0.00'}',
        reviewCount: (j['review_count'] as int?) ?? 0,
        followerCount: (j['follower_count'] as int?) ?? 0,
        kycStatus: (j['kyc_status'] as String?) ?? 'pending',
        kycSubmittedAt: j['kyc_submitted_at'] != null
            ? DateTime.tryParse(j['kyc_submitted_at'] as String)
            : null,
        profileCompleted: (j['profile_completed'] as bool?) ?? false,
        superChatPresets: _strList(j['super_chat_presets']),
        pendingEdit: j['pending_edit'] is Map
            ? Map<String, dynamic>.from(j['pending_edit'] as Map)
            : null,
        mobile: j['mobile'] is String ? j['mobile'] as String : null,
        countryCode: j['country_code'] is String ? j['country_code'] as String : null,
      );

  @override
  List<Object?> get props => [
        id,
        displayName,
        isOnline,
        isLive,
        avgRating,
        pendingEdit?['id'],
        pendingEdit?['status'],
        mobile,
        countryCode,
      ];
}
