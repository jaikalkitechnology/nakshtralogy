// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'हिन्दुस्तानी ज्योतिष';

  @override
  String get commonOk => 'ठीक है';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonRetry => 'पुनः प्रयास करें';

  @override
  String get commonSave => 'सहेजें';

  @override
  String get commonDone => 'पूर्ण';

  @override
  String get commonAdd => 'जोड़ें';

  @override
  String get commonClear => 'साफ़ करें';

  @override
  String get commonSeeAll => 'सभी देखें';

  @override
  String get commonLoading => 'लोड हो रहा है…';

  @override
  String get commonOnline => 'ऑनलाइन';

  @override
  String get commonOffline => 'ऑफ़लाइन';

  @override
  String get commonErrorGeneric => 'कुछ गड़बड़ हो गई। कृपया पुनः प्रयास करें।';

  @override
  String get navHome => 'होम';

  @override
  String get navAstrologers => 'ज्योतिषी';

  @override
  String get navInsights => 'अंतर्दृष्टि';

  @override
  String get navWallet => 'वॉलेट';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get authNamaste => 'नमस्ते 🙏';

  @override
  String get authWelcomeSubtitle =>
      'कुछ ही मिनटों में सत्यापित वैदिक ज्योतिषियों से बात करें।';

  @override
  String get authContinue => 'आगे बढ़ें';

  @override
  String get authContinueWithGoogle => 'Google से जारी रखें';

  @override
  String get authGoogleHelper => 'अपने Google खाते से सुरक्षित साइन इन करें';

  @override
  String get homeGreeting => 'नमस्ते 🙏';

  @override
  String get homeSeeker => 'जिज्ञासु';

  @override
  String get homeCosmicInsights => 'ब्रह्मांडीय अंतर्दृष्टि';

  @override
  String get homeOnlineAstrologers => 'ऑनलाइन ज्योतिषी';

  @override
  String get homeNoAstrologersOnline => 'इस समय कोई ज्योतिषी ऑनलाइन नहीं है।';

  @override
  String get homePromoTitle => 'पहली चैट ₹7/संदेश से';

  @override
  String get homePromoSubtitle => 'अभी सत्यापित वैदिक ज्योतिषियों से बात करें।';

  @override
  String get homeLiveTitle => 'ज्योतिषी अभी लाइव';

  @override
  String get homeLiveSubtitle =>
      'लाइव सत्र में शामिल हों, प्रश्न पूछें, उपहार भेजें।';

  @override
  String get homeFeaturedVideos => 'विशेष वीडियो';

  @override
  String get toolDailyHoroscope => 'दैनिक राशिफल';

  @override
  String get toolDetailedKundli => 'विस्तृत कुंडली';

  @override
  String get toolLoveMatch => 'प्रेम मिलान';

  @override
  String get toolPlanetPosition => 'ग्रह स्थिति';

  @override
  String get cardAstrologer => 'ज्योतिषी';

  @override
  String get cardConsult => 'परामर्श';

  @override
  String get cardChat => 'चैट';

  @override
  String get cardCall => 'कॉल';

  @override
  String get cardVideo => 'वीडियो';

  @override
  String cardYears(Object years) {
    return '$years वर्ष';
  }

  @override
  String cardYearsExp(Object years) {
    return '$years वर्ष अनुभव';
  }

  @override
  String cardRatePerMsg(Object rate) {
    return '₹$rate/संदेश';
  }

  @override
  String cardRatePerMin(Object rate) {
    return '₹$rate/मिनट';
  }

  @override
  String get discoverySearchHint => 'ज्योतिषी, विद्याएँ खोजें…';

  @override
  String get discoveryOnlineNow => 'अभी ऑनलाइन';

  @override
  String get discoveryLanguage => 'भाषा';

  @override
  String get discoverySkill => 'विद्या';

  @override
  String get discoverySort => 'क्रमबद्ध करें';

  @override
  String get discoverySortTopRated => 'सर्वोच्च रेटेड';

  @override
  String get discoverySortPriceAsc => 'मूल्य: कम से अधिक';

  @override
  String get discoverySortPriceDesc => 'मूल्य: अधिक से कम';

  @override
  String get discoveryNoMatch =>
      'आपके फ़िल्टर से कोई ज्योतिषी मेल नहीं खाता।\nअपनी खोज का दायरा बढ़ाकर देखें।';

  @override
  String get discoveryReachedEnd => 'आप अंत तक पहुँच गए हैं';

  @override
  String get walletTitle => 'वॉलेट';

  @override
  String get walletBalance => 'शेष राशि';

  @override
  String get walletQuickRecharge => 'त्वरित रिचार्ज';

  @override
  String get walletCustomAmount => 'अपनी राशि';

  @override
  String walletBiometricNote(Object amount) {
    return '₹$amount या उससे अधिक के रिचार्ज के लिए बायोमेट्रिक पुष्टि आवश्यक है।';
  }

  @override
  String get walletRecentTransactions => 'हाल के लेन-देन';

  @override
  String get walletNoTransactions => 'अभी तक कोई लेन-देन नहीं।';

  @override
  String get walletEnterValidAmount => '₹ में एक मान्य राशि दर्ज करें।';

  @override
  String get walletBiometricRequired =>
      'इस राशि के लिए बायोमेट्रिक सत्यापन आवश्यक है।';

  @override
  String walletRechargeConfirm(Object amount) {
    return '₹$amount रिचार्ज करने के लिए अपनी पहचान की पुष्टि करें';
  }

  @override
  String walletAddedToWallet(Object amount) {
    return 'आपके वॉलेट में ₹$amount जोड़े गए।';
  }

  @override
  String get consultChat => 'चैट';

  @override
  String get consultAudioCall => 'ऑडियो कॉल';

  @override
  String get consultVideoCall => 'वीडियो कॉल';

  @override
  String get consultConnected => 'जुड़ गए';

  @override
  String get consultWaitingForAstrologer => 'ज्योतिषी की प्रतीक्षा…';

  @override
  String get consultEnded => 'समाप्त';

  @override
  String get consultSendMessage => 'संदेश भेजें';

  @override
  String get consultCloseSession => 'बंद करें';

  @override
  String get consultReady => 'तैयार';

  @override
  String get consultStart => 'प्रारंभ करें';

  @override
  String get consultTapStart => 'जुड़ने के लिए प्रारंभ पर टैप करें';

  @override
  String get consultConnecting => 'जोड़ा जा रहा है…';

  @override
  String get consultSayNamaste => 'शुरू करने के लिए नमस्ते कहें 🙏';

  @override
  String get consultConnectingAstrologer => 'आपको ज्योतिषी से जोड़ा जा रहा है…';

  @override
  String get consultTypeMessage => 'संदेश लिखें…';

  @override
  String get consultWaitingAstrologer => 'ज्योतिषी की प्रतीक्षा…';

  @override
  String get consultChatEnded => 'यह चैट समाप्त हो गई है।';

  @override
  String get consultSessionEnded => 'सत्र समाप्त';

  @override
  String get consultSessionEndedLowBalance => 'सत्र समाप्त (कम शेष राशि)';

  @override
  String consultDuration(Object seconds) {
    return 'अवधि: $seconds से॰';
  }

  @override
  String consultCharged(Object amount) {
    return 'शुल्क: ₹$amount';
  }

  @override
  String get consultSoFar => 'अब तक';

  @override
  String get consultWaitingAstrologerJoin =>
      'ज्योतिषी के जुड़ने की प्रतीक्षा है…';

  @override
  String get consultEndCallConfirmTitle => 'यह कॉल समाप्त करें?';

  @override
  String get consultEndCallConfirmBody =>
      'इससे यह लाइव सत्र दोनों के लिए समाप्त हो जाएगा और इसे वापस नहीं लिया जा सकता।';

  @override
  String get commonEnd => 'समाप्त करें';

  @override
  String get consultEndedInBackgroundTitle => 'कॉल समाप्त हुई';

  @override
  String get consultEndedInBackgroundBody =>
      'ऐप बैकग्राउंड में होने के दौरान यह कॉल समाप्त हो गई।';

  @override
  String get consultReconnectingChat => 'चैट पुनः जोड़ी जा रही है…';

  @override
  String get consultCallReconnecting => 'पुनः जुड़ रहे हैं…';

  @override
  String get consultSessionEndedTimeUp => 'सत्र समाप्त (समय सीमा पूरी हुई)';

  @override
  String consultCallEndedBy(String name) {
    return '$name ने कॉल समाप्त की';
  }

  @override
  String get consultTheAstrologer => 'ज्योतिषी';

  @override
  String get consultSending => 'भेजा जा रहा है…';

  @override
  String get consultNotSentRetry => 'नहीं भेजा गया · पुनः प्रयास करें';

  @override
  String get consultSpeakerOn => 'स्पीकर चालू';

  @override
  String get consultSpeakerOff => 'स्पीकर बंद';

  @override
  String consultSessionMsgs(Object used, Object cap, Object left) {
    return 'सत्र: $used/$cap संदेश ($left शेष)';
  }

  @override
  String consultPerMsgRate(Object rate) {
    return '₹$rate/संदेश';
  }

  @override
  String get consultConnectedLabel => 'जुड़ा हुआ';

  @override
  String consultChargedRate(Object charged, Object rate) {
    return '₹$charged · ₹$rate/मिनट';
  }

  @override
  String consultBalanceMinutes(Object balance, Object minutes) {
    return 'शेष ₹$balance · ~$minutes मिनट बाकी';
  }

  @override
  String consultBalanceRemaining(Object balance) {
    return 'शेष ₹$balance';
  }

  @override
  String get consultLowBalanceBanner => 'कम बैलेंस — एक मिनट से कम बचा है';

  @override
  String get consultAddMoney => 'पैसे जोड़ें';

  @override
  String get consultRechargeTitle => 'वॉलेट में पैसे जोड़ें';

  @override
  String get consultRechargeSubtitle => 'कॉल समाप्त किए बिना रिचार्ज करें।';

  @override
  String consultRechargeAdded(Object amount) {
    return '₹$amount जोड़े गए — कॉल जारी है।';
  }

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get profileSeeker => 'जिज्ञासु';

  @override
  String get profileAppLockTitle => 'ऐप लॉक (बायोमेट्रिक)';

  @override
  String get profileAppLockOn =>
      'ऐप खोलने के लिए बायोमेट्रिक अनलॉक आवश्यक करें।';

  @override
  String get profileAppLockOff => 'इस डिवाइस पर कोई बायोमेट्रिक सेट नहीं है।';

  @override
  String get profileChatCallHistory => 'चैट और कॉल इतिहास';

  @override
  String get profilePaymentHistory => 'भुगतान इतिहास';

  @override
  String get profileBecomeAstrologer => 'ज्योतिषी बनें';

  @override
  String get profileHelpline => 'हेल्पलाइन और सहायता';

  @override
  String get helplineNotConfigured => 'हेल्पलाइन संपर्क अभी नहीं जोड़ा गया है।';

  @override
  String get helplineEmail => 'ईमेल';

  @override
  String get helplinePhone => 'फ़ोन';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get privacyPolicyNotConfigured =>
      'गोपनीयता नीति अभी नहीं जोड़ी गई है।';

  @override
  String get profileAboutTerms => 'परिचय · नियम · गोपनीयता';

  @override
  String get profileSignOut => 'साइन आउट';

  @override
  String get profileFollowUs => 'हमें फ़ॉलो करें';

  @override
  String get profileLinkCopied => 'लिंक खुल नहीं पाया — कॉपी कर दिया गया है।';

  @override
  String get profileLanguage => 'भाषा / Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get profileTheme => 'थीम';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get completeProfileTitle => 'अपनी प्रोफ़ाइल पूरी करें';

  @override
  String get completeProfileSubtitle =>
      'आपका नाम और संपर्क नंबर — शुरुआत के लिए बस इतना ही चाहिए।';

  @override
  String get completeProfileFullName => 'पूरा नाम';

  @override
  String get completeProfileContactNumber => 'संपर्क नंबर';

  @override
  String get completeProfileSaveContinue => 'सहेजें और आगे बढ़ें';

  @override
  String get completeProfilePhotoAdd => 'प्रोफ़ाइल फ़ोटो जोड़ें (वैकल्पिक)';

  @override
  String get completeProfilePhotoChange => 'फ़ोटो बदलें';

  @override
  String get completeProfilePhotoUploadFailed =>
      'फ़ोटो अपलोड नहीं हो सकी। कृपया पुनः प्रयास करें।';

  @override
  String get completeProfileNameRequired => 'कृपया अपना नाम दर्ज करें।';

  @override
  String get completeProfileMobileIndia =>
      '+91 के लिए 10 अंकों का मान्य मोबाइल नंबर दर्ज करें।';

  @override
  String get completeProfileMobileGeneric =>
      'मान्य संपर्क नंबर दर्ज करें (4–15 अंक)।';

  @override
  String get profileEditProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get editProfileSubtitle =>
      'अपनी फ़ोटो, नाम और संपर्क नंबर अपडेट करें।';

  @override
  String get editProfileSaved => 'प्रोफ़ाइल अपडेट हो गई।';

  @override
  String get profileBirthDetails => 'जन्म विवरण';

  @override
  String get birthDetailsSubtitle =>
      'आपके जन्म विवरण से आपकी कुंडली और भविष्यवाणियाँ बनती हैं।';

  @override
  String get birthDob => 'जन्म तिथि';

  @override
  String get birthTimeOptional => 'जन्म समय (वैकल्पिक)';

  @override
  String get birthPlaceOptional => 'जन्म स्थान (वैकल्पिक)';

  @override
  String get birthSelect => 'चुनें';

  @override
  String get birthDobRequired => 'कृपया अपनी जन्म तिथि चुनें।';

  @override
  String get birthSaved => 'जन्म विवरण सहेज दिए गए।';

  @override
  String get insightsNeedBirthDetails =>
      'इस अंतर्दृष्टि के लिए प्रोफ़ाइल में अपने जन्म विवरण जोड़ें।';

  @override
  String get insightsAddBirthDetails => 'अभी जोड़ें';

  @override
  String get commonClose => 'बंद करें';

  @override
  String get insightsTitle => 'ब्रह्मांडीय अंतर्दृष्टि';

  @override
  String get insightsSubtitle => 'व्यक्तिगत वैदिक रिपोर्ट, तुरंत।';

  @override
  String get insightDailyHoroscope => 'दैनिक राशिफल';

  @override
  String get insightDetailedKundli => 'विस्तृत कुंडली';

  @override
  String get insightPlanetPosition => 'ग्रह स्थिति';

  @override
  String get insightLoveCompatibility => 'प्रेम मिलान';

  @override
  String get insightBirthdayNumber => 'जन्मांक';

  @override
  String get insightDailyPrediction => 'दैनिक भविष्यवाणी';

  @override
  String get insightsMyReports => 'मेरी रिपोर्ट';

  @override
  String get insightsMyReportsSubtitle => 'आपकी पिछली रिपोर्ट और PDF';

  @override
  String insightsChargedBalance(Object amount, Object balance) {
    return 'शुल्क ₹$amount · शेष ₹$balance';
  }

  @override
  String get insightDownloadPdf => 'PDF डाउनलोड करें';

  @override
  String get insightPdfOpenFailed => 'PDF खुल नहीं पाई।';

  @override
  String get insightPreflightTitle => 'अपने विवरण पूरे करें';

  @override
  String get insightPreflightSubtitle =>
      'रिपोर्ट तैयार करने के लिए ये विवरण आवश्यक हैं और आपकी प्रोफ़ाइल में सहेजे जाएँगे।';

  @override
  String get insightGenerateTitle => 'इस रिपोर्ट के लिए जन्म विवरण';

  @override
  String get insightGenerateSubtitle =>
      'आपकी प्रोफ़ाइल से पहले से भरा हुआ। किसी और के लिए रिपोर्ट बनाने हेतु कोई भी फ़ील्ड बदलें।';

  @override
  String get insightGenerateCta => 'रिपोर्ट बनाएँ';

  @override
  String get reportOpenFailed => 'यह रिपोर्ट खोली नहीं जा सकी।';

  @override
  String get insightSharePdf => 'रिपोर्ट साझा करें';

  @override
  String get reportSavedOffline => 'इस डिवाइस पर सहेजा गया — ऑफ़लाइन उपलब्ध।';

  @override
  String get insightPartnerTitle => 'साथी के विवरण';

  @override
  String get insightPartnerSubtitle =>
      'मिलान के लिए अपने साथी के जन्म विवरण दर्ज करें।';

  @override
  String get insightFieldName => 'पूरा नाम';

  @override
  String get insightFieldGender => 'लिंग';

  @override
  String get genderMale => 'पुरुष';

  @override
  String get genderFemale => 'महिला';

  @override
  String get genderOther => 'अन्य';

  @override
  String get insightFieldDob => 'जन्म तिथि';

  @override
  String get insightFieldBirthTime => 'जन्म समय';

  @override
  String get insightFieldBirthPlace => 'जन्म स्थान';

  @override
  String get insightFieldsRequired => 'कृपया सभी फ़ील्ड भरें।';

  @override
  String get kundliChartTitle => 'लग्न कुंडली (उत्तर भारतीय)';

  @override
  String get kundliRetroLegend => '(R) = वक्री ग्रह';

  @override
  String get kundliLagnaLabel => 'लग्न';

  @override
  String get kundliPlanetsTitle => 'ग्रह स्थितियाँ';

  @override
  String get kundliDashaTitle => 'विंशोत्तरी महादशा';

  @override
  String get colPlanet => 'ग्रह';

  @override
  String get colSign => 'राशि';

  @override
  String get colDegree => 'अंश';

  @override
  String get colNakshatra => 'नक्षत्र';

  @override
  String get colPada => 'पद';

  @override
  String get loveScoreTitle => 'अनुकूलता स्कोर';

  @override
  String get loveAshtakootTitle => 'अष्टकूट (गुण मिलान)';

  @override
  String get loveVerdictTitle => 'निष्कर्ष';

  @override
  String get loveStrengthsTitle => 'मज़बूत पक्ष';

  @override
  String get numberTraitsTitle => 'विशेषताएँ';

  @override
  String get numberLifePath => 'मूलांक (लाइफ पाथ)';

  @override
  String get predictionActionsTitle => 'आज के श्रेष्ठ कार्य';

  @override
  String get predictionCautionsTitle => 'आज सावधानी रखें';

  @override
  String get insightNoDetails =>
      'आपकी रिपोर्ट तैयार है — पूरे विवरण के लिए PDF डाउनलोड करें।';

  @override
  String get reportsEmpty =>
      'अभी कोई रिपोर्ट नहीं। पहली रिपोर्ट बनाने के लिए कोई अंतर्दृष्टि चलाएँ।';

  @override
  String get reportsOpenPdf => 'PDF खोलें';

  @override
  String get imageViewerClose => 'बंद करें';

  @override
  String get liveAnsweringNow => 'अभी उत्तर दे रहे हैं';

  @override
  String get liveTopGifters => 'शीर्ष उपहारदाता';

  @override
  String get liveReconnectingVideo => 'वीडियो से पुनः कनेक्ट हो रहा है…';
}
