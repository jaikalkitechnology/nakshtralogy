// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appName => 'നക്ഷത്രലോജി';

  @override
  String get cosmicJourneyAwaits =>
      'നിങ്ങളുടെ പ്രാപഞ്ചിക യാത്ര കാത്തിരിക്കുന്നു';

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
  String get endChatConfirm =>
      'ഈ ചാറ്റ് സെഷന്‍ തീര്‍ച്ചയായും അവസാനിപ്പിക്കണമെന്ന് ഉറപ്പാണോ?';

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
  String get astrologerUnavailable =>
      'ജ്യോതിഷി ലഭ്യമല്ല. സ്ട്രീം അവസാനിക്കുന്നു.';

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
  String get english => 'English';

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
