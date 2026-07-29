// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

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
  String get sbLegendary => 'അസാധാരണം';

  @override
  String get sbSthana => 'സ്ഥാന ബലം';

  @override
  String get sbDig => 'ദിക് ബലം';

  @override
  String get sbKala => 'കാല ബലം';

  @override
  String get sbChesta => 'ചേഷ്ടാ ബലം';

  @override
  String get sbNaisargika => 'നൈസർഗിക ബലം';

  @override
  String get sbDrik => 'ദൃക് ബലം';

  @override
  String get sbSummary => 'ഗ്രഹ ബല സംഗ്രഹം';

  @override
  String get sbAverageStrength => 'ശരാശരി ബലം';

  @override
  String get sbHighestRupa => 'ഏറ്റവും ഉയർന്ന രൂപം';

  @override
  String get sbRupa => 'രൂപം';

  @override
  String get sbRanking => 'ഗ്രഹ റാങ്കിംഗ്';

  @override
  String get sbRequired => 'ആവശ്യമായ';

  @override
  String get sbExcess => 'അധികം';

  @override
  String get sbDeficit => 'കുറവ്';

  @override
  String get sbTotalShadbala => 'മൊത്തം ഷഡ്ബലം';

  @override
  String get sbExplain => 'എന്റെ ഗ്രഹ ബലം വിശദീകരിക്കുക';

  @override
  String get sbExplainSubtitle => 'നിങ്ങളുടെ ഗ്രഹങ്ങളുടെ ബലത്തിന്റെ ലളിതമായ സംഗ്രഹം';

  @override
  String get sbInfoTitle => 'ഷഡ്ബലം മനസ്സിലാക്കുക';

  @override
  String get sbQWhatIs => 'ഷഡ്ബലം എന്താണ്?';

  @override
  String get sbQRupas => 'രൂപങ്ങൾ എന്താണ്?';

  @override
  String get sbQHowCalc => 'ബലം എങ്ങനെ കണക്കാക്കുന്നു?';

  @override
  String get sbQHowUse => 'ഇത് എങ്ങനെ ഉപയോഗിക്കാം';

  @override
  String get sbWhyStrong => 'എന്തുകൊണ്ട് ശക്തം';

  @override
  String get sbWhyWeak => 'എന്തുകൊണ്ട് ദുർബലം';

  @override
  String get sbDuringMahadasha => 'മഹാദശ കാലത്ത്';

  @override
  String get sbEffects => 'ഫലങ്ങൾ';

  @override
  String get sbLifeAreas => 'ജീവിത മേഖലകള്‍';

  @override
  String get sbPlanetDetails => 'ഗ്രഹ വിശദാംശങ്ങൾ';

  @override
  String get sbBodyWhatIs => 'ഷഡ്ബലം (\'ആറിരട്ടി ബലം\') ഓരോ ഗ്രഹത്തിനും അതിന്റെ ഫലങ്ങൾ നൽകാൻ എത്ര ശക്തിയുണ്ടെന്ന്, ആറ് സ്വതന്ത്ര ബല സ്രോതസ്സുകൾ കൂട്ടിച്ചേർത്ത് അളക്കുന്നു.';

  @override
  String get sbBodyRupas => 'ബലം രൂപങ്ങളിൽ അളക്കുന്നു (1 രൂപം = 60 വിരൂപം). ശക്തമായി കണക്കാക്കാൻ ഓരോ ഗ്രഹത്തിനും ഒരു കുറഞ്ഞ രൂപ ബലം ആവശ്യമാണ്; കൂടുതൽ രൂപങ്ങൾ എന്നാൽ അത് അതിന്റെ ഫലങ്ങൾ കൂടുതൽ പൂർണ്ണമായി നൽകുന്നു എന്നാണ്.';

  @override
  String get sbBodyHowCalc => 'ആറ് ബലങ്ങൾ കൂട്ടിച്ചേർക്കുന്നു: സ്ഥാന (സ്ഥാനപരം), ദിക് (ദിശാപരം), കാല (കാലികം), ചേഷ്ടാ (ചലനപരം), നൈസർഗിക (സ്വാഭാവികം) കൂടാതെ ദൃക് (ദൃഷ്ടിപരം). ആകെ തുകയെ ഗ്രഹത്തിന്റെ ആവശ്യമായ ഏറ്റവും കുറഞ്ഞ അളവുമായി താരതമ്യം ചെയ്ത് ശതമാനം കണ്ടെത്തുന്നു.';

  @override
  String get sbBodyHowUse => '100%-ൽ കൂടുതലുള്ള ഗ്രഹം അതിന്റെ ഫലങ്ങൾ സുഖമായി നൽകുന്നു; 100%-ൽ താഴെയാണെങ്കിൽ പിന്തുണ ആവശ്യമാണ്. പ്രധാനപ്പെട്ട കാര്യങ്ങൾക്ക് നിങ്ങളുടെ ഏറ്റവും ശക്തമായ ഗ്രഹങ്ങൾക്ക് മുൻഗണന നൽകുക, ദുർബലമായവയ്ക്ക് പരിഹാരങ്ങളും ക്ഷമയും നൽകുക.';

  @override
  String get sbRemedyStrong => 'നന്നായി പിന്തുണയ്ക്കപ്പെടുന്നു — പ്രത്യേക പരിഹാരം ആവശ്യമില്ല; ഈ ഗ്രഹത്തിന്റെ കാലഘട്ടങ്ങൾ നിങ്ങൾക്ക് ആത്മവിശ്വാസത്തോടെ ഉപയോഗിക്കാം.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '${strongP} നിങ്ങളുടെ ഏറ്റവും ശക്തമായ ഗ്രഹമാണ്, ${strongTrait}ന് മികച്ച പിന്തുണ നൽകുന്നു. ${weakP} ഏറ്റവും ദുർബലമാണ്, പരിഹാരങ്ങളിൽ നിന്ന് ഏറ്റവും കൂടുതൽ പ്രയോജനം നേടുന്നു.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '${planet}ന് ${category} ഷഡ്ബലമുണ്ട്, അതിനാൽ അതിന്റെ ${karakatva} അതിനനുസരിച്ച് പിന്തുണയ്ക്കപ്പെടുന്നു.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return '${bala} വഴി ഏറ്റവും ശക്തം (${rupa} രൂപങ്ങൾ).';
  }

  @override
  String sbWeakLine(Object bala) {
    return '${bala}-ൽ ഏറ്റവും ദുർബലം, ഇത് ആകെ തുക കുറയ്ക്കുന്നു.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return '${planet}ന്റെ മഹാദശ കാലത്ത്, അതിന്റെ ${karak} മുന്നിലേക്ക് വരുന്നു.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'ശക്തമായ ഷഡ്ബലത്തോടെ, ${karak} സ്വാഭാവികമായി പിന്തുണയ്ക്കപ്പെടുന്നു.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'മിതമായ ഷഡ്ബലത്തോടെ, ${karak}ന് ബോധപൂർവമായ പരിശ്രമം ആവശ്യമായി വന്നേക്കാം.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return '${planet}നെ അതിന്റെ മന്ത്രം, രത്നം അല്ലെങ്കിൽ ദാനം വഴി ശക്തിപ്പെടുത്തുക, അതിന്റെ കാലഘട്ടങ്ങളിൽ ക്ഷമയോടെ പ്രവർത്തിക്കുക.';
  }

  @override
  String get bhOverview => 'അവലോകനം';

  @override
  String get bhDetailed => 'വിശദമായ';

  @override
  String get bhavaHouses => 'ഭാവങ്ങൾ';

  @override
  String get bhStrengthOverview => 'ഭാവ ബലം അവലോകനം';

  @override
  String get bhOverallAverage => 'മൊത്തം ഭാവ ശരാശരി';

  @override
  String get bhStrongestHouse => 'ഏറ്റവും ശക്തമായ ഭാവം';

  @override
  String get bhWeakestHouse => 'ഏറ്റവും ദുർബലമായ ഭാവം';

  @override
  String get bhBestArea => 'മികച്ച ജീവിത മേഖല';

  @override
  String get bhNeedsAttention => 'ശ്രദ്ധ ആവശ്യമാണ്';

  @override
  String get bhSavContribution => 'SAV സംഭാവന';

  @override
  String get bhLordCondition => 'ഭാവാധിപന്റെ അവസ്ഥ';

  @override
  String get bhBenefic => 'ശുഭ സ്വാധീനം';

  @override
  String get bhMalefic => 'പാപ സ്വാധീനം';

  @override
  String get bhStrengthReasons => 'ഈ സ്കോർ എന്തുകൊണ്ട്';

  @override
  String get bhGoodEffects => 'നല്ല ഫലങ്ങൾ';

  @override
  String get bhChallenges => 'വെല്ലുവിളികൾ';

  @override
  String get bhRemedies => 'പരിഹാരങ്ങൾ';

  @override
  String get bhRanking => 'ഭാവ റാങ്കിംഗ്';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'എന്റെ ഭാവങ്ങൾ വിശദീകരിക്കുക';

  @override
  String get bhExplainSubtitle => 'നിങ്ങളുടെ 12 ഭാവങ്ങളുടെ ലളിതമായ സംഗ്രഹം';

  @override
  String bhHeroSummary(Object s1, Object s2, Object strongArea, Object weakArea) {
    return 'നിങ്ങളുടെ ഏറ്റവും ശക്തമായ ഭാവങ്ങൾ ${s1}, ${s2} എന്നിവയാണ്. ${strongArea} സ്വാഭാവികമായി ശക്തമാണ്, ${weakArea}ന് കൂടുതൽ പരിശ്രമം ആവശ്യമാണ്.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'ഇതിന്റെ അധിപൻ ${lord} ${relation} ആയി സ്ഥിതി ചെയ്യുന്നു.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'ഈ ഭാവത്തിൽ ${sav} ശുഭ പോയിന്റുകൾ (SAV) ഉണ്ട്; ഇതിലുള്ള ഗ്രഹങ്ങളും അവയുടെ ദൃഷ്ടികളും ബാക്കി സ്കോർ നിർണയിക്കുന്നു.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'ശക്തമായിരിക്കുമ്പോൾ, ഇത് ${meaning}-നെ പിന്തുണയ്ക്കുന്നു.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'ദുർബലമായിരിക്കുമ്പോൾ, ${meaning}-ന് കൂടുതൽ പരിശ്രമവും ശ്രദ്ധയും ആവശ്യമായി വന്നേക്കാം.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'ഇത് മെച്ചപ്പെടുത്താൻ ഇതിന്റെ അധിപൻ ${lord}-നെ ശക്തിപ്പെടുത്തുകയും ഈ ഭാവത്തിന്റെ കാര്യങ്ങളെ ബഹുമാനിക്കുകയും ചെയ്യുക.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'നിങ്ങളുടെ ${house} ${strengthWord} ആണ്. ഇത് ${meaning} നിയന്ത്രിക്കുന്നു.';
  }

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
  String get plNature => 'സ്വഭാവം';

  @override
  String get plElement => 'ഭൂതം';

  @override
  String get plGender => 'ലിംഗം';

  @override
  String get plKarakatva => 'കാരകത്വം';

  @override
  String get plLordship => 'അധിപത്യം';

  @override
  String get plStrength => 'ബലം';

  @override
  String get plAspectsGiven => 'നൽകിയ ദൃഷ്ടി';

  @override
  String get plAspectsReceived => 'ലഭിച്ച ദൃഷ്ടി';

  @override
  String get plConjunction => 'യുതി';

  @override
  String get plHouseMeaning => 'ഭാവത്തിന്റെ അർത്ഥം';

  @override
  String get plNakshatraMeaning => 'നക്ഷത്രത്തിന്റെ അർത്ഥം';

  @override
  String get plAiInterpretation => 'AI വിശദീകരണം';

  @override
  String get plSearchHint => 'ഏതെങ്കിലും ഗ്രഹം തിരയുക';

  @override
  String get plNoResults => 'ഗ്രഹങ്ങളൊന്നും കണ്ടെത്തിയില്ല';

  @override
  String get plBenefic => 'ശുഭ';

  @override
  String get plMalefic => 'പാപ';

  @override
  String get plMale => 'പുരുഷൻ';

  @override
  String get plFemale => 'സ്ത്രീ';

  @override
  String get plNeutralGender => 'നപുംസകം';

  @override
  String get plOwnSign => 'സ്വ രാശി';

  @override
  String get plFriend => 'മിത്ര രാശി';

  @override
  String get plEnemy => 'ശത്രു രാശി';

  @override
  String get plNeutral => 'സമം';

  @override
  String get sumEther => 'ആകാശം';

  @override
  String plLordOfHouses(Object houses) {
    return 'ഭാവം ${houses}ന്റെ അധിപൻ';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return '${nakLord} ഭരിക്കുന്നു, ${trait} കൊണ്ടുവരുന്നു.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '${planet} ${sign} രാശിയിൽ, ${house} ഭാവത്തിൽ സ്ഥിതി ചെയ്യുന്നു.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'ഇതിന്റെ പ്രധാന കാരകത്വങ്ങൾ — ${karak} — ഇവിടെ നന്നായി പിന്തുണയ്ക്കപ്പെടുന്നു.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'ഇതിന്റെ പ്രധാന കാരകത്വങ്ങൾ — ${karak} — ഇവിടെ ബോധപൂർവമായ ശ്രമം ആവശ്യമായി വരാം.';
  }

  @override
  String plAiExalted(Object planet) {
    return '${planet} ഉച്ചത്തിലാണ്, അതിന്റെ ഏറ്റവും മികച്ച ഫലങ്ങൾ നൽകുന്നു.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '${planet} നീചത്തിലാണ്, ഫലങ്ങൾ നൽകാൻ പിന്തുണ ആവശ്യമാണ്.';
  }

  @override
  String plAiCombust(Object planet) {
    return '${planet} അസ്തമിച്ചിരിക്കുന്നു, അതിനാൽ സൂര്യന്റെ തീവ്രതയിൽ ഇത് കുറച്ച് പ്രകടമായി പ്രവർത്തിക്കുന്നു.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '${planet} വർഗ്ഗോത്തമമാണ് — ഈ ശക്തമായ സ്ഥാനം നവാംശത്തിലും ആവർത്തിക്കുന്നു.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '${planet} വക്രമാണ്, അതിന്റെ ഊർജ്ജത്തെ ഉള്ളിലേക്ക് തിരിച്ച് അതിനെ തീവ്രമാക്കുന്നു.';
  }

  @override
  String get plHouse1 => 'സ്വയം, ശരീരം, വ്യക്തിത്വം, ജീവശക്തി';

  @override
  String get plHouse2 => 'ധനം, കുടുംബം, സംസാരം, ഭക്ഷണം';

  @override
  String get plHouse3 => 'ധൈര്യം, സഹോദരങ്ങൾ, ആശയവിനിമയം, ചെറിയ യാത്രകൾ';

  @override
  String get plHouse4 => 'വീട്, അമ്മ, സൗകര്യം, സ്വത്ത്, ആന്തരിക സമാധാനം';

  @override
  String get plHouse5 => 'സന്താനങ്ങൾ, സർഗ്ഗാത്മകത, ബുദ്ധി, പ്രണയം, പൂർവ്വ പുണ്യം';

  @override
  String get plHouse6 => 'ആരോഗ്യം, ശത്രുക്കൾ, കടങ്ങൾ, സേവനം, ദൈനംദിന ജോലി';

  @override
  String get plHouse7 => 'വിവാഹം, പങ്കാളിത്തം, ബിസിനസ് ബന്ധങ്ങൾ';

  @override
  String get plHouse8 => 'ആയുസ്സ്, പരിവർത്തനം, രഹസ്യങ്ങൾ, പിന്തുടർച്ചാവകാശം';

  @override
  String get plHouse9 => 'ഭാഗ്യം, ധർമ്മം, ഉന്നത വിദ്യാഭ്യാസം, ഗുരു, പിതാവ്';

  @override
  String get plHouse10 => 'കരിയർ, പദവി, അധികാരം, പൊതു കർമ്മം';

  @override
  String get plHouse11 => 'നേട്ടങ്ങൾ, വരുമാനം, സുഹൃത്തുക്കൾ, ബന്ധങ്ങൾ, സഫലമായ ആഗ്രഹങ്ങൾ';

  @override
  String get plHouse12 => 'നഷ്ടം, ചെലവുകൾ, വിദേശം, ആത്മീയത, മോക്ഷം';

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
  String get kundliAscendantLagna => 'ലഗ്നം (ലഗ്നം)';

  @override
  String get kundliMoonSignRashi => 'ചന്ദ്ര രാശി (രാശി)';

  @override
  String get kundliSunSign => 'സൂര്യ രാശി';

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
  String get grahaDrishti => 'ഗ്രഹ ദൃഷ്ടി (ഗ്രഹ ദൃഷ്ടികൾ)';

  @override
  String get rashiDrishti => 'രാശി ദൃഷ്ടി (രാശി ദൃഷ്ടികൾ)';

  @override
  String get grahaDrishtiSubtitle => 'ആരാരെ ദൃഷ്ടിക്കുന്നു (%)';

  @override
  String get lagnaAspectsReceived => 'ലഗ്നത്തിന് ലഭിക്കുന്ന ദൃഷ്ടികൾ';

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
  String get gradeExcellent => 'മികച്ചത്';

  @override
  String get gradeGood => 'നല്ലത്';

  @override
  String get gradeAverage => 'ശരാശരി';

  @override
  String get gradeWeak => 'ദുർബലം';

  @override
  String get careerWord => 'കരിയർ';

  @override
  String get educationWord => 'വിദ്യാഭ്യാസം';

  @override
  String get lifeAreaMarriage => 'വിവാഹം';

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
  String get forecast => 'പ്രവചനം';

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
  String get best => 'മികച്ചത്';

  @override
  String get worst => 'മോശം';

  @override
  String get avg => 'avg';

  @override
  String get love => 'പ്രണയം';

  @override
  String get spiritual => 'ആധ്യാത്മികം';

  @override
  String get analysisConfidence => 'വിശകലന വിശ്വാസ്യത';

  @override
  String get areasForGrowth => 'വളർച്ചാ മേഖലകൾ';

  @override
  String get astrologicalRemedies => 'ജ്യോതിഷ പരിഹാരങ്ങൾ';

  @override
  String get bestIndustries => 'മികച്ച വ്യവസായങ്ങൾ';

  @override
  String get burnoutRisk => 'ബേൺഔട്ട് സാധ്യത';

  @override
  String get careerAnalysis => 'കരിയർ വിശകലനം';

  @override
  String get careerArchetype => 'കരിയർ ആർക്കിടൈപ്പ്';

  @override
  String get careerRisks => 'കരിയർ സാധ്യതാ ദോഷങ്ങൾ';

  @override
  String get careerStagnation => 'കരിയർ സ്തംഭനം';

  @override
  String get clarity => 'വ്യക്തത';

  @override
  String get copyFullReport => 'മുഴുവൻ റിപ്പോർട്ട് ഡാറ്റ പകർത്തുക';

  @override
  String get d9Dignity => 'D9 അന്തസ്സ്';

  @override
  String get divisionalValidation => 'വർഗ്ഗ സാധൂകരണം';

  @override
  String get employment => 'ജോലി';

  @override
  String get entrepreneurship => 'സംരംഭകത്വം';

  @override
  String get fitScore => 'ഫിറ്റ് സ്കോർ';

  @override
  String get freelance => 'ഫ്രീലാൻസ്';

  @override
  String get growth => 'വളർച്ച';

  @override
  String get houseAnalysis => 'ഭാവ വിശകലനം';

  @override
  String get idealEnvironment => 'അനുയോജ്യ അന്തരീക്ഷം';

  @override
  String get idealOrgSize => 'അനുയോജ്യ സ്ഥാപന വലുപ്പം';

  @override
  String get jaiminiKarakas => 'ജൈമിനി കാരകങ്ങൾ';

  @override
  String get lagnaLord => 'ലഗ്ന നാഥൻ';

  @override
  String get launchWindows => 'ആരംഭ കാലയളവുകൾ';

  @override
  String get lord => 'നാഥൻ';

  @override
  String get lordDignity => 'നാഥന്റെ അന്തസ്സ്';

  @override
  String get lordPlacedIn => 'നാഥൻ സ്ഥിതി ചെയ്യുന്നത്';

  @override
  String get overallStrength => 'മൊത്തം ബലം';

  @override
  String get peakWindows => 'ഉച്ചകാല കാലയളവുകൾ';

  @override
  String get portfolio => 'പോർട്ട്‌ഫോളിയോ';

  @override
  String get practicalSolutions => 'പ്രായോഗിക പരിഹാരങ്ങൾ';

  @override
  String get promotionWindows => 'സ്ഥാനക്കയറ്റ കാലയളവുകൾ';

  @override
  String get recognition => 'അംഗീകാരം';

  @override
  String get recommended => 'ശുപാർശ ചെയ്യുന്നത്';

  @override
  String get riskWindows => 'ദോഷ കാലയളവുകൾ';

  @override
  String get satisfaction => 'സംതൃപ്തി';

  @override
  String get stability => 'സ്ഥിരത';

  @override
  String get teamLeadership => 'ടീം നേതൃത്വം';

  @override
  String get tenthLord => '10-ാം നാഥൻ';

  @override
  String get timingWindows => 'സമയ കാലയളവുകൾ';

  @override
  String get verdict => 'വിധി';

  @override
  String get workStructure => 'ജോലി ഘടന';

  @override
  String get workplaceConflict => 'ജോലിസ്ഥല സംഘർഷം';

  @override
  String get mitigationLabel => 'ലഘൂകരണം';

  @override
  String get reliabilityVeryHigh => 'വളരെ ഉയർന്ന വിശ്വാസ്യത';

  @override
  String get reliabilityHigh => 'ഉയർന്ന വിശ്വാസ്യത';

  @override
  String get reliabilityModerate => 'ഇടത്തരം വിശ്വാസ്യത';

  @override
  String get reliabilityGuidance => 'മാർഗ്ഗനിർദ്ദേശ തലത്തിലുള്ള വായന';

  @override
  String get relationshipTitlePrefix => 'ബന്ധം';

  @override
  String get relationshipTitleSuffix => 'ഇന്റലിജൻസ്';

  @override
  String get relationshipIntelBannerLabel => 'ബന്ധ ഇന്റലിജൻസ്';

  @override
  String get typeLabel => 'തരം';

  @override
  String get trustLabel => 'വിശ്വാസം';

  @override
  String get dhokaRiskLabel => 'ധോഖ സാധ്യത';

  @override
  String powerLabel(Object power) {
    return 'ശക്തി: ${power}';
  }

  @override
  String get chartProfilesPrefix => 'ചാർട്ട്';

  @override
  String get chartProfilesSuffix => 'പ്രൊഫൈലുകൾ';

  @override
  String lagnaSuffixLabel(Object sign) {
    return '${sign} ലഗ്നം';
  }

  @override
  String get miniIntegrityLabel => 'സത്യസന്ധത';

  @override
  String get miniWarmthLabel => 'ഊഷ്മളത';

  @override
  String get miniTrustLabel => 'വിശ്വാസം';

  @override
  String get miniAssertLabel => 'ദൃഢത';

  @override
  String akLabel(Object planet) {
    return 'AK: ${planet}';
  }

  @override
  String get pairwisePrefix => 'ജോഡി';

  @override
  String get pairwiseSuffix => 'വിശകലനം';

  @override
  String trustPercentLabel(Object pct) {
    return 'വിശ്വാസം: ${pct}%';
  }

  @override
  String betrayalPercentLabel(Object pct) {
    return 'വഞ്ചന: ${pct}%';
  }

  @override
  String get scoreCharacterLabel => 'സ്വഭാവം';

  @override
  String get scoreLoveLabel => 'പ്രണയം';

  @override
  String get scoreBusinessLabel => 'ബിസിനസ്';

  @override
  String get scoreKarmicLabel => 'കാർമിക്';

  @override
  String get scoreTrustLabel => 'വിശ്വാസം';

  @override
  String get scoreEnmityRiskLabel => 'ശത്രുതാ സാധ്യത';

  @override
  String dynamicLabel(Object value) {
    return 'ചലനാത്മകം: ${value}';
  }

  @override
  String karmicLabel(Object value) {
    return 'കാർമിക്: ${value}';
  }

  @override
  String get criticalPrefix => 'നിർണായക';

  @override
  String get criticalSuffix => 'പാറ്റേണുകൾ';

  @override
  String get groupPrefix => 'ഗ്രൂപ്പ്';

  @override
  String get groupSuffix => 'ശുപാർശകൾ';

  @override
  String get sharedPracticesLabel => 'പങ്കിട്ട അഭ്യാസങ്ങൾ';

  @override
  String communicationLabel(Object value) {
    return 'ആശയവിനിമയം: ${value}';
  }

  @override
  String focusLabel(Object value) {
    return 'ശ്രദ്ധ: ${value}';
  }

  @override
  String get individualPrefix => 'വ്യക്തിഗത';

  @override
  String get individualSuffix => 'മാർഗ്ഗനിർദ്ദേശം';

  @override
  String karmicLessonLabel(Object value) {
    return 'കാർമിക് പാഠം: ${value}';
  }

  @override
  String get growthAreasLabel => 'വളർച്ചാ മേഖലകൾ';

  @override
  String get corePrefix => 'കാതൽ';

  @override
  String get coreSuffix => 'പ്രമേയം';

  @override
  String get growthOrientedLabel => 'വളർച്ചാ അധിഷ്ഠിതം';

  @override
  String get groupThemeLabel => 'ഗ്രൂപ്പ് പ്രമേയം';

  @override
  String get analysisPrefix => 'വിശകലനം';

  @override
  String get analysisConfidenceSuffix => 'വിശ്വാസ്യത';

  @override
  String get reportCopied => 'റിപ്പോർട്ട് പകർത്തി!';

  @override
  String get copyFullReportData => 'മുഴുവൻ റിപ്പോർട്ട് ഡാറ്റ പകർത്തുക';

  @override
  String get openExternalLabel => 'തുറക്കുക';

  @override
  String copiedOpeningAi(Object ai) {
    return 'പകർത്തി! ${ai} തുറക്കുന്നു...';
  }

  @override
  String get milanTitlePrefix => 'കുണ്ഡലി';

  @override
  String get ashtakoot => 'അഷ്ടകൂട്';

  @override
  String get compatibilityLabel => 'പൊരുത്തം';

  @override
  String get unifiedScoreLabel => 'ഏകീകൃത\nസ്കോർ';

  @override
  String get probabilityLabel => 'സാധ്യത';

  @override
  String ganaLabel(Object value) {
    return 'ഗണം: ${value}';
  }

  @override
  String get gunPrefixLabel => '8 ഗുണം';

  @override
  String get breakdownLabel => 'വിശദാംശം';

  @override
  String get mangalLabel => 'മംഗൾ';

  @override
  String severityLabel(Object value) {
    return 'തീവ്രത: ${value}';
  }

  @override
  String get d9Label => 'D-9';

  @override
  String get crossChartLabel => 'ക്രോസ്-ചാർട്ട്';

  @override
  String get d9CompatibilityLabel => 'D-9 പൊരുത്തം';

  @override
  String get domainEmotional => 'വൈകാരികം';

  @override
  String get domainIntellectual => 'ബൗദ്ധികം';

  @override
  String get domainSpiritual => 'ആത്മീയം';

  @override
  String get domainFinancial => 'സാമ്പത്തികം';

  @override
  String get domainDomestic => 'ഗാർഹികം';

  @override
  String get domainCommunication => 'ആശയവിനിമയം';

  @override
  String get domainSharedDharma => 'പങ്കിട്ട ധർമ്മം';

  @override
  String get domainFamilyCreation => 'കുടുംബ സൃഷ്ടി';

  @override
  String get domainLabel => 'മേഖല';

  @override
  String get compatibilitySuffixLabel => 'പൊരുത്തം';

  @override
  String get marriageLabel => 'വിവാഹം';

  @override
  String get timingLabel => 'സമയം';

  @override
  String get jointMarriageWindowsTitle => 'സംയുക്ത വിവാഹ കാലയളവുകൾ';

  @override
  String get engagementWindowsTitle => 'വിവാഹനിശ്ചയ കാലയളവുകൾ';

  @override
  String recommendedLabel(Object value) {
    return 'ശുപാർശ: ${value}';
  }

  @override
  String get risksLabel => 'സാധ്യതാ ദോഷങ്ങൾ';

  @override
  String get finalLabel => 'അന്തിമം';

  @override
  String get verdictLabel => 'വിധി';

  @override
  String get marriageVerdictLabel => 'വിവാഹ വിധി';

  @override
  String get discussReportWithAI => 'ഈ റിപ്പോർട്ട് AI-യുമായി ചർച്ച ചെയ്യുക';

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
  String get multiChartSuffixCompatibility => 'പൊരുത്തം';

  @override
  String get multiChartSuffixLinkage => 'ബന്ധം';

  @override
  String get multiChartSuffixReport => 'റിപ്പോർട്ട്';

  @override
  String get participantsLabel => 'പങ്കാളികൾ';

  @override
  String get reportDataCopied => 'റിപ്പോർട്ട് ഡാറ്റ പകർത്തി!';

  @override
  String copiedForAi(Object label) {
    return '${label}-നായി പകർത്തി!';
  }

  @override
  String get wealthScoresLabel => 'സമ്പത്ത് സ്കോറുകൾ';

  @override
  String get wealthStrengthLabel => 'സമ്പത്ത്\nബലം';

  @override
  String get accumulationLabel => 'സഞ്ചയം';

  @override
  String get incomeFlowLabel => 'വരുമാന\nഒഴുക്ക്';

  @override
  String get sustainLabel => 'നിലനിർത്തൽ';

  @override
  String get multiStreamLabel => 'മൾട്ടി-സ്ട്രീം';

  @override
  String get retentionLabel => 'സൂക്ഷിപ്പ്';

  @override
  String get wealthLabel => 'സമ്പത്ത്';

  @override
  String get karakasLabel => 'കാരകങ്ങൾ';

  @override
  String get wealthYogasTitle => 'ധന യോഗങ്ങൾ';

  @override
  String get drainsLabel => 'ചോർച്ചകൾ';

  @override
  String get boostersLabel => 'ഉത്തേജകങ്ങൾ';

  @override
  String get incomeLabel => 'വരുമാനം';

  @override
  String get sourcesLabel => 'ഉറവിടങ്ങൾ';

  @override
  String get investmentLabel => 'നിക്ഷേപം';

  @override
  String get mixLabel => 'മിശ്രിതം';

  @override
  String get yearlyTrendTitle => 'വാർഷിക പ്രവണത';

  @override
  String get wealthGrowthTitle => 'സമ്പത്ത് വളർച്ച';

  @override
  String get cashPressureTitle => 'പണ സമ്മർദ്ദം';

  @override
  String get moneyPersonalityTitle => 'പണ വ്യക്തിത്വം';

  @override
  String get wealthTypeLabel => 'സമ്പത്ത് തരം';

  @override
  String get riskAppetiteLabel => 'റിസ്ക് ആഭിമുഖ്യം';

  @override
  String get investmentStyleLabel => 'നിക്ഷേപ ശൈലി';

  @override
  String get moneyPersonalityLabel => 'പണ വ്യക്തിത്വം';

  @override
  String get spendingLabel => 'ചെലവ്';

  @override
  String get debtProbLabel => 'കട സാധ്യത %';

  @override
  String get inheritanceProbLabel => 'അനന്തരാവകാശം %';

  @override
  String get suddenGainsProbLabel => 'പെട്ടെന്നുള്ള നേട്ടം %';

  @override
  String get spouseBoostLabel => 'പങ്കാളി ബൂസ്റ്റ് %';

  @override
  String successProbabilityLabel(Object pct) {
    return 'വിജയ സാധ്യത: ${pct}%';
  }

  @override
  String get lifetimeWealthClassLabel => 'ജീവിതകാല സമ്പത്ത് വർഗ്ഗം';

  @override
  String primaryLabel(Object value) {
    return 'പ്രാഥമികം: ${value}';
  }

  @override
  String peakAgeLabel(Object value) {
    return 'ഉച്ചകാലം: ${value}';
  }

  @override
  String drivenByLabel(Object value) {
    return '${value} നയിക്കുന്നു';
  }

  @override
  String get coreBlockerLabel => 'കാതൽ തടസ്സം';

  @override
  String get debtScoresLabel => 'കട സ്കോറുകൾ';

  @override
  String get currentDebtLoadLabel => 'നിലവിലെ\nകട ഭാരം';

  @override
  String get recoveryCapacityLabel => 'വീണ്ടെടുപ്പ്\nശേഷി';

  @override
  String get intensityLabel => 'തീവ്രത';

  @override
  String get defaultRiskLabel => 'ഡിഫോൾട്ട് സാധ്യത';

  @override
  String get debtProfileTitle => 'കട പ്രൊഫൈൽ';

  @override
  String get karmaLabel => 'കർമ്മം';

  @override
  String get personalityLabel => 'വ്യക്തിത്വം';

  @override
  String get phaseLabel => 'ഘട്ടം';

  @override
  String get primaryCategoryLabel => 'പ്രാഥമിക വിഭാഗം';

  @override
  String get debtLabel => 'കടം';

  @override
  String get debtYogasTitle => 'കട യോഗങ്ങൾ';

  @override
  String get debtCreatingLabel => 'കടം സൃഷ്ടിക്കുന്നത്';

  @override
  String get debtClearingLabel => 'കടം തീർക്കുന്നത്';

  @override
  String get categoriesLabel => 'വിഭാഗങ്ങൾ';

  @override
  String get yearlyDebtTitle => 'വാർഷിക കടം';

  @override
  String get repaymentTitle => 'തിരിച്ചടവ്';

  @override
  String get dangerPeriodsTitle => 'അപകട കാലയളവുകൾ';

  @override
  String get defaultPctLabel => 'ഡിഫോൾട്ട് %';

  @override
  String get bankruptcyPctLabel => 'പാപ്പരത്തം %';

  @override
  String get chronicPctLabel => 'ദീർഘകാല %';

  @override
  String get resilienceLabel => 'പ്രതിരോധശേഷി';

  @override
  String recoveryTimelineLabel(Object pct, Object years) {
    return 'വീണ്ടെടുപ്പ്: ${pct}% · സമയരേഖ: ${years} വർഷം';
  }

  @override
  String get debtFreeWindowLabel => 'കടരഹിത കാലയളവ്';

  @override
  String yearLabel(Object year) {
    return 'വർഷം ${year}';
  }

  @override
  String dashaLabel(Object value) {
    return 'ദശ: ${value}';
  }

  @override
  String get marriageScoresLabel => 'വിവാഹ സ്കോറുകൾ';

  @override
  String get overallMarriageLabel => 'മൊത്തം\nവിവാഹം';

  @override
  String get maritalHarmonyLabel => 'ദാമ്പത്യ\nയോജിപ്പ്';

  @override
  String get domesticStabilityLabel => 'ഗാർഹിക\nസ്ഥിരത';

  @override
  String get longevityLabel => 'ദീർഘായുസ്സ്';

  @override
  String get satisfactionLabel => 'സംതൃപ്തി';

  @override
  String get clarityLabel => 'വ്യക്തത';

  @override
  String get darakarakaLabel => 'ദാരാകാരകൻ';

  @override
  String get spouseKarakaLabel => 'പങ്കാളി കാരകൻ';

  @override
  String get darakarakaDkLabel => 'ദാരാകാരകൻ (DK)';

  @override
  String get seventhLabel => '7-ാം';

  @override
  String get lordLabel => 'നാഥൻ';

  @override
  String get lordInLabel => 'നാഥൻ സ്ഥിതി';

  @override
  String get lordDignityLabel => 'നാഥന്റെ അന്തസ്സ്';

  @override
  String get emptyLabel => 'ശൂന്യം';

  @override
  String get spouseLabel => 'പങ്കാളി';

  @override
  String get spouseTraitsLabel => 'പങ്കാളി സവിശേഷതകൾ';

  @override
  String get likelyProfessionsLabel => 'സാധ്യതയുള്ള തൊഴിലുകൾ';

  @override
  String get harmonyPhysicalLabel => 'ശാരീരികം';

  @override
  String get sharedValuesLabel => 'പങ്കിട്ട മൂല്യങ്ങൾ';

  @override
  String get conflictResolutionLabel => 'സംഘർഷ പരിഹാരം';

  @override
  String get harmonyLabel => 'യോജിപ്പ്';

  @override
  String get radarLabel => 'റഡാർ';

  @override
  String get mangalDoshLabel => 'മംഗൾ ദോഷം';

  @override
  String severityColonLabel(Object value) {
    return 'തീവ്രത: ${value}';
  }

  @override
  String cancellationColonLabel(Object value) {
    return 'റദ്ദാക്കൽ: ${value}';
  }

  @override
  String get marriageWindowsTitle => 'വിവാഹ കാലയളവുകൾ';

  @override
  String get marriagePhasesTitle => 'വിവാഹ ഘട്ടങ്ങൾ';

  @override
  String get inLawRelationsLabel => 'ഭർതൃ/പത്നീ കുടുംബ ബന്ധം';

  @override
  String get familyHarmonyLabel => 'കുടുംബ യോജിപ്പ്';

  @override
  String get fertilityLabel => 'പ്രത്യുൽപാദനശേഷി';

  @override
  String get homeOwnershipLabel => 'വീട് ഉടമസ്ഥത';

  @override
  String get divorceRiskLabel => 'വിവാഹമോചന സാധ്യത';

  @override
  String get infidelityLabel => 'വിശ്വാസവഞ്ചന';

  @override
  String get conflictLabel => 'സംഘർഷം';

  @override
  String get distanceLabel => 'അകലം';

  @override
  String get seekInPartnerLabel => 'പങ്കാളിയിൽ തേടേണ്ടത്';

  @override
  String get avoidInPartnerLabel => 'പങ്കാളിയിൽ ഒഴിവാക്കേണ്ടത്';

  @override
  String realizationLabel(Object pct) {
    return 'സാക്ഷാത്കാരം: ${pct}%';
  }

  @override
  String get navamsaLabel => 'നവാംശം';

  @override
  String get characterScoresLabel => 'സ്വഭാവ സ്കോറുകൾ';

  @override
  String get characterStrengthLabel => 'സ്വഭാവ\nബലം';

  @override
  String get characterIntegrityLabel => 'സത്യസന്ധത';

  @override
  String get awarenessLabel => 'അവബോധം';

  @override
  String get stabilityLabel => 'സ്ഥിരത';

  @override
  String get ethicsLabel => 'സദാചാരം';

  @override
  String get surfacePersonalityTitle => 'ബാഹ്യ വ്യക്തിത്വം';

  @override
  String get constitutionLabel => 'പ്രകൃതി';

  @override
  String get nakshatraLabel => 'നക്ഷത്രം';

  @override
  String get deityLabel => 'ദേവത';

  @override
  String get moonManasTitle => 'ചന്ദ്ര മനസ്സ്';

  @override
  String get warmthLabel => 'ഊഷ്മളത';

  @override
  String get empathyLabel => 'സഹാനുഭൂതി';

  @override
  String get loyaltyLabel => 'വിശ്വസ്തത';

  @override
  String get boundariesLabel => 'അതിരുകൾ';

  @override
  String get dharmaLabel => 'ധർമ്മം';

  @override
  String get truthLabel => 'സത്യം';

  @override
  String get compassionLabel => 'കാരുണ്യം';

  @override
  String get generosityLabel => 'ഔദാര്യം';

  @override
  String get signatureVirtuesLabel => 'മുഖ്യ സദ്ഗുണങ്ങൾ';

  @override
  String get naturalTalentsLabel => 'സ്വാഭാവിക കഴിവുകൾ';

  @override
  String get shadowPatternsLabel => 'നിഴൽ പാറ്റേണുകൾ';

  @override
  String get characterYogasTitle => 'സ്വഭാവ യോഗങ്ങൾ';

  @override
  String get testsLabel => 'പരീക്ഷണങ്ങൾ';

  @override
  String get giftsLabel => 'വരദാനങ്ങൾ';

  @override
  String get selfAwareEiLabel => 'സ്വയം അവബോധം EI';

  @override
  String get selfRegulateLabel => 'സ്വയം നിയന്ത്രണം';

  @override
  String get empathyEiLabel => 'സഹാനുഭൂതി EI';

  @override
  String get socialSkillsLabel => 'സാമൂഹിക കഴിവുകൾ';

  @override
  String get atmakarakaLabel => 'ആത്മകാരകൻ';

  @override
  String get soulSignatureLabel => 'ആത്മ മുദ്ര';

  @override
  String get atmakarakaAllCapsLabel => 'ആത്മകാരകൻ';

  @override
  String get gunaLabel => 'ഗുണം';

  @override
  String dominantColonLabel(Object value) {
    return 'പ്രബലം: ${value}';
  }

  @override
  String get coreGiftLabel => 'കാതൽ വരദാനം';

  @override
  String get coreThemeAllCapsLabel => 'കാതൽ പ്രമേയം';

  @override
  String get pastLifeScoresLabel => 'പൂർവ്വജന്മ സ്കോറുകൾ';

  @override
  String get signatureStrengthLabel => 'മുദ്ര\nബലം';

  @override
  String get carryForwardLabel => 'മുന്നോട്ട്\nകൊണ്ടുവരൽ';

  @override
  String get masteryPreservedLabel => 'സൂക്ഷിച്ച\nനൈപുണ്യം';

  @override
  String get unfinishedLabel => 'പൂർത്തിയാകാത്തത്';

  @override
  String get karmicDebtLabel => 'കാർമിക് കടം';

  @override
  String get pastMasteryLabel => 'പൂർവ്വ നൈപുണ്യം';

  @override
  String get futureGrowthLabel => 'ഭാവി വളർച്ച';

  @override
  String get ketuWhatYouMasteredLabel => 'കേതു · നിങ്ങൾ നേടിയത്';

  @override
  String get rahuWhatPullsForwardLabel => 'രാഹു · നിങ്ങളെ മുന്നോട്ട് നയിക്കുന്നത്';

  @override
  String get pastLifeProfileTitle => 'പൂർവ്വജന്മ പ്രൊഫൈൽ';

  @override
  String get themeLabel => 'പ്രമേയം';

  @override
  String get professionLabel => 'തൊഴിൽ';

  @override
  String get socialStandingLabel => 'സാമൂഹിക നില';

  @override
  String get regionLabel => 'പ്രദേശം';

  @override
  String get spiritualLevelLabel => 'ആത്മീയ നില';

  @override
  String get wealthLevelLabel => 'സമ്പത്ത് നില';

  @override
  String get familyRoleLabel => 'കുടുംബ പങ്ക്';

  @override
  String get skillsCarriedForwardLabel => 'മുന്നോട്ട് കൊണ്ടുവന്ന കഴിവുകൾ';

  @override
  String get naturalAttractionsLabel => 'സ്വാഭാവിക ആകർഷണങ്ങൾ';

  @override
  String get unexplainedFearsLabel => 'വിശദീകരിക്കാനാവാത്ത ഭയങ്ങൾ';

  @override
  String get magneticPullsLabel => 'കാന്തിക ആകർഷണങ്ങൾ';

  @override
  String get relationshipLabel => 'ബന്ധം';

  @override
  String get financialLabel => 'സാമ്പത്തികം';

  @override
  String get serviceLabel => 'സേവനം';

  @override
  String get dharmicLabel => 'ധാർമ്മികം';

  @override
  String get onRelationsLabel => 'ബന്ധങ്ങളിൽ';

  @override
  String get onCareerLabel => 'കരിയറിൽ';

  @override
  String get onHealthLabel => 'ആരോഗ്യത്തിൽ';

  @override
  String get onSpiritualLabel => 'ആത്മീയതയിൽ';

  @override
  String get karmicResolutionTitle => 'കാർമിക് പരിഹാരം';

  @override
  String get primaryPathLabel => 'പ്രാഥമിക പാത';

  @override
  String get secondaryPathLabel => 'ദ്വിതീയ പാത';

  @override
  String get clearingProgressLabel => 'തീർക്കൽ പുരോഗതി';

  @override
  String get remainingWorkLabel => 'ബാക്കിയുള്ള ജോലി';

  @override
  String get debtTimelineLabel => 'കട സമയരേഖ';

  @override
  String get memoryAccessLabel => 'ഓർമ്മ ലഭ്യത';

  @override
  String get dreamVisitsLabel => 'സ്വപ്ന സന്ദർശനങ്ങൾ';

  @override
  String get dejaVuLabel => 'ദേജാ വൂ';

  @override
  String get regressionFitLabel => 'റിഗ്രഷൻ ഫിറ്റ്';

  @override
  String get pastLifeActivationTitle => 'പൂർവ്വജന്മ സജീവമാക്കൽ';

  @override
  String maturityStatusLabel(Object score, Object status) {
    return 'പക്വത: ${score} · സ്ഥിതി: ${status}';
  }

  @override
  String shadowColonLabel(Object value) {
    return 'നിഴൽ: ${value}';
  }

  @override
  String get lifePathScoresLabel => 'ജീവിതപാത സ്കോറുകൾ';

  @override
  String get dharmaClarityLabel => 'ധർമ്മ\nവ്യക്തത';

  @override
  String get fortuneBaselineLabel => 'ഭാഗ്യ\nഅടിസ്ഥാനം';

  @override
  String get lifePathCoherenceLabel => 'ജീവിതപാത\nസംയോജനം';

  @override
  String get karmaAllCapsLabel => 'കർമ്മം';

  @override
  String get spiritualAllCapsLabel => 'ആത്മീയം';

  @override
  String get fameLabel => 'പ്രശസ്തി';

  @override
  String get lifeLabel => 'ജീവിതം';

  @override
  String get archetypeLabel => 'ആർക്കിടൈപ്പ്';

  @override
  String get soulContractTitle => 'ആത്മ കരാർ';

  @override
  String get akFocusLabel => 'AK ശ്രദ്ധ';

  @override
  String get soulPurposeLabel => 'ആത്മ ലക്ഷ്യം';

  @override
  String get lifeChapterLabel => 'ജീവിത അധ്യായം';

  @override
  String get primaryDomainLabel => 'പ്രാഥമിക മേഖല';

  @override
  String get leadershipLabel => 'നേതൃത്വം';

  @override
  String get wisdomTeachLabel => 'ജ്ഞാനം/അധ്യാപനം';

  @override
  String get healingLabel => 'രോഗശാന്തി';

  @override
  String get fortuneYogasTitle => 'ഭാഗ്യ യോഗങ്ങൾ';

  @override
  String get luckBlocksLabel => 'ഭാഗ്യ തടസ്സങ്ങൾ';

  @override
  String get fortuneBoostersLabel => 'ഭാഗ്യ ഉത്തേജകങ്ങൾ';

  @override
  String get fortuneTrendTitle => 'ഭാഗ്യ പ്രവണത';

  @override
  String get goldenWindowsTitle => 'സുവർണ്ണ കാലയളവുകൾ ★';

  @override
  String get transformationTitle => 'രൂപാന്തരം';

  @override
  String get lifeMilestonesTitle => 'ജീവിത നാഴികക്കല്ലുകൾ';

  @override
  String get destinyVsLabel => 'വിധി vs';

  @override
  String get freeWillLabel => 'സ്വതന്ത്ര ഇച്ഛ';

  @override
  String get destinyAllCapsLabel => 'വിധി';

  @override
  String get freeWillAllCapsLabel => 'സ്വതന്ത്ര ഇച്ഛ';

  @override
  String get karmicLessonsTitle => 'കാർമിക് പാഠങ്ങൾ';

  @override
  String get rahuGrowthLabel => 'രാഹു വളർച്ച';

  @override
  String get ketuSurrenderLabel => 'കേതു സമർപ്പണം';

  @override
  String get saturnLessonLabel => 'ശനി പാഠം';

  @override
  String get lifeDifficultyLabel => 'ജീവിത പ്രയാസം';

  @override
  String get soulCameToExperienceLabel => 'ആത്മാവ് അനുഭവിക്കാൻ വന്നത്';

  @override
  String get blessingsLabel => 'അനുഗ്രഹങ്ങൾ';

  @override
  String fulfillmentLabel(Object pct) {
    return 'പൂർത്തീകരണം: ${pct}%';
  }

  @override
  String get legalScoresLabel => 'നിയമ സ്കോറുകൾ';

  @override
  String get legalVulnerabilityLabel => 'നിയമ\nദുർബലത';

  @override
  String get victoryPotentialLabel => 'വിജയ\nസാധ്യത';

  @override
  String get resolutionLabel => 'പരിഹാരം';

  @override
  String get legalProfileTitle => 'നിയമ പ്രൊഫൈൽ';

  @override
  String get karmaTypeLabel => 'കർമ്മ തരം';

  @override
  String get conflictStyleLabel => 'സംഘർഷ ശൈലി';

  @override
  String get strategyLabel => 'തന്ത്രം';

  @override
  String get caseDurationLabel => 'കേസ് കാലാവധി';

  @override
  String get currentStatusLabel => 'നിലവിലെ സ്ഥിതി';

  @override
  String get legalLabel => 'നിയമം';

  @override
  String get legalYogasTitle => 'നിയമ യോഗങ്ങൾ';

  @override
  String get disputePressureLabel => 'തർക്ക സമ്മർദ്ദം';

  @override
  String get legalProtectionLabel => 'നിയമ സംരക്ഷണം';

  @override
  String get victoryLabel => 'വിജയം';

  @override
  String get asPlaintiffLabel => 'വാദിയായി';

  @override
  String get asDefendantLabel => 'പ്രതിയായി';

  @override
  String get winProbabilityLabel => 'വിജയ സാധ്യത';

  @override
  String get disputeLabel => 'തർക്കം';

  @override
  String get legalStressTitle => 'നിയമ സമ്മർദ്ദം';

  @override
  String get visibleEnemiesLabel => 'ദൃശ്യ ശത്രുക്കൾ';

  @override
  String get hiddenEnemiesLabel => 'മറഞ്ഞ ശത്രുക്കൾ';

  @override
  String get criminalRiskLabel => 'ക്രിമിനൽ സാധ്യത';

  @override
  String get falseAccusationLabel => 'വ്യാജ ആരോപണം';

  @override
  String get contractKarmaTitle => 'കരാർ കർമ്മം';

  @override
  String get documentationLabel => 'രേഖകൾ';

  @override
  String get finePrintAwareLabel => 'സൂക്ഷ്മ വ്യവസ്ഥാ അവബോധം';

  @override
  String get negotiationSkillLabel => 'വിലപേശൽ കഴിവ്';

  @override
  String get signatureCautionLabel => 'ഒപ്പിടൽ ജാഗ്രത';

  @override
  String resilienceColonLabel(Object value) {
    return 'പ്രതിരോധശേഷി: ${value}/100';
  }

  @override
  String get healthScoresLabel => 'ആരോഗ്യ സ്കോറുകൾ';

  @override
  String get vitalityLabel => 'ഓജസ്സ്';

  @override
  String get immunityLabel => 'പ്രതിരോധശക്തി';

  @override
  String get recoveryLabel => 'വീണ്ടെടുപ്പ്';

  @override
  String get mentalLabel => 'മാനസികം';

  @override
  String get stressTolLabel => 'സമ്മർദ്ദ സഹനം';

  @override
  String get ayurvedicLabel => 'ആയുർവേദം';

  @override
  String get constitutionTitleLabel => 'പ്രകൃതി';

  @override
  String secondaryColonLabel(Object value) {
    return 'ദ്വിതീയം: ${value}';
  }

  @override
  String get bodyLabel => 'ശരീരം';

  @override
  String get systemMapLabel => 'സിസ്റ്റം മാപ്പ്';

  @override
  String get healthYogasTitle => 'ആരോഗ്യ യോഗങ്ങൾ';

  @override
  String get diseasePressureLabel => 'രോഗ സമ്മർദ്ദം';

  @override
  String get protectiveLabel => 'സംരക്ഷണം';

  @override
  String get bodyZoneLabel => 'ശരീര മേഖല';

  @override
  String get vulnerabilityLabel => 'ദുർബലത';

  @override
  String get diseaseLabel => 'രോഗം';

  @override
  String get susceptibilityLabel => 'സാധ്യത';

  @override
  String get healthTrendTitle => 'ആരോഗ്യ പ്രവണത';

  @override
  String get recoveryWindowsTitle => 'വീണ്ടെടുപ്പ് കാലയളവുകൾ';

  @override
  String get cautionPeriodsTitle => 'ജാഗ്രതാ കാലയളവുകൾ';

  @override
  String get burnoutRiskLabel => 'ബേൺഔട്ട് സാധ്യത';

  @override
  String get addictionVulnLabel => 'അടിമത്ത ദുർബലത';

  @override
  String get workLifeBalLabel => 'ജോലി-ജീവിത സന്തുലനം';

  @override
  String get lifestyleFactorsTitle => 'ജീവിതശൈലി ഘടകങ്ങൾ';

  @override
  String get sleepDisciplineLabel => 'ഉറക്ക അച്ചടക്കം';

  @override
  String get dietDisciplineLabel => 'ആഹാര അച്ചടക്കം';

  @override
  String get exerciseNeedLabel => 'വ്യായാമ ആവശ്യം';

  @override
  String get sunlightNeedLabel => 'സൂര്യപ്രകാശ ആവശ്യം';

  @override
  String get socialTypeLabel => 'സാമൂഹിക തരം';

  @override
  String get healingSpeedLabel => 'രോഗശാന്തി വേഗത';

  @override
  String get mentalScoresLabel => 'മാനസിക സ്കോറുകൾ';

  @override
  String get mentalStabilityLabel => 'മാനസിക\nസ്ഥിരത';

  @override
  String get emotionalBaselineLabel => 'വൈകാരിക\nഅടിസ്ഥാനം';

  @override
  String get anxietyLabel => 'ഉത്കണ്ഠ';

  @override
  String get depressionLabel => 'വിഷാദം';

  @override
  String get regulationLabel => 'നിയന്ത്രണം';

  @override
  String get mentalProfileTitle => 'മാനസിക പ്രൊഫൈൽ';

  @override
  String get stressDriverLabel => 'സമ്മർദ്ദ ഹേതു';

  @override
  String get stabilityAnchorLabel => 'സ്ഥിരതാ ആധാരം';

  @override
  String get attachmentStyleLabel => 'അടുപ്പ ശൈലി';

  @override
  String get burnoutStageLabel => 'ബേൺഔട്ട് ഘട്ടം';

  @override
  String get mentalTitleLabel => 'മാനസികം';

  @override
  String get mentalYogasTitle => 'മാനസിക യോഗങ്ങൾ';

  @override
  String get stressPressureLabel => 'സമ്മർദ്ദ ഭാരം';

  @override
  String get stressResponseLabel => 'സമ്മർദ്ദ പ്രതികരണം';

  @override
  String get anxietyTitleLabel => 'ഉത്കണ്ഠ';

  @override
  String get typesLabel => 'തരങ്ങൾ';

  @override
  String get therapyLabel => 'തെറാപ്പി';

  @override
  String get modalityFitLabel => 'രീതി അനുയോജ്യത';

  @override
  String get wellnessTrendTitle => 'ക്ഷേമ പ്രവണത';

  @override
  String get healthyCopingLabel => 'ആരോഗ്യകര നേരിടൽ';

  @override
  String get unhealthyRisksLabel => 'അനാരോഗ്യകര സാധ്യതകൾ';

  @override
  String get recommendedAlternativesLabel => 'ശുപാർശ ചെയ്ത ബദലുകൾ';

  @override
  String get sleepQualityLabel => 'ഉറക്ക ഗുണനിലവാരം';

  @override
  String get socialSupportLabel => 'സാമൂഹിക പിന്തുണ';

  @override
  String get burnoutVulnLabel => 'ബേൺഔട്ട് ദുർബലത';

  @override
  String get selfAwarenessLabel => 'സ്വയം അവബോധം';

  @override
  String get authTagline => 'ജ്യോതിഷികൾക്കായുള്ള Nakshatralogy';

  @override
  String get googleSignInNoToken => 'Google Sign-In: ID ടോക്കൺ ലഭിച്ചില്ല. GOOGLE_WEB_CLIENT_ID സജ്ജമാണെന്നും google-services.json കോൺഫിഗർ ചെയ്തിട്ടുണ്ടെന്നും ഉറപ്പാക്കുക.';

  @override
  String googleSignInError(String error) {
    return 'Google Sign-In പിശക്: ${error}';
  }

  @override
  String get orDivider => 'അല്ലെങ്കിൽ';

  @override
  String get register => 'രജിസ്റ്റർ ചെയ്യുക';

  @override
  String get signInWithBiometrics => 'ബയോമെട്രിക്സ് ഉപയോഗിച്ച് സൈൻ ഇൻ ചെയ്യുക';

  @override
  String get forgotPasswordInstructions => 'റീസെറ്റ് ലിങ്ക് ലഭിക്കാൻ നിങ്ങളുടെ\nരജിസ്റ്റർ ചെയ്ത ഇമെയിൽ നൽകുക.';

  @override
  String get resendLink => 'ലിങ്ക് വീണ്ടും അയയ്ക്കുക';

  @override
  String callJoinedChannel(String channel) {
    return '${channel} ചാനലിൽ ചേർന്നു';
  }

  @override
  String get callUserConnected => 'ഉപയോക്താവ് കണക്റ്റ് ചെയ്തു! കോൾ സജീവം';

  @override
  String callConnectionFailed(String reason) {
    return 'കണക്ഷൻ പരാജയപ്പെട്ടു: ${reason}. Agora ക്രെഡൻഷ്യലുകൾ പരിശോധിക്കുക.';
  }

  @override
  String callAgoraError(String details) {
    return 'Agora പിശക്: ${details}';
  }

  @override
  String callAgoraInitFailed(String error) {
    return 'Agora ഇനിറ്റ് പരാജയപ്പെട്ടു: ${error}';
  }

  @override
  String get callWaitingForVideo => 'വീഡിയോയ്ക്കായി കാത്തിരിക്കുന്നു...';

  @override
  String get callVideoCall => 'വീഡിയോ കോൾ';

  @override
  String get callVoiceCall => 'വോയിസ് കോൾ';

  @override
  String callRateEarning(String rate, String earning) {
    return '${rate}/മിനിറ്റ് • സമ്പാദ്യം: ${earning}';
  }

  @override
  String get markAllRead => 'എല്ലാം വായിച്ചതായി അടയാളപ്പെടുത്തുക';

  @override
  String get noNotificationsYet => 'അറിയിപ്പുകളൊന്നുമില്ല';

  @override
  String get pullToRefresh => 'പുതുക്കാൻ താഴേക്ക് വലിക്കുക';

  @override
  String get justNow => 'ഇപ്പോൾ';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}മി മുമ്പ്';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}മ മുമ്പ്';
  }

  @override
  String daysAgo(int days) {
    return '${days}ദി മുമ്പ്';
  }

  @override
  String get noChartsCreateFirst => 'ചാർട്ടുകളില്ല. ആദ്യം ഒരു ജനന ചാർട്ട് സൃഷ്ടിക്കുക.';

  @override
  String get selectBirthChartToAnalyze => 'വിശകലനം ചെയ്യാൻ ഒരു ജനന ചാർട്ട് തിരഞ്ഞെടുക്കുക';

  @override
  String get unknownName => 'അജ്ഞാതം';

  @override
  String selectRangeCharts(int max) {
    return '2-${max} ചാർട്ടുകൾ തിരഞ്ഞെടുക്കുക';
  }

  @override
  String selectExactCharts(int max) {
    return '${max} ചാർട്ടുകൾ തിരഞ്ഞെടുക്കുക';
  }

  @override
  String runningAnalysis(String label) {
    return '${label} വിശകലനം നടത്തുന്നു...';
  }

  @override
  String pickKarmicCharts(int max) {
    return 'കാർമിക് ബന്ധങ്ങൾ വിശകലനം ചെയ്യാൻ 2 മുതൽ ${max} വരെ ചാർട്ടുകൾ തിരഞ്ഞെടുക്കുക';
  }

  @override
  String get pickMaleFemaleChart => 'ഒരു പുരുഷ, സ്ത്രീ ചാർട്ട് തിരഞ്ഞെടുക്കുക';

  @override
  String get analysisFailed => 'വിശകലനം പരാജയപ്പെട്ടു';

  @override
  String errorWithDetails(String error) {
    return 'പിശക്: ${error}';
  }

  @override
  String personNumber(int n) {
    return 'വ്യക്തി ${n}';
  }

  @override
  String analyzeNCharts(int count) {
    return '${count} ചാർട്ടുകൾ വിശകലനം ചെയ്യുക';
  }

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
  String get bhavaHouse10 => 'കരിയർ / പിതാവ്';

  @override
  String get bhavaHouse11 => 'നേട്ടങ്ങൾ / സുഹൃത്തുക്കൾ';

  @override
  String get bhavaHouse12 => 'നഷ്ടം / മോക്ഷം';

  @override
  String bhavaSignLord(String sign, String lord) {
    return '${sign} • നാഥൻ: ${lord}';
  }

  @override
  String bhavaSavValue(String value) {
    return 'SAV: ${value}';
  }

  @override
  String get today => 'ഇന്ന്';

  @override
  String gocharTransitScoresTitle(String date) {
    return 'ഗോചരം (ഗോചര സ്കോറുകൾ) — ${date}';
  }

  @override
  String gocharNativeMoon(String moonSign) {
    return 'ജാതക ചന്ദ്രൻ: ${moonSign}';
  }

  @override
  String get gocharBest => 'മികച്ചത്';

  @override
  String get gocharWorst => 'മോശം';

  @override
  String get aspectsGrahaDrishtiTitle => 'ഗ്രഹ ദൃഷ്ടി (ഗ്രഹ വീക്ഷണങ്ങൾ)';

  @override
  String get aspectsGrahaDrishtiSubtitle => 'ആർ ആരെ വീക്ഷിക്കുന്നു (%)';

  @override
  String get aspectsLagnaReceivedTitle => 'ലഗ്നത്തിന് ലഭിച്ച ദൃഷ്ടികൾ';

  @override
  String get aspectsRashiDrishtiTitle => 'രാശി ദൃഷ്ടി (രാശി വീക്ഷണങ്ങൾ)';

  @override
  String get ashtakavargaSavTitle => 'സർവ്വ അഷ്ടകവർഗ്ഗം (SAV)';

  @override
  String ashtakavargaSavSubtitle(String total, String average) {
    return 'ആകെ: ${total} രേഖകൾ (ശരാശരി രാശി = ${average})';
  }

  @override
  String ashtakavargaPlanetBavTitle(String planet) {
    return '${planet} — BAV';
  }

  @override
  String ashtakavargaPlanetBavSubtitle(String total, String natalScore) {
    return 'ആകെ: ${total} രേഖകൾ • ജനന രാശിയിൽ: ${natalScore}';
  }

  @override
  String get appName => 'നക്ഷത്രലോജി ആസ്ട്രോ';

  @override
  String get astrologerPanel => 'ജ്യോതിഷ പാനല്‍';

  @override
  String get home => 'ഹോം';

  @override
  String get dashboard => 'ഡാഷ്‌ബോര്‍ഡ്';

  @override
  String get charts => 'ജാതകങ്ങള്‍';

  @override
  String get bookings => 'ബുക്കിംഗുകള്‍';

  @override
  String get requests => 'അഭ്യര്‍ത്ഥനകള്‍';

  @override
  String get chats => 'ചാറ്റുകള്‍';

  @override
  String get earnings => 'വരുമാനം';

  @override
  String get profile => 'പ്രൊഫൈല്‍';

  @override
  String get live => 'ലൈവ്';

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
  String get fullName => 'പൂര്‍ണ്ണ നാമം';

  @override
  String get phone => 'ഫോണ്‍ (ഐച്ഛികം)';

  @override
  String get forgotPassword => 'പാസ്‌വേഡ് മറന്നോ?';

  @override
  String get yogaHelpful => 'Helpful';

  @override
  String get yogaInactive => 'Inactive';

  @override
  String get yogaTabMoney => 'Money';

  @override
  String get yogaTabRare => 'Rare';

  @override
  String get yogaSummaryTitle => 'Yoga Summary';

  @override
  String get yogaActiveYogas => 'Active Yogas';

  @override
  String get yogaTotalYogas => 'Total Yogas';

  @override
  String get yogaMostPowerful => 'Most Powerful';

  @override
  String get yogaFortuneRating => 'Overall Fortune';

  @override
  String get yogaBenefits => 'Benefits';

  @override
  String get yogaSupportingPlanets => 'Supporting Planets';

  @override
  String get yogaRanking => 'Top 5 Strongest Yogas';

  @override
  String get yogaExplain => 'Explain My Yogas';

  @override
  String get yogaExplainSubtitle => 'How your yogas support you';

  @override
  String get yogaNoneActive => 'No active yogas yet';

  @override
  String get yogaNoneInCategory => 'No yogas in this category';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return 'Your chart carries ${count} active yogas — supportive planetary combinations. Combinations involving ${planets} create especially helpful influences for growth and success.';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '${name} supports ${areas}, and its benefits grow when its planets are active in dasha or transit.';
  }

  @override
  String get yogaAiGeneric => 'This yoga is a supportive combination in your chart that strengthens its related areas of life.';

  @override
  String get yogaExplainReassure => 'Yogas are the bright spots of your chart — helpful planetary combinations working in your favour. The stronger ones deliver lasting benefits, especially during the periods of the planets that form them.';

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
  String get minSixChars => 'കുറഞ്ഞത് 6 അക്ഷരങ്ങള്‍';

  @override
  String get passwordsMismatch => 'പാസ്‌വേഡുകള്‍ പൊരുത്തപ്പെടുന്നില്ല';

  @override
  String get validEmailRequired => 'സാധുവായ ഇമെയില്‍ ആവശ്യമാണ്';

  @override
  String get loginFailed => 'ലോഗിന്‍ പരാജയപ്പെട്ടു';

  @override
  String get signupFailed => 'സൈനപ്പ് പരാജയപ്പെട്ടു';

  @override
  String get todaysEarning => 'ഇന്നത്തെ വരുമാനം';

  @override
  String get walletBalance => 'വാലറ്റ്';

  @override
  String get rating => 'റേറ്റിംഗ്';

  @override
  String get totalSessions => 'സെഷനുകള്‍';

  @override
  String get consultations => 'കൂടിയാലോചനകള്‍';

  @override
  String get response => 'പ്രതികരണം';

  @override
  String get online => 'ഓണ്‍ലൈന്‍';

  @override
  String get offline => 'ഓഫ്‌ലൈന്‍';

  @override
  String get busy => 'തിരക്കിലാണ്';

  @override
  String get goLive => 'ലൈവിലേക്ക് പോകുക';

  @override
  String get streamTitle => 'സ്ട്രീം ശീര്‍ഷകം';

  @override
  String get description => 'വിവരണം (ഐച്ഛികം)';

  @override
  String get start => 'ആരംഭിക്കുക';

  @override
  String get rashiPredictions => 'രാശി ഫലങ്ങള്‍';

  @override
  String get todaysGochar => 'ഇന്നത്തെ ഗോചരം എല്ലാ 12 രാശികള്‍ക്കും — വിശദാംശങ്ങള്‍ക്ക് ടാപ്പ് ചെയ്യുക';

  @override
  String get recentRequests => 'സമീപകാല അഭ്യര്‍ത്ഥനകള്‍';

  @override
  String get noRecentRequests => 'സമീപകാല അഭ്യര്‍ത്ഥനകള്‍ ഇല്ല';

  @override
  String get upcoming => 'വരാനിരിക്കുന്നത്';

  @override
  String get viewAll => 'എല്ലാം കാണുക';

  @override
  String get pending => 'തീര്‍പ്പുകല്‍പ്പിക്കാത്തത്';

  @override
  String get accepted => 'അംഗീകരിച്ചു';

  @override
  String get completed => 'പൂര്‍ത്തിയായി';

  @override
  String get declined => 'നിരസിച്ചു';

  @override
  String get clientCharts => 'ക്ലയന്റ് ജാതകങ്ങള്‍';

  @override
  String get newChart => 'പുതിയ ജാതകം';

  @override
  String get noChartsCreated => 'ഇതുവരെ ജാതകം സൃഷ്ടിച്ചിട്ടില്ല';

  @override
  String get newClientChart => 'പുതിയ ക്ലയന്റ് ജാതകം';

  @override
  String get clientBirthDetails => 'ക്ലയന്റ് ജനന വിവരങ്ങള്‍';

  @override
  String get clientName => 'ക്ലയന്റിന്റെ പേര്';

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
  String get clientChartCreated => 'ക്ലയന്റ് ജാതകം സൃഷ്ടിച്ചു!';

  @override
  String get viewKundli => 'കുണ്ഡലി കാണുക';

  @override
  String get deleteChart => 'ജാതകം ഇല്ലാതാക്കണോ?';

  @override
  String get completeBirthChart => 'പൂര്‍ണ്ണ ജനന ജാതകം';

  @override
  String get birthDetails => 'ജനന വിവരങ്ങള്‍';

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
  String get kundli => 'കുണ്ഡലി';

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
  String get ashtakavarga => 'അഷ്ടകവര്‍ഗ്ഗം';

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
  String get thisMonth => 'ഈ മാസം';

  @override
  String get statement => 'സ്റ്റേറ്റ്‌മെന്റ്';

  @override
  String get all => 'എല്ലാം';

  @override
  String get credits => 'ക്രെഡിറ്റുകള്‍';

  @override
  String get withdrawals => 'പിന്‍വലിക്കലുകള്‍';

  @override
  String get bonus => 'ബോണസ്';

  @override
  String get refunds => 'റീഫണ്ടുകള്‍';

  @override
  String get requestWithdrawal => 'പിന്‍വലിക്കല്‍ അഭ്യര്‍ത്ഥന';

  @override
  String get withdraw => 'പിന്‍വലിക്കുക';

  @override
  String get amount => 'തുക';

  @override
  String get upiId => 'UPI ID';

  @override
  String get bankTransfer => 'ബാങ്ക് ട്രാന്‍സ്ഫര്‍';

  @override
  String get accountHolderName => 'അക്കൗണ്ട് ഉടമയുടെ പേര്';

  @override
  String get accountNumber => 'അക്കൗണ്ട് നമ്പര്‍';

  @override
  String get ifscCode => 'IFSC കോഡ്';

  @override
  String get submit => 'സമര്‍പ്പിക്കുക';

  @override
  String get noTransactions => 'ഇടപാടുകള്‍ ഇല്ല';

  @override
  String get withdrawalHistory => 'പിന്‍വലിക്കല്‍ ചരിത്രം';

  @override
  String get typeGuidance => 'നിങ്ങളുടെ മാര്‍ഗ്ഗനിര്‍ദ്ദേശം ടൈപ്പ് ചെയ്യുക...';

  @override
  String get sessionEnded => 'സെഷന്‍ അവസാനിച്ചു';

  @override
  String get endChat => 'ചാറ്റ് അവസാനിപ്പിക്കണോ?';

  @override
  String get endChatConfirm => 'ഈ സെഷന്‍ അവസാനിപ്പിക്കണമെന്ന് ഉറപ്പാണോ?';

  @override
  String get activeNow => 'ഇപ്പോള്‍ സജീവം';

  @override
  String get connecting => 'കണക്റ്റ് ചെയ്യുന്നു...';

  @override
  String get clientKundli => 'ക്ലയന്റ് കുണ്ഡലി';

  @override
  String get earned => 'സമ്പാദ്യം';

  @override
  String get connected => 'കണക്റ്റ് ആയി';

  @override
  String get endCall => 'കോള്‍ അവസാനിപ്പിക്കുക';

  @override
  String get endStream => 'സ്ട്രീം അവസാനിപ്പിക്കുക';

  @override
  String get endStreamConfirm => 'ലൈവ് സ്ട്രീം അവസാനിപ്പിക്കണോ?';

  @override
  String get goLiveBtn => 'ലൈവിലേക്ക് പോകുക';

  @override
  String get viewers => 'കാണികള്‍';

  @override
  String get peak => 'പരമാവധി';

  @override
  String get gifts => 'സമ്മാനങ്ങള്‍';

  @override
  String get ok => 'ശരി';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get save => 'സേവ് ചെയ്യുക';

  @override
  String get edit => 'എഡിറ്റ് ചെയ്യുക';

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
  String get logout => 'ലോഗൗട്ട്';

  @override
  String get selectLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get language => 'ഭാഷ';

  @override
  String get english => 'ഇംഗ്ലീഷ്';

  @override
  String get kycSubmit => 'KYC സമര്‍പ്പിക്കുക';

  @override
  String get kycPending => 'KYC പരിശോധനയിലാണ്';

  @override
  String get kycRejected => 'KYC നിരസിക്കപ്പെട്ടു';

  @override
  String get notifications => 'അറിയിപ്പുകൾ';

  @override
  String get biometricLogin => 'ബയോമെട്രിക് ലോഗിൻ';

  @override
  String get editProfile => 'പ്രൊഫൈൽ എഡിറ്റ് ചെയ്യുക';

  @override
  String get totalCredit => 'ആകെ ക്രെഡിറ്റ്';

  @override
  String get totalDebit => 'ആകെ ഡെബിറ്റ്';

  @override
  String get allTypes => 'എല്ലാ തരങ്ങളും';

  @override
  String get prev => 'മുമ്പത്തെ';

  @override
  String get next => 'അടുത്തത്';

  @override
  String get page => 'പേജ്';

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
  String get deptReports => 'വിഭാഗ റിപ്പോർട്ടുകൾ';

  @override
  String get specialistAnalysesDesc => '15 വിദഗ്ദ്ധ വിശകലനങ്ങൾ — കരിയർ, സമ്പത്ത്, ആരോഗ്യം, പ്രണയം തുടങ്ങിയവ';

  @override
  String get matchTwoChartsDesc => 'രണ്ട് ജാതകങ്ങൾ ഒത്തുനോക്കുക — അഷ്ടകൂട്, നവാംശ, ഗോചര സമയം തുടങ്ങിയവ';

  @override
  String get todaysForecast => 'ഇന്നത്തെ പ്രവചനം';

  @override
  String get dailyProbability => 'ഏത് ജാതകത്തിനും ദൈനംദിന സാധ്യതാ പ്രവചനം';

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
  String get decline => 'നിരസിക്കുക';

  @override
  String get accept => 'സ്വീകരിക്കുക';

  @override
  String get endSession => 'സെഷൻ അവസാനിപ്പിക്കുക';

  @override
  String get enterChat => 'ചാറ്റിൽ പ്രവേശിക്കുക';

  @override
  String get inProgress => 'പുരോഗതിയിൽ';

  @override
  String get requestDeclined => 'അഭ്യർത്ഥന നിരസിച്ചു';

  @override
  String get noRequests => 'അഭ്യർത്ഥനകളില്ല';

  @override
  String get tapViewChat => 'ചാറ്റ് ചരിത്രം കാണാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get tapViewCall => 'കോൾ വിശദാംശങ്ങൾ കാണാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get consultation => 'കൺസൾട്ടേഷൻ';

  @override
  String get charged => 'ചാർജ്';

  @override
  String get messages => 'സന്ദേശങ്ങൾ';

  @override
  String get duration => 'കാലാവധി';

  @override
  String get rate => 'നിരക്ക്';

  @override
  String get callDetails => 'കോൾ വിശദാംശങ്ങൾ';

  @override
  String get yourEarning => 'നിങ്ങളുടെ സമ്പാദ്യം';

  @override
  String get totalCharged => 'ആകെ ചാർജ്';

  @override
  String get activeDoshas => 'സജീവ ദോഷങ്ങൾ';

  @override
  String get activeYogas => 'സജീവ യോഗങ്ങൾ';

  @override
  String get allDoshas => 'എല്ലാ ദോഷങ്ങളും';

  @override
  String get areasToNurture => 'പരിപോഷിപ്പിക്കേണ്ട മേഖലകൾ';

  @override
  String get basedOnPlanetStrengths => 'ഗ്രഹ ബലങ്ങൾ അടിസ്ഥാനമാക്കി';

  @override
  String get basedOnTransits => 'നിലവിലെ ഗോചരങ്ങൾ അടിസ്ഥാനമാക്കി';

  @override
  String get basis => 'അടിസ്ഥാനം';

  @override
  String get beneficAspects => 'ശുഭ ദൃഷ്ടികൾ';

  @override
  String get bestWindows => 'മികച്ച കാലയളവുകൾ';

  @override
  String get bhakootAxis => 'ഭകൂട് അക്ഷം';

  @override
  String get cancellation => 'റദ്ദാക്കൽ';

  @override
  String get cancellationFactors => 'റദ്ദാക്കൽ ഘടകങ്ങൾ';

  @override
  String get cancellations => 'റദ്ദാക്കലുകൾ';

  @override
  String get challengingPeriods => 'വെല്ലുവിളി കാലയളവുകൾ';

  @override
  String get characterOverview => 'സ്വഭാവ അവലോകനം';

  @override
  String get combinedFertility => 'സംയുക്ത പ്രത്യുൽപാദനശേഷി';

  @override
  String get combust => 'അസ്തംഗതം';

  @override
  String get confidence => 'വിശ്വാസ്യത';

  @override
  String get contact => 'ബന്ധപ്പെടുക';

  @override
  String get copy => 'പകർത്തുക';

  @override
  String get currentPlanetPositions => 'നിലവിലെ ഗ്രഹ സ്ഥാനങ്ങൾ';

  @override
  String get d7Saptamsa => 'D7 സപ്തമാംശം';

  @override
  String get dashaSync => 'ദശ സമന്വയം';

  @override
  String get daughter => 'മകൾ';

  @override
  String get debilitated => 'നീചം';

  @override
  String get detailedSummary => 'വിശദമായ സംഗ്രഹം';

  @override
  String get discussWithAI => 'AI-യുമായി ചർച്ച ചെയ്യുക';

  @override
  String get dominantPlanet => 'പ്രബല ഗ്രഹം';

  @override
  String get effect => 'ഫലം';

  @override
  String get exalted => 'ഉച്ചം';

  @override
  String get factors => 'ഘടകങ്ങൾ';

  @override
  String get favorablePeriodAdvice => 'അനുകൂല കാലയളവ്';

  @override
  String get favorablePeriods => 'അനുകൂല കാലയളവുകൾ';

  @override
  String get genderExplanation => 'ലിംഗ വിശദീകരണം';

  @override
  String get genderTendency => 'ലിംഗ പ്രവണത';

  @override
  String get grantPermissions => 'അനുമതികൾ നൽകുക';

  @override
  String get health => 'മൊത്തം ആരോഗ്യം';

  @override
  String get herMoon => 'അവളുടെ ചന്ദ്രൻ';

  @override
  String get hisMoon => 'അവന്റെ ചന്ദ്രൻ';

  @override
  String get house => 'ഭാവം';

  @override
  String get inFifth => '5-ൽ';

  @override
  String get ketuContacts => 'കേതു സമ്പർക്കങ്ങൾ';

  @override
  String get key => 'കീ';

  @override
  String get keyHouses => 'പ്രധാന ഭാവങ്ങൾ';

  @override
  String get keyInsights => 'പ്രധാന ഉൾക്കാഴ്ചകൾ';

  @override
  String get keyPlanets => 'പ്രധാന ഗ്രഹങ്ങൾ';

  @override
  String get kundliMilan => 'കുണ്ഡലി മിലൻ';

  @override
  String get lifeAreaPredictions => 'ജീവിത മേഖലാ പ്രവചനങ്ങൾ';

  @override
  String get maleficAspects => 'പാപ ദൃഷ്ടികൾ';

  @override
  String get manifestation => 'പ്രകടനം';

  @override
  String get milan => 'മിലൻ';

  @override
  String get mitigation => 'ലഘൂകരണം';

  @override
  String get moonSignCompat => 'ചന്ദ്ര രാശി പൊരുത്തം';

  @override
  String get nakshatraCompat => 'നക്ഷത്ര പൊരുത്തം';

  @override
  String get navigation => 'നാവിഗേഷൻ';

  @override
  String get nextFavorableWindow => 'അടുത്ത അനുകൂല കാലയളവ്';

  @override
  String get noCharts => 'ചാർട്ടുകളില്ല';

  @override
  String get noClassicalYogas => 'സ്ഥിരമായ പ്രയത്നത്തിലൂടെ വിജയം വരുന്നു.';

  @override
  String get noYogasActive => 'ഈ ചാർട്ടിൽ സജീവ യോഗങ്ങളില്ല.';

  @override
  String get notesSaved => 'കുറിപ്പുകൾ സേവ് ചെയ്തു';

  @override
  String get numberExplanation => 'സംഖ്യാ വിശദീകരണം';

  @override
  String get occupants => 'സ്ഥിതി ചെയ്യുന്ന ഗ്രഹങ്ങൾ';

  @override
  String get overallVerdict => 'മൊത്തം വിധി';

  @override
  String get overlappingWindows => 'ഓവർലാപ്പിംഗ് വിവാഹ കാലയളവുകൾ';

  @override
  String get past => 'കഴിഞ്ഞത്';

  @override
  String get pastLifeIndication => 'പൂർവ്വജന്മ സൂചന';

  @override
  String get planet => 'ഗ്രഹം';

  @override
  String get planetPositions => 'ഗ്രഹ സ്ഥാനങ്ങൾ';

  @override
  String get potentialStrengths => 'സാധ്യതയുള്ള ശക്തികൾ';

  @override
  String get primaryArchetype => 'പ്രാഥമിക ആർക്കിടൈപ്പ്';

  @override
  String get probableNumber => 'സാധ്യതയുള്ള സംഖ്യ';

  @override
  String get rahuContacts => 'രാഹു സമ്പർക്കങ്ങൾ';

  @override
  String get rashi => 'രാശി പ്രവചനങ്ങൾ';

  @override
  String get recommendations => 'ശുപാർശകൾ';

  @override
  String get relationshipGuidance => 'ബന്ധ മാർഗ്ഗനിർദ്ദേശം';

  @override
  String get remedies => 'പരിഹാരം';

  @override
  String get retrograde => 'വക്രം';

  @override
  String get ruledBy => 'അധിപൻ';

  @override
  String get running => 'പ്രവർത്തിക്കുന്നു';

  @override
  String get scoreComponents => 'സ്കോർ ഘടകങ്ങൾ';

  @override
  String get selectChartsForMilan => '2 ചാർട്ടുകൾ തിരഞ്ഞെടുക്കുക';

  @override
  String get selectMultiCharts => 'ചാർട്ടുകൾ തിരഞ്ഞെടുക്കുക';

  @override
  String get selectTwoCharts => 'പൊരുത്തത്തിനായി 2 ചാർട്ടുകൾ തിരഞ്ഞെടുക്കുക';

  @override
  String get sign => 'രാശി';

  @override
  String get son => 'മകൻ';

  @override
  String get soulCareerAlign => 'ആത്മാവ് ↔ കരിയർ വിന്യാസം';

  @override
  String get startKundliMilan => 'കുണ്ഡലി മിലൻ ആരംഭിക്കുക';

  @override
  String get startSession => 'സെഷൻ ആരംഭിക്കുക';

  @override
  String get strength => 'ബലം';

  @override
  String get strengths => 'ശക്തികൾ';

  @override
  String get todaysTransitChart => 'ഗോചര ചാർട്ട്';

  @override
  String get topActiveDoshas => 'മുഖ്യ സജീവ ദോഷങ്ങൾ';

  @override
  String get topOpportunities => 'മുഖ്യ മേഖലകൾ';

  @override
  String get topRisks => 'മുഖ്യ സാധ്യതാ ദോഷങ്ങൾ';

  @override
  String get totalChallengePenalty => 'ആകെ വെല്ലുവിളി പിഴ';

  @override
  String get totalDoshaPenalty => 'ആകെ ദോഷ പിഴ';

  @override
  String get transitMarriageWindows => 'ഗോചര വിവാഹ കാലയളവുകൾ';

  @override
  String get value => 'മൂല്യം';

  @override
  String get vargottama => 'വർഗ്ഗോത്തമം';

  @override
  String get venusContacts => 'ശുക്ര സമ്പർക്കങ്ങൾ';

  @override
  String get weaknesses => 'ദൗർബല്യങ്ങൾ';

  @override
  String get worstWindows => 'മോശം കാലയളവുകൾ';

  @override
  String get yogaAnalysis => 'യോഗ വിശകലനം';

  @override
  String get unlocked => 'അൺലോക്ക് ചെയ്തു!';

  @override
  String get lessThanOneMin => '1 മിനിറ്റിൽ താഴെ ബാക്കി';
}
