// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get awChooseLanguage => 'Choose your language';

  @override
  String get awGoogleFailed => 'Google sign-in failed. Please try again.';

  @override
  String get awCompleteProfileTitle => 'Complete your profile';

  @override
  String awWelcomeName(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get awCompleteProfileSubtitle =>
      'A couple of details to personalize Nakshatralogy for you.';

  @override
  String get awRegionLabel => 'Region';

  @override
  String get awRegionIndia => 'India';

  @override
  String get awRegionInternational => 'International';

  @override
  String get awPreferredLanguage => 'Preferred language';

  @override
  String get awFinishSetup => 'Finish setup';

  @override
  String get awChatFileWebUnsupported =>
      'File sharing isn\'t available on web yet. Please use the mobile app.';

  @override
  String get awVideoUnsupported =>
      'Video calls aren\'t supported in this browser. Please use our mobile app or a supported desktop browser.';

  @override
  String get awClose => 'Close';

  @override
  String get pwPremiumTitle => 'பிரீமியம் அறிக்கை';

  @override
  String get pwLockedSubtitle =>
      'இந்த ஜாதகத்தின் முழு பகுப்பாய்வை அன்லாக் செய்யுங்கள்';

  @override
  String pwUnlockFull(Object name) {
    return 'முழு $name ஐ அன்லாக் செய்யுங்கள்';
  }

  @override
  String pwUnlockPrice(Object price) {
    return 'அன்லாக் · $price';
  }

  @override
  String get pwOneTime =>
      'ஒருமுறை அன்லாக் — இந்த ஜாதகத்தில் நிரந்தரமாக உங்களுக்கு';

  @override
  String get pwWhatYouGet => 'நீங்கள் பெறுவது';

  @override
  String get pwYourBalance => 'உங்கள் வாலட் இருப்பு';

  @override
  String get pwInsufficient => 'போதுமான இருப்பு இல்லை';

  @override
  String get pwRechargeToUnlock => 'அன்லாக் செய்ய ரீசார்ஜ் செய்யுங்கள்';

  @override
  String get pwRechargeAmount => 'ரீசார்ஜ் தொகை (₹)';

  @override
  String get pwAddMoney => 'பணம் சேர்க்கவும்';

  @override
  String get pwRechargeDone => 'வாலட் ரீசார்ஜ் செய்யப்பட்டது';

  @override
  String get pwRechargeFailed =>
      'ரீசார்ஜ் தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get pwUnlockFailed =>
      'அன்லாக் செய்ய முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get pwUnlockedNow => 'அன்லாக் ஆனது! உங்கள் அறிக்கை ஏற்றப்படுகிறது…';

  @override
  String get pwProcessing => 'செயலாக்கப்படுகிறது…';

  @override
  String get pwPrimaryNoDelete =>
      'உங்கள் முதன்மை குண்டலியை நீக்க முடியாது — இது எப்போதும் இலவசம்.';

  @override
  String get pwPrimaryNoEdit => 'உங்கள் முதன்மை குண்டலியை திருத்த முடியாது.';

  @override
  String get pwLoadingAccess => 'அணுகல் சரிபார்க்கப்படுகிறது…';

  @override
  String get pwMaybeLater => 'பின்னர் பார்க்கலாம்';

  @override
  String get updatePhoto => 'புகைப்படத்தைப் புதுப்பிக்கவும்';

  @override
  String get takePhoto => 'கேமரா';

  @override
  String get chooseFromGallery => 'கேலரி';

  @override
  String get removePhoto => 'புகைப்படத்தை அகற்று';

  @override
  String get photoUpdated => 'புகைப்படம் புதுப்பிக்கப்பட்டது';

  @override
  String get photoUploadFailed =>
      'புகைப்படத்தை பதிவேற்ற முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get tapToChangePhoto => 'புகைப்படத்தை மாற்ற தட்டவும்';

  @override
  String get klSubtitle => 'AI-இயக்கும் வேத முன்வினை கர்ம தொடர்பு அறிக்கை';

  @override
  String get klTitle => 'முன்வினை கர்ம தொடர்பு';

  @override
  String get klSnapshotHeader => 'கர்ம தொடர்பு சுருக்கம்';

  @override
  String get klGaugePairwise => 'சராசரி இரட்டைத் தொடர்பு';

  @override
  String get klGaugeCohesion => 'குழு ஒற்றுமை';

  @override
  String get klGaugeRahuKetu => 'ராகு-கேது எதிரொலி';

  @override
  String get klGaugeAtmakaraka => 'ஆத்மா எதிரொலி';

  @override
  String get klGaugeD60 => 'D60 எதிரொலி';

  @override
  String get klChipSoulResonance => 'வலுவான ஆத்மா-அடையாள எதிரொலி';

  @override
  String get klChipD60Resonance => 'வலுவான D60 முன்வினை எதிரொலி';

  @override
  String get klChipCohesiveGroup => 'ஒற்றுமையான குழு';

  @override
  String get klChipNoDebts => 'கர்ம கடன்கள் எதுவும் இல்லை';

  @override
  String get klProfilesTitle => 'ஜாதக விவரங்கள்';

  @override
  String get klKetuAt => 'கேது இருக்கும் இடம்';

  @override
  String get klRahuAt => 'ராகு இருக்கும் இடம்';

  @override
  String get klFoundationTitle => 'ஒவ்வொரு ஜாதகத்திற்குமான கர்ம அடிப்படை';

  @override
  String get klFoundationSubtitle =>
      'ஒவ்வொரு ஆத்மாவின் முன்வினைத் திறமையும் தற்போதைய வாழ்க்கை திசையும்';

  @override
  String get klKetuMastery => 'கேது தேர்ச்சி';

  @override
  String get klRahuGrowth => 'ராகு வளர்ச்சி';

  @override
  String get klNinthHousePunya => '9ஆம் வீட்டு புண்ணியம்';

  @override
  String get klD60Depth => 'D60 கர்ம ஆழம்';

  @override
  String get klAtmakarakaAgenda => 'ஆத்மாவின் நோக்கம்';

  @override
  String get klSaturnKarma => 'சனி கர்மா';

  @override
  String get klPairwiseTitle => 'இரட்டை கர்ம தொடர்புகள்';

  @override
  String get klActiveFactors => 'செயலில் உள்ள தொடர்பு காரணிகள்';

  @override
  String get klGroupPatternTitle => 'குழு கர்ம வடிவம்';

  @override
  String get klSharedSetting => 'பகிரப்பட்ட முன்வினை பின்னணி';

  @override
  String get klCohesionScore => 'கர்ம ஒற்றுமை';

  @override
  String get klPastGoalsTitle => 'முன்வினை இலக்குகள்';

  @override
  String get klLearningTitle => 'தற்போதைய வாழ்க்கை கற்றல்';

  @override
  String get klTeachingMap => 'பரஸ்பர கற்பித்தல் வரைபடம்';

  @override
  String get klDebtsTitle => 'கர்ம கடன்களும் தீர்வுகளும்';

  @override
  String get klNoDebtsDetected =>
      'இந்த குழுவில் கர்ம கடன்கள் எதுவும் கண்டறியப்படவில்லை';

  @override
  String get klTimingTitle => 'மூல தசை கர்ம நேரம்';

  @override
  String get klAuditTitle => 'ஆழ்ந்த ஆய்வு அட்டவணை';

  @override
  String klAuditSubtitle(Object count) {
    return '$count கர்ம அளவுருக்கள் ஆய்வு செய்யப்பட்டன';
  }

  @override
  String get klTopicLinkage => 'எங்கள் ஒட்டுமொத்த கர்ம தொடர்பு';

  @override
  String get klTopicPairwise => 'ஒரு குறிப்பிட்ட ஜோடியின் கர்ம பிணைப்பு';

  @override
  String get klTopicDebts => 'தீர்க்க வேண்டிய கர்ம கடன்கள்';

  @override
  String get klTopicLessons => 'நாங்கள் இங்கே கற்க வந்தது என்ன';

  @override
  String get klTopicTiming => 'எங்கள் குழுவிற்கான சிறந்த நேரம்';

  @override
  String get klTopicGroup => 'எங்கள் பகிரப்பட்ட முன்வினை கதை';

  @override
  String get lcSubtitle => 'AI-இயங்கும் வேத காதல் பொருத்தம் அறிக்கை';

  @override
  String get lcTitle => 'காதல் பொருத்தம்';

  @override
  String get lcSnapshotHeader => 'காதல் பொருத்த சுருக்கம்';

  @override
  String get lcGaugeAttraction => 'ஈர்ப்பு';

  @override
  String get lcGaugeEmotional => 'உணர்வுப் பொருத்தம்';

  @override
  String get lcGaugeMental => 'மனப் பொருத்தம்';

  @override
  String get lcGaugePassion => 'ஆர்வம்';

  @override
  String get lcGaugeLongterm => 'நீண்டகால பொருத்தம்';

  @override
  String get lcChipStrongMental => 'வலுவான மனப் பிணைப்பு';

  @override
  String get lcChipStrongLongterm => 'வலுவான நீண்டகால சாத்தியம்';

  @override
  String get lcChipStrongPassion => 'வலுவான உடல் ஈர்ப்பு';

  @override
  String get lcChipLowFriction => 'ஒட்டுமொத்தமாக குறைந்த முரண்பாடு';

  @override
  String get lcChipKarmicPull => 'வலுவான கர்ம ஈர்ப்பு';

  @override
  String get lcPartnersTitle => 'துணையினர் சுருக்கம்';

  @override
  String get lcVenusSuffix => 'சுக்ர ராசி';

  @override
  String get lcAttractionTitle => 'ஈர்ப்பு மற்றும் இணக்கம்';

  @override
  String get lcAttractionScore => 'ஈர்ப்பு மதிப்பெண்';

  @override
  String get lcActiveContacts => 'செயலில் உள்ள சுக்ர தொடர்புகள்';

  @override
  String get lcEmotionalTitle => 'உணர்வுப் பொருத்தம்';

  @override
  String get lcEmotionalScore => 'உணர்வுப் பொருத்த மதிப்பெண்';

  @override
  String get lcNakshatraCompat => 'நட்சத்திர பொருத்தம்';

  @override
  String get lcYoniKoota => 'யோனி கூடம்';

  @override
  String get lcGanaKoota => 'கண கூடம்';

  @override
  String get lcTaraKoota => 'தாரா கூடம்';

  @override
  String get lcBhakootAxis => 'பகூட் அச்சு';

  @override
  String get lcMentalTitle => 'மனப் பொருத்தம்';

  @override
  String get lcMentalScore => 'மனப் பொருத்த மதிப்பெண்';

  @override
  String get lcPassionTitle => 'ஆர்வம் & உடல் ரீதியானது';

  @override
  String get lcPassionScore => 'ஆர்வ மதிப்பெண்';

  @override
  String get lcLongtermTitle => 'நீண்டகால பொருத்தம்';

  @override
  String get lcLongtermScore => 'நீண்டகால பொருத்த மதிப்பெண்';

  @override
  String get lcCommitmentPotential => 'அர்ப்பணிப்பு சாத்தியம்';

  @override
  String get lc7thHouseSynastry => '7வது பாவ சினாஸ்ட்ரி';

  @override
  String get lcJupiterBlessing => 'குரு ஆசி';

  @override
  String get lcD9Resonance => 'D9 நவாம்ச எதிரொலி';

  @override
  String get lcSaturnLongevity => 'சனி நீளாயுள்';

  @override
  String get lcKarmicTitle => 'கர்ம காதல் பிணைப்பு';

  @override
  String get lcKarmicScore => 'கர்ம பிணைப்பு மதிப்பெண்';

  @override
  String get lcKetuContacts => 'கேது தொடர்புகள்';

  @override
  String get lcRahuContacts => 'ராகு தொடர்புகள்';

  @override
  String get lcChallengesTitle => 'சவால்கள் & முரண்பாடுகள்';

  @override
  String get lcNoChallenges =>
      'இரு ஜாதகங்களிலும் குறிப்பிடத்தக்க முரண்பாடு எதுவும் இல்லை';

  @override
  String get lcTotalPenalty => 'மொத்த சவால் அபராதம்';

  @override
  String get lcTimingTitle => 'காதல் நேரம் — மூல தசை';

  @override
  String get lcDynamicsTitle => 'உறவு இயக்கவியல்';

  @override
  String get lcPowerBalance => 'அதிகார சமநிலை';

  @override
  String get lcGiverReceiver => 'உணர்வு ரீதியான கொடுப்பவர்/பெறுபவர்';

  @override
  String get lcGrowthDynamic => 'வளர்ச்சி இயக்கவியல்';

  @override
  String get lcAreasToNurture => 'கவனிக்க வேண்டிய பகுதிகள்';

  @override
  String get lcTopicTiming => 'நமது உறவுக்கான சிறந்த நேரம்';

  @override
  String get lcTopicChallenges => 'சமாளிக்க வேண்டிய சவால்கள்';

  @override
  String get lcTopicKarmic => 'நமது கர்ம தொடர்பு';

  @override
  String get lcTopicRemedies => 'பரிந்துரைக்கப்பட்ட பரிகாரங்கள்';

  @override
  String get lcTopicLongterm => 'நமது நீண்டகால சாத்தியம்';

  @override
  String get lcTopicDynamics => 'நமது உறவு இயக்கவியல்';

  @override
  String get cpSubtitle => 'AI-இயக்கும் வேத குழந்தை பேறு சாத்தியக்கூறு அறிக்கை';

  @override
  String get cpTitle => 'குழந்தை பேறு சாத்தியக்கூறு';

  @override
  String get cpSnapshotHeader => 'குழந்தை பேறு சாத்தியக்கூறு சுருக்கம்';

  @override
  String get cpGauge5thHouse => '5ஆம் பாவம்';

  @override
  String get cpGaugeJupiter => 'குரு/புத்திரகாரகன்';

  @override
  String get cpGaugeD7 => 'D7 சப்தாம்சம்';

  @override
  String get cpGaugeSphuta => 'பீஜ-க்ஷேத்ரம்';

  @override
  String get cpGaugeTiming => 'தசா காலநேரம்';

  @override
  String get cpChipStrongPutrakaraka => 'வலிமையான புத்திரகாரகன் (குரு)';

  @override
  String get cpChipLowDoshaPenalty => 'குறைந்த தோஷ தாக்கம்';

  @override
  String get cpChipFavorableTiming => 'சாதகமான தசா காலநேரம்';

  @override
  String get cpChipNoDoshas => 'குழந்தை-தோஷங்கள் எதுவும் இல்லை';

  @override
  String get cpPartnersTitle => 'துணையின் சுருக்கம்';

  @override
  String get cpLagnaSuffix => 'லக்னம்';

  @override
  String get cpMoonSuffix => 'சந்திர ராசி';

  @override
  String get cpNumberTitle => 'குழந்தைகளின் எண்ணிக்கை & பாலின போக்கு';

  @override
  String get cpProbableNumber => 'சாத்தியமான எண்ணிக்கை';

  @override
  String get cpFirstChildTendency => 'முதல் குழந்தை போக்கு';

  @override
  String get cpSpacing => 'இடைவெளி குறிப்பு';

  @override
  String get cpTimingTitle => 'காலநேரம் — மூல தசா';

  @override
  String get cpCombinedTiming => 'இணைந்த காலநேரம்';

  @override
  String get cpNextWindow => 'அடுத்த சாதகமான காலகட்டம்';

  @override
  String get cp5thHouseTitle => '5ஆம் பாவ பகுப்பாய்வு';

  @override
  String get cp5thHouseSubtitle =>
      'குழந்தைகளின் பாவம் (புத்திர பாவம்), ஒவ்வொருவருக்கும்';

  @override
  String get cpJupiterTitle => 'குரு — புத்திரகாரக பகுப்பாய்வு';

  @override
  String get cpJupiterSubtitle =>
      'குழந்தைகளின் இயற்கை காரகன், ஒவ்வொருவருக்கும்';

  @override
  String get cpD7Title => 'D7 சப்தாம்ச பகுப்பாய்வு';

  @override
  String get cpD7Subtitle => 'குழந்தைகளுக்கென தனிப்பட்ட வர்க்க கட்டம்';

  @override
  String get cpD7Strength => 'D7 வலிமை';

  @override
  String get cpSphutaTitle => 'பீஜ & க்ஷேத்ர ஸ்புடம்';

  @override
  String get cpBeejaSphuta => 'பீஜ ஸ்புடம் (விதை)';

  @override
  String get cpKshetraSphuta => 'க்ஷேத்ர ஸ்புடம் (நிலம்)';

  @override
  String get cpDoshaTitle => 'தோஷ பகுப்பாய்வு';

  @override
  String get cpNoDoshasDetected =>
      'இரு ஜாதகங்களிலும் குழந்தை தொடர்பான தோஷங்கள் எதுவும் இல்லை';

  @override
  String get cpRemediesTitle => 'பரிந்துரைக்கப்பட்ட பரிகாரங்கள்';

  @override
  String get cpAddresses => 'தீர்வளிக்கும்';

  @override
  String get cpTopicTiming => 'கருத்தரிப்பதற்கான சிறந்த காலநேரம்';

  @override
  String get cpTopicNumber => 'நமக்கு எத்தனை குழந்தைகள் இருக்கலாம்';

  @override
  String get cpTopicDosha => 'தீர்வு காணவேண்டிய தோஷங்கள்';

  @override
  String get cpTopicRemedies => 'பரிந்துரைக்கப்பட்ட பரிகாரங்கள்';

  @override
  String get cpTopicFifthHouse => 'நமது 5ஆம் பாவ வலிமை';

  @override
  String get cpTopicJupiter => 'இதில் குருவின் பங்கு';

  @override
  String get riSubtitle => 'AI-இயக்கும் வேத உறவு நுண்ணறிவு அறிக்கை';

  @override
  String get riTitle => 'உறவு நுண்ணறிவு';

  @override
  String get riSnapshotHeader => 'குழு சுருக்கம்';

  @override
  String get riGaugeCohesion => 'குழு ஒற்றுமை';

  @override
  String get riGaugeTrust => 'நம்பிக்கை சூழல்';

  @override
  String get riGaugeProductivity => 'உற்பத்தித்திறன்';

  @override
  String get riGaugeCreativity => 'படைப்பாற்றல்';

  @override
  String get riChipNoAlerts => 'முக்கிய எச்சரிக்கைகள் இல்லை';

  @override
  String get riChipStrongCohesion => 'வலுவான குழு ஒற்றுமை';

  @override
  String get riChipHighTrust => 'உயர் நம்பிக்கை சூழல்';

  @override
  String get riChipNoHiddenEnemy => 'மறைமுக-எதிரி சமிக்ஞை இல்லை';

  @override
  String get riChipHealthyGroup => 'மொத்தத்தில் ஆரோக்கியமான குழு';

  @override
  String get riProfilesTitle => 'ஜாதக விவரங்கள்';

  @override
  String riProfilesSubtitle(Object count) {
    return 'இந்தக் குழுவில் $count பேர்';
  }

  @override
  String get riLagnaSuffix => 'லக்னம்';

  @override
  String get riIntegrity => 'நேர்மை';

  @override
  String get riWarmth => 'அன்பு';

  @override
  String get riTrustworthiness => 'நம்பகத்தன்மை';

  @override
  String get riAssertiveness => 'உறுதி';

  @override
  String get riGroupDynamicsTitle => 'குழு இயக்கவியல் மேலோட்டம்';

  @override
  String get riMostSupportive => 'மிகவும் ஆதரவானவர்';

  @override
  String get riMostChallenged => 'மிகவும் சவாலானது';

  @override
  String get riHiddenEnemyAlert => 'மறைமுக-எதிரி சமிக்ஞை கண்டறியப்பட்டது';

  @override
  String get riBestWorstTitle => 'சிறந்த & மிகவும் சவாலான ஜோடிகள்';

  @override
  String get riBestPair => 'மிக வலுவான பிணைப்பு';

  @override
  String get riWorstPair => 'கவனம் தேவை';

  @override
  String get riAlliances => 'சாத்தியமான கூட்டணிகள்';

  @override
  String get riConflicts => 'சாத்தியமான உராய்வு புள்ளிகள்';

  @override
  String get riPairwiseTitle => 'ஜோடி வாரியான பகுப்பாய்வு';

  @override
  String riPairwiseSubtitle(Object count) {
    return '$count ஜோடிகள் பகுப்பாய்வு செய்யப்பட்டன';
  }

  @override
  String get riDynamic => 'இயக்கவியல்';

  @override
  String get riKarmicLink => 'கர்ம தொடர்பு';

  @override
  String get riMutualTrust => 'பரஸ்பர நம்பிக்கை';

  @override
  String get riBetrayalRisk => 'துரோக அபாயம்';

  @override
  String get riPowerDistribution => 'அதிகார பங்கீடு';

  @override
  String get riPowerHealth => 'அதிகார-சமநிலை ஆரோக்கியம்';

  @override
  String get riCriticalPatternsTitle => 'முக்கிய வடிவங்கள்';

  @override
  String get riGroupRecsTitle => 'குழு பரிந்துரைகள்';

  @override
  String get riSharedPractices => 'பகிரப்பட்ட நடைமுறைகள்';

  @override
  String get riCommStyle => 'பரிந்துரைக்கப்பட்ட தொடர்பு பாணி';

  @override
  String get riGrowthFocus => 'பரிந்துரைக்கப்பட்ட வளர்ச்சி மையம்';

  @override
  String get riIndividualTitle => 'தனிநபர் வழிகாட்டுதல்';

  @override
  String get riBestAllies => 'சிறந்த கூட்டாளிகள்';

  @override
  String get riHandleWithCare => 'கவனமாக கையாளவும்';

  @override
  String get riCoreThemeTitle => 'முக்கிய குழு கருப்பொருள்';

  @override
  String get riLayerPairwise => 'ஜோடி வாரியான முழுமை';

  @override
  String get riLayerD1 => 'ஜென்ம ஜாதகம் (D1)';

  @override
  String get riLayerD9 => 'நவாம்சம் (D9)';

  @override
  String get riLayerD10 => 'தசாம்சம் (D10)';

  @override
  String get riLayerD30 => 'திரிம்சாம்சம் (D30)';

  @override
  String get riLayerJaimini => 'ஜைமினி சமிக்ஞை';

  @override
  String get riLayerBehavior => 'நடத்தை தெளிவு';

  @override
  String get riLayerCoherence => 'குழு ஒருங்கிணைப்பு';

  @override
  String get riTopicDynamics => 'எங்கள் குழு இயக்கவியல்';

  @override
  String get riTopicPairwise => 'ஒரு குறிப்பிட்ட ஜோடியின் பொருத்தம்';

  @override
  String get riTopicAlerts => 'ஏதேனும் முக்கிய எச்சரிக்கைகள்';

  @override
  String get riTopicGrowth => 'நாங்கள் ஒன்றாக எவ்வாறு வளரலாம்';

  @override
  String get riTopicRecs => 'பரிந்துரைக்கப்பட்ட நடைமுறைகள்';

  @override
  String get riTopicTheme => 'எங்கள் முக்கிய குழு கருப்பொருள்';

  @override
  String get kmSubtitle => 'AI-இயக்கப்படும் வேத குண்டலி மிலன் அறிக்கை';

  @override
  String get kmTitle => 'குண்டலி மிலன்';

  @override
  String get kmSnapshotHeader => 'இணக்கத்தன்மை சுருக்கம்';

  @override
  String kmAshtakootScore(Object score) {
    return 'அஷ்டகூடம்: $score/36';
  }

  @override
  String get kmGaugeAshtakoot => 'அஷ்டகூடம் %';

  @override
  String get kmGaugeD9 => 'D9 திருமண கர்மா';

  @override
  String get kmGaugeMangal => 'செவ்வாய் சமநிலை';

  @override
  String get kmGaugePapa => 'கர்ம சமநிலை';

  @override
  String get kmGaugeAk => 'ஆத்ம எதிரொலி';

  @override
  String get kmChipNoNadi => 'நாடி தோஷம் இல்லை';

  @override
  String get kmChipNoBhakoot => 'பகூட தோஷம் இல்லை';

  @override
  String get kmChipMangalCancelled => 'செவ்வாய் தோஷம் ரத்து';

  @override
  String get kmChipPapaBalanced => 'சமநிலையான கர்ம சுமை';

  @override
  String get kmChipStrongChemistry => 'வலுவான உடல் இணக்கம்';

  @override
  String get kmChipStrongD9 => 'வலுவான D9 திருமண கர்மா';

  @override
  String get kmChipLongevity => 'வலுவான ஆயுள் இணக்கம்';

  @override
  String get kmAshtakootTitle => 'அஷ்டகூட குண மிலன்';

  @override
  String get kmAshtakootSubtitle => '36-இல் பாரம்பரிய 8-புள்ளி பொருத்த முறை';

  @override
  String get kmNadiSeverity => 'நாடி தீவிரம்';

  @override
  String get kmBhakootSeverity => 'பகூட தீவிரம்';

  @override
  String get kmGanaSignature => 'கண சிறப்பியல்பு';

  @override
  String get kmMangalTitle => 'செவ்வாய் தோஷ சோதனை';

  @override
  String get kmD9Title => 'D9 நவாம்சம் — திருமண கர்மா';

  @override
  String get kmD9Subtitle =>
      'ஆத்ம நிலை திருமண ஜாதகம், பாரம்பரியமாக மிக முக்கியமானதாகக் கருதப்படுகிறது';

  @override
  String get kmD9Score => 'D9 இணக்கத்தன்மை';

  @override
  String get kmLagnaRelation => 'லக்ன தொடர்பு';

  @override
  String get km7thLordRelation => '7ஆம் இடத்தின் அதிபதி தொடர்பு';

  @override
  String get kmKarakasTitle => 'ஆத்மா & துணை காரகர்கள்';

  @override
  String get kmAtmakaraka => 'ஆத்ம கிரகம்';

  @override
  String get kmAkCompatibility => 'ஆத்ம-சிறப்பியல்பு எதிரொலி';

  @override
  String get kmUlCompatibility => 'துணை-காரக இணக்கம்';

  @override
  String get kmUlSigns => 'உபபத அதிபதிகள்';

  @override
  String get kmChemistryTitle => 'சுக்ரன்-செவ்வாய் இணக்கம்';

  @override
  String get kmPhysicalChemistry => 'உடல் இணக்கம்';

  @override
  String get kmEmotionalWarmth => 'உணர்ச்சி அன்பு';

  @override
  String get kmAestheticAlignment => 'அழகியல் இணக்கம்';

  @override
  String get kmElementalSynthesis => 'தத்துவ ஒருங்கிணைப்பு';

  @override
  String get kmHouseCrossTitle => '7 & 8 ஆம் இடங்களின் ஒப்பீட்டு பகுப்பாய்வு';

  @override
  String get km78Compatibility => '7-8 ஆம் இட இணக்கம்';

  @override
  String get km8thHouseSignature => 'இணைந்த ஆயுள் சிறப்பியல்பு';

  @override
  String get kmLongevityAlignment => 'ஆயுள் இணக்கம்';

  @override
  String get km7thLordFriendship => '7ஆம் அதிபதி நட்பு';

  @override
  String get kmDomainsTitle => 'பிரிவு வாரியான இணக்கத்தன்மை';

  @override
  String get kmConflictEngagement => 'மோதல் பாணி';

  @override
  String get kmDashaTitle => 'தசை & கோச்சார ஒத்திசைவு';

  @override
  String get kmDashaSync => 'தசை ஒத்திசைவு';

  @override
  String get kmTransitAlignment => 'கோச்சார இணக்கம்';

  @override
  String get kmTimingTitle => 'திருமண காலம்';

  @override
  String get kmMarriageWindow => 'திருமண காலவரம்பு';

  @override
  String get kmEngagementWindow => 'நிச்சயதார்த்த காலவரம்பு';

  @override
  String get kmRecommendedRange => 'பரிந்துரைக்கப்படும் காலம்';

  @override
  String get kmMuhurtaNotes => 'முகூர்த்த குறிப்புகள்';

  @override
  String get kmRisksTitle => 'கவனிக்க வேண்டிய அபாயங்கள்';

  @override
  String get kmConflictRisk => 'மோதல் அபாயம்';

  @override
  String get kmCommunicationRisk => 'தொடர்பு அபாயம்';

  @override
  String get kmFinanceRisk => 'நிதி மோதல் அபாயம்';

  @override
  String get kmFamilyDynamicsRisk => 'குடும்ப இயக்கவியல் அபாயம்';

  @override
  String get kmMentalHealthRisk => 'மனநல இணக்க அபாயம்';

  @override
  String get kmStrengthsTitle => 'முதன்மை இணக்கத்தன்மை பலங்கள்';

  @override
  String get kmSharedGrowth => 'பகிரப்பட்ட வளர்ச்சி திறன்';

  @override
  String get kmSharedCreative => 'பகிரப்பட்ட படைப்பாற்றல் திறன்';

  @override
  String get kmJourneyTitle => 'உறவின் பயணமும் வளர்ச்சியும்';

  @override
  String get kmCurrentPhase => 'தற்போதைய கட்டம்';

  @override
  String get kmEarlyArc => 'ஆரம்ப திருமணம்';

  @override
  String get kmMiddleArc => 'நடுத்தர திருமணம்';

  @override
  String get kmMatureArc => 'முதிர்ந்த திருமணம்';

  @override
  String get kmElderArc => 'மூத்த வயது ஆண்டுகள்';

  @override
  String get kmPeakPhase => 'உச்ச தோழமை கட்டம்';

  @override
  String get kmGrowthAreas => 'வளர்ச்சி பகுதிகள்';

  @override
  String get kmCommProtocols => 'தொடர்பு நெறிமுறைகள்';

  @override
  String get kmSharedPractices => 'பகிரப்பட்ட பழக்கவழக்கங்கள்';

  @override
  String get kmImprovementTitle => 'முக்கிய கருப்பொருள் & மேம்பாட்டுத் திட்டம்';

  @override
  String get kmVerdictTitle => 'இறுதி முடிவு';

  @override
  String get kmRealizationPotential => 'உறவு நிறைவேற்றும் திறன்';

  @override
  String get kmLayerAshtakoot => 'அஷ்டகூடம்';

  @override
  String get kmLayerD9 => 'D9 நவாம்சம்';

  @override
  String get kmLayerMangalPapa => 'செவ்வாய் & பாபசாம்யம்';

  @override
  String get kmLayerVenusMars => 'சுக்ரன்-செவ்வாய்';

  @override
  String get kmLayerDashaSync => 'தசை ஒத்திசைவு';

  @override
  String get kmLayerH7H8 => '7-8 ஆம் இட ஒப்பீடு';

  @override
  String get kmLayerAkResonance => 'ஆத்மகாரக எதிரொலி';

  @override
  String get kmLayerDomains => 'பிரிவு பரிமாணங்கள்';

  @override
  String get kmTopicAshtakoot => 'எங்கள் அஷ்டகூட மதிப்பெண்';

  @override
  String get kmTopicMangal => 'செவ்வாய் தோஷ கவலைகள்';

  @override
  String get kmTopicD9 => 'எங்கள் திருமண கர்மா (D9)';

  @override
  String get kmTopicTiming => 'சிறந்த திருமண காலம்';

  @override
  String get kmTopicRisks => 'தயாராக வேண்டிய அபாயங்கள்';

  @override
  String get kmTopicGrowth => 'நாங்கள் எப்படி ஒன்றாக வளரலாம்';

  @override
  String get kmTopicRemedies => 'பரிந்துரைக்கப்படும் பரிகாரங்கள்';

  @override
  String get kmTopicVerdict => 'நாங்கள் திருமணத்திற்கு முன்னேற வேண்டுமா';

  @override
  String get pkSubtitle => 'AI-இயக்கும் வேத பூர்வ ஜென்ம மற்றும் கர்ம அறிக்கை';

  @override
  String get pkTitle => 'பூர்வ ஜென்மம் மற்றும் கர்மா';

  @override
  String get pkSnapshotHeader => 'பூர்வ ஜென்ம சுருக்கம்';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return 'உங்கள் ஜாதகத்தில் \'$theme\' பூர்வ ஜென்ம முத்திரை உள்ளது, தற்போது இந்த ஜென்மத்தில் $relation ஆகி வருகிறது. பரிந்துரைக்கப்படும் பாதை: $strategy.';
  }

  @override
  String get pkGaugeSignature => 'முத்திரையின் வலிமை';

  @override
  String get pkGaugeMasteryPreserved => 'பாதுகாக்கப்பட்ட தேர்ச்சி';

  @override
  String get pkGaugeClearingProgress => 'கர்மா தெளிவாதல்';

  @override
  String get pkGaugeMaturity => 'பூர்வ ஜென்ம முதிர்ச்சி';

  @override
  String get pkGaugeMemoryAccess => 'நினைவக அணுகல்';

  @override
  String get pkChipGoodProgress => 'கர்மா தெளிவாதலில் நல்ல முன்னேற்றம்';

  @override
  String get pkChipLowDebt => 'குறைந்த கர்ம கடன்';

  @override
  String get pkChipMatureSoul => 'முதிர்ந்த ஆன்மா முத்திரை';

  @override
  String get pkChipGiftedPast => 'ஜாதகத்தில் பூர்வ ஜென்ம பரிசு உள்ளது';

  @override
  String get pkChipAccomplished => 'வெற்றிகரமான பூர்வ ஜென்மம்';

  @override
  String get pkChipMasteryPreserved => 'வலுவான தேர்ச்சி தொடர்ந்து வருகிறது';

  @override
  String get pkKetuTitle => 'கேது — உங்கள் பூர்வ ஜென்ம தேர்ச்சி';

  @override
  String get pkKetuSubtitle => 'உங்கள் ஆன்மா ஏற்கனவே கற்றுத்தேர்ந்த திறன்கள்';

  @override
  String get pkMasteryStrength => 'தேர்ச்சி வலிமை';

  @override
  String get pkSkillsCarried => 'தொடர்ந்து வரும் திறன்கள்';

  @override
  String get pkInstincts => 'இயல்பான திறன்கள்';

  @override
  String get pkKetuDignity => 'கேதுவின் நிலை';

  @override
  String get pkRahuTitle => 'ராகு — உங்கள் ஆன்மாவின் வளர்ச்சி பாதை';

  @override
  String get pkRahuSubtitle => 'உங்கள் ஆன்மா இங்கு எதை நிறைவேற்ற வந்துள்ளது';

  @override
  String get pkUnmetDesires => 'நிறைவேறாத விருப்பங்கள்';

  @override
  String get pkProfileTitle => 'உங்கள் பூர்வ ஜென்ம சுயவிவரம்';

  @override
  String get pkProfession => 'வாய்ப்புள்ள தொழில்';

  @override
  String get pkSocialStanding => 'சமூக அந்தஸ்து';

  @override
  String get pkRegion => 'வாய்ப்புள்ள பகுதி';

  @override
  String get pkCulturalArchetype => 'பண்பாட்டு வடிவம்';

  @override
  String get pkAccomplishment => 'சாதனை நிலை';

  @override
  String get pkAuthority => 'அதிகார நிலை';

  @override
  String get pkFamilyRole => 'குடும்ப பங்கு';

  @override
  String get pkSecondaryProfession => 'இரண்டாம் தொழில்';

  @override
  String get pkClimateAffinity => 'காலநிலை ஈடுபாடு';

  @override
  String get pkForeignResidence => 'வெளிநாடு-வாழ்வு கர்மா';

  @override
  String get pkRelationshipsTitle => 'தொடர்ந்து வரும் பழைய உறவுகள்';

  @override
  String get pkSpouseConnection => 'வாழ்க்கைத் துணை மறுஇணைப்பு';

  @override
  String get pkChildrenConnection => 'குழந்தைகள் மறுஇணைப்பு';

  @override
  String get pkCarriedRelationTypes => 'உறவு முறைகள்';

  @override
  String get pkPartnerArchetype => 'பூர்வ ஜென்ம துணை வடிவம்';

  @override
  String get pkDarakaraka => 'துணை காரகன்';

  @override
  String get pkParentsKarma => 'பெற்றோர் கர்ம முறை';

  @override
  String get pkSiblingKarma => 'உடன்பிறப்பு கர்ம முறை';

  @override
  String get pkSpiritualTitle => 'அப்போது உங்கள் ஆன்மீக வாழ்க்கை';

  @override
  String get pkSpiritualLevel => 'ஆன்மீக நிலை';

  @override
  String get pkPracticeSignature => 'சாதனை பாணி';

  @override
  String get pkMeditativeCapacity => 'தியான திறன்';

  @override
  String get pkDevotionalPractice => 'பக்தி சாதனை';

  @override
  String get pkYogicAttainment => 'யோக சாதனை';

  @override
  String get pkMokshaProximity => 'மோட்ச நெருக்கம்';

  @override
  String get pkKarmicDebtsTitle => 'கர்ம கடன்கள் மற்றும் அப்போதைய செல்வம்';

  @override
  String get pkTotalKarmicDebt => 'மொத்த கர்ம கடன்';

  @override
  String get pkPrimaryDebtType => 'முதன்மை கடன் வகை';

  @override
  String get pkRelationshipDebt => 'உறவு கடன்';

  @override
  String get pkFinancialDebt => 'நிதி கடன்';

  @override
  String get pkServiceDebt => 'சேவை கடன்';

  @override
  String get pkDharmicDebt => 'தர்ம கடன்';

  @override
  String get pkPitruKarma => 'பித்ரு கர்மா';

  @override
  String get pkMatruKarma => 'மாத்ரு கர்மா';

  @override
  String get pkWealthLevel => 'அப்போதைய செல்வ நிலை';

  @override
  String get pkWealthKarmaCarried => 'தொடர்ந்து வரும் செல்வ கர்மா';

  @override
  String get pkResourcePattern => 'வள மேலாண்மை';

  @override
  String get pkGainSource => 'லாப ஆதாரம்';

  @override
  String get pkEchoesTitle => 'இந்த வாழ்க்கையில் எதிரொலிகள்';

  @override
  String get pkOnRelationships => 'உறவுகளில்';

  @override
  String get pkOnCareer => 'தொழிலில்';

  @override
  String get pkOnHealth => 'ஆரோக்கியத்தில்';

  @override
  String get pkOnSpirituality => 'ஆன்மீகத்தில்';

  @override
  String get pkDominantArea => 'மிக வலிமையான தொடர்ச்சி';

  @override
  String get pkAttractions => 'இயல்பான ஈர்ப்புகள்';

  @override
  String get pkAversions => 'இயல்பான வெறுப்புகள்';

  @override
  String get pkUnexplainedFears => 'விளக்க முடியாத பயங்கள்';

  @override
  String get pkMagneticPulls => 'காந்த ஈர்ப்புகள்';

  @override
  String get pkResolutionTitle => 'கர்ம தீர்வு மற்றும் நிறைவு';

  @override
  String get pkPrimaryPathway => 'முதன்மை பாதை';

  @override
  String get pkSecondaryPathway => 'இரண்டாம் பாதை';

  @override
  String get pkClearingProgress => 'தெளிவாதல் முன்னேற்றம்';

  @override
  String get pkRemainingWork => 'மீதமுள்ள வேலை';

  @override
  String get pkSettlementTimeline => 'தீர்வு காலவரிசை';

  @override
  String get pkAccelerationPractices => 'தீர்வை விரைவுபடுத்தும் சாதனைகள்';

  @override
  String get pkPriorityAreas => 'முன்னுரிமை பகுதிகள்';

  @override
  String get pkVerificationTitle => 'ஜாதகங்களில் உறுதிப்படுத்தப்பட்டது (D60)';

  @override
  String get pkD60Label => 'D60 பூர்வ ஜென்ம காலம்';

  @override
  String get pkD60Ketu => 'D60 கேது நிலை';

  @override
  String get pkD60Standing => 'ஒட்டுமொத்த நிலை';

  @override
  String get pkMemoryTitle => 'நினைவகம் மற்றும் உள்ளுணர்வு';

  @override
  String get pkMemoryAccess => 'நினைவக அணுகல்';

  @override
  String get pkRegressionFit => 'ரிகிரஷன்-தெரபி பொருத்தம்';

  @override
  String get pkDreamVisits => 'கனவு வருகைகள்';

  @override
  String get pkDejaVuFrequency => 'தேஜா வூ அதிர்வெண்';

  @override
  String get pkSpontaneousRemembrance => 'தன்னிச்சையான நினைவு';

  @override
  String get pkRemembrancePractices => 'நினைவு சாதனைகள்';

  @override
  String get pkTimelineTitle => 'செயல்பாட்டு காலவரிசை';

  @override
  String get pkGiftsActivation => 'பூர்வ ஜென்ம பரிசுகளின் செயல்பாடு';

  @override
  String get pkSurfaceWindow => 'வெளிப்படும் காலம்';

  @override
  String get pkRisksTitle => 'இடர்கள் மற்றும் நீடித்த முறைகள்';

  @override
  String get pkTraumaResidue => 'மனஅதிர்ச்சி எச்சம்';

  @override
  String get pkSpiritualBypass => 'ஆன்மீக தவிர்ப்பு இடர்';

  @override
  String get pkMajorRisks => 'முக்கிய இடர்கள்';

  @override
  String get pkChronicImprints => 'நீடித்த முத்திரைகள்';

  @override
  String get pkKarmicLoops => 'கர்ம சுழற்சிகள்';

  @override
  String get pkImprovementTitle => 'மேம்பாட்டுத் திட்டம்';

  @override
  String get pkRoadmapTitle => 'உங்கள் பூர்வ ஜென்ம வழிகாட்டி';

  @override
  String get pkMaturity => 'பூர்வ ஜென்ம முதிர்ச்சி';

  @override
  String get pkLayerD1 => 'ஜனன ஜாதகம் (D1)';

  @override
  String get pkLayerD9 => 'நவாம்சம் (D9)';

  @override
  String get pkLayerD60 => 'சஷ்டியாம்சம் (D60)';

  @override
  String get pkLayerKetuDepth => 'கேது ஆழம்';

  @override
  String get pkLayerAtmakaraka => 'ஆன்மா கிரகம் (ஆத்மகாரகன்)';

  @override
  String get pkTopicMastery => 'என் பூர்வ ஜென்ம தேர்ச்சி';

  @override
  String get pkTopicUnfinished => 'என் முடிவடையாத கர்மா';

  @override
  String get pkTopicRelationships => 'என் பூர்வ ஜென்ம உறவுகள்';

  @override
  String get pkTopicDebts => 'என் கர்ம கடன்கள்';

  @override
  String get pkTopicResolution => 'என் கர்மாவை எவ்வாறு தீர்ப்பது';

  @override
  String get pkTopicMemory => 'பூர்வ ஜென்ம நினைவக அணுகல்';

  @override
  String get pkTopicTiming => 'சிறந்த நேர காலங்கள்';

  @override
  String get pkTopicProfile => 'பூர்வ ஜென்மத்தில் நான் யார்';

  @override
  String get chSubtitle => 'AI-இயக்கும் வேத தன்மை பகுப்பாய்வு அறிக்கை';

  @override
  String get chTitle => 'தன்மை பகுப்பாய்வு';

  @override
  String get chSnapshotHeader => 'தன்மை சுருக்கம்';

  @override
  String get chGaugeIntegrity => 'நேர்மை';

  @override
  String get chGaugeResilience => 'தாங்கும் திறன்';

  @override
  String get chGaugeSelfAwareness => 'தன்-விழிப்புணர்வு';

  @override
  String get chGaugeStability => 'உணர்ச்சி நிலைத்தன்மை';

  @override
  String get chGaugeMoralFabric => 'தார்மீக அமைப்பு';

  @override
  String get chChipRajaYoga => 'ராஜயோகம் உள்ளது';

  @override
  String get chChipHighIntegrity => 'உயர் நேர்மை';

  @override
  String get chChipResilient => 'தாங்கும் இயல்பு';

  @override
  String get chChipDharmic => 'வலுவான தர்ம நோக்கு';

  @override
  String get chChipEmpathetic => 'இயல்பாகவே பரிவுள்ளவர்';

  @override
  String get chChipLoyal => 'ஆழ்ந்த விசுவாசம்';

  @override
  String get chChipGiftedCharacter => 'ஜாதகத்தில் தன்மை பரிசு உள்ளது';

  @override
  String get chSoulTitle => 'உங்கள் ஆத்ம அடையாளம்';

  @override
  String get chSoulIntegration => 'ஆத்மா-தன்மை ஒருங்கிணைப்பு';

  @override
  String get chAmatyakarakaTheme => 'துணை தன்மை குரல்';

  @override
  String get chAtmakarakaDignity => 'ஆத்மகாரக கிரக பலம்';

  @override
  String get chAtmakarakaHouse => 'பாவ நிலை';

  @override
  String get chSurfaceTitle => 'வெளிப்புற ஆளுமை மற்றும் அமைப்பு';

  @override
  String get chLagnaSign => 'லக்ன ராசி';

  @override
  String get chConstitution => 'அமைப்பு';

  @override
  String get chSurfaceSignature =>
      'நீங்கள் மற்றவர்களுக்கு எப்படி தெரிகிறீர்கள்';

  @override
  String get chPhysicalConstitution => 'உடல் அமைப்பு';

  @override
  String get chLagnaLord => 'லக்னாதிபதி';

  @override
  String get chLagnaOccupants => 'லக்னத்தில் உள்ள கிரகங்கள்';

  @override
  String get chMindEmotionsTitle => 'மனம், உணர்வுகள் மற்றும் அகங்காரம்';

  @override
  String get chEmotionalNature => 'உங்கள் உணர்ச்சி இயல்பு';

  @override
  String get chMentalStability => 'மன நிலைத்தன்மை';

  @override
  String get chSelfConfidence => 'ஆரோக்கியமான தன்னம்பிக்கை';

  @override
  String get chEgoNature => 'உங்கள் அகங்காரம் மற்றும் தன்-கருத்து';

  @override
  String get chAuthorityRelationship => 'அதிகாரத்துடனான உறவு';

  @override
  String get chPrideTendency => 'பெருமித போக்கு';

  @override
  String get chMoodPatterns => 'மனநிலை முறைகள்';

  @override
  String get chKemadrumaPresent =>
      'கேமத்ரும யோகம் உள்ளது — கூடுதல் உணர்ச்சி பராமரிப்பு நன்மை பயக்கும்.';

  @override
  String get chFatherImprint => 'தந்தை பதிவின் தரம்';

  @override
  String get chCommunicationTitle => 'தொடர்பாடல் மற்றும் அறிவுத்திறன் பாணி';

  @override
  String get chIntellectStyle => 'அறிவுத்திறன் பாணி';

  @override
  String get chCommStyle => 'தொடர்பாடல் பாணி';

  @override
  String get chDecisionStyle => 'முடிவெடுக்கும் பாணி';

  @override
  String get chDiscrimination => 'பகுத்தறியும் திறன்';

  @override
  String get chPersonaTitle => 'பொது முகம் மற்றும் உண்மையான சுயம்';

  @override
  String get chAuthenticityGap => 'நம்பகத்தன்மை இடைவெளி';

  @override
  String get chGunaTitle => 'குணம் மற்றும் தோஷ சுயவிவரம்';

  @override
  String get chGunaSubtitle =>
      'உங்கள் உள் இயல்பு மற்றும் அமைப்பு, பாரம்பரிய வேத பாணியில்';

  @override
  String get chSattva => 'சத்வம்';

  @override
  String get chRajas => 'ரஜஸ்';

  @override
  String get chTamas => 'தமஸ்';

  @override
  String get chDominantGuna => 'முதன்மை குணம்';

  @override
  String get chPitta => 'பித்தம்';

  @override
  String get chKapha => 'கபம்';

  @override
  String get chVata => 'வாதம்';

  @override
  String get chDominantDosha => 'முதன்மை தோஷம்';

  @override
  String get chRahuRestlessness => 'ராகுவின் அமைதியின்மை';

  @override
  String get chKetuDetachment => 'கேதுவின் பற்றின்மை';

  @override
  String get chYogasTitle => 'தன்மை யோகங்கள்';

  @override
  String get chRajaYogaStrength => 'ராஜயோக பலம்';

  @override
  String get chGiftYogas => 'பரிசு யோகங்கள்';

  @override
  String get chTestYogas => 'சோதனை யோகங்கள்';

  @override
  String get chStrengthsTitle => 'பலங்கள் மற்றும் திறமைகள்';

  @override
  String get chSignatureVirtues => 'தனித்துவமான நற்குணங்கள்';

  @override
  String get chNaturalTalents => 'இயல்பான திறமைகள்';

  @override
  String get chSoftSkills => 'மென் திறன்கள்';

  @override
  String get chHiddenStrengths => 'வளர்க்க வேண்டிய மறைந்த பலங்கள்';

  @override
  String get chShadowTitle => 'நிழல் மற்றும் வளர்ச்சி பகுதிகள்';

  @override
  String get chShadowSubtitle =>
      'கவனிக்க வேண்டிய முறைகள் குறித்த மென்மையான விழிப்புணர்வு';

  @override
  String get chShadowPatterns => 'நிழல் முறைகள்';

  @override
  String get chBlindSpots => 'கண்ணுக்குத் தெரியாத பகுதிகள்';

  @override
  String get chEmotionalWounds => 'உணர்ச்சி காயங்கள்';

  @override
  String get chShadowWorkPriorities => 'நிழல்-பணி முன்னுரிமைகள்';

  @override
  String get chMoralTests => 'தார்மீக சோதனைகள்';

  @override
  String get chRelationshipsTitle => 'உறவுகள் மற்றும் சமூக பாணி';

  @override
  String get chWarmth => 'பரஸ்பர அன்பு';

  @override
  String get chEmpathy => 'பரிவு திறன்';

  @override
  String get chLoyalty => 'விசுவாச திறன்';

  @override
  String get chBoundaries => 'எல்லைகளை நிர்ணயித்தல்';

  @override
  String get chSocialConfidence => 'சமூக தன்னம்பிக்கை';

  @override
  String get chTrustGiving => 'நம்பிக்கை அளிக்கும் அடிப்படை நிலை';

  @override
  String get chConflictStyle => 'முரண்பாட்டு பாணி';

  @override
  String get chEthicsTitle => 'நெறிமுறை மற்றும் தார்மீக திசைகாட்டி';

  @override
  String get chDharmaOrientation => 'தர்ம நோக்கு';

  @override
  String get chTruthfulness => 'உண்மைத்தன்மை';

  @override
  String get chCompassion => 'கருணை';

  @override
  String get chGenerosity => 'தாராள மனப்பான்மை';

  @override
  String get chEthicalConsistency => 'நெறிமுறை நிலைத்தன்மை';

  @override
  String get chIntegrityPressure => 'அழுத்தத்தில் நேர்மை';

  @override
  String get chJusticeFairness => 'நீதி மற்றும் நியாயம்';

  @override
  String get chMoralTrajectory => 'தார்மீக வளர்ச்சி';

  @override
  String get chEiTitle => 'உணர்ச்சி நுண்ணறிவு';

  @override
  String get chEiSelfAwareness => 'தன்-விழிப்புணர்வு';

  @override
  String get chEiSelfRegulation => 'தன்-கட்டுப்பாடு';

  @override
  String get chEiEmpathy => 'பரிவு';

  @override
  String get chEiSocialSkills => 'சமூக திறன்கள்';

  @override
  String get chMotivation => 'உள் ஊக்கம்';

  @override
  String get chVulnerabilityComfort => 'பலவீனத்துடன் வசதி';

  @override
  String get chEmotionalExpression => 'உணர்ச்சி வெளிப்பாட்டில் வசதி';

  @override
  String get chEmotionalReceptivity => 'உணர்ச்சி ஏற்புத்திறன்';

  @override
  String get chVerificationTitle =>
      'அனைத்து ஜாதகங்களிலும் உறுதிப்படுத்தப்பட்டது (D9/D12/D30/D60)';

  @override
  String get chD9Label => 'D9 தர்ம-தன்மை';

  @override
  String get chD12Label => 'D12 மூதாதையர் பரம்பரை';

  @override
  String get chD30Label => 'D30 நிழல் சுயவிவரம்';

  @override
  String get chD60Label => 'D60 முன் பிறவி தன்மை';

  @override
  String get chD30Standing => 'நிழல் நிலை';

  @override
  String get chMaternalInheritance => 'தாய்வழி பரம்பரை';

  @override
  String get chAncestralKarmaWeight => 'மூதாதையர் கர்ம பாரம்';

  @override
  String get chTimelineTitle => 'தன்மை காலவரிசை';

  @override
  String get chFormationWindow => 'உருவாக்க காலம்';

  @override
  String get chMaturationWindow => 'முதிர்ச்சி காலம்';

  @override
  String get chLegacyWindow => 'பாரம்பரிய காலம்';

  @override
  String get chPeakMaturationAge => 'உச்ச முதிர்ச்சி வயது';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return 'வயது $ageRange';
  }

  @override
  String get chImprovementTitle => 'முன்னேற்ற திட்டம்';

  @override
  String get chRoadmapTitle => 'உங்கள் தன்மை வரைபடம்';

  @override
  String get chAuthenticExpression => 'உண்மையான தன்-வெளிப்பாடு';

  @override
  String get chRealizationPotential => 'தன்மை உணர்தல் திறன்';

  @override
  String get chLayerAtmakaraka => 'ஆத்மா கிரகம் (ஆத்மகாரகன்)';

  @override
  String get chLayerD1 => 'பிறப்பு ஜாதகம் (D1)';

  @override
  String get chLayerD9 => 'நவாம்சம் (D9)';

  @override
  String get chLayerD30 => 'திரிம்சாம்சம் (D30)';

  @override
  String get chLayerLagnaMoon => 'லக்னம் மற்றும் சந்திரன்';

  @override
  String get chLayerArudha => 'ஆரூட லக்னம்';

  @override
  String get chTopicStrengths => 'எனது தன்மை பலங்கள்';

  @override
  String get chTopicShadow => 'எனது நிழல் முறைகள்';

  @override
  String get chTopicSoul => 'எனது ஆத்ம அடையாளம்';

  @override
  String get chTopicRelationships => 'எனது உறவு பாணி';

  @override
  String get chTopicEthics => 'எனது நெறிமுறைகள் மற்றும் மதிப்புகள்';

  @override
  String get chTopicGuna => 'எனது குணம் மற்றும் தோஷ சுயவிவரம்';

  @override
  String get chTopicGrowth => 'எனது தன்மையை எப்படி வளர்ப்பது';

  @override
  String get chTopicTiming => 'தன்மை பணிக்கான சிறந்த நேரம்';

  @override
  String get lpSubtitle => 'AI-இயக்கும் வேத வாழ்க்கைப் பாதை & அதிர்ஷ்ட அறிக்கை';

  @override
  String get lpTitle => 'வாழ்க்கைப் பாதை & அதிர்ஷ்டம்';

  @override
  String get lpSnapshotHeader => 'வாழ்க்கைப் பாதை சுருக்கம்';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return 'நீங்கள் ஒரு $archetype, உங்கள் முதன்மை நோக்கம் $domain-இல் உள்ளது. எங்கள் பகுப்பாய்வின்படி உங்கள் ஒட்டுமொத்த வாழ்க்கை நிறைவு திறன் $probability%.';
  }

  @override
  String get lpGaugeDharma => 'தர்ம தெளிவு';

  @override
  String get lpGaugeFortune => 'அதிர்ஷ்ட அடிப்படை';

  @override
  String get lpGaugeCoherence => 'பாதை ஒருங்கிணைவு';

  @override
  String get lpGaugeFulfillment => 'நிறைவேற்றம்';

  @override
  String get lpGaugeMomentum => 'கர்ம வேகம்';

  @override
  String get lpChipRareGift => 'அரிய விதி பரிசு';

  @override
  String get lpChipFreeWillStrong => 'வலுவான சுதந்திர விருப்பம்';

  @override
  String get lpChipGraceSupported => 'அருள் ஆதரவு பெற்றது';

  @override
  String get lpChipLightKarma => 'இலகுவான கர்ம சுமை';

  @override
  String get lpChipRecognitionPotential => 'அங்கீகார சாத்தியம்';

  @override
  String get lpChipSpiritualPath => 'வலுவான ஆன்மீக ஈர்ப்பு';

  @override
  String get lpChipBlessed => 'ஜாதகம் ஆசீர்வாதங்களைக் கொண்டுள்ளது';

  @override
  String get lpSoulPathTitle => 'உங்கள் ஆத்மா பாதை';

  @override
  String get lpSoulPlanet => 'ஆத்மா கிரகம்';

  @override
  String get lpCareerPlanet => 'நோக்கக் கிரகம்';

  @override
  String get lpSoulClarity => 'நோக்கத் தெளிவு';

  @override
  String get lpLifeChapter => 'தற்போதைய வாழ்க்கை அத்தியாயம்';

  @override
  String get lpPrimaryDomain => 'முதன்மை நோக்கப் பகுதி';

  @override
  String get lpKarakaTitle => 'உங்கள் தர்மக் கிரகங்கள்';

  @override
  String get lpKarakaSubtitle =>
      'ஒவ்வொரு கிரகமும் உங்கள் வாழ்க்கை நோக்கத்தை எவ்வளவு ஆதரிக்கிறது';

  @override
  String get lpVerificationTitle => 'ஜாதகங்களில் சரிபார்க்கப்பட்டது (D9 / D60)';

  @override
  String get lpD9Label => 'D9 ஆத்மா சீரமைப்பு';

  @override
  String lpD9Explain(Object stage) {
    return 'நவாம்சம் ஜாதகத்தில் உங்கள் ஆத்மா-பரிணாம நிலை \'$stage\' ஆகும்.';
  }

  @override
  String get lpD9JupiterDignity => 'குருவின் கண்ணியம்';

  @override
  String get lpD9DharmaMultiplier => 'தர்ம பெருக்கி';

  @override
  String get lpD60Label => 'D60 முன்பிறவி முத்திரை';

  @override
  String get lpKarmaType => 'முன்பிறவி கர்ம வகை';

  @override
  String get lpKetuMastery => 'கேது முன்பிறவி தேர்ச்சி';

  @override
  String get lpRahuGrowthDir => 'ராகு வளர்ச்சி திசை';

  @override
  String get lpYogasTitle => 'அதிர்ஷ்ட யோகங்கள் & அதிர்ஷ்டத் தடைகள்';

  @override
  String get lpFortuneBoost => 'அதிர்ஷ்ட மேம்பாடு';

  @override
  String get lpLuckDrain => 'அதிர்ஷ்ட வடிகால்';

  @override
  String get lpFortuneBoosters => 'அதிர்ஷ்டம் அதிகரிப்பவை';

  @override
  String get lpLuckBlocks => 'அதிர்ஷ்டத் தடைகள்';

  @override
  String get lpPurposeTitle => 'நோக்கப் பகுதிகள் & புகழ்';

  @override
  String get lpDomainLeadership => 'தலைமைத்துவம்';

  @override
  String get lpDomainWisdom => 'ஞானம் & கற்பித்தல்';

  @override
  String get lpDomainService => 'சேவை';

  @override
  String get lpDomainHealing => 'குணப்படுத்துதல்';

  @override
  String get lpDomainCreative => 'படைப்பாற்றல் வெளிப்பாடு';

  @override
  String get lpPrimaryDomainBadge => 'முதன்மை';

  @override
  String get lpFameRecognition => 'புகழ் & அங்கீகாரம்';

  @override
  String get lpSocialInfluence => 'சமூக செல்வாக்கு';

  @override
  String get lpRecognitionDomain => 'அங்கீகாரப் பகுதி';

  @override
  String get lpPublicImage => 'பொது பிம்பம்';

  @override
  String get lpHistoricalImpact => 'வரலாற்று தாக்கச் சாத்தியம்';

  @override
  String get lpTimelineTitle => 'அதிர்ஷ்டம் & வாழ்க்கை காலவரிசை';

  @override
  String get lpCurrentPhase => 'தற்போதைய அதிர்ஷ்ட கட்டம்';

  @override
  String get lpJupiterReturn => 'குரு திரும்புதல்';

  @override
  String get lpSaturnReturn => 'சனி திரும்புதல்';

  @override
  String get lpSadeSati => 'சாடே சாதி';

  @override
  String get lpGoldenWindow => 'பொன்னான வாய்ப்புக் காலம்';

  @override
  String get lpTransformationWindow => 'மாற்றக் காலம்';

  @override
  String get lpPeakYears => 'உச்ச அதிர்ஷ்ட ஆண்டுகள்';

  @override
  String get lpChallengingYears => 'சவாலான ஆண்டுகள்';

  @override
  String get lpMilestonesTitle => 'முக்கிய மைல்கற்கள் & திருப்புமுனைகள்';

  @override
  String get lpFirstTurningPoint => 'முதல் முக்கிய திருப்புமுனை';

  @override
  String get lpMidlifeTransform => 'நடுவாழ்க்கை மாற்றம்';

  @override
  String get lpLateLifeFulfillment => 'பிற்பகுதி வாழ்க்கை நிறைவேற்றம்';

  @override
  String lpDharmicMilestone(Object age) {
    return 'தர்ம மைல்கல் (வயது $age)';
  }

  @override
  String lpAgeLabel(Object age) {
    return 'வயது $age';
  }

  @override
  String get lpDestinyTitle => 'விதி vs சுதந்திர விருப்பம்';

  @override
  String get lpDestinyStat => 'விதியின் எடை';

  @override
  String get lpFreeWillStat => 'சுதந்திர விருப்ப செல்வாக்கு';

  @override
  String get lpFateStrength => 'விதி முத்திரை வலிமை';

  @override
  String get lpSelfCreation => 'சுய-படைப்புத் திறன்';

  @override
  String get lpEffortGrace => 'முயற்சி vs அருள்';

  @override
  String get lpKarmicTitle => 'கர்மப் பாடங்கள்';

  @override
  String get lpRahuGrowthLabel => 'ராகு — வளர்ச்சி சவால்';

  @override
  String get lpKetuSurrenderLabel => 'கேது — சரணடைதல் கருப்பொருள்';

  @override
  String get lpSaturnLessonLabel => 'சனி — ஒழுக்கப் பாடம்';

  @override
  String get lpTestDifficulty => 'வாழ்க்கை சோதனை கடினத்தன்மை';

  @override
  String get lpLessonsInProgress => 'நடைபெறும் பாடங்கள்';

  @override
  String get lpSoulContract => 'ஆத்மா ஒப்பந்தப் பகுதிகள்';

  @override
  String get lpSoulExperience => 'உங்கள் ஆத்மா எதை அனுபவிக்க வந்தது';

  @override
  String get lpSoulMastery => 'உங்கள் ஆத்மா எதில் தேர்ச்சி பெற வந்தது';

  @override
  String get lpSpiritualTitle => 'ஆன்மீகப் பாதை';

  @override
  String get lpSpiritualInclination => 'ஆன்மீக நாட்டம்';

  @override
  String get lpMeditationReceptivity => 'தியான ஏற்புத்தன்மை';

  @override
  String get lpTeacherKarma => 'குரு/ஆசிரியர் கர்மா';

  @override
  String get lpPilgrimageBenefit => 'யாத்திரை பலன்';

  @override
  String get lpSelfRealization => 'சுய-உணர்வுச் சாத்தியம்';

  @override
  String get lpDivineConnection => 'தெய்வீக தொடர்பு';

  @override
  String get lpTraditionAffinity => 'பாரம்பரிய ஈர்ப்பு';

  @override
  String get lpIntuitionStrength => 'உள்ளுணர்வு வலிமை';

  @override
  String get lpMantraEfficacy => 'பிரார்த்தனை/மந்திர பயனளிப்பு';

  @override
  String get lpInnerGuidance => 'உள்ளார்ந்த வழிகாட்டுதலின் நம்பிக்கை';

  @override
  String get lpPropheticDreams => 'முன்னறிவிப்பு கனவு உணர்திறன்';

  @override
  String get lpDifficultyTitle => 'வாழ்க்கை சிரமங்கள் & சவால்கள்';

  @override
  String get lpEarlyLife => 'ஆரம்ப வாழ்க்கை';

  @override
  String get lpMidlife => 'நடுவாழ்க்கை';

  @override
  String get lpLateLife => 'பிற்பகுதி வாழ்க்கை';

  @override
  String get lpStruggleToSuccess => 'போராட்டத்திலிருந்து-வெற்றி கர்மா';

  @override
  String get lpUnlivedLifeRisk => 'வாழப்படாத-வாழ்க்கை ஆபத்து';

  @override
  String get lpChallenges => 'வாழ்க்கை சவால்கள்';

  @override
  String get lpFortuneDrains => 'நீடித்த அதிர்ஷ்ட வடிகால்கள்';

  @override
  String get lpRegretAreas => 'வருத்தம்-ஆபத்துள்ள பகுதிகள்';

  @override
  String get lpRedFlags => 'திசை எச்சரிக்கை அறிகுறிகள்';

  @override
  String get lpBlessingsTitle => 'ஆசீர்வாதங்கள் & முக்கிய வாழ்க்கை கருப்பொருள்';

  @override
  String get lpKarmicRoot => 'கர்ம வேர்';

  @override
  String get lpBlessingsList => 'உங்கள் ஆசீர்வாதங்கள்';

  @override
  String get lpFulfillmentPriorities => 'நிறைவேற்ற முன்னுரிமைகள்';

  @override
  String get lpImprovementTitle => 'மேம்பாட்டுத் திட்டம்';

  @override
  String get lpDharmaPriorities => 'தர்ம முன்னுரிமைகள்';

  @override
  String get lpRoadmapTitle => 'உங்கள் விதி வரைபடம்';

  @override
  String get lpStrategy => 'உத்தி';

  @override
  String get lpFulfillmentPotential => 'நிறைவேற்றத் திறன்';

  @override
  String get lpNext12Focus => 'அடுத்த 12 மாத கவனம்';

  @override
  String get lpLayerD1 => 'பிறப்பு ஜாதகம் (D1)';

  @override
  String get lpLayerD9 => 'நவாம்சம் (D9)';

  @override
  String get lpLayerD60 => 'சஷ்டியம்சம் (D60)';

  @override
  String get lpLayerDasha => 'தசை காலம்';

  @override
  String get lpLayerTransit => 'தற்போதைய கோச்சாரம்';

  @override
  String get lpTopicPurpose => 'எனது வாழ்க்கை நோக்கம்';

  @override
  String get lpTopicFortune => 'எனது அதிர்ஷ்ட யோகங்கள்';

  @override
  String get lpTopicKarma => 'எனது கர்மப் பாடங்கள்';

  @override
  String get lpTopicMilestones => 'வரவிருக்கும் மைல்கற்கள்';

  @override
  String get lpTopicDestiny => 'விதி vs சுதந்திர விருப்பம்';

  @override
  String get lpTopicSpiritual => 'எனது ஆன்மீகப் பாதை';

  @override
  String get lpTopicChallenges => 'எனது வாழ்க்கை சவால்கள்';

  @override
  String get lpTopicTiming => 'சிறந்த நேர சாளரங்கள்';

  @override
  String get dbSubtitle => 'AI-இயக்கும் வேத கடன் & மீட்பு அறிக்கை';

  @override
  String get dbTitle => 'கடன் & மீட்பு';

  @override
  String get dbSnapshotHeader => 'கடன் மீட்பு சுருக்கம்';

  @override
  String dbHeroSummary(
    Object phase,
    Object personality,
    Object probability,
    Object years,
  ) {
    return 'நீங்கள் தற்போது \'$phase\' நிலையில் இருக்கிறீர்கள், பணத்தின் மீதான உங்கள் அணுகுமுறை $personality ஆக உள்ளது. எங்கள் பகுப்பாய்வின்படி சுமார் $years ஆண்டுகளில் கடன் இல்லாத நிலைக்கு வர $probability% வாய்ப்பு உள்ளது.';
  }

  @override
  String get dbGaugeCapacity => 'மீட்பு திறன்';

  @override
  String get dbGaugeProbability => 'மீட்பு வாய்ப்பு';

  @override
  String get dbGaugeFreedomNow => 'இப்போது கடன் விடுதலை';

  @override
  String get dbGaugeDti => 'வருமான ஆரோக்கியம்';

  @override
  String get dbGaugeResilience => 'மீள்திறன்';

  @override
  String get dbChipCleanKarma => 'தூய்மையான கடன் கர்மா';

  @override
  String get dbChipStrongRecovery => 'வலுவான மீட்பு திறன்';

  @override
  String get dbChipHealthyDti => 'ஆரோக்கியமான கடன்-வருமான விகிதம்';

  @override
  String get dbChipResilient => 'உயர் மனவலிமை';

  @override
  String get dbChipCycleBreakable => 'கடன் சுழற்சியை உடைக்க முடியும்';

  @override
  String get dbChipLowReindebt => 'மீண்டும் கடனாளியாகும் அபாயம் குறைவு';

  @override
  String get dbChipGoodNegotiator => 'நல்ல பேச்சுவார்த்தை வாய்ப்புகள்';

  @override
  String get dbProfileTitle => 'உங்கள் கடன் விவரக்குறிப்பு';

  @override
  String get dbPhaseLabel => 'தற்போதைய நிலை';

  @override
  String get dbPrimaryCategoryLabel => 'முதன்மை வகை';

  @override
  String get dbKarakaLabel => 'கடன் காரகன்';

  @override
  String get dbProtectorLabel => 'கடன் வழங்குநர் பாதுகாப்பு';

  @override
  String get dbSecondaryCategories => 'இரண்டாம் நிலை வகைகள்';

  @override
  String get dbUnsecuredRatio => 'பாதுகாப்பற்ற-கடன் விகிதம்';

  @override
  String get dbKarakaTitle => 'உங்கள் கடன் கிரகங்கள்';

  @override
  String get dbKarakaSubtitle =>
      'ஒவ்வொரு கிரகமும் உங்கள் கடன் மீட்புக்கு எவ்வளவு வலுவாக ஆதரவளிக்கிறது';

  @override
  String get dbVerificationTitle =>
      'அனைத்து ஜாதகங்களிலும் உறுதிசெய்யப்பட்டது (D6)';

  @override
  String get dbD6Label => 'D6 கடன் & எதிரிகள் ஜாதகம்';

  @override
  String get dbD6LordDignity => '6ஆம் இல்லத்தின் அதிபதியின் வலிமை';

  @override
  String get dbD6Severity => 'கடன் கர்மாவின் தீவிரம்';

  @override
  String get dbD6Multiplier => 'D6 கடன் பெருக்கி';

  @override
  String get dbYogasTitle => 'கடன் யோகங்கள் & பாதுகாப்புகள்';

  @override
  String get dbPressureNow => 'தற்போதைய கடன் அழுத்தம்';

  @override
  String get dbRecoveryBoost => 'மீட்பு ஊக்கம்';

  @override
  String get dbClearingLabel => 'கடன்-தீர்க்கும் யோகங்கள்';

  @override
  String get dbCreatingLabel => 'கடன்-உருவாக்கும் யோகங்கள்';

  @override
  String get dbCategoriesTitle => 'கடன் வகைகள் கண்காணிப்பு';

  @override
  String get dbCategoriesSubtitle => 'எந்த வகை கடனுக்கு அதிக கவனம் தேவை';

  @override
  String get dbTimelineTitle => 'கடன்-விடுதலை காலவரிசை';

  @override
  String get dbFreeWindowLabel => 'கடன்-விடுதலை காலம்';

  @override
  String get dbClearanceEstimate => 'முழு தீர்வுக்கான மதிப்பீடு';

  @override
  String get dbPeakYears => 'கடன்-உச்ச ஆண்டுகள்';

  @override
  String get dbClearanceYears => 'தீர்வு ஆண்டுகள்';

  @override
  String get dbBorrowTitle => 'புத்திசாலித்தனமான கடன் வாங்கும் வழிகாட்டி';

  @override
  String get dbLoanSuitability => 'கடன் பொருத்தம்';

  @override
  String get dbBestLoanType => 'சிறந்த கடன் வகை';

  @override
  String get dbLeverageCeiling => 'கடன் அளவு உச்சவரம்பு';

  @override
  String get dbNegotiationSuccess => 'பேச்சுவார்த்தை வெற்றி';

  @override
  String get dbCreditorAggression => 'கடன் வழங்குநர் அழுத்த அபாயம்';

  @override
  String get dbLegalEscalation => 'சட்ட நடவடிக்கை அபாயம்';

  @override
  String get dbNegotiationApproach => 'பரிந்துரைக்கப்படும் அணுகுமுறை';

  @override
  String get dbAvoidLoanTypes => 'தவிர்க்க வேண்டிய கடன் வகைகள்';

  @override
  String get dbRiskTitle => 'அபாயம் & பாதிப்பு கண்காணிப்பு';

  @override
  String get dbRiskDefault => 'தவறல் அபாயம்';

  @override
  String get dbRiskDefaultExp =>
      'திட்டமிடப்பட்ட திருப்பிச் செலுத்துதலை மோசமாக தவறவிட்டு, கடன் வழங்குநரிடம் தவறல் நிலையைத் தூண்டும் வாய்ப்பு.';

  @override
  String get dbRiskDefaultFix =>
      'குறைந்தபட்ச செலுத்துதல்களை தானியங்குபடுத்தி, 1 மாத இருப்பை வைத்திருங்கள், அதனால் ஒரு வருமான சுழற்சி தவறினாலும் அது பெரிதாகாது.';

  @override
  String get dbRiskBankruptcy => 'திவால் அபாயம்';

  @override
  String get dbRiskBankruptcyExp =>
      'வருமானமும் சொத்தும் நடைமுறையில் ஈடுகட்ட முடியாத அளவுக்கு கடன் சுமை உயரும் வாய்ப்பு.';

  @override
  String get dbRiskBankruptcyFix =>
      'புதிய கடன் அல்லது கடன் வரம்பை எடுப்பதற்கு முன் தொழில்முறை கடன் மதிப்பாய்வு பெறுங்கள்.';

  @override
  String get dbRiskAssetSeizure => 'சொத்து-பறிமுதல் அபாயம்';

  @override
  String get dbRiskAssetSeizureExp =>
      'பாதுகாப்பான கடன் தவறல் ஏற்பட்டால் கடன் வழங்குநர் அடமானப் பொருளை அல்லது சொத்தை கைப்பற்றும் வாய்ப்பு.';

  @override
  String get dbRiskAssetSeizureFix =>
      'பாதுகாப்பான-கடன் செலுத்துதல்களுக்கு முதலில் முன்னுரிமை கொடுங்கள், செலுத்துதலில் இடைவெளி ஏற்படும் என தோன்றினால் விரைவில் மறுநிதியளிப்பு செய்யுங்கள்.';

  @override
  String get dbRiskChronic => 'நீடித்த மீண்டும்-கடன் அபாயம்';

  @override
  String get dbRiskChronicExp =>
      'தற்போதைய கடனைத் தீர்த்த பிறகும் மீண்டும் கடனில் சிக்கும் போக்கு.';

  @override
  String get dbRiskChronicFix =>
      'தீர்வுக்குப் பிறகு வாழ்க்கை முறை செலவை அதிகரிக்கும் முன் ஒரு தனி அவசரகால நிதியை உருவாக்குங்கள்.';

  @override
  String get dbReindebtTrigger => 'மீண்டும்-கடன் தூண்டுதல்';

  @override
  String get dbCycleBreakFeasibility => 'சுழற்சி-முறிவு சாத்தியக்கூறு';

  @override
  String get dbMajorRisks => 'முக்கிய அபாயங்கள்';

  @override
  String get dbHiddenSignals => 'மறைந்த கடன் சமிக்ஞைகள்';

  @override
  String get dbCrisisTitle => 'நெருக்கடி தயார்நிலை';

  @override
  String get dbCrisisSubtitle =>
      'பிரச்சனையை முன்கூட்டியே எப்படி கண்டறிந்து அமைதியாக பதிலளிப்பது';

  @override
  String get dbWarningSigns => 'ஆரம்பகால எச்சரிக்கை அறிகுறிகள்';

  @override
  String get dbMitigationActions => 'இதைப் பற்றி என்ன செய்யலாம்';

  @override
  String get dbFamilyTitle => 'குடும்ப & மூதாதையர் கடன்';

  @override
  String get dbInheritedDebtProb => 'பரம்பரையாக வந்த கடன் வாய்ப்பு';

  @override
  String get dbFamilyDrag => 'குடும்ப கடன் இழுப்பு';

  @override
  String get dbInheritedSource => 'வாய்ப்புள்ள மூலம்';

  @override
  String get dbCoreBlockerLabel => 'முக்கிய தடை';

  @override
  String get dbPsychologyTitle => 'உங்கள் பண மனநிலை';

  @override
  String get dbResilience => 'மீள்திறன்';

  @override
  String get dbDiscipline => 'அழுத்தத்தில் ஒழுக்கம்';

  @override
  String get dbSocialSupport => 'சமூக ஆதரவு';

  @override
  String get dbDepressionRisk => 'நிதி-அழுத்த பாதிப்பு';

  @override
  String get dbStressTolerance => 'அழுத்தத்தை தாங்கும் திறன்';

  @override
  String get dbRootCause => 'நடத்தை அடிப்படை காரணம்';

  @override
  String get dbImprovementTitle => 'மேம்பாட்டுத் திட்டம்';

  @override
  String get dbRoadmapTitle => 'உங்கள் கடன்-விடுதலை பாதைத் திட்டம்';

  @override
  String get dbRecoveryProbability => 'மீட்பு வாய்ப்பு';

  @override
  String get dbClearanceTimeline => 'தீர்வு காலவரிசை';

  @override
  String get dbYears => 'ஆண்டுகள்';

  @override
  String get dbDtiHealth => 'கடன்-வருமான ஆரோக்கியம்';

  @override
  String get dbDtiCategory => 'DTI வகை';

  @override
  String get dbBreakEvenMonths => 'சமநிலைக்கு மாதங்கள்';

  @override
  String get dbIncomeAcceleration => 'தேவையான வருமான வளர்ச்சி';

  @override
  String get dbLayerD1 => 'ஜாதகம் (D1)';

  @override
  String get dbLayerD6 => 'கடன் & எதிரிகள் (D6)';

  @override
  String get dbLayerD9 => 'நவாம்சம் (D9)';

  @override
  String get dbLayerDasha => 'தசை காலம்';

  @override
  String get dbLayerTransit => 'தற்போதைய கோச்சாரம்';

  @override
  String get dbTopicRecovery => 'எனது மீட்பு காலவரிசை';

  @override
  String get dbTopicNegotiate => 'கடன் வழங்குநர்களுடன் பேச்சுவார்த்தை';

  @override
  String get dbTopicBorrowing => 'இப்போது கடன் வாங்குவது பாதுகாப்பானதா';

  @override
  String get dbTopicCrisis => 'நெருக்கடிக்கு தயார்படுதல்';

  @override
  String get dbTopicAncestral => 'மூதாதையர் கடன் கர்மா';

  @override
  String get dbTopicTimeline => 'கடன் தீர்க்க சிறந்த ஆண்டுகள்';

  @override
  String get dbTopicPsychology => 'எனது பண மனநிலை';

  @override
  String get dbTopicCategories =>
      'எந்த கடன்களுக்கு முன்னுரிமை கொடுக்க வேண்டும்';

  @override
  String get mnSubtitle => 'AI-இயங்கும் வேத நல்வாழ்வு அறிக்கை';

  @override
  String get mnTitle => 'மனநலம் மற்றும் மன அழுத்தம்';

  @override
  String get mnSnapshotHeader => 'நல்வாழ்வு ஸ்னாப்ஷாட்';

  @override
  String get mnResilience => 'மீள் திறன்';

  @override
  String get mnStability => 'நிலைத்தன்மை';

  @override
  String get mnEmotionalBalance => 'உணர்ச்சி சமநிலை';

  @override
  String get mnInnerCalm => 'உள் அமைதி';

  @override
  String get mnSelfAwareness => 'தன்-விழிப்புணர்வு';

  @override
  String get mnStatusThriving => 'சிறப்பாக உள்ளீர்கள்';

  @override
  String get mnStatusSteady => 'நிலையான மற்றும் சமநிலையான';

  @override
  String get mnStatusBuildingStrength => 'வலிமையை உருவாக்குகிறது';

  @override
  String get mnStatusNeedsGentleCare => 'மென்மையான கவனிப்பு தேவை';

  @override
  String get mnStatusReachOut => 'ஆதரவு பெற வேண்டிய நேரம்';

  @override
  String get mnChipStable => 'உணர்ச்சி ரீதியாக நிலையானது';

  @override
  String get mnChipSupported => 'நல்ல ஆதரவு உள்ளது';

  @override
  String get mnChipSelfAware => 'மிகவும் தன்-விழிப்புணர்வுடன்';

  @override
  String get mnChipResilient => 'விரைவில் மீண்டு வருகிறது';

  @override
  String get mnChipSecureAttachment => 'பாதுகாப்பான பிணைப்பு';

  @override
  String get mnChipHealingReady => 'குணமடைய தயார்';

  @override
  String get mnChipMindBodyBalance => 'மனம்-உடல் சமநிலை';

  @override
  String get mnSupportBannerTitle => 'ஒரு மென்மையான குறிப்பு';

  @override
  String get mnSupportBannerBody =>
      'இப்போது கூடுதல் ஆதரவை நாடுவது நல்லது என்று உங்கள் ஜாதகம் தெரிவிக்கிறது — நம்பகமான நண்பர், குடும்ப உறுப்பினர், அல்லது நிபுணர். உதவி கேட்பது பலவீனம் அல்ல, அது வலிமையின் அடையாளம்.';

  @override
  String get mnProfileTitle => 'உங்கள் உணர்ச்சி வரைபடம்';

  @override
  String get mnStressDriver => 'மன அழுத்தத்திற்கான காரணி';

  @override
  String get mnStabilityAnchor => 'நிலைத்தன்மையின் ஆதாரம்';

  @override
  String get mnSoulLevelKarma => 'ஆன்மீக-நிலை வடிவம்';

  @override
  String get mnSubtleSignature => 'நுட்பமான உணர்ச்சி முத்திரை';

  @override
  String get mnKarakaTitle => 'உங்கள் மனமும் கிரகங்களும்';

  @override
  String get mnKarakaSubtitle =>
      'எந்த கிரகங்கள் உங்கள் உள் உலகை வடிவமைக்கின்றன';

  @override
  String get mnYogasTitle => 'பலங்கள் மற்றும் வளர்ச்சி பகுதிகள்';

  @override
  String get mnCurrentPhase => 'தற்போதைய கட்டம்';

  @override
  String get mnCurrentStressLevel => 'தற்போதைய மன அழுத்த நிலை';

  @override
  String get mnRecentStrain => 'சமீபத்திய உணர்ச்சி சோர்வு';

  @override
  String get mnStrengths => 'பலங்கள்';

  @override
  String get mnGrowthAreas => 'வளர்ச்சி பகுதிகள்';

  @override
  String get mnSadeSatiStatus => 'சாடே சாதி நிலை';

  @override
  String get mnVerificationTitle =>
      'அனைத்து ஜாதகங்களிலும் உறுதிப்படுத்தப்பட்டது';

  @override
  String get mnD9Confirmation => 'D9 உறுதிப்படுத்தல்';

  @override
  String get mnD30Confirmation => 'D30 உறுதிப்படுத்தல்';

  @override
  String get mnMoodPatternsTitle => 'மனநிலை மற்றும் பதற்றத்தின் வடிவங்கள்';

  @override
  String get mnMoodPatternsSubtitle =>
      'மென்மையான விழிப்புணர்வு, நோய் கண்டறிதல் அல்ல';

  @override
  String get mnAnxietyPatterns => 'பதற்ற வடிவங்கள்';

  @override
  String get mnMoodPatterns => 'மனச்சோர்வு வடிவங்கள்';

  @override
  String get mnPrimaryPattern => 'முதன்மை வடிவம்';

  @override
  String get mnRumination => 'அதிகம் யோசிக்கும் போக்கு';

  @override
  String get mnHypervigilance => 'அதீத விழிப்பு';

  @override
  String get mnHopelessnessVuln => 'மனச்சோர்வு உணர்திறன்';

  @override
  String get mnEnergyDepletion => 'ஆற்றல் குறையும் போக்கு';

  @override
  String get mnMotivationBaseline => 'உந்துதலின் அடிப்படை நிலை';

  @override
  String get mnRegulationTitle => 'உணர்ச்சி கட்டுப்பாடு மற்றும் சமாளிப்பு';

  @override
  String get mnEmotionalRegulation => 'உணர்ச்சி கட்டுப்பாடு';

  @override
  String get mnSelfSoothing => 'தன்னை அமைதிப்படுத்தும் திறன்';

  @override
  String get mnExpressionStyle => 'வெளிப்பாட்டு பாணி';

  @override
  String get mnRecoveryTime => 'மீட்பு நேரம்';

  @override
  String get mnTriggerIntensity => 'தூண்டுதலின் தீவிரம்';

  @override
  String get mnHealthyCoping => 'ஆரோக்கியமான சமாளிப்பு பழக்கங்கள்';

  @override
  String get mnWatchFor => 'மென்மையாக கவனியுங்கள்';

  @override
  String get mnSleepTitle => 'தூக்கம் மற்றும் ஓய்வு';

  @override
  String get mnSleepQuality => 'தூக்கத்தின் தரம்';

  @override
  String get mnSleepAsRegulator => 'உணர்ச்சி கட்டுப்படுத்தியாக தூக்கம்';

  @override
  String get mnInsomniaTendency => 'அமைதியற்ற இரவுகளின் போக்கு';

  @override
  String get mnNightmareTendency => 'தெளிவான கனவுகளின் போக்கு';

  @override
  String get mnSleepHygienePriority => 'தூக்க சுகாதார முன்னுரிமை';

  @override
  String get mnBurnoutTitle => 'பர்ன்அவுட் மற்றும் ஆற்றல்';

  @override
  String get mnBurnoutVulnerability => 'பர்ன்அவுட் உணர்திறன்';

  @override
  String get mnBurnoutRecovery => 'பர்ன்அவுட்டிலிருந்து மீளும் திறன்';

  @override
  String get mnBurnoutStage => 'தற்போதைய பர்ன்அவுட் நிலை';

  @override
  String get mnSelfDrivingTendency => 'தன்னைத் தள்ளும் போக்கு';

  @override
  String get mnBurnoutTriggers => 'பர்ன்அவுட் தூண்டுதல்கள்';

  @override
  String get mnConnectionTitle => 'தொடர்பு மற்றும் ஆதரவு';

  @override
  String get mnSocialSupport => 'சமூக ஆதரவின் தரம்';

  @override
  String get mnLonelinessVuln => 'தனிமை உணர்திறன்';

  @override
  String get mnSolitudeNeed => 'தனிமையின் தேவை';

  @override
  String get mnSocialComfort => 'சமூக வசதி';

  @override
  String get mnTraumaSensitivity => 'மன அதிர்ச்சி உணர்திறன்';

  @override
  String get mnHealingReadiness => 'குணமடைவதற்கான தயார்நிலை';

  @override
  String get mnProcessingStyle => 'செயலாக்க பாணி';

  @override
  String get mnMindBodyIntegration => 'மனம்-உடல் ஒருங்கிணைப்பு';

  @override
  String get mnPtsdVuln => 'அதிர்ச்சி-எதிர்வினை உணர்திறன்';

  @override
  String get mnSelfAwarenessTitle => 'தன்-விழிப்புணர்வு மற்றும் வளர்ச்சி';

  @override
  String get mnSelfAwarenessScore => 'தன்-விழிப்புணர்வு';

  @override
  String get mnEmotionalVocabulary => 'உணர்ச்சி சொல்லகராதி';

  @override
  String get mnTherapyReadiness => 'சிகிச்சைக்கான தயார்நிலை';

  @override
  String get mnJournalingBenefit => 'நாட்குறிப்பு எழுதுவதன் நன்மை';

  @override
  String get mnInnerDialogue => 'உள் உரையாடலின் தரம்';

  @override
  String get mnAwarenessOfPatterns => 'வடிவங்கள் பற்றிய விழிப்புணர்வு';

  @override
  String get mnEscapePatternVuln => 'தப்பிக்கும் போக்கு உணர்திறன்';

  @override
  String get mnEscapeChannels => 'மென்மையாக கவனியுங்கள்';

  @override
  String get mnHealthyAlternatives => 'ஆரோக்கியமான மாற்று வழிகள்';

  @override
  String get mnTherapyFitTitle => 'சிகிச்சை மற்றும் ஆதரவு பொருத்தம்';

  @override
  String get mnCrisisSupportRec => 'ஆதரவு பரிந்துரை';

  @override
  String get mnSupportNetwork => 'உங்கள் ஆதரவு வலையமைப்பை செயல்படுத்துங்கள்';

  @override
  String get mnSelfAdvocacy => 'தனக்காக குரல் கொடுக்கும் தயார்நிலை';

  @override
  String get mnMedicationReceptivity => 'மருந்துக்கான ஏற்புத்தன்மை';

  @override
  String get mnTimelineTitle => 'நல்வாழ்வு காலவரிசை';

  @override
  String get mnPeakWellnessYears => 'சிறந்த நல்வாழ்வு ஆண்டுகள்';

  @override
  String get mnExtraCareYears => 'கூடுதல் சுய-பராமரிப்பு ஆண்டுகள்';

  @override
  String get mnTransformationWindows => 'நேர்மறை மாற்ற காலகட்டங்கள்';

  @override
  String get mnTherapyWindow => 'பரிந்துரைக்கப்பட்ட சிகிச்சை காலகட்டம்';

  @override
  String get mnPracticesTitle => 'தினசரி நல்வாழ்வு பழக்கங்கள்';

  @override
  String get mnMorningPractices => 'காலை பழக்கங்கள்';

  @override
  String get mnEveningPractices => 'மாலை பழக்கங்கள்';

  @override
  String get mnBreathwork => 'மூச்சுப் பயிற்சி';

  @override
  String get mnMovement => 'உடல் இயக்கம்';

  @override
  String get mnNutrition => 'ஊட்டச்சத்து';

  @override
  String get mnNatureExposure => 'இயற்கையுடன் இணைவதன் தேவை';

  @override
  String get mnDigitalDetox => 'டிஜிட்டல் டிடாக்ஸ் தேவை';

  @override
  String get mnImprovementTitle => 'மேம்பாட்டு திட்டம்';

  @override
  String get mnReliabilityTitle => 'நம்பகத்தன்மை';

  @override
  String get mnLayerD1 => 'பிறப்பு ஜாதகம் (D1)';

  @override
  String get mnLayerD9 => 'ஆன்மீக ஜாதகம் (D9)';

  @override
  String get mnLayerD30 => 'D30 ஜாதகம்';

  @override
  String get mnLayerDasha => 'தசை காலம்';

  @override
  String get mnLayerTransit => 'கோச்சாரம்';

  @override
  String get mnTopicResilience =>
      'நான் உணர்ச்சி ரீதியாக எவ்வளவு மீள் திறன் கொண்டவன்/கொண்டவள்?';

  @override
  String get mnTopicCoping => 'எனக்கான சிறந்த சமாளிப்பு உத்திகள் என்ன?';

  @override
  String get mnTopicSleep => 'நான் என் தூக்கத்தை எப்படி மேம்படுத்தலாம்?';

  @override
  String get mnTopicBurnout => 'எனக்கு பர்ன்அவுட் ஆபத்து உள்ளதா?';

  @override
  String get mnTopicTherapy => 'எனக்கு எந்த சிகிச்சை பாணி பொருந்தும்?';

  @override
  String get mnTopicPractices => 'எந்த தினசரி பழக்கங்கள் எனக்கு அதிகம் உதவும்?';

  @override
  String get mnTopicTiming => 'எனது சிறந்த நல்வாழ்வு ஆண்டுகள் எப்போது?';

  @override
  String get mnTopicSupport =>
      'நான் ஒரு வலுவான ஆதரவு வலையமைப்பை எப்படி உருவாக்குவது?';

  @override
  String get lgSubtitle => 'AI-இயக்கும் வேத சட்ட அறிக்கை';

  @override
  String get lgTitle => 'சட்டம் & சச்சரவுகள்';

  @override
  String get lgSnapshotHeader => 'சட்ட சுருக்கம்';

  @override
  String get lgResilience => 'சட்ட மீள்திறன்';

  @override
  String get lgResolutionCapacity => 'தீர்வு திறன்';

  @override
  String get lgVictoryPotential => 'வெற்றி சாத்தியம்';

  @override
  String get lgLegalSafety => 'சட்ட பாதுகாப்பு';

  @override
  String get lgNegotiationSkill => 'பேச்சுவார்த்தை திறமை';

  @override
  String get lgStatusExcellent => 'சிறப்பானது';

  @override
  String get lgStatusStrong => 'வலிமையானது';

  @override
  String get lgStatusModerate => 'மிதமானது';

  @override
  String get lgStatusDeveloping => 'வளர்ந்து வருகிறது';

  @override
  String get lgStatusChallenging => 'சவாலானது';

  @override
  String get lgChipResolver => 'திறமையான தீர்வுகாரர்';

  @override
  String get lgChipWinner => 'வலிமையான வழக்கு வெற்றி';

  @override
  String get lgChipNegotiator => 'இயல்பான பேச்சுவார்த்தையாளர்';

  @override
  String get lgChipDocumented => 'நன்கு ஆவணப்படுத்தப்பட்டது';

  @override
  String get lgChipLowRisk => 'குறைந்த சட்ட ஆபத்து';

  @override
  String get lgChipMoralAuthority => 'தார்மீக அதிகாரம்';

  @override
  String get lgChipLegalAptitude => 'சட்ட திறமை';

  @override
  String get lgProfileTitle => 'உங்கள் சட்ட சுயவிவரம் & கர்மா';

  @override
  String get lgPrimaryDriver => 'முதன்மை காரணி';

  @override
  String get lgDharmaAnchor => 'தர்ம அடிப்படை';

  @override
  String get lgAggressionMarker => 'ஆக்ரோஷ குறியீடு';

  @override
  String get lgDocumentationKaraka => 'ஆவண தரம்';

  @override
  String get lgKarakaTitle => 'உங்கள் சட்ட கிரகங்கள்';

  @override
  String get lgKarakaSubtitle =>
      'எந்த கிரகங்கள் உங்கள் சட்ட அதிர்ஷ்டத்தை வடிவமைக்கின்றன';

  @override
  String get lgYogasTitle => 'சட்ட யோகங்கள் & பாதுகாப்புகள்';

  @override
  String get lgCurrentPhase => 'தற்போதைய கட்டம்';

  @override
  String get lgProtections => 'பாதுகாப்புகள்';

  @override
  String get lgDisputePressures => 'சச்சரவு அழுத்தங்கள்';

  @override
  String get lgVerificationTitle =>
      'அனைத்து ஜாதகங்களிலும் உறுதிப்படுத்தப்பட்டது';

  @override
  String get lgD6Litigation => 'D6 வழக்கு ஜாதகம்';

  @override
  String get lgD9Dharma => 'D9 தர்ம ஜாதகம்';

  @override
  String get lgMoralAuthority => 'தார்மீக அதிகாரம்';

  @override
  String get lgVictoryTitle => 'வெற்றி பகுப்பாய்வு';

  @override
  String get lgAsPlaintiff => 'வாதியாக';

  @override
  String get lgAsDefendant => 'பிரதிவாதியாக';

  @override
  String get lgSettlementPreference => 'தீர்வு விருப்பம்';

  @override
  String get lgDisputeCategoriesTitle => 'சச்சரவு வகைகள் கண்காணிப்பு';

  @override
  String get lgLowRiskCategories => 'குறைந்த ஆபத்து வகைகள்';

  @override
  String get lgConflictStyleTitle => 'மோதல் பாணி & எதிரிகள்';

  @override
  String get lgConfrontationComfort => 'எதிர்கொள்வதில் வசதி';

  @override
  String get lgArgumentPersuasiveness => 'வாதத்தின் தாக்கம்';

  @override
  String get lgEmotionalRegulation => 'உணர்ச்சி கட்டுப்பாடு';

  @override
  String get lgGrudgeHolding => 'வெறுப்பு வைத்திருக்கும் போக்கு';

  @override
  String get lgEnemyAnalysisLabel => 'எதிரி பகுப்பாய்வு';

  @override
  String get lgVisibleEnemies => 'வெளிப்படையான எதிரிகள்';

  @override
  String get lgHiddenEnemies => 'மறைந்த எதிரிகள்';

  @override
  String get lgWorkplaceEnemies => 'பணியிட எதிரிகள்';

  @override
  String get lgFamilyEnemies => 'குடும்ப எதிரிகள்';

  @override
  String get lgLegalEnemies => 'சட்ட எதிரிகள்';

  @override
  String get lgEnemyDefeatCapacity => 'எதிரியை வெல்லும் திறன்';

  @override
  String get lgCriminalFinancialTitle => 'குற்றவியல் & நிதி ஆபத்து கண்காணிப்பு';

  @override
  String get lgCriminalRisk => 'குற்றவியல் ஈடுபாடு ஆபத்து';

  @override
  String get lgVictimOfCrime => 'குற்றத்திற்கு பலியாகும் வாய்ப்பு';

  @override
  String get lgFalseAccusation => 'தவறான குற்றச்சாட்டு ஆபத்து';

  @override
  String get lgImprisonmentRisk => 'சிறை ஆபத்து';

  @override
  String get lgTaxDisputeRisk => 'வரி சச்சரவு ஆபத்து';

  @override
  String get lgFinancialFraudRisk => 'நிதி மோசடி ஆபத்து';

  @override
  String get lgBusinessLitigationRisk => 'வணிக வழக்கு ஆபத்து';

  @override
  String get lgBankruptcyRisk => 'திவால் ஆபத்து';

  @override
  String get lgAuditVulnerability => 'தணிக்கை பாதிப்புத்தன்மை';

  @override
  String get lgProtectionPriority => 'பாதுகாப்பு முன்னுரிமை';

  @override
  String get lgContractsTitle => 'ஒப்பந்தங்கள் & பேச்சுவார்த்தை';

  @override
  String get lgContractClarity => 'ஒப்பந்த தெளிவு';

  @override
  String get lgDocumentationDiscipline => 'ஆவணப் பொறுப்புணர்வு';

  @override
  String get lgFinePrintAwareness =>
      'நுட்பமான விதிமுறைகள் குறித்த விழிப்புணர்வு';

  @override
  String get lgSignatureCaution => 'கையொப்பத்தில் எச்சரிக்கை';

  @override
  String get lgMediationReceptivity => 'மத்தியஸ்தத்திற்கான ஏற்புத்தன்மை';

  @override
  String get lgNegotiationSkillFull => 'பேச்சுவார்த்தை திறமை';

  @override
  String get lgCompromiseWillingness => 'சமரசம் செய்யும் விருப்பம்';

  @override
  String get lgFaceSavingNeeds => 'மதிப்பைக் காக்கும் தேவை';

  @override
  String get lgMediatorHireRecommendation =>
      'மத்தியஸ்தரை நியமிக்கும் பரிந்துரை';

  @override
  String get lgTypicalContractIssues => 'பொதுவான ஒப்பந்த சிக்கல்கள்';

  @override
  String get lgCareerFitTitle => 'சட்டத் தொழில் பொருத்தம்';

  @override
  String get lgProfessionAffinity => 'தொழில் ஈடுபாடு';

  @override
  String get lgRoleFit => 'சிறந்த பங்கு பொருத்தம்';

  @override
  String get lgLawStudentSuccess => 'சட்ட மாணவர் வெற்றி';

  @override
  String get lgBarExamSuccess => 'பார் தேர்வு வெற்றி';

  @override
  String get lgTimelineTitle => 'சட்ட காலவரிசை';

  @override
  String get lgNewMatterChance => 'புதிய வழக்கு வாய்ப்பு (அடுத்த 12 மாதங்கள்)';

  @override
  String get lgOngoingCaseOutcome => 'நடைபெறும் வழக்கின் விளைவு';

  @override
  String get lgRecommendedAction => 'பரிந்துரைக்கப்பட்ட நடவடிக்கை';

  @override
  String get lgPeakDisputeYears => 'உச்ச சச்சரவு ஆண்டுகள்';

  @override
  String get lgClarityYears => 'சட்ட தெளிவு ஆண்டுகள்';

  @override
  String get lgAvoidancePeriods => 'முக்கியமான தவிர்க்க வேண்டிய காலம்';

  @override
  String get lgFavorableWindows => 'சாதகமான தீர்வு காலங்கள்';

  @override
  String get lgRisksTitle => 'ஆபத்துகள் & பாதிப்புகள்';

  @override
  String get lgChronicVulnerabilities => 'நீடித்த பாதிப்புகள்';

  @override
  String get lgAvoidDashaPeriods => 'கவனிக்க வேண்டிய தசா காலங்கள்';

  @override
  String get lgPreventivePriorities => 'தடுப்பு முன்னுரிமைகள்';

  @override
  String get lgRedFlags => 'எச்சரிக்கை சூழ்நிலைகள்';

  @override
  String get lgImprovementTitle => 'மேம்பாட்டுத் திட்டம்';

  @override
  String get lgReliabilityTitle => 'நம்பகத்தன்மை';

  @override
  String get lgLayerD1 => 'ஜனன ஜாதகம் (D1)';

  @override
  String get lgLayerD6 => 'வழக்கு ஜாதகம் (D6)';

  @override
  String get lgLayerD9 => 'தர்ம ஜாதகம் (D9)';

  @override
  String get lgLayerDasha => 'தசா காலம்';

  @override
  String get lgLayerTransit => 'கோச்சாரம்';

  @override
  String get lgTopicWinChance => 'எனது வெற்றி வாய்ப்புகள் என்ன?';

  @override
  String get lgTopicStrategy => 'எனக்கு சிறந்த சட்ட உத்தி என்ன?';

  @override
  String get lgTopicContract => 'எந்த ஒப்பந்த ஆபத்துகளை கவனிக்க வேண்டும்?';

  @override
  String get lgTopicTiming => 'சச்சரவுகளை தீர்க்க சிறந்த நேரம் எது?';

  @override
  String get lgTopicSettlement =>
      'நான் சமரசம் செய்ய வேண்டுமா அல்லது போராட வேண்டுமா?';

  @override
  String get lgTopicEnemies => 'எனது மறைந்த எதிரிகள் யார்?';

  @override
  String get lgTopicProtection =>
      'நான் சட்டப்படி என்னை எப்படி பாதுகாத்துக் கொள்வது?';

  @override
  String get lgTopicCareer => 'நான் சட்டத் தொழிலுக்கு பொருத்தமானவனா?';

  @override
  String get prSubtitle => 'AI-இயங்கும் வேத சொத்து அறிக்கை';

  @override
  String get prTitle => 'சொத்து மற்றும் சொத்துக்கள்';

  @override
  String get prSnapshotHeader => 'சொத்து சுருக்கம்';

  @override
  String get prAcquisitionCapacity => 'பெறும் திறன்';

  @override
  String get prHomeOwnership => 'வீட்டு உரிமை';

  @override
  String get prWealthPotential => 'செல்வ சாத்தியம்';

  @override
  String get prRentalIncome => 'வாடகை வருமானம்';

  @override
  String get prLandOwnership => 'நில உரிமை';

  @override
  String get prStatusExcellent => 'சிறப்பானது';

  @override
  String get prStatusStrong => 'வலிமையானது';

  @override
  String get prStatusModerate => 'நடுத்தரம்';

  @override
  String get prStatusDeveloping => 'வளர்ந்து வருகிறது';

  @override
  String get prStatusChallenging => 'சவாலானது';

  @override
  String get prChipHomeOwner => 'வீட்டு உரிமையாளர்';

  @override
  String get prChipWealthBuilder => 'செல்வம் உருவாக்குபவர்';

  @override
  String get prChipLandOwner => 'நில உரிமையாளர்';

  @override
  String get prChipInvestor => 'சொத்து முதலீட்டாளர்';

  @override
  String get prChipInheritance => 'வாரிசு வாய்ப்பு';

  @override
  String get prChipVehicle => 'வாகன உரிமையாளர்';

  @override
  String get prChipGlobalAsset => 'உலகளாவிய சொத்து ஈர்ப்பு';

  @override
  String get prProfileTitle => 'உங்கள் சொத்து பாணி';

  @override
  String get prHomeAesthetics => 'வீட்டு அழகியல்';

  @override
  String get prHomeSanctuary => 'வீடு ஒரு புகலிடமாக';

  @override
  String get prComfortInvestment => 'வசதியில் முதலீடு';

  @override
  String get prVastuPriority => 'வாஸ்து முன்னுரிமை';

  @override
  String get prNaturalElements => 'இயற்கை கூறுகள்';

  @override
  String get prNextActionLabel => 'அடுத்த நடவடிக்கை';

  @override
  String get prKarakaTitle => 'உங்கள் சொத்து கிரகங்கள்';

  @override
  String get prKarakaSubtitle =>
      'எந்த கிரகங்கள் உங்கள் சொத்து அதிர்ஷ்டத்தை வடிவமைக்கின்றன';

  @override
  String get prPrimaryKaraka => 'முதன்மை காரகன்';

  @override
  String get prDurableAsset => 'நீடித்த சொத்து காரகன்';

  @override
  String get prYogasTitle => 'சொத்து யோகங்கள் மற்றும் தோஷங்கள்';

  @override
  String get prCurrentPhase => 'தற்போதைய கட்டம்';

  @override
  String get prBoosters => 'மேம்படுத்திகள்';

  @override
  String get prDrains => 'குறைப்பவைகள்';

  @override
  String get prVerificationTitle => 'பல அட்டவணைகளில் உறுதிப்படுத்தப்பட்டது';

  @override
  String get prD4Property => 'D4 சொத்து அட்டவணை';

  @override
  String get prD16Vehicle => 'D16 வாகன அட்டவணை';

  @override
  String get prVehicleFit => 'வாகன பொருத்தம்';

  @override
  String get prJourneyTitle => 'உரிமை பயணம் மற்றும் காலவரிசை';

  @override
  String get prFirstHomeAge => 'முதல் வீட்டு வயது';

  @override
  String get prFirstHomeType => 'முதல் வீட்டு வகை';

  @override
  String get prMultipleHomes => 'பல வீடுகள்';

  @override
  String get prNewPropertySoon => 'விரைவில் புதிய சொத்து';

  @override
  String get prFirstMajorWindow => 'முதல் முக்கிய காலகட்டம்';

  @override
  String get prBuyingWindow => 'வாங்கும் காலகட்டம்';

  @override
  String get prConstructionWindow => 'கட்டுமான காலகட்டம்';

  @override
  String get prNextOpportunity => 'அடுத்த வாய்ப்பு';

  @override
  String get prLifetimePropertyCount => 'வாழ்நாள் சொத்து எண்ணிக்கை';

  @override
  String get prInheritanceTitle => 'வாரிசு மற்றும் குடும்ப சொத்து';

  @override
  String get prMaternalInheritance => 'தாய்வழி வாரிசு';

  @override
  String get prPaternalInheritance => 'தந்தைவழி வாரிசு';

  @override
  String get prAncestralProperty => 'மூதாதையர் சொத்து';

  @override
  String get prFamilyDisputeRisk => 'குடும்ப தகராறு அபாயம்';

  @override
  String get prInheritanceTiming => 'வாரிசு நேரம்';

  @override
  String get prInheritanceType => 'வாரிசு வகை';

  @override
  String get prLandInvestTitle => 'நிலம், முதலீடு மற்றும் உலகளாவிய சொத்து';

  @override
  String get prPropertyInvestor => 'சொத்து முதலீட்டாளர் மதிப்பெண்';

  @override
  String get prAppreciationLuck => 'மதிப்பு உயர்வு அதிர்ஷ்டம்';

  @override
  String get prInvestorMindset => 'முதலீட்டாளர் மனநிலை';

  @override
  String get prLandType => 'நில வகை';

  @override
  String get prRentalCount => 'வாடகை சொத்து எண்ணிக்கை';

  @override
  String get prMultipleLand => 'பல நில துண்டுகள்';

  @override
  String get prFarmEstate => 'பண்ணை / எஸ்டேட் வாய்ப்பு';

  @override
  String get prGlobalPropertyLabel => 'உலகளாவிய சொத்து';

  @override
  String get prForeignProperty => 'வெளிநாட்டு சொத்து';

  @override
  String get prNriAffinity => 'என்ஆர்ஐ சொத்து ஈர்ப்பு';

  @override
  String get prVehiclesTitle => 'வாகனங்கள்';

  @override
  String get prVehicleCount => 'வாகன எண்ணிக்கை';

  @override
  String get prVehicleFirstAge => 'முதல் வாகன வயது';

  @override
  String get prVehicleCategory => 'வாகன வகை';

  @override
  String get prVehicleQuality => 'வாகன தரம்';

  @override
  String get prLuxuryAffinity => 'ஆடம்பர ஈர்ப்பு';

  @override
  String get prVehicleLossRisk => 'வாகன இழப்பு / சேத அபாயம்';

  @override
  String get prLegalRiskTitle => 'சட்ட மற்றும் அபாய கண்காணிப்பு';

  @override
  String get prBoundaryDisputes => 'எல்லை தகராறுகள்';

  @override
  String get prPartitionDisputes => 'பங்கீட்டு தகராறுகள்';

  @override
  String get prTitleIssues => 'உரிமை / ஆவண பிரச்சினைகள்';

  @override
  String get prTenantConflict => 'வாடகைதாரர்-வீட்டு உரிமையாளர் மோதல்';

  @override
  String get prForcedSale => 'கட்டாய விற்பனை அபாயம்';

  @override
  String get prPropertyDamage => 'சொத்து சேத அபாயம்';

  @override
  String get prInsurancePriority => 'காப்பீட்டு முன்னுரிமை';

  @override
  String get prProtectionUrgency => 'பாதுகாப்பு அவசரம்';

  @override
  String get prProtectiveFactors => 'பாதுகாப்பு காரணிகள்';

  @override
  String get prChronicVulnerabilities => 'நீடித்த பாதிப்புகள்';

  @override
  String get prDueDiligenceTitle => 'விழிப்புணர்வு சரிபார்ப்பு பட்டியல்';

  @override
  String get prPreventiveMeasures => 'தடுப்பு நடவடிக்கைகள்';

  @override
  String get prImprovementTitle => 'மேம்பாட்டு திட்டம்';

  @override
  String get prReliabilityTitle => 'நம்பகத்தன்மை';

  @override
  String get prLayerD1 => 'ஜாதகம் (D1)';

  @override
  String get prLayerD4 => 'சொத்து அட்டவணை (D4)';

  @override
  String get prLayerD16 => 'வாகன அட்டவணை (D16)';

  @override
  String get prLayerDasha => 'தசை காலம்';

  @override
  String get prLayerTransit => 'கோச்சாரம்';

  @override
  String get prTopicBuying => 'வாங்க சிறந்த நேரம் எது?';

  @override
  String get prTopicInherit => 'எனக்கு சொத்து வாரிசாக கிடைக்குமா?';

  @override
  String get prTopicVehicle => 'எனக்கு எப்போது வாகனம் கிடைக்கும்?';

  @override
  String get prTopicRental => 'வாடகை வருமான வாய்ப்பு எப்படி?';

  @override
  String get prTopicLand => 'நில உரிமை வாய்ப்புகள் எப்படி?';

  @override
  String get prTopicLegal => 'கவனிக்க வேண்டிய சட்ட அபாயங்கள் என்ன?';

  @override
  String get prTopicForeign => 'வெளிநாட்டு சொத்து வாய்ப்புகள் எப்படி?';

  @override
  String get prTopicTiming => 'சொத்துக்கான சிறந்த நேரம் எது?';

  @override
  String get edTitle => 'கல்வி மற்றும் கற்றல் பகுப்பாய்வு';

  @override
  String get edSubtitle => 'AI-இயங்கும் வேத கல்வி அறிக்கை';

  @override
  String get edSnapshotHeader => 'உங்கள் கல்வி ஸ்னாப்ஷாட்';

  @override
  String get edOverallStrength => 'ஒட்டுமொத்த வலிமை';

  @override
  String get edAcademicSuccess => 'கல்வி வெற்றி';

  @override
  String get edLearningCapacity => 'கற்றல் திறன்';

  @override
  String get edIntellect => 'அறிவாற்றல்';

  @override
  String get edMemory => 'நினைவாற்றல்';

  @override
  String get edStatusExcellent => 'சிறந்த சாத்தியக்கூறு';

  @override
  String get edStatusStrong => 'வலுவான சாத்தியக்கூறு';

  @override
  String get edStatusModerate => 'மிதமான சாத்தியக்கூறு';

  @override
  String get edStatusDeveloping => 'வளர்ந்து வரும் சாத்தியக்கூறு';

  @override
  String get edStatusChallenging => 'சவாலான கட்டம்';

  @override
  String get edChipSaraswati => 'சரஸ்வதி யோகம்';

  @override
  String get edChipGajaKesari => 'கஜகேசரி யோகம்';

  @override
  String get edChipBudhaAditya => 'புத ஆதித்ய யோகம்';

  @override
  String get edChipResearch => 'வலுவான ஆராய்ச்சி திறன்';

  @override
  String get edChipScholarship => 'உதவித்தொகை சாத்தியக்கூறு';

  @override
  String get edChipDoctorate => 'முனைவர் பட்ட சாத்தியக்கூறு';

  @override
  String get edChipForeign => 'வெளிநாட்டு கல்வி ஆதரவு';

  @override
  String get edChipLifelong => 'வாழ்நாள் முழுவதும் கற்பவர்';

  @override
  String get edLearningStyleTitle => 'உங்கள் கற்றல் பாணி';

  @override
  String get edSoulPlanet => 'ஆத்ம கிரகம்';

  @override
  String get edSoulHint =>
      'உங்கள் ஆழமான உள்ளார்ந்த உந்துதல் மற்றும் வாழ்க்கை நோக்கம்';

  @override
  String get edSubjectPlanet => 'பாட கிரகம்';

  @override
  String get edTechAtmakaraka => 'ஆத்மகாரகா (தொழில்நுட்பம்)';

  @override
  String get edTechAmatyakaraka => 'அமாத்தியகாரகா (தொழில்நுட்பம்)';

  @override
  String get edSubjectKarakaStrength => 'பாட காரக வலிமை';

  @override
  String get edFoundationTitle => 'கல்வி அடித்தளம்';

  @override
  String get edHouse4 => 'ஆரம்பக் கல்வி';

  @override
  String get edHouse5 => 'அறிவுத்திறன்';

  @override
  String get edHouse9 => 'உயர் கல்வி';

  @override
  String get edPurvaPunya => 'முன்பிறவி புண்ணியம்';

  @override
  String get edStudyPlanetsTitle => 'உங்கள் படிப்பு கிரகங்கள்';

  @override
  String get edYogasTitle => 'உங்கள் ஜாதகத்தில் கல்வி யோகங்கள்';

  @override
  String get edYogaBudhaAditya => 'புத ஆதித்யா';

  @override
  String get edYogaGajaKesari => 'கஜகேசரி';

  @override
  String get edYogaSaraswati => 'சரஸ்வதி';

  @override
  String get edYogaPresent => 'இருக்கிறது';

  @override
  String get edYogaAbsent => 'இல்லை';

  @override
  String get edYogaNoneNote =>
      'பாரம்பரிய கல்வி யோகங்கள் இல்லை — வெற்றி தொடர்ச்சியான முயற்சி மற்றும் ஒழுக்கத்திலிருந்து வருகிறது.';

  @override
  String get edVerificationTitle => 'பல ஜாதகங்களில் உறுதிப்படுத்தல்';

  @override
  String get edD24Learning => 'D24 — ஆழ்ந்த கற்றல் ஜாதகம்';

  @override
  String get edD4Formal => 'D4 — முறையான கல்வி ஜாதகம்';

  @override
  String get edD9Dharma => 'D9 — கற்றல் தர்ம ஜாதகம்';

  @override
  String get edD60Karma => 'D60 — முன்பிறவி கற்றல் கர்மா';

  @override
  String get edSubjectsTitle => 'உங்களுக்கான சிறந்த பாடங்கள்';

  @override
  String get edSubjectsSubtitle => 'ஜாதக பொருத்தத்தின் அடிப்படையில் தரவரிசை';

  @override
  String get edLowAffinity => 'குறைந்த பொருத்தமுள்ள பாடங்கள்';

  @override
  String get edDegreesTitle => 'பட்டம் மற்றும் நிலை சாத்தியக்கூறு';

  @override
  String get edExpectedLevel => 'எதிர்பார்க்கப்படும் நிலை';

  @override
  String get edDegreeFormal => 'முறையான பட்டம்';

  @override
  String get edDegreePostgrad => 'முதுகலை';

  @override
  String get edDegreeDoctorate => 'முனைவர் பட்டம்';

  @override
  String get edDegreeForeign => 'வெளிநாட்டு கல்வி';

  @override
  String get edTimelineTitle => 'படிப்பு காலவரிசை';

  @override
  String get edEarlySchooling => 'ஆரம்பக் கல்வி காலம்';

  @override
  String get edHigherEducation => 'உயர் கல்வி காலம்';

  @override
  String get edPostgradResearch => 'முதுகலை / ஆராய்ச்சி காலம்';

  @override
  String get edPeakLearningAge => 'உச்சக்கட்ட கற்றல் வயது';

  @override
  String get edPreferencesTitle => 'கற்றல் விருப்பங்கள் மற்றும் ஆதரவு';

  @override
  String get edPrefStudyMode => 'படிப்பு முறை';

  @override
  String get edPrefTiming => 'சிறந்த நேரம்';

  @override
  String get edPrefEnvironment => 'சூழல்';

  @override
  String get edPrefLocation => 'இடம்';

  @override
  String get edPrefForeign => 'வெளிநாட்டு படிப்பு';

  @override
  String get edGuruRelationship => 'ஆசிரியர்/குரு பிணைப்பு';

  @override
  String get edMentorAvailability => 'வழிகாட்டி கிடைப்பு';

  @override
  String get edPeerLearning => 'சக மாணவர் கற்றல்';

  @override
  String get edAuthorityDeference => 'அதிகாரத்தின் மீதான மரியாதை';

  @override
  String get edStrengthsTitle => 'பலம் மற்றும் சவால்கள்';

  @override
  String get edCognitiveGifts => 'அறிவாற்றல் பரிசுகள்';

  @override
  String get edNaturalAbilities => 'இயற்கையான கற்றல் திறன்கள்';

  @override
  String get edHiddenCapacities => 'மறைந்திருக்கும் திறன்கள்';

  @override
  String get edConcentration => 'கவனம் செலுத்துவதில் சிரமம்';

  @override
  String get edBreakRisk => 'கல்வியில் இடைவெளி ஏற்படும் அபாயம்';

  @override
  String get edDisciplineConsistency => 'ஒழுக்க நிலைத்தன்மை';

  @override
  String get edScholarshipLikelihood => 'உதவித்தொகை சாத்தியக்கூறு';

  @override
  String get edCareerLinkTitle => 'கல்வி → தொழில் பாதை';

  @override
  String get edDirectionRec => 'பரிந்துரைக்கப்பட்ட திசை';

  @override
  String get edIntegrationStrategy => 'ஒருங்கிணைப்பு உத்தி';

  @override
  String get edCareerLinkage => 'தொழில் தொடர்பு';

  @override
  String get edAlignedSubjects => 'தொழிலுக்கு ஏற்ற பாடங்கள்';

  @override
  String get edDegreeUtility => 'தொழிலுக்கான பட்டத்தின் பயன்பாடு';

  @override
  String get edImprovementTitle => 'உங்கள் மேம்பாட்டுத் திட்டம்';

  @override
  String get edReliabilityTitle => 'கணிப்பு நம்பகத்தன்மை';

  @override
  String get edLayerD1 => 'பிறப்பு ஜாதகம் (D1)';

  @override
  String get edLayerD4 => 'முறையான கல்வி (D4)';

  @override
  String get edLayerD9 => 'நவாம்சம் (D9)';

  @override
  String get edLayerD24 => 'ஆழ்ந்த கற்றல் (D24)';

  @override
  String get edLayerD60 => 'முன்பிறவி கற்றல் (D60)';

  @override
  String get edLayerAmk => 'பாட காரகா';

  @override
  String get edLayerMj => 'புதன்-குரு';

  @override
  String get edLayerDasha => 'கிரக காலம்';

  @override
  String get edTopicSubjects => 'எனக்கான சிறந்த பாடங்கள்';

  @override
  String get edTopicDegree => 'பட்டம் பெறும் வாய்ப்புகள்';

  @override
  String get edTopicAbroad => 'வெளிநாட்டில் படிப்பு';

  @override
  String get edTopicExam => 'தேர்வு செயல்திறன்';

  @override
  String get edTopicHabits => 'படிப்பு பழக்கங்கள்';

  @override
  String get edTopicCareerLink => 'கல்வி-தொழில் தொடர்பு';

  @override
  String get edTopicTiming => 'கல்வி காலக்கெடு';

  @override
  String get edTopicScholarship => 'உதவித்தொகை வாய்ப்புகள்';

  @override
  String get hwTitle => 'உடல்நலம் & நல்வாழ்வு பகுப்பாய்வு';

  @override
  String get hwSubtitle => 'AI-இயக்கப்படும் வேத உடல்நலம் & நல்வாழ்வு அறிக்கை';

  @override
  String get hwSnapshotHeader => 'உங்கள் உடல்நல சுருக்கம்';

  @override
  String get hwOverallVitality => 'உயிர்ச்சக்தி';

  @override
  String get hwImmunity => 'நோய் எதிர்ப்பு சக்தி';

  @override
  String get hwRecovery => 'மீட்சி';

  @override
  String get hwMentalWellness => 'மன நலம்';

  @override
  String get hwStressTolerance => 'மன அழுத்த சகிப்புத்தன்மை';

  @override
  String get hwStatusThriving => 'சிறப்பாக உள்ளது';

  @override
  String get hwStatusGood => 'நல்ல உயிர்ச்சக்தி';

  @override
  String get hwStatusBalanced => 'சமநிலை';

  @override
  String get hwStatusNeedsCare => 'கவனிப்பு தேவை';

  @override
  String get hwStatusNeedsAttention => 'கவனம் தேவை';

  @override
  String get hwChipImmunity => 'வலுவான நோய் எதிர்ப்பு சக்தி';

  @override
  String get hwChipRecovery => 'வேகமான மீட்சி';

  @override
  String get hwChipMentalBalance => 'சமநிலையான மனம்';

  @override
  String get hwChipStressResilience => 'மன அழுத்தத்தை தாங்கும் திறன்';

  @override
  String get hwChipFertility => 'கருவுறுதல் ஆதரவு';

  @override
  String get hwChipWorkLife => 'நல்ல வேலை-வாழ்க்கை சமநிலை';

  @override
  String get hwChipLowAddiction => 'குறைந்த போதை ஆபத்து';

  @override
  String get hwConstitutionTitle => 'உங்கள் உடல் வகை';

  @override
  String get hwConstitutionSubtitle =>
      'உங்கள் ஜாதகத்தில் இருந்து ஆயுர்வேத இயல்பு';

  @override
  String get hwDominantDosha => 'முதன்மை';

  @override
  String get hwSecondaryDosha => 'இரண்டாம் நிலை';

  @override
  String get hwPrimaryKaraka => 'முதன்மை உடல்நல குறிகாட்டி';

  @override
  String get hwStrongestSystem => 'மிகவும் வலிமையான அமைப்பு';

  @override
  String get hwWeakestSystem => 'ஆதரவு தேவைப்படும் அமைப்பு';

  @override
  String get hwBodyMapTitle => 'உங்கள் உடலின் கிரக வரைபடம்';

  @override
  String get hwBodyMapSubtitle => '9 கிரகங்கள், 9 உடல் அமைப்புகள்';

  @override
  String get hwYogaTitle => 'உங்கள் ஜாதகத்தில் உடல்நல அமைப்புகள்';

  @override
  String get hwYogaSubtitle => 'பாதுகாப்பு எதிராக நோய்-அழுத்த யோகங்கள்';

  @override
  String get hwDiseasePressureLabel => 'நோய் அழுத்தம்';

  @override
  String get hwAreasTitle => 'கவனிக்க வேண்டிய உடல் பகுதிகள்';

  @override
  String get hwAreasSubtitle => 'உடல் பகுதி வாரியாக பாதிப்புத்தன்மை';

  @override
  String get hwProtectedAreas => 'நன்கு பாதுகாக்கப்பட்ட பகுதிகள்';

  @override
  String get hwCategoriesTitle => 'நோய்-வகை கண்காணிப்பு';

  @override
  String get hwCategoriesSubtitle => 'முக்கிய உடல்நல வகைகளில் பாதிப்புத்தன்மை';

  @override
  String get hwLowRiskCategories => 'குறைந்த ஆபத்து வகைகள்';

  @override
  String get hwMentalTitle => 'மன & உணர்ச்சி நலம்';

  @override
  String get hwMentalSubtitle => 'உணர்ச்சி மீட்சித்திறன் மற்றும் ஆதரவு தேவைகள்';

  @override
  String get hwMentalVulnerability => 'உணர்ச்சி உணர்திறன்';

  @override
  String get hwEmotionalRegulation => 'உணர்ச்சி கட்டுப்பாடு';

  @override
  String get hwSupportRec => 'ஆதரவு பரிந்துரை';

  @override
  String get hwTendencies => 'மன போக்குகள்';

  @override
  String get hwTimelineTitle => 'உடல்நல காலவரிசை';

  @override
  String get hwTimelineSubtitle =>
      'உச்ச ஆண்டுகள், எச்சரிக்கை ஆண்டுகள் & மீட்சி காலங்கள்';

  @override
  String get hwPeakYears => 'உச்ச நல்வாழ்வு ஆண்டுகள்';

  @override
  String get hwCautionYears => 'எச்சரிக்கை ஆண்டுகள்';

  @override
  String get hwRecoveryWindow => 'மீட்சி காலம்';

  @override
  String get hwCheckupYears => 'பரிந்துரைக்கப்பட்ட பரிசோதனை ஆண்டுகள்';

  @override
  String get hwCurrentPhase => 'தற்போதைய கட்டம்';

  @override
  String get hwLifestyleTitle => 'உங்கள் வாழ்க்கை முறை வழிகாட்டி';

  @override
  String get hwLifestyleSubtitle =>
      'தினசரி பழக்கவழக்கங்கள் பற்றி உங்கள் ஜாதகம் என்ன சொல்கிறது';

  @override
  String get hwSleepDiscipline => 'தூக்க கட்டுப்பாட்டின் தாக்கம்';

  @override
  String get hwDietDiscipline => 'உணவு கட்டுப்பாட்டின் தாக்கம்';

  @override
  String get hwExerciseNeed => 'உடற்பயிற்சி தேவை';

  @override
  String get hwSunlightNeed => 'வெயில் தேவை';

  @override
  String get hwStressSusceptibility => 'மன அழுத்த உணர்திறன்';

  @override
  String get hwHydrationSensitivity => 'நீரூட்டல் உணர்திறன்';

  @override
  String get hwSocialType => 'சமூக ஆற்றல் வகை';

  @override
  String get hwHealingSpeed => 'குணமாகும் வேகம்';

  @override
  String get hwTreatmentResponse => 'சிகிச்சை பதில்';

  @override
  String get hwAltHealing => 'மாற்று மருத்துவத்தின் மீதான ஈடுபாடு';

  @override
  String get hwSpecialTitle => 'வாழ்க்கை-கட்டம் & சிறப்பு தலைப்புகள்';

  @override
  String get hwSpecialSubtitle =>
      'கருவுறுதல், குழந்தைப்பருவ உடல்நலம், பழக்கங்கள் & சோர்வு';

  @override
  String get hwFertility => 'கருவுறுதல் குறிகாட்டி';

  @override
  String get hwHormonalBalance => 'ஹார்மோன் சமநிலை';

  @override
  String get hwReproductiveStrength => 'இனப்பெருக்க அமைப்பின் வலிமை';

  @override
  String get hwChildhoodVuln => 'குழந்தைப்பருவ உடல்நல பாதிப்புத்தன்மை';

  @override
  String get hwChildhoodStatus => 'குழந்தைப்பருவ உடல்நலம்';

  @override
  String get hwAddictionVuln => 'போதை பாதிப்புத்தன்மை';

  @override
  String get hwAddictionRecovery => 'மீட்சி திறன்';

  @override
  String get hwBurnoutVuln => 'சோர்வு பாதிப்புத்தன்மை';

  @override
  String get hwWorkLifeBalance => 'வேலை-வாழ்க்கை சமநிலை';

  @override
  String get hwStressTriggers => 'மன அழுத்த தூண்டுதல்கள்';

  @override
  String get hwProtectiveFactors => 'பாதுகாப்பு காரணிகள்';

  @override
  String get hwChallengesTitle => 'கவனிக்க வேண்டிய சவால்கள்';

  @override
  String get hwChallengesSubtitle =>
      'தடுப்பு பராமரிப்பில் எங்கு கவனம் செலுத்த வேண்டும்';

  @override
  String get hwMitigation => 'எவ்வாறு நிர்வகிப்பது';

  @override
  String get hwChronicAreas => 'நீண்டகால பாதிப்பு பகுதிகள்';

  @override
  String get hwPreventivePriorities => 'தடுப்பு முன்னுரிமைகள்';

  @override
  String get hwImprovementTitle => 'உங்கள் நல்வாழ்வு திட்டம்';

  @override
  String get hwImprovementSubtitle => 'நடைமுறை படிகள் + பாரம்பரிய மருந்துகள்';

  @override
  String get hwReliabilityTitle => 'நம்பகத்தன்மை நிலை';

  @override
  String get hwLayerD1 => 'ஜாதகம் (D1)';

  @override
  String get hwLayerD6 => 'உடல்நல ஜாதகம் (D6)';

  @override
  String get hwLayerD30 => 'நுண்-உடல்நல ஜாதகம் (D30)';

  @override
  String get hwLayerDasha => 'கிரக காலக்கணிப்பு';

  @override
  String get hwLayerTransit => 'தற்போதைய கோச்சாரம்';

  @override
  String get hwDisclaimerLabel => 'மருத்துவ மறுப்பு அறிக்கை';

  @override
  String get hwTopicImmunity => 'நோய் எதிர்ப்பு சக்தியை அதிகரிக்கவும்';

  @override
  String get hwTopicSleep => 'தூக்கம் & ஓய்வு';

  @override
  String get hwTopicStress => 'மன அழுத்தத்தை நிர்வகிக்கவும்';

  @override
  String get hwTopicFertility => 'கருவுறுதல் காலம்';

  @override
  String get hwTopicDiet => 'உணவு & ஊட்டச்சத்து';

  @override
  String get hwTopicTiming => 'உடல்நல கால சாளரங்கள்';

  @override
  String get hwTopicMental => 'மன நலம்';

  @override
  String get hwTopicPrevention => 'தடுப்பு பராமரிப்பு திட்டம்';

  @override
  String get lvSubtitle => 'AI-இயங்கும் வேத காதல் அறிக்கை';

  @override
  String get lvTitle => 'காதல் & உறவுகள்';

  @override
  String get lvLovePotential => 'காதல் திறன்';

  @override
  String get lvEmotionalAvail => 'உணர்வுபூர்வமாக திறந்த மனது';

  @override
  String get lvAttraction => 'ஈர்ப்பு';

  @override
  String get lvCommitment => 'அர்ப்பணிப்பு';

  @override
  String get lvCommunication => 'தொடர்பு';

  @override
  String get lvFidelity => 'விசுவாசம்';

  @override
  String get lvChipLoyal => 'விசுவாசமான இதயம்';

  @override
  String get lvChipOpenHeart => 'திறந்த மனது கொண்டவர்';

  @override
  String get lvChipCommunicator => 'சிறந்த தொடர்பாளர்';

  @override
  String get lvChipMature => 'மோதலை நன்றாக கையாள்பவர்';

  @override
  String get lvChipEmotionallyWise => 'உணர்வுபூர்வமாக ஞானமுள்ளவர்';

  @override
  String get lvLoveStyle => 'உங்கள் காதல் பாணி';

  @override
  String get lvAttractionStyle => 'ஈர்ப்பு பாணி';

  @override
  String get lvLangGiven => 'நீங்கள் காதலை வெளிப்படுத்தும் விதம்';

  @override
  String get lvLangReceived => 'நீங்கள் காதலை உணரும் விதம்';

  @override
  String get lvLovePlanets => 'உங்கள் காதல் கிரகங்கள்';

  @override
  String get lvLoveKaraka => 'காதல்';

  @override
  String get lvEmotionKaraka => 'உணர்வு';

  @override
  String get lvPassionKaraka => 'ஆர்வம்';

  @override
  String get lvPathToLove => 'காதலுக்கான உங்கள் பாதை';

  @override
  String get lvPathSub => 'காதல் vs பெற்றோர் ஏற்பாட்டு திருமணம்';

  @override
  String get lvLoveMarriage => 'காதல் திருமணம்';

  @override
  String get lvArrangedMarriage => 'பெற்றோர் ஏற்பாட்டு திருமணம்';

  @override
  String get lvParentalAccept => 'பெற்றோர் ஏற்பு';

  @override
  String get lvInterCaste => 'மறு சாதி / மதம்';

  @override
  String get lvIdealPartner => 'உங்கள் இலட்சிய துணை';

  @override
  String get lvPersonality => 'ஆளுமை';

  @override
  String get lvAppearance => 'தோற்றம்';

  @override
  String get lvIdealTraits => 'இலட்சிய குணங்கள்';

  @override
  String get lvWhatMatters => 'மிக முக்கியமானது என்ன';

  @override
  String get lvDrawnTo => 'ஈர்க்கப்படுவது';

  @override
  String get lvDealbreakers => 'உறவை முறிக்கும் காரணங்கள்';

  @override
  String get lvYourAppeal => 'உங்கள் கவர்ச்சி';

  @override
  String get lvLoveStory => 'உங்கள் காதல் கதை';

  @override
  String get lvLoveStorySub => 'உறவு முறைகள்';

  @override
  String get lvFirstLove => 'முதல் காதல்';

  @override
  String get lvRelationCount => 'முக்கிய உறவுகள்';

  @override
  String get lvDuration => 'வழக்கமான காலஅளவு';

  @override
  String get lvDepth => 'உணர்வு ஆழம்';

  @override
  String get lvDatingPattern => 'டேட்டிங் முறை';

  @override
  String get lvCommitIntimacy => 'அர்ப்பணிப்பு & நெருக்கம்';

  @override
  String get lvCommitReady => 'அர்ப்பணிப்புக்கான தயார்நிலை';

  @override
  String get lvIntimacyDrive => 'நெருக்கத்திற்கான ஆசை';

  @override
  String get lvSensuality => 'ஈர்ப்புணர்வு';

  @override
  String get lvEmpathy => 'பரிவு';

  @override
  String get lvCommitStyle => 'அர்ப்பணிப்பு பாணி';

  @override
  String get lvChemistry => 'வேதி இணக்கப் பாணி';

  @override
  String get lvMakesCommit => 'உங்களை அர்ப்பணிக்க வைப்பது என்ன';

  @override
  String get lvMakesFlee => 'உங்களை விலக்கி தள்ளுவது என்ன';

  @override
  String get lvEmotional => 'உணர்வுசார் அறிவாற்றல்';

  @override
  String get lvEmotionalIQ => 'உணர்வுசார் IQ';

  @override
  String get lvConflictStyle => 'மோதல் பாணி';

  @override
  String get lvTiming => 'காதல் நேரம்';

  @override
  String get lvNewLove12 => '12 மாதங்களில் புதிய காதல்';

  @override
  String get lvEnergyNow => 'இப்போதைய ஆற்றல்';

  @override
  String get lvPhaseNow => 'இப்போதைய கட்டம்';

  @override
  String get lvPeakRomance => 'காதலின் உச்ச ஆண்டுகள்';

  @override
  String get lvNewLoveWindow => 'புதிய காதல் காலகட்டம்';

  @override
  String get lvChallenges => 'கவனிக்க வேண்டிய சவால்கள்';

  @override
  String get lvRiskHeartbreak => 'மனம் புண்படும் அபாயம்';

  @override
  String get lvRiskSabotage => 'சுய-தடை';

  @override
  String get lvRiskCommitFear => 'அர்ப்பணிப்பு பயம்';

  @override
  String get lvRiskRepeat => 'மீண்டும் மீண்டும் நிகழும் முறைகள்';

  @override
  String get lvRiskWorkaholic => 'காதலை விட வேலை';

  @override
  String get lvRedFlags => 'கவனிக்க வேண்டிய எச்சரிக்கை அறிகுறிகள்';

  @override
  String get lvHealing => 'குணப்படுத்த வேண்டியவை';

  @override
  String get lvFocusArea => 'கவனம் செலுத்த வேண்டிய பகுதி';

  @override
  String get lvHealDir => 'குணப்படுத்தும் திசை';

  @override
  String get lvImprovementPlan => 'மேம்பாட்டுத் திட்டம்';

  @override
  String get lvReliability => 'கணிப்பு நம்பகத்தன்மை';

  @override
  String get lvLayerBirth => 'ஜாதகம் (D1)';

  @override
  String get lvLayerNavamsa => 'நவாம்சம் (D9)';

  @override
  String get lvLayerSaptamsa => 'சப்தாம்சம் (D7)';

  @override
  String get lvLayerDasha => 'தசை காலம்';

  @override
  String get lvLayerTransit => 'தற்போதைய கோச்சாரம்';

  @override
  String get lvTopicWhen => 'எனக்கு எப்போது காதல் கிடைக்கும்?';

  @override
  String get lvTopicSoulmate => 'என் ஆத்ம துணையைப் பற்றி';

  @override
  String get lvTopicCurrent => 'எனது தற்போதைய உறவு';

  @override
  String get lvTopicHeal => 'கடந்த காலத்திலிருந்து குணமடைதல்';

  @override
  String get lvTopicCommit => 'அர்ப்பணிப்பு உதவி';

  @override
  String get lvTopicLoveVsArranged => 'காதல் vs பெற்றோர் ஏற்பாட்டு திருமணம்';

  @override
  String get lvTopicHeartbreak => 'மனம் புண்படுவதைத் தவிர்த்தல்';

  @override
  String get lvTopicConfidence => 'காதலில் நம்பிக்கை';

  @override
  String get mrSubtitle => 'AI-இயக்கும் வேத திருமண அறிக்கை';

  @override
  String get mrTitle => 'திருமணம் & குடும்பம்';

  @override
  String get mrMarriagePotential => 'திருமண சாத்தியம்';

  @override
  String get mrHarmony => 'இணக்கம்';

  @override
  String get mrLongevity => 'நீடித்த தன்மை';

  @override
  String get mrSatisfaction => 'திருப்தி';

  @override
  String get mrStability => 'வீட்டு நிலைத்தன்மை';

  @override
  String get mrClarity => 'தெளிவு';

  @override
  String get mrChipHarmony => 'இணக்கமான பந்தம்';

  @override
  String get mrChipNoMangal => 'மங்கள தோஷம் இல்லை';

  @override
  String get mrChipLongLasting => 'நீண்டகாலம் நீடிக்கும்';

  @override
  String get mrChipHome => 'சொந்த வீடு அமையும் வாய்ப்பு';

  @override
  String get mrChipInLaws => 'நல்ல மாமியார் வீட்டார்';

  @override
  String get mrChipChildren => 'குழந்தை பாக்கியம்';

  @override
  String get mrSpouse => 'உங்கள் எதிர்கால துணை';

  @override
  String get mrSpouseSub => 'ஜாதகம் என்ன கூறுகிறது';

  @override
  String get mrSpouseTraits => 'சாத்தியமான குணநலன்கள்';

  @override
  String get mrSpouseWork => 'சாத்தியமான தொழில்';

  @override
  String get mrAgeDiff => 'வயது வித்தியாசம்';

  @override
  String get mrCulture => 'பண்பாட்டு பொருத்தம்';

  @override
  String get mrEducation => 'கல்வி';

  @override
  String get mrFamilyBg => 'குடும்ப பின்னணி';

  @override
  String get mrSoulPartnership => 'ஆன்மா & கூட்டு வாழ்க்கை';

  @override
  String get mrSelfPlanet => 'பந்தத்தில் நீங்கள்';

  @override
  String get mrSpousePlanet => 'உங்கள் துணை கிரகம்';

  @override
  String get mrSoulAlignment => 'ஆன்மீக இணக்கம்';

  @override
  String get mrAlignStrong =>
      'உங்கள் ஆன்மாவும் உங்கள் இலட்சிய துணையும் மிகவும் நன்றாக பொருந்துகின்றனர் — ஒரு நிறைவான பந்தம் நன்கு ஆதரிக்கப்படுகிறது.';

  @override
  String get mrAlignModerate =>
      'உங்கள் ஆன்மாவும் உங்கள் இலட்சிய துணையும் மிதமான இணக்கத்தில் உள்ளனர் — நினைவுடன் முயற்சி செய்தால் ஒரு நிறைவான பந்தம் வளரும்.';

  @override
  String get mrAlignLow =>
      'உங்கள் ஆன்மாவுக்கும் கூட்டு வாழ்க்கைக்கும் நினைவுடன் இணக்கம் தேவை — உங்கள் உள்ளார்ந்த மதிப்புகளுக்கு உண்மையாக பொருந்தும் துணையை தேர்ந்தெடுங்கள்.';

  @override
  String get mrTechDarakaraka => 'துணை கிரகம் (தாரகாரகன்)';

  @override
  String get mrUpapada => 'திருமண புள்ளி (உபபதம்)';

  @override
  String get mrUpapadaLord => 'உபபத அதிபதி';

  @override
  String get mrFoundation => 'திருமண அடித்தளம்';

  @override
  String get mrMarriageSign => 'திருமண ராசி';

  @override
  String get mrMarriageLord => 'திருமண அதிபதி';

  @override
  String get mrHouseStrength => 'பாவ பலம்';

  @override
  String get mrPartnerHint => 'உங்கள் ஜாதகத்தில் இருந்து துணை குறிப்பு';

  @override
  String get mrHarmonyHdr => 'பொருத்த இணக்கம்';

  @override
  String get mrHarmonySub => 'நீங்கள் இருவரும் எப்படி இணைவீர்கள்';

  @override
  String get mrEmotional => 'உணர்ச்சி ரீதியான';

  @override
  String get mrIntellectual => 'அறிவார்ந்த';

  @override
  String get mrPhysical => 'உடல் நெருக்கம்';

  @override
  String get mrFinancial => 'நிதி சார்ந்த';

  @override
  String get mrCommunication => 'தொடர்பு';

  @override
  String get mrSharedValues => 'பகிரப்பட்ட மதிப்புகள்';

  @override
  String get mrSpiritual => 'ஆன்மீகம்';

  @override
  String get mrConflictRes => 'முரண்பாடு தீர்வு';

  @override
  String get mrTiming => 'திருமண காலம்';

  @override
  String get mrFirstMarriageAge => 'சாத்தியமான திருமண வயது';

  @override
  String get mrDelayChance => 'தாமத வாய்ப்பு';

  @override
  String get mrMarriageWindow => 'திருமண காலகட்டம்';

  @override
  String get mrSecondaryWindow => 'மாற்று காலகட்டம்';

  @override
  String get mrCurrentReadiness => 'இப்போதைய நிலை';

  @override
  String get mrJourney => 'திருமண பயணம்';

  @override
  String get mrJourneySub => 'பந்தம் எப்படி வளர்கிறது';

  @override
  String get mrPhaseEarly => 'ஆரம்ப ஆண்டுகள்';

  @override
  String get mrPhaseMid => 'நடு ஆண்டுகள்';

  @override
  String get mrPhaseMature => 'முதிர்ந்த ஆண்டுகள்';

  @override
  String get mrPhaseLate => 'பிற்கால ஆண்டுகள்';

  @override
  String get mrTip => 'குறிப்பு';

  @override
  String get mrFamilyHome => 'குடும்பம் & வீடு';

  @override
  String get mrInLaws => 'மாமியார் வீட்டார் உறவு';

  @override
  String get mrFamilyHarmony => 'குடும்ப இணக்கம்';

  @override
  String get mrHomeOwnership => 'வீட்டு உரிமை';

  @override
  String get mrDomesticPeace => 'வீட்டு அமைதி';

  @override
  String get mrFertility => 'கருவுறும் திறன்';

  @override
  String get mrParenting => 'பெற்றோர் பொறுப்பில் இணக்கம்';

  @override
  String get mrChildren => 'குழந்தைகள்';

  @override
  String get mrLikelyCount => 'சாத்தியமான எண்ணிக்கை';

  @override
  String get mrVerification => 'பல ஜாதகங்கள் ஒப்பீடு';

  @override
  String get mrD9 => 'திருமண ஜாதகம் (D9)';

  @override
  String get mrD10 => 'தொழில்-துணை ஜாதகம் (D10)';

  @override
  String get mrD60 => 'கர்ம ஜாதகம் (D60)';

  @override
  String get mrChallenges => 'கவனிக்க வேண்டிய சவால்கள்';

  @override
  String get mrMangalPresent =>
      'ஜாதகத்தில் மங்கள தோஷம் உள்ளது — பரிகாரங்களையும் பொருத்தத்தையும் கவனமாக ஆராயுங்கள்.';

  @override
  String get mrMangalAbsent =>
      'மங்கள தோஷம் இல்லை — இது திருமணத்திற்கு ஒரு நல்ல அறிகுறி.';

  @override
  String get mrRiskConflict => 'முரண்பாடு';

  @override
  String get mrRiskSeparation => 'பிரிவினை';

  @override
  String get mrRiskDistance => 'உணர்ச்சி தூரம்';

  @override
  String get mrRiskInfidelity => 'நம்பிக்கை துரோகம்';

  @override
  String get mrRiskFinance => 'பண கருத்து வேறுபாடுகள்';

  @override
  String get mrPartnerGuide => 'துணை வழிகாட்டி';

  @override
  String get mrPartnerGuideSub => 'எதை கவனிக்க வேண்டும்';

  @override
  String get mrSeek => 'இவற்றை தேடுங்கள்';

  @override
  String get mrMatchingPriorities => 'பொருத்த முன்னுரிமைகள்';

  @override
  String get mrImprovementPlan => 'மேம்பாட்டு திட்டம்';

  @override
  String get mrReliability => 'கணிப்பு நம்பகத்தன்மை';

  @override
  String get mrLayerBirth => 'பிறப்பு ஜாதகம் (D1)';

  @override
  String get mrLayerNavamsa => 'நவாம்சம் (D9)';

  @override
  String get mrLayerDashamsa => 'தசாம்சம் (D10)';

  @override
  String get mrLayerShashtiamsa => 'கர்மம் (D60)';

  @override
  String get mrLayerDarakaraka => 'துணை கிரகம்';

  @override
  String get mrTopicWhen => 'எனக்கு எப்போது திருமணம் ஆகும்?';

  @override
  String get mrTopicSpouse => 'என் துணையை பற்றி';

  @override
  String get mrTopicCompat => 'பொருத்த குறிப்புகள்';

  @override
  String get mrTopicDelay => 'திருமண தாமதம்';

  @override
  String get mrTopicMangal => 'மங்கள தோஷம்';

  @override
  String get mrTopicChildren => 'குழந்தை பேறு காலம்';

  @override
  String get mrTopicInLaws => 'மாமியார் வீட்டார் உறவு';

  @override
  String get mrTopicHarmony => 'இணக்கத்தை உருவாக்குதல்';

  @override
  String get wlSubtitle => 'AI-இயங்கும் வேத செல்வ அறிக்கை';

  @override
  String get wlTitle => 'செல்வம் & நிதி';

  @override
  String get wlWealthPotential => 'செல்வ திறன்';

  @override
  String get wlAccumulation => 'குவிப்பு';

  @override
  String get wlIncomeFlow => 'வருமான ஓட்டம்';

  @override
  String get wlRetention => 'தக்கவைப்பு';

  @override
  String get wlSustainability => 'நிலைத்தன்மை';

  @override
  String get wlSavings => 'சேமிப்பு ஒழுக்கம்';

  @override
  String get wlChipSaver => 'இயல்பான சேமிப்பாளர்';

  @override
  String get wlChipMultiIncome => 'பல வருமான ஆதாரங்கள்';

  @override
  String get wlChipStrongYogas => 'செல்வ யோகங்கள்';

  @override
  String get wlChipLowDebt => 'குறைந்த கடன்';

  @override
  String get wlChipInheritance => 'வாரிசுரிமை வாய்ப்பு';

  @override
  String get wlChipInvestor => 'புத்திசாலி முதலீட்டாளர்';

  @override
  String get wlWealthClass => 'செல்வ வகுப்பு';

  @override
  String get wlWealthType => 'முதன்மை செல்வ வகை';

  @override
  String get wlPrimarySource => 'முதன்மை வருமானம்';

  @override
  String get wlPeakAge => 'உச்ச செல்வ வயது';

  @override
  String get wlBoosters => 'உங்கள் செல்வத்தை அதிகரிப்பது என்ன';

  @override
  String get wlBoostersSub => 'சக்திவாய்ந்த பண சேர்க்கைகள்';

  @override
  String get wlWealthImpact => 'மேம்பாடு';

  @override
  String get wlDrains => 'செல்வ இழப்புகள்';

  @override
  String get wlIncomeSources => 'வருமான ஆதாரங்கள்';

  @override
  String get wlIncomeSourcesSub => 'உங்கள் பணம் எங்கிருந்து வருகிறது';

  @override
  String get wlPrimary => 'முதன்மை';

  @override
  String get wlInvestment => 'முதலீட்டு திட்டம்';

  @override
  String get wlInvestmentSub => 'சிறந்த சொத்து கலவை';

  @override
  String get wlRiskAppetite => 'இடர் ஏற்கும் திறன்';

  @override
  String get wlInvestStyle => 'முதலீட்டு பாணி';

  @override
  String get wlDrivenBy => 'இதனால் இயக்கப்படுகிறது';

  @override
  String get wlMoneyPersonality => 'பண ஆளுமை';

  @override
  String get wlMoneyType => 'பண வகை';

  @override
  String get wlSpending => 'செலவு';

  @override
  String get wlSavingsDiscipline => 'சேமிப்பு ஒழுக்கம்';

  @override
  String get wlCharity => 'தான போக்கு';

  @override
  String get wlLuxury => 'ஆடம்பர செலவு';

  @override
  String get wlWindfalls => 'எதிர்பாராத லாபங்கள் & வாய்ப்புகள்';

  @override
  String get wlWindfallsSub => 'அதிர்ஷ்ட அடிப்படையிலான பணம்';

  @override
  String get wlInheritanceChance => 'வாரிசுரிமை';

  @override
  String get wlSuddenGains => 'திடீர் லாபங்கள்';

  @override
  String get wlLottery => 'லாட்டரி / ஊகவணிகம்';

  @override
  String get wlInsurance => 'காப்பீட்டு உரிமைகோரல்கள்';

  @override
  String get wlWindfallSource => 'சாத்தியமான எதிர்பாராத லாப ஆதாரம்';

  @override
  String get wlMoneyPlanets => 'உங்கள் பண கிரகங்கள்';

  @override
  String get wlPrimaryKaraka => 'முதன்மை பண கிரகம்';

  @override
  String get wlSecondaryKaraka => 'இரண்டாம் நிலை பண கிரகம்';

  @override
  String get wlTimeline => 'செல்வ காலவரிசை';

  @override
  String get wlPeakYears => 'உச்ச ஆண்டுகள்';

  @override
  String get wlGoodPeriod => 'செழிப்பான காலம்';

  @override
  String get wlSuddenGainWindow => 'திடீர் லாப காலம்';

  @override
  String get wlToughPeriod => 'எச்சரிக்கை காலம்';

  @override
  String get wlDebtRisks => 'கடன் & பண இடர்கள்';

  @override
  String get wlDebtChance => 'கடன் வாய்ப்பு';

  @override
  String get wlLoanBurden => 'கடன் சுமை';

  @override
  String get wlDrainSources => 'இவற்றை கவனியுங்கள்';

  @override
  String get wlStrengthen => 'எதை வலுப்படுத்த வேண்டும்';

  @override
  String get wlWeakestDriver => 'மிகவும் பலவீனமான பண காரணி';

  @override
  String get wlHowToFix => 'எப்படி வலுப்படுத்துவது';

  @override
  String get wlImprovementPlan => 'மேம்பாட்டு திட்டம்';

  @override
  String get wlReliability => 'கணிப்பு நம்பகத்தன்மை';

  @override
  String get wlLayerBirth => 'செல்வ பாவங்கள் (D1)';

  @override
  String get wlLayerHora => 'ஹோரா அட்டவணை (D2)';

  @override
  String get wlLayerNavamsa => 'நவாம்சம் (D9)';

  @override
  String get wlLayerDasha => 'தசா காலம்';

  @override
  String get wlLayerTransit => 'தற்போதைய கோச்சாரம்';

  @override
  String get wlTopicGrow => 'செல்வத்தை எப்படி வளர்ப்பது';

  @override
  String get wlTopicInvest => 'எங்கு முதலீடு செய்வது';

  @override
  String get wlTopicDebt => 'கடனை நிர்வகித்தல்';

  @override
  String get wlTopicProperty => 'சொத்து வாங்குதல்';

  @override
  String get wlTopicRetire => 'ஓய்வூதிய திட்டமிடல்';

  @override
  String get wlTopicPassive => 'செயலற்ற வருமானம்';

  @override
  String get wlTopicWindfall => 'திடீர் லாபங்கள்';

  @override
  String get wlTopicTiming => 'சிறந்த பண நேரம்';

  @override
  String get bzSubtitle => 'AI-இயக்கும் வேத வணிக அறிக்கை';

  @override
  String get bzTitle => 'வணிகம் & ஸ்டார்ட்அப்';

  @override
  String get bzBusinessPotential => 'வணிக திறன்';

  @override
  String get bzEntrepreneurship => 'தொழில் முனைவோர்';

  @override
  String get bzVenture => 'தொழில்முனைவு வெற்றி';

  @override
  String get bzWealth => 'வணிகத்தின் மூலம் செல்வம்';

  @override
  String get bzRiskAppetite => 'ஆபத்து ஏற்கும் திறன்';

  @override
  String get bzLongevity => 'நீடித்திருக்கும் தன்மை';

  @override
  String get bzChipWealthMagnet => 'செல்வத்தை ஈர்க்கும் திறன்';

  @override
  String get bzChipMoneyYoga => 'பண யோகம்';

  @override
  String get bzChipLeadership => 'தலைமைத்துவம்';

  @override
  String get bzChipPartnerFit => 'சிறந்த கூட்டாளர் பொருத்தம்';

  @override
  String get bzChipGains => 'வலுவான லாபம்';

  @override
  String get bzChipInvestor => 'முதலீட்டாளர் ஈர்ப்பு';

  @override
  String get bzChipFounder => 'நிறுவனர் மனநிலை';

  @override
  String get bzWhatsWorking => 'உங்களுக்கு சாதகமாக இருப்பது என்ன';

  @override
  String get bzWhatsWorkingSub => 'உங்கள் வணிக பரிசுகள்';

  @override
  String get bzClassicYogas => 'பாரம்பரிய செல்வ யோகங்கள்';

  @override
  String get bzFounderType => 'உங்கள் நிறுவனர் வகை';

  @override
  String get bzSoulBusiness => 'ஆன்மா & வணிக நோக்கம்';

  @override
  String get bzSoulPlanet => 'உங்கள் ஆன்மா கிரகம்';

  @override
  String get bzBusinessPlanet => 'உங்கள் வணிக மனம்';

  @override
  String get bzDirectionStrength => 'திசை தெளிவு';

  @override
  String get bzAlignStrong =>
      'உங்கள் ஆன்ம நோக்கமும் வணிக திசையும் வலுவாக இணைந்துள்ளன — ஒரு தொழிலை உருவாக்குவது இயல்பாகவும் திருப்தியாகவும் இருக்கும்.';

  @override
  String get bzAlignModerate =>
      'உங்கள் ஆன்ம நோக்கமும் வணிக திசையும் மிதமாக இணைந்துள்ளன — உங்கள் ஆழமான மதிப்புகளை பிரதிபலிக்கும்போது தொழில் சிறப்பாக செயல்படும்.';

  @override
  String get bzAlignLow =>
      'உங்கள் ஆன்ம நோக்கத்திற்கும் வணிக திசைக்கும் நனவான இணைப்பு தேவை — உங்கள் உண்மையான தன்மையுடன் பொருந்தும் தொழிலை தேர்ந்தெடுங்கள்.';

  @override
  String get bzTechAtmakaraka => 'ஆன்மா கிரகம் (ஆத்மகாரகன்)';

  @override
  String get bzTechAmatyakaraka => 'வணிக கிரகம் (அமாத்யகாரகன்)';

  @override
  String get bzTechDarakaraka => 'கூட்டாளர் கிரகம் (தாரகாரகன்)';

  @override
  String get bzFoundation => 'வணிக அடித்தளம்';

  @override
  String get bzCareerHouse => 'தொழில் பாவம்';

  @override
  String get bzGainsHouse => 'லாப பாவம்';

  @override
  String get bzLord => 'அதிபதி';

  @override
  String get bzGainsPotential => 'லாப திறன்';

  @override
  String get bzNetwork => 'நெட்வொர்க் சக்தி';

  @override
  String get bzRecovery => 'மீட்பு சக்தி';

  @override
  String get bzVerification => 'குறுக்கு-அட்டவணை சரிபார்ப்பு';

  @override
  String get bzD10 => 'தொழில் அட்டவணை (D10)';

  @override
  String get bzD11 => 'லாப அட்டவணை (D11)';

  @override
  String get bzD9 => 'நோக்க அட்டவணை (D9)';

  @override
  String get bzD60 => 'கர்ம அட்டவணை (D60)';

  @override
  String get bzFounderSkills => 'நிறுவனர் திறன்கள்';

  @override
  String get bzSkillStrategy => 'மூலோபாய சிந்தனை';

  @override
  String get bzSkillExecution => 'செயல்படுத்துதல்';

  @override
  String get bzSkillPeople => 'மனித மேலாண்மை';

  @override
  String get bzSkillSales => 'விற்பனை & வற்புறுத்தல்';

  @override
  String get bzSkillFinance => 'நிதி புரிதல்';

  @override
  String get bzSkillOps => 'செயல்பாட்டு ஒழுக்கம்';

  @override
  String get bzTopSkill => 'முதன்மை திறன்';

  @override
  String get bzDomains => 'சிறந்த வணிக துறைகள்';

  @override
  String get bzDomainsSub => 'இயல்பான பொருத்தத்தின் அடிப்படையில் தரவரிசை';

  @override
  String get bzFit => 'பொருத்தம்';

  @override
  String get bzBusinessStyleHdr => 'வணிக பாணி';

  @override
  String get bzStyleService => 'பொருள் vs சேவை';

  @override
  String get bzStyleMarket => 'சந்தை கவனம்';

  @override
  String get bzStyleTech => 'தொழில்நுட்ப அணுகுமுறை';

  @override
  String get bzStyleLeadership => 'தலைமைத்துவ பாணி';

  @override
  String get bzStylePartnership => 'தனியாக அல்லது கூட்டாண்மையில்';

  @override
  String get bzWhereBuild => 'எட்டும் தூரம்';

  @override
  String get bzExpansion => 'விரிவாக்கம்';

  @override
  String get bzSetup => 'அமைப்பு';

  @override
  String get bzPartnership => 'கூட்டாண்மை & குழு';

  @override
  String get bzIdealCofounder => 'சிறந்த இணை-நிறுவனர்';

  @override
  String get bzPartnerViability => 'கூட்டாண்மை பொருத்தம்';

  @override
  String get bzTeamBuilding => 'குழு உருவாக்கம்';

  @override
  String get bzCofounderFit => 'இணை-நிறுவனர் பொருத்தம்';

  @override
  String get bzAdvisorNetwork => 'ஆலோசகர் நெட்வொர்க்';

  @override
  String get bzFunding => 'நிதி மற்றும் பணம்';

  @override
  String get bzRecommendedPath => 'பரிந்துரைக்கப்பட்ட நிதி பாதை';

  @override
  String get bzInvestorAttract => 'முதலீட்டாளர் ஈர்ப்பு';

  @override
  String get bzFamilyBacking => 'குடும்ப ஆதரவு';

  @override
  String get bzHybridViability => 'வேலை + வணிக கலவை';

  @override
  String get bzFallback => 'காப்பாக வேலை';

  @override
  String get bzDebtStyle => 'கடன் பாணி';

  @override
  String get bzTimeline => 'வணிக காலவரிசை';

  @override
  String get bzCurrentPhase => 'இப்போது';

  @override
  String get bzLaunchWindow => 'தொடங்கும் காலம்';

  @override
  String get bzScaleWindow => 'வளர்ச்சி காலம்';

  @override
  String get bzPeakAge => 'உச்ச ஆண்டுகள்';

  @override
  String get bzChallenges => 'கவனிக்க வேண்டிய சவால்கள்';

  @override
  String get bzRiskFinancial => 'நிதி இழப்பு';

  @override
  String get bzRiskBurnout => 'மனச் சோர்வு';

  @override
  String get bzRiskTeam => 'குழு மோதல்';

  @override
  String get bzRiskLegal => 'சட்ட / ஒழுங்குமுறை';

  @override
  String get bzFinancialExp =>
      'அதிக முதலீடு அல்லது மோசமான பண ஓட்ட நேரத்தால் தொழிலில் பணம் இழக்கும் ஆபத்து.';

  @override
  String get bzFinancialFix =>
      'பணக் கையிருப்பை வைத்திருங்கள், சிறிய அளவில் தொடங்குங்கள், செலவை அதிகரிக்கும் முன் தேவையை சரிபார்க்கவும்.';

  @override
  String get bzBurnoutExp =>
      'நீண்ட காலமாக அதிகமாக உழைப்பது உங்கள் ஆற்றலையும் கவனத்தையும் குறைக்கலாம்.';

  @override
  String get bzBurnoutFix =>
      'ஓய்வுக்கு முன்னுரிமை கொடுங்கள், சீக்கிரமே பொறுப்புகளை ஒப்படைக்கவும், ஆதரவான காலங்களைச் சுற்றி பெரிய முயற்சிகளை திட்டமிடுங்கள்.';

  @override
  String get bzTeamExp =>
      'இணை-நிறுவனர்கள் அல்லது பணியாளர்களுடன் கருத்து வேறுபாடு வணிகத்தை மெதுவாக்கலாம்.';

  @override
  String get bzTeamFix =>
      'பாத்திரங்களையும் எதிர்பார்ப்புகளையும் எழுத்து வடிவில் தெளிவாக்குங்கள், அடிக்கடி தொடர்பு கொள்ளுங்கள்.';

  @override
  String get bzLegalExp =>
      'இணக்கம், ஒப்பந்தங்கள் அல்லது ஒழுங்குமுறை பிரச்சினைகள் தடைகளை உருவாக்கலாம்.';

  @override
  String get bzLegalFix =>
      'ஒப்பந்தங்களை ஆய்வு செய்யுங்கள், ஆவணங்களை தெளிவாக வைத்திருங்கள், தொடக்கத்திலேயே நிபுணர்களை அணுகுங்கள்.';

  @override
  String get bzImprovementPlan => 'மேம்பாட்டு திட்டம்';

  @override
  String get bzBestDirection => 'சிறந்த திசை';

  @override
  String get bzStrategy => 'கட்டமைப்பு மூலோபாயம்';

  @override
  String get bzTopFields => 'முதன்மை துறைகள்';

  @override
  String get bzEmploymentPath => 'வேலை vs வணிகம்';

  @override
  String get bzRoadmap => 'வளர்ச்சி வரைபடம்';

  @override
  String get bzRoadmapSub => 'உங்கள் தொழில் திட்டம்';

  @override
  String get bzReliability => 'கணிப்பு நம்பகத்தன்மை';

  @override
  String get bzLayerBirth => 'பிறப்பு அட்டவணை (D1)';

  @override
  String get bzLayerNavamsa => 'நவாம்சம் (D9)';

  @override
  String get bzLayerDashamsa => 'தொழில் (D10)';

  @override
  String get bzLayerLabhamsa => 'லாபம் (D11)';

  @override
  String get bzLayerShashtiamsa => 'கர்மம் (D60)';

  @override
  String get bzTopicStart => 'நான் இப்போது தொடங்க வேண்டுமா?';

  @override
  String get bzTopicIdea => 'சிறந்த வணிக யோசனை';

  @override
  String get bzTopicPartner => 'இணை-நிறுவனரைக் கண்டறிதல்';

  @override
  String get bzTopicFunding => 'இதற்கு நிதி பெறுவது எப்படி';

  @override
  String get bzTopicScale => 'எப்போது விரிவாக்குவது';

  @override
  String get bzTopicRisk => 'ஆபத்துகளை நிர்வகித்தல்';

  @override
  String get bzTopicJob => 'வேலை vs வணிகம்';

  @override
  String get bzTopicTiming => 'சிறந்த நேரம்';

  @override
  String get crTitle => 'தொழில் & வேலை பகுப்பாய்வு';

  @override
  String get crSubtitle => 'AI-இயக்கப்படும் வேத தொழில் அறிக்கை';

  @override
  String get crCrumbHome => 'முகப்பு';

  @override
  String get crCrumbReports => 'அறிக்கைகள்';

  @override
  String get crCareerPotential => 'தொழில் திறன்';

  @override
  String get crStatusStrong => 'வலுவான திறன்';

  @override
  String get crStatusGood => 'நல்ல திறன்';

  @override
  String get crStatusModerate => 'மிதமான திறன்';

  @override
  String get crStatusDeveloping => 'வளர்ந்து வரும் திறன்';

  @override
  String get crStatusChallenging => 'சவாலான கட்டம்';

  @override
  String get crOverallCareer => 'மொத்த தொழில்';

  @override
  String get crStability => 'தொழில் நிலைத்தன்மை';

  @override
  String get crGrowth => 'வளர்ச்சி திறன்';

  @override
  String get crRecognition => 'அங்கீகாரம்';

  @override
  String get crSatisfaction => 'திருப்தி';

  @override
  String get crChipLeadership => 'தலைமைத்துவம்';

  @override
  String get crChipCreativity => 'படைப்பாற்றல்';

  @override
  String get crChipBusiness => 'வணிகம்';

  @override
  String get crChipStableIncome => 'நிலையான வருமானம்';

  @override
  String get crChipLearning => 'கற்றல்';

  @override
  String get crChipGrowth => 'நீண்ட கால வளர்ச்சி';

  @override
  String get crChipTechnical => 'தொழில்நுட்ப திறமை';

  @override
  String get crChipRecognition => 'அங்கீகாரம்';

  @override
  String get crTopInsights => 'முக்கிய நுண்ணறிவுகள்';

  @override
  String get crWhatDefines => 'உங்கள் தொழிலை எது வரையறுக்கிறது?';

  @override
  String get crSoulCareer => 'ஆன்மா & தொழில் நோக்கம்';

  @override
  String get crSoulPlanet => 'ஆன்ம நோக்கம் கிரகம்';

  @override
  String get crCareerPlanet => 'தொழில் கிரகம்';

  @override
  String get crMeaning => 'பொருள்';

  @override
  String get crAlignment => 'ஆன்மா ↔ தொழில் இணக்கம்';

  @override
  String get crAlignStrong =>
      'உங்கள் இயல்பான ஆர்வங்களும் தொழில் பாதையும் வலுவாக இணைந்துள்ளன.';

  @override
  String get crAlignModerate =>
      'உங்கள் இயல்பான ஆர்வங்களும் தொழில் பாதையும் மிதமாக இணைந்துள்ளன.';

  @override
  String get crAlignLow =>
      'உங்கள் இயல்பான ஆர்வங்களும் தொழில் பாதையும் நனவுடன் இணைக்கப்பட வேண்டும்.';

  @override
  String get crTechAtmakaraka => 'ஆத்மகாரகன் (ஆன்மா குறிகாட்டி)';

  @override
  String get crTechAmatyakaraka => 'அமாத்யகாரகன் (தொழில் குறிகாட்டி)';

  @override
  String get crDegrees => 'டிகிரிகள்';

  @override
  String get crDignity => 'கண்ணியம்';

  @override
  String get crFoundation => 'தொழில் அடித்தளம்';

  @override
  String get crCareerSign => 'தொழில் ராசி';

  @override
  String get crCareerLord => 'தொழில் அதிபதி';

  @override
  String get crLordPosition => 'அதிபதியின் நிலை';

  @override
  String get crCareerStrength => 'தொழில் வலிமை';

  @override
  String get crProfStyle => 'தொழில்முறை பாணி';

  @override
  String get crBestFields => 'சிறந்த துறைகள்';

  @override
  String get crTechnicalDetails => 'தொழில்நுட்ப விவரங்கள்';

  @override
  String get crHouseLabel => 'பாவம்';

  @override
  String get crVerification => 'பல்வேறு ஜாதகங்களில் தொழில் சரிபார்ப்பு';

  @override
  String get crD10Career => 'D10 · தொழில்';

  @override
  String get crD9Purpose => 'D9 · நோக்கம்';

  @override
  String get crD60Karma => 'D60 · கர்மா';

  @override
  String get crStatusNeedsImprovement => 'மேம்பாடு தேவை';

  @override
  String get crStatusWellAligned => 'நன்கு இணைக்கப்பட்டது';

  @override
  String get crStatusStrongSupport => 'வலுவான ஆதரவு';

  @override
  String get crStatusModerateSupport => 'மிதமான ஆதரவு';

  @override
  String get crChartDetails => 'தொழில்நுட்ப ஜாதக விவரங்கள்';

  @override
  String get crPersonality => 'உங்கள் தொழில் ஆளுமை';

  @override
  String get crGrowthAreas => 'வளர்ச்சி பகுதிகள்';

  @override
  String get crBestRoles => 'சிறந்த பங்குகள்';

  @override
  String get crBestIndustries => 'சிறந்த தொழில்துறைகள்';

  @override
  String get crEnvironment => 'தொழில் சூழல்';

  @override
  String get crWorkStyle => 'சிறந்த பணி பாணி';

  @override
  String get crEmployment => 'வேலைவாய்ப்பு';

  @override
  String get crBusiness => 'வணிகம்';

  @override
  String get crFreelance => 'ஃப்ரீலான்ஸ் / ஆலோசனை';

  @override
  String get crPortfolio => 'கலப்பு போர்ட்ஃபோலியோ';

  @override
  String get crLeadership => 'தலைமைத்துவம்';

  @override
  String get crFit => 'பொருத்தம்';

  @override
  String get crBestFit => 'சிறந்த பொருத்தம்';

  @override
  String get crTimeline => 'தொழில் காலவரிசை';

  @override
  String get crPastPeak => 'கடந்த உச்சம்';

  @override
  String get crPresentPhase => 'தற்போதைய கட்டம்';

  @override
  String get crUpcoming => 'வரவிருக்கும் வாய்ப்பு';

  @override
  String get crFutureExpansion => 'எதிர்கால விரிவாக்கம்';

  @override
  String get crRiskPeriod => 'ஆபத்து காலம்';

  @override
  String get crViewDasha => 'கிரக தசை (தொழில்நுட்பம்)';

  @override
  String get crChallenges => 'கவனிக்க வேண்டிய சவால்கள்';

  @override
  String get crRiskBurnout => 'பர்ன்அவுட்';

  @override
  String get crRiskRecognition => 'அங்கீகாரத் தாமதம்';

  @override
  String get crRiskConflict => 'பணியிட முரண்பாடு';

  @override
  String get crRiskFinancial => 'நிதி நிலையின்மை';

  @override
  String get crRiskOverqual => 'திறனை முழுமையாக பயன்படுத்தாமை';

  @override
  String get crPrevention => 'தடுப்பு';

  @override
  String get crBurnoutExp =>
      'நீண்ட, கடினமான கட்டங்கள் காலப்போக்கில் உங்கள் சக்தியை குறைக்கலாம்.';

  @override
  String get crBurnoutFix =>
      'ஓய்வை பாதுகாக்கவும், எல்லைகளை நிர்ணயிக்கவும், பெரிய முயற்சிகளை வேகத்தில் செய்யவும்.';

  @override
  String get crRecognitionExp =>
      'வெகுமதிகளும் அங்கீகாரமும் உங்கள் முயற்சியை விட மெதுவாக வரலாம்.';

  @override
  String get crRecognitionFix =>
      'உங்கள் வெற்றிகளை பதிவு செய்யவும், உங்கள் பங்களிப்புகளை மேலதிகாரிகளுக்கு தெளிவாகக் காட்டவும்.';

  @override
  String get crConflictExp =>
      'சக ஊழியர்கள் அல்லது அதிகாரத்துடன் சில நேரங்களில் மோதல் ஏற்படலாம்.';

  @override
  String get crConflictFix =>
      'அமைதியாக தொடர்பு கொள்ளவும், உங்கள் போராட்டங்களை புத்திசாலித்தனமாக தேர்ந்தெடுக்கவும்.';

  @override
  String get crFinancialExp => 'சில கட்டங்களில் வருமானம் சீரற்றதாக தோன்றலாம்.';

  @override
  String get crFinancialFix =>
      'ஒரு இருப்பை வைத்திருங்கள், நிதி ரீதியாக அதிக உறுதிமொழி கொடுப்பதை தவிர்க்கவும்.';

  @override
  String get crOverqualExp =>
      'சில நேரங்களில் உங்கள் திறன் முழுமையாக பயன்படுத்தப்படவில்லை என்று உணரலாம்.';

  @override
  String get crOverqualFix =>
      'சவாலான பங்குகளை தேடுங்கள், ஈடுபாட்டை தக்கவைக்க தொடர்ந்து கற்றுக்கொள்ளுங்கள்.';

  @override
  String get crImprovementPlan => 'தொழில் மேம்பாட்டு திட்டம்';

  @override
  String get crCatPlanetary => 'கிரக & ஆன்மீக';

  @override
  String get crCatPractical => 'நடைமுறை நடவடிக்கைகள்';

  @override
  String get crTraditionalExplain => 'பாரம்பரிய ஜோதிட விளக்கம்';

  @override
  String get crActionPlan => '30-நாள் தொழில் செயல் திட்டம்';

  @override
  String get crWeek1 => 'வாரம் 1 · சுயவிவரம் மேம்படுத்துதல்';

  @override
  String get crWeek2 => 'வாரம் 2 · திறன் மேம்பாடு';

  @override
  String get crWeek3 => 'வாரம் 3 · நெட்வொர்க்கிங்';

  @override
  String get crWeek4 => 'வாரம் 4 · தொழில் தெரிவுநிலை';

  @override
  String get crWeek1Tip =>
      'உங்கள் வலிமையான தொழில் கருப்பொருளை மையமாகக் கொண்டு உங்கள் ரெஸ்யூம் மற்றும் லிங்க்டுஇன் ஐ புதுப்பிக்கவும்.';

  @override
  String get crWeek2Tip =>
      'உங்கள் சிறந்த துறையில் ஒரு உயர்-மதிப்பு திறனைத் தேர்ந்தெடுத்து தினமும் பயிற்சி செய்யுங்கள்.';

  @override
  String get crWeek3Tip =>
      'வழிகாட்டிகளுடன் மீண்டும் தொடர்பு கொள்ளுங்கள், தொழில்துறையின் இரண்டு புதிய தொடர்புகளை அணுகுங்கள்.';

  @override
  String get crWeek4Tip =>
      'உங்கள் வேலையை பொதுவில் பகிரவும், தெரியும்படியான ஒரு திட்டத்திற்கு தன்னார்வலராக முன்வரவும்.';

  @override
  String get crPriority => 'முன்னுரிமை';

  @override
  String get crTimeRequired => 'நேரம்';

  @override
  String get crExpectedBenefit => 'பலன்';

  @override
  String get crPriorityHigh => 'அதிகம்';

  @override
  String get crPriorityMedium => 'நடுத்தரம்';

  @override
  String get crRoadmap => 'AI தொழில் திட்டவரைபடம்';

  @override
  String get crNext12 => 'அடுத்த 12 மாதங்கள்';

  @override
  String get crBestFocus => 'சிறந்த கவனம்';

  @override
  String get crSkillsLearn => 'கற்க வேண்டிய திறன்கள்';

  @override
  String get crIndustriesTarget => 'இலக்கு தொழில்துறைகள்';

  @override
  String get crExpectedOutcome => 'எதிர்பார்க்கப்படும் விளைவு';

  @override
  String get crReliability => 'கணிப்பு நம்பகத்தன்மை';

  @override
  String get crReliabilityHigh => 'அதிக நம்பகத்தன்மை';

  @override
  String get crReliabilityGood => 'நல்ல நம்பகத்தன்மை';

  @override
  String get crReliabilityModerate => 'மிதமான நம்பகத்தன்மை';

  @override
  String get crReliabilityExplain =>
      'இந்த அறிக்கை உங்கள் ஜாதகம், பிரிவு ஜாதகங்கள் மற்றும் ஜைமினி குறிகாட்டிகளை இணைக்கிறது. இந்த ஜாதக அடுக்குகள் எவ்வளவு வலுவாக ஒத்துப்போகின்றன என்பதை மதிப்பெண் காட்டுகிறது.';

  @override
  String get crChartLayers => 'ஜாதக அடுக்குகள் & எடைகள்';

  @override
  String get crBirthChart => 'ஜாதகம் (D1)';

  @override
  String get crNavamsa => 'நவாம்சம் (D9)';

  @override
  String get crDashamsa => 'தசாம்சம் (D10)';

  @override
  String get crShashtiamsa => 'சஷ்டியாம்சம் (D60)';

  @override
  String get crDiscussAi => 'AI உடன் விவாதிக்கவும்';

  @override
  String get crAskAbout => 'இதைப் பற்றி கேளுங்கள்';

  @override
  String get crTopicChange => 'தொழில் மாற்றம்';

  @override
  String get crTopicGovt => 'அரசு வேலை';

  @override
  String get crTopicBusiness => 'வணிகம்';

  @override
  String get crTopicPromotion => 'பதவி உயர்வு';

  @override
  String get crTopicMarriage => 'திருமணம் vs தொழில்';

  @override
  String get crTopicAbroad => 'வெளிநாடு';

  @override
  String get crTopicIncome => 'வருமானம்';

  @override
  String get crTopicPurpose => 'நோக்கம்';

  @override
  String get crTopicResume => 'ரெஸ்யூம்';

  @override
  String get crTopicCopied =>
      'கேள்வி நகலெடுக்கப்பட்டது — அதை உங்கள் AI அரட்டையில் ஒட்டவும்.';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return '$soul உங்கள் உள்ளார்ந்த அழைப்பை வழிநடத்துகிறது, $career உங்கள் வெளிப்புற தொழிலை வடிவமைக்கிறது.';
  }

  @override
  String get rzTodayOutlook => 'இன்றைய ராசி பலன் கண்ணோட்டம்';

  @override
  String get rzPlanetaryEnergy => 'இன்றைய கிரக ஆற்றல்';

  @override
  String get rzBestSign => 'சிறந்த ராசி';

  @override
  String get rzChallengingSign => 'மிகவும் சவாலான ராசி';

  @override
  String get rzDominantPlanet => 'மேலோங்கும் கிரகம்';

  @override
  String get rzOverallMood => 'மொத்த மனநிலை';

  @override
  String get rzMoodBright => 'பிரகாசமான & சுறுசுறுப்பான';

  @override
  String get rzMoodCalm => 'அமைதியான & நிலையான';

  @override
  String get rzMoodMixed => 'கலவை ஆற்றல்';

  @override
  String get rzMoodTense => 'பதற்றமான & எச்சரிக்கையான';

  @override
  String get rzTodayEnergy => 'இன்றைய ஆற்றல்';

  @override
  String get rzCaution => 'எச்சரிக்கை';

  @override
  String get rzWeak => 'பலவீனம்';

  @override
  String get rzAllSigns => 'அனைத்து ராசிகள்';

  @override
  String get rzAiSummary => 'AI சுருக்கம்';

  @override
  String get rzPlanetaryInfluence => 'இன்றைய கிரக தாக்கம்';

  @override
  String get rzStrongInfluences => 'வலுவான தாக்கங்கள்';

  @override
  String get rzShowTechnical => 'தொழில்நுட்ப விவரங்களைக் காட்டு';

  @override
  String get rzOpportunities => 'இன்றைய வாய்ப்புகள்';

  @override
  String get rzAvoidTitle => 'இன்று தவிர்க்க வேண்டியவை';

  @override
  String get rzTechnicalReason => 'தொழில்நுட்ப காரணம்';

  @override
  String get rzAvoidDecisions => 'முக்கியமான முடிவுகளில் அவசரம்';

  @override
  String get rzAvoidArguments => 'வெப்பமான வாக்குவாதங்கள்';

  @override
  String get rzAvoidInvestments => 'பெரிய முதலீடுகள்';

  @override
  String get rzAvoidOverthink => 'சிறிய விஷயங்களில் அதிக யோசனை';

  @override
  String get rzAvoidOverspend => 'தேவையற்ற செலவு';

  @override
  String get rzAvoidStress => 'மன அழுத்தமும் அதிக வேலையும்';

  @override
  String get rzPlanetaryChart => 'இன்றைய கிரக அட்டவணை';

  @override
  String get rzWhatChartMeans => 'இந்த அட்டவணையின் பொருள்';

  @override
  String get rzChartExplain =>
      'இன்று வானில் ஒவ்வொரு கிரகமும் எங்கு அமைந்துள்ளது என்பதை இந்த வைர வடிவம் உங்கள் ராசிக்கு ஏற்ப காட்டுகிறது. ஆதரவான பாவங்களில் உள்ள கிரகங்கள் நாளை மேம்படுத்தும்; கடினமான பாவங்களில் உள்ளவை கவனம் தேவைப்படுத்தும்.';

  @override
  String get rzDoNetworking => 'நெட்வொர்க்கிங் & தொடர்பு';

  @override
  String get rzDoLearning => 'புதிதாக ஏதாவது கற்றல்';

  @override
  String get rzDoMeditation => 'தியானம் & அமைதி';

  @override
  String get rzDoFamily => 'குடும்பத்துடன் நேரம்';

  @override
  String get rzDoCreative => 'படைப்பாற்றல் வேலை';

  @override
  String get rzDoRest => 'ஓய்வு & சுய பராமரிப்பு';

  @override
  String get rzAiRecommendations => 'இன்றைய AI பரிந்துரைகள்';

  @override
  String get rzTechnical => 'தொழில்நுட்ப ஜோதிடம்';

  @override
  String get rzTransitScore => 'கோச்சார மதிப்பெண்';

  @override
  String get rzVedha => 'வேதம் (தடைகள்)';

  @override
  String get rzGocharDetails => 'கோச்சார விவரங்கள்';

  @override
  String get rzAdvancedOnly => 'மேம்பட்ட பயனர்களுக்கு';

  @override
  String get rzTomorrow => 'நாளையின் முன்னோட்டம்';

  @override
  String get rzTomorrowEnergy => 'நாளையின் ஆற்றல்';

  @override
  String get rzImproving => 'மேம்படுகிறது';

  @override
  String get rzWeaker => 'சற்று பலவீனம்';

  @override
  String get rzSteady => 'நிலையானது';

  @override
  String get rzTomorrowUpLine =>
      'நாளை ஆற்றல் அதிகரிக்கும் என எதிர்பார்க்கப்படுகிறது — முக்கியமான பணிகளை முன்கூட்டியே திட்டமிடுங்கள்.';

  @override
  String get rzTomorrowDownLine =>
      'நாளை ஆற்றல் சற்று குறையலாம் — நாளை இலகுவாகவும் நிலையாகவும் வைத்திருங்கள்.';

  @override
  String get rzTomorrowFlatLine =>
      'நாளை ஆற்றல் நிலையாக இருக்கும் — அமைதியான, சமநிலையான நாள் காத்திருக்கிறது.';

  @override
  String get rzWeeklyTrend => 'வாராந்திர போக்கு';

  @override
  String get rzMonthlyTrend => 'மாதாந்திர போக்கு';

  @override
  String get rzBestDayWeek => 'சிறந்த நாள்';

  @override
  String get rzHardestDay => 'மிகவும் கடினமான நாள்';

  @override
  String get rzLuckyToday => 'இன்று அதிர்ஷ்டம்';

  @override
  String get rzKarakaSun => 'நம்பிக்கை & உயிர்ச்சக்தி';

  @override
  String get rzKarakaMoon => 'உணர்வுகள் & மன அமைதி';

  @override
  String get rzKarakaMars => 'ஆற்றல் & உந்துதல்';

  @override
  String get rzKarakaMercury => 'தொடர்பு & கற்றல்';

  @override
  String get rzKarakaJupiter => 'ஞானம் & வளர்ச்சி';

  @override
  String get rzKarakaVenus => 'உறவுகள் & வசதி';

  @override
  String get rzKarakaSaturn => 'ஒழுக்கம் & பொறுமை';

  @override
  String get rzKarakaRahu => 'லட்சியம் & மாற்றம்';

  @override
  String get rzKarakaKetu => 'ஆன்மீகம் & விட்டுவிடுதல்';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '$dom நாளின் தன்மையை நிர்ணயிக்கிறது, அதே நேரம் $chal பொறுமையும் கவனமும் கோருகிறது.';
  }

  @override
  String rzInsightGood(Object karaka) {
    return '$karakaக்கு நல்ல நாள்.';
  }

  @override
  String rzInsightHard(Object karaka) {
    return 'இன்று $karaka விஷயத்தில் மெதுவாக செல்லுங்கள்.';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return 'இன்று $karaka நன்கு ஆதரிக்கப்படுகிறது.';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return 'இன்று $karaka தாமதங்களை சந்திக்கலாம்.';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return 'இன்று $strongக்கு ஆதரவளிக்கிறது, அதே நேரம் $weakக்கு பொறுமையும் கவனமும் தேவை.';
  }

  @override
  String get fdEnergyScore => 'இன்றைய எனர்ஜி மதிப்பெண்';

  @override
  String get fdStatusAverage => 'சராசரி';

  @override
  String get fdStatusMixed => 'கலவையான';

  @override
  String get fdStatusChallenging => 'சவாலான';

  @override
  String get fdTheme => 'இன்றைய தீம்';

  @override
  String get fdExplainToday => 'இன்றைய நிலையை விளக்கு';

  @override
  String get fdTodaysFocus => 'இன்றைய கவனம்';

  @override
  String get fdTopRecommendation => 'முதன்மை பரிந்துரை';

  @override
  String get fdTopCaution => 'முதன்மை எச்சரிக்கை';

  @override
  String get fdReadingTime => 'படிக்கும் நேரம்';

  @override
  String get fdSeconds30 => '30 வினாடிகள்';

  @override
  String get fdCareer => 'தொழில்';

  @override
  String get fdMoney => 'பணம்';

  @override
  String get fdLove => 'காதல்';

  @override
  String get fdHealth => 'ஆரோக்கியம்';

  @override
  String get fdTravel => 'பயணம்';

  @override
  String get fdFamily => 'குடும்பம்';

  @override
  String get fdBestToDo => 'இன்று செய்ய சிறந்த காரியங்கள்';

  @override
  String get fdAvoidToday => 'இன்று தவிர்க்க வேண்டியவை';

  @override
  String get fdConfidenceLabel => 'நம்பகத்தன்மை';

  @override
  String get fdBestTime => 'சிறந்த நேரம்';

  @override
  String get fdRecommended => 'பரிந்துரைக்கப்படுகிறது';

  @override
  String get fdReason => 'காரணம்';

  @override
  String get fdRisk => 'இடர்';

  @override
  String get fdRecommendation => 'பரிந்துரை';

  @override
  String get fdNoActions =>
      'இன்று குறிப்பாக செய்ய எதுவும் இல்லை — நிலையான, அமைதியான வழக்கத்தை பராமரியுங்கள்.';

  @override
  String get fdNoCautions =>
      'இன்று பெரிய எச்சரிக்கை எதுவும் இல்லை — வழக்கமான விழிப்புணர்வுடன் தொடருங்கள்.';

  @override
  String get fdHighlights => 'இன்றைய முக்கிய அம்சங்கள்';

  @override
  String get fdProbVeryHigh => 'மிக அதிகம்';

  @override
  String get fdProbHigh => 'அதிகம்';

  @override
  String get fdProbElevated => 'உயர்ந்தது';

  @override
  String get fdProbCaution => 'எச்சரிக்கை';

  @override
  String get fdWhatToDo => 'என்ன செய்ய வேண்டும்';

  @override
  String get fdLifeAreas => 'வாழ்க்கைத் துறைகள்';

  @override
  String get fdTapDetails => 'விவரங்களுக்கு தட்டவும்';

  @override
  String get fdArea1 => 'தன்னலமும் ஆரோக்கியமும்';

  @override
  String get fdArea2 => 'செல்வமும் குடும்பமும்';

  @override
  String get fdArea3 => 'தொடர்பு';

  @override
  String get fdArea4 => 'வீடும் வசதியும்';

  @override
  String get fdArea5 => 'படைப்பாற்றலும் காதலும்';

  @override
  String get fdArea6 => 'வேலையும் கடமைகளும்';

  @override
  String get fdArea7 => 'உறவுகள்';

  @override
  String get fdArea8 => 'மாற்றமும் ஆழமும்';

  @override
  String get fdArea9 => 'அதிர்ஷ்டமும் பயணமும்';

  @override
  String get fdArea10 => 'தொழிலும் அந்தஸ்தும்';

  @override
  String get fdArea11 => 'லாபமும் தொடர்புகளும்';

  @override
  String get fdArea12 => 'ஓய்வும் ஆன்மீகமும்';

  @override
  String get fdTodaysMeaning => 'இன்றைய பொருள்';

  @override
  String get fdGoodFor => 'இதற்கு நல்லது';

  @override
  String get fdAvoid => 'தவிர்க்கவும்';

  @override
  String get fdPlanetSupport => 'கிரக ஆதரவு';

  @override
  String get fdWhyPrediction => 'இந்த கணிப்பு ஏன்?';

  @override
  String get fdAdvancedDetails => 'மேம்பட்ட விவரங்கள்';

  @override
  String get fdAiRecommendation => 'AI பரிந்துரை';

  @override
  String get fdOverallStatus => 'ஒட்டுமொத்த நிலை';

  @override
  String get fdNoPlanetTransit =>
      'இன்று இந்தத் துறையில் முக்கிய கிரகம் எதுவும் கோச்சரம் செய்யவில்லை.';

  @override
  String get fdFinancialOutlook => 'நிதி நிலைப்பாடு';

  @override
  String get fdIncomeProbability => 'வருமான வாய்ப்பு';

  @override
  String get fdExpenseProbability => 'செலவு வாய்ப்பு';

  @override
  String get fdNetBalance => 'மொத்த நிதி இருப்பு';

  @override
  String get fdAvoidSpending => 'செலவை தவிர்க்கவும்';

  @override
  String get fdRelationshipOutlook => 'உறவு நிலைப்பாடு';

  @override
  String get fdOverallScore => 'ஒட்டுமொத்த மதிப்பெண்';

  @override
  String get fdPartner => 'துணை';

  @override
  String get fdRomance => 'காதல் உணர்வு';

  @override
  String get fdWorkplace => 'பணியிடம்';

  @override
  String get fdPublicImage => 'பொது இமேஜ்';

  @override
  String get fdBestActivity => 'சிறந்த செயல்பாடு';

  @override
  String get fdWeakArea => 'பலவீனமான பகுதி';

  @override
  String get fdBiggestOpportunity => 'மிகப்பெரிய வாய்ப்பு';

  @override
  String get fdBiggestRisk => 'மிகப்பெரிய இடர்';

  @override
  String get fdProbability => 'வாய்ப்பு';

  @override
  String get fdProtection => 'பாதுகாப்பு ஆலோசனை';

  @override
  String get fdDescription => 'விளக்கம்';

  @override
  String get fdBestTimeToday => 'இன்றைய சிறந்த நேரம்';

  @override
  String get fdAvoidDuring => 'இந்த நேரத்தில் தவிர்க்கவும்';

  @override
  String get fdPredictionConfidence => 'கணிப்பு நம்பகத்தன்மை';

  @override
  String get fdConfBasis => 'இன்றைய கணிப்பு இவற்றை இணைக்கிறது';

  @override
  String get fdConfNatal => 'ஜாதகம்';

  @override
  String get fdConfTransit => 'தற்போதைய கோச்சரம்';

  @override
  String get fdConfDasha => 'கிரக தசைகள்';

  @override
  String get fdConfStrength => 'கிரக பலம்';

  @override
  String get fdConfHouse => 'பாவ செயல்பாடு';

  @override
  String get fdAskAi => 'AI-யிடம் கேளுங்கள்';

  @override
  String get fdAskAiSub => 'இன்றைய பதிலைப் பெற ஒரு கேள்வியை தட்டவும்';

  @override
  String get fdQ1 => 'இன்று தொழில் ஏன் மந்தமாக உள்ளது?';

  @override
  String get fdQ2 => 'இன்றைய சிறந்த நேரம் எது?';

  @override
  String get fdQ3 => 'இன்று பண விஷயங்களுக்கு நல்லதா?';

  @override
  String get fdQ4 => 'இன்று பயணத்திற்கு நல்லதா?';

  @override
  String get fdQ5 => 'இன்று நான் எதை தவிர்க்க வேண்டும்?';

  @override
  String get fdMoreSuggestions => 'மேலும் பரிந்துரைகள்';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return 'இன்று $top-க்கு மிகவும் ஏற்றது. $weak மந்தமாக உணரலாம், எனவே அங்கு முக்கிய முடிவுகளை தவிர்க்கவும். நிதி ரீதியாக நாள் $fin போல் தெரிகிறது.';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return 'இன்று உங்கள் ஆற்றல் $top-ஐ சுற்றி குவிந்துள்ளது — அதில் முழு கவனம் செலுத்தி மற்ற இடங்களில் மெதுவாக செல்லுங்கள்.';
  }

  @override
  String get gochToday => 'இன்று';

  @override
  String get gochOverallScore => 'ஒட்டுமொத்த கோச்சர மதிப்பெண்';

  @override
  String get gochNeutral => 'நடுநிலை';

  @override
  String get gochChallenging => 'சவாலானது';

  @override
  String get gochTopPositive => 'முதன்மை நேர்மறை';

  @override
  String get gochTopChallenges => 'முதன்மை சவால்கள்';

  @override
  String get gochFilterAll => 'அனைத்தும்';

  @override
  String get gochFavorability => 'சாதகம்';

  @override
  String get gochAlerts => 'கோச்சர எச்சரிக்கைகள்';

  @override
  String get gochAlertCritical => 'மிக முக்கியமானது';

  @override
  String get gochAlertWarning => 'எச்சரிக்கை';

  @override
  String get gochAlertOpportunity => 'வாய்ப்பு';

  @override
  String get gochAiFocus => 'இன்றைய AI கவனம்';

  @override
  String get gochLifeScores => 'வாழ்க்கைத் துறை மதிப்பெண்கள்';

  @override
  String get gochWhy => 'ஏன்?';

  @override
  String get gochCurrentTransits => 'செயலில் உள்ள கோச்சரங்கள்';

  @override
  String get gochDailyPlan => 'உங்கள் தினசரி திட்டம்';

  @override
  String get gochMorning => 'காலை';

  @override
  String get gochAfternoon => 'மதியம்';

  @override
  String get gochEvening => 'மாலை';

  @override
  String get gochNight => 'இரவு';

  @override
  String get gochSmartReco => 'ஸ்மார்ட் பரிந்துரைகள்';

  @override
  String get gochExplain => 'இன்றைய கோச்சரத்தை விளக்குங்கள்';

  @override
  String get gochDo => 'செய்யுங்கள்';

  @override
  String get gochDont => 'தவிர்க்கவும்';

  @override
  String get gochDoWork => 'முக்கியமான வேலைகளை முடிக்கவும்';

  @override
  String get gochDoMeditate => 'தியானம் செய்து சிந்தியுங்கள்';

  @override
  String get gochDoStart => 'புதிய திட்டங்களைத் தொடங்குங்கள்';

  @override
  String get gochDoFinish => 'நிலுவையிலுள்ள வேலைகளை முடிக்கவும்';

  @override
  String get gochDontArgue => 'வாக்குவாதங்களைத் தவிர்க்கவும்';

  @override
  String get gochDontImpulsive => 'அவசர முடிவுகளைத் தவிர்க்கவும்';

  @override
  String get gochDontOverspend => 'அதிக செலவை தவிர்க்கவும்';

  @override
  String gochThemeGrowth(Object area) {
    return 'இன்று $area-இல் வளர்ச்சியின் நாள் — அதைப் பயன்படுத்திக்கொள்ளுங்கள்.';
  }

  @override
  String gochThemeChallenge(Object area) {
    return 'இன்று $area-உடன் பொறுமையாக இருங்கள் — நிலையாக முன்னேறுங்கள்.';
  }

  @override
  String gochPosLine(Object area) {
    return '$area இப்போது நன்கு ஆதரிக்கப்படுகிறது.';
  }

  @override
  String gochChalLine(Object area) {
    return 'இன்று $area-க்கு கூடுதல் கவனம் தேவை.';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return 'இன்று உங்கள் ஆற்றலை $a1-இல் செலுத்துங்கள், மேலும் $a2-உடன் மென்மையாக இருங்கள்.';
  }

  @override
  String get divBeginner => 'எளிமையானது';

  @override
  String get divSearchHint => 'தேடு: தொழில், திருமணம், கல்வி…';

  @override
  String get divSummaryTitle => 'வர்க்க குண்டலி சுருக்கம்';

  @override
  String get divTotalCharts => 'மொத்த குண்டலிகள்';

  @override
  String get divMostImportant => 'மிக முக்கியமானவை';

  @override
  String get divRecommendedForYou => 'உங்களுக்காக பரிந்துரைக்கப்பட்டவை';

  @override
  String get divCatEssential => 'அத்தியாவசிய குண்டலிகள்';

  @override
  String get divCatPersonal => 'தனிப்பட்ட வாழ்க்கை';

  @override
  String get divCatKnowledge => 'அறிவு குண்டலிகள்';

  @override
  String get divCatAdvanced => 'மேம்பட்ட குண்டலிகள்';

  @override
  String get divGoalProperty => 'சொத்து';

  @override
  String get divGoalKarma => 'கர்மா';

  @override
  String get divBadgeHighlyRec => 'மிகவும் பரிந்துரைக்கப்பட்டது';

  @override
  String get divBadgeRec => 'பரிந்துரை';

  @override
  String get divBadgeUseful => 'பயனுள்ளது';

  @override
  String get divBadgeOptional => 'விருப்பத்திற்குரியது';

  @override
  String get divBadgeAdvOnly => 'மேம்பட்டவர்களுக்கு மட்டும்';

  @override
  String get divRecommendBest => 'சிறந்த குண்டலிகளை பரிந்துரைக்கவும்';

  @override
  String get divNoMatch => 'உங்கள் தேடலுக்கு பொருந்தும் குண்டலிகள் இல்லை';

  @override
  String get divLifeAreas => 'வாழ்க்கை பகுதிகள்';

  @override
  String divAiUse(Object purpose) {
    return '$purpose பகுப்பாய்வு செய்ய இந்த குண்டலியைப் பயன்படுத்தவும்.';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return 'உங்கள் $c1 மற்றும் $c2 குண்டலிகள் மிகவும் முக்கியமானவை — அவை உள்ளடக்கும் விஷயங்களுக்கு அங்கிருந்தே தொடங்கி, தேவைப்படும்போது மற்றவற்றையும் ஆராயுங்கள்.';
  }

  @override
  String divRecReasonHouse(Object house) {
    return 'உங்கள் $house வீட்டை இன்னும் ஆழமாக பார்க்க வேண்டும் — இந்த குண்டலி அதை விரிவாகக் காட்டுகிறது.';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '$planet ஒரு முக்கியமான ஆனால் சவாலான கிரகம் — இந்த குண்டலி அதன் ஆழ்ந்த நிலையை வெளிப்படுத்துகிறது.';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return 'நீங்கள் தற்போது $planet மகாதசையில் இருக்கிறீர்கள், எனவே இந்த குண்டலி இப்போது மிகவும் பொருத்தமானது.';
  }

  @override
  String divRecSummary(Object c1) {
    return 'உங்கள் குண்டலியின்படி, $c1 உங்களுக்கு மிக முக்கியமான முன்னுரிமையாக இருக்க வேண்டும். கீழே உள்ள குண்டலிகள் உங்களுக்கான பொருத்தத்தின் அடிப்படையில் வரிசைப்படுத்தப்பட்டுள்ளன.';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return 'நீங்கள் $purpose படிக்க விரும்பும்போது இந்த குண்டலியைத் திறக்கவும்.';
  }

  @override
  String get yogaHelpful => 'உதவிகரமான';

  @override
  String get yogaInactive => 'செயலற்ற';

  @override
  String get yogaTabMoney => 'தனம்';

  @override
  String get yogaTabRare => 'அரிய';

  @override
  String get yogaSummaryTitle => 'யோக சுருக்கம்';

  @override
  String get yogaActiveYogas => 'செயலில் உள்ள யோகங்கள்';

  @override
  String get yogaTotalYogas => 'மொத்த யோகங்கள்';

  @override
  String get yogaMostPowerful => 'மிக சக்திவாய்ந்தது';

  @override
  String get yogaFortuneRating => 'ஒட்டுமொத்த அதிர்ஷ்டம்';

  @override
  String get yogaBenefits => 'நன்மைகள்';

  @override
  String get yogaSupportingPlanets => 'ஆதரவு கிரகங்கள்';

  @override
  String get yogaRanking => 'முதன்மையான 5 வலிமையான யோகங்கள்';

  @override
  String get yogaExplain => 'எனது யோகங்களை விளக்குங்கள்';

  @override
  String get yogaExplainSubtitle =>
      'உங்கள் யோகங்கள் உங்களுக்கு எப்படி உதவுகின்றன';

  @override
  String get yogaNoneActive => 'இதுவரை செயலில் உள்ள யோகங்கள் இல்லை';

  @override
  String get yogaNoneInCategory => 'இந்த பிரிவில் யோகங்கள் இல்லை';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return 'உங்கள் ஜாதகத்தில் $count செயலில் உள்ள யோகங்கள் உள்ளன — ஆதரவான கிரக சேர்க்கைகள். $planets சம்பந்தப்பட்ட சேர்க்கைகள் வளர்ச்சி மற்றும் வெற்றிக்கு குறிப்பாக உதவிகரமான தாக்கங்களை உருவாக்குகின்றன.';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '$name $areas-க்கு ஆதரவளிக்கிறது, மேலும் அதன் கிரகங்கள் தசை அல்லது கோச்சாரத்தில் செயலில் இருக்கும்போது அதன் நன்மைகள் மேலும் அதிகரிக்கின்றன.';
  }

  @override
  String get yogaAiGeneric =>
      'இந்த யோகம் உங்கள் ஜாதகத்தில் ஒரு ஆதரவான சேர்க்கையாகும், இது வாழ்க்கையின் தொடர்புடைய பகுதிகளை வலுப்படுத்துகிறது.';

  @override
  String get yogaExplainReassure =>
      'யோகங்கள் உங்கள் ஜாதகத்தின் பிரகாசமான புள்ளிகள் — உங்களுக்கு சாதகமாக செயல்படும் ஆதரவான கிரக சேர்க்கைகள். வலிமையானவை நீடித்த நன்மைகளை அளிக்கின்றன, குறிப்பாக அவற்றை உருவாக்கும் கிரகங்களின் காலகட்டங்களில்.';

  @override
  String get doshSevere => 'கடுமையானது';

  @override
  String get doshVeryMild => 'மிக லேசானது';

  @override
  String get doshLow => 'குறைவு';

  @override
  String get doshHigh => 'அதிகம்';

  @override
  String get doshCritical => 'மிக கடுமையானது';

  @override
  String get doshSummaryTitle => 'தோஷ சுருக்கம்';

  @override
  String get doshActiveDoshas => 'செயலில் உள்ள தோஷங்கள்';

  @override
  String get doshTotalChecked => 'மொத்தம் சரிபார்க்கப்பட்டது';

  @override
  String get doshOverallSeverity => 'ஒட்டுமொத்த தீவிரம்';

  @override
  String get doshNoneActive => 'செயலில் தோஷங்கள் இல்லை — தூய்மையான ஜாதகம்!';

  @override
  String get doshCategory => 'வகை';

  @override
  String get doshConfidence => 'நம்பகத்தன்மை';

  @override
  String get doshWhyFormed => 'இது ஏன் உருவானது';

  @override
  String get doshAffectedAreas => 'பாதிக்கப்பட்ட பகுதிகள்';

  @override
  String get doshTimeline => 'காலவரிசை';

  @override
  String get doshDefinition => 'வரையறை';

  @override
  String get doshFormationRule => 'உருவாக்க விதி';

  @override
  String get doshSupportingPlanets => 'தொடர்புடைய கிரகம்';

  @override
  String get doshCancellation => 'நிவாரண யோகங்கள்';

  @override
  String get doshNoCancellation => 'எதுவும் இல்லை';

  @override
  String get doshAreaChildren => 'சந்ததி';

  @override
  String get doshAreaMind => 'மனம்';

  @override
  String get remMantra => 'மந்திரம்';

  @override
  String get remGemstone => 'ரத்தினம்';

  @override
  String get remDonation => 'தானம்';

  @override
  String get remTemple => 'கோவில்';

  @override
  String get remFasting => 'விரதம்';

  @override
  String get remLifestyle => 'வாழ்க்கை முறை';

  @override
  String get remLifestyleGeneric =>
      'இந்த கிரகத்துடன் தொடர்புடைய நன்றியுணர்வு, ஒழுக்கம் மற்றும் தானம் ஆகியவற்றை பயிற்சி செய்யுங்கள், மேலும் நல்ல நடத்தையை பேணுங்கள்.';

  @override
  String get doshExplain => 'எனது தோஷங்களை விளக்குங்கள்';

  @override
  String get doshExplainSubtitle =>
      'உங்கள் தோஷங்கள் மீதான ஒரு அமைதியான, நடைமுறை பார்வை';

  @override
  String get doshExplainReassure =>
      'தோஷங்கள் பொதுவானவை — கிட்டத்தட்ட ஒவ்வொரு ஜாதகத்திலும் சில உள்ளன. இவை போக்குகளை விவரிக்கின்றன, நிலையான விதியை அல்ல. விழிப்புணர்வு, நல்ல நடத்தை மற்றும் எளிய பரிகாரங்கள் இவற்றின் நடைமுறை தாக்கத்தை குறைக்கின்றன, எனவே கவலைப்பட வேண்டியதில்லை.';

  @override
  String get doshAiGeneric =>
      'இந்த தோஷம் உங்கள் ஜாதகத்தில் ஒரு போக்கை விவரிக்கிறது. இதன் நடைமுறை தாக்கம் பொதுவாக லேசானது, மேலும் விழிப்புணர்வு மற்றும் எளிய பரிகாரங்கள் மூலம் சமநிலைப்படுத்தலாம்.';

  @override
  String doshHeroSummary(Object active, Object total) {
    return 'உங்கள் ஜாதகத்தில் சரிபார்க்கப்பட்ட $total-இல் $active தோஷங்கள் செயலில் உள்ளன. பெரும்பாலானவை லேசானவை, சிலவற்றுக்கு மட்டும் கவனம் தேவை. புரிதல் மற்றும் எளிய பரிகாரங்கள் மூலம் இவற்றின் நடைமுறை தாக்கத்தை குறைக்கலாம்.';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return 'இந்த தோஷம் முதன்மையாக $areas ஐ பாதிக்கிறது. $planet தசைக் காலங்களில் இதன் தாக்கம் அதிகமாக உணரப்படலாம், மேலும் பரிகாரங்கள் அதை சமநிலைப்படுத்த உதவும்.';
  }

  @override
  String doshTimelineLine(Object planet) {
    return 'இதன் தாக்கம் $planet-இன் மகாதசை மற்றும் அந்தரதசை காலங்களில், மற்றும் கோச்சாரத்தில் $planet செயலில் இருக்கும்போது அதிகம் உணரப்படுகிறது.';
  }

  @override
  String get sbLegendary => 'புகழ்பெற்ற';

  @override
  String get sbSthana => 'ஸ்தான பலம்';

  @override
  String get sbDig => 'திக் பலம்';

  @override
  String get sbKala => 'கால பலம்';

  @override
  String get sbChesta => 'சேஷ்டா பலம்';

  @override
  String get sbNaisargika => 'நைசர்கிக பலம்';

  @override
  String get sbDrik => 'த்ருக் பலம்';

  @override
  String get sbSummary => 'கிரக பல சுருக்கம்';

  @override
  String get sbAverageStrength => 'சராசரி பலம்';

  @override
  String get sbHighestRupa => 'அதிக ரூபம்';

  @override
  String get sbRupa => 'ரூபம்';

  @override
  String get sbRanking => 'கிரக தரவரிசை';

  @override
  String get sbRequired => 'தேவையான';

  @override
  String get sbExcess => 'அதிகப்படி';

  @override
  String get sbDeficit => 'பற்றாக்குறை';

  @override
  String get sbTotalShadbala => 'மொத்த ஷட்பலம்';

  @override
  String get sbExplain => 'எனது கிரக பலத்தை விளக்கவும்';

  @override
  String get sbExplainSubtitle => 'உங்கள் கிரகங்களின் பலத்தின் எளிய சுருக்கம்';

  @override
  String get sbInfoTitle => 'ஷட்பலத்தை புரிந்துகொள்ளுதல்';

  @override
  String get sbQWhatIs => 'ஷட்பலம் என்றால் என்ன?';

  @override
  String get sbQRupas => 'ரூபங்கள் என்றால் என்ன?';

  @override
  String get sbQHowCalc => 'பலம் எப்படி கணக்கிடப்படுகிறது?';

  @override
  String get sbQHowUse => 'இதை எப்படி பயன்படுத்துவது';

  @override
  String get sbWhyStrong => 'ஏன் வலிமையானது';

  @override
  String get sbWhyWeak => 'ஏன் பலவீனமானது';

  @override
  String get sbDuringMahadasha => 'மகாதசையின் போது';

  @override
  String get sbEffects => 'விளைவுகள்';

  @override
  String get sbLifeAreas => 'வாழ்க்கைத் துறைகள்';

  @override
  String get sbPlanetDetails => 'கிரக விவரங்கள்';

  @override
  String get sbBodyWhatIs =>
      'ஷட்பலம் (\'ஆறுவகை பலம்\') ஒவ்வொரு கிரகமும் தனது பலன்களை வழங்க எவ்வளவு சக்தி கொண்டுள்ளது என்பதை, ஆறு தனித்தனி பல மூலங்களைச் சேர்த்து அளவிடுகிறது.';

  @override
  String get sbBodyRupas =>
      'பலம் ரூபங்களில் அளவிடப்படுகிறது (1 ரூபம் = 60 விரூபம்). ஒவ்வொரு கிரகமும் வலிமையானதாக கருதப்பட குறைந்தபட்ச ரூப பலம் தேவை; அதிக ரூபங்கள் என்றால் அது தனது பலன்களை இன்னும் முழுமையாக வழங்குகிறது என்று பொருள்.';

  @override
  String get sbBodyHowCalc =>
      'ஆறு பலங்கள் சேர்க்கப்படுகின்றன: ஸ்தானம் (இட ரீதியான), திக் (திசை ரீதியான), காலம் (கால ரீதியான), சேஷ்டா (இயக்க ரீதியான), நைசர்கிகம் (இயற்கையான) மற்றும் த்ருக் (பார்வை ரீதியான). மொத்தத்தை கிரகத்திற்குத் தேவையான குறைந்தபட்சத்துடன் ஒப்பிட்டு சதவீதம் பெறப்படுகிறது.';

  @override
  String get sbBodyHowUse =>
      '100%க்கு மேல் உள்ள கிரகம் தன் பலன்களை வசதியாக வழங்குகிறது; 100%க்கு கீழ் இருந்தால் ஆதரவு தேவை. முக்கியமான விஷயங்களுக்கு உங்கள் வலிமையான கிரகங்களுக்கு முன்னுரிமை கொடுங்கள், பலவீனமானவற்றுக்கு பரிகாரங்களும் பொறுமையும் கொடுங்கள்.';

  @override
  String get sbRemedyStrong =>
      'நன்கு ஆதரிக்கப்படுகிறது — சிறப்பு பரிகாரம் தேவையில்லை; இந்த கிரகத்தின் காலங்களை நம்பிக்கையுடன் பயன்படுத்தலாம்.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '$strongP உங்கள் வலிமையான கிரகம், $strongTraitக்கு சிறந்த ஆதரவை அளிக்கிறது. $weakP மிகவும் பலவீனமானது மற்றும் பரிகாரங்களால் அதிகம் பயனடைகிறது.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '$planetக்கு $category ஷட்பலம் உள்ளது, எனவே அதன் $karakatva அதற்கேற்ப ஆதரிக்கப்படுகின்றன.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return '$bala மூலம் மிகவும் வலிமையானது ($rupa ரூபங்கள்).';
  }

  @override
  String sbWeakLine(Object bala) {
    return '$balaஇல் மிகவும் பலவீனமானது, இது மொத்தத்தை குறைக்கிறது.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return '$planetஇன் மகாதசையின் போது, அதன் $karak முன்னிலைக்கு வருகின்றன.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'வலிமையான ஷட்பலத்துடன், $karak இயற்கையாகவே ஆதரிக்கப்படுகின்றன.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'மிதமான ஷட்பலத்துடன், $karakக்கு உணர்வுபூர்வமான முயற்சி தேவைப்படலாம்.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return '$planetஇன் மந்திரம், ரத்தினம் அல்லது தானம் மூலம் வலிமைப்படுத்துங்கள், மற்றும் அதன் காலங்களில் பொறுமையாக செயல்படுங்கள்.';
  }

  @override
  String get bhOverview => 'கண்ணோட்டம்';

  @override
  String get bhDetailed => 'விரிவான';

  @override
  String get bhavaHouses => 'வீடுகள்';

  @override
  String get bhStrengthOverview => 'வீட்டு பலம் கண்ணோட்டம்';

  @override
  String get bhOverallAverage => 'ஒட்டுமொத்த வீடு சராசரி';

  @override
  String get bhStrongestHouse => 'மிகவும் வலிமையான வீடு';

  @override
  String get bhWeakestHouse => 'மிகவும் பலவீனமான வீடு';

  @override
  String get bhBestArea => 'சிறந்த வாழ்க்கை பகுதி';

  @override
  String get bhNeedsAttention => 'கவனம் தேவை';

  @override
  String get bhSavContribution => 'SAV பங்களிப்பு';

  @override
  String get bhLordCondition => 'வீட்டு அதிபதியின் நிலை';

  @override
  String get bhBenefic => 'சுப தாக்கம்';

  @override
  String get bhMalefic => 'பாப தாக்கம்';

  @override
  String get bhStrengthReasons => 'இந்த மதிப்பெண் ஏன்';

  @override
  String get bhGoodEffects => 'நல்ல விளைவுகள்';

  @override
  String get bhChallenges => 'சவால்கள்';

  @override
  String get bhRemedies => 'பரிகாரங்கள்';

  @override
  String get bhRanking => 'வீடு தரவரிசை';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'எனது வீடுகளை விளக்கவும்';

  @override
  String get bhExplainSubtitle => 'உங்கள் 12 வீடுகளின் எளிய சுருக்கம்';

  @override
  String bhHeroSummary(
    Object s1,
    Object s2,
    Object strongArea,
    Object weakArea,
  ) {
    return 'உங்கள் மிகவும் வலிமையான வீடுகள் $s1 மற்றும் $s2. $strongArea இயற்கையாகவே வலிமையானது, அதே நேரத்தில் $weakArea-க்கு கூடுதல் முயற்சி தேவைப்படுகிறது.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'இதன் அதிபதி $lord $relation ஆக அமைந்துள்ளார்.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'இந்த வீட்டில் $sav சுப புள்ளிகள் (SAV) உள்ளன; இதில் அமர்ந்துள்ள கிரகங்களும் அவற்றின் பார்வைகளும் மீதமுள்ள மதிப்பெண்ணை தீர்மானிக்கின்றன.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'வலிமையாக இருக்கும்போது, இது $meaning-ஐ ஆதரிக்கிறது.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'பலவீனமாக இருக்கும்போது, $meaning-க்கு கூடுதல் முயற்சியும் கவனிப்பும் தேவைப்படலாம்.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'இதை மேம்படுத்த அதிபதி $lord-ஐ பலப்படுத்தி, இந்த வீட்டின் விஷயங்களை மதிக்கவும்.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'உங்கள் $house $strengthWord ஆக உள்ளது. இது $meaning-ஐ நிர்வகிக்கிறது.';
  }

  @override
  String get kunNavamsa => 'நவாம்சம் (D9)';

  @override
  String get kunD10 => 'தசாம்சம் (D10)';

  @override
  String get kunPlacement => 'கிரக நிலை';

  @override
  String get kunHousesTitle => 'பாவ விவரங்கள்';

  @override
  String get kunPlanet => 'கிரகம்';

  @override
  String get kunNakshatra => 'நட்சத்திரம்';

  @override
  String get kunPada => 'பாதம்';

  @override
  String get kunLord => 'அதிபதி';

  @override
  String get kunExplain => 'என் ஜாதகத்தை விளக்குக';

  @override
  String get kunExplainSubtitle => 'உங்கள் ஜாதகத்தின் எளிய சுருக்கம்';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return '$ordinal பாவம் $meaning ஐ நிர்வகிக்கிறது.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return 'இங்கு அமைந்துள்ள $planets இதன் பலன்களை வடிவமைக்கின்றன.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'உங்கள் லக்னம் $asc, இது உங்கள் பார்வையையும் மற்றவர்கள் உங்களை முதலில் எப்படி காண்கிறார்கள் என்பதையும் வடிவமைக்கிறது.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'உங்கள் மனமும் உணர்வுகளும் $moon-இல் உள்ள சந்திரனைப் பின்பற்றுகின்றன.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '$planet உங்கள் மிகவும் வலிமையான கிரகம் — எளிமை மற்றும் ஆதரவின் இயற்கையான பகுதி.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '$planet உங்களை அதிகம் சோதிக்கும் கிரகம் — இங்கு பொறுமையும் முயற்சியும் பலனளிக்கும்.';
  }

  @override
  String get plNature => 'இயல்பு';

  @override
  String get plElement => 'தனிமம்';

  @override
  String get plGender => 'பாலினம்';

  @override
  String get plKarakatva => 'காரகத்துவம்';

  @override
  String get plLordship => 'அதிபத்தியம்';

  @override
  String get plStrength => 'பலம்';

  @override
  String get plAspectsGiven => 'கொடுக்கப்பட்ட பார்வை';

  @override
  String get plAspectsReceived => 'பெறப்பட்ட பார்வை';

  @override
  String get plConjunction => 'யுதி';

  @override
  String get plHouseMeaning => 'பாவத்தின் பொருள்';

  @override
  String get plNakshatraMeaning => 'நக்ஷத்திரத்தின் பொருள்';

  @override
  String get plAiInterpretation => 'AI விளக்கம்';

  @override
  String get plSearchHint => 'எந்த கிரகத்தையும் தேடுங்கள்';

  @override
  String get plNoResults => 'கிரகங்கள் எதுவும் கிடைக்கவில்லை';

  @override
  String get plBenefic => 'சுப';

  @override
  String get plMalefic => 'பாப';

  @override
  String get plMale => 'ஆண்';

  @override
  String get plFemale => 'பெண்';

  @override
  String get plNeutralGender => 'நபும்சகம்';

  @override
  String get plOwnSign => 'ஸ்வ ராசி';

  @override
  String get plFriend => 'மித்ர ராசி';

  @override
  String get plEnemy => 'சத்ரு ராசி';

  @override
  String get plNeutral => 'சம';

  @override
  String get sumEther => 'ஆகாயம்';

  @override
  String plLordOfHouses(Object houses) {
    return 'பாவம் $houses-க்கு அதிபதி';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return '$nakLord ஆல் ஆளப்படுகிறது, $trait-ஐக் கொண்டு வருகிறது.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '$planet $sign ராசியில், $house பாவத்தில் அமைந்துள்ளது.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'இதன் முக்கிய காரகத்துவங்கள் — $karak — இங்கு நன்கு ஆதரிக்கப்படுகின்றன.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'இதன் முக்கிய காரகத்துவங்கள் — $karak — இங்கு நனவான முயற்சி தேவைப்படலாம்.';
  }

  @override
  String plAiExalted(Object planet) {
    return '$planet உச்சத்தில் உள்ளது, தனது சிறந்த பலன்களை அளிக்கிறது.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '$planet நீசத்தில் உள்ளது, தனது பலன்களை அளிக்க ஆதரவு தேவை.';
  }

  @override
  String plAiCombust(Object planet) {
    return '$planet அஸ்தமித்துள்ளது, எனவே சூரியனின் தீவிரத்தில் இது குறைவாகவே வெளிப்படையாக செயல்படுகிறது.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '$planet வர்கோத்தமமாக உள்ளது — இந்த வலுவான நிலை நவாம்சத்திலும் மீண்டும் வருகிறது.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '$planet வக்ரமாக உள்ளது, தனது ஆற்றலை உள்நோக்கி திருப்பி அதை தீவிரப்படுத்துகிறது.';
  }

  @override
  String get plHouse1 => 'தான், உடல், ஆளுமை மற்றும் உயிர்ச்சக்தி';

  @override
  String get plHouse2 => 'செல்வம், குடும்பம், பேச்சு மற்றும் உணவு';

  @override
  String get plHouse3 =>
      'தைரியம், உடன்பிறப்புகள், தொடர்பு மற்றும் குறுகிய பயணங்கள்';

  @override
  String get plHouse4 => 'வீடு, தாய், வசதி, சொத்து மற்றும் அக அமைதி';

  @override
  String get plHouse5 =>
      'குழந்தைகள், படைப்பாற்றல், அறிவு, காதல் மற்றும் முன்வினைப் புண்ணியம்';

  @override
  String get plHouse6 =>
      'ஆரோக்கியம், எதிரிகள், கடன்கள், சேவை மற்றும் அன்றாட வேலை';

  @override
  String get plHouse7 => 'திருமணம், கூட்டாண்மை மற்றும் வணிக உறவுகள்';

  @override
  String get plHouse8 => 'ஆயுள், மாற்றம், ரகசியங்கள் மற்றும் வாரிசு உரிமை';

  @override
  String get plHouse9 => 'பாக்கியம், தர்மம், உயர்கல்வி, குரு மற்றும் தந்தை';

  @override
  String get plHouse10 => 'தொழில், அந்தஸ்து, அதிகாரம் மற்றும் பொது கர்மா';

  @override
  String get plHouse11 =>
      'ஆதாயங்கள், வருமானம், நண்பர்கள், தொடர்பு வலை மற்றும் நிறைவேறிய ஆசைகள்';

  @override
  String get plHouse12 =>
      'இழப்பு, செலவுகள், வெளிநாடு, ஆன்மீகம் மற்றும் மோட்சம்';

  @override
  String get sumVeryStrong => 'மிகவும் வலிமையானது';

  @override
  String get sumStrong => 'வலிமையானது';

  @override
  String get sumAverage => 'சராசரி';

  @override
  String get sumWeak => 'பலவீனமானது';

  @override
  String get sumNeedsAttention => 'கவனம் தேவை';

  @override
  String get sumFire => 'அக்னி';

  @override
  String get sumEarth => 'பூமி';

  @override
  String get sumAir => 'வாயு';

  @override
  String get sumWater => 'நீர்';

  @override
  String get sumMovable => 'சரம்';

  @override
  String get sumFixed => 'ஸ்திரம்';

  @override
  String get sumDual => 'த்விஸ்வபாவ';

  @override
  String get sumDirEast => 'கிழக்கு';

  @override
  String get sumDirWest => 'மேற்கு';

  @override
  String get sumDirNorth => 'வடக்கு';

  @override
  String get sumDirSouth => 'தெற்கு';

  @override
  String get sumDirNE => 'வடகிழக்கு';

  @override
  String get sumDirNW => 'வடமேற்கு';

  @override
  String get sumDirSE => 'தென்கிழக்கு';

  @override
  String get sumDirSW => 'தென்மேற்கு';

  @override
  String get sumSnapshotTitle => 'உங்கள் ஜோதிட சுருக்கம்';

  @override
  String get sumMahadasha => 'மகாதசை';

  @override
  String get sumAntardasha => 'அந்தர்தசை';

  @override
  String get sumNakshatra => 'ஜென்ம நட்சத்திரம்';

  @override
  String get sumElement => 'தத்துவம்';

  @override
  String get sumModality => 'இயல்பு';

  @override
  String get sumLuckyDirection => 'அதிர்ஷ்ட திசை';

  @override
  String get sumHighlights => 'முக்கிய அம்சங்கள்';

  @override
  String get sumStrongPlanet => 'வலிமையான கிரகம்';

  @override
  String get sumWeakPlanet => 'பலவீனமான கிரகம்';

  @override
  String get sumYogas => 'யோகங்கள்';

  @override
  String get sumDoshas => 'தோஷங்கள்';

  @override
  String get sumRetrograde => 'வக்ரம்';

  @override
  String get sumCombust => 'அஸ்தமனம்';

  @override
  String get sumExalted => 'உச்சம்';

  @override
  String get sumDebilitated => 'நீசம்';

  @override
  String get sumVargottama => 'வர்கோத்தமம்';

  @override
  String get sumQuickInsights => 'விரைவு நுண்ணறிவு';

  @override
  String get sumSpirituality => 'ஆன்மீகம்';

  @override
  String get sumTimezone => 'நேர மண்டலம்';

  @override
  String get sumAyanamsa => 'அயனாம்சம்';

  @override
  String get sumCalendarType => 'பஞ்சாங்கம்';

  @override
  String get sumCopied => 'கிளிப்போர்டில் நகலெடுக்கப்பட்டது';

  @override
  String get sumNatureFire =>
      'நீங்கள் ஒரு தைரியமான, சுறுசுறுப்பான மற்றும் முன்னோடித்தனமான இயல்பு கொண்டவர், முன்னின்று வழிநடத்துகிறீர்கள்.';

  @override
  String get sumNatureEarth =>
      'நீங்கள் நடைமுறையான, உறுதியான மற்றும் ஒழுங்குபடுத்தப்பட்ட இயல்பு கொண்டவர், நீடித்த முடிவுகளை உருவாக்குகிறீர்கள்.';

  @override
  String get sumNatureAir =>
      'நீங்கள் ஆர்வமுள்ள, தொடர்பாடல் திறன் மிக்க மற்றும் அறிவார்ந்த இயல்பு கொண்டவர், புதிய கருத்துக்களில் சிறந்து விளங்குகிறீர்கள்.';

  @override
  String get sumNatureWater =>
      'நீங்கள் உள்ளுணர்வு மிக்க, உணர்ச்சிபூர்வமான மற்றும் பரிவுள்ள இயல்பு கொண்டவர், ஆழ்ந்த உள் உணர்திறன் கொண்டவர்.';

  @override
  String get sumGradePhraseExcellent =>
      'வலுவாக ஆதரிக்கப்படுகிறது — நிலையான முயற்சியுடன் சாதகமான முடிவுகள் கிடைக்க வாய்ப்புள்ளது.';

  @override
  String get sumGradePhraseGood =>
      'நன்கு ஆதரிக்கப்படுகிறது — சிறிது கவனத்துடன் பொதுவாக நேர்மறையான முடிவுகள்.';

  @override
  String get sumGradePhraseAverage =>
      'கலப்பு ஆதரவு — முடிவுகள் முயற்சி மற்றும் நேரத்தைப் பொறுத்தது.';

  @override
  String get sumGradePhraseWeak =>
      'கவனம் தேவை — பொறுமையும் பரிகாரங்களும் இங்கு உதவும்.';

  @override
  String get kDefCombust =>
      'சூரியனுக்கு மிக அருகில் இருக்கும் ஒரு கிரகம், அதனால் அதன் ஆற்றல் \'எரிந்து\' பலவீனமடைகிறது.';

  @override
  String get kDefRetrograde =>
      'பின்னோக்கி நகர்வது போல் தோன்றும் ஒரு கிரகம்; அதன் விளைவுகள் உள்நோக்கி திரும்பி தீவிரமடைகின்றன.';

  @override
  String get kDefNakshatra =>
      'சந்திரனும் கிரகங்களும் பயணிக்கும் 27 நட்சத்திர மண்டலங்களில் ஒன்று.';

  @override
  String get kDefVargottama =>
      'ஜென்ம ஜாதகத்திலும் (D1) நவாம்சத்திலும் (D9) ஒரே ராசியில் இருக்கும் ஒரு கிரகம் — வலிமையின் அடையாளம்.';

  @override
  String get kDefOwnSign =>
      'தான் ஆளும் ராசியில் அமர்ந்திருக்கும் ஒரு கிரகம், அங்கு அது வீட்டைப் போல உணர்ந்து நிலையான முடிவுகளை அளிக்கிறது.';

  @override
  String get kDefExalted =>
      'தனது மிகுந்த வலிமையின் ராசியில் இருக்கும் ஒரு கிரகம், அது சிறந்த முடிவுகளை அளிக்கிறது.';

  @override
  String get kDefDebilitated =>
      'தனது பலவீனமான ராசியில் இருக்கும் ஒரு கிரகம், அங்கு அது முடிவுகளை அளிக்க போராடுகிறது.';

  @override
  String get kDefMooltrikona =>
      'ஒரு கிரகத்தின் சொந்த ராசியின் ஒரு சிறப்பு பகுதி, அங்கு அது குறிப்பாக சக்திவாய்ந்ததாக இருக்கும்.';

  @override
  String get kDefAscendant =>
      'பிறந்த நேரத்தில் கிழக்கு அடிவானத்தில் உதிக்கும் ராசி — லக்னம், ஜாதகத்தின் அடித்தளம்.';

  @override
  String get kDefMahadasha =>
      'வாழ்க்கையின் நீண்ட காலத்தை வண்ணமயமாக்கும் முக்கிய கிரக காலம்.';

  @override
  String get kDefAntardasha =>
      'மகாதசைக்குள் இருக்கும் ஒரு துணைக்காலம், அதன் முடிவுகளை நுட்பமாக சரிசெய்கிறது.';

  @override
  String get kDefPada =>
      'ஒரு கிரகம் அமைந்திருக்கும் நட்சத்திரத்தின் நான்கு பாதங்களில் ஒன்று.';

  @override
  String get aspGivesAspectTo => 'பார்வை செலுத்துகிறது';

  @override
  String get aspReceivesAspectFrom => 'பார்வை பெறுகிறது';

  @override
  String get aspInfluences => 'பாதிக்கிறது';

  @override
  String get aspNoInfluence => 'தாக்கம் இல்லை';

  @override
  String get aspNoAspect => 'பார்வை இல்லை';

  @override
  String get aspPresent => 'உள்ளது';

  @override
  String get aspAbsent => 'இல்லாதது';

  @override
  String get aspNotPresent => 'இருக்கவில்லை';

  @override
  String get aspSpecialAspect => 'சிறப்பு பார்வை';

  @override
  String get aspAspectWord => 'பார்வை';

  @override
  String get aspTotalGiven => 'கொடுக்கப்பட்ட பார்வைகள்';

  @override
  String get aspTotalReceived => 'பெறப்பட்ட பார்வைகள்';

  @override
  String get aspStrongestInfluence => 'மிக வலிமையான தாக்கம்';

  @override
  String get aspMedium => 'நடுத்தரம்';

  @override
  String get aspAspectPresent => 'பார்வை உள்ளது';

  @override
  String get aspReason => 'காரணம்';

  @override
  String get aspBoth => 'இரண்டும்';

  @override
  String get aspTargetHouse => 'இலக்கு வீடு';

  @override
  String get aspTargetSign => 'இலக்கு ராசி';

  @override
  String get aspLagnaReceives => 'லக்னம் பார்வை பெறும் கிரகங்கள்';

  @override
  String get aspNoAspectFrom => 'இவற்றிலிருந்து பார்வை இல்லை';

  @override
  String get aspPlanetToPlanet => 'கிரகத்திலிருந்து கிரகம்';

  @override
  String get aspSignToSign => 'ராசியிலிருந்து ராசி';

  @override
  String get aspCombinedAspect => 'இணைந்த பார்வை';

  @override
  String get aspGrahaAspect => 'கிரக பார்வை';

  @override
  String get aspRashiAspect => 'ராசி பார்வை';

  @override
  String get aspInfoTitle => 'பார்வை (Drishti) பற்றி அறிதல்';

  @override
  String get aspQGraha => 'கிரக பார்வை என்றால் என்ன?';

  @override
  String get aspQRashi => 'ராசி பார்வை என்றால் என்ன?';

  @override
  String get aspQDiff => 'இரண்டிற்கும் இடையேயான வேறுபாடு';

  @override
  String get aspQPredict => 'பார்வைகள் பலனை எவ்வாறு பாதிக்கின்றன';

  @override
  String get aspGrahaBody =>
      'கிரக பார்வை என்பது ஒரு கிரகம் தன் நிலையிலிருந்து செலுத்தும் பார்வையாகும். ஒவ்வொரு கிரகமும் தன் இடத்திலிருந்து 7வது வீடு/கிரகத்தின் மீது முழு பார்வையை செலுத்துகிறது (நேரடியான, முகம் நோக்கிய தாக்கம்). கூடுதலாக, செவ்வாய் 4வது மற்றும் 8வது மீதும், குரு 5வது மற்றும் 9வது மீதும், சனி 3வது மற்றும் 10வது மீதும் பார்வை செலுத்துகிறது. ராகு மற்றும் கேது பொதுவாக 5, 7, 9 ஆகிய பார்வைகளைப் பெறுகின்றன. ஒரு கிரகத்தின் பார்வை அது விழும் கிரகம் அல்லது வீட்டிற்கு தன் இயல்பின் நிறத்தை ஏற்றுகிறது.';

  @override
  String get aspRashiBody =>
      'ராசி பார்வை என்பது ஜைமினி ஜோதிடத்தில் இருந்து வரும் ராசி-க்கு-ராசி பார்வையாகும், அது அங்கு எந்த கிரகங்கள் இருக்கின்றன என்பதைச் சாராது. சர ராசிகள் நிலை ராசிகளைப் பார்க்கும் (அருகிலுள்ளதைத் தவிர), நிலை ராசிகள் சர ராசிகளைப் பார்க்கும் (அருகிலுள்ளதைத் தவிர), மற்றும் உபய ராசிகள் மற்ற உபய ராசிகளைப் பார்க்கும். இது முக்கியமாக ஜைமினி பலன் கூறுதலிலும், வீடுகளுக்கு இடையேயான தொடர்பை மதிப்பிடவும் பயன்படுத்தப்படுகிறது.';

  @override
  String get aspDiffBody =>
      'கிரக பார்வை ஒரு கிரகத்தால் செலுத்தப்படுகிறது, அது அந்த கிரகம் எங்கு உள்ளது என்பதைப் பொறுத்தது. ராசி பார்வை ராசிக்கே சொந்தமானது, அதில் எது வைக்கப்பட்டிருந்தாலும் அதற்குப் பொருந்தும். கிரக பார்வை திசைசார்ந்தது (கிரகம் A கிரகம் B-ஐ பார்க்கிறது), ராசி பார்வை பொதுவாக ராசிகளுக்கு இடையே பரஸ்பரமானது. இரண்டும் ஒரே இலக்கை சுட்டும் போது, தாக்கம் குறிப்பாக வலுவாக இருக்கும்.';

  @override
  String get aspPredictBody =>
      'ஒரு பார்வை, ஒரு கிரகம் தன் சொந்த வீட்டிற்கு அப்பால் தன் தாக்கத்தை எங்கு விரிவுபடுத்துகிறது என்பதைக் காட்டுகிறது. ஒரு நல்ல பார்வை (குரு, சுக்கிரன், நன்கு அமைந்த சந்திரன்/புதன்) இலக்கை ஆதரித்து பாதுகாக்கிறது; ஒரு தீய பார்வை (சனி, செவ்வாய், சூரியன், ராகு, கேது) அதன் மீது அழுத்தம், தாமதம் அல்லது சவால் ஏற்படுத்தலாம். எந்த கிரகங்கள் ஒரு வீடு அல்லது கிரகத்தை பார்க்கின்றன என்பதைப் படிப்பது, முடிவுகள் ஏன் அவ்வாறு தோன்றுகின்றன என்பதை விளக்குகிறது.';

  @override
  String get aspTraitSun => 'அதிகாரம், தலைமைத்துவம் மற்றும் உயிர்ச்சக்தி';

  @override
  String get aspTraitMoon =>
      'உணர்வுப் பூர்வமான ஆழம், ஆறுதல் மற்றும் உள்ளுணர்வு';

  @override
  String get aspTraitMars => 'ஆற்றல், தைரியம் மற்றும் உந்துவிசை';

  @override
  String get aspTraitMercury => 'தொடர்பாடல், அறிவு மற்றும் தகவமைப்புத் திறன்';

  @override
  String get aspTraitJupiter => 'ஞானம், வளர்ச்சி மற்றும் நல்வாய்ப்பு';

  @override
  String get aspTraitVenus => 'காதல், இணக்கம் மற்றும் இன்பங்கள்';

  @override
  String get aspTraitSaturn =>
      'ஒழுக்கம், பொறுப்பு மற்றும் பொறுமையான, சில நேரங்களில் தாமதமான, வெற்றி';

  @override
  String get aspTraitRahu => 'லட்சியம், தீவிரம் மற்றும் மரபுசாராத திருப்பங்கள்';

  @override
  String get aspTraitKetu => 'பற்றின்மை, ஆன்மீகம் மற்றும் திடீர் மாற்றம்';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '$planet $targets-ஐ பாதிக்கிறது. இது இந்த கிரகங்கள் குறிக்கும் பகுதிகளில் $trait கொண்டு வரலாம்.';
  }

  @override
  String aspAiNone(Object planet) {
    return '$planet இங்கு வேறு எந்த கிரகத்தின் மீதும் சிறப்புப் பார்வையை செலுத்தவில்லை; இதன் தாக்கம் முக்கியமாக அதன் சொந்த ராசி மற்றும் வீட்டின் மூலமே செயல்படுகிறது.';
  }

  @override
  String get avSummaryTitle => 'அஷ்டகவர்க்க சுருக்கம்';

  @override
  String get avOverallScore => 'மொத்த SAV மதிப்பெண்';

  @override
  String get avOverallRating => 'ஒட்டுமொத்த மதிப்பீடு';

  @override
  String get avStrongestSigns => 'வலிமையான ராசிகள்';

  @override
  String get avWeakestSigns => 'பலவீனமான ராசிகள்';

  @override
  String get avScore => 'மதிப்பெண்';

  @override
  String get avMeaning => 'பொருள்';

  @override
  String get avGrid => 'கட்டம்';

  @override
  String get avList => 'பட்டியல்';

  @override
  String get avOverallScoreShort => 'மொத்த மதிப்பெண்';

  @override
  String get avNatalSignScore => 'ஜென்ம ராசி மதிப்பெண்';

  @override
  String get avBestSigns => 'சிறந்த ராசிகள்';

  @override
  String get avWeakSigns => 'பலவீன ராசிகள்';

  @override
  String get avAiInterpretation => 'AI விளக்கம்';

  @override
  String get avVeryGood => 'மிக நல்லது';

  @override
  String get avVeryWeak => 'மிகவும் பலவீனம்';

  @override
  String get avTotalSav => 'மொத்த SAV';

  @override
  String get avPlanetContributions => 'கிரக பங்களிப்புகள்';

  @override
  String get avFinance => 'நிதி';

  @override
  String get avOverallStrength => 'ஒட்டுமொத்த வலிமை';

  @override
  String get avWhatDoesThisMean => 'இதன் பொருள் என்ன?';

  @override
  String get avSimple => 'எளிமை';

  @override
  String get avAdvanced => 'விரிவானது';

  @override
  String get avInfoTitle => 'அஷ்டகவர்க்கத்தை புரிந்துகொள்ளுதல்';

  @override
  String get avStrong => 'வலிமையானது';

  @override
  String get avModerate => 'மிதமானது';

  @override
  String get avQWhatIsAv => 'அஷ்டகவர்க்கம் என்றால் என்ன?';

  @override
  String get avQWhatIsSav => 'SAV என்றால் என்ன?';

  @override
  String get avQWhatIsBav => 'BAV என்றால் என்ன?';

  @override
  String get avQHowToRead => 'இந்த மதிப்பெண்களை எப்படி படிப்பது';

  @override
  String get avQSavVsBav => 'SAV Vs BAV';

  @override
  String get avABody =>
      'அஷ்டகவர்க்கம் என்பது வேத ஜோதிடத்தில் மதிப்பெண்களை அடிப்படையாகக் கொண்ட ஒரு வலிமை அமைப்பு ஆகும். ஒவ்வொரு கிரகமும் தனது நிலைப்பாட்டைப் பொறுத்து பன்னிரண்டு ராசிகளுக்கும் சுப மதிப்பெண்களை (பிந்து, ரேகை என்றும் அழைக்கப்படும்) வழங்குகிறது. ஒரு ராசியில் அதிக மதிப்பெண் இருந்தால், அதனுடன் தொடர்புடைய கிரக தசை மற்றும் கோச்சாரங்களின் போது வாழ்க்கையின் அந்தப் பகுதி மென்மையான ஆதரவைப் பெறும்.';

  @override
  String get avSavBody =>
      'SAV (சர்வ அஷ்டகவர்க்கம்) ஒவ்வொரு ராசிக்கும் ஏழு கிரகங்களின் மதிப்பெண்களைச் சேர்க்கிறது. இது ஒவ்வொரு ராசிக்கும் ஒரே ஒரு வலிமை மதிப்பெண்ணைத் தருகிறது, இதனால் உங்கள் ஜாதகத்தில் எந்த ராசிகள் — மற்றும் அவை அமைந்துள்ள பாவங்கள் — அதிக ஆதரவைப் பெறுகின்றன என்பதை நீங்கள் விரைவாகக் காணலாம்.';

  @override
  String get avBavBody =>
      'BAV (பின்ன அஷ்டகவர்க்கம்) ஒரு தனி கிரகத்தின் மதிப்பெண்களை பன்னிரண்டு ராசிகளிலும் காட்டுகிறது. இது ஒரு குறிப்பிட்ட கிரகம் எந்த ராசிகளுக்கு அதிக ஆதரவு தருகிறது என்பதைக் காட்டுகிறது, அந்த கிரகத்தின் தசை அல்லது கோச்சாரம் செயலில் இருக்கும்போது இது முக்கியமாகிறது.';

  @override
  String get avHowToReadBody =>
      'அதிக எண்கள் சிறந்தவை. SAV-க்கு, சராசரி ராசி சுமார் 28 மதிப்பெண்களைப் பெறும் — 30-க்கு மேல் வலிமையானது, 25-க்கு கீழ் கவனம் தேவை. BAV-க்கு, ஒவ்வொரு ராசியும் 0 முதல் 8 வரை இருக்கும், 4 சராசரியாகக் கருதப்படுகிறது. முக்கியமான செயல்களுக்கு உங்கள் வலிமையான ராசிகளுக்கு முன்னுரிமை கொடுங்கள், மேலும் உங்கள் பலவீனமான ராசிகளின் விஷயங்களில் பொறுமையாகவும் ஒழுக்கமாகவும் இருங்கள்.';

  @override
  String get avSavVsBavBody =>
      'SAV என்பது அனைத்து கிரகங்களின் இணைந்த மொத்தம் ஆகும், இது ஒரு ராசியின் ஒட்டுமொத்த வலிமையைக் காட்டுகிறது. BAV என்பது ஒரு தனி கிரகத்தின் பங்களிப்பு ஆகும், இது எந்த கிரகம் அந்த ராசிக்கு ஆதரவு தருகிறது என்பதைக் காட்டுகிறது. பெரிய படத்தைப் புரிந்துகொள்ள SAV-ஐப் பயன்படுத்துங்கள், எந்த கிரகம் ராசியின் வலிமையை இயக்குகிறது என்பதைப் புரிந்துகொள்ள BAV-ஐப் பாருங்கள்.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'உங்கள் ஜாதகம் $s1, $s2 மற்றும் $s3 ராசிகளில் மிகவும் வலிமையானது. இந்த ராசிகள் கிரக தசைகள் மற்றும் கோச்சாரங்களின் போது சிறந்த ஆதரவைத் தருகின்றன. $weak தற்போது மிகக் குறைந்த ஆதரவைப் பெற்றுள்ளது, எனவே இதனுடன் தொடர்புடைய விஷயங்களில் பொறுமையும் ஒழுக்கமும் உதவும்.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '$planet $s1 மற்றும் $s2 மூலம் மிகச் சிறப்பாகச் செயல்படுகிறது. இந்த ராசிகள் செயல்பாட்டில் இருக்கும்போது $planet கட்டுப்படுத்தும் விஷயங்கள் மேம்படுகின்றன.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'உங்கள் வலிமையான ராசிகள் $s1 மற்றும் $s2 — கிரகங்கள் இவற்றின் வழியாக கோச்சாரம் செய்யும்போது முக்கியமான தொடக்கங்களுக்கு இவற்றுக்கு முன்னுரிமை கொடுங்கள்.';
  }

  @override
  String avInsightWeak(Object s1) {
    return '$s1-க்கு மிகக் குறைந்த ஆதரவு உள்ளது — அதன் விஷயங்களில் கவனமாக செயல்படுங்கள், அதிக அளவு உறுதிமொழிகளைத் தவிருங்கள்.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '$planet-க்கு அதிக மதிப்பெண்கள் உள்ளன, எனவே அதன் அம்சங்கள் உங்கள் வாழ்க்கையில் நன்கு ஆதரிக்கப்படுகின்றன.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '$planet-க்கு மிகக் குறைந்த மதிப்பெண்கள் உள்ளன, மேலும் பரிகாரங்கள் மற்றும் சிந்தனையுடன் கூடிய முயற்சியால் அதிக பயன் பெறுகிறது.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'உங்கள் சராசரியான $avg மதிப்பெண்களுக்கு மேல் மதிப்பெண் பெறும் ராசிகள் பொதுவாக மென்மையான, நம்பகமான முடிவுகளைத் தருகின்றன.';
  }

  @override
  String get fcKey => 'குறியீடு';

  @override
  String get fcActions => 'செயல்கள்';

  @override
  String get fcCautions => 'எச்சரிக்கைகள்';

  @override
  String get fc12House => '12 வீடுகள்';

  @override
  String get fcProbabilities => 'சாத்தியக்கூறுகள்';

  @override
  String get fcHousesCaps => 'வீடுகள்';

  @override
  String get fcCritical => 'மிக முக்கியமான';

  @override
  String get fcFlags => 'குறிகள்';

  @override
  String get fcAnalysis => 'பகுப்பாய்வு';

  @override
  String get fcConfidence => 'நம்பிக்கை';

  @override
  String get fcQualityCaps => 'தரம்';

  @override
  String get fcIncomeVs => 'வருமானம் எதிராக';

  @override
  String get fcExpense => 'செலவு';

  @override
  String get fcFinance => 'நிதி';

  @override
  String get fcNetBalance => 'நிகர இருப்பு';

  @override
  String get fcSignature => 'கையொப்பம்';

  @override
  String get fcBestTimeForIncome => 'வருமானத்திற்கான சிறந்த நேரம்';

  @override
  String get fcExpenseCaution => 'செலவு எச்சரிக்கை';

  @override
  String get fcIncomeCaps => 'வருமானம்';

  @override
  String get fcExpenseCaps => 'செலவு';

  @override
  String get fcRelationships => 'உறவுகள்';

  @override
  String get fcAreasCaps => 'பகுதிகள்';

  @override
  String get fcBestForMeetings => 'கூட்டங்களுக்கு சிறந்தது';

  @override
  String get fcOpportunitiesVs => 'வாய்ப்புகள் எதிராக';

  @override
  String get fcRisks => 'அபாயங்கள்';

  @override
  String get fcOutlook => 'கண்ணோட்டம்';

  @override
  String get fcAction => 'செயல்';

  @override
  String get fcProtect => 'பாதுகா';

  @override
  String get fcOpportunityCaps => 'வாய்ப்பு';

  @override
  String get fcRiskCaps => 'அபாயம்';

  @override
  String get fcTopOpportunities => 'முதன்மை வாய்ப்புகள்';

  @override
  String get fcTopRisks => 'முதன்மை அபாயங்கள்';

  @override
  String get fcTiming => 'நேரம்';

  @override
  String get fcWindows => 'நேர இடைவெளிகள்';

  @override
  String get fcSlotsCaps => 'நேரங்கள்';

  @override
  String get fcBestWindows => 'சிறந்த நேரங்கள்';

  @override
  String get fcWorstWindows => 'மோசமான நேரங்கள்';

  @override
  String get fcAvoid => 'தவிர்க்கவும்';

  @override
  String get fcHouse => 'வீடு';

  @override
  String get fcFailed => 'தோல்வி';

  @override
  String get lifeCareer => 'தொழில்';

  @override
  String get lifeHealth => 'ஆரோக்கியம்';

  @override
  String get lifeWealth => 'செல்வம்';

  @override
  String get lifeFamily => 'குடும்பம்';

  @override
  String get lifeMind => 'மனம்';

  @override
  String get lifeEgo => 'அகங்காரம்';

  @override
  String get lifeAggression => 'ஆக்கிரமிப்பு';

  @override
  String get lifeConflict => 'மோதல்';

  @override
  String get rashiElement => 'தத்துவம்';

  @override
  String get rashiQuality => 'குணம்';

  @override
  String get rashiLuckyColor => 'அதிர்ஷ்ட நிறம்';

  @override
  String get rashiLuckyDay => 'அதிர்ஷ்ட நாள்';

  @override
  String get rashiLuckyNumber => 'அதிர்ஷ்ட எண்';

  @override
  String get rashiGemstone => 'ரத்தினம்';

  @override
  String get rashiBody => 'உடல்';

  @override
  String get gocharTodaysTransitChart => 'இன்றைய கோச்சார விளக்கப்படம்';

  @override
  String get gocharTransit => 'கோச்சாரம்';

  @override
  String get thisWeek => 'இந்த வாரம்';

  @override
  String get thisMonth => 'இந்த மாதம்';

  @override
  String get best => 'சிறந்த';

  @override
  String get worst => 'மோசமான';

  @override
  String get avg => 'avg';

  @override
  String get favorableLoveWindowsLabel => 'சாதகமான காதல் காலங்கள்';

  @override
  String get lordLabel => 'அதிபதி';

  @override
  String get lordPlacementLabel => 'அதிபதி நிலை';

  @override
  String get lordDignityLabel => 'அதிபதி பலம்';

  @override
  String get categoriesSuffix => 'வகைகள்';

  @override
  String get coreBlockerLabel => 'முக்கிய தடை';

  @override
  String get coreGiftLabel => '✦ முக்கிய கொடை';

  @override
  String get coreThemeLabel => '● முக்கிய கருப்பொருள்';

  @override
  String dominantLabel(Object value) {
    return 'மேலோங்கியது: $value';
  }

  @override
  String get karakasSuffix => 'காரகர்கள்';

  @override
  String get protectiveLabel => 'பாதுகாப்பு';

  @override
  String secondaryLabel(Object value) {
    return ' · இரண்டாம்: $value';
  }

  @override
  String get tagCore => 'முக்கியம்';

  @override
  String get debtScoresHeader => '📉 கடன் மதிப்பெண்கள்';

  @override
  String get debtCurrentLoadStat => 'தற்போதைய\nகடன் சுமை';

  @override
  String get debtRecoveryCapacityStat => 'மீட்பு\nதிறன்';

  @override
  String get debtIntensityStat => 'தீவிரம்';

  @override
  String get debtDefaultRiskStat => 'தவறிழைப்பு அபாயம்';

  @override
  String get debtProfileTitle => 'கடன் விவரம்';

  @override
  String get debtKarmaLabel => 'கர்மா';

  @override
  String get debtPersonalityLabel => 'ஆளுமை';

  @override
  String get debtPhaseLabel => 'கட்டம்';

  @override
  String get debtPrimaryCategoryLabel => 'முதன்மை வகை';

  @override
  String get debtWord => 'கடன்';

  @override
  String get debtYogasTitle => 'கடன் யோகங்கள்';

  @override
  String get debtCreatingLabel => 'கடன் உருவாக்கும்';

  @override
  String get debtClearingLabel => 'கடன் தீர்க்கும்';

  @override
  String get yearlyDebtTitle => 'வருடாந்திர கடன்';

  @override
  String get debtRepaymentTitle => 'திருப்பிச் செலுத்துதல்';

  @override
  String get debtDangerPeriodsTitle => 'ஆபத்தான காலங்கள்';

  @override
  String get debtDefaultPctStat => 'தவறிழைப்பு %';

  @override
  String get debtBankruptcyPctStat => 'திவால் %';

  @override
  String get debtChronicPctStat => 'நாள்பட்ட %';

  @override
  String get debtResilienceStat => 'தாங்கும் திறன்';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'மீட்பு: $pct% · காலவரிசை: $yearsஆண்டுகள்';
  }

  @override
  String get debtFreeWindowLabel => '🎯 கடனற்ற காலம்';

  @override
  String debtFreeYear(Object year) {
    return '$year ஆம் ஆண்டு';
  }

  @override
  String get legalScoresHeader => '⚖️ சட்ட மதிப்பெண்கள்';

  @override
  String get legalVulnerabilityStat => 'சட்ட\nபாதிப்பு';

  @override
  String get legalVictoryPotentialStat => 'வெற்றி\nவாய்ப்பு';

  @override
  String get legalConflictStat => 'மோதல்';

  @override
  String get legalResolutionStat => 'தீர்வு';

  @override
  String get legalProfileTitle => 'சட்ட விவரம்';

  @override
  String get legalKarmaTypeLabel => 'கர்மா வகை';

  @override
  String get legalConflictStyleLabel => 'மோதல் பாணி';

  @override
  String get legalStrategyLabel => 'உத்தி';

  @override
  String get legalCaseDurationLabel => 'வழக்கு காலம்';

  @override
  String get legalCurrentStatusLabel => 'தற்போதைய நிலை';

  @override
  String get legalWord => 'சட்டம்';

  @override
  String get legalYogasTitle => 'சட்ட யோகங்கள்';

  @override
  String get legalDisputePressureLabel => 'தகராறு அழுத்தம்';

  @override
  String get legalProtectionLabel => 'சட்ட பாதுகாப்பு';

  @override
  String get legalStressTrendTitle => 'சட்ட மன அழுத்தம்';

  @override
  String get legalVisibleEnemiesStat => 'வெளிப்படை எதிரிகள்';

  @override
  String get legalHiddenEnemiesStat => 'மறைமுக எதிரிகள்';

  @override
  String get legalCriminalRiskStat => 'குற்றவியல் அபாயம்';

  @override
  String get legalFalseAccusationStat => 'பொய் குற்றச்சாட்டு';

  @override
  String get legalContractKarmaTitle => 'ஒப்பந்த கர்மா';

  @override
  String get legalDocumentationLabel => 'ஆவணப்படுத்தல்';

  @override
  String get legalFinePrintAwareLabel => 'நுண் விவர விழிப்பு';

  @override
  String get legalNegotiationSkillLabel => 'பேச்சுவார்த்தை திறன்';

  @override
  String get legalSignatureCautionLabel => 'கையொப்ப எச்சரிக்கை';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'தாங்கும் திறன்: $pct/100';
  }

  @override
  String get legalVictoryWord => 'வெற்றி';

  @override
  String get legalAnalysisSuffix => 'பகுப்பாய்வு';

  @override
  String get legalAsPlaintiff => 'வாதியாக';

  @override
  String get legalAsDefendant => 'பிரதிவாதியாக';

  @override
  String get legalWinProbability => 'வெற்றி நிகழ்தகவு';

  @override
  String get legalDisputeWord => 'தகராறு';

  @override
  String get lifepathScoresHeader => '🌟 வாழ்க்கைப் பாதை மதிப்பெண்கள்';

  @override
  String get lifepathDharmaClarityStat => 'தர்ம\nதெளிவு';

  @override
  String get lifepathFortuneBaselineStat => 'அதிர்ஷ்ட\nஅடிப்படை';

  @override
  String get lifepathCoherenceStat => 'வாழ்க்கைப் பாதை\nஒருங்கிணைவு';

  @override
  String get lifepathKarmaStat => 'கர்மா';

  @override
  String get lifepathSpiritualStat => 'ஆன்மீகம்';

  @override
  String get lifepathFameStat => 'புகழ்';

  @override
  String get lifepathSoulContractTitle => 'ஆத்ம ஒப்பந்தம்';

  @override
  String get lifepathAtmakarakaLabel => 'ஆத்மகாரகன்';

  @override
  String get lifepathAkFocusLabel => 'AK கவனம்';

  @override
  String get lifepathSoulPurposeLabel => 'ஆத்ம நோக்கம்';

  @override
  String get lifepathLifeChapterLabel => 'வாழ்க்கை அத்தியாயம்';

  @override
  String get lifepathPrimaryDomainLabel => 'முதன்மை துறை';

  @override
  String get lifepathLeadershipStat => 'தலைமை';

  @override
  String get lifepathWisdomTeachStat => 'ஞானம்/கற்பித்தல்';

  @override
  String get lifepathServiceStat => 'சேவை';

  @override
  String get lifepathHealingStat => 'குணப்படுத்துதல்';

  @override
  String get lifepathFortuneYogasTitle => 'அதிர்ஷ்ட யோகங்கள்';

  @override
  String get lifepathLuckBlocksLabel => 'அதிர்ஷ்ட தடைகள்';

  @override
  String get lifepathFortuneBoostersLabel => 'அதிர்ஷ்ட ஊக்கிகள்';

  @override
  String get lifepathFortuneTrendTitle => 'அதிர்ஷ்ட போக்கு';

  @override
  String get lifepathGoldenWindowsTitle => 'பொன்னான காலங்கள் ★';

  @override
  String get lifepathTransformationTitle => 'மாற்றம்';

  @override
  String get lifepathMilestonesTitle => 'வாழ்க்கை மைல்கற்கள்';

  @override
  String get lifepathKarmicLessonsTitle => 'கர்ம பாடங்கள்';

  @override
  String get lifepathRahuGrowthLabel => 'ராகு வளர்ச்சி';

  @override
  String get lifepathKetuSurrenderLabel => 'கேது சரணாகதி';

  @override
  String get lifepathSaturnLessonLabel => 'சனி பாடம்';

  @override
  String get lifepathLifeDifficultyLabel => 'வாழ்க்கை கடினம்';

  @override
  String get lifepathSoulExperienceTitle => '★ ஆத்மா அனுபவிக்க வந்தது';

  @override
  String get lifepathBlessingsTitle => '● ஆசீர்வாதங்கள்';

  @override
  String get lifepathLifeWord => 'வாழ்க்கை';

  @override
  String get lifepathArchetypeSuffix => 'வடிவம்';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'நிறைவேற்றம்: $pct%';
  }

  @override
  String get lifepathDestinyVsWord => 'விதி எதிராக';

  @override
  String get lifepathFreeWillSuffix => 'சுதந்திர விருப்பம்';

  @override
  String get lifepathDestinyStat => 'விதி';

  @override
  String get lifepathFreeWillStat => 'சுதந்திர விருப்பம்';

  @override
  String get pastlifeScoresHeader => '🔮 முற்பிறவி மதிப்பெண்கள்';

  @override
  String get pastlifeSignatureStrengthStat => 'தனித்துவ\nபலம்';

  @override
  String get pastlifeCarryForwardStat => 'எடுத்துச்\nசெல்லல்';

  @override
  String get pastlifeMasteryPreservedStat => 'தேர்ச்சி\nபாதுகாக்கப்பட்டது';

  @override
  String get pastlifeUnfinishedStat => 'முடிக்கப்படாதது';

  @override
  String get pastlifeKarmicDebtStat => 'கர்ம கடன்';

  @override
  String get pastlifeProfileTitle => 'முற்பிறவி விவரம்';

  @override
  String get pastlifeThemeLabel => 'கருப்பொருள்';

  @override
  String get pastlifeProfessionLabel => 'தொழில்';

  @override
  String get pastlifeSocialStandingLabel => 'சமூக அந்தஸ்து';

  @override
  String get pastlifeRegionLabel => 'பகுதி';

  @override
  String get pastlifeSpiritualLevelLabel => 'ஆன்மீக நிலை';

  @override
  String get pastlifeGenderLabel => 'பாலினம்';

  @override
  String get pastlifeWealthLevelLabel => 'செல்வ நிலை';

  @override
  String get pastlifeFamilyRoleLabel => 'குடும்ப பங்கு';

  @override
  String get pastlifeSkillsCarriedTitle => '★ எடுத்துச் செல்லப்பட்ட திறன்கள்';

  @override
  String get pastlifeNaturalAttractionsTitle => '● இயற்கை ஈர்ப்புகள்';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ விளக்கமற்ற பயங்கள்';

  @override
  String get pastlifeMagneticPullsTitle => '→ காந்த இழுப்புகள்';

  @override
  String get pastlifeRelationshipStat => 'உறவு';

  @override
  String get pastlifeFinancialStat => 'நிதி';

  @override
  String get pastlifeServiceStat => 'சேவை';

  @override
  String get pastlifeDharmicStat => 'தர்மம்';

  @override
  String get pastlifeOnRelationsStat => 'உறவுகளில்';

  @override
  String get pastlifeOnCareerStat => 'தொழிலில்';

  @override
  String get pastlifeOnHealthStat => 'ஆரோக்கியத்தில்';

  @override
  String get pastlifeOnSpiritualStat => 'ஆன்மீகத்தில்';

  @override
  String get pastlifeKarmicResolutionTitle => 'கர்ம தீர்வு';

  @override
  String get pastlifePrimaryPathLabel => 'முதன்மை பாதை';

  @override
  String get pastlifeSecondaryPathLabel => 'இரண்டாம் பாதை';

  @override
  String get pastlifeClearingProgressLabel => 'தீர்வு முன்னேற்றம்';

  @override
  String get pastlifeRemainingWorkLabel => 'மீதமுள்ள பணி';

  @override
  String get pastlifeDebtTimelineLabel => 'கடன் காலவரிசை';

  @override
  String get pastlifeMemoryAccessStat => 'நினைவு அணுகல்';

  @override
  String get pastlifeDreamVisitsStat => 'கனவு வருகைகள்';

  @override
  String get pastlifeDejaVuStat => 'டெஜா வூ';

  @override
  String get pastlifeRegressionFitStat => 'பின்னடைவு பொருத்தம்';

  @override
  String get pastlifeActivationTitle => 'முற்பிறவி செயல்பாடு';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'முதிர்ச்சி: $maturity · நிலை: $status';
  }

  @override
  String get pastlifeKetuWord => 'கேது';

  @override
  String get pastlifePastMasterySuffix => 'முற்பிறவி தேர்ச்சி';

  @override
  String get pastlifeKetuMasteredLabel => 'கேது · நீங்கள் தேர்ச்சி பெற்றது';

  @override
  String get pastlifeRahuWord => 'ராகு';

  @override
  String get pastlifeFutureGrowthSuffix => 'எதிர்கால வளர்ச்சி';

  @override
  String get pastlifeRahuPullsLabel => 'ராகு · உங்களை முன்னோக்கி இழுப்பது';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ நிழல்: $shadow';
  }

  @override
  String get mentalScoresHeader => '🧠 மன மதிப்பெண்கள்';

  @override
  String get mentalStabilityStat => 'மன\nநிலைத்தன்மை';

  @override
  String get mentalEmotionalBaselineStat => 'உணர்ச்சி\nஅடிப்படை';

  @override
  String get mentalResilienceStat => 'தாங்கும் திறன்';

  @override
  String get mentalAnxietyStat => 'பதட்டம்';

  @override
  String get mentalDepressionStat => 'மனச்சோர்வு';

  @override
  String get mentalRegulationStat => 'கட்டுப்பாடு';

  @override
  String get mentalProfileTitle => 'மன விவரம்';

  @override
  String get mentalConstitutionLabel => 'உடல்நிலை அமைப்பு';

  @override
  String get mentalStressDriverLabel => 'மன அழுத்த காரணி';

  @override
  String get mentalStabilityAnchorLabel => 'நிலைத்தன்மை நங்கூரம்';

  @override
  String get mentalStressResponseLabel => 'மன அழுத்த பதில்';

  @override
  String get mentalAttachmentStyleLabel => 'பிணைப்பு பாணி';

  @override
  String get mentalBurnoutStageLabel => 'சோர்வு கட்டம்';

  @override
  String get mentalWord => 'மனம்';

  @override
  String get mentalYogasTitle => 'மன யோகங்கள்';

  @override
  String get mentalStressPressureLabel => 'மன அழுத்த சுமை';

  @override
  String get mentalWellnessTrendTitle => 'நல்வாழ்வு போக்கு';

  @override
  String get mentalHealthyCopingTitle => '✓ ஆரோக்கியமான சமாளிப்பு';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ ஆரோக்கியமற்ற அபாயங்கள்';

  @override
  String get mentalRecommendedAlternativesTitle =>
      '✦ பரிந்துரைக்கப்பட்ட மாற்றுகள்';

  @override
  String get mentalSleepQualityStat => 'தூக்க தரம்';

  @override
  String get mentalSocialSupportStat => 'சமூக ஆதரவு';

  @override
  String get mentalBurnoutVulnStat => 'சோர்வு பாதிப்பு';

  @override
  String get mentalSelfAwarenessStat => 'சுய விழிப்புணர்வு';

  @override
  String get mentalAnxietyWord => 'பதட்டம்';

  @override
  String get mentalTypesSuffix => 'வகைகள்';

  @override
  String get mentalTherapyWord => 'சிகிச்சை';

  @override
  String get mentalModalityFitSuffix => 'முறை பொருத்தம்';

  @override
  String get characterScoresHeader => '🔍 குணநல மதிப்பெண்கள்';

  @override
  String get characterStrengthStat => 'குணநல\nபலம்';

  @override
  String get characterIntegrityStat => 'நேர்மை';

  @override
  String get characterResilienceStat => 'தாங்கும் திறன்';

  @override
  String get characterAwarenessStat => 'விழிப்புணர்வு';

  @override
  String get characterStabilityStat => 'நிலைத்தன்மை';

  @override
  String get characterEthicsStat => 'நெறிமுறை';

  @override
  String get characterSurfacePersonalityTitle => 'மேற்பரப்பு ஆளுமை';

  @override
  String get characterLagnaLabel => 'லக்னம்';

  @override
  String get characterConstitutionLabel => 'உடல்நிலை அமைப்பு';

  @override
  String get characterNakshatraLabel => 'நக்ஷத்திரம்';

  @override
  String get characterDeityLabel => 'தெய்வம்';

  @override
  String get characterMoonManasTitle => 'சந்திரன் மனஸ்';

  @override
  String get characterSignLabel => 'ராசி';

  @override
  String get characterHouseLabel => 'வீடு';

  @override
  String get characterWarmthStat => 'அன்பு';

  @override
  String get characterEmpathyStat => 'பரிவு';

  @override
  String get characterLoyaltyStat => 'விசுவாசம்';

  @override
  String get characterBoundariesStat => 'எல்லைகள்';

  @override
  String get characterDharmaStat => 'தர்மம்';

  @override
  String get characterTruthStat => 'உண்மை';

  @override
  String get characterCompassionStat => 'கருணை';

  @override
  String get characterGenerosityStat => 'தாராள மனப்பான்மை';

  @override
  String get characterSignatureVirtuesTitle => '★ தனித்துவ நற்பண்புகள்';

  @override
  String get characterNaturalTalentsTitle => '● இயற்கை திறமைகள்';

  @override
  String get characterShadowPatternsTitle => '⚠ நிழல் வடிவங்கள்';

  @override
  String get characterYogasTitle => 'குணநல யோகங்கள்';

  @override
  String get characterTestsLabel => 'சோதனைகள்';

  @override
  String get characterGiftsLabel => 'கொடைகள்';

  @override
  String get characterSelfAwareEiStat => 'சுய விழிப்பு EI';

  @override
  String get characterSelfRegulateStat => 'சுய கட்டுப்பாடு';

  @override
  String get characterEmpathyEiStat => 'பரிவு EI';

  @override
  String get characterSocialSkillsStat => 'சமூக திறன்கள்';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'உணர்தல்: $pct%';
  }

  @override
  String get characterAtmakarakaWord => 'ஆத்மகாரகன்';

  @override
  String get characterSoulSignatureSuffix => 'ஆத்ம தனித்துவம்';

  @override
  String get characterAtmakarakaLabel => 'ஆத்மகாரகன்';

  @override
  String get characterGunaWord => 'குணம்';

  @override
  String get characterProfileSuffix => 'விவரம்';

  @override
  String get characterSattvaLabel => 'சத்துவம்';

  @override
  String get characterRajasLabel => 'ரஜஸ்';

  @override
  String get characterTamasLabel => 'தமஸ்';

  @override
  String get healthScoresHeader => '🏥 ஆரோக்கிய மதிப்பெண்கள்';

  @override
  String get healthVitalityStat => 'உயிர்ச்சக்தி';

  @override
  String get healthImmunityStat => 'நோய் எதிர்ப்பு';

  @override
  String get healthRecoveryStat => 'மீட்பு';

  @override
  String get healthMentalStat => 'மனநிலை';

  @override
  String get healthStressTolStat => 'அழுத்த சகிப்பு';

  @override
  String get healthYogasTitle => 'ஆரோக்கிய யோகங்கள்';

  @override
  String get healthDiseasePressureLabel => 'நோய் அழுத்தம்';

  @override
  String get healthTrendTitle => 'ஆரோக்கிய போக்கு';

  @override
  String get healthRecoveryWindowsTitle => 'மீட்பு காலங்கள்';

  @override
  String get healthCautionPeriodsTitle => 'எச்சரிக்கை காலங்கள்';

  @override
  String get healthFertilityStat => 'கருவளம்';

  @override
  String get healthBurnoutRiskStat => 'சோர்வு அபாயம்';

  @override
  String get healthAddictionVulnStat => 'அடிமை பாதிப்பு';

  @override
  String get healthWorkLifeBalStat => 'வேலை-வாழ்க்கை சமநிலை';

  @override
  String get healthAyurvedicWord => 'ஆயுர்வேத';

  @override
  String get healthConstitutionSuffix => 'உடல்நிலை அமைப்பு';

  @override
  String get healthBodyWord => 'உடல்';

  @override
  String get healthSystemMapSuffix => 'அமைப்பு வரைபடம்';

  @override
  String get healthBodyZoneWord => 'உடல் பகுதி';

  @override
  String get healthVulnerabilitySuffix => 'பாதிப்பு';

  @override
  String get healthDiseaseWord => 'நோய்';

  @override
  String get healthSusceptibilitySuffix => 'தாக்குதல் வாய்ப்பு';

  @override
  String get healthLifestyleFactorsTitle => 'வாழ்க்கை முறை காரணிகள்';

  @override
  String get healthSleepDisciplineLabel => 'தூக்க ஒழுங்கு';

  @override
  String get healthDietDisciplineLabel => 'உணவு ஒழுங்கு';

  @override
  String get healthExerciseNeedLabel => 'உடற்பயிற்சி தேவை';

  @override
  String get healthSunlightNeedLabel => 'சூரிய ஒளி தேவை';

  @override
  String get healthSocialTypeLabel => 'சமூக வகை';

  @override
  String get healthHealingSpeedLabel => 'குணமாகும் வேகம்';

  @override
  String get wealthScoresHeader => '💰 செல்வ மதிப்பெண்கள்';

  @override
  String get wealthStrengthStat => 'செல்வ\nபலம்';

  @override
  String get wealthAccumulationStat => 'சேர்ப்பு';

  @override
  String get wealthIncomeFlowStat => 'வருமான\nஓட்டம்';

  @override
  String get wealthSustainStat => 'நிலைத்தல்';

  @override
  String get wealthMultiStreamStat => 'பல ஆதாரம்';

  @override
  String get wealthRetentionStat => 'தக்கவைப்பு';

  @override
  String get wealthWord => 'செல்வம்';

  @override
  String get wealthYogasTitle => 'செல்வ யோகங்கள்';

  @override
  String get wealthDrainsLabel => 'வடிகால்கள்';

  @override
  String get wealthBoostersLabel => 'ஊக்கிகள்';

  @override
  String get wealthYearlyTrendTitle => 'வருடாந்திர போக்கு';

  @override
  String get wealthGrowthTitle => 'செல்வ வளர்ச்சி';

  @override
  String get wealthCashPressureTitle => 'பணப் பற்றாக்குறை அழுத்தம்';

  @override
  String get wealthMoneyPersonalityTitle => 'பண ஆளுமை';

  @override
  String get wealthTypeLabel => 'செல்வ வகை';

  @override
  String get wealthRiskAppetiteLabel => 'அபாய விருப்பம்';

  @override
  String get wealthInvestmentStyleLabel => 'முதலீட்டு பாணி';

  @override
  String get wealthMoneyPersonalityLabel => 'பண ஆளுமை';

  @override
  String get wealthSpendingLabel => 'செலவு';

  @override
  String get wealthDebtProbStat => 'கடன் நிகழ்தகவு %';

  @override
  String get wealthInheritanceStat => 'வாரிசு %';

  @override
  String get wealthSuddenGainsStat => 'திடீர் லாபம் %';

  @override
  String get wealthSpouseBoostStat => 'வாழ்க்கைத்துணை ஊக்கம் %';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'வெற்றி நிகழ்தகவு: $pct%';
  }

  @override
  String get wealthLifetimeClassLabel => 'வாழ்நாள் செல்வ வகுப்பு';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'முதன்மை: $value';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'உச்சம்: $value';
  }

  @override
  String get wealthIncomeWord => 'வருமானம்';

  @override
  String get wealthSourcesSuffix => 'ஆதாரங்கள்';

  @override
  String get wealthInvestmentWord => 'முதலீடு';

  @override
  String get wealthMixSuffix => 'கலவை';

  @override
  String wealthDrivenByLabel(Object planet) {
    return '$planet இயக்கும்';
  }

  @override
  String get marriageScoresHeader => '💒 திருமண மதிப்பெண்கள்';

  @override
  String get marriageOverallStat => 'ஒட்டுமொத்த\nதிருமணம்';

  @override
  String get marriageHarmonyStat => 'தாம்பத்திய\nஇணக்கம்';

  @override
  String get marriageDomesticStabilityStat => 'இல்லற\nநிலைத்தன்மை';

  @override
  String get marriageLongevityStat => 'நீடித்தல்';

  @override
  String get marriageSatisfactionStat => 'திருப்தி';

  @override
  String get marriageClarityStat => 'தெளிவு';

  @override
  String get marriageWindowsTitle => 'திருமண காலங்கள்';

  @override
  String get marriagePhasesTitle => 'திருமண கட்டங்கள்';

  @override
  String get marriageInLawRelationsStat => 'மாமியார் உறவுகள்';

  @override
  String get marriageFamilyHarmonyStat => 'குடும்ப இணக்கம்';

  @override
  String get marriageFertilityStat => 'கருவளம்';

  @override
  String get marriageHomeOwnershipStat => 'வீட்டு உரிமை';

  @override
  String get marriageDivorceRiskStat => 'விவாகரத்து அபாயம்';

  @override
  String get marriageInfidelityStat => 'விசுவாசமின்மை';

  @override
  String get marriageConflictStat => 'மோதல்';

  @override
  String get marriageDistanceStat => 'தூரம்';

  @override
  String get marriageSeekInPartnerTitle => '★ துணையில் தேடுங்கள்';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ துணையில் தவிர்க்கவும்';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'உணர்தல்: $pct%';
  }

  @override
  String get marriageDarakarakaWord => 'தாராகாரகன்';

  @override
  String get marriageSpouseKarakaSuffix => 'வாழ்க்கைத்துணை காரகன்';

  @override
  String get marriageDarakarakaDkLabel => 'தாராகாரகன் (DK)';

  @override
  String get marriage7thWord => '7ஆம்';

  @override
  String get marriageSignLabel => 'ராசி';

  @override
  String get marriageLordInLabel => 'அதிபதி இருப்பது';

  @override
  String get marriageStrengthLabel => 'பலம்';

  @override
  String get marriageSpouseWord => 'வாழ்க்கைத்துணை';

  @override
  String get marriageProfileSuffix => 'விவரம்';

  @override
  String get marriageSpouseTraitsTitle => '★ வாழ்க்கைத்துணை பண்புகள்';

  @override
  String get marriageLikelyProfessionsTitle => '● சாத்தியமான தொழில்கள்';

  @override
  String get marriageHarmonyWord => 'இணக்கம்';

  @override
  String get marriageRadarSuffix => 'ரேடார்';

  @override
  String get marriagePhysicalLabel => 'உடல்';

  @override
  String get marriageSharedValuesLabel => 'பகிர்ந்த மதிப்புகள்';

  @override
  String get marriageConflictResolutionLabel => 'மோதல் தீர்வு';

  @override
  String get marriageMangalDoshLabel => '⚠ மங்கள் தோஷம்';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'தீவிரம்: $value';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'நீக்கம்: $value';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'நவாம்சம்';

  @override
  String get multiChartTitleChild => 'குழந்தை';

  @override
  String get multiChartTitleLove => 'காதல்';

  @override
  String get multiChartTitleKarma => 'கர்மா';

  @override
  String get multiChartTitleDefault => 'பல-ஜாதகம்';

  @override
  String get multiChartSuffixProbability => 'நிகழ்தகவு';

  @override
  String get multiChartSuffixCompatibility => 'பொருத்தம்';

  @override
  String get multiChartSuffixLinkage => 'இணைப்பு';

  @override
  String get multiChartSuffixReport => 'அறிக்கை';

  @override
  String get multiChartParticipantsLabel => 'பங்கேற்பாளர்கள்';

  @override
  String get multiChartAnalysisWord => 'பகுப்பாய்வு';

  @override
  String get multiChartConfidenceSuffix => 'நம்பகத்தன்மை';

  @override
  String get multiChartQualityBadge => 'தரம்';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'இந்த வேத ஜோதிட அறிக்கையை பகுப்பாய்வு செய்து விரிவான பார்வைகளை வழங்கவும்:\n\n$formatted';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'இதோ ஒரு வேத ஜோதிட நிபுணர் அறிக்கை. தயவுசெய்து இதை முழுமையாக பகுப்பாய்வு செய்து செயல்படுத்தக்கூடிய பார்வைகளை வழங்கவும்:\n\n$formatted';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'இந்த வேத ஜோதிட பகுப்பாய்வை மதிப்பாய்வு செய்து முக்கிய கண்டுபிடிப்புகளை எளிய மொழியில் விளக்கவும்:\n\n$formatted';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return '$labelக்கு நகலெடுக்கப்பட்டது!';
  }

  @override
  String get childProbTitle1 => 'குழந்தை';

  @override
  String get childProbTitle2 => 'நிகழ்தகவு';

  @override
  String get childNumberOfChildrenHeader1 => 'எண்ணிக்கை';

  @override
  String get childNumberOfChildrenHeader2 => 'குழந்தைகள்';

  @override
  String get childTimingHeader1 => 'காலம்';

  @override
  String get childTimingHeader2 => 'மூல தசை';

  @override
  String get child5thHouseHeader1 => '5ஆம் வீடு';

  @override
  String get analysisWord => 'பகுப்பாய்வு';

  @override
  String get jupiterWord => 'குரு';

  @override
  String get childD7Header1 => 'D7 சப்தாம்சம்';

  @override
  String get childBeejaHeader1 => 'பீஜ & க்ஷேத்ர';

  @override
  String get childBeejaHeader2 => 'ஸ்புடம்';

  @override
  String get childDoshaHeader1 => 'தோஷம்';

  @override
  String get childVedicHeader1 => 'வேத';

  @override
  String get childVedicHeader2 => 'பரிகாரங்கள்';

  @override
  String get progenyProbabilityLabel => 'சந்ததி நிகழ்தகவு';

  @override
  String get favorableWindowsLabel => 'சாதகமான காலங்கள்';

  @override
  String get partnerOneLabel => 'துணை 1';

  @override
  String get partnerTwoLabel => 'துணை 2';

  @override
  String get moonSignLabel => 'சந்திர ராசி';

  @override
  String get lordInDusthana => 'அதிபதி துஷ்டானத்தில்';

  @override
  String get lordStrengthLabel => 'அதிபதி பலம்';

  @override
  String get houseStrengthLabel => 'வீட்டு பலம்';

  @override
  String get dignityLabel => 'பலம்';

  @override
  String get directBadge => 'நேரடி';

  @override
  String get notCombustBadge => 'எரிப்பு இல்லை';

  @override
  String get in5thHouseBadge => '5ஆம் வீட்டில்';

  @override
  String get aspects5thBadge => '5ஐ பார்க்கிறது';

  @override
  String get no5thConnectionBadge => '5ஆம் தொடர்பு இல்லை';

  @override
  String jupiterInSignHeading(String sign) {
    return '$sign இல் குரு';
  }

  @override
  String get d7LagnaLabel => 'D7 லக்னம்';

  @override
  String get d7FifthSignLabel => 'D7 5ஆம் ராசி';

  @override
  String get d7FifthLordLabel => 'D7 5ஆம் அதிபதி';

  @override
  String get jupiterInD7Label => 'D7 இல் குரு';

  @override
  String get jupiterDignityLabel => 'குரு பலம்';

  @override
  String get d7StrengthLabel => 'D7 பலம்';

  @override
  String get yesWord => 'ஆம்';

  @override
  String get noWord => 'இல்லை';

  @override
  String get beejaSphutaTitle => 'பீஜ ஸ்புடம்';

  @override
  String get kshetraSphutaTitle => 'க்ஷேத்ர ஸ்புடம்';

  @override
  String get degreeLabel => 'பாகை';

  @override
  String get signLordLabel => 'ராசி அதிபதி';

  @override
  String get presentInLabel => 'இருப்பது';

  @override
  String get netPenaltyLabel => 'நிகர அபராதம்';

  @override
  String get remedyGemstone => 'ரத்தின பரிகாரங்கள்';

  @override
  String get remedyMantra => 'மந்திர பரிகாரங்கள்';

  @override
  String get remedyRitual => 'சடங்கு பரிகாரங்கள்';

  @override
  String get remedyLifestyle => 'வாழ்க்கை முறை பரிகாரங்கள்';

  @override
  String get remedyCharitable => 'தான பரிகாரங்கள்';

  @override
  String copiedForName(String name) {
    return '$nameக்கு நகலெடுக்கப்பட்டது!';
  }

  @override
  String get mahadashaLabel => 'மகாதசை';

  @override
  String get mdPeriodLabel => 'MD காலம்';

  @override
  String get antardashaLabel => 'அந்தர்தசை';

  @override
  String get adPeriodLabel => 'AD காலம்';

  @override
  String get pratyantardashaLabel => 'பிரத்யந்தர்தசை';

  @override
  String get favorabilityLabel => 'சாதகத்தன்மை';

  @override
  String factorPrefix(String factor) {
    return 'காரணி: $factor';
  }

  @override
  String appliesToLabel(String value) {
    return 'பொருந்துவது: $value';
  }

  @override
  String get qualityTag => 'தரம்';

  @override
  String get reliabilityVeryHigh => 'மிக உயர் நம்பகத்தன்மை';

  @override
  String get reliabilityGuidanceLevel => 'வழிகாட்டி நிலை வாசிப்பு';

  @override
  String get karmaLinkTitle1 => 'கர்மா';

  @override
  String get karmaLinkTitle2 => 'இணைப்பு';

  @override
  String get karmaFoundationHeader1 => 'கர்ம';

  @override
  String get karmaFoundationHeader2 => 'அடித்தளம்';

  @override
  String get karmaPairwiseHeader1 => 'இணை வாரியான';

  @override
  String get karmaPairwiseHeader2 => 'இணைப்புகள்';

  @override
  String get karmaGroupHeader1 => 'குழு';

  @override
  String get karmaGroupHeader2 => 'வடிவம்';

  @override
  String get karmaPastLifeHeader1 => 'முற்பிறவி';

  @override
  String get karmaPastLifeHeader2 => 'இலக்குகள்';

  @override
  String get karmaCurrentLifeHeader1 => 'தற்பிறவி';

  @override
  String get karmaCurrentLifeHeader2 => 'கற்றல்';

  @override
  String get karmaDebtsHeader2 => 'கடன்கள்';

  @override
  String get karmaMoolaDashaHeader1 => 'மூல தசை';

  @override
  String get karmaMoolaDashaHeader2 => 'காலம்';

  @override
  String get karmaDeepAuditHeader1 => 'ஆழமான தணிக்கை';

  @override
  String get karmaDeepAuditHeader2 => 'அட்டவணை';

  @override
  String get karmaHeroLabel => 'முற்பிறவி கர்ம இணைப்பு';

  @override
  String get karmaKetuMastery => 'கேது தேர்ச்சி';

  @override
  String get nakshatraLabel => 'நக்ஷத்திரம்';

  @override
  String get deityLabel => 'தெய்வம்';

  @override
  String get masteryScoreLabel => 'தேர்ச்சி மதிப்பெண்';

  @override
  String get karmaRahuGrowth => 'ராகு வளர்ச்சி';

  @override
  String get growthScoreLabel => 'வளர்ச்சி மதிப்பெண்';

  @override
  String get karmaAtmakaraka => 'ஆத்மகாரகன்';

  @override
  String get karmaSaturnKarma => 'சனி கர்மா';

  @override
  String get karma12thHouse => '12ஆம் வீடு';

  @override
  String get karma9thHousePunya => '9ஆம் வீடு புண்ணியம்';

  @override
  String get bhavaScoreLabel => 'பாவ மதிப்பெண்';

  @override
  String get karmaD60Signature => 'D60 தனித்துவம்';

  @override
  String get depthScoreLabel => 'ஆழ மதிப்பெண்';

  @override
  String get linkageStrengthLabel => 'இணைப்பு பலம்';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'இணைப்பு காரணிகள் ($count செயலில்)';
  }

  @override
  String get factorColumnLabel => 'காரணி';

  @override
  String get weightColumnLabel => 'எடை';

  @override
  String get meaningColumnLabel => 'பொருள்';

  @override
  String get statusColumnLabel => 'நிலை';

  @override
  String get karmaPastLifeConnection => 'முற்பிறவி தொடர்பு';

  @override
  String get karmaCurrentLifeDynamic => 'தற்பிறவி இயக்கம்';

  @override
  String get karmaWhatTheyTeach => 'அவர்கள் ஒருவருக்கொருவர் கற்பிப்பது';

  @override
  String get karmaGroupThemeHeader => 'குழு கர்ம கருப்பொருள்';

  @override
  String get karmaSharedSettingHeader => 'பகிர்ந்த முற்பிறவி சூழல்';

  @override
  String get karmaCollectiveKetuHeader => 'கூட்டு கேது வடிவம்';

  @override
  String get karmaCollectiveRahuHeader => 'கூட்டு ராகு வடிவம்';

  @override
  String get housesPrefixLabel => 'வீடுகள்: ';

  @override
  String get signsPrefixLabel => 'ராசிகள்: ';

  @override
  String get karmicCohesionLabel => 'கர்ம ஒருங்கிணைவு';

  @override
  String get karmaGroupSoulContractHeader => 'குழு ஆத்ம ஒப்பந்தம்';

  @override
  String get goalLabel => 'இலக்கு';

  @override
  String get karmaSharedGoalHeader => 'பகிர்ந்த முற்பிறவி இலக்கு';

  @override
  String get howToGrowHeader => 'எப்படி வளர்வது';

  @override
  String moolaDashaPrefix(String value) {
    return 'மூல தசை: $value';
  }

  @override
  String get karmaSharedLessonHeader => 'பகிர்ந்த குழு பாடம்';

  @override
  String get karmaMutualTeachingHeader => 'பரஸ்பர கற்பித்தல் வரைபடம்';

  @override
  String get karmaTeachingDynamicsPlaceholder =>
      'கர்ம தொடர்புகள் ஆழமடையும் போது கற்பித்தல் இயக்கங்கள் வெளிப்படும்.';

  @override
  String get typeFieldLabel => 'வகை';

  @override
  String get basisFieldLabel => 'அடிப்படை';

  @override
  String get resolutionPathHeader => 'தீர்வு பாதை';

  @override
  String dashaTimingPrefix(String value) {
    return 'தசை காலம்: $value';
  }

  @override
  String get mutualDebtsHeader => 'பரஸ்பர கடன்கள்';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'தேதிகள்';

  @override
  String get groupKarmicWindowHeader => 'குழு கர்ம காலம்';

  @override
  String parametersAuditedHeading(int count) {
    return '$count அளவுருக்கள் தணிக்கை செய்யப்பட்டன';
  }

  @override
  String get valuePrefixLabel => 'மதிப்பு: ';

  @override
  String weightPrefix(String value) {
    return 'எடை: $value';
  }

  @override
  String get loveCompatTitle1 => 'காதல்';

  @override
  String get loveCompatTitle2 => 'பொருத்தம்';

  @override
  String get loveAttractionHeader1 => 'ஈர்ப்பு &';

  @override
  String get loveAttractionHeader2 => 'ரசவாதம்';

  @override
  String get loveEmotionalHeader1 => 'உணர்ச்சி';

  @override
  String get loveEmotionalHeader2 => 'இணக்கம்';

  @override
  String get loveMentalHeader1 => 'மன';

  @override
  String get loveMentalHeader2 => 'ஒற்றுமை';

  @override
  String get lovePassionHeader1 => 'ஆர்வம் &';

  @override
  String get lovePassionHeader2 => 'உடல்';

  @override
  String get loveLongtermHeader1 => 'நீண்டகால';

  @override
  String get loveKarmicHeader1 => 'கர்ம காதல்';

  @override
  String get loveKarmicHeader2 => 'பிணைப்பு';

  @override
  String get loveChallengesHeader1 => 'சவால்கள் &';

  @override
  String get loveChallengesHeader2 => 'உராய்வு';

  @override
  String get loveTimingHeader1 => 'காதல் காலம்';

  @override
  String get loveRelationshipHeader1 => 'உறவு';

  @override
  String get loveRelationshipHeader2 => 'இயக்கங்கள்';

  @override
  String get loveRemediesHeader1 => 'பரிகாரங்கள் &';

  @override
  String get loveRemediesHeader2 => 'வழிகாட்டல்';

  @override
  String get loveCompatHeroLabel => 'காதல் பொருத்தம்';

  @override
  String get loveChipAttraction => 'ஈர்ப்பு';

  @override
  String get loveChipPassion => 'ஆர்வம்';

  @override
  String get loveChipChallenge => 'சவால்';

  @override
  String get venusSignLabel => 'சுக்கிர ராசி';

  @override
  String get attractionScoreLabel => 'ஈர்ப்பு மதிப்பெண்';

  @override
  String get activeContactsLabel => 'செயலில் உள்ள தொடர்புகள்';

  @override
  String get magneticPullLabel => 'காந்த இழுப்பு';

  @override
  String get initialAttractionLabel => 'ஆரம்ப ஈர்ப்பு';

  @override
  String get emotionalScoreLabel => 'உணர்ச்சி மதிப்பெண்';

  @override
  String get elementMatchLabel => 'தனிமப் பொருத்தம்';

  @override
  String get harmonyLabel => 'இணக்கம்';

  @override
  String get kootaYoni => 'யோனி';

  @override
  String get kootaGana => 'கண';

  @override
  String get kootaTara => 'தாரா';

  @override
  String get doshaPresentBadge => 'தோஷம் உள்ளது';

  @override
  String get noDoshaBadge => 'தோஷம் இல்லை';

  @override
  String get axisLabel => 'அச்சு';

  @override
  String get mentalScoreLabel => 'மன மதிப்பெண்';

  @override
  String get mercuryDynamicsLabel => 'புத இயக்கங்கள்';

  @override
  String get communicationStyleLabel => 'தொடர்பு பாணி பொருத்தம்';

  @override
  String get intellectualConnectionLabel => 'அறிவுசார் தொடர்பு';

  @override
  String get passionScoreLabel => 'ஆர்வ மதிப்பெண்';

  @override
  String get marsVenusLabel => 'செவ்வாய்-சுக்கிர தொடர்பு';

  @override
  String get physicalChemistryLabel => 'உடல் ரசவாதம்';

  @override
  String get yoniCompatLabel => 'யோனி பொருத்தம்';

  @override
  String get longtermScoreLabel => 'நீண்டகால மதிப்பெண்';

  @override
  String get seventhHouseSynastryLabel => '7ஆம் வீடு ஒப்பீடு';

  @override
  String get commitmentPotentialLabel => 'அர்ப்பணிப்பு வாய்ப்பு';

  @override
  String get jupiterBlessingLabel => 'குரு ஆசீர்வாதம்';

  @override
  String get d9NavamsaResonanceLabel => 'D9 நவாம்ச ஒத்திசைவு';

  @override
  String get saturnLongevityLabel => 'சனி நீடித்தல்';

  @override
  String get karmicScoreLabel => 'கர்ம மதிப்பெண்';

  @override
  String get darakarakaLinkLabel => 'தாராகாரக இணைப்பு';

  @override
  String get sourceLabel => 'ஆதாரம்';

  @override
  String get emotionalGiverReceiverLabel => 'உணர்ச்சி வழங்குபவர் / பெறுபவர்';

  @override
  String get powerBalanceLabel => 'அதிகார சமநிலை';

  @override
  String get growthDynamicLabel => 'வளர்ச்சி இயக்கம்';

  @override
  String get addressesLabel => 'தீர்க்கிறது';

  @override
  String get loveScoresLabel => 'காதல் மதிப்பெண்கள்';

  @override
  String get loveCapacityLabel => 'காதல்\nதிறன்';

  @override
  String get emotionalAvailabilityLabel => 'உணர்ச்சி\nகிடைப்பு';

  @override
  String get romanticAttractionLabel => 'காதல்\nஈர்ப்பு';

  @override
  String get commitmentWord => 'அர்ப்பணிப்பு';

  @override
  String get intimacyWord => 'நெருக்கம்';

  @override
  String get fidelityWord => 'விசுவாசம்';

  @override
  String get loveProfileTitle => 'காதல் விவரம்';

  @override
  String get loveStyleLabel => 'காதல் பாணி';

  @override
  String get attractionStyleLabel => 'ஈர்ப்பு பாணி';

  @override
  String get lovePathLabel => 'காதல் பாதை';

  @override
  String get currentPhaseLabel => 'தற்போதைய கட்டம்';

  @override
  String get commitmentStyleLabel => 'அர்ப்பணிப்பு பாணி';

  @override
  String get loveWord => 'காதல்';

  @override
  String get karakasWord => 'காரகர்கள்';

  @override
  String get attractedToLabel => 'ஈர்க்கப்படுவது';

  @override
  String get whatPartnerSeesLabel => 'துணை பார்ப்பது';

  @override
  String get romancePatternTitle => 'காதல் வடிவம்';

  @override
  String get firstLoveAgeLabel => 'முதல் காதல் வயது';

  @override
  String get relationshipCountLabel => 'உறவுகளின் எண்ணிக்கை';

  @override
  String get avgDurationLabel => 'சராசரி காலம்';

  @override
  String get breakupTriggerLabel => 'பிரிவு தூண்டுதல்';

  @override
  String get heartbreakRecoveryLabel => 'இதயவலி மீட்பு';

  @override
  String get loveTrendTitle => 'காதல் போக்கு';

  @override
  String get newLoveWindowsTitle => 'புதிய காதல் காலங்கள்';

  @override
  String get loveBlocksTitle => 'காதல் தடைகள்';

  @override
  String get activeBlocksLabel => 'செயலில் உள்ள தடைகள்';

  @override
  String get loveMarriagePctLabel => 'காதல் திருமணம் %';

  @override
  String get heartbreakVulnLabel => 'இதயவலி பாதிப்பு';

  @override
  String get selfSabotageLabel => 'சுய நாசம்';

  @override
  String get emotionalIqLabel => 'உணர்ச்சி IQ';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'நிறைவேற்றம்: $pct%';
  }

  @override
  String get languagesWord => 'மொழிகள்';

  @override
  String get givesLabel => 'கொடுக்கிறது';

  @override
  String get receivesLabel => 'பெறுகிறது';

  @override
  String get idealWord => 'சிறந்த';

  @override
  String get partnerWord => 'துணை';

  @override
  String get seekTheseTraitsLabel => 'இந்த பண்புகளை தேடுங்கள்';

  @override
  String get dealbreakersLabel => 'ஏற்க முடியாதவை';

  @override
  String get propertyScoresLabel => 'சொத்து மதிப்பெண்கள்';

  @override
  String get acquisitionCapacityLabel => 'கையகப்படுத்தும்\nதிறன்';

  @override
  String get homeOwnershipPctLabel => 'வீட்டு\nஉரிமை %';

  @override
  String get reWealthPotentialLabel => 'ரியல் எஸ்டேட் செல்வ\nவாய்ப்பு';

  @override
  String get rentalWord => 'வாடகை';

  @override
  String get vehiclesWord => 'வாகனங்கள்';

  @override
  String get landPctLabel => 'நிலம் %';

  @override
  String get propertyProfileTitle => 'சொத்து விவரம்';

  @override
  String get karmaTypeLabel => 'கர்மா வகை';

  @override
  String get environmentLabel => 'சூழல்';

  @override
  String get styleLabel => 'பாணி';

  @override
  String get sizeLabel => 'அளவு';

  @override
  String get locationLabel => 'இடம்';

  @override
  String get actionNext12mLabel => 'அடுத்த 12 மாத நடவடிக்கை';

  @override
  String get propertyWord => 'சொத்து';

  @override
  String get propertyYogasTitle => 'சொத்து யோகங்கள்';

  @override
  String get drainsLabel => 'வடிகால்கள்';

  @override
  String get boostersLabel => 'ஊக்கிகள்';

  @override
  String get propertyTrendTitle => 'சொத்து போக்கு';

  @override
  String get buyingWindowsTitle => 'வாங்கும் காலங்கள்';

  @override
  String get constructionWindowsTitle => 'கட்டுமான காலங்கள்';

  @override
  String get maternalInherPctLabel => 'தாய்வழி வாரிசு %';

  @override
  String get paternalInherPctLabel => 'தந்தைவழி வாரிசு %';

  @override
  String get multiHomePctLabel => 'பல வீடு %';

  @override
  String get investmentPctLabel => 'முதலீடு %';

  @override
  String get vehicleProfileTitle => 'வாகன விவரம்';

  @override
  String get countLabel => 'எண்ணிக்கை';

  @override
  String get firstAgeLabel => 'முதல் வயது';

  @override
  String get categoryLabel => 'வகை';

  @override
  String get luxuryLabel => 'ஆடம்பரம்';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'வாழ்நாள் எண்ணிக்கை: $count · நிறைவேற்றம்: $pct%';
  }

  @override
  String get pressureWord => 'அழுத்தம்';

  @override
  String get protectionWord => 'பாதுகாப்பு';

  @override
  String get astrologicalWord => 'ஜோதிட';

  @override
  String get keyRisksHeader1 => 'முக்கிய';

  @override
  String get keyRisksHeader2 => 'அபாயங்கள்';

  @override
  String get reportCopiedShort => 'அறிக்கை நகலெடுக்கப்பட்டது!';

  @override
  String get keyScoresLabel => 'முக்கிய மதிப்பெண்கள்';

  @override
  String allScoresCountLabel(int count) {
    return 'அனைத்து மதிப்பெண்கள் ($count)';
  }

  @override
  String get windowsWord => 'காலங்கள்';

  @override
  String get genericFailedMsg => 'தோல்வி';

  @override
  String get unknownWord => 'தெரியவில்லை';

  @override
  String selectKarmaChartsLabel(int max) {
    return '2-$max ஜாதகங்களை தேர்ந்தெடுக்கவும்';
  }

  @override
  String selectChartsLabelCount(int max) {
    return '$max ஜாதகங்களை தேர்ந்தெடுக்கவும்';
  }

  @override
  String runningAnalysisLabel(String label) {
    return '$label பகுப்பாய்வு இயங்குகிறது...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'கர்ம இணைப்புகளை பகுப்பாய்வு செய்ய 2 முதல் $max ஜாதகங்களை தேர்ந்தெடுக்கவும்';
  }

  @override
  String get pickMaleFemaleHint =>
      'ஆண் மற்றும் பெண் ஜாதகத்தை தேர்ந்தெடுக்கவும்';

  @override
  String get personOneLabel => 'நபர் 1';

  @override
  String get personTwoLabel => 'நபர் 2';

  @override
  String get analysisFailedMsg => 'பகுப்பாய்வு தோல்வியடைந்தது';

  @override
  String analyzeChartsCountLabel(int count) {
    return '$count ஜாதகங்களை பகுப்பாய்வு செய்';
  }

  @override
  String get contextGeneralLabel => 'பொது';

  @override
  String get contextLoveLabel => 'காதல்';

  @override
  String get contextBusinessLabel => 'வணிகம்';

  @override
  String get contextFamilyLabel => 'குடும்பம்';

  @override
  String get contextTeamLabel => 'குழு';

  @override
  String get contextFriendshipLabel => 'நட்பு';

  @override
  String get relationshipIntelTitle => 'உறவு நுண்ணறிவு';

  @override
  String analyzingChartsCountLabel(int count) {
    return '$count ஜாதகங்களை பகுப்பாய்வு செய்கிறது...';
  }

  @override
  String get relationshipContextLabel => 'உறவு சூழல்';

  @override
  String get kundliMilanReportTitle => 'குண்டலி மிலன் அறிக்கை';

  @override
  String get runningMilanAnalysisLabel => 'மிலன் பகுப்பாய்வு இயங்குகிறது...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '$count/2 தேர்ந்தெடுக்கப்பட்டது';
  }

  @override
  String get runMilanAnalysisBtn => 'மிலன் பகுப்பாய்வு இயக்கு';

  @override
  String get noChartsCreateFirst =>
      'ஜாதகங்கள் இல்லை. முதலில் ஜாதகம் உருவாக்கவும்.';

  @override
  String get selectBirthChartAnalyze =>
      'பகுப்பாய்வு செய்ய ஜாதகம் தேர்ந்தெடுக்கவும்';

  @override
  String get doshAnalysis => 'தோஷ பகுப்பாய்வு';

  @override
  String doshActiveCount(Object active, Object total) {
    return '$active செயலில் / $total சரிபார்க்கப்பட்டது';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '$active செயலில் / $total யோகங்கள் சரிபார்க்கப்பட்டது';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'செயலில் உள்ள யோகங்கள் ($count)';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'செயலற்ற யோகங்களை மறை ($count)';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'செயலற்ற யோகங்களை காட்டு ($count)';
  }

  @override
  String get loadFailed => 'தோல்வி';

  @override
  String dashaDrillMd(Object planet) {
    return '$planet MD → அந்தர்தசைகள்';
  }

  @override
  String dashaDrillAd(Object planet) {
    return '$planet AD → பிரத்யந்தர்தசைகள்';
  }

  @override
  String dashaDrillPd(Object planet) {
    return '$planet PD → சூக்ஷ்மதசைகள்';
  }

  @override
  String dashaDrillSub(Object planet) {
    return '$planet துணை காலங்கள்';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return 'பிறப்பு அதிபதி: $lord • மீதம்: $balance ஆண்டுகள்';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'லக்னம்: $lagna • மீதம்: $balance ஆண்டுகள்';
  }

  @override
  String dashaYearsValue(Object years) {
    return '$years ஆண்டுகள்';
  }

  @override
  String get dashaCurrentPeriod => 'தற்போதைய தசை காலம்';

  @override
  String dashaAsOf(Object date) {
    return 'தேதி வரை: $date';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'தற்போதைய காலத்தில் செயலில் உள்ள யோகங்கள் ($count)';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'தற்போதைய காலத்தில் செயலில் உள்ள தோஷங்கள் ($count)';
  }

  @override
  String get dashaNoYogasTriggered => 'யோகங்கள் தூண்டப்படவில்லை';

  @override
  String get dashaNoDoshasTriggered => 'தோஷங்கள் தூண்டப்படவில்லை';

  @override
  String get divD1Name => 'ராசி (D-1)';

  @override
  String get divD1Desc => 'உடல் இருப்பு, அனைத்து விஷயங்கள்';

  @override
  String get divD2Name => 'ஹோரா (D-2)';

  @override
  String get divD2Desc => 'செல்வம், பணம்';

  @override
  String get divD3Name => 'த்ரேக்கண (D-3)';

  @override
  String get divD3Desc => 'உடன்பிறந்தோர், தைரியம்';

  @override
  String get divD4Name => 'சதுர்த்தாம்சம் (D-4)';

  @override
  String get divD4Desc => 'சொத்து, வசிப்பிடம், அதிர்ஷ்டம்';

  @override
  String get divD5Name => 'பஞ்சாம்சம் (D-5)';

  @override
  String get divD5Desc => 'புகழ், அதிகாரம், சக்தி';

  @override
  String get divD6Name => 'ஷஷ்டாம்சம் (D-6)';

  @override
  String get divD6Desc => 'ஆரோக்கிய பிரச்சினைகள்';

  @override
  String get divD7Name => 'சப்தாம்சம் (D-7)';

  @override
  String get divD7Desc => 'குழந்தைகள், பேரக்குழந்தைகள்';

  @override
  String get divD8Name => 'அஷ்டாம்சம் (D-8)';

  @override
  String get divD8Desc => 'திடீர் இடர்கள், வழக்கு';

  @override
  String get divD9Name => 'நவாம்சம் (D-9)';

  @override
  String get divD9Desc => 'திருமணம், வாழ்க்கைத்துணை, தர்மம்';

  @override
  String get divD10Name => 'தசாம்சம் (D-10)';

  @override
  String get divD10Desc => 'தொழில், வேலை';

  @override
  String get divD11Name => 'ருத்ராம்சம் (D-11)';

  @override
  String get divD11Desc => 'மரணம், அழிவு';

  @override
  String get divD12Name => 'த்வாதசாம்சம் (D-12)';

  @override
  String get divD12Desc => 'பெற்றோர், இரத்த உறவினர்கள்';

  @override
  String get divD16Name => 'ஷோடசாம்சம் (D-16)';

  @override
  String get divD16Desc => 'வாகனங்கள், வசதிகள், இன்பங்கள்';

  @override
  String get divD20Name => 'விம்சாம்சம் (D-20)';

  @override
  String get divD20Desc => 'ஆன்மீக விஷயங்கள், மத';

  @override
  String get divD24Name => 'சதுர்விம்சாம்சம் (D-24)';

  @override
  String get divD24Desc => 'கற்றல், அறிவு, கல்வி';

  @override
  String get divD27Name => 'நக்ஷத்திராம்சம் (D-27)';

  @override
  String get divD27Desc => 'பலங்கள், பலவீனங்கள், இயல்பு';

  @override
  String get divD30Name => 'த்ரிம்சாம்சம் (D-30)';

  @override
  String get divD30Desc => 'தீமைகள், ஆழ்மனம், தண்டனை';

  @override
  String get divD40Name => 'கவேதாம்சம் (D-40)';

  @override
  String get divD40Desc => 'நற்/தீய பலன்கள் (தாய்வழி)';

  @override
  String get divD45Name => 'அக்ஷவேதாம்சம் (D-45)';

  @override
  String get divD45Desc => 'அனைத்து விஷயங்கள் (தந்தைவழி)';

  @override
  String get divD60Name => 'ஷஷ்டியாம்சம் (D-60)';

  @override
  String get divD60Desc => 'முற்பிறவி கர்மா — மிக முக்கியம்';

  @override
  String get lifeAreaCareer => 'தொழில்';

  @override
  String get lifeAreaWealth => 'செல்வம்';

  @override
  String get lifeAreaMarriage => 'திருமணம்';

  @override
  String get lifeAreaHealth => 'ஆரோக்கியம்';

  @override
  String get lifeAreaSpirituality => 'ஆன்மீகம்';

  @override
  String lifeAreaGrade(Object grade) {
    return 'தரம்: $grade';
  }

  @override
  String get lifeAreaFactorsLabel => 'காரணிகள்:';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return 'நக்: $nakshatra ($pada)';
  }

  @override
  String planetNakLord(Object lord) {
    return 'NL: $lord';
  }

  @override
  String planetLongitude(Object value) {
    return 'நீளம்: $value°';
  }

  @override
  String get chakraOverallHealth => 'ஒட்டுமொத்த ஆரோக்கியம்';

  @override
  String get careerWord => 'தொழில்';

  @override
  String get failedToLoad => 'ஏற்ற முடியவில்லை';

  @override
  String get kundliAscendantLagna => 'லக்னம் (உதயம்)';

  @override
  String get kundliMoonSignRashi => 'சந்திர ராசி';

  @override
  String get kundliSunSign => 'சூரிய ராசி';

  @override
  String kundliEngineLabel(Object engine) {
    return 'எஞ்சின்: $engine';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return 'பாகை: $degree°  •  நக்ஷத்திரம்: $nakshatra ($pada)';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'நக்ஷத்திர அதிபதி: $lord  •  பலம்: $dignity';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return '$base ஜாதகம் — $sign';
  }

  @override
  String kundliBaseChart(Object base) {
    return '$base ஜாதகம்';
  }

  @override
  String get careerSummary => 'தொழில் சுருக்கம்';

  @override
  String get phase => 'கட்டம்';

  @override
  String get confidenceLabel => 'நம்பகத்தன்மை';

  @override
  String get careerScores => 'தொழில் மதிப்பெண்கள்';

  @override
  String get stabilityLabel => 'நிலைத்தன்மை';

  @override
  String get growthLabel => 'வளர்ச்சி';

  @override
  String get gradeExcellent => 'சிறந்தது';

  @override
  String get gradeGood => 'நல்லது';

  @override
  String get gradeAverage => 'சராசரி';

  @override
  String get gradeBelowAvg => 'சராசரிக்கு கீழ்';

  @override
  String get gradeWeak => 'பலவீனம்';

  @override
  String get careerTypeDomain => 'தொழில் & துறை';

  @override
  String get careerTimeline => 'தொழில் காலவரிசை';

  @override
  String dashaLabel(Object dasha) {
    return 'தசை: $dasha';
  }

  @override
  String get improvementSuggestions => 'மேம்பாட்டு பரிந்துரைகள்';

  @override
  String get chartDetails => 'ஜாதக விவரங்கள்';

  @override
  String get keyHousesCareer => 'முக்கிய வீடுகள் (தொழில்)';

  @override
  String get keyCareerPlanets => 'முக்கிய தொழில் கிரகங்கள்';

  @override
  String get empty => 'காலி';

  @override
  String get guna => 'குணம்';

  @override
  String get dasha => 'தசை';

  @override
  String get satwik => 'சாத்வீகம்';

  @override
  String get rajasik => 'ராஜசம்';

  @override
  String get tamasik => 'தாமசம்';

  @override
  String get charGroupCorePersonality => 'முக்கிய ஆளுமை';

  @override
  String get charGroupTrustHonesty => 'நம்பிக்கை & நேர்மை';

  @override
  String get charGroupLoyaltyCommitment => 'விசுவாசம் & அர்ப்பணிப்பு';

  @override
  String get charGroupStrategicPrivacy => 'உத்தி & தனியுரிமை';

  @override
  String get charGroupFinancial => 'நிதி';

  @override
  String get charGroupAngerConflict => 'கோபம் & மோதல்';

  @override
  String get charGroupMoralDharmic => 'அறம் & தர்மம்';

  @override
  String get charGroupIntellectCommunication => 'அறிவு & தொடர்பு';

  @override
  String get charGroupEmotionalProfile => 'உணர்ச்சி விவரம்';

  @override
  String get charGroupMentalHealth => 'மன ஆரோக்கியம்';

  @override
  String get charGroupRomantic => 'காதல்';

  @override
  String get charGroupMarriageFamily => 'திருமணம் & குடும்பம்';

  @override
  String get charGroupOverallLife => 'ஒட்டுமொத்த வாழ்க்கை';

  @override
  String get grahaDrishti => 'க்ரக திருஷ்டி (கிரக பார்வைகள்)';

  @override
  String get grahaDrishtiSubtitle => 'யார் யாரை பார்க்கிறார்கள் (%)';

  @override
  String get lagnaAspectsReceived => 'லக்னம் பெறும் பார்வைகள்';

  @override
  String get rashiDrishti => 'ராசி திருஷ்டி (ராசி பார்வைகள்)';

  @override
  String get shadbalaRupas => 'ரூபங்கள்';

  @override
  String get bhavaHouse1 => 'தன்னிலை / உடல்';

  @override
  String get bhavaHouse2 => 'செல்வம் / குடும்பம்';

  @override
  String get bhavaHouse3 => 'உடன்பிறந்தோர் / தைரியம்';

  @override
  String get bhavaHouse4 => 'வீடு / தாய்';

  @override
  String get bhavaHouse5 => 'குழந்தைகள் / அறிவு';

  @override
  String get bhavaHouse6 => 'எதிரிகள் / ஆரோக்கியம்';

  @override
  String get bhavaHouse7 => 'திருமணம் / துணை';

  @override
  String get bhavaHouse8 => 'ஆயுள்';

  @override
  String get bhavaHouse9 => 'அதிர்ஷ்டம் / குரு';

  @override
  String get bhavaHouse10 => 'தொழில் / தந்தை';

  @override
  String get bhavaHouse11 => 'லாபம் / நண்பர்கள்';

  @override
  String get bhavaHouse12 => 'இழப்பு / மோட்சம்';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '$sign • அதிபதி: $lord';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: $value';
  }

  @override
  String get sarvaAshtakavarga => 'சர்வ அஷ்டகவர்கம் (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'மொத்தம்: $total ரேகைகள் (சராசரி ராசி = $avg)';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '$planet — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'மொத்தம்: $total ரேகைகள் • ஜாதக ராசியில்: $score';
  }

  @override
  String get today => 'இன்று';

  @override
  String gocharTransitScores(Object date) {
    return 'கோசாரம் (பயண மதிப்பெண்கள்) — $date';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'ஜாதக சந்திரன்: $sign';
  }

  @override
  String get gocharBest => 'சிறந்தது';

  @override
  String get gocharWorst => 'மோசம்';

  @override
  String copiedOpening(Object ai) {
    return 'நகலெடுக்கப்பட்டது! $ai திறக்கிறது...';
  }

  @override
  String get openLink => 'திற ↗';

  @override
  String get discussReportWithAI => 'இந்த அறிக்கையை AI உடன் விவாதிக்கவும்';

  @override
  String get reliabilityHigh => 'உயர் நம்பகத்தன்மை';

  @override
  String get reliabilityModerate => 'மிதமான நம்பகத்தன்மை';

  @override
  String get reliabilityLow => 'குறைவு — வழிகாட்டல் மட்டும்';

  @override
  String get reliabilityGoodEdu =>
      'நல்ல நம்பகத்தன்மை · D-24 சரிபார்க்கப்பட்டது';

  @override
  String get relationshipWord => 'உறவு';

  @override
  String get intelligenceWord => 'நுண்ணறிவு';

  @override
  String get relationshipIntelligence => 'உறவு நுண்ணறிவு';

  @override
  String get typeLabel => 'வகை';

  @override
  String get trustLabel => 'நம்பிக்கை';

  @override
  String get dhokaRisk => 'துரோக அபாயம்';

  @override
  String get powerLabel => 'சக்தி';

  @override
  String get integrity => 'நேர்மை';

  @override
  String get warmth => 'அன்பு';

  @override
  String get trustWord => 'நம்பிக்கை';

  @override
  String get assertLabel => 'உறுதிப்பாடு';

  @override
  String get character => 'குணநலன்';

  @override
  String get love => 'காதல்';

  @override
  String get businessWord => 'வணிகம்';

  @override
  String get karmic => 'கர்ம';

  @override
  String get enmityRisk => 'பகை அபாயம்';

  @override
  String get hdrChartProfiles => 'ஜாதக விவரங்கள்';

  @override
  String get hdrPairwiseAnalysis => 'இணை வாரியான பகுப்பாய்வு';

  @override
  String get hdrCriticalPatterns => 'முக்கிய வடிவங்கள்';

  @override
  String get hdrGroupRecommendations => 'குழு பரிந்துரைகள்';

  @override
  String get sharedPractices => 'பகிர்ந்த பயிற்சிகள்';

  @override
  String get hdrIndividualGuidance => 'தனிநபர் வழிகாட்டல்';

  @override
  String get growthAreas => 'வளர்ச்சி பகுதிகள்';

  @override
  String get hdrCoreTheme => 'முக்கிய கருப்பொருள்';

  @override
  String get growthOriented => 'வளர்ச்சி நோக்கிய';

  @override
  String get groupTheme => 'குழு கருப்பொருள்';

  @override
  String get compatibility => 'பொருத்தம்';

  @override
  String get unifiedScoreLabel => 'ஒருங்கிணைந்த மதிப்பெண்';

  @override
  String get ashtakoot => 'அஷ்டகூடம்';

  @override
  String get probability => 'நிகழ்தகவு';

  @override
  String get hdrAshtakootSummary => 'அஷ்டகூட சுருக்கம்';

  @override
  String get hdrGunBreakdown => '8 குண விவரம்';

  @override
  String get hdrMangalDosh => 'மங்கள் தோஷம்';

  @override
  String get hdrD9CrossChart => 'D-9 குறுக்கு ஜாதகம்';

  @override
  String get d9Compatibility => 'D-9 பொருத்தம்';

  @override
  String get hdrDomainCompatibility => 'துறை பொருத்தம்';

  @override
  String get emotional => 'உணர்ச்சி';

  @override
  String get intellectual => 'அறிவுசார்';

  @override
  String get spiritual => 'ஆன்மீக';

  @override
  String get financial => 'நிதி';

  @override
  String get domestic => 'இல்லற';

  @override
  String get communicationWord => 'தொடர்பு';

  @override
  String get sharedDharma => 'பகிர்ந்த தர்மம்';

  @override
  String get familyCreation => 'குடும்ப உருவாக்கம்';

  @override
  String get hdrMarriageTiming => 'திருமண காலம்';

  @override
  String get jointMarriageWindows => 'கூட்டு திருமண காலங்கள்';

  @override
  String get engagementWindows => 'நிச்சயதார்த்த காலங்கள்';

  @override
  String get recommendedLabel => 'பரிந்துரைக்கப்பட்டது';

  @override
  String get hdrKeyRisks => 'முக்கிய அபாயங்கள்';

  @override
  String get hdrFinalVerdict => 'இறுதி தீர்ப்பு';

  @override
  String get marriageVerdict => 'திருமண தீர்ப்பு';

  @override
  String get educationWord => 'கல்வி';

  @override
  String get learningSuffix => '& கற்றல்';

  @override
  String get coreEducationScores => 'முக்கிய கல்வி மதிப்பெண்கள்';

  @override
  String get academicSuccess => 'கல்வி வெற்றி';

  @override
  String get learningCapacity => 'கற்றல் திறன்';

  @override
  String get memory => 'நினைவாற்றல்';

  @override
  String get intelligence => 'நுண்ணறிவு';

  @override
  String get research => 'ஆராய்ச்சி';

  @override
  String get hdrIntellectualProfile => 'அறிவுசார் விவரம்';

  @override
  String get learningSignature => 'கற்றல் தனித்துவம்';

  @override
  String get hdrSubjectKaraka => 'பாட காரகன்';

  @override
  String get hdrHouseFoundations => 'வீட்டு அடித்தளங்கள்';

  @override
  String get hdrMercuryJupiter => 'புதன் & குரு';

  @override
  String get hdrEducationYogas => 'கல்வி யோகங்கள்';

  @override
  String get hdrDivisionalValidation => 'பிரிவு சார்பு சரிபார்ப்பு';

  @override
  String get standing => 'நிலை';

  @override
  String get hdrSubjectRanking => 'பாட தரவரிசை';

  @override
  String get hdrDegreeLikelihood => 'பட்டப்படிப்பு வாய்ப்பு';

  @override
  String get hdrStudyPeriods => 'படிப்பு காலங்கள்';

  @override
  String get earlySchooling => 'ஆரம்ப பள்ளிக்கல்வி';

  @override
  String get higherEducation => 'உயர்கல்வி';

  @override
  String get postgradResearch => 'முதுகலை · ஆராய்ச்சி';

  @override
  String get hdrLearningPreferences => 'கற்றல் விருப்பங்கள்';

  @override
  String get hdrChallengesGifts => 'சவால்கள் & கொடைகள்';

  @override
  String get challenges => 'சவால்கள்';

  @override
  String get cognitiveGifts => 'அறிவாற்றல் கொடைகள்';

  @override
  String get naturalAbilities => 'இயற்கை திறன்கள்';

  @override
  String get hdrSaraswatiRemedies => 'சரஸ்வதி பரிகாரங்கள்';

  @override
  String get studentVerdict => 'மாணவர் தீர்ப்பு';

  @override
  String get educationCareerLinkage => 'கல்வி → தொழில் இணைப்பு';

  @override
  String get startupSuffix => '& தொடக்கம்';

  @override
  String get coreBusinessScores => 'முக்கிய வணிக மதிப்பெண்கள்';

  @override
  String get overallBusiness => 'ஒட்டுமொத்த வணிகம்';

  @override
  String get ventureSuccess => 'முயற்சி வெற்றி';

  @override
  String get eleventhHouse => '11ஆம் வீடு';

  @override
  String get gains => 'லாபங்கள்';

  @override
  String get investor => 'முதலீட்டாளர்';

  @override
  String get hdrFounderArchetype => 'நிறுவனர் வடிவம்';

  @override
  String get hdrTenthEleventhHouses => '10 & 11ஆம் வீடுகள்';

  @override
  String get hdrBusinessYogas => 'வணிக யோகங்கள்';

  @override
  String get hdrRecommendedDomains => 'பரிந்துரைக்கப்பட்ட துறைகள்';

  @override
  String get hdrBusinessStyle => 'வணிக பாணி';

  @override
  String get hdrFounderSkills => 'நிறுவனர் திறன்கள்';

  @override
  String get hdrFundingProfile => 'நிதியளிப்பு விவரம்';

  @override
  String get recommendedPath => 'பரிந்துரைக்கப்பட்ட பாதை';

  @override
  String get investorAttract => 'முதலீட்டாளர் ஈர்ப்பு';

  @override
  String get familyBacking => 'குடும்ப ஆதரவு';

  @override
  String get hybridViability => 'கலப்பின சாத்தியம்';

  @override
  String get launchWindow => 'தொடக்க காலம்';

  @override
  String get scaleWindow => 'விரிவாக்க காலம்';

  @override
  String get hdrBusinessRisks => 'வணிக அபாயங்கள்';

  @override
  String get recoveryCapacity => 'மீட்பு திறன்';

  @override
  String get hdrRemediesSolutions => 'பரிகாரங்கள் & தீர்வுகள்';

  @override
  String get aiConnectionLost =>
      'இணைப்பு துண்டிக்கப்பட்டது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get aiSomethingWrong => 'ஏதோ தவறு நடந்தது';

  @override
  String get aiNoResponse => 'பதில் இல்லை';

  @override
  String get aiConnectionError => 'இணைப்பு பிழை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get aiAutoDetect => 'தானாக கண்டறி';

  @override
  String aiAutoArrow(String lang) {
    return 'தானாக → $lang';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'மொழி: $lang';
  }

  @override
  String get aiNoBirthCharts => 'ஜாதகங்கள் எதுவும் இல்லை';

  @override
  String get aiCreateChartFirst =>
      'AI உடன் அரட்டையடிக்க முதலில் ஜாதகம் உருவாக்கவும்';

  @override
  String get aiSelectChartBegin =>
      'பகுப்பாய்வு தொடங்க ஜாதகம் தேர்ந்தெடுக்கவும்';

  @override
  String aiAnalyzingName(String name) {
    return 'பகுப்பாய்வு: $name';
  }

  @override
  String get aiChange => 'மாற்று';

  @override
  String get aiAnalyzingChart => 'உங்கள் ஜாதகத்தை பகுப்பாய்வு செய்கிறது...';

  @override
  String get aiAskStarsHint => 'நட்சத்திரங்களிடம் எதையும் கேளுங்கள்...';

  @override
  String get aiSuggestedFollowups => 'பரிந்துரைக்கப்பட்ட தொடர் கேள்விகள்';

  @override
  String get aiThinking => 'சிந்திக்கிறது...';

  @override
  String get aiThanks => 'நன்றி!';

  @override
  String get aiFeedbackNoted => 'கருத்து பதிவு செய்யப்பட்டது';

  @override
  String get svcAll => 'அனைத்தும்';

  @override
  String get svcNoServices => 'சேவைகள் எதுவும் இல்லை';

  @override
  String get svcFree => 'இலவசம்';

  @override
  String get astroFailedStartCall => 'அழைப்பை தொடங்க முடியவில்லை';

  @override
  String get astroFailedStartChat => 'அரட்டையை தொடங்க முடியவில்லை';

  @override
  String astroErrorDetail(String error) {
    return 'பிழை: $error';
  }

  @override
  String get astroExperience => 'அனுபவம்';

  @override
  String get astroSessions => 'அமர்வுகள்';

  @override
  String get astroMinutes => 'நிமிடங்கள்';

  @override
  String get astroAbout => 'பற்றி';

  @override
  String get astroLanguages => 'மொழிகள்';

  @override
  String get astroRateCard => 'கட்டண அட்டவணை';

  @override
  String get astroVoice => 'குரல்';

  @override
  String astroReviews(int count) {
    return 'மதிப்புரைகள் ($count)';
  }

  @override
  String get astroNoReviews => 'இதுவரை மதிப்புரைகள் இல்லை';

  @override
  String get astroAnonymous => 'அநாமதேய';

  @override
  String get forgotPasswordSubtitle =>
      'உங்கள் மின்னஞ்சலை உள்ளிடவும், கடவுச்சொல்லை\nமீட்டமைக்க இணைப்பை அனுப்புவோம்.';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => 'இணைப்பை மீண்டும் அனுப்பு';

  @override
  String get appName => 'நக்ஷத்ரலாஜி';

  @override
  String get cosmicJourneyAwaits => 'உங்கள் அண்டப் பயணம் காத்திருக்கிறது';

  @override
  String get home => 'முகப்பு';

  @override
  String get astrologers => 'ஜோதிடர்கள்';

  @override
  String get services => 'சேவைகள்';

  @override
  String get wallet => 'வாலட்';

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get live => 'நேரலை';

  @override
  String get kundli => 'குண்டலி';

  @override
  String get chat => 'அரட்டை';

  @override
  String get call => 'அழைப்பு';

  @override
  String get video => 'வீடியோ';

  @override
  String get signIn => 'உள்நுழை';

  @override
  String get createAccount => 'கணக்கை உருவாக்கு';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get confirmPassword => 'கடவுச்சொல்லை உறுதிப்படுத்து';

  @override
  String get fullName => 'முழு பெயர்';

  @override
  String get phone => 'தொலைபேசி';

  @override
  String get forgotPassword => 'கடவுச்சொல் மறந்துவிட்டதா?';

  @override
  String get sendResetLink => 'மீட்டமைப்பு இணைப்பை அனுப்பு';

  @override
  String get backToSignIn => 'உள்நுழைவுக்குத் திரும்பு';

  @override
  String get dontHaveAccount => 'கணக்கு இல்லையா?';

  @override
  String get alreadyHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா?';

  @override
  String get continueGoogle => 'Google மூலம் தொடரவும்';

  @override
  String get required => 'தேவை';

  @override
  String get minSixChars => 'குறைந்தது ௬ எழுத்துகள்';

  @override
  String get passwordsMismatch => 'கடவுச்சொற்கள் பொருந்தவில்லை';

  @override
  String get validEmailRequired => 'சரியான மின்னஞ்சல் தேவை';

  @override
  String get loginFailed => 'உள்நுழைவு தோல்வி';

  @override
  String get signupFailed => 'பதிவு தோல்வி';

  @override
  String get welcomeBack => 'மீண்டும் வருக';

  @override
  String get todaysHoroscope => 'இன்றைய ஜாதகம்';

  @override
  String get todaysRashi => 'இன்றைய ராசி';

  @override
  String get tapDetails => 'விவரங்களுக்கு தட்டவும்';

  @override
  String get allServices => 'அனைத்து சேவைகள்';

  @override
  String get seeAll => 'அனைத்தையும் காண்';

  @override
  String get topAstrologers => 'சிறந்த ஜோதிடர்கள்';

  @override
  String get onlineExperts => 'ஆலோசனைக்கு ஆன்லைன் நிபுணர்கள்';

  @override
  String get searchAstrologers => 'ஜோதிடர்களைத் தேடு...';

  @override
  String get noAstrologersFound => 'ஜோதிடர்கள் கிடைக்கவில்லை';

  @override
  String get online => 'ஆன்லைன்';

  @override
  String get offline => 'ஆஃப்லைன்';

  @override
  String get busy => 'பிஸி';

  @override
  String get perMin => '/நிமிடம்';

  @override
  String get noCharts => 'இதுவரை ஜாதகம் இல்லை';

  @override
  String get createFirst => 'உங்கள் முதல் ஜனன குண்டலி உருவாக்கவும்';

  @override
  String get createChart => 'ஜாதகம் உருவாக்கு';

  @override
  String get newBirthChart => 'புதிய ஜாதகம்';

  @override
  String get clientName => 'பெயர்';

  @override
  String get gender => 'பாலினம்';

  @override
  String get male => 'ஆண்';

  @override
  String get female => 'பெண்';

  @override
  String get other => 'மற்றவை';

  @override
  String get dateOfBirth => 'பிறந்த தேதி';

  @override
  String get timeOfBirth => 'பிறந்த நேரம்';

  @override
  String get birthPlace => 'பிறந்த இடம்';

  @override
  String get birthPlaceHint => 'நகரத்தின் பெயரை தட்டச்சு செய்யவும்...';

  @override
  String get generateKundli => 'குண்டலி உருவாக்கு';

  @override
  String get birthChartCreated => 'ஜாதகம் உருவாக்கப்பட்டது!';

  @override
  String get deleteChart => 'ஜாதகத்தை நீக்கவா?';

  @override
  String get cannotUndo => 'இதை மீட்டெடுக்க முடியாது.';

  @override
  String get primary => 'முதன்மை';

  @override
  String get viewKundli => 'குண்டலி பார்';

  @override
  String get completeBirthChart => 'முழு ஜாதகம்';

  @override
  String get birthDetails => 'பிறப்பு விவரங்கள்';

  @override
  String get name => 'பெயர்';

  @override
  String get dob => 'பிறந்த தேதி';

  @override
  String get tob => 'பிறந்த நேரம்';

  @override
  String get place => 'இடம்';

  @override
  String get summary => 'சுருக்கம்';

  @override
  String get planets => 'கிரகங்கள்';

  @override
  String get divisions => 'பிரிவுகள்';

  @override
  String get vimshottari => 'விம்சோத்தரி';

  @override
  String get moola => 'மூல';

  @override
  String get gochar => 'கோசாரம்';

  @override
  String get dosh => 'தோஷம்';

  @override
  String get yoga => 'யோகம்';

  @override
  String get shadbala => 'ஷட்பலம்';

  @override
  String get ashtakavarga => 'அஷ்டகவர்க்கம்';

  @override
  String get aspects => 'பார்வை';

  @override
  String get lifeAreas => 'வாழ்க்கைத் துறைகள்';

  @override
  String get bhava => 'பாவம்';

  @override
  String get chakras => 'சக்கரங்கள்';

  @override
  String get dashaActive => 'தசை செயலில்';

  @override
  String get lagna => 'லக்னம்';

  @override
  String get moon => 'சந்திரன்';

  @override
  String get sun => 'சூரியன்';

  @override
  String get premiumSection => 'பிரீமியம் பகுதி';

  @override
  String get unlockReading => 'விரிவான பகுப்பாய்வைக் காண திறக்கவும்.';

  @override
  String get unlock => 'திற';

  @override
  String get retrograde => 'வக்ரம்';

  @override
  String get combust => 'அஸ்தம்';

  @override
  String get vargottama => 'வர்கோத்தமம்';

  @override
  String get exalted => 'உச்சம்';

  @override
  String get debilitated => 'நீசம்';

  @override
  String get addBalance => 'இருப்பு சேர்';

  @override
  String get amount => 'தொகை';

  @override
  String get walletBalance => 'வாலட் இருப்பு';

  @override
  String get recharge => 'ரீசார்ஜ்';

  @override
  String get bonus => 'போனஸ்';

  @override
  String get serviceLabel => 'சேவை';

  @override
  String get refund => 'பணத்திரும்ப';

  @override
  String get noTransactions => 'பரிவர்த்தனைகள் இல்லை';

  @override
  String get editProfile => 'சுயவிவரம் திருத்து';

  @override
  String get savedAstrologers => 'சேமித்த ஜோதிடர்கள்';

  @override
  String get noSavedAstrologers => 'சேமித்த ஜோதிடர்கள் இல்லை';

  @override
  String get myOrders => 'எனது ஆர்டர்கள்';

  @override
  String get communicationHistory => 'தொடர்பு வரலாறு';

  @override
  String get chatHistory => 'அரட்டை வரலாறு';

  @override
  String get callHistory => 'அழைப்பு வரலாறு';

  @override
  String get logout => 'வெளியேறு';

  @override
  String get chatMessages => 'அரட்டை செய்திகள்';

  @override
  String get typeMessage => 'செய்தி தட்டச்சு செய்யவும்...';

  @override
  String get sessionEnded => 'அமர்வு முடிந்தது';

  @override
  String get endChat => 'அரட்டையை முடிக்கவா?';

  @override
  String get endChatConfirm =>
      'இந்த அரட்டை அமர்வை நிச்சயமாக முடிக்க விரும்புகிறீர்களா?';

  @override
  String get sendPhoto => 'புகைப்படம் அனுப்பு';

  @override
  String get sendPDF => 'PDF அனுப்பு';

  @override
  String get upload => 'பதிவேற்று';

  @override
  String get fileNotFound => 'கோப்பு கிடைக்கவில்லை';

  @override
  String get voiceCall => 'குரல் அழைப்பு';

  @override
  String get videoCall => 'வீடியோ அழைப்பு';

  @override
  String get ringing => 'அழைக்கிறது...';

  @override
  String get connected => 'இணைந்தது';

  @override
  String get endCall => 'அழைப்பை முடி';

  @override
  String get mute => 'ஒலியடக்கு';

  @override
  String get unmute => 'ஒலியை இயக்கு';

  @override
  String get speaker => 'ஸ்பீக்கர்';

  @override
  String get camera => 'கேமரா';

  @override
  String get flip => 'புரட்டு';

  @override
  String get liveStreams => 'நேரலை ஸ்ட்ரீம்கள்';

  @override
  String get noLiveStreams => 'தற்போது நேரலை ஸ்ட்ரீம் இல்லை';

  @override
  String get astrologerUnavailable =>
      'ஜோதிடர் கிடைக்கவில்லை. ஸ்ட்ரீம் முடிகிறது.';

  @override
  String get streamEnded => 'ஸ்ட்ரீம் முடிந்தது';

  @override
  String get superChat => 'சூப்பர் சாட்';

  @override
  String get sendGift => 'பரிசு அனுப்பு';

  @override
  String get goBack => 'திரும்பு';

  @override
  String get appPermissions => 'ஆப் அனுமதிகள்';

  @override
  String get grantPermissions => 'அனுமதிகள் வழங்கு';

  @override
  String get skipForNow => 'இப்போதைக்கு தவிர்';

  @override
  String get microphone => 'மைக்ரோஃபோன்';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get storage => 'சேமிப்பகம்';

  @override
  String get ok => 'சரி';

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get save => 'சேமி';

  @override
  String get edit => 'திருத்து';

  @override
  String get delete => 'நீக்கு';

  @override
  String get retry => 'மீண்டும் முயற்சி';

  @override
  String get send => 'அனுப்பு';

  @override
  String get refresh => 'புதுப்பி';

  @override
  String get loading => 'ஏற்றுகிறது...';

  @override
  String get noData => 'தரவு இல்லை';

  @override
  String get error => 'பிழை';

  @override
  String get success => 'வெற்றி';

  @override
  String get selectLanguage => 'மொழி தேர்வு செய்';

  @override
  String get language => 'மொழி';

  @override
  String get english => 'ஆங்கிலம்';

  @override
  String get myDetails => 'என் விவரங்கள்';

  @override
  String get myKundlis => 'என் குண்டலிகள்';

  @override
  String get walletRecharge => 'வாலட் & ரீசார்ஜ்';

  @override
  String get consultationHistory => 'ஆலோசனை வரலாறு';

  @override
  String get helpSupport => 'உதவி & ஆதரவு';

  @override
  String get biometricLogin => 'பயோமெட்ரிக் உள்நுழைவு';

  @override
  String get pastVoiceConsultations => 'முந்தைய குரல் ஆலோசனைகள்';

  @override
  String get pastTextConversations => 'முந்தைய உரை உரையாடல்கள்';

  @override
  String get comingSoon => 'விரைவில் வருகிறது';

  @override
  String get totalCredit => 'மொத்த கிரெடிட்';

  @override
  String get totalDebit => 'மொத்த டெபிட்';

  @override
  String get statement => 'அறிக்கை';

  @override
  String get allTypes => 'அனைத்து வகைகள்';

  @override
  String get prev => 'முந்தைய';

  @override
  String get next => 'அடுத்த';

  @override
  String get allInsights => 'அனைத்து பகுப்பாய்வுகள்';

  @override
  String get yourCompleteReading => 'உங்கள் முழு வாசிப்பு';

  @override
  String get expertEngines => 'நிபுணர் இயந்திரங்கள்';

  @override
  String get eachInsightConsultation => 'ஒவ்வொரு பகுப்பாய்வும் ஒரு முழு ஆலோசனை';

  @override
  String get engines => 'இயந்திரங்கள்';

  @override
  String get dataPoints => 'தரவு புள்ளிகள்';

  @override
  String get singleChart => 'ஒற்றை';

  @override
  String get careerPurpose => 'தொழில் & நோக்கம்';

  @override
  String get wealthAssets => 'செல்வம் & சொத்துகள்';

  @override
  String get loveRelationships => 'காதல் & உறவுகள்';

  @override
  String get healthWellness => 'ஆரோக்கியம் & நல்வாழ்வு';

  @override
  String get soulKarma => 'ஆன்மா & கர்மா';

  @override
  String get specialistReports => 'நிபுணர் அறிக்கைகள்';

  @override
  String get searchByNameSpeciality => 'பெயர், நிபுணத்துவத்தால் தேடுங்கள்...';

  @override
  String get sortedByRating => 'மதிப்பீட்டின் படி';

  @override
  String get initiatingChat => 'அரட்டை தொடங்குகிறது...';

  @override
  String get startingCall => 'அழைப்பு தொடங்குகிறது...';

  @override
  String get yrs => 'ஆண்டுகள்';

  @override
  String get chatWithAISpecialist => 'AI நிபுணருடன் அரட்டை';

  @override
  String get tapToStart => 'தொடங்க தட்டவும்';

  @override
  String get astrologer => 'ஜோதிடர்';

  @override
  String get reports => 'அறிக்கைகள்';

  @override
  String get milan => 'மிலன்';

  @override
  String get forecast => 'முன்னறிவிப்பு';

  @override
  String get rashi => 'ராசி';

  @override
  String get jupiterFavorsBold => 'குரு தைரியமான நடவடிக்கைகளை ஆதரிக்கிறார்';

  @override
  String get careerIlluminated =>
      'உங்கள் தொழில் துறை ஒளிரும் — உங்கள் உள்ளுணர்வை நம்புங்கள்.';

  @override
  String get todaysForecast => 'இன்றைய முன்னறிவிப்பு';

  @override
  String get engCareer => 'தொழில் & வேலை';

  @override
  String get engBusiness => 'வணிகம் & தொடக்கம்';

  @override
  String get engEducation => 'கல்வி & கற்றல்';

  @override
  String get engLifePath => 'வாழ்க்கை பாதை & அதிர்ஷ்டம்';

  @override
  String get engWealth => 'செல்வம் & நிதி';

  @override
  String get engDebt => 'கடன் & மீட்பு';

  @override
  String get engProperty => 'சொத்து & சொத்துகள்';

  @override
  String get engLegal => 'சட்ட & தகராறு';

  @override
  String get engLove => 'காதல் & காதல்';

  @override
  String get engMarriage => 'திருமணம் & குடும்பம்';

  @override
  String get engKundliMilan => 'குண்டலி மிலன்';

  @override
  String get engRelationship => 'உறவு புலனாய்வு';

  @override
  String get engLoveCompat => 'காதல் இணக்கம்';

  @override
  String get engChildProb => 'குழந்தை வாய்ப்பு';

  @override
  String get engHealth => 'ஆரோக்கியம் & நல்வாழ்வு';

  @override
  String get engMental => 'மன & மன அழுத்தம்';

  @override
  String get engCharacter => 'குணம் பகுப்பாய்வு';

  @override
  String get engPastLife => 'முற்பிறவி & கர்மா';

  @override
  String get engKarmaLink => 'கர்மா இணைப்பு';

  @override
  String get noChatSessions => 'இன்னும் அரட்டை அமர்வுகள் இல்லை';

  @override
  String get chatAppearHere =>
      'ஜோதிடர்களுடன் உங்கள் உரையாடல்கள் இங்கே தோன்றும்.';

  @override
  String get noCallsYet => 'இன்னும் அழைப்புகள் இல்லை';

  @override
  String get callAppearHere =>
      'ஜோதிடர்களுடன் உங்கள் அழைப்பு வரலாறு இங்கே தோன்றும்.';

  @override
  String get chatWith => 'உடன் அரட்டை';

  @override
  String get msgs => 'செய்திகள்';

  @override
  String get voiceCallLabel => 'குரல் அழைப்பு';

  @override
  String get videoCallLabel => 'வீடியோ அழைப்பு';

  @override
  String get pullToRefresh => 'புதுப்பிக்க கீழே இழுக்கவும்';

  @override
  String get sessionExpired => 'அமர்வு காலாவதியானது';

  @override
  String get connectionFailed => 'இணைப்பு தோல்வி';

  @override
  String get callActive => 'அழைப்பு செயலில்';

  @override
  String get lessThanOneMin => '1 நிமிடத்திற்கும் குறைவாக மீதம்';

  @override
  String get noMessages => 'இந்த அமர்வில் செய்திகள் இல்லை';

  @override
  String get gocharForAllSigns => 'அனைத்து 12 ராசிகளுக்கும் இன்றைய கோசாரம்';

  @override
  String get selectChart => 'பகுப்பாய்வுக்கு ஜாதகம் தேர்வு செய்யவும்';

  @override
  String get selectTwoCharts => 'இரண்டு ஜாதகங்களைத் தேர்ந்தெடுக்கவும்';

  @override
  String get analyzing => 'பகுப்பாய்வு நடைபெறுகிறது...';

  @override
  String get browseAstrologers => 'ஜோதிடர்களைக் கண்டறியவும்';

  @override
  String get probableNumber => 'சாத்தியமான எண்ணிக்கை';

  @override
  String get genderTendency => 'பாலின போக்கு';

  @override
  String get son => 'மகன்';

  @override
  String get daughter => 'மகள்';

  @override
  String get occupants => 'குடியிருப்பு கிரகங்கள்';

  @override
  String get beneficAspects => 'சுப பார்வை';

  @override
  String get maleficAspects => 'பாப பார்வை';

  @override
  String get nextFavorableWindow => 'அடுத்த சாதகமான காலம்';

  @override
  String get totalDoshaPenalty => 'மொத்த தோஷ தண்டனை';

  @override
  String get cancellationFactors => 'ரத்து காரணிகள்';

  @override
  String get combinedFertility => 'ஒருங்கிணைந்த கருவுறுதல் குறிகாட்டி';

  @override
  String get planetPositions => 'கிரக நிலைகள்';

  @override
  String get bestWindows => 'சிறந்த காலங்கள்';

  @override
  String get worstWindows => 'மோசமான காலங்கள்';

  @override
  String get scoreComponents => 'மதிப்பெண் கூறுகள்';

  @override
  String get topOpportunities => 'முக்கிய வாய்ப்புகள்';

  @override
  String get topRisks => 'முக்கிய அபாயங்கள்';

  @override
  String get remedies => 'பரிகாரங்கள்';

  @override
  String get keyInsights => 'முக்கிய நுண்ணறிவுகள்';

  @override
  String get overallVerdict => 'ஒட்டுமொத்த தீர்ப்பு';

  @override
  String get venusContacts => 'சுக்கிர தொடர்புகள்';

  @override
  String get contact => 'தொடர்பு';

  @override
  String get effect => 'விளைவு';

  @override
  String get moonSignCompat => 'சந்திர ராசி இணக்கம்';

  @override
  String get hisMoon => 'அவரது சந்திரன்';

  @override
  String get herMoon => 'அவளது சந்திரன்';

  @override
  String get nakshatraCompat => 'நட்சத்திர இணக்கம்';

  @override
  String get ketuContacts => 'கேது தொடர்புகள்';

  @override
  String get rahuContacts => 'ராகு தொடர்புகள்';

  @override
  String get pastLifeIndication => 'முற்பிறவி குறிகாட்டி';

  @override
  String get totalChallengePenalty => 'மொத்த சவால் தண்டனை';

  @override
  String get manifestation => 'வெளிப்பாடு';

  @override
  String get cancellation => 'ரத்து';

  @override
  String get navigation => 'வழிநடத்தல்';

  @override
  String get potentialStrengths => 'சாத்தியமான பலங்கள்';

  @override
  String get areasToNurture => 'வளர்க்க வேண்டிய பகுதிகள்';

  @override
  String get relationshipGuidance => 'உறவு வழிகாட்டுதல்';

  @override
  String get detailedSummary => 'விரிவான சுருக்கம்';

  @override
  String get discussWithAI => 'AI உடன் விவாதிக்கவும்';

  @override
  String get planet => 'கிரகம்';

  @override
  String get sign => 'ராசி';

  @override
  String get house => 'பாவம்';

  @override
  String get strength => 'பலம்';

  @override
  String get copy => 'நகல்';

  @override
  String get confidence => 'நம்பிக்கை';

  @override
  String get d7Saptamsa => 'D7 சப்தாம்சம்';

  @override
  String get numberExplanation => 'எண் விளக்கம்';

  @override
  String get genderExplanation => 'பாலின விளக்கம்';

  @override
  String get inFifth => '5வதில்?';

  @override
  String get primaryArchetype => 'முதன்மை முன்மாதிரி';

  @override
  String get mitigation => 'தணிப்பு';

  @override
  String get soulCareerAlign => 'ஆன்மா ↔ தொழில் சீரமைப்பு';

  @override
  String get favorablePeriods => 'சாதகமான காலம்';

  @override
  String get challengingPeriods => 'சவாலான காலம்';

  @override
  String get keyHouses => 'முக்கிய பாவங்கள்';

  @override
  String get keyPlanets => 'முக்கிய கிரகங்கள்';

  @override
  String get characterOverview => 'குணம் மேலோட்டம்';

  @override
  String get noYogasActive => 'இந்த ஜாதகத்தில் தற்போது யோகங்கள் இல்லை.';

  @override
  String get basedOnPlanetStrengths =>
      'கிரக பலங்கள் & பாவ நிலைகளின் அடிப்படையில்';

  @override
  String get basedOnTransits => 'தற்போதைய கிரக கோசாரத்தின் அடிப்படையில்';

  @override
  String get currentPlanetPositions =>
      'உங்கள் ராசியை 1ம் பாவமாகக் கொண்டு தற்போதைய கிரக நிலைகள்';

  @override
  String get favorablePeriodAdvice =>
      'சாதகமான காலம் — தொழில் வளர்ச்சி மற்றும் உறவுகளில் கவனம் செலுத்துங்கள்.';

  @override
  String get noClassicalYogas =>
      'சாஸ்திர கல்வி யோகங்கள் இல்லாமல், வெற்றி நிலையான முயற்சியால் வருகிறது.';

  @override
  String get walletDeduction => 'தொகை உங்கள் வாலட்டிலிருந்து கழிக்கப்படும்';

  @override
  String get bhakootAxis => 'பகூட் அச்சு';

  @override
  String get basis => 'அடிப்படை';

  @override
  String get selectChartsForMilan =>
      'மிலனுக்கு 2 ஜாதகங்களைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectMultiCharts => '2-5 ஜாதகங்களைத் தேர்ந்தெடுக்கவும்';

  @override
  String get running => 'இயங்குகிறது';

  @override
  String get past => 'கடந்த';

  @override
  String get topActiveDoshas => 'முக்கிய செயலில் தோஷங்கள்';

  @override
  String get allDoshas => 'அனைத்து தோஷங்கள்';

  @override
  String get activeYogas => 'செயலில் யோகங்கள்';

  @override
  String get activeDoshas => 'செயலில் தோஷங்கள்';

  @override
  String get yogaAnalysis => 'யோக பகுப்பாய்வு';

  @override
  String get factors => 'காரணிகள்';

  @override
  String get dominantPlanet => 'ஆதிக்க கிரகம்';

  @override
  String get startSession => 'அமர்வு தொடங்கவும்';

  @override
  String get notesSaved => 'குறிப்புகள் சேமிக்கப்பட்டன';

  @override
  String get unlocked => 'திறக்கப்பட்டது! உங்கள் வாசிப்பை அனுபவிக்கவும்.';

  @override
  String get todaysGochar => 'இன்றைய கோசாரம்';

  @override
  String get todaysTransitChart => 'இன்றைய கோசார வரைபடம்';

  @override
  String get lifeAreaPredictions => 'வாழ்க்கை துறை கணிப்புகள்';

  @override
  String get strengths => 'பலங்கள்';

  @override
  String get weaknesses => 'பலவீனங்கள்';

  @override
  String get ruledBy => 'அதிபதி';

  @override
  String get kundliMilan => 'குண்டலி மிலன்';

  @override
  String get startKundliMilan => 'குண்டலி மிலன் தொடங்கவும்';

  @override
  String get recommendations => 'பரிந்துரைகள்';

  @override
  String get cancellations => 'ரத்துகள்';

  @override
  String get dashaSync => 'தசா ஒத்திசைவு';

  @override
  String get transitMarriageWindows => 'கோசார திருமண காலம்';

  @override
  String get overlappingWindows => 'மேலோட்ட திருமண காலம்';

  @override
  String get overallStrength => 'ஒட்டுமொத்த வலிமை';

  @override
  String get stability => 'நிலைத்தன்மை';

  @override
  String get growth => 'வளர்ச்சி';

  @override
  String get clarity => 'தெளிவு';

  @override
  String get recognition => 'அங்கீகாரம்';

  @override
  String get satisfaction => 'திருப்தி';

  @override
  String get verdict => 'தீர்ப்பு';

  @override
  String get topRoles => 'முக்கிய பாத்திரங்கள்';

  @override
  String get areasForGrowth => 'வளர்ச்சி துறைகள்';

  @override
  String get bestIndustries => 'சிறந்த தொழில்கள்';

  @override
  String get employment => 'வேலை';

  @override
  String get entrepreneurship => 'தொழில்முனைவு';

  @override
  String get freelance => 'ஃப்ரீலான்ஸ்';

  @override
  String get portfolio => 'போர்ட்ஃபோலியோ';

  @override
  String get burnoutRisk => 'சோர்வு ஆபத்து';

  @override
  String get careerStagnation => 'தொழில் தேக்கம்';

  @override
  String get workplaceConflict => 'பணியிட மோதல்';

  @override
  String get positioning => 'நிலைப்படுத்துதல்';

  @override
  String get skillDevelopment => 'திறன் மேம்பாடு';

  @override
  String get network => 'நெட்வொர்க்';

  @override
  String get visibility => 'தெரிவுநிலை';

  @override
  String get lagnaLord => 'லக்ன அதிபதி';

  @override
  String get tenthLord => 'பத்தாம் அதிபதி';

  @override
  String get lord => 'அதிபதி';

  @override
  String get lordPlacedIn => 'அதிபதி நிலை';

  @override
  String get lordDignity => 'அதிபதி கௌரவம்';

  @override
  String get d9Dignity => 'டி9 கௌரவம்';

  @override
  String get careerAnalysis => 'தொழில் பகுப்பாய்வு';

  @override
  String get launchWindows => 'தொடக்க காலம்';

  @override
  String get peakWindows => 'உச்ச காலம்';

  @override
  String get promotionWindows => 'பதவி உயர்வு காலம்';

  @override
  String get riskWindows => 'ஆபத்து காலம்';

  @override
  String get timingWindows => 'நேர சாளரம்';

  @override
  String get careerRisks => 'தொழில் அபாயங்கள்';

  @override
  String get astrologicalRemedies => 'ஜோதிட பரிகாரங்கள்';

  @override
  String get practicalSolutions => 'நடைமுறை தீர்வுகள்';

  @override
  String get analysisConfidence => 'பகுப்பாய்வு நம்பகத்தன்மை';

  @override
  String get careerArchetype => 'தொழில் முன்மாதிரி';

  @override
  String get workStructure => 'பணி அமைப்பு';

  @override
  String get teamLeadership => 'குழு தலைமை';

  @override
  String get idealEnvironment => 'சிறந்த சூழல்';

  @override
  String get idealOrgSize => 'சிறந்த நிறுவன அளவு';

  @override
  String get fitScore => 'பொருத்த மதிப்பெண்';

  @override
  String get recommended => 'பரிந்துரை';

  @override
  String get divisionalValidation => 'பிரிவு சரிபார்ப்பு';

  @override
  String get houseAnalysis => 'பாவ பகுப்பாய்வு';

  @override
  String get jaiminiKarakas => 'ஜைமினி காரகங்கள்';

  @override
  String get copyFullReport => 'முழு அறிக்கையை நகலெடுக்கவும்';

  @override
  String get reportCopied => 'அறிக்கை நகலெடுக்கப்பட்டது!';

  @override
  String get biometricNotAvailable => 'இந்த சாதனத்தில் பயோமெட்ரிக் இல்லை';

  @override
  String biometricErrorMsg(Object error) {
    return 'பயோமெட்ரிக் பிழை: $error';
  }

  @override
  String get biometricVerifyReason =>
      'பயோமெட்ரிக் உள்நுழைவை இயக்க சரிபார்க்கவும்';

  @override
  String get dobFormatLabel => 'பிறந்த தேதி (DD/MM/YYYY)';

  @override
  String get tobFormatLabel => 'பிறந்த நேரம் (HH:MM)';

  @override
  String get phoneLabel => 'தொலைபேசி';

  @override
  String get activeBadge => 'செயலில்';

  @override
  String get chartCategoryLabel => 'வகை';

  @override
  String get freePrimaryDescription =>
      'ஃப்ரீ ப்ரைமரி — தினசரி ராசிபலன் மற்றும் இலவச ஒற்றை-சார்ட் சேவைகளுக்குப் பயன்படுகிறது';

  @override
  String get searchChartsHint => 'பெயர் அல்லது பிறந்த தேதி மூலம் தேடுங்கள்...';

  @override
  String unlockPriceLabel(Object price) {
    return '$price க்கு அன்லாக் செய்யவும்';
  }

  @override
  String unlockAiSpecialistIntl(Object price) {
    return 'இந்த AI நிபுணரை $price க்கு (ஒரு முறை) அன்லாக் செய்யவும், இது ஆப் ஸ்டோர் மூலம் பாதுகாப்பாக வாங்கப்படுகிறது.';
  }

  @override
  String unlockAiSpecialistWallet(Object price) {
    return 'இந்த AI நிபுணரை $price க்கு (ஒரு முறை) அன்லாக் செய்யவும். தொகை உங்கள் வாலட்டில் இருந்து கழிக்கப்படும்.';
  }

  @override
  String get specialistNotAvailablePurchase =>
      'இந்த நிபுணர் இன்னும் வாங்குவதற்குக் கிடைக்கவில்லை.';

  @override
  String get couldNotCompletePurchase =>
      'வாங்குதலை முடிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get couldNotUnlockWalletBalance =>
      'அன்லாக் செய்ய முடியவில்லை (வாலட் இருப்பைச் சரிபார்க்கவும்)';

  @override
  String get freeBadge => 'இலவசம்';

  @override
  String activeSessionInProgress(Object kind) {
    return 'உங்கள் செயலில் உள்ள $kind நடந்து கொண்டிருக்கிறது';
  }

  @override
  String get returnLabel => 'திரும்பு';

  @override
  String get enableNotificationsForAlerts =>
      'ஆலோசனை மற்றும் சலுகை விழிப்பூட்டல்களைப் பெற அறிவிப்புகளை இயக்கவும்';

  @override
  String get enableLabel => 'இயக்கு';

  @override
  String get notificationsEnabled => 'அறிவிப்புகள் இயக்கப்பட்டன';

  @override
  String get couldNotEnableNotifications =>
      'இயக்க முடியவில்லை — உங்கள் உலாவியில் அறிவிப்புகளை அனுமதிக்கவும்';

  @override
  String get amountInrLabel => 'தொகை (₹)';

  @override
  String get noteOptionalLabel => 'குறிப்பு (விருப்பம்)';

  @override
  String get txnDate => 'தேதி';

  @override
  String get txnDescription => 'விவரம்';

  @override
  String get txnType => 'வகை';

  @override
  String get txnAmount => 'தொகை';

  @override
  String get txnBalance => 'இருப்பு';

  @override
  String get credit => 'கிரெடிட்';

  @override
  String get debit => 'டெபிட்';

  @override
  String get razorpayStripeNote =>
      '💳 உற்பத்தியில் இது Razorpay/Stripe க்கு திருப்பிவிடப்படும்.';

  @override
  String get downloadPdf => 'PDF பதிவிறக்கவும்';

  @override
  String get chatWithAiCta => 'AI உடன் அரட்டை அடிக்கவும்';

  @override
  String get pdfServiceUnavailable =>
      'PDF சேவை தற்காலிகமாக கிடைக்கவில்லை. பின்னர் முயற்சிக்கவும்.';

  @override
  String get pleaseUnlockFirst => 'முதலில் இதை அன்லாக் செய்யவும்.';

  @override
  String get couldNotGeneratePdf =>
      'PDF உருவாக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get statConsults => 'ஆலோசனைகள்';

  @override
  String get statCharts => 'சார்ட்கள்';

  @override
  String get statWallet => 'வாலட்';

  @override
  String get firstChartPrimaryInfo =>
      'உங்கள் முதல் சார்ட் உங்கள் இலவச ப்ரைமரி. கூடுதல் சார்ட்கள் தனித்தனியாக சேவைகளை அன்லாக் செய்யும்.';

  @override
  String get tryDifferentFilter => 'வேறு வடிப்பானை முயற்சிக்கவும்';

  @override
  String get defaultChartName => 'சார்ட்';

  @override
  String get balAbbr => 'இருப்பு';

  @override
  String get aiTimePassTitle => 'உங்கள் அரட்டை நேரத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get aiTimePassHint =>
      'வாலெட்டிலிருந்து கட்டணம். நேரம் இப்போதே தொடங்கும் — மீண்டும் வாங்கினால் மீதமுள்ள நேரத்துடன் சேர்க்கப்படும்.';

  @override
  String aiTimePlanMinutes(Object minutes) {
    return '$minutes நிமிடம்';
  }

  @override
  String aiTimePassPay(Object price) {
    return '$price செலுத்து';
  }

  @override
  String aiTimeLeft(Object minutes) {
    return '$minutes நிமிடம் மீதம்';
  }
}
