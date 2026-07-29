// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

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
  String get sbAverageStrength => 'सरासरी बल';

  @override
  String get sbHighestRupa => 'सर्वाधिक रुप';

  @override
  String get sbRupa => 'रुप';

  @override
  String get sbRanking => 'ग्रह क्रमवारी';

  @override
  String get sbRequired => 'आवश्यक';

  @override
  String get sbExcess => 'अतिरिक्त';

  @override
  String get sbDeficit => 'कमतरता';

  @override
  String get sbTotalShadbala => 'एकूण षड्बल';

  @override
  String get sbExplain => 'माझे ग्रह बल समजावून सांगा';

  @override
  String get sbExplainSubtitle => 'तुमच्या ग्रहांच्या बलाचा सोपा सारांश';

  @override
  String get sbInfoTitle => 'षड्बल समजून घेणे';

  @override
  String get sbQWhatIs => 'षड्बल म्हणजे काय?';

  @override
  String get sbQRupas => 'रुप म्हणजे काय?';

  @override
  String get sbQHowCalc => 'बलाची गणना कशी केली जाते?';

  @override
  String get sbQHowUse => 'याचा वापर कसा करावा';

  @override
  String get sbWhyStrong => 'का मजबूत';

  @override
  String get sbWhyWeak => 'का कमकुवत';

  @override
  String get sbDuringMahadasha => 'महादशेदरम्यान';

  @override
  String get sbEffects => 'परिणाम';

  @override
  String get sbLifeAreas => 'जीवन क्षेत्रे';

  @override
  String get sbPlanetDetails => 'ग्रह तपशील';

  @override
  String get sbBodyWhatIs => 'षड्बल (\'सहा प्रकारचे बल\') प्रत्येक ग्रहाकडे त्याचे परिणाम देण्याची किती शक्ती आहे हे, सहा स्वतंत्र बल स्रोत एकत्र करून मोजते.';

  @override
  String get sbBodyRupas => 'बल रुपांमध्ये मोजले जाते (1 रुप = 60 विरुप). प्रत्येक ग्रहाला मजबूत मानण्यासाठी किमान रुप बल आवश्यक आहे; जास्त रुप म्हणजे तो आपले परिणाम अधिक पूर्णपणे देतो.';

  @override
  String get sbBodyHowCalc => 'सहा बले एकत्र केली जातात: स्थान (स्थानिक), दिक् (दिशात्मक), काल (कालिक), चेष्टा (गतिक), नैसर्गिक (नैसर्गिक) आणि दृक् (दृष्टीसंबंधी). एकूण बलाची ग्रहाच्या आवश्यक किमानाशी तुलना करून टक्केवारी मिळवली जाते.';

  @override
  String get sbBodyHowUse => '100% पेक्षा जास्त असलेला ग्रह त्याचे परिणाम सहजपणे देतो; 100% पेक्षा कमी असल्यास आधाराची गरज असते. महत्त्वाच्या बाबींसाठी तुमच्या सर्वात मजबूत ग्रहांना प्राधान्य द्या, आणि सर्वात कमकुवत ग्रहांना उपाय आणि संयम द्या.';

  @override
  String get sbRemedyStrong => 'चांगला आधार मिळाला आहे — विशेष उपायाची गरज नाही; तुम्ही या ग्रहाचे कालावधी आत्मविश्वासाने वापरू शकता.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '${strongP} हा तुमचा सर्वात मजबूत ग्रह आहे, जो ${strongTrait} साठी उत्कृष्ट आधार देतो. ${weakP} सर्वात कमकुवत आहे आणि उपायांचा सर्वाधिक फायदा घेतो.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '${planet}चे षड्बल ${category} आहे, त्यामुळे त्याचे ${karakatva} त्यानुसार समर्थित आहेत.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return '${bala} द्वारे सर्वात मजबूत (${rupa} रुप).';
  }

  @override
  String sbWeakLine(Object bala) {
    return '${bala}मध्ये सर्वात कमकुवत, ज्यामुळे एकूण बल कमी होते.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return '${planet}च्या महादशेदरम्यान, त्याचे ${karak} पुढे येतात.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'मजबूत षड्बलासह, ${karak} नैसर्गिकरित्या समर्थित असतात.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'सामान्य षड्बलासह, ${karak}साठी जाणीवपूर्वक प्रयत्नांची गरज भासू शकते.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return '${planet}ला त्याच्या मंत्र, रत्न किंवा दानाद्वारे मजबूत करा, आणि त्याच्या कालावधीत संयमाने वागा.';
  }

  @override
  String get bhOverview => 'अवलोकन';

  @override
  String get bhDetailed => 'सविस्तर';

  @override
  String get bhavaHouses => 'भाव';

  @override
  String get bhStrengthOverview => 'भाव बळ अवलोकन';

  @override
  String get bhOverallAverage => 'एकूण भाव सरासरी';

  @override
  String get bhStrongestHouse => 'सर्वात मजबूत भाव';

  @override
  String get bhWeakestHouse => 'सर्वात कमकुवत भाव';

  @override
  String get bhBestArea => 'सर्वोत्तम जीवन क्षेत्र';

  @override
  String get bhNeedsAttention => 'लक्ष देण्याची गरज';

  @override
  String get bhSavContribution => 'SAV योगदान';

  @override
  String get bhLordCondition => 'भाव स्वामीची स्थिती';

  @override
  String get bhBenefic => 'शुभ प्रभाव';

  @override
  String get bhMalefic => 'पाप प्रभाव';

  @override
  String get bhStrengthReasons => 'हा स्कोर का';

  @override
  String get bhGoodEffects => 'चांगले परिणाम';

  @override
  String get bhChallenges => 'आव्हाने';

  @override
  String get bhRemedies => 'उपाय';

  @override
  String get bhRanking => 'भाव क्रमवारी';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'माझे भाव समजावून सांगा';

  @override
  String get bhExplainSubtitle => 'तुमच्या 12 भावांचा सोपा सारांश';

  @override
  String bhHeroSummary(Object s1, Object s2, Object strongArea, Object weakArea) {
    return 'तुमचे सर्वात मजबूत भाव ${s1} आणि ${s2} आहेत. ${strongArea} नैसर्गिकरित्या मजबूत आहे, तर ${weakArea} ला अधिक प्रयत्नांची गरज आहे.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'याचा स्वामी ${lord} ${relation} म्हणून स्थित आहे.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'या भावात ${sav} शुभ गुण (SAV) आहेत; यात असलेले ग्रह आणि त्यांच्या दृष्टी उर्वरित स्कोर ठरवतात.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'मजबूत असताना, हे ${meaning} ला आधार देते.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'कमकुवत असताना, ${meaning} साठी अतिरिक्त प्रयत्न आणि काळजीची गरज भासू शकते.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'हे बळकट करण्यासाठी याचा स्वामी ${lord} ला बळकट करा आणि या भावाच्या विषयांचा आदर करा.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'तुमचे ${house} ${strengthWord} आहे. हे ${meaning} नियंत्रित करते.';
  }

  @override
  String get kunNavamsa => 'नवमांश (D9)';

  @override
  String get kunD10 => 'दशमांश (D10)';

  @override
  String get kunPlacement => 'ग्रह स्थिती';

  @override
  String get kunHousesTitle => 'भाव तपशील';

  @override
  String get kunPlanet => 'ग्रह';

  @override
  String get kunNakshatra => 'नक्षत्र';

  @override
  String get kunPada => 'पद';

  @override
  String get kunLord => 'स्वामी';

  @override
  String get kunExplain => 'माझी कुंडली समजावून सांगा';

  @override
  String get kunExplainSubtitle => 'तुमच्या कुंडलीचा सोपा सारांश';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return '${ordinal} भाव ${meaning} नियंत्रित करतो.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return 'येथे स्थित ${planets} याचे परिणाम घडवतात.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'तुमची लग्नराशी ${asc} आहे, जी तुमचा दृष्टिकोन आणि इतर तुम्हाला प्रथम कसे पाहतात हे घडवते.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'तुमचे मन आणि भावना ${moon} मधील चंद्राचे अनुसरण करतात.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '${planet} हा तुमचा सर्वात बलवान ग्रह आहे — सहजता आणि आधाराचे नैसर्गिक क्षेत्र.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '${planet} हा तुमची सर्वाधिक परीक्षा घेणारा ग्रह आहे — येथे संयम आणि प्रयत्न फळ देतात.';
  }

  @override
  String get plNature => 'स्वभाव';

  @override
  String get plElement => 'तत्त्व';

  @override
  String get plGender => 'लिंग';

  @override
  String get plKarakatva => 'कारकत्व';

  @override
  String get plLordship => 'स्वामित्व';

  @override
  String get plStrength => 'बल';

  @override
  String get plAspectsGiven => 'दिलेली दृष्टी';

  @override
  String get plAspectsReceived => 'मिळालेली दृष्टी';

  @override
  String get plConjunction => 'युती';

  @override
  String get plHouseMeaning => 'भावाचा अर्थ';

  @override
  String get plNakshatraMeaning => 'नक्षत्राचा अर्थ';

  @override
  String get plAiInterpretation => 'AI स्पष्टीकरण';

  @override
  String get plSearchHint => 'कोणताही ग्रह शोधा';

  @override
  String get plNoResults => 'कोणताही ग्रह सापडला नाही';

  @override
  String get plBenefic => 'शुभ';

  @override
  String get plMalefic => 'पाप';

  @override
  String get plMale => 'पुरुष';

  @override
  String get plFemale => 'स्त्री';

  @override
  String get plNeutralGender => 'नपुंसक';

  @override
  String get plOwnSign => 'स्व राशी';

  @override
  String get plFriend => 'मित्र राशी';

  @override
  String get plEnemy => 'शत्रू राशी';

  @override
  String get plNeutral => 'सम';

  @override
  String get sumEther => 'आकाश';

  @override
  String plLordOfHouses(Object houses) {
    return 'भाव ${houses}चे स्वामी';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return '${nakLord} द्वारे शासित, ${trait} आणते.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '${planet}, ${sign} राशीत, ${house} भावात स्थित आहे.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'याचे मुख्य कारकत्व — ${karak} — येथे चांगल्या प्रकारे समर्थित आहेत.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'याचे मुख्य कारकत्व — ${karak} — यासाठी येथे जाणीवपूर्वक प्रयत्नांची गरज भासू शकते.';
  }

  @override
  String plAiExalted(Object planet) {
    return '${planet} उच्च राशीत आहे, जो त्याचे सर्वोत्तम परिणाम देतो.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '${planet} नीच राशीत आहे आणि त्याचे परिणाम देण्यासाठी आधाराची गरज आहे.';
  }

  @override
  String plAiCombust(Object planet) {
    return '${planet} अस्त आहे, त्यामुळे तो सूर्याच्या तीव्रतेत कमी उघडपणे कार्य करतो.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '${planet} वर्गोत्तम आहे — ही मजबूत स्थिती नवमांशातही पुनरावृत्ती होते.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '${planet} वक्री आहे, जो त्याची ऊर्जा आतल्या दिशेने वळवून ती तीव्र करतो.';
  }

  @override
  String get plHouse1 => 'स्व, शरीर, व्यक्तिमत्त्व आणि जीवनशक्ती';

  @override
  String get plHouse2 => 'धन, कुटुंब, वाणी आणि अन्न';

  @override
  String get plHouse3 => 'धैर्य, भावंडे, संवाद आणि छोटे प्रवास';

  @override
  String get plHouse4 => 'घर, आई, सुखसोयी, मालमत्ता आणि आंतरिक शांती';

  @override
  String get plHouse5 => 'संतती, सर्जनशीलता, बुद्धी, प्रेम आणि पूर्वपुण्य';

  @override
  String get plHouse6 => 'आरोग्य, शत्रू, कर्ज, सेवा आणि दैनंदिन काम';

  @override
  String get plHouse7 => 'विवाह, भागीदारी आणि व्यावसायिक संबंध';

  @override
  String get plHouse8 => 'आयुष्य, परिवर्तन, रहस्ये आणि वारसा';

  @override
  String get plHouse9 => 'भाग्य, धर्म, उच्च शिक्षण, गुरू आणि वडील';

  @override
  String get plHouse10 => 'करिअर, प्रतिष्ठा, अधिकार आणि सार्वजनिक कर्म';

  @override
  String get plHouse11 => 'लाभ, उत्पन्न, मित्र, नेटवर्क आणि पूर्ण झालेल्या इच्छा';

  @override
  String get plHouse12 => 'हानी, खर्च, परदेश, आध्यात्मिकता आणि मोक्ष';

  @override
  String get sumVeryStrong => 'अत्यंत मजबूत';

  @override
  String get sumStrong => 'मजबूत';

  @override
  String get sumAverage => 'सरासरी';

  @override
  String get sumWeak => 'कमकुवत';

  @override
  String get sumNeedsAttention => 'लक्ष देण्याची गरज';

  @override
  String get sumFire => 'अग्नि';

  @override
  String get sumEarth => 'पृथ्वी';

  @override
  String get sumAir => 'वायू';

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
  String get sumDirNE => 'ईशान्य';

  @override
  String get sumDirNW => 'वायव्य';

  @override
  String get sumDirSE => 'आग्नेय';

  @override
  String get sumDirSW => 'नैऋत्य';

  @override
  String get sumSnapshotTitle => 'तुमची ज्योतिष झलक';

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
  String get sumHighlights => 'महत्त्वाचे मुद्दे';

  @override
  String get sumStrongPlanet => 'सर्वात मजबूत ग्रह';

  @override
  String get sumWeakPlanet => 'सर्वात कमकुवत ग्रह';

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
  String get sumQuickInsights => 'त्वरित माहिती';

  @override
  String get sumSpirituality => 'अध्यात्म';

  @override
  String get sumTimezone => 'वेळ क्षेत्र';

  @override
  String get sumAyanamsa => 'अयनांश';

  @override
  String get sumCalendarType => 'पंचांग';

  @override
  String get sumCopied => 'क्लिपबोर्डवर कॉपी केले';

  @override
  String get sumNatureFire => 'तुमचा स्वभाव धाडसी, उत्साही आणि आघाडीवर राहून नेतृत्व करणारा आहे.';

  @override
  String get sumNatureEarth => 'तुमचा स्वभाव व्यावहारिक, स्थिर आणि शिस्तबद्ध आहे, जो टिकाऊ परिणाम घडवतो.';

  @override
  String get sumNatureAir => 'तुमचा स्वभाव जिज्ञासू, संवादशील आणि बौद्धिक आहे, जो नवीन कल्पनांमध्ये बहरतो.';

  @override
  String get sumNatureWater => 'तुमचा स्वभाव सहज-प्रवृत्त, भावनिक आणि सहानुभूतीशील आहे, खोल आंतरिक संवेदनशीलतेसह.';

  @override
  String get sumGradePhraseExcellent => 'भक्कमपणे समर्थित — सातत्यपूर्ण प्रयत्नाने अनुकूल परिणाम मिळण्याची शक्यता आहे.';

  @override
  String get sumGradePhraseGood => 'चांगल्या प्रकारे समर्थित — थोड्या काळजीने साधारणपणे सकारात्मक.';

  @override
  String get sumGradePhraseAverage => 'संमिश्र समर्थन — परिणाम प्रयत्न आणि वेळेवर अवलंबून असतात.';

  @override
  String get sumGradePhraseWeak => 'लक्ष देण्याची गरज — संयम आणि उपाय येथे मदत करतात.';

  @override
  String get kDefCombust => 'सूर्याच्या अगदी जवळ असलेला ग्रह, त्यामुळे त्याची ऊर्जा \'जळून\' कमकुवत होते.';

  @override
  String get kDefRetrograde => 'मागे सरकत असल्यासारखा दिसणारा ग्रह; याचे परिणाम आतल्या दिशेने वळून तीव्र होतात.';

  @override
  String get kDefNakshatra => 'चंद्र आणि ग्रह ज्यातून प्रवास करतात अशा 27 नक्षत्र मंडळांपैकी एक.';

  @override
  String get kDefVargottama => 'जन्मकुंडली (D1) आणि नवमांश (D9) या दोन्हीमध्ये एकाच राशीत असणारा ग्रह — बळाचे लक्षण.';

  @override
  String get kDefOwnSign => 'स्वतःच्या मालकीच्या राशीत बसलेला ग्रह, जिथे तो घरच्यासारखा वाटतो आणि स्थिर परिणाम देतो.';

  @override
  String get kDefExalted => 'स्वतःच्या सर्वाधिक बळाच्या राशीत असलेला ग्रह, जो सर्वोत्तम परिणाम देतो.';

  @override
  String get kDefDebilitated => 'स्वतःच्या सर्वात कमकुवत राशीत असलेला ग्रह, जिथे तो परिणाम देण्यासाठी संघर्ष करतो.';

  @override
  String get kDefMooltrikona => 'ग्रहाच्या स्वतःच्या राशीतील एक विशेष भाग, जिथे तो विशेषतः शक्तिशाली असतो.';

  @override
  String get kDefAscendant => 'जन्माच्या वेळी पूर्व क्षितिजावर उगवणारी रास — लग्न, कुंडलीचा पाया.';

  @override
  String get kDefMahadasha => 'आयुष्याच्या दीर्घ कालावधीला रंग देणारा प्रमुख ग्रह काळ.';

  @override
  String get kDefAntardasha => 'महादशेतील एक उप-काळ, जो तिचे परिणाम सूक्ष्मपणे समायोजित करतो.';

  @override
  String get kDefPada => 'ग्रह ज्या नक्षत्रात असतो त्याच्या चार चरणांपैकी एक.';

  @override
  String get aspGivesAspectTo => 'दृष्टी टाकतो';

  @override
  String get aspReceivesAspectFrom => 'दृष्टी प्राप्त करतो';

  @override
  String get aspInfluences => 'प्रभावित करतो';

  @override
  String get aspNoInfluence => 'कोणताही प्रभाव नाही';

  @override
  String get aspNoAspect => 'कोणतीही दृष्टी नाही';

  @override
  String get aspPresent => 'उपस्थित';

  @override
  String get aspAbsent => 'अनुपस्थित';

  @override
  String get aspNotPresent => 'उपस्थित नाही';

  @override
  String get aspSpecialAspect => 'विशेष दृष्टी';

  @override
  String get aspAspectWord => 'दृष्टी';

  @override
  String get aspTotalGiven => 'दिलेली दृष्टी';

  @override
  String get aspTotalReceived => 'प्राप्त दृष्टी';

  @override
  String get aspStrongestInfluence => 'सर्वात प्रबळ प्रभाव';

  @override
  String get aspMedium => 'मध्यम';

  @override
  String get aspAspectPresent => 'दृष्टी उपस्थित';

  @override
  String get aspReason => 'कारण';

  @override
  String get aspBoth => 'दोन्ही';

  @override
  String get aspTargetHouse => 'लक्ष्य भाव';

  @override
  String get aspTargetSign => 'लक्ष्य रास';

  @override
  String get aspLagnaReceives => 'लग्नाला दृष्टी प्राप्त होते';

  @override
  String get aspNoAspectFrom => 'यांच्याकडून कोणतीही दृष्टी नाही';

  @override
  String get aspPlanetToPlanet => 'ग्रहापासून ग्रहापर्यंत';

  @override
  String get aspSignToSign => 'राशीपासून राशीपर्यंत';

  @override
  String get aspCombinedAspect => 'संयुक्त दृष्टी';

  @override
  String get aspGrahaAspect => 'ग्रह दृष्टी';

  @override
  String get aspRashiAspect => 'राशी दृष्टी';

  @override
  String get aspInfoTitle => 'दृष्टी (Drishti) समजून घेणे';

  @override
  String get aspQGraha => 'ग्रह दृष्टी म्हणजे काय?';

  @override
  String get aspQRashi => 'राशी दृष्टी म्हणजे काय?';

  @override
  String get aspQDiff => 'दोघांमधील फरक';

  @override
  String get aspQPredict => 'दृष्टी भविष्यवाणीवर कसा परिणाम करते';

  @override
  String get aspGrahaBody => 'ग्रह दृष्टी म्हणजे एखादा ग्रह त्याच्या स्थानावरून टाकत असलेली दृष्टी. प्रत्येक ग्रह स्वतःच्या स्थानावरून 7व्या भावावर/ग्रहावर पूर्ण दृष्टी टाकतो (थेट, समोरासमोरचा प्रभाव). याशिवाय, मंगळ 4थ्या आणि 8व्या वर, गुरू 5व्या आणि 9व्या वर, आणि शनी 3ऱ्या आणि 10व्या वर दृष्टी टाकतो. राहू आणि केतूला सहसा 5वी, 7वी आणि 9वी दृष्टी दिली जाते. एखाद्या ग्रहाची दृष्टी ज्या ग्रहावर किंवा भावावर पडते त्याला स्वतःच्या स्वभावाचा रंग देते.';

  @override
  String get aspRashiBody => 'राशी दृष्टी ही जैमिनी ज्योतिषातील राशी-ते-राशी दृष्टी आहे, जी तिथे कोणते ग्रह बसले आहेत यावर अवलंबून नसते. चर राशी स्थिर राशींवर दृष्टी टाकतात (शेजारील वगळता), स्थिर राशी चर राशींवर दृष्टी टाकतात (शेजारील वगळता), आणि द्विस्वभाव राशी इतर द्विस्वभाव राशींवर दृष्टी टाकतात. याचा वापर प्रामुख्याने जैमिनी भविष्यवाणीत आणि भावांमधील संबंध जोखण्यासाठी केला जातो.';

  @override
  String get aspDiffBody => 'ग्रह दृष्टी एखाद्या ग्रहाद्वारे टाकली जाते आणि तो ग्रह कुठे आहे यावर अवलंबून असते. राशी दृष्टी राशीची स्वतःची असते आणि त्यात जे काही असेल त्याला लागू होते. ग्रह दृष्टी दिशात्मक असते (ग्रह A ग्रह Bकडे पाहतो), तर राशी दृष्टी सहसा राशींमध्ये परस्पर असते. जेव्हा दोन्ही एकाच लक्ष्याकडे निर्देश करतात, तेव्हा प्रभाव विशेषतः प्रबळ असतो.';

  @override
  String get aspPredictBody => 'एखादी दृष्टी दाखवते की एखादा ग्रह त्याच्या स्वतःच्या भावाबाहेर कुठे आपला प्रभाव विस्तारतो. एक शुभ दृष्टी (गुरू, शुक्र, चांगल्या स्थितीत असलेला चंद्र/बुध) लक्ष्याला आधार देते आणि संरक्षण करते; एक अशुभ दृष्टी (शनी, मंगळ, सूर्य, राहू, केतू) त्यावर दबाव आणू शकते, विलंब करू शकते किंवा आव्हान देऊ शकते. कोणते ग्रह एखाद्या भावावर किंवा ग्रहावर दृष्टी टाकतात हे वाचल्याने निकाल का अशा प्रकारे दिसतात हे स्पष्ट होते.';

  @override
  String get aspTraitSun => 'अधिकार, नेतृत्व आणि जीवनशक्ती';

  @override
  String get aspTraitMoon => 'भावनिक खोली, सुख आणि अंतर्ज्ञान';

  @override
  String get aspTraitMars => 'ऊर्जा, धैर्य आणि जोम';

  @override
  String get aspTraitMercury => 'संवाद, बुद्धी आणि जुळवून घेण्याची क्षमता';

  @override
  String get aspTraitJupiter => 'ज्ञान, वृद्धी आणि सौभाग्य';

  @override
  String get aspTraitVenus => 'प्रेम, सौहार्द आणि सुखसोयी';

  @override
  String get aspTraitSaturn => 'शिस्त, जबाबदारी आणि धीराने मिळणारे, कधीकधी उशिरा मिळणारे, यश';

  @override
  String get aspTraitRahu => 'महत्त्वाकांक्षा, तीव्रता आणि अपारंपरिक वळणे';

  @override
  String get aspTraitKetu => 'विरक्ती, आध्यात्मिकता आणि अचानक बदल';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '${planet} ${targets}वर प्रभाव टाकत आहे. यामुळे या ग्रहांनी दर्शवलेल्या क्षेत्रांमध्ये ${trait} येऊ शकते.';
  }

  @override
  String aspAiNone(Object planet) {
    return '${planet} इथे इतर कोणत्याही ग्रहावर विशेष दृष्टी टाकत नाही; याचा प्रभाव प्रामुख्याने स्वतःच्या राशी आणि भावाद्वारेच कार्य करतो.';
  }

  @override
  String get avSummaryTitle => 'अष्टकवर्ग सारांश';

  @override
  String get avOverallScore => 'एकूण SAV स्कोअर';

  @override
  String get avOverallRating => 'एकूण रेटिंग';

  @override
  String get avStrongestSigns => 'सर्वात मजबूत राशी';

  @override
  String get avWeakestSigns => 'सर्वात कमकुवत राशी';

  @override
  String get avScore => 'स्कोअर';

  @override
  String get avMeaning => 'अर्थ';

  @override
  String get avGrid => 'ग्रिड';

  @override
  String get avList => 'यादी';

  @override
  String get avOverallScoreShort => 'एकूण स्कोअर';

  @override
  String get avNatalSignScore => 'जन्म रास स्कोअर';

  @override
  String get avBestSigns => 'सर्वोत्तम राशी';

  @override
  String get avWeakSigns => 'कमकुवत राशी';

  @override
  String get avAiInterpretation => 'AI विश्लेषण';

  @override
  String get avVeryGood => 'खूप चांगले';

  @override
  String get avVeryWeak => 'खूप कमकुवत';

  @override
  String get avTotalSav => 'एकूण SAV';

  @override
  String get avPlanetContributions => 'ग्रह योगदान';

  @override
  String get avFinance => 'आर्थिक';

  @override
  String get avOverallStrength => 'एकूण शक्ती';

  @override
  String get avWhatDoesThisMean => 'याचा अर्थ काय आहे?';

  @override
  String get avSimple => 'सोपे';

  @override
  String get avAdvanced => 'सविस्तर';

  @override
  String get avInfoTitle => 'अष्टकवर्ग समजून घेणे';

  @override
  String get avStrong => 'मजबूत';

  @override
  String get avModerate => 'मध्यम';

  @override
  String get avQWhatIsAv => 'अष्टकवर्ग म्हणजे काय?';

  @override
  String get avQWhatIsSav => 'SAV म्हणजे काय?';

  @override
  String get avQWhatIsBav => 'BAV म्हणजे काय?';

  @override
  String get avQHowToRead => 'हे स्कोअर कसे वाचावे';

  @override
  String get avQSavVsBav => 'SAV वि. BAV';

  @override
  String get avABody => 'अष्टकवर्ग ही वैदिक ज्योतिषातील गुणांवर आधारित एक शक्ती प्रणाली आहे. प्रत्येक ग्रह आपल्या स्थानानुसार बारा राशींना शुभ गुण (बिंदू, ज्यांना रेखा असेही म्हणतात) देतो. एखाद्या राशीत जास्त गुण असल्यास, संबंधित ग्रह दशा आणि गोचरादरम्यान जीवनाच्या त्या क्षेत्राला अधिक सुलभ आधार मिळतो.';

  @override
  String get avSavBody => 'SAV (सर्व अष्टकवर्ग) प्रत्येक राशीसाठी सातही ग्रहांचे गुण एकत्र करतो. हे प्रत्येक राशीसाठी एकच शक्ती स्कोअर देते, त्यामुळे तुमच्या पत्रिकेत कोणत्या राशी — आणि त्यांची भावस्थाने — सर्वाधिक समर्थित आहेत हे तुम्ही लगेच पाहू शकता.';

  @override
  String get avBavBody => 'BAV (भिन्न अष्टकवर्ग) एका ग्रहाचे गुण बारा राशींमध्ये दाखवतो. एखादा विशिष्ट ग्रह कोणत्या राशींना सर्वाधिक आधार देतो हे हे दर्शवते, जे त्या ग्रहाची दशा किंवा गोचर सक्रिय असताना महत्त्वाचे ठरते.';

  @override
  String get avHowToReadBody => 'जास्त संख्या चांगली असते. SAV साठी, सरासरी राशीला सुमारे 28 गुण मिळतात — 30 पेक्षा जास्त मजबूत आणि 25 पेक्षा कमी असल्यास काळजी घेणे आवश्यक आहे. BAV साठी, प्रत्येक राशी 0 ते 8 दरम्यान असते, ज्यात 4 सरासरी मानले जाते. महत्त्वाच्या कामांसाठी तुमच्या सर्वात मजबूत राशींना प्राधान्य द्या, आणि सर्वात कमकुवत राशींच्या बाबतीत संयम व शिस्त बाळगा.';

  @override
  String get avSavVsBavBody => 'SAV हा सर्व ग्रहांचा एकत्रित एकूण असून तो राशीची एकूण शक्ती दर्शवतो. BAV हे एका ग्रहाचे योगदान असून तो कोणता ग्रह त्या राशीला आधार देतो हे दर्शवतो. मोठे चित्र समजून घेण्यासाठी SAV वापरा, आणि राशीच्या शक्तीला कोणता ग्रह चालना देतो हे समजून घेण्यासाठी BAV पहा.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'तुमची पत्रिका ${s1}, ${s2} आणि ${s3} मध्ये सर्वात मजबूत आहे. या राशी ग्रह दशा आणि गोचरादरम्यान अधिक चांगला आधार देतात. ${weak} ला सध्या सर्वात कमी आधार आहे, त्यामुळे त्याच्याशी संबंधित बाबींमध्ये संयम आणि शिस्त उपयुक्त ठरते.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '${planet} ${s1} आणि ${s2} द्वारे सर्वात मजबूतपणे कार्य करतो. या राशी सक्रिय झाल्यावर ${planet} शी संबंधित बाबींमध्ये सुधारणा होते.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'तुमच्या सर्वात मजबूत राशी ${s1} आणि ${s2} आहेत — ग्रह यांतून गोचर करताना महत्त्वाच्या सुरुवातींसाठी यांना प्राधान्य द्या.';
  }

  @override
  String avInsightWeak(Object s1) {
    return '${s1} ला सर्वात कमी आधार आहे — त्याच्या बाबींमध्ये काळजीपूर्वक पुढे जा आणि जास्त बांधिलकी टाळा.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '${planet} कडे सर्वाधिक गुण आहेत, त्यामुळे त्याचे विषय तुमच्या जीवनात चांगल्या प्रकारे समर्थित आहेत.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '${planet} कडे सर्वात कमी गुण आहेत आणि उपाय व जाणीवपूर्वक प्रयत्नांमुळे त्याला सर्वाधिक फायदा होतो.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'तुमच्या सरासरी ${avg} गुणांपेक्षा जास्त स्कोअर करणाऱ्या राशी सहसा अधिक सुलभ आणि विश्वासार्ह परिणाम देतात.';
  }

  @override
  String get fcKey => 'की';

  @override
  String get fcActions => 'क्रिया';

  @override
  String get fcCautions => 'सावधानता';

  @override
  String get fc12House => '12 भाव';

  @override
  String get fcProbabilities => 'शक्यता';

  @override
  String get fcHousesCaps => 'भाव';

  @override
  String get fcCritical => 'गंभीर';

  @override
  String get fcFlags => 'चिन्हे';

  @override
  String get fcAnalysis => 'विश्लेषण';

  @override
  String get fcConfidence => 'आत्मविश्वास';

  @override
  String get fcQualityCaps => 'गुणवत्ता';

  @override
  String get fcIncomeVs => 'उत्पन्न विरुद्ध';

  @override
  String get fcExpense => 'खर्च';

  @override
  String get fcFinance => 'वित्त';

  @override
  String get fcNetBalance => 'निव्वळ शिल्लक';

  @override
  String get fcSignature => 'स्वाक्षरी';

  @override
  String get fcBestTimeForIncome => 'उत्पन्नासाठी सर्वोत्तम वेळ';

  @override
  String get fcExpenseCaution => 'खर्च सावधानता';

  @override
  String get fcIncomeCaps => 'उत्पन्न';

  @override
  String get fcExpenseCaps => 'खर्च';

  @override
  String get fcRelationships => 'नाती';

  @override
  String get fcAreasCaps => 'क्षेत्रे';

  @override
  String get fcBestForMeetings => 'बैठकांसाठी सर्वोत्तम';

  @override
  String get fcOpportunitiesVs => 'संधी विरुद्ध';

  @override
  String get fcRisks => 'धोके';

  @override
  String get fcOutlook => 'दृष्टीकोन';

  @override
  String get fcAction => 'कृती';

  @override
  String get fcProtect => 'संरक्षण';

  @override
  String get fcOpportunityCaps => 'संधी';

  @override
  String get fcRiskCaps => 'धोका';

  @override
  String get fcTopOpportunities => 'शीर्ष संधी';

  @override
  String get fcTopRisks => 'शीर्ष धोके';

  @override
  String get fcTiming => 'वेळ';

  @override
  String get fcWindows => 'विंडो';

  @override
  String get fcSlotsCaps => 'स्लॉट्स';

  @override
  String get fcBestWindows => 'सर्वोत्तम विंडो';

  @override
  String get fcWorstWindows => 'सर्वात वाईट विंडो';

  @override
  String get fcAvoid => 'टाळा';

  @override
  String get fcHouse => 'भाव';

  @override
  String get fcFailed => 'अयशस्वी';

  @override
  String get lifeCareer => 'करिअर';

  @override
  String get lifeHealth => 'आरोग्य';

  @override
  String get lifeWealth => 'संपत्ती';

  @override
  String get lifeFamily => 'कुटुंब';

  @override
  String get lifeMind => 'मन';

  @override
  String get lifeEgo => 'अहंकार';

  @override
  String get lifeAggression => 'आक्रमकता';

  @override
  String get lifeConflict => 'संघर्ष';

  @override
  String get rashiElement => 'तत्व';

  @override
  String get rashiQuality => 'गुण';

  @override
  String get rashiLuckyColor => 'शुभ रंग';

  @override
  String get rashiLuckyDay => 'शुभ दिवस';

  @override
  String get rashiLuckyNumber => 'शुभ अंक';

  @override
  String get rashiGemstone => 'रत्न';

  @override
  String get rashiBody => 'शरीर';

  @override
  String get gocharTodaysTransitChart => 'आजचा गोचर तक्ता';

  @override
  String get gocharTransit => 'गोचर';

  @override
  String get thisWeek => 'या आठवड्यात';

  @override
  String get thisMonth => 'या महिन्यात';

  @override
  String get best => 'सर्वोत्तम';

  @override
  String get worst => 'सर्वात वाईट';

  @override
  String get avg => 'avg';

  @override
  String get favorableLoveWindowsLabel => 'अनुकूल प्रेम कालावधी';

  @override
  String get lordLabel => 'स्वामी';

  @override
  String get lordPlacementLabel => 'स्वामीचे स्थान';

  @override
  String get lordDignityLabel => 'स्वामीची अवस्था';

  @override
  String get categoriesSuffix => 'श्रेणी';

  @override
  String get coreBlockerLabel => 'मुख्य अडथळा';

  @override
  String get coreGiftLabel => '✦ मुख्य देणगी';

  @override
  String get coreThemeLabel => '● मुख्य सूत्र';

  @override
  String dominantLabel(Object value) {
    return 'प्रमुख: ${value}';
  }

  @override
  String get karakasSuffix => 'कारक';

  @override
  String get protectiveLabel => 'संरक्षक';

  @override
  String secondaryLabel(Object value) {
    return ' · दुय्यम: ${value}';
  }

  @override
  String get tagCore => 'मुख्य';

  @override
  String get debtScoresHeader => '📉 कर्ज गुण';

  @override
  String get debtCurrentLoadStat => 'सध्याचे\nकर्जभार';

  @override
  String get debtRecoveryCapacityStat => 'परतफेड\nक्षमता';

  @override
  String get debtIntensityStat => 'तीव्रता';

  @override
  String get debtDefaultRiskStat => 'थकबाकी धोका';

  @override
  String get debtProfileTitle => 'कर्ज प्रोफाइल';

  @override
  String get debtKarmaLabel => 'कर्म';

  @override
  String get debtPersonalityLabel => 'व्यक्तिमत्त्व';

  @override
  String get debtPhaseLabel => 'टप्पा';

  @override
  String get debtPrimaryCategoryLabel => 'मुख्य श्रेणी';

  @override
  String get debtWord => 'कर्ज';

  @override
  String get debtYogasTitle => 'कर्ज योग';

  @override
  String get debtCreatingLabel => 'कर्ज-निर्माण';

  @override
  String get debtClearingLabel => 'कर्ज-मुक्ती';

  @override
  String get yearlyDebtTitle => 'वार्षिक कर्ज';

  @override
  String get debtRepaymentTitle => 'परतफेड';

  @override
  String get debtDangerPeriodsTitle => 'धोक्याचे कालावधी';

  @override
  String get debtDefaultPctStat => 'थकबाकी %';

  @override
  String get debtBankruptcyPctStat => 'दिवाळखोरी %';

  @override
  String get debtChronicPctStat => 'दीर्घकालीन %';

  @override
  String get debtResilienceStat => 'लवचिकता';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'परतफेड: ${pct}% · कालावधी: ${years} वर्षे';
  }

  @override
  String get debtFreeWindowLabel => '🎯 कर्जमुक्त कालावधी';

  @override
  String debtFreeYear(Object year) {
    return 'वर्ष ${year}';
  }

  @override
  String get legalScoresHeader => '⚖️ कायदेशीर गुण';

  @override
  String get legalVulnerabilityStat => 'कायदेशीर\nअसुरक्षितता';

  @override
  String get legalVictoryPotentialStat => 'विजय\nक्षमता';

  @override
  String get legalConflictStat => 'संघर्ष';

  @override
  String get legalResolutionStat => 'निवारण';

  @override
  String get legalProfileTitle => 'कायदेशीर प्रोफाइल';

  @override
  String get legalKarmaTypeLabel => 'कर्म प्रकार';

  @override
  String get legalConflictStyleLabel => 'संघर्ष शैली';

  @override
  String get legalStrategyLabel => 'रणनीती';

  @override
  String get legalCaseDurationLabel => 'खटला कालावधी';

  @override
  String get legalCurrentStatusLabel => 'सध्याची स्थिती';

  @override
  String get legalWord => 'कायदेशीर';

  @override
  String get legalYogasTitle => 'कायदेशीर योग';

  @override
  String get legalDisputePressureLabel => 'वाद दबाव';

  @override
  String get legalProtectionLabel => 'कायदेशीर संरक्षण';

  @override
  String get legalStressTrendTitle => 'कायदेशीर तणाव';

  @override
  String get legalVisibleEnemiesStat => 'दृश्य शत्रू';

  @override
  String get legalHiddenEnemiesStat => 'गुप्त शत्रू';

  @override
  String get legalCriminalRiskStat => 'गुन्हेगारी धोका';

  @override
  String get legalFalseAccusationStat => 'खोटा आरोप';

  @override
  String get legalContractKarmaTitle => 'करार कर्म';

  @override
  String get legalDocumentationLabel => 'दस्तऐवजीकरण';

  @override
  String get legalFinePrintAwareLabel => 'बारीक अटींची जाणीव';

  @override
  String get legalNegotiationSkillLabel => 'वाटाघाटी कौशल्य';

  @override
  String get legalSignatureCautionLabel => 'स्वाक्षरी सावधगिरी';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'लवचिकता: ${pct}/100';
  }

  @override
  String get legalVictoryWord => 'विजय';

  @override
  String get legalAnalysisSuffix => 'विश्लेषण';

  @override
  String get legalAsPlaintiff => 'फिर्यादी म्हणून';

  @override
  String get legalAsDefendant => 'प्रतिवादी म्हणून';

  @override
  String get legalWinProbability => 'जिंकण्याची शक्यता';

  @override
  String get legalDisputeWord => 'वाद';

  @override
  String get lifepathScoresHeader => '🌟 जीवनमार्ग गुण';

  @override
  String get lifepathDharmaClarityStat => 'धर्म\nस्पष्टता';

  @override
  String get lifepathFortuneBaselineStat => 'भाग्य\nआधाररेखा';

  @override
  String get lifepathCoherenceStat => 'जीवनमार्ग\nसुसंगती';

  @override
  String get lifepathKarmaStat => 'कर्म';

  @override
  String get lifepathSpiritualStat => 'आध्यात्मिक';

  @override
  String get lifepathFameStat => 'कीर्ती';

  @override
  String get lifepathSoulContractTitle => 'आत्मा करार';

  @override
  String get lifepathAtmakarakaLabel => 'आत्मकारक';

  @override
  String get lifepathAkFocusLabel => 'AK केंद्र';

  @override
  String get lifepathSoulPurposeLabel => 'आत्म्याचा उद्देश';

  @override
  String get lifepathLifeChapterLabel => 'जीवन अध्याय';

  @override
  String get lifepathPrimaryDomainLabel => 'मुख्य क्षेत्र';

  @override
  String get lifepathLeadershipStat => 'नेतृत्व';

  @override
  String get lifepathWisdomTeachStat => 'ज्ञान/अध्यापन';

  @override
  String get lifepathServiceStat => 'सेवा';

  @override
  String get lifepathHealingStat => 'उपचार';

  @override
  String get lifepathFortuneYogasTitle => 'भाग्य योग';

  @override
  String get lifepathLuckBlocksLabel => 'भाग्य अडथळे';

  @override
  String get lifepathFortuneBoostersLabel => 'भाग्यवर्धक';

  @override
  String get lifepathFortuneTrendTitle => 'भाग्य कल';

  @override
  String get lifepathGoldenWindowsTitle => 'सुवर्ण कालावधी ★';

  @override
  String get lifepathTransformationTitle => 'परिवर्तन';

  @override
  String get lifepathMilestonesTitle => 'जीवनातील टप्पे';

  @override
  String get lifepathKarmicLessonsTitle => 'कार्मिक धडे';

  @override
  String get lifepathRahuGrowthLabel => 'राहू वृद्धी';

  @override
  String get lifepathKetuSurrenderLabel => 'केतू समर्पण';

  @override
  String get lifepathSaturnLessonLabel => 'शनी धडा';

  @override
  String get lifepathLifeDifficultyLabel => 'जीवन अडचण';

  @override
  String get lifepathSoulExperienceTitle => '★ आत्मा अनुभवण्यासाठी आला';

  @override
  String get lifepathBlessingsTitle => '● आशीर्वाद';

  @override
  String get lifepathLifeWord => 'जीवन';

  @override
  String get lifepathArchetypeSuffix => 'आदर्श';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'पूर्तता: ${pct}%';
  }

  @override
  String get lifepathDestinyVsWord => 'नियती विरुद्ध';

  @override
  String get lifepathFreeWillSuffix => 'स्वेच्छा';

  @override
  String get lifepathDestinyStat => 'नियती';

  @override
  String get lifepathFreeWillStat => 'स्वेच्छा';

  @override
  String get pastlifeScoresHeader => '🔮 पूर्वजन्म गुण';

  @override
  String get pastlifeSignatureStrengthStat => 'स्वाक्षरी\nबळ';

  @override
  String get pastlifeCarryForwardStat => 'पुढे\nनेलेले';

  @override
  String get pastlifeMasteryPreservedStat => 'जपलेले\nप्रावीण्य';

  @override
  String get pastlifeUnfinishedStat => 'अपूर्ण';

  @override
  String get pastlifeKarmicDebtStat => 'कार्मिक कर्ज';

  @override
  String get pastlifeProfileTitle => 'पूर्वजन्म प्रोफाइल';

  @override
  String get pastlifeThemeLabel => 'सूत्र';

  @override
  String get pastlifeProfessionLabel => 'व्यवसाय';

  @override
  String get pastlifeSocialStandingLabel => 'सामाजिक स्थान';

  @override
  String get pastlifeRegionLabel => 'प्रदेश';

  @override
  String get pastlifeSpiritualLevelLabel => 'आध्यात्मिक पातळी';

  @override
  String get pastlifeGenderLabel => 'लिंग';

  @override
  String get pastlifeWealthLevelLabel => 'संपत्ती पातळी';

  @override
  String get pastlifeFamilyRoleLabel => 'कुटुंबातील भूमिका';

  @override
  String get pastlifeSkillsCarriedTitle => '★ पुढे नेलेली कौशल्ये';

  @override
  String get pastlifeNaturalAttractionsTitle => '● नैसर्गिक आकर्षणे';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ अस्पष्ट भीती';

  @override
  String get pastlifeMagneticPullsTitle => '→ चुंबकीय ओढ';

  @override
  String get pastlifeRelationshipStat => 'नातेसंबंध';

  @override
  String get pastlifeFinancialStat => 'आर्थिक';

  @override
  String get pastlifeServiceStat => 'सेवा';

  @override
  String get pastlifeDharmicStat => 'धार्मिक';

  @override
  String get pastlifeOnRelationsStat => 'नात्यांवर';

  @override
  String get pastlifeOnCareerStat => 'करिअरवर';

  @override
  String get pastlifeOnHealthStat => 'आरोग्यावर';

  @override
  String get pastlifeOnSpiritualStat => 'आध्यात्मावर';

  @override
  String get pastlifeKarmicResolutionTitle => 'कार्मिक निवारण';

  @override
  String get pastlifePrimaryPathLabel => 'मुख्य मार्ग';

  @override
  String get pastlifeSecondaryPathLabel => 'दुय्यम मार्ग';

  @override
  String get pastlifeClearingProgressLabel => 'मुक्ती प्रगती';

  @override
  String get pastlifeRemainingWorkLabel => 'उर्वरित काम';

  @override
  String get pastlifeDebtTimelineLabel => 'कर्ज कालावधी';

  @override
  String get pastlifeMemoryAccessStat => 'स्मृती प्रवेश';

  @override
  String get pastlifeDreamVisitsStat => 'स्वप्न भेटी';

  @override
  String get pastlifeDejaVuStat => 'देजा वू';

  @override
  String get pastlifeRegressionFitStat => 'रिग्रेशन योग्यता';

  @override
  String get pastlifeActivationTitle => 'पूर्वजन्म सक्रियता';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'परिपक्वता: ${maturity} · स्थिती: ${status}';
  }

  @override
  String get pastlifeKetuWord => 'केतू';

  @override
  String get pastlifePastMasterySuffix => 'पूर्व प्रावीण्य';

  @override
  String get pastlifeKetuMasteredLabel => 'केतू · तुम्ही काय प्रभुत्व मिळवले';

  @override
  String get pastlifeRahuWord => 'राहू';

  @override
  String get pastlifeFutureGrowthSuffix => 'भविष्यातील वृद्धी';

  @override
  String get pastlifeRahuPullsLabel => 'राहू · तुम्हाला पुढे काय ओढते';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ छाया: ${shadow}';
  }

  @override
  String get mentalScoresHeader => '🧠 मानसिक गुण';

  @override
  String get mentalStabilityStat => 'मानसिक\nस्थैर्य';

  @override
  String get mentalEmotionalBaselineStat => 'भावनिक\nआधाररेखा';

  @override
  String get mentalResilienceStat => 'लवचिकता';

  @override
  String get mentalAnxietyStat => 'चिंता';

  @override
  String get mentalDepressionStat => 'नैराश्य';

  @override
  String get mentalRegulationStat => 'नियंत्रण';

  @override
  String get mentalProfileTitle => 'मानसिक प्रोफाइल';

  @override
  String get mentalConstitutionLabel => 'प्रकृती';

  @override
  String get mentalStressDriverLabel => 'तणाव कारण';

  @override
  String get mentalStabilityAnchorLabel => 'स्थैर्य आधार';

  @override
  String get mentalStressResponseLabel => 'तणाव प्रतिसाद';

  @override
  String get mentalAttachmentStyleLabel => 'आसक्ती शैली';

  @override
  String get mentalBurnoutStageLabel => 'थकवा टप्पा';

  @override
  String get mentalWord => 'मानसिक';

  @override
  String get mentalYogasTitle => 'मानसिक योग';

  @override
  String get mentalStressPressureLabel => 'तणाव दबाव';

  @override
  String get mentalWellnessTrendTitle => 'स्वास्थ्य कल';

  @override
  String get mentalHealthyCopingTitle => '✓ निरोगी सामना';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ अनारोग्यकर धोके';

  @override
  String get mentalRecommendedAlternativesTitle => '✦ शिफारस केलेले पर्याय';

  @override
  String get mentalSleepQualityStat => 'झोप गुणवत्ता';

  @override
  String get mentalSocialSupportStat => 'सामाजिक आधार';

  @override
  String get mentalBurnoutVulnStat => 'थकवा असुरक्षितता';

  @override
  String get mentalSelfAwarenessStat => 'आत्मजागृती';

  @override
  String get mentalAnxietyWord => 'चिंता';

  @override
  String get mentalTypesSuffix => 'प्रकार';

  @override
  String get mentalTherapyWord => 'थेरपी';

  @override
  String get mentalModalityFitSuffix => 'पद्धती योग्यता';

  @override
  String get characterScoresHeader => '🔍 चारित्र्य गुण';

  @override
  String get characterStrengthStat => 'चारित्र्य\nबळ';

  @override
  String get characterIntegrityStat => 'सचोटी';

  @override
  String get characterResilienceStat => 'लवचिकता';

  @override
  String get characterAwarenessStat => 'जागृती';

  @override
  String get characterStabilityStat => 'स्थैर्य';

  @override
  String get characterEthicsStat => 'नैतिकता';

  @override
  String get characterSurfacePersonalityTitle => 'बाह्य व्यक्तिमत्त्व';

  @override
  String get characterLagnaLabel => 'लग्न';

  @override
  String get characterConstitutionLabel => 'प्रकृती';

  @override
  String get characterNakshatraLabel => 'नक्षत्र';

  @override
  String get characterDeityLabel => 'देवता';

  @override
  String get characterMoonManasTitle => 'चंद्र मन';

  @override
  String get characterSignLabel => 'राशी';

  @override
  String get characterHouseLabel => 'स्थान';

  @override
  String get characterWarmthStat => 'प्रेमळपणा';

  @override
  String get characterEmpathyStat => 'सहानुभूती';

  @override
  String get characterLoyaltyStat => 'निष्ठा';

  @override
  String get characterBoundariesStat => 'मर्यादा';

  @override
  String get characterDharmaStat => 'धर्म';

  @override
  String get characterTruthStat => 'सत्य';

  @override
  String get characterCompassionStat => 'करुणा';

  @override
  String get characterGenerosityStat => 'उदारता';

  @override
  String get characterSignatureVirtuesTitle => '★ खास सद्गुण';

  @override
  String get characterNaturalTalentsTitle => '● नैसर्गिक गुण';

  @override
  String get characterShadowPatternsTitle => '⚠ छाया आकृतिबंध';

  @override
  String get characterYogasTitle => 'चारित्र्य योग';

  @override
  String get characterTestsLabel => 'परीक्षा';

  @override
  String get characterGiftsLabel => 'देणग्या';

  @override
  String get characterSelfAwareEiStat => 'आत्मजागृती EI';

  @override
  String get characterSelfRegulateStat => 'आत्मनियंत्रण';

  @override
  String get characterEmpathyEiStat => 'सहानुभूती EI';

  @override
  String get characterSocialSkillsStat => 'सामाजिक कौशल्ये';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'साक्षात्कार: ${pct}%';
  }

  @override
  String get characterAtmakarakaWord => 'आत्मकारक';

  @override
  String get characterSoulSignatureSuffix => 'आत्म स्वाक्षरी';

  @override
  String get characterAtmakarakaLabel => 'आत्मकारक';

  @override
  String get characterGunaWord => 'गुण';

  @override
  String get characterProfileSuffix => 'प्रोफाइल';

  @override
  String get characterSattvaLabel => 'सत्त्व';

  @override
  String get characterRajasLabel => 'रजस';

  @override
  String get characterTamasLabel => 'तमस';

  @override
  String get healthScoresHeader => '🏥 आरोग्य गुण';

  @override
  String get healthVitalityStat => 'चैतन्य';

  @override
  String get healthImmunityStat => 'प्रतिकारशक्ती';

  @override
  String get healthRecoveryStat => 'पुनर्प्राप्ती';

  @override
  String get healthMentalStat => 'मानसिक';

  @override
  String get healthStressTolStat => 'तणाव सहनशक्ती';

  @override
  String get healthYogasTitle => 'आरोग्य योग';

  @override
  String get healthDiseasePressureLabel => 'रोग दबाव';

  @override
  String get healthTrendTitle => 'आरोग्य कल';

  @override
  String get healthRecoveryWindowsTitle => 'पुनर्प्राप्ती कालावधी';

  @override
  String get healthCautionPeriodsTitle => 'सावधगिरी कालावधी';

  @override
  String get healthFertilityStat => 'प्रजनन क्षमता';

  @override
  String get healthBurnoutRiskStat => 'थकवा धोका';

  @override
  String get healthAddictionVulnStat => 'व्यसन असुरक्षितता';

  @override
  String get healthWorkLifeBalStat => 'कार्य-जीवन संतुलन';

  @override
  String get healthAyurvedicWord => 'आयुर्वेदिक';

  @override
  String get healthConstitutionSuffix => 'प्रकृती';

  @override
  String get healthBodyWord => 'शरीर';

  @override
  String get healthSystemMapSuffix => 'प्रणाली नकाशा';

  @override
  String get healthBodyZoneWord => 'शरीर क्षेत्र';

  @override
  String get healthVulnerabilitySuffix => 'असुरक्षितता';

  @override
  String get healthDiseaseWord => 'रोग';

  @override
  String get healthSusceptibilitySuffix => 'प्रवृत्ती';

  @override
  String get healthLifestyleFactorsTitle => 'जीवनशैली घटक';

  @override
  String get healthSleepDisciplineLabel => 'झोप शिस्त';

  @override
  String get healthDietDisciplineLabel => 'आहार शिस्त';

  @override
  String get healthExerciseNeedLabel => 'व्यायाम गरज';

  @override
  String get healthSunlightNeedLabel => 'सूर्यप्रकाश गरज';

  @override
  String get healthSocialTypeLabel => 'सामाजिक प्रकार';

  @override
  String get healthHealingSpeedLabel => 'उपचार वेग';

  @override
  String get wealthScoresHeader => '💰 संपत्ती गुण';

  @override
  String get wealthStrengthStat => 'संपत्ती\nबळ';

  @override
  String get wealthAccumulationStat => 'संचय';

  @override
  String get wealthIncomeFlowStat => 'उत्पन्न\nप्रवाह';

  @override
  String get wealthSustainStat => 'टिकाव';

  @override
  String get wealthMultiStreamStat => 'बहु-स्रोत';

  @override
  String get wealthRetentionStat => 'टिकवणूक';

  @override
  String get wealthWord => 'संपत्ती';

  @override
  String get wealthYogasTitle => 'संपत्ती योग';

  @override
  String get wealthDrainsLabel => 'गळती';

  @override
  String get wealthBoostersLabel => 'वर्धक';

  @override
  String get wealthYearlyTrendTitle => 'वार्षिक कल';

  @override
  String get wealthGrowthTitle => 'संपत्ती वृद्धी';

  @override
  String get wealthCashPressureTitle => 'रोख दबाव';

  @override
  String get wealthMoneyPersonalityTitle => 'पैसा व्यक्तिमत्त्व';

  @override
  String get wealthTypeLabel => 'संपत्ती प्रकार';

  @override
  String get wealthRiskAppetiteLabel => 'जोखीम क्षमता';

  @override
  String get wealthInvestmentStyleLabel => 'गुंतवणूक शैली';

  @override
  String get wealthMoneyPersonalityLabel => 'पैसा व्यक्तिमत्त्व';

  @override
  String get wealthSpendingLabel => 'खर्च';

  @override
  String get wealthDebtProbStat => 'कर्ज संभाव्यता %';

  @override
  String get wealthInheritanceStat => 'वारसा %';

  @override
  String get wealthSuddenGainsStat => 'अचानक लाभ %';

  @override
  String get wealthSpouseBoostStat => 'जोडीदार लाभ %';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'यशाची शक्यता: ${pct}%';
  }

  @override
  String get wealthLifetimeClassLabel => 'जीवनकाळ संपत्ती वर्ग';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'मुख्य: ${value}';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'शिखर: ${value}';
  }

  @override
  String get wealthIncomeWord => 'उत्पन्न';

  @override
  String get wealthSourcesSuffix => 'स्रोत';

  @override
  String get wealthInvestmentWord => 'गुंतवणूक';

  @override
  String get wealthMixSuffix => 'मिश्रण';

  @override
  String wealthDrivenByLabel(Object planet) {
    return '${planet} द्वारे चालित';
  }

  @override
  String get marriageScoresHeader => '💒 विवाह गुण';

  @override
  String get marriageOverallStat => 'एकूण\nविवाह';

  @override
  String get marriageHarmonyStat => 'वैवाहिक\nसामंजस्य';

  @override
  String get marriageDomesticStabilityStat => 'घरगुती\nस्थैर्य';

  @override
  String get marriageLongevityStat => 'दीर्घायुष्य';

  @override
  String get marriageSatisfactionStat => 'समाधान';

  @override
  String get marriageClarityStat => 'स्पष्टता';

  @override
  String get marriageWindowsTitle => 'विवाह कालावधी';

  @override
  String get marriagePhasesTitle => 'विवाह टप्पे';

  @override
  String get marriageInLawRelationsStat => 'सासरचे संबंध';

  @override
  String get marriageFamilyHarmonyStat => 'कौटुंबिक सामंजस्य';

  @override
  String get marriageFertilityStat => 'प्रजनन क्षमता';

  @override
  String get marriageHomeOwnershipStat => 'घर मालकी';

  @override
  String get marriageDivorceRiskStat => 'घटस्फोट धोका';

  @override
  String get marriageInfidelityStat => 'बेवफाई';

  @override
  String get marriageConflictStat => 'संघर्ष';

  @override
  String get marriageDistanceStat => 'दुरावा';

  @override
  String get marriageSeekInPartnerTitle => '★ जोडीदारात शोधा';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ जोडीदारात टाळा';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'साक्षात्कार: ${pct}%';
  }

  @override
  String get marriageDarakarakaWord => 'दाराकारक';

  @override
  String get marriageSpouseKarakaSuffix => 'जोडीदार कारक';

  @override
  String get marriageDarakarakaDkLabel => 'दाराकारक (DK)';

  @override
  String get marriage7thWord => 'सप्तम';

  @override
  String get marriageSignLabel => 'राशी';

  @override
  String get marriageLordInLabel => 'स्वामी येथे';

  @override
  String get marriageStrengthLabel => 'बळ';

  @override
  String get marriageSpouseWord => 'जोडीदार';

  @override
  String get marriageProfileSuffix => 'प्रोफाइल';

  @override
  String get marriageSpouseTraitsTitle => '★ जोडीदार गुणधर्म';

  @override
  String get marriageLikelyProfessionsTitle => '● संभाव्य व्यवसाय';

  @override
  String get marriageHarmonyWord => 'सामंजस्य';

  @override
  String get marriageRadarSuffix => 'रडार';

  @override
  String get marriagePhysicalLabel => 'शारीरिक';

  @override
  String get marriageSharedValuesLabel => 'समान मूल्ये';

  @override
  String get marriageConflictResolutionLabel => 'संघर्ष निवारण';

  @override
  String get marriageMangalDoshLabel => '⚠ मंगळ दोष';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'तीव्रता: ${value}';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'रद्दीकरण: ${value}';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'नवमांश';

  @override
  String get multiChartTitleChild => 'अपत्य';

  @override
  String get multiChartTitleLove => 'प्रेम';

  @override
  String get multiChartTitleKarma => 'कर्म';

  @override
  String get multiChartTitleDefault => 'बहु-कुंडली';

  @override
  String get multiChartSuffixProbability => 'संभाव्यता';

  @override
  String get multiChartSuffixCompatibility => 'सुसंगती';

  @override
  String get multiChartSuffixLinkage => 'जोडणी';

  @override
  String get multiChartSuffixReport => 'अहवाल';

  @override
  String get multiChartParticipantsLabel => 'सहभागी';

  @override
  String get multiChartAnalysisWord => 'विश्लेषण';

  @override
  String get multiChartConfidenceSuffix => 'विश्वास';

  @override
  String get multiChartQualityBadge => 'गुणवत्ता';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'या वैदिक ज्योतिष अहवालाचे विश्लेषण करा आणि सविस्तर अंतर्दृष्टी द्या:\n\n${formatted}';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'हा एक वैदिक ज्योतिष तज्ज्ञ अहवाल आहे. कृपया याचे सखोल विश्लेषण करून कृतीयोग्य अंतर्दृष्टी द्या:\n\n${formatted}';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'या वैदिक ज्योतिष विश्लेषणाचे पुनरावलोकन करा आणि मुख्य निष्कर्ष सोप्या भाषेत समजावून सांगा:\n\n${formatted}';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return '${label} साठी कॉपी केले!';
  }

  @override
  String get childProbTitle1 => 'अपत्य';

  @override
  String get childProbTitle2 => 'संभाव्यता';

  @override
  String get childNumberOfChildrenHeader1 => 'अपत्यांची';

  @override
  String get childNumberOfChildrenHeader2 => 'संख्या';

  @override
  String get childTimingHeader1 => 'काळ';

  @override
  String get childTimingHeader2 => 'मूल दशा';

  @override
  String get child5thHouseHeader1 => 'पंचम स्थान';

  @override
  String get analysisWord => 'विश्लेषण';

  @override
  String get jupiterWord => 'गुरू';

  @override
  String get childD7Header1 => 'D7 सप्तमांश';

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
  String get progenyProbabilityLabel => 'संतती संभाव्यता';

  @override
  String get favorableWindowsLabel => 'अनुकूल कालावधी';

  @override
  String get partnerOneLabel => 'जोडीदार 1';

  @override
  String get partnerTwoLabel => 'जोडीदार 2';

  @override
  String get moonSignLabel => 'चंद्र राशी';

  @override
  String get lordInDusthana => 'दुःस्थानात स्वामी';

  @override
  String get lordStrengthLabel => 'स्वामी बळ';

  @override
  String get houseStrengthLabel => 'स्थान बळ';

  @override
  String get dignityLabel => 'अवस्था';

  @override
  String get directBadge => 'मार्गी';

  @override
  String get notCombustBadge => 'अस्त नाही';

  @override
  String get in5thHouseBadge => 'पंचम स्थानात';

  @override
  String get aspects5thBadge => 'पंचमावर दृष्टी';

  @override
  String get no5thConnectionBadge => 'पंचमाशी संबंध नाही';

  @override
  String jupiterInSignHeading(String sign) {
    return '${sign} मध्ये गुरू';
  }

  @override
  String get d7LagnaLabel => 'D7 लग्न';

  @override
  String get d7FifthSignLabel => 'D7 पंचम राशी';

  @override
  String get d7FifthLordLabel => 'D7 पंचम स्वामी';

  @override
  String get jupiterInD7Label => 'D7 मध्ये गुरू';

  @override
  String get jupiterDignityLabel => 'गुरू अवस्था';

  @override
  String get d7StrengthLabel => 'D7 बळ';

  @override
  String get yesWord => 'होय';

  @override
  String get noWord => 'नाही';

  @override
  String get beejaSphutaTitle => 'बीज स्फुट';

  @override
  String get kshetraSphutaTitle => 'क्षेत्र स्फुट';

  @override
  String get degreeLabel => 'अंश';

  @override
  String get signLordLabel => 'राशी स्वामी';

  @override
  String get presentInLabel => 'येथे उपस्थित';

  @override
  String get netPenaltyLabel => 'निव्वळ दंड';

  @override
  String get remedyGemstone => 'रत्न उपाय';

  @override
  String get remedyMantra => 'मंत्र उपाय';

  @override
  String get remedyRitual => 'विधी उपाय';

  @override
  String get remedyLifestyle => 'जीवनशैली उपाय';

  @override
  String get remedyCharitable => 'दान उपाय';

  @override
  String copiedForName(String name) {
    return '${name} साठी कॉपी केले!';
  }

  @override
  String get mahadashaLabel => 'महादशा';

  @override
  String get mdPeriodLabel => 'MD कालावधी';

  @override
  String get antardashaLabel => 'अंतर्दशा';

  @override
  String get adPeriodLabel => 'AD कालावधी';

  @override
  String get pratyantardashaLabel => 'प्रत्यंतर्दशा';

  @override
  String get favorabilityLabel => 'अनुकूलता';

  @override
  String factorPrefix(String factor) {
    return 'घटक: ${factor}';
  }

  @override
  String appliesToLabel(String value) {
    return 'लागू: ${value}';
  }

  @override
  String get qualityTag => 'गुणवत्ता';

  @override
  String get reliabilityVeryHigh => 'अत्यंत उच्च विश्वसनीयता';

  @override
  String get reliabilityGuidanceLevel => 'मार्गदर्शन-स्तरीय वाचन';

  @override
  String get karmaLinkTitle1 => 'कर्म';

  @override
  String get karmaLinkTitle2 => 'जोडणी';

  @override
  String get karmaFoundationHeader1 => 'कार्मिक';

  @override
  String get karmaFoundationHeader2 => 'पाया';

  @override
  String get karmaPairwiseHeader1 => 'जोडीनिहाय';

  @override
  String get karmaPairwiseHeader2 => 'जोडण्या';

  @override
  String get karmaGroupHeader1 => 'गट';

  @override
  String get karmaGroupHeader2 => 'आकृतिबंध';

  @override
  String get karmaPastLifeHeader1 => 'पूर्वजन्म';

  @override
  String get karmaPastLifeHeader2 => 'उद्दिष्टे';

  @override
  String get karmaCurrentLifeHeader1 => 'सध्याचे जीवन';

  @override
  String get karmaCurrentLifeHeader2 => 'शिक्षण';

  @override
  String get karmaDebtsHeader2 => 'कर्जे';

  @override
  String get karmaMoolaDashaHeader1 => 'मूल दशा';

  @override
  String get karmaMoolaDashaHeader2 => 'काळ';

  @override
  String get karmaDeepAuditHeader1 => 'सखोल तपासणी';

  @override
  String get karmaDeepAuditHeader2 => 'तक्ता';

  @override
  String get karmaHeroLabel => 'पूर्वजन्म कर्म जोडणी';

  @override
  String get karmaKetuMastery => 'केतू प्रावीण्य';

  @override
  String get nakshatraLabel => 'नक्षत्र';

  @override
  String get deityLabel => 'देवता';

  @override
  String get masteryScoreLabel => 'प्रावीण्य गुण';

  @override
  String get karmaRahuGrowth => 'राहू वृद्धी';

  @override
  String get growthScoreLabel => 'वृद्धी गुण';

  @override
  String get karmaAtmakaraka => 'आत्मकारक';

  @override
  String get karmaSaturnKarma => 'शनी कर्म';

  @override
  String get karma12thHouse => 'द्वादश स्थान';

  @override
  String get karma9thHousePunya => 'नवम स्थान पुण्य';

  @override
  String get bhavaScoreLabel => 'भाव गुण';

  @override
  String get karmaD60Signature => 'D60 स्वाक्षरी';

  @override
  String get depthScoreLabel => 'खोली गुण';

  @override
  String get linkageStrengthLabel => 'जोडणी बळ';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'जोडणी घटक (${count} सक्रिय)';
  }

  @override
  String get factorColumnLabel => 'घटक';

  @override
  String get weightColumnLabel => 'वजन';

  @override
  String get meaningColumnLabel => 'अर्थ';

  @override
  String get statusColumnLabel => 'स्थिती';

  @override
  String get karmaPastLifeConnection => 'पूर्वजन्म संबंध';

  @override
  String get karmaCurrentLifeDynamic => 'सध्याचे जीवन गतिशीलता';

  @override
  String get karmaWhatTheyTeach => 'ते एकमेकांना काय शिकवतात';

  @override
  String get karmaGroupThemeHeader => 'गट कार्मिक सूत्र';

  @override
  String get karmaSharedSettingHeader => 'समान पूर्वजन्म परिवेश';

  @override
  String get karmaCollectiveKetuHeader => 'सामूहिक केतू आकृतिबंध';

  @override
  String get karmaCollectiveRahuHeader => 'सामूहिक राहू आकृतिबंध';

  @override
  String get housesPrefixLabel => 'स्थाने: ';

  @override
  String get signsPrefixLabel => 'राशी: ';

  @override
  String get karmicCohesionLabel => 'कार्मिक एकजूट';

  @override
  String get karmaGroupSoulContractHeader => 'गट आत्मा करार';

  @override
  String get goalLabel => 'उद्दिष्ट';

  @override
  String get karmaSharedGoalHeader => 'समान पूर्वजन्म उद्दिष्ट';

  @override
  String get howToGrowHeader => 'कशी वाढ करावी';

  @override
  String moolaDashaPrefix(String value) {
    return 'मूल दशा: ${value}';
  }

  @override
  String get karmaSharedLessonHeader => 'समान गट धडा';

  @override
  String get karmaMutualTeachingHeader => 'परस्पर अध्यापन नकाशा';

  @override
  String get karmaTeachingDynamicsPlaceholder => 'कार्मिक संबंध अधिक दृढ होताच अध्यापन गतिशीलता उदयास येईल.';

  @override
  String get typeFieldLabel => 'प्रकार';

  @override
  String get basisFieldLabel => 'आधार';

  @override
  String get resolutionPathHeader => 'निवारण मार्ग';

  @override
  String dashaTimingPrefix(String value) {
    return 'दशा काळ: ${value}';
  }

  @override
  String get mutualDebtsHeader => 'परस्पर कर्जे';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'तारखा';

  @override
  String get groupKarmicWindowHeader => 'गट कार्मिक कालावधी';

  @override
  String parametersAuditedHeading(int count) {
    return '${count} घटक तपासले';
  }

  @override
  String get valuePrefixLabel => 'मूल्य: ';

  @override
  String weightPrefix(String value) {
    return 'व: ${value}';
  }

  @override
  String get loveCompatTitle1 => 'प्रेम';

  @override
  String get loveCompatTitle2 => 'सुसंगती';

  @override
  String get loveAttractionHeader1 => 'आकर्षण व';

  @override
  String get loveAttractionHeader2 => 'रसायन';

  @override
  String get loveEmotionalHeader1 => 'भावनिक';

  @override
  String get loveEmotionalHeader2 => 'सामंजस्य';

  @override
  String get loveMentalHeader1 => 'मानसिक';

  @override
  String get loveMentalHeader2 => 'सुसंवाद';

  @override
  String get lovePassionHeader1 => 'उत्कटता व';

  @override
  String get lovePassionHeader2 => 'शारीरिक';

  @override
  String get loveLongtermHeader1 => 'दीर्घकालीन';

  @override
  String get loveKarmicHeader1 => 'कार्मिक प्रेम';

  @override
  String get loveKarmicHeader2 => 'बंध';

  @override
  String get loveChallengesHeader1 => 'आव्हाने व';

  @override
  String get loveChallengesHeader2 => 'घर्षण';

  @override
  String get loveTimingHeader1 => 'प्रेम काळ';

  @override
  String get loveRelationshipHeader1 => 'नातेसंबंध';

  @override
  String get loveRelationshipHeader2 => 'गतिशीलता';

  @override
  String get loveRemediesHeader1 => 'उपाय व';

  @override
  String get loveRemediesHeader2 => 'मार्गदर्शन';

  @override
  String get loveCompatHeroLabel => 'प्रेम सुसंगती';

  @override
  String get loveChipAttraction => 'आकर्षण';

  @override
  String get loveChipPassion => 'उत्कटता';

  @override
  String get loveChipChallenge => 'आव्हान';

  @override
  String get venusSignLabel => 'शुक्र राशी';

  @override
  String get attractionScoreLabel => 'आकर्षण गुण';

  @override
  String get activeContactsLabel => 'सक्रिय संपर्क';

  @override
  String get magneticPullLabel => 'चुंबकीय ओढ';

  @override
  String get initialAttractionLabel => 'प्रारंभिक आकर्षण';

  @override
  String get emotionalScoreLabel => 'भावनिक गुण';

  @override
  String get elementMatchLabel => 'तत्त्व जुळणी';

  @override
  String get harmonyLabel => 'सामंजस्य';

  @override
  String get kootaYoni => 'योनी';

  @override
  String get kootaGana => 'गण';

  @override
  String get kootaTara => 'तारा';

  @override
  String get doshaPresentBadge => 'दोष उपस्थित';

  @override
  String get noDoshaBadge => 'दोष नाही';

  @override
  String get axisLabel => 'अक्ष';

  @override
  String get mentalScoreLabel => 'मानसिक गुण';

  @override
  String get mercuryDynamicsLabel => 'बुध गतिशीलता';

  @override
  String get communicationStyleLabel => 'संवाद शैली जुळणी';

  @override
  String get intellectualConnectionLabel => 'बौद्धिक संबंध';

  @override
  String get passionScoreLabel => 'उत्कटता गुण';

  @override
  String get marsVenusLabel => 'मंगळ-शुक्र आंतरक्रिया';

  @override
  String get physicalChemistryLabel => 'शारीरिक रसायन';

  @override
  String get yoniCompatLabel => 'योनी सुसंगती';

  @override
  String get longtermScoreLabel => 'दीर्घकालीन गुण';

  @override
  String get seventhHouseSynastryLabel => 'सप्तम स्थान सिनॅस्ट्री';

  @override
  String get commitmentPotentialLabel => 'बांधिलकी क्षमता';

  @override
  String get jupiterBlessingLabel => 'गुरू आशीर्वाद';

  @override
  String get d9NavamsaResonanceLabel => 'D9 नवमांश अनुनाद';

  @override
  String get saturnLongevityLabel => 'शनी दीर्घायुष्य';

  @override
  String get karmicScoreLabel => 'कार्मिक गुण';

  @override
  String get darakarakaLinkLabel => 'दाराकारक जोडणी';

  @override
  String get sourceLabel => 'स्रोत';

  @override
  String get emotionalGiverReceiverLabel => 'भावनिक दाता / ग्रहणकर्ता';

  @override
  String get powerBalanceLabel => 'सत्ता संतुलन';

  @override
  String get growthDynamicLabel => 'वृद्धी गतिशीलता';

  @override
  String get addressesLabel => 'संबोधित करते';

  @override
  String get loveScoresLabel => 'प्रेम गुण';

  @override
  String get loveCapacityLabel => 'प्रेम\nक्षमता';

  @override
  String get emotionalAvailabilityLabel => 'भावनिक\nउपलब्धता';

  @override
  String get romanticAttractionLabel => 'प्रणय\nआकर्षण';

  @override
  String get commitmentWord => 'बांधिलकी';

  @override
  String get intimacyWord => 'जवळीक';

  @override
  String get fidelityWord => 'निष्ठा';

  @override
  String get loveProfileTitle => 'प्रेम प्रोफाइल';

  @override
  String get loveStyleLabel => 'प्रेम शैली';

  @override
  String get attractionStyleLabel => 'आकर्षण शैली';

  @override
  String get lovePathLabel => 'प्रेम मार्ग';

  @override
  String get currentPhaseLabel => 'सध्याचा टप्पा';

  @override
  String get commitmentStyleLabel => 'बांधिलकी शैली';

  @override
  String get loveWord => 'प्रेम';

  @override
  String get karakasWord => 'कारक';

  @override
  String get attractedToLabel => 'आकर्षित';

  @override
  String get whatPartnerSeesLabel => 'जोडीदार काय पाहतो';

  @override
  String get romancePatternTitle => 'प्रणय आकृतिबंध';

  @override
  String get firstLoveAgeLabel => 'पहिले प्रेम वय';

  @override
  String get relationshipCountLabel => 'नातेसंबंध संख्या';

  @override
  String get avgDurationLabel => 'सरासरी कालावधी';

  @override
  String get breakupTriggerLabel => 'विभक्तीचे कारण';

  @override
  String get heartbreakRecoveryLabel => 'हृदयभंग पुनर्प्राप्ती';

  @override
  String get loveTrendTitle => 'प्रेम कल';

  @override
  String get newLoveWindowsTitle => 'नवीन प्रेम कालावधी';

  @override
  String get loveBlocksTitle => 'प्रेम अडथळे';

  @override
  String get activeBlocksLabel => 'सक्रिय अडथळे';

  @override
  String get loveMarriagePctLabel => 'प्रेमविवाह %';

  @override
  String get heartbreakVulnLabel => 'हृदयभंग असुरक्षितता';

  @override
  String get selfSabotageLabel => 'आत्म-घात';

  @override
  String get emotionalIqLabel => 'भावनिक बुद्ध्यांक';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'पूर्तता: ${pct}%';
  }

  @override
  String get languagesWord => 'भाषा';

  @override
  String get givesLabel => 'देतो';

  @override
  String get receivesLabel => 'घेतो';

  @override
  String get idealWord => 'आदर्श';

  @override
  String get partnerWord => 'जोडीदार';

  @override
  String get seekTheseTraitsLabel => 'हे गुणधर्म शोधा';

  @override
  String get dealbreakersLabel => 'अस्वीकार्य बाबी';

  @override
  String get propertyScoresLabel => 'मालमत्ता गुण';

  @override
  String get acquisitionCapacityLabel => 'अधिग्रहण\nक्षमता';

  @override
  String get homeOwnershipPctLabel => 'घर\nमालकी %';

  @override
  String get reWealthPotentialLabel => 'स्थावर संपत्ती\nक्षमता';

  @override
  String get rentalWord => 'भाडे';

  @override
  String get vehiclesWord => 'वाहने';

  @override
  String get landPctLabel => 'जमीन %';

  @override
  String get propertyProfileTitle => 'मालमत्ता प्रोफाइल';

  @override
  String get karmaTypeLabel => 'कर्म प्रकार';

  @override
  String get environmentLabel => 'परिसर';

  @override
  String get styleLabel => 'शैली';

  @override
  String get sizeLabel => 'आकार';

  @override
  String get locationLabel => 'स्थान';

  @override
  String get actionNext12mLabel => 'पुढील 12 महिन्यांतील कृती';

  @override
  String get propertyWord => 'मालमत्ता';

  @override
  String get propertyYogasTitle => 'मालमत्ता योग';

  @override
  String get drainsLabel => 'गळती';

  @override
  String get boostersLabel => 'वर्धक';

  @override
  String get propertyTrendTitle => 'मालमत्ता कल';

  @override
  String get buyingWindowsTitle => 'खरेदी कालावधी';

  @override
  String get constructionWindowsTitle => 'बांधकाम कालावधी';

  @override
  String get maternalInherPctLabel => 'मातृ वारसा %';

  @override
  String get paternalInherPctLabel => 'पितृ वारसा %';

  @override
  String get multiHomePctLabel => 'बहु-घर %';

  @override
  String get investmentPctLabel => 'गुंतवणूक %';

  @override
  String get vehicleProfileTitle => 'वाहन प्रोफाइल';

  @override
  String get countLabel => 'संख्या';

  @override
  String get firstAgeLabel => 'पहिले वय';

  @override
  String get categoryLabel => 'श्रेणी';

  @override
  String get luxuryLabel => 'विलासी';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'जीवनकाळ संख्या: ${count} · पूर्तता: ${pct}%';
  }

  @override
  String get pressureWord => 'दबाव';

  @override
  String get protectionWord => 'संरक्षण';

  @override
  String get astrologicalWord => 'ज्योतिषशास्त्रीय';

  @override
  String get keyRisksHeader1 => 'मुख्य';

  @override
  String get keyRisksHeader2 => 'धोके';

  @override
  String get reportCopiedShort => 'अहवाल कॉपी केला!';

  @override
  String get keyScoresLabel => 'मुख्य गुण';

  @override
  String allScoresCountLabel(int count) {
    return 'सर्व गुण (${count})';
  }

  @override
  String get windowsWord => 'कालावधी';

  @override
  String get genericFailedMsg => 'अयशस्वी';

  @override
  String get unknownWord => 'अज्ञात';

  @override
  String selectKarmaChartsLabel(int max) {
    return '2-${max} कुंडल्या निवडा';
  }

  @override
  String selectChartsLabelCount(int max) {
    return '${max} कुंडल्या निवडा';
  }

  @override
  String runningAnalysisLabel(String label) {
    return '${label} विश्लेषण सुरू आहे...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'कार्मिक जोडण्यांचे विश्लेषण करण्यासाठी 2 ते ${max} कुंडल्या निवडा';
  }

  @override
  String get pickMaleFemaleHint => 'पुरुष व स्त्री कुंडली निवडा';

  @override
  String get personOneLabel => 'व्यक्ती 1';

  @override
  String get personTwoLabel => 'व्यक्ती 2';

  @override
  String get analysisFailedMsg => 'विश्लेषण अयशस्वी';

  @override
  String analyzeChartsCountLabel(int count) {
    return '${count} कुंडल्यांचे विश्लेषण करा';
  }

  @override
  String get contextGeneralLabel => 'सामान्य';

  @override
  String get contextLoveLabel => 'प्रेम';

  @override
  String get contextBusinessLabel => 'व्यवसाय';

  @override
  String get contextFamilyLabel => 'कुटुंब';

  @override
  String get contextTeamLabel => 'संघ';

  @override
  String get contextFriendshipLabel => 'मैत्री';

  @override
  String get relationshipIntelTitle => 'नातेसंबंध बुद्धिमत्ता';

  @override
  String analyzingChartsCountLabel(int count) {
    return '${count} कुंडल्यांचे विश्लेषण सुरू आहे...';
  }

  @override
  String get relationshipContextLabel => 'नातेसंबंध संदर्भ';

  @override
  String get kundliMilanReportTitle => 'कुंडली मिलन अहवाल';

  @override
  String get runningMilanAnalysisLabel => 'मिलन विश्लेषण सुरू आहे...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '${count}/2 निवडले';
  }

  @override
  String get runMilanAnalysisBtn => 'मिलन विश्लेषण चालवा';

  @override
  String get noChartsCreateFirst => 'कुंडली नाही. प्रथम जन्मकुंडली तयार करा.';

  @override
  String get selectBirthChartAnalyze => 'विश्लेषणासाठी जन्मकुंडली निवडा';

  @override
  String get doshAnalysis => 'दोष विश्लेषण';

  @override
  String doshActiveCount(Object active, Object total) {
    return '${active} सक्रिय / ${total} तपासले';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '${active} सक्रिय / ${total} योग तपासले';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'सक्रिय योग (${count})';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'निष्क्रिय योग लपवा (${count})';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'निष्क्रिय योग दाखवा (${count})';
  }

  @override
  String get loadFailed => 'अयशस्वी';

  @override
  String dashaDrillMd(Object planet) {
    return '${planet} MD → अंतर्दशा';
  }

  @override
  String dashaDrillAd(Object planet) {
    return '${planet} AD → प्रत्यंतर्दशा';
  }

  @override
  String dashaDrillPd(Object planet) {
    return '${planet} PD → सूक्ष्मदशा';
  }

  @override
  String dashaDrillSub(Object planet) {
    return '${planet} उप-कालावधी';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return 'जन्म स्वामी: ${lord} • शिल्लक: ${balance} वर्षे';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'लग्न: ${lagna} • शिल्लक: ${balance} वर्षे';
  }

  @override
  String dashaYearsValue(Object years) {
    return '${years} वर्षे';
  }

  @override
  String get dashaCurrentPeriod => 'सध्याचा दशा कालावधी';

  @override
  String dashaAsOf(Object date) {
    return 'दिनांकानुसार: ${date}';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'सध्याच्या कालावधीत सक्रिय योग (${count})';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'सध्याच्या कालावधीत सक्रिय दोष (${count})';
  }

  @override
  String get dashaNoYogasTriggered => 'कोणतेही योग सक्रिय नाहीत';

  @override
  String get dashaNoDoshasTriggered => 'कोणतेही दोष सक्रिय नाहीत';

  @override
  String get divD1Name => 'राशी (D-1)';

  @override
  String get divD1Desc => 'भौतिक अस्तित्व, सर्व बाबी';

  @override
  String get divD2Name => 'होरा (D-2)';

  @override
  String get divD2Desc => 'संपत्ती, पैसा';

  @override
  String get divD3Name => 'द्रेक्काण (D-3)';

  @override
  String get divD3Desc => 'भावंडे, धैर्य';

  @override
  String get divD4Name => 'चतुर्थांश (D-4)';

  @override
  String get divD4Desc => 'मालमत्ता, निवास, भाग्य';

  @override
  String get divD5Name => 'पंचमांश (D-5)';

  @override
  String get divD5Desc => 'कीर्ती, अधिकार, सत्ता';

  @override
  String get divD6Name => 'षष्ठांश (D-6)';

  @override
  String get divD6Desc => 'आरोग्य समस्या';

  @override
  String get divD7Name => 'सप्तमांश (D-7)';

  @override
  String get divD7Desc => 'अपत्ये, नातवंडे';

  @override
  String get divD8Name => 'अष्टमांश (D-8)';

  @override
  String get divD8Desc => 'अचानक संकटे, खटले';

  @override
  String get divD9Name => 'नवमांश (D-9)';

  @override
  String get divD9Desc => 'विवाह, जोडीदार, धर्म';

  @override
  String get divD10Name => 'दशमांश (D-10)';

  @override
  String get divD10Desc => 'करिअर, व्यवसाय';

  @override
  String get divD11Name => 'रुद्रांश (D-11)';

  @override
  String get divD11Desc => 'मृत्यू, विनाश';

  @override
  String get divD12Name => 'द्वादशांश (D-12)';

  @override
  String get divD12Desc => 'आई-वडील, रक्तनातेवाईक';

  @override
  String get divD16Name => 'षोडशांश (D-16)';

  @override
  String get divD16Desc => 'वाहने, सुखसोयी, आनंद';

  @override
  String get divD20Name => 'विंशांश (D-20)';

  @override
  String get divD20Desc => 'आध्यात्मिक बाबी, धार्मिक';

  @override
  String get divD24Name => 'चतुर्विंशांश (D-24)';

  @override
  String get divD24Desc => 'शिक्षण, ज्ञान, विद्या';

  @override
  String get divD27Name => 'नक्षत्रांश (D-27)';

  @override
  String get divD27Desc => 'बलस्थाने, कमकुवत बाजू, स्वभाव';

  @override
  String get divD30Name => 'त्रिंशांश (D-30)';

  @override
  String get divD30Desc => 'अनिष्ट, अवचेतन, शिक्षा';

  @override
  String get divD40Name => 'खवेदांश (D-40)';

  @override
  String get divD40Desc => 'शुभ/अशुभ (मातृ)';

  @override
  String get divD45Name => 'अक्षवेदांश (D-45)';

  @override
  String get divD45Desc => 'सर्व बाबी (पितृ)';

  @override
  String get divD60Name => 'षष्ट्यंश (D-60)';

  @override
  String get divD60Desc => 'पूर्वजन्म कर्म — सर्वात महत्त्वाचे';

  @override
  String get lifeAreaCareer => 'करिअर';

  @override
  String get lifeAreaWealth => 'संपत्ती';

  @override
  String get lifeAreaMarriage => 'विवाह';

  @override
  String get lifeAreaHealth => 'आरोग्य';

  @override
  String get lifeAreaSpirituality => 'अध्यात्म';

  @override
  String lifeAreaGrade(Object grade) {
    return 'श्रेणी: ${grade}';
  }

  @override
  String get lifeAreaFactorsLabel => 'घटक:';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return 'नक्षत्र: ${nakshatra} (${pada})';
  }

  @override
  String planetNakLord(Object lord) {
    return 'नक्षत्र स्वामी: ${lord}';
  }

  @override
  String planetLongitude(Object value) {
    return 'रेखांश: ${value}°';
  }

  @override
  String get chakraOverallHealth => 'एकूण आरोग्य';

  @override
  String get careerWord => 'करिअर';

  @override
  String get failedToLoad => 'लोड करण्यात अयशस्वी';

  @override
  String get kundliAscendantLagna => 'लग्न (आरोह)';

  @override
  String get kundliMoonSignRashi => 'चंद्र राशी';

  @override
  String get kundliSunSign => 'सूर्य राशी';

  @override
  String kundliEngineLabel(Object engine) {
    return 'इंजिन: ${engine}';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return 'अंश: ${degree}°  •  नक्षत्र: ${nakshatra} (${pada})';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'नक्षत्र स्वामी: ${lord}  •  अवस्था: ${dignity}';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return '${base} कुंडली — ${sign}';
  }

  @override
  String kundliBaseChart(Object base) {
    return '${base} कुंडली';
  }

  @override
  String get careerSummary => 'करिअर सारांश';

  @override
  String get phase => 'टप्पा';

  @override
  String get confidenceLabel => 'विश्वास';

  @override
  String get careerScores => 'करिअर गुण';

  @override
  String get stabilityLabel => 'स्थैर्य';

  @override
  String get growthLabel => 'वृद्धी';

  @override
  String get gradeExcellent => 'उत्कृष्ट';

  @override
  String get gradeGood => 'चांगले';

  @override
  String get gradeAverage => 'सरासरी';

  @override
  String get gradeBelowAvg => 'सरासरीपेक्षा कमी';

  @override
  String get gradeWeak => 'कमकुवत';

  @override
  String get careerTypeDomain => 'करिअर व क्षेत्र';

  @override
  String get careerTimeline => 'करिअर कालरेषा';

  @override
  String dashaLabel(Object dasha) {
    return 'दशा: ${dasha}';
  }

  @override
  String get improvementSuggestions => 'सुधारणा सूचना';

  @override
  String get chartDetails => 'कुंडली तपशील';

  @override
  String get keyHousesCareer => 'मुख्य स्थाने (करिअर)';

  @override
  String get keyCareerPlanets => 'मुख्य करिअर ग्रह';

  @override
  String get empty => 'रिकामे';

  @override
  String get guna => 'गुण';

  @override
  String get dasha => 'दशा';

  @override
  String get satwik => 'सात्त्विक';

  @override
  String get rajasik => 'राजसिक';

  @override
  String get tamasik => 'तामसिक';

  @override
  String get charGroupCorePersonality => 'मुख्य व्यक्तिमत्त्व';

  @override
  String get charGroupTrustHonesty => 'विश्वास व प्रामाणिकपणा';

  @override
  String get charGroupLoyaltyCommitment => 'निष्ठा व बांधिलकी';

  @override
  String get charGroupStrategicPrivacy => 'रणनीती व गोपनीयता';

  @override
  String get charGroupFinancial => 'आर्थिक';

  @override
  String get charGroupAngerConflict => 'राग व संघर्ष';

  @override
  String get charGroupMoralDharmic => 'नैतिक व धार्मिक';

  @override
  String get charGroupIntellectCommunication => 'बुद्धी व संवाद';

  @override
  String get charGroupEmotionalProfile => 'भावनिक प्रोफाइल';

  @override
  String get charGroupMentalHealth => 'मानसिक आरोग्य';

  @override
  String get charGroupRomantic => 'प्रणय';

  @override
  String get charGroupMarriageFamily => 'विवाह व कुटुंब';

  @override
  String get charGroupOverallLife => 'एकूण जीवन';

  @override
  String get grahaDrishti => 'ग्रह दृष्टी (ग्रहांच्या दृष्टी)';

  @override
  String get grahaDrishtiSubtitle => 'कोण कोणावर दृष्टी टाकतो (%)';

  @override
  String get lagnaAspectsReceived => 'लग्नावरील दृष्टी';

  @override
  String get rashiDrishti => 'राशी दृष्टी (राशींच्या दृष्टी)';

  @override
  String get shadbalaRupas => 'रुप';

  @override
  String get bhavaHouse1 => 'स्वतः / शरीर';

  @override
  String get bhavaHouse2 => 'संपत्ती / कुटुंब';

  @override
  String get bhavaHouse3 => 'भावंडे / धैर्य';

  @override
  String get bhavaHouse4 => 'घर / आई';

  @override
  String get bhavaHouse5 => 'अपत्ये / बुद्धी';

  @override
  String get bhavaHouse6 => 'शत्रू / आरोग्य';

  @override
  String get bhavaHouse7 => 'विवाह / जोडीदार';

  @override
  String get bhavaHouse8 => 'आयुष्य';

  @override
  String get bhavaHouse9 => 'भाग्य / गुरू';

  @override
  String get bhavaHouse10 => 'करिअर / वडील';

  @override
  String get bhavaHouse11 => 'लाभ / मित्र';

  @override
  String get bhavaHouse12 => 'हानी / मोक्ष';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '${sign} • स्वामी: ${lord}';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: ${value}';
  }

  @override
  String get sarvaAshtakavarga => 'सर्व अष्टकवर्ग (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'एकूण: ${total} रेखा (सरासरी राशी = ${avg})';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '${planet} — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'एकूण: ${total} रेखा • जन्म राशीत: ${score}';
  }

  @override
  String get today => 'आज';

  @override
  String gocharTransitScores(Object date) {
    return 'गोचर (संक्रमण गुण) — ${date}';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'जन्म चंद्र: ${sign}';
  }

  @override
  String get gocharBest => 'सर्वोत्तम';

  @override
  String get gocharWorst => 'सर्वात वाईट';

  @override
  String copiedOpening(Object ai) {
    return 'कॉपी केले! ${ai} उघडत आहे...';
  }

  @override
  String get openLink => 'उघडा ↗';

  @override
  String get discussReportWithAI => 'हा अहवाल AI सोबत चर्चा करा';

  @override
  String get reliabilityHigh => 'उच्च विश्वसनीयता';

  @override
  String get reliabilityModerate => 'मध्यम विश्वसनीयता';

  @override
  String get reliabilityLow => 'कमी — फक्त मार्गदर्शन';

  @override
  String get reliabilityGoodEdu => 'चांगली विश्वसनीयता · D-24 पडताळले';

  @override
  String get relationshipWord => 'नातेसंबंध';

  @override
  String get intelligenceWord => 'बुद्धिमत्ता';

  @override
  String get relationshipIntelligence => 'नातेसंबंध बुद्धिमत्ता';

  @override
  String get typeLabel => 'प्रकार';

  @override
  String get trustLabel => 'विश्वास';

  @override
  String get dhokaRisk => 'धोका जोखीम';

  @override
  String get powerLabel => 'सत्ता';

  @override
  String get integrity => 'सचोटी';

  @override
  String get warmth => 'प्रेमळपणा';

  @override
  String get trustWord => 'विश्वास';

  @override
  String get assertLabel => 'ठामपणा';

  @override
  String get character => 'चारित्र्य';

  @override
  String get love => 'प्रेम';

  @override
  String get businessWord => 'व्यवसाय';

  @override
  String get karmic => 'कार्मिक';

  @override
  String get enmityRisk => 'शत्रुत्व जोखीम';

  @override
  String get hdrChartProfiles => 'कुंडली प्रोफाइल';

  @override
  String get hdrPairwiseAnalysis => 'जोडीनिहाय विश्लेषण';

  @override
  String get hdrCriticalPatterns => 'गंभीर आकृतिबंध';

  @override
  String get hdrGroupRecommendations => 'गट शिफारसी';

  @override
  String get sharedPractices => 'समान अभ्यास';

  @override
  String get hdrIndividualGuidance => 'वैयक्तिक मार्गदर्शन';

  @override
  String get growthAreas => 'वृद्धी क्षेत्रे';

  @override
  String get hdrCoreTheme => 'मुख्य सूत्र';

  @override
  String get growthOriented => 'वृद्धी-केंद्रित';

  @override
  String get groupTheme => 'गट सूत्र';

  @override
  String get compatibility => 'सुसंगती';

  @override
  String get unifiedScoreLabel => 'एकत्रित गुण';

  @override
  String get ashtakoot => 'अष्टकूट';

  @override
  String get probability => 'संभाव्यता';

  @override
  String get hdrAshtakootSummary => 'अष्टकूट सारांश';

  @override
  String get hdrGunBreakdown => '8 गुण विवरण';

  @override
  String get hdrMangalDosh => 'मंगळ दोष';

  @override
  String get hdrD9CrossChart => 'D-9 क्रॉस-कुंडली';

  @override
  String get d9Compatibility => 'D-9 सुसंगती';

  @override
  String get hdrDomainCompatibility => 'क्षेत्र सुसंगती';

  @override
  String get emotional => 'भावनिक';

  @override
  String get intellectual => 'बौद्धिक';

  @override
  String get spiritual => 'आध्यात्मिक';

  @override
  String get financial => 'आर्थिक';

  @override
  String get domestic => 'घरगुती';

  @override
  String get communicationWord => 'संवाद';

  @override
  String get sharedDharma => 'समान धर्म';

  @override
  String get familyCreation => 'कुटुंब निर्मिती';

  @override
  String get hdrMarriageTiming => 'विवाह काळ';

  @override
  String get jointMarriageWindows => 'संयुक्त विवाह कालावधी';

  @override
  String get engagementWindows => 'साखरपुडा कालावधी';

  @override
  String get recommendedLabel => 'शिफारस केलेले';

  @override
  String get hdrKeyRisks => 'मुख्य धोके';

  @override
  String get hdrFinalVerdict => 'अंतिम निर्णय';

  @override
  String get marriageVerdict => 'विवाह निर्णय';

  @override
  String get educationWord => 'शिक्षण';

  @override
  String get learningSuffix => 'व अध्ययन';

  @override
  String get coreEducationScores => 'मुख्य शिक्षण गुण';

  @override
  String get academicSuccess => 'शैक्षणिक यश';

  @override
  String get learningCapacity => 'अध्ययन क्षमता';

  @override
  String get memory => 'स्मरणशक्ती';

  @override
  String get intelligence => 'बुद्धिमत्ता';

  @override
  String get research => 'संशोधन';

  @override
  String get hdrIntellectualProfile => 'बौद्धिक प्रोफाइल';

  @override
  String get learningSignature => 'अध्ययन स्वाक्षरी';

  @override
  String get hdrSubjectKaraka => 'विषय कारक';

  @override
  String get hdrHouseFoundations => 'स्थान पाया';

  @override
  String get hdrMercuryJupiter => 'बुध व गुरू';

  @override
  String get hdrEducationYogas => 'शिक्षण योग';

  @override
  String get hdrDivisionalValidation => 'विभागीय पडताळणी';

  @override
  String get standing => 'स्थान';

  @override
  String get hdrSubjectRanking => 'विषय क्रमवारी';

  @override
  String get hdrDegreeLikelihood => 'पदवी शक्यता';

  @override
  String get hdrStudyPeriods => 'अभ्यास कालावधी';

  @override
  String get earlySchooling => 'प्रारंभिक शालेय शिक्षण';

  @override
  String get higherEducation => 'उच्च शिक्षण';

  @override
  String get postgradResearch => 'पदव्युत्तर · संशोधन';

  @override
  String get hdrLearningPreferences => 'अध्ययन प्राधान्ये';

  @override
  String get hdrChallengesGifts => 'आव्हाने व देणग्या';

  @override
  String get challenges => 'आव्हाने';

  @override
  String get cognitiveGifts => 'संज्ञानात्मक देणग्या';

  @override
  String get naturalAbilities => 'नैसर्गिक क्षमता';

  @override
  String get hdrSaraswatiRemedies => 'सरस्वती उपाय';

  @override
  String get studentVerdict => 'विद्यार्थी निर्णय';

  @override
  String get educationCareerLinkage => 'शिक्षण → करिअर जोडणी';

  @override
  String get startupSuffix => 'व स्टार्टअप';

  @override
  String get coreBusinessScores => 'मुख्य व्यवसाय गुण';

  @override
  String get overallBusiness => 'एकूण व्यवसाय';

  @override
  String get ventureSuccess => 'उद्यम यश';

  @override
  String get eleventhHouse => 'एकादश स्थान';

  @override
  String get gains => 'लाभ';

  @override
  String get investor => 'गुंतवणूकदार';

  @override
  String get hdrFounderArchetype => 'संस्थापक आदर्श';

  @override
  String get hdrTenthEleventhHouses => 'दशम व एकादश स्थाने';

  @override
  String get hdrBusinessYogas => 'व्यवसाय योग';

  @override
  String get hdrRecommendedDomains => 'शिफारस केलेली क्षेत्रे';

  @override
  String get hdrBusinessStyle => 'व्यवसाय शैली';

  @override
  String get hdrFounderSkills => 'संस्थापक कौशल्ये';

  @override
  String get hdrFundingProfile => 'निधी प्रोफाइल';

  @override
  String get recommendedPath => 'शिफारस केलेला मार्ग';

  @override
  String get investorAttract => 'गुंतवणूकदार आकर्षण';

  @override
  String get familyBacking => 'कौटुंबिक पाठबळ';

  @override
  String get hybridViability => 'संकरित व्यवहार्यता';

  @override
  String get launchWindow => 'प्रारंभ कालावधी';

  @override
  String get scaleWindow => 'विस्तार कालावधी';

  @override
  String get hdrBusinessRisks => 'व्यवसाय धोके';

  @override
  String get recoveryCapacity => 'पुनर्प्राप्ती क्षमता';

  @override
  String get hdrRemediesSolutions => 'उपाय व निराकरणे';

  @override
  String get aiConnectionLost => 'कनेक्शन तुटले. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get aiSomethingWrong => 'काहीतरी चूक झाली';

  @override
  String get aiNoResponse => 'प्रतिसाद नाही';

  @override
  String get aiConnectionError => 'कनेक्शन त्रुटी. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get aiAutoDetect => 'स्वयं-शोध';

  @override
  String aiAutoArrow(String lang) {
    return 'स्वयं → ${lang}';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'भाषा: ${lang}';
  }

  @override
  String get aiNoBirthCharts => 'जन्मकुंडली सापडली नाही';

  @override
  String get aiCreateChartFirst => 'AI सोबत चॅट करण्यासाठी प्रथम जन्मकुंडली तयार करा';

  @override
  String get aiSelectChartBegin => 'विश्लेषण सुरू करण्यासाठी जन्मकुंडली निवडा';

  @override
  String aiAnalyzingName(String name) {
    return 'विश्लेषण सुरू: ${name}';
  }

  @override
  String get aiChange => 'बदला';

  @override
  String get aiAnalyzingChart => 'तुमच्या कुंडलीचे विश्लेषण सुरू आहे...';

  @override
  String get aiAskStarsHint => 'ताऱ्यांना काहीही विचारा...';

  @override
  String get aiSuggestedFollowups => 'सुचवलेले पुढील प्रश्न';

  @override
  String get aiThinking => 'विचार करत आहे...';

  @override
  String get aiThanks => 'धन्यवाद!';

  @override
  String get aiFeedbackNoted => 'अभिप्राय नोंदवला';

  @override
  String get svcAll => 'सर्व';

  @override
  String get svcNoServices => 'कोणतीही सेवा उपलब्ध नाही';

  @override
  String get svcFree => 'मोफत';

  @override
  String get astroFailedStartCall => 'कॉल सुरू करण्यात अयशस्वी';

  @override
  String get astroFailedStartChat => 'चॅट सुरू करण्यात अयशस्वी';

  @override
  String astroErrorDetail(String error) {
    return 'त्रुटी: ${error}';
  }

  @override
  String get astroExperience => 'अनुभव';

  @override
  String get astroSessions => 'सत्रे';

  @override
  String get astroMinutes => 'मिनिटे';

  @override
  String get astroAbout => 'विषयी';

  @override
  String get astroLanguages => 'भाषा';

  @override
  String get astroRateCard => 'दर सूची';

  @override
  String get astroVoice => 'आवाज';

  @override
  String astroReviews(int count) {
    return 'पुनरावलोकने (${count})';
  }

  @override
  String get astroNoReviews => 'अद्याप पुनरावलोकने नाहीत';

  @override
  String get astroAnonymous => 'निनावी';

  @override
  String get forgotPasswordSubtitle => 'तुमचा ईमेल टाका आणि आम्ही तुम्हाला\nपासवर्ड रीसेट करण्यासाठी लिंक पाठवू.';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => 'लिंक पुन्हा पाठवा';

  @override
  String get appName => 'नक्षत्रलॉजी';

  @override
  String get cosmicJourneyAwaits => 'तुमचा वैश्विक प्रवास वाट पाहतोय';

  @override
  String get home => 'मुख्यपृष्ठ';

  @override
  String get astrologers => 'ज्योतिषी';

  @override
  String get services => 'सेवा';

  @override
  String get wallet => 'वॉलेट';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get live => 'लाइव्ह';

  @override
  String get kundli => 'कुंडली';

  @override
  String get chat => 'चॅट';

  @override
  String get call => 'कॉल';

  @override
  String get video => 'व्हिडिओ';

  @override
  String get signIn => 'साइन इन';

  @override
  String get createAccount => 'खाते तयार करा';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्ड पुन्हा लिहा';

  @override
  String get fullName => 'पूर्ण नाव';

  @override
  String get phone => 'फोन (ऐच्छिक)';

  @override
  String get forgotPassword => 'पासवर्ड विसरलात?';

  @override
  String get sendResetLink => 'रीसेट लिंक पाठवा';

  @override
  String get backToSignIn => 'साइन इन वर परत जा';

  @override
  String get dontHaveAccount => 'खाते नाही?';

  @override
  String get alreadyHaveAccount => 'आधीच खाते आहे?';

  @override
  String get continueGoogle => 'Google ने सुरू ठेवा';

  @override
  String get required => 'आवश्यक';

  @override
  String get minSixChars => 'किमान ६ अक्षरे';

  @override
  String get passwordsMismatch => 'पासवर्ड जुळत नाहीत';

  @override
  String get validEmailRequired => 'वैध ईमेल आवश्यक';

  @override
  String get loginFailed => 'लॉगिन अयशस्वी';

  @override
  String get signupFailed => 'साइनअप अयशस्वी';

  @override
  String get welcomeBack => 'पुन्हा स्वागत';

  @override
  String get todaysHoroscope => 'आजचे राशिभविष्य';

  @override
  String get todaysRashi => 'आजची राशी';

  @override
  String get tapDetails => 'तपशीलांसाठी टॅप करा';

  @override
  String get allServices => 'सर्व सेवा';

  @override
  String get seeAll => 'सर्व पहा';

  @override
  String get topAstrologers => 'शीर्ष ज्योतिषी';

  @override
  String get onlineExperts => 'सल्लामसलतीसाठी ऑनलाइन तज्ञ';

  @override
  String get searchAstrologers => 'ज्योतिषी शोधा...';

  @override
  String get noAstrologersFound => 'ज्योतिषी सापडले नाहीत';

  @override
  String get online => 'ऑनलाइन';

  @override
  String get offline => 'ऑफलाइन';

  @override
  String get busy => 'व्यस्त';

  @override
  String get perMin => '/मिनिट';

  @override
  String get noCharts => 'अद्याप जन्म कुंडली नाही';

  @override
  String get createFirst => 'तुमची पहिली जन्म कुंडली तयार करा';

  @override
  String get createChart => 'कुंडली तयार करा';

  @override
  String get newBirthChart => 'नवीन जन्म कुंडली';

  @override
  String get clientName => 'नाव';

  @override
  String get gender => 'लिंग';

  @override
  String get male => 'पुरुष';

  @override
  String get female => 'स्त्री';

  @override
  String get other => 'इतर';

  @override
  String get dateOfBirth => 'जन्मतारीख';

  @override
  String get timeOfBirth => 'जन्मवेळ';

  @override
  String get birthPlace => 'जन्मस्थान';

  @override
  String get birthPlaceHint => 'शहराचे नाव टाइप करा...';

  @override
  String get generateKundli => 'कुंडली तयार करा';

  @override
  String get birthChartCreated => 'जन्म कुंडली तयार झाली!';

  @override
  String get deleteChart => 'कुंडली हटवायची?';

  @override
  String get cannotUndo => 'हे पूर्ववत करता येणार नाही.';

  @override
  String get primary => 'प्राथमिक';

  @override
  String get viewKundli => 'कुंडली पहा';

  @override
  String get completeBirthChart => 'संपूर्ण जन्म कुंडली';

  @override
  String get birthDetails => 'जन्म तपशील';

  @override
  String get name => 'नाव';

  @override
  String get dob => 'जन्मतारीख';

  @override
  String get tob => 'जन्मवेळ';

  @override
  String get place => 'ठिकाण';

  @override
  String get summary => 'सारांश';

  @override
  String get planets => 'ग्रह';

  @override
  String get divisions => 'विभाग';

  @override
  String get vimshottari => 'विंशोत्तरी';

  @override
  String get moola => 'मूळ';

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
  String get aspects => 'दृष्टी';

  @override
  String get lifeAreas => 'जीवन क्षेत्रे';

  @override
  String get bhava => 'भाव';

  @override
  String get chakras => 'चक्रे';

  @override
  String get dashaActive => 'दशा सक्रिय';

  @override
  String get lagna => 'लग्न';

  @override
  String get moon => 'चंद्र';

  @override
  String get sun => 'सूर्य';

  @override
  String get premiumSection => 'प्रीमियम विभाग';

  @override
  String get unlockReading => 'तपशीलवार विश्लेषण पाहण्यासाठी अनलॉक करा.';

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
  String get addBalance => 'शिल्लक जोडा';

  @override
  String get amount => 'रक्कम';

  @override
  String get walletBalance => 'वॉलेट शिल्लक';

  @override
  String get recharge => 'रिचार्ज';

  @override
  String get bonus => 'बोनस';

  @override
  String get serviceLabel => 'सेवा';

  @override
  String get refund => 'परतावा';

  @override
  String get noTransactions => 'व्यवहार नाहीत';

  @override
  String get editProfile => 'प्रोफाइल संपादित करा';

  @override
  String get savedAstrologers => 'जतन केलेले ज्योतिषी';

  @override
  String get noSavedAstrologers => 'अद्याप जतन केलेले ज्योतिषी नाहीत';

  @override
  String get myOrders => 'माझ्या ऑर्डर';

  @override
  String get communicationHistory => 'संवाद इतिहास';

  @override
  String get chatHistory => 'चॅट इतिहास';

  @override
  String get callHistory => 'कॉल इतिहास';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get chatMessages => 'चॅट संदेश';

  @override
  String get typeMessage => 'संदेश लिहा...';

  @override
  String get sessionEnded => 'सत्र संपले';

  @override
  String get endChat => 'चॅट संपवायची?';

  @override
  String get endChatConfirm => 'तुम्हाला खात्री आहे की हे चॅट सत्र संपवायचे आहे?';

  @override
  String get sendPhoto => 'फोटो पाठवा';

  @override
  String get sendPDF => 'PDF पाठवा';

  @override
  String get upload => 'अपलोड';

  @override
  String get fileNotFound => 'फाइल सापडली नाही';

  @override
  String get voiceCall => 'व्हॉइस कॉल';

  @override
  String get videoCall => 'व्हिडिओ कॉल';

  @override
  String get ringing => 'रिंग होत आहे...';

  @override
  String get connected => 'जोडलेले';

  @override
  String get endCall => 'कॉल संपवा';

  @override
  String get mute => 'म्यूट';

  @override
  String get unmute => 'अनम्यूट';

  @override
  String get speaker => 'स्पीकर';

  @override
  String get camera => 'कॅमेरा';

  @override
  String get flip => 'फ्लिप';

  @override
  String get liveStreams => 'लाइव्ह स्ट्रीम्स';

  @override
  String get noLiveStreams => 'सध्या लाइव्ह स्ट्रीम नाहीत';

  @override
  String get astrologerUnavailable => 'ज्योतिषी उपलब्ध नाहीत. स्ट्रीम संपत आहे.';

  @override
  String get streamEnded => 'स्ट्रीम संपली';

  @override
  String get superChat => 'सुपर चॅट';

  @override
  String get sendGift => 'भेट पाठवा';

  @override
  String get goBack => 'मागे जा';

  @override
  String get appPermissions => 'अॅप परवानग्या';

  @override
  String get grantPermissions => 'परवानग्या द्या';

  @override
  String get skipForNow => 'सध्या वगळा';

  @override
  String get microphone => 'मायक्रोफोन';

  @override
  String get notifications => 'सूचना';

  @override
  String get storage => 'स्टोरेज';

  @override
  String get ok => 'ठीक आहे';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get save => 'जतन करा';

  @override
  String get edit => 'संपादित करा';

  @override
  String get delete => 'हटवा';

  @override
  String get retry => 'पुन्हा प्रयत्न करा';

  @override
  String get send => 'पाठवा';

  @override
  String get refresh => 'रिफ्रेश';

  @override
  String get loading => 'लोड होत आहे...';

  @override
  String get noData => 'डेटा उपलब्ध नाही';

  @override
  String get error => 'त्रुटी';

  @override
  String get success => 'यशस्वी';

  @override
  String get selectLanguage => 'भाषा निवडा';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'English';

  @override
  String get myDetails => 'माझा तपशील';

  @override
  String get myKundlis => 'माझ्या कुंडल्या';

  @override
  String get walletRecharge => 'वॉलेट आणि रिचार्ज';

  @override
  String get consultationHistory => 'सल्ला इतिहास';

  @override
  String get helpSupport => 'मदत आणि समर्थन';

  @override
  String get biometricLogin => 'बायोमेट्रिक लॉगिन';

  @override
  String get pastVoiceConsultations => 'मागील व्हॉइस सल्ला';

  @override
  String get pastTextConversations => 'मागील मजकूर संभाषणे';

  @override
  String get comingSoon => 'लवकरच येत आहे';

  @override
  String get totalCredit => 'एकूण क्रेडिट';

  @override
  String get totalDebit => 'एकूण डेबिट';

  @override
  String get statement => 'विवरण';

  @override
  String get allTypes => 'सर्व प्रकार';

  @override
  String get prev => 'मागील';

  @override
  String get next => 'पुढील';

  @override
  String get allInsights => 'सर्व विश्लेषण';

  @override
  String get yourCompleteReading => 'तुमचे पूर्ण वाचन';

  @override
  String get expertEngines => 'तज्ञ इंजिन';

  @override
  String get eachInsightConsultation => 'प्रत्येक विश्लेषण एक पूर्ण सल्ला आहे';

  @override
  String get engines => 'इंजिन';

  @override
  String get dataPoints => 'डेटा पॉइंट';

  @override
  String get singleChart => 'सिंगल';

  @override
  String get careerPurpose => 'करिअर आणि उद्देश';

  @override
  String get wealthAssets => 'संपत्ती आणि मालमत्ता';

  @override
  String get loveRelationships => 'प्रेम आणि नाते';

  @override
  String get healthWellness => 'आरोग्य आणि कल्याण';

  @override
  String get soulKarma => 'आत्मा आणि कर्म';

  @override
  String get specialistReports => 'तज्ञ अहवाल';

  @override
  String get searchByNameSpeciality => 'नाव, विशेषता शोधा...';

  @override
  String get sortedByRating => 'रेटिंगनुसार';

  @override
  String get initiatingChat => 'चॅट सुरू होत आहे...';

  @override
  String get startingCall => 'कॉल सुरू होत आहे...';

  @override
  String get yrs => 'वर्षे';

  @override
  String get chatWithAISpecialist => 'AI तज्ञांशी चॅट करा';

  @override
  String get tapToStart => 'सुरू करण्यासाठी टॅप करा';

  @override
  String get astrologer => 'ज्योतिषी';

  @override
  String get reports => 'अहवाल';

  @override
  String get milan => 'मिलन';

  @override
  String get forecast => 'भविष्यवाणी';

  @override
  String get rashi => 'राशी';

  @override
  String get jupiterFavorsBold => 'गुरू धाडसी पावलांना अनुकूल आहे';

  @override
  String get careerIlluminated => 'तुमचे करिअर क्षेत्र प्रकाशमान आहे — तुमच्या अंतर्ज्ञानावर विश्वास ठेवा.';

  @override
  String get todaysForecast => 'आजचे भविष्य';

  @override
  String get engCareer => 'करिअर आणि नोकरी';

  @override
  String get engBusiness => 'व्यवसाय आणि स्टार्टअप';

  @override
  String get engEducation => 'शिक्षण आणि अभ्यास';

  @override
  String get engLifePath => 'जीवन मार्ग आणि नशीब';

  @override
  String get engWealth => 'संपत्ती आणि वित्त';

  @override
  String get engDebt => 'कर्ज आणि वसुली';

  @override
  String get engProperty => 'मालमत्ता आणि आस्ति';

  @override
  String get engLegal => 'कायदेशीर आणि वाद';

  @override
  String get engLove => 'प्रेम आणि रोमान्स';

  @override
  String get engMarriage => 'विवाह आणि कुटुंब';

  @override
  String get engKundliMilan => 'कुंडली मिलन';

  @override
  String get engRelationship => 'नाते विश्लेषण';

  @override
  String get engLoveCompat => 'प्रेम अनुकूलता';

  @override
  String get engChildProb => 'अपत्य संभावना';

  @override
  String get engHealth => 'आरोग्य आणि कल्याण';

  @override
  String get engMental => 'मानसिक आणि ताण';

  @override
  String get engCharacter => 'व्यक्तिमत्व विश्लेषण';

  @override
  String get engPastLife => 'पूर्वजन्म आणि कर्म';

  @override
  String get engKarmaLink => 'कर्म संबंध';

  @override
  String get noChatSessions => 'अद्याप चॅट सत्र नाहीत';

  @override
  String get chatAppearHere => 'ज्योतिषींशी तुमच्या संवाद येथे दिसतील.';

  @override
  String get noCallsYet => 'अद्याप कॉल नाहीत';

  @override
  String get callAppearHere => 'ज्योतिषींशी तुमचा कॉल इतिहास येथे दिसेल.';

  @override
  String get chatWith => 'शी चॅट';

  @override
  String get msgs => 'संदेश';

  @override
  String get voiceCallLabel => 'व्हॉइस कॉल';

  @override
  String get videoCallLabel => 'व्हिडिओ कॉल';

  @override
  String get pullToRefresh => 'रिफ्रेश करण्यासाठी खाली ओढा';

  @override
  String get sessionExpired => 'सत्र संपले';

  @override
  String get connectionFailed => 'कनेक्शन अयशस्वी';

  @override
  String get callActive => 'कॉल सक्रिय';

  @override
  String get lessThanOneMin => '1 मिनिटापेक्षा कमी शिल्लक';

  @override
  String get noMessages => 'या सत्रात संदेश नाहीत';

  @override
  String get gocharForAllSigns => 'सर्व 12 राशींचा आजचा गोचर';

  @override
  String get selectChart => 'विश्लेषणासाठी कुंडली निवडा';

  @override
  String get selectTwoCharts => 'दोन कुंडल्या निवडा';

  @override
  String get analyzing => 'विश्लेषण सुरू आहे...';

  @override
  String get browseAstrologers => 'ज्योतिषी शोधा';

  @override
  String get probableNumber => 'संभाव्य संख्या';

  @override
  String get genderTendency => 'लिंग प्रवृत्ती';

  @override
  String get son => 'पुत्र';

  @override
  String get daughter => 'पुत्री';

  @override
  String get occupants => 'निवासी ग्रह';

  @override
  String get beneficAspects => 'शुभ दृष्टी';

  @override
  String get maleficAspects => 'पाप दृष्टी';

  @override
  String get nextFavorableWindow => 'पुढील अनुकूल कालावधी';

  @override
  String get totalDoshaPenalty => 'एकूण दोष दंड';

  @override
  String get cancellationFactors => 'निरसन घटक';

  @override
  String get combinedFertility => 'एकत्रित प्रजनन संकेत';

  @override
  String get planetPositions => 'ग्रह स्थिती';

  @override
  String get bestWindows => 'सर्वोत्तम कालावधी';

  @override
  String get worstWindows => 'प्रतिकूल कालावधी';

  @override
  String get scoreComponents => 'गुण घटक';

  @override
  String get topOpportunities => 'शीर्ष संधी';

  @override
  String get topRisks => 'शीर्ष धोके';

  @override
  String get remedies => 'उपाय';

  @override
  String get keyInsights => 'मुख्य अंतर्दृष्टी';

  @override
  String get overallVerdict => 'एकूण निर्णय';

  @override
  String get venusContacts => 'शुक्र क्रॉस संपर्क';

  @override
  String get contact => 'संपर्क';

  @override
  String get effect => 'प्रभाव';

  @override
  String get moonSignCompat => 'चंद्र राशी अनुकूलता';

  @override
  String get hisMoon => 'त्यांचा चंद्र';

  @override
  String get herMoon => 'तिचा चंद्र';

  @override
  String get nakshatraCompat => 'नक्षत्र अनुकूलता';

  @override
  String get ketuContacts => 'केतू संपर्क';

  @override
  String get rahuContacts => 'राहू संपर्क';

  @override
  String get pastLifeIndication => 'पूर्वजन्म संकेत';

  @override
  String get totalChallengePenalty => 'एकूण आव्हान दंड';

  @override
  String get manifestation => 'अभिव्यक्ती';

  @override
  String get cancellation => 'निरसन';

  @override
  String get navigation => 'मार्गदर्शन';

  @override
  String get potentialStrengths => 'संभाव्य शक्ती';

  @override
  String get areasToNurture => 'पोषण क्षेत्रे';

  @override
  String get relationshipGuidance => 'नाते मार्गदर्शन';

  @override
  String get detailedSummary => 'सविस्तर सारांश';

  @override
  String get discussWithAI => 'AI शी चर्चा करा';

  @override
  String get planet => 'ग्रह';

  @override
  String get sign => 'राशी';

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
  String get numberExplanation => 'संख्या स्पष्टीकरण';

  @override
  String get genderExplanation => 'लिंग स्पष्टीकरण';

  @override
  String get inFifth => '5व्या मध्ये?';

  @override
  String get primaryArchetype => 'प्राथमिक प्रारूप';

  @override
  String get mitigation => 'शमन';

  @override
  String get soulCareerAlign => 'आत्मा ↔ करिअर संरेखन';

  @override
  String get favorablePeriods => 'अनुकूल काळ';

  @override
  String get challengingPeriods => 'आव्हानात्मक काळ';

  @override
  String get keyHouses => 'प्रमुख भाव';

  @override
  String get keyPlanets => 'प्रमुख ग्रह';

  @override
  String get characterOverview => 'व्यक्तिमत्व अवलोकन';

  @override
  String get noYogasActive => 'या कुंडलीत सध्या कोणताही योग सक्रिय नाही.';

  @override
  String get basedOnPlanetStrengths => 'ग्रह बल आणि भाव स्थितीवर आधारित';

  @override
  String get basedOnTransits => 'सध्याच्या ग्रह गोचरावर आधारित';

  @override
  String get currentPlanetPositions => 'तुमची राशी पहिला भाव मानून सध्याच्या ग्रह स्थिती';

  @override
  String get favorablePeriodAdvice => 'अनुकूल काळ — करिअर वाढ आणि नात्यांवर लक्ष केंद्रित करा.';

  @override
  String get noClassicalYogas => 'शास्त्रीय योगांशिवाय, यश सातत्याने प्रयत्नातून येते.';

  @override
  String get walletDeduction => 'रक्कम तुमच्या वॉलेटमधून कापली जाईल';

  @override
  String get bhakootAxis => 'भकूट अक्ष';

  @override
  String get basis => 'आधार';

  @override
  String get selectChartsForMilan => 'मिलनासाठी 2 कुंडल्या निवडा';

  @override
  String get selectMultiCharts => '2-5 कुंडल्या निवडा';

  @override
  String get running => 'चालू';

  @override
  String get past => 'भूतकाळ';

  @override
  String get topActiveDoshas => 'शीर्ष सक्रिय दोष';

  @override
  String get allDoshas => 'सर्व दोष';

  @override
  String get activeYogas => 'सक्रिय योग';

  @override
  String get activeDoshas => 'सक्रिय दोष';

  @override
  String get yogaAnalysis => 'योग विश्लेषण';

  @override
  String get factors => 'घटक';

  @override
  String get dominantPlanet => 'प्रमुख ग्रह';

  @override
  String get startSession => 'सत्र सुरू करा';

  @override
  String get notesSaved => 'नोट्स सेव्ह झाल्या';

  @override
  String get unlocked => 'अनलॉक! तुमचे वाचन आनंद घ्या.';

  @override
  String get todaysGochar => 'आजचे गोचर';

  @override
  String get todaysTransitChart => 'आजचा गोचर तक्ता';

  @override
  String get lifeAreaPredictions => 'जीवन क्षेत्र भविष्य';

  @override
  String get strengths => 'शक्ती';

  @override
  String get weaknesses => 'कमकुवतपणा';

  @override
  String get ruledBy => 'स्वामी';

  @override
  String get kundliMilan => 'कुंडली मिलन';

  @override
  String get startKundliMilan => 'कुंडली मिलन सुरू करा';

  @override
  String get recommendations => 'शिफारसी';

  @override
  String get cancellations => 'निरसन';

  @override
  String get dashaSync => 'दशा समन्वय';

  @override
  String get transitMarriageWindows => 'गोचर विवाह कालावधी';

  @override
  String get overlappingWindows => 'ओव्हरलॅपिंग विवाह कालावधी';

  @override
  String get overallStrength => 'एकूण बल';

  @override
  String get stability => 'स्थिरता';

  @override
  String get growth => 'वाढ';

  @override
  String get clarity => 'स्पष्टता';

  @override
  String get recognition => 'ओळख';

  @override
  String get satisfaction => 'समाधान';

  @override
  String get verdict => 'निर्णय';

  @override
  String get topRoles => 'शीर्ष भूमिका';

  @override
  String get areasForGrowth => 'विकास क्षेत्र';

  @override
  String get bestIndustries => 'सर्वोत्तम उद्योग';

  @override
  String get employment => 'नोकरी';

  @override
  String get entrepreneurship => 'उद्योजकता';

  @override
  String get freelance => 'फ्रीलान्स';

  @override
  String get portfolio => 'पोर्टफोलिओ';

  @override
  String get burnoutRisk => 'थकवा धोका';

  @override
  String get careerStagnation => 'करिअर ठप्प';

  @override
  String get workplaceConflict => 'कार्यस्थळ संघर्ष';

  @override
  String get positioning => 'स्थिती निर्धारण';

  @override
  String get skillDevelopment => 'कौशल्य विकास';

  @override
  String get network => 'नेटवर्क';

  @override
  String get visibility => 'दृश्यमानता';

  @override
  String get lagnaLord => 'लग्न स्वामी';

  @override
  String get tenthLord => 'दसवा स्वामी';

  @override
  String get lord => 'स्वामी';

  @override
  String get lordPlacedIn => 'स्वामी स्थित';

  @override
  String get lordDignity => 'स्वामी प्रतिष्ठा';

  @override
  String get d9Dignity => 'डी9 प्रतिष्ठा';

  @override
  String get careerAnalysis => 'करिअर विश्लेषण';

  @override
  String get launchWindows => 'शुभारंभ कालावधी';

  @override
  String get peakWindows => 'शिखर कालावधी';

  @override
  String get promotionWindows => 'पदोन्नती कालावधी';

  @override
  String get riskWindows => 'धोका कालावधी';

  @override
  String get timingWindows => 'वेळ कालावधी';

  @override
  String get careerRisks => 'करिअर धोके';

  @override
  String get astrologicalRemedies => 'ज्योतिषीय उपाय';

  @override
  String get practicalSolutions => 'व्यावहारिक उपाय';

  @override
  String get analysisConfidence => 'विश्लेषण विश्वासार्हता';

  @override
  String get careerArchetype => 'करिअर प्रारूप';

  @override
  String get workStructure => 'कार्य संरचना';

  @override
  String get teamLeadership => 'टीम नेतृत्व';

  @override
  String get idealEnvironment => 'आदर्श वातावरण';

  @override
  String get idealOrgSize => 'आदर्श संस्था आकार';

  @override
  String get fitScore => 'फिट गुण';

  @override
  String get recommended => 'शिफारस';

  @override
  String get divisionalValidation => 'विभागीय सत्यापन';

  @override
  String get houseAnalysis => 'भाव विश्लेषण';

  @override
  String get jaiminiKarakas => 'जैमिनी कारक';

  @override
  String get copyFullReport => 'संपूर्ण अहवाल कॉपी करा';

  @override
  String get reportCopied => 'अहवाल कॉपी झाला!';
}
