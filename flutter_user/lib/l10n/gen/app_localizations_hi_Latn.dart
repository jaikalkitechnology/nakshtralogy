// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (Latin script) — Hinglish (`hi_Latn`).
class AppLocalizationsHiLatn extends AppLocalizations {
  AppLocalizationsHiLatn([String locale = 'hi_Latn']) : super(locale);

  @override
  String get appName => 'Nakshatralogy';

  @override
  String get cosmicJourneyAwaits => 'Aapki Cosmic Journey Shuru Hoti Hai';

  @override
  String get home => 'Home';

  @override
  String get astrologers => 'Jyotishi';

  @override
  String get services => 'Sevayein';

  @override
  String get wallet => 'Wallet';

  @override
  String get profile => 'Profile';

  @override
  String get live => 'Live';

  @override
  String get kundli => 'Kundli';

  @override
  String get chat => 'Chat';

  @override
  String get call => 'Call';

  @override
  String get video => 'Video';

  @override
  String get signIn => 'Sign In';

  @override
  String get createAccount => 'Account Banayein';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Password Confirm Karein';

  @override
  String get fullName => 'Poora Naam';

  @override
  String get phone => 'Phone (optional)';

  @override
  String get forgotPassword => 'Password Bhool Gaye?';

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
  String get gradeGood => 'Achha';

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
  String get grahaDrishtiSubtitle => 'Kaun kise dekhta hai (%)';

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
  String get today => 'Aaj';

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
  String get typeLabel => 'Type';

  @override
  String get trustLabel => 'Trust';

  @override
  String get dhokaRisk => 'Dhoka Risk';

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
  String get ashtakoot => 'Ashtakoot';

  @override
  String get probability => 'Probability';

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
  String get memory => 'Memory';

  @override
  String get intelligence => 'Intelligence';

  @override
  String get research => 'Research';

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
  String get challenges => 'Challenges';

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
  String get gains => 'Gains';

  @override
  String get investor => 'Investor';

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
  String get aiConnectionLost => 'Connection lost ho gaya. Please dobara try karein.';

  @override
  String get aiSomethingWrong => 'Kuch galat ho gaya';

  @override
  String get aiNoResponse => 'Koi response nahi';

  @override
  String get aiConnectionError => 'Connection error. Please dobara try karein.';

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
  String get aiNoBirthCharts => 'Koi birth chart nahi mila';

  @override
  String get aiCreateChartFirst => 'AI se chat karne ke liye pehle ek birth chart banayein';

  @override
  String get aiSelectChartBegin => 'Analysis shuru karne ke liye ek birth chart select karein';

  @override
  String aiAnalyzingName(String name) {
    return 'Analyzing: ${name}';
  }

  @override
  String get aiChange => 'Change';

  @override
  String get aiAnalyzingChart => 'Aapki chart analyze ho rahi hai...';

  @override
  String get aiAskStarsHint => 'Sitaron se kuch bhi poochhein...';

  @override
  String get aiSuggestedFollowups => 'Suggested follow-ups';

  @override
  String get aiThinking => 'Soch raha hai...';

  @override
  String get aiThanks => 'Thanks!';

  @override
  String get aiFeedbackNoted => 'Feedback note kar liya';

  @override
  String get svcAll => 'All';

  @override
  String get svcNoServices => 'Koi service available nahi';

  @override
  String get svcFree => 'FREE';

  @override
  String get astroFailedStartCall => 'Call shuru karne mein fail';

  @override
  String get astroFailedStartChat => 'Chat shuru karne mein fail';

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
  String get astroNoReviews => 'Abhi tak koi review nahi';

  @override
  String get astroAnonymous => 'Anonymous';

  @override
  String get forgotPasswordSubtitle => 'Apna email daalein — hum aapko password\nreset karne ke liye link bhejenge.';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => 'Link dobara bhejein';

  @override
  String get sendResetLink => 'Reset Link Bhejein';

  @override
  String get backToSignIn => 'Sign In Par Wapas';

  @override
  String get dontHaveAccount => 'Account nahi hai?';

  @override
  String get alreadyHaveAccount => 'Pehle se account hai?';

  @override
  String get continueGoogle => 'Google Se Continue Karein';

  @override
  String get required => 'Zaroori';

  @override
  String get minSixChars => 'Kam se kam 6 characters';

  @override
  String get passwordsMismatch => 'Passwords match nahi karte';

  @override
  String get validEmailRequired => 'Valid email zaroori hai';

  @override
  String get loginFailed => 'Login fail hua';

  @override
  String get signupFailed => 'Signup fail hua';

  @override
  String get welcomeBack => 'Wapas Aapka Swagat Hai';

  @override
  String get todaysHoroscope => 'AAJ KA RASHIFAL';

  @override
  String get todaysRashi => 'Aaj Ki Rashi';

  @override
  String get tapDetails => 'Details ke liye tap karein';

  @override
  String get allServices => 'Sabhi Sevayein';

  @override
  String get seeAll => 'SABHI DEKHEIN';

  @override
  String get topAstrologers => 'Top Jyotishi';

  @override
  String get onlineExperts => 'Online experts consultation ke liye taiyar';

  @override
  String get searchAstrologers => 'Jyotishi khojein...';

  @override
  String get noAstrologersFound => 'Koi jyotishi nahi mila';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get busy => 'Busy';

  @override
  String get perMin => '/min';

  @override
  String get noCharts => 'Abhi koi janam kundli nahi';

  @override
  String get createFirst => 'Apni pehli Janam Kundli banayein';

  @override
  String get createChart => 'Kundli Banayein';

  @override
  String get newBirthChart => 'Nayi Janam Kundli';

  @override
  String get clientName => 'Naam';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Purush';

  @override
  String get female => 'Stri';

  @override
  String get other => 'Anya';

  @override
  String get dateOfBirth => 'Janam Tithi';

  @override
  String get timeOfBirth => 'Janam Samay';

  @override
  String get birthPlace => 'Janam Sthan';

  @override
  String get birthPlaceHint => 'City ka naam type karein...';

  @override
  String get generateKundli => 'Kundli Banayein';

  @override
  String get birthChartCreated => 'Janam kundli ban gayi!';

  @override
  String get deleteChart => 'Kundli Hatayein?';

  @override
  String get cannotUndo => 'Yeh wapas nahi hoga.';

  @override
  String get primary => 'PRIMARY';

  @override
  String get viewKundli => 'Kundli Dekhein';

  @override
  String get completeBirthChart => 'Poori Janam Kundli';

  @override
  String get birthDetails => 'Janam Vivaran';

  @override
  String get name => 'Naam';

  @override
  String get dob => 'Janam Tithi';

  @override
  String get tob => 'Janam Samay';

  @override
  String get place => 'Sthan';

  @override
  String get summary => 'Summary';

  @override
  String get planets => 'Grah';

  @override
  String get divisions => 'Vibhag';

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
  String get aspects => 'Drishti';

  @override
  String get lifeAreas => 'Jeevan Kshetra';

  @override
  String get bhava => 'Bhava';

  @override
  String get chakras => 'Chakra';

  @override
  String get dashaActive => 'Dasha Active';

  @override
  String get lagna => 'Lagna';

  @override
  String get moon => 'Chandra';

  @override
  String get sun => 'Surya';

  @override
  String get premiumSection => 'Premium Section';

  @override
  String get unlockReading =>
      'Detailed analysis dekhne ke liye unlock karein.';

  @override
  String get unlock => 'Unlock';

  @override
  String get retrograde => 'Vakri';

  @override
  String get combust => 'Ast';

  @override
  String get vargottama => 'Vargottama';

  @override
  String get exalted => 'Uchcha';

  @override
  String get debilitated => 'Neech';

  @override
  String get addBalance => 'Balance Jodein';

  @override
  String get amount => 'Amount';

  @override
  String get walletBalance => 'Wallet Balance';

  @override
  String get recharge => 'Recharge';

  @override
  String get bonus => 'Bonus';

  @override
  String get serviceLabel => 'Seva';

  @override
  String get refund => 'Refund';

  @override
  String get noTransactions => 'Koi transaction nahi';

  @override
  String get editProfile => 'Profile Edit Karein';

  @override
  String get savedAstrologers => 'Save Kiye Jyotishi';

  @override
  String get noSavedAstrologers => 'Abhi koi saved jyotishi nahi';

  @override
  String get myOrders => 'Mere Orders';

  @override
  String get communicationHistory => 'Communication History';

  @override
  String get chatHistory => 'Chat History';

  @override
  String get callHistory => 'Call History';

  @override
  String get logout => 'Logout';

  @override
  String get chatMessages => 'Chat Messages';

  @override
  String get typeMessage => 'Message likhein...';

  @override
  String get sessionEnded => 'Session Khatam';

  @override
  String get endChat => 'Chat Khatam Karein?';

  @override
  String get endChatConfirm =>
      'Kya aap sach mein is chat session ko khatam karna chahte hain?';

  @override
  String get sendPhoto => 'Photo Bhejein';

  @override
  String get sendPDF => 'PDF Bhejein';

  @override
  String get upload => 'Upload';

  @override
  String get fileNotFound => 'File nahi mili';

  @override
  String get voiceCall => 'Voice Call';

  @override
  String get videoCall => 'Video Call';

  @override
  String get ringing => 'Ring ho rahi hai...';

  @override
  String get connected => 'CONNECTED';

  @override
  String get endCall => 'Call Khatam';

  @override
  String get mute => 'Mute';

  @override
  String get unmute => 'Unmute';

  @override
  String get speaker => 'Speaker';

  @override
  String get camera => 'Camera';

  @override
  String get flip => 'Flip';

  @override
  String get liveStreams => 'Live Streams';

  @override
  String get noLiveStreams => 'Abhi koi live stream nahi';

  @override
  String get astrologerUnavailable =>
      'Jyotishi available nahi. Stream khatam ho rahi hai.';

  @override
  String get streamEnded => 'Stream Khatam';

  @override
  String get superChat => 'Super Chat';

  @override
  String get sendGift => 'Gift Bhejein';

  @override
  String get goBack => 'Wapas Jayein';

  @override
  String get appPermissions => 'App Permissions';

  @override
  String get grantPermissions => 'Permissions Dein';

  @override
  String get skipForNow => 'Abhi Skip Karein';

  @override
  String get microphone => 'Microphone';

  @override
  String get notifications => 'Notifications';

  @override
  String get storage => 'Storage';

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
  String get retry => 'Phir Try Karein';

  @override
  String get send => 'Bhejein';

  @override
  String get refresh => 'Refresh';

  @override
  String get loading => 'Load ho raha hai...';

  @override
  String get noData => 'Koi data nahi mila';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get selectLanguage => 'Bhasha Chunein';

  @override
  String get language => 'Bhasha';

  @override
  String get english => 'English';

  @override
  String get myDetails => 'Meri Details';

  @override
  String get myKundlis => 'Meri Kundliyan';

  @override
  String get walletRecharge => 'Wallet & Recharge';

  @override
  String get consultationHistory => 'Consultation History';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get biometricLogin => 'Biometric Login';

  @override
  String get pastVoiceConsultations => 'Pichle voice consultations';

  @override
  String get pastTextConversations => 'Pichli text baatcheet';

  @override
  String get comingSoon => 'Jaldi aa raha hai';

  @override
  String get totalCredit => 'Total Credit';

  @override
  String get totalDebit => 'Total Debit';

  @override
  String get statement => 'Statement';

  @override
  String get allTypes => 'Sabhi Types';

  @override
  String get prev => 'Pichla';

  @override
  String get next => 'Agla';

  @override
  String get allInsights => 'Sabhi Insights';

  @override
  String get yourCompleteReading => 'AAPKA COMPLETE READING';

  @override
  String get expertEngines => 'expert engines';

  @override
  String get eachInsightConsultation => 'Har insight ek complete consultation hai';

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
  String get searchByNameSpeciality => 'Naam, speciality se khojein...';

  @override
  String get sortedByRating => 'Rating ke anusaar';

  @override
  String get initiatingChat => 'Chat shuru ho rahi hai...';

  @override
  String get startingCall => 'Call shuru ho rahi hai...';

  @override
  String get yrs => 'saal';

  @override
  String get chatWithAISpecialist => 'AI Specialist Se Chat Karein';

  @override
  String get tapToStart => 'Shuru karne ke liye tap karein';

  @override
  String get astrologer => 'Jyotishi';

  @override
  String get reports => 'Reports';

  @override
  String get milan => 'Milan';

  @override
  String get forecast => 'Forecast';

  @override
  String get rashi => 'Rashi';

  @override
  String get jupiterFavorsBold => 'Jupiter bold moves ko support karta hai';

  @override
  String get careerIlluminated => 'Aapka career sector illuminated hai — apni instinct par trust karein.';

  @override
  String get todaysForecast => 'Aaj Ka Forecast';

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
  String get noChatSessions => 'Abhi koi chat session nahi';

  @override
  String get chatAppearHere => 'Jyotishiyon ke saath aapki baatcheet yahan dikhegi.';

  @override
  String get noCallsYet => 'Abhi koi call nahi';

  @override
  String get callAppearHere => 'Jyotishiyon ke saath aapka call history yahan dikhega.';

  @override
  String get chatWith => 'Ke saath chat';

  @override
  String get msgs => 'msgs';

  @override
  String get voiceCallLabel => 'Voice call';

  @override
  String get videoCallLabel => 'Video call';

  @override
  String get pullToRefresh => 'Refresh karne ke liye neeche khenchein';

  @override
  String get sessionExpired => 'Session khatam';

  @override
  String get connectionFailed => 'Connection fail';

  @override
  String get callActive => 'Call active';

  @override
  String get lessThanOneMin => '1 minute se kam baaki';

  @override
  String get noMessages => 'Is session mein koi message nahi';

  @override
  String get gocharForAllSigns => 'Sabhi 12 rashiyon ka aaj ka gochar';

  @override
  String get selectChart => 'Analysis ke liye kundli chunein';

  @override
  String get selectTwoCharts => 'Do kundliyan chunein';

  @override
  String get analyzing => 'Analysis ho raha hai...';

  @override
  String get browseAstrologers => 'Jyotishi khojein';

  @override
  String get probableNumber => 'PROBABLE NUMBER';

  @override
  String get genderTendency => 'GENDER TENDENCY';

  @override
  String get son => 'SON';

  @override
  String get daughter => 'DAUGHTER';

  @override
  String get occupants => 'OCCUPANTS';

  @override
  String get beneficAspects => 'SHUBH ASPECTS';

  @override
  String get maleficAspects => 'PAAP ASPECTS';

  @override
  String get nextFavorableWindow => 'NEXT FAVORABLE WINDOW';

  @override
  String get totalDoshaPenalty => 'TOTAL DOSHA PENALTY';

  @override
  String get cancellationFactors => 'CANCELLATION FACTORS';

  @override
  String get combinedFertility => 'COMBINED FERTILITY INDICATION';

  @override
  String get planetPositions => 'GRAH POSITIONS';

  @override
  String get bestWindows => 'BEST WINDOWS';

  @override
  String get worstWindows => 'WORST WINDOWS';

  @override
  String get scoreComponents => 'SCORE COMPONENTS';

  @override
  String get topOpportunities => 'TOP OPPORTUNITIES';

  @override
  String get topRisks => 'TOP RISKS';

  @override
  String get remedies => 'UPAAY';

  @override
  String get keyInsights => 'KEY INSIGHTS';

  @override
  String get overallVerdict => 'OVERALL VERDICT';

  @override
  String get venusContacts => 'VENUS CROSS CONTACTS';

  @override
  String get contact => 'Contact';

  @override
  String get effect => 'Effect';

  @override
  String get moonSignCompat => 'MOON SIGN COMPATIBILITY';

  @override
  String get hisMoon => 'HIS MOON';

  @override
  String get herMoon => 'HER MOON';

  @override
  String get nakshatraCompat => 'NAKSHATRA COMPATIBILITY';

  @override
  String get ketuContacts => 'KETU CONTACTS';

  @override
  String get rahuContacts => 'RAHU CONTACTS';

  @override
  String get pastLifeIndication => 'PAST LIFE INDICATION';

  @override
  String get totalChallengePenalty => 'TOTAL CHALLENGE PENALTY';

  @override
  String get manifestation => 'MANIFESTATION';

  @override
  String get cancellation => 'CANCELLATION';

  @override
  String get navigation => 'NAVIGATION';

  @override
  String get potentialStrengths => 'STRENGTHS';

  @override
  String get areasToNurture => 'NURTURE AREAS';

  @override
  String get relationshipGuidance => 'RELATIONSHIP GUIDANCE';

  @override
  String get detailedSummary => 'DETAILED SUMMARY';

  @override
  String get discussWithAI => 'AI SE DISCUSS KAREIN';

  @override
  String get planet => 'Grah';

  @override
  String get sign => 'Rashi';

  @override
  String get house => 'Bhav';

  @override
  String get strength => 'Bal';

  @override
  String get copy => 'COPY';

  @override
  String get confidence => 'CONFIDENCE';

  @override
  String get d7Saptamsa => 'D7 SAPTAMSA';

  @override
  String get numberExplanation => 'NUMBER EXPLANATION';

  @override
  String get genderExplanation => 'GENDER EXPLANATION';

  @override
  String get inFifth => '5th mein?';

  @override
  String get primaryArchetype => 'PRIMARY ARCHETYPE';

  @override
  String get mitigation => 'MITIGATION';

  @override
  String get soulCareerAlign => 'Soul ↔ Career Alignment';

  @override
  String get favorablePeriods => 'Anukool Kaal';

  @override
  String get challengingPeriods => 'Chunautipurna Kaal';

  @override
  String get keyHouses => 'Key Houses';

  @override
  String get keyPlanets => 'Key Grah';

  @override
  String get characterOverview => 'Character Overview';

  @override
  String get noYogasActive => 'Is kundli mein abhi koi yoga active nahi.';

  @override
  String get basedOnPlanetStrengths => 'Grah bal aur bhav placement ke basis par';

  @override
  String get basedOnTransits => 'Current grah gochar ke basis par';

  @override
  String get currentPlanetPositions => 'Aapki rashi ko first house maante hue grah sthiti';

  @override
  String get favorablePeriodAdvice => 'Anukool kaal — career growth aur relationships par dhyaan dein.';

  @override
  String get noClassicalYogas => 'Classical yogas ke bina, safalta consistent effort se aati hai.';

  @override
  String get walletDeduction => 'Amount aapke wallet se kategi';

  @override
  String get bhakootAxis => 'BHAKOOT AXIS';

  @override
  String get basis => 'BASIS';

  @override
  String get selectChartsForMilan => 'Milan ke liye 2 kundliyan chunein';

  @override
  String get selectMultiCharts => '2-5 kundliyan chunein';

  @override
  String get running => 'RUNNING';

  @override
  String get past => 'beeta hua';

  @override
  String get topActiveDoshas => 'TOP ACTIVE DOSHAS';

  @override
  String get allDoshas => 'ALL DOSHAS';

  @override
  String get activeYogas => 'Active Yogas';

  @override
  String get activeDoshas => 'Active Doshas';

  @override
  String get yogaAnalysis => 'Yoga Analysis';

  @override
  String get factors => 'Factors';

  @override
  String get dominantPlanet => 'Dominant Grah';

  @override
  String get startSession => 'Session Shuru Karein';

  @override
  String get notesSaved => 'Notes save ho gaye';

  @override
  String get unlocked => 'Unlock ho gaya! Reading enjoy karein.';

  @override
  String get todaysGochar => 'Aaj Ka Gochar';

  @override
  String get todaysTransitChart => 'Aaj Ka Transit Chart';

  @override
  String get lifeAreaPredictions => 'Life Area Predictions';

  @override
  String get strengths => 'Strengths';

  @override
  String get weaknesses => 'Weaknesses';

  @override
  String get ruledBy => 'Swami';

  @override
  String get kundliMilan => 'Kundli Milan';

  @override
  String get startKundliMilan => 'Kundli Milan Shuru Karein';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get cancellations => 'Cancellations';

  @override
  String get dashaSync => 'Dasha Sync';

  @override
  String get transitMarriageWindows => 'Transit Marriage Windows';

  @override
  String get overlappingWindows => 'Overlapping Marriage Windows';

  @override
  String get overallStrength => 'OVERALL STRENGTH';

  @override
  String get stability => 'STABILITY';

  @override
  String get growth => 'GROWTH';

  @override
  String get clarity => 'CLARITY';

  @override
  String get recognition => 'RECOGNITION';

  @override
  String get satisfaction => 'SATISFACTION';

  @override
  String get verdict => 'VERDICT';

  @override
  String get topRoles => 'TOP ROLES';

  @override
  String get areasForGrowth => 'AREAS FOR GROWTH';

  @override
  String get bestIndustries => 'BEST INDUSTRIES';

  @override
  String get employment => 'Employment';

  @override
  String get entrepreneurship => 'Entrepreneurship';

  @override
  String get freelance => 'Freelance';

  @override
  String get portfolio => 'Portfolio';

  @override
  String get burnoutRisk => 'Burnout Risk';

  @override
  String get careerStagnation => 'Career Stagnation';

  @override
  String get workplaceConflict => 'Workplace Conflict';

  @override
  String get positioning => 'POSITIONING';

  @override
  String get skillDevelopment => 'SKILL DEVELOPMENT';

  @override
  String get network => 'NETWORK';

  @override
  String get visibility => 'VISIBILITY';

  @override
  String get lagnaLord => 'Lagna Lord';

  @override
  String get tenthLord => '10th Lord';

  @override
  String get lord => 'LORD';

  @override
  String get lordPlacedIn => 'LORD PLACED IN';

  @override
  String get lordDignity => 'LORD DIGNITY';

  @override
  String get d9Dignity => 'D9 DIGNITY';

  @override
  String get careerAnalysis => 'Career Analysis';

  @override
  String get launchWindows => 'Launch Windows';

  @override
  String get peakWindows => 'Peak Windows';

  @override
  String get promotionWindows => 'Promotion Windows';

  @override
  String get riskWindows => 'Risk Windows';

  @override
  String get timingWindows => 'Timing Windows';

  @override
  String get careerRisks => 'Career Risks';

  @override
  String get astrologicalRemedies => 'Astrological Remedies';

  @override
  String get practicalSolutions => 'Practical Solutions';

  @override
  String get analysisConfidence => 'Analysis Confidence';

  @override
  String get careerArchetype => 'Career Archetype';

  @override
  String get workStructure => 'Work Structure';

  @override
  String get teamLeadership => 'Team Leadership';

  @override
  String get idealEnvironment => 'Ideal Environment';

  @override
  String get idealOrgSize => 'Ideal Org Size';

  @override
  String get fitScore => 'FIT SCORE';

  @override
  String get recommended => 'RECOMMENDED';

  @override
  String get divisionalValidation => 'Divisional Validation';

  @override
  String get houseAnalysis => 'House Analysis';

  @override
  String get jaiminiKarakas => 'Jaimini Karakas';

  @override
  String get copyFullReport => 'Poori report copy karein';

  @override
  String get reportCopied => 'Report copy ho gayi!';
}
