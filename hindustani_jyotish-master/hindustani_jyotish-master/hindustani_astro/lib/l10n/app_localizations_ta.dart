// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'இந்துஸ்தானி ஜோதிடம் — ஜோதிடர்';

  @override
  String get commonOk => 'சரி';

  @override
  String get commonCancel => 'ரத்து செய்';

  @override
  String get commonRetry => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get commonSave => 'சேமி';

  @override
  String get commonDone => 'முடிந்தது';

  @override
  String get commonSettings => 'அமைப்புகள்';

  @override
  String get commonSignOut => 'வெளியேறு';

  @override
  String get navDashboard => 'டாஷ்போர்டு';

  @override
  String get navRequests => 'கோரிக்கைகள்';

  @override
  String get navEarnings => 'வருமானம்';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String get authApplyTitle => 'ஜோதிடராக விண்ணப்பிக்கவும்';

  @override
  String get authApplySubtitle =>
      'உங்கள் அனைத்து ஆலோசனைகள் மற்றும் வருமானத்திற்கான ஒரே டாஷ்போர்டு.';

  @override
  String get authContinueWithGoogle => 'Google மூலம் தொடரவும்';

  @override
  String get dashWelcomeBack => 'மீண்டும் வருக';

  @override
  String dashReviews(Object count) {
    return '$count விமர்சனங்கள்';
  }

  @override
  String get dashOnline => 'நீங்கள் ஆன்லைனில் உள்ளீர்கள்';

  @override
  String get dashOffline => 'நீங்கள் ஆஃப்லைனில் உள்ளீர்கள்';

  @override
  String get dashOnlineSubtitle => 'ஆலோசனை கோரிக்கைகள் பெறப்படுகின்றன';

  @override
  String get dashOfflineSubtitle =>
      'கோரிக்கைகளைப் பெறத் தொடங்க டோகிள் செய்யவும்';

  @override
  String get dashGoLive => 'நேரலைக்குச் செல்';

  @override
  String get dashRequests => 'கோரிக்கைகள்';

  @override
  String get dashSettings => 'அமைப்புகள்';

  @override
  String get dashSettingsSubtitle =>
      'கட்டணங்கள், அறிமுகம், மொழிகள் மற்றும் புகைப்படம்';

  @override
  String get statTodayEarnings => 'இன்றைய வருமானம்';

  @override
  String get statBalance => 'மீதி';

  @override
  String get statTodayConsults => 'இன்றைய ஆலோசனைகள்';

  @override
  String get statTotalConsults => 'மொத்த ஆலோசனைகள்';

  @override
  String get statRating => 'மதிப்பீடு';

  @override
  String get statFollowers => 'பின்தொடர்பவர்கள்';

  @override
  String get reqTitle => 'வரும் கோரிக்கைகள்';

  @override
  String get reqEmpty =>
      'நிலுவையில் உள்ள கோரிக்கைகள் இல்லை.\nபுதுப்பிக்க கீழே இழுக்கவும்.';

  @override
  String reqRequestLabel(String kind) {
    return '$kind கோரிக்கை';
  }

  @override
  String get reqDecline => 'நிராகரி';

  @override
  String get reqAccept => 'ஏற்றுக்கொள்';

  @override
  String get profileTitle => 'சுயவிவரம்';

  @override
  String get profileAstrologer => 'ஜோதிடர்';

  @override
  String get profileSkills => 'திறமைகள்';

  @override
  String get profileLanguages => 'மொழிகள்';

  @override
  String get profileExperience => 'அனுபவம்';

  @override
  String get profileRating => 'மதிப்பீடு';

  @override
  String get profileChatRate => 'அரட்டை கட்டணம்';

  @override
  String get profileCallRate => 'அழைப்பு கட்டணம்';

  @override
  String get profileVideoRate => 'வீடியோ கட்டணம்';

  @override
  String profileYears(Object years) {
    return '$years ஆண்டுகள்';
  }

  @override
  String get profileEditCharges => 'சுயவிவரம் மற்றும் கட்டணங்களைத் திருத்து';

  @override
  String get profileAccountSection => 'கணக்கு';

  @override
  String get profileEditProfile => 'சுயவிவரத்தைத் திருத்து';

  @override
  String get profileEditProfileSub =>
      'பெயர், அறிமுகம், திறமைகள், மொழிகள், விகிதங்கள் மற்றும் புகைப்படம்';

  @override
  String get profileBankPan => 'வங்கி மற்றும் PAN விவரங்கள்';

  @override
  String get profileBankPanSub =>
      'பணம் பெறும் முறை, வங்கிக் கணக்கு மற்றும் PAN';

  @override
  String get editProfileTitle => 'சுயவிவரத்தைத் திருத்து';

  @override
  String get editProfileSubtitle =>
      'தேடுபவர்கள் உங்களை எப்படிப் பார்க்கிறார்கள் மற்றும் நீங்கள் என்ன கட்டணம் வசூலிக்கிறீர்கள் என்பதைப் புதுப்பிக்கவும்.';

  @override
  String get bankPanTitle => 'வங்கி மற்றும் PAN விவரங்கள்';

  @override
  String get bankPanIntro =>
      'திரும்பப் பெறுதல் மற்றும் சரிபார்ப்புக்குப் பயன்படுத்தப்படும் உங்கள் பணம் பெறும் மற்றும் அடையாள விவரங்கள்.';

  @override
  String get bankPanPayoutSection => 'பணம் பெறும் முறை';

  @override
  String get bankPanIdentitySection => 'அடையாளம்';

  @override
  String get bankPanDocsSection => 'ஆவணங்கள்';

  @override
  String get bankPanBankName => 'வங்கியின் பெயர்';

  @override
  String get bankPanIfsc => 'IFSC குறியீடு';

  @override
  String get bankPanAccountHolder => 'கணக்கு வைத்திருப்பவர்';

  @override
  String get bankPanAccountNumber => 'கணக்கு எண்';

  @override
  String get bankPanUpiId => 'UPI ஐடி';

  @override
  String get bankPanPan => 'PAN எண்';

  @override
  String get bankPanAadhaar => 'ஆதார் எண்';

  @override
  String bankPanMasked(String last4) {
    return '•••• $last4';
  }

  @override
  String get bankPanNotSet => 'அமைக்கப்படவில்லை';

  @override
  String get bankPanEditCta => 'வங்கி மற்றும் PAN விவரங்களைத் திருத்து';

  @override
  String get bankPanAddCta => 'வங்கி மற்றும் PAN விவரங்களைச் சேர்';

  @override
  String get bankPanApprovalNote =>
      'வங்கி அல்லது PAN விவரங்களில் மாற்றங்கள் நிர்வாக ஒப்புதலுக்காக சமர்ப்பிக்கப்படும், ஒப்புதல் அளிக்கப்பட்டதும் அமலுக்கு வரும்.';

  @override
  String get bankPanEmpty =>
      'நீங்கள் இதுவரை உங்கள் வங்கி மற்றும் PAN விவரங்களைச் சேர்க்கவில்லை.';

  @override
  String get bankPanLoadFailed =>
      'உங்கள் வங்கி மற்றும் PAN விவரங்களை ஏற்ற முடியவில்லை.';

  @override
  String get setTitle => 'அமைப்புகள்';

  @override
  String get setChangePhoto => 'உங்கள் புகைப்படத்தை மாற்ற கேமராவைத் தட்டவும்';

  @override
  String get setCharges => 'கட்டணங்கள்';

  @override
  String get setChatRate => 'அரட்டை கட்டணம்';

  @override
  String get setCallRate => 'அழைப்பு கட்டணம்';

  @override
  String get setVideoRate => 'வீடியோ கட்டணம்';

  @override
  String get setPerMessage => '₹ / செய்தி';

  @override
  String get setPerMinute => '₹ / நிமிடம்';

  @override
  String get setSuperChatRate => 'சூப்பர் சாட் விலை';

  @override
  String get setPerSuperChat => '₹ / சூப்பர் சாட்';

  @override
  String get setSuperChatInvalid =>
      'சரியான சூப்பர் சாட் விலையை உள்ளிடவும் (₹0க்கு மேல்).';

  @override
  String get setSuperChatMax => 'சூப்பர் சாட் விலை ₹10000ஐ மீறக்கூடாது.';

  @override
  String get setAboutYou => 'உங்களைப் பற்றி';

  @override
  String get setDisplayName => 'காட்சிப் பெயர்';

  @override
  String get setBio => 'அறிமுகம்';

  @override
  String get setBioHint =>
      'உங்கள் பயிற்சியைப் பற்றி தேடுபவர்களிடம் சொல்லுங்கள்…';

  @override
  String get setSkills => 'திறமைகள்';

  @override
  String get setSkillsHint => 'வேதம், டாரோ, எண் கணிதம்';

  @override
  String get setLanguagesField => 'மொழிகள்';

  @override
  String get setLanguagesHint => 'இந்தி, ஆங்கிலம்';

  @override
  String get setCommaSeparated => 'காற்புள்ளியால் பிரிக்கப்பட்டது';

  @override
  String get setKycDocsTitle => 'KYC ஆவணங்கள்';

  @override
  String get setKycDocsSubtitle =>
      'சரிபார்ப்புக்காக நீங்கள் சமர்ப்பித்த அடையாள ஆவணங்கள்.';

  @override
  String get setKycDocsLocked =>
      'ஒப்புதலுக்குப் பிறகு ஆவணங்கள் பூட்டப்படும். அவற்றைப் புதுப்பிக்க ஆதரவுக் குழுவைத் தொடர்பு கொள்ளவும்.';

  @override
  String get setKycResubmit => 'KYC ஆவணங்களைப் புதுப்பி';

  @override
  String get setKycUpdateButton => 'KYC / பணம் பெறும் விவரங்களைப் புதுப்பி';

  @override
  String get setKycUpdateNote =>
      'நிர்வாக ஒப்புதலுக்குப் பிறகு மாற்றங்கள் அமலுக்கு வரும்.';

  @override
  String get setKycNotUploaded => 'பதிவேற்றப்படவில்லை';

  @override
  String get setKycLoadFailed => 'KYC ஆவணங்களை ஏற்ற முடியவில்லை.';

  @override
  String get setDocPhoto => 'புகைப்படம்';

  @override
  String get setDocPan => 'PAN அட்டை';

  @override
  String get setDocAadhaar => 'ஆதார் (முன் பக்கம்)';

  @override
  String get setDocAadhaarBack => 'ஆதார் (பின் பக்கம்)';

  @override
  String get setDocBankProof => 'வங்கி சான்று';

  @override
  String get setDocCertificate => 'சான்றிதழ்';

  @override
  String get setPayoutMethodLabel => 'பணம் பெறும் முறை';

  @override
  String get setPayoutUpi => 'UPI';

  @override
  String get setPayoutBank => 'வங்கிக் கணக்கு';

  @override
  String get setSaveChanges => 'மாற்றங்களைச் சேமி';

  @override
  String get setSaving => 'சேமிக்கப்படுகிறது…';

  @override
  String get setProfileUpdated => 'சுயவிவரம் புதுப்பிக்கப்பட்டது';

  @override
  String get setPhotoUpdated => 'புகைப்படம் புதுப்பிக்கப்பட்டது';

  @override
  String get setChangesPendingApproval =>
      'மாற்றங்கள் நிர்வாக ஒப்புதலுக்காக சமர்ப்பிக்கப்பட்டன — ஒப்புதல் அளிக்கப்பட்டதும் அவை அமலுக்கு வரும்.';

  @override
  String get setPendingEditBanner =>
      'உங்கள் சுயவிவர மாற்றங்கள் நிர்வாக ஒப்புதலுக்காக காத்திருக்கின்றன.';

  @override
  String get setPendingEditRejected =>
      'உங்கள் சமீபத்திய சுயவிவர மாற்றங்கள் நிராகரிக்கப்பட்டன.';

  @override
  String setPendingEditFields(String fields) {
    return 'மாற்றப்பட்ட புலங்கள்: $fields';
  }

  @override
  String get setFieldMobile => 'தொடர்பு எண்';

  @override
  String get setFieldCountryCode => 'நாட்டுக் குறியீடு';

  @override
  String get setFieldKyc => 'KYC / பணம் பெறும் விவரங்கள்';

  @override
  String get appLanguageSection => 'ஆப்';

  @override
  String get appLanguage => 'மொழி / Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languageGujarati => 'ગુજરાતી';

  @override
  String get languageKannada => 'ಕನ್ನಡ';

  @override
  String get languageMalayalam => 'മലയാളം';

  @override
  String get languageMarathi => 'मराठी';

  @override
  String get languagePunjabi => 'ਪੰਜਾਬੀ';

  @override
  String get languageTamil => 'தமிழ்';

  @override
  String get languageTelugu => 'తెలుగు';

  @override
  String get languageSystem => 'கணினி இயல்புநிலை';

  @override
  String get profileTheme => 'தோற்றம்';

  @override
  String get themeDark => 'இருள்';

  @override
  String get themeLight => 'வெளிச்சம்';

  @override
  String get themeSystem => 'கணினி இயல்புநிலை';

  @override
  String get callIncomingVoice => 'வரும் குரல் அழைப்பு';

  @override
  String get callIncomingVideo => 'வரும் வீடியோ அழைப்பு';

  @override
  String callRatePerMin(String rate) {
    return '₹$rate/நிமிடம்';
  }

  @override
  String callAutoDeclineIn(int seconds) {
    return '$seconds வினாடிகளில் தானாக நிராகரிக்கப்படும்';
  }

  @override
  String get callAccept => 'ஏற்றுக்கொள்';

  @override
  String get callDecline => 'நிராகரி';

  @override
  String get callConnecting => 'இணைக்கப்படுகிறது…';

  @override
  String get callExpired => 'அழைப்பு காலாவதியானது';

  @override
  String get callExpiredBody => 'இந்த அழைப்பு கோரிக்கை இனி கிடைக்கவில்லை.';

  @override
  String get callCouldNotStart =>
      'அழைப்பைத் தொடங்க முடியவில்லை: சர்வர் Agora அழைப்பு விவரங்களைத் திருப்பவில்லை.';

  @override
  String get commonSeeker => 'தேடுபவர்';

  @override
  String get commonClose => 'மூடு';

  @override
  String get commonUser => 'பயனர்';

  @override
  String get commonEnd => 'முடி';

  @override
  String get callPermMic =>
      'இந்த அழைப்பைப் பெற மைக்ரோஃபோன் அனுமதி தேவை. அமைப்புகளில் அதை இயக்கி மீண்டும் முயற்சிக்கவும்.';

  @override
  String get callPermMicCam =>
      'இந்த அழைப்பைப் பெற மைக்ரோஃபோன் மற்றும் கேமரா அனுமதி தேவை. அமைப்புகளில் அதை இயக்கி மீண்டும் முயற்சிக்கவும்.';

  @override
  String get callAvUnavailable =>
      'ஜோதிடர் ஆடியோ/வீடியோ கிடைக்கவில்லை — சர்வர் Agora டோக்கன் இல்லை.';

  @override
  String callConnectFailed(String error) {
    return 'அழைப்பை இணைக்க முடியவில்லை: $error';
  }

  @override
  String get callEndConfirmTitle => 'இந்த அழைப்பை முடிக்கவா?';

  @override
  String get callEndConfirmBody =>
      'தேடுபவர் துண்டிக்கப்படுவார், மேலும் இந்த அமர்வு முடிவடையும். இதை மாற்ற முடியாது.';

  @override
  String callEndedBy(String name) {
    return '$name அழைப்பை முடித்தார்';
  }

  @override
  String get callCantConnect => 'இணைக்க முடியவில்லை';

  @override
  String get callReconnecting => 'மீண்டும் இணைக்கிறது…';

  @override
  String get callConnected => 'இணைக்கப்பட்டது';

  @override
  String get callWaitingForSeeker => 'தேடுபவருக்காக காத்திருக்கிறது…';

  @override
  String get callVideoTitle => 'வீடியோ அழைப்பு';

  @override
  String get callAudioTitle => 'ஆடியோ அழைப்பு';

  @override
  String callEarningsSoFar(String amount) {
    return 'இதுவரை வருமானம்: ₹$amount';
  }

  @override
  String callRateDotPerMin(String rate) {
    return '· ₹$rate/நிமிடம்';
  }

  @override
  String get callPillCantConnect => 'இணைக்க முடியவில்லை';

  @override
  String get callPillConnecting => 'இணைக்கிறது';

  @override
  String get callPillReconnecting => 'மீண்டும் இணைக்கிறது';

  @override
  String get callPillWaiting => 'காத்திருக்கிறது';

  @override
  String callPillLive(String elapsed) {
    return 'நேரலை · $elapsed';
  }

  @override
  String get chatReconnecting => 'மீண்டும் இணைக்கிறது…';

  @override
  String chatWithName(String name) {
    return '$name உடன் அரட்டை';
  }

  @override
  String get chatEnded => 'முடிந்தது';

  @override
  String get chatLive => 'நேரலை';

  @override
  String get chatWaitingNamaste => 'தேடுபவர் நமஸ்தே சொல்ல காத்திருக்கிறது 🙏';

  @override
  String get chatSending => 'அனுப்பப்படுகிறது…';

  @override
  String get chatNotSentRetry =>
      'அனுப்பப்படவில்லை · மீண்டும் முயற்சிக்க தட்டவும்';

  @override
  String get chatReplyHint => 'பதில்…';

  @override
  String get chatEndedHint => 'அரட்டை முடிந்தது';

  @override
  String get chatSendTooltip => 'செய்தி அனுப்பு';

  @override
  String get liveDefaultTitle => 'மாலை ராசிபலன்';

  @override
  String get liveSetRatesFirst =>
      'நேரலைக்குச் செல்வதற்கு முன் உங்கள் அரட்டை, அழைப்பு மற்றும் வீடியோ விகிதங்களை அமைக்கவும்.';

  @override
  String get liveMessageSent => 'செய்தி அனுப்பப்பட்டது';

  @override
  String get liveMessageSendFailed =>
      'அனுப்ப முடியவில்லை — அரட்டையுடன் மீண்டும் இணைக்கிறது, சிறிது நேரத்தில் மீண்டும் முயற்சிக்கவும்.';

  @override
  String get livePinFailed =>
      'பின் செய்ய முடியவில்லை — அரட்டையுடன் மீண்டும் இணைக்கிறது, மீண்டும் முயற்சிக்கவும்.';

  @override
  String get liveSetGiftGoalTitle => 'பரிசு இலக்கை அமை';

  @override
  String get liveGiftGoalHint => 'எ.கா. 5000';

  @override
  String get liveEndConfirmTitle => 'நேரலை ஒளிபரப்பை முடிக்கவா?';

  @override
  String get liveEndConfirmBody =>
      'உங்கள் பார்வையாளர்கள் துண்டிக்கப்படுவார்கள், மேலும் இந்த அமர்வு முடிவடையும். இதை மாற்ற முடியாது.';

  @override
  String get liveStartTitle => 'நேரலை அமர்வைத் தொடங்கு';

  @override
  String get liveStartSubtitle =>
      'நீங்கள் நேரலைக்குச் செல்லும்போது உங்கள் பின்தொடர்பவர்களுக்கு அறிவிப்பு கிடைக்கும்.';

  @override
  String get liveStreamTitleLabel => 'ஒளிபரப்பு தலைப்பு';

  @override
  String get liveStarting => 'தொடங்குகிறது…';

  @override
  String get liveGiftGoalTooltip => 'பரிசு இலக்கு';

  @override
  String get liveFlipCamera => 'கேமராவை மாற்று';

  @override
  String get liveReconnectingVideo => 'வீடியோ மீண்டும் இணைக்கப்படுகிறது…';

  @override
  String get liveReconnectingChat => 'அரட்டை மீண்டும் இணைக்கப்படுகிறது…';

  @override
  String get liveChatEmpty => 'பார்வையாளர் செய்திகள் இங்கே தோன்றும்…';

  @override
  String liveReplyingTo(String name) {
    return '@$name க்கு பதில்';
  }

  @override
  String liveReplyHint(String name) {
    return '@$name க்கு பதிலளிக்கவும்…';
  }

  @override
  String get liveSayHiHint => 'உங்கள் பார்வையாளர்களுக்கு வணக்கம் சொல்லுங்கள்…';

  @override
  String get liveWrapTitle => 'முடிந்துவிட்டது!';

  @override
  String get liveWrapSubtitle =>
      'உங்கள் அமர்வு எப்படி இருந்தது என்று பாருங்கள்.';

  @override
  String get liveDuration => 'கால அளவு';

  @override
  String get livePeakViewers => 'அதிகபட்ச பார்வையாளர்கள்';

  @override
  String get liveBadge => 'நேரலை';

  @override
  String get liveEndButton => 'நேரலையை முடி';

  @override
  String get liveMuteMic => 'மைக்ரோஃபோனை முடக்கு';

  @override
  String get liveUnmuteMic => 'மைக்ரோஃபோனை இயக்கு';

  @override
  String get liveGift => 'பரிசு';

  @override
  String get liveAnsweringNow => 'இப்போது பதிலளிக்கிறார் — ';

  @override
  String get commonErrorGeneric => 'ஏதோ தவறு நடந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get profileDeleteAccount => 'கணக்கை நீக்கு';

  @override
  String get deleteAccountTitle => 'கணக்கை நீக்கவா?';

  @override
  String get deleteAccountWarning =>
      'இது உங்கள் ஜோதிடர் கணக்கை நிரந்தரமாக நீக்கும். உங்கள் சுயவிவரம் மற்றும் KYC நீக்கப்படும், நீங்கள் ஆஃப்லைனாகி தேடலில் இருந்து மறைக்கப்படுவீர்கள், உங்கள் அனைத்து அமர்வுகளும் முடிவடையும், மேலும் இதை மாற்ற முடியாது. முதலில் ஏதேனும் மீதியை திரும்பப் பெற்று, நடப்பு ஆலோசனைகளை முடிக்கவும்.';

  @override
  String get deleteAccountTypeHint => 'உறுதிசெய்ய DELETE என தட்டச்சு செய்யவும்';

  @override
  String get deleteAccountConfirm => 'கணக்கை நீக்கு';

  @override
  String get deleteAccountSuccess => 'உங்கள் கணக்கு நீக்கப்பட்டது.';

  @override
  String get earningsAddPanTitle => 'திரும்பப் பெற உங்கள் PAN-ஐச் சேர்க்கவும்';

  @override
  String get earningsAddPanBody =>
      'ஒவ்வொரு பணம் செலுத்துதலிலும் உங்கள் PAN-க்கு எதிராக TDS கழிக்கப்படும். திரும்பப் பெறுவதற்கு முன் உங்கள் வங்கி மற்றும் PAN விவரங்களில் சரியான PAN-ஐச் சேர்க்கவும்.';

  @override
  String get earningsAddPanAction => 'PAN சேர்';

  @override
  String earningsTdsNote(String rate) {
    return 'ஒவ்வொரு பணம் செலுத்துதலிலும் உங்கள் PAN-க்கு எதிராக $rate% TDS கழிக்கப்படும்.';
  }

  @override
  String get earningsRecentPayouts => 'சமீபத்திய திரும்பப்பெறுதல்கள்';

  @override
  String get earningsPayoutTds => 'TDS';

  @override
  String get earningsPayoutNet => 'நிகர பணம்';

  @override
  String get earningsPayoutGross => 'மொத்தம்';

  @override
  String get earningsNoPayouts => 'இதுவரை திரும்பப்பெறுதல்கள் இல்லை.';

  @override
  String get notificationsTitle => 'அறிவிப்புகள்';

  @override
  String get notificationsEmpty => 'உங்களுக்கு இதுவரை அறிவிப்புகள் இல்லை.';

  @override
  String get notificationsMarkAllRead => 'அனைத்தையும் படித்ததாகக் குறி';

  @override
  String get supportTitle => 'உதவி மற்றும் ஆதரவு';

  @override
  String get supportFaqTab => 'அடிக்கடி கேட்கப்படும் கேள்விகள்';

  @override
  String get supportTicketsTab => 'என் டிக்கெட்டுகள்';

  @override
  String get supportFaqEmpty => 'இப்போது உதவிக் கட்டுரைகள் எதுவும் இல்லை.';

  @override
  String get supportTicketsEmpty =>
      'உங்களுக்கு இதுவரை ஆதரவு டிக்கெட்டுகள் இல்லை.';

  @override
  String get supportRaiseTicket => 'டிக்கெட் உருவாக்கு';

  @override
  String get supportSubject => 'பொருள்';

  @override
  String get supportMessage => 'உங்கள் பிரச்சினையை விவரிக்கவும்';

  @override
  String get supportSubmit => 'சமர்ப்பி';

  @override
  String get supportFillFields => 'பொருள் மற்றும் செய்தியைச் சேர்க்கவும்.';

  @override
  String get supportTicket => 'டிக்கெட்';

  @override
  String get supportReplyHint => 'பதிலை தட்டச்சு செய்யவும்…';

  @override
  String get supportReopenHint =>
      'இந்த டிக்கெட்டை மீண்டும் திறக்க பதிலளிக்கவும்…';

  @override
  String get supportSenderYou => 'நீங்கள்';

  @override
  String get supportSenderSupport => 'ஆதரவு';

  @override
  String get supportStatusOpen => 'திறந்துள்ளது';

  @override
  String get supportStatusPending => 'உங்கள் பதில் எதிர்பார்க்கப்படுகிறது';

  @override
  String get supportStatusClosed => 'மூடப்பட்டது';
}
