// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

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
    return 'மேலோங்கியது: ${value}';
  }

  @override
  String get karakasSuffix => 'காரகர்கள்';

  @override
  String get protectiveLabel => 'பாதுகாப்பு';

  @override
  String secondaryLabel(Object value) {
    return ' · இரண்டாம்: ${value}';
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
    return 'மீட்பு: ${pct}% · காலவரிசை: ${years}ஆண்டுகள்';
  }

  @override
  String get debtFreeWindowLabel => '🎯 கடனற்ற காலம்';

  @override
  String debtFreeYear(Object year) {
    return '${year} ஆம் ஆண்டு';
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
    return 'தாங்கும் திறன்: ${pct}/100';
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
    return 'நிறைவேற்றம்: ${pct}%';
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
    return 'முதிர்ச்சி: ${maturity} · நிலை: ${status}';
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
    return '⚠ நிழல்: ${shadow}';
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
  String get mentalRecommendedAlternativesTitle => '✦ பரிந்துரைக்கப்பட்ட மாற்றுகள்';

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
    return 'உணர்தல்: ${pct}%';
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
    return 'வெற்றி நிகழ்தகவு: ${pct}%';
  }

  @override
  String get wealthLifetimeClassLabel => 'வாழ்நாள் செல்வ வகுப்பு';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'முதன்மை: ${value}';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'உச்சம்: ${value}';
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
    return '${planet} இயக்கும்';
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
    return 'உணர்தல்: ${pct}%';
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
    return 'தீவிரம்: ${value}';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'நீக்கம்: ${value}';
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
    return 'இந்த வேத ஜோதிட அறிக்கையை பகுப்பாய்வு செய்து விரிவான பார்வைகளை வழங்கவும்:\n\n${formatted}';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'இதோ ஒரு வேத ஜோதிட நிபுணர் அறிக்கை. தயவுசெய்து இதை முழுமையாக பகுப்பாய்வு செய்து செயல்படுத்தக்கூடிய பார்வைகளை வழங்கவும்:\n\n${formatted}';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'இந்த வேத ஜோதிட பகுப்பாய்வை மதிப்பாய்வு செய்து முக்கிய கண்டுபிடிப்புகளை எளிய மொழியில் விளக்கவும்:\n\n${formatted}';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return '${label}க்கு நகலெடுக்கப்பட்டது!';
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
    return '${sign} இல் குரு';
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
    return '${name}க்கு நகலெடுக்கப்பட்டது!';
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
    return 'காரணி: ${factor}';
  }

  @override
  String appliesToLabel(String value) {
    return 'பொருந்துவது: ${value}';
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
    return 'இணைப்பு காரணிகள் (${count} செயலில்)';
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
    return 'மூல தசை: ${value}';
  }

  @override
  String get karmaSharedLessonHeader => 'பகிர்ந்த குழு பாடம்';

  @override
  String get karmaMutualTeachingHeader => 'பரஸ்பர கற்பித்தல் வரைபடம்';

  @override
  String get karmaTeachingDynamicsPlaceholder => 'கர்ம தொடர்புகள் ஆழமடையும் போது கற்பித்தல் இயக்கங்கள் வெளிப்படும்.';

  @override
  String get typeFieldLabel => 'வகை';

  @override
  String get basisFieldLabel => 'அடிப்படை';

  @override
  String get resolutionPathHeader => 'தீர்வு பாதை';

  @override
  String dashaTimingPrefix(String value) {
    return 'தசை காலம்: ${value}';
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
    return '${count} அளவுருக்கள் தணிக்கை செய்யப்பட்டன';
  }

  @override
  String get valuePrefixLabel => 'மதிப்பு: ';

  @override
  String weightPrefix(String value) {
    return 'எடை: ${value}';
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
    return 'நிறைவேற்றம்: ${pct}%';
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
    return 'வாழ்நாள் எண்ணிக்கை: ${count} · நிறைவேற்றம்: ${pct}%';
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
    return 'அனைத்து மதிப்பெண்கள் (${count})';
  }

  @override
  String get windowsWord => 'காலங்கள்';

  @override
  String get genericFailedMsg => 'தோல்வி';

  @override
  String get unknownWord => 'தெரியவில்லை';

  @override
  String selectKarmaChartsLabel(int max) {
    return '2-${max} ஜாதகங்களை தேர்ந்தெடுக்கவும்';
  }

  @override
  String selectChartsLabelCount(int max) {
    return '${max} ஜாதகங்களை தேர்ந்தெடுக்கவும்';
  }

  @override
  String runningAnalysisLabel(String label) {
    return '${label} பகுப்பாய்வு இயங்குகிறது...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'கர்ம இணைப்புகளை பகுப்பாய்வு செய்ய 2 முதல் ${max} ஜாதகங்களை தேர்ந்தெடுக்கவும்';
  }

  @override
  String get pickMaleFemaleHint => 'ஆண் மற்றும் பெண் ஜாதகத்தை தேர்ந்தெடுக்கவும்';

  @override
  String get personOneLabel => 'நபர் 1';

  @override
  String get personTwoLabel => 'நபர் 2';

  @override
  String get analysisFailedMsg => 'பகுப்பாய்வு தோல்வியடைந்தது';

  @override
  String analyzeChartsCountLabel(int count) {
    return '${count} ஜாதகங்களை பகுப்பாய்வு செய்';
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
    return '${count} ஜாதகங்களை பகுப்பாய்வு செய்கிறது...';
  }

  @override
  String get relationshipContextLabel => 'உறவு சூழல்';

  @override
  String get kundliMilanReportTitle => 'குண்டலி மிலன் அறிக்கை';

  @override
  String get runningMilanAnalysisLabel => 'மிலன் பகுப்பாய்வு இயங்குகிறது...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '${count}/2 தேர்ந்தெடுக்கப்பட்டது';
  }

  @override
  String get runMilanAnalysisBtn => 'மிலன் பகுப்பாய்வு இயக்கு';

  @override
  String get noChartsCreateFirst => 'ஜாதகங்கள் இல்லை. முதலில் ஜாதகம் உருவாக்கவும்.';

  @override
  String get selectBirthChartAnalyze => 'பகுப்பாய்வு செய்ய ஜாதகம் தேர்ந்தெடுக்கவும்';

  @override
  String get doshAnalysis => 'தோஷ பகுப்பாய்வு';

  @override
  String doshActiveCount(Object active, Object total) {
    return '${active} செயலில் / ${total} சரிபார்க்கப்பட்டது';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '${active} செயலில் / ${total} யோகங்கள் சரிபார்க்கப்பட்டது';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'செயலில் உள்ள யோகங்கள் (${count})';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'செயலற்ற யோகங்களை மறை (${count})';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'செயலற்ற யோகங்களை காட்டு (${count})';
  }

  @override
  String get loadFailed => 'தோல்வி';

  @override
  String dashaDrillMd(Object planet) {
    return '${planet} MD → அந்தர்தசைகள்';
  }

  @override
  String dashaDrillAd(Object planet) {
    return '${planet} AD → பிரத்யந்தர்தசைகள்';
  }

  @override
  String dashaDrillPd(Object planet) {
    return '${planet} PD → சூக்ஷ்மதசைகள்';
  }

  @override
  String dashaDrillSub(Object planet) {
    return '${planet} துணை காலங்கள்';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return 'பிறப்பு அதிபதி: ${lord} • மீதம்: ${balance} ஆண்டுகள்';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'லக்னம்: ${lagna} • மீதம்: ${balance} ஆண்டுகள்';
  }

  @override
  String dashaYearsValue(Object years) {
    return '${years} ஆண்டுகள்';
  }

  @override
  String get dashaCurrentPeriod => 'தற்போதைய தசை காலம்';

  @override
  String dashaAsOf(Object date) {
    return 'தேதி வரை: ${date}';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'தற்போதைய காலத்தில் செயலில் உள்ள யோகங்கள் (${count})';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'தற்போதைய காலத்தில் செயலில் உள்ள தோஷங்கள் (${count})';
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
    return 'தரம்: ${grade}';
  }

  @override
  String get lifeAreaFactorsLabel => 'காரணிகள்:';

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
    return 'எஞ்சின்: ${engine}';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return 'பாகை: ${degree}°  •  நக்ஷத்திரம்: ${nakshatra} (${pada})';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'நக்ஷத்திர அதிபதி: ${lord}  •  பலம்: ${dignity}';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return '${base} ஜாதகம் — ${sign}';
  }

  @override
  String kundliBaseChart(Object base) {
    return '${base} ஜாதகம்';
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
    return 'தசை: ${dasha}';
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
    return '${sign} • அதிபதி: ${lord}';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: ${value}';
  }

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
  String bavSubtitle(Object total, Object score) {
    return 'மொத்தம்: ${total} ரேகைகள் • ஜாதக ராசியில்: ${score}';
  }

  @override
  String get today => 'இன்று';

  @override
  String gocharTransitScores(Object date) {
    return 'கோசாரம் (பயண மதிப்பெண்கள்) — ${date}';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'ஜாதக சந்திரன்: ${sign}';
  }

  @override
  String get gocharBest => 'சிறந்தது';

  @override
  String get gocharWorst => 'மோசம்';

  @override
  String copiedOpening(Object ai) {
    return 'நகலெடுக்கப்பட்டது! ${ai} திறக்கிறது...';
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
  String get reliabilityGoodEdu => 'நல்ல நம்பகத்தன்மை · D-24 சரிபார்க்கப்பட்டது';

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
  String get aiConnectionLost => 'இணைப்பு துண்டிக்கப்பட்டது. மீண்டும் முயற்சிக்கவும்.';

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
    return 'தானாக → ${lang}';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'மொழி: ${lang}';
  }

  @override
  String get aiNoBirthCharts => 'ஜாதகங்கள் எதுவும் இல்லை';

  @override
  String get aiCreateChartFirst => 'AI உடன் அரட்டையடிக்க முதலில் ஜாதகம் உருவாக்கவும்';

  @override
  String get aiSelectChartBegin => 'பகுப்பாய்வு தொடங்க ஜாதகம் தேர்ந்தெடுக்கவும்';

  @override
  String aiAnalyzingName(String name) {
    return 'பகுப்பாய்வு: ${name}';
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
    return 'பிழை: ${error}';
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
    return 'மதிப்புரைகள் (${count})';
  }

  @override
  String get astroNoReviews => 'இதுவரை மதிப்புரைகள் இல்லை';

  @override
  String get astroAnonymous => 'அநாமதேய';

  @override
  String get forgotPasswordSubtitle => 'உங்கள் மின்னஞ்சலை உள்ளிடவும், கடவுச்சொல்லை\nமீட்டமைக்க இணைப்பை அனுப்புவோம்.';

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
  String get phone => 'தொலைபேசி (விருப்பம்)';

  @override
  String get forgotPassword => 'கடவுச்சொல் மறந்துவிட்டதா?';

  @override
  String get bhOverview => 'Overview';

  @override
  String get bhDetailed => 'Detailed';

  @override
  String get bhavaHouses => 'Houses';

  @override
  String get bhStrengthOverview => 'House Strength Overview';

  @override
  String get bhOverallAverage => 'Overall House Average';

  @override
  String get bhStrongestHouse => 'Strongest House';

  @override
  String get bhWeakestHouse => 'Weakest House';

  @override
  String get bhBestArea => 'Best Life Area';

  @override
  String get bhNeedsAttention => 'Needs Attention';

  @override
  String get bhSavContribution => 'SAV Contribution';

  @override
  String get bhLordCondition => 'House Lord Condition';

  @override
  String get bhBenefic => 'Benefic Influence';

  @override
  String get bhMalefic => 'Malefic Influence';

  @override
  String get bhStrengthReasons => 'Why This Score';

  @override
  String get bhGoodEffects => 'Good Effects';

  @override
  String get bhChallenges => 'Challenges';

  @override
  String get bhRemedies => 'Remedies';

  @override
  String get bhRanking => 'House Ranking';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'Explain My Houses';

  @override
  String get bhExplainSubtitle => 'A simple summary of your 12 houses';

  @override
  String bhHeroSummary(Object s1, Object s2, Object strongArea, Object weakArea) {
    return 'Your strongest houses are ${s1} and ${s2}. ${strongArea} is naturally strong, while ${weakArea} needs more effort.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'Its lord ${lord} is placed as ${relation}.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'This house carries ${sav} benefic points (SAV); its occupants and aspects shape the rest of the score.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'When strong, it supports ${meaning}.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'When weak, ${meaning} may need extra effort and care.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'Strengthen its lord ${lord} and honour this house\'s matters to lift it.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'Your ${house} is ${strengthWord}. It governs ${meaning}.';
  }

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
  String get endChatConfirm => 'இந்த அரட்டை அமர்வை நிச்சயமாக முடிக்க விரும்புகிறீர்களா?';

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
  String get astrologerUnavailable => 'ஜோதிடர் கிடைக்கவில்லை. ஸ்ட்ரீம் முடிகிறது.';

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
  String get careerIlluminated => 'உங்கள் தொழில் துறை ஒளிரும் — உங்கள் உள்ளுணர்வை நம்புங்கள்.';

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
  String get chatAppearHere => 'ஜோதிடர்களுடன் உங்கள் உரையாடல்கள் இங்கே தோன்றும்.';

  @override
  String get noCallsYet => 'இன்னும் அழைப்புகள் இல்லை';

  @override
  String get callAppearHere => 'ஜோதிடர்களுடன் உங்கள் அழைப்பு வரலாறு இங்கே தோன்றும்.';

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
  String get basedOnPlanetStrengths => 'கிரக பலங்கள் & பாவ நிலைகளின் அடிப்படையில்';

  @override
  String get basedOnTransits => 'தற்போதைய கிரக கோசாரத்தின் அடிப்படையில்';

  @override
  String get currentPlanetPositions => 'உங்கள் ராசியை 1ம் பாவமாகக் கொண்டு தற்போதைய கிரக நிலைகள்';

  @override
  String get favorablePeriodAdvice => 'சாதகமான காலம் — தொழில் வளர்ச்சி மற்றும் உறவுகளில் கவனம் செலுத்துங்கள்.';

  @override
  String get noClassicalYogas => 'சாஸ்திர கல்வி யோகங்கள் இல்லாமல், வெற்றி நிலையான முயற்சியால் வருகிறது.';

  @override
  String get walletDeduction => 'தொகை உங்கள் வாலட்டிலிருந்து கழிக்கப்படும்';

  @override
  String get bhakootAxis => 'பகூட் அச்சு';

  @override
  String get basis => 'அடிப்படை';

  @override
  String get selectChartsForMilan => 'மிலனுக்கு 2 ஜாதகங்களைத் தேர்ந்தெடுக்கவும்';

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
}
