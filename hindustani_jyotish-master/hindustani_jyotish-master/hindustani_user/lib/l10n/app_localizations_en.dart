// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hindustani Jyotish';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDone => 'Done';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonOnline => 'Online';

  @override
  String get commonOffline => 'Offline';

  @override
  String get commonErrorGeneric => 'Something went wrong. Please try again.';

  @override
  String get navHome => 'Home';

  @override
  String get navAstrologers => 'Astrologers';

  @override
  String get navInsights => 'Insights';

  @override
  String get navWallet => 'Wallet';

  @override
  String get navProfile => 'Profile';

  @override
  String get authNamaste => 'Namaste 🙏';

  @override
  String get authWelcomeSubtitle =>
      'Talk to verified Vedic astrologers in minutes.';

  @override
  String get authContinue => 'Continue';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authGoogleHelper => 'Sign in securely with your Google account';

  @override
  String get homeGreeting => 'Namaste 🙏';

  @override
  String get homeSeeker => 'Seeker';

  @override
  String get homeCosmicInsights => 'Cosmic Insights';

  @override
  String get homeOnlineAstrologers => 'Online Astrologers';

  @override
  String get homeNoAstrologersOnline => 'No astrologers online right now.';

  @override
  String get homePromoTitle => 'First chat from ₹7/msg';

  @override
  String get homePromoSubtitle => 'Talk to verified Vedic astrologers now.';

  @override
  String get homeLiveTitle => 'Astrologers live now';

  @override
  String get homeLiveSubtitle => 'Join a stream, ask questions, send gifts.';

  @override
  String get homeFeaturedVideos => 'Featured videos';

  @override
  String get toolDailyHoroscope => 'Daily Horoscope';

  @override
  String get toolDetailedKundli => 'Detailed Kundli';

  @override
  String get toolLoveMatch => 'Love Match';

  @override
  String get toolPlanetPosition => 'Planet Position';

  @override
  String get cardAstrologer => 'Astrologer';

  @override
  String get cardConsult => 'Consult';

  @override
  String get cardChat => 'Chat';

  @override
  String get cardCall => 'Call';

  @override
  String get cardVideo => 'Video';

  @override
  String cardYears(Object years) {
    return '$years yrs';
  }

  @override
  String cardYearsExp(Object years) {
    return '$years yrs exp';
  }

  @override
  String cardRatePerMsg(Object rate) {
    return '₹$rate/msg';
  }

  @override
  String cardRatePerMin(Object rate) {
    return '₹$rate/min';
  }

  @override
  String get discoverySearchHint => 'Search astrologers, skills…';

  @override
  String get discoveryOnlineNow => 'Online now';

  @override
  String get discoveryLanguage => 'Language';

  @override
  String get discoverySkill => 'Skill';

  @override
  String get discoverySort => 'Sort';

  @override
  String get discoverySortTopRated => 'Top rated';

  @override
  String get discoverySortPriceAsc => 'Price: low to high';

  @override
  String get discoverySortPriceDesc => 'Price: high to low';

  @override
  String get discoveryNoMatch =>
      'No astrologers match your filters.\nTry widening your search.';

  @override
  String get discoveryReachedEnd => 'You\'ve reached the end';

  @override
  String get walletTitle => 'Wallet';

  @override
  String get walletBalance => 'Balance';

  @override
  String get walletQuickRecharge => 'Quick recharge';

  @override
  String get walletCustomAmount => 'Custom amount';

  @override
  String walletBiometricNote(Object amount) {
    return 'Recharges of ₹$amount or more need biometric confirmation.';
  }

  @override
  String get walletRecentTransactions => 'Recent transactions';

  @override
  String get walletNoTransactions => 'No transactions yet.';

  @override
  String get walletEnterValidAmount => 'Enter a valid amount in ₹.';

  @override
  String get walletBiometricRequired =>
      'Biometric verification is required for this amount.';

  @override
  String walletRechargeConfirm(Object amount) {
    return 'Confirm your identity to recharge ₹$amount';
  }

  @override
  String walletAddedToWallet(Object amount) {
    return '₹$amount added to your wallet.';
  }

  @override
  String get consultChat => 'Chat';

  @override
  String get consultAudioCall => 'Audio Call';

  @override
  String get consultVideoCall => 'Video Call';

  @override
  String get consultConnected => 'Connected';

  @override
  String get consultWaitingForAstrologer => 'Waiting for astrologer…';

  @override
  String get consultEnded => 'Ended';

  @override
  String get consultSendMessage => 'Send message';

  @override
  String get consultCloseSession => 'Close';

  @override
  String get consultReady => 'Ready';

  @override
  String get consultStart => 'Start';

  @override
  String get consultTapStart => 'Tap start to connect';

  @override
  String get consultConnecting => 'Connecting…';

  @override
  String get consultSayNamaste => 'Say Namaste to begin 🙏';

  @override
  String get consultConnectingAstrologer => 'Connecting you to the astrologer…';

  @override
  String get consultTypeMessage => 'Type a message…';

  @override
  String get consultWaitingAstrologer => 'Waiting for astrologer…';

  @override
  String get consultChatEnded => 'This chat has ended.';

  @override
  String get consultSessionEnded => 'Session ended';

  @override
  String get consultSessionEndedLowBalance => 'Session ended (low balance)';

  @override
  String consultDuration(Object seconds) {
    return 'Duration: ${seconds}s';
  }

  @override
  String consultCharged(Object amount) {
    return 'Charged: ₹$amount';
  }

  @override
  String get consultSoFar => 'so far';

  @override
  String get consultWaitingAstrologerJoin =>
      'Waiting for the astrologer to join…';

  @override
  String get consultEndCallConfirmTitle => 'End this call?';

  @override
  String get consultEndCallConfirmBody =>
      'This will end the live session for both of you and can\'t be undone.';

  @override
  String get commonEnd => 'End';

  @override
  String get consultEndedInBackgroundTitle => 'Call ended';

  @override
  String get consultEndedInBackgroundBody =>
      'This call ended while the app was in the background.';

  @override
  String get consultReconnectingChat => 'Reconnecting chat…';

  @override
  String get consultCallReconnecting => 'Reconnecting…';

  @override
  String get consultSessionEndedTimeUp => 'Session ended (time limit reached)';

  @override
  String consultCallEndedBy(String name) {
    return 'Call ended by $name';
  }

  @override
  String get consultTheAstrologer => 'the astrologer';

  @override
  String get consultSending => 'Sending…';

  @override
  String get consultNotSentRetry => 'Not sent · Tap to retry';

  @override
  String get consultSpeakerOn => 'Speaker on';

  @override
  String get consultSpeakerOff => 'Speaker off';

  @override
  String consultSessionMsgs(Object used, Object cap, Object left) {
    return 'Session: $used/$cap msgs ($left left)';
  }

  @override
  String consultPerMsgRate(Object rate) {
    return '₹$rate/msg';
  }

  @override
  String get consultConnectedLabel => 'CONNECTED';

  @override
  String consultChargedRate(Object charged, Object rate) {
    return '₹$charged · ₹$rate/min';
  }

  @override
  String consultBalanceMinutes(Object balance, Object minutes) {
    return 'Balance ₹$balance · ~$minutes min left';
  }

  @override
  String consultBalanceRemaining(Object balance) {
    return 'Balance ₹$balance';
  }

  @override
  String get consultLowBalanceBanner => 'Low balance — under a minute left';

  @override
  String get consultAddMoney => 'Add money';

  @override
  String get consultRechargeTitle => 'Add money to wallet';

  @override
  String get consultRechargeSubtitle => 'Top up without ending the call.';

  @override
  String consultRechargeAdded(Object amount) {
    return '₹$amount added — the call continues.';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSeeker => 'Seeker';

  @override
  String get profileAppLockTitle => 'App lock (biometric)';

  @override
  String get profileAppLockOn => 'Require biometric unlock to open the app.';

  @override
  String get profileAppLockOff => 'No biometric set up on this device.';

  @override
  String get profileChatCallHistory => 'Chat & call history';

  @override
  String get profilePaymentHistory => 'Payment history';

  @override
  String get profileBecomeAstrologer => 'Become an astrologer';

  @override
  String get profileHelpline => 'Helpline & support';

  @override
  String get helplineNotConfigured =>
      'Helpline contact has not been added yet.';

  @override
  String get helplineEmail => 'Email';

  @override
  String get helplinePhone => 'Phone';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyNotConfigured =>
      'Privacy Policy has not been added yet.';

  @override
  String get profileAboutTerms => 'About · Terms · Privacy';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileFollowUs => 'Follow us';

  @override
  String get profileLinkCopied =>
      'Could not open the link — copied it instead.';

  @override
  String get profileLanguage => 'Language / भाषा';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageSystem => 'System default';

  @override
  String get profileTheme => 'Appearance';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System default';

  @override
  String get completeProfileTitle => 'Complete your profile';

  @override
  String get completeProfileSubtitle =>
      'Your name and contact number — that\'s all we need to get started.';

  @override
  String get completeProfileFullName => 'Full name';

  @override
  String get completeProfileContactNumber => 'Contact number';

  @override
  String get completeProfileSaveContinue => 'Save & Continue';

  @override
  String get completeProfilePhotoAdd => 'Add a profile photo (optional)';

  @override
  String get completeProfilePhotoChange => 'Change photo';

  @override
  String get completeProfilePhotoUploadFailed =>
      'Could not upload the photo. Please try again.';

  @override
  String get completeProfileNameRequired => 'Please enter your name.';

  @override
  String get completeProfileMobileIndia =>
      'Enter a valid 10-digit mobile number for +91.';

  @override
  String get completeProfileMobileGeneric =>
      'Enter a valid contact number (4–15 digits).';

  @override
  String get profileEditProfile => 'Edit profile';

  @override
  String get editProfileSubtitle =>
      'Update your photo, name and contact number.';

  @override
  String get editProfileSaved => 'Profile updated.';

  @override
  String get profileBirthDetails => 'Birth details';

  @override
  String get birthDetailsSubtitle =>
      'Your birth details power your Kundli & predictions.';

  @override
  String get birthDob => 'Date of birth';

  @override
  String get birthTimeOptional => 'Time of birth (optional)';

  @override
  String get birthPlaceOptional => 'Birth place (optional)';

  @override
  String get birthSelect => 'Select';

  @override
  String get birthDobRequired => 'Please select your date of birth.';

  @override
  String get birthSaved => 'Birth details saved.';

  @override
  String get insightsNeedBirthDetails =>
      'Add your birth details in Profile to unlock this insight.';

  @override
  String get insightsAddBirthDetails => 'Add now';

  @override
  String get commonClose => 'Close';

  @override
  String get insightsTitle => 'Cosmic Insights';

  @override
  String get insightsSubtitle => 'Personalised Vedic reports, instantly.';

  @override
  String get insightDailyHoroscope => 'Daily Horoscope';

  @override
  String get insightDetailedKundli => 'Detailed Kundli';

  @override
  String get insightFree => 'Free';

  @override
  String get insightPlanetPosition => 'Planet Position';

  @override
  String get insightLoveCompatibility => 'Love Compatibility';

  @override
  String get insightBirthdayNumber => 'Birthday Number';

  @override
  String get insightDailyPrediction => 'Daily Prediction';

  @override
  String get insightsMyReports => 'My Reports';

  @override
  String get insightsMyReportsSubtitle => 'Your past reports and PDFs';

  @override
  String insightsChargedBalance(Object amount, Object balance) {
    return 'Charged ₹$amount · Balance ₹$balance';
  }

  @override
  String get insightDownloadPdf => 'Download PDF';

  @override
  String get insightPdfOpenFailed => 'Could not open the PDF.';

  @override
  String get insightPreflightTitle => 'Complete your details';

  @override
  String get insightPreflightSubtitle =>
      'These details are needed to prepare your report and will be saved to your profile.';

  @override
  String get insightGenerateTitle => 'Birth details for this report';

  @override
  String get insightGenerateSubtitle =>
      'Pre-filled from your profile. Edit any field to generate the report for someone else.';

  @override
  String get insightGenerateCta => 'Generate report';

  @override
  String get reportOpenFailed => 'Could not open this report.';

  @override
  String get insightSharePdf => 'Share report';

  @override
  String get reportSavedOffline => 'Saved to this device — available offline.';

  @override
  String get insightPartnerTitle => 'Partner\'s details';

  @override
  String get insightPartnerSubtitle =>
      'Enter your partner\'s birth details for the match.';

  @override
  String get insightFieldName => 'Full name';

  @override
  String get insightFieldGender => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get insightFieldDob => 'Date of birth';

  @override
  String get insightFieldBirthTime => 'Time of birth';

  @override
  String get insightFieldBirthPlace => 'Birth place';

  @override
  String get insightFieldsRequired => 'Please fill in all the fields.';

  @override
  String get kundliChartTitle => 'Lagna Chart (North Indian)';

  @override
  String get kundliRetroLegend => '(R) = retrograde (vakri)';

  @override
  String get kundliLagnaLabel => 'Lagna (Ascendant)';

  @override
  String get kundliPlanetsTitle => 'Planetary Positions';

  @override
  String get kundliDashaTitle => 'Vimshottari Mahadasha';

  @override
  String get colPlanet => 'Planet';

  @override
  String get colSign => 'Sign';

  @override
  String get colDegree => 'Degree';

  @override
  String get colNakshatra => 'Nakshatra';

  @override
  String get colPada => 'Pada';

  @override
  String get loveScoreTitle => 'Compatibility Score';

  @override
  String get loveAshtakootTitle => 'Ashtakoot (Gun Milan)';

  @override
  String get loveVerdictTitle => 'Verdict';

  @override
  String get loveStrengthsTitle => 'Strengths';

  @override
  String get numberTraitsTitle => 'Traits';

  @override
  String get numberLifePath => 'Life Path Number';

  @override
  String get predictionActionsTitle => 'Best actions today';

  @override
  String get predictionCautionsTitle => 'Take care today';

  @override
  String get insightNoDetails =>
      'Your report is ready — download the PDF for the full details.';

  @override
  String get reportsEmpty =>
      'No reports yet. Run an insight to generate your first report.';

  @override
  String get reportsOpenPdf => 'Open PDF';

  @override
  String get imageViewerClose => 'Close';

  @override
  String get liveAnsweringNow => 'Answering now';

  @override
  String get liveTopGifters => 'Top gifters';

  @override
  String get liveReconnectingVideo => 'Reconnecting to video…';

  @override
  String get kunFullAnalysis => 'Complete birth chart';

  @override
  String get kunOpenFullAnalysis => 'Open full analysis';

  @override
  String get kunRetry => 'Retry';

  @override
  String get kunNoData => 'No data available';

  @override
  String get kunChecked => 'Checked';

  @override
  String get kunFactors => 'Why it forms';

  @override
  String get kunCancellation => 'Cancellation';

  @override
  String get kunSummary => 'Summary';

  @override
  String get kunPlanets => 'Planets';

  @override
  String get kunKundli => 'Kundli';

  @override
  String get kunDivisions => 'Divisions';

  @override
  String get kunVimshottari => 'Vimshottari';

  @override
  String get kunGochar => 'Gochar';

  @override
  String get kunDosh => 'Dosh';

  @override
  String get kunYoga => 'Yoga';

  @override
  String get kunShadbala => 'Shadbala';

  @override
  String get kunAshtakavarga => 'Ashtakavarga';

  @override
  String get kunAspects => 'Aspects';

  @override
  String get kunBhava => 'Bhava';

  @override
  String get dashaRunning => 'RUNNING';

  @override
  String dashaBirthBalance(Object lord, Object years) {
    return 'Birth lord: $lord · Balance: $years yrs';
  }

  @override
  String dashaAntardashasOf(Object planet) {
    return '$planet MD → Antardashas';
  }

  @override
  String dashaPratyantardashasOf(Object planet) {
    return '$planet AD → Pratyantardashas';
  }

  @override
  String dashaSookshmaOf(Object planet) {
    return '$planet PD → Sookshmadashas';
  }

  @override
  String dashaSubperiodsOf(Object planet) {
    return '$planet sub-periods';
  }

  @override
  String get divChartsSubtitle => 'Tap any varga chart to enlarge it.';

  @override
  String get summaryLagna => 'Lagna';

  @override
  String get summaryMoon => 'Moon sign';

  @override
  String get summarySun => 'Sun sign';

  @override
  String get summaryActiveDoshas => 'Active doshas';

  @override
  String get summaryActiveYogas => 'Active yogas';

  @override
  String get gocharBest => 'Best rashi';

  @override
  String get gocharWorst => 'Weakest rashi';

  @override
  String get doshActive => 'Active doshas';

  @override
  String get yogaActive => 'Active yogas';

  @override
  String get doshNone => 'No active doshas — a clear chart.';

  @override
  String get yogaNone => 'No prominent yogas detected.';

  @override
  String get colStrength => 'Strength';

  @override
  String get shadbalaRanking => 'Planet strength ranking';

  @override
  String get shadbalaRupas => 'rupas';

  @override
  String get avSavTitle => 'Sarvashtakavarga (SAV)';

  @override
  String avSavTotal(Object total) {
    return 'Total: $total';
  }

  @override
  String get avBavTitle => 'Bhinnashtakavarga (BAV)';

  @override
  String get aspectsGraha => 'Graha drishti (planetary aspects)';

  @override
  String get aspectsRashi => 'Rashi drishti (sign aspects)';

  @override
  String bhavaHouse(Object n) {
    return 'House $n';
  }

  @override
  String get bhavaLord => 'Lord';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountWarning =>
      'This permanently deletes your account. Your profile, birth details and saved data are removed, all your sessions end, and this cannot be undone.';

  @override
  String get deleteAccountTypeHint => 'Type DELETE to confirm';

  @override
  String get deleteAccountConfirm => 'Delete account';

  @override
  String get deleteAccountSuccess => 'Your account has been deleted.';
}
