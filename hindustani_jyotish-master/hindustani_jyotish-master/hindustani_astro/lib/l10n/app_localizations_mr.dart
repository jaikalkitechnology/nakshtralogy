// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'हिंदुस्तानी ज्योतिष — ज्योतिषी';

  @override
  String get commonOk => 'ठीक आहे';

  @override
  String get commonCancel => 'रद्द करा';

  @override
  String get commonRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get commonSave => 'जतन करा';

  @override
  String get commonDone => 'पूर्ण';

  @override
  String get commonSettings => 'सेटिंग्ज';

  @override
  String get commonSignOut => 'साइन आउट';

  @override
  String get navDashboard => 'डॅशबोर्ड';

  @override
  String get navRequests => 'विनंत्या';

  @override
  String get navEarnings => 'कमाई';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get authApplyTitle => 'ज्योतिषी म्हणून अर्ज करा';

  @override
  String get authApplySubtitle =>
      'तुमच्या सर्व सल्ला आणि कमाईसाठी एकच डॅशबोर्ड.';

  @override
  String get authContinueWithGoogle => 'Google सह सुरू ठेवा';

  @override
  String get dashWelcomeBack => 'पुन्हा स्वागत आहे';

  @override
  String dashReviews(Object count) {
    return '$count पुनरावलोकने';
  }

  @override
  String get dashOnline => 'तुम्ही ऑनलाइन आहात';

  @override
  String get dashOffline => 'तुम्ही ऑफलाइन आहात';

  @override
  String get dashOnlineSubtitle => 'सल्ला विनंत्या प्राप्त होत आहेत';

  @override
  String get dashOfflineSubtitle =>
      'विनंत्या प्राप्त करणे सुरू करण्यासाठी टॉगल करा';

  @override
  String get dashGoLive => 'लाइव्ह जा';

  @override
  String get dashRequests => 'विनंत्या';

  @override
  String get dashSettings => 'सेटिंग्ज';

  @override
  String get dashSettingsSubtitle => 'शुल्क, परिचय, भाषा आणि फोटो';

  @override
  String get statTodayEarnings => 'आजची कमाई';

  @override
  String get statBalance => 'शिल्लक';

  @override
  String get statTodayConsults => 'आजचे सल्ला';

  @override
  String get statTotalConsults => 'एकूण सल्ला';

  @override
  String get statRating => 'रेटिंग';

  @override
  String get statFollowers => 'फॉलोअर्स';

  @override
  String get reqTitle => 'येणाऱ्या विनंत्या';

  @override
  String get reqEmpty =>
      'कोणतीही प्रलंबित विनंती नाही.\nरिफ्रेश करण्यासाठी खाली खेचा.';

  @override
  String reqRequestLabel(String kind) {
    return '$kind विनंती';
  }

  @override
  String get reqDecline => 'नाकारा';

  @override
  String get reqAccept => 'स्वीकारा';

  @override
  String get profileTitle => 'प्रोफाइल';

  @override
  String get profileAstrologer => 'ज्योतिषी';

  @override
  String get profileSkills => 'कौशल्ये';

  @override
  String get profileLanguages => 'भाषा';

  @override
  String get profileExperience => 'अनुभव';

  @override
  String get profileRating => 'रेटिंग';

  @override
  String get profileChatRate => 'चॅट दर';

  @override
  String get profileCallRate => 'कॉल दर';

  @override
  String get profileVideoRate => 'व्हिडिओ दर';

  @override
  String profileYears(Object years) {
    return '$years वर्षे';
  }

  @override
  String get profileEditCharges => 'प्रोफाइल आणि शुल्क संपादित करा';

  @override
  String get profileAccountSection => 'खाते';

  @override
  String get profileEditProfile => 'प्रोफाइल संपादित करा';

  @override
  String get profileEditProfileSub =>
      'नाव, परिचय, कौशल्ये, भाषा, दर आणि फोटो';

  @override
  String get profileBankPan => 'बँक आणि पॅन तपशील';

  @override
  String get profileBankPanSub => 'पेआउट पद्धत, बँक खाते आणि पॅन';

  @override
  String get editProfileTitle => 'प्रोफाइल संपादित करा';

  @override
  String get editProfileSubtitle =>
      'जिज्ञासू तुम्हाला कसे पाहतात आणि तुम्ही किती शुल्क आकारता ते अद्ययावत करा.';

  @override
  String get bankPanTitle => 'बँक आणि पॅन तपशील';

  @override
  String get bankPanIntro =>
      'पैसे काढणे आणि पडताळणीसाठी वापरले जाणारे तुमचे पेआउट आणि ओळख तपशील.';

  @override
  String get bankPanPayoutSection => 'पेआउट पद्धत';

  @override
  String get bankPanIdentitySection => 'ओळख';

  @override
  String get bankPanDocsSection => 'कागदपत्रे';

  @override
  String get bankPanBankName => 'बँकेचे नाव';

  @override
  String get bankPanIfsc => 'IFSC कोड';

  @override
  String get bankPanAccountHolder => 'खातेधारक';

  @override
  String get bankPanAccountNumber => 'खाते क्रमांक';

  @override
  String get bankPanUpiId => 'UPI आयडी';

  @override
  String get bankPanPan => 'पॅन क्रमांक';

  @override
  String get bankPanAadhaar => 'आधार क्रमांक';

  @override
  String bankPanMasked(String last4) {
    return '•••• $last4';
  }

  @override
  String get bankPanNotSet => 'सेट केलेले नाही';

  @override
  String get bankPanEditCta => 'बँक आणि पॅन तपशील संपादित करा';

  @override
  String get bankPanAddCta => 'बँक आणि पॅन तपशील जोडा';

  @override
  String get bankPanApprovalNote =>
      'बँक किंवा पॅन तपशीलातील बदल प्रशासकांच्या मंजुरीसाठी सादर केले जातात आणि मंजूर झाल्यावर लागू होतात.';

  @override
  String get bankPanEmpty =>
      'तुम्ही अद्याप तुमचे बँक आणि पॅन तपशील जोडलेले नाहीत.';

  @override
  String get bankPanLoadFailed => 'तुमचे बँक आणि पॅन तपशील लोड करता आले नाहीत.';

  @override
  String get setTitle => 'सेटिंग्ज';

  @override
  String get setChangePhoto => 'तुमचा फोटो बदलण्यासाठी कॅमेऱ्यावर टॅप करा';

  @override
  String get setCharges => 'शुल्क';

  @override
  String get setChatRate => 'चॅट दर';

  @override
  String get setCallRate => 'कॉल दर';

  @override
  String get setVideoRate => 'व्हिडिओ दर';

  @override
  String get setPerMessage => '₹ / संदेश';

  @override
  String get setPerMinute => '₹ / मिनिट';

  @override
  String get setSuperChatRate => 'सुपर चॅट किंमत';

  @override
  String get setPerSuperChat => '₹ / सुपर चॅट';

  @override
  String get setSuperChatInvalid =>
      'वैध सुपर चॅट किंमत टाका (₹0 पेक्षा जास्त).';

  @override
  String get setSuperChatMax =>
      'सुपर चॅट किंमत ₹10000 पेक्षा जास्त नसावी.';

  @override
  String get setAboutYou => 'तुमच्याबद्दल';

  @override
  String get setDisplayName => 'प्रदर्शित नाव';

  @override
  String get setBio => 'परिचय';

  @override
  String get setBioHint => 'जिज्ञासूंना तुमच्या सरावाबद्दल सांगा…';

  @override
  String get setSkills => 'कौशल्ये';

  @override
  String get setSkillsHint => 'वैदिक, टॅरो, अंकशास्त्र';

  @override
  String get setLanguagesField => 'भाषा';

  @override
  String get setLanguagesHint => 'हिंदी, इंग्रजी';

  @override
  String get setCommaSeparated => 'स्वल्पविरामाने वेगळे करा';

  @override
  String get setKycDocsTitle => 'KYC कागदपत्रे';

  @override
  String get setKycDocsSubtitle =>
      'पडताळणीसाठी तुम्ही सादर केलेली ओळख कागदपत्रे.';

  @override
  String get setKycDocsLocked =>
      'मंजुरीनंतर कागदपत्रे लॉक होतात. ती बदलण्यासाठी सहाय्य टीमशी संपर्क साधा.';

  @override
  String get setKycResubmit => 'KYC कागदपत्रे अद्ययावत करा';

  @override
  String get setKycUpdateButton => 'KYC / पेआउट तपशील अद्ययावत करा';

  @override
  String get setKycUpdateNote => 'बदल प्रशासकांच्या मंजुरीनंतर लागू होतील.';

  @override
  String get setKycNotUploaded => 'अपलोड केलेले नाही';

  @override
  String get setKycLoadFailed => 'KYC कागदपत्रे लोड करता आली नाहीत.';

  @override
  String get setDocPhoto => 'फोटो';

  @override
  String get setDocPan => 'पॅन कार्ड';

  @override
  String get setDocAadhaar => 'आधार (पुढील बाजू)';

  @override
  String get setDocAadhaarBack => 'आधार (मागील बाजू)';

  @override
  String get setDocBankProof => 'बँक पुरावा';

  @override
  String get setDocCertificate => 'प्रमाणपत्र';

  @override
  String get setPayoutMethodLabel => 'पेआउट पद्धत';

  @override
  String get setPayoutUpi => 'UPI';

  @override
  String get setPayoutBank => 'बँक खाते';

  @override
  String get setSaveChanges => 'बदल जतन करा';

  @override
  String get setSaving => 'जतन होत आहे…';

  @override
  String get setProfileUpdated => 'प्रोफाइल अद्ययावत झाली';

  @override
  String get setPhotoUpdated => 'फोटो अद्ययावत झाला';

  @override
  String get setChangesPendingApproval =>
      'बदल प्रशासकांच्या मंजुरीसाठी सादर केले आहेत — मंजूर होताच लागू होतील.';

  @override
  String get setPendingEditBanner =>
      'तुमचे प्रोफाइल बदल प्रशासकांच्या मंजुरीच्या प्रतीक्षेत आहेत.';

  @override
  String get setPendingEditRejected =>
      'तुमचे अलीकडील प्रोफाइल बदल नाकारण्यात आले.';

  @override
  String setPendingEditFields(String fields) {
    return 'बदललेली फील्ड: $fields';
  }

  @override
  String get setFieldMobile => 'संपर्क क्रमांक';

  @override
  String get setFieldCountryCode => 'देश कोड';

  @override
  String get setFieldKyc => 'KYC / पेआउट तपशील';

  @override
  String get appLanguageSection => 'अ‍ॅप';

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
  String get languageSystem => 'सिस्टम डीफॉल्ट';

  @override
  String get profileTheme => 'थीम';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeSystem => 'सिस्टम डीफॉल्ट';

  @override
  String get callIncomingVoice => 'येणारा व्हॉइस कॉल';

  @override
  String get callIncomingVideo => 'येणारा व्हिडिओ कॉल';

  @override
  String callRatePerMin(String rate) {
    return '₹$rate/मिनिट';
  }

  @override
  String callAutoDeclineIn(int seconds) {
    return '$seconds सेकंदात आपोआप नाकारले जाईल';
  }

  @override
  String get callAccept => 'स्वीकारा';

  @override
  String get callDecline => 'नाकारा';

  @override
  String get callConnecting => 'कनेक्ट होत आहे…';

  @override
  String get callExpired => 'कॉल कालबाह्य झाला';

  @override
  String get callExpiredBody => 'ही कॉल विनंती आता उपलब्ध नाही.';

  @override
  String get callCouldNotStart =>
      'कॉल सुरू होऊ शकला नाही: सर्व्हरने Agora कॉल तपशील परत दिले नाहीत.';

  @override
  String get commonSeeker => 'जिज्ञासू';

  @override
  String get commonClose => 'बंद करा';

  @override
  String get commonUser => 'वापरकर्ता';

  @override
  String get commonEnd => 'संपवा';

  @override
  String get callPermMic =>
      'हा कॉल घेण्यासाठी मायक्रोफोन परवानगी आवश्यक आहे. सेटिंग्जमध्ये ती सक्षम करा आणि पुन्हा प्रयत्न करा.';

  @override
  String get callPermMicCam =>
      'हा कॉल घेण्यासाठी मायक्रोफोन आणि कॅमेरा परवानगी आवश्यक आहे. सेटिंग्जमध्ये ती सक्षम करा आणि पुन्हा प्रयत्न करा.';

  @override
  String get callAvUnavailable =>
      'ज्योतिषी ऑडिओ/व्हिडिओ उपलब्ध नाही — सर्व्हरचा Agora टोकन गहाळ आहे.';

  @override
  String callConnectFailed(String error) {
    return 'कॉल कनेक्ट होऊ शकला नाही: $error';
  }

  @override
  String get callEndConfirmTitle => 'हा कॉल संपवायचा?';

  @override
  String get callEndConfirmBody =>
      'जिज्ञासूचा संपर्क तुटेल आणि हे सत्र संपेल. हे पूर्ववत करता येणार नाही.';

  @override
  String callEndedBy(String name) {
    return '$name ने कॉल संपवला';
  }

  @override
  String get callCantConnect => 'कनेक्ट होऊ शकले नाही';

  @override
  String get callReconnecting => 'पुन्हा कनेक्ट होत आहे…';

  @override
  String get callConnected => 'कनेक्ट झाले';

  @override
  String get callWaitingForSeeker => 'जिज्ञासूची प्रतीक्षा आहे…';

  @override
  String get callVideoTitle => 'व्हिडिओ कॉल';

  @override
  String get callAudioTitle => 'ऑडिओ कॉल';

  @override
  String callEarningsSoFar(String amount) {
    return 'आतापर्यंतची कमाई: ₹$amount';
  }

  @override
  String callRateDotPerMin(String rate) {
    return '· ₹$rate/मिनिट';
  }

  @override
  String get callPillCantConnect => 'कनेक्ट नाही';

  @override
  String get callPillConnecting => 'कनेक्ट होत आहे';

  @override
  String get callPillReconnecting => 'पुन्हा कनेक्ट';

  @override
  String get callPillWaiting => 'प्रतीक्षा';

  @override
  String callPillLive(String elapsed) {
    return 'लाइव्ह · $elapsed';
  }

  @override
  String get chatReconnecting => 'पुन्हा कनेक्ट होत आहे…';

  @override
  String chatWithName(String name) {
    return '$name सोबत चॅट';
  }

  @override
  String get chatEnded => 'संपले';

  @override
  String get chatLive => 'लाइव्ह';

  @override
  String get chatWaitingNamaste => 'जिज्ञासू नमस्कार म्हणण्याची प्रतीक्षा आहे 🙏';

  @override
  String get chatSending => 'पाठवत आहे…';

  @override
  String get chatNotSentRetry => 'पाठवले नाही · पुन्हा प्रयत्नासाठी टॅप करा';

  @override
  String get chatReplyHint => 'उत्तर द्या…';

  @override
  String get chatEndedHint => 'चॅट संपली';

  @override
  String get chatSendTooltip => 'संदेश पाठवा';

  @override
  String get liveDefaultTitle => 'संध्याकाळचे राशिभविष्य';

  @override
  String get liveSetRatesFirst =>
      'लाइव्ह जाण्यापूर्वी तुमचे चॅट, कॉल आणि व्हिडिओ दर निश्चित करा.';

  @override
  String get liveMessageSent => 'संदेश पाठवला';

  @override
  String get liveMessageSendFailed =>
      'पाठवता आले नाही — चॅटशी पुन्हा कनेक्ट होत आहे, थोड्या वेळाने पुन्हा प्रयत्न करा.';

  @override
  String get livePinFailed =>
      'पिन करता आले नाही — चॅटशी पुन्हा कनेक्ट होत आहे, पुन्हा प्रयत्न करा.';

  @override
  String get liveSetGiftGoalTitle => 'भेटवस्तू ध्येय निश्चित करा';

  @override
  String get liveGiftGoalHint => 'उदा. 5000';

  @override
  String get liveEndConfirmTitle => 'लाइव्ह प्रसारण संपवायचे?';

  @override
  String get liveEndConfirmBody =>
      'तुमच्या प्रेक्षकांचा संपर्क तुटेल आणि हे सत्र संपेल. हे पूर्ववत करता येणार नाही.';

  @override
  String get liveStartTitle => 'लाइव्ह सत्र सुरू करा';

  @override
  String get liveStartSubtitle =>
      'तुम्ही लाइव्ह जाता तेव्हा तुमच्या फॉलोअर्सना सूचना मिळते.';

  @override
  String get liveStreamTitleLabel => 'प्रसारण शीर्षक';

  @override
  String get liveStarting => 'सुरू होत आहे…';

  @override
  String get liveGiftGoalTooltip => 'भेटवस्तू ध्येय';

  @override
  String get liveFlipCamera => 'कॅमेरा बदला';

  @override
  String get liveReconnectingVideo => 'व्हिडिओ पुन्हा कनेक्ट होत आहे…';

  @override
  String get liveReconnectingChat => 'चॅट पुन्हा कनेक्ट होत आहे…';

  @override
  String get liveChatEmpty => 'प्रेक्षकांचे संदेश येथे दिसतील…';

  @override
  String liveReplyingTo(String name) {
    return '@$name ला उत्तर';
  }

  @override
  String liveReplyHint(String name) {
    return '@$name ला उत्तर द्या…';
  }

  @override
  String get liveSayHiHint => 'तुमच्या प्रेक्षकांना नमस्कार म्हणा…';

  @override
  String get liveWrapTitle => 'हे राहिले संपन्न!';

  @override
  String get liveWrapSubtitle => 'तुमचे सत्र कसे झाले ते पहा.';

  @override
  String get liveDuration => 'कालावधी';

  @override
  String get livePeakViewers => 'कमाल प्रेक्षक';

  @override
  String get liveBadge => 'लाइव्ह';

  @override
  String get liveEndButton => 'लाइव्ह संपवा';

  @override
  String get liveMuteMic => 'मायक्रोफोन म्यूट करा';

  @override
  String get liveUnmuteMic => 'मायक्रोफोन अनम्यूट करा';

  @override
  String get liveGift => 'भेटवस्तू';

  @override
  String get liveAnsweringNow => 'आता उत्तर देत आहेत — ';

  @override
  String get commonErrorGeneric =>
      'काहीतरी चूक झाली. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get profileDeleteAccount => 'खाते हटवा';

  @override
  String get deleteAccountTitle => 'खाते हटवायचे?';

  @override
  String get deleteAccountWarning =>
      'यामुळे तुमचे ज्योतिषी खाते कायमचे हटवले जाईल. तुमची प्रोफाइल आणि KYC काढून टाकले जाईल, तुम्ही ऑफलाइन व्हाल आणि शोधातून लपाल, सर्व सत्रे संपतील आणि हे पूर्ववत करता येणार नाही. आधी कोणतीही शिल्लक रक्कम काढा आणि सुरू असलेले सल्ला पूर्ण करा.';

  @override
  String get deleteAccountTypeHint => 'पुष्टीसाठी DELETE टाइप करा';

  @override
  String get deleteAccountConfirm => 'खाते हटवा';

  @override
  String get deleteAccountSuccess => 'तुमचे खाते हटवण्यात आले आहे.';

  @override
  String get earningsAddPanTitle => 'पैसे काढण्यासाठी तुमचे PAN जोडा';

  @override
  String get earningsAddPanBody =>
      'प्रत्येक पेआउटवर तुमच्या PAN विरुद्ध TDS कापला जातो. पैसे काढण्यापूर्वी तुमच्या बँक आणि PAN तपशीलात वैध PAN जोडा.';

  @override
  String get earningsAddPanAction => 'PAN जोडा';

  @override
  String earningsTdsNote(String rate) {
    return 'प्रत्येक पेआउटवर तुमच्या PAN विरुद्ध $rate% TDS कापला जातो.';
  }

  @override
  String get earningsRecentPayouts => 'अलीकडील पैसे काढणे';

  @override
  String get earningsPayoutTds => 'TDS';

  @override
  String get earningsPayoutNet => 'निव्वळ भरणा';

  @override
  String get earningsPayoutGross => 'एकूण';

  @override
  String get earningsNoPayouts => 'अद्याप कोणतेही पैसे काढलेले नाहीत.';

  @override
  String get notificationsTitle => 'सूचना';

  @override
  String get notificationsEmpty => 'तुमच्याकडे अद्याप कोणतीही सूचना नाही.';

  @override
  String get notificationsMarkAllRead => 'सर्व वाचले म्हणून चिन्हांकित करा';

  @override
  String get supportTitle => 'मदत आणि सहाय्य';

  @override
  String get supportFaqTab => 'सामान्य प्रश्न';

  @override
  String get supportTicketsTab => 'माझी तिकिटे';

  @override
  String get supportFaqEmpty => 'सध्या कोणतेही मदत लेख उपलब्ध नाहीत.';

  @override
  String get supportTicketsEmpty => 'तुमच्याकडे अद्याप कोणतेही सहाय्य तिकीट नाही.';

  @override
  String get supportRaiseTicket => 'तिकीट तयार करा';

  @override
  String get supportSubject => 'विषय';

  @override
  String get supportMessage => 'तुमची समस्या सांगा';

  @override
  String get supportSubmit => 'सबमिट करा';

  @override
  String get supportFillFields => 'कृपया विषय आणि संदेश भरा.';

  @override
  String get supportTicket => 'तिकीट';

  @override
  String get supportReplyHint => 'उत्तर टाइप करा…';

  @override
  String get supportReopenHint => 'हे तिकीट पुन्हा उघडण्यासाठी उत्तर द्या…';

  @override
  String get supportSenderYou => 'तुम्ही';

  @override
  String get supportSenderSupport => 'सहाय्य';

  @override
  String get supportStatusOpen => 'उघडे';

  @override
  String get supportStatusPending => 'तुमच्या प्रतिसादाची प्रतीक्षा';

  @override
  String get supportStatusClosed => 'बंद';
}
