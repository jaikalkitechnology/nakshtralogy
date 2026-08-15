// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'হিন্দুস্তানি জ্যোতিষ — জ্যোতিষী';

  @override
  String get commonOk => 'ঠিক আছে';

  @override
  String get commonCancel => 'বাতিল করুন';

  @override
  String get commonRetry => 'আবার চেষ্টা করুন';

  @override
  String get commonSave => 'সংরক্ষণ করুন';

  @override
  String get commonDone => 'সম্পন্ন';

  @override
  String get commonSettings => 'সেটিংস';

  @override
  String get commonSignOut => 'সাইন আউট';

  @override
  String get navDashboard => 'ড্যাশবোর্ড';

  @override
  String get navRequests => 'অনুরোধ';

  @override
  String get navEarnings => 'উপার্জন';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get authApplyTitle => 'জ্যোতিষী হিসেবে আবেদন করুন';

  @override
  String get authApplySubtitle =>
      'আপনার সমস্ত পরামর্শ ও উপার্জনের জন্য একটি একক ড্যাশবোর্ড।';

  @override
  String get authContinueWithGoogle => 'Google দিয়ে চালিয়ে যান';

  @override
  String get dashWelcomeBack => 'ফিরে আসার জন্য স্বাগতম';

  @override
  String dashReviews(Object count) {
    return '$count পর্যালোচনা';
  }

  @override
  String get dashOnline => 'আপনি অনলাইনে আছেন';

  @override
  String get dashOffline => 'আপনি অফলাইনে আছেন';

  @override
  String get dashOnlineSubtitle => 'পরামর্শের অনুরোধ পাওয়া যাচ্ছে';

  @override
  String get dashOfflineSubtitle =>
      'অনুরোধ পাওয়া শুরু করতে টগল করুন';

  @override
  String get dashGoLive => 'লাইভ যান';

  @override
  String get dashRequests => 'অনুরোধ';

  @override
  String get dashSettings => 'সেটিংস';

  @override
  String get dashSettingsSubtitle => 'চার্জ, পরিচিতি, ভাষা ও ছবি';

  @override
  String get statTodayEarnings => 'আজকের উপার্জন';

  @override
  String get statBalance => 'ব্যালেন্স';

  @override
  String get statTodayConsults => 'আজকের পরামর্শ';

  @override
  String get statTotalConsults => 'মোট পরামর্শ';

  @override
  String get statRating => 'রেটিং';

  @override
  String get statFollowers => 'অনুসারী';

  @override
  String get reqTitle => 'আগত অনুরোধ';

  @override
  String get reqEmpty =>
      'কোনো অমীমাংসিত অনুরোধ নেই।\nরিফ্রেশ করতে নিচে টানুন।';

  @override
  String reqRequestLabel(String kind) {
    return '$kind অনুরোধ';
  }

  @override
  String get reqDecline => 'প্রত্যাখ্যান করুন';

  @override
  String get reqAccept => 'গ্রহণ করুন';

  @override
  String get profileTitle => 'প্রোফাইল';

  @override
  String get profileAstrologer => 'জ্যোতিষী';

  @override
  String get profileSkills => 'দক্ষতা';

  @override
  String get profileLanguages => 'ভাষা';

  @override
  String get profileExperience => 'অভিজ্ঞতা';

  @override
  String get profileRating => 'রেটিং';

  @override
  String get profileChatRate => 'চ্যাট হার';

  @override
  String get profileCallRate => 'কল হার';

  @override
  String get profileVideoRate => 'ভিডিও হার';

  @override
  String profileYears(Object years) {
    return '$years বছর';
  }

  @override
  String get profileEditCharges => 'প্রোফাইল ও চার্জ সম্পাদনা করুন';

  @override
  String get profileAccountSection => 'অ্যাকাউন্ট';

  @override
  String get profileEditProfile => 'প্রোফাইল সম্পাদনা করুন';

  @override
  String get profileEditProfileSub =>
      'নাম, পরিচিতি, দক্ষতা, ভাষা, হার ও ছবি';

  @override
  String get profileBankPan => 'ব্যাংক ও প্যান বিবরণ';

  @override
  String get profileBankPanSub => 'পেআউট পদ্ধতি, ব্যাংক অ্যাকাউন্ট ও প্যান';

  @override
  String get editProfileTitle => 'প্রোফাইল সম্পাদনা করুন';

  @override
  String get editProfileSubtitle =>
      'জিজ্ঞাসুরা আপনাকে কীভাবে দেখেন এবং আপনি কী চার্জ করেন তা আপডেট করুন।';

  @override
  String get bankPanTitle => 'ব্যাংক ও প্যান বিবরণ';

  @override
  String get bankPanIntro =>
      'উত্তোলন ও যাচাইকরণের জন্য ব্যবহৃত আপনার পেআউট ও পরিচয় বিবরণ।';

  @override
  String get bankPanPayoutSection => 'পেআউট পদ্ধতি';

  @override
  String get bankPanIdentitySection => 'পরিচয়';

  @override
  String get bankPanDocsSection => 'নথিপত্র';

  @override
  String get bankPanBankName => 'ব্যাংকের নাম';

  @override
  String get bankPanIfsc => 'IFSC কোড';

  @override
  String get bankPanAccountHolder => 'অ্যাকাউন্ট হোল্ডার';

  @override
  String get bankPanAccountNumber => 'অ্যাকাউন্ট নম্বর';

  @override
  String get bankPanUpiId => 'UPI আইডি';

  @override
  String get bankPanPan => 'প্যান নম্বর';

  @override
  String get bankPanAadhaar => 'আধার নম্বর';

  @override
  String bankPanMasked(String last4) {
    return '•••• $last4';
  }

  @override
  String get bankPanNotSet => 'সেট করা নেই';

  @override
  String get bankPanEditCta => 'ব্যাংক ও প্যান বিবরণ সম্পাদনা করুন';

  @override
  String get bankPanAddCta => 'ব্যাংক ও প্যান বিবরণ যোগ করুন';

  @override
  String get bankPanApprovalNote =>
      'ব্যাংক বা প্যান বিবরণের পরিবর্তনগুলি অ্যাডমিন অনুমোদনের জন্য জমা দেওয়া হয় এবং অনুমোদিত হওয়ার পর প্রযোজ্য হয়।';

  @override
  String get bankPanEmpty =>
      'আপনি এখনো আপনার ব্যাংক ও প্যান বিবরণ যোগ করেননি।';

  @override
  String get bankPanLoadFailed => 'আপনার ব্যাংক ও প্যান বিবরণ লোড করা যায়নি।';

  @override
  String get setTitle => 'সেটিংস';

  @override
  String get setChangePhoto => 'আপনার ছবি পরিবর্তন করতে ক্যামেরায় ট্যাপ করুন';

  @override
  String get setCharges => 'চার্জ';

  @override
  String get setChatRate => 'চ্যাট হার';

  @override
  String get setCallRate => 'কল হার';

  @override
  String get setVideoRate => 'ভিডিও হার';

  @override
  String get setPerMessage => '₹ / বার্তা';

  @override
  String get setPerMinute => '₹ / মিনিট';

  @override
  String get setSuperChatRate => 'সুপার চ্যাট মূল্য';

  @override
  String get setPerSuperChat => '₹ / সুপার চ্যাট';

  @override
  String get setSuperChatInvalid =>
      'একটি বৈধ সুপার চ্যাট মূল্য লিখুন (₹০-এর বেশি)।';

  @override
  String get setSuperChatMax =>
      'সুপার চ্যাট মূল্য ₹১০০০০-এর বেশি হতে পারবে না।';

  @override
  String get setAboutYou => 'আপনার সম্পর্কে';

  @override
  String get setDisplayName => 'প্রদর্শিত নাম';

  @override
  String get setBio => 'পরিচিতি';

  @override
  String get setBioHint => 'জিজ্ঞাসুদের আপনার অনুশীলন সম্পর্কে বলুন…';

  @override
  String get setSkills => 'দক্ষতা';

  @override
  String get setSkillsHint => 'বৈদিক, ট্যারো, সংখ্যাতত্ত্ব';

  @override
  String get setLanguagesField => 'ভাষা';

  @override
  String get setLanguagesHint => 'হিন্দি, ইংরেজি';

  @override
  String get setCommaSeparated => 'কমা দিয়ে আলাদা করুন';

  @override
  String get setKycDocsTitle => 'KYC নথিপত্র';

  @override
  String get setKycDocsSubtitle =>
      'যাচাইকরণের জন্য আপনার জমা দেওয়া পরিচয় নথিপত্র।';

  @override
  String get setKycDocsLocked =>
      'অনুমোদনের পর নথিপত্র লক হয়ে যায়। এগুলি আপডেট করতে সহায়তার সাথে যোগাযোগ করুন।';

  @override
  String get setKycResubmit => 'KYC নথিপত্র আপডেট করুন';

  @override
  String get setKycUpdateButton => 'KYC / পেআউট বিবরণ আপডেট করুন';

  @override
  String get setKycUpdateNote => 'পরিবর্তনগুলি অ্যাডমিন অনুমোদনের পর প্রযোজ্য হবে।';

  @override
  String get setKycNotUploaded => 'আপলোড করা হয়নি';

  @override
  String get setKycLoadFailed => 'KYC নথিপত্র লোড করা যায়নি।';

  @override
  String get setDocPhoto => 'ছবি';

  @override
  String get setDocPan => 'প্যান কার্ড';

  @override
  String get setDocAadhaar => 'আধার (সামনের দিক)';

  @override
  String get setDocAadhaarBack => 'আধার (পিছনের দিক)';

  @override
  String get setDocBankProof => 'ব্যাংক প্রমাণ';

  @override
  String get setDocCertificate => 'সার্টিফিকেট';

  @override
  String get setPayoutMethodLabel => 'পেআউট পদ্ধতি';

  @override
  String get setPayoutUpi => 'UPI';

  @override
  String get setPayoutBank => 'ব্যাংক অ্যাকাউন্ট';

  @override
  String get setSaveChanges => 'পরিবর্তন সংরক্ষণ করুন';

  @override
  String get setSaving => 'সংরক্ষণ করা হচ্ছে…';

  @override
  String get setProfileUpdated => 'প্রোফাইল আপডেট হয়েছে';

  @override
  String get setPhotoUpdated => 'ছবি আপডেট হয়েছে';

  @override
  String get setChangesPendingApproval =>
      'পরিবর্তনগুলি অ্যাডমিন অনুমোদনের জন্য জমা দেওয়া হয়েছে — অনুমোদিত হওয়ার সাথে সাথেই সেগুলি চালু হবে।';

  @override
  String get setPendingEditBanner =>
      'আপনার প্রোফাইলের পরিবর্তনগুলি অ্যাডমিন অনুমোদনের অপেক্ষায় আছে।';

  @override
  String get setPendingEditRejected =>
      'আপনার সাম্প্রতিক প্রোফাইল পরিবর্তনগুলি প্রত্যাখ্যাত হয়েছে।';

  @override
  String setPendingEditFields(String fields) {
    return 'পরিবর্তিত ফিল্ড: $fields';
  }

  @override
  String get setFieldMobile => 'যোগাযোগের নম্বর';

  @override
  String get setFieldCountryCode => 'দেশের কোড';

  @override
  String get setFieldKyc => 'KYC / পেআউট বিবরণ';

  @override
  String get appLanguageSection => 'অ্যাপ';

  @override
  String get appLanguage => 'ভাষা / Language';

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
  String get languageSystem => 'সিস্টেম ডিফল্ট';

  @override
  String get profileTheme => 'থিম';

  @override
  String get themeDark => 'ডার্ক';

  @override
  String get themeLight => 'লাইট';

  @override
  String get themeSystem => 'সিস্টেম ডিফল্ট';

  @override
  String get callIncomingVoice => 'ইনকামিং ভয়েস কল';

  @override
  String get callIncomingVideo => 'ইনকামিং ভিডিও কল';

  @override
  String callRatePerMin(String rate) {
    return '₹$rate/মিনিট';
  }

  @override
  String callAutoDeclineIn(int seconds) {
    return '$seconds সেকেন্ডে স্বয়ংক্রিয়ভাবে প্রত্যাখ্যান হবে';
  }

  @override
  String get callAccept => 'গ্রহণ করুন';

  @override
  String get callDecline => 'প্রত্যাখ্যান করুন';

  @override
  String get callConnecting => 'সংযুক্ত হচ্ছে…';

  @override
  String get callExpired => 'কল মেয়াদোত্তীর্ণ';

  @override
  String get callExpiredBody => 'এই কল অনুরোধটি আর উপলব্ধ নেই।';

  @override
  String get callCouldNotStart =>
      'কল শুরু করা যায়নি: সার্ভার Agora কল বিবরণ ফেরত দেয়নি।';

  @override
  String get commonSeeker => 'জিজ্ঞাসু';

  @override
  String get commonClose => 'বন্ধ করুন';

  @override
  String get commonUser => 'ব্যবহারকারী';

  @override
  String get commonEnd => 'শেষ করুন';

  @override
  String get callPermMic =>
      'এই কলটি নিতে মাইক্রোফোনের অনুমতি প্রয়োজন। সেটিংসে এটি সক্ষম করুন এবং আবার চেষ্টা করুন।';

  @override
  String get callPermMicCam =>
      'এই কলটি নিতে মাইক্রোফোন ও ক্যামেরার অনুমতি প্রয়োজন। সেটিংসে এটি সক্ষম করুন এবং আবার চেষ্টা করুন।';

  @override
  String get callAvUnavailable =>
      'জ্যোতিষীর অডিও/ভিডিও উপলব্ধ নেই — সার্ভারের Agora টোকেন অনুপস্থিত।';

  @override
  String callConnectFailed(String error) {
    return 'কল সংযুক্ত করা যায়নি: $error';
  }

  @override
  String get callEndConfirmTitle => 'এই কলটি শেষ করবেন?';

  @override
  String get callEndConfirmBody =>
      'জিজ্ঞাসুর সংযোগ বিচ্ছিন্ন হয়ে যাবে এবং এই সেশনটি শেষ হয়ে যাবে। এটি ফিরিয়ে আনা যাবে না।';

  @override
  String callEndedBy(String name) {
    return '$name কলটি শেষ করেছেন';
  }

  @override
  String get callCantConnect => 'সংযুক্ত করা যায়নি';

  @override
  String get callReconnecting => 'পুনরায় সংযুক্ত হচ্ছে…';

  @override
  String get callConnected => 'সংযুক্ত হয়েছে';

  @override
  String get callWaitingForSeeker => 'জিজ্ঞাসুর জন্য অপেক্ষা করা হচ্ছে…';

  @override
  String get callVideoTitle => 'ভিডিও কল';

  @override
  String get callAudioTitle => 'অডিও কল';

  @override
  String callEarningsSoFar(String amount) {
    return 'এখন পর্যন্ত উপার্জন: ₹$amount';
  }

  @override
  String callRateDotPerMin(String rate) {
    return '· ₹$rate/মিনিট';
  }

  @override
  String get callPillCantConnect => 'সংযুক্ত হয়নি';

  @override
  String get callPillConnecting => 'সংযুক্ত হচ্ছে';

  @override
  String get callPillReconnecting => 'পুনরায় সংযুক্ত';

  @override
  String get callPillWaiting => 'অপেক্ষা';

  @override
  String callPillLive(String elapsed) {
    return 'লাইভ · $elapsed';
  }

  @override
  String get chatReconnecting => 'পুনরায় সংযুক্ত হচ্ছে…';

  @override
  String chatWithName(String name) {
    return '$name-এর সাথে চ্যাট';
  }

  @override
  String get chatEnded => 'শেষ';

  @override
  String get chatLive => 'লাইভ';

  @override
  String get chatWaitingNamaste => 'জিজ্ঞাসুর নমস্তে বলার জন্য অপেক্ষা করা হচ্ছে 🙏';

  @override
  String get chatSending => 'পাঠানো হচ্ছে…';

  @override
  String get chatNotSentRetry => 'পাঠানো হয়নি · আবার চেষ্টা করতে ট্যাপ করুন';

  @override
  String get chatReplyHint => 'উত্তর দিন…';

  @override
  String get chatEndedHint => 'চ্যাট শেষ';

  @override
  String get chatSendTooltip => 'বার্তা পাঠান';

  @override
  String get liveDefaultTitle => 'সান্ধ্য রাশিফল';

  @override
  String get liveSetRatesFirst =>
      'লাইভে যাওয়ার আগে আপনার চ্যাট, কল ও ভিডিও হার নির্ধারণ করুন।';

  @override
  String get liveMessageSent => 'বার্তা পাঠানো হয়েছে';

  @override
  String get liveMessageSendFailed =>
      'পাঠানো যায়নি — চ্যাটে পুনরায় সংযুক্ত হচ্ছে, একটু পরে আবার চেষ্টা করুন।';

  @override
  String get livePinFailed =>
      'পিন করা যায়নি — চ্যাটে পুনরায় সংযুক্ত হচ্ছে, আবার চেষ্টা করুন।';

  @override
  String get liveSetGiftGoalTitle => 'গিফটিং লক্ষ্য নির্ধারণ করুন';

  @override
  String get liveGiftGoalHint => 'যেমন ৫০০০';

  @override
  String get liveEndConfirmTitle => 'লাইভ সম্প্রচার শেষ করবেন?';

  @override
  String get liveEndConfirmBody =>
      'আপনার দর্শকদের সংযোগ বিচ্ছিন্ন হয়ে যাবে এবং এই সেশনটি শেষ হয়ে যাবে। এটি ফিরিয়ে আনা যাবে না।';

  @override
  String get liveStartTitle => 'একটি লাইভ সেশন শুরু করুন';

  @override
  String get liveStartSubtitle =>
      'আপনি লাইভে গেলে আপনার অনুসারীরা বিজ্ঞপ্তি পান।';

  @override
  String get liveStreamTitleLabel => 'স্ট্রিমের শিরোনাম';

  @override
  String get liveStarting => 'শুরু হচ্ছে…';

  @override
  String get liveGiftGoalTooltip => 'গিফটিং লক্ষ্য';

  @override
  String get liveFlipCamera => 'ক্যামেরা পরিবর্তন করুন';

  @override
  String get liveReconnectingVideo => 'ভিডিও পুনরায় সংযুক্ত হচ্ছে…';

  @override
  String get liveReconnectingChat => 'চ্যাট পুনরায় সংযুক্ত হচ্ছে…';

  @override
  String get liveChatEmpty => 'দর্শকদের বার্তা এখানে দেখা যাবে…';

  @override
  String liveReplyingTo(String name) {
    return '@$name-কে উত্তর';
  }

  @override
  String liveReplyHint(String name) {
    return '@$name-কে উত্তর দিন…';
  }

  @override
  String get liveSayHiHint => 'আপনার দর্শকদের নমস্তে বলুন…';

  @override
  String get liveWrapTitle => 'এটাই শেষ!';

  @override
  String get liveWrapSubtitle => 'দেখুন আপনার সেশনটি কেমন গেল।';

  @override
  String get liveDuration => 'সময়কাল';

  @override
  String get livePeakViewers => 'সর্বোচ্চ দর্শক';

  @override
  String get liveBadge => 'লাইভ';

  @override
  String get liveEndButton => 'লাইভ শেষ করুন';

  @override
  String get liveMuteMic => 'মাইক্রোফোন মিউট করুন';

  @override
  String get liveUnmuteMic => 'মাইক্রোফোন আনমিউট করুন';

  @override
  String get liveGift => 'গিফট';

  @override
  String get liveAnsweringNow => 'এখন উত্তর দিচ্ছেন — ';

  @override
  String get commonErrorGeneric =>
      'কিছু ভুল হয়ে গেছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get profileDeleteAccount => 'অ্যাকাউন্ট মুছুন';

  @override
  String get deleteAccountTitle => 'অ্যাকাউন্ট মুছবেন?';

  @override
  String get deleteAccountWarning =>
      'এতে আপনার জ্যোতিষী অ্যাকাউন্ট স্থায়ীভাবে মুছে যাবে। আপনার প্রোফাইল ও KYC সরিয়ে ফেলা হবে, আপনি অফলাইনে চলে যাবেন ও অনুসন্ধান থেকে লুকিয়ে যাবেন, আপনার সমস্ত সেশন শেষ হয়ে যাবে, এবং এটি ফিরিয়ে আনা যাবে না। আগে যেকোনো অবশিষ্ট ব্যালেন্স উত্তোলন করুন এবং চলমান পরামর্শগুলি সম্পূর্ণ করুন।';

  @override
  String get deleteAccountTypeHint => 'নিশ্চিত করতে DELETE টাইপ করুন';

  @override
  String get deleteAccountConfirm => 'অ্যাকাউন্ট মুছুন';

  @override
  String get deleteAccountSuccess => 'আপনার অ্যাকাউন্ট মুছে ফেলা হয়েছে।';

  @override
  String get earningsAddPanTitle => 'উত্তোলন করতে আপনার PAN যোগ করুন';

  @override
  String get earningsAddPanBody =>
      'প্রতিটি পেআউটে আপনার PAN-এর বিরুদ্ধে TDS কাটা হয়। উত্তোলনের আগে আপনার ব্যাংক ও PAN বিবরণে একটি বৈধ PAN যোগ করুন।';

  @override
  String get earningsAddPanAction => 'PAN যোগ করুন';

  @override
  String earningsTdsNote(String rate) {
    return 'প্রতিটি পেআউটে আপনার PAN-এর বিরুদ্ধে $rate% TDS কাটা হয়।';
  }

  @override
  String get earningsRecentPayouts => 'সাম্প্রতিক উত্তোলন';

  @override
  String get earningsPayoutTds => 'TDS';

  @override
  String get earningsPayoutNet => 'নেট পরিশোধিত';

  @override
  String get earningsPayoutGross => 'মোট';

  @override
  String get earningsNoPayouts => 'এখনো কোনো উত্তোলন নেই।';

  @override
  String get notificationsTitle => 'বিজ্ঞপ্তি';

  @override
  String get notificationsEmpty => 'আপনার কাছে এখনো কোনো বিজ্ঞপ্তি নেই।';

  @override
  String get notificationsMarkAllRead => 'সব পঠিত হিসেবে চিহ্নিত করুন';

  @override
  String get supportTitle => 'সহায়তা ও সমর্থন';

  @override
  String get supportFaqTab => 'প্রশ্নোত্তর';

  @override
  String get supportTicketsTab => 'আমার টিকিট';

  @override
  String get supportFaqEmpty => 'এখনো কোনো সহায়তা নিবন্ধ উপলব্ধ নেই।';

  @override
  String get supportTicketsEmpty => 'আপনার কাছে এখনো কোনো সহায়তা টিকিট নেই।';

  @override
  String get supportRaiseTicket => 'একটি টিকিট তৈরি করুন';

  @override
  String get supportSubject => 'বিষয়';

  @override
  String get supportMessage => 'আপনার সমস্যাটি বর্ণনা করুন';

  @override
  String get supportSubmit => 'জমা দিন';

  @override
  String get supportFillFields => 'অনুগ্রহ করে একটি বিষয় এবং একটি বার্তা যোগ করুন।';

  @override
  String get supportTicket => 'টিকিট';

  @override
  String get supportReplyHint => 'একটি উত্তর লিখুন…';

  @override
  String get supportReopenHint => 'এই টিকিটটি পুনরায় খুলতে উত্তর দিন…';

  @override
  String get supportSenderYou => 'আপনি';

  @override
  String get supportSenderSupport => 'সহায়তা';

  @override
  String get supportStatusOpen => 'খোলা';

  @override
  String get supportStatusPending => 'আপনার প্রতিক্রিয়া অপেক্ষিত';

  @override
  String get supportStatusClosed => 'বন্ধ';
}
