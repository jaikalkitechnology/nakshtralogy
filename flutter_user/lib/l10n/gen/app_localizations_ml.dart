// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get kunNavamsa => 'നവാംശം (D9)';

  @override
  String get kunD10 => 'ദശാംശം (D10)';

  @override
  String get kunPlacement => 'ഗ്രഹ സ്ഥാനം';

  @override
  String get kunHousesTitle => 'ഭാവ വിവരങ്ങൾ';

  @override
  String get kunPlanet => 'ഗ്രഹം';

  @override
  String get kunNakshatra => 'നക്ഷത്രം';

  @override
  String get kunPada => 'പാദം';

  @override
  String get kunLord => 'അധിപൻ';

  @override
  String get kunExplain => 'എന്റെ ജാതകം വിശദീകരിക്കുക';

  @override
  String get kunExplainSubtitle => 'നിങ്ങളുടെ ജാതകത്തിന്റെ ലളിതമായ സംഗ്രഹം';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return '${ordinal} ഭാവം ${meaning} നിയന്ത്രിക്കുന്നു.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return 'ഇവിടെയുള്ള ${planets} ഇതിന്റെ ഫലങ്ങളെ രൂപപ്പെടുത്തുന്നു.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'നിങ്ങളുടെ ലഗ്നം ${asc} ആണ്, ഇത് നിങ്ങളുടെ വീക്ഷണത്തെയും മറ്റുള്ളവർ നിങ്ങളെ ആദ്യം എങ്ങനെ കാണുന്നു എന്നതിനെയും രൂപപ്പെടുത്തുന്നു.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'നിങ്ങളുടെ മനസ്സും വികാരങ്ങളും ${moon}-ൽ ഉള്ള ചന്ദ്രനെ പിന്തുടരുന്നു.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '${planet} നിങ്ങളുടെ ഏറ്റവും ശക്തമായ ഗ്രഹമാണ് — എളുപ്പവും പിന്തുണയും ഉള്ള സ്വാഭാവിക മേഖല.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '${planet} നിങ്ങളെ ഏറ്റവും കൂടുതൽ പരീക്ഷിക്കുന്ന ഗ്രഹമാണ് — ഇവിടെ ക്ഷമയും പരിശ്രമവും ഫലം നൽകും.';
  }

  @override
  String get plNature => 'Nature';

  @override
  String get plElement => 'Element';

  @override
  String get plGender => 'Gender';

  @override
  String get plKarakatva => 'Karakatva';

  @override
  String get plLordship => 'Lordship';

  @override
  String get plStrength => 'Strength';

  @override
  String get plAspectsGiven => 'Aspects Given';

  @override
  String get plAspectsReceived => 'Aspects Received';

  @override
  String get plConjunction => 'Conjunction';

  @override
  String get plHouseMeaning => 'House Meaning';

  @override
  String get plNakshatraMeaning => 'Nakshatra Meaning';

  @override
  String get plAiInterpretation => 'AI Interpretation';

  @override
  String get plSearchHint => 'Search any planet';

  @override
  String get plNoResults => 'No planets found';

  @override
  String get plBenefic => 'Benefic';

  @override
  String get plMalefic => 'Malefic';

  @override
  String get plMale => 'Male';

  @override
  String get plFemale => 'Female';

  @override
  String get plNeutralGender => 'Neutral';

  @override
  String get plOwnSign => 'Own Sign';

  @override
  String get plFriend => 'Friend Sign';

  @override
  String get plEnemy => 'Enemy Sign';

  @override
  String get plNeutral => 'Neutral';

  @override
  String get sumEther => 'Ether';

  @override
  String plLordOfHouses(Object houses) {
    return 'Lord of house(s) ${houses}';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return 'Ruled by ${nakLord}, bringing ${trait}.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '${planet} sits in ${sign}, in the ${house} house.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'Its core significations — ${karak} — are well supported here.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'Its core significations — ${karak} — may need conscious effort here.';
  }

  @override
  String plAiExalted(Object planet) {
    return '${planet} is exalted, giving its very best results.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '${planet} is debilitated and needs support to deliver its results.';
  }

  @override
  String plAiCombust(Object planet) {
    return '${planet} is combust, so it works less openly under the Sun\'s glare.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '${planet} is vargottama — a strong placement repeated in the navamsa.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '${planet} is retrograde, turning its energy inward and intensifying it.';
  }

  @override
  String get plHouse1 => 'self, body, personality and vitality';

  @override
  String get plHouse2 => 'wealth, family, speech and food';

  @override
  String get plHouse3 => 'courage, siblings, communication and short travels';

  @override
  String get plHouse4 => 'home, mother, comfort, property and inner peace';

  @override
  String get plHouse5 => 'children, creativity, intelligence, romance and past merits';

  @override
  String get plHouse6 => 'health, enemies, debts, service and daily work';

  @override
  String get plHouse7 => 'marriage, partnerships and business relationships';

  @override
  String get plHouse8 => 'longevity, transformation, secrets and inheritance';

  @override
  String get plHouse9 => 'fortune, dharma, higher learning, guru and father';

  @override
  String get plHouse10 => 'career, status, authority and public karma';

  @override
  String get plHouse11 => 'gains, income, friends, network and fulfilled desires';

  @override
  String get plHouse12 => 'loss, expenses, foreign lands, spirituality and liberation';

  @override
  String get sumVeryStrong => 'വളരെ ശക്തം';

  @override
  String get sumStrong => 'ശക്തം';

  @override
  String get sumAverage => 'ശരാശരി';

  @override
  String get sumWeak => 'ദുർബലം';

  @override
  String get sumNeedsAttention => 'ശ്രദ്ധ ആവശ്യമാണ്';

  @override
  String get sumFire => 'അഗ്നി';

  @override
  String get sumEarth => 'ഭൂമി';

  @override
  String get sumAir => 'വായു';

  @override
  String get sumWater => 'ജലം';

  @override
  String get sumMovable => 'ചരം';

  @override
  String get sumFixed => 'സ്ഥിരം';

  @override
  String get sumDual => 'ദ്വിസ്വഭാവം';

  @override
  String get sumDirEast => 'കിഴക്ക്';

  @override
  String get sumDirWest => 'പടിഞ്ഞാറ്';

  @override
  String get sumDirNorth => 'വടക്ക്';

  @override
  String get sumDirSouth => 'തെക്ക്';

  @override
  String get sumDirNE => 'വടക്ക്-കിഴക്ക്';

  @override
  String get sumDirNW => 'വടക്ക്-പടിഞ്ഞാറ്';

  @override
  String get sumDirSE => 'തെക്ക്-കിഴക്ക്';

  @override
  String get sumDirSW => 'തെക്ക്-പടിഞ്ഞാറ്';

  @override
  String get sumSnapshotTitle => 'നിങ്ങളുടെ ജ്യോതിഷ സംഗ്രഹം';

  @override
  String get sumMahadasha => 'മഹാദശ';

  @override
  String get sumAntardasha => 'അന്തർദശ';

  @override
  String get sumNakshatra => 'ജന്മ നക്ഷത്രം';

  @override
  String get sumElement => 'തത്വം';

  @override
  String get sumModality => 'സ്വഭാവം';

  @override
  String get sumLuckyDirection => 'ശുഭ ദിശ';

  @override
  String get sumHighlights => 'പ്രധാന വിവരങ്ങൾ';

  @override
  String get sumStrongPlanet => 'ഏറ്റവും ശക്തമായ ഗ്രഹം';

  @override
  String get sumWeakPlanet => 'ഏറ്റവും ദുർബലമായ ഗ്രഹം';

  @override
  String get sumYogas => 'യോഗങ്ങൾ';

  @override
  String get sumDoshas => 'ദോഷങ്ങൾ';

  @override
  String get sumRetrograde => 'വക്രി';

  @override
  String get sumCombust => 'അസ്തംഗതം';

  @override
  String get sumExalted => 'ഉച്ചം';

  @override
  String get sumDebilitated => 'നീചം';

  @override
  String get sumVargottama => 'വർഗോത്തമം';

  @override
  String get sumQuickInsights => 'പെട്ടെന്നുള്ള വിവരങ്ങൾ';

  @override
  String get sumSpirituality => 'ആത്മീയത';

  @override
  String get sumTimezone => 'സമയ മേഖല';

  @override
  String get sumAyanamsa => 'അയനാംശം';

  @override
  String get sumCalendarType => 'പഞ്ചാംഗം';

  @override
  String get sumCopied => 'ക്ലിപ്പ്ബോർഡിലേക്ക് പകർത്തി';

  @override
  String get sumNatureFire => 'നിങ്ങൾക്ക് ധൈര്യവും ഊർജ്ജസ്വലതയും മുൻനിരയിൽ നിന്ന് നയിക്കുന്ന സ്വഭാവവുമുണ്ട്.';

  @override
  String get sumNatureEarth => 'നിങ്ങൾക്ക് പ്രായോഗികവും സ്ഥിരതയുള്ളതും അച്ചടക്കമുള്ളതുമായ സ്വഭാവമുണ്ട്, ഇത് ശാശ്വത ഫലങ്ങൾ കെട്ടിപ്പടുക്കുന്നു.';

  @override
  String get sumNatureAir => 'നിങ്ങൾക്ക് ജിജ്ഞാസയുള്ളതും ആശയവിനിമയശേഷിയുള്ളതും ബുദ്ധിപരവുമായ സ്വഭാവമുണ്ട്, ഇത് പുതിയ ആശയങ്ങളിൽ അഭിവൃദ്ധി പ്രാപിക്കുന്നു.';

  @override
  String get sumNatureWater => 'നിങ്ങൾക്ക് അന്തർജ്ഞാനവും വൈകാരികവും അനുകമ്പയുള്ളതുമായ സ്വഭാവമുണ്ട്, ആഴമേറിയ ആന്തരിക സംവേദനക്ഷമതയോടെ.';

  @override
  String get sumGradePhraseExcellent => 'ശക്തമായി പിന്തുണയ്ക്കപ്പെടുന്നു — സ്ഥിരമായ പരിശ്രമത്തിലൂടെ അനുകൂല ഫലങ്ങൾ ലഭിക്കാൻ സാധ്യതയുണ്ട്.';

  @override
  String get sumGradePhraseGood => 'നന്നായി പിന്തുണയ്ക്കപ്പെടുന്നു — അല്പം ശ്രദ്ധയോടെ പൊതുവെ അനുകൂലം.';

  @override
  String get sumGradePhraseAverage => 'സമ്മിശ്ര പിന്തുണ — ഫലങ്ങൾ പരിശ്രമത്തെയും സമയത്തെയും ആശ്രയിച്ചിരിക്കുന്നു.';

  @override
  String get sumGradePhraseWeak => 'ശ്രദ്ധ ആവശ്യമാണ് — ക്ഷമയും പരിഹാരങ്ങളും ഇവിടെ സഹായിക്കും.';

  @override
  String get kDefCombust => 'സൂര്യനോട് വളരെ അടുത്തുള്ള ഒരു ഗ്രഹം, ഇതുമൂലം അതിന്റെ ഊർജ്ജം \'ദഹിച്ച്\' ദുർബലമാകുന്നു.';

  @override
  String get kDefRetrograde => 'പിന്നോട്ട് സഞ്ചരിക്കുന്നതായി തോന്നുന്ന ഗ്രഹം; ഇതിന്റെ ഫലങ്ങൾ ഉള്ളിലേക്ക് തിരിഞ്ഞ് തീവ്രമാകുന്നു.';

  @override
  String get kDefNakshatra => 'ചന്ദ്രനും ഗ്രഹങ്ങളും സഞ്ചരിക്കുന്ന 27 നക്ഷത്ര മണ്ഡലങ്ങളിൽ ഒന്ന്.';

  @override
  String get kDefVargottama => 'ജന്മ ജാതകത്തിലും (D1) നവാംശത്തിലും (D9) ഒരേ രാശിയിൽ വരുന്ന ഗ്രഹം — ബലത്തിന്റെ അടയാളം.';

  @override
  String get kDefOwnSign => 'സ്വന്തം അധികാരമുള്ള രാശിയിൽ ഇരിക്കുന്ന ഗ്രഹം, അവിടെ അത് സ്വന്തം വീട്ടിലെന്ന പോലെ അനുഭവപ്പെട്ട് സ്ഥിരതയുള്ള ഫലങ്ങൾ നൽകുന്നു.';

  @override
  String get kDefExalted => 'തന്റെ ഏറ്റവും ഉയർന്ന ബലമുള്ള രാശിയിലുള്ള ഗ്രഹം, ഇത് ഏറ്റവും മികച്ച ഫലങ്ങൾ നൽകുന്നു.';

  @override
  String get kDefDebilitated => 'തന്റെ ഏറ്റവും ദുർബലമായ രാശിയിലുള്ള ഗ്രഹം, അവിടെ അത് ഫലങ്ങൾ നൽകാൻ പാടുപെടുന്നു.';

  @override
  String get kDefMooltrikona => 'ഒരു ഗ്രഹത്തിന്റെ സ്വന്തം രാശിയിലെ പ്രത്യേക ഭാഗം, അവിടെ അത് പ്രത്യേകം ശക്തമായിരിക്കും.';

  @override
  String get kDefAscendant => 'ജനന സമയത്ത് കിഴക്കൻ ചക്രവാളത്തിൽ ഉദിക്കുന്ന രാശി — ലഗ്നം, ജാതകത്തിന്റെ അടിസ്ഥാനം.';

  @override
  String get kDefMahadasha => 'ജീവിതത്തിന്റെ ദീർഘകാലത്തെ വർണ്ണിക്കുന്ന പ്രധാന ഗ്രഹ കാലയളവ്.';

  @override
  String get kDefAntardasha => 'മഹാദശയ്ക്കുള്ളിലെ ഒരു ഉപ-കാലയളവ്, ഇത് അതിന്റെ ഫലങ്ങളെ സൂക്ഷ്മമായി ക്രമീകരിക്കുന്നു.';

  @override
  String get kDefPada => 'ഒരു ഗ്രഹം സ്ഥിതി ചെയ്യുന്ന നക്ഷത്രത്തിന്റെ നാല് പാദങ്ങളിൽ ഒന്ന്.';

  @override
  String get aspGivesAspectTo => 'ദൃഷ്ടി നൽകുന്നു';

  @override
  String get aspReceivesAspectFrom => 'ദൃഷ്ടി സ്വീകരിക്കുന്നു';

  @override
  String get aspInfluences => 'സ്വാധീനിക്കുന്നു';

  @override
  String get aspNoInfluence => 'സ്വാധീനമില്ല';

  @override
  String get aspNoAspect => 'ദൃഷ്ടിയില്ല';

  @override
  String get aspPresent => 'ഉണ്ട്';

  @override
  String get aspAbsent => 'ഇല്ലാത്തത്';

  @override
  String get aspNotPresent => 'ഇല്ല';

  @override
  String get aspSpecialAspect => 'പ്രത്യേക ദൃഷ്ടി';

  @override
  String get aspAspectWord => 'ദൃഷ്ടി';

  @override
  String get aspTotalGiven => 'നൽകിയ ദൃഷ്ടികൾ';

  @override
  String get aspTotalReceived => 'ലഭിച്ച ദൃഷ്ടികൾ';

  @override
  String get aspStrongestInfluence => 'ഏറ്റവും ശക്തമായ സ്വാധീനം';

  @override
  String get aspMedium => 'മധ്യമം';

  @override
  String get aspAspectPresent => 'ദൃഷ്ടി ഉണ്ട്';

  @override
  String get aspReason => 'കാരണം';

  @override
  String get aspBoth => 'രണ്ടും';

  @override
  String get aspTargetHouse => 'ലക്ഷ്യ ഭാവം';

  @override
  String get aspTargetSign => 'ലക്ഷ്യ രാശി';

  @override
  String get aspLagnaReceives => 'ലഗ്നത്തിന് ദൃഷ്ടി ലഭിക്കുന്ന ഗ്രഹങ്ങൾ';

  @override
  String get aspNoAspectFrom => 'ഇവയിൽ നിന്ന് ദൃഷ്ടിയില്ല';

  @override
  String get aspPlanetToPlanet => 'ഗ്രഹത്തിൽ നിന്ന് ഗ്രഹത്തിലേക്ക്';

  @override
  String get aspSignToSign => 'രാശിയിൽ നിന്ന് രാശിയിലേക്ക്';

  @override
  String get aspCombinedAspect => 'സംയുക്ത ദൃഷ്ടി';

  @override
  String get aspGrahaAspect => 'ഗ്രഹ ദൃഷ്ടി';

  @override
  String get aspRashiAspect => 'രാശി ദൃഷ്ടി';

  @override
  String get aspInfoTitle => 'ദൃഷ്ടി (Drishti) മനസ്സിലാക്കുക';

  @override
  String get aspQGraha => 'ഗ്രഹ ദൃഷ്ടി എന്താണ്?';

  @override
  String get aspQRashi => 'രാശി ദൃഷ്ടി എന്താണ്?';

  @override
  String get aspQDiff => 'രണ്ടും തമ്മിലുള്ള വ്യത്യാസം';

  @override
  String get aspQPredict => 'ദൃഷ്ടികൾ പ്രവചനത്തെ എങ്ങനെ സ്വാധീനിക്കുന്നു';

  @override
  String get aspGrahaBody => 'ഒരു ഗ്രഹം അതിന്റെ സ്ഥാനത്തുനിന്ന് പ്രസരിപ്പിക്കുന്ന ദൃഷ്ടിയാണ് ഗ്രഹ ദൃഷ്ടി. ഓരോ ഗ്രഹവും അതിന്റെ സ്ഥാനത്തുനിന്ന് 7-ാം ഭാവത്തിലേക്ക്/ഗ്രഹത്തിലേക്ക് പൂർണ്ണ ദൃഷ്ടി നൽകുന്നു (നേരിട്ടുള്ള, മുഖാമുഖ സ്വാധീനം). കൂടാതെ, ചൊവ്വ 4-ഉം 8-ഉം ഭാവങ്ങളിലേക്കും, വ്യാഴം 5-ഉം 9-ഉം ഭാവങ്ങളിലേക്കും, ശനി 3-ഉം 10-ഉം ഭാവങ്ങളിലേക്കും ദൃഷ്ടി നൽകുന്നു. രാഹുവിനും കേതുവിനും സാധാരണയായി 5, 7, 9 ദൃഷ്ടികൾ നൽകപ്പെടുന്നു. ഒരു ഗ്രഹത്തിന്റെ ദൃഷ്ടി അത് പതിക്കുന്ന ഗ്രഹത്തിനോ ഭാവത്തിനോ അതിന്റെ സ്വഭാവത്തിന്റെ നിറം നൽകുന്നു.';

  @override
  String get aspRashiBody => 'ജൈമിനി ജ്യോതിഷത്തിൽ നിന്നുള്ള രാശി-രാശി ദൃഷ്ടിയാണ് രാശി ദൃഷ്ടി, അവിടെ ഏതു ഗ്രഹങ്ങളാണ് ഉള്ളതെന്നത് പരിഗണിക്കാതെ. ചര രാശികൾ സ്ഥിര രാശികളെ കാണുന്നു (അടുത്തുള്ളത് ഒഴികെ), സ്ഥിര രാശികൾ ചര രാശികളെ കാണുന്നു (അടുത്തുള്ളത് ഒഴികെ), ദ്വിസ്വഭാവ രാശികൾ മറ്റ് ദ്വിസ്വഭാവ രാശികളെ കാണുന്നു. ഇത് പ്രധാനമായും ജൈമിനി പ്രവചനത്തിലും ഭാവങ്ങൾ തമ്മിലുള്ള ബന്ധം വിലയിരുത്താനും ഉപയോഗിക്കുന്നു.';

  @override
  String get aspDiffBody => 'ഗ്രഹ ദൃഷ്ടി ഒരു ഗ്രഹം പ്രസരിപ്പിക്കുന്നതും ആ ഗ്രഹം എവിടെയാണ് എന്നതിനെ ആശ്രയിച്ചിരിക്കുന്നതുമാണ്. രാശി ദൃഷ്ടി രാശിക്ക് സ്വന്തമായതും അതിൽ എന്ത് സ്ഥിതി ചെയ്താലും ബാധകമാകുന്നതുമാണ്. ഗ്രഹ ദൃഷ്ടി ദിശാപരമാണ് (ഗ്രഹം A ഗ്രഹം Bയെ കാണുന്നു), രാശി ദൃഷ്ടി സാധാരണയായി രാശികൾ തമ്മിൽ പരസ്പരമാണ്. രണ്ടും ഒരേ ലക്ഷ്യത്തിലേക്ക് ചൂണ്ടുമ്പോൾ, സ്വാധീനം പ്രത്യേകിച്ചും ശക്തമാകുന്നു.';

  @override
  String get aspPredictBody => 'ഒരു ഗ്രഹം സ്വന്തം ഭാവത്തിനപ്പുറം എവിടെ സ്വാധീനം വ്യാപിപ്പിക്കുന്നു എന്ന് ഒരു ദൃഷ്ടി കാണിക്കുന്നു. ഒരു ശുഭ ദൃഷ്ടി (വ്യാഴം, ശുക്രൻ, നല്ല സ്ഥാനത്തുള്ള ചന്ദ്രൻ/ബുധൻ) ലക്ഷ്യത്തെ പിന്തുണച്ച് സംരക്ഷിക്കുന്നു; ഒരു അശുഭ ദൃഷ്ടി (ശനി, ചൊവ്വ, സൂര്യൻ, രാഹു, കേതു) അതിൽ സമ്മർദ്ദം ചെലുത്തുകയോ വൈകിപ്പിക്കുകയോ വെല്ലുവിളിക്കുകയോ ചെയ്യാം. ഏതൊക്കെ ഗ്രഹങ്ങൾ ഒരു ഭാവത്തെയോ ഗ്രഹത്തെയോ ദൃഷ്ടി ചെയ്യുന്നു എന്ന് വായിക്കുന്നത് ഫലങ്ങൾ എന്തുകൊണ്ട് ആ വിധത്തിൽ പ്രത്യക്ഷപ്പെടുന്നു എന്ന് വിശദീകരിക്കുന്നു.';

  @override
  String get aspTraitSun => 'അധികാരം, നേതൃത്വം, ജീവശക്തി';

  @override
  String get aspTraitMoon => 'വൈകാരിക ആഴം, സുഖം, ഉൾക്കാഴ്ച';

  @override
  String get aspTraitMars => 'ഊർജ്ജം, ധൈര്യം, ഊർജസ്വലത';

  @override
  String get aspTraitMercury => 'ആശയവിനിമയം, ബുദ്ധി, പൊരുത്തപ്പെടൽ';

  @override
  String get aspTraitJupiter => 'ജ്ഞാനം, വളർച്ച, സൗഭാഗ്യം';

  @override
  String get aspTraitVenus => 'പ്രണയം, ഐക്യം, സുഖസൗകര്യങ്ങൾ';

  @override
  String get aspTraitSaturn => 'അച്ചടക്കം, ഉത്തരവാദിത്തം, ക്ഷമയോടെയുള്ള, ചിലപ്പോൾ വൈകിയ, വിജയം';

  @override
  String get aspTraitRahu => 'അഭിലാഷം, തീവ്രത, പതിവില്ലാത്ത വഴിത്തിരിവുകൾ';

  @override
  String get aspTraitKetu => 'വിരക്തി, ആത്മീയത, പെട്ടെന്നുള്ള മാറ്റം';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '${planet} ${targets}-നെ സ്വാധീനിക്കുന്നു. ഇത് ഈ ഗ്രഹങ്ങൾ പ്രതിനിധീകരിക്കുന്ന മേഖലകളിൽ ${trait} കൊണ്ടുവന്നേക്കാം.';
  }

  @override
  String aspAiNone(Object planet) {
    return '${planet} ഇവിടെ മറ്റൊരു ഗ്രഹത്തിലും പ്രത്യേക ദൃഷ്ടി ചെലുത്തുന്നില്ല; ഇതിന്റെ സ്വാധീനം പ്രധാനമായും സ്വന്തം രാശിയിലൂടെയും ഭാവത്തിലൂടെയും പ്രവർത്തിക്കുന്നു.';
  }

  @override
  String get avSummaryTitle => 'അഷ്ടകവർഗ്ഗ സംഗ്രഹം';

  @override
  String get avOverallScore => 'മൊത്തം SAV സ്കോർ';

  @override
  String get avOverallRating => 'മൊത്തം റേറ്റിംഗ്';

  @override
  String get avStrongestSigns => 'ശക്തമായ രാശികൾ';

  @override
  String get avWeakestSigns => 'ദുർബലമായ രാശികൾ';

  @override
  String get avScore => 'സ്കോർ';

  @override
  String get avMeaning => 'അർത്ഥം';

  @override
  String get avGrid => 'ഗ്രിഡ്';

  @override
  String get avList => 'ലിസ്റ്റ്';

  @override
  String get avOverallScoreShort => 'മൊത്തം സ്കോർ';

  @override
  String get avNatalSignScore => 'ജന്മ രാശി സ്കോർ';

  @override
  String get avBestSigns => 'മികച്ച രാശികൾ';

  @override
  String get avWeakSigns => 'ദുർബല രാശികൾ';

  @override
  String get avAiInterpretation => 'AI വ്യാഖ്യാനം';

  @override
  String get avVeryGood => 'വളരെ നല്ലത്';

  @override
  String get avVeryWeak => 'വളരെ ദുർബലം';

  @override
  String get avTotalSav => 'മൊത്തം SAV';

  @override
  String get avPlanetContributions => 'ഗ്രഹ സംഭാവനകൾ';

  @override
  String get avFinance => 'സാമ്പത്തികം';

  @override
  String get avOverallStrength => 'മൊത്തം ശക്തി';

  @override
  String get avWhatDoesThisMean => 'ഇതിന്റെ അർത്ഥം എന്താണ്?';

  @override
  String get avSimple => 'ലളിതം';

  @override
  String get avAdvanced => 'വിശദമായത്';

  @override
  String get avInfoTitle => 'അഷ്ടകവർഗ്ഗം മനസ്സിലാക്കുക';

  @override
  String get avStrong => 'ശക്തം';

  @override
  String get avModerate => 'മിതമായ';

  @override
  String get avQWhatIsAv => 'അഷ്ടകവർഗ്ഗം എന്താണ്?';

  @override
  String get avQWhatIsSav => 'SAV എന്താണ്?';

  @override
  String get avQWhatIsBav => 'BAV എന്താണ്?';

  @override
  String get avQHowToRead => 'ഈ സ്കോറുകൾ എങ്ങനെ വായിക്കാം';

  @override
  String get avQSavVsBav => 'SAV vs BAV';

  @override
  String get avABody => 'വൈദിക ജ്യോതിഷത്തിലെ പോയിന്റ് അടിസ്ഥാനമാക്കിയുള്ള ഒരു ശക്തി സംവിധാനമാണ് അഷ്ടകവർഗ്ഗം. ഓരോ ഗ്രഹവും അതിന്റെ സ്ഥാനം അനുസരിച്ച് പന്ത്രണ്ട് രാശികൾക്കും ശുഭ പോയിന്റുകൾ (ബിന്ദുക്കൾ, രേഖകൾ എന്നും അറിയപ്പെടുന്നു) നൽകുന്നു. ഒരു രാശിയിൽ കൂടുതൽ പോയിന്റ് ഉണ്ടെങ്കിൽ, ബന്ധപ്പെട്ട ഗ്രഹദശകളിലും ഗോചാരങ്ങളിലും ജീവിതത്തിന്റെ ആ മേഖലയ്ക്ക് കൂടുതൽ സുഗമമായ പിന്തുണ ലഭിക്കും.';

  @override
  String get avSavBody => 'SAV (സർവ്വ അഷ്ടകവർഗ്ഗം) ഓരോ രാശിക്കും ഏഴ് ഗ്രഹങ്ങളുടെയും പോയിന്റുകൾ കൂട്ടിച്ചേർക്കുന്നു. ഇത് ഓരോ രാശിക്കും ഒരൊറ്റ ശക്തി സ്കോർ നൽകുന്നു, അതിനാൽ നിങ്ങളുടെ ജാതകത്തിൽ ഏത് രാശികൾക്ക് — അവ വരുന്ന ഭാവങ്ങൾക്കും — ഏറ്റവും കൂടുതൽ പിന്തുണയുണ്ടെന്ന് വേഗത്തിൽ കാണാം.';

  @override
  String get avBavBody => 'BAV (ഭിന്ന അഷ്ടകവർഗ്ഗം) ഒരൊറ്റ ഗ്രഹത്തിന്റെ പോയിന്റുകൾ പന്ത്രണ്ട് രാശികളിലും കാണിക്കുന്നു. ഒരു നിർദ്ദിഷ്ട ഗ്രഹം ഏത് രാശികളെ ഏറ്റവും കൂടുതൽ പിന്തുണയ്ക്കുന്നു എന്ന് ഇത് കാണിക്കുന്നു, ആ ഗ്രഹത്തിന്റെ ദശയോ ഗോചാരമോ സജീവമാകുമ്പോൾ ഇത് പ്രധാനമാകുന്നു.';

  @override
  String get avHowToReadBody => 'ഉയർന്ന സംഖ്യകൾ മെച്ചമാണ്. SAV-യ്ക്ക്, ശരാശരി രാശിക്ക് ഏകദേശം 28 പോയിന്റ് ലഭിക്കും — 30-ന് മുകളിൽ ശക്തവും 25-ന് താഴെ ശ്രദ്ധ വേണ്ടതുമാണ്. BAV-യ്ക്ക്, ഓരോ രാശിയും 0 മുതൽ 8 വരെയാണ്, 4 ശരാശരിയായി കണക്കാക്കുന്നു. പ്രധാനപ്പെട്ട കാര്യങ്ങൾക്ക് നിങ്ങളുടെ ഏറ്റവും ശക്തമായ രാശികൾക്ക് മുൻഗണന നൽകുക, ദുർബലമായ രാശികളുടെ കാര്യങ്ങളിൽ ക്ഷമയും അച്ചടക്കവും പാലിക്കുക.';

  @override
  String get avSavVsBavBody => 'SAV എല്ലാ ഗ്രഹങ്ങളുടെയും സംയോജിത ആകെത്തുകയാണ്, ഇത് ഒരു രാശിയുടെ മൊത്തം ശക്തി കാണിക്കുന്നു. BAV ഒരൊറ്റ ഗ്രഹത്തിന്റെ സംഭാവനയാണ്, ഏത് ഗ്രഹമാണ് ആ രാശിയെ പിന്തുണയ്ക്കുന്നതെന്ന് കാണിക്കുന്നു. വലിയ ചിത്രം മനസ്സിലാക്കാൻ SAV ഉപയോഗിക്കുക, ഏത് ഗ്രഹമാണ് രാശിയുടെ ശക്തി നയിക്കുന്നതെന്ന് മനസ്സിലാക്കാൻ BAV നോക്കുക.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'നിങ്ങളുടെ ജാതകം ${s1}, ${s2}, ${s3} എന്നീ രാശികളിൽ ഏറ്റവും ശക്തമാണ്. ഈ രാശികൾ ഗ്രഹദശകളിലും ഗോചാരങ്ങളിലും മികച്ച പിന്തുണ നൽകുന്നു. ${weak}-ന് നിലവിൽ ഏറ്റവും കുറഞ്ഞ പിന്തുണയാണുള്ളത്, അതിനാൽ അതുമായി ബന്ധപ്പെട്ട കാര്യങ്ങളിൽ ക്ഷമയും അച്ചടക്കവും സഹായകമാകും.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '${planet} ${s1}, ${s2} എന്നിവയിലൂടെ ഏറ്റവും ശക്തമായി പ്രവർത്തിക്കുന്നു. ഈ രാശികൾ സജീവമാകുമ്പോൾ ${planet} നിയന്ത്രിക്കുന്ന കാര്യങ്ങൾ മെച്ചപ്പെടുന്നു.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'നിങ്ങളുടെ ഏറ്റവും ശക്തമായ രാശികൾ ${s1}, ${s2} എന്നിവയാണ് — ഗ്രഹങ്ങൾ ഇവയിലൂടെ ഗോചരിക്കുമ്പോൾ പ്രധാന തുടക്കങ്ങൾക്ക് ഇവയ്ക്ക് മുൻഗണന നൽകുക.';
  }

  @override
  String avInsightWeak(Object s1) {
    return '${s1}-ന് ഏറ്റവും കുറഞ്ഞ പിന്തുണയാണുള്ളത് — അതിന്റെ കാര്യങ്ങളിൽ ശ്രദ്ധയോടെ മുന്നോട്ട് പോകുകയും അമിതമായ പ്രതിബദ്ധത ഒഴിവാക്കുകയും ചെയ്യുക.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '${planet}-ന് ഏറ്റവും കൂടുതൽ പോയിന്റുകളുണ്ട്, അതിനാൽ അതിന്റെ സൂചനകൾ നിങ്ങളുടെ ജീവിതത്തിൽ നന്നായി പിന്തുണയ്ക്കപ്പെടുന്നു.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '${planet}-ന് ഏറ്റവും കുറഞ്ഞ പോയിന്റുകളുണ്ട്, പരിഹാരങ്ങളിൽ നിന്നും ബോധപൂർവമായ ശ്രമങ്ങളിൽ നിന്നും ഏറ്റവും കൂടുതൽ പ്രയോജനം നേടുന്നു.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'നിങ്ങളുടെ ശരാശരി ${avg} പോയിന്റുകൾക്ക് മുകളിൽ സ്കോർ ചെയ്യുന്ന രാശികൾ പൊതുവെ കൂടുതൽ സുഗമവും വിശ്വസനീയവുമായ ഫലങ്ങൾ നൽകുന്നു.';
  }

  @override
  String get fcKey => 'കീ';

  @override
  String get fcActions => 'പ്രവർത്തനങ്ങൾ';

  @override
  String get fcCautions => 'മുൻകരുതലുകൾ';

  @override
  String get fc12House => '12 ഭാവങ്ങൾ';

  @override
  String get fcProbabilities => 'സാധ്യതകൾ';

  @override
  String get fcHousesCaps => 'ഭാവങ്ങൾ';

  @override
  String get fcCritical => 'നിർണായകം';

  @override
  String get fcFlags => 'അടയാളങ്ങൾ';

  @override
  String get fcAnalysis => 'വിശകലനം';

  @override
  String get fcConfidence => 'ആത്മവിശ്വാസം';

  @override
  String get fcQualityCaps => 'ഗുണനിലവാരം';

  @override
  String get fcIncomeVs => 'വരുമാനം vs';

  @override
  String get fcExpense => 'ചെലവ്';

  @override
  String get fcFinance => 'ധനകാര്യം';

  @override
  String get fcNetBalance => 'നെറ്റ് ബാലൻസ്';

  @override
  String get fcSignature => 'ഒപ്പ്';

  @override
  String get fcBestTimeForIncome => 'വരുമാനത്തിനുള്ള മികച്ച സമയം';

  @override
  String get fcExpenseCaution => 'ചെലവ് മുൻകരുതൽ';

  @override
  String get fcIncomeCaps => 'വരുമാനം';

  @override
  String get fcExpenseCaps => 'ചെലവ്';

  @override
  String get fcRelationships => 'ബന്ധങ്ങൾ';

  @override
  String get fcAreasCaps => 'മേഖലകൾ';

  @override
  String get fcBestForMeetings => 'മീറ്റിംഗുകൾക്ക് മികച്ചത്';

  @override
  String get fcOpportunitiesVs => 'അവസരങ്ങൾ vs';

  @override
  String get fcRisks => 'അപകടസാധ്യതകൾ';

  @override
  String get fcOutlook => 'കാഴ്ചപ്പാട്';

  @override
  String get fcAction => 'പ്രവർത്തനം';

  @override
  String get fcProtect => 'സംരക്ഷിക്കുക';

  @override
  String get fcOpportunityCaps => 'അവസരം';

  @override
  String get fcRiskCaps => 'അപകടസാധ്യത';

  @override
  String get fcTopOpportunities => 'മികച്ച അവസരങ്ങൾ';

  @override
  String get fcTopRisks => 'പ്രധാന അപകടസാധ്യതകൾ';

  @override
  String get fcTiming => 'സമയം';

  @override
  String get fcWindows => 'വിൻഡോകൾ';

  @override
  String get fcSlotsCaps => 'സ്ലോട്ടുകൾ';

  @override
  String get fcBestWindows => 'മികച്ച വിൻഡോകൾ';

  @override
  String get fcWorstWindows => 'ഏറ്റവും മോശം വിൻഡോകൾ';

  @override
  String get fcAvoid => 'ഒഴിവാക്കുക';

  @override
  String get fcHouse => 'ഭാവം';

  @override
  String get fcFailed => 'പരാജയപ്പെട്ടു';

  @override
  String get lifeCareer => 'ജോലി';

  @override
  String get lifeHealth => 'ആരോഗ്യം';

  @override
  String get lifeWealth => 'സമ്പത്ത്';

  @override
  String get lifeFamily => 'കുടുംബം';

  @override
  String get lifeMind => 'മനസ്സ്';

  @override
  String get lifeEgo => 'അഹംഭാവം';

  @override
  String get lifeAggression => 'ആക്രമണോത്സുകത';

  @override
  String get lifeConflict => 'സംഘർഷം';

  @override
  String get rashiElement => 'തത്വം';

  @override
  String get rashiQuality => 'ഗുണം';

  @override
  String get rashiLuckyColor => 'ഭാഗ്യ നിറം';

  @override
  String get rashiLuckyDay => 'ഭാഗ്യ ദിവസം';

  @override
  String get rashiLuckyNumber => 'ഭാഗ്യ സംഖ്യ';

  @override
  String get rashiGemstone => 'രത്നം';

  @override
  String get rashiBody => 'ശരീരം';

  @override
  String get gocharTodaysTransitChart => 'ഇന്നത്തെ ഗോചാര ചാർട്ട്';

  @override
  String get gocharTransit => 'ഗോചാരം';

  @override
  String get thisWeek => 'ഈ ആഴ്ച';

  @override
  String get thisMonth => 'ഈ മാസം';

  @override
  String get best => 'മികച്ചത്';

  @override
  String get worst => 'മോശം';

  @override
  String get avg => 'avg';

  @override
  String get favorableLoveWindowsLabel => 'അനുകൂല പ്രണയ കാലങ്ങൾ';

  @override
  String get lordLabel => 'അധിപൻ';

  @override
  String get lordPlacementLabel => 'അധിപ സ്ഥാനം';

  @override
  String get lordDignityLabel => 'അധിപ ബലം';

  @override
  String get categoriesSuffix => 'വിഭാഗങ്ങൾ';

  @override
  String get coreBlockerLabel => 'പ്രധാന തടസ്സം';

  @override
  String get coreGiftLabel => '✦ പ്രധാന വരം';

  @override
  String get coreThemeLabel => '● പ്രധാന വിഷയം';

  @override
  String dominantLabel(Object value) {
    return 'പ്രബലം: ${value}';
  }

  @override
  String get karakasSuffix => 'കാരകങ്ങൾ';

  @override
  String get protectiveLabel => 'സംരക്ഷകം';

  @override
  String secondaryLabel(Object value) {
    return ' · ദ്വിതീയം: ${value}';
  }

  @override
  String get tagCore => 'പ്രധാനം';

  @override
  String get debtScoresHeader => '📉 കടം സ്കോറുകൾ';

  @override
  String get debtCurrentLoadStat => 'നിലവിലെ\nകടഭാരം';

  @override
  String get debtRecoveryCapacityStat => 'വീണ്ടെടുപ്പ്\nശേഷി';

  @override
  String get debtIntensityStat => 'തീവ്രത';

  @override
  String get debtDefaultRiskStat => 'വീഴ്ചാ അപകടം';

  @override
  String get debtProfileTitle => 'കട വിവരണം';

  @override
  String get debtKarmaLabel => 'കർമ്മം';

  @override
  String get debtPersonalityLabel => 'വ്യക്തിത്വം';

  @override
  String get debtPhaseLabel => 'ഘട്ടം';

  @override
  String get debtPrimaryCategoryLabel => 'പ്രാഥമിക വിഭാഗം';

  @override
  String get debtWord => 'കടം';

  @override
  String get debtYogasTitle => 'കട യോഗങ്ങൾ';

  @override
  String get debtCreatingLabel => 'കടം സൃഷ്ടിക്കുന്ന';

  @override
  String get debtClearingLabel => 'കടം തീർക്കുന്ന';

  @override
  String get yearlyDebtTitle => 'വാർഷിക കടം';

  @override
  String get debtRepaymentTitle => 'തിരിച്ചടവ്';

  @override
  String get debtDangerPeriodsTitle => 'അപകട കാലങ്ങൾ';

  @override
  String get debtDefaultPctStat => 'വീഴ്ച %';

  @override
  String get debtBankruptcyPctStat => 'പാപ്പരത്വം %';

  @override
  String get debtChronicPctStat => 'സ്ഥിരം %';

  @override
  String get debtResilienceStat => 'പ്രതിരോധം';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'വീണ്ടെടുപ്പ്: ${pct}% · കാലയളവ്: ${years} വർഷം';
  }

  @override
  String get debtFreeWindowLabel => '🎯 കടരഹിത കാലം';

  @override
  String debtFreeYear(Object year) {
    return 'വർഷം ${year}';
  }

  @override
  String get legalScoresHeader => '⚖️ നിയമ സ്കോറുകൾ';

  @override
  String get legalVulnerabilityStat => 'നിയമ\nദുർബലത';

  @override
  String get legalVictoryPotentialStat => 'വിജയ\nസാധ്യത';

  @override
  String get legalConflictStat => 'സംഘർഷം';

  @override
  String get legalResolutionStat => 'പരിഹാരം';

  @override
  String get legalProfileTitle => 'നിയമ വിവരണം';

  @override
  String get legalKarmaTypeLabel => 'കർമ്മ തരം';

  @override
  String get legalConflictStyleLabel => 'സംഘർഷ ശൈലി';

  @override
  String get legalStrategyLabel => 'തന്ത്രം';

  @override
  String get legalCaseDurationLabel => 'കേസ് കാലയളവ്';

  @override
  String get legalCurrentStatusLabel => 'നിലവിലെ അവസ്ഥ';

  @override
  String get legalWord => 'നിയമം';

  @override
  String get legalYogasTitle => 'നിയമ യോഗങ്ങൾ';

  @override
  String get legalDisputePressureLabel => 'തർക്ക സമ്മർദ്ദം';

  @override
  String get legalProtectionLabel => 'നിയമ സംരക്ഷണം';

  @override
  String get legalStressTrendTitle => 'നിയമ സമ്മർദ്ദം';

  @override
  String get legalVisibleEnemiesStat => 'ദൃശ്യ ശത്രുക്കൾ';

  @override
  String get legalHiddenEnemiesStat => 'മറഞ്ഞ ശത്രുക്കൾ';

  @override
  String get legalCriminalRiskStat => 'ക്രിമിനൽ അപകടം';

  @override
  String get legalFalseAccusationStat => 'വ്യാജ ആരോപണം';

  @override
  String get legalContractKarmaTitle => 'കരാർ കർമ്മം';

  @override
  String get legalDocumentationLabel => 'രേഖകൾ';

  @override
  String get legalFinePrintAwareLabel => 'സൂക്ഷ്മ വ്യവസ്ഥ ബോധം';

  @override
  String get legalNegotiationSkillLabel => 'വിലപേശൽ കഴിവ്';

  @override
  String get legalSignatureCautionLabel => 'ഒപ്പ് ജാഗ്രത';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'പ്രതിരോധം: ${pct}/100';
  }

  @override
  String get legalVictoryWord => 'വിജയം';

  @override
  String get legalAnalysisSuffix => 'വിശകലനം';

  @override
  String get legalAsPlaintiff => 'വാദിയായി';

  @override
  String get legalAsDefendant => 'പ്രതിയായി';

  @override
  String get legalWinProbability => 'ജയ സാധ്യത';

  @override
  String get legalDisputeWord => 'തർക്കം';

  @override
  String get lifepathScoresHeader => '🌟 ജീവിതപഥ സ്കോറുകൾ';

  @override
  String get lifepathDharmaClarityStat => 'ധർമ്മ\nവ്യക്തത';

  @override
  String get lifepathFortuneBaselineStat => 'ഭാഗ്യ\nഅടിസ്ഥാനം';

  @override
  String get lifepathCoherenceStat => 'ജീവിതപഥ\nസംഗതി';

  @override
  String get lifepathKarmaStat => 'കർമ്മം';

  @override
  String get lifepathSpiritualStat => 'ആധ്യാത്മികം';

  @override
  String get lifepathFameStat => 'പ്രശസ്തി';

  @override
  String get lifepathSoulContractTitle => 'ആത്മ കരാർ';

  @override
  String get lifepathAtmakarakaLabel => 'ആത്മകാരകൻ';

  @override
  String get lifepathAkFocusLabel => 'AK ശ്രദ്ധ';

  @override
  String get lifepathSoulPurposeLabel => 'ആത്മ ലക്ഷ്യം';

  @override
  String get lifepathLifeChapterLabel => 'ജീവിത അധ്യായം';

  @override
  String get lifepathPrimaryDomainLabel => 'പ്രാഥമിക മേഖല';

  @override
  String get lifepathLeadershipStat => 'നേതൃത്വം';

  @override
  String get lifepathWisdomTeachStat => 'ജ്ഞാനം/അധ്യാപനം';

  @override
  String get lifepathServiceStat => 'സേവനം';

  @override
  String get lifepathHealingStat => 'രോഗശാന്തി';

  @override
  String get lifepathFortuneYogasTitle => 'ഭാഗ്യ യോഗങ്ങൾ';

  @override
  String get lifepathLuckBlocksLabel => 'ഭാഗ്യ തടസ്സങ്ങൾ';

  @override
  String get lifepathFortuneBoostersLabel => 'ഭാഗ്യ വർധകങ്ങൾ';

  @override
  String get lifepathFortuneTrendTitle => 'ഭാഗ്യ പ്രവണത';

  @override
  String get lifepathGoldenWindowsTitle => 'സുവർണ്ണ കാലങ്ങൾ ★';

  @override
  String get lifepathTransformationTitle => 'പരിവർത്തനം';

  @override
  String get lifepathMilestonesTitle => 'ജീവിത നാഴികക്കല്ലുകൾ';

  @override
  String get lifepathKarmicLessonsTitle => 'കാർമിക പാഠങ്ങൾ';

  @override
  String get lifepathRahuGrowthLabel => 'രാഹു വളർച്ച';

  @override
  String get lifepathKetuSurrenderLabel => 'കേതു സമർപ്പണം';

  @override
  String get lifepathSaturnLessonLabel => 'ശനി പാഠം';

  @override
  String get lifepathLifeDifficultyLabel => 'ജീവിത പ്രയാസം';

  @override
  String get lifepathSoulExperienceTitle => '★ ആത്മാവ് അനുഭവിക്കാൻ വന്നത്';

  @override
  String get lifepathBlessingsTitle => '● അനുഗ്രഹങ്ങൾ';

  @override
  String get lifepathLifeWord => 'ജീവിതം';

  @override
  String get lifepathArchetypeSuffix => 'പ്രാരൂപം';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'പൂർത്തീകരണം: ${pct}%';
  }

  @override
  String get lifepathDestinyVsWord => 'വിധി vs';

  @override
  String get lifepathFreeWillSuffix => 'സ്വതന്ത്ര ഇച്ഛ';

  @override
  String get lifepathDestinyStat => 'വിധി';

  @override
  String get lifepathFreeWillStat => 'സ്വതന്ത്ര ഇച്ഛ';

  @override
  String get pastlifeScoresHeader => '🔮 പൂർവജന്മ സ്കോറുകൾ';

  @override
  String get pastlifeSignatureStrengthStat => 'മുദ്ര\nബലം';

  @override
  String get pastlifeCarryForwardStat => 'മുന്നോട്ട്\nകൊണ്ടുവന്നത്';

  @override
  String get pastlifeMasteryPreservedStat => 'സംരക്ഷിത\nപ്രാവീണ്യം';

  @override
  String get pastlifeUnfinishedStat => 'അപൂർണ്ണം';

  @override
  String get pastlifeKarmicDebtStat => 'കാർമിക കടം';

  @override
  String get pastlifeProfileTitle => 'പൂർവജന്മ വിവരണം';

  @override
  String get pastlifeThemeLabel => 'വിഷയം';

  @override
  String get pastlifeProfessionLabel => 'തൊഴിൽ';

  @override
  String get pastlifeSocialStandingLabel => 'സാമൂഹിക നില';

  @override
  String get pastlifeRegionLabel => 'പ്രദേശം';

  @override
  String get pastlifeSpiritualLevelLabel => 'ആധ്യാത്മിക നിലവാരം';

  @override
  String get pastlifeGenderLabel => 'ലിംഗം';

  @override
  String get pastlifeWealthLevelLabel => 'സമ്പത്ത് നിലവാരം';

  @override
  String get pastlifeFamilyRoleLabel => 'കുടുംബ പങ്ക്';

  @override
  String get pastlifeSkillsCarriedTitle => '★ കൊണ്ടുവന്ന കഴിവുകൾ';

  @override
  String get pastlifeNaturalAttractionsTitle => '● സ്വാഭാവിക ആകർഷണങ്ങൾ';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ വിശദീകരിക്കാനാവാത്ത ഭയങ്ങൾ';

  @override
  String get pastlifeMagneticPullsTitle => '→ കാന്തിക ആകർഷണങ്ങൾ';

  @override
  String get pastlifeRelationshipStat => 'ബന്ധം';

  @override
  String get pastlifeFinancialStat => 'സാമ്പത്തികം';

  @override
  String get pastlifeServiceStat => 'സേവനം';

  @override
  String get pastlifeDharmicStat => 'ധാർമ്മികം';

  @override
  String get pastlifeOnRelationsStat => 'ബന്ധങ്ങളിൽ';

  @override
  String get pastlifeOnCareerStat => 'കരിയറിൽ';

  @override
  String get pastlifeOnHealthStat => 'ആരോഗ്യത്തിൽ';

  @override
  String get pastlifeOnSpiritualStat => 'ആധ്യാത്മികതയിൽ';

  @override
  String get pastlifeKarmicResolutionTitle => 'കാർമിക പരിഹാരം';

  @override
  String get pastlifePrimaryPathLabel => 'പ്രാഥമിക പഥം';

  @override
  String get pastlifeSecondaryPathLabel => 'ദ്വിതീയ പഥം';

  @override
  String get pastlifeClearingProgressLabel => 'തീർക്കൽ പുരോഗതി';

  @override
  String get pastlifeRemainingWorkLabel => 'ബാക്കിയുള്ള ജോലി';

  @override
  String get pastlifeDebtTimelineLabel => 'കട കാലയളവ്';

  @override
  String get pastlifeMemoryAccessStat => 'സ്മൃതി പ്രാപ്യത';

  @override
  String get pastlifeDreamVisitsStat => 'സ്വപ്ന സന്ദർശനങ്ങൾ';

  @override
  String get pastlifeDejaVuStat => 'ദേജാ വൂ';

  @override
  String get pastlifeRegressionFitStat => 'റിഗ്രഷൻ യോജിപ്പ്';

  @override
  String get pastlifeActivationTitle => 'പൂർവജന്മ സജീവീകരണം';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'പക്വത: ${maturity} · അവസ്ഥ: ${status}';
  }

  @override
  String get pastlifeKetuWord => 'കേതു';

  @override
  String get pastlifePastMasterySuffix => 'പൂർവ പ്രാവീണ്യം';

  @override
  String get pastlifeKetuMasteredLabel => 'കേതു · നിങ്ങൾ വശമാക്കിയത്';

  @override
  String get pastlifeRahuWord => 'രാഹു';

  @override
  String get pastlifeFutureGrowthSuffix => 'ഭാവി വളർച്ച';

  @override
  String get pastlifeRahuPullsLabel => 'രാഹു · നിങ്ങളെ മുന്നോട്ട് നയിക്കുന്നത്';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ നിഴൽ: ${shadow}';
  }

  @override
  String get mentalScoresHeader => '🧠 മാനസിക സ്കോറുകൾ';

  @override
  String get mentalStabilityStat => 'മാനസിക\nസ്ഥിരത';

  @override
  String get mentalEmotionalBaselineStat => 'വൈകാരിക\nഅടിസ്ഥാനം';

  @override
  String get mentalResilienceStat => 'പ്രതിരോധം';

  @override
  String get mentalAnxietyStat => 'ഉത്കണ്ഠ';

  @override
  String get mentalDepressionStat => 'വിഷാദം';

  @override
  String get mentalRegulationStat => 'നിയന്ത്രണം';

  @override
  String get mentalProfileTitle => 'മാനസിക വിവരണം';

  @override
  String get mentalConstitutionLabel => 'പ്രകൃതി';

  @override
  String get mentalStressDriverLabel => 'സമ്മർദ്ദ കാരണം';

  @override
  String get mentalStabilityAnchorLabel => 'സ്ഥിരതാ ആധാരം';

  @override
  String get mentalStressResponseLabel => 'സമ്മർദ്ദ പ്രതികരണം';

  @override
  String get mentalAttachmentStyleLabel => 'ബന്ധ ശൈലി';

  @override
  String get mentalBurnoutStageLabel => 'തളർച്ചാ ഘട്ടം';

  @override
  String get mentalWord => 'മാനസികം';

  @override
  String get mentalYogasTitle => 'മാനസിക യോഗങ്ങൾ';

  @override
  String get mentalStressPressureLabel => 'സമ്മർദ്ദ ഭാരം';

  @override
  String get mentalWellnessTrendTitle => 'സൗഖ്യ പ്രവണത';

  @override
  String get mentalHealthyCopingTitle => '✓ ആരോഗ്യകരമായ നേരിടൽ';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ അനാരോഗ്യകര അപകടങ്ങൾ';

  @override
  String get mentalRecommendedAlternativesTitle => '✦ ശുപാർശ ചെയ്ത ബദലുകൾ';

  @override
  String get mentalSleepQualityStat => 'ഉറക്ക നിലവാരം';

  @override
  String get mentalSocialSupportStat => 'സാമൂഹിക പിന്തുണ';

  @override
  String get mentalBurnoutVulnStat => 'തളർച്ചാ ദുർബലത';

  @override
  String get mentalSelfAwarenessStat => 'സ്വയബോധം';

  @override
  String get mentalAnxietyWord => 'ഉത്കണ്ഠ';

  @override
  String get mentalTypesSuffix => 'തരങ്ങൾ';

  @override
  String get mentalTherapyWord => 'തെറാപ്പി';

  @override
  String get mentalModalityFitSuffix => 'രീതി യോജിപ്പ്';

  @override
  String get characterScoresHeader => '🔍 സ്വഭാവ സ്കോറുകൾ';

  @override
  String get characterStrengthStat => 'സ്വഭാവ\nബലം';

  @override
  String get characterIntegrityStat => 'സത്യസന്ധത';

  @override
  String get characterResilienceStat => 'പ്രതിരോധം';

  @override
  String get characterAwarenessStat => 'അവബോധം';

  @override
  String get characterStabilityStat => 'സ്ഥിരത';

  @override
  String get characterEthicsStat => 'ധാർമ്മികത';

  @override
  String get characterSurfacePersonalityTitle => 'ബാഹ്യ വ്യക്തിത്വം';

  @override
  String get characterLagnaLabel => 'ലഗ്നം';

  @override
  String get characterConstitutionLabel => 'പ്രകൃതി';

  @override
  String get characterNakshatraLabel => 'നക്ഷത്രം';

  @override
  String get characterDeityLabel => 'ദേവത';

  @override
  String get characterMoonManasTitle => 'ചന്ദ്ര മനസ്സ്';

  @override
  String get characterSignLabel => 'രാശി';

  @override
  String get characterHouseLabel => 'ഭാവം';

  @override
  String get characterWarmthStat => 'ഊഷ്മളത';

  @override
  String get characterEmpathyStat => 'സഹാനുഭൂതി';

  @override
  String get characterLoyaltyStat => 'വിശ്വസ്തത';

  @override
  String get characterBoundariesStat => 'അതിരുകൾ';

  @override
  String get characterDharmaStat => 'ധർമ്മം';

  @override
  String get characterTruthStat => 'സത്യം';

  @override
  String get characterCompassionStat => 'കാരുണ്യം';

  @override
  String get characterGenerosityStat => 'ഔദാര്യം';

  @override
  String get characterSignatureVirtuesTitle => '★ മുദ്ര ഗുണങ്ങൾ';

  @override
  String get characterNaturalTalentsTitle => '● സ്വാഭാവിക കഴിവുകൾ';

  @override
  String get characterShadowPatternsTitle => '⚠ നിഴൽ പാറ്റേണുകൾ';

  @override
  String get characterYogasTitle => 'സ്വഭാവ യോഗങ്ങൾ';

  @override
  String get characterTestsLabel => 'പരീക്ഷണങ്ങൾ';

  @override
  String get characterGiftsLabel => 'വരങ്ങൾ';

  @override
  String get characterSelfAwareEiStat => 'സ്വയബോധ EI';

  @override
  String get characterSelfRegulateStat => 'സ്വയനിയന്ത്രണം';

  @override
  String get characterEmpathyEiStat => 'സഹാനുഭൂതി EI';

  @override
  String get characterSocialSkillsStat => 'സാമൂഹിക കഴിവുകൾ';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'സാക്ഷാത്കാരം: ${pct}%';
  }

  @override
  String get characterAtmakarakaWord => 'ആത്മകാരകൻ';

  @override
  String get characterSoulSignatureSuffix => 'ആത്മ മുദ്ര';

  @override
  String get characterAtmakarakaLabel => 'ആത്മകാരകൻ';

  @override
  String get characterGunaWord => 'ഗുണം';

  @override
  String get characterProfileSuffix => 'വിവരണം';

  @override
  String get characterSattvaLabel => 'സത്വം';

  @override
  String get characterRajasLabel => 'രജസ്സ്';

  @override
  String get characterTamasLabel => 'തമസ്സ്';

  @override
  String get healthScoresHeader => '🏥 ആരോഗ്യ സ്കോറുകൾ';

  @override
  String get healthVitalityStat => 'ഓജസ്സ്';

  @override
  String get healthImmunityStat => 'പ്രതിരോധശക്തി';

  @override
  String get healthRecoveryStat => 'വീണ്ടെടുപ്പ്';

  @override
  String get healthMentalStat => 'മാനസികം';

  @override
  String get healthStressTolStat => 'സമ്മർദ്ദ സഹനം';

  @override
  String get healthYogasTitle => 'ആരോഗ്യ യോഗങ്ങൾ';

  @override
  String get healthDiseasePressureLabel => 'രോഗ സമ്മർദ്ദം';

  @override
  String get healthTrendTitle => 'ആരോഗ്യ പ്രവണത';

  @override
  String get healthRecoveryWindowsTitle => 'വീണ്ടെടുപ്പ് കാലങ്ങൾ';

  @override
  String get healthCautionPeriodsTitle => 'ജാഗ്രതാ കാലങ്ങൾ';

  @override
  String get healthFertilityStat => 'പ്രത്യുൽപാദനം';

  @override
  String get healthBurnoutRiskStat => 'തളർച്ചാ അപകടം';

  @override
  String get healthAddictionVulnStat => 'ആസക്തി ദുർബലത';

  @override
  String get healthWorkLifeBalStat => 'തൊഴിൽ-ജീവിത സന്തുലനം';

  @override
  String get healthAyurvedicWord => 'ആയുർവേദ';

  @override
  String get healthConstitutionSuffix => 'പ്രകൃതി';

  @override
  String get healthBodyWord => 'ശരീരം';

  @override
  String get healthSystemMapSuffix => 'സിസ്റ്റം മാപ്പ്';

  @override
  String get healthBodyZoneWord => 'ശരീര മേഖല';

  @override
  String get healthVulnerabilitySuffix => 'ദുർബലത';

  @override
  String get healthDiseaseWord => 'രോഗം';

  @override
  String get healthSusceptibilitySuffix => 'സാധ്യത';

  @override
  String get healthLifestyleFactorsTitle => 'ജീവിതശൈലി ഘടകങ്ങൾ';

  @override
  String get healthSleepDisciplineLabel => 'ഉറക്ക ചിട്ട';

  @override
  String get healthDietDisciplineLabel => 'ആഹാര ചിട്ട';

  @override
  String get healthExerciseNeedLabel => 'വ്യായാമ ആവശ്യം';

  @override
  String get healthSunlightNeedLabel => 'സൂര്യപ്രകാശ ആവശ്യം';

  @override
  String get healthSocialTypeLabel => 'സാമൂഹിക തരം';

  @override
  String get healthHealingSpeedLabel => 'രോഗശാന്തി വേഗം';

  @override
  String get wealthScoresHeader => '💰 സമ്പത്ത് സ്കോറുകൾ';

  @override
  String get wealthStrengthStat => 'സമ്പത്ത്\nബലം';

  @override
  String get wealthAccumulationStat => 'സമ്പാ-\nദനം';

  @override
  String get wealthIncomeFlowStat => 'വരുമാന\nഒഴുക്ക്';

  @override
  String get wealthSustainStat => 'സ്ഥിരത';

  @override
  String get wealthMultiStreamStat => 'ബഹു-സ്രോതസ്സ്';

  @override
  String get wealthRetentionStat => 'സൂക്ഷിപ്പ്';

  @override
  String get wealthWord => 'സമ്പത്ത്';

  @override
  String get wealthYogasTitle => 'സമ്പത്ത് യോഗങ്ങൾ';

  @override
  String get wealthDrainsLabel => 'ചോർച്ചകൾ';

  @override
  String get wealthBoostersLabel => 'വർധകങ്ങൾ';

  @override
  String get wealthYearlyTrendTitle => 'വാർഷിക പ്രവണത';

  @override
  String get wealthGrowthTitle => 'സമ്പത്ത് വളർച്ച';

  @override
  String get wealthCashPressureTitle => 'പണ സമ്മർദ്ദം';

  @override
  String get wealthMoneyPersonalityTitle => 'പണ വ്യക്തിത്വം';

  @override
  String get wealthTypeLabel => 'സമ്പത്ത് തരം';

  @override
  String get wealthRiskAppetiteLabel => 'അപകട സഹനം';

  @override
  String get wealthInvestmentStyleLabel => 'നിക്ഷേപ ശൈലി';

  @override
  String get wealthMoneyPersonalityLabel => 'പണ വ്യക്തിത്വം';

  @override
  String get wealthSpendingLabel => 'ചെലവ്';

  @override
  String get wealthDebtProbStat => 'കട സാധ്യത %';

  @override
  String get wealthInheritanceStat => 'അനന്തരാവകാശം %';

  @override
  String get wealthSuddenGainsStat => 'പെട്ടെന്നുള്ള നേട്ടം %';

  @override
  String get wealthSpouseBoostStat => 'പങ്കാളി ഉയർച്ച %';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'വിജയ സാധ്യത: ${pct}%';
  }

  @override
  String get wealthLifetimeClassLabel => 'ജീവിതകാല സമ്പത്ത് വിഭാഗം';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'പ്രാഥമികം: ${value}';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'ഉച്ചസ്ഥായി: ${value}';
  }

  @override
  String get wealthIncomeWord => 'വരുമാനം';

  @override
  String get wealthSourcesSuffix => 'സ്രോതസ്സുകൾ';

  @override
  String get wealthInvestmentWord => 'നിക്ഷേപം';

  @override
  String get wealthMixSuffix => 'മിശ്രിതം';

  @override
  String wealthDrivenByLabel(Object planet) {
    return '${planet} നയിക്കുന്നു';
  }

  @override
  String get marriageScoresHeader => '💒 വിവാഹ സ്കോറുകൾ';

  @override
  String get marriageOverallStat => 'മൊത്തം\nവിവാഹം';

  @override
  String get marriageHarmonyStat => 'ദാമ്പത്യ\nസൗഹാർദ്ദം';

  @override
  String get marriageDomesticStabilityStat => 'ഗാർഹിക\nസ്ഥിരത';

  @override
  String get marriageLongevityStat => 'ദീർഘായുസ്സ്';

  @override
  String get marriageSatisfactionStat => 'സംതൃപ്തി';

  @override
  String get marriageClarityStat => 'വ്യക്തത';

  @override
  String get marriageWindowsTitle => 'വിവാഹ കാലങ്ങൾ';

  @override
  String get marriagePhasesTitle => 'വിവാഹ ഘട്ടങ്ങൾ';

  @override
  String get marriageInLawRelationsStat => 'വിവാഹബന്ധു ബന്ധം';

  @override
  String get marriageFamilyHarmonyStat => 'കുടുംബ സൗഹാർദ്ദം';

  @override
  String get marriageFertilityStat => 'പ്രത്യുൽപാദനം';

  @override
  String get marriageHomeOwnershipStat => 'വീട് ഉടമസ്ഥത';

  @override
  String get marriageDivorceRiskStat => 'വിവാഹമോചന അപകടം';

  @override
  String get marriageInfidelityStat => 'വിശ്വാസവഞ്ചന';

  @override
  String get marriageConflictStat => 'സംഘർഷം';

  @override
  String get marriageDistanceStat => 'അകലം';

  @override
  String get marriageSeekInPartnerTitle => '★ പങ്കാളിയിൽ അന്വേഷിക്കുക';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ പങ്കാളിയിൽ ഒഴിവാക്കുക';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'സാക്ഷാത്കാരം: ${pct}%';
  }

  @override
  String get marriageDarakarakaWord => 'ദാരാകാരകൻ';

  @override
  String get marriageSpouseKarakaSuffix => 'പങ്കാളി കാരകൻ';

  @override
  String get marriageDarakarakaDkLabel => 'ദാരാകാരകൻ (DK)';

  @override
  String get marriage7thWord => '7-ാം';

  @override
  String get marriageSignLabel => 'രാശി';

  @override
  String get marriageLordInLabel => 'അധിപൻ';

  @override
  String get marriageStrengthLabel => 'ബലം';

  @override
  String get marriageSpouseWord => 'പങ്കാളി';

  @override
  String get marriageProfileSuffix => 'വിവരണം';

  @override
  String get marriageSpouseTraitsTitle => '★ പങ്കാളി സവിശേഷതകൾ';

  @override
  String get marriageLikelyProfessionsTitle => '● സാധ്യതയുള്ള തൊഴിലുകൾ';

  @override
  String get marriageHarmonyWord => 'സൗഹാർദ്ദം';

  @override
  String get marriageRadarSuffix => 'റഡാർ';

  @override
  String get marriagePhysicalLabel => 'ശാരീരികം';

  @override
  String get marriageSharedValuesLabel => 'പങ്കിട്ട മൂല്യങ്ങൾ';

  @override
  String get marriageConflictResolutionLabel => 'സംഘർഷ പരിഹാരം';

  @override
  String get marriageMangalDoshLabel => '⚠ മംഗൾ ദോഷം';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'തീവ്രത: ${value}';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'റദ്ദാക്കൽ: ${value}';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'നവാംശം';

  @override
  String get multiChartTitleChild => 'കുട്ടി';

  @override
  String get multiChartTitleLove => 'പ്രണയം';

  @override
  String get multiChartTitleKarma => 'കർമ്മം';

  @override
  String get multiChartTitleDefault => 'മൾട്ടി-ചാർട്ട്';

  @override
  String get multiChartSuffixProbability => 'സാധ്യത';

  @override
  String get multiChartSuffixCompatibility => 'അനുയോജ്യത';

  @override
  String get multiChartSuffixLinkage => 'ബന്ധം';

  @override
  String get multiChartSuffixReport => 'റിപ്പോർട്ട്';

  @override
  String get multiChartParticipantsLabel => 'പങ്കാളികൾ';

  @override
  String get multiChartAnalysisWord => 'വിശകലനം';

  @override
  String get multiChartConfidenceSuffix => 'ആത്മവിശ്വാസം';

  @override
  String get multiChartQualityBadge => 'ഗുണനിലവാരം';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'ഈ വേദ ജ്യോതിഷ റിപ്പോർട്ട് വിശകലനം ചെയ്ത് വിശദമായ ഉൾക്കാഴ്ചകൾ നൽകുക:\n\n${formatted}';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'ഇതാ ഒരു വേദ ജ്യോതിഷ വിദഗ്ധ റിപ്പോർട്ട്. ദയവായി ഇത് സൂക്ഷ്മമായി വിശകലനം ചെയ്ത് പ്രായോഗിക ഉൾക്കാഴ്ചകൾ നൽകുക:\n\n${formatted}';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'ഈ വേദ ജ്യോതിഷ വിശകലനം അവലോകനം ചെയ്ത് പ്രധാന കണ്ടെത്തലുകൾ ലളിതമായ ഭാഷയിൽ വിശദീകരിക്കുക:\n\n${formatted}';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return '${label} എന്നതിനായി പകർത്തി!';
  }

  @override
  String get childProbTitle1 => 'കുട്ടി';

  @override
  String get childProbTitle2 => 'സാധ്യത';

  @override
  String get childNumberOfChildrenHeader1 => 'കുട്ടികളുടെ';

  @override
  String get childNumberOfChildrenHeader2 => 'എണ്ണം';

  @override
  String get childTimingHeader1 => 'സമയം';

  @override
  String get childTimingHeader2 => 'മൂല ദശ';

  @override
  String get child5thHouseHeader1 => '5-ാം ഭാവം';

  @override
  String get analysisWord => 'വിശകലനം';

  @override
  String get jupiterWord => 'വ്യാഴം';

  @override
  String get childD7Header1 => 'D7 സപ്താംശം';

  @override
  String get childBeejaHeader1 => 'ബീജ & ക്ഷേത്ര';

  @override
  String get childBeejaHeader2 => 'സ്ഫുടം';

  @override
  String get childDoshaHeader1 => 'ദോഷം';

  @override
  String get childVedicHeader1 => 'വേദ';

  @override
  String get childVedicHeader2 => 'പരിഹാരങ്ങൾ';

  @override
  String get progenyProbabilityLabel => 'സന്താന സാധ്യത';

  @override
  String get favorableWindowsLabel => 'അനുകൂല കാലങ്ങൾ';

  @override
  String get partnerOneLabel => 'പങ്കാളി 1';

  @override
  String get partnerTwoLabel => 'പങ്കാളി 2';

  @override
  String get moonSignLabel => 'ചന്ദ്ര രാശി';

  @override
  String get lordInDusthana => 'അധിപൻ ദുസ്ഥാനത്തിൽ';

  @override
  String get lordStrengthLabel => 'അധിപ ബലം';

  @override
  String get houseStrengthLabel => 'ഭാവ ബലം';

  @override
  String get dignityLabel => 'ബലം';

  @override
  String get directBadge => 'മാർഗ്ഗി';

  @override
  String get notCombustBadge => 'അസ്തമിക്കാത്ത';

  @override
  String get in5thHouseBadge => '5-ാം ഭാവത്തിൽ';

  @override
  String get aspects5thBadge => '5-ാം ഭാവം ദൃഷ്ടി';

  @override
  String get no5thConnectionBadge => '5-ാം ഭാവ ബന്ധമില്ല';

  @override
  String jupiterInSignHeading(String sign) {
    return '${sign} രാശിയിൽ വ്യാഴം';
  }

  @override
  String get d7LagnaLabel => 'D7 ലഗ്നം';

  @override
  String get d7FifthSignLabel => 'D7 5-ാം രാശി';

  @override
  String get d7FifthLordLabel => 'D7 5-ാം അധിപൻ';

  @override
  String get jupiterInD7Label => 'D7-ൽ വ്യാഴം';

  @override
  String get jupiterDignityLabel => 'വ്യാഴ ബലം';

  @override
  String get d7StrengthLabel => 'D7 ബലം';

  @override
  String get yesWord => 'അതെ';

  @override
  String get noWord => 'അല്ല';

  @override
  String get beejaSphutaTitle => 'ബീജ സ്ഫുടം';

  @override
  String get kshetraSphutaTitle => 'ക്ഷേത്ര സ്ഫുടം';

  @override
  String get degreeLabel => 'ഡിഗ്രി';

  @override
  String get signLordLabel => 'രാശ്യധിപൻ';

  @override
  String get presentInLabel => 'സ്ഥിതി';

  @override
  String get netPenaltyLabel => 'മൊത്തം ന്യൂനത';

  @override
  String get remedyGemstone => 'രത്ന പരിഹാരങ്ങൾ';

  @override
  String get remedyMantra => 'മന്ത്ര പരിഹാരങ്ങൾ';

  @override
  String get remedyRitual => 'അനുഷ്ഠാന പരിഹാരങ്ങൾ';

  @override
  String get remedyLifestyle => 'ജീവിതശൈലി പരിഹാരങ്ങൾ';

  @override
  String get remedyCharitable => 'ദാന പരിഹാരങ്ങൾ';

  @override
  String copiedForName(String name) {
    return '${name} എന്നതിനായി പകർത്തി!';
  }

  @override
  String get mahadashaLabel => 'മഹാദശ';

  @override
  String get mdPeriodLabel => 'MD കാലയളവ്';

  @override
  String get antardashaLabel => 'അന്തർദശ';

  @override
  String get adPeriodLabel => 'AD കാലയളവ്';

  @override
  String get pratyantardashaLabel => 'പ്രത്യന്തർദശ';

  @override
  String get favorabilityLabel => 'അനുകൂലത';

  @override
  String factorPrefix(String factor) {
    return 'ഘടകം: ${factor}';
  }

  @override
  String appliesToLabel(String value) {
    return 'ബാധകം: ${value}';
  }

  @override
  String get qualityTag => 'ഗുണനിലവാരം';

  @override
  String get reliabilityVeryHigh => 'വളരെ ഉയർന്ന വിശ്വാസ്യത';

  @override
  String get reliabilityGuidanceLevel => 'മാർഗ്ഗനിർദ്ദേശ നിലവാര വായന';

  @override
  String get karmaLinkTitle1 => 'കർമ്മ';

  @override
  String get karmaLinkTitle2 => 'ബന്ധം';

  @override
  String get karmaFoundationHeader1 => 'കാർമിക';

  @override
  String get karmaFoundationHeader2 => 'അടിസ്ഥാനം';

  @override
  String get karmaPairwiseHeader1 => 'ജോഡി';

  @override
  String get karmaPairwiseHeader2 => 'ബന്ധങ്ങൾ';

  @override
  String get karmaGroupHeader1 => 'ഗ്രൂപ്പ്';

  @override
  String get karmaGroupHeader2 => 'പാറ്റേൺ';

  @override
  String get karmaPastLifeHeader1 => 'പൂർവജന്മ';

  @override
  String get karmaPastLifeHeader2 => 'ലക്ഷ്യങ്ങൾ';

  @override
  String get karmaCurrentLifeHeader1 => 'ഇപ്പോഴത്തെ ജന്മം';

  @override
  String get karmaCurrentLifeHeader2 => 'പഠനം';

  @override
  String get karmaDebtsHeader2 => 'കടങ്ങൾ';

  @override
  String get karmaMoolaDashaHeader1 => 'മൂല ദശ';

  @override
  String get karmaMoolaDashaHeader2 => 'സമയം';

  @override
  String get karmaDeepAuditHeader1 => 'ആഴത്തിലുള്ള ഓഡിറ്റ്';

  @override
  String get karmaDeepAuditHeader2 => 'പട്ടിക';

  @override
  String get karmaHeroLabel => 'പൂർവജന്മ കർമ്മ ബന്ധം';

  @override
  String get karmaKetuMastery => 'കേതു പ്രാവീണ്യം';

  @override
  String get nakshatraLabel => 'നക്ഷത്രം';

  @override
  String get deityLabel => 'ദേവത';

  @override
  String get masteryScoreLabel => 'പ്രാവീണ്യ സ്കോർ';

  @override
  String get karmaRahuGrowth => 'രാഹു വളർച്ച';

  @override
  String get growthScoreLabel => 'വളർച്ചാ സ്കോർ';

  @override
  String get karmaAtmakaraka => 'ആത്മകാരകൻ';

  @override
  String get karmaSaturnKarma => 'ശനി കർമ്മം';

  @override
  String get karma12thHouse => '12-ാം ഭാവം';

  @override
  String get karma9thHousePunya => '9-ാം ഭാവ പുണ്യം';

  @override
  String get bhavaScoreLabel => 'ഭാവ സ്കോർ';

  @override
  String get karmaD60Signature => 'D60 മുദ്ര';

  @override
  String get depthScoreLabel => 'ആഴ സ്കോർ';

  @override
  String get linkageStrengthLabel => 'ബന്ധ ബലം';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'ബന്ധ ഘടകങ്ങൾ (${count} സജീവം)';
  }

  @override
  String get factorColumnLabel => 'ഘടകം';

  @override
  String get weightColumnLabel => 'ഭാരം';

  @override
  String get meaningColumnLabel => 'അർത്ഥം';

  @override
  String get statusColumnLabel => 'അവസ്ഥ';

  @override
  String get karmaPastLifeConnection => 'പൂർവജന്മ ബന്ധം';

  @override
  String get karmaCurrentLifeDynamic => 'ഇപ്പോഴത്തെ ജന്മ ചലനാത്മകത';

  @override
  String get karmaWhatTheyTeach => 'അവർ പരസ്പരം പഠിപ്പിക്കുന്നത്';

  @override
  String get karmaGroupThemeHeader => 'ഗ്രൂപ്പ് കാർമിക വിഷയം';

  @override
  String get karmaSharedSettingHeader => 'പങ്കിട്ട പൂർവജന്മ പശ്ചാത്തലം';

  @override
  String get karmaCollectiveKetuHeader => 'കൂട്ടായ കേതു പാറ്റേൺ';

  @override
  String get karmaCollectiveRahuHeader => 'കൂട്ടായ രാഹു പാറ്റേൺ';

  @override
  String get housesPrefixLabel => 'ഭാവങ്ങൾ: ';

  @override
  String get signsPrefixLabel => 'രാശികൾ: ';

  @override
  String get karmicCohesionLabel => 'കാർമിക ഐക്യം';

  @override
  String get karmaGroupSoulContractHeader => 'ഗ്രൂപ്പ് ആത്മ കരാർ';

  @override
  String get goalLabel => 'ലക്ഷ്യം';

  @override
  String get karmaSharedGoalHeader => 'പങ്കിട്ട പൂർവജന്മ ലക്ഷ്യം';

  @override
  String get howToGrowHeader => 'എങ്ങനെ വളരാം';

  @override
  String moolaDashaPrefix(String value) {
    return 'മൂല ദശ: ${value}';
  }

  @override
  String get karmaSharedLessonHeader => 'പങ്കിട്ട ഗ്രൂപ്പ് പാഠം';

  @override
  String get karmaMutualTeachingHeader => 'പരസ്പര അധ്യാപന മാപ്പ്';

  @override
  String get karmaTeachingDynamicsPlaceholder => 'കാർമിക ബന്ധങ്ങൾ ആഴപ്പെടുമ്പോൾ അധ്യാപന ചലനാത്മകത ഉയർന്നുവരും.';

  @override
  String get typeFieldLabel => 'തരം';

  @override
  String get basisFieldLabel => 'അടിസ്ഥാനം';

  @override
  String get resolutionPathHeader => 'പരിഹാര പഥം';

  @override
  String dashaTimingPrefix(String value) {
    return 'ദശ സമയം: ${value}';
  }

  @override
  String get mutualDebtsHeader => 'പരസ്പര കടങ്ങൾ';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'തീയതികൾ';

  @override
  String get groupKarmicWindowHeader => 'ഗ്രൂപ്പ് കാർമിക കാലം';

  @override
  String parametersAuditedHeading(int count) {
    return '${count} പാരാമീറ്ററുകൾ ഓഡിറ്റ് ചെയ്തു';
  }

  @override
  String get valuePrefixLabel => 'മൂല്യം: ';

  @override
  String weightPrefix(String value) {
    return 'ഭാ: ${value}';
  }

  @override
  String get loveCompatTitle1 => 'പ്രണയ';

  @override
  String get loveCompatTitle2 => 'അനുയോജ്യത';

  @override
  String get loveAttractionHeader1 => 'ആകർഷണം &';

  @override
  String get loveAttractionHeader2 => 'രസതന്ത്രം';

  @override
  String get loveEmotionalHeader1 => 'വൈകാരിക';

  @override
  String get loveEmotionalHeader2 => 'സൗഹാർദ്ദം';

  @override
  String get loveMentalHeader1 => 'മാനസിക';

  @override
  String get loveMentalHeader2 => 'പൊരുത്തം';

  @override
  String get lovePassionHeader1 => 'അഭിനിവേശം &';

  @override
  String get lovePassionHeader2 => 'ശാരീരികം';

  @override
  String get loveLongtermHeader1 => 'ദീർഘകാല';

  @override
  String get loveKarmicHeader1 => 'കാർമിക പ്രണയ';

  @override
  String get loveKarmicHeader2 => 'ബന്ധം';

  @override
  String get loveChallengesHeader1 => 'വെല്ലുവിളികൾ &';

  @override
  String get loveChallengesHeader2 => 'ഘർഷണം';

  @override
  String get loveTimingHeader1 => 'പ്രണയ സമയം';

  @override
  String get loveRelationshipHeader1 => 'ബന്ധ';

  @override
  String get loveRelationshipHeader2 => 'ചലനാത്മകത';

  @override
  String get loveRemediesHeader1 => 'പരിഹാരങ്ങൾ &';

  @override
  String get loveRemediesHeader2 => 'മാർഗ്ഗനിർദ്ദേശം';

  @override
  String get loveCompatHeroLabel => 'പ്രണയ അനുയോജ്യത';

  @override
  String get loveChipAttraction => 'ആകർഷണം';

  @override
  String get loveChipPassion => 'അഭിനിവേശം';

  @override
  String get loveChipChallenge => 'വെല്ലുവിളി';

  @override
  String get venusSignLabel => 'ശുക്ര രാശി';

  @override
  String get attractionScoreLabel => 'ആകർഷണ സ്കോർ';

  @override
  String get activeContactsLabel => 'സജീവ ബന്ധങ്ങൾ';

  @override
  String get magneticPullLabel => 'കാന്തിക ആകർഷണം';

  @override
  String get initialAttractionLabel => 'പ്രാരംഭ ആകർഷണം';

  @override
  String get emotionalScoreLabel => 'വൈകാരിക സ്കോർ';

  @override
  String get elementMatchLabel => 'ഭൂത പൊരുത്തം';

  @override
  String get harmonyLabel => 'സൗഹാർദ്ദം';

  @override
  String get kootaYoni => 'യോനി';

  @override
  String get kootaGana => 'ഗണം';

  @override
  String get kootaTara => 'താര';

  @override
  String get doshaPresentBadge => 'ദോഷം ഉണ്ട്';

  @override
  String get noDoshaBadge => 'ദോഷമില്ല';

  @override
  String get axisLabel => 'അക്ഷം';

  @override
  String get mentalScoreLabel => 'മാനസിക സ്കോർ';

  @override
  String get mercuryDynamicsLabel => 'ബുധ ചലനാത്മകത';

  @override
  String get communicationStyleLabel => 'ആശയവിനിമയ ശൈലി പൊരുത്തം';

  @override
  String get intellectualConnectionLabel => 'ബൗദ്ധിക ബന്ധം';

  @override
  String get passionScoreLabel => 'അഭിനിവേശ സ്കോർ';

  @override
  String get marsVenusLabel => 'ചൊവ്വ-ശുക്ര പരസ്പരബന്ധം';

  @override
  String get physicalChemistryLabel => 'ശാരീരിക രസതന്ത്രം';

  @override
  String get yoniCompatLabel => 'യോനി അനുയോജ്യത';

  @override
  String get longtermScoreLabel => 'ദീർഘകാല സ്കോർ';

  @override
  String get seventhHouseSynastryLabel => '7-ാം ഭാവ സിനാസ്ട്രി';

  @override
  String get commitmentPotentialLabel => 'പ്രതിബദ്ധതാ സാധ്യത';

  @override
  String get jupiterBlessingLabel => 'വ്യാഴ അനുഗ്രഹം';

  @override
  String get d9NavamsaResonanceLabel => 'D9 നവാംശ അനുരണനം';

  @override
  String get saturnLongevityLabel => 'ശനി ദീർഘായുസ്സ്';

  @override
  String get karmicScoreLabel => 'കാർമിക സ്കോർ';

  @override
  String get darakarakaLinkLabel => 'ദാരാകാരക ബന്ധം';

  @override
  String get sourceLabel => 'സ്രോതസ്സ്';

  @override
  String get emotionalGiverReceiverLabel => 'വൈകാരിക ദാതാവ് / സ്വീകർത്താവ്';

  @override
  String get powerBalanceLabel => 'അധികാര സന്തുലനം';

  @override
  String get growthDynamicLabel => 'വളർച്ചാ ചലനാത്മകത';

  @override
  String get addressesLabel => 'പരിഹരിക്കുന്നു';

  @override
  String get loveScoresLabel => 'പ്രണയ സ്കോറുകൾ';

  @override
  String get loveCapacityLabel => 'പ്രണയ\nശേഷി';

  @override
  String get emotionalAvailabilityLabel => 'വൈകാരിക\nലഭ്യത';

  @override
  String get romanticAttractionLabel => 'പ്രണയ\nആകർഷണം';

  @override
  String get commitmentWord => 'പ്രതിബദ്ധത';

  @override
  String get intimacyWord => 'അടുപ്പം';

  @override
  String get fidelityWord => 'വിശ്വസ്തത';

  @override
  String get loveProfileTitle => 'പ്രണയ വിവരണം';

  @override
  String get loveStyleLabel => 'പ്രണയ ശൈലി';

  @override
  String get attractionStyleLabel => 'ആകർഷണ ശൈലി';

  @override
  String get lovePathLabel => 'പ്രണയ പഥം';

  @override
  String get currentPhaseLabel => 'നിലവിലെ ഘട്ടം';

  @override
  String get commitmentStyleLabel => 'പ്രതിബദ്ധതാ ശൈലി';

  @override
  String get loveWord => 'പ്രണയം';

  @override
  String get karakasWord => 'കാരകങ്ങൾ';

  @override
  String get attractedToLabel => 'ആകർഷിക്കപ്പെടുന്നത്';

  @override
  String get whatPartnerSeesLabel => 'പങ്കാളി കാണുന്നത്';

  @override
  String get romancePatternTitle => 'പ്രണയ പാറ്റേൺ';

  @override
  String get firstLoveAgeLabel => 'ആദ്യ പ്രണയ പ്രായം';

  @override
  String get relationshipCountLabel => 'ബന്ധങ്ങളുടെ എണ്ണം';

  @override
  String get avgDurationLabel => 'ശരാശരി കാലയളവ്';

  @override
  String get breakupTriggerLabel => 'വേർപിരിയൽ കാരണം';

  @override
  String get heartbreakRecoveryLabel => 'ഹൃദയഭംഗ വീണ്ടെടുപ്പ്';

  @override
  String get loveTrendTitle => 'പ്രണയ പ്രവണത';

  @override
  String get newLoveWindowsTitle => 'പുതിയ പ്രണയ കാലങ്ങൾ';

  @override
  String get loveBlocksTitle => 'പ്രണയ തടസ്സങ്ങൾ';

  @override
  String get activeBlocksLabel => 'സജീവ തടസ്സങ്ങൾ';

  @override
  String get loveMarriagePctLabel => 'പ്രണയ വിവാഹം %';

  @override
  String get heartbreakVulnLabel => 'ഹൃദയഭംഗ ദുർബലത';

  @override
  String get selfSabotageLabel => 'സ്വയം നാശം';

  @override
  String get emotionalIqLabel => 'വൈകാരിക IQ';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'പൂർത്തീകരണം: ${pct}%';
  }

  @override
  String get languagesWord => 'ഭാഷകൾ';

  @override
  String get givesLabel => 'നൽകുന്നു';

  @override
  String get receivesLabel => 'സ്വീകരിക്കുന്നു';

  @override
  String get idealWord => 'ആദർശ';

  @override
  String get partnerWord => 'പങ്കാളി';

  @override
  String get seekTheseTraitsLabel => 'ഈ സവിശേഷതകൾ അന്വേഷിക്കുക';

  @override
  String get dealbreakersLabel => 'ഒഴിവാക്കേണ്ടവ';

  @override
  String get propertyScoresLabel => 'സ്വത്ത് സ്കോറുകൾ';

  @override
  String get acquisitionCapacityLabel => 'സമ്പാദന\nശേഷി';

  @override
  String get homeOwnershipPctLabel => 'വീട്\nഉടമസ്ഥത %';

  @override
  String get reWealthPotentialLabel => 'റിയൽ എസ്റ്റേറ്റ്\nസമ്പത്ത് സാധ്യത';

  @override
  String get rentalWord => 'വാടക';

  @override
  String get vehiclesWord => 'വാഹനങ്ങൾ';

  @override
  String get landPctLabel => 'ഭൂമി %';

  @override
  String get propertyProfileTitle => 'സ്വത്ത് വിവരണം';

  @override
  String get karmaTypeLabel => 'കർമ്മ തരം';

  @override
  String get environmentLabel => 'പരിസ്ഥിതി';

  @override
  String get styleLabel => 'ശൈലി';

  @override
  String get sizeLabel => 'വലുപ്പം';

  @override
  String get locationLabel => 'സ്ഥലം';

  @override
  String get actionNext12mLabel => 'അടുത്ത 12 മാസ നടപടി';

  @override
  String get propertyWord => 'സ്വത്ത്';

  @override
  String get propertyYogasTitle => 'സ്വത്ത് യോഗങ്ങൾ';

  @override
  String get drainsLabel => 'ചോർച്ചകൾ';

  @override
  String get boostersLabel => 'വർധകങ്ങൾ';

  @override
  String get propertyTrendTitle => 'സ്വത്ത് പ്രവണത';

  @override
  String get buyingWindowsTitle => 'വാങ്ങൽ കാലങ്ങൾ';

  @override
  String get constructionWindowsTitle => 'നിർമ്മാണ കാലങ്ങൾ';

  @override
  String get maternalInherPctLabel => 'മാതൃ അനന്തരാവകാശം %';

  @override
  String get paternalInherPctLabel => 'പിതൃ അനന്തരാവകാശം %';

  @override
  String get multiHomePctLabel => 'ബഹു-വീട് %';

  @override
  String get investmentPctLabel => 'നിക്ഷേപം %';

  @override
  String get vehicleProfileTitle => 'വാഹന വിവരണം';

  @override
  String get countLabel => 'എണ്ണം';

  @override
  String get firstAgeLabel => 'ആദ്യ പ്രായം';

  @override
  String get categoryLabel => 'വിഭാഗം';

  @override
  String get luxuryLabel => 'ആഡംബരം';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'ജീവിതകാല എണ്ണം: ${count} · പൂർത്തീകരണം: ${pct}%';
  }

  @override
  String get pressureWord => 'സമ്മർദ്ദം';

  @override
  String get protectionWord => 'സംരക്ഷണം';

  @override
  String get astrologicalWord => 'ജ്യോതിഷ';

  @override
  String get keyRisksHeader1 => 'പ്രധാന';

  @override
  String get keyRisksHeader2 => 'അപകടങ്ങൾ';

  @override
  String get reportCopiedShort => 'റിപ്പോർട്ട് പകർത്തി!';

  @override
  String get keyScoresLabel => 'പ്രധാന സ്കോറുകൾ';

  @override
  String allScoresCountLabel(int count) {
    return 'എല്ലാ സ്കോറുകളും (${count})';
  }

  @override
  String get windowsWord => 'കാലങ്ങൾ';

  @override
  String get genericFailedMsg => 'പരാജയപ്പെട്ടു';

  @override
  String get unknownWord => 'അജ്ഞാതം';

  @override
  String selectKarmaChartsLabel(int max) {
    return '2-${max} ചാർട്ടുകൾ തിരഞ്ഞെടുക്കുക';
  }

  @override
  String selectChartsLabelCount(int max) {
    return '${max} ചാർട്ടുകൾ തിരഞ്ഞെടുക്കുക';
  }

  @override
  String runningAnalysisLabel(String label) {
    return '${label} വിശകലനം നടക്കുന്നു...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'കാർമിക ബന്ധങ്ങൾ വിശകലനം ചെയ്യാൻ 2 മുതൽ ${max} വരെ ചാർട്ടുകൾ തിരഞ്ഞെടുക്കുക';
  }

  @override
  String get pickMaleFemaleHint => 'ഒരു പുരുഷ, സ്ത്രീ ചാർട്ട് തിരഞ്ഞെടുക്കുക';

  @override
  String get personOneLabel => 'വ്യക്തി 1';

  @override
  String get personTwoLabel => 'വ്യക്തി 2';

  @override
  String get analysisFailedMsg => 'വിശകലനം പരാജയപ്പെട്ടു';

  @override
  String analyzeChartsCountLabel(int count) {
    return '${count} ചാർട്ടുകൾ വിശകലനം ചെയ്യുക';
  }

  @override
  String get contextGeneralLabel => 'പൊതുവായത്';

  @override
  String get contextLoveLabel => 'പ്രണയം';

  @override
  String get contextBusinessLabel => 'ബിസിനസ്';

  @override
  String get contextFamilyLabel => 'കുടുംബം';

  @override
  String get contextTeamLabel => 'ടീം';

  @override
  String get contextFriendshipLabel => 'സൗഹൃദം';

  @override
  String get relationshipIntelTitle => 'ബന്ധ ഇന്റലിജൻസ്';

  @override
  String analyzingChartsCountLabel(int count) {
    return '${count} ചാർട്ടുകൾ വിശകലനം ചെയ്യുന്നു...';
  }

  @override
  String get relationshipContextLabel => 'ബന്ധ സന്ദർഭം';

  @override
  String get kundliMilanReportTitle => 'കുണ്ഡലി മിലൻ റിപ്പോർട്ട്';

  @override
  String get runningMilanAnalysisLabel => 'മിലൻ വിശകലനം നടക്കുന്നു...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '${count}/2 തിരഞ്ഞെടുത്തു';
  }

  @override
  String get runMilanAnalysisBtn => 'മിലൻ വിശകലനം നടത്തുക';

  @override
  String get noChartsCreateFirst => 'ചാർട്ടുകളില്ല. ആദ്യം ഒരു ജന്മ ചാർട്ട് സൃഷ്ടിക്കുക.';

  @override
  String get selectBirthChartAnalyze => 'വിശകലനം ചെയ്യാൻ ഒരു ജന്മ ചാർട്ട് തിരഞ്ഞെടുക്കുക';

  @override
  String get doshAnalysis => 'ദോഷ വിശകലനം';

  @override
  String doshActiveCount(Object active, Object total) {
    return '${active} സജീവം / ${total} പരിശോധിച്ചു';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '${active} സജീവം / ${total} യോഗങ്ങൾ പരിശോധിച്ചു';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'സജീവ യോഗങ്ങൾ (${count})';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'നിഷ്ക്രിയ യോഗങ്ങൾ മറയ്ക്കുക (${count})';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'നിഷ്ക്രിയ യോഗങ്ങൾ കാണിക്കുക (${count})';
  }

  @override
  String get loadFailed => 'പരാജയപ്പെട്ടു';

  @override
  String dashaDrillMd(Object planet) {
    return '${planet} MD → അന്തർദശകൾ';
  }

  @override
  String dashaDrillAd(Object planet) {
    return '${planet} AD → പ്രത്യന്തർദശകൾ';
  }

  @override
  String dashaDrillPd(Object planet) {
    return '${planet} PD → സൂക്ഷ്മദശകൾ';
  }

  @override
  String dashaDrillSub(Object planet) {
    return '${planet} ഉപകാലങ്ങൾ';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return 'ജന്മ അധിപൻ: ${lord} • ബാലൻസ്: ${balance} വർഷം';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'ലഗ്നം: ${lagna} • ബാലൻസ്: ${balance} വർഷം';
  }

  @override
  String dashaYearsValue(Object years) {
    return '${years} വർഷം';
  }

  @override
  String get dashaCurrentPeriod => 'നിലവിലെ ദശ കാലയളവ്';

  @override
  String dashaAsOf(Object date) {
    return 'അന്നത്തെ നിലയിൽ: ${date}';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'നിലവിലെ കാലയളവിലെ സജീവ യോഗങ്ങൾ (${count})';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'നിലവിലെ കാലയളവിലെ സജീവ ദോഷങ്ങൾ (${count})';
  }

  @override
  String get dashaNoYogasTriggered => 'യോഗങ്ങളൊന്നും സജീവമല്ല';

  @override
  String get dashaNoDoshasTriggered => 'ദോഷങ്ങളൊന്നും സജീവമല്ല';

  @override
  String get divD1Name => 'രാശി (D-1)';

  @override
  String get divD1Desc => 'ശാരീരിക അസ്തിത്വം, എല്ലാ വിഷയങ്ങളും';

  @override
  String get divD2Name => 'ഹോര (D-2)';

  @override
  String get divD2Desc => 'സമ്പത്ത്, പണം';

  @override
  String get divD3Name => 'ദ്രേക്കാണം (D-3)';

  @override
  String get divD3Desc => 'സഹോദരങ്ങൾ, ധൈര്യം';

  @override
  String get divD4Name => 'ചതുർത്ഥാംശം (D-4)';

  @override
  String get divD4Desc => 'സ്വത്ത്, വാസസ്ഥലം, ഭാഗ്യം';

  @override
  String get divD5Name => 'പഞ്ചാംശം (D-5)';

  @override
  String get divD5Desc => 'പ്രശസ്തി, അധികാരം, ശക്തി';

  @override
  String get divD6Name => 'ഷഷ്ഠാംശം (D-6)';

  @override
  String get divD6Desc => 'ആരോഗ്യ പ്രശ്നങ്ങൾ';

  @override
  String get divD7Name => 'സപ്താംശം (D-7)';

  @override
  String get divD7Desc => 'കുട്ടികൾ, കൊച്ചുമക്കൾ';

  @override
  String get divD8Name => 'അഷ്ടാംശം (D-8)';

  @override
  String get divD8Desc => 'പെട്ടെന്നുള്ള കുഴപ്പങ്ങൾ, വ്യവഹാരം';

  @override
  String get divD9Name => 'നവാംശം (D-9)';

  @override
  String get divD9Desc => 'വിവാഹം, പങ്കാളി, ധർമ്മം';

  @override
  String get divD10Name => 'ദശാംശം (D-10)';

  @override
  String get divD10Desc => 'കരിയർ, തൊഴിൽ';

  @override
  String get divD11Name => 'രുദ്രാംശം (D-11)';

  @override
  String get divD11Desc => 'മരണം, നാശം';

  @override
  String get divD12Name => 'ദ്വാദശാംശം (D-12)';

  @override
  String get divD12Desc => 'മാതാപിതാക്കൾ, രക്തബന്ധുക്കൾ';

  @override
  String get divD16Name => 'ഷോഡശാംശം (D-16)';

  @override
  String get divD16Desc => 'വാഹനങ്ങൾ, സുഖസൗകര്യങ്ങൾ, ആനന്ദങ്ങൾ';

  @override
  String get divD20Name => 'വിംശാംശം (D-20)';

  @override
  String get divD20Desc => 'ആധ്യാത്മിക വിഷയങ്ങൾ, മത';

  @override
  String get divD24Name => 'ചതുർവിംശാംശം (D-24)';

  @override
  String get divD24Desc => 'പഠനം, ജ്ഞാനം, വിദ്യാഭ്യാസം';

  @override
  String get divD27Name => 'നക്ഷത്രാംശം (D-27)';

  @override
  String get divD27Desc => 'ശക്തികൾ, ദൗർബല്യങ്ങൾ, സ്വഭാവം';

  @override
  String get divD30Name => 'ത്രിംശാംശം (D-30)';

  @override
  String get divD30Desc => 'തിന്മകൾ, ഉപബോധമനസ്സ്, ശിക്ഷ';

  @override
  String get divD40Name => 'ഖവേദാംശം (D-40)';

  @override
  String get divD40Desc => 'ശുഭം/അശുഭം (മാതൃ)';

  @override
  String get divD45Name => 'അക്ഷവേദാംശം (D-45)';

  @override
  String get divD45Desc => 'എല്ലാ വിഷയങ്ങളും (പിതൃ)';

  @override
  String get divD60Name => 'ഷഷ്ട്യംശം (D-60)';

  @override
  String get divD60Desc => 'പൂർവജന്മ കർമ്മം — ഏറ്റവും പ്രധാനം';

  @override
  String get lifeAreaCareer => 'കരിയർ';

  @override
  String get lifeAreaWealth => 'സമ്പത്ത്';

  @override
  String get lifeAreaMarriage => 'വിവാഹം';

  @override
  String get lifeAreaHealth => 'ആരോഗ്യം';

  @override
  String get lifeAreaSpirituality => 'ആധ്യാത്മികത';

  @override
  String lifeAreaGrade(Object grade) {
    return 'ഗ്രേഡ്: ${grade}';
  }

  @override
  String get lifeAreaFactorsLabel => 'ഘടകങ്ങൾ:';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return 'നക്ഷ: ${nakshatra} (${pada})';
  }

  @override
  String planetNakLord(Object lord) {
    return 'നക്ഷ അധിപൻ: ${lord}';
  }

  @override
  String planetLongitude(Object value) {
    return 'രേഖാംശം: ${value}°';
  }

  @override
  String get chakraOverallHealth => 'മൊത്തം ആരോഗ്യം';

  @override
  String get careerWord => 'കരിയർ';

  @override
  String get failedToLoad => 'ലോഡ് ചെയ്യാൻ പരാജയപ്പെട്ടു';

  @override
  String get kundliAscendantLagna => 'ലഗ്നം (ലഗ്നം)';

  @override
  String get kundliMoonSignRashi => 'ചന്ദ്ര രാശി (രാശി)';

  @override
  String get kundliSunSign => 'സൂര്യ രാശി';

  @override
  String kundliEngineLabel(Object engine) {
    return 'എൻജിൻ: ${engine}';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return 'ഡിഗ്രി: ${degree}°  •  നക്ഷത്രം: ${nakshatra} (${pada})';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'നക്ഷത്ര അധിപൻ: ${lord}  •  ബലം: ${dignity}';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return '${base} ചാർട്ട് — ${sign}';
  }

  @override
  String kundliBaseChart(Object base) {
    return '${base} ചാർട്ട്';
  }

  @override
  String get careerSummary => 'കരിയർ സംഗ്രഹം';

  @override
  String get phase => 'ഘട്ടം';

  @override
  String get confidenceLabel => 'ആത്മവിശ്വാസം';

  @override
  String get careerScores => 'കരിയർ സ്കോറുകൾ';

  @override
  String get stabilityLabel => 'സ്ഥിരത';

  @override
  String get growthLabel => 'വളർച്ച';

  @override
  String get gradeExcellent => 'മികച്ചത്';

  @override
  String get gradeGood => 'നല്ലത്';

  @override
  String get gradeAverage => 'ശരാശരി';

  @override
  String get gradeBelowAvg => 'ശരാശരിക്ക് താഴെ';

  @override
  String get gradeWeak => 'ദുർബലം';

  @override
  String get careerTypeDomain => 'കരിയർ & മേഖല';

  @override
  String get careerTimeline => 'കരിയർ ടൈംലൈൻ';

  @override
  String dashaLabel(Object dasha) {
    return 'ദശ: ${dasha}';
  }

  @override
  String get improvementSuggestions => 'മെച്ചപ്പെടുത്തൽ നിർദ്ദേശങ്ങൾ';

  @override
  String get chartDetails => 'ചാർട്ട് വിശദാംശങ്ങൾ';

  @override
  String get keyHousesCareer => 'പ്രധാന ഭാവങ്ങൾ (കരിയർ)';

  @override
  String get keyCareerPlanets => 'പ്രധാന കരിയർ ഗ്രഹങ്ങൾ';

  @override
  String get empty => 'ശൂന്യം';

  @override
  String get guna => 'ഗുണം';

  @override
  String get dasha => 'ദശ';

  @override
  String get satwik => 'സാത്വികം';

  @override
  String get rajasik => 'രാജസികം';

  @override
  String get tamasik => 'താമസികം';

  @override
  String get charGroupCorePersonality => 'പ്രധാന വ്യക്തിത്വം';

  @override
  String get charGroupTrustHonesty => 'വിശ്വാസം & സത്യസന്ധത';

  @override
  String get charGroupLoyaltyCommitment => 'വിശ്വസ്തത & പ്രതിബദ്ധത';

  @override
  String get charGroupStrategicPrivacy => 'തന്ത്രം & സ്വകാര്യത';

  @override
  String get charGroupFinancial => 'സാമ്പത്തികം';

  @override
  String get charGroupAngerConflict => 'കോപം & സംഘർഷം';

  @override
  String get charGroupMoralDharmic => 'ധാർമ്മികം & ധർമ്മം';

  @override
  String get charGroupIntellectCommunication => 'ബുദ്ധി & ആശയവിനിമയം';

  @override
  String get charGroupEmotionalProfile => 'വൈകാരിക വിവരണം';

  @override
  String get charGroupMentalHealth => 'മാനസികാരോഗ്യം';

  @override
  String get charGroupRomantic => 'പ്രണയപരം';

  @override
  String get charGroupMarriageFamily => 'വിവാഹം & കുടുംബം';

  @override
  String get charGroupOverallLife => 'മൊത്തം ജീവിതം';

  @override
  String get grahaDrishti => 'ഗ്രഹ ദൃഷ്ടി (ഗ്രഹ ദൃഷ്ടികൾ)';

  @override
  String get grahaDrishtiSubtitle => 'ആരാരെ ദൃഷ്ടിക്കുന്നു (%)';

  @override
  String get lagnaAspectsReceived => 'ലഗ്നത്തിന് ലഭിക്കുന്ന ദൃഷ്ടികൾ';

  @override
  String get rashiDrishti => 'രാശി ദൃഷ്ടി (രാശി ദൃഷ്ടികൾ)';

  @override
  String get shadbalaRupas => 'രൂപകൾ';

  @override
  String get bhavaHouse1 => 'സ്വയം / ശരീരം';

  @override
  String get bhavaHouse2 => 'സമ്പത്ത് / കുടുംബം';

  @override
  String get bhavaHouse3 => 'സഹോദരങ്ങൾ / ധൈര്യം';

  @override
  String get bhavaHouse4 => 'വീട് / അമ്മ';

  @override
  String get bhavaHouse5 => 'കുട്ടികൾ / ബുദ്ധി';

  @override
  String get bhavaHouse6 => 'ശത്രുക്കൾ / ആരോഗ്യം';

  @override
  String get bhavaHouse7 => 'വിവാഹം / പങ്കാളി';

  @override
  String get bhavaHouse8 => 'ആയുസ്സ്';

  @override
  String get bhavaHouse9 => 'ഭാഗ്യം / ഗുരു';

  @override
  String get bhavaHouse10 => 'കരിയർ / അച്ഛൻ';

  @override
  String get bhavaHouse11 => 'നേട്ടങ്ങൾ / സുഹൃത്തുക്കൾ';

  @override
  String get bhavaHouse12 => 'നഷ്ടം / മോക്ഷം';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '${sign} • അധിപൻ: ${lord}';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: ${value}';
  }

  @override
  String get sarvaAshtakavarga => 'സർവ അഷ്ടകവർഗ (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'ആകെ: ${total} രേഖകൾ (ശരാശരി രാശി = ${avg})';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '${planet} — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'ആകെ: ${total} രേഖകൾ • ജന്മ രാശിയിൽ: ${score}';
  }

  @override
  String get today => 'ഇന്ന്';

  @override
  String gocharTransitScores(Object date) {
    return 'ഗോചരം (സഞ്ചാര സ്കോറുകൾ) — ${date}';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'ജന്മ ചന്ദ്രൻ: ${sign}';
  }

  @override
  String get gocharBest => 'മികച്ചത്';

  @override
  String get gocharWorst => 'ഏറ്റവും മോശം';

  @override
  String copiedOpening(Object ai) {
    return 'പകർത്തി! ${ai} തുറക്കുന്നു...';
  }

  @override
  String get openLink => 'തുറക്കുക ↗';

  @override
  String get discussReportWithAI => 'ഈ റിപ്പോർട്ട് AI-യുമായി ചർച്ച ചെയ്യുക';

  @override
  String get reliabilityHigh => 'ഉയർന്ന വിശ്വാസ്യത';

  @override
  String get reliabilityModerate => 'മിതമായ വിശ്വാസ്യത';

  @override
  String get reliabilityLow => 'കുറവ് — മാർഗ്ഗനിർദ്ദേശം മാത്രം';

  @override
  String get reliabilityGoodEdu => 'നല്ല വിശ്വാസ്യത · D-24 പരിശോധിച്ചു';

  @override
  String get relationshipWord => 'ബന്ധം';

  @override
  String get intelligenceWord => 'ഇന്റലിജൻസ്';

  @override
  String get relationshipIntelligence => 'ബന്ധ ഇന്റലിജൻസ്';

  @override
  String get typeLabel => 'തരം';

  @override
  String get trustLabel => 'വിശ്വാസം';

  @override
  String get dhokaRisk => 'ധോഖ അപകടം';

  @override
  String get powerLabel => 'ശക്തി';

  @override
  String get integrity => 'സത്യസന്ധത';

  @override
  String get warmth => 'ഊഷ്മളത';

  @override
  String get trustWord => 'വിശ്വാസം';

  @override
  String get assertLabel => 'ദൃഢത';

  @override
  String get character => 'സ്വഭാവം';

  @override
  String get love => 'പ്രണയം';

  @override
  String get businessWord => 'ബിസിനസ്';

  @override
  String get karmic => 'കാർമികം';

  @override
  String get enmityRisk => 'ശത്രുതാ അപകടം';

  @override
  String get hdrChartProfiles => 'ചാർട്ട് വിവരണങ്ങൾ';

  @override
  String get hdrPairwiseAnalysis => 'ജോഡി വിശകലനം';

  @override
  String get hdrCriticalPatterns => 'നിർണായക പാറ്റേണുകൾ';

  @override
  String get hdrGroupRecommendations => 'ഗ്രൂപ്പ് ശുപാർശകൾ';

  @override
  String get sharedPractices => 'പങ്കിട്ട അഭ്യാസങ്ങൾ';

  @override
  String get hdrIndividualGuidance => 'വ്യക്തിഗത മാർഗ്ഗനിർദ്ദേശം';

  @override
  String get growthAreas => 'വളർച്ചാ മേഖലകൾ';

  @override
  String get hdrCoreTheme => 'പ്രധാന വിഷയം';

  @override
  String get growthOriented => 'വളർച്ചാ കേന്ദ്രീകൃതം';

  @override
  String get groupTheme => 'ഗ്രൂപ്പ് വിഷയം';

  @override
  String get compatibility => 'അനുയോജ്യത';

  @override
  String get unifiedScoreLabel => 'ഏകീകൃത സ്കോർ';

  @override
  String get ashtakoot => 'അഷ്ടകൂട്ട്';

  @override
  String get probability => 'സാധ്യത';

  @override
  String get hdrAshtakootSummary => 'അഷ്ടകൂട്ട് സംഗ്രഹം';

  @override
  String get hdrGunBreakdown => '8 ഗുൺ വിശദാംശം';

  @override
  String get hdrMangalDosh => 'മംഗൾ ദോഷം';

  @override
  String get hdrD9CrossChart => 'D-9 ക്രോസ്-ചാർട്ട്';

  @override
  String get d9Compatibility => 'D-9 അനുയോജ്യത';

  @override
  String get hdrDomainCompatibility => 'മേഖലാ അനുയോജ്യത';

  @override
  String get emotional => 'വൈകാരികം';

  @override
  String get intellectual => 'ബൗദ്ധികം';

  @override
  String get spiritual => 'ആധ്യാത്മികം';

  @override
  String get financial => 'സാമ്പത്തികം';

  @override
  String get domestic => 'ഗാർഹികം';

  @override
  String get communicationWord => 'ആശയവിനിമയം';

  @override
  String get sharedDharma => 'പങ്കിട്ട ധർമ്മം';

  @override
  String get familyCreation => 'കുടുംബ സൃഷ്ടി';

  @override
  String get hdrMarriageTiming => 'വിവാഹ സമയം';

  @override
  String get jointMarriageWindows => 'സംയുക്ത വിവാഹ കാലങ്ങൾ';

  @override
  String get engagementWindows => 'വിവാഹനിശ്ചയ കാലങ്ങൾ';

  @override
  String get recommendedLabel => 'ശുപാർശ ചെയ്തത്';

  @override
  String get hdrKeyRisks => 'പ്രധാന അപകടങ്ങൾ';

  @override
  String get hdrFinalVerdict => 'അന്തിമ വിധി';

  @override
  String get marriageVerdict => 'വിവാഹ വിധി';

  @override
  String get educationWord => 'വിദ്യാഭ്യാസം';

  @override
  String get learningSuffix => '& പഠനം';

  @override
  String get coreEducationScores => 'പ്രധാന വിദ്യാഭ്യാസ സ്കോറുകൾ';

  @override
  String get academicSuccess => 'അക്കാദമിക വിജയം';

  @override
  String get learningCapacity => 'പഠന ശേഷി';

  @override
  String get memory => 'സ്മൃതി';

  @override
  String get intelligence => 'ബുദ്ധി';

  @override
  String get research => 'ഗവേഷണം';

  @override
  String get hdrIntellectualProfile => 'ബൗദ്ധിക വിവരണം';

  @override
  String get learningSignature => 'പഠന മുദ്ര';

  @override
  String get hdrSubjectKaraka => 'വിഷയ കാരകൻ';

  @override
  String get hdrHouseFoundations => 'ഭാവ അടിസ്ഥാനങ്ങൾ';

  @override
  String get hdrMercuryJupiter => 'ബുധൻ & വ്യാഴം';

  @override
  String get hdrEducationYogas => 'വിദ്യാഭ്യാസ യോഗങ്ങൾ';

  @override
  String get hdrDivisionalValidation => 'വർഗ്ഗ പരിശോധന';

  @override
  String get standing => 'നില';

  @override
  String get hdrSubjectRanking => 'വിഷയ റാങ്കിംഗ്';

  @override
  String get hdrDegreeLikelihood => 'ബിരുദ സാധ്യത';

  @override
  String get hdrStudyPeriods => 'പഠന കാലങ്ങൾ';

  @override
  String get earlySchooling => 'പ്രാഥമിക വിദ്യാഭ്യാസം';

  @override
  String get higherEducation => 'ഉന്നത വിദ്യാഭ്യാസം';

  @override
  String get postgradResearch => 'ബിരുദാനന്തരം · ഗവേഷണം';

  @override
  String get hdrLearningPreferences => 'പഠന മുൻഗണനകൾ';

  @override
  String get hdrChallengesGifts => 'വെല്ലുവിളികൾ & വരങ്ങൾ';

  @override
  String get challenges => 'വെല്ലുവിളികൾ';

  @override
  String get cognitiveGifts => 'വൈജ്ഞാനിക വരങ്ങൾ';

  @override
  String get naturalAbilities => 'സ്വാഭാവിക കഴിവുകൾ';

  @override
  String get hdrSaraswatiRemedies => 'സരസ്വതി പരിഹാരങ്ങൾ';

  @override
  String get studentVerdict => 'വിദ്യാർത്ഥി വിധി';

  @override
  String get educationCareerLinkage => 'വിദ്യാഭ്യാസം → കരിയർ ബന്ധം';

  @override
  String get startupSuffix => '& സ്റ്റാർട്ടപ്പ്';

  @override
  String get coreBusinessScores => 'പ്രധാന ബിസിനസ് സ്കോറുകൾ';

  @override
  String get overallBusiness => 'മൊത്തം ബിസിനസ്';

  @override
  String get ventureSuccess => 'സംരംഭ വിജയം';

  @override
  String get eleventhHouse => '11-ാം ഭാവം';

  @override
  String get gains => 'നേട്ടങ്ങൾ';

  @override
  String get investor => 'നിക്ഷേപകൻ';

  @override
  String get hdrFounderArchetype => 'സ്ഥാപക പ്രാരൂപം';

  @override
  String get hdrTenthEleventhHouses => '10-ാം & 11-ാം ഭാവങ്ങൾ';

  @override
  String get hdrBusinessYogas => 'ബിസിനസ് യോഗങ്ങൾ';

  @override
  String get hdrRecommendedDomains => 'ശുപാർശ ചെയ്ത മേഖലകൾ';

  @override
  String get hdrBusinessStyle => 'ബിസിനസ് ശൈലി';

  @override
  String get hdrFounderSkills => 'സ്ഥാപക കഴിവുകൾ';

  @override
  String get hdrFundingProfile => 'ധനസഹായ വിവരണം';

  @override
  String get recommendedPath => 'ശുപാർശ ചെയ്ത പഥം';

  @override
  String get investorAttract => 'നിക്ഷേപക ആകർഷണം';

  @override
  String get familyBacking => 'കുടുംബ പിന്തുണ';

  @override
  String get hybridViability => 'ഹൈബ്രിഡ് സാധ്യത';

  @override
  String get launchWindow => 'ലോഞ്ച് കാലം';

  @override
  String get scaleWindow => 'വികസന കാലം';

  @override
  String get hdrBusinessRisks => 'ബിസിനസ് അപകടങ്ങൾ';

  @override
  String get recoveryCapacity => 'വീണ്ടെടുപ്പ് ശേഷി';

  @override
  String get hdrRemediesSolutions => 'പരിഹാരങ്ങൾ & പരിഹാരമാർഗ്ഗങ്ങൾ';

  @override
  String get aiConnectionLost => 'കണക്ഷൻ നഷ്ടപ്പെട്ടു. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get aiSomethingWrong => 'എന്തോ കുഴപ്പം സംഭവിച്ചു';

  @override
  String get aiNoResponse => 'പ്രതികരണമില്ല';

  @override
  String get aiConnectionError => 'കണക്ഷൻ പിശക്. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get aiAutoDetect => 'സ്വയം കണ്ടെത്തുക';

  @override
  String aiAutoArrow(String lang) {
    return 'സ്വയം → ${lang}';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'ഭാഷ: ${lang}';
  }

  @override
  String get aiNoBirthCharts => 'ജന്മ ചാർട്ടുകളൊന്നും കണ്ടെത്തിയില്ല';

  @override
  String get aiCreateChartFirst => 'AI-യുമായി ചാറ്റ് ചെയ്യാൻ ആദ്യം ഒരു ജന്മ ചാർട്ട് സൃഷ്ടിക്കുക';

  @override
  String get aiSelectChartBegin => 'വിശകലനം ആരംഭിക്കാൻ ഒരു ജന്മ ചാർട്ട് തിരഞ്ഞെടുക്കുക';

  @override
  String aiAnalyzingName(String name) {
    return 'വിശകലനം ചെയ്യുന്നു: ${name}';
  }

  @override
  String get aiChange => 'മാറ്റുക';

  @override
  String get aiAnalyzingChart => 'നിങ്ങളുടെ ചാർട്ട് വിശകലനം ചെയ്യുന്നു...';

  @override
  String get aiAskStarsHint => 'നക്ഷത്രങ്ങളോട് എന്തും ചോദിക്കൂ...';

  @override
  String get aiSuggestedFollowups => 'നിർദ്ദേശിച്ച തുടർചോദ്യങ്ങൾ';

  @override
  String get aiThinking => 'ചിന്തിക്കുന്നു...';

  @override
  String get aiThanks => 'നന്ദി!';

  @override
  String get aiFeedbackNoted => 'അഭിപ്രായം രേഖപ്പെടുത്തി';

  @override
  String get svcAll => 'എല്ലാം';

  @override
  String get svcNoServices => 'സേവനങ്ങളൊന്നും ലഭ്യമല്ല';

  @override
  String get svcFree => 'സൗജന്യം';

  @override
  String get astroFailedStartCall => 'കോൾ ആരംഭിക്കാൻ പരാജയപ്പെട്ടു';

  @override
  String get astroFailedStartChat => 'ചാറ്റ് ആരംഭിക്കാൻ പരാജയപ്പെട്ടു';

  @override
  String astroErrorDetail(String error) {
    return 'പിശക്: ${error}';
  }

  @override
  String get astroExperience => 'പരിചയം';

  @override
  String get astroSessions => 'സെഷനുകൾ';

  @override
  String get astroMinutes => 'മിനിറ്റുകൾ';

  @override
  String get astroAbout => 'വിവരണം';

  @override
  String get astroLanguages => 'ഭാഷകൾ';

  @override
  String get astroRateCard => 'നിരക്ക് കാർഡ്';

  @override
  String get astroVoice => 'വോയ്സ്';

  @override
  String astroReviews(int count) {
    return 'അവലോകനങ്ങൾ (${count})';
  }

  @override
  String get astroNoReviews => 'അവലോകനങ്ങളൊന്നുമില്ല';

  @override
  String get astroAnonymous => 'അജ്ഞാതൻ';

  @override
  String get forgotPasswordSubtitle => 'നിങ്ങളുടെ ഇമെയിൽ നൽകുക, പാസ്‌വേഡ് പുനഃസജ്ജമാക്കാൻ\nഒരു ലിങ്ക് ഞങ്ങൾ അയയ്ക്കാം.';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => 'ലിങ്ക് വീണ്ടും അയയ്ക്കുക';

  @override
  String get appName => 'നക്ഷത്രലോജി';

  @override
  String get cosmicJourneyAwaits => 'നിങ്ങളുടെ പ്രാപഞ്ചിക യാത്ര കാത്തിരിക്കുന്നു';

  @override
  String get home => 'ഹോം';

  @override
  String get astrologers => 'ജ്യോതിഷികള്‍';

  @override
  String get services => 'സേവനങ്ങള്‍';

  @override
  String get wallet => 'വാലറ്റ്';

  @override
  String get profile => 'പ്രൊഫൈല്‍';

  @override
  String get live => 'ലൈവ്';

  @override
  String get kundli => 'കുണ്ഡലി';

  @override
  String get chat => 'ചാറ്റ്';

  @override
  String get call => 'കോള്‍';

  @override
  String get video => 'വീഡിയോ';

  @override
  String get signIn => 'സൈന്‍ ഇന്‍';

  @override
  String get createAccount => 'അക്കൗണ്ട് സൃഷ്ടിക്കുക';

  @override
  String get email => 'ഇമെയില്‍';

  @override
  String get password => 'പാസ്‌വേഡ്';

  @override
  String get confirmPassword => 'പാസ്‌വേഡ് സ്ഥിരീകരിക്കുക';

  @override
  String get fullName => 'മുഴുവന്‍ പേര്';

  @override
  String get phone => 'ഫോണ്‍ (ഐച്ഛികം)';

  @override
  String get forgotPassword => 'പാസ്‌വേഡ് മറന്നോ?';

  @override
  String get sendResetLink => 'റീസെറ്റ് ലിങ്ക് അയയ്ക്കുക';

  @override
  String get backToSignIn => 'സൈന്‍ ഇന്നിലേക്ക് മടങ്ങുക';

  @override
  String get dontHaveAccount => 'അക്കൗണ്ട് ഇല്ലേ?';

  @override
  String get alreadyHaveAccount => 'ഇതിനകം അക്കൗണ്ട് ഉണ്ടോ?';

  @override
  String get continueGoogle => 'Google ഉപയോഗിച്ച് തുടരുക';

  @override
  String get required => 'ആവശ്യമാണ്';

  @override
  String get minSixChars => 'കുറഞ്ഞത് ൬ അക്ഷരങ്ങള്‍';

  @override
  String get passwordsMismatch => 'പാസ്‌വേഡുകള്‍ പൊരുത്തപ്പെടുന്നില്ല';

  @override
  String get validEmailRequired => 'സാധുവായ ഇമെയില്‍ ആവശ്യമാണ്';

  @override
  String get loginFailed => 'ലോഗിന്‍ പരാജയപ്പെട്ടു';

  @override
  String get signupFailed => 'സൈനപ്പ് പരാജയപ്പെട്ടു';

  @override
  String get welcomeBack => 'തിരികെ സ്വാഗതം';

  @override
  String get todaysHoroscope => 'ഇന്നത്തെ രാശിഫലം';

  @override
  String get todaysRashi => 'ഇന്നത്തെ രാശി';

  @override
  String get tapDetails => 'വിശദാംശങ്ങള്‍ക്ക് ടാപ്പ് ചെയ്യുക';

  @override
  String get allServices => 'എല്ലാ സേവനങ്ങളും';

  @override
  String get seeAll => 'എല്ലാം കാണുക';

  @override
  String get topAstrologers => 'മുന്‍നിര ജ്യോതിഷികള്‍';

  @override
  String get onlineExperts => 'കൺസൾട്ടേഷനായി ഓൺലൈൻ വിദഗ്ധർ';

  @override
  String get searchAstrologers => 'ജ്യോതിഷികളെ തിരയുക...';

  @override
  String get noAstrologersFound => 'ജ്യോതിഷികളെ കണ്ടെത്തിയില്ല';

  @override
  String get online => 'ഓൺലൈൻ';

  @override
  String get offline => 'ഓഫ്‌ലൈൻ';

  @override
  String get busy => 'തിരക്കില്‍';

  @override
  String get perMin => '/മിനിറ്റ്';

  @override
  String get noCharts => 'ഇതുവരെ ജനന കുണ്ഡലി ഇല്ല';

  @override
  String get createFirst => 'നിങ്ങളുടെ ആദ്യ ജനന കുണ്ഡലി സൃഷ്ടിക്കുക';

  @override
  String get createChart => 'കുണ്ഡലി സൃഷ്ടിക്കുക';

  @override
  String get newBirthChart => 'പുതിയ ജനന കുണ്ഡലി';

  @override
  String get clientName => 'പേര്';

  @override
  String get gender => 'ലിംഗം';

  @override
  String get male => 'പുരുഷന്‍';

  @override
  String get female => 'സ്ത്രീ';

  @override
  String get other => 'മറ്റുള്ളവ';

  @override
  String get dateOfBirth => 'ജനന തീയതി';

  @override
  String get timeOfBirth => 'ജനന സമയം';

  @override
  String get birthPlace => 'ജനന സ്ഥലം';

  @override
  String get birthPlaceHint => 'നഗരത്തിന്റെ പേര് ടൈപ്പ് ചെയ്യുക...';

  @override
  String get generateKundli => 'കുണ്ഡലി തയ്യാറാക്കുക';

  @override
  String get birthChartCreated => 'ജനന കുണ്ഡലി സൃഷ്ടിച്ചു!';

  @override
  String get deleteChart => 'കുണ്ഡലി ഇല്ലാതാക്കണോ?';

  @override
  String get cannotUndo => 'ഇത് പഴയപടിയാക്കാനാവില്ല.';

  @override
  String get primary => 'പ്രാഥമികം';

  @override
  String get viewKundli => 'കുണ്ഡലി കാണുക';

  @override
  String get completeBirthChart => 'പൂർണ്ണ ജനന കുണ്ഡലി';

  @override
  String get birthDetails => 'ജനന വിശദാംശങ്ങള്‍';

  @override
  String get name => 'പേര്';

  @override
  String get dob => 'ജനന തീയതി';

  @override
  String get tob => 'ജനന സമയം';

  @override
  String get place => 'സ്ഥലം';

  @override
  String get summary => 'സംഗ്രഹം';

  @override
  String get planets => 'ഗ്രഹങ്ങള്‍';

  @override
  String get divisions => 'വിഭാഗങ്ങള്‍';

  @override
  String get vimshottari => 'വിംശോത്തരി';

  @override
  String get moola => 'മൂല';

  @override
  String get gochar => 'ഗോചരം';

  @override
  String get dosh => 'ദോഷം';

  @override
  String get yoga => 'യോഗം';

  @override
  String get shadbala => 'ഷഡ്ബലം';

  @override
  String get ashtakavarga => 'അഷ്ടകവർഗ്ഗം';

  @override
  String get aspects => 'ദൃഷ്ടി';

  @override
  String get lifeAreas => 'ജീവിത മേഖലകള്‍';

  @override
  String get bhava => 'ഭാവം';

  @override
  String get chakras => 'ചക്രങ്ങള്‍';

  @override
  String get dashaActive => 'ദശ സജീവം';

  @override
  String get lagna => 'ലഗ്നം';

  @override
  String get moon => 'ചന്ദ്രന്‍';

  @override
  String get sun => 'സൂര്യന്‍';

  @override
  String get premiumSection => 'പ്രീമിയം വിഭാഗം';

  @override
  String get unlockReading => 'വിശദമായ വിശകലനം കാണാന്‍ അൺലോക്ക് ചെയ്യുക.';

  @override
  String get unlock => 'അൺലോക്ക്';

  @override
  String get retrograde => 'വക്രം';

  @override
  String get combust => 'അസ്തം';

  @override
  String get vargottama => 'വർഗ്ഗോത്തമം';

  @override
  String get exalted => 'ഉച്ചം';

  @override
  String get debilitated => 'നീചം';

  @override
  String get addBalance => 'ബാലന്‍സ് ചേര്‍ക്കുക';

  @override
  String get amount => 'തുക';

  @override
  String get walletBalance => 'വാലറ്റ് ബാലന്‍സ്';

  @override
  String get recharge => 'റീചാര്‍ജ്';

  @override
  String get bonus => 'ബോണസ്';

  @override
  String get serviceLabel => 'സേവനം';

  @override
  String get refund => 'റീഫണ്ട്';

  @override
  String get noTransactions => 'ഇടപാടുകളില്ല';

  @override
  String get editProfile => 'പ്രൊഫൈല്‍ തിരുത്തുക';

  @override
  String get savedAstrologers => 'സേവ് ചെയ്ത ജ്യോതിഷികള്‍';

  @override
  String get noSavedAstrologers => 'ഇതുവരെ സേവ് ചെയ്ത ജ്യോതിഷികളില്ല';

  @override
  String get myOrders => 'എന്റെ ഓര്‍ഡറുകള്‍';

  @override
  String get communicationHistory => 'ആശയവിനിമയ ചരിത്രം';

  @override
  String get chatHistory => 'ചാറ്റ് ചരിത്രം';

  @override
  String get callHistory => 'കോള്‍ ചരിത്രം';

  @override
  String get logout => 'ലോഗൗട്ട്';

  @override
  String get chatMessages => 'ചാറ്റ് സന്ദേശങ്ങള്‍';

  @override
  String get typeMessage => 'സന്ദേശം ടൈപ്പ് ചെയ്യുക...';

  @override
  String get sessionEnded => 'സെഷന്‍ അവസാനിച്ചു';

  @override
  String get endChat => 'ചാറ്റ് അവസാനിപ്പിക്കണോ?';

  @override
  String get endChatConfirm => 'ഈ ചാറ്റ് സെഷന്‍ തീര്‍ച്ചയായും അവസാനിപ്പിക്കണമെന്ന് ഉറപ്പാണോ?';

  @override
  String get sendPhoto => 'ഫോട്ടോ അയയ്ക്കുക';

  @override
  String get sendPDF => 'PDF അയയ്ക്കുക';

  @override
  String get upload => 'അപ്‌ലോഡ്';

  @override
  String get fileNotFound => 'ഫയല്‍ കണ്ടെത്തിയില്ല';

  @override
  String get voiceCall => 'വോയ്‌സ് കോള്‍';

  @override
  String get videoCall => 'വീഡിയോ കോള്‍';

  @override
  String get ringing => 'റിംഗ് ചെയ്യുന്നു...';

  @override
  String get connected => 'കണക്റ്റ് ചെയ്തു';

  @override
  String get endCall => 'കോള്‍ അവസാനിപ്പിക്കുക';

  @override
  String get mute => 'മ്യൂട്ട്';

  @override
  String get unmute => 'അൺമ്യൂട്ട്';

  @override
  String get speaker => 'സ്പീക്കര്‍';

  @override
  String get camera => 'ക്യാമറ';

  @override
  String get flip => 'ഫ്ലിപ്പ്';

  @override
  String get liveStreams => 'ലൈവ് സ്ട്രീമുകള്‍';

  @override
  String get noLiveStreams => 'ഇപ്പോള്‍ ലൈവ് സ്ട്രീമുകളില്ല';

  @override
  String get astrologerUnavailable => 'ജ്യോതിഷി ലഭ്യമല്ല. സ്ട്രീം അവസാനിക്കുന്നു.';

  @override
  String get streamEnded => 'സ്ട്രീം അവസാനിച്ചു';

  @override
  String get superChat => 'സൂപ്പര്‍ ചാറ്റ്';

  @override
  String get sendGift => 'സമ്മാനം അയയ്ക്കുക';

  @override
  String get goBack => 'തിരികെ പോകുക';

  @override
  String get appPermissions => 'ആപ്പ് അനുമതികള്‍';

  @override
  String get grantPermissions => 'അനുമതികള്‍ നല്‍കുക';

  @override
  String get skipForNow => 'ഇപ്പോള്‍ ഒഴിവാക്കുക';

  @override
  String get microphone => 'മൈക്രോഫോണ്‍';

  @override
  String get notifications => 'അറിയിപ്പുകള്‍';

  @override
  String get storage => 'സ്റ്റോറേജ്';

  @override
  String get ok => 'ശരി';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get save => 'സേവ് ചെയ്യുക';

  @override
  String get edit => 'തിരുത്തുക';

  @override
  String get delete => 'ഇല്ലാതാക്കുക';

  @override
  String get retry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get send => 'അയയ്ക്കുക';

  @override
  String get refresh => 'റിഫ്രഷ്';

  @override
  String get loading => 'ലോഡ് ചെയ്യുന്നു...';

  @override
  String get noData => 'ഡാറ്റ ലഭ്യമല്ല';

  @override
  String get error => 'പിശക്';

  @override
  String get success => 'വിജയം';

  @override
  String get selectLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get language => 'ഭാഷ';

  @override
  String get english => 'ഇംഗ്ലീഷ്';

  @override
  String get myDetails => 'എന്റെ വിശദാംശങ്ങൾ';

  @override
  String get myKundlis => 'എന്റെ കുണ്ഡലികൾ';

  @override
  String get walletRecharge => 'വാലറ്റ് & റീചാർജ്';

  @override
  String get consultationHistory => 'കൺസൾട്ടേഷൻ ചരിത്രം';

  @override
  String get helpSupport => 'സഹായം & പിന്തുണ';

  @override
  String get biometricLogin => 'ബയോമെട്രിക് ലോഗിൻ';

  @override
  String get pastVoiceConsultations => 'മുൻ വോയ്‌സ് കൺസൾട്ടേഷനുകൾ';

  @override
  String get pastTextConversations => 'മുൻ ടെക്‌സ്‌റ്റ് സംഭാഷണങ്ങൾ';

  @override
  String get comingSoon => 'ഉടൻ വരുന്നു';

  @override
  String get totalCredit => 'ആകെ ക്രെഡിറ്റ്';

  @override
  String get totalDebit => 'ആകെ ഡെബിറ്റ്';

  @override
  String get statement => 'സ്റ്റേറ്റ്‌മെന്റ്';

  @override
  String get allTypes => 'എല്ലാ തരങ്ങളും';

  @override
  String get prev => 'മുമ്പത്തെ';

  @override
  String get next => 'അടുത്തത്';

  @override
  String get allInsights => 'എല്ലാ വിശകലനങ്ങളും';

  @override
  String get yourCompleteReading => 'നിങ്ങളുടെ പൂർണ്ണ വായന';

  @override
  String get expertEngines => 'വിദഗ്ദ്ധ എഞ്ചിനുകൾ';

  @override
  String get eachInsightConsultation => 'ഓരോ വിശകലനവും ഒരു പൂർണ്ണ കൺസൾട്ടേഷൻ';

  @override
  String get engines => 'എഞ്ചിനുകൾ';

  @override
  String get dataPoints => 'ഡാറ്റ പോയിന്റുകൾ';

  @override
  String get singleChart => 'സിംഗിൾ';

  @override
  String get careerPurpose => 'കരിയർ & ലക്ഷ്യം';

  @override
  String get wealthAssets => 'സമ്പത്ത് & ആസ്തികൾ';

  @override
  String get loveRelationships => 'പ്രണയം & ബന്ധങ്ങൾ';

  @override
  String get healthWellness => 'ആരോഗ്യം & ക്ഷേമം';

  @override
  String get soulKarma => 'ആത്മാവ് & കർമ്മം';

  @override
  String get specialistReports => 'വിദഗ്ദ്ധ റിപ്പോർട്ടുകൾ';

  @override
  String get searchByNameSpeciality => 'പേര്, വിശേഷത ഉപയോഗിച്ച് തിരയുക...';

  @override
  String get sortedByRating => 'റേറ്റിംഗ് അനുസരിച്ച്';

  @override
  String get initiatingChat => 'ചാറ്റ് ആരംഭിക്കുന്നു...';

  @override
  String get startingCall => 'കോൾ ആരംഭിക്കുന്നു...';

  @override
  String get yrs => 'വർഷങ്ങൾ';

  @override
  String get chatWithAISpecialist => 'AI വിദഗ്ദ്ധനുമായി ചാറ്റ് ചെയ്യുക';

  @override
  String get tapToStart => 'ആരംഭിക്കാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get astrologer => 'ജ്യോത്സ്യൻ';

  @override
  String get reports => 'റിപ്പോർട്ടുകൾ';

  @override
  String get milan => 'മിലൻ';

  @override
  String get forecast => 'പ്രവചനം';

  @override
  String get rashi => 'രാശി';

  @override
  String get jupiterFavorsBold => 'വ്യാഴം ധീരമായ നടപടികൾക്ക് അനുകൂലം';

  @override
  String get careerIlluminated => 'നിങ്ങളുടെ കരിയർ മേഖല പ്രകാശിതമാണ് — നിങ്ങളുടെ സഹജവാസനയെ വിശ്വസിക്കുക.';

  @override
  String get todaysForecast => 'ഇന്നത്തെ പ്രവചനം';

  @override
  String get engCareer => 'കരിയർ & ജോലി';

  @override
  String get engBusiness => 'ബിസിനസ് & സ്റ്റാർട്ടപ്പ്';

  @override
  String get engEducation => 'വിദ്യാഭ്യാസം & പഠനം';

  @override
  String get engLifePath => 'ജീവിത പാത & ഭാഗ്യം';

  @override
  String get engWealth => 'സമ്പത്ത് & ധനകാര്യം';

  @override
  String get engDebt => 'കടം & വീണ്ടെടുക്കൽ';

  @override
  String get engProperty => 'സ്വത്ത് & ആസ്തി';

  @override
  String get engLegal => 'നിയമ & തർക്കം';

  @override
  String get engLove => 'പ്രണയം & റൊമാൻസ്';

  @override
  String get engMarriage => 'വിവാഹം & കുടുംബം';

  @override
  String get engKundliMilan => 'കുണ്ഡലി മിലൻ';

  @override
  String get engRelationship => 'ബന്ധ വിശകലനം';

  @override
  String get engLoveCompat => 'പ്രണയ അനുയോജ്യത';

  @override
  String get engChildProb => 'സന്താന സാധ്യത';

  @override
  String get engHealth => 'ആരോഗ്യം & ക്ഷേമം';

  @override
  String get engMental => 'മാനസിക & സമ്മർദ്ദം';

  @override
  String get engCharacter => 'സ്വഭാവ വിശകലനം';

  @override
  String get engPastLife => 'പൂർവജന്മം & കർമ്മം';

  @override
  String get engKarmaLink => 'കർമ്മ ബന്ധം';

  @override
  String get noChatSessions => 'ഇതുവരെ ചാറ്റ് സെഷനുകളില്ല';

  @override
  String get chatAppearHere => 'ജ്യോത്സ്യന്മാരുമായുള്ള നിങ്ങളുടെ സംഭാഷണങ്ങൾ ഇവിടെ കാണാം.';

  @override
  String get noCallsYet => 'ഇതുവരെ കോളുകളില്ല';

  @override
  String get callAppearHere => 'ജ്യോത്സ്യന്മാരുമായുള്ള നിങ്ങളുടെ കോൾ ചരിത്രം ഇവിടെ കാണാം.';

  @override
  String get chatWith => 'ഉമായി ചാറ്റ്';

  @override
  String get msgs => 'സന്ദേശങ്ങൾ';

  @override
  String get voiceCallLabel => 'വോയ്‌സ് കോൾ';

  @override
  String get videoCallLabel => 'വീഡിയോ കോൾ';

  @override
  String get pullToRefresh => 'പുതുക്കാൻ താഴേക്ക് വലിക്കുക';

  @override
  String get sessionExpired => 'സെഷൻ കാലഹരണപ്പെട്ടു';

  @override
  String get connectionFailed => 'കണക്ഷൻ പരാജയം';

  @override
  String get callActive => 'കോൾ ആക്ടീവ്';

  @override
  String get lessThanOneMin => '1 മിനിറ്റിൽ കുറവ് ബാക്കി';

  @override
  String get noMessages => 'ഈ സെഷനിൽ സന്ദേശങ്ങളില്ല';

  @override
  String get gocharForAllSigns => 'എല്ലാ 12 രാശികൾക്കും ഇന്നത്തെ ഗോചരം';

  @override
  String get selectChart => 'വിശകലനത്തിനായി ജാതകം തിരഞ്ഞെടുക്കുക';

  @override
  String get selectTwoCharts => 'രണ്ട് ജാതകങ്ങൾ തിരഞ്ഞെടുക്കുക';

  @override
  String get analyzing => 'വിശകലനം നടക്കുന്നു...';

  @override
  String get browseAstrologers => 'ജ്യോത്സ്യന്മാരെ കണ്ടെത്തുക';

  @override
  String get probableNumber => 'സാധ്യമായ എണ്ണം';

  @override
  String get genderTendency => 'ലിംഗ പ്രവണത';

  @override
  String get son => 'പുത്രൻ';

  @override
  String get daughter => 'പുത്രി';

  @override
  String get occupants => 'നിവാസി ഗ്രഹങ്ങൾ';

  @override
  String get beneficAspects => 'ശുഭ ദൃഷ്ടി';

  @override
  String get maleficAspects => 'പാപ ദൃഷ്ടി';

  @override
  String get nextFavorableWindow => 'അടുത്ത അനുകൂല സമയം';

  @override
  String get totalDoshaPenalty => 'ആകെ ദോഷ ദണ്ഡം';

  @override
  String get cancellationFactors => 'റദ്ദാക്കൽ ഘടകങ്ങൾ';

  @override
  String get combinedFertility => 'സംയുക്ത ഫലഭൂയിഷ്ഠത സൂചന';

  @override
  String get planetPositions => 'ഗ്രഹ സ്ഥാനങ്ങൾ';

  @override
  String get bestWindows => 'മികച്ച സമയം';

  @override
  String get worstWindows => 'പ്രതികൂല സമയം';

  @override
  String get scoreComponents => 'സ്കോർ ഘടകങ്ങൾ';

  @override
  String get topOpportunities => 'പ്രധാന അവസരങ്ങൾ';

  @override
  String get topRisks => 'പ്രധാന അപകടങ്ങൾ';

  @override
  String get remedies => 'പരിഹാരങ്ങൾ';

  @override
  String get keyInsights => 'പ്രധാന ഉൾക്കാഴ്ചകൾ';

  @override
  String get overallVerdict => 'മൊത്തം വിധി';

  @override
  String get venusContacts => 'ശുക്ര സമ്പർക്കങ്ങൾ';

  @override
  String get contact => 'സമ്പർക്കം';

  @override
  String get effect => 'ഫലം';

  @override
  String get moonSignCompat => 'ചന്ദ്ര രാശി അനുയോജ്യത';

  @override
  String get hisMoon => 'അദ്ദേഹത്തിന്റെ ചന്ദ്രൻ';

  @override
  String get herMoon => 'അവളുടെ ചന്ദ്രൻ';

  @override
  String get nakshatraCompat => 'നക്ഷത്ര അനുയോജ്യത';

  @override
  String get ketuContacts => 'കേതു സമ്പർക്കങ്ങൾ';

  @override
  String get rahuContacts => 'രാഹു സമ്പർക്കങ്ങൾ';

  @override
  String get pastLifeIndication => 'പൂർവജന്മ സൂചന';

  @override
  String get totalChallengePenalty => 'ആകെ വെല്ലുവിളി ദണ്ഡം';

  @override
  String get manifestation => 'പ്രകടനം';

  @override
  String get cancellation => 'റദ്ദാക്കൽ';

  @override
  String get navigation => 'മാർഗനിർദേശം';

  @override
  String get potentialStrengths => 'സാധ്യമായ ശക്തികൾ';

  @override
  String get areasToNurture => 'പരിപോഷിക്കേണ്ട മേഖലകൾ';

  @override
  String get relationshipGuidance => 'ബന്ധ മാർഗനിർദേശം';

  @override
  String get detailedSummary => 'വിശദമായ സംഗ്രഹം';

  @override
  String get discussWithAI => 'AI യുമായി ചർച്ച ചെയ്യുക';

  @override
  String get planet => 'ഗ്രഹം';

  @override
  String get sign => 'രാശി';

  @override
  String get house => 'ഭാവം';

  @override
  String get strength => 'ബലം';

  @override
  String get copy => 'പകർപ്പ്';

  @override
  String get confidence => 'ആത്മവിശ്വാസം';

  @override
  String get d7Saptamsa => 'D7 സപ്താംശം';

  @override
  String get numberExplanation => 'സംഖ്യ വിശദീകരണം';

  @override
  String get genderExplanation => 'ലിംഗ വിശദീകരണം';

  @override
  String get inFifth => '5-ാം ല്‍?';

  @override
  String get primaryArchetype => 'പ്രാഥമിക മൂലരൂപം';

  @override
  String get mitigation => 'ലഘൂകരണം';

  @override
  String get soulCareerAlign => 'ആത്മാവ് ↔ കരിയർ സമന്വയം';

  @override
  String get favorablePeriods => 'അനുകൂല കാലം';

  @override
  String get challengingPeriods => 'വെല്ലുവിളി കാലം';

  @override
  String get keyHouses => 'പ്രധാന ഭാവങ്ങൾ';

  @override
  String get keyPlanets => 'പ്രധാന ഗ്രഹങ്ങൾ';

  @override
  String get characterOverview => 'സ്വഭാവ അവലോകനം';

  @override
  String get noYogasActive => 'ഈ ജാതകത്തിൽ നിലവിൽ യോഗങ്ങളില്ല.';

  @override
  String get basedOnPlanetStrengths => 'ഗ്രഹ ബലങ്ങളുടെയും ഭാവ സ്ഥാനങ്ങളുടെയും അടിസ്ഥാനത്തിൽ';

  @override
  String get basedOnTransits => 'നിലവിലെ ഗ്രഹ ഗോചരത്തെ അടിസ്ഥാനമാക്കി';

  @override
  String get currentPlanetPositions => 'നിങ്ങളുടെ രാശിയെ 1-ാം ഭാവമായി കണക്കാക്കി നിലവിലെ ഗ്രഹ സ്ഥാനങ്ങൾ';

  @override
  String get favorablePeriodAdvice => 'അനുകൂല കാലം — കരിയർ വളർച്ചയിലും ബന്ധങ്ങളിലും ശ്രദ്ധ കേന്ദ്രീകരിക്കുക.';

  @override
  String get noClassicalYogas => 'ശാസ്ത്രീയ വിദ്യാ യോഗങ്ങളില്ലാതെ, വിജയം സ്ഥിരമായ പരിശ്രമത്തിലൂടെ വരുന്നു.';

  @override
  String get walletDeduction => 'തുക നിങ്ങളുടെ വാലറ്റിൽ നിന്ന് കുറയ്ക്കും';

  @override
  String get bhakootAxis => 'ഭകൂട് അക്ഷം';

  @override
  String get basis => 'അടിസ്ഥാനം';

  @override
  String get selectChartsForMilan => 'മിലനായി 2 ജാതകങ്ങൾ തിരഞ്ഞെടുക്കുക';

  @override
  String get selectMultiCharts => '2-5 ജാതകങ്ങൾ തിരഞ്ഞെടുക്കുക';

  @override
  String get running => 'പ്രവർത്തിക്കുന്നു';

  @override
  String get past => 'കഴിഞ്ഞ';

  @override
  String get topActiveDoshas => 'ടോപ്പ് ആക്ടീവ് ദോഷങ്ങൾ';

  @override
  String get allDoshas => 'എല്ലാ ദോഷങ്ങളും';

  @override
  String get activeYogas => 'ആക്ടീവ് യോഗങ്ങൾ';

  @override
  String get activeDoshas => 'ആക്ടീവ് ദോഷങ്ങൾ';

  @override
  String get yogaAnalysis => 'യോഗ വിശകലനം';

  @override
  String get factors => 'ഘടകങ്ങൾ';

  @override
  String get dominantPlanet => 'പ്രധാന ഗ്രഹം';

  @override
  String get startSession => 'സെഷൻ ആരംഭിക്കുക';

  @override
  String get notesSaved => 'കുറിപ്പുകൾ സംരക്ഷിച്ചു';

  @override
  String get unlocked => 'അൺലോക്ക്! നിങ്ങളുടെ വായന ആസ്വദിക്കൂ.';

  @override
  String get todaysGochar => 'ഇന്നത്തെ ഗോചരം';

  @override
  String get todaysTransitChart => 'ഇന്നത്തെ ഗോചര ചാർട്ട്';

  @override
  String get lifeAreaPredictions => 'ജീവിത മേഖല പ്രവചനങ്ങൾ';

  @override
  String get strengths => 'ശക്തികൾ';

  @override
  String get weaknesses => 'ദൗർബല്യങ്ങൾ';

  @override
  String get ruledBy => 'അധിപൻ';

  @override
  String get kundliMilan => 'കുണ്ഡലി മിലൻ';

  @override
  String get startKundliMilan => 'കുണ്ഡലി മിലൻ ആരംഭിക്കുക';

  @override
  String get recommendations => 'ശുപാർശകൾ';

  @override
  String get cancellations => 'റദ്ദാക്കലുകൾ';

  @override
  String get dashaSync => 'ദശാ സിങ്ക്';

  @override
  String get transitMarriageWindows => 'ഗോചര വിവാഹ സമയം';

  @override
  String get overlappingWindows => 'ഓവർലാപ്പിംഗ് വിവാഹ സമയം';

  @override
  String get overallStrength => 'മൊത്തം ബലം';

  @override
  String get stability => 'സ്ഥിരത';

  @override
  String get growth => 'വളര്‍ച്ച';

  @override
  String get clarity => 'വ്യക്തത';

  @override
  String get recognition => 'അംഗീകാരം';

  @override
  String get satisfaction => 'സംതൃപ്തി';

  @override
  String get verdict => 'വിധി';

  @override
  String get topRoles => 'പ്രധാന പങ്കുകള്‍';

  @override
  String get areasForGrowth => 'വളര്‍ച്ചാ മേഖലകള്‍';

  @override
  String get bestIndustries => 'മികച്ച വ്യവസായങ്ങള്‍';

  @override
  String get employment => 'ജോലി';

  @override
  String get entrepreneurship => 'സംരംഭകത്വം';

  @override
  String get freelance => 'ഫ്രീലാന്‍സ്';

  @override
  String get portfolio => 'പോര്‍ട്ട്‌ഫോളിയോ';

  @override
  String get burnoutRisk => 'അമിത ക്ഷീണ അപകടം';

  @override
  String get careerStagnation => 'തൊഴില്‍ മുരടിപ്പ്';

  @override
  String get workplaceConflict => 'ജോലിസ്ഥല സംഘര്‍ഷം';

  @override
  String get positioning => 'സ്ഥാന നിര്‍ണയം';

  @override
  String get skillDevelopment => 'നൈപുണ്യ വികസനം';

  @override
  String get network => 'നെറ്റ്‌വര്‍ക്ക്';

  @override
  String get visibility => 'ദൃശ്യപരത';

  @override
  String get lagnaLord => 'ലഗ്ന അധിപന്‍';

  @override
  String get tenthLord => 'പത്താം അധിപന്‍';

  @override
  String get lord => 'അധിപന്‍';

  @override
  String get lordPlacedIn => 'അധിപന്‍ സ്ഥിതം';

  @override
  String get lordDignity => 'അധിപ ബലം';

  @override
  String get d9Dignity => 'ഡി9 ബലം';

  @override
  String get careerAnalysis => 'കരിയർ വിശകലനം';

  @override
  String get launchWindows => 'ആരംഭ സമയം';

  @override
  String get peakWindows => 'ഉച്ച സമയം';

  @override
  String get promotionWindows => 'സ്ഥാനക്കയറ്റ സമയം';

  @override
  String get riskWindows => 'അപകട സമയം';

  @override
  String get timingWindows => 'സമയ ജാലകം';

  @override
  String get careerRisks => 'തൊഴില്‍ അപകടങ്ങള്‍';

  @override
  String get astrologicalRemedies => 'ജ്യോതിഷ പരിഹാരങ്ങള്‍';

  @override
  String get practicalSolutions => 'പ്രായോഗിക പരിഹാരങ്ങള്‍';

  @override
  String get analysisConfidence => 'വിശകലന വിശ്വാസ്യത';

  @override
  String get careerArchetype => 'തൊഴില്‍ മാതൃക';

  @override
  String get workStructure => 'ജോലി ഘടന';

  @override
  String get teamLeadership => 'ടീം നേതൃത്വം';

  @override
  String get idealEnvironment => 'അനുയോജ്യ അന്തരീക്ഷം';

  @override
  String get idealOrgSize => 'അനുയോജ്യ സ്ഥാപന വലിപ്പം';

  @override
  String get fitScore => 'ഫിറ്റ് സ്കോര്‍';

  @override
  String get recommended => 'ശുപാർശ ചെയ്തത്';

  @override
  String get divisionalValidation => 'വിഭാഗ സാധൂകരണം';

  @override
  String get houseAnalysis => 'ഭാവ വിശകലനം';

  @override
  String get jaiminiKarakas => 'ജൈമിനി കാരകങ്ങള്‍';

  @override
  String get copyFullReport => 'മുഴുവന്‍ റിപ്പോര്‍ട്ട് പകര്‍ത്തുക';

  @override
  String get reportCopied => 'റിപ്പോര്‍ട്ട് പകര്‍ത്തി!';
}
