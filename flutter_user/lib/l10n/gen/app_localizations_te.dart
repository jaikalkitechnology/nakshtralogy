// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appName => 'నక్షత్రలాజీ';

  @override
  String get cosmicJourneyAwaits => 'మీ విశ్వ ప్రయాణం వేచి ఉంది';

  @override
  String get home => 'హోమ్';

  @override
  String get astrologers => 'జ్యోతిష్కులు';

  @override
  String get services => 'సేవలు';

  @override
  String get wallet => 'వాలెట్';

  @override
  String get profile => 'ప్రొఫైల్';

  @override
  String get live => 'లైవ్';

  @override
  String get kundli => 'కుండలి';

  @override
  String get chat => 'చాట్';

  @override
  String get call => 'కాల్';

  @override
  String get video => 'వీడియో';

  @override
  String get signIn => 'సైన్ ఇన్';

  @override
  String get createAccount => 'ఖాతా సృష్టించు';

  @override
  String get email => 'ఇమెయిల్';

  @override
  String get password => 'పాస్‌వర్డ్';

  @override
  String get confirmPassword => 'పాస్‌వర్డ్ నిర్ధారించు';

  @override
  String get fullName => 'పూర్తి పేరు';

  @override
  String get phone => 'ఫోన్ (ఐచ్ఛికం)';

  @override
  String get forgotPassword => 'పాస్‌వర్డ్ మర్చిపోయారా?';

  @override
  String get careerSummary => 'Career Summary';

  @override
  String get phase => 'Phase';

  @override
  String get confidenceLabel => 'Confidence';

  @override
  String get careerScores => 'Career Scores';

  @override
  String get stabilityLabel => 'Stability';

  @override
  String get growthLabel => 'Growth';

  @override
  String get gradeExcellent => 'Excellent';

  @override
  String get gradeGood => 'Good';

  @override
  String get gradeAverage => 'Average';

  @override
  String get gradeBelowAvg => 'Below Avg';

  @override
  String get gradeWeak => 'Weak';

  @override
  String get careerTypeDomain => 'Career & Domain';

  @override
  String get careerTimeline => 'Career Timeline';

  @override
  String dashaLabel(Object dasha) {
    return 'Dasha: ${dasha}';
  }

  @override
  String get improvementSuggestions => 'Improvement Suggestions';

  @override
  String get chartDetails => 'Chart Details';

  @override
  String get keyHousesCareer => 'Key Houses (Career)';

  @override
  String get keyCareerPlanets => 'Key Career Planets';

  @override
  String get empty => 'Empty';

  @override
  String get guna => 'Guna';

  @override
  String get dasha => 'Dasha';

  @override
  String get satwik => 'Satwik';

  @override
  String get rajasik => 'Rajasik';

  @override
  String get tamasik => 'Tamasik';

  @override
  String get charGroupCorePersonality => 'Core Personality';

  @override
  String get charGroupTrustHonesty => 'Trust & Honesty';

  @override
  String get charGroupLoyaltyCommitment => 'Loyalty & Commitment';

  @override
  String get charGroupStrategicPrivacy => 'Strategic & Privacy';

  @override
  String get charGroupFinancial => 'Financial';

  @override
  String get charGroupAngerConflict => 'Anger & Conflict';

  @override
  String get charGroupMoralDharmic => 'Moral & Dharmic';

  @override
  String get charGroupIntellectCommunication => 'Intellect & Communication';

  @override
  String get charGroupEmotionalProfile => 'Emotional Profile';

  @override
  String get charGroupMentalHealth => 'Mental Health';

  @override
  String get charGroupRomantic => 'Romantic';

  @override
  String get charGroupMarriageFamily => 'Marriage & Family';

  @override
  String get charGroupOverallLife => 'Overall Life';

  @override
  String get grahaDrishti => 'Graha Drishti (Planet Aspects)';

  @override
  String get grahaDrishtiSubtitle => 'Who aspects whom (%)';

  @override
  String get lagnaAspectsReceived => 'Lagna Aspects Received';

  @override
  String get rashiDrishti => 'Rashi Drishti (Sign Aspects)';

  @override
  String get shadbalaRupas => 'rupas';

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
  String bhavaSignLord(Object sign, Object lord) {
    return '${sign} • Lord: ${lord}';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: ${value}';
  }

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
  String bavSubtitle(Object total, Object score) {
    return 'Total: ${total} rekhas • At natal sign: ${score}';
  }

  @override
  String get today => 'Today';

  @override
  String gocharTransitScores(Object date) {
    return 'Gochar (Transit Scores) — ${date}';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'Native Moon: ${sign}';
  }

  @override
  String get gocharBest => 'BEST';

  @override
  String get gocharWorst => 'WORST';

  @override
  String copiedOpening(Object ai) {
    return 'Copied! Opening ${ai}...';
  }

  @override
  String get openLink => 'OPEN ↗';

  @override
  String get discussReportWithAI => 'DISCUSS THIS REPORT WITH AI';

  @override
  String get reliabilityHigh => 'High reliability';

  @override
  String get reliabilityModerate => 'Moderate reliability';

  @override
  String get reliabilityLow => 'Lower — guidance only';

  @override
  String get reliabilityGoodEdu => 'Good reliability · D-24 verified';

  @override
  String get relationshipWord => 'Relationship';

  @override
  String get intelligenceWord => 'Intelligence';

  @override
  String get relationshipIntelligence => 'RELATIONSHIP INTELLIGENCE';

  @override
  String get typeLabel => 'TYPE';

  @override
  String get trustLabel => 'TRUST';

  @override
  String get dhokaRisk => 'DHOKA RISK';

  @override
  String get powerLabel => 'Power';

  @override
  String get integrity => 'Integrity';

  @override
  String get warmth => 'Warmth';

  @override
  String get trustWord => 'Trust';

  @override
  String get assertLabel => 'Assert';

  @override
  String get character => 'Character';

  @override
  String get love => 'Love';

  @override
  String get businessWord => 'Business';

  @override
  String get karmic => 'Karmic';

  @override
  String get enmityRisk => 'Enmity Risk';

  @override
  String get hdrChartProfiles => 'Chart Profiles';

  @override
  String get hdrPairwiseAnalysis => 'Pairwise Analysis';

  @override
  String get hdrCriticalPatterns => 'Critical Patterns';

  @override
  String get hdrGroupRecommendations => 'Group Recommendations';

  @override
  String get sharedPractices => 'SHARED PRACTICES';

  @override
  String get hdrIndividualGuidance => 'Individual Guidance';

  @override
  String get growthAreas => 'GROWTH AREAS';

  @override
  String get hdrCoreTheme => 'Core Theme';

  @override
  String get growthOriented => 'GROWTH-ORIENTED';

  @override
  String get groupTheme => 'GROUP THEME';

  @override
  String get compatibility => 'COMPATIBILITY';

  @override
  String get unifiedScoreLabel => 'UNIFIED SCORE';

  @override
  String get ashtakoot => 'ASHTAKOOT';

  @override
  String get probability => 'PROBABILITY';

  @override
  String get hdrAshtakootSummary => 'Ashtakoot Summary';

  @override
  String get hdrGunBreakdown => '8 Gun Breakdown';

  @override
  String get hdrMangalDosh => 'Mangal Dosh';

  @override
  String get hdrD9CrossChart => 'D-9 Cross-Chart';

  @override
  String get d9Compatibility => 'D-9 COMPATIBILITY';

  @override
  String get hdrDomainCompatibility => 'Domain Compatibility';

  @override
  String get emotional => 'Emotional';

  @override
  String get intellectual => 'Intellectual';

  @override
  String get spiritual => 'Spiritual';

  @override
  String get financial => 'Financial';

  @override
  String get domestic => 'Domestic';

  @override
  String get communicationWord => 'Communication';

  @override
  String get sharedDharma => 'Shared Dharma';

  @override
  String get familyCreation => 'Family Creation';

  @override
  String get hdrMarriageTiming => 'Marriage Timing';

  @override
  String get jointMarriageWindows => 'Joint Marriage Windows';

  @override
  String get engagementWindows => 'Engagement Windows';

  @override
  String get recommendedLabel => 'Recommended';

  @override
  String get hdrKeyRisks => 'Key Risks';

  @override
  String get hdrFinalVerdict => 'Final Verdict';

  @override
  String get marriageVerdict => 'MARRIAGE VERDICT';

  @override
  String get educationWord => 'Education';

  @override
  String get learningSuffix => '& Learning';

  @override
  String get coreEducationScores => 'CORE EDUCATION SCORES';

  @override
  String get academicSuccess => 'ACADEMIC SUCCESS';

  @override
  String get learningCapacity => 'LEARNING CAPACITY';

  @override
  String get memory => 'MEMORY';

  @override
  String get intelligence => 'INTELLIGENCE';

  @override
  String get research => 'RESEARCH';

  @override
  String get hdrIntellectualProfile => 'Intellectual Profile';

  @override
  String get learningSignature => 'LEARNING SIGNATURE';

  @override
  String get hdrSubjectKaraka => 'Subject Karaka';

  @override
  String get hdrHouseFoundations => 'House Foundations';

  @override
  String get hdrMercuryJupiter => 'Mercury & Jupiter';

  @override
  String get hdrEducationYogas => 'Education Yogas';

  @override
  String get hdrDivisionalValidation => 'Divisional Validation';

  @override
  String get standing => 'STANDING';

  @override
  String get hdrSubjectRanking => 'Subject Ranking';

  @override
  String get hdrDegreeLikelihood => 'Degree Likelihood';

  @override
  String get hdrStudyPeriods => 'Study Periods';

  @override
  String get earlySchooling => 'Early Schooling';

  @override
  String get higherEducation => 'Higher Education';

  @override
  String get postgradResearch => 'Postgrad · Research';

  @override
  String get hdrLearningPreferences => 'Learning Preferences';

  @override
  String get hdrChallengesGifts => 'Challenges & Gifts';

  @override
  String get challenges => 'CHALLENGES';

  @override
  String get cognitiveGifts => 'COGNITIVE GIFTS';

  @override
  String get naturalAbilities => 'NATURAL ABILITIES';

  @override
  String get hdrSaraswatiRemedies => 'Saraswati Remedies';

  @override
  String get studentVerdict => 'STUDENT VERDICT';

  @override
  String get educationCareerLinkage => 'EDUCATION → CAREER LINKAGE';

  @override
  String get startupSuffix => '& Startup';

  @override
  String get coreBusinessScores => 'CORE BUSINESS SCORES';

  @override
  String get overallBusiness => 'OVERALL BUSINESS';

  @override
  String get ventureSuccess => 'VENTURE SUCCESS';

  @override
  String get eleventhHouse => '11TH HOUSE';

  @override
  String get gains => 'GAINS';

  @override
  String get investor => 'INVESTOR';

  @override
  String get hdrFounderArchetype => 'Founder Archetype';

  @override
  String get hdrTenthEleventhHouses => '10th & 11th Houses';

  @override
  String get hdrBusinessYogas => 'Business Yogas';

  @override
  String get hdrRecommendedDomains => 'Recommended Domains';

  @override
  String get hdrBusinessStyle => 'Business Style';

  @override
  String get hdrFounderSkills => 'Founder Skills';

  @override
  String get hdrFundingProfile => 'Funding Profile';

  @override
  String get recommendedPath => 'RECOMMENDED PATH';

  @override
  String get investorAttract => 'INVESTOR ATTRACT';

  @override
  String get familyBacking => 'FAMILY BACKING';

  @override
  String get hybridViability => 'HYBRID VIABILITY';

  @override
  String get launchWindow => 'Launch Window';

  @override
  String get scaleWindow => 'Scale Window';

  @override
  String get hdrBusinessRisks => 'Business Risks';

  @override
  String get recoveryCapacity => 'RECOVERY CAPACITY';

  @override
  String get hdrRemediesSolutions => 'Remedies & Solutions';

  @override
  String get aiConnectionLost => 'Connection lost. Please try again.';

  @override
  String get aiSomethingWrong => 'Something went wrong';

  @override
  String get aiNoResponse => 'No response';

  @override
  String get aiConnectionError => 'Connection error. Please try again.';

  @override
  String get aiAutoDetect => 'Auto-detect';

  @override
  String aiAutoArrow(String lang) {
    return 'Auto → ${lang}';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'Language: ${lang}';
  }

  @override
  String get aiNoBirthCharts => 'No birth charts found';

  @override
  String get aiCreateChartFirst => 'Create a birth chart first to chat with AI';

  @override
  String get aiSelectChartBegin => 'Select a birth chart to begin analysis';

  @override
  String aiAnalyzingName(String name) {
    return 'Analyzing: ${name}';
  }

  @override
  String get aiChange => 'Change';

  @override
  String get aiAnalyzingChart => 'Analyzing your chart...';

  @override
  String get aiAskStarsHint => 'Ask the stars anything...';

  @override
  String get aiSuggestedFollowups => 'Suggested follow-ups';

  @override
  String get aiThinking => 'Thinking...';

  @override
  String get aiThanks => 'Thanks!';

  @override
  String get aiFeedbackNoted => 'Feedback noted';

  @override
  String get svcAll => 'All';

  @override
  String get svcNoServices => 'No services available';

  @override
  String get svcFree => 'FREE';

  @override
  String get astroFailedStartCall => 'Failed to start call';

  @override
  String get astroFailedStartChat => 'Failed to start chat';

  @override
  String astroErrorDetail(String error) {
    return 'Error: ${error}';
  }

  @override
  String get astroExperience => 'Experience';

  @override
  String get astroSessions => 'Sessions';

  @override
  String get astroMinutes => 'Minutes';

  @override
  String get astroAbout => 'About';

  @override
  String get astroLanguages => 'Languages';

  @override
  String get astroRateCard => 'Rate Card';

  @override
  String get astroVoice => 'Voice';

  @override
  String astroReviews(int count) {
    return 'Reviews (${count})';
  }

  @override
  String get astroNoReviews => 'No reviews yet';

  @override
  String get astroAnonymous => 'Anonymous';

  @override
  String get forgotPasswordSubtitle => 'Enter your email and we\'ll send you\na link to reset your password.';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => 'Resend Link';

  @override
  String get sendResetLink => 'రీసెట్ లింక్ పంపు';

  @override
  String get backToSignIn => 'సైన్ ఇన్‌కు తిరిగి వెళ్ళు';

  @override
  String get dontHaveAccount => 'ఖాతా లేదా?';

  @override
  String get alreadyHaveAccount => 'ఇప్పటికే ఖాతా ఉందా?';

  @override
  String get continueGoogle => 'Google తో కొనసాగించు';

  @override
  String get required => 'అవసరం';

  @override
  String get minSixChars => 'కనీసం ౬ అక్షరాలు';

  @override
  String get passwordsMismatch => 'పాస్‌వర్డ్‌లు సరిపోలడం లేదు';

  @override
  String get validEmailRequired => 'చెల్లుబాటు అయ్యే ఇమెయిల్ అవసరం';

  @override
  String get loginFailed => 'లాగిన్ విఫలమైంది';

  @override
  String get signupFailed => 'సైనప్ విఫలమైంది';

  @override
  String get welcomeBack => 'తిరిగి స్వాగతం';

  @override
  String get todaysHoroscope => 'ఈరోజు జాతకం';

  @override
  String get todaysRashi => 'ఈరోజు రాశి';

  @override
  String get tapDetails => 'వివరాల కోసం నొక్కండి';

  @override
  String get allServices => 'అన్ని సేవలు';

  @override
  String get seeAll => 'అన్నీ చూడండి';

  @override
  String get topAstrologers => 'అగ్ర జ్యోతిష్కులు';

  @override
  String get onlineExperts => 'సంప్రదింపుకు ఆన్‌లైన్ నిపుణులు';

  @override
  String get searchAstrologers => 'జ్యోతిష్కులను వెతకండి...';

  @override
  String get noAstrologersFound => 'జ్యోతిష్కులు కనుగొనబడలేదు';

  @override
  String get online => 'ఆన్‌లైన్';

  @override
  String get offline => 'ఆఫ్‌లైన్';

  @override
  String get busy => 'బిజీ';

  @override
  String get perMin => '/నిమిషం';

  @override
  String get noCharts => 'ఇంకా జన్మ కుండలి లేదు';

  @override
  String get createFirst => 'మీ మొదటి జన్మ కుండలి సృష్టించండి';

  @override
  String get createChart => 'కుండలి సృష్టించు';

  @override
  String get newBirthChart => 'కొత్త జన్మ కుండలి';

  @override
  String get clientName => 'పేరు';

  @override
  String get gender => 'లింగం';

  @override
  String get male => 'పురుషుడు';

  @override
  String get female => 'స్త్రీ';

  @override
  String get other => 'ఇతరం';

  @override
  String get dateOfBirth => 'పుట్టిన తేదీ';

  @override
  String get timeOfBirth => 'పుట్టిన సమయం';

  @override
  String get birthPlace => 'పుట్టిన ప్రదేశం';

  @override
  String get birthPlaceHint => 'నగరం పేరు టైప్ చేయండి...';

  @override
  String get generateKundli => 'కుండలి రూపొందించు';

  @override
  String get birthChartCreated => 'జన్మ కుండలి సృష్టించబడింది!';

  @override
  String get deleteChart => 'కుండలి తొలగించాలా?';

  @override
  String get cannotUndo => 'దీన్ని రద్దు చేయలేరు.';

  @override
  String get primary => 'ప్రాథమిక';

  @override
  String get viewKundli => 'కుండలి చూడు';

  @override
  String get completeBirthChart => 'పూర్తి జన్మ కుండలి';

  @override
  String get birthDetails => 'జన్మ వివరాలు';

  @override
  String get name => 'పేరు';

  @override
  String get dob => 'పుట్టిన తేదీ';

  @override
  String get tob => 'పుట్టిన సమయం';

  @override
  String get place => 'ప్రదేశం';

  @override
  String get summary => 'సారాంశం';

  @override
  String get planets => 'గ్రహాలు';

  @override
  String get divisions => 'విభాగాలు';

  @override
  String get vimshottari => 'విమ్శోత్తరి';

  @override
  String get moola => 'మూల';

  @override
  String get gochar => 'గోచారం';

  @override
  String get dosh => 'దోషం';

  @override
  String get yoga => 'యోగం';

  @override
  String get shadbala => 'షడ్బలం';

  @override
  String get ashtakavarga => 'అష్టకవర్గం';

  @override
  String get aspects => 'దృష్టి';

  @override
  String get lifeAreas => 'జీవిత రంగాలు';

  @override
  String get bhava => 'భావం';

  @override
  String get chakras => 'చక్రాలు';

  @override
  String get dashaActive => 'దశ సక్రియం';

  @override
  String get lagna => 'లగ్నం';

  @override
  String get moon => 'చంద్రుడు';

  @override
  String get sun => 'సూర్యుడు';

  @override
  String get premiumSection => 'ప్రీమియం విభాగం';

  @override
  String get unlockReading => 'వివరమైన విశ్లేషణ చూడటానికి అన్‌లాక్ చేయండి.';

  @override
  String get unlock => 'అన్‌లాక్';

  @override
  String get retrograde => 'వక్రం';

  @override
  String get combust => 'అస్తం';

  @override
  String get vargottama => 'వర్గోత్తమం';

  @override
  String get exalted => 'ఉచ్చం';

  @override
  String get debilitated => 'నీచం';

  @override
  String get addBalance => 'బ్యాలెన్స్ జోడించు';

  @override
  String get amount => 'మొత్తం';

  @override
  String get walletBalance => 'వాలెట్ బ్యాలెన్స్';

  @override
  String get recharge => 'రీఛార్జ్';

  @override
  String get bonus => 'బోనస్';

  @override
  String get serviceLabel => 'సేవ';

  @override
  String get refund => 'రీఫండ్';

  @override
  String get noTransactions => 'లావాదేవీలు లేవు';

  @override
  String get editProfile => 'ప్రొఫైల్ మార్చు';

  @override
  String get savedAstrologers => 'సేవ్ చేసిన జ్యోతిష్కులు';

  @override
  String get noSavedAstrologers => 'ఇంకా సేవ్ చేసిన జ్యోతిష్కులు లేరు';

  @override
  String get myOrders => 'నా ఆర్డర్లు';

  @override
  String get communicationHistory => 'సంభాషణ చరిత్ర';

  @override
  String get chatHistory => 'చాట్ చరిత్ర';

  @override
  String get callHistory => 'కాల్ చరిత్ర';

  @override
  String get logout => 'లాగ్‌అవుట్';

  @override
  String get chatMessages => 'చాట్ సందేశాలు';

  @override
  String get typeMessage => 'సందేశం టైప్ చేయండి...';

  @override
  String get sessionEnded => 'సెషన్ ముగిసింది';

  @override
  String get endChat => 'చాట్ ముగించాలా?';

  @override
  String get endChatConfirm => 'ఈ చాట్ సెషన్‌ను నిజంగా ముగించాలనుకుంటున్నారా?';

  @override
  String get sendPhoto => 'ఫోటో పంపు';

  @override
  String get sendPDF => 'PDF పంపు';

  @override
  String get upload => 'అప్‌లోడ్';

  @override
  String get fileNotFound => 'ఫైల్ కనుగొనబడలేదు';

  @override
  String get voiceCall => 'వాయిస్ కాల్';

  @override
  String get videoCall => 'వీడియో కాల్';

  @override
  String get ringing => 'రింగ్ అవుతోంది...';

  @override
  String get connected => 'కనెక్ట్ అయింది';

  @override
  String get endCall => 'కాల్ ముగించు';

  @override
  String get mute => 'మ్యూట్';

  @override
  String get unmute => 'అన్‌మ్యూట్';

  @override
  String get speaker => 'స్పీకర్';

  @override
  String get camera => 'కెమెరా';

  @override
  String get flip => 'ఫ్లిప్';

  @override
  String get liveStreams => 'లైవ్ స్ట్రీమ్‌లు';

  @override
  String get noLiveStreams => 'ప్రస్తుతం లైవ్ స్ట్రీమ్‌లు లేవు';

  @override
  String get astrologerUnavailable =>
      'జ్యోతిష్కుడు అందుబాటులో లేరు. స్ట్రీమ్ ముగుస్తోంది.';

  @override
  String get streamEnded => 'స్ట్రీమ్ ముగిసింది';

  @override
  String get superChat => 'సూపర్ చాట్';

  @override
  String get sendGift => 'బహుమతి పంపు';

  @override
  String get goBack => 'వెనక్కి వెళ్ళు';

  @override
  String get appPermissions => 'యాప్ అనుమతులు';

  @override
  String get grantPermissions => 'అనుమతులు ఇవ్వండి';

  @override
  String get skipForNow => 'ప్రస్తుతానికి వదిలేయండి';

  @override
  String get microphone => 'మైక్రోఫోన్';

  @override
  String get notifications => 'నోటిఫికేషన్లు';

  @override
  String get storage => 'స్టోరేజ్';

  @override
  String get ok => 'సరే';

  @override
  String get cancel => 'రద్దు';

  @override
  String get save => 'సేవ్';

  @override
  String get edit => 'మార్చు';

  @override
  String get delete => 'తొలగించు';

  @override
  String get retry => 'మళ్ళీ ప్రయత్నించు';

  @override
  String get send => 'పంపు';

  @override
  String get refresh => 'రిఫ్రెష్';

  @override
  String get loading => 'లోడ్ అవుతోంది...';

  @override
  String get noData => 'డేటా అందుబాటులో లేదు';

  @override
  String get error => 'లోపం';

  @override
  String get success => 'విజయం';

  @override
  String get selectLanguage => 'భాష ఎంచుకోండి';

  @override
  String get language => 'భాష';

  @override
  String get english => 'English';

  @override
  String get myDetails => 'నా వివరాలు';

  @override
  String get myKundlis => 'నా కుండలీలు';

  @override
  String get walletRecharge => 'వాలెట్ & రీఛార్జ్';

  @override
  String get consultationHistory => 'సంప్రదింపు చరిత్ర';

  @override
  String get helpSupport => 'సహాయం & మద్దతు';

  @override
  String get biometricLogin => 'బయోమెట్రిక్ లాగిన్';

  @override
  String get pastVoiceConsultations => 'గత వాయిస్ సంప్రదింపులు';

  @override
  String get pastTextConversations => 'గత టెక్స్ట్ సంభాషణలు';

  @override
  String get comingSoon => 'త్వరలో వస్తోంది';

  @override
  String get totalCredit => 'మొత్తం క్రెడిట్';

  @override
  String get totalDebit => 'మొత్తం డెబిట్';

  @override
  String get statement => 'స్టేట్‌మెంట్';

  @override
  String get allTypes => 'అన్ని రకాలు';

  @override
  String get prev => 'మునుపటి';

  @override
  String get next => 'తదుపరి';

  @override
  String get allInsights => 'అన్ని విశ్లేషణలు';

  @override
  String get yourCompleteReading => 'మీ పూర్తి పఠనం';

  @override
  String get expertEngines => 'నిపుణుల ఇంజిన్లు';

  @override
  String get eachInsightConsultation => 'ప్రతి విశ్లేషణ ఒక పూర్తి సంప్రదింపు';

  @override
  String get engines => 'ఇంజిన్లు';

  @override
  String get dataPoints => 'డేటా పాయింట్లు';

  @override
  String get singleChart => 'సింగిల్';

  @override
  String get careerPurpose => 'కెరీర్ & ఉద్దేశ్యం';

  @override
  String get wealthAssets => 'సంపద & ఆస్తులు';

  @override
  String get loveRelationships => 'ప్రేమ & సంబంధాలు';

  @override
  String get healthWellness => 'ఆరోగ్యం & సంక్షేమం';

  @override
  String get soulKarma => 'ఆత్మ & కర్మ';

  @override
  String get specialistReports => 'నిపుణుల నివేదికలు';

  @override
  String get searchByNameSpeciality => 'పేరు, ప్రత్యేకత ద్వారా వెతకండి...';

  @override
  String get sortedByRating => 'రేటింగ్ ప్రకారం';

  @override
  String get initiatingChat => 'చాట్ ప్రారంభమవుతోంది...';

  @override
  String get startingCall => 'కాల్ ప్రారంభమవుతోంది...';

  @override
  String get yrs => 'సంవత్సరాలు';

  @override
  String get chatWithAISpecialist => 'AI నిపుణులతో చాట్ చేయండి';

  @override
  String get tapToStart => 'ప్రారంభించడానికి ట్యాప్ చేయండి';

  @override
  String get astrologer => 'జ్యోతిష్కుడు';

  @override
  String get reports => 'నివేదికలు';

  @override
  String get milan => 'మిలన్';

  @override
  String get forecast => 'అంచనా';

  @override
  String get rashi => 'రాశి';

  @override
  String get jupiterFavorsBold => 'గురుడు ధైర్యమైన చర్యలకు అనుకూలం';

  @override
  String get careerIlluminated => 'మీ కెరీర్ రంగం ప్రకాశిస్తోంది — మీ అంతర్ దృష్టిని నమ్మండి.';

  @override
  String get todaysForecast => 'ఈరోజు అంచనా';

  @override
  String get engCareer => 'కెరీర్ & ఉద్యోగం';

  @override
  String get engBusiness => 'వ్యాపారం & స్టార్టప్';

  @override
  String get engEducation => 'విద్య & అభ్యాసం';

  @override
  String get engLifePath => 'జీవిత మార్గం & అదృష్టం';

  @override
  String get engWealth => 'సంపద & ఆర్థికం';

  @override
  String get engDebt => 'అప్పు & రికవరీ';

  @override
  String get engProperty => 'ఆస్తి & సంపత్తి';

  @override
  String get engLegal => 'న్యాయ & వివాదాలు';

  @override
  String get engLove => 'ప్రేమ & రొమాన్స్';

  @override
  String get engMarriage => 'వివాహం & కుటుంబం';

  @override
  String get engKundliMilan => 'కుండలి మిలన్';

  @override
  String get engRelationship => 'సంబంధ విశ్లేషణ';

  @override
  String get engLoveCompat => 'ప్రేమ అనుకూలత';

  @override
  String get engChildProb => 'సంతానం సంభావ్యత';

  @override
  String get engHealth => 'ఆరోగ్యం & సంక్షేమం';

  @override
  String get engMental => 'మానసిక & ఒత్తిడి';

  @override
  String get engCharacter => 'వ్యక్తిత్వ విశ్లేషణ';

  @override
  String get engPastLife => 'పూర్వజన్మ & కర్మ';

  @override
  String get engKarmaLink => 'కర్మ అనుబంధం';

  @override
  String get noChatSessions => 'ఇంకా చాట్ సెషన్లు లేవు';

  @override
  String get chatAppearHere => 'జ్యోతిష్కులతో మీ సంభాషణలు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get noCallsYet => 'ఇంకా కాల్‌లు లేవు';

  @override
  String get callAppearHere => 'జ్యోతిష్కులతో మీ కాల్ చరిత్ర ఇక్కడ కనిపిస్తుంది.';

  @override
  String get chatWith => 'తో చాట్';

  @override
  String get msgs => 'సందేశాలు';

  @override
  String get voiceCallLabel => 'వాయిస్ కాల్';

  @override
  String get videoCallLabel => 'వీడియో కాల్';

  @override
  String get pullToRefresh => 'రిఫ్రెష్ చేయడానికి కిందకు లాగండి';

  @override
  String get sessionExpired => 'సెషన్ ముగిసింది';

  @override
  String get connectionFailed => 'కనెక్షన్ విఫలం';

  @override
  String get callActive => 'కాల్ యాక్టివ్';

  @override
  String get lessThanOneMin => '1 నిమిషం కంటే తక్కువ మిగిలి ఉంది';

  @override
  String get noMessages => 'ఈ సెషన్‌లో సందేశాలు లేవు';

  @override
  String get gocharForAllSigns => 'అన్ని 12 రాశులకు ఈరోజు గోచారం';

  @override
  String get selectChart => 'విశ్లేషణ కోసం జాతకం ఎంచుకోండి';

  @override
  String get selectTwoCharts => 'రెండు జాతకాలు ఎంచుకోండి';

  @override
  String get analyzing => 'విశ్లేషణ జరుగుతోంది...';

  @override
  String get browseAstrologers => 'జ్యోతిష్కులను కనుగొనండి';

  @override
  String get probableNumber => 'సంభావ్య సంఖ్య';

  @override
  String get genderTendency => 'లింగ ధోరణి';

  @override
  String get son => 'కుమారుడు';

  @override
  String get daughter => 'కుమార్తె';

  @override
  String get occupants => 'నివాస గ్రహాలు';

  @override
  String get beneficAspects => 'శుభ దృష్టి';

  @override
  String get maleficAspects => 'పాప దృష్టి';

  @override
  String get nextFavorableWindow => 'తదుపరి అనుకూల సమయం';

  @override
  String get totalDoshaPenalty => 'మొత్తం దోష శిక్ష';

  @override
  String get cancellationFactors => 'రద్దు కారకాలు';

  @override
  String get combinedFertility => 'సంయుక్త సంతానోత్పత్తి సూచన';

  @override
  String get planetPositions => 'గ్రహ స్థానాలు';

  @override
  String get bestWindows => 'ఉత్తమ సమయాలు';

  @override
  String get worstWindows => 'ప్రతికూల సమయాలు';

  @override
  String get scoreComponents => 'స్కోర్ భాగాలు';

  @override
  String get topOpportunities => 'ప్రధాన అవకాశాలు';

  @override
  String get topRisks => 'ప్రధాన నష్టాలు';

  @override
  String get remedies => 'పరిహారాలు';

  @override
  String get keyInsights => 'ముఖ్య అంతర్దృష్టులు';

  @override
  String get overallVerdict => 'మొత్తం తీర్పు';

  @override
  String get venusContacts => 'శుక్ర సంపర్కాలు';

  @override
  String get contact => 'సంపర్కం';

  @override
  String get effect => 'ప్రభావం';

  @override
  String get moonSignCompat => 'చంద్ర రాశి అనుకూలత';

  @override
  String get hisMoon => 'అతని చంద్రుడు';

  @override
  String get herMoon => 'ఆమె చంద్రుడు';

  @override
  String get nakshatraCompat => 'నక్షత్ర అనుకూలత';

  @override
  String get ketuContacts => 'కేతు సంపర్కాలు';

  @override
  String get rahuContacts => 'రాహు సంపర్కాలు';

  @override
  String get pastLifeIndication => 'పూర్వజన్మ సూచన';

  @override
  String get totalChallengePenalty => 'మొత్తం సవాలు శిక్ష';

  @override
  String get manifestation => 'వ్యక్తీకరణ';

  @override
  String get cancellation => 'రద్దు';

  @override
  String get navigation => 'మార్గదర్శకత్వం';

  @override
  String get potentialStrengths => 'సంభావ్య బలాలు';

  @override
  String get areasToNurture => 'పెంపొందించాల్సిన రంగాలు';

  @override
  String get relationshipGuidance => 'సంబంధ మార్గదర్శకత్వం';

  @override
  String get detailedSummary => 'వివరమైన సారాంశం';

  @override
  String get discussWithAI => 'AI తో చర్చించండి';

  @override
  String get planet => 'గ్రహం';

  @override
  String get sign => 'రాశి';

  @override
  String get house => 'భావం';

  @override
  String get strength => 'బలం';

  @override
  String get copy => 'కాపీ';

  @override
  String get confidence => 'విశ్వాసం';

  @override
  String get d7Saptamsa => 'D7 సప్తాంశం';

  @override
  String get numberExplanation => 'సంఖ్య వివరణ';

  @override
  String get genderExplanation => 'లింగ వివరణ';

  @override
  String get inFifth => '5వ లో?';

  @override
  String get primaryArchetype => 'ప్రాథమిక ఆదర్శరూపం';

  @override
  String get mitigation => 'ఉపశమనం';

  @override
  String get soulCareerAlign => 'ఆత్మ ↔ కెరీర్ సమలేఖనం';

  @override
  String get favorablePeriods => 'అనుకూల కాలం';

  @override
  String get challengingPeriods => 'సవాలు కాలం';

  @override
  String get keyHouses => 'ముఖ్య భావాలు';

  @override
  String get keyPlanets => 'ముఖ్య గ్రహాలు';

  @override
  String get characterOverview => 'వ్యక్తిత్వ అవలోకనం';

  @override
  String get noYogasActive => 'ఈ జాతకంలో ప్రస్తుతం యోగాలు లేవు.';

  @override
  String get basedOnPlanetStrengths => 'గ్రహ బలాలు & భావ స్థానాల ఆధారంగా';

  @override
  String get basedOnTransits => 'ప్రస్తుత గ్రహ గోచారం ఆధారంగా';

  @override
  String get currentPlanetPositions => 'మీ రాశిని 1వ భావంగా భావించి ప్రస్తుత గ్రహ స్థానాలు';

  @override
  String get favorablePeriodAdvice => 'అనుకూల కాలం — కెరీర్ పెరుగుదల మరియు సంబంధాలపై దృష్టి పెట్టండి.';

  @override
  String get noClassicalYogas => 'శాస్త్రీయ విద్యా యోగాలు లేకుండా, విజయం స్థిరమైన కృషి ద్వారా వస్తుంది.';

  @override
  String get walletDeduction => 'మొత్తం మీ వాలెట్ నుండి తీసివేయబడుతుంది';

  @override
  String get bhakootAxis => 'భకూట్ అక్షం';

  @override
  String get basis => 'ఆధారం';

  @override
  String get selectChartsForMilan => 'మిలన్ కోసం 2 జాతకాలు ఎంచుకోండి';

  @override
  String get selectMultiCharts => '2-5 జాతకాలు ఎంచుకోండి';

  @override
  String get running => 'నడుస్తోంది';

  @override
  String get past => 'గతం';

  @override
  String get topActiveDoshas => 'టాప్ యాక్టివ్ దోషాలు';

  @override
  String get allDoshas => 'అన్ని దోషాలు';

  @override
  String get activeYogas => 'యాక్టివ్ యోగాలు';

  @override
  String get activeDoshas => 'యాక్టివ్ దోషాలు';

  @override
  String get yogaAnalysis => 'యోగ విశ్లేషణ';

  @override
  String get factors => 'కారకాలు';

  @override
  String get dominantPlanet => 'ప్రధాన గ్రహం';

  @override
  String get startSession => 'సెషన్ ప్రారంభించండి';

  @override
  String get notesSaved => 'నోట్స్ సేవ్ అయ్యాయి';

  @override
  String get unlocked => 'అన్‌లాక్! మీ రీడింగ్ ఆనందించండి.';

  @override
  String get todaysGochar => 'ఈరోజు గోచారం';

  @override
  String get todaysTransitChart => 'ఈరోజు గోచార చార్ట్';

  @override
  String get lifeAreaPredictions => 'జీవిత రంగ అంచనాలు';

  @override
  String get strengths => 'బలాలు';

  @override
  String get weaknesses => 'బలహీనతలు';

  @override
  String get ruledBy => 'అధిపతి';

  @override
  String get kundliMilan => 'కుండలి మిలన్';

  @override
  String get startKundliMilan => 'కుండలి మిలన్ ప్రారంభించండి';

  @override
  String get recommendations => 'సిఫార్సులు';

  @override
  String get cancellations => 'రద్దులు';

  @override
  String get dashaSync => 'దశా సింక్';

  @override
  String get transitMarriageWindows => 'గోచార వివాహ సమయాలు';

  @override
  String get overlappingWindows => 'అతిపాత వివాహ సమయాలు';

  @override
  String get overallStrength => 'మొత్తం బలం';

  @override
  String get stability => 'స్థిరత్వం';

  @override
  String get growth => 'వృద్ధి';

  @override
  String get clarity => 'స్పష్టత';

  @override
  String get recognition => 'గుర్తింపు';

  @override
  String get satisfaction => 'సంతృప్తి';

  @override
  String get verdict => 'తీర్పు';

  @override
  String get topRoles => 'ముఖ్య పాత్రలు';

  @override
  String get areasForGrowth => 'వృద్ధి రంగాలు';

  @override
  String get bestIndustries => 'ఉత్తమ పరిశ్రమలు';

  @override
  String get employment => 'ఉద్యోగం';

  @override
  String get entrepreneurship => 'వ్యవసాయదారిత్వం';

  @override
  String get freelance => 'ఫ్రీలాన్స్';

  @override
  String get portfolio => 'పోర్ట్‌ఫోలియో';

  @override
  String get burnoutRisk => 'అలసట ప్రమాదం';

  @override
  String get careerStagnation => 'వృత్తి స్తబ్ధత';

  @override
  String get workplaceConflict => 'కార్యస్థల ఘర్షణ';

  @override
  String get positioning => 'స్థాన నిర్ధారణ';

  @override
  String get skillDevelopment => 'నైపుణ్య అభివృద్ధి';

  @override
  String get network => 'నెట్‌వర్క్';

  @override
  String get visibility => 'కనిపింపు';

  @override
  String get lagnaLord => 'లగ్న అధిపతి';

  @override
  String get tenthLord => 'పదవ అధిపతి';

  @override
  String get lord => 'అధిపతి';

  @override
  String get lordPlacedIn => 'అధిపతి స్థితం';

  @override
  String get lordDignity => 'అధిపతి గౌరవం';

  @override
  String get d9Dignity => 'డి9 గౌరవం';

  @override
  String get careerAnalysis => 'కెరీర్ విశ్లేషణ';

  @override
  String get launchWindows => 'ప్రారంభ సమయాలు';

  @override
  String get peakWindows => 'శిఖర సమయాలు';

  @override
  String get promotionWindows => 'పదోన్నతి సమయాలు';

  @override
  String get riskWindows => 'ప్రమాద సమయాలు';

  @override
  String get timingWindows => 'సమయ విండోలు';

  @override
  String get careerRisks => 'వృత్తి ప్రమాదాలు';

  @override
  String get astrologicalRemedies => 'జ్యోతిష పరిహారాలు';

  @override
  String get practicalSolutions => 'ఆచరణాత్మక పరిష్కారాలు';

  @override
  String get analysisConfidence => 'విశ్లేషణ విశ్వసనీయత';

  @override
  String get careerArchetype => 'కెరీర్ ఆదిరూపం';

  @override
  String get workStructure => 'పని నిర్మాణం';

  @override
  String get teamLeadership => 'బృంద నాయకత్వం';

  @override
  String get idealEnvironment => 'ఆదర్శ వాతావరణం';

  @override
  String get idealOrgSize => 'ఆదర్శ సంస్థ పరిమాణం';

  @override
  String get fitScore => 'ఫిట్ స్కోర్';

  @override
  String get recommended => 'సిఫార్సు';

  @override
  String get divisionalValidation => 'విభాగ ధృవీకరణ';

  @override
  String get houseAnalysis => 'భావ విశ్లేషణ';

  @override
  String get jaiminiKarakas => 'జైమిని కారకాలు';

  @override
  String get copyFullReport => 'పూర్తి నివేదిక కాపీ చేయండి';

  @override
  String get reportCopied => 'నివేదిక కాపీ అయింది!';
}
