// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

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
  String get sbLegendary => 'ಅಸಾಧಾರಣ';

  @override
  String get sbSthana => 'ಸ್ಥಾನ ಬಲ';

  @override
  String get sbDig => 'ದಿಕ್ ಬಲ';

  @override
  String get sbKala => 'ಕಾಲ ಬಲ';

  @override
  String get sbChesta => 'ಚೇಷ್ಟಾ ಬಲ';

  @override
  String get sbNaisargika => 'ನೈಸರ್ಗಿಕ ಬಲ';

  @override
  String get sbDrik => 'ದೃಕ್ ಬಲ';

  @override
  String get sbSummary => 'ಗ್ರಹ ಬಲ ಸಾರಾಂಶ';

  @override
  String get sbAverageStrength => 'ಸರಾಸರಿ ಬಲ';

  @override
  String get sbHighestRupa => 'ಅತ್ಯಧಿಕ ರೂಪ';

  @override
  String get sbRupa => 'ರೂಪ';

  @override
  String get sbRanking => 'ಗ್ರಹ ಶ್ರೇಣಿ';

  @override
  String get sbRequired => 'ಅಗತ್ಯ';

  @override
  String get sbExcess => 'ಹೆಚ್ಚುವರಿ';

  @override
  String get sbDeficit => 'ಕೊರತೆ';

  @override
  String get sbTotalShadbala => 'ಒಟ್ಟು ಷಡ್ಬಲ';

  @override
  String get sbExplain => 'ನನ್ನ ಗ್ರಹ ಬಲವನ್ನು ವಿವರಿಸಿ';

  @override
  String get sbExplainSubtitle => 'ನಿಮ್ಮ ಗ್ರಹಗಳ ಬಲದ ಸರಳ ಸಾರಾಂಶ';

  @override
  String get sbInfoTitle => 'ಷಡ್ಬಲವನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳುವುದು';

  @override
  String get sbQWhatIs => 'ಷಡ್ಬಲ ಎಂದರೇನು?';

  @override
  String get sbQRupas => 'ರೂಪಗಳು ಎಂದರೇನು?';

  @override
  String get sbQHowCalc => 'ಬಲವನ್ನು ಹೇಗೆ ಲೆಕ್ಕಹಾಕಲಾಗುತ್ತದೆ?';

  @override
  String get sbQHowUse => 'ಇದನ್ನು ಹೇಗೆ ಬಳಸುವುದು';

  @override
  String get sbWhyStrong => 'ಏಕೆ ಬಲಶಾಲಿ';

  @override
  String get sbWhyWeak => 'ಏಕೆ ದುರ್ಬಲ';

  @override
  String get sbDuringMahadasha => 'ಮಹಾದಶಾ ಸಮಯದಲ್ಲಿ';

  @override
  String get sbEffects => 'ಪರಿಣಾಮಗಳು';

  @override
  String get sbLifeAreas => 'ಜೀವನ ಕ್ಷೇತ್ರಗಳು';

  @override
  String get sbPlanetDetails => 'ಗ್ರಹ ವಿವರಗಳು';

  @override
  String get sbBodyWhatIs => 'ಷಡ್ಬಲ (\'ಆರು ಪಟ್ಟು ಬಲ\') ಪ್ರತಿ ಗ್ರಹ ತನ್ನ ಫಲಿತಾಂಶಗಳನ್ನು ನೀಡಲು ಎಷ್ಟು ಶಕ್ತಿಯನ್ನು ಹೊಂದಿದೆ ಎಂಬುದನ್ನು, ಆರು ಸ್ವತಂತ್ರ ಬಲ ಮೂಲಗಳನ್ನು ಸೇರಿಸುವ ಮೂಲಕ ಅಳೆಯುತ್ತದೆ.';

  @override
  String get sbBodyRupas => 'ಬಲವನ್ನು ರೂಪಗಳಲ್ಲಿ ಅಳೆಯಲಾಗುತ್ತದೆ (1 ರೂಪ = 60 ವಿರೂಪ). ಪ್ರತಿ ಗ್ರಹಕ್ಕೆ ಬಲಶಾಲಿ ಎಂದು ಪರಿಗಣಿಸಲು ಕನಿಷ್ಠ ರೂಪ ಬಲ ಬೇಕಾಗುತ್ತದೆ; ಹೆಚ್ಚು ರೂಪಗಳು ಎಂದರೆ ಅದು ತನ್ನ ಫಲಿತಾಂಶಗಳನ್ನು ಇನ್ನಷ್ಟು ಪೂರ್ಣವಾಗಿ ನೀಡುತ್ತದೆ ಎಂದರ್ಥ.';

  @override
  String get sbBodyHowCalc => 'ಆರು ಬಲಗಳನ್ನು ಸೇರಿಸಲಾಗುತ್ತದೆ: ಸ್ಥಾನ (ಸ್ಥಾನಿಕ), ದಿಕ್ (ದಿಕ್ಕಿನ), ಕಾಲ (ಕಾಲಿಕ), ಚೇಷ್ಟಾ (ಚಲನೆಯ), ನೈಸರ್ಗಿಕ (ಸಹಜ) ಮತ್ತು ದೃಕ್ (ದೃಷ್ಟಿಯ). ಒಟ್ಟು ಮೊತ್ತವನ್ನು ಗ್ರಹದ ಅಗತ್ಯ ಕನಿಷ್ಠದೊಂದಿಗೆ ಹೋಲಿಸಿ ಶೇಕಡಾವಾರು ಪಡೆಯಲಾಗುತ್ತದೆ.';

  @override
  String get sbBodyHowUse => '100%ಕ್ಕಿಂತ ಹೆಚ್ಚಿನ ಗ್ರಹ ತನ್ನ ಫಲಗಳನ್ನು ಆರಾಮವಾಗಿ ನೀಡುತ್ತದೆ; 100%ಕ್ಕಿಂತ ಕಡಿಮೆ ಇದ್ದರೆ ಬೆಂಬಲ ಬೇಕಾಗುತ್ತದೆ. ಪ್ರಮುಖ ವಿಷಯಗಳಿಗೆ ನಿಮ್ಮ ಪ್ರಬಲ ಗ್ರಹಗಳಿಗೆ ಆದ್ಯತೆ ನೀಡಿ, ದುರ್ಬಲವಾದವುಗಳಿಗೆ ಪರಿಹಾರಗಳು ಮತ್ತು ತಾಳ್ಮೆ ನೀಡಿ.';

  @override
  String get sbRemedyStrong => 'ಚೆನ್ನಾಗಿ ಬೆಂಬಲಿತವಾಗಿದೆ — ವಿಶೇಷ ಪರಿಹಾರ ಅಗತ್ಯವಿಲ್ಲ; ಈ ಗ್ರಹದ ಅವಧಿಗಳನ್ನು ನೀವು ವಿಶ್ವಾಸದಿಂದ ಬಳಸಬಹುದು.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '${strongP} ನಿಮ್ಮ ಪ್ರಬಲ ಗ್ರಹ, ${strongTrait}ಗೆ ಅತ್ಯುತ್ತಮ ಬೆಂಬಲ ನೀಡುತ್ತದೆ. ${weakP} ಅತ್ಯಂತ ದುರ್ಬಲವಾಗಿದೆ ಮತ್ತು ಪರಿಹಾರಗಳಿಂದ ಹೆಚ್ಚು ಪ್ರಯೋಜನ ಪಡೆಯುತ್ತದೆ.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '${planet} ಗೆ ${category} ಷಡ್ಬಲ ಇದೆ, ಆದ್ದರಿಂದ ಅದರ ${karakatva} ಅದಕ್ಕೆ ಅನುಗುಣವಾಗಿ ಬೆಂಬಲಿತವಾಗಿವೆ.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return '${bala} ಮೂಲಕ ಅತ್ಯಂತ ಬಲಶಾಲಿ (${rupa} ರೂಪಗಳು).';
  }

  @override
  String sbWeakLine(Object bala) {
    return '${bala}ದಲ್ಲಿ ಅತ್ಯಂತ ದುರ್ಬಲ, ಇದು ಒಟ್ಟು ಮೊತ್ತವನ್ನು ಕಡಿಮೆ ಮಾಡುತ್ತದೆ.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return '${planet} ಯ ಮಹಾದಶಾ ಸಮಯದಲ್ಲಿ, ಅದರ ${karak} ಮುನ್ನೆಲೆಗೆ ಬರುತ್ತವೆ.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'ಬಲಶಾಲಿ ಷಡ್ಬಲದೊಂದಿಗೆ, ${karak} ಸಹಜವಾಗಿ ಬೆಂಬಲಿತವಾಗಿವೆ.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'ಸಾಧಾರಣ ಷಡ್ಬಲದೊಂದಿಗೆ, ${karak}ಗೆ ಪ್ರಜ್ಞಾಪೂರ್ವಕ ಪ್ರಯತ್ನ ಬೇಕಾಗಬಹುದು.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return '${planet} ಅನ್ನು ಅದರ ಮಂತ್ರ, ರತ್ನ ಅಥವಾ ದಾನದ ಮೂಲಕ ಬಲಪಡಿಸಿ, ಮತ್ತು ಅದರ ಅವಧಿಗಳಲ್ಲಿ ತಾಳ್ಮೆಯಿಂದ ವರ್ತಿಸಿ.';
  }

  @override
  String get bhOverview => 'ಅವಲೋಕನ';

  @override
  String get bhDetailed => 'ವಿವರವಾದ';

  @override
  String get bhavaHouses => 'ಭಾವಗಳು';

  @override
  String get bhStrengthOverview => 'ಭಾವ ಶಕ್ತಿ ಅವಲೋಕನ';

  @override
  String get bhOverallAverage => 'ಒಟ್ಟಾರೆ ಭಾವ ಸರಾಸರಿ';

  @override
  String get bhStrongestHouse => 'ಅತ್ಯಂತ ಪ್ರಬಲ ಭಾವ';

  @override
  String get bhWeakestHouse => 'ಅತ್ಯಂತ ದುರ್ಬಲ ಭಾವ';

  @override
  String get bhBestArea => 'ಅತ್ಯುತ್ತಮ ಜೀವನ ಕ್ಷೇತ್ರ';

  @override
  String get bhNeedsAttention => 'ಗಮನ ಅಗತ್ಯ';

  @override
  String get bhSavContribution => 'SAV ಕೊಡುಗೆ';

  @override
  String get bhLordCondition => 'ಭಾವಾಧಿಪತಿಯ ಸ್ಥಿತಿ';

  @override
  String get bhBenefic => 'ಶುಭ ಪ್ರಭಾವ';

  @override
  String get bhMalefic => 'ಪಾಪ ಪ್ರಭಾವ';

  @override
  String get bhStrengthReasons => 'ಈ ಸ್ಕೋರ್ ಏಕೆ';

  @override
  String get bhGoodEffects => 'ಒಳ್ಳೆಯ ಪರಿಣಾಮಗಳು';

  @override
  String get bhChallenges => 'ಸವಾಲುಗಳು';

  @override
  String get bhRemedies => 'ಪರಿಹಾರಗಳು';

  @override
  String get bhRanking => 'ಭಾವ ಶ್ರೇಣಿ';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'ನನ್ನ ಭಾವಗಳನ್ನು ವಿವರಿಸಿ';

  @override
  String get bhExplainSubtitle => 'ನಿಮ್ಮ 12 ಭಾವಗಳ ಸರಳ ಸಾರಾಂಶ';

  @override
  String bhHeroSummary(Object s1, Object s2, Object strongArea, Object weakArea) {
    return 'ನಿಮ್ಮ ಅತ್ಯಂತ ಪ್ರಬಲ ಭಾವಗಳು ${s1} ಮತ್ತು ${s2}. ${strongArea} ಸಹಜವಾಗಿ ಬಲಶಾಲಿಯಾಗಿದೆ, ಆದರೆ ${weakArea}ಗೆ ಹೆಚ್ಚಿನ ಪ್ರಯತ್ನ ಬೇಕಾಗುತ್ತದೆ.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'ಇದರ ಅಧಿಪತಿ ${lord} ${relation} ಆಗಿ ಇರಿಸಲ್ಪಟ್ಟಿದ್ದಾರೆ.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'ಈ ಭಾವದಲ್ಲಿ ${sav} ಶುಭ ಅಂಕಗಳು (SAV) ಇವೆ; ಇದರಲ್ಲಿರುವ ಗ್ರಹಗಳು ಮತ್ತು ದೃಷ್ಟಿಗಳು ಉಳಿದ ಸ್ಕೋರ್ ಅನ್ನು ನಿರ್ಧರಿಸುತ್ತವೆ.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'ಬಲಶಾಲಿಯಾಗಿದ್ದಾಗ, ಇದು ${meaning} ಅನ್ನು ಬೆಂಬಲಿಸುತ್ತದೆ.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'ದುರ್ಬಲವಾಗಿದ್ದಾಗ, ${meaning}ಗೆ ಹೆಚ್ಚುವರಿ ಪ್ರಯತ್ನ ಮತ್ತು ಕಾಳಜಿ ಬೇಕಾಗಬಹುದು.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'ಇದನ್ನು ಬಲಪಡಿಸಲು ಇದರ ಅಧಿಪತಿ ${lord} ಅನ್ನು ಬಲಪಡಿಸಿ ಮತ್ತು ಈ ಭಾವದ ವಿಷಯಗಳನ್ನು ಗೌರವಿಸಿ.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'ನಿಮ್ಮ ${house} ${strengthWord} ಆಗಿದೆ. ಇದು ${meaning} ಅನ್ನು ನಿಯಂತ್ರಿಸುತ್ತದೆ.';
  }

  @override
  String get kunNavamsa => 'ನವಾಂಶ (D9)';

  @override
  String get kunD10 => 'ದಶಾಂಶ (D10)';

  @override
  String get kunPlacement => 'ಗ್ರಹ ಸ್ಥಾನ';

  @override
  String get kunHousesTitle => 'ಭಾವ ವಿವರಗಳು';

  @override
  String get kunPlanet => 'ಗ್ರಹ';

  @override
  String get kunNakshatra => 'ನಕ್ಷತ್ರ';

  @override
  String get kunPada => 'ಪಾದ';

  @override
  String get kunLord => 'ಒಡೆಯ';

  @override
  String get kunExplain => 'ನನ್ನ ಜಾತಕವನ್ನು ವಿವರಿಸಿ';

  @override
  String get kunExplainSubtitle => 'ನಿಮ್ಮ ಜಾತಕದ ಸರಳ ಸಾರಾಂಶ';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return '${ordinal} ಭಾವವು ${meaning} ಅನ್ನು ನಿಯಂತ್ರಿಸುತ್ತದೆ.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return 'ಇಲ್ಲಿ ಇರುವ ${planets} ಇದರ ಫಲಿತಾಂಶಗಳನ್ನು ರೂಪಿಸುತ್ತವೆ.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'ನಿಮ್ಮ ಲಗ್ನ ${asc}, ಇದು ನಿಮ್ಮ ದೃಷ್ಟಿಕೋನವನ್ನು ಮತ್ತು ಇತರರು ನಿಮ್ಮನ್ನು ಮೊದಲು ಹೇಗೆ ನೋಡುತ್ತಾರೆ ಎಂಬುದನ್ನು ರೂಪಿಸುತ್ತದೆ.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'ನಿಮ್ಮ ಮನಸ್ಸು ಮತ್ತು ಭಾವನೆಗಳು ${moon}ನಲ್ಲಿರುವ ಚಂದ್ರನನ್ನು ಅನುಸರಿಸುತ್ತವೆ.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '${planet} ನಿಮ್ಮ ಪ್ರಬಲ ಗ್ರಹ — ಸುಲಭ ಮತ್ತು ಬೆಂಬಲದ ಸಹಜ ಕ್ಷೇತ್ರ.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '${planet} ನಿಮ್ಮನ್ನು ಅತ್ಯಂತ ಪರೀಕ್ಷಿಸುವ ಗ್ರಹ — ಇಲ್ಲಿ ತಾಳ್ಮೆ ಮತ್ತು ಪ್ರಯತ್ನ ಫಲ ನೀಡುತ್ತದೆ.';
  }

  @override
  String get plNature => 'ಸ್ವಭಾವ';

  @override
  String get plElement => 'ತತ್ವ';

  @override
  String get plGender => 'ಲಿಂಗ';

  @override
  String get plKarakatva => 'ಕಾರಕತ್ವ';

  @override
  String get plLordship => 'ಅಧಿಪತ್ಯ';

  @override
  String get plStrength => 'ಬಲ';

  @override
  String get plAspectsGiven => 'ನೀಡಿದ ದೃಷ್ಟಿ';

  @override
  String get plAspectsReceived => 'ಪಡೆದ ದೃಷ್ಟಿ';

  @override
  String get plConjunction => 'ಯುತಿ';

  @override
  String get plHouseMeaning => 'ಭಾವದ ಅರ್ಥ';

  @override
  String get plNakshatraMeaning => 'ನಕ್ಷತ್ರದ ಅರ್ಥ';

  @override
  String get plAiInterpretation => 'AI ವಿವರಣೆ';

  @override
  String get plSearchHint => 'ಯಾವುದೇ ಗ್ರಹವನ್ನು ಹುಡುಕಿ';

  @override
  String get plNoResults => 'ಯಾವುದೇ ಗ್ರಹಗಳು ಕಂಡುಬಂದಿಲ್ಲ';

  @override
  String get plBenefic => 'ಶುಭ';

  @override
  String get plMalefic => 'ಪಾಪ';

  @override
  String get plMale => 'ಪುರುಷ';

  @override
  String get plFemale => 'ಸ್ತ್ರೀ';

  @override
  String get plNeutralGender => 'ನಪುಂಸಕ';

  @override
  String get plOwnSign => 'ಸ್ವ ರಾಶಿ';

  @override
  String get plFriend => 'ಮಿತ್ರ ರಾಶಿ';

  @override
  String get plEnemy => 'ಶತ್ರು ರಾಶಿ';

  @override
  String get plNeutral => 'ಸಮ';

  @override
  String get sumEther => 'ಆಕಾಶ';

  @override
  String plLordOfHouses(Object houses) {
    return 'ಭಾವ ${houses}ಕ್ಕೆ ಅಧಿಪತಿ';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return '${nakLord} ಆಳ್ವಿಕೆ ನಡೆಸುತ್ತದೆ, ${trait} ತರುತ್ತದೆ.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '${planet} ${sign} ರಾಶಿಯಲ್ಲಿ, ${house} ಭಾವದಲ್ಲಿ ಇದೆ.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'ಇದರ ಪ್ರಮುಖ ಕಾರಕತ್ವಗಳು — ${karak} — ಇಲ್ಲಿ ಚೆನ್ನಾಗಿ ಬೆಂಬಲಿತವಾಗಿವೆ.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'ಇದರ ಪ್ರಮುಖ ಕಾರಕತ್ವಗಳು — ${karak} — ಇಲ್ಲಿ ಪ್ರಜ್ಞಾಪೂರ್ವಕ ಪ್ರಯತ್ನದ ಅಗತ್ಯವಿರಬಹುದು.';
  }

  @override
  String plAiExalted(Object planet) {
    return '${planet} ಉಚ್ಚ ಸ್ಥಿತಿಯಲ್ಲಿದೆ, ತನ್ನ ಅತ್ಯುತ್ತಮ ಫಲಿತಾಂಶಗಳನ್ನು ನೀಡುತ್ತದೆ.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '${planet} ನೀಚ ಸ್ಥಿತಿಯಲ್ಲಿದೆ ಮತ್ತು ತನ್ನ ಫಲಿತಾಂಶಗಳನ್ನು ನೀಡಲು ಬೆಂಬಲ ಬೇಕಾಗುತ್ತದೆ.';
  }

  @override
  String plAiCombust(Object planet) {
    return '${planet} ಅಸ್ತವಾಗಿದೆ, ಆದ್ದರಿಂದ ಇದು ಸೂರ್ಯನ ತೀಕ್ಷ್ಣತೆಯಲ್ಲಿ ಕಡಿಮೆ ಬಹಿರಂಗವಾಗಿ ಕಾರ್ಯನಿರ್ವಹಿಸುತ್ತದೆ.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '${planet} ವರ್ಗೋತ್ತಮ — ಈ ಬಲವಾದ ಸ್ಥಾನವು ನವಾಂಶದಲ್ಲಿಯೂ ಪುನರಾವರ್ತನೆಯಾಗುತ್ತದೆ.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '${planet} ವಕ್ರವಾಗಿದೆ, ತನ್ನ ಶಕ್ತಿಯನ್ನು ಒಳಮುಖವಾಗಿ ತಿರುಗಿಸಿ ಅದನ್ನು ತೀವ್ರಗೊಳಿಸುತ್ತದೆ.';
  }

  @override
  String get plHouse1 => 'ಸ್ವಂತ, ದೇಹ, ವ್ಯಕ್ತಿತ್ವ ಮತ್ತು ಜೀವಶಕ್ತಿ';

  @override
  String get plHouse2 => 'ಧನ, ಕುಟುಂಬ, ಮಾತು ಮತ್ತು ಆಹಾರ';

  @override
  String get plHouse3 => 'ಧೈರ್ಯ, ಒಡಹುಟ್ಟಿದವರು, ಸಂವಹನ ಮತ್ತು ಚಿಕ್ಕ ಪ್ರಯಾಣಗಳು';

  @override
  String get plHouse4 => 'ಮನೆ, ತಾಯಿ, ಸೌಕರ್ಯ, ಆಸ್ತಿ ಮತ್ತು ಆಂತರಿಕ ಶಾಂತಿ';

  @override
  String get plHouse5 => 'ಮಕ್ಕಳು, ಸೃಜನಶೀಲತೆ, ಬುದ್ಧಿ, ಪ್ರೀತಿ ಮತ್ತು ಪೂರ್ವ ಪುಣ್ಯ';

  @override
  String get plHouse6 => 'ಆರೋಗ್ಯ, ಶತ್ರುಗಳು, ಸಾಲಗಳು, ಸೇವೆ ಮತ್ತು ದೈನಂದಿನ ಕೆಲಸ';

  @override
  String get plHouse7 => 'ವಿವಾಹ, ಪಾಲುದಾರಿಕೆ ಮತ್ತು ವ್ಯಾಪಾರ ಸಂಬಂಧಗಳು';

  @override
  String get plHouse8 => 'ಆಯುಷ್ಯ, ಪರಿವರ್ತನೆ, ರಹಸ್ಯಗಳು ಮತ್ತು ಪಿತ್ರಾರ್ಜಿತ ಆಸ್ತಿ';

  @override
  String get plHouse9 => 'ಅದೃಷ್ಟ, ಧರ್ಮ, ಉನ್ನತ ವಿದ್ಯೆ, ಗುರು ಮತ್ತು ತಂದೆ';

  @override
  String get plHouse10 => 'ವೃತ್ತಿ, ಸ್ಥಾನಮಾನ, ಅಧಿಕಾರ ಮತ್ತು ಸಾರ್ವಜನಿಕ ಕರ್ಮ';

  @override
  String get plHouse11 => 'ಲಾಭಗಳು, ಆದಾಯ, ಸ್ನೇಹಿತರು, ಸಂಪರ್ಕಜಾಲ ಮತ್ತು ಈಡೇರಿದ ಆಸೆಗಳು';

  @override
  String get plHouse12 => 'ನಷ್ಟ, ಖರ್ಚು, ವಿದೇಶ, ಆಧ್ಯಾತ್ಮಿಕತೆ ಮತ್ತು ಮೋಕ್ಷ';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return 'ನಕ್ಷ: ${nakshatra} (${pada})';
  }

  @override
  String planetNakLord(Object lord) {
    return 'NL: ${lord}';
  }

  @override
  String planetLongitude(Object value) {
    return 'ರೇಖಾಂಶ: ${value}°';
  }

  @override
  String get sumVeryStrong => 'ಅತ್ಯಂತ ಬಲಶಾಲಿ';

  @override
  String get sumStrong => 'ಬಲಶಾಲಿ';

  @override
  String get sumAverage => 'ಸರಾಸರಿ';

  @override
  String get sumWeak => 'ದುರ್ಬಲ';

  @override
  String get sumNeedsAttention => 'ಗಮನ ಅಗತ್ಯ';

  @override
  String get sumFire => 'ಅಗ್ನಿ';

  @override
  String get sumEarth => 'ಭೂಮಿ';

  @override
  String get sumAir => 'ವಾಯು';

  @override
  String get sumWater => 'ನೀರು';

  @override
  String get sumMovable => 'ಚರ';

  @override
  String get sumFixed => 'ಸ್ಥಿರ';

  @override
  String get sumDual => 'ದ್ವಿಸ್ವಭಾವ';

  @override
  String get sumDirEast => 'ಪೂರ್ವ';

  @override
  String get sumDirWest => 'ಪಶ್ಚಿಮ';

  @override
  String get sumDirNorth => 'ಉತ್ತರ';

  @override
  String get sumDirSouth => 'ದಕ್ಷಿಣ';

  @override
  String get sumDirNE => 'ಈಶಾನ್ಯ';

  @override
  String get sumDirNW => 'ವಾಯುವ್ಯ';

  @override
  String get sumDirSE => 'ಆಗ್ನೇಯ';

  @override
  String get sumDirSW => 'ನೈಋತ್ಯ';

  @override
  String get sumSnapshotTitle => 'ನಿಮ್ಮ ಜ್ಯೋತಿಷ್ಯ ಸಾರಾಂಶ';

  @override
  String get sumMahadasha => 'ಮಹಾದಶಾ';

  @override
  String get sumAntardasha => 'ಅಂತರ್ದಶಾ';

  @override
  String get sumNakshatra => 'ಜನ್ಮ ನಕ್ಷತ್ರ';

  @override
  String get sumElement => 'ತತ್ವ';

  @override
  String get sumModality => 'ಸ್ವಭಾವ';

  @override
  String get sumLuckyDirection => 'ಶುಭ ದಿಕ್ಕು';

  @override
  String get sumHighlights => 'ಮುಖ್ಯಾಂಶಗಳು';

  @override
  String get sumStrongPlanet => 'ಅತ್ಯಂತ ಬಲಶಾಲಿ ಗ್ರಹ';

  @override
  String get sumWeakPlanet => 'ಅತ್ಯಂತ ದುರ್ಬಲ ಗ್ರಹ';

  @override
  String get sumYogas => 'ಯೋಗಗಳು';

  @override
  String get sumDoshas => 'ದೋಷಗಳು';

  @override
  String get sumRetrograde => 'ವಕ್ರಿ';

  @override
  String get sumCombust => 'ಅಸ್ತಂಗತ';

  @override
  String get sumExalted => 'ಉಚ್ಚ';

  @override
  String get sumDebilitated => 'ನೀಚ';

  @override
  String get sumVargottama => 'ವರ್ಗೋತ್ತಮ';

  @override
  String get sumQuickInsights => 'ತ್ವರಿತ ಮಾಹಿತಿ';

  @override
  String get sumSpirituality => 'ಆಧ್ಯಾತ್ಮಿಕತೆ';

  @override
  String get sumTimezone => 'ಕಾಲ ವಲಯ';

  @override
  String get sumAyanamsa => 'ಅಯನಾಂಶ';

  @override
  String get sumCalendarType => 'ಪಂಚಾಂಗ';

  @override
  String get sumCopied => 'ಕ್ಲಿಪ್‌ಬೋರ್ಡ್‌ಗೆ ನಕಲಿಸಲಾಗಿದೆ';

  @override
  String get sumNatureFire => 'ನಿಮ್ಮಲ್ಲಿ ಧೈರ್ಯಶಾಲಿ, ಶಕ್ತಿಯುತ ಮತ್ತು ಮುಂದಾಳತ್ವ ವಹಿಸುವ ಸ್ವಭಾವವಿದೆ.';

  @override
  String get sumNatureEarth => 'ನಿಮ್ಮಲ್ಲಿ ಪ್ರಾಯೋಗಿಕ, ಸ್ಥಿರ ಮತ್ತು ಶಿಸ್ತುಬದ್ಧ ಸ್ವಭಾವವಿದೆ, ಇದು ಶಾಶ್ವತ ಫಲಿತಾಂಶಗಳನ್ನು ನಿರ್ಮಿಸುತ್ತದೆ.';

  @override
  String get sumNatureAir => 'ನಿಮ್ಮಲ್ಲಿ ಕುತೂಹಲಭರಿತ, ಸಂವಹನಶೀಲ ಮತ್ತು ಬೌದ್ಧಿಕ ಸ್ವಭಾವವಿದೆ, ಇದು ಹೊಸ ಕಲ್ಪನೆಗಳಲ್ಲಿ ಪ್ರವರ್ಧಿಸುತ್ತದೆ.';

  @override
  String get sumNatureWater => 'ನಿಮ್ಮಲ್ಲಿ ಅಂತಃಪ್ರಜ್ಞೆಯುಳ್ಳ, ಭಾವನಾತ್ಮಕ ಮತ್ತು ಸಹಾನುಭೂತಿಯುಳ್ಳ ಸ್ವಭಾವವಿದೆ, ಆಳವಾದ ಆಂತರಿಕ ಸಂವೇದನೆಯೊಂದಿಗೆ.';

  @override
  String get sumGradePhraseExcellent => 'ಬಲವಾಗಿ ಬೆಂಬಲಿತವಾಗಿದೆ — ಸ್ಥಿರ ಪ್ರಯತ್ನದೊಂದಿಗೆ ಅನುಕೂಲಕರ ಫಲಿತಾಂಶಗಳು ಸಿಗುವ ಸಾಧ್ಯತೆಯಿದೆ.';

  @override
  String get sumGradePhraseGood => 'ಚೆನ್ನಾಗಿ ಬೆಂಬಲಿತವಾಗಿದೆ — ಸ್ವಲ್ಪ ಕಾಳಜಿಯೊಂದಿಗೆ ಸಾಮಾನ್ಯವಾಗಿ ಸಕಾರಾತ್ಮಕ.';

  @override
  String get sumGradePhraseAverage => 'ಮಿಶ್ರ ಬೆಂಬಲ — ಫಲಿತಾಂಶಗಳು ಪ್ರಯತ್ನ ಮತ್ತು ಸಮಯವನ್ನು ಅವಲಂಬಿಸಿರುತ್ತವೆ.';

  @override
  String get sumGradePhraseWeak => 'ಗಮನ ಅಗತ್ಯ — ತಾಳ್ಮೆ ಮತ್ತು ಪರಿಹಾರಗಳು ಇಲ್ಲಿ ಸಹಾಯ ಮಾಡುತ್ತವೆ.';

  @override
  String get kDefCombust => 'ಸೂರ್ಯನಿಗೆ ಅತಿ ಹತ್ತಿರವಿರುವ ಗ್ರಹ, ಇದರಿಂದ ಅದರ ಶಕ್ತಿ \'ಸುಟ್ಟು\' ದುರ್ಬಲಗೊಳ್ಳುತ್ತದೆ.';

  @override
  String get kDefRetrograde => 'ಹಿಂದಕ್ಕೆ ಚಲಿಸುವಂತೆ ಕಾಣುವ ಗ್ರಹ; ಇದರ ಪರಿಣಾಮಗಳು ಒಳಮುಖವಾಗಿ ತಿರುಗಿ ತೀವ್ರಗೊಳ್ಳುತ್ತವೆ.';

  @override
  String get kDefNakshatra => 'ಚಂದ್ರ ಮತ್ತು ಗ್ರಹಗಳು ಸಂಚರಿಸುವ 27 ನಕ್ಷತ್ರ ಮಂಡಲಗಳಲ್ಲಿ ಒಂದು.';

  @override
  String get kDefVargottama => 'ಜನ್ಮ ಕುಂಡಲಿ (D1) ಮತ್ತು ನವಾಂಶ (D9) ಎರಡರಲ್ಲೂ ಒಂದೇ ರಾಶಿಯಲ್ಲಿರುವ ಗ್ರಹ — ಬಲದ ಸಂಕೇತ.';

  @override
  String get kDefOwnSign => 'ತಾನು ಆಳುವ ರಾಶಿಯಲ್ಲಿ ಕುಳಿತಿರುವ ಗ್ರಹ, ಅಲ್ಲಿ ಅದು ಮನೆಯಂತೆ ಭಾವಿಸಿ ಸ್ಥಿರ ಫಲಿತಾಂಶಗಳನ್ನು ನೀಡುತ್ತದೆ.';

  @override
  String get kDefExalted => 'ತನ್ನ ಅತ್ಯುನ್ನತ ಬಲದ ರಾಶಿಯಲ್ಲಿರುವ ಗ್ರಹ, ಇದು ತನ್ನ ಅತ್ಯುತ್ತಮ ಫಲಿತಾಂಶಗಳನ್ನು ನೀಡುತ್ತದೆ.';

  @override
  String get kDefDebilitated => 'ತನ್ನ ಅತ್ಯಂತ ದುರ್ಬಲ ರಾಶಿಯಲ್ಲಿರುವ ಗ್ರಹ, ಅಲ್ಲಿ ಅದು ಫಲಿತಾಂಶ ನೀಡಲು ಹೆಣಗಾಡುತ್ತದೆ.';

  @override
  String get kDefMooltrikona => 'ಗ್ರಹದ ಸ್ವಂತ ರಾಶಿಯ ವಿಶೇಷ ಭಾಗ, ಅಲ್ಲಿ ಅದು ವಿಶೇಷವಾಗಿ ಶಕ್ತಿಶಾಲಿಯಾಗಿರುತ್ತದೆ.';

  @override
  String get kDefAscendant => 'ಜನ್ಮ ಸಮಯದಲ್ಲಿ ಪೂರ್ವ ದಿಗಂತದಲ್ಲಿ ಉದಯಿಸುವ ರಾಶಿ — ಲಗ್ನ, ಜಾತಕದ ಅಡಿಪಾಯ.';

  @override
  String get kDefMahadasha => 'ಜೀವನದ ದೀರ್ಘಾವಧಿಗೆ ಬಣ್ಣ ನೀಡುವ ಪ್ರಮುಖ ಗ್ರಹ ಕಾಲಾವಧಿ.';

  @override
  String get kDefAntardasha => 'ಮಹಾದಶೆಯೊಳಗಿನ ಉಪ-ಅವಧಿ, ಇದು ಅದರ ಫಲಿತಾಂಶಗಳನ್ನು ಸೂಕ್ಷ್ಮವಾಗಿ ಹೊಂದಿಸುತ್ತದೆ.';

  @override
  String get kDefPada => 'ಗ್ರಹವು ಇರುವ ನಕ್ಷತ್ರದ ನಾಲ್ಕು ಪಾದಗಳಲ್ಲಿ ಒಂದು.';

  @override
  String get kundliAscendantLagna => 'ಲಗ್ನ (ಅಸೆಂಡೆಂಟ್)';

  @override
  String get kundliMoonSignRashi => 'ಚಂದ್ರ ರಾಶಿ';

  @override
  String get kundliSunSign => 'ಸೂರ್ಯ ರಾಶಿ';

  @override
  String get aspGivesAspectTo => 'ದೃಷ್ಟಿ ನೀಡುತ್ತದೆ';

  @override
  String get aspReceivesAspectFrom => 'ದೃಷ್ಟಿ ಪಡೆಯುತ್ತದೆ';

  @override
  String get aspInfluences => 'ಪ್ರಭಾವ ಬೀರುತ್ತದೆ';

  @override
  String get aspNoInfluence => 'ಯಾವುದೇ ಪ್ರಭಾವವಿಲ್ಲ';

  @override
  String get aspNoAspect => 'ಯಾವುದೇ ದೃಷ್ಟಿ ಇಲ್ಲ';

  @override
  String get aspPresent => 'ಇದೆ';

  @override
  String get aspAbsent => 'ಇಲ್ಲದಿರುವುದು';

  @override
  String get aspNotPresent => 'ಇಲ್ಲ';

  @override
  String get aspSpecialAspect => 'ವಿಶೇಷ ದೃಷ್ಟಿ';

  @override
  String get aspAspectWord => 'ದೃಷ್ಟಿ';

  @override
  String get aspTotalGiven => 'ನೀಡಿದ ದೃಷ್ಟಿಗಳು';

  @override
  String get aspTotalReceived => 'ಪಡೆದ ದೃಷ್ಟಿಗಳು';

  @override
  String get aspStrongestInfluence => 'ಅತ್ಯಂತ ಪ್ರಬಲ ಪ್ರಭಾವ';

  @override
  String get aspMedium => 'ಮಧ್ಯಮ';

  @override
  String get aspAspectPresent => 'ದೃಷ್ಟಿ ಇದೆ';

  @override
  String get aspReason => 'ಕಾರಣ';

  @override
  String get aspBoth => 'ಎರಡೂ';

  @override
  String get aspTargetHouse => 'ಗುರಿ ಭಾವ';

  @override
  String get aspTargetSign => 'ಗುರಿ ರಾಶಿ';

  @override
  String get aspLagnaReceives => 'ಲಗ್ನ ದೃಷ್ಟಿ ಪಡೆಯುವ ಗ್ರಹಗಳು';

  @override
  String get aspNoAspectFrom => 'ಇವುಗಳಿಂದ ಯಾವುದೇ ದೃಷ್ಟಿ ಇಲ್ಲ';

  @override
  String get aspPlanetToPlanet => 'ಗ್ರಹದಿಂದ ಗ್ರಹಕ್ಕೆ';

  @override
  String get aspSignToSign => 'ರಾಶಿಯಿಂದ ರಾಶಿಗೆ';

  @override
  String get aspCombinedAspect => 'ಸಂಯುಕ್ತ ದೃಷ್ಟಿ';

  @override
  String get aspGrahaAspect => 'ಗ್ರಹ ದೃಷ್ಟಿ';

  @override
  String get aspRashiAspect => 'ರಾಶಿ ದೃಷ್ಟಿ';

  @override
  String get aspInfoTitle => 'ದೃಷ್ಟಿ (Drishti) ಅರ್ಥಮಾಡಿಕೊಳ್ಳುವುದು';

  @override
  String get aspQGraha => 'ಗ್ರಹ ದೃಷ್ಟಿ ಎಂದರೇನು?';

  @override
  String get aspQRashi => 'ರಾಶಿ ದೃಷ್ಟಿ ಎಂದರೇನು?';

  @override
  String get aspQDiff => 'ಎರಡರ ನಡುವಿನ ವ್ಯತ್ಯಾಸ';

  @override
  String get aspQPredict => 'ದೃಷ್ಟಿಗಳು ಭವಿಷ್ಯವಾಣಿಯ ಮೇಲೆ ಹೇಗೆ ಪರಿಣಾಮ ಬೀರುತ್ತವೆ';

  @override
  String get aspGrahaBody => 'ಗ್ರಹ ದೃಷ್ಟಿ ಎಂದರೆ ಒಂದು ಗ್ರಹ ತನ್ನ ಸ್ಥಾನದಿಂದ ಬೀರುವ ದೃಷ್ಟಿ. ಪ್ರತಿಯೊಂದು ಗ್ರಹವು ತನ್ನ ಸ್ಥಳದಿಂದ 7ನೇ ಭಾವ/ಗ್ರಹದ ಮೇಲೆ ಸಂಪೂರ್ಣ ದೃಷ್ಟಿ ಬೀರುತ್ತದೆ (ನೇರ, ಮುಖಾಮುಖಿ ಪ್ರಭಾವ). ಇದಲ್ಲದೆ, ಮಂಗಳ 4ನೇ ಮತ್ತು 8ನೇ ಸ್ಥಾನದ ಮೇಲೆ, ಗುರು 5ನೇ ಮತ್ತು 9ನೇ ಸ್ಥಾನದ ಮೇಲೆ, ಮತ್ತು ಶನಿ 3ನೇ ಮತ್ತು 10ನೇ ಸ್ಥಾನದ ಮೇಲೆ ದೃಷ್ಟಿ ಬೀರುತ್ತಾರೆ. ರಾಹು ಮತ್ತು ಕೇತುಗೆ ಸಾಮಾನ್ಯವಾಗಿ 5, 7 ಮತ್ತು 9ನೇ ದೃಷ್ಟಿಗಳನ್ನು ನೀಡಲಾಗುತ್ತದೆ. ಒಂದು ಗ್ರಹದ ದೃಷ್ಟಿ ಅದು ಬೀಳುವ ಗ್ರಹ ಅಥವಾ ಭಾವಕ್ಕೆ ತನ್ನ ಸ್ವಭಾವದ ಬಣ್ಣವನ್ನು ನೀಡುತ್ತದೆ.';

  @override
  String get aspRashiBody => 'ರಾಶಿ ದೃಷ್ಟಿ ಜೈಮಿನಿ ಜ್ಯೋತಿಷ್ಯದ ರಾಶಿಯಿಂದ-ರಾಶಿಗೆ ಇರುವ ದೃಷ್ಟಿಯಾಗಿದ್ದು, ಅಲ್ಲಿ ಯಾವ ಗ್ರಹಗಳಿವೆ ಎಂಬುದರ ಮೇಲೆ ಅವಲಂಬಿತವಾಗಿಲ್ಲ. ಚರ ರಾಶಿಗಳು ಸ್ಥಿರ ರಾಶಿಗಳ ಮೇಲೆ ದೃಷ್ಟಿ ಬೀರುತ್ತವೆ (ಪಕ್ಕದ್ದನ್ನು ಹೊರತುಪಡಿಸಿ), ಸ್ಥಿರ ರಾಶಿಗಳು ಚರ ರಾಶಿಗಳ ಮೇಲೆ ದೃಷ್ಟಿ ಬೀರುತ್ತವೆ (ಪಕ್ಕದ್ದನ್ನು ಹೊರತುಪಡಿಸಿ), ಮತ್ತು ದ್ವಿಸ್ವಭಾವ ರಾಶಿಗಳು ಇತರ ದ್ವಿಸ್ವಭಾವ ರಾಶಿಗಳ ಮೇಲೆ ದೃಷ್ಟಿ ಬೀರುತ್ತವೆ. ಇದನ್ನು ಮುಖ್ಯವಾಗಿ ಜೈಮಿನಿ ಭವಿಷ್ಯವಾಣಿಯಲ್ಲಿ ಮತ್ತು ಭಾವಗಳ ನಡುವಿನ ಸಂಬಂಧವನ್ನು ನಿರ್ಣಯಿಸಲು ಬಳಸಲಾಗುತ್ತದೆ.';

  @override
  String get aspDiffBody => 'ಗ್ರಹ ದೃಷ್ಟಿಯನ್ನು ಒಂದು ಗ್ರಹ ಬೀರುತ್ತದೆ ಮತ್ತು ಅದು ಆ ಗ್ರಹ ಎಲ್ಲಿ ಇದೆ ಎಂಬುದರ ಮೇಲೆ ಅವಲಂಬಿತವಾಗಿದೆ. ರಾಶಿ ದೃಷ್ಟಿ ರಾಶಿಗೇ ಸೇರಿದ್ದು ಮತ್ತು ಅದರಲ್ಲಿ ಏನೇ ಇರಿಸಿದ್ದರೂ ಅದಕ್ಕೆ ಅನ್ವಯಿಸುತ್ತದೆ. ಗ್ರಹ ದೃಷ್ಟಿ ದಿಕ್ಕಾತ್ಮಕವಾಗಿದೆ (ಗ್ರಹ A ಗ್ರಹ Bಯನ್ನು ನೋಡುತ್ತದೆ), ಆದರೆ ರಾಶಿ ದೃಷ್ಟಿ ಸಾಮಾನ್ಯವಾಗಿ ರಾಶಿಗಳ ನಡುವೆ ಪರಸ್ಪರವಾಗಿರುತ್ತದೆ. ಎರಡೂ ಒಂದೇ ಗುರಿಯನ್ನು ಸೂಚಿಸಿದಾಗ, ಪ್ರಭಾವ ವಿಶೇಷವಾಗಿ ಪ್ರಬಲವಾಗಿರುತ್ತದೆ.';

  @override
  String get aspPredictBody => 'ಒಂದು ದೃಷ್ಟಿ ಒಂದು ಗ್ರಹ ತನ್ನ ಸ್ವಂತ ಭಾವವನ್ನು ಮೀರಿ ತನ್ನ ಪ್ರಭಾವವನ್ನು ಎಲ್ಲಿ ವಿಸ್ತರಿಸುತ್ತದೆ ಎಂಬುದನ್ನು ತೋರಿಸುತ್ತದೆ. ಒಂದು ಶುಭ ದೃಷ್ಟಿ (ಗುರು, ಶುಕ್ರ, ಉತ್ತಮ ಸ್ಥಾನದಲ್ಲಿರುವ ಚಂದ್ರ/ಬುಧ) ಗುರಿಯನ್ನು ಬೆಂಬಲಿಸಿ ರಕ್ಷಿಸುತ್ತದೆ; ಒಂದು ಅಶುಭ ದೃಷ್ಟಿ (ಶನಿ, ಮಂಗಳ, ಸೂರ್ಯ, ರಾಹು, ಕೇತು) ಅದರ ಮೇಲೆ ಒತ್ತಡ, ವಿಳಂಬ ಅಥವಾ ಸವಾಲನ್ನು ಉಂಟುಮಾಡಬಹುದು. ಯಾವ ಗ್ರಹಗಳು ಒಂದು ಭಾವ ಅಥವಾ ಗ್ರಹದ ಮೇಲೆ ದೃಷ್ಟಿ ಬೀರುತ್ತವೆ ಎಂಬುದನ್ನು ಓದುವುದರಿಂದ ಫಲಿತಾಂಶಗಳು ಏಕೆ ಹಾಗೆ ಕಾಣುತ್ತವೆ ಎಂಬುದನ್ನು ವಿವರಿಸುತ್ತದೆ.';

  @override
  String get aspTraitSun => 'ಅಧಿಕಾರ, ನಾಯಕತ್ವ ಮತ್ತು ಚೈತನ್ಯ';

  @override
  String get aspTraitMoon => 'ಭಾವನಾತ್ಮಕ ಆಳ, ಸೌಕರ್ಯ ಮತ್ತು ಅಂತಃಪ್ರಜ್ಞೆ';

  @override
  String get aspTraitMars => 'ಶಕ್ತಿ, ಧೈರ್ಯ ಮತ್ತು ಪ್ರಚೋದನೆ';

  @override
  String get aspTraitMercury => 'ಸಂವಹನ, ಬುದ್ಧಿ ಮತ್ತು ಹೊಂದಾಣಿಕೆ';

  @override
  String get aspTraitJupiter => 'ಜ್ಞಾನ, ಬೆಳವಣಿಗೆ ಮತ್ತು ಅದೃಷ್ಟ';

  @override
  String get aspTraitVenus => 'ಪ್ರೀತಿ, ಸಾಮರಸ್ಯ ಮತ್ತು ಸೌಕರ್ಯಗಳು';

  @override
  String get aspTraitSaturn => 'ಶಿಸ್ತು, ಜವಾಬ್ದಾರಿ ಮತ್ತು ತಾಳ್ಮೆಯ, ಕೆಲವೊಮ್ಮೆ ವಿಳಂಬಿತ, ಯಶಸ್ಸು';

  @override
  String get aspTraitRahu => 'ಮಹತ್ವಾಕಾಂಕ್ಷೆ, ತೀವ್ರತೆ ಮತ್ತು ಅಸಾಂಪ್ರದಾಯಿಕ ತಿರುವುಗಳು';

  @override
  String get aspTraitKetu => 'ವಿರಕ್ತಿ, ಆಧ್ಯಾತ್ಮಿಕತೆ ಮತ್ತು ಹಠಾತ್ ಬದಲಾವಣೆ';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '${planet} ${targets} ಅನ್ನು ಪ್ರಭಾವಿಸುತ್ತಿದೆ. ಇದರಿಂದ ಈ ಗ್ರಹಗಳು ಪ್ರತಿನಿಧಿಸುವ ಕ್ಷೇತ್ರಗಳಲ್ಲಿ ${trait} ಬರಬಹುದು.';
  }

  @override
  String aspAiNone(Object planet) {
    return '${planet} ಇಲ್ಲಿ ಬೇರೆ ಯಾವುದೇ ಗ್ರಹದ ಮೇಲೆ ವಿಶೇಷ ದೃಷ್ಟಿ ಬೀರುವುದಿಲ್ಲ; ಇದರ ಪ್ರಭಾವ ಮುಖ್ಯವಾಗಿ ತನ್ನ ಸ್ವಂತ ರಾಶಿ ಮತ್ತು ಭಾವದ ಮೂಲಕ ಕಾರ್ಯನಿರ್ವಹಿಸುತ್ತದೆ.';
  }

  @override
  String get grahaDrishti => 'ಗ್ರಹ ದೃಷ್ಟಿ (ಗ್ರಹ ವೀಕ್ಷಣೆಗಳು)';

  @override
  String get rashiDrishti => 'ರಾಶಿ ದೃಷ್ಟಿ (ರಾಶಿ ವೀಕ್ಷಣೆಗಳು)';

  @override
  String get grahaDrishtiSubtitle => 'ಯಾರು ಯಾರನ್ನು ದೃಷ್ಟಿಸುತ್ತಾರೆ (%)';

  @override
  String get lagnaAspectsReceived => 'ಲಗ್ನ ಪಡೆದ ದೃಷ್ಟಿಗಳು';

  @override
  String get avSummaryTitle => 'ಅಷ್ಟಕವರ್ಗ ಸಾರಾಂಶ';

  @override
  String get avOverallScore => 'ಒಟ್ಟು SAV ಸ್ಕೋರ್';

  @override
  String get avOverallRating => 'ಒಟ್ಟಾರೆ ರೇಟಿಂಗ್';

  @override
  String get avStrongestSigns => 'ಬಲಿಷ್ಠ ರಾಶಿಗಳು';

  @override
  String get avWeakestSigns => 'ದುರ್ಬಲ ರಾಶಿಗಳು';

  @override
  String get avScore => 'ಸ್ಕೋರ್';

  @override
  String get avMeaning => 'ಅರ್ಥ';

  @override
  String get avGrid => 'ಗ್ರಿಡ್';

  @override
  String get avList => 'ಪಟ್ಟಿ';

  @override
  String get avOverallScoreShort => 'ಒಟ್ಟು ಸ್ಕೋರ್';

  @override
  String get avNatalSignScore => 'ಜನ್ಮ ರಾಶಿ ಸ್ಕೋರ್';

  @override
  String get avBestSigns => 'ಉತ್ತಮ ರಾಶಿಗಳು';

  @override
  String get avWeakSigns => 'ದುರ್ಬಲ ರಾಶಿಗಳು';

  @override
  String get avAiInterpretation => 'AI ವ್ಯಾಖ್ಯಾನ';

  @override
  String get avVeryGood => 'ತುಂಬಾ ಒಳ್ಳೆಯದು';

  @override
  String get avVeryWeak => 'ತುಂಬಾ ದುರ್ಬಲ';

  @override
  String get avTotalSav => 'ಒಟ್ಟು SAV';

  @override
  String get avPlanetContributions => 'ಗ್ರಹ ಕೊಡುಗೆಗಳು';

  @override
  String get avFinance => 'ಹಣಕಾಸು';

  @override
  String get avOverallStrength => 'ಒಟ್ಟಾರೆ ಶಕ್ತಿ';

  @override
  String get avWhatDoesThisMean => 'ಇದರ ಅರ್ಥವೇನು?';

  @override
  String get avSimple => 'ಸರಳ';

  @override
  String get avAdvanced => 'ವಿವರವಾದ';

  @override
  String get avInfoTitle => 'ಅಷ್ಟಕವರ್ಗವನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳುವುದು';

  @override
  String get avStrong => 'ಬಲಿಷ್ಠ';

  @override
  String get avModerate => 'ಮಧ್ಯಮ';

  @override
  String get avQWhatIsAv => 'ಅಷ್ಟಕವರ್ಗ ಎಂದರೇನು?';

  @override
  String get avQWhatIsSav => 'SAV ಎಂದರೇನು?';

  @override
  String get avQWhatIsBav => 'BAV ಎಂದರೇನು?';

  @override
  String get avQHowToRead => 'ಈ ಸ್ಕೋರ್‌ಗಳನ್ನು ಹೇಗೆ ಓದುವುದು';

  @override
  String get avQSavVsBav => 'SAV vs BAV';

  @override
  String get avABody => 'ಅಷ್ಟಕವರ್ಗವು ವೈದಿಕ ಜ್ಯೋತಿಷ್ಯದಲ್ಲಿ ಅಂಕಗಳ ಆಧಾರಿತ ಶಕ್ತಿ ವ್ಯವಸ್ಥೆಯಾಗಿದೆ. ಪ್ರತಿ ಗ್ರಹವು ತನ್ನ ಸ್ಥಾನವನ್ನು ಅವಲಂಬಿಸಿ ಹನ್ನೆರಡು ರಾಶಿಗಳಿಗೆ ಶುಭ ಅಂಕಗಳನ್ನು (ಬಿಂದುಗಳು, ಇವನ್ನು ರೇಖೆಗಳು ಎಂದೂ ಕರೆಯುತ್ತಾರೆ) ನೀಡುತ್ತದೆ. ಒಂದು ರಾಶಿಯಲ್ಲಿ ಹೆಚ್ಚು ಅಂಕಗಳಿದ್ದರೆ, ಸಂಬಂಧಿತ ಗ್ರಹ ದಶೆ ಮತ್ತು ಗೋಚಾರದ ಸಮಯದಲ್ಲಿ ಜೀವನದ ಆ ಕ್ಷೇತ್ರವು ಹೆಚ್ಚು ಸುಗಮ ಬೆಂಬಲ ಪಡೆಯುತ್ತದೆ.';

  @override
  String get avSavBody => 'SAV (ಸರ್ವ ಅಷ್ಟಕವರ್ಗ) ಪ್ರತಿ ರಾಶಿಗೆ ಎಲ್ಲಾ ಏಳು ಗ್ರಹಗಳ ಅಂಕಗಳನ್ನು ಒಟ್ಟುಗೂಡಿಸುತ್ತದೆ. ಇದು ಪ್ರತಿ ರಾಶಿಗೆ ಒಂದೇ ಶಕ್ತಿ ಸ್ಕೋರ್ ನೀಡುತ್ತದೆ, ಇದರಿಂದ ನಿಮ್ಮ ಜಾತಕದಲ್ಲಿ ಯಾವ ರಾಶಿಗಳು — ಮತ್ತು ಅವು ಬೀಳುವ ಭಾವಗಳು — ಹೆಚ್ಚು ಬೆಂಬಲಿತವಾಗಿವೆ ಎಂಬುದನ್ನು ನೀವು ಬೇಗ ನೋಡಬಹುದು.';

  @override
  String get avBavBody => 'BAV (ಭಿನ್ನ ಅಷ್ಟಕವರ್ಗ) ಒಂದೇ ಗ್ರಹದ ಅಂಕಗಳನ್ನು ಹನ್ನೆರಡು ರಾಶಿಗಳಲ್ಲಿ ತೋರಿಸುತ್ತದೆ. ಒಂದು ನಿರ್ದಿಷ್ಟ ಗ್ರಹ ಯಾವ ರಾಶಿಗಳಿಗೆ ಹೆಚ್ಚು ಬೆಂಬಲ ನೀಡುತ್ತದೆ ಎಂಬುದನ್ನು ಇದು ತಿಳಿಸುತ್ತದೆ, ಆ ಗ್ರಹದ ದಶೆ ಅಥವಾ ಗೋಚಾರ ಸಕ್ರಿಯವಾದಾಗ ಇದು ಮುಖ್ಯವಾಗುತ್ತದೆ.';

  @override
  String get avHowToReadBody => 'ಹೆಚ್ಚಿನ ಸಂಖ್ಯೆಗಳು ಉತ್ತಮ. SAV ಗಾಗಿ, ಸರಾಸರಿ ರಾಶಿ ಸುಮಾರು 28 ಅಂಕಗಳನ್ನು ಪಡೆಯುತ್ತದೆ — 30ಕ್ಕಿಂತ ಹೆಚ್ಚು ಬಲಿಷ್ಠ ಮತ್ತು 25ಕ್ಕಿಂತ ಕಡಿಮೆ ಎಚ್ಚರಿಕೆ ಬೇಕು. BAV ಗಾಗಿ, ಪ್ರತಿ ರಾಶಿ 0 ರಿಂದ 8ರ ನಡುವೆ ಇರುತ್ತದೆ, 4 ಅನ್ನು ಸರಾಸರಿ ಎಂದು ಪರಿಗಣಿಸಲಾಗುತ್ತದೆ. ಮುಖ್ಯ ಕಾರ್ಯಗಳಿಗೆ ನಿಮ್ಮ ಬಲಿಷ್ಠ ರಾಶಿಗಳಿಗೆ ಆದ್ಯತೆ ನೀಡಿ, ಮತ್ತು ನಿಮ್ಮ ದುರ್ಬಲ ರಾಶಿಗಳ ವಿಷಯಗಳಲ್ಲಿ ತಾಳ್ಮೆ ಮತ್ತು ಶಿಸ್ತು ಕಾಪಾಡಿಕೊಳ್ಳಿ.';

  @override
  String get avSavVsBavBody => 'SAV ಎಲ್ಲಾ ಗ್ರಹಗಳ ಒಟ್ಟುಗೂಡಿದ ಮೊತ್ತವಾಗಿದ್ದು, ಇದು ಒಂದು ರಾಶಿಯ ಒಟ್ಟಾರೆ ಶಕ್ತಿಯನ್ನು ತೋರಿಸುತ್ತದೆ. BAV ಒಂದೇ ಗ್ರಹದ ಕೊಡುಗೆಯಾಗಿದ್ದು, ಯಾವ ಗ್ರಹ ಆ ರಾಶಿಗೆ ಬೆಂಬಲ ನೀಡುತ್ತದೆ ಎಂಬುದನ್ನು ತೋರಿಸುತ್ತದೆ. ದೊಡ್ಡ ಚಿತ್ರವನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳಲು SAV ಬಳಸಿ, ಮತ್ತು ಯಾವ ಗ್ರಹ ರಾಶಿಯ ಶಕ್ತಿಯನ್ನು ಚಾಲನೆ ಮಾಡುತ್ತದೆ ಎಂಬುದನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳಲು BAV ನೋಡಿ.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'ನಿಮ್ಮ ಜಾತಕ ${s1}, ${s2} ಮತ್ತು ${s3} ರಾಶಿಗಳಲ್ಲಿ ಅತ್ಯಂತ ಬಲಿಷ್ಠವಾಗಿದೆ. ಈ ರಾಶಿಗಳು ಗ್ರಹ ದಶೆಗಳು ಮತ್ತು ಗೋಚಾರಗಳ ಸಮಯದಲ್ಲಿ ಉತ್ತಮ ಬೆಂಬಲ ನೀಡುತ್ತವೆ. ${weak} ಪ್ರಸ್ತುತ ಅತ್ಯಂತ ಕಡಿಮೆ ಬೆಂಬಲ ಹೊಂದಿದೆ, ಆದ್ದರಿಂದ ಅದಕ್ಕೆ ಸಂಬಂಧಿಸಿದ ವಿಷಯಗಳಲ್ಲಿ ತಾಳ್ಮೆ ಮತ್ತು ಶಿಸ್ತು ಸಹಾಯಕವಾಗುತ್ತದೆ.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '${planet} ${s1} ಮತ್ತು ${s2} ಮೂಲಕ ಅತ್ಯಂತ ಬಲಿಷ್ಠವಾಗಿ ಕಾರ್ಯನಿರ್ವಹಿಸುತ್ತದೆ. ಈ ರಾಶಿಗಳು ಸಕ್ರಿಯವಾದಾಗ ${planet} ನಿಯಂತ್ರಿಸುವ ವಿಷಯಗಳು ಸುಧಾರಿಸುತ್ತವೆ.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'ನಿಮ್ಮ ಬಲಿಷ್ಠ ರಾಶಿಗಳು ${s1} ಮತ್ತು ${s2} — ಗ್ರಹಗಳು ಇವುಗಳ ಮೂಲಕ ಗೋಚರಿಸಿದಾಗ ಮುಖ್ಯ ಆರಂಭಗಳಿಗೆ ಇವುಗಳಿಗೆ ಆದ್ಯತೆ ನೀಡಿ.';
  }

  @override
  String avInsightWeak(Object s1) {
    return '${s1} ಅತ್ಯಂತ ಕಡಿಮೆ ಬೆಂಬಲ ಹೊಂದಿದೆ — ಅದರ ವಿಷಯಗಳಲ್ಲಿ ಎಚ್ಚರಿಕೆಯಿಂದ ಮುಂದುವರಿಯಿರಿ ಮತ್ತು ಅತಿಯಾದ ಬದ್ಧತೆಯನ್ನು ತಪ್ಪಿಸಿ.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '${planet} ಅತಿ ಹೆಚ್ಚು ಅಂಕಗಳನ್ನು ಹೊಂದಿದೆ, ಆದ್ದರಿಂದ ಅದರ ಸೂಚನೆಗಳು ನಿಮ್ಮ ಜೀವನದಲ್ಲಿ ಉತ್ತಮವಾಗಿ ಬೆಂಬಲಿತವಾಗಿವೆ.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '${planet} ಅತ್ಯಂತ ಕಡಿಮೆ ಅಂಕಗಳನ್ನು ಹೊಂದಿದೆ ಮತ್ತು ಪರಿಹಾರಗಳು ಹಾಗೂ ಪ್ರಜ್ಞಾಪೂರ್ವಕ ಪ್ರಯತ್ನದಿಂದ ಹೆಚ್ಚು ಪ್ರಯೋಜನ ಪಡೆಯುತ್ತದೆ.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'ನಿಮ್ಮ ಸರಾಸರಿ ${avg} ಅಂಕಗಳಿಗಿಂತ ಹೆಚ್ಚು ಸ್ಕೋರ್ ಮಾಡುವ ರಾಶಿಗಳು ಸಾಮಾನ್ಯವಾಗಿ ಹೆಚ್ಚು ಸುಗಮ ಮತ್ತು ವಿಶ್ವಾಸಾರ್ಹ ಫಲಿತಾಂಶಗಳನ್ನು ನೀಡುತ್ತವೆ.';
  }

  @override
  String get gradeExcellent => 'ಅತ್ಯುತ್ತಮ';

  @override
  String get gradeGood => 'ಒಳ್ಳೆಯದು';

  @override
  String get gradeAverage => 'ಸರಾಸರಿ';

  @override
  String get gradeWeak => 'ದುರ್ಬಲ';

  @override
  String get careerWord => 'ವೃತ್ತಿ';

  @override
  String get educationWord => 'ಶಿಕ್ಷಣ';

  @override
  String get lifeAreaMarriage => 'ವಿವಾಹ';

  @override
  String get sarvaAshtakavarga => 'ಸರ್ವ ಅಷ್ಟಕವರ್ಗ (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'ಒಟ್ಟು: ${total} ರೇಖೆಗಳು (ಸರಾಸರಿ ರಾಶಿ = ${avg})';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '${planet} — BAV';
  }

  @override
  String get forecast => 'ಮುನ್ಸೂಚನೆ';

  @override
  String get fcKey => 'ಕೀ';

  @override
  String get fcActions => 'ಕ್ರಿಯೆಗಳು';

  @override
  String get fcCautions => 'ಎಚ್ಚರಿಕೆಗಳು';

  @override
  String get fc12House => '12 ಭಾವಗಳು';

  @override
  String get fcProbabilities => 'ಸಂಭವನೀಯತೆಗಳು';

  @override
  String get fcHousesCaps => 'ಭಾವಗಳು';

  @override
  String get fcCritical => 'ನಿರ್ಣಾಯಕ';

  @override
  String get fcFlags => 'ಗುರುತುಗಳು';

  @override
  String get fcAnalysis => 'ವಿಶ್ಲೇಷಣೆ';

  @override
  String get fcConfidence => 'ವಿಶ್ವಾಸ';

  @override
  String get fcQualityCaps => 'ಗುಣಮಟ್ಟ';

  @override
  String get fcIncomeVs => 'ಆದಾಯ ವರ್ಸಸ್';

  @override
  String get fcExpense => 'ಖರ್ಚು';

  @override
  String get fcFinance => 'ಹಣಕಾಸು';

  @override
  String get fcNetBalance => 'ನಿವ್ವಳ ಬಾಕಿ';

  @override
  String get fcSignature => 'ಸಹಿ';

  @override
  String get fcBestTimeForIncome => 'ಆದಾಯಕ್ಕೆ ಉತ್ತಮ ಸಮಯ';

  @override
  String get fcExpenseCaution => 'ಖರ್ಚು ಎಚ್ಚರಿಕೆ';

  @override
  String get fcIncomeCaps => 'ಆದಾಯ';

  @override
  String get fcExpenseCaps => 'ಖರ್ಚು';

  @override
  String get fcRelationships => 'ಸಂಬಂಧಗಳು';

  @override
  String get fcAreasCaps => 'ಕ್ಷೇತ್ರಗಳು';

  @override
  String get fcBestForMeetings => 'ಸಭೆಗಳಿಗೆ ಉತ್ತಮ';

  @override
  String get fcOpportunitiesVs => 'ಅವಕಾಶಗಳು ವರ್ಸಸ್';

  @override
  String get fcRisks => 'ಅಪಾಯಗಳು';

  @override
  String get fcOutlook => 'ದೃಷ್ಟಿಕೋನ';

  @override
  String get fcAction => 'ಕ್ರಿಯೆ';

  @override
  String get fcProtect => 'ರಕ್ಷಿಸಿ';

  @override
  String get fcOpportunityCaps => 'ಅವಕಾಶ';

  @override
  String get fcRiskCaps => 'ಅಪಾಯ';

  @override
  String get fcTopOpportunities => 'ಪ್ರಮುಖ ಅವಕಾಶಗಳು';

  @override
  String get fcTopRisks => 'ಪ್ರಮುಖ ಅಪಾಯಗಳು';

  @override
  String get fcTiming => 'ಸಮಯ';

  @override
  String get fcWindows => 'ವಿಂಡೋಗಳು';

  @override
  String get fcSlotsCaps => 'ಸ್ಲಾಟ್‌ಗಳು';

  @override
  String get fcBestWindows => 'ಉತ್ತಮ ವಿಂಡೋಗಳು';

  @override
  String get fcWorstWindows => 'ಕೆಟ್ಟ ವಿಂಡೋಗಳು';

  @override
  String get fcAvoid => 'ತಪ್ಪಿಸಿ';

  @override
  String get fcHouse => 'ಭಾವ';

  @override
  String get fcFailed => 'ವಿಫಲ';

  @override
  String get lifeCareer => 'ವೃತ್ತಿ';

  @override
  String get lifeHealth => 'ಆರೋಗ್ಯ';

  @override
  String get lifeWealth => 'ಸಂಪತ್ತು';

  @override
  String get lifeFamily => 'ಕುಟುಂಬ';

  @override
  String get lifeMind => 'ಮನಸ್ಸು';

  @override
  String get lifeEgo => 'ಅಹಂಕಾರ';

  @override
  String get lifeAggression => 'ಆಕ್ರಮಣಶೀಲತೆ';

  @override
  String get lifeConflict => 'ಸಂಘರ್ಷ';

  @override
  String get rashiElement => 'ತತ್ವ';

  @override
  String get rashiQuality => 'ಗುಣ';

  @override
  String get rashiLuckyColor => 'ಅದೃಷ್ಟ ಬಣ್ಣ';

  @override
  String get rashiLuckyDay => 'ಅದೃಷ್ಟ ದಿನ';

  @override
  String get rashiLuckyNumber => 'ಅದೃಷ್ಟ ಸಂಖ್ಯೆ';

  @override
  String get rashiGemstone => 'ರತ್ನ';

  @override
  String get rashiBody => 'ದೇಹ';

  @override
  String get gocharTodaysTransitChart => 'ಇಂದಿನ ಗೋಚಾರ ಚಾರ್ಟ್';

  @override
  String get gocharTransit => 'ಗೋಚಾರ';

  @override
  String get thisWeek => 'ಈ ವಾರ';

  @override
  String get best => 'ಅತ್ಯುತ್ತಮ';

  @override
  String get worst => 'ಕೆಟ್ಟ';

  @override
  String get avg => 'avg';

  @override
  String get love => 'ಪ್ರೀತಿ';

  @override
  String get spiritual => 'ಆಧ್ಯಾತ್ಮಿಕ';

  @override
  String get analysisConfidence => 'ವಿಶ್ಲೇಷಣೆ ವಿಶ್ವಾಸ';

  @override
  String get areasForGrowth => 'ಬೆಳವಣಿಗೆ ಕ್ಷೇತ್ರಗಳು';

  @override
  String get astrologicalRemedies => 'ಜ್ಯೋತಿಷ್ಯ ಪರಿಹಾರಗಳು';

  @override
  String get bestIndustries => 'ಅತ್ಯುತ್ತಮ ಉದ್ಯಮಗಳು';

  @override
  String get burnoutRisk => 'ಬರ್ನ್‌ಔಟ್ ಅಪಾಯ';

  @override
  String get careerAnalysis => 'ವೃತ್ತಿ ವಿಶ್ಲೇಷಣೆ';

  @override
  String get careerArchetype => 'ವೃತ್ತಿ ಮಾದರಿ';

  @override
  String get careerRisks => 'ವೃತ್ತಿ ಅಪಾಯಗಳು';

  @override
  String get careerStagnation => 'ವೃತ್ತಿ ನಿಶ್ಚಲತೆ';

  @override
  String get clarity => 'ಸ್ಪಷ್ಟತೆ';

  @override
  String get copyFullReport => 'ಪೂರ್ಣ ವರದಿ ದತ್ತಾಂಶ ನಕಲಿಸಿ';

  @override
  String get d9Dignity => 'D9 ಘನತೆ';

  @override
  String get divisionalValidation => 'ವರ್ಗ ಚಕ್ರ ದೃಢೀಕರಣ';

  @override
  String get employment => 'ಉದ್ಯೋಗ';

  @override
  String get entrepreneurship => 'ಉದ್ಯಮಶೀಲತೆ';

  @override
  String get fitScore => 'ಹೊಂದಾಣಿಕೆ ಅಂಕ';

  @override
  String get freelance => 'ಫ್ರೀಲ್ಯಾನ್ಸ್';

  @override
  String get growth => 'ಬೆಳವಣಿಗೆ';

  @override
  String get houseAnalysis => 'ಭಾವ ವಿಶ್ಲೇಷಣೆ';

  @override
  String get idealEnvironment => 'ಆದರ್ಶ ಪರಿಸರ';

  @override
  String get idealOrgSize => 'ಆದರ್ಶ ಸಂಸ್ಥೆ ಗಾತ್ರ';

  @override
  String get jaiminiKarakas => 'ಜೈಮಿನಿ ಕಾರಕಗಳು';

  @override
  String get lagnaLord => 'ಲಗ್ನಾಧಿಪತಿ';

  @override
  String get launchWindows => 'ಆರಂಭ ಅವಧಿಗಳು';

  @override
  String get lord => 'ಅಧಿಪತಿ';

  @override
  String get lordDignity => 'ಅಧಿಪತಿ ಘನತೆ';

  @override
  String get lordPlacedIn => 'ಅಧಿಪತಿ ಇರುವ ಸ್ಥಾನ';

  @override
  String get overallStrength => 'ಒಟ್ಟಾರೆ ಬಲ';

  @override
  String get peakWindows => 'ಉತ್ತುಂಗ ಅವಧಿಗಳು';

  @override
  String get portfolio => 'ಪೋರ್ಟ್‌ಫೋಲಿಯೊ';

  @override
  String get practicalSolutions => 'ಪ್ರಾಯೋಗಿಕ ಪರಿಹಾರಗಳು';

  @override
  String get promotionWindows => 'ಬಡ್ತಿ ಅವಧಿಗಳು';

  @override
  String get recognition => 'ಗುರುತಿಸುವಿಕೆ';

  @override
  String get recommended => 'ಶಿಫಾರಸು';

  @override
  String get riskWindows => 'ಅಪಾಯ ಅವಧಿಗಳು';

  @override
  String get satisfaction => 'ತೃಪ್ತಿ';

  @override
  String get stability => 'ಸ್ಥಿರತೆ';

  @override
  String get teamLeadership => 'ತಂಡ ನಾಯಕತ್ವ';

  @override
  String get tenthLord => '10ನೇ ಅಧಿಪತಿ';

  @override
  String get timingWindows => 'ಕಾಲ ಅವಧಿಗಳು';

  @override
  String get verdict => 'ತೀರ್ಪು';

  @override
  String get workStructure => 'ಕೆಲಸ ರಚನೆ';

  @override
  String get workplaceConflict => 'ಕೆಲಸದ ಸ್ಥಳ ಸಂಘರ್ಷ';

  @override
  String get mitigationLabel => 'ಶಮನ';

  @override
  String get reliabilityVeryHigh => 'ಅತಿ ಹೆಚ್ಚು ವಿಶ್ವಾಸಾರ್ಹತೆ';

  @override
  String get reliabilityHigh => 'ಹೆಚ್ಚು ವಿಶ್ವಾಸಾರ್ಹತೆ';

  @override
  String get reliabilityModerate => 'ಮಧ್ಯಮ ವಿಶ್ವಾಸಾರ್ಹತೆ';

  @override
  String get reliabilityGuidance => 'ಮಾರ್ಗದರ್ಶನ ಮಟ್ಟದ ಓದು';

  @override
  String get relationshipTitlePrefix => 'ಸಂಬಂಧ';

  @override
  String get relationshipTitleSuffix => 'ಬುದ್ಧಿಮತ್ತೆ';

  @override
  String get relationshipIntelBannerLabel => 'ಸಂಬಂಧ ಬುದ್ಧಿಮತ್ತೆ';

  @override
  String get typeLabel => 'ಪ್ರಕಾರ';

  @override
  String get trustLabel => 'ನಂಬಿಕೆ';

  @override
  String get dhokaRiskLabel => 'ಮೋಸ ಅಪಾಯ';

  @override
  String powerLabel(Object power) {
    return 'ಶಕ್ತಿ: ${power}';
  }

  @override
  String get chartProfilesPrefix => 'ಚಕ್ರ';

  @override
  String get chartProfilesSuffix => 'ಪ್ರೊಫೈಲ್‌ಗಳು';

  @override
  String lagnaSuffixLabel(Object sign) {
    return '${sign} ಲಗ್ನ';
  }

  @override
  String get miniIntegrityLabel => 'ಸಮಗ್ರತೆ';

  @override
  String get miniWarmthLabel => 'ಹೃದಯವಂತಿಕೆ';

  @override
  String get miniTrustLabel => 'ನಂಬಿಕೆ';

  @override
  String get miniAssertLabel => 'ದೃಢತೆ';

  @override
  String akLabel(Object planet) {
    return 'AK: ${planet}';
  }

  @override
  String get pairwisePrefix => 'ಜೋಡಿವಾರು';

  @override
  String get pairwiseSuffix => 'ವಿಶ್ಲೇಷಣೆ';

  @override
  String trustPercentLabel(Object pct) {
    return 'ನಂಬಿಕೆ: ${pct}%';
  }

  @override
  String betrayalPercentLabel(Object pct) {
    return 'ವಿಶ್ವಾಸಘಾತ: ${pct}%';
  }

  @override
  String get scoreCharacterLabel => 'ಗುಣ';

  @override
  String get scoreLoveLabel => 'ಪ್ರೀತಿ';

  @override
  String get scoreBusinessLabel => 'ವ್ಯಾಪಾರ';

  @override
  String get scoreKarmicLabel => 'ಕಾರ್ಮಿಕ';

  @override
  String get scoreTrustLabel => 'ನಂಬಿಕೆ';

  @override
  String get scoreEnmityRiskLabel => 'ಶತ್ರುತ್ವ ಅಪಾಯ';

  @override
  String dynamicLabel(Object value) {
    return 'ಕ್ರಿಯಾಶೀಲತೆ: ${value}';
  }

  @override
  String karmicLabel(Object value) {
    return 'ಕಾರ್ಮಿಕ: ${value}';
  }

  @override
  String get criticalPrefix => 'ನಿರ್ಣಾಯಕ';

  @override
  String get criticalSuffix => 'ಮಾದರಿಗಳು';

  @override
  String get groupPrefix => 'ಗುಂಪು';

  @override
  String get groupSuffix => 'ಶಿಫಾರಸುಗಳು';

  @override
  String get sharedPracticesLabel => 'ಹಂಚಿಕೊಂಡ ಅಭ್ಯಾಸಗಳು';

  @override
  String communicationLabel(Object value) {
    return 'ಸಂವಹನ: ${value}';
  }

  @override
  String focusLabel(Object value) {
    return 'ಗಮನ: ${value}';
  }

  @override
  String get individualPrefix => 'ವೈಯಕ್ತಿಕ';

  @override
  String get individualSuffix => 'ಮಾರ್ಗದರ್ಶನ';

  @override
  String karmicLessonLabel(Object value) {
    return 'ಕಾರ್ಮಿಕ ಪಾಠ: ${value}';
  }

  @override
  String get growthAreasLabel => 'ಬೆಳವಣಿಗೆ ಕ್ಷೇತ್ರಗಳು';

  @override
  String get corePrefix => 'ಮೂಲ';

  @override
  String get coreSuffix => 'ವಿಷಯ';

  @override
  String get growthOrientedLabel => 'ಬೆಳವಣಿಗೆ-ಆಧಾರಿತ';

  @override
  String get groupThemeLabel => 'ಗುಂಪು ವಿಷಯ';

  @override
  String get analysisPrefix => 'ವಿಶ್ಲೇಷಣೆ';

  @override
  String get analysisConfidenceSuffix => 'ವಿಶ್ವಾಸ';

  @override
  String get reportCopied => 'ವರದಿ ನಕಲಿಸಲಾಗಿದೆ!';

  @override
  String get copyFullReportData => 'ಪೂರ್ಣ ವರದಿ ದತ್ತಾಂಶ ನಕಲಿಸಿ';

  @override
  String get openExternalLabel => 'ತೆರೆ';

  @override
  String copiedOpeningAi(Object ai) {
    return 'ನಕಲಿಸಲಾಗಿದೆ! ${ai} ತೆರೆಯುತ್ತಿದೆ...';
  }

  @override
  String get milanTitlePrefix => 'ಕುಂಡಲಿ';

  @override
  String get ashtakoot => 'ಅಷ್ಟಕೂಟ';

  @override
  String get compatibilityLabel => 'ಹೊಂದಾಣಿಕೆ';

  @override
  String get unifiedScoreLabel => 'ಏಕೀಕೃತ\nಅಂಕ';

  @override
  String get probabilityLabel => 'ಸಂಭವನೀಯತೆ';

  @override
  String ganaLabel(Object value) {
    return 'ಗಣ: ${value}';
  }

  @override
  String get gunPrefixLabel => '8 ಗುಣ';

  @override
  String get breakdownLabel => 'ವಿಭಜನೆ';

  @override
  String get mangalLabel => 'ಮಂಗಳ';

  @override
  String severityLabel(Object value) {
    return 'ತೀವ್ರತೆ: ${value}';
  }

  @override
  String get d9Label => 'D-9';

  @override
  String get crossChartLabel => 'ಅಡ್ಡ-ಚಕ್ರ';

  @override
  String get d9CompatibilityLabel => 'D-9 ಹೊಂದಾಣಿಕೆ';

  @override
  String get domainEmotional => 'ಭಾವನಾತ್ಮಕ';

  @override
  String get domainIntellectual => 'ಬೌದ್ಧಿಕ';

  @override
  String get domainSpiritual => 'ಆಧ್ಯಾತ್ಮಿಕ';

  @override
  String get domainFinancial => 'ಆರ್ಥಿಕ';

  @override
  String get domainDomestic => 'ಗೃಹಸ್ಥ';

  @override
  String get domainCommunication => 'ಸಂವಹನ';

  @override
  String get domainSharedDharma => 'ಹಂಚಿಕೊಂಡ ಧರ್ಮ';

  @override
  String get domainFamilyCreation => 'ಕುಟುಂಬ ನಿರ್ಮಾಣ';

  @override
  String get domainLabel => 'ಕ್ಷೇತ್ರ';

  @override
  String get compatibilitySuffixLabel => 'ಹೊಂದಾಣಿಕೆ';

  @override
  String get marriageLabel => 'ವಿವಾಹ';

  @override
  String get timingLabel => 'ಕಾಲ';

  @override
  String get jointMarriageWindowsTitle => 'ಜಂಟಿ ವಿವಾಹ ಅವಧಿಗಳು';

  @override
  String get engagementWindowsTitle => 'ನಿಶ್ಚಿತಾರ್ಥ ಅವಧಿಗಳು';

  @override
  String recommendedLabel(Object value) {
    return 'ಶಿಫಾರಸು: ${value}';
  }

  @override
  String get risksLabel => 'ಅಪಾಯಗಳು';

  @override
  String get finalLabel => 'ಅಂತಿಮ';

  @override
  String get verdictLabel => 'ತೀರ್ಪು';

  @override
  String get marriageVerdictLabel => 'ವಿವಾಹ ತೀರ್ಪು';

  @override
  String get discussReportWithAI => 'ಈ ವರದಿಯನ್ನು AI ಜೊತೆ ಚರ್ಚಿಸಿ';

  @override
  String get multiChartTitleChild => 'ಮಗು';

  @override
  String get multiChartTitleLove => 'ಪ್ರೀತಿ';

  @override
  String get multiChartTitleKarma => 'ಕರ್ಮ';

  @override
  String get multiChartTitleDefault => 'ಬಹು-ಚಕ್ರ';

  @override
  String get multiChartSuffixProbability => 'ಸಂಭವನೀಯತೆ';

  @override
  String get multiChartSuffixCompatibility => 'ಹೊಂದಾಣಿಕೆ';

  @override
  String get multiChartSuffixLinkage => 'ಸಂಪರ್ಕ';

  @override
  String get multiChartSuffixReport => 'ವರದಿ';

  @override
  String get participantsLabel => 'ಭಾಗವಹಿಸಿದವರು';

  @override
  String get reportDataCopied => 'ವರದಿ ದತ್ತಾಂಶ ನಕಲಿಸಲಾಗಿದೆ!';

  @override
  String copiedForAi(Object label) {
    return '${label} ಗಾಗಿ ನಕಲಿಸಲಾಗಿದೆ!';
  }

  @override
  String get wealthScoresLabel => 'ಸಂಪತ್ತು ಅಂಕಗಳು';

  @override
  String get wealthStrengthLabel => 'ಸಂಪತ್ತು\nಬಲ';

  @override
  String get accumulationLabel => 'ಸಂಗ್ರಹ';

  @override
  String get incomeFlowLabel => 'ಆದಾಯ\nಹರಿವು';

  @override
  String get sustainLabel => 'ಉಳಿಸಿಕೊ';

  @override
  String get multiStreamLabel => 'ಬಹು-ಮೂಲ';

  @override
  String get retentionLabel => 'ಉಳಿಸಿಕೆ';

  @override
  String get wealthLabel => 'ಸಂಪತ್ತು';

  @override
  String get karakasLabel => 'ಕಾರಕಗಳು';

  @override
  String get wealthYogasTitle => 'ಸಂಪತ್ತು ಯೋಗಗಳು';

  @override
  String get drainsLabel => 'ಸೋರಿಕೆಗಳು';

  @override
  String get boostersLabel => 'ವರ್ಧಕಗಳು';

  @override
  String get incomeLabel => 'ಆದಾಯ';

  @override
  String get sourcesLabel => 'ಮೂಲಗಳು';

  @override
  String get investmentLabel => 'ಹೂಡಿಕೆ';

  @override
  String get mixLabel => 'ಮಿಶ್ರಣ';

  @override
  String get yearlyTrendTitle => 'ವಾರ್ಷಿಕ ಪ್ರವೃತ್ತಿ';

  @override
  String get wealthGrowthTitle => 'ಸಂಪತ್ತು ಬೆಳವಣಿಗೆ';

  @override
  String get cashPressureTitle => 'ನಗದು ಒತ್ತಡ';

  @override
  String get moneyPersonalityTitle => 'ಹಣ ವ್ಯಕ್ತಿತ್ವ';

  @override
  String get wealthTypeLabel => 'ಸಂಪತ್ತು ಪ್ರಕಾರ';

  @override
  String get riskAppetiteLabel => 'ಅಪಾಯ ಒಲವು';

  @override
  String get investmentStyleLabel => 'ಹೂಡಿಕೆ ಶೈಲಿ';

  @override
  String get moneyPersonalityLabel => 'ಹಣ ವ್ಯಕ್ತಿತ್ವ';

  @override
  String get spendingLabel => 'ಖರ್ಚು';

  @override
  String get debtProbLabel => 'ಸಾಲ ಸಂಭವ %';

  @override
  String get inheritanceProbLabel => 'ಉತ್ತರಾಧಿಕಾರ %';

  @override
  String get suddenGainsProbLabel => 'ಹಠಾತ್ ಲಾಭ %';

  @override
  String get spouseBoostLabel => 'ಸಂಗಾತಿ ವರ್ಧನೆ %';

  @override
  String successProbabilityLabel(Object pct) {
    return 'ಯಶಸ್ಸಿನ ಸಂಭವನೀಯತೆ: ${pct}%';
  }

  @override
  String get lifetimeWealthClassLabel => 'ಜೀವಿತ ಸಂಪತ್ತು ವರ್ಗ';

  @override
  String primaryLabel(Object value) {
    return 'ಪ್ರಾಥಮಿಕ: ${value}';
  }

  @override
  String peakAgeLabel(Object value) {
    return 'ಉತ್ತುಂಗ: ${value}';
  }

  @override
  String drivenByLabel(Object value) {
    return '${value} ಚಾಲಿತ';
  }

  @override
  String get coreBlockerLabel => 'ಮೂಲ ತಡೆ';

  @override
  String get debtScoresLabel => 'ಸಾಲ ಅಂಕಗಳು';

  @override
  String get currentDebtLoadLabel => 'ಪ್ರಸ್ತುತ\nಸಾಲ ಭಾರ';

  @override
  String get recoveryCapacityLabel => 'ಚೇತರಿಕೆ\nಸಾಮರ್ಥ್ಯ';

  @override
  String get intensityLabel => 'ತೀವ್ರತೆ';

  @override
  String get defaultRiskLabel => 'ಡೀಫಾಲ್ಟ್ ಅಪಾಯ';

  @override
  String get debtProfileTitle => 'ಸಾಲ ಪ್ರೊಫೈಲ್';

  @override
  String get karmaLabel => 'ಕರ್ಮ';

  @override
  String get personalityLabel => 'ವ್ಯಕ್ತಿತ್ವ';

  @override
  String get phaseLabel => 'ಹಂತ';

  @override
  String get primaryCategoryLabel => 'ಪ್ರಾಥಮಿಕ ವರ್ಗ';

  @override
  String get debtLabel => 'ಸಾಲ';

  @override
  String get debtYogasTitle => 'ಸಾಲ ಯೋಗಗಳು';

  @override
  String get debtCreatingLabel => 'ಸಾಲ-ಸೃಷ್ಟಿಸುವ';

  @override
  String get debtClearingLabel => 'ಸಾಲ-ತೀರಿಸುವ';

  @override
  String get categoriesLabel => 'ವರ್ಗಗಳು';

  @override
  String get yearlyDebtTitle => 'ವಾರ್ಷಿಕ ಸಾಲ';

  @override
  String get repaymentTitle => 'ಮರುಪಾವತಿ';

  @override
  String get dangerPeriodsTitle => 'ಅಪಾಯ ಅವಧಿಗಳು';

  @override
  String get defaultPctLabel => 'ಡೀಫಾಲ್ಟ್ %';

  @override
  String get bankruptcyPctLabel => 'ದಿವಾಳಿ %';

  @override
  String get chronicPctLabel => 'ದೀರ್ಘಕಾಲಿಕ %';

  @override
  String get resilienceLabel => 'ಸಹನಶಕ್ತಿ';

  @override
  String recoveryTimelineLabel(Object pct, Object years) {
    return 'ಚೇತರಿಕೆ: ${pct}% · ಕಾಲಾವಧಿ: ${years}ವರ್ಷ';
  }

  @override
  String get debtFreeWindowLabel => 'ಸಾಲ-ಮುಕ್ತ ಅವಧಿ';

  @override
  String yearLabel(Object year) {
    return 'ವರ್ಷ ${year}';
  }

  @override
  String dashaLabel(Object value) {
    return 'ದಶಾ: ${value}';
  }

  @override
  String get marriageScoresLabel => 'ವಿವಾಹ ಅಂಕಗಳು';

  @override
  String get overallMarriageLabel => 'ಒಟ್ಟಾರೆ\nವಿವಾಹ';

  @override
  String get maritalHarmonyLabel => 'ದಾಂಪತ್ಯ\nಸಾಮರಸ್ಯ';

  @override
  String get domesticStabilityLabel => 'ಗೃಹಸ್ಥ\nಸ್ಥಿರತೆ';

  @override
  String get longevityLabel => 'ಆಯುಷ್ಯ';

  @override
  String get satisfactionLabel => 'ತೃಪ್ತಿ';

  @override
  String get clarityLabel => 'ಸ್ಪಷ್ಟತೆ';

  @override
  String get darakarakaLabel => 'ದಾರಾಕಾರಕ';

  @override
  String get spouseKarakaLabel => 'ಸಂಗಾತಿ ಕಾರಕ';

  @override
  String get darakarakaDkLabel => 'ದಾರಾಕಾರಕ (DK)';

  @override
  String get seventhLabel => '7ನೇ';

  @override
  String get lordLabel => 'ಅಧಿಪತಿ';

  @override
  String get lordInLabel => 'ಅಧಿಪತಿ ಇರುವ';

  @override
  String get lordDignityLabel => 'ಅಧಿಪತಿ ಘನತೆ';

  @override
  String get emptyLabel => 'ಖಾಲಿ';

  @override
  String get spouseLabel => 'ಸಂಗಾತಿ';

  @override
  String get spouseTraitsLabel => 'ಸಂಗಾತಿ ಲಕ್ಷಣಗಳು';

  @override
  String get likelyProfessionsLabel => 'ಸಂಭವನೀಯ ವೃತ್ತಿಗಳು';

  @override
  String get harmonyPhysicalLabel => 'ಶಾರೀರಿಕ';

  @override
  String get sharedValuesLabel => 'ಹಂಚಿಕೊಂಡ ಮೌಲ್ಯಗಳು';

  @override
  String get conflictResolutionLabel => 'ಸಂಘರ್ಷ ಪರಿಹಾರ';

  @override
  String get harmonyLabel => 'ಸಾಮರಸ್ಯ';

  @override
  String get radarLabel => 'ರಾಡಾರ್';

  @override
  String get mangalDoshLabel => 'ಮಂಗಳ ದೋಷ';

  @override
  String severityColonLabel(Object value) {
    return 'ತೀವ್ರತೆ: ${value}';
  }

  @override
  String cancellationColonLabel(Object value) {
    return 'ರದ್ದತಿ: ${value}';
  }

  @override
  String get marriageWindowsTitle => 'ವಿವಾಹ ಅವಧಿಗಳು';

  @override
  String get marriagePhasesTitle => 'ವಿವಾಹ ಹಂತಗಳು';

  @override
  String get inLawRelationsLabel => 'ಬಂಧು ಸಂಬಂಧಗಳು';

  @override
  String get familyHarmonyLabel => 'ಕುಟುಂಬ ಸಾಮರಸ್ಯ';

  @override
  String get fertilityLabel => 'ಫಲವಂತಿಕೆ';

  @override
  String get homeOwnershipLabel => 'ಗೃಹ ಮಾಲೀಕತ್ವ';

  @override
  String get divorceRiskLabel => 'ವಿಚ್ಛೇದನ ಅಪಾಯ';

  @override
  String get infidelityLabel => 'ವಿಶ್ವಾಸಘಾತ';

  @override
  String get conflictLabel => 'ಸಂಘರ್ಷ';

  @override
  String get distanceLabel => 'ಅಂತರ';

  @override
  String get seekInPartnerLabel => 'ಸಂಗಾತಿಯಲ್ಲಿ ಬಯಸಿ';

  @override
  String get avoidInPartnerLabel => 'ಸಂಗಾತಿಯಲ್ಲಿ ತಪ್ಪಿಸಿ';

  @override
  String realizationLabel(Object pct) {
    return 'ಸಾಕ್ಷಾತ್ಕಾರ: ${pct}%';
  }

  @override
  String get navamsaLabel => 'ನವಾಂಶ';

  @override
  String get characterScoresLabel => 'ಗುಣ ಅಂಕಗಳು';

  @override
  String get characterStrengthLabel => 'ಗುಣ\nಬಲ';

  @override
  String get characterIntegrityLabel => 'ಸಮಗ್ರತೆ';

  @override
  String get awarenessLabel => 'ಅರಿವು';

  @override
  String get stabilityLabel => 'ಸ್ಥಿರತೆ';

  @override
  String get ethicsLabel => 'ನೀತಿ';

  @override
  String get surfacePersonalityTitle => 'ಬಾಹ್ಯ ವ್ಯಕ್ತಿತ್ವ';

  @override
  String get constitutionLabel => 'ಪ್ರಕೃತಿ';

  @override
  String get nakshatraLabel => 'ನಕ್ಷತ್ರ';

  @override
  String get deityLabel => 'ದೇವತೆ';

  @override
  String get moonManasTitle => 'ಚಂದ್ರ ಮನಸ್';

  @override
  String get warmthLabel => 'ಹೃದಯವಂತಿಕೆ';

  @override
  String get empathyLabel => 'ಸಹಾನುಭೂತಿ';

  @override
  String get loyaltyLabel => 'ನಿಷ್ಠೆ';

  @override
  String get boundariesLabel => 'ಗಡಿಗಳು';

  @override
  String get dharmaLabel => 'ಧರ್ಮ';

  @override
  String get truthLabel => 'ಸತ್ಯ';

  @override
  String get compassionLabel => 'ಕರುಣೆ';

  @override
  String get generosityLabel => 'ಔದಾರ್ಯ';

  @override
  String get signatureVirtuesLabel => 'ವಿಶಿಷ್ಟ ಸದ್ಗುಣಗಳು';

  @override
  String get naturalTalentsLabel => 'ಸಹಜ ಪ್ರತಿಭೆಗಳು';

  @override
  String get shadowPatternsLabel => 'ಛಾಯಾ ಮಾದರಿಗಳು';

  @override
  String get characterYogasTitle => 'ಗುಣ ಯೋಗಗಳು';

  @override
  String get testsLabel => 'ಪರೀಕ್ಷೆಗಳು';

  @override
  String get giftsLabel => 'ಕೊಡುಗೆಗಳು';

  @override
  String get selfAwareEiLabel => 'ಸ್ವ-ಅರಿವು EI';

  @override
  String get selfRegulateLabel => 'ಸ್ವ-ನಿಯಂತ್ರಣ';

  @override
  String get empathyEiLabel => 'ಸಹಾನುಭೂತಿ EI';

  @override
  String get socialSkillsLabel => 'ಸಾಮಾಜಿಕ ಕೌಶಲ್ಯ';

  @override
  String get atmakarakaLabel => 'ಆತ್ಮಕಾರಕ';

  @override
  String get soulSignatureLabel => 'ಆತ್ಮ ಚಿಹ್ನೆ';

  @override
  String get atmakarakaAllCapsLabel => 'ಆತ್ಮಕಾರಕ';

  @override
  String get gunaLabel => 'ಗುಣ';

  @override
  String dominantColonLabel(Object value) {
    return 'ಪ್ರಬಲ: ${value}';
  }

  @override
  String get coreGiftLabel => 'ಮೂಲ ಕೊಡುಗೆ';

  @override
  String get coreThemeAllCapsLabel => 'ಮೂಲ ವಿಷಯ';

  @override
  String get pastLifeScoresLabel => 'ಪೂರ್ವಜನ್ಮ ಅಂಕಗಳು';

  @override
  String get signatureStrengthLabel => 'ವಿಶಿಷ್ಟ\nಬಲ';

  @override
  String get carryForwardLabel => 'ಮುಂದಕ್ಕೆ\nಸಾಗಿಸು';

  @override
  String get masteryPreservedLabel => 'ಪ್ರಾವೀಣ್ಯ\nಉಳಿಸಿದೆ';

  @override
  String get unfinishedLabel => 'ಅಪೂರ್ಣ';

  @override
  String get karmicDebtLabel => 'ಕಾರ್ಮಿಕ ಸಾಲ';

  @override
  String get pastMasteryLabel => 'ಪೂರ್ವ ಪ್ರಾವೀಣ್ಯ';

  @override
  String get futureGrowthLabel => 'ಭವಿಷ್ಯ ಬೆಳವಣಿಗೆ';

  @override
  String get ketuWhatYouMasteredLabel => 'ಕೇತು · ನೀವು ಮಾಸ್ಟರ್ ಮಾಡಿದ್ದು';

  @override
  String get rahuWhatPullsForwardLabel => 'ರಾಹು · ನಿಮ್ಮನ್ನು ಮುಂದಕ್ಕೆ ಸೆಳೆಯುವುದು';

  @override
  String get pastLifeProfileTitle => 'ಪೂರ್ವಜನ್ಮ ಪ್ರೊಫೈಲ್';

  @override
  String get themeLabel => 'ವಿಷಯ';

  @override
  String get professionLabel => 'ವೃತ್ತಿ';

  @override
  String get socialStandingLabel => 'ಸಾಮಾಜಿಕ ಸ್ಥಾನ';

  @override
  String get regionLabel => 'ಪ್ರದೇಶ';

  @override
  String get spiritualLevelLabel => 'ಆಧ್ಯಾತ್ಮಿಕ ಮಟ್ಟ';

  @override
  String get wealthLevelLabel => 'ಸಂಪತ್ತು ಮಟ್ಟ';

  @override
  String get familyRoleLabel => 'ಕುಟುಂಬ ಪಾತ್ರ';

  @override
  String get skillsCarriedForwardLabel => 'ಮುಂದಕ್ಕೆ ಸಾಗಿಸಿದ ಕೌಶಲ್ಯಗಳು';

  @override
  String get naturalAttractionsLabel => 'ಸಹಜ ಆಕರ್ಷಣೆಗಳು';

  @override
  String get unexplainedFearsLabel => 'ವಿವರಿಸಲಾಗದ ಭಯಗಳು';

  @override
  String get magneticPullsLabel => 'ಆಯಸ್ಕಾಂತ ಸೆಳೆತಗಳು';

  @override
  String get relationshipLabel => 'ಸಂಬಂಧ';

  @override
  String get financialLabel => 'ಆರ್ಥಿಕ';

  @override
  String get serviceLabel => 'ಸೇವೆ';

  @override
  String get dharmicLabel => 'ಧಾರ್ಮಿಕ';

  @override
  String get onRelationsLabel => 'ಸಂಬಂಧಗಳ ಮೇಲೆ';

  @override
  String get onCareerLabel => 'ವೃತ್ತಿಯ ಮೇಲೆ';

  @override
  String get onHealthLabel => 'ಆರೋಗ್ಯದ ಮೇಲೆ';

  @override
  String get onSpiritualLabel => 'ಆಧ್ಯಾತ್ಮಿಕದ ಮೇಲೆ';

  @override
  String get karmicResolutionTitle => 'ಕಾರ್ಮಿಕ ಪರಿಹಾರ';

  @override
  String get primaryPathLabel => 'ಪ್ರಾಥಮಿಕ ಮಾರ್ಗ';

  @override
  String get secondaryPathLabel => 'ದ್ವಿತೀಯ ಮಾರ್ಗ';

  @override
  String get clearingProgressLabel => 'ತೀರಿಸುವ ಪ್ರಗತಿ';

  @override
  String get remainingWorkLabel => 'ಉಳಿದ ಕೆಲಸ';

  @override
  String get debtTimelineLabel => 'ಸಾಲ ಕಾಲಾವಧಿ';

  @override
  String get memoryAccessLabel => 'ಸ್ಮೃತಿ ಪ್ರವೇಶ';

  @override
  String get dreamVisitsLabel => 'ಸ್ವಪ್ನ ಭೇಟಿಗಳು';

  @override
  String get dejaVuLabel => 'ದೇಜಾ ವು';

  @override
  String get regressionFitLabel => 'ಪುನರಾವರ್ತನ ಹೊಂದಾಣಿಕೆ';

  @override
  String get pastLifeActivationTitle => 'ಪೂರ್ವಜನ್ಮ ಸಕ್ರಿಯಗೊಳಿಸುವಿಕೆ';

  @override
  String maturityStatusLabel(Object score, Object status) {
    return 'ಪಕ್ವತೆ: ${score} · ಸ್ಥಿತಿ: ${status}';
  }

  @override
  String shadowColonLabel(Object value) {
    return 'ಛಾಯೆ: ${value}';
  }

  @override
  String get lifePathScoresLabel => 'ಜೀವನ ಮಾರ್ಗ ಅಂಕಗಳು';

  @override
  String get dharmaClarityLabel => 'ಧರ್ಮ\nಸ್ಪಷ್ಟತೆ';

  @override
  String get fortuneBaselineLabel => 'ಅದೃಷ್ಟ\nಆಧಾರ';

  @override
  String get lifePathCoherenceLabel => 'ಜೀವನ ಮಾರ್ಗ\nಸುಸಂಬದ್ಧತೆ';

  @override
  String get karmaAllCapsLabel => 'ಕರ್ಮ';

  @override
  String get spiritualAllCapsLabel => 'ಆಧ್ಯಾತ್ಮಿಕ';

  @override
  String get fameLabel => 'ಕೀರ್ತಿ';

  @override
  String get lifeLabel => 'ಜೀವನ';

  @override
  String get archetypeLabel => 'ಮಾದರಿ';

  @override
  String get soulContractTitle => 'ಆತ್ಮ ಒಪ್ಪಂದ';

  @override
  String get akFocusLabel => 'AK ಗಮನ';

  @override
  String get soulPurposeLabel => 'ಆತ್ಮ ಉದ್ದೇಶ';

  @override
  String get lifeChapterLabel => 'ಜೀವನ ಅಧ್ಯಾಯ';

  @override
  String get primaryDomainLabel => 'ಪ್ರಾಥಮಿಕ ಕ್ಷೇತ್ರ';

  @override
  String get leadershipLabel => 'ನಾಯಕತ್ವ';

  @override
  String get wisdomTeachLabel => 'ಜ್ಞಾನ/ಬೋಧನೆ';

  @override
  String get healingLabel => 'ಗುಣಪಡಿಸುವಿಕೆ';

  @override
  String get fortuneYogasTitle => 'ಅದೃಷ್ಟ ಯೋಗಗಳು';

  @override
  String get luckBlocksLabel => 'ಅದೃಷ್ಟ ತಡೆಗಳು';

  @override
  String get fortuneBoostersLabel => 'ಅದೃಷ್ಟ ವರ್ಧಕಗಳು';

  @override
  String get fortuneTrendTitle => 'ಅದೃಷ್ಟ ಪ್ರವೃತ್ತಿ';

  @override
  String get goldenWindowsTitle => 'ಸುವರ್ಣ ಅವಧಿಗಳು ★';

  @override
  String get transformationTitle => 'ಪರಿವರ್ತನೆ';

  @override
  String get lifeMilestonesTitle => 'ಜೀವನ ಮೈಲಿಗಲ್ಲುಗಳು';

  @override
  String get destinyVsLabel => 'ವಿಧಿ ವಿರುದ್ಧ';

  @override
  String get freeWillLabel => 'ಸ್ವತಂತ್ರ ಇಚ್ಛೆ';

  @override
  String get destinyAllCapsLabel => 'ವಿಧಿ';

  @override
  String get freeWillAllCapsLabel => 'ಸ್ವತಂತ್ರ ಇಚ್ಛೆ';

  @override
  String get karmicLessonsTitle => 'ಕಾರ್ಮಿಕ ಪಾಠಗಳು';

  @override
  String get rahuGrowthLabel => 'ರಾಹು ಬೆಳವಣಿಗೆ';

  @override
  String get ketuSurrenderLabel => 'ಕೇತು ಶರಣಾಗತಿ';

  @override
  String get saturnLessonLabel => 'ಶನಿ ಪಾಠ';

  @override
  String get lifeDifficultyLabel => 'ಜೀವನ ಕಷ್ಟ';

  @override
  String get soulCameToExperienceLabel => 'ಆತ್ಮ ಅನುಭವಿಸಲು ಬಂದಿದೆ';

  @override
  String get blessingsLabel => 'ಆಶೀರ್ವಾದಗಳು';

  @override
  String fulfillmentLabel(Object pct) {
    return 'ಈಡೇರಿಕೆ: ${pct}%';
  }

  @override
  String get legalScoresLabel => 'ಕಾನೂನು ಅಂಕಗಳು';

  @override
  String get legalVulnerabilityLabel => 'ಕಾನೂನು\nದುರ್ಬಲತೆ';

  @override
  String get victoryPotentialLabel => 'ವಿಜಯ\nಸಾಮರ್ಥ್ಯ';

  @override
  String get resolutionLabel => 'ಪರಿಹಾರ';

  @override
  String get legalProfileTitle => 'ಕಾನೂನು ಪ್ರೊಫೈಲ್';

  @override
  String get karmaTypeLabel => 'ಕರ್ಮ ಪ್ರಕಾರ';

  @override
  String get conflictStyleLabel => 'ಸಂಘರ್ಷ ಶೈಲಿ';

  @override
  String get strategyLabel => 'ತಂತ್ರ';

  @override
  String get caseDurationLabel => 'ಪ್ರಕರಣ ಅವಧಿ';

  @override
  String get currentStatusLabel => 'ಪ್ರಸ್ತುತ ಸ್ಥಿತಿ';

  @override
  String get legalLabel => 'ಕಾನೂನು';

  @override
  String get legalYogasTitle => 'ಕಾನೂನು ಯೋಗಗಳು';

  @override
  String get disputePressureLabel => 'ವಿವಾದ ಒತ್ತಡ';

  @override
  String get legalProtectionLabel => 'ಕಾನೂನು ರಕ್ಷಣೆ';

  @override
  String get victoryLabel => 'ವಿಜಯ';

  @override
  String get asPlaintiffLabel => 'ಫಿರ್ಯಾದಿಯಾಗಿ';

  @override
  String get asDefendantLabel => 'ಪ್ರತಿವಾದಿಯಾಗಿ';

  @override
  String get winProbabilityLabel => 'ಗೆಲುವಿನ ಸಂಭವನೀಯತೆ';

  @override
  String get disputeLabel => 'ವಿವಾದ';

  @override
  String get legalStressTitle => 'ಕಾನೂನು ಒತ್ತಡ';

  @override
  String get visibleEnemiesLabel => 'ಗೋಚರ ಶತ್ರುಗಳು';

  @override
  String get hiddenEnemiesLabel => 'ಗುಪ್ತ ಶತ್ರುಗಳು';

  @override
  String get criminalRiskLabel => 'ಕ್ರಿಮಿನಲ್ ಅಪಾಯ';

  @override
  String get falseAccusationLabel => 'ಸುಳ್ಳು ಆರೋಪ';

  @override
  String get contractKarmaTitle => 'ಒಪ್ಪಂದ ಕರ್ಮ';

  @override
  String get documentationLabel => 'ದಾಖಲೀಕರಣ';

  @override
  String get finePrintAwareLabel => 'ಸೂಕ್ಷ್ಮ ಅಂಶ ಅರಿವು';

  @override
  String get negotiationSkillLabel => 'ಮಾತುಕತೆ ಕೌಶಲ್ಯ';

  @override
  String get signatureCautionLabel => 'ಸಹಿ ಎಚ್ಚರಿಕೆ';

  @override
  String resilienceColonLabel(Object value) {
    return 'ಸಹನಶಕ್ತಿ: ${value}/100';
  }

  @override
  String get healthScoresLabel => 'ಆರೋಗ್ಯ ಅಂಕಗಳು';

  @override
  String get vitalityLabel => 'ಚೈತನ್ಯ';

  @override
  String get immunityLabel => 'ರೋಗನಿರೋಧಕ';

  @override
  String get recoveryLabel => 'ಚೇತರಿಕೆ';

  @override
  String get mentalLabel => 'ಮಾನಸಿಕ';

  @override
  String get stressTolLabel => 'ಒತ್ತಡ ಸಹನೆ';

  @override
  String get ayurvedicLabel => 'ಆಯುರ್ವೇದ';

  @override
  String get constitutionTitleLabel => 'ಪ್ರಕೃತಿ';

  @override
  String secondaryColonLabel(Object value) {
    return 'ದ್ವಿತೀಯ: ${value}';
  }

  @override
  String get bodyLabel => 'ದೇಹ';

  @override
  String get systemMapLabel => 'ವ್ಯವಸ್ಥೆ ನಕ್ಷೆ';

  @override
  String get healthYogasTitle => 'ಆರೋಗ್ಯ ಯೋಗಗಳು';

  @override
  String get diseasePressureLabel => 'ರೋಗ ಒತ್ತಡ';

  @override
  String get protectiveLabel => 'ರಕ್ಷಣಾತ್ಮಕ';

  @override
  String get bodyZoneLabel => 'ದೇಹ ವಲಯ';

  @override
  String get vulnerabilityLabel => 'ದುರ್ಬಲತೆ';

  @override
  String get diseaseLabel => 'ರೋಗ';

  @override
  String get susceptibilityLabel => 'ಒಳಗಾಗುವಿಕೆ';

  @override
  String get healthTrendTitle => 'ಆರೋಗ್ಯ ಪ್ರವೃತ್ತಿ';

  @override
  String get recoveryWindowsTitle => 'ಚೇತರಿಕೆ ಅವಧಿಗಳು';

  @override
  String get cautionPeriodsTitle => 'ಎಚ್ಚರಿಕೆ ಅವಧಿಗಳು';

  @override
  String get burnoutRiskLabel => 'ಬರ್ನ್‌ಔಟ್ ಅಪಾಯ';

  @override
  String get addictionVulnLabel => 'ವ್ಯಸನ ದುರ್ಬಲತೆ';

  @override
  String get workLifeBalLabel => 'ಕೆಲಸ-ಜೀವನ ಸಮತೋಲನ';

  @override
  String get lifestyleFactorsTitle => 'ಜೀವನಶೈಲಿ ಅಂಶಗಳು';

  @override
  String get sleepDisciplineLabel => 'ನಿದ್ರೆ ಶಿಸ್ತು';

  @override
  String get dietDisciplineLabel => 'ಆಹಾರ ಶಿಸ್ತು';

  @override
  String get exerciseNeedLabel => 'ವ್ಯಾಯಾಮ ಅಗತ್ಯ';

  @override
  String get sunlightNeedLabel => 'ಸೂರ್ಯಬೆಳಕು ಅಗತ್ಯ';

  @override
  String get socialTypeLabel => 'ಸಾಮಾಜಿಕ ಪ್ರಕಾರ';

  @override
  String get healingSpeedLabel => 'ಗುಣಪಡಿಸುವ ವೇಗ';

  @override
  String get mentalScoresLabel => 'ಮಾನಸಿಕ ಅಂಕಗಳು';

  @override
  String get mentalStabilityLabel => 'ಮಾನಸಿಕ\nಸ್ಥಿರತೆ';

  @override
  String get emotionalBaselineLabel => 'ಭಾವನಾತ್ಮಕ\nಆಧಾರ';

  @override
  String get anxietyLabel => 'ಆತಂಕ';

  @override
  String get depressionLabel => 'ಖಿನ್ನತೆ';

  @override
  String get regulationLabel => 'ನಿಯಂತ್ರಣ';

  @override
  String get mentalProfileTitle => 'ಮಾನಸಿಕ ಪ್ರೊಫೈಲ್';

  @override
  String get stressDriverLabel => 'ಒತ್ತಡ ಚಾಲಕ';

  @override
  String get stabilityAnchorLabel => 'ಸ್ಥಿರತೆ ಆಧಾರ';

  @override
  String get attachmentStyleLabel => 'ಬಾಂಧವ್ಯ ಶೈಲಿ';

  @override
  String get burnoutStageLabel => 'ಬರ್ನ್‌ಔಟ್ ಹಂತ';

  @override
  String get mentalTitleLabel => 'ಮಾನಸಿಕ';

  @override
  String get mentalYogasTitle => 'ಮಾನಸಿಕ ಯೋಗಗಳು';

  @override
  String get stressPressureLabel => 'ಒತ್ತಡ ಒತ್ತುವಿಕೆ';

  @override
  String get stressResponseLabel => 'ಒತ್ತಡ ಪ್ರತಿಕ್ರಿಯೆ';

  @override
  String get anxietyTitleLabel => 'ಆತಂಕ';

  @override
  String get typesLabel => 'ಪ್ರಕಾರಗಳು';

  @override
  String get therapyLabel => 'ಚಿಕಿತ್ಸೆ';

  @override
  String get modalityFitLabel => 'ವಿಧಾನ ಹೊಂದಾಣಿಕೆ';

  @override
  String get wellnessTrendTitle => 'ಸ್ವಾಸ್ಥ್ಯ ಪ್ರವೃತ್ತಿ';

  @override
  String get healthyCopingLabel => 'ಆರೋಗ್ಯಕರ ನಿಭಾವಣೆ';

  @override
  String get unhealthyRisksLabel => 'ಅನಾರೋಗ್ಯಕರ ಅಪಾಯಗಳು';

  @override
  String get recommendedAlternativesLabel => 'ಶಿಫಾರಸು ಪರ್ಯಾಯಗಳು';

  @override
  String get sleepQualityLabel => 'ನಿದ್ರೆ ಗುಣಮಟ್ಟ';

  @override
  String get socialSupportLabel => 'ಸಾಮಾಜಿಕ ಬೆಂಬಲ';

  @override
  String get burnoutVulnLabel => 'ಬರ್ನ್‌ಔಟ್ ದುರ್ಬಲತೆ';

  @override
  String get selfAwarenessLabel => 'ಸ್ವ-ಅರಿವು';

  @override
  String get authTagline => 'ಜ್ಯೋತಿಷಿಗಳಿಗಾಗಿ ನಕ್ಷತ್ರಲಜಿ';

  @override
  String get googleSignInNoToken => 'Google ಸೈನ್-ಇನ್: ಯಾವುದೇ ID ಟೋಕನ್ ಸ್ವೀಕರಿಸಿಲ್ಲ. GOOGLE_WEB_CLIENT_ID ಹೊಂದಿಸಲಾಗಿದೆ ಮತ್ತು google-services.json ಕಾನ್ಫಿಗರ್ ಆಗಿದೆ ಎಂದು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಿ.';

  @override
  String googleSignInError(String error) {
    return 'Google ಸೈನ್-ಇನ್ ದೋಷ: ${error}';
  }

  @override
  String get orDivider => 'ಅಥವಾ';

  @override
  String get register => 'ನೋಂದಣಿ';

  @override
  String get signInWithBiometrics => 'ಬಯೋಮೆಟ್ರಿಕ್ಸ್‌ನೊಂದಿಗೆ ಸೈನ್ ಇನ್';

  @override
  String get forgotPasswordInstructions => 'ಮರುಹೊಂದಿಸುವ ಲಿಂಕ್ ಪಡೆಯಲು ನಿಮ್ಮ\nನೋಂದಾಯಿತ ಇಮೇಲ್ ನಮೂದಿಸಿ.';

  @override
  String get resendLink => 'ಲಿಂಕ್ ಮರುಕಳುಹಿಸಿ';

  @override
  String callJoinedChannel(String channel) {
    return '${channel} ಚಾನೆಲ್ ಸೇರಿದೆ';
  }

  @override
  String get callUserConnected => 'ಬಳಕೆದಾರ ಸಂಪರ್ಕಗೊಂಡಿದೆ! ಕರೆ ಸಕ್ರಿಯ';

  @override
  String callConnectionFailed(String reason) {
    return 'ಸಂಪರ್ಕ ವಿಫಲವಾಗಿದೆ: ${reason}. Agora ರುಜುವಾತುಗಳನ್ನು ಪರಿಶೀಲಿಸಿ.';
  }

  @override
  String callAgoraError(String details) {
    return 'Agora ದೋಷ: ${details}';
  }

  @override
  String callAgoraInitFailed(String error) {
    return 'Agora ಆರಂಭ ವಿಫಲವಾಗಿದೆ: ${error}';
  }

  @override
  String get callWaitingForVideo => 'ವೀಡಿಯೊಗಾಗಿ ಕಾಯುತ್ತಿದೆ...';

  @override
  String get callVideoCall => 'ವೀಡಿಯೊ ಕರೆ';

  @override
  String get callVoiceCall => 'ಧ್ವನಿ ಕರೆ';

  @override
  String callRateEarning(String rate, String earning) {
    return '${rate}/ನಿಮಿಷ • ಗಳಿಕೆ: ${earning}';
  }

  @override
  String get markAllRead => 'ಎಲ್ಲವನ್ನೂ ಓದಿದಂತೆ ಗುರುತಿಸಿ';

  @override
  String get noNotificationsYet => 'ಇನ್ನೂ ಯಾವುದೇ ಅಧಿಸೂಚನೆಗಳಿಲ್ಲ';

  @override
  String get pullToRefresh => 'ರಿಫ್ರೆಶ್ ಮಾಡಲು ಕೆಳಗೆ ಎಳೆಯಿರಿ';

  @override
  String get justNow => 'ಈಗಷ್ಟೇ';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}ನಿ ಹಿಂದೆ';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}ಗಂ ಹಿಂದೆ';
  }

  @override
  String daysAgo(int days) {
    return '${days}ದಿ ಹಿಂದೆ';
  }

  @override
  String get noChartsCreateFirst => 'ಚಕ್ರಗಳಿಲ್ಲ. ಮೊದಲು ಜನ್ಮ ಚಕ್ರ ರಚಿಸಿ.';

  @override
  String get selectBirthChartToAnalyze => 'ವಿಶ್ಲೇಷಿಸಲು ಜನ್ಮ ಚಕ್ರ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get unknownName => 'ಅಜ್ಞಾತ';

  @override
  String selectRangeCharts(int max) {
    return '2-${max} ಚಕ್ರಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ';
  }

  @override
  String selectExactCharts(int max) {
    return '${max} ಚಕ್ರಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ';
  }

  @override
  String runningAnalysis(String label) {
    return '${label} ವಿಶ್ಲೇಷಣೆ ನಡೆಯುತ್ತಿದೆ...';
  }

  @override
  String pickKarmicCharts(int max) {
    return 'ಕಾರ್ಮಿಕ ಸಂಪರ್ಕ ವಿಶ್ಲೇಷಿಸಲು 2 ರಿಂದ ${max} ಚಕ್ರ ಆಯ್ಕೆಮಾಡಿ';
  }

  @override
  String get pickMaleFemaleChart => 'ಒಂದು ಪುರುಷ ಮತ್ತು ಸ್ತ್ರೀ ಚಕ್ರ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get analysisFailed => 'ವಿಶ್ಲೇಷಣೆ ವಿಫಲವಾಗಿದೆ';

  @override
  String errorWithDetails(String error) {
    return 'ದೋಷ: ${error}';
  }

  @override
  String personNumber(int n) {
    return 'ವ್ಯಕ್ತಿ ${n}';
  }

  @override
  String analyzeNCharts(int count) {
    return '${count} ಚಕ್ರಗಳನ್ನು ವಿಶ್ಲೇಷಿಸಿ';
  }

  @override
  String get bhavaHouse1 => 'ಸ್ವಯಂ / ದೇಹ';

  @override
  String get bhavaHouse2 => 'ಸಂಪತ್ತು / ಕುಟುಂಬ';

  @override
  String get bhavaHouse3 => 'ಸಹೋದರರು / ಧೈರ್ಯ';

  @override
  String get bhavaHouse4 => 'ಮನೆ / ತಾಯಿ';

  @override
  String get bhavaHouse5 => 'ಮಕ್ಕಳು / ಬುದ್ಧಿ';

  @override
  String get bhavaHouse6 => 'ಶತ್ರುಗಳು / ಆರೋಗ್ಯ';

  @override
  String get bhavaHouse7 => 'ವಿವಾಹ / ಸಂಗಾತಿ';

  @override
  String get bhavaHouse8 => 'ಆಯುಷ್ಯ';

  @override
  String get bhavaHouse9 => 'ಅದೃಷ್ಟ / ಗುರು';

  @override
  String get bhavaHouse10 => 'ವೃತ್ತಿ / ತಂದೆ';

  @override
  String get bhavaHouse11 => 'ಲಾಭ / ಸ್ನೇಹಿತರು';

  @override
  String get bhavaHouse12 => 'ನಷ್ಟ / ಮೋಕ್ಷ';

  @override
  String bhavaSignLord(String sign, String lord) {
    return '${sign} • ಅಧಿಪತಿ: ${lord}';
  }

  @override
  String bhavaSavValue(String value) {
    return 'SAV: ${value}';
  }

  @override
  String get today => 'ಇಂದು';

  @override
  String gocharTransitScoresTitle(String date) {
    return 'ಗೋಚರ (ಸಂಚಾರ ಅಂಕಗಳು) — ${date}';
  }

  @override
  String gocharNativeMoon(String moonSign) {
    return 'ಜನ್ಮ ಚಂದ್ರ: ${moonSign}';
  }

  @override
  String get gocharBest => 'ಅತ್ಯುತ್ತಮ';

  @override
  String get gocharWorst => 'ಕೆಟ್ಟ';

  @override
  String get aspectsGrahaDrishtiTitle => 'ಗ್ರಹ ದೃಷ್ಟಿ (ಗ್ರಹ ದೃಷ್ಟಿಗಳು)';

  @override
  String get aspectsGrahaDrishtiSubtitle => 'ಯಾರು ಯಾರನ್ನು ದೃಷ್ಟಿಸುತ್ತಾರೆ (%)';

  @override
  String get aspectsLagnaReceivedTitle => 'ಲಗ್ನ ಪಡೆದ ದೃಷ್ಟಿಗಳು';

  @override
  String get aspectsRashiDrishtiTitle => 'ರಾಶಿ ದೃಷ್ಟಿ (ರಾಶಿ ದೃಷ್ಟಿಗಳು)';

  @override
  String get ashtakavargaSavTitle => 'ಸರ್ವ ಅಷ್ಟಕವರ್ಗ (SAV)';

  @override
  String ashtakavargaSavSubtitle(String total, String average) {
    return 'ಒಟ್ಟು: ${total} ರೇಖೆಗಳು (ಸರಾಸರಿ ರಾಶಿ = ${average})';
  }

  @override
  String ashtakavargaPlanetBavTitle(String planet) {
    return '${planet} — BAV';
  }

  @override
  String ashtakavargaPlanetBavSubtitle(String total, String natalScore) {
    return 'ಒಟ್ಟು: ${total} ರೇಖೆಗಳು • ಜನ್ಮ ರಾಶಿಯಲ್ಲಿ: ${natalScore}';
  }

  @override
  String get appName => 'ನಕ್ಷತ್ರಲಾಜಿ ಆಸ್ಟ್ರೋ';

  @override
  String get astrologerPanel => 'ಜ್ಯೋತಿಷಿ ಪ್ಯಾನಲ್';

  @override
  String get home => 'ಮುಖಪುಟ';

  @override
  String get dashboard => 'ಡ್ಯಾಶ್‌ಬೋರ್ಡ್';

  @override
  String get charts => 'ಜಾತಕಗಳು';

  @override
  String get bookings => 'ಬುಕಿಂಗ್‌ಗಳು';

  @override
  String get requests => 'ವಿನಂತಿಗಳು';

  @override
  String get chats => 'ಚಾಟ್‌ಗಳು';

  @override
  String get earnings => 'ಗಳಿಕೆ';

  @override
  String get profile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get live => 'ಲೈವ್';

  @override
  String get signIn => 'ಸೈನ್ ಇನ್';

  @override
  String get createAccount => 'ಖಾತೆ ರಚಿಸಿ';

  @override
  String get email => 'ಇಮೇಲ್';

  @override
  String get password => 'ಪಾಸ್‌ವರ್ಡ್';

  @override
  String get confirmPassword => 'ಪಾಸ್‌ವರ್ಡ್ ದೃಢೀಕರಿಸಿ';

  @override
  String get fullName => 'ಪೂರ್ಣ ಹೆಸರು';

  @override
  String get phone => 'ಫೋನ್ (ಐಚ್ಛಿಕ)';

  @override
  String get forgotPassword => 'ಪಾಸ್‌ವರ್ಡ್ ಮರೆತಿರಾ?';

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
  String get sendResetLink => 'ಮರುಹೊಂದಿಸುವ ಲಿಂಕ್ ಕಳುಹಿಸಿ';

  @override
  String get backToSignIn => 'ಸೈನ್ ಇನ್‌ಗೆ ಹಿಂತಿರುಗಿ';

  @override
  String get dontHaveAccount => 'ಖಾತೆ ಇಲ್ಲವೇ?';

  @override
  String get alreadyHaveAccount => 'ಈಗಾಗಲೇ ಖಾತೆ ಇದೆಯೇ?';

  @override
  String get continueGoogle => 'Google ನೊಂದಿಗೆ ಮುಂದುವರಿಸಿ';

  @override
  String get required => 'ಅಗತ್ಯ';

  @override
  String get minSixChars => 'ಕನಿಷ್ಠ 6 ಅಕ್ಷರಗಳು';

  @override
  String get passwordsMismatch => 'ಪಾಸ್‌ವರ್ಡ್‌ಗಳು ಹೊಂದಿಕೆಯಾಗುತ್ತಿಲ್ಲ';

  @override
  String get validEmailRequired => 'ಮಾನ್ಯ ಇಮೇಲ್ ಅಗತ್ಯ';

  @override
  String get loginFailed => 'ಲಾಗಿನ್ ವಿಫಲವಾಯಿತು';

  @override
  String get signupFailed => 'ಸೈನಪ್ ವಿಫಲವಾಯಿತು';

  @override
  String get todaysEarning => 'ಇಂದಿನ ಗಳಿಕೆ';

  @override
  String get walletBalance => 'ವಾಲೆಟ್';

  @override
  String get rating => 'ರೇಟಿಂಗ್';

  @override
  String get totalSessions => 'ಸೆಷನ್‌ಗಳು';

  @override
  String get consultations => 'ಸಮಾಲೋಚನೆಗಳು';

  @override
  String get response => 'ಪ್ರತಿಕ್ರಿಯೆ';

  @override
  String get online => 'ಆನ್‌ಲೈನ್';

  @override
  String get offline => 'ಆಫ್‌ಲೈನ್';

  @override
  String get busy => 'ಬ್ಯುಸಿ';

  @override
  String get goLive => 'ಲೈವ್‌ಗೆ ಹೋಗಿ';

  @override
  String get streamTitle => 'ಸ್ಟ್ರೀಮ್ ಶೀರ್ಷಿಕೆ';

  @override
  String get description => 'ವಿವರಣೆ (ಐಚ್ಛಿಕ)';

  @override
  String get start => 'ಪ್ರಾರಂಭ';

  @override
  String get rashiPredictions => 'ರಾಶಿ ಭವಿಷ್ಯ';

  @override
  String get todaysGochar => 'ಇಂದಿನ ಗೋಚಾರ ಎಲ್ಲಾ 12 ರಾಶಿಗಳಿಗೆ — ವಿವರಗಳಿಗೆ ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get recentRequests => 'ಇತ್ತೀಚಿನ ವಿನಂತಿಗಳು';

  @override
  String get noRecentRequests => 'ಇತ್ತೀಚಿನ ವಿನಂತಿಗಳಿಲ್ಲ';

  @override
  String get upcoming => 'ಮುಂಬರುವ';

  @override
  String get viewAll => 'ಎಲ್ಲವನ್ನೂ ನೋಡಿ';

  @override
  String get pending => 'ಬಾಕಿ';

  @override
  String get accepted => 'ಅಂಗೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get completed => 'ಪೂರ್ಣಗೊಂಡಿದೆ';

  @override
  String get declined => 'ತಿರಸ್ಕರಿಸಲಾಗಿದೆ';

  @override
  String get clientCharts => 'ಕ್ಲೈಂಟ್ ಜಾತಕಗಳು';

  @override
  String get newChart => 'ಹೊಸ ಜಾತಕ';

  @override
  String get noChartsCreated => 'ಇನ್ನೂ ಯಾವುದೇ ಜಾತಕ ರಚಿಸಿಲ್ಲ';

  @override
  String get newClientChart => 'ಹೊಸ ಕ್ಲೈಂಟ್ ಜಾತಕ';

  @override
  String get clientBirthDetails => 'ಕ್ಲೈಂಟ್ ಜನ್ಮ ವಿವರಗಳು';

  @override
  String get clientName => 'ಕ್ಲೈಂಟ್ ಹೆಸರು';

  @override
  String get gender => 'ಲಿಂಗ';

  @override
  String get male => 'ಪುರುಷ';

  @override
  String get female => 'ಮಹಿಳೆ';

  @override
  String get other => 'ಇತರ';

  @override
  String get dateOfBirth => 'ಹುಟ್ಟಿದ ದಿನಾಂಕ';

  @override
  String get timeOfBirth => 'ಹುಟ್ಟಿದ ಸಮಯ';

  @override
  String get birthPlace => 'ಹುಟ್ಟಿದ ಸ್ಥಳ';

  @override
  String get birthPlaceHint => 'ನಗರದ ಹೆಸರನ್ನು ಟೈಪ್ ಮಾಡಿ...';

  @override
  String get generateKundli => 'ಕುಂಡಲಿ ರಚಿಸಿ';

  @override
  String get clientChartCreated => 'ಕ್ಲೈಂಟ್ ಜಾತಕ ರಚಿಸಲಾಗಿದೆ!';

  @override
  String get viewKundli => 'ಕುಂಡಲಿ ನೋಡಿ';

  @override
  String get deleteChart => 'ಜಾತಕ ಅಳಿಸಬೇಕೇ?';

  @override
  String get completeBirthChart => 'ಸಂಪೂರ್ಣ ಜನ್ಮ ಜಾತಕ';

  @override
  String get birthDetails => 'ಜನ್ಮ ವಿವರಗಳು';

  @override
  String get name => 'ಹೆಸರು';

  @override
  String get dob => 'ಹುಟ್ಟಿದ ದಿನಾಂಕ';

  @override
  String get tob => 'ಹುಟ್ಟಿದ ಸಮಯ';

  @override
  String get place => 'ಸ್ಥಳ';

  @override
  String get summary => 'ಸಾರಾಂಶ';

  @override
  String get planets => 'ಗ್ರಹಗಳು';

  @override
  String get kundli => 'ಕುಂಡಲಿ';

  @override
  String get divisions => 'ವಿಭಾಗಗಳು';

  @override
  String get vimshottari => 'ವಿಂಶೋತ್ತರಿ';

  @override
  String get moola => 'ಮೂಲ';

  @override
  String get gochar => 'ಗೋಚಾರ';

  @override
  String get dosh => 'ದೋಷ';

  @override
  String get yoga => 'ಯೋಗ';

  @override
  String get shadbala => 'ಷಡ್ಬಲ';

  @override
  String get ashtakavarga => 'ಅಷ್ಟಕವರ್ಗ';

  @override
  String get aspects => 'ದೃಷ್ಟಿ';

  @override
  String get lifeAreas => 'ಜೀವನ ಕ್ಷೇತ್ರಗಳು';

  @override
  String get bhava => 'ಭಾವ';

  @override
  String get chakras => 'ಚಕ್ರಗಳು';

  @override
  String get dashaActive => 'ದಶಾ ಸಕ್ರಿಯ';

  @override
  String get lagna => 'ಲಗ್ನ';

  @override
  String get moon => 'ಚಂದ್ರ';

  @override
  String get sun => 'ಸೂರ್ಯ';

  @override
  String get thisMonth => 'ಈ ತಿಂಗಳು';

  @override
  String get statement => 'ಹೇಳಿಕೆ';

  @override
  String get all => 'ಎಲ್ಲಾ';

  @override
  String get credits => 'ಕ್ರೆಡಿಟ್‌ಗಳು';

  @override
  String get withdrawals => 'ಹಿಂಪಡೆಯುವಿಕೆಗಳು';

  @override
  String get bonus => 'ಬೋನಸ್';

  @override
  String get refunds => 'ಮರುಪಾವತಿಗಳು';

  @override
  String get requestWithdrawal => 'ಹಿಂಪಡೆಯುವ ವಿನಂತಿ';

  @override
  String get withdraw => 'ಹಿಂಪಡೆಯಿರಿ';

  @override
  String get amount => 'ಮೊತ್ತ';

  @override
  String get upiId => 'UPI ID';

  @override
  String get bankTransfer => 'ಬ್ಯಾಂಕ್ ವರ್ಗಾವಣೆ';

  @override
  String get accountHolderName => 'ಖಾತೆದಾರರ ಹೆಸರು';

  @override
  String get accountNumber => 'ಖಾತೆ ಸಂಖ್ಯೆ';

  @override
  String get ifscCode => 'IFSC ಕೋಡ್';

  @override
  String get submit => 'ಸಲ್ಲಿಸಿ';

  @override
  String get noTransactions => 'ವಹಿವಾಟುಗಳಿಲ್ಲ';

  @override
  String get withdrawalHistory => 'ಹಿಂಪಡೆಯುವ ಇತಿಹಾಸ';

  @override
  String get typeGuidance => 'ನಿಮ್ಮ ಮಾರ್ಗದರ್ಶನವನ್ನು ಟೈಪ್ ಮಾಡಿ...';

  @override
  String get sessionEnded => 'ಸೆಷನ್ ಮುಗಿದಿದೆ';

  @override
  String get endChat => 'ಚಾಟ್ ಮುಗಿಸಬೇಕೇ?';

  @override
  String get endChatConfirm => 'ನೀವು ಈ ಸೆಷನ್ ಅನ್ನು ಮುಗಿಸಲು ಖಚಿತವಾಗಿ ಬಯಸುವಿರಾ?';

  @override
  String get activeNow => 'ಈಗ ಸಕ್ರಿಯ';

  @override
  String get connecting => 'ಸಂಪರ್ಕಿಸುತ್ತಿದೆ...';

  @override
  String get clientKundli => 'ಕ್ಲೈಂಟ್ ಕುಂಡಲಿ';

  @override
  String get earned => 'ಗಳಿಸಿದ್ದು';

  @override
  String get connected => 'ಸಂಪರ್ಕಿತ';

  @override
  String get endCall => 'ಕರೆ ಮುಗಿಸಿ';

  @override
  String get endStream => 'ಸ್ಟ್ರೀಮ್ ಮುಗಿಸಿ';

  @override
  String get endStreamConfirm => 'ಲೈವ್ ಸ್ಟ್ರೀಮ್ ಮುಗಿಸಬೇಕೇ?';

  @override
  String get goLiveBtn => 'ಲೈವ್‌ಗೆ ಹೋಗಿ';

  @override
  String get viewers => 'ವೀಕ್ಷಕರು';

  @override
  String get peak => 'ಗರಿಷ್ಠ';

  @override
  String get gifts => 'ಉಡುಗೊರೆಗಳು';

  @override
  String get ok => 'ಸರಿ';

  @override
  String get cancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get save => 'ಉಳಿಸಿ';

  @override
  String get edit => 'ಸಂಪಾದಿಸಿ';

  @override
  String get delete => 'ಅಳಿಸಿ';

  @override
  String get retry => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get send => 'ಕಳುಹಿಸಿ';

  @override
  String get refresh => 'ರಿಫ್ರೆಶ್';

  @override
  String get loading => 'ಲೋಡ್ ಆಗುತ್ತಿದೆ...';

  @override
  String get noData => 'ಡೇಟಾ ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get error => 'ದೋಷ';

  @override
  String get success => 'ಯಶಸ್ಸು';

  @override
  String get logout => 'ಲಾಗ್‌ಔಟ್';

  @override
  String get selectLanguage => 'ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get language => 'ಭಾಷೆ';

  @override
  String get english => 'ಇಂಗ್ಲಿಷ್';

  @override
  String get kycSubmit => 'KYC ಸಲ್ಲಿಸಿ';

  @override
  String get kycPending => 'KYC ಪರಿಶೀಲನೆಯಲ್ಲಿದೆ';

  @override
  String get kycRejected => 'KYC ತಿರಸ್ಕರಿಸಲಾಗಿದೆ';

  @override
  String get notifications => 'ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get biometricLogin => 'ಬಯೋಮೆಟ್ರಿಕ್ ಲಾಗಿನ್';

  @override
  String get editProfile => 'ಪ್ರೊಫೈಲ್ ಸಂಪಾದಿಸಿ';

  @override
  String get totalCredit => 'ಒಟ್ಟು ಕ್ರೆಡಿಟ್';

  @override
  String get totalDebit => 'ಒಟ್ಟು ಡೆಬಿಟ್';

  @override
  String get allTypes => 'ಎಲ್ಲಾ ಪ್ರಕಾರಗಳು';

  @override
  String get prev => 'ಹಿಂದಿನ';

  @override
  String get next => 'ಮುಂದಿನ';

  @override
  String get page => 'ಪುಟ';

  @override
  String get allInsights => 'ಎಲ್ಲಾ ವಿಶ್ಲೇಷಣೆಗಳು';

  @override
  String get yourCompleteReading => 'ನಿಮ್ಮ ಸಂಪೂರ್ಣ ಓದು';

  @override
  String get expertEngines => 'ತಜ್ಞ ಎಂಜಿನ್‌ಗಳು';

  @override
  String get eachInsightConsultation => 'ಪ್ರತಿ ವಿಶ್ಲೇಷಣೆಯು ಸಂಪೂರ್ಣ ಸಮಾಲೋಚನೆ';

  @override
  String get engines => 'ಎಂಜಿನ್‌ಗಳು';

  @override
  String get dataPoints => 'ಡೇಟಾ ಪಾಯಿಂಟ್‌ಗಳು';

  @override
  String get singleChart => 'ಸಿಂಗಲ್';

  @override
  String get careerPurpose => 'ವೃತ್ತಿ & ಉದ್ದೇಶ';

  @override
  String get wealthAssets => 'ಸಂಪತ್ತು & ಆಸ್ತಿಗಳು';

  @override
  String get loveRelationships => 'ಪ್ರೀತಿ & ಸಂಬಂಧಗಳು';

  @override
  String get healthWellness => 'ಆರೋಗ್ಯ & ಕ್ಷೇಮ';

  @override
  String get soulKarma => 'ಆತ್ಮ & ಕರ್ಮ';

  @override
  String get specialistReports => 'ತಜ್ಞ ವರದಿಗಳು';

  @override
  String get deptReports => 'ವಿಭಾಗ ವರದಿಗಳು';

  @override
  String get specialistAnalysesDesc => '15 ತಜ್ಞ ವಿಶ್ಲೇಷಣೆಗಳು — ವೃತ್ತಿ, ಸಂಪತ್ತು, ಆರೋಗ್ಯ, ಪ್ರೀತಿ ಮತ್ತು ಇನ್ನಷ್ಟು';

  @override
  String get matchTwoChartsDesc => 'ಎರಡು ಕುಂಡಲಿಗಳನ್ನು ಹೊಂದಿಸಿ — ಅಷ್ಟಕೂಟ, ನವಾಂಶ, ಗೋಚರ ಸಮಯ ಮತ್ತು ಇನ್ನಷ್ಟು';

  @override
  String get todaysForecast => 'ಇಂದಿನ ಮುನ್ಸೂಚನೆ';

  @override
  String get dailyProbability => 'ಯಾವುದೇ ಕುಂಡಲಿಗೆ ದೈನಂದಿನ ಸಂಭವನೀಯತೆ ಮುನ್ಸೂಚನೆ';

  @override
  String get engCareer => 'ವೃತ್ತಿ & ಉದ್ಯೋಗ';

  @override
  String get engBusiness => 'ವ್ಯಾಪಾರ & ಸ್ಟಾರ್ಟ್‌ಅಪ್';

  @override
  String get engEducation => 'ಶಿಕ್ಷಣ & ಕಲಿಕೆ';

  @override
  String get engLifePath => 'ಜೀವನ ಮಾರ್ಗ & ಅದೃಷ್ಟ';

  @override
  String get engWealth => 'ಸಂಪತ್ತು & ಹಣಕಾಸು';

  @override
  String get engDebt => 'ಸಾಲ & ವಸೂಲಿ';

  @override
  String get engProperty => 'ಆಸ್ತಿ & ಸ್ವತ್ತು';

  @override
  String get engLegal => 'ಕಾನೂನು & ವಿವಾದ';

  @override
  String get engLove => 'ಪ್ರೀತಿ & ರೊಮ್ಯಾನ್ಸ್';

  @override
  String get engMarriage => 'ವಿವಾಹ & ಕುಟುಂಬ';

  @override
  String get engKundliMilan => 'ಕುಂಡಲಿ ಮಿಲನ್';

  @override
  String get engRelationship => 'ಸಂಬಂಧ ವಿಶ್ಲೇಷಣೆ';

  @override
  String get engLoveCompat => 'ಪ್ರೀತಿ ಹೊಂದಾಣಿಕೆ';

  @override
  String get engChildProb => 'ಮಕ್ಕಳ ಸಂಭವನೀಯತೆ';

  @override
  String get engHealth => 'ಆರೋಗ್ಯ & ಕ್ಷೇಮ';

  @override
  String get engMental => 'ಮಾನಸಿಕ & ಒತ್ತಡ';

  @override
  String get engCharacter => 'ವ್ಯಕ್ತಿತ್ವ ವಿಶ್ಲೇಷಣೆ';

  @override
  String get engPastLife => 'ಪೂರ್ವಜನ್ಮ & ಕರ್ಮ';

  @override
  String get engKarmaLink => 'ಕರ್ಮ ಸಂಬಂಧ';

  @override
  String get decline => 'ನಿರಾಕರಿಸಿ';

  @override
  String get accept => 'ಸ್ವೀಕರಿಸಿ';

  @override
  String get endSession => 'ಅವಧಿ ಮುಗಿಸಿ';

  @override
  String get enterChat => 'ಚಾಟ್‌ಗೆ ಹೋಗಿ';

  @override
  String get inProgress => 'ಪ್ರಗತಿಯಲ್ಲಿ';

  @override
  String get requestDeclined => 'ವಿನಂತಿ ನಿರಾಕರಿಸಲಾಗಿದೆ';

  @override
  String get noRequests => 'ವಿನಂತಿಗಳಿಲ್ಲ';

  @override
  String get tapViewChat => 'ಚಾಟ್ ಇತಿಹಾಸ ನೋಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get tapViewCall => 'ಕರೆ ವಿವರಗಳನ್ನು ನೋಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get consultation => 'ಸಮಾಲೋಚನೆ';

  @override
  String get charged => 'ಶುಲ್ಕ';

  @override
  String get messages => 'ಸಂದೇಶಗಳು';

  @override
  String get duration => 'ಅವಧಿ';

  @override
  String get rate => 'ದರ';

  @override
  String get callDetails => 'ಕರೆ ವಿವರಗಳು';

  @override
  String get yourEarning => 'ನಿಮ್ಮ ಗಳಿಕೆ';

  @override
  String get totalCharged => 'ಒಟ್ಟು ಶುಲ್ಕ';

  @override
  String get activeDoshas => 'ಸಕ್ರಿಯ ದೋಷಗಳು';

  @override
  String get activeYogas => 'ಸಕ್ರಿಯ ಯೋಗಗಳು';

  @override
  String get allDoshas => 'ಎಲ್ಲಾ ದೋಷಗಳು';

  @override
  String get areasToNurture => 'ಪೋಷಿಸಬೇಕಾದ ಕ್ಷೇತ್ರಗಳು';

  @override
  String get basedOnPlanetStrengths => 'ಗ್ರಹ ಬಲಗಳ ಆಧಾರದ ಮೇಲೆ';

  @override
  String get basedOnTransits => 'ಪ್ರಸ್ತುತ ಸಂಚಾರಗಳ ಆಧಾರದ ಮೇಲೆ';

  @override
  String get basis => 'ಆಧಾರ';

  @override
  String get beneficAspects => 'ಶುಭ ದೃಷ್ಟಿಗಳು';

  @override
  String get bestWindows => 'ಅತ್ಯುತ್ತಮ ಅವಧಿಗಳು';

  @override
  String get bhakootAxis => 'ಭಕೂಟ ಅಕ್ಷ';

  @override
  String get cancellation => 'ರದ್ದತಿ';

  @override
  String get cancellationFactors => 'ರದ್ದತಿ ಅಂಶಗಳು';

  @override
  String get cancellations => 'ರದ್ದತಿಗಳು';

  @override
  String get challengingPeriods => 'ಸವಾಲಿನ ಅವಧಿಗಳು';

  @override
  String get characterOverview => 'ಗುಣ ಅವಲೋಕನ';

  @override
  String get combinedFertility => 'ಸಂಯೋಜಿತ ಫಲವಂತಿಕೆ';

  @override
  String get combust => 'ಅಸ್ತಂಗತ';

  @override
  String get confidence => 'ವಿಶ್ವಾಸ';

  @override
  String get contact => 'ಸಂಪರ್ಕ';

  @override
  String get copy => 'ನಕಲಿಸಿ';

  @override
  String get currentPlanetPositions => 'ಪ್ರಸ್ತುತ ಗ್ರಹ ಸ್ಥಾನಗಳು';

  @override
  String get d7Saptamsa => 'D7 ಸಪ್ತಾಂಶ';

  @override
  String get dashaSync => 'ದಶಾ ಸಿಂಕ್';

  @override
  String get daughter => 'ಮಗಳು';

  @override
  String get debilitated => 'ನೀಚ';

  @override
  String get detailedSummary => 'ವಿವರವಾದ ಸಾರಾಂಶ';

  @override
  String get discussWithAI => 'AI ಜೊತೆ ಚರ್ಚಿಸಿ';

  @override
  String get dominantPlanet => 'ಪ್ರಬಲ ಗ್ರಹ';

  @override
  String get effect => 'ಪರಿಣಾಮ';

  @override
  String get exalted => 'ಉಚ್ಚ';

  @override
  String get factors => 'ಅಂಶಗಳು';

  @override
  String get favorablePeriodAdvice => 'ಅನುಕೂಲ ಅವಧಿ';

  @override
  String get favorablePeriods => 'ಅನುಕೂಲ ಅವಧಿಗಳು';

  @override
  String get genderExplanation => 'ಲಿಂಗ ವಿವರಣೆ';

  @override
  String get genderTendency => 'ಲಿಂಗ ಪ್ರವೃತ್ತಿ';

  @override
  String get grantPermissions => 'ಅನುಮತಿಗಳನ್ನು ನೀಡಿ';

  @override
  String get health => 'ಒಟ್ಟಾರೆ ಆರೋಗ್ಯ';

  @override
  String get herMoon => 'ಅವಳ ಚಂದ್ರ';

  @override
  String get hisMoon => 'ಅವನ ಚಂದ್ರ';

  @override
  String get house => 'ಭಾವ';

  @override
  String get inFifth => '5ನೇ ಭಾವದಲ್ಲಿ';

  @override
  String get ketuContacts => 'ಕೇತು ಸಂಪರ್ಕಗಳು';

  @override
  String get key => 'ಕೀಲಿ';

  @override
  String get keyHouses => 'ಪ್ರಮುಖ ಭಾವಗಳು';

  @override
  String get keyInsights => 'ಪ್ರಮುಖ ಒಳನೋಟಗಳು';

  @override
  String get keyPlanets => 'ಪ್ರಮುಖ ಗ್ರಹಗಳು';

  @override
  String get kundliMilan => 'ಕುಂಡಲಿ ಮಿಲನ';

  @override
  String get lifeAreaPredictions => 'ಜೀವನ ಕ್ಷೇತ್ರ ಭವಿಷ್ಯಗಳು';

  @override
  String get maleficAspects => 'ಅಶುಭ ದೃಷ್ಟಿಗಳು';

  @override
  String get manifestation => 'ಪ್ರಕಟನೆ';

  @override
  String get milan => 'ಮಿಲನ';

  @override
  String get mitigation => 'ಶಮನ';

  @override
  String get moonSignCompat => 'ಚಂದ್ರ ರಾಶಿ ಹೊಂದಾಣಿಕೆ';

  @override
  String get nakshatraCompat => 'ನಕ್ಷತ್ರ ಹೊಂದಾಣಿಕೆ';

  @override
  String get navigation => 'ನ್ಯಾವಿಗೇಷನ್';

  @override
  String get nextFavorableWindow => 'ಮುಂದಿನ ಅನುಕೂಲ ಅವಧಿ';

  @override
  String get noCharts => 'ಚಕ್ರಗಳಿಲ್ಲ';

  @override
  String get noClassicalYogas => 'ಸ್ಥಿರ ಪ್ರಯತ್ನದಿಂದ ಯಶಸ್ಸು ಬರುತ್ತದೆ.';

  @override
  String get noYogasActive => 'ಈ ಚಕ್ರದಲ್ಲಿ ಸಕ್ರಿಯ ಯೋಗಗಳಿಲ್ಲ.';

  @override
  String get notesSaved => 'ಟಿಪ್ಪಣಿಗಳು ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get numberExplanation => 'ಸಂಖ್ಯೆ ವಿವರಣೆ';

  @override
  String get occupants => 'ನಿವಾಸಿಗಳು';

  @override
  String get overallVerdict => 'ಒಟ್ಟಾರೆ ತೀರ್ಪು';

  @override
  String get overlappingWindows => 'ಅತಿಕ್ರಮಿಸುವ ವಿವಾಹ ಅವಧಿಗಳು';

  @override
  String get past => 'ಗತ';

  @override
  String get pastLifeIndication => 'ಪೂರ್ವಜನ್ಮ ಸೂಚನೆ';

  @override
  String get planet => 'ಗ್ರಹ';

  @override
  String get planetPositions => 'ಗ್ರಹ ಸ್ಥಾನಗಳು';

  @override
  String get potentialStrengths => 'ಸಂಭಾವ್ಯ ಬಲಗಳು';

  @override
  String get primaryArchetype => 'ಪ್ರಾಥಮಿಕ ಮಾದರಿ';

  @override
  String get probableNumber => 'ಸಂಭವನೀಯ ಸಂಖ್ಯೆ';

  @override
  String get rahuContacts => 'ರಾಹು ಸಂಪರ್ಕಗಳು';

  @override
  String get rashi => 'ರಾಶಿ ಭವಿಷ್ಯಗಳು';

  @override
  String get recommendations => 'ಶಿಫಾರಸುಗಳು';

  @override
  String get relationshipGuidance => 'ಸಂಬಂಧ ಮಾರ್ಗದರ್ಶನ';

  @override
  String get remedies => 'ಪರಿಹಾರ';

  @override
  String get retrograde => 'ವಕ್ರ';

  @override
  String get ruledBy => 'ಅಧಿಪತಿ';

  @override
  String get running => 'ನಡೆಯುತ್ತಿದೆ';

  @override
  String get scoreComponents => 'ಅಂಕ ಘಟಕಗಳು';

  @override
  String get selectChartsForMilan => '2 ಚಕ್ರಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get selectMultiCharts => 'ಚಕ್ರಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get selectTwoCharts => 'ಹೊಂದಾಣಿಕೆಗಾಗಿ 2 ಚಕ್ರ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get sign => 'ರಾಶಿ';

  @override
  String get son => 'ಮಗ';

  @override
  String get soulCareerAlign => 'ಆತ್ಮ ↔ ವೃತ್ತಿ ಹೊಂದಾಣಿಕೆ';

  @override
  String get startKundliMilan => 'ಕುಂಡಲಿ ಮಿಲನ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get startSession => 'ಸೆಷನ್ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get strength => 'ಬಲ';

  @override
  String get strengths => 'ಬಲಗಳು';

  @override
  String get todaysTransitChart => 'ಸಂಚಾರ ಚಕ್ರ';

  @override
  String get topActiveDoshas => 'ಪ್ರಮುಖ ಸಕ್ರಿಯ ದೋಷಗಳು';

  @override
  String get topOpportunities => 'ಪ್ರಮುಖ ಕ್ಷೇತ್ರಗಳು';

  @override
  String get topRisks => 'ಪ್ರಮುಖ ಅಪಾಯಗಳು';

  @override
  String get totalChallengePenalty => 'ಒಟ್ಟು ಸವಾಲಿನ ದಂಡ';

  @override
  String get totalDoshaPenalty => 'ಒಟ್ಟು ದೋಷ ದಂಡ';

  @override
  String get transitMarriageWindows => 'ಸಂಚಾರ ವಿವಾಹ ಅವಧಿಗಳು';

  @override
  String get value => 'ಮೌಲ್ಯ';

  @override
  String get vargottama => 'ವರ್ಗೋತ್ತಮ';

  @override
  String get venusContacts => 'ಶುಕ್ರ ಸಂಪರ್ಕಗಳು';

  @override
  String get weaknesses => 'ದೌರ್ಬಲ್ಯಗಳು';

  @override
  String get worstWindows => 'ಕೆಟ್ಟ ಅವಧಿಗಳು';

  @override
  String get yogaAnalysis => 'ಯೋಗ ವಿಶ್ಲೇಷಣೆ';

  @override
  String get unlocked => 'ಅನ್‌ಲಾಕ್ ಆಗಿದೆ!';

  @override
  String get lessThanOneMin => '1 ನಿಮಿಷಕ್ಕಿಂತ ಕಡಿಮೆ ಉಳಿದಿದೆ';
}
