// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get doshSevere => 'Severe';

  @override
  String get doshVeryMild => 'Very Mild';

  @override
  String get doshLow => 'Low';

  @override
  String get doshHigh => 'High';

  @override
  String get doshCritical => 'Critical';

  @override
  String get doshSummaryTitle => 'Dosha Summary';

  @override
  String get doshActiveDoshas => 'Active Doshas';

  @override
  String get doshTotalChecked => 'Total Checked';

  @override
  String get doshOverallSeverity => 'Overall Severity';

  @override
  String get doshNoneActive => 'No active doshas — a clean chart!';

  @override
  String get doshCategory => 'Category';

  @override
  String get doshConfidence => 'Confidence';

  @override
  String get doshWhyFormed => 'Why This Formed';

  @override
  String get doshAffectedAreas => 'Affected Areas';

  @override
  String get doshTimeline => 'Timeline';

  @override
  String get doshDefinition => 'Definition';

  @override
  String get doshFormationRule => 'Formation Rule';

  @override
  String get doshSupportingPlanets => 'Related Planet';

  @override
  String get doshCancellation => 'Cancellation Yogas';

  @override
  String get doshNoCancellation => 'None found';

  @override
  String get doshAreaChildren => 'Children';

  @override
  String get doshAreaMind => 'Mind';

  @override
  String get remMantra => 'Mantra';

  @override
  String get remGemstone => 'Gemstone';

  @override
  String get remDonation => 'Donation';

  @override
  String get remTemple => 'Temple';

  @override
  String get remFasting => 'Fasting';

  @override
  String get remLifestyle => 'Lifestyle';

  @override
  String get remLifestyleGeneric => 'Practise gratitude, discipline and charity connected to this planet, and keep good conduct.';

  @override
  String get doshExplain => 'Explain My Doshas';

  @override
  String get doshExplainSubtitle => 'A calm, practical look at your doshas';

  @override
  String get doshExplainReassure => 'Doshas are common — almost every chart has some. They describe tendencies, not fixed fate. Awareness, good conduct and simple remedies reduce their practical effect, so there is no need to worry.';

  @override
  String get doshAiGeneric => 'This dosha describes a tendency in your chart. Its practical effect is usually mild and can be balanced with awareness and simple remedies.';

  @override
  String doshHeroSummary(Object active, Object total) {
    return 'Your chart shows ${active} active doshas out of ${total} checked. Most are mild and only a few need attention. With understanding and simple remedies, their practical effect can be eased.';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return 'This dosha mainly influences ${areas}. During ${planet} periods its effect can feel stronger, and remedies help balance it.';
  }

  @override
  String doshTimelineLine(Object planet) {
    return 'Its effect is felt most during the Mahadasha and Antardasha of ${planet}, and when ${planet} is active in transit.';
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
  String get sbBodyWhatIs => 'ஷட்பலம் (\'ஆறுவகை பலம்\') ஒவ்வொரு கிரகமும் தனது பலன்களை வழங்க எவ்வளவு சக்தி கொண்டுள்ளது என்பதை, ஆறு தனித்தனி பல மூலங்களைச் சேர்த்து அளவிடுகிறது.';

  @override
  String get sbBodyRupas => 'பலம் ரூபங்களில் அளவிடப்படுகிறது (1 ரூபம் = 60 விரூபம்). ஒவ்வொரு கிரகமும் வலிமையானதாக கருதப்பட குறைந்தபட்ச ரூப பலம் தேவை; அதிக ரூபங்கள் என்றால் அது தனது பலன்களை இன்னும் முழுமையாக வழங்குகிறது என்று பொருள்.';

  @override
  String get sbBodyHowCalc => 'ஆறு பலங்கள் சேர்க்கப்படுகின்றன: ஸ்தானம் (இட ரீதியான), திக் (திசை ரீதியான), காலம் (கால ரீதியான), சேஷ்டா (இயக்க ரீதியான), நைசர்கிகம் (இயற்கையான) மற்றும் த்ருக் (பார்வை ரீதியான). மொத்தத்தை கிரகத்திற்குத் தேவையான குறைந்தபட்சத்துடன் ஒப்பிட்டு சதவீதம் பெறப்படுகிறது.';

  @override
  String get sbBodyHowUse => '100%க்கு மேல் உள்ள கிரகம் தன் பலன்களை வசதியாக வழங்குகிறது; 100%க்கு கீழ் இருந்தால் ஆதரவு தேவை. முக்கியமான விஷயங்களுக்கு உங்கள் வலிமையான கிரகங்களுக்கு முன்னுரிமை கொடுங்கள், பலவீனமானவற்றுக்கு பரிகாரங்களும் பொறுமையும் கொடுங்கள்.';

  @override
  String get sbRemedyStrong => 'நன்கு ஆதரிக்கப்படுகிறது — சிறப்பு பரிகாரம் தேவையில்லை; இந்த கிரகத்தின் காலங்களை நம்பிக்கையுடன் பயன்படுத்தலாம்.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '${strongP} உங்கள் வலிமையான கிரகம், ${strongTrait}க்கு சிறந்த ஆதரவை அளிக்கிறது. ${weakP} மிகவும் பலவீனமானது மற்றும் பரிகாரங்களால் அதிகம் பயனடைகிறது.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '${planet}க்கு ${category} ஷட்பலம் உள்ளது, எனவே அதன் ${karakatva} அதற்கேற்ப ஆதரிக்கப்படுகின்றன.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return '${bala} மூலம் மிகவும் வலிமையானது (${rupa} ரூபங்கள்).';
  }

  @override
  String sbWeakLine(Object bala) {
    return '${bala}இல் மிகவும் பலவீனமானது, இது மொத்தத்தை குறைக்கிறது.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return '${planet}இன் மகாதசையின் போது, அதன் ${karak} முன்னிலைக்கு வருகின்றன.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'வலிமையான ஷட்பலத்துடன், ${karak} இயற்கையாகவே ஆதரிக்கப்படுகின்றன.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'மிதமான ஷட்பலத்துடன், ${karak}க்கு உணர்வுபூர்வமான முயற்சி தேவைப்படலாம்.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return '${planet}இன் மந்திரம், ரத்தினம் அல்லது தானம் மூலம் வலிமைப்படுத்துங்கள், மற்றும் அதன் காலங்களில் பொறுமையாக செயல்படுங்கள்.';
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
  String bhHeroSummary(Object s1, Object s2, Object strongArea, Object weakArea) {
    return 'உங்கள் மிகவும் வலிமையான வீடுகள் ${s1} மற்றும் ${s2}. ${strongArea} இயற்கையாகவே வலிமையானது, அதே நேரத்தில் ${weakArea}-க்கு கூடுதல் முயற்சி தேவைப்படுகிறது.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'இதன் அதிபதி ${lord} ${relation} ஆக அமைந்துள்ளார்.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'இந்த வீட்டில் ${sav} சுப புள்ளிகள் (SAV) உள்ளன; இதில் அமர்ந்துள்ள கிரகங்களும் அவற்றின் பார்வைகளும் மீதமுள்ள மதிப்பெண்ணை தீர்மானிக்கின்றன.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'வலிமையாக இருக்கும்போது, இது ${meaning}-ஐ ஆதரிக்கிறது.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'பலவீனமாக இருக்கும்போது, ${meaning}-க்கு கூடுதல் முயற்சியும் கவனிப்பும் தேவைப்படலாம்.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'இதை மேம்படுத்த அதிபதி ${lord}-ஐ பலப்படுத்தி, இந்த வீட்டின் விஷயங்களை மதிக்கவும்.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'உங்கள் ${house} ${strengthWord} ஆக உள்ளது. இது ${meaning}-ஐ நிர்வகிக்கிறது.';
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
    return '${ordinal} பாவம் ${meaning} ஐ நிர்வகிக்கிறது.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return 'இங்கு அமைந்துள்ள ${planets} இதன் பலன்களை வடிவமைக்கின்றன.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'உங்கள் லக்னம் ${asc}, இது உங்கள் பார்வையையும் மற்றவர்கள் உங்களை முதலில் எப்படி காண்கிறார்கள் என்பதையும் வடிவமைக்கிறது.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'உங்கள் மனமும் உணர்வுகளும் ${moon}-இல் உள்ள சந்திரனைப் பின்பற்றுகின்றன.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '${planet} உங்கள் மிகவும் வலிமையான கிரகம் — எளிமை மற்றும் ஆதரவின் இயற்கையான பகுதி.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '${planet} உங்களை அதிகம் சோதிக்கும் கிரகம் — இங்கு பொறுமையும் முயற்சியும் பலனளிக்கும்.';
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
    return 'பாவம் ${houses}-க்கு அதிபதி';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return '${nakLord} ஆல் ஆளப்படுகிறது, ${trait}-ஐக் கொண்டு வருகிறது.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '${planet} ${sign} ராசியில், ${house} பாவத்தில் அமைந்துள்ளது.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'இதன் முக்கிய காரகத்துவங்கள் — ${karak} — இங்கு நன்கு ஆதரிக்கப்படுகின்றன.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'இதன் முக்கிய காரகத்துவங்கள் — ${karak} — இங்கு நனவான முயற்சி தேவைப்படலாம்.';
  }

  @override
  String plAiExalted(Object planet) {
    return '${planet} உச்சத்தில் உள்ளது, தனது சிறந்த பலன்களை அளிக்கிறது.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '${planet} நீசத்தில் உள்ளது, தனது பலன்களை அளிக்க ஆதரவு தேவை.';
  }

  @override
  String plAiCombust(Object planet) {
    return '${planet} அஸ்தமித்துள்ளது, எனவே சூரியனின் தீவிரத்தில் இது குறைவாகவே வெளிப்படையாக செயல்படுகிறது.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '${planet} வர்கோத்தமமாக உள்ளது — இந்த வலுவான நிலை நவாம்சத்திலும் மீண்டும் வருகிறது.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '${planet} வக்ரமாக உள்ளது, தனது ஆற்றலை உள்நோக்கி திருப்பி அதை தீவிரப்படுத்துகிறது.';
  }

  @override
  String get plHouse1 => 'தான், உடல், ஆளுமை மற்றும் உயிர்ச்சக்தி';

  @override
  String get plHouse2 => 'செல்வம், குடும்பம், பேச்சு மற்றும் உணவு';

  @override
  String get plHouse3 => 'தைரியம், உடன்பிறப்புகள், தொடர்பு மற்றும் குறுகிய பயணங்கள்';

  @override
  String get plHouse4 => 'வீடு, தாய், வசதி, சொத்து மற்றும் அக அமைதி';

  @override
  String get plHouse5 => 'குழந்தைகள், படைப்பாற்றல், அறிவு, காதல் மற்றும் முன்வினைப் புண்ணியம்';

  @override
  String get plHouse6 => 'ஆரோக்கியம், எதிரிகள், கடன்கள், சேவை மற்றும் அன்றாட வேலை';

  @override
  String get plHouse7 => 'திருமணம், கூட்டாண்மை மற்றும் வணிக உறவுகள்';

  @override
  String get plHouse8 => 'ஆயுள், மாற்றம், ரகசியங்கள் மற்றும் வாரிசு உரிமை';

  @override
  String get plHouse9 => 'பாக்கியம், தர்மம், உயர்கல்வி, குரு மற்றும் தந்தை';

  @override
  String get plHouse10 => 'தொழில், அந்தஸ்து, அதிகாரம் மற்றும் பொது கர்மா';

  @override
  String get plHouse11 => 'ஆதாயங்கள், வருமானம், நண்பர்கள், தொடர்பு வலை மற்றும் நிறைவேறிய ஆசைகள்';

  @override
  String get plHouse12 => 'இழப்பு, செலவுகள், வெளிநாடு, ஆன்மீகம் மற்றும் மோட்சம்';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return 'நக்: ${nakshatra} (${pada})';
  }

  @override
  String planetNakLord(Object lord) {
    return 'NL: ${lord}';
  }

  @override
  String planetLongitude(Object value) {
    return 'நீளம்: ${value}°';
  }

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
  String get sumNatureFire => 'நீங்கள் ஒரு தைரியமான, சுறுசுறுப்பான மற்றும் முன்னோடித்தனமான இயல்பு கொண்டவர், முன்னின்று வழிநடத்துகிறீர்கள்.';

  @override
  String get sumNatureEarth => 'நீங்கள் நடைமுறையான, உறுதியான மற்றும் ஒழுங்குபடுத்தப்பட்ட இயல்பு கொண்டவர், நீடித்த முடிவுகளை உருவாக்குகிறீர்கள்.';

  @override
  String get sumNatureAir => 'நீங்கள் ஆர்வமுள்ள, தொடர்பாடல் திறன் மிக்க மற்றும் அறிவார்ந்த இயல்பு கொண்டவர், புதிய கருத்துக்களில் சிறந்து விளங்குகிறீர்கள்.';

  @override
  String get sumNatureWater => 'நீங்கள் உள்ளுணர்வு மிக்க, உணர்ச்சிபூர்வமான மற்றும் பரிவுள்ள இயல்பு கொண்டவர், ஆழ்ந்த உள் உணர்திறன் கொண்டவர்.';

  @override
  String get sumGradePhraseExcellent => 'வலுவாக ஆதரிக்கப்படுகிறது — நிலையான முயற்சியுடன் சாதகமான முடிவுகள் கிடைக்க வாய்ப்புள்ளது.';

  @override
  String get sumGradePhraseGood => 'நன்கு ஆதரிக்கப்படுகிறது — சிறிது கவனத்துடன் பொதுவாக நேர்மறையான முடிவுகள்.';

  @override
  String get sumGradePhraseAverage => 'கலப்பு ஆதரவு — முடிவுகள் முயற்சி மற்றும் நேரத்தைப் பொறுத்தது.';

  @override
  String get sumGradePhraseWeak => 'கவனம் தேவை — பொறுமையும் பரிகாரங்களும் இங்கு உதவும்.';

  @override
  String get kDefCombust => 'சூரியனுக்கு மிக அருகில் இருக்கும் ஒரு கிரகம், அதனால் அதன் ஆற்றல் \'எரிந்து\' பலவீனமடைகிறது.';

  @override
  String get kDefRetrograde => 'பின்னோக்கி நகர்வது போல் தோன்றும் ஒரு கிரகம்; அதன் விளைவுகள் உள்நோக்கி திரும்பி தீவிரமடைகின்றன.';

  @override
  String get kDefNakshatra => 'சந்திரனும் கிரகங்களும் பயணிக்கும் 27 நட்சத்திர மண்டலங்களில் ஒன்று.';

  @override
  String get kDefVargottama => 'ஜென்ம ஜாதகத்திலும் (D1) நவாம்சத்திலும் (D9) ஒரே ராசியில் இருக்கும் ஒரு கிரகம் — வலிமையின் அடையாளம்.';

  @override
  String get kDefOwnSign => 'தான் ஆளும் ராசியில் அமர்ந்திருக்கும் ஒரு கிரகம், அங்கு அது வீட்டைப் போல உணர்ந்து நிலையான முடிவுகளை அளிக்கிறது.';

  @override
  String get kDefExalted => 'தனது மிகுந்த வலிமையின் ராசியில் இருக்கும் ஒரு கிரகம், அது சிறந்த முடிவுகளை அளிக்கிறது.';

  @override
  String get kDefDebilitated => 'தனது பலவீனமான ராசியில் இருக்கும் ஒரு கிரகம், அங்கு அது முடிவுகளை அளிக்க போராடுகிறது.';

  @override
  String get kDefMooltrikona => 'ஒரு கிரகத்தின் சொந்த ராசியின் ஒரு சிறப்பு பகுதி, அங்கு அது குறிப்பாக சக்திவாய்ந்ததாக இருக்கும்.';

  @override
  String get kDefAscendant => 'பிறந்த நேரத்தில் கிழக்கு அடிவானத்தில் உதிக்கும் ராசி — லக்னம், ஜாதகத்தின் அடித்தளம்.';

  @override
  String get kDefMahadasha => 'வாழ்க்கையின் நீண்ட காலத்தை வண்ணமயமாக்கும் முக்கிய கிரக காலம்.';

  @override
  String get kDefAntardasha => 'மகாதசைக்குள் இருக்கும் ஒரு துணைக்காலம், அதன் முடிவுகளை நுட்பமாக சரிசெய்கிறது.';

  @override
  String get kDefPada => 'ஒரு கிரகம் அமைந்திருக்கும் நட்சத்திரத்தின் நான்கு பாதங்களில் ஒன்று.';

  @override
  String get kundliAscendantLagna => 'லக்னம் (உதயம்)';

  @override
  String get kundliMoonSignRashi => 'சந்திர ராசி';

  @override
  String get kundliSunSign => 'சூரிய ராசி';

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
  String get aspGrahaBody => 'கிரக பார்வை என்பது ஒரு கிரகம் தன் நிலையிலிருந்து செலுத்தும் பார்வையாகும். ஒவ்வொரு கிரகமும் தன் இடத்திலிருந்து 7வது வீடு/கிரகத்தின் மீது முழு பார்வையை செலுத்துகிறது (நேரடியான, முகம் நோக்கிய தாக்கம்). கூடுதலாக, செவ்வாய் 4வது மற்றும் 8வது மீதும், குரு 5வது மற்றும் 9வது மீதும், சனி 3வது மற்றும் 10வது மீதும் பார்வை செலுத்துகிறது. ராகு மற்றும் கேது பொதுவாக 5, 7, 9 ஆகிய பார்வைகளைப் பெறுகின்றன. ஒரு கிரகத்தின் பார்வை அது விழும் கிரகம் அல்லது வீட்டிற்கு தன் இயல்பின் நிறத்தை ஏற்றுகிறது.';

  @override
  String get aspRashiBody => 'ராசி பார்வை என்பது ஜைமினி ஜோதிடத்தில் இருந்து வரும் ராசி-க்கு-ராசி பார்வையாகும், அது அங்கு எந்த கிரகங்கள் இருக்கின்றன என்பதைச் சாராது. சர ராசிகள் நிலை ராசிகளைப் பார்க்கும் (அருகிலுள்ளதைத் தவிர), நிலை ராசிகள் சர ராசிகளைப் பார்க்கும் (அருகிலுள்ளதைத் தவிர), மற்றும் உபய ராசிகள் மற்ற உபய ராசிகளைப் பார்க்கும். இது முக்கியமாக ஜைமினி பலன் கூறுதலிலும், வீடுகளுக்கு இடையேயான தொடர்பை மதிப்பிடவும் பயன்படுத்தப்படுகிறது.';

  @override
  String get aspDiffBody => 'கிரக பார்வை ஒரு கிரகத்தால் செலுத்தப்படுகிறது, அது அந்த கிரகம் எங்கு உள்ளது என்பதைப் பொறுத்தது. ராசி பார்வை ராசிக்கே சொந்தமானது, அதில் எது வைக்கப்பட்டிருந்தாலும் அதற்குப் பொருந்தும். கிரக பார்வை திசைசார்ந்தது (கிரகம் A கிரகம் B-ஐ பார்க்கிறது), ராசி பார்வை பொதுவாக ராசிகளுக்கு இடையே பரஸ்பரமானது. இரண்டும் ஒரே இலக்கை சுட்டும் போது, தாக்கம் குறிப்பாக வலுவாக இருக்கும்.';

  @override
  String get aspPredictBody => 'ஒரு பார்வை, ஒரு கிரகம் தன் சொந்த வீட்டிற்கு அப்பால் தன் தாக்கத்தை எங்கு விரிவுபடுத்துகிறது என்பதைக் காட்டுகிறது. ஒரு நல்ல பார்வை (குரு, சுக்கிரன், நன்கு அமைந்த சந்திரன்/புதன்) இலக்கை ஆதரித்து பாதுகாக்கிறது; ஒரு தீய பார்வை (சனி, செவ்வாய், சூரியன், ராகு, கேது) அதன் மீது அழுத்தம், தாமதம் அல்லது சவால் ஏற்படுத்தலாம். எந்த கிரகங்கள் ஒரு வீடு அல்லது கிரகத்தை பார்க்கின்றன என்பதைப் படிப்பது, முடிவுகள் ஏன் அவ்வாறு தோன்றுகின்றன என்பதை விளக்குகிறது.';

  @override
  String get aspTraitSun => 'அதிகாரம், தலைமைத்துவம் மற்றும் உயிர்ச்சக்தி';

  @override
  String get aspTraitMoon => 'உணர்வுப் பூர்வமான ஆழம், ஆறுதல் மற்றும் உள்ளுணர்வு';

  @override
  String get aspTraitMars => 'ஆற்றல், தைரியம் மற்றும் உந்துவிசை';

  @override
  String get aspTraitMercury => 'தொடர்பாடல், அறிவு மற்றும் தகவமைப்புத் திறன்';

  @override
  String get aspTraitJupiter => 'ஞானம், வளர்ச்சி மற்றும் நல்வாய்ப்பு';

  @override
  String get aspTraitVenus => 'காதல், இணக்கம் மற்றும் இன்பங்கள்';

  @override
  String get aspTraitSaturn => 'ஒழுக்கம், பொறுப்பு மற்றும் பொறுமையான, சில நேரங்களில் தாமதமான, வெற்றி';

  @override
  String get aspTraitRahu => 'லட்சியம், தீவிரம் மற்றும் மரபுசாராத திருப்பங்கள்';

  @override
  String get aspTraitKetu => 'பற்றின்மை, ஆன்மீகம் மற்றும் திடீர் மாற்றம்';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '${planet} ${targets}-ஐ பாதிக்கிறது. இது இந்த கிரகங்கள் குறிக்கும் பகுதிகளில் ${trait} கொண்டு வரலாம்.';
  }

  @override
  String aspAiNone(Object planet) {
    return '${planet} இங்கு வேறு எந்த கிரகத்தின் மீதும் சிறப்புப் பார்வையை செலுத்தவில்லை; இதன் தாக்கம் முக்கியமாக அதன் சொந்த ராசி மற்றும் வீட்டின் மூலமே செயல்படுகிறது.';
  }

  @override
  String get grahaDrishti => 'க்ரக திருஷ்டி (கிரக பார்வைகள்)';

  @override
  String get rashiDrishti => 'ராசி திருஷ்டி (ராசி பார்வைகள்)';

  @override
  String get grahaDrishtiSubtitle => 'யார் யாரை பார்க்கிறார்கள் (%)';

  @override
  String get lagnaAspectsReceived => 'லக்னம் பெறும் பார்வைகள்';

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
  String get avABody => 'அஷ்டகவர்க்கம் என்பது வேத ஜோதிடத்தில் மதிப்பெண்களை அடிப்படையாகக் கொண்ட ஒரு வலிமை அமைப்பு ஆகும். ஒவ்வொரு கிரகமும் தனது நிலைப்பாட்டைப் பொறுத்து பன்னிரண்டு ராசிகளுக்கும் சுப மதிப்பெண்களை (பிந்து, ரேகை என்றும் அழைக்கப்படும்) வழங்குகிறது. ஒரு ராசியில் அதிக மதிப்பெண் இருந்தால், அதனுடன் தொடர்புடைய கிரக தசை மற்றும் கோச்சாரங்களின் போது வாழ்க்கையின் அந்தப் பகுதி மென்மையான ஆதரவைப் பெறும்.';

  @override
  String get avSavBody => 'SAV (சர்வ அஷ்டகவர்க்கம்) ஒவ்வொரு ராசிக்கும் ஏழு கிரகங்களின் மதிப்பெண்களைச் சேர்க்கிறது. இது ஒவ்வொரு ராசிக்கும் ஒரே ஒரு வலிமை மதிப்பெண்ணைத் தருகிறது, இதனால் உங்கள் ஜாதகத்தில் எந்த ராசிகள் — மற்றும் அவை அமைந்துள்ள பாவங்கள் — அதிக ஆதரவைப் பெறுகின்றன என்பதை நீங்கள் விரைவாகக் காணலாம்.';

  @override
  String get avBavBody => 'BAV (பின்ன அஷ்டகவர்க்கம்) ஒரு தனி கிரகத்தின் மதிப்பெண்களை பன்னிரண்டு ராசிகளிலும் காட்டுகிறது. இது ஒரு குறிப்பிட்ட கிரகம் எந்த ராசிகளுக்கு அதிக ஆதரவு தருகிறது என்பதைக் காட்டுகிறது, அந்த கிரகத்தின் தசை அல்லது கோச்சாரம் செயலில் இருக்கும்போது இது முக்கியமாகிறது.';

  @override
  String get avHowToReadBody => 'அதிக எண்கள் சிறந்தவை. SAV-க்கு, சராசரி ராசி சுமார் 28 மதிப்பெண்களைப் பெறும் — 30-க்கு மேல் வலிமையானது, 25-க்கு கீழ் கவனம் தேவை. BAV-க்கு, ஒவ்வொரு ராசியும் 0 முதல் 8 வரை இருக்கும், 4 சராசரியாகக் கருதப்படுகிறது. முக்கியமான செயல்களுக்கு உங்கள் வலிமையான ராசிகளுக்கு முன்னுரிமை கொடுங்கள், மேலும் உங்கள் பலவீனமான ராசிகளின் விஷயங்களில் பொறுமையாகவும் ஒழுக்கமாகவும் இருங்கள்.';

  @override
  String get avSavVsBavBody => 'SAV என்பது அனைத்து கிரகங்களின் இணைந்த மொத்தம் ஆகும், இது ஒரு ராசியின் ஒட்டுமொத்த வலிமையைக் காட்டுகிறது. BAV என்பது ஒரு தனி கிரகத்தின் பங்களிப்பு ஆகும், இது எந்த கிரகம் அந்த ராசிக்கு ஆதரவு தருகிறது என்பதைக் காட்டுகிறது. பெரிய படத்தைப் புரிந்துகொள்ள SAV-ஐப் பயன்படுத்துங்கள், எந்த கிரகம் ராசியின் வலிமையை இயக்குகிறது என்பதைப் புரிந்துகொள்ள BAV-ஐப் பாருங்கள்.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'உங்கள் ஜாதகம் ${s1}, ${s2} மற்றும் ${s3} ராசிகளில் மிகவும் வலிமையானது. இந்த ராசிகள் கிரக தசைகள் மற்றும் கோச்சாரங்களின் போது சிறந்த ஆதரவைத் தருகின்றன. ${weak} தற்போது மிகக் குறைந்த ஆதரவைப் பெற்றுள்ளது, எனவே இதனுடன் தொடர்புடைய விஷயங்களில் பொறுமையும் ஒழுக்கமும் உதவும்.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '${planet} ${s1} மற்றும் ${s2} மூலம் மிகச் சிறப்பாகச் செயல்படுகிறது. இந்த ராசிகள் செயல்பாட்டில் இருக்கும்போது ${planet} கட்டுப்படுத்தும் விஷயங்கள் மேம்படுகின்றன.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'உங்கள் வலிமையான ராசிகள் ${s1} மற்றும் ${s2} — கிரகங்கள் இவற்றின் வழியாக கோச்சாரம் செய்யும்போது முக்கியமான தொடக்கங்களுக்கு இவற்றுக்கு முன்னுரிமை கொடுங்கள்.';
  }

  @override
  String avInsightWeak(Object s1) {
    return '${s1}-க்கு மிகக் குறைந்த ஆதரவு உள்ளது — அதன் விஷயங்களில் கவனமாக செயல்படுங்கள், அதிக அளவு உறுதிமொழிகளைத் தவிருங்கள்.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '${planet}-க்கு அதிக மதிப்பெண்கள் உள்ளன, எனவே அதன் அம்சங்கள் உங்கள் வாழ்க்கையில் நன்கு ஆதரிக்கப்படுகின்றன.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '${planet}-க்கு மிகக் குறைந்த மதிப்பெண்கள் உள்ளன, மேலும் பரிகாரங்கள் மற்றும் சிந்தனையுடன் கூடிய முயற்சியால் அதிக பயன் பெறுகிறது.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'உங்கள் சராசரியான ${avg} மதிப்பெண்களுக்கு மேல் மதிப்பெண் பெறும் ராசிகள் பொதுவாக மென்மையான, நம்பகமான முடிவுகளைத் தருகின்றன.';
  }

  @override
  String get gradeExcellent => 'சிறந்தது';

  @override
  String get gradeGood => 'நல்லது';

  @override
  String get gradeAverage => 'சராசரி';

  @override
  String get gradeWeak => 'பலவீனம்';

  @override
  String get careerWord => 'தொழில்';

  @override
  String get educationWord => 'கல்வி';

  @override
  String get lifeAreaMarriage => 'திருமணம்';

  @override
  String get sarvaAshtakavarga => 'சர்வ அஷ்டகவர்கம் (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'மொத்தம்: ${total} ரேகைகள் (சராசரி ராசி = ${avg})';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '${planet} — BAV';
  }

  @override
  String get forecast => 'முன்னறிவிப்பு';

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
  String get best => 'சிறந்த';

  @override
  String get worst => 'மோசமான';

  @override
  String get avg => 'avg';

  @override
  String get love => 'காதல்';

  @override
  String get spiritual => 'ஆன்மீக';

  @override
  String get analysisConfidence => 'பகுப்பாய்வு நம்பகத்தன்மை';

  @override
  String get areasForGrowth => 'வளர்ச்சிக்கான பகுதிகள்';

  @override
  String get astrologicalRemedies => 'ஜோதிட பரிகாரங்கள்';

  @override
  String get bestIndustries => 'சிறந்த தொழில்துறைகள்';

  @override
  String get burnoutRisk => 'சோர்வு அபாயம்';

  @override
  String get careerAnalysis => 'தொழில் பகுப்பாய்வு';

  @override
  String get careerArchetype => 'தொழில் மாதிரி';

  @override
  String get careerRisks => 'தொழில் அபாயங்கள்';

  @override
  String get careerStagnation => 'தொழில் தேக்கம்';

  @override
  String get clarity => 'தெளிவு';

  @override
  String get copyFullReport => 'முழு அறிக்கை தரவை நகலெடு';

  @override
  String get d9Dignity => 'D9 கௌரவம்';

  @override
  String get divisionalValidation => 'வர்க்க சரிபார்ப்பு';

  @override
  String get employment => 'வேலைவாய்ப்பு';

  @override
  String get entrepreneurship => 'தொழில்முனைவு';

  @override
  String get fitScore => 'பொருத்த மதிப்பெண்';

  @override
  String get freelance => 'சுயதொழில்';

  @override
  String get growth => 'வளர்ச்சி';

  @override
  String get houseAnalysis => 'பாவ பகுப்பாய்வு';

  @override
  String get idealEnvironment => 'சிறந்த சூழல்';

  @override
  String get idealOrgSize => 'சிறந்த நிறுவன அளவு';

  @override
  String get jaiminiKarakas => 'ஜைமினி காரகர்கள்';

  @override
  String get lagnaLord => 'லக்ன அதிபதி';

  @override
  String get launchWindows => 'தொடக்க காலம்';

  @override
  String get lord => 'அதிபதி';

  @override
  String get lordDignity => 'அதிபதி கௌரவம்';

  @override
  String get lordPlacedIn => 'அதிபதி அமைந்துள்ள இடம்';

  @override
  String get overallStrength => 'மொத்த பலம்';

  @override
  String get peakWindows => 'உச்ச காலம்';

  @override
  String get portfolio => 'போர்ட்ஃபோலியோ';

  @override
  String get practicalSolutions => 'நடைமுறை தீர்வுகள்';

  @override
  String get promotionWindows => 'பதவி உயர்வு காலம்';

  @override
  String get recognition => 'அங்கீகாரம்';

  @override
  String get recommended => 'பரிந்துரைக்கப்பட்டது';

  @override
  String get riskWindows => 'அபாய காலம்';

  @override
  String get satisfaction => 'திருப்தி';

  @override
  String get stability => 'நிலைத்தன்மை';

  @override
  String get teamLeadership => 'குழு தலைமை';

  @override
  String get tenthLord => '10ஆம் அதிபதி';

  @override
  String get timingWindows => 'நேர காலம்';

  @override
  String get verdict => 'தீர்ப்பு';

  @override
  String get workStructure => 'பணி அமைப்பு';

  @override
  String get workplaceConflict => 'பணியிட மோதல்';

  @override
  String get mitigationLabel => 'தணிப்பு';

  @override
  String get reliabilityVeryHigh => 'மிக அதிக நம்பகத்தன்மை';

  @override
  String get reliabilityHigh => 'அதிக நம்பகத்தன்மை';

  @override
  String get reliabilityModerate => 'மிதமான நம்பகத்தன்மை';

  @override
  String get reliabilityGuidance => 'வழிகாட்டுதல் அளவு விளக்கம்';

  @override
  String get relationshipTitlePrefix => 'உறவு';

  @override
  String get relationshipTitleSuffix => 'நுண்ணறிவு';

  @override
  String get relationshipIntelBannerLabel => 'உறவு நுண்ணறிவு';

  @override
  String get typeLabel => 'வகை';

  @override
  String get trustLabel => 'நம்பிக்கை';

  @override
  String get dhokaRiskLabel => 'துரோக அபாயம்';

  @override
  String powerLabel(Object power) {
    return 'சக்தி: ${power}';
  }

  @override
  String get chartProfilesPrefix => 'ஜாதக';

  @override
  String get chartProfilesSuffix => 'விவரங்கள்';

  @override
  String lagnaSuffixLabel(Object sign) {
    return '${sign} லக்னம்';
  }

  @override
  String get miniIntegrityLabel => 'நேர்மை';

  @override
  String get miniWarmthLabel => 'அன்பு';

  @override
  String get miniTrustLabel => 'நம்பிக்கை';

  @override
  String get miniAssertLabel => 'உறுதி';

  @override
  String akLabel(Object planet) {
    return 'AK: ${planet}';
  }

  @override
  String get pairwisePrefix => 'இணை';

  @override
  String get pairwiseSuffix => 'பகுப்பாய்வு';

  @override
  String trustPercentLabel(Object pct) {
    return 'நம்பிக்கை: ${pct}%';
  }

  @override
  String betrayalPercentLabel(Object pct) {
    return 'துரோகம்: ${pct}%';
  }

  @override
  String get scoreCharacterLabel => 'குணம்';

  @override
  String get scoreLoveLabel => 'காதல்';

  @override
  String get scoreBusinessLabel => 'வணிகம்';

  @override
  String get scoreKarmicLabel => 'கர்ம';

  @override
  String get scoreTrustLabel => 'நம்பிக்கை';

  @override
  String get scoreEnmityRiskLabel => 'பகை அபாயம்';

  @override
  String dynamicLabel(Object value) {
    return 'இயக்கம்: ${value}';
  }

  @override
  String karmicLabel(Object value) {
    return 'கர்ம: ${value}';
  }

  @override
  String get criticalPrefix => 'முக்கிய';

  @override
  String get criticalSuffix => 'வடிவங்கள்';

  @override
  String get groupPrefix => 'குழு';

  @override
  String get groupSuffix => 'பரிந்துரைகள்';

  @override
  String get sharedPracticesLabel => 'பொதுவான பயிற்சிகள்';

  @override
  String communicationLabel(Object value) {
    return 'தொடர்பு: ${value}';
  }

  @override
  String focusLabel(Object value) {
    return 'கவனம்: ${value}';
  }

  @override
  String get individualPrefix => 'தனிநபர்';

  @override
  String get individualSuffix => 'வழிகாட்டுதல்';

  @override
  String karmicLessonLabel(Object value) {
    return 'கர்ம பாடம்: ${value}';
  }

  @override
  String get growthAreasLabel => 'வளர்ச்சி பகுதிகள்';

  @override
  String get corePrefix => 'மைய';

  @override
  String get coreSuffix => 'கருப்பொருள்';

  @override
  String get growthOrientedLabel => 'வளர்ச்சி நோக்கிய';

  @override
  String get groupThemeLabel => 'குழு கருப்பொருள்';

  @override
  String get analysisPrefix => 'பகுப்பாய்வு';

  @override
  String get analysisConfidenceSuffix => 'நம்பகத்தன்மை';

  @override
  String get reportCopied => 'அறிக்கை நகலெடுக்கப்பட்டது!';

  @override
  String get copyFullReportData => 'முழு அறிக்கை தரவை நகலெடு';

  @override
  String get openExternalLabel => 'திற';

  @override
  String copiedOpeningAi(Object ai) {
    return 'நகலெடுக்கப்பட்டது! ${ai} திறக்கிறது...';
  }

  @override
  String get milanTitlePrefix => 'குண்டலி';

  @override
  String get ashtakoot => 'அஷ்டகூடம்';

  @override
  String get compatibilityLabel => 'பொருத்தம்';

  @override
  String get unifiedScoreLabel => 'ஒருங்கிணைந்த\nமதிப்பெண்';

  @override
  String get probabilityLabel => 'நிகழ்தகவு';

  @override
  String ganaLabel(Object value) {
    return 'கணம்: ${value}';
  }

  @override
  String get gunPrefixLabel => '8 குணம்';

  @override
  String get breakdownLabel => 'விவரம்';

  @override
  String get mangalLabel => 'மங்கள்';

  @override
  String severityLabel(Object value) {
    return 'தீவிரம்: ${value}';
  }

  @override
  String get d9Label => 'D-9';

  @override
  String get crossChartLabel => 'குறுக்கு-ஜாதகம்';

  @override
  String get d9CompatibilityLabel => 'D-9 பொருத்தம்';

  @override
  String get domainEmotional => 'உணர்ச்சி';

  @override
  String get domainIntellectual => 'அறிவு';

  @override
  String get domainSpiritual => 'ஆன்மீகம்';

  @override
  String get domainFinancial => 'நிதி';

  @override
  String get domainDomestic => 'குடும்பம்';

  @override
  String get domainCommunication => 'தொடர்பு';

  @override
  String get domainSharedDharma => 'பகிர்ந்த தர்மம்';

  @override
  String get domainFamilyCreation => 'குடும்ப உருவாக்கம்';

  @override
  String get domainLabel => 'துறை';

  @override
  String get compatibilitySuffixLabel => 'பொருத்தம்';

  @override
  String get marriageLabel => 'திருமணம்';

  @override
  String get timingLabel => 'நேரம்';

  @override
  String get jointMarriageWindowsTitle => 'கூட்டு திருமண காலம்';

  @override
  String get engagementWindowsTitle => 'நிச்சயதார்த்த காலம்';

  @override
  String recommendedLabel(Object value) {
    return 'பரிந்துரை: ${value}';
  }

  @override
  String get risksLabel => 'அபாயங்கள்';

  @override
  String get finalLabel => 'இறுதி';

  @override
  String get verdictLabel => 'தீர்ப்பு';

  @override
  String get marriageVerdictLabel => 'திருமண தீர்ப்பு';

  @override
  String get discussReportWithAI => 'இந்த அறிக்கையை AI உடன் விவாதி';

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
  String get participantsLabel => 'பங்கேற்பாளர்கள்';

  @override
  String get reportDataCopied => 'அறிக்கை தரவு நகலெடுக்கப்பட்டது!';

  @override
  String copiedForAi(Object label) {
    return '${label} க்கு நகலெடுக்கப்பட்டது!';
  }

  @override
  String get wealthScoresLabel => 'செல்வ மதிப்பெண்கள்';

  @override
  String get wealthStrengthLabel => 'செல்வ\nபலம்';

  @override
  String get accumulationLabel => 'சேமிப்பு';

  @override
  String get incomeFlowLabel => 'வருமான\nஓட்டம்';

  @override
  String get sustainLabel => 'நிலைத்திருத்தல்';

  @override
  String get multiStreamLabel => 'பல-மூல';

  @override
  String get retentionLabel => 'தக்கவைப்பு';

  @override
  String get wealthLabel => 'செல்வம்';

  @override
  String get karakasLabel => 'காரகர்கள்';

  @override
  String get wealthYogasTitle => 'தன யோகங்கள்';

  @override
  String get drainsLabel => 'வடிகால்கள்';

  @override
  String get boostersLabel => 'ஊக்கிகள்';

  @override
  String get incomeLabel => 'வருமானம்';

  @override
  String get sourcesLabel => 'மூலங்கள்';

  @override
  String get investmentLabel => 'முதலீடு';

  @override
  String get mixLabel => 'கலவை';

  @override
  String get yearlyTrendTitle => 'ஆண்டு போக்கு';

  @override
  String get wealthGrowthTitle => 'செல்வ வளர்ச்சி';

  @override
  String get cashPressureTitle => 'பண அழுத்தம்';

  @override
  String get moneyPersonalityTitle => 'பண ஆளுமை';

  @override
  String get wealthTypeLabel => 'செல்வ வகை';

  @override
  String get riskAppetiteLabel => 'அபாய ஆர்வம்';

  @override
  String get investmentStyleLabel => 'முதலீட்டு பாணி';

  @override
  String get moneyPersonalityLabel => 'பண ஆளுமை';

  @override
  String get spendingLabel => 'செலவு';

  @override
  String get debtProbLabel => 'கடன் நிகழ்தகவு %';

  @override
  String get inheritanceProbLabel => 'வாரிசு %';

  @override
  String get suddenGainsProbLabel => 'திடீர் லாபம் %';

  @override
  String get spouseBoostLabel => 'மனைவி ஊக்கம் %';

  @override
  String successProbabilityLabel(Object pct) {
    return 'வெற்றி நிகழ்தகவு: ${pct}%';
  }

  @override
  String get lifetimeWealthClassLabel => 'வாழ்நாள் செல்வ வகை';

  @override
  String primaryLabel(Object value) {
    return 'முதன்மை: ${value}';
  }

  @override
  String peakAgeLabel(Object value) {
    return 'உச்சம்: ${value}';
  }

  @override
  String drivenByLabel(Object value) {
    return '${value} ஆல் இயக்கப்படுகிறது';
  }

  @override
  String get coreBlockerLabel => 'மைய தடை';

  @override
  String get debtScoresLabel => 'கடன் மதிப்பெண்கள்';

  @override
  String get currentDebtLoadLabel => 'தற்போதைய\nகடன் சுமை';

  @override
  String get recoveryCapacityLabel => 'மீட்பு\nதிறன்';

  @override
  String get intensityLabel => 'தீவிரம்';

  @override
  String get defaultRiskLabel => 'தவறல் அபாயம்';

  @override
  String get debtProfileTitle => 'கடன் விவரம்';

  @override
  String get karmaLabel => 'கர்மா';

  @override
  String get personalityLabel => 'ஆளுமை';

  @override
  String get phaseLabel => 'கட்டம்';

  @override
  String get primaryCategoryLabel => 'முதன்மை வகை';

  @override
  String get debtLabel => 'கடன்';

  @override
  String get debtYogasTitle => 'கடன் யோகங்கள்';

  @override
  String get debtCreatingLabel => 'கடன்-உருவாக்கும்';

  @override
  String get debtClearingLabel => 'கடன்-நீக்கும்';

  @override
  String get categoriesLabel => 'வகைகள்';

  @override
  String get yearlyDebtTitle => 'ஆண்டு கடன்';

  @override
  String get repaymentTitle => 'திருப்பிச் செலுத்தல்';

  @override
  String get dangerPeriodsTitle => 'ஆபத்து காலங்கள்';

  @override
  String get defaultPctLabel => 'தவறல் %';

  @override
  String get bankruptcyPctLabel => 'திவால் %';

  @override
  String get chronicPctLabel => 'நாள்பட்ட %';

  @override
  String get resilienceLabel => 'மீள்திறன்';

  @override
  String recoveryTimelineLabel(Object pct, Object years) {
    return 'மீட்பு: ${pct}% · காலம்: ${years} ஆண்டுகள்';
  }

  @override
  String get debtFreeWindowLabel => 'கடன்-இல்லா காலம்';

  @override
  String yearLabel(Object year) {
    return 'ஆண்டு ${year}';
  }

  @override
  String dashaLabel(Object value) {
    return 'தசை: ${value}';
  }

  @override
  String get marriageScoresLabel => 'திருமண மதிப்பெண்கள்';

  @override
  String get overallMarriageLabel => 'மொத்த\nதிருமணம்';

  @override
  String get maritalHarmonyLabel => 'தாம்பத்திய\nஇணக்கம்';

  @override
  String get domesticStabilityLabel => 'குடும்ப\nநிலைத்தன்மை';

  @override
  String get longevityLabel => 'ஆயுள்';

  @override
  String get satisfactionLabel => 'திருப்தி';

  @override
  String get clarityLabel => 'தெளிவு';

  @override
  String get darakarakaLabel => 'தாராகாரகன்';

  @override
  String get spouseKarakaLabel => 'மனைவி காரகன்';

  @override
  String get darakarakaDkLabel => 'தாராகாரகன் (DK)';

  @override
  String get seventhLabel => '7ஆம்';

  @override
  String get lordLabel => 'அதிபதி';

  @override
  String get lordInLabel => 'அதிபதி அமைவு';

  @override
  String get lordDignityLabel => 'அதிபதி கௌரவம்';

  @override
  String get emptyLabel => 'காலி';

  @override
  String get spouseLabel => 'மனைவி';

  @override
  String get spouseTraitsLabel => 'மனைவி பண்புகள்';

  @override
  String get likelyProfessionsLabel => 'சாத்தியமான தொழில்கள்';

  @override
  String get harmonyPhysicalLabel => 'உடல்';

  @override
  String get sharedValuesLabel => 'பொதுவான மதிப்புகள்';

  @override
  String get conflictResolutionLabel => 'மோதல் தீர்வு';

  @override
  String get harmonyLabel => 'இணக்கம்';

  @override
  String get radarLabel => 'ரேடார்';

  @override
  String get mangalDoshLabel => 'மங்கள் தோஷம்';

  @override
  String severityColonLabel(Object value) {
    return 'தீவிரம்: ${value}';
  }

  @override
  String cancellationColonLabel(Object value) {
    return 'ரத்து: ${value}';
  }

  @override
  String get marriageWindowsTitle => 'திருமண காலம்';

  @override
  String get marriagePhasesTitle => 'திருமண கட்டங்கள்';

  @override
  String get inLawRelationsLabel => 'மைத்துனர் உறவுகள்';

  @override
  String get familyHarmonyLabel => 'குடும்ப இணக்கம்';

  @override
  String get fertilityLabel => 'கருவளம்';

  @override
  String get homeOwnershipLabel => 'வீட்டு உரிமை';

  @override
  String get divorceRiskLabel => 'விவாகரத்து அபாயம்';

  @override
  String get infidelityLabel => 'துரோகம்';

  @override
  String get conflictLabel => 'மோதல்';

  @override
  String get distanceLabel => 'தூரம்';

  @override
  String get seekInPartnerLabel => 'துணையில் தேடுக';

  @override
  String get avoidInPartnerLabel => 'துணையில் தவிர்க்க';

  @override
  String realizationLabel(Object pct) {
    return 'நிறைவேற்றம்: ${pct}%';
  }

  @override
  String get navamsaLabel => 'நவாம்சம்';

  @override
  String get characterScoresLabel => 'குண மதிப்பெண்கள்';

  @override
  String get characterStrengthLabel => 'குண\nபலம்';

  @override
  String get characterIntegrityLabel => 'நேர்மை';

  @override
  String get awarenessLabel => 'விழிப்புணர்வு';

  @override
  String get stabilityLabel => 'நிலைத்தன்மை';

  @override
  String get ethicsLabel => 'நெறிமுறை';

  @override
  String get surfacePersonalityTitle => 'வெளிப்புற ஆளுமை';

  @override
  String get constitutionLabel => 'தேக அமைப்பு';

  @override
  String get nakshatraLabel => 'நட்சத்திரம்';

  @override
  String get deityLabel => 'தெய்வம்';

  @override
  String get moonManasTitle => 'சந்திர மனஸ்';

  @override
  String get warmthLabel => 'அன்பு';

  @override
  String get empathyLabel => 'பச்சாதாபம்';

  @override
  String get loyaltyLabel => 'விசுவாசம்';

  @override
  String get boundariesLabel => 'எல்லைகள்';

  @override
  String get dharmaLabel => 'தர்மம்';

  @override
  String get truthLabel => 'உண்மை';

  @override
  String get compassionLabel => 'கருணை';

  @override
  String get generosityLabel => 'தாராள மனம்';

  @override
  String get signatureVirtuesLabel => 'தனிச்சிறப்பு நற்பண்புகள்';

  @override
  String get naturalTalentsLabel => 'இயற்கை திறமைகள்';

  @override
  String get shadowPatternsLabel => 'நிழல் வடிவங்கள்';

  @override
  String get characterYogasTitle => 'குண யோகங்கள்';

  @override
  String get testsLabel => 'சோதனைகள்';

  @override
  String get giftsLabel => 'வரங்கள்';

  @override
  String get selfAwareEiLabel => 'சுய-விழிப்பு EI';

  @override
  String get selfRegulateLabel => 'சுய-கட்டுப்பாடு';

  @override
  String get empathyEiLabel => 'பச்சாதாப EI';

  @override
  String get socialSkillsLabel => 'சமூக திறன்கள்';

  @override
  String get atmakarakaLabel => 'ஆத்மகாரகன்';

  @override
  String get soulSignatureLabel => 'ஆன்ம அடையாளம்';

  @override
  String get atmakarakaAllCapsLabel => 'ஆத்மகாரகன்';

  @override
  String get gunaLabel => 'குணம்';

  @override
  String dominantColonLabel(Object value) {
    return 'ஆதிக்கம்: ${value}';
  }

  @override
  String get coreGiftLabel => 'மைய வரம்';

  @override
  String get coreThemeAllCapsLabel => 'மைய கருப்பொருள்';

  @override
  String get pastLifeScoresLabel => 'முற்பிறவி மதிப்பெண்கள்';

  @override
  String get signatureStrengthLabel => 'தனிச்சிறப்பு\nபலம்';

  @override
  String get carryForwardLabel => 'எடுத்துச்\nசெல்லல்';

  @override
  String get masteryPreservedLabel => 'தேர்ச்சி\nபாதுகாக்கப்பட்டது';

  @override
  String get unfinishedLabel => 'முடிக்காதது';

  @override
  String get karmicDebtLabel => 'கர்ம கடன்';

  @override
  String get pastMasteryLabel => 'முந்தைய தேர்ச்சி';

  @override
  String get futureGrowthLabel => 'எதிர்கால வளர்ச்சி';

  @override
  String get ketuWhatYouMasteredLabel => 'கேது · நீங்கள் தேர்ச்சி பெற்றது';

  @override
  String get rahuWhatPullsForwardLabel => 'ராகு · உங்களை முன்னோக்கி இழுப்பது';

  @override
  String get pastLifeProfileTitle => 'முற்பிறவி விவரம்';

  @override
  String get themeLabel => 'கருப்பொருள்';

  @override
  String get professionLabel => 'தொழில்';

  @override
  String get socialStandingLabel => 'சமூக அந்தஸ்து';

  @override
  String get regionLabel => 'பகுதி';

  @override
  String get spiritualLevelLabel => 'ஆன்மீக நிலை';

  @override
  String get wealthLevelLabel => 'செல்வ நிலை';

  @override
  String get familyRoleLabel => 'குடும்ப பங்கு';

  @override
  String get skillsCarriedForwardLabel => 'எடுத்துச் செல்லப்பட்ட திறன்கள்';

  @override
  String get naturalAttractionsLabel => 'இயற்கை ஈர்ப்புகள்';

  @override
  String get unexplainedFearsLabel => 'விளக்கமில்லா அச்சங்கள்';

  @override
  String get magneticPullsLabel => 'காந்த ஈர்ப்புகள்';

  @override
  String get relationshipLabel => 'உறவு';

  @override
  String get financialLabel => 'நிதி';

  @override
  String get serviceLabel => 'சேவை';

  @override
  String get dharmicLabel => 'தார்மீக';

  @override
  String get onRelationsLabel => 'உறவுகள் மீது';

  @override
  String get onCareerLabel => 'தொழில் மீது';

  @override
  String get onHealthLabel => 'ஆரோக்கியம் மீது';

  @override
  String get onSpiritualLabel => 'ஆன்மீகம் மீது';

  @override
  String get karmicResolutionTitle => 'கர்ம தீர்வு';

  @override
  String get primaryPathLabel => 'முதன்மை பாதை';

  @override
  String get secondaryPathLabel => 'இரண்டாம் பாதை';

  @override
  String get clearingProgressLabel => 'நீக்கும் முன்னேற்றம்';

  @override
  String get remainingWorkLabel => 'மீதமுள்ள பணி';

  @override
  String get debtTimelineLabel => 'கடன் காலவரிசை';

  @override
  String get memoryAccessLabel => 'நினைவு அணுகல்';

  @override
  String get dreamVisitsLabel => 'கனவு வருகைகள்';

  @override
  String get dejaVuLabel => 'டேஜா வூ';

  @override
  String get regressionFitLabel => 'பிற்செலுத்தல் பொருத்தம்';

  @override
  String get pastLifeActivationTitle => 'முற்பிறவி செயல்படுத்தல்';

  @override
  String maturityStatusLabel(Object score, Object status) {
    return 'முதிர்ச்சி: ${score} · நிலை: ${status}';
  }

  @override
  String shadowColonLabel(Object value) {
    return 'நிழல்: ${value}';
  }

  @override
  String get lifePathScoresLabel => 'வாழ்க்கை பாதை மதிப்பெண்கள்';

  @override
  String get dharmaClarityLabel => 'தர்ம\nதெளிவு';

  @override
  String get fortuneBaselineLabel => 'அதிர்ஷ்ட\nஅடிப்படை';

  @override
  String get lifePathCoherenceLabel => 'வாழ்க்கை பாதை\nஒத்திசைவு';

  @override
  String get karmaAllCapsLabel => 'கர்மா';

  @override
  String get spiritualAllCapsLabel => 'ஆன்மீகம்';

  @override
  String get fameLabel => 'புகழ்';

  @override
  String get lifeLabel => 'வாழ்க்கை';

  @override
  String get archetypeLabel => 'மாதிரி';

  @override
  String get soulContractTitle => 'ஆன்ம ஒப்பந்தம்';

  @override
  String get akFocusLabel => 'AK கவனம்';

  @override
  String get soulPurposeLabel => 'ஆன்ம நோக்கம்';

  @override
  String get lifeChapterLabel => 'வாழ்க்கை அத்தியாயம்';

  @override
  String get primaryDomainLabel => 'முதன்மை துறை';

  @override
  String get leadershipLabel => 'தலைமை';

  @override
  String get wisdomTeachLabel => 'ஞானம்/கற்பித்தல்';

  @override
  String get healingLabel => 'குணப்படுத்தல்';

  @override
  String get fortuneYogasTitle => 'அதிர்ஷ்ட யோகங்கள்';

  @override
  String get luckBlocksLabel => 'அதிர்ஷ்ட தடைகள்';

  @override
  String get fortuneBoostersLabel => 'அதிர்ஷ்ட ஊக்கிகள்';

  @override
  String get fortuneTrendTitle => 'அதிர்ஷ்ட போக்கு';

  @override
  String get goldenWindowsTitle => 'தங்க காலம் ★';

  @override
  String get transformationTitle => 'மாற்றம்';

  @override
  String get lifeMilestonesTitle => 'வாழ்க்கை மைல்கற்கள்';

  @override
  String get destinyVsLabel => 'விதி vs';

  @override
  String get freeWillLabel => 'சுதந்திர விருப்பம்';

  @override
  String get destinyAllCapsLabel => 'விதி';

  @override
  String get freeWillAllCapsLabel => 'சுதந்திர விருப்பம்';

  @override
  String get karmicLessonsTitle => 'கர்ம பாடங்கள்';

  @override
  String get rahuGrowthLabel => 'ராகு வளர்ச்சி';

  @override
  String get ketuSurrenderLabel => 'கேது சரணாகதி';

  @override
  String get saturnLessonLabel => 'சனி பாடம்';

  @override
  String get lifeDifficultyLabel => 'வாழ்க்கை சிரமம்';

  @override
  String get soulCameToExperienceLabel => 'ஆன்மா அனுபவிக்க வந்தது';

  @override
  String get blessingsLabel => 'ஆசீர்வாதங்கள்';

  @override
  String fulfillmentLabel(Object pct) {
    return 'நிறைவேற்றம்: ${pct}%';
  }

  @override
  String get legalScoresLabel => 'சட்ட மதிப்பெண்கள்';

  @override
  String get legalVulnerabilityLabel => 'சட்ட\nபாதிப்புத்தன்மை';

  @override
  String get victoryPotentialLabel => 'வெற்றி\nசாத்தியம்';

  @override
  String get resolutionLabel => 'தீர்வு';

  @override
  String get legalProfileTitle => 'சட்ட விவரம்';

  @override
  String get karmaTypeLabel => 'கர்ம வகை';

  @override
  String get conflictStyleLabel => 'மோதல் பாணி';

  @override
  String get strategyLabel => 'உத்தி';

  @override
  String get caseDurationLabel => 'வழக்கு காலம்';

  @override
  String get currentStatusLabel => 'தற்போதைய நிலை';

  @override
  String get legalLabel => 'சட்டம்';

  @override
  String get legalYogasTitle => 'சட்ட யோகங்கள்';

  @override
  String get disputePressureLabel => 'தகராறு அழுத்தம்';

  @override
  String get legalProtectionLabel => 'சட்ட பாதுகாப்பு';

  @override
  String get victoryLabel => 'வெற்றி';

  @override
  String get asPlaintiffLabel => 'வாதியாக';

  @override
  String get asDefendantLabel => 'பிரதிவாதியாக';

  @override
  String get winProbabilityLabel => 'வெற்றி நிகழ்தகவு';

  @override
  String get disputeLabel => 'தகராறு';

  @override
  String get legalStressTitle => 'சட்ட மன அழுத்தம்';

  @override
  String get visibleEnemiesLabel => 'வெளிப்படை எதிரிகள்';

  @override
  String get hiddenEnemiesLabel => 'மறைமுக எதிரிகள்';

  @override
  String get criminalRiskLabel => 'குற்றவியல் அபாயம்';

  @override
  String get falseAccusationLabel => 'பொய் குற்றச்சாட்டு';

  @override
  String get contractKarmaTitle => 'ஒப்பந்த கர்மா';

  @override
  String get documentationLabel => 'ஆவணப்படுத்தல்';

  @override
  String get finePrintAwareLabel => 'நுண் விவர விழிப்பு';

  @override
  String get negotiationSkillLabel => 'பேச்சுவார்த்தை திறன்';

  @override
  String get signatureCautionLabel => 'கையொப்ப எச்சரிக்கை';

  @override
  String resilienceColonLabel(Object value) {
    return 'மீள்திறன்: ${value}/100';
  }

  @override
  String get healthScoresLabel => 'ஆரோக்கிய மதிப்பெண்கள்';

  @override
  String get vitalityLabel => 'உயிர்ச்சக்தி';

  @override
  String get immunityLabel => 'நோய் எதிர்ப்பு';

  @override
  String get recoveryLabel => 'மீட்பு';

  @override
  String get mentalLabel => 'மனநிலை';

  @override
  String get stressTolLabel => 'அழுத்த சகிப்பு';

  @override
  String get ayurvedicLabel => 'ஆயுர்வேத';

  @override
  String get constitutionTitleLabel => 'தேக அமைப்பு';

  @override
  String secondaryColonLabel(Object value) {
    return 'இரண்டாம்: ${value}';
  }

  @override
  String get bodyLabel => 'உடல்';

  @override
  String get systemMapLabel => 'அமைப்பு வரைபடம்';

  @override
  String get healthYogasTitle => 'ஆரோக்கிய யோகங்கள்';

  @override
  String get diseasePressureLabel => 'நோய் அழுத்தம்';

  @override
  String get protectiveLabel => 'பாதுகாப்பு';

  @override
  String get bodyZoneLabel => 'உடல் மண்டலம்';

  @override
  String get vulnerabilityLabel => 'பாதிப்புத்தன்மை';

  @override
  String get diseaseLabel => 'நோய்';

  @override
  String get susceptibilityLabel => 'எளிதில் பாதிப்பு';

  @override
  String get healthTrendTitle => 'ஆரோக்கிய போக்கு';

  @override
  String get recoveryWindowsTitle => 'மீட்பு காலம்';

  @override
  String get cautionPeriodsTitle => 'எச்சரிக்கை காலங்கள்';

  @override
  String get burnoutRiskLabel => 'சோர்வு அபாயம்';

  @override
  String get addictionVulnLabel => 'அடிமைத்தன பாதிப்பு';

  @override
  String get workLifeBalLabel => 'பணி-வாழ்வு சமநிலை';

  @override
  String get lifestyleFactorsTitle => 'வாழ்க்கை முறை காரணிகள்';

  @override
  String get sleepDisciplineLabel => 'தூக்க ஒழுங்கு';

  @override
  String get dietDisciplineLabel => 'உணவு ஒழுங்கு';

  @override
  String get exerciseNeedLabel => 'உடற்பயிற்சி தேவை';

  @override
  String get sunlightNeedLabel => 'சூரிய ஒளி தேவை';

  @override
  String get socialTypeLabel => 'சமூக வகை';

  @override
  String get healingSpeedLabel => 'குணப்படும் வேகம்';

  @override
  String get mentalScoresLabel => 'மன மதிப்பெண்கள்';

  @override
  String get mentalStabilityLabel => 'மன\nநிலைத்தன்மை';

  @override
  String get emotionalBaselineLabel => 'உணர்ச்சி\nஅடிப்படை';

  @override
  String get anxietyLabel => 'பதற்றம்';

  @override
  String get depressionLabel => 'மனச்சோர்வு';

  @override
  String get regulationLabel => 'கட்டுப்பாடு';

  @override
  String get mentalProfileTitle => 'மன விவரம்';

  @override
  String get stressDriverLabel => 'அழுத்த காரணி';

  @override
  String get stabilityAnchorLabel => 'நிலைத்தன்மை நங்கூரம்';

  @override
  String get attachmentStyleLabel => 'பிணைப்பு பாணி';

  @override
  String get burnoutStageLabel => 'சோர்வு கட்டம்';

  @override
  String get mentalTitleLabel => 'மனம்';

  @override
  String get mentalYogasTitle => 'மன யோகங்கள்';

  @override
  String get stressPressureLabel => 'அழுத்த நெருக்கடி';

  @override
  String get stressResponseLabel => 'அழுத்த பதில்';

  @override
  String get anxietyTitleLabel => 'பதற்றம்';

  @override
  String get typesLabel => 'வகைகள்';

  @override
  String get therapyLabel => 'சிகிச்சை';

  @override
  String get modalityFitLabel => 'முறை பொருத்தம்';

  @override
  String get wellnessTrendTitle => 'நல்வாழ்வு போக்கு';

  @override
  String get healthyCopingLabel => 'ஆரோக்கிய சமாளிப்பு';

  @override
  String get unhealthyRisksLabel => 'ஆரோக்கியமற்ற அபாயங்கள்';

  @override
  String get recommendedAlternativesLabel => 'பரிந்துரைக்கப்பட்ட மாற்றுகள்';

  @override
  String get sleepQualityLabel => 'தூக்க தரம்';

  @override
  String get socialSupportLabel => 'சமூக ஆதரவு';

  @override
  String get burnoutVulnLabel => 'சோர்வு பாதிப்பு';

  @override
  String get selfAwarenessLabel => 'சுய-விழிப்புணர்வு';

  @override
  String get authTagline => 'ஜோதிடர்களுக்கான நக்ஷத்ரலாஜி';

  @override
  String get googleSignInNoToken => 'Google உள்நுழைவு: ID டோக்கன் பெறப்படவில்லை. GOOGLE_WEB_CLIENT_ID அமைக்கப்பட்டுள்ளதா மற்றும் google-services.json கட்டமைக்கப்பட்டுள்ளதா என்பதை உறுதிப்படுத்துக.';

  @override
  String googleSignInError(String error) {
    return 'Google உள்நுழைவு பிழை: ${error}';
  }

  @override
  String get orDivider => 'அல்லது';

  @override
  String get register => 'பதிவு செய்க';

  @override
  String get signInWithBiometrics => 'பயோமெட்ரிக்ஸ் மூலம் உள்நுழைக';

  @override
  String get forgotPasswordInstructions => 'மீட்டமைப்பு இணைப்பைப் பெற உங்கள்\nபதிவு செய்யப்பட்ட மின்னஞ்சலை உள்ளிடுக.';

  @override
  String get resendLink => 'இணைப்பை மீண்டும் அனுப்பு';

  @override
  String callJoinedChannel(String channel) {
    return '${channel} சேனலில் இணைந்தது';
  }

  @override
  String get callUserConnected => 'பயனர் இணைந்தார்! அழைப்பு செயலில்';

  @override
  String callConnectionFailed(String reason) {
    return 'இணைப்பு தோல்வி: ${reason}. Agora சான்றுகளைச் சரிபார்க்கவும்.';
  }

  @override
  String callAgoraError(String details) {
    return 'Agora பிழை: ${details}';
  }

  @override
  String callAgoraInitFailed(String error) {
    return 'Agora துவக்கம் தோல்வி: ${error}';
  }

  @override
  String get callWaitingForVideo => 'வீடியோவுக்காக காத்திருக்கிறது...';

  @override
  String get callVideoCall => 'வீடியோ அழைப்பு';

  @override
  String get callVoiceCall => 'குரல் அழைப்பு';

  @override
  String callRateEarning(String rate, String earning) {
    return '${rate}/நிமிடம் • வருவாய்: ${earning}';
  }

  @override
  String get markAllRead => 'அனைத்தையும் படித்ததாகக் குறி';

  @override
  String get noNotificationsYet => 'இதுவரை அறிவிப்புகள் இல்லை';

  @override
  String get pullToRefresh => 'புதுப்பிக்க கீழே இழுக்கவும்';

  @override
  String get justNow => 'இப்போதுதான்';

  @override
  String minutesAgo(int minutes) {
    return '${minutes} நிமிடங்கள் முன்பு';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours} மணி முன்பு';
  }

  @override
  String daysAgo(int days) {
    return '${days} நாட்கள் முன்பு';
  }

  @override
  String get noChartsCreateFirst => 'ஜாதகம் இல்லை. முதலில் ஜாதகம் உருவாக்கவும்.';

  @override
  String get selectBirthChartToAnalyze => 'பகுப்பாய்வு செய்ய ஜாதகத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get unknownName => 'தெரியாதது';

  @override
  String selectRangeCharts(int max) {
    return '2-${max} ஜாதகங்களைத் தேர்ந்தெடுக்கவும்';
  }

  @override
  String selectExactCharts(int max) {
    return '${max} ஜாதகங்களைத் தேர்ந்தெடுக்கவும்';
  }

  @override
  String runningAnalysis(String label) {
    return '${label} பகுப்பாய்வு இயங்குகிறது...';
  }

  @override
  String pickKarmicCharts(int max) {
    return 'கர்ம இணைப்புகளை பகுப்பாய்வு செய்ய 2 முதல் ${max} ஜாதகங்களைத் தேர்ந்தெடுக்கவும்';
  }

  @override
  String get pickMaleFemaleChart => 'ஆண் மற்றும் பெண் ஜாதகத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get analysisFailed => 'பகுப்பாய்வு தோல்வியடைந்தது';

  @override
  String errorWithDetails(String error) {
    return 'பிழை: ${error}';
  }

  @override
  String personNumber(int n) {
    return 'நபர் ${n}';
  }

  @override
  String analyzeNCharts(int count) {
    return '${count} ஜாதகங்களை பகுப்பாய்வு செய்';
  }

  @override
  String get bhavaHouse1 => 'தன்னிலை / உடல்';

  @override
  String get bhavaHouse2 => 'செல்வம் / குடும்பம்';

  @override
  String get bhavaHouse3 => 'உடன்பிறப்பு / தைரியம்';

  @override
  String get bhavaHouse4 => 'இல்லம் / தாய்';

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
  String bhavaSignLord(String sign, String lord) {
    return '${sign} • அதிபதி: ${lord}';
  }

  @override
  String bhavaSavValue(String value) {
    return 'SAV: ${value}';
  }

  @override
  String get today => 'இன்று';

  @override
  String gocharTransitScoresTitle(String date) {
    return 'கோசார (பயண மதிப்பெண்கள்) — ${date}';
  }

  @override
  String gocharNativeMoon(String moonSign) {
    return 'ஜாதக சந்திரன்: ${moonSign}';
  }

  @override
  String get gocharBest => 'சிறந்தது';

  @override
  String get gocharWorst => 'மோசமானது';

  @override
  String get aspectsGrahaDrishtiTitle => 'க்ரக திருஷ்டி (கிரக பார்வைகள்)';

  @override
  String get aspectsGrahaDrishtiSubtitle => 'யார் யாரைப் பார்க்கிறார் (%)';

  @override
  String get aspectsLagnaReceivedTitle => 'லக்னம் பெற்ற பார்வைகள்';

  @override
  String get aspectsRashiDrishtiTitle => 'ராசி திருஷ்டி (ராசி பார்வைகள்)';

  @override
  String get ashtakavargaSavTitle => 'சர்வ அஷ்டகவர்க்கம் (SAV)';

  @override
  String ashtakavargaSavSubtitle(String total, String average) {
    return 'மொத்தம்: ${total} ரேகைகள் (சராசரி ராசி = ${average})';
  }

  @override
  String ashtakavargaPlanetBavTitle(String planet) {
    return '${planet} — BAV';
  }

  @override
  String ashtakavargaPlanetBavSubtitle(String total, String natalScore) {
    return 'மொத்தம்: ${total} ரேகைகள் • ஜாதக ராசியில்: ${natalScore}';
  }

  @override
  String get appName => 'நக்ஷத்ரலாஜி ஆஸ்ட்ரோ';

  @override
  String get astrologerPanel => 'ஜோதிடர் பேனல்';

  @override
  String get home => 'முகப்பு';

  @override
  String get dashboard => 'டாஷ்போர்டு';

  @override
  String get charts => 'ஜாதகங்கள்';

  @override
  String get bookings => 'முன்பதிவுகள்';

  @override
  String get requests => 'கோரிக்கைகள்';

  @override
  String get chats => 'அரட்டை';

  @override
  String get earnings => 'வருமானம்';

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get live => 'நேரலை';

  @override
  String get signIn => 'உள்நுழையவும்';

  @override
  String get createAccount => 'கணக்கை உருவாக்கவும்';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get confirmPassword => 'கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get fullName => 'முழுப்பெயர்';

  @override
  String get phone => 'தொலைபேசி (விரும்பினால்)';

  @override
  String get forgotPassword => 'கடவுச்சொல் மறந்துவிட்டதா?';

  @override
  String get sendResetLink => 'மீட்டமைப்பு இணைப்பை அனுப்பவும்';

  @override
  String get backToSignIn => 'உள்நுழைவுக்குத் திரும்பு';

  @override
  String get dontHaveAccount => 'கணக்கு இல்லையா?';

  @override
  String get alreadyHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா?';

  @override
  String get continueGoogle => 'Google மூலம் தொடரவும்';

  @override
  String get required => 'அவசியம்';

  @override
  String get minSixChars => 'குறைந்தது 6 எழுத்துகள்';

  @override
  String get passwordsMismatch => 'கடவுச்சொற்கள் பொருந்தவில்லை';

  @override
  String get validEmailRequired => 'சரியான மின்னஞ்சல் தேவை';

  @override
  String get loginFailed => 'உள்நுழைவு தோல்வி';

  @override
  String get signupFailed => 'பதிவு தோல்வி';

  @override
  String get todaysEarning => 'இன்றைய வருமானம்';

  @override
  String get walletBalance => 'வாலட்';

  @override
  String get rating => 'மதிப்பீடு';

  @override
  String get totalSessions => 'அமர்வுகள்';

  @override
  String get consultations => 'ஆலோசனைகள்';

  @override
  String get response => 'பதில்';

  @override
  String get online => 'ஆன்லைன்';

  @override
  String get offline => 'ஆஃப்லைன்';

  @override
  String get busy => 'பிஸி';

  @override
  String get goLive => 'நேரலைக்குச் செல்';

  @override
  String get streamTitle => 'ஸ்ட்ரீம் தலைப்பு';

  @override
  String get description => 'விவரம் (விரும்பினால்)';

  @override
  String get start => 'தொடங்கு';

  @override
  String get rashiPredictions => 'ராசி பலன்கள்';

  @override
  String get todaysGochar => 'இன்றைய கோசாரம் அனைத்து 12 ராசிகளுக்கும் — விரிவாகக் காண தட்டவும்';

  @override
  String get recentRequests => 'சமீபத்திய கோரிக்கைகள்';

  @override
  String get noRecentRequests => 'சமீபத்திய கோரிக்கைகள் இல்லை';

  @override
  String get upcoming => 'வரவிருக்கும்';

  @override
  String get viewAll => 'அனைத்தும் காண';

  @override
  String get pending => 'நிலுவையில்';

  @override
  String get accepted => 'ஏற்றுக்கொள்ளப்பட்டது';

  @override
  String get completed => 'முடிவடைந்தது';

  @override
  String get declined => 'நிராகரிக்கப்பட்டது';

  @override
  String get clientCharts => 'வாடிக்கையாளர் ஜாதகங்கள்';

  @override
  String get newChart => 'புதிய ஜாதகம்';

  @override
  String get noChartsCreated => 'இதுவரை ஜாதகம் உருவாக்கப்படவில்லை';

  @override
  String get newClientChart => 'புதிய வாடிக்கையாளர் ஜாதகம்';

  @override
  String get clientBirthDetails => 'வாடிக்கையாளர் பிறப்பு விவரங்கள்';

  @override
  String get clientName => 'வாடிக்கையாளர் பெயர்';

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
  String get birthPlaceHint => 'நகரத்தின் பெயரைத் தட்டச்சு செய்யவும்...';

  @override
  String get generateKundli => 'குண்டலி உருவாக்கு';

  @override
  String get clientChartCreated => 'வாடிக்கையாளர் ஜாதகம் உருவாக்கப்பட்டது!';

  @override
  String get viewKundli => 'குண்டலி காண்க';

  @override
  String get deleteChart => 'ஜாதகத்தை நீக்கவா?';

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
  String get kundli => 'குண்டலி';

  @override
  String get divisions => 'வர்க்கங்கள்';

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
  String get aspects => 'திருஷ்டி';

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
  String get thisMonth => 'இந்த மாதம்';

  @override
  String get statement => 'அறிக்கை';

  @override
  String get all => 'அனைத்தும்';

  @override
  String get credits => 'வரவுகள்';

  @override
  String get withdrawals => 'பணம் எடுப்பு';

  @override
  String get bonus => 'போனஸ்';

  @override
  String get refunds => 'பணத்திரும்பல்';

  @override
  String get requestWithdrawal => 'பணம் எடுக்க கோரிக்கை';

  @override
  String get withdraw => 'பணம் எடு';

  @override
  String get amount => 'தொகை';

  @override
  String get upiId => 'UPI ஐடி';

  @override
  String get bankTransfer => 'வங்கி பரிமாற்றம்';

  @override
  String get accountHolderName => 'கணக்கு வைத்திருப்பவர் பெயர்';

  @override
  String get accountNumber => 'கணக்கு எண்';

  @override
  String get ifscCode => 'IFSC குறியீடு';

  @override
  String get submit => 'சமர்ப்பிக்கவும்';

  @override
  String get noTransactions => 'பரிவர்த்தனைகள் இல்லை';

  @override
  String get withdrawalHistory => 'பணம் எடுப்பு வரலாறு';

  @override
  String get typeGuidance => 'உங்கள் வழிகாட்டுதலை எழுதுங்கள்...';

  @override
  String get sessionEnded => 'அமர்வு முடிந்தது';

  @override
  String get endChat => 'அரட்டையை முடிக்கவா?';

  @override
  String get endChatConfirm => 'இந்த அமர்வை முடிக்க விரும்புகிறீர்களா?';

  @override
  String get activeNow => 'இப்போது செயலில்';

  @override
  String get connecting => 'இணைக்கிறது...';

  @override
  String get clientKundli => 'வாடிக்கையாளர் குண்டலி';

  @override
  String get earned => 'சம்பாதிப்பு';

  @override
  String get connected => 'இணைக்கப்பட்டது';

  @override
  String get endCall => 'அழைப்பை முடி';

  @override
  String get endStream => 'ஸ்ட்ரீமை முடி';

  @override
  String get endStreamConfirm => 'நேரலை ஸ்ட்ரீமை முடிக்கவா?';

  @override
  String get goLiveBtn => 'நேரலைக்குச் செல்';

  @override
  String get viewers => 'பார்வையாளர்கள்';

  @override
  String get peak => 'உச்சம்';

  @override
  String get gifts => 'பரிசுகள்';

  @override
  String get ok => 'சரி';

  @override
  String get cancel => 'ரத்து செய்';

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
  String get logout => 'வெளியேறு';

  @override
  String get selectLanguage => 'மொழியைத் தேர்வு செய்யவும்';

  @override
  String get language => 'மொழி';

  @override
  String get english => 'ஆங்கிலம்';

  @override
  String get kycSubmit => 'KYC சமர்ப்பிக்கவும்';

  @override
  String get kycPending => 'KYC ஆய்வில் உள்ளது';

  @override
  String get kycRejected => 'KYC நிராகரிக்கப்பட்டது';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get biometricLogin => 'பயோமெட்ரிக் உள்நுழைவு';

  @override
  String get editProfile => 'சுயவிவரத்தைத் திருத்து';

  @override
  String get totalCredit => 'மொத்த கிரெடிட்';

  @override
  String get totalDebit => 'மொத்த டெபிட்';

  @override
  String get allTypes => 'அனைத்து வகைகள்';

  @override
  String get prev => 'முந்தைய';

  @override
  String get next => 'அடுத்த';

  @override
  String get page => 'பக்கம்';

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
  String get deptReports => 'துறை அறிக்கைகள்';

  @override
  String get specialistAnalysesDesc => '15 நிபுணர் பகுப்பாய்வுகள் — தொழில், செல்வம், ஆரோக்கியம், காதல் மற்றும் மேலும்';

  @override
  String get matchTwoChartsDesc => 'இரண்டு ஜாதகங்களை பொருத்துங்கள் — அஷ்டகூட், நவாம்சம், கோசர நேரம் மற்றும் மேலும்';

  @override
  String get todaysForecast => 'இன்றைய முன்னறிவிப்பு';

  @override
  String get dailyProbability => 'எந்த ஜாதகத்திற்கும் தினசரி நிகழ்தகவு முன்னறிவிப்பு';

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
  String get decline => 'மறுப்பு';

  @override
  String get accept => 'ஏற்றுக்கொள்';

  @override
  String get endSession => 'அமர்வு முடி';

  @override
  String get enterChat => 'அரட்டையில் நுழை';

  @override
  String get inProgress => 'நடைபெறுகிறது';

  @override
  String get requestDeclined => 'கோரிக்கை நிராகரிக்கப்பட்டது';

  @override
  String get noRequests => 'கோரிக்கைகள் இல்லை';

  @override
  String get tapViewChat => 'அரட்டை வரலாற்றைக் காண தட்டவும்';

  @override
  String get tapViewCall => 'அழைப்பு விவரங்களைக் காண தட்டவும்';

  @override
  String get consultation => 'ஆலோசனை';

  @override
  String get charged => 'கட்டணம்';

  @override
  String get messages => 'செய்திகள்';

  @override
  String get duration => 'காலம்';

  @override
  String get rate => 'கட்டணம்';

  @override
  String get callDetails => 'அழைப்பு விவரங்கள்';

  @override
  String get yourEarning => 'உங்கள் சம்பாதிப்பு';

  @override
  String get totalCharged => 'மொத்த கட்டணம்';

  @override
  String get activeDoshas => 'செயலில் உள்ள தோஷங்கள்';

  @override
  String get activeYogas => 'செயலில் உள்ள யோகங்கள்';

  @override
  String get allDoshas => 'அனைத்து தோஷங்கள்';

  @override
  String get areasToNurture => 'வளர்க்க வேண்டிய பகுதிகள்';

  @override
  String get basedOnPlanetStrengths => 'கிரக பலங்களை அடிப்படையாகக் கொண்டது';

  @override
  String get basedOnTransits => 'தற்போதைய பயணங்களை அடிப்படையாகக் கொண்டது';

  @override
  String get basis => 'அடிப்படை';

  @override
  String get beneficAspects => 'சுப பார்வைகள்';

  @override
  String get bestWindows => 'சிறந்த காலம்';

  @override
  String get bhakootAxis => 'பகூட அச்சு';

  @override
  String get cancellation => 'ரத்து';

  @override
  String get cancellationFactors => 'ரத்து காரணிகள்';

  @override
  String get cancellations => 'ரத்துகள்';

  @override
  String get challengingPeriods => 'சவால் நிறைந்த காலங்கள்';

  @override
  String get characterOverview => 'குண மேலோட்டம்';

  @override
  String get combinedFertility => 'ஒருங்கிணைந்த கருவளம்';

  @override
  String get combust => 'அஸ்தமனம்';

  @override
  String get confidence => 'நம்பகத்தன்மை';

  @override
  String get contact => 'தொடர்பு';

  @override
  String get copy => 'நகலெடு';

  @override
  String get currentPlanetPositions => 'தற்போதைய கிரக நிலைகள்';

  @override
  String get d7Saptamsa => 'D7 சப்தாம்சம்';

  @override
  String get dashaSync => 'தசை ஒத்திசைவு';

  @override
  String get daughter => 'மகள்';

  @override
  String get debilitated => 'நீசம்';

  @override
  String get detailedSummary => 'விரிவான சுருக்கம்';

  @override
  String get discussWithAI => 'AI உடன் விவாதி';

  @override
  String get dominantPlanet => 'ஆதிக்க கிரகம்';

  @override
  String get effect => 'விளைவு';

  @override
  String get exalted => 'உச்சம்';

  @override
  String get factors => 'காரணிகள்';

  @override
  String get favorablePeriodAdvice => 'சாதகமான காலம்';

  @override
  String get favorablePeriods => 'சாதகமான காலங்கள்';

  @override
  String get genderExplanation => 'பாலின விளக்கம்';

  @override
  String get genderTendency => 'பாலின போக்கு';

  @override
  String get grantPermissions => 'அனுமதிகளை வழங்கு';

  @override
  String get health => 'மொத்த ஆரோக்கியம்';

  @override
  String get herMoon => 'அவளின் சந்திரன்';

  @override
  String get hisMoon => 'அவனின் சந்திரன்';

  @override
  String get house => 'பாவம்';

  @override
  String get inFifth => '5ஆம் இடத்தில்';

  @override
  String get ketuContacts => 'கேது தொடர்புகள்';

  @override
  String get key => 'முக்கியம்';

  @override
  String get keyHouses => 'முக்கிய பாவங்கள்';

  @override
  String get keyInsights => 'முக்கிய நுண்ணறிவுகள்';

  @override
  String get keyPlanets => 'முக்கிய கிரகங்கள்';

  @override
  String get kundliMilan => 'குண்டலி மிலன்';

  @override
  String get lifeAreaPredictions => 'வாழ்க்கை பகுதி கணிப்புகள்';

  @override
  String get maleficAspects => 'பாப பார்வைகள்';

  @override
  String get manifestation => 'வெளிப்பாடு';

  @override
  String get milan => 'மிலன்';

  @override
  String get mitigation => 'தணிப்பு';

  @override
  String get moonSignCompat => 'ராசி பொருத்தம்';

  @override
  String get nakshatraCompat => 'நட்சத்திர பொருத்தம்';

  @override
  String get navigation => 'வழிசெலுத்தல்';

  @override
  String get nextFavorableWindow => 'அடுத்த சாதகமான காலம்';

  @override
  String get noCharts => 'ஜாதகம் இல்லை';

  @override
  String get noClassicalYogas => 'நிலையான முயற்சியால் வெற்றி கிடைக்கும்.';

  @override
  String get noYogasActive => 'இந்த ஜாதகத்தில் செயலில் யோகங்கள் இல்லை.';

  @override
  String get notesSaved => 'குறிப்புகள் சேமிக்கப்பட்டன';

  @override
  String get numberExplanation => 'எண் விளக்கம்';

  @override
  String get occupants => 'வசிப்பவர்கள்';

  @override
  String get overallVerdict => 'மொத்த தீர்ப்பு';

  @override
  String get overlappingWindows => 'ஒன்றுடன் ஒன்று சேரும் திருமண காலம்';

  @override
  String get past => 'கடந்த';

  @override
  String get pastLifeIndication => 'முற்பிறவி சுட்டிக்காட்டல்';

  @override
  String get planet => 'கிரகம்';

  @override
  String get planetPositions => 'கிரக அமைவுகள்';

  @override
  String get potentialStrengths => 'சாத்தியமான பலங்கள்';

  @override
  String get primaryArchetype => 'முதன்மை மாதிரி';

  @override
  String get probableNumber => 'சாத்தியமான எண்';

  @override
  String get rahuContacts => 'ராகு தொடர்புகள்';

  @override
  String get rashi => 'ராசி கணிப்புகள்';

  @override
  String get recommendations => 'பரிந்துரைகள்';

  @override
  String get relationshipGuidance => 'உறவு வழிகாட்டுதல்';

  @override
  String get remedies => 'பரிகாரம்';

  @override
  String get retrograde => 'வக்ரம்';

  @override
  String get ruledBy => 'ஆளுநர்';

  @override
  String get running => 'இயங்குகிறது';

  @override
  String get scoreComponents => 'மதிப்பெண் கூறுகள்';

  @override
  String get selectChartsForMilan => '2 ஜாதகங்களைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectMultiCharts => 'ஜாதகங்களைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectTwoCharts => 'பொருத்துவதற்கு 2 ஜாதகங்களைத் தேர்ந்தெடுக்கவும்';

  @override
  String get sign => 'ராசி';

  @override
  String get son => 'மகன்';

  @override
  String get soulCareerAlign => 'ஆன்மா ↔ தொழில் ஒத்திசைவு';

  @override
  String get startKundliMilan => 'குண்டலி மிலன் தொடங்கு';

  @override
  String get startSession => 'அமர்வைத் தொடங்கு';

  @override
  String get strength => 'பலம்';

  @override
  String get strengths => 'பலங்கள்';

  @override
  String get todaysTransitChart => 'பயண ஜாதகம்';

  @override
  String get topActiveDoshas => 'முதன்மை செயல் தோஷங்கள்';

  @override
  String get topOpportunities => 'முதன்மை பகுதிகள்';

  @override
  String get topRisks => 'முதன்மை அபாயங்கள்';

  @override
  String get totalChallengePenalty => 'மொத்த சவால் அபராதம்';

  @override
  String get totalDoshaPenalty => 'மொத்த தோஷ அபராதம்';

  @override
  String get transitMarriageWindows => 'பயண திருமண காலம்';

  @override
  String get value => 'மதிப்பு';

  @override
  String get vargottama => 'வர்கோத்தமம்';

  @override
  String get venusContacts => 'சுக்கிர தொடர்புகள்';

  @override
  String get weaknesses => 'பலவீனங்கள்';

  @override
  String get worstWindows => 'மோசமான காலம்';

  @override
  String get yogaAnalysis => 'யோக பகுப்பாய்வு';

  @override
  String get unlocked => 'திறக்கப்பட்டது!';

  @override
  String get lessThanOneMin => '1 நிமிடத்திற்கும் குறைவாக உள்ளது';
}
