// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'हिन्दुस्तानी ज्योतिष — ज्योतिषी';

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
  String get commonSettings => 'सेटिंग्स';

  @override
  String get commonSignOut => 'साइन आउट';

  @override
  String get navDashboard => 'डैशबोर्ड';

  @override
  String get navRequests => 'अनुरोध';

  @override
  String get navEarnings => 'कमाई';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get authApplyTitle => 'ज्योतिषी के रूप में आवेदन करें';

  @override
  String get authApplySubtitle =>
      'आपके सभी परामर्श और कमाई के लिए एक ही डैशबोर्ड।';

  @override
  String get authContinueWithGoogle => 'Google से जारी रखें';

  @override
  String get dashWelcomeBack => 'वापसी पर स्वागत है';

  @override
  String dashReviews(Object count) {
    return '$count समीक्षाएँ';
  }

  @override
  String get dashOnline => 'आप ऑनलाइन हैं';

  @override
  String get dashOffline => 'आप ऑफ़लाइन हैं';

  @override
  String get dashOnlineSubtitle => 'परामर्श अनुरोध प्राप्त हो रहे हैं';

  @override
  String get dashOfflineSubtitle =>
      'अनुरोध प्राप्त करना शुरू करने के लिए टॉगल करें';

  @override
  String get dashGoLive => 'लाइव जाएँ';

  @override
  String get dashRequests => 'अनुरोध';

  @override
  String get dashSettings => 'सेटिंग्स';

  @override
  String get dashSettingsSubtitle => 'शुल्क, परिचय, भाषाएँ और फ़ोटो';

  @override
  String get statTodayEarnings => 'आज की कमाई';

  @override
  String get statBalance => 'शेष राशि';

  @override
  String get statTodayConsults => 'आज के परामर्श';

  @override
  String get statTotalConsults => 'कुल परामर्श';

  @override
  String get statRating => 'रेटिंग';

  @override
  String get statFollowers => 'अनुयायी';

  @override
  String get reqTitle => 'आने वाले अनुरोध';

  @override
  String get reqEmpty =>
      'कोई लंबित अनुरोध नहीं।\nताज़ा करने के लिए नीचे खींचें।';

  @override
  String reqRequestLabel(String kind) {
    return '$kind अनुरोध';
  }

  @override
  String get reqDecline => 'अस्वीकार करें';

  @override
  String get reqAccept => 'स्वीकार करें';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get profileAstrologer => 'ज्योतिषी';

  @override
  String get profileSkills => 'विद्याएँ';

  @override
  String get profileLanguages => 'भाषाएँ';

  @override
  String get profileExperience => 'अनुभव';

  @override
  String get profileRating => 'रेटिंग';

  @override
  String get profileChatRate => 'चैट दर';

  @override
  String get profileCallRate => 'कॉल दर';

  @override
  String get profileVideoRate => 'वीडियो दर';

  @override
  String profileYears(Object years) {
    return '$years वर्ष';
  }

  @override
  String get profileEditCharges => 'प्रोफ़ाइल और शुल्क संपादित करें';

  @override
  String get profileAccountSection => 'खाता';

  @override
  String get profileEditProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get profileEditProfileSub =>
      'नाम, परिचय, विद्याएँ, भाषाएँ, दरें और फ़ोटो';

  @override
  String get profileBankPan => 'बैंक और पैन विवरण';

  @override
  String get profileBankPanSub => 'पेआउट विधि, बैंक खाता और पैन';

  @override
  String get editProfileTitle => 'प्रोफ़ाइल संपादित करें';

  @override
  String get editProfileSubtitle =>
      'जिज्ञासु आपको कैसे देखें और आप क्या शुल्क लेते हैं, यह अपडेट करें।';

  @override
  String get bankPanTitle => 'बैंक और पैन विवरण';

  @override
  String get bankPanIntro =>
      'निकासी और सत्यापन के लिए उपयोग किए जाने वाले आपके पेआउट और पहचान विवरण।';

  @override
  String get bankPanPayoutSection => 'पेआउट विधि';

  @override
  String get bankPanIdentitySection => 'पहचान';

  @override
  String get bankPanDocsSection => 'दस्तावेज़';

  @override
  String get bankPanBankName => 'बैंक का नाम';

  @override
  String get bankPanIfsc => 'IFSC कोड';

  @override
  String get bankPanAccountHolder => 'खाताधारक';

  @override
  String get bankPanAccountNumber => 'खाता संख्या';

  @override
  String get bankPanUpiId => 'UPI आईडी';

  @override
  String get bankPanPan => 'पैन नंबर';

  @override
  String get bankPanAadhaar => 'आधार नंबर';

  @override
  String bankPanMasked(String last4) {
    return '•••• $last4';
  }

  @override
  String get bankPanNotSet => 'सेट नहीं है';

  @override
  String get bankPanEditCta => 'बैंक और पैन विवरण संपादित करें';

  @override
  String get bankPanAddCta => 'बैंक और पैन विवरण जोड़ें';

  @override
  String get bankPanApprovalNote =>
      'बैंक या पैन विवरण में परिवर्तन एडमिन अनुमोदन के लिए भेजे जाते हैं और अनुमोदित होने पर लागू होते हैं।';

  @override
  String get bankPanEmpty =>
      'आपने अभी तक अपने बैंक और पैन विवरण नहीं जोड़े हैं।';

  @override
  String get bankPanLoadFailed => 'आपके बैंक और पैन विवरण लोड नहीं हो सके।';

  @override
  String get setTitle => 'सेटिंग्स';

  @override
  String get setChangePhoto => 'अपनी फ़ोटो बदलने के लिए कैमरे पर टैप करें';

  @override
  String get setCharges => 'शुल्क';

  @override
  String get setChatRate => 'चैट दर';

  @override
  String get setCallRate => 'कॉल दर';

  @override
  String get setVideoRate => 'वीडियो दर';

  @override
  String get setPerMessage => '₹ / संदेश';

  @override
  String get setPerMinute => '₹ / मिनट';

  @override
  String get setSuperChatRate => 'सुपर चैट मूल्य';

  @override
  String get setPerSuperChat => '₹ / सुपर चैट';

  @override
  String get setSuperChatInvalid =>
      'मान्य सुपर चैट मूल्य दर्ज करें (₹0 से अधिक)।';

  @override
  String get setSuperChatMax =>
      'सुपर चैट मूल्य ₹10000 से अधिक नहीं होना चाहिए।';

  @override
  String get setAboutYou => 'आपके बारे में';

  @override
  String get setDisplayName => 'प्रदर्शित नाम';

  @override
  String get setBio => 'परिचय';

  @override
  String get setBioHint => 'जिज्ञासुओं को अपनी विद्या के बारे में बताएँ…';

  @override
  String get setSkills => 'विद्याएँ';

  @override
  String get setSkillsHint => 'वैदिक, टैरो, अंक ज्योतिष';

  @override
  String get setLanguagesField => 'भाषाएँ';

  @override
  String get setLanguagesHint => 'हिन्दी, अंग्रेज़ी';

  @override
  String get setCommaSeparated => 'अल्पविराम से अलग करें';

  @override
  String get setKycDocsTitle => 'KYC दस्तावेज़';

  @override
  String get setKycDocsSubtitle =>
      'सत्यापन के लिए आपके जमा किए गए पहचान दस्तावेज़।';

  @override
  String get setKycDocsLocked =>
      'अनुमोदन के बाद दस्तावेज़ लॉक हो जाते हैं। इन्हें बदलने के लिए सहायता टीम से संपर्क करें।';

  @override
  String get setKycResubmit => 'KYC दस्तावेज़ अपडेट करें';

  @override
  String get setKycUpdateButton => 'KYC / पेआउट विवरण अपडेट करें';

  @override
  String get setKycUpdateNote => 'परिवर्तन एडमिन अनुमोदन के बाद लागू होंगे।';

  @override
  String get setKycNotUploaded => 'अपलोड नहीं किया गया';

  @override
  String get setKycLoadFailed => 'KYC दस्तावेज़ लोड नहीं हो सके।';

  @override
  String get setDocPhoto => 'फ़ोटो';

  @override
  String get setDocPan => 'पैन कार्ड';

  @override
  String get setDocAadhaar => 'आधार (आगे का भाग)';

  @override
  String get setDocAadhaarBack => 'आधार (पीछे का भाग)';

  @override
  String get setDocBankProof => 'बैंक प्रमाण';

  @override
  String get setDocCertificate => 'प्रमाणपत्र';

  @override
  String get setPayoutMethodLabel => 'पेआउट विधि';

  @override
  String get setPayoutUpi => 'UPI';

  @override
  String get setPayoutBank => 'बैंक खाता';

  @override
  String get setSaveChanges => 'परिवर्तन सहेजें';

  @override
  String get setSaving => 'सहेजा जा रहा है…';

  @override
  String get setProfileUpdated => 'प्रोफ़ाइल अपडेट हो गई';

  @override
  String get setPhotoUpdated => 'फ़ोटो अपडेट हो गई';

  @override
  String get setChangesPendingApproval =>
      'परिवर्तन एडमिन अनुमोदन के लिए भेज दिए गए हैं — अनुमोदित होते ही लागू हो जाएँगे।';

  @override
  String get setPendingEditBanner =>
      'आपके प्रोफ़ाइल परिवर्तन एडमिन अनुमोदन की प्रतीक्षा में हैं।';

  @override
  String get setPendingEditRejected =>
      'आपके हाल के प्रोफ़ाइल परिवर्तन अस्वीकार कर दिए गए।';

  @override
  String setPendingEditFields(String fields) {
    return 'बदले गए फ़ील्ड: $fields';
  }

  @override
  String get setFieldMobile => 'संपर्क नंबर';

  @override
  String get setFieldCountryCode => 'देश कोड';

  @override
  String get setFieldKyc => 'KYC / पेआउट विवरण';

  @override
  String get appLanguageSection => 'ऐप';

  @override
  String get appLanguage => 'भाषा / Language';

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
  String get callIncomingVoice => 'इनकमिंग वॉइस कॉल';

  @override
  String get callIncomingVideo => 'इनकमिंग वीडियो कॉल';

  @override
  String callRatePerMin(String rate) {
    return '₹$rate/मिनट';
  }

  @override
  String callAutoDeclineIn(int seconds) {
    return '$seconds सेकंड में अपने-आप अस्वीकार';
  }

  @override
  String get callAccept => 'स्वीकारें';

  @override
  String get callDecline => 'अस्वीकारें';

  @override
  String get callConnecting => 'कनेक्ट हो रहा है…';

  @override
  String get callExpired => 'कॉल समाप्त';

  @override
  String get callExpiredBody => 'यह कॉल अनुरोध अब उपलब्ध नहीं है।';

  @override
  String get callCouldNotStart =>
      'कॉल शुरू नहीं हो सकी: सर्वर ने Agora कॉल विवरण नहीं लौटाया।';

  @override
  String get commonSeeker => 'जिज्ञासु';

  @override
  String get commonClose => 'बंद करें';

  @override
  String get commonUser => 'उपयोगकर्ता';

  @override
  String get commonEnd => 'समाप्त करें';

  @override
  String get callPermMic =>
      'यह कॉल लेने के लिए माइक्रोफ़ोन की अनुमति आवश्यक है। इसे सेटिंग्स में सक्षम करें और पुनः प्रयास करें।';

  @override
  String get callPermMicCam =>
      'यह कॉल लेने के लिए माइक्रोफ़ोन और कैमरे की अनुमति आवश्यक है। इसे सेटिंग्स में सक्षम करें और पुनः प्रयास करें।';

  @override
  String get callAvUnavailable =>
      'ज्योतिषी ऑडियो/वीडियो उपलब्ध नहीं — सर्वर का Agora टोकन अनुपलब्ध है।';

  @override
  String callConnectFailed(String error) {
    return 'कॉल कनेक्ट नहीं हो सकी: $error';
  }

  @override
  String get callEndConfirmTitle => 'यह कॉल समाप्त करें?';

  @override
  String get callEndConfirmBody =>
      'जिज्ञासु का संपर्क टूट जाएगा और यह सत्र समाप्त हो जाएगा। इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String callEndedBy(String name) {
    return '$name ने कॉल समाप्त की';
  }

  @override
  String get callCantConnect => 'कनेक्ट नहीं हो सका';

  @override
  String get callReconnecting => 'पुनः कनेक्ट हो रहा है…';

  @override
  String get callConnected => 'कनेक्ट हो गया';

  @override
  String get callWaitingForSeeker => 'जिज्ञासु की प्रतीक्षा है…';

  @override
  String get callVideoTitle => 'वीडियो कॉल';

  @override
  String get callAudioTitle => 'ऑडियो कॉल';

  @override
  String callEarningsSoFar(String amount) {
    return 'अब तक की कमाई: ₹$amount';
  }

  @override
  String callRateDotPerMin(String rate) {
    return '· ₹$rate/मिनट';
  }

  @override
  String get callPillCantConnect => 'कनेक्ट नहीं';

  @override
  String get callPillConnecting => 'कनेक्ट हो रहा है';

  @override
  String get callPillReconnecting => 'पुनः कनेक्ट';

  @override
  String get callPillWaiting => 'प्रतीक्षा';

  @override
  String callPillLive(String elapsed) {
    return 'लाइव · $elapsed';
  }

  @override
  String get chatReconnecting => 'पुनः कनेक्ट हो रहा है…';

  @override
  String chatWithName(String name) {
    return '$name के साथ चैट';
  }

  @override
  String get chatEnded => 'समाप्त';

  @override
  String get chatLive => 'लाइव';

  @override
  String get chatWaitingNamaste => 'जिज्ञासु के नमस्ते कहने की प्रतीक्षा है 🙏';

  @override
  String get chatSending => 'भेजा जा रहा है…';

  @override
  String get chatNotSentRetry => 'नहीं भेजा गया · पुनः प्रयास हेतु टैप करें';

  @override
  String get chatReplyHint => 'उत्तर दें…';

  @override
  String get chatEndedHint => 'चैट समाप्त';

  @override
  String get chatSendTooltip => 'संदेश भेजें';

  @override
  String get liveDefaultTitle => 'संध्या राशिफल';

  @override
  String get liveSetRatesFirst =>
      'लाइव जाने से पहले अपनी चैट, कॉल और वीडियो दरें निर्धारित करें।';

  @override
  String get liveMessageSent => 'संदेश भेजा गया';

  @override
  String get liveMessageSendFailed =>
      'भेजा नहीं जा सका — चैट से पुनः कनेक्ट हो रहा है, कुछ ही पल में फिर प्रयास करें।';

  @override
  String get livePinFailed =>
      'पिन नहीं किया जा सका — चैट से पुनः कनेक्ट हो रहा है, फिर प्रयास करें।';

  @override
  String get liveSetGiftGoalTitle => 'गिफ़्ट लक्ष्य निर्धारित करें';

  @override
  String get liveGiftGoalHint => 'उदा. 5000';

  @override
  String get liveEndConfirmTitle => 'लाइव प्रसारण समाप्त करें?';

  @override
  String get liveEndConfirmBody =>
      'आपके दर्शकों का संपर्क टूट जाएगा और यह सत्र समाप्त हो जाएगा। इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String get liveStartTitle => 'लाइव सत्र शुरू करें';

  @override
  String get liveStartSubtitle =>
      'जब आप लाइव जाते हैं तो आपके अनुयायियों को सूचना मिलती है।';

  @override
  String get liveStreamTitleLabel => 'प्रसारण शीर्षक';

  @override
  String get liveStarting => 'शुरू हो रहा है…';

  @override
  String get liveGiftGoalTooltip => 'गिफ़्ट लक्ष्य';

  @override
  String get liveFlipCamera => 'कैमरा बदलें';

  @override
  String get liveReconnectingVideo => 'वीडियो पुनः कनेक्ट हो रहा है…';

  @override
  String get liveReconnectingChat => 'चैट पुनः कनेक्ट हो रही है…';

  @override
  String get liveChatEmpty => 'दर्शकों के संदेश यहाँ दिखाई देंगे…';

  @override
  String liveReplyingTo(String name) {
    return '@$name को उत्तर';
  }

  @override
  String liveReplyHint(String name) {
    return '@$name को उत्तर दें…';
  }

  @override
  String get liveSayHiHint => 'अपने दर्शकों को नमस्ते कहें…';

  @override
  String get liveWrapTitle => 'यह रहा समापन!';

  @override
  String get liveWrapSubtitle => 'देखें आपका सत्र कैसा रहा।';

  @override
  String get liveDuration => 'अवधि';

  @override
  String get livePeakViewers => 'अधिकतम दर्शक';

  @override
  String get liveBadge => 'लाइव';

  @override
  String get liveEndButton => 'लाइव समाप्त';

  @override
  String get liveMuteMic => 'माइक्रोफ़ोन म्यूट करें';

  @override
  String get liveUnmuteMic => 'माइक्रोफ़ोन अनम्यूट करें';

  @override
  String get liveGift => 'गिफ़्ट';

  @override
  String get liveAnsweringNow => 'अभी उत्तर दे रहे हैं — ';

  @override
  String get commonErrorGeneric =>
      'कुछ गड़बड़ हो गई। कृपया फिर से प्रयास करें।';

  @override
  String get profileDeleteAccount => 'खाता हटाएँ';

  @override
  String get deleteAccountTitle => 'खाता हटाएँ?';

  @override
  String get deleteAccountWarning =>
      'इससे आपका ज्योतिषी खाता स्थायी रूप से हट जाएगा। आपकी प्रोफ़ाइल और KYC हटा दी जाएगी, आप ऑफ़लाइन हो जाएँगे और खोज से छिप जाएँगे, सभी सत्र समाप्त हो जाएँगे, और इसे पूर्ववत नहीं किया जा सकता। पहले कोई भी शेष राशि निकाल लें और चालू परामर्श पूरे कर लें।';

  @override
  String get deleteAccountTypeHint => 'पुष्टि के लिए DELETE टाइप करें';

  @override
  String get deleteAccountConfirm => 'खाता हटाएँ';

  @override
  String get deleteAccountSuccess => 'आपका खाता हटा दिया गया है।';

  @override
  String get earningsAddPanTitle => 'निकासी के लिए अपना PAN जोड़ें';

  @override
  String get earningsAddPanBody =>
      'हर भुगतान पर आपके PAN के विरुद्ध TDS काटा जाता है। निकासी से पहले अपने बैंक और PAN विवरण में एक वैध PAN जोड़ें।';

  @override
  String get earningsAddPanAction => 'PAN जोड़ें';

  @override
  String earningsTdsNote(String rate) {
    return 'प्रत्येक भुगतान पर आपके PAN के विरुद्ध $rate% TDS काटा जाता है।';
  }

  @override
  String get earningsRecentPayouts => 'हाल की निकासियाँ';

  @override
  String get earningsPayoutTds => 'TDS';

  @override
  String get earningsPayoutNet => 'शुद्ध भुगतान';

  @override
  String get earningsPayoutGross => 'सकल';

  @override
  String get earningsNoPayouts => 'अभी तक कोई निकासी नहीं।';

  @override
  String get notificationsTitle => 'सूचनाएँ';

  @override
  String get notificationsEmpty => 'आपके पास अभी कोई सूचना नहीं है।';

  @override
  String get notificationsMarkAllRead => 'सभी को पढ़ा हुआ चिह्नित करें';

  @override
  String get supportTitle => 'सहायता एवं समर्थन';

  @override
  String get supportFaqTab => 'सामान्य प्रश्न';

  @override
  String get supportTicketsTab => 'मेरे टिकट';

  @override
  String get supportFaqEmpty => 'अभी कोई सहायता लेख उपलब्ध नहीं है।';

  @override
  String get supportTicketsEmpty => 'आपके पास अभी कोई सहायता टिकट नहीं है।';

  @override
  String get supportRaiseTicket => 'टिकट बनाएँ';

  @override
  String get supportSubject => 'विषय';

  @override
  String get supportMessage => 'अपनी समस्या बताएँ';

  @override
  String get supportSubmit => 'भेजें';

  @override
  String get supportFillFields => 'कृपया विषय और संदेश भरें।';

  @override
  String get supportTicket => 'टिकट';

  @override
  String get supportReplyHint => 'उत्तर लिखें…';

  @override
  String get supportReopenHint => 'इस टिकट को फिर से खोलने के लिए उत्तर दें…';

  @override
  String get supportSenderYou => 'आप';

  @override
  String get supportSenderSupport => 'सहायता';

  @override
  String get supportStatusOpen => 'खुला';

  @override
  String get supportStatusPending => 'आपकी प्रतिक्रिया अपेक्षित';

  @override
  String get supportStatusClosed => 'बंद';
}
