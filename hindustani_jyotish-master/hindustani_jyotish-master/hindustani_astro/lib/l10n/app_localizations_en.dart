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
  String get profileAccountSection => 'Account';

  @override
  String get profileEditProfile => 'Edit Profile';

  @override
  String get profileEditProfileSub =>
      'Name, bio, skills, languages, rates & photo';

  @override
  String get profileBankPan => 'Bank & PAN details';

  @override
  String get profileBankPanSub => 'Payout method, bank account & PAN';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileSubtitle =>
      'Update how seekers see you and what you charge.';

  @override
  String get bankPanTitle => 'Bank & PAN details';

  @override
  String get bankPanIntro =>
      'Your payout and identity details, used for withdrawals and verification.';

  @override
  String get bankPanPayoutSection => 'Payout method';

  @override
  String get bankPanIdentitySection => 'Identity';

  @override
  String get bankPanDocsSection => 'Documents';

  @override
  String get bankPanBankName => 'Bank name';

  @override
  String get bankPanIfsc => 'IFSC code';

  @override
  String get bankPanAccountHolder => 'Account holder';

  @override
  String get bankPanAccountNumber => 'Account number';

  @override
  String get bankPanUpiId => 'UPI ID';

  @override
  String get bankPanPan => 'PAN number';

  @override
  String get bankPanAadhaar => 'Aadhaar number';

  @override
  String bankPanMasked(String last4) {
    return '•••• $last4';
  }

  @override
  String get bankPanNotSet => 'Not set';

  @override
  String get bankPanEditCta => 'Edit bank & PAN details';

  @override
  String get bankPanAddCta => 'Add bank & PAN details';

  @override
  String get bankPanApprovalNote =>
      'Changes to bank or PAN details are submitted for admin approval and apply once approved.';

  @override
  String get bankPanEmpty => 'You haven\'t added your bank & PAN details yet.';

  @override
  String get bankPanLoadFailed => 'Could not load your bank & PAN details.';

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

  @override
  String get callIncomingVoice => 'Incoming voice call';

  @override
  String get callIncomingVideo => 'Incoming video call';

  @override
  String callRatePerMin(String rate) {
    return '₹$rate/min';
  }

  @override
  String callAutoDeclineIn(int seconds) {
    return 'Auto-decline in ${seconds}s';
  }

  @override
  String get callAccept => 'Accept';

  @override
  String get callDecline => 'Decline';

  @override
  String get callConnecting => 'Connecting…';

  @override
  String get callExpired => 'Call expired';

  @override
  String get callExpiredBody => 'This call request is no longer available.';

  @override
  String get callCouldNotStart =>
      'Call could not start: the server did not return Agora call details.';

  @override
  String get commonSeeker => 'Seeker';

  @override
  String get commonClose => 'Close';

  @override
  String get commonUser => 'User';

  @override
  String get commonEnd => 'End';

  @override
  String get callPermMic =>
      'Microphone permission is required to take this call. Enable it in Settings and try again.';

  @override
  String get callPermMicCam =>
      'Microphone and camera permission is required to take this call. Enable it in Settings and try again.';

  @override
  String get callAvUnavailable =>
      'Astrologer A/V not available — server Agora token missing.';

  @override
  String callConnectFailed(String error) {
    return 'Could not connect the call: $error';
  }

  @override
  String get callEndConfirmTitle => 'End this call?';

  @override
  String get callEndConfirmBody =>
      'The seeker will be disconnected and this session will end. This can\'t be undone.';

  @override
  String callEndedBy(String name) {
    return 'Call ended by $name';
  }

  @override
  String get callCantConnect => 'Couldn\'t connect';

  @override
  String get callReconnecting => 'Reconnecting…';

  @override
  String get callConnected => 'Connected';

  @override
  String get callWaitingForSeeker => 'Waiting for the seeker…';

  @override
  String get callVideoTitle => 'Video Call';

  @override
  String get callAudioTitle => 'Audio Call';

  @override
  String callEarningsSoFar(String amount) {
    return 'Earnings so far: ₹$amount';
  }

  @override
  String callRateDotPerMin(String rate) {
    return '· ₹$rate/min';
  }

  @override
  String get callPillCantConnect => 'Can\'t connect';

  @override
  String get callPillConnecting => 'Connecting';

  @override
  String get callPillReconnecting => 'Reconnecting';

  @override
  String get callPillWaiting => 'Waiting';

  @override
  String callPillLive(String elapsed) {
    return 'Live · $elapsed';
  }

  @override
  String get chatReconnecting => 'Reconnecting…';

  @override
  String chatWithName(String name) {
    return 'Chat with $name';
  }

  @override
  String get chatEnded => 'Ended';

  @override
  String get chatLive => 'Live';

  @override
  String get chatWaitingNamaste => 'Waiting for the seeker to say Namaste 🙏';

  @override
  String get chatSending => 'Sending…';

  @override
  String get chatNotSentRetry => 'Not sent · Tap to retry';

  @override
  String get chatReplyHint => 'Reply…';

  @override
  String get chatEndedHint => 'Chat ended';

  @override
  String get chatSendTooltip => 'Send message';

  @override
  String get liveDefaultTitle => 'Evening Rashifal';

  @override
  String get liveSetRatesFirst =>
      'Set your chat, call, and video rates before going live.';

  @override
  String get liveMessageSent => 'Message sent';

  @override
  String get liveMessageSendFailed =>
      'Couldn\'t send — reconnecting to chat, try again in a moment.';

  @override
  String get livePinFailed =>
      'Couldn\'t pin — reconnecting to chat, try again.';

  @override
  String get liveSetGiftGoalTitle => 'Set gifting goal';

  @override
  String get liveGiftGoalHint => 'e.g. 5000';

  @override
  String get liveEndConfirmTitle => 'End live broadcast?';

  @override
  String get liveEndConfirmBody =>
      'Your viewers will be disconnected and this session will end. This can\'t be undone.';

  @override
  String get liveStartTitle => 'Start a live session';

  @override
  String get liveStartSubtitle =>
      'Your followers get notified when you go live.';

  @override
  String get liveStreamTitleLabel => 'Stream title';

  @override
  String get liveStarting => 'Starting…';

  @override
  String get liveGiftGoalTooltip => 'Gifting goal';

  @override
  String get liveFlipCamera => 'Flip camera';

  @override
  String get liveReconnectingVideo => 'Reconnecting video…';

  @override
  String get liveReconnectingChat => 'Reconnecting chat…';

  @override
  String get liveChatEmpty => 'Viewer messages will appear here…';

  @override
  String liveReplyingTo(String name) {
    return 'Replying to @$name';
  }

  @override
  String liveReplyHint(String name) {
    return 'Reply to @$name…';
  }

  @override
  String get liveSayHiHint => 'Say hi to your viewers…';

  @override
  String get liveWrapTitle => 'That’s a wrap!';

  @override
  String get liveWrapSubtitle => 'Here’s how your session went.';

  @override
  String get liveDuration => 'Duration';

  @override
  String get livePeakViewers => 'Peak viewers';

  @override
  String get liveBadge => 'LIVE';

  @override
  String get liveEndButton => 'End Live';

  @override
  String get liveMuteMic => 'Mute microphone';

  @override
  String get liveUnmuteMic => 'Unmute microphone';

  @override
  String get liveGift => 'Gift';

  @override
  String get liveAnsweringNow => 'Answering now — ';

  @override
  String get commonErrorGeneric => 'Something went wrong. Please try again.';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountWarning =>
      'This permanently deletes your astrologer account. Your profile and KYC are removed, you are taken offline and hidden from discovery, all your sessions end, and this cannot be undone. Withdraw any balance and finish open consultations first.';

  @override
  String get deleteAccountTypeHint => 'Type DELETE to confirm';

  @override
  String get deleteAccountConfirm => 'Delete account';

  @override
  String get deleteAccountSuccess => 'Your account has been deleted.';

  @override
  String get earningsAddPanTitle => 'Add your PAN to withdraw';

  @override
  String get earningsAddPanBody =>
      'TDS is deducted against your PAN on every payout. Add a valid PAN in your bank & PAN details before you can withdraw.';

  @override
  String get earningsAddPanAction => 'Add PAN';

  @override
  String earningsTdsNote(String rate) {
    return '$rate% TDS is deducted against your PAN on each payout.';
  }

  @override
  String get earningsRecentPayouts => 'Recent withdrawals';

  @override
  String get earningsPayoutTds => 'TDS';

  @override
  String get earningsPayoutNet => 'Net paid';

  @override
  String get earningsPayoutGross => 'Gross';

  @override
  String get earningsNoPayouts => 'No withdrawals yet.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'You have no notifications yet.';

  @override
  String get notificationsMarkAllRead => 'Mark all read';
}
