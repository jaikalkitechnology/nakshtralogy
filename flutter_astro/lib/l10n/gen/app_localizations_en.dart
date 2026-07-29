// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Nakshatralogy Astro';

  @override
  String get astrologerPanel => 'Astrologer Panel';

  @override
  String get home => 'Home';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get charts => 'Charts';

  @override
  String get bookings => 'Bookings';

  @override
  String get requests => 'Requests';

  @override
  String get chats => 'Chats';

  @override
  String get earnings => 'Earnings';

  @override
  String get profile => 'Profile';

  @override
  String get live => 'Live';

  @override
  String get signIn => 'Sign In';

  @override
  String get createAccount => 'Create Account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get phone => 'Phone (optional)';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get rzTodayOutlook => 'Today\'s Zodiac Outlook';

  @override
  String get rzPlanetaryEnergy => 'Today\'s Planetary Energy';

  @override
  String get rzBestSign => 'Best Sign';

  @override
  String get rzChallengingSign => 'Most Challenging';

  @override
  String get rzDominantPlanet => 'Dominant Planet';

  @override
  String get rzOverallMood => 'Overall Mood';

  @override
  String get rzMoodBright => 'Bright & Active';

  @override
  String get rzMoodCalm => 'Calm & Steady';

  @override
  String get rzMoodMixed => 'Mixed Energy';

  @override
  String get rzMoodTense => 'Tense & Careful';

  @override
  String get rzTodayEnergy => 'Today\'s Energy';

  @override
  String get rzCaution => 'Caution';

  @override
  String get rzWeak => 'Weak';

  @override
  String get rzAllSigns => 'All Zodiac Signs';

  @override
  String get rzAiSummary => 'AI Summary';

  @override
  String get rzPlanetaryInfluence => 'Today\'s Planetary Influence';

  @override
  String get rzStrongInfluences => 'Strong Influences';

  @override
  String get rzShowTechnical => 'Show technical details';

  @override
  String get rzOpportunities => 'Today\'s Opportunities';

  @override
  String get rzAvoidTitle => 'Things To Avoid Today';

  @override
  String get rzTechnicalReason => 'Technical reason';

  @override
  String get rzAvoidDecisions => 'Rushing important decisions';

  @override
  String get rzAvoidArguments => 'Heated arguments';

  @override
  String get rzAvoidInvestments => 'Large investments';

  @override
  String get rzAvoidOverthink => 'Overthinking small issues';

  @override
  String get rzAvoidOverspend => 'Unnecessary spending';

  @override
  String get rzAvoidStress => 'Stress and overworking';

  @override
  String get rzPlanetaryChart => 'Today\'s Planetary Chart';

  @override
  String get rzWhatChartMeans => 'What this chart means';

  @override
  String get rzChartExplain => 'This diamond shows where each planet is sitting in the sky today, mapped to your sign. Planets in supportive houses lift the day; those in tough houses ask for care.';

  @override
  String get rzDoNetworking => 'Networking & connecting';

  @override
  String get rzDoLearning => 'Learning something new';

  @override
  String get rzDoMeditation => 'Meditation & calm';

  @override
  String get rzDoFamily => 'Family time';

  @override
  String get rzDoCreative => 'Creative work';

  @override
  String get rzDoRest => 'Rest & self-care';

  @override
  String get rzAiRecommendations => 'Today\'s AI Recommendations';

  @override
  String get rzTechnical => 'Technical Astrology';

  @override
  String get rzTransitScore => 'Transit Score';

  @override
  String get rzVedha => 'Vedha (Obstructions)';

  @override
  String get rzGocharDetails => 'Gochar Details';

  @override
  String get rzAdvancedOnly => 'For advanced users';

  @override
  String get rzTomorrow => 'Tomorrow Preview';

  @override
  String get rzTomorrowEnergy => 'Tomorrow\'s Energy';

  @override
  String get rzImproving => 'Improving';

  @override
  String get rzWeaker => 'Slightly Weaker';

  @override
  String get rzSteady => 'Steady';

  @override
  String get rzTomorrowUpLine => 'Energy is expected to rise tomorrow — plan ahead for important tasks.';

  @override
  String get rzTomorrowDownLine => 'Energy may dip a little tomorrow — keep the day light and steady.';

  @override
  String get rzTomorrowFlatLine => 'Energy stays steady tomorrow — a calm, balanced day ahead.';

  @override
  String get rzWeeklyTrend => 'Weekly Trend';

  @override
  String get rzMonthlyTrend => 'Monthly Trend';

  @override
  String get rzBestDayWeek => 'Best Day';

  @override
  String get rzHardestDay => 'Toughest Day';

  @override
  String get rzLuckyToday => 'Lucky Today';

  @override
  String get rzKarakaSun => 'confidence & vitality';

  @override
  String get rzKarakaMoon => 'emotions & peace of mind';

  @override
  String get rzKarakaMars => 'energy & drive';

  @override
  String get rzKarakaMercury => 'communication & learning';

  @override
  String get rzKarakaJupiter => 'wisdom & growth';

  @override
  String get rzKarakaVenus => 'relationships & comfort';

  @override
  String get rzKarakaSaturn => 'discipline & patience';

  @override
  String get rzKarakaRahu => 'ambition & change';

  @override
  String get rzKarakaKetu => 'spirituality & letting go';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '${dom} sets the tone of the day, while ${chal} asks for patience and care.';
  }

  @override
  String rzInsightGood(Object karaka) {
    return 'Good day for ${karaka}.';
  }

  @override
  String rzInsightHard(Object karaka) {
    return 'Take it slow with ${karaka} today.';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return '${karaka} is well supported today.';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return '${karaka} may face delays today.';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return 'Today supports ${strong}, while ${weak} needs patience and care.';
  }

  @override
  String get fdEnergyScore => 'Today\'s Energy Score';

  @override
  String get fdStatusAverage => 'Average';

  @override
  String get fdStatusMixed => 'Mixed';

  @override
  String get fdStatusChallenging => 'Challenging';

  @override
  String get fdTheme => 'Today\'s Theme';

  @override
  String get fdExplainToday => 'Explain Today';

  @override
  String get fdTodaysFocus => 'Today\'s Focus';

  @override
  String get fdTopRecommendation => 'Top Recommendation';

  @override
  String get fdTopCaution => 'Top Caution';

  @override
  String get fdReadingTime => 'Reading time';

  @override
  String get fdSeconds30 => '30 sec';

  @override
  String get fdCareer => 'Career';

  @override
  String get fdMoney => 'Money';

  @override
  String get fdLove => 'Love';

  @override
  String get fdHealth => 'Health';

  @override
  String get fdTravel => 'Travel';

  @override
  String get fdFamily => 'Family';

  @override
  String get fdBestToDo => 'Best Things To Do Today';

  @override
  String get fdAvoidToday => 'Avoid Today';

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
  String get fdRecommendation => 'Recommendation';

  @override
  String get fdNoActions => 'Nothing major to push today — keep a steady, calm routine.';

  @override
  String get fdNoCautions => 'No major cautions today — proceed with normal awareness.';

  @override
  String get fdHighlights => 'Today\'s Highlights';

  @override
  String get fdProbVeryHigh => 'Very High';

  @override
  String get fdProbHigh => 'High';

  @override
  String get fdProbElevated => 'Elevated';

  @override
  String get fdProbCaution => 'Caution';

  @override
  String get fdWhatToDo => 'What to do';

  @override
  String get fdLifeAreas => 'Life Areas';

  @override
  String get fdTapDetails => 'Tap for details';

  @override
  String get fdArea1 => 'Self & Health';

  @override
  String get fdArea2 => 'Wealth & Family';

  @override
  String get fdArea3 => 'Communication';

  @override
  String get fdArea4 => 'Home & Comfort';

  @override
  String get fdArea5 => 'Creativity & Romance';

  @override
  String get fdArea6 => 'Work & Duties';

  @override
  String get fdArea7 => 'Relationships';

  @override
  String get fdArea8 => 'Change & Depth';

  @override
  String get fdArea9 => 'Luck & Travel';

  @override
  String get fdArea10 => 'Career & Status';

  @override
  String get fdArea11 => 'Gains & Network';

  @override
  String get fdArea12 => 'Rest & Spirituality';

  @override
  String get fdTodaysMeaning => 'Today\'s Meaning';

  @override
  String get fdGoodFor => 'Good For';

  @override
  String get fdAvoid => 'Avoid';

  @override
  String get fdPlanetSupport => 'Planet Support';

  @override
  String get fdWhyPrediction => 'Why this prediction?';

  @override
  String get fdAdvancedDetails => 'Advanced Details';

  @override
  String get fdAiRecommendation => 'AI Recommendation';

  @override
  String get fdOverallStatus => 'Overall Status';

  @override
  String get fdNoPlanetTransit => 'No major planet is transiting this area today.';

  @override
  String get fdFinancialOutlook => 'Financial Outlook';

  @override
  String get fdIncomeProbability => 'Income Probability';

  @override
  String get fdExpenseProbability => 'Expense Probability';

  @override
  String get fdNetBalance => 'Net Financial Balance';

  @override
  String get fdAvoidSpending => 'Avoid Spending';

  @override
  String get fdRelationshipOutlook => 'Relationship Outlook';

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
  String get fdWeakArea => 'Weak Area';

  @override
  String get fdBiggestOpportunity => 'Biggest Opportunity';

  @override
  String get fdBiggestRisk => 'Biggest Risk';

  @override
  String get fdProbability => 'Probability';

  @override
  String get fdProtection => 'Protection Advice';

  @override
  String get fdDescription => 'Description';

  @override
  String get fdBestTimeToday => 'Best Time Today';

  @override
  String get fdAvoidDuring => 'Avoid During';

  @override
  String get fdPredictionConfidence => 'Prediction Confidence';

  @override
  String get fdConfBasis => 'Today\'s prediction combines';

  @override
  String get fdConfNatal => 'Birth Chart';

  @override
  String get fdConfTransit => 'Current Transit';

  @override
  String get fdConfDasha => 'Planetary Periods';

  @override
  String get fdConfStrength => 'Planet Strength';

  @override
  String get fdConfHouse => 'House Activation';

  @override
  String get fdAskAi => 'Ask AI';

  @override
  String get fdAskAiSub => 'Tap a question to get today\'s answer';

  @override
  String get fdQ1 => 'Why is career slow today?';

  @override
  String get fdQ2 => 'What is the best time today?';

  @override
  String get fdQ3 => 'Is today good for money matters?';

  @override
  String get fdQ4 => 'Is today good for travel?';

  @override
  String get fdQ5 => 'What should I avoid today?';

  @override
  String get fdMoreSuggestions => 'More Suggestions';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return 'Today is best suited for ${top}. ${weak} may feel slow, so avoid major decisions there. Financially the day looks ${fin}.';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return 'Your energy today gathers around ${top} — lean into it and go gently elsewhere.';
  }

  @override
  String get gochToday => 'Today';

  @override
  String get gochOverallScore => 'Overall Transit Score';

  @override
  String get gochNeutral => 'Neutral';

  @override
  String get gochChallenging => 'Challenging';

  @override
  String get gochTopPositive => 'Top Positive';

  @override
  String get gochTopChallenges => 'Top Challenges';

  @override
  String get gochFilterAll => 'All';

  @override
  String get gochFavorability => 'Favorability';

  @override
  String get gochAlerts => 'Transit Alerts';

  @override
  String get gochAlertCritical => 'Critical';

  @override
  String get gochAlertWarning => 'Caution';

  @override
  String get gochAlertOpportunity => 'Opportunity';

  @override
  String get gochAiFocus => 'AI Focus Today';

  @override
  String get gochLifeScores => 'Life Area Scores';

  @override
  String get gochWhy => 'Why?';

  @override
  String get gochCurrentTransits => 'Active Transits';

  @override
  String get gochDailyPlan => 'Your Daily Plan';

  @override
  String get gochMorning => 'Morning';

  @override
  String get gochAfternoon => 'Afternoon';

  @override
  String get gochEvening => 'Evening';

  @override
  String get gochNight => 'Night';

  @override
  String get gochSmartReco => 'Smart Recommendations';

  @override
  String get gochExplain => 'Explain Today\'s Transit';

  @override
  String get gochDo => 'Do';

  @override
  String get gochDont => 'Avoid';

  @override
  String get gochDoWork => 'Tackle important work';

  @override
  String get gochDoMeditate => 'Meditate and reflect';

  @override
  String get gochDoStart => 'Start new plans';

  @override
  String get gochDoFinish => 'Finish pending tasks';

  @override
  String get gochDontArgue => 'Avoid arguments';

  @override
  String get gochDontImpulsive => 'Avoid impulsive decisions';

  @override
  String get gochDontOverspend => 'Avoid overspending';

  @override
  String gochThemeGrowth(Object area) {
    return 'A day of growth in ${area} — lean into it.';
  }

  @override
  String gochThemeChallenge(Object area) {
    return 'Stay patient with ${area} today — go steady.';
  }

  @override
  String gochPosLine(Object area) {
    return '${area} is well supported right now.';
  }

  @override
  String gochChalLine(Object area) {
    return '${area} needs extra care today.';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return 'Put your energy into ${a1} today, and be gentle with ${a2}.';
  }

  @override
  String get divBeginner => 'Beginner';

  @override
  String get divSearchHint => 'Search: career, marriage, education…';

  @override
  String get divSummaryTitle => 'Divisional Chart Summary';

  @override
  String get divTotalCharts => 'Total Charts';

  @override
  String get divMostImportant => 'Most Important';

  @override
  String get divRecommendedForYou => 'Recommended For You';

  @override
  String get divCatEssential => 'Essential Charts';

  @override
  String get divCatPersonal => 'Personal Life';

  @override
  String get divCatKnowledge => 'Knowledge Charts';

  @override
  String get divCatAdvanced => 'Advanced Charts';

  @override
  String get divGoalProperty => 'Property';

  @override
  String get divGoalKarma => 'Karma';

  @override
  String get divBadgeHighlyRec => 'Highly Recommended';

  @override
  String get divBadgeRec => 'Recommended';

  @override
  String get divBadgeUseful => 'Useful';

  @override
  String get divBadgeOptional => 'Optional';

  @override
  String get divBadgeAdvOnly => 'Advanced Only';

  @override
  String get divRecommendBest => 'Recommend Best Charts';

  @override
  String get divNoMatch => 'No charts match your search';

  @override
  String get divLifeAreas => 'Life Areas';

  @override
  String divAiUse(Object purpose) {
    return 'Use this chart to analyse ${purpose}.';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return 'Your ${c1} and ${c2} charts are especially important — start there for the areas they cover, then explore the rest as needed.';
  }

  @override
  String divRecReasonHouse(Object house) {
    return 'Your ${house} house needs a closer look — this chart shows it in depth.';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '${planet} is a key but tested planet — this chart reveals its deeper condition.';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return 'You are in ${planet}\'s Mahadasha, so this chart is especially timely now.';
  }

  @override
  String divRecSummary(Object c1) {
    return 'Based on your chart, ${c1} should be your highest priority. The charts below are ordered by how relevant they are for you right now.';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return 'Open this chart when you want to study ${purpose}.';
  }

  @override
  String get divD1Name => 'Rasi (D-1)';

  @override
  String get divD1Desc => 'Physical existence, all matters';

  @override
  String get divD2Name => 'Hora (D-2)';

  @override
  String get divD2Desc => 'Wealth, money';

  @override
  String get divD3Name => 'Drekkana (D-3)';

  @override
  String get divD3Desc => 'Siblings, courage';

  @override
  String get divD4Name => 'Chaturthamsa (D-4)';

  @override
  String get divD4Desc => 'Property, residence, fortune';

  @override
  String get divD5Name => 'Panchamsa (D-5)';

  @override
  String get divD5Desc => 'Fame, authority, power';

  @override
  String get divD6Name => 'Shashthamsa (D-6)';

  @override
  String get divD6Desc => 'Health troubles';

  @override
  String get divD7Name => 'Saptamsa (D-7)';

  @override
  String get divD7Desc => 'Children, grandchildren';

  @override
  String get divD8Name => 'Ashtamsa (D-8)';

  @override
  String get divD8Desc => 'Sudden troubles, litigation';

  @override
  String get divD9Name => 'Navamsha (D-9)';

  @override
  String get divD9Desc => 'Marriage, spouse, dharma';

  @override
  String get divD10Name => 'Dasamsha (D-10)';

  @override
  String get divD10Desc => 'Career, profession';

  @override
  String get divD11Name => 'Rudramsha (D-11)';

  @override
  String get divD11Desc => 'Death, destruction';

  @override
  String get divD12Name => 'Dwadasamsha (D-12)';

  @override
  String get divD12Desc => 'Parents, blood-relatives';

  @override
  String get divD16Name => 'Shodasamsha (D-16)';

  @override
  String get divD16Desc => 'Vehicles, comforts, pleasures';

  @override
  String get divD20Name => 'Vimsamsha (D-20)';

  @override
  String get divD20Desc => 'Spiritual matters, religious';

  @override
  String get divD24Name => 'Chaturvimsamsha (D-24)';

  @override
  String get divD24Desc => 'Learning, knowledge, education';

  @override
  String get divD27Name => 'Nakshatramsha (D-27)';

  @override
  String get divD27Desc => 'Strengths, weaknesses, nature';

  @override
  String get divD30Name => 'Trimsamsha (D-30)';

  @override
  String get divD30Desc => 'Evils, sub-conscious, punishment';

  @override
  String get divD40Name => 'Khavedamsha (D-40)';

  @override
  String get divD40Desc => 'Auspicious/inauspicious (maternal)';

  @override
  String get divD45Name => 'Akshavedamsha (D-45)';

  @override
  String get divD45Desc => 'All matters (paternal)';

  @override
  String get divD60Name => 'Shashtyamsha (D-60)';

  @override
  String get divD60Desc => 'Past-life karma — MOST IMPORTANT';

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
  String get sbSummary => 'Planetary Strength Summary';

  @override
  String get sbAverageStrength => 'Average Strength';

  @override
  String get sbHighestRupa => 'Highest Rupa';

  @override
  String get sbRupa => 'Rupa';

  @override
  String get sbRanking => 'Planet Ranking';

  @override
  String get sbRequired => 'Required';

  @override
  String get sbExcess => 'Excess';

  @override
  String get sbDeficit => 'Deficit';

  @override
  String get sbTotalShadbala => 'Total Shadbala';

  @override
  String get sbExplain => 'Explain My Planetary Strength';

  @override
  String get sbExplainSubtitle => 'A simple summary of your planets\' strength';

  @override
  String get sbInfoTitle => 'Understanding Shadbala';

  @override
  String get sbQWhatIs => 'What is Shadbala?';

  @override
  String get sbQRupas => 'What are Rupas?';

  @override
  String get sbQHowCalc => 'How is strength calculated?';

  @override
  String get sbQHowUse => 'How to use this';

  @override
  String get sbWhyStrong => 'Why Strong';

  @override
  String get sbWhyWeak => 'Why Weak';

  @override
  String get sbDuringMahadasha => 'During Mahadasha';

  @override
  String get sbEffects => 'Effects';

  @override
  String get sbLifeAreas => 'Life Areas';

  @override
  String get sbPlanetDetails => 'Planet Details';

  @override
  String get sbBodyWhatIs => 'Shadbala (\'six-fold strength\') measures how much power each planet has to deliver its results, by adding six independent sources of strength.';

  @override
  String get sbBodyRupas => 'Strength is measured in Rupas (1 Rupa = 60 Virupas). Each planet needs a minimum Rupa strength to count as strong; more Rupas means it delivers its results more fully.';

  @override
  String get sbBodyHowCalc => 'Six balas are added: Sthana (positional), Dig (directional), Kala (temporal), Chesta (motional), Naisargika (natural) and Drik (aspectual). The total is compared with the planet\'s required minimum to get a percentage.';

  @override
  String get sbBodyHowUse => 'A planet above 100% comfortably delivers its significations; below 100% it needs support. Favour your strongest planets for important matters, and give the weakest ones remedies and patience.';

  @override
  String get sbRemedyStrong => 'Well-supported — no special remedy needed; you can use this planet\'s periods confidently.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '${strongP} is your strongest planet, giving excellent support for ${strongTrait}. ${weakP} is the weakest and benefits most from remedies.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '${planet} has ${category} Shadbala, so its ${karakatva} are supported accordingly.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return 'Strongest through ${bala} (${rupa} rupas).';
  }

  @override
  String sbWeakLine(Object bala) {
    return 'Weakest in ${bala}, which lowers the total.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return 'During ${planet}\'s Mahadasha, its ${karak} come to the fore.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'With strong Shadbala, ${karak} are naturally supported.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'With modest Shadbala, ${karak} may need conscious effort.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return 'Strengthen ${planet} through its mantra, gemstone or charity, and act patiently during its periods.';
  }

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
  String get kunNavamsa => 'Navamsa (D9)';

  @override
  String get kunD10 => 'Dasamsa (D10)';

  @override
  String get kunPlacement => 'Planet Placement';

  @override
  String get kunHousesTitle => 'House Details';

  @override
  String get kunPlanet => 'Planet';

  @override
  String get kunNakshatra => 'Nakshatra';

  @override
  String get kunPada => 'Pada';

  @override
  String get kunLord => 'Lord';

  @override
  String get kunExplain => 'Explain My Chart';

  @override
  String get kunExplainSubtitle => 'A simple summary of your chart';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return 'The ${ordinal} house governs ${meaning}.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return '${planets} placed here shape its results.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'Your ascendant is ${asc}, shaping your outlook and how others first see you.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'Your mind and emotions follow the Moon in ${moon}.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '${planet} is your strongest planet — a natural area of ease and support.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '${planet} is your most tested planet — patience and effort pay off here.';
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
    return 'Nak: ${nakshatra} (${pada})';
  }

  @override
  String planetNakLord(Object lord) {
    return 'NL: ${lord}';
  }

  @override
  String planetLongitude(Object value) {
    return 'Lon: ${value}°';
  }

  @override
  String get sumVeryStrong => 'Very Strong';

  @override
  String get sumStrong => 'Strong';

  @override
  String get sumAverage => 'Average';

  @override
  String get sumWeak => 'Weak';

  @override
  String get sumNeedsAttention => 'Needs Attention';

  @override
  String get sumFire => 'Fire';

  @override
  String get sumEarth => 'Earth';

  @override
  String get sumAir => 'Air';

  @override
  String get sumWater => 'Water';

  @override
  String get sumMovable => 'Movable';

  @override
  String get sumFixed => 'Fixed';

  @override
  String get sumDual => 'Dual';

  @override
  String get sumDirEast => 'East';

  @override
  String get sumDirWest => 'West';

  @override
  String get sumDirNorth => 'North';

  @override
  String get sumDirSouth => 'South';

  @override
  String get sumDirNE => 'North-East';

  @override
  String get sumDirNW => 'North-West';

  @override
  String get sumDirSE => 'South-East';

  @override
  String get sumDirSW => 'South-West';

  @override
  String get sumSnapshotTitle => 'Your Astrology Snapshot';

  @override
  String get sumMahadasha => 'Mahadasha';

  @override
  String get sumAntardasha => 'Antardasha';

  @override
  String get sumNakshatra => 'Janma Nakshatra';

  @override
  String get sumElement => 'Element';

  @override
  String get sumModality => 'Modality';

  @override
  String get sumLuckyDirection => 'Lucky Direction';

  @override
  String get sumHighlights => 'Important Highlights';

  @override
  String get sumStrongPlanet => 'Strongest Planet';

  @override
  String get sumWeakPlanet => 'Weakest Planet';

  @override
  String get sumYogas => 'Yogas';

  @override
  String get sumDoshas => 'Doshas';

  @override
  String get sumRetrograde => 'Retrograde';

  @override
  String get sumCombust => 'Combust';

  @override
  String get sumExalted => 'Exalted';

  @override
  String get sumDebilitated => 'Debilitated';

  @override
  String get sumVargottama => 'Vargottama';

  @override
  String get sumQuickInsights => 'Quick Insights';

  @override
  String get sumSpirituality => 'Spirituality';

  @override
  String get sumTimezone => 'Timezone';

  @override
  String get sumAyanamsa => 'Ayanamsa';

  @override
  String get sumCalendarType => 'Calendar';

  @override
  String get sumCopied => 'Copied to clipboard';

  @override
  String get sumNatureFire => 'You have a bold, energetic and pioneering nature that leads from the front.';

  @override
  String get sumNatureEarth => 'You have a practical, grounded and disciplined nature that builds lasting results.';

  @override
  String get sumNatureAir => 'You have a curious, communicative and intellectual nature that thrives on new ideas.';

  @override
  String get sumNatureWater => 'You have an intuitive, emotional and empathetic nature with deep inner sensitivity.';

  @override
  String get sumGradePhraseExcellent => 'Strongly supported — favourable results are likely with steady effort.';

  @override
  String get sumGradePhraseGood => 'Well supported — generally positive with a little care.';

  @override
  String get sumGradePhraseAverage => 'Mixed support — results depend on effort and timing.';

  @override
  String get sumGradePhraseWeak => 'Needs attention — patience and remedies help here.';

  @override
  String get kDefCombust => 'A planet too close to the Sun, so its energy is \'burnt\' and weakened.';

  @override
  String get kDefRetrograde => 'A planet that appears to move backwards; its effects turn inward and intensify.';

  @override
  String get kDefNakshatra => 'One of the 27 lunar mansions that the Moon and planets travel through.';

  @override
  String get kDefVargottama => 'A planet in the same sign in both the birth chart (D1) and the navamsa (D9) — a mark of strength.';

  @override
  String get kDefOwnSign => 'A planet sitting in a sign it rules, where it feels at home and gives steady results.';

  @override
  String get kDefExalted => 'A planet in its sign of highest strength, giving its very best results.';

  @override
  String get kDefDebilitated => 'A planet in its weakest sign, where it struggles to give results.';

  @override
  String get kDefMooltrikona => 'A special portion of a planet\'s own sign where it is especially powerful.';

  @override
  String get kDefAscendant => 'The sign rising on the eastern horizon at birth — the Lagna, the foundation of the chart.';

  @override
  String get kDefMahadasha => 'The major planetary period that colours a long span of life.';

  @override
  String get kDefAntardasha => 'A sub-period within a Mahadasha that fine-tunes its results.';

  @override
  String get kDefPada => 'One of the four quarters of a nakshatra that a planet occupies.';

  @override
  String get kundliAscendantLagna => 'Ascendant (Lagna)';

  @override
  String get kundliMoonSignRashi => 'Moon Sign (Rashi)';

  @override
  String get kundliSunSign => 'Sun Sign';

  @override
  String get aspGivesAspectTo => 'Gives Aspect To';

  @override
  String get aspReceivesAspectFrom => 'Receives Aspect From';

  @override
  String get aspInfluences => 'Influences';

  @override
  String get aspNoInfluence => 'No Influence';

  @override
  String get aspNoAspect => 'No Aspect';

  @override
  String get aspPresent => 'Present';

  @override
  String get aspAbsent => 'Absent';

  @override
  String get aspNotPresent => 'Not Present';

  @override
  String get aspSpecialAspect => 'Special Aspect';

  @override
  String get aspAspectWord => 'Aspect';

  @override
  String get aspTotalGiven => 'Aspects Given';

  @override
  String get aspTotalReceived => 'Aspects Received';

  @override
  String get aspStrongestInfluence => 'Strongest Influence';

  @override
  String get aspMedium => 'Medium';

  @override
  String get aspAspectPresent => 'Aspect Present';

  @override
  String get aspReason => 'Reason';

  @override
  String get aspBoth => 'Both';

  @override
  String get aspTargetHouse => 'Target House';

  @override
  String get aspTargetSign => 'Target Sign';

  @override
  String get aspLagnaReceives => 'Lagna Receives Aspect From';

  @override
  String get aspNoAspectFrom => 'No Aspect From';

  @override
  String get aspPlanetToPlanet => 'Planet to Planet';

  @override
  String get aspSignToSign => 'Sign to Sign';

  @override
  String get aspCombinedAspect => 'Combined Aspect';

  @override
  String get aspGrahaAspect => 'Graha Aspect';

  @override
  String get aspRashiAspect => 'Rashi Aspect';

  @override
  String get aspInfoTitle => 'Understanding Aspects (Drishti)';

  @override
  String get aspQGraha => 'What is Graha Drishti?';

  @override
  String get aspQRashi => 'What is Rashi Drishti?';

  @override
  String get aspQDiff => 'Difference between the two';

  @override
  String get aspQPredict => 'How aspects affect prediction';

  @override
  String get aspGrahaBody => 'Graha Drishti is the aspect a planet casts from its position. Every planet fully aspects the 7th house/planet from itself (a direct, face-to-face influence). In addition, Mars aspects the 4th and 8th, Jupiter the 5th and 9th, and Saturn the 3rd and 10th. Rahu and Ketu are usually given the 5th, 7th and 9th. A planet\'s aspect colours the planet or house it falls on with its own nature.';

  @override
  String get aspRashiBody => 'Rashi Drishti is a sign-to-sign aspect from Jaimini astrology, independent of which planets sit there. Movable signs aspect fixed signs (except the adjacent one), fixed signs aspect movable signs (except the adjacent one), and dual signs aspect the other dual signs. It is used mainly in Jaimini prediction and for judging relationships between houses.';

  @override
  String get aspDiffBody => 'Graha Drishti is cast by a planet and depends on where that planet sits. Rashi Drishti belongs to the sign itself and applies to whatever is placed in it. Graha Drishti is directional (planet A sees planet B), while Rashi Drishti is usually mutual between the signs. When both point to the same target, the influence is especially strong.';

  @override
  String get aspPredictBody => 'An aspect shows where a planet extends its influence beyond its own house. A benefic aspect (Jupiter, Venus, well-placed Moon/Mercury) supports and protects the target; a malefic aspect (Saturn, Mars, Sun, Rahu, Ketu) can pressure, delay or challenge it. Reading which planets aspect a house or planet explains why results appear the way they do.';

  @override
  String get aspTraitSun => 'authority, leadership and vitality';

  @override
  String get aspTraitMoon => 'emotional depth, comfort and intuition';

  @override
  String get aspTraitMars => 'energy, courage and drive';

  @override
  String get aspTraitMercury => 'communication, intellect and adaptability';

  @override
  String get aspTraitJupiter => 'wisdom, growth and good fortune';

  @override
  String get aspTraitVenus => 'love, harmony and comforts';

  @override
  String get aspTraitSaturn => 'discipline, responsibility and patient, sometimes delayed, success';

  @override
  String get aspTraitRahu => 'ambition, intensity and unconventional turns';

  @override
  String get aspTraitKetu => 'detachment, spirituality and sudden change';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '${planet} is influencing ${targets}. This may bring ${trait} to the areas represented by these planets.';
  }

  @override
  String aspAiNone(Object planet) {
    return '${planet} does not cast a special aspect on any other planet here; its influence works mainly through its own sign and house.';
  }

  @override
  String get grahaDrishti => 'Graha Drishti (Planet Aspects)';

  @override
  String get rashiDrishti => 'Rashi Drishti (Sign Aspects)';

  @override
  String get grahaDrishtiSubtitle => 'Who aspects whom (%)';

  @override
  String get lagnaAspectsReceived => 'Lagna Aspects Received';

  @override
  String get avSummaryTitle => 'Ashtakavarga Summary';

  @override
  String get avOverallScore => 'Overall SAV Score';

  @override
  String get avOverallRating => 'Overall Rating';

  @override
  String get avStrongestSigns => 'Strongest Signs';

  @override
  String get avWeakestSigns => 'Weakest Signs';

  @override
  String get avScore => 'Score';

  @override
  String get avMeaning => 'Meaning';

  @override
  String get avGrid => 'Grid';

  @override
  String get avList => 'List';

  @override
  String get avOverallScoreShort => 'Overall Score';

  @override
  String get avNatalSignScore => 'Natal Sign Score';

  @override
  String get avBestSigns => 'Best Signs';

  @override
  String get avWeakSigns => 'Weak Signs';

  @override
  String get avAiInterpretation => 'AI Interpretation';

  @override
  String get avVeryGood => 'Very Good';

  @override
  String get avVeryWeak => 'Very Weak';

  @override
  String get avTotalSav => 'Total SAV';

  @override
  String get avPlanetContributions => 'Planet Contributions';

  @override
  String get avFinance => 'Finance';

  @override
  String get avOverallStrength => 'Overall Strength';

  @override
  String get avWhatDoesThisMean => 'What does this mean?';

  @override
  String get avSimple => 'Simple';

  @override
  String get avAdvanced => 'Advanced';

  @override
  String get avInfoTitle => 'Understanding Ashtakavarga';

  @override
  String get avStrong => 'Strong';

  @override
  String get avModerate => 'Moderate';

  @override
  String get avQWhatIsAv => 'What is Ashtakavarga?';

  @override
  String get avQWhatIsSav => 'What is SAV?';

  @override
  String get avQWhatIsBav => 'What is BAV?';

  @override
  String get avQHowToRead => 'How to read these scores';

  @override
  String get avQSavVsBav => 'SAV vs BAV';

  @override
  String get avABody => 'Ashtakavarga is a points-based strength system in Vedic astrology. Each planet awards benefic points (bindus, also called rekhas) to the twelve signs based on its position. More points in a sign means that area of life gets smoother support during related planetary periods and transits.';

  @override
  String get avSavBody => 'SAV (Sarva Ashtakavarga) adds together the points from all seven planets for each sign. It gives a single strength score per sign, so you can quickly see which signs — and the houses they fall in — are best supported in your chart.';

  @override
  String get avBavBody => 'BAV (Bhinna Ashtakavarga) shows the points from a single planet across the twelve signs. It tells you which signs a specific planet supports most, which matters when that planet\'s dasha or transit is active.';

  @override
  String get avHowToReadBody => 'Higher numbers are better. For SAV, an average sign scores about 28 points — above 30 is strong and below 25 needs care. For BAV, each sign ranges from 0 to 8, with 4 being average. Favour your strongest signs for important actions, and stay patient and disciplined with your weakest ones.';

  @override
  String get avSavVsBavBody => 'SAV is the combined total of all planets and shows a sign\'s overall strength. BAV is a single planet\'s contribution and shows which planet supports that sign. Use SAV for the big picture, and BAV to understand which planet drives a sign\'s strength.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'Your chart is strongest in ${s1}, ${s2} and ${s3}. These signs give better support during planetary periods and transits. ${weak} currently has the least support, so patience and discipline help in matters connected with it.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '${planet} performs strongest through ${s1} and ${s2}. Matters governed by ${planet} tend to improve when these signs are activated.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'Your strongest signs are ${s1} and ${s2} — favour important beginnings when planets transit them.';
  }

  @override
  String avInsightWeak(Object s1) {
    return '${s1} has the least support — move carefully and avoid over-commitment in its matters.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '${planet} carries the most points, so its significations are well supported in your life.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '${planet} carries the fewest points and benefits most from remedies and conscious effort.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'Signs scoring above your average of ${avg} points tend to give smoother, more reliable results.';
  }

  @override
  String get gradeExcellent => 'Excellent';

  @override
  String get gradeGood => 'Good';

  @override
  String get gradeAverage => 'Average';

  @override
  String get gradeWeak => 'Weak';

  @override
  String get careerWord => 'Career';

  @override
  String get educationWord => 'Education';

  @override
  String get lifeAreaMarriage => 'Marriage';

  @override
  String get sarvaAshtakavarga => 'Sarva Ashtakavarga (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'Total: ${total} rekhas (average sign = ${avg})';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '${planet} — BAV';
  }

  @override
  String get forecast => 'Forecast';

  @override
  String get fcKey => 'Key';

  @override
  String get fcActions => 'Actions';

  @override
  String get fcCautions => 'Cautions';

  @override
  String get fc12House => '12 House';

  @override
  String get fcProbabilities => 'Probabilities';

  @override
  String get fcHousesCaps => 'HOUSES';

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
  String get fcBestTimeForIncome => 'Best Time for Income';

  @override
  String get fcExpenseCaution => 'Expense Caution';

  @override
  String get fcIncomeCaps => 'INCOME';

  @override
  String get fcExpenseCaps => 'EXPENSE';

  @override
  String get fcRelationships => 'Relationships';

  @override
  String get fcAreasCaps => 'AREAS';

  @override
  String get fcBestForMeetings => 'Best For Meetings';

  @override
  String get fcOpportunitiesVs => 'Opportunities vs';

  @override
  String get fcRisks => 'Risks';

  @override
  String get fcOutlook => 'OUTLOOK';

  @override
  String get fcAction => 'Action';

  @override
  String get fcProtect => 'Protect';

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
  String get fcAvoid => 'Avoid';

  @override
  String get fcHouse => 'House';

  @override
  String get fcFailed => 'Failed';

  @override
  String get lifeCareer => 'Career';

  @override
  String get lifeHealth => 'Health';

  @override
  String get lifeWealth => 'Wealth';

  @override
  String get lifeFamily => 'Family';

  @override
  String get lifeMind => 'Mind';

  @override
  String get lifeEgo => 'Ego';

  @override
  String get lifeAggression => 'Aggression';

  @override
  String get lifeConflict => 'Conflict';

  @override
  String get rashiElement => 'Element';

  @override
  String get rashiQuality => 'Quality';

  @override
  String get rashiLuckyColor => 'Lucky Color';

  @override
  String get rashiLuckyDay => 'Lucky Day';

  @override
  String get rashiLuckyNumber => 'Lucky Number';

  @override
  String get rashiGemstone => 'Gemstone';

  @override
  String get rashiBody => 'Body';

  @override
  String get gocharTodaysTransitChart => 'Today\'s Transit Chart';

  @override
  String get gocharTransit => 'Transit';

  @override
  String get thisWeek => 'This Week';

  @override
  String get best => 'Best';

  @override
  String get worst => 'Worst';

  @override
  String get avg => 'avg';

  @override
  String get love => 'Love';

  @override
  String get spiritual => 'Spiritual';

  @override
  String get analysisConfidence => 'Analysis Confidence';

  @override
  String get areasForGrowth => 'AREAS FOR GROWTH';

  @override
  String get astrologicalRemedies => 'Astrological Remedies';

  @override
  String get bestIndustries => 'BEST INDUSTRIES';

  @override
  String get burnoutRisk => 'Burnout Risk';

  @override
  String get careerAnalysis => 'Career Analysis';

  @override
  String get careerArchetype => 'Career Archetype';

  @override
  String get careerRisks => 'Career Risks';

  @override
  String get careerStagnation => 'Career Stagnation';

  @override
  String get clarity => 'CLARITY';

  @override
  String get copyFullReport => 'Copy full report data';

  @override
  String get d9Dignity => 'D9 DIGNITY';

  @override
  String get divisionalValidation => 'Divisional Validation';

  @override
  String get employment => 'Employment';

  @override
  String get entrepreneurship => 'Entrepreneurship';

  @override
  String get fitScore => 'FIT SCORE';

  @override
  String get freelance => 'Freelance';

  @override
  String get growth => 'GROWTH';

  @override
  String get houseAnalysis => 'House Analysis';

  @override
  String get idealEnvironment => 'Ideal Environment';

  @override
  String get idealOrgSize => 'Ideal Org Size';

  @override
  String get jaiminiKarakas => 'Jaimini Karakas';

  @override
  String get lagnaLord => 'Lagna Lord';

  @override
  String get launchWindows => 'Launch Windows';

  @override
  String get lord => 'LORD';

  @override
  String get lordDignity => 'LORD DIGNITY';

  @override
  String get lordPlacedIn => 'LORD PLACED IN';

  @override
  String get overallStrength => 'OVERALL STRENGTH';

  @override
  String get peakWindows => 'Peak Windows';

  @override
  String get portfolio => 'Portfolio';

  @override
  String get practicalSolutions => 'Practical Solutions';

  @override
  String get promotionWindows => 'Promotion Windows';

  @override
  String get recognition => 'RECOGNITION';

  @override
  String get recommended => 'RECOMMENDED';

  @override
  String get riskWindows => 'Risk Windows';

  @override
  String get satisfaction => 'SATISFACTION';

  @override
  String get stability => 'STABILITY';

  @override
  String get teamLeadership => 'Team Leadership';

  @override
  String get tenthLord => '10th Lord';

  @override
  String get timingWindows => 'Timing Windows';

  @override
  String get verdict => 'VERDICT';

  @override
  String get workStructure => 'Work Structure';

  @override
  String get workplaceConflict => 'Workplace Conflict';

  @override
  String get mitigationLabel => 'MITIGATION';

  @override
  String get reliabilityVeryHigh => 'Very High reliability';

  @override
  String get reliabilityHigh => 'High reliability';

  @override
  String get reliabilityModerate => 'Moderate reliability';

  @override
  String get reliabilityGuidance => 'Guidance-level reading';

  @override
  String get relationshipTitlePrefix => 'Relationship';

  @override
  String get relationshipTitleSuffix => 'Intelligence';

  @override
  String get relationshipIntelBannerLabel => 'RELATIONSHIP INTELLIGENCE';

  @override
  String get typeLabel => 'TYPE';

  @override
  String get trustLabel => 'TRUST';

  @override
  String get dhokaRiskLabel => 'DHOKA RISK';

  @override
  String powerLabel(Object power) {
    return 'Power: ${power}';
  }

  @override
  String get chartProfilesPrefix => 'Chart';

  @override
  String get chartProfilesSuffix => 'Profiles';

  @override
  String lagnaSuffixLabel(Object sign) {
    return '${sign} Lagna';
  }

  @override
  String get miniIntegrityLabel => 'Integrity';

  @override
  String get miniWarmthLabel => 'Warmth';

  @override
  String get miniTrustLabel => 'Trust';

  @override
  String get miniAssertLabel => 'Assert';

  @override
  String akLabel(Object planet) {
    return 'AK: ${planet}';
  }

  @override
  String get pairwisePrefix => 'Pairwise';

  @override
  String get pairwiseSuffix => 'Analysis';

  @override
  String trustPercentLabel(Object pct) {
    return 'Trust: ${pct}%';
  }

  @override
  String betrayalPercentLabel(Object pct) {
    return 'Betrayal: ${pct}%';
  }

  @override
  String get scoreCharacterLabel => 'Character';

  @override
  String get scoreLoveLabel => 'Love';

  @override
  String get scoreBusinessLabel => 'Business';

  @override
  String get scoreKarmicLabel => 'Karmic';

  @override
  String get scoreTrustLabel => 'Trust';

  @override
  String get scoreEnmityRiskLabel => 'Enmity Risk';

  @override
  String dynamicLabel(Object value) {
    return 'Dynamic: ${value}';
  }

  @override
  String karmicLabel(Object value) {
    return 'Karmic: ${value}';
  }

  @override
  String get criticalPrefix => 'Critical';

  @override
  String get criticalSuffix => 'Patterns';

  @override
  String get groupPrefix => 'Group';

  @override
  String get groupSuffix => 'Recommendations';

  @override
  String get sharedPracticesLabel => 'SHARED PRACTICES';

  @override
  String communicationLabel(Object value) {
    return 'Communication: ${value}';
  }

  @override
  String focusLabel(Object value) {
    return 'Focus: ${value}';
  }

  @override
  String get individualPrefix => 'Individual';

  @override
  String get individualSuffix => 'Guidance';

  @override
  String karmicLessonLabel(Object value) {
    return 'Karmic lesson: ${value}';
  }

  @override
  String get growthAreasLabel => 'GROWTH AREAS';

  @override
  String get corePrefix => 'Core';

  @override
  String get coreSuffix => 'Theme';

  @override
  String get growthOrientedLabel => 'GROWTH-ORIENTED';

  @override
  String get groupThemeLabel => 'GROUP THEME';

  @override
  String get analysisPrefix => 'Analysis';

  @override
  String get analysisConfidenceSuffix => 'Confidence';

  @override
  String get reportCopied => 'Report copied!';

  @override
  String get copyFullReportData => 'Copy full report data';

  @override
  String get openExternalLabel => 'OPEN';

  @override
  String copiedOpeningAi(Object ai) {
    return 'Copied! Opening ${ai}...';
  }

  @override
  String get milanTitlePrefix => 'Kundli';

  @override
  String get ashtakoot => 'Ashtakoot';

  @override
  String get compatibilityLabel => 'COMPATIBILITY';

  @override
  String get unifiedScoreLabel => 'UNIFIED\nSCORE';

  @override
  String get probabilityLabel => 'PROBABILITY';

  @override
  String ganaLabel(Object value) {
    return 'Gana: ${value}';
  }

  @override
  String get gunPrefixLabel => '8 Gun';

  @override
  String get breakdownLabel => 'Breakdown';

  @override
  String get mangalLabel => 'Mangal';

  @override
  String severityLabel(Object value) {
    return 'Sev: ${value}';
  }

  @override
  String get d9Label => 'D-9';

  @override
  String get crossChartLabel => 'Cross-Chart';

  @override
  String get d9CompatibilityLabel => 'D-9 COMPATIBILITY';

  @override
  String get domainEmotional => 'Emotional';

  @override
  String get domainIntellectual => 'Intellectual';

  @override
  String get domainSpiritual => 'Spiritual';

  @override
  String get domainFinancial => 'Financial';

  @override
  String get domainDomestic => 'Domestic';

  @override
  String get domainCommunication => 'Communication';

  @override
  String get domainSharedDharma => 'Shared Dharma';

  @override
  String get domainFamilyCreation => 'Family Creation';

  @override
  String get domainLabel => 'Domain';

  @override
  String get compatibilitySuffixLabel => 'Compatibility';

  @override
  String get marriageLabel => 'Marriage';

  @override
  String get timingLabel => 'Timing';

  @override
  String get jointMarriageWindowsTitle => 'Joint Marriage Windows';

  @override
  String get engagementWindowsTitle => 'Engagement Windows';

  @override
  String recommendedLabel(Object value) {
    return 'Recommended: ${value}';
  }

  @override
  String get risksLabel => 'Risks';

  @override
  String get finalLabel => 'Final';

  @override
  String get verdictLabel => 'Verdict';

  @override
  String get marriageVerdictLabel => 'MARRIAGE VERDICT';

  @override
  String get discussReportWithAI => 'DISCUSS THIS REPORT WITH AI';

  @override
  String get multiChartTitleChild => 'Child';

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
  String get participantsLabel => 'PARTICIPANTS';

  @override
  String get reportDataCopied => 'Report data copied!';

  @override
  String copiedForAi(Object label) {
    return 'Copied for ${label}!';
  }

  @override
  String get wealthScoresLabel => 'WEALTH SCORES';

  @override
  String get wealthStrengthLabel => 'WEALTH\nSTRENGTH';

  @override
  String get accumulationLabel => 'ACCUMU-\nLATION';

  @override
  String get incomeFlowLabel => 'INCOME\nFLOW';

  @override
  String get sustainLabel => 'SUSTAIN';

  @override
  String get multiStreamLabel => 'MULTI-STREAM';

  @override
  String get retentionLabel => 'RETENTION';

  @override
  String get wealthLabel => 'Wealth';

  @override
  String get karakasLabel => 'Karakas';

  @override
  String get wealthYogasTitle => 'Wealth Yogas';

  @override
  String get drainsLabel => 'DRAINS';

  @override
  String get boostersLabel => 'BOOSTERS';

  @override
  String get incomeLabel => 'Income';

  @override
  String get sourcesLabel => 'Sources';

  @override
  String get investmentLabel => 'Investment';

  @override
  String get mixLabel => 'Mix';

  @override
  String get yearlyTrendTitle => 'Yearly Trend';

  @override
  String get wealthGrowthTitle => 'Wealth Growth';

  @override
  String get cashPressureTitle => 'Cash Pressure';

  @override
  String get moneyPersonalityTitle => 'Money Personality';

  @override
  String get wealthTypeLabel => 'WEALTH TYPE';

  @override
  String get riskAppetiteLabel => 'RISK APPETITE';

  @override
  String get investmentStyleLabel => 'INVESTMENT STYLE';

  @override
  String get moneyPersonalityLabel => 'MONEY PERSONALITY';

  @override
  String get spendingLabel => 'SPENDING';

  @override
  String get debtProbLabel => 'DEBT PROB %';

  @override
  String get inheritanceProbLabel => 'INHERITANCE %';

  @override
  String get suddenGainsProbLabel => 'SUDDEN GAINS %';

  @override
  String get spouseBoostLabel => 'SPOUSE BOOST %';

  @override
  String successProbabilityLabel(Object pct) {
    return 'Success probability: ${pct}%';
  }

  @override
  String get lifetimeWealthClassLabel => 'LIFETIME WEALTH CLASS';

  @override
  String primaryLabel(Object value) {
    return 'Primary: ${value}';
  }

  @override
  String peakAgeLabel(Object value) {
    return 'Peak: ${value}';
  }

  @override
  String drivenByLabel(Object value) {
    return 'Driven by ${value}';
  }

  @override
  String get coreBlockerLabel => 'CORE BLOCKER';

  @override
  String get debtScoresLabel => 'DEBT SCORES';

  @override
  String get currentDebtLoadLabel => 'CURRENT\nDEBT LOAD';

  @override
  String get recoveryCapacityLabel => 'RECOVERY\nCAPACITY';

  @override
  String get intensityLabel => 'INTENSITY';

  @override
  String get defaultRiskLabel => 'DEFAULT RISK';

  @override
  String get debtProfileTitle => 'Debt Profile';

  @override
  String get karmaLabel => 'KARMA';

  @override
  String get personalityLabel => 'PERSONALITY';

  @override
  String get phaseLabel => 'PHASE';

  @override
  String get primaryCategoryLabel => 'PRIMARY CATEGORY';

  @override
  String get debtLabel => 'Debt';

  @override
  String get debtYogasTitle => 'Debt Yogas';

  @override
  String get debtCreatingLabel => 'DEBT-CREATING';

  @override
  String get debtClearingLabel => 'DEBT-CLEARING';

  @override
  String get categoriesLabel => 'Categories';

  @override
  String get yearlyDebtTitle => 'Yearly Debt';

  @override
  String get repaymentTitle => 'Repayment';

  @override
  String get dangerPeriodsTitle => 'Danger Periods';

  @override
  String get defaultPctLabel => 'DEFAULT %';

  @override
  String get bankruptcyPctLabel => 'BANKRUPTCY %';

  @override
  String get chronicPctLabel => 'CHRONIC %';

  @override
  String get resilienceLabel => 'RESILIENCE';

  @override
  String recoveryTimelineLabel(Object pct, Object years) {
    return 'Recovery: ${pct}% · Timeline: ${years}yrs';
  }

  @override
  String get debtFreeWindowLabel => 'DEBT-FREE WINDOW';

  @override
  String yearLabel(Object year) {
    return 'Year ${year}';
  }

  @override
  String dashaLabel(Object value) {
    return 'Dasha: ${value}';
  }

  @override
  String get marriageScoresLabel => 'MARRIAGE SCORES';

  @override
  String get overallMarriageLabel => 'OVERALL\nMARRIAGE';

  @override
  String get maritalHarmonyLabel => 'MARITAL\nHARMONY';

  @override
  String get domesticStabilityLabel => 'DOMESTIC\nSTABILITY';

  @override
  String get longevityLabel => 'LONGEVITY';

  @override
  String get satisfactionLabel => 'SATISFACTION';

  @override
  String get clarityLabel => 'CLARITY';

  @override
  String get darakarakaLabel => 'Darakaraka';

  @override
  String get spouseKarakaLabel => 'Spouse Karaka';

  @override
  String get darakarakaDkLabel => 'DARAKARAKA (DK)';

  @override
  String get seventhLabel => '7th';

  @override
  String get lordLabel => 'LORD';

  @override
  String get lordInLabel => 'LORD IN';

  @override
  String get lordDignityLabel => 'LORD DIGNITY';

  @override
  String get emptyLabel => 'Empty';

  @override
  String get spouseLabel => 'Spouse';

  @override
  String get spouseTraitsLabel => 'SPOUSE TRAITS';

  @override
  String get likelyProfessionsLabel => 'LIKELY PROFESSIONS';

  @override
  String get harmonyPhysicalLabel => 'Physical';

  @override
  String get sharedValuesLabel => 'Shared Values';

  @override
  String get conflictResolutionLabel => 'Conflict Resolution';

  @override
  String get harmonyLabel => 'Harmony';

  @override
  String get radarLabel => 'Radar';

  @override
  String get mangalDoshLabel => 'MANGAL DOSH';

  @override
  String severityColonLabel(Object value) {
    return 'Severity: ${value}';
  }

  @override
  String cancellationColonLabel(Object value) {
    return 'Cancellation: ${value}';
  }

  @override
  String get marriageWindowsTitle => 'Marriage Windows';

  @override
  String get marriagePhasesTitle => 'Marriage Phases';

  @override
  String get inLawRelationsLabel => 'IN-LAW RELATIONS';

  @override
  String get familyHarmonyLabel => 'FAMILY HARMONY';

  @override
  String get fertilityLabel => 'FERTILITY';

  @override
  String get homeOwnershipLabel => 'HOME OWNERSHIP';

  @override
  String get divorceRiskLabel => 'DIVORCE RISK';

  @override
  String get infidelityLabel => 'INFIDELITY';

  @override
  String get conflictLabel => 'CONFLICT';

  @override
  String get distanceLabel => 'DISTANCE';

  @override
  String get seekInPartnerLabel => 'SEEK IN PARTNER';

  @override
  String get avoidInPartnerLabel => 'AVOID IN PARTNER';

  @override
  String realizationLabel(Object pct) {
    return 'Realization: ${pct}%';
  }

  @override
  String get navamsaLabel => 'Navamsa';

  @override
  String get characterScoresLabel => 'CHARACTER SCORES';

  @override
  String get characterStrengthLabel => 'CHARACTER\nSTRENGTH';

  @override
  String get characterIntegrityLabel => 'INTEGRITY';

  @override
  String get awarenessLabel => 'AWARENESS';

  @override
  String get stabilityLabel => 'STABILITY';

  @override
  String get ethicsLabel => 'ETHICS';

  @override
  String get surfacePersonalityTitle => 'Surface Personality';

  @override
  String get constitutionLabel => 'CONSTITUTION';

  @override
  String get nakshatraLabel => 'NAKSHATRA';

  @override
  String get deityLabel => 'DEITY';

  @override
  String get moonManasTitle => 'Moon Manas';

  @override
  String get warmthLabel => 'WARMTH';

  @override
  String get empathyLabel => 'EMPATHY';

  @override
  String get loyaltyLabel => 'LOYALTY';

  @override
  String get boundariesLabel => 'BOUNDARIES';

  @override
  String get dharmaLabel => 'DHARMA';

  @override
  String get truthLabel => 'TRUTH';

  @override
  String get compassionLabel => 'COMPASSION';

  @override
  String get generosityLabel => 'GENEROSITY';

  @override
  String get signatureVirtuesLabel => 'SIGNATURE VIRTUES';

  @override
  String get naturalTalentsLabel => 'NATURAL TALENTS';

  @override
  String get shadowPatternsLabel => 'SHADOW PATTERNS';

  @override
  String get characterYogasTitle => 'Character Yogas';

  @override
  String get testsLabel => 'TESTS';

  @override
  String get giftsLabel => 'GIFTS';

  @override
  String get selfAwareEiLabel => 'SELF-AWARE EI';

  @override
  String get selfRegulateLabel => 'SELF-REGULATE';

  @override
  String get empathyEiLabel => 'EMPATHY EI';

  @override
  String get socialSkillsLabel => 'SOCIAL SKILLS';

  @override
  String get atmakarakaLabel => 'Atmakaraka';

  @override
  String get soulSignatureLabel => 'Soul Signature';

  @override
  String get atmakarakaAllCapsLabel => 'ATMAKARAKA';

  @override
  String get gunaLabel => 'Guna';

  @override
  String dominantColonLabel(Object value) {
    return 'Dominant: ${value}';
  }

  @override
  String get coreGiftLabel => 'CORE GIFT';

  @override
  String get coreThemeAllCapsLabel => 'CORE THEME';

  @override
  String get pastLifeScoresLabel => 'PAST LIFE SCORES';

  @override
  String get signatureStrengthLabel => 'SIGNATURE\nSTRENGTH';

  @override
  String get carryForwardLabel => 'CARRY-\nFORWARD';

  @override
  String get masteryPreservedLabel => 'MASTERY\nPRESERVED';

  @override
  String get unfinishedLabel => 'UNFINISHED';

  @override
  String get karmicDebtLabel => 'KARMIC DEBT';

  @override
  String get pastMasteryLabel => 'Past Mastery';

  @override
  String get futureGrowthLabel => 'Future Growth';

  @override
  String get ketuWhatYouMasteredLabel => 'KETU · WHAT YOU MASTERED';

  @override
  String get rahuWhatPullsForwardLabel => 'RAHU · WHAT PULLS YOU FORWARD';

  @override
  String get pastLifeProfileTitle => 'Past Life Profile';

  @override
  String get themeLabel => 'THEME';

  @override
  String get professionLabel => 'PROFESSION';

  @override
  String get socialStandingLabel => 'SOCIAL STANDING';

  @override
  String get regionLabel => 'REGION';

  @override
  String get spiritualLevelLabel => 'SPIRITUAL LEVEL';

  @override
  String get wealthLevelLabel => 'WEALTH LEVEL';

  @override
  String get familyRoleLabel => 'FAMILY ROLE';

  @override
  String get skillsCarriedForwardLabel => 'SKILLS CARRIED FORWARD';

  @override
  String get naturalAttractionsLabel => 'NATURAL ATTRACTIONS';

  @override
  String get unexplainedFearsLabel => 'UNEXPLAINED FEARS';

  @override
  String get magneticPullsLabel => 'MAGNETIC PULLS';

  @override
  String get relationshipLabel => 'RELATIONSHIP';

  @override
  String get financialLabel => 'FINANCIAL';

  @override
  String get serviceLabel => 'SERVICE';

  @override
  String get dharmicLabel => 'DHARMIC';

  @override
  String get onRelationsLabel => 'ON RELATIONS';

  @override
  String get onCareerLabel => 'ON CAREER';

  @override
  String get onHealthLabel => 'ON HEALTH';

  @override
  String get onSpiritualLabel => 'ON SPIRITUAL';

  @override
  String get karmicResolutionTitle => 'Karmic Resolution';

  @override
  String get primaryPathLabel => 'PRIMARY PATH';

  @override
  String get secondaryPathLabel => 'SECONDARY PATH';

  @override
  String get clearingProgressLabel => 'CLEARING PROGRESS';

  @override
  String get remainingWorkLabel => 'REMAINING WORK';

  @override
  String get debtTimelineLabel => 'DEBT TIMELINE';

  @override
  String get memoryAccessLabel => 'MEMORY ACCESS';

  @override
  String get dreamVisitsLabel => 'DREAM VISITS';

  @override
  String get dejaVuLabel => 'DEJA VU';

  @override
  String get regressionFitLabel => 'REGRESSION FIT';

  @override
  String get pastLifeActivationTitle => 'Past Life Activation';

  @override
  String maturityStatusLabel(Object score, Object status) {
    return 'Maturity: ${score} · Status: ${status}';
  }

  @override
  String shadowColonLabel(Object value) {
    return 'Shadow: ${value}';
  }

  @override
  String get lifePathScoresLabel => 'LIFE PATH SCORES';

  @override
  String get dharmaClarityLabel => 'DHARMA\nCLARITY';

  @override
  String get fortuneBaselineLabel => 'FORTUNE\nBASELINE';

  @override
  String get lifePathCoherenceLabel => 'LIFE PATH\nCOHERENCE';

  @override
  String get karmaAllCapsLabel => 'KARMA';

  @override
  String get spiritualAllCapsLabel => 'SPIRITUAL';

  @override
  String get fameLabel => 'FAME';

  @override
  String get lifeLabel => 'Life';

  @override
  String get archetypeLabel => 'Archetype';

  @override
  String get soulContractTitle => 'Soul Contract';

  @override
  String get akFocusLabel => 'AK FOCUS';

  @override
  String get soulPurposeLabel => 'SOUL PURPOSE';

  @override
  String get lifeChapterLabel => 'LIFE CHAPTER';

  @override
  String get primaryDomainLabel => 'PRIMARY DOMAIN';

  @override
  String get leadershipLabel => 'LEADERSHIP';

  @override
  String get wisdomTeachLabel => 'WISDOM/TEACH';

  @override
  String get healingLabel => 'HEALING';

  @override
  String get fortuneYogasTitle => 'Fortune Yogas';

  @override
  String get luckBlocksLabel => 'LUCK BLOCKS';

  @override
  String get fortuneBoostersLabel => 'FORTUNE BOOSTERS';

  @override
  String get fortuneTrendTitle => 'Fortune Trend';

  @override
  String get goldenWindowsTitle => 'Golden Windows ★';

  @override
  String get transformationTitle => 'Transformation';

  @override
  String get lifeMilestonesTitle => 'Life Milestones';

  @override
  String get destinyVsLabel => 'Destiny vs';

  @override
  String get freeWillLabel => 'Free Will';

  @override
  String get destinyAllCapsLabel => 'DESTINY';

  @override
  String get freeWillAllCapsLabel => 'FREE WILL';

  @override
  String get karmicLessonsTitle => 'Karmic Lessons';

  @override
  String get rahuGrowthLabel => 'RAHU GROWTH';

  @override
  String get ketuSurrenderLabel => 'KETU SURRENDER';

  @override
  String get saturnLessonLabel => 'SATURN LESSON';

  @override
  String get lifeDifficultyLabel => 'LIFE DIFFICULTY';

  @override
  String get soulCameToExperienceLabel => 'SOUL CAME TO EXPERIENCE';

  @override
  String get blessingsLabel => 'BLESSINGS';

  @override
  String fulfillmentLabel(Object pct) {
    return 'Fulfillment: ${pct}%';
  }

  @override
  String get legalScoresLabel => 'LEGAL SCORES';

  @override
  String get legalVulnerabilityLabel => 'LEGAL\nVULNERABILITY';

  @override
  String get victoryPotentialLabel => 'VICTORY\nPOTENTIAL';

  @override
  String get resolutionLabel => 'RESOLUTION';

  @override
  String get legalProfileTitle => 'Legal Profile';

  @override
  String get karmaTypeLabel => 'KARMA TYPE';

  @override
  String get conflictStyleLabel => 'CONFLICT STYLE';

  @override
  String get strategyLabel => 'STRATEGY';

  @override
  String get caseDurationLabel => 'CASE DURATION';

  @override
  String get currentStatusLabel => 'CURRENT STATUS';

  @override
  String get legalLabel => 'Legal';

  @override
  String get legalYogasTitle => 'Legal Yogas';

  @override
  String get disputePressureLabel => 'DISPUTE PRESSURE';

  @override
  String get legalProtectionLabel => 'LEGAL PROTECTION';

  @override
  String get victoryLabel => 'Victory';

  @override
  String get asPlaintiffLabel => 'AS PLAINTIFF';

  @override
  String get asDefendantLabel => 'AS DEFENDANT';

  @override
  String get winProbabilityLabel => 'WIN PROBABILITY';

  @override
  String get disputeLabel => 'Dispute';

  @override
  String get legalStressTitle => 'Legal Stress';

  @override
  String get visibleEnemiesLabel => 'VISIBLE ENEMIES';

  @override
  String get hiddenEnemiesLabel => 'HIDDEN ENEMIES';

  @override
  String get criminalRiskLabel => 'CRIMINAL RISK';

  @override
  String get falseAccusationLabel => 'FALSE ACCUSATION';

  @override
  String get contractKarmaTitle => 'Contract Karma';

  @override
  String get documentationLabel => 'DOCUMENTATION';

  @override
  String get finePrintAwareLabel => 'FINE PRINT AWARE';

  @override
  String get negotiationSkillLabel => 'NEGOTIATION SKILL';

  @override
  String get signatureCautionLabel => 'SIGNATURE CAUTION';

  @override
  String resilienceColonLabel(Object value) {
    return 'Resilience: ${value}/100';
  }

  @override
  String get healthScoresLabel => 'HEALTH SCORES';

  @override
  String get vitalityLabel => 'VITALITY';

  @override
  String get immunityLabel => 'IMMUNITY';

  @override
  String get recoveryLabel => 'RECOVERY';

  @override
  String get mentalLabel => 'MENTAL';

  @override
  String get stressTolLabel => 'STRESS TOL';

  @override
  String get ayurvedicLabel => 'Ayurvedic';

  @override
  String get constitutionTitleLabel => 'Constitution';

  @override
  String secondaryColonLabel(Object value) {
    return 'Secondary: ${value}';
  }

  @override
  String get bodyLabel => 'Body';

  @override
  String get systemMapLabel => 'System Map';

  @override
  String get healthYogasTitle => 'Health Yogas';

  @override
  String get diseasePressureLabel => 'DISEASE PRESSURE';

  @override
  String get protectiveLabel => 'PROTECTIVE';

  @override
  String get bodyZoneLabel => 'Body Zone';

  @override
  String get vulnerabilityLabel => 'Vulnerability';

  @override
  String get diseaseLabel => 'Disease';

  @override
  String get susceptibilityLabel => 'Susceptibility';

  @override
  String get healthTrendTitle => 'Health Trend';

  @override
  String get recoveryWindowsTitle => 'Recovery Windows';

  @override
  String get cautionPeriodsTitle => 'Caution Periods';

  @override
  String get burnoutRiskLabel => 'BURNOUT RISK';

  @override
  String get addictionVulnLabel => 'ADDICTION VULN';

  @override
  String get workLifeBalLabel => 'WORK-LIFE BAL';

  @override
  String get lifestyleFactorsTitle => 'Lifestyle Factors';

  @override
  String get sleepDisciplineLabel => 'SLEEP DISCIPLINE';

  @override
  String get dietDisciplineLabel => 'DIET DISCIPLINE';

  @override
  String get exerciseNeedLabel => 'EXERCISE NEED';

  @override
  String get sunlightNeedLabel => 'SUNLIGHT NEED';

  @override
  String get socialTypeLabel => 'SOCIAL TYPE';

  @override
  String get healingSpeedLabel => 'HEALING SPEED';

  @override
  String get mentalScoresLabel => 'MENTAL SCORES';

  @override
  String get mentalStabilityLabel => 'MENTAL\nSTABILITY';

  @override
  String get emotionalBaselineLabel => 'EMOTIONAL\nBASELINE';

  @override
  String get anxietyLabel => 'ANXIETY';

  @override
  String get depressionLabel => 'DEPRESSION';

  @override
  String get regulationLabel => 'REGULATION';

  @override
  String get mentalProfileTitle => 'Mental Profile';

  @override
  String get stressDriverLabel => 'STRESS DRIVER';

  @override
  String get stabilityAnchorLabel => 'STABILITY ANCHOR';

  @override
  String get attachmentStyleLabel => 'ATTACHMENT STYLE';

  @override
  String get burnoutStageLabel => 'BURNOUT STAGE';

  @override
  String get mentalTitleLabel => 'Mental';

  @override
  String get mentalYogasTitle => 'Mental Yogas';

  @override
  String get stressPressureLabel => 'STRESS PRESSURE';

  @override
  String get stressResponseLabel => 'STRESS RESPONSE';

  @override
  String get anxietyTitleLabel => 'Anxiety';

  @override
  String get typesLabel => 'Types';

  @override
  String get therapyLabel => 'Therapy';

  @override
  String get modalityFitLabel => 'Modality Fit';

  @override
  String get wellnessTrendTitle => 'Wellness Trend';

  @override
  String get healthyCopingLabel => 'HEALTHY COPING';

  @override
  String get unhealthyRisksLabel => 'UNHEALTHY RISKS';

  @override
  String get recommendedAlternativesLabel => 'RECOMMENDED ALTERNATIVES';

  @override
  String get sleepQualityLabel => 'SLEEP QUALITY';

  @override
  String get socialSupportLabel => 'SOCIAL SUPPORT';

  @override
  String get burnoutVulnLabel => 'BURNOUT VULN';

  @override
  String get selfAwarenessLabel => 'SELF-AWARENESS';

  @override
  String get authTagline => 'Nakshatralogy for Astrologers';

  @override
  String get googleSignInNoToken => 'Google Sign-In: No ID token received. Ensure GOOGLE_WEB_CLIENT_ID is set and google-services.json is configured.';

  @override
  String googleSignInError(String error) {
    return 'Google Sign-In error: ${error}';
  }

  @override
  String get orDivider => 'OR';

  @override
  String get register => 'Register';

  @override
  String get signInWithBiometrics => 'Sign in with biometrics';

  @override
  String get forgotPasswordInstructions => 'Enter your registered email to\nreceive a reset link.';

  @override
  String get resendLink => 'Resend Link';

  @override
  String callJoinedChannel(String channel) {
    return 'Joined channel ${channel}';
  }

  @override
  String get callUserConnected => 'User connected! Call active';

  @override
  String callConnectionFailed(String reason) {
    return 'Connection failed: ${reason}. Check Agora credentials.';
  }

  @override
  String callAgoraError(String details) {
    return 'Agora error: ${details}';
  }

  @override
  String callAgoraInitFailed(String error) {
    return 'Agora init failed: ${error}';
  }

  @override
  String get callWaitingForVideo => 'Waiting for video...';

  @override
  String get callVideoCall => 'Video Call';

  @override
  String get callVoiceCall => 'Voice Call';

  @override
  String callRateEarning(String rate, String earning) {
    return '${rate}/min • Earning: ${earning}';
  }

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get pullToRefresh => 'Pull down to refresh';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get noChartsCreateFirst => 'No charts. Create a birth chart first.';

  @override
  String get selectBirthChartToAnalyze => 'Select a birth chart to analyze';

  @override
  String get unknownName => 'Unknown';

  @override
  String selectRangeCharts(int max) {
    return 'Select 2-${max} Charts';
  }

  @override
  String selectExactCharts(int max) {
    return 'Select ${max} Charts';
  }

  @override
  String runningAnalysis(String label) {
    return 'Running ${label} analysis...';
  }

  @override
  String pickKarmicCharts(int max) {
    return 'Pick 2 to ${max} charts to analyze karmic links';
  }

  @override
  String get pickMaleFemaleChart => 'Pick a Male and Female chart';

  @override
  String get analysisFailed => 'Analysis failed';

  @override
  String errorWithDetails(String error) {
    return 'Error: ${error}';
  }

  @override
  String personNumber(int n) {
    return 'Person ${n}';
  }

  @override
  String analyzeNCharts(int count) {
    return 'Analyze ${count} Charts';
  }

  @override
  String get bhavaHouse1 => 'Self / Body';

  @override
  String get bhavaHouse2 => 'Wealth / Family';

  @override
  String get bhavaHouse3 => 'Siblings / Courage';

  @override
  String get bhavaHouse4 => 'Home / Mother';

  @override
  String get bhavaHouse5 => 'Children / Intellect';

  @override
  String get bhavaHouse6 => 'Enemies / Health';

  @override
  String get bhavaHouse7 => 'Marriage / Partner';

  @override
  String get bhavaHouse8 => 'Longevity';

  @override
  String get bhavaHouse9 => 'Fortune / Guru';

  @override
  String get bhavaHouse10 => 'Career / Father';

  @override
  String get bhavaHouse11 => 'Gains / Friends';

  @override
  String get bhavaHouse12 => 'Loss / Moksha';

  @override
  String bhavaSignLord(String sign, String lord) {
    return '${sign} • Lord: ${lord}';
  }

  @override
  String bhavaSavValue(String value) {
    return 'SAV: ${value}';
  }

  @override
  String get today => 'Today';

  @override
  String gocharTransitScoresTitle(String date) {
    return 'Gochar (Transit Scores) — ${date}';
  }

  @override
  String gocharNativeMoon(String moonSign) {
    return 'Native Moon: ${moonSign}';
  }

  @override
  String get gocharBest => 'BEST';

  @override
  String get gocharWorst => 'WORST';

  @override
  String get aspectsGrahaDrishtiTitle => 'Graha Drishti (Planet Aspects)';

  @override
  String get aspectsGrahaDrishtiSubtitle => 'Who aspects whom (%)';

  @override
  String get aspectsLagnaReceivedTitle => 'Lagna Aspects Received';

  @override
  String get aspectsRashiDrishtiTitle => 'Rashi Drishti (Sign Aspects)';

  @override
  String get ashtakavargaSavTitle => 'Sarva Ashtakavarga (SAV)';

  @override
  String ashtakavargaSavSubtitle(String total, String average) {
    return 'Total: ${total} rekhas (average sign = ${average})';
  }

  @override
  String ashtakavargaPlanetBavTitle(String planet) {
    return '${planet} — BAV';
  }

  @override
  String ashtakavargaPlanetBavSubtitle(String total, String natalScore) {
    return 'Total: ${total} rekhas • At natal sign: ${natalScore}';
  }

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get continueGoogle => 'Continue with Google';

  @override
  String get required => 'Required';

  @override
  String get minSixChars => 'Min 6 characters';

  @override
  String get passwordsMismatch => 'Passwords do not match';

  @override
  String get validEmailRequired => 'Valid email required';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get signupFailed => 'Signup failed';

  @override
  String get todaysEarning => 'TODAY\'S EARNINGS';

  @override
  String get walletBalance => 'WALLET';

  @override
  String get rating => 'RATING';

  @override
  String get totalSessions => 'SESSIONS';

  @override
  String get consultations => 'CONSULTATIONS';

  @override
  String get response => 'RESPONSE';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get busy => 'Busy';

  @override
  String get goLive => 'Go Live';

  @override
  String get streamTitle => 'Stream Title';

  @override
  String get description => 'Description (optional)';

  @override
  String get start => 'Start';

  @override
  String get rashiPredictions => 'Rashi Predictions';

  @override
  String get todaysGochar =>
      'Today\'s gochar for all 12 signs — tap to drill in';

  @override
  String get recentRequests => 'Recent Requests';

  @override
  String get noRecentRequests => 'No recent requests';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get viewAll => 'VIEW ALL';

  @override
  String get pending => 'Pending';

  @override
  String get accepted => 'Accepted';

  @override
  String get completed => 'Completed';

  @override
  String get declined => 'Declined';

  @override
  String get clientCharts => 'Client Charts';

  @override
  String get newChart => 'New Chart';

  @override
  String get noChartsCreated => 'No charts created yet';

  @override
  String get newClientChart => 'New Client Chart';

  @override
  String get clientBirthDetails => 'Client Birth Details';

  @override
  String get clientName => 'Client Name';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get timeOfBirth => 'Time of Birth';

  @override
  String get birthPlace => 'Birth Place';

  @override
  String get birthPlaceHint => 'Type city name to search...';

  @override
  String get generateKundli => 'Generate Kundli';

  @override
  String get clientChartCreated => 'Client chart created!';

  @override
  String get viewKundli => 'View Kundli';

  @override
  String get deleteChart => 'Delete Chart?';

  @override
  String get completeBirthChart => 'Complete Birth Chart';

  @override
  String get birthDetails => 'Birth Details';

  @override
  String get name => 'Name';

  @override
  String get dob => 'DOB';

  @override
  String get tob => 'TOB';

  @override
  String get place => 'Place';

  @override
  String get summary => 'Summary';

  @override
  String get planets => 'Planets';

  @override
  String get kundli => 'Kundli';

  @override
  String get divisions => 'Divisions';

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
  String get aspects => 'Aspects';

  @override
  String get lifeAreas => 'Life Areas';

  @override
  String get bhava => 'Bhava';

  @override
  String get chakras => 'Chakras';

  @override
  String get dashaActive => 'Dasha Active';

  @override
  String get lagna => 'Lagna';

  @override
  String get moon => 'Moon';

  @override
  String get sun => 'Sun';

  @override
  String get thisMonth => 'THIS MONTH';

  @override
  String get statement => 'Statement';

  @override
  String get all => 'All';

  @override
  String get credits => 'Credits';

  @override
  String get withdrawals => 'Withdrawals';

  @override
  String get bonus => 'Bonus';

  @override
  String get refunds => 'Refunds';

  @override
  String get requestWithdrawal => 'Request Withdrawal';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get amount => 'Amount';

  @override
  String get upiId => 'UPI ID';

  @override
  String get bankTransfer => 'Bank Transfer';

  @override
  String get accountHolderName => 'Account Holder Name';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get ifscCode => 'IFSC Code';

  @override
  String get submit => 'Submit';

  @override
  String get noTransactions => 'No transactions';

  @override
  String get withdrawalHistory => 'Withdrawal History';

  @override
  String get typeGuidance => 'Type your guidance...';

  @override
  String get sessionEnded => 'Session Ended';

  @override
  String get endChat => 'End Chat?';

  @override
  String get endChatConfirm => 'Are you sure you want to end this session?';

  @override
  String get activeNow => 'Active now';

  @override
  String get connecting => 'Connecting...';

  @override
  String get clientKundli => 'CLIENT KUNDLI';

  @override
  String get earned => 'Earned';

  @override
  String get connected => 'CONNECTED';

  @override
  String get endCall => 'End Call';

  @override
  String get endStream => 'End Stream';

  @override
  String get endStreamConfirm => 'End live stream?';

  @override
  String get goLiveBtn => 'Go Live';

  @override
  String get viewers => 'Viewers';

  @override
  String get peak => 'Peak';

  @override
  String get gifts => 'Gifts';

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
  String get retry => 'Retry';

  @override
  String get send => 'Send';

  @override
  String get refresh => 'Refresh';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data available';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get logout => 'Logout';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get kycSubmit => 'Submit KYC';

  @override
  String get kycPending => 'KYC Under Review';

  @override
  String get kycRejected => 'KYC Rejected';

  @override
  String get notifications => 'Notifications';

  @override
  String get biometricLogin => 'Biometric Login';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get totalCredit => 'Total Credit';

  @override
  String get totalDebit => 'Total Debit';

  @override
  String get allTypes => 'All types';

  @override
  String get prev => 'Prev';

  @override
  String get next => 'Next';

  @override
  String get page => 'Page';

  @override
  String get allInsights => 'All Insights';

  @override
  String get yourCompleteReading => 'YOUR COMPLETE READING';

  @override
  String get expertEngines => 'expert engines';

  @override
  String get eachInsightConsultation => 'Each insight is a complete consultation';

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
  String get deptReports => 'Dept Reports';

  @override
  String get specialistAnalysesDesc => '15 specialist analyses — Career, Wealth, Health, Love & more';

  @override
  String get matchTwoChartsDesc => 'Match two charts — Ashtakoot, Navamsa, Transit timing & more';

  @override
  String get todaysForecast => 'Today\'s Forecast';

  @override
  String get dailyProbability => 'Daily probability forecast for any chart';

  @override
  String get engCareer => 'Career & Job';

  @override
  String get engBusiness => 'Business & Startup';

  @override
  String get engEducation => 'Education & Learning';

  @override
  String get engLifePath => 'Life Path & Luck';

  @override
  String get engWealth => 'Wealth & Finance';

  @override
  String get engDebt => 'Debt & Recovery';

  @override
  String get engProperty => 'Property & Assets';

  @override
  String get engLegal => 'Legal & Disputes';

  @override
  String get engLove => 'Love & Romance';

  @override
  String get engMarriage => 'Marriage & Family';

  @override
  String get engKundliMilan => 'Kundli Milan';

  @override
  String get engRelationship => 'Relationship Intel';

  @override
  String get engLoveCompat => 'Love Compatibility';

  @override
  String get engChildProb => 'Child Probability';

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
  String get decline => 'Decline';

  @override
  String get accept => 'Accept';

  @override
  String get endSession => 'End Session';

  @override
  String get enterChat => 'Enter Chat';

  @override
  String get inProgress => 'In Progress';

  @override
  String get requestDeclined => 'Request declined';

  @override
  String get noRequests => 'No requests';

  @override
  String get tapViewChat => 'Tap to view chat history';

  @override
  String get tapViewCall => 'Tap to view call details';

  @override
  String get consultation => 'consultation';

  @override
  String get charged => 'Charged';

  @override
  String get messages => 'Messages';

  @override
  String get duration => 'Duration';

  @override
  String get rate => 'Rate';

  @override
  String get callDetails => 'Call Details';

  @override
  String get yourEarning => 'Your Earning';

  @override
  String get totalCharged => 'Total Charged';
  @override
  String get activeDoshas => 'Active Doshas';

  @override
  String get activeYogas => 'Active Yogas';

  @override
  String get allDoshas => 'ALL DOSHAS';

  @override
  String get areasToNurture => 'Areas to Nurture';

  @override
  String get basedOnPlanetStrengths => 'Based on planetary strengths';

  @override
  String get basedOnTransits => 'Based on current transits';

  @override
  String get basis => 'Basis';

  @override
  String get beneficAspects => 'Benefic Aspects';

  @override
  String get bestWindows => 'BEST WINDOWS';

  @override
  String get bhakootAxis => 'Bhakoot Axis';

  @override
  String get cancellation => 'Cancellation';

  @override
  String get cancellationFactors => 'Cancellation Factors';

  @override
  String get cancellations => 'Cancellations';

  @override
  String get challengingPeriods => 'Challenging Periods';

  @override
  String get characterOverview => 'Character Overview';

  @override
  String get combinedFertility => 'Combined Fertility';

  @override
  String get combust => 'Combust';

  @override
  String get confidence => 'CONFIDENCE';

  @override
  String get contact => 'Contact';

  @override
  String get copy => 'COPY';

  @override
  String get currentPlanetPositions => 'Current planet positions';

  @override
  String get d7Saptamsa => 'D7 Saptamsa';

  @override
  String get dashaSync => 'Dasha Sync';

  @override
  String get daughter => 'Daughter';

  @override
  String get debilitated => 'Debilitated';

  @override
  String get detailedSummary => 'Detailed Summary';

  @override
  String get discussWithAI => 'DISCUSS WITH AI';

  @override
  String get dominantPlanet => 'Dominant Planet';

  @override
  String get effect => 'Effect';

  @override
  String get exalted => 'Exalted';

  @override
  String get factors => 'Factors';

  @override
  String get favorablePeriodAdvice => 'Favorable period';

  @override
  String get favorablePeriods => 'Favorable Periods';

  @override
  String get genderExplanation => 'Gender Explanation';

  @override
  String get genderTendency => 'Gender Tendency';

  @override
  String get grantPermissions => 'Grant Permissions';

  @override
  String get health => 'Overall Health';

  @override
  String get herMoon => 'Her Moon';

  @override
  String get hisMoon => 'His Moon';

  @override
  String get house => 'House';

  @override
  String get inFifth => 'In 5th';

  @override
  String get ketuContacts => 'Ketu Contacts';

  @override
  String get key => 'Key';

  @override
  String get keyHouses => 'Key Houses';

  @override
  String get keyInsights => 'Key Insights';

  @override
  String get keyPlanets => 'Key Planets';

  @override
  String get kundliMilan => 'Kundli Milan';

  @override
  String get lifeAreaPredictions => 'Life Area Predictions';

  @override
  String get maleficAspects => 'Malefic Aspects';

  @override
  String get manifestation => 'Manifestation';

  @override
  String get milan => 'Milan';

  @override
  String get mitigation => 'Mitigation';

  @override
  String get moonSignCompat => 'Moon Sign Compatibility';

  @override
  String get nakshatraCompat => 'Nakshatra Compatibility';

  @override
  String get navigation => 'Navigation';

  @override
  String get nextFavorableWindow => 'Next Favorable Window';

  @override
  String get noCharts => 'No charts';

  @override
  String get noClassicalYogas => 'Success comes from consistent effort.';

  @override
  String get noYogasActive => 'No active yogas in this chart.';

  @override
  String get notesSaved => 'Notes saved';

  @override
  String get numberExplanation => 'Number Explanation';

  @override
  String get occupants => 'Occupants';

  @override
  String get overallVerdict => 'Overall Verdict';

  @override
  String get overlappingWindows => 'Overlapping Marriage Windows';

  @override
  String get past => 'past';

  @override
  String get pastLifeIndication => 'Past Life Indication';

  @override
  String get planet => 'Planet';

  @override
  String get planetPositions => 'Planet Placements';

  @override
  String get potentialStrengths => 'Potential Strengths';

  @override
  String get primaryArchetype => 'PRIMARY ARCHETYPE';

  @override
  String get probableNumber => 'Probable Number';

  @override
  String get rahuContacts => 'Rahu Contacts';

  @override
  String get rashi => 'Rashi Predictions';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get relationshipGuidance => 'Relationship Guidance';

  @override
  String get remedies => 'REMEDY';

  @override
  String get retrograde => 'Retrograde';

  @override
  String get ruledBy => 'Ruled by';

  @override
  String get running => 'RUNNING';

  @override
  String get scoreComponents => 'Score Components';

  @override
  String get selectChartsForMilan => 'Select 2 Charts';

  @override
  String get selectMultiCharts => 'Select Charts';

  @override
  String get selectTwoCharts => 'Select 2 Charts for Matching';

  @override
  String get sign => 'Sign';

  @override
  String get son => 'Son';

  @override
  String get soulCareerAlign => 'Soul ↔ Career Alignment';

  @override
  String get startKundliMilan => 'Start Kundli Milan';

  @override
  String get startSession => 'Start Session';

  @override
  String get strength => 'Strength';

  @override
  String get strengths => 'Strengths';

  @override
  String get todaysTransitChart => 'Transit Chart';

  @override
  String get topActiveDoshas => 'TOP ACTIVE DOSHAS';

  @override
  String get topOpportunities => 'TOP AREAS';

  @override
  String get topRisks => 'TOP RISKS';

  @override
  String get totalChallengePenalty => 'Total Challenge Penalty';

  @override
  String get totalDoshaPenalty => 'Total Dosha Penalty';

  @override
  String get transitMarriageWindows => 'Transit Marriage Windows';

  @override
  String get value => 'Value';

  @override
  String get vargottama => 'Vargottama';

  @override
  String get venusContacts => 'Venus Contacts';

  @override
  String get weaknesses => 'Weaknesses';

  @override
  String get worstWindows => 'WORST WINDOWS';

  @override
  String get yogaAnalysis => 'Yoga Analysis';
  @override
  String get unlocked => 'Unlocked!';

  @override
  String get lessThanOneMin => 'Less than 1 minute remaining';

}
