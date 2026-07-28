import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale.fromSubtags(languageCode: 'hi', scriptCode: 'Latn'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('pa'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Nakshatralogy'**
  String get appName;

  /// No description provided for @cosmicJourneyAwaits.
  ///
  /// In en, this message translates to:
  /// **'Your Cosmic Journey Awaits'**
  String get cosmicJourneyAwaits;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @astrologers.
  ///
  /// In en, this message translates to:
  /// **'Astrologers'**
  String get astrologers;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @kundli.
  ///
  /// In en, this message translates to:
  /// **'Kundli'**
  String get kundli;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phone;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @lifeCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get lifeCareer;

  /// No description provided for @lifeHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get lifeHealth;

  /// No description provided for @lifeWealth.
  ///
  /// In en, this message translates to:
  /// **'Wealth'**
  String get lifeWealth;

  /// No description provided for @lifeFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get lifeFamily;

  /// No description provided for @lifeMind.
  ///
  /// In en, this message translates to:
  /// **'Mind'**
  String get lifeMind;

  /// No description provided for @lifeEgo.
  ///
  /// In en, this message translates to:
  /// **'Ego'**
  String get lifeEgo;

  /// No description provided for @lifeAggression.
  ///
  /// In en, this message translates to:
  /// **'Aggression'**
  String get lifeAggression;

  /// No description provided for @lifeConflict.
  ///
  /// In en, this message translates to:
  /// **'Conflict'**
  String get lifeConflict;

  /// No description provided for @rashiElement.
  ///
  /// In en, this message translates to:
  /// **'Element'**
  String get rashiElement;

  /// No description provided for @rashiQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get rashiQuality;

  /// No description provided for @rashiLuckyColor.
  ///
  /// In en, this message translates to:
  /// **'Lucky Color'**
  String get rashiLuckyColor;

  /// No description provided for @rashiLuckyDay.
  ///
  /// In en, this message translates to:
  /// **'Lucky Day'**
  String get rashiLuckyDay;

  /// No description provided for @rashiLuckyNumber.
  ///
  /// In en, this message translates to:
  /// **'Lucky Number'**
  String get rashiLuckyNumber;

  /// No description provided for @rashiGemstone.
  ///
  /// In en, this message translates to:
  /// **'Gemstone'**
  String get rashiGemstone;

  /// No description provided for @rashiBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get rashiBody;

  /// No description provided for @gocharTodaysTransitChart.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Transit Chart'**
  String get gocharTodaysTransitChart;

  /// No description provided for @gocharTransit.
  ///
  /// In en, this message translates to:
  /// **'Transit'**
  String get gocharTransit;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @best.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get best;

  /// No description provided for @worst.
  ///
  /// In en, this message translates to:
  /// **'Worst'**
  String get worst;

  /// No description provided for @avg.
  ///
  /// In en, this message translates to:
  /// **'avg'**
  String get avg;

  /// No description provided for @favorableLoveWindowsLabel.
  ///
  /// In en, this message translates to:
  /// **'Favorable Love Windows'**
  String get favorableLoveWindowsLabel;

  /// No description provided for @lordLabel.
  ///
  /// In en, this message translates to:
  /// **'Lord'**
  String get lordLabel;

  /// No description provided for @lordPlacementLabel.
  ///
  /// In en, this message translates to:
  /// **'Lord Placement'**
  String get lordPlacementLabel;

  /// No description provided for @lordDignityLabel.
  ///
  /// In en, this message translates to:
  /// **'Lord Dignity'**
  String get lordDignityLabel;

  /// No description provided for @categoriesSuffix.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesSuffix;

  /// No description provided for @coreBlockerLabel.
  ///
  /// In en, this message translates to:
  /// **'CORE BLOCKER'**
  String get coreBlockerLabel;

  /// No description provided for @coreGiftLabel.
  ///
  /// In en, this message translates to:
  /// **'✦ CORE GIFT'**
  String get coreGiftLabel;

  /// No description provided for @coreThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'● CORE THEME'**
  String get coreThemeLabel;

  /// No description provided for @dominantLabel.
  ///
  /// In en, this message translates to:
  /// **'Dominant: {value}'**
  String dominantLabel(Object value);

  /// No description provided for @karakasSuffix.
  ///
  /// In en, this message translates to:
  /// **'Karakas'**
  String get karakasSuffix;

  /// No description provided for @protectiveLabel.
  ///
  /// In en, this message translates to:
  /// **'PROTECTIVE'**
  String get protectiveLabel;

  /// No description provided for @secondaryLabel.
  ///
  /// In en, this message translates to:
  /// **' · Secondary: {value}'**
  String secondaryLabel(Object value);

  /// No description provided for @tagCore.
  ///
  /// In en, this message translates to:
  /// **'CORE'**
  String get tagCore;

  /// No description provided for @debtScoresHeader.
  ///
  /// In en, this message translates to:
  /// **'📉 DEBT SCORES'**
  String get debtScoresHeader;

  /// No description provided for @debtCurrentLoadStat.
  ///
  /// In en, this message translates to:
  /// **'CURRENT\nDEBT LOAD'**
  String get debtCurrentLoadStat;

  /// No description provided for @debtRecoveryCapacityStat.
  ///
  /// In en, this message translates to:
  /// **'RECOVERY\nCAPACITY'**
  String get debtRecoveryCapacityStat;

  /// No description provided for @debtIntensityStat.
  ///
  /// In en, this message translates to:
  /// **'INTENSITY'**
  String get debtIntensityStat;

  /// No description provided for @debtDefaultRiskStat.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT RISK'**
  String get debtDefaultRiskStat;

  /// No description provided for @debtProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Debt Profile'**
  String get debtProfileTitle;

  /// No description provided for @debtKarmaLabel.
  ///
  /// In en, this message translates to:
  /// **'KARMA'**
  String get debtKarmaLabel;

  /// No description provided for @debtPersonalityLabel.
  ///
  /// In en, this message translates to:
  /// **'PERSONALITY'**
  String get debtPersonalityLabel;

  /// No description provided for @debtPhaseLabel.
  ///
  /// In en, this message translates to:
  /// **'PHASE'**
  String get debtPhaseLabel;

  /// No description provided for @debtPrimaryCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY CATEGORY'**
  String get debtPrimaryCategoryLabel;

  /// No description provided for @debtWord.
  ///
  /// In en, this message translates to:
  /// **'Debt'**
  String get debtWord;

  /// No description provided for @debtYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Debt Yogas'**
  String get debtYogasTitle;

  /// No description provided for @debtCreatingLabel.
  ///
  /// In en, this message translates to:
  /// **'DEBT-CREATING'**
  String get debtCreatingLabel;

  /// No description provided for @debtClearingLabel.
  ///
  /// In en, this message translates to:
  /// **'DEBT-CLEARING'**
  String get debtClearingLabel;

  /// No description provided for @yearlyDebtTitle.
  ///
  /// In en, this message translates to:
  /// **'Yearly Debt'**
  String get yearlyDebtTitle;

  /// No description provided for @debtRepaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Repayment'**
  String get debtRepaymentTitle;

  /// No description provided for @debtDangerPeriodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Danger Periods'**
  String get debtDangerPeriodsTitle;

  /// No description provided for @debtDefaultPctStat.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT %'**
  String get debtDefaultPctStat;

  /// No description provided for @debtBankruptcyPctStat.
  ///
  /// In en, this message translates to:
  /// **'BANKRUPTCY %'**
  String get debtBankruptcyPctStat;

  /// No description provided for @debtChronicPctStat.
  ///
  /// In en, this message translates to:
  /// **'CHRONIC %'**
  String get debtChronicPctStat;

  /// No description provided for @debtResilienceStat.
  ///
  /// In en, this message translates to:
  /// **'RESILIENCE'**
  String get debtResilienceStat;

  /// No description provided for @debtRecoveryTimelineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery: {pct}% · Timeline: {years}yrs'**
  String debtRecoveryTimelineSubtitle(Object pct, Object years);

  /// No description provided for @debtFreeWindowLabel.
  ///
  /// In en, this message translates to:
  /// **'🎯 DEBT-FREE WINDOW'**
  String get debtFreeWindowLabel;

  /// No description provided for @debtFreeYear.
  ///
  /// In en, this message translates to:
  /// **'Year {year}'**
  String debtFreeYear(Object year);

  /// No description provided for @legalScoresHeader.
  ///
  /// In en, this message translates to:
  /// **'⚖️ LEGAL SCORES'**
  String get legalScoresHeader;

  /// No description provided for @legalVulnerabilityStat.
  ///
  /// In en, this message translates to:
  /// **'LEGAL\nVULNERABILITY'**
  String get legalVulnerabilityStat;

  /// No description provided for @legalVictoryPotentialStat.
  ///
  /// In en, this message translates to:
  /// **'VICTORY\nPOTENTIAL'**
  String get legalVictoryPotentialStat;

  /// No description provided for @legalConflictStat.
  ///
  /// In en, this message translates to:
  /// **'CONFLICT'**
  String get legalConflictStat;

  /// No description provided for @legalResolutionStat.
  ///
  /// In en, this message translates to:
  /// **'RESOLUTION'**
  String get legalResolutionStat;

  /// No description provided for @legalProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Profile'**
  String get legalProfileTitle;

  /// No description provided for @legalKarmaTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'KARMA TYPE'**
  String get legalKarmaTypeLabel;

  /// No description provided for @legalConflictStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'CONFLICT STYLE'**
  String get legalConflictStyleLabel;

  /// No description provided for @legalStrategyLabel.
  ///
  /// In en, this message translates to:
  /// **'STRATEGY'**
  String get legalStrategyLabel;

  /// No description provided for @legalCaseDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'CASE DURATION'**
  String get legalCaseDurationLabel;

  /// No description provided for @legalCurrentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'CURRENT STATUS'**
  String get legalCurrentStatusLabel;

  /// No description provided for @legalWord.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legalWord;

  /// No description provided for @legalYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Yogas'**
  String get legalYogasTitle;

  /// No description provided for @legalDisputePressureLabel.
  ///
  /// In en, this message translates to:
  /// **'DISPUTE PRESSURE'**
  String get legalDisputePressureLabel;

  /// No description provided for @legalProtectionLabel.
  ///
  /// In en, this message translates to:
  /// **'LEGAL PROTECTION'**
  String get legalProtectionLabel;

  /// No description provided for @legalStressTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Stress'**
  String get legalStressTrendTitle;

  /// No description provided for @legalVisibleEnemiesStat.
  ///
  /// In en, this message translates to:
  /// **'VISIBLE ENEMIES'**
  String get legalVisibleEnemiesStat;

  /// No description provided for @legalHiddenEnemiesStat.
  ///
  /// In en, this message translates to:
  /// **'HIDDEN ENEMIES'**
  String get legalHiddenEnemiesStat;

  /// No description provided for @legalCriminalRiskStat.
  ///
  /// In en, this message translates to:
  /// **'CRIMINAL RISK'**
  String get legalCriminalRiskStat;

  /// No description provided for @legalFalseAccusationStat.
  ///
  /// In en, this message translates to:
  /// **'FALSE ACCUSATION'**
  String get legalFalseAccusationStat;

  /// No description provided for @legalContractKarmaTitle.
  ///
  /// In en, this message translates to:
  /// **'Contract Karma'**
  String get legalContractKarmaTitle;

  /// No description provided for @legalDocumentationLabel.
  ///
  /// In en, this message translates to:
  /// **'DOCUMENTATION'**
  String get legalDocumentationLabel;

  /// No description provided for @legalFinePrintAwareLabel.
  ///
  /// In en, this message translates to:
  /// **'FINE PRINT AWARE'**
  String get legalFinePrintAwareLabel;

  /// No description provided for @legalNegotiationSkillLabel.
  ///
  /// In en, this message translates to:
  /// **'NEGOTIATION SKILL'**
  String get legalNegotiationSkillLabel;

  /// No description provided for @legalSignatureCautionLabel.
  ///
  /// In en, this message translates to:
  /// **'SIGNATURE CAUTION'**
  String get legalSignatureCautionLabel;

  /// No description provided for @legalResilienceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Resilience: {pct}/100'**
  String legalResilienceSubtitle(Object pct);

  /// No description provided for @legalVictoryWord.
  ///
  /// In en, this message translates to:
  /// **'Victory'**
  String get legalVictoryWord;

  /// No description provided for @legalAnalysisSuffix.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get legalAnalysisSuffix;

  /// No description provided for @legalAsPlaintiff.
  ///
  /// In en, this message translates to:
  /// **'AS PLAINTIFF'**
  String get legalAsPlaintiff;

  /// No description provided for @legalAsDefendant.
  ///
  /// In en, this message translates to:
  /// **'AS DEFENDANT'**
  String get legalAsDefendant;

  /// No description provided for @legalWinProbability.
  ///
  /// In en, this message translates to:
  /// **'WIN PROBABILITY'**
  String get legalWinProbability;

  /// No description provided for @legalDisputeWord.
  ///
  /// In en, this message translates to:
  /// **'Dispute'**
  String get legalDisputeWord;

  /// No description provided for @lifepathScoresHeader.
  ///
  /// In en, this message translates to:
  /// **'🌟 LIFE PATH SCORES'**
  String get lifepathScoresHeader;

  /// No description provided for @lifepathDharmaClarityStat.
  ///
  /// In en, this message translates to:
  /// **'DHARMA\nCLARITY'**
  String get lifepathDharmaClarityStat;

  /// No description provided for @lifepathFortuneBaselineStat.
  ///
  /// In en, this message translates to:
  /// **'FORTUNE\nBASELINE'**
  String get lifepathFortuneBaselineStat;

  /// No description provided for @lifepathCoherenceStat.
  ///
  /// In en, this message translates to:
  /// **'LIFE PATH\nCOHERENCE'**
  String get lifepathCoherenceStat;

  /// No description provided for @lifepathKarmaStat.
  ///
  /// In en, this message translates to:
  /// **'KARMA'**
  String get lifepathKarmaStat;

  /// No description provided for @lifepathSpiritualStat.
  ///
  /// In en, this message translates to:
  /// **'SPIRITUAL'**
  String get lifepathSpiritualStat;

  /// No description provided for @lifepathFameStat.
  ///
  /// In en, this message translates to:
  /// **'FAME'**
  String get lifepathFameStat;

  /// No description provided for @lifepathSoulContractTitle.
  ///
  /// In en, this message translates to:
  /// **'Soul Contract'**
  String get lifepathSoulContractTitle;

  /// No description provided for @lifepathAtmakarakaLabel.
  ///
  /// In en, this message translates to:
  /// **'ATMAKARAKA'**
  String get lifepathAtmakarakaLabel;

  /// No description provided for @lifepathAkFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'AK FOCUS'**
  String get lifepathAkFocusLabel;

  /// No description provided for @lifepathSoulPurposeLabel.
  ///
  /// In en, this message translates to:
  /// **'SOUL PURPOSE'**
  String get lifepathSoulPurposeLabel;

  /// No description provided for @lifepathLifeChapterLabel.
  ///
  /// In en, this message translates to:
  /// **'LIFE CHAPTER'**
  String get lifepathLifeChapterLabel;

  /// No description provided for @lifepathPrimaryDomainLabel.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY DOMAIN'**
  String get lifepathPrimaryDomainLabel;

  /// No description provided for @lifepathLeadershipStat.
  ///
  /// In en, this message translates to:
  /// **'LEADERSHIP'**
  String get lifepathLeadershipStat;

  /// No description provided for @lifepathWisdomTeachStat.
  ///
  /// In en, this message translates to:
  /// **'WISDOM/TEACH'**
  String get lifepathWisdomTeachStat;

  /// No description provided for @lifepathServiceStat.
  ///
  /// In en, this message translates to:
  /// **'SERVICE'**
  String get lifepathServiceStat;

  /// No description provided for @lifepathHealingStat.
  ///
  /// In en, this message translates to:
  /// **'HEALING'**
  String get lifepathHealingStat;

  /// No description provided for @lifepathFortuneYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Fortune Yogas'**
  String get lifepathFortuneYogasTitle;

  /// No description provided for @lifepathLuckBlocksLabel.
  ///
  /// In en, this message translates to:
  /// **'LUCK BLOCKS'**
  String get lifepathLuckBlocksLabel;

  /// No description provided for @lifepathFortuneBoostersLabel.
  ///
  /// In en, this message translates to:
  /// **'FORTUNE BOOSTERS'**
  String get lifepathFortuneBoostersLabel;

  /// No description provided for @lifepathFortuneTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Fortune Trend'**
  String get lifepathFortuneTrendTitle;

  /// No description provided for @lifepathGoldenWindowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Golden Windows ★'**
  String get lifepathGoldenWindowsTitle;

  /// No description provided for @lifepathTransformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Transformation'**
  String get lifepathTransformationTitle;

  /// No description provided for @lifepathMilestonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Life Milestones'**
  String get lifepathMilestonesTitle;

  /// No description provided for @lifepathKarmicLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Karmic Lessons'**
  String get lifepathKarmicLessonsTitle;

  /// No description provided for @lifepathRahuGrowthLabel.
  ///
  /// In en, this message translates to:
  /// **'RAHU GROWTH'**
  String get lifepathRahuGrowthLabel;

  /// No description provided for @lifepathKetuSurrenderLabel.
  ///
  /// In en, this message translates to:
  /// **'KETU SURRENDER'**
  String get lifepathKetuSurrenderLabel;

  /// No description provided for @lifepathSaturnLessonLabel.
  ///
  /// In en, this message translates to:
  /// **'SATURN LESSON'**
  String get lifepathSaturnLessonLabel;

  /// No description provided for @lifepathLifeDifficultyLabel.
  ///
  /// In en, this message translates to:
  /// **'LIFE DIFFICULTY'**
  String get lifepathLifeDifficultyLabel;

  /// No description provided for @lifepathSoulExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'★ SOUL CAME TO EXPERIENCE'**
  String get lifepathSoulExperienceTitle;

  /// No description provided for @lifepathBlessingsTitle.
  ///
  /// In en, this message translates to:
  /// **'● BLESSINGS'**
  String get lifepathBlessingsTitle;

  /// No description provided for @lifepathLifeWord.
  ///
  /// In en, this message translates to:
  /// **'Life'**
  String get lifepathLifeWord;

  /// No description provided for @lifepathArchetypeSuffix.
  ///
  /// In en, this message translates to:
  /// **'Archetype'**
  String get lifepathArchetypeSuffix;

  /// No description provided for @lifepathFulfillmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fulfillment: {pct}%'**
  String lifepathFulfillmentSubtitle(Object pct);

  /// No description provided for @lifepathDestinyVsWord.
  ///
  /// In en, this message translates to:
  /// **'Destiny vs'**
  String get lifepathDestinyVsWord;

  /// No description provided for @lifepathFreeWillSuffix.
  ///
  /// In en, this message translates to:
  /// **'Free Will'**
  String get lifepathFreeWillSuffix;

  /// No description provided for @lifepathDestinyStat.
  ///
  /// In en, this message translates to:
  /// **'DESTINY'**
  String get lifepathDestinyStat;

  /// No description provided for @lifepathFreeWillStat.
  ///
  /// In en, this message translates to:
  /// **'FREE WILL'**
  String get lifepathFreeWillStat;

  /// No description provided for @pastlifeScoresHeader.
  ///
  /// In en, this message translates to:
  /// **'🔮 PAST LIFE SCORES'**
  String get pastlifeScoresHeader;

  /// No description provided for @pastlifeSignatureStrengthStat.
  ///
  /// In en, this message translates to:
  /// **'SIGNATURE\nSTRENGTH'**
  String get pastlifeSignatureStrengthStat;

  /// No description provided for @pastlifeCarryForwardStat.
  ///
  /// In en, this message translates to:
  /// **'CARRY-\nFORWARD'**
  String get pastlifeCarryForwardStat;

  /// No description provided for @pastlifeMasteryPreservedStat.
  ///
  /// In en, this message translates to:
  /// **'MASTERY\nPRESERVED'**
  String get pastlifeMasteryPreservedStat;

  /// No description provided for @pastlifeUnfinishedStat.
  ///
  /// In en, this message translates to:
  /// **'UNFINISHED'**
  String get pastlifeUnfinishedStat;

  /// No description provided for @pastlifeKarmicDebtStat.
  ///
  /// In en, this message translates to:
  /// **'KARMIC DEBT'**
  String get pastlifeKarmicDebtStat;

  /// No description provided for @pastlifeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Past Life Profile'**
  String get pastlifeProfileTitle;

  /// No description provided for @pastlifeThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'THEME'**
  String get pastlifeThemeLabel;

  /// No description provided for @pastlifeProfessionLabel.
  ///
  /// In en, this message translates to:
  /// **'PROFESSION'**
  String get pastlifeProfessionLabel;

  /// No description provided for @pastlifeSocialStandingLabel.
  ///
  /// In en, this message translates to:
  /// **'SOCIAL STANDING'**
  String get pastlifeSocialStandingLabel;

  /// No description provided for @pastlifeRegionLabel.
  ///
  /// In en, this message translates to:
  /// **'REGION'**
  String get pastlifeRegionLabel;

  /// No description provided for @pastlifeSpiritualLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'SPIRITUAL LEVEL'**
  String get pastlifeSpiritualLevelLabel;

  /// No description provided for @pastlifeGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'GENDER'**
  String get pastlifeGenderLabel;

  /// No description provided for @pastlifeWealthLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'WEALTH LEVEL'**
  String get pastlifeWealthLevelLabel;

  /// No description provided for @pastlifeFamilyRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'FAMILY ROLE'**
  String get pastlifeFamilyRoleLabel;

  /// No description provided for @pastlifeSkillsCarriedTitle.
  ///
  /// In en, this message translates to:
  /// **'★ SKILLS CARRIED FORWARD'**
  String get pastlifeSkillsCarriedTitle;

  /// No description provided for @pastlifeNaturalAttractionsTitle.
  ///
  /// In en, this message translates to:
  /// **'● NATURAL ATTRACTIONS'**
  String get pastlifeNaturalAttractionsTitle;

  /// No description provided for @pastlifeUnexplainedFearsTitle.
  ///
  /// In en, this message translates to:
  /// **'⚠ UNEXPLAINED FEARS'**
  String get pastlifeUnexplainedFearsTitle;

  /// No description provided for @pastlifeMagneticPullsTitle.
  ///
  /// In en, this message translates to:
  /// **'→ MAGNETIC PULLS'**
  String get pastlifeMagneticPullsTitle;

  /// No description provided for @pastlifeRelationshipStat.
  ///
  /// In en, this message translates to:
  /// **'RELATIONSHIP'**
  String get pastlifeRelationshipStat;

  /// No description provided for @pastlifeFinancialStat.
  ///
  /// In en, this message translates to:
  /// **'FINANCIAL'**
  String get pastlifeFinancialStat;

  /// No description provided for @pastlifeServiceStat.
  ///
  /// In en, this message translates to:
  /// **'SERVICE'**
  String get pastlifeServiceStat;

  /// No description provided for @pastlifeDharmicStat.
  ///
  /// In en, this message translates to:
  /// **'DHARMIC'**
  String get pastlifeDharmicStat;

  /// No description provided for @pastlifeOnRelationsStat.
  ///
  /// In en, this message translates to:
  /// **'ON RELATIONS'**
  String get pastlifeOnRelationsStat;

  /// No description provided for @pastlifeOnCareerStat.
  ///
  /// In en, this message translates to:
  /// **'ON CAREER'**
  String get pastlifeOnCareerStat;

  /// No description provided for @pastlifeOnHealthStat.
  ///
  /// In en, this message translates to:
  /// **'ON HEALTH'**
  String get pastlifeOnHealthStat;

  /// No description provided for @pastlifeOnSpiritualStat.
  ///
  /// In en, this message translates to:
  /// **'ON SPIRITUAL'**
  String get pastlifeOnSpiritualStat;

  /// No description provided for @pastlifeKarmicResolutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Karmic Resolution'**
  String get pastlifeKarmicResolutionTitle;

  /// No description provided for @pastlifePrimaryPathLabel.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY PATH'**
  String get pastlifePrimaryPathLabel;

  /// No description provided for @pastlifeSecondaryPathLabel.
  ///
  /// In en, this message translates to:
  /// **'SECONDARY PATH'**
  String get pastlifeSecondaryPathLabel;

  /// No description provided for @pastlifeClearingProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'CLEARING PROGRESS'**
  String get pastlifeClearingProgressLabel;

  /// No description provided for @pastlifeRemainingWorkLabel.
  ///
  /// In en, this message translates to:
  /// **'REMAINING WORK'**
  String get pastlifeRemainingWorkLabel;

  /// No description provided for @pastlifeDebtTimelineLabel.
  ///
  /// In en, this message translates to:
  /// **'DEBT TIMELINE'**
  String get pastlifeDebtTimelineLabel;

  /// No description provided for @pastlifeMemoryAccessStat.
  ///
  /// In en, this message translates to:
  /// **'MEMORY ACCESS'**
  String get pastlifeMemoryAccessStat;

  /// No description provided for @pastlifeDreamVisitsStat.
  ///
  /// In en, this message translates to:
  /// **'DREAM VISITS'**
  String get pastlifeDreamVisitsStat;

  /// No description provided for @pastlifeDejaVuStat.
  ///
  /// In en, this message translates to:
  /// **'DEJA VU'**
  String get pastlifeDejaVuStat;

  /// No description provided for @pastlifeRegressionFitStat.
  ///
  /// In en, this message translates to:
  /// **'REGRESSION FIT'**
  String get pastlifeRegressionFitStat;

  /// No description provided for @pastlifeActivationTitle.
  ///
  /// In en, this message translates to:
  /// **'Past Life Activation'**
  String get pastlifeActivationTitle;

  /// No description provided for @pastlifeMaturityStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Maturity: {maturity} · Status: {status}'**
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status);

  /// No description provided for @pastlifeKetuWord.
  ///
  /// In en, this message translates to:
  /// **'Ketu'**
  String get pastlifeKetuWord;

  /// No description provided for @pastlifePastMasterySuffix.
  ///
  /// In en, this message translates to:
  /// **'Past Mastery'**
  String get pastlifePastMasterySuffix;

  /// No description provided for @pastlifeKetuMasteredLabel.
  ///
  /// In en, this message translates to:
  /// **'KETU · WHAT YOU MASTERED'**
  String get pastlifeKetuMasteredLabel;

  /// No description provided for @pastlifeRahuWord.
  ///
  /// In en, this message translates to:
  /// **'Rahu'**
  String get pastlifeRahuWord;

  /// No description provided for @pastlifeFutureGrowthSuffix.
  ///
  /// In en, this message translates to:
  /// **'Future Growth'**
  String get pastlifeFutureGrowthSuffix;

  /// No description provided for @pastlifeRahuPullsLabel.
  ///
  /// In en, this message translates to:
  /// **'RAHU · WHAT PULLS YOU FORWARD'**
  String get pastlifeRahuPullsLabel;

  /// No description provided for @pastlifeShadowPrefix.
  ///
  /// In en, this message translates to:
  /// **'⚠ Shadow: {shadow}'**
  String pastlifeShadowPrefix(Object shadow);

  /// No description provided for @mentalScoresHeader.
  ///
  /// In en, this message translates to:
  /// **'🧠 MENTAL SCORES'**
  String get mentalScoresHeader;

  /// No description provided for @mentalStabilityStat.
  ///
  /// In en, this message translates to:
  /// **'MENTAL\nSTABILITY'**
  String get mentalStabilityStat;

  /// No description provided for @mentalEmotionalBaselineStat.
  ///
  /// In en, this message translates to:
  /// **'EMOTIONAL\nBASELINE'**
  String get mentalEmotionalBaselineStat;

  /// No description provided for @mentalResilienceStat.
  ///
  /// In en, this message translates to:
  /// **'RESILIENCE'**
  String get mentalResilienceStat;

  /// No description provided for @mentalAnxietyStat.
  ///
  /// In en, this message translates to:
  /// **'ANXIETY'**
  String get mentalAnxietyStat;

  /// No description provided for @mentalDepressionStat.
  ///
  /// In en, this message translates to:
  /// **'DEPRESSION'**
  String get mentalDepressionStat;

  /// No description provided for @mentalRegulationStat.
  ///
  /// In en, this message translates to:
  /// **'REGULATION'**
  String get mentalRegulationStat;

  /// No description provided for @mentalProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Mental Profile'**
  String get mentalProfileTitle;

  /// No description provided for @mentalConstitutionLabel.
  ///
  /// In en, this message translates to:
  /// **'CONSTITUTION'**
  String get mentalConstitutionLabel;

  /// No description provided for @mentalStressDriverLabel.
  ///
  /// In en, this message translates to:
  /// **'STRESS DRIVER'**
  String get mentalStressDriverLabel;

  /// No description provided for @mentalStabilityAnchorLabel.
  ///
  /// In en, this message translates to:
  /// **'STABILITY ANCHOR'**
  String get mentalStabilityAnchorLabel;

  /// No description provided for @mentalStressResponseLabel.
  ///
  /// In en, this message translates to:
  /// **'STRESS RESPONSE'**
  String get mentalStressResponseLabel;

  /// No description provided for @mentalAttachmentStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'ATTACHMENT STYLE'**
  String get mentalAttachmentStyleLabel;

  /// No description provided for @mentalBurnoutStageLabel.
  ///
  /// In en, this message translates to:
  /// **'BURNOUT STAGE'**
  String get mentalBurnoutStageLabel;

  /// No description provided for @mentalWord.
  ///
  /// In en, this message translates to:
  /// **'Mental'**
  String get mentalWord;

  /// No description provided for @mentalYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Mental Yogas'**
  String get mentalYogasTitle;

  /// No description provided for @mentalStressPressureLabel.
  ///
  /// In en, this message translates to:
  /// **'STRESS PRESSURE'**
  String get mentalStressPressureLabel;

  /// No description provided for @mentalWellnessTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Wellness Trend'**
  String get mentalWellnessTrendTitle;

  /// No description provided for @mentalHealthyCopingTitle.
  ///
  /// In en, this message translates to:
  /// **'✓ HEALTHY COPING'**
  String get mentalHealthyCopingTitle;

  /// No description provided for @mentalUnhealthyRisksTitle.
  ///
  /// In en, this message translates to:
  /// **'⚠ UNHEALTHY RISKS'**
  String get mentalUnhealthyRisksTitle;

  /// No description provided for @mentalRecommendedAlternativesTitle.
  ///
  /// In en, this message translates to:
  /// **'✦ RECOMMENDED ALTERNATIVES'**
  String get mentalRecommendedAlternativesTitle;

  /// No description provided for @mentalSleepQualityStat.
  ///
  /// In en, this message translates to:
  /// **'SLEEP QUALITY'**
  String get mentalSleepQualityStat;

  /// No description provided for @mentalSocialSupportStat.
  ///
  /// In en, this message translates to:
  /// **'SOCIAL SUPPORT'**
  String get mentalSocialSupportStat;

  /// No description provided for @mentalBurnoutVulnStat.
  ///
  /// In en, this message translates to:
  /// **'BURNOUT VULN'**
  String get mentalBurnoutVulnStat;

  /// No description provided for @mentalSelfAwarenessStat.
  ///
  /// In en, this message translates to:
  /// **'SELF-AWARENESS'**
  String get mentalSelfAwarenessStat;

  /// No description provided for @mentalAnxietyWord.
  ///
  /// In en, this message translates to:
  /// **'Anxiety'**
  String get mentalAnxietyWord;

  /// No description provided for @mentalTypesSuffix.
  ///
  /// In en, this message translates to:
  /// **'Types'**
  String get mentalTypesSuffix;

  /// No description provided for @mentalTherapyWord.
  ///
  /// In en, this message translates to:
  /// **'Therapy'**
  String get mentalTherapyWord;

  /// No description provided for @mentalModalityFitSuffix.
  ///
  /// In en, this message translates to:
  /// **'Modality Fit'**
  String get mentalModalityFitSuffix;

  /// No description provided for @characterScoresHeader.
  ///
  /// In en, this message translates to:
  /// **'🔍 CHARACTER SCORES'**
  String get characterScoresHeader;

  /// No description provided for @characterStrengthStat.
  ///
  /// In en, this message translates to:
  /// **'CHARACTER\nSTRENGTH'**
  String get characterStrengthStat;

  /// No description provided for @characterIntegrityStat.
  ///
  /// In en, this message translates to:
  /// **'INTEGRITY'**
  String get characterIntegrityStat;

  /// No description provided for @characterResilienceStat.
  ///
  /// In en, this message translates to:
  /// **'RESILIENCE'**
  String get characterResilienceStat;

  /// No description provided for @characterAwarenessStat.
  ///
  /// In en, this message translates to:
  /// **'AWARENESS'**
  String get characterAwarenessStat;

  /// No description provided for @characterStabilityStat.
  ///
  /// In en, this message translates to:
  /// **'STABILITY'**
  String get characterStabilityStat;

  /// No description provided for @characterEthicsStat.
  ///
  /// In en, this message translates to:
  /// **'ETHICS'**
  String get characterEthicsStat;

  /// No description provided for @characterSurfacePersonalityTitle.
  ///
  /// In en, this message translates to:
  /// **'Surface Personality'**
  String get characterSurfacePersonalityTitle;

  /// No description provided for @characterLagnaLabel.
  ///
  /// In en, this message translates to:
  /// **'LAGNA'**
  String get characterLagnaLabel;

  /// No description provided for @characterConstitutionLabel.
  ///
  /// In en, this message translates to:
  /// **'CONSTITUTION'**
  String get characterConstitutionLabel;

  /// No description provided for @characterNakshatraLabel.
  ///
  /// In en, this message translates to:
  /// **'NAKSHATRA'**
  String get characterNakshatraLabel;

  /// No description provided for @characterDeityLabel.
  ///
  /// In en, this message translates to:
  /// **'DEITY'**
  String get characterDeityLabel;

  /// No description provided for @characterMoonManasTitle.
  ///
  /// In en, this message translates to:
  /// **'Moon Manas'**
  String get characterMoonManasTitle;

  /// No description provided for @characterSignLabel.
  ///
  /// In en, this message translates to:
  /// **'SIGN'**
  String get characterSignLabel;

  /// No description provided for @characterHouseLabel.
  ///
  /// In en, this message translates to:
  /// **'HOUSE'**
  String get characterHouseLabel;

  /// No description provided for @characterWarmthStat.
  ///
  /// In en, this message translates to:
  /// **'WARMTH'**
  String get characterWarmthStat;

  /// No description provided for @characterEmpathyStat.
  ///
  /// In en, this message translates to:
  /// **'EMPATHY'**
  String get characterEmpathyStat;

  /// No description provided for @characterLoyaltyStat.
  ///
  /// In en, this message translates to:
  /// **'LOYALTY'**
  String get characterLoyaltyStat;

  /// No description provided for @characterBoundariesStat.
  ///
  /// In en, this message translates to:
  /// **'BOUNDARIES'**
  String get characterBoundariesStat;

  /// No description provided for @characterDharmaStat.
  ///
  /// In en, this message translates to:
  /// **'DHARMA'**
  String get characterDharmaStat;

  /// No description provided for @characterTruthStat.
  ///
  /// In en, this message translates to:
  /// **'TRUTH'**
  String get characterTruthStat;

  /// No description provided for @characterCompassionStat.
  ///
  /// In en, this message translates to:
  /// **'COMPASSION'**
  String get characterCompassionStat;

  /// No description provided for @characterGenerosityStat.
  ///
  /// In en, this message translates to:
  /// **'GENEROSITY'**
  String get characterGenerosityStat;

  /// No description provided for @characterSignatureVirtuesTitle.
  ///
  /// In en, this message translates to:
  /// **'★ SIGNATURE VIRTUES'**
  String get characterSignatureVirtuesTitle;

  /// No description provided for @characterNaturalTalentsTitle.
  ///
  /// In en, this message translates to:
  /// **'● NATURAL TALENTS'**
  String get characterNaturalTalentsTitle;

  /// No description provided for @characterShadowPatternsTitle.
  ///
  /// In en, this message translates to:
  /// **'⚠ SHADOW PATTERNS'**
  String get characterShadowPatternsTitle;

  /// No description provided for @characterYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Character Yogas'**
  String get characterYogasTitle;

  /// No description provided for @characterTestsLabel.
  ///
  /// In en, this message translates to:
  /// **'TESTS'**
  String get characterTestsLabel;

  /// No description provided for @characterGiftsLabel.
  ///
  /// In en, this message translates to:
  /// **'GIFTS'**
  String get characterGiftsLabel;

  /// No description provided for @characterSelfAwareEiStat.
  ///
  /// In en, this message translates to:
  /// **'SELF-AWARE EI'**
  String get characterSelfAwareEiStat;

  /// No description provided for @characterSelfRegulateStat.
  ///
  /// In en, this message translates to:
  /// **'SELF-REGULATE'**
  String get characterSelfRegulateStat;

  /// No description provided for @characterEmpathyEiStat.
  ///
  /// In en, this message translates to:
  /// **'EMPATHY EI'**
  String get characterEmpathyEiStat;

  /// No description provided for @characterSocialSkillsStat.
  ///
  /// In en, this message translates to:
  /// **'SOCIAL SKILLS'**
  String get characterSocialSkillsStat;

  /// No description provided for @characterRealizationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Realization: {pct}%'**
  String characterRealizationSubtitle(Object pct);

  /// No description provided for @characterAtmakarakaWord.
  ///
  /// In en, this message translates to:
  /// **'Atmakaraka'**
  String get characterAtmakarakaWord;

  /// No description provided for @characterSoulSignatureSuffix.
  ///
  /// In en, this message translates to:
  /// **'Soul Signature'**
  String get characterSoulSignatureSuffix;

  /// No description provided for @characterAtmakarakaLabel.
  ///
  /// In en, this message translates to:
  /// **'ATMAKARAKA'**
  String get characterAtmakarakaLabel;

  /// No description provided for @characterGunaWord.
  ///
  /// In en, this message translates to:
  /// **'Guna'**
  String get characterGunaWord;

  /// No description provided for @characterProfileSuffix.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get characterProfileSuffix;

  /// No description provided for @characterSattvaLabel.
  ///
  /// In en, this message translates to:
  /// **'Sattva'**
  String get characterSattvaLabel;

  /// No description provided for @characterRajasLabel.
  ///
  /// In en, this message translates to:
  /// **'Rajas'**
  String get characterRajasLabel;

  /// No description provided for @characterTamasLabel.
  ///
  /// In en, this message translates to:
  /// **'Tamas'**
  String get characterTamasLabel;

  /// No description provided for @healthScoresHeader.
  ///
  /// In en, this message translates to:
  /// **'🏥 HEALTH SCORES'**
  String get healthScoresHeader;

  /// No description provided for @healthVitalityStat.
  ///
  /// In en, this message translates to:
  /// **'VITALITY'**
  String get healthVitalityStat;

  /// No description provided for @healthImmunityStat.
  ///
  /// In en, this message translates to:
  /// **'IMMUNITY'**
  String get healthImmunityStat;

  /// No description provided for @healthRecoveryStat.
  ///
  /// In en, this message translates to:
  /// **'RECOVERY'**
  String get healthRecoveryStat;

  /// No description provided for @healthMentalStat.
  ///
  /// In en, this message translates to:
  /// **'MENTAL'**
  String get healthMentalStat;

  /// No description provided for @healthStressTolStat.
  ///
  /// In en, this message translates to:
  /// **'STRESS TOL'**
  String get healthStressTolStat;

  /// No description provided for @healthYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Yogas'**
  String get healthYogasTitle;

  /// No description provided for @healthDiseasePressureLabel.
  ///
  /// In en, this message translates to:
  /// **'DISEASE PRESSURE'**
  String get healthDiseasePressureLabel;

  /// No description provided for @healthTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Trend'**
  String get healthTrendTitle;

  /// No description provided for @healthRecoveryWindowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery Windows'**
  String get healthRecoveryWindowsTitle;

  /// No description provided for @healthCautionPeriodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Caution Periods'**
  String get healthCautionPeriodsTitle;

  /// No description provided for @healthFertilityStat.
  ///
  /// In en, this message translates to:
  /// **'FERTILITY'**
  String get healthFertilityStat;

  /// No description provided for @healthBurnoutRiskStat.
  ///
  /// In en, this message translates to:
  /// **'BURNOUT RISK'**
  String get healthBurnoutRiskStat;

  /// No description provided for @healthAddictionVulnStat.
  ///
  /// In en, this message translates to:
  /// **'ADDICTION VULN'**
  String get healthAddictionVulnStat;

  /// No description provided for @healthWorkLifeBalStat.
  ///
  /// In en, this message translates to:
  /// **'WORK-LIFE BAL'**
  String get healthWorkLifeBalStat;

  /// No description provided for @healthAyurvedicWord.
  ///
  /// In en, this message translates to:
  /// **'Ayurvedic'**
  String get healthAyurvedicWord;

  /// No description provided for @healthConstitutionSuffix.
  ///
  /// In en, this message translates to:
  /// **'Constitution'**
  String get healthConstitutionSuffix;

  /// No description provided for @healthBodyWord.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get healthBodyWord;

  /// No description provided for @healthSystemMapSuffix.
  ///
  /// In en, this message translates to:
  /// **'System Map'**
  String get healthSystemMapSuffix;

  /// No description provided for @healthBodyZoneWord.
  ///
  /// In en, this message translates to:
  /// **'Body Zone'**
  String get healthBodyZoneWord;

  /// No description provided for @healthVulnerabilitySuffix.
  ///
  /// In en, this message translates to:
  /// **'Vulnerability'**
  String get healthVulnerabilitySuffix;

  /// No description provided for @healthDiseaseWord.
  ///
  /// In en, this message translates to:
  /// **'Disease'**
  String get healthDiseaseWord;

  /// No description provided for @healthSusceptibilitySuffix.
  ///
  /// In en, this message translates to:
  /// **'Susceptibility'**
  String get healthSusceptibilitySuffix;

  /// No description provided for @healthLifestyleFactorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle Factors'**
  String get healthLifestyleFactorsTitle;

  /// No description provided for @healthSleepDisciplineLabel.
  ///
  /// In en, this message translates to:
  /// **'SLEEP DISCIPLINE'**
  String get healthSleepDisciplineLabel;

  /// No description provided for @healthDietDisciplineLabel.
  ///
  /// In en, this message translates to:
  /// **'DIET DISCIPLINE'**
  String get healthDietDisciplineLabel;

  /// No description provided for @healthExerciseNeedLabel.
  ///
  /// In en, this message translates to:
  /// **'EXERCISE NEED'**
  String get healthExerciseNeedLabel;

  /// No description provided for @healthSunlightNeedLabel.
  ///
  /// In en, this message translates to:
  /// **'SUNLIGHT NEED'**
  String get healthSunlightNeedLabel;

  /// No description provided for @healthSocialTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'SOCIAL TYPE'**
  String get healthSocialTypeLabel;

  /// No description provided for @healthHealingSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'HEALING SPEED'**
  String get healthHealingSpeedLabel;

  /// No description provided for @wealthScoresHeader.
  ///
  /// In en, this message translates to:
  /// **'💰 WEALTH SCORES'**
  String get wealthScoresHeader;

  /// No description provided for @wealthStrengthStat.
  ///
  /// In en, this message translates to:
  /// **'WEALTH\nSTRENGTH'**
  String get wealthStrengthStat;

  /// No description provided for @wealthAccumulationStat.
  ///
  /// In en, this message translates to:
  /// **'ACCUMU-\nLATION'**
  String get wealthAccumulationStat;

  /// No description provided for @wealthIncomeFlowStat.
  ///
  /// In en, this message translates to:
  /// **'INCOME\nFLOW'**
  String get wealthIncomeFlowStat;

  /// No description provided for @wealthSustainStat.
  ///
  /// In en, this message translates to:
  /// **'SUSTAIN'**
  String get wealthSustainStat;

  /// No description provided for @wealthMultiStreamStat.
  ///
  /// In en, this message translates to:
  /// **'MULTI-STREAM'**
  String get wealthMultiStreamStat;

  /// No description provided for @wealthRetentionStat.
  ///
  /// In en, this message translates to:
  /// **'RETENTION'**
  String get wealthRetentionStat;

  /// No description provided for @wealthWord.
  ///
  /// In en, this message translates to:
  /// **'Wealth'**
  String get wealthWord;

  /// No description provided for @wealthYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Wealth Yogas'**
  String get wealthYogasTitle;

  /// No description provided for @wealthDrainsLabel.
  ///
  /// In en, this message translates to:
  /// **'DRAINS'**
  String get wealthDrainsLabel;

  /// No description provided for @wealthBoostersLabel.
  ///
  /// In en, this message translates to:
  /// **'BOOSTERS'**
  String get wealthBoostersLabel;

  /// No description provided for @wealthYearlyTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Yearly Trend'**
  String get wealthYearlyTrendTitle;

  /// No description provided for @wealthGrowthTitle.
  ///
  /// In en, this message translates to:
  /// **'Wealth Growth'**
  String get wealthGrowthTitle;

  /// No description provided for @wealthCashPressureTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash Pressure'**
  String get wealthCashPressureTitle;

  /// No description provided for @wealthMoneyPersonalityTitle.
  ///
  /// In en, this message translates to:
  /// **'Money Personality'**
  String get wealthMoneyPersonalityTitle;

  /// No description provided for @wealthTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'WEALTH TYPE'**
  String get wealthTypeLabel;

  /// No description provided for @wealthRiskAppetiteLabel.
  ///
  /// In en, this message translates to:
  /// **'RISK APPETITE'**
  String get wealthRiskAppetiteLabel;

  /// No description provided for @wealthInvestmentStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'INVESTMENT STYLE'**
  String get wealthInvestmentStyleLabel;

  /// No description provided for @wealthMoneyPersonalityLabel.
  ///
  /// In en, this message translates to:
  /// **'MONEY PERSONALITY'**
  String get wealthMoneyPersonalityLabel;

  /// No description provided for @wealthSpendingLabel.
  ///
  /// In en, this message translates to:
  /// **'SPENDING'**
  String get wealthSpendingLabel;

  /// No description provided for @wealthDebtProbStat.
  ///
  /// In en, this message translates to:
  /// **'DEBT PROB %'**
  String get wealthDebtProbStat;

  /// No description provided for @wealthInheritanceStat.
  ///
  /// In en, this message translates to:
  /// **'INHERITANCE %'**
  String get wealthInheritanceStat;

  /// No description provided for @wealthSuddenGainsStat.
  ///
  /// In en, this message translates to:
  /// **'SUDDEN GAINS %'**
  String get wealthSuddenGainsStat;

  /// No description provided for @wealthSpouseBoostStat.
  ///
  /// In en, this message translates to:
  /// **'SPOUSE BOOST %'**
  String get wealthSpouseBoostStat;

  /// No description provided for @wealthSuccessProbabilitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Success probability: {pct}%'**
  String wealthSuccessProbabilitySubtitle(Object pct);

  /// No description provided for @wealthLifetimeClassLabel.
  ///
  /// In en, this message translates to:
  /// **'LIFETIME WEALTH CLASS'**
  String get wealthLifetimeClassLabel;

  /// No description provided for @wealthPrimaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Primary: {value}'**
  String wealthPrimaryLabel(Object value);

  /// No description provided for @wealthPeakLabel.
  ///
  /// In en, this message translates to:
  /// **'Peak: {value}'**
  String wealthPeakLabel(Object value);

  /// No description provided for @wealthIncomeWord.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get wealthIncomeWord;

  /// No description provided for @wealthSourcesSuffix.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get wealthSourcesSuffix;

  /// No description provided for @wealthInvestmentWord.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get wealthInvestmentWord;

  /// No description provided for @wealthMixSuffix.
  ///
  /// In en, this message translates to:
  /// **'Mix'**
  String get wealthMixSuffix;

  /// No description provided for @wealthDrivenByLabel.
  ///
  /// In en, this message translates to:
  /// **'Driven by {planet}'**
  String wealthDrivenByLabel(Object planet);

  /// No description provided for @marriageScoresHeader.
  ///
  /// In en, this message translates to:
  /// **'💒 MARRIAGE SCORES'**
  String get marriageScoresHeader;

  /// No description provided for @marriageOverallStat.
  ///
  /// In en, this message translates to:
  /// **'OVERALL\nMARRIAGE'**
  String get marriageOverallStat;

  /// No description provided for @marriageHarmonyStat.
  ///
  /// In en, this message translates to:
  /// **'MARITAL\nHARMONY'**
  String get marriageHarmonyStat;

  /// No description provided for @marriageDomesticStabilityStat.
  ///
  /// In en, this message translates to:
  /// **'DOMESTIC\nSTABILITY'**
  String get marriageDomesticStabilityStat;

  /// No description provided for @marriageLongevityStat.
  ///
  /// In en, this message translates to:
  /// **'LONGEVITY'**
  String get marriageLongevityStat;

  /// No description provided for @marriageSatisfactionStat.
  ///
  /// In en, this message translates to:
  /// **'SATISFACTION'**
  String get marriageSatisfactionStat;

  /// No description provided for @marriageClarityStat.
  ///
  /// In en, this message translates to:
  /// **'CLARITY'**
  String get marriageClarityStat;

  /// No description provided for @marriageWindowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Marriage Windows'**
  String get marriageWindowsTitle;

  /// No description provided for @marriagePhasesTitle.
  ///
  /// In en, this message translates to:
  /// **'Marriage Phases'**
  String get marriagePhasesTitle;

  /// No description provided for @marriageInLawRelationsStat.
  ///
  /// In en, this message translates to:
  /// **'IN-LAW RELATIONS'**
  String get marriageInLawRelationsStat;

  /// No description provided for @marriageFamilyHarmonyStat.
  ///
  /// In en, this message translates to:
  /// **'FAMILY HARMONY'**
  String get marriageFamilyHarmonyStat;

  /// No description provided for @marriageFertilityStat.
  ///
  /// In en, this message translates to:
  /// **'FERTILITY'**
  String get marriageFertilityStat;

  /// No description provided for @marriageHomeOwnershipStat.
  ///
  /// In en, this message translates to:
  /// **'HOME OWNERSHIP'**
  String get marriageHomeOwnershipStat;

  /// No description provided for @marriageDivorceRiskStat.
  ///
  /// In en, this message translates to:
  /// **'DIVORCE RISK'**
  String get marriageDivorceRiskStat;

  /// No description provided for @marriageInfidelityStat.
  ///
  /// In en, this message translates to:
  /// **'INFIDELITY'**
  String get marriageInfidelityStat;

  /// No description provided for @marriageConflictStat.
  ///
  /// In en, this message translates to:
  /// **'CONFLICT'**
  String get marriageConflictStat;

  /// No description provided for @marriageDistanceStat.
  ///
  /// In en, this message translates to:
  /// **'DISTANCE'**
  String get marriageDistanceStat;

  /// No description provided for @marriageSeekInPartnerTitle.
  ///
  /// In en, this message translates to:
  /// **'★ SEEK IN PARTNER'**
  String get marriageSeekInPartnerTitle;

  /// No description provided for @marriageAvoidInPartnerTitle.
  ///
  /// In en, this message translates to:
  /// **'⚠ AVOID IN PARTNER'**
  String get marriageAvoidInPartnerTitle;

  /// No description provided for @marriageRealizationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Realization: {pct}%'**
  String marriageRealizationSubtitle(Object pct);

  /// No description provided for @marriageDarakarakaWord.
  ///
  /// In en, this message translates to:
  /// **'Darakaraka'**
  String get marriageDarakarakaWord;

  /// No description provided for @marriageSpouseKarakaSuffix.
  ///
  /// In en, this message translates to:
  /// **'Spouse Karaka'**
  String get marriageSpouseKarakaSuffix;

  /// No description provided for @marriageDarakarakaDkLabel.
  ///
  /// In en, this message translates to:
  /// **'DARAKARAKA (DK)'**
  String get marriageDarakarakaDkLabel;

  /// No description provided for @marriage7thWord.
  ///
  /// In en, this message translates to:
  /// **'7th'**
  String get marriage7thWord;

  /// No description provided for @marriageSignLabel.
  ///
  /// In en, this message translates to:
  /// **'SIGN'**
  String get marriageSignLabel;

  /// No description provided for @marriageLordInLabel.
  ///
  /// In en, this message translates to:
  /// **'LORD IN'**
  String get marriageLordInLabel;

  /// No description provided for @marriageStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'STRENGTH'**
  String get marriageStrengthLabel;

  /// No description provided for @marriageSpouseWord.
  ///
  /// In en, this message translates to:
  /// **'Spouse'**
  String get marriageSpouseWord;

  /// No description provided for @marriageProfileSuffix.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get marriageProfileSuffix;

  /// No description provided for @marriageSpouseTraitsTitle.
  ///
  /// In en, this message translates to:
  /// **'★ SPOUSE TRAITS'**
  String get marriageSpouseTraitsTitle;

  /// No description provided for @marriageLikelyProfessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'● LIKELY PROFESSIONS'**
  String get marriageLikelyProfessionsTitle;

  /// No description provided for @marriageHarmonyWord.
  ///
  /// In en, this message translates to:
  /// **'Harmony'**
  String get marriageHarmonyWord;

  /// No description provided for @marriageRadarSuffix.
  ///
  /// In en, this message translates to:
  /// **'Radar'**
  String get marriageRadarSuffix;

  /// No description provided for @marriagePhysicalLabel.
  ///
  /// In en, this message translates to:
  /// **'Physical'**
  String get marriagePhysicalLabel;

  /// No description provided for @marriageSharedValuesLabel.
  ///
  /// In en, this message translates to:
  /// **'Shared Values'**
  String get marriageSharedValuesLabel;

  /// No description provided for @marriageConflictResolutionLabel.
  ///
  /// In en, this message translates to:
  /// **'Conflict Resolution'**
  String get marriageConflictResolutionLabel;

  /// No description provided for @marriageMangalDoshLabel.
  ///
  /// In en, this message translates to:
  /// **'⚠ MANGAL DOSH'**
  String get marriageMangalDoshLabel;

  /// No description provided for @marriageSeveritySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Severity: {value}'**
  String marriageSeveritySubtitle(Object value);

  /// No description provided for @marriageCancellationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cancellation: {value}'**
  String marriageCancellationSubtitle(Object value);

  /// No description provided for @marriageD9Word.
  ///
  /// In en, this message translates to:
  /// **'D-9'**
  String get marriageD9Word;

  /// No description provided for @marriageNavamsaSuffix.
  ///
  /// In en, this message translates to:
  /// **'Navamsa'**
  String get marriageNavamsaSuffix;

  /// No description provided for @multiChartTitleChild.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get multiChartTitleChild;

  /// No description provided for @multiChartTitleLove.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get multiChartTitleLove;

  /// No description provided for @multiChartTitleKarma.
  ///
  /// In en, this message translates to:
  /// **'Karma'**
  String get multiChartTitleKarma;

  /// No description provided for @multiChartTitleDefault.
  ///
  /// In en, this message translates to:
  /// **'Multi-Chart'**
  String get multiChartTitleDefault;

  /// No description provided for @multiChartSuffixProbability.
  ///
  /// In en, this message translates to:
  /// **'Probability'**
  String get multiChartSuffixProbability;

  /// No description provided for @multiChartSuffixCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Compatibility'**
  String get multiChartSuffixCompatibility;

  /// No description provided for @multiChartSuffixLinkage.
  ///
  /// In en, this message translates to:
  /// **'Linkage'**
  String get multiChartSuffixLinkage;

  /// No description provided for @multiChartSuffixReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get multiChartSuffixReport;

  /// No description provided for @multiChartParticipantsLabel.
  ///
  /// In en, this message translates to:
  /// **'PARTICIPANTS'**
  String get multiChartParticipantsLabel;

  /// No description provided for @multiChartAnalysisWord.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get multiChartAnalysisWord;

  /// No description provided for @multiChartConfidenceSuffix.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get multiChartConfidenceSuffix;

  /// No description provided for @multiChartQualityBadge.
  ///
  /// In en, this message translates to:
  /// **'QUALITY'**
  String get multiChartQualityBadge;

  /// No description provided for @multiChartPromptChatgpt.
  ///
  /// In en, this message translates to:
  /// **'Analyze this Vedic astrology report and give detailed insights:\n\n{formatted}'**
  String multiChartPromptChatgpt(Object formatted);

  /// No description provided for @multiChartPromptClaude.
  ///
  /// In en, this message translates to:
  /// **'Here is a Vedic astrology specialist report. Please analyze it thoroughly and provide actionable insights:\n\n{formatted}'**
  String multiChartPromptClaude(Object formatted);

  /// No description provided for @multiChartPromptGemini.
  ///
  /// In en, this message translates to:
  /// **'Review this Vedic astrology analysis and explain the key findings in simple language:\n\n{formatted}'**
  String multiChartPromptGemini(Object formatted);

  /// No description provided for @multiChartCopiedForLabel.
  ///
  /// In en, this message translates to:
  /// **'Copied for {label}!'**
  String multiChartCopiedForLabel(Object label);

  /// No description provided for @childProbTitle1.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get childProbTitle1;

  /// No description provided for @childProbTitle2.
  ///
  /// In en, this message translates to:
  /// **'Probability'**
  String get childProbTitle2;

  /// No description provided for @childNumberOfChildrenHeader1.
  ///
  /// In en, this message translates to:
  /// **'Number of'**
  String get childNumberOfChildrenHeader1;

  /// No description provided for @childNumberOfChildrenHeader2.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get childNumberOfChildrenHeader2;

  /// No description provided for @childTimingHeader1.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get childTimingHeader1;

  /// No description provided for @childTimingHeader2.
  ///
  /// In en, this message translates to:
  /// **'Moola Dasha'**
  String get childTimingHeader2;

  /// No description provided for @child5thHouseHeader1.
  ///
  /// In en, this message translates to:
  /// **'5th House'**
  String get child5thHouseHeader1;

  /// No description provided for @analysisWord.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get analysisWord;

  /// No description provided for @jupiterWord.
  ///
  /// In en, this message translates to:
  /// **'Jupiter'**
  String get jupiterWord;

  /// No description provided for @childD7Header1.
  ///
  /// In en, this message translates to:
  /// **'D7 Saptamsa'**
  String get childD7Header1;

  /// No description provided for @childBeejaHeader1.
  ///
  /// In en, this message translates to:
  /// **'Beeja & Kshetra'**
  String get childBeejaHeader1;

  /// No description provided for @childBeejaHeader2.
  ///
  /// In en, this message translates to:
  /// **'Sphuta'**
  String get childBeejaHeader2;

  /// No description provided for @childDoshaHeader1.
  ///
  /// In en, this message translates to:
  /// **'Dosha'**
  String get childDoshaHeader1;

  /// No description provided for @childVedicHeader1.
  ///
  /// In en, this message translates to:
  /// **'Vedic'**
  String get childVedicHeader1;

  /// No description provided for @childVedicHeader2.
  ///
  /// In en, this message translates to:
  /// **'Remedies'**
  String get childVedicHeader2;

  /// No description provided for @progenyProbabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'PROGENY PROBABILITY'**
  String get progenyProbabilityLabel;

  /// No description provided for @favorableWindowsLabel.
  ///
  /// In en, this message translates to:
  /// **'FAVORABLE WINDOWS'**
  String get favorableWindowsLabel;

  /// No description provided for @partnerOneLabel.
  ///
  /// In en, this message translates to:
  /// **'Partner 1'**
  String get partnerOneLabel;

  /// No description provided for @partnerTwoLabel.
  ///
  /// In en, this message translates to:
  /// **'Partner 2'**
  String get partnerTwoLabel;

  /// No description provided for @moonSignLabel.
  ///
  /// In en, this message translates to:
  /// **'Moon Sign'**
  String get moonSignLabel;

  /// No description provided for @lordInDusthana.
  ///
  /// In en, this message translates to:
  /// **'Lord in Dusthana'**
  String get lordInDusthana;

  /// No description provided for @lordStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Lord Strength'**
  String get lordStrengthLabel;

  /// No description provided for @houseStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'House Strength'**
  String get houseStrengthLabel;

  /// No description provided for @dignityLabel.
  ///
  /// In en, this message translates to:
  /// **'Dignity'**
  String get dignityLabel;

  /// No description provided for @directBadge.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get directBadge;

  /// No description provided for @notCombustBadge.
  ///
  /// In en, this message translates to:
  /// **'Not Combust'**
  String get notCombustBadge;

  /// No description provided for @in5thHouseBadge.
  ///
  /// In en, this message translates to:
  /// **'In 5th House'**
  String get in5thHouseBadge;

  /// No description provided for @aspects5thBadge.
  ///
  /// In en, this message translates to:
  /// **'Aspects 5th'**
  String get aspects5thBadge;

  /// No description provided for @no5thConnectionBadge.
  ///
  /// In en, this message translates to:
  /// **'No 5th Connection'**
  String get no5thConnectionBadge;

  /// No description provided for @jupiterInSignHeading.
  ///
  /// In en, this message translates to:
  /// **'Jupiter in {sign}'**
  String jupiterInSignHeading(String sign);

  /// No description provided for @d7LagnaLabel.
  ///
  /// In en, this message translates to:
  /// **'D7 Lagna'**
  String get d7LagnaLabel;

  /// No description provided for @d7FifthSignLabel.
  ///
  /// In en, this message translates to:
  /// **'D7 5th Sign'**
  String get d7FifthSignLabel;

  /// No description provided for @d7FifthLordLabel.
  ///
  /// In en, this message translates to:
  /// **'D7 5th Lord'**
  String get d7FifthLordLabel;

  /// No description provided for @jupiterInD7Label.
  ///
  /// In en, this message translates to:
  /// **'Jupiter in D7'**
  String get jupiterInD7Label;

  /// No description provided for @jupiterDignityLabel.
  ///
  /// In en, this message translates to:
  /// **'Jupiter Dignity'**
  String get jupiterDignityLabel;

  /// No description provided for @d7StrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'D7 Strength'**
  String get d7StrengthLabel;

  /// No description provided for @yesWord.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesWord;

  /// No description provided for @noWord.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noWord;

  /// No description provided for @beejaSphutaTitle.
  ///
  /// In en, this message translates to:
  /// **'BEEJA SPHUTA'**
  String get beejaSphutaTitle;

  /// No description provided for @kshetraSphutaTitle.
  ///
  /// In en, this message translates to:
  /// **'KSHETRA SPHUTA'**
  String get kshetraSphutaTitle;

  /// No description provided for @degreeLabel.
  ///
  /// In en, this message translates to:
  /// **'Degree'**
  String get degreeLabel;

  /// No description provided for @signLordLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign Lord'**
  String get signLordLabel;

  /// No description provided for @presentInLabel.
  ///
  /// In en, this message translates to:
  /// **'Present In'**
  String get presentInLabel;

  /// No description provided for @netPenaltyLabel.
  ///
  /// In en, this message translates to:
  /// **'Net Penalty'**
  String get netPenaltyLabel;

  /// No description provided for @remedyGemstone.
  ///
  /// In en, this message translates to:
  /// **'Gemstone Remedies'**
  String get remedyGemstone;

  /// No description provided for @remedyMantra.
  ///
  /// In en, this message translates to:
  /// **'Mantra Remedies'**
  String get remedyMantra;

  /// No description provided for @remedyRitual.
  ///
  /// In en, this message translates to:
  /// **'Ritual Remedies'**
  String get remedyRitual;

  /// No description provided for @remedyLifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle Remedies'**
  String get remedyLifestyle;

  /// No description provided for @remedyCharitable.
  ///
  /// In en, this message translates to:
  /// **'Charitable Remedies'**
  String get remedyCharitable;

  /// No description provided for @copiedForName.
  ///
  /// In en, this message translates to:
  /// **'Copied for {name}!'**
  String copiedForName(String name);

  /// No description provided for @mahadashaLabel.
  ///
  /// In en, this message translates to:
  /// **'Mahadasha'**
  String get mahadashaLabel;

  /// No description provided for @mdPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'MD Period'**
  String get mdPeriodLabel;

  /// No description provided for @antardashaLabel.
  ///
  /// In en, this message translates to:
  /// **'Antardasha'**
  String get antardashaLabel;

  /// No description provided for @adPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'AD Period'**
  String get adPeriodLabel;

  /// No description provided for @pratyantardashaLabel.
  ///
  /// In en, this message translates to:
  /// **'Pratyantardasha'**
  String get pratyantardashaLabel;

  /// No description provided for @favorabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Favorability'**
  String get favorabilityLabel;

  /// No description provided for @factorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Factor: {factor}'**
  String factorPrefix(String factor);

  /// No description provided for @appliesToLabel.
  ///
  /// In en, this message translates to:
  /// **'Applies to: {value}'**
  String appliesToLabel(String value);

  /// No description provided for @qualityTag.
  ///
  /// In en, this message translates to:
  /// **'QUALITY'**
  String get qualityTag;

  /// No description provided for @reliabilityVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very High reliability'**
  String get reliabilityVeryHigh;

  /// No description provided for @reliabilityGuidanceLevel.
  ///
  /// In en, this message translates to:
  /// **'Guidance-level reading'**
  String get reliabilityGuidanceLevel;

  /// No description provided for @karmaLinkTitle1.
  ///
  /// In en, this message translates to:
  /// **'Karma'**
  String get karmaLinkTitle1;

  /// No description provided for @karmaLinkTitle2.
  ///
  /// In en, this message translates to:
  /// **'Linkage'**
  String get karmaLinkTitle2;

  /// No description provided for @karmaFoundationHeader1.
  ///
  /// In en, this message translates to:
  /// **'Karmic'**
  String get karmaFoundationHeader1;

  /// No description provided for @karmaFoundationHeader2.
  ///
  /// In en, this message translates to:
  /// **'Foundation'**
  String get karmaFoundationHeader2;

  /// No description provided for @karmaPairwiseHeader1.
  ///
  /// In en, this message translates to:
  /// **'Pairwise'**
  String get karmaPairwiseHeader1;

  /// No description provided for @karmaPairwiseHeader2.
  ///
  /// In en, this message translates to:
  /// **'Linkages'**
  String get karmaPairwiseHeader2;

  /// No description provided for @karmaGroupHeader1.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get karmaGroupHeader1;

  /// No description provided for @karmaGroupHeader2.
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get karmaGroupHeader2;

  /// No description provided for @karmaPastLifeHeader1.
  ///
  /// In en, this message translates to:
  /// **'Past Life'**
  String get karmaPastLifeHeader1;

  /// No description provided for @karmaPastLifeHeader2.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get karmaPastLifeHeader2;

  /// No description provided for @karmaCurrentLifeHeader1.
  ///
  /// In en, this message translates to:
  /// **'Current Life'**
  String get karmaCurrentLifeHeader1;

  /// No description provided for @karmaCurrentLifeHeader2.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get karmaCurrentLifeHeader2;

  /// No description provided for @karmaDebtsHeader2.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get karmaDebtsHeader2;

  /// No description provided for @karmaMoolaDashaHeader1.
  ///
  /// In en, this message translates to:
  /// **'Moola Dasha'**
  String get karmaMoolaDashaHeader1;

  /// No description provided for @karmaMoolaDashaHeader2.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get karmaMoolaDashaHeader2;

  /// No description provided for @karmaDeepAuditHeader1.
  ///
  /// In en, this message translates to:
  /// **'Deep Audit'**
  String get karmaDeepAuditHeader1;

  /// No description provided for @karmaDeepAuditHeader2.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get karmaDeepAuditHeader2;

  /// No description provided for @karmaHeroLabel.
  ///
  /// In en, this message translates to:
  /// **'PAST LIFE KARMA LINKAGE'**
  String get karmaHeroLabel;

  /// No description provided for @karmaKetuMastery.
  ///
  /// In en, this message translates to:
  /// **'KETU MASTERY'**
  String get karmaKetuMastery;

  /// No description provided for @nakshatraLabel.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra'**
  String get nakshatraLabel;

  /// No description provided for @deityLabel.
  ///
  /// In en, this message translates to:
  /// **'Deity'**
  String get deityLabel;

  /// No description provided for @masteryScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Mastery Score'**
  String get masteryScoreLabel;

  /// No description provided for @karmaRahuGrowth.
  ///
  /// In en, this message translates to:
  /// **'RAHU GROWTH'**
  String get karmaRahuGrowth;

  /// No description provided for @growthScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Growth Score'**
  String get growthScoreLabel;

  /// No description provided for @karmaAtmakaraka.
  ///
  /// In en, this message translates to:
  /// **'ATMAKARAKA'**
  String get karmaAtmakaraka;

  /// No description provided for @karmaSaturnKarma.
  ///
  /// In en, this message translates to:
  /// **'SATURN KARMA'**
  String get karmaSaturnKarma;

  /// No description provided for @karma12thHouse.
  ///
  /// In en, this message translates to:
  /// **'12TH HOUSE'**
  String get karma12thHouse;

  /// No description provided for @karma9thHousePunya.
  ///
  /// In en, this message translates to:
  /// **'9TH HOUSE PUNYA'**
  String get karma9thHousePunya;

  /// No description provided for @bhavaScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Bhava Score'**
  String get bhavaScoreLabel;

  /// No description provided for @karmaD60Signature.
  ///
  /// In en, this message translates to:
  /// **'D60 SIGNATURE'**
  String get karmaD60Signature;

  /// No description provided for @depthScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Depth Score'**
  String get depthScoreLabel;

  /// No description provided for @linkageStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Linkage Strength'**
  String get linkageStrengthLabel;

  /// No description provided for @karmaLinkageFactorsHeader.
  ///
  /// In en, this message translates to:
  /// **'LINKAGE FACTORS ({count} active)'**
  String karmaLinkageFactorsHeader(int count);

  /// No description provided for @factorColumnLabel.
  ///
  /// In en, this message translates to:
  /// **'Factor'**
  String get factorColumnLabel;

  /// No description provided for @weightColumnLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightColumnLabel;

  /// No description provided for @meaningColumnLabel.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get meaningColumnLabel;

  /// No description provided for @statusColumnLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusColumnLabel;

  /// No description provided for @karmaPastLifeConnection.
  ///
  /// In en, this message translates to:
  /// **'PAST LIFE CONNECTION'**
  String get karmaPastLifeConnection;

  /// No description provided for @karmaCurrentLifeDynamic.
  ///
  /// In en, this message translates to:
  /// **'CURRENT LIFE DYNAMIC'**
  String get karmaCurrentLifeDynamic;

  /// No description provided for @karmaWhatTheyTeach.
  ///
  /// In en, this message translates to:
  /// **'WHAT THEY TEACH EACH OTHER'**
  String get karmaWhatTheyTeach;

  /// No description provided for @karmaGroupThemeHeader.
  ///
  /// In en, this message translates to:
  /// **'GROUP KARMIC THEME'**
  String get karmaGroupThemeHeader;

  /// No description provided for @karmaSharedSettingHeader.
  ///
  /// In en, this message translates to:
  /// **'SHARED PAST LIFE SETTING'**
  String get karmaSharedSettingHeader;

  /// No description provided for @karmaCollectiveKetuHeader.
  ///
  /// In en, this message translates to:
  /// **'COLLECTIVE KETU PATTERN'**
  String get karmaCollectiveKetuHeader;

  /// No description provided for @karmaCollectiveRahuHeader.
  ///
  /// In en, this message translates to:
  /// **'COLLECTIVE RAHU PATTERN'**
  String get karmaCollectiveRahuHeader;

  /// No description provided for @housesPrefixLabel.
  ///
  /// In en, this message translates to:
  /// **'Houses: '**
  String get housesPrefixLabel;

  /// No description provided for @signsPrefixLabel.
  ///
  /// In en, this message translates to:
  /// **'Signs: '**
  String get signsPrefixLabel;

  /// No description provided for @karmicCohesionLabel.
  ///
  /// In en, this message translates to:
  /// **'Karmic Cohesion'**
  String get karmicCohesionLabel;

  /// No description provided for @karmaGroupSoulContractHeader.
  ///
  /// In en, this message translates to:
  /// **'GROUP SOUL CONTRACT'**
  String get karmaGroupSoulContractHeader;

  /// No description provided for @goalLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goalLabel;

  /// No description provided for @karmaSharedGoalHeader.
  ///
  /// In en, this message translates to:
  /// **'SHARED PAST LIFE GOAL'**
  String get karmaSharedGoalHeader;

  /// No description provided for @howToGrowHeader.
  ///
  /// In en, this message translates to:
  /// **'HOW TO GROW'**
  String get howToGrowHeader;

  /// No description provided for @moolaDashaPrefix.
  ///
  /// In en, this message translates to:
  /// **'Moola Dasha: {value}'**
  String moolaDashaPrefix(String value);

  /// No description provided for @karmaSharedLessonHeader.
  ///
  /// In en, this message translates to:
  /// **'SHARED GROUP LESSON'**
  String get karmaSharedLessonHeader;

  /// No description provided for @karmaMutualTeachingHeader.
  ///
  /// In en, this message translates to:
  /// **'MUTUAL TEACHING MAP'**
  String get karmaMutualTeachingHeader;

  /// No description provided for @karmaTeachingDynamicsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Teaching dynamics will emerge as karmic connections deepen.'**
  String get karmaTeachingDynamicsPlaceholder;

  /// No description provided for @typeFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeFieldLabel;

  /// No description provided for @basisFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Basis'**
  String get basisFieldLabel;

  /// No description provided for @resolutionPathHeader.
  ///
  /// In en, this message translates to:
  /// **'RESOLUTION PATH'**
  String get resolutionPathHeader;

  /// No description provided for @dashaTimingPrefix.
  ///
  /// In en, this message translates to:
  /// **'Dasha Timing: {value}'**
  String dashaTimingPrefix(String value);

  /// No description provided for @mutualDebtsHeader.
  ///
  /// In en, this message translates to:
  /// **'MUTUAL DEBTS'**
  String get mutualDebtsHeader;

  /// No description provided for @mdLabel.
  ///
  /// In en, this message translates to:
  /// **'MD'**
  String get mdLabel;

  /// No description provided for @adLabel.
  ///
  /// In en, this message translates to:
  /// **'AD'**
  String get adLabel;

  /// No description provided for @pdLabel.
  ///
  /// In en, this message translates to:
  /// **'PD'**
  String get pdLabel;

  /// No description provided for @datesLabel.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get datesLabel;

  /// No description provided for @groupKarmicWindowHeader.
  ///
  /// In en, this message translates to:
  /// **'GROUP KARMIC WINDOW'**
  String get groupKarmicWindowHeader;

  /// No description provided for @parametersAuditedHeading.
  ///
  /// In en, this message translates to:
  /// **'{count} PARAMETERS AUDITED'**
  String parametersAuditedHeading(int count);

  /// No description provided for @valuePrefixLabel.
  ///
  /// In en, this message translates to:
  /// **'Value: '**
  String get valuePrefixLabel;

  /// No description provided for @weightPrefix.
  ///
  /// In en, this message translates to:
  /// **'W: {value}'**
  String weightPrefix(String value);

  /// No description provided for @loveCompatTitle1.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get loveCompatTitle1;

  /// No description provided for @loveCompatTitle2.
  ///
  /// In en, this message translates to:
  /// **'Compatibility'**
  String get loveCompatTitle2;

  /// No description provided for @loveAttractionHeader1.
  ///
  /// In en, this message translates to:
  /// **'Attraction &'**
  String get loveAttractionHeader1;

  /// No description provided for @loveAttractionHeader2.
  ///
  /// In en, this message translates to:
  /// **'Chemistry'**
  String get loveAttractionHeader2;

  /// No description provided for @loveEmotionalHeader1.
  ///
  /// In en, this message translates to:
  /// **'Emotional'**
  String get loveEmotionalHeader1;

  /// No description provided for @loveEmotionalHeader2.
  ///
  /// In en, this message translates to:
  /// **'Harmony'**
  String get loveEmotionalHeader2;

  /// No description provided for @loveMentalHeader1.
  ///
  /// In en, this message translates to:
  /// **'Mental'**
  String get loveMentalHeader1;

  /// No description provided for @loveMentalHeader2.
  ///
  /// In en, this message translates to:
  /// **'Rapport'**
  String get loveMentalHeader2;

  /// No description provided for @lovePassionHeader1.
  ///
  /// In en, this message translates to:
  /// **'Passion &'**
  String get lovePassionHeader1;

  /// No description provided for @lovePassionHeader2.
  ///
  /// In en, this message translates to:
  /// **'Physical'**
  String get lovePassionHeader2;

  /// No description provided for @loveLongtermHeader1.
  ///
  /// In en, this message translates to:
  /// **'Long-term'**
  String get loveLongtermHeader1;

  /// No description provided for @loveKarmicHeader1.
  ///
  /// In en, this message translates to:
  /// **'Karmic Love'**
  String get loveKarmicHeader1;

  /// No description provided for @loveKarmicHeader2.
  ///
  /// In en, this message translates to:
  /// **'Bond'**
  String get loveKarmicHeader2;

  /// No description provided for @loveChallengesHeader1.
  ///
  /// In en, this message translates to:
  /// **'Challenges &'**
  String get loveChallengesHeader1;

  /// No description provided for @loveChallengesHeader2.
  ///
  /// In en, this message translates to:
  /// **'Friction'**
  String get loveChallengesHeader2;

  /// No description provided for @loveTimingHeader1.
  ///
  /// In en, this message translates to:
  /// **'Love Timing'**
  String get loveTimingHeader1;

  /// No description provided for @loveRelationshipHeader1.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get loveRelationshipHeader1;

  /// No description provided for @loveRelationshipHeader2.
  ///
  /// In en, this message translates to:
  /// **'Dynamics'**
  String get loveRelationshipHeader2;

  /// No description provided for @loveRemediesHeader1.
  ///
  /// In en, this message translates to:
  /// **'Remedies &'**
  String get loveRemediesHeader1;

  /// No description provided for @loveRemediesHeader2.
  ///
  /// In en, this message translates to:
  /// **'Guidance'**
  String get loveRemediesHeader2;

  /// No description provided for @loveCompatHeroLabel.
  ///
  /// In en, this message translates to:
  /// **'LOVE COMPATIBILITY'**
  String get loveCompatHeroLabel;

  /// No description provided for @loveChipAttraction.
  ///
  /// In en, this message translates to:
  /// **'Attraction'**
  String get loveChipAttraction;

  /// No description provided for @loveChipPassion.
  ///
  /// In en, this message translates to:
  /// **'Passion'**
  String get loveChipPassion;

  /// No description provided for @loveChipChallenge.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get loveChipChallenge;

  /// No description provided for @venusSignLabel.
  ///
  /// In en, this message translates to:
  /// **'Venus Sign'**
  String get venusSignLabel;

  /// No description provided for @attractionScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Attraction Score'**
  String get attractionScoreLabel;

  /// No description provided for @activeContactsLabel.
  ///
  /// In en, this message translates to:
  /// **'Active Contacts'**
  String get activeContactsLabel;

  /// No description provided for @magneticPullLabel.
  ///
  /// In en, this message translates to:
  /// **'Magnetic Pull'**
  String get magneticPullLabel;

  /// No description provided for @initialAttractionLabel.
  ///
  /// In en, this message translates to:
  /// **'Initial Attraction'**
  String get initialAttractionLabel;

  /// No description provided for @emotionalScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Emotional Score'**
  String get emotionalScoreLabel;

  /// No description provided for @elementMatchLabel.
  ///
  /// In en, this message translates to:
  /// **'Element Match'**
  String get elementMatchLabel;

  /// No description provided for @harmonyLabel.
  ///
  /// In en, this message translates to:
  /// **'Harmony'**
  String get harmonyLabel;

  /// No description provided for @kootaYoni.
  ///
  /// In en, this message translates to:
  /// **'YONI'**
  String get kootaYoni;

  /// No description provided for @kootaGana.
  ///
  /// In en, this message translates to:
  /// **'GANA'**
  String get kootaGana;

  /// No description provided for @kootaTara.
  ///
  /// In en, this message translates to:
  /// **'TARA'**
  String get kootaTara;

  /// No description provided for @doshaPresentBadge.
  ///
  /// In en, this message translates to:
  /// **'Dosha Present'**
  String get doshaPresentBadge;

  /// No description provided for @noDoshaBadge.
  ///
  /// In en, this message translates to:
  /// **'No Dosha'**
  String get noDoshaBadge;

  /// No description provided for @axisLabel.
  ///
  /// In en, this message translates to:
  /// **'Axis'**
  String get axisLabel;

  /// No description provided for @mentalScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Mental Score'**
  String get mentalScoreLabel;

  /// No description provided for @mercuryDynamicsLabel.
  ///
  /// In en, this message translates to:
  /// **'MERCURY DYNAMICS'**
  String get mercuryDynamicsLabel;

  /// No description provided for @communicationStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'COMMUNICATION STYLE MATCH'**
  String get communicationStyleLabel;

  /// No description provided for @intellectualConnectionLabel.
  ///
  /// In en, this message translates to:
  /// **'INTELLECTUAL CONNECTION'**
  String get intellectualConnectionLabel;

  /// No description provided for @passionScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Passion Score'**
  String get passionScoreLabel;

  /// No description provided for @marsVenusLabel.
  ///
  /// In en, this message translates to:
  /// **'MARS-VENUS INTERPLAY'**
  String get marsVenusLabel;

  /// No description provided for @physicalChemistryLabel.
  ///
  /// In en, this message translates to:
  /// **'PHYSICAL CHEMISTRY'**
  String get physicalChemistryLabel;

  /// No description provided for @yoniCompatLabel.
  ///
  /// In en, this message translates to:
  /// **'YONI COMPATIBILITY'**
  String get yoniCompatLabel;

  /// No description provided for @longtermScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Long-term Score'**
  String get longtermScoreLabel;

  /// No description provided for @seventhHouseSynastryLabel.
  ///
  /// In en, this message translates to:
  /// **'7TH HOUSE SYNASTRY'**
  String get seventhHouseSynastryLabel;

  /// No description provided for @commitmentPotentialLabel.
  ///
  /// In en, this message translates to:
  /// **'COMMITMENT POTENTIAL'**
  String get commitmentPotentialLabel;

  /// No description provided for @jupiterBlessingLabel.
  ///
  /// In en, this message translates to:
  /// **'JUPITER BLESSING'**
  String get jupiterBlessingLabel;

  /// No description provided for @d9NavamsaResonanceLabel.
  ///
  /// In en, this message translates to:
  /// **'D9 NAVAMSA RESONANCE'**
  String get d9NavamsaResonanceLabel;

  /// No description provided for @saturnLongevityLabel.
  ///
  /// In en, this message translates to:
  /// **'SATURN LONGEVITY'**
  String get saturnLongevityLabel;

  /// No description provided for @karmicScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Karmic Score'**
  String get karmicScoreLabel;

  /// No description provided for @darakarakaLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'DARAKARAKA LINK'**
  String get darakarakaLinkLabel;

  /// No description provided for @sourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get sourceLabel;

  /// No description provided for @emotionalGiverReceiverLabel.
  ///
  /// In en, this message translates to:
  /// **'EMOTIONAL GIVER / RECEIVER'**
  String get emotionalGiverReceiverLabel;

  /// No description provided for @powerBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'POWER BALANCE'**
  String get powerBalanceLabel;

  /// No description provided for @growthDynamicLabel.
  ///
  /// In en, this message translates to:
  /// **'GROWTH DYNAMIC'**
  String get growthDynamicLabel;

  /// No description provided for @addressesLabel.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addressesLabel;

  /// No description provided for @loveScoresLabel.
  ///
  /// In en, this message translates to:
  /// **'LOVE SCORES'**
  String get loveScoresLabel;

  /// No description provided for @loveCapacityLabel.
  ///
  /// In en, this message translates to:
  /// **'LOVE\nCAPACITY'**
  String get loveCapacityLabel;

  /// No description provided for @emotionalAvailabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'EMOTIONAL\nAVAILABILITY'**
  String get emotionalAvailabilityLabel;

  /// No description provided for @romanticAttractionLabel.
  ///
  /// In en, this message translates to:
  /// **'ROMANTIC\nATTRACTION'**
  String get romanticAttractionLabel;

  /// No description provided for @commitmentWord.
  ///
  /// In en, this message translates to:
  /// **'COMMITMENT'**
  String get commitmentWord;

  /// No description provided for @intimacyWord.
  ///
  /// In en, this message translates to:
  /// **'INTIMACY'**
  String get intimacyWord;

  /// No description provided for @fidelityWord.
  ///
  /// In en, this message translates to:
  /// **'FIDELITY'**
  String get fidelityWord;

  /// No description provided for @loveProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Love Profile'**
  String get loveProfileTitle;

  /// No description provided for @loveStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'LOVE STYLE'**
  String get loveStyleLabel;

  /// No description provided for @attractionStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'ATTRACTION STYLE'**
  String get attractionStyleLabel;

  /// No description provided for @lovePathLabel.
  ///
  /// In en, this message translates to:
  /// **'LOVE PATH'**
  String get lovePathLabel;

  /// No description provided for @currentPhaseLabel.
  ///
  /// In en, this message translates to:
  /// **'CURRENT PHASE'**
  String get currentPhaseLabel;

  /// No description provided for @commitmentStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'COMMITMENT STYLE'**
  String get commitmentStyleLabel;

  /// No description provided for @loveWord.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get loveWord;

  /// No description provided for @karakasWord.
  ///
  /// In en, this message translates to:
  /// **'Karakas'**
  String get karakasWord;

  /// No description provided for @attractedToLabel.
  ///
  /// In en, this message translates to:
  /// **'ATTRACTED TO'**
  String get attractedToLabel;

  /// No description provided for @whatPartnerSeesLabel.
  ///
  /// In en, this message translates to:
  /// **'WHAT PARTNER SEES'**
  String get whatPartnerSeesLabel;

  /// No description provided for @romancePatternTitle.
  ///
  /// In en, this message translates to:
  /// **'Romance Pattern'**
  String get romancePatternTitle;

  /// No description provided for @firstLoveAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'FIRST LOVE AGE'**
  String get firstLoveAgeLabel;

  /// No description provided for @relationshipCountLabel.
  ///
  /// In en, this message translates to:
  /// **'RELATIONSHIP COUNT'**
  String get relationshipCountLabel;

  /// No description provided for @avgDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'AVG DURATION'**
  String get avgDurationLabel;

  /// No description provided for @breakupTriggerLabel.
  ///
  /// In en, this message translates to:
  /// **'BREAKUP TRIGGER'**
  String get breakupTriggerLabel;

  /// No description provided for @heartbreakRecoveryLabel.
  ///
  /// In en, this message translates to:
  /// **'HEARTBREAK RECOVERY'**
  String get heartbreakRecoveryLabel;

  /// No description provided for @loveTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Love Trend'**
  String get loveTrendTitle;

  /// No description provided for @newLoveWindowsTitle.
  ///
  /// In en, this message translates to:
  /// **'New Love Windows'**
  String get newLoveWindowsTitle;

  /// No description provided for @loveBlocksTitle.
  ///
  /// In en, this message translates to:
  /// **'Love Blocks'**
  String get loveBlocksTitle;

  /// No description provided for @activeBlocksLabel.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE BLOCKS'**
  String get activeBlocksLabel;

  /// No description provided for @loveMarriagePctLabel.
  ///
  /// In en, this message translates to:
  /// **'LOVE MARRIAGE %'**
  String get loveMarriagePctLabel;

  /// No description provided for @heartbreakVulnLabel.
  ///
  /// In en, this message translates to:
  /// **'HEARTBREAK VULN'**
  String get heartbreakVulnLabel;

  /// No description provided for @selfSabotageLabel.
  ///
  /// In en, this message translates to:
  /// **'SELF-SABOTAGE'**
  String get selfSabotageLabel;

  /// No description provided for @emotionalIqLabel.
  ///
  /// In en, this message translates to:
  /// **'EMOTIONAL IQ'**
  String get emotionalIqLabel;

  /// No description provided for @fulfillmentPctLabel.
  ///
  /// In en, this message translates to:
  /// **'Fulfillment: {pct}%'**
  String fulfillmentPctLabel(String pct);

  /// No description provided for @languagesWord.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languagesWord;

  /// No description provided for @givesLabel.
  ///
  /// In en, this message translates to:
  /// **'GIVES'**
  String get givesLabel;

  /// No description provided for @receivesLabel.
  ///
  /// In en, this message translates to:
  /// **'RECEIVES'**
  String get receivesLabel;

  /// No description provided for @idealWord.
  ///
  /// In en, this message translates to:
  /// **'Ideal'**
  String get idealWord;

  /// No description provided for @partnerWord.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get partnerWord;

  /// No description provided for @seekTheseTraitsLabel.
  ///
  /// In en, this message translates to:
  /// **'SEEK THESE TRAITS'**
  String get seekTheseTraitsLabel;

  /// No description provided for @dealbreakersLabel.
  ///
  /// In en, this message translates to:
  /// **'DEALBREAKERS'**
  String get dealbreakersLabel;

  /// No description provided for @propertyScoresLabel.
  ///
  /// In en, this message translates to:
  /// **'PROPERTY SCORES'**
  String get propertyScoresLabel;

  /// No description provided for @acquisitionCapacityLabel.
  ///
  /// In en, this message translates to:
  /// **'ACQUISITION\nCAPACITY'**
  String get acquisitionCapacityLabel;

  /// No description provided for @homeOwnershipPctLabel.
  ///
  /// In en, this message translates to:
  /// **'HOME\nOWNERSHIP %'**
  String get homeOwnershipPctLabel;

  /// No description provided for @reWealthPotentialLabel.
  ///
  /// In en, this message translates to:
  /// **'RE WEALTH\nPOTENTIAL'**
  String get reWealthPotentialLabel;

  /// No description provided for @rentalWord.
  ///
  /// In en, this message translates to:
  /// **'RENTAL'**
  String get rentalWord;

  /// No description provided for @vehiclesWord.
  ///
  /// In en, this message translates to:
  /// **'VEHICLES'**
  String get vehiclesWord;

  /// No description provided for @landPctLabel.
  ///
  /// In en, this message translates to:
  /// **'LAND %'**
  String get landPctLabel;

  /// No description provided for @propertyProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Property Profile'**
  String get propertyProfileTitle;

  /// No description provided for @karmaTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'KARMA TYPE'**
  String get karmaTypeLabel;

  /// No description provided for @environmentLabel.
  ///
  /// In en, this message translates to:
  /// **'ENVIRONMENT'**
  String get environmentLabel;

  /// No description provided for @styleLabel.
  ///
  /// In en, this message translates to:
  /// **'STYLE'**
  String get styleLabel;

  /// No description provided for @sizeLabel.
  ///
  /// In en, this message translates to:
  /// **'SIZE'**
  String get sizeLabel;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'LOCATION'**
  String get locationLabel;

  /// No description provided for @actionNext12mLabel.
  ///
  /// In en, this message translates to:
  /// **'ACTION NEXT 12M'**
  String get actionNext12mLabel;

  /// No description provided for @propertyWord.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get propertyWord;

  /// No description provided for @propertyYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Property Yogas'**
  String get propertyYogasTitle;

  /// No description provided for @drainsLabel.
  ///
  /// In en, this message translates to:
  /// **'DRAINS'**
  String get drainsLabel;

  /// No description provided for @boostersLabel.
  ///
  /// In en, this message translates to:
  /// **'BOOSTERS'**
  String get boostersLabel;

  /// No description provided for @propertyTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Property Trend'**
  String get propertyTrendTitle;

  /// No description provided for @buyingWindowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Buying Windows'**
  String get buyingWindowsTitle;

  /// No description provided for @constructionWindowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Construction Windows'**
  String get constructionWindowsTitle;

  /// No description provided for @maternalInherPctLabel.
  ///
  /// In en, this message translates to:
  /// **'MATERNAL INHER %'**
  String get maternalInherPctLabel;

  /// No description provided for @paternalInherPctLabel.
  ///
  /// In en, this message translates to:
  /// **'PATERNAL INHER %'**
  String get paternalInherPctLabel;

  /// No description provided for @multiHomePctLabel.
  ///
  /// In en, this message translates to:
  /// **'MULTI-HOME %'**
  String get multiHomePctLabel;

  /// No description provided for @investmentPctLabel.
  ///
  /// In en, this message translates to:
  /// **'INVESTMENT %'**
  String get investmentPctLabel;

  /// No description provided for @vehicleProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Profile'**
  String get vehicleProfileTitle;

  /// No description provided for @countLabel.
  ///
  /// In en, this message translates to:
  /// **'COUNT'**
  String get countLabel;

  /// No description provided for @firstAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'FIRST AGE'**
  String get firstAgeLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY'**
  String get categoryLabel;

  /// No description provided for @luxuryLabel.
  ///
  /// In en, this message translates to:
  /// **'LUXURY'**
  String get luxuryLabel;

  /// No description provided for @lifetimeCountFulfillmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Lifetime count: {count} · Fulfillment: {pct}%'**
  String lifetimeCountFulfillmentLabel(String count, String pct);

  /// No description provided for @pressureWord.
  ///
  /// In en, this message translates to:
  /// **'PRESSURE'**
  String get pressureWord;

  /// No description provided for @protectionWord.
  ///
  /// In en, this message translates to:
  /// **'PROTECTION'**
  String get protectionWord;

  /// No description provided for @astrologicalWord.
  ///
  /// In en, this message translates to:
  /// **'Astrological'**
  String get astrologicalWord;

  /// No description provided for @keyRisksHeader1.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get keyRisksHeader1;

  /// No description provided for @keyRisksHeader2.
  ///
  /// In en, this message translates to:
  /// **'Risks'**
  String get keyRisksHeader2;

  /// No description provided for @reportCopiedShort.
  ///
  /// In en, this message translates to:
  /// **'Report copied!'**
  String get reportCopiedShort;

  /// No description provided for @keyScoresLabel.
  ///
  /// In en, this message translates to:
  /// **'KEY SCORES'**
  String get keyScoresLabel;

  /// No description provided for @allScoresCountLabel.
  ///
  /// In en, this message translates to:
  /// **'All Scores ({count})'**
  String allScoresCountLabel(int count);

  /// No description provided for @windowsWord.
  ///
  /// In en, this message translates to:
  /// **'Windows'**
  String get windowsWord;

  /// No description provided for @genericFailedMsg.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get genericFailedMsg;

  /// No description provided for @unknownWord.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownWord;

  /// No description provided for @selectKarmaChartsLabel.
  ///
  /// In en, this message translates to:
  /// **'Select 2-{max} Charts'**
  String selectKarmaChartsLabel(int max);

  /// No description provided for @selectChartsLabelCount.
  ///
  /// In en, this message translates to:
  /// **'Select {max} Charts'**
  String selectChartsLabelCount(int max);

  /// No description provided for @runningAnalysisLabel.
  ///
  /// In en, this message translates to:
  /// **'Running {label} analysis...'**
  String runningAnalysisLabel(String label);

  /// No description provided for @pickKarmicChartsHint.
  ///
  /// In en, this message translates to:
  /// **'Pick 2 to {max} charts to analyze karmic links'**
  String pickKarmicChartsHint(int max);

  /// No description provided for @pickMaleFemaleHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a Male and Female chart'**
  String get pickMaleFemaleHint;

  /// No description provided for @personOneLabel.
  ///
  /// In en, this message translates to:
  /// **'Person 1'**
  String get personOneLabel;

  /// No description provided for @personTwoLabel.
  ///
  /// In en, this message translates to:
  /// **'Person 2'**
  String get personTwoLabel;

  /// No description provided for @analysisFailedMsg.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed'**
  String get analysisFailedMsg;

  /// No description provided for @analyzeChartsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Analyze {count} Charts'**
  String analyzeChartsCountLabel(int count);

  /// No description provided for @contextGeneralLabel.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get contextGeneralLabel;

  /// No description provided for @contextLoveLabel.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get contextLoveLabel;

  /// No description provided for @contextBusinessLabel.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get contextBusinessLabel;

  /// No description provided for @contextFamilyLabel.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get contextFamilyLabel;

  /// No description provided for @contextTeamLabel.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get contextTeamLabel;

  /// No description provided for @contextFriendshipLabel.
  ///
  /// In en, this message translates to:
  /// **'Friendship'**
  String get contextFriendshipLabel;

  /// No description provided for @relationshipIntelTitle.
  ///
  /// In en, this message translates to:
  /// **'Relationship Intelligence'**
  String get relationshipIntelTitle;

  /// No description provided for @analyzingChartsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Analyzing {count} charts...'**
  String analyzingChartsCountLabel(int count);

  /// No description provided for @relationshipContextLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship Context'**
  String get relationshipContextLabel;

  /// No description provided for @kundliMilanReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Kundli Milan Report'**
  String get kundliMilanReportTitle;

  /// No description provided for @runningMilanAnalysisLabel.
  ///
  /// In en, this message translates to:
  /// **'Running Milan analysis...'**
  String get runningMilanAnalysisLabel;

  /// No description provided for @selectedCountOfTwoLabel.
  ///
  /// In en, this message translates to:
  /// **'{count}/2 selected'**
  String selectedCountOfTwoLabel(int count);

  /// No description provided for @runMilanAnalysisBtn.
  ///
  /// In en, this message translates to:
  /// **'Run Milan Analysis'**
  String get runMilanAnalysisBtn;

  /// No description provided for @noChartsCreateFirst.
  ///
  /// In en, this message translates to:
  /// **'No charts. Create a birth chart first.'**
  String get noChartsCreateFirst;

  /// No description provided for @selectBirthChartAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Select a birth chart to analyze'**
  String get selectBirthChartAnalyze;

  /// No description provided for @doshAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Dosha Analysis'**
  String get doshAnalysis;

  /// No description provided for @doshActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{active} active / {total} checked'**
  String doshActiveCount(Object active, Object total);

  /// No description provided for @yogaActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{active} active / {total} yogas checked'**
  String yogaActiveCount(Object active, Object total);

  /// No description provided for @yogaActiveHeader.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE YOGAS ({count})'**
  String yogaActiveHeader(Object count);

  /// No description provided for @yogaHideInactiveCount.
  ///
  /// In en, this message translates to:
  /// **'Hide inactive yogas ({count})'**
  String yogaHideInactiveCount(Object count);

  /// No description provided for @yogaShowInactiveCount.
  ///
  /// In en, this message translates to:
  /// **'Show inactive yogas ({count})'**
  String yogaShowInactiveCount(Object count);

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get loadFailed;

  /// No description provided for @dashaDrillMd.
  ///
  /// In en, this message translates to:
  /// **'{planet} MD → Antardashas'**
  String dashaDrillMd(Object planet);

  /// No description provided for @dashaDrillAd.
  ///
  /// In en, this message translates to:
  /// **'{planet} AD → Pratyantardashas'**
  String dashaDrillAd(Object planet);

  /// No description provided for @dashaDrillPd.
  ///
  /// In en, this message translates to:
  /// **'{planet} PD → Sookshmadashas'**
  String dashaDrillPd(Object planet);

  /// No description provided for @dashaDrillSub.
  ///
  /// In en, this message translates to:
  /// **'{planet} Sub-periods'**
  String dashaDrillSub(Object planet);

  /// No description provided for @dashaBirthLordBalance.
  ///
  /// In en, this message translates to:
  /// **'Birth Lord: {lord} • Balance: {balance} yrs'**
  String dashaBirthLordBalance(Object lord, Object balance);

  /// No description provided for @dashaLagnaBalance.
  ///
  /// In en, this message translates to:
  /// **'Lagna: {lagna} • Balance: {balance} yrs'**
  String dashaLagnaBalance(Object lagna, Object balance);

  /// No description provided for @dashaYearsValue.
  ///
  /// In en, this message translates to:
  /// **'{years} years'**
  String dashaYearsValue(Object years);

  /// No description provided for @dashaCurrentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Current Dasha Period'**
  String get dashaCurrentPeriod;

  /// No description provided for @dashaAsOf.
  ///
  /// In en, this message translates to:
  /// **'As of: {date}'**
  String dashaAsOf(Object date);

  /// No description provided for @dashaActiveYogasCount.
  ///
  /// In en, this message translates to:
  /// **'Active Yogas in Current Period ({count})'**
  String dashaActiveYogasCount(Object count);

  /// No description provided for @dashaActiveDoshasCount.
  ///
  /// In en, this message translates to:
  /// **'Active Doshas in Current Period ({count})'**
  String dashaActiveDoshasCount(Object count);

  /// No description provided for @dashaNoYogasTriggered.
  ///
  /// In en, this message translates to:
  /// **'No yogas triggered'**
  String get dashaNoYogasTriggered;

  /// No description provided for @dashaNoDoshasTriggered.
  ///
  /// In en, this message translates to:
  /// **'No doshas triggered'**
  String get dashaNoDoshasTriggered;

  /// No description provided for @divD1Name.
  ///
  /// In en, this message translates to:
  /// **'Rasi (D-1)'**
  String get divD1Name;

  /// No description provided for @divD1Desc.
  ///
  /// In en, this message translates to:
  /// **'Physical existence, all matters'**
  String get divD1Desc;

  /// No description provided for @divD2Name.
  ///
  /// In en, this message translates to:
  /// **'Hora (D-2)'**
  String get divD2Name;

  /// No description provided for @divD2Desc.
  ///
  /// In en, this message translates to:
  /// **'Wealth, money'**
  String get divD2Desc;

  /// No description provided for @divD3Name.
  ///
  /// In en, this message translates to:
  /// **'Drekkana (D-3)'**
  String get divD3Name;

  /// No description provided for @divD3Desc.
  ///
  /// In en, this message translates to:
  /// **'Siblings, courage'**
  String get divD3Desc;

  /// No description provided for @divD4Name.
  ///
  /// In en, this message translates to:
  /// **'Chaturthamsa (D-4)'**
  String get divD4Name;

  /// No description provided for @divD4Desc.
  ///
  /// In en, this message translates to:
  /// **'Property, residence, fortune'**
  String get divD4Desc;

  /// No description provided for @divD5Name.
  ///
  /// In en, this message translates to:
  /// **'Panchamsa (D-5)'**
  String get divD5Name;

  /// No description provided for @divD5Desc.
  ///
  /// In en, this message translates to:
  /// **'Fame, authority, power'**
  String get divD5Desc;

  /// No description provided for @divD6Name.
  ///
  /// In en, this message translates to:
  /// **'Shashthamsa (D-6)'**
  String get divD6Name;

  /// No description provided for @divD6Desc.
  ///
  /// In en, this message translates to:
  /// **'Health troubles'**
  String get divD6Desc;

  /// No description provided for @divD7Name.
  ///
  /// In en, this message translates to:
  /// **'Saptamsa (D-7)'**
  String get divD7Name;

  /// No description provided for @divD7Desc.
  ///
  /// In en, this message translates to:
  /// **'Children, grandchildren'**
  String get divD7Desc;

  /// No description provided for @divD8Name.
  ///
  /// In en, this message translates to:
  /// **'Ashtamsa (D-8)'**
  String get divD8Name;

  /// No description provided for @divD8Desc.
  ///
  /// In en, this message translates to:
  /// **'Sudden troubles, litigation'**
  String get divD8Desc;

  /// No description provided for @divD9Name.
  ///
  /// In en, this message translates to:
  /// **'Navamsha (D-9)'**
  String get divD9Name;

  /// No description provided for @divD9Desc.
  ///
  /// In en, this message translates to:
  /// **'Marriage, spouse, dharma'**
  String get divD9Desc;

  /// No description provided for @divD10Name.
  ///
  /// In en, this message translates to:
  /// **'Dasamsha (D-10)'**
  String get divD10Name;

  /// No description provided for @divD10Desc.
  ///
  /// In en, this message translates to:
  /// **'Career, profession'**
  String get divD10Desc;

  /// No description provided for @divD11Name.
  ///
  /// In en, this message translates to:
  /// **'Rudramsha (D-11)'**
  String get divD11Name;

  /// No description provided for @divD11Desc.
  ///
  /// In en, this message translates to:
  /// **'Death, destruction'**
  String get divD11Desc;

  /// No description provided for @divD12Name.
  ///
  /// In en, this message translates to:
  /// **'Dwadasamsha (D-12)'**
  String get divD12Name;

  /// No description provided for @divD12Desc.
  ///
  /// In en, this message translates to:
  /// **'Parents, blood-relatives'**
  String get divD12Desc;

  /// No description provided for @divD16Name.
  ///
  /// In en, this message translates to:
  /// **'Shodasamsha (D-16)'**
  String get divD16Name;

  /// No description provided for @divD16Desc.
  ///
  /// In en, this message translates to:
  /// **'Vehicles, comforts, pleasures'**
  String get divD16Desc;

  /// No description provided for @divD20Name.
  ///
  /// In en, this message translates to:
  /// **'Vimsamsha (D-20)'**
  String get divD20Name;

  /// No description provided for @divD20Desc.
  ///
  /// In en, this message translates to:
  /// **'Spiritual matters, religious'**
  String get divD20Desc;

  /// No description provided for @divD24Name.
  ///
  /// In en, this message translates to:
  /// **'Chaturvimsamsha (D-24)'**
  String get divD24Name;

  /// No description provided for @divD24Desc.
  ///
  /// In en, this message translates to:
  /// **'Learning, knowledge, education'**
  String get divD24Desc;

  /// No description provided for @divD27Name.
  ///
  /// In en, this message translates to:
  /// **'Nakshatramsha (D-27)'**
  String get divD27Name;

  /// No description provided for @divD27Desc.
  ///
  /// In en, this message translates to:
  /// **'Strengths, weaknesses, nature'**
  String get divD27Desc;

  /// No description provided for @divD30Name.
  ///
  /// In en, this message translates to:
  /// **'Trimsamsha (D-30)'**
  String get divD30Name;

  /// No description provided for @divD30Desc.
  ///
  /// In en, this message translates to:
  /// **'Evils, sub-conscious, punishment'**
  String get divD30Desc;

  /// No description provided for @divD40Name.
  ///
  /// In en, this message translates to:
  /// **'Khavedamsha (D-40)'**
  String get divD40Name;

  /// No description provided for @divD40Desc.
  ///
  /// In en, this message translates to:
  /// **'Auspicious/inauspicious (maternal)'**
  String get divD40Desc;

  /// No description provided for @divD45Name.
  ///
  /// In en, this message translates to:
  /// **'Akshavedamsha (D-45)'**
  String get divD45Name;

  /// No description provided for @divD45Desc.
  ///
  /// In en, this message translates to:
  /// **'All matters (paternal)'**
  String get divD45Desc;

  /// No description provided for @divD60Name.
  ///
  /// In en, this message translates to:
  /// **'Shashtyamsha (D-60)'**
  String get divD60Name;

  /// No description provided for @divD60Desc.
  ///
  /// In en, this message translates to:
  /// **'Past-life karma — MOST IMPORTANT'**
  String get divD60Desc;

  /// No description provided for @lifeAreaCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get lifeAreaCareer;

  /// No description provided for @lifeAreaWealth.
  ///
  /// In en, this message translates to:
  /// **'Wealth'**
  String get lifeAreaWealth;

  /// No description provided for @lifeAreaMarriage.
  ///
  /// In en, this message translates to:
  /// **'Marriage'**
  String get lifeAreaMarriage;

  /// No description provided for @lifeAreaHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get lifeAreaHealth;

  /// No description provided for @lifeAreaSpirituality.
  ///
  /// In en, this message translates to:
  /// **'Spirituality'**
  String get lifeAreaSpirituality;

  /// No description provided for @lifeAreaGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade: {grade}'**
  String lifeAreaGrade(Object grade);

  /// No description provided for @lifeAreaFactorsLabel.
  ///
  /// In en, this message translates to:
  /// **'Factors:'**
  String get lifeAreaFactorsLabel;

  /// No description provided for @planetNakPada.
  ///
  /// In en, this message translates to:
  /// **'Nak: {nakshatra} ({pada})'**
  String planetNakPada(Object nakshatra, Object pada);

  /// No description provided for @planetNakLord.
  ///
  /// In en, this message translates to:
  /// **'NL: {lord}'**
  String planetNakLord(Object lord);

  /// No description provided for @planetLongitude.
  ///
  /// In en, this message translates to:
  /// **'Lon: {value}°'**
  String planetLongitude(Object value);

  /// No description provided for @chakraOverallHealth.
  ///
  /// In en, this message translates to:
  /// **'Overall Health'**
  String get chakraOverallHealth;

  /// No description provided for @careerWord.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get careerWord;

  /// No description provided for @failedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get failedToLoad;

  /// No description provided for @kundliAscendantLagna.
  ///
  /// In en, this message translates to:
  /// **'Ascendant (Lagna)'**
  String get kundliAscendantLagna;

  /// No description provided for @kundliMoonSignRashi.
  ///
  /// In en, this message translates to:
  /// **'Moon Sign (Rashi)'**
  String get kundliMoonSignRashi;

  /// No description provided for @kundliSunSign.
  ///
  /// In en, this message translates to:
  /// **'Sun Sign'**
  String get kundliSunSign;

  /// No description provided for @kundliEngineLabel.
  ///
  /// In en, this message translates to:
  /// **'Engine: {engine}'**
  String kundliEngineLabel(Object engine);

  /// No description provided for @kundliDegreeNakshatra.
  ///
  /// In en, this message translates to:
  /// **'Degree: {degree}°  •  Nakshatra: {nakshatra} ({pada})'**
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada);

  /// No description provided for @kundliNakLordDignity.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra Lord: {lord}  •  Dignity: {dignity}'**
  String kundliNakLordDignity(Object lord, Object dignity);

  /// No description provided for @kundliChartHeader.
  ///
  /// In en, this message translates to:
  /// **'{base} Chart — {sign}'**
  String kundliChartHeader(Object base, Object sign);

  /// No description provided for @kundliBaseChart.
  ///
  /// In en, this message translates to:
  /// **'{base} Chart'**
  String kundliBaseChart(Object base);

  /// No description provided for @careerSummary.
  ///
  /// In en, this message translates to:
  /// **'Career Summary'**
  String get careerSummary;

  /// No description provided for @phase.
  ///
  /// In en, this message translates to:
  /// **'Phase'**
  String get phase;

  /// No description provided for @confidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidenceLabel;

  /// No description provided for @careerScores.
  ///
  /// In en, this message translates to:
  /// **'Career Scores'**
  String get careerScores;

  /// No description provided for @stabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Stability'**
  String get stabilityLabel;

  /// No description provided for @growthLabel.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get growthLabel;

  /// No description provided for @gradeExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get gradeExcellent;

  /// No description provided for @gradeGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get gradeGood;

  /// No description provided for @gradeAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get gradeAverage;

  /// No description provided for @gradeBelowAvg.
  ///
  /// In en, this message translates to:
  /// **'Below Avg'**
  String get gradeBelowAvg;

  /// No description provided for @gradeWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get gradeWeak;

  /// No description provided for @careerTypeDomain.
  ///
  /// In en, this message translates to:
  /// **'Career & Domain'**
  String get careerTypeDomain;

  /// No description provided for @careerTimeline.
  ///
  /// In en, this message translates to:
  /// **'Career Timeline'**
  String get careerTimeline;

  /// No description provided for @dashaLabel.
  ///
  /// In en, this message translates to:
  /// **'Dasha: {dasha}'**
  String dashaLabel(Object dasha);

  /// No description provided for @improvementSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Improvement Suggestions'**
  String get improvementSuggestions;

  /// No description provided for @chartDetails.
  ///
  /// In en, this message translates to:
  /// **'Chart Details'**
  String get chartDetails;

  /// No description provided for @keyHousesCareer.
  ///
  /// In en, this message translates to:
  /// **'Key Houses (Career)'**
  String get keyHousesCareer;

  /// No description provided for @keyCareerPlanets.
  ///
  /// In en, this message translates to:
  /// **'Key Career Planets'**
  String get keyCareerPlanets;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// No description provided for @guna.
  ///
  /// In en, this message translates to:
  /// **'Guna'**
  String get guna;

  /// No description provided for @dasha.
  ///
  /// In en, this message translates to:
  /// **'Dasha'**
  String get dasha;

  /// No description provided for @satwik.
  ///
  /// In en, this message translates to:
  /// **'Satwik'**
  String get satwik;

  /// No description provided for @rajasik.
  ///
  /// In en, this message translates to:
  /// **'Rajasik'**
  String get rajasik;

  /// No description provided for @tamasik.
  ///
  /// In en, this message translates to:
  /// **'Tamasik'**
  String get tamasik;

  /// No description provided for @charGroupCorePersonality.
  ///
  /// In en, this message translates to:
  /// **'Core Personality'**
  String get charGroupCorePersonality;

  /// No description provided for @charGroupTrustHonesty.
  ///
  /// In en, this message translates to:
  /// **'Trust & Honesty'**
  String get charGroupTrustHonesty;

  /// No description provided for @charGroupLoyaltyCommitment.
  ///
  /// In en, this message translates to:
  /// **'Loyalty & Commitment'**
  String get charGroupLoyaltyCommitment;

  /// No description provided for @charGroupStrategicPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Strategic & Privacy'**
  String get charGroupStrategicPrivacy;

  /// No description provided for @charGroupFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get charGroupFinancial;

  /// No description provided for @charGroupAngerConflict.
  ///
  /// In en, this message translates to:
  /// **'Anger & Conflict'**
  String get charGroupAngerConflict;

  /// No description provided for @charGroupMoralDharmic.
  ///
  /// In en, this message translates to:
  /// **'Moral & Dharmic'**
  String get charGroupMoralDharmic;

  /// No description provided for @charGroupIntellectCommunication.
  ///
  /// In en, this message translates to:
  /// **'Intellect & Communication'**
  String get charGroupIntellectCommunication;

  /// No description provided for @charGroupEmotionalProfile.
  ///
  /// In en, this message translates to:
  /// **'Emotional Profile'**
  String get charGroupEmotionalProfile;

  /// No description provided for @charGroupMentalHealth.
  ///
  /// In en, this message translates to:
  /// **'Mental Health'**
  String get charGroupMentalHealth;

  /// No description provided for @charGroupRomantic.
  ///
  /// In en, this message translates to:
  /// **'Romantic'**
  String get charGroupRomantic;

  /// No description provided for @charGroupMarriageFamily.
  ///
  /// In en, this message translates to:
  /// **'Marriage & Family'**
  String get charGroupMarriageFamily;

  /// No description provided for @charGroupOverallLife.
  ///
  /// In en, this message translates to:
  /// **'Overall Life'**
  String get charGroupOverallLife;

  /// No description provided for @grahaDrishti.
  ///
  /// In en, this message translates to:
  /// **'Graha Drishti (Planet Aspects)'**
  String get grahaDrishti;

  /// No description provided for @grahaDrishtiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who aspects whom (%)'**
  String get grahaDrishtiSubtitle;

  /// No description provided for @lagnaAspectsReceived.
  ///
  /// In en, this message translates to:
  /// **'Lagna Aspects Received'**
  String get lagnaAspectsReceived;

  /// No description provided for @rashiDrishti.
  ///
  /// In en, this message translates to:
  /// **'Rashi Drishti (Sign Aspects)'**
  String get rashiDrishti;

  /// No description provided for @shadbalaRupas.
  ///
  /// In en, this message translates to:
  /// **'rupas'**
  String get shadbalaRupas;

  /// No description provided for @bhavaHouse1.
  ///
  /// In en, this message translates to:
  /// **'Self / Body'**
  String get bhavaHouse1;

  /// No description provided for @bhavaHouse2.
  ///
  /// In en, this message translates to:
  /// **'Wealth / Family'**
  String get bhavaHouse2;

  /// No description provided for @bhavaHouse3.
  ///
  /// In en, this message translates to:
  /// **'Siblings / Courage'**
  String get bhavaHouse3;

  /// No description provided for @bhavaHouse4.
  ///
  /// In en, this message translates to:
  /// **'Home / Mother'**
  String get bhavaHouse4;

  /// No description provided for @bhavaHouse5.
  ///
  /// In en, this message translates to:
  /// **'Children / Intellect'**
  String get bhavaHouse5;

  /// No description provided for @bhavaHouse6.
  ///
  /// In en, this message translates to:
  /// **'Enemies / Health'**
  String get bhavaHouse6;

  /// No description provided for @bhavaHouse7.
  ///
  /// In en, this message translates to:
  /// **'Marriage / Partner'**
  String get bhavaHouse7;

  /// No description provided for @bhavaHouse8.
  ///
  /// In en, this message translates to:
  /// **'Longevity'**
  String get bhavaHouse8;

  /// No description provided for @bhavaHouse9.
  ///
  /// In en, this message translates to:
  /// **'Fortune / Guru'**
  String get bhavaHouse9;

  /// No description provided for @bhavaHouse10.
  ///
  /// In en, this message translates to:
  /// **'Career / Father'**
  String get bhavaHouse10;

  /// No description provided for @bhavaHouse11.
  ///
  /// In en, this message translates to:
  /// **'Gains / Friends'**
  String get bhavaHouse11;

  /// No description provided for @bhavaHouse12.
  ///
  /// In en, this message translates to:
  /// **'Loss / Moksha'**
  String get bhavaHouse12;

  /// No description provided for @bhavaSignLord.
  ///
  /// In en, this message translates to:
  /// **'{sign} • Lord: {lord}'**
  String bhavaSignLord(Object sign, Object lord);

  /// No description provided for @bhavaSav.
  ///
  /// In en, this message translates to:
  /// **'SAV: {value}'**
  String bhavaSav(Object value);

  /// No description provided for @sarvaAshtakavarga.
  ///
  /// In en, this message translates to:
  /// **'Sarva Ashtakavarga (SAV)'**
  String get sarvaAshtakavarga;

  /// No description provided for @savSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Total: {total} rekhas (average sign = {avg})'**
  String savSubtitle(Object total, Object avg);

  /// No description provided for @ashtakavargaBav.
  ///
  /// In en, this message translates to:
  /// **'{planet} — BAV'**
  String ashtakavargaBav(Object planet);

  /// No description provided for @bavSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Total: {total} rekhas • At natal sign: {score}'**
  String bavSubtitle(Object total, Object score);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @gocharTransitScores.
  ///
  /// In en, this message translates to:
  /// **'Gochar (Transit Scores) — {date}'**
  String gocharTransitScores(Object date);

  /// No description provided for @gocharNativeMoon.
  ///
  /// In en, this message translates to:
  /// **'Native Moon: {sign}'**
  String gocharNativeMoon(Object sign);

  /// No description provided for @gocharBest.
  ///
  /// In en, this message translates to:
  /// **'BEST'**
  String get gocharBest;

  /// No description provided for @gocharWorst.
  ///
  /// In en, this message translates to:
  /// **'WORST'**
  String get gocharWorst;

  /// No description provided for @copiedOpening.
  ///
  /// In en, this message translates to:
  /// **'Copied! Opening {ai}...'**
  String copiedOpening(Object ai);

  /// No description provided for @openLink.
  ///
  /// In en, this message translates to:
  /// **'OPEN ↗'**
  String get openLink;

  /// No description provided for @discussReportWithAI.
  ///
  /// In en, this message translates to:
  /// **'DISCUSS THIS REPORT WITH AI'**
  String get discussReportWithAI;

  /// No description provided for @reliabilityHigh.
  ///
  /// In en, this message translates to:
  /// **'High reliability'**
  String get reliabilityHigh;

  /// No description provided for @reliabilityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate reliability'**
  String get reliabilityModerate;

  /// No description provided for @reliabilityLow.
  ///
  /// In en, this message translates to:
  /// **'Lower — guidance only'**
  String get reliabilityLow;

  /// No description provided for @reliabilityGoodEdu.
  ///
  /// In en, this message translates to:
  /// **'Good reliability · D-24 verified'**
  String get reliabilityGoodEdu;

  /// No description provided for @relationshipWord.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationshipWord;

  /// No description provided for @intelligenceWord.
  ///
  /// In en, this message translates to:
  /// **'Intelligence'**
  String get intelligenceWord;

  /// No description provided for @relationshipIntelligence.
  ///
  /// In en, this message translates to:
  /// **'RELATIONSHIP INTELLIGENCE'**
  String get relationshipIntelligence;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'TYPE'**
  String get typeLabel;

  /// No description provided for @trustLabel.
  ///
  /// In en, this message translates to:
  /// **'TRUST'**
  String get trustLabel;

  /// No description provided for @dhokaRisk.
  ///
  /// In en, this message translates to:
  /// **'DHOKA RISK'**
  String get dhokaRisk;

  /// No description provided for @powerLabel.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get powerLabel;

  /// No description provided for @integrity.
  ///
  /// In en, this message translates to:
  /// **'Integrity'**
  String get integrity;

  /// No description provided for @warmth.
  ///
  /// In en, this message translates to:
  /// **'Warmth'**
  String get warmth;

  /// No description provided for @trustWord.
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get trustWord;

  /// No description provided for @assertLabel.
  ///
  /// In en, this message translates to:
  /// **'Assert'**
  String get assertLabel;

  /// No description provided for @character.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get character;

  /// No description provided for @love.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get love;

  /// No description provided for @businessWord.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get businessWord;

  /// No description provided for @karmic.
  ///
  /// In en, this message translates to:
  /// **'Karmic'**
  String get karmic;

  /// No description provided for @enmityRisk.
  ///
  /// In en, this message translates to:
  /// **'Enmity Risk'**
  String get enmityRisk;

  /// No description provided for @hdrChartProfiles.
  ///
  /// In en, this message translates to:
  /// **'Chart Profiles'**
  String get hdrChartProfiles;

  /// No description provided for @hdrPairwiseAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Pairwise Analysis'**
  String get hdrPairwiseAnalysis;

  /// No description provided for @hdrCriticalPatterns.
  ///
  /// In en, this message translates to:
  /// **'Critical Patterns'**
  String get hdrCriticalPatterns;

  /// No description provided for @hdrGroupRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Group Recommendations'**
  String get hdrGroupRecommendations;

  /// No description provided for @sharedPractices.
  ///
  /// In en, this message translates to:
  /// **'SHARED PRACTICES'**
  String get sharedPractices;

  /// No description provided for @hdrIndividualGuidance.
  ///
  /// In en, this message translates to:
  /// **'Individual Guidance'**
  String get hdrIndividualGuidance;

  /// No description provided for @growthAreas.
  ///
  /// In en, this message translates to:
  /// **'GROWTH AREAS'**
  String get growthAreas;

  /// No description provided for @hdrCoreTheme.
  ///
  /// In en, this message translates to:
  /// **'Core Theme'**
  String get hdrCoreTheme;

  /// No description provided for @growthOriented.
  ///
  /// In en, this message translates to:
  /// **'GROWTH-ORIENTED'**
  String get growthOriented;

  /// No description provided for @groupTheme.
  ///
  /// In en, this message translates to:
  /// **'GROUP THEME'**
  String get groupTheme;

  /// No description provided for @compatibility.
  ///
  /// In en, this message translates to:
  /// **'COMPATIBILITY'**
  String get compatibility;

  /// No description provided for @unifiedScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'UNIFIED SCORE'**
  String get unifiedScoreLabel;

  /// No description provided for @ashtakoot.
  ///
  /// In en, this message translates to:
  /// **'ASHTAKOOT'**
  String get ashtakoot;

  /// No description provided for @probability.
  ///
  /// In en, this message translates to:
  /// **'PROBABILITY'**
  String get probability;

  /// No description provided for @hdrAshtakootSummary.
  ///
  /// In en, this message translates to:
  /// **'Ashtakoot Summary'**
  String get hdrAshtakootSummary;

  /// No description provided for @hdrGunBreakdown.
  ///
  /// In en, this message translates to:
  /// **'8 Gun Breakdown'**
  String get hdrGunBreakdown;

  /// No description provided for @hdrMangalDosh.
  ///
  /// In en, this message translates to:
  /// **'Mangal Dosh'**
  String get hdrMangalDosh;

  /// No description provided for @hdrD9CrossChart.
  ///
  /// In en, this message translates to:
  /// **'D-9 Cross-Chart'**
  String get hdrD9CrossChart;

  /// No description provided for @d9Compatibility.
  ///
  /// In en, this message translates to:
  /// **'D-9 COMPATIBILITY'**
  String get d9Compatibility;

  /// No description provided for @hdrDomainCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Domain Compatibility'**
  String get hdrDomainCompatibility;

  /// No description provided for @emotional.
  ///
  /// In en, this message translates to:
  /// **'Emotional'**
  String get emotional;

  /// No description provided for @intellectual.
  ///
  /// In en, this message translates to:
  /// **'Intellectual'**
  String get intellectual;

  /// No description provided for @spiritual.
  ///
  /// In en, this message translates to:
  /// **'Spiritual'**
  String get spiritual;

  /// No description provided for @financial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get financial;

  /// No description provided for @domestic.
  ///
  /// In en, this message translates to:
  /// **'Domestic'**
  String get domestic;

  /// No description provided for @communicationWord.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get communicationWord;

  /// No description provided for @sharedDharma.
  ///
  /// In en, this message translates to:
  /// **'Shared Dharma'**
  String get sharedDharma;

  /// No description provided for @familyCreation.
  ///
  /// In en, this message translates to:
  /// **'Family Creation'**
  String get familyCreation;

  /// No description provided for @hdrMarriageTiming.
  ///
  /// In en, this message translates to:
  /// **'Marriage Timing'**
  String get hdrMarriageTiming;

  /// No description provided for @jointMarriageWindows.
  ///
  /// In en, this message translates to:
  /// **'Joint Marriage Windows'**
  String get jointMarriageWindows;

  /// No description provided for @engagementWindows.
  ///
  /// In en, this message translates to:
  /// **'Engagement Windows'**
  String get engagementWindows;

  /// No description provided for @recommendedLabel.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommendedLabel;

  /// No description provided for @hdrKeyRisks.
  ///
  /// In en, this message translates to:
  /// **'Key Risks'**
  String get hdrKeyRisks;

  /// No description provided for @hdrFinalVerdict.
  ///
  /// In en, this message translates to:
  /// **'Final Verdict'**
  String get hdrFinalVerdict;

  /// No description provided for @marriageVerdict.
  ///
  /// In en, this message translates to:
  /// **'MARRIAGE VERDICT'**
  String get marriageVerdict;

  /// No description provided for @educationWord.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get educationWord;

  /// No description provided for @learningSuffix.
  ///
  /// In en, this message translates to:
  /// **'& Learning'**
  String get learningSuffix;

  /// No description provided for @coreEducationScores.
  ///
  /// In en, this message translates to:
  /// **'CORE EDUCATION SCORES'**
  String get coreEducationScores;

  /// No description provided for @academicSuccess.
  ///
  /// In en, this message translates to:
  /// **'ACADEMIC SUCCESS'**
  String get academicSuccess;

  /// No description provided for @learningCapacity.
  ///
  /// In en, this message translates to:
  /// **'LEARNING CAPACITY'**
  String get learningCapacity;

  /// No description provided for @memory.
  ///
  /// In en, this message translates to:
  /// **'MEMORY'**
  String get memory;

  /// No description provided for @intelligence.
  ///
  /// In en, this message translates to:
  /// **'INTELLIGENCE'**
  String get intelligence;

  /// No description provided for @research.
  ///
  /// In en, this message translates to:
  /// **'RESEARCH'**
  String get research;

  /// No description provided for @hdrIntellectualProfile.
  ///
  /// In en, this message translates to:
  /// **'Intellectual Profile'**
  String get hdrIntellectualProfile;

  /// No description provided for @learningSignature.
  ///
  /// In en, this message translates to:
  /// **'LEARNING SIGNATURE'**
  String get learningSignature;

  /// No description provided for @hdrSubjectKaraka.
  ///
  /// In en, this message translates to:
  /// **'Subject Karaka'**
  String get hdrSubjectKaraka;

  /// No description provided for @hdrHouseFoundations.
  ///
  /// In en, this message translates to:
  /// **'House Foundations'**
  String get hdrHouseFoundations;

  /// No description provided for @hdrMercuryJupiter.
  ///
  /// In en, this message translates to:
  /// **'Mercury & Jupiter'**
  String get hdrMercuryJupiter;

  /// No description provided for @hdrEducationYogas.
  ///
  /// In en, this message translates to:
  /// **'Education Yogas'**
  String get hdrEducationYogas;

  /// No description provided for @hdrDivisionalValidation.
  ///
  /// In en, this message translates to:
  /// **'Divisional Validation'**
  String get hdrDivisionalValidation;

  /// No description provided for @standing.
  ///
  /// In en, this message translates to:
  /// **'STANDING'**
  String get standing;

  /// No description provided for @hdrSubjectRanking.
  ///
  /// In en, this message translates to:
  /// **'Subject Ranking'**
  String get hdrSubjectRanking;

  /// No description provided for @hdrDegreeLikelihood.
  ///
  /// In en, this message translates to:
  /// **'Degree Likelihood'**
  String get hdrDegreeLikelihood;

  /// No description provided for @hdrStudyPeriods.
  ///
  /// In en, this message translates to:
  /// **'Study Periods'**
  String get hdrStudyPeriods;

  /// No description provided for @earlySchooling.
  ///
  /// In en, this message translates to:
  /// **'Early Schooling'**
  String get earlySchooling;

  /// No description provided for @higherEducation.
  ///
  /// In en, this message translates to:
  /// **'Higher Education'**
  String get higherEducation;

  /// No description provided for @postgradResearch.
  ///
  /// In en, this message translates to:
  /// **'Postgrad · Research'**
  String get postgradResearch;

  /// No description provided for @hdrLearningPreferences.
  ///
  /// In en, this message translates to:
  /// **'Learning Preferences'**
  String get hdrLearningPreferences;

  /// No description provided for @hdrChallengesGifts.
  ///
  /// In en, this message translates to:
  /// **'Challenges & Gifts'**
  String get hdrChallengesGifts;

  /// No description provided for @challenges.
  ///
  /// In en, this message translates to:
  /// **'CHALLENGES'**
  String get challenges;

  /// No description provided for @cognitiveGifts.
  ///
  /// In en, this message translates to:
  /// **'COGNITIVE GIFTS'**
  String get cognitiveGifts;

  /// No description provided for @naturalAbilities.
  ///
  /// In en, this message translates to:
  /// **'NATURAL ABILITIES'**
  String get naturalAbilities;

  /// No description provided for @hdrSaraswatiRemedies.
  ///
  /// In en, this message translates to:
  /// **'Saraswati Remedies'**
  String get hdrSaraswatiRemedies;

  /// No description provided for @studentVerdict.
  ///
  /// In en, this message translates to:
  /// **'STUDENT VERDICT'**
  String get studentVerdict;

  /// No description provided for @educationCareerLinkage.
  ///
  /// In en, this message translates to:
  /// **'EDUCATION → CAREER LINKAGE'**
  String get educationCareerLinkage;

  /// No description provided for @startupSuffix.
  ///
  /// In en, this message translates to:
  /// **'& Startup'**
  String get startupSuffix;

  /// No description provided for @coreBusinessScores.
  ///
  /// In en, this message translates to:
  /// **'CORE BUSINESS SCORES'**
  String get coreBusinessScores;

  /// No description provided for @overallBusiness.
  ///
  /// In en, this message translates to:
  /// **'OVERALL BUSINESS'**
  String get overallBusiness;

  /// No description provided for @ventureSuccess.
  ///
  /// In en, this message translates to:
  /// **'VENTURE SUCCESS'**
  String get ventureSuccess;

  /// No description provided for @eleventhHouse.
  ///
  /// In en, this message translates to:
  /// **'11TH HOUSE'**
  String get eleventhHouse;

  /// No description provided for @gains.
  ///
  /// In en, this message translates to:
  /// **'GAINS'**
  String get gains;

  /// No description provided for @investor.
  ///
  /// In en, this message translates to:
  /// **'INVESTOR'**
  String get investor;

  /// No description provided for @hdrFounderArchetype.
  ///
  /// In en, this message translates to:
  /// **'Founder Archetype'**
  String get hdrFounderArchetype;

  /// No description provided for @hdrTenthEleventhHouses.
  ///
  /// In en, this message translates to:
  /// **'10th & 11th Houses'**
  String get hdrTenthEleventhHouses;

  /// No description provided for @hdrBusinessYogas.
  ///
  /// In en, this message translates to:
  /// **'Business Yogas'**
  String get hdrBusinessYogas;

  /// No description provided for @hdrRecommendedDomains.
  ///
  /// In en, this message translates to:
  /// **'Recommended Domains'**
  String get hdrRecommendedDomains;

  /// No description provided for @hdrBusinessStyle.
  ///
  /// In en, this message translates to:
  /// **'Business Style'**
  String get hdrBusinessStyle;

  /// No description provided for @hdrFounderSkills.
  ///
  /// In en, this message translates to:
  /// **'Founder Skills'**
  String get hdrFounderSkills;

  /// No description provided for @hdrFundingProfile.
  ///
  /// In en, this message translates to:
  /// **'Funding Profile'**
  String get hdrFundingProfile;

  /// No description provided for @recommendedPath.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDED PATH'**
  String get recommendedPath;

  /// No description provided for @investorAttract.
  ///
  /// In en, this message translates to:
  /// **'INVESTOR ATTRACT'**
  String get investorAttract;

  /// No description provided for @familyBacking.
  ///
  /// In en, this message translates to:
  /// **'FAMILY BACKING'**
  String get familyBacking;

  /// No description provided for @hybridViability.
  ///
  /// In en, this message translates to:
  /// **'HYBRID VIABILITY'**
  String get hybridViability;

  /// No description provided for @launchWindow.
  ///
  /// In en, this message translates to:
  /// **'Launch Window'**
  String get launchWindow;

  /// No description provided for @scaleWindow.
  ///
  /// In en, this message translates to:
  /// **'Scale Window'**
  String get scaleWindow;

  /// No description provided for @hdrBusinessRisks.
  ///
  /// In en, this message translates to:
  /// **'Business Risks'**
  String get hdrBusinessRisks;

  /// No description provided for @recoveryCapacity.
  ///
  /// In en, this message translates to:
  /// **'RECOVERY CAPACITY'**
  String get recoveryCapacity;

  /// No description provided for @hdrRemediesSolutions.
  ///
  /// In en, this message translates to:
  /// **'Remedies & Solutions'**
  String get hdrRemediesSolutions;

  /// No description provided for @aiConnectionLost.
  ///
  /// In en, this message translates to:
  /// **'Connection lost. Please try again.'**
  String get aiConnectionLost;

  /// No description provided for @aiSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get aiSomethingWrong;

  /// No description provided for @aiNoResponse.
  ///
  /// In en, this message translates to:
  /// **'No response'**
  String get aiNoResponse;

  /// No description provided for @aiConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please try again.'**
  String get aiConnectionError;

  /// No description provided for @aiAutoDetect.
  ///
  /// In en, this message translates to:
  /// **'Auto-detect'**
  String get aiAutoDetect;

  /// No description provided for @aiAutoArrow.
  ///
  /// In en, this message translates to:
  /// **'Auto → {lang}'**
  String aiAutoArrow(String lang);

  /// No description provided for @aiLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language: {lang}'**
  String aiLanguageLabel(String lang);

  /// No description provided for @aiNoBirthCharts.
  ///
  /// In en, this message translates to:
  /// **'No birth charts found'**
  String get aiNoBirthCharts;

  /// No description provided for @aiCreateChartFirst.
  ///
  /// In en, this message translates to:
  /// **'Create a birth chart first to chat with AI'**
  String get aiCreateChartFirst;

  /// No description provided for @aiSelectChartBegin.
  ///
  /// In en, this message translates to:
  /// **'Select a birth chart to begin analysis'**
  String get aiSelectChartBegin;

  /// No description provided for @aiAnalyzingName.
  ///
  /// In en, this message translates to:
  /// **'Analyzing: {name}'**
  String aiAnalyzingName(String name);

  /// No description provided for @aiChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get aiChange;

  /// No description provided for @aiAnalyzingChart.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your chart...'**
  String get aiAnalyzingChart;

  /// No description provided for @aiAskStarsHint.
  ///
  /// In en, this message translates to:
  /// **'Ask the stars anything...'**
  String get aiAskStarsHint;

  /// No description provided for @aiSuggestedFollowups.
  ///
  /// In en, this message translates to:
  /// **'Suggested follow-ups'**
  String get aiSuggestedFollowups;

  /// No description provided for @aiThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get aiThinking;

  /// No description provided for @aiThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks!'**
  String get aiThanks;

  /// No description provided for @aiFeedbackNoted.
  ///
  /// In en, this message translates to:
  /// **'Feedback noted'**
  String get aiFeedbackNoted;

  /// No description provided for @svcAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get svcAll;

  /// No description provided for @svcNoServices.
  ///
  /// In en, this message translates to:
  /// **'No services available'**
  String get svcNoServices;

  /// No description provided for @svcFree.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get svcFree;

  /// No description provided for @astroFailedStartCall.
  ///
  /// In en, this message translates to:
  /// **'Failed to start call'**
  String get astroFailedStartCall;

  /// No description provided for @astroFailedStartChat.
  ///
  /// In en, this message translates to:
  /// **'Failed to start chat'**
  String get astroFailedStartChat;

  /// No description provided for @astroErrorDetail.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String astroErrorDetail(String error);

  /// No description provided for @astroExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get astroExperience;

  /// No description provided for @astroSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get astroSessions;

  /// No description provided for @astroMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get astroMinutes;

  /// No description provided for @astroAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get astroAbout;

  /// No description provided for @astroLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get astroLanguages;

  /// No description provided for @astroRateCard.
  ///
  /// In en, this message translates to:
  /// **'Rate Card'**
  String get astroRateCard;

  /// No description provided for @astroVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get astroVoice;

  /// No description provided for @astroReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews ({count})'**
  String astroReviews(int count);

  /// No description provided for @astroNoReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get astroNoReviews;

  /// No description provided for @astroAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get astroAnonymous;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you\na link to reset your password.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'your@email.com'**
  String get emailHint;

  /// No description provided for @resendLink.
  ///
  /// In en, this message translates to:
  /// **'Resend Link'**
  String get resendLink;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @continueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueGoogle;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @minSixChars.
  ///
  /// In en, this message translates to:
  /// **'Min 6 characters'**
  String get minSixChars;

  /// No description provided for @passwordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsMismatch;

  /// No description provided for @validEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Valid email required'**
  String get validEmailRequired;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @signupFailed.
  ///
  /// In en, this message translates to:
  /// **'Signup failed'**
  String get signupFailed;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @todaysHoroscope.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S HOROSCOPE'**
  String get todaysHoroscope;

  /// No description provided for @todaysRashi.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Rashi'**
  String get todaysRashi;

  /// No description provided for @tapDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap for details'**
  String get tapDetails;

  /// No description provided for @allServices.
  ///
  /// In en, this message translates to:
  /// **'All Services'**
  String get allServices;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'SEE ALL'**
  String get seeAll;

  /// No description provided for @topAstrologers.
  ///
  /// In en, this message translates to:
  /// **'Top Astrologers'**
  String get topAstrologers;

  /// No description provided for @onlineExperts.
  ///
  /// In en, this message translates to:
  /// **'Online experts ready for consultation'**
  String get onlineExperts;

  /// No description provided for @searchAstrologers.
  ///
  /// In en, this message translates to:
  /// **'Search astrologers...'**
  String get searchAstrologers;

  /// No description provided for @noAstrologersFound.
  ///
  /// In en, this message translates to:
  /// **'No astrologers found'**
  String get noAstrologersFound;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @busy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get busy;

  /// No description provided for @perMin.
  ///
  /// In en, this message translates to:
  /// **'/min'**
  String get perMin;

  /// No description provided for @noCharts.
  ///
  /// In en, this message translates to:
  /// **'No birth charts yet'**
  String get noCharts;

  /// No description provided for @createFirst.
  ///
  /// In en, this message translates to:
  /// **'Create your first Janam Kundli'**
  String get createFirst;

  /// No description provided for @createChart.
  ///
  /// In en, this message translates to:
  /// **'Create Chart'**
  String get createChart;

  /// No description provided for @newBirthChart.
  ///
  /// In en, this message translates to:
  /// **'New Birth Chart'**
  String get newBirthChart;

  /// No description provided for @clientName.
  ///
  /// In en, this message translates to:
  /// **'Client Name'**
  String get clientName;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @timeOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Time of Birth'**
  String get timeOfBirth;

  /// No description provided for @birthPlace.
  ///
  /// In en, this message translates to:
  /// **'Birth Place'**
  String get birthPlace;

  /// No description provided for @birthPlaceHint.
  ///
  /// In en, this message translates to:
  /// **'Type city name to search...'**
  String get birthPlaceHint;

  /// No description provided for @generateKundli.
  ///
  /// In en, this message translates to:
  /// **'Generate Kundli'**
  String get generateKundli;

  /// No description provided for @birthChartCreated.
  ///
  /// In en, this message translates to:
  /// **'Birth chart created!'**
  String get birthChartCreated;

  /// No description provided for @deleteChart.
  ///
  /// In en, this message translates to:
  /// **'Delete Chart?'**
  String get deleteChart;

  /// No description provided for @cannotUndo.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get cannotUndo;

  /// No description provided for @primary.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY'**
  String get primary;

  /// No description provided for @viewKundli.
  ///
  /// In en, this message translates to:
  /// **'View Kundli'**
  String get viewKundli;

  /// No description provided for @completeBirthChart.
  ///
  /// In en, this message translates to:
  /// **'Complete Birth Chart'**
  String get completeBirthChart;

  /// No description provided for @birthDetails.
  ///
  /// In en, this message translates to:
  /// **'Birth Details'**
  String get birthDetails;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @dob.
  ///
  /// In en, this message translates to:
  /// **'DOB'**
  String get dob;

  /// No description provided for @tob.
  ///
  /// In en, this message translates to:
  /// **'TOB'**
  String get tob;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @planets.
  ///
  /// In en, this message translates to:
  /// **'Planets'**
  String get planets;

  /// No description provided for @divisions.
  ///
  /// In en, this message translates to:
  /// **'Divisions'**
  String get divisions;

  /// No description provided for @vimshottari.
  ///
  /// In en, this message translates to:
  /// **'Vimshottari'**
  String get vimshottari;

  /// No description provided for @moola.
  ///
  /// In en, this message translates to:
  /// **'Moola'**
  String get moola;

  /// No description provided for @gochar.
  ///
  /// In en, this message translates to:
  /// **'Gochar'**
  String get gochar;

  /// No description provided for @dosh.
  ///
  /// In en, this message translates to:
  /// **'Dosh'**
  String get dosh;

  /// No description provided for @yoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get yoga;

  /// No description provided for @shadbala.
  ///
  /// In en, this message translates to:
  /// **'Shadbala'**
  String get shadbala;

  /// No description provided for @ashtakavarga.
  ///
  /// In en, this message translates to:
  /// **'Ashtakavarga'**
  String get ashtakavarga;

  /// No description provided for @aspects.
  ///
  /// In en, this message translates to:
  /// **'Aspects'**
  String get aspects;

  /// No description provided for @lifeAreas.
  ///
  /// In en, this message translates to:
  /// **'Life Areas'**
  String get lifeAreas;

  /// No description provided for @bhava.
  ///
  /// In en, this message translates to:
  /// **'Bhava'**
  String get bhava;

  /// No description provided for @chakras.
  ///
  /// In en, this message translates to:
  /// **'Chakras'**
  String get chakras;

  /// No description provided for @dashaActive.
  ///
  /// In en, this message translates to:
  /// **'Dasha Active'**
  String get dashaActive;

  /// No description provided for @lagna.
  ///
  /// In en, this message translates to:
  /// **'Lagna'**
  String get lagna;

  /// No description provided for @moon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get moon;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @premiumSection.
  ///
  /// In en, this message translates to:
  /// **'Premium Section'**
  String get premiumSection;

  /// No description provided for @unlockReading.
  ///
  /// In en, this message translates to:
  /// **'Unlock this reading to view detailed analysis.'**
  String get unlockReading;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @retrograde.
  ///
  /// In en, this message translates to:
  /// **'Retrograde'**
  String get retrograde;

  /// No description provided for @combust.
  ///
  /// In en, this message translates to:
  /// **'Combust'**
  String get combust;

  /// No description provided for @vargottama.
  ///
  /// In en, this message translates to:
  /// **'Vargottama'**
  String get vargottama;

  /// No description provided for @exalted.
  ///
  /// In en, this message translates to:
  /// **'Exalted'**
  String get exalted;

  /// No description provided for @debilitated.
  ///
  /// In en, this message translates to:
  /// **'Debilitated'**
  String get debilitated;

  /// No description provided for @addBalance.
  ///
  /// In en, this message translates to:
  /// **'Add Balance'**
  String get addBalance;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get walletBalance;

  /// No description provided for @recharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge'**
  String get recharge;

  /// No description provided for @bonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get bonus;

  /// No description provided for @serviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get serviceLabel;

  /// No description provided for @refund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refund;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get noTransactions;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @savedAstrologers.
  ///
  /// In en, this message translates to:
  /// **'Saved Astrologers'**
  String get savedAstrologers;

  /// No description provided for @noSavedAstrologers.
  ///
  /// In en, this message translates to:
  /// **'No saved astrologers yet'**
  String get noSavedAstrologers;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @communicationHistory.
  ///
  /// In en, this message translates to:
  /// **'Communication History'**
  String get communicationHistory;

  /// No description provided for @chatHistory.
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chatHistory;

  /// No description provided for @callHistory.
  ///
  /// In en, this message translates to:
  /// **'Call History'**
  String get callHistory;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @chatMessages.
  ///
  /// In en, this message translates to:
  /// **'Chat Messages'**
  String get chatMessages;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @sessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Session Ended'**
  String get sessionEnded;

  /// No description provided for @endChat.
  ///
  /// In en, this message translates to:
  /// **'End Chat?'**
  String get endChat;

  /// No description provided for @endChatConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to end this chat session?'**
  String get endChatConfirm;

  /// No description provided for @sendPhoto.
  ///
  /// In en, this message translates to:
  /// **'Send Photo'**
  String get sendPhoto;

  /// No description provided for @sendPDF.
  ///
  /// In en, this message translates to:
  /// **'Send PDF'**
  String get sendPDF;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File not found'**
  String get fileNotFound;

  /// No description provided for @voiceCall.
  ///
  /// In en, this message translates to:
  /// **'Voice Call'**
  String get voiceCall;

  /// No description provided for @videoCall.
  ///
  /// In en, this message translates to:
  /// **'Video Call'**
  String get videoCall;

  /// No description provided for @ringing.
  ///
  /// In en, this message translates to:
  /// **'Ringing...'**
  String get ringing;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'CONNECTED'**
  String get connected;

  /// No description provided for @endCall.
  ///
  /// In en, this message translates to:
  /// **'End Call'**
  String get endCall;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @unmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get unmute;

  /// No description provided for @speaker.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get speaker;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @flip.
  ///
  /// In en, this message translates to:
  /// **'Flip'**
  String get flip;

  /// No description provided for @liveStreams.
  ///
  /// In en, this message translates to:
  /// **'Live Streams'**
  String get liveStreams;

  /// No description provided for @noLiveStreams.
  ///
  /// In en, this message translates to:
  /// **'No live streams right now'**
  String get noLiveStreams;

  /// No description provided for @astrologerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Astrologer not available. Ending stream.'**
  String get astrologerUnavailable;

  /// No description provided for @streamEnded.
  ///
  /// In en, this message translates to:
  /// **'Stream ended'**
  String get streamEnded;

  /// No description provided for @superChat.
  ///
  /// In en, this message translates to:
  /// **'Super Chat'**
  String get superChat;

  /// No description provided for @sendGift.
  ///
  /// In en, this message translates to:
  /// **'Send a Gift'**
  String get sendGift;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @appPermissions.
  ///
  /// In en, this message translates to:
  /// **'App Permissions'**
  String get appPermissions;

  /// No description provided for @grantPermissions.
  ///
  /// In en, this message translates to:
  /// **'Grant Permissions'**
  String get grantPermissions;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @microphone.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get microphone;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @myDetails.
  ///
  /// In en, this message translates to:
  /// **'My Details'**
  String get myDetails;

  /// No description provided for @myKundlis.
  ///
  /// In en, this message translates to:
  /// **'My Kundlis'**
  String get myKundlis;

  /// No description provided for @walletRecharge.
  ///
  /// In en, this message translates to:
  /// **'Wallet & Recharge'**
  String get walletRecharge;

  /// No description provided for @consultationHistory.
  ///
  /// In en, this message translates to:
  /// **'Consultation History'**
  String get consultationHistory;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get biometricLogin;

  /// No description provided for @pastVoiceConsultations.
  ///
  /// In en, this message translates to:
  /// **'Past voice consultations'**
  String get pastVoiceConsultations;

  /// No description provided for @pastTextConversations.
  ///
  /// In en, this message translates to:
  /// **'Past text conversations'**
  String get pastTextConversations;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @totalCredit.
  ///
  /// In en, this message translates to:
  /// **'Total Credit'**
  String get totalCredit;

  /// No description provided for @totalDebit.
  ///
  /// In en, this message translates to:
  /// **'Total Debit'**
  String get totalDebit;

  /// No description provided for @statement.
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get statement;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get allTypes;

  /// No description provided for @prev.
  ///
  /// In en, this message translates to:
  /// **'Prev'**
  String get prev;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @allInsights.
  ///
  /// In en, this message translates to:
  /// **'All Insights'**
  String get allInsights;

  /// No description provided for @yourCompleteReading.
  ///
  /// In en, this message translates to:
  /// **'YOUR COMPLETE READING'**
  String get yourCompleteReading;

  /// No description provided for @expertEngines.
  ///
  /// In en, this message translates to:
  /// **'expert engines'**
  String get expertEngines;

  /// No description provided for @eachInsightConsultation.
  ///
  /// In en, this message translates to:
  /// **'Each insight is a complete consultation'**
  String get eachInsightConsultation;

  /// No description provided for @engines.
  ///
  /// In en, this message translates to:
  /// **'ENGINES'**
  String get engines;

  /// No description provided for @dataPoints.
  ///
  /// In en, this message translates to:
  /// **'DATA POINTS'**
  String get dataPoints;

  /// No description provided for @singleChart.
  ///
  /// In en, this message translates to:
  /// **'SINGLE'**
  String get singleChart;

  /// No description provided for @careerPurpose.
  ///
  /// In en, this message translates to:
  /// **'CAREER & PURPOSE'**
  String get careerPurpose;

  /// No description provided for @wealthAssets.
  ///
  /// In en, this message translates to:
  /// **'WEALTH & ASSETS'**
  String get wealthAssets;

  /// No description provided for @loveRelationships.
  ///
  /// In en, this message translates to:
  /// **'LOVE & RELATIONSHIPS'**
  String get loveRelationships;

  /// No description provided for @healthWellness.
  ///
  /// In en, this message translates to:
  /// **'HEALTH & WELLNESS'**
  String get healthWellness;

  /// No description provided for @soulKarma.
  ///
  /// In en, this message translates to:
  /// **'SOUL & KARMA'**
  String get soulKarma;

  /// No description provided for @specialistReports.
  ///
  /// In en, this message translates to:
  /// **'Specialist Reports'**
  String get specialistReports;

  /// No description provided for @searchByNameSpeciality.
  ///
  /// In en, this message translates to:
  /// **'Search by name, speciality...'**
  String get searchByNameSpeciality;

  /// No description provided for @sortedByRating.
  ///
  /// In en, this message translates to:
  /// **'Sorted by rating'**
  String get sortedByRating;

  /// No description provided for @initiatingChat.
  ///
  /// In en, this message translates to:
  /// **'Initiating chat...'**
  String get initiatingChat;

  /// No description provided for @startingCall.
  ///
  /// In en, this message translates to:
  /// **'Starting call...'**
  String get startingCall;

  /// No description provided for @yrs.
  ///
  /// In en, this message translates to:
  /// **'yrs'**
  String get yrs;

  /// No description provided for @chatWithAISpecialist.
  ///
  /// In en, this message translates to:
  /// **'Chat with AI Specialist'**
  String get chatWithAISpecialist;

  /// No description provided for @tapToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap to start'**
  String get tapToStart;

  /// No description provided for @astrologer.
  ///
  /// In en, this message translates to:
  /// **'Astrologer'**
  String get astrologer;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @milan.
  ///
  /// In en, this message translates to:
  /// **'Milan'**
  String get milan;

  /// No description provided for @forecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get forecast;

  /// No description provided for @rashi.
  ///
  /// In en, this message translates to:
  /// **'Rashi'**
  String get rashi;

  /// No description provided for @jupiterFavorsBold.
  ///
  /// In en, this message translates to:
  /// **'Jupiter favors bold moves'**
  String get jupiterFavorsBold;

  /// No description provided for @careerIlluminated.
  ///
  /// In en, this message translates to:
  /// **'Your career sector is illuminated — trust your instincts.'**
  String get careerIlluminated;

  /// No description provided for @todaysForecast.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Forecast'**
  String get todaysForecast;

  /// No description provided for @engCareer.
  ///
  /// In en, this message translates to:
  /// **'Career & Job'**
  String get engCareer;

  /// No description provided for @engBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business & Startup'**
  String get engBusiness;

  /// No description provided for @engEducation.
  ///
  /// In en, this message translates to:
  /// **'Education & Learning'**
  String get engEducation;

  /// No description provided for @engLifePath.
  ///
  /// In en, this message translates to:
  /// **'Life Path & Luck'**
  String get engLifePath;

  /// No description provided for @engWealth.
  ///
  /// In en, this message translates to:
  /// **'Wealth & Finance'**
  String get engWealth;

  /// No description provided for @engDebt.
  ///
  /// In en, this message translates to:
  /// **'Debt & Recovery'**
  String get engDebt;

  /// No description provided for @engProperty.
  ///
  /// In en, this message translates to:
  /// **'Property & Assets'**
  String get engProperty;

  /// No description provided for @engLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal & Disputes'**
  String get engLegal;

  /// No description provided for @engLove.
  ///
  /// In en, this message translates to:
  /// **'Love & Romance'**
  String get engLove;

  /// No description provided for @engMarriage.
  ///
  /// In en, this message translates to:
  /// **'Marriage & Family'**
  String get engMarriage;

  /// No description provided for @engKundliMilan.
  ///
  /// In en, this message translates to:
  /// **'Kundli Milan'**
  String get engKundliMilan;

  /// No description provided for @engRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship Intel'**
  String get engRelationship;

  /// No description provided for @engLoveCompat.
  ///
  /// In en, this message translates to:
  /// **'Love Compatibility'**
  String get engLoveCompat;

  /// No description provided for @engChildProb.
  ///
  /// In en, this message translates to:
  /// **'Child Probability'**
  String get engChildProb;

  /// No description provided for @engHealth.
  ///
  /// In en, this message translates to:
  /// **'Health & Wellness'**
  String get engHealth;

  /// No description provided for @engMental.
  ///
  /// In en, this message translates to:
  /// **'Mental & Stress'**
  String get engMental;

  /// No description provided for @engCharacter.
  ///
  /// In en, this message translates to:
  /// **'Character Analysis'**
  String get engCharacter;

  /// No description provided for @engPastLife.
  ///
  /// In en, this message translates to:
  /// **'Past Life & Karma'**
  String get engPastLife;

  /// No description provided for @engKarmaLink.
  ///
  /// In en, this message translates to:
  /// **'Karma Linkage'**
  String get engKarmaLink;

  /// No description provided for @noChatSessions.
  ///
  /// In en, this message translates to:
  /// **'No Chat Sessions Yet'**
  String get noChatSessions;

  /// No description provided for @chatAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your conversations with astrologers will appear here.'**
  String get chatAppearHere;

  /// No description provided for @noCallsYet.
  ///
  /// In en, this message translates to:
  /// **'No Calls Yet'**
  String get noCallsYet;

  /// No description provided for @callAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your call history with astrologers will appear here.'**
  String get callAppearHere;

  /// No description provided for @chatWith.
  ///
  /// In en, this message translates to:
  /// **'Chat with'**
  String get chatWith;

  /// No description provided for @msgs.
  ///
  /// In en, this message translates to:
  /// **'msgs'**
  String get msgs;

  /// No description provided for @voiceCallLabel.
  ///
  /// In en, this message translates to:
  /// **'Voice call'**
  String get voiceCallLabel;

  /// No description provided for @videoCallLabel.
  ///
  /// In en, this message translates to:
  /// **'Video call'**
  String get videoCallLabel;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh'**
  String get pullToRefresh;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get sessionExpired;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectionFailed;

  /// No description provided for @callActive.
  ///
  /// In en, this message translates to:
  /// **'Call active'**
  String get callActive;

  /// No description provided for @lessThanOneMin.
  ///
  /// In en, this message translates to:
  /// **'Less than 1 minute remaining'**
  String get lessThanOneMin;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages in this session'**
  String get noMessages;

  /// No description provided for @gocharForAllSigns.
  ///
  /// In en, this message translates to:
  /// **'Today\'s gochar for all 12 signs'**
  String get gocharForAllSigns;

  /// No description provided for @selectChart.
  ///
  /// In en, this message translates to:
  /// **'Select a chart to analyze'**
  String get selectChart;

  /// No description provided for @selectTwoCharts.
  ///
  /// In en, this message translates to:
  /// **'Select two charts'**
  String get selectTwoCharts;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @browseAstrologers.
  ///
  /// In en, this message translates to:
  /// **'Browse Astrologers'**
  String get browseAstrologers;

  /// No description provided for @probableNumber.
  ///
  /// In en, this message translates to:
  /// **'PROBABLE NUMBER'**
  String get probableNumber;

  /// No description provided for @genderTendency.
  ///
  /// In en, this message translates to:
  /// **'GENDER TENDENCY'**
  String get genderTendency;

  /// No description provided for @son.
  ///
  /// In en, this message translates to:
  /// **'SON'**
  String get son;

  /// No description provided for @daughter.
  ///
  /// In en, this message translates to:
  /// **'DAUGHTER'**
  String get daughter;

  /// No description provided for @occupants.
  ///
  /// In en, this message translates to:
  /// **'OCCUPANTS'**
  String get occupants;

  /// No description provided for @beneficAspects.
  ///
  /// In en, this message translates to:
  /// **'BENEFIC ASPECTS'**
  String get beneficAspects;

  /// No description provided for @maleficAspects.
  ///
  /// In en, this message translates to:
  /// **'MALEFIC ASPECTS'**
  String get maleficAspects;

  /// No description provided for @nextFavorableWindow.
  ///
  /// In en, this message translates to:
  /// **'NEXT FAVORABLE WINDOW'**
  String get nextFavorableWindow;

  /// No description provided for @totalDoshaPenalty.
  ///
  /// In en, this message translates to:
  /// **'TOTAL DOSHA PENALTY'**
  String get totalDoshaPenalty;

  /// No description provided for @cancellationFactors.
  ///
  /// In en, this message translates to:
  /// **'CANCELLATION FACTORS'**
  String get cancellationFactors;

  /// No description provided for @combinedFertility.
  ///
  /// In en, this message translates to:
  /// **'COMBINED FERTILITY INDICATION'**
  String get combinedFertility;

  /// No description provided for @planetPositions.
  ///
  /// In en, this message translates to:
  /// **'PLANET POSITIONS'**
  String get planetPositions;

  /// No description provided for @bestWindows.
  ///
  /// In en, this message translates to:
  /// **'BEST WINDOWS'**
  String get bestWindows;

  /// No description provided for @worstWindows.
  ///
  /// In en, this message translates to:
  /// **'WORST WINDOWS'**
  String get worstWindows;

  /// No description provided for @scoreComponents.
  ///
  /// In en, this message translates to:
  /// **'SCORE COMPONENTS'**
  String get scoreComponents;

  /// No description provided for @topOpportunities.
  ///
  /// In en, this message translates to:
  /// **'TOP OPPORTUNITIES'**
  String get topOpportunities;

  /// No description provided for @topRisks.
  ///
  /// In en, this message translates to:
  /// **'TOP RISKS'**
  String get topRisks;

  /// No description provided for @remedies.
  ///
  /// In en, this message translates to:
  /// **'REMEDIES'**
  String get remedies;

  /// No description provided for @keyInsights.
  ///
  /// In en, this message translates to:
  /// **'KEY INSIGHTS'**
  String get keyInsights;

  /// No description provided for @overallVerdict.
  ///
  /// In en, this message translates to:
  /// **'OVERALL VERDICT'**
  String get overallVerdict;

  /// No description provided for @venusContacts.
  ///
  /// In en, this message translates to:
  /// **'VENUS CROSS CONTACTS'**
  String get venusContacts;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @effect.
  ///
  /// In en, this message translates to:
  /// **'Effect'**
  String get effect;

  /// No description provided for @moonSignCompat.
  ///
  /// In en, this message translates to:
  /// **'MOON SIGN COMPATIBILITY'**
  String get moonSignCompat;

  /// No description provided for @hisMoon.
  ///
  /// In en, this message translates to:
  /// **'HIS MOON'**
  String get hisMoon;

  /// No description provided for @herMoon.
  ///
  /// In en, this message translates to:
  /// **'HER MOON'**
  String get herMoon;

  /// No description provided for @nakshatraCompat.
  ///
  /// In en, this message translates to:
  /// **'NAKSHATRA COMPATIBILITY'**
  String get nakshatraCompat;

  /// No description provided for @ketuContacts.
  ///
  /// In en, this message translates to:
  /// **'KETU CONTACTS'**
  String get ketuContacts;

  /// No description provided for @rahuContacts.
  ///
  /// In en, this message translates to:
  /// **'RAHU CONTACTS'**
  String get rahuContacts;

  /// No description provided for @pastLifeIndication.
  ///
  /// In en, this message translates to:
  /// **'PAST LIFE INDICATION'**
  String get pastLifeIndication;

  /// No description provided for @totalChallengePenalty.
  ///
  /// In en, this message translates to:
  /// **'TOTAL CHALLENGE PENALTY'**
  String get totalChallengePenalty;

  /// No description provided for @manifestation.
  ///
  /// In en, this message translates to:
  /// **'MANIFESTATION'**
  String get manifestation;

  /// No description provided for @cancellation.
  ///
  /// In en, this message translates to:
  /// **'CANCELLATION'**
  String get cancellation;

  /// No description provided for @navigation.
  ///
  /// In en, this message translates to:
  /// **'NAVIGATION'**
  String get navigation;

  /// No description provided for @potentialStrengths.
  ///
  /// In en, this message translates to:
  /// **'POTENTIAL STRENGTHS'**
  String get potentialStrengths;

  /// No description provided for @areasToNurture.
  ///
  /// In en, this message translates to:
  /// **'AREAS TO NURTURE'**
  String get areasToNurture;

  /// No description provided for @relationshipGuidance.
  ///
  /// In en, this message translates to:
  /// **'RELATIONSHIP GUIDANCE'**
  String get relationshipGuidance;

  /// No description provided for @detailedSummary.
  ///
  /// In en, this message translates to:
  /// **'DETAILED SUMMARY'**
  String get detailedSummary;

  /// No description provided for @discussWithAI.
  ///
  /// In en, this message translates to:
  /// **'DISCUSS WITH AI'**
  String get discussWithAI;

  /// No description provided for @planet.
  ///
  /// In en, this message translates to:
  /// **'Planet'**
  String get planet;

  /// No description provided for @sign.
  ///
  /// In en, this message translates to:
  /// **'Sign'**
  String get sign;

  /// No description provided for @house.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get house;

  /// No description provided for @strength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strength;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'COPY'**
  String get copy;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'CONFIDENCE'**
  String get confidence;

  /// No description provided for @d7Saptamsa.
  ///
  /// In en, this message translates to:
  /// **'D7 SAPTAMSA'**
  String get d7Saptamsa;

  /// No description provided for @numberExplanation.
  ///
  /// In en, this message translates to:
  /// **'NUMBER EXPLANATION'**
  String get numberExplanation;

  /// No description provided for @genderExplanation.
  ///
  /// In en, this message translates to:
  /// **'GENDER EXPLANATION'**
  String get genderExplanation;

  /// No description provided for @inFifth.
  ///
  /// In en, this message translates to:
  /// **'In 5th?'**
  String get inFifth;

  /// No description provided for @primaryArchetype.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY ARCHETYPE'**
  String get primaryArchetype;

  /// No description provided for @mitigation.
  ///
  /// In en, this message translates to:
  /// **'MITIGATION'**
  String get mitigation;

  /// No description provided for @soulCareerAlign.
  ///
  /// In en, this message translates to:
  /// **'Soul ↔ Career Alignment'**
  String get soulCareerAlign;

  /// No description provided for @favorablePeriods.
  ///
  /// In en, this message translates to:
  /// **'Favorable Periods'**
  String get favorablePeriods;

  /// No description provided for @challengingPeriods.
  ///
  /// In en, this message translates to:
  /// **'Challenging Periods'**
  String get challengingPeriods;

  /// No description provided for @keyHouses.
  ///
  /// In en, this message translates to:
  /// **'Key Houses'**
  String get keyHouses;

  /// No description provided for @keyPlanets.
  ///
  /// In en, this message translates to:
  /// **'Key Planets'**
  String get keyPlanets;

  /// No description provided for @characterOverview.
  ///
  /// In en, this message translates to:
  /// **'Character Overview'**
  String get characterOverview;

  /// No description provided for @noYogasActive.
  ///
  /// In en, this message translates to:
  /// **'No yogas currently active in this chart.'**
  String get noYogasActive;

  /// No description provided for @basedOnPlanetStrengths.
  ///
  /// In en, this message translates to:
  /// **'Based on planetary strengths & house placements'**
  String get basedOnPlanetStrengths;

  /// No description provided for @basedOnTransits.
  ///
  /// In en, this message translates to:
  /// **'Based on current planetary transits'**
  String get basedOnTransits;

  /// No description provided for @currentPlanetPositions.
  ///
  /// In en, this message translates to:
  /// **'Current planet positions with your sign as house 1'**
  String get currentPlanetPositions;

  /// No description provided for @favorablePeriodAdvice.
  ///
  /// In en, this message translates to:
  /// **'Favorable period — focus on career growth and relationships.'**
  String get favorablePeriodAdvice;

  /// No description provided for @noClassicalYogas.
  ///
  /// In en, this message translates to:
  /// **'Without classical learning yogas, success comes from consistent effort.'**
  String get noClassicalYogas;

  /// No description provided for @walletDeduction.
  ///
  /// In en, this message translates to:
  /// **'Amount will be deducted from your wallet'**
  String get walletDeduction;

  /// No description provided for @bhakootAxis.
  ///
  /// In en, this message translates to:
  /// **'BHAKOOT AXIS'**
  String get bhakootAxis;

  /// No description provided for @basis.
  ///
  /// In en, this message translates to:
  /// **'BASIS'**
  String get basis;

  /// No description provided for @selectChartsForMilan.
  ///
  /// In en, this message translates to:
  /// **'Select 2 Charts for Milan Analysis'**
  String get selectChartsForMilan;

  /// No description provided for @selectMultiCharts.
  ///
  /// In en, this message translates to:
  /// **'Select 2–5 Charts'**
  String get selectMultiCharts;

  /// No description provided for @running.
  ///
  /// In en, this message translates to:
  /// **'RUNNING'**
  String get running;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'past'**
  String get past;

  /// No description provided for @topActiveDoshas.
  ///
  /// In en, this message translates to:
  /// **'TOP ACTIVE DOSHAS'**
  String get topActiveDoshas;

  /// No description provided for @allDoshas.
  ///
  /// In en, this message translates to:
  /// **'ALL DOSHAS'**
  String get allDoshas;

  /// No description provided for @activeYogas.
  ///
  /// In en, this message translates to:
  /// **'Active Yogas'**
  String get activeYogas;

  /// No description provided for @activeDoshas.
  ///
  /// In en, this message translates to:
  /// **'Active Doshas'**
  String get activeDoshas;

  /// No description provided for @yogaAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Yoga Analysis'**
  String get yogaAnalysis;

  /// No description provided for @factors.
  ///
  /// In en, this message translates to:
  /// **'Factors'**
  String get factors;

  /// No description provided for @dominantPlanet.
  ///
  /// In en, this message translates to:
  /// **'Dominant Planet'**
  String get dominantPlanet;

  /// No description provided for @startSession.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSession;

  /// No description provided for @notesSaved.
  ///
  /// In en, this message translates to:
  /// **'Notes saved'**
  String get notesSaved;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked! Enjoy your reading.'**
  String get unlocked;

  /// No description provided for @todaysGochar.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Gochar'**
  String get todaysGochar;

  /// No description provided for @todaysTransitChart.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Transit Chart'**
  String get todaysTransitChart;

  /// No description provided for @lifeAreaPredictions.
  ///
  /// In en, this message translates to:
  /// **'Life Area Predictions'**
  String get lifeAreaPredictions;

  /// No description provided for @strengths.
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get strengths;

  /// No description provided for @weaknesses.
  ///
  /// In en, this message translates to:
  /// **'Weaknesses'**
  String get weaknesses;

  /// No description provided for @ruledBy.
  ///
  /// In en, this message translates to:
  /// **'Ruled by'**
  String get ruledBy;

  /// No description provided for @kundliMilan.
  ///
  /// In en, this message translates to:
  /// **'Kundli Milan'**
  String get kundliMilan;

  /// No description provided for @startKundliMilan.
  ///
  /// In en, this message translates to:
  /// **'Start Kundli Milan'**
  String get startKundliMilan;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @cancellations.
  ///
  /// In en, this message translates to:
  /// **'Cancellations'**
  String get cancellations;

  /// No description provided for @dashaSync.
  ///
  /// In en, this message translates to:
  /// **'Dasha Sync'**
  String get dashaSync;

  /// No description provided for @transitMarriageWindows.
  ///
  /// In en, this message translates to:
  /// **'Transit Marriage Windows'**
  String get transitMarriageWindows;

  /// No description provided for @overlappingWindows.
  ///
  /// In en, this message translates to:
  /// **'Overlapping Marriage Windows'**
  String get overlappingWindows;

  /// No description provided for @overallStrength.
  ///
  /// In en, this message translates to:
  /// **'OVERALL STRENGTH'**
  String get overallStrength;

  /// No description provided for @stability.
  ///
  /// In en, this message translates to:
  /// **'STABILITY'**
  String get stability;

  /// No description provided for @growth.
  ///
  /// In en, this message translates to:
  /// **'GROWTH'**
  String get growth;

  /// No description provided for @clarity.
  ///
  /// In en, this message translates to:
  /// **'CLARITY'**
  String get clarity;

  /// No description provided for @recognition.
  ///
  /// In en, this message translates to:
  /// **'RECOGNITION'**
  String get recognition;

  /// No description provided for @satisfaction.
  ///
  /// In en, this message translates to:
  /// **'SATISFACTION'**
  String get satisfaction;

  /// No description provided for @verdict.
  ///
  /// In en, this message translates to:
  /// **'VERDICT'**
  String get verdict;

  /// No description provided for @topRoles.
  ///
  /// In en, this message translates to:
  /// **'TOP ROLES'**
  String get topRoles;

  /// No description provided for @areasForGrowth.
  ///
  /// In en, this message translates to:
  /// **'AREAS FOR GROWTH'**
  String get areasForGrowth;

  /// No description provided for @bestIndustries.
  ///
  /// In en, this message translates to:
  /// **'BEST INDUSTRIES'**
  String get bestIndustries;

  /// No description provided for @employment.
  ///
  /// In en, this message translates to:
  /// **'Employment'**
  String get employment;

  /// No description provided for @entrepreneurship.
  ///
  /// In en, this message translates to:
  /// **'Entrepreneurship'**
  String get entrepreneurship;

  /// No description provided for @freelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get freelance;

  /// No description provided for @portfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolio;

  /// No description provided for @burnoutRisk.
  ///
  /// In en, this message translates to:
  /// **'Burnout Risk'**
  String get burnoutRisk;

  /// No description provided for @careerStagnation.
  ///
  /// In en, this message translates to:
  /// **'Career Stagnation'**
  String get careerStagnation;

  /// No description provided for @workplaceConflict.
  ///
  /// In en, this message translates to:
  /// **'Workplace Conflict'**
  String get workplaceConflict;

  /// No description provided for @positioning.
  ///
  /// In en, this message translates to:
  /// **'POSITIONING'**
  String get positioning;

  /// No description provided for @skillDevelopment.
  ///
  /// In en, this message translates to:
  /// **'SKILL DEVELOPMENT'**
  String get skillDevelopment;

  /// No description provided for @network.
  ///
  /// In en, this message translates to:
  /// **'NETWORK'**
  String get network;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'VISIBILITY'**
  String get visibility;

  /// No description provided for @lagnaLord.
  ///
  /// In en, this message translates to:
  /// **'Lagna Lord'**
  String get lagnaLord;

  /// No description provided for @tenthLord.
  ///
  /// In en, this message translates to:
  /// **'10th Lord'**
  String get tenthLord;

  /// No description provided for @lord.
  ///
  /// In en, this message translates to:
  /// **'LORD'**
  String get lord;

  /// No description provided for @lordPlacedIn.
  ///
  /// In en, this message translates to:
  /// **'LORD PLACED IN'**
  String get lordPlacedIn;

  /// No description provided for @lordDignity.
  ///
  /// In en, this message translates to:
  /// **'LORD DIGNITY'**
  String get lordDignity;

  /// No description provided for @d9Dignity.
  ///
  /// In en, this message translates to:
  /// **'D9 DIGNITY'**
  String get d9Dignity;

  /// No description provided for @careerAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Career Analysis'**
  String get careerAnalysis;

  /// No description provided for @launchWindows.
  ///
  /// In en, this message translates to:
  /// **'Launch Windows'**
  String get launchWindows;

  /// No description provided for @peakWindows.
  ///
  /// In en, this message translates to:
  /// **'Peak Windows'**
  String get peakWindows;

  /// No description provided for @promotionWindows.
  ///
  /// In en, this message translates to:
  /// **'Promotion Windows'**
  String get promotionWindows;

  /// No description provided for @riskWindows.
  ///
  /// In en, this message translates to:
  /// **'Risk Windows'**
  String get riskWindows;

  /// No description provided for @timingWindows.
  ///
  /// In en, this message translates to:
  /// **'Timing Windows'**
  String get timingWindows;

  /// No description provided for @careerRisks.
  ///
  /// In en, this message translates to:
  /// **'Career Risks'**
  String get careerRisks;

  /// No description provided for @astrologicalRemedies.
  ///
  /// In en, this message translates to:
  /// **'Astrological Remedies'**
  String get astrologicalRemedies;

  /// No description provided for @practicalSolutions.
  ///
  /// In en, this message translates to:
  /// **'Practical Solutions'**
  String get practicalSolutions;

  /// No description provided for @analysisConfidence.
  ///
  /// In en, this message translates to:
  /// **'Analysis Confidence'**
  String get analysisConfidence;

  /// No description provided for @careerArchetype.
  ///
  /// In en, this message translates to:
  /// **'Career Archetype'**
  String get careerArchetype;

  /// No description provided for @workStructure.
  ///
  /// In en, this message translates to:
  /// **'Work Structure'**
  String get workStructure;

  /// No description provided for @teamLeadership.
  ///
  /// In en, this message translates to:
  /// **'Team Leadership'**
  String get teamLeadership;

  /// No description provided for @idealEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Ideal Environment'**
  String get idealEnvironment;

  /// No description provided for @idealOrgSize.
  ///
  /// In en, this message translates to:
  /// **'Ideal Org Size'**
  String get idealOrgSize;

  /// No description provided for @fitScore.
  ///
  /// In en, this message translates to:
  /// **'FIT SCORE'**
  String get fitScore;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDED'**
  String get recommended;

  /// No description provided for @divisionalValidation.
  ///
  /// In en, this message translates to:
  /// **'Divisional Validation'**
  String get divisionalValidation;

  /// No description provided for @houseAnalysis.
  ///
  /// In en, this message translates to:
  /// **'House Analysis'**
  String get houseAnalysis;

  /// No description provided for @jaiminiKarakas.
  ///
  /// In en, this message translates to:
  /// **'Jaimini Karakas'**
  String get jaiminiKarakas;

  /// No description provided for @copyFullReport.
  ///
  /// In en, this message translates to:
  /// **'Copy full report data'**
  String get copyFullReport;

  /// No description provided for @reportCopied.
  ///
  /// In en, this message translates to:
  /// **'Report data copied!'**
  String get reportCopied;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'ml',
    'mr',
    'pa',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'hi':
      {
        switch (locale.scriptCode) {
          case 'Latn':
            return AppLocalizationsHiLatn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
