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
  String get languageSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get profileTheme => 'थीम';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeSystem => 'सिस्टम डिफ़ॉल्ट';
}
