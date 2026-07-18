// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

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
  String get endChatConfirm =>
      'இந்த அரட்டை அமர்வை நிச்சயமாக முடிக்க விரும்புகிறீர்களா?';

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
  String get astrologerUnavailable =>
      'ஜோதிடர் கிடைக்கவில்லை. ஸ்ட்ரீம் முடிகிறது.';

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
  String get english => 'English';

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
