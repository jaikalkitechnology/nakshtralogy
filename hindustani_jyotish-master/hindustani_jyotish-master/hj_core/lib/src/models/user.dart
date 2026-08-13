import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    this.name,
    this.mobile,
    this.countryCode,
    this.email,
    this.avatarUrl,
    this.language = 'en',
    this.biometricEnabled = false,
    this.walletBalance = '0.00',
    this.dob,
    this.birthTime,
    this.birthPlace,
    this.gender,
  });

  final String id;
  final String? name;
  final String? mobile;

  /// Dial code for [mobile] (e.g. `+91`). Returned by the backend as
  /// `country_code`; may be null for accounts created before it existed.
  final String? countryCode;
  final String? email;
  final String? avatarUrl;
  final String language;
  final bool biometricEnabled;
  final String walletBalance;
  final String? dob;
  final String? birthTime;
  final String? birthPlace;
  final String? gender;

  /// Signup "Complete Profile" gate: name + contact number (spec §2). Birth
  /// details are no longer collected at signup — they're edited later from
  /// Profile → Birth details and only feed the Kundli/insights features.
  bool get profileComplete =>
      (name?.isNotEmpty ?? false) && (mobile?.isNotEmpty ?? false);

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
        id: j['id'] as String,
        name: j['name'] as String?,
        mobile: j['mobile'] as String?,
        countryCode: j['country_code'] as String?,
        email: j['email'] as String?,
        avatarUrl: j['avatar_url'] as String?,
        language: (j['language'] as String?) ?? 'en',
        biometricEnabled: (j['biometric_enabled'] as bool?) ?? false,
        walletBalance: '${j['wallet_balance'] ?? '0.00'}',
        dob: j['dob'] as String?,
        birthTime: j['birth_time'] as String?,
        birthPlace: j['birth_place'] as String?,
        gender: j['gender'] as String?,
      );

  // Include avatar + birth fields so AuthCubit.updateUser's Equatable
  // comparison doesn't suppress emits when only those change (e.g. saving
  // birth details from Profile must reach the Insights screen immediately).
  @override
  List<Object?> get props => [
        id,
        name,
        mobile,
        countryCode,
        email,
        avatarUrl,
        walletBalance,
        language,
        dob,
        birthTime,
        birthPlace,
        gender,
      ];
}
