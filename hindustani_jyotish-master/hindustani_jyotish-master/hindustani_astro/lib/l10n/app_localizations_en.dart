// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hindustani Jyotish — Astrologer';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDone => 'Done';

  @override
  String get commonSettings => 'Settings';

  @override
  String get commonSignOut => 'Sign out';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navRequests => 'Requests';

  @override
  String get navEarnings => 'Earnings';

  @override
  String get navProfile => 'Profile';

  @override
  String get authApplyTitle => 'Apply as Astrologer';

  @override
  String get authApplySubtitle =>
      'Single dashboard for all your consultations & earnings.';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get dashWelcomeBack => 'Welcome back';

  @override
  String dashReviews(Object count) {
    return '$count reviews';
  }

  @override
  String get dashOnline => 'You\'re Online';

  @override
  String get dashOffline => 'You\'re Offline';

  @override
  String get dashOnlineSubtitle => 'Receiving consultation requests';

  @override
  String get dashOfflineSubtitle => 'Toggle to start receiving requests';

  @override
  String get dashGoLive => 'Go Live';

  @override
  String get dashRequests => 'Requests';

  @override
  String get dashSettings => 'Settings';

  @override
  String get dashSettingsSubtitle => 'Charges, bio, languages & photo';

  @override
  String get statTodayEarnings => 'Today\'s earnings';

  @override
  String get statBalance => 'Balance';

  @override
  String get statTodayConsults => 'Today consults';

  @override
  String get statTotalConsults => 'Total consults';

  @override
  String get statRating => 'Rating';

  @override
  String get statFollowers => 'Followers';

  @override
  String get reqTitle => 'Incoming Requests';

  @override
  String get reqEmpty => 'No pending requests.\nPull down to refresh.';

  @override
  String reqRequestLabel(String kind) {
    return '$kind request';
  }

  @override
  String get reqDecline => 'Decline';

  @override
  String get reqAccept => 'Accept';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileAstrologer => 'Astrologer';

  @override
  String get profileSkills => 'Skills';

  @override
  String get profileLanguages => 'Languages';

  @override
  String get profileExperience => 'Experience';

  @override
  String get profileRating => 'Rating';

  @override
  String get profileChatRate => 'Chat rate';

  @override
  String get profileCallRate => 'Call rate';

  @override
  String get profileVideoRate => 'Video rate';

  @override
  String profileYears(Object years) {
    return '$years yrs';
  }

  @override
  String get profileEditCharges => 'Edit profile & charges';

  @override
  String get setTitle => 'Settings';

  @override
  String get setChangePhoto => 'Tap the camera to change your photo';

  @override
  String get setCharges => 'Charges';

  @override
  String get setChatRate => 'Chat rate';

  @override
  String get setCallRate => 'Call rate';

  @override
  String get setVideoRate => 'Video rate';

  @override
  String get setPerMessage => '₹ / message';

  @override
  String get setPerMinute => '₹ / minute';

  @override
  String get setSuperChatRate => 'Super Chat price';

  @override
  String get setPerSuperChat => '₹ / super chat';

  @override
  String get setSuperChatInvalid =>
      'Enter a valid Super Chat price (greater than ₹0).';

  @override
  String get setSuperChatMax => 'The Super Chat price must not exceed ₹10000.';

  @override
  String get setAboutYou => 'About you';

  @override
  String get setDisplayName => 'Display name';

  @override
  String get setBio => 'Bio';

  @override
  String get setBioHint => 'Tell seekers about your practice…';

  @override
  String get setSkills => 'Skills';

  @override
  String get setSkillsHint => 'Vedic, Tarot, Numerology';

  @override
  String get setLanguagesField => 'Languages';

  @override
  String get setLanguagesHint => 'Hindi, English';

  @override
  String get setCommaSeparated => 'Comma-separated';

  @override
  String get setKycDocsTitle => 'KYC documents';

  @override
  String get setKycDocsSubtitle =>
      'The identity documents you submitted for verification.';

  @override
  String get setKycDocsLocked =>
      'Documents are locked after approval. Contact support to update them.';

  @override
  String get setKycResubmit => 'Update KYC documents';

  @override
  String get setKycUpdateButton => 'Update KYC / payout details';

  @override
  String get setKycUpdateNote => 'Changes will apply after admin approval.';

  @override
  String get setKycNotUploaded => 'Not uploaded';

  @override
  String get setKycLoadFailed => 'Could not load KYC documents.';

  @override
  String get setDocPhoto => 'Photo';

  @override
  String get setDocPan => 'PAN card';

  @override
  String get setDocAadhaar => 'Aadhaar front';

  @override
  String get setDocAadhaarBack => 'Aadhaar back';

  @override
  String get setDocBankProof => 'Bank proof';

  @override
  String get setDocCertificate => 'Certificate';

  @override
  String get setPayoutMethodLabel => 'Payout method';

  @override
  String get setPayoutUpi => 'UPI';

  @override
  String get setPayoutBank => 'Bank account';

  @override
  String get setSaveChanges => 'Save changes';

  @override
  String get setSaving => 'Saving…';

  @override
  String get setProfileUpdated => 'Profile updated';

  @override
  String get setPhotoUpdated => 'Photo updated';

  @override
  String get setChangesPendingApproval =>
      'Changes submitted for admin approval — they\'ll go live once approved.';

  @override
  String get setPendingEditBanner =>
      'Your profile changes are awaiting admin approval.';

  @override
  String get setPendingEditRejected =>
      'Your recent profile changes were rejected.';

  @override
  String setPendingEditFields(String fields) {
    return 'Changed fields: $fields';
  }

  @override
  String get setFieldMobile => 'Contact number';

  @override
  String get setFieldCountryCode => 'Country code';

  @override
  String get setFieldKyc => 'KYC / payout details';

  @override
  String get appLanguageSection => 'App';

  @override
  String get appLanguage => 'Language / भाषा';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageSystem => 'System default';

  @override
  String get profileTheme => 'Appearance';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System default';
}
