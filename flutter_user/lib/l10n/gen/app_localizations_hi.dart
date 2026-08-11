// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get awChooseLanguage => 'अपनी भाषा चुनें';

  @override
  String get awGoogleFailed =>
      'Google साइन-इन विफल रहा। कृपया पुनः प्रयास करें।';

  @override
  String get awCompleteProfileTitle => 'अपनी प्रोफ़ाइल पूरी करें';

  @override
  String awWelcomeName(String name) {
    return 'स्वागत है, $name!';
  }

  @override
  String get awCompleteProfileSubtitle =>
      'Nakshatralogy को आपके लिए अनुकूलित करने हेतु कुछ जानकारी।';

  @override
  String get awRegionLabel => 'क्षेत्र';

  @override
  String get awRegionIndia => 'भारत';

  @override
  String get awRegionInternational => 'अंतरराष्ट्रीय';

  @override
  String get awPreferredLanguage => 'पसंदीदा भाषा';

  @override
  String get awFinishSetup => 'सेटअप पूरा करें';

  @override
  String get awChatFileWebUnsupported =>
      'फ़ाइल साझा करना वेब पर अभी उपलब्ध नहीं है। कृपया मोबाइल ऐप का उपयोग करें।';

  @override
  String get awVideoUnsupported =>
      'इस ब्राउज़र में वीडियो कॉल समर्थित नहीं हैं। कृपया हमारे मोबाइल ऐप या समर्थित डेस्कटॉप ब्राउज़र का उपयोग करें।';

  @override
  String get awClose => 'बंद करें';

  @override
  String get pwPremiumTitle => 'प्रीमियम रिपोर्ट';

  @override
  String get pwLockedSubtitle => 'इस कुंडली के लिए पूरा विश्लेषण अनलॉक करें';

  @override
  String pwUnlockFull(Object name) {
    return 'पूरा $name अनलॉक करें';
  }

  @override
  String pwUnlockPrice(Object price) {
    return 'अनलॉक · $price';
  }

  @override
  String get pwOneTime => 'एक बार अनलॉक — इस कुंडली पर हमेशा के लिए आपका';

  @override
  String get pwWhatYouGet => 'आपको क्या मिलेगा';

  @override
  String get pwYourBalance => 'आपका वॉलेट बैलेंस';

  @override
  String get pwInsufficient => 'अपर्याप्त बैलेंस';

  @override
  String get pwRechargeToUnlock => 'अनलॉक करने के लिए रिचार्ज करें';

  @override
  String get pwRechargeAmount => 'रिचार्ज राशि (₹)';

  @override
  String get pwAddMoney => 'पैसे जोड़ें';

  @override
  String get pwRechargeDone => 'वॉलेट रिचार्ज हो गया';

  @override
  String get pwRechargeFailed => 'रिचार्ज विफल। कृपया पुनः प्रयास करें।';

  @override
  String get pwUnlockFailed => 'अनलॉक नहीं हो सका। कृपया पुनः प्रयास करें।';

  @override
  String get pwUnlockedNow => 'अनलॉक हो गया! आपकी रिपोर्ट लोड हो रही है…';

  @override
  String get pwProcessing => 'प्रोसेस हो रहा है…';

  @override
  String get pwPrimaryNoDelete =>
      'आपकी प्राथमिक कुंडली हटाई नहीं जा सकती — यह हमेशा मुफ़्त है।';

  @override
  String get pwPrimaryNoEdit => 'आपकी प्राथमिक कुंडली संपादित नहीं की जा सकती।';

  @override
  String get pwLoadingAccess => 'एक्सेस जाँचा जा रहा है…';

  @override
  String get pwMaybeLater => 'बाद में';

  @override
  String get updatePhoto => 'फ़ोटो अपडेट करें';

  @override
  String get takePhoto => 'कैमरा';

  @override
  String get chooseFromGallery => 'गैलरी';

  @override
  String get removePhoto => 'फ़ोटो हटाएँ';

  @override
  String get photoUpdated => 'फ़ोटो अपडेट हो गई';

  @override
  String get photoUploadFailed =>
      'फ़ोटो अपलोड नहीं हो सकी। कृपया पुनः प्रयास करें।';

  @override
  String get tapToChangePhoto => 'फ़ोटो बदलने के लिए टैप करें';

  @override
  String get klSubtitle => 'AI-संचालित वैदिक पूर्वजन्म कर्म-बंधन रिपोर्ट';

  @override
  String get klTitle => 'पूर्वजन्म कर्म-बंधन';

  @override
  String get klSnapshotHeader => 'कर्म-बंधन स्नैपशॉट';

  @override
  String get klGaugePairwise => 'औसत युगल-बंधन';

  @override
  String get klGaugeCohesion => 'समूह एकजुटता';

  @override
  String get klGaugeRahuKetu => 'राहु-केतु अनुनाद';

  @override
  String get klGaugeAtmakaraka => 'आत्मा अनुनाद';

  @override
  String get klGaugeD60 => 'D60 अनुनाद';

  @override
  String get klChipSoulResonance => 'प्रबल आत्म-हस्ताक्षर अनुनाद';

  @override
  String get klChipD60Resonance => 'प्रबल D60 पूर्वजन्म अनुनाद';

  @override
  String get klChipCohesiveGroup => 'एकजुट समूह';

  @override
  String get klChipNoDebts => 'कोई कर्म-ऋण नहीं मिला';

  @override
  String get klProfilesTitle => 'कुंडली प्रोफ़ाइल';

  @override
  String get klKetuAt => 'केतु स्थित है';

  @override
  String get klRahuAt => 'राहु स्थित है';

  @override
  String get klFoundationTitle => 'प्रति-कुंडली कर्म-आधार';

  @override
  String get klFoundationSubtitle =>
      'प्रत्येक आत्मा की पूर्वजन्म निपुणता और वर्तमान जीवन दिशा';

  @override
  String get klKetuMastery => 'केतु निपुणता';

  @override
  String get klRahuGrowth => 'राहु विकास';

  @override
  String get klNinthHousePunya => 'नवम भाव पुण्य';

  @override
  String get klD60Depth => 'D60 कर्म गहराई';

  @override
  String get klAtmakarakaAgenda => 'आत्मा का उद्देश्य';

  @override
  String get klSaturnKarma => 'शनि कर्म';

  @override
  String get klPairwiseTitle => 'युगल कर्म-बंधन';

  @override
  String get klActiveFactors => 'सक्रिय बंधन कारक';

  @override
  String get klGroupPatternTitle => 'समूह कर्म पैटर्न';

  @override
  String get klSharedSetting => 'साझा पूर्वजन्म परिवेश';

  @override
  String get klCohesionScore => 'कर्म एकजुटता';

  @override
  String get klPastGoalsTitle => 'पूर्वजन्म के लक्ष्य';

  @override
  String get klLearningTitle => 'वर्तमान जीवन की सीख';

  @override
  String get klTeachingMap => 'पारस्परिक शिक्षण मानचित्र';

  @override
  String get klDebtsTitle => 'कर्म-ऋण और समाधान';

  @override
  String get klNoDebtsDetected => 'इस समूह में कोई कर्म-ऋण नहीं मिला';

  @override
  String get klTimingTitle => 'मूल दशा कर्म समय';

  @override
  String get klAuditTitle => 'गहन ऑडिट तालिका';

  @override
  String klAuditSubtitle(Object count) {
    return '$count कर्म पैरामीटर जांचे गए';
  }

  @override
  String get klTopicLinkage => 'हमारा समग्र कर्म-बंधन';

  @override
  String get klTopicPairwise => 'किसी विशेष जोड़े का कर्म-बंधन';

  @override
  String get klTopicDebts => 'सुलझाने योग्य कर्म-ऋण';

  @override
  String get klTopicLessons => 'हम यहाँ क्या सीखने आए हैं';

  @override
  String get klTopicTiming => 'हमारे समूह के लिए सर्वोत्तम समय';

  @override
  String get klTopicGroup => 'हमारी साझा पूर्वजन्म कहानी';

  @override
  String get lcSubtitle => 'AI-आधारित वैदिक प्रेम अनुकूलता रिपोर्ट';

  @override
  String get lcTitle => 'प्रेम अनुकूलता';

  @override
  String get lcSnapshotHeader => 'प्रेम अनुकूलता स्नैपशॉट';

  @override
  String get lcGaugeAttraction => 'आकर्षण';

  @override
  String get lcGaugeEmotional => 'भावनात्मक सामंजस्य';

  @override
  String get lcGaugeMental => 'मानसिक तालमेल';

  @override
  String get lcGaugePassion => 'जुनून';

  @override
  String get lcGaugeLongterm => 'दीर्घकालिक सामंजस्य';

  @override
  String get lcChipStrongMental => 'मजबूत मानसिक जुड़ाव';

  @override
  String get lcChipStrongLongterm => 'मजबूत दीर्घकालिक संभावना';

  @override
  String get lcChipStrongPassion => 'मजबूत शारीरिक आकर्षण';

  @override
  String get lcChipLowFriction => 'कुल मिलाकर कम टकराव';

  @override
  String get lcChipKarmicPull => 'मजबूत कर्मिक खिंचाव';

  @override
  String get lcPartnersTitle => 'साथी स्नैपशॉट';

  @override
  String get lcVenusSuffix => 'शुक्र राशि';

  @override
  String get lcAttractionTitle => 'आकर्षण और केमिस्ट्री';

  @override
  String get lcAttractionScore => 'आकर्षण स्कोर';

  @override
  String get lcActiveContacts => 'सक्रिय शुक्र संपर्क';

  @override
  String get lcEmotionalTitle => 'भावनात्मक सामंजस्य';

  @override
  String get lcEmotionalScore => 'भावनात्मक सामंजस्य स्कोर';

  @override
  String get lcNakshatraCompat => 'नक्षत्र अनुकूलता';

  @override
  String get lcYoniKoota => 'योनि कूट';

  @override
  String get lcGanaKoota => 'गण कूट';

  @override
  String get lcTaraKoota => 'तारा कूट';

  @override
  String get lcBhakootAxis => 'भकूट अक्ष';

  @override
  String get lcMentalTitle => 'मानसिक तालमेल';

  @override
  String get lcMentalScore => 'मानसिक तालमेल स्कोर';

  @override
  String get lcPassionTitle => 'जुनून और शारीरिक आकर्षण';

  @override
  String get lcPassionScore => 'जुनून स्कोर';

  @override
  String get lcLongtermTitle => 'दीर्घकालिक सामंजस्य';

  @override
  String get lcLongtermScore => 'दीर्घकालिक सामंजस्य स्कोर';

  @override
  String get lcCommitmentPotential => 'प्रतिबद्धता क्षमता';

  @override
  String get lc7thHouseSynastry => '7वां भाव सिनेस्ट्री';

  @override
  String get lcJupiterBlessing => 'गुरु का आशीर्वाद';

  @override
  String get lcD9Resonance => 'D9 नवमांश अनुनाद';

  @override
  String get lcSaturnLongevity => 'शनि दीर्घायु';

  @override
  String get lcKarmicTitle => 'कर्मिक प्रेम बंधन';

  @override
  String get lcKarmicScore => 'कर्मिक बंधन स्कोर';

  @override
  String get lcKetuContacts => 'केतु संपर्क';

  @override
  String get lcRahuContacts => 'राहु संपर्क';

  @override
  String get lcChallengesTitle => 'चुनौतियाँ और टकराव';

  @override
  String get lcNoChallenges =>
      'दोनों कुंडलियों में कोई महत्वपूर्ण टकराव बिंदु नहीं मिला';

  @override
  String get lcTotalPenalty => 'कुल चुनौती दंड';

  @override
  String get lcTimingTitle => 'प्रेम का समय — मूल दशा';

  @override
  String get lcDynamicsTitle => 'रिश्ते की गतिशीलता';

  @override
  String get lcPowerBalance => 'शक्ति संतुलन';

  @override
  String get lcGiverReceiver => 'भावनात्मक देने वाला/पाने वाला';

  @override
  String get lcGrowthDynamic => 'विकास की गतिशीलता';

  @override
  String get lcAreasToNurture => 'पोषण के क्षेत्र';

  @override
  String get lcTopicTiming => 'हमारे रिश्ते के लिए सबसे अच्छा समय';

  @override
  String get lcTopicChallenges => 'सामना करने योग्य चुनौतियाँ';

  @override
  String get lcTopicKarmic => 'हमारा कर्मिक संबंध';

  @override
  String get lcTopicRemedies => 'अनुशंसित उपाय';

  @override
  String get lcTopicLongterm => 'हमारी दीर्घकालिक संभावना';

  @override
  String get lcTopicDynamics => 'हमारे रिश्ते की गतिशीलता';

  @override
  String get cpSubtitle => 'AI-संचालित वैदिक संतान संभावना रिपोर्ट';

  @override
  String get cpTitle => 'संतान संभावना';

  @override
  String get cpSnapshotHeader => 'संतान संभावना स्नैपशॉट';

  @override
  String get cpGauge5thHouse => 'पंचम भाव';

  @override
  String get cpGaugeJupiter => 'गुरु/पुत्रकारक';

  @override
  String get cpGaugeD7 => 'D7 सप्तांश';

  @override
  String get cpGaugeSphuta => 'बीज-क्षेत्र';

  @override
  String get cpGaugeTiming => 'दशा समय';

  @override
  String get cpChipStrongPutrakaraka => 'प्रबल पुत्रकारक (गुरु)';

  @override
  String get cpChipLowDoshaPenalty => 'कम दोष प्रभाव';

  @override
  String get cpChipFavorableTiming => 'अनुकूल दशा समय';

  @override
  String get cpChipNoDoshas => 'कोई संतान-दोष नहीं पाया गया';

  @override
  String get cpPartnersTitle => 'साथी स्नैपशॉट';

  @override
  String get cpLagnaSuffix => 'लग्न';

  @override
  String get cpMoonSuffix => 'चंद्र राशि';

  @override
  String get cpNumberTitle => 'संतान संख्या और लिंग प्रवृत्ति';

  @override
  String get cpProbableNumber => 'संभावित संख्या';

  @override
  String get cpFirstChildTendency => 'प्रथम संतान की प्रवृत्ति';

  @override
  String get cpSpacing => 'अंतराल नोट';

  @override
  String get cpTimingTitle => 'समय — मूल दशा';

  @override
  String get cpCombinedTiming => 'संयुक्त समय';

  @override
  String get cpNextWindow => 'अगली अनुकूल अवधि';

  @override
  String get cp5thHouseTitle => 'पंचम भाव विश्लेषण';

  @override
  String get cp5thHouseSubtitle =>
      'संतान का भाव (पुत्र भाव), प्रत्येक व्यक्ति के लिए';

  @override
  String get cpJupiterTitle => 'गुरु — पुत्रकारक विश्लेषण';

  @override
  String get cpJupiterSubtitle =>
      'संतान का स्वाभाविक कारक, प्रत्येक व्यक्ति के लिए';

  @override
  String get cpD7Title => 'D7 सप्तांश विश्लेषण';

  @override
  String get cpD7Subtitle => 'संतान के लिए विशेष रूप से वर्ग कुंडली';

  @override
  String get cpD7Strength => 'D7 शक्ति';

  @override
  String get cpSphutaTitle => 'बीज और क्षेत्र स्फुट';

  @override
  String get cpBeejaSphuta => 'बीज स्फुट (बीज)';

  @override
  String get cpKshetraSphuta => 'क्षेत्र स्फुट (क्षेत्र)';

  @override
  String get cpDoshaTitle => 'दोष विश्लेषण';

  @override
  String get cpNoDoshasDetected =>
      'किसी भी कुंडली में संतान-संबंधी कोई दोष नहीं पाया गया';

  @override
  String get cpRemediesTitle => 'अनुशंसित उपाय';

  @override
  String get cpAddresses => 'समाधान';

  @override
  String get cpTopicTiming => 'गर्भधारण के लिए सर्वोत्तम समय';

  @override
  String get cpTopicNumber => 'हमारे कितने बच्चे हो सकते हैं';

  @override
  String get cpTopicDosha => 'समाधान हेतु कोई दोष';

  @override
  String get cpTopicRemedies => 'अनुशंसित उपाय';

  @override
  String get cpTopicFifthHouse => 'हमारे पंचम भाव की शक्ति';

  @override
  String get cpTopicJupiter => 'इसमें गुरु की भूमिका';

  @override
  String get riSubtitle => 'AI-संचालित वैदिक रिलेशनशिप इंटेलिजेंस रिपोर्ट';

  @override
  String get riTitle => 'रिलेशनशिप इंटेल';

  @override
  String get riSnapshotHeader => 'समूह स्नैपशॉट';

  @override
  String get riGaugeCohesion => 'समूह सामंजस्य';

  @override
  String get riGaugeTrust => 'विश्वास का माहौल';

  @override
  String get riGaugeProductivity => 'उत्पादकता';

  @override
  String get riGaugeCreativity => 'रचनात्मकता';

  @override
  String get riChipNoAlerts => 'कोई गंभीर चेतावनी नहीं';

  @override
  String get riChipStrongCohesion => 'मजबूत समूह सामंजस्य';

  @override
  String get riChipHighTrust => 'उच्च विश्वास का माहौल';

  @override
  String get riChipNoHiddenEnemy => 'कोई छिपे-दुश्मन का संकेत नहीं';

  @override
  String get riChipHealthyGroup => 'कुल मिलाकर स्वस्थ समूह';

  @override
  String get riProfilesTitle => 'कुंडली प्रोफाइल';

  @override
  String riProfilesSubtitle(Object count) {
    return 'इस समूह में $count लोग';
  }

  @override
  String get riLagnaSuffix => 'लग्न';

  @override
  String get riIntegrity => 'ईमानदारी';

  @override
  String get riWarmth => 'आत्मीयता';

  @override
  String get riTrustworthiness => 'विश्वसनीयता';

  @override
  String get riAssertiveness => 'दृढ़ता';

  @override
  String get riGroupDynamicsTitle => 'समूह गतिशीलता अवलोकन';

  @override
  String get riMostSupportive => 'सबसे सहयोगी';

  @override
  String get riMostChallenged => 'सबसे चुनौतीपूर्ण';

  @override
  String get riHiddenEnemyAlert => 'छिपे-दुश्मन का संकेत मिला';

  @override
  String get riBestWorstTitle => 'सर्वश्रेष्ठ और सबसे चुनौतीपूर्ण जोड़े';

  @override
  String get riBestPair => 'सबसे मजबूत बंधन';

  @override
  String get riWorstPair => 'ध्यान देने की आवश्यकता';

  @override
  String get riAlliances => 'संभावित गठजोड़';

  @override
  String get riConflicts => 'संभावित टकराव के बिंदु';

  @override
  String get riPairwiseTitle => 'जोड़ी-वार विश्लेषण';

  @override
  String riPairwiseSubtitle(Object count) {
    return '$count जोड़ों का विश्लेषण किया गया';
  }

  @override
  String get riDynamic => 'गतिशीलता';

  @override
  String get riKarmicLink => 'कर्म संबंध';

  @override
  String get riMutualTrust => 'पारस्परिक विश्वास';

  @override
  String get riBetrayalRisk => 'धोखे का जोखिम';

  @override
  String get riPowerDistribution => 'शक्ति वितरण';

  @override
  String get riPowerHealth => 'शक्ति-संतुलन स्वास्थ्य';

  @override
  String get riCriticalPatternsTitle => 'गंभीर पैटर्न';

  @override
  String get riGroupRecsTitle => 'समूह सिफारिशें';

  @override
  String get riSharedPractices => 'साझा अभ्यास';

  @override
  String get riCommStyle => 'अनुशंसित संचार शैली';

  @override
  String get riGrowthFocus => 'अनुशंसित विकास केंद्र';

  @override
  String get riIndividualTitle => 'व्यक्तिगत मार्गदर्शन';

  @override
  String get riBestAllies => 'सर्वश्रेष्ठ सहयोगी';

  @override
  String get riHandleWithCare => 'सावधानी से व्यवहार करें';

  @override
  String get riCoreThemeTitle => 'मुख्य समूह विषय';

  @override
  String get riLayerPairwise => 'जोड़ी-वार पूर्णता';

  @override
  String get riLayerD1 => 'जन्म कुंडली (D1)';

  @override
  String get riLayerD9 => 'नवमांश (D9)';

  @override
  String get riLayerD10 => 'दशमांश (D10)';

  @override
  String get riLayerD30 => 'त्रिंशांश (D30)';

  @override
  String get riLayerJaimini => 'जैमिनी संकेत';

  @override
  String get riLayerBehavior => 'व्यवहार स्पष्टता';

  @override
  String get riLayerCoherence => 'समूह सामंजस्यता';

  @override
  String get riTopicDynamics => 'हमारी समूह गतिशीलता';

  @override
  String get riTopicPairwise => 'किसी विशेष जोड़े की अनुकूलता';

  @override
  String get riTopicAlerts => 'कोई गंभीर चेतावनी';

  @override
  String get riTopicGrowth => 'हम एक साथ कैसे विकसित हो सकते हैं';

  @override
  String get riTopicRecs => 'अनुशंसित अभ्यास';

  @override
  String get riTopicTheme => 'हमारा मुख्य समूह विषय';

  @override
  String get kmSubtitle => 'AI-संचालित वैदिक कुंडली मिलान रिपोर्ट';

  @override
  String get kmTitle => 'कुंडली मिलान';

  @override
  String get kmSnapshotHeader => 'अनुकूलता स्नैपशॉट';

  @override
  String kmAshtakootScore(Object score) {
    return 'अष्टकूट: $score/36';
  }

  @override
  String get kmGaugeAshtakoot => 'अष्टकूट %';

  @override
  String get kmGaugeD9 => 'डी9 विवाह कर्म';

  @override
  String get kmGaugeMangal => 'मंगल संतुलन';

  @override
  String get kmGaugePapa => 'कर्मिक संतुलन';

  @override
  String get kmGaugeAk => 'आत्मा अनुनाद';

  @override
  String get kmChipNoNadi => 'नाड़ी दोष नहीं';

  @override
  String get kmChipNoBhakoot => 'भकूट दोष नहीं';

  @override
  String get kmChipMangalCancelled => 'मंगल दोष निरस्त';

  @override
  String get kmChipPapaBalanced => 'संतुलित कर्मिक भार';

  @override
  String get kmChipStrongChemistry => 'मजबूत शारीरिक केमिस्ट्री';

  @override
  String get kmChipStrongD9 => 'मजबूत डी9 विवाह कर्म';

  @override
  String get kmChipLongevity => 'मजबूत दीर्घायु संरेखण';

  @override
  String get kmAshtakootTitle => 'अष्टकूट गुण मिलान';

  @override
  String get kmAshtakootSubtitle => '36 में से क्लासिकल 8-बिंदु मिलान प्रणाली';

  @override
  String get kmNadiSeverity => 'नाड़ी गंभीरता';

  @override
  String get kmBhakootSeverity => 'भकूट गंभीरता';

  @override
  String get kmGanaSignature => 'गण हस्ताक्षर';

  @override
  String get kmMangalTitle => 'मंगल दोष जांच';

  @override
  String get kmD9Title => 'डी9 नवमांश — विवाह कर्म';

  @override
  String get kmD9Subtitle =>
      'आत्मा-स्तरीय विवाह कुंडली, शास्त्रीय रूप से सबसे महत्वपूर्ण मानी जाती है';

  @override
  String get kmD9Score => 'डी9 अनुकूलता';

  @override
  String get kmLagnaRelation => 'लग्न संबंध';

  @override
  String get km7thLordRelation => 'सप्तम भाव स्वामी संबंध';

  @override
  String get kmKarakasTitle => 'आत्मा और जीवनसाथी कारक';

  @override
  String get kmAtmakaraka => 'आत्मा ग्रह';

  @override
  String get kmAkCompatibility => 'आत्मा-हस्ताक्षर अनुनाद';

  @override
  String get kmUlCompatibility => 'जीवनसाथी-कारक संरेखण';

  @override
  String get kmUlSigns => 'उपपद स्वामी';

  @override
  String get kmChemistryTitle => 'शुक्र-मंगल केमिस्ट्री';

  @override
  String get kmPhysicalChemistry => 'शारीरिक केमिस्ट्री';

  @override
  String get kmEmotionalWarmth => 'भावनात्मक गर्मजोशी';

  @override
  String get kmAestheticAlignment => 'सौंदर्य संरेखण';

  @override
  String get kmElementalSynthesis => 'तात्विक संश्लेषण';

  @override
  String get kmHouseCrossTitle => 'सप्तम और अष्टम भाव क्रॉस-विश्लेषण';

  @override
  String get km78Compatibility => 'सप्तम-अष्टम भाव अनुकूलता';

  @override
  String get km8thHouseSignature => 'संयुक्त दीर्घायु हस्ताक्षर';

  @override
  String get kmLongevityAlignment => 'दीर्घायु संरेखण';

  @override
  String get km7thLordFriendship => 'सप्तमेश मैत्री';

  @override
  String get kmDomainsTitle => 'क्षेत्र-दर-क्षेत्र अनुकूलता';

  @override
  String get kmConflictEngagement => 'टकराव शैली';

  @override
  String get kmDashaTitle => 'दशा और गोचर सिंक';

  @override
  String get kmDashaSync => 'दशा सिंक';

  @override
  String get kmTransitAlignment => 'गोचर संरेखण';

  @override
  String get kmTimingTitle => 'विवाह का समय';

  @override
  String get kmMarriageWindow => 'विवाह विंडो';

  @override
  String get kmEngagementWindow => 'सगाई विंडो';

  @override
  String get kmRecommendedRange => 'अनुशंसित समयसीमा';

  @override
  String get kmMuhurtaNotes => 'मुहूर्त नोट्स';

  @override
  String get kmRisksTitle => 'ध्यान देने योग्य जोखिम';

  @override
  String get kmConflictRisk => 'टकराव जोखिम';

  @override
  String get kmCommunicationRisk => 'संवाद जोखिम';

  @override
  String get kmFinanceRisk => 'वित्तीय टकराव जोखिम';

  @override
  String get kmFamilyDynamicsRisk => 'पारिवारिक गतिशीलता जोखिम';

  @override
  String get kmMentalHealthRisk => 'मानसिक-स्वास्थ्य संरेखण जोखिम';

  @override
  String get kmStrengthsTitle => 'शीर्ष अनुकूलता ताकतें';

  @override
  String get kmSharedGrowth => 'साझा विकास क्षमता';

  @override
  String get kmSharedCreative => 'साझा रचनात्मक क्षमता';

  @override
  String get kmJourneyTitle => 'रिश्ते की यात्रा और विकास';

  @override
  String get kmCurrentPhase => 'वर्तमान चरण';

  @override
  String get kmEarlyArc => 'प्रारंभिक विवाह';

  @override
  String get kmMiddleArc => 'मध्य विवाह';

  @override
  String get kmMatureArc => 'परिपक्व विवाह';

  @override
  String get kmElderArc => 'वरिष्ठ वर्ष';

  @override
  String get kmPeakPhase => 'उच्चतम साथ चरण';

  @override
  String get kmGrowthAreas => 'विकास क्षेत्र';

  @override
  String get kmCommProtocols => 'संवाद प्रोटोकॉल';

  @override
  String get kmSharedPractices => 'साझा अभ्यास';

  @override
  String get kmImprovementTitle => 'मुख्य विषय और सुधार योजना';

  @override
  String get kmVerdictTitle => 'अंतिम निर्णय';

  @override
  String get kmRealizationPotential => 'रिश्ते की साकारता क्षमता';

  @override
  String get kmLayerAshtakoot => 'अष्टकूट';

  @override
  String get kmLayerD9 => 'डी9 नवमांश';

  @override
  String get kmLayerMangalPapa => 'मंगल और पापसाम्य';

  @override
  String get kmLayerVenusMars => 'शुक्र-मंगल';

  @override
  String get kmLayerDashaSync => 'दशा सिंक';

  @override
  String get kmLayerH7H8 => 'सप्तम-अष्टम भाव क्रॉस';

  @override
  String get kmLayerAkResonance => 'आत्मकारक अनुनाद';

  @override
  String get kmLayerDomains => 'क्षेत्र आयाम';

  @override
  String get kmTopicAshtakoot => 'हमारा अष्टकूट स्कोर';

  @override
  String get kmTopicMangal => 'मंगल दोष चिंताएं';

  @override
  String get kmTopicD9 => 'हमारा विवाह कर्म (डी9)';

  @override
  String get kmTopicTiming => 'सर्वोत्तम विवाह समय';

  @override
  String get kmTopicRisks => 'तैयार होने वाले जोखिम';

  @override
  String get kmTopicGrowth => 'हम साथ कैसे बढ़ सकते हैं';

  @override
  String get kmTopicRemedies => 'अनुशंसित उपाय';

  @override
  String get kmTopicVerdict => 'क्या हमें विवाह के लिए आगे बढ़ना चाहिए';

  @override
  String get pkSubtitle => 'AI-संचालित वैदिक पूर्वजन्म और कर्म रिपोर्ट';

  @override
  String get pkTitle => 'पूर्वजन्म और कर्म';

  @override
  String get pkSnapshotHeader => 'पूर्वजन्म झलक';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return 'आपकी कुंडली में \'$theme\' पूर्वजन्म हस्ताक्षर दिखता है, जो वर्तमान में इस जीवन में $relation हो रहा है। अनुशंसित मार्ग: $strategy।';
  }

  @override
  String get pkGaugeSignature => 'हस्ताक्षर शक्ति';

  @override
  String get pkGaugeMasteryPreserved => 'संरक्षित निपुणता';

  @override
  String get pkGaugeClearingProgress => 'कर्म शुद्धि';

  @override
  String get pkGaugeMaturity => 'पूर्वजन्म परिपक्वता';

  @override
  String get pkGaugeMemoryAccess => 'स्मृति पहुंच';

  @override
  String get pkChipGoodProgress => 'कर्म-शुद्धि में अच्छी प्रगति';

  @override
  String get pkChipLowDebt => 'कम कर्म-ऋण';

  @override
  String get pkChipMatureSoul => 'परिपक्व आत्मा हस्ताक्षर';

  @override
  String get pkChipGiftedPast => 'कुंडली में पूर्वजन्म का उपहार';

  @override
  String get pkChipAccomplished => 'सफल पूर्वजन्म';

  @override
  String get pkChipMasteryPreserved => 'आगे ले जाई गई मजबूत निपुणता';

  @override
  String get pkKetuTitle => 'केतु — आपकी पूर्वजन्म निपुणता';

  @override
  String get pkKetuSubtitle => 'वे कौशल जिन्हें आपकी आत्मा पहले ही सीख चुकी है';

  @override
  String get pkMasteryStrength => 'निपुणता शक्ति';

  @override
  String get pkSkillsCarried => 'आगे ले जाए गए कौशल';

  @override
  String get pkInstincts => 'सहज क्षमताएं';

  @override
  String get pkKetuDignity => 'केतु की स्थिति';

  @override
  String get pkRahuTitle => 'राहु — आपकी आत्मा की विकास दिशा';

  @override
  String get pkRahuSubtitle => 'आपकी आत्मा यहां क्या पूरा करने आई है';

  @override
  String get pkUnmetDesires => 'अधूरी इच्छाएं';

  @override
  String get pkProfileTitle => 'आपकी पूर्वजन्म प्रोफ़ाइल';

  @override
  String get pkProfession => 'संभावित पेशा';

  @override
  String get pkSocialStanding => 'सामाजिक स्थिति';

  @override
  String get pkRegion => 'संभावित क्षेत्र';

  @override
  String get pkCulturalArchetype => 'सांस्कृतिक स्वरूप';

  @override
  String get pkAccomplishment => 'उपलब्धि स्तर';

  @override
  String get pkAuthority => 'अधिकार स्तर';

  @override
  String get pkFamilyRole => 'पारिवारिक भूमिका';

  @override
  String get pkSecondaryProfession => 'द्वितीयक पेशा';

  @override
  String get pkClimateAffinity => 'जलवायु अनुकूलता';

  @override
  String get pkForeignResidence => 'विदेश-निवास कर्म';

  @override
  String get pkRelationshipsTitle => 'आगे ले जाए गए पूर्व संबंध';

  @override
  String get pkSpouseConnection => 'जीवनसाथी पुनर्मिलन';

  @override
  String get pkChildrenConnection => 'संतान पुनर्मिलन';

  @override
  String get pkCarriedRelationTypes => 'संबंध पैटर्न';

  @override
  String get pkPartnerArchetype => 'पूर्वजन्म साथी स्वरूप';

  @override
  String get pkDarakaraka => 'जीवनसाथी कारक';

  @override
  String get pkParentsKarma => 'माता-पिता कर्म पैटर्न';

  @override
  String get pkSiblingKarma => 'भाई-बहन कर्म पैटर्न';

  @override
  String get pkSpiritualTitle => 'तब आपका आध्यात्मिक जीवन';

  @override
  String get pkSpiritualLevel => 'आध्यात्मिक स्तर';

  @override
  String get pkPracticeSignature => 'साधना शैली';

  @override
  String get pkMeditativeCapacity => 'ध्यान क्षमता';

  @override
  String get pkDevotionalPractice => 'भक्ति साधना';

  @override
  String get pkYogicAttainment => 'योगिक उपलब्धि';

  @override
  String get pkMokshaProximity => 'मोक्ष निकटता';

  @override
  String get pkKarmicDebtsTitle => 'कर्म-ऋण और तब की संपत्ति';

  @override
  String get pkTotalKarmicDebt => 'कुल कर्म-ऋण';

  @override
  String get pkPrimaryDebtType => 'प्राथमिक ऋण प्रकार';

  @override
  String get pkRelationshipDebt => 'संबंध ऋण';

  @override
  String get pkFinancialDebt => 'आर्थिक ऋण';

  @override
  String get pkServiceDebt => 'सेवा ऋण';

  @override
  String get pkDharmicDebt => 'धार्मिक ऋण';

  @override
  String get pkPitruKarma => 'पितृ कर्म';

  @override
  String get pkMatruKarma => 'मातृ कर्म';

  @override
  String get pkWealthLevel => 'तब का धन स्तर';

  @override
  String get pkWealthKarmaCarried => 'आगे ले जाया गया धन-कर्म';

  @override
  String get pkResourcePattern => 'संसाधन प्रबंधन';

  @override
  String get pkGainSource => 'लाभ का स्रोत';

  @override
  String get pkEchoesTitle => 'इस जीवन में प्रतिध्वनियां';

  @override
  String get pkOnRelationships => 'संबंधों पर';

  @override
  String get pkOnCareer => 'करियर पर';

  @override
  String get pkOnHealth => 'स्वास्थ्य पर';

  @override
  String get pkOnSpirituality => 'आध्यात्मिकता पर';

  @override
  String get pkDominantArea => 'सबसे प्रबल प्रभाव';

  @override
  String get pkAttractions => 'स्वाभाविक आकर्षण';

  @override
  String get pkAversions => 'स्वाभाविक विकर्षण';

  @override
  String get pkUnexplainedFears => 'अस्पष्ट भय';

  @override
  String get pkMagneticPulls => 'चुंबकीय खिंचाव';

  @override
  String get pkResolutionTitle => 'कर्म निवारण और पूर्णता';

  @override
  String get pkPrimaryPathway => 'प्राथमिक मार्ग';

  @override
  String get pkSecondaryPathway => 'द्वितीयक मार्ग';

  @override
  String get pkClearingProgress => 'शुद्धि प्रगति';

  @override
  String get pkRemainingWork => 'शेष कार्य';

  @override
  String get pkSettlementTimeline => 'निपटान समयरेखा';

  @override
  String get pkAccelerationPractices => 'निवारण को तेज करने वाली साधनाएं';

  @override
  String get pkPriorityAreas => 'प्राथमिकता क्षेत्र';

  @override
  String get pkVerificationTitle => 'कुंडलियों में सत्यापित (D60)';

  @override
  String get pkD60Label => 'D60 पूर्वजन्म युग';

  @override
  String get pkD60Ketu => 'D60 केतु स्थिति';

  @override
  String get pkD60Standing => 'समग्र स्थिति';

  @override
  String get pkMemoryTitle => 'स्मृति और अंतर्ज्ञान';

  @override
  String get pkMemoryAccess => 'स्मृति पहुंच';

  @override
  String get pkRegressionFit => 'रिग्रेशन-थेरेपी उपयुक्तता';

  @override
  String get pkDreamVisits => 'स्वप्न भ्रमण';

  @override
  String get pkDejaVuFrequency => 'देजा वू आवृत्ति';

  @override
  String get pkSpontaneousRemembrance => 'सहज स्मरण';

  @override
  String get pkRemembrancePractices => 'स्मरण साधनाएं';

  @override
  String get pkTimelineTitle => 'सक्रियण समयरेखा';

  @override
  String get pkGiftsActivation => 'पूर्वजन्म उपहारों का सक्रियण';

  @override
  String get pkSurfaceWindow => 'उभरने की अवधि';

  @override
  String get pkRisksTitle => 'जोखिम और स्थायी पैटर्न';

  @override
  String get pkTraumaResidue => 'आघात अवशेष';

  @override
  String get pkSpiritualBypass => 'आध्यात्मिक टालमटोल जोखिम';

  @override
  String get pkMajorRisks => 'प्रमुख जोखिम';

  @override
  String get pkChronicImprints => 'स्थायी छाप';

  @override
  String get pkKarmicLoops => 'कर्म चक्र';

  @override
  String get pkImprovementTitle => 'सुधार योजना';

  @override
  String get pkRoadmapTitle => 'आपकी पूर्वजन्म यात्रा-मार्ग';

  @override
  String get pkMaturity => 'पूर्वजन्म परिपक्वता';

  @override
  String get pkLayerD1 => 'जन्म कुंडली (D1)';

  @override
  String get pkLayerD9 => 'नवांश (D9)';

  @override
  String get pkLayerD60 => 'षष्ठ्यंश (D60)';

  @override
  String get pkLayerKetuDepth => 'केतु गहराई';

  @override
  String get pkLayerAtmakaraka => 'आत्मा ग्रह (आत्मकारक)';

  @override
  String get pkTopicMastery => 'मेरी पूर्वजन्म निपुणता';

  @override
  String get pkTopicUnfinished => 'मेरा अधूरा कर्म';

  @override
  String get pkTopicRelationships => 'मेरे पूर्वजन्म संबंध';

  @override
  String get pkTopicDebts => 'मेरे कर्म-ऋण';

  @override
  String get pkTopicResolution => 'अपने कर्म को कैसे सुलझाएं';

  @override
  String get pkTopicMemory => 'पूर्वजन्म स्मृति पहुंच';

  @override
  String get pkTopicTiming => 'सर्वोत्तम समय अवधि';

  @override
  String get pkTopicProfile => 'पूर्वजन्म में मैं कौन था';

  @override
  String get chSubtitle => 'AI-संचालित वैदिक चरित्र विश्लेषण रिपोर्ट';

  @override
  String get chTitle => 'चरित्र विश्लेषण';

  @override
  String get chSnapshotHeader => 'चरित्र स्नैपशॉट';

  @override
  String get chGaugeIntegrity => 'सत्यनिष्ठा';

  @override
  String get chGaugeResilience => 'लचीलापन';

  @override
  String get chGaugeSelfAwareness => 'आत्म-जागरूकता';

  @override
  String get chGaugeStability => 'भावनात्मक स्थिरता';

  @override
  String get chGaugeMoralFabric => 'नैतिक ताना-बाना';

  @override
  String get chChipRajaYoga => 'राजयोग मौजूद';

  @override
  String get chChipHighIntegrity => 'उच्च सत्यनिष्ठा';

  @override
  String get chChipResilient => 'लचीला स्वभाव';

  @override
  String get chChipDharmic => 'प्रबल धर्म-प्रवृत्ति';

  @override
  String get chChipEmpathetic => 'स्वाभाविक रूप से सहानुभूतिशील';

  @override
  String get chChipLoyal => 'गहरी वफादारी';

  @override
  String get chChipGiftedCharacter => 'कुंडली में चरित्र का उपहार';

  @override
  String get chSoulTitle => 'आपकी आत्मा की पहचान';

  @override
  String get chSoulIntegration => 'आत्मा-चरित्र एकीकरण';

  @override
  String get chAmatyakarakaTheme => 'सहायक चरित्र स्वर';

  @override
  String get chAtmakarakaDignity => 'आत्मकारक ग्रह की गरिमा';

  @override
  String get chAtmakarakaHouse => 'भाव स्थिति';

  @override
  String get chSurfaceTitle => 'बाहरी व्यक्तित्व और संरचना';

  @override
  String get chLagnaSign => 'लग्न राशि';

  @override
  String get chConstitution => 'संरचना';

  @override
  String get chSurfaceSignature => 'आप दूसरों को कैसे लगते हैं';

  @override
  String get chPhysicalConstitution => 'शारीरिक संरचना';

  @override
  String get chLagnaLord => 'लग्नेश';

  @override
  String get chLagnaOccupants => 'लग्न में ग्रह';

  @override
  String get chMindEmotionsTitle => 'मन, भावनाएँ और अहंकार';

  @override
  String get chEmotionalNature => 'आपकी भावनात्मक प्रकृति';

  @override
  String get chMentalStability => 'मानसिक स्थिरता';

  @override
  String get chSelfConfidence => 'स्वस्थ आत्मविश्वास';

  @override
  String get chEgoNature => 'आपका अहंकार और आत्म-बोध';

  @override
  String get chAuthorityRelationship => 'अधिकार के साथ संबंध';

  @override
  String get chPrideTendency => 'अभिमान की प्रवृत्ति';

  @override
  String get chMoodPatterns => 'मनोदशा के पैटर्न';

  @override
  String get chKemadrumaPresent =>
      'केमद्रुम योग मौजूद है — अतिरिक्त भावनात्मक देखभाल लाभकारी है।';

  @override
  String get chFatherImprint => 'पिता की छाप की गुणवत्ता';

  @override
  String get chCommunicationTitle => 'संचार और बुद्धि शैली';

  @override
  String get chIntellectStyle => 'बुद्धि शैली';

  @override
  String get chCommStyle => 'संचार शैली';

  @override
  String get chDecisionStyle => 'निर्णय लेने की शैली';

  @override
  String get chDiscrimination => 'विवेक क्षमता';

  @override
  String get chPersonaTitle => 'सार्वजनिक छवि बनाम वास्तविक स्वरूप';

  @override
  String get chAuthenticityGap => 'प्रामाणिकता अंतर';

  @override
  String get chGunaTitle => 'गुण और दोष प्रोफ़ाइल';

  @override
  String get chGunaSubtitle =>
      'आपकी आंतरिक प्रकृति और संरचना, शास्त्रीय वैदिक शैली में';

  @override
  String get chSattva => 'सत्व';

  @override
  String get chRajas => 'रजस';

  @override
  String get chTamas => 'तमस';

  @override
  String get chDominantGuna => 'प्रमुख गुण';

  @override
  String get chPitta => 'पित्त';

  @override
  String get chKapha => 'कफ';

  @override
  String get chVata => 'वात';

  @override
  String get chDominantDosha => 'प्रमुख दोष';

  @override
  String get chRahuRestlessness => 'राहु की बेचैनी';

  @override
  String get chKetuDetachment => 'केतु की विरक्ति';

  @override
  String get chYogasTitle => 'चरित्र योग';

  @override
  String get chRajaYogaStrength => 'राजयोग शक्ति';

  @override
  String get chGiftYogas => 'वरदान योग';

  @override
  String get chTestYogas => 'परीक्षा योग';

  @override
  String get chStrengthsTitle => 'शक्तियाँ और प्रतिभाएँ';

  @override
  String get chSignatureVirtues => 'विशिष्ट गुण';

  @override
  String get chNaturalTalents => 'स्वाभाविक प्रतिभाएँ';

  @override
  String get chSoftSkills => 'सॉफ्ट स्किल्स';

  @override
  String get chHiddenStrengths => 'विकसित करने योग्य छिपी शक्तियाँ';

  @override
  String get chShadowTitle => 'छाया और विकास के क्षेत्र';

  @override
  String get chShadowSubtitle =>
      'काम करने योग्य पैटर्न के प्रति सौम्य जागरूकता';

  @override
  String get chShadowPatterns => 'छाया पैटर्न';

  @override
  String get chBlindSpots => 'अंधे कोने';

  @override
  String get chEmotionalWounds => 'भावनात्मक घाव';

  @override
  String get chShadowWorkPriorities => 'छाया-कार्य प्राथमिकताएँ';

  @override
  String get chMoralTests => 'नैतिक परीक्षाएँ';

  @override
  String get chRelationshipsTitle => 'रिश्ते और सामाजिक शैली';

  @override
  String get chWarmth => 'पारस्परिक उष्मा';

  @override
  String get chEmpathy => 'सहानुभूति क्षमता';

  @override
  String get chLoyalty => 'वफादारी क्षमता';

  @override
  String get chBoundaries => 'सीमाएँ तय करना';

  @override
  String get chSocialConfidence => 'सामाजिक आत्मविश्वास';

  @override
  String get chTrustGiving => 'विश्वास देने का आधार स्तर';

  @override
  String get chConflictStyle => 'संघर्ष शैली';

  @override
  String get chEthicsTitle => 'नैतिकता और नैतिक दिशासूचक';

  @override
  String get chDharmaOrientation => 'धर्म-प्रवृत्ति';

  @override
  String get chTruthfulness => 'सच्चाई';

  @override
  String get chCompassion => 'करुणा';

  @override
  String get chGenerosity => 'उदारता';

  @override
  String get chEthicalConsistency => 'नैतिक निरंतरता';

  @override
  String get chIntegrityPressure => 'दबाव में सत्यनिष्ठा';

  @override
  String get chJusticeFairness => 'न्याय और निष्पक्षता';

  @override
  String get chMoralTrajectory => 'नैतिक विकास';

  @override
  String get chEiTitle => 'भावनात्मक बुद्धिमत्ता';

  @override
  String get chEiSelfAwareness => 'आत्म-जागरूकता';

  @override
  String get chEiSelfRegulation => 'आत्म-नियमन';

  @override
  String get chEiEmpathy => 'सहानुभूति';

  @override
  String get chEiSocialSkills => 'सामाजिक कौशल';

  @override
  String get chMotivation => 'आंतरिक प्रेरणा';

  @override
  String get chVulnerabilityComfort => 'भेद्यता के साथ सहजता';

  @override
  String get chEmotionalExpression => 'भावनात्मक अभिव्यक्ति में सहजता';

  @override
  String get chEmotionalReceptivity => 'भावनात्मक ग्रहणशीलता';

  @override
  String get chVerificationTitle => 'चार्ट्स में सत्यापित (D9/D12/D30/D60)';

  @override
  String get chD9Label => 'D9 धर्म-चरित्र';

  @override
  String get chD12Label => 'D12 पैतृक विरासत';

  @override
  String get chD30Label => 'D30 छाया प्रोफ़ाइल';

  @override
  String get chD60Label => 'D60 पूर्वजन्म चरित्र';

  @override
  String get chD30Standing => 'छाया स्थिति';

  @override
  String get chMaternalInheritance => 'मातृ विरासत';

  @override
  String get chAncestralKarmaWeight => 'पैतृक कर्म भार';

  @override
  String get chTimelineTitle => 'चरित्र समयरेखा';

  @override
  String get chFormationWindow => 'निर्माण अवधि';

  @override
  String get chMaturationWindow => 'परिपक्वता अवधि';

  @override
  String get chLegacyWindow => 'विरासत अवधि';

  @override
  String get chPeakMaturationAge => 'शिखर परिपक्वता आयु';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return 'आयु $ageRange';
  }

  @override
  String get chImprovementTitle => 'सुधार योजना';

  @override
  String get chRoadmapTitle => 'आपका चरित्र रोडमैप';

  @override
  String get chAuthenticExpression => 'प्रामाणिक आत्म-अभिव्यक्ति';

  @override
  String get chRealizationPotential => 'चरित्र साकार करने की क्षमता';

  @override
  String get chLayerAtmakaraka => 'आत्मा ग्रह (आत्मकारक)';

  @override
  String get chLayerD1 => 'जन्म कुंडली (D1)';

  @override
  String get chLayerD9 => 'नवमांश (D9)';

  @override
  String get chLayerD30 => 'त्रिंशांश (D30)';

  @override
  String get chLayerLagnaMoon => 'लग्न और चंद्रमा';

  @override
  String get chLayerArudha => 'आरूढ़ लग्न';

  @override
  String get chTopicStrengths => 'मेरी चरित्र शक्तियाँ';

  @override
  String get chTopicShadow => 'मेरे छाया पैटर्न';

  @override
  String get chTopicSoul => 'मेरी आत्मा की पहचान';

  @override
  String get chTopicRelationships => 'मेरी रिश्तों की शैली';

  @override
  String get chTopicEthics => 'मेरी नैतिकता और मूल्य';

  @override
  String get chTopicGuna => 'मेरा गुण और दोष प्रोफ़ाइल';

  @override
  String get chTopicGrowth => 'मेरे चरित्र को कैसे विकसित करें';

  @override
  String get chTopicTiming => 'चरित्र-कार्य के लिए सर्वोत्तम समय';

  @override
  String get lpSubtitle => 'AI-संचालित वैदिक जीवन पथ और भाग्य रिपोर्ट';

  @override
  String get lpTitle => 'जीवन पथ और भाग्य';

  @override
  String get lpSnapshotHeader => 'जीवन पथ की झलक';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return 'आप एक $archetype हैं जिनका मुख्य उद्देश्य $domain में है। हमारे विश्लेषण के अनुसार आपकी समग्र जीवन-पूर्णता क्षमता $probability% है।';
  }

  @override
  String get lpGaugeDharma => 'धर्म स्पष्टता';

  @override
  String get lpGaugeFortune => 'भाग्य आधार';

  @override
  String get lpGaugeCoherence => 'पथ सामंजस्य';

  @override
  String get lpGaugeFulfillment => 'पूर्णता';

  @override
  String get lpGaugeMomentum => 'कर्म गति';

  @override
  String get lpChipRareGift => 'दुर्लभ नियति उपहार';

  @override
  String get lpChipFreeWillStrong => 'प्रबल स्वतंत्र इच्छाशक्ति';

  @override
  String get lpChipGraceSupported => 'कृपा-समर्थित';

  @override
  String get lpChipLightKarma => 'हल्का कर्म भार';

  @override
  String get lpChipRecognitionPotential => 'पहचान की संभावना';

  @override
  String get lpChipSpiritualPath => 'प्रबल आध्यात्मिक झुकाव';

  @override
  String get lpChipBlessed => 'कुंडली में आशीर्वाद है';

  @override
  String get lpSoulPathTitle => 'आपका आत्मा पथ';

  @override
  String get lpSoulPlanet => 'आत्मा ग्रह';

  @override
  String get lpCareerPlanet => 'उद्देश्य ग्रह';

  @override
  String get lpSoulClarity => 'उद्देश्य स्पष्टता';

  @override
  String get lpLifeChapter => 'वर्तमान जीवन अध्याय';

  @override
  String get lpPrimaryDomain => 'मुख्य उद्देश्य क्षेत्र';

  @override
  String get lpKarakaTitle => 'आपके धर्म ग्रह';

  @override
  String get lpKarakaSubtitle =>
      'हर ग्रह आपके जीवन उद्देश्य का कितना समर्थन करता है';

  @override
  String get lpVerificationTitle => 'कुंडलियों में सत्यापित (D9 / D60)';

  @override
  String get lpD9Label => 'D9 आत्मा संरेखण';

  @override
  String lpD9Explain(Object stage) {
    return 'नवांश कुंडली में आपकी आत्मा-विकास अवस्था \'$stage\' है।';
  }

  @override
  String get lpD9JupiterDignity => 'गुरु की गरिमा';

  @override
  String get lpD9DharmaMultiplier => 'धर्म गुणक';

  @override
  String get lpD60Label => 'D60 पूर्वजन्म हस्ताक्षर';

  @override
  String get lpKarmaType => 'पूर्वजन्म कर्म प्रकार';

  @override
  String get lpKetuMastery => 'केतु पूर्वजन्म निपुणता';

  @override
  String get lpRahuGrowthDir => 'राहु विकास दिशा';

  @override
  String get lpYogasTitle => 'भाग्य योग और भाग्य अवरोध';

  @override
  String get lpFortuneBoost => 'भाग्य वृद्धि';

  @override
  String get lpLuckDrain => 'भाग्य ह्रास';

  @override
  String get lpFortuneBoosters => 'भाग्य बढ़ाने वाले योग';

  @override
  String get lpLuckBlocks => 'भाग्य अवरोधक';

  @override
  String get lpPurposeTitle => 'उद्देश्य क्षेत्र और प्रसिद्धि';

  @override
  String get lpDomainLeadership => 'नेतृत्व';

  @override
  String get lpDomainWisdom => 'ज्ञान और शिक्षण';

  @override
  String get lpDomainService => 'सेवा';

  @override
  String get lpDomainHealing => 'उपचार';

  @override
  String get lpDomainCreative => 'रचनात्मक अभिव्यक्ति';

  @override
  String get lpPrimaryDomainBadge => 'मुख्य';

  @override
  String get lpFameRecognition => 'प्रसिद्धि और पहचान';

  @override
  String get lpSocialInfluence => 'सामाजिक प्रभाव';

  @override
  String get lpRecognitionDomain => 'पहचान क्षेत्र';

  @override
  String get lpPublicImage => 'सार्वजनिक छवि';

  @override
  String get lpHistoricalImpact => 'ऐतिहासिक प्रभाव क्षमता';

  @override
  String get lpTimelineTitle => 'भाग्य और जीवन समयरेखा';

  @override
  String get lpCurrentPhase => 'वर्तमान भाग्य चरण';

  @override
  String get lpJupiterReturn => 'गुरु प्रत्यागमन';

  @override
  String get lpSaturnReturn => 'शनि प्रत्यागमन';

  @override
  String get lpSadeSati => 'साढ़े साती';

  @override
  String get lpGoldenWindow => 'स्वर्णिम अवसर काल';

  @override
  String get lpTransformationWindow => 'रूपांतरण काल';

  @override
  String get lpPeakYears => 'शीर्ष भाग्य वर्ष';

  @override
  String get lpChallengingYears => 'चुनौतीपूर्ण वर्ष';

  @override
  String get lpMilestonesTitle => 'प्रमुख पड़ाव और मोड़';

  @override
  String get lpFirstTurningPoint => 'पहला बड़ा मोड़';

  @override
  String get lpMidlifeTransform => 'मध्य-जीवन परिवर्तन';

  @override
  String get lpLateLifeFulfillment => 'उत्तर-जीवन पूर्णता';

  @override
  String lpDharmicMilestone(Object age) {
    return 'धार्मिक पड़ाव (आयु $age)';
  }

  @override
  String lpAgeLabel(Object age) {
    return 'आयु $age';
  }

  @override
  String get lpDestinyTitle => 'नियति बनाम स्वतंत्र इच्छा';

  @override
  String get lpDestinyStat => 'नियति भार';

  @override
  String get lpFreeWillStat => 'स्वतंत्र इच्छा प्रभाव';

  @override
  String get lpFateStrength => 'भाग्य हस्ताक्षर शक्ति';

  @override
  String get lpSelfCreation => 'स्व-निर्माण क्षमता';

  @override
  String get lpEffortGrace => 'प्रयास बनाम कृपा';

  @override
  String get lpKarmicTitle => 'कर्म पाठ';

  @override
  String get lpRahuGrowthLabel => 'राहु — विकास चुनौती';

  @override
  String get lpKetuSurrenderLabel => 'केतु — समर्पण विषय';

  @override
  String get lpSaturnLessonLabel => 'शनि — अनुशासन पाठ';

  @override
  String get lpTestDifficulty => 'जीवन परीक्षा कठिनाई';

  @override
  String get lpLessonsInProgress => 'प्रगति में पाठ';

  @override
  String get lpSoulContract => 'आत्मा अनुबंध क्षेत्र';

  @override
  String get lpSoulExperience => 'आपकी आत्मा क्या अनुभव करने आई';

  @override
  String get lpSoulMastery => 'आपकी आत्मा क्या निपुणता पाने आई';

  @override
  String get lpSpiritualTitle => 'आध्यात्मिक पथ';

  @override
  String get lpSpiritualInclination => 'आध्यात्मिक झुकाव';

  @override
  String get lpMeditationReceptivity => 'ध्यान ग्रहणशीलता';

  @override
  String get lpTeacherKarma => 'गुरु/शिक्षक कर्म';

  @override
  String get lpPilgrimageBenefit => 'तीर्थयात्रा लाभ';

  @override
  String get lpSelfRealization => 'आत्म-साक्षात्कार क्षमता';

  @override
  String get lpDivineConnection => 'दिव्य संबंध';

  @override
  String get lpTraditionAffinity => 'परंपरा के प्रति रुझान';

  @override
  String get lpIntuitionStrength => 'अंतर्ज्ञान शक्ति';

  @override
  String get lpMantraEfficacy => 'प्रार्थना/मंत्र प्रभावशीलता';

  @override
  String get lpInnerGuidance => 'आंतरिक मार्गदर्शन विश्वास';

  @override
  String get lpPropheticDreams => 'भविष्यसूचक सपनों की संवेदनशीलता';

  @override
  String get lpDifficultyTitle => 'जीवन कठिनाई और चुनौतियाँ';

  @override
  String get lpEarlyLife => 'प्रारंभिक जीवन';

  @override
  String get lpMidlife => 'मध्य जीवन';

  @override
  String get lpLateLife => 'उत्तर जीवन';

  @override
  String get lpStruggleToSuccess => 'संघर्ष-से-सफलता कर्म';

  @override
  String get lpUnlivedLifeRisk => 'अधूरे जीवन का जोखिम';

  @override
  String get lpChallenges => 'जीवन चुनौतियाँ';

  @override
  String get lpFortuneDrains => 'दीर्घकालिक भाग्य ह्रास';

  @override
  String get lpRegretAreas => 'पछतावा-संवेदनशील क्षेत्र';

  @override
  String get lpRedFlags => 'दिशा चेतावनी संकेत';

  @override
  String get lpBlessingsTitle => 'आशीर्वाद और मुख्य जीवन विषय';

  @override
  String get lpKarmicRoot => 'कर्म मूल';

  @override
  String get lpBlessingsList => 'आपके आशीर्वाद';

  @override
  String get lpFulfillmentPriorities => 'पूर्णता प्राथमिकताएँ';

  @override
  String get lpImprovementTitle => 'सुधार योजना';

  @override
  String get lpDharmaPriorities => 'धर्म प्राथमिकताएँ';

  @override
  String get lpRoadmapTitle => 'आपकी नियति योजना';

  @override
  String get lpStrategy => 'रणनीति';

  @override
  String get lpFulfillmentPotential => 'पूर्णता क्षमता';

  @override
  String get lpNext12Focus => 'अगले 12 महीनों का फोकस';

  @override
  String get lpLayerD1 => 'जन्म कुंडली (D1)';

  @override
  String get lpLayerD9 => 'नवांश (D9)';

  @override
  String get lpLayerD60 => 'षष्ठ्यंश (D60)';

  @override
  String get lpLayerDasha => 'दशा समय';

  @override
  String get lpLayerTransit => 'वर्तमान गोचर';

  @override
  String get lpTopicPurpose => 'मेरा जीवन उद्देश्य';

  @override
  String get lpTopicFortune => 'मेरे भाग्य योग';

  @override
  String get lpTopicKarma => 'मेरे कर्म पाठ';

  @override
  String get lpTopicMilestones => 'आगामी पड़ाव';

  @override
  String get lpTopicDestiny => 'नियति बनाम स्वतंत्र इच्छा';

  @override
  String get lpTopicSpiritual => 'मेरा आध्यात्मिक पथ';

  @override
  String get lpTopicChallenges => 'मेरी जीवन चुनौतियाँ';

  @override
  String get lpTopicTiming => 'सर्वोत्तम समय अवधि';

  @override
  String get dbSubtitle => 'AI-संचालित वैदिक ऋण एवं वसूली रिपोर्ट';

  @override
  String get dbTitle => 'ऋण एवं वसूली';

  @override
  String get dbSnapshotHeader => 'ऋण वसूली स्नैपशॉट';

  @override
  String dbHeroSummary(
    Object phase,
    Object personality,
    Object probability,
    Object years,
  ) {
    return 'आप वर्तमान में \'$phase\' चरण में हैं और पैसे के प्रति आपका दृष्टिकोण $personality है। हमारे विश्लेषण के अनुसार लगभग $years वर्षों में ऋण-मुक्त होने की $probability% संभावना है।';
  }

  @override
  String get dbGaugeCapacity => 'वसूली क्षमता';

  @override
  String get dbGaugeProbability => 'वसूली की संभावना';

  @override
  String get dbGaugeFreedomNow => 'अभी ऋण मुक्ति';

  @override
  String get dbGaugeDti => 'आय स्वास्थ्य';

  @override
  String get dbGaugeResilience => 'लचीलापन';

  @override
  String get dbChipCleanKarma => 'स्वच्छ ऋण कर्म';

  @override
  String get dbChipStrongRecovery => 'मजबूत वसूली क्षमता';

  @override
  String get dbChipHealthyDti => 'स्वस्थ ऋण-आय अनुपात';

  @override
  String get dbChipResilient => 'उच्च मानसिक लचीलापन';

  @override
  String get dbChipCycleBreakable => 'ऋण चक्र तोड़ा जा सकता है';

  @override
  String get dbChipLowReindebt => 'पुनः-ऋणी होने का कम जोखिम';

  @override
  String get dbChipGoodNegotiator => 'अच्छी बातचीत की संभावना';

  @override
  String get dbProfileTitle => 'आपकी ऋण प्रोफ़ाइल';

  @override
  String get dbPhaseLabel => 'वर्तमान चरण';

  @override
  String get dbPrimaryCategoryLabel => 'मुख्य श्रेणी';

  @override
  String get dbKarakaLabel => 'ऋण कारक';

  @override
  String get dbProtectorLabel => 'लेनदार संरक्षण';

  @override
  String get dbSecondaryCategories => 'द्वितीयक श्रेणियाँ';

  @override
  String get dbUnsecuredRatio => 'असुरक्षित-ऋण अनुपात';

  @override
  String get dbKarakaTitle => 'आपके ऋण ग्रह';

  @override
  String get dbKarakaSubtitle =>
      'प्रत्येक ग्रह आपकी ऋण वसूली को कितनी मजबूती से समर्थन देता है';

  @override
  String get dbVerificationTitle => 'सभी चार्ट में सत्यापित (D6)';

  @override
  String get dbD6Label => 'D6 ऋण एवं शत्रु चार्ट';

  @override
  String get dbD6LordDignity => 'छठे भाव स्वामी की शक्ति';

  @override
  String get dbD6Severity => 'ऋण कर्म की गंभीरता';

  @override
  String get dbD6Multiplier => 'D6 ऋण गुणक';

  @override
  String get dbYogasTitle => 'ऋण योग एवं सुरक्षा';

  @override
  String get dbPressureNow => 'वर्तमान ऋण दबाव';

  @override
  String get dbRecoveryBoost => 'वसूली बूस्ट';

  @override
  String get dbClearingLabel => 'ऋण-मुक्ति योग';

  @override
  String get dbCreatingLabel => 'ऋण-निर्माण योग';

  @override
  String get dbCategoriesTitle => 'ऋण श्रेणी निगरानी';

  @override
  String get dbCategoriesSubtitle =>
      'किस प्रकार के ऋण पर सबसे अधिक ध्यान देने की आवश्यकता है';

  @override
  String get dbTimelineTitle => 'ऋण-मुक्ति समयरेखा';

  @override
  String get dbFreeWindowLabel => 'ऋण-मुक्ति विंडो';

  @override
  String get dbClearanceEstimate => 'पूर्ण निपटान अनुमान';

  @override
  String get dbPeakYears => 'ऋण-शिखर वर्ष';

  @override
  String get dbClearanceYears => 'निपटान वर्ष';

  @override
  String get dbBorrowTitle => 'स्मार्ट उधार गाइड';

  @override
  String get dbLoanSuitability => 'ऋण उपयुक्तता';

  @override
  String get dbBestLoanType => 'सर्वोत्तम ऋण प्रकार';

  @override
  String get dbLeverageCeiling => 'लीवरेज सीमा';

  @override
  String get dbNegotiationSuccess => 'बातचीत की सफलता';

  @override
  String get dbCreditorAggression => 'लेनदार दबाव जोखिम';

  @override
  String get dbLegalEscalation => 'कानूनी वृद्धि जोखिम';

  @override
  String get dbNegotiationApproach => 'अनुशंसित दृष्टिकोण';

  @override
  String get dbAvoidLoanTypes => 'बचने योग्य ऋण प्रकार';

  @override
  String get dbRiskTitle => 'जोखिम एवं भेद्यता निगरानी';

  @override
  String get dbRiskDefault => 'डिफ़ॉल्ट जोखिम';

  @override
  String get dbRiskDefaultExp =>
      'किसी निर्धारित पुनर्भुगतान को इतनी बुरी तरह चूकने की संभावना कि यह ऋणदाता के साथ डिफ़ॉल्ट स्थिति को ट्रिगर कर दे।';

  @override
  String get dbRiskDefaultFix =>
      'न्यूनतम भुगतान को स्वचालित करें और 1 महीने का बफर रखें ताकि आय चक्र छूटने पर भी असर आगे न बढ़े।';

  @override
  String get dbRiskBankruptcy => 'दिवालियापन जोखिम';

  @override
  String get dbRiskBankruptcyExp =>
      'ऋण भार के इतना बढ़ जाने की संभावना कि आय और संपत्ति वास्तविक रूप से उसे कवर न कर सकें।';

  @override
  String get dbRiskBankruptcyFix =>
      'कोई भी नया ऋण या क्रेडिट लाइन लेने से पहले पेशेवर ऋण समीक्षा करवाएं।';

  @override
  String get dbRiskAssetSeizure => 'संपत्ति-जब्ती जोखिम';

  @override
  String get dbRiskAssetSeizureExp =>
      'सुरक्षित ऋण में चूक होने पर ऋणदाता द्वारा गिरवी संपत्ति या संपत्ति जब्त किए जाने की संभावना।';

  @override
  String get dbRiskAssetSeizureFix =>
      'सुरक्षित-ऋण भुगतान को प्राथमिकता दें, और भुगतान में अंतर की संभावना दिखने पर जल्दी पुनर्वित्त करें।';

  @override
  String get dbRiskChronic => 'बार-बार ऋणी होने का जोखिम';

  @override
  String get dbRiskChronicExp =>
      'वर्तमान ऋण चुकाने के बाद भी दोबारा ऋण में फंसने की प्रवृत्ति।';

  @override
  String get dbRiskChronicFix =>
      'निपटान के बाद जीवनशैली खर्च बढ़ाने से पहले एक समर्पित आपातकालीन कोष बनाएं।';

  @override
  String get dbReindebtTrigger => 'पुनः-ऋण ट्रिगर';

  @override
  String get dbCycleBreakFeasibility => 'चक्र-भंग व्यवहार्यता';

  @override
  String get dbMajorRisks => 'प्रमुख जोखिम';

  @override
  String get dbHiddenSignals => 'छिपे हुए ऋण संकेत';

  @override
  String get dbCrisisTitle => 'संकट तैयारी';

  @override
  String get dbCrisisSubtitle =>
      'परेशानी को जल्दी कैसे पहचानें और शांति से प्रतिक्रिया दें';

  @override
  String get dbWarningSigns => 'प्रारंभिक चेतावनी संकेत';

  @override
  String get dbMitigationActions => 'इस बारे में क्या करें';

  @override
  String get dbFamilyTitle => 'पारिवारिक एवं पैतृक ऋण';

  @override
  String get dbInheritedDebtProb => 'विरासत में ऋण की संभावना';

  @override
  String get dbFamilyDrag => 'पारिवारिक ऋण खिंचाव';

  @override
  String get dbInheritedSource => 'संभावित स्रोत';

  @override
  String get dbCoreBlockerLabel => 'मुख्य बाधा';

  @override
  String get dbPsychologyTitle => 'आपका धन मनोविज्ञान';

  @override
  String get dbResilience => 'लचीलापन';

  @override
  String get dbDiscipline => 'दबाव में अनुशासन';

  @override
  String get dbSocialSupport => 'सामाजिक सहयोग';

  @override
  String get dbDepressionRisk => 'वित्तीय-तनाव संवेदनशीलता';

  @override
  String get dbStressTolerance => 'तनाव सहनशीलता';

  @override
  String get dbRootCause => 'व्यवहारिक मूल कारण';

  @override
  String get dbImprovementTitle => 'सुधार योजना';

  @override
  String get dbRoadmapTitle => 'आपका ऋण-मुक्ति रोडमैप';

  @override
  String get dbRecoveryProbability => 'वसूली संभावना';

  @override
  String get dbClearanceTimeline => 'निपटान समयरेखा';

  @override
  String get dbYears => 'वर्ष';

  @override
  String get dbDtiHealth => 'ऋण-आय स्वास्थ्य';

  @override
  String get dbDtiCategory => 'DTI श्रेणी';

  @override
  String get dbBreakEvenMonths => 'ब्रेक-ईवन तक महीने';

  @override
  String get dbIncomeAcceleration => 'आवश्यक आय वृद्धि';

  @override
  String get dbLayerD1 => 'जन्म कुंडली (D1)';

  @override
  String get dbLayerD6 => 'ऋण एवं शत्रु (D6)';

  @override
  String get dbLayerD9 => 'नवमांश (D9)';

  @override
  String get dbLayerDasha => 'दशा समय';

  @override
  String get dbLayerTransit => 'वर्तमान गोचर';

  @override
  String get dbTopicRecovery => 'मेरी वसूली समयरेखा';

  @override
  String get dbTopicNegotiate => 'लेनदारों से बातचीत';

  @override
  String get dbTopicBorrowing => 'क्या अभी उधार लेना सुरक्षित है';

  @override
  String get dbTopicCrisis => 'संकट की तैयारी';

  @override
  String get dbTopicAncestral => 'पैतृक ऋण कर्म';

  @override
  String get dbTopicTimeline => 'ऋण चुकाने के सर्वोत्तम वर्ष';

  @override
  String get dbTopicPsychology => 'मेरा धन मनोविज्ञान';

  @override
  String get dbTopicCategories => 'किन ऋणों को प्राथमिकता दें';

  @override
  String get mnSubtitle => 'AI-संचालित वैदिक वेलनेस रिपोर्ट';

  @override
  String get mnTitle => 'मानसिक स्वास्थ्य और तनाव';

  @override
  String get mnSnapshotHeader => 'वेलनेस स्नैपशॉट';

  @override
  String get mnResilience => 'लचीलापन';

  @override
  String get mnStability => 'स्थिरता';

  @override
  String get mnEmotionalBalance => 'भावनात्मक संतुलन';

  @override
  String get mnInnerCalm => 'आंतरिक शांति';

  @override
  String get mnSelfAwareness => 'आत्म-जागरूकता';

  @override
  String get mnStatusThriving => 'फल-फूल रहे हैं';

  @override
  String get mnStatusSteady => 'स्थिर और संतुलित';

  @override
  String get mnStatusBuildingStrength => 'शक्ति का निर्माण';

  @override
  String get mnStatusNeedsGentleCare => 'थोड़ी कोमल देखभाल चाहिए';

  @override
  String get mnStatusReachOut => 'सहारा लेने का समय';

  @override
  String get mnChipStable => 'भावनात्मक रूप से स्थिर';

  @override
  String get mnChipSupported => 'अच्छा सहारा प्राप्त';

  @override
  String get mnChipSelfAware => 'अत्यंत आत्म-जागरूक';

  @override
  String get mnChipResilient => 'जल्दी संभल जाते हैं';

  @override
  String get mnChipSecureAttachment => 'सुरक्षित लगाव';

  @override
  String get mnChipHealingReady => 'उपचार के लिए तैयार';

  @override
  String get mnChipMindBodyBalance => 'मन-शरीर संतुलन';

  @override
  String get mnSupportBannerTitle => 'एक कोमल सुझाव';

  @override
  String get mnSupportBannerBody =>
      'आपकी कुंडली बताती है कि अभी थोड़ा अतिरिक्त सहारा लेना अच्छा रहेगा — कोई भरोसेमंद दोस्त, परिवार का सदस्य, या विशेषज्ञ। मदद माँगना कमज़ोरी नहीं, बल्कि हिम्मत की निशानी है।';

  @override
  String get mnProfileTitle => 'आपका भावनात्मक खाका';

  @override
  String get mnStressDriver => 'तनाव का कारण';

  @override
  String get mnStabilityAnchor => 'स्थिरता का आधार';

  @override
  String get mnSoulLevelKarma => 'आत्मा-स्तर का पैटर्न';

  @override
  String get mnSubtleSignature => 'सूक्ष्म भावनात्मक छाप';

  @override
  String get mnKarakaTitle => 'आपका मन और ग्रह';

  @override
  String get mnKarakaSubtitle =>
      'कौन से ग्रह आपकी भीतरी दुनिया को आकार देते हैं';

  @override
  String get mnYogasTitle => 'शक्तियाँ और विकास क्षेत्र';

  @override
  String get mnCurrentPhase => 'मौजूदा चरण';

  @override
  String get mnCurrentStressLevel => 'मौजूदा तनाव स्तर';

  @override
  String get mnRecentStrain => 'हाल की भावनात्मक थकान';

  @override
  String get mnStrengths => 'शक्तियाँ';

  @override
  String get mnGrowthAreas => 'विकास के क्षेत्र';

  @override
  String get mnSadeSatiStatus => 'साढ़े साती की स्थिति';

  @override
  String get mnVerificationTitle => 'सभी कुंडलियों में पुष्टि';

  @override
  String get mnD9Confirmation => 'D9 पुष्टि';

  @override
  String get mnD30Confirmation => 'D30 पुष्टि';

  @override
  String get mnMoodPatternsTitle => 'मूड और चिंता के पैटर्न';

  @override
  String get mnMoodPatternsSubtitle => 'कोमल जागरूकता, कोई निदान नहीं';

  @override
  String get mnAnxietyPatterns => 'चिंता के पैटर्न';

  @override
  String get mnMoodPatterns => 'उदासी के पैटर्न';

  @override
  String get mnPrimaryPattern => 'मुख्य पैटर्न';

  @override
  String get mnRumination => 'अधिक सोचने की प्रवृत्ति';

  @override
  String get mnHypervigilance => 'अति-सतर्कता';

  @override
  String get mnHopelessnessVuln => 'उदासी के प्रति संवेदनशीलता';

  @override
  String get mnEnergyDepletion => 'ऊर्जा घटने की प्रवृत्ति';

  @override
  String get mnMotivationBaseline => 'प्रेरणा का आधार स्तर';

  @override
  String get mnRegulationTitle => 'भावनात्मक नियमन और मुकाबला';

  @override
  String get mnEmotionalRegulation => 'भावनात्मक नियमन';

  @override
  String get mnSelfSoothing => 'स्वयं को शांत करने की क्षमता';

  @override
  String get mnExpressionStyle => 'अभिव्यक्ति की शैली';

  @override
  String get mnRecoveryTime => 'रिकवरी का समय';

  @override
  String get mnTriggerIntensity => 'ट्रिगर की तीव्रता';

  @override
  String get mnHealthyCoping => 'स्वस्थ मुकाबला आदतें';

  @override
  String get mnWatchFor => 'कोमलता से ध्यान रखें';

  @override
  String get mnSleepTitle => 'नींद और आराम';

  @override
  String get mnSleepQuality => 'नींद की गुणवत्ता';

  @override
  String get mnSleepAsRegulator => 'भावनात्मक संतुलन में नींद की भूमिका';

  @override
  String get mnInsomniaTendency => 'बेचैन रातों की प्रवृत्ति';

  @override
  String get mnNightmareTendency => 'गहरे सपनों की प्रवृत्ति';

  @override
  String get mnSleepHygienePriority => 'नींद की स्वच्छता की प्राथमिकता';

  @override
  String get mnBurnoutTitle => 'बर्नआउट और ऊर्जा';

  @override
  String get mnBurnoutVulnerability => 'बर्नआउट संवेदनशीलता';

  @override
  String get mnBurnoutRecovery => 'बर्नआउट से उबरने की क्षमता';

  @override
  String get mnBurnoutStage => 'मौजूदा बर्नआउट चरण';

  @override
  String get mnSelfDrivingTendency => 'स्वयं को आगे बढ़ाने की प्रवृत्ति';

  @override
  String get mnBurnoutTriggers => 'बर्नआउट के कारण';

  @override
  String get mnConnectionTitle => 'जुड़ाव और सहारा';

  @override
  String get mnSocialSupport => 'सामाजिक सहारे की गुणवत्ता';

  @override
  String get mnLonelinessVuln => 'अकेलेपन के प्रति संवेदनशीलता';

  @override
  String get mnSolitudeNeed => 'एकांत की आवश्यकता';

  @override
  String get mnSocialComfort => 'सामाजिक सहजता';

  @override
  String get mnTraumaSensitivity => 'आघात के प्रति संवेदनशीलता';

  @override
  String get mnHealingReadiness => 'उपचार के लिए तैयारी';

  @override
  String get mnProcessingStyle => 'समझने-सुलझाने की शैली';

  @override
  String get mnMindBodyIntegration => 'मन-शरीर एकीकरण';

  @override
  String get mnPtsdVuln => 'आघात-प्रतिक्रिया संवेदनशीलता';

  @override
  String get mnSelfAwarenessTitle => 'आत्म-जागरूकता और विकास';

  @override
  String get mnSelfAwarenessScore => 'आत्म-जागरूकता';

  @override
  String get mnEmotionalVocabulary => 'भावनाओं को व्यक्त करने की शब्दावली';

  @override
  String get mnTherapyReadiness => 'थेरेपी के लिए तैयारी';

  @override
  String get mnJournalingBenefit => 'जर्नलिंग से लाभ';

  @override
  String get mnInnerDialogue => 'आंतरिक संवाद की गुणवत्ता';

  @override
  String get mnAwarenessOfPatterns => 'पैटर्न की समझ';

  @override
  String get mnEscapePatternVuln => 'पलायन-प्रवृत्ति संवेदनशीलता';

  @override
  String get mnEscapeChannels => 'कोमलता से ध्यान रखें';

  @override
  String get mnHealthyAlternatives => 'स्वस्थ विकल्प';

  @override
  String get mnTherapyFitTitle => 'थेरेपी और सहारे की उपयुक्तता';

  @override
  String get mnCrisisSupportRec => 'सहारे की सिफ़ारिश';

  @override
  String get mnSupportNetwork => 'अपना सहायता नेटवर्क सक्रिय करें';

  @override
  String get mnSelfAdvocacy => 'स्वयं के लिए आवाज़ उठाने की तैयारी';

  @override
  String get mnMedicationReceptivity => 'दवा के प्रति खुलापन';

  @override
  String get mnTimelineTitle => 'वेलनेस समयरेखा';

  @override
  String get mnPeakWellnessYears => 'सर्वोत्तम वेलनेस वर्ष';

  @override
  String get mnExtraCareYears => 'अतिरिक्त आत्म-देखभाल के वर्ष';

  @override
  String get mnTransformationWindows => 'सकारात्मक बदलाव के समय';

  @override
  String get mnTherapyWindow => 'अनुशंसित थेरेपी का समय';

  @override
  String get mnPracticesTitle => 'दैनिक वेलनेस अभ्यास';

  @override
  String get mnMorningPractices => 'सुबह के अभ्यास';

  @override
  String get mnEveningPractices => 'शाम के अभ्यास';

  @override
  String get mnBreathwork => 'श्वास अभ्यास';

  @override
  String get mnMovement => 'गतिविधि';

  @override
  String get mnNutrition => 'पोषण';

  @override
  String get mnNatureExposure => 'प्रकृति से जुड़ाव की आवश्यकता';

  @override
  String get mnDigitalDetox => 'डिजिटल डिटॉक्स की आवश्यकता';

  @override
  String get mnImprovementTitle => 'सुधार योजना';

  @override
  String get mnReliabilityTitle => 'विश्वसनीयता';

  @override
  String get mnLayerD1 => 'जन्म कुंडली (D1)';

  @override
  String get mnLayerD9 => 'आत्मा कुंडली (D9)';

  @override
  String get mnLayerD30 => 'D30 कुंडली';

  @override
  String get mnLayerDasha => 'दशा समय';

  @override
  String get mnLayerTransit => 'गोचर';

  @override
  String get mnTopicResilience => 'मैं भावनात्मक रूप से कितना लचीला हूँ?';

  @override
  String get mnTopicCoping => 'मेरे लिए सबसे अच्छी मुकाबला रणनीतियाँ क्या हैं?';

  @override
  String get mnTopicSleep => 'मैं अपनी नींद कैसे सुधार सकता/सकती हूँ?';

  @override
  String get mnTopicBurnout => 'क्या मुझे बर्नआउट का खतरा है?';

  @override
  String get mnTopicTherapy => 'मेरे लिए कौन-सी थेरेपी शैली उपयुक्त है?';

  @override
  String get mnTopicPractices =>
      'कौन-से दैनिक अभ्यास मेरी सबसे ज़्यादा मदद करेंगे?';

  @override
  String get mnTopicTiming => 'मेरे लिए सबसे अच्छे वेलनेस वर्ष कब हैं?';

  @override
  String get mnTopicSupport => 'मैं एक मज़बूत सहायता नेटवर्क कैसे बनाऊँ?';

  @override
  String get lgSubtitle => 'AI-संचालित वैदिक कानूनी रिपोर्ट';

  @override
  String get lgTitle => 'कानून व विवाद';

  @override
  String get lgSnapshotHeader => 'कानूनी सारांश';

  @override
  String get lgResilience => 'कानूनी दृढ़ता';

  @override
  String get lgResolutionCapacity => 'समाधान क्षमता';

  @override
  String get lgVictoryPotential => 'विजय क्षमता';

  @override
  String get lgLegalSafety => 'कानूनी सुरक्षा';

  @override
  String get lgNegotiationSkill => 'समझौता कौशल';

  @override
  String get lgStatusExcellent => 'उत्कृष्ट';

  @override
  String get lgStatusStrong => 'मजबूत';

  @override
  String get lgStatusModerate => 'मध्यम';

  @override
  String get lgStatusDeveloping => 'विकसित हो रहा';

  @override
  String get lgStatusChallenging => 'चुनौतीपूर्ण';

  @override
  String get lgChipResolver => 'कुशल समाधानकर्ता';

  @override
  String get lgChipWinner => 'मजबूत केस विजेता';

  @override
  String get lgChipNegotiator => 'स्वाभाविक वार्ताकार';

  @override
  String get lgChipDocumented => 'अच्छी तरह दस्तावेज़ीकृत';

  @override
  String get lgChipLowRisk => 'कम कानूनी जोखिम';

  @override
  String get lgChipMoralAuthority => 'नैतिक अधिकार';

  @override
  String get lgChipLegalAptitude => 'कानूनी योग्यता';

  @override
  String get lgProfileTitle => 'आपकी कानूनी प्रोफ़ाइल व कर्म';

  @override
  String get lgPrimaryDriver => 'मुख्य प्रेरक तत्व';

  @override
  String get lgDharmaAnchor => 'धर्म आधार';

  @override
  String get lgAggressionMarker => 'आक्रामकता संकेतक';

  @override
  String get lgDocumentationKaraka => 'दस्तावेज़ीकरण गुणवत्ता';

  @override
  String get lgKarakaTitle => 'आपके कानूनी ग्रह';

  @override
  String get lgKarakaSubtitle =>
      'कौन से ग्रह आपके कानूनी भाग्य को आकार देते हैं';

  @override
  String get lgYogasTitle => 'कानूनी योग व सुरक्षाएँ';

  @override
  String get lgCurrentPhase => 'वर्तमान चरण';

  @override
  String get lgProtections => 'सुरक्षाएँ';

  @override
  String get lgDisputePressures => 'विवाद दबाव';

  @override
  String get lgVerificationTitle => 'सभी कुंडलियों में पुष्टि';

  @override
  String get lgD6Litigation => 'D6 मुकदमा कुंडली';

  @override
  String get lgD9Dharma => 'D9 धर्म कुंडली';

  @override
  String get lgMoralAuthority => 'नैतिक अधिकार';

  @override
  String get lgVictoryTitle => 'विजय विश्लेषण';

  @override
  String get lgAsPlaintiff => 'वादी के रूप में';

  @override
  String get lgAsDefendant => 'प्रतिवादी के रूप में';

  @override
  String get lgSettlementPreference => 'समझौता प्राथमिकता';

  @override
  String get lgDisputeCategoriesTitle => 'विवाद श्रेणी निगरानी';

  @override
  String get lgLowRiskCategories => 'कम जोखिम वाली श्रेणियाँ';

  @override
  String get lgConflictStyleTitle => 'संघर्ष शैली व शत्रु';

  @override
  String get lgConfrontationComfort => 'टकराव में सहजता';

  @override
  String get lgArgumentPersuasiveness => 'तर्क में प्रभावशीलता';

  @override
  String get lgEmotionalRegulation => 'भावनात्मक नियंत्रण';

  @override
  String get lgGrudgeHolding => 'मन में द्वेष रखने की प्रवृत्ति';

  @override
  String get lgEnemyAnalysisLabel => 'शत्रु विश्लेषण';

  @override
  String get lgVisibleEnemies => 'प्रत्यक्ष शत्रु';

  @override
  String get lgHiddenEnemies => 'छिपे शत्रु';

  @override
  String get lgWorkplaceEnemies => 'कार्यस्थल के शत्रु';

  @override
  String get lgFamilyEnemies => 'पारिवारिक शत्रु';

  @override
  String get lgLegalEnemies => 'कानूनी शत्रु';

  @override
  String get lgEnemyDefeatCapacity => 'शत्रु को परास्त करने की क्षमता';

  @override
  String get lgCriminalFinancialTitle => 'आपराधिक व वित्तीय जोखिम निगरानी';

  @override
  String get lgCriminalRisk => 'आपराधिक संलिप्तता जोखिम';

  @override
  String get lgVictimOfCrime => 'अपराध का शिकार होने की संभावना';

  @override
  String get lgFalseAccusation => 'झूठे आरोप का जोखिम';

  @override
  String get lgImprisonmentRisk => 'कारावास का जोखिम';

  @override
  String get lgTaxDisputeRisk => 'कर विवाद जोखिम';

  @override
  String get lgFinancialFraudRisk => 'वित्तीय धोखाधड़ी जोखिम';

  @override
  String get lgBusinessLitigationRisk => 'व्यावसायिक मुकदमेबाज़ी जोखिम';

  @override
  String get lgBankruptcyRisk => 'दिवालियापन जोखिम';

  @override
  String get lgAuditVulnerability => 'ऑडिट संवेदनशीलता';

  @override
  String get lgProtectionPriority => 'सुरक्षा प्राथमिकता';

  @override
  String get lgContractsTitle => 'अनुबंध व वार्ता';

  @override
  String get lgContractClarity => 'अनुबंध स्पष्टता';

  @override
  String get lgDocumentationDiscipline => 'दस्तावेज़ीकरण अनुशासन';

  @override
  String get lgFinePrintAwareness => 'बारीक शर्तों की जागरूकता';

  @override
  String get lgSignatureCaution => 'हस्ताक्षर सावधानी';

  @override
  String get lgMediationReceptivity => 'मध्यस्थता के प्रति ग्रहणशीलता';

  @override
  String get lgNegotiationSkillFull => 'समझौता कौशल';

  @override
  String get lgCompromiseWillingness => 'समझौते की इच्छा';

  @override
  String get lgFaceSavingNeeds => 'प्रतिष्ठा बचाने की आवश्यकता';

  @override
  String get lgMediatorHireRecommendation => 'मध्यस्थ नियुक्त करने की सलाह';

  @override
  String get lgTypicalContractIssues => 'सामान्य अनुबंध समस्याएँ';

  @override
  String get lgCareerFitTitle => 'कानूनी करियर उपयुक्तता';

  @override
  String get lgProfessionAffinity => 'व्यवसाय के प्रति रुझान';

  @override
  String get lgRoleFit => 'सर्वोत्तम भूमिका';

  @override
  String get lgLawStudentSuccess => 'विधि छात्र सफलता';

  @override
  String get lgBarExamSuccess => 'बार परीक्षा सफलता';

  @override
  String get lgTimelineTitle => 'कानूनी समयरेखा';

  @override
  String get lgNewMatterChance => 'नए मामले की संभावना (अगले 12 माह)';

  @override
  String get lgOngoingCaseOutcome => 'चल रहे मामले का परिणाम';

  @override
  String get lgRecommendedAction => 'अनुशंसित कार्रवाई';

  @override
  String get lgPeakDisputeYears => 'विवाद के चरम वर्ष';

  @override
  String get lgClarityYears => 'कानूनी स्पष्टता के वर्ष';

  @override
  String get lgAvoidancePeriods => 'महत्वपूर्ण बचाव अवधि';

  @override
  String get lgFavorableWindows => 'अनुकूल समाधान अवधि';

  @override
  String get lgRisksTitle => 'जोखिम व कमज़ोरियाँ';

  @override
  String get lgChronicVulnerabilities => 'स्थायी कमज़ोरियाँ';

  @override
  String get lgAvoidDashaPeriods => 'सावधान रहने योग्य दशा अवधि';

  @override
  String get lgPreventivePriorities => 'निवारक प्राथमिकताएँ';

  @override
  String get lgRedFlags => 'चेतावनी संकेत स्थितियाँ';

  @override
  String get lgImprovementTitle => 'सुधार योजना';

  @override
  String get lgReliabilityTitle => 'विश्वसनीयता';

  @override
  String get lgLayerD1 => 'जन्म कुंडली (D1)';

  @override
  String get lgLayerD6 => 'मुकदमा कुंडली (D6)';

  @override
  String get lgLayerD9 => 'धर्म कुंडली (D9)';

  @override
  String get lgLayerDasha => 'दशा समय';

  @override
  String get lgLayerTransit => 'गोचर';

  @override
  String get lgTopicWinChance => 'मेरे जीतने की संभावना क्या है?';

  @override
  String get lgTopicStrategy => 'मेरे लिए सर्वोत्तम कानूनी रणनीति क्या है?';

  @override
  String get lgTopicContract => 'किन अनुबंध जोखिमों पर ध्यान दें?';

  @override
  String get lgTopicTiming => 'विवाद सुलझाने का सर्वोत्तम समय कब है?';

  @override
  String get lgTopicSettlement => 'मुझे समझौता करना चाहिए या लड़ना चाहिए?';

  @override
  String get lgTopicEnemies => 'मेरे छिपे शत्रु कौन हैं?';

  @override
  String get lgTopicProtection =>
      'मैं खुद को कानूनी रूप से कैसे सुरक्षित रखूँ?';

  @override
  String get lgTopicCareer => 'क्या मैं कानूनी करियर के लिए उपयुक्त हूँ?';

  @override
  String get prSubtitle => 'एआई-संचालित वैदिक संपत्ति रिपोर्ट';

  @override
  String get prTitle => 'संपत्ति और परिसंपत्तियाँ';

  @override
  String get prSnapshotHeader => 'संपत्ति स्नैपशॉट';

  @override
  String get prAcquisitionCapacity => 'अधिग्रहण क्षमता';

  @override
  String get prHomeOwnership => 'घर का स्वामित्व';

  @override
  String get prWealthPotential => 'धन क्षमता';

  @override
  String get prRentalIncome => 'किराये की आय';

  @override
  String get prLandOwnership => 'भूमि स्वामित्व';

  @override
  String get prStatusExcellent => 'उत्कृष्ट';

  @override
  String get prStatusStrong => 'मजबूत';

  @override
  String get prStatusModerate => 'मध्यम';

  @override
  String get prStatusDeveloping => 'विकासशील';

  @override
  String get prStatusChallenging => 'चुनौतीपूर्ण';

  @override
  String get prChipHomeOwner => 'घर का मालिक';

  @override
  String get prChipWealthBuilder => 'धन निर्माता';

  @override
  String get prChipLandOwner => 'भूमि मालिक';

  @override
  String get prChipInvestor => 'संपत्ति निवेशक';

  @override
  String get prChipInheritance => 'विरासत की संभावना';

  @override
  String get prChipVehicle => 'वाहन मालिक';

  @override
  String get prChipGlobalAsset => 'वैश्विक संपत्ति झुकाव';

  @override
  String get prProfileTitle => 'आपकी संपत्ति शैली';

  @override
  String get prHomeAesthetics => 'घर का सौंदर्य';

  @override
  String get prHomeSanctuary => 'घर एक आश्रय के रूप में';

  @override
  String get prComfortInvestment => 'आराम में निवेश';

  @override
  String get prVastuPriority => 'वास्तु प्राथमिकता';

  @override
  String get prNaturalElements => 'प्राकृतिक तत्व';

  @override
  String get prNextActionLabel => 'अगला कदम';

  @override
  String get prKarakaTitle => 'आपके संपत्ति ग्रह';

  @override
  String get prKarakaSubtitle =>
      'कौन से ग्रह आपकी संपत्ति भाग्य को आकार देते हैं';

  @override
  String get prPrimaryKaraka => 'मुख्य कारक';

  @override
  String get prDurableAsset => 'टिकाऊ संपत्ति कारक';

  @override
  String get prYogasTitle => 'संपत्ति योग और दोष';

  @override
  String get prCurrentPhase => 'वर्तमान चरण';

  @override
  String get prBoosters => 'बढ़ावा देने वाले कारक';

  @override
  String get prDrains => 'क्षय करने वाले कारक';

  @override
  String get prVerificationTitle => 'चार्ट्स में सत्यापित';

  @override
  String get prD4Property => 'D4 संपत्ति चार्ट';

  @override
  String get prD16Vehicle => 'D16 वाहन चार्ट';

  @override
  String get prVehicleFit => 'वाहन अनुकूलता';

  @override
  String get prJourneyTitle => 'स्वामित्व यात्रा और समयरेखा';

  @override
  String get prFirstHomeAge => 'पहले घर की उम्र';

  @override
  String get prFirstHomeType => 'पहले घर का प्रकार';

  @override
  String get prMultipleHomes => 'कई घर';

  @override
  String get prNewPropertySoon => 'जल्द नई संपत्ति';

  @override
  String get prFirstMajorWindow => 'पहली बड़ी अवधि';

  @override
  String get prBuyingWindow => 'खरीद अवधि';

  @override
  String get prConstructionWindow => 'निर्माण अवधि';

  @override
  String get prNextOpportunity => 'अगला अवसर';

  @override
  String get prLifetimePropertyCount => 'जीवनभर संपत्ति संख्या';

  @override
  String get prInheritanceTitle => 'विरासत और पारिवारिक संपत्ति';

  @override
  String get prMaternalInheritance => 'मातृ पक्ष से विरासत';

  @override
  String get prPaternalInheritance => 'पितृ पक्ष से विरासत';

  @override
  String get prAncestralProperty => 'पैतृक संपत्ति';

  @override
  String get prFamilyDisputeRisk => 'पारिवारिक विवाद जोखिम';

  @override
  String get prInheritanceTiming => 'विरासत का समय';

  @override
  String get prInheritanceType => 'विरासत का प्रकार';

  @override
  String get prLandInvestTitle => 'भूमि, निवेश और वैश्विक संपत्ति';

  @override
  String get prPropertyInvestor => 'संपत्ति निवेशक स्कोर';

  @override
  String get prAppreciationLuck => 'मूल्य वृद्धि भाग्य';

  @override
  String get prInvestorMindset => 'निवेशक मानसिकता';

  @override
  String get prLandType => 'भूमि का प्रकार';

  @override
  String get prRentalCount => 'किराये की संपत्ति संख्या';

  @override
  String get prMultipleLand => 'कई भूमि खंड';

  @override
  String get prFarmEstate => 'फार्म / एस्टेट संभावना';

  @override
  String get prGlobalPropertyLabel => 'वैश्विक संपत्ति';

  @override
  String get prForeignProperty => 'विदेशी संपत्ति';

  @override
  String get prNriAffinity => 'एनआरआई संपत्ति झुकाव';

  @override
  String get prVehiclesTitle => 'वाहन';

  @override
  String get prVehicleCount => 'वाहन संख्या';

  @override
  String get prVehicleFirstAge => 'पहले वाहन की उम्र';

  @override
  String get prVehicleCategory => 'वाहन श्रेणी';

  @override
  String get prVehicleQuality => 'वाहन गुणवत्ता';

  @override
  String get prLuxuryAffinity => 'लक्जरी झुकाव';

  @override
  String get prVehicleLossRisk => 'वाहन हानि / क्षति जोखिम';

  @override
  String get prLegalRiskTitle => 'कानूनी और जोखिम निगरानी';

  @override
  String get prBoundaryDisputes => 'सीमा विवाद';

  @override
  String get prPartitionDisputes => 'बंटवारे के विवाद';

  @override
  String get prTitleIssues => 'स्वामित्व / दस्तावेज़ीकरण समस्याएँ';

  @override
  String get prTenantConflict => 'किरायेदार-मकान मालिक विवाद';

  @override
  String get prForcedSale => 'जबरन बिक्री जोखिम';

  @override
  String get prPropertyDamage => 'संपत्ति क्षति जोखिम';

  @override
  String get prInsurancePriority => 'बीमा प्राथमिकता';

  @override
  String get prProtectionUrgency => 'सुरक्षा की तात्कालिकता';

  @override
  String get prProtectiveFactors => 'सुरक्षात्मक कारक';

  @override
  String get prChronicVulnerabilities => 'स्थायी कमजोरियाँ';

  @override
  String get prDueDiligenceTitle => 'सावधानी जांच सूची';

  @override
  String get prPreventiveMeasures => 'बचाव के उपाय';

  @override
  String get prImprovementTitle => 'सुधार योजना';

  @override
  String get prReliabilityTitle => 'विश्वसनीयता';

  @override
  String get prLayerD1 => 'जन्म कुंडली (D1)';

  @override
  String get prLayerD4 => 'संपत्ति चार्ट (D4)';

  @override
  String get prLayerD16 => 'वाहन चार्ट (D16)';

  @override
  String get prLayerDasha => 'दशा समय';

  @override
  String get prLayerTransit => 'गोचर';

  @override
  String get prTopicBuying => 'खरीदने का सबसे अच्छा समय?';

  @override
  String get prTopicInherit => 'क्या मुझे संपत्ति विरासत में मिलेगी?';

  @override
  String get prTopicVehicle => 'मुझे वाहन कब मिलेगा?';

  @override
  String get prTopicRental => 'किराये की आय की संभावना?';

  @override
  String get prTopicLand => 'भूमि स्वामित्व की संभावना?';

  @override
  String get prTopicLegal => 'किन कानूनी जोखिमों पर ध्यान दें?';

  @override
  String get prTopicForeign => 'विदेशी संपत्ति की संभावना?';

  @override
  String get prTopicTiming => 'संपत्ति के लिए सबसे अच्छा समय कब है?';

  @override
  String get edTitle => 'शिक्षा एवं अध्ययन विश्लेषण';

  @override
  String get edSubtitle => 'AI-संचालित वैदिक शिक्षा रिपोर्ट';

  @override
  String get edSnapshotHeader => 'आपकी शिक्षा झलक';

  @override
  String get edOverallStrength => 'समग्र शक्ति';

  @override
  String get edAcademicSuccess => 'शैक्षणिक सफलता';

  @override
  String get edLearningCapacity => 'सीखने की क्षमता';

  @override
  String get edIntellect => 'बुद्धि';

  @override
  String get edMemory => 'स्मरण शक्ति';

  @override
  String get edStatusExcellent => 'उत्कृष्ट संभावना';

  @override
  String get edStatusStrong => 'मजबूत संभावना';

  @override
  String get edStatusModerate => 'मध्यम संभावना';

  @override
  String get edStatusDeveloping => 'विकसित होती संभावना';

  @override
  String get edStatusChallenging => 'चुनौतीपूर्ण चरण';

  @override
  String get edChipSaraswati => 'सरस्वती योग';

  @override
  String get edChipGajaKesari => 'गजकेसरी योग';

  @override
  String get edChipBudhaAditya => 'बुध आदित्य योग';

  @override
  String get edChipResearch => 'मजबूत शोध क्षमता';

  @override
  String get edChipScholarship => 'छात्रवृत्ति संभावना';

  @override
  String get edChipDoctorate => 'डॉक्टरेट संभावना';

  @override
  String get edChipForeign => 'विदेश शिक्षा सहयोग';

  @override
  String get edChipLifelong => 'आजीवन शिक्षार्थी';

  @override
  String get edLearningStyleTitle => 'आपकी सीखने की शैली';

  @override
  String get edSoulPlanet => 'आत्मा ग्रह';

  @override
  String get edSoulHint => 'आपकी गहरी आंतरिक प्रेरणा और जीवन लक्ष्य';

  @override
  String get edSubjectPlanet => 'विषय ग्रह';

  @override
  String get edTechAtmakaraka => 'आत्मकारक (तकनीकी)';

  @override
  String get edTechAmatyakaraka => 'अमात्यकारक (तकनीकी)';

  @override
  String get edSubjectKarakaStrength => 'विषय कारक शक्ति';

  @override
  String get edFoundationTitle => 'शिक्षा की नींव';

  @override
  String get edHouse4 => 'प्रारंभिक शिक्षा';

  @override
  String get edHouse5 => 'बुद्धिमत्ता';

  @override
  String get edHouse9 => 'उच्च शिक्षा';

  @override
  String get edPurvaPunya => 'पूर्व-जन्म पुण्य';

  @override
  String get edStudyPlanetsTitle => 'आपके अध्ययन ग्रह';

  @override
  String get edYogasTitle => 'आपकी कुंडली में शिक्षा योग';

  @override
  String get edYogaBudhaAditya => 'बुध आदित्य';

  @override
  String get edYogaGajaKesari => 'गजकेसरी';

  @override
  String get edYogaSaraswati => 'सरस्वती';

  @override
  String get edYogaPresent => 'उपस्थित';

  @override
  String get edYogaAbsent => 'अनुपस्थित';

  @override
  String get edYogaNoneNote =>
      'कोई शास्त्रीय शिक्षा योग नहीं — सफलता निरंतर प्रयास और अनुशासन से आती है।';

  @override
  String get edVerificationTitle => 'विभिन्न कुंडलियों में पुष्टि';

  @override
  String get edD24Learning => 'D24 — गहन अध्ययन कुंडली';

  @override
  String get edD4Formal => 'D4 — औपचारिक शिक्षा कुंडली';

  @override
  String get edD9Dharma => 'D9 — अध्ययन धर्म कुंडली';

  @override
  String get edD60Karma => 'D60 — पूर्व-जन्म अध्ययन कर्म';

  @override
  String get edSubjectsTitle => 'आपके लिए सर्वश्रेष्ठ विषय';

  @override
  String get edSubjectsSubtitle => 'कुंडली अनुकूलता के अनुसार क्रमबद्ध';

  @override
  String get edLowAffinity => 'कम अनुकूलता वाले विषय';

  @override
  String get edDegreesTitle => 'डिग्री एवं स्तर संभावना';

  @override
  String get edExpectedLevel => 'अपेक्षित स्तर';

  @override
  String get edDegreeFormal => 'औपचारिक डिग्री';

  @override
  String get edDegreePostgrad => 'स्नातकोत्तर';

  @override
  String get edDegreeDoctorate => 'डॉक्टरेट';

  @override
  String get edDegreeForeign => 'विदेश शिक्षा';

  @override
  String get edTimelineTitle => 'अध्ययन समयरेखा';

  @override
  String get edEarlySchooling => 'प्रारंभिक शिक्षा अवधि';

  @override
  String get edHigherEducation => 'उच्च शिक्षा अवधि';

  @override
  String get edPostgradResearch => 'स्नातकोत्तर / शोध अवधि';

  @override
  String get edPeakLearningAge => 'सर्वोत्तम सीखने की आयु';

  @override
  String get edPreferencesTitle => 'सीखने की प्राथमिकताएं एवं सहयोग';

  @override
  String get edPrefStudyMode => 'अध्ययन का तरीका';

  @override
  String get edPrefTiming => 'सर्वोत्तम समय';

  @override
  String get edPrefEnvironment => 'वातावरण';

  @override
  String get edPrefLocation => 'स्थान';

  @override
  String get edPrefForeign => 'विदेश अध्ययन';

  @override
  String get edGuruRelationship => 'गुरु/शिक्षक संबंध';

  @override
  String get edMentorAvailability => 'मार्गदर्शक की उपलब्धता';

  @override
  String get edPeerLearning => 'सहपाठी शिक्षण';

  @override
  String get edAuthorityDeference => 'अधिकार के प्रति सम्मान';

  @override
  String get edStrengthsTitle => 'शक्तियां एवं चुनौतियां';

  @override
  String get edCognitiveGifts => 'संज्ञानात्मक वरदान';

  @override
  String get edNaturalAbilities => 'स्वाभाविक सीखने की क्षमताएं';

  @override
  String get edHiddenCapacities => 'छिपी हुई क्षमताएं';

  @override
  String get edConcentration => 'एकाग्रता में कठिनाई';

  @override
  String get edBreakRisk => 'शिक्षा में व्यवधान का जोखिम';

  @override
  String get edDisciplineConsistency => 'अनुशासन निरंतरता';

  @override
  String get edScholarshipLikelihood => 'छात्रवृत्ति की संभावना';

  @override
  String get edCareerLinkTitle => 'शिक्षा → करियर पथ';

  @override
  String get edDirectionRec => 'अनुशंसित दिशा';

  @override
  String get edIntegrationStrategy => 'एकीकरण रणनीति';

  @override
  String get edCareerLinkage => 'करियर संबंध';

  @override
  String get edAlignedSubjects => 'करियर-संगत विषय';

  @override
  String get edDegreeUtility => 'करियर के लिए डिग्री उपयोगिता';

  @override
  String get edImprovementTitle => 'आपकी सुधार योजना';

  @override
  String get edReliabilityTitle => 'भविष्यवाणी की विश्वसनीयता';

  @override
  String get edLayerD1 => 'जन्म कुंडली (D1)';

  @override
  String get edLayerD4 => 'औपचारिक शिक्षा (D4)';

  @override
  String get edLayerD9 => 'नवमांश (D9)';

  @override
  String get edLayerD24 => 'गहन अध्ययन (D24)';

  @override
  String get edLayerD60 => 'पूर्व-जन्म अध्ययन (D60)';

  @override
  String get edLayerAmk => 'विषय कारक';

  @override
  String get edLayerMj => 'बुध-गुरु';

  @override
  String get edLayerDasha => 'ग्रहीय समय';

  @override
  String get edTopicSubjects => 'मेरे लिए सर्वश्रेष्ठ विषय';

  @override
  String get edTopicDegree => 'डिग्री की संभावना';

  @override
  String get edTopicAbroad => 'विदेश में अध्ययन';

  @override
  String get edTopicExam => 'परीक्षा प्रदर्शन';

  @override
  String get edTopicHabits => 'अध्ययन की आदतें';

  @override
  String get edTopicCareerLink => 'शिक्षा-से-करियर संबंध';

  @override
  String get edTopicTiming => 'शिक्षा समय अवधि';

  @override
  String get edTopicScholarship => 'छात्रवृत्ति की संभावनाएं';

  @override
  String get hwTitle => 'स्वास्थ्य एवं कल्याण विश्लेषण';

  @override
  String get hwSubtitle => 'AI-संचालित वैदिक स्वास्थ्य एवं कल्याण रिपोर्ट';

  @override
  String get hwSnapshotHeader => 'आपकी स्वास्थ्य झलक';

  @override
  String get hwOverallVitality => 'जीवनशक्ति';

  @override
  String get hwImmunity => 'प्रतिरक्षा क्षमता';

  @override
  String get hwRecovery => 'रिकवरी';

  @override
  String get hwMentalWellness => 'मानसिक स्वास्थ्य';

  @override
  String get hwStressTolerance => 'तनाव सहनशक्ति';

  @override
  String get hwStatusThriving => 'उत्कृष्ट';

  @override
  String get hwStatusGood => 'अच्छी जीवनशक्ति';

  @override
  String get hwStatusBalanced => 'संतुलित';

  @override
  String get hwStatusNeedsCare => 'देखभाल आवश्यक';

  @override
  String get hwStatusNeedsAttention => 'ध्यान देने की आवश्यकता';

  @override
  String get hwChipImmunity => 'मजबूत प्रतिरक्षा';

  @override
  String get hwChipRecovery => 'तेज़ रिकवरी';

  @override
  String get hwChipMentalBalance => 'संतुलित मन';

  @override
  String get hwChipStressResilience => 'तनाव-सहनशील';

  @override
  String get hwChipFertility => 'प्रजनन क्षमता समर्थन';

  @override
  String get hwChipWorkLife => 'अच्छा कार्य-जीवन संतुलन';

  @override
  String get hwChipLowAddiction => 'कम व्यसन जोखिम';

  @override
  String get hwConstitutionTitle => 'आपकी शारीरिक प्रकृति';

  @override
  String get hwConstitutionSubtitle => 'आपकी कुंडली से आयुर्वेदिक प्रकृति';

  @override
  String get hwDominantDosha => 'प्रमुख';

  @override
  String get hwSecondaryDosha => 'द्वितीयक';

  @override
  String get hwPrimaryKaraka => 'मुख्य स्वास्थ्य संकेतक';

  @override
  String get hwStrongestSystem => 'सबसे मजबूत तंत्र';

  @override
  String get hwWeakestSystem => 'सहयोग की आवश्यकता वाला तंत्र';

  @override
  String get hwBodyMapTitle => 'आपके शरीर का ग्रह मानचित्र';

  @override
  String get hwBodyMapSubtitle => '9 ग्रह, 9 शरीर तंत्र';

  @override
  String get hwYogaTitle => 'आपकी कुंडली में स्वास्थ्य पैटर्न';

  @override
  String get hwYogaSubtitle => 'सुरक्षात्मक बनाम रोग-दबाव योग';

  @override
  String get hwDiseasePressureLabel => 'रोग दबाव';

  @override
  String get hwAreasTitle => 'ध्यान देने योग्य शरीर क्षेत्र';

  @override
  String get hwAreasSubtitle => 'शरीर क्षेत्र अनुसार संवेदनशीलता';

  @override
  String get hwProtectedAreas => 'सुरक्षित क्षेत्र';

  @override
  String get hwCategoriesTitle => 'रोग-श्रेणी निगरानी';

  @override
  String get hwCategoriesSubtitle =>
      'प्रमुख स्वास्थ्य श्रेणियों में संवेदनशीलता';

  @override
  String get hwLowRiskCategories => 'कम जोखिम वाली श्रेणियां';

  @override
  String get hwMentalTitle => 'मानसिक एवं भावनात्मक स्वास्थ्य';

  @override
  String get hwMentalSubtitle => 'भावनात्मक लचीलापन और सहयोग की जरूरतें';

  @override
  String get hwMentalVulnerability => 'भावनात्मक संवेदनशीलता';

  @override
  String get hwEmotionalRegulation => 'भावनात्मक नियंत्रण';

  @override
  String get hwSupportRec => 'सहयोग सुझाव';

  @override
  String get hwTendencies => 'मानसिक प्रवृत्तियां';

  @override
  String get hwTimelineTitle => 'स्वास्थ्य समयरेखा';

  @override
  String get hwTimelineSubtitle => 'उत्तम वर्ष, सतर्कता वर्ष और रिकवरी अवधि';

  @override
  String get hwPeakYears => 'सर्वोत्तम स्वास्थ्य वर्ष';

  @override
  String get hwCautionYears => 'सतर्कता वर्ष';

  @override
  String get hwRecoveryWindow => 'रिकवरी अवधि';

  @override
  String get hwCheckupYears => 'सुझाए गए जांच वर्ष';

  @override
  String get hwCurrentPhase => 'वर्तमान चरण';

  @override
  String get hwLifestyleTitle => 'आपकी जीवनशैली मार्गदर्शिका';

  @override
  String get hwLifestyleSubtitle =>
      'आपकी कुंडली दैनिक आदतों के बारे में क्या कहती है';

  @override
  String get hwSleepDiscipline => 'नींद अनुशासन प्रभाव';

  @override
  String get hwDietDiscipline => 'आहार अनुशासन प्रभाव';

  @override
  String get hwExerciseNeed => 'व्यायाम की आवश्यकता';

  @override
  String get hwSunlightNeed => 'धूप की आवश्यकता';

  @override
  String get hwStressSusceptibility => 'तनाव संवेदनशीलता';

  @override
  String get hwHydrationSensitivity => 'जलयोजन संवेदनशीलता';

  @override
  String get hwSocialType => 'सामाजिक ऊर्जा प्रकार';

  @override
  String get hwHealingSpeed => 'उपचार गति';

  @override
  String get hwTreatmentResponse => 'उपचार प्रतिक्रिया';

  @override
  String get hwAltHealing => 'वैकल्पिक चिकित्सा रुझान';

  @override
  String get hwSpecialTitle => 'जीवन-चरण एवं विशेष विषय';

  @override
  String get hwSpecialSubtitle =>
      'प्रजनन क्षमता, बचपन का स्वास्थ्य, आदतें और थकावट';

  @override
  String get hwFertility => 'प्रजनन क्षमता संकेतक';

  @override
  String get hwHormonalBalance => 'हार्मोनल संतुलन';

  @override
  String get hwReproductiveStrength => 'प्रजनन तंत्र की मजबूती';

  @override
  String get hwChildhoodVuln => 'बचपन स्वास्थ्य संवेदनशीलता';

  @override
  String get hwChildhoodStatus => 'बचपन का स्वास्थ्य';

  @override
  String get hwAddictionVuln => 'व्यसन संवेदनशीलता';

  @override
  String get hwAddictionRecovery => 'रिकवरी क्षमता';

  @override
  String get hwBurnoutVuln => 'थकावट संवेदनशीलता';

  @override
  String get hwWorkLifeBalance => 'कार्य-जीवन संतुलन';

  @override
  String get hwStressTriggers => 'तनाव के कारण';

  @override
  String get hwProtectiveFactors => 'सुरक्षात्मक कारक';

  @override
  String get hwChallengesTitle => 'ध्यान देने योग्य चुनौतियां';

  @override
  String get hwChallengesSubtitle => 'निवारक देखभाल पर कहां ध्यान दें';

  @override
  String get hwMitigation => 'कैसे प्रबंधित करें';

  @override
  String get hwChronicAreas => 'दीर्घकालिक संवेदनशील क्षेत्र';

  @override
  String get hwPreventivePriorities => 'निवारक प्राथमिकताएं';

  @override
  String get hwImprovementTitle => 'आपकी कल्याण योजना';

  @override
  String get hwImprovementSubtitle => 'व्यावहारिक कदम + पारंपरिक उपाय';

  @override
  String get hwReliabilityTitle => 'विश्वसनीयता स्तर';

  @override
  String get hwLayerD1 => 'जन्म कुंडली (D1)';

  @override
  String get hwLayerD6 => 'स्वास्थ्य कुंडली (D6)';

  @override
  String get hwLayerD30 => 'सूक्ष्म-स्वास्थ्य कुंडली (D30)';

  @override
  String get hwLayerDasha => 'ग्रह समय-चक्र';

  @override
  String get hwLayerTransit => 'वर्तमान गोचर';

  @override
  String get hwDisclaimerLabel => 'चिकित्सा अस्वीकरण';

  @override
  String get hwTopicImmunity => 'प्रतिरक्षा बढ़ाएं';

  @override
  String get hwTopicSleep => 'नींद एवं विश्राम';

  @override
  String get hwTopicStress => 'तनाव प्रबंधन';

  @override
  String get hwTopicFertility => 'प्रजनन समय';

  @override
  String get hwTopicDiet => 'आहार एवं पोषण';

  @override
  String get hwTopicTiming => 'स्वास्थ्य समय-अवधि';

  @override
  String get hwTopicMental => 'मानसिक स्वास्थ्य';

  @override
  String get hwTopicPrevention => 'निवारक देखभाल योजना';

  @override
  String get lvSubtitle => 'AI-संचालित वैदिक प्रेम रिपोर्ट';

  @override
  String get lvTitle => 'प्रेम और रिश्ते';

  @override
  String get lvLovePotential => 'प्रेम क्षमता';

  @override
  String get lvEmotionalAvail => 'भावनात्मक रूप से खुले';

  @override
  String get lvAttraction => 'आकर्षण';

  @override
  String get lvCommitment => 'प्रतिबद्धता';

  @override
  String get lvCommunication => 'संवाद';

  @override
  String get lvFidelity => 'वफादारी';

  @override
  String get lvChipLoyal => 'वफादार दिल';

  @override
  String get lvChipOpenHeart => 'खुले दिल वाले';

  @override
  String get lvChipCommunicator => 'बेहतरीन संवादक';

  @override
  String get lvChipMature => 'टकराव को अच्छे से संभालते हैं';

  @override
  String get lvChipEmotionallyWise => 'भावनात्मक रूप से समझदार';

  @override
  String get lvLoveStyle => 'आपकी प्रेम शैली';

  @override
  String get lvAttractionStyle => 'आकर्षण शैली';

  @override
  String get lvLangGiven => 'आप प्रेम कैसे व्यक्त करते हैं';

  @override
  String get lvLangReceived => 'आपको प्रेम कैसे महसूस होता है';

  @override
  String get lvLovePlanets => 'आपके प्रेम ग्रह';

  @override
  String get lvLoveKaraka => 'प्रेम';

  @override
  String get lvEmotionKaraka => 'भावना';

  @override
  String get lvPassionKaraka => 'जुनून';

  @override
  String get lvPathToLove => 'प्रेम की ओर आपका मार्ग';

  @override
  String get lvPathSub => 'प्रेम विवाह बनाम व्यवस्थित विवाह';

  @override
  String get lvLoveMarriage => 'प्रेम विवाह';

  @override
  String get lvArrangedMarriage => 'व्यवस्थित विवाह';

  @override
  String get lvParentalAccept => 'माता-पिता की स्वीकृति';

  @override
  String get lvInterCaste => 'अंतर-जाति / धर्म';

  @override
  String get lvIdealPartner => 'आपका आदर्श साथी';

  @override
  String get lvPersonality => 'व्यक्तित्व';

  @override
  String get lvAppearance => 'रूप-रंग';

  @override
  String get lvIdealTraits => 'आदर्श गुण';

  @override
  String get lvWhatMatters => 'सबसे ज़्यादा क्या मायने रखता है';

  @override
  String get lvDrawnTo => 'आकर्षित होते हैं';

  @override
  String get lvDealbreakers => 'रिश्ता तोड़ने वाली बातें';

  @override
  String get lvYourAppeal => 'आपका आकर्षण';

  @override
  String get lvLoveStory => 'आपकी प्रेम कहानी';

  @override
  String get lvLoveStorySub => 'रिश्तों के पैटर्न';

  @override
  String get lvFirstLove => 'पहला प्यार';

  @override
  String get lvRelationCount => 'महत्वपूर्ण रिश्ते';

  @override
  String get lvDuration => 'सामान्य अवधि';

  @override
  String get lvDepth => 'भावनात्मक गहराई';

  @override
  String get lvDatingPattern => 'डेटिंग पैटर्न';

  @override
  String get lvCommitIntimacy => 'प्रतिबद्धता और आत्मीयता';

  @override
  String get lvCommitReady => 'प्रतिबद्धता के लिए तत्परता';

  @override
  String get lvIntimacyDrive => 'आत्मीयता की चाहत';

  @override
  String get lvSensuality => 'कामुकता';

  @override
  String get lvEmpathy => 'सहानुभूति';

  @override
  String get lvCommitStyle => 'प्रतिबद्धता शैली';

  @override
  String get lvChemistry => 'केमिस्ट्री शैली';

  @override
  String get lvMakesCommit => 'आपको प्रतिबद्ध क्या बनाता है';

  @override
  String get lvMakesFlee => 'आपको दूर क्या धकेलता है';

  @override
  String get lvEmotional => 'भावनात्मक बुद्धिमत्ता';

  @override
  String get lvEmotionalIQ => 'भावनात्मक IQ';

  @override
  String get lvConflictStyle => 'टकराव शैली';

  @override
  String get lvTiming => 'प्रेम का समय';

  @override
  String get lvNewLove12 => '12 महीनों में नया प्रेम';

  @override
  String get lvEnergyNow => 'अभी की ऊर्जा';

  @override
  String get lvPhaseNow => 'अभी का चरण';

  @override
  String get lvPeakRomance => 'रोमांस के चरम वर्ष';

  @override
  String get lvNewLoveWindow => 'नए प्रेम की खिड़की';

  @override
  String get lvChallenges => 'ध्यान देने योग्य चुनौतियाँ';

  @override
  String get lvRiskHeartbreak => 'दिल टूटने की संभावना';

  @override
  String get lvRiskSabotage => 'आत्म-बाधा';

  @override
  String get lvRiskCommitFear => 'प्रतिबद्धता का डर';

  @override
  String get lvRiskRepeat => 'दोहराने वाले पैटर्न';

  @override
  String get lvRiskWorkaholic => 'प्रेम से ज़्यादा काम';

  @override
  String get lvRedFlags => 'ध्यान देने योग्य चेतावनी संकेत';

  @override
  String get lvHealing => 'क्या ठीक करना है';

  @override
  String get lvFocusArea => 'फोकस क्षेत्र';

  @override
  String get lvHealDir => 'उपचार की दिशा';

  @override
  String get lvImprovementPlan => 'सुधार योजना';

  @override
  String get lvReliability => 'भविष्यवाणी की विश्वसनीयता';

  @override
  String get lvLayerBirth => 'जन्म कुंडली (D1)';

  @override
  String get lvLayerNavamsa => 'नवांश (D9)';

  @override
  String get lvLayerSaptamsa => 'सप्तांश (D7)';

  @override
  String get lvLayerDasha => 'दशा समय';

  @override
  String get lvLayerTransit => 'वर्तमान गोचर';

  @override
  String get lvTopicWhen => 'मुझे प्रेम कब मिलेगा?';

  @override
  String get lvTopicSoulmate => 'मेरे सोलमेट के बारे में';

  @override
  String get lvTopicCurrent => 'मेरा वर्तमान रिश्ता';

  @override
  String get lvTopicHeal => 'अतीत से उपचार';

  @override
  String get lvTopicCommit => 'प्रतिबद्धता में मदद';

  @override
  String get lvTopicLoveVsArranged => 'प्रेम विवाह बनाम व्यवस्थित विवाह';

  @override
  String get lvTopicHeartbreak => 'दिल टूटने से बचना';

  @override
  String get lvTopicConfidence => 'प्रेम में आत्मविश्वास';

  @override
  String get mrSubtitle => 'AI-संचालित वैदिक विवाह रिपोर्ट';

  @override
  String get mrTitle => 'विवाह और परिवार';

  @override
  String get mrMarriagePotential => 'विवाह की संभावना';

  @override
  String get mrHarmony => 'सामंजस्य';

  @override
  String get mrLongevity => 'दीर्घायु';

  @override
  String get mrSatisfaction => 'संतुष्टि';

  @override
  String get mrStability => 'घर की स्थिरता';

  @override
  String get mrClarity => 'स्पष्टता';

  @override
  String get mrChipHarmony => 'सामंजस्यपूर्ण बंधन';

  @override
  String get mrChipNoMangal => 'कोई मंगल दोष नहीं';

  @override
  String get mrChipLongLasting => 'लंबे समय तक टिकने वाला';

  @override
  String get mrChipHome => 'अपना घर संभावित';

  @override
  String get mrChipInLaws => 'अच्छे ससुराल वाले';

  @override
  String get mrChipChildren => 'संतान का आशीर्वाद';

  @override
  String get mrSpouse => 'आपका भावी जीवनसाथी';

  @override
  String get mrSpouseSub => 'कुंडली क्या दर्शाती है';

  @override
  String get mrSpouseTraits => 'संभावित स्वभाव';

  @override
  String get mrSpouseWork => 'संभावित पेशा';

  @override
  String get mrAgeDiff => 'आयु अंतर';

  @override
  String get mrCulture => 'सांस्कृतिक मेल';

  @override
  String get mrEducation => 'शिक्षा';

  @override
  String get mrFamilyBg => 'पारिवारिक पृष्ठभूमि';

  @override
  String get mrSoulPartnership => 'आत्मा और साझेदारी';

  @override
  String get mrSelfPlanet => 'बंधन में आप';

  @override
  String get mrSpousePlanet => 'आपका जीवनसाथी ग्रह';

  @override
  String get mrSoulAlignment => 'आत्मिक तालमेल';

  @override
  String get mrAlignStrong =>
      'आपकी आत्मा और आपके आदर्श साथी में गहरा तालमेल है — एक संतोषजनक बंधन की पूरी संभावना है।';

  @override
  String get mrAlignModerate =>
      'आपकी आत्मा और आपके आदर्श साथी में मध्यम तालमेल है — सचेत प्रयास से संतोषजनक बंधन विकसित होगा।';

  @override
  String get mrAlignLow =>
      'आपकी आत्मा और साझेदारी को सचेत तालमेल की जरूरत है — ऐसा साथी चुनें जो वाकई आपके भीतरी मूल्यों से मेल खाता हो।';

  @override
  String get mrTechDarakaraka => 'जीवनसाथी ग्रह (दाराकारक)';

  @override
  String get mrUpapada => 'विवाह बिंदु (उपपद)';

  @override
  String get mrUpapadaLord => 'उपपद स्वामी';

  @override
  String get mrFoundation => 'विवाह की नींव';

  @override
  String get mrMarriageSign => 'विवाह राशि';

  @override
  String get mrMarriageLord => 'विवाह स्वामी';

  @override
  String get mrHouseStrength => 'भाव बल';

  @override
  String get mrPartnerHint => 'आपकी कुंडली से साथी का संकेत';

  @override
  String get mrHarmonyHdr => 'अनुकूलता सामंजस्य';

  @override
  String get mrHarmonySub => 'आप कैसे जुड़ेंगे';

  @override
  String get mrEmotional => 'भावनात्मक';

  @override
  String get mrIntellectual => 'बौद्धिक';

  @override
  String get mrPhysical => 'शारीरिक निकटता';

  @override
  String get mrFinancial => 'आर्थिक';

  @override
  String get mrCommunication => 'संवाद';

  @override
  String get mrSharedValues => 'साझा मूल्य';

  @override
  String get mrSpiritual => 'आध्यात्मिक';

  @override
  String get mrConflictRes => 'मतभेद समाधान';

  @override
  String get mrTiming => 'विवाह का समय';

  @override
  String get mrFirstMarriageAge => 'संभावित विवाह आयु';

  @override
  String get mrDelayChance => 'देरी की संभावना';

  @override
  String get mrMarriageWindow => 'विवाह अवधि';

  @override
  String get mrSecondaryWindow => 'वैकल्पिक अवधि';

  @override
  String get mrCurrentReadiness => 'अभी की स्थिति';

  @override
  String get mrJourney => 'विवाह यात्रा';

  @override
  String get mrJourneySub => 'बंधन कैसे विकसित होता है';

  @override
  String get mrPhaseEarly => 'शुरुआती वर्ष';

  @override
  String get mrPhaseMid => 'मध्य वर्ष';

  @override
  String get mrPhaseMature => 'परिपक्व वर्ष';

  @override
  String get mrPhaseLate => 'बाद के वर्ष';

  @override
  String get mrTip => 'सुझाव';

  @override
  String get mrFamilyHome => 'परिवार और घर';

  @override
  String get mrInLaws => 'ससुराल संबंध';

  @override
  String get mrFamilyHarmony => 'पारिवारिक सामंजस्य';

  @override
  String get mrHomeOwnership => 'घर का स्वामित्व';

  @override
  String get mrDomesticPeace => 'घरेलू शांति';

  @override
  String get mrFertility => 'प्रजनन क्षमता';

  @override
  String get mrParenting => 'पालन-पोषण में सामंजस्य';

  @override
  String get mrChildren => 'संतान';

  @override
  String get mrLikelyCount => 'संभावित संख्या';

  @override
  String get mrVerification => 'क्रॉस-चार्ट सत्यापन';

  @override
  String get mrD9 => 'विवाह कुंडली (D9)';

  @override
  String get mrD10 => 'करियर-जीवनसाथी कुंडली (D10)';

  @override
  String get mrD60 => 'कर्म कुंडली (D60)';

  @override
  String get mrChallenges => 'ध्यान देने योग्य चुनौतियाँ';

  @override
  String get mrMangalPresent =>
      'कुंडली में मंगल दोष मौजूद है — उपाय और मिलान को ध्यान से देखें।';

  @override
  String get mrMangalAbsent =>
      'कोई मंगल दोष नहीं पाया गया — यह विवाह के लिए एक शुभ संकेत है।';

  @override
  String get mrRiskConflict => 'मतभेद';

  @override
  String get mrRiskSeparation => 'अलगाव';

  @override
  String get mrRiskDistance => 'भावनात्मक दूरी';

  @override
  String get mrRiskInfidelity => 'बेवफाई';

  @override
  String get mrRiskFinance => 'धन संबंधी मतभेद';

  @override
  String get mrPartnerGuide => 'साथी मार्गदर्शिका';

  @override
  String get mrPartnerGuideSub => 'किस पर ध्यान दें';

  @override
  String get mrSeek => 'इन्हें देखें';

  @override
  String get mrMatchingPriorities => 'मिलान प्राथमिकताएँ';

  @override
  String get mrImprovementPlan => 'सुधार योजना';

  @override
  String get mrReliability => 'भविष्यवाणी की विश्वसनीयता';

  @override
  String get mrLayerBirth => 'जन्म कुंडली (D1)';

  @override
  String get mrLayerNavamsa => 'नवमांश (D9)';

  @override
  String get mrLayerDashamsa => 'दशमांश (D10)';

  @override
  String get mrLayerShashtiamsa => 'कर्म (D60)';

  @override
  String get mrLayerDarakaraka => 'जीवनसाथी ग्रह';

  @override
  String get mrTopicWhen => 'मेरा विवाह कब होगा?';

  @override
  String get mrTopicSpouse => 'मेरे जीवनसाथी के बारे में';

  @override
  String get mrTopicCompat => 'अनुकूलता सुझाव';

  @override
  String get mrTopicDelay => 'विवाह में देरी';

  @override
  String get mrTopicMangal => 'मंगल दोष';

  @override
  String get mrTopicChildren => 'संतान का समय';

  @override
  String get mrTopicInLaws => 'ससुराल संबंध';

  @override
  String get mrTopicHarmony => 'सामंजस्य बनाना';

  @override
  String get wlSubtitle => 'AI-संचालित वैदिक धन रिपोर्ट';

  @override
  String get wlTitle => 'धन एवं वित्त';

  @override
  String get wlWealthPotential => 'धन क्षमता';

  @override
  String get wlAccumulation => 'संचय';

  @override
  String get wlIncomeFlow => 'आय प्रवाह';

  @override
  String get wlRetention => 'प्रतिधारण';

  @override
  String get wlSustainability => 'स्थिरता';

  @override
  String get wlSavings => 'बचत अनुशासन';

  @override
  String get wlChipSaver => 'स्वाभाविक बचतकर्ता';

  @override
  String get wlChipMultiIncome => 'कई आय स्रोत';

  @override
  String get wlChipStrongYogas => 'धन योग';

  @override
  String get wlChipLowDebt => 'कम कर्ज';

  @override
  String get wlChipInheritance => 'विरासत संभावित';

  @override
  String get wlChipInvestor => 'समझदार निवेशक';

  @override
  String get wlWealthClass => 'धन वर्ग';

  @override
  String get wlWealthType => 'मुख्य धन प्रकार';

  @override
  String get wlPrimarySource => 'मुख्य आय';

  @override
  String get wlPeakAge => 'धन शिखर आयु';

  @override
  String get wlBoosters => 'आपके धन को क्या बढ़ा रहा है';

  @override
  String get wlBoostersSub => 'शक्तिशाली धन संयोजन';

  @override
  String get wlWealthImpact => 'बढ़ावा';

  @override
  String get wlDrains => 'धन हानि';

  @override
  String get wlIncomeSources => 'आय स्रोत';

  @override
  String get wlIncomeSourcesSub => 'आपका पैसा कहाँ से आता है';

  @override
  String get wlPrimary => 'मुख्य';

  @override
  String get wlInvestment => 'निवेश योजना';

  @override
  String get wlInvestmentSub => 'आदर्श परिसंपत्ति मिश्रण';

  @override
  String get wlRiskAppetite => 'जोखिम क्षमता';

  @override
  String get wlInvestStyle => 'निवेश शैली';

  @override
  String get wlDrivenBy => 'इससे प्रेरित';

  @override
  String get wlMoneyPersonality => 'धन व्यक्तित्व';

  @override
  String get wlMoneyType => 'धन प्रकार';

  @override
  String get wlSpending => 'खर्च';

  @override
  String get wlSavingsDiscipline => 'बचत अनुशासन';

  @override
  String get wlCharity => 'दान की प्रवृत्ति';

  @override
  String get wlLuxury => 'विलासिता खर्च';

  @override
  String get wlWindfalls => 'अप्रत्याशित लाभ और अवसर';

  @override
  String get wlWindfallsSub => 'भाग्य आधारित धन';

  @override
  String get wlInheritanceChance => 'विरासत';

  @override
  String get wlSuddenGains => 'अचानक लाभ';

  @override
  String get wlLottery => 'लॉटरी / सट्टा';

  @override
  String get wlInsurance => 'बीमा दावे';

  @override
  String get wlWindfallSource => 'संभावित अप्रत्याशित लाभ स्रोत';

  @override
  String get wlMoneyPlanets => 'आपके धन ग्रह';

  @override
  String get wlPrimaryKaraka => 'मुख्य धन ग्रह';

  @override
  String get wlSecondaryKaraka => 'द्वितीयक धन ग्रह';

  @override
  String get wlTimeline => 'धन समयरेखा';

  @override
  String get wlPeakYears => 'शिखर वर्ष';

  @override
  String get wlGoodPeriod => 'समृद्ध काल';

  @override
  String get wlSuddenGainWindow => 'अचानक लाभ की अवधि';

  @override
  String get wlToughPeriod => 'सावधानी काल';

  @override
  String get wlDebtRisks => 'कर्ज और धन जोखिम';

  @override
  String get wlDebtChance => 'कर्ज की संभावना';

  @override
  String get wlLoanBurden => 'ऋण भार';

  @override
  String get wlDrainSources => 'इनसे सावधान रहें';

  @override
  String get wlStrengthen => 'क्या मजबूत करें';

  @override
  String get wlWeakestDriver => 'सबसे कमजोर धन कारक';

  @override
  String get wlHowToFix => 'कैसे मजबूत करें';

  @override
  String get wlImprovementPlan => 'सुधार योजना';

  @override
  String get wlReliability => 'भविष्यवाणी विश्वसनीयता';

  @override
  String get wlLayerBirth => 'धन भाव (D1)';

  @override
  String get wlLayerHora => 'होरा चार्ट (D2)';

  @override
  String get wlLayerNavamsa => 'नवांश (D9)';

  @override
  String get wlLayerDasha => 'दशा समय';

  @override
  String get wlLayerTransit => 'वर्तमान गोचर';

  @override
  String get wlTopicGrow => 'धन कैसे बढ़ाएं';

  @override
  String get wlTopicInvest => 'कहाँ निवेश करें';

  @override
  String get wlTopicDebt => 'कर्ज प्रबंधन';

  @override
  String get wlTopicProperty => 'संपत्ति खरीदना';

  @override
  String get wlTopicRetire => 'सेवानिवृत्ति योजना';

  @override
  String get wlTopicPassive => 'निष्क्रिय आय';

  @override
  String get wlTopicWindfall => 'अचानक लाभ';

  @override
  String get wlTopicTiming => 'सर्वोत्तम धन समय';

  @override
  String get bzSubtitle => 'AI-संचालित वैदिक व्यवसाय रिपोर्ट';

  @override
  String get bzTitle => 'व्यवसाय और स्टार्टअप';

  @override
  String get bzBusinessPotential => 'व्यवसाय क्षमता';

  @override
  String get bzEntrepreneurship => 'उद्यमी';

  @override
  String get bzVenture => 'उद्यम सफलता';

  @override
  String get bzWealth => 'व्यवसाय से धन';

  @override
  String get bzRiskAppetite => 'जोखिम क्षमता';

  @override
  String get bzLongevity => 'दीर्घायु';

  @override
  String get bzChipWealthMagnet => 'धन आकर्षण';

  @override
  String get bzChipMoneyYoga => 'धन योग';

  @override
  String get bzChipLeadership => 'नेतृत्व';

  @override
  String get bzChipPartnerFit => 'बेहतरीन साझेदार मेल';

  @override
  String get bzChipGains => 'मजबूत लाभ';

  @override
  String get bzChipInvestor => 'निवेशक आकर्षण';

  @override
  String get bzChipFounder => 'संस्थापक सोच';

  @override
  String get bzWhatsWorking => 'आपके लिए क्या काम कर रहा है';

  @override
  String get bzWhatsWorkingSub => 'आपकी व्यावसायिक क्षमताएं';

  @override
  String get bzClassicYogas => 'पारंपरिक धन योग';

  @override
  String get bzFounderType => 'आपका संस्थापक प्रकार';

  @override
  String get bzSoulBusiness => 'आत्मा और व्यवसाय का उद्देश्य';

  @override
  String get bzSoulPlanet => 'आपकी आत्मा का ग्रह';

  @override
  String get bzBusinessPlanet => 'आपका व्यावसायिक मन';

  @override
  String get bzDirectionStrength => 'दिशा स्पष्टता';

  @override
  String get bzAlignStrong =>
      'आपका आत्म-उद्देश्य और व्यावसायिक दिशा एक-दूसरे से मजबूती से जुड़े हैं — उद्यम बनाना स्वाभाविक और संतोषजनक लगता है।';

  @override
  String get bzAlignModerate =>
      'आपका आत्म-उद्देश्य और व्यावसायिक दिशा मध्यम रूप से जुड़े हैं — उद्यम तब सबसे अच्छा काम करता है जब वह आपके गहरे मूल्यों को दर्शाए।';

  @override
  String get bzAlignLow =>
      'आपके आत्म-उद्देश्य और व्यावसायिक दिशा को सचेत रूप से जोड़ने की जरूरत है — ऐसा उद्यम चुनें जो सच में आपके व्यक्तित्व से मेल खाए।';

  @override
  String get bzTechAtmakaraka => 'आत्मा ग्रह (आत्मकारक)';

  @override
  String get bzTechAmatyakaraka => 'व्यवसाय ग्रह (अमात्यकारक)';

  @override
  String get bzTechDarakaraka => 'साझेदार ग्रह (दारकारक)';

  @override
  String get bzFoundation => 'व्यावसायिक नींव';

  @override
  String get bzCareerHouse => 'करियर भाव';

  @override
  String get bzGainsHouse => 'लाभ भाव';

  @override
  String get bzLord => 'स्वामी';

  @override
  String get bzGainsPotential => 'लाभ क्षमता';

  @override
  String get bzNetwork => 'नेटवर्क शक्ति';

  @override
  String get bzRecovery => 'पुनर्प्राप्ति शक्ति';

  @override
  String get bzVerification => 'क्रॉस-चार्ट सत्यापन';

  @override
  String get bzD10 => 'करियर चार्ट (D10)';

  @override
  String get bzD11 => 'लाभ चार्ट (D11)';

  @override
  String get bzD9 => 'उद्देश्य चार्ट (D9)';

  @override
  String get bzD60 => 'कर्म चार्ट (D60)';

  @override
  String get bzFounderSkills => 'संस्थापक कौशल';

  @override
  String get bzSkillStrategy => 'रणनीतिक सोच';

  @override
  String get bzSkillExecution => 'क्रियान्वयन';

  @override
  String get bzSkillPeople => 'लोगों का प्रबंधन';

  @override
  String get bzSkillSales => 'बिक्री और समझाने की कला';

  @override
  String get bzSkillFinance => 'वित्तीय समझ';

  @override
  String get bzSkillOps => 'परिचालन अनुशासन';

  @override
  String get bzTopSkill => 'सबसे बड़ा कौशल';

  @override
  String get bzDomains => 'सर्वश्रेष्ठ व्यावसायिक क्षेत्र';

  @override
  String get bzDomainsSub => 'स्वाभाविक मेल के अनुसार क्रम में';

  @override
  String get bzFit => 'मेल';

  @override
  String get bzBusinessStyleHdr => 'व्यावसायिक शैली';

  @override
  String get bzStyleService => 'उत्पाद बनाम सेवा';

  @override
  String get bzStyleMarket => 'बाज़ार केंद्रित';

  @override
  String get bzStyleTech => 'तकनीकी दृष्टिकोण';

  @override
  String get bzStyleLeadership => 'नेतृत्व शैली';

  @override
  String get bzStylePartnership => 'अकेले या साझेदारी में';

  @override
  String get bzWhereBuild => 'पहुंच';

  @override
  String get bzExpansion => 'विस्तार';

  @override
  String get bzSetup => 'सेटअप';

  @override
  String get bzPartnership => 'साझेदारी और टीम';

  @override
  String get bzIdealCofounder => 'आदर्श सह-संस्थापक';

  @override
  String get bzPartnerViability => 'साझेदारी मेल';

  @override
  String get bzTeamBuilding => 'टीम निर्माण';

  @override
  String get bzCofounderFit => 'सह-संस्थापक मेल';

  @override
  String get bzAdvisorNetwork => 'सलाहकार नेटवर्क';

  @override
  String get bzFunding => 'फंडिंग और धन';

  @override
  String get bzRecommendedPath => 'अनुशंसित फंडिंग मार्ग';

  @override
  String get bzInvestorAttract => 'निवेशक आकर्षण';

  @override
  String get bzFamilyBacking => 'पारिवारिक समर्थन';

  @override
  String get bzHybridViability => 'नौकरी + व्यवसाय मिश्रण';

  @override
  String get bzFallback => 'बैकअप के रूप में नौकरी';

  @override
  String get bzDebtStyle => 'ऋण शैली';

  @override
  String get bzTimeline => 'व्यावसायिक समयरेखा';

  @override
  String get bzCurrentPhase => 'अभी की स्थिति';

  @override
  String get bzLaunchWindow => 'शुरुआत का समय';

  @override
  String get bzScaleWindow => 'विकास का समय';

  @override
  String get bzPeakAge => 'शीर्ष वर्ष';

  @override
  String get bzChallenges => 'ध्यान देने योग्य चुनौतियां';

  @override
  String get bzRiskFinancial => 'वित्तीय नुकसान';

  @override
  String get bzRiskBurnout => 'थकावट';

  @override
  String get bzRiskTeam => 'टीम में टकराव';

  @override
  String get bzRiskLegal => 'कानूनी / नियामक';

  @override
  String get bzFinancialExp =>
      'अधिक निवेश या खराब नकदी-प्रवाह के समय के कारण उद्यम में धन हानि का जोखिम।';

  @override
  String get bzFinancialFix =>
      'नकद भंडार रखें, छोटे स्तर पर शुरुआत करें, और खर्च बढ़ाने से पहले मांग को परखें।';

  @override
  String get bzBurnoutExp =>
      'बहुत लंबे समय तक बहुत अधिक मेहनत करने से आपकी ऊर्जा और ध्यान कम हो सकता है।';

  @override
  String get bzBurnoutFix =>
      'आराम को प्राथमिकता दें, जल्दी काम सौंपें, और बड़े प्रयासों को अनुकूल समय के आसपास व्यवस्थित करें।';

  @override
  String get bzTeamExp =>
      'सह-संस्थापकों या कर्मचारियों के साथ मतभेद व्यवसाय को धीमा कर सकते हैं।';

  @override
  String get bzTeamFix =>
      'लिखित रूप में स्पष्ट भूमिकाएं और अपेक्षाएं तय करें, और अक्सर बातचीत करें।';

  @override
  String get bzLegalExp =>
      'अनुपालन, अनुबंध या नियामक मुद्दे बाधाएं पैदा कर सकते हैं।';

  @override
  String get bzLegalFix =>
      'अनुबंधों की समीक्षा करवाएं, कागजी कार्रवाई साफ रखें, और शुरुआत में ही पेशेवरों से सलाह लें।';

  @override
  String get bzImprovementPlan => 'सुधार योजना';

  @override
  String get bzBestDirection => 'सर्वश्रेष्ठ दिशा';

  @override
  String get bzStrategy => 'निर्माण रणनीति';

  @override
  String get bzTopFields => 'शीर्ष क्षेत्र';

  @override
  String get bzEmploymentPath => 'नौकरी बनाम व्यवसाय';

  @override
  String get bzRoadmap => 'विकास रोडमैप';

  @override
  String get bzRoadmapSub => 'आपकी उद्यम योजना';

  @override
  String get bzReliability => 'भविष्यवाणी विश्वसनीयता';

  @override
  String get bzLayerBirth => 'जन्म कुंडली (D1)';

  @override
  String get bzLayerNavamsa => 'नवमांश (D9)';

  @override
  String get bzLayerDashamsa => 'करियर (D10)';

  @override
  String get bzLayerLabhamsa => 'लाभ (D11)';

  @override
  String get bzLayerShashtiamsa => 'कर्म (D60)';

  @override
  String get bzTopicStart => 'क्या मुझे अभी शुरू करना चाहिए?';

  @override
  String get bzTopicIdea => 'सर्वश्रेष्ठ व्यावसायिक विचार';

  @override
  String get bzTopicPartner => 'सह-संस्थापक ढूंढना';

  @override
  String get bzTopicFunding => 'इसे कैसे फंड करें';

  @override
  String get bzTopicScale => 'कब बढ़ाएं';

  @override
  String get bzTopicRisk => 'जोखिमों का प्रबंधन';

  @override
  String get bzTopicJob => 'नौकरी बनाम व्यवसाय';

  @override
  String get bzTopicTiming => 'सर्वश्रेष्ठ समय';

  @override
  String get crTitle => 'करियर और जॉब विश्लेषण';

  @override
  String get crSubtitle => 'AI-संचालित वैदिक करियर रिपोर्ट';

  @override
  String get crCrumbHome => 'होम';

  @override
  String get crCrumbReports => 'रिपोर्ट्स';

  @override
  String get crCareerPotential => 'करियर क्षमता';

  @override
  String get crStatusStrong => 'मजबूत क्षमता';

  @override
  String get crStatusGood => 'अच्छी क्षमता';

  @override
  String get crStatusModerate => 'मध्यम क्षमता';

  @override
  String get crStatusDeveloping => 'विकासशील क्षमता';

  @override
  String get crStatusChallenging => 'चुनौतीपूर्ण चरण';

  @override
  String get crOverallCareer => 'समग्र करियर';

  @override
  String get crStability => 'करियर स्थिरता';

  @override
  String get crGrowth => 'विकास क्षमता';

  @override
  String get crRecognition => 'पहचान';

  @override
  String get crSatisfaction => 'संतुष्टि';

  @override
  String get crChipLeadership => 'नेतृत्व';

  @override
  String get crChipCreativity => 'रचनात्मकता';

  @override
  String get crChipBusiness => 'व्यवसाय';

  @override
  String get crChipStableIncome => 'स्थिर आय';

  @override
  String get crChipLearning => 'सीखना';

  @override
  String get crChipGrowth => 'दीर्घकालिक विकास';

  @override
  String get crChipTechnical => 'तकनीकी कौशल';

  @override
  String get crChipRecognition => 'पहचान';

  @override
  String get crTopInsights => 'मुख्य जानकारियां';

  @override
  String get crWhatDefines => 'आपके करियर को क्या परिभाषित करता है?';

  @override
  String get crSoulCareer => 'आत्मा और करियर का उद्देश्य';

  @override
  String get crSoulPlanet => 'आत्म-उद्देश्य ग्रह';

  @override
  String get crCareerPlanet => 'करियर ग्रह';

  @override
  String get crMeaning => 'अर्थ';

  @override
  String get crAlignment => 'आत्मा ↔ करियर तालमेल';

  @override
  String get crAlignStrong =>
      'आपकी स्वाभाविक रुचियां और करियर पथ मजबूती से जुड़े हुए हैं।';

  @override
  String get crAlignModerate =>
      'आपकी स्वाभाविक रुचियां और करियर पथ मध्यम रूप से जुड़े हुए हैं।';

  @override
  String get crAlignLow =>
      'आपकी स्वाभाविक रुचियों और करियर पथ को सचेत रूप से जोड़ने की जरूरत है।';

  @override
  String get crTechAtmakaraka => 'आत्मकारक (आत्मा सूचक)';

  @override
  String get crTechAmatyakaraka => 'अमात्यकारक (करियर सूचक)';

  @override
  String get crDegrees => 'अंश';

  @override
  String get crDignity => 'गरिमा';

  @override
  String get crFoundation => 'करियर की नींव';

  @override
  String get crCareerSign => 'करियर राशि';

  @override
  String get crCareerLord => 'करियर स्वामी';

  @override
  String get crLordPosition => 'स्वामी की स्थिति';

  @override
  String get crCareerStrength => 'करियर बल';

  @override
  String get crProfStyle => 'व्यावसायिक शैली';

  @override
  String get crBestFields => 'सर्वश्रेष्ठ क्षेत्र';

  @override
  String get crTechnicalDetails => 'तकनीकी विवरण';

  @override
  String get crHouseLabel => 'भाव';

  @override
  String get crVerification => 'विभिन्न चार्ट्स में करियर सत्यापन';

  @override
  String get crD10Career => 'D10 · करियर';

  @override
  String get crD9Purpose => 'D9 · उद्देश्य';

  @override
  String get crD60Karma => 'D60 · कर्म';

  @override
  String get crStatusNeedsImprovement => 'सुधार की जरूरत';

  @override
  String get crStatusWellAligned => 'अच्छी तरह संरेखित';

  @override
  String get crStatusStrongSupport => 'मजबूत समर्थन';

  @override
  String get crStatusModerateSupport => 'मध्यम समर्थन';

  @override
  String get crChartDetails => 'तकनीकी चार्ट विवरण';

  @override
  String get crPersonality => 'आपका करियर व्यक्तित्व';

  @override
  String get crGrowthAreas => 'विकास क्षेत्र';

  @override
  String get crBestRoles => 'सर्वश्रेष्ठ भूमिकाएं';

  @override
  String get crBestIndustries => 'सर्वश्रेष्ठ उद्योग';

  @override
  String get crEnvironment => 'करियर वातावरण';

  @override
  String get crWorkStyle => 'सर्वश्रेष्ठ कार्यशैली';

  @override
  String get crEmployment => 'नौकरी';

  @override
  String get crBusiness => 'व्यवसाय';

  @override
  String get crFreelance => 'फ्रीलांस / परामर्श';

  @override
  String get crPortfolio => 'मिश्रित पोर्टफोलियो';

  @override
  String get crLeadership => 'नेतृत्व';

  @override
  String get crFit => 'उपयुक्तता';

  @override
  String get crBestFit => 'सर्वश्रेष्ठ उपयुक्तता';

  @override
  String get crTimeline => 'करियर समयरेखा';

  @override
  String get crPastPeak => 'पिछला शिखर';

  @override
  String get crPresentPhase => 'वर्तमान चरण';

  @override
  String get crUpcoming => 'आगामी अवसर';

  @override
  String get crFutureExpansion => 'भविष्य का विस्तार';

  @override
  String get crRiskPeriod => 'जोखिम अवधि';

  @override
  String get crViewDasha => 'ग्रह दशा (तकनीकी)';

  @override
  String get crChallenges => 'ध्यान देने योग्य चुनौतियां';

  @override
  String get crRiskBurnout => 'थकावट';

  @override
  String get crRiskRecognition => 'पहचान में देरी';

  @override
  String get crRiskConflict => 'कार्यस्थल संघर्ष';

  @override
  String get crRiskFinancial => 'आर्थिक अस्थिरता';

  @override
  String get crRiskOverqual => 'क्षमता का कम उपयोग';

  @override
  String get crPrevention => 'बचाव';

  @override
  String get crBurnoutExp =>
      'लंबे, कठिन चरण समय के साथ आपकी ऊर्जा को खत्म कर सकते हैं।';

  @override
  String get crBurnoutFix =>
      'आराम को प्राथमिकता दें, सीमाएं तय करें और बड़े प्रयासों की गति संतुलित रखें।';

  @override
  String get crRecognitionExp =>
      'इनाम और पहचान आपकी मेहनत की तुलना में धीरे मिल सकते हैं।';

  @override
  String get crRecognitionFix =>
      'अपनी उपलब्धियों को दर्ज करें और अपने योगदान को वरिष्ठों के सामने स्पष्ट रूप से रखें।';

  @override
  String get crConflictExp =>
      'सहकर्मियों या वरिष्ठों के साथ कभी-कभी टकराव हो सकता है।';

  @override
  String get crConflictFix =>
      'शांति से बातचीत करें और समझदारी से अपनी लड़ाइयां चुनें।';

  @override
  String get crFinancialExp => 'कुछ चरणों के दौरान आय असमान महसूस हो सकती है।';

  @override
  String get crFinancialFix =>
      'एक बचत राशि रखें और आर्थिक रूप से अधिक प्रतिबद्धता से बचें।';

  @override
  String get crOverqualExp =>
      'कभी-कभी आपको लग सकता है कि आपकी क्षमता का पूरा उपयोग नहीं हो रहा।';

  @override
  String get crOverqualFix =>
      'चुनौतीपूर्ण भूमिकाएं तलाशें और जुड़ाव बनाए रखने के लिए सीखते रहें।';

  @override
  String get crImprovementPlan => 'करियर सुधार योजना';

  @override
  String get crCatPlanetary => 'ग्रहीय और आध्यात्मिक';

  @override
  String get crCatPractical => 'व्यावहारिक कदम';

  @override
  String get crTraditionalExplain => 'पारंपरिक ज्योतिष व्याख्या';

  @override
  String get crActionPlan => '30-दिन की करियर कार्य योजना';

  @override
  String get crWeek1 => 'सप्ताह 1 · प्रोफाइल अनुकूलन';

  @override
  String get crWeek2 => 'सप्ताह 2 · कौशल निर्माण';

  @override
  String get crWeek3 => 'सप्ताह 3 · नेटवर्किंग';

  @override
  String get crWeek4 => 'सप्ताह 4 · करियर दृश्यता';

  @override
  String get crWeek1Tip =>
      'अपने सबसे मजबूत करियर विषय के अनुसार अपना रिज़्यूमे और लिंक्डइन अपडेट करें।';

  @override
  String get crWeek2Tip =>
      'अपने सर्वश्रेष्ठ क्षेत्र में एक उच्च-मूल्य कौशल चुनें और रोज़ अभ्यास करें।';

  @override
  String get crWeek3Tip =>
      'अपने मेंटर्स से दोबारा जुड़ें और उद्योग के दो नए संपर्कों से बात करें।';

  @override
  String get crWeek4Tip =>
      'अपना काम सार्वजनिक रूप से साझा करें और किसी दिखने वाले प्रोजेक्ट के लिए स्वेच्छा से आगे आएं।';

  @override
  String get crPriority => 'प्राथमिकता';

  @override
  String get crTimeRequired => 'समय';

  @override
  String get crExpectedBenefit => 'लाभ';

  @override
  String get crPriorityHigh => 'उच्च';

  @override
  String get crPriorityMedium => 'मध्यम';

  @override
  String get crRoadmap => 'AI करियर रोडमैप';

  @override
  String get crNext12 => 'अगले 12 महीने';

  @override
  String get crBestFocus => 'सर्वश्रेष्ठ फोकस';

  @override
  String get crSkillsLearn => 'सीखने योग्य कौशल';

  @override
  String get crIndustriesTarget => 'लक्षित उद्योग';

  @override
  String get crExpectedOutcome => 'अपेक्षित परिणाम';

  @override
  String get crReliability => 'भविष्यवाणी विश्वसनीयता';

  @override
  String get crReliabilityHigh => 'उच्च विश्वसनीयता';

  @override
  String get crReliabilityGood => 'अच्छी विश्वसनीयता';

  @override
  String get crReliabilityModerate => 'मध्यम विश्वसनीयता';

  @override
  String get crReliabilityExplain =>
      'यह रिपोर्ट आपकी जन्म कुंडली, विभाजित चार्ट्स और जैमिनी संकेतकों को जोड़ती है। स्कोर दर्शाता है कि ये चार्ट परतें कितनी मजबूती से आपस में मेल खाती हैं।';

  @override
  String get crChartLayers => 'चार्ट परतें और भार';

  @override
  String get crBirthChart => 'जन्म कुंडली (D1)';

  @override
  String get crNavamsa => 'नवमांश (D9)';

  @override
  String get crDashamsa => 'दशमांश (D10)';

  @override
  String get crShashtiamsa => 'षष्ठ्यंश (D60)';

  @override
  String get crDiscussAi => 'AI से चर्चा करें';

  @override
  String get crAskAbout => 'इस बारे में पूछें';

  @override
  String get crTopicChange => 'करियर बदलाव';

  @override
  String get crTopicGovt => 'सरकारी नौकरी';

  @override
  String get crTopicBusiness => 'व्यवसाय';

  @override
  String get crTopicPromotion => 'पदोन्नति';

  @override
  String get crTopicMarriage => 'विवाह बनाम करियर';

  @override
  String get crTopicAbroad => 'विदेश';

  @override
  String get crTopicIncome => 'आय';

  @override
  String get crTopicPurpose => 'उद्देश्य';

  @override
  String get crTopicResume => 'रिज़्यूमे';

  @override
  String get crTopicCopied =>
      'प्रश्न कॉपी हो गया — इसे अपनी AI चैट में पेस्ट करें।';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return '$soul आपकी आंतरिक पुकार को दिशा देता है, जबकि $career आपके बाहरी पेशे को आकार देता है।';
  }

  @override
  String get rzTodayOutlook => 'आज का राशि विश्लेषण';

  @override
  String get rzPlanetaryEnergy => 'आज की ग्रह ऊर्जा';

  @override
  String get rzBestSign => 'सर्वश्रेष्ठ राशि';

  @override
  String get rzChallengingSign => 'सबसे चुनौतीपूर्ण';

  @override
  String get rzDominantPlanet => 'प्रभावी ग्रह';

  @override
  String get rzOverallMood => 'समग्र मनोदशा';

  @override
  String get rzMoodBright => 'उज्ज्वल और सक्रिय';

  @override
  String get rzMoodCalm => 'शांत और स्थिर';

  @override
  String get rzMoodMixed => 'मिश्रित ऊर्जा';

  @override
  String get rzMoodTense => 'तनावपूर्ण और सतर्क';

  @override
  String get rzTodayEnergy => 'आज की ऊर्जा';

  @override
  String get rzCaution => 'सावधानी';

  @override
  String get rzWeak => 'कमज़ोर';

  @override
  String get rzAllSigns => 'सभी राशियाँ';

  @override
  String get rzAiSummary => 'AI सारांश';

  @override
  String get rzPlanetaryInfluence => 'आज का ग्रह प्रभाव';

  @override
  String get rzStrongInfluences => 'प्रबल प्रभाव';

  @override
  String get rzShowTechnical => 'तकनीकी विवरण देखें';

  @override
  String get rzOpportunities => 'आज के अवसर';

  @override
  String get rzAvoidTitle => 'आज इनसे बचें';

  @override
  String get rzTechnicalReason => 'तकनीकी कारण';

  @override
  String get rzAvoidDecisions => 'महत्वपूर्ण फैसलों में जल्दबाज़ी';

  @override
  String get rzAvoidArguments => 'तीखी बहस';

  @override
  String get rzAvoidInvestments => 'बड़ा निवेश';

  @override
  String get rzAvoidOverthink => 'छोटी बातों पर अधिक सोचना';

  @override
  String get rzAvoidOverspend => 'अनावश्यक खर्च';

  @override
  String get rzAvoidStress => 'तनाव और अधिक काम';

  @override
  String get rzPlanetaryChart => 'आज की ग्रह कुंडली';

  @override
  String get rzWhatChartMeans => 'इस चार्ट का मतलब';

  @override
  String get rzChartExplain =>
      'यह डायमंड आकृति दिखाती है कि आज आकाश में हर ग्रह कहाँ स्थित है, आपकी राशि के अनुसार। सहायक भावों में स्थित ग्रह दिन को बेहतर बनाते हैं; कठिन भावों में स्थित ग्रहों के लिए सावधानी ज़रूरी है।';

  @override
  String get rzDoNetworking => 'नेटवर्किंग और जुड़ाव';

  @override
  String get rzDoLearning => 'कुछ नया सीखना';

  @override
  String get rzDoMeditation => 'ध्यान और शांति';

  @override
  String get rzDoFamily => 'परिवार के साथ समय';

  @override
  String get rzDoCreative => 'रचनात्मक कार्य';

  @override
  String get rzDoRest => 'आराम और स्व-देखभाल';

  @override
  String get rzAiRecommendations => 'आज की AI सिफारिशें';

  @override
  String get rzTechnical => 'तकनीकी ज्योतिष';

  @override
  String get rzTransitScore => 'गोचर स्कोर';

  @override
  String get rzVedha => 'वेध (बाधाएँ)';

  @override
  String get rzGocharDetails => 'गोचर विवरण';

  @override
  String get rzAdvancedOnly => 'उन्नत उपयोगकर्ताओं के लिए';

  @override
  String get rzTomorrow => 'कल की झलक';

  @override
  String get rzTomorrowEnergy => 'कल की ऊर्जा';

  @override
  String get rzImproving => 'सुधर रही है';

  @override
  String get rzWeaker => 'थोड़ी कमज़ोर';

  @override
  String get rzSteady => 'स्थिर';

  @override
  String get rzTomorrowUpLine =>
      'कल ऊर्जा बढ़ने की उम्मीद है — महत्वपूर्ण कार्यों की पहले से योजना बनाएं।';

  @override
  String get rzTomorrowDownLine =>
      'कल ऊर्जा थोड़ी कम हो सकती है — दिन को हल्का और सहज रखें।';

  @override
  String get rzTomorrowFlatLine =>
      'कल ऊर्जा स्थिर रहेगी — आगे एक शांत, संतुलित दिन है।';

  @override
  String get rzWeeklyTrend => 'साप्ताहिक रुझान';

  @override
  String get rzMonthlyTrend => 'मासिक रुझान';

  @override
  String get rzBestDayWeek => 'सर्वश्रेष्ठ दिन';

  @override
  String get rzHardestDay => 'सबसे कठिन दिन';

  @override
  String get rzLuckyToday => 'आज भाग्यशाली';

  @override
  String get rzKarakaSun => 'आत्मविश्वास और जीवनशक्ति';

  @override
  String get rzKarakaMoon => 'भावनाएँ और मानसिक शांति';

  @override
  String get rzKarakaMars => 'ऊर्जा और उत्साह';

  @override
  String get rzKarakaMercury => 'संवाद और सीखना';

  @override
  String get rzKarakaJupiter => 'ज्ञान और विकास';

  @override
  String get rzKarakaVenus => 'रिश्ते और सुख-सुविधा';

  @override
  String get rzKarakaSaturn => 'अनुशासन और धैर्य';

  @override
  String get rzKarakaRahu => 'महत्वाकांक्षा और बदलाव';

  @override
  String get rzKarakaKetu => 'आध्यात्मिकता और मोह-त्याग';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '$dom दिन का माहौल तय करता है, जबकि $chal को धैर्य और सावधानी की ज़रूरत है।';
  }

  @override
  String rzInsightGood(Object karaka) {
    return '$karaka के लिए अच्छा दिन है।';
  }

  @override
  String rzInsightHard(Object karaka) {
    return 'आज $karaka के मामले में धीरे चलें।';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return 'आज $karaka को अच्छा समर्थन मिल रहा है।';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return 'आज $karaka में देरी हो सकती है।';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return 'आज $strong के लिए सहायक है, जबकि $weak को धैर्य और देखभाल चाहिए।';
  }

  @override
  String get fdEnergyScore => 'आज का ऊर्जा स्कोर';

  @override
  String get fdStatusAverage => 'औसत';

  @override
  String get fdStatusMixed => 'मिश्रित';

  @override
  String get fdStatusChallenging => 'चुनौतीपूर्ण';

  @override
  String get fdTheme => 'आज की थीम';

  @override
  String get fdExplainToday => 'आज को समझें';

  @override
  String get fdTodaysFocus => 'आज का फोकस';

  @override
  String get fdTopRecommendation => 'मुख्य सुझाव';

  @override
  String get fdTopCaution => 'मुख्य सावधानी';

  @override
  String get fdReadingTime => 'पढ़ने का समय';

  @override
  String get fdSeconds30 => '30 सेकंड';

  @override
  String get fdCareer => 'करियर';

  @override
  String get fdMoney => 'धन';

  @override
  String get fdLove => 'प्रेम';

  @override
  String get fdHealth => 'स्वास्थ्य';

  @override
  String get fdTravel => 'यात्रा';

  @override
  String get fdFamily => 'परिवार';

  @override
  String get fdBestToDo => 'आज करने योग्य सबसे अच्छे काम';

  @override
  String get fdAvoidToday => 'आज इनसे बचें';

  @override
  String get fdConfidenceLabel => 'विश्वास स्तर';

  @override
  String get fdBestTime => 'सर्वश्रेष्ठ समय';

  @override
  String get fdRecommended => 'अनुशंसित';

  @override
  String get fdReason => 'कारण';

  @override
  String get fdRisk => 'जोखिम';

  @override
  String get fdRecommendation => 'सुझाव';

  @override
  String get fdNoActions =>
      'आज कुछ खास करने की जरूरत नहीं — स्थिर और शांत दिनचर्या बनाए रखें।';

  @override
  String get fdNoCautions =>
      'आज कोई बड़ी सावधानी नहीं — सामान्य सजगता के साथ आगे बढ़ें।';

  @override
  String get fdHighlights => 'आज की मुख्य बातें';

  @override
  String get fdProbVeryHigh => 'बहुत अधिक';

  @override
  String get fdProbHigh => 'अधिक';

  @override
  String get fdProbElevated => 'बढ़ा हुआ';

  @override
  String get fdProbCaution => 'सावधानी';

  @override
  String get fdWhatToDo => 'क्या करें';

  @override
  String get fdLifeAreas => 'जीवन के क्षेत्र';

  @override
  String get fdTapDetails => 'विवरण के लिए टैप करें';

  @override
  String get fdArea1 => 'स्वयं और स्वास्थ्य';

  @override
  String get fdArea2 => 'धन और परिवार';

  @override
  String get fdArea3 => 'संवाद';

  @override
  String get fdArea4 => 'घर और आराम';

  @override
  String get fdArea5 => 'रचनात्मकता और प्रेम';

  @override
  String get fdArea6 => 'काम और जिम्मेदारियाँ';

  @override
  String get fdArea7 => 'रिश्ते';

  @override
  String get fdArea8 => 'बदलाव और गहराई';

  @override
  String get fdArea9 => 'भाग्य और यात्रा';

  @override
  String get fdArea10 => 'करियर और प्रतिष्ठा';

  @override
  String get fdArea11 => 'लाभ और नेटवर्क';

  @override
  String get fdArea12 => 'विश्राम और आध्यात्मिकता';

  @override
  String get fdTodaysMeaning => 'आज का अर्थ';

  @override
  String get fdGoodFor => 'इसके लिए अच्छा';

  @override
  String get fdAvoid => 'बचें';

  @override
  String get fdPlanetSupport => 'ग्रह सहयोग';

  @override
  String get fdWhyPrediction => 'यह भविष्यवाणी क्यों?';

  @override
  String get fdAdvancedDetails => 'विस्तृत जानकारी';

  @override
  String get fdAiRecommendation => 'AI सुझाव';

  @override
  String get fdOverallStatus => 'समग्र स्थिति';

  @override
  String get fdNoPlanetTransit =>
      'आज कोई प्रमुख ग्रह इस क्षेत्र में गोचर नहीं कर रहा है।';

  @override
  String get fdFinancialOutlook => 'वित्तीय दृष्टिकोण';

  @override
  String get fdIncomeProbability => 'आय की संभावना';

  @override
  String get fdExpenseProbability => 'खर्च की संभावना';

  @override
  String get fdNetBalance => 'कुल वित्तीय संतुलन';

  @override
  String get fdAvoidSpending => 'खर्च से बचें';

  @override
  String get fdRelationshipOutlook => 'रिश्तों का दृष्टिकोण';

  @override
  String get fdOverallScore => 'समग्र स्कोर';

  @override
  String get fdPartner => 'साथी';

  @override
  String get fdRomance => 'रोमांस';

  @override
  String get fdWorkplace => 'कार्यस्थल';

  @override
  String get fdPublicImage => 'सार्वजनिक छवि';

  @override
  String get fdBestActivity => 'सर्वश्रेष्ठ गतिविधि';

  @override
  String get fdWeakArea => 'कमजोर क्षेत्र';

  @override
  String get fdBiggestOpportunity => 'सबसे बड़ा अवसर';

  @override
  String get fdBiggestRisk => 'सबसे बड़ा जोखिम';

  @override
  String get fdProbability => 'संभावना';

  @override
  String get fdProtection => 'सुरक्षा सलाह';

  @override
  String get fdDescription => 'विवरण';

  @override
  String get fdBestTimeToday => 'आज का सर्वश्रेष्ठ समय';

  @override
  String get fdAvoidDuring => 'इस दौरान बचें';

  @override
  String get fdPredictionConfidence => 'भविष्यवाणी विश्वास';

  @override
  String get fdConfBasis => 'आज की भविष्यवाणी इनका संयोजन है';

  @override
  String get fdConfNatal => 'जन्म कुंडली';

  @override
  String get fdConfTransit => 'वर्तमान गोचर';

  @override
  String get fdConfDasha => 'ग्रह दशाएँ';

  @override
  String get fdConfStrength => 'ग्रह शक्ति';

  @override
  String get fdConfHouse => 'भाव सक्रियता';

  @override
  String get fdAskAi => 'AI से पूछें';

  @override
  String get fdAskAiSub => 'आज का उत्तर पाने के लिए प्रश्न पर टैप करें';

  @override
  String get fdQ1 => 'आज करियर धीमा क्यों है?';

  @override
  String get fdQ2 => 'आज सबसे अच्छा समय क्या है?';

  @override
  String get fdQ3 => 'क्या आज धन के मामलों के लिए अच्छा है?';

  @override
  String get fdQ4 => 'क्या आज यात्रा के लिए अच्छा है?';

  @override
  String get fdQ5 => 'आज मुझे किससे बचना चाहिए?';

  @override
  String get fdMoreSuggestions => 'और सुझाव';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return 'आज $top के लिए सबसे उपयुक्त है। $weak में सुस्ती महसूस हो सकती है, इसलिए वहाँ बड़े फैसले लेने से बचें। आर्थिक रूप से दिन $fin लग रहा है।';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return 'आज आपकी ऊर्जा $top के इर्द-गिर्द केंद्रित है — इसमें पूरा ध्यान लगाएँ और बाकी जगह हल्के से आगे बढ़ें।';
  }

  @override
  String get gochToday => 'आज';

  @override
  String get gochOverallScore => 'कुल गोचर स्कोर';

  @override
  String get gochNeutral => 'तटस्थ';

  @override
  String get gochChallenging => 'चुनौतीपूर्ण';

  @override
  String get gochTopPositive => 'शीर्ष सकारात्मक';

  @override
  String get gochTopChallenges => 'शीर्ष चुनौतियाँ';

  @override
  String get gochFilterAll => 'सभी';

  @override
  String get gochFavorability => 'अनुकूलता';

  @override
  String get gochAlerts => 'गोचर अलर्ट';

  @override
  String get gochAlertCritical => 'गंभीर';

  @override
  String get gochAlertWarning => 'सावधानी';

  @override
  String get gochAlertOpportunity => 'अवसर';

  @override
  String get gochAiFocus => 'आज का AI फोकस';

  @override
  String get gochLifeScores => 'जीवन क्षेत्र स्कोर';

  @override
  String get gochWhy => 'क्यों?';

  @override
  String get gochCurrentTransits => 'सक्रिय गोचर';

  @override
  String get gochDailyPlan => 'आपकी दैनिक योजना';

  @override
  String get gochMorning => 'सुबह';

  @override
  String get gochAfternoon => 'दोपहर';

  @override
  String get gochEvening => 'शाम';

  @override
  String get gochNight => 'रात';

  @override
  String get gochSmartReco => 'स्मार्ट सुझाव';

  @override
  String get gochExplain => 'आज के गोचर की व्याख्या करें';

  @override
  String get gochDo => 'करें';

  @override
  String get gochDont => 'न करें';

  @override
  String get gochDoWork => 'महत्वपूर्ण काम निपटाएं';

  @override
  String get gochDoMeditate => 'ध्यान करें और चिंतन करें';

  @override
  String get gochDoStart => 'नई योजनाएं शुरू करें';

  @override
  String get gochDoFinish => 'लंबित कार्य पूरे करें';

  @override
  String get gochDontArgue => 'बहस से बचें';

  @override
  String get gochDontImpulsive => 'जल्दबाजी में निर्णय लेने से बचें';

  @override
  String get gochDontOverspend => 'अधिक खर्च करने से बचें';

  @override
  String gochThemeGrowth(Object area) {
    return '$area में विकास का दिन है — इसका पूरा लाभ उठाएं।';
  }

  @override
  String gochThemeChallenge(Object area) {
    return 'आज $area के साथ धैर्य रखें — स्थिर रहें।';
  }

  @override
  String gochPosLine(Object area) {
    return '$area को अभी अच्छा समर्थन मिल रहा है।';
  }

  @override
  String gochChalLine(Object area) {
    return 'आज $area को अतिरिक्त ध्यान देने की जरूरत है।';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return 'आज अपनी ऊर्जा $a1 में लगाएं, और $a2 के साथ नरमी बरतें।';
  }

  @override
  String get divBeginner => 'सरल';

  @override
  String get divSearchHint => 'खोजें: करियर, विवाह, शिक्षा…';

  @override
  String get divSummaryTitle => 'वर्ग कुंडली सारांश';

  @override
  String get divTotalCharts => 'कुल कुंडलियाँ';

  @override
  String get divMostImportant => 'सर्वाधिक महत्वपूर्ण';

  @override
  String get divRecommendedForYou => 'आपके लिए अनुशंसित';

  @override
  String get divCatEssential => 'आवश्यक कुंडलियाँ';

  @override
  String get divCatPersonal => 'व्यक्तिगत जीवन';

  @override
  String get divCatKnowledge => 'ज्ञान कुंडलियाँ';

  @override
  String get divCatAdvanced => 'उन्नत कुंडलियाँ';

  @override
  String get divGoalProperty => 'संपत्ति';

  @override
  String get divGoalKarma => 'कर्म';

  @override
  String get divBadgeHighlyRec => 'अत्यधिक अनुशंसित';

  @override
  String get divBadgeRec => 'अनुशंसित';

  @override
  String get divBadgeUseful => 'उपयोगी';

  @override
  String get divBadgeOptional => 'वैकल्पिक';

  @override
  String get divBadgeAdvOnly => 'केवल उन्नत';

  @override
  String get divRecommendBest => 'सर्वश्रेष्ठ कुंडलियाँ सुझाएं';

  @override
  String get divNoMatch => 'आपकी खोज से कोई कुंडली मेल नहीं खाती';

  @override
  String get divLifeAreas => 'जीवन क्षेत्र';

  @override
  String divAiUse(Object purpose) {
    return '$purpose का विश्लेषण करने के लिए इस कुंडली का उपयोग करें।';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return 'आपकी $c1 और $c2 कुंडलियाँ विशेष रूप से महत्वपूर्ण हैं — इनसे जुड़े क्षेत्रों के लिए यहीं से शुरुआत करें, फिर आवश्यकतानुसार बाकी कुंडलियाँ भी देखें।';
  }

  @override
  String divRecReasonHouse(Object house) {
    return 'आपके $house भाव पर गहराई से नज़र डालने की ज़रूरत है — यह कुंडली इसे विस्तार से दिखाती है।';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '$planet एक महत्वपूर्ण लेकिन चुनौतीपूर्ण ग्रह है — यह कुंडली इसकी गहन स्थिति को उजागर करती है।';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return 'आप वर्तमान में $planet की महादशा में हैं, इसलिए यह कुंडली अभी विशेष रूप से उपयुक्त है।';
  }

  @override
  String divRecSummary(Object c1) {
    return 'आपकी कुंडली के अनुसार, $c1 को आपकी सर्वोच्च प्राथमिकता होनी चाहिए। नीचे दी गई कुंडलियाँ आपके लिए उनकी प्रासंगिकता के अनुसार क्रमबद्ध हैं।';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return 'जब आप $purpose का अध्ययन करना चाहें, तब यह कुंडली खोलें।';
  }

  @override
  String get yogaHelpful => 'सहायक';

  @override
  String get yogaInactive => 'निष्क्रिय';

  @override
  String get yogaTabMoney => 'धन';

  @override
  String get yogaTabRare => 'दुर्लभ';

  @override
  String get yogaSummaryTitle => 'योग सारांश';

  @override
  String get yogaActiveYogas => 'सक्रिय योग';

  @override
  String get yogaTotalYogas => 'कुल योग';

  @override
  String get yogaMostPowerful => 'सर्वाधिक शक्तिशाली';

  @override
  String get yogaFortuneRating => 'समग्र भाग्य';

  @override
  String get yogaBenefits => 'लाभ';

  @override
  String get yogaSupportingPlanets => 'सहायक ग्रह';

  @override
  String get yogaRanking => 'शीर्ष 5 प्रबल योग';

  @override
  String get yogaExplain => 'मेरे योग समझाएं';

  @override
  String get yogaExplainSubtitle => 'आपके योग आपकी कैसे मदद करते हैं';

  @override
  String get yogaNoneActive => 'अभी कोई सक्रिय योग नहीं';

  @override
  String get yogaNoneInCategory => 'इस श्रेणी में कोई योग नहीं';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return 'आपकी कुंडली में $count सक्रिय योग हैं — सहायक ग्रह संयोजन। $planets से जुड़े संयोजन विकास और सफलता के लिए विशेष रूप से लाभकारी प्रभाव बनाते हैं।';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '$name $areas को सहयोग देता है, और जब इसके ग्रह दशा या गोचर में सक्रिय होते हैं तो इसके लाभ और बढ़ जाते हैं।';
  }

  @override
  String get yogaAiGeneric =>
      'यह योग आपकी कुंडली में एक सहायक संयोजन है जो जीवन के संबंधित क्षेत्रों को मजबूत करता है।';

  @override
  String get yogaExplainReassure =>
      'योग आपकी कुंडली के उज्ज्वल पक्ष हैं — सहायक ग्रह संयोजन जो आपके पक्ष में काम करते हैं। जो अधिक प्रबल होते हैं वे स्थायी लाभ देते हैं, विशेष रूप से उन्हें बनाने वाले ग्रहों की अवधि के दौरान।';

  @override
  String get doshSevere => 'गंभीर';

  @override
  String get doshVeryMild => 'बहुत हल्का';

  @override
  String get doshLow => 'निम्न';

  @override
  String get doshHigh => 'उच्च';

  @override
  String get doshCritical => 'अति गंभीर';

  @override
  String get doshSummaryTitle => 'दोष सारांश';

  @override
  String get doshActiveDoshas => 'सक्रिय दोष';

  @override
  String get doshTotalChecked => 'कुल जाँचे गए';

  @override
  String get doshOverallSeverity => 'समग्र गंभीरता';

  @override
  String get doshNoneActive => 'कोई सक्रिय दोष नहीं — शुद्ध कुंडली!';

  @override
  String get doshCategory => 'श्रेणी';

  @override
  String get doshConfidence => 'विश्वास स्तर';

  @override
  String get doshWhyFormed => 'यह क्यों बना';

  @override
  String get doshAffectedAreas => 'प्रभावित क्षेत्र';

  @override
  String get doshTimeline => 'समयरेखा';

  @override
  String get doshDefinition => 'परिभाषा';

  @override
  String get doshFormationRule => 'निर्माण नियम';

  @override
  String get doshSupportingPlanets => 'संबंधित ग्रह';

  @override
  String get doshCancellation => 'निवारण योग';

  @override
  String get doshNoCancellation => 'कोई नहीं';

  @override
  String get doshAreaChildren => 'संतान';

  @override
  String get doshAreaMind => 'मन';

  @override
  String get remMantra => 'मंत्र';

  @override
  String get remGemstone => 'रत्न';

  @override
  String get remDonation => 'दान';

  @override
  String get remTemple => 'मंदिर';

  @override
  String get remFasting => 'व्रत';

  @override
  String get remLifestyle => 'जीवनशैली';

  @override
  String get remLifestyleGeneric =>
      'इस ग्रह से जुड़े कृतज्ञता, अनुशासन और दान का अभ्यास करें, और अच्छा आचरण बनाए रखें।';

  @override
  String get doshExplain => 'मेरे दोष समझाएं';

  @override
  String get doshExplainSubtitle => 'आपके दोषों पर एक शांत, व्यावहारिक नज़र';

  @override
  String get doshExplainReassure =>
      'दोष सामान्य हैं — लगभग हर कुंडली में कुछ न कुछ होते हैं। ये स्वभाव दर्शाते हैं, तय भाग्य नहीं। जागरूकता, अच्छे आचरण और सरल उपायों से इनका व्यावहारिक प्रभाव कम हो जाता है, इसलिए चिंता की कोई बात नहीं है।';

  @override
  String get doshAiGeneric =>
      'यह दोष आपकी कुंडली में एक प्रवृत्ति दर्शाता है। इसका व्यावहारिक प्रभाव आमतौर पर हल्का होता है और जागरूकता व सरल उपायों से संतुलित किया जा सकता है।';

  @override
  String doshHeroSummary(Object active, Object total) {
    return 'आपकी कुंडली में $total में से $active सक्रिय दोष दिखते हैं। अधिकांश हल्के हैं और केवल कुछ पर ध्यान देने की जरूरत है। समझ और सरल उपायों से इनका व्यावहारिक प्रभाव कम किया जा सकता है।';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return 'यह दोष मुख्यतः $areas को प्रभावित करता है। $planet की अवधि के दौरान इसका प्रभाव अधिक महसूस हो सकता है, और उपाय इसे संतुलित करने में मदद करते हैं।';
  }

  @override
  String doshTimelineLine(Object planet) {
    return 'इसका प्रभाव $planet की महादशा और अंतर्दशा के दौरान, और गोचर में $planet के सक्रिय होने पर सबसे अधिक महसूस होता है।';
  }

  @override
  String get sbLegendary => 'असाधारण';

  @override
  String get sbSthana => 'स्थान बल';

  @override
  String get sbDig => 'दिक् बल';

  @override
  String get sbKala => 'काल बल';

  @override
  String get sbChesta => 'चेष्टा बल';

  @override
  String get sbNaisargika => 'नैसर्गिक बल';

  @override
  String get sbDrik => 'दृक् बल';

  @override
  String get sbSummary => 'ग्रह बल सारांश';

  @override
  String get sbAverageStrength => 'औसत बल';

  @override
  String get sbHighestRupa => 'सर्वाधिक रूपा';

  @override
  String get sbRupa => 'रूपा';

  @override
  String get sbRanking => 'ग्रह रैंकिंग';

  @override
  String get sbRequired => 'आवश्यक';

  @override
  String get sbExcess => 'अधिशेष';

  @override
  String get sbDeficit => 'कमी';

  @override
  String get sbTotalShadbala => 'कुल षड्बल';

  @override
  String get sbExplain => 'मेरा ग्रह बल समझाएं';

  @override
  String get sbExplainSubtitle => 'आपके ग्रहों के बल का सरल सारांश';

  @override
  String get sbInfoTitle => 'षड्बल को समझें';

  @override
  String get sbQWhatIs => 'षड्बल क्या है?';

  @override
  String get sbQRupas => 'रूपा क्या हैं?';

  @override
  String get sbQHowCalc => 'बल की गणना कैसे होती है?';

  @override
  String get sbQHowUse => 'इसका उपयोग कैसे करें';

  @override
  String get sbWhyStrong => 'क्यों मजबूत';

  @override
  String get sbWhyWeak => 'क्यों कमजोर';

  @override
  String get sbDuringMahadasha => 'महादशा के दौरान';

  @override
  String get sbEffects => 'प्रभाव';

  @override
  String get sbLifeAreas => 'जीवन क्षेत्र';

  @override
  String get sbPlanetDetails => 'ग्रह विवरण';

  @override
  String get sbBodyWhatIs =>
      'षड्बल (\'छह गुना बल\') मापता है कि प्रत्येक ग्रह में अपने परिणाम देने की कितनी शक्ति है, छह स्वतंत्र बल स्रोतों को जोड़कर।';

  @override
  String get sbBodyRupas =>
      'बल रूपा में मापा जाता है (1 रूपा = 60 विरूपा)। मजबूत माने जाने के लिए प्रत्येक ग्रह को न्यूनतम रूपा बल चाहिए; अधिक रूपा का मतलब है कि वह अपने परिणाम अधिक पूर्णता से देता है।';

  @override
  String get sbBodyHowCalc =>
      'छह बल जोड़े जाते हैं: स्थान (स्थितिजन्य), दिक् (दिशात्मक), काल (समयगत), चेष्टा (गतिजन्य), नैसर्गिक (प्राकृतिक) और दृक् (दृष्टिगत)। कुल की तुलना ग्रह की आवश्यक न्यूनतम सीमा से करके प्रतिशत प्राप्त किया जाता है।';

  @override
  String get sbBodyHowUse =>
      '100% से ऊपर वाला ग्रह अपने कारकत्व सहजता से देता है; 100% से नीचे होने पर सहायता की आवश्यकता होती है। महत्वपूर्ण मामलों के लिए अपने सबसे मजबूत ग्रहों को प्राथमिकता दें, और सबसे कमजोर ग्रहों को उपाय और धैर्य दें।';

  @override
  String get sbRemedyStrong =>
      'अच्छी तरह से समर्थित — किसी विशेष उपाय की आवश्यकता नहीं; आप इस ग्रह की अवधियों का आत्मविश्वास से उपयोग कर सकते हैं।';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '$strongP आपका सबसे मजबूत ग्रह है, जो $strongTrait के लिए उत्कृष्ट सहयोग देता है। $weakP सबसे कमजोर है और उपायों से सबसे अधिक लाभान्वित होता है।';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '$planet का षड्बल $category है, इसलिए इसके $karakatva तदनुसार समर्थित हैं।';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return '$bala के माध्यम से सबसे मजबूत ($rupa रूपा)।';
  }

  @override
  String sbWeakLine(Object bala) {
    return '$bala में सबसे कमजोर, जो कुल को कम करता है।';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return '$planet की महादशा के दौरान, इसके $karak सामने आते हैं।';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'मजबूत षड्बल के साथ, $karak स्वाभाविक रूप से समर्थित होते हैं।';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'साधारण षड्बल के साथ, $karak को सचेत प्रयास की आवश्यकता हो सकती है।';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return '$planet को इसके मंत्र, रत्न या दान के माध्यम से मजबूत करें, और इसकी अवधियों के दौरान धैर्यपूर्वक कार्य करें।';
  }

  @override
  String get bhOverview => 'अवलोकन';

  @override
  String get bhDetailed => 'विस्तृत';

  @override
  String get bhavaHouses => 'भाव';

  @override
  String get bhStrengthOverview => 'भाव शक्ति अवलोकन';

  @override
  String get bhOverallAverage => 'समग्र भाव औसत';

  @override
  String get bhStrongestHouse => 'सबसे मजबूत भाव';

  @override
  String get bhWeakestHouse => 'सबसे कमजोर भाव';

  @override
  String get bhBestArea => 'श्रेष्ठ जीवन क्षेत्र';

  @override
  String get bhNeedsAttention => 'ध्यान देने योग्य';

  @override
  String get bhSavContribution => 'SAV योगदान';

  @override
  String get bhLordCondition => 'भावेश की स्थिति';

  @override
  String get bhBenefic => 'शुभ प्रभाव';

  @override
  String get bhMalefic => 'अशुभ प्रभाव';

  @override
  String get bhStrengthReasons => 'यह स्कोर क्यों';

  @override
  String get bhGoodEffects => 'अच्छे प्रभाव';

  @override
  String get bhChallenges => 'चुनौतियाँ';

  @override
  String get bhRemedies => 'उपाय';

  @override
  String get bhRanking => 'भाव रैंकिंग';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'मेरे भाव समझाएं';

  @override
  String get bhExplainSubtitle => 'आपके 12 भावों का सरल सारांश';

  @override
  String bhHeroSummary(
    Object s1,
    Object s2,
    Object strongArea,
    Object weakArea,
  ) {
    return 'आपके सबसे मजबूत भाव $s1 और $s2 हैं। $strongArea स्वाभाविक रूप से मजबूत है, जबकि $weakArea को अधिक प्रयास की आवश्यकता है।';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'इसका स्वामी $lord $relation के रूप में स्थित है।';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'इस भाव में $sav शुभ अंक (SAV) हैं; इसमें बैठे ग्रह और उन पर पड़ने वाली दृष्टियाँ शेष स्कोर तय करती हैं।';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'जब यह मजबूत होता है, तो यह $meaning को सहारा देता है।';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'जब यह कमजोर होता है, तो $meaning के लिए अतिरिक्त प्रयास और ध्यान की आवश्यकता हो सकती है।';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'इसे मजबूत बनाने के लिए इसके स्वामी $lord को बल दें और इस भाव के विषयों का सम्मान करें।';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'आपका $house $strengthWord है। यह $meaning को नियंत्रित करता है।';
  }

  @override
  String get kunNavamsa => 'नवांश (D9)';

  @override
  String get kunD10 => 'दशांश (D10)';

  @override
  String get kunPlacement => 'ग्रह स्थिति';

  @override
  String get kunHousesTitle => 'भाव विवरण';

  @override
  String get kunPlanet => 'ग्रह';

  @override
  String get kunNakshatra => 'नक्षत्र';

  @override
  String get kunPada => 'पद';

  @override
  String get kunLord => 'स्वामी';

  @override
  String get kunExplain => 'मेरी कुंडली समझाएं';

  @override
  String get kunExplainSubtitle => 'आपकी कुंडली का सरल सारांश';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return '$ordinal भाव $meaning को नियंत्रित करता है।';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return 'यहाँ स्थित $planets इसके परिणामों को आकार देते हैं।';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'आपका लग्न $asc है, जो आपके दृष्टिकोण और दूसरों की आपके बारे में पहली धारणा को आकार देता है।';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'आपका मन और भावनाएं $moon में स्थित चंद्रमा का अनुसरण करती हैं।';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '$planet आपका सबसे मजबूत ग्रह है — सहजता और सहयोग का स्वाभाविक क्षेत्र।';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '$planet आपका सबसे चुनौतीपूर्ण ग्रह है — यहाँ धैर्य और प्रयास फल देते हैं।';
  }

  @override
  String get plNature => 'प्रकृति';

  @override
  String get plElement => 'तत्व';

  @override
  String get plGender => 'लिंग';

  @override
  String get plKarakatva => 'कारकत्व';

  @override
  String get plLordship => 'स्वामित्व';

  @override
  String get plStrength => 'शक्ति';

  @override
  String get plAspectsGiven => 'दी गई दृष्टि';

  @override
  String get plAspectsReceived => 'प्राप्त दृष्टि';

  @override
  String get plConjunction => 'युति';

  @override
  String get plHouseMeaning => 'भाव का अर्थ';

  @override
  String get plNakshatraMeaning => 'नक्षत्र का अर्थ';

  @override
  String get plAiInterpretation => 'AI व्याख्या';

  @override
  String get plSearchHint => 'कोई भी ग्रह खोजें';

  @override
  String get plNoResults => 'कोई ग्रह नहीं मिला';

  @override
  String get plBenefic => 'शुभ';

  @override
  String get plMalefic => 'अशुभ';

  @override
  String get plMale => 'पुरुष';

  @override
  String get plFemale => 'स्त्री';

  @override
  String get plNeutralGender => 'नपुंसक';

  @override
  String get plOwnSign => 'स्व राशि';

  @override
  String get plFriend => 'मित्र राशि';

  @override
  String get plEnemy => 'शत्रु राशि';

  @override
  String get plNeutral => 'सम';

  @override
  String get sumEther => 'आकाश';

  @override
  String plLordOfHouses(Object houses) {
    return 'भाव $houses के स्वामी';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return '$nakLord द्वारा शासित, जो $trait लाता है।';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '$planet, $sign राशि में, $house भाव में स्थित है।';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'इसके मुख्य कारकत्व — $karak — यहाँ अच्छी तरह समर्थित हैं।';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'इसके मुख्य कारकत्व — $karak — को यहाँ सचेत प्रयास की आवश्यकता हो सकती है।';
  }

  @override
  String plAiExalted(Object planet) {
    return '$planet उच्च का है, जो अपने सर्वश्रेष्ठ परिणाम देता है।';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '$planet नीच का है और अपने परिणाम देने के लिए सहारे की आवश्यकता है।';
  }

  @override
  String plAiCombust(Object planet) {
    return '$planet अस्त है, इसलिए यह सूर्य की तीव्रता में कम खुलकर कार्य करता है।';
  }

  @override
  String plAiVargottama(Object planet) {
    return '$planet वर्गोत्तम है — यह मजबूत स्थिति नवमांश में भी दोहराई जाती है।';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '$planet वक्री है, जो अपनी ऊर्जा को भीतर की ओर मोड़कर उसे तीव्र करता है।';
  }

  @override
  String get plHouse1 => 'स्व, शरीर, व्यक्तित्व और जीवनशक्ति';

  @override
  String get plHouse2 => 'धन, परिवार, वाणी और भोजन';

  @override
  String get plHouse3 => 'साहस, भाई-बहन, संचार और छोटी यात्राएँ';

  @override
  String get plHouse4 => 'घर, माता, सुख-सुविधा, संपत्ति और आंतरिक शांति';

  @override
  String get plHouse5 => 'संतान, रचनात्मकता, बुद्धि, प्रेम और पूर्व पुण्य';

  @override
  String get plHouse6 => 'स्वास्थ्य, शत्रु, ऋण, सेवा और दैनिक कार्य';

  @override
  String get plHouse7 => 'विवाह, साझेदारी और व्यावसायिक संबंध';

  @override
  String get plHouse8 => 'आयु, परिवर्तन, रहस्य और विरासत';

  @override
  String get plHouse9 => 'भाग्य, धर्म, उच्च शिक्षा, गुरु और पिता';

  @override
  String get plHouse10 => 'करियर, प्रतिष्ठा, अधिकार और सार्वजनिक कर्म';

  @override
  String get plHouse11 => 'लाभ, आय, मित्र, नेटवर्क और पूर्ण इच्छाएँ';

  @override
  String get plHouse12 => 'हानि, व्यय, विदेश, आध्यात्मिकता और मोक्ष';

  @override
  String get sumVeryStrong => 'बहुत मजबूत';

  @override
  String get sumStrong => 'मजबूत';

  @override
  String get sumAverage => 'औसत';

  @override
  String get sumWeak => 'कमजोर';

  @override
  String get sumNeedsAttention => 'ध्यान देने योग्य';

  @override
  String get sumFire => 'अग्नि';

  @override
  String get sumEarth => 'पृथ्वी';

  @override
  String get sumAir => 'वायु';

  @override
  String get sumWater => 'जल';

  @override
  String get sumMovable => 'चर';

  @override
  String get sumFixed => 'स्थिर';

  @override
  String get sumDual => 'द्विस्वभाव';

  @override
  String get sumDirEast => 'पूर्व';

  @override
  String get sumDirWest => 'पश्चिम';

  @override
  String get sumDirNorth => 'उत्तर';

  @override
  String get sumDirSouth => 'दक्षिण';

  @override
  String get sumDirNE => 'उत्तर-पूर्व';

  @override
  String get sumDirNW => 'उत्तर-पश्चिम';

  @override
  String get sumDirSE => 'दक्षिण-पूर्व';

  @override
  String get sumDirSW => 'दक्षिण-पश्चिम';

  @override
  String get sumSnapshotTitle => 'आपकी ज्योतिष झलक';

  @override
  String get sumMahadasha => 'महादशा';

  @override
  String get sumAntardasha => 'अंतर्दशा';

  @override
  String get sumNakshatra => 'जन्म नक्षत्र';

  @override
  String get sumElement => 'तत्व';

  @override
  String get sumModality => 'स्वभाव';

  @override
  String get sumLuckyDirection => 'शुभ दिशा';

  @override
  String get sumHighlights => 'मुख्य बिंदु';

  @override
  String get sumStrongPlanet => 'सबसे मजबूत ग्रह';

  @override
  String get sumWeakPlanet => 'सबसे कमजोर ग्रह';

  @override
  String get sumYogas => 'योग';

  @override
  String get sumDoshas => 'दोष';

  @override
  String get sumRetrograde => 'वक्री';

  @override
  String get sumCombust => 'अस्त';

  @override
  String get sumExalted => 'उच्च';

  @override
  String get sumDebilitated => 'नीच';

  @override
  String get sumVargottama => 'वर्गोत्तम';

  @override
  String get sumQuickInsights => 'त्वरित जानकारी';

  @override
  String get sumSpirituality => 'आध्यात्म';

  @override
  String get sumTimezone => 'समय क्षेत्र';

  @override
  String get sumAyanamsa => 'अयनांश';

  @override
  String get sumCalendarType => 'पंचांग';

  @override
  String get sumCopied => 'क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get sumNatureFire =>
      'आपका स्वभाव साहसी, ऊर्जावान और अग्रणी है, जो आगे बढ़कर नेतृत्व करता है।';

  @override
  String get sumNatureEarth =>
      'आपका स्वभाव व्यावहारिक, स्थिर और अनुशासित है, जो स्थायी परिणाम बनाता है।';

  @override
  String get sumNatureAir =>
      'आपका स्वभाव जिज्ञासु, संवादप्रिय और बौद्धिक है, जो नए विचारों में फलता-फूलता है।';

  @override
  String get sumNatureWater =>
      'आपका स्वभाव सहज-बोधी, भावनात्मक और सहानुभूतिपूर्ण है, गहरी आंतरिक संवेदनशीलता के साथ।';

  @override
  String get sumGradePhraseExcellent =>
      'मजबूती से समर्थित — निरंतर प्रयास से अनुकूल परिणाम मिलने की संभावना है।';

  @override
  String get sumGradePhraseGood =>
      'अच्छी तरह समर्थित — थोड़ी सावधानी के साथ सामान्यतः सकारात्मक।';

  @override
  String get sumGradePhraseAverage =>
      'मिश्रित समर्थन — परिणाम प्रयास और समय पर निर्भर करते हैं।';

  @override
  String get sumGradePhraseWeak =>
      'ध्यान देने योग्य — धैर्य और उपाय यहां मदद करते हैं।';

  @override
  String get kDefCombust =>
      'सूर्य के बहुत निकट स्थित ग्रह, जिससे उसकी ऊर्जा \'जल\' कर कमजोर हो जाती है।';

  @override
  String get kDefRetrograde =>
      'पीछे की ओर चलता प्रतीत होने वाला ग्रह; इसके प्रभाव भीतर की ओर मुड़कर तीव्र हो जाते हैं।';

  @override
  String get kDefNakshatra =>
      '27 नक्षत्र मंडलों में से एक, जिनसे चंद्रमा और ग्रह गुजरते हैं।';

  @override
  String get kDefVargottama =>
      'जन्म कुंडली (D1) और नवांश (D9) दोनों में एक ही राशि में स्थित ग्रह — शक्ति का प्रतीक।';

  @override
  String get kDefOwnSign =>
      'अपनी स्वयं की राशि में बैठा ग्रह, जहां वह घर जैसा महसूस करता है और स्थिर परिणाम देता है।';

  @override
  String get kDefExalted =>
      'अपनी सर्वोच्च शक्ति की राशि में स्थित ग्रह, जो अपने सर्वश्रेष्ठ परिणाम देता है।';

  @override
  String get kDefDebilitated =>
      'अपनी सबसे कमजोर राशि में स्थित ग्रह, जहां वह परिणाम देने में संघर्ष करता है।';

  @override
  String get kDefMooltrikona =>
      'ग्रह की अपनी राशि का एक विशेष भाग, जहां वह विशेष रूप से शक्तिशाली होता है।';

  @override
  String get kDefAscendant =>
      'जन्म के समय पूर्वी क्षितिज पर उदित होने वाली राशि — लग्न, कुंडली की नींव।';

  @override
  String get kDefMahadasha =>
      'जीवन की एक लंबी अवधि को रंग देने वाला प्रमुख ग्रह काल।';

  @override
  String get kDefAntardasha =>
      'महादशा के भीतर एक उप-अवधि, जो इसके परिणामों को सूक्ष्मता से समायोजित करती है।';

  @override
  String get kDefPada =>
      'ग्रह जिस नक्षत्र में स्थित है, उसके चार चरणों में से एक।';

  @override
  String get aspGivesAspectTo => 'दृष्टि डालता है';

  @override
  String get aspReceivesAspectFrom => 'दृष्टि प्राप्त करता है';

  @override
  String get aspInfluences => 'प्रभावित करता है';

  @override
  String get aspNoInfluence => 'कोई प्रभाव नहीं';

  @override
  String get aspNoAspect => 'कोई दृष्टि नहीं';

  @override
  String get aspPresent => 'उपस्थित';

  @override
  String get aspAbsent => 'अनुपस्थित';

  @override
  String get aspNotPresent => 'उपस्थित नहीं';

  @override
  String get aspSpecialAspect => 'विशेष दृष्टि';

  @override
  String get aspAspectWord => 'दृष्टि';

  @override
  String get aspTotalGiven => 'दी गई दृष्टि';

  @override
  String get aspTotalReceived => 'प्राप्त दृष्टि';

  @override
  String get aspStrongestInfluence => 'सबसे प्रबल प्रभाव';

  @override
  String get aspMedium => 'मध्यम';

  @override
  String get aspAspectPresent => 'दृष्टि उपस्थित';

  @override
  String get aspReason => 'कारण';

  @override
  String get aspBoth => 'दोनों';

  @override
  String get aspTargetHouse => 'लक्ष्य भाव';

  @override
  String get aspTargetSign => 'लक्ष्य राशि';

  @override
  String get aspLagnaReceives => 'लग्न को दृष्टि प्राप्त होती है';

  @override
  String get aspNoAspectFrom => 'इनसे कोई दृष्टि नहीं';

  @override
  String get aspPlanetToPlanet => 'ग्रह से ग्रह';

  @override
  String get aspSignToSign => 'राशि से राशि';

  @override
  String get aspCombinedAspect => 'संयुक्त दृष्टि';

  @override
  String get aspGrahaAspect => 'ग्रह दृष्टि';

  @override
  String get aspRashiAspect => 'राशि दृष्टि';

  @override
  String get aspInfoTitle => 'दृष्टि को समझें';

  @override
  String get aspQGraha => 'ग्रह दृष्टि क्या है?';

  @override
  String get aspQRashi => 'राशि दृष्टि क्या है?';

  @override
  String get aspQDiff => 'दोनों में अंतर';

  @override
  String get aspQPredict => 'दृष्टि भविष्यवाणी को कैसे प्रभावित करती है';

  @override
  String get aspGrahaBody =>
      'ग्रह दृष्टि वह प्रभाव है जो एक ग्रह अपनी स्थिति से डालता है। हर ग्रह अपने स्थान से 7वें भाव/ग्रह पर पूर्ण दृष्टि डालता है (एक सीधा, आमने-सामने का प्रभाव)। इसके अतिरिक्त, मंगल 4थे और 8वें पर, गुरु 5वें और 9वें पर, तथा शनि 3रे और 10वें पर दृष्टि डालता है। राहु और केतु को आमतौर पर 5वीं, 7वीं और 9वीं दृष्टि दी जाती है। किसी ग्रह की दृष्टि उस ग्रह या भाव को अपने स्वभाव के रंग में रंग देती है।';

  @override
  String get aspRashiBody =>
      'राशि दृष्टि जैमिनी ज्योतिष की एक राशि-से-राशि दृष्टि है, जो इस पर निर्भर नहीं करती कि वहाँ कौन से ग्रह बैठे हैं। चर राशियाँ स्थिर राशियों पर दृष्टि डालती हैं (निकटवर्ती को छोड़कर), स्थिर राशियाँ चर राशियों पर दृष्टि डालती हैं (निकटवर्ती को छोड़कर), और द्विस्वभाव राशियाँ अन्य द्विस्वभाव राशियों पर दृष्टि डालती हैं। इसका उपयोग मुख्य रूप से जैमिनी भविष्यवाणी और भावों के बीच संबंध आँकने में किया जाता है।';

  @override
  String get aspDiffBody =>
      'ग्रह दृष्टि किसी ग्रह द्वारा डाली जाती है और इस पर निर्भर करती है कि वह ग्रह कहाँ स्थित है। राशि दृष्टि राशि की अपनी होती है और उसमें जो कुछ भी स्थित हो, उस पर लागू होती है। ग्रह दृष्टि दिशात्मक होती है (ग्रह A ग्रह B को देखता है), जबकि राशि दृष्टि आमतौर पर राशियों के बीच परस्पर होती है। जब दोनों एक ही लक्ष्य की ओर इशारा करते हैं, तो प्रभाव विशेष रूप से प्रबल होता है।';

  @override
  String get aspPredictBody =>
      'दृष्टि यह दर्शाती है कि एक ग्रह अपने भाव से परे अपना प्रभाव कहाँ तक फैलाता है। एक शुभ दृष्टि (गुरु, शुक्र, अच्छी स्थिति में चंद्र/बुध) लक्ष्य का समर्थन और रक्षा करती है; एक अशुभ दृष्टि (शनि, मंगल, सूर्य, राहु, केतु) उस पर दबाव डाल सकती है, विलंब कर सकती है या चुनौती दे सकती है। यह पढ़ना कि कौन से ग्रह किसी भाव या ग्रह पर दृष्टि डालते हैं, यह समझाता है कि परिणाम जिस तरह से सामने आते हैं, वैसे क्यों आते हैं।';

  @override
  String get aspTraitSun => 'अधिकार, नेतृत्व और जीवन-शक्ति';

  @override
  String get aspTraitMoon => 'भावनात्मक गहराई, सुख और अंतर्ज्ञान';

  @override
  String get aspTraitMars => 'ऊर्जा, साहस और जोश';

  @override
  String get aspTraitMercury => 'संचार, बुद्धि और अनुकूलनशीलता';

  @override
  String get aspTraitJupiter => 'ज्ञान, विकास और सौभाग्य';

  @override
  String get aspTraitVenus => 'प्रेम, सामंजस्य और सुख-सुविधाएँ';

  @override
  String get aspTraitSaturn =>
      'अनुशासन, जिम्मेदारी और धैर्यपूर्ण, कभी-कभी विलंबित, सफलता';

  @override
  String get aspTraitRahu => 'महत्वाकांक्षा, तीव्रता और अपरंपरागत मोड़';

  @override
  String get aspTraitKetu => 'विरक्ति, आध्यात्मिकता और अचानक परिवर्तन';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '$planet $targets को प्रभावित कर रहा है। इससे इन ग्रहों द्वारा दर्शाए गए क्षेत्रों में $trait आ सकता है।';
  }

  @override
  String aspAiNone(Object planet) {
    return '$planet यहाँ किसी अन्य ग्रह पर विशेष दृष्टि नहीं डालता; इसका प्रभाव मुख्यतः अपनी ही राशि और भाव के माध्यम से कार्य करता है।';
  }

  @override
  String get avSummaryTitle => 'अष्टकवर्ग सारांश';

  @override
  String get avOverallScore => 'कुल SAV स्कोर';

  @override
  String get avOverallRating => 'समग्र रेटिंग';

  @override
  String get avStrongestSigns => 'सबसे मजबूत राशियाँ';

  @override
  String get avWeakestSigns => 'सबसे कमजोर राशियाँ';

  @override
  String get avScore => 'स्कोर';

  @override
  String get avMeaning => 'अर्थ';

  @override
  String get avGrid => 'ग्रिड';

  @override
  String get avList => 'सूची';

  @override
  String get avOverallScoreShort => 'कुल स्कोर';

  @override
  String get avNatalSignScore => 'जन्म राशि स्कोर';

  @override
  String get avBestSigns => 'श्रेष्ठ राशियाँ';

  @override
  String get avWeakSigns => 'कमजोर राशियाँ';

  @override
  String get avAiInterpretation => 'AI व्याख्या';

  @override
  String get avVeryGood => 'बहुत अच्छा';

  @override
  String get avVeryWeak => 'बहुत कमजोर';

  @override
  String get avTotalSav => 'कुल SAV';

  @override
  String get avPlanetContributions => 'ग्रह योगदान';

  @override
  String get avFinance => 'वित्त';

  @override
  String get avOverallStrength => 'समग्र शक्ति';

  @override
  String get avWhatDoesThisMean => 'इसका क्या अर्थ है?';

  @override
  String get avSimple => 'सरल';

  @override
  String get avAdvanced => 'विस्तृत';

  @override
  String get avInfoTitle => 'अष्टकवर्ग को समझें';

  @override
  String get avStrong => 'मजबूत';

  @override
  String get avModerate => 'मध्यम';

  @override
  String get avQWhatIsAv => 'अष्टकवर्ग क्या है?';

  @override
  String get avQWhatIsSav => 'SAV क्या है?';

  @override
  String get avQWhatIsBav => 'BAV क्या है?';

  @override
  String get avQHowToRead => 'इन स्कोर को कैसे पढ़ें';

  @override
  String get avQSavVsBav => 'SAV बनाम BAV';

  @override
  String get avABody =>
      'अष्टकवर्ग वैदिक ज्योतिष में अंकों पर आधारित एक शक्ति प्रणाली है। प्रत्येक ग्रह अपनी स्थिति के अनुसार बारह राशियों को शुभ अंक (बिंदु, जिन्हें रेखा भी कहते हैं) देता है। किसी राशि में जितने अधिक अंक होंगे, संबंधित ग्रह दशा और गोचर के दौरान जीवन का वह क्षेत्र उतना ही सहज सहयोग पाएगा।';

  @override
  String get avSavBody =>
      'SAV (सर्व अष्टकवर्ग) सातों ग्रहों के अंकों को प्रत्येक राशि के लिए जोड़ता है। यह प्रत्येक राशि के लिए एक ही शक्ति स्कोर देता है, जिससे आप जल्दी देख सकते हैं कि आपकी कुंडली में कौन-सी राशियाँ — और उनके भाव — सबसे अधिक सहयोग प्राप्त कर रहे हैं।';

  @override
  String get avBavBody =>
      'BAV (भिन्न अष्टकवर्ग) एक ही ग्रह के अंक बारह राशियों में दिखाता है। यह बताता है कि कोई विशेष ग्रह किन राशियों को सबसे अधिक सहयोग देता है, जो तब महत्वपूर्ण होता है जब उस ग्रह की दशा या गोचर सक्रिय हो।';

  @override
  String get avHowToReadBody =>
      'अधिक अंक बेहतर माने जाते हैं। SAV के लिए, औसत राशि लगभग 28 अंक पाती है — 30 से ऊपर मजबूत और 25 से नीचे सावधानी की आवश्यकता दर्शाता है। BAV के लिए, प्रत्येक राशि 0 से 8 के बीच होती है, जिसमें 4 औसत माना जाता है। महत्वपूर्ण कार्यों के लिए अपनी सबसे मजबूत राशियों को प्राथमिकता दें, और सबसे कमजोर राशियों के मामलों में धैर्य और अनुशासन बनाए रखें।';

  @override
  String get avSavVsBavBody =>
      'SAV सभी ग्रहों का संयुक्त कुल है और किसी राशि की समग्र शक्ति दिखाता है। BAV एक ही ग्रह का योगदान है और बताता है कि कौन-सा ग्रह उस राशि को सहयोग देता है। बड़ी तस्वीर समझने के लिए SAV का उपयोग करें, और यह जानने के लिए कि किस ग्रह से राशि की शक्ति आती है, BAV देखें।';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'आपकी कुंडली $s1, $s2 और $s3 में सबसे मजबूत है। ये राशियाँ ग्रह दशाओं और गोचर के दौरान बेहतर सहयोग देती हैं। $weak में फिलहाल सबसे कम सहयोग है, इसलिए इससे जुड़े मामलों में धैर्य और अनुशासन मददगार रहेगा।';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '$planet $s1 और $s2 के माध्यम से सबसे अधिक प्रभावी रहता है। जब ये राशियाँ सक्रिय होती हैं, तो $planet से संबंधित मामलों में सुधार होता है।';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'आपकी सबसे मजबूत राशियाँ $s1 और $s2 हैं — जब ग्रह इनसे गोचर करें तो महत्वपूर्ण शुरुआत के लिए इन्हें प्राथमिकता दें।';
  }

  @override
  String avInsightWeak(Object s1) {
    return '$s1 में सबसे कम सहयोग है — इससे जुड़े मामलों में सावधानी बरतें और अधिक प्रतिबद्धता से बचें।';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '$planet के पास सबसे अधिक अंक हैं, इसलिए इससे जुड़े विषय आपके जीवन में अच्छी तरह सहयोग पाते हैं।';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '$planet के पास सबसे कम अंक हैं और यह उपायों तथा सजग प्रयास से सबसे अधिक लाभान्वित होता है।';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'जिन राशियों का स्कोर आपके औसत $avg अंकों से अधिक है, वे आमतौर पर अधिक सहज और भरोसेमंद परिणाम देती हैं।';
  }

  @override
  String get fcKey => 'कुंजी';

  @override
  String get fcActions => 'कार्य';

  @override
  String get fcCautions => 'सावधानियां';

  @override
  String get fc12House => '12 भाव';

  @override
  String get fcProbabilities => 'संभावनाएं';

  @override
  String get fcHousesCaps => 'भाव';

  @override
  String get fcCritical => 'गंभीर';

  @override
  String get fcFlags => 'चिह्न';

  @override
  String get fcAnalysis => 'विश्लेषण';

  @override
  String get fcConfidence => 'विश्वास';

  @override
  String get fcQualityCaps => 'गुणवत्ता';

  @override
  String get fcIncomeVs => 'आय बनाम';

  @override
  String get fcExpense => 'व्यय';

  @override
  String get fcFinance => 'वित्त';

  @override
  String get fcNetBalance => 'निवल शेष';

  @override
  String get fcSignature => 'हस्ताक्षर';

  @override
  String get fcBestTimeForIncome => 'आय के लिए सर्वोत्तम समय';

  @override
  String get fcExpenseCaution => 'व्यय सावधानी';

  @override
  String get fcIncomeCaps => 'आय';

  @override
  String get fcExpenseCaps => 'व्यय';

  @override
  String get fcRelationships => 'रिश्ते';

  @override
  String get fcAreasCaps => 'क्षेत्र';

  @override
  String get fcBestForMeetings => 'बैठकों के लिए सर्वोत्तम';

  @override
  String get fcOpportunitiesVs => 'अवसर बनाम';

  @override
  String get fcRisks => 'जोखिम';

  @override
  String get fcOutlook => 'दृष्टिकोण';

  @override
  String get fcAction => 'कार्य';

  @override
  String get fcProtect => 'सुरक्षा';

  @override
  String get fcOpportunityCaps => 'अवसर';

  @override
  String get fcRiskCaps => 'जोखिम';

  @override
  String get fcTopOpportunities => 'शीर्ष अवसर';

  @override
  String get fcTopRisks => 'शीर्ष जोखिम';

  @override
  String get fcTiming => 'समय';

  @override
  String get fcWindows => 'विंडो';

  @override
  String get fcSlotsCaps => 'स्लॉट';

  @override
  String get fcBestWindows => 'सर्वश्रेष्ठ विंडो';

  @override
  String get fcWorstWindows => 'सबसे खराब विंडो';

  @override
  String get fcAvoid => 'बचें';

  @override
  String get fcHouse => 'भाव';

  @override
  String get fcFailed => 'विफल';

  @override
  String get lifeCareer => 'करियर';

  @override
  String get lifeHealth => 'स्वास्थ्य';

  @override
  String get lifeWealth => 'धन';

  @override
  String get lifeFamily => 'परिवार';

  @override
  String get lifeMind => 'मन';

  @override
  String get lifeEgo => 'अहंकार';

  @override
  String get lifeAggression => 'आक्रामकता';

  @override
  String get lifeConflict => 'संघर्ष';

  @override
  String get rashiElement => 'तत्व';

  @override
  String get rashiQuality => 'गुण';

  @override
  String get rashiLuckyColor => 'शुभ रंग';

  @override
  String get rashiLuckyDay => 'शुभ दिन';

  @override
  String get rashiLuckyNumber => 'शुभ अंक';

  @override
  String get rashiGemstone => 'रत्न';

  @override
  String get rashiBody => 'शरीर';

  @override
  String get gocharTodaysTransitChart => 'आज का गोचर चार्ट';

  @override
  String get gocharTransit => 'गोचर';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get best => 'सर्वश्रेष्ठ';

  @override
  String get worst => 'सबसे खराब';

  @override
  String get avg => 'avg';

  @override
  String get favorableLoveWindowsLabel => 'अनुकूल प्रेम अवधि';

  @override
  String get lordLabel => 'स्वामी';

  @override
  String get lordPlacementLabel => 'स्वामी स्थिति';

  @override
  String get lordDignityLabel => 'स्वामी बल';

  @override
  String get categoriesSuffix => 'श्रेणियाँ';

  @override
  String get coreBlockerLabel => 'मुख्य बाधा';

  @override
  String get coreGiftLabel => '✦ मुख्य उपहार';

  @override
  String get coreThemeLabel => '● मुख्य विषय';

  @override
  String dominantLabel(Object value) {
    return 'प्रमुख: $value';
  }

  @override
  String get karakasSuffix => 'कारक';

  @override
  String get protectiveLabel => 'रक्षक';

  @override
  String secondaryLabel(Object value) {
    return ' · द्वितीयक: $value';
  }

  @override
  String get tagCore => 'मुख्य';

  @override
  String get debtScoresHeader => '📉 ऋण स्कोर';

  @override
  String get debtCurrentLoadStat => 'वर्तमान\nऋण भार';

  @override
  String get debtRecoveryCapacityStat => 'उबरने की\nक्षमता';

  @override
  String get debtIntensityStat => 'तीव्रता';

  @override
  String get debtDefaultRiskStat => 'चूक जोखिम';

  @override
  String get debtProfileTitle => 'ऋण प्रोफ़ाइल';

  @override
  String get debtKarmaLabel => 'कर्म';

  @override
  String get debtPersonalityLabel => 'व्यक्तित्व';

  @override
  String get debtPhaseLabel => 'चरण';

  @override
  String get debtPrimaryCategoryLabel => 'मुख्य श्रेणी';

  @override
  String get debtWord => 'ऋण';

  @override
  String get debtYogasTitle => 'ऋण योग';

  @override
  String get debtCreatingLabel => 'ऋण-कारक';

  @override
  String get debtClearingLabel => 'ऋण-मुक्तिकारक';

  @override
  String get yearlyDebtTitle => 'वार्षिक ऋण';

  @override
  String get debtRepaymentTitle => 'चुकौती';

  @override
  String get debtDangerPeriodsTitle => 'जोखिम अवधि';

  @override
  String get debtDefaultPctStat => 'चूक %';

  @override
  String get debtBankruptcyPctStat => 'दिवालिया %';

  @override
  String get debtChronicPctStat => 'दीर्घकालिक %';

  @override
  String get debtResilienceStat => 'सहनशीलता';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'उबरना: $pct% · अवधि: $years वर्ष';
  }

  @override
  String get debtFreeWindowLabel => '🎯 ऋण-मुक्त अवधि';

  @override
  String debtFreeYear(Object year) {
    return 'वर्ष $year';
  }

  @override
  String get legalScoresHeader => '⚖️ कानूनी स्कोर';

  @override
  String get legalVulnerabilityStat => 'कानूनी\nसंवेदनशीलता';

  @override
  String get legalVictoryPotentialStat => 'विजय\nसंभावना';

  @override
  String get legalConflictStat => 'विवाद';

  @override
  String get legalResolutionStat => 'समाधान';

  @override
  String get legalProfileTitle => 'कानूनी प्रोफ़ाइल';

  @override
  String get legalKarmaTypeLabel => 'कर्म प्रकार';

  @override
  String get legalConflictStyleLabel => 'विवाद शैली';

  @override
  String get legalStrategyLabel => 'रणनीति';

  @override
  String get legalCaseDurationLabel => 'मामले की अवधि';

  @override
  String get legalCurrentStatusLabel => 'वर्तमान स्थिति';

  @override
  String get legalWord => 'कानूनी';

  @override
  String get legalYogasTitle => 'कानूनी योग';

  @override
  String get legalDisputePressureLabel => 'विवाद दबाव';

  @override
  String get legalProtectionLabel => 'कानूनी सुरक्षा';

  @override
  String get legalStressTrendTitle => 'कानूनी तनाव';

  @override
  String get legalVisibleEnemiesStat => 'प्रत्यक्ष शत्रु';

  @override
  String get legalHiddenEnemiesStat => 'गुप्त शत्रु';

  @override
  String get legalCriminalRiskStat => 'आपराधिक जोखिम';

  @override
  String get legalFalseAccusationStat => 'झूठा आरोप';

  @override
  String get legalContractKarmaTitle => 'अनुबंध कर्म';

  @override
  String get legalDocumentationLabel => 'दस्तावेज़ीकरण';

  @override
  String get legalFinePrintAwareLabel => 'बारीक शर्तों की जानकारी';

  @override
  String get legalNegotiationSkillLabel => 'वार्ता कौशल';

  @override
  String get legalSignatureCautionLabel => 'हस्ताक्षर सावधानी';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'सहनशीलता: $pct/100';
  }

  @override
  String get legalVictoryWord => 'विजय';

  @override
  String get legalAnalysisSuffix => 'विश्लेषण';

  @override
  String get legalAsPlaintiff => 'वादी के रूप में';

  @override
  String get legalAsDefendant => 'प्रतिवादी के रूप में';

  @override
  String get legalWinProbability => 'जीत की संभावना';

  @override
  String get legalDisputeWord => 'विवाद';

  @override
  String get lifepathScoresHeader => '🌟 जीवन पथ स्कोर';

  @override
  String get lifepathDharmaClarityStat => 'धर्म\nस्पष्टता';

  @override
  String get lifepathFortuneBaselineStat => 'भाग्य\nआधार';

  @override
  String get lifepathCoherenceStat => 'जीवन पथ\nसामंजस्य';

  @override
  String get lifepathKarmaStat => 'कर्म';

  @override
  String get lifepathSpiritualStat => 'आध्यात्मिक';

  @override
  String get lifepathFameStat => 'प्रसिद्धि';

  @override
  String get lifepathSoulContractTitle => 'आत्मा अनुबंध';

  @override
  String get lifepathAtmakarakaLabel => 'आत्मकारक';

  @override
  String get lifepathAkFocusLabel => 'AK केंद्र';

  @override
  String get lifepathSoulPurposeLabel => 'आत्मा उद्देश्य';

  @override
  String get lifepathLifeChapterLabel => 'जीवन अध्याय';

  @override
  String get lifepathPrimaryDomainLabel => 'मुख्य क्षेत्र';

  @override
  String get lifepathLeadershipStat => 'नेतृत्व';

  @override
  String get lifepathWisdomTeachStat => 'ज्ञान/शिक्षण';

  @override
  String get lifepathServiceStat => 'सेवा';

  @override
  String get lifepathHealingStat => 'उपचार';

  @override
  String get lifepathFortuneYogasTitle => 'भाग्य योग';

  @override
  String get lifepathLuckBlocksLabel => 'भाग्य बाधाएँ';

  @override
  String get lifepathFortuneBoostersLabel => 'भाग्य वर्धक';

  @override
  String get lifepathFortuneTrendTitle => 'भाग्य प्रवृत्ति';

  @override
  String get lifepathGoldenWindowsTitle => 'स्वर्णिम अवधि ★';

  @override
  String get lifepathTransformationTitle => 'रूपांतरण';

  @override
  String get lifepathMilestonesTitle => 'जीवन के पड़ाव';

  @override
  String get lifepathKarmicLessonsTitle => 'कार्मिक सीख';

  @override
  String get lifepathRahuGrowthLabel => 'राहु विकास';

  @override
  String get lifepathKetuSurrenderLabel => 'केतु समर्पण';

  @override
  String get lifepathSaturnLessonLabel => 'शनि की सीख';

  @override
  String get lifepathLifeDifficultyLabel => 'जीवन कठिनाई';

  @override
  String get lifepathSoulExperienceTitle => '★ आत्मा अनुभव के लिए आई';

  @override
  String get lifepathBlessingsTitle => '● आशीर्वाद';

  @override
  String get lifepathLifeWord => 'जीवन';

  @override
  String get lifepathArchetypeSuffix => 'मूल स्वरूप';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'पूर्णता: $pct%';
  }

  @override
  String get lifepathDestinyVsWord => 'भाग्य बनाम';

  @override
  String get lifepathFreeWillSuffix => 'स्वतंत्र इच्छा';

  @override
  String get lifepathDestinyStat => 'भाग्य';

  @override
  String get lifepathFreeWillStat => 'स्वतंत्र इच्छा';

  @override
  String get pastlifeScoresHeader => '🔮 पूर्वजन्म स्कोर';

  @override
  String get pastlifeSignatureStrengthStat => 'विशिष्ट\nबल';

  @override
  String get pastlifeCarryForwardStat => 'आगे लाया\nगया';

  @override
  String get pastlifeMasteryPreservedStat => 'संरक्षित\nदक्षता';

  @override
  String get pastlifeUnfinishedStat => 'अधूरा';

  @override
  String get pastlifeKarmicDebtStat => 'कार्मिक ऋण';

  @override
  String get pastlifeProfileTitle => 'पूर्वजन्म प्रोफ़ाइल';

  @override
  String get pastlifeThemeLabel => 'विषय';

  @override
  String get pastlifeProfessionLabel => 'पेशा';

  @override
  String get pastlifeSocialStandingLabel => 'सामाजिक स्थिति';

  @override
  String get pastlifeRegionLabel => 'क्षेत्र';

  @override
  String get pastlifeSpiritualLevelLabel => 'आध्यात्मिक स्तर';

  @override
  String get pastlifeGenderLabel => 'लिंग';

  @override
  String get pastlifeWealthLevelLabel => 'धन स्तर';

  @override
  String get pastlifeFamilyRoleLabel => 'पारिवारिक भूमिका';

  @override
  String get pastlifeSkillsCarriedTitle => '★ आगे लाए गए कौशल';

  @override
  String get pastlifeNaturalAttractionsTitle => '● स्वाभाविक आकर्षण';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ अस्पष्ट भय';

  @override
  String get pastlifeMagneticPullsTitle => '→ चुंबकीय खिंचाव';

  @override
  String get pastlifeRelationshipStat => 'संबंध';

  @override
  String get pastlifeFinancialStat => 'वित्तीय';

  @override
  String get pastlifeServiceStat => 'सेवा';

  @override
  String get pastlifeDharmicStat => 'धार्मिक';

  @override
  String get pastlifeOnRelationsStat => 'संबंधों पर';

  @override
  String get pastlifeOnCareerStat => 'करियर पर';

  @override
  String get pastlifeOnHealthStat => 'स्वास्थ्य पर';

  @override
  String get pastlifeOnSpiritualStat => 'आध्यात्म पर';

  @override
  String get pastlifeKarmicResolutionTitle => 'कार्मिक समाधान';

  @override
  String get pastlifePrimaryPathLabel => 'मुख्य मार्ग';

  @override
  String get pastlifeSecondaryPathLabel => 'द्वितीयक मार्ग';

  @override
  String get pastlifeClearingProgressLabel => 'मुक्ति प्रगति';

  @override
  String get pastlifeRemainingWorkLabel => 'शेष कार्य';

  @override
  String get pastlifeDebtTimelineLabel => 'ऋण समयरेखा';

  @override
  String get pastlifeMemoryAccessStat => 'स्मृति पहुँच';

  @override
  String get pastlifeDreamVisitsStat => 'स्वप्न दर्शन';

  @override
  String get pastlifeDejaVuStat => 'देजा वू';

  @override
  String get pastlifeRegressionFitStat => 'रिग्रेशन अनुकूलता';

  @override
  String get pastlifeActivationTitle => 'पूर्वजन्म सक्रियता';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'परिपक्वता: $maturity · स्थिति: $status';
  }

  @override
  String get pastlifeKetuWord => 'केतु';

  @override
  String get pastlifePastMasterySuffix => 'पूर्व दक्षता';

  @override
  String get pastlifeKetuMasteredLabel => 'केतु · आपने जिसमें दक्षता पाई';

  @override
  String get pastlifeRahuWord => 'राहु';

  @override
  String get pastlifeFutureGrowthSuffix => 'भविष्य विकास';

  @override
  String get pastlifeRahuPullsLabel => 'राहु · जो आपको आगे खींचता है';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ छाया: $shadow';
  }

  @override
  String get mentalScoresHeader => '🧠 मानसिक स्कोर';

  @override
  String get mentalStabilityStat => 'मानसिक\nस्थिरता';

  @override
  String get mentalEmotionalBaselineStat => 'भावनात्मक\nआधार';

  @override
  String get mentalResilienceStat => 'सहनशीलता';

  @override
  String get mentalAnxietyStat => 'चिंता';

  @override
  String get mentalDepressionStat => 'अवसाद';

  @override
  String get mentalRegulationStat => 'नियमन';

  @override
  String get mentalProfileTitle => 'मानसिक प्रोफ़ाइल';

  @override
  String get mentalConstitutionLabel => 'प्रकृति';

  @override
  String get mentalStressDriverLabel => 'तनाव कारक';

  @override
  String get mentalStabilityAnchorLabel => 'स्थिरता आधार';

  @override
  String get mentalStressResponseLabel => 'तनाव प्रतिक्रिया';

  @override
  String get mentalAttachmentStyleLabel => 'लगाव शैली';

  @override
  String get mentalBurnoutStageLabel => 'बर्नआउट चरण';

  @override
  String get mentalWord => 'मानसिक';

  @override
  String get mentalYogasTitle => 'मानसिक योग';

  @override
  String get mentalStressPressureLabel => 'तनाव दबाव';

  @override
  String get mentalWellnessTrendTitle => 'कल्याण प्रवृत्ति';

  @override
  String get mentalHealthyCopingTitle => '✓ स्वस्थ सामना';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ अस्वस्थ जोखिम';

  @override
  String get mentalRecommendedAlternativesTitle => '✦ अनुशंसित विकल्प';

  @override
  String get mentalSleepQualityStat => 'नींद गुणवत्ता';

  @override
  String get mentalSocialSupportStat => 'सामाजिक सहयोग';

  @override
  String get mentalBurnoutVulnStat => 'बर्नआउट जोखिम';

  @override
  String get mentalSelfAwarenessStat => 'आत्म-जागरूकता';

  @override
  String get mentalAnxietyWord => 'चिंता';

  @override
  String get mentalTypesSuffix => 'प्रकार';

  @override
  String get mentalTherapyWord => 'थेरेपी';

  @override
  String get mentalModalityFitSuffix => 'पद्धति अनुकूलता';

  @override
  String get characterScoresHeader => '🔍 चरित्र स्कोर';

  @override
  String get characterStrengthStat => 'चरित्र\nबल';

  @override
  String get characterIntegrityStat => 'सत्यनिष्ठा';

  @override
  String get characterResilienceStat => 'सहनशीलता';

  @override
  String get characterAwarenessStat => 'जागरूकता';

  @override
  String get characterStabilityStat => 'स्थिरता';

  @override
  String get characterEthicsStat => 'नैतिकता';

  @override
  String get characterSurfacePersonalityTitle => 'बाह्य व्यक्तित्व';

  @override
  String get characterLagnaLabel => 'लग्न';

  @override
  String get characterConstitutionLabel => 'प्रकृति';

  @override
  String get characterNakshatraLabel => 'नक्षत्र';

  @override
  String get characterDeityLabel => 'देवता';

  @override
  String get characterMoonManasTitle => 'चंद्र मानस';

  @override
  String get characterSignLabel => 'राशि';

  @override
  String get characterHouseLabel => 'भाव';

  @override
  String get characterWarmthStat => 'स्नेह';

  @override
  String get characterEmpathyStat => 'सहानुभूति';

  @override
  String get characterLoyaltyStat => 'निष्ठा';

  @override
  String get characterBoundariesStat => 'सीमाएँ';

  @override
  String get characterDharmaStat => 'धर्म';

  @override
  String get characterTruthStat => 'सत्य';

  @override
  String get characterCompassionStat => 'करुणा';

  @override
  String get characterGenerosityStat => 'उदारता';

  @override
  String get characterSignatureVirtuesTitle => '★ विशिष्ट गुण';

  @override
  String get characterNaturalTalentsTitle => '● स्वाभाविक प्रतिभाएँ';

  @override
  String get characterShadowPatternsTitle => '⚠ छाया प्रवृत्तियाँ';

  @override
  String get characterYogasTitle => 'चरित्र योग';

  @override
  String get characterTestsLabel => 'परीक्षाएँ';

  @override
  String get characterGiftsLabel => 'उपहार';

  @override
  String get characterSelfAwareEiStat => 'आत्म-जागरूक EI';

  @override
  String get characterSelfRegulateStat => 'आत्म-नियमन';

  @override
  String get characterEmpathyEiStat => 'सहानुभूति EI';

  @override
  String get characterSocialSkillsStat => 'सामाजिक कौशल';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'अनुभूति: $pct%';
  }

  @override
  String get characterAtmakarakaWord => 'आत्मकारक';

  @override
  String get characterSoulSignatureSuffix => 'आत्मा हस्ताक्षर';

  @override
  String get characterAtmakarakaLabel => 'आत्मकारक';

  @override
  String get characterGunaWord => 'गुण';

  @override
  String get characterProfileSuffix => 'प्रोफ़ाइल';

  @override
  String get characterSattvaLabel => 'सत्त्व';

  @override
  String get characterRajasLabel => 'रजस';

  @override
  String get characterTamasLabel => 'तमस';

  @override
  String get healthScoresHeader => '🏥 स्वास्थ्य स्कोर';

  @override
  String get healthVitalityStat => 'ओज';

  @override
  String get healthImmunityStat => 'रोग प्रतिरोधक';

  @override
  String get healthRecoveryStat => 'स्वास्थ्य लाभ';

  @override
  String get healthMentalStat => 'मानसिक';

  @override
  String get healthStressTolStat => 'तनाव सहन';

  @override
  String get healthYogasTitle => 'स्वास्थ्य योग';

  @override
  String get healthDiseasePressureLabel => 'रोग दबाव';

  @override
  String get healthTrendTitle => 'स्वास्थ्य प्रवृत्ति';

  @override
  String get healthRecoveryWindowsTitle => 'स्वास्थ्य लाभ अवधि';

  @override
  String get healthCautionPeriodsTitle => 'सावधानी अवधि';

  @override
  String get healthFertilityStat => 'प्रजनन क्षमता';

  @override
  String get healthBurnoutRiskStat => 'बर्नआउट जोखिम';

  @override
  String get healthAddictionVulnStat => 'व्यसन जोखिम';

  @override
  String get healthWorkLifeBalStat => 'कार्य-जीवन संतुलन';

  @override
  String get healthAyurvedicWord => 'आयुर्वेदिक';

  @override
  String get healthConstitutionSuffix => 'प्रकृति';

  @override
  String get healthBodyWord => 'शरीर';

  @override
  String get healthSystemMapSuffix => 'तंत्र मानचित्र';

  @override
  String get healthBodyZoneWord => 'शरीर क्षेत्र';

  @override
  String get healthVulnerabilitySuffix => 'संवेदनशीलता';

  @override
  String get healthDiseaseWord => 'रोग';

  @override
  String get healthSusceptibilitySuffix => 'प्रवृत्ति';

  @override
  String get healthLifestyleFactorsTitle => 'जीवनशैली कारक';

  @override
  String get healthSleepDisciplineLabel => 'नींद अनुशासन';

  @override
  String get healthDietDisciplineLabel => 'आहार अनुशासन';

  @override
  String get healthExerciseNeedLabel => 'व्यायाम आवश्यकता';

  @override
  String get healthSunlightNeedLabel => 'धूप आवश्यकता';

  @override
  String get healthSocialTypeLabel => 'सामाजिक प्रकार';

  @override
  String get healthHealingSpeedLabel => 'उपचार गति';

  @override
  String get wealthScoresHeader => '💰 धन स्कोर';

  @override
  String get wealthStrengthStat => 'धन\nबल';

  @override
  String get wealthAccumulationStat => 'संचय';

  @override
  String get wealthIncomeFlowStat => 'आय\nप्रवाह';

  @override
  String get wealthSustainStat => 'स्थायित्व';

  @override
  String get wealthMultiStreamStat => 'बहु-स्रोत';

  @override
  String get wealthRetentionStat => 'धारण';

  @override
  String get wealthWord => 'धन';

  @override
  String get wealthYogasTitle => 'धन योग';

  @override
  String get wealthDrainsLabel => 'क्षय';

  @override
  String get wealthBoostersLabel => 'वर्धक';

  @override
  String get wealthYearlyTrendTitle => 'वार्षिक प्रवृत्ति';

  @override
  String get wealthGrowthTitle => 'धन वृद्धि';

  @override
  String get wealthCashPressureTitle => 'नकदी दबाव';

  @override
  String get wealthMoneyPersonalityTitle => 'धन व्यक्तित्व';

  @override
  String get wealthTypeLabel => 'धन प्रकार';

  @override
  String get wealthRiskAppetiteLabel => 'जोखिम रुचि';

  @override
  String get wealthInvestmentStyleLabel => 'निवेश शैली';

  @override
  String get wealthMoneyPersonalityLabel => 'धन व्यक्तित्व';

  @override
  String get wealthSpendingLabel => 'व्यय';

  @override
  String get wealthDebtProbStat => 'ऋण संभावना %';

  @override
  String get wealthInheritanceStat => 'विरासत %';

  @override
  String get wealthSuddenGainsStat => 'आकस्मिक लाभ %';

  @override
  String get wealthSpouseBoostStat => 'जीवनसाथी लाभ %';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'सफलता संभावना: $pct%';
  }

  @override
  String get wealthLifetimeClassLabel => 'जीवनकाल धन वर्ग';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'मुख्य: $value';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'शिखर: $value';
  }

  @override
  String get wealthIncomeWord => 'आय';

  @override
  String get wealthSourcesSuffix => 'स्रोत';

  @override
  String get wealthInvestmentWord => 'निवेश';

  @override
  String get wealthMixSuffix => 'मिश्रण';

  @override
  String wealthDrivenByLabel(Object planet) {
    return '$planet द्वारा संचालित';
  }

  @override
  String get marriageScoresHeader => '💒 विवाह स्कोर';

  @override
  String get marriageOverallStat => 'समग्र\nविवाह';

  @override
  String get marriageHarmonyStat => 'वैवाहिक\nसामंजस्य';

  @override
  String get marriageDomesticStabilityStat => 'घरेलू\nस्थिरता';

  @override
  String get marriageLongevityStat => 'दीर्घायु';

  @override
  String get marriageSatisfactionStat => 'संतुष्टि';

  @override
  String get marriageClarityStat => 'स्पष्टता';

  @override
  String get marriageWindowsTitle => 'विवाह अवधि';

  @override
  String get marriagePhasesTitle => 'विवाह चरण';

  @override
  String get marriageInLawRelationsStat => 'ससुराल संबंध';

  @override
  String get marriageFamilyHarmonyStat => 'पारिवारिक सामंजस्य';

  @override
  String get marriageFertilityStat => 'प्रजनन क्षमता';

  @override
  String get marriageHomeOwnershipStat => 'गृह स्वामित्व';

  @override
  String get marriageDivorceRiskStat => 'तलाक जोखिम';

  @override
  String get marriageInfidelityStat => 'बेवफाई';

  @override
  String get marriageConflictStat => 'विवाद';

  @override
  String get marriageDistanceStat => 'दूरी';

  @override
  String get marriageSeekInPartnerTitle => '★ साथी में तलाशें';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ साथी में टालें';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'अनुभूति: $pct%';
  }

  @override
  String get marriageDarakarakaWord => 'दाराकारक';

  @override
  String get marriageSpouseKarakaSuffix => 'जीवनसाथी कारक';

  @override
  String get marriageDarakarakaDkLabel => 'दाराकारक (DK)';

  @override
  String get marriage7thWord => 'सप्तम';

  @override
  String get marriageSignLabel => 'राशि';

  @override
  String get marriageLordInLabel => 'स्वामी स्थित';

  @override
  String get marriageStrengthLabel => 'बल';

  @override
  String get marriageSpouseWord => 'जीवनसाथी';

  @override
  String get marriageProfileSuffix => 'प्रोफ़ाइल';

  @override
  String get marriageSpouseTraitsTitle => '★ जीवनसाथी गुण';

  @override
  String get marriageLikelyProfessionsTitle => '● संभावित पेशे';

  @override
  String get marriageHarmonyWord => 'सामंजस्य';

  @override
  String get marriageRadarSuffix => 'रडार';

  @override
  String get marriagePhysicalLabel => 'शारीरिक';

  @override
  String get marriageSharedValuesLabel => 'साझा मूल्य';

  @override
  String get marriageConflictResolutionLabel => 'विवाद समाधान';

  @override
  String get marriageMangalDoshLabel => '⚠ मंगल दोष';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'गंभीरता: $value';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'निवारण: $value';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'नवांश';

  @override
  String get multiChartTitleChild => 'संतान';

  @override
  String get multiChartTitleLove => 'प्रेम';

  @override
  String get multiChartTitleKarma => 'कर्म';

  @override
  String get multiChartTitleDefault => 'बहु-कुंडली';

  @override
  String get multiChartSuffixProbability => 'संभावना';

  @override
  String get multiChartSuffixCompatibility => 'अनुकूलता';

  @override
  String get multiChartSuffixLinkage => 'जुड़ाव';

  @override
  String get multiChartSuffixReport => 'रिपोर्ट';

  @override
  String get multiChartParticipantsLabel => 'प्रतिभागी';

  @override
  String get multiChartAnalysisWord => 'विश्लेषण';

  @override
  String get multiChartConfidenceSuffix => 'विश्वसनीयता';

  @override
  String get multiChartQualityBadge => 'गुणवत्ता';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'इस वैदिक ज्योतिष रिपोर्ट का विश्लेषण करें और विस्तृत जानकारी दें:\n\n$formatted';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'यह एक वैदिक ज्योतिष विशेषज्ञ रिपोर्ट है। कृपया इसका गहन विश्लेषण करें और व्यावहारिक सुझाव दें:\n\n$formatted';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'इस वैदिक ज्योतिष विश्लेषण की समीक्षा करें और मुख्य निष्कर्षों को सरल भाषा में समझाएँ:\n\n$formatted';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return '$label के लिए कॉपी किया गया!';
  }

  @override
  String get childProbTitle1 => 'संतान';

  @override
  String get childProbTitle2 => 'संभावना';

  @override
  String get childNumberOfChildrenHeader1 => 'संतानों की';

  @override
  String get childNumberOfChildrenHeader2 => 'संख्या';

  @override
  String get childTimingHeader1 => 'समय';

  @override
  String get childTimingHeader2 => 'मूल दशा';

  @override
  String get child5thHouseHeader1 => 'पंचम भाव';

  @override
  String get analysisWord => 'विश्लेषण';

  @override
  String get jupiterWord => 'गुरु';

  @override
  String get childD7Header1 => 'D7 सप्तांश';

  @override
  String get childBeejaHeader1 => 'बीज व क्षेत्र';

  @override
  String get childBeejaHeader2 => 'स्फुट';

  @override
  String get childDoshaHeader1 => 'दोष';

  @override
  String get childVedicHeader1 => 'वैदिक';

  @override
  String get childVedicHeader2 => 'उपाय';

  @override
  String get progenyProbabilityLabel => 'संतान संभावना';

  @override
  String get favorableWindowsLabel => 'अनुकूल अवधि';

  @override
  String get partnerOneLabel => 'साथी 1';

  @override
  String get partnerTwoLabel => 'साथी 2';

  @override
  String get moonSignLabel => 'चंद्र राशि';

  @override
  String get lordInDusthana => 'स्वामी दुःस्थान में';

  @override
  String get lordStrengthLabel => 'स्वामी बल';

  @override
  String get houseStrengthLabel => 'भाव बल';

  @override
  String get dignityLabel => 'बल';

  @override
  String get directBadge => 'मार्गी';

  @override
  String get notCombustBadge => 'अस्त नहीं';

  @override
  String get in5thHouseBadge => 'पंचम भाव में';

  @override
  String get aspects5thBadge => 'पंचम पर दृष्टि';

  @override
  String get no5thConnectionBadge => 'पंचम से कोई संबंध नहीं';

  @override
  String jupiterInSignHeading(String sign) {
    return '$sign में गुरु';
  }

  @override
  String get d7LagnaLabel => 'D7 लग्न';

  @override
  String get d7FifthSignLabel => 'D7 पंचम राशि';

  @override
  String get d7FifthLordLabel => 'D7 पंचम स्वामी';

  @override
  String get jupiterInD7Label => 'D7 में गुरु';

  @override
  String get jupiterDignityLabel => 'गुरु बल';

  @override
  String get d7StrengthLabel => 'D7 बल';

  @override
  String get yesWord => 'हाँ';

  @override
  String get noWord => 'नहीं';

  @override
  String get beejaSphutaTitle => 'बीज स्फुट';

  @override
  String get kshetraSphutaTitle => 'क्षेत्र स्फुट';

  @override
  String get degreeLabel => 'अंश';

  @override
  String get signLordLabel => 'राशि स्वामी';

  @override
  String get presentInLabel => 'स्थित है';

  @override
  String get netPenaltyLabel => 'कुल दंड';

  @override
  String get remedyGemstone => 'रत्न उपाय';

  @override
  String get remedyMantra => 'मंत्र उपाय';

  @override
  String get remedyRitual => 'अनुष्ठान उपाय';

  @override
  String get remedyLifestyle => 'जीवनशैली उपाय';

  @override
  String get remedyCharitable => 'दान उपाय';

  @override
  String copiedForName(String name) {
    return '$name के लिए कॉपी किया गया!';
  }

  @override
  String get mahadashaLabel => 'महादशा';

  @override
  String get mdPeriodLabel => 'MD अवधि';

  @override
  String get antardashaLabel => 'अंतर्दशा';

  @override
  String get adPeriodLabel => 'AD अवधि';

  @override
  String get pratyantardashaLabel => 'प्रत्यंतर्दशा';

  @override
  String get favorabilityLabel => 'अनुकूलता';

  @override
  String factorPrefix(String factor) {
    return 'कारक: $factor';
  }

  @override
  String appliesToLabel(String value) {
    return 'लागू: $value';
  }

  @override
  String get qualityTag => 'गुणवत्ता';

  @override
  String get reliabilityVeryHigh => 'अत्यधिक विश्वसनीय';

  @override
  String get reliabilityGuidanceLevel => 'मार्गदर्शन-स्तर पठन';

  @override
  String get karmaLinkTitle1 => 'कर्म';

  @override
  String get karmaLinkTitle2 => 'जुड़ाव';

  @override
  String get karmaFoundationHeader1 => 'कार्मिक';

  @override
  String get karmaFoundationHeader2 => 'आधार';

  @override
  String get karmaPairwiseHeader1 => 'युग्मवार';

  @override
  String get karmaPairwiseHeader2 => 'जुड़ाव';

  @override
  String get karmaGroupHeader1 => 'समूह';

  @override
  String get karmaGroupHeader2 => 'पैटर्न';

  @override
  String get karmaPastLifeHeader1 => 'पूर्वजन्म';

  @override
  String get karmaPastLifeHeader2 => 'लक्ष्य';

  @override
  String get karmaCurrentLifeHeader1 => 'वर्तमान जीवन';

  @override
  String get karmaCurrentLifeHeader2 => 'सीख';

  @override
  String get karmaDebtsHeader2 => 'ऋण';

  @override
  String get karmaMoolaDashaHeader1 => 'मूल दशा';

  @override
  String get karmaMoolaDashaHeader2 => 'समय';

  @override
  String get karmaDeepAuditHeader1 => 'गहन ऑडिट';

  @override
  String get karmaDeepAuditHeader2 => 'तालिका';

  @override
  String get karmaHeroLabel => 'पूर्वजन्म कर्म जुड़ाव';

  @override
  String get karmaKetuMastery => 'केतु दक्षता';

  @override
  String get nakshatraLabel => 'नक्षत्र';

  @override
  String get deityLabel => 'देवता';

  @override
  String get masteryScoreLabel => 'दक्षता स्कोर';

  @override
  String get karmaRahuGrowth => 'राहु विकास';

  @override
  String get growthScoreLabel => 'विकास स्कोर';

  @override
  String get karmaAtmakaraka => 'आत्मकारक';

  @override
  String get karmaSaturnKarma => 'शनि कर्म';

  @override
  String get karma12thHouse => 'द्वादश भाव';

  @override
  String get karma9thHousePunya => 'नवम भाव पुण्य';

  @override
  String get bhavaScoreLabel => 'भाव स्कोर';

  @override
  String get karmaD60Signature => 'D60 विशिष्टता';

  @override
  String get depthScoreLabel => 'गहनता स्कोर';

  @override
  String get linkageStrengthLabel => 'जुड़ाव बल';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'जुड़ाव कारक ($count सक्रिय)';
  }

  @override
  String get factorColumnLabel => 'कारक';

  @override
  String get weightColumnLabel => 'भार';

  @override
  String get meaningColumnLabel => 'अर्थ';

  @override
  String get statusColumnLabel => 'स्थिति';

  @override
  String get karmaPastLifeConnection => 'पूर्वजन्म संबंध';

  @override
  String get karmaCurrentLifeDynamic => 'वर्तमान जीवन गतिशीलता';

  @override
  String get karmaWhatTheyTeach => 'वे एक-दूसरे को क्या सिखाते हैं';

  @override
  String get karmaGroupThemeHeader => 'समूह कार्मिक विषय';

  @override
  String get karmaSharedSettingHeader => 'साझा पूर्वजन्म परिवेश';

  @override
  String get karmaCollectiveKetuHeader => 'सामूहिक केतु पैटर्न';

  @override
  String get karmaCollectiveRahuHeader => 'सामूहिक राहु पैटर्न';

  @override
  String get housesPrefixLabel => 'भाव: ';

  @override
  String get signsPrefixLabel => 'राशियाँ: ';

  @override
  String get karmicCohesionLabel => 'कार्मिक एकता';

  @override
  String get karmaGroupSoulContractHeader => 'समूह आत्मा अनुबंध';

  @override
  String get goalLabel => 'लक्ष्य';

  @override
  String get karmaSharedGoalHeader => 'साझा पूर्वजन्म लक्ष्य';

  @override
  String get howToGrowHeader => 'कैसे विकसित हों';

  @override
  String moolaDashaPrefix(String value) {
    return 'मूल दशा: $value';
  }

  @override
  String get karmaSharedLessonHeader => 'साझा समूह सीख';

  @override
  String get karmaMutualTeachingHeader => 'परस्पर शिक्षण मानचित्र';

  @override
  String get karmaTeachingDynamicsPlaceholder =>
      'कार्मिक संबंध गहराने के साथ शिक्षण गतिशीलता उभरेगी।';

  @override
  String get typeFieldLabel => 'प्रकार';

  @override
  String get basisFieldLabel => 'आधार';

  @override
  String get resolutionPathHeader => 'समाधान मार्ग';

  @override
  String dashaTimingPrefix(String value) {
    return 'दशा समय: $value';
  }

  @override
  String get mutualDebtsHeader => 'परस्पर ऋण';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'तिथियाँ';

  @override
  String get groupKarmicWindowHeader => 'समूह कार्मिक अवधि';

  @override
  String parametersAuditedHeading(int count) {
    return '$count मापदंड ऑडिट किए गए';
  }

  @override
  String get valuePrefixLabel => 'मान: ';

  @override
  String weightPrefix(String value) {
    return 'भार: $value';
  }

  @override
  String get loveCompatTitle1 => 'प्रेम';

  @override
  String get loveCompatTitle2 => 'अनुकूलता';

  @override
  String get loveAttractionHeader1 => 'आकर्षण व';

  @override
  String get loveAttractionHeader2 => 'रसायन';

  @override
  String get loveEmotionalHeader1 => 'भावनात्मक';

  @override
  String get loveEmotionalHeader2 => 'सामंजस्य';

  @override
  String get loveMentalHeader1 => 'मानसिक';

  @override
  String get loveMentalHeader2 => 'तालमेल';

  @override
  String get lovePassionHeader1 => 'जुनून व';

  @override
  String get lovePassionHeader2 => 'शारीरिक';

  @override
  String get loveLongtermHeader1 => 'दीर्घकालिक';

  @override
  String get loveKarmicHeader1 => 'कार्मिक प्रेम';

  @override
  String get loveKarmicHeader2 => 'बंधन';

  @override
  String get loveChallengesHeader1 => 'चुनौतियाँ व';

  @override
  String get loveChallengesHeader2 => 'टकराव';

  @override
  String get loveTimingHeader1 => 'प्रेम समय';

  @override
  String get loveRelationshipHeader1 => 'संबंध';

  @override
  String get loveRelationshipHeader2 => 'गतिशीलता';

  @override
  String get loveRemediesHeader1 => 'उपाय व';

  @override
  String get loveRemediesHeader2 => 'मार्गदर्शन';

  @override
  String get loveCompatHeroLabel => 'प्रेम अनुकूलता';

  @override
  String get loveChipAttraction => 'आकर्षण';

  @override
  String get loveChipPassion => 'जुनून';

  @override
  String get loveChipChallenge => 'चुनौती';

  @override
  String get venusSignLabel => 'शुक्र राशि';

  @override
  String get attractionScoreLabel => 'आकर्षण स्कोर';

  @override
  String get activeContactsLabel => 'सक्रिय संपर्क';

  @override
  String get magneticPullLabel => 'चुंबकीय खिंचाव';

  @override
  String get initialAttractionLabel => 'प्रारंभिक आकर्षण';

  @override
  String get emotionalScoreLabel => 'भावनात्मक स्कोर';

  @override
  String get elementMatchLabel => 'तत्व मेल';

  @override
  String get harmonyLabel => 'सामंजस्य';

  @override
  String get kootaYoni => 'योनि';

  @override
  String get kootaGana => 'गण';

  @override
  String get kootaTara => 'तारा';

  @override
  String get doshaPresentBadge => 'दोष मौजूद';

  @override
  String get noDoshaBadge => 'कोई दोष नहीं';

  @override
  String get axisLabel => 'अक्ष';

  @override
  String get mentalScoreLabel => 'मानसिक स्कोर';

  @override
  String get mercuryDynamicsLabel => 'बुध गतिशीलता';

  @override
  String get communicationStyleLabel => 'संवाद शैली मेल';

  @override
  String get intellectualConnectionLabel => 'बौद्धिक जुड़ाव';

  @override
  String get passionScoreLabel => 'जुनून स्कोर';

  @override
  String get marsVenusLabel => 'मंगल-शुक्र परस्पर क्रिया';

  @override
  String get physicalChemistryLabel => 'शारीरिक रसायन';

  @override
  String get yoniCompatLabel => 'योनि अनुकूलता';

  @override
  String get longtermScoreLabel => 'दीर्घकालिक स्कोर';

  @override
  String get seventhHouseSynastryLabel => 'सप्तम भाव सिनैस्ट्री';

  @override
  String get commitmentPotentialLabel => 'प्रतिबद्धता संभावना';

  @override
  String get jupiterBlessingLabel => 'गुरु आशीर्वाद';

  @override
  String get d9NavamsaResonanceLabel => 'D9 नवांश तालमेल';

  @override
  String get saturnLongevityLabel => 'शनि दीर्घायु';

  @override
  String get karmicScoreLabel => 'कार्मिक स्कोर';

  @override
  String get darakarakaLinkLabel => 'दाराकारक जुड़ाव';

  @override
  String get sourceLabel => 'स्रोत';

  @override
  String get emotionalGiverReceiverLabel => 'भावनात्मक दाता / ग्रहीता';

  @override
  String get powerBalanceLabel => 'शक्ति संतुलन';

  @override
  String get growthDynamicLabel => 'विकास गतिशीलता';

  @override
  String get addressesLabel => 'संबोधित करता है';

  @override
  String get loveScoresLabel => 'प्रेम स्कोर';

  @override
  String get loveCapacityLabel => 'प्रेम\nक्षमता';

  @override
  String get emotionalAvailabilityLabel => 'भावनात्मक\nउपलब्धता';

  @override
  String get romanticAttractionLabel => 'रोमांटिक\nआकर्षण';

  @override
  String get commitmentWord => 'प्रतिबद्धता';

  @override
  String get intimacyWord => 'घनिष्ठता';

  @override
  String get fidelityWord => 'निष्ठा';

  @override
  String get loveProfileTitle => 'प्रेम प्रोफ़ाइल';

  @override
  String get loveStyleLabel => 'प्रेम शैली';

  @override
  String get attractionStyleLabel => 'आकर्षण शैली';

  @override
  String get lovePathLabel => 'प्रेम मार्ग';

  @override
  String get currentPhaseLabel => 'वर्तमान चरण';

  @override
  String get commitmentStyleLabel => 'प्रतिबद्धता शैली';

  @override
  String get loveWord => 'प्रेम';

  @override
  String get karakasWord => 'कारक';

  @override
  String get attractedToLabel => 'किसकी ओर आकर्षित';

  @override
  String get whatPartnerSeesLabel => 'साथी क्या देखता है';

  @override
  String get romancePatternTitle => 'रोमांस पैटर्न';

  @override
  String get firstLoveAgeLabel => 'पहला प्रेम आयु';

  @override
  String get relationshipCountLabel => 'संबंधों की संख्या';

  @override
  String get avgDurationLabel => 'औसत अवधि';

  @override
  String get breakupTriggerLabel => 'ब्रेकअप कारण';

  @override
  String get heartbreakRecoveryLabel => 'दिल टूटने से उबरना';

  @override
  String get loveTrendTitle => 'प्रेम प्रवृत्ति';

  @override
  String get newLoveWindowsTitle => 'नया प्रेम अवधि';

  @override
  String get loveBlocksTitle => 'प्रेम बाधाएँ';

  @override
  String get activeBlocksLabel => 'सक्रिय बाधाएँ';

  @override
  String get loveMarriagePctLabel => 'प्रेम विवाह %';

  @override
  String get heartbreakVulnLabel => 'दिल टूटने का जोखिम';

  @override
  String get selfSabotageLabel => 'आत्म-हानि';

  @override
  String get emotionalIqLabel => 'भावनात्मक IQ';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'पूर्णता: $pct%';
  }

  @override
  String get languagesWord => 'भाषाएँ';

  @override
  String get givesLabel => 'देता है';

  @override
  String get receivesLabel => 'पाता है';

  @override
  String get idealWord => 'आदर्श';

  @override
  String get partnerWord => 'साथी';

  @override
  String get seekTheseTraitsLabel => 'इन गुणों को तलाशें';

  @override
  String get dealbreakersLabel => 'अस्वीकार्य बातें';

  @override
  String get propertyScoresLabel => 'संपत्ति स्कोर';

  @override
  String get acquisitionCapacityLabel => 'अर्जन\nक्षमता';

  @override
  String get homeOwnershipPctLabel => 'गृह\nस्वामित्व %';

  @override
  String get reWealthPotentialLabel => 'रियल एस्टेट धन\nसंभावना';

  @override
  String get rentalWord => 'किराया';

  @override
  String get vehiclesWord => 'वाहन';

  @override
  String get landPctLabel => 'भूमि %';

  @override
  String get propertyProfileTitle => 'संपत्ति प्रोफ़ाइल';

  @override
  String get karmaTypeLabel => 'कर्म प्रकार';

  @override
  String get environmentLabel => 'परिवेश';

  @override
  String get styleLabel => 'शैली';

  @override
  String get sizeLabel => 'आकार';

  @override
  String get locationLabel => 'स्थान';

  @override
  String get actionNext12mLabel => 'अगले 12 माह में कार्रवाई';

  @override
  String get propertyWord => 'संपत्ति';

  @override
  String get propertyYogasTitle => 'संपत्ति योग';

  @override
  String get drainsLabel => 'क्षय';

  @override
  String get boostersLabel => 'वर्धक';

  @override
  String get propertyTrendTitle => 'संपत्ति प्रवृत्ति';

  @override
  String get buyingWindowsTitle => 'खरीद अवधि';

  @override
  String get constructionWindowsTitle => 'निर्माण अवधि';

  @override
  String get maternalInherPctLabel => 'मातृ विरासत %';

  @override
  String get paternalInherPctLabel => 'पितृ विरासत %';

  @override
  String get multiHomePctLabel => 'बहु-गृह %';

  @override
  String get investmentPctLabel => 'निवेश %';

  @override
  String get vehicleProfileTitle => 'वाहन प्रोफ़ाइल';

  @override
  String get countLabel => 'संख्या';

  @override
  String get firstAgeLabel => 'पहली आयु';

  @override
  String get categoryLabel => 'श्रेणी';

  @override
  String get luxuryLabel => 'विलासिता';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'जीवनकाल संख्या: $count · पूर्णता: $pct%';
  }

  @override
  String get pressureWord => 'दबाव';

  @override
  String get protectionWord => 'सुरक्षा';

  @override
  String get astrologicalWord => 'ज्योतिषीय';

  @override
  String get keyRisksHeader1 => 'मुख्य';

  @override
  String get keyRisksHeader2 => 'जोखिम';

  @override
  String get reportCopiedShort => 'रिपोर्ट कॉपी हुई!';

  @override
  String get keyScoresLabel => 'मुख्य स्कोर';

  @override
  String allScoresCountLabel(int count) {
    return 'सभी स्कोर ($count)';
  }

  @override
  String get windowsWord => 'अवधि';

  @override
  String get genericFailedMsg => 'विफल';

  @override
  String get unknownWord => 'अज्ञात';

  @override
  String selectKarmaChartsLabel(int max) {
    return '2-$max कुंडलियाँ चुनें';
  }

  @override
  String selectChartsLabelCount(int max) {
    return '$max कुंडलियाँ चुनें';
  }

  @override
  String runningAnalysisLabel(String label) {
    return '$label विश्लेषण चल रहा है...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'कार्मिक संबंध विश्लेषण हेतु 2 से $max कुंडलियाँ चुनें';
  }

  @override
  String get pickMaleFemaleHint => 'एक पुरुष और एक स्त्री कुंडली चुनें';

  @override
  String get personOneLabel => 'व्यक्ति 1';

  @override
  String get personTwoLabel => 'व्यक्ति 2';

  @override
  String get analysisFailedMsg => 'विश्लेषण विफल';

  @override
  String analyzeChartsCountLabel(int count) {
    return '$count कुंडलियों का विश्लेषण करें';
  }

  @override
  String get contextGeneralLabel => 'सामान्य';

  @override
  String get contextLoveLabel => 'प्रेम';

  @override
  String get contextBusinessLabel => 'व्यवसाय';

  @override
  String get contextFamilyLabel => 'परिवार';

  @override
  String get contextTeamLabel => 'टीम';

  @override
  String get contextFriendshipLabel => 'मित्रता';

  @override
  String get relationshipIntelTitle => 'संबंध बुद्धिमत्ता';

  @override
  String analyzingChartsCountLabel(int count) {
    return '$count कुंडलियों का विश्लेषण हो रहा है...';
  }

  @override
  String get relationshipContextLabel => 'संबंध संदर्भ';

  @override
  String get kundliMilanReportTitle => 'कुंडली मिलान रिपोर्ट';

  @override
  String get runningMilanAnalysisLabel => 'मिलान विश्लेषण चल रहा है...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '$count/2 चयनित';
  }

  @override
  String get runMilanAnalysisBtn => 'मिलान विश्लेषण चलाएँ';

  @override
  String get noChartsCreateFirst => 'कोई कुंडली नहीं। पहले जन्म कुंडली बनाएँ।';

  @override
  String get selectBirthChartAnalyze => 'विश्लेषण हेतु एक जन्म कुंडली चुनें';

  @override
  String get doshAnalysis => 'दोष विश्लेषण';

  @override
  String doshActiveCount(Object active, Object total) {
    return '$active सक्रिय / $total जाँचे गए';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '$active सक्रिय / $total योग जाँचे गए';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'सक्रिय योग ($count)';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'निष्क्रिय योग छिपाएँ ($count)';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'निष्क्रिय योग दिखाएँ ($count)';
  }

  @override
  String get loadFailed => 'विफल';

  @override
  String dashaDrillMd(Object planet) {
    return '$planet MD → अंतर्दशाएँ';
  }

  @override
  String dashaDrillAd(Object planet) {
    return '$planet AD → प्रत्यंतर्दशाएँ';
  }

  @override
  String dashaDrillPd(Object planet) {
    return '$planet PD → सूक्ष्मदशाएँ';
  }

  @override
  String dashaDrillSub(Object planet) {
    return '$planet उप-अवधियाँ';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return 'जन्म स्वामी: $lord • शेष: $balance वर्ष';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'लग्न: $lagna • शेष: $balance वर्ष';
  }

  @override
  String dashaYearsValue(Object years) {
    return '$years वर्ष';
  }

  @override
  String get dashaCurrentPeriod => 'वर्तमान दशा अवधि';

  @override
  String dashaAsOf(Object date) {
    return 'तिथि अनुसार: $date';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'वर्तमान अवधि में सक्रिय योग ($count)';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'वर्तमान अवधि में सक्रिय दोष ($count)';
  }

  @override
  String get dashaNoYogasTriggered => 'कोई योग सक्रिय नहीं';

  @override
  String get dashaNoDoshasTriggered => 'कोई दोष सक्रिय नहीं';

  @override
  String get divD1Name => 'राशि (D-1)';

  @override
  String get divD1Desc => 'भौतिक अस्तित्व, सभी विषय';

  @override
  String get divD2Name => 'होरा (D-2)';

  @override
  String get divD2Desc => 'धन, संपत्ति';

  @override
  String get divD3Name => 'द्रेक्काण (D-3)';

  @override
  String get divD3Desc => 'भाई-बहन, साहस';

  @override
  String get divD4Name => 'चतुर्थांश (D-4)';

  @override
  String get divD4Desc => 'संपत्ति, निवास, भाग्य';

  @override
  String get divD5Name => 'पंचमांश (D-5)';

  @override
  String get divD5Desc => 'यश, अधिकार, शक्ति';

  @override
  String get divD6Name => 'षष्ठांश (D-6)';

  @override
  String get divD6Desc => 'स्वास्थ्य समस्याएँ';

  @override
  String get divD7Name => 'सप्तांश (D-7)';

  @override
  String get divD7Desc => 'संतान, पौत्र-पौत्री';

  @override
  String get divD8Name => 'अष्टांश (D-8)';

  @override
  String get divD8Desc => 'आकस्मिक संकट, मुकदमा';

  @override
  String get divD9Name => 'नवांश (D-9)';

  @override
  String get divD9Desc => 'विवाह, जीवनसाथी, धर्म';

  @override
  String get divD10Name => 'दशांश (D-10)';

  @override
  String get divD10Desc => 'करियर, पेशा';

  @override
  String get divD11Name => 'रुद्रांश (D-11)';

  @override
  String get divD11Desc => 'मृत्यु, विनाश';

  @override
  String get divD12Name => 'द्वादशांश (D-12)';

  @override
  String get divD12Desc => 'माता-पिता, रक्त-संबंधी';

  @override
  String get divD16Name => 'षोडशांश (D-16)';

  @override
  String get divD16Desc => 'वाहन, सुख-सुविधाएँ, भोग';

  @override
  String get divD20Name => 'विंशांश (D-20)';

  @override
  String get divD20Desc => 'आध्यात्मिक विषय, धार्मिक';

  @override
  String get divD24Name => 'चतुर्विंशांश (D-24)';

  @override
  String get divD24Desc => 'अध्ययन, ज्ञान, शिक्षा';

  @override
  String get divD27Name => 'नक्षत्रांश (D-27)';

  @override
  String get divD27Desc => 'शक्तियाँ, कमज़ोरियाँ, स्वभाव';

  @override
  String get divD30Name => 'त्रिंशांश (D-30)';

  @override
  String get divD30Desc => 'दोष, अवचेतन, दंड';

  @override
  String get divD40Name => 'खवेदांश (D-40)';

  @override
  String get divD40Desc => 'शुभ/अशुभ (मातृ पक्ष)';

  @override
  String get divD45Name => 'अक्षवेदांश (D-45)';

  @override
  String get divD45Desc => 'सभी विषय (पितृ पक्ष)';

  @override
  String get divD60Name => 'षष्ट्यांश (D-60)';

  @override
  String get divD60Desc => 'पूर्वजन्म कर्म — सर्वाधिक महत्वपूर्ण';

  @override
  String get lifeAreaCareer => 'करियर';

  @override
  String get lifeAreaWealth => 'धन';

  @override
  String get lifeAreaMarriage => 'विवाह';

  @override
  String get lifeAreaHealth => 'स्वास्थ्य';

  @override
  String get lifeAreaSpirituality => 'आध्यात्म';

  @override
  String lifeAreaGrade(Object grade) {
    return 'ग्रेड: $grade';
  }

  @override
  String get lifeAreaFactorsLabel => 'कारक:';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return 'नक्षत्र: $nakshatra ($pada)';
  }

  @override
  String planetNakLord(Object lord) {
    return 'नक्षत्र स्वामी: $lord';
  }

  @override
  String planetLongitude(Object value) {
    return 'देशांतर: $value°';
  }

  @override
  String get chakraOverallHealth => 'समग्र स्वास्थ्य';

  @override
  String get careerWord => 'करियर';

  @override
  String get failedToLoad => 'लोड करने में विफल';

  @override
  String get kundliAscendantLagna => 'लग्न (Ascendant)';

  @override
  String get kundliMoonSignRashi => 'चंद्र राशि (Rashi)';

  @override
  String get kundliSunSign => 'सूर्य राशि';

  @override
  String kundliEngineLabel(Object engine) {
    return 'इंजन: $engine';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return 'अंश: $degree°  •  नक्षत्र: $nakshatra ($pada)';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'नक्षत्र स्वामी: $lord  •  बल: $dignity';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return '$base कुंडली — $sign';
  }

  @override
  String kundliBaseChart(Object base) {
    return '$base कुंडली';
  }

  @override
  String get careerSummary => 'करियर सारांश';

  @override
  String get phase => 'चरण';

  @override
  String get confidenceLabel => 'विश्वास';

  @override
  String get careerScores => 'करियर स्कोर';

  @override
  String get stabilityLabel => 'स्थिरता';

  @override
  String get growthLabel => 'वृद्धि';

  @override
  String get gradeExcellent => 'उत्कृष्ट';

  @override
  String get gradeGood => 'अच्छा';

  @override
  String get gradeAverage => 'औसत';

  @override
  String get gradeBelowAvg => 'औसत से नीचे';

  @override
  String get gradeWeak => 'कमज़ोर';

  @override
  String get careerTypeDomain => 'करियर प्रकार और क्षेत्र';

  @override
  String get careerTimeline => 'करियर समयरेखा';

  @override
  String dashaLabel(Object dasha) {
    return 'दशा: $dasha';
  }

  @override
  String get improvementSuggestions => 'सुधार सुझाव';

  @override
  String get chartDetails => 'कुंडली विवरण';

  @override
  String get keyHousesCareer => 'मुख्य भाव (करियर)';

  @override
  String get keyCareerPlanets => 'मुख्य करियर ग्रह';

  @override
  String get empty => 'खाली';

  @override
  String get guna => 'गुण';

  @override
  String get dasha => 'दशा';

  @override
  String get satwik => 'सात्विक';

  @override
  String get rajasik => 'राजसिक';

  @override
  String get tamasik => 'तामसिक';

  @override
  String get charGroupCorePersonality => 'मूल व्यक्तित्व';

  @override
  String get charGroupTrustHonesty => 'विश्वास और ईमानदारी';

  @override
  String get charGroupLoyaltyCommitment => 'वफ़ादारी और प्रतिबद्धता';

  @override
  String get charGroupStrategicPrivacy => 'रणनीतिक और निजता';

  @override
  String get charGroupFinancial => 'वित्तीय';

  @override
  String get charGroupAngerConflict => 'क्रोध और संघर्ष';

  @override
  String get charGroupMoralDharmic => 'नैतिक और धार्मिक';

  @override
  String get charGroupIntellectCommunication => 'बुद्धि और संचार';

  @override
  String get charGroupEmotionalProfile => 'भावनात्मक प्रोफ़ाइल';

  @override
  String get charGroupMentalHealth => 'मानसिक स्वास्थ्य';

  @override
  String get charGroupRomantic => 'रोमांटिक';

  @override
  String get charGroupMarriageFamily => 'विवाह और परिवार';

  @override
  String get charGroupOverallLife => 'समग्र जीवन';

  @override
  String get grahaDrishti => 'ग्रह दृष्टि (ग्रहों की दृष्टि)';

  @override
  String get grahaDrishtiSubtitle => 'कौन किस पर दृष्टि डालता है (%)';

  @override
  String get lagnaAspectsReceived => 'लग्न पर प्राप्त दृष्टि';

  @override
  String get rashiDrishti => 'राशि दृष्टि (राशियों की दृष्टि)';

  @override
  String get shadbalaRupas => 'रूप';

  @override
  String get bhavaHouse1 => 'स्वयं / शरीर';

  @override
  String get bhavaHouse2 => 'धन / परिवार';

  @override
  String get bhavaHouse3 => 'भाई-बहन / साहस';

  @override
  String get bhavaHouse4 => 'घर / माता';

  @override
  String get bhavaHouse5 => 'संतान / बुद्धि';

  @override
  String get bhavaHouse6 => 'शत्रु / स्वास्थ्य';

  @override
  String get bhavaHouse7 => 'विवाह / जीवनसाथी';

  @override
  String get bhavaHouse8 => 'आयु';

  @override
  String get bhavaHouse9 => 'भाग्य / गुरु';

  @override
  String get bhavaHouse10 => 'करियर / पिता';

  @override
  String get bhavaHouse11 => 'लाभ / मित्र';

  @override
  String get bhavaHouse12 => 'हानि / मोक्ष';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '$sign • स्वामी: $lord';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: $value';
  }

  @override
  String get sarvaAshtakavarga => 'सर्व अष्टकवर्ग (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'कुल: $total रेखाएँ (औसत राशि = $avg)';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '$planet — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'कुल: $total रेखाएँ • जन्म राशि पर: $score';
  }

  @override
  String get today => 'आज';

  @override
  String gocharTransitScores(Object date) {
    return 'गोचर (गोचर स्कोर) — $date';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'जातक का चंद्र: $sign';
  }

  @override
  String get gocharBest => 'सर्वश्रेष्ठ';

  @override
  String get gocharWorst => 'सबसे खराब';

  @override
  String copiedOpening(Object ai) {
    return 'कॉपी हुआ! $ai खुल रहा है...';
  }

  @override
  String get openLink => 'खोलें ↗';

  @override
  String get discussReportWithAI => 'इस रिपोर्ट पर AI से चर्चा करें';

  @override
  String get reliabilityHigh => 'उच्च विश्वसनीयता';

  @override
  String get reliabilityModerate => 'मध्यम विश्वसनीयता';

  @override
  String get reliabilityLow => 'कम — केवल मार्गदर्शन';

  @override
  String get reliabilityGoodEdu => 'अच्छी विश्वसनीयता · D-24 सत्यापित';

  @override
  String get relationshipWord => 'रिश्ता';

  @override
  String get intelligenceWord => 'इंटेलिजेंस';

  @override
  String get relationshipIntelligence => 'संबंध बुद्धिमत्ता';

  @override
  String get typeLabel => 'प्रकार';

  @override
  String get trustLabel => 'भरोसा';

  @override
  String get dhokaRisk => 'धोखा जोखिम';

  @override
  String get powerLabel => 'शक्ति';

  @override
  String get integrity => 'ईमानदारी';

  @override
  String get warmth => 'गर्मजोशी';

  @override
  String get trustWord => 'भरोसा';

  @override
  String get assertLabel => 'दृढ़ता';

  @override
  String get character => 'चरित्र';

  @override
  String get love => 'प्रेम';

  @override
  String get businessWord => 'व्यापार';

  @override
  String get karmic => 'कार्मिक';

  @override
  String get enmityRisk => 'शत्रुता जोखिम';

  @override
  String get hdrChartProfiles => 'कुंडली प्रोफ़ाइल';

  @override
  String get hdrPairwiseAnalysis => 'युग्मवार विश्लेषण';

  @override
  String get hdrCriticalPatterns => 'महत्वपूर्ण पैटर्न';

  @override
  String get hdrGroupRecommendations => 'समूह अनुशंसाएँ';

  @override
  String get sharedPractices => 'साझा अभ्यास';

  @override
  String get hdrIndividualGuidance => 'व्यक्तिगत मार्गदर्शन';

  @override
  String get growthAreas => 'विकास क्षेत्र';

  @override
  String get hdrCoreTheme => 'मुख्य विषय';

  @override
  String get growthOriented => 'विकास-उन्मुख';

  @override
  String get groupTheme => 'समूह विषय';

  @override
  String get compatibility => 'अनुकूलता';

  @override
  String get unifiedScoreLabel => 'एकीकृत स्कोर';

  @override
  String get ashtakoot => 'अष्टकूट';

  @override
  String get probability => 'संभावना';

  @override
  String get hdrAshtakootSummary => 'अष्टकूट सारांश';

  @override
  String get hdrGunBreakdown => '8 गुण विवरण';

  @override
  String get hdrMangalDosh => 'मंगल दोष';

  @override
  String get hdrD9CrossChart => 'D-9 क्रॉस-कुंडली';

  @override
  String get d9Compatibility => 'D-9 अनुकूलता';

  @override
  String get hdrDomainCompatibility => 'क्षेत्र अनुकूलता';

  @override
  String get emotional => 'भावनात्मक';

  @override
  String get intellectual => 'बौद्धिक';

  @override
  String get spiritual => 'आध्यात्मिक';

  @override
  String get financial => 'वित्तीय';

  @override
  String get domestic => 'घरेलू';

  @override
  String get communicationWord => 'संचार';

  @override
  String get sharedDharma => 'साझा धर्म';

  @override
  String get familyCreation => 'परिवार निर्माण';

  @override
  String get hdrMarriageTiming => 'विवाह समय';

  @override
  String get jointMarriageWindows => 'संयुक्त विवाह अवधि';

  @override
  String get engagementWindows => 'सगाई अवधि';

  @override
  String get recommendedLabel => 'अनुशंसित';

  @override
  String get hdrKeyRisks => 'मुख्य जोखिम';

  @override
  String get hdrFinalVerdict => 'अंतिम निर्णय';

  @override
  String get marriageVerdict => 'विवाह निर्णय';

  @override
  String get educationWord => 'शिक्षा';

  @override
  String get learningSuffix => 'व अधिगम';

  @override
  String get coreEducationScores => 'मुख्य शिक्षा स्कोर';

  @override
  String get academicSuccess => 'शैक्षणिक सफलता';

  @override
  String get learningCapacity => 'अधिगम क्षमता';

  @override
  String get memory => 'स्मृति';

  @override
  String get intelligence => 'बुद्धि';

  @override
  String get research => 'अनुसंधान';

  @override
  String get hdrIntellectualProfile => 'बौद्धिक प्रोफ़ाइल';

  @override
  String get learningSignature => 'अधिगम विशिष्टता';

  @override
  String get hdrSubjectKaraka => 'विषय कारक';

  @override
  String get hdrHouseFoundations => 'भाव आधार';

  @override
  String get hdrMercuryJupiter => 'बुध व गुरु';

  @override
  String get hdrEducationYogas => 'शिक्षा योग';

  @override
  String get hdrDivisionalValidation => 'विभागीय सत्यापन';

  @override
  String get standing => 'स्थिति';

  @override
  String get hdrSubjectRanking => 'विषय वरीयता';

  @override
  String get hdrDegreeLikelihood => 'डिग्री संभावना';

  @override
  String get hdrStudyPeriods => 'अध्ययन अवधि';

  @override
  String get earlySchooling => 'प्रारंभिक शिक्षा';

  @override
  String get higherEducation => 'उच्च शिक्षा';

  @override
  String get postgradResearch => 'स्नातकोत्तर · शोध';

  @override
  String get hdrLearningPreferences => 'अधिगम प्राथमिकताएँ';

  @override
  String get hdrChallengesGifts => 'चुनौतियाँ व उपहार';

  @override
  String get challenges => 'चुनौतियाँ';

  @override
  String get cognitiveGifts => 'संज्ञानात्मक उपहार';

  @override
  String get naturalAbilities => 'स्वाभाविक क्षमताएँ';

  @override
  String get hdrSaraswatiRemedies => 'सरस्वती उपाय';

  @override
  String get studentVerdict => 'विद्यार्थी निर्णय';

  @override
  String get educationCareerLinkage => 'शिक्षा → करियर जुड़ाव';

  @override
  String get startupSuffix => 'व स्टार्टअप';

  @override
  String get coreBusinessScores => 'मुख्य व्यवसाय स्कोर';

  @override
  String get overallBusiness => 'समग्र व्यवसाय';

  @override
  String get ventureSuccess => 'उद्यम सफलता';

  @override
  String get eleventhHouse => 'एकादश भाव';

  @override
  String get gains => 'लाभ';

  @override
  String get investor => 'निवेशक';

  @override
  String get hdrFounderArchetype => 'संस्थापक मूल स्वरूप';

  @override
  String get hdrTenthEleventhHouses => 'दशम व एकादश भाव';

  @override
  String get hdrBusinessYogas => 'व्यवसाय योग';

  @override
  String get hdrRecommendedDomains => 'अनुशंसित क्षेत्र';

  @override
  String get hdrBusinessStyle => 'व्यवसाय शैली';

  @override
  String get hdrFounderSkills => 'संस्थापक कौशल';

  @override
  String get hdrFundingProfile => 'फंडिंग प्रोफ़ाइल';

  @override
  String get recommendedPath => 'अनुशंसित मार्ग';

  @override
  String get investorAttract => 'निवेशक आकर्षण';

  @override
  String get familyBacking => 'पारिवारिक सहयोग';

  @override
  String get hybridViability => 'हाइब्रिड व्यवहार्यता';

  @override
  String get launchWindow => 'लॉन्च अवधि';

  @override
  String get scaleWindow => 'विस्तार अवधि';

  @override
  String get hdrBusinessRisks => 'व्यवसाय जोखिम';

  @override
  String get recoveryCapacity => 'उबरने की क्षमता';

  @override
  String get hdrRemediesSolutions => 'उपाय व समाधान';

  @override
  String get aiConnectionLost => 'कनेक्शन टूट गया। कृपया पुनः प्रयास करें।';

  @override
  String get aiSomethingWrong => 'कुछ गलत हो गया';

  @override
  String get aiNoResponse => 'कोई प्रतिक्रिया नहीं';

  @override
  String get aiConnectionError => 'कनेक्शन त्रुटि। कृपया पुनः प्रयास करें।';

  @override
  String get aiAutoDetect => 'स्वतः पहचान';

  @override
  String aiAutoArrow(String lang) {
    return 'स्वतः → $lang';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'भाषा: $lang';
  }

  @override
  String get aiNoBirthCharts => 'कोई जन्म कुंडली नहीं मिली';

  @override
  String get aiCreateChartFirst =>
      'AI से चैट करने के लिए पहले एक जन्म कुंडली बनाएं';

  @override
  String get aiSelectChartBegin =>
      'विश्लेषण शुरू करने के लिए एक जन्म कुंडली चुनें';

  @override
  String aiAnalyzingName(String name) {
    return 'विश्लेषण: $name';
  }

  @override
  String get aiChange => 'बदलें';

  @override
  String get aiAnalyzingChart => 'आपकी कुंडली का विश्लेषण हो रहा है...';

  @override
  String get aiAskStarsHint => 'सितारों से कुछ भी पूछें...';

  @override
  String get aiSuggestedFollowups => 'सुझाए गए प्रश्न';

  @override
  String get aiThinking => 'सोच रहा है...';

  @override
  String get aiThanks => 'धन्यवाद!';

  @override
  String get aiFeedbackNoted => 'प्रतिक्रिया दर्ज की गई';

  @override
  String get svcAll => 'सभी';

  @override
  String get svcNoServices => 'कोई सेवा उपलब्ध नहीं';

  @override
  String get svcFree => 'मुफ़्त';

  @override
  String get astroFailedStartCall => 'कॉल शुरू करने में विफल';

  @override
  String get astroFailedStartChat => 'चैट शुरू करने में विफल';

  @override
  String astroErrorDetail(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get astroExperience => 'अनुभव';

  @override
  String get astroSessions => 'सत्र';

  @override
  String get astroMinutes => 'मिनट';

  @override
  String get astroAbout => 'परिचय';

  @override
  String get astroLanguages => 'भाषाएँ';

  @override
  String get astroRateCard => 'दर सूची';

  @override
  String get astroVoice => 'वॉइस';

  @override
  String astroReviews(int count) {
    return 'समीक्षाएँ ($count)';
  }

  @override
  String get astroNoReviews => 'अभी तक कोई समीक्षा नहीं';

  @override
  String get astroAnonymous => 'अनाम';

  @override
  String get forgotPasswordSubtitle =>
      'अपना ईमेल दर्ज करें और हम आपको पासवर्ड\nरीसेट करने के लिए एक लिंक भेजेंगे।';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => 'लिंक दोबारा भेजें';

  @override
  String get appName => 'नक्षत्रलॉजी';

  @override
  String get cosmicJourneyAwaits => 'आपकी ब्रह्मांडीय यात्रा शुरू होती है';

  @override
  String get home => 'होम';

  @override
  String get astrologers => 'ज्योतिषी';

  @override
  String get services => 'सेवाएं';

  @override
  String get wallet => 'वॉलेट';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get live => 'लाइव';

  @override
  String get kundli => 'कुंडली';

  @override
  String get chat => 'चैट';

  @override
  String get call => 'कॉल';

  @override
  String get video => 'वीडियो';

  @override
  String get signIn => 'साइन इन';

  @override
  String get createAccount => 'खाता बनाएं';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्ड पुष्टि करें';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get phone => 'फ़ोन (वैकल्पिक)';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get sendResetLink => 'रीसेट लिंक भेजें';

  @override
  String get backToSignIn => 'साइन इन पर वापस';

  @override
  String get dontHaveAccount => 'खाता नहीं है?';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है?';

  @override
  String get continueGoogle => 'Google से जारी रखें';

  @override
  String get required => 'आवश्यक';

  @override
  String get minSixChars => 'कम से कम 6 अक्षर';

  @override
  String get passwordsMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get validEmailRequired => 'वैध ईमेल आवश्यक';

  @override
  String get loginFailed => 'लॉगिन विफल';

  @override
  String get signupFailed => 'साइनअप विफल';

  @override
  String get welcomeBack => 'वापस आपका स्वागत है';

  @override
  String get todaysHoroscope => 'आज का राशिफल';

  @override
  String get todaysRashi => 'आज की राशि';

  @override
  String get tapDetails => 'विवरण के लिए टैप करें';

  @override
  String get allServices => 'सभी सेवाएं';

  @override
  String get seeAll => 'सभी देखें';

  @override
  String get topAstrologers => 'शीर्ष ज्योतिषी';

  @override
  String get onlineExperts => 'ऑनलाइन विशेषज्ञ परामर्श के लिए तैयार';

  @override
  String get searchAstrologers => 'ज्योतिषी खोजें...';

  @override
  String get noAstrologersFound => 'कोई ज्योतिषी नहीं मिला';

  @override
  String get online => 'ऑनलाइन';

  @override
  String get offline => 'ऑफ़लाइन';

  @override
  String get busy => 'व्यस्त';

  @override
  String get perMin => '/मिनट';

  @override
  String get noCharts => 'अभी कोई जन्म कुंडली नहीं';

  @override
  String get createFirst => 'अपनी पहली जन्म कुंडली बनाएं';

  @override
  String get createChart => 'कुंडली बनाएं';

  @override
  String get newBirthChart => 'नई जन्म कुंडली';

  @override
  String get clientName => 'नाम';

  @override
  String get gender => 'लिंग';

  @override
  String get male => 'पुरुष';

  @override
  String get female => 'महिला';

  @override
  String get other => 'अन्य';

  @override
  String get dateOfBirth => 'जन्म तिथि';

  @override
  String get timeOfBirth => 'जन्म समय';

  @override
  String get birthPlace => 'जन्म स्थान';

  @override
  String get birthPlaceHint => 'शहर का नाम टाइप करें...';

  @override
  String get generateKundli => 'कुंडली बनाएं';

  @override
  String get birthChartCreated => 'जन्म कुंडली बन गई!';

  @override
  String get deleteChart => 'कुंडली हटाएं?';

  @override
  String get cannotUndo => 'यह वापस नहीं किया जा सकता।';

  @override
  String get primary => 'प्राथमिक';

  @override
  String get viewKundli => 'कुंडली देखें';

  @override
  String get completeBirthChart => 'पूर्ण जन्म कुंडली';

  @override
  String get birthDetails => 'जन्म विवरण';

  @override
  String get name => 'नाम';

  @override
  String get dob => 'जन्म तिथि';

  @override
  String get tob => 'जन्म समय';

  @override
  String get place => 'स्थान';

  @override
  String get summary => 'सारांश';

  @override
  String get planets => 'ग्रह';

  @override
  String get divisions => 'विभाग';

  @override
  String get vimshottari => 'विंशोत्तरी';

  @override
  String get moola => 'मूल';

  @override
  String get gochar => 'गोचर';

  @override
  String get dosh => 'दोष';

  @override
  String get yoga => 'योग';

  @override
  String get shadbala => 'षड्बल';

  @override
  String get ashtakavarga => 'अष्टकवर्ग';

  @override
  String get aspects => 'दृष्टि';

  @override
  String get lifeAreas => 'जीवन क्षेत्र';

  @override
  String get bhava => 'भाव';

  @override
  String get chakras => 'चक्र';

  @override
  String get dashaActive => 'दशा सक्रिय';

  @override
  String get lagna => 'लग्न';

  @override
  String get moon => 'चंद्र';

  @override
  String get sun => 'सूर्य';

  @override
  String get premiumSection => 'प्रीमियम अनुभाग';

  @override
  String get unlockReading => 'विस्तृत विश्लेषण देखने के लिए अनलॉक करें।';

  @override
  String get unlock => 'अनलॉक';

  @override
  String get retrograde => 'वक्री';

  @override
  String get combust => 'अस्त';

  @override
  String get vargottama => 'वर्गोत्तम';

  @override
  String get exalted => 'उच्च';

  @override
  String get debilitated => 'नीच';

  @override
  String get addBalance => 'बैलेंस जोड़ें';

  @override
  String get amount => 'राशि';

  @override
  String get walletBalance => 'वॉलेट बैलेंस';

  @override
  String get recharge => 'रिचार्ज';

  @override
  String get bonus => 'बोनस';

  @override
  String get serviceLabel => 'सेवा';

  @override
  String get refund => 'वापसी';

  @override
  String get noTransactions => 'कोई लेनदेन नहीं';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get savedAstrologers => 'सहेजे गए ज्योतिषी';

  @override
  String get noSavedAstrologers => 'अभी कोई सहेजे गए ज्योतिषी नहीं';

  @override
  String get myOrders => 'मेरे ऑर्डर';

  @override
  String get communicationHistory => 'संवाद इतिहास';

  @override
  String get chatHistory => 'चैट इतिहास';

  @override
  String get callHistory => 'कॉल इतिहास';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get chatMessages => 'चैट संदेश';

  @override
  String get typeMessage => 'संदेश लिखें...';

  @override
  String get sessionEnded => 'सत्र समाप्त';

  @override
  String get endChat => 'चैट समाप्त करें?';

  @override
  String get endChatConfirm =>
      'क्या आप वाकई इस चैट सत्र को समाप्त करना चाहते हैं?';

  @override
  String get sendPhoto => 'फ़ोटो भेजें';

  @override
  String get sendPDF => 'PDF भेजें';

  @override
  String get upload => 'अपलोड';

  @override
  String get fileNotFound => 'फ़ाइल नहीं मिली';

  @override
  String get voiceCall => 'वॉइस कॉल';

  @override
  String get videoCall => 'वीडियो कॉल';

  @override
  String get ringing => 'रिंग हो रही है...';

  @override
  String get connected => 'कनेक्टेड';

  @override
  String get endCall => 'कॉल समाप्त';

  @override
  String get mute => 'म्यूट';

  @override
  String get unmute => 'अनम्यूट';

  @override
  String get speaker => 'स्पीकर';

  @override
  String get camera => 'कैमरा';

  @override
  String get flip => 'फ्लिप';

  @override
  String get liveStreams => 'लाइव स्ट्रीम';

  @override
  String get noLiveStreams => 'अभी कोई लाइव स्ट्रीम नहीं';

  @override
  String get astrologerUnavailable =>
      'ज्योतिषी उपलब्ध नहीं। स्ट्रीम समाप्त हो रही है।';

  @override
  String get streamEnded => 'स्ट्रीम समाप्त';

  @override
  String get superChat => 'सुपर चैट';

  @override
  String get sendGift => 'उपहार भेजें';

  @override
  String get goBack => 'वापस जाएं';

  @override
  String get appPermissions => 'ऐप अनुमतियां';

  @override
  String get grantPermissions => 'अनुमतियां दें';

  @override
  String get skipForNow => 'अभी छोड़ें';

  @override
  String get microphone => 'माइक्रोफ़ोन';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get storage => 'स्टोरेज';

  @override
  String get ok => 'ठीक है';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get edit => 'संपादित करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get retry => 'पुनः प्रयास';

  @override
  String get send => 'भेजें';

  @override
  String get refresh => 'रीफ्रेश';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get noData => 'कोई डेटा उपलब्ध नहीं';

  @override
  String get error => 'त्रुटि';

  @override
  String get success => 'सफल';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get myDetails => 'मेरा विवरण';

  @override
  String get myKundlis => 'मेरी कुंडलियां';

  @override
  String get walletRecharge => 'वॉलेट और रिचार्ज';

  @override
  String get consultationHistory => 'परामर्श इतिहास';

  @override
  String get helpSupport => 'सहायता और समर्थन';

  @override
  String get biometricLogin => 'बायोमेट्रिक लॉगिन';

  @override
  String get pastVoiceConsultations => 'पिछले वॉइस परामर्श';

  @override
  String get pastTextConversations => 'पिछली टेक्स्ट बातचीत';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get totalCredit => 'कुल क्रेडिट';

  @override
  String get totalDebit => 'कुल डेबिट';

  @override
  String get statement => 'विवरण';

  @override
  String get allTypes => 'सभी प्रकार';

  @override
  String get prev => 'पिछला';

  @override
  String get next => 'अगला';

  @override
  String get allInsights => 'सभी विश्लेषण';

  @override
  String get yourCompleteReading => 'आपका पूर्ण पठन';

  @override
  String get expertEngines => 'विशेषज्ञ इंजन';

  @override
  String get eachInsightConsultation => 'प्रत्येक विश्लेषण एक पूर्ण परामर्श है';

  @override
  String get engines => 'इंजन';

  @override
  String get dataPoints => 'डेटा पॉइंट';

  @override
  String get singleChart => 'सिंगल';

  @override
  String get careerPurpose => 'करियर और उद्देश्य';

  @override
  String get wealthAssets => 'धन और संपत्ति';

  @override
  String get loveRelationships => 'प्रेम और रिश्ते';

  @override
  String get healthWellness => 'स्वास्थ्य और कल्याण';

  @override
  String get soulKarma => 'आत्मा और कर्म';

  @override
  String get specialistReports => 'विशेषज्ञ रिपोर्ट';

  @override
  String get searchByNameSpeciality => 'नाम, विशेषता से खोजें...';

  @override
  String get sortedByRating => 'रेटिंग के अनुसार';

  @override
  String get initiatingChat => 'चैट शुरू हो रही है...';

  @override
  String get startingCall => 'कॉल शुरू हो रही है...';

  @override
  String get yrs => 'वर्ष';

  @override
  String get chatWithAISpecialist => 'AI विशेषज्ञ से चैट करें';

  @override
  String get tapToStart => 'शुरू करने के लिए टैप करें';

  @override
  String get astrologer => 'ज्योतिषी';

  @override
  String get reports => 'रिपोर्ट';

  @override
  String get milan => 'मिलान';

  @override
  String get forecast => 'भविष्यवाणी';

  @override
  String get rashi => 'राशि';

  @override
  String get jupiterFavorsBold => 'बृहस्पति साहसी कदमों का समर्थन करता है';

  @override
  String get careerIlluminated =>
      'आपका करियर क्षेत्र प्रकाशमान है — अपनी अंतर्ज्ञान पर विश्वास करें।';

  @override
  String get todaysForecast => 'आज का पूर्वानुमान';

  @override
  String get engCareer => 'करियर और नौकरी';

  @override
  String get engBusiness => 'व्यापार और स्टार्टअप';

  @override
  String get engEducation => 'शिक्षा और अध्ययन';

  @override
  String get engLifePath => 'जीवन पथ और भाग्य';

  @override
  String get engWealth => 'धन और वित्त';

  @override
  String get engDebt => 'ऋण और वसूली';

  @override
  String get engProperty => 'संपत्ति और आस्तियां';

  @override
  String get engLegal => 'कानूनी और विवाद';

  @override
  String get engLove => 'प्रेम और रोमांस';

  @override
  String get engMarriage => 'विवाह और परिवार';

  @override
  String get engKundliMilan => 'कुंडली मिलान';

  @override
  String get engRelationship => 'रिश्ता विश्लेषण';

  @override
  String get engLoveCompat => 'प्रेम अनुकूलता';

  @override
  String get engChildProb => 'संतान संभावना';

  @override
  String get engHealth => 'स्वास्थ्य और कल्याण';

  @override
  String get engMental => 'मानसिक और तनाव';

  @override
  String get engCharacter => 'चरित्र विश्लेषण';

  @override
  String get engPastLife => 'पूर्वजन्म और कर्म';

  @override
  String get engKarmaLink => 'कर्म संबंध';

  @override
  String get noChatSessions => 'अभी कोई चैट सत्र नहीं';

  @override
  String get chatAppearHere =>
      'ज्योतिषियों के साथ आपकी बातचीत यहां दिखाई देगी।';

  @override
  String get noCallsYet => 'अभी कोई कॉल नहीं';

  @override
  String get callAppearHere =>
      'ज्योतिषियों के साथ आपका कॉल इतिहास यहां दिखाई देगा।';

  @override
  String get chatWith => 'के साथ चैट';

  @override
  String get msgs => 'संदेश';

  @override
  String get voiceCallLabel => 'वॉइस कॉल';

  @override
  String get videoCallLabel => 'वीडियो कॉल';

  @override
  String get pullToRefresh => 'रीफ्रेश करने के लिए नीचे खींचें';

  @override
  String get sessionExpired => 'सत्र समाप्त';

  @override
  String get connectionFailed => 'कनेक्शन विफल';

  @override
  String get callActive => 'कॉल सक्रिय';

  @override
  String get lessThanOneMin => '1 मिनट से कम शेष';

  @override
  String get noMessages => 'इस सत्र में कोई संदेश नहीं';

  @override
  String get gocharForAllSigns => 'सभी 12 राशियों का आज का गोचर';

  @override
  String get selectChart => 'विश्लेषण के लिए कुंडली चुनें';

  @override
  String get selectTwoCharts => 'दो कुंडलियां चुनें';

  @override
  String get analyzing => 'विश्लेषण हो रहा है...';

  @override
  String get browseAstrologers => 'ज्योतिषी खोजें';

  @override
  String get probableNumber => 'संभावित संख्या';

  @override
  String get genderTendency => 'लिंग प्रवृत्ति';

  @override
  String get son => 'पुत्र';

  @override
  String get daughter => 'पुत्री';

  @override
  String get occupants => 'निवासी ग्रह';

  @override
  String get beneficAspects => 'शुभ दृष्टि';

  @override
  String get maleficAspects => 'पाप दृष्टि';

  @override
  String get nextFavorableWindow => 'अगली अनुकूल अवधि';

  @override
  String get totalDoshaPenalty => 'कुल दोष दंड';

  @override
  String get cancellationFactors => 'निरसन कारक';

  @override
  String get combinedFertility => 'संयुक्त प्रजनन संकेत';

  @override
  String get planetPositions => 'ग्रह स्थिति';

  @override
  String get bestWindows => 'सर्वोत्तम अवधि';

  @override
  String get worstWindows => 'प्रतिकूल अवधि';

  @override
  String get scoreComponents => 'अंक घटक';

  @override
  String get topOpportunities => 'शीर्ष अवसर';

  @override
  String get topRisks => 'शीर्ष जोखिम';

  @override
  String get remedies => 'उपाय';

  @override
  String get keyInsights => 'मुख्य अंतर्दृष्टि';

  @override
  String get overallVerdict => 'समग्र निर्णय';

  @override
  String get venusContacts => 'शुक्र क्रॉस संपर्क';

  @override
  String get contact => 'संपर्क';

  @override
  String get effect => 'प्रभाव';

  @override
  String get moonSignCompat => 'चंद्र राशि अनुकूलता';

  @override
  String get hisMoon => 'उनका चंद्र';

  @override
  String get herMoon => 'उनका चंद्र';

  @override
  String get nakshatraCompat => 'नक्षत्र अनुकूलता';

  @override
  String get ketuContacts => 'केतु संपर्क';

  @override
  String get rahuContacts => 'राहु संपर्क';

  @override
  String get pastLifeIndication => 'पूर्वजन्म संकेत';

  @override
  String get totalChallengePenalty => 'कुल चुनौती दंड';

  @override
  String get manifestation => 'अभिव्यक्ति';

  @override
  String get cancellation => 'निरसन';

  @override
  String get navigation => 'मार्गदर्शन';

  @override
  String get potentialStrengths => 'संभावित शक्तियां';

  @override
  String get areasToNurture => 'पोषण क्षेत्र';

  @override
  String get relationshipGuidance => 'रिश्ता मार्गदर्शन';

  @override
  String get detailedSummary => 'विस्तृत सारांश';

  @override
  String get discussWithAI => 'AI से चर्चा करें';

  @override
  String get planet => 'ग्रह';

  @override
  String get sign => 'राशि';

  @override
  String get house => 'भाव';

  @override
  String get strength => 'बल';

  @override
  String get copy => 'कॉपी';

  @override
  String get confidence => 'विश्वास';

  @override
  String get d7Saptamsa => 'डी7 सप्तांश';

  @override
  String get numberExplanation => 'संख्या विवरण';

  @override
  String get genderExplanation => 'लिंग विवरण';

  @override
  String get inFifth => '5वें में?';

  @override
  String get primaryArchetype => 'प्राथमिक प्रारूप';

  @override
  String get mitigation => 'शमन';

  @override
  String get soulCareerAlign => 'आत्मा ↔ करियर संरेखण';

  @override
  String get favorablePeriods => 'अनुकूल काल';

  @override
  String get challengingPeriods => 'चुनौतीपूर्ण काल';

  @override
  String get keyHouses => 'प्रमुख भाव';

  @override
  String get keyPlanets => 'प्रमुख ग्रह';

  @override
  String get characterOverview => 'चरित्र अवलोकन';

  @override
  String get noYogasActive => 'इस कुंडली में अभी कोई योग सक्रिय नहीं है।';

  @override
  String get basedOnPlanetStrengths => 'ग्रह बल और भाव स्थिति के आधार पर';

  @override
  String get basedOnTransits => 'वर्तमान ग्रह गोचर के आधार पर';

  @override
  String get currentPlanetPositions =>
      'आपकी राशि को प्रथम भाव मानते हुए वर्तमान ग्रह स्थिति';

  @override
  String get favorablePeriodAdvice =>
      'अनुकूल काल — करियर विकास और रिश्तों पर ध्यान दें।';

  @override
  String get noClassicalYogas =>
      'शास्त्रीय शिक्षा योगों के बिना, सफलता निरंतर प्रयास से आती है।';

  @override
  String get walletDeduction => 'राशि आपके वॉलेट से कटेगी';

  @override
  String get bhakootAxis => 'भकूट अक्ष';

  @override
  String get basis => 'आधार';

  @override
  String get selectChartsForMilan => 'मिलान के लिए 2 कुंडलियां चुनें';

  @override
  String get selectMultiCharts => '2-5 कुंडलियां चुनें';

  @override
  String get running => 'चालू';

  @override
  String get past => 'बीता हुआ';

  @override
  String get topActiveDoshas => 'शीर्ष सक्रिय दोष';

  @override
  String get allDoshas => 'सभी दोष';

  @override
  String get activeYogas => 'सक्रिय योग';

  @override
  String get activeDoshas => 'सक्रिय दोष';

  @override
  String get yogaAnalysis => 'योग विश्लेषण';

  @override
  String get factors => 'कारक';

  @override
  String get dominantPlanet => 'प्रमुख ग्रह';

  @override
  String get startSession => 'सत्र शुरू करें';

  @override
  String get notesSaved => 'नोट्स सहेजे गए';

  @override
  String get unlocked => 'अनलॉक! अपना पठन आनंद लें।';

  @override
  String get todaysGochar => 'आज का गोचर';

  @override
  String get todaysTransitChart => 'आज का गोचर चार्ट';

  @override
  String get lifeAreaPredictions => 'जीवन क्षेत्र भविष्यवाणी';

  @override
  String get strengths => 'शक्तियां';

  @override
  String get weaknesses => 'कमजोरियां';

  @override
  String get ruledBy => 'स्वामी';

  @override
  String get kundliMilan => 'कुंडली मिलान';

  @override
  String get startKundliMilan => 'कुंडली मिलान शुरू करें';

  @override
  String get recommendations => 'सिफारिशें';

  @override
  String get cancellations => 'निरसन';

  @override
  String get dashaSync => 'दशा समन्वय';

  @override
  String get transitMarriageWindows => 'गोचर विवाह अवधि';

  @override
  String get overlappingWindows => 'ओवरलैपिंग विवाह अवधि';

  @override
  String get overallStrength => 'समग्र बल';

  @override
  String get stability => 'स्थिरता';

  @override
  String get growth => 'विकास';

  @override
  String get clarity => 'स्पष्टता';

  @override
  String get recognition => 'पहचान';

  @override
  String get satisfaction => 'संतुष्टि';

  @override
  String get verdict => 'निर्णय';

  @override
  String get topRoles => 'शीर्ष भूमिकाएं';

  @override
  String get areasForGrowth => 'विकास क्षेत्र';

  @override
  String get bestIndustries => 'सर्वोत्तम उद्योग';

  @override
  String get employment => 'नौकरी';

  @override
  String get entrepreneurship => 'उद्यमिता';

  @override
  String get freelance => 'फ्रीलांस';

  @override
  String get portfolio => 'पोर्टफोलियो';

  @override
  String get burnoutRisk => 'थकान जोखिम';

  @override
  String get careerStagnation => 'करियर ठहराव';

  @override
  String get workplaceConflict => 'कार्यस्थल संघर्ष';

  @override
  String get positioning => 'स्थिति निर्धारण';

  @override
  String get skillDevelopment => 'कौशल विकास';

  @override
  String get network => 'नेटवर्क';

  @override
  String get visibility => 'दृश्यता';

  @override
  String get lagnaLord => 'लग्न स्वामी';

  @override
  String get tenthLord => 'दसवां स्वामी';

  @override
  String get lord => 'स्वामी';

  @override
  String get lordPlacedIn => 'स्वामी स्थित';

  @override
  String get lordDignity => 'स्वामी गरिमा';

  @override
  String get d9Dignity => 'डी9 गरिमा';

  @override
  String get careerAnalysis => 'करियर विश्लेषण';

  @override
  String get launchWindows => 'शुभारंभ अवधि';

  @override
  String get peakWindows => 'शिखर अवधि';

  @override
  String get promotionWindows => 'पदोन्नति अवधि';

  @override
  String get riskWindows => 'जोखिम अवधि';

  @override
  String get timingWindows => 'समय अवधि';

  @override
  String get careerRisks => 'करियर जोखिम';

  @override
  String get astrologicalRemedies => 'ज्योतिषीय उपाय';

  @override
  String get practicalSolutions => 'व्यावहारिक समाधान';

  @override
  String get analysisConfidence => 'विश्लेषण विश्वसनीयता';

  @override
  String get careerArchetype => 'करियर प्रारूप';

  @override
  String get workStructure => 'कार्य संरचना';

  @override
  String get teamLeadership => 'टीम नेतृत्व';

  @override
  String get idealEnvironment => 'आदर्श वातावरण';

  @override
  String get idealOrgSize => 'आदर्श संगठन आकार';

  @override
  String get fitScore => 'फिट स्कोर';

  @override
  String get recommended => 'अनुशंसित';

  @override
  String get divisionalValidation => 'विभागीय सत्यापन';

  @override
  String get houseAnalysis => 'भाव विश्लेषण';

  @override
  String get jaiminiKarakas => 'जैमिनी कारक';

  @override
  String get copyFullReport => 'पूरी रिपोर्ट कॉपी करें';

  @override
  String get reportCopied => 'रिपोर्ट कॉपी हो गई!';

  @override
  String get biometricNotAvailable => 'इस डिवाइस पर बायोमेट्रिक उपलब्ध नहीं है';

  @override
  String biometricErrorMsg(Object error) {
    return 'बायोमेट्रिक त्रुटि: $error';
  }

  @override
  String get biometricVerifyReason =>
      'बायोमेट्रिक लॉगिन सक्षम करने के लिए सत्यापित करें';

  @override
  String get dobFormatLabel => 'जन्म तिथि (DD/MM/YYYY)';

  @override
  String get tobFormatLabel => 'जन्म समय (HH:MM)';

  @override
  String get phoneLabel => 'फ़ोन';

  @override
  String get activeBadge => 'सक्रिय';

  @override
  String get chartCategoryLabel => 'श्रेणी';

  @override
  String get freePrimaryDescription =>
      'फ्री प्राइमरी — दैनिक राशिफल और मुफ्त सिंगल-चार्ट सेवाओं के लिए उपयोग होता है';

  @override
  String get searchChartsHint => 'नाम या जन्म तिथि से खोजें...';

  @override
  String unlockPriceLabel(Object price) {
    return '$price में अनलॉक करें';
  }

  @override
  String unlockAiSpecialistIntl(Object price) {
    return 'इस AI विशेषज्ञ को $price में (एक बार) अनलॉक करें, जिसे ऐप स्टोर के माध्यम से सुरक्षित रूप से खरीदा जाता है।';
  }

  @override
  String unlockAiSpecialistWallet(Object price) {
    return 'इस AI विशेषज्ञ को $price में (एक बार) अनलॉक करें। राशि आपके वॉलेट से काट ली जाएगी।';
  }

  @override
  String get specialistNotAvailablePurchase =>
      'यह विशेषज्ञ अभी खरीद के लिए उपलब्ध नहीं है।';

  @override
  String get couldNotCompletePurchase =>
      'खरीद पूरी नहीं हो सकी। कृपया पुनः प्रयास करें।';

  @override
  String get couldNotUnlockWalletBalance =>
      'अनलॉक नहीं हो सका (वॉलेट बैलेंस जांचें)';

  @override
  String get freeBadge => 'फ्री';

  @override
  String activeSessionInProgress(Object kind) {
    return 'आपका एक सक्रिय $kind जारी है';
  }

  @override
  String get returnLabel => 'वापस जाएं';

  @override
  String get enableNotificationsForAlerts =>
      'सलाह और ऑफ़र अलर्ट पाने के लिए नोटिफ़िकेशन सक्षम करें';

  @override
  String get enableLabel => 'सक्षम करें';

  @override
  String get notificationsEnabled => 'नोटिफ़िकेशन सक्षम किए गए';

  @override
  String get couldNotEnableNotifications =>
      'सक्षम नहीं हो सका — अपने ब्राउज़र में नोटिफ़िकेशन की अनुमति दें';

  @override
  String get amountInrLabel => 'राशि (₹)';

  @override
  String get noteOptionalLabel => 'नोट (वैकल्पिक)';

  @override
  String get txnDate => 'तिथि';

  @override
  String get txnDescription => 'विवरण';

  @override
  String get txnType => 'प्रकार';

  @override
  String get txnAmount => 'राशि';

  @override
  String get txnBalance => 'बैलेंस';

  @override
  String get credit => 'क्रेडिट';

  @override
  String get debit => 'डेबिट';

  @override
  String get razorpayStripeNote =>
      '💳 प्रोडक्शन में यह Razorpay/Stripe पर रीडायरेक्ट होगा।';

  @override
  String get downloadPdf => 'PDF डाउनलोड करें';

  @override
  String get chatWithAiCta => 'AI से चैट करें';

  @override
  String get pdfServiceUnavailable =>
      'PDF सेवा अभी अस्थायी रूप से अनुपलब्ध है। कृपया बाद में पुनः प्रयास करें।';

  @override
  String get pleaseUnlockFirst => 'कृपया पहले इसे अनलॉक करें।';

  @override
  String get couldNotGeneratePdf =>
      'PDF तैयार नहीं हो सका। कृपया पुनः प्रयास करें।';

  @override
  String get statConsults => 'सलाह';

  @override
  String get statCharts => 'चार्ट्स';

  @override
  String get statWallet => 'वॉलेट';

  @override
  String get firstChartPrimaryInfo =>
      'आपका पहला चार्ट आपका फ्री प्राइमरी है। अतिरिक्त चार्ट व्यक्तिगत रूप से सेवाएं अनलॉक करते हैं।';

  @override
  String get tryDifferentFilter => 'एक अलग फ़िल्टर आज़माएं';

  @override
  String get defaultChartName => 'चार्ट';

  @override
  String get balAbbr => 'बैलेंस';
}

/// The translations for Hindi, using the Latin script (`hi_Latn`).
class AppLocalizationsHiLatn extends AppLocalizationsHi {
  AppLocalizationsHiLatn() : super('hi_Latn');

  @override
  String get awChooseLanguage => 'Apni bhasha chunein';

  @override
  String get awGoogleFailed =>
      'Google sign-in fail ho gaya. Kripya dobara try karein.';

  @override
  String get awCompleteProfileTitle => 'Apni profile poori karein';

  @override
  String awWelcomeName(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get awCompleteProfileSubtitle =>
      'Nakshatralogy ko aapke liye personalize karne ke liye kuch details.';

  @override
  String get awRegionLabel => 'Region';

  @override
  String get awRegionIndia => 'India';

  @override
  String get awRegionInternational => 'International';

  @override
  String get awPreferredLanguage => 'Pasandeeda bhasha';

  @override
  String get awFinishSetup => 'Setup poora karein';

  @override
  String get awChatFileWebUnsupported =>
      'File sharing web par abhi available nahi hai. Kripya mobile app use karein.';

  @override
  String get awVideoUnsupported =>
      'Is browser mein video calls support nahi hain. Kripya hamara mobile app ya supported desktop browser use karein.';

  @override
  String get awClose => 'Close';

  @override
  String get pwPremiumTitle => 'Premium Report';

  @override
  String get pwLockedSubtitle =>
      'Is chart ke liye poora analysis unlock karein';

  @override
  String pwUnlockFull(Object name) {
    return 'Poora $name unlock karein';
  }

  @override
  String pwUnlockPrice(Object price) {
    return 'Unlock · $price';
  }

  @override
  String get pwOneTime => 'Ek baar unlock — is chart par hamesha ke liye aapka';

  @override
  String get pwWhatYouGet => 'Aapko kya milega';

  @override
  String get pwYourBalance => 'Aapka wallet balance';

  @override
  String get pwInsufficient => 'Balance kam hai';

  @override
  String get pwRechargeToUnlock => 'Unlock karne ke liye recharge karein';

  @override
  String get pwRechargeAmount => 'Recharge amount (₹)';

  @override
  String get pwAddMoney => 'Paise add karein';

  @override
  String get pwRechargeDone => 'Wallet recharge ho gaya';

  @override
  String get pwRechargeFailed => 'Recharge fail hua. Dobara try karein.';

  @override
  String get pwUnlockFailed => 'Unlock nahi hua. Dobara try karein.';

  @override
  String get pwUnlockedNow => 'Unlock ho gaya! Aapki report load ho rahi hai…';

  @override
  String get pwProcessing => 'Process ho raha hai…';

  @override
  String get pwPrimaryNoDelete =>
      'Aapki Primary Kundli delete nahi ho sakti — yeh hamesha free hai.';

  @override
  String get pwPrimaryNoEdit => 'Aapki Primary Kundli edit nahi ho sakti.';

  @override
  String get pwLoadingAccess => 'Access check ho raha hai…';

  @override
  String get pwMaybeLater => 'Baad mein';

  @override
  String get updatePhoto => 'Photo Update Karein';

  @override
  String get takePhoto => 'Camera';

  @override
  String get chooseFromGallery => 'Gallery';

  @override
  String get removePhoto => 'Photo Hataayein';

  @override
  String get photoUpdated => 'Photo update ho gayi';

  @override
  String get photoUploadFailed =>
      'Photo upload nahi ho saki. Please dobara try karein.';

  @override
  String get tapToChangePhoto => 'Photo badalne ke liye tap karein';

  @override
  String get klSubtitle => 'AI-powered Vedic Past-Life Karma Linkage Report';

  @override
  String get klTitle => 'Past-Life Karma Linkage';

  @override
  String get klSnapshotHeader => 'Karmic Linkage Snapshot';

  @override
  String get klGaugePairwise => 'Avg Pairwise Linkage';

  @override
  String get klGaugeCohesion => 'Group Cohesion';

  @override
  String get klGaugeRahuKetu => 'Rahu-Ketu Resonance';

  @override
  String get klGaugeAtmakaraka => 'Soul Resonance';

  @override
  String get klGaugeD60 => 'D60 Resonance';

  @override
  String get klChipSoulResonance => 'Strong soul-signature resonance';

  @override
  String get klChipD60Resonance => 'Strong D60 past-life resonance';

  @override
  String get klChipCohesiveGroup => 'Cohesive group';

  @override
  String get klChipNoDebts => 'Koi karmic debt nahi mila';

  @override
  String get klProfilesTitle => 'Chart Profiles';

  @override
  String get klKetuAt => 'Ketu hai';

  @override
  String get klRahuAt => 'Rahu hai';

  @override
  String get klFoundationTitle => 'Per-Chart Karmic Foundation';

  @override
  String get klFoundationSubtitle =>
      'Har soul ki past-life mastery aur current-life direction';

  @override
  String get klKetuMastery => 'Ketu Mastery';

  @override
  String get klRahuGrowth => 'Rahu Growth';

  @override
  String get klNinthHousePunya => '9th House Punya';

  @override
  String get klD60Depth => 'D60 Karmic Depth';

  @override
  String get klAtmakarakaAgenda => 'Soul ka agenda';

  @override
  String get klSaturnKarma => 'Shani ka karma';

  @override
  String get klPairwiseTitle => 'Pairwise Karmic Linkages';

  @override
  String get klActiveFactors => 'Active linkage factors';

  @override
  String get klGroupPatternTitle => 'Group Karmic Pattern';

  @override
  String get klSharedSetting => 'Shared Past-Life Setting';

  @override
  String get klCohesionScore => 'Karmic Cohesion';

  @override
  String get klPastGoalsTitle => 'Past-Life Goals';

  @override
  String get klLearningTitle => 'Current-Life Learning';

  @override
  String get klTeachingMap => 'Mutual Teaching Map';

  @override
  String get klDebtsTitle => 'Karmic Debts & Resolutions';

  @override
  String get klNoDebtsDetected => 'Is group mein koi karmic debt nahi mila';

  @override
  String get klTimingTitle => 'Moola Dasha Karmic Timing';

  @override
  String get klAuditTitle => 'Deep Audit Table';

  @override
  String klAuditSubtitle(Object count) {
    return '$count karmic parameters check kiye gaye';
  }

  @override
  String get klTopicLinkage => 'Humara overall karmic linkage';

  @override
  String get klTopicPairwise => 'Kisi ek pair ka karmic bond';

  @override
  String get klTopicDebts => 'Suljhane wale karmic debts';

  @override
  String get klTopicLessons => 'Hum yahan kya seekhne aaye hain';

  @override
  String get klTopicTiming => 'Humare group ke liye best timing';

  @override
  String get klTopicGroup => 'Humari shared past-life story';

  @override
  String get lcSubtitle => 'AI se taiyaar Vedic Love Compatibility Report';

  @override
  String get lcTitle => 'Love Compatibility';

  @override
  String get lcSnapshotHeader => 'Love Compatibility ka Snapshot';

  @override
  String get lcGaugeAttraction => 'Aakarshan';

  @override
  String get lcGaugeEmotional => 'Emotional Harmony';

  @override
  String get lcGaugeMental => 'Mental Rapport';

  @override
  String get lcGaugePassion => 'Passion';

  @override
  String get lcGaugeLongterm => 'Long-Term Harmony';

  @override
  String get lcChipStrongMental => 'Strong mental connection';

  @override
  String get lcChipStrongLongterm => 'Strong long-term potential';

  @override
  String get lcChipStrongPassion => 'Strong physical chemistry';

  @override
  String get lcChipLowFriction => 'Overall kam friction';

  @override
  String get lcChipKarmicPull => 'Strong karmic khinchaav';

  @override
  String get lcPartnersTitle => 'Partner ka Snapshot';

  @override
  String get lcVenusSuffix => 'Venus sign';

  @override
  String get lcAttractionTitle => 'Attraction & Chemistry';

  @override
  String get lcAttractionScore => 'Attraction Score';

  @override
  String get lcActiveContacts => 'Active Venus Contacts';

  @override
  String get lcEmotionalTitle => 'Emotional Harmony';

  @override
  String get lcEmotionalScore => 'Emotional Harmony Score';

  @override
  String get lcNakshatraCompat => 'Nakshatra Compatibility';

  @override
  String get lcYoniKoota => 'Yoni Koota';

  @override
  String get lcGanaKoota => 'Gana Koota';

  @override
  String get lcTaraKoota => 'Tara Koota';

  @override
  String get lcBhakootAxis => 'Bhakoot Axis';

  @override
  String get lcMentalTitle => 'Mental Rapport';

  @override
  String get lcMentalScore => 'Mental Rapport Score';

  @override
  String get lcPassionTitle => 'Passion & Physical';

  @override
  String get lcPassionScore => 'Passion Score';

  @override
  String get lcLongtermTitle => 'Long-Term Harmony';

  @override
  String get lcLongtermScore => 'Long-Term Harmony Score';

  @override
  String get lcCommitmentPotential => 'Commitment Potential';

  @override
  String get lc7thHouseSynastry => '7th House Synastry';

  @override
  String get lcJupiterBlessing => 'Jupiter ka Aashirwad';

  @override
  String get lcD9Resonance => 'D9 Navamsa Resonance';

  @override
  String get lcSaturnLongevity => 'Shani Longevity';

  @override
  String get lcKarmicTitle => 'Karmic Love Bond';

  @override
  String get lcKarmicScore => 'Karmic Bond Score';

  @override
  String get lcKetuContacts => 'Ketu Contacts';

  @override
  String get lcRahuContacts => 'Rahu Contacts';

  @override
  String get lcChallengesTitle => 'Challenges & Friction';

  @override
  String get lcNoChallenges =>
      'Dono charts mein koi bada friction-point nahi mila';

  @override
  String get lcTotalPenalty => 'Total Challenge Penalty';

  @override
  String get lcTimingTitle => 'Love ka Timing — Moola Dasha';

  @override
  String get lcDynamicsTitle => 'Relationship Dynamics';

  @override
  String get lcPowerBalance => 'Power Balance';

  @override
  String get lcGiverReceiver => 'Emotional Giver/Receiver';

  @override
  String get lcGrowthDynamic => 'Growth Dynamic';

  @override
  String get lcAreasToNurture => 'Nurture karne wale Areas';

  @override
  String get lcTopicTiming => 'Hamare rishte ke liye best timing';

  @override
  String get lcTopicChallenges => 'Navigate karne wali Challenges';

  @override
  String get lcTopicKarmic => 'Hamara karmic connection';

  @override
  String get lcTopicRemedies => 'Recommended remedies';

  @override
  String get lcTopicLongterm => 'Hamari long-term potential';

  @override
  String get lcTopicDynamics => 'Hamari relationship dynamics';

  @override
  String get cpSubtitle => 'AI-powered Vedic Santan Sambhavna Report';

  @override
  String get cpTitle => 'Santan Sambhavna';

  @override
  String get cpSnapshotHeader => 'Santan Sambhavna Snapshot';

  @override
  String get cpGauge5thHouse => '5th House (Pancham Bhava)';

  @override
  String get cpGaugeJupiter => 'Guru/Putrakaraka';

  @override
  String get cpGaugeD7 => 'D7 Saptamsa';

  @override
  String get cpGaugeSphuta => 'Beeja-Kshetra';

  @override
  String get cpGaugeTiming => 'Dasha Timing';

  @override
  String get cpChipStrongPutrakaraka => 'Strong Putrakaraka (Guru)';

  @override
  String get cpChipLowDoshaPenalty => 'Kam dosha penalty';

  @override
  String get cpChipFavorableTiming => 'Anukool dasha timing';

  @override
  String get cpChipNoDoshas => 'Koi santan-dosha nahi mila';

  @override
  String get cpPartnersTitle => 'Partner Snapshot';

  @override
  String get cpLagnaSuffix => 'Lagna';

  @override
  String get cpMoonSuffix => 'Chandra rashi';

  @override
  String get cpNumberTitle => 'Bachchon ki Sankhya aur Gender Tendency';

  @override
  String get cpProbableNumber => 'Sambhavit Sankhya';

  @override
  String get cpFirstChildTendency => 'Pehli Santan ki Tendency';

  @override
  String get cpSpacing => 'Spacing Note';

  @override
  String get cpTimingTitle => 'Timing — Moola Dasha';

  @override
  String get cpCombinedTiming => 'Combined Timing';

  @override
  String get cpNextWindow => 'Agla Anukool Window';

  @override
  String get cp5thHouseTitle => '5th House (Pancham Bhava) Analysis';

  @override
  String get cp5thHouseSubtitle =>
      'Santan ka bhava (Putra Bhava), har vyakti ke liye';

  @override
  String get cpJupiterTitle => 'Guru — Putrakaraka Analysis';

  @override
  String get cpJupiterSubtitle => 'Santan ka natural karak, har vyakti ke liye';

  @override
  String get cpD7Title => 'D7 Saptamsa Analysis';

  @override
  String get cpD7Subtitle => 'Bachchon ke liye khaas divisional chart';

  @override
  String get cpD7Strength => 'D7 Strength';

  @override
  String get cpSphutaTitle => 'Beeja aur Kshetra Sphuta';

  @override
  String get cpBeejaSphuta => 'Beeja Sphuta (Seed)';

  @override
  String get cpKshetraSphuta => 'Kshetra Sphuta (Field)';

  @override
  String get cpDoshaTitle => 'Dosha Analysis';

  @override
  String get cpNoDoshasDetected =>
      'Dono kundli mein koi santan-sambandhit dosha nahi mila';

  @override
  String get cpRemediesTitle => 'Recommended Upay';

  @override
  String get cpAddresses => 'Solutions';

  @override
  String get cpTopicTiming => 'Conception ke liye best timing';

  @override
  String get cpTopicNumber => 'Hamare kitne bachche ho sakte hain';

  @override
  String get cpTopicDosha => 'Address karne wale koi dosha';

  @override
  String get cpTopicRemedies => 'Recommended upay';

  @override
  String get cpTopicFifthHouse => 'Hamare 5th house ki strength';

  @override
  String get cpTopicJupiter => 'Isme Guru ka role';

  @override
  String get riSubtitle => 'AI-powered Vedic Relationship Intelligence Report';

  @override
  String get riTitle => 'Relationship Intel';

  @override
  String get riSnapshotHeader => 'Group Snapshot';

  @override
  String get riGaugeCohesion => 'Group Cohesion';

  @override
  String get riGaugeTrust => 'Trust ka Mahaul';

  @override
  String get riGaugeProductivity => 'Productivity';

  @override
  String get riGaugeCreativity => 'Creativity';

  @override
  String get riChipNoAlerts => 'Koi critical alert nahi';

  @override
  String get riChipStrongCohesion => 'Strong group cohesion';

  @override
  String get riChipHighTrust => 'High trust ka mahaul';

  @override
  String get riChipNoHiddenEnemy => 'Koi hidden-enemy signal nahi';

  @override
  String get riChipHealthyGroup => 'Overall healthy group';

  @override
  String get riProfilesTitle => 'Chart Profiles';

  @override
  String riProfilesSubtitle(Object count) {
    return 'Is group mein $count log';
  }

  @override
  String get riLagnaSuffix => 'Lagna';

  @override
  String get riIntegrity => 'Integrity';

  @override
  String get riWarmth => 'Warmth';

  @override
  String get riTrustworthiness => 'Trustworthiness';

  @override
  String get riAssertiveness => 'Assertiveness';

  @override
  String get riGroupDynamicsTitle => 'Group Dynamics Overview';

  @override
  String get riMostSupportive => 'Most Supportive';

  @override
  String get riMostChallenged => 'Most Challenged';

  @override
  String get riHiddenEnemyAlert => 'Hidden-Enemy Signal Mila';

  @override
  String get riBestWorstTitle => 'Best & Most Challenging Pairs';

  @override
  String get riBestPair => 'STRONGEST BOND';

  @override
  String get riWorstPair => 'NEEDS ATTENTION';

  @override
  String get riAlliances => 'Likely Alliances';

  @override
  String get riConflicts => 'Likely Friction Points';

  @override
  String get riPairwiseTitle => 'Pairwise Analysis';

  @override
  String riPairwiseSubtitle(Object count) {
    return '$count pairs analyze kiye gaye';
  }

  @override
  String get riDynamic => 'Dynamic';

  @override
  String get riKarmicLink => 'Karmic link';

  @override
  String get riMutualTrust => 'Mutual trust';

  @override
  String get riBetrayalRisk => 'Betrayal ka risk';

  @override
  String get riPowerDistribution => 'Power distribution';

  @override
  String get riPowerHealth => 'Power-balance health';

  @override
  String get riCriticalPatternsTitle => 'Critical Patterns';

  @override
  String get riGroupRecsTitle => 'Group Recommendations';

  @override
  String get riSharedPractices => 'Shared Practices';

  @override
  String get riCommStyle => 'Recommended Communication Style';

  @override
  String get riGrowthFocus => 'Recommended Growth Focus';

  @override
  String get riIndividualTitle => 'Individual Guidance';

  @override
  String get riBestAllies => 'Best Allies';

  @override
  String get riHandleWithCare => 'Handle With Care';

  @override
  String get riCoreThemeTitle => 'Core Group Theme';

  @override
  String get riLayerPairwise => 'Pairwise Completeness';

  @override
  String get riLayerD1 => 'Birth Chart (D1)';

  @override
  String get riLayerD9 => 'Navamsa (D9)';

  @override
  String get riLayerD10 => 'Dashamsa (D10)';

  @override
  String get riLayerD30 => 'Trimshamsa (D30)';

  @override
  String get riLayerJaimini => 'Jaimini Signal';

  @override
  String get riLayerBehavior => 'Behavior Clarity';

  @override
  String get riLayerCoherence => 'Group Coherence';

  @override
  String get riTopicDynamics => 'Hamari group dynamics';

  @override
  String get riTopicPairwise => 'Kisi specific pair ki compatibility';

  @override
  String get riTopicAlerts => 'Koi critical alerts';

  @override
  String get riTopicGrowth => 'Hum saath mein kaise grow kar sakte hain';

  @override
  String get riTopicRecs => 'Recommended practices';

  @override
  String get riTopicTheme => 'Hamara core group theme';

  @override
  String get kmSubtitle => 'AI-powered Vedic Kundli Milan Report';

  @override
  String get kmTitle => 'Kundli Milan';

  @override
  String get kmSnapshotHeader => 'Compatibility Snapshot';

  @override
  String kmAshtakootScore(Object score) {
    return 'Ashtakoot: $score/36';
  }

  @override
  String get kmGaugeAshtakoot => 'Ashtakoot %';

  @override
  String get kmGaugeD9 => 'D9 Marriage Karma';

  @override
  String get kmGaugeMangal => 'Mangal Balance';

  @override
  String get kmGaugePapa => 'Karmic Balance';

  @override
  String get kmGaugeAk => 'Soul Resonance';

  @override
  String get kmChipNoNadi => 'Nadi Dosh nahi hai';

  @override
  String get kmChipNoBhakoot => 'Bhakoot Dosh nahi hai';

  @override
  String get kmChipMangalCancelled => 'Mangal Dosh cancel ho gaya';

  @override
  String get kmChipPapaBalanced => 'Balanced karmic load';

  @override
  String get kmChipStrongChemistry => 'Strong physical chemistry';

  @override
  String get kmChipStrongD9 => 'Strong D9 marriage karma';

  @override
  String get kmChipLongevity => 'Strong longevity alignment';

  @override
  String get kmAshtakootTitle => 'Ashtakoot Guna Milan';

  @override
  String get kmAshtakootSubtitle =>
      '36 mein se classical 8-point matching system';

  @override
  String get kmNadiSeverity => 'Nadi severity';

  @override
  String get kmBhakootSeverity => 'Bhakoot severity';

  @override
  String get kmGanaSignature => 'Gana signature';

  @override
  String get kmMangalTitle => 'Mangal Dosha Check';

  @override
  String get kmD9Title => 'D9 Navamsa — Marriage Karma';

  @override
  String get kmD9Subtitle =>
      'Soul-level marriage chart, classically sabse important mani jaati hai';

  @override
  String get kmD9Score => 'D9 Compatibility';

  @override
  String get kmLagnaRelation => 'Lagna relationship';

  @override
  String get km7thLordRelation => '7th lord relationship';

  @override
  String get kmKarakasTitle => 'Soul & Spouse Karakas';

  @override
  String get kmAtmakaraka => 'Soul Planet';

  @override
  String get kmAkCompatibility => 'Soul-Signature Resonance';

  @override
  String get kmUlCompatibility => 'Spouse-Karaka Alignment';

  @override
  String get kmUlSigns => 'Upapada lords';

  @override
  String get kmChemistryTitle => 'Venus-Mars Chemistry';

  @override
  String get kmPhysicalChemistry => 'Physical Chemistry';

  @override
  String get kmEmotionalWarmth => 'Emotional Warmth';

  @override
  String get kmAestheticAlignment => 'Aesthetic Alignment';

  @override
  String get kmElementalSynthesis => 'Elemental Synthesis';

  @override
  String get kmHouseCrossTitle => '7th & 8th House Cross-Analysis';

  @override
  String get km78Compatibility => '7th-8th House Compatibility';

  @override
  String get km8thHouseSignature => 'Joint Longevity Signature';

  @override
  String get kmLongevityAlignment => 'Longevity Alignment';

  @override
  String get km7thLordFriendship => '7th-lord friendship';

  @override
  String get kmDomainsTitle => 'Domain-by-Domain Compatibility';

  @override
  String get kmConflictEngagement => 'Conflict Style';

  @override
  String get kmDashaTitle => 'Dasha & Transit Sync';

  @override
  String get kmDashaSync => 'Dasha Sync';

  @override
  String get kmTransitAlignment => 'Transit Alignment';

  @override
  String get kmTimingTitle => 'Marriage Timing';

  @override
  String get kmMarriageWindow => 'Marriage Window';

  @override
  String get kmEngagementWindow => 'Engagement Window';

  @override
  String get kmRecommendedRange => 'Recommended Timeframe';

  @override
  String get kmMuhurtaNotes => 'Muhurta Notes';

  @override
  String get kmRisksTitle => 'Risks Jo Address Karne Hain';

  @override
  String get kmConflictRisk => 'Conflict Risk';

  @override
  String get kmCommunicationRisk => 'Communication Risk';

  @override
  String get kmFinanceRisk => 'Finance Conflict Risk';

  @override
  String get kmFamilyDynamicsRisk => 'Family Dynamics Risk';

  @override
  String get kmMentalHealthRisk => 'Mental-Health Alignment Risk';

  @override
  String get kmStrengthsTitle => 'Top Compatibility Strengths';

  @override
  String get kmSharedGrowth => 'Shared Growth Potential';

  @override
  String get kmSharedCreative => 'Shared Creative Potential';

  @override
  String get kmJourneyTitle => 'Relationship Journey & Growth';

  @override
  String get kmCurrentPhase => 'Current phase';

  @override
  String get kmEarlyArc => 'Early Marriage';

  @override
  String get kmMiddleArc => 'Middle Marriage';

  @override
  String get kmMatureArc => 'Mature Marriage';

  @override
  String get kmElderArc => 'Elder Years';

  @override
  String get kmPeakPhase => 'Peak Companionship Phase';

  @override
  String get kmGrowthAreas => 'Growth Areas';

  @override
  String get kmCommProtocols => 'Communication Protocols';

  @override
  String get kmSharedPractices => 'Shared Practices';

  @override
  String get kmImprovementTitle => 'Core Theme & Improvement Plan';

  @override
  String get kmVerdictTitle => 'Final Verdict';

  @override
  String get kmRealizationPotential => 'Relationship Realization Potential';

  @override
  String get kmLayerAshtakoot => 'Ashtakoot';

  @override
  String get kmLayerD9 => 'D9 Navamsa';

  @override
  String get kmLayerMangalPapa => 'Mangal & Papasamya';

  @override
  String get kmLayerVenusMars => 'Venus-Mars';

  @override
  String get kmLayerDashaSync => 'Dasha Sync';

  @override
  String get kmLayerH7H8 => '7th-8th House Cross';

  @override
  String get kmLayerAkResonance => 'Atmakaraka Resonance';

  @override
  String get kmLayerDomains => 'Domain Dimensions';

  @override
  String get kmTopicAshtakoot => 'Hamara Ashtakoot score';

  @override
  String get kmTopicMangal => 'Mangal Dosha concerns';

  @override
  String get kmTopicD9 => 'Hamara marriage karma (D9)';

  @override
  String get kmTopicTiming => 'Best marriage timing';

  @override
  String get kmTopicRisks => 'Risks jinke liye prepare karna hai';

  @override
  String get kmTopicGrowth => 'Hum saath mein kaise grow kar sakte hain';

  @override
  String get kmTopicRemedies => 'Recommended remedies';

  @override
  String get kmTopicVerdict =>
      'Kya humein marriage ke liye aage badhna chahiye';

  @override
  String get pkSubtitle => 'AI-powered Vedic Past Life & Karma Report';

  @override
  String get pkTitle => 'Past Life & Karma';

  @override
  String get pkSnapshotHeader => 'Past-Life ki Jhalak';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return 'Aapki kundli mein ek \'$theme\' past-life signature dikhta hai, jo abhi is life mein $relation ho raha hai. Recommended path: $strategy.';
  }

  @override
  String get pkGaugeSignature => 'Signature Strength';

  @override
  String get pkGaugeMasteryPreserved => 'Preserved Mastery';

  @override
  String get pkGaugeClearingProgress => 'Karma Clearing';

  @override
  String get pkGaugeMaturity => 'Past-Life Maturity';

  @override
  String get pkGaugeMemoryAccess => 'Memory Access';

  @override
  String get pkChipGoodProgress => 'Karma-clearing mein achhi progress';

  @override
  String get pkChipLowDebt => 'Kam karmic debt';

  @override
  String get pkChipMatureSoul => 'Mature soul signature';

  @override
  String get pkChipGiftedPast => 'Kundli mein past-life ka gift hai';

  @override
  String get pkChipAccomplished => 'Accomplished past life';

  @override
  String get pkChipMasteryPreserved => 'Strong mastery aage carry hui hai';

  @override
  String get pkKetuTitle => 'Ketu — Aapki Past Mastery';

  @override
  String get pkKetuSubtitle =>
      'Wo skills jo aapki soul already master kar chuki hai';

  @override
  String get pkMasteryStrength => 'Mastery Strength';

  @override
  String get pkSkillsCarried => 'Aage Carry Hue Skills';

  @override
  String get pkInstincts => 'Instinctual Capacities';

  @override
  String get pkKetuDignity => 'Ketu ki dignity';

  @override
  String get pkRahuTitle => 'Rahu — Aapki Soul ka Growth Edge';

  @override
  String get pkRahuSubtitle => 'Aapki soul yahan kya complete karne aayi hai';

  @override
  String get pkUnmetDesires => 'Adhoori Desires';

  @override
  String get pkProfileTitle => 'Aapki Past-Life Profile';

  @override
  String get pkProfession => 'Likely Profession';

  @override
  String get pkSocialStanding => 'Social Standing';

  @override
  String get pkRegion => 'Likely Region';

  @override
  String get pkCulturalArchetype => 'Cultural Archetype';

  @override
  String get pkAccomplishment => 'Accomplishment Level';

  @override
  String get pkAuthority => 'Authority Level';

  @override
  String get pkFamilyRole => 'Family role';

  @override
  String get pkSecondaryProfession => 'Secondary profession';

  @override
  String get pkClimateAffinity => 'Climate affinity';

  @override
  String get pkForeignResidence => 'Foreign-residence karma';

  @override
  String get pkRelationshipsTitle => 'Aage Carry Hue Past Relationships';

  @override
  String get pkSpouseConnection => 'Spouse Reconnection';

  @override
  String get pkChildrenConnection => 'Children Reconnection';

  @override
  String get pkCarriedRelationTypes => 'Relationship Patterns';

  @override
  String get pkPartnerArchetype => 'Past-Life Partner Archetype';

  @override
  String get pkDarakaraka => 'Spouse karaka';

  @override
  String get pkParentsKarma => 'Parents karma pattern';

  @override
  String get pkSiblingKarma => 'Sibling karma pattern';

  @override
  String get pkSpiritualTitle => 'Tab Aapki Spiritual Life';

  @override
  String get pkSpiritualLevel => 'Spiritual Level';

  @override
  String get pkPracticeSignature => 'Practice Style';

  @override
  String get pkMeditativeCapacity => 'Meditative Capacity';

  @override
  String get pkDevotionalPractice => 'Devotional Practice';

  @override
  String get pkYogicAttainment => 'Yogic Attainment';

  @override
  String get pkMokshaProximity => 'Moksha Proximity';

  @override
  String get pkKarmicDebtsTitle => 'Karmic Debts & Tab ki Wealth';

  @override
  String get pkTotalKarmicDebt => 'Total Karmic Debt';

  @override
  String get pkPrimaryDebtType => 'Primary Debt Type';

  @override
  String get pkRelationshipDebt => 'Relationship Debt';

  @override
  String get pkFinancialDebt => 'Financial Debt';

  @override
  String get pkServiceDebt => 'Service Debt';

  @override
  String get pkDharmicDebt => 'Dharmic Debt';

  @override
  String get pkPitruKarma => 'Pitru karma';

  @override
  String get pkMatruKarma => 'Matru karma';

  @override
  String get pkWealthLevel => 'Tab ka Wealth Level';

  @override
  String get pkWealthKarmaCarried => 'Aage Carry Hua Wealth Karma';

  @override
  String get pkResourcePattern => 'Resource management';

  @override
  String get pkGainSource => 'Gain source';

  @override
  String get pkEchoesTitle => 'Is Life Mein Echoes';

  @override
  String get pkOnRelationships => 'Relationships Par';

  @override
  String get pkOnCareer => 'Career Par';

  @override
  String get pkOnHealth => 'Health Par';

  @override
  String get pkOnSpirituality => 'Spirituality Par';

  @override
  String get pkDominantArea => 'Sabse Strong Carryforward';

  @override
  String get pkAttractions => 'Natural Attractions';

  @override
  String get pkAversions => 'Natural Aversions';

  @override
  String get pkUnexplainedFears => 'Unexplained Fears';

  @override
  String get pkMagneticPulls => 'Magnetic Pulls';

  @override
  String get pkResolutionTitle => 'Karmic Resolution & Completion';

  @override
  String get pkPrimaryPathway => 'Primary Path';

  @override
  String get pkSecondaryPathway => 'Secondary Path';

  @override
  String get pkClearingProgress => 'Clearing Progress';

  @override
  String get pkRemainingWork => 'Bacha Hua Kaam';

  @override
  String get pkSettlementTimeline => 'Settlement Timeline';

  @override
  String get pkAccelerationPractices => 'Resolution Speed Karne Wali Practices';

  @override
  String get pkPriorityAreas => 'Priority Areas';

  @override
  String get pkVerificationTitle => 'Charts Mein Verified (D60)';

  @override
  String get pkD60Label => 'D60 Past-Life Era';

  @override
  String get pkD60Ketu => 'D60 Ketu placement';

  @override
  String get pkD60Standing => 'Overall standing';

  @override
  String get pkMemoryTitle => 'Memory & Intuition';

  @override
  String get pkMemoryAccess => 'Memory Access';

  @override
  String get pkRegressionFit => 'Regression-Therapy Fit';

  @override
  String get pkDreamVisits => 'Dream Visitations';

  @override
  String get pkDejaVuFrequency => 'Deja Vu Frequency';

  @override
  String get pkSpontaneousRemembrance => 'Spontaneous remembrance';

  @override
  String get pkRemembrancePractices => 'Remembrance Practices';

  @override
  String get pkTimelineTitle => 'Activation Timeline';

  @override
  String get pkGiftsActivation => 'Past-Life Gifts ka Activation';

  @override
  String get pkSurfaceWindow => 'Surfacing Window';

  @override
  String get pkRisksTitle => 'Risks & Chronic Patterns';

  @override
  String get pkTraumaResidue => 'Trauma Residue';

  @override
  String get pkSpiritualBypass => 'Spiritual Bypass Risk';

  @override
  String get pkMajorRisks => 'Major Risks';

  @override
  String get pkChronicImprints => 'Chronic Imprints';

  @override
  String get pkKarmicLoops => 'Karmic Loops';

  @override
  String get pkImprovementTitle => 'Improvement Plan';

  @override
  String get pkRoadmapTitle => 'Aapka Past-Life Roadmap';

  @override
  String get pkMaturity => 'Past-Life Maturity';

  @override
  String get pkLayerD1 => 'Birth Chart (D1)';

  @override
  String get pkLayerD9 => 'Navamsa (D9)';

  @override
  String get pkLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get pkLayerKetuDepth => 'Ketu Depth';

  @override
  String get pkLayerAtmakaraka => 'Soul Planet (Atmakaraka)';

  @override
  String get pkTopicMastery => 'Meri past-life mastery';

  @override
  String get pkTopicUnfinished => 'Mera adhoora karma';

  @override
  String get pkTopicRelationships => 'Mere past-life relationships';

  @override
  String get pkTopicDebts => 'Mere karmic debts';

  @override
  String get pkTopicResolution => 'Apna karma kaise resolve karein';

  @override
  String get pkTopicMemory => 'Past-life memory access';

  @override
  String get pkTopicTiming => 'Best timing windows';

  @override
  String get pkTopicProfile => 'Past life mein main kaun tha';

  @override
  String get chSubtitle => 'AI-powered Vedic Character Analysis Report';

  @override
  String get chTitle => 'Character Analysis';

  @override
  String get chSnapshotHeader => 'Character Snapshot';

  @override
  String get chGaugeIntegrity => 'Integrity';

  @override
  String get chGaugeResilience => 'Resilience';

  @override
  String get chGaugeSelfAwareness => 'Self-Awareness';

  @override
  String get chGaugeStability => 'Emotional Stability';

  @override
  String get chGaugeMoralFabric => 'Moral Fabric';

  @override
  String get chChipRajaYoga => 'Raja Yoga maujood';

  @override
  String get chChipHighIntegrity => 'High integrity';

  @override
  String get chChipResilient => 'Resilient nature';

  @override
  String get chChipDharmic => 'Strong dharma orientation';

  @override
  String get chChipEmpathetic => 'Naturally empathetic';

  @override
  String get chChipLoyal => 'Deeply loyal';

  @override
  String get chChipGiftedCharacter => 'Chart mein character ka gift hai';

  @override
  String get chSoulTitle => 'Aapki Soul Signature';

  @override
  String get chSoulIntegration => 'Soul-Character Integration';

  @override
  String get chAmatyakarakaTheme => 'Supporting Character Voice';

  @override
  String get chAtmakarakaDignity => 'Soul-planet ki dignity';

  @override
  String get chAtmakarakaHouse => 'House placement';

  @override
  String get chSurfaceTitle => 'Surface Personality & Constitution';

  @override
  String get chLagnaSign => 'Ascendant (Lagna) Sign';

  @override
  String get chConstitution => 'Constitution';

  @override
  String get chSurfaceSignature => 'Aap dusron ko kaise lagte hain';

  @override
  String get chPhysicalConstitution => 'Physical Constitution';

  @override
  String get chLagnaLord => 'Lagna Lord';

  @override
  String get chLagnaOccupants => 'Lagna mein planets';

  @override
  String get chMindEmotionsTitle => 'Mind, Emotions & Ego';

  @override
  String get chEmotionalNature => 'Aapki Emotional Nature';

  @override
  String get chMentalStability => 'Mental Stability';

  @override
  String get chSelfConfidence => 'Healthy Self-Confidence';

  @override
  String get chEgoNature => 'Aapka Ego & Self-Concept';

  @override
  String get chAuthorityRelationship => 'Authority ke saath relationship';

  @override
  String get chPrideTendency => 'Pride Tendency';

  @override
  String get chMoodPatterns => 'Mood Patterns';

  @override
  String get chKemadrumaPresent =>
      'Kemadruma Yoga present hai — extra emotional self-care faydemand hai.';

  @override
  String get chFatherImprint => 'Father imprint ki quality';

  @override
  String get chCommunicationTitle => 'Communication & Intellect Style';

  @override
  String get chIntellectStyle => 'Intellect Style';

  @override
  String get chCommStyle => 'Communication Style';

  @override
  String get chDecisionStyle => 'Decision-Making Style';

  @override
  String get chDiscrimination => 'Discrimination Capacity';

  @override
  String get chPersonaTitle => 'Public Persona vs True Self';

  @override
  String get chAuthenticityGap => 'Authenticity Gap';

  @override
  String get chGunaTitle => 'Guna & Dosha Profile';

  @override
  String get chGunaSubtitle =>
      'Aapki inner nature aur constitution, classical Vedic style mein';

  @override
  String get chSattva => 'Sattva';

  @override
  String get chRajas => 'Rajas';

  @override
  String get chTamas => 'Tamas';

  @override
  String get chDominantGuna => 'Dominant Guna';

  @override
  String get chPitta => 'Pitta';

  @override
  String get chKapha => 'Kapha';

  @override
  String get chVata => 'Vata';

  @override
  String get chDominantDosha => 'Dominant Dosha';

  @override
  String get chRahuRestlessness => 'Rahu ki restlessness';

  @override
  String get chKetuDetachment => 'Ketu ki detachment';

  @override
  String get chYogasTitle => 'Character Yogas';

  @override
  String get chRajaYogaStrength => 'Raja Yoga Strength';

  @override
  String get chGiftYogas => 'Gift Yogas';

  @override
  String get chTestYogas => 'Test Yogas';

  @override
  String get chStrengthsTitle => 'Strengths & Talents';

  @override
  String get chSignatureVirtues => 'Signature Virtues';

  @override
  String get chNaturalTalents => 'Natural Talents';

  @override
  String get chSoftSkills => 'Soft Skills';

  @override
  String get chHiddenStrengths => 'Develop karne wali Hidden Strengths';

  @override
  String get chShadowTitle => 'Shadow & Growth Areas';

  @override
  String get chShadowSubtitle =>
      'Kaam karne layak patterns ki gentle awareness';

  @override
  String get chShadowPatterns => 'Shadow Patterns';

  @override
  String get chBlindSpots => 'Blind Spots';

  @override
  String get chEmotionalWounds => 'Emotional Wounds';

  @override
  String get chShadowWorkPriorities => 'Shadow-Work Priorities';

  @override
  String get chMoralTests => 'Moral Tests';

  @override
  String get chRelationshipsTitle => 'Relationships & Social Style';

  @override
  String get chWarmth => 'Interpersonal Warmth';

  @override
  String get chEmpathy => 'Empathy Capacity';

  @override
  String get chLoyalty => 'Loyalty Capacity';

  @override
  String get chBoundaries => 'Boundary Setting';

  @override
  String get chSocialConfidence => 'Social Confidence';

  @override
  String get chTrustGiving => 'Trust dene ka baseline';

  @override
  String get chConflictStyle => 'Conflict style';

  @override
  String get chEthicsTitle => 'Ethics & Moral Compass';

  @override
  String get chDharmaOrientation => 'Dharma Orientation';

  @override
  String get chTruthfulness => 'Truthfulness';

  @override
  String get chCompassion => 'Compassion';

  @override
  String get chGenerosity => 'Generosity';

  @override
  String get chEthicalConsistency => 'Ethical Consistency';

  @override
  String get chIntegrityPressure => 'Pressure mein Integrity';

  @override
  String get chJusticeFairness => 'Justice & Fairness';

  @override
  String get chMoralTrajectory => 'Moral development';

  @override
  String get chEiTitle => 'Emotional Intelligence';

  @override
  String get chEiSelfAwareness => 'Self-Awareness';

  @override
  String get chEiSelfRegulation => 'Self-Regulation';

  @override
  String get chEiEmpathy => 'Empathy';

  @override
  String get chEiSocialSkills => 'Social Skills';

  @override
  String get chMotivation => 'Internal Motivation';

  @override
  String get chVulnerabilityComfort => 'Vulnerability ke saath comfort';

  @override
  String get chEmotionalExpression => 'Emotional expression ka comfort';

  @override
  String get chEmotionalReceptivity => 'Emotional receptivity';

  @override
  String get chVerificationTitle => 'Charts mein Verified (D9/D12/D30/D60)';

  @override
  String get chD9Label => 'D9 Dharma-Character';

  @override
  String get chD12Label => 'D12 Ancestral Inheritance';

  @override
  String get chD30Label => 'D30 Shadow Profile';

  @override
  String get chD60Label => 'D60 Past-Life Character';

  @override
  String get chD30Standing => 'Shadow standing';

  @override
  String get chMaternalInheritance => 'Maternal inheritance';

  @override
  String get chAncestralKarmaWeight => 'Ancestral karma ka weight';

  @override
  String get chTimelineTitle => 'Character Timeline';

  @override
  String get chFormationWindow => 'Formation Window';

  @override
  String get chMaturationWindow => 'Maturation Window';

  @override
  String get chLegacyWindow => 'Legacy Window';

  @override
  String get chPeakMaturationAge => 'Peak maturation age';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return 'Age $ageRange';
  }

  @override
  String get chImprovementTitle => 'Improvement Plan';

  @override
  String get chRoadmapTitle => 'Aapka Character Roadmap';

  @override
  String get chAuthenticExpression => 'Authentic Self-Expression';

  @override
  String get chRealizationPotential => 'Character Realization Potential';

  @override
  String get chLayerAtmakaraka => 'Soul Planet (Atmakaraka)';

  @override
  String get chLayerD1 => 'Birth Chart (D1)';

  @override
  String get chLayerD9 => 'Navamsa (D9)';

  @override
  String get chLayerD30 => 'Trimshamsa (D30)';

  @override
  String get chLayerLagnaMoon => 'Ascendant & Moon';

  @override
  String get chLayerArudha => 'Arudha Lagna';

  @override
  String get chTopicStrengths => 'Meri character strengths';

  @override
  String get chTopicShadow => 'Mere shadow patterns';

  @override
  String get chTopicSoul => 'Meri soul signature';

  @override
  String get chTopicRelationships => 'Mera relationship style';

  @override
  String get chTopicEthics => 'Meri ethics & values';

  @override
  String get chTopicGuna => 'Mera guna & dosha profile';

  @override
  String get chTopicGrowth => 'Apna character kaise grow karein';

  @override
  String get chTopicTiming => 'Character work ke liye best timing';

  @override
  String get lpSubtitle => 'AI-powered Vedic Life Path aur Luck Report';

  @override
  String get lpTitle => 'Life Path aur Luck';

  @override
  String get lpSnapshotHeader => 'Life Path ki Jhalak';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return 'Aap ek $archetype hain jinka main purpose $domain mein hai. Hamare analysis ke hisab se aapki overall life-fulfillment potential $probability% hai.';
  }

  @override
  String get lpGaugeDharma => 'Dharma Clarity';

  @override
  String get lpGaugeFortune => 'Fortune Baseline';

  @override
  String get lpGaugeCoherence => 'Path Coherence';

  @override
  String get lpGaugeFulfillment => 'Fulfillment';

  @override
  String get lpGaugeMomentum => 'Karmic Momentum';

  @override
  String get lpChipRareGift => 'Rare destiny gift';

  @override
  String get lpChipFreeWillStrong => 'Strong free will';

  @override
  String get lpChipGraceSupported => 'Grace se supported';

  @override
  String get lpChipLightKarma => 'Halka karmic load';

  @override
  String get lpChipRecognitionPotential => 'Recognition ki possibility';

  @override
  String get lpChipSpiritualPath => 'Strong spiritual pull';

  @override
  String get lpChipBlessed => 'Kundli mein blessings hai';

  @override
  String get lpSoulPathTitle => 'Aapka Soul Path';

  @override
  String get lpSoulPlanet => 'Soul Planet';

  @override
  String get lpCareerPlanet => 'Purpose Planet';

  @override
  String get lpSoulClarity => 'Purpose Clarity';

  @override
  String get lpLifeChapter => 'Current Life Chapter';

  @override
  String get lpPrimaryDomain => 'Primary Purpose Domain';

  @override
  String get lpKarakaTitle => 'Aapke Dharma Planets';

  @override
  String get lpKarakaSubtitle =>
      'Har planet aapke life purpose ko kitna support karta hai';

  @override
  String get lpVerificationTitle => 'Charts mein Verified (D9 / D60)';

  @override
  String get lpD9Label => 'D9 Soul Alignment';

  @override
  String lpD9Explain(Object stage) {
    return 'Navamsa chart mein aapki soul-evolution stage \'$stage\' hai.';
  }

  @override
  String get lpD9JupiterDignity => 'Jupiter (Guru) ki dignity';

  @override
  String get lpD9DharmaMultiplier => 'Dharma multiplier';

  @override
  String get lpD60Label => 'D60 Past-Life Signature';

  @override
  String get lpKarmaType => 'Past-life karma type';

  @override
  String get lpKetuMastery => 'Ketu ki past-life mastery';

  @override
  String get lpRahuGrowthDir => 'Rahu ki growth direction';

  @override
  String get lpYogasTitle => 'Fortune Yogas aur Luck Blocks';

  @override
  String get lpFortuneBoost => 'Fortune Boost';

  @override
  String get lpLuckDrain => 'Luck Drain';

  @override
  String get lpFortuneBoosters => 'Fortune Boosters';

  @override
  String get lpLuckBlocks => 'Luck Blocks';

  @override
  String get lpPurposeTitle => 'Purpose Domains aur Fame';

  @override
  String get lpDomainLeadership => 'Leadership';

  @override
  String get lpDomainWisdom => 'Wisdom aur Teaching';

  @override
  String get lpDomainService => 'Service';

  @override
  String get lpDomainHealing => 'Healing';

  @override
  String get lpDomainCreative => 'Creative Expression';

  @override
  String get lpPrimaryDomainBadge => 'Primary';

  @override
  String get lpFameRecognition => 'Fame aur Recognition';

  @override
  String get lpSocialInfluence => 'Social Influence';

  @override
  String get lpRecognitionDomain => 'Recognition Field';

  @override
  String get lpPublicImage => 'Public Image';

  @override
  String get lpHistoricalImpact => 'Historical impact potential';

  @override
  String get lpTimelineTitle => 'Fortune aur Life Timeline';

  @override
  String get lpCurrentPhase => 'Current Fortune Phase';

  @override
  String get lpJupiterReturn => 'Jupiter Return';

  @override
  String get lpSaturnReturn => 'Saturn Return';

  @override
  String get lpSadeSati => 'Sade Sati';

  @override
  String get lpGoldenWindow => 'Golden Window';

  @override
  String get lpTransformationWindow => 'Transformation Window';

  @override
  String get lpPeakYears => 'Peak Fortune Years';

  @override
  String get lpChallengingYears => 'Challenging Years';

  @override
  String get lpMilestonesTitle => 'Major Milestones aur Turning Points';

  @override
  String get lpFirstTurningPoint => 'Pehla Bada Turning Point';

  @override
  String get lpMidlifeTransform => 'Midlife Transformation';

  @override
  String get lpLateLifeFulfillment => 'Late-Life Fulfillment';

  @override
  String lpDharmicMilestone(Object age) {
    return 'Dharmic Milestone (Age $age)';
  }

  @override
  String lpAgeLabel(Object age) {
    return 'Age $age';
  }

  @override
  String get lpDestinyTitle => 'Destiny vs Free Will';

  @override
  String get lpDestinyStat => 'Destiny Weight';

  @override
  String get lpFreeWillStat => 'Free Will Leverage';

  @override
  String get lpFateStrength => 'Fate Signature Strength';

  @override
  String get lpSelfCreation => 'Self-Creation Capacity';

  @override
  String get lpEffortGrace => 'Effort vs grace';

  @override
  String get lpKarmicTitle => 'Karmic Lessons';

  @override
  String get lpRahuGrowthLabel => 'Rahu — Growth Challenge';

  @override
  String get lpKetuSurrenderLabel => 'Ketu — Surrender Theme';

  @override
  String get lpSaturnLessonLabel => 'Saturn — Discipline Lesson';

  @override
  String get lpTestDifficulty => 'Life Test Difficulty';

  @override
  String get lpLessonsInProgress => 'Lessons In Progress';

  @override
  String get lpSoulContract => 'Soul Contract Areas';

  @override
  String get lpSoulExperience => 'Aapki Soul Kya Experience Karne Aayi Hai';

  @override
  String get lpSoulMastery => 'Aapki Soul Kya Master Karne Aayi Hai';

  @override
  String get lpSpiritualTitle => 'Spiritual Path';

  @override
  String get lpSpiritualInclination => 'Spiritual Inclination';

  @override
  String get lpMeditationReceptivity => 'Meditation Receptivity';

  @override
  String get lpTeacherKarma => 'Teacher/Guru Karma';

  @override
  String get lpPilgrimageBenefit => 'Pilgrimage (Teerth Yatra) Benefit';

  @override
  String get lpSelfRealization => 'Self-Realization Potential';

  @override
  String get lpDivineConnection => 'Divine Connection';

  @override
  String get lpTraditionAffinity => 'Tradition affinity';

  @override
  String get lpIntuitionStrength => 'Intuition strength';

  @override
  String get lpMantraEfficacy => 'Prayer/mantra efficacy';

  @override
  String get lpInnerGuidance => 'Inner-guidance par trust';

  @override
  String get lpPropheticDreams => 'Prophetic-dream sensitivity';

  @override
  String get lpDifficultyTitle => 'Life Difficulty aur Challenges';

  @override
  String get lpEarlyLife => 'Early Life';

  @override
  String get lpMidlife => 'Midlife';

  @override
  String get lpLateLife => 'Late Life';

  @override
  String get lpStruggleToSuccess => 'Struggle-to-Success Karma';

  @override
  String get lpUnlivedLifeRisk => 'Unlived-Life Risk';

  @override
  String get lpChallenges => 'Life Challenges';

  @override
  String get lpFortuneDrains => 'Chronic Fortune Drains';

  @override
  String get lpRegretAreas => 'Regret-Vulnerability Areas';

  @override
  String get lpRedFlags => 'Direction Red Flags';

  @override
  String get lpBlessingsTitle => 'Blessings aur Core Life Theme';

  @override
  String get lpKarmicRoot => 'Karmic root';

  @override
  String get lpBlessingsList => 'Aapki Blessings';

  @override
  String get lpFulfillmentPriorities => 'Fulfillment Priorities';

  @override
  String get lpImprovementTitle => 'Improvement Plan';

  @override
  String get lpDharmaPriorities => 'Dharma Priorities';

  @override
  String get lpRoadmapTitle => 'Aapka Destiny Roadmap';

  @override
  String get lpStrategy => 'Strategy';

  @override
  String get lpFulfillmentPotential => 'Fulfillment Potential';

  @override
  String get lpNext12Focus => 'Agle 12-Month ka Focus';

  @override
  String get lpLayerD1 => 'Birth Chart (D1)';

  @override
  String get lpLayerD9 => 'Navamsa (D9)';

  @override
  String get lpLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get lpLayerDasha => 'Dasha Timing';

  @override
  String get lpLayerTransit => 'Current Transits';

  @override
  String get lpTopicPurpose => 'Mera life purpose';

  @override
  String get lpTopicFortune => 'Mere fortune yogas';

  @override
  String get lpTopicKarma => 'Mere karmic lessons';

  @override
  String get lpTopicMilestones => 'Upcoming milestones';

  @override
  String get lpTopicDestiny => 'Destiny vs free will';

  @override
  String get lpTopicSpiritual => 'Mera spiritual path';

  @override
  String get lpTopicChallenges => 'Meri life challenges';

  @override
  String get lpTopicTiming => 'Best timing windows';

  @override
  String get dbSubtitle => 'AI-powered Vedic Debt & Recovery Report';

  @override
  String get dbTitle => 'Debt & Recovery';

  @override
  String get dbSnapshotHeader => 'Debt Recovery Snapshot';

  @override
  String dbHeroSummary(
    Object phase,
    Object personality,
    Object probability,
    Object years,
  ) {
    return 'Aap abhi \'$phase\' phase mein hain aur paise ko lekar aapka approach $personality hai. Hamare analysis ke hisaab se lagbhag $years saal mein debt-free hone ka $probability% chance hai.';
  }

  @override
  String get dbGaugeCapacity => 'Recovery Capacity';

  @override
  String get dbGaugeProbability => 'Recovery Chance';

  @override
  String get dbGaugeFreedomNow => 'Abhi Debt Freedom';

  @override
  String get dbGaugeDti => 'Income Health';

  @override
  String get dbGaugeResilience => 'Resilience';

  @override
  String get dbChipCleanKarma => 'Saaf debt karma';

  @override
  String get dbChipStrongRecovery => 'Strong recovery capacity';

  @override
  String get dbChipHealthyDti => 'Healthy debt-to-income';

  @override
  String get dbChipResilient => 'High mental resilience';

  @override
  String get dbChipCycleBreakable => 'Debt cycle todna possible hai';

  @override
  String get dbChipLowReindebt => 'Dobara karzdaar hone ka kam risk';

  @override
  String get dbChipGoodNegotiator => 'Achhi negotiation chances';

  @override
  String get dbProfileTitle => 'Aapki Debt Profile';

  @override
  String get dbPhaseLabel => 'Current phase';

  @override
  String get dbPrimaryCategoryLabel => 'Main category';

  @override
  String get dbKarakaLabel => 'Debt Karaka';

  @override
  String get dbProtectorLabel => 'Creditor Protection';

  @override
  String get dbSecondaryCategories => 'Secondary categories';

  @override
  String get dbUnsecuredRatio => 'Unsecured-debt ratio';

  @override
  String get dbKarakaTitle => 'Aapke Debt Planets';

  @override
  String get dbKarakaSubtitle =>
      'Har planet aapki debt recovery ko kitni strongly support karta hai';

  @override
  String get dbVerificationTitle => 'Sabhi charts mein verified (D6)';

  @override
  String get dbD6Label => 'D6 Debt & Enemies Chart';

  @override
  String get dbD6LordDignity => '6th lord ki strength';

  @override
  String get dbD6Severity => 'Debt karma ki severity';

  @override
  String get dbD6Multiplier => 'D6 debt multiplier';

  @override
  String get dbYogasTitle => 'Debt Yogas & Protections';

  @override
  String get dbPressureNow => 'Abhi Debt Pressure';

  @override
  String get dbRecoveryBoost => 'Recovery Boost';

  @override
  String get dbClearingLabel => 'Debt-Clearing Yogas';

  @override
  String get dbCreatingLabel => 'Debt-Creating Yogas';

  @override
  String get dbCategoriesTitle => 'Debt Categories Watch';

  @override
  String get dbCategoriesSubtitle =>
      'Kis type ke debt par sabse zyada dhyan dena hai';

  @override
  String get dbTimelineTitle => 'Debt-Free Timeline';

  @override
  String get dbFreeWindowLabel => 'DEBT-FREE WINDOW';

  @override
  String get dbClearanceEstimate => 'Full clearance ka estimate';

  @override
  String get dbPeakYears => 'Debt-Peak Years';

  @override
  String get dbClearanceYears => 'Clearance Years';

  @override
  String get dbBorrowTitle => 'Smart Borrowing Guide';

  @override
  String get dbLoanSuitability => 'Loan Suitability';

  @override
  String get dbBestLoanType => 'Best Loan Type';

  @override
  String get dbLeverageCeiling => 'Leverage Ceiling';

  @override
  String get dbNegotiationSuccess => 'Negotiation Success';

  @override
  String get dbCreditorAggression => 'Creditor Pressure Risk';

  @override
  String get dbLegalEscalation => 'Legal Escalation Risk';

  @override
  String get dbNegotiationApproach => 'Recommended approach';

  @override
  String get dbAvoidLoanTypes => 'In Loan Types se bachein';

  @override
  String get dbRiskTitle => 'Risk & Vulnerability Watch';

  @override
  String get dbRiskDefault => 'Default Risk';

  @override
  String get dbRiskDefaultExp =>
      'Scheduled repayment itni badly miss hone ka chance ki lender ke saath default status trigger ho jaaye.';

  @override
  String get dbRiskDefaultFix =>
      'Minimum payments automate karein aur 1-month ka buffer rakhein taaki ek miss hua income cycle aage cascade na ho.';

  @override
  String get dbRiskBankruptcy => 'Bankruptcy Risk';

  @override
  String get dbRiskBankruptcyExp =>
      'Debt load ke itna badhne ka chance ki income aur assets realistically cover na kar paayein.';

  @override
  String get dbRiskBankruptcyFix =>
      'Koi bhi naya loan ya credit line lene se pehle professional debt review karwayein.';

  @override
  String get dbRiskAssetSeizure => 'Asset-Seizure Risk';

  @override
  String get dbRiskAssetSeizureExp =>
      'Secured loan default hone par lender ke collateral ya property repossess karne ka chance.';

  @override
  String get dbRiskAssetSeizureFix =>
      'Secured-loan payments ko pehle prioritize karein, aur payment gap dikhne par jaldi refinance karein.';

  @override
  String get dbRiskChronic => 'Chronic Re-Debt Risk';

  @override
  String get dbRiskChronicExp =>
      'Current load clear karne ke baad bhi dobara debt mein fasne ki tendency.';

  @override
  String get dbRiskChronicFix =>
      'Clearance ke baad lifestyle spending badhane se pehle ek dedicated emergency fund banayein.';

  @override
  String get dbReindebtTrigger => 'Re-Debt Trigger';

  @override
  String get dbCycleBreakFeasibility => 'Cycle-Break Feasibility';

  @override
  String get dbMajorRisks => 'Major Risks';

  @override
  String get dbHiddenSignals => 'Hidden Debt Signals';

  @override
  String get dbCrisisTitle => 'Crisis Preparedness';

  @override
  String get dbCrisisSubtitle =>
      'Trouble ko jaldi kaise pehchanein aur shaant reh kar respond karein';

  @override
  String get dbWarningSigns => 'Early Warning Signs';

  @override
  String get dbMitigationActions => 'Iske baare mein kya karein';

  @override
  String get dbFamilyTitle => 'Family & Ancestral Debt';

  @override
  String get dbInheritedDebtProb => 'Inherited-Debt Chance';

  @override
  String get dbFamilyDrag => 'Family Debt Drag';

  @override
  String get dbInheritedSource => 'Likely source';

  @override
  String get dbCoreBlockerLabel => 'CORE BLOCKER';

  @override
  String get dbPsychologyTitle => 'Aapki Money Psychology';

  @override
  String get dbResilience => 'Resilience';

  @override
  String get dbDiscipline => 'Pressure Mein Discipline';

  @override
  String get dbSocialSupport => 'Social Support';

  @override
  String get dbDepressionRisk => 'Financial-Stress Vulnerability';

  @override
  String get dbStressTolerance => 'Stress tolerance';

  @override
  String get dbRootCause => 'Behavioral Root Cause';

  @override
  String get dbImprovementTitle => 'Improvement Plan';

  @override
  String get dbRoadmapTitle => 'Aapka Debt-Free Roadmap';

  @override
  String get dbRecoveryProbability => 'Recovery Probability';

  @override
  String get dbClearanceTimeline => 'Clearance Timeline';

  @override
  String get dbYears => 'saal';

  @override
  String get dbDtiHealth => 'Debt-to-Income Health';

  @override
  String get dbDtiCategory => 'DTI Category';

  @override
  String get dbBreakEvenMonths => 'Break-even tak months';

  @override
  String get dbIncomeAcceleration => 'Zaroori income growth';

  @override
  String get dbLayerD1 => 'Birth Chart (D1)';

  @override
  String get dbLayerD6 => 'Debt & Enemies (D6)';

  @override
  String get dbLayerD9 => 'Navamsa (D9)';

  @override
  String get dbLayerDasha => 'Dasha Timing';

  @override
  String get dbLayerTransit => 'Current Transits';

  @override
  String get dbTopicRecovery => 'Meri recovery timeline';

  @override
  String get dbTopicNegotiate => 'Creditors ke saath negotiation';

  @override
  String get dbTopicBorrowing => 'Kya abhi borrow karna safe hai';

  @override
  String get dbTopicCrisis => 'Crisis ke liye taiyari';

  @override
  String get dbTopicAncestral => 'Ancestral debt karma';

  @override
  String get dbTopicTimeline => 'Debt clear karne ke best years';

  @override
  String get dbTopicPsychology => 'Meri money psychology';

  @override
  String get dbTopicCategories => 'Kaunse debts ko prioritize karein';

  @override
  String get mnSubtitle => 'AI-powered Vedic Wellness Report';

  @override
  String get mnTitle => 'Mental Health aur Stress';

  @override
  String get mnSnapshotHeader => 'Wellness Snapshot';

  @override
  String get mnResilience => 'Resilience';

  @override
  String get mnStability => 'Stability';

  @override
  String get mnEmotionalBalance => 'Emotional Balance';

  @override
  String get mnInnerCalm => 'Andar ki Shanti';

  @override
  String get mnSelfAwareness => 'Self-Awareness';

  @override
  String get mnStatusThriving => 'Bahut Achha Chal Raha Hai';

  @override
  String get mnStatusSteady => 'Stable aur Balanced';

  @override
  String get mnStatusBuildingStrength => 'Strength Build Ho Rahi Hai';

  @override
  String get mnStatusNeedsGentleCare => 'Thodi Gentle Care Chahiye';

  @override
  String get mnStatusReachOut => 'Support Lene Ka Time Hai';

  @override
  String get mnChipStable => 'Emotionally Stable';

  @override
  String get mnChipSupported => 'Achha Support Mil Raha Hai';

  @override
  String get mnChipSelfAware => 'Highly Self-Aware';

  @override
  String get mnChipResilient => 'Jaldi Sambhal Jaate Hain';

  @override
  String get mnChipSecureAttachment => 'Secure Attachment';

  @override
  String get mnChipHealingReady => 'Healing Ke Liye Ready';

  @override
  String get mnChipMindBodyBalance => 'Mind-Body Balance';

  @override
  String get mnSupportBannerTitle => 'Ek Gentle Note';

  @override
  String get mnSupportBannerBody =>
      'Aapki kundli batati hai ki abhi thoda extra support lena achha rahega — koi trusted friend, family member, ya professional. Help maangna weakness nahi, balki strength ki nishaani hai.';

  @override
  String get mnProfileTitle => 'Aapka Emotional Blueprint';

  @override
  String get mnStressDriver => 'Stress Ka Karan';

  @override
  String get mnStabilityAnchor => 'Stability Ka Anchor';

  @override
  String get mnSoulLevelKarma => 'Soul-Level Pattern';

  @override
  String get mnSubtleSignature => 'Subtle Emotional Signature';

  @override
  String get mnKarakaTitle => 'Aapka Mann aur Grah';

  @override
  String get mnKarakaSubtitle =>
      'Kaunse grah aapki inner world ko shape karte hain';

  @override
  String get mnYogasTitle => 'Strengths aur Growth Areas';

  @override
  String get mnCurrentPhase => 'Current Phase';

  @override
  String get mnCurrentStressLevel => 'Current Stress Level';

  @override
  String get mnRecentStrain => 'Recent Emotional Strain';

  @override
  String get mnStrengths => 'Strengths';

  @override
  String get mnGrowthAreas => 'Growth Areas';

  @override
  String get mnSadeSatiStatus => 'Sade Sati Status';

  @override
  String get mnVerificationTitle => 'Sabhi Charts Mein Confirm';

  @override
  String get mnD9Confirmation => 'D9 Confirmation';

  @override
  String get mnD30Confirmation => 'D30 Confirmation';

  @override
  String get mnMoodPatternsTitle => 'Mood aur Anxiety Patterns';

  @override
  String get mnMoodPatternsSubtitle => 'Gentle awareness, koi diagnosis nahi';

  @override
  String get mnAnxietyPatterns => 'Anxiety Patterns';

  @override
  String get mnMoodPatterns => 'Low-Mood Patterns';

  @override
  String get mnPrimaryPattern => 'Primary Pattern';

  @override
  String get mnRumination => 'Overthinking Ki Tendency';

  @override
  String get mnHypervigilance => 'Hyper-Alertness';

  @override
  String get mnHopelessnessVuln => 'Low-Mood Sensitivity';

  @override
  String get mnEnergyDepletion => 'Energy Kam Hone Ki Tendency';

  @override
  String get mnMotivationBaseline => 'Motivation Ka Baseline';

  @override
  String get mnRegulationTitle => 'Emotional Regulation aur Coping';

  @override
  String get mnEmotionalRegulation => 'Emotional Regulation';

  @override
  String get mnSelfSoothing => 'Khud Ko Shant Karne Ki Ability';

  @override
  String get mnExpressionStyle => 'Expression Style';

  @override
  String get mnRecoveryTime => 'Recovery Time';

  @override
  String get mnTriggerIntensity => 'Trigger Intensity';

  @override
  String get mnHealthyCoping => 'Healthy Coping Habits';

  @override
  String get mnWatchFor => 'Gently Dhyan Rakhein';

  @override
  String get mnSleepTitle => 'Sleep aur Rest';

  @override
  String get mnSleepQuality => 'Sleep Quality';

  @override
  String get mnSleepAsRegulator => 'Emotional Regulator Ke Roop Mein Sleep';

  @override
  String get mnInsomniaTendency => 'Restless-Night Tendency';

  @override
  String get mnNightmareTendency => 'Vivid-Dream Tendency';

  @override
  String get mnSleepHygienePriority => 'Sleep Hygiene Priority';

  @override
  String get mnBurnoutTitle => 'Burnout aur Energy';

  @override
  String get mnBurnoutVulnerability => 'Burnout Sensitivity';

  @override
  String get mnBurnoutRecovery => 'Burnout Se Recover Karne Ki Capacity';

  @override
  String get mnBurnoutStage => 'Current Burnout Stage';

  @override
  String get mnSelfDrivingTendency => 'Khud Ko Push Karne Ki Tendency';

  @override
  String get mnBurnoutTriggers => 'Burnout Ke Triggers';

  @override
  String get mnConnectionTitle => 'Connection aur Support';

  @override
  String get mnSocialSupport => 'Social Support Ki Quality';

  @override
  String get mnLonelinessVuln => 'Loneliness Sensitivity';

  @override
  String get mnSolitudeNeed => 'Akele Rehne Ki Need';

  @override
  String get mnSocialComfort => 'Social Comfort';

  @override
  String get mnTraumaSensitivity => 'Trauma Sensitivity';

  @override
  String get mnHealingReadiness => 'Healing Ke Liye Readiness';

  @override
  String get mnProcessingStyle => 'Processing Style';

  @override
  String get mnMindBodyIntegration => 'Mind-Body Integration';

  @override
  String get mnPtsdVuln => 'Trauma-Response Sensitivity';

  @override
  String get mnSelfAwarenessTitle => 'Self-Awareness aur Growth';

  @override
  String get mnSelfAwarenessScore => 'Self-Awareness';

  @override
  String get mnEmotionalVocabulary => 'Emotional Vocabulary';

  @override
  String get mnTherapyReadiness => 'Therapy Ke Liye Readiness';

  @override
  String get mnJournalingBenefit => 'Journaling Se Benefit';

  @override
  String get mnInnerDialogue => 'Inner Dialogue Ki Quality';

  @override
  String get mnAwarenessOfPatterns => 'Patterns Ki Awareness';

  @override
  String get mnEscapePatternVuln => 'Escape-Pattern Sensitivity';

  @override
  String get mnEscapeChannels => 'Gently Dhyan Rakhein';

  @override
  String get mnHealthyAlternatives => 'Healthy Alternatives';

  @override
  String get mnTherapyFitTitle => 'Therapy aur Support Fit';

  @override
  String get mnCrisisSupportRec => 'Support Recommendation';

  @override
  String get mnSupportNetwork => 'Apna Support Network Activate Karein';

  @override
  String get mnSelfAdvocacy => 'Khud Ke Liye Awaaz Uthane Ki Readiness';

  @override
  String get mnMedicationReceptivity => 'Medication Ke Prati Openness';

  @override
  String get mnTimelineTitle => 'Wellness Timeline';

  @override
  String get mnPeakWellnessYears => 'Best Wellness Years';

  @override
  String get mnExtraCareYears => 'Extra Self-Care Ke Saal';

  @override
  String get mnTransformationWindows => 'Positive Transformation Ke Windows';

  @override
  String get mnTherapyWindow => 'Recommended Therapy Window';

  @override
  String get mnPracticesTitle => 'Daily Wellness Practices';

  @override
  String get mnMorningPractices => 'Morning Practices';

  @override
  String get mnEveningPractices => 'Evening Practices';

  @override
  String get mnBreathwork => 'Breathwork';

  @override
  String get mnMovement => 'Movement';

  @override
  String get mnNutrition => 'Nutrition';

  @override
  String get mnNatureExposure => 'Nature Exposure Ki Need';

  @override
  String get mnDigitalDetox => 'Digital Detox Ki Need';

  @override
  String get mnImprovementTitle => 'Improvement Plan';

  @override
  String get mnReliabilityTitle => 'Reliability';

  @override
  String get mnLayerD1 => 'Birth Chart (D1)';

  @override
  String get mnLayerD9 => 'Soul Chart (D9)';

  @override
  String get mnLayerD30 => 'D30 Chart';

  @override
  String get mnLayerDasha => 'Dasha Timing';

  @override
  String get mnLayerTransit => 'Transits';

  @override
  String get mnTopicResilience => 'Main emotionally kitna resilient hoon?';

  @override
  String get mnTopicCoping => 'Mere liye best coping strategies kya hain?';

  @override
  String get mnTopicSleep =>
      'Main apni sleep kaise improve kar sakta/sakti hoon?';

  @override
  String get mnTopicBurnout => 'Kya mujhe burnout ka risk hai?';

  @override
  String get mnTopicTherapy => 'Mere liye kaunsi therapy style suit karti hai?';

  @override
  String get mnTopicPractices =>
      'Kaunsi daily practices mujhe sabse zyada help karengi?';

  @override
  String get mnTopicTiming => 'Mere best wellness years kab hain?';

  @override
  String get mnTopicSupport => 'Main ek strong support network kaise banaoon?';

  @override
  String get lgSubtitle => 'AI-powered Vedic Legal Report';

  @override
  String get lgTitle => 'Legal & Disputes';

  @override
  String get lgSnapshotHeader => 'Legal Snapshot';

  @override
  String get lgResilience => 'Legal Resilience';

  @override
  String get lgResolutionCapacity => 'Resolution Capacity';

  @override
  String get lgVictoryPotential => 'Victory Potential';

  @override
  String get lgLegalSafety => 'Legal Safety';

  @override
  String get lgNegotiationSkill => 'Negotiation Skill';

  @override
  String get lgStatusExcellent => 'Excellent';

  @override
  String get lgStatusStrong => 'Strong';

  @override
  String get lgStatusModerate => 'Moderate';

  @override
  String get lgStatusDeveloping => 'Develop ho raha hai';

  @override
  String get lgStatusChallenging => 'Challenging';

  @override
  String get lgChipResolver => 'Skilled Resolver';

  @override
  String get lgChipWinner => 'Strong Case Winner';

  @override
  String get lgChipNegotiator => 'Natural Negotiator';

  @override
  String get lgChipDocumented => 'Well Documented';

  @override
  String get lgChipLowRisk => 'Kam Legal Risk';

  @override
  String get lgChipMoralAuthority => 'Moral Authority';

  @override
  String get lgChipLegalAptitude => 'Legal Aptitude';

  @override
  String get lgProfileTitle => 'Aapki Legal Profile & Karma';

  @override
  String get lgPrimaryDriver => 'Primary Driver';

  @override
  String get lgDharmaAnchor => 'Dharma Anchor';

  @override
  String get lgAggressionMarker => 'Aggression Marker';

  @override
  String get lgDocumentationKaraka => 'Documentation Quality';

  @override
  String get lgKarakaTitle => 'Aapke Legal Planets';

  @override
  String get lgKarakaSubtitle =>
      'Kaunse planets aapki legal fortune ko shape karte hain';

  @override
  String get lgYogasTitle => 'Legal Yogas & Protections';

  @override
  String get lgCurrentPhase => 'Current Phase';

  @override
  String get lgProtections => 'Protections';

  @override
  String get lgDisputePressures => 'Dispute Pressures';

  @override
  String get lgVerificationTitle => 'Sabhi Charts Mein Verify Kiya Gaya';

  @override
  String get lgD6Litigation => 'D6 Litigation Chart';

  @override
  String get lgD9Dharma => 'D9 Dharma Chart';

  @override
  String get lgMoralAuthority => 'Moral Authority';

  @override
  String get lgVictoryTitle => 'Victory Analysis';

  @override
  String get lgAsPlaintiff => 'Vadi (Plaintiff) Ke Roop Mein';

  @override
  String get lgAsDefendant => 'Pratiwadi (Defendant) Ke Roop Mein';

  @override
  String get lgSettlementPreference => 'Settlement Preference';

  @override
  String get lgDisputeCategoriesTitle => 'Dispute Categories Watch';

  @override
  String get lgLowRiskCategories => 'Low-Risk Categories';

  @override
  String get lgConflictStyleTitle => 'Conflict Style & Enemies';

  @override
  String get lgConfrontationComfort => 'Confrontation Mein Comfort';

  @override
  String get lgArgumentPersuasiveness => 'Argument Ki Persuasiveness';

  @override
  String get lgEmotionalRegulation => 'Emotional Control';

  @override
  String get lgGrudgeHolding => 'Grudge Rakhne Ki Tendency';

  @override
  String get lgEnemyAnalysisLabel => 'Enemy Analysis';

  @override
  String get lgVisibleEnemies => 'Visible Enemies';

  @override
  String get lgHiddenEnemies => 'Hidden Enemies';

  @override
  String get lgWorkplaceEnemies => 'Workplace Ke Enemies';

  @override
  String get lgFamilyEnemies => 'Family Ke Enemies';

  @override
  String get lgLegalEnemies => 'Legal Enemies';

  @override
  String get lgEnemyDefeatCapacity => 'Enemy Ko Defeat Karne Ki Capacity';

  @override
  String get lgCriminalFinancialTitle => 'Criminal & Financial Risk Watch';

  @override
  String get lgCriminalRisk => 'Criminal Involvement Risk';

  @override
  String get lgVictimOfCrime => 'Crime Ka Victim Banne Ka Chance';

  @override
  String get lgFalseAccusation => 'False Accusation Ka Risk';

  @override
  String get lgImprisonmentRisk => 'Imprisonment Risk';

  @override
  String get lgTaxDisputeRisk => 'Tax Dispute Risk';

  @override
  String get lgFinancialFraudRisk => 'Financial Fraud Risk';

  @override
  String get lgBusinessLitigationRisk => 'Business Litigation Risk';

  @override
  String get lgBankruptcyRisk => 'Bankruptcy Risk';

  @override
  String get lgAuditVulnerability => 'Audit Vulnerability';

  @override
  String get lgProtectionPriority => 'Protection Priority';

  @override
  String get lgContractsTitle => 'Contracts & Negotiation';

  @override
  String get lgContractClarity => 'Contract Clarity';

  @override
  String get lgDocumentationDiscipline => 'Documentation Discipline';

  @override
  String get lgFinePrintAwareness => 'Fine-Print Ki Awareness';

  @override
  String get lgSignatureCaution => 'Signature Karte Waqt Caution';

  @override
  String get lgMediationReceptivity => 'Mediation Ke Liye Openness';

  @override
  String get lgNegotiationSkillFull => 'Negotiation Skill';

  @override
  String get lgCompromiseWillingness => 'Compromise Karne Ki Willingness';

  @override
  String get lgFaceSavingNeeds => 'Face-Saving Ki Zaroorat';

  @override
  String get lgMediatorHireRecommendation =>
      'Mediator Hire Karne Ki Recommendation';

  @override
  String get lgTypicalContractIssues => 'Typical Contract Issues';

  @override
  String get lgCareerFitTitle => 'Legal Career Fit';

  @override
  String get lgProfessionAffinity => 'Profession Ke Prati Affinity';

  @override
  String get lgRoleFit => 'Best Role Fit';

  @override
  String get lgLawStudentSuccess => 'Law Student Ke Roop Mein Success';

  @override
  String get lgBarExamSuccess => 'Bar Exam Mein Success';

  @override
  String get lgTimelineTitle => 'Legal Timeline';

  @override
  String get lgNewMatterChance => 'Naye Matter Ka Chance (Agle 12 Mahine)';

  @override
  String get lgOngoingCaseOutcome => 'Chal Rahe Case Ka Outcome';

  @override
  String get lgRecommendedAction => 'Recommended Action';

  @override
  String get lgPeakDisputeYears => 'Peak Dispute Years';

  @override
  String get lgClarityYears => 'Legal Clarity Ke Years';

  @override
  String get lgAvoidancePeriods => 'Critical Avoidance Periods';

  @override
  String get lgFavorableWindows => 'Favorable Resolution Windows';

  @override
  String get lgRisksTitle => 'Risks & Vulnerabilities';

  @override
  String get lgChronicVulnerabilities => 'Chronic Vulnerabilities';

  @override
  String get lgAvoidDashaPeriods => 'Dhyan Rakhne Wali Dasha Periods';

  @override
  String get lgPreventivePriorities => 'Preventive Priorities';

  @override
  String get lgRedFlags => 'Red-Flag Situations';

  @override
  String get lgImprovementTitle => 'Improvement Plan';

  @override
  String get lgReliabilityTitle => 'Reliability';

  @override
  String get lgLayerD1 => 'Birth Chart (D1)';

  @override
  String get lgLayerD6 => 'Litigation Chart (D6)';

  @override
  String get lgLayerD9 => 'Dharma Chart (D9)';

  @override
  String get lgLayerDasha => 'Dasha Timing';

  @override
  String get lgLayerTransit => 'Transits';

  @override
  String get lgTopicWinChance => 'Mere jeetne ke chances kya hain?';

  @override
  String get lgTopicStrategy => 'Mere liye best legal strategy kya hai?';

  @override
  String get lgTopicContract => 'Kaunse contract risks pe dhyan doon?';

  @override
  String get lgTopicTiming => 'Disputes solve karne ka best time kab hai?';

  @override
  String get lgTopicSettlement =>
      'Mujhe settle karna chahiye ya fight karna chahiye?';

  @override
  String get lgTopicEnemies => 'Mere hidden enemies kaun hain?';

  @override
  String get lgTopicProtection => 'Main khud ko legally kaise protect karoon?';

  @override
  String get lgTopicCareer => 'Kya main legal career ke liye suited hoon?';

  @override
  String get prSubtitle => 'AI-powered Vedic Property Report';

  @override
  String get prTitle => 'Property aur Assets';

  @override
  String get prSnapshotHeader => 'Property Snapshot';

  @override
  String get prAcquisitionCapacity => 'Acquisition Capacity';

  @override
  String get prHomeOwnership => 'Home Ownership';

  @override
  String get prWealthPotential => 'Wealth Potential';

  @override
  String get prRentalIncome => 'Rental Income';

  @override
  String get prLandOwnership => 'Land Ownership';

  @override
  String get prStatusExcellent => 'Excellent';

  @override
  String get prStatusStrong => 'Strong';

  @override
  String get prStatusModerate => 'Moderate';

  @override
  String get prStatusDeveloping => 'Develop ho raha hai';

  @override
  String get prStatusChallenging => 'Challenging';

  @override
  String get prChipHomeOwner => 'Home Owner';

  @override
  String get prChipWealthBuilder => 'Wealth Builder';

  @override
  String get prChipLandOwner => 'Land Owner';

  @override
  String get prChipInvestor => 'Property Investor';

  @override
  String get prChipInheritance => 'Inheritance ke chances';

  @override
  String get prChipVehicle => 'Vehicle Owner';

  @override
  String get prChipGlobalAsset => 'Global Asset ka jhukav';

  @override
  String get prProfileTitle => 'Aapki Property Style';

  @override
  String get prHomeAesthetics => 'Ghar ki Khoobsurati';

  @override
  String get prHomeSanctuary => 'Ghar ek Sanctuary ki tarah';

  @override
  String get prComfortInvestment => 'Comfort mein Investment';

  @override
  String get prVastuPriority => 'Vastu Priority';

  @override
  String get prNaturalElements => 'Natural Elements';

  @override
  String get prNextActionLabel => 'Agla Kadam';

  @override
  String get prKarakaTitle => 'Aapke Property Grah';

  @override
  String get prKarakaSubtitle =>
      'Kaunse grah aapki property luck ko shape karte hain';

  @override
  String get prPrimaryKaraka => 'Primary Karaka';

  @override
  String get prDurableAsset => 'Durable Asset Karaka';

  @override
  String get prYogasTitle => 'Property Yogas aur Doshas';

  @override
  String get prCurrentPhase => 'Current Phase';

  @override
  String get prBoosters => 'Boosters';

  @override
  String get prDrains => 'Drains';

  @override
  String get prVerificationTitle => 'Charts mein Verified';

  @override
  String get prD4Property => 'D4 Property Chart';

  @override
  String get prD16Vehicle => 'D16 Vehicle Chart';

  @override
  String get prVehicleFit => 'Vehicle Fit';

  @override
  String get prJourneyTitle => 'Ownership Journey aur Timeline';

  @override
  String get prFirstHomeAge => 'Pehle Ghar ki Age';

  @override
  String get prFirstHomeType => 'Pehle Ghar ka Type';

  @override
  String get prMultipleHomes => 'Multiple Homes';

  @override
  String get prNewPropertySoon => 'Jaldi Nayi Property';

  @override
  String get prFirstMajorWindow => 'Pehli Badi Window';

  @override
  String get prBuyingWindow => 'Buying Window';

  @override
  String get prConstructionWindow => 'Construction Window';

  @override
  String get prNextOpportunity => 'Next Opportunity';

  @override
  String get prLifetimePropertyCount => 'Lifetime Property Count';

  @override
  String get prInheritanceTitle => 'Inheritance aur Family Property';

  @override
  String get prMaternalInheritance => 'Maternal Inheritance';

  @override
  String get prPaternalInheritance => 'Paternal Inheritance';

  @override
  String get prAncestralProperty => 'Ancestral Property';

  @override
  String get prFamilyDisputeRisk => 'Family Dispute Risk';

  @override
  String get prInheritanceTiming => 'Inheritance ka Timing';

  @override
  String get prInheritanceType => 'Inheritance ka Type';

  @override
  String get prLandInvestTitle => 'Land, Investment aur Global Property';

  @override
  String get prPropertyInvestor => 'Property Investor Score';

  @override
  String get prAppreciationLuck => 'Appreciation Luck';

  @override
  String get prInvestorMindset => 'Investor Mindset';

  @override
  String get prLandType => 'Land Type';

  @override
  String get prRentalCount => 'Rental Property Count';

  @override
  String get prMultipleLand => 'Multiple Land Parcels';

  @override
  String get prFarmEstate => 'Farm / Estate ke Chances';

  @override
  String get prGlobalPropertyLabel => 'Global Property';

  @override
  String get prForeignProperty => 'Foreign Property';

  @override
  String get prNriAffinity => 'NRI Asset ka Jhukav';

  @override
  String get prVehiclesTitle => 'Vehicles';

  @override
  String get prVehicleCount => 'Vehicle Count';

  @override
  String get prVehicleFirstAge => 'Pehle Vehicle ki Age';

  @override
  String get prVehicleCategory => 'Vehicle Category';

  @override
  String get prVehicleQuality => 'Vehicle Quality';

  @override
  String get prLuxuryAffinity => 'Luxury ka Jhukav';

  @override
  String get prVehicleLossRisk => 'Vehicle Loss / Damage Risk';

  @override
  String get prLegalRiskTitle => 'Legal aur Risk Watch';

  @override
  String get prBoundaryDisputes => 'Boundary Disputes';

  @override
  String get prPartitionDisputes => 'Partition Disputes';

  @override
  String get prTitleIssues => 'Title / Documentation Issues';

  @override
  String get prTenantConflict => 'Tenant-Landlord Conflict';

  @override
  String get prForcedSale => 'Forced Sale Risk';

  @override
  String get prPropertyDamage => 'Property Damage Risk';

  @override
  String get prInsurancePriority => 'Insurance Priority';

  @override
  String get prProtectionUrgency => 'Protection ki Urgency';

  @override
  String get prProtectiveFactors => 'Protective Factors';

  @override
  String get prChronicVulnerabilities => 'Chronic Vulnerabilities';

  @override
  String get prDueDiligenceTitle => 'Due Diligence Checklist';

  @override
  String get prPreventiveMeasures => 'Preventive Measures';

  @override
  String get prImprovementTitle => 'Improvement Plan';

  @override
  String get prReliabilityTitle => 'Reliability';

  @override
  String get prLayerD1 => 'Birth Chart (D1)';

  @override
  String get prLayerD4 => 'Property Chart (D4)';

  @override
  String get prLayerD16 => 'Vehicle Chart (D16)';

  @override
  String get prLayerDasha => 'Dasha Timing';

  @override
  String get prLayerTransit => 'Transits';

  @override
  String get prTopicBuying => 'Kharidne ka best time?';

  @override
  String get prTopicInherit => 'Kya mujhe property inherit hogi?';

  @override
  String get prTopicVehicle => 'Mujhe vehicle kab milega?';

  @override
  String get prTopicRental => 'Rental income ki potential?';

  @override
  String get prTopicLand => 'Land ownership ke chances?';

  @override
  String get prTopicLegal => 'Kaunse legal risks dhyan rakhein?';

  @override
  String get prTopicForeign => 'Foreign property ke chances?';

  @override
  String get prTopicTiming => 'Property ke liye best timing windows?';

  @override
  String get edTitle => 'Education aur Learning Analysis';

  @override
  String get edSubtitle => 'AI-powered Vedic Education Report';

  @override
  String get edSnapshotHeader => 'Aapki Education Snapshot';

  @override
  String get edOverallStrength => 'Overall Strength';

  @override
  String get edAcademicSuccess => 'Academic Success';

  @override
  String get edLearningCapacity => 'Seekhne ki Kshamata';

  @override
  String get edIntellect => 'Intellect';

  @override
  String get edMemory => 'Memory';

  @override
  String get edStatusExcellent => 'Excellent Potential';

  @override
  String get edStatusStrong => 'Strong Potential';

  @override
  String get edStatusModerate => 'Moderate Potential';

  @override
  String get edStatusDeveloping => 'Developing Potential';

  @override
  String get edStatusChallenging => 'Challenging Phase';

  @override
  String get edChipSaraswati => 'Saraswati Yoga';

  @override
  String get edChipGajaKesari => 'Gaja Kesari Yoga';

  @override
  String get edChipBudhaAditya => 'Budha Aditya Yoga';

  @override
  String get edChipResearch => 'Strong Research Ability';

  @override
  String get edChipScholarship => 'Scholarship Potential';

  @override
  String get edChipDoctorate => 'Doctorate Potential';

  @override
  String get edChipForeign => 'Foreign Education Support';

  @override
  String get edChipLifelong => 'Lifelong Learner';

  @override
  String get edLearningStyleTitle => 'Aapki Learning Style';

  @override
  String get edSoulPlanet => 'Soul Planet';

  @override
  String get edSoulHint => 'Aapki sabse gehri inner drive aur life purpose';

  @override
  String get edSubjectPlanet => 'Subject Planet';

  @override
  String get edTechAtmakaraka => 'Atmakaraka (technical)';

  @override
  String get edTechAmatyakaraka => 'Amatyakaraka (technical)';

  @override
  String get edSubjectKarakaStrength => 'Subject Karaka Strength';

  @override
  String get edFoundationTitle => 'Education Foundation';

  @override
  String get edHouse4 => 'Shuruati Schooling';

  @override
  String get edHouse5 => 'Intelligence';

  @override
  String get edHouse9 => 'Higher Learning';

  @override
  String get edPurvaPunya => 'Purv-Janam Punya';

  @override
  String get edStudyPlanetsTitle => 'Aapke Study Planets';

  @override
  String get edYogasTitle => 'Aapki Kundli mein Education Yogas';

  @override
  String get edYogaBudhaAditya => 'Budha Aditya';

  @override
  String get edYogaGajaKesari => 'Gaja Kesari';

  @override
  String get edYogaSaraswati => 'Saraswati';

  @override
  String get edYogaPresent => 'Present';

  @override
  String get edYogaAbsent => 'Absent';

  @override
  String get edYogaNoneNote =>
      'Koi classical education yoga nahi — success consistent effort aur discipline se aati hai.';

  @override
  String get edVerificationTitle => 'Alag-Alag Charts mein Verification';

  @override
  String get edD24Learning => 'D24 — Deep Learning Chart';

  @override
  String get edD4Formal => 'D4 — Formal Education Chart';

  @override
  String get edD9Dharma => 'D9 — Learning Dharma Chart';

  @override
  String get edD60Karma => 'D60 — Purv-Janam Learning Karma';

  @override
  String get edSubjectsTitle => 'Aapke Liye Best Subjects';

  @override
  String get edSubjectsSubtitle => 'Chart affinity ke hisaab se ranked';

  @override
  String get edLowAffinity => 'Kam Affinity Wale Subjects';

  @override
  String get edDegreesTitle => 'Degree aur Level Likelihood';

  @override
  String get edExpectedLevel => 'Expected Level';

  @override
  String get edDegreeFormal => 'Formal Degree';

  @override
  String get edDegreePostgrad => 'Postgraduate';

  @override
  String get edDegreeDoctorate => 'Doctorate';

  @override
  String get edDegreeForeign => 'Foreign Education';

  @override
  String get edTimelineTitle => 'Study Timeline';

  @override
  String get edEarlySchooling => 'Early Schooling Window';

  @override
  String get edHigherEducation => 'Higher Education Window';

  @override
  String get edPostgradResearch => 'Postgrad / Research Window';

  @override
  String get edPeakLearningAge => 'Peak Learning Age';

  @override
  String get edPreferencesTitle => 'Learning Preferences aur Support';

  @override
  String get edPrefStudyMode => 'Study Mode';

  @override
  String get edPrefTiming => 'Best Time';

  @override
  String get edPrefEnvironment => 'Environment';

  @override
  String get edPrefLocation => 'Location';

  @override
  String get edPrefForeign => 'Foreign Study';

  @override
  String get edGuruRelationship => 'Teacher/Guru Bond';

  @override
  String get edMentorAvailability => 'Mentor Availability';

  @override
  String get edPeerLearning => 'Peer Learning';

  @override
  String get edAuthorityDeference => 'Authority ke liye Respect';

  @override
  String get edStrengthsTitle => 'Strengths aur Challenges';

  @override
  String get edCognitiveGifts => 'Cognitive Gifts';

  @override
  String get edNaturalAbilities => 'Natural Learning Abilities';

  @override
  String get edHiddenCapacities => 'Hidden Capacities';

  @override
  String get edConcentration => 'Concentration Difficulty';

  @override
  String get edBreakRisk => 'Education Break Risk';

  @override
  String get edDisciplineConsistency => 'Discipline Consistency';

  @override
  String get edScholarshipLikelihood => 'Scholarship Likelihood';

  @override
  String get edCareerLinkTitle => 'Education → Career Path';

  @override
  String get edDirectionRec => 'Recommended Direction';

  @override
  String get edIntegrationStrategy => 'Integration Strategy';

  @override
  String get edCareerLinkage => 'Career Linkage';

  @override
  String get edAlignedSubjects => 'Career-Aligned Subjects';

  @override
  String get edDegreeUtility => 'Career ke liye Degree Utility';

  @override
  String get edImprovementTitle => 'Aapka Improvement Plan';

  @override
  String get edReliabilityTitle => 'Prediction Reliability';

  @override
  String get edLayerD1 => 'Birth Chart (D1)';

  @override
  String get edLayerD4 => 'Formal Education (D4)';

  @override
  String get edLayerD9 => 'Navamsa (D9)';

  @override
  String get edLayerD24 => 'Deep Learning (D24)';

  @override
  String get edLayerD60 => 'Purv-Janam Learning (D60)';

  @override
  String get edLayerAmk => 'Subject Karaka';

  @override
  String get edLayerMj => 'Mercury-Jupiter';

  @override
  String get edLayerDasha => 'Planetary Timing';

  @override
  String get edTopicSubjects => 'Mere Liye Best Subjects';

  @override
  String get edTopicDegree => 'Degree Chances';

  @override
  String get edTopicAbroad => 'Videsh mein Padhai';

  @override
  String get edTopicExam => 'Exam Performance';

  @override
  String get edTopicHabits => 'Study Habits';

  @override
  String get edTopicCareerLink => 'Education-se-Career Link';

  @override
  String get edTopicTiming => 'Education Timing Windows';

  @override
  String get edTopicScholarship => 'Scholarship Chances';

  @override
  String get hwTitle => 'Health & Wellness Analysis';

  @override
  String get hwSubtitle => 'AI se bana Vedic Health & Wellness Report';

  @override
  String get hwSnapshotHeader => 'Aapki Health Snapshot';

  @override
  String get hwOverallVitality => 'Vitality';

  @override
  String get hwImmunity => 'Immunity';

  @override
  String get hwRecovery => 'Recovery';

  @override
  String get hwMentalWellness => 'Mental Wellness';

  @override
  String get hwStressTolerance => 'Stress Sahan Shakti';

  @override
  String get hwStatusThriving => 'Bahut Achha';

  @override
  String get hwStatusGood => 'Achhi Vitality';

  @override
  String get hwStatusBalanced => 'Santulit';

  @override
  String get hwStatusNeedsCare => 'Dhyaan Chahiye';

  @override
  String get hwStatusNeedsAttention => 'Attention Chahiye';

  @override
  String get hwChipImmunity => 'Strong Immunity';

  @override
  String get hwChipRecovery => 'Fast Recovery';

  @override
  String get hwChipMentalBalance => 'Balanced Mind';

  @override
  String get hwChipStressResilience => 'Stress Resilient';

  @override
  String get hwChipFertility => 'Fertility Support';

  @override
  String get hwChipWorkLife => 'Achha Work-Life Balance';

  @override
  String get hwChipLowAddiction => 'Kam Addiction Risk';

  @override
  String get hwConstitutionTitle => 'Aapka Body Type';

  @override
  String get hwConstitutionSubtitle => 'Aapki kundli se Ayurvedic constitution';

  @override
  String get hwDominantDosha => 'Dominant';

  @override
  String get hwSecondaryDosha => 'Secondary';

  @override
  String get hwPrimaryKaraka => 'Main Health Indicator';

  @override
  String get hwStrongestSystem => 'Sabse Strong System';

  @override
  String get hwWeakestSystem => 'Support Karne Wala System';

  @override
  String get hwBodyMapTitle => 'Aapke Body ka Planetary Map';

  @override
  String get hwBodyMapSubtitle => '9 grah, 9 body systems';

  @override
  String get hwYogaTitle => 'Aapki Kundli mein Health Patterns';

  @override
  String get hwYogaSubtitle => 'Protective vs disease-pressure yogas';

  @override
  String get hwDiseasePressureLabel => 'DISEASE PRESSURE';

  @override
  String get hwAreasTitle => 'Dhyaan Dene Wale Body Areas';

  @override
  String get hwAreasSubtitle => 'Body zone ke hisaab se vulnerability';

  @override
  String get hwProtectedAreas => 'Well-Protected Areas';

  @override
  String get hwCategoriesTitle => 'Disease-Category Watch';

  @override
  String get hwCategoriesSubtitle =>
      'Major health categories mein susceptibility';

  @override
  String get hwLowRiskCategories => 'Low-Risk Categories';

  @override
  String get hwMentalTitle => 'Mental & Emotional Wellness';

  @override
  String get hwMentalSubtitle => 'Emotional resilience aur support ki zarurat';

  @override
  String get hwMentalVulnerability => 'Emotional Sensitivity';

  @override
  String get hwEmotionalRegulation => 'Emotional Regulation';

  @override
  String get hwSupportRec => 'Support Recommendation';

  @override
  String get hwTendencies => 'Mental Tendencies';

  @override
  String get hwTimelineTitle => 'Health Timeline';

  @override
  String get hwTimelineSubtitle =>
      'Peak years, caution years & recovery windows';

  @override
  String get hwPeakYears => 'Peak Wellness Years';

  @override
  String get hwCautionYears => 'Caution Years';

  @override
  String get hwRecoveryWindow => 'Recovery Window';

  @override
  String get hwCheckupYears => 'Recommended Check-up Years';

  @override
  String get hwCurrentPhase => 'Current Phase';

  @override
  String get hwLifestyleTitle => 'Aapki Lifestyle Guide';

  @override
  String get hwLifestyleSubtitle =>
      'Aapki kundli daily habits ke baare mein kya kehti hai';

  @override
  String get hwSleepDiscipline => 'Sleep Discipline ka Impact';

  @override
  String get hwDietDiscipline => 'Diet Discipline ka Impact';

  @override
  String get hwExerciseNeed => 'Exercise ki Zarurat';

  @override
  String get hwSunlightNeed => 'Dhoop ki Zarurat';

  @override
  String get hwStressSusceptibility => 'Stress Susceptibility';

  @override
  String get hwHydrationSensitivity => 'Hydration Sensitivity';

  @override
  String get hwSocialType => 'Social Energy Type';

  @override
  String get hwHealingSpeed => 'Healing Speed';

  @override
  String get hwTreatmentResponse => 'Treatment Response';

  @override
  String get hwAltHealing => 'Alternative Healing ki Affinity';

  @override
  String get hwSpecialTitle => 'Life-Stage & Special Topics';

  @override
  String get hwSpecialSubtitle =>
      'Fertility, bachpan ki health, habits & burnout';

  @override
  String get hwFertility => 'Fertility Indicator';

  @override
  String get hwHormonalBalance => 'Hormonal Balance';

  @override
  String get hwReproductiveStrength => 'Reproductive System ki Strength';

  @override
  String get hwChildhoodVuln => 'Bachpan Health Vulnerability';

  @override
  String get hwChildhoodStatus => 'Bachpan ki Health';

  @override
  String get hwAddictionVuln => 'Addiction Vulnerability';

  @override
  String get hwAddictionRecovery => 'Recovery Capacity';

  @override
  String get hwBurnoutVuln => 'Burnout Vulnerability';

  @override
  String get hwWorkLifeBalance => 'Work-Life Balance';

  @override
  String get hwStressTriggers => 'Stress Triggers';

  @override
  String get hwProtectiveFactors => 'Protective Factors';

  @override
  String get hwChallengesTitle => 'Dhyaan Dene Wali Challenges';

  @override
  String get hwChallengesSubtitle => 'Preventive care kahan focus karein';

  @override
  String get hwMitigation => 'Kaise Manage Karein';

  @override
  String get hwChronicAreas => 'Chronic Vulnerability Areas';

  @override
  String get hwPreventivePriorities => 'Preventive Priorities';

  @override
  String get hwImprovementTitle => 'Aapka Wellness Plan';

  @override
  String get hwImprovementSubtitle => 'Practical steps + traditional remedies';

  @override
  String get hwReliabilityTitle => 'Reading Reliability';

  @override
  String get hwLayerD1 => 'Birth Chart (D1)';

  @override
  String get hwLayerD6 => 'Health Chart (D6)';

  @override
  String get hwLayerD30 => 'Micro-Health Chart (D30)';

  @override
  String get hwLayerDasha => 'Planetary Timing';

  @override
  String get hwLayerTransit => 'Current Transits';

  @override
  String get hwDisclaimerLabel => 'Medical Disclaimer';

  @override
  String get hwTopicImmunity => 'Immunity Boost Karein';

  @override
  String get hwTopicSleep => 'Sleep & Rest';

  @override
  String get hwTopicStress => 'Stress Manage Karein';

  @override
  String get hwTopicFertility => 'Fertility Timing';

  @override
  String get hwTopicDiet => 'Diet & Nutrition';

  @override
  String get hwTopicTiming => 'Health Timing Windows';

  @override
  String get hwTopicMental => 'Mental Wellbeing';

  @override
  String get hwTopicPrevention => 'Preventive Care Plan';

  @override
  String get lvSubtitle => 'AI se banayi gayi Vedic Love Report';

  @override
  String get lvTitle => 'Pyaar aur Rishtey';

  @override
  String get lvLovePotential => 'Pyaar ki Sambhavna';

  @override
  String get lvEmotionalAvail => 'Emotionally Open';

  @override
  String get lvAttraction => 'Aakarshan';

  @override
  String get lvCommitment => 'Commitment';

  @override
  String get lvCommunication => 'Baatcheet';

  @override
  String get lvFidelity => 'Wafadari';

  @override
  String get lvChipLoyal => 'Wafadar dil';

  @override
  String get lvChipOpenHeart => 'Khule dil wale';

  @override
  String get lvChipCommunicator => 'Behtareen communicator';

  @override
  String get lvChipMature => 'Takraav ko achhe se sambhalte hain';

  @override
  String get lvChipEmotionallyWise => 'Emotionally samajhdaar';

  @override
  String get lvLoveStyle => 'Aapki Love Style';

  @override
  String get lvAttractionStyle => 'Aakarshan ki style';

  @override
  String get lvLangGiven => 'Aap Pyaar Kaise Jatate Hain';

  @override
  String get lvLangReceived => 'Aapko Pyaar Kaise Mehsoos Hota Hai';

  @override
  String get lvLovePlanets => 'Aapke Love Planets';

  @override
  String get lvLoveKaraka => 'Pyaar';

  @override
  String get lvEmotionKaraka => 'Emotion';

  @override
  String get lvPassionKaraka => 'Junoon';

  @override
  String get lvPathToLove => 'Pyaar ki Taraf Aapka Raasta';

  @override
  String get lvPathSub => 'Love vs arranged marriage';

  @override
  String get lvLoveMarriage => 'Love Marriage';

  @override
  String get lvArrangedMarriage => 'Arranged Marriage';

  @override
  String get lvParentalAccept => 'Maa-Baap ki Manjoori';

  @override
  String get lvInterCaste => 'Inter-caste / Dharm';

  @override
  String get lvIdealPartner => 'Aapka Ideal Partner';

  @override
  String get lvPersonality => 'Personality';

  @override
  String get lvAppearance => 'Dikhawat';

  @override
  String get lvIdealTraits => 'Ideal Gun';

  @override
  String get lvWhatMatters => 'Sabse Zyada Kya Matter Karta Hai';

  @override
  String get lvDrawnTo => 'Aakarshit hote hain';

  @override
  String get lvDealbreakers => 'Rishta Todne Wali Baatein';

  @override
  String get lvYourAppeal => 'Aapka Appeal';

  @override
  String get lvLoveStory => 'Aapki Love Story';

  @override
  String get lvLoveStorySub => 'Rishton ke Patterns';

  @override
  String get lvFirstLove => 'Pehla Pyaar';

  @override
  String get lvRelationCount => 'Khaas Rishtey';

  @override
  String get lvDuration => 'Aam Duration';

  @override
  String get lvDepth => 'Emotional Gehrai';

  @override
  String get lvDatingPattern => 'Dating Pattern';

  @override
  String get lvCommitIntimacy => 'Commitment aur Intimacy';

  @override
  String get lvCommitReady => 'Commitment ke liye Taiyari';

  @override
  String get lvIntimacyDrive => 'Intimacy ki Chaahat';

  @override
  String get lvSensuality => 'Sensuality';

  @override
  String get lvEmpathy => 'Empathy';

  @override
  String get lvCommitStyle => 'Commitment Style';

  @override
  String get lvChemistry => 'Chemistry Style';

  @override
  String get lvMakesCommit => 'Aapko Commit Karne Wali Baat';

  @override
  String get lvMakesFlee => 'Aapko Door Karne Wali Baat';

  @override
  String get lvEmotional => 'Emotional Intelligence';

  @override
  String get lvEmotionalIQ => 'Emotional IQ';

  @override
  String get lvConflictStyle => 'Conflict Style';

  @override
  String get lvTiming => 'Pyaar ka Timing';

  @override
  String get lvNewLove12 => '12 Mahino mein Naya Pyaar';

  @override
  String get lvEnergyNow => 'Abhi ki Energy';

  @override
  String get lvPhaseNow => 'Abhi ka Phase';

  @override
  String get lvPeakRomance => 'Romance ke Best Saal';

  @override
  String get lvNewLoveWindow => 'Naye Pyaar ki Window';

  @override
  String get lvChallenges => 'Dhyan Dene Wali Challenges';

  @override
  String get lvRiskHeartbreak => 'Dil Tootne ka Khatra';

  @override
  String get lvRiskSabotage => 'Khud ko Nuksaan Pahunchana';

  @override
  String get lvRiskCommitFear => 'Commitment ka Dar';

  @override
  String get lvRiskRepeat => 'Baar-Baar Wahi Pattern';

  @override
  String get lvRiskWorkaholic => 'Pyaar se Zyada Kaam';

  @override
  String get lvRedFlags => 'Dhyan Dene Wale Red Flags';

  @override
  String get lvHealing => 'Kya Theek Karna Hai';

  @override
  String get lvFocusArea => 'Focus Area';

  @override
  String get lvHealDir => 'Healing ki Disha';

  @override
  String get lvImprovementPlan => 'Sudhar ka Plan';

  @override
  String get lvReliability => 'Prediction ki Reliability';

  @override
  String get lvLayerBirth => 'Birth Chart (D1)';

  @override
  String get lvLayerNavamsa => 'Navamsa (D9)';

  @override
  String get lvLayerSaptamsa => 'Saptamsa (D7)';

  @override
  String get lvLayerDasha => 'Dasha Timing';

  @override
  String get lvLayerTransit => 'Abhi ke Transits';

  @override
  String get lvTopicWhen => 'Mujhe pyaar kab milega?';

  @override
  String get lvTopicSoulmate => 'Mere soulmate ke baare mein';

  @override
  String get lvTopicCurrent => 'Mera current rishta';

  @override
  String get lvTopicHeal => 'Beete kal se healing';

  @override
  String get lvTopicCommit => 'Commitment mein madad';

  @override
  String get lvTopicLoveVsArranged => 'Love vs arranged marriage';

  @override
  String get lvTopicHeartbreak => 'Dil tootne se bachna';

  @override
  String get lvTopicConfidence => 'Pyaar mein confidence';

  @override
  String get mrSubtitle => 'AI-powered Vedic Marriage Report';

  @override
  String get mrTitle => 'Marriage aur Family';

  @override
  String get mrMarriagePotential => 'Marriage ki Sambhavna';

  @override
  String get mrHarmony => 'Taalmel';

  @override
  String get mrLongevity => 'Lambi Umr';

  @override
  String get mrSatisfaction => 'Santushti';

  @override
  String get mrStability => 'Ghar ki Stability';

  @override
  String get mrClarity => 'Spashtata';

  @override
  String get mrChipHarmony => 'Sundar Bandhan';

  @override
  String get mrChipNoMangal => 'Koi Mangal Dosh Nahi';

  @override
  String get mrChipLongLasting => 'Lambe Samay Tak';

  @override
  String get mrChipHome => 'Apna Ghar Sambhav';

  @override
  String get mrChipInLaws => 'Achhe Sasural Wale';

  @override
  String get mrChipChildren => 'Santaan ka Aashirwad';

  @override
  String get mrSpouse => 'Aapka Hone Wala Jeevansathi';

  @override
  String get mrSpouseSub => 'Kundli Kya Batati Hai';

  @override
  String get mrSpouseTraits => 'Sambhavit Swabhav';

  @override
  String get mrSpouseWork => 'Sambhavit Peshaa';

  @override
  String get mrAgeDiff => 'Umr ka Antar';

  @override
  String get mrCulture => 'Cultural Match';

  @override
  String get mrEducation => 'Padhai';

  @override
  String get mrFamilyBg => 'Family Background';

  @override
  String get mrSoulPartnership => 'Aatma aur Partnership';

  @override
  String get mrSelfPlanet => 'Bandhan Mein Aap';

  @override
  String get mrSpousePlanet => 'Aapka Jeevansathi Graha';

  @override
  String get mrSoulAlignment => 'Aatmik Taalmel';

  @override
  String get mrAlignStrong =>
      'Aapki aatma aur aapke ideal partner ke beech gehra taalmel hai — ek santushtikaran bandhan poori tarah se sambhav hai.';

  @override
  String get mrAlignModerate =>
      'Aapki aatma aur aapke ideal partner ke beech madhyam taalmel hai — thoda dhyaan aur koshish se ek santushtikaran bandhan bane ga.';

  @override
  String get mrAlignLow =>
      'Aapki aatma aur partnership ko thoda sochke taalmel banane ki zarurat hai — aisa partner chunein jo sach mein aapki andaruni values se milta ho.';

  @override
  String get mrTechDarakaraka => 'Jeevansathi Graha (Darakaraka)';

  @override
  String get mrUpapada => 'Marriage Point (Upapada)';

  @override
  String get mrUpapadaLord => 'Upapada Swami';

  @override
  String get mrFoundation => 'Marriage ki Buniyaad';

  @override
  String get mrMarriageSign => 'Marriage Rashi';

  @override
  String get mrMarriageLord => 'Marriage Swami';

  @override
  String get mrHouseStrength => 'Bhava Strength';

  @override
  String get mrPartnerHint => 'Aapki Kundli Se Partner ka Ishaara';

  @override
  String get mrHarmonyHdr => 'Compatibility Harmony';

  @override
  String get mrHarmonySub => 'Aap Kaise Judenge';

  @override
  String get mrEmotional => 'Emotional';

  @override
  String get mrIntellectual => 'Intellectual';

  @override
  String get mrPhysical => 'Physical Nazdeeki';

  @override
  String get mrFinancial => 'Financial';

  @override
  String get mrCommunication => 'Baatcheet';

  @override
  String get mrSharedValues => 'Saanjhe Values';

  @override
  String get mrSpiritual => 'Spiritual';

  @override
  String get mrConflictRes => 'Matbhed Suljhaana';

  @override
  String get mrTiming => 'Marriage ka Samay';

  @override
  String get mrFirstMarriageAge => 'Sambhavit Marriage Umr';

  @override
  String get mrDelayChance => 'Deri Ki Sambhavna';

  @override
  String get mrMarriageWindow => 'Marriage Window';

  @override
  String get mrSecondaryWindow => 'Doosri Window';

  @override
  String get mrCurrentReadiness => 'Abhi Ki Sthiti';

  @override
  String get mrJourney => 'Marriage Ki Yatra';

  @override
  String get mrJourneySub => 'Bandhan Kaise Aage Badhta Hai';

  @override
  String get mrPhaseEarly => 'Shuruaati Saal';

  @override
  String get mrPhaseMid => 'Beech Ke Saal';

  @override
  String get mrPhaseMature => 'Pakke Saal';

  @override
  String get mrPhaseLate => 'Baad Ke Saal';

  @override
  String get mrTip => 'Tip';

  @override
  String get mrFamilyHome => 'Family aur Ghar';

  @override
  String get mrInLaws => 'Sasural Rishtey';

  @override
  String get mrFamilyHarmony => 'Family Mein Taalmel';

  @override
  String get mrHomeOwnership => 'Ghar Ka Malikana';

  @override
  String get mrDomesticPeace => 'Ghar Ki Shaanti';

  @override
  String get mrFertility => 'Fertility';

  @override
  String get mrParenting => 'Parenting Mein Taalmel';

  @override
  String get mrChildren => 'Bachche';

  @override
  String get mrLikelyCount => 'Sambhavit Ginti';

  @override
  String get mrVerification => 'Cross-Chart Verification';

  @override
  String get mrD9 => 'Marriage Chart (D9)';

  @override
  String get mrD10 => 'Career-Spouse Chart (D10)';

  @override
  String get mrD60 => 'Karma Chart (D60)';

  @override
  String get mrChallenges => 'Dhyaan Dene Wali Baatein';

  @override
  String get mrMangalPresent =>
      'Kundli mein Mangal Dosh hai — upay aur matching ko dhyan se dekhein.';

  @override
  String get mrMangalAbsent =>
      'Koi Mangal Dosh nahi mila — yeh marriage ke liye ek shubh sanket hai.';

  @override
  String get mrRiskConflict => 'Matbhed';

  @override
  String get mrRiskSeparation => 'Alagaav';

  @override
  String get mrRiskDistance => 'Emotional Doori';

  @override
  String get mrRiskInfidelity => 'Beimaani';

  @override
  String get mrRiskFinance => 'Paise Ke Matbhed';

  @override
  String get mrPartnerGuide => 'Partner Guide';

  @override
  String get mrPartnerGuideSub => 'Kis Baat Ka Dhyan Rakhein';

  @override
  String get mrSeek => 'Ye Dekhein';

  @override
  String get mrMatchingPriorities => 'Matching Priorities';

  @override
  String get mrImprovementPlan => 'Sudhaar Plan';

  @override
  String get mrReliability => 'Prediction Ki Reliability';

  @override
  String get mrLayerBirth => 'Janam Kundli (D1)';

  @override
  String get mrLayerNavamsa => 'Navamsa (D9)';

  @override
  String get mrLayerDashamsa => 'Dashamsa (D10)';

  @override
  String get mrLayerShashtiamsa => 'Karma (D60)';

  @override
  String get mrLayerDarakaraka => 'Jeevansathi Graha';

  @override
  String get mrTopicWhen => 'Meri Shaadi Kab Hogi?';

  @override
  String get mrTopicSpouse => 'Mere Jeevansathi Ke Baare Mein';

  @override
  String get mrTopicCompat => 'Compatibility Tips';

  @override
  String get mrTopicDelay => 'Marriage Mein Deri';

  @override
  String get mrTopicMangal => 'Mangal Dosh';

  @override
  String get mrTopicChildren => 'Bachchon Ka Samay';

  @override
  String get mrTopicInLaws => 'Sasural Rishtey';

  @override
  String get mrTopicHarmony => 'Taalmel Banana';

  @override
  String get wlSubtitle => 'AI se banayi gayi Vedic Wealth Report';

  @override
  String get wlTitle => 'Wealth & Finance';

  @override
  String get wlWealthPotential => 'Wealth Potential';

  @override
  String get wlAccumulation => 'Dhan Sanchay';

  @override
  String get wlIncomeFlow => 'Income Flow';

  @override
  String get wlRetention => 'Paisa Tikaav';

  @override
  String get wlSustainability => 'Long-term Tikaav';

  @override
  String get wlSavings => 'Savings Discipline';

  @override
  String get wlChipSaver => 'Janamjat saver';

  @override
  String get wlChipMultiIncome => 'Multiple income sources';

  @override
  String get wlChipStrongYogas => 'Dhan yog';

  @override
  String get wlChipLowDebt => 'Kam karz';

  @override
  String get wlChipInheritance => 'Virasat milne ke aasar';

  @override
  String get wlChipInvestor => 'Smart investor';

  @override
  String get wlWealthClass => 'Wealth Class';

  @override
  String get wlWealthType => 'Aapka Main Wealth Type';

  @override
  String get wlPrimarySource => 'Mukhya Income';

  @override
  String get wlPeakAge => 'Sabse zyada dhan ki age';

  @override
  String get wlBoosters => 'Aapki Wealth Ko Kya Boost Kar Raha Hai';

  @override
  String get wlBoostersSub => 'Powerful paise ke combinations';

  @override
  String get wlWealthImpact => 'boost';

  @override
  String get wlDrains => 'Dhan Ki Kami';

  @override
  String get wlIncomeSources => 'Income Sources';

  @override
  String get wlIncomeSourcesSub => 'Aapka paisa kahan se aata hai';

  @override
  String get wlPrimary => 'Mukhya';

  @override
  String get wlInvestment => 'Investment Plan';

  @override
  String get wlInvestmentSub => 'Ideal asset mix';

  @override
  String get wlRiskAppetite => 'Risk Lene Ki Kshamata';

  @override
  String get wlInvestStyle => 'Investing Style';

  @override
  String get wlDrivenBy => 'Isse prerit';

  @override
  String get wlMoneyPersonality => 'Money Personality';

  @override
  String get wlMoneyType => 'Money Type';

  @override
  String get wlSpending => 'Kharcha';

  @override
  String get wlSavingsDiscipline => 'Savings Discipline';

  @override
  String get wlCharity => 'Daan Ki Pravriti';

  @override
  String get wlLuxury => 'Luxury Par Kharcha';

  @override
  String get wlWindfalls => 'Achanak Labh & Mauke';

  @override
  String get wlWindfallsSub => 'Kismat se milne wala paisa';

  @override
  String get wlInheritanceChance => 'Virasat';

  @override
  String get wlSuddenGains => 'Achanak Labh';

  @override
  String get wlLottery => 'Lottery / Sattebaazi';

  @override
  String get wlInsurance => 'Insurance Claims';

  @override
  String get wlWindfallSource => 'Sambhavit achanak labh ka source';

  @override
  String get wlMoneyPlanets => 'Aapke Money Planets';

  @override
  String get wlPrimaryKaraka => 'Mukhya Money Planet';

  @override
  String get wlSecondaryKaraka => 'Dusra Money Planet';

  @override
  String get wlTimeline => 'Wealth Timeline';

  @override
  String get wlPeakYears => 'Peak Years';

  @override
  String get wlGoodPeriod => 'Samriddhi Ka Samay';

  @override
  String get wlSuddenGainWindow => 'Achanak Labh Ka Samay';

  @override
  String get wlToughPeriod => 'Savdhani Ka Samay';

  @override
  String get wlDebtRisks => 'Karz Aur Paise Ke Risks';

  @override
  String get wlDebtChance => 'Karz Hone Ki Sambhavna';

  @override
  String get wlLoanBurden => 'Loan Ka Bojh';

  @override
  String get wlDrainSources => 'In cheezon se savdhan rahein';

  @override
  String get wlStrengthen => 'Kya Mazboot Karein';

  @override
  String get wlWeakestDriver => 'Sabse Kamzor Money Factor';

  @override
  String get wlHowToFix => 'Kaise mazboot karein';

  @override
  String get wlImprovementPlan => 'Improvement Plan';

  @override
  String get wlReliability => 'Prediction Ki Reliability';

  @override
  String get wlLayerBirth => 'Dhan Bhaav (D1)';

  @override
  String get wlLayerHora => 'Hora Chart (D2)';

  @override
  String get wlLayerNavamsa => 'Navamsa (D9)';

  @override
  String get wlLayerDasha => 'Dasha Timing';

  @override
  String get wlLayerTransit => 'Current Gochar';

  @override
  String get wlTopicGrow => 'Wealth kaise badhaye';

  @override
  String get wlTopicInvest => 'Kahan invest karein';

  @override
  String get wlTopicDebt => 'Karz manage karna';

  @override
  String get wlTopicProperty => 'Property kharidna';

  @override
  String get wlTopicRetire => 'Retirement planning';

  @override
  String get wlTopicPassive => 'Passive income';

  @override
  String get wlTopicWindfall => 'Achanak labh';

  @override
  String get wlTopicTiming => 'Paise ke liye best samay';

  @override
  String get bzSubtitle => 'AI-powered Vedic Business Report';

  @override
  String get bzTitle => 'Business & Startup';

  @override
  String get bzBusinessPotential => 'Business Potential';

  @override
  String get bzEntrepreneurship => 'Entrepreneur';

  @override
  String get bzVenture => 'Venture Success';

  @override
  String get bzWealth => 'Business se Wealth';

  @override
  String get bzRiskAppetite => 'Risk Lene ki Capacity';

  @override
  String get bzLongevity => 'Longevity';

  @override
  String get bzChipWealthMagnet => 'Wealth Magnet';

  @override
  String get bzChipMoneyYoga => 'Money Yoga';

  @override
  String get bzChipLeadership => 'Leadership';

  @override
  String get bzChipPartnerFit => 'Great Partner Fit';

  @override
  String get bzChipGains => 'Strong Gains';

  @override
  String get bzChipInvestor => 'Investor Appeal';

  @override
  String get bzChipFounder => 'Founder Mindset';

  @override
  String get bzWhatsWorking => 'Aapke Liye Kya Kaam Kar Raha Hai';

  @override
  String get bzWhatsWorkingSub => 'Aapke Business Gifts';

  @override
  String get bzClassicYogas => 'Classic Wealth Combinations';

  @override
  String get bzFounderType => 'Aapka Founder Type';

  @override
  String get bzSoulBusiness => 'Soul & Business Purpose';

  @override
  String get bzSoulPlanet => 'Aapka Soul Driver';

  @override
  String get bzBusinessPlanet => 'Aapka Business Mind';

  @override
  String get bzDirectionStrength => 'Direction Clarity';

  @override
  String get bzAlignStrong =>
      'Aapka soul purpose aur business direction strongly aligned hain — venture banana natural aur fulfilling lagta hai.';

  @override
  String get bzAlignModerate =>
      'Aapka soul purpose aur business direction moderately aligned hain — venture tab best kaam karta hai jab woh aapke deeper values ko reflect kare.';

  @override
  String get bzAlignLow =>
      'Aapke soul purpose aur business direction ko conscious alignment ki zaroorat hai — aisa venture choose karein jo genuinely aapse match kare.';

  @override
  String get bzTechAtmakaraka => 'Soul Planet (Atmakaraka)';

  @override
  String get bzTechAmatyakaraka => 'Business Planet (Amatyakaraka)';

  @override
  String get bzTechDarakaraka => 'Partner Planet (Darakaraka)';

  @override
  String get bzFoundation => 'Business Foundation';

  @override
  String get bzCareerHouse => 'Career House';

  @override
  String get bzGainsHouse => 'Gains House';

  @override
  String get bzLord => 'Lord';

  @override
  String get bzGainsPotential => 'Gains Potential';

  @override
  String get bzNetwork => 'Network Power';

  @override
  String get bzRecovery => 'Recovery Strength';

  @override
  String get bzVerification => 'Cross-Chart Verification';

  @override
  String get bzD10 => 'Career Chart (D10)';

  @override
  String get bzD11 => 'Gains Chart (D11)';

  @override
  String get bzD9 => 'Purpose Chart (D9)';

  @override
  String get bzD60 => 'Karma Chart (D60)';

  @override
  String get bzFounderSkills => 'Founder Skills';

  @override
  String get bzSkillStrategy => 'Strategic Thinking';

  @override
  String get bzSkillExecution => 'Execution';

  @override
  String get bzSkillPeople => 'People Management';

  @override
  String get bzSkillSales => 'Sales & Persuasion';

  @override
  String get bzSkillFinance => 'Financial Acumen';

  @override
  String get bzSkillOps => 'Operational Discipline';

  @override
  String get bzTopSkill => 'Top Skill';

  @override
  String get bzDomains => 'Best Business Fields';

  @override
  String get bzDomainsSub => 'Natural Fit ke Hisaab se Ranked';

  @override
  String get bzFit => 'FIT';

  @override
  String get bzBusinessStyleHdr => 'Business Style';

  @override
  String get bzStyleService => 'Product vs Service';

  @override
  String get bzStyleMarket => 'Market Focus';

  @override
  String get bzStyleTech => 'Tech Approach';

  @override
  String get bzStyleLeadership => 'Leadership Style';

  @override
  String get bzStylePartnership => 'Solo ya Partnership';

  @override
  String get bzWhereBuild => 'Reach';

  @override
  String get bzExpansion => 'Expansion';

  @override
  String get bzSetup => 'Setup';

  @override
  String get bzPartnership => 'Partnership & Team';

  @override
  String get bzIdealCofounder => 'Ideal Co-founder';

  @override
  String get bzPartnerViability => 'Partnership Fit';

  @override
  String get bzTeamBuilding => 'Team Building';

  @override
  String get bzCofounderFit => 'Co-founder Fit';

  @override
  String get bzAdvisorNetwork => 'Advisor Network';

  @override
  String get bzFunding => 'Funding & Money';

  @override
  String get bzRecommendedPath => 'Recommended Funding Path';

  @override
  String get bzInvestorAttract => 'Investor Appeal';

  @override
  String get bzFamilyBacking => 'Family Support';

  @override
  String get bzHybridViability => 'Job + Business Mix';

  @override
  String get bzFallback => 'Backup ke Taur Par Job';

  @override
  String get bzDebtStyle => 'Debt Style';

  @override
  String get bzTimeline => 'Business Timeline';

  @override
  String get bzCurrentPhase => 'Abhi ka Time';

  @override
  String get bzLaunchWindow => 'Launch Window';

  @override
  String get bzScaleWindow => 'Growth Window';

  @override
  String get bzPeakAge => 'Peak Years';

  @override
  String get bzChallenges => 'Dhyan Dene Wali Challenges';

  @override
  String get bzRiskFinancial => 'Financial Loss';

  @override
  String get bzRiskBurnout => 'Burnout';

  @override
  String get bzRiskTeam => 'Team Conflict';

  @override
  String get bzRiskLegal => 'Legal / Regulatory';

  @override
  String get bzFinancialExp =>
      'Zyada investment ya kharab cash-flow timing ki wajah se venture mein paise doobne ka risk.';

  @override
  String get bzFinancialFix =>
      'Cash reserve rakhein, lean start karein, aur spend badhane se pehle demand validate karein.';

  @override
  String get bzBurnoutExp =>
      'Bahut lambe time tak bahut zyada mehnat karne se aapki energy aur focus kam ho sakta hai.';

  @override
  String get bzBurnoutFix =>
      'Rest ko priority dein, jaldi delegate karein, aur badi pushes ko supportive periods ke around plan karein.';

  @override
  String get bzTeamExp =>
      'Co-founders ya staff ke saath friction business ko slow kar sakta hai.';

  @override
  String get bzTeamFix =>
      'Roles aur expectations ko likhit mein clear rakhein, aur regularly communicate karein.';

  @override
  String get bzLegalExp =>
      'Compliance, contracts ya regulatory issues obstacles create kar sakte hain.';

  @override
  String get bzLegalFix =>
      'Contracts review karwayein, paperwork clean rakhein, aur professionals se jaldi consult karein.';

  @override
  String get bzImprovementPlan => 'Improvement Plan';

  @override
  String get bzBestDirection => 'Best Direction';

  @override
  String get bzStrategy => 'Build Strategy';

  @override
  String get bzTopFields => 'Top Fields';

  @override
  String get bzEmploymentPath => 'Job vs Business';

  @override
  String get bzRoadmap => 'Growth Roadmap';

  @override
  String get bzRoadmapSub => 'Aapka Venture Plan';

  @override
  String get bzReliability => 'Prediction Reliability';

  @override
  String get bzLayerBirth => 'Birth Chart (D1)';

  @override
  String get bzLayerNavamsa => 'Navamsa (D9)';

  @override
  String get bzLayerDashamsa => 'Career (D10)';

  @override
  String get bzLayerLabhamsa => 'Gains (D11)';

  @override
  String get bzLayerShashtiamsa => 'Karma (D60)';

  @override
  String get bzTopicStart => 'Kya mujhe abhi start karna chahiye?';

  @override
  String get bzTopicIdea => 'Best Business Idea';

  @override
  String get bzTopicPartner => 'Co-founder Dhoondhna';

  @override
  String get bzTopicFunding => 'Ise Fund Kaise Karein';

  @override
  String get bzTopicScale => 'Kab Scale Karein';

  @override
  String get bzTopicRisk => 'Risks ko Manage Karna';

  @override
  String get bzTopicJob => 'Job vs Business';

  @override
  String get bzTopicTiming => 'Best Timing';

  @override
  String get crTitle => 'Career aur Job Analysis';

  @override
  String get crSubtitle => 'AI-powered Vedic Career Report';

  @override
  String get crCrumbHome => 'Home';

  @override
  String get crCrumbReports => 'Reports';

  @override
  String get crCareerPotential => 'Career Potential';

  @override
  String get crStatusStrong => 'Strong Potential';

  @override
  String get crStatusGood => 'Good Potential';

  @override
  String get crStatusModerate => 'Moderate Potential';

  @override
  String get crStatusDeveloping => 'Developing Potential';

  @override
  String get crStatusChallenging => 'Challenging Phase';

  @override
  String get crOverallCareer => 'Overall Career';

  @override
  String get crStability => 'Career Stability';

  @override
  String get crGrowth => 'Growth Potential';

  @override
  String get crRecognition => 'Recognition';

  @override
  String get crSatisfaction => 'Satisfaction';

  @override
  String get crChipLeadership => 'Leadership';

  @override
  String get crChipCreativity => 'Creativity';

  @override
  String get crChipBusiness => 'Business';

  @override
  String get crChipStableIncome => 'Stable Income';

  @override
  String get crChipLearning => 'Learning';

  @override
  String get crChipGrowth => 'Long-Term Growth';

  @override
  String get crChipTechnical => 'Technical Skill';

  @override
  String get crChipRecognition => 'Recognition';

  @override
  String get crTopInsights => 'Top Insights';

  @override
  String get crWhatDefines => 'Aapke career ko kya define karta hai?';

  @override
  String get crSoulCareer => 'Soul aur Career ka Purpose';

  @override
  String get crSoulPlanet => 'Soul Purpose Planet';

  @override
  String get crCareerPlanet => 'Career Planet';

  @override
  String get crMeaning => 'Matlab';

  @override
  String get crAlignment => 'Soul ↔ Career Alignment';

  @override
  String get crAlignStrong =>
      'Aapki natural interests aur career path strongly aligned hain.';

  @override
  String get crAlignModerate =>
      'Aapki natural interests aur career path moderately aligned hain.';

  @override
  String get crAlignLow =>
      'Aapki natural interests aur career path ko conscious alignment ki zaroorat hai.';

  @override
  String get crTechAtmakaraka => 'Atmakaraka (Soul indicator)';

  @override
  String get crTechAmatyakaraka => 'Amatyakaraka (Career indicator)';

  @override
  String get crDegrees => 'Degrees';

  @override
  String get crDignity => 'Dignity';

  @override
  String get crFoundation => 'Career Foundation';

  @override
  String get crCareerSign => 'Career Sign';

  @override
  String get crCareerLord => 'Career Lord';

  @override
  String get crLordPosition => 'Lord Position';

  @override
  String get crCareerStrength => 'Career Strength';

  @override
  String get crProfStyle => 'Professional Style';

  @override
  String get crBestFields => 'Best Fields';

  @override
  String get crTechnicalDetails => 'Technical Details';

  @override
  String get crHouseLabel => 'House';

  @override
  String get crVerification => 'Charts ke aar-paar Career Verification';

  @override
  String get crD10Career => 'D10 · Career';

  @override
  String get crD9Purpose => 'D9 · Purpose';

  @override
  String get crD60Karma => 'D60 · Karma';

  @override
  String get crStatusNeedsImprovement => 'Improvement ki zaroorat';

  @override
  String get crStatusWellAligned => 'Well Aligned';

  @override
  String get crStatusStrongSupport => 'Strong Support';

  @override
  String get crStatusModerateSupport => 'Moderate Support';

  @override
  String get crChartDetails => 'Technical chart details';

  @override
  String get crPersonality => 'Aapki Career Personality';

  @override
  String get crGrowthAreas => 'Growth Areas';

  @override
  String get crBestRoles => 'Best Roles';

  @override
  String get crBestIndustries => 'Best Industries';

  @override
  String get crEnvironment => 'Career Environment';

  @override
  String get crWorkStyle => 'Best Work Style';

  @override
  String get crEmployment => 'Job / Employment';

  @override
  String get crBusiness => 'Business';

  @override
  String get crFreelance => 'Freelance / Consulting';

  @override
  String get crPortfolio => 'Mixed Portfolio';

  @override
  String get crLeadership => 'Leadership';

  @override
  String get crFit => 'Fit';

  @override
  String get crBestFit => 'Best Fit';

  @override
  String get crTimeline => 'Career Timeline';

  @override
  String get crPastPeak => 'Past Peak';

  @override
  String get crPresentPhase => 'Present Phase';

  @override
  String get crUpcoming => 'Aane wala Opportunity';

  @override
  String get crFutureExpansion => 'Future Expansion';

  @override
  String get crRiskPeriod => 'Risk Period';

  @override
  String get crViewDasha => 'Planetary period (technical)';

  @override
  String get crChallenges => 'Dhyaan rakhne wali Challenges';

  @override
  String get crRiskBurnout => 'Burnout';

  @override
  String get crRiskRecognition => 'Recognition mein Delay';

  @override
  String get crRiskConflict => 'Workplace Conflict';

  @override
  String get crRiskFinancial => 'Financial Instability';

  @override
  String get crRiskOverqual => 'Under-utilization';

  @override
  String get crPrevention => 'Bachaav';

  @override
  String get crBurnoutExp =>
      'Lambe aur demanding phases time ke saath aapki energy drain kar sakte hain.';

  @override
  String get crBurnoutFix =>
      'Apna rest protect karein, boundaries set karein, aur bade pushes ko pace se lein.';

  @override
  String get crRecognitionExp =>
      'Rewards aur recognition aapki mehnat se thoda slow aa sakte hain.';

  @override
  String get crRecognitionFix =>
      'Apni wins document karein aur apne contributions ko seniors ke saamne visible banayein.';

  @override
  String get crConflictExp =>
      'Colleagues ya authority ke saath kabhi-kabhi friction ho sakta hai.';

  @override
  String get crConflictFix =>
      'Shant tarike se communicate karein aur apni battles samajhdari se choose karein.';

  @override
  String get crFinancialExp =>
      'Kuch phases mein income uneven feel ho sakti hai.';

  @override
  String get crFinancialFix =>
      'Ek buffer rakhein aur financially over-commit karne se bachein.';

  @override
  String get crOverqualExp =>
      'Kabhi-kabhi aapko lag sakta hai ki aapki potential ka poora use nahi ho raha.';

  @override
  String get crOverqualFix =>
      'Stretch roles dhoondein aur engaged rehne ke liye seekhte rahein.';

  @override
  String get crImprovementPlan => 'Career Improvement Plan';

  @override
  String get crCatPlanetary => 'Planetary aur Spiritual';

  @override
  String get crCatPractical => 'Practical Steps';

  @override
  String get crTraditionalExplain => 'Traditional astrology explanation';

  @override
  String get crActionPlan => '30-Din ka Career Action Plan';

  @override
  String get crWeek1 => 'Week 1 · Profile Optimization';

  @override
  String get crWeek2 => 'Week 2 · Skill Building';

  @override
  String get crWeek3 => 'Week 3 · Networking';

  @override
  String get crWeek4 => 'Week 4 · Career Visibility';

  @override
  String get crWeek1Tip =>
      'Apne sabse strong career theme ke around resume aur LinkedIn ko refresh karein.';

  @override
  String get crWeek2Tip =>
      'Apne best field mein ek high-value skill choose karein aur roz practice karein.';

  @override
  String get crWeek3Tip =>
      'Apne mentors se dobara connect karein aur do naye industry contacts se baat karein.';

  @override
  String get crWeek4Tip =>
      'Apna kaam publicly share karein aur ek visible project ke liye volunteer karein.';

  @override
  String get crPriority => 'Priority';

  @override
  String get crTimeRequired => 'Time';

  @override
  String get crExpectedBenefit => 'Benefit';

  @override
  String get crPriorityHigh => 'High';

  @override
  String get crPriorityMedium => 'Medium';

  @override
  String get crRoadmap => 'AI Career Roadmap';

  @override
  String get crNext12 => 'Agle 12 Mahine';

  @override
  String get crBestFocus => 'Best Focus';

  @override
  String get crSkillsLearn => 'Seekhne wali Skills';

  @override
  String get crIndustriesTarget => 'Target karne wali Industries';

  @override
  String get crExpectedOutcome => 'Expected Outcome';

  @override
  String get crReliability => 'Prediction Reliability';

  @override
  String get crReliabilityHigh => 'High Reliability';

  @override
  String get crReliabilityGood => 'Good Reliability';

  @override
  String get crReliabilityModerate => 'Moderate Reliability';

  @override
  String get crReliabilityExplain =>
      'Yeh report aapki birth chart, divisional charts aur Jaimini indicators ko combine karti hai. Score batata hai ki yeh chart layers kitni strongly agree karte hain.';

  @override
  String get crChartLayers => 'Chart layers aur weights';

  @override
  String get crBirthChart => 'Birth Chart (D1)';

  @override
  String get crNavamsa => 'Navamsa (D9)';

  @override
  String get crDashamsa => 'Dashamsa (D10)';

  @override
  String get crShashtiamsa => 'Shashtiamsa (D60)';

  @override
  String get crDiscussAi => 'AI ke saath Discuss karein';

  @override
  String get crAskAbout => 'Ye Poochein';

  @override
  String get crTopicChange => 'Career Change';

  @override
  String get crTopicGovt => 'Government Job';

  @override
  String get crTopicBusiness => 'Business';

  @override
  String get crTopicPromotion => 'Promotion';

  @override
  String get crTopicMarriage => 'Marriage vs Career';

  @override
  String get crTopicAbroad => 'Videsh';

  @override
  String get crTopicIncome => 'Income';

  @override
  String get crTopicPurpose => 'Purpose';

  @override
  String get crTopicResume => 'Resume';

  @override
  String get crTopicCopied =>
      'Question copy ho gaya — ise apni AI chat mein paste karein.';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return '$soul aapki inner calling ko guide karta hai, jabki $career aapke outer profession ko shape karta hai.';
  }

  @override
  String get rzTodayOutlook => 'Aaj ka Rashi Overview';

  @override
  String get rzPlanetaryEnergy => 'Aaj ki Planetary Energy';

  @override
  String get rzBestSign => 'Best Sign';

  @override
  String get rzChallengingSign => 'Sabse Challenging';

  @override
  String get rzDominantPlanet => 'Dominant Planet';

  @override
  String get rzOverallMood => 'Overall Mood';

  @override
  String get rzMoodBright => 'Bright aur Active';

  @override
  String get rzMoodCalm => 'Calm aur Steady';

  @override
  String get rzMoodMixed => 'Mixed Energy';

  @override
  String get rzMoodTense => 'Tense aur Careful';

  @override
  String get rzTodayEnergy => 'Aaj ki Energy';

  @override
  String get rzCaution => 'Caution';

  @override
  String get rzWeak => 'Weak';

  @override
  String get rzAllSigns => 'Saari Rashiyan';

  @override
  String get rzAiSummary => 'AI Summary';

  @override
  String get rzPlanetaryInfluence => 'Aaj ka Planetary Influence';

  @override
  String get rzStrongInfluences => 'Strong Influences';

  @override
  String get rzShowTechnical => 'Technical details dikhayein';

  @override
  String get rzOpportunities => 'Aaj ke Opportunities';

  @override
  String get rzAvoidTitle => 'Aaj Inse Bachein';

  @override
  String get rzTechnicalReason => 'Technical Reason';

  @override
  String get rzAvoidDecisions => 'Important faislon mein jaldbaazi';

  @override
  String get rzAvoidArguments => 'Garam bahas';

  @override
  String get rzAvoidInvestments => 'Bada investment';

  @override
  String get rzAvoidOverthink => 'Chhoti baaton par zyada sochna';

  @override
  String get rzAvoidOverspend => 'Fizool kharcha';

  @override
  String get rzAvoidStress => 'Stress aur zyada kaam';

  @override
  String get rzPlanetaryChart => 'Aaj ka Planetary Chart';

  @override
  String get rzWhatChartMeans => 'Is chart ka matlab';

  @override
  String get rzChartExplain =>
      'Yeh diamond shape dikhata hai ki aaj aasman mein har planet kahan hai, aapki rashi ke hisaab se. Supportive houses mein planets din ko behtar banate hain; tough houses mein unke liye thoda dhyan rakhna zaroori hai.';

  @override
  String get rzDoNetworking => 'Networking aur connections';

  @override
  String get rzDoLearning => 'Kuch naya seekhna';

  @override
  String get rzDoMeditation => 'Meditation aur shaanti';

  @override
  String get rzDoFamily => 'Family time';

  @override
  String get rzDoCreative => 'Creative kaam';

  @override
  String get rzDoRest => 'Rest aur self-care';

  @override
  String get rzAiRecommendations => 'Aaj ki AI Recommendations';

  @override
  String get rzTechnical => 'Technical Astrology';

  @override
  String get rzTransitScore => 'Transit Score';

  @override
  String get rzVedha => 'Vedha (Rukavatein)';

  @override
  String get rzGocharDetails => 'Gochar Details';

  @override
  String get rzAdvancedOnly => 'Advanced users ke liye';

  @override
  String get rzTomorrow => 'Kal ki Jhalak';

  @override
  String get rzTomorrowEnergy => 'Kal ki Energy';

  @override
  String get rzImproving => 'Improve ho rahi hai';

  @override
  String get rzWeaker => 'Thodi Weak';

  @override
  String get rzSteady => 'Steady';

  @override
  String get rzTomorrowUpLine =>
      'Kal energy badhne ki ummeed hai — important kaam pehle se plan kar lein.';

  @override
  String get rzTomorrowDownLine =>
      'Kal energy thodi kam ho sakti hai — din ko halka aur steady rakhein.';

  @override
  String get rzTomorrowFlatLine =>
      'Kal energy steady rahegi — aage ek shaant, balanced din hai.';

  @override
  String get rzWeeklyTrend => 'Weekly Trend';

  @override
  String get rzMonthlyTrend => 'Monthly Trend';

  @override
  String get rzBestDayWeek => 'Best Din';

  @override
  String get rzHardestDay => 'Sabse Mushkil Din';

  @override
  String get rzLuckyToday => 'Aaj Lucky';

  @override
  String get rzKarakaSun => 'confidence aur vitality';

  @override
  String get rzKarakaMoon => 'emotions aur mann ki shaanti';

  @override
  String get rzKarakaMars => 'energy aur drive';

  @override
  String get rzKarakaMercury => 'baatcheet aur seekhna';

  @override
  String get rzKarakaJupiter => 'gyaan aur growth';

  @override
  String get rzKarakaVenus => 'rishtey aur comfort';

  @override
  String get rzKarakaSaturn => 'discipline aur patience';

  @override
  String get rzKarakaRahu => 'ambition aur badlaav';

  @override
  String get rzKarakaKetu => 'spirituality aur chhodna';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '$dom din ka mood set karta hai, jabki $chal ko patience aur care chahiye.';
  }

  @override
  String rzInsightGood(Object karaka) {
    return '$karaka ke liye accha din hai.';
  }

  @override
  String rzInsightHard(Object karaka) {
    return 'Aaj $karaka mein thoda dheere chalein.';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return 'Aaj $karaka ko accha support mil raha hai.';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return 'Aaj $karaka mein delay ho sakti hai.';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return 'Aaj $strong ke liye supportive hai, jabki $weak ko patience aur care chahiye.';
  }

  @override
  String get fdEnergyScore => 'Aaj ka Energy Score';

  @override
  String get fdStatusAverage => 'Average';

  @override
  String get fdStatusMixed => 'Mixed';

  @override
  String get fdStatusChallenging => 'Challenging';

  @override
  String get fdTheme => 'Aaj ka Theme';

  @override
  String get fdExplainToday => 'Aaj ko Samjhein';

  @override
  String get fdTodaysFocus => 'Aaj ka Focus';

  @override
  String get fdTopRecommendation => 'Sabse Bada Sujhaav';

  @override
  String get fdTopCaution => 'Sabse Badi Savdhani';

  @override
  String get fdReadingTime => 'Padhne ka Samay';

  @override
  String get fdSeconds30 => '30 sec';

  @override
  String get fdCareer => 'Career';

  @override
  String get fdMoney => 'Paisa';

  @override
  String get fdLove => 'Pyaar';

  @override
  String get fdHealth => 'Sehat';

  @override
  String get fdTravel => 'Safar';

  @override
  String get fdFamily => 'Parivaar';

  @override
  String get fdBestToDo => 'Aaj Karne Layak Best Cheezein';

  @override
  String get fdAvoidToday => 'Aaj In Se Bachein';

  @override
  String get fdConfidenceLabel => 'Confidence';

  @override
  String get fdBestTime => 'Best Time';

  @override
  String get fdRecommended => 'Recommended';

  @override
  String get fdReason => 'Reason';

  @override
  String get fdRisk => 'Risk';

  @override
  String get fdRecommendation => 'Sujhaav';

  @override
  String get fdNoActions =>
      'Aaj kuch khaas push karne ki zaroorat nahi — ek steady, shaant routine banaye rakhein.';

  @override
  String get fdNoCautions =>
      'Aaj koi badi savdhani nahi — normal awareness ke saath aage badhein.';

  @override
  String get fdHighlights => 'Aaj ki Khaas Baatein';

  @override
  String get fdProbVeryHigh => 'Bahut Zyada';

  @override
  String get fdProbHigh => 'Zyada';

  @override
  String get fdProbElevated => 'Badha Hua';

  @override
  String get fdProbCaution => 'Savdhani';

  @override
  String get fdWhatToDo => 'Kya Karein';

  @override
  String get fdLifeAreas => 'Life Ke Areas';

  @override
  String get fdTapDetails => 'Details ke liye tap karein';

  @override
  String get fdArea1 => 'Khud & Sehat';

  @override
  String get fdArea2 => 'Dhan & Parivaar';

  @override
  String get fdArea3 => 'Communication';

  @override
  String get fdArea4 => 'Ghar & Aaram';

  @override
  String get fdArea5 => 'Creativity & Romance';

  @override
  String get fdArea6 => 'Kaam & Zimmedariyan';

  @override
  String get fdArea7 => 'Rishtey';

  @override
  String get fdArea8 => 'Badlaav & Gehrai';

  @override
  String get fdArea9 => 'Kismat & Safar';

  @override
  String get fdArea10 => 'Career & Status';

  @override
  String get fdArea11 => 'Fayda & Network';

  @override
  String get fdArea12 => 'Aaram & Adhyaatm';

  @override
  String get fdTodaysMeaning => 'Aaj ka Matlab';

  @override
  String get fdGoodFor => 'Iske Liye Accha';

  @override
  String get fdAvoid => 'Bachein';

  @override
  String get fdPlanetSupport => 'Grahon ka Saath';

  @override
  String get fdWhyPrediction => 'Yeh prediction kyun?';

  @override
  String get fdAdvancedDetails => 'Advanced Details';

  @override
  String get fdAiRecommendation => 'AI Sujhaav';

  @override
  String get fdOverallStatus => 'Overall Status';

  @override
  String get fdNoPlanetTransit =>
      'Aaj koi bada graha is area mein transit nahi kar raha.';

  @override
  String get fdFinancialOutlook => 'Financial Outlook';

  @override
  String get fdIncomeProbability => 'Income ki Sambhavna';

  @override
  String get fdExpenseProbability => 'Kharch ki Sambhavna';

  @override
  String get fdNetBalance => 'Net Financial Balance';

  @override
  String get fdAvoidSpending => 'Kharch se Bachein';

  @override
  String get fdRelationshipOutlook => 'Rishton ka Outlook';

  @override
  String get fdOverallScore => 'Overall Score';

  @override
  String get fdPartner => 'Partner';

  @override
  String get fdRomance => 'Romance';

  @override
  String get fdWorkplace => 'Workplace';

  @override
  String get fdPublicImage => 'Public Image';

  @override
  String get fdBestActivity => 'Best Activity';

  @override
  String get fdWeakArea => 'Kamzor Area';

  @override
  String get fdBiggestOpportunity => 'Sabse Bada Mauka';

  @override
  String get fdBiggestRisk => 'Sabse Bada Risk';

  @override
  String get fdProbability => 'Sambhavna';

  @override
  String get fdProtection => 'Suraksha ki Salah';

  @override
  String get fdDescription => 'Description';

  @override
  String get fdBestTimeToday => 'Aaj ka Best Time';

  @override
  String get fdAvoidDuring => 'Is Dauran Bachein';

  @override
  String get fdPredictionConfidence => 'Prediction ka Confidence';

  @override
  String get fdConfBasis => 'Aaj ki prediction inka mel hai';

  @override
  String get fdConfNatal => 'Janam Kundli';

  @override
  String get fdConfTransit => 'Current Transit';

  @override
  String get fdConfDasha => 'Grahon ki Dasha';

  @override
  String get fdConfStrength => 'Grah ki Takat';

  @override
  String get fdConfHouse => 'Bhav Activation';

  @override
  String get fdAskAi => 'AI Se Poochein';

  @override
  String get fdAskAiSub => 'Aaj ka jawab paane ke liye sawal par tap karein';

  @override
  String get fdQ1 => 'Aaj career slow kyun hai?';

  @override
  String get fdQ2 => 'Aaj best time kya hai?';

  @override
  String get fdQ3 => 'Kya aaj paise ke maamlon ke liye accha hai?';

  @override
  String get fdQ4 => 'Kya aaj safar ke liye accha hai?';

  @override
  String get fdQ5 => 'Aaj mujhe kis se bachna chahiye?';

  @override
  String get fdMoreSuggestions => 'Aur Sujhaav';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return 'Aaj $top ke liye sabse best hai. $weak mein sustee lag sakti hai, isliye wahan bade faisle lene se bachein. Financially din $fin lag raha hai.';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return 'Aaj aapki energy $top ke aas-paas center hai — isme poora dhyan lagayein aur baaki jagah halke se aage badhein.';
  }

  @override
  String get gochToday => 'Aaj';

  @override
  String get gochOverallScore => 'Overall Gochar Score';

  @override
  String get gochNeutral => 'Neutral';

  @override
  String get gochChallenging => 'Challenging';

  @override
  String get gochTopPositive => 'Top Positive';

  @override
  String get gochTopChallenges => 'Top Challenges';

  @override
  String get gochFilterAll => 'Sabhi';

  @override
  String get gochFavorability => 'Anukulta';

  @override
  String get gochAlerts => 'Gochar Alerts';

  @override
  String get gochAlertCritical => 'Gambhir';

  @override
  String get gochAlertWarning => 'Savdhani';

  @override
  String get gochAlertOpportunity => 'Avsar';

  @override
  String get gochAiFocus => 'Aaj ka AI Focus';

  @override
  String get gochLifeScores => 'Life Area Scores';

  @override
  String get gochWhy => 'Kyun?';

  @override
  String get gochCurrentTransits => 'Active Gochar';

  @override
  String get gochDailyPlan => 'Aapka Daily Plan';

  @override
  String get gochMorning => 'Subah';

  @override
  String get gochAfternoon => 'Dopahar';

  @override
  String get gochEvening => 'Shaam';

  @override
  String get gochNight => 'Raat';

  @override
  String get gochSmartReco => 'Smart Recommendations';

  @override
  String get gochExplain => 'Aaj Ka Gochar Samjhein';

  @override
  String get gochDo => 'Karein';

  @override
  String get gochDont => 'Na Karein';

  @override
  String get gochDoWork => 'Important kaam nipatayein';

  @override
  String get gochDoMeditate => 'Dhyan karein aur reflect karein';

  @override
  String get gochDoStart => 'Naye plans shuru karein';

  @override
  String get gochDoFinish => 'Pending kaam poore karein';

  @override
  String get gochDontArgue => 'Bahas se bachein';

  @override
  String get gochDontImpulsive => 'Jaldbaazi mein faisle lene se bachein';

  @override
  String get gochDontOverspend => 'Zyada kharch karne se bachein';

  @override
  String gochThemeGrowth(Object area) {
    return 'Aaj $area mein growth ka din hai — ispar poora dhyan dein.';
  }

  @override
  String gochThemeChallenge(Object area) {
    return 'Aaj $area ke saath patience rakhein — steady rahein.';
  }

  @override
  String gochPosLine(Object area) {
    return '$area ko abhi achha support mil raha hai.';
  }

  @override
  String gochChalLine(Object area) {
    return 'Aaj $area ko extra dhyan dene ki zaroorat hai.';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return 'Aaj apni energy $a1 mein lagayein, aur $a2 ke saath narmi rakhein.';
  }

  @override
  String get divBeginner => 'Saral';

  @override
  String get divSearchHint => 'Khojein: career, vivah, shiksha…';

  @override
  String get divSummaryTitle => 'Varg Kundli Saaraansh';

  @override
  String get divTotalCharts => 'Kul Kundliyan';

  @override
  String get divMostImportant => 'Sabse Mahatvapurna';

  @override
  String get divRecommendedForYou => 'Aapke Liye Anushansit';

  @override
  String get divCatEssential => 'Aavashyak Kundliyan';

  @override
  String get divCatPersonal => 'Vyaktigat Jeevan';

  @override
  String get divCatKnowledge => 'Gyaan Kundliyan';

  @override
  String get divCatAdvanced => 'Unnat Kundliyan';

  @override
  String get divGoalProperty => 'Sampatti';

  @override
  String get divGoalKarma => 'Karm';

  @override
  String get divBadgeHighlyRec => 'Atyadhik Anushansit';

  @override
  String get divBadgeRec => 'Anushansit';

  @override
  String get divBadgeUseful => 'Upyogi';

  @override
  String get divBadgeOptional => 'Vaikalpik';

  @override
  String get divBadgeAdvOnly => 'Keval Unnat';

  @override
  String get divRecommendBest => 'Best Kundliyan Sujhaein';

  @override
  String get divNoMatch => 'Aapki khoj se koi kundli match nahi hui';

  @override
  String get divLifeAreas => 'Jeevan Kshetra';

  @override
  String divAiUse(Object purpose) {
    return '$purpose ka vishleshan karne ke liye is kundli ka upyog karein.';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return 'Aapki $c1 aur $c2 kundliyan khaas taur par mahatvapurna hain — inse judi cheezon ke liye yahin se shuruat karein, phir zarurat ke anusar baaki kundliyan bhi dekhein.';
  }

  @override
  String divRecReasonHouse(Object house) {
    return 'Aapke $house bhaav par gehrai se nazar daalna zaroori hai — yeh kundli ise vistaar se dikhati hai.';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '$planet ek mahatvapurna lekin chunauti-purna grah hai — yeh kundli iski gehri sthiti ko ujagar karti hai.';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return 'Aap abhi $planet ki Mahadasha mein hain, isliye yeh kundli abhi khaas taur par upyukt hai.';
  }

  @override
  String divRecSummary(Object c1) {
    return 'Aapki kundli ke anusar, $c1 aapki sabse badi priority honi chahiye. Neeche di gayi kundliyan aapke liye unki prasangikta ke hisaab se kramabaddh hain.';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return 'Jab aap $purpose ka adhyayan karna chahein, tab yeh kundli kholein.';
  }

  @override
  String get yogaHelpful => 'Sahayak';

  @override
  String get yogaInactive => 'Nishkriya';

  @override
  String get yogaTabMoney => 'Dhan';

  @override
  String get yogaTabRare => 'Durlabh';

  @override
  String get yogaSummaryTitle => 'Yog Saaraansh';

  @override
  String get yogaActiveYogas => 'Sakriya Yog';

  @override
  String get yogaTotalYogas => 'Kul Yog';

  @override
  String get yogaMostPowerful => 'Sabse Shaktishali';

  @override
  String get yogaFortuneRating => 'Samagra Bhagya';

  @override
  String get yogaBenefits => 'Laabh';

  @override
  String get yogaSupportingPlanets => 'Sahayak Grah';

  @override
  String get yogaRanking => 'Top 5 Prabal Yog';

  @override
  String get yogaExplain => 'Mere Yog Samjhaein';

  @override
  String get yogaExplainSubtitle => 'Aapke yog aapki kaise madad karte hain';

  @override
  String get yogaNoneActive => 'Abhi koi sakriya yog nahi';

  @override
  String get yogaNoneInCategory => 'Is shreni mein koi yog nahi';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return 'Aapki kundli mein $count sakriya yog hain — sahayak grah sanyojan. $planets se jude sanyojan growth aur success ke liye khaas taur par madadgar prabhav banate hain.';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '$name $areas ko support karta hai, aur jab iske grah dasha ya transit mein sakriya hote hain to iske fayde aur badh jaate hain.';
  }

  @override
  String get yogaAiGeneric =>
      'Yeh yog aapki kundli mein ek sahayak sanyojan hai jo jeevan ke sambandhit kshetron ko majboot karta hai.';

  @override
  String get yogaExplainReassure =>
      'Yog aapki kundli ke ujjwal pehlu hain — sahayak grah sanyojan jo aapke favour mein kaam karte hain. Jo zyada prabal hote hain wo lasting fayda dete hain, khaaskar unhe banane wale grahon ki period ke dauran.';

  @override
  String get doshSevere => 'Gambhir';

  @override
  String get doshVeryMild => 'Bahut Halka';

  @override
  String get doshLow => 'Nimn';

  @override
  String get doshHigh => 'Uchch';

  @override
  String get doshCritical => 'Ati Gambhir';

  @override
  String get doshSummaryTitle => 'Dosh Saaraansh';

  @override
  String get doshActiveDoshas => 'Sakriya Dosh';

  @override
  String get doshTotalChecked => 'Kul Jaanche Gaye';

  @override
  String get doshOverallSeverity => 'Samagra Gambhirta';

  @override
  String get doshNoneActive => 'Koi sakriya dosh nahi — shuddh kundli!';

  @override
  String get doshCategory => 'Shreni';

  @override
  String get doshConfidence => 'Confidence';

  @override
  String get doshWhyFormed => 'Yeh Kyon Bana';

  @override
  String get doshAffectedAreas => 'Prabhaavit Kshetra';

  @override
  String get doshTimeline => 'Timeline';

  @override
  String get doshDefinition => 'Paribhasha';

  @override
  String get doshFormationRule => 'Nirmaan Niyam';

  @override
  String get doshSupportingPlanets => 'Sambandhit Grah';

  @override
  String get doshCancellation => 'Nivaran Yog';

  @override
  String get doshNoCancellation => 'Koi Nahi';

  @override
  String get doshAreaChildren => 'Santaan';

  @override
  String get doshAreaMind => 'Man';

  @override
  String get remMantra => 'Mantra';

  @override
  String get remGemstone => 'Ratna';

  @override
  String get remDonation => 'Daan';

  @override
  String get remTemple => 'Mandir';

  @override
  String get remFasting => 'Vrat';

  @override
  String get remLifestyle => 'Jeevanshaili';

  @override
  String get remLifestyleGeneric =>
      'Is grah se judi kritagyata, anushasan aur daan ka abhyas karein, aur achha aacharan banaye rakhein.';

  @override
  String get doshExplain => 'Mere Dosh Samjhaein';

  @override
  String get doshExplainSubtitle =>
      'Aapke doshon par ek shaant, vyavaharik nazar';

  @override
  String get doshExplainReassure =>
      'Dosh aam hain — lagbhag har kundli mein kuch na kuch hote hain. Ye swabhav dikhate hain, tay bhagya nahi. Jaagrukta, achhe aacharan aur saral upayon se inka vyavaharik prabhav kam ho jaata hai, isliye chinta ki koi baat nahi hai.';

  @override
  String get doshAiGeneric =>
      'Yeh dosh aapki kundli mein ek pravritti dikhata hai. Iska vyavaharik prabhav aam taur par halka hota hai aur jaagrukta va saral upayon se santulit kiya ja sakta hai.';

  @override
  String doshHeroSummary(Object active, Object total) {
    return 'Aapki kundli mein $total mein se $active sakriya dosh dikhte hain. Adhikansh halke hain aur sirf kuch par dhyan dene ki zaroorat hai. Samajh aur saral upayon se inka vyavaharik prabhav kam kiya ja sakta hai.';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return 'Yeh dosh mukhyatah $areas ko prabhavit karta hai. $planet ki avadhi ke dauran iska prabhav adhik mehsoos ho sakta hai, aur upay ise santulit karne mein madad karte hain.';
  }

  @override
  String doshTimelineLine(Object planet) {
    return 'Iska prabhav $planet ki Mahadasha aur Antardasha ke dauran, aur gochar mein $planet ke sakriya hone par sabse adhik mehsoos hota hai.';
  }

  @override
  String get sbLegendary => 'Legendary';

  @override
  String get sbSthana => 'Sthana Bala';

  @override
  String get sbDig => 'Dig Bala';

  @override
  String get sbKala => 'Kala Bala';

  @override
  String get sbChesta => 'Chesta Bala';

  @override
  String get sbNaisargika => 'Naisargika Bala';

  @override
  String get sbDrik => 'Drik Bala';

  @override
  String get sbSummary => 'Grah Bal Saaraansh';

  @override
  String get sbAverageStrength => 'Ausat Bal';

  @override
  String get sbHighestRupa => 'Sarvadhik Rupa';

  @override
  String get sbRupa => 'Rupa';

  @override
  String get sbRanking => 'Grah Ranking';

  @override
  String get sbRequired => 'Aavashyak';

  @override
  String get sbExcess => 'Adhishesh';

  @override
  String get sbDeficit => 'Kami';

  @override
  String get sbTotalShadbala => 'Kul Shadbala';

  @override
  String get sbExplain => 'Mera Grah Bal Samjhaein';

  @override
  String get sbExplainSubtitle => 'Aapke grahon ke bal ka saral saaraansh';

  @override
  String get sbInfoTitle => 'Shadbala Ko Samjhein';

  @override
  String get sbQWhatIs => 'Shadbala kya hai?';

  @override
  String get sbQRupas => 'Rupa kya hain?';

  @override
  String get sbQHowCalc => 'Bal ki ganana kaise hoti hai?';

  @override
  String get sbQHowUse => 'Iska upyog kaise karein';

  @override
  String get sbWhyStrong => 'Kyon Mazboot';

  @override
  String get sbWhyWeak => 'Kyon Kamzor';

  @override
  String get sbDuringMahadasha => 'Mahadasha ke dauraan';

  @override
  String get sbEffects => 'Prabhaav';

  @override
  String get sbLifeAreas => 'Jeevan Kshetra';

  @override
  String get sbPlanetDetails => 'Grah Vivaran';

  @override
  String get sbBodyWhatIs =>
      'Shadbala (\'chhah guna bal\') mapta hai ki har grah mein apne parinam dene ki kitni shakti hai, chhah swatantra bal sroton ko jodkar.';

  @override
  String get sbBodyRupas =>
      'Bal Rupa mein mapa jata hai (1 Rupa = 60 Virupa). Majboot mane jaane ke liye har grah ko nyuntam Rupa bal chahiye; adhik Rupa ka matlab hai ki wah apne parinam adhik purnata se deta hai.';

  @override
  String get sbBodyHowCalc =>
      'Chhah bal jode jaate hain: Sthana (sthiti se sambandhit), Dig (disha se sambandhit), Kala (samay se sambandhit), Chesta (gati se sambandhit), Naisargika (prakritik) aur Drik (drishti se sambandhit). Kul ki tulna grah ki avashyak nyuntam seema se karke pratishat prapt kiya jata hai.';

  @override
  String get sbBodyHowUse =>
      '100% se upar wala grah apne karakatva sahajta se deta hai; 100% se neeche hone par sahayata ki zaroorat hoti hai. Mahatvapurn maamlon ke liye apne sabse majboot grahon ko prathamikta dein, aur sabse kamzor grahon ko upay aur dhairya dein.';

  @override
  String get sbRemedyStrong =>
      'Achhi tarah se samarthit — kisi khaas upay ki zaroorat nahi; aap is grah ki avadhiyon ka aatmavishwas se upyog kar sakte hain.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '$strongP aapka sabse majboot grah hai, jo $strongTrait ke liye utkrisht sahyog deta hai. $weakP sabse kamzor hai aur upayon se sabse zyada labhaanvit hota hai.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '$planet ka Shadbala $category hai, isliye iske $karakatva tadanusaar samarthit hain.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return '$bala ke madhyam se sabse majboot ($rupa Rupa).';
  }

  @override
  String sbWeakLine(Object bala) {
    return '$bala mein sabse kamzor, jo kul ko kam karta hai.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return '$planet ki Mahadasha ke dauraan, iske $karak saamne aate hain.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'Majboot Shadbala ke saath, $karak swabhavik roop se samarthit hote hain.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'Saadharan Shadbala ke saath, $karak ko sachet prayaas ki zaroorat ho sakti hai.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return '$planet ko iske mantra, ratna ya daan ke madhyam se majboot karein, aur iski avadhiyon ke dauraan dhairyapoorvak kaary karein.';
  }

  @override
  String get bhOverview => 'Avlokan';

  @override
  String get bhDetailed => 'Vistrit';

  @override
  String get bhavaHouses => 'Bhaav';

  @override
  String get bhStrengthOverview => 'Bhaav Shakti Avlokan';

  @override
  String get bhOverallAverage => 'Samagra Bhaav Ausat';

  @override
  String get bhStrongestHouse => 'Sabse Mazboot Bhaav';

  @override
  String get bhWeakestHouse => 'Sabse Kamzor Bhaav';

  @override
  String get bhBestArea => 'Best Jeevan Kshetra';

  @override
  String get bhNeedsAttention => 'Dhyan Dene Yogya';

  @override
  String get bhSavContribution => 'SAV Yogdaan';

  @override
  String get bhLordCondition => 'Bhaavesh ki Sthiti';

  @override
  String get bhBenefic => 'Shubh Prabhaav';

  @override
  String get bhMalefic => 'Ashubh Prabhaav';

  @override
  String get bhStrengthReasons => 'Yeh Score Kyon';

  @override
  String get bhGoodEffects => 'Acche Prabhaav';

  @override
  String get bhChallenges => 'Chunautiyan';

  @override
  String get bhRemedies => 'Upay';

  @override
  String get bhRanking => 'Bhaav Ranking';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'Mere Bhaav Samjhaein';

  @override
  String get bhExplainSubtitle => 'Aapke 12 bhaavon ka saral saaraansh';

  @override
  String bhHeroSummary(
    Object s1,
    Object s2,
    Object strongArea,
    Object weakArea,
  ) {
    return 'Aapke sabse mazboot bhaav $s1 aur $s2 hain. $strongArea swaabhaavik roop se mazboot hai, jabki $weakArea ko zyada mehnat ki zaroorat hai.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'Iska swami $lord $relation ke roop mein sthit hai.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'Is bhaav mein $sav shubh points (SAV) hain; isme baithe grah aur unki drishtiyan baaki score tay karti hain.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'Jab yeh mazboot hota hai, toh yeh $meaning ko support karta hai.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'Jab yeh kamzor hota hai, toh $meaning ke liye extra mehnat aur dhyan ki zaroorat ho sakti hai.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'Ise mazboot banane ke liye iske swami $lord ko bal dein aur is bhaav ke vishayon ka samman karein.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'Aapka $house $strengthWord hai. Yeh $meaning ko govern karta hai.';
  }

  @override
  String get kunNavamsa => 'Navamsa (D9)';

  @override
  String get kunD10 => 'Dasamsa (D10)';

  @override
  String get kunPlacement => 'Grah Sthiti';

  @override
  String get kunHousesTitle => 'Bhaav Vivaran';

  @override
  String get kunPlanet => 'Grah';

  @override
  String get kunNakshatra => 'Nakshatra';

  @override
  String get kunPada => 'Pad';

  @override
  String get kunLord => 'Swami';

  @override
  String get kunExplain => 'Meri Kundli Samjhaein';

  @override
  String get kunExplainSubtitle => 'Aapki kundli ka saral saaraansh';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return '$ordinal bhaav $meaning ko niyantrit karta hai.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return 'Yahaan sthit $planets iske parinaamon ko aakar dete hain.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'Aapka lagna $asc hai, jo aapke drishtikon aur doosron ki aapke baare mein pehli dhaarna ko aakar deta hai.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'Aapka mann aur bhavnayein $moon mein sthit Chandrama ka anusaran karti hain.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '$planet aapka sabse majboot grah hai — sehajta aur sahyog ka swaabhavik kshetra.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '$planet aapka sabse chunauti-poorn grah hai — yahaan dhairya aur prayaas fal dete hain.';
  }

  @override
  String get plNature => 'Prakriti';

  @override
  String get plElement => 'Tatva';

  @override
  String get plGender => 'Ling';

  @override
  String get plKarakatva => 'Karakatva';

  @override
  String get plLordship => 'Swamitva';

  @override
  String get plStrength => 'Shakti';

  @override
  String get plAspectsGiven => 'Di Gayi Drishti';

  @override
  String get plAspectsReceived => 'Praapt Drishti';

  @override
  String get plConjunction => 'Yuti';

  @override
  String get plHouseMeaning => 'Bhaav ka Arth';

  @override
  String get plNakshatraMeaning => 'Nakshatra ka Arth';

  @override
  String get plAiInterpretation => 'AI Vyakhya';

  @override
  String get plSearchHint => 'Koi bhi grah khojein';

  @override
  String get plNoResults => 'Koi grah nahi mila';

  @override
  String get plBenefic => 'Shubh';

  @override
  String get plMalefic => 'Ashubh';

  @override
  String get plMale => 'Purush';

  @override
  String get plFemale => 'Stri';

  @override
  String get plNeutralGender => 'Napunsak';

  @override
  String get plOwnSign => 'Sva Rashi';

  @override
  String get plFriend => 'Mitra Rashi';

  @override
  String get plEnemy => 'Shatru Rashi';

  @override
  String get plNeutral => 'Sam';

  @override
  String get sumEther => 'Akash';

  @override
  String plLordOfHouses(Object houses) {
    return 'Bhav $houses ke Swami';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return '$nakLord dwara shasit, jo $trait laata hai.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '$planet, $sign rashi mein, $house bhav mein sthit hai.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'Iske mukhya karakatva — $karak — yahaan achhi tarah samarthit hain.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'Iske mukhya karakatva — $karak — ko yahaan sachet prayaas ki zaroorat ho sakti hai.';
  }

  @override
  String plAiExalted(Object planet) {
    return '$planet uchcha ka hai, jo apne sarvashreshtha parinaam deta hai.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '$planet neech ka hai aur apne parinaam dene ke liye sahaare ki zaroorat hai.';
  }

  @override
  String plAiCombust(Object planet) {
    return '$planet ast hai, isliye yah Surya ki teevrata mein kam khulkar kaam karta hai.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '$planet vargottama hai — yah majboot sthiti navamsa mein bhi doharaayi jaati hai.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '$planet vakri hai, jo apni urja ko bheetar ki ore modkar use teevra karta hai.';
  }

  @override
  String get plHouse1 => 'Swa, sharir, vyaktitva aur jeevanshakti';

  @override
  String get plHouse2 => 'Dhan, parivaar, vaani aur bhojan';

  @override
  String get plHouse3 => 'Saahas, bhai-behen, sanchaar aur choti yatraayein';

  @override
  String get plHouse4 =>
      'Ghar, maata, sukh-suvidha, sampatti aur aantarik shaanti';

  @override
  String get plHouse5 => 'Santaan, rachnaatmakta, buddhi, prem aur poorv punya';

  @override
  String get plHouse6 => 'Swasthya, shatru, rin, seva aur dainik kaarya';

  @override
  String get plHouse7 => 'Vivaah, saajhedari aur vyavsayik sambandh';

  @override
  String get plHouse8 => 'Aayu, parivartan, rahasya aur virasat';

  @override
  String get plHouse9 => 'Bhagya, dharma, uchch shiksha, guru aur pita';

  @override
  String get plHouse10 => 'Career, pratishtha, adhikaar aur saarvajanik karma';

  @override
  String get plHouse11 => 'Laabh, aay, mitra, network aur poorn ichchhayein';

  @override
  String get plHouse12 => 'Haani, vyay, videsh, aadhyatmikta aur moksha';

  @override
  String get sumVeryStrong => 'Bahut Mazboot';

  @override
  String get sumStrong => 'Mazboot';

  @override
  String get sumAverage => 'Ausat';

  @override
  String get sumWeak => 'Kamzor';

  @override
  String get sumNeedsAttention => 'Dhyan Dene Yogya';

  @override
  String get sumFire => 'Agni';

  @override
  String get sumEarth => 'Prithvi';

  @override
  String get sumAir => 'Vayu';

  @override
  String get sumWater => 'Jal';

  @override
  String get sumMovable => 'Char';

  @override
  String get sumFixed => 'Sthir';

  @override
  String get sumDual => 'Dwiswabhav';

  @override
  String get sumDirEast => 'Purva';

  @override
  String get sumDirWest => 'Paschim';

  @override
  String get sumDirNorth => 'Uttar';

  @override
  String get sumDirSouth => 'Dakshin';

  @override
  String get sumDirNE => 'Uttar-Purva';

  @override
  String get sumDirNW => 'Uttar-Paschim';

  @override
  String get sumDirSE => 'Dakshin-Purva';

  @override
  String get sumDirSW => 'Dakshin-Paschim';

  @override
  String get sumSnapshotTitle => 'Aapki Jyotish Jhalak';

  @override
  String get sumMahadasha => 'Mahadasha';

  @override
  String get sumAntardasha => 'Antardasha';

  @override
  String get sumNakshatra => 'Janma Nakshatra';

  @override
  String get sumElement => 'Tatva';

  @override
  String get sumModality => 'Swabhav';

  @override
  String get sumLuckyDirection => 'Shubh Disha';

  @override
  String get sumHighlights => 'Mukhya Bindu';

  @override
  String get sumStrongPlanet => 'Sabse Mazboot Grah';

  @override
  String get sumWeakPlanet => 'Sabse Kamzor Grah';

  @override
  String get sumYogas => 'Yog';

  @override
  String get sumDoshas => 'Dosh';

  @override
  String get sumRetrograde => 'Vakri';

  @override
  String get sumCombust => 'Ast';

  @override
  String get sumExalted => 'Uchcha';

  @override
  String get sumDebilitated => 'Neech';

  @override
  String get sumVargottama => 'Vargottam';

  @override
  String get sumQuickInsights => 'Twarit Jankari';

  @override
  String get sumSpirituality => 'Aadhyatm';

  @override
  String get sumTimezone => 'Time Zone';

  @override
  String get sumAyanamsa => 'Ayanamsha';

  @override
  String get sumCalendarType => 'Panchang';

  @override
  String get sumCopied => 'Clipboard par copy ho gaya';

  @override
  String get sumNatureFire =>
      'Aapka swabhav saahsi, urjavaan aur agrani hai, jo aage badhkar netritva karta hai.';

  @override
  String get sumNatureEarth =>
      'Aapka swabhav vyavaharik, sthir aur anushasit hai, jo sthayi parinaam banata hai.';

  @override
  String get sumNatureAir =>
      'Aapka swabhav jigyasu, samvadpriya aur bauddhik hai, jo naye vicharon mein phalta-phoolta hai.';

  @override
  String get sumNatureWater =>
      'Aapka swabhav sahaj-bodhi, bhavnatmak aur sahanubhutipurn hai, gehri aantarik samvedansheelta ke saath.';

  @override
  String get sumGradePhraseExcellent =>
      'Mazbooti se samarthit — nirantar prayaas se anukool parinaam milne ki sambhavna hai.';

  @override
  String get sumGradePhraseGood =>
      'Achhi tarah samarthit — thodi savdhani ke saath samanyatah sakaratmak.';

  @override
  String get sumGradePhraseAverage =>
      'Mishrit samarthan — parinaam prayaas aur samay par nirbhar karte hain.';

  @override
  String get sumGradePhraseWeak =>
      'Dhyan dene yogya — dhairya aur upaay yahan madad karte hain.';

  @override
  String get kDefCombust =>
      'Surya ke bahut nikat sthit grah, jisse uski urja \'jal\' kar kamzor ho jaati hai.';

  @override
  String get kDefRetrograde =>
      'Peechhe ki or chalta prateet hone wala grah; iske prabhav bheetar ki or mudkar teevra ho jaate hain.';

  @override
  String get kDefNakshatra =>
      '27 nakshatra mandalon mein se ek, jinse Chandrama aur grah guzarte hain.';

  @override
  String get kDefVargottama =>
      'Janma kundli (D1) aur navansh (D9) dono mein ek hi raashi mein sthit grah — shakti ka prateek.';

  @override
  String get kDefOwnSign =>
      'Apni khud ki raashi mein baitha grah, jahan wo ghar jaisa mehsoos karta hai aur sthir parinaam deta hai.';

  @override
  String get kDefExalted =>
      'Apni sarvochcha shakti ki raashi mein sthit grah, jo apne sarvashreshtha parinaam deta hai.';

  @override
  String get kDefDebilitated =>
      'Apni sabse kamzor raashi mein sthit grah, jahan wo parinaam dene mein sangharsh karta hai.';

  @override
  String get kDefMooltrikona =>
      'Grah ki apni raashi ka ek vishesh bhaag, jahan wo vishesh roop se shaktishaali hota hai.';

  @override
  String get kDefAscendant =>
      'Janma ke samay purvi kshitij par udit hone wali raashi — Lagna, kundli ki neenv.';

  @override
  String get kDefMahadasha =>
      'Jeevan ki ek lambi avadhi ko rang dene wala pramukh grah kaal.';

  @override
  String get kDefAntardasha =>
      'Mahadasha ke bheetar ek upa-avadhi, jo iske parinaamon ko sookshmata se samayojit karti hai.';

  @override
  String get kDefPada =>
      'Grah jis nakshatra mein sthit hai, uske chaar charanon mein se ek.';

  @override
  String get aspGivesAspectTo => 'Drishti Daalta Hai';

  @override
  String get aspReceivesAspectFrom => 'Drishti Praapt Karta Hai';

  @override
  String get aspInfluences => 'Prabhaavit Karta Hai';

  @override
  String get aspNoInfluence => 'Koi Prabhaav Nahi';

  @override
  String get aspNoAspect => 'Koi Drishti Nahi';

  @override
  String get aspPresent => 'Present';

  @override
  String get aspAbsent => 'Absent';

  @override
  String get aspNotPresent => 'Present Nahi';

  @override
  String get aspSpecialAspect => 'Vishesh Drishti';

  @override
  String get aspAspectWord => 'Drishti';

  @override
  String get aspTotalGiven => 'Di Gayi Drishti';

  @override
  String get aspTotalReceived => 'Praapt Drishti';

  @override
  String get aspStrongestInfluence => 'Sabse Prabal Prabhaav';

  @override
  String get aspMedium => 'Madhyam';

  @override
  String get aspAspectPresent => 'Drishti Present';

  @override
  String get aspReason => 'Kaaran';

  @override
  String get aspBoth => 'Dono';

  @override
  String get aspTargetHouse => 'Target Bhaav';

  @override
  String get aspTargetSign => 'Target Rashi';

  @override
  String get aspLagnaReceives => 'Lagna Ko Drishti Milti Hai';

  @override
  String get aspNoAspectFrom => 'Inse Koi Drishti Nahi';

  @override
  String get aspPlanetToPlanet => 'Grah Se Grah';

  @override
  String get aspSignToSign => 'Rashi Se Rashi';

  @override
  String get aspCombinedAspect => 'Sanyukt Drishti';

  @override
  String get aspGrahaAspect => 'Grah Drishti';

  @override
  String get aspRashiAspect => 'Rashi Drishti';

  @override
  String get aspInfoTitle => 'Drishti Ko Samjhein';

  @override
  String get aspQGraha => 'Grah Drishti kya hai?';

  @override
  String get aspQRashi => 'Rashi Drishti kya hai?';

  @override
  String get aspQDiff => 'Dono mein antar';

  @override
  String get aspQPredict => 'Drishti prediction ko kaise prabhaavit karti hai';

  @override
  String get aspGrahaBody =>
      'Grah Drishti woh prabhaav hai jo ek grah apni sthiti se daalta hai. Har grah apne sthaan se 7ve bhaav/grah par poorn drishti daalta hai (ek seedha, aamne-saamne ka prabhaav). Iske alawa, Mangal 4the aur 8ve par, Guru 5ve aur 9ve par, aur Shani 3re aur 10ve par drishti daalta hai. Rahu aur Ketu ko aksar 5vi, 7vi aur 9vi drishti di jaati hai. Kisi grah ki drishti us grah ya bhaav ko apne swabhav ke rang mein rang deti hai.';

  @override
  String get aspRashiBody =>
      'Rashi Drishti Jaimini jyotish ki ek rashi-se-rashi drishti hai, jo is baat par nirbhar nahi karti ki wahan kaunse grah baithe hain. Char rashiyan sthir rashiyon par drishti daalti hain (paas wali ko chhodkar), sthir rashiyan char rashiyon par drishti daalti hain (paas wali ko chhodkar), aur dwiswabhav rashiyan doosri dwiswabhav rashiyon par drishti daalti hain. Iska upyog mukhya roop se Jaimini prediction aur bhaavon ke beech sambandh aankne mein hota hai.';

  @override
  String get aspDiffBody =>
      'Grah Drishti ek grah dwara daali jaati hai aur is baat par nirbhar karti hai ki woh grah kahan sthit hai. Rashi Drishti khud rashi ki hoti hai aur usmein jo bhi sthit ho, us par lagu hoti hai. Grah Drishti directional hoti hai (grah A grah B ko dekhta hai), jabki Rashi Drishti aksar rashiyon ke beech mutual hoti hai. Jab dono ek hi target ki taraf ishara karte hain, tab prabhaav khaas taur par prabal hota hai.';

  @override
  String get aspPredictBody =>
      'Drishti yeh dikhati hai ki ek grah apne bhaav se aage apna prabhaav kahan tak failata hai. Ek shubh drishti (Guru, Shukra, achhi sthiti mein Chandra/Budh) target ko support aur suraksha deti hai; ek ashubh drishti (Shani, Mangal, Surya, Rahu, Ketu) us par dabaav daal sakti hai, deri kar sakti hai ya challenge kar sakti hai. Yeh padhna ki kaunse grah kisi bhaav ya grah par drishti daalte hain, yeh samjhata hai ki result jis tarah se saamne aate hain, waise kyun aate hain.';

  @override
  String get aspTraitSun => 'adhikar, netritva aur jeevan-shakti';

  @override
  String get aspTraitMoon => 'bhaavnatmak gehrai, sukh aur antargyaan';

  @override
  String get aspTraitMars => 'urja, saahas aur josh';

  @override
  String get aspTraitMercury => 'sanchaar, buddhi aur anukoolan-sheelta';

  @override
  String get aspTraitJupiter => 'gyaan, vikas aur saubhagya';

  @override
  String get aspTraitVenus => 'prem, saamanjasya aur sukh-suvidhayein';

  @override
  String get aspTraitSaturn =>
      'anushasan, zimmedari aur dhairyapoorn, kabhi-kabhi vilambit, safalta';

  @override
  String get aspTraitRahu => 'mahatvakanksha, tivrata aur aparampragat modh';

  @override
  String get aspTraitKetu => 'virakti, adhyatmikta aur achanak parivartan';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '$planet $targets ko prabhaavit kar raha hai. Isse in grahon dwara darshaye gaye kshetron mein $trait aa sakta hai.';
  }

  @override
  String aspAiNone(Object planet) {
    return '$planet yahan kisi aur grah par vishesh drishti nahi daalta; iska prabhaav mukhyatah apni hi rashi aur bhaav ke madhyam se kaam karta hai.';
  }

  @override
  String get avSummaryTitle => 'Ashtakavarga Saaraansh';

  @override
  String get avOverallScore => 'Overall SAV Score';

  @override
  String get avOverallRating => 'Samagra Rating';

  @override
  String get avStrongestSigns => 'Sabse Mazboot Rashiyan';

  @override
  String get avWeakestSigns => 'Sabse Kamzor Rashiyan';

  @override
  String get avScore => 'Score';

  @override
  String get avMeaning => 'Matlab';

  @override
  String get avGrid => 'Grid';

  @override
  String get avList => 'List';

  @override
  String get avOverallScoreShort => 'Overall Score';

  @override
  String get avNatalSignScore => 'Janma Rashi Score';

  @override
  String get avBestSigns => 'Best Rashiyan';

  @override
  String get avWeakSigns => 'Kamzor Rashiyan';

  @override
  String get avAiInterpretation => 'AI Vyakhya';

  @override
  String get avVeryGood => 'Bahut Accha';

  @override
  String get avVeryWeak => 'Bahut Kamzor';

  @override
  String get avTotalSav => 'Total SAV';

  @override
  String get avPlanetContributions => 'Grah Yogdaan';

  @override
  String get avFinance => 'Vitt';

  @override
  String get avOverallStrength => 'Samagra Shakti';

  @override
  String get avWhatDoesThisMean => 'Iska kya matlab hai?';

  @override
  String get avSimple => 'Simple';

  @override
  String get avAdvanced => 'Advanced';

  @override
  String get avInfoTitle => 'Ashtakavarga Ko Samjhein';

  @override
  String get avStrong => 'Mazboot';

  @override
  String get avModerate => 'Madhyam';

  @override
  String get avQWhatIsAv => 'Ashtakavarga kya hai?';

  @override
  String get avQWhatIsSav => 'SAV kya hai?';

  @override
  String get avQWhatIsBav => 'BAV kya hai?';

  @override
  String get avQHowToRead => 'In scores ko kaise padhein';

  @override
  String get avQSavVsBav => 'SAV vs BAV';

  @override
  String get avABody =>
      'Ashtakavarga Vedic astrology mein points par based ek strength system hai. Har planet apni position ke hisaab se barah rashiyon ko benefic points (bindus, jinhe rekha bhi kehte hain) deta hai. Kisi rashi mein jitne zyada points honge, related planetary dasha aur transit ke dauraan life ka wo area utna hi smooth support paayega.';

  @override
  String get avSavBody =>
      'SAV (Sarva Ashtakavarga) saaton planets ke points ko har rashi ke liye jod deta hai. Ye har rashi ke liye ek hi strength score deta hai, jisse aap jaldi dekh sakte hain ki aapki chart mein kaunsi rashiyan — aur unke houses — sabse zyada supported hain.';

  @override
  String get avBavBody =>
      'BAV (Bhinna Ashtakavarga) ek single planet ke points ko barah rashiyon mein dikhata hai. Ye batata hai ki koi specific planet kaunsi rashiyon ko sabse zyada support karta hai, jo tab important hota hai jab us planet ki dasha ya transit active ho.';

  @override
  String get avHowToReadBody =>
      'Zyada number better hote hain. SAV ke liye, average rashi lagbhag 28 points score karti hai — 30 se upar strong hai aur 25 se neeche care ki zaroorat hai. BAV ke liye, har rashi 0 se 8 ke beech hoti hai, jisme 4 average maana jaata hai. Important kaamon ke liye apni strongest rashiyon ko favour karein, aur weakest rashiyon ke matters mein patience aur discipline rakhein.';

  @override
  String get avSavVsBavBody =>
      'SAV saare planets ka combined total hai aur ek rashi ki overall strength dikhata hai. BAV ek single planet ka contribution hai aur batata hai ki kaunsa planet us rashi ko support karta hai. Big picture samajhne ke liye SAV use karein, aur ye jaanne ke liye ki kaunsa planet rashi ki strength drive karta hai, BAV dekhein.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'Aapki chart $s1, $s2 aur $s3 mein sabse strong hai. Ye rashiyan planetary periods aur transits ke dauraan better support deti hain. $weak mein abhi sabse kam support hai, isliye isse jude matters mein patience aur discipline madad karega.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '$planet $s1 aur $s2 ke through sabse strong perform karta hai. Jab ye rashiyan activate hoti hain, tab $planet se related matters improve hote hain.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'Aapki strongest rashiyan $s1 aur $s2 hain — jab planets inhe transit karein tab important beginnings ke liye inhe favour karein.';
  }

  @override
  String avInsightWeak(Object s1) {
    return '$s1 mein sabse kam support hai — iske matters mein carefully aage badhein aur zyada commitment se bachein.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '$planet ke paas sabse zyada points hain, isliye iske significations aapki life mein achhi tarah supported hain.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '$planet ke paas sabse kam points hain aur remedies aur conscious effort se sabse zyada benefit paata hai.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'Jo rashiyan aapke average $avg points se upar score karti hain, wo aam taur par smoother aur zyada reliable results deti hain.';
  }

  @override
  String get fcKey => 'Key';

  @override
  String get fcActions => 'Actions';

  @override
  String get fcCautions => 'Savdhaaniyan';

  @override
  String get fc12House => '12 Bhav';

  @override
  String get fcProbabilities => 'Sambhavnaayein';

  @override
  String get fcHousesCaps => 'BHAV';

  @override
  String get fcCritical => 'Critical';

  @override
  String get fcFlags => 'Flags';

  @override
  String get fcAnalysis => 'Analysis';

  @override
  String get fcConfidence => 'Confidence';

  @override
  String get fcQualityCaps => 'QUALITY';

  @override
  String get fcIncomeVs => 'Income vs';

  @override
  String get fcExpense => 'Expense';

  @override
  String get fcFinance => 'FINANCE';

  @override
  String get fcNetBalance => 'Net Balance';

  @override
  String get fcSignature => 'Signature';

  @override
  String get fcBestTimeForIncome => 'Income ke liye Best Time';

  @override
  String get fcExpenseCaution => 'Expense Caution';

  @override
  String get fcIncomeCaps => 'INCOME';

  @override
  String get fcExpenseCaps => 'EXPENSE';

  @override
  String get fcRelationships => 'Rishtey';

  @override
  String get fcAreasCaps => 'AREAS';

  @override
  String get fcBestForMeetings => 'Meetings ke liye Best';

  @override
  String get fcOpportunitiesVs => 'Opportunities vs';

  @override
  String get fcRisks => 'Risks';

  @override
  String get fcOutlook => 'OUTLOOK';

  @override
  String get fcAction => 'Action';

  @override
  String get fcProtect => 'Suraksha';

  @override
  String get fcOpportunityCaps => 'OPPORTUNITY';

  @override
  String get fcRiskCaps => 'RISK';

  @override
  String get fcTopOpportunities => 'TOP OPPORTUNITIES';

  @override
  String get fcTopRisks => 'TOP RISKS';

  @override
  String get fcTiming => 'Timing';

  @override
  String get fcWindows => 'Windows';

  @override
  String get fcSlotsCaps => 'SLOTS';

  @override
  String get fcBestWindows => 'BEST WINDOWS';

  @override
  String get fcWorstWindows => 'WORST WINDOWS';

  @override
  String get fcAvoid => 'Avoid Karein';

  @override
  String get fcHouse => 'Bhav';

  @override
  String get fcFailed => 'Fail';

  @override
  String get lifeCareer => 'Career';

  @override
  String get lifeHealth => 'Health';

  @override
  String get lifeWealth => 'Dhan';

  @override
  String get lifeFamily => 'Parivar';

  @override
  String get lifeMind => 'Man';

  @override
  String get lifeEgo => 'Ahankar';

  @override
  String get lifeAggression => 'Aggression';

  @override
  String get lifeConflict => 'Conflict';

  @override
  String get rashiElement => 'Tatva';

  @override
  String get rashiQuality => 'Gun';

  @override
  String get rashiLuckyColor => 'Lucky Color';

  @override
  String get rashiLuckyDay => 'Lucky Din';

  @override
  String get rashiLuckyNumber => 'Lucky Number';

  @override
  String get rashiGemstone => 'Ratna';

  @override
  String get rashiBody => 'Body';

  @override
  String get gocharTodaysTransitChart => 'Aaj ka Transit Chart';

  @override
  String get gocharTransit => 'Transit';

  @override
  String get thisWeek => 'Is Hafte';

  @override
  String get thisMonth => 'Is Mahine';

  @override
  String get best => 'Best';

  @override
  String get worst => 'Worst';

  @override
  String get avg => 'avg';

  @override
  String get favorableLoveWindowsLabel => 'Favorable Love Windows';

  @override
  String get lordLabel => 'Swami';

  @override
  String get lordPlacementLabel => 'Swami ki Sthiti';

  @override
  String get lordDignityLabel => 'Swami ki Dignity';

  @override
  String get categoriesSuffix => 'Categories';

  @override
  String get coreBlockerLabel => 'CORE BLOCKER';

  @override
  String get coreGiftLabel => '✦ CORE GIFT';

  @override
  String get coreThemeLabel => '● CORE THEME';

  @override
  String dominantLabel(Object value) {
    return 'Pradhan: $value';
  }

  @override
  String get karakasSuffix => 'Karakas';

  @override
  String get protectiveLabel => 'PROTECTIVE';

  @override
  String secondaryLabel(Object value) {
    return ' · Secondary: $value';
  }

  @override
  String get tagCore => 'CORE';

  @override
  String get debtScoresHeader => '📉 DEBT SCORES';

  @override
  String get debtCurrentLoadStat => 'CURRENT\nDEBT LOAD';

  @override
  String get debtRecoveryCapacityStat => 'RECOVERY\nCAPACITY';

  @override
  String get debtIntensityStat => 'INTENSITY';

  @override
  String get debtDefaultRiskStat => 'DEFAULT RISK';

  @override
  String get debtProfileTitle => 'Debt Profile';

  @override
  String get debtKarmaLabel => 'KARMA';

  @override
  String get debtPersonalityLabel => 'PERSONALITY';

  @override
  String get debtPhaseLabel => 'PHASE';

  @override
  String get debtPrimaryCategoryLabel => 'PRIMARY CATEGORY';

  @override
  String get debtWord => 'Karz';

  @override
  String get debtYogasTitle => 'Debt Yogas';

  @override
  String get debtCreatingLabel => 'KARZ-BADHANE WALE';

  @override
  String get debtClearingLabel => 'KARZ-CHUKANE WALE';

  @override
  String get yearlyDebtTitle => 'Yearly Debt';

  @override
  String get debtRepaymentTitle => 'Repayment';

  @override
  String get debtDangerPeriodsTitle => 'Danger Periods';

  @override
  String get debtDefaultPctStat => 'DEFAULT %';

  @override
  String get debtBankruptcyPctStat => 'BANKRUPTCY %';

  @override
  String get debtChronicPctStat => 'CHRONIC %';

  @override
  String get debtResilienceStat => 'RESILIENCE';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'Recovery: $pct% · Timeline: ${years}saal';
  }

  @override
  String get debtFreeWindowLabel => '🎯 KARZ-MUKT WINDOW';

  @override
  String debtFreeYear(Object year) {
    return 'Saal $year';
  }

  @override
  String get legalScoresHeader => '⚖️ LEGAL SCORES';

  @override
  String get legalVulnerabilityStat => 'LEGAL\nVULNERABILITY';

  @override
  String get legalVictoryPotentialStat => 'VICTORY\nPOTENTIAL';

  @override
  String get legalConflictStat => 'CONFLICT';

  @override
  String get legalResolutionStat => 'RESOLUTION';

  @override
  String get legalProfileTitle => 'Legal Profile';

  @override
  String get legalKarmaTypeLabel => 'KARMA TYPE';

  @override
  String get legalConflictStyleLabel => 'CONFLICT STYLE';

  @override
  String get legalStrategyLabel => 'STRATEGY';

  @override
  String get legalCaseDurationLabel => 'CASE DURATION';

  @override
  String get legalCurrentStatusLabel => 'CURRENT STATUS';

  @override
  String get legalWord => 'Legal';

  @override
  String get legalYogasTitle => 'Legal Yogas';

  @override
  String get legalDisputePressureLabel => 'DISPUTE PRESSURE';

  @override
  String get legalProtectionLabel => 'LEGAL PROTECTION';

  @override
  String get legalStressTrendTitle => 'Legal Stress';

  @override
  String get legalVisibleEnemiesStat => 'SAMNE KE DUSHMAN';

  @override
  String get legalHiddenEnemiesStat => 'CHUPE DUSHMAN';

  @override
  String get legalCriminalRiskStat => 'CRIMINAL RISK';

  @override
  String get legalFalseAccusationStat => 'JHOOTHA AAROP';

  @override
  String get legalContractKarmaTitle => 'Contract Karma';

  @override
  String get legalDocumentationLabel => 'DOCUMENTATION';

  @override
  String get legalFinePrintAwareLabel => 'FINE PRINT AWARE';

  @override
  String get legalNegotiationSkillLabel => 'NEGOTIATION SKILL';

  @override
  String get legalSignatureCautionLabel => 'SIGNATURE CAUTION';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'Resilience: $pct/100';
  }

  @override
  String get legalVictoryWord => 'Jeet';

  @override
  String get legalAnalysisSuffix => 'Analysis';

  @override
  String get legalAsPlaintiff => 'PLAINTIFF KE ROOP MEIN';

  @override
  String get legalAsDefendant => 'DEFENDANT KE ROOP MEIN';

  @override
  String get legalWinProbability => 'JEET KI SAMBHAVNA';

  @override
  String get legalDisputeWord => 'Vivaad';

  @override
  String get lifepathScoresHeader => '🌟 LIFE PATH SCORES';

  @override
  String get lifepathDharmaClarityStat => 'DHARMA\nCLARITY';

  @override
  String get lifepathFortuneBaselineStat => 'FORTUNE\nBASELINE';

  @override
  String get lifepathCoherenceStat => 'LIFE PATH\nCOHERENCE';

  @override
  String get lifepathKarmaStat => 'KARMA';

  @override
  String get lifepathSpiritualStat => 'SPIRITUAL';

  @override
  String get lifepathFameStat => 'FAME';

  @override
  String get lifepathSoulContractTitle => 'Soul Contract';

  @override
  String get lifepathAtmakarakaLabel => 'ATMAKARAKA';

  @override
  String get lifepathAkFocusLabel => 'AK FOCUS';

  @override
  String get lifepathSoulPurposeLabel => 'SOUL PURPOSE';

  @override
  String get lifepathLifeChapterLabel => 'LIFE CHAPTER';

  @override
  String get lifepathPrimaryDomainLabel => 'PRIMARY DOMAIN';

  @override
  String get lifepathLeadershipStat => 'LEADERSHIP';

  @override
  String get lifepathWisdomTeachStat => 'WISDOM/TEACH';

  @override
  String get lifepathServiceStat => 'SEVA';

  @override
  String get lifepathHealingStat => 'HEALING';

  @override
  String get lifepathFortuneYogasTitle => 'Fortune Yogas';

  @override
  String get lifepathLuckBlocksLabel => 'KISMAT KE BLOCKS';

  @override
  String get lifepathFortuneBoostersLabel => 'FORTUNE BOOSTERS';

  @override
  String get lifepathFortuneTrendTitle => 'Fortune Trend';

  @override
  String get lifepathGoldenWindowsTitle => 'Golden Windows ★';

  @override
  String get lifepathTransformationTitle => 'Transformation';

  @override
  String get lifepathMilestonesTitle => 'Life Milestones';

  @override
  String get lifepathKarmicLessonsTitle => 'Karmic Lessons';

  @override
  String get lifepathRahuGrowthLabel => 'RAHU GROWTH';

  @override
  String get lifepathKetuSurrenderLabel => 'KETU SURRENDER';

  @override
  String get lifepathSaturnLessonLabel => 'SHANI LESSON';

  @override
  String get lifepathLifeDifficultyLabel => 'LIFE DIFFICULTY';

  @override
  String get lifepathSoulExperienceTitle => '★ AATMA JO ANUBHAV KARNE AAYI';

  @override
  String get lifepathBlessingsTitle => '● BLESSINGS';

  @override
  String get lifepathLifeWord => 'Jeevan';

  @override
  String get lifepathArchetypeSuffix => 'Archetype';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'Fulfillment: $pct%';
  }

  @override
  String get lifepathDestinyVsWord => 'Bhagya vs';

  @override
  String get lifepathFreeWillSuffix => 'Free Will';

  @override
  String get lifepathDestinyStat => 'BHAGYA';

  @override
  String get lifepathFreeWillStat => 'FREE WILL';

  @override
  String get pastlifeScoresHeader => '🔮 PAST LIFE SCORES';

  @override
  String get pastlifeSignatureStrengthStat => 'SIGNATURE\nSTRENGTH';

  @override
  String get pastlifeCarryForwardStat => 'CARRY-\nFORWARD';

  @override
  String get pastlifeMasteryPreservedStat => 'MASTERY\nPRESERVED';

  @override
  String get pastlifeUnfinishedStat => 'ADHOORA';

  @override
  String get pastlifeKarmicDebtStat => 'KARMIC DEBT';

  @override
  String get pastlifeProfileTitle => 'Past Life Profile';

  @override
  String get pastlifeThemeLabel => 'THEME';

  @override
  String get pastlifeProfessionLabel => 'PROFESSION';

  @override
  String get pastlifeSocialStandingLabel => 'SOCIAL STANDING';

  @override
  String get pastlifeRegionLabel => 'REGION';

  @override
  String get pastlifeSpiritualLevelLabel => 'SPIRITUAL LEVEL';

  @override
  String get pastlifeGenderLabel => 'GENDER';

  @override
  String get pastlifeWealthLevelLabel => 'WEALTH LEVEL';

  @override
  String get pastlifeFamilyRoleLabel => 'FAMILY ROLE';

  @override
  String get pastlifeSkillsCarriedTitle => '★ SAATH LAAYE HUE SKILLS';

  @override
  String get pastlifeNaturalAttractionsTitle => '● NATURAL ATTRACTIONS';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ ANJAAN DAR';

  @override
  String get pastlifeMagneticPullsTitle => '→ MAGNETIC PULLS';

  @override
  String get pastlifeRelationshipStat => 'RELATIONSHIP';

  @override
  String get pastlifeFinancialStat => 'FINANCIAL';

  @override
  String get pastlifeServiceStat => 'SEVA';

  @override
  String get pastlifeDharmicStat => 'DHARMIC';

  @override
  String get pastlifeOnRelationsStat => 'RISHTON PAR';

  @override
  String get pastlifeOnCareerStat => 'CAREER PAR';

  @override
  String get pastlifeOnHealthStat => 'HEALTH PAR';

  @override
  String get pastlifeOnSpiritualStat => 'SPIRITUAL PAR';

  @override
  String get pastlifeKarmicResolutionTitle => 'Karmic Resolution';

  @override
  String get pastlifePrimaryPathLabel => 'PRIMARY PATH';

  @override
  String get pastlifeSecondaryPathLabel => 'SECONDARY PATH';

  @override
  String get pastlifeClearingProgressLabel => 'CLEARING PROGRESS';

  @override
  String get pastlifeRemainingWorkLabel => 'BAAKI KAAM';

  @override
  String get pastlifeDebtTimelineLabel => 'DEBT TIMELINE';

  @override
  String get pastlifeMemoryAccessStat => 'MEMORY ACCESS';

  @override
  String get pastlifeDreamVisitsStat => 'DREAM VISITS';

  @override
  String get pastlifeDejaVuStat => 'DEJA VU';

  @override
  String get pastlifeRegressionFitStat => 'REGRESSION FIT';

  @override
  String get pastlifeActivationTitle => 'Past Life Activation';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'Maturity: $maturity · Status: $status';
  }

  @override
  String get pastlifeKetuWord => 'Ketu';

  @override
  String get pastlifePastMasterySuffix => 'Past Mastery';

  @override
  String get pastlifeKetuMasteredLabel => 'KETU · JO AAPNE MASTER KIYA';

  @override
  String get pastlifeRahuWord => 'Rahu';

  @override
  String get pastlifeFutureGrowthSuffix => 'Future Growth';

  @override
  String get pastlifeRahuPullsLabel => 'RAHU · JO AAPKO AAGE KHEENCHTA HAI';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ Shadow: $shadow';
  }

  @override
  String get mentalScoresHeader => '🧠 MENTAL SCORES';

  @override
  String get mentalStabilityStat => 'MENTAL\nSTABILITY';

  @override
  String get mentalEmotionalBaselineStat => 'EMOTIONAL\nBASELINE';

  @override
  String get mentalResilienceStat => 'RESILIENCE';

  @override
  String get mentalAnxietyStat => 'ANXIETY';

  @override
  String get mentalDepressionStat => 'DEPRESSION';

  @override
  String get mentalRegulationStat => 'REGULATION';

  @override
  String get mentalProfileTitle => 'Mental Profile';

  @override
  String get mentalConstitutionLabel => 'CONSTITUTION';

  @override
  String get mentalStressDriverLabel => 'STRESS DRIVER';

  @override
  String get mentalStabilityAnchorLabel => 'STABILITY ANCHOR';

  @override
  String get mentalStressResponseLabel => 'STRESS RESPONSE';

  @override
  String get mentalAttachmentStyleLabel => 'ATTACHMENT STYLE';

  @override
  String get mentalBurnoutStageLabel => 'BURNOUT STAGE';

  @override
  String get mentalWord => 'Mental';

  @override
  String get mentalYogasTitle => 'Mental Yogas';

  @override
  String get mentalStressPressureLabel => 'STRESS PRESSURE';

  @override
  String get mentalWellnessTrendTitle => 'Wellness Trend';

  @override
  String get mentalHealthyCopingTitle => '✓ HEALTHY COPING';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ UNHEALTHY RISKS';

  @override
  String get mentalRecommendedAlternativesTitle => '✦ RECOMMENDED ALTERNATIVES';

  @override
  String get mentalSleepQualityStat => 'SLEEP QUALITY';

  @override
  String get mentalSocialSupportStat => 'SOCIAL SUPPORT';

  @override
  String get mentalBurnoutVulnStat => 'BURNOUT VULN';

  @override
  String get mentalSelfAwarenessStat => 'SELF-AWARENESS';

  @override
  String get mentalAnxietyWord => 'Anxiety';

  @override
  String get mentalTypesSuffix => 'Types';

  @override
  String get mentalTherapyWord => 'Therapy';

  @override
  String get mentalModalityFitSuffix => 'Modality Fit';

  @override
  String get characterScoresHeader => '🔍 CHARACTER SCORES';

  @override
  String get characterStrengthStat => 'CHARACTER\nSTRENGTH';

  @override
  String get characterIntegrityStat => 'INTEGRITY';

  @override
  String get characterResilienceStat => 'RESILIENCE';

  @override
  String get characterAwarenessStat => 'AWARENESS';

  @override
  String get characterStabilityStat => 'STABILITY';

  @override
  String get characterEthicsStat => 'ETHICS';

  @override
  String get characterSurfacePersonalityTitle => 'Surface Personality';

  @override
  String get characterLagnaLabel => 'LAGNA';

  @override
  String get characterConstitutionLabel => 'CONSTITUTION';

  @override
  String get characterNakshatraLabel => 'NAKSHATRA';

  @override
  String get characterDeityLabel => 'DEVTA';

  @override
  String get characterMoonManasTitle => 'Chandra Manas';

  @override
  String get characterSignLabel => 'RASHI';

  @override
  String get characterHouseLabel => 'BHAAV';

  @override
  String get characterWarmthStat => 'WARMTH';

  @override
  String get characterEmpathyStat => 'EMPATHY';

  @override
  String get characterLoyaltyStat => 'LOYALTY';

  @override
  String get characterBoundariesStat => 'BOUNDARIES';

  @override
  String get characterDharmaStat => 'DHARMA';

  @override
  String get characterTruthStat => 'SATYA';

  @override
  String get characterCompassionStat => 'KARUNA';

  @override
  String get characterGenerosityStat => 'GENEROSITY';

  @override
  String get characterSignatureVirtuesTitle => '★ SIGNATURE VIRTUES';

  @override
  String get characterNaturalTalentsTitle => '● NATURAL TALENTS';

  @override
  String get characterShadowPatternsTitle => '⚠ SHADOW PATTERNS';

  @override
  String get characterYogasTitle => 'Character Yogas';

  @override
  String get characterTestsLabel => 'TESTS';

  @override
  String get characterGiftsLabel => 'GIFTS';

  @override
  String get characterSelfAwareEiStat => 'SELF-AWARE EI';

  @override
  String get characterSelfRegulateStat => 'SELF-REGULATE';

  @override
  String get characterEmpathyEiStat => 'EMPATHY EI';

  @override
  String get characterSocialSkillsStat => 'SOCIAL SKILLS';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'Realization: $pct%';
  }

  @override
  String get characterAtmakarakaWord => 'Atmakaraka';

  @override
  String get characterSoulSignatureSuffix => 'Soul Signature';

  @override
  String get characterAtmakarakaLabel => 'ATMAKARAKA';

  @override
  String get characterGunaWord => 'Guna';

  @override
  String get characterProfileSuffix => 'Profile';

  @override
  String get characterSattvaLabel => 'Sattva';

  @override
  String get characterRajasLabel => 'Rajas';

  @override
  String get characterTamasLabel => 'Tamas';

  @override
  String get healthScoresHeader => '🏥 HEALTH SCORES';

  @override
  String get healthVitalityStat => 'VITALITY';

  @override
  String get healthImmunityStat => 'IMMUNITY';

  @override
  String get healthRecoveryStat => 'RECOVERY';

  @override
  String get healthMentalStat => 'MENTAL';

  @override
  String get healthStressTolStat => 'STRESS TOL';

  @override
  String get healthYogasTitle => 'Health Yogas';

  @override
  String get healthDiseasePressureLabel => 'DISEASE PRESSURE';

  @override
  String get healthTrendTitle => 'Health Trend';

  @override
  String get healthRecoveryWindowsTitle => 'Recovery Windows';

  @override
  String get healthCautionPeriodsTitle => 'Caution Periods';

  @override
  String get healthFertilityStat => 'FERTILITY';

  @override
  String get healthBurnoutRiskStat => 'BURNOUT RISK';

  @override
  String get healthAddictionVulnStat => 'ADDICTION VULN';

  @override
  String get healthWorkLifeBalStat => 'WORK-LIFE BAL';

  @override
  String get healthAyurvedicWord => 'Ayurvedic';

  @override
  String get healthConstitutionSuffix => 'Constitution';

  @override
  String get healthBodyWord => 'Body';

  @override
  String get healthSystemMapSuffix => 'System Map';

  @override
  String get healthBodyZoneWord => 'Body Zone';

  @override
  String get healthVulnerabilitySuffix => 'Vulnerability';

  @override
  String get healthDiseaseWord => 'Rog';

  @override
  String get healthSusceptibilitySuffix => 'Susceptibility';

  @override
  String get healthLifestyleFactorsTitle => 'Lifestyle Factors';

  @override
  String get healthSleepDisciplineLabel => 'SLEEP DISCIPLINE';

  @override
  String get healthDietDisciplineLabel => 'DIET DISCIPLINE';

  @override
  String get healthExerciseNeedLabel => 'EXERCISE NEED';

  @override
  String get healthSunlightNeedLabel => 'SUNLIGHT NEED';

  @override
  String get healthSocialTypeLabel => 'SOCIAL TYPE';

  @override
  String get healthHealingSpeedLabel => 'HEALING SPEED';

  @override
  String get wealthScoresHeader => '💰 WEALTH SCORES';

  @override
  String get wealthStrengthStat => 'WEALTH\nSTRENGTH';

  @override
  String get wealthAccumulationStat => 'ACCUMU-\nLATION';

  @override
  String get wealthIncomeFlowStat => 'INCOME\nFLOW';

  @override
  String get wealthSustainStat => 'SUSTAIN';

  @override
  String get wealthMultiStreamStat => 'MULTI-STREAM';

  @override
  String get wealthRetentionStat => 'RETENTION';

  @override
  String get wealthWord => 'Dhan';

  @override
  String get wealthYogasTitle => 'Wealth Yogas';

  @override
  String get wealthDrainsLabel => 'DRAINS';

  @override
  String get wealthBoostersLabel => 'BOOSTERS';

  @override
  String get wealthYearlyTrendTitle => 'Yearly Trend';

  @override
  String get wealthGrowthTitle => 'Wealth Growth';

  @override
  String get wealthCashPressureTitle => 'Cash Pressure';

  @override
  String get wealthMoneyPersonalityTitle => 'Money Personality';

  @override
  String get wealthTypeLabel => 'WEALTH TYPE';

  @override
  String get wealthRiskAppetiteLabel => 'RISK APPETITE';

  @override
  String get wealthInvestmentStyleLabel => 'INVESTMENT STYLE';

  @override
  String get wealthMoneyPersonalityLabel => 'MONEY PERSONALITY';

  @override
  String get wealthSpendingLabel => 'SPENDING';

  @override
  String get wealthDebtProbStat => 'DEBT PROB %';

  @override
  String get wealthInheritanceStat => 'INHERITANCE %';

  @override
  String get wealthSuddenGainsStat => 'SUDDEN GAINS %';

  @override
  String get wealthSpouseBoostStat => 'SPOUSE BOOST %';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'Success probability: $pct%';
  }

  @override
  String get wealthLifetimeClassLabel => 'LIFETIME WEALTH CLASS';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'Primary: $value';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'Peak: $value';
  }

  @override
  String get wealthIncomeWord => 'Income';

  @override
  String get wealthSourcesSuffix => 'Sources';

  @override
  String get wealthInvestmentWord => 'Investment';

  @override
  String get wealthMixSuffix => 'Mix';

  @override
  String wealthDrivenByLabel(Object planet) {
    return '$planet dwara chalit';
  }

  @override
  String get marriageScoresHeader => '💒 MARRIAGE SCORES';

  @override
  String get marriageOverallStat => 'OVERALL\nMARRIAGE';

  @override
  String get marriageHarmonyStat => 'MARITAL\nHARMONY';

  @override
  String get marriageDomesticStabilityStat => 'DOMESTIC\nSTABILITY';

  @override
  String get marriageLongevityStat => 'LONGEVITY';

  @override
  String get marriageSatisfactionStat => 'SATISFACTION';

  @override
  String get marriageClarityStat => 'CLARITY';

  @override
  String get marriageWindowsTitle => 'Marriage Windows';

  @override
  String get marriagePhasesTitle => 'Marriage Phases';

  @override
  String get marriageInLawRelationsStat => 'SASURAAL RISHTE';

  @override
  String get marriageFamilyHarmonyStat => 'FAMILY HARMONY';

  @override
  String get marriageFertilityStat => 'FERTILITY';

  @override
  String get marriageHomeOwnershipStat => 'HOME OWNERSHIP';

  @override
  String get marriageDivorceRiskStat => 'DIVORCE RISK';

  @override
  String get marriageInfidelityStat => 'INFIDELITY';

  @override
  String get marriageConflictStat => 'CONFLICT';

  @override
  String get marriageDistanceStat => 'DISTANCE';

  @override
  String get marriageSeekInPartnerTitle => '★ PARTNER MEIN DHOONDHEIN';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ PARTNER MEIN BACHEIN';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'Realization: $pct%';
  }

  @override
  String get marriageDarakarakaWord => 'Darakaraka';

  @override
  String get marriageSpouseKarakaSuffix => 'Spouse Karaka';

  @override
  String get marriageDarakarakaDkLabel => 'DARAKARAKA (DK)';

  @override
  String get marriage7thWord => '7th';

  @override
  String get marriageSignLabel => 'RASHI';

  @override
  String get marriageLordInLabel => 'SWAMI YAHAN';

  @override
  String get marriageStrengthLabel => 'STRENGTH';

  @override
  String get marriageSpouseWord => 'Jeevansaathi';

  @override
  String get marriageProfileSuffix => 'Profile';

  @override
  String get marriageSpouseTraitsTitle => '★ JEEVANSAATHI KE GUN';

  @override
  String get marriageLikelyProfessionsTitle => '● SAMBHAVIT PROFESSIONS';

  @override
  String get marriageHarmonyWord => 'Harmony';

  @override
  String get marriageRadarSuffix => 'Radar';

  @override
  String get marriagePhysicalLabel => 'Physical';

  @override
  String get marriageSharedValuesLabel => 'Shared Values';

  @override
  String get marriageConflictResolutionLabel => 'Conflict Resolution';

  @override
  String get marriageMangalDoshLabel => '⚠ MANGAL DOSH';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'Severity: $value';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'Cancellation: $value';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'Navamsa';

  @override
  String get multiChartTitleChild => 'Santaan';

  @override
  String get multiChartTitleLove => 'Love';

  @override
  String get multiChartTitleKarma => 'Karma';

  @override
  String get multiChartTitleDefault => 'Multi-Chart';

  @override
  String get multiChartSuffixProbability => 'Probability';

  @override
  String get multiChartSuffixCompatibility => 'Compatibility';

  @override
  String get multiChartSuffixLinkage => 'Linkage';

  @override
  String get multiChartSuffixReport => 'Report';

  @override
  String get multiChartParticipantsLabel => 'PARTICIPANTS';

  @override
  String get multiChartAnalysisWord => 'Analysis';

  @override
  String get multiChartConfidenceSuffix => 'Confidence';

  @override
  String get multiChartQualityBadge => 'QUALITY';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'Is Vedic astrology report ko analyze karein aur detailed insights dein:\n\n$formatted';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'Yeh ek Vedic astrology specialist report hai. Kripya ise achhe se analyze karein aur actionable insights dein:\n\n$formatted';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'Is Vedic astrology analysis ko review karein aur key findings ko simple bhasha mein samjhayein:\n\n$formatted';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return '$label ke liye copy ho gaya!';
  }

  @override
  String get childProbTitle1 => 'Santaan';

  @override
  String get childProbTitle2 => 'Probability';

  @override
  String get childNumberOfChildrenHeader1 => 'Bachchon ki';

  @override
  String get childNumberOfChildrenHeader2 => 'Sankhya';

  @override
  String get childTimingHeader1 => 'Timing';

  @override
  String get childTimingHeader2 => 'Moola Dasha';

  @override
  String get child5thHouseHeader1 => '5th House';

  @override
  String get analysisWord => 'Analysis';

  @override
  String get jupiterWord => 'Guru';

  @override
  String get childD7Header1 => 'D7 Saptamsa';

  @override
  String get childBeejaHeader1 => 'Beeja & Kshetra';

  @override
  String get childBeejaHeader2 => 'Sphuta';

  @override
  String get childDoshaHeader1 => 'Dosha';

  @override
  String get childVedicHeader1 => 'Vedic';

  @override
  String get childVedicHeader2 => 'Upay';

  @override
  String get progenyProbabilityLabel => 'SANTAAN KI SAMBHAVNA';

  @override
  String get favorableWindowsLabel => 'FAVORABLE WINDOWS';

  @override
  String get partnerOneLabel => 'Partner 1';

  @override
  String get partnerTwoLabel => 'Partner 2';

  @override
  String get moonSignLabel => 'Chandra Rashi';

  @override
  String get lordInDusthana => 'Swami Dusthana Mein';

  @override
  String get lordStrengthLabel => 'Swami ki Strength';

  @override
  String get houseStrengthLabel => 'House Strength';

  @override
  String get dignityLabel => 'Dignity';

  @override
  String get directBadge => 'Direct';

  @override
  String get notCombustBadge => 'Not Combust';

  @override
  String get in5thHouseBadge => '5th House Mein';

  @override
  String get aspects5thBadge => '5th Par Drishti';

  @override
  String get no5thConnectionBadge => 'No 5th Connection';

  @override
  String jupiterInSignHeading(String sign) {
    return 'Guru $sign mein';
  }

  @override
  String get d7LagnaLabel => 'D7 Lagna';

  @override
  String get d7FifthSignLabel => 'D7 5th Rashi';

  @override
  String get d7FifthLordLabel => 'D7 5th Swami';

  @override
  String get jupiterInD7Label => 'Guru D7 mein';

  @override
  String get jupiterDignityLabel => 'Guru Dignity';

  @override
  String get d7StrengthLabel => 'D7 Strength';

  @override
  String get yesWord => 'Haan';

  @override
  String get noWord => 'Nahi';

  @override
  String get beejaSphutaTitle => 'BEEJA SPHUTA';

  @override
  String get kshetraSphutaTitle => 'KSHETRA SPHUTA';

  @override
  String get degreeLabel => 'Degree';

  @override
  String get signLordLabel => 'Rashi Swami';

  @override
  String get presentInLabel => 'Yahan Sthit';

  @override
  String get netPenaltyLabel => 'Net Penalty';

  @override
  String get remedyGemstone => 'Ratna Upay';

  @override
  String get remedyMantra => 'Mantra Upay';

  @override
  String get remedyRitual => 'Anushthan Upay';

  @override
  String get remedyLifestyle => 'Lifestyle Upay';

  @override
  String get remedyCharitable => 'Daan Upay';

  @override
  String copiedForName(String name) {
    return '$name ke liye copy ho gaya!';
  }

  @override
  String get mahadashaLabel => 'Mahadasha';

  @override
  String get mdPeriodLabel => 'MD Period';

  @override
  String get antardashaLabel => 'Antardasha';

  @override
  String get adPeriodLabel => 'AD Period';

  @override
  String get pratyantardashaLabel => 'Pratyantardasha';

  @override
  String get favorabilityLabel => 'Favorability';

  @override
  String factorPrefix(String factor) {
    return 'Factor: $factor';
  }

  @override
  String appliesToLabel(String value) {
    return 'Applies to: $value';
  }

  @override
  String get qualityTag => 'QUALITY';

  @override
  String get reliabilityVeryHigh => 'Very High reliability';

  @override
  String get reliabilityGuidanceLevel => 'Guidance-level reading';

  @override
  String get karmaLinkTitle1 => 'Karma';

  @override
  String get karmaLinkTitle2 => 'Linkage';

  @override
  String get karmaFoundationHeader1 => 'Karmic';

  @override
  String get karmaFoundationHeader2 => 'Foundation';

  @override
  String get karmaPairwiseHeader1 => 'Pairwise';

  @override
  String get karmaPairwiseHeader2 => 'Linkages';

  @override
  String get karmaGroupHeader1 => 'Group';

  @override
  String get karmaGroupHeader2 => 'Pattern';

  @override
  String get karmaPastLifeHeader1 => 'Past Life';

  @override
  String get karmaPastLifeHeader2 => 'Goals';

  @override
  String get karmaCurrentLifeHeader1 => 'Current Life';

  @override
  String get karmaCurrentLifeHeader2 => 'Learning';

  @override
  String get karmaDebtsHeader2 => 'Debts';

  @override
  String get karmaMoolaDashaHeader1 => 'Moola Dasha';

  @override
  String get karmaMoolaDashaHeader2 => 'Timing';

  @override
  String get karmaDeepAuditHeader1 => 'Deep Audit';

  @override
  String get karmaDeepAuditHeader2 => 'Table';

  @override
  String get karmaHeroLabel => 'PAST LIFE KARMA LINKAGE';

  @override
  String get karmaKetuMastery => 'KETU MASTERY';

  @override
  String get nakshatraLabel => 'Nakshatra';

  @override
  String get deityLabel => 'Devta';

  @override
  String get masteryScoreLabel => 'Mastery Score';

  @override
  String get karmaRahuGrowth => 'RAHU GROWTH';

  @override
  String get growthScoreLabel => 'Growth Score';

  @override
  String get karmaAtmakaraka => 'ATMAKARAKA';

  @override
  String get karmaSaturnKarma => 'SHANI KARMA';

  @override
  String get karma12thHouse => '12TH HOUSE';

  @override
  String get karma9thHousePunya => '9TH HOUSE PUNYA';

  @override
  String get bhavaScoreLabel => 'Bhava Score';

  @override
  String get karmaD60Signature => 'D60 SIGNATURE';

  @override
  String get depthScoreLabel => 'Depth Score';

  @override
  String get linkageStrengthLabel => 'Linkage Strength';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'LINKAGE FACTORS ($count active)';
  }

  @override
  String get factorColumnLabel => 'Factor';

  @override
  String get weightColumnLabel => 'Weight';

  @override
  String get meaningColumnLabel => 'Arth';

  @override
  String get statusColumnLabel => 'Status';

  @override
  String get karmaPastLifeConnection => 'PAST LIFE CONNECTION';

  @override
  String get karmaCurrentLifeDynamic => 'CURRENT LIFE DYNAMIC';

  @override
  String get karmaWhatTheyTeach => 'EK DOOSRE KO KYA SIKHATE HAIN';

  @override
  String get karmaGroupThemeHeader => 'GROUP KARMIC THEME';

  @override
  String get karmaSharedSettingHeader => 'SHARED PAST LIFE SETTING';

  @override
  String get karmaCollectiveKetuHeader => 'COLLECTIVE KETU PATTERN';

  @override
  String get karmaCollectiveRahuHeader => 'COLLECTIVE RAHU PATTERN';

  @override
  String get housesPrefixLabel => 'Houses: ';

  @override
  String get signsPrefixLabel => 'Rashiyan: ';

  @override
  String get karmicCohesionLabel => 'Karmic Cohesion';

  @override
  String get karmaGroupSoulContractHeader => 'GROUP SOUL CONTRACT';

  @override
  String get goalLabel => 'Lakshya';

  @override
  String get karmaSharedGoalHeader => 'SHARED PAST LIFE GOAL';

  @override
  String get howToGrowHeader => 'GROW KAISE KAREIN';

  @override
  String moolaDashaPrefix(String value) {
    return 'Moola Dasha: $value';
  }

  @override
  String get karmaSharedLessonHeader => 'SHARED GROUP LESSON';

  @override
  String get karmaMutualTeachingHeader => 'MUTUAL TEACHING MAP';

  @override
  String get karmaTeachingDynamicsPlaceholder =>
      'Karmic connections gehri hone par teaching dynamics samne aayenge.';

  @override
  String get typeFieldLabel => 'Type';

  @override
  String get basisFieldLabel => 'Basis';

  @override
  String get resolutionPathHeader => 'RESOLUTION PATH';

  @override
  String dashaTimingPrefix(String value) {
    return 'Dasha Timing: $value';
  }

  @override
  String get mutualDebtsHeader => 'MUTUAL DEBTS';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'Dates';

  @override
  String get groupKarmicWindowHeader => 'GROUP KARMIC WINDOW';

  @override
  String parametersAuditedHeading(int count) {
    return '$count PARAMETERS AUDITED';
  }

  @override
  String get valuePrefixLabel => 'Value: ';

  @override
  String weightPrefix(String value) {
    return 'W: $value';
  }

  @override
  String get loveCompatTitle1 => 'Love';

  @override
  String get loveCompatTitle2 => 'Compatibility';

  @override
  String get loveAttractionHeader1 => 'Attraction &';

  @override
  String get loveAttractionHeader2 => 'Chemistry';

  @override
  String get loveEmotionalHeader1 => 'Emotional';

  @override
  String get loveEmotionalHeader2 => 'Harmony';

  @override
  String get loveMentalHeader1 => 'Mental';

  @override
  String get loveMentalHeader2 => 'Rapport';

  @override
  String get lovePassionHeader1 => 'Passion &';

  @override
  String get lovePassionHeader2 => 'Physical';

  @override
  String get loveLongtermHeader1 => 'Long-term';

  @override
  String get loveKarmicHeader1 => 'Karmic Love';

  @override
  String get loveKarmicHeader2 => 'Bond';

  @override
  String get loveChallengesHeader1 => 'Challenges &';

  @override
  String get loveChallengesHeader2 => 'Friction';

  @override
  String get loveTimingHeader1 => 'Love Timing';

  @override
  String get loveRelationshipHeader1 => 'Relationship';

  @override
  String get loveRelationshipHeader2 => 'Dynamics';

  @override
  String get loveRemediesHeader1 => 'Upay &';

  @override
  String get loveRemediesHeader2 => 'Guidance';

  @override
  String get loveCompatHeroLabel => 'LOVE COMPATIBILITY';

  @override
  String get loveChipAttraction => 'Attraction';

  @override
  String get loveChipPassion => 'Passion';

  @override
  String get loveChipChallenge => 'Challenge';

  @override
  String get venusSignLabel => 'Shukra Rashi';

  @override
  String get attractionScoreLabel => 'Attraction Score';

  @override
  String get activeContactsLabel => 'Active Contacts';

  @override
  String get magneticPullLabel => 'Magnetic Pull';

  @override
  String get initialAttractionLabel => 'Initial Attraction';

  @override
  String get emotionalScoreLabel => 'Emotional Score';

  @override
  String get elementMatchLabel => 'Element Match';

  @override
  String get harmonyLabel => 'Harmony';

  @override
  String get kootaYoni => 'YONI';

  @override
  String get kootaGana => 'GANA';

  @override
  String get kootaTara => 'TARA';

  @override
  String get doshaPresentBadge => 'Dosha Hai';

  @override
  String get noDoshaBadge => 'No Dosha';

  @override
  String get axisLabel => 'Axis';

  @override
  String get mentalScoreLabel => 'Mental Score';

  @override
  String get mercuryDynamicsLabel => 'BUDH DYNAMICS';

  @override
  String get communicationStyleLabel => 'COMMUNICATION STYLE MATCH';

  @override
  String get intellectualConnectionLabel => 'INTELLECTUAL CONNECTION';

  @override
  String get passionScoreLabel => 'Passion Score';

  @override
  String get marsVenusLabel => 'MANGAL-SHUKRA INTERPLAY';

  @override
  String get physicalChemistryLabel => 'PHYSICAL CHEMISTRY';

  @override
  String get yoniCompatLabel => 'YONI COMPATIBILITY';

  @override
  String get longtermScoreLabel => 'Long-term Score';

  @override
  String get seventhHouseSynastryLabel => '7TH HOUSE SYNASTRY';

  @override
  String get commitmentPotentialLabel => 'COMMITMENT POTENTIAL';

  @override
  String get jupiterBlessingLabel => 'GURU BLESSING';

  @override
  String get d9NavamsaResonanceLabel => 'D9 NAVAMSA RESONANCE';

  @override
  String get saturnLongevityLabel => 'SHANI LONGEVITY';

  @override
  String get karmicScoreLabel => 'Karmic Score';

  @override
  String get darakarakaLinkLabel => 'DARAKARAKA LINK';

  @override
  String get sourceLabel => 'Source';

  @override
  String get emotionalGiverReceiverLabel => 'EMOTIONAL GIVER / RECEIVER';

  @override
  String get powerBalanceLabel => 'POWER BALANCE';

  @override
  String get growthDynamicLabel => 'GROWTH DYNAMIC';

  @override
  String get addressesLabel => 'Addresses';

  @override
  String get loveScoresLabel => 'LOVE SCORES';

  @override
  String get loveCapacityLabel => 'LOVE\nCAPACITY';

  @override
  String get emotionalAvailabilityLabel => 'EMOTIONAL\nAVAILABILITY';

  @override
  String get romanticAttractionLabel => 'ROMANTIC\nATTRACTION';

  @override
  String get commitmentWord => 'COMMITMENT';

  @override
  String get intimacyWord => 'INTIMACY';

  @override
  String get fidelityWord => 'FIDELITY';

  @override
  String get loveProfileTitle => 'Love Profile';

  @override
  String get loveStyleLabel => 'LOVE STYLE';

  @override
  String get attractionStyleLabel => 'ATTRACTION STYLE';

  @override
  String get lovePathLabel => 'LOVE PATH';

  @override
  String get currentPhaseLabel => 'CURRENT PHASE';

  @override
  String get commitmentStyleLabel => 'COMMITMENT STYLE';

  @override
  String get loveWord => 'Love';

  @override
  String get karakasWord => 'Karakas';

  @override
  String get attractedToLabel => 'ATTRACTED TO';

  @override
  String get whatPartnerSeesLabel => 'PARTNER KYA DEKHTA HAI';

  @override
  String get romancePatternTitle => 'Romance Pattern';

  @override
  String get firstLoveAgeLabel => 'PEHLE PYAAR KI UMAR';

  @override
  String get relationshipCountLabel => 'RELATIONSHIP COUNT';

  @override
  String get avgDurationLabel => 'AVG DURATION';

  @override
  String get breakupTriggerLabel => 'BREAKUP TRIGGER';

  @override
  String get heartbreakRecoveryLabel => 'HEARTBREAK RECOVERY';

  @override
  String get loveTrendTitle => 'Love Trend';

  @override
  String get newLoveWindowsTitle => 'New Love Windows';

  @override
  String get loveBlocksTitle => 'Love Blocks';

  @override
  String get activeBlocksLabel => 'ACTIVE BLOCKS';

  @override
  String get loveMarriagePctLabel => 'LOVE MARRIAGE %';

  @override
  String get heartbreakVulnLabel => 'HEARTBREAK VULN';

  @override
  String get selfSabotageLabel => 'SELF-SABOTAGE';

  @override
  String get emotionalIqLabel => 'EMOTIONAL IQ';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'Fulfillment: $pct%';
  }

  @override
  String get languagesWord => 'Languages';

  @override
  String get givesLabel => 'DETA HAI';

  @override
  String get receivesLabel => 'LETA HAI';

  @override
  String get idealWord => 'Ideal';

  @override
  String get partnerWord => 'Partner';

  @override
  String get seekTheseTraitsLabel => 'YE GUN DHOONDHEIN';

  @override
  String get dealbreakersLabel => 'DEALBREAKERS';

  @override
  String get propertyScoresLabel => 'PROPERTY SCORES';

  @override
  String get acquisitionCapacityLabel => 'ACQUISITION\nCAPACITY';

  @override
  String get homeOwnershipPctLabel => 'HOME\nOWNERSHIP %';

  @override
  String get reWealthPotentialLabel => 'RE WEALTH\nPOTENTIAL';

  @override
  String get rentalWord => 'RENTAL';

  @override
  String get vehiclesWord => 'VAAHAN';

  @override
  String get landPctLabel => 'LAND %';

  @override
  String get propertyProfileTitle => 'Property Profile';

  @override
  String get karmaTypeLabel => 'KARMA TYPE';

  @override
  String get environmentLabel => 'ENVIRONMENT';

  @override
  String get styleLabel => 'STYLE';

  @override
  String get sizeLabel => 'SIZE';

  @override
  String get locationLabel => 'LOCATION';

  @override
  String get actionNext12mLabel => 'ACTION NEXT 12M';

  @override
  String get propertyWord => 'Property';

  @override
  String get propertyYogasTitle => 'Property Yogas';

  @override
  String get drainsLabel => 'DRAINS';

  @override
  String get boostersLabel => 'BOOSTERS';

  @override
  String get propertyTrendTitle => 'Property Trend';

  @override
  String get buyingWindowsTitle => 'Buying Windows';

  @override
  String get constructionWindowsTitle => 'Construction Windows';

  @override
  String get maternalInherPctLabel => 'MAAYKE SE VIRASAT %';

  @override
  String get paternalInherPctLabel => 'PITA SE VIRASAT %';

  @override
  String get multiHomePctLabel => 'MULTI-HOME %';

  @override
  String get investmentPctLabel => 'INVESTMENT %';

  @override
  String get vehicleProfileTitle => 'Vehicle Profile';

  @override
  String get countLabel => 'COUNT';

  @override
  String get firstAgeLabel => 'FIRST AGE';

  @override
  String get categoryLabel => 'CATEGORY';

  @override
  String get luxuryLabel => 'LUXURY';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'Lifetime count: $count · Fulfillment: $pct%';
  }

  @override
  String get pressureWord => 'PRESSURE';

  @override
  String get protectionWord => 'PROTECTION';

  @override
  String get astrologicalWord => 'Jyotish';

  @override
  String get keyRisksHeader1 => 'Key';

  @override
  String get keyRisksHeader2 => 'Risks';

  @override
  String get reportCopiedShort => 'Report copy ho gayi!';

  @override
  String get keyScoresLabel => 'KEY SCORES';

  @override
  String allScoresCountLabel(int count) {
    return 'All Scores ($count)';
  }

  @override
  String get windowsWord => 'Windows';

  @override
  String get genericFailedMsg => 'Fail ho gaya';

  @override
  String get unknownWord => 'Anjaan';

  @override
  String selectKarmaChartsLabel(int max) {
    return '2-$max Charts Chunein';
  }

  @override
  String selectChartsLabelCount(int max) {
    return '$max Charts Chunein';
  }

  @override
  String runningAnalysisLabel(String label) {
    return '$label analysis chal raha hai...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'Karmic links analyze karne ke liye 2 se $max charts chunein';
  }

  @override
  String get pickMaleFemaleHint => 'Ek Male aur Female chart chunein';

  @override
  String get personOneLabel => 'Person 1';

  @override
  String get personTwoLabel => 'Person 2';

  @override
  String get analysisFailedMsg => 'Analysis fail ho gaya';

  @override
  String analyzeChartsCountLabel(int count) {
    return '$count Charts Analyze Karein';
  }

  @override
  String get contextGeneralLabel => 'General';

  @override
  String get contextLoveLabel => 'Love';

  @override
  String get contextBusinessLabel => 'Business';

  @override
  String get contextFamilyLabel => 'Family';

  @override
  String get contextTeamLabel => 'Team';

  @override
  String get contextFriendshipLabel => 'Dosti';

  @override
  String get relationshipIntelTitle => 'Relationship Intelligence';

  @override
  String analyzingChartsCountLabel(int count) {
    return '$count charts analyze ho rahe hain...';
  }

  @override
  String get relationshipContextLabel => 'Relationship Context';

  @override
  String get kundliMilanReportTitle => 'Kundli Milan Report';

  @override
  String get runningMilanAnalysisLabel => 'Milan analysis chal raha hai...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '$count/2 selected';
  }

  @override
  String get runMilanAnalysisBtn => 'Milan Analysis Chalayein';

  @override
  String get noChartsCreateFirst =>
      'Koi chart nahi. Pehle birth chart banayein.';

  @override
  String get selectBirthChartAnalyze =>
      'Analyze karne ke liye ek birth chart chunein';

  @override
  String get doshAnalysis => 'Dosha Analysis';

  @override
  String doshActiveCount(Object active, Object total) {
    return '$active active / $total checked';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '$active active / $total yogas checked';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'ACTIVE YOGAS ($count)';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'Inactive yogas chhupayein ($count)';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'Inactive yogas dikhayein ($count)';
  }

  @override
  String get loadFailed => 'Fail ho gaya';

  @override
  String dashaDrillMd(Object planet) {
    return '$planet MD → Antardashas';
  }

  @override
  String dashaDrillAd(Object planet) {
    return '$planet AD → Pratyantardashas';
  }

  @override
  String dashaDrillPd(Object planet) {
    return '$planet PD → Sookshmadashas';
  }

  @override
  String dashaDrillSub(Object planet) {
    return '$planet Sub-periods';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return 'Birth Lord: $lord • Balance: $balance saal';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'Lagna: $lagna • Balance: $balance saal';
  }

  @override
  String dashaYearsValue(Object years) {
    return '$years saal';
  }

  @override
  String get dashaCurrentPeriod => 'Current Dasha Period';

  @override
  String dashaAsOf(Object date) {
    return 'As of: $date';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'Current Period ke Active Yogas ($count)';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'Current Period ke Active Doshas ($count)';
  }

  @override
  String get dashaNoYogasTriggered => 'Koi yoga trigger nahi hua';

  @override
  String get dashaNoDoshasTriggered => 'Koi dosha trigger nahi hua';

  @override
  String get divD1Name => 'Rasi (D-1)';

  @override
  String get divD1Desc => 'Sharirik astitva, sabhi vishay';

  @override
  String get divD2Name => 'Hora (D-2)';

  @override
  String get divD2Desc => 'Dhan, paisa';

  @override
  String get divD3Name => 'Drekkana (D-3)';

  @override
  String get divD3Desc => 'Bhai-behen, saahas';

  @override
  String get divD4Name => 'Chaturthamsa (D-4)';

  @override
  String get divD4Desc => 'Sampatti, nivaas, bhagya';

  @override
  String get divD5Name => 'Panchamsa (D-5)';

  @override
  String get divD5Desc => 'Yash, satta, shakti';

  @override
  String get divD6Name => 'Shashthamsa (D-6)';

  @override
  String get divD6Desc => 'Swasthya samasyaayein';

  @override
  String get divD7Name => 'Saptamsa (D-7)';

  @override
  String get divD7Desc => 'Santaan, potey-potiyaan';

  @override
  String get divD8Name => 'Ashtamsa (D-8)';

  @override
  String get divD8Desc => 'Achanak pareshaani, mukadma';

  @override
  String get divD9Name => 'Navamsha (D-9)';

  @override
  String get divD9Desc => 'Vivah, jeevansaathi, dharma';

  @override
  String get divD10Name => 'Dasamsha (D-10)';

  @override
  String get divD10Desc => 'Career, profession';

  @override
  String get divD11Name => 'Rudramsha (D-11)';

  @override
  String get divD11Desc => 'Mrityu, vinaash';

  @override
  String get divD12Name => 'Dwadasamsha (D-12)';

  @override
  String get divD12Desc => 'Maata-pita, rakt-sambandhi';

  @override
  String get divD16Name => 'Shodasamsha (D-16)';

  @override
  String get divD16Desc => 'Vaahan, sukh-suvidha, aanand';

  @override
  String get divD20Name => 'Vimsamsha (D-20)';

  @override
  String get divD20Desc => 'Aadhyaatmik vishay, dharmik';

  @override
  String get divD24Name => 'Chaturvimsamsha (D-24)';

  @override
  String get divD24Desc => 'Vidya, gyaan, shiksha';

  @override
  String get divD27Name => 'Nakshatramsha (D-27)';

  @override
  String get divD27Desc => 'Taakat, kamzoriyaan, swabhav';

  @override
  String get divD30Name => 'Trimsamsha (D-30)';

  @override
  String get divD30Desc => 'Buraiyaan, avchetan, dand';

  @override
  String get divD40Name => 'Khavedamsha (D-40)';

  @override
  String get divD40Desc => 'Shubh/ashubh (maatri paksh)';

  @override
  String get divD45Name => 'Akshavedamsha (D-45)';

  @override
  String get divD45Desc => 'Sabhi vishay (pitri paksh)';

  @override
  String get divD60Name => 'Shashtyamsha (D-60)';

  @override
  String get divD60Desc => 'Poorv-janm karma — SABSE MEHATVAPURN';

  @override
  String get lifeAreaCareer => 'Career';

  @override
  String get lifeAreaWealth => 'Dhan';

  @override
  String get lifeAreaMarriage => 'Vivah';

  @override
  String get lifeAreaHealth => 'Swasthya';

  @override
  String get lifeAreaSpirituality => 'Aadhyaatm';

  @override
  String lifeAreaGrade(Object grade) {
    return 'Grade: $grade';
  }

  @override
  String get lifeAreaFactorsLabel => 'Factors:';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return 'Nak: $nakshatra ($pada)';
  }

  @override
  String planetNakLord(Object lord) {
    return 'NL: $lord';
  }

  @override
  String planetLongitude(Object value) {
    return 'Lon: $value°';
  }

  @override
  String get chakraOverallHealth => 'Overall Health';

  @override
  String get careerWord => 'Career';

  @override
  String get failedToLoad => 'Load fail ho gaya';

  @override
  String get kundliAscendantLagna => 'Ascendant (Lagna)';

  @override
  String get kundliMoonSignRashi => 'Chandra Rashi';

  @override
  String get kundliSunSign => 'Surya Rashi';

  @override
  String kundliEngineLabel(Object engine) {
    return 'Engine: $engine';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return 'Degree: $degree°  •  Nakshatra: $nakshatra ($pada)';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'Nakshatra Swami: $lord  •  Dignity: $dignity';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return '$base Chart — $sign';
  }

  @override
  String kundliBaseChart(Object base) {
    return '$base Chart';
  }

  @override
  String get careerSummary => 'Career Summary';

  @override
  String get phase => 'Phase';

  @override
  String get confidenceLabel => 'Confidence';

  @override
  String get careerScores => 'Career Scores';

  @override
  String get stabilityLabel => 'Stability';

  @override
  String get growthLabel => 'Growth';

  @override
  String get gradeExcellent => 'Behtareen';

  @override
  String get gradeGood => 'Achha';

  @override
  String get gradeAverage => 'Average';

  @override
  String get gradeBelowAvg => 'Below Avg';

  @override
  String get gradeWeak => 'Kamzor';

  @override
  String get careerTypeDomain => 'Career & Domain';

  @override
  String get careerTimeline => 'Career Timeline';

  @override
  String dashaLabel(Object dasha) {
    return 'Dasha: $dasha';
  }

  @override
  String get improvementSuggestions => 'Improvement Suggestions';

  @override
  String get chartDetails => 'Chart Details';

  @override
  String get keyHousesCareer => 'Key Houses (Career)';

  @override
  String get keyCareerPlanets => 'Key Career Grah';

  @override
  String get empty => 'Khaali';

  @override
  String get guna => 'Guna';

  @override
  String get dasha => 'Dasha';

  @override
  String get satwik => 'Satwik';

  @override
  String get rajasik => 'Rajasik';

  @override
  String get tamasik => 'Tamasik';

  @override
  String get charGroupCorePersonality => 'Core Personality';

  @override
  String get charGroupTrustHonesty => 'Vishwas & Imaandari';

  @override
  String get charGroupLoyaltyCommitment => 'Loyalty & Commitment';

  @override
  String get charGroupStrategicPrivacy => 'Strategic & Privacy';

  @override
  String get charGroupFinancial => 'Financial';

  @override
  String get charGroupAngerConflict => 'Gussa & Conflict';

  @override
  String get charGroupMoralDharmic => 'Naitik & Dharmic';

  @override
  String get charGroupIntellectCommunication => 'Buddhi & Communication';

  @override
  String get charGroupEmotionalProfile => 'Emotional Profile';

  @override
  String get charGroupMentalHealth => 'Mental Health';

  @override
  String get charGroupRomantic => 'Romantic';

  @override
  String get charGroupMarriageFamily => 'Vivah & Parivaar';

  @override
  String get charGroupOverallLife => 'Overall Life';

  @override
  String get grahaDrishti => 'Graha Drishti (Grah Drishti)';

  @override
  String get grahaDrishtiSubtitle => 'Kaun kise dekhta hai (%)';

  @override
  String get lagnaAspectsReceived => 'Lagna Par Aayi Drishti';

  @override
  String get rashiDrishti => 'Rashi Drishti (Rashi Drishti)';

  @override
  String get shadbalaRupas => 'rupas';

  @override
  String get bhavaHouse1 => 'Swayam / Sharir';

  @override
  String get bhavaHouse2 => 'Dhan / Parivaar';

  @override
  String get bhavaHouse3 => 'Bhai-Behen / Saahas';

  @override
  String get bhavaHouse4 => 'Ghar / Maata';

  @override
  String get bhavaHouse5 => 'Santaan / Buddhi';

  @override
  String get bhavaHouse6 => 'Dushman / Swasthya';

  @override
  String get bhavaHouse7 => 'Vivah / Partner';

  @override
  String get bhavaHouse8 => 'Aayu';

  @override
  String get bhavaHouse9 => 'Bhagya / Guru';

  @override
  String get bhavaHouse10 => 'Career / Pita';

  @override
  String get bhavaHouse11 => 'Laabh / Dost';

  @override
  String get bhavaHouse12 => 'Haani / Moksha';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '$sign • Swami: $lord';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: $value';
  }

  @override
  String get sarvaAshtakavarga => 'Sarva Ashtakavarga (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'Total: $total rekhas (average rashi = $avg)';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '$planet — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'Total: $total rekhas • Janm rashi par: $score';
  }

  @override
  String get today => 'Aaj';

  @override
  String gocharTransitScores(Object date) {
    return 'Gochar (Transit Scores) — $date';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'Janm Chandra: $sign';
  }

  @override
  String get gocharBest => 'BEST';

  @override
  String get gocharWorst => 'WORST';

  @override
  String copiedOpening(Object ai) {
    return 'Copy ho gaya! $ai khul raha hai...';
  }

  @override
  String get openLink => 'OPEN ↗';

  @override
  String get discussReportWithAI => 'IS REPORT PAR AI SE BAAT KAREIN';

  @override
  String get reliabilityHigh => 'High reliability';

  @override
  String get reliabilityModerate => 'Moderate reliability';

  @override
  String get reliabilityLow => 'Kam — sirf guidance';

  @override
  String get reliabilityGoodEdu => 'Good reliability · D-24 verified';

  @override
  String get relationshipWord => 'Relationship';

  @override
  String get intelligenceWord => 'Intelligence';

  @override
  String get relationshipIntelligence => 'RELATIONSHIP INTELLIGENCE';

  @override
  String get typeLabel => 'Type';

  @override
  String get trustLabel => 'Trust';

  @override
  String get dhokaRisk => 'Dhoka Risk';

  @override
  String get powerLabel => 'Power';

  @override
  String get integrity => 'Integrity';

  @override
  String get warmth => 'Warmth';

  @override
  String get trustWord => 'Vishwas';

  @override
  String get assertLabel => 'Assert';

  @override
  String get character => 'Character';

  @override
  String get love => 'Love';

  @override
  String get businessWord => 'Business';

  @override
  String get karmic => 'Karmic';

  @override
  String get enmityRisk => 'Dushmani Risk';

  @override
  String get hdrChartProfiles => 'Chart Profiles';

  @override
  String get hdrPairwiseAnalysis => 'Pairwise Analysis';

  @override
  String get hdrCriticalPatterns => 'Critical Patterns';

  @override
  String get hdrGroupRecommendations => 'Group Recommendations';

  @override
  String get sharedPractices => 'SHARED PRACTICES';

  @override
  String get hdrIndividualGuidance => 'Individual Guidance';

  @override
  String get growthAreas => 'GROWTH AREAS';

  @override
  String get hdrCoreTheme => 'Core Theme';

  @override
  String get growthOriented => 'GROWTH-ORIENTED';

  @override
  String get groupTheme => 'GROUP THEME';

  @override
  String get compatibility => 'COMPATIBILITY';

  @override
  String get unifiedScoreLabel => 'UNIFIED SCORE';

  @override
  String get ashtakoot => 'Ashtakoot';

  @override
  String get probability => 'Probability';

  @override
  String get hdrAshtakootSummary => 'Ashtakoot Summary';

  @override
  String get hdrGunBreakdown => '8 Gun Breakdown';

  @override
  String get hdrMangalDosh => 'Mangal Dosh';

  @override
  String get hdrD9CrossChart => 'D-9 Cross-Chart';

  @override
  String get d9Compatibility => 'D-9 COMPATIBILITY';

  @override
  String get hdrDomainCompatibility => 'Domain Compatibility';

  @override
  String get emotional => 'Emotional';

  @override
  String get intellectual => 'Intellectual';

  @override
  String get spiritual => 'Spiritual';

  @override
  String get financial => 'Financial';

  @override
  String get domestic => 'Domestic';

  @override
  String get communicationWord => 'Communication';

  @override
  String get sharedDharma => 'Shared Dharma';

  @override
  String get familyCreation => 'Family Creation';

  @override
  String get hdrMarriageTiming => 'Marriage Timing';

  @override
  String get jointMarriageWindows => 'Joint Marriage Windows';

  @override
  String get engagementWindows => 'Engagement Windows';

  @override
  String get recommendedLabel => 'Recommended';

  @override
  String get hdrKeyRisks => 'Key Risks';

  @override
  String get hdrFinalVerdict => 'Final Verdict';

  @override
  String get marriageVerdict => 'MARRIAGE VERDICT';

  @override
  String get educationWord => 'Shiksha';

  @override
  String get learningSuffix => '& Learning';

  @override
  String get coreEducationScores => 'CORE EDUCATION SCORES';

  @override
  String get academicSuccess => 'ACADEMIC SUCCESS';

  @override
  String get learningCapacity => 'LEARNING CAPACITY';

  @override
  String get memory => 'Memory';

  @override
  String get intelligence => 'Intelligence';

  @override
  String get research => 'Research';

  @override
  String get hdrIntellectualProfile => 'Intellectual Profile';

  @override
  String get learningSignature => 'LEARNING SIGNATURE';

  @override
  String get hdrSubjectKaraka => 'Subject Karaka';

  @override
  String get hdrHouseFoundations => 'House Foundations';

  @override
  String get hdrMercuryJupiter => 'Budh & Guru';

  @override
  String get hdrEducationYogas => 'Education Yogas';

  @override
  String get hdrDivisionalValidation => 'Divisional Validation';

  @override
  String get standing => 'STANDING';

  @override
  String get hdrSubjectRanking => 'Subject Ranking';

  @override
  String get hdrDegreeLikelihood => 'Degree Likelihood';

  @override
  String get hdrStudyPeriods => 'Study Periods';

  @override
  String get earlySchooling => 'Early Schooling';

  @override
  String get higherEducation => 'Higher Education';

  @override
  String get postgradResearch => 'Postgrad · Research';

  @override
  String get hdrLearningPreferences => 'Learning Preferences';

  @override
  String get hdrChallengesGifts => 'Challenges & Gifts';

  @override
  String get challenges => 'Challenges';

  @override
  String get cognitiveGifts => 'COGNITIVE GIFTS';

  @override
  String get naturalAbilities => 'NATURAL ABILITIES';

  @override
  String get hdrSaraswatiRemedies => 'Saraswati Upay';

  @override
  String get studentVerdict => 'STUDENT VERDICT';

  @override
  String get educationCareerLinkage => 'EDUCATION → CAREER LINKAGE';

  @override
  String get startupSuffix => '& Startup';

  @override
  String get coreBusinessScores => 'CORE BUSINESS SCORES';

  @override
  String get overallBusiness => 'OVERALL BUSINESS';

  @override
  String get ventureSuccess => 'VENTURE SUCCESS';

  @override
  String get eleventhHouse => '11TH HOUSE';

  @override
  String get gains => 'Gains';

  @override
  String get investor => 'Investor';

  @override
  String get hdrFounderArchetype => 'Founder Archetype';

  @override
  String get hdrTenthEleventhHouses => '10th & 11th Houses';

  @override
  String get hdrBusinessYogas => 'Business Yogas';

  @override
  String get hdrRecommendedDomains => 'Recommended Domains';

  @override
  String get hdrBusinessStyle => 'Business Style';

  @override
  String get hdrFounderSkills => 'Founder Skills';

  @override
  String get hdrFundingProfile => 'Funding Profile';

  @override
  String get recommendedPath => 'RECOMMENDED PATH';

  @override
  String get investorAttract => 'INVESTOR ATTRACT';

  @override
  String get familyBacking => 'FAMILY BACKING';

  @override
  String get hybridViability => 'HYBRID VIABILITY';

  @override
  String get launchWindow => 'Launch Window';

  @override
  String get scaleWindow => 'Scale Window';

  @override
  String get hdrBusinessRisks => 'Business Risks';

  @override
  String get recoveryCapacity => 'RECOVERY CAPACITY';

  @override
  String get hdrRemediesSolutions => 'Upay & Solutions';

  @override
  String get aiConnectionLost =>
      'Connection lost ho gaya. Please dobara try karein.';

  @override
  String get aiSomethingWrong => 'Kuch galat ho gaya';

  @override
  String get aiNoResponse => 'Koi response nahi';

  @override
  String get aiConnectionError => 'Connection error. Please dobara try karein.';

  @override
  String get aiAutoDetect => 'Auto-detect';

  @override
  String aiAutoArrow(String lang) {
    return 'Auto → $lang';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'Language: $lang';
  }

  @override
  String get aiNoBirthCharts => 'Koi birth chart nahi mila';

  @override
  String get aiCreateChartFirst =>
      'AI se chat karne ke liye pehle ek birth chart banayein';

  @override
  String get aiSelectChartBegin =>
      'Analysis shuru karne ke liye ek birth chart select karein';

  @override
  String aiAnalyzingName(String name) {
    return 'Analyzing: $name';
  }

  @override
  String get aiChange => 'Change';

  @override
  String get aiAnalyzingChart => 'Aapki chart analyze ho rahi hai...';

  @override
  String get aiAskStarsHint => 'Sitaron se kuch bhi poochhein...';

  @override
  String get aiSuggestedFollowups => 'Suggested follow-ups';

  @override
  String get aiThinking => 'Soch raha hai...';

  @override
  String get aiThanks => 'Shukriya!';

  @override
  String get aiFeedbackNoted => 'Feedback note kar liya';

  @override
  String get svcAll => 'All';

  @override
  String get svcNoServices => 'Koi service available nahi';

  @override
  String get svcFree => 'FREE';

  @override
  String get astroFailedStartCall => 'Call shuru karne mein fail';

  @override
  String get astroFailedStartChat => 'Chat shuru karne mein fail';

  @override
  String astroErrorDetail(String error) {
    return 'Error: $error';
  }

  @override
  String get astroExperience => 'Experience';

  @override
  String get astroSessions => 'Sessions';

  @override
  String get astroMinutes => 'Minutes';

  @override
  String get astroAbout => 'About';

  @override
  String get astroLanguages => 'Languages';

  @override
  String get astroRateCard => 'Rate Card';

  @override
  String get astroVoice => 'Voice';

  @override
  String astroReviews(int count) {
    return 'Reviews ($count)';
  }

  @override
  String get astroNoReviews => 'Abhi tak koi review nahi';

  @override
  String get astroAnonymous => 'Anonymous';

  @override
  String get forgotPasswordSubtitle =>
      'Apna email daalein — hum aapko password\nreset karne ke liye link bhejenge.';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => 'Link dobara bhejein';

  @override
  String get appName => 'Nakshatralogy';

  @override
  String get cosmicJourneyAwaits => 'Aapki Cosmic Journey Shuru Hoti Hai';

  @override
  String get home => 'Home';

  @override
  String get astrologers => 'Jyotishi';

  @override
  String get services => 'Sevayein';

  @override
  String get wallet => 'Wallet';

  @override
  String get profile => 'Profile';

  @override
  String get live => 'Live';

  @override
  String get kundli => 'Kundli';

  @override
  String get chat => 'Chat';

  @override
  String get call => 'Call';

  @override
  String get video => 'Video';

  @override
  String get signIn => 'Sign In';

  @override
  String get createAccount => 'Account Banayein';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Password Confirm Karein';

  @override
  String get fullName => 'Poora Naam';

  @override
  String get phone => 'Phone (optional)';

  @override
  String get forgotPassword => 'Password Bhool Gaye?';

  @override
  String get sendResetLink => 'Reset Link Bhejein';

  @override
  String get backToSignIn => 'Sign In Par Wapas';

  @override
  String get dontHaveAccount => 'Account nahi hai?';

  @override
  String get alreadyHaveAccount => 'Pehle se account hai?';

  @override
  String get continueGoogle => 'Google Se Continue Karein';

  @override
  String get required => 'Zaroori';

  @override
  String get minSixChars => 'Kam se kam 6 characters';

  @override
  String get passwordsMismatch => 'Passwords match nahi karte';

  @override
  String get validEmailRequired => 'Valid email zaroori hai';

  @override
  String get loginFailed => 'Login fail hua';

  @override
  String get signupFailed => 'Signup fail hua';

  @override
  String get welcomeBack => 'Wapas Aapka Swagat Hai';

  @override
  String get todaysHoroscope => 'AAJ KA RASHIFAL';

  @override
  String get todaysRashi => 'Aaj Ki Rashi';

  @override
  String get tapDetails => 'Details ke liye tap karein';

  @override
  String get allServices => 'Sabhi Sevayein';

  @override
  String get seeAll => 'SABHI DEKHEIN';

  @override
  String get topAstrologers => 'Top Jyotishi';

  @override
  String get onlineExperts => 'Online experts consultation ke liye taiyar';

  @override
  String get searchAstrologers => 'Jyotishi khojein...';

  @override
  String get noAstrologersFound => 'Koi jyotishi nahi mila';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get busy => 'Busy';

  @override
  String get perMin => '/min';

  @override
  String get noCharts => 'Abhi koi janam kundli nahi';

  @override
  String get createFirst => 'Apni pehli Janam Kundli banayein';

  @override
  String get createChart => 'Kundli Banayein';

  @override
  String get newBirthChart => 'Nayi Janam Kundli';

  @override
  String get clientName => 'Naam';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Purush';

  @override
  String get female => 'Stri';

  @override
  String get other => 'Anya';

  @override
  String get dateOfBirth => 'Janam Tithi';

  @override
  String get timeOfBirth => 'Janam Samay';

  @override
  String get birthPlace => 'Janam Sthan';

  @override
  String get birthPlaceHint => 'City ka naam type karein...';

  @override
  String get generateKundli => 'Kundli Banayein';

  @override
  String get birthChartCreated => 'Janam kundli ban gayi!';

  @override
  String get deleteChart => 'Kundli Hatayein?';

  @override
  String get cannotUndo => 'Yeh wapas nahi hoga.';

  @override
  String get primary => 'PRIMARY';

  @override
  String get viewKundli => 'Kundli Dekhein';

  @override
  String get completeBirthChart => 'Poori Janam Kundli';

  @override
  String get birthDetails => 'Janam Vivaran';

  @override
  String get name => 'Naam';

  @override
  String get dob => 'Janam Tithi';

  @override
  String get tob => 'Janam Samay';

  @override
  String get place => 'Sthan';

  @override
  String get summary => 'Summary';

  @override
  String get planets => 'Grah';

  @override
  String get divisions => 'Vibhag';

  @override
  String get vimshottari => 'Vimshottari';

  @override
  String get moola => 'Moola';

  @override
  String get gochar => 'Gochar';

  @override
  String get dosh => 'Dosh';

  @override
  String get yoga => 'Yoga';

  @override
  String get shadbala => 'Shadbala';

  @override
  String get ashtakavarga => 'Ashtakavarga';

  @override
  String get aspects => 'Drishti';

  @override
  String get lifeAreas => 'Jeevan Kshetra';

  @override
  String get bhava => 'Bhava';

  @override
  String get chakras => 'Chakra';

  @override
  String get dashaActive => 'Dasha Active';

  @override
  String get lagna => 'Lagna';

  @override
  String get moon => 'Chandra';

  @override
  String get sun => 'Surya';

  @override
  String get premiumSection => 'Premium Section';

  @override
  String get unlockReading => 'Detailed analysis dekhne ke liye unlock karein.';

  @override
  String get unlock => 'Unlock';

  @override
  String get retrograde => 'Vakri';

  @override
  String get combust => 'Ast';

  @override
  String get vargottama => 'Vargottama';

  @override
  String get exalted => 'Uchcha';

  @override
  String get debilitated => 'Neech';

  @override
  String get addBalance => 'Balance Jodein';

  @override
  String get amount => 'Amount';

  @override
  String get walletBalance => 'Wallet Balance';

  @override
  String get recharge => 'Recharge';

  @override
  String get bonus => 'Bonus';

  @override
  String get serviceLabel => 'Seva';

  @override
  String get refund => 'Refund';

  @override
  String get noTransactions => 'Koi transaction nahi';

  @override
  String get editProfile => 'Profile Edit Karein';

  @override
  String get savedAstrologers => 'Save Kiye Jyotishi';

  @override
  String get noSavedAstrologers => 'Abhi koi saved jyotishi nahi';

  @override
  String get myOrders => 'Mere Orders';

  @override
  String get communicationHistory => 'Communication History';

  @override
  String get chatHistory => 'Chat History';

  @override
  String get callHistory => 'Call History';

  @override
  String get logout => 'Logout';

  @override
  String get chatMessages => 'Chat Messages';

  @override
  String get typeMessage => 'Message likhein...';

  @override
  String get sessionEnded => 'Session Khatam';

  @override
  String get endChat => 'Chat Khatam Karein?';

  @override
  String get endChatConfirm =>
      'Kya aap sach mein is chat session ko khatam karna chahte hain?';

  @override
  String get sendPhoto => 'Photo Bhejein';

  @override
  String get sendPDF => 'PDF Bhejein';

  @override
  String get upload => 'Upload';

  @override
  String get fileNotFound => 'File nahi mili';

  @override
  String get voiceCall => 'Voice Call';

  @override
  String get videoCall => 'Video Call';

  @override
  String get ringing => 'Ring ho rahi hai...';

  @override
  String get connected => 'CONNECTED';

  @override
  String get endCall => 'Call Khatam';

  @override
  String get mute => 'Mute';

  @override
  String get unmute => 'Unmute';

  @override
  String get speaker => 'Speaker';

  @override
  String get camera => 'Camera';

  @override
  String get flip => 'Flip';

  @override
  String get liveStreams => 'Live Streams';

  @override
  String get noLiveStreams => 'Abhi koi live stream nahi';

  @override
  String get astrologerUnavailable =>
      'Jyotishi available nahi. Stream khatam ho rahi hai.';

  @override
  String get streamEnded => 'Stream Khatam';

  @override
  String get superChat => 'Super Chat';

  @override
  String get sendGift => 'Gift Bhejein';

  @override
  String get goBack => 'Wapas Jayein';

  @override
  String get appPermissions => 'App Permissions';

  @override
  String get grantPermissions => 'Permissions Dein';

  @override
  String get skipForNow => 'Abhi Skip Karein';

  @override
  String get microphone => 'Microphone';

  @override
  String get notifications => 'Notifications';

  @override
  String get storage => 'Storage';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Phir Try Karein';

  @override
  String get send => 'Bhejein';

  @override
  String get refresh => 'Refresh';

  @override
  String get loading => 'Load ho raha hai...';

  @override
  String get noData => 'Koi data nahi mila';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get selectLanguage => 'Bhasha Chunein';

  @override
  String get language => 'Bhasha';

  @override
  String get english => 'English';

  @override
  String get myDetails => 'Meri Details';

  @override
  String get myKundlis => 'Meri Kundliyan';

  @override
  String get walletRecharge => 'Wallet & Recharge';

  @override
  String get consultationHistory => 'Consultation History';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get biometricLogin => 'Biometric Login';

  @override
  String get pastVoiceConsultations => 'Pichle voice consultations';

  @override
  String get pastTextConversations => 'Pichli text baatcheet';

  @override
  String get comingSoon => 'Jaldi aa raha hai';

  @override
  String get totalCredit => 'Total Credit';

  @override
  String get totalDebit => 'Total Debit';

  @override
  String get statement => 'Statement';

  @override
  String get allTypes => 'Sabhi Types';

  @override
  String get prev => 'Pichla';

  @override
  String get next => 'Agla';

  @override
  String get allInsights => 'Sabhi Insights';

  @override
  String get yourCompleteReading => 'AAPKA COMPLETE READING';

  @override
  String get expertEngines => 'expert engines';

  @override
  String get eachInsightConsultation =>
      'Har insight ek complete consultation hai';

  @override
  String get engines => 'ENGINES';

  @override
  String get dataPoints => 'DATA POINTS';

  @override
  String get singleChart => 'SINGLE';

  @override
  String get careerPurpose => 'CAREER & PURPOSE';

  @override
  String get wealthAssets => 'WEALTH & ASSETS';

  @override
  String get loveRelationships => 'LOVE & RELATIONSHIPS';

  @override
  String get healthWellness => 'HEALTH & WELLNESS';

  @override
  String get soulKarma => 'SOUL & KARMA';

  @override
  String get specialistReports => 'Specialist Reports';

  @override
  String get searchByNameSpeciality => 'Naam, speciality se khojein...';

  @override
  String get sortedByRating => 'Rating ke anusaar';

  @override
  String get initiatingChat => 'Chat shuru ho rahi hai...';

  @override
  String get startingCall => 'Call shuru ho rahi hai...';

  @override
  String get yrs => 'saal';

  @override
  String get chatWithAISpecialist => 'AI Specialist Se Chat Karein';

  @override
  String get tapToStart => 'Shuru karne ke liye tap karein';

  @override
  String get astrologer => 'Jyotishi';

  @override
  String get reports => 'Reports';

  @override
  String get milan => 'Milan';

  @override
  String get forecast => 'Forecast';

  @override
  String get rashi => 'Rashi';

  @override
  String get jupiterFavorsBold => 'Jupiter bold moves ko support karta hai';

  @override
  String get careerIlluminated =>
      'Aapka career sector illuminated hai — apni instinct par trust karein.';

  @override
  String get todaysForecast => 'Aaj Ka Forecast';

  @override
  String get engCareer => 'Career & Job';

  @override
  String get engBusiness => 'Business & Startup';

  @override
  String get engEducation => 'Shiksha & Learning';

  @override
  String get engLifePath => 'Life Path & Luck';

  @override
  String get engWealth => 'Dhan & Finance';

  @override
  String get engDebt => 'Karz & Recovery';

  @override
  String get engProperty => 'Property & Assets';

  @override
  String get engLegal => 'Legal & Vivaad';

  @override
  String get engLove => 'Love & Romance';

  @override
  String get engMarriage => 'Vivah & Parivaar';

  @override
  String get engKundliMilan => 'Kundli Milan';

  @override
  String get engRelationship => 'Relationship Intel';

  @override
  String get engLoveCompat => 'Love Compatibility';

  @override
  String get engChildProb => 'Santaan Probability';

  @override
  String get engHealth => 'Health & Wellness';

  @override
  String get engMental => 'Mental & Stress';

  @override
  String get engCharacter => 'Character Analysis';

  @override
  String get engPastLife => 'Past Life & Karma';

  @override
  String get engKarmaLink => 'Karma Linkage';

  @override
  String get noChatSessions => 'Abhi koi chat session nahi';

  @override
  String get chatAppearHere =>
      'Jyotishiyon ke saath aapki baatcheet yahan dikhegi.';

  @override
  String get noCallsYet => 'Abhi koi call nahi';

  @override
  String get callAppearHere =>
      'Jyotishiyon ke saath aapka call history yahan dikhega.';

  @override
  String get chatWith => 'Ke saath chat';

  @override
  String get msgs => 'msgs';

  @override
  String get voiceCallLabel => 'Voice call';

  @override
  String get videoCallLabel => 'Video call';

  @override
  String get pullToRefresh => 'Refresh karne ke liye neeche khenchein';

  @override
  String get sessionExpired => 'Session khatam';

  @override
  String get connectionFailed => 'Connection fail';

  @override
  String get callActive => 'Call active';

  @override
  String get lessThanOneMin => '1 minute se kam baaki';

  @override
  String get noMessages => 'Is session mein koi message nahi';

  @override
  String get gocharForAllSigns => 'Sabhi 12 rashiyon ka aaj ka gochar';

  @override
  String get selectChart => 'Analysis ke liye kundli chunein';

  @override
  String get selectTwoCharts => 'Do kundliyan chunein';

  @override
  String get analyzing => 'Analysis ho raha hai...';

  @override
  String get browseAstrologers => 'Jyotishi khojein';

  @override
  String get probableNumber => 'SAMBHAVIT SANKHYA';

  @override
  String get genderTendency => 'GENDER TENDENCY';

  @override
  String get son => 'BETA';

  @override
  String get daughter => 'BETI';

  @override
  String get occupants => 'OCCUPANTS';

  @override
  String get beneficAspects => 'SHUBH ASPECTS';

  @override
  String get maleficAspects => 'PAAP ASPECTS';

  @override
  String get nextFavorableWindow => 'AGLA FAVORABLE WINDOW';

  @override
  String get totalDoshaPenalty => 'TOTAL DOSHA PENALTY';

  @override
  String get cancellationFactors => 'CANCELLATION FACTORS';

  @override
  String get combinedFertility => 'COMBINED FERTILITY INDICATION';

  @override
  String get planetPositions => 'GRAH POSITIONS';

  @override
  String get bestWindows => 'BEST WINDOWS';

  @override
  String get worstWindows => 'WORST WINDOWS';

  @override
  String get scoreComponents => 'SCORE COMPONENTS';

  @override
  String get topOpportunities => 'TOP OPPORTUNITIES';

  @override
  String get topRisks => 'TOP RISKS';

  @override
  String get remedies => 'UPAAY';

  @override
  String get keyInsights => 'KEY INSIGHTS';

  @override
  String get overallVerdict => 'OVERALL VERDICT';

  @override
  String get venusContacts => 'SHUKRA CROSS CONTACTS';

  @override
  String get contact => 'Contact';

  @override
  String get effect => 'Effect';

  @override
  String get moonSignCompat => 'CHANDRA RASHI COMPATIBILITY';

  @override
  String get hisMoon => 'USKA CHANDRA';

  @override
  String get herMoon => 'USKA CHANDRA';

  @override
  String get nakshatraCompat => 'NAKSHATRA COMPATIBILITY';

  @override
  String get ketuContacts => 'KETU CONTACTS';

  @override
  String get rahuContacts => 'RAHU CONTACTS';

  @override
  String get pastLifeIndication => 'PAST LIFE INDICATION';

  @override
  String get totalChallengePenalty => 'TOTAL CHALLENGE PENALTY';

  @override
  String get manifestation => 'MANIFESTATION';

  @override
  String get cancellation => 'CANCELLATION';

  @override
  String get navigation => 'NAVIGATION';

  @override
  String get potentialStrengths => 'STRENGTHS';

  @override
  String get areasToNurture => 'NURTURE AREAS';

  @override
  String get relationshipGuidance => 'RELATIONSHIP GUIDANCE';

  @override
  String get detailedSummary => 'DETAILED SUMMARY';

  @override
  String get discussWithAI => 'AI SE DISCUSS KAREIN';

  @override
  String get planet => 'Grah';

  @override
  String get sign => 'Rashi';

  @override
  String get house => 'Bhav';

  @override
  String get strength => 'Bal';

  @override
  String get copy => 'COPY';

  @override
  String get confidence => 'CONFIDENCE';

  @override
  String get d7Saptamsa => 'D7 SAPTAMSA';

  @override
  String get numberExplanation => 'SANKHYA KA SPASHTIKARAN';

  @override
  String get genderExplanation => 'GENDER KA SPASHTIKARAN';

  @override
  String get inFifth => '5th mein?';

  @override
  String get primaryArchetype => 'PRIMARY ARCHETYPE';

  @override
  String get mitigation => 'MITIGATION';

  @override
  String get soulCareerAlign => 'Soul ↔ Career Alignment';

  @override
  String get favorablePeriods => 'Anukool Kaal';

  @override
  String get challengingPeriods => 'Chunautipurna Kaal';

  @override
  String get keyHouses => 'Key Houses';

  @override
  String get keyPlanets => 'Key Grah';

  @override
  String get characterOverview => 'Character Overview';

  @override
  String get noYogasActive => 'Is kundli mein abhi koi yoga active nahi.';

  @override
  String get basedOnPlanetStrengths =>
      'Grah bal aur bhav placement ke basis par';

  @override
  String get basedOnTransits => 'Current grah gochar ke basis par';

  @override
  String get currentPlanetPositions =>
      'Aapki rashi ko first house maante hue grah sthiti';

  @override
  String get favorablePeriodAdvice =>
      'Anukool kaal — career growth aur relationships par dhyaan dein.';

  @override
  String get noClassicalYogas =>
      'Classical yogas ke bina, safalta consistent effort se aati hai.';

  @override
  String get walletDeduction => 'Amount aapke wallet se kategi';

  @override
  String get bhakootAxis => 'BHAKOOT AXIS';

  @override
  String get basis => 'BASIS';

  @override
  String get selectChartsForMilan => 'Milan ke liye 2 kundliyan chunein';

  @override
  String get selectMultiCharts => '2-5 kundliyan chunein';

  @override
  String get running => 'RUNNING';

  @override
  String get past => 'beeta hua';

  @override
  String get topActiveDoshas => 'TOP ACTIVE DOSHAS';

  @override
  String get allDoshas => 'ALL DOSHAS';

  @override
  String get activeYogas => 'Active Yogas';

  @override
  String get activeDoshas => 'Active Doshas';

  @override
  String get yogaAnalysis => 'Yoga Analysis';

  @override
  String get factors => 'Factors';

  @override
  String get dominantPlanet => 'Dominant Grah';

  @override
  String get startSession => 'Session Shuru Karein';

  @override
  String get notesSaved => 'Notes save ho gaye';

  @override
  String get unlocked => 'Unlock ho gaya! Reading enjoy karein.';

  @override
  String get todaysGochar => 'Aaj Ka Gochar';

  @override
  String get todaysTransitChart => 'Aaj Ka Transit Chart';

  @override
  String get lifeAreaPredictions => 'Life Area Predictions';

  @override
  String get strengths => 'Khoobiyaan';

  @override
  String get weaknesses => 'Kamzoriyaan';

  @override
  String get ruledBy => 'Swami';

  @override
  String get kundliMilan => 'Kundli Milan';

  @override
  String get startKundliMilan => 'Kundli Milan Shuru Karein';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get cancellations => 'Cancellations';

  @override
  String get dashaSync => 'Dasha Sync';

  @override
  String get transitMarriageWindows => 'Transit Marriage Windows';

  @override
  String get overlappingWindows => 'Overlapping Marriage Windows';

  @override
  String get overallStrength => 'OVERALL STRENGTH';

  @override
  String get stability => 'STABILITY';

  @override
  String get growth => 'GROWTH';

  @override
  String get clarity => 'CLARITY';

  @override
  String get recognition => 'RECOGNITION';

  @override
  String get satisfaction => 'SATISFACTION';

  @override
  String get verdict => 'VERDICT';

  @override
  String get topRoles => 'TOP ROLES';

  @override
  String get areasForGrowth => 'AREAS FOR GROWTH';

  @override
  String get bestIndustries => 'BEST INDUSTRIES';

  @override
  String get employment => 'Employment';

  @override
  String get entrepreneurship => 'Entrepreneurship';

  @override
  String get freelance => 'Freelance';

  @override
  String get portfolio => 'Portfolio';

  @override
  String get burnoutRisk => 'Burnout Risk';

  @override
  String get careerStagnation => 'Career Stagnation';

  @override
  String get workplaceConflict => 'Workplace Conflict';

  @override
  String get positioning => 'POSITIONING';

  @override
  String get skillDevelopment => 'SKILL DEVELOPMENT';

  @override
  String get network => 'NETWORK';

  @override
  String get visibility => 'VISIBILITY';

  @override
  String get lagnaLord => 'Lagna Swami';

  @override
  String get tenthLord => '10th Swami';

  @override
  String get lord => 'SWAMI';

  @override
  String get lordPlacedIn => 'SWAMI YAHAN STHIT';

  @override
  String get lordDignity => 'SWAMI DIGNITY';

  @override
  String get d9Dignity => 'D9 DIGNITY';

  @override
  String get careerAnalysis => 'Career Analysis';

  @override
  String get launchWindows => 'Launch Windows';

  @override
  String get peakWindows => 'Peak Windows';

  @override
  String get promotionWindows => 'Promotion Windows';

  @override
  String get riskWindows => 'Risk Windows';

  @override
  String get timingWindows => 'Timing Windows';

  @override
  String get careerRisks => 'Career Risks';

  @override
  String get astrologicalRemedies => 'Jyotish Upay';

  @override
  String get practicalSolutions => 'Practical Solutions';

  @override
  String get analysisConfidence => 'Analysis Confidence';

  @override
  String get careerArchetype => 'Career Archetype';

  @override
  String get workStructure => 'Work Structure';

  @override
  String get teamLeadership => 'Team Leadership';

  @override
  String get idealEnvironment => 'Ideal Environment';

  @override
  String get idealOrgSize => 'Ideal Org Size';

  @override
  String get fitScore => 'FIT SCORE';

  @override
  String get recommended => 'RECOMMENDED';

  @override
  String get divisionalValidation => 'Divisional Validation';

  @override
  String get houseAnalysis => 'House Analysis';

  @override
  String get jaiminiKarakas => 'Jaimini Karakas';

  @override
  String get copyFullReport => 'Poori report copy karein';

  @override
  String get reportCopied => 'Report copy ho gayi!';

  @override
  String get biometricNotAvailable =>
      'Is device par biometric available nahi hai';

  @override
  String biometricErrorMsg(Object error) {
    return 'Biometric error: $error';
  }

  @override
  String get biometricVerifyReason =>
      'Biometric login enable karne ke liye verify karein';

  @override
  String get dobFormatLabel => 'DOB (DD/MM/YYYY)';

  @override
  String get tobFormatLabel => 'TOB (HH:MM)';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get activeBadge => 'ACTIVE';

  @override
  String get chartCategoryLabel => 'Category';

  @override
  String get freePrimaryDescription =>
      'Free Primary — daily horoscope aur free single-chart services ke liye use hota hai';

  @override
  String get searchChartsHint => 'Naam ya janam tithi se search karein...';

  @override
  String unlockPriceLabel(Object price) {
    return '$price mein unlock karein';
  }

  @override
  String unlockAiSpecialistIntl(Object price) {
    return 'Is AI specialist ko $price mein (ek baar) unlock karein, jo app store ke through securely purchase hota hai.';
  }

  @override
  String unlockAiSpecialistWallet(Object price) {
    return 'Is AI specialist ko $price mein (ek baar) unlock karein. Amount aapke wallet se deduct ho jayega.';
  }

  @override
  String get specialistNotAvailablePurchase =>
      'Yeh specialist abhi purchase ke liye available nahi hai.';

  @override
  String get couldNotCompletePurchase =>
      'Purchase complete nahi ho paya. Please phir try karein.';

  @override
  String get couldNotUnlockWalletBalance =>
      'Unlock nahi ho paya (wallet balance check karein)';

  @override
  String get freeBadge => 'FREE';

  @override
  String activeSessionInProgress(Object kind) {
    return 'Aapka ek active $kind chal raha hai';
  }

  @override
  String get returnLabel => 'Return';

  @override
  String get enableNotificationsForAlerts =>
      'Consultation aur offer alerts pane ke liye notifications enable karein';

  @override
  String get enableLabel => 'Enable Karein';

  @override
  String get notificationsEnabled => 'Notifications enable ho gaye';

  @override
  String get couldNotEnableNotifications =>
      'Enable nahi ho paya — apne browser mein notifications allow karein';

  @override
  String get amountInrLabel => 'Amount (₹)';

  @override
  String get noteOptionalLabel => 'Note (optional)';

  @override
  String get txnDate => 'DATE';

  @override
  String get txnDescription => 'DESCRIPTION';

  @override
  String get txnType => 'TYPE';

  @override
  String get txnAmount => 'AMOUNT';

  @override
  String get txnBalance => 'BALANCE';

  @override
  String get credit => 'Credit';

  @override
  String get debit => 'Debit';

  @override
  String get razorpayStripeNote =>
      '💳 Production mein yeh Razorpay/Stripe par redirect hoga.';

  @override
  String get downloadPdf => 'PDF Download Karein';

  @override
  String get chatWithAiCta => 'AI se Chat Karein';

  @override
  String get pdfServiceUnavailable =>
      'PDF service abhi temporarily unavailable hai. Please baad mein try karein.';

  @override
  String get pleaseUnlockFirst => 'Please pehle isse unlock karein.';

  @override
  String get couldNotGeneratePdf =>
      'PDF generate nahi ho paya. Please phir try karein.';

  @override
  String get statConsults => 'CONSULTS';

  @override
  String get statCharts => 'CHARTS';

  @override
  String get statWallet => 'WALLET';

  @override
  String get firstChartPrimaryInfo =>
      'Aapka pehla chart aapka free Primary hai. Extra charts individually services unlock karte hain.';

  @override
  String get tryDifferentFilter => 'Ek alag filter try karein';

  @override
  String get defaultChartName => 'Chart';

  @override
  String get balAbbr => 'Bal';
}
