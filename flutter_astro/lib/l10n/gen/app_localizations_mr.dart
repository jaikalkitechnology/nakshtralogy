// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

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
  String get kundliAscendantLagna => 'लग्न (आरोह)';

  @override
  String get kundliMoonSignRashi => 'चंद्र राशी';

  @override
  String get kundliSunSign => 'सूर्य राशी';

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
  String get grahaDrishti => 'ग्रह दृष्टी (ग्रहांच्या दृष्टी)';

  @override
  String get rashiDrishti => 'राशी दृष्टी (राशींच्या दृष्टी)';

  @override
  String get grahaDrishtiSubtitle => 'कोण कोणावर दृष्टी टाकतो (%)';

  @override
  String get lagnaAspectsReceived => 'लग्नावरील दृष्टी';

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
  String get gradeExcellent => 'उत्कृष्ट';

  @override
  String get gradeGood => 'चांगले';

  @override
  String get gradeAverage => 'सरासरी';

  @override
  String get gradeWeak => 'कमकुवत';

  @override
  String get careerWord => 'करिअर';

  @override
  String get educationWord => 'शिक्षण';

  @override
  String get lifeAreaMarriage => 'विवाह';

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
  String get forecast => 'भविष्यवाणी';

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
  String get best => 'सर्वोत्तम';

  @override
  String get worst => 'सर्वात वाईट';

  @override
  String get avg => 'avg';

  @override
  String get love => 'प्रेम';

  @override
  String get spiritual => 'आध्यात्मिक';

  @override
  String get analysisConfidence => 'विश्लेषण विश्वसनीयता';

  @override
  String get areasForGrowth => 'वाढीची क्षेत्रे';

  @override
  String get astrologicalRemedies => 'ज्योतिषीय उपाय';

  @override
  String get bestIndustries => 'सर्वोत्तम उद्योग';

  @override
  String get burnoutRisk => 'थकवा जोखीम';

  @override
  String get careerAnalysis => 'करिअर विश्लेषण';

  @override
  String get careerArchetype => 'करिअर आदर्श';

  @override
  String get careerRisks => 'करिअर जोखीम';

  @override
  String get careerStagnation => 'करिअर स्थगिती';

  @override
  String get clarity => 'स्पष्टता';

  @override
  String get copyFullReport => 'संपूर्ण अहवाल डेटा कॉपी करा';

  @override
  String get d9Dignity => 'D9 बल';

  @override
  String get divisionalValidation => 'वर्ग कुंडली पडताळणी';

  @override
  String get employment => 'नोकरी';

  @override
  String get entrepreneurship => 'उद्योजकता';

  @override
  String get fitScore => 'योग्यता गुण';

  @override
  String get freelance => 'फ्रीलान्स';

  @override
  String get growth => 'वाढ';

  @override
  String get houseAnalysis => 'भाव विश्लेषण';

  @override
  String get idealEnvironment => 'आदर्श वातावरण';

  @override
  String get idealOrgSize => 'आदर्श संस्था आकार';

  @override
  String get jaiminiKarakas => 'जैमिनी कारक';

  @override
  String get lagnaLord => 'लग्नेश';

  @override
  String get launchWindows => 'आरंभ कालावधी';

  @override
  String get lord => 'स्वामी';

  @override
  String get lordDignity => 'स्वामी बल';

  @override
  String get lordPlacedIn => 'स्वामी स्थित';

  @override
  String get overallStrength => 'एकूण बल';

  @override
  String get peakWindows => 'उच्च कालावधी';

  @override
  String get portfolio => 'पोर्टफोलिओ';

  @override
  String get practicalSolutions => 'व्यावहारिक उपाय';

  @override
  String get promotionWindows => 'पदोन्नती कालावधी';

  @override
  String get recognition => 'मान्यता';

  @override
  String get recommended => 'शिफारस केलेले';

  @override
  String get riskWindows => 'जोखीम कालावधी';

  @override
  String get satisfaction => 'समाधान';

  @override
  String get stability => 'स्थिरता';

  @override
  String get teamLeadership => 'संघ नेतृत्व';

  @override
  String get tenthLord => 'दशमेश';

  @override
  String get timingWindows => 'काळ कालावधी';

  @override
  String get verdict => 'निर्णय';

  @override
  String get workStructure => 'कार्य रचना';

  @override
  String get workplaceConflict => 'कामाच्या ठिकाणी संघर्ष';

  @override
  String get mitigationLabel => 'उपशमन';

  @override
  String get reliabilityVeryHigh => 'अत्यंत उच्च विश्वसनीयता';

  @override
  String get reliabilityHigh => 'उच्च विश्वसनीयता';

  @override
  String get reliabilityModerate => 'मध्यम विश्वसनीयता';

  @override
  String get reliabilityGuidance => 'मार्गदर्शन-स्तर वाचन';

  @override
  String get relationshipTitlePrefix => 'नातेसंबंध';

  @override
  String get relationshipTitleSuffix => 'बुद्धिमत्ता';

  @override
  String get relationshipIntelBannerLabel => 'नातेसंबंध बुद्धिमत्ता';

  @override
  String get typeLabel => 'प्रकार';

  @override
  String get trustLabel => 'विश्वास';

  @override
  String get dhokaRiskLabel => 'धोका जोखीम';

  @override
  String powerLabel(Object power) {
    return 'शक्ती: ${power}';
  }

  @override
  String get chartProfilesPrefix => 'कुंडली';

  @override
  String get chartProfilesSuffix => 'प्रोफाइल';

  @override
  String lagnaSuffixLabel(Object sign) {
    return '${sign} लग्न';
  }

  @override
  String get miniIntegrityLabel => 'सचोटी';

  @override
  String get miniWarmthLabel => 'उबदारपणा';

  @override
  String get miniTrustLabel => 'विश्वास';

  @override
  String get miniAssertLabel => 'ठामपणा';

  @override
  String akLabel(Object planet) {
    return 'AK: ${planet}';
  }

  @override
  String get pairwisePrefix => 'जोडीनिहाय';

  @override
  String get pairwiseSuffix => 'विश्लेषण';

  @override
  String trustPercentLabel(Object pct) {
    return 'विश्वास: ${pct}%';
  }

  @override
  String betrayalPercentLabel(Object pct) {
    return 'विश्वासघात: ${pct}%';
  }

  @override
  String get scoreCharacterLabel => 'चारित्र्य';

  @override
  String get scoreLoveLabel => 'प्रेम';

  @override
  String get scoreBusinessLabel => 'व्यवसाय';

  @override
  String get scoreKarmicLabel => 'कर्म';

  @override
  String get scoreTrustLabel => 'विश्वास';

  @override
  String get scoreEnmityRiskLabel => 'शत्रुत्व जोखीम';

  @override
  String dynamicLabel(Object value) {
    return 'गतिशील: ${value}';
  }

  @override
  String karmicLabel(Object value) {
    return 'कर्म: ${value}';
  }

  @override
  String get criticalPrefix => 'महत्त्वाचे';

  @override
  String get criticalSuffix => 'नमुने';

  @override
  String get groupPrefix => 'समूह';

  @override
  String get groupSuffix => 'शिफारसी';

  @override
  String get sharedPracticesLabel => 'सामायिक साधना';

  @override
  String communicationLabel(Object value) {
    return 'संवाद: ${value}';
  }

  @override
  String focusLabel(Object value) {
    return 'लक्ष: ${value}';
  }

  @override
  String get individualPrefix => 'वैयक्तिक';

  @override
  String get individualSuffix => 'मार्गदर्शन';

  @override
  String karmicLessonLabel(Object value) {
    return 'कर्म धडा: ${value}';
  }

  @override
  String get growthAreasLabel => 'वाढीची क्षेत्रे';

  @override
  String get corePrefix => 'मुख्य';

  @override
  String get coreSuffix => 'थीम';

  @override
  String get growthOrientedLabel => 'वाढ-केंद्रित';

  @override
  String get groupThemeLabel => 'समूह थीम';

  @override
  String get analysisPrefix => 'विश्लेषण';

  @override
  String get analysisConfidenceSuffix => 'विश्वसनीयता';

  @override
  String get reportCopied => 'अहवाल कॉपी झाला!';

  @override
  String get copyFullReportData => 'संपूर्ण अहवाल डेटा कॉपी करा';

  @override
  String get openExternalLabel => 'उघडा';

  @override
  String copiedOpeningAi(Object ai) {
    return 'कॉपी झाले! ${ai} उघडत आहे...';
  }

  @override
  String get milanTitlePrefix => 'कुंडली';

  @override
  String get ashtakoot => 'अष्टकूट';

  @override
  String get compatibilityLabel => 'अनुकूलता';

  @override
  String get unifiedScoreLabel => 'एकत्रित\nगुण';

  @override
  String get probabilityLabel => 'संभाव्यता';

  @override
  String ganaLabel(Object value) {
    return 'गण: ${value}';
  }

  @override
  String get gunPrefixLabel => '8 गुण';

  @override
  String get breakdownLabel => 'तपशील';

  @override
  String get mangalLabel => 'मंगळ';

  @override
  String severityLabel(Object value) {
    return 'तीव्रता: ${value}';
  }

  @override
  String get d9Label => 'D-9';

  @override
  String get crossChartLabel => 'क्रॉस-कुंडली';

  @override
  String get d9CompatibilityLabel => 'D-9 अनुकूलता';

  @override
  String get domainEmotional => 'भावनिक';

  @override
  String get domainIntellectual => 'बौद्धिक';

  @override
  String get domainSpiritual => 'आध्यात्मिक';

  @override
  String get domainFinancial => 'आर्थिक';

  @override
  String get domainDomestic => 'घरगुती';

  @override
  String get domainCommunication => 'संवाद';

  @override
  String get domainSharedDharma => 'सामायिक धर्म';

  @override
  String get domainFamilyCreation => 'कुटुंब निर्मिती';

  @override
  String get domainLabel => 'क्षेत्र';

  @override
  String get compatibilitySuffixLabel => 'अनुकूलता';

  @override
  String get marriageLabel => 'विवाह';

  @override
  String get timingLabel => 'काळ';

  @override
  String get jointMarriageWindowsTitle => 'संयुक्त विवाह कालावधी';

  @override
  String get engagementWindowsTitle => 'साखरपुडा कालावधी';

  @override
  String recommendedLabel(Object value) {
    return 'शिफारस: ${value}';
  }

  @override
  String get risksLabel => 'जोखीम';

  @override
  String get finalLabel => 'अंतिम';

  @override
  String get verdictLabel => 'निर्णय';

  @override
  String get marriageVerdictLabel => 'विवाह निर्णय';

  @override
  String get discussReportWithAI => 'हा अहवाल AI सोबत चर्चा करा';

  @override
  String get multiChartTitleChild => 'अपत्य';

  @override
  String get multiChartTitleLove => 'प्रेम';

  @override
  String get multiChartTitleKarma => 'कर्म';

  @override
  String get multiChartTitleDefault => 'मल्टी-कुंडली';

  @override
  String get multiChartSuffixProbability => 'संभाव्यता';

  @override
  String get multiChartSuffixCompatibility => 'अनुकूलता';

  @override
  String get multiChartSuffixLinkage => 'संबंध';

  @override
  String get multiChartSuffixReport => 'अहवाल';

  @override
  String get participantsLabel => 'सहभागी';

  @override
  String get reportDataCopied => 'अहवाल डेटा कॉपी झाला!';

  @override
  String copiedForAi(Object label) {
    return '${label} साठी कॉपी झाले!';
  }

  @override
  String get wealthScoresLabel => 'संपत्ती गुण';

  @override
  String get wealthStrengthLabel => 'संपत्ती\nबल';

  @override
  String get accumulationLabel => 'संचय';

  @override
  String get incomeFlowLabel => 'उत्पन्न\nप्रवाह';

  @override
  String get sustainLabel => 'टिकाव';

  @override
  String get multiStreamLabel => 'बहु-स्रोत';

  @override
  String get retentionLabel => 'धारणा';

  @override
  String get wealthLabel => 'संपत्ती';

  @override
  String get karakasLabel => 'कारक';

  @override
  String get wealthYogasTitle => 'धन योग';

  @override
  String get drainsLabel => 'गळती';

  @override
  String get boostersLabel => 'वर्धक';

  @override
  String get incomeLabel => 'उत्पन्न';

  @override
  String get sourcesLabel => 'स्रोत';

  @override
  String get investmentLabel => 'गुंतवणूक';

  @override
  String get mixLabel => 'मिश्रण';

  @override
  String get yearlyTrendTitle => 'वार्षिक कल';

  @override
  String get wealthGrowthTitle => 'संपत्ती वाढ';

  @override
  String get cashPressureTitle => 'रोख दबाव';

  @override
  String get moneyPersonalityTitle => 'पैसा व्यक्तिमत्त्व';

  @override
  String get wealthTypeLabel => 'संपत्ती प्रकार';

  @override
  String get riskAppetiteLabel => 'जोखीम क्षमता';

  @override
  String get investmentStyleLabel => 'गुंतवणूक शैली';

  @override
  String get moneyPersonalityLabel => 'पैसा व्यक्तिमत्त्व';

  @override
  String get spendingLabel => 'खर्च';

  @override
  String get debtProbLabel => 'कर्ज संभाव्यता %';

  @override
  String get inheritanceProbLabel => 'वारसा %';

  @override
  String get suddenGainsProbLabel => 'आकस्मिक लाभ %';

  @override
  String get spouseBoostLabel => 'जोडीदार वृद्धी %';

  @override
  String successProbabilityLabel(Object pct) {
    return 'यश संभाव्यता: ${pct}%';
  }

  @override
  String get lifetimeWealthClassLabel => 'आजीवन संपत्ती वर्ग';

  @override
  String primaryLabel(Object value) {
    return 'प्राथमिक: ${value}';
  }

  @override
  String peakAgeLabel(Object value) {
    return 'उच्च: ${value}';
  }

  @override
  String drivenByLabel(Object value) {
    return '${value} द्वारे चालित';
  }

  @override
  String get coreBlockerLabel => 'मुख्य अडथळा';

  @override
  String get debtScoresLabel => 'कर्ज गुण';

  @override
  String get currentDebtLoadLabel => 'सध्याचा\nकर्ज भार';

  @override
  String get recoveryCapacityLabel => 'पुनर्प्राप्ती\nक्षमता';

  @override
  String get intensityLabel => 'तीव्रता';

  @override
  String get defaultRiskLabel => 'थकबाकी जोखीम';

  @override
  String get debtProfileTitle => 'कर्ज प्रोफाइल';

  @override
  String get karmaLabel => 'कर्म';

  @override
  String get personalityLabel => 'व्यक्तिमत्त्व';

  @override
  String get phaseLabel => 'टप्पा';

  @override
  String get primaryCategoryLabel => 'प्राथमिक श्रेणी';

  @override
  String get debtLabel => 'कर्ज';

  @override
  String get debtYogasTitle => 'कर्ज योग';

  @override
  String get debtCreatingLabel => 'कर्ज-निर्माण';

  @override
  String get debtClearingLabel => 'कर्ज-मुक्ती';

  @override
  String get categoriesLabel => 'श्रेणी';

  @override
  String get yearlyDebtTitle => 'वार्षिक कर्ज';

  @override
  String get repaymentTitle => 'परतफेड';

  @override
  String get dangerPeriodsTitle => 'धोकादायक कालावधी';

  @override
  String get defaultPctLabel => 'थकबाकी %';

  @override
  String get bankruptcyPctLabel => 'दिवाळखोरी %';

  @override
  String get chronicPctLabel => 'दीर्घकालीन %';

  @override
  String get resilienceLabel => 'लवचिकता';

  @override
  String recoveryTimelineLabel(Object pct, Object years) {
    return 'पुनर्प्राप्ती: ${pct}% · कालावधी: ${years} वर्षे';
  }

  @override
  String get debtFreeWindowLabel => 'कर्जमुक्त कालावधी';

  @override
  String yearLabel(Object year) {
    return 'वर्ष ${year}';
  }

  @override
  String dashaLabel(Object value) {
    return 'दशा: ${value}';
  }

  @override
  String get marriageScoresLabel => 'विवाह गुण';

  @override
  String get overallMarriageLabel => 'एकूण\nविवाह';

  @override
  String get maritalHarmonyLabel => 'वैवाहिक\nसुसंवाद';

  @override
  String get domesticStabilityLabel => 'घरगुती\nस्थिरता';

  @override
  String get longevityLabel => 'दीर्घायुष्य';

  @override
  String get satisfactionLabel => 'समाधान';

  @override
  String get clarityLabel => 'स्पष्टता';

  @override
  String get darakarakaLabel => 'दाराकारक';

  @override
  String get spouseKarakaLabel => 'जोडीदार कारक';

  @override
  String get darakarakaDkLabel => 'दाराकारक (DK)';

  @override
  String get seventhLabel => 'सप्तम';

  @override
  String get lordLabel => 'स्वामी';

  @override
  String get lordInLabel => 'स्वामी स्थित';

  @override
  String get lordDignityLabel => 'स्वामी बल';

  @override
  String get emptyLabel => 'रिक्त';

  @override
  String get spouseLabel => 'जोडीदार';

  @override
  String get spouseTraitsLabel => 'जोडीदार गुणधर्म';

  @override
  String get likelyProfessionsLabel => 'संभाव्य व्यवसाय';

  @override
  String get harmonyPhysicalLabel => 'शारीरिक';

  @override
  String get sharedValuesLabel => 'सामायिक मूल्ये';

  @override
  String get conflictResolutionLabel => 'संघर्ष निवारण';

  @override
  String get harmonyLabel => 'सुसंवाद';

  @override
  String get radarLabel => 'रडार';

  @override
  String get mangalDoshLabel => 'मंगळ दोष';

  @override
  String severityColonLabel(Object value) {
    return 'तीव्रता: ${value}';
  }

  @override
  String cancellationColonLabel(Object value) {
    return 'निवारण: ${value}';
  }

  @override
  String get marriageWindowsTitle => 'विवाह कालावधी';

  @override
  String get marriagePhasesTitle => 'विवाह टप्पे';

  @override
  String get inLawRelationsLabel => 'सासरचे संबंध';

  @override
  String get familyHarmonyLabel => 'कौटुंबिक सुसंवाद';

  @override
  String get fertilityLabel => 'प्रजनन क्षमता';

  @override
  String get homeOwnershipLabel => 'घर मालकी';

  @override
  String get divorceRiskLabel => 'घटस्फोट जोखीम';

  @override
  String get infidelityLabel => 'बेवफाई';

  @override
  String get conflictLabel => 'संघर्ष';

  @override
  String get distanceLabel => 'अंतर';

  @override
  String get seekInPartnerLabel => 'जोडीदारात शोधा';

  @override
  String get avoidInPartnerLabel => 'जोडीदारात टाळा';

  @override
  String realizationLabel(Object pct) {
    return 'प्राप्ती: ${pct}%';
  }

  @override
  String get navamsaLabel => 'नवमांश';

  @override
  String get characterScoresLabel => 'चारित्र्य गुण';

  @override
  String get characterStrengthLabel => 'चारित्र्य\nबल';

  @override
  String get characterIntegrityLabel => 'सचोटी';

  @override
  String get awarenessLabel => 'जागरूकता';

  @override
  String get stabilityLabel => 'स्थिरता';

  @override
  String get ethicsLabel => 'नैतिकता';

  @override
  String get surfacePersonalityTitle => 'बाह्य व्यक्तिमत्त्व';

  @override
  String get constitutionLabel => 'प्रकृती';

  @override
  String get nakshatraLabel => 'नक्षत्र';

  @override
  String get deityLabel => 'देवता';

  @override
  String get moonManasTitle => 'चंद्र मानस';

  @override
  String get warmthLabel => 'उबदारपणा';

  @override
  String get empathyLabel => 'सहानुभूती';

  @override
  String get loyaltyLabel => 'निष्ठा';

  @override
  String get boundariesLabel => 'सीमा';

  @override
  String get dharmaLabel => 'धर्म';

  @override
  String get truthLabel => 'सत्य';

  @override
  String get compassionLabel => 'करुणा';

  @override
  String get generosityLabel => 'उदारता';

  @override
  String get signatureVirtuesLabel => 'वैशिष्ट्यपूर्ण गुण';

  @override
  String get naturalTalentsLabel => 'नैसर्गिक कौशल्ये';

  @override
  String get shadowPatternsLabel => 'छाया नमुने';

  @override
  String get characterYogasTitle => 'चारित्र्य योग';

  @override
  String get testsLabel => 'परीक्षा';

  @override
  String get giftsLabel => 'देणग्या';

  @override
  String get selfAwareEiLabel => 'स्व-जागरूकता EI';

  @override
  String get selfRegulateLabel => 'स्व-नियमन';

  @override
  String get empathyEiLabel => 'सहानुभूती EI';

  @override
  String get socialSkillsLabel => 'सामाजिक कौशल्ये';

  @override
  String get atmakarakaLabel => 'आत्मकारक';

  @override
  String get soulSignatureLabel => 'आत्मा स्वाक्षरी';

  @override
  String get atmakarakaAllCapsLabel => 'आत्मकारक';

  @override
  String get gunaLabel => 'गुण';

  @override
  String dominantColonLabel(Object value) {
    return 'प्रबळ: ${value}';
  }

  @override
  String get coreGiftLabel => 'मुख्य देणगी';

  @override
  String get coreThemeAllCapsLabel => 'मुख्य थीम';

  @override
  String get pastLifeScoresLabel => 'पूर्वजन्म गुण';

  @override
  String get signatureStrengthLabel => 'स्वाक्षरी\nबल';

  @override
  String get carryForwardLabel => 'पुढे\nनेलेले';

  @override
  String get masteryPreservedLabel => 'प्रावीण्य\nजतन';

  @override
  String get unfinishedLabel => 'अपूर्ण';

  @override
  String get karmicDebtLabel => 'कर्म ऋण';

  @override
  String get pastMasteryLabel => 'पूर्व प्रावीण्य';

  @override
  String get futureGrowthLabel => 'भविष्य वाढ';

  @override
  String get ketuWhatYouMasteredLabel => 'केतू · जे तुम्ही आत्मसात केले';

  @override
  String get rahuWhatPullsForwardLabel => 'राहू · जे तुम्हाला पुढे नेते';

  @override
  String get pastLifeProfileTitle => 'पूर्वजन्म प्रोफाइल';

  @override
  String get themeLabel => 'थीम';

  @override
  String get professionLabel => 'व्यवसाय';

  @override
  String get socialStandingLabel => 'सामाजिक स्थान';

  @override
  String get regionLabel => 'प्रदेश';

  @override
  String get spiritualLevelLabel => 'आध्यात्मिक स्तर';

  @override
  String get wealthLevelLabel => 'संपत्ती स्तर';

  @override
  String get familyRoleLabel => 'कौटुंबिक भूमिका';

  @override
  String get skillsCarriedForwardLabel => 'पुढे नेलेली कौशल्ये';

  @override
  String get naturalAttractionsLabel => 'नैसर्गिक आकर्षणे';

  @override
  String get unexplainedFearsLabel => 'अस्पष्ट भीती';

  @override
  String get magneticPullsLabel => 'चुंबकीय ओढ';

  @override
  String get relationshipLabel => 'नातेसंबंध';

  @override
  String get financialLabel => 'आर्थिक';

  @override
  String get serviceLabel => 'सेवा';

  @override
  String get dharmicLabel => 'धार्मिक';

  @override
  String get onRelationsLabel => 'नातेसंबंधांवर';

  @override
  String get onCareerLabel => 'करिअरवर';

  @override
  String get onHealthLabel => 'आरोग्यावर';

  @override
  String get onSpiritualLabel => 'आध्यात्मावर';

  @override
  String get karmicResolutionTitle => 'कर्म निवारण';

  @override
  String get primaryPathLabel => 'प्राथमिक मार्ग';

  @override
  String get secondaryPathLabel => 'दुय्यम मार्ग';

  @override
  String get clearingProgressLabel => 'निवारण प्रगती';

  @override
  String get remainingWorkLabel => 'उर्वरित कार्य';

  @override
  String get debtTimelineLabel => 'ऋण कालरेषा';

  @override
  String get memoryAccessLabel => 'स्मृती प्रवेश';

  @override
  String get dreamVisitsLabel => 'स्वप्न भेटी';

  @override
  String get dejaVuLabel => 'देजा वू';

  @override
  String get regressionFitLabel => 'प्रतिगमन योग्यता';

  @override
  String get pastLifeActivationTitle => 'पूर्वजन्म सक्रियता';

  @override
  String maturityStatusLabel(Object score, Object status) {
    return 'परिपक्वता: ${score} · स्थिती: ${status}';
  }

  @override
  String shadowColonLabel(Object value) {
    return 'छाया: ${value}';
  }

  @override
  String get lifePathScoresLabel => 'जीवन मार्ग गुण';

  @override
  String get dharmaClarityLabel => 'धर्म\nस्पष्टता';

  @override
  String get fortuneBaselineLabel => 'भाग्य\nआधाररेषा';

  @override
  String get lifePathCoherenceLabel => 'जीवन मार्ग\nसुसंगती';

  @override
  String get karmaAllCapsLabel => 'कर्म';

  @override
  String get spiritualAllCapsLabel => 'आध्यात्मिक';

  @override
  String get fameLabel => 'कीर्ती';

  @override
  String get lifeLabel => 'जीवन';

  @override
  String get archetypeLabel => 'आदर्श';

  @override
  String get soulContractTitle => 'आत्मा करार';

  @override
  String get akFocusLabel => 'AK केंद्र';

  @override
  String get soulPurposeLabel => 'आत्मा उद्देश';

  @override
  String get lifeChapterLabel => 'जीवन अध्याय';

  @override
  String get primaryDomainLabel => 'प्राथमिक क्षेत्र';

  @override
  String get leadershipLabel => 'नेतृत्व';

  @override
  String get wisdomTeachLabel => 'ज्ञान/शिक्षण';

  @override
  String get healingLabel => 'उपचार';

  @override
  String get fortuneYogasTitle => 'भाग्य योग';

  @override
  String get luckBlocksLabel => 'नशीब अडथळे';

  @override
  String get fortuneBoostersLabel => 'भाग्य वर्धक';

  @override
  String get fortuneTrendTitle => 'भाग्य कल';

  @override
  String get goldenWindowsTitle => 'सुवर्ण कालावधी ★';

  @override
  String get transformationTitle => 'परिवर्तन';

  @override
  String get lifeMilestonesTitle => 'जीवन टप्पे';

  @override
  String get destinyVsLabel => 'नियती विरुद्ध';

  @override
  String get freeWillLabel => 'स्वेच्छा';

  @override
  String get destinyAllCapsLabel => 'नियती';

  @override
  String get freeWillAllCapsLabel => 'स्वेच्छा';

  @override
  String get karmicLessonsTitle => 'कर्म धडे';

  @override
  String get rahuGrowthLabel => 'राहू वाढ';

  @override
  String get ketuSurrenderLabel => 'केतू समर्पण';

  @override
  String get saturnLessonLabel => 'शनी धडा';

  @override
  String get lifeDifficultyLabel => 'जीवन कठिणता';

  @override
  String get soulCameToExperienceLabel => 'आत्मा अनुभवण्यासाठी आला';

  @override
  String get blessingsLabel => 'आशीर्वाद';

  @override
  String fulfillmentLabel(Object pct) {
    return 'पूर्तता: ${pct}%';
  }

  @override
  String get legalScoresLabel => 'कायदेशीर गुण';

  @override
  String get legalVulnerabilityLabel => 'कायदेशीर\nदुर्बलता';

  @override
  String get victoryPotentialLabel => 'विजय\nक्षमता';

  @override
  String get resolutionLabel => 'निराकरण';

  @override
  String get legalProfileTitle => 'कायदेशीर प्रोफाइल';

  @override
  String get karmaTypeLabel => 'कर्म प्रकार';

  @override
  String get conflictStyleLabel => 'संघर्ष शैली';

  @override
  String get strategyLabel => 'रणनीती';

  @override
  String get caseDurationLabel => 'खटला कालावधी';

  @override
  String get currentStatusLabel => 'सध्याची स्थिती';

  @override
  String get legalLabel => 'कायदेशीर';

  @override
  String get legalYogasTitle => 'कायदेशीर योग';

  @override
  String get disputePressureLabel => 'वाद दबाव';

  @override
  String get legalProtectionLabel => 'कायदेशीर संरक्षण';

  @override
  String get victoryLabel => 'विजय';

  @override
  String get asPlaintiffLabel => 'फिर्यादी म्हणून';

  @override
  String get asDefendantLabel => 'प्रतिवादी म्हणून';

  @override
  String get winProbabilityLabel => 'विजय संभाव्यता';

  @override
  String get disputeLabel => 'वाद';

  @override
  String get legalStressTitle => 'कायदेशीर तणाव';

  @override
  String get visibleEnemiesLabel => 'दृश्य शत्रू';

  @override
  String get hiddenEnemiesLabel => 'गुप्त शत्रू';

  @override
  String get criminalRiskLabel => 'गुन्हेगारी जोखीम';

  @override
  String get falseAccusationLabel => 'खोटा आरोप';

  @override
  String get contractKarmaTitle => 'करार कर्म';

  @override
  String get documentationLabel => 'दस्तऐवजीकरण';

  @override
  String get finePrintAwareLabel => 'बारीक अटी जागरूकता';

  @override
  String get negotiationSkillLabel => 'वाटाघाटी कौशल्य';

  @override
  String get signatureCautionLabel => 'स्वाक्षरी सावधानता';

  @override
  String resilienceColonLabel(Object value) {
    return 'लवचिकता: ${value}/100';
  }

  @override
  String get healthScoresLabel => 'आरोग्य गुण';

  @override
  String get vitalityLabel => 'चैतन्य';

  @override
  String get immunityLabel => 'प्रतिकारशक्ती';

  @override
  String get recoveryLabel => 'पुनर्प्राप्ती';

  @override
  String get mentalLabel => 'मानसिक';

  @override
  String get stressTolLabel => 'तणाव सहनशक्ती';

  @override
  String get ayurvedicLabel => 'आयुर्वेदिक';

  @override
  String get constitutionTitleLabel => 'प्रकृती';

  @override
  String secondaryColonLabel(Object value) {
    return 'दुय्यम: ${value}';
  }

  @override
  String get bodyLabel => 'शरीर';

  @override
  String get systemMapLabel => 'प्रणाली नकाशा';

  @override
  String get healthYogasTitle => 'आरोग्य योग';

  @override
  String get diseasePressureLabel => 'रोग दबाव';

  @override
  String get protectiveLabel => 'संरक्षक';

  @override
  String get bodyZoneLabel => 'शरीर भाग';

  @override
  String get vulnerabilityLabel => 'दुर्बलता';

  @override
  String get diseaseLabel => 'रोग';

  @override
  String get susceptibilityLabel => 'संवेदनशीलता';

  @override
  String get healthTrendTitle => 'आरोग्य कल';

  @override
  String get recoveryWindowsTitle => 'पुनर्प्राप्ती कालावधी';

  @override
  String get cautionPeriodsTitle => 'सावधगिरी कालावधी';

  @override
  String get burnoutRiskLabel => 'थकवा जोखीम';

  @override
  String get addictionVulnLabel => 'व्यसन दुर्बलता';

  @override
  String get workLifeBalLabel => 'कार्य-जीवन संतुलन';

  @override
  String get lifestyleFactorsTitle => 'जीवनशैली घटक';

  @override
  String get sleepDisciplineLabel => 'झोप शिस्त';

  @override
  String get dietDisciplineLabel => 'आहार शिस्त';

  @override
  String get exerciseNeedLabel => 'व्यायाम गरज';

  @override
  String get sunlightNeedLabel => 'सूर्यप्रकाश गरज';

  @override
  String get socialTypeLabel => 'सामाजिक प्रकार';

  @override
  String get healingSpeedLabel => 'उपचार गती';

  @override
  String get mentalScoresLabel => 'मानसिक गुण';

  @override
  String get mentalStabilityLabel => 'मानसिक\nस्थिरता';

  @override
  String get emotionalBaselineLabel => 'भावनिक\nआधाररेषा';

  @override
  String get anxietyLabel => 'चिंता';

  @override
  String get depressionLabel => 'नैराश्य';

  @override
  String get regulationLabel => 'नियमन';

  @override
  String get mentalProfileTitle => 'मानसिक प्रोफाइल';

  @override
  String get stressDriverLabel => 'तणाव कारक';

  @override
  String get stabilityAnchorLabel => 'स्थिरता आधार';

  @override
  String get attachmentStyleLabel => 'जोड शैली';

  @override
  String get burnoutStageLabel => 'थकवा टप्पा';

  @override
  String get mentalTitleLabel => 'मानसिक';

  @override
  String get mentalYogasTitle => 'मानसिक योग';

  @override
  String get stressPressureLabel => 'तणाव दबाव';

  @override
  String get stressResponseLabel => 'तणाव प्रतिसाद';

  @override
  String get anxietyTitleLabel => 'चिंता';

  @override
  String get typesLabel => 'प्रकार';

  @override
  String get therapyLabel => 'थेरपी';

  @override
  String get modalityFitLabel => 'पद्धती योग्यता';

  @override
  String get wellnessTrendTitle => 'कल्याण कल';

  @override
  String get healthyCopingLabel => 'निरोगी सामना';

  @override
  String get unhealthyRisksLabel => 'अनारोग्यकारी जोखीम';

  @override
  String get recommendedAlternativesLabel => 'शिफारस केलेले पर्याय';

  @override
  String get sleepQualityLabel => 'झोप गुणवत्ता';

  @override
  String get socialSupportLabel => 'सामाजिक आधार';

  @override
  String get burnoutVulnLabel => 'थकवा दुर्बलता';

  @override
  String get selfAwarenessLabel => 'स्व-जागरूकता';

  @override
  String get authTagline => 'ज्योतिषांसाठी नक्षत्रालॉजी';

  @override
  String get googleSignInNoToken => 'Google साइन-इन: कोणतेही ID टोकन मिळाले नाही. GOOGLE_WEB_CLIENT_ID सेट असल्याची आणि google-services.json कॉन्फिगर असल्याची खात्री करा.';

  @override
  String googleSignInError(String error) {
    return 'Google साइन-इन त्रुटी: ${error}';
  }

  @override
  String get orDivider => 'किंवा';

  @override
  String get register => 'नोंदणी करा';

  @override
  String get signInWithBiometrics => 'बायोमेट्रिकद्वारे साइन इन करा';

  @override
  String get forgotPasswordInstructions => 'रीसेट लिंक मिळवण्यासाठी तुमचा\nनोंदणीकृत ईमेल प्रविष्ट करा.';

  @override
  String get resendLink => 'लिंक पुन्हा पाठवा';

  @override
  String callJoinedChannel(String channel) {
    return 'चॅनेल ${channel} मध्ये सामील झाले';
  }

  @override
  String get callUserConnected => 'वापरकर्ता जोडला! कॉल सक्रिय';

  @override
  String callConnectionFailed(String reason) {
    return 'कनेक्शन अयशस्वी: ${reason}. Agora क्रेडेन्शियल तपासा.';
  }

  @override
  String callAgoraError(String details) {
    return 'Agora त्रुटी: ${details}';
  }

  @override
  String callAgoraInitFailed(String error) {
    return 'Agora आरंभ अयशस्वी: ${error}';
  }

  @override
  String get callWaitingForVideo => 'व्हिडिओची प्रतीक्षा करत आहे...';

  @override
  String get callVideoCall => 'व्हिडिओ कॉल';

  @override
  String get callVoiceCall => 'व्हॉइस कॉल';

  @override
  String callRateEarning(String rate, String earning) {
    return '${rate}/मिनिट • कमाई: ${earning}';
  }

  @override
  String get markAllRead => 'सर्व वाचले म्हणून चिन्हांकित करा';

  @override
  String get noNotificationsYet => 'अद्याप कोणत्याही सूचना नाहीत';

  @override
  String get pullToRefresh => 'रिफ्रेश करण्यासाठी खाली ओढा';

  @override
  String get justNow => 'आत्ताच';

  @override
  String minutesAgo(int minutes) {
    return '${minutes} मि पूर्वी';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours} ता पूर्वी';
  }

  @override
  String daysAgo(int days) {
    return '${days} दि पूर्वी';
  }

  @override
  String get noChartsCreateFirst => 'कोणतीही कुंडली नाही. आधी जन्म कुंडली तयार करा.';

  @override
  String get selectBirthChartToAnalyze => 'विश्लेषणासाठी जन्म कुंडली निवडा';

  @override
  String get unknownName => 'अज्ञात';

  @override
  String selectRangeCharts(int max) {
    return '2-${max} कुंडल्या निवडा';
  }

  @override
  String selectExactCharts(int max) {
    return '${max} कुंडल्या निवडा';
  }

  @override
  String runningAnalysis(String label) {
    return '${label} विश्लेषण चालू आहे...';
  }

  @override
  String pickKarmicCharts(int max) {
    return 'कर्म संबंध विश्लेषणासाठी 2 ते ${max} कुंडल्या निवडा';
  }

  @override
  String get pickMaleFemaleChart => 'एक पुरुष व एक स्त्री कुंडली निवडा';

  @override
  String get analysisFailed => 'विश्लेषण अयशस्वी';

  @override
  String errorWithDetails(String error) {
    return 'त्रुटी: ${error}';
  }

  @override
  String personNumber(int n) {
    return 'व्यक्ती ${n}';
  }

  @override
  String analyzeNCharts(int count) {
    return '${count} कुंडल्यांचे विश्लेषण करा';
  }

  @override
  String get bhavaHouse1 => 'स्वतः / शरीर';

  @override
  String get bhavaHouse2 => 'धन / कुटुंब';

  @override
  String get bhavaHouse3 => 'भावंडे / पराक्रम';

  @override
  String get bhavaHouse4 => 'घर / माता';

  @override
  String get bhavaHouse5 => 'संतती / बुद्धी';

  @override
  String get bhavaHouse6 => 'शत्रू / आरोग्य';

  @override
  String get bhavaHouse7 => 'विवाह / जोडीदार';

  @override
  String get bhavaHouse8 => 'आयुष्य';

  @override
  String get bhavaHouse9 => 'भाग्य / गुरू';

  @override
  String get bhavaHouse10 => 'करिअर / पिता';

  @override
  String get bhavaHouse11 => 'लाभ / मित्र';

  @override
  String get bhavaHouse12 => 'हानी / मोक्ष';

  @override
  String bhavaSignLord(String sign, String lord) {
    return '${sign} • स्वामी: ${lord}';
  }

  @override
  String bhavaSavValue(String value) {
    return 'SAV: ${value}';
  }

  @override
  String get today => 'आज';

  @override
  String gocharTransitScoresTitle(String date) {
    return 'गोचर (भ्रमण गुण) — ${date}';
  }

  @override
  String gocharNativeMoon(String moonSign) {
    return 'जन्म चंद्र: ${moonSign}';
  }

  @override
  String get gocharBest => 'सर्वोत्तम';

  @override
  String get gocharWorst => 'सर्वात वाईट';

  @override
  String get aspectsGrahaDrishtiTitle => 'ग्रह दृष्टी';

  @override
  String get aspectsGrahaDrishtiSubtitle => 'कोण कोणावर दृष्टी टाकतो (%)';

  @override
  String get aspectsLagnaReceivedTitle => 'लग्नावर प्राप्त दृष्टी';

  @override
  String get aspectsRashiDrishtiTitle => 'राशी दृष्टी';

  @override
  String get ashtakavargaSavTitle => 'सर्व अष्टकवर्ग (SAV)';

  @override
  String ashtakavargaSavSubtitle(String total, String average) {
    return 'एकूण: ${total} रेखा (सरासरी राशी = ${average})';
  }

  @override
  String ashtakavargaPlanetBavTitle(String planet) {
    return '${planet} — BAV';
  }

  @override
  String ashtakavargaPlanetBavSubtitle(String total, String natalScore) {
    return 'एकूण: ${total} रेखा • जन्म राशीत: ${natalScore}';
  }

  @override
  String get appName => 'नक्षत्रलोजी ॲस्ट्रो';

  @override
  String get astrologerPanel => 'ज्योतिषी पॅनेल';

  @override
  String get home => 'मुख्यपृष्ठ';

  @override
  String get dashboard => 'डॅशबोर्ड';

  @override
  String get charts => 'चार्ट्स';

  @override
  String get bookings => 'बुकिंग्ज';

  @override
  String get requests => 'विनंत्या';

  @override
  String get chats => 'चॅट्स';

  @override
  String get earnings => 'कमाई';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get live => 'लाइव्ह';

  @override
  String get signIn => 'साइन इन';

  @override
  String get createAccount => 'खाते तयार करा';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्ड पुष्टी करा';

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
  String get continueGoogle => 'Google सह सुरू ठेवा';

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
  String get todaysEarning => 'आजची कमाई';

  @override
  String get walletBalance => 'वॉलेट';

  @override
  String get rating => 'रेटिंग';

  @override
  String get totalSessions => 'सत्रे';

  @override
  String get consultations => 'सल्लामसलत';

  @override
  String get response => 'प्रतिसाद';

  @override
  String get online => 'ऑनलाइन';

  @override
  String get offline => 'ऑफलाइन';

  @override
  String get busy => 'व्यस्त';

  @override
  String get goLive => 'लाइव्ह जा';

  @override
  String get streamTitle => 'स्ट्रीम शीर्षक';

  @override
  String get description => 'वर्णन (ऐच्छिक)';

  @override
  String get start => 'सुरू करा';

  @override
  String get rashiPredictions => 'राशी भविष्य';

  @override
  String get todaysGochar => 'आजचा सर्व १२ राशींचा गोचर — अधिक जाणून घ्या';

  @override
  String get recentRequests => 'अलीकडील विनंत्या';

  @override
  String get noRecentRequests => 'अलीकडील विनंत्या नाहीत';

  @override
  String get upcoming => 'आगामी';

  @override
  String get viewAll => 'सर्व पहा';

  @override
  String get pending => 'प्रलंबित';

  @override
  String get accepted => 'स्वीकारले';

  @override
  String get completed => 'पूर्ण';

  @override
  String get declined => 'नाकारले';

  @override
  String get clientCharts => 'ग्राहक चार्ट्स';

  @override
  String get newChart => 'नवीन चार्ट';

  @override
  String get noChartsCreated => 'अजून चार्ट तयार केलेले नाहीत';

  @override
  String get newClientChart => 'नवीन ग्राहक चार्ट';

  @override
  String get clientBirthDetails => 'ग्राहक जन्म तपशील';

  @override
  String get clientName => 'ग्राहक नाव';

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
  String get birthPlaceHint => 'शहराचे नाव शोधा...';

  @override
  String get generateKundli => 'कुंडली तयार करा';

  @override
  String get clientChartCreated => 'ग्राहक चार्ट तयार झाला!';

  @override
  String get viewKundli => 'कुंडली पहा';

  @override
  String get deleteChart => 'चार्ट हटवायचा?';

  @override
  String get completeBirthChart => 'संपूर्ण जन्म चार्ट';

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
  String get kundli => 'कुंडली';

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
  String get thisMonth => 'या महिन्यात';

  @override
  String get statement => 'विवरण';

  @override
  String get all => 'सर्व';

  @override
  String get credits => 'क्रेडिट्स';

  @override
  String get withdrawals => 'पैसे काढणे';

  @override
  String get bonus => 'बोनस';

  @override
  String get refunds => 'परतावा';

  @override
  String get requestWithdrawal => 'पैसे काढण्याची विनंती';

  @override
  String get withdraw => 'पैसे काढा';

  @override
  String get amount => 'रक्कम';

  @override
  String get upiId => 'UPI आयडी';

  @override
  String get bankTransfer => 'बँक ट्रान्सफर';

  @override
  String get accountHolderName => 'खातेधारकाचे नाव';

  @override
  String get accountNumber => 'खाते क्रमांक';

  @override
  String get ifscCode => 'IFSC कोड';

  @override
  String get submit => 'सबमिट करा';

  @override
  String get noTransactions => 'कोणतेही व्यवहार नाहीत';

  @override
  String get withdrawalHistory => 'पैसे काढण्याचा इतिहास';

  @override
  String get typeGuidance => 'तुमचे मार्गदर्शन लिहा...';

  @override
  String get sessionEnded => 'सत्र संपले';

  @override
  String get endChat => 'चॅट संपवायची?';

  @override
  String get endChatConfirm => 'तुम्हाला खात्री आहे की हे सत्र संपवायचे आहे?';

  @override
  String get activeNow => 'आत्ता सक्रिय';

  @override
  String get connecting => 'कनेक्ट होत आहे...';

  @override
  String get clientKundli => 'ग्राहक कुंडली';

  @override
  String get earned => 'कमावले';

  @override
  String get connected => 'कनेक्टेड';

  @override
  String get endCall => 'कॉल संपवा';

  @override
  String get endStream => 'स्ट्रीम संपवा';

  @override
  String get endStreamConfirm => 'लाइव्ह स्ट्रीम संपवायची?';

  @override
  String get goLiveBtn => 'लाइव्ह जा';

  @override
  String get viewers => 'दर्शक';

  @override
  String get peak => 'शिखर';

  @override
  String get gifts => 'भेटवस्तू';

  @override
  String get ok => 'ठीक आहे';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get save => 'जतन करा';

  @override
  String get edit => 'संपादन';

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
  String get logout => 'लॉगआउट';

  @override
  String get selectLanguage => 'भाषा निवडा';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'इंग्रजी';

  @override
  String get kycSubmit => 'KYC सबमिट करा';

  @override
  String get kycPending => 'KYC पुनरावलोकनाधीन';

  @override
  String get kycRejected => 'KYC नाकारले';

  @override
  String get notifications => 'सूचना';

  @override
  String get biometricLogin => 'बायोमेट्रिक लॉगिन';

  @override
  String get editProfile => 'प्रोफाइल संपादित करा';

  @override
  String get totalCredit => 'एकूण क्रेडिट';

  @override
  String get totalDebit => 'एकूण डेबिट';

  @override
  String get allTypes => 'सर्व प्रकार';

  @override
  String get prev => 'मागील';

  @override
  String get next => 'पुढील';

  @override
  String get page => 'पृष्ठ';

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
  String get deptReports => 'विभाग अहवाल';

  @override
  String get specialistAnalysesDesc => '15 तज्ञ विश्लेषणे — करिअर, संपत्ती, आरोग्य, प्रेम आणि अधिक';

  @override
  String get matchTwoChartsDesc => 'दोन कुंडल्या जुळवा — अष्टकूट, नवांश, गोचर वेळ आणि अधिक';

  @override
  String get todaysForecast => 'आजचे भविष्य';

  @override
  String get dailyProbability => 'कोणत्याही कुंडलीसाठी दैनिक संभाव्यता भविष्य';

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
  String get decline => 'नकार';

  @override
  String get accept => 'स्वीकार';

  @override
  String get endSession => 'सत्र संपवा';

  @override
  String get enterChat => 'चॅटमध्ये जा';

  @override
  String get inProgress => 'प्रगतीपथावर';

  @override
  String get requestDeclined => 'विनंती नाकारली';

  @override
  String get noRequests => 'विनंत्या नाहीत';

  @override
  String get tapViewChat => 'चॅट इतिहास पाहण्यासाठी टॅप करा';

  @override
  String get tapViewCall => 'कॉल तपशील पाहण्यासाठी टॅप करा';

  @override
  String get consultation => 'सल्ला';

  @override
  String get charged => 'शुल्क';

  @override
  String get messages => 'संदेश';

  @override
  String get duration => 'कालावधी';

  @override
  String get rate => 'दर';

  @override
  String get callDetails => 'कॉल तपशील';

  @override
  String get yourEarning => 'तुमची कमाई';

  @override
  String get totalCharged => 'एकूण शुल्क';

  @override
  String get activeDoshas => 'सक्रिय दोष';

  @override
  String get activeYogas => 'सक्रिय योग';

  @override
  String get allDoshas => 'सर्व दोष';

  @override
  String get areasToNurture => 'जोपासण्याची क्षेत्रे';

  @override
  String get basedOnPlanetStrengths => 'ग्रह बलांवर आधारित';

  @override
  String get basedOnTransits => 'सध्याच्या गोचरांवर आधारित';

  @override
  String get basis => 'आधार';

  @override
  String get beneficAspects => 'शुभ दृष्टी';

  @override
  String get bestWindows => 'सर्वोत्तम कालावधी';

  @override
  String get bhakootAxis => 'भकूट अक्ष';

  @override
  String get cancellation => 'निवारण';

  @override
  String get cancellationFactors => 'निवारण घटक';

  @override
  String get cancellations => 'निवारणे';

  @override
  String get challengingPeriods => 'आव्हानात्मक कालावधी';

  @override
  String get characterOverview => 'चारित्र्य आढावा';

  @override
  String get combinedFertility => 'एकत्रित प्रजनन क्षमता';

  @override
  String get combust => 'अस्त';

  @override
  String get confidence => 'विश्वसनीयता';

  @override
  String get contact => 'संपर्क';

  @override
  String get copy => 'कॉपी';

  @override
  String get currentPlanetPositions => 'सध्याची ग्रह स्थिती';

  @override
  String get d7Saptamsa => 'D7 सप्तमांश';

  @override
  String get dashaSync => 'दशा समन्वय';

  @override
  String get daughter => 'मुलगी';

  @override
  String get debilitated => 'नीच';

  @override
  String get detailedSummary => 'सविस्तर सारांश';

  @override
  String get discussWithAI => 'AI सोबत चर्चा करा';

  @override
  String get dominantPlanet => 'प्रबळ ग्रह';

  @override
  String get effect => 'परिणाम';

  @override
  String get exalted => 'उच्च';

  @override
  String get factors => 'घटक';

  @override
  String get favorablePeriodAdvice => 'अनुकूल कालावधी';

  @override
  String get favorablePeriods => 'अनुकूल कालावधी';

  @override
  String get genderExplanation => 'लिंग स्पष्टीकरण';

  @override
  String get genderTendency => 'लिंग प्रवृत्ती';

  @override
  String get grantPermissions => 'परवानग्या द्या';

  @override
  String get health => 'एकूण आरोग्य';

  @override
  String get herMoon => 'तिचा चंद्र';

  @override
  String get hisMoon => 'त्याचा चंद्र';

  @override
  String get house => 'भाव';

  @override
  String get inFifth => 'पंचम स्थानात';

  @override
  String get ketuContacts => 'केतू संपर्क';

  @override
  String get key => 'मुख्य';

  @override
  String get keyHouses => 'मुख्य भाव';

  @override
  String get keyInsights => 'मुख्य अंतर्दृष्टी';

  @override
  String get keyPlanets => 'मुख्य ग्रह';

  @override
  String get kundliMilan => 'कुंडली मिलन';

  @override
  String get lifeAreaPredictions => 'जीवन क्षेत्र भविष्य';

  @override
  String get maleficAspects => 'अशुभ दृष्टी';

  @override
  String get manifestation => 'प्रकटीकरण';

  @override
  String get milan => 'मिलन';

  @override
  String get mitigation => 'उपशमन';

  @override
  String get moonSignCompat => 'चंद्र राशी अनुकूलता';

  @override
  String get nakshatraCompat => 'नक्षत्र अनुकूलता';

  @override
  String get navigation => 'नेव्हिगेशन';

  @override
  String get nextFavorableWindow => 'पुढील अनुकूल कालावधी';

  @override
  String get noCharts => 'कुंडल्या नाहीत';

  @override
  String get noClassicalYogas => 'सातत्यपूर्ण प्रयत्नातून यश मिळते.';

  @override
  String get noYogasActive => 'या कुंडलीत सक्रिय योग नाहीत.';

  @override
  String get notesSaved => 'टिपा जतन झाल्या';

  @override
  String get numberExplanation => 'अंक स्पष्टीकरण';

  @override
  String get occupants => 'स्थित ग्रह';

  @override
  String get overallVerdict => 'एकूण निर्णय';

  @override
  String get overlappingWindows => 'आच्छादित विवाह कालावधी';

  @override
  String get past => 'मागील';

  @override
  String get pastLifeIndication => 'पूर्वजन्म संकेत';

  @override
  String get planet => 'ग्रह';

  @override
  String get planetPositions => 'ग्रह स्थान';

  @override
  String get potentialStrengths => 'संभाव्य सामर्थ्ये';

  @override
  String get primaryArchetype => 'प्राथमिक आदर्श';

  @override
  String get probableNumber => 'संभाव्य अंक';

  @override
  String get rahuContacts => 'राहू संपर्क';

  @override
  String get rashi => 'राशी भविष्य';

  @override
  String get recommendations => 'शिफारसी';

  @override
  String get relationshipGuidance => 'नातेसंबंध मार्गदर्शन';

  @override
  String get remedies => 'उपाय';

  @override
  String get retrograde => 'वक्री';

  @override
  String get ruledBy => 'स्वामी';

  @override
  String get running => 'चालू';

  @override
  String get scoreComponents => 'गुण घटक';

  @override
  String get selectChartsForMilan => '2 कुंडल्या निवडा';

  @override
  String get selectMultiCharts => 'कुंडल्या निवडा';

  @override
  String get selectTwoCharts => 'जुळणीसाठी 2 कुंडल्या निवडा';

  @override
  String get sign => 'राशी';

  @override
  String get son => 'मुलगा';

  @override
  String get soulCareerAlign => 'आत्मा ↔ करिअर संरेखन';

  @override
  String get startKundliMilan => 'कुंडली मिलन सुरू करा';

  @override
  String get startSession => 'सत्र सुरू करा';

  @override
  String get strength => 'बल';

  @override
  String get strengths => 'सामर्थ्ये';

  @override
  String get todaysTransitChart => 'गोचर कुंडली';

  @override
  String get topActiveDoshas => 'प्रमुख सक्रिय दोष';

  @override
  String get topOpportunities => 'प्रमुख क्षेत्रे';

  @override
  String get topRisks => 'प्रमुख जोखीम';

  @override
  String get totalChallengePenalty => 'एकूण आव्हान दंड';

  @override
  String get totalDoshaPenalty => 'एकूण दोष दंड';

  @override
  String get transitMarriageWindows => 'गोचर विवाह कालावधी';

  @override
  String get value => 'मूल्य';

  @override
  String get vargottama => 'वर्गोत्तम';

  @override
  String get venusContacts => 'शुक्र संपर्क';

  @override
  String get weaknesses => 'दुर्बलता';

  @override
  String get worstWindows => 'सर्वात वाईट कालावधी';

  @override
  String get yogaAnalysis => 'योग विश्लेषण';

  @override
  String get unlocked => 'अनलॉक झाले!';

  @override
  String get lessThanOneMin => '1 मिनिटापेक्षा कमी शिल्लक';
}
