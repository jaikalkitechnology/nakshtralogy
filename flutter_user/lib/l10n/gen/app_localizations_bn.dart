// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get kunNavamsa => 'নবাংশ (D9)';

  @override
  String get kunD10 => 'দশাংশ (D10)';

  @override
  String get kunPlacement => 'গ্রহ অবস্থান';

  @override
  String get kunHousesTitle => 'ভাব বিবরণ';

  @override
  String get kunPlanet => 'গ্রহ';

  @override
  String get kunNakshatra => 'নক্ষত্র';

  @override
  String get kunPada => 'পদ';

  @override
  String get kunLord => 'স্বামী';

  @override
  String get kunExplain => 'আমার কুণ্ডলী ব্যাখ্যা করুন';

  @override
  String get kunExplainSubtitle => 'আপনার কুণ্ডলীর সহজ সারাংশ';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return '${ordinal} ভাব ${meaning} নিয়ন্ত্রণ করে।';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return 'এখানে অবস্থিত ${planets} এর ফলাফল নির্ধারণ করে।';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'আপনার লগ্ন ${asc}, যা আপনার দৃষ্টিভঙ্গি এবং অন্যরা আপনাকে প্রথমে কীভাবে দেখে তা গঠন করে।';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'আপনার মন ও আবেগ ${moon}-এ অবস্থিত চন্দ্রকে অনুসরণ করে।';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '${planet} আপনার সবচেয়ে শক্তিশালী গ্রহ — স্বাচ্ছন্দ্য ও সহায়তার স্বাভাবিক ক্ষেত্র।';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '${planet} আপনার সবচেয়ে পরীক্ষিত গ্রহ — এখানে ধৈর্য ও পরিশ্রম ফল দেয়।';
  }

  @override
  String get plNature => 'প্রকৃতি';

  @override
  String get plElement => 'তত্ত্ব';

  @override
  String get plGender => 'লিঙ্গ';

  @override
  String get plKarakatva => 'কারকত্ব';

  @override
  String get plLordship => 'অধিপত্য';

  @override
  String get plStrength => 'বল';

  @override
  String get plAspectsGiven => 'প্রদত্ত দৃষ্টি';

  @override
  String get plAspectsReceived => 'প্রাপ্ত দৃষ্টি';

  @override
  String get plConjunction => 'যুতি';

  @override
  String get plHouseMeaning => 'ভাবের অর্থ';

  @override
  String get plNakshatraMeaning => 'নক্ষত্রের অর্থ';

  @override
  String get plAiInterpretation => 'AI ব্যাখ্যা';

  @override
  String get plSearchHint => 'যেকোনো গ্রহ খুঁজুন';

  @override
  String get plNoResults => 'কোনো গ্রহ পাওয়া যায়নি';

  @override
  String get plBenefic => 'শুভ';

  @override
  String get plMalefic => 'পাপ';

  @override
  String get plMale => 'পুরুষ';

  @override
  String get plFemale => 'স্ত্রী';

  @override
  String get plNeutralGender => 'নপুংসক';

  @override
  String get plOwnSign => 'স্ব রাশি';

  @override
  String get plFriend => 'মিত্র রাশি';

  @override
  String get plEnemy => 'শত্রু রাশি';

  @override
  String get plNeutral => 'সম';

  @override
  String get sumEther => 'আকাশ';

  @override
  String plLordOfHouses(Object houses) {
    return 'ভাব ${houses}-এর অধিপতি';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return '${nakLord} দ্বারা শাসিত, যা ${trait} নিয়ে আসে।';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '${planet} ${sign} রাশিতে, ${house} ভাবে অবস্থিত।';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'এর মূল কারকত্ব — ${karak} — এখানে ভালোভাবে সমর্থিত।';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'এর মূল কারকত্ব — ${karak} — এখানে সচেতন প্রচেষ্টার প্রয়োজন হতে পারে।';
  }

  @override
  String plAiExalted(Object planet) {
    return '${planet} উচ্চ অবস্থায় আছে, যা তার সেরা ফল দেয়।';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '${planet} নীচ অবস্থায় আছে এবং ফল দেওয়ার জন্য সহায়তার প্রয়োজন।';
  }

  @override
  String plAiCombust(Object planet) {
    return '${planet} অস্ত অবস্থায় আছে, তাই সূর্যের তীব্রতায় এটি কম প্রকাশ্যে কাজ করে।';
  }

  @override
  String plAiVargottama(Object planet) {
    return '${planet} বর্গোত্তম — এই শক্তিশালী অবস্থান নবমাংশেও পুনরাবৃত্তি হয়।';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '${planet} বক্রী, যা তার শক্তিকে অভ্যন্তরীণ দিকে মোড় দিয়ে তীব্র করে তোলে।';
  }

  @override
  String get plHouse1 => 'স্ব, শরীর, ব্যক্তিত্ব এবং জীবনীশক্তি';

  @override
  String get plHouse2 => 'ধন, পরিবার, বাণী এবং খাদ্য';

  @override
  String get plHouse3 => 'সাহস, ভাইবোন, যোগাযোগ এবং ছোট ভ্রমণ';

  @override
  String get plHouse4 => 'ঘর, মা, স্বাচ্ছন্দ্য, সম্পত্তি এবং আন্তরিক শান্তি';

  @override
  String get plHouse5 => 'সন্তান, সৃজনশীলতা, বুদ্ধি, প্রেম এবং পূর্বপুণ্য';

  @override
  String get plHouse6 => 'স্বাস্থ্য, শত্রু, ঋণ, সেবা এবং দৈনন্দিন কাজ';

  @override
  String get plHouse7 => 'বিবাহ, অংশীদারিত্ব এবং ব্যবসায়িক সম্পর্ক';

  @override
  String get plHouse8 => 'দীর্ঘায়ু, রূপান্তর, রহস্য এবং উত্তরাধিকার';

  @override
  String get plHouse9 => 'ভাগ্য, ধর্ম, উচ্চশিক্ষা, গুরু এবং পিতা';

  @override
  String get plHouse10 => 'কর্মজীবন, মর্যাদা, কর্তৃত্ব এবং সামাজিক কর্ম';

  @override
  String get plHouse11 => 'লাভ, আয়, বন্ধু, নেটওয়ার্ক এবং পূর্ণ ইচ্ছা';

  @override
  String get plHouse12 => 'ক্ষতি, ব্যয়, বিদেশ, আধ্যাত্মিকতা এবং মোক্ষ';

  @override
  String get sumVeryStrong => 'অত্যন্ত শক্তিশালী';

  @override
  String get sumStrong => 'শক্তিশালী';

  @override
  String get sumAverage => 'গড়';

  @override
  String get sumWeak => 'দুর্বল';

  @override
  String get sumNeedsAttention => 'মনোযোগ প্রয়োজন';

  @override
  String get sumFire => 'অগ্নি';

  @override
  String get sumEarth => 'পৃথিবী';

  @override
  String get sumAir => 'বায়ু';

  @override
  String get sumWater => 'জল';

  @override
  String get sumMovable => 'চর';

  @override
  String get sumFixed => 'স্থির';

  @override
  String get sumDual => 'দ্বিস্বভাব';

  @override
  String get sumDirEast => 'পূর্ব';

  @override
  String get sumDirWest => 'পশ্চিম';

  @override
  String get sumDirNorth => 'উত্তর';

  @override
  String get sumDirSouth => 'দক্ষিণ';

  @override
  String get sumDirNE => 'উত্তর-পূর্ব';

  @override
  String get sumDirNW => 'উত্তর-পশ্চিম';

  @override
  String get sumDirSE => 'দক্ষিণ-পূর্ব';

  @override
  String get sumDirSW => 'দক্ষিণ-পশ্চিম';

  @override
  String get sumSnapshotTitle => 'আপনার জ্যোতিষ ঝলক';

  @override
  String get sumMahadasha => 'মহাদশা';

  @override
  String get sumAntardasha => 'অন্তর্দশা';

  @override
  String get sumNakshatra => 'জন্ম নক্ষত্র';

  @override
  String get sumElement => 'তত্ত্ব';

  @override
  String get sumModality => 'স্বভাব';

  @override
  String get sumLuckyDirection => 'শুভ দিক';

  @override
  String get sumHighlights => 'গুরুত্বপূর্ণ বিষয়';

  @override
  String get sumStrongPlanet => 'সবচেয়ে শক্তিশালী গ্রহ';

  @override
  String get sumWeakPlanet => 'সবচেয়ে দুর্বল গ্রহ';

  @override
  String get sumYogas => 'যোগ';

  @override
  String get sumDoshas => 'দোষ';

  @override
  String get sumRetrograde => 'বক্রী';

  @override
  String get sumCombust => 'অস্ত';

  @override
  String get sumExalted => 'উচ্চ';

  @override
  String get sumDebilitated => 'নীচ';

  @override
  String get sumVargottama => 'বর্গোত্তম';

  @override
  String get sumQuickInsights => 'দ্রুত তথ্য';

  @override
  String get sumSpirituality => 'আধ্যাত্মিকতা';

  @override
  String get sumTimezone => 'সময় অঞ্চল';

  @override
  String get sumAyanamsa => 'অয়নাংশ';

  @override
  String get sumCalendarType => 'পঞ্জিকা';

  @override
  String get sumCopied => 'ক্লিপবোর্ডে কপি হয়েছে';

  @override
  String get sumNatureFire => 'আপনার একটি সাহসী, উদ্যমী এবং অগ্রণী স্বভাব রয়েছে যা সামনে থেকে নেতৃত্ব দেয়।';

  @override
  String get sumNatureEarth => 'আপনার একটি বাস্তববাদী, স্থিতিশীল এবং শৃঙ্খলাপূর্ণ স্বভাব রয়েছে যা দীর্ঘস্থায়ী ফল গড়ে তোলে।';

  @override
  String get sumNatureAir => 'আপনার একটি কৌতূহলী, যোগাযোগমুখী এবং বুদ্ধিদীপ্ত স্বভাব রয়েছে যা নতুন ধারণায় সমৃদ্ধ হয়।';

  @override
  String get sumNatureWater => 'আপনার একটি স্বজ্ঞাত, আবেগপ্রবণ এবং সহানুভূতিশীল স্বভাব রয়েছে যার গভীর অন্তর্দৃষ্টি আছে।';

  @override
  String get sumGradePhraseExcellent => 'দৃঢ়ভাবে সমর্থিত — ধারাবাহিক প্রচেষ্টায় অনুকূল ফল পাওয়ার সম্ভাবনা রয়েছে।';

  @override
  String get sumGradePhraseGood => 'ভালোভাবে সমর্থিত — সামান্য যত্নে সাধারণত ইতিবাচক ফল।';

  @override
  String get sumGradePhraseAverage => 'মিশ্র সমর্থন — ফলাফল প্রচেষ্টা এবং সময়ের উপর নির্ভর করে।';

  @override
  String get sumGradePhraseWeak => 'মনোযোগ প্রয়োজন — ধৈর্য ও প্রতিকার এখানে সহায়ক।';

  @override
  String get kDefCombust => 'সূর্যের অত্যন্ত কাছাকাছি থাকা একটি গ্রহ, যার ফলে তার শক্তি \'দগ্ধ\' ও দুর্বল হয়ে যায়।';

  @override
  String get kDefRetrograde => 'একটি গ্রহ যা পিছনের দিকে চলমান বলে মনে হয়; এর প্রভাব ভেতরের দিকে ফিরে তীব্র হয়।';

  @override
  String get kDefNakshatra => '২৭টি নাক্ষত্রিক মন্ডলের একটি, যার মধ্য দিয়ে চন্দ্র ও গ্রহরা ভ্রমণ করে।';

  @override
  String get kDefVargottama => 'একটি গ্রহ যা জন্মছক (D1) এবং নবমাংশ (D9) উভয়েই একই রাশিতে অবস্থান করে — শক্তির একটি চিহ্ন।';

  @override
  String get kDefOwnSign => 'একটি গ্রহ যা তার নিজস্ব রাশিতে অবস্থান করে, যেখানে সে ঘরের মতো অনুভব করে এবং স্থিতিশীল ফল দেয়।';

  @override
  String get kDefExalted => 'একটি গ্রহ তার সর্বোচ্চ শক্তির রাশিতে, যা তার সেরা ফল প্রদান করে।';

  @override
  String get kDefDebilitated => 'একটি গ্রহ তার দুর্বলতম রাশিতে, যেখানে সে ফল দিতে সংগ্রাম করে।';

  @override
  String get kDefMooltrikona => 'একটি গ্রহের নিজস্ব রাশির একটি বিশেষ অংশ যেখানে সে বিশেষভাবে শক্তিশালী।';

  @override
  String get kDefAscendant => 'জন্মের সময় পূর্ব দিগন্তে উদিত রাশি — লগ্ন, ছকের ভিত্তি।';

  @override
  String get kDefMahadasha => 'প্রধান গ্রহ-সময়কাল যা জীবনের দীর্ঘ সময়কে রঙিন করে তোলে।';

  @override
  String get kDefAntardasha => 'মহাদশার মধ্যে একটি উপ-সময়কাল যা তার ফলাফলকে সূক্ষ্মভাবে সমন্বয় করে।';

  @override
  String get kDefPada => 'একটি নক্ষত্রের চারটি ভাগের একটি, যেখানে একটি গ্রহ অবস্থান করে।';

  @override
  String get aspGivesAspectTo => 'দৃষ্টি প্রদান করে';

  @override
  String get aspReceivesAspectFrom => 'দৃষ্টি গ্রহণ করে';

  @override
  String get aspInfluences => 'প্রভাবিত করে';

  @override
  String get aspNoInfluence => 'কোনো প্রভাব নেই';

  @override
  String get aspNoAspect => 'কোনো দৃষ্টি নেই';

  @override
  String get aspPresent => 'উপস্থিত';

  @override
  String get aspAbsent => 'অনুপস্থিত';

  @override
  String get aspNotPresent => 'উপস্থিত নয়';

  @override
  String get aspSpecialAspect => 'বিশেষ দৃষ্টি';

  @override
  String get aspAspectWord => 'দৃষ্টি';

  @override
  String get aspTotalGiven => 'প্রদত্ত দৃষ্টি';

  @override
  String get aspTotalReceived => 'প্রাপ্ত দৃষ্টি';

  @override
  String get aspStrongestInfluence => 'সবচেয়ে শক্তিশালী প্রভাব';

  @override
  String get aspMedium => 'মাঝারি';

  @override
  String get aspAspectPresent => 'দৃষ্টি উপস্থিত';

  @override
  String get aspReason => 'কারণ';

  @override
  String get aspBoth => 'উভয়ই';

  @override
  String get aspTargetHouse => 'লক্ষ্য ভাব';

  @override
  String get aspTargetSign => 'লক্ষ্য রাশি';

  @override
  String get aspLagnaReceives => 'লগ্ন যাদের কাছ থেকে দৃষ্টি পায়';

  @override
  String get aspNoAspectFrom => 'এদের থেকে কোনো দৃষ্টি নেই';

  @override
  String get aspPlanetToPlanet => 'গ্রহ থেকে গ্রহ';

  @override
  String get aspSignToSign => 'রাশি থেকে রাশি';

  @override
  String get aspCombinedAspect => 'সম্মিলিত দৃষ্টি';

  @override
  String get aspGrahaAspect => 'গ্রহ দৃষ্টি';

  @override
  String get aspRashiAspect => 'রাশি দৃষ্টি';

  @override
  String get aspInfoTitle => 'দৃষ্টি (Drishti) বোঝা';

  @override
  String get aspQGraha => 'গ্রহ দৃষ্টি কী?';

  @override
  String get aspQRashi => 'রাশি দৃষ্টি কী?';

  @override
  String get aspQDiff => 'দুটির মধ্যে পার্থক্য';

  @override
  String get aspQPredict => 'দৃষ্টি কীভাবে ভবিষ্যদ্বাণীকে প্রভাবিত করে';

  @override
  String get aspGrahaBody => 'গ্রহ দৃষ্টি হলো একটি গ্রহ তার অবস্থান থেকে যে দৃষ্টি নিক্ষেপ করে। প্রতিটি গ্রহ নিজের অবস্থান থেকে ৭ম ভাব/গ্রহের উপর সম্পূর্ণ দৃষ্টি দেয় (সরাসরি, মুখোমুখি প্রভাব)। এছাড়া, মঙ্গল ৪র্থ ও ৮ম-এর উপর, বৃহস্পতি ৫ম ও ৯ম-এর উপর, এবং শনি ৩য় ও ১০ম-এর উপর দৃষ্টি দেয়। রাহু ও কেতুকে সাধারণত ৫ম, ৭ম ও ৯ম দৃষ্টি দেওয়া হয়। একটি গ্রহের দৃষ্টি যে গ্রহ বা ভাবের উপর পড়ে তাকে নিজের স্বভাবের রঙে রাঙিয়ে দেয়।';

  @override
  String get aspRashiBody => 'রাশি দৃষ্টি হলো জৈমিনী জ্যোতিষের একটি রাশি-থেকে-রাশি দৃষ্টি, যা সেখানে কোন গ্রহ আছে তার উপর নির্ভর করে না। চর রাশি স্থির রাশির উপর দৃষ্টি দেয় (পার্শ্ববর্তী ছাড়া), স্থির রাশি চর রাশির উপর দৃষ্টি দেয় (পার্শ্ববর্তী ছাড়া), এবং দ্বিস্বভাব রাশি অন্য দ্বিস্বভাব রাশির উপর দৃষ্টি দেয়। এটি মূলত জৈমিনী ভবিষ্যদ্বাণী এবং ভাবগুলোর মধ্যে সম্পর্ক বিচারে ব্যবহৃত হয়।';

  @override
  String get aspDiffBody => 'গ্রহ দৃষ্টি একটি গ্রহ দ্বারা নিক্ষিপ্ত হয় এবং সেই গ্রহ কোথায় অবস্থান করছে তার উপর নির্ভর করে। রাশি দৃষ্টি রাশির নিজস্ব এবং তাতে যা কিছু স্থাপিত থাকুক না কেন তার উপর প্রযোজ্য। গ্রহ দৃষ্টি দিকনির্দেশক (গ্রহ A গ্রহ B-কে দেখে), অন্যদিকে রাশি দৃষ্টি সাধারণত রাশিগুলোর মধ্যে পারস্পরিক হয়। যখন দুটোই একই লক্ষ্যের দিকে নির্দেশ করে, তখন প্রভাব বিশেষভাবে শক্তিশালী হয়।';

  @override
  String get aspPredictBody => 'একটি দৃষ্টি দেখায় যে একটি গ্রহ তার নিজের ভাবের বাইরে কোথায় প্রভাব বিস্তার করে। একটি শুভ দৃষ্টি (বৃহস্পতি, শুক্র, ভালোভাবে স্থাপিত চন্দ্র/বুধ) লক্ষ্যকে সমর্থন ও রক্ষা করে; একটি অশুভ দৃষ্টি (শনি, মঙ্গল, সূর্য, রাহু, কেতু) তার উপর চাপ, বিলম্ব বা চ্যালেঞ্জ তৈরি করতে পারে। কোন গ্রহ কোন ভাব বা গ্রহের উপর দৃষ্টি দেয় তা পড়লে বোঝা যায় ফলাফল কেন এভাবে প্রকাশ পায়।';

  @override
  String get aspTraitSun => 'কর্তৃত্ব, নেতৃত্ব এবং প্রাণশক্তি';

  @override
  String get aspTraitMoon => 'আবেগিক গভীরতা, স্বাচ্ছন্দ্য এবং স্বজ্ঞা';

  @override
  String get aspTraitMars => 'শক্তি, সাহস এবং উদ্যম';

  @override
  String get aspTraitMercury => 'যোগাযোগ, বুদ্ধি এবং অভিযোজনযোগ্যতা';

  @override
  String get aspTraitJupiter => 'জ্ঞান, বৃদ্ধি এবং সৌভাগ্য';

  @override
  String get aspTraitVenus => 'প্রেম, সামঞ্জস্য এবং স্বাচ্ছন্দ্য';

  @override
  String get aspTraitSaturn => 'শৃঙ্খলা, দায়িত্ব এবং ধৈর্যশীল, কখনো কখনো বিলম্বিত, সাফল্য';

  @override
  String get aspTraitRahu => 'উচ্চাকাঙ্ক্ষা, তীব্রতা এবং অপ্রচলিত মোড়';

  @override
  String get aspTraitKetu => 'বিচ্ছিন্নতা, আধ্যাত্মিকতা এবং আকস্মিক পরিবর্তন';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '${planet} ${targets}-কে প্রভাবিত করছে। এর ফলে এই গ্রহগুলো যে ক্ষেত্রগুলোকে প্রতিনিধিত্ব করে সেখানে ${trait} আসতে পারে।';
  }

  @override
  String aspAiNone(Object planet) {
    return '${planet} এখানে অন্য কোনো গ্রহের উপর বিশেষ দৃষ্টি দেয় না; এর প্রভাব মূলত নিজের রাশি ও ভাবের মাধ্যমেই কাজ করে।';
  }

  @override
  String get avSummaryTitle => 'অষ্টকবর্গ সারাংশ';

  @override
  String get avOverallScore => 'সামগ্রিক SAV স্কোর';

  @override
  String get avOverallRating => 'সামগ্রিক রেটিং';

  @override
  String get avStrongestSigns => 'সবচেয়ে শক্তিশালী রাশি';

  @override
  String get avWeakestSigns => 'সবচেয়ে দুর্বল রাশি';

  @override
  String get avScore => 'স্কোর';

  @override
  String get avMeaning => 'অর্থ';

  @override
  String get avGrid => 'গ্রিড';

  @override
  String get avList => 'তালিকা';

  @override
  String get avOverallScoreShort => 'সামগ্রিক স্কোর';

  @override
  String get avNatalSignScore => 'জন্ম রাশি স্কোর';

  @override
  String get avBestSigns => 'সেরা রাশি';

  @override
  String get avWeakSigns => 'দুর্বল রাশি';

  @override
  String get avAiInterpretation => 'AI ব্যাখ্যা';

  @override
  String get avVeryGood => 'খুব ভালো';

  @override
  String get avVeryWeak => 'খুব দুর্বল';

  @override
  String get avTotalSav => 'মোট SAV';

  @override
  String get avPlanetContributions => 'গ্রহের অবদান';

  @override
  String get avFinance => 'আর্থিক';

  @override
  String get avOverallStrength => 'সামগ্রিক শক্তি';

  @override
  String get avWhatDoesThisMean => 'এর অর্থ কী?';

  @override
  String get avSimple => 'সহজ';

  @override
  String get avAdvanced => 'বিস্তারিত';

  @override
  String get avInfoTitle => 'অষ্টকবর্গ বোঝা';

  @override
  String get avStrong => 'শক্তিশালী';

  @override
  String get avModerate => 'মাঝারি';

  @override
  String get avQWhatIsAv => 'অষ্টকবর্গ কী?';

  @override
  String get avQWhatIsSav => 'SAV কী?';

  @override
  String get avQWhatIsBav => 'BAV কী?';

  @override
  String get avQHowToRead => 'এই স্কোরগুলো কীভাবে পড়বেন';

  @override
  String get avQSavVsBav => 'SAV বনাম BAV';

  @override
  String get avABody => 'অষ্টকবর্গ হলো বৈদিক জ্যোতিষে পয়েন্ট-ভিত্তিক শক্তির একটি পদ্ধতি। প্রতিটি গ্রহ তার অবস্থান অনুযায়ী বারোটি রাশিকে শুভ পয়েন্ট (বিন্দু, যাকে রেখাও বলা হয়) প্রদান করে। কোনো রাশিতে বেশি পয়েন্ট থাকলে সংশ্লিষ্ট গ্রহদশা ও গোচরের সময় জীবনের সেই ক্ষেত্র আরও মসৃণ সহায়তা পায়।';

  @override
  String get avSavBody => 'SAV (সর্ব অষ্টকবর্গ) প্রতিটি রাশির জন্য সাতটি গ্রহের পয়েন্ট যোগ করে। এটি প্রতিটি রাশির জন্য একটি একক শক্তি স্কোর দেয়, যাতে আপনি সহজেই দেখতে পারেন আপনার কুণ্ডলীতে কোন রাশি — এবং তার ভাব — সবচেয়ে বেশি সহায়তা পাচ্ছে।';

  @override
  String get avBavBody => 'BAV (ভিন্ন অষ্টকবর্গ) একটি একক গ্রহের পয়েন্ট বারোটি রাশি জুড়ে দেখায়। এটি বলে দেয় কোনো নির্দিষ্ট গ্রহ কোন রাশিগুলোকে সবচেয়ে বেশি সমর্থন করে, যা সেই গ্রহের দশা বা গোচর সক্রিয় থাকলে গুরুত্বপূর্ণ হয়ে ওঠে।';

  @override
  String get avHowToReadBody => 'বেশি সংখ্যা ভালো। SAV-এর ক্ষেত্রে, গড়ে একটি রাশি প্রায় ২৮ পয়েন্ট পায় — ৩০-এর বেশি শক্তিশালী এবং ২৫-এর কম হলে সতর্কতা প্রয়োজন। BAV-এর ক্ষেত্রে, প্রতিটি রাশি ০ থেকে ৮-এর মধ্যে থাকে, যেখানে ৪ গড় ধরা হয়। গুরুত্বপূর্ণ কাজের জন্য আপনার সবচেয়ে শক্তিশালী রাশিগুলোকে প্রাধান্য দিন, এবং দুর্বল রাশিগুলোর ক্ষেত্রে ধৈর্য ও শৃঙ্খলা বজায় রাখুন।';

  @override
  String get avSavVsBavBody => 'SAV হলো সব গ্রহের মিলিত মোট, যা একটি রাশির সামগ্রিক শক্তি দেখায়। BAV হলো একটি একক গ্রহের অবদান, যা দেখায় কোন গ্রহ সেই রাশিকে সমর্থন করছে। বড় চিত্র বোঝার জন্য SAV ব্যবহার করুন, আর কোন গ্রহ রাশির শক্তি চালাচ্ছে তা বুঝতে BAV দেখুন।';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'আপনার কুণ্ডলী ${s1}, ${s2} এবং ${s3}-এ সবচেয়ে শক্তিশালী। এই রাশিগুলো গ্রহদশা ও গোচরের সময় ভালো সহায়তা দেয়। ${weak}-এ বর্তমানে সবচেয়ে কম সহায়তা রয়েছে, তাই এর সাথে সম্পর্কিত বিষয়ে ধৈর্য ও শৃঙ্খলা সহায়ক হবে।';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '${planet} ${s1} এবং ${s2}-এর মাধ্যমে সবচেয়ে শক্তিশালীভাবে কাজ করে। এই রাশিগুলো সক্রিয় হলে ${planet}-এর সাথে সম্পর্কিত বিষয়ে উন্নতি হতে থাকে।';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'আপনার সবচেয়ে শক্তিশালী রাশি হলো ${s1} এবং ${s2} — গ্রহ এগুলোতে গোচর করলে গুরুত্বপূর্ণ শুরুর জন্য এগুলোকে প্রাধান্য দিন।';
  }

  @override
  String avInsightWeak(Object s1) {
    return '${s1}-এ সবচেয়ে কম সহায়তা রয়েছে — এর সংশ্লিষ্ট বিষয়ে সাবধানে এগোন এবং অতিরিক্ত প্রতিশ্রুতি এড়িয়ে চলুন।';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '${planet}-এর সবচেয়ে বেশি পয়েন্ট রয়েছে, তাই এর তাৎপর্যপূর্ণ বিষয়গুলো আপনার জীবনে ভালোভাবে সমর্থিত।';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '${planet}-এর সবচেয়ে কম পয়েন্ট রয়েছে এবং এটি প্রতিকার ও সচেতন প্রচেষ্টা থেকে সবচেয়ে বেশি উপকৃত হয়।';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'যেসব রাশি আপনার গড় ${avg} পয়েন্টের বেশি স্কোর করে, সেগুলো সাধারণত আরও মসৃণ ও নির্ভরযোগ্য ফলাফল দেয়।';
  }

  @override
  String get fcKey => 'কী';

  @override
  String get fcActions => 'কার্যক্রম';

  @override
  String get fcCautions => 'সতর্কতা';

  @override
  String get fc12House => '১২ ভাব';

  @override
  String get fcProbabilities => 'সম্ভাবনা';

  @override
  String get fcHousesCaps => 'ভাব';

  @override
  String get fcCritical => 'সংকটজনক';

  @override
  String get fcFlags => 'চিহ্ন';

  @override
  String get fcAnalysis => 'বিশ্লেষণ';

  @override
  String get fcConfidence => 'আত্মবিশ্বাস';

  @override
  String get fcQualityCaps => 'গুণমান';

  @override
  String get fcIncomeVs => 'আয় বনাম';

  @override
  String get fcExpense => 'ব্যয়';

  @override
  String get fcFinance => 'অর্থ';

  @override
  String get fcNetBalance => 'নিট ব্যালেন্স';

  @override
  String get fcSignature => 'স্বাক্ষর';

  @override
  String get fcBestTimeForIncome => 'আয়ের জন্য সেরা সময়';

  @override
  String get fcExpenseCaution => 'ব্যয় সতর্কতা';

  @override
  String get fcIncomeCaps => 'আয়';

  @override
  String get fcExpenseCaps => 'ব্যয়';

  @override
  String get fcRelationships => 'সম্পর্ক';

  @override
  String get fcAreasCaps => 'ক্ষেত্র';

  @override
  String get fcBestForMeetings => 'মিটিংয়ের জন্য সেরা';

  @override
  String get fcOpportunitiesVs => 'সুযোগ বনাম';

  @override
  String get fcRisks => 'ঝুঁকি';

  @override
  String get fcOutlook => 'দৃষ্টিভঙ্গি';

  @override
  String get fcAction => 'পদক্ষেপ';

  @override
  String get fcProtect => 'সুরক্ষা';

  @override
  String get fcOpportunityCaps => 'সুযোগ';

  @override
  String get fcRiskCaps => 'ঝুঁকি';

  @override
  String get fcTopOpportunities => 'শীর্ষ সুযোগ';

  @override
  String get fcTopRisks => 'শীর্ষ ঝুঁকি';

  @override
  String get fcTiming => 'সময়';

  @override
  String get fcWindows => 'উইন্ডো';

  @override
  String get fcSlotsCaps => 'স্লট';

  @override
  String get fcBestWindows => 'সেরা উইন্ডো';

  @override
  String get fcWorstWindows => 'সবচেয়ে খারাপ উইন্ডো';

  @override
  String get fcAvoid => 'এড়িয়ে চলুন';

  @override
  String get fcHouse => 'ভাব';

  @override
  String get fcFailed => 'ব্যর্থ';

  @override
  String get lifeCareer => 'কর্মজীবন';

  @override
  String get lifeHealth => 'স্বাস্থ্য';

  @override
  String get lifeWealth => 'সম্পদ';

  @override
  String get lifeFamily => 'পরিবার';

  @override
  String get lifeMind => 'মন';

  @override
  String get lifeEgo => 'অহংকার';

  @override
  String get lifeAggression => 'আক্রমণাত্মকতা';

  @override
  String get lifeConflict => 'দ্বন্দ্ব';

  @override
  String get rashiElement => 'উপাদান';

  @override
  String get rashiQuality => 'গুণ';

  @override
  String get rashiLuckyColor => 'শুভ রঙ';

  @override
  String get rashiLuckyDay => 'শুভ দিন';

  @override
  String get rashiLuckyNumber => 'শুভ সংখ্যা';

  @override
  String get rashiGemstone => 'রত্ন';

  @override
  String get rashiBody => 'শরীর';

  @override
  String get gocharTodaysTransitChart => 'আজকের গোচর চার্ট';

  @override
  String get gocharTransit => 'গোচর';

  @override
  String get thisWeek => 'এই সপ্তাহে';

  @override
  String get thisMonth => 'এই মাসে';

  @override
  String get best => 'সেরা';

  @override
  String get worst => 'সবচেয়ে খারাপ';

  @override
  String get avg => 'avg';

  @override
  String get favorableLoveWindowsLabel => 'অনুকূল প্রেমের সময়';

  @override
  String get lordLabel => 'অধিপতি';

  @override
  String get lordPlacementLabel => 'অধিপতির অবস্থান';

  @override
  String get lordDignityLabel => 'অধিপতির মর্যাদা';

  @override
  String get categoriesSuffix => 'বিভাগ';

  @override
  String get coreBlockerLabel => 'মূল বাধা';

  @override
  String get coreGiftLabel => '✦ মূল উপহার';

  @override
  String get coreThemeLabel => '● মূল বিষয়';

  @override
  String dominantLabel(Object value) {
    return 'প্রধান: ${value}';
  }

  @override
  String get karakasSuffix => 'কারক';

  @override
  String get protectiveLabel => 'সুরক্ষামূলক';

  @override
  String secondaryLabel(Object value) {
    return ' · গৌণ: ${value}';
  }

  @override
  String get tagCore => 'মূল';

  @override
  String get debtScoresHeader => '📉 ঋণ স্কোর';

  @override
  String get debtCurrentLoadStat => 'বর্তমান\nঋণভার';

  @override
  String get debtRecoveryCapacityStat => 'পুনরুদ্ধার\nক্ষমতা';

  @override
  String get debtIntensityStat => 'তীব্রতা';

  @override
  String get debtDefaultRiskStat => 'খেলাপির ঝুঁকি';

  @override
  String get debtProfileTitle => 'ঋণ প্রোফাইল';

  @override
  String get debtKarmaLabel => 'কর্ম';

  @override
  String get debtPersonalityLabel => 'ব্যক্তিত্ব';

  @override
  String get debtPhaseLabel => 'পর্যায়';

  @override
  String get debtPrimaryCategoryLabel => 'প্রধান বিভাগ';

  @override
  String get debtWord => 'ঋণ';

  @override
  String get debtYogasTitle => 'ঋণ যোগ';

  @override
  String get debtCreatingLabel => 'ঋণ-সৃষ্টিকারী';

  @override
  String get debtClearingLabel => 'ঋণ-নিষ্কাশক';

  @override
  String get yearlyDebtTitle => 'বার্ষিক ঋণ';

  @override
  String get debtRepaymentTitle => 'পরিশোধ';

  @override
  String get debtDangerPeriodsTitle => 'বিপদের সময়';

  @override
  String get debtDefaultPctStat => 'খেলাপি %';

  @override
  String get debtBankruptcyPctStat => 'দেউলিয়া %';

  @override
  String get debtChronicPctStat => 'দীর্ঘস্থায়ী %';

  @override
  String get debtResilienceStat => 'সহনশীলতা';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'পুনরুদ্ধার: ${pct}% · সময়রেখা: ${years} বছর';
  }

  @override
  String get debtFreeWindowLabel => '🎯 ঋণমুক্ত সময়';

  @override
  String debtFreeYear(Object year) {
    return 'বছর ${year}';
  }

  @override
  String get legalScoresHeader => '⚖️ আইনি স্কোর';

  @override
  String get legalVulnerabilityStat => 'আইনি\nদুর্বলতা';

  @override
  String get legalVictoryPotentialStat => 'বিজয়ের\nসম্ভাবনা';

  @override
  String get legalConflictStat => 'সংঘাত';

  @override
  String get legalResolutionStat => 'সমাধান';

  @override
  String get legalProfileTitle => 'আইনি প্রোফাইল';

  @override
  String get legalKarmaTypeLabel => 'কর্মের ধরন';

  @override
  String get legalConflictStyleLabel => 'সংঘাতের ধরন';

  @override
  String get legalStrategyLabel => 'কৌশল';

  @override
  String get legalCaseDurationLabel => 'মামলার মেয়াদ';

  @override
  String get legalCurrentStatusLabel => 'বর্তমান অবস্থা';

  @override
  String get legalWord => 'আইনি';

  @override
  String get legalYogasTitle => 'আইনি যোগ';

  @override
  String get legalDisputePressureLabel => 'বিবাদের চাপ';

  @override
  String get legalProtectionLabel => 'আইনি সুরক্ষা';

  @override
  String get legalStressTrendTitle => 'আইনি চাপ';

  @override
  String get legalVisibleEnemiesStat => 'দৃশ্যমান শত্রু';

  @override
  String get legalHiddenEnemiesStat => 'গোপন শত্রু';

  @override
  String get legalCriminalRiskStat => 'ফৌজদারি ঝুঁকি';

  @override
  String get legalFalseAccusationStat => 'মিথ্যা অভিযোগ';

  @override
  String get legalContractKarmaTitle => 'চুক্তি কর্ম';

  @override
  String get legalDocumentationLabel => 'নথিপত্র';

  @override
  String get legalFinePrintAwareLabel => 'সূক্ষ্ম শর্ত সচেতন';

  @override
  String get legalNegotiationSkillLabel => 'দর কষাকষির দক্ষতা';

  @override
  String get legalSignatureCautionLabel => 'স্বাক্ষর সতর্কতা';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'সহনশীলতা: ${pct}/100';
  }

  @override
  String get legalVictoryWord => 'বিজয়';

  @override
  String get legalAnalysisSuffix => 'বিশ্লেষণ';

  @override
  String get legalAsPlaintiff => 'বাদী হিসেবে';

  @override
  String get legalAsDefendant => 'বিবাদী হিসেবে';

  @override
  String get legalWinProbability => 'জয়ের সম্ভাবনা';

  @override
  String get legalDisputeWord => 'বিবাদ';

  @override
  String get lifepathScoresHeader => '🌟 জীবনপথ স্কোর';

  @override
  String get lifepathDharmaClarityStat => 'ধর্ম\nস্পষ্টতা';

  @override
  String get lifepathFortuneBaselineStat => 'ভাগ্যের\nভিত্তি';

  @override
  String get lifepathCoherenceStat => 'জীবনপথ\nসংগতি';

  @override
  String get lifepathKarmaStat => 'কর্ম';

  @override
  String get lifepathSpiritualStat => 'আধ্যাত্মিক';

  @override
  String get lifepathFameStat => 'খ্যাতি';

  @override
  String get lifepathSoulContractTitle => 'আত্মার চুক্তি';

  @override
  String get lifepathAtmakarakaLabel => 'আত্মকারক';

  @override
  String get lifepathAkFocusLabel => 'AK কেন্দ্রবিন্দু';

  @override
  String get lifepathSoulPurposeLabel => 'আত্মার উদ্দেশ্য';

  @override
  String get lifepathLifeChapterLabel => 'জীবন অধ্যায়';

  @override
  String get lifepathPrimaryDomainLabel => 'প্রধান ক্ষেত্র';

  @override
  String get lifepathLeadershipStat => 'নেতৃত্ব';

  @override
  String get lifepathWisdomTeachStat => 'জ্ঞান/শিক্ষা';

  @override
  String get lifepathServiceStat => 'সেবা';

  @override
  String get lifepathHealingStat => 'নিরাময়';

  @override
  String get lifepathFortuneYogasTitle => 'ভাগ্য যোগ';

  @override
  String get lifepathLuckBlocksLabel => 'ভাগ্য বাধা';

  @override
  String get lifepathFortuneBoostersLabel => 'ভাগ্য বর্ধক';

  @override
  String get lifepathFortuneTrendTitle => 'ভাগ্যের প্রবণতা';

  @override
  String get lifepathGoldenWindowsTitle => 'সুবর্ণ সময় ★';

  @override
  String get lifepathTransformationTitle => 'রূপান্তর';

  @override
  String get lifepathMilestonesTitle => 'জীবনের মাইলফলক';

  @override
  String get lifepathKarmicLessonsTitle => 'কার্মিক শিক্ষা';

  @override
  String get lifepathRahuGrowthLabel => 'রাহু বৃদ্ধি';

  @override
  String get lifepathKetuSurrenderLabel => 'কেতু আত্মসমর্পণ';

  @override
  String get lifepathSaturnLessonLabel => 'শনি শিক্ষা';

  @override
  String get lifepathLifeDifficultyLabel => 'জীবনের কষ্ট';

  @override
  String get lifepathSoulExperienceTitle => '★ আত্মা যা অনুভব করতে এসেছে';

  @override
  String get lifepathBlessingsTitle => '● আশীর্বাদ';

  @override
  String get lifepathLifeWord => 'জীবন';

  @override
  String get lifepathArchetypeSuffix => 'আর্কিটাইপ';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'পরিপূর্ণতা: ${pct}%';
  }

  @override
  String get lifepathDestinyVsWord => 'নিয়তি বনাম';

  @override
  String get lifepathFreeWillSuffix => 'স্বাধীন ইচ্ছা';

  @override
  String get lifepathDestinyStat => 'নিয়তি';

  @override
  String get lifepathFreeWillStat => 'স্বাধীন ইচ্ছা';

  @override
  String get pastlifeScoresHeader => '🔮 পূর্বজন্ম স্কোর';

  @override
  String get pastlifeSignatureStrengthStat => 'স্বাক্ষর\nশক্তি';

  @override
  String get pastlifeCarryForwardStat => 'বহন করা\nসংস্কার';

  @override
  String get pastlifeMasteryPreservedStat => 'সংরক্ষিত\nদক্ষতা';

  @override
  String get pastlifeUnfinishedStat => 'অসমাপ্ত';

  @override
  String get pastlifeKarmicDebtStat => 'কার্মিক ঋণ';

  @override
  String get pastlifeProfileTitle => 'পূর্বজন্ম প্রোফাইল';

  @override
  String get pastlifeThemeLabel => 'বিষয়';

  @override
  String get pastlifeProfessionLabel => 'পেশা';

  @override
  String get pastlifeSocialStandingLabel => 'সামাজিক অবস্থান';

  @override
  String get pastlifeRegionLabel => 'অঞ্চল';

  @override
  String get pastlifeSpiritualLevelLabel => 'আধ্যাত্মিক স্তর';

  @override
  String get pastlifeGenderLabel => 'লিঙ্গ';

  @override
  String get pastlifeWealthLevelLabel => 'সম্পদ স্তর';

  @override
  String get pastlifeFamilyRoleLabel => 'পারিবারিক ভূমিকা';

  @override
  String get pastlifeSkillsCarriedTitle => '★ বহন করা দক্ষতা';

  @override
  String get pastlifeNaturalAttractionsTitle => '● স্বাভাবিক আকর্ষণ';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ অব্যাখ্যাত ভয়';

  @override
  String get pastlifeMagneticPullsTitle => '→ চৌম্বকীয় টান';

  @override
  String get pastlifeRelationshipStat => 'সম্পর্ক';

  @override
  String get pastlifeFinancialStat => 'আর্থিক';

  @override
  String get pastlifeServiceStat => 'সেবা';

  @override
  String get pastlifeDharmicStat => 'ধার্মিক';

  @override
  String get pastlifeOnRelationsStat => 'সম্পর্কে';

  @override
  String get pastlifeOnCareerStat => 'কর্মজীবনে';

  @override
  String get pastlifeOnHealthStat => 'স্বাস্থ্যে';

  @override
  String get pastlifeOnSpiritualStat => 'আধ্যাত্মিকে';

  @override
  String get pastlifeKarmicResolutionTitle => 'কার্মিক সমাধান';

  @override
  String get pastlifePrimaryPathLabel => 'প্রধান পথ';

  @override
  String get pastlifeSecondaryPathLabel => 'গৌণ পথ';

  @override
  String get pastlifeClearingProgressLabel => 'নিষ্কাশন অগ্রগতি';

  @override
  String get pastlifeRemainingWorkLabel => 'অবশিষ্ট কাজ';

  @override
  String get pastlifeDebtTimelineLabel => 'ঋণ সময়রেখা';

  @override
  String get pastlifeMemoryAccessStat => 'স্মৃতি অভিগম্যতা';

  @override
  String get pastlifeDreamVisitsStat => 'স্বপ্ন দর্শন';

  @override
  String get pastlifeDejaVuStat => 'দেজা ভু';

  @override
  String get pastlifeRegressionFitStat => 'রিগ্রেশন উপযোগিতা';

  @override
  String get pastlifeActivationTitle => 'পূর্বজন্ম সক্রিয়করণ';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'পরিপক্বতা: ${maturity} · অবস্থা: ${status}';
  }

  @override
  String get pastlifeKetuWord => 'কেতু';

  @override
  String get pastlifePastMasterySuffix => 'পূর্বের দক্ষতা';

  @override
  String get pastlifeKetuMasteredLabel => 'কেতু · যা আয়ত্ত করেছেন';

  @override
  String get pastlifeRahuWord => 'রাহু';

  @override
  String get pastlifeFutureGrowthSuffix => 'ভবিষ্যৎ বৃদ্ধি';

  @override
  String get pastlifeRahuPullsLabel => 'রাহু · যা আপনাকে এগিয়ে নেয়';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ ছায়া: ${shadow}';
  }

  @override
  String get mentalScoresHeader => '🧠 মানসিক স্কোর';

  @override
  String get mentalStabilityStat => 'মানসিক\nস্থিতিশীলতা';

  @override
  String get mentalEmotionalBaselineStat => 'আবেগীয়\nভিত্তি';

  @override
  String get mentalResilienceStat => 'সহনশীলতা';

  @override
  String get mentalAnxietyStat => 'উদ্বেগ';

  @override
  String get mentalDepressionStat => 'বিষণ্নতা';

  @override
  String get mentalRegulationStat => 'নিয়ন্ত্রণ';

  @override
  String get mentalProfileTitle => 'মানসিক প্রোফাইল';

  @override
  String get mentalConstitutionLabel => 'প্রকৃতি';

  @override
  String get mentalStressDriverLabel => 'চাপের কারণ';

  @override
  String get mentalStabilityAnchorLabel => 'স্থিতিশীলতার ভিত্তি';

  @override
  String get mentalStressResponseLabel => 'চাপের প্রতিক্রিয়া';

  @override
  String get mentalAttachmentStyleLabel => 'সংযুক্তির ধরন';

  @override
  String get mentalBurnoutStageLabel => 'ক্লান্তির পর্যায়';

  @override
  String get mentalWord => 'মানসিক';

  @override
  String get mentalYogasTitle => 'মানসিক যোগ';

  @override
  String get mentalStressPressureLabel => 'চাপের পীড়ন';

  @override
  String get mentalWellnessTrendTitle => 'সুস্থতার প্রবণতা';

  @override
  String get mentalHealthyCopingTitle => '✓ স্বাস্থ্যকর মোকাবিলা';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ অস্বাস্থ্যকর ঝুঁকি';

  @override
  String get mentalRecommendedAlternativesTitle => '✦ প্রস্তাবিত বিকল্প';

  @override
  String get mentalSleepQualityStat => 'ঘুমের মান';

  @override
  String get mentalSocialSupportStat => 'সামাজিক সহায়তা';

  @override
  String get mentalBurnoutVulnStat => 'ক্লান্তির ঝুঁকি';

  @override
  String get mentalSelfAwarenessStat => 'আত্ম-সচেতনতা';

  @override
  String get mentalAnxietyWord => 'উদ্বেগ';

  @override
  String get mentalTypesSuffix => 'প্রকার';

  @override
  String get mentalTherapyWord => 'থেরাপি';

  @override
  String get mentalModalityFitSuffix => 'পদ্ধতি উপযোগিতা';

  @override
  String get characterScoresHeader => '🔍 চরিত্র স্কোর';

  @override
  String get characterStrengthStat => 'চরিত্র\nশক্তি';

  @override
  String get characterIntegrityStat => 'সততা';

  @override
  String get characterResilienceStat => 'সহনশীলতা';

  @override
  String get characterAwarenessStat => 'সচেতনতা';

  @override
  String get characterStabilityStat => 'স্থিতিশীলতা';

  @override
  String get characterEthicsStat => 'নৈতিকতা';

  @override
  String get characterSurfacePersonalityTitle => 'বাহ্যিক ব্যক্তিত্ব';

  @override
  String get characterLagnaLabel => 'লগ্ন';

  @override
  String get characterConstitutionLabel => 'প্রকৃতি';

  @override
  String get characterNakshatraLabel => 'নক্ষত্র';

  @override
  String get characterDeityLabel => 'দেবতা';

  @override
  String get characterMoonManasTitle => 'চন্দ্র মানস';

  @override
  String get characterSignLabel => 'রাশি';

  @override
  String get characterHouseLabel => 'ভাব';

  @override
  String get characterWarmthStat => 'উষ্ণতা';

  @override
  String get characterEmpathyStat => 'সহানুভূতি';

  @override
  String get characterLoyaltyStat => 'আনুগত্য';

  @override
  String get characterBoundariesStat => 'সীমানা';

  @override
  String get characterDharmaStat => 'ধর্ম';

  @override
  String get characterTruthStat => 'সত্য';

  @override
  String get characterCompassionStat => 'করুণা';

  @override
  String get characterGenerosityStat => 'উদারতা';

  @override
  String get characterSignatureVirtuesTitle => '★ স্বাক্ষর গুণাবলী';

  @override
  String get characterNaturalTalentsTitle => '● স্বাভাবিক প্রতিভা';

  @override
  String get characterShadowPatternsTitle => '⚠ ছায়া প্যাটার্ন';

  @override
  String get characterYogasTitle => 'চরিত্র যোগ';

  @override
  String get characterTestsLabel => 'পরীক্ষা';

  @override
  String get characterGiftsLabel => 'উপহার';

  @override
  String get characterSelfAwareEiStat => 'আত্ম-সচেতন EI';

  @override
  String get characterSelfRegulateStat => 'আত্ম-নিয়ন্ত্রণ';

  @override
  String get characterEmpathyEiStat => 'সহানুভূতি EI';

  @override
  String get characterSocialSkillsStat => 'সামাজিক দক্ষতা';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'উপলব্ধি: ${pct}%';
  }

  @override
  String get characterAtmakarakaWord => 'আত্মকারক';

  @override
  String get characterSoulSignatureSuffix => 'আত্মার স্বাক্ষর';

  @override
  String get characterAtmakarakaLabel => 'আত্মকারক';

  @override
  String get characterGunaWord => 'গুণ';

  @override
  String get characterProfileSuffix => 'প্রোফাইল';

  @override
  String get characterSattvaLabel => 'সত্ত্ব';

  @override
  String get characterRajasLabel => 'রজঃ';

  @override
  String get characterTamasLabel => 'তমঃ';

  @override
  String get healthScoresHeader => '🏥 স্বাস্থ্য স্কোর';

  @override
  String get healthVitalityStat => 'জীবনীশক্তি';

  @override
  String get healthImmunityStat => 'রোগ প্রতিরোধ';

  @override
  String get healthRecoveryStat => 'পুনরুদ্ধার';

  @override
  String get healthMentalStat => 'মানসিক';

  @override
  String get healthStressTolStat => 'চাপ সহনশীলতা';

  @override
  String get healthYogasTitle => 'স্বাস্থ্য যোগ';

  @override
  String get healthDiseasePressureLabel => 'রোগের চাপ';

  @override
  String get healthTrendTitle => 'স্বাস্থ্যের প্রবণতা';

  @override
  String get healthRecoveryWindowsTitle => 'পুনরুদ্ধারের সময়';

  @override
  String get healthCautionPeriodsTitle => 'সতর্কতার সময়';

  @override
  String get healthFertilityStat => 'প্রজনন ক্ষমতা';

  @override
  String get healthBurnoutRiskStat => 'ক্লান্তির ঝুঁকি';

  @override
  String get healthAddictionVulnStat => 'আসক্তির ঝুঁকি';

  @override
  String get healthWorkLifeBalStat => 'কর্ম-জীবন ভারসাম্য';

  @override
  String get healthAyurvedicWord => 'আয়ুর্বেদিক';

  @override
  String get healthConstitutionSuffix => 'প্রকৃতি';

  @override
  String get healthBodyWord => 'শরীর';

  @override
  String get healthSystemMapSuffix => 'সিস্টেম ম্যাপ';

  @override
  String get healthBodyZoneWord => 'শরীর অঞ্চল';

  @override
  String get healthVulnerabilitySuffix => 'দুর্বলতা';

  @override
  String get healthDiseaseWord => 'রোগ';

  @override
  String get healthSusceptibilitySuffix => 'সংবেদনশীলতা';

  @override
  String get healthLifestyleFactorsTitle => 'জীবনযাত্রার উপাদান';

  @override
  String get healthSleepDisciplineLabel => 'ঘুমের নিয়ম';

  @override
  String get healthDietDisciplineLabel => 'খাদ্য নিয়ম';

  @override
  String get healthExerciseNeedLabel => 'ব্যায়ামের প্রয়োজন';

  @override
  String get healthSunlightNeedLabel => 'সূর্যালোকের প্রয়োজন';

  @override
  String get healthSocialTypeLabel => 'সামাজিক ধরন';

  @override
  String get healthHealingSpeedLabel => 'নিরাময়ের গতি';

  @override
  String get wealthScoresHeader => '💰 সম্পদ স্কোর';

  @override
  String get wealthStrengthStat => 'সম্পদ\nশক্তি';

  @override
  String get wealthAccumulationStat => 'সঞ্চয়';

  @override
  String get wealthIncomeFlowStat => 'আয়ের\nপ্রবাহ';

  @override
  String get wealthSustainStat => 'টিকিয়ে রাখা';

  @override
  String get wealthMultiStreamStat => 'বহু-উৎস';

  @override
  String get wealthRetentionStat => 'ধারণক্ষমতা';

  @override
  String get wealthWord => 'সম্পদ';

  @override
  String get wealthYogasTitle => 'সম্পদ যোগ';

  @override
  String get wealthDrainsLabel => 'ক্ষয়';

  @override
  String get wealthBoostersLabel => 'বর্ধক';

  @override
  String get wealthYearlyTrendTitle => 'বার্ষিক প্রবণতা';

  @override
  String get wealthGrowthTitle => 'সম্পদ বৃদ্ধি';

  @override
  String get wealthCashPressureTitle => 'নগদ চাপ';

  @override
  String get wealthMoneyPersonalityTitle => 'অর্থ ব্যক্তিত্ব';

  @override
  String get wealthTypeLabel => 'সম্পদের ধরন';

  @override
  String get wealthRiskAppetiteLabel => 'ঝুঁকির প্রবণতা';

  @override
  String get wealthInvestmentStyleLabel => 'বিনিয়োগের ধরন';

  @override
  String get wealthMoneyPersonalityLabel => 'অর্থ ব্যক্তিত্ব';

  @override
  String get wealthSpendingLabel => 'ব্যয়';

  @override
  String get wealthDebtProbStat => 'ঋণ সম্ভাবনা %';

  @override
  String get wealthInheritanceStat => 'উত্তরাধিকার %';

  @override
  String get wealthSuddenGainsStat => 'আকস্মিক লাভ %';

  @override
  String get wealthSpouseBoostStat => 'স্বামী/স্ত্রী বৃদ্ধি %';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'সাফল্যের সম্ভাবনা: ${pct}%';
  }

  @override
  String get wealthLifetimeClassLabel => 'আজীবন সম্পদ শ্রেণী';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'প্রধান: ${value}';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'সর্বোচ্চ: ${value}';
  }

  @override
  String get wealthIncomeWord => 'আয়';

  @override
  String get wealthSourcesSuffix => 'উৎস';

  @override
  String get wealthInvestmentWord => 'বিনিয়োগ';

  @override
  String get wealthMixSuffix => 'সংমিশ্রণ';

  @override
  String wealthDrivenByLabel(Object planet) {
    return '${planet} দ্বারা চালিত';
  }

  @override
  String get marriageScoresHeader => '💒 বিবাহ স্কোর';

  @override
  String get marriageOverallStat => 'সামগ্রিক\nবিবাহ';

  @override
  String get marriageHarmonyStat => 'দাম্পত্য\nসম্প্রীতি';

  @override
  String get marriageDomesticStabilityStat => 'গার্হস্থ্য\nস্থিতিশীলতা';

  @override
  String get marriageLongevityStat => 'স্থায়িত্ব';

  @override
  String get marriageSatisfactionStat => 'সন্তুষ্টি';

  @override
  String get marriageClarityStat => 'স্পষ্টতা';

  @override
  String get marriageWindowsTitle => 'বিবাহের সময়';

  @override
  String get marriagePhasesTitle => 'বিবাহের পর্যায়';

  @override
  String get marriageInLawRelationsStat => 'শ্বশুরবাড়ির সম্পর্ক';

  @override
  String get marriageFamilyHarmonyStat => 'পারিবারিক সম্প্রীতি';

  @override
  String get marriageFertilityStat => 'প্রজনন ক্ষমতা';

  @override
  String get marriageHomeOwnershipStat => 'বাড়ির মালিকানা';

  @override
  String get marriageDivorceRiskStat => 'বিবাহবিচ্ছেদ ঝুঁকি';

  @override
  String get marriageInfidelityStat => 'অবিশ্বস্ততা';

  @override
  String get marriageConflictStat => 'সংঘাত';

  @override
  String get marriageDistanceStat => 'দূরত্ব';

  @override
  String get marriageSeekInPartnerTitle => '★ সঙ্গীর মধ্যে খুঁজুন';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ সঙ্গীর মধ্যে এড়িয়ে চলুন';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'উপলব্ধি: ${pct}%';
  }

  @override
  String get marriageDarakarakaWord => 'দারাকারক';

  @override
  String get marriageSpouseKarakaSuffix => 'স্বামী/স্ত্রী কারক';

  @override
  String get marriageDarakarakaDkLabel => 'দারাকারক (DK)';

  @override
  String get marriage7thWord => '৭ম';

  @override
  String get marriageSignLabel => 'রাশি';

  @override
  String get marriageLordInLabel => 'অধিপতি যেখানে';

  @override
  String get marriageStrengthLabel => 'শক্তি';

  @override
  String get marriageSpouseWord => 'স্বামী/স্ত্রী';

  @override
  String get marriageProfileSuffix => 'প্রোফাইল';

  @override
  String get marriageSpouseTraitsTitle => '★ স্বামী/স্ত্রীর বৈশিষ্ট্য';

  @override
  String get marriageLikelyProfessionsTitle => '● সম্ভাব্য পেশা';

  @override
  String get marriageHarmonyWord => 'সম্প্রীতি';

  @override
  String get marriageRadarSuffix => 'রাডার';

  @override
  String get marriagePhysicalLabel => 'শারীরিক';

  @override
  String get marriageSharedValuesLabel => 'অভিন্ন মূল্যবোধ';

  @override
  String get marriageConflictResolutionLabel => 'সংঘাত সমাধান';

  @override
  String get marriageMangalDoshLabel => '⚠ মঙ্গল দোষ';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'তীব্রতা: ${value}';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'বাতিলকরণ: ${value}';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'নবাংশ';

  @override
  String get multiChartTitleChild => 'সন্তান';

  @override
  String get multiChartTitleLove => 'প্রেম';

  @override
  String get multiChartTitleKarma => 'কর্ম';

  @override
  String get multiChartTitleDefault => 'মাল্টি-চার্ট';

  @override
  String get multiChartSuffixProbability => 'সম্ভাবনা';

  @override
  String get multiChartSuffixCompatibility => 'সামঞ্জস্য';

  @override
  String get multiChartSuffixLinkage => 'সংযোগ';

  @override
  String get multiChartSuffixReport => 'রিপোর্ট';

  @override
  String get multiChartParticipantsLabel => 'অংশগ্রহণকারী';

  @override
  String get multiChartAnalysisWord => 'বিশ্লেষণ';

  @override
  String get multiChartConfidenceSuffix => 'আস্থা';

  @override
  String get multiChartQualityBadge => 'গুণমান';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'এই বৈদিক জ্যোতিষ রিপোর্টটি বিশ্লেষণ করুন এবং বিস্তারিত অন্তর্দৃষ্টি দিন:\n\n${formatted}';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'এটি একটি বৈদিক জ্যোতিষ বিশেষজ্ঞ রিপোর্ট। অনুগ্রহ করে এটি পুঙ্খানুপুঙ্খভাবে বিশ্লেষণ করুন এবং কার্যকর অন্তর্দৃষ্টি প্রদান করুন:\n\n${formatted}';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'এই বৈদিক জ্যোতিষ বিশ্লেষণটি পর্যালোচনা করুন এবং মূল ফলাফলগুলি সহজ ভাষায় ব্যাখ্যা করুন:\n\n${formatted}';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return '${label} এর জন্য কপি করা হয়েছে!';
  }

  @override
  String get childProbTitle1 => 'সন্তান';

  @override
  String get childProbTitle2 => 'সম্ভাবনা';

  @override
  String get childNumberOfChildrenHeader1 => 'সন্তানের';

  @override
  String get childNumberOfChildrenHeader2 => 'সংখ্যা';

  @override
  String get childTimingHeader1 => 'সময়';

  @override
  String get childTimingHeader2 => 'মূল দশা';

  @override
  String get child5thHouseHeader1 => '৫ম ভাব';

  @override
  String get analysisWord => 'বিশ্লেষণ';

  @override
  String get jupiterWord => 'বৃহস্পতি';

  @override
  String get childD7Header1 => 'D7 সপ্তাংশ';

  @override
  String get childBeejaHeader1 => 'বীজ ও ক্ষেত্র';

  @override
  String get childBeejaHeader2 => 'স্ফুট';

  @override
  String get childDoshaHeader1 => 'দোষ';

  @override
  String get childVedicHeader1 => 'বৈদিক';

  @override
  String get childVedicHeader2 => 'প্রতিকার';

  @override
  String get progenyProbabilityLabel => 'সন্তান সম্ভাবনা';

  @override
  String get favorableWindowsLabel => 'অনুকূল সময়';

  @override
  String get partnerOneLabel => 'সঙ্গী ১';

  @override
  String get partnerTwoLabel => 'সঙ্গী ২';

  @override
  String get moonSignLabel => 'চন্দ্র রাশি';

  @override
  String get lordInDusthana => 'অধিপতি দুঃস্থানে';

  @override
  String get lordStrengthLabel => 'অধিপতির শক্তি';

  @override
  String get houseStrengthLabel => 'ভাবের শক্তি';

  @override
  String get dignityLabel => 'মর্যাদা';

  @override
  String get directBadge => 'মার্গী';

  @override
  String get notCombustBadge => 'অস্তমিত নয়';

  @override
  String get in5thHouseBadge => '৫ম ভাবে';

  @override
  String get aspects5thBadge => '৫মে দৃষ্টি';

  @override
  String get no5thConnectionBadge => '৫মে সংযোগ নেই';

  @override
  String jupiterInSignHeading(String sign) {
    return '${sign} রাশিতে বৃহস্পতি';
  }

  @override
  String get d7LagnaLabel => 'D7 লগ্ন';

  @override
  String get d7FifthSignLabel => 'D7 ৫ম রাশি';

  @override
  String get d7FifthLordLabel => 'D7 ৫ম অধিপতি';

  @override
  String get jupiterInD7Label => 'D7-এ বৃহস্পতি';

  @override
  String get jupiterDignityLabel => 'বৃহস্পতির মর্যাদা';

  @override
  String get d7StrengthLabel => 'D7 শক্তি';

  @override
  String get yesWord => 'হ্যাঁ';

  @override
  String get noWord => 'না';

  @override
  String get beejaSphutaTitle => 'বীজ স্ফুট';

  @override
  String get kshetraSphutaTitle => 'ক্ষেত্র স্ফুট';

  @override
  String get degreeLabel => 'ডিগ্রি';

  @override
  String get signLordLabel => 'রাশি অধিপতি';

  @override
  String get presentInLabel => 'যেখানে উপস্থিত';

  @override
  String get netPenaltyLabel => 'নিট জরিমানা';

  @override
  String get remedyGemstone => 'রত্ন প্রতিকার';

  @override
  String get remedyMantra => 'মন্ত্র প্রতিকার';

  @override
  String get remedyRitual => 'আচার প্রতিকার';

  @override
  String get remedyLifestyle => 'জীবনযাত্রা প্রতিকার';

  @override
  String get remedyCharitable => 'দান প্রতিকার';

  @override
  String copiedForName(String name) {
    return '${name} এর জন্য কপি করা হয়েছে!';
  }

  @override
  String get mahadashaLabel => 'মহাদশা';

  @override
  String get mdPeriodLabel => 'MD সময়কাল';

  @override
  String get antardashaLabel => 'অন্তর্দশা';

  @override
  String get adPeriodLabel => 'AD সময়কাল';

  @override
  String get pratyantardashaLabel => 'প্রত্যন্তর্দশা';

  @override
  String get favorabilityLabel => 'অনুকূলতা';

  @override
  String factorPrefix(String factor) {
    return 'উপাদান: ${factor}';
  }

  @override
  String appliesToLabel(String value) {
    return 'প্রযোজ্য: ${value}';
  }

  @override
  String get qualityTag => 'গুণমান';

  @override
  String get reliabilityVeryHigh => 'খুব উচ্চ নির্ভরযোগ্যতা';

  @override
  String get reliabilityGuidanceLevel => 'নির্দেশনা-স্তরের পাঠ';

  @override
  String get karmaLinkTitle1 => 'কর্ম';

  @override
  String get karmaLinkTitle2 => 'সংযোগ';

  @override
  String get karmaFoundationHeader1 => 'কার্মিক';

  @override
  String get karmaFoundationHeader2 => 'ভিত্তি';

  @override
  String get karmaPairwiseHeader1 => 'জোড়াভিত্তিক';

  @override
  String get karmaPairwiseHeader2 => 'সংযোগ';

  @override
  String get karmaGroupHeader1 => 'গোষ্ঠী';

  @override
  String get karmaGroupHeader2 => 'প্যাটার্ন';

  @override
  String get karmaPastLifeHeader1 => 'পূর্বজন্ম';

  @override
  String get karmaPastLifeHeader2 => 'লক্ষ্য';

  @override
  String get karmaCurrentLifeHeader1 => 'বর্তমান জীবন';

  @override
  String get karmaCurrentLifeHeader2 => 'শিক্ষা';

  @override
  String get karmaDebtsHeader2 => 'ঋণ';

  @override
  String get karmaMoolaDashaHeader1 => 'মূল দশা';

  @override
  String get karmaMoolaDashaHeader2 => 'সময়';

  @override
  String get karmaDeepAuditHeader1 => 'গভীর নিরীক্ষা';

  @override
  String get karmaDeepAuditHeader2 => 'সারণী';

  @override
  String get karmaHeroLabel => 'পূর্বজন্ম কর্ম সংযোগ';

  @override
  String get karmaKetuMastery => 'কেতু দক্ষতা';

  @override
  String get nakshatraLabel => 'নক্ষত্র';

  @override
  String get deityLabel => 'দেবতা';

  @override
  String get masteryScoreLabel => 'দক্ষতা স্কোর';

  @override
  String get karmaRahuGrowth => 'রাহু বৃদ্ধি';

  @override
  String get growthScoreLabel => 'বৃদ্ধি স্কোর';

  @override
  String get karmaAtmakaraka => 'আত্মকারক';

  @override
  String get karmaSaturnKarma => 'শনি কর্ম';

  @override
  String get karma12thHouse => '১২তম ভাব';

  @override
  String get karma9thHousePunya => '৯ম ভাব পুণ্য';

  @override
  String get bhavaScoreLabel => 'ভাব স্কোর';

  @override
  String get karmaD60Signature => 'D60 স্বাক্ষর';

  @override
  String get depthScoreLabel => 'গভীরতা স্কোর';

  @override
  String get linkageStrengthLabel => 'সংযোগ শক্তি';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'সংযোগ উপাদান (${count} সক্রিয়)';
  }

  @override
  String get factorColumnLabel => 'উপাদান';

  @override
  String get weightColumnLabel => 'ওজন';

  @override
  String get meaningColumnLabel => 'অর্থ';

  @override
  String get statusColumnLabel => 'অবস্থা';

  @override
  String get karmaPastLifeConnection => 'পূর্বজন্ম সংযোগ';

  @override
  String get karmaCurrentLifeDynamic => 'বর্তমান জীবন গতিশীলতা';

  @override
  String get karmaWhatTheyTeach => 'তারা একে অপরকে যা শেখায়';

  @override
  String get karmaGroupThemeHeader => 'গোষ্ঠী কার্মিক বিষয়';

  @override
  String get karmaSharedSettingHeader => 'অভিন্ন পূর্বজন্ম পরিবেশ';

  @override
  String get karmaCollectiveKetuHeader => 'সমষ্টিগত কেতু প্যাটার্ন';

  @override
  String get karmaCollectiveRahuHeader => 'সমষ্টিগত রাহু প্যাটার্ন';

  @override
  String get housesPrefixLabel => 'ভাব: ';

  @override
  String get signsPrefixLabel => 'রাশি: ';

  @override
  String get karmicCohesionLabel => 'কার্মিক সংহতি';

  @override
  String get karmaGroupSoulContractHeader => 'গোষ্ঠী আত্মার চুক্তি';

  @override
  String get goalLabel => 'লক্ষ্য';

  @override
  String get karmaSharedGoalHeader => 'অভিন্ন পূর্বজন্ম লক্ষ্য';

  @override
  String get howToGrowHeader => 'কীভাবে বৃদ্ধি পাবেন';

  @override
  String moolaDashaPrefix(String value) {
    return 'মূল দশা: ${value}';
  }

  @override
  String get karmaSharedLessonHeader => 'অভিন্ন গোষ্ঠী শিক্ষা';

  @override
  String get karmaMutualTeachingHeader => 'পারস্পরিক শিক্ষা মানচিত্র';

  @override
  String get karmaTeachingDynamicsPlaceholder => 'কার্মিক সংযোগ গভীর হওয়ার সাথে সাথে শিক্ষার গতিশীলতা উদ্ভূত হবে।';

  @override
  String get typeFieldLabel => 'ধরন';

  @override
  String get basisFieldLabel => 'ভিত্তি';

  @override
  String get resolutionPathHeader => 'সমাধানের পথ';

  @override
  String dashaTimingPrefix(String value) {
    return 'দশা সময়: ${value}';
  }

  @override
  String get mutualDebtsHeader => 'পারস্পরিক ঋণ';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'তারিখ';

  @override
  String get groupKarmicWindowHeader => 'গোষ্ঠী কার্মিক সময়';

  @override
  String parametersAuditedHeading(int count) {
    return '${count} প্যারামিটার নিরীক্ষিত';
  }

  @override
  String get valuePrefixLabel => 'মান: ';

  @override
  String weightPrefix(String value) {
    return 'W: ${value}';
  }

  @override
  String get loveCompatTitle1 => 'প্রেম';

  @override
  String get loveCompatTitle2 => 'সামঞ্জস্য';

  @override
  String get loveAttractionHeader1 => 'আকর্ষণ ও';

  @override
  String get loveAttractionHeader2 => 'রসায়ন';

  @override
  String get loveEmotionalHeader1 => 'আবেগীয়';

  @override
  String get loveEmotionalHeader2 => 'সম্প্রীতি';

  @override
  String get loveMentalHeader1 => 'মানসিক';

  @override
  String get loveMentalHeader2 => 'সমঝোতা';

  @override
  String get lovePassionHeader1 => 'আবেগ ও';

  @override
  String get lovePassionHeader2 => 'শারীরিক';

  @override
  String get loveLongtermHeader1 => 'দীর্ঘমেয়াদী';

  @override
  String get loveKarmicHeader1 => 'কার্মিক প্রেম';

  @override
  String get loveKarmicHeader2 => 'বন্ধন';

  @override
  String get loveChallengesHeader1 => 'চ্যালেঞ্জ ও';

  @override
  String get loveChallengesHeader2 => 'ঘর্ষণ';

  @override
  String get loveTimingHeader1 => 'প্রেমের সময়';

  @override
  String get loveRelationshipHeader1 => 'সম্পর্ক';

  @override
  String get loveRelationshipHeader2 => 'গতিশীলতা';

  @override
  String get loveRemediesHeader1 => 'প্রতিকার ও';

  @override
  String get loveRemediesHeader2 => 'নির্দেশনা';

  @override
  String get loveCompatHeroLabel => 'প্রেম সামঞ্জস্য';

  @override
  String get loveChipAttraction => 'আকর্ষণ';

  @override
  String get loveChipPassion => 'আবেগ';

  @override
  String get loveChipChallenge => 'চ্যালেঞ্জ';

  @override
  String get venusSignLabel => 'শুক্র রাশি';

  @override
  String get attractionScoreLabel => 'আকর্ষণ স্কোর';

  @override
  String get activeContactsLabel => 'সক্রিয় সংযোগ';

  @override
  String get magneticPullLabel => 'চৌম্বকীয় টান';

  @override
  String get initialAttractionLabel => 'প্রাথমিক আকর্ষণ';

  @override
  String get emotionalScoreLabel => 'আবেগীয় স্কোর';

  @override
  String get elementMatchLabel => 'উপাদান মিল';

  @override
  String get harmonyLabel => 'সম্প্রীতি';

  @override
  String get kootaYoni => 'যোনি';

  @override
  String get kootaGana => 'গণ';

  @override
  String get kootaTara => 'তারা';

  @override
  String get doshaPresentBadge => 'দোষ উপস্থিত';

  @override
  String get noDoshaBadge => 'কোনো দোষ নেই';

  @override
  String get axisLabel => 'অক্ষ';

  @override
  String get mentalScoreLabel => 'মানসিক স্কোর';

  @override
  String get mercuryDynamicsLabel => 'বুধ গতিশীলতা';

  @override
  String get communicationStyleLabel => 'যোগাযোগ শৈলীর মিল';

  @override
  String get intellectualConnectionLabel => 'বৌদ্ধিক সংযোগ';

  @override
  String get passionScoreLabel => 'আবেগ স্কোর';

  @override
  String get marsVenusLabel => 'মঙ্গল-শুক্র মিথস্ক্রিয়া';

  @override
  String get physicalChemistryLabel => 'শারীরিক রসায়ন';

  @override
  String get yoniCompatLabel => 'যোনি সামঞ্জস্য';

  @override
  String get longtermScoreLabel => 'দীর্ঘমেয়াদী স্কোর';

  @override
  String get seventhHouseSynastryLabel => '৭ম ভাব সিন্যাস্ট্রি';

  @override
  String get commitmentPotentialLabel => 'প্রতিশ্রুতির সম্ভাবনা';

  @override
  String get jupiterBlessingLabel => 'বৃহস্পতির আশীর্বাদ';

  @override
  String get d9NavamsaResonanceLabel => 'D9 নবাংশ অনুরণন';

  @override
  String get saturnLongevityLabel => 'শনি স্থায়িত্ব';

  @override
  String get karmicScoreLabel => 'কার্মিক স্কোর';

  @override
  String get darakarakaLinkLabel => 'দারাকারক সংযোগ';

  @override
  String get sourceLabel => 'উৎস';

  @override
  String get emotionalGiverReceiverLabel => 'আবেগীয় দাতা / গ্রহীতা';

  @override
  String get powerBalanceLabel => 'ক্ষমতার ভারসাম্য';

  @override
  String get growthDynamicLabel => 'বৃদ্ধি গতিশীলতা';

  @override
  String get addressesLabel => 'সম্বোধন';

  @override
  String get loveScoresLabel => 'প্রেম স্কোর';

  @override
  String get loveCapacityLabel => 'প্রেমের\nক্ষমতা';

  @override
  String get emotionalAvailabilityLabel => 'আবেগীয়\nপ্রাপ্যতা';

  @override
  String get romanticAttractionLabel => 'রোমান্টিক\nআকর্ষণ';

  @override
  String get commitmentWord => 'প্রতিশ্রুতি';

  @override
  String get intimacyWord => 'ঘনিষ্ঠতা';

  @override
  String get fidelityWord => 'বিশ্বস্ততা';

  @override
  String get loveProfileTitle => 'প্রেম প্রোফাইল';

  @override
  String get loveStyleLabel => 'প্রেমের ধরন';

  @override
  String get attractionStyleLabel => 'আকর্ষণের ধরন';

  @override
  String get lovePathLabel => 'প্রেমের পথ';

  @override
  String get currentPhaseLabel => 'বর্তমান পর্যায়';

  @override
  String get commitmentStyleLabel => 'প্রতিশ্রুতির ধরন';

  @override
  String get loveWord => 'প্রেম';

  @override
  String get karakasWord => 'কারক';

  @override
  String get attractedToLabel => 'আকৃষ্ট যার প্রতি';

  @override
  String get whatPartnerSeesLabel => 'সঙ্গী যা দেখে';

  @override
  String get romancePatternTitle => 'রোমান্স প্যাটার্ন';

  @override
  String get firstLoveAgeLabel => 'প্রথম প্রেমের বয়স';

  @override
  String get relationshipCountLabel => 'সম্পর্কের সংখ্যা';

  @override
  String get avgDurationLabel => 'গড় মেয়াদ';

  @override
  String get breakupTriggerLabel => 'সম্পর্কভঙ্গের কারণ';

  @override
  String get heartbreakRecoveryLabel => 'হৃদয়ভঙ্গ পুনরুদ্ধার';

  @override
  String get loveTrendTitle => 'প্রেমের প্রবণতা';

  @override
  String get newLoveWindowsTitle => 'নতুন প্রেমের সময়';

  @override
  String get loveBlocksTitle => 'প্রেম বাধা';

  @override
  String get activeBlocksLabel => 'সক্রিয় বাধা';

  @override
  String get loveMarriagePctLabel => 'প্রেম বিবাহ %';

  @override
  String get heartbreakVulnLabel => 'হৃদয়ভঙ্গ ঝুঁকি';

  @override
  String get selfSabotageLabel => 'আত্ম-বিধ্বংস';

  @override
  String get emotionalIqLabel => 'আবেগীয় IQ';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'পরিপূর্ণতা: ${pct}%';
  }

  @override
  String get languagesWord => 'ভাষা';

  @override
  String get givesLabel => 'দেয়';

  @override
  String get receivesLabel => 'গ্রহণ করে';

  @override
  String get idealWord => 'আদর্শ';

  @override
  String get partnerWord => 'সঙ্গী';

  @override
  String get seekTheseTraitsLabel => 'এই বৈশিষ্ট্যগুলি খুঁজুন';

  @override
  String get dealbreakersLabel => 'চুক্তিভঙ্গকারী';

  @override
  String get propertyScoresLabel => 'সম্পত্তি স্কোর';

  @override
  String get acquisitionCapacityLabel => 'অর্জনের\nক্ষমতা';

  @override
  String get homeOwnershipPctLabel => 'বাড়ির\nমালিকানা %';

  @override
  String get reWealthPotentialLabel => 'রিয়েল এস্টেট\nসম্পদ সম্ভাবনা';

  @override
  String get rentalWord => 'ভাড়া';

  @override
  String get vehiclesWord => 'যানবাহন';

  @override
  String get landPctLabel => 'জমি %';

  @override
  String get propertyProfileTitle => 'সম্পত্তি প্রোফাইল';

  @override
  String get karmaTypeLabel => 'কর্মের ধরন';

  @override
  String get environmentLabel => 'পরিবেশ';

  @override
  String get styleLabel => 'ধরন';

  @override
  String get sizeLabel => 'আকার';

  @override
  String get locationLabel => 'অবস্থান';

  @override
  String get actionNext12mLabel => 'পরবর্তী ১২ মাসের পদক্ষেপ';

  @override
  String get propertyWord => 'সম্পত্তি';

  @override
  String get propertyYogasTitle => 'সম্পত্তি যোগ';

  @override
  String get drainsLabel => 'ক্ষয়';

  @override
  String get boostersLabel => 'বর্ধক';

  @override
  String get propertyTrendTitle => 'সম্পত্তি প্রবণতা';

  @override
  String get buyingWindowsTitle => 'ক্রয়ের সময়';

  @override
  String get constructionWindowsTitle => 'নির্মাণের সময়';

  @override
  String get maternalInherPctLabel => 'মাতৃকূল উত্তরাধিকার %';

  @override
  String get paternalInherPctLabel => 'পিতৃকূল উত্তরাধিকার %';

  @override
  String get multiHomePctLabel => 'একাধিক বাড়ি %';

  @override
  String get investmentPctLabel => 'বিনিয়োগ %';

  @override
  String get vehicleProfileTitle => 'যানবাহন প্রোফাইল';

  @override
  String get countLabel => 'সংখ্যা';

  @override
  String get firstAgeLabel => 'প্রথম বয়স';

  @override
  String get categoryLabel => 'বিভাগ';

  @override
  String get luxuryLabel => 'বিলাসিতা';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'আজীবন সংখ্যা: ${count} · পরিপূর্ণতা: ${pct}%';
  }

  @override
  String get pressureWord => 'চাপ';

  @override
  String get protectionWord => 'সুরক্ষা';

  @override
  String get astrologicalWord => 'জ্যোতিষশাস্ত্রীয়';

  @override
  String get keyRisksHeader1 => 'মূল';

  @override
  String get keyRisksHeader2 => 'ঝুঁকি';

  @override
  String get reportCopiedShort => 'রিপোর্ট কপি হয়েছে!';

  @override
  String get keyScoresLabel => 'মূল স্কোর';

  @override
  String allScoresCountLabel(int count) {
    return 'সব স্কোর (${count})';
  }

  @override
  String get windowsWord => 'সময়';

  @override
  String get genericFailedMsg => 'ব্যর্থ';

  @override
  String get unknownWord => 'অজানা';

  @override
  String selectKarmaChartsLabel(int max) {
    return '২-${max}টি চার্ট নির্বাচন করুন';
  }

  @override
  String selectChartsLabelCount(int max) {
    return '${max}টি চার্ট নির্বাচন করুন';
  }

  @override
  String runningAnalysisLabel(String label) {
    return '${label} বিশ্লেষণ চলছে...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'কার্মিক সংযোগ বিশ্লেষণ করতে ২ থেকে ${max}টি চার্ট বাছুন';
  }

  @override
  String get pickMaleFemaleHint => 'একটি পুরুষ ও একটি মহিলা চার্ট বাছুন';

  @override
  String get personOneLabel => 'ব্যক্তি ১';

  @override
  String get personTwoLabel => 'ব্যক্তি ২';

  @override
  String get analysisFailedMsg => 'বিশ্লেষণ ব্যর্থ';

  @override
  String analyzeChartsCountLabel(int count) {
    return '${count}টি চার্ট বিশ্লেষণ করুন';
  }

  @override
  String get contextGeneralLabel => 'সাধারণ';

  @override
  String get contextLoveLabel => 'প্রেম';

  @override
  String get contextBusinessLabel => 'ব্যবসা';

  @override
  String get contextFamilyLabel => 'পরিবার';

  @override
  String get contextTeamLabel => 'দল';

  @override
  String get contextFriendshipLabel => 'বন্ধুত্ব';

  @override
  String get relationshipIntelTitle => 'সম্পর্ক বুদ্ধিমত্তা';

  @override
  String analyzingChartsCountLabel(int count) {
    return '${count}টি চার্ট বিশ্লেষণ করা হচ্ছে...';
  }

  @override
  String get relationshipContextLabel => 'সম্পর্কের প্রসঙ্গ';

  @override
  String get kundliMilanReportTitle => 'কুণ্ডলী মিলন রিপোর্ট';

  @override
  String get runningMilanAnalysisLabel => 'মিলন বিশ্লেষণ চলছে...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '${count}/2 নির্বাচিত';
  }

  @override
  String get runMilanAnalysisBtn => 'মিলন বিশ্লেষণ চালান';

  @override
  String get noChartsCreateFirst => 'কোনো চার্ট নেই। প্রথমে একটি জন্মকুণ্ডলী তৈরি করুন।';

  @override
  String get selectBirthChartAnalyze => 'বিশ্লেষণের জন্য একটি জন্মকুণ্ডলী নির্বাচন করুন';

  @override
  String get doshAnalysis => 'দোষ বিশ্লেষণ';

  @override
  String doshActiveCount(Object active, Object total) {
    return '${active} সক্রিয় / ${total} পরীক্ষিত';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '${active} সক্রিয় / ${total} যোগ পরীক্ষিত';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'সক্রিয় যোগ (${count})';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'নিষ্ক্রিয় যোগ লুকান (${count})';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'নিষ্ক্রিয় যোগ দেখান (${count})';
  }

  @override
  String get loadFailed => 'ব্যর্থ';

  @override
  String dashaDrillMd(Object planet) {
    return '${planet} MD → অন্তর্দশা';
  }

  @override
  String dashaDrillAd(Object planet) {
    return '${planet} AD → প্রত্যন্তর্দশা';
  }

  @override
  String dashaDrillPd(Object planet) {
    return '${planet} PD → সূক্ষ্মদশা';
  }

  @override
  String dashaDrillSub(Object planet) {
    return '${planet} উপ-সময়কাল';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return 'জন্ম অধিপতি: ${lord} • ভারসাম্য: ${balance} বছর';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'লগ্ন: ${lagna} • ভারসাম্য: ${balance} বছর';
  }

  @override
  String dashaYearsValue(Object years) {
    return '${years} বছর';
  }

  @override
  String get dashaCurrentPeriod => 'বর্তমান দশা সময়কাল';

  @override
  String dashaAsOf(Object date) {
    return 'যে তারিখে: ${date}';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'বর্তমান সময়ে সক্রিয় যোগ (${count})';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'বর্তমান সময়ে সক্রিয় দোষ (${count})';
  }

  @override
  String get dashaNoYogasTriggered => 'কোনো যোগ সক্রিয় হয়নি';

  @override
  String get dashaNoDoshasTriggered => 'কোনো দোষ সক্রিয় হয়নি';

  @override
  String get divD1Name => 'রাশি (D-1)';

  @override
  String get divD1Desc => 'শারীরিক অস্তিত্ব, সব বিষয়';

  @override
  String get divD2Name => 'হোরা (D-2)';

  @override
  String get divD2Desc => 'সম্পদ, অর্থ';

  @override
  String get divD3Name => 'দ্রেক্কাণ (D-3)';

  @override
  String get divD3Desc => 'ভাইবোন, সাহস';

  @override
  String get divD4Name => 'চতুর্থাংশ (D-4)';

  @override
  String get divD4Desc => 'সম্পত্তি, বাসস্থান, ভাগ্য';

  @override
  String get divD5Name => 'পঞ্চমাংশ (D-5)';

  @override
  String get divD5Desc => 'খ্যাতি, কর্তৃত্ব, ক্ষমতা';

  @override
  String get divD6Name => 'ষষ্ঠাংশ (D-6)';

  @override
  String get divD6Desc => 'স্বাস্থ্য সমস্যা';

  @override
  String get divD7Name => 'সপ্তাংশ (D-7)';

  @override
  String get divD7Desc => 'সন্তান, নাতি-নাতনি';

  @override
  String get divD8Name => 'অষ্টাংশ (D-8)';

  @override
  String get divD8Desc => 'আকস্মিক সমস্যা, মামলা';

  @override
  String get divD9Name => 'নবাংশ (D-9)';

  @override
  String get divD9Desc => 'বিবাহ, স্বামী/স্ত্রী, ধর্ম';

  @override
  String get divD10Name => 'দশাংশ (D-10)';

  @override
  String get divD10Desc => 'কর্মজীবন, পেশা';

  @override
  String get divD11Name => 'রুদ্রাংশ (D-11)';

  @override
  String get divD11Desc => 'মৃত্যু, ধ্বংস';

  @override
  String get divD12Name => 'দ্বাদশাংশ (D-12)';

  @override
  String get divD12Desc => 'পিতামাতা, রক্তসম্পর্কীয়';

  @override
  String get divD16Name => 'ষোড়শাংশ (D-16)';

  @override
  String get divD16Desc => 'যানবাহন, আরাম, সুখ';

  @override
  String get divD20Name => 'বিংশাংশ (D-20)';

  @override
  String get divD20Desc => 'আধ্যাত্মিক বিষয়, ধর্মীয়';

  @override
  String get divD24Name => 'চতুর্বিংশাংশ (D-24)';

  @override
  String get divD24Desc => 'শিক্ষা, জ্ঞান, বিদ্যা';

  @override
  String get divD27Name => 'নক্ষত্রাংশ (D-27)';

  @override
  String get divD27Desc => 'শক্তি, দুর্বলতা, প্রকৃতি';

  @override
  String get divD30Name => 'ত্রিংশাংশ (D-30)';

  @override
  String get divD30Desc => 'অশুভ, অবচেতন, শাস্তি';

  @override
  String get divD40Name => 'খবেদাংশ (D-40)';

  @override
  String get divD40Desc => 'শুভ/অশুভ (মাতৃকূল)';

  @override
  String get divD45Name => 'অক্ষবেদাংশ (D-45)';

  @override
  String get divD45Desc => 'সব বিষয় (পিতৃকূল)';

  @override
  String get divD60Name => 'ষষ্ট্যংশ (D-60)';

  @override
  String get divD60Desc => 'পূর্বজন্ম কর্ম — সবচেয়ে গুরুত্বপূর্ণ';

  @override
  String get lifeAreaCareer => 'কর্মজীবন';

  @override
  String get lifeAreaWealth => 'সম্পদ';

  @override
  String get lifeAreaMarriage => 'বিবাহ';

  @override
  String get lifeAreaHealth => 'স্বাস্থ্য';

  @override
  String get lifeAreaSpirituality => 'আধ্যাত্মিকতা';

  @override
  String lifeAreaGrade(Object grade) {
    return 'গ্রেড: ${grade}';
  }

  @override
  String get lifeAreaFactorsLabel => 'উপাদান:';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return 'নক্ষত্র: ${nakshatra} (${pada})';
  }

  @override
  String planetNakLord(Object lord) {
    return 'NL: ${lord}';
  }

  @override
  String planetLongitude(Object value) {
    return 'দ্রাঘিমা: ${value}°';
  }

  @override
  String get chakraOverallHealth => 'সামগ্রিক স্বাস্থ্য';

  @override
  String get careerWord => 'কর্মজীবন';

  @override
  String get failedToLoad => 'লোড করতে ব্যর্থ';

  @override
  String get kundliAscendantLagna => 'লগ্ন (লগ্ন)';

  @override
  String get kundliMoonSignRashi => 'চন্দ্র রাশি (রাশি)';

  @override
  String get kundliSunSign => 'সূর্য রাশি';

  @override
  String kundliEngineLabel(Object engine) {
    return 'ইঞ্জিন: ${engine}';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return 'ডিগ্রি: ${degree}°  •  নক্ষত্র: ${nakshatra} (${pada})';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'নক্ষত্র অধিপতি: ${lord}  •  মর্যাদা: ${dignity}';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return '${base} চার্ট — ${sign}';
  }

  @override
  String kundliBaseChart(Object base) {
    return '${base} চার্ট';
  }

  @override
  String get careerSummary => 'কর্মজীবন সারাংশ';

  @override
  String get phase => 'পর্যায়';

  @override
  String get confidenceLabel => 'আস্থা';

  @override
  String get careerScores => 'কর্মজীবন স্কোর';

  @override
  String get stabilityLabel => 'স্থিতিশীলতা';

  @override
  String get growthLabel => 'বৃদ্ধি';

  @override
  String get gradeExcellent => 'চমৎকার';

  @override
  String get gradeGood => 'ভালো';

  @override
  String get gradeAverage => 'মাঝারি';

  @override
  String get gradeBelowAvg => 'গড়ের নিচে';

  @override
  String get gradeWeak => 'দুর্বল';

  @override
  String get careerTypeDomain => 'কর্মজীবন ও ক্ষেত্র';

  @override
  String get careerTimeline => 'কর্মজীবন সময়রেখা';

  @override
  String dashaLabel(Object dasha) {
    return 'দশা: ${dasha}';
  }

  @override
  String get improvementSuggestions => 'উন্নতির পরামর্শ';

  @override
  String get chartDetails => 'চার্ট বিবরণ';

  @override
  String get keyHousesCareer => 'মূল ভাব (কর্মজীবন)';

  @override
  String get keyCareerPlanets => 'মূল কর্মজীবন গ্রহ';

  @override
  String get empty => 'খালি';

  @override
  String get guna => 'গুণ';

  @override
  String get dasha => 'দশা';

  @override
  String get satwik => 'সাত্ত্বিক';

  @override
  String get rajasik => 'রাজসিক';

  @override
  String get tamasik => 'তামসিক';

  @override
  String get charGroupCorePersonality => 'মূল ব্যক্তিত্ব';

  @override
  String get charGroupTrustHonesty => 'বিশ্বাস ও সততা';

  @override
  String get charGroupLoyaltyCommitment => 'আনুগত্য ও প্রতিশ্রুতি';

  @override
  String get charGroupStrategicPrivacy => 'কৌশল ও গোপনীয়তা';

  @override
  String get charGroupFinancial => 'আর্থিক';

  @override
  String get charGroupAngerConflict => 'রাগ ও সংঘাত';

  @override
  String get charGroupMoralDharmic => 'নৈতিক ও ধার্মিক';

  @override
  String get charGroupIntellectCommunication => 'বুদ্ধি ও যোগাযোগ';

  @override
  String get charGroupEmotionalProfile => 'আবেগীয় প্রোফাইল';

  @override
  String get charGroupMentalHealth => 'মানসিক স্বাস্থ্য';

  @override
  String get charGroupRomantic => 'রোমান্টিক';

  @override
  String get charGroupMarriageFamily => 'বিবাহ ও পরিবার';

  @override
  String get charGroupOverallLife => 'সামগ্রিক জীবন';

  @override
  String get grahaDrishti => 'গ্রহ দৃষ্টি (গ্রহ দৃষ্টিপাত)';

  @override
  String get grahaDrishtiSubtitle => 'কে কার উপর দৃষ্টি দেয় (%)';

  @override
  String get lagnaAspectsReceived => 'লগ্নে প্রাপ্ত দৃষ্টি';

  @override
  String get rashiDrishti => 'রাশি দৃষ্টি (রাশি দৃষ্টিপাত)';

  @override
  String get shadbalaRupas => 'রূপ';

  @override
  String get bhavaHouse1 => 'স্ব / দেহ';

  @override
  String get bhavaHouse2 => 'সম্পদ / পরিবার';

  @override
  String get bhavaHouse3 => 'ভাইবোন / সাহস';

  @override
  String get bhavaHouse4 => 'বাড়ি / মাতা';

  @override
  String get bhavaHouse5 => 'সন্তান / বুদ্ধি';

  @override
  String get bhavaHouse6 => 'শত্রু / স্বাস্থ্য';

  @override
  String get bhavaHouse7 => 'বিবাহ / সঙ্গী';

  @override
  String get bhavaHouse8 => 'আয়ু';

  @override
  String get bhavaHouse9 => 'ভাগ্য / গুরু';

  @override
  String get bhavaHouse10 => 'কর্মজীবন / পিতা';

  @override
  String get bhavaHouse11 => 'লাভ / বন্ধু';

  @override
  String get bhavaHouse12 => 'ক্ষতি / মোক্ষ';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '${sign} • অধিপতি: ${lord}';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: ${value}';
  }

  @override
  String get sarvaAshtakavarga => 'সর্ব অষ্টকবর্গ (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'মোট: ${total} রেখা (গড় রাশি = ${avg})';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '${planet} — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'মোট: ${total} রেখা • জন্ম রাশিতে: ${score}';
  }

  @override
  String get today => 'আজ';

  @override
  String gocharTransitScores(Object date) {
    return 'গোচর (গোচর স্কোর) — ${date}';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'জাতক চন্দ্র: ${sign}';
  }

  @override
  String get gocharBest => 'সর্বোত্তম';

  @override
  String get gocharWorst => 'সর্বনিকৃষ্ট';

  @override
  String copiedOpening(Object ai) {
    return 'কপি হয়েছে! ${ai} খোলা হচ্ছে...';
  }

  @override
  String get openLink => 'খুলুন ↗';

  @override
  String get discussReportWithAI => 'এই রিপোর্ট AI-এর সাথে আলোচনা করুন';

  @override
  String get reliabilityHigh => 'উচ্চ নির্ভরযোগ্যতা';

  @override
  String get reliabilityModerate => 'মাঝারি নির্ভরযোগ্যতা';

  @override
  String get reliabilityLow => 'কম — শুধু নির্দেশনা';

  @override
  String get reliabilityGoodEdu => 'ভালো নির্ভরযোগ্যতা · D-24 যাচাইকৃত';

  @override
  String get relationshipWord => 'সম্পর্ক';

  @override
  String get intelligenceWord => 'বুদ্ধিমত্তা';

  @override
  String get relationshipIntelligence => 'সম্পর্ক বুদ্ধিমত্তা';

  @override
  String get typeLabel => 'ধরন';

  @override
  String get trustLabel => 'বিশ্বাস';

  @override
  String get dhokaRisk => 'ধোঁকার ঝুঁকি';

  @override
  String get powerLabel => 'ক্ষমতা';

  @override
  String get integrity => 'সততা';

  @override
  String get warmth => 'উষ্ণতা';

  @override
  String get trustWord => 'বিশ্বাস';

  @override
  String get assertLabel => 'দৃঢ়তা';

  @override
  String get character => 'চরিত্র';

  @override
  String get love => 'প্রেম';

  @override
  String get businessWord => 'ব্যবসা';

  @override
  String get karmic => 'কার্মিক';

  @override
  String get enmityRisk => 'শত্রুতার ঝুঁকি';

  @override
  String get hdrChartProfiles => 'চার্ট প্রোফাইল';

  @override
  String get hdrPairwiseAnalysis => 'জোড়াভিত্তিক বিশ্লেষণ';

  @override
  String get hdrCriticalPatterns => 'গুরুত্বপূর্ণ প্যাটার্ন';

  @override
  String get hdrGroupRecommendations => 'গোষ্ঠী সুপারিশ';

  @override
  String get sharedPractices => 'অভিন্ন অনুশীলন';

  @override
  String get hdrIndividualGuidance => 'ব্যক্তিগত নির্দেশনা';

  @override
  String get growthAreas => 'বৃদ্ধির ক্ষেত্র';

  @override
  String get hdrCoreTheme => 'মূল বিষয়';

  @override
  String get growthOriented => 'বৃদ্ধিমুখী';

  @override
  String get groupTheme => 'গোষ্ঠী বিষয়';

  @override
  String get compatibility => 'সামঞ্জস্য';

  @override
  String get unifiedScoreLabel => 'সমন্বিত স্কোর';

  @override
  String get ashtakoot => 'অষ্টকূট';

  @override
  String get probability => 'সম্ভাবনা';

  @override
  String get hdrAshtakootSummary => 'অষ্টকূট সারাংশ';

  @override
  String get hdrGunBreakdown => '৮ গুণ বিশ্লেষণ';

  @override
  String get hdrMangalDosh => 'মঙ্গল দোষ';

  @override
  String get hdrD9CrossChart => 'D-9 ক্রস-চার্ট';

  @override
  String get d9Compatibility => 'D-9 সামঞ্জস্য';

  @override
  String get hdrDomainCompatibility => 'ক্ষেত্র সামঞ্জস্য';

  @override
  String get emotional => 'আবেগীয়';

  @override
  String get intellectual => 'বৌদ্ধিক';

  @override
  String get spiritual => 'আধ্যাত্মিক';

  @override
  String get financial => 'আর্থিক';

  @override
  String get domestic => 'গার্হস্থ্য';

  @override
  String get communicationWord => 'যোগাযোগ';

  @override
  String get sharedDharma => 'অভিন্ন ধর্ম';

  @override
  String get familyCreation => 'পরিবার গঠন';

  @override
  String get hdrMarriageTiming => 'বিবাহের সময়';

  @override
  String get jointMarriageWindows => 'যৌথ বিবাহের সময়';

  @override
  String get engagementWindows => 'বাগদানের সময়';

  @override
  String get recommendedLabel => 'প্রস্তাবিত';

  @override
  String get hdrKeyRisks => 'মূল ঝুঁকি';

  @override
  String get hdrFinalVerdict => 'চূড়ান্ত রায়';

  @override
  String get marriageVerdict => 'বিবাহ রায়';

  @override
  String get educationWord => 'শিক্ষা';

  @override
  String get learningSuffix => 'ও অধ্যয়ন';

  @override
  String get coreEducationScores => 'মূল শিক্ষা স্কোর';

  @override
  String get academicSuccess => 'একাডেমিক সাফল্য';

  @override
  String get learningCapacity => 'শেখার ক্ষমতা';

  @override
  String get memory => 'স্মৃতি';

  @override
  String get intelligence => 'বুদ্ধিমত্তা';

  @override
  String get research => 'গবেষণা';

  @override
  String get hdrIntellectualProfile => 'বৌদ্ধিক প্রোফাইল';

  @override
  String get learningSignature => 'শেখার স্বাক্ষর';

  @override
  String get hdrSubjectKaraka => 'বিষয় কারক';

  @override
  String get hdrHouseFoundations => 'ভাব ভিত্তি';

  @override
  String get hdrMercuryJupiter => 'বুধ ও বৃহস্পতি';

  @override
  String get hdrEducationYogas => 'শিক্ষা যোগ';

  @override
  String get hdrDivisionalValidation => 'বর্গ চার্ট যাচাই';

  @override
  String get standing => 'অবস্থান';

  @override
  String get hdrSubjectRanking => 'বিষয় ক্রমতালিকা';

  @override
  String get hdrDegreeLikelihood => 'ডিগ্রির সম্ভাবনা';

  @override
  String get hdrStudyPeriods => 'অধ্যয়নের সময়কাল';

  @override
  String get earlySchooling => 'প্রাথমিক শিক্ষা';

  @override
  String get higherEducation => 'উচ্চশিক্ষা';

  @override
  String get postgradResearch => 'স্নাতকোত্তর · গবেষণা';

  @override
  String get hdrLearningPreferences => 'শেখার পছন্দ';

  @override
  String get hdrChallengesGifts => 'চ্যালেঞ্জ ও উপহার';

  @override
  String get challenges => 'চ্যালেঞ্জ';

  @override
  String get cognitiveGifts => 'জ্ঞানীয় উপহার';

  @override
  String get naturalAbilities => 'স্বাভাবিক ক্ষমতা';

  @override
  String get hdrSaraswatiRemedies => 'সরস্বতী প্রতিকার';

  @override
  String get studentVerdict => 'ছাত্র রায়';

  @override
  String get educationCareerLinkage => 'শিক্ষা → কর্মজীবন সংযোগ';

  @override
  String get startupSuffix => 'ও স্টার্টআপ';

  @override
  String get coreBusinessScores => 'মূল ব্যবসা স্কোর';

  @override
  String get overallBusiness => 'সামগ্রিক ব্যবসা';

  @override
  String get ventureSuccess => 'উদ্যোগের সাফল্য';

  @override
  String get eleventhHouse => '১১তম ভাব';

  @override
  String get gains => 'লাভ';

  @override
  String get investor => 'বিনিয়োগকারী';

  @override
  String get hdrFounderArchetype => 'প্রতিষ্ঠাতা আর্কিটাইপ';

  @override
  String get hdrTenthEleventhHouses => '১০ম ও ১১তম ভাব';

  @override
  String get hdrBusinessYogas => 'ব্যবসা যোগ';

  @override
  String get hdrRecommendedDomains => 'প্রস্তাবিত ক্ষেত্র';

  @override
  String get hdrBusinessStyle => 'ব্যবসার ধরন';

  @override
  String get hdrFounderSkills => 'প্রতিষ্ঠাতা দক্ষতা';

  @override
  String get hdrFundingProfile => 'তহবিল প্রোফাইল';

  @override
  String get recommendedPath => 'প্রস্তাবিত পথ';

  @override
  String get investorAttract => 'বিনিয়োগকারী আকর্ষণ';

  @override
  String get familyBacking => 'পারিবারিক সমর্থন';

  @override
  String get hybridViability => 'হাইব্রিড কার্যকারিতা';

  @override
  String get launchWindow => 'সূচনার সময়';

  @override
  String get scaleWindow => 'সম্প্রসারণের সময়';

  @override
  String get hdrBusinessRisks => 'ব্যবসার ঝুঁকি';

  @override
  String get recoveryCapacity => 'পুনরুদ্ধার ক্ষমতা';

  @override
  String get hdrRemediesSolutions => 'প্রতিকার ও সমাধান';

  @override
  String get aiConnectionLost => 'সংযোগ বিচ্ছিন্ন। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get aiSomethingWrong => 'কিছু ভুল হয়েছে';

  @override
  String get aiNoResponse => 'কোনো উত্তর নেই';

  @override
  String get aiConnectionError => 'সংযোগ ত্রুটি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get aiAutoDetect => 'স্বয়ংক্রিয় সনাক্তকরণ';

  @override
  String aiAutoArrow(String lang) {
    return 'স্বয়ংক্রিয় → ${lang}';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'ভাষা: ${lang}';
  }

  @override
  String get aiNoBirthCharts => 'কোনো জন্মকুণ্ডলী পাওয়া যায়নি';

  @override
  String get aiCreateChartFirst => 'AI-এর সাথে চ্যাট করতে প্রথমে একটি জন্মকুণ্ডলী তৈরি করুন';

  @override
  String get aiSelectChartBegin => 'বিশ্লেষণ শুরু করতে একটি জন্মকুণ্ডলী নির্বাচন করুন';

  @override
  String aiAnalyzingName(String name) {
    return 'বিশ্লেষণ করা হচ্ছে: ${name}';
  }

  @override
  String get aiChange => 'পরিবর্তন';

  @override
  String get aiAnalyzingChart => 'আপনার চার্ট বিশ্লেষণ করা হচ্ছে...';

  @override
  String get aiAskStarsHint => 'তারাদের যা খুশি জিজ্ঞাসা করুন...';

  @override
  String get aiSuggestedFollowups => 'প্রস্তাবিত অনুসরণ';

  @override
  String get aiThinking => 'ভাবছে...';

  @override
  String get aiThanks => 'ধন্যবাদ!';

  @override
  String get aiFeedbackNoted => 'মতামত নথিভুক্ত';

  @override
  String get svcAll => 'সব';

  @override
  String get svcNoServices => 'কোনো পরিষেবা উপলব্ধ নেই';

  @override
  String get svcFree => 'বিনামূল্যে';

  @override
  String get astroFailedStartCall => 'কল শুরু করতে ব্যর্থ';

  @override
  String get astroFailedStartChat => 'চ্যাট শুরু করতে ব্যর্থ';

  @override
  String astroErrorDetail(String error) {
    return 'ত্রুটি: ${error}';
  }

  @override
  String get astroExperience => 'অভিজ্ঞতা';

  @override
  String get astroSessions => 'সেশন';

  @override
  String get astroMinutes => 'মিনিট';

  @override
  String get astroAbout => 'সম্পর্কে';

  @override
  String get astroLanguages => 'ভাষা';

  @override
  String get astroRateCard => 'রেট কার্ড';

  @override
  String get astroVoice => 'ভয়েস';

  @override
  String astroReviews(int count) {
    return 'রিভিউ (${count})';
  }

  @override
  String get astroNoReviews => 'এখনো কোনো রিভিউ নেই';

  @override
  String get astroAnonymous => 'নামহীন';

  @override
  String get forgotPasswordSubtitle => 'আপনার ইমেল লিখুন, আমরা আপনাকে পাসওয়ার্ড\nরিসেট করার একটি লিঙ্ক পাঠাব।';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => 'লিঙ্ক পুনরায় পাঠান';

  @override
  String get appName => 'নক্ষত্রলজি';

  @override
  String get cosmicJourneyAwaits => 'আপনার মহাজাগতিক যাত্রা অপেক্ষা করছে';

  @override
  String get home => 'হোম';

  @override
  String get astrologers => 'জ্যোতিষীরা';

  @override
  String get services => 'সেবা';

  @override
  String get wallet => 'ওয়ালেট';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get live => 'লাইভ';

  @override
  String get kundli => 'কুণ্ডলী';

  @override
  String get chat => 'চ্যাট';

  @override
  String get call => 'কল';

  @override
  String get video => 'ভিডিও';

  @override
  String get signIn => 'সাইন ইন';

  @override
  String get createAccount => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get email => 'ইমেইল';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get confirmPassword => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get fullName => 'পুরো নাম';

  @override
  String get phone => 'ফোন (ঐচ্ছিক)';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

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
  String get sendResetLink => 'রিসেট লিংক পাঠান';

  @override
  String get backToSignIn => 'সাইন ইন-এ ফিরে যান';

  @override
  String get dontHaveAccount => 'অ্যাকাউন্ট নেই?';

  @override
  String get alreadyHaveAccount => 'ইতিমধ্যে অ্যাকাউন্ট আছে?';

  @override
  String get continueGoogle => 'Google দিয়ে চালিয়ে যান';

  @override
  String get required => 'আবশ্যক';

  @override
  String get minSixChars => 'ন্যূনতম ৬টি অক্ষর';

  @override
  String get passwordsMismatch => 'পাসওয়ার্ড মিলছে না';

  @override
  String get validEmailRequired => 'বৈধ ইমেইল প্রয়োজন';

  @override
  String get loginFailed => 'লগইন ব্যর্থ';

  @override
  String get signupFailed => 'সাইনআপ ব্যর্থ';

  @override
  String get welcomeBack => 'আবার স্বাগতম';

  @override
  String get todaysHoroscope => 'আজকের রাশিফল';

  @override
  String get todaysRashi => 'আজকের রাশি';

  @override
  String get tapDetails => 'বিস্তারিত দেখতে ট্যাপ করুন';

  @override
  String get allServices => 'সকল সেবা';

  @override
  String get seeAll => 'সব দেখুন';

  @override
  String get topAstrologers => 'শীর্ষ জ্যোতিষীরা';

  @override
  String get onlineExperts => 'পরামর্শের জন্য অনলাইন বিশেষজ্ঞরা';

  @override
  String get searchAstrologers => 'জ্যোতিষী খুঁজুন...';

  @override
  String get noAstrologersFound => 'কোনো জ্যোতিষী পাওয়া যায়নি';

  @override
  String get online => 'অনলাইন';

  @override
  String get offline => 'অফলাইন';

  @override
  String get busy => 'ব্যস্ত';

  @override
  String get perMin => '/মিনিট';

  @override
  String get noCharts => 'এখনো কোনো জন্ম কুণ্ডলী নেই';

  @override
  String get createFirst => 'আপনার প্রথম জন্ম কুণ্ডলী তৈরি করুন';

  @override
  String get createChart => 'কুণ্ডলী তৈরি করুন';

  @override
  String get newBirthChart => 'নতুন জন্ম কুণ্ডলী';

  @override
  String get clientName => 'নাম';

  @override
  String get gender => 'লিঙ্গ';

  @override
  String get male => 'পুরুষ';

  @override
  String get female => 'মহিলা';

  @override
  String get other => 'অন্যান্য';

  @override
  String get dateOfBirth => 'জন্ম তারিখ';

  @override
  String get timeOfBirth => 'জন্ম সময়';

  @override
  String get birthPlace => 'জন্মস্থান';

  @override
  String get birthPlaceHint => 'শহরের নাম টাইপ করুন...';

  @override
  String get generateKundli => 'কুণ্ডলী তৈরি করুন';

  @override
  String get birthChartCreated => 'জন্ম কুণ্ডলী তৈরি হয়েছে!';

  @override
  String get deleteChart => 'কুণ্ডলী মুছবেন?';

  @override
  String get cannotUndo => 'এটি পূর্বাবস্থায় ফেরানো যাবে না।';

  @override
  String get primary => 'প্রাথমিক';

  @override
  String get viewKundli => 'কুণ্ডলী দেখুন';

  @override
  String get completeBirthChart => 'সম্পূর্ণ জন্ম কুণ্ডলী';

  @override
  String get birthDetails => 'জন্ম বিবরণ';

  @override
  String get name => 'নাম';

  @override
  String get dob => 'জন্ম তারিখ';

  @override
  String get tob => 'জন্ম সময়';

  @override
  String get place => 'স্থান';

  @override
  String get summary => 'সারসংক্ষেপ';

  @override
  String get planets => 'গ্রহসমূহ';

  @override
  String get divisions => 'বিভাগ';

  @override
  String get vimshottari => 'বিংশোত্তরী';

  @override
  String get moola => 'মূল';

  @override
  String get gochar => 'গোচর';

  @override
  String get dosh => 'দোষ';

  @override
  String get yoga => 'যোগ';

  @override
  String get shadbala => 'ষড়বল';

  @override
  String get ashtakavarga => 'অষ্টকবর্গ';

  @override
  String get aspects => 'দৃষ্টি';

  @override
  String get lifeAreas => 'জীবনের ক্ষেত্র';

  @override
  String get bhava => 'ভাব';

  @override
  String get chakras => 'চক্র';

  @override
  String get dashaActive => 'দশা সক্রিয়';

  @override
  String get lagna => 'লগ্ন';

  @override
  String get moon => 'চন্দ্র';

  @override
  String get sun => 'সূর্য';

  @override
  String get premiumSection => 'প্রিমিয়াম বিভাগ';

  @override
  String get unlockReading => 'বিস্তারিত বিশ্লেষণ দেখতে আনলক করুন।';

  @override
  String get unlock => 'আনলক';

  @override
  String get retrograde => 'বক্রী';

  @override
  String get combust => 'অস্ত';

  @override
  String get vargottama => 'বর্গোত্তম';

  @override
  String get exalted => 'উচ্চ';

  @override
  String get debilitated => 'নীচ';

  @override
  String get addBalance => 'ব্যালেন্স যোগ করুন';

  @override
  String get amount => 'পরিমাণ';

  @override
  String get walletBalance => 'ওয়ালেট ব্যালেন্স';

  @override
  String get recharge => 'রিচার্জ';

  @override
  String get bonus => 'বোনাস';

  @override
  String get serviceLabel => 'সেবা';

  @override
  String get refund => 'ফেরত';

  @override
  String get noTransactions => 'কোনো লেনদেন নেই';

  @override
  String get editProfile => 'প্রোফাইল সম্পাদনা';

  @override
  String get savedAstrologers => 'সংরক্ষিত জ্যোতিষীরা';

  @override
  String get noSavedAstrologers => 'এখনো কোনো সংরক্ষিত জ্যোতিষী নেই';

  @override
  String get myOrders => 'আমার অর্ডার';

  @override
  String get communicationHistory => 'যোগাযোগ ইতিহাস';

  @override
  String get chatHistory => 'চ্যাট ইতিহাস';

  @override
  String get callHistory => 'কল ইতিহাস';

  @override
  String get logout => 'লগআউট';

  @override
  String get chatMessages => 'চ্যাট বার্তা';

  @override
  String get typeMessage => 'বার্তা লিখুন...';

  @override
  String get sessionEnded => 'সেশন শেষ হয়েছে';

  @override
  String get endChat => 'চ্যাট শেষ করবেন?';

  @override
  String get endChatConfirm => 'আপনি কি নিশ্চিত যে এই চ্যাট সেশন শেষ করতে চান?';

  @override
  String get sendPhoto => 'ছবি পাঠান';

  @override
  String get sendPDF => 'PDF পাঠান';

  @override
  String get upload => 'আপলোড';

  @override
  String get fileNotFound => 'ফাইল পাওয়া যায়নি';

  @override
  String get voiceCall => 'ভয়েস কল';

  @override
  String get videoCall => 'ভিডিও কল';

  @override
  String get ringing => 'রিং হচ্ছে...';

  @override
  String get connected => 'সংযুক্ত';

  @override
  String get endCall => 'কল শেষ করুন';

  @override
  String get mute => 'মিউট';

  @override
  String get unmute => 'আনমিউট';

  @override
  String get speaker => 'স্পিকার';

  @override
  String get camera => 'ক্যামেরা';

  @override
  String get flip => 'ফ্লিপ';

  @override
  String get liveStreams => 'লাইভ স্ট্রিম';

  @override
  String get noLiveStreams => 'এই মুহূর্তে কোনো লাইভ স্ট্রিম নেই';

  @override
  String get astrologerUnavailable => 'জ্যোতিষী উপলব্ধ নেই। স্ট্রিম শেষ হচ্ছে।';

  @override
  String get streamEnded => 'স্ট্রিম শেষ হয়েছে';

  @override
  String get superChat => 'সুপার চ্যাট';

  @override
  String get sendGift => 'উপহার পাঠান';

  @override
  String get goBack => 'ফিরে যান';

  @override
  String get appPermissions => 'অ্যাপ অনুমতি';

  @override
  String get grantPermissions => 'অনুমতি দিন';

  @override
  String get skipForNow => 'এখন বাদ দিন';

  @override
  String get microphone => 'মাইক্রোফোন';

  @override
  String get notifications => 'বিজ্ঞপ্তি';

  @override
  String get storage => 'স্টোরেজ';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get cancel => 'বাতিল';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get delete => 'মুছুন';

  @override
  String get retry => 'পুনরায় চেষ্টা';

  @override
  String get send => 'পাঠান';

  @override
  String get refresh => 'রিফ্রেশ';

  @override
  String get loading => 'লোড হচ্ছে...';

  @override
  String get noData => 'কোনো তথ্য নেই';

  @override
  String get error => 'ত্রুটি';

  @override
  String get success => 'সফল';

  @override
  String get selectLanguage => 'ভাষা নির্বাচন করুন';

  @override
  String get language => 'ভাষা';

  @override
  String get english => 'ইংরেজি';

  @override
  String get myDetails => 'আমার বিবরণ';

  @override
  String get myKundlis => 'আমার কুণ্ডলী';

  @override
  String get walletRecharge => 'ওয়ালেট ও রিচার্জ';

  @override
  String get consultationHistory => 'পরামর্শ ইতিহাস';

  @override
  String get helpSupport => 'সাহায্য ও সহায়তা';

  @override
  String get biometricLogin => 'বায়োমেট্রিক লগইন';

  @override
  String get pastVoiceConsultations => 'আগের ভয়েস পরামর্শ';

  @override
  String get pastTextConversations => 'আগের টেক্সট কথোপকথন';

  @override
  String get comingSoon => 'শীঘ্রই আসছে';

  @override
  String get totalCredit => 'মোট ক্রেডিট';

  @override
  String get totalDebit => 'মোট ডেবিট';

  @override
  String get statement => 'স্টেটমেন্ট';

  @override
  String get allTypes => 'সব ধরনের';

  @override
  String get prev => 'আগের';

  @override
  String get next => 'পরের';

  @override
  String get allInsights => 'সমস্ত বিশ্লেষণ';

  @override
  String get yourCompleteReading => 'আপনার সম্পূর্ণ পঠন';

  @override
  String get expertEngines => 'বিশেষজ্ঞ ইঞ্জিন';

  @override
  String get eachInsightConsultation => 'প্রতিটি বিশ্লেষণ একটি সম্পূর্ণ পরামর্শ';

  @override
  String get engines => 'ইঞ্জিন';

  @override
  String get dataPoints => 'ডেটা পয়েন্ট';

  @override
  String get singleChart => 'সিঙ্গেল';

  @override
  String get careerPurpose => 'ক্যারিয়ার ও উদ্দেশ্য';

  @override
  String get wealthAssets => 'সম্পদ ও সম্পত্তি';

  @override
  String get loveRelationships => 'প্রেম ও সম্পর্ক';

  @override
  String get healthWellness => 'স্বাস্থ্য ও সুস্থতা';

  @override
  String get soulKarma => 'আত্মা ও কর্ম';

  @override
  String get specialistReports => 'বিশেষজ্ঞ প্রতিবেদন';

  @override
  String get searchByNameSpeciality => 'নাম, বিশেষত্ব দিয়ে খুঁজুন...';

  @override
  String get sortedByRating => 'রেটিং অনুযায়ী';

  @override
  String get initiatingChat => 'চ্যাট শুরু হচ্ছে...';

  @override
  String get startingCall => 'কল শুরু হচ্ছে...';

  @override
  String get yrs => 'বছর';

  @override
  String get chatWithAISpecialist => 'AI বিশেষজ্ঞের সাথে চ্যাট করুন';

  @override
  String get tapToStart => 'শুরু করতে ট্যাপ করুন';

  @override
  String get astrologer => 'জ্যোতিষী';

  @override
  String get reports => 'রিপোর্ট';

  @override
  String get milan => 'মিলন';

  @override
  String get forecast => 'পূর্বাভাস';

  @override
  String get rashi => 'রাশি';

  @override
  String get jupiterFavorsBold => 'বৃহস্পতি সাহসী পদক্ষেপে সহায়ক';

  @override
  String get careerIlluminated => 'আপনার ক্যারিয়ার ক্ষেত্র আলোকিত — আপনার অন্তর্দৃষ্টিতে বিশ্বাস রাখুন।';

  @override
  String get todaysForecast => 'আজকের পূর্বাভাস';

  @override
  String get engCareer => 'ক্যারিয়ার ও চাকরি';

  @override
  String get engBusiness => 'ব্যবসা ও স্টার্টআপ';

  @override
  String get engEducation => 'শিক্ষা ও পড়াশোনা';

  @override
  String get engLifePath => 'জীবন পথ ও ভাগ্য';

  @override
  String get engWealth => 'সম্পদ ও অর্থ';

  @override
  String get engDebt => 'ঋণ ও পুনরুদ্ধার';

  @override
  String get engProperty => 'সম্পত্তি ও আস্তি';

  @override
  String get engLegal => 'আইনি ও বিরোধ';

  @override
  String get engLove => 'প্রেম ও রোমান্স';

  @override
  String get engMarriage => 'বিবাহ ও পরিবার';

  @override
  String get engKundliMilan => 'কুণ্ডলী মিলন';

  @override
  String get engRelationship => 'সম্পর্ক বিশ্লেষণ';

  @override
  String get engLoveCompat => 'প্রেম সামঞ্জস্য';

  @override
  String get engChildProb => 'সন্তান সম্ভাবনা';

  @override
  String get engHealth => 'স্বাস্থ্য ও সুস্থতা';

  @override
  String get engMental => 'মানসিক ও চাপ';

  @override
  String get engCharacter => 'চরিত্র বিশ্লেষণ';

  @override
  String get engPastLife => 'পূর্বজন্ম ও কর্ম';

  @override
  String get engKarmaLink => 'কর্ম সংযোগ';

  @override
  String get noChatSessions => 'এখনও কোনো চ্যাট সেশন নেই';

  @override
  String get chatAppearHere => 'জ্যোতিষীদের সাথে আপনার কথোপকথন এখানে দেখা যাবে।';

  @override
  String get noCallsYet => 'এখনও কোনো কল নেই';

  @override
  String get callAppearHere => 'জ্যোতিষীদের সাথে আপনার কল ইতিহাস এখানে দেখা যাবে।';

  @override
  String get chatWith => 'এর সাথে চ্যাট';

  @override
  String get msgs => 'বার্তা';

  @override
  String get voiceCallLabel => 'ভয়েস কল';

  @override
  String get videoCallLabel => 'ভিডিও কল';

  @override
  String get pullToRefresh => 'রিফ্রেশ করতে নিচে টানুন';

  @override
  String get sessionExpired => 'সেশন শেষ';

  @override
  String get connectionFailed => 'সংযোগ ব্যর্থ';

  @override
  String get callActive => 'কল সক্রিয়';

  @override
  String get lessThanOneMin => '1 মিনিটেরও কম বাকি';

  @override
  String get noMessages => 'এই সেশনে কোনো বার্তা নেই';

  @override
  String get gocharForAllSigns => 'সমস্ত 12 রাশির আজকের গোচর';

  @override
  String get selectChart => 'বিশ্লেষণের জন্য কুণ্ডলী নির্বাচন করুন';

  @override
  String get selectTwoCharts => 'দুটি কুণ্ডলী নির্বাচন করুন';

  @override
  String get analyzing => 'বিশ্লেষণ চলছে...';

  @override
  String get browseAstrologers => 'জ্যোতিষী খুঁজুন';

  @override
  String get probableNumber => 'সম্ভাব্য সংখ্যা';

  @override
  String get genderTendency => 'লিঙ্গ প্রবণতা';

  @override
  String get son => 'পুত্র';

  @override
  String get daughter => 'কন্যা';

  @override
  String get occupants => 'অধিবাসী গ্রহ';

  @override
  String get beneficAspects => 'শুভ দৃষ্টি';

  @override
  String get maleficAspects => 'পাপ দৃষ্টি';

  @override
  String get nextFavorableWindow => 'পরবর্তী অনুকূল সময়';

  @override
  String get totalDoshaPenalty => 'মোট দোষ শাস্তি';

  @override
  String get cancellationFactors => 'বাতিল কারণ';

  @override
  String get combinedFertility => 'সম্মিলিত উর্বরতা সূচক';

  @override
  String get planetPositions => 'গ্রহ অবস্থান';

  @override
  String get bestWindows => 'সেরা সময়';

  @override
  String get worstWindows => 'প্রতিকূল সময়';

  @override
  String get scoreComponents => 'স্কোর উপাদান';

  @override
  String get topOpportunities => 'শীর্ষ সুযোগ';

  @override
  String get topRisks => 'শীর্ষ ঝুঁকি';

  @override
  String get remedies => 'প্রতিকার';

  @override
  String get keyInsights => 'মূল অন্তর্দৃষ্টি';

  @override
  String get overallVerdict => 'সামগ্রিক রায়';

  @override
  String get venusContacts => 'শুক্র সংযোগ';

  @override
  String get contact => 'সংযোগ';

  @override
  String get effect => 'প্রভাব';

  @override
  String get moonSignCompat => 'চন্দ্র রাশি সামঞ্জস্য';

  @override
  String get hisMoon => 'তার চন্দ্র';

  @override
  String get herMoon => 'তার চন্দ্র';

  @override
  String get nakshatraCompat => 'নক্ষত্র সামঞ্জস্য';

  @override
  String get ketuContacts => 'কেতু সংযোগ';

  @override
  String get rahuContacts => 'রাহু সংযোগ';

  @override
  String get pastLifeIndication => 'পূর্বজন্ম ইঙ্গিত';

  @override
  String get totalChallengePenalty => 'মোট চ্যালেঞ্জ শাস্তি';

  @override
  String get manifestation => 'প্রকাশ';

  @override
  String get cancellation => 'বাতিল';

  @override
  String get navigation => 'দিকনির্দেশনা';

  @override
  String get potentialStrengths => 'সম্ভাব্য শক্তি';

  @override
  String get areasToNurture => 'লালনপালনের ক্ষেত্র';

  @override
  String get relationshipGuidance => 'সম্পর্ক নির্দেশিকা';

  @override
  String get detailedSummary => 'বিস্তারিত সারাংশ';

  @override
  String get discussWithAI => 'AI এর সাথে আলোচনা';

  @override
  String get planet => 'গ্রহ';

  @override
  String get sign => 'রাশি';

  @override
  String get house => 'ভাব';

  @override
  String get strength => 'বল';

  @override
  String get copy => 'কপি';

  @override
  String get confidence => 'আত্মবিশ্বাস';

  @override
  String get d7Saptamsa => 'D7 সপ্তাংশ';

  @override
  String get numberExplanation => 'সংখ্যা ব্যাখ্যা';

  @override
  String get genderExplanation => 'লিঙ্গ ব্যাখ্যা';

  @override
  String get inFifth => '5ম এ?';

  @override
  String get primaryArchetype => 'প্রাথমিক আদর্শরূপ';

  @override
  String get mitigation => 'প্রশমন';

  @override
  String get soulCareerAlign => 'আত্মা ↔ ক্যারিয়ার সামঞ্জস্য';

  @override
  String get favorablePeriods => 'অনুকূল কাল';

  @override
  String get challengingPeriods => 'চ্যালেঞ্জিং কাল';

  @override
  String get keyHouses => 'প্রধান ভাব';

  @override
  String get keyPlanets => 'প্রধান গ্রহ';

  @override
  String get characterOverview => 'চরিত্র সংক্ষেপ';

  @override
  String get noYogasActive => 'এই কুণ্ডলীতে বর্তমানে কোনো যোগ সক্রিয় নেই।';

  @override
  String get basedOnPlanetStrengths => 'গ্রহ বল ও ভাব স্থানের ভিত্তিতে';

  @override
  String get basedOnTransits => 'বর্তমান গ্রহ গোচরের ভিত্তিতে';

  @override
  String get currentPlanetPositions => 'আপনার রাশিকে প্রথম ভাব ধরে বর্তমান গ্রহ অবস্থান';

  @override
  String get favorablePeriodAdvice => 'অনুকূল কাল — ক্যারিয়ার বৃদ্ধি ও সম্পর্কে মনোযোগ দিন।';

  @override
  String get noClassicalYogas => 'শাস্ত্রীয় বিদ্যা যোগ ছাড়া, সাফল্য ধারাবাহিক প্রচেষ্টায় আসে।';

  @override
  String get walletDeduction => 'পরিমাণ আপনার ওয়ালেট থেকে কাটা হবে';

  @override
  String get bhakootAxis => 'ভকূট অক্ষ';

  @override
  String get basis => 'ভিত্তি';

  @override
  String get selectChartsForMilan => 'মিলনের জন্য 2 কুণ্ডলী নির্বাচন করুন';

  @override
  String get selectMultiCharts => '2-5 কুণ্ডলী নির্বাচন করুন';

  @override
  String get running => 'চলমান';

  @override
  String get past => 'অতীত';

  @override
  String get topActiveDoshas => 'শীর্ষ সক্রিয় দোষ';

  @override
  String get allDoshas => 'সমস্ত দোষ';

  @override
  String get activeYogas => 'সক্রিয় যোগ';

  @override
  String get activeDoshas => 'সক্রিয় দোষ';

  @override
  String get yogaAnalysis => 'যোগ বিশ্লেষণ';

  @override
  String get factors => 'কারণ';

  @override
  String get dominantPlanet => 'প্রধান গ্রহ';

  @override
  String get startSession => 'সেশন শুরু করুন';

  @override
  String get notesSaved => 'নোট সংরক্ষিত';

  @override
  String get unlocked => 'আনলক! আপনার পড়া উপভোগ করুন।';

  @override
  String get todaysGochar => 'আজকের গোচর';

  @override
  String get todaysTransitChart => 'আজকের গোচর চার্ট';

  @override
  String get lifeAreaPredictions => 'জীবন ক্ষেত্র ভবিষ্যদ্বাণী';

  @override
  String get strengths => 'শক্তি';

  @override
  String get weaknesses => 'দুর্বলতা';

  @override
  String get ruledBy => 'অধিপতি';

  @override
  String get kundliMilan => 'কুণ্ডলী মিলন';

  @override
  String get startKundliMilan => 'কুণ্ডলী মিলন শুরু করুন';

  @override
  String get recommendations => 'সুপারিশ';

  @override
  String get cancellations => 'বাতিল';

  @override
  String get dashaSync => 'দশা সিঙ্ক';

  @override
  String get transitMarriageWindows => 'গোচর বিবাহ সময়';

  @override
  String get overlappingWindows => 'ওভারল্যাপিং বিবাহ সময়';

  @override
  String get overallStrength => 'সামগ্রিক শক্তি';

  @override
  String get stability => 'স্থিতিশীলতা';

  @override
  String get growth => 'বৃদ্ধি';

  @override
  String get clarity => 'স্পষ্টতা';

  @override
  String get recognition => 'স্বীকৃতি';

  @override
  String get satisfaction => 'সন্তুষ্টি';

  @override
  String get verdict => 'রায়';

  @override
  String get topRoles => 'শীর্ষ ভূমিকা';

  @override
  String get areasForGrowth => 'বৃদ্ধির ক্ষেত্র';

  @override
  String get bestIndustries => 'সেরা শিল্প';

  @override
  String get employment => 'চাকরি';

  @override
  String get entrepreneurship => 'উদ্যোক্তা';

  @override
  String get freelance => 'ফ্রিল্যান্স';

  @override
  String get portfolio => 'পোর্টফোলিও';

  @override
  String get burnoutRisk => 'অবসাদ ঝুঁকি';

  @override
  String get careerStagnation => 'পেশা স্থবিরতা';

  @override
  String get workplaceConflict => 'কর্মস্থল সংঘাত';

  @override
  String get positioning => 'অবস্থান নির্ধারণ';

  @override
  String get skillDevelopment => 'দক্ষতা উন্নয়ন';

  @override
  String get network => 'নেটওয়ার্ক';

  @override
  String get visibility => 'দৃশ্যমানতা';

  @override
  String get lagnaLord => 'লগ্ন স্বামী';

  @override
  String get tenthLord => 'দশম স্বামী';

  @override
  String get lord => 'স্বামী';

  @override
  String get lordPlacedIn => 'স্বামী স্থিত';

  @override
  String get lordDignity => 'স্বামী মর্যাদা';

  @override
  String get d9Dignity => 'ডি9 মর্যাদা';

  @override
  String get careerAnalysis => 'ক্যারিয়ার বিশ্লেষণ';

  @override
  String get launchWindows => 'শুরুর সময়';

  @override
  String get peakWindows => 'শীর্ষ সময়';

  @override
  String get promotionWindows => 'পদোন্নতি সময়';

  @override
  String get riskWindows => 'ঝুঁকি সময়';

  @override
  String get timingWindows => 'সময় উইন্ডো';

  @override
  String get careerRisks => 'পেশা ঝুঁকি';

  @override
  String get astrologicalRemedies => 'জ্যোতিষ প্রতিকার';

  @override
  String get practicalSolutions => 'ব্যবহারিক সমাধান';

  @override
  String get analysisConfidence => 'বিশ্লেষণ বিশ্বাসযোগ্যতা';

  @override
  String get careerArchetype => 'পেশা আদর্শরূপ';

  @override
  String get workStructure => 'কাজের কাঠামো';

  @override
  String get teamLeadership => 'দল নেতৃত্ব';

  @override
  String get idealEnvironment => 'আদর্শ পরিবেশ';

  @override
  String get idealOrgSize => 'আদর্শ সংস্থা আকার';

  @override
  String get fitScore => 'ফিট স্কোর';

  @override
  String get recommended => 'সুপারিশকৃত';

  @override
  String get divisionalValidation => 'বিভাগীয় যাচাইকরণ';

  @override
  String get houseAnalysis => 'ভাব বিশ্লেষণ';

  @override
  String get jaiminiKarakas => 'জৈমিনি কারক';

  @override
  String get copyFullReport => 'সম্পূর্ণ রিপোর্ট কপি করুন';

  @override
  String get reportCopied => 'রিপোর্ট কপি হয়েছে!';
}
