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
import 'app_localizations_hi_Latn.dart';

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
  /// **'Nakshatralogy Astro'**
  String get appName;

  /// No description provided for @astrologerPanel.
  ///
  /// In en, this message translates to:
  /// **'Astrologer Panel'**
  String get astrologerPanel;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @charts.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get charts;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

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

  /// No description provided for @rzTodayOutlook.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Zodiac Outlook'**
  String get rzTodayOutlook;

  /// No description provided for @rzPlanetaryEnergy.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Planetary Energy'**
  String get rzPlanetaryEnergy;

  /// No description provided for @rzBestSign.
  ///
  /// In en, this message translates to:
  /// **'Best Sign'**
  String get rzBestSign;

  /// No description provided for @rzChallengingSign.
  ///
  /// In en, this message translates to:
  /// **'Most Challenging'**
  String get rzChallengingSign;

  /// No description provided for @rzDominantPlanet.
  ///
  /// In en, this message translates to:
  /// **'Dominant Planet'**
  String get rzDominantPlanet;

  /// No description provided for @rzOverallMood.
  ///
  /// In en, this message translates to:
  /// **'Overall Mood'**
  String get rzOverallMood;

  /// No description provided for @rzMoodBright.
  ///
  /// In en, this message translates to:
  /// **'Bright & Active'**
  String get rzMoodBright;

  /// No description provided for @rzMoodCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm & Steady'**
  String get rzMoodCalm;

  /// No description provided for @rzMoodMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed Energy'**
  String get rzMoodMixed;

  /// No description provided for @rzMoodTense.
  ///
  /// In en, this message translates to:
  /// **'Tense & Careful'**
  String get rzMoodTense;

  /// No description provided for @rzTodayEnergy.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Energy'**
  String get rzTodayEnergy;

  /// No description provided for @rzCaution.
  ///
  /// In en, this message translates to:
  /// **'Caution'**
  String get rzCaution;

  /// No description provided for @rzWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get rzWeak;

  /// No description provided for @rzAllSigns.
  ///
  /// In en, this message translates to:
  /// **'All Zodiac Signs'**
  String get rzAllSigns;

  /// No description provided for @rzAiSummary.
  ///
  /// In en, this message translates to:
  /// **'AI Summary'**
  String get rzAiSummary;

  /// No description provided for @rzPlanetaryInfluence.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Planetary Influence'**
  String get rzPlanetaryInfluence;

  /// No description provided for @rzStrongInfluences.
  ///
  /// In en, this message translates to:
  /// **'Strong Influences'**
  String get rzStrongInfluences;

  /// No description provided for @rzShowTechnical.
  ///
  /// In en, this message translates to:
  /// **'Show technical details'**
  String get rzShowTechnical;

  /// No description provided for @rzOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Opportunities'**
  String get rzOpportunities;

  /// No description provided for @rzAvoidTitle.
  ///
  /// In en, this message translates to:
  /// **'Things To Avoid Today'**
  String get rzAvoidTitle;

  /// No description provided for @rzTechnicalReason.
  ///
  /// In en, this message translates to:
  /// **'Technical reason'**
  String get rzTechnicalReason;

  /// No description provided for @rzAvoidDecisions.
  ///
  /// In en, this message translates to:
  /// **'Rushing important decisions'**
  String get rzAvoidDecisions;

  /// No description provided for @rzAvoidArguments.
  ///
  /// In en, this message translates to:
  /// **'Heated arguments'**
  String get rzAvoidArguments;

  /// No description provided for @rzAvoidInvestments.
  ///
  /// In en, this message translates to:
  /// **'Large investments'**
  String get rzAvoidInvestments;

  /// No description provided for @rzAvoidOverthink.
  ///
  /// In en, this message translates to:
  /// **'Overthinking small issues'**
  String get rzAvoidOverthink;

  /// No description provided for @rzAvoidOverspend.
  ///
  /// In en, this message translates to:
  /// **'Unnecessary spending'**
  String get rzAvoidOverspend;

  /// No description provided for @rzAvoidStress.
  ///
  /// In en, this message translates to:
  /// **'Stress and overworking'**
  String get rzAvoidStress;

  /// No description provided for @rzPlanetaryChart.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Planetary Chart'**
  String get rzPlanetaryChart;

  /// No description provided for @rzWhatChartMeans.
  ///
  /// In en, this message translates to:
  /// **'What this chart means'**
  String get rzWhatChartMeans;

  /// No description provided for @rzChartExplain.
  ///
  /// In en, this message translates to:
  /// **'This diamond shows where each planet is sitting in the sky today, mapped to your sign. Planets in supportive houses lift the day; those in tough houses ask for care.'**
  String get rzChartExplain;

  /// No description provided for @rzDoNetworking.
  ///
  /// In en, this message translates to:
  /// **'Networking & connecting'**
  String get rzDoNetworking;

  /// No description provided for @rzDoLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning something new'**
  String get rzDoLearning;

  /// No description provided for @rzDoMeditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation & calm'**
  String get rzDoMeditation;

  /// No description provided for @rzDoFamily.
  ///
  /// In en, this message translates to:
  /// **'Family time'**
  String get rzDoFamily;

  /// No description provided for @rzDoCreative.
  ///
  /// In en, this message translates to:
  /// **'Creative work'**
  String get rzDoCreative;

  /// No description provided for @rzDoRest.
  ///
  /// In en, this message translates to:
  /// **'Rest & self-care'**
  String get rzDoRest;

  /// No description provided for @rzAiRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Today\'s AI Recommendations'**
  String get rzAiRecommendations;

  /// No description provided for @rzTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical Astrology'**
  String get rzTechnical;

  /// No description provided for @rzTransitScore.
  ///
  /// In en, this message translates to:
  /// **'Transit Score'**
  String get rzTransitScore;

  /// No description provided for @rzVedha.
  ///
  /// In en, this message translates to:
  /// **'Vedha (Obstructions)'**
  String get rzVedha;

  /// No description provided for @rzGocharDetails.
  ///
  /// In en, this message translates to:
  /// **'Gochar Details'**
  String get rzGocharDetails;

  /// No description provided for @rzAdvancedOnly.
  ///
  /// In en, this message translates to:
  /// **'For advanced users'**
  String get rzAdvancedOnly;

  /// No description provided for @rzTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow Preview'**
  String get rzTomorrow;

  /// No description provided for @rzTomorrowEnergy.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow\'s Energy'**
  String get rzTomorrowEnergy;

  /// No description provided for @rzImproving.
  ///
  /// In en, this message translates to:
  /// **'Improving'**
  String get rzImproving;

  /// No description provided for @rzWeaker.
  ///
  /// In en, this message translates to:
  /// **'Slightly Weaker'**
  String get rzWeaker;

  /// No description provided for @rzSteady.
  ///
  /// In en, this message translates to:
  /// **'Steady'**
  String get rzSteady;

  /// No description provided for @rzTomorrowUpLine.
  ///
  /// In en, this message translates to:
  /// **'Energy is expected to rise tomorrow — plan ahead for important tasks.'**
  String get rzTomorrowUpLine;

  /// No description provided for @rzTomorrowDownLine.
  ///
  /// In en, this message translates to:
  /// **'Energy may dip a little tomorrow — keep the day light and steady.'**
  String get rzTomorrowDownLine;

  /// No description provided for @rzTomorrowFlatLine.
  ///
  /// In en, this message translates to:
  /// **'Energy stays steady tomorrow — a calm, balanced day ahead.'**
  String get rzTomorrowFlatLine;

  /// No description provided for @rzWeeklyTrend.
  ///
  /// In en, this message translates to:
  /// **'Weekly Trend'**
  String get rzWeeklyTrend;

  /// No description provided for @rzMonthlyTrend.
  ///
  /// In en, this message translates to:
  /// **'Monthly Trend'**
  String get rzMonthlyTrend;

  /// No description provided for @rzBestDayWeek.
  ///
  /// In en, this message translates to:
  /// **'Best Day'**
  String get rzBestDayWeek;

  /// No description provided for @rzHardestDay.
  ///
  /// In en, this message translates to:
  /// **'Toughest Day'**
  String get rzHardestDay;

  /// No description provided for @rzLuckyToday.
  ///
  /// In en, this message translates to:
  /// **'Lucky Today'**
  String get rzLuckyToday;

  /// No description provided for @rzKarakaSun.
  ///
  /// In en, this message translates to:
  /// **'confidence & vitality'**
  String get rzKarakaSun;

  /// No description provided for @rzKarakaMoon.
  ///
  /// In en, this message translates to:
  /// **'emotions & peace of mind'**
  String get rzKarakaMoon;

  /// No description provided for @rzKarakaMars.
  ///
  /// In en, this message translates to:
  /// **'energy & drive'**
  String get rzKarakaMars;

  /// No description provided for @rzKarakaMercury.
  ///
  /// In en, this message translates to:
  /// **'communication & learning'**
  String get rzKarakaMercury;

  /// No description provided for @rzKarakaJupiter.
  ///
  /// In en, this message translates to:
  /// **'wisdom & growth'**
  String get rzKarakaJupiter;

  /// No description provided for @rzKarakaVenus.
  ///
  /// In en, this message translates to:
  /// **'relationships & comfort'**
  String get rzKarakaVenus;

  /// No description provided for @rzKarakaSaturn.
  ///
  /// In en, this message translates to:
  /// **'discipline & patience'**
  String get rzKarakaSaturn;

  /// No description provided for @rzKarakaRahu.
  ///
  /// In en, this message translates to:
  /// **'ambition & change'**
  String get rzKarakaRahu;

  /// No description provided for @rzKarakaKetu.
  ///
  /// In en, this message translates to:
  /// **'spirituality & letting go'**
  String get rzKarakaKetu;

  /// No description provided for @rzHomeSummary.
  ///
  /// In en, this message translates to:
  /// **'{dom} sets the tone of the day, while {chal} asks for patience and care.'**
  String rzHomeSummary(Object dom, Object chal);

  /// No description provided for @rzInsightGood.
  ///
  /// In en, this message translates to:
  /// **'Good day for {karaka}.'**
  String rzInsightGood(Object karaka);

  /// No description provided for @rzInsightHard.
  ///
  /// In en, this message translates to:
  /// **'Take it slow with {karaka} today.'**
  String rzInsightHard(Object karaka);

  /// No description provided for @rzInfluenceGood.
  ///
  /// In en, this message translates to:
  /// **'{karaka} is well supported today.'**
  String rzInfluenceGood(Object karaka);

  /// No description provided for @rzInfluenceHard.
  ///
  /// In en, this message translates to:
  /// **'{karaka} may face delays today.'**
  String rzInfluenceHard(Object karaka);

  /// No description provided for @rzDetailSummary.
  ///
  /// In en, this message translates to:
  /// **'Today supports {strong}, while {weak} needs patience and care.'**
  String rzDetailSummary(Object strong, Object weak);

  /// No description provided for @fdEnergyScore.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Energy Score'**
  String get fdEnergyScore;

  /// No description provided for @fdStatusAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get fdStatusAverage;

  /// No description provided for @fdStatusMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get fdStatusMixed;

  /// No description provided for @fdStatusChallenging.
  ///
  /// In en, this message translates to:
  /// **'Challenging'**
  String get fdStatusChallenging;

  /// No description provided for @fdTheme.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Theme'**
  String get fdTheme;

  /// No description provided for @fdExplainToday.
  ///
  /// In en, this message translates to:
  /// **'Explain Today'**
  String get fdExplainToday;

  /// No description provided for @fdTodaysFocus.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Focus'**
  String get fdTodaysFocus;

  /// No description provided for @fdTopRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Top Recommendation'**
  String get fdTopRecommendation;

  /// No description provided for @fdTopCaution.
  ///
  /// In en, this message translates to:
  /// **'Top Caution'**
  String get fdTopCaution;

  /// No description provided for @fdReadingTime.
  ///
  /// In en, this message translates to:
  /// **'Reading time'**
  String get fdReadingTime;

  /// No description provided for @fdSeconds30.
  ///
  /// In en, this message translates to:
  /// **'30 sec'**
  String get fdSeconds30;

  /// No description provided for @fdCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get fdCareer;

  /// No description provided for @fdMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get fdMoney;

  /// No description provided for @fdLove.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get fdLove;

  /// No description provided for @fdHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get fdHealth;

  /// No description provided for @fdTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get fdTravel;

  /// No description provided for @fdFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get fdFamily;

  /// No description provided for @fdBestToDo.
  ///
  /// In en, this message translates to:
  /// **'Best Things To Do Today'**
  String get fdBestToDo;

  /// No description provided for @fdAvoidToday.
  ///
  /// In en, this message translates to:
  /// **'Avoid Today'**
  String get fdAvoidToday;

  /// No description provided for @fdConfidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get fdConfidenceLabel;

  /// No description provided for @fdBestTime.
  ///
  /// In en, this message translates to:
  /// **'Best Time'**
  String get fdBestTime;

  /// No description provided for @fdRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get fdRecommended;

  /// No description provided for @fdReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get fdReason;

  /// No description provided for @fdRisk.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get fdRisk;

  /// No description provided for @fdRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get fdRecommendation;

  /// No description provided for @fdNoActions.
  ///
  /// In en, this message translates to:
  /// **'Nothing major to push today — keep a steady, calm routine.'**
  String get fdNoActions;

  /// No description provided for @fdNoCautions.
  ///
  /// In en, this message translates to:
  /// **'No major cautions today — proceed with normal awareness.'**
  String get fdNoCautions;

  /// No description provided for @fdHighlights.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Highlights'**
  String get fdHighlights;

  /// No description provided for @fdProbVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very High'**
  String get fdProbVeryHigh;

  /// No description provided for @fdProbHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get fdProbHigh;

  /// No description provided for @fdProbElevated.
  ///
  /// In en, this message translates to:
  /// **'Elevated'**
  String get fdProbElevated;

  /// No description provided for @fdProbCaution.
  ///
  /// In en, this message translates to:
  /// **'Caution'**
  String get fdProbCaution;

  /// No description provided for @fdWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'What to do'**
  String get fdWhatToDo;

  /// No description provided for @fdLifeAreas.
  ///
  /// In en, this message translates to:
  /// **'Life Areas'**
  String get fdLifeAreas;

  /// No description provided for @fdTapDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap for details'**
  String get fdTapDetails;

  /// No description provided for @fdArea1.
  ///
  /// In en, this message translates to:
  /// **'Self & Health'**
  String get fdArea1;

  /// No description provided for @fdArea2.
  ///
  /// In en, this message translates to:
  /// **'Wealth & Family'**
  String get fdArea2;

  /// No description provided for @fdArea3.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get fdArea3;

  /// No description provided for @fdArea4.
  ///
  /// In en, this message translates to:
  /// **'Home & Comfort'**
  String get fdArea4;

  /// No description provided for @fdArea5.
  ///
  /// In en, this message translates to:
  /// **'Creativity & Romance'**
  String get fdArea5;

  /// No description provided for @fdArea6.
  ///
  /// In en, this message translates to:
  /// **'Work & Duties'**
  String get fdArea6;

  /// No description provided for @fdArea7.
  ///
  /// In en, this message translates to:
  /// **'Relationships'**
  String get fdArea7;

  /// No description provided for @fdArea8.
  ///
  /// In en, this message translates to:
  /// **'Change & Depth'**
  String get fdArea8;

  /// No description provided for @fdArea9.
  ///
  /// In en, this message translates to:
  /// **'Luck & Travel'**
  String get fdArea9;

  /// No description provided for @fdArea10.
  ///
  /// In en, this message translates to:
  /// **'Career & Status'**
  String get fdArea10;

  /// No description provided for @fdArea11.
  ///
  /// In en, this message translates to:
  /// **'Gains & Network'**
  String get fdArea11;

  /// No description provided for @fdArea12.
  ///
  /// In en, this message translates to:
  /// **'Rest & Spirituality'**
  String get fdArea12;

  /// No description provided for @fdTodaysMeaning.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Meaning'**
  String get fdTodaysMeaning;

  /// No description provided for @fdGoodFor.
  ///
  /// In en, this message translates to:
  /// **'Good For'**
  String get fdGoodFor;

  /// No description provided for @fdAvoid.
  ///
  /// In en, this message translates to:
  /// **'Avoid'**
  String get fdAvoid;

  /// No description provided for @fdPlanetSupport.
  ///
  /// In en, this message translates to:
  /// **'Planet Support'**
  String get fdPlanetSupport;

  /// No description provided for @fdWhyPrediction.
  ///
  /// In en, this message translates to:
  /// **'Why this prediction?'**
  String get fdWhyPrediction;

  /// No description provided for @fdAdvancedDetails.
  ///
  /// In en, this message translates to:
  /// **'Advanced Details'**
  String get fdAdvancedDetails;

  /// No description provided for @fdAiRecommendation.
  ///
  /// In en, this message translates to:
  /// **'AI Recommendation'**
  String get fdAiRecommendation;

  /// No description provided for @fdOverallStatus.
  ///
  /// In en, this message translates to:
  /// **'Overall Status'**
  String get fdOverallStatus;

  /// No description provided for @fdNoPlanetTransit.
  ///
  /// In en, this message translates to:
  /// **'No major planet is transiting this area today.'**
  String get fdNoPlanetTransit;

  /// No description provided for @fdFinancialOutlook.
  ///
  /// In en, this message translates to:
  /// **'Financial Outlook'**
  String get fdFinancialOutlook;

  /// No description provided for @fdIncomeProbability.
  ///
  /// In en, this message translates to:
  /// **'Income Probability'**
  String get fdIncomeProbability;

  /// No description provided for @fdExpenseProbability.
  ///
  /// In en, this message translates to:
  /// **'Expense Probability'**
  String get fdExpenseProbability;

  /// No description provided for @fdNetBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Financial Balance'**
  String get fdNetBalance;

  /// No description provided for @fdAvoidSpending.
  ///
  /// In en, this message translates to:
  /// **'Avoid Spending'**
  String get fdAvoidSpending;

  /// No description provided for @fdRelationshipOutlook.
  ///
  /// In en, this message translates to:
  /// **'Relationship Outlook'**
  String get fdRelationshipOutlook;

  /// No description provided for @fdOverallScore.
  ///
  /// In en, this message translates to:
  /// **'Overall Score'**
  String get fdOverallScore;

  /// No description provided for @fdPartner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get fdPartner;

  /// No description provided for @fdRomance.
  ///
  /// In en, this message translates to:
  /// **'Romance'**
  String get fdRomance;

  /// No description provided for @fdWorkplace.
  ///
  /// In en, this message translates to:
  /// **'Workplace'**
  String get fdWorkplace;

  /// No description provided for @fdPublicImage.
  ///
  /// In en, this message translates to:
  /// **'Public Image'**
  String get fdPublicImage;

  /// No description provided for @fdBestActivity.
  ///
  /// In en, this message translates to:
  /// **'Best Activity'**
  String get fdBestActivity;

  /// No description provided for @fdWeakArea.
  ///
  /// In en, this message translates to:
  /// **'Weak Area'**
  String get fdWeakArea;

  /// No description provided for @fdBiggestOpportunity.
  ///
  /// In en, this message translates to:
  /// **'Biggest Opportunity'**
  String get fdBiggestOpportunity;

  /// No description provided for @fdBiggestRisk.
  ///
  /// In en, this message translates to:
  /// **'Biggest Risk'**
  String get fdBiggestRisk;

  /// No description provided for @fdProbability.
  ///
  /// In en, this message translates to:
  /// **'Probability'**
  String get fdProbability;

  /// No description provided for @fdProtection.
  ///
  /// In en, this message translates to:
  /// **'Protection Advice'**
  String get fdProtection;

  /// No description provided for @fdDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fdDescription;

  /// No description provided for @fdBestTimeToday.
  ///
  /// In en, this message translates to:
  /// **'Best Time Today'**
  String get fdBestTimeToday;

  /// No description provided for @fdAvoidDuring.
  ///
  /// In en, this message translates to:
  /// **'Avoid During'**
  String get fdAvoidDuring;

  /// No description provided for @fdPredictionConfidence.
  ///
  /// In en, this message translates to:
  /// **'Prediction Confidence'**
  String get fdPredictionConfidence;

  /// No description provided for @fdConfBasis.
  ///
  /// In en, this message translates to:
  /// **'Today\'s prediction combines'**
  String get fdConfBasis;

  /// No description provided for @fdConfNatal.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart'**
  String get fdConfNatal;

  /// No description provided for @fdConfTransit.
  ///
  /// In en, this message translates to:
  /// **'Current Transit'**
  String get fdConfTransit;

  /// No description provided for @fdConfDasha.
  ///
  /// In en, this message translates to:
  /// **'Planetary Periods'**
  String get fdConfDasha;

  /// No description provided for @fdConfStrength.
  ///
  /// In en, this message translates to:
  /// **'Planet Strength'**
  String get fdConfStrength;

  /// No description provided for @fdConfHouse.
  ///
  /// In en, this message translates to:
  /// **'House Activation'**
  String get fdConfHouse;

  /// No description provided for @fdAskAi.
  ///
  /// In en, this message translates to:
  /// **'Ask AI'**
  String get fdAskAi;

  /// No description provided for @fdAskAiSub.
  ///
  /// In en, this message translates to:
  /// **'Tap a question to get today\'s answer'**
  String get fdAskAiSub;

  /// No description provided for @fdQ1.
  ///
  /// In en, this message translates to:
  /// **'Why is career slow today?'**
  String get fdQ1;

  /// No description provided for @fdQ2.
  ///
  /// In en, this message translates to:
  /// **'What is the best time today?'**
  String get fdQ2;

  /// No description provided for @fdQ3.
  ///
  /// In en, this message translates to:
  /// **'Is today good for money matters?'**
  String get fdQ3;

  /// No description provided for @fdQ4.
  ///
  /// In en, this message translates to:
  /// **'Is today good for travel?'**
  String get fdQ4;

  /// No description provided for @fdQ5.
  ///
  /// In en, this message translates to:
  /// **'What should I avoid today?'**
  String get fdQ5;

  /// No description provided for @fdMoreSuggestions.
  ///
  /// In en, this message translates to:
  /// **'More Suggestions'**
  String get fdMoreSuggestions;

  /// No description provided for @fdAiSummaryLine.
  ///
  /// In en, this message translates to:
  /// **'Today is best suited for {top}. {weak} may feel slow, so avoid major decisions there. Financially the day looks {fin}.'**
  String fdAiSummaryLine(Object top, Object weak, Object fin);

  /// No description provided for @fdThemeFocusLine.
  ///
  /// In en, this message translates to:
  /// **'Your energy today gathers around {top} — lean into it and go gently elsewhere.'**
  String fdThemeFocusLine(Object top);

  /// No description provided for @gochToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get gochToday;

  /// No description provided for @gochOverallScore.
  ///
  /// In en, this message translates to:
  /// **'Overall Transit Score'**
  String get gochOverallScore;

  /// No description provided for @gochNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get gochNeutral;

  /// No description provided for @gochChallenging.
  ///
  /// In en, this message translates to:
  /// **'Challenging'**
  String get gochChallenging;

  /// No description provided for @gochTopPositive.
  ///
  /// In en, this message translates to:
  /// **'Top Positive'**
  String get gochTopPositive;

  /// No description provided for @gochTopChallenges.
  ///
  /// In en, this message translates to:
  /// **'Top Challenges'**
  String get gochTopChallenges;

  /// No description provided for @gochFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get gochFilterAll;

  /// No description provided for @gochFavorability.
  ///
  /// In en, this message translates to:
  /// **'Favorability'**
  String get gochFavorability;

  /// No description provided for @gochAlerts.
  ///
  /// In en, this message translates to:
  /// **'Transit Alerts'**
  String get gochAlerts;

  /// No description provided for @gochAlertCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get gochAlertCritical;

  /// No description provided for @gochAlertWarning.
  ///
  /// In en, this message translates to:
  /// **'Caution'**
  String get gochAlertWarning;

  /// No description provided for @gochAlertOpportunity.
  ///
  /// In en, this message translates to:
  /// **'Opportunity'**
  String get gochAlertOpportunity;

  /// No description provided for @gochAiFocus.
  ///
  /// In en, this message translates to:
  /// **'AI Focus Today'**
  String get gochAiFocus;

  /// No description provided for @gochLifeScores.
  ///
  /// In en, this message translates to:
  /// **'Life Area Scores'**
  String get gochLifeScores;

  /// No description provided for @gochWhy.
  ///
  /// In en, this message translates to:
  /// **'Why?'**
  String get gochWhy;

  /// No description provided for @gochCurrentTransits.
  ///
  /// In en, this message translates to:
  /// **'Active Transits'**
  String get gochCurrentTransits;

  /// No description provided for @gochDailyPlan.
  ///
  /// In en, this message translates to:
  /// **'Your Daily Plan'**
  String get gochDailyPlan;

  /// No description provided for @gochMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get gochMorning;

  /// No description provided for @gochAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get gochAfternoon;

  /// No description provided for @gochEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get gochEvening;

  /// No description provided for @gochNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get gochNight;

  /// No description provided for @gochSmartReco.
  ///
  /// In en, this message translates to:
  /// **'Smart Recommendations'**
  String get gochSmartReco;

  /// No description provided for @gochExplain.
  ///
  /// In en, this message translates to:
  /// **'Explain Today\'s Transit'**
  String get gochExplain;

  /// No description provided for @gochDo.
  ///
  /// In en, this message translates to:
  /// **'Do'**
  String get gochDo;

  /// No description provided for @gochDont.
  ///
  /// In en, this message translates to:
  /// **'Avoid'**
  String get gochDont;

  /// No description provided for @gochDoWork.
  ///
  /// In en, this message translates to:
  /// **'Tackle important work'**
  String get gochDoWork;

  /// No description provided for @gochDoMeditate.
  ///
  /// In en, this message translates to:
  /// **'Meditate and reflect'**
  String get gochDoMeditate;

  /// No description provided for @gochDoStart.
  ///
  /// In en, this message translates to:
  /// **'Start new plans'**
  String get gochDoStart;

  /// No description provided for @gochDoFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish pending tasks'**
  String get gochDoFinish;

  /// No description provided for @gochDontArgue.
  ///
  /// In en, this message translates to:
  /// **'Avoid arguments'**
  String get gochDontArgue;

  /// No description provided for @gochDontImpulsive.
  ///
  /// In en, this message translates to:
  /// **'Avoid impulsive decisions'**
  String get gochDontImpulsive;

  /// No description provided for @gochDontOverspend.
  ///
  /// In en, this message translates to:
  /// **'Avoid overspending'**
  String get gochDontOverspend;

  /// No description provided for @gochThemeGrowth.
  ///
  /// In en, this message translates to:
  /// **'A day of growth in {area} — lean into it.'**
  String gochThemeGrowth(Object area);

  /// No description provided for @gochThemeChallenge.
  ///
  /// In en, this message translates to:
  /// **'Stay patient with {area} today — go steady.'**
  String gochThemeChallenge(Object area);

  /// No description provided for @gochPosLine.
  ///
  /// In en, this message translates to:
  /// **'{area} is well supported right now.'**
  String gochPosLine(Object area);

  /// No description provided for @gochChalLine.
  ///
  /// In en, this message translates to:
  /// **'{area} needs extra care today.'**
  String gochChalLine(Object area);

  /// No description provided for @gochAiFocusLine.
  ///
  /// In en, this message translates to:
  /// **'Put your energy into {a1} today, and be gentle with {a2}.'**
  String gochAiFocusLine(Object a1, Object a2);

  /// No description provided for @divBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get divBeginner;

  /// No description provided for @divSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search: career, marriage, education…'**
  String get divSearchHint;

  /// No description provided for @divSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Divisional Chart Summary'**
  String get divSummaryTitle;

  /// No description provided for @divTotalCharts.
  ///
  /// In en, this message translates to:
  /// **'Total Charts'**
  String get divTotalCharts;

  /// No description provided for @divMostImportant.
  ///
  /// In en, this message translates to:
  /// **'Most Important'**
  String get divMostImportant;

  /// No description provided for @divRecommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended For You'**
  String get divRecommendedForYou;

  /// No description provided for @divCatEssential.
  ///
  /// In en, this message translates to:
  /// **'Essential Charts'**
  String get divCatEssential;

  /// No description provided for @divCatPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal Life'**
  String get divCatPersonal;

  /// No description provided for @divCatKnowledge.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Charts'**
  String get divCatKnowledge;

  /// No description provided for @divCatAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced Charts'**
  String get divCatAdvanced;

  /// No description provided for @divGoalProperty.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get divGoalProperty;

  /// No description provided for @divGoalKarma.
  ///
  /// In en, this message translates to:
  /// **'Karma'**
  String get divGoalKarma;

  /// No description provided for @divBadgeHighlyRec.
  ///
  /// In en, this message translates to:
  /// **'Highly Recommended'**
  String get divBadgeHighlyRec;

  /// No description provided for @divBadgeRec.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get divBadgeRec;

  /// No description provided for @divBadgeUseful.
  ///
  /// In en, this message translates to:
  /// **'Useful'**
  String get divBadgeUseful;

  /// No description provided for @divBadgeOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get divBadgeOptional;

  /// No description provided for @divBadgeAdvOnly.
  ///
  /// In en, this message translates to:
  /// **'Advanced Only'**
  String get divBadgeAdvOnly;

  /// No description provided for @divRecommendBest.
  ///
  /// In en, this message translates to:
  /// **'Recommend Best Charts'**
  String get divRecommendBest;

  /// No description provided for @divNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No charts match your search'**
  String get divNoMatch;

  /// No description provided for @divLifeAreas.
  ///
  /// In en, this message translates to:
  /// **'Life Areas'**
  String get divLifeAreas;

  /// No description provided for @divAiUse.
  ///
  /// In en, this message translates to:
  /// **'Use this chart to analyse {purpose}.'**
  String divAiUse(Object purpose);

  /// No description provided for @divHeroSummary.
  ///
  /// In en, this message translates to:
  /// **'Your {c1} and {c2} charts are especially important — start there for the areas they cover, then explore the rest as needed.'**
  String divHeroSummary(Object c1, Object c2);

  /// No description provided for @divRecReasonHouse.
  ///
  /// In en, this message translates to:
  /// **'Your {house} house needs a closer look — this chart shows it in depth.'**
  String divRecReasonHouse(Object house);

  /// No description provided for @divRecReasonPlanet.
  ///
  /// In en, this message translates to:
  /// **'{planet} is a key but tested planet — this chart reveals its deeper condition.'**
  String divRecReasonPlanet(Object planet);

  /// No description provided for @divRecReasonDasha.
  ///
  /// In en, this message translates to:
  /// **'You are in {planet}\'s Mahadasha, so this chart is especially timely now.'**
  String divRecReasonDasha(Object planet);

  /// No description provided for @divRecSummary.
  ///
  /// In en, this message translates to:
  /// **'Based on your chart, {c1} should be your highest priority. The charts below are ordered by how relevant they are for you right now.'**
  String divRecSummary(Object c1);

  /// No description provided for @divWhenToUseLine.
  ///
  /// In en, this message translates to:
  /// **'Open this chart when you want to study {purpose}.'**
  String divWhenToUseLine(Object purpose);

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

  /// No description provided for @yogaHelpful.
  ///
  /// In en, this message translates to:
  /// **'Helpful'**
  String get yogaHelpful;

  /// No description provided for @yogaInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get yogaInactive;

  /// No description provided for @yogaTabMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get yogaTabMoney;

  /// No description provided for @yogaTabRare.
  ///
  /// In en, this message translates to:
  /// **'Rare'**
  String get yogaTabRare;

  /// No description provided for @yogaSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Yoga Summary'**
  String get yogaSummaryTitle;

  /// No description provided for @yogaActiveYogas.
  ///
  /// In en, this message translates to:
  /// **'Active Yogas'**
  String get yogaActiveYogas;

  /// No description provided for @yogaTotalYogas.
  ///
  /// In en, this message translates to:
  /// **'Total Yogas'**
  String get yogaTotalYogas;

  /// No description provided for @yogaMostPowerful.
  ///
  /// In en, this message translates to:
  /// **'Most Powerful'**
  String get yogaMostPowerful;

  /// No description provided for @yogaFortuneRating.
  ///
  /// In en, this message translates to:
  /// **'Overall Fortune'**
  String get yogaFortuneRating;

  /// No description provided for @yogaBenefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get yogaBenefits;

  /// No description provided for @yogaSupportingPlanets.
  ///
  /// In en, this message translates to:
  /// **'Supporting Planets'**
  String get yogaSupportingPlanets;

  /// No description provided for @yogaRanking.
  ///
  /// In en, this message translates to:
  /// **'Top 5 Strongest Yogas'**
  String get yogaRanking;

  /// No description provided for @yogaExplain.
  ///
  /// In en, this message translates to:
  /// **'Explain My Yogas'**
  String get yogaExplain;

  /// No description provided for @yogaExplainSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How your yogas support you'**
  String get yogaExplainSubtitle;

  /// No description provided for @yogaNoneActive.
  ///
  /// In en, this message translates to:
  /// **'No active yogas yet'**
  String get yogaNoneActive;

  /// No description provided for @yogaNoneInCategory.
  ///
  /// In en, this message translates to:
  /// **'No yogas in this category'**
  String get yogaNoneInCategory;

  /// No description provided for @yogaHeroSummary.
  ///
  /// In en, this message translates to:
  /// **'Your chart carries {count} active yogas — supportive planetary combinations. Combinations involving {planets} create especially helpful influences for growth and success.'**
  String yogaHeroSummary(Object count, Object planets);

  /// No description provided for @yogaAiLine.
  ///
  /// In en, this message translates to:
  /// **'{name} supports {areas}, and its benefits grow when its planets are active in dasha or transit.'**
  String yogaAiLine(Object name, Object areas);

  /// No description provided for @yogaAiGeneric.
  ///
  /// In en, this message translates to:
  /// **'This yoga is a supportive combination in your chart that strengthens its related areas of life.'**
  String get yogaAiGeneric;

  /// No description provided for @yogaExplainReassure.
  ///
  /// In en, this message translates to:
  /// **'Yogas are the bright spots of your chart — helpful planetary combinations working in your favour. The stronger ones deliver lasting benefits, especially during the periods of the planets that form them.'**
  String get yogaExplainReassure;

  /// No description provided for @doshSevere.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get doshSevere;

  /// No description provided for @doshVeryMild.
  ///
  /// In en, this message translates to:
  /// **'Very Mild'**
  String get doshVeryMild;

  /// No description provided for @doshLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get doshLow;

  /// No description provided for @doshHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get doshHigh;

  /// No description provided for @doshCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get doshCritical;

  /// No description provided for @doshSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Dosha Summary'**
  String get doshSummaryTitle;

  /// No description provided for @doshActiveDoshas.
  ///
  /// In en, this message translates to:
  /// **'Active Doshas'**
  String get doshActiveDoshas;

  /// No description provided for @doshTotalChecked.
  ///
  /// In en, this message translates to:
  /// **'Total Checked'**
  String get doshTotalChecked;

  /// No description provided for @doshOverallSeverity.
  ///
  /// In en, this message translates to:
  /// **'Overall Severity'**
  String get doshOverallSeverity;

  /// No description provided for @doshNoneActive.
  ///
  /// In en, this message translates to:
  /// **'No active doshas — a clean chart!'**
  String get doshNoneActive;

  /// No description provided for @doshCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get doshCategory;

  /// No description provided for @doshConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get doshConfidence;

  /// No description provided for @doshWhyFormed.
  ///
  /// In en, this message translates to:
  /// **'Why This Formed'**
  String get doshWhyFormed;

  /// No description provided for @doshAffectedAreas.
  ///
  /// In en, this message translates to:
  /// **'Affected Areas'**
  String get doshAffectedAreas;

  /// No description provided for @doshTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get doshTimeline;

  /// No description provided for @doshDefinition.
  ///
  /// In en, this message translates to:
  /// **'Definition'**
  String get doshDefinition;

  /// No description provided for @doshFormationRule.
  ///
  /// In en, this message translates to:
  /// **'Formation Rule'**
  String get doshFormationRule;

  /// No description provided for @doshSupportingPlanets.
  ///
  /// In en, this message translates to:
  /// **'Related Planet'**
  String get doshSupportingPlanets;

  /// No description provided for @doshCancellation.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Yogas'**
  String get doshCancellation;

  /// No description provided for @doshNoCancellation.
  ///
  /// In en, this message translates to:
  /// **'None found'**
  String get doshNoCancellation;

  /// No description provided for @doshAreaChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get doshAreaChildren;

  /// No description provided for @doshAreaMind.
  ///
  /// In en, this message translates to:
  /// **'Mind'**
  String get doshAreaMind;

  /// No description provided for @remMantra.
  ///
  /// In en, this message translates to:
  /// **'Mantra'**
  String get remMantra;

  /// No description provided for @remGemstone.
  ///
  /// In en, this message translates to:
  /// **'Gemstone'**
  String get remGemstone;

  /// No description provided for @remDonation.
  ///
  /// In en, this message translates to:
  /// **'Donation'**
  String get remDonation;

  /// No description provided for @remTemple.
  ///
  /// In en, this message translates to:
  /// **'Temple'**
  String get remTemple;

  /// No description provided for @remFasting.
  ///
  /// In en, this message translates to:
  /// **'Fasting'**
  String get remFasting;

  /// No description provided for @remLifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get remLifestyle;

  /// No description provided for @remLifestyleGeneric.
  ///
  /// In en, this message translates to:
  /// **'Practise gratitude, discipline and charity connected to this planet, and keep good conduct.'**
  String get remLifestyleGeneric;

  /// No description provided for @doshExplain.
  ///
  /// In en, this message translates to:
  /// **'Explain My Doshas'**
  String get doshExplain;

  /// No description provided for @doshExplainSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A calm, practical look at your doshas'**
  String get doshExplainSubtitle;

  /// No description provided for @doshExplainReassure.
  ///
  /// In en, this message translates to:
  /// **'Doshas are common — almost every chart has some. They describe tendencies, not fixed fate. Awareness, good conduct and simple remedies reduce their practical effect, so there is no need to worry.'**
  String get doshExplainReassure;

  /// No description provided for @doshAiGeneric.
  ///
  /// In en, this message translates to:
  /// **'This dosha describes a tendency in your chart. Its practical effect is usually mild and can be balanced with awareness and simple remedies.'**
  String get doshAiGeneric;

  /// No description provided for @doshHeroSummary.
  ///
  /// In en, this message translates to:
  /// **'Your chart shows {active} active doshas out of {total} checked. Most are mild and only a few need attention. With understanding and simple remedies, their practical effect can be eased.'**
  String doshHeroSummary(Object active, Object total);

  /// No description provided for @doshAiLine.
  ///
  /// In en, this message translates to:
  /// **'This dosha mainly influences {areas}. During {planet} periods its effect can feel stronger, and remedies help balance it.'**
  String doshAiLine(Object areas, Object planet);

  /// No description provided for @doshTimelineLine.
  ///
  /// In en, this message translates to:
  /// **'Its effect is felt most during the Mahadasha and Antardasha of {planet}, and when {planet} is active in transit.'**
  String doshTimelineLine(Object planet);

  /// No description provided for @sbLegendary.
  ///
  /// In en, this message translates to:
  /// **'Legendary'**
  String get sbLegendary;

  /// No description provided for @sbSthana.
  ///
  /// In en, this message translates to:
  /// **'Sthana Bala'**
  String get sbSthana;

  /// No description provided for @sbDig.
  ///
  /// In en, this message translates to:
  /// **'Dig Bala'**
  String get sbDig;

  /// No description provided for @sbKala.
  ///
  /// In en, this message translates to:
  /// **'Kala Bala'**
  String get sbKala;

  /// No description provided for @sbChesta.
  ///
  /// In en, this message translates to:
  /// **'Chesta Bala'**
  String get sbChesta;

  /// No description provided for @sbNaisargika.
  ///
  /// In en, this message translates to:
  /// **'Naisargika Bala'**
  String get sbNaisargika;

  /// No description provided for @sbDrik.
  ///
  /// In en, this message translates to:
  /// **'Drik Bala'**
  String get sbDrik;

  /// No description provided for @sbSummary.
  ///
  /// In en, this message translates to:
  /// **'Planetary Strength Summary'**
  String get sbSummary;

  /// No description provided for @sbAverageStrength.
  ///
  /// In en, this message translates to:
  /// **'Average Strength'**
  String get sbAverageStrength;

  /// No description provided for @sbHighestRupa.
  ///
  /// In en, this message translates to:
  /// **'Highest Rupa'**
  String get sbHighestRupa;

  /// No description provided for @sbRupa.
  ///
  /// In en, this message translates to:
  /// **'Rupa'**
  String get sbRupa;

  /// No description provided for @sbRanking.
  ///
  /// In en, this message translates to:
  /// **'Planet Ranking'**
  String get sbRanking;

  /// No description provided for @sbRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get sbRequired;

  /// No description provided for @sbExcess.
  ///
  /// In en, this message translates to:
  /// **'Excess'**
  String get sbExcess;

  /// No description provided for @sbDeficit.
  ///
  /// In en, this message translates to:
  /// **'Deficit'**
  String get sbDeficit;

  /// No description provided for @sbTotalShadbala.
  ///
  /// In en, this message translates to:
  /// **'Total Shadbala'**
  String get sbTotalShadbala;

  /// No description provided for @sbExplain.
  ///
  /// In en, this message translates to:
  /// **'Explain My Planetary Strength'**
  String get sbExplain;

  /// No description provided for @sbExplainSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A simple summary of your planets\' strength'**
  String get sbExplainSubtitle;

  /// No description provided for @sbInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Understanding Shadbala'**
  String get sbInfoTitle;

  /// No description provided for @sbQWhatIs.
  ///
  /// In en, this message translates to:
  /// **'What is Shadbala?'**
  String get sbQWhatIs;

  /// No description provided for @sbQRupas.
  ///
  /// In en, this message translates to:
  /// **'What are Rupas?'**
  String get sbQRupas;

  /// No description provided for @sbQHowCalc.
  ///
  /// In en, this message translates to:
  /// **'How is strength calculated?'**
  String get sbQHowCalc;

  /// No description provided for @sbQHowUse.
  ///
  /// In en, this message translates to:
  /// **'How to use this'**
  String get sbQHowUse;

  /// No description provided for @sbWhyStrong.
  ///
  /// In en, this message translates to:
  /// **'Why Strong'**
  String get sbWhyStrong;

  /// No description provided for @sbWhyWeak.
  ///
  /// In en, this message translates to:
  /// **'Why Weak'**
  String get sbWhyWeak;

  /// No description provided for @sbDuringMahadasha.
  ///
  /// In en, this message translates to:
  /// **'During Mahadasha'**
  String get sbDuringMahadasha;

  /// No description provided for @sbEffects.
  ///
  /// In en, this message translates to:
  /// **'Effects'**
  String get sbEffects;

  /// No description provided for @sbLifeAreas.
  ///
  /// In en, this message translates to:
  /// **'Life Areas'**
  String get sbLifeAreas;

  /// No description provided for @sbPlanetDetails.
  ///
  /// In en, this message translates to:
  /// **'Planet Details'**
  String get sbPlanetDetails;

  /// No description provided for @sbBodyWhatIs.
  ///
  /// In en, this message translates to:
  /// **'Shadbala (\'six-fold strength\') measures how much power each planet has to deliver its results, by adding six independent sources of strength.'**
  String get sbBodyWhatIs;

  /// No description provided for @sbBodyRupas.
  ///
  /// In en, this message translates to:
  /// **'Strength is measured in Rupas (1 Rupa = 60 Virupas). Each planet needs a minimum Rupa strength to count as strong; more Rupas means it delivers its results more fully.'**
  String get sbBodyRupas;

  /// No description provided for @sbBodyHowCalc.
  ///
  /// In en, this message translates to:
  /// **'Six balas are added: Sthana (positional), Dig (directional), Kala (temporal), Chesta (motional), Naisargika (natural) and Drik (aspectual). The total is compared with the planet\'s required minimum to get a percentage.'**
  String get sbBodyHowCalc;

  /// No description provided for @sbBodyHowUse.
  ///
  /// In en, this message translates to:
  /// **'A planet above 100% comfortably delivers its significations; below 100% it needs support. Favour your strongest planets for important matters, and give the weakest ones remedies and patience.'**
  String get sbBodyHowUse;

  /// No description provided for @sbRemedyStrong.
  ///
  /// In en, this message translates to:
  /// **'Well-supported — no special remedy needed; you can use this planet\'s periods confidently.'**
  String get sbRemedyStrong;

  /// No description provided for @sbHeroSummary.
  ///
  /// In en, this message translates to:
  /// **'{strongP} is your strongest planet, giving excellent support for {strongTrait}. {weakP} is the weakest and benefits most from remedies.'**
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP);

  /// No description provided for @sbCardAi.
  ///
  /// In en, this message translates to:
  /// **'{planet} has {category} Shadbala, so its {karakatva} are supported accordingly.'**
  String sbCardAi(Object planet, Object category, Object karakatva);

  /// No description provided for @sbWhyLine.
  ///
  /// In en, this message translates to:
  /// **'Strongest through {bala} ({rupa} rupas).'**
  String sbWhyLine(Object bala, Object rupa);

  /// No description provided for @sbWeakLine.
  ///
  /// In en, this message translates to:
  /// **'Weakest in {bala}, which lowers the total.'**
  String sbWeakLine(Object bala);

  /// No description provided for @sbMahadashaLine.
  ///
  /// In en, this message translates to:
  /// **'During {planet}\'s Mahadasha, its {karak} come to the fore.'**
  String sbMahadashaLine(Object planet, Object karak);

  /// No description provided for @sbEffectStrong.
  ///
  /// In en, this message translates to:
  /// **'With strong Shadbala, {karak} are naturally supported.'**
  String sbEffectStrong(Object karak);

  /// No description provided for @sbEffectWeak.
  ///
  /// In en, this message translates to:
  /// **'With modest Shadbala, {karak} may need conscious effort.'**
  String sbEffectWeak(Object karak);

  /// No description provided for @sbRemedyWeak.
  ///
  /// In en, this message translates to:
  /// **'Strengthen {planet} through its mantra, gemstone or charity, and act patiently during its periods.'**
  String sbRemedyWeak(Object planet);

  /// No description provided for @bhOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get bhOverview;

  /// No description provided for @bhDetailed.
  ///
  /// In en, this message translates to:
  /// **'Detailed'**
  String get bhDetailed;

  /// No description provided for @bhavaHouses.
  ///
  /// In en, this message translates to:
  /// **'Houses'**
  String get bhavaHouses;

  /// No description provided for @bhStrengthOverview.
  ///
  /// In en, this message translates to:
  /// **'House Strength Overview'**
  String get bhStrengthOverview;

  /// No description provided for @bhOverallAverage.
  ///
  /// In en, this message translates to:
  /// **'Overall House Average'**
  String get bhOverallAverage;

  /// No description provided for @bhStrongestHouse.
  ///
  /// In en, this message translates to:
  /// **'Strongest House'**
  String get bhStrongestHouse;

  /// No description provided for @bhWeakestHouse.
  ///
  /// In en, this message translates to:
  /// **'Weakest House'**
  String get bhWeakestHouse;

  /// No description provided for @bhBestArea.
  ///
  /// In en, this message translates to:
  /// **'Best Life Area'**
  String get bhBestArea;

  /// No description provided for @bhNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs Attention'**
  String get bhNeedsAttention;

  /// No description provided for @bhSavContribution.
  ///
  /// In en, this message translates to:
  /// **'SAV Contribution'**
  String get bhSavContribution;

  /// No description provided for @bhLordCondition.
  ///
  /// In en, this message translates to:
  /// **'House Lord Condition'**
  String get bhLordCondition;

  /// No description provided for @bhBenefic.
  ///
  /// In en, this message translates to:
  /// **'Benefic Influence'**
  String get bhBenefic;

  /// No description provided for @bhMalefic.
  ///
  /// In en, this message translates to:
  /// **'Malefic Influence'**
  String get bhMalefic;

  /// No description provided for @bhStrengthReasons.
  ///
  /// In en, this message translates to:
  /// **'Why This Score'**
  String get bhStrengthReasons;

  /// No description provided for @bhGoodEffects.
  ///
  /// In en, this message translates to:
  /// **'Good Effects'**
  String get bhGoodEffects;

  /// No description provided for @bhChallenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get bhChallenges;

  /// No description provided for @bhRemedies.
  ///
  /// In en, this message translates to:
  /// **'Remedies'**
  String get bhRemedies;

  /// No description provided for @bhRanking.
  ///
  /// In en, this message translates to:
  /// **'House Ranking'**
  String get bhRanking;

  /// No description provided for @bhSav.
  ///
  /// In en, this message translates to:
  /// **'SAV'**
  String get bhSav;

  /// No description provided for @bhExplain.
  ///
  /// In en, this message translates to:
  /// **'Explain My Houses'**
  String get bhExplain;

  /// No description provided for @bhExplainSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A simple summary of your 12 houses'**
  String get bhExplainSubtitle;

  /// No description provided for @bhHeroSummary.
  ///
  /// In en, this message translates to:
  /// **'Your strongest houses are {s1} and {s2}. {strongArea} is naturally strong, while {weakArea} needs more effort.'**
  String bhHeroSummary(Object s1, Object s2, Object strongArea, Object weakArea);

  /// No description provided for @bhLordLine.
  ///
  /// In en, this message translates to:
  /// **'Its lord {lord} is placed as {relation}.'**
  String bhLordLine(Object lord, Object relation);

  /// No description provided for @bhWhyLine.
  ///
  /// In en, this message translates to:
  /// **'This house carries {sav} benefic points (SAV); its occupants and aspects shape the rest of the score.'**
  String bhWhyLine(Object sav);

  /// No description provided for @bhGoodLine.
  ///
  /// In en, this message translates to:
  /// **'When strong, it supports {meaning}.'**
  String bhGoodLine(Object meaning);

  /// No description provided for @bhChallengeLine.
  ///
  /// In en, this message translates to:
  /// **'When weak, {meaning} may need extra effort and care.'**
  String bhChallengeLine(Object meaning);

  /// No description provided for @bhRemedyLine.
  ///
  /// In en, this message translates to:
  /// **'Strengthen its lord {lord} and honour this house\'s matters to lift it.'**
  String bhRemedyLine(Object lord);

  /// No description provided for @bhCardAi.
  ///
  /// In en, this message translates to:
  /// **'Your {house} is {strengthWord}. It governs {meaning}.'**
  String bhCardAi(Object house, Object strengthWord, Object meaning);

  /// No description provided for @kunNavamsa.
  ///
  /// In en, this message translates to:
  /// **'Navamsa (D9)'**
  String get kunNavamsa;

  /// No description provided for @kunD10.
  ///
  /// In en, this message translates to:
  /// **'Dasamsa (D10)'**
  String get kunD10;

  /// No description provided for @kunPlacement.
  ///
  /// In en, this message translates to:
  /// **'Planet Placement'**
  String get kunPlacement;

  /// No description provided for @kunHousesTitle.
  ///
  /// In en, this message translates to:
  /// **'House Details'**
  String get kunHousesTitle;

  /// No description provided for @kunPlanet.
  ///
  /// In en, this message translates to:
  /// **'Planet'**
  String get kunPlanet;

  /// No description provided for @kunNakshatra.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra'**
  String get kunNakshatra;

  /// No description provided for @kunPada.
  ///
  /// In en, this message translates to:
  /// **'Pada'**
  String get kunPada;

  /// No description provided for @kunLord.
  ///
  /// In en, this message translates to:
  /// **'Lord'**
  String get kunLord;

  /// No description provided for @kunExplain.
  ///
  /// In en, this message translates to:
  /// **'Explain My Chart'**
  String get kunExplain;

  /// No description provided for @kunExplainSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A simple summary of your chart'**
  String get kunExplainSubtitle;

  /// No description provided for @kunHouseLine.
  ///
  /// In en, this message translates to:
  /// **'The {ordinal} house governs {meaning}.'**
  String kunHouseLine(Object ordinal, Object meaning);

  /// No description provided for @kunHouseOccupied.
  ///
  /// In en, this message translates to:
  /// **'{planets} placed here shape its results.'**
  String kunHouseOccupied(Object planets);

  /// No description provided for @kunExplainAsc.
  ///
  /// In en, this message translates to:
  /// **'Your ascendant is {asc}, shaping your outlook and how others first see you.'**
  String kunExplainAsc(Object asc);

  /// No description provided for @kunExplainMoon.
  ///
  /// In en, this message translates to:
  /// **'Your mind and emotions follow the Moon in {moon}.'**
  String kunExplainMoon(Object moon);

  /// No description provided for @kunExplainStrong.
  ///
  /// In en, this message translates to:
  /// **'{planet} is your strongest planet — a natural area of ease and support.'**
  String kunExplainStrong(Object planet);

  /// No description provided for @kunExplainWeak.
  ///
  /// In en, this message translates to:
  /// **'{planet} is your most tested planet — patience and effort pay off here.'**
  String kunExplainWeak(Object planet);

  /// No description provided for @plNature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get plNature;

  /// No description provided for @plElement.
  ///
  /// In en, this message translates to:
  /// **'Element'**
  String get plElement;

  /// No description provided for @plGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get plGender;

  /// No description provided for @plKarakatva.
  ///
  /// In en, this message translates to:
  /// **'Karakatva'**
  String get plKarakatva;

  /// No description provided for @plLordship.
  ///
  /// In en, this message translates to:
  /// **'Lordship'**
  String get plLordship;

  /// No description provided for @plStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get plStrength;

  /// No description provided for @plAspectsGiven.
  ///
  /// In en, this message translates to:
  /// **'Aspects Given'**
  String get plAspectsGiven;

  /// No description provided for @plAspectsReceived.
  ///
  /// In en, this message translates to:
  /// **'Aspects Received'**
  String get plAspectsReceived;

  /// No description provided for @plConjunction.
  ///
  /// In en, this message translates to:
  /// **'Conjunction'**
  String get plConjunction;

  /// No description provided for @plHouseMeaning.
  ///
  /// In en, this message translates to:
  /// **'House Meaning'**
  String get plHouseMeaning;

  /// No description provided for @plNakshatraMeaning.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra Meaning'**
  String get plNakshatraMeaning;

  /// No description provided for @plAiInterpretation.
  ///
  /// In en, this message translates to:
  /// **'AI Interpretation'**
  String get plAiInterpretation;

  /// No description provided for @plSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search any planet'**
  String get plSearchHint;

  /// No description provided for @plNoResults.
  ///
  /// In en, this message translates to:
  /// **'No planets found'**
  String get plNoResults;

  /// No description provided for @plBenefic.
  ///
  /// In en, this message translates to:
  /// **'Benefic'**
  String get plBenefic;

  /// No description provided for @plMalefic.
  ///
  /// In en, this message translates to:
  /// **'Malefic'**
  String get plMalefic;

  /// No description provided for @plMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get plMale;

  /// No description provided for @plFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get plFemale;

  /// No description provided for @plNeutralGender.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get plNeutralGender;

  /// No description provided for @plOwnSign.
  ///
  /// In en, this message translates to:
  /// **'Own Sign'**
  String get plOwnSign;

  /// No description provided for @plFriend.
  ///
  /// In en, this message translates to:
  /// **'Friend Sign'**
  String get plFriend;

  /// No description provided for @plEnemy.
  ///
  /// In en, this message translates to:
  /// **'Enemy Sign'**
  String get plEnemy;

  /// No description provided for @plNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get plNeutral;

  /// No description provided for @sumEther.
  ///
  /// In en, this message translates to:
  /// **'Ether'**
  String get sumEther;

  /// No description provided for @plLordOfHouses.
  ///
  /// In en, this message translates to:
  /// **'Lord of house(s) {houses}'**
  String plLordOfHouses(Object houses);

  /// No description provided for @plNakMeaning.
  ///
  /// In en, this message translates to:
  /// **'Ruled by {nakLord}, bringing {trait}.'**
  String plNakMeaning(Object nakLord, Object trait);

  /// No description provided for @plAiPlace.
  ///
  /// In en, this message translates to:
  /// **'{planet} sits in {sign}, in the {house} house.'**
  String plAiPlace(Object planet, Object sign, Object house);

  /// No description provided for @plAiKarakStrong.
  ///
  /// In en, this message translates to:
  /// **'Its core significations — {karak} — are well supported here.'**
  String plAiKarakStrong(Object karak);

  /// No description provided for @plAiKarakWeak.
  ///
  /// In en, this message translates to:
  /// **'Its core significations — {karak} — may need conscious effort here.'**
  String plAiKarakWeak(Object karak);

  /// No description provided for @plAiExalted.
  ///
  /// In en, this message translates to:
  /// **'{planet} is exalted, giving its very best results.'**
  String plAiExalted(Object planet);

  /// No description provided for @plAiDebilitated.
  ///
  /// In en, this message translates to:
  /// **'{planet} is debilitated and needs support to deliver its results.'**
  String plAiDebilitated(Object planet);

  /// No description provided for @plAiCombust.
  ///
  /// In en, this message translates to:
  /// **'{planet} is combust, so it works less openly under the Sun\'s glare.'**
  String plAiCombust(Object planet);

  /// No description provided for @plAiVargottama.
  ///
  /// In en, this message translates to:
  /// **'{planet} is vargottama — a strong placement repeated in the navamsa.'**
  String plAiVargottama(Object planet);

  /// No description provided for @plAiRetrograde.
  ///
  /// In en, this message translates to:
  /// **'{planet} is retrograde, turning its energy inward and intensifying it.'**
  String plAiRetrograde(Object planet);

  /// No description provided for @plHouse1.
  ///
  /// In en, this message translates to:
  /// **'self, body, personality and vitality'**
  String get plHouse1;

  /// No description provided for @plHouse2.
  ///
  /// In en, this message translates to:
  /// **'wealth, family, speech and food'**
  String get plHouse2;

  /// No description provided for @plHouse3.
  ///
  /// In en, this message translates to:
  /// **'courage, siblings, communication and short travels'**
  String get plHouse3;

  /// No description provided for @plHouse4.
  ///
  /// In en, this message translates to:
  /// **'home, mother, comfort, property and inner peace'**
  String get plHouse4;

  /// No description provided for @plHouse5.
  ///
  /// In en, this message translates to:
  /// **'children, creativity, intelligence, romance and past merits'**
  String get plHouse5;

  /// No description provided for @plHouse6.
  ///
  /// In en, this message translates to:
  /// **'health, enemies, debts, service and daily work'**
  String get plHouse6;

  /// No description provided for @plHouse7.
  ///
  /// In en, this message translates to:
  /// **'marriage, partnerships and business relationships'**
  String get plHouse7;

  /// No description provided for @plHouse8.
  ///
  /// In en, this message translates to:
  /// **'longevity, transformation, secrets and inheritance'**
  String get plHouse8;

  /// No description provided for @plHouse9.
  ///
  /// In en, this message translates to:
  /// **'fortune, dharma, higher learning, guru and father'**
  String get plHouse9;

  /// No description provided for @plHouse10.
  ///
  /// In en, this message translates to:
  /// **'career, status, authority and public karma'**
  String get plHouse10;

  /// No description provided for @plHouse11.
  ///
  /// In en, this message translates to:
  /// **'gains, income, friends, network and fulfilled desires'**
  String get plHouse11;

  /// No description provided for @plHouse12.
  ///
  /// In en, this message translates to:
  /// **'loss, expenses, foreign lands, spirituality and liberation'**
  String get plHouse12;

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

  /// No description provided for @sumVeryStrong.
  ///
  /// In en, this message translates to:
  /// **'Very Strong'**
  String get sumVeryStrong;

  /// No description provided for @sumStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get sumStrong;

  /// No description provided for @sumAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get sumAverage;

  /// No description provided for @sumWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get sumWeak;

  /// No description provided for @sumNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs Attention'**
  String get sumNeedsAttention;

  /// No description provided for @sumFire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get sumFire;

  /// No description provided for @sumEarth.
  ///
  /// In en, this message translates to:
  /// **'Earth'**
  String get sumEarth;

  /// No description provided for @sumAir.
  ///
  /// In en, this message translates to:
  /// **'Air'**
  String get sumAir;

  /// No description provided for @sumWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get sumWater;

  /// No description provided for @sumMovable.
  ///
  /// In en, this message translates to:
  /// **'Movable'**
  String get sumMovable;

  /// No description provided for @sumFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get sumFixed;

  /// No description provided for @sumDual.
  ///
  /// In en, this message translates to:
  /// **'Dual'**
  String get sumDual;

  /// No description provided for @sumDirEast.
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get sumDirEast;

  /// No description provided for @sumDirWest.
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get sumDirWest;

  /// No description provided for @sumDirNorth.
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get sumDirNorth;

  /// No description provided for @sumDirSouth.
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get sumDirSouth;

  /// No description provided for @sumDirNE.
  ///
  /// In en, this message translates to:
  /// **'North-East'**
  String get sumDirNE;

  /// No description provided for @sumDirNW.
  ///
  /// In en, this message translates to:
  /// **'North-West'**
  String get sumDirNW;

  /// No description provided for @sumDirSE.
  ///
  /// In en, this message translates to:
  /// **'South-East'**
  String get sumDirSE;

  /// No description provided for @sumDirSW.
  ///
  /// In en, this message translates to:
  /// **'South-West'**
  String get sumDirSW;

  /// No description provided for @sumSnapshotTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Astrology Snapshot'**
  String get sumSnapshotTitle;

  /// No description provided for @sumMahadasha.
  ///
  /// In en, this message translates to:
  /// **'Mahadasha'**
  String get sumMahadasha;

  /// No description provided for @sumAntardasha.
  ///
  /// In en, this message translates to:
  /// **'Antardasha'**
  String get sumAntardasha;

  /// No description provided for @sumNakshatra.
  ///
  /// In en, this message translates to:
  /// **'Janma Nakshatra'**
  String get sumNakshatra;

  /// No description provided for @sumElement.
  ///
  /// In en, this message translates to:
  /// **'Element'**
  String get sumElement;

  /// No description provided for @sumModality.
  ///
  /// In en, this message translates to:
  /// **'Modality'**
  String get sumModality;

  /// No description provided for @sumLuckyDirection.
  ///
  /// In en, this message translates to:
  /// **'Lucky Direction'**
  String get sumLuckyDirection;

  /// No description provided for @sumHighlights.
  ///
  /// In en, this message translates to:
  /// **'Important Highlights'**
  String get sumHighlights;

  /// No description provided for @sumStrongPlanet.
  ///
  /// In en, this message translates to:
  /// **'Strongest Planet'**
  String get sumStrongPlanet;

  /// No description provided for @sumWeakPlanet.
  ///
  /// In en, this message translates to:
  /// **'Weakest Planet'**
  String get sumWeakPlanet;

  /// No description provided for @sumYogas.
  ///
  /// In en, this message translates to:
  /// **'Yogas'**
  String get sumYogas;

  /// No description provided for @sumDoshas.
  ///
  /// In en, this message translates to:
  /// **'Doshas'**
  String get sumDoshas;

  /// No description provided for @sumRetrograde.
  ///
  /// In en, this message translates to:
  /// **'Retrograde'**
  String get sumRetrograde;

  /// No description provided for @sumCombust.
  ///
  /// In en, this message translates to:
  /// **'Combust'**
  String get sumCombust;

  /// No description provided for @sumExalted.
  ///
  /// In en, this message translates to:
  /// **'Exalted'**
  String get sumExalted;

  /// No description provided for @sumDebilitated.
  ///
  /// In en, this message translates to:
  /// **'Debilitated'**
  String get sumDebilitated;

  /// No description provided for @sumVargottama.
  ///
  /// In en, this message translates to:
  /// **'Vargottama'**
  String get sumVargottama;

  /// No description provided for @sumQuickInsights.
  ///
  /// In en, this message translates to:
  /// **'Quick Insights'**
  String get sumQuickInsights;

  /// No description provided for @sumSpirituality.
  ///
  /// In en, this message translates to:
  /// **'Spirituality'**
  String get sumSpirituality;

  /// No description provided for @sumTimezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get sumTimezone;

  /// No description provided for @sumAyanamsa.
  ///
  /// In en, this message translates to:
  /// **'Ayanamsa'**
  String get sumAyanamsa;

  /// No description provided for @sumCalendarType.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get sumCalendarType;

  /// No description provided for @sumCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get sumCopied;

  /// No description provided for @sumNatureFire.
  ///
  /// In en, this message translates to:
  /// **'You have a bold, energetic and pioneering nature that leads from the front.'**
  String get sumNatureFire;

  /// No description provided for @sumNatureEarth.
  ///
  /// In en, this message translates to:
  /// **'You have a practical, grounded and disciplined nature that builds lasting results.'**
  String get sumNatureEarth;

  /// No description provided for @sumNatureAir.
  ///
  /// In en, this message translates to:
  /// **'You have a curious, communicative and intellectual nature that thrives on new ideas.'**
  String get sumNatureAir;

  /// No description provided for @sumNatureWater.
  ///
  /// In en, this message translates to:
  /// **'You have an intuitive, emotional and empathetic nature with deep inner sensitivity.'**
  String get sumNatureWater;

  /// No description provided for @sumGradePhraseExcellent.
  ///
  /// In en, this message translates to:
  /// **'Strongly supported — favourable results are likely with steady effort.'**
  String get sumGradePhraseExcellent;

  /// No description provided for @sumGradePhraseGood.
  ///
  /// In en, this message translates to:
  /// **'Well supported — generally positive with a little care.'**
  String get sumGradePhraseGood;

  /// No description provided for @sumGradePhraseAverage.
  ///
  /// In en, this message translates to:
  /// **'Mixed support — results depend on effort and timing.'**
  String get sumGradePhraseAverage;

  /// No description provided for @sumGradePhraseWeak.
  ///
  /// In en, this message translates to:
  /// **'Needs attention — patience and remedies help here.'**
  String get sumGradePhraseWeak;

  /// No description provided for @kDefCombust.
  ///
  /// In en, this message translates to:
  /// **'A planet too close to the Sun, so its energy is \'burnt\' and weakened.'**
  String get kDefCombust;

  /// No description provided for @kDefRetrograde.
  ///
  /// In en, this message translates to:
  /// **'A planet that appears to move backwards; its effects turn inward and intensify.'**
  String get kDefRetrograde;

  /// No description provided for @kDefNakshatra.
  ///
  /// In en, this message translates to:
  /// **'One of the 27 lunar mansions that the Moon and planets travel through.'**
  String get kDefNakshatra;

  /// No description provided for @kDefVargottama.
  ///
  /// In en, this message translates to:
  /// **'A planet in the same sign in both the birth chart (D1) and the navamsa (D9) — a mark of strength.'**
  String get kDefVargottama;

  /// No description provided for @kDefOwnSign.
  ///
  /// In en, this message translates to:
  /// **'A planet sitting in a sign it rules, where it feels at home and gives steady results.'**
  String get kDefOwnSign;

  /// No description provided for @kDefExalted.
  ///
  /// In en, this message translates to:
  /// **'A planet in its sign of highest strength, giving its very best results.'**
  String get kDefExalted;

  /// No description provided for @kDefDebilitated.
  ///
  /// In en, this message translates to:
  /// **'A planet in its weakest sign, where it struggles to give results.'**
  String get kDefDebilitated;

  /// No description provided for @kDefMooltrikona.
  ///
  /// In en, this message translates to:
  /// **'A special portion of a planet\'s own sign where it is especially powerful.'**
  String get kDefMooltrikona;

  /// No description provided for @kDefAscendant.
  ///
  /// In en, this message translates to:
  /// **'The sign rising on the eastern horizon at birth — the Lagna, the foundation of the chart.'**
  String get kDefAscendant;

  /// No description provided for @kDefMahadasha.
  ///
  /// In en, this message translates to:
  /// **'The major planetary period that colours a long span of life.'**
  String get kDefMahadasha;

  /// No description provided for @kDefAntardasha.
  ///
  /// In en, this message translates to:
  /// **'A sub-period within a Mahadasha that fine-tunes its results.'**
  String get kDefAntardasha;

  /// No description provided for @kDefPada.
  ///
  /// In en, this message translates to:
  /// **'One of the four quarters of a nakshatra that a planet occupies.'**
  String get kDefPada;

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

  /// No description provided for @aspGivesAspectTo.
  ///
  /// In en, this message translates to:
  /// **'Gives Aspect To'**
  String get aspGivesAspectTo;

  /// No description provided for @aspReceivesAspectFrom.
  ///
  /// In en, this message translates to:
  /// **'Receives Aspect From'**
  String get aspReceivesAspectFrom;

  /// No description provided for @aspInfluences.
  ///
  /// In en, this message translates to:
  /// **'Influences'**
  String get aspInfluences;

  /// No description provided for @aspNoInfluence.
  ///
  /// In en, this message translates to:
  /// **'No Influence'**
  String get aspNoInfluence;

  /// No description provided for @aspNoAspect.
  ///
  /// In en, this message translates to:
  /// **'No Aspect'**
  String get aspNoAspect;

  /// No description provided for @aspPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get aspPresent;

  /// No description provided for @aspAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get aspAbsent;

  /// No description provided for @aspNotPresent.
  ///
  /// In en, this message translates to:
  /// **'Not Present'**
  String get aspNotPresent;

  /// No description provided for @aspSpecialAspect.
  ///
  /// In en, this message translates to:
  /// **'Special Aspect'**
  String get aspSpecialAspect;

  /// No description provided for @aspAspectWord.
  ///
  /// In en, this message translates to:
  /// **'Aspect'**
  String get aspAspectWord;

  /// No description provided for @aspTotalGiven.
  ///
  /// In en, this message translates to:
  /// **'Aspects Given'**
  String get aspTotalGiven;

  /// No description provided for @aspTotalReceived.
  ///
  /// In en, this message translates to:
  /// **'Aspects Received'**
  String get aspTotalReceived;

  /// No description provided for @aspStrongestInfluence.
  ///
  /// In en, this message translates to:
  /// **'Strongest Influence'**
  String get aspStrongestInfluence;

  /// No description provided for @aspMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get aspMedium;

  /// No description provided for @aspAspectPresent.
  ///
  /// In en, this message translates to:
  /// **'Aspect Present'**
  String get aspAspectPresent;

  /// No description provided for @aspReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get aspReason;

  /// No description provided for @aspBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get aspBoth;

  /// No description provided for @aspTargetHouse.
  ///
  /// In en, this message translates to:
  /// **'Target House'**
  String get aspTargetHouse;

  /// No description provided for @aspTargetSign.
  ///
  /// In en, this message translates to:
  /// **'Target Sign'**
  String get aspTargetSign;

  /// No description provided for @aspLagnaReceives.
  ///
  /// In en, this message translates to:
  /// **'Lagna Receives Aspect From'**
  String get aspLagnaReceives;

  /// No description provided for @aspNoAspectFrom.
  ///
  /// In en, this message translates to:
  /// **'No Aspect From'**
  String get aspNoAspectFrom;

  /// No description provided for @aspPlanetToPlanet.
  ///
  /// In en, this message translates to:
  /// **'Planet to Planet'**
  String get aspPlanetToPlanet;

  /// No description provided for @aspSignToSign.
  ///
  /// In en, this message translates to:
  /// **'Sign to Sign'**
  String get aspSignToSign;

  /// No description provided for @aspCombinedAspect.
  ///
  /// In en, this message translates to:
  /// **'Combined Aspect'**
  String get aspCombinedAspect;

  /// No description provided for @aspGrahaAspect.
  ///
  /// In en, this message translates to:
  /// **'Graha Aspect'**
  String get aspGrahaAspect;

  /// No description provided for @aspRashiAspect.
  ///
  /// In en, this message translates to:
  /// **'Rashi Aspect'**
  String get aspRashiAspect;

  /// No description provided for @aspInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Understanding Aspects (Drishti)'**
  String get aspInfoTitle;

  /// No description provided for @aspQGraha.
  ///
  /// In en, this message translates to:
  /// **'What is Graha Drishti?'**
  String get aspQGraha;

  /// No description provided for @aspQRashi.
  ///
  /// In en, this message translates to:
  /// **'What is Rashi Drishti?'**
  String get aspQRashi;

  /// No description provided for @aspQDiff.
  ///
  /// In en, this message translates to:
  /// **'Difference between the two'**
  String get aspQDiff;

  /// No description provided for @aspQPredict.
  ///
  /// In en, this message translates to:
  /// **'How aspects affect prediction'**
  String get aspQPredict;

  /// No description provided for @aspGrahaBody.
  ///
  /// In en, this message translates to:
  /// **'Graha Drishti is the aspect a planet casts from its position. Every planet fully aspects the 7th house/planet from itself (a direct, face-to-face influence). In addition, Mars aspects the 4th and 8th, Jupiter the 5th and 9th, and Saturn the 3rd and 10th. Rahu and Ketu are usually given the 5th, 7th and 9th. A planet\'s aspect colours the planet or house it falls on with its own nature.'**
  String get aspGrahaBody;

  /// No description provided for @aspRashiBody.
  ///
  /// In en, this message translates to:
  /// **'Rashi Drishti is a sign-to-sign aspect from Jaimini astrology, independent of which planets sit there. Movable signs aspect fixed signs (except the adjacent one), fixed signs aspect movable signs (except the adjacent one), and dual signs aspect the other dual signs. It is used mainly in Jaimini prediction and for judging relationships between houses.'**
  String get aspRashiBody;

  /// No description provided for @aspDiffBody.
  ///
  /// In en, this message translates to:
  /// **'Graha Drishti is cast by a planet and depends on where that planet sits. Rashi Drishti belongs to the sign itself and applies to whatever is placed in it. Graha Drishti is directional (planet A sees planet B), while Rashi Drishti is usually mutual between the signs. When both point to the same target, the influence is especially strong.'**
  String get aspDiffBody;

  /// No description provided for @aspPredictBody.
  ///
  /// In en, this message translates to:
  /// **'An aspect shows where a planet extends its influence beyond its own house. A benefic aspect (Jupiter, Venus, well-placed Moon/Mercury) supports and protects the target; a malefic aspect (Saturn, Mars, Sun, Rahu, Ketu) can pressure, delay or challenge it. Reading which planets aspect a house or planet explains why results appear the way they do.'**
  String get aspPredictBody;

  /// No description provided for @aspTraitSun.
  ///
  /// In en, this message translates to:
  /// **'authority, leadership and vitality'**
  String get aspTraitSun;

  /// No description provided for @aspTraitMoon.
  ///
  /// In en, this message translates to:
  /// **'emotional depth, comfort and intuition'**
  String get aspTraitMoon;

  /// No description provided for @aspTraitMars.
  ///
  /// In en, this message translates to:
  /// **'energy, courage and drive'**
  String get aspTraitMars;

  /// No description provided for @aspTraitMercury.
  ///
  /// In en, this message translates to:
  /// **'communication, intellect and adaptability'**
  String get aspTraitMercury;

  /// No description provided for @aspTraitJupiter.
  ///
  /// In en, this message translates to:
  /// **'wisdom, growth and good fortune'**
  String get aspTraitJupiter;

  /// No description provided for @aspTraitVenus.
  ///
  /// In en, this message translates to:
  /// **'love, harmony and comforts'**
  String get aspTraitVenus;

  /// No description provided for @aspTraitSaturn.
  ///
  /// In en, this message translates to:
  /// **'discipline, responsibility and patient, sometimes delayed, success'**
  String get aspTraitSaturn;

  /// No description provided for @aspTraitRahu.
  ///
  /// In en, this message translates to:
  /// **'ambition, intensity and unconventional turns'**
  String get aspTraitRahu;

  /// No description provided for @aspTraitKetu.
  ///
  /// In en, this message translates to:
  /// **'detachment, spirituality and sudden change'**
  String get aspTraitKetu;

  /// No description provided for @aspAiInfluence.
  ///
  /// In en, this message translates to:
  /// **'{planet} is influencing {targets}. This may bring {trait} to the areas represented by these planets.'**
  String aspAiInfluence(Object planet, Object targets, Object trait);

  /// No description provided for @aspAiNone.
  ///
  /// In en, this message translates to:
  /// **'{planet} does not cast a special aspect on any other planet here; its influence works mainly through its own sign and house.'**
  String aspAiNone(Object planet);

  /// No description provided for @grahaDrishti.
  ///
  /// In en, this message translates to:
  /// **'Graha Drishti (Planet Aspects)'**
  String get grahaDrishti;

  /// No description provided for @rashiDrishti.
  ///
  /// In en, this message translates to:
  /// **'Rashi Drishti (Sign Aspects)'**
  String get rashiDrishti;

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

  /// No description provided for @avSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Ashtakavarga Summary'**
  String get avSummaryTitle;

  /// No description provided for @avOverallScore.
  ///
  /// In en, this message translates to:
  /// **'Overall SAV Score'**
  String get avOverallScore;

  /// No description provided for @avOverallRating.
  ///
  /// In en, this message translates to:
  /// **'Overall Rating'**
  String get avOverallRating;

  /// No description provided for @avStrongestSigns.
  ///
  /// In en, this message translates to:
  /// **'Strongest Signs'**
  String get avStrongestSigns;

  /// No description provided for @avWeakestSigns.
  ///
  /// In en, this message translates to:
  /// **'Weakest Signs'**
  String get avWeakestSigns;

  /// No description provided for @avScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get avScore;

  /// No description provided for @avMeaning.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get avMeaning;

  /// No description provided for @avGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get avGrid;

  /// No description provided for @avList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get avList;

  /// No description provided for @avOverallScoreShort.
  ///
  /// In en, this message translates to:
  /// **'Overall Score'**
  String get avOverallScoreShort;

  /// No description provided for @avNatalSignScore.
  ///
  /// In en, this message translates to:
  /// **'Natal Sign Score'**
  String get avNatalSignScore;

  /// No description provided for @avBestSigns.
  ///
  /// In en, this message translates to:
  /// **'Best Signs'**
  String get avBestSigns;

  /// No description provided for @avWeakSigns.
  ///
  /// In en, this message translates to:
  /// **'Weak Signs'**
  String get avWeakSigns;

  /// No description provided for @avAiInterpretation.
  ///
  /// In en, this message translates to:
  /// **'AI Interpretation'**
  String get avAiInterpretation;

  /// No description provided for @avVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get avVeryGood;

  /// No description provided for @avVeryWeak.
  ///
  /// In en, this message translates to:
  /// **'Very Weak'**
  String get avVeryWeak;

  /// No description provided for @avTotalSav.
  ///
  /// In en, this message translates to:
  /// **'Total SAV'**
  String get avTotalSav;

  /// No description provided for @avPlanetContributions.
  ///
  /// In en, this message translates to:
  /// **'Planet Contributions'**
  String get avPlanetContributions;

  /// No description provided for @avFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get avFinance;

  /// No description provided for @avOverallStrength.
  ///
  /// In en, this message translates to:
  /// **'Overall Strength'**
  String get avOverallStrength;

  /// No description provided for @avWhatDoesThisMean.
  ///
  /// In en, this message translates to:
  /// **'What does this mean?'**
  String get avWhatDoesThisMean;

  /// No description provided for @avSimple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get avSimple;

  /// No description provided for @avAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get avAdvanced;

  /// No description provided for @avInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Understanding Ashtakavarga'**
  String get avInfoTitle;

  /// No description provided for @avStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get avStrong;

  /// No description provided for @avModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get avModerate;

  /// No description provided for @avQWhatIsAv.
  ///
  /// In en, this message translates to:
  /// **'What is Ashtakavarga?'**
  String get avQWhatIsAv;

  /// No description provided for @avQWhatIsSav.
  ///
  /// In en, this message translates to:
  /// **'What is SAV?'**
  String get avQWhatIsSav;

  /// No description provided for @avQWhatIsBav.
  ///
  /// In en, this message translates to:
  /// **'What is BAV?'**
  String get avQWhatIsBav;

  /// No description provided for @avQHowToRead.
  ///
  /// In en, this message translates to:
  /// **'How to read these scores'**
  String get avQHowToRead;

  /// No description provided for @avQSavVsBav.
  ///
  /// In en, this message translates to:
  /// **'SAV vs BAV'**
  String get avQSavVsBav;

  /// No description provided for @avABody.
  ///
  /// In en, this message translates to:
  /// **'Ashtakavarga is a points-based strength system in Vedic astrology. Each planet awards benefic points (bindus, also called rekhas) to the twelve signs based on its position. More points in a sign means that area of life gets smoother support during related planetary periods and transits.'**
  String get avABody;

  /// No description provided for @avSavBody.
  ///
  /// In en, this message translates to:
  /// **'SAV (Sarva Ashtakavarga) adds together the points from all seven planets for each sign. It gives a single strength score per sign, so you can quickly see which signs — and the houses they fall in — are best supported in your chart.'**
  String get avSavBody;

  /// No description provided for @avBavBody.
  ///
  /// In en, this message translates to:
  /// **'BAV (Bhinna Ashtakavarga) shows the points from a single planet across the twelve signs. It tells you which signs a specific planet supports most, which matters when that planet\'s dasha or transit is active.'**
  String get avBavBody;

  /// No description provided for @avHowToReadBody.
  ///
  /// In en, this message translates to:
  /// **'Higher numbers are better. For SAV, an average sign scores about 28 points — above 30 is strong and below 25 needs care. For BAV, each sign ranges from 0 to 8, with 4 being average. Favour your strongest signs for important actions, and stay patient and disciplined with your weakest ones.'**
  String get avHowToReadBody;

  /// No description provided for @avSavVsBavBody.
  ///
  /// In en, this message translates to:
  /// **'SAV is the combined total of all planets and shows a sign\'s overall strength. BAV is a single planet\'s contribution and shows which planet supports that sign. Use SAV for the big picture, and BAV to understand which planet drives a sign\'s strength.'**
  String get avSavVsBavBody;

  /// No description provided for @avSummaryInsight.
  ///
  /// In en, this message translates to:
  /// **'Your chart is strongest in {s1}, {s2} and {s3}. These signs give better support during planetary periods and transits. {weak} currently has the least support, so patience and discipline help in matters connected with it.'**
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak);

  /// No description provided for @avBavInsight.
  ///
  /// In en, this message translates to:
  /// **'{planet} performs strongest through {s1} and {s2}. Matters governed by {planet} tend to improve when these signs are activated.'**
  String avBavInsight(Object planet, Object s1, Object s2);

  /// No description provided for @avInsightStrong.
  ///
  /// In en, this message translates to:
  /// **'Your strongest signs are {s1} and {s2} — favour important beginnings when planets transit them.'**
  String avInsightStrong(Object s1, Object s2);

  /// No description provided for @avInsightWeak.
  ///
  /// In en, this message translates to:
  /// **'{s1} has the least support — move carefully and avoid over-commitment in its matters.'**
  String avInsightWeak(Object s1);

  /// No description provided for @avInsightBestPlanet.
  ///
  /// In en, this message translates to:
  /// **'{planet} carries the most points, so its significations are well supported in your life.'**
  String avInsightBestPlanet(Object planet);

  /// No description provided for @avInsightWeakPlanet.
  ///
  /// In en, this message translates to:
  /// **'{planet} carries the fewest points and benefits most from remedies and conscious effort.'**
  String avInsightWeakPlanet(Object planet);

  /// No description provided for @avInsightAverage.
  ///
  /// In en, this message translates to:
  /// **'Signs scoring above your average of {avg} points tend to give smoother, more reliable results.'**
  String avInsightAverage(Object avg);

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

  /// No description provided for @gradeWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get gradeWeak;

  /// No description provided for @careerWord.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get careerWord;

  /// No description provided for @educationWord.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get educationWord;

  /// No description provided for @lifeAreaMarriage.
  ///
  /// In en, this message translates to:
  /// **'Marriage'**
  String get lifeAreaMarriage;

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

  /// No description provided for @forecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get forecast;

  /// No description provided for @fcKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get fcKey;

  /// No description provided for @fcActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get fcActions;

  /// No description provided for @fcCautions.
  ///
  /// In en, this message translates to:
  /// **'Cautions'**
  String get fcCautions;

  /// No description provided for @fc12House.
  ///
  /// In en, this message translates to:
  /// **'12 House'**
  String get fc12House;

  /// No description provided for @fcProbabilities.
  ///
  /// In en, this message translates to:
  /// **'Probabilities'**
  String get fcProbabilities;

  /// No description provided for @fcHousesCaps.
  ///
  /// In en, this message translates to:
  /// **'HOUSES'**
  String get fcHousesCaps;

  /// No description provided for @fcCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get fcCritical;

  /// No description provided for @fcFlags.
  ///
  /// In en, this message translates to:
  /// **'Flags'**
  String get fcFlags;

  /// No description provided for @fcAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get fcAnalysis;

  /// No description provided for @fcConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get fcConfidence;

  /// No description provided for @fcQualityCaps.
  ///
  /// In en, this message translates to:
  /// **'QUALITY'**
  String get fcQualityCaps;

  /// No description provided for @fcIncomeVs.
  ///
  /// In en, this message translates to:
  /// **'Income vs'**
  String get fcIncomeVs;

  /// No description provided for @fcExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get fcExpense;

  /// No description provided for @fcFinance.
  ///
  /// In en, this message translates to:
  /// **'FINANCE'**
  String get fcFinance;

  /// No description provided for @fcNetBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get fcNetBalance;

  /// No description provided for @fcSignature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get fcSignature;

  /// No description provided for @fcBestTimeForIncome.
  ///
  /// In en, this message translates to:
  /// **'Best Time for Income'**
  String get fcBestTimeForIncome;

  /// No description provided for @fcExpenseCaution.
  ///
  /// In en, this message translates to:
  /// **'Expense Caution'**
  String get fcExpenseCaution;

  /// No description provided for @fcIncomeCaps.
  ///
  /// In en, this message translates to:
  /// **'INCOME'**
  String get fcIncomeCaps;

  /// No description provided for @fcExpenseCaps.
  ///
  /// In en, this message translates to:
  /// **'EXPENSE'**
  String get fcExpenseCaps;

  /// No description provided for @fcRelationships.
  ///
  /// In en, this message translates to:
  /// **'Relationships'**
  String get fcRelationships;

  /// No description provided for @fcAreasCaps.
  ///
  /// In en, this message translates to:
  /// **'AREAS'**
  String get fcAreasCaps;

  /// No description provided for @fcBestForMeetings.
  ///
  /// In en, this message translates to:
  /// **'Best For Meetings'**
  String get fcBestForMeetings;

  /// No description provided for @fcOpportunitiesVs.
  ///
  /// In en, this message translates to:
  /// **'Opportunities vs'**
  String get fcOpportunitiesVs;

  /// No description provided for @fcRisks.
  ///
  /// In en, this message translates to:
  /// **'Risks'**
  String get fcRisks;

  /// No description provided for @fcOutlook.
  ///
  /// In en, this message translates to:
  /// **'OUTLOOK'**
  String get fcOutlook;

  /// No description provided for @fcAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get fcAction;

  /// No description provided for @fcProtect.
  ///
  /// In en, this message translates to:
  /// **'Protect'**
  String get fcProtect;

  /// No description provided for @fcOpportunityCaps.
  ///
  /// In en, this message translates to:
  /// **'OPPORTUNITY'**
  String get fcOpportunityCaps;

  /// No description provided for @fcRiskCaps.
  ///
  /// In en, this message translates to:
  /// **'RISK'**
  String get fcRiskCaps;

  /// No description provided for @fcTopOpportunities.
  ///
  /// In en, this message translates to:
  /// **'TOP OPPORTUNITIES'**
  String get fcTopOpportunities;

  /// No description provided for @fcTopRisks.
  ///
  /// In en, this message translates to:
  /// **'TOP RISKS'**
  String get fcTopRisks;

  /// No description provided for @fcTiming.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get fcTiming;

  /// No description provided for @fcWindows.
  ///
  /// In en, this message translates to:
  /// **'Windows'**
  String get fcWindows;

  /// No description provided for @fcSlotsCaps.
  ///
  /// In en, this message translates to:
  /// **'SLOTS'**
  String get fcSlotsCaps;

  /// No description provided for @fcBestWindows.
  ///
  /// In en, this message translates to:
  /// **'BEST WINDOWS'**
  String get fcBestWindows;

  /// No description provided for @fcWorstWindows.
  ///
  /// In en, this message translates to:
  /// **'WORST WINDOWS'**
  String get fcWorstWindows;

  /// No description provided for @fcAvoid.
  ///
  /// In en, this message translates to:
  /// **'Avoid'**
  String get fcAvoid;

  /// No description provided for @fcHouse.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get fcHouse;

  /// No description provided for @fcFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get fcFailed;

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

  /// No description provided for @love.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get love;

  /// No description provided for @spiritual.
  ///
  /// In en, this message translates to:
  /// **'Spiritual'**
  String get spiritual;

  /// No description provided for @analysisConfidence.
  ///
  /// In en, this message translates to:
  /// **'Analysis Confidence'**
  String get analysisConfidence;

  /// No description provided for @areasForGrowth.
  ///
  /// In en, this message translates to:
  /// **'AREAS FOR GROWTH'**
  String get areasForGrowth;

  /// No description provided for @astrologicalRemedies.
  ///
  /// In en, this message translates to:
  /// **'Astrological Remedies'**
  String get astrologicalRemedies;

  /// No description provided for @bestIndustries.
  ///
  /// In en, this message translates to:
  /// **'BEST INDUSTRIES'**
  String get bestIndustries;

  /// No description provided for @burnoutRisk.
  ///
  /// In en, this message translates to:
  /// **'Burnout Risk'**
  String get burnoutRisk;

  /// No description provided for @careerAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Career Analysis'**
  String get careerAnalysis;

  /// No description provided for @careerArchetype.
  ///
  /// In en, this message translates to:
  /// **'Career Archetype'**
  String get careerArchetype;

  /// No description provided for @careerRisks.
  ///
  /// In en, this message translates to:
  /// **'Career Risks'**
  String get careerRisks;

  /// No description provided for @careerStagnation.
  ///
  /// In en, this message translates to:
  /// **'Career Stagnation'**
  String get careerStagnation;

  /// No description provided for @clarity.
  ///
  /// In en, this message translates to:
  /// **'CLARITY'**
  String get clarity;

  /// No description provided for @copyFullReport.
  ///
  /// In en, this message translates to:
  /// **'Copy full report data'**
  String get copyFullReport;

  /// No description provided for @d9Dignity.
  ///
  /// In en, this message translates to:
  /// **'D9 DIGNITY'**
  String get d9Dignity;

  /// No description provided for @divisionalValidation.
  ///
  /// In en, this message translates to:
  /// **'Divisional Validation'**
  String get divisionalValidation;

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

  /// No description provided for @fitScore.
  ///
  /// In en, this message translates to:
  /// **'FIT SCORE'**
  String get fitScore;

  /// No description provided for @freelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get freelance;

  /// No description provided for @growth.
  ///
  /// In en, this message translates to:
  /// **'GROWTH'**
  String get growth;

  /// No description provided for @houseAnalysis.
  ///
  /// In en, this message translates to:
  /// **'House Analysis'**
  String get houseAnalysis;

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

  /// No description provided for @jaiminiKarakas.
  ///
  /// In en, this message translates to:
  /// **'Jaimini Karakas'**
  String get jaiminiKarakas;

  /// No description provided for @lagnaLord.
  ///
  /// In en, this message translates to:
  /// **'Lagna Lord'**
  String get lagnaLord;

  /// No description provided for @launchWindows.
  ///
  /// In en, this message translates to:
  /// **'Launch Windows'**
  String get launchWindows;

  /// No description provided for @lord.
  ///
  /// In en, this message translates to:
  /// **'LORD'**
  String get lord;

  /// No description provided for @lordDignity.
  ///
  /// In en, this message translates to:
  /// **'LORD DIGNITY'**
  String get lordDignity;

  /// No description provided for @lordPlacedIn.
  ///
  /// In en, this message translates to:
  /// **'LORD PLACED IN'**
  String get lordPlacedIn;

  /// No description provided for @overallStrength.
  ///
  /// In en, this message translates to:
  /// **'OVERALL STRENGTH'**
  String get overallStrength;

  /// No description provided for @peakWindows.
  ///
  /// In en, this message translates to:
  /// **'Peak Windows'**
  String get peakWindows;

  /// No description provided for @portfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolio;

  /// No description provided for @practicalSolutions.
  ///
  /// In en, this message translates to:
  /// **'Practical Solutions'**
  String get practicalSolutions;

  /// No description provided for @promotionWindows.
  ///
  /// In en, this message translates to:
  /// **'Promotion Windows'**
  String get promotionWindows;

  /// No description provided for @recognition.
  ///
  /// In en, this message translates to:
  /// **'RECOGNITION'**
  String get recognition;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDED'**
  String get recommended;

  /// No description provided for @riskWindows.
  ///
  /// In en, this message translates to:
  /// **'Risk Windows'**
  String get riskWindows;

  /// No description provided for @satisfaction.
  ///
  /// In en, this message translates to:
  /// **'SATISFACTION'**
  String get satisfaction;

  /// No description provided for @stability.
  ///
  /// In en, this message translates to:
  /// **'STABILITY'**
  String get stability;

  /// No description provided for @teamLeadership.
  ///
  /// In en, this message translates to:
  /// **'Team Leadership'**
  String get teamLeadership;

  /// No description provided for @tenthLord.
  ///
  /// In en, this message translates to:
  /// **'10th Lord'**
  String get tenthLord;

  /// No description provided for @timingWindows.
  ///
  /// In en, this message translates to:
  /// **'Timing Windows'**
  String get timingWindows;

  /// No description provided for @verdict.
  ///
  /// In en, this message translates to:
  /// **'VERDICT'**
  String get verdict;

  /// No description provided for @workStructure.
  ///
  /// In en, this message translates to:
  /// **'Work Structure'**
  String get workStructure;

  /// No description provided for @workplaceConflict.
  ///
  /// In en, this message translates to:
  /// **'Workplace Conflict'**
  String get workplaceConflict;

  /// No description provided for @mitigationLabel.
  ///
  /// In en, this message translates to:
  /// **'MITIGATION'**
  String get mitigationLabel;

  /// No description provided for @reliabilityVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very High reliability'**
  String get reliabilityVeryHigh;

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

  /// No description provided for @reliabilityGuidance.
  ///
  /// In en, this message translates to:
  /// **'Guidance-level reading'**
  String get reliabilityGuidance;

  /// No description provided for @relationshipTitlePrefix.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationshipTitlePrefix;

  /// No description provided for @relationshipTitleSuffix.
  ///
  /// In en, this message translates to:
  /// **'Intelligence'**
  String get relationshipTitleSuffix;

  /// No description provided for @relationshipIntelBannerLabel.
  ///
  /// In en, this message translates to:
  /// **'RELATIONSHIP INTELLIGENCE'**
  String get relationshipIntelBannerLabel;

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

  /// No description provided for @dhokaRiskLabel.
  ///
  /// In en, this message translates to:
  /// **'DHOKA RISK'**
  String get dhokaRiskLabel;

  /// No description provided for @powerLabel.
  ///
  /// In en, this message translates to:
  /// **'Power: {power}'**
  String powerLabel(Object power);

  /// No description provided for @chartProfilesPrefix.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get chartProfilesPrefix;

  /// No description provided for @chartProfilesSuffix.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get chartProfilesSuffix;

  /// No description provided for @lagnaSuffixLabel.
  ///
  /// In en, this message translates to:
  /// **'{sign} Lagna'**
  String lagnaSuffixLabel(Object sign);

  /// No description provided for @miniIntegrityLabel.
  ///
  /// In en, this message translates to:
  /// **'Integrity'**
  String get miniIntegrityLabel;

  /// No description provided for @miniWarmthLabel.
  ///
  /// In en, this message translates to:
  /// **'Warmth'**
  String get miniWarmthLabel;

  /// No description provided for @miniTrustLabel.
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get miniTrustLabel;

  /// No description provided for @miniAssertLabel.
  ///
  /// In en, this message translates to:
  /// **'Assert'**
  String get miniAssertLabel;

  /// No description provided for @akLabel.
  ///
  /// In en, this message translates to:
  /// **'AK: {planet}'**
  String akLabel(Object planet);

  /// No description provided for @pairwisePrefix.
  ///
  /// In en, this message translates to:
  /// **'Pairwise'**
  String get pairwisePrefix;

  /// No description provided for @pairwiseSuffix.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get pairwiseSuffix;

  /// No description provided for @trustPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Trust: {pct}%'**
  String trustPercentLabel(Object pct);

  /// No description provided for @betrayalPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Betrayal: {pct}%'**
  String betrayalPercentLabel(Object pct);

  /// No description provided for @scoreCharacterLabel.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get scoreCharacterLabel;

  /// No description provided for @scoreLoveLabel.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get scoreLoveLabel;

  /// No description provided for @scoreBusinessLabel.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get scoreBusinessLabel;

  /// No description provided for @scoreKarmicLabel.
  ///
  /// In en, this message translates to:
  /// **'Karmic'**
  String get scoreKarmicLabel;

  /// No description provided for @scoreTrustLabel.
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get scoreTrustLabel;

  /// No description provided for @scoreEnmityRiskLabel.
  ///
  /// In en, this message translates to:
  /// **'Enmity Risk'**
  String get scoreEnmityRiskLabel;

  /// No description provided for @dynamicLabel.
  ///
  /// In en, this message translates to:
  /// **'Dynamic: {value}'**
  String dynamicLabel(Object value);

  /// No description provided for @karmicLabel.
  ///
  /// In en, this message translates to:
  /// **'Karmic: {value}'**
  String karmicLabel(Object value);

  /// No description provided for @criticalPrefix.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get criticalPrefix;

  /// No description provided for @criticalSuffix.
  ///
  /// In en, this message translates to:
  /// **'Patterns'**
  String get criticalSuffix;

  /// No description provided for @groupPrefix.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get groupPrefix;

  /// No description provided for @groupSuffix.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get groupSuffix;

  /// No description provided for @sharedPracticesLabel.
  ///
  /// In en, this message translates to:
  /// **'SHARED PRACTICES'**
  String get sharedPracticesLabel;

  /// No description provided for @communicationLabel.
  ///
  /// In en, this message translates to:
  /// **'Communication: {value}'**
  String communicationLabel(Object value);

  /// No description provided for @focusLabel.
  ///
  /// In en, this message translates to:
  /// **'Focus: {value}'**
  String focusLabel(Object value);

  /// No description provided for @individualPrefix.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individualPrefix;

  /// No description provided for @individualSuffix.
  ///
  /// In en, this message translates to:
  /// **'Guidance'**
  String get individualSuffix;

  /// No description provided for @karmicLessonLabel.
  ///
  /// In en, this message translates to:
  /// **'Karmic lesson: {value}'**
  String karmicLessonLabel(Object value);

  /// No description provided for @growthAreasLabel.
  ///
  /// In en, this message translates to:
  /// **'GROWTH AREAS'**
  String get growthAreasLabel;

  /// No description provided for @corePrefix.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get corePrefix;

  /// No description provided for @coreSuffix.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get coreSuffix;

  /// No description provided for @growthOrientedLabel.
  ///
  /// In en, this message translates to:
  /// **'GROWTH-ORIENTED'**
  String get growthOrientedLabel;

  /// No description provided for @groupThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'GROUP THEME'**
  String get groupThemeLabel;

  /// No description provided for @analysisPrefix.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get analysisPrefix;

  /// No description provided for @analysisConfidenceSuffix.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get analysisConfidenceSuffix;

  /// No description provided for @reportCopied.
  ///
  /// In en, this message translates to:
  /// **'Report copied!'**
  String get reportCopied;

  /// No description provided for @copyFullReportData.
  ///
  /// In en, this message translates to:
  /// **'Copy full report data'**
  String get copyFullReportData;

  /// No description provided for @openExternalLabel.
  ///
  /// In en, this message translates to:
  /// **'OPEN'**
  String get openExternalLabel;

  /// No description provided for @copiedOpeningAi.
  ///
  /// In en, this message translates to:
  /// **'Copied! Opening {ai}...'**
  String copiedOpeningAi(Object ai);

  /// No description provided for @milanTitlePrefix.
  ///
  /// In en, this message translates to:
  /// **'Kundli'**
  String get milanTitlePrefix;

  /// No description provided for @ashtakoot.
  ///
  /// In en, this message translates to:
  /// **'Ashtakoot'**
  String get ashtakoot;

  /// No description provided for @compatibilityLabel.
  ///
  /// In en, this message translates to:
  /// **'COMPATIBILITY'**
  String get compatibilityLabel;

  /// No description provided for @unifiedScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'UNIFIED\nSCORE'**
  String get unifiedScoreLabel;

  /// No description provided for @probabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'PROBABILITY'**
  String get probabilityLabel;

  /// No description provided for @ganaLabel.
  ///
  /// In en, this message translates to:
  /// **'Gana: {value}'**
  String ganaLabel(Object value);

  /// No description provided for @gunPrefixLabel.
  ///
  /// In en, this message translates to:
  /// **'8 Gun'**
  String get gunPrefixLabel;

  /// No description provided for @breakdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get breakdownLabel;

  /// No description provided for @mangalLabel.
  ///
  /// In en, this message translates to:
  /// **'Mangal'**
  String get mangalLabel;

  /// No description provided for @severityLabel.
  ///
  /// In en, this message translates to:
  /// **'Sev: {value}'**
  String severityLabel(Object value);

  /// No description provided for @d9Label.
  ///
  /// In en, this message translates to:
  /// **'D-9'**
  String get d9Label;

  /// No description provided for @crossChartLabel.
  ///
  /// In en, this message translates to:
  /// **'Cross-Chart'**
  String get crossChartLabel;

  /// No description provided for @d9CompatibilityLabel.
  ///
  /// In en, this message translates to:
  /// **'D-9 COMPATIBILITY'**
  String get d9CompatibilityLabel;

  /// No description provided for @domainEmotional.
  ///
  /// In en, this message translates to:
  /// **'Emotional'**
  String get domainEmotional;

  /// No description provided for @domainIntellectual.
  ///
  /// In en, this message translates to:
  /// **'Intellectual'**
  String get domainIntellectual;

  /// No description provided for @domainSpiritual.
  ///
  /// In en, this message translates to:
  /// **'Spiritual'**
  String get domainSpiritual;

  /// No description provided for @domainFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get domainFinancial;

  /// No description provided for @domainDomestic.
  ///
  /// In en, this message translates to:
  /// **'Domestic'**
  String get domainDomestic;

  /// No description provided for @domainCommunication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get domainCommunication;

  /// No description provided for @domainSharedDharma.
  ///
  /// In en, this message translates to:
  /// **'Shared Dharma'**
  String get domainSharedDharma;

  /// No description provided for @domainFamilyCreation.
  ///
  /// In en, this message translates to:
  /// **'Family Creation'**
  String get domainFamilyCreation;

  /// No description provided for @domainLabel.
  ///
  /// In en, this message translates to:
  /// **'Domain'**
  String get domainLabel;

  /// No description provided for @compatibilitySuffixLabel.
  ///
  /// In en, this message translates to:
  /// **'Compatibility'**
  String get compatibilitySuffixLabel;

  /// No description provided for @marriageLabel.
  ///
  /// In en, this message translates to:
  /// **'Marriage'**
  String get marriageLabel;

  /// No description provided for @timingLabel.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get timingLabel;

  /// No description provided for @jointMarriageWindowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Joint Marriage Windows'**
  String get jointMarriageWindowsTitle;

  /// No description provided for @engagementWindowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Engagement Windows'**
  String get engagementWindowsTitle;

  /// No description provided for @recommendedLabel.
  ///
  /// In en, this message translates to:
  /// **'Recommended: {value}'**
  String recommendedLabel(Object value);

  /// No description provided for @risksLabel.
  ///
  /// In en, this message translates to:
  /// **'Risks'**
  String get risksLabel;

  /// No description provided for @finalLabel.
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get finalLabel;

  /// No description provided for @verdictLabel.
  ///
  /// In en, this message translates to:
  /// **'Verdict'**
  String get verdictLabel;

  /// No description provided for @marriageVerdictLabel.
  ///
  /// In en, this message translates to:
  /// **'MARRIAGE VERDICT'**
  String get marriageVerdictLabel;

  /// No description provided for @discussReportWithAI.
  ///
  /// In en, this message translates to:
  /// **'DISCUSS THIS REPORT WITH AI'**
  String get discussReportWithAI;

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

  /// No description provided for @participantsLabel.
  ///
  /// In en, this message translates to:
  /// **'PARTICIPANTS'**
  String get participantsLabel;

  /// No description provided for @reportDataCopied.
  ///
  /// In en, this message translates to:
  /// **'Report data copied!'**
  String get reportDataCopied;

  /// No description provided for @copiedForAi.
  ///
  /// In en, this message translates to:
  /// **'Copied for {label}!'**
  String copiedForAi(Object label);

  /// No description provided for @wealthScoresLabel.
  ///
  /// In en, this message translates to:
  /// **'WEALTH SCORES'**
  String get wealthScoresLabel;

  /// No description provided for @wealthStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'WEALTH\nSTRENGTH'**
  String get wealthStrengthLabel;

  /// No description provided for @accumulationLabel.
  ///
  /// In en, this message translates to:
  /// **'ACCUMU-\nLATION'**
  String get accumulationLabel;

  /// No description provided for @incomeFlowLabel.
  ///
  /// In en, this message translates to:
  /// **'INCOME\nFLOW'**
  String get incomeFlowLabel;

  /// No description provided for @sustainLabel.
  ///
  /// In en, this message translates to:
  /// **'SUSTAIN'**
  String get sustainLabel;

  /// No description provided for @multiStreamLabel.
  ///
  /// In en, this message translates to:
  /// **'MULTI-STREAM'**
  String get multiStreamLabel;

  /// No description provided for @retentionLabel.
  ///
  /// In en, this message translates to:
  /// **'RETENTION'**
  String get retentionLabel;

  /// No description provided for @wealthLabel.
  ///
  /// In en, this message translates to:
  /// **'Wealth'**
  String get wealthLabel;

  /// No description provided for @karakasLabel.
  ///
  /// In en, this message translates to:
  /// **'Karakas'**
  String get karakasLabel;

  /// No description provided for @wealthYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Wealth Yogas'**
  String get wealthYogasTitle;

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

  /// No description provided for @incomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeLabel;

  /// No description provided for @sourcesLabel.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get sourcesLabel;

  /// No description provided for @investmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get investmentLabel;

  /// No description provided for @mixLabel.
  ///
  /// In en, this message translates to:
  /// **'Mix'**
  String get mixLabel;

  /// No description provided for @yearlyTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Yearly Trend'**
  String get yearlyTrendTitle;

  /// No description provided for @wealthGrowthTitle.
  ///
  /// In en, this message translates to:
  /// **'Wealth Growth'**
  String get wealthGrowthTitle;

  /// No description provided for @cashPressureTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash Pressure'**
  String get cashPressureTitle;

  /// No description provided for @moneyPersonalityTitle.
  ///
  /// In en, this message translates to:
  /// **'Money Personality'**
  String get moneyPersonalityTitle;

  /// No description provided for @wealthTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'WEALTH TYPE'**
  String get wealthTypeLabel;

  /// No description provided for @riskAppetiteLabel.
  ///
  /// In en, this message translates to:
  /// **'RISK APPETITE'**
  String get riskAppetiteLabel;

  /// No description provided for @investmentStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'INVESTMENT STYLE'**
  String get investmentStyleLabel;

  /// No description provided for @moneyPersonalityLabel.
  ///
  /// In en, this message translates to:
  /// **'MONEY PERSONALITY'**
  String get moneyPersonalityLabel;

  /// No description provided for @spendingLabel.
  ///
  /// In en, this message translates to:
  /// **'SPENDING'**
  String get spendingLabel;

  /// No description provided for @debtProbLabel.
  ///
  /// In en, this message translates to:
  /// **'DEBT PROB %'**
  String get debtProbLabel;

  /// No description provided for @inheritanceProbLabel.
  ///
  /// In en, this message translates to:
  /// **'INHERITANCE %'**
  String get inheritanceProbLabel;

  /// No description provided for @suddenGainsProbLabel.
  ///
  /// In en, this message translates to:
  /// **'SUDDEN GAINS %'**
  String get suddenGainsProbLabel;

  /// No description provided for @spouseBoostLabel.
  ///
  /// In en, this message translates to:
  /// **'SPOUSE BOOST %'**
  String get spouseBoostLabel;

  /// No description provided for @successProbabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Success probability: {pct}%'**
  String successProbabilityLabel(Object pct);

  /// No description provided for @lifetimeWealthClassLabel.
  ///
  /// In en, this message translates to:
  /// **'LIFETIME WEALTH CLASS'**
  String get lifetimeWealthClassLabel;

  /// No description provided for @primaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Primary: {value}'**
  String primaryLabel(Object value);

  /// No description provided for @peakAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Peak: {value}'**
  String peakAgeLabel(Object value);

  /// No description provided for @drivenByLabel.
  ///
  /// In en, this message translates to:
  /// **'Driven by {value}'**
  String drivenByLabel(Object value);

  /// No description provided for @coreBlockerLabel.
  ///
  /// In en, this message translates to:
  /// **'CORE BLOCKER'**
  String get coreBlockerLabel;

  /// No description provided for @debtScoresLabel.
  ///
  /// In en, this message translates to:
  /// **'DEBT SCORES'**
  String get debtScoresLabel;

  /// No description provided for @currentDebtLoadLabel.
  ///
  /// In en, this message translates to:
  /// **'CURRENT\nDEBT LOAD'**
  String get currentDebtLoadLabel;

  /// No description provided for @recoveryCapacityLabel.
  ///
  /// In en, this message translates to:
  /// **'RECOVERY\nCAPACITY'**
  String get recoveryCapacityLabel;

  /// No description provided for @intensityLabel.
  ///
  /// In en, this message translates to:
  /// **'INTENSITY'**
  String get intensityLabel;

  /// No description provided for @defaultRiskLabel.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT RISK'**
  String get defaultRiskLabel;

  /// No description provided for @debtProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Debt Profile'**
  String get debtProfileTitle;

  /// No description provided for @karmaLabel.
  ///
  /// In en, this message translates to:
  /// **'KARMA'**
  String get karmaLabel;

  /// No description provided for @personalityLabel.
  ///
  /// In en, this message translates to:
  /// **'PERSONALITY'**
  String get personalityLabel;

  /// No description provided for @phaseLabel.
  ///
  /// In en, this message translates to:
  /// **'PHASE'**
  String get phaseLabel;

  /// No description provided for @primaryCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY CATEGORY'**
  String get primaryCategoryLabel;

  /// No description provided for @debtLabel.
  ///
  /// In en, this message translates to:
  /// **'Debt'**
  String get debtLabel;

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

  /// No description provided for @categoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesLabel;

  /// No description provided for @yearlyDebtTitle.
  ///
  /// In en, this message translates to:
  /// **'Yearly Debt'**
  String get yearlyDebtTitle;

  /// No description provided for @repaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Repayment'**
  String get repaymentTitle;

  /// No description provided for @dangerPeriodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Danger Periods'**
  String get dangerPeriodsTitle;

  /// No description provided for @defaultPctLabel.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT %'**
  String get defaultPctLabel;

  /// No description provided for @bankruptcyPctLabel.
  ///
  /// In en, this message translates to:
  /// **'BANKRUPTCY %'**
  String get bankruptcyPctLabel;

  /// No description provided for @chronicPctLabel.
  ///
  /// In en, this message translates to:
  /// **'CHRONIC %'**
  String get chronicPctLabel;

  /// No description provided for @resilienceLabel.
  ///
  /// In en, this message translates to:
  /// **'RESILIENCE'**
  String get resilienceLabel;

  /// No description provided for @recoveryTimelineLabel.
  ///
  /// In en, this message translates to:
  /// **'Recovery: {pct}% · Timeline: {years}yrs'**
  String recoveryTimelineLabel(Object pct, Object years);

  /// No description provided for @debtFreeWindowLabel.
  ///
  /// In en, this message translates to:
  /// **'DEBT-FREE WINDOW'**
  String get debtFreeWindowLabel;

  /// No description provided for @yearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year {year}'**
  String yearLabel(Object year);

  /// No description provided for @dashaLabel.
  ///
  /// In en, this message translates to:
  /// **'Dasha: {value}'**
  String dashaLabel(Object value);

  /// No description provided for @marriageScoresLabel.
  ///
  /// In en, this message translates to:
  /// **'MARRIAGE SCORES'**
  String get marriageScoresLabel;

  /// No description provided for @overallMarriageLabel.
  ///
  /// In en, this message translates to:
  /// **'OVERALL\nMARRIAGE'**
  String get overallMarriageLabel;

  /// No description provided for @maritalHarmonyLabel.
  ///
  /// In en, this message translates to:
  /// **'MARITAL\nHARMONY'**
  String get maritalHarmonyLabel;

  /// No description provided for @domesticStabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'DOMESTIC\nSTABILITY'**
  String get domesticStabilityLabel;

  /// No description provided for @longevityLabel.
  ///
  /// In en, this message translates to:
  /// **'LONGEVITY'**
  String get longevityLabel;

  /// No description provided for @satisfactionLabel.
  ///
  /// In en, this message translates to:
  /// **'SATISFACTION'**
  String get satisfactionLabel;

  /// No description provided for @clarityLabel.
  ///
  /// In en, this message translates to:
  /// **'CLARITY'**
  String get clarityLabel;

  /// No description provided for @darakarakaLabel.
  ///
  /// In en, this message translates to:
  /// **'Darakaraka'**
  String get darakarakaLabel;

  /// No description provided for @spouseKarakaLabel.
  ///
  /// In en, this message translates to:
  /// **'Spouse Karaka'**
  String get spouseKarakaLabel;

  /// No description provided for @darakarakaDkLabel.
  ///
  /// In en, this message translates to:
  /// **'DARAKARAKA (DK)'**
  String get darakarakaDkLabel;

  /// No description provided for @seventhLabel.
  ///
  /// In en, this message translates to:
  /// **'7th'**
  String get seventhLabel;

  /// No description provided for @lordLabel.
  ///
  /// In en, this message translates to:
  /// **'LORD'**
  String get lordLabel;

  /// No description provided for @lordInLabel.
  ///
  /// In en, this message translates to:
  /// **'LORD IN'**
  String get lordInLabel;

  /// No description provided for @lordDignityLabel.
  ///
  /// In en, this message translates to:
  /// **'LORD DIGNITY'**
  String get lordDignityLabel;

  /// No description provided for @emptyLabel.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get emptyLabel;

  /// No description provided for @spouseLabel.
  ///
  /// In en, this message translates to:
  /// **'Spouse'**
  String get spouseLabel;

  /// No description provided for @spouseTraitsLabel.
  ///
  /// In en, this message translates to:
  /// **'SPOUSE TRAITS'**
  String get spouseTraitsLabel;

  /// No description provided for @likelyProfessionsLabel.
  ///
  /// In en, this message translates to:
  /// **'LIKELY PROFESSIONS'**
  String get likelyProfessionsLabel;

  /// No description provided for @harmonyPhysicalLabel.
  ///
  /// In en, this message translates to:
  /// **'Physical'**
  String get harmonyPhysicalLabel;

  /// No description provided for @sharedValuesLabel.
  ///
  /// In en, this message translates to:
  /// **'Shared Values'**
  String get sharedValuesLabel;

  /// No description provided for @conflictResolutionLabel.
  ///
  /// In en, this message translates to:
  /// **'Conflict Resolution'**
  String get conflictResolutionLabel;

  /// No description provided for @harmonyLabel.
  ///
  /// In en, this message translates to:
  /// **'Harmony'**
  String get harmonyLabel;

  /// No description provided for @radarLabel.
  ///
  /// In en, this message translates to:
  /// **'Radar'**
  String get radarLabel;

  /// No description provided for @mangalDoshLabel.
  ///
  /// In en, this message translates to:
  /// **'MANGAL DOSH'**
  String get mangalDoshLabel;

  /// No description provided for @severityColonLabel.
  ///
  /// In en, this message translates to:
  /// **'Severity: {value}'**
  String severityColonLabel(Object value);

  /// No description provided for @cancellationColonLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancellation: {value}'**
  String cancellationColonLabel(Object value);

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

  /// No description provided for @inLawRelationsLabel.
  ///
  /// In en, this message translates to:
  /// **'IN-LAW RELATIONS'**
  String get inLawRelationsLabel;

  /// No description provided for @familyHarmonyLabel.
  ///
  /// In en, this message translates to:
  /// **'FAMILY HARMONY'**
  String get familyHarmonyLabel;

  /// No description provided for @fertilityLabel.
  ///
  /// In en, this message translates to:
  /// **'FERTILITY'**
  String get fertilityLabel;

  /// No description provided for @homeOwnershipLabel.
  ///
  /// In en, this message translates to:
  /// **'HOME OWNERSHIP'**
  String get homeOwnershipLabel;

  /// No description provided for @divorceRiskLabel.
  ///
  /// In en, this message translates to:
  /// **'DIVORCE RISK'**
  String get divorceRiskLabel;

  /// No description provided for @infidelityLabel.
  ///
  /// In en, this message translates to:
  /// **'INFIDELITY'**
  String get infidelityLabel;

  /// No description provided for @conflictLabel.
  ///
  /// In en, this message translates to:
  /// **'CONFLICT'**
  String get conflictLabel;

  /// No description provided for @distanceLabel.
  ///
  /// In en, this message translates to:
  /// **'DISTANCE'**
  String get distanceLabel;

  /// No description provided for @seekInPartnerLabel.
  ///
  /// In en, this message translates to:
  /// **'SEEK IN PARTNER'**
  String get seekInPartnerLabel;

  /// No description provided for @avoidInPartnerLabel.
  ///
  /// In en, this message translates to:
  /// **'AVOID IN PARTNER'**
  String get avoidInPartnerLabel;

  /// No description provided for @realizationLabel.
  ///
  /// In en, this message translates to:
  /// **'Realization: {pct}%'**
  String realizationLabel(Object pct);

  /// No description provided for @navamsaLabel.
  ///
  /// In en, this message translates to:
  /// **'Navamsa'**
  String get navamsaLabel;

  /// No description provided for @characterScoresLabel.
  ///
  /// In en, this message translates to:
  /// **'CHARACTER SCORES'**
  String get characterScoresLabel;

  /// No description provided for @characterStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'CHARACTER\nSTRENGTH'**
  String get characterStrengthLabel;

  /// No description provided for @characterIntegrityLabel.
  ///
  /// In en, this message translates to:
  /// **'INTEGRITY'**
  String get characterIntegrityLabel;

  /// No description provided for @awarenessLabel.
  ///
  /// In en, this message translates to:
  /// **'AWARENESS'**
  String get awarenessLabel;

  /// No description provided for @stabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'STABILITY'**
  String get stabilityLabel;

  /// No description provided for @ethicsLabel.
  ///
  /// In en, this message translates to:
  /// **'ETHICS'**
  String get ethicsLabel;

  /// No description provided for @surfacePersonalityTitle.
  ///
  /// In en, this message translates to:
  /// **'Surface Personality'**
  String get surfacePersonalityTitle;

  /// No description provided for @constitutionLabel.
  ///
  /// In en, this message translates to:
  /// **'CONSTITUTION'**
  String get constitutionLabel;

  /// No description provided for @nakshatraLabel.
  ///
  /// In en, this message translates to:
  /// **'NAKSHATRA'**
  String get nakshatraLabel;

  /// No description provided for @deityLabel.
  ///
  /// In en, this message translates to:
  /// **'DEITY'**
  String get deityLabel;

  /// No description provided for @moonManasTitle.
  ///
  /// In en, this message translates to:
  /// **'Moon Manas'**
  String get moonManasTitle;

  /// No description provided for @warmthLabel.
  ///
  /// In en, this message translates to:
  /// **'WARMTH'**
  String get warmthLabel;

  /// No description provided for @empathyLabel.
  ///
  /// In en, this message translates to:
  /// **'EMPATHY'**
  String get empathyLabel;

  /// No description provided for @loyaltyLabel.
  ///
  /// In en, this message translates to:
  /// **'LOYALTY'**
  String get loyaltyLabel;

  /// No description provided for @boundariesLabel.
  ///
  /// In en, this message translates to:
  /// **'BOUNDARIES'**
  String get boundariesLabel;

  /// No description provided for @dharmaLabel.
  ///
  /// In en, this message translates to:
  /// **'DHARMA'**
  String get dharmaLabel;

  /// No description provided for @truthLabel.
  ///
  /// In en, this message translates to:
  /// **'TRUTH'**
  String get truthLabel;

  /// No description provided for @compassionLabel.
  ///
  /// In en, this message translates to:
  /// **'COMPASSION'**
  String get compassionLabel;

  /// No description provided for @generosityLabel.
  ///
  /// In en, this message translates to:
  /// **'GENEROSITY'**
  String get generosityLabel;

  /// No description provided for @signatureVirtuesLabel.
  ///
  /// In en, this message translates to:
  /// **'SIGNATURE VIRTUES'**
  String get signatureVirtuesLabel;

  /// No description provided for @naturalTalentsLabel.
  ///
  /// In en, this message translates to:
  /// **'NATURAL TALENTS'**
  String get naturalTalentsLabel;

  /// No description provided for @shadowPatternsLabel.
  ///
  /// In en, this message translates to:
  /// **'SHADOW PATTERNS'**
  String get shadowPatternsLabel;

  /// No description provided for @characterYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Character Yogas'**
  String get characterYogasTitle;

  /// No description provided for @testsLabel.
  ///
  /// In en, this message translates to:
  /// **'TESTS'**
  String get testsLabel;

  /// No description provided for @giftsLabel.
  ///
  /// In en, this message translates to:
  /// **'GIFTS'**
  String get giftsLabel;

  /// No description provided for @selfAwareEiLabel.
  ///
  /// In en, this message translates to:
  /// **'SELF-AWARE EI'**
  String get selfAwareEiLabel;

  /// No description provided for @selfRegulateLabel.
  ///
  /// In en, this message translates to:
  /// **'SELF-REGULATE'**
  String get selfRegulateLabel;

  /// No description provided for @empathyEiLabel.
  ///
  /// In en, this message translates to:
  /// **'EMPATHY EI'**
  String get empathyEiLabel;

  /// No description provided for @socialSkillsLabel.
  ///
  /// In en, this message translates to:
  /// **'SOCIAL SKILLS'**
  String get socialSkillsLabel;

  /// No description provided for @atmakarakaLabel.
  ///
  /// In en, this message translates to:
  /// **'Atmakaraka'**
  String get atmakarakaLabel;

  /// No description provided for @soulSignatureLabel.
  ///
  /// In en, this message translates to:
  /// **'Soul Signature'**
  String get soulSignatureLabel;

  /// No description provided for @atmakarakaAllCapsLabel.
  ///
  /// In en, this message translates to:
  /// **'ATMAKARAKA'**
  String get atmakarakaAllCapsLabel;

  /// No description provided for @gunaLabel.
  ///
  /// In en, this message translates to:
  /// **'Guna'**
  String get gunaLabel;

  /// No description provided for @dominantColonLabel.
  ///
  /// In en, this message translates to:
  /// **'Dominant: {value}'**
  String dominantColonLabel(Object value);

  /// No description provided for @coreGiftLabel.
  ///
  /// In en, this message translates to:
  /// **'CORE GIFT'**
  String get coreGiftLabel;

  /// No description provided for @coreThemeAllCapsLabel.
  ///
  /// In en, this message translates to:
  /// **'CORE THEME'**
  String get coreThemeAllCapsLabel;

  /// No description provided for @pastLifeScoresLabel.
  ///
  /// In en, this message translates to:
  /// **'PAST LIFE SCORES'**
  String get pastLifeScoresLabel;

  /// No description provided for @signatureStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'SIGNATURE\nSTRENGTH'**
  String get signatureStrengthLabel;

  /// No description provided for @carryForwardLabel.
  ///
  /// In en, this message translates to:
  /// **'CARRY-\nFORWARD'**
  String get carryForwardLabel;

  /// No description provided for @masteryPreservedLabel.
  ///
  /// In en, this message translates to:
  /// **'MASTERY\nPRESERVED'**
  String get masteryPreservedLabel;

  /// No description provided for @unfinishedLabel.
  ///
  /// In en, this message translates to:
  /// **'UNFINISHED'**
  String get unfinishedLabel;

  /// No description provided for @karmicDebtLabel.
  ///
  /// In en, this message translates to:
  /// **'KARMIC DEBT'**
  String get karmicDebtLabel;

  /// No description provided for @pastMasteryLabel.
  ///
  /// In en, this message translates to:
  /// **'Past Mastery'**
  String get pastMasteryLabel;

  /// No description provided for @futureGrowthLabel.
  ///
  /// In en, this message translates to:
  /// **'Future Growth'**
  String get futureGrowthLabel;

  /// No description provided for @ketuWhatYouMasteredLabel.
  ///
  /// In en, this message translates to:
  /// **'KETU · WHAT YOU MASTERED'**
  String get ketuWhatYouMasteredLabel;

  /// No description provided for @rahuWhatPullsForwardLabel.
  ///
  /// In en, this message translates to:
  /// **'RAHU · WHAT PULLS YOU FORWARD'**
  String get rahuWhatPullsForwardLabel;

  /// No description provided for @pastLifeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Past Life Profile'**
  String get pastLifeProfileTitle;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'THEME'**
  String get themeLabel;

  /// No description provided for @professionLabel.
  ///
  /// In en, this message translates to:
  /// **'PROFESSION'**
  String get professionLabel;

  /// No description provided for @socialStandingLabel.
  ///
  /// In en, this message translates to:
  /// **'SOCIAL STANDING'**
  String get socialStandingLabel;

  /// No description provided for @regionLabel.
  ///
  /// In en, this message translates to:
  /// **'REGION'**
  String get regionLabel;

  /// No description provided for @spiritualLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'SPIRITUAL LEVEL'**
  String get spiritualLevelLabel;

  /// No description provided for @wealthLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'WEALTH LEVEL'**
  String get wealthLevelLabel;

  /// No description provided for @familyRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'FAMILY ROLE'**
  String get familyRoleLabel;

  /// No description provided for @skillsCarriedForwardLabel.
  ///
  /// In en, this message translates to:
  /// **'SKILLS CARRIED FORWARD'**
  String get skillsCarriedForwardLabel;

  /// No description provided for @naturalAttractionsLabel.
  ///
  /// In en, this message translates to:
  /// **'NATURAL ATTRACTIONS'**
  String get naturalAttractionsLabel;

  /// No description provided for @unexplainedFearsLabel.
  ///
  /// In en, this message translates to:
  /// **'UNEXPLAINED FEARS'**
  String get unexplainedFearsLabel;

  /// No description provided for @magneticPullsLabel.
  ///
  /// In en, this message translates to:
  /// **'MAGNETIC PULLS'**
  String get magneticPullsLabel;

  /// No description provided for @relationshipLabel.
  ///
  /// In en, this message translates to:
  /// **'RELATIONSHIP'**
  String get relationshipLabel;

  /// No description provided for @financialLabel.
  ///
  /// In en, this message translates to:
  /// **'FINANCIAL'**
  String get financialLabel;

  /// No description provided for @serviceLabel.
  ///
  /// In en, this message translates to:
  /// **'SERVICE'**
  String get serviceLabel;

  /// No description provided for @dharmicLabel.
  ///
  /// In en, this message translates to:
  /// **'DHARMIC'**
  String get dharmicLabel;

  /// No description provided for @onRelationsLabel.
  ///
  /// In en, this message translates to:
  /// **'ON RELATIONS'**
  String get onRelationsLabel;

  /// No description provided for @onCareerLabel.
  ///
  /// In en, this message translates to:
  /// **'ON CAREER'**
  String get onCareerLabel;

  /// No description provided for @onHealthLabel.
  ///
  /// In en, this message translates to:
  /// **'ON HEALTH'**
  String get onHealthLabel;

  /// No description provided for @onSpiritualLabel.
  ///
  /// In en, this message translates to:
  /// **'ON SPIRITUAL'**
  String get onSpiritualLabel;

  /// No description provided for @karmicResolutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Karmic Resolution'**
  String get karmicResolutionTitle;

  /// No description provided for @primaryPathLabel.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY PATH'**
  String get primaryPathLabel;

  /// No description provided for @secondaryPathLabel.
  ///
  /// In en, this message translates to:
  /// **'SECONDARY PATH'**
  String get secondaryPathLabel;

  /// No description provided for @clearingProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'CLEARING PROGRESS'**
  String get clearingProgressLabel;

  /// No description provided for @remainingWorkLabel.
  ///
  /// In en, this message translates to:
  /// **'REMAINING WORK'**
  String get remainingWorkLabel;

  /// No description provided for @debtTimelineLabel.
  ///
  /// In en, this message translates to:
  /// **'DEBT TIMELINE'**
  String get debtTimelineLabel;

  /// No description provided for @memoryAccessLabel.
  ///
  /// In en, this message translates to:
  /// **'MEMORY ACCESS'**
  String get memoryAccessLabel;

  /// No description provided for @dreamVisitsLabel.
  ///
  /// In en, this message translates to:
  /// **'DREAM VISITS'**
  String get dreamVisitsLabel;

  /// No description provided for @dejaVuLabel.
  ///
  /// In en, this message translates to:
  /// **'DEJA VU'**
  String get dejaVuLabel;

  /// No description provided for @regressionFitLabel.
  ///
  /// In en, this message translates to:
  /// **'REGRESSION FIT'**
  String get regressionFitLabel;

  /// No description provided for @pastLifeActivationTitle.
  ///
  /// In en, this message translates to:
  /// **'Past Life Activation'**
  String get pastLifeActivationTitle;

  /// No description provided for @maturityStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Maturity: {score} · Status: {status}'**
  String maturityStatusLabel(Object score, Object status);

  /// No description provided for @shadowColonLabel.
  ///
  /// In en, this message translates to:
  /// **'Shadow: {value}'**
  String shadowColonLabel(Object value);

  /// No description provided for @lifePathScoresLabel.
  ///
  /// In en, this message translates to:
  /// **'LIFE PATH SCORES'**
  String get lifePathScoresLabel;

  /// No description provided for @dharmaClarityLabel.
  ///
  /// In en, this message translates to:
  /// **'DHARMA\nCLARITY'**
  String get dharmaClarityLabel;

  /// No description provided for @fortuneBaselineLabel.
  ///
  /// In en, this message translates to:
  /// **'FORTUNE\nBASELINE'**
  String get fortuneBaselineLabel;

  /// No description provided for @lifePathCoherenceLabel.
  ///
  /// In en, this message translates to:
  /// **'LIFE PATH\nCOHERENCE'**
  String get lifePathCoherenceLabel;

  /// No description provided for @karmaAllCapsLabel.
  ///
  /// In en, this message translates to:
  /// **'KARMA'**
  String get karmaAllCapsLabel;

  /// No description provided for @spiritualAllCapsLabel.
  ///
  /// In en, this message translates to:
  /// **'SPIRITUAL'**
  String get spiritualAllCapsLabel;

  /// No description provided for @fameLabel.
  ///
  /// In en, this message translates to:
  /// **'FAME'**
  String get fameLabel;

  /// No description provided for @lifeLabel.
  ///
  /// In en, this message translates to:
  /// **'Life'**
  String get lifeLabel;

  /// No description provided for @archetypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Archetype'**
  String get archetypeLabel;

  /// No description provided for @soulContractTitle.
  ///
  /// In en, this message translates to:
  /// **'Soul Contract'**
  String get soulContractTitle;

  /// No description provided for @akFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'AK FOCUS'**
  String get akFocusLabel;

  /// No description provided for @soulPurposeLabel.
  ///
  /// In en, this message translates to:
  /// **'SOUL PURPOSE'**
  String get soulPurposeLabel;

  /// No description provided for @lifeChapterLabel.
  ///
  /// In en, this message translates to:
  /// **'LIFE CHAPTER'**
  String get lifeChapterLabel;

  /// No description provided for @primaryDomainLabel.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY DOMAIN'**
  String get primaryDomainLabel;

  /// No description provided for @leadershipLabel.
  ///
  /// In en, this message translates to:
  /// **'LEADERSHIP'**
  String get leadershipLabel;

  /// No description provided for @wisdomTeachLabel.
  ///
  /// In en, this message translates to:
  /// **'WISDOM/TEACH'**
  String get wisdomTeachLabel;

  /// No description provided for @healingLabel.
  ///
  /// In en, this message translates to:
  /// **'HEALING'**
  String get healingLabel;

  /// No description provided for @fortuneYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Fortune Yogas'**
  String get fortuneYogasTitle;

  /// No description provided for @luckBlocksLabel.
  ///
  /// In en, this message translates to:
  /// **'LUCK BLOCKS'**
  String get luckBlocksLabel;

  /// No description provided for @fortuneBoostersLabel.
  ///
  /// In en, this message translates to:
  /// **'FORTUNE BOOSTERS'**
  String get fortuneBoostersLabel;

  /// No description provided for @fortuneTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Fortune Trend'**
  String get fortuneTrendTitle;

  /// No description provided for @goldenWindowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Golden Windows ★'**
  String get goldenWindowsTitle;

  /// No description provided for @transformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Transformation'**
  String get transformationTitle;

  /// No description provided for @lifeMilestonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Life Milestones'**
  String get lifeMilestonesTitle;

  /// No description provided for @destinyVsLabel.
  ///
  /// In en, this message translates to:
  /// **'Destiny vs'**
  String get destinyVsLabel;

  /// No description provided for @freeWillLabel.
  ///
  /// In en, this message translates to:
  /// **'Free Will'**
  String get freeWillLabel;

  /// No description provided for @destinyAllCapsLabel.
  ///
  /// In en, this message translates to:
  /// **'DESTINY'**
  String get destinyAllCapsLabel;

  /// No description provided for @freeWillAllCapsLabel.
  ///
  /// In en, this message translates to:
  /// **'FREE WILL'**
  String get freeWillAllCapsLabel;

  /// No description provided for @karmicLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Karmic Lessons'**
  String get karmicLessonsTitle;

  /// No description provided for @rahuGrowthLabel.
  ///
  /// In en, this message translates to:
  /// **'RAHU GROWTH'**
  String get rahuGrowthLabel;

  /// No description provided for @ketuSurrenderLabel.
  ///
  /// In en, this message translates to:
  /// **'KETU SURRENDER'**
  String get ketuSurrenderLabel;

  /// No description provided for @saturnLessonLabel.
  ///
  /// In en, this message translates to:
  /// **'SATURN LESSON'**
  String get saturnLessonLabel;

  /// No description provided for @lifeDifficultyLabel.
  ///
  /// In en, this message translates to:
  /// **'LIFE DIFFICULTY'**
  String get lifeDifficultyLabel;

  /// No description provided for @soulCameToExperienceLabel.
  ///
  /// In en, this message translates to:
  /// **'SOUL CAME TO EXPERIENCE'**
  String get soulCameToExperienceLabel;

  /// No description provided for @blessingsLabel.
  ///
  /// In en, this message translates to:
  /// **'BLESSINGS'**
  String get blessingsLabel;

  /// No description provided for @fulfillmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Fulfillment: {pct}%'**
  String fulfillmentLabel(Object pct);

  /// No description provided for @legalScoresLabel.
  ///
  /// In en, this message translates to:
  /// **'LEGAL SCORES'**
  String get legalScoresLabel;

  /// No description provided for @legalVulnerabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'LEGAL\nVULNERABILITY'**
  String get legalVulnerabilityLabel;

  /// No description provided for @victoryPotentialLabel.
  ///
  /// In en, this message translates to:
  /// **'VICTORY\nPOTENTIAL'**
  String get victoryPotentialLabel;

  /// No description provided for @resolutionLabel.
  ///
  /// In en, this message translates to:
  /// **'RESOLUTION'**
  String get resolutionLabel;

  /// No description provided for @legalProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Profile'**
  String get legalProfileTitle;

  /// No description provided for @karmaTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'KARMA TYPE'**
  String get karmaTypeLabel;

  /// No description provided for @conflictStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'CONFLICT STYLE'**
  String get conflictStyleLabel;

  /// No description provided for @strategyLabel.
  ///
  /// In en, this message translates to:
  /// **'STRATEGY'**
  String get strategyLabel;

  /// No description provided for @caseDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'CASE DURATION'**
  String get caseDurationLabel;

  /// No description provided for @currentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'CURRENT STATUS'**
  String get currentStatusLabel;

  /// No description provided for @legalLabel.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legalLabel;

  /// No description provided for @legalYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Yogas'**
  String get legalYogasTitle;

  /// No description provided for @disputePressureLabel.
  ///
  /// In en, this message translates to:
  /// **'DISPUTE PRESSURE'**
  String get disputePressureLabel;

  /// No description provided for @legalProtectionLabel.
  ///
  /// In en, this message translates to:
  /// **'LEGAL PROTECTION'**
  String get legalProtectionLabel;

  /// No description provided for @victoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Victory'**
  String get victoryLabel;

  /// No description provided for @asPlaintiffLabel.
  ///
  /// In en, this message translates to:
  /// **'AS PLAINTIFF'**
  String get asPlaintiffLabel;

  /// No description provided for @asDefendantLabel.
  ///
  /// In en, this message translates to:
  /// **'AS DEFENDANT'**
  String get asDefendantLabel;

  /// No description provided for @winProbabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'WIN PROBABILITY'**
  String get winProbabilityLabel;

  /// No description provided for @disputeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dispute'**
  String get disputeLabel;

  /// No description provided for @legalStressTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Stress'**
  String get legalStressTitle;

  /// No description provided for @visibleEnemiesLabel.
  ///
  /// In en, this message translates to:
  /// **'VISIBLE ENEMIES'**
  String get visibleEnemiesLabel;

  /// No description provided for @hiddenEnemiesLabel.
  ///
  /// In en, this message translates to:
  /// **'HIDDEN ENEMIES'**
  String get hiddenEnemiesLabel;

  /// No description provided for @criminalRiskLabel.
  ///
  /// In en, this message translates to:
  /// **'CRIMINAL RISK'**
  String get criminalRiskLabel;

  /// No description provided for @falseAccusationLabel.
  ///
  /// In en, this message translates to:
  /// **'FALSE ACCUSATION'**
  String get falseAccusationLabel;

  /// No description provided for @contractKarmaTitle.
  ///
  /// In en, this message translates to:
  /// **'Contract Karma'**
  String get contractKarmaTitle;

  /// No description provided for @documentationLabel.
  ///
  /// In en, this message translates to:
  /// **'DOCUMENTATION'**
  String get documentationLabel;

  /// No description provided for @finePrintAwareLabel.
  ///
  /// In en, this message translates to:
  /// **'FINE PRINT AWARE'**
  String get finePrintAwareLabel;

  /// No description provided for @negotiationSkillLabel.
  ///
  /// In en, this message translates to:
  /// **'NEGOTIATION SKILL'**
  String get negotiationSkillLabel;

  /// No description provided for @signatureCautionLabel.
  ///
  /// In en, this message translates to:
  /// **'SIGNATURE CAUTION'**
  String get signatureCautionLabel;

  /// No description provided for @resilienceColonLabel.
  ///
  /// In en, this message translates to:
  /// **'Resilience: {value}/100'**
  String resilienceColonLabel(Object value);

  /// No description provided for @healthScoresLabel.
  ///
  /// In en, this message translates to:
  /// **'HEALTH SCORES'**
  String get healthScoresLabel;

  /// No description provided for @vitalityLabel.
  ///
  /// In en, this message translates to:
  /// **'VITALITY'**
  String get vitalityLabel;

  /// No description provided for @immunityLabel.
  ///
  /// In en, this message translates to:
  /// **'IMMUNITY'**
  String get immunityLabel;

  /// No description provided for @recoveryLabel.
  ///
  /// In en, this message translates to:
  /// **'RECOVERY'**
  String get recoveryLabel;

  /// No description provided for @mentalLabel.
  ///
  /// In en, this message translates to:
  /// **'MENTAL'**
  String get mentalLabel;

  /// No description provided for @stressTolLabel.
  ///
  /// In en, this message translates to:
  /// **'STRESS TOL'**
  String get stressTolLabel;

  /// No description provided for @ayurvedicLabel.
  ///
  /// In en, this message translates to:
  /// **'Ayurvedic'**
  String get ayurvedicLabel;

  /// No description provided for @constitutionTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Constitution'**
  String get constitutionTitleLabel;

  /// No description provided for @secondaryColonLabel.
  ///
  /// In en, this message translates to:
  /// **'Secondary: {value}'**
  String secondaryColonLabel(Object value);

  /// No description provided for @bodyLabel.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get bodyLabel;

  /// No description provided for @systemMapLabel.
  ///
  /// In en, this message translates to:
  /// **'System Map'**
  String get systemMapLabel;

  /// No description provided for @healthYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Yogas'**
  String get healthYogasTitle;

  /// No description provided for @diseasePressureLabel.
  ///
  /// In en, this message translates to:
  /// **'DISEASE PRESSURE'**
  String get diseasePressureLabel;

  /// No description provided for @protectiveLabel.
  ///
  /// In en, this message translates to:
  /// **'PROTECTIVE'**
  String get protectiveLabel;

  /// No description provided for @bodyZoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Body Zone'**
  String get bodyZoneLabel;

  /// No description provided for @vulnerabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Vulnerability'**
  String get vulnerabilityLabel;

  /// No description provided for @diseaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Disease'**
  String get diseaseLabel;

  /// No description provided for @susceptibilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Susceptibility'**
  String get susceptibilityLabel;

  /// No description provided for @healthTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Trend'**
  String get healthTrendTitle;

  /// No description provided for @recoveryWindowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery Windows'**
  String get recoveryWindowsTitle;

  /// No description provided for @cautionPeriodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Caution Periods'**
  String get cautionPeriodsTitle;

  /// No description provided for @burnoutRiskLabel.
  ///
  /// In en, this message translates to:
  /// **'BURNOUT RISK'**
  String get burnoutRiskLabel;

  /// No description provided for @addictionVulnLabel.
  ///
  /// In en, this message translates to:
  /// **'ADDICTION VULN'**
  String get addictionVulnLabel;

  /// No description provided for @workLifeBalLabel.
  ///
  /// In en, this message translates to:
  /// **'WORK-LIFE BAL'**
  String get workLifeBalLabel;

  /// No description provided for @lifestyleFactorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle Factors'**
  String get lifestyleFactorsTitle;

  /// No description provided for @sleepDisciplineLabel.
  ///
  /// In en, this message translates to:
  /// **'SLEEP DISCIPLINE'**
  String get sleepDisciplineLabel;

  /// No description provided for @dietDisciplineLabel.
  ///
  /// In en, this message translates to:
  /// **'DIET DISCIPLINE'**
  String get dietDisciplineLabel;

  /// No description provided for @exerciseNeedLabel.
  ///
  /// In en, this message translates to:
  /// **'EXERCISE NEED'**
  String get exerciseNeedLabel;

  /// No description provided for @sunlightNeedLabel.
  ///
  /// In en, this message translates to:
  /// **'SUNLIGHT NEED'**
  String get sunlightNeedLabel;

  /// No description provided for @socialTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'SOCIAL TYPE'**
  String get socialTypeLabel;

  /// No description provided for @healingSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'HEALING SPEED'**
  String get healingSpeedLabel;

  /// No description provided for @mentalScoresLabel.
  ///
  /// In en, this message translates to:
  /// **'MENTAL SCORES'**
  String get mentalScoresLabel;

  /// No description provided for @mentalStabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'MENTAL\nSTABILITY'**
  String get mentalStabilityLabel;

  /// No description provided for @emotionalBaselineLabel.
  ///
  /// In en, this message translates to:
  /// **'EMOTIONAL\nBASELINE'**
  String get emotionalBaselineLabel;

  /// No description provided for @anxietyLabel.
  ///
  /// In en, this message translates to:
  /// **'ANXIETY'**
  String get anxietyLabel;

  /// No description provided for @depressionLabel.
  ///
  /// In en, this message translates to:
  /// **'DEPRESSION'**
  String get depressionLabel;

  /// No description provided for @regulationLabel.
  ///
  /// In en, this message translates to:
  /// **'REGULATION'**
  String get regulationLabel;

  /// No description provided for @mentalProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Mental Profile'**
  String get mentalProfileTitle;

  /// No description provided for @stressDriverLabel.
  ///
  /// In en, this message translates to:
  /// **'STRESS DRIVER'**
  String get stressDriverLabel;

  /// No description provided for @stabilityAnchorLabel.
  ///
  /// In en, this message translates to:
  /// **'STABILITY ANCHOR'**
  String get stabilityAnchorLabel;

  /// No description provided for @attachmentStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'ATTACHMENT STYLE'**
  String get attachmentStyleLabel;

  /// No description provided for @burnoutStageLabel.
  ///
  /// In en, this message translates to:
  /// **'BURNOUT STAGE'**
  String get burnoutStageLabel;

  /// No description provided for @mentalTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Mental'**
  String get mentalTitleLabel;

  /// No description provided for @mentalYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Mental Yogas'**
  String get mentalYogasTitle;

  /// No description provided for @stressPressureLabel.
  ///
  /// In en, this message translates to:
  /// **'STRESS PRESSURE'**
  String get stressPressureLabel;

  /// No description provided for @stressResponseLabel.
  ///
  /// In en, this message translates to:
  /// **'STRESS RESPONSE'**
  String get stressResponseLabel;

  /// No description provided for @anxietyTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Anxiety'**
  String get anxietyTitleLabel;

  /// No description provided for @typesLabel.
  ///
  /// In en, this message translates to:
  /// **'Types'**
  String get typesLabel;

  /// No description provided for @therapyLabel.
  ///
  /// In en, this message translates to:
  /// **'Therapy'**
  String get therapyLabel;

  /// No description provided for @modalityFitLabel.
  ///
  /// In en, this message translates to:
  /// **'Modality Fit'**
  String get modalityFitLabel;

  /// No description provided for @wellnessTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Wellness Trend'**
  String get wellnessTrendTitle;

  /// No description provided for @healthyCopingLabel.
  ///
  /// In en, this message translates to:
  /// **'HEALTHY COPING'**
  String get healthyCopingLabel;

  /// No description provided for @unhealthyRisksLabel.
  ///
  /// In en, this message translates to:
  /// **'UNHEALTHY RISKS'**
  String get unhealthyRisksLabel;

  /// No description provided for @recommendedAlternativesLabel.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDED ALTERNATIVES'**
  String get recommendedAlternativesLabel;

  /// No description provided for @sleepQualityLabel.
  ///
  /// In en, this message translates to:
  /// **'SLEEP QUALITY'**
  String get sleepQualityLabel;

  /// No description provided for @socialSupportLabel.
  ///
  /// In en, this message translates to:
  /// **'SOCIAL SUPPORT'**
  String get socialSupportLabel;

  /// No description provided for @burnoutVulnLabel.
  ///
  /// In en, this message translates to:
  /// **'BURNOUT VULN'**
  String get burnoutVulnLabel;

  /// No description provided for @selfAwarenessLabel.
  ///
  /// In en, this message translates to:
  /// **'SELF-AWARENESS'**
  String get selfAwarenessLabel;

  /// No description provided for @authTagline.
  ///
  /// In en, this message translates to:
  /// **'Nakshatralogy for Astrologers'**
  String get authTagline;

  /// No description provided for @googleSignInNoToken.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In: No ID token received. Ensure GOOGLE_WEB_CLIENT_ID is set and google-services.json is configured.'**
  String get googleSignInNoToken;

  /// No description provided for @googleSignInError.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In error: {error}'**
  String googleSignInError(String error);

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @signInWithBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Sign in with biometrics'**
  String get signInWithBiometrics;

  /// No description provided for @forgotPasswordInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email to\nreceive a reset link.'**
  String get forgotPasswordInstructions;

  /// No description provided for @resendLink.
  ///
  /// In en, this message translates to:
  /// **'Resend Link'**
  String get resendLink;

  /// No description provided for @callJoinedChannel.
  ///
  /// In en, this message translates to:
  /// **'Joined channel {channel}'**
  String callJoinedChannel(String channel);

  /// No description provided for @callUserConnected.
  ///
  /// In en, this message translates to:
  /// **'User connected! Call active'**
  String get callUserConnected;

  /// No description provided for @callConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {reason}. Check Agora credentials.'**
  String callConnectionFailed(String reason);

  /// No description provided for @callAgoraError.
  ///
  /// In en, this message translates to:
  /// **'Agora error: {details}'**
  String callAgoraError(String details);

  /// No description provided for @callAgoraInitFailed.
  ///
  /// In en, this message translates to:
  /// **'Agora init failed: {error}'**
  String callAgoraInitFailed(String error);

  /// No description provided for @callWaitingForVideo.
  ///
  /// In en, this message translates to:
  /// **'Waiting for video...'**
  String get callWaitingForVideo;

  /// No description provided for @callVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Video Call'**
  String get callVideoCall;

  /// No description provided for @callVoiceCall.
  ///
  /// In en, this message translates to:
  /// **'Voice Call'**
  String get callVoiceCall;

  /// No description provided for @callRateEarning.
  ///
  /// In en, this message translates to:
  /// **'{rate}/min • Earning: {earning}'**
  String callRateEarning(String rate, String earning);

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh'**
  String get pullToRefresh;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String minutesAgo(int minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String hoursAgo(int hours);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String daysAgo(int days);

  /// No description provided for @noChartsCreateFirst.
  ///
  /// In en, this message translates to:
  /// **'No charts. Create a birth chart first.'**
  String get noChartsCreateFirst;

  /// No description provided for @selectBirthChartToAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Select a birth chart to analyze'**
  String get selectBirthChartToAnalyze;

  /// No description provided for @unknownName.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownName;

  /// No description provided for @selectRangeCharts.
  ///
  /// In en, this message translates to:
  /// **'Select 2-{max} Charts'**
  String selectRangeCharts(int max);

  /// No description provided for @selectExactCharts.
  ///
  /// In en, this message translates to:
  /// **'Select {max} Charts'**
  String selectExactCharts(int max);

  /// No description provided for @runningAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Running {label} analysis...'**
  String runningAnalysis(String label);

  /// No description provided for @pickKarmicCharts.
  ///
  /// In en, this message translates to:
  /// **'Pick 2 to {max} charts to analyze karmic links'**
  String pickKarmicCharts(int max);

  /// No description provided for @pickMaleFemaleChart.
  ///
  /// In en, this message translates to:
  /// **'Pick a Male and Female chart'**
  String get pickMaleFemaleChart;

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed'**
  String get analysisFailed;

  /// No description provided for @errorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorWithDetails(String error);

  /// No description provided for @personNumber.
  ///
  /// In en, this message translates to:
  /// **'Person {n}'**
  String personNumber(int n);

  /// No description provided for @analyzeNCharts.
  ///
  /// In en, this message translates to:
  /// **'Analyze {count} Charts'**
  String analyzeNCharts(int count);

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
  String bhavaSignLord(String sign, String lord);

  /// No description provided for @bhavaSavValue.
  ///
  /// In en, this message translates to:
  /// **'SAV: {value}'**
  String bhavaSavValue(String value);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @gocharTransitScoresTitle.
  ///
  /// In en, this message translates to:
  /// **'Gochar (Transit Scores) — {date}'**
  String gocharTransitScoresTitle(String date);

  /// No description provided for @gocharNativeMoon.
  ///
  /// In en, this message translates to:
  /// **'Native Moon: {moonSign}'**
  String gocharNativeMoon(String moonSign);

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

  /// No description provided for @aspectsGrahaDrishtiTitle.
  ///
  /// In en, this message translates to:
  /// **'Graha Drishti (Planet Aspects)'**
  String get aspectsGrahaDrishtiTitle;

  /// No description provided for @aspectsGrahaDrishtiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who aspects whom (%)'**
  String get aspectsGrahaDrishtiSubtitle;

  /// No description provided for @aspectsLagnaReceivedTitle.
  ///
  /// In en, this message translates to:
  /// **'Lagna Aspects Received'**
  String get aspectsLagnaReceivedTitle;

  /// No description provided for @aspectsRashiDrishtiTitle.
  ///
  /// In en, this message translates to:
  /// **'Rashi Drishti (Sign Aspects)'**
  String get aspectsRashiDrishtiTitle;

  /// No description provided for @ashtakavargaSavTitle.
  ///
  /// In en, this message translates to:
  /// **'Sarva Ashtakavarga (SAV)'**
  String get ashtakavargaSavTitle;

  /// No description provided for @ashtakavargaSavSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Total: {total} rekhas (average sign = {average})'**
  String ashtakavargaSavSubtitle(String total, String average);

  /// No description provided for @ashtakavargaPlanetBavTitle.
  ///
  /// In en, this message translates to:
  /// **'{planet} — BAV'**
  String ashtakavargaPlanetBavTitle(String planet);

  /// No description provided for @ashtakavargaPlanetBavSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Total: {total} rekhas • At natal sign: {natalScore}'**
  String ashtakavargaPlanetBavSubtitle(String total, String natalScore);

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

  /// No description provided for @todaysEarning.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S EARNINGS'**
  String get todaysEarning;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'WALLET'**
  String get walletBalance;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'RATING'**
  String get rating;

  /// No description provided for @totalSessions.
  ///
  /// In en, this message translates to:
  /// **'SESSIONS'**
  String get totalSessions;

  /// No description provided for @consultations.
  ///
  /// In en, this message translates to:
  /// **'CONSULTATIONS'**
  String get consultations;

  /// No description provided for @response.
  ///
  /// In en, this message translates to:
  /// **'RESPONSE'**
  String get response;

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

  /// No description provided for @goLive.
  ///
  /// In en, this message translates to:
  /// **'Go Live'**
  String get goLive;

  /// No description provided for @streamTitle.
  ///
  /// In en, this message translates to:
  /// **'Stream Title'**
  String get streamTitle;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get description;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @rashiPredictions.
  ///
  /// In en, this message translates to:
  /// **'Rashi Predictions'**
  String get rashiPredictions;

  /// No description provided for @todaysGochar.
  ///
  /// In en, this message translates to:
  /// **'Today\'s gochar for all 12 signs — tap to drill in'**
  String get todaysGochar;

  /// No description provided for @recentRequests.
  ///
  /// In en, this message translates to:
  /// **'Recent Requests'**
  String get recentRequests;

  /// No description provided for @noRecentRequests.
  ///
  /// In en, this message translates to:
  /// **'No recent requests'**
  String get noRecentRequests;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'VIEW ALL'**
  String get viewAll;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @declined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get declined;

  /// No description provided for @clientCharts.
  ///
  /// In en, this message translates to:
  /// **'Client Charts'**
  String get clientCharts;

  /// No description provided for @newChart.
  ///
  /// In en, this message translates to:
  /// **'New Chart'**
  String get newChart;

  /// No description provided for @noChartsCreated.
  ///
  /// In en, this message translates to:
  /// **'No charts created yet'**
  String get noChartsCreated;

  /// No description provided for @newClientChart.
  ///
  /// In en, this message translates to:
  /// **'New Client Chart'**
  String get newClientChart;

  /// No description provided for @clientBirthDetails.
  ///
  /// In en, this message translates to:
  /// **'Client Birth Details'**
  String get clientBirthDetails;

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

  /// No description provided for @clientChartCreated.
  ///
  /// In en, this message translates to:
  /// **'Client chart created!'**
  String get clientChartCreated;

  /// No description provided for @viewKundli.
  ///
  /// In en, this message translates to:
  /// **'View Kundli'**
  String get viewKundli;

  /// No description provided for @deleteChart.
  ///
  /// In en, this message translates to:
  /// **'Delete Chart?'**
  String get deleteChart;

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

  /// No description provided for @kundli.
  ///
  /// In en, this message translates to:
  /// **'Kundli'**
  String get kundli;

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

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'THIS MONTH'**
  String get thisMonth;

  /// No description provided for @statement.
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get statement;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits;

  /// No description provided for @withdrawals.
  ///
  /// In en, this message translates to:
  /// **'Withdrawals'**
  String get withdrawals;

  /// No description provided for @bonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get bonus;

  /// No description provided for @refunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get refunds;

  /// No description provided for @requestWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Request Withdrawal'**
  String get requestWithdrawal;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @upiId.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get upiId;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer;

  /// No description provided for @accountHolderName.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get accountHolderName;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @ifscCode.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code'**
  String get ifscCode;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get noTransactions;

  /// No description provided for @withdrawalHistory.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal History'**
  String get withdrawalHistory;

  /// No description provided for @typeGuidance.
  ///
  /// In en, this message translates to:
  /// **'Type your guidance...'**
  String get typeGuidance;

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
  /// **'Are you sure you want to end this session?'**
  String get endChatConfirm;

  /// No description provided for @activeNow.
  ///
  /// In en, this message translates to:
  /// **'Active now'**
  String get activeNow;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// No description provided for @clientKundli.
  ///
  /// In en, this message translates to:
  /// **'CLIENT KUNDLI'**
  String get clientKundli;

  /// No description provided for @earned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get earned;

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

  /// No description provided for @endStream.
  ///
  /// In en, this message translates to:
  /// **'End Stream'**
  String get endStream;

  /// No description provided for @endStreamConfirm.
  ///
  /// In en, this message translates to:
  /// **'End live stream?'**
  String get endStreamConfirm;

  /// No description provided for @goLiveBtn.
  ///
  /// In en, this message translates to:
  /// **'Go Live'**
  String get goLiveBtn;

  /// No description provided for @viewers.
  ///
  /// In en, this message translates to:
  /// **'Viewers'**
  String get viewers;

  /// No description provided for @peak.
  ///
  /// In en, this message translates to:
  /// **'Peak'**
  String get peak;

  /// No description provided for @gifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get gifts;

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

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

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

  /// No description provided for @kycSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit KYC'**
  String get kycSubmit;

  /// No description provided for @kycPending.
  ///
  /// In en, this message translates to:
  /// **'KYC Under Review'**
  String get kycPending;

  /// No description provided for @kycRejected.
  ///
  /// In en, this message translates to:
  /// **'KYC Rejected'**
  String get kycRejected;

  String get notifications;
  String get biometricLogin;
  String get editProfile;

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

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

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

  /// No description provided for @deptReports.
  ///
  /// In en, this message translates to:
  /// **'Dept Reports'**
  String get deptReports;

  /// No description provided for @specialistAnalysesDesc.
  ///
  /// In en, this message translates to:
  /// **'15 specialist analyses — Career, Wealth, Health, Love & more'**
  String get specialistAnalysesDesc;

  /// No description provided for @matchTwoChartsDesc.
  ///
  /// In en, this message translates to:
  /// **'Match two charts — Ashtakoot, Navamsa, Transit timing & more'**
  String get matchTwoChartsDesc;

  /// No description provided for @todaysForecast.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Forecast'**
  String get todaysForecast;

  /// No description provided for @dailyProbability.
  ///
  /// In en, this message translates to:
  /// **'Daily probability forecast for any chart'**
  String get dailyProbability;

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

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @endSession.
  ///
  /// In en, this message translates to:
  /// **'End Session'**
  String get endSession;

  /// No description provided for @enterChat.
  ///
  /// In en, this message translates to:
  /// **'Enter Chat'**
  String get enterChat;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @requestDeclined.
  ///
  /// In en, this message translates to:
  /// **'Request declined'**
  String get requestDeclined;

  /// No description provided for @noRequests.
  ///
  /// In en, this message translates to:
  /// **'No requests'**
  String get noRequests;

  /// No description provided for @tapViewChat.
  ///
  /// In en, this message translates to:
  /// **'Tap to view chat history'**
  String get tapViewChat;

  /// No description provided for @tapViewCall.
  ///
  /// In en, this message translates to:
  /// **'Tap to view call details'**
  String get tapViewCall;

  /// No description provided for @consultation.
  ///
  /// In en, this message translates to:
  /// **'consultation'**
  String get consultation;

  /// No description provided for @charged.
  ///
  /// In en, this message translates to:
  /// **'Charged'**
  String get charged;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @callDetails.
  ///
  /// In en, this message translates to:
  /// **'Call Details'**
  String get callDetails;

  /// No description provided for @yourEarning.
  ///
  /// In en, this message translates to:
  /// **'Your Earning'**
  String get yourEarning;

  /// No description provided for @totalCharged.
  ///
  /// In en, this message translates to:
  /// **'Total Charged'**
  String get totalCharged;

  String get unlocked;
  String get lessThanOneMin;

  String get activeDoshas;
  String get activeYogas;
  String get allDoshas;
  String get areasToNurture;
  String get basedOnPlanetStrengths;
  String get basedOnTransits;
  String get basis;
  String get beneficAspects;
  String get bestWindows;
  String get bhakootAxis;
  String get cancellation;
  String get cancellationFactors;
  String get cancellations;
  String get challengingPeriods;
  String get characterOverview;
  String get combinedFertility;
  String get combust;
  String get confidence;
  String get contact;
  String get copy;
  String get currentPlanetPositions;
  String get d7Saptamsa;
  String get dashaSync;
  String get daughter;
  String get debilitated;
  String get detailedSummary;
  String get discussWithAI;
  String get dominantPlanet;
  String get effect;
  String get exalted;
  String get factors;
  String get favorablePeriodAdvice;
  String get favorablePeriods;
  String get genderExplanation;
  String get genderTendency;
  String get grantPermissions;
  String get health;
  String get herMoon;
  String get hisMoon;
  String get house;
  String get inFifth;
  String get ketuContacts;
  String get key;
  String get keyHouses;
  String get keyInsights;
  String get keyPlanets;
  String get kundliMilan;
  String get lifeAreaPredictions;
  String get maleficAspects;
  String get manifestation;
  String get milan;
  String get mitigation;
  String get moonSignCompat;
  String get nakshatraCompat;
  String get navigation;
  String get nextFavorableWindow;
  String get noCharts;
  String get noClassicalYogas;
  String get noYogasActive;
  String get notesSaved;
  String get numberExplanation;
  String get occupants;
  String get overallVerdict;
  String get overlappingWindows;
  String get past;
  String get pastLifeIndication;
  String get planet;
  String get planetPositions;
  String get potentialStrengths;
  String get primaryArchetype;
  String get probableNumber;
  String get rahuContacts;
  String get rashi;
  String get recommendations;
  String get relationshipGuidance;
  String get remedies;
  String get retrograde;
  String get ruledBy;
  String get running;
  String get scoreComponents;
  String get selectChartsForMilan;
  String get selectMultiCharts;
  String get selectTwoCharts;
  String get sign;
  String get son;
  String get soulCareerAlign;
  String get startKundliMilan;
  String get startSession;
  String get strength;
  String get strengths;
  String get todaysTransitChart;
  String get topActiveDoshas;
  String get topOpportunities;
  String get topRisks;
  String get totalChallengePenalty;
  String get totalDoshaPenalty;
  String get transitMarriageWindows;
  String get value;
  String get vargottama;
  String get venusContacts;
  String get weaknesses;
  String get worstWindows;
  String get yogaAnalysis;
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
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      if (locale.scriptCode == 'Latn') return AppLocalizationsHiLatn();
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
