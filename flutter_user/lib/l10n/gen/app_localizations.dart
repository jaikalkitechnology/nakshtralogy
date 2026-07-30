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

  /// No description provided for @riSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Relationship Intelligence Report'**
  String get riSubtitle;

  /// No description provided for @riTitle.
  ///
  /// In en, this message translates to:
  /// **'Relationship Intel'**
  String get riTitle;

  /// No description provided for @riSnapshotHeader.
  ///
  /// In en, this message translates to:
  /// **'Group Snapshot'**
  String get riSnapshotHeader;

  /// No description provided for @riGaugeCohesion.
  ///
  /// In en, this message translates to:
  /// **'Group Cohesion'**
  String get riGaugeCohesion;

  /// No description provided for @riGaugeTrust.
  ///
  /// In en, this message translates to:
  /// **'Trust Climate'**
  String get riGaugeTrust;

  /// No description provided for @riGaugeProductivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get riGaugeProductivity;

  /// No description provided for @riGaugeCreativity.
  ///
  /// In en, this message translates to:
  /// **'Creativity'**
  String get riGaugeCreativity;

  /// No description provided for @riChipNoAlerts.
  ///
  /// In en, this message translates to:
  /// **'No critical alerts'**
  String get riChipNoAlerts;

  /// No description provided for @riChipStrongCohesion.
  ///
  /// In en, this message translates to:
  /// **'Strong group cohesion'**
  String get riChipStrongCohesion;

  /// No description provided for @riChipHighTrust.
  ///
  /// In en, this message translates to:
  /// **'High trust climate'**
  String get riChipHighTrust;

  /// No description provided for @riChipNoHiddenEnemy.
  ///
  /// In en, this message translates to:
  /// **'No hidden-enemy signal'**
  String get riChipNoHiddenEnemy;

  /// No description provided for @riChipHealthyGroup.
  ///
  /// In en, this message translates to:
  /// **'Healthy group overall'**
  String get riChipHealthyGroup;

  /// No description provided for @riProfilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Chart Profiles'**
  String get riProfilesTitle;

  /// No description provided for @riProfilesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} people in this group'**
  String riProfilesSubtitle(Object count);

  /// No description provided for @riLagnaSuffix.
  ///
  /// In en, this message translates to:
  /// **'Lagna'**
  String get riLagnaSuffix;

  /// No description provided for @riIntegrity.
  ///
  /// In en, this message translates to:
  /// **'Integrity'**
  String get riIntegrity;

  /// No description provided for @riWarmth.
  ///
  /// In en, this message translates to:
  /// **'Warmth'**
  String get riWarmth;

  /// No description provided for @riTrustworthiness.
  ///
  /// In en, this message translates to:
  /// **'Trustworthiness'**
  String get riTrustworthiness;

  /// No description provided for @riAssertiveness.
  ///
  /// In en, this message translates to:
  /// **'Assertiveness'**
  String get riAssertiveness;

  /// No description provided for @riGroupDynamicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Dynamics Overview'**
  String get riGroupDynamicsTitle;

  /// No description provided for @riMostSupportive.
  ///
  /// In en, this message translates to:
  /// **'Most Supportive'**
  String get riMostSupportive;

  /// No description provided for @riMostChallenged.
  ///
  /// In en, this message translates to:
  /// **'Most Challenged'**
  String get riMostChallenged;

  /// No description provided for @riHiddenEnemyAlert.
  ///
  /// In en, this message translates to:
  /// **'Hidden-Enemy Signal Detected'**
  String get riHiddenEnemyAlert;

  /// No description provided for @riBestWorstTitle.
  ///
  /// In en, this message translates to:
  /// **'Best & Most Challenging Pairs'**
  String get riBestWorstTitle;

  /// No description provided for @riBestPair.
  ///
  /// In en, this message translates to:
  /// **'STRONGEST BOND'**
  String get riBestPair;

  /// No description provided for @riWorstPair.
  ///
  /// In en, this message translates to:
  /// **'NEEDS ATTENTION'**
  String get riWorstPair;

  /// No description provided for @riAlliances.
  ///
  /// In en, this message translates to:
  /// **'Likely Alliances'**
  String get riAlliances;

  /// No description provided for @riConflicts.
  ///
  /// In en, this message translates to:
  /// **'Likely Friction Points'**
  String get riConflicts;

  /// No description provided for @riPairwiseTitle.
  ///
  /// In en, this message translates to:
  /// **'Pairwise Analysis'**
  String get riPairwiseTitle;

  /// No description provided for @riPairwiseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} pairs analyzed'**
  String riPairwiseSubtitle(Object count);

  /// No description provided for @riDynamic.
  ///
  /// In en, this message translates to:
  /// **'Dynamic'**
  String get riDynamic;

  /// No description provided for @riKarmicLink.
  ///
  /// In en, this message translates to:
  /// **'Karmic link'**
  String get riKarmicLink;

  /// No description provided for @riMutualTrust.
  ///
  /// In en, this message translates to:
  /// **'Mutual trust'**
  String get riMutualTrust;

  /// No description provided for @riBetrayalRisk.
  ///
  /// In en, this message translates to:
  /// **'Betrayal risk'**
  String get riBetrayalRisk;

  /// No description provided for @riPowerDistribution.
  ///
  /// In en, this message translates to:
  /// **'Power distribution'**
  String get riPowerDistribution;

  /// No description provided for @riPowerHealth.
  ///
  /// In en, this message translates to:
  /// **'Power-balance health'**
  String get riPowerHealth;

  /// No description provided for @riCriticalPatternsTitle.
  ///
  /// In en, this message translates to:
  /// **'Critical Patterns'**
  String get riCriticalPatternsTitle;

  /// No description provided for @riGroupRecsTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Recommendations'**
  String get riGroupRecsTitle;

  /// No description provided for @riSharedPractices.
  ///
  /// In en, this message translates to:
  /// **'Shared Practices'**
  String get riSharedPractices;

  /// No description provided for @riCommStyle.
  ///
  /// In en, this message translates to:
  /// **'Recommended Communication Style'**
  String get riCommStyle;

  /// No description provided for @riGrowthFocus.
  ///
  /// In en, this message translates to:
  /// **'Recommended Growth Focus'**
  String get riGrowthFocus;

  /// No description provided for @riIndividualTitle.
  ///
  /// In en, this message translates to:
  /// **'Individual Guidance'**
  String get riIndividualTitle;

  /// No description provided for @riBestAllies.
  ///
  /// In en, this message translates to:
  /// **'Best Allies'**
  String get riBestAllies;

  /// No description provided for @riHandleWithCare.
  ///
  /// In en, this message translates to:
  /// **'Handle With Care'**
  String get riHandleWithCare;

  /// No description provided for @riCoreThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Core Group Theme'**
  String get riCoreThemeTitle;

  /// No description provided for @riLayerPairwise.
  ///
  /// In en, this message translates to:
  /// **'Pairwise Completeness'**
  String get riLayerPairwise;

  /// No description provided for @riLayerD1.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart (D1)'**
  String get riLayerD1;

  /// No description provided for @riLayerD9.
  ///
  /// In en, this message translates to:
  /// **'Navamsa (D9)'**
  String get riLayerD9;

  /// No description provided for @riLayerD10.
  ///
  /// In en, this message translates to:
  /// **'Dashamsa (D10)'**
  String get riLayerD10;

  /// No description provided for @riLayerD30.
  ///
  /// In en, this message translates to:
  /// **'Trimshamsa (D30)'**
  String get riLayerD30;

  /// No description provided for @riLayerJaimini.
  ///
  /// In en, this message translates to:
  /// **'Jaimini Signal'**
  String get riLayerJaimini;

  /// No description provided for @riLayerBehavior.
  ///
  /// In en, this message translates to:
  /// **'Behavior Clarity'**
  String get riLayerBehavior;

  /// No description provided for @riLayerCoherence.
  ///
  /// In en, this message translates to:
  /// **'Group Coherence'**
  String get riLayerCoherence;

  /// No description provided for @riTopicDynamics.
  ///
  /// In en, this message translates to:
  /// **'Our group dynamics'**
  String get riTopicDynamics;

  /// No description provided for @riTopicPairwise.
  ///
  /// In en, this message translates to:
  /// **'A specific pair\'s compatibility'**
  String get riTopicPairwise;

  /// No description provided for @riTopicAlerts.
  ///
  /// In en, this message translates to:
  /// **'Any critical alerts'**
  String get riTopicAlerts;

  /// No description provided for @riTopicGrowth.
  ///
  /// In en, this message translates to:
  /// **'How we can grow together'**
  String get riTopicGrowth;

  /// No description provided for @riTopicRecs.
  ///
  /// In en, this message translates to:
  /// **'Recommended practices'**
  String get riTopicRecs;

  /// No description provided for @riTopicTheme.
  ///
  /// In en, this message translates to:
  /// **'Our core group theme'**
  String get riTopicTheme;

  /// No description provided for @kmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Kundli Milan Report'**
  String get kmSubtitle;

  /// No description provided for @kmTitle.
  ///
  /// In en, this message translates to:
  /// **'Kundli Milan'**
  String get kmTitle;

  /// No description provided for @kmSnapshotHeader.
  ///
  /// In en, this message translates to:
  /// **'Compatibility Snapshot'**
  String get kmSnapshotHeader;

  /// No description provided for @kmAshtakootScore.
  ///
  /// In en, this message translates to:
  /// **'Ashtakoot: {score}/36'**
  String kmAshtakootScore(Object score);

  /// No description provided for @kmGaugeAshtakoot.
  ///
  /// In en, this message translates to:
  /// **'Ashtakoot %'**
  String get kmGaugeAshtakoot;

  /// No description provided for @kmGaugeD9.
  ///
  /// In en, this message translates to:
  /// **'D9 Marriage Karma'**
  String get kmGaugeD9;

  /// No description provided for @kmGaugeMangal.
  ///
  /// In en, this message translates to:
  /// **'Mangal Balance'**
  String get kmGaugeMangal;

  /// No description provided for @kmGaugePapa.
  ///
  /// In en, this message translates to:
  /// **'Karmic Balance'**
  String get kmGaugePapa;

  /// No description provided for @kmGaugeAk.
  ///
  /// In en, this message translates to:
  /// **'Soul Resonance'**
  String get kmGaugeAk;

  /// No description provided for @kmChipNoNadi.
  ///
  /// In en, this message translates to:
  /// **'No Nadi Dosh'**
  String get kmChipNoNadi;

  /// No description provided for @kmChipNoBhakoot.
  ///
  /// In en, this message translates to:
  /// **'No Bhakoot Dosh'**
  String get kmChipNoBhakoot;

  /// No description provided for @kmChipMangalCancelled.
  ///
  /// In en, this message translates to:
  /// **'Mangal Dosh cancelled'**
  String get kmChipMangalCancelled;

  /// No description provided for @kmChipPapaBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced karmic load'**
  String get kmChipPapaBalanced;

  /// No description provided for @kmChipStrongChemistry.
  ///
  /// In en, this message translates to:
  /// **'Strong physical chemistry'**
  String get kmChipStrongChemistry;

  /// No description provided for @kmChipStrongD9.
  ///
  /// In en, this message translates to:
  /// **'Strong D9 marriage karma'**
  String get kmChipStrongD9;

  /// No description provided for @kmChipLongevity.
  ///
  /// In en, this message translates to:
  /// **'Strong longevity alignment'**
  String get kmChipLongevity;

  /// No description provided for @kmAshtakootTitle.
  ///
  /// In en, this message translates to:
  /// **'Ashtakoot Guna Milan'**
  String get kmAshtakootTitle;

  /// No description provided for @kmAshtakootSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The classical 8-point matching system, out of 36'**
  String get kmAshtakootSubtitle;

  /// No description provided for @kmNadiSeverity.
  ///
  /// In en, this message translates to:
  /// **'Nadi severity'**
  String get kmNadiSeverity;

  /// No description provided for @kmBhakootSeverity.
  ///
  /// In en, this message translates to:
  /// **'Bhakoot severity'**
  String get kmBhakootSeverity;

  /// No description provided for @kmGanaSignature.
  ///
  /// In en, this message translates to:
  /// **'Gana signature'**
  String get kmGanaSignature;

  /// No description provided for @kmMangalTitle.
  ///
  /// In en, this message translates to:
  /// **'Mangal Dosha Check'**
  String get kmMangalTitle;

  /// No description provided for @kmD9Title.
  ///
  /// In en, this message translates to:
  /// **'D9 Navamsa — Marriage Karma'**
  String get kmD9Title;

  /// No description provided for @kmD9Subtitle.
  ///
  /// In en, this message translates to:
  /// **'The soul-level marriage chart, considered most important classically'**
  String get kmD9Subtitle;

  /// No description provided for @kmD9Score.
  ///
  /// In en, this message translates to:
  /// **'D9 Compatibility'**
  String get kmD9Score;

  /// No description provided for @kmLagnaRelation.
  ///
  /// In en, this message translates to:
  /// **'Lagna relationship'**
  String get kmLagnaRelation;

  /// No description provided for @km7thLordRelation.
  ///
  /// In en, this message translates to:
  /// **'7th lord relationship'**
  String get km7thLordRelation;

  /// No description provided for @kmKarakasTitle.
  ///
  /// In en, this message translates to:
  /// **'Soul & Spouse Karakas'**
  String get kmKarakasTitle;

  /// No description provided for @kmAtmakaraka.
  ///
  /// In en, this message translates to:
  /// **'Soul Planet'**
  String get kmAtmakaraka;

  /// No description provided for @kmAkCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Soul-Signature Resonance'**
  String get kmAkCompatibility;

  /// No description provided for @kmUlCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Spouse-Karaka Alignment'**
  String get kmUlCompatibility;

  /// No description provided for @kmUlSigns.
  ///
  /// In en, this message translates to:
  /// **'Upapada lords'**
  String get kmUlSigns;

  /// No description provided for @kmChemistryTitle.
  ///
  /// In en, this message translates to:
  /// **'Venus-Mars Chemistry'**
  String get kmChemistryTitle;

  /// No description provided for @kmPhysicalChemistry.
  ///
  /// In en, this message translates to:
  /// **'Physical Chemistry'**
  String get kmPhysicalChemistry;

  /// No description provided for @kmEmotionalWarmth.
  ///
  /// In en, this message translates to:
  /// **'Emotional Warmth'**
  String get kmEmotionalWarmth;

  /// No description provided for @kmAestheticAlignment.
  ///
  /// In en, this message translates to:
  /// **'Aesthetic Alignment'**
  String get kmAestheticAlignment;

  /// No description provided for @kmElementalSynthesis.
  ///
  /// In en, this message translates to:
  /// **'Elemental Synthesis'**
  String get kmElementalSynthesis;

  /// No description provided for @kmHouseCrossTitle.
  ///
  /// In en, this message translates to:
  /// **'7th & 8th House Cross-Analysis'**
  String get kmHouseCrossTitle;

  /// No description provided for @km78Compatibility.
  ///
  /// In en, this message translates to:
  /// **'7th-8th House Compatibility'**
  String get km78Compatibility;

  /// No description provided for @km8thHouseSignature.
  ///
  /// In en, this message translates to:
  /// **'Joint Longevity Signature'**
  String get km8thHouseSignature;

  /// No description provided for @kmLongevityAlignment.
  ///
  /// In en, this message translates to:
  /// **'Longevity Alignment'**
  String get kmLongevityAlignment;

  /// No description provided for @km7thLordFriendship.
  ///
  /// In en, this message translates to:
  /// **'7th-lord friendship'**
  String get km7thLordFriendship;

  /// No description provided for @kmDomainsTitle.
  ///
  /// In en, this message translates to:
  /// **'Domain-by-Domain Compatibility'**
  String get kmDomainsTitle;

  /// No description provided for @kmConflictEngagement.
  ///
  /// In en, this message translates to:
  /// **'Conflict Style'**
  String get kmConflictEngagement;

  /// No description provided for @kmDashaTitle.
  ///
  /// In en, this message translates to:
  /// **'Dasha & Transit Sync'**
  String get kmDashaTitle;

  /// No description provided for @kmDashaSync.
  ///
  /// In en, this message translates to:
  /// **'Dasha Sync'**
  String get kmDashaSync;

  /// No description provided for @kmTransitAlignment.
  ///
  /// In en, this message translates to:
  /// **'Transit Alignment'**
  String get kmTransitAlignment;

  /// No description provided for @kmTimingTitle.
  ///
  /// In en, this message translates to:
  /// **'Marriage Timing'**
  String get kmTimingTitle;

  /// No description provided for @kmMarriageWindow.
  ///
  /// In en, this message translates to:
  /// **'Marriage Window'**
  String get kmMarriageWindow;

  /// No description provided for @kmEngagementWindow.
  ///
  /// In en, this message translates to:
  /// **'Engagement Window'**
  String get kmEngagementWindow;

  /// No description provided for @kmRecommendedRange.
  ///
  /// In en, this message translates to:
  /// **'Recommended Timeframe'**
  String get kmRecommendedRange;

  /// No description provided for @kmMuhurtaNotes.
  ///
  /// In en, this message translates to:
  /// **'Muhurta Notes'**
  String get kmMuhurtaNotes;

  /// No description provided for @kmRisksTitle.
  ///
  /// In en, this message translates to:
  /// **'Risks To Address'**
  String get kmRisksTitle;

  /// No description provided for @kmConflictRisk.
  ///
  /// In en, this message translates to:
  /// **'Conflict Risk'**
  String get kmConflictRisk;

  /// No description provided for @kmCommunicationRisk.
  ///
  /// In en, this message translates to:
  /// **'Communication Risk'**
  String get kmCommunicationRisk;

  /// No description provided for @kmFinanceRisk.
  ///
  /// In en, this message translates to:
  /// **'Finance Conflict Risk'**
  String get kmFinanceRisk;

  /// No description provided for @kmFamilyDynamicsRisk.
  ///
  /// In en, this message translates to:
  /// **'Family Dynamics Risk'**
  String get kmFamilyDynamicsRisk;

  /// No description provided for @kmMentalHealthRisk.
  ///
  /// In en, this message translates to:
  /// **'Mental-Health Alignment Risk'**
  String get kmMentalHealthRisk;

  /// No description provided for @kmStrengthsTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Compatibility Strengths'**
  String get kmStrengthsTitle;

  /// No description provided for @kmSharedGrowth.
  ///
  /// In en, this message translates to:
  /// **'Shared Growth Potential'**
  String get kmSharedGrowth;

  /// No description provided for @kmSharedCreative.
  ///
  /// In en, this message translates to:
  /// **'Shared Creative Potential'**
  String get kmSharedCreative;

  /// No description provided for @kmJourneyTitle.
  ///
  /// In en, this message translates to:
  /// **'Relationship Journey & Growth'**
  String get kmJourneyTitle;

  /// No description provided for @kmCurrentPhase.
  ///
  /// In en, this message translates to:
  /// **'Current phase'**
  String get kmCurrentPhase;

  /// No description provided for @kmEarlyArc.
  ///
  /// In en, this message translates to:
  /// **'Early Marriage'**
  String get kmEarlyArc;

  /// No description provided for @kmMiddleArc.
  ///
  /// In en, this message translates to:
  /// **'Middle Marriage'**
  String get kmMiddleArc;

  /// No description provided for @kmMatureArc.
  ///
  /// In en, this message translates to:
  /// **'Mature Marriage'**
  String get kmMatureArc;

  /// No description provided for @kmElderArc.
  ///
  /// In en, this message translates to:
  /// **'Elder Years'**
  String get kmElderArc;

  /// No description provided for @kmPeakPhase.
  ///
  /// In en, this message translates to:
  /// **'Peak Companionship Phase'**
  String get kmPeakPhase;

  /// No description provided for @kmGrowthAreas.
  ///
  /// In en, this message translates to:
  /// **'Growth Areas'**
  String get kmGrowthAreas;

  /// No description provided for @kmCommProtocols.
  ///
  /// In en, this message translates to:
  /// **'Communication Protocols'**
  String get kmCommProtocols;

  /// No description provided for @kmSharedPractices.
  ///
  /// In en, this message translates to:
  /// **'Shared Practices'**
  String get kmSharedPractices;

  /// No description provided for @kmImprovementTitle.
  ///
  /// In en, this message translates to:
  /// **'Core Theme & Improvement Plan'**
  String get kmImprovementTitle;

  /// No description provided for @kmVerdictTitle.
  ///
  /// In en, this message translates to:
  /// **'Final Verdict'**
  String get kmVerdictTitle;

  /// No description provided for @kmRealizationPotential.
  ///
  /// In en, this message translates to:
  /// **'Relationship Realization Potential'**
  String get kmRealizationPotential;

  /// No description provided for @kmLayerAshtakoot.
  ///
  /// In en, this message translates to:
  /// **'Ashtakoot'**
  String get kmLayerAshtakoot;

  /// No description provided for @kmLayerD9.
  ///
  /// In en, this message translates to:
  /// **'D9 Navamsa'**
  String get kmLayerD9;

  /// No description provided for @kmLayerMangalPapa.
  ///
  /// In en, this message translates to:
  /// **'Mangal & Papasamya'**
  String get kmLayerMangalPapa;

  /// No description provided for @kmLayerVenusMars.
  ///
  /// In en, this message translates to:
  /// **'Venus-Mars'**
  String get kmLayerVenusMars;

  /// No description provided for @kmLayerDashaSync.
  ///
  /// In en, this message translates to:
  /// **'Dasha Sync'**
  String get kmLayerDashaSync;

  /// No description provided for @kmLayerH7H8.
  ///
  /// In en, this message translates to:
  /// **'7th-8th House Cross'**
  String get kmLayerH7H8;

  /// No description provided for @kmLayerAkResonance.
  ///
  /// In en, this message translates to:
  /// **'Atmakaraka Resonance'**
  String get kmLayerAkResonance;

  /// No description provided for @kmLayerDomains.
  ///
  /// In en, this message translates to:
  /// **'Domain Dimensions'**
  String get kmLayerDomains;

  /// No description provided for @kmTopicAshtakoot.
  ///
  /// In en, this message translates to:
  /// **'Our Ashtakoot score'**
  String get kmTopicAshtakoot;

  /// No description provided for @kmTopicMangal.
  ///
  /// In en, this message translates to:
  /// **'Mangal Dosha concerns'**
  String get kmTopicMangal;

  /// No description provided for @kmTopicD9.
  ///
  /// In en, this message translates to:
  /// **'Our marriage karma (D9)'**
  String get kmTopicD9;

  /// No description provided for @kmTopicTiming.
  ///
  /// In en, this message translates to:
  /// **'Best marriage timing'**
  String get kmTopicTiming;

  /// No description provided for @kmTopicRisks.
  ///
  /// In en, this message translates to:
  /// **'Risks to prepare for'**
  String get kmTopicRisks;

  /// No description provided for @kmTopicGrowth.
  ///
  /// In en, this message translates to:
  /// **'How we can grow together'**
  String get kmTopicGrowth;

  /// No description provided for @kmTopicRemedies.
  ///
  /// In en, this message translates to:
  /// **'Recommended remedies'**
  String get kmTopicRemedies;

  /// No description provided for @kmTopicVerdict.
  ///
  /// In en, this message translates to:
  /// **'Should we proceed with marriage'**
  String get kmTopicVerdict;

  /// No description provided for @pkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Past Life & Karma Report'**
  String get pkSubtitle;

  /// No description provided for @pkTitle.
  ///
  /// In en, this message translates to:
  /// **'Past Life & Karma'**
  String get pkTitle;

  /// No description provided for @pkSnapshotHeader.
  ///
  /// In en, this message translates to:
  /// **'Past-Life Snapshot'**
  String get pkSnapshotHeader;

  /// No description provided for @pkHeroSummary.
  ///
  /// In en, this message translates to:
  /// **'Your chart shows a \'{theme}\' past-life signature, currently {relation} into this life. Recommended path: {strategy}.'**
  String pkHeroSummary(Object theme, Object relation, Object strategy);

  /// No description provided for @pkGaugeSignature.
  ///
  /// In en, this message translates to:
  /// **'Signature Strength'**
  String get pkGaugeSignature;

  /// No description provided for @pkGaugeMasteryPreserved.
  ///
  /// In en, this message translates to:
  /// **'Mastery Preserved'**
  String get pkGaugeMasteryPreserved;

  /// No description provided for @pkGaugeClearingProgress.
  ///
  /// In en, this message translates to:
  /// **'Karma Clearing'**
  String get pkGaugeClearingProgress;

  /// No description provided for @pkGaugeMaturity.
  ///
  /// In en, this message translates to:
  /// **'Past-Life Maturity'**
  String get pkGaugeMaturity;

  /// No description provided for @pkGaugeMemoryAccess.
  ///
  /// In en, this message translates to:
  /// **'Memory Access'**
  String get pkGaugeMemoryAccess;

  /// No description provided for @pkChipGoodProgress.
  ///
  /// In en, this message translates to:
  /// **'Good karma-clearing progress'**
  String get pkChipGoodProgress;

  /// No description provided for @pkChipLowDebt.
  ///
  /// In en, this message translates to:
  /// **'Low karmic debt'**
  String get pkChipLowDebt;

  /// No description provided for @pkChipMatureSoul.
  ///
  /// In en, this message translates to:
  /// **'Mature soul signature'**
  String get pkChipMatureSoul;

  /// No description provided for @pkChipGiftedPast.
  ///
  /// In en, this message translates to:
  /// **'Chart carries a past-life gift'**
  String get pkChipGiftedPast;

  /// No description provided for @pkChipAccomplished.
  ///
  /// In en, this message translates to:
  /// **'Accomplished past life'**
  String get pkChipAccomplished;

  /// No description provided for @pkChipMasteryPreserved.
  ///
  /// In en, this message translates to:
  /// **'Strong mastery carried forward'**
  String get pkChipMasteryPreserved;

  /// No description provided for @pkKetuTitle.
  ///
  /// In en, this message translates to:
  /// **'Ketu — Your Past Mastery'**
  String get pkKetuTitle;

  /// No description provided for @pkKetuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Skills your soul already mastered'**
  String get pkKetuSubtitle;

  /// No description provided for @pkMasteryStrength.
  ///
  /// In en, this message translates to:
  /// **'Mastery Strength'**
  String get pkMasteryStrength;

  /// No description provided for @pkSkillsCarried.
  ///
  /// In en, this message translates to:
  /// **'Skills Carried Forward'**
  String get pkSkillsCarried;

  /// No description provided for @pkInstincts.
  ///
  /// In en, this message translates to:
  /// **'Instinctual Capacities'**
  String get pkInstincts;

  /// No description provided for @pkKetuDignity.
  ///
  /// In en, this message translates to:
  /// **'Ketu dignity'**
  String get pkKetuDignity;

  /// No description provided for @pkRahuTitle.
  ///
  /// In en, this message translates to:
  /// **'Rahu — Your Soul\'s Growth Edge'**
  String get pkRahuTitle;

  /// No description provided for @pkRahuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What your soul is here to finish'**
  String get pkRahuSubtitle;

  /// No description provided for @pkUnmetDesires.
  ///
  /// In en, this message translates to:
  /// **'Unmet Desires'**
  String get pkUnmetDesires;

  /// No description provided for @pkProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Past-Life Profile'**
  String get pkProfileTitle;

  /// No description provided for @pkProfession.
  ///
  /// In en, this message translates to:
  /// **'Likely Profession'**
  String get pkProfession;

  /// No description provided for @pkSocialStanding.
  ///
  /// In en, this message translates to:
  /// **'Social Standing'**
  String get pkSocialStanding;

  /// No description provided for @pkRegion.
  ///
  /// In en, this message translates to:
  /// **'Likely Region'**
  String get pkRegion;

  /// No description provided for @pkCulturalArchetype.
  ///
  /// In en, this message translates to:
  /// **'Cultural Archetype'**
  String get pkCulturalArchetype;

  /// No description provided for @pkAccomplishment.
  ///
  /// In en, this message translates to:
  /// **'Accomplishment Level'**
  String get pkAccomplishment;

  /// No description provided for @pkAuthority.
  ///
  /// In en, this message translates to:
  /// **'Authority Level'**
  String get pkAuthority;

  /// No description provided for @pkFamilyRole.
  ///
  /// In en, this message translates to:
  /// **'Family role'**
  String get pkFamilyRole;

  /// No description provided for @pkSecondaryProfession.
  ///
  /// In en, this message translates to:
  /// **'Secondary profession'**
  String get pkSecondaryProfession;

  /// No description provided for @pkClimateAffinity.
  ///
  /// In en, this message translates to:
  /// **'Climate affinity'**
  String get pkClimateAffinity;

  /// No description provided for @pkForeignResidence.
  ///
  /// In en, this message translates to:
  /// **'Foreign-residence karma'**
  String get pkForeignResidence;

  /// No description provided for @pkRelationshipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Past Relationships Carried Forward'**
  String get pkRelationshipsTitle;

  /// No description provided for @pkSpouseConnection.
  ///
  /// In en, this message translates to:
  /// **'Spouse Reconnection'**
  String get pkSpouseConnection;

  /// No description provided for @pkChildrenConnection.
  ///
  /// In en, this message translates to:
  /// **'Children Reconnection'**
  String get pkChildrenConnection;

  /// No description provided for @pkCarriedRelationTypes.
  ///
  /// In en, this message translates to:
  /// **'Relationship Patterns'**
  String get pkCarriedRelationTypes;

  /// No description provided for @pkPartnerArchetype.
  ///
  /// In en, this message translates to:
  /// **'Past-Life Partner Archetype'**
  String get pkPartnerArchetype;

  /// No description provided for @pkDarakaraka.
  ///
  /// In en, this message translates to:
  /// **'Spouse karaka'**
  String get pkDarakaraka;

  /// No description provided for @pkParentsKarma.
  ///
  /// In en, this message translates to:
  /// **'Parents karma pattern'**
  String get pkParentsKarma;

  /// No description provided for @pkSiblingKarma.
  ///
  /// In en, this message translates to:
  /// **'Sibling karma pattern'**
  String get pkSiblingKarma;

  /// No description provided for @pkSpiritualTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Spiritual Life Then'**
  String get pkSpiritualTitle;

  /// No description provided for @pkSpiritualLevel.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Level'**
  String get pkSpiritualLevel;

  /// No description provided for @pkPracticeSignature.
  ///
  /// In en, this message translates to:
  /// **'Practice Style'**
  String get pkPracticeSignature;

  /// No description provided for @pkMeditativeCapacity.
  ///
  /// In en, this message translates to:
  /// **'Meditative Capacity'**
  String get pkMeditativeCapacity;

  /// No description provided for @pkDevotionalPractice.
  ///
  /// In en, this message translates to:
  /// **'Devotional Practice'**
  String get pkDevotionalPractice;

  /// No description provided for @pkYogicAttainment.
  ///
  /// In en, this message translates to:
  /// **'Yogic Attainment'**
  String get pkYogicAttainment;

  /// No description provided for @pkMokshaProximity.
  ///
  /// In en, this message translates to:
  /// **'Moksha Proximity'**
  String get pkMokshaProximity;

  /// No description provided for @pkKarmicDebtsTitle.
  ///
  /// In en, this message translates to:
  /// **'Karmic Debts & Wealth Then'**
  String get pkKarmicDebtsTitle;

  /// No description provided for @pkTotalKarmicDebt.
  ///
  /// In en, this message translates to:
  /// **'Total Karmic Debt'**
  String get pkTotalKarmicDebt;

  /// No description provided for @pkPrimaryDebtType.
  ///
  /// In en, this message translates to:
  /// **'Primary Debt Type'**
  String get pkPrimaryDebtType;

  /// No description provided for @pkRelationshipDebt.
  ///
  /// In en, this message translates to:
  /// **'Relationship Debt'**
  String get pkRelationshipDebt;

  /// No description provided for @pkFinancialDebt.
  ///
  /// In en, this message translates to:
  /// **'Financial Debt'**
  String get pkFinancialDebt;

  /// No description provided for @pkServiceDebt.
  ///
  /// In en, this message translates to:
  /// **'Service Debt'**
  String get pkServiceDebt;

  /// No description provided for @pkDharmicDebt.
  ///
  /// In en, this message translates to:
  /// **'Dharmic Debt'**
  String get pkDharmicDebt;

  /// No description provided for @pkPitruKarma.
  ///
  /// In en, this message translates to:
  /// **'Pitru karma'**
  String get pkPitruKarma;

  /// No description provided for @pkMatruKarma.
  ///
  /// In en, this message translates to:
  /// **'Matru karma'**
  String get pkMatruKarma;

  /// No description provided for @pkWealthLevel.
  ///
  /// In en, this message translates to:
  /// **'Wealth Level Then'**
  String get pkWealthLevel;

  /// No description provided for @pkWealthKarmaCarried.
  ///
  /// In en, this message translates to:
  /// **'Wealth Karma Carried'**
  String get pkWealthKarmaCarried;

  /// No description provided for @pkResourcePattern.
  ///
  /// In en, this message translates to:
  /// **'Resource management'**
  String get pkResourcePattern;

  /// No description provided for @pkGainSource.
  ///
  /// In en, this message translates to:
  /// **'Gain source'**
  String get pkGainSource;

  /// No description provided for @pkEchoesTitle.
  ///
  /// In en, this message translates to:
  /// **'Echoes In This Life'**
  String get pkEchoesTitle;

  /// No description provided for @pkOnRelationships.
  ///
  /// In en, this message translates to:
  /// **'On Relationships'**
  String get pkOnRelationships;

  /// No description provided for @pkOnCareer.
  ///
  /// In en, this message translates to:
  /// **'On Career'**
  String get pkOnCareer;

  /// No description provided for @pkOnHealth.
  ///
  /// In en, this message translates to:
  /// **'On Health'**
  String get pkOnHealth;

  /// No description provided for @pkOnSpirituality.
  ///
  /// In en, this message translates to:
  /// **'On Spirituality'**
  String get pkOnSpirituality;

  /// No description provided for @pkDominantArea.
  ///
  /// In en, this message translates to:
  /// **'Strongest Carryforward'**
  String get pkDominantArea;

  /// No description provided for @pkAttractions.
  ///
  /// In en, this message translates to:
  /// **'Natural Attractions'**
  String get pkAttractions;

  /// No description provided for @pkAversions.
  ///
  /// In en, this message translates to:
  /// **'Natural Aversions'**
  String get pkAversions;

  /// No description provided for @pkUnexplainedFears.
  ///
  /// In en, this message translates to:
  /// **'Unexplained Fears'**
  String get pkUnexplainedFears;

  /// No description provided for @pkMagneticPulls.
  ///
  /// In en, this message translates to:
  /// **'Magnetic Pulls'**
  String get pkMagneticPulls;

  /// No description provided for @pkResolutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Karmic Resolution & Completion'**
  String get pkResolutionTitle;

  /// No description provided for @pkPrimaryPathway.
  ///
  /// In en, this message translates to:
  /// **'Primary Path'**
  String get pkPrimaryPathway;

  /// No description provided for @pkSecondaryPathway.
  ///
  /// In en, this message translates to:
  /// **'Secondary Path'**
  String get pkSecondaryPathway;

  /// No description provided for @pkClearingProgress.
  ///
  /// In en, this message translates to:
  /// **'Clearing Progress'**
  String get pkClearingProgress;

  /// No description provided for @pkRemainingWork.
  ///
  /// In en, this message translates to:
  /// **'Remaining Work'**
  String get pkRemainingWork;

  /// No description provided for @pkSettlementTimeline.
  ///
  /// In en, this message translates to:
  /// **'Settlement Timeline'**
  String get pkSettlementTimeline;

  /// No description provided for @pkAccelerationPractices.
  ///
  /// In en, this message translates to:
  /// **'Practices That Speed Resolution'**
  String get pkAccelerationPractices;

  /// No description provided for @pkPriorityAreas.
  ///
  /// In en, this message translates to:
  /// **'Priority Areas'**
  String get pkPriorityAreas;

  /// No description provided for @pkVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified Across Charts (D60)'**
  String get pkVerificationTitle;

  /// No description provided for @pkD60Label.
  ///
  /// In en, this message translates to:
  /// **'D60 Past-Life Era'**
  String get pkD60Label;

  /// No description provided for @pkD60Ketu.
  ///
  /// In en, this message translates to:
  /// **'D60 Ketu placement'**
  String get pkD60Ketu;

  /// No description provided for @pkD60Standing.
  ///
  /// In en, this message translates to:
  /// **'Overall standing'**
  String get pkD60Standing;

  /// No description provided for @pkMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Memory & Intuition'**
  String get pkMemoryTitle;

  /// No description provided for @pkMemoryAccess.
  ///
  /// In en, this message translates to:
  /// **'Memory Access'**
  String get pkMemoryAccess;

  /// No description provided for @pkRegressionFit.
  ///
  /// In en, this message translates to:
  /// **'Regression-Therapy Fit'**
  String get pkRegressionFit;

  /// No description provided for @pkDreamVisits.
  ///
  /// In en, this message translates to:
  /// **'Dream Visitations'**
  String get pkDreamVisits;

  /// No description provided for @pkDejaVuFrequency.
  ///
  /// In en, this message translates to:
  /// **'Deja Vu Frequency'**
  String get pkDejaVuFrequency;

  /// No description provided for @pkSpontaneousRemembrance.
  ///
  /// In en, this message translates to:
  /// **'Spontaneous remembrance'**
  String get pkSpontaneousRemembrance;

  /// No description provided for @pkRemembrancePractices.
  ///
  /// In en, this message translates to:
  /// **'Remembrance Practices'**
  String get pkRemembrancePractices;

  /// No description provided for @pkTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Activation Timeline'**
  String get pkTimelineTitle;

  /// No description provided for @pkGiftsActivation.
  ///
  /// In en, this message translates to:
  /// **'Past-Life Gifts Activation'**
  String get pkGiftsActivation;

  /// No description provided for @pkSurfaceWindow.
  ///
  /// In en, this message translates to:
  /// **'Surfacing Window'**
  String get pkSurfaceWindow;

  /// No description provided for @pkRisksTitle.
  ///
  /// In en, this message translates to:
  /// **'Risks & Chronic Patterns'**
  String get pkRisksTitle;

  /// No description provided for @pkTraumaResidue.
  ///
  /// In en, this message translates to:
  /// **'Trauma Residue'**
  String get pkTraumaResidue;

  /// No description provided for @pkSpiritualBypass.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Bypass Risk'**
  String get pkSpiritualBypass;

  /// No description provided for @pkMajorRisks.
  ///
  /// In en, this message translates to:
  /// **'Major Risks'**
  String get pkMajorRisks;

  /// No description provided for @pkChronicImprints.
  ///
  /// In en, this message translates to:
  /// **'Chronic Imprints'**
  String get pkChronicImprints;

  /// No description provided for @pkKarmicLoops.
  ///
  /// In en, this message translates to:
  /// **'Karmic Loops'**
  String get pkKarmicLoops;

  /// No description provided for @pkImprovementTitle.
  ///
  /// In en, this message translates to:
  /// **'Improvement Plan'**
  String get pkImprovementTitle;

  /// No description provided for @pkRoadmapTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Past-Life Roadmap'**
  String get pkRoadmapTitle;

  /// No description provided for @pkMaturity.
  ///
  /// In en, this message translates to:
  /// **'Past-Life Maturity'**
  String get pkMaturity;

  /// No description provided for @pkLayerD1.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart (D1)'**
  String get pkLayerD1;

  /// No description provided for @pkLayerD9.
  ///
  /// In en, this message translates to:
  /// **'Navamsa (D9)'**
  String get pkLayerD9;

  /// No description provided for @pkLayerD60.
  ///
  /// In en, this message translates to:
  /// **'Shashtiamsa (D60)'**
  String get pkLayerD60;

  /// No description provided for @pkLayerKetuDepth.
  ///
  /// In en, this message translates to:
  /// **'Ketu Depth'**
  String get pkLayerKetuDepth;

  /// No description provided for @pkLayerAtmakaraka.
  ///
  /// In en, this message translates to:
  /// **'Soul Planet (Atmakaraka)'**
  String get pkLayerAtmakaraka;

  /// No description provided for @pkTopicMastery.
  ///
  /// In en, this message translates to:
  /// **'My past-life mastery'**
  String get pkTopicMastery;

  /// No description provided for @pkTopicUnfinished.
  ///
  /// In en, this message translates to:
  /// **'My unfinished karma'**
  String get pkTopicUnfinished;

  /// No description provided for @pkTopicRelationships.
  ///
  /// In en, this message translates to:
  /// **'My past-life relationships'**
  String get pkTopicRelationships;

  /// No description provided for @pkTopicDebts.
  ///
  /// In en, this message translates to:
  /// **'My karmic debts'**
  String get pkTopicDebts;

  /// No description provided for @pkTopicResolution.
  ///
  /// In en, this message translates to:
  /// **'How to resolve my karma'**
  String get pkTopicResolution;

  /// No description provided for @pkTopicMemory.
  ///
  /// In en, this message translates to:
  /// **'Past-life memory access'**
  String get pkTopicMemory;

  /// No description provided for @pkTopicTiming.
  ///
  /// In en, this message translates to:
  /// **'Best timing windows'**
  String get pkTopicTiming;

  /// No description provided for @pkTopicProfile.
  ///
  /// In en, this message translates to:
  /// **'Who I was in my past life'**
  String get pkTopicProfile;

  /// No description provided for @chSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Character Analysis Report'**
  String get chSubtitle;

  /// No description provided for @chTitle.
  ///
  /// In en, this message translates to:
  /// **'Character Analysis'**
  String get chTitle;

  /// No description provided for @chSnapshotHeader.
  ///
  /// In en, this message translates to:
  /// **'Character Snapshot'**
  String get chSnapshotHeader;

  /// No description provided for @chGaugeIntegrity.
  ///
  /// In en, this message translates to:
  /// **'Integrity'**
  String get chGaugeIntegrity;

  /// No description provided for @chGaugeResilience.
  ///
  /// In en, this message translates to:
  /// **'Resilience'**
  String get chGaugeResilience;

  /// No description provided for @chGaugeSelfAwareness.
  ///
  /// In en, this message translates to:
  /// **'Self-Awareness'**
  String get chGaugeSelfAwareness;

  /// No description provided for @chGaugeStability.
  ///
  /// In en, this message translates to:
  /// **'Emotional Stability'**
  String get chGaugeStability;

  /// No description provided for @chGaugeMoralFabric.
  ///
  /// In en, this message translates to:
  /// **'Moral Fabric'**
  String get chGaugeMoralFabric;

  /// No description provided for @chChipRajaYoga.
  ///
  /// In en, this message translates to:
  /// **'Raja Yoga present'**
  String get chChipRajaYoga;

  /// No description provided for @chChipHighIntegrity.
  ///
  /// In en, this message translates to:
  /// **'High integrity'**
  String get chChipHighIntegrity;

  /// No description provided for @chChipResilient.
  ///
  /// In en, this message translates to:
  /// **'Resilient nature'**
  String get chChipResilient;

  /// No description provided for @chChipDharmic.
  ///
  /// In en, this message translates to:
  /// **'Strong dharma orientation'**
  String get chChipDharmic;

  /// No description provided for @chChipEmpathetic.
  ///
  /// In en, this message translates to:
  /// **'Naturally empathetic'**
  String get chChipEmpathetic;

  /// No description provided for @chChipLoyal.
  ///
  /// In en, this message translates to:
  /// **'Deeply loyal'**
  String get chChipLoyal;

  /// No description provided for @chChipGiftedCharacter.
  ///
  /// In en, this message translates to:
  /// **'Chart carries a character gift'**
  String get chChipGiftedCharacter;

  /// No description provided for @chSoulTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Soul Signature'**
  String get chSoulTitle;

  /// No description provided for @chSoulIntegration.
  ///
  /// In en, this message translates to:
  /// **'Soul-Character Integration'**
  String get chSoulIntegration;

  /// No description provided for @chAmatyakarakaTheme.
  ///
  /// In en, this message translates to:
  /// **'Supporting Character Voice'**
  String get chAmatyakarakaTheme;

  /// No description provided for @chAtmakarakaDignity.
  ///
  /// In en, this message translates to:
  /// **'Soul-planet dignity'**
  String get chAtmakarakaDignity;

  /// No description provided for @chAtmakarakaHouse.
  ///
  /// In en, this message translates to:
  /// **'House placement'**
  String get chAtmakarakaHouse;

  /// No description provided for @chSurfaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Surface Personality & Constitution'**
  String get chSurfaceTitle;

  /// No description provided for @chLagnaSign.
  ///
  /// In en, this message translates to:
  /// **'Ascendant Sign'**
  String get chLagnaSign;

  /// No description provided for @chConstitution.
  ///
  /// In en, this message translates to:
  /// **'Constitution'**
  String get chConstitution;

  /// No description provided for @chSurfaceSignature.
  ///
  /// In en, this message translates to:
  /// **'How you come across'**
  String get chSurfaceSignature;

  /// No description provided for @chPhysicalConstitution.
  ///
  /// In en, this message translates to:
  /// **'Physical Constitution'**
  String get chPhysicalConstitution;

  /// No description provided for @chLagnaLord.
  ///
  /// In en, this message translates to:
  /// **'Ascendant Lord'**
  String get chLagnaLord;

  /// No description provided for @chLagnaOccupants.
  ///
  /// In en, this message translates to:
  /// **'Planets in Ascendant'**
  String get chLagnaOccupants;

  /// No description provided for @chMindEmotionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mind, Emotions & Ego'**
  String get chMindEmotionsTitle;

  /// No description provided for @chEmotionalNature.
  ///
  /// In en, this message translates to:
  /// **'Your Emotional Nature'**
  String get chEmotionalNature;

  /// No description provided for @chMentalStability.
  ///
  /// In en, this message translates to:
  /// **'Mental Stability'**
  String get chMentalStability;

  /// No description provided for @chSelfConfidence.
  ///
  /// In en, this message translates to:
  /// **'Healthy Self-Confidence'**
  String get chSelfConfidence;

  /// No description provided for @chEgoNature.
  ///
  /// In en, this message translates to:
  /// **'Your Ego & Self-Concept'**
  String get chEgoNature;

  /// No description provided for @chAuthorityRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship with Authority'**
  String get chAuthorityRelationship;

  /// No description provided for @chPrideTendency.
  ///
  /// In en, this message translates to:
  /// **'Pride Tendency'**
  String get chPrideTendency;

  /// No description provided for @chMoodPatterns.
  ///
  /// In en, this message translates to:
  /// **'Mood Patterns'**
  String get chMoodPatterns;

  /// No description provided for @chKemadrumaPresent.
  ///
  /// In en, this message translates to:
  /// **'Kemadruma Yoga present — extra emotional self-care is beneficial.'**
  String get chKemadrumaPresent;

  /// No description provided for @chFatherImprint.
  ///
  /// In en, this message translates to:
  /// **'Father imprint quality'**
  String get chFatherImprint;

  /// No description provided for @chCommunicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Communication & Intellect Style'**
  String get chCommunicationTitle;

  /// No description provided for @chIntellectStyle.
  ///
  /// In en, this message translates to:
  /// **'Intellect Style'**
  String get chIntellectStyle;

  /// No description provided for @chCommStyle.
  ///
  /// In en, this message translates to:
  /// **'Communication Style'**
  String get chCommStyle;

  /// No description provided for @chDecisionStyle.
  ///
  /// In en, this message translates to:
  /// **'Decision-Making Style'**
  String get chDecisionStyle;

  /// No description provided for @chDiscrimination.
  ///
  /// In en, this message translates to:
  /// **'Discrimination Capacity'**
  String get chDiscrimination;

  /// No description provided for @chPersonaTitle.
  ///
  /// In en, this message translates to:
  /// **'Public Persona vs True Self'**
  String get chPersonaTitle;

  /// No description provided for @chAuthenticityGap.
  ///
  /// In en, this message translates to:
  /// **'Authenticity Gap'**
  String get chAuthenticityGap;

  /// No description provided for @chGunaTitle.
  ///
  /// In en, this message translates to:
  /// **'Guna & Dosha Profile'**
  String get chGunaTitle;

  /// No description provided for @chGunaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your inner nature and constitution, classical Vedic style'**
  String get chGunaSubtitle;

  /// No description provided for @chSattva.
  ///
  /// In en, this message translates to:
  /// **'Sattva'**
  String get chSattva;

  /// No description provided for @chRajas.
  ///
  /// In en, this message translates to:
  /// **'Rajas'**
  String get chRajas;

  /// No description provided for @chTamas.
  ///
  /// In en, this message translates to:
  /// **'Tamas'**
  String get chTamas;

  /// No description provided for @chDominantGuna.
  ///
  /// In en, this message translates to:
  /// **'Dominant Guna'**
  String get chDominantGuna;

  /// No description provided for @chPitta.
  ///
  /// In en, this message translates to:
  /// **'Pitta'**
  String get chPitta;

  /// No description provided for @chKapha.
  ///
  /// In en, this message translates to:
  /// **'Kapha'**
  String get chKapha;

  /// No description provided for @chVata.
  ///
  /// In en, this message translates to:
  /// **'Vata'**
  String get chVata;

  /// No description provided for @chDominantDosha.
  ///
  /// In en, this message translates to:
  /// **'Dominant Dosha'**
  String get chDominantDosha;

  /// No description provided for @chRahuRestlessness.
  ///
  /// In en, this message translates to:
  /// **'Rahu restlessness'**
  String get chRahuRestlessness;

  /// No description provided for @chKetuDetachment.
  ///
  /// In en, this message translates to:
  /// **'Ketu detachment'**
  String get chKetuDetachment;

  /// No description provided for @chYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Character Yogas'**
  String get chYogasTitle;

  /// No description provided for @chRajaYogaStrength.
  ///
  /// In en, this message translates to:
  /// **'Raja Yoga Strength'**
  String get chRajaYogaStrength;

  /// No description provided for @chGiftYogas.
  ///
  /// In en, this message translates to:
  /// **'Gift Yogas'**
  String get chGiftYogas;

  /// No description provided for @chTestYogas.
  ///
  /// In en, this message translates to:
  /// **'Test Yogas'**
  String get chTestYogas;

  /// No description provided for @chStrengthsTitle.
  ///
  /// In en, this message translates to:
  /// **'Strengths & Talents'**
  String get chStrengthsTitle;

  /// No description provided for @chSignatureVirtues.
  ///
  /// In en, this message translates to:
  /// **'Signature Virtues'**
  String get chSignatureVirtues;

  /// No description provided for @chNaturalTalents.
  ///
  /// In en, this message translates to:
  /// **'Natural Talents'**
  String get chNaturalTalents;

  /// No description provided for @chSoftSkills.
  ///
  /// In en, this message translates to:
  /// **'Soft Skills'**
  String get chSoftSkills;

  /// No description provided for @chHiddenStrengths.
  ///
  /// In en, this message translates to:
  /// **'Hidden Strengths To Develop'**
  String get chHiddenStrengths;

  /// No description provided for @chShadowTitle.
  ///
  /// In en, this message translates to:
  /// **'Shadow & Growth Areas'**
  String get chShadowTitle;

  /// No description provided for @chShadowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle awareness of patterns worth working on'**
  String get chShadowSubtitle;

  /// No description provided for @chShadowPatterns.
  ///
  /// In en, this message translates to:
  /// **'Shadow Patterns'**
  String get chShadowPatterns;

  /// No description provided for @chBlindSpots.
  ///
  /// In en, this message translates to:
  /// **'Blind Spots'**
  String get chBlindSpots;

  /// No description provided for @chEmotionalWounds.
  ///
  /// In en, this message translates to:
  /// **'Emotional Wounds'**
  String get chEmotionalWounds;

  /// No description provided for @chShadowWorkPriorities.
  ///
  /// In en, this message translates to:
  /// **'Shadow-Work Priorities'**
  String get chShadowWorkPriorities;

  /// No description provided for @chMoralTests.
  ///
  /// In en, this message translates to:
  /// **'Moral Tests'**
  String get chMoralTests;

  /// No description provided for @chRelationshipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Relationships & Social Style'**
  String get chRelationshipsTitle;

  /// No description provided for @chWarmth.
  ///
  /// In en, this message translates to:
  /// **'Interpersonal Warmth'**
  String get chWarmth;

  /// No description provided for @chEmpathy.
  ///
  /// In en, this message translates to:
  /// **'Empathy Capacity'**
  String get chEmpathy;

  /// No description provided for @chLoyalty.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Capacity'**
  String get chLoyalty;

  /// No description provided for @chBoundaries.
  ///
  /// In en, this message translates to:
  /// **'Boundary Setting'**
  String get chBoundaries;

  /// No description provided for @chSocialConfidence.
  ///
  /// In en, this message translates to:
  /// **'Social Confidence'**
  String get chSocialConfidence;

  /// No description provided for @chTrustGiving.
  ///
  /// In en, this message translates to:
  /// **'Trust-Giving Baseline'**
  String get chTrustGiving;

  /// No description provided for @chConflictStyle.
  ///
  /// In en, this message translates to:
  /// **'Conflict style'**
  String get chConflictStyle;

  /// No description provided for @chEthicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ethics & Moral Compass'**
  String get chEthicsTitle;

  /// No description provided for @chDharmaOrientation.
  ///
  /// In en, this message translates to:
  /// **'Dharma Orientation'**
  String get chDharmaOrientation;

  /// No description provided for @chTruthfulness.
  ///
  /// In en, this message translates to:
  /// **'Truthfulness'**
  String get chTruthfulness;

  /// No description provided for @chCompassion.
  ///
  /// In en, this message translates to:
  /// **'Compassion'**
  String get chCompassion;

  /// No description provided for @chGenerosity.
  ///
  /// In en, this message translates to:
  /// **'Generosity'**
  String get chGenerosity;

  /// No description provided for @chEthicalConsistency.
  ///
  /// In en, this message translates to:
  /// **'Ethical Consistency'**
  String get chEthicalConsistency;

  /// No description provided for @chIntegrityPressure.
  ///
  /// In en, this message translates to:
  /// **'Integrity Under Pressure'**
  String get chIntegrityPressure;

  /// No description provided for @chJusticeFairness.
  ///
  /// In en, this message translates to:
  /// **'Justice & Fairness'**
  String get chJusticeFairness;

  /// No description provided for @chMoralTrajectory.
  ///
  /// In en, this message translates to:
  /// **'Moral development'**
  String get chMoralTrajectory;

  /// No description provided for @chEiTitle.
  ///
  /// In en, this message translates to:
  /// **'Emotional Intelligence'**
  String get chEiTitle;

  /// No description provided for @chEiSelfAwareness.
  ///
  /// In en, this message translates to:
  /// **'Self-Awareness'**
  String get chEiSelfAwareness;

  /// No description provided for @chEiSelfRegulation.
  ///
  /// In en, this message translates to:
  /// **'Self-Regulation'**
  String get chEiSelfRegulation;

  /// No description provided for @chEiEmpathy.
  ///
  /// In en, this message translates to:
  /// **'Empathy'**
  String get chEiEmpathy;

  /// No description provided for @chEiSocialSkills.
  ///
  /// In en, this message translates to:
  /// **'Social Skills'**
  String get chEiSocialSkills;

  /// No description provided for @chMotivation.
  ///
  /// In en, this message translates to:
  /// **'Internal Motivation'**
  String get chMotivation;

  /// No description provided for @chVulnerabilityComfort.
  ///
  /// In en, this message translates to:
  /// **'Comfort With Vulnerability'**
  String get chVulnerabilityComfort;

  /// No description provided for @chEmotionalExpression.
  ///
  /// In en, this message translates to:
  /// **'Emotional expression comfort'**
  String get chEmotionalExpression;

  /// No description provided for @chEmotionalReceptivity.
  ///
  /// In en, this message translates to:
  /// **'Emotional receptivity'**
  String get chEmotionalReceptivity;

  /// No description provided for @chVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified Across Charts (D9/D12/D30/D60)'**
  String get chVerificationTitle;

  /// No description provided for @chD9Label.
  ///
  /// In en, this message translates to:
  /// **'D9 Dharma-Character'**
  String get chD9Label;

  /// No description provided for @chD12Label.
  ///
  /// In en, this message translates to:
  /// **'D12 Ancestral Inheritance'**
  String get chD12Label;

  /// No description provided for @chD30Label.
  ///
  /// In en, this message translates to:
  /// **'D30 Shadow Profile'**
  String get chD30Label;

  /// No description provided for @chD60Label.
  ///
  /// In en, this message translates to:
  /// **'D60 Past-Life Character'**
  String get chD60Label;

  /// No description provided for @chD30Standing.
  ///
  /// In en, this message translates to:
  /// **'Shadow standing'**
  String get chD30Standing;

  /// No description provided for @chMaternalInheritance.
  ///
  /// In en, this message translates to:
  /// **'Maternal inheritance'**
  String get chMaternalInheritance;

  /// No description provided for @chAncestralKarmaWeight.
  ///
  /// In en, this message translates to:
  /// **'Ancestral karma weight'**
  String get chAncestralKarmaWeight;

  /// No description provided for @chTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Character Timeline'**
  String get chTimelineTitle;

  /// No description provided for @chFormationWindow.
  ///
  /// In en, this message translates to:
  /// **'Formation Window'**
  String get chFormationWindow;

  /// No description provided for @chMaturationWindow.
  ///
  /// In en, this message translates to:
  /// **'Maturation Window'**
  String get chMaturationWindow;

  /// No description provided for @chLegacyWindow.
  ///
  /// In en, this message translates to:
  /// **'Legacy Window'**
  String get chLegacyWindow;

  /// No description provided for @chPeakMaturationAge.
  ///
  /// In en, this message translates to:
  /// **'Peak maturation age'**
  String get chPeakMaturationAge;

  /// No description provided for @chAgeRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age {ageRange}'**
  String chAgeRangeLabel(Object ageRange);

  /// No description provided for @chImprovementTitle.
  ///
  /// In en, this message translates to:
  /// **'Improvement Plan'**
  String get chImprovementTitle;

  /// No description provided for @chRoadmapTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Character Roadmap'**
  String get chRoadmapTitle;

  /// No description provided for @chAuthenticExpression.
  ///
  /// In en, this message translates to:
  /// **'Authentic Self-Expression'**
  String get chAuthenticExpression;

  /// No description provided for @chRealizationPotential.
  ///
  /// In en, this message translates to:
  /// **'Character Realization Potential'**
  String get chRealizationPotential;

  /// No description provided for @chLayerAtmakaraka.
  ///
  /// In en, this message translates to:
  /// **'Soul Planet (Atmakaraka)'**
  String get chLayerAtmakaraka;

  /// No description provided for @chLayerD1.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart (D1)'**
  String get chLayerD1;

  /// No description provided for @chLayerD9.
  ///
  /// In en, this message translates to:
  /// **'Navamsa (D9)'**
  String get chLayerD9;

  /// No description provided for @chLayerD30.
  ///
  /// In en, this message translates to:
  /// **'Trimshamsa (D30)'**
  String get chLayerD30;

  /// No description provided for @chLayerLagnaMoon.
  ///
  /// In en, this message translates to:
  /// **'Ascendant & Moon'**
  String get chLayerLagnaMoon;

  /// No description provided for @chLayerArudha.
  ///
  /// In en, this message translates to:
  /// **'Arudha Lagna'**
  String get chLayerArudha;

  /// No description provided for @chTopicStrengths.
  ///
  /// In en, this message translates to:
  /// **'My character strengths'**
  String get chTopicStrengths;

  /// No description provided for @chTopicShadow.
  ///
  /// In en, this message translates to:
  /// **'My shadow patterns'**
  String get chTopicShadow;

  /// No description provided for @chTopicSoul.
  ///
  /// In en, this message translates to:
  /// **'My soul signature'**
  String get chTopicSoul;

  /// No description provided for @chTopicRelationships.
  ///
  /// In en, this message translates to:
  /// **'My relationship style'**
  String get chTopicRelationships;

  /// No description provided for @chTopicEthics.
  ///
  /// In en, this message translates to:
  /// **'My ethics & values'**
  String get chTopicEthics;

  /// No description provided for @chTopicGuna.
  ///
  /// In en, this message translates to:
  /// **'My guna & dosha profile'**
  String get chTopicGuna;

  /// No description provided for @chTopicGrowth.
  ///
  /// In en, this message translates to:
  /// **'How to grow my character'**
  String get chTopicGrowth;

  /// No description provided for @chTopicTiming.
  ///
  /// In en, this message translates to:
  /// **'Best timing for character work'**
  String get chTopicTiming;

  /// No description provided for @lpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Life Path & Luck Report'**
  String get lpSubtitle;

  /// No description provided for @lpTitle.
  ///
  /// In en, this message translates to:
  /// **'Life Path & Luck'**
  String get lpTitle;

  /// No description provided for @lpSnapshotHeader.
  ///
  /// In en, this message translates to:
  /// **'Life Path Snapshot'**
  String get lpSnapshotHeader;

  /// No description provided for @lpHeroSummary.
  ///
  /// In en, this message translates to:
  /// **'You\'re a {archetype} with a primary purpose in {domain}. Our analysis shows a {probability}% overall life-fulfillment potential.'**
  String lpHeroSummary(Object archetype, Object domain, Object probability);

  /// No description provided for @lpGaugeDharma.
  ///
  /// In en, this message translates to:
  /// **'Dharma Clarity'**
  String get lpGaugeDharma;

  /// No description provided for @lpGaugeFortune.
  ///
  /// In en, this message translates to:
  /// **'Fortune Baseline'**
  String get lpGaugeFortune;

  /// No description provided for @lpGaugeCoherence.
  ///
  /// In en, this message translates to:
  /// **'Path Coherence'**
  String get lpGaugeCoherence;

  /// No description provided for @lpGaugeFulfillment.
  ///
  /// In en, this message translates to:
  /// **'Fulfillment'**
  String get lpGaugeFulfillment;

  /// No description provided for @lpGaugeMomentum.
  ///
  /// In en, this message translates to:
  /// **'Karmic Momentum'**
  String get lpGaugeMomentum;

  /// No description provided for @lpChipRareGift.
  ///
  /// In en, this message translates to:
  /// **'Rare destiny gift'**
  String get lpChipRareGift;

  /// No description provided for @lpChipFreeWillStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong free will'**
  String get lpChipFreeWillStrong;

  /// No description provided for @lpChipGraceSupported.
  ///
  /// In en, this message translates to:
  /// **'Grace-supported'**
  String get lpChipGraceSupported;

  /// No description provided for @lpChipLightKarma.
  ///
  /// In en, this message translates to:
  /// **'Light karmic load'**
  String get lpChipLightKarma;

  /// No description provided for @lpChipRecognitionPotential.
  ///
  /// In en, this message translates to:
  /// **'Recognition potential'**
  String get lpChipRecognitionPotential;

  /// No description provided for @lpChipSpiritualPath.
  ///
  /// In en, this message translates to:
  /// **'Strong spiritual pull'**
  String get lpChipSpiritualPath;

  /// No description provided for @lpChipBlessed.
  ///
  /// In en, this message translates to:
  /// **'Chart carries blessings'**
  String get lpChipBlessed;

  /// No description provided for @lpSoulPathTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Soul Path'**
  String get lpSoulPathTitle;

  /// No description provided for @lpSoulPlanet.
  ///
  /// In en, this message translates to:
  /// **'Soul Planet'**
  String get lpSoulPlanet;

  /// No description provided for @lpCareerPlanet.
  ///
  /// In en, this message translates to:
  /// **'Purpose Planet'**
  String get lpCareerPlanet;

  /// No description provided for @lpSoulClarity.
  ///
  /// In en, this message translates to:
  /// **'Purpose Clarity'**
  String get lpSoulClarity;

  /// No description provided for @lpLifeChapter.
  ///
  /// In en, this message translates to:
  /// **'Current Life Chapter'**
  String get lpLifeChapter;

  /// No description provided for @lpPrimaryDomain.
  ///
  /// In en, this message translates to:
  /// **'Primary Purpose Domain'**
  String get lpPrimaryDomain;

  /// No description provided for @lpKarakaTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Dharma Planets'**
  String get lpKarakaTitle;

  /// No description provided for @lpKarakaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How strongly each planet supports your life purpose'**
  String get lpKarakaSubtitle;

  /// No description provided for @lpVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified Across Charts (D9 / D60)'**
  String get lpVerificationTitle;

  /// No description provided for @lpD9Label.
  ///
  /// In en, this message translates to:
  /// **'D9 Soul Alignment'**
  String get lpD9Label;

  /// No description provided for @lpD9Explain.
  ///
  /// In en, this message translates to:
  /// **'Your soul-evolution stage is \'{stage}\' in the Navamsa chart.'**
  String lpD9Explain(Object stage);

  /// No description provided for @lpD9JupiterDignity.
  ///
  /// In en, this message translates to:
  /// **'Jupiter dignity'**
  String get lpD9JupiterDignity;

  /// No description provided for @lpD9DharmaMultiplier.
  ///
  /// In en, this message translates to:
  /// **'Dharma multiplier'**
  String get lpD9DharmaMultiplier;

  /// No description provided for @lpD60Label.
  ///
  /// In en, this message translates to:
  /// **'D60 Past-Life Signature'**
  String get lpD60Label;

  /// No description provided for @lpKarmaType.
  ///
  /// In en, this message translates to:
  /// **'Past-life karma type'**
  String get lpKarmaType;

  /// No description provided for @lpKetuMastery.
  ///
  /// In en, this message translates to:
  /// **'Ketu past-life mastery'**
  String get lpKetuMastery;

  /// No description provided for @lpRahuGrowthDir.
  ///
  /// In en, this message translates to:
  /// **'Rahu growth direction'**
  String get lpRahuGrowthDir;

  /// No description provided for @lpYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Fortune Yogas & Luck Blocks'**
  String get lpYogasTitle;

  /// No description provided for @lpFortuneBoost.
  ///
  /// In en, this message translates to:
  /// **'Fortune Boost'**
  String get lpFortuneBoost;

  /// No description provided for @lpLuckDrain.
  ///
  /// In en, this message translates to:
  /// **'Luck Drain'**
  String get lpLuckDrain;

  /// No description provided for @lpFortuneBoosters.
  ///
  /// In en, this message translates to:
  /// **'Fortune Boosters'**
  String get lpFortuneBoosters;

  /// No description provided for @lpLuckBlocks.
  ///
  /// In en, this message translates to:
  /// **'Luck Blocks'**
  String get lpLuckBlocks;

  /// No description provided for @lpPurposeTitle.
  ///
  /// In en, this message translates to:
  /// **'Purpose Domains & Fame'**
  String get lpPurposeTitle;

  /// No description provided for @lpDomainLeadership.
  ///
  /// In en, this message translates to:
  /// **'Leadership'**
  String get lpDomainLeadership;

  /// No description provided for @lpDomainWisdom.
  ///
  /// In en, this message translates to:
  /// **'Wisdom & Teaching'**
  String get lpDomainWisdom;

  /// No description provided for @lpDomainService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get lpDomainService;

  /// No description provided for @lpDomainHealing.
  ///
  /// In en, this message translates to:
  /// **'Healing'**
  String get lpDomainHealing;

  /// No description provided for @lpDomainCreative.
  ///
  /// In en, this message translates to:
  /// **'Creative Expression'**
  String get lpDomainCreative;

  /// No description provided for @lpPrimaryDomainBadge.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get lpPrimaryDomainBadge;

  /// No description provided for @lpFameRecognition.
  ///
  /// In en, this message translates to:
  /// **'Fame & Recognition'**
  String get lpFameRecognition;

  /// No description provided for @lpSocialInfluence.
  ///
  /// In en, this message translates to:
  /// **'Social Influence'**
  String get lpSocialInfluence;

  /// No description provided for @lpRecognitionDomain.
  ///
  /// In en, this message translates to:
  /// **'Recognition Field'**
  String get lpRecognitionDomain;

  /// No description provided for @lpPublicImage.
  ///
  /// In en, this message translates to:
  /// **'Public Image'**
  String get lpPublicImage;

  /// No description provided for @lpHistoricalImpact.
  ///
  /// In en, this message translates to:
  /// **'Historical impact potential'**
  String get lpHistoricalImpact;

  /// No description provided for @lpTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Fortune & Life Timeline'**
  String get lpTimelineTitle;

  /// No description provided for @lpCurrentPhase.
  ///
  /// In en, this message translates to:
  /// **'Current Fortune Phase'**
  String get lpCurrentPhase;

  /// No description provided for @lpJupiterReturn.
  ///
  /// In en, this message translates to:
  /// **'Jupiter Return'**
  String get lpJupiterReturn;

  /// No description provided for @lpSaturnReturn.
  ///
  /// In en, this message translates to:
  /// **'Saturn Return'**
  String get lpSaturnReturn;

  /// No description provided for @lpSadeSati.
  ///
  /// In en, this message translates to:
  /// **'Sade Sati'**
  String get lpSadeSati;

  /// No description provided for @lpGoldenWindow.
  ///
  /// In en, this message translates to:
  /// **'Golden Window'**
  String get lpGoldenWindow;

  /// No description provided for @lpTransformationWindow.
  ///
  /// In en, this message translates to:
  /// **'Transformation Window'**
  String get lpTransformationWindow;

  /// No description provided for @lpPeakYears.
  ///
  /// In en, this message translates to:
  /// **'Peak Fortune Years'**
  String get lpPeakYears;

  /// No description provided for @lpChallengingYears.
  ///
  /// In en, this message translates to:
  /// **'Challenging Years'**
  String get lpChallengingYears;

  /// No description provided for @lpMilestonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Major Milestones & Turning Points'**
  String get lpMilestonesTitle;

  /// No description provided for @lpFirstTurningPoint.
  ///
  /// In en, this message translates to:
  /// **'First Major Turning Point'**
  String get lpFirstTurningPoint;

  /// No description provided for @lpMidlifeTransform.
  ///
  /// In en, this message translates to:
  /// **'Midlife Transformation'**
  String get lpMidlifeTransform;

  /// No description provided for @lpLateLifeFulfillment.
  ///
  /// In en, this message translates to:
  /// **'Late-Life Fulfillment'**
  String get lpLateLifeFulfillment;

  /// No description provided for @lpDharmicMilestone.
  ///
  /// In en, this message translates to:
  /// **'Dharmic Milestone (Age {age})'**
  String lpDharmicMilestone(Object age);

  /// No description provided for @lpAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age {age}'**
  String lpAgeLabel(Object age);

  /// No description provided for @lpDestinyTitle.
  ///
  /// In en, this message translates to:
  /// **'Destiny vs Free Will'**
  String get lpDestinyTitle;

  /// No description provided for @lpDestinyStat.
  ///
  /// In en, this message translates to:
  /// **'Destiny Weight'**
  String get lpDestinyStat;

  /// No description provided for @lpFreeWillStat.
  ///
  /// In en, this message translates to:
  /// **'Free Will Leverage'**
  String get lpFreeWillStat;

  /// No description provided for @lpFateStrength.
  ///
  /// In en, this message translates to:
  /// **'Fate Signature Strength'**
  String get lpFateStrength;

  /// No description provided for @lpSelfCreation.
  ///
  /// In en, this message translates to:
  /// **'Self-Creation Capacity'**
  String get lpSelfCreation;

  /// No description provided for @lpEffortGrace.
  ///
  /// In en, this message translates to:
  /// **'Effort vs grace'**
  String get lpEffortGrace;

  /// No description provided for @lpKarmicTitle.
  ///
  /// In en, this message translates to:
  /// **'Karmic Lessons'**
  String get lpKarmicTitle;

  /// No description provided for @lpRahuGrowthLabel.
  ///
  /// In en, this message translates to:
  /// **'Rahu — Growth Challenge'**
  String get lpRahuGrowthLabel;

  /// No description provided for @lpKetuSurrenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Ketu — Surrender Theme'**
  String get lpKetuSurrenderLabel;

  /// No description provided for @lpSaturnLessonLabel.
  ///
  /// In en, this message translates to:
  /// **'Saturn — Discipline Lesson'**
  String get lpSaturnLessonLabel;

  /// No description provided for @lpTestDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Life Test Difficulty'**
  String get lpTestDifficulty;

  /// No description provided for @lpLessonsInProgress.
  ///
  /// In en, this message translates to:
  /// **'Lessons In Progress'**
  String get lpLessonsInProgress;

  /// No description provided for @lpSoulContract.
  ///
  /// In en, this message translates to:
  /// **'Soul Contract Areas'**
  String get lpSoulContract;

  /// No description provided for @lpSoulExperience.
  ///
  /// In en, this message translates to:
  /// **'What Your Soul Came To Experience'**
  String get lpSoulExperience;

  /// No description provided for @lpSoulMastery.
  ///
  /// In en, this message translates to:
  /// **'What Your Soul Came To Master'**
  String get lpSoulMastery;

  /// No description provided for @lpSpiritualTitle.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Path'**
  String get lpSpiritualTitle;

  /// No description provided for @lpSpiritualInclination.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Inclination'**
  String get lpSpiritualInclination;

  /// No description provided for @lpMeditationReceptivity.
  ///
  /// In en, this message translates to:
  /// **'Meditation Receptivity'**
  String get lpMeditationReceptivity;

  /// No description provided for @lpTeacherKarma.
  ///
  /// In en, this message translates to:
  /// **'Teacher/Guru Karma'**
  String get lpTeacherKarma;

  /// No description provided for @lpPilgrimageBenefit.
  ///
  /// In en, this message translates to:
  /// **'Pilgrimage Benefit'**
  String get lpPilgrimageBenefit;

  /// No description provided for @lpSelfRealization.
  ///
  /// In en, this message translates to:
  /// **'Self-Realization Potential'**
  String get lpSelfRealization;

  /// No description provided for @lpDivineConnection.
  ///
  /// In en, this message translates to:
  /// **'Divine Connection'**
  String get lpDivineConnection;

  /// No description provided for @lpTraditionAffinity.
  ///
  /// In en, this message translates to:
  /// **'Tradition affinity'**
  String get lpTraditionAffinity;

  /// No description provided for @lpIntuitionStrength.
  ///
  /// In en, this message translates to:
  /// **'Intuition strength'**
  String get lpIntuitionStrength;

  /// No description provided for @lpMantraEfficacy.
  ///
  /// In en, this message translates to:
  /// **'Prayer/mantra efficacy'**
  String get lpMantraEfficacy;

  /// No description provided for @lpInnerGuidance.
  ///
  /// In en, this message translates to:
  /// **'Inner-guidance trust'**
  String get lpInnerGuidance;

  /// No description provided for @lpPropheticDreams.
  ///
  /// In en, this message translates to:
  /// **'Prophetic-dream sensitivity'**
  String get lpPropheticDreams;

  /// No description provided for @lpDifficultyTitle.
  ///
  /// In en, this message translates to:
  /// **'Life Difficulty & Challenges'**
  String get lpDifficultyTitle;

  /// No description provided for @lpEarlyLife.
  ///
  /// In en, this message translates to:
  /// **'Early Life'**
  String get lpEarlyLife;

  /// No description provided for @lpMidlife.
  ///
  /// In en, this message translates to:
  /// **'Midlife'**
  String get lpMidlife;

  /// No description provided for @lpLateLife.
  ///
  /// In en, this message translates to:
  /// **'Late Life'**
  String get lpLateLife;

  /// No description provided for @lpStruggleToSuccess.
  ///
  /// In en, this message translates to:
  /// **'Struggle-to-Success Karma'**
  String get lpStruggleToSuccess;

  /// No description provided for @lpUnlivedLifeRisk.
  ///
  /// In en, this message translates to:
  /// **'Unlived-Life Risk'**
  String get lpUnlivedLifeRisk;

  /// No description provided for @lpChallenges.
  ///
  /// In en, this message translates to:
  /// **'Life Challenges'**
  String get lpChallenges;

  /// No description provided for @lpFortuneDrains.
  ///
  /// In en, this message translates to:
  /// **'Chronic Fortune Drains'**
  String get lpFortuneDrains;

  /// No description provided for @lpRegretAreas.
  ///
  /// In en, this message translates to:
  /// **'Regret-Vulnerability Areas'**
  String get lpRegretAreas;

  /// No description provided for @lpRedFlags.
  ///
  /// In en, this message translates to:
  /// **'Direction Red Flags'**
  String get lpRedFlags;

  /// No description provided for @lpBlessingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Blessings & Core Life Theme'**
  String get lpBlessingsTitle;

  /// No description provided for @lpKarmicRoot.
  ///
  /// In en, this message translates to:
  /// **'Karmic root'**
  String get lpKarmicRoot;

  /// No description provided for @lpBlessingsList.
  ///
  /// In en, this message translates to:
  /// **'Your Blessings'**
  String get lpBlessingsList;

  /// No description provided for @lpFulfillmentPriorities.
  ///
  /// In en, this message translates to:
  /// **'Fulfillment Priorities'**
  String get lpFulfillmentPriorities;

  /// No description provided for @lpImprovementTitle.
  ///
  /// In en, this message translates to:
  /// **'Improvement Plan'**
  String get lpImprovementTitle;

  /// No description provided for @lpDharmaPriorities.
  ///
  /// In en, this message translates to:
  /// **'Dharma Priorities'**
  String get lpDharmaPriorities;

  /// No description provided for @lpRoadmapTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Destiny Roadmap'**
  String get lpRoadmapTitle;

  /// No description provided for @lpStrategy.
  ///
  /// In en, this message translates to:
  /// **'Strategy'**
  String get lpStrategy;

  /// No description provided for @lpFulfillmentPotential.
  ///
  /// In en, this message translates to:
  /// **'Fulfillment Potential'**
  String get lpFulfillmentPotential;

  /// No description provided for @lpNext12Focus.
  ///
  /// In en, this message translates to:
  /// **'Next 12-Month Focus'**
  String get lpNext12Focus;

  /// No description provided for @lpLayerD1.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart (D1)'**
  String get lpLayerD1;

  /// No description provided for @lpLayerD9.
  ///
  /// In en, this message translates to:
  /// **'Navamsa (D9)'**
  String get lpLayerD9;

  /// No description provided for @lpLayerD60.
  ///
  /// In en, this message translates to:
  /// **'Shashtiamsa (D60)'**
  String get lpLayerD60;

  /// No description provided for @lpLayerDasha.
  ///
  /// In en, this message translates to:
  /// **'Dasha Timing'**
  String get lpLayerDasha;

  /// No description provided for @lpLayerTransit.
  ///
  /// In en, this message translates to:
  /// **'Current Transits'**
  String get lpLayerTransit;

  /// No description provided for @lpTopicPurpose.
  ///
  /// In en, this message translates to:
  /// **'My life purpose'**
  String get lpTopicPurpose;

  /// No description provided for @lpTopicFortune.
  ///
  /// In en, this message translates to:
  /// **'My fortune yogas'**
  String get lpTopicFortune;

  /// No description provided for @lpTopicKarma.
  ///
  /// In en, this message translates to:
  /// **'My karmic lessons'**
  String get lpTopicKarma;

  /// No description provided for @lpTopicMilestones.
  ///
  /// In en, this message translates to:
  /// **'Upcoming milestones'**
  String get lpTopicMilestones;

  /// No description provided for @lpTopicDestiny.
  ///
  /// In en, this message translates to:
  /// **'Destiny vs free will'**
  String get lpTopicDestiny;

  /// No description provided for @lpTopicSpiritual.
  ///
  /// In en, this message translates to:
  /// **'My spiritual path'**
  String get lpTopicSpiritual;

  /// No description provided for @lpTopicChallenges.
  ///
  /// In en, this message translates to:
  /// **'My life challenges'**
  String get lpTopicChallenges;

  /// No description provided for @lpTopicTiming.
  ///
  /// In en, this message translates to:
  /// **'Best timing windows'**
  String get lpTopicTiming;

  /// No description provided for @dbSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Debt & Recovery Report'**
  String get dbSubtitle;

  /// No description provided for @dbTitle.
  ///
  /// In en, this message translates to:
  /// **'Debt & Recovery'**
  String get dbTitle;

  /// No description provided for @dbSnapshotHeader.
  ///
  /// In en, this message translates to:
  /// **'Debt Recovery Snapshot'**
  String get dbSnapshotHeader;

  /// No description provided for @dbHeroSummary.
  ///
  /// In en, this message translates to:
  /// **'You\'re currently in a \'{phase}\' phase with a {personality} approach to money. Our analysis shows a {probability}% chance of becoming debt-free within about {years} years.'**
  String dbHeroSummary(Object phase, Object personality, Object probability, Object years);

  /// No description provided for @dbGaugeCapacity.
  ///
  /// In en, this message translates to:
  /// **'Recovery Capacity'**
  String get dbGaugeCapacity;

  /// No description provided for @dbGaugeProbability.
  ///
  /// In en, this message translates to:
  /// **'Recovery Chance'**
  String get dbGaugeProbability;

  /// No description provided for @dbGaugeFreedomNow.
  ///
  /// In en, this message translates to:
  /// **'Debt Freedom Now'**
  String get dbGaugeFreedomNow;

  /// No description provided for @dbGaugeDti.
  ///
  /// In en, this message translates to:
  /// **'Income Health'**
  String get dbGaugeDti;

  /// No description provided for @dbGaugeResilience.
  ///
  /// In en, this message translates to:
  /// **'Resilience'**
  String get dbGaugeResilience;

  /// No description provided for @dbChipCleanKarma.
  ///
  /// In en, this message translates to:
  /// **'Clean debt karma'**
  String get dbChipCleanKarma;

  /// No description provided for @dbChipStrongRecovery.
  ///
  /// In en, this message translates to:
  /// **'Strong recovery capacity'**
  String get dbChipStrongRecovery;

  /// No description provided for @dbChipHealthyDti.
  ///
  /// In en, this message translates to:
  /// **'Healthy debt-to-income'**
  String get dbChipHealthyDti;

  /// No description provided for @dbChipResilient.
  ///
  /// In en, this message translates to:
  /// **'High psychological resilience'**
  String get dbChipResilient;

  /// No description provided for @dbChipCycleBreakable.
  ///
  /// In en, this message translates to:
  /// **'Debt cycle is breakable'**
  String get dbChipCycleBreakable;

  /// No description provided for @dbChipLowReindebt.
  ///
  /// In en, this message translates to:
  /// **'Low re-indebtedness risk'**
  String get dbChipLowReindebt;

  /// No description provided for @dbChipGoodNegotiator.
  ///
  /// In en, this message translates to:
  /// **'Good negotiation odds'**
  String get dbChipGoodNegotiator;

  /// No description provided for @dbProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Debt Profile'**
  String get dbProfileTitle;

  /// No description provided for @dbPhaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Current phase'**
  String get dbPhaseLabel;

  /// No description provided for @dbPrimaryCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Main category'**
  String get dbPrimaryCategoryLabel;

  /// No description provided for @dbKarakaLabel.
  ///
  /// In en, this message translates to:
  /// **'Debt Karaka'**
  String get dbKarakaLabel;

  /// No description provided for @dbProtectorLabel.
  ///
  /// In en, this message translates to:
  /// **'Creditor Protection'**
  String get dbProtectorLabel;

  /// No description provided for @dbSecondaryCategories.
  ///
  /// In en, this message translates to:
  /// **'Secondary categories'**
  String get dbSecondaryCategories;

  /// No description provided for @dbUnsecuredRatio.
  ///
  /// In en, this message translates to:
  /// **'Unsecured-debt ratio'**
  String get dbUnsecuredRatio;

  /// No description provided for @dbKarakaTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Debt Planets'**
  String get dbKarakaTitle;

  /// No description provided for @dbKarakaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How strongly each planet supports your debt recovery'**
  String get dbKarakaSubtitle;

  /// No description provided for @dbVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified Across Charts (D6)'**
  String get dbVerificationTitle;

  /// No description provided for @dbD6Label.
  ///
  /// In en, this message translates to:
  /// **'D6 Debt & Enemies Chart'**
  String get dbD6Label;

  /// No description provided for @dbD6LordDignity.
  ///
  /// In en, this message translates to:
  /// **'6th lord strength'**
  String get dbD6LordDignity;

  /// No description provided for @dbD6Severity.
  ///
  /// In en, this message translates to:
  /// **'Debt karma severity'**
  String get dbD6Severity;

  /// No description provided for @dbD6Multiplier.
  ///
  /// In en, this message translates to:
  /// **'D6 debt multiplier'**
  String get dbD6Multiplier;

  /// No description provided for @dbYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Debt Yogas & Protections'**
  String get dbYogasTitle;

  /// No description provided for @dbPressureNow.
  ///
  /// In en, this message translates to:
  /// **'Debt Pressure Now'**
  String get dbPressureNow;

  /// No description provided for @dbRecoveryBoost.
  ///
  /// In en, this message translates to:
  /// **'Recovery Boost'**
  String get dbRecoveryBoost;

  /// No description provided for @dbClearingLabel.
  ///
  /// In en, this message translates to:
  /// **'Debt-Clearing Yogas'**
  String get dbClearingLabel;

  /// No description provided for @dbCreatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Debt-Creating Yogas'**
  String get dbCreatingLabel;

  /// No description provided for @dbCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Debt Categories Watch'**
  String get dbCategoriesTitle;

  /// No description provided for @dbCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Which types of debt need the most attention'**
  String get dbCategoriesSubtitle;

  /// No description provided for @dbTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Debt-Free Timeline'**
  String get dbTimelineTitle;

  /// No description provided for @dbFreeWindowLabel.
  ///
  /// In en, this message translates to:
  /// **'DEBT-FREE WINDOW'**
  String get dbFreeWindowLabel;

  /// No description provided for @dbClearanceEstimate.
  ///
  /// In en, this message translates to:
  /// **'Full clearance estimate'**
  String get dbClearanceEstimate;

  /// No description provided for @dbPeakYears.
  ///
  /// In en, this message translates to:
  /// **'Debt-Peak Years'**
  String get dbPeakYears;

  /// No description provided for @dbClearanceYears.
  ///
  /// In en, this message translates to:
  /// **'Clearance Years'**
  String get dbClearanceYears;

  /// No description provided for @dbBorrowTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Borrowing Guide'**
  String get dbBorrowTitle;

  /// No description provided for @dbLoanSuitability.
  ///
  /// In en, this message translates to:
  /// **'Loan Suitability'**
  String get dbLoanSuitability;

  /// No description provided for @dbBestLoanType.
  ///
  /// In en, this message translates to:
  /// **'Best Loan Type'**
  String get dbBestLoanType;

  /// No description provided for @dbLeverageCeiling.
  ///
  /// In en, this message translates to:
  /// **'Leverage Ceiling'**
  String get dbLeverageCeiling;

  /// No description provided for @dbNegotiationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Negotiation Success'**
  String get dbNegotiationSuccess;

  /// No description provided for @dbCreditorAggression.
  ///
  /// In en, this message translates to:
  /// **'Creditor Pressure Risk'**
  String get dbCreditorAggression;

  /// No description provided for @dbLegalEscalation.
  ///
  /// In en, this message translates to:
  /// **'Legal Escalation Risk'**
  String get dbLegalEscalation;

  /// No description provided for @dbNegotiationApproach.
  ///
  /// In en, this message translates to:
  /// **'Recommended approach'**
  String get dbNegotiationApproach;

  /// No description provided for @dbAvoidLoanTypes.
  ///
  /// In en, this message translates to:
  /// **'Loan Types to Avoid'**
  String get dbAvoidLoanTypes;

  /// No description provided for @dbRiskTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk & Vulnerability Watch'**
  String get dbRiskTitle;

  /// No description provided for @dbRiskDefault.
  ///
  /// In en, this message translates to:
  /// **'Default Risk'**
  String get dbRiskDefault;

  /// No description provided for @dbRiskDefaultExp.
  ///
  /// In en, this message translates to:
  /// **'The chance of missing a scheduled repayment badly enough to trigger default status with a lender.'**
  String get dbRiskDefaultExp;

  /// No description provided for @dbRiskDefaultFix.
  ///
  /// In en, this message translates to:
  /// **'Automate minimum payments and keep a 1-month buffer so a single missed income cycle doesn\'t cascade.'**
  String get dbRiskDefaultFix;

  /// No description provided for @dbRiskBankruptcy.
  ///
  /// In en, this message translates to:
  /// **'Bankruptcy Risk'**
  String get dbRiskBankruptcy;

  /// No description provided for @dbRiskBankruptcyExp.
  ///
  /// In en, this message translates to:
  /// **'The probability that debt load grows beyond what income and assets can realistically cover.'**
  String get dbRiskBankruptcyExp;

  /// No description provided for @dbRiskBankruptcyFix.
  ///
  /// In en, this message translates to:
  /// **'Get a professional debt review before taking any new loan or credit line.'**
  String get dbRiskBankruptcyFix;

  /// No description provided for @dbRiskAssetSeizure.
  ///
  /// In en, this message translates to:
  /// **'Asset-Seizure Risk'**
  String get dbRiskAssetSeizure;

  /// No description provided for @dbRiskAssetSeizureExp.
  ///
  /// In en, this message translates to:
  /// **'The chance a secured loan default could lead to a lender repossessing collateral or property.'**
  String get dbRiskAssetSeizureExp;

  /// No description provided for @dbRiskAssetSeizureFix.
  ///
  /// In en, this message translates to:
  /// **'Prioritize secured-loan payments first, and refinance early if a payment gap looks likely.'**
  String get dbRiskAssetSeizureFix;

  /// No description provided for @dbRiskChronic.
  ///
  /// In en, this message translates to:
  /// **'Chronic Re-Debt Risk'**
  String get dbRiskChronic;

  /// No description provided for @dbRiskChronicExp.
  ///
  /// In en, this message translates to:
  /// **'The tendency to fall back into debt again even after clearing the current load.'**
  String get dbRiskChronicExp;

  /// No description provided for @dbRiskChronicFix.
  ///
  /// In en, this message translates to:
  /// **'Build a dedicated emergency fund before increasing lifestyle spending after clearance.'**
  String get dbRiskChronicFix;

  /// No description provided for @dbReindebtTrigger.
  ///
  /// In en, this message translates to:
  /// **'Re-Debt Trigger'**
  String get dbReindebtTrigger;

  /// No description provided for @dbCycleBreakFeasibility.
  ///
  /// In en, this message translates to:
  /// **'Cycle-Break Feasibility'**
  String get dbCycleBreakFeasibility;

  /// No description provided for @dbMajorRisks.
  ///
  /// In en, this message translates to:
  /// **'Major Risks'**
  String get dbMajorRisks;

  /// No description provided for @dbHiddenSignals.
  ///
  /// In en, this message translates to:
  /// **'Hidden Debt Signals'**
  String get dbHiddenSignals;

  /// No description provided for @dbCrisisTitle.
  ///
  /// In en, this message translates to:
  /// **'Crisis Preparedness'**
  String get dbCrisisTitle;

  /// No description provided for @dbCrisisSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How to spot trouble early and respond calmly'**
  String get dbCrisisSubtitle;

  /// No description provided for @dbWarningSigns.
  ///
  /// In en, this message translates to:
  /// **'Early Warning Signs'**
  String get dbWarningSigns;

  /// No description provided for @dbMitigationActions.
  ///
  /// In en, this message translates to:
  /// **'What To Do About It'**
  String get dbMitigationActions;

  /// No description provided for @dbFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Family & Ancestral Debt'**
  String get dbFamilyTitle;

  /// No description provided for @dbInheritedDebtProb.
  ///
  /// In en, this message translates to:
  /// **'Inherited-Debt Chance'**
  String get dbInheritedDebtProb;

  /// No description provided for @dbFamilyDrag.
  ///
  /// In en, this message translates to:
  /// **'Family Debt Drag'**
  String get dbFamilyDrag;

  /// No description provided for @dbInheritedSource.
  ///
  /// In en, this message translates to:
  /// **'Likely source'**
  String get dbInheritedSource;

  /// No description provided for @dbCoreBlockerLabel.
  ///
  /// In en, this message translates to:
  /// **'CORE BLOCKER'**
  String get dbCoreBlockerLabel;

  /// No description provided for @dbPsychologyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Money Psychology'**
  String get dbPsychologyTitle;

  /// No description provided for @dbResilience.
  ///
  /// In en, this message translates to:
  /// **'Resilience'**
  String get dbResilience;

  /// No description provided for @dbDiscipline.
  ///
  /// In en, this message translates to:
  /// **'Discipline Under Pressure'**
  String get dbDiscipline;

  /// No description provided for @dbSocialSupport.
  ///
  /// In en, this message translates to:
  /// **'Social Support'**
  String get dbSocialSupport;

  /// No description provided for @dbDepressionRisk.
  ///
  /// In en, this message translates to:
  /// **'Financial-Stress Vulnerability'**
  String get dbDepressionRisk;

  /// No description provided for @dbStressTolerance.
  ///
  /// In en, this message translates to:
  /// **'Stress tolerance'**
  String get dbStressTolerance;

  /// No description provided for @dbRootCause.
  ///
  /// In en, this message translates to:
  /// **'Behavioral Root Cause'**
  String get dbRootCause;

  /// No description provided for @dbImprovementTitle.
  ///
  /// In en, this message translates to:
  /// **'Improvement Plan'**
  String get dbImprovementTitle;

  /// No description provided for @dbRoadmapTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Debt-Free Roadmap'**
  String get dbRoadmapTitle;

  /// No description provided for @dbRecoveryProbability.
  ///
  /// In en, this message translates to:
  /// **'Recovery Probability'**
  String get dbRecoveryProbability;

  /// No description provided for @dbClearanceTimeline.
  ///
  /// In en, this message translates to:
  /// **'Clearance Timeline'**
  String get dbClearanceTimeline;

  /// No description provided for @dbYears.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get dbYears;

  /// No description provided for @dbDtiHealth.
  ///
  /// In en, this message translates to:
  /// **'Debt-to-Income Health'**
  String get dbDtiHealth;

  /// No description provided for @dbDtiCategory.
  ///
  /// In en, this message translates to:
  /// **'DTI Category'**
  String get dbDtiCategory;

  /// No description provided for @dbBreakEvenMonths.
  ///
  /// In en, this message translates to:
  /// **'Months to break-even'**
  String get dbBreakEvenMonths;

  /// No description provided for @dbIncomeAcceleration.
  ///
  /// In en, this message translates to:
  /// **'Income growth needed'**
  String get dbIncomeAcceleration;

  /// No description provided for @dbLayerD1.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart (D1)'**
  String get dbLayerD1;

  /// No description provided for @dbLayerD6.
  ///
  /// In en, this message translates to:
  /// **'Debt & Enemies (D6)'**
  String get dbLayerD6;

  /// No description provided for @dbLayerD9.
  ///
  /// In en, this message translates to:
  /// **'Navamsa (D9)'**
  String get dbLayerD9;

  /// No description provided for @dbLayerDasha.
  ///
  /// In en, this message translates to:
  /// **'Dasha Timing'**
  String get dbLayerDasha;

  /// No description provided for @dbLayerTransit.
  ///
  /// In en, this message translates to:
  /// **'Current Transits'**
  String get dbLayerTransit;

  /// No description provided for @dbTopicRecovery.
  ///
  /// In en, this message translates to:
  /// **'My recovery timeline'**
  String get dbTopicRecovery;

  /// No description provided for @dbTopicNegotiate.
  ///
  /// In en, this message translates to:
  /// **'Negotiating with creditors'**
  String get dbTopicNegotiate;

  /// No description provided for @dbTopicBorrowing.
  ///
  /// In en, this message translates to:
  /// **'Is it safe to borrow now'**
  String get dbTopicBorrowing;

  /// No description provided for @dbTopicCrisis.
  ///
  /// In en, this message translates to:
  /// **'Preparing for a crisis'**
  String get dbTopicCrisis;

  /// No description provided for @dbTopicAncestral.
  ///
  /// In en, this message translates to:
  /// **'Ancestral debt karma'**
  String get dbTopicAncestral;

  /// No description provided for @dbTopicTimeline.
  ///
  /// In en, this message translates to:
  /// **'Best years to clear debt'**
  String get dbTopicTimeline;

  /// No description provided for @dbTopicPsychology.
  ///
  /// In en, this message translates to:
  /// **'My money psychology'**
  String get dbTopicPsychology;

  /// No description provided for @dbTopicCategories.
  ///
  /// In en, this message translates to:
  /// **'Which debts to prioritize'**
  String get dbTopicCategories;

  /// No description provided for @mnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Wellness Report'**
  String get mnSubtitle;

  /// No description provided for @mnTitle.
  ///
  /// In en, this message translates to:
  /// **'Mental & Stress'**
  String get mnTitle;

  /// No description provided for @mnSnapshotHeader.
  ///
  /// In en, this message translates to:
  /// **'Wellness Snapshot'**
  String get mnSnapshotHeader;

  /// No description provided for @mnResilience.
  ///
  /// In en, this message translates to:
  /// **'Resilience'**
  String get mnResilience;

  /// No description provided for @mnStability.
  ///
  /// In en, this message translates to:
  /// **'Stability'**
  String get mnStability;

  /// No description provided for @mnEmotionalBalance.
  ///
  /// In en, this message translates to:
  /// **'Emotional Balance'**
  String get mnEmotionalBalance;

  /// No description provided for @mnInnerCalm.
  ///
  /// In en, this message translates to:
  /// **'Inner Calm'**
  String get mnInnerCalm;

  /// No description provided for @mnSelfAwareness.
  ///
  /// In en, this message translates to:
  /// **'Self-Awareness'**
  String get mnSelfAwareness;

  /// No description provided for @mnStatusThriving.
  ///
  /// In en, this message translates to:
  /// **'Thriving'**
  String get mnStatusThriving;

  /// No description provided for @mnStatusSteady.
  ///
  /// In en, this message translates to:
  /// **'Steady & Stable'**
  String get mnStatusSteady;

  /// No description provided for @mnStatusBuildingStrength.
  ///
  /// In en, this message translates to:
  /// **'Building Strength'**
  String get mnStatusBuildingStrength;

  /// No description provided for @mnStatusNeedsGentleCare.
  ///
  /// In en, this message translates to:
  /// **'Needs Gentle Care'**
  String get mnStatusNeedsGentleCare;

  /// No description provided for @mnStatusReachOut.
  ///
  /// In en, this message translates to:
  /// **'Time to Reach Out for Support'**
  String get mnStatusReachOut;

  /// No description provided for @mnChipStable.
  ///
  /// In en, this message translates to:
  /// **'Emotionally Stable'**
  String get mnChipStable;

  /// No description provided for @mnChipSupported.
  ///
  /// In en, this message translates to:
  /// **'Well Supported'**
  String get mnChipSupported;

  /// No description provided for @mnChipSelfAware.
  ///
  /// In en, this message translates to:
  /// **'Highly Self-Aware'**
  String get mnChipSelfAware;

  /// No description provided for @mnChipResilient.
  ///
  /// In en, this message translates to:
  /// **'Bounces Back Well'**
  String get mnChipResilient;

  /// No description provided for @mnChipSecureAttachment.
  ///
  /// In en, this message translates to:
  /// **'Secure Attachment'**
  String get mnChipSecureAttachment;

  /// No description provided for @mnChipHealingReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to Heal'**
  String get mnChipHealingReady;

  /// No description provided for @mnChipMindBodyBalance.
  ///
  /// In en, this message translates to:
  /// **'Mind-Body Balance'**
  String get mnChipMindBodyBalance;

  /// No description provided for @mnSupportBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'A Gentle Note'**
  String get mnSupportBannerTitle;

  /// No description provided for @mnSupportBannerBody.
  ///
  /// In en, this message translates to:
  /// **'Your chart suggests this could be a good time to lean on extra support — a trusted friend, family member, or professional. Reaching out is a sign of strength, not weakness.'**
  String get mnSupportBannerBody;

  /// No description provided for @mnProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Emotional Blueprint'**
  String get mnProfileTitle;

  /// No description provided for @mnStressDriver.
  ///
  /// In en, this message translates to:
  /// **'Stress Driver'**
  String get mnStressDriver;

  /// No description provided for @mnStabilityAnchor.
  ///
  /// In en, this message translates to:
  /// **'Stability Anchor'**
  String get mnStabilityAnchor;

  /// No description provided for @mnSoulLevelKarma.
  ///
  /// In en, this message translates to:
  /// **'Soul-Level Pattern'**
  String get mnSoulLevelKarma;

  /// No description provided for @mnSubtleSignature.
  ///
  /// In en, this message translates to:
  /// **'Subtle Emotional Signature'**
  String get mnSubtleSignature;

  /// No description provided for @mnKarakaTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Mind & Planets'**
  String get mnKarakaTitle;

  /// No description provided for @mnKarakaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Which planets shape your inner world'**
  String get mnKarakaSubtitle;

  /// No description provided for @mnYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Strengths & Growth Areas'**
  String get mnYogasTitle;

  /// No description provided for @mnCurrentPhase.
  ///
  /// In en, this message translates to:
  /// **'Current Phase'**
  String get mnCurrentPhase;

  /// No description provided for @mnCurrentStressLevel.
  ///
  /// In en, this message translates to:
  /// **'Current Stress Level'**
  String get mnCurrentStressLevel;

  /// No description provided for @mnRecentStrain.
  ///
  /// In en, this message translates to:
  /// **'Recent Emotional Strain'**
  String get mnRecentStrain;

  /// No description provided for @mnStrengths.
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get mnStrengths;

  /// No description provided for @mnGrowthAreas.
  ///
  /// In en, this message translates to:
  /// **'Growth Areas'**
  String get mnGrowthAreas;

  /// No description provided for @mnSadeSatiStatus.
  ///
  /// In en, this message translates to:
  /// **'Sade Sati Status'**
  String get mnSadeSatiStatus;

  /// No description provided for @mnVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified Across Charts'**
  String get mnVerificationTitle;

  /// No description provided for @mnD9Confirmation.
  ///
  /// In en, this message translates to:
  /// **'D9 Confirmation'**
  String get mnD9Confirmation;

  /// No description provided for @mnD30Confirmation.
  ///
  /// In en, this message translates to:
  /// **'D30 Confirmation'**
  String get mnD30Confirmation;

  /// No description provided for @mnMoodPatternsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood & Anxiety Patterns'**
  String get mnMoodPatternsTitle;

  /// No description provided for @mnMoodPatternsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle awareness, not a diagnosis'**
  String get mnMoodPatternsSubtitle;

  /// No description provided for @mnAnxietyPatterns.
  ///
  /// In en, this message translates to:
  /// **'Anxiety Patterns'**
  String get mnAnxietyPatterns;

  /// No description provided for @mnMoodPatterns.
  ///
  /// In en, this message translates to:
  /// **'Low-Mood Patterns'**
  String get mnMoodPatterns;

  /// No description provided for @mnPrimaryPattern.
  ///
  /// In en, this message translates to:
  /// **'Primary Pattern'**
  String get mnPrimaryPattern;

  /// No description provided for @mnRumination.
  ///
  /// In en, this message translates to:
  /// **'Overthinking Tendency'**
  String get mnRumination;

  /// No description provided for @mnHypervigilance.
  ///
  /// In en, this message translates to:
  /// **'Hyper-Alertness'**
  String get mnHypervigilance;

  /// No description provided for @mnHopelessnessVuln.
  ///
  /// In en, this message translates to:
  /// **'Low-Mood Sensitivity'**
  String get mnHopelessnessVuln;

  /// No description provided for @mnEnergyDepletion.
  ///
  /// In en, this message translates to:
  /// **'Energy Depletion Tendency'**
  String get mnEnergyDepletion;

  /// No description provided for @mnMotivationBaseline.
  ///
  /// In en, this message translates to:
  /// **'Motivation Baseline'**
  String get mnMotivationBaseline;

  /// No description provided for @mnRegulationTitle.
  ///
  /// In en, this message translates to:
  /// **'Emotional Regulation & Coping'**
  String get mnRegulationTitle;

  /// No description provided for @mnEmotionalRegulation.
  ///
  /// In en, this message translates to:
  /// **'Emotional Regulation'**
  String get mnEmotionalRegulation;

  /// No description provided for @mnSelfSoothing.
  ///
  /// In en, this message translates to:
  /// **'Self-Soothing Ability'**
  String get mnSelfSoothing;

  /// No description provided for @mnExpressionStyle.
  ///
  /// In en, this message translates to:
  /// **'Expression Style'**
  String get mnExpressionStyle;

  /// No description provided for @mnRecoveryTime.
  ///
  /// In en, this message translates to:
  /// **'Recovery Time'**
  String get mnRecoveryTime;

  /// No description provided for @mnTriggerIntensity.
  ///
  /// In en, this message translates to:
  /// **'Trigger Intensity'**
  String get mnTriggerIntensity;

  /// No description provided for @mnHealthyCoping.
  ///
  /// In en, this message translates to:
  /// **'Healthy Coping Habits'**
  String get mnHealthyCoping;

  /// No description provided for @mnWatchFor.
  ///
  /// In en, this message translates to:
  /// **'Gently Watch For'**
  String get mnWatchFor;

  /// No description provided for @mnSleepTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep & Rest'**
  String get mnSleepTitle;

  /// No description provided for @mnSleepQuality.
  ///
  /// In en, this message translates to:
  /// **'Sleep Quality'**
  String get mnSleepQuality;

  /// No description provided for @mnSleepAsRegulator.
  ///
  /// In en, this message translates to:
  /// **'Sleep as Emotional Regulator'**
  String get mnSleepAsRegulator;

  /// No description provided for @mnInsomniaTendency.
  ///
  /// In en, this message translates to:
  /// **'Restless-Night Tendency'**
  String get mnInsomniaTendency;

  /// No description provided for @mnNightmareTendency.
  ///
  /// In en, this message translates to:
  /// **'Vivid-Dream Tendency'**
  String get mnNightmareTendency;

  /// No description provided for @mnSleepHygienePriority.
  ///
  /// In en, this message translates to:
  /// **'Sleep Hygiene Priority'**
  String get mnSleepHygienePriority;

  /// No description provided for @mnBurnoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Burnout & Energy'**
  String get mnBurnoutTitle;

  /// No description provided for @mnBurnoutVulnerability.
  ///
  /// In en, this message translates to:
  /// **'Burnout Sensitivity'**
  String get mnBurnoutVulnerability;

  /// No description provided for @mnBurnoutRecovery.
  ///
  /// In en, this message translates to:
  /// **'Burnout Recovery Capacity'**
  String get mnBurnoutRecovery;

  /// No description provided for @mnBurnoutStage.
  ///
  /// In en, this message translates to:
  /// **'Current Burnout Stage'**
  String get mnBurnoutStage;

  /// No description provided for @mnSelfDrivingTendency.
  ///
  /// In en, this message translates to:
  /// **'Self-Driving Tendency'**
  String get mnSelfDrivingTendency;

  /// No description provided for @mnBurnoutTriggers.
  ///
  /// In en, this message translates to:
  /// **'Burnout Triggers'**
  String get mnBurnoutTriggers;

  /// No description provided for @mnConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection & Support'**
  String get mnConnectionTitle;

  /// No description provided for @mnSocialSupport.
  ///
  /// In en, this message translates to:
  /// **'Social Support Quality'**
  String get mnSocialSupport;

  /// No description provided for @mnLonelinessVuln.
  ///
  /// In en, this message translates to:
  /// **'Loneliness Sensitivity'**
  String get mnLonelinessVuln;

  /// No description provided for @mnSolitudeNeed.
  ///
  /// In en, this message translates to:
  /// **'Need for Solitude'**
  String get mnSolitudeNeed;

  /// No description provided for @mnSocialComfort.
  ///
  /// In en, this message translates to:
  /// **'Social Comfort'**
  String get mnSocialComfort;

  /// No description provided for @mnTraumaSensitivity.
  ///
  /// In en, this message translates to:
  /// **'Trauma Sensitivity'**
  String get mnTraumaSensitivity;

  /// No description provided for @mnHealingReadiness.
  ///
  /// In en, this message translates to:
  /// **'Healing Readiness'**
  String get mnHealingReadiness;

  /// No description provided for @mnProcessingStyle.
  ///
  /// In en, this message translates to:
  /// **'Processing Style'**
  String get mnProcessingStyle;

  /// No description provided for @mnMindBodyIntegration.
  ///
  /// In en, this message translates to:
  /// **'Mind-Body Integration'**
  String get mnMindBodyIntegration;

  /// No description provided for @mnPtsdVuln.
  ///
  /// In en, this message translates to:
  /// **'Trauma-Response Sensitivity'**
  String get mnPtsdVuln;

  /// No description provided for @mnSelfAwarenessTitle.
  ///
  /// In en, this message translates to:
  /// **'Self-Awareness & Growth'**
  String get mnSelfAwarenessTitle;

  /// No description provided for @mnSelfAwarenessScore.
  ///
  /// In en, this message translates to:
  /// **'Self-Awareness'**
  String get mnSelfAwarenessScore;

  /// No description provided for @mnEmotionalVocabulary.
  ///
  /// In en, this message translates to:
  /// **'Emotional Vocabulary'**
  String get mnEmotionalVocabulary;

  /// No description provided for @mnTherapyReadiness.
  ///
  /// In en, this message translates to:
  /// **'Therapy Readiness'**
  String get mnTherapyReadiness;

  /// No description provided for @mnJournalingBenefit.
  ///
  /// In en, this message translates to:
  /// **'Journaling Benefit'**
  String get mnJournalingBenefit;

  /// No description provided for @mnInnerDialogue.
  ///
  /// In en, this message translates to:
  /// **'Inner Dialogue Quality'**
  String get mnInnerDialogue;

  /// No description provided for @mnAwarenessOfPatterns.
  ///
  /// In en, this message translates to:
  /// **'Awareness of Patterns'**
  String get mnAwarenessOfPatterns;

  /// No description provided for @mnEscapePatternVuln.
  ///
  /// In en, this message translates to:
  /// **'Escape-Pattern Sensitivity'**
  String get mnEscapePatternVuln;

  /// No description provided for @mnEscapeChannels.
  ///
  /// In en, this message translates to:
  /// **'Gently Watch For'**
  String get mnEscapeChannels;

  /// No description provided for @mnHealthyAlternatives.
  ///
  /// In en, this message translates to:
  /// **'Healthy Alternatives'**
  String get mnHealthyAlternatives;

  /// No description provided for @mnTherapyFitTitle.
  ///
  /// In en, this message translates to:
  /// **'Therapy & Support Fit'**
  String get mnTherapyFitTitle;

  /// No description provided for @mnCrisisSupportRec.
  ///
  /// In en, this message translates to:
  /// **'Support Recommendation'**
  String get mnCrisisSupportRec;

  /// No description provided for @mnSupportNetwork.
  ///
  /// In en, this message translates to:
  /// **'Activate Your Support Network'**
  String get mnSupportNetwork;

  /// No description provided for @mnSelfAdvocacy.
  ///
  /// In en, this message translates to:
  /// **'Self-Advocacy Readiness'**
  String get mnSelfAdvocacy;

  /// No description provided for @mnMedicationReceptivity.
  ///
  /// In en, this message translates to:
  /// **'Medication Receptivity'**
  String get mnMedicationReceptivity;

  /// No description provided for @mnTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Wellness Timeline'**
  String get mnTimelineTitle;

  /// No description provided for @mnPeakWellnessYears.
  ///
  /// In en, this message translates to:
  /// **'Peak Wellness Years'**
  String get mnPeakWellnessYears;

  /// No description provided for @mnExtraCareYears.
  ///
  /// In en, this message translates to:
  /// **'Years for Extra Self-Care'**
  String get mnExtraCareYears;

  /// No description provided for @mnTransformationWindows.
  ///
  /// In en, this message translates to:
  /// **'Positive Transformation Windows'**
  String get mnTransformationWindows;

  /// No description provided for @mnTherapyWindow.
  ///
  /// In en, this message translates to:
  /// **'Recommended Therapy Window'**
  String get mnTherapyWindow;

  /// No description provided for @mnPracticesTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Wellness Practices'**
  String get mnPracticesTitle;

  /// No description provided for @mnMorningPractices.
  ///
  /// In en, this message translates to:
  /// **'Morning Practices'**
  String get mnMorningPractices;

  /// No description provided for @mnEveningPractices.
  ///
  /// In en, this message translates to:
  /// **'Evening Practices'**
  String get mnEveningPractices;

  /// No description provided for @mnBreathwork.
  ///
  /// In en, this message translates to:
  /// **'Breathwork'**
  String get mnBreathwork;

  /// No description provided for @mnMovement.
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get mnMovement;

  /// No description provided for @mnNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get mnNutrition;

  /// No description provided for @mnNatureExposure.
  ///
  /// In en, this message translates to:
  /// **'Nature Exposure Need'**
  String get mnNatureExposure;

  /// No description provided for @mnDigitalDetox.
  ///
  /// In en, this message translates to:
  /// **'Digital Detox Need'**
  String get mnDigitalDetox;

  /// No description provided for @mnImprovementTitle.
  ///
  /// In en, this message translates to:
  /// **'Improvement Plan'**
  String get mnImprovementTitle;

  /// No description provided for @mnReliabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Reliability'**
  String get mnReliabilityTitle;

  /// No description provided for @mnLayerD1.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart (D1)'**
  String get mnLayerD1;

  /// No description provided for @mnLayerD9.
  ///
  /// In en, this message translates to:
  /// **'Soul Chart (D9)'**
  String get mnLayerD9;

  /// No description provided for @mnLayerD30.
  ///
  /// In en, this message translates to:
  /// **'D30 Chart'**
  String get mnLayerD30;

  /// No description provided for @mnLayerDasha.
  ///
  /// In en, this message translates to:
  /// **'Dasha Timing'**
  String get mnLayerDasha;

  /// No description provided for @mnLayerTransit.
  ///
  /// In en, this message translates to:
  /// **'Transits'**
  String get mnLayerTransit;

  /// No description provided for @mnTopicResilience.
  ///
  /// In en, this message translates to:
  /// **'How resilient am I emotionally?'**
  String get mnTopicResilience;

  /// No description provided for @mnTopicCoping.
  ///
  /// In en, this message translates to:
  /// **'What are my best coping strategies?'**
  String get mnTopicCoping;

  /// No description provided for @mnTopicSleep.
  ///
  /// In en, this message translates to:
  /// **'How can I improve my sleep?'**
  String get mnTopicSleep;

  /// No description provided for @mnTopicBurnout.
  ///
  /// In en, this message translates to:
  /// **'Am I at risk of burnout?'**
  String get mnTopicBurnout;

  /// No description provided for @mnTopicTherapy.
  ///
  /// In en, this message translates to:
  /// **'Which therapy style suits me?'**
  String get mnTopicTherapy;

  /// No description provided for @mnTopicPractices.
  ///
  /// In en, this message translates to:
  /// **'What daily practices help me most?'**
  String get mnTopicPractices;

  /// No description provided for @mnTopicTiming.
  ///
  /// In en, this message translates to:
  /// **'When are my best wellness years?'**
  String get mnTopicTiming;

  /// No description provided for @mnTopicSupport.
  ///
  /// In en, this message translates to:
  /// **'How do I build a strong support network?'**
  String get mnTopicSupport;

  /// No description provided for @lgSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Legal Report'**
  String get lgSubtitle;

  /// No description provided for @lgTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal & Disputes'**
  String get lgTitle;

  /// No description provided for @lgSnapshotHeader.
  ///
  /// In en, this message translates to:
  /// **'Legal Snapshot'**
  String get lgSnapshotHeader;

  /// No description provided for @lgResilience.
  ///
  /// In en, this message translates to:
  /// **'Legal Resilience'**
  String get lgResilience;

  /// No description provided for @lgResolutionCapacity.
  ///
  /// In en, this message translates to:
  /// **'Resolution Capacity'**
  String get lgResolutionCapacity;

  /// No description provided for @lgVictoryPotential.
  ///
  /// In en, this message translates to:
  /// **'Victory Potential'**
  String get lgVictoryPotential;

  /// No description provided for @lgLegalSafety.
  ///
  /// In en, this message translates to:
  /// **'Legal Safety'**
  String get lgLegalSafety;

  /// No description provided for @lgNegotiationSkill.
  ///
  /// In en, this message translates to:
  /// **'Negotiation Skill'**
  String get lgNegotiationSkill;

  /// No description provided for @lgStatusExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get lgStatusExcellent;

  /// No description provided for @lgStatusStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get lgStatusStrong;

  /// No description provided for @lgStatusModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get lgStatusModerate;

  /// No description provided for @lgStatusDeveloping.
  ///
  /// In en, this message translates to:
  /// **'Developing'**
  String get lgStatusDeveloping;

  /// No description provided for @lgStatusChallenging.
  ///
  /// In en, this message translates to:
  /// **'Challenging'**
  String get lgStatusChallenging;

  /// No description provided for @lgChipResolver.
  ///
  /// In en, this message translates to:
  /// **'Skilled Resolver'**
  String get lgChipResolver;

  /// No description provided for @lgChipWinner.
  ///
  /// In en, this message translates to:
  /// **'Strong Case Wins'**
  String get lgChipWinner;

  /// No description provided for @lgChipNegotiator.
  ///
  /// In en, this message translates to:
  /// **'Natural Negotiator'**
  String get lgChipNegotiator;

  /// No description provided for @lgChipDocumented.
  ///
  /// In en, this message translates to:
  /// **'Well Documented'**
  String get lgChipDocumented;

  /// No description provided for @lgChipLowRisk.
  ///
  /// In en, this message translates to:
  /// **'Low Legal Risk'**
  String get lgChipLowRisk;

  /// No description provided for @lgChipMoralAuthority.
  ///
  /// In en, this message translates to:
  /// **'Moral Authority'**
  String get lgChipMoralAuthority;

  /// No description provided for @lgChipLegalAptitude.
  ///
  /// In en, this message translates to:
  /// **'Legal Aptitude'**
  String get lgChipLegalAptitude;

  /// No description provided for @lgProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Legal Profile & Karma'**
  String get lgProfileTitle;

  /// No description provided for @lgPrimaryDriver.
  ///
  /// In en, this message translates to:
  /// **'Primary Driver'**
  String get lgPrimaryDriver;

  /// No description provided for @lgDharmaAnchor.
  ///
  /// In en, this message translates to:
  /// **'Dharma Anchor'**
  String get lgDharmaAnchor;

  /// No description provided for @lgAggressionMarker.
  ///
  /// In en, this message translates to:
  /// **'Aggression Marker'**
  String get lgAggressionMarker;

  /// No description provided for @lgDocumentationKaraka.
  ///
  /// In en, this message translates to:
  /// **'Documentation Quality'**
  String get lgDocumentationKaraka;

  /// No description provided for @lgKarakaTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Legal Planets'**
  String get lgKarakaTitle;

  /// No description provided for @lgKarakaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Which planets shape your legal fortune'**
  String get lgKarakaSubtitle;

  /// No description provided for @lgYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Yogas & Protections'**
  String get lgYogasTitle;

  /// No description provided for @lgCurrentPhase.
  ///
  /// In en, this message translates to:
  /// **'Current Phase'**
  String get lgCurrentPhase;

  /// No description provided for @lgProtections.
  ///
  /// In en, this message translates to:
  /// **'Protections'**
  String get lgProtections;

  /// No description provided for @lgDisputePressures.
  ///
  /// In en, this message translates to:
  /// **'Dispute Pressures'**
  String get lgDisputePressures;

  /// No description provided for @lgVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified Across Charts'**
  String get lgVerificationTitle;

  /// No description provided for @lgD6Litigation.
  ///
  /// In en, this message translates to:
  /// **'D6 Litigation Chart'**
  String get lgD6Litigation;

  /// No description provided for @lgD9Dharma.
  ///
  /// In en, this message translates to:
  /// **'D9 Dharma Chart'**
  String get lgD9Dharma;

  /// No description provided for @lgMoralAuthority.
  ///
  /// In en, this message translates to:
  /// **'Moral Authority'**
  String get lgMoralAuthority;

  /// No description provided for @lgVictoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Victory Analysis'**
  String get lgVictoryTitle;

  /// No description provided for @lgAsPlaintiff.
  ///
  /// In en, this message translates to:
  /// **'As Plaintiff'**
  String get lgAsPlaintiff;

  /// No description provided for @lgAsDefendant.
  ///
  /// In en, this message translates to:
  /// **'As Defendant'**
  String get lgAsDefendant;

  /// No description provided for @lgSettlementPreference.
  ///
  /// In en, this message translates to:
  /// **'Settlement Preference'**
  String get lgSettlementPreference;

  /// No description provided for @lgDisputeCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Dispute Categories Watch'**
  String get lgDisputeCategoriesTitle;

  /// No description provided for @lgLowRiskCategories.
  ///
  /// In en, this message translates to:
  /// **'Low-Risk Categories'**
  String get lgLowRiskCategories;

  /// No description provided for @lgConflictStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Conflict Style & Enemies'**
  String get lgConflictStyleTitle;

  /// No description provided for @lgConfrontationComfort.
  ///
  /// In en, this message translates to:
  /// **'Confrontation Comfort'**
  String get lgConfrontationComfort;

  /// No description provided for @lgArgumentPersuasiveness.
  ///
  /// In en, this message translates to:
  /// **'Argument Persuasiveness'**
  String get lgArgumentPersuasiveness;

  /// No description provided for @lgEmotionalRegulation.
  ///
  /// In en, this message translates to:
  /// **'Emotional Regulation'**
  String get lgEmotionalRegulation;

  /// No description provided for @lgGrudgeHolding.
  ///
  /// In en, this message translates to:
  /// **'Grudge-Holding Tendency'**
  String get lgGrudgeHolding;

  /// No description provided for @lgEnemyAnalysisLabel.
  ///
  /// In en, this message translates to:
  /// **'Enemy Analysis'**
  String get lgEnemyAnalysisLabel;

  /// No description provided for @lgVisibleEnemies.
  ///
  /// In en, this message translates to:
  /// **'Visible Enemies'**
  String get lgVisibleEnemies;

  /// No description provided for @lgHiddenEnemies.
  ///
  /// In en, this message translates to:
  /// **'Hidden Enemies'**
  String get lgHiddenEnemies;

  /// No description provided for @lgWorkplaceEnemies.
  ///
  /// In en, this message translates to:
  /// **'Workplace Enemies'**
  String get lgWorkplaceEnemies;

  /// No description provided for @lgFamilyEnemies.
  ///
  /// In en, this message translates to:
  /// **'Family Enemies'**
  String get lgFamilyEnemies;

  /// No description provided for @lgLegalEnemies.
  ///
  /// In en, this message translates to:
  /// **'Legal Enemies'**
  String get lgLegalEnemies;

  /// No description provided for @lgEnemyDefeatCapacity.
  ///
  /// In en, this message translates to:
  /// **'Enemy Defeat Capacity'**
  String get lgEnemyDefeatCapacity;

  /// No description provided for @lgCriminalFinancialTitle.
  ///
  /// In en, this message translates to:
  /// **'Criminal & Financial Risk Watch'**
  String get lgCriminalFinancialTitle;

  /// No description provided for @lgCriminalRisk.
  ///
  /// In en, this message translates to:
  /// **'Criminal Involvement Risk'**
  String get lgCriminalRisk;

  /// No description provided for @lgVictimOfCrime.
  ///
  /// In en, this message translates to:
  /// **'Victim of Crime Chance'**
  String get lgVictimOfCrime;

  /// No description provided for @lgFalseAccusation.
  ///
  /// In en, this message translates to:
  /// **'False Accusation Risk'**
  String get lgFalseAccusation;

  /// No description provided for @lgImprisonmentRisk.
  ///
  /// In en, this message translates to:
  /// **'Imprisonment Risk'**
  String get lgImprisonmentRisk;

  /// No description provided for @lgTaxDisputeRisk.
  ///
  /// In en, this message translates to:
  /// **'Tax Dispute Risk'**
  String get lgTaxDisputeRisk;

  /// No description provided for @lgFinancialFraudRisk.
  ///
  /// In en, this message translates to:
  /// **'Financial Fraud Risk'**
  String get lgFinancialFraudRisk;

  /// No description provided for @lgBusinessLitigationRisk.
  ///
  /// In en, this message translates to:
  /// **'Business Litigation Risk'**
  String get lgBusinessLitigationRisk;

  /// No description provided for @lgBankruptcyRisk.
  ///
  /// In en, this message translates to:
  /// **'Bankruptcy Risk'**
  String get lgBankruptcyRisk;

  /// No description provided for @lgAuditVulnerability.
  ///
  /// In en, this message translates to:
  /// **'Audit Vulnerability'**
  String get lgAuditVulnerability;

  /// No description provided for @lgProtectionPriority.
  ///
  /// In en, this message translates to:
  /// **'Protection Priority'**
  String get lgProtectionPriority;

  /// No description provided for @lgContractsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contracts & Negotiation'**
  String get lgContractsTitle;

  /// No description provided for @lgContractClarity.
  ///
  /// In en, this message translates to:
  /// **'Contract Clarity'**
  String get lgContractClarity;

  /// No description provided for @lgDocumentationDiscipline.
  ///
  /// In en, this message translates to:
  /// **'Documentation Discipline'**
  String get lgDocumentationDiscipline;

  /// No description provided for @lgFinePrintAwareness.
  ///
  /// In en, this message translates to:
  /// **'Fine-Print Awareness'**
  String get lgFinePrintAwareness;

  /// No description provided for @lgSignatureCaution.
  ///
  /// In en, this message translates to:
  /// **'Signature Caution'**
  String get lgSignatureCaution;

  /// No description provided for @lgMediationReceptivity.
  ///
  /// In en, this message translates to:
  /// **'Mediation Receptivity'**
  String get lgMediationReceptivity;

  /// No description provided for @lgNegotiationSkillFull.
  ///
  /// In en, this message translates to:
  /// **'Negotiation Skill'**
  String get lgNegotiationSkillFull;

  /// No description provided for @lgCompromiseWillingness.
  ///
  /// In en, this message translates to:
  /// **'Compromise Willingness'**
  String get lgCompromiseWillingness;

  /// No description provided for @lgFaceSavingNeeds.
  ///
  /// In en, this message translates to:
  /// **'Face-Saving Needs'**
  String get lgFaceSavingNeeds;

  /// No description provided for @lgMediatorHireRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Mediator Hire Recommendation'**
  String get lgMediatorHireRecommendation;

  /// No description provided for @lgTypicalContractIssues.
  ///
  /// In en, this message translates to:
  /// **'Typical Contract Issues'**
  String get lgTypicalContractIssues;

  /// No description provided for @lgCareerFitTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Career Fit'**
  String get lgCareerFitTitle;

  /// No description provided for @lgProfessionAffinity.
  ///
  /// In en, this message translates to:
  /// **'Profession Affinity'**
  String get lgProfessionAffinity;

  /// No description provided for @lgRoleFit.
  ///
  /// In en, this message translates to:
  /// **'Best Role Fit'**
  String get lgRoleFit;

  /// No description provided for @lgLawStudentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Law Student Success'**
  String get lgLawStudentSuccess;

  /// No description provided for @lgBarExamSuccess.
  ///
  /// In en, this message translates to:
  /// **'Bar Exam Success'**
  String get lgBarExamSuccess;

  /// No description provided for @lgTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Timeline'**
  String get lgTimelineTitle;

  /// No description provided for @lgNewMatterChance.
  ///
  /// In en, this message translates to:
  /// **'New Matter Chance (Next 12M)'**
  String get lgNewMatterChance;

  /// No description provided for @lgOngoingCaseOutcome.
  ///
  /// In en, this message translates to:
  /// **'Ongoing Case Outcome'**
  String get lgOngoingCaseOutcome;

  /// No description provided for @lgRecommendedAction.
  ///
  /// In en, this message translates to:
  /// **'Recommended Action'**
  String get lgRecommendedAction;

  /// No description provided for @lgPeakDisputeYears.
  ///
  /// In en, this message translates to:
  /// **'Peak Dispute Years'**
  String get lgPeakDisputeYears;

  /// No description provided for @lgClarityYears.
  ///
  /// In en, this message translates to:
  /// **'Legal Clarity Years'**
  String get lgClarityYears;

  /// No description provided for @lgAvoidancePeriods.
  ///
  /// In en, this message translates to:
  /// **'Critical Avoidance Periods'**
  String get lgAvoidancePeriods;

  /// No description provided for @lgFavorableWindows.
  ///
  /// In en, this message translates to:
  /// **'Favorable Resolution Windows'**
  String get lgFavorableWindows;

  /// No description provided for @lgRisksTitle.
  ///
  /// In en, this message translates to:
  /// **'Risks & Vulnerabilities'**
  String get lgRisksTitle;

  /// No description provided for @lgChronicVulnerabilities.
  ///
  /// In en, this message translates to:
  /// **'Chronic Vulnerabilities'**
  String get lgChronicVulnerabilities;

  /// No description provided for @lgAvoidDashaPeriods.
  ///
  /// In en, this message translates to:
  /// **'Dasha Periods to Watch'**
  String get lgAvoidDashaPeriods;

  /// No description provided for @lgPreventivePriorities.
  ///
  /// In en, this message translates to:
  /// **'Preventive Priorities'**
  String get lgPreventivePriorities;

  /// No description provided for @lgRedFlags.
  ///
  /// In en, this message translates to:
  /// **'Red-Flag Situations'**
  String get lgRedFlags;

  /// No description provided for @lgImprovementTitle.
  ///
  /// In en, this message translates to:
  /// **'Improvement Plan'**
  String get lgImprovementTitle;

  /// No description provided for @lgReliabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Reliability'**
  String get lgReliabilityTitle;

  /// No description provided for @lgLayerD1.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart (D1)'**
  String get lgLayerD1;

  /// No description provided for @lgLayerD6.
  ///
  /// In en, this message translates to:
  /// **'Litigation Chart (D6)'**
  String get lgLayerD6;

  /// No description provided for @lgLayerD9.
  ///
  /// In en, this message translates to:
  /// **'Dharma Chart (D9)'**
  String get lgLayerD9;

  /// No description provided for @lgLayerDasha.
  ///
  /// In en, this message translates to:
  /// **'Dasha Timing'**
  String get lgLayerDasha;

  /// No description provided for @lgLayerTransit.
  ///
  /// In en, this message translates to:
  /// **'Transits'**
  String get lgLayerTransit;

  /// No description provided for @lgTopicWinChance.
  ///
  /// In en, this message translates to:
  /// **'What are my winning chances?'**
  String get lgTopicWinChance;

  /// No description provided for @lgTopicStrategy.
  ///
  /// In en, this message translates to:
  /// **'Best legal strategy for me?'**
  String get lgTopicStrategy;

  /// No description provided for @lgTopicContract.
  ///
  /// In en, this message translates to:
  /// **'Contract risks to watch?'**
  String get lgTopicContract;

  /// No description provided for @lgTopicTiming.
  ///
  /// In en, this message translates to:
  /// **'Best timing to resolve disputes?'**
  String get lgTopicTiming;

  /// No description provided for @lgTopicSettlement.
  ///
  /// In en, this message translates to:
  /// **'Should I settle or fight?'**
  String get lgTopicSettlement;

  /// No description provided for @lgTopicEnemies.
  ///
  /// In en, this message translates to:
  /// **'Who are my hidden enemies?'**
  String get lgTopicEnemies;

  /// No description provided for @lgTopicProtection.
  ///
  /// In en, this message translates to:
  /// **'How to protect myself legally?'**
  String get lgTopicProtection;

  /// No description provided for @lgTopicCareer.
  ///
  /// In en, this message translates to:
  /// **'Am I suited for a legal career?'**
  String get lgTopicCareer;

  /// No description provided for @prSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Property Report'**
  String get prSubtitle;

  /// No description provided for @prTitle.
  ///
  /// In en, this message translates to:
  /// **'Property & Assets'**
  String get prTitle;

  /// No description provided for @prSnapshotHeader.
  ///
  /// In en, this message translates to:
  /// **'Property Snapshot'**
  String get prSnapshotHeader;

  /// No description provided for @prAcquisitionCapacity.
  ///
  /// In en, this message translates to:
  /// **'Acquisition Capacity'**
  String get prAcquisitionCapacity;

  /// No description provided for @prHomeOwnership.
  ///
  /// In en, this message translates to:
  /// **'Home Ownership'**
  String get prHomeOwnership;

  /// No description provided for @prWealthPotential.
  ///
  /// In en, this message translates to:
  /// **'Wealth Potential'**
  String get prWealthPotential;

  /// No description provided for @prRentalIncome.
  ///
  /// In en, this message translates to:
  /// **'Rental Income'**
  String get prRentalIncome;

  /// No description provided for @prLandOwnership.
  ///
  /// In en, this message translates to:
  /// **'Land Ownership'**
  String get prLandOwnership;

  /// No description provided for @prStatusExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get prStatusExcellent;

  /// No description provided for @prStatusStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get prStatusStrong;

  /// No description provided for @prStatusModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get prStatusModerate;

  /// No description provided for @prStatusDeveloping.
  ///
  /// In en, this message translates to:
  /// **'Developing'**
  String get prStatusDeveloping;

  /// No description provided for @prStatusChallenging.
  ///
  /// In en, this message translates to:
  /// **'Challenging'**
  String get prStatusChallenging;

  /// No description provided for @prChipHomeOwner.
  ///
  /// In en, this message translates to:
  /// **'Home Owner'**
  String get prChipHomeOwner;

  /// No description provided for @prChipWealthBuilder.
  ///
  /// In en, this message translates to:
  /// **'Wealth Builder'**
  String get prChipWealthBuilder;

  /// No description provided for @prChipLandOwner.
  ///
  /// In en, this message translates to:
  /// **'Land Owner'**
  String get prChipLandOwner;

  /// No description provided for @prChipInvestor.
  ///
  /// In en, this message translates to:
  /// **'Property Investor'**
  String get prChipInvestor;

  /// No description provided for @prChipInheritance.
  ///
  /// In en, this message translates to:
  /// **'Inheritance Likely'**
  String get prChipInheritance;

  /// No description provided for @prChipVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Owner'**
  String get prChipVehicle;

  /// No description provided for @prChipGlobalAsset.
  ///
  /// In en, this message translates to:
  /// **'Global Asset Affinity'**
  String get prChipGlobalAsset;

  /// No description provided for @prProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Property Style'**
  String get prProfileTitle;

  /// No description provided for @prHomeAesthetics.
  ///
  /// In en, this message translates to:
  /// **'Home Aesthetics'**
  String get prHomeAesthetics;

  /// No description provided for @prHomeSanctuary.
  ///
  /// In en, this message translates to:
  /// **'Home as Sanctuary'**
  String get prHomeSanctuary;

  /// No description provided for @prComfortInvestment.
  ///
  /// In en, this message translates to:
  /// **'Comfort Investment'**
  String get prComfortInvestment;

  /// No description provided for @prVastuPriority.
  ///
  /// In en, this message translates to:
  /// **'Vastu Priority'**
  String get prVastuPriority;

  /// No description provided for @prNaturalElements.
  ///
  /// In en, this message translates to:
  /// **'Natural Elements'**
  String get prNaturalElements;

  /// No description provided for @prNextActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Next Action'**
  String get prNextActionLabel;

  /// No description provided for @prKarakaTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Property Planets'**
  String get prKarakaTitle;

  /// No description provided for @prKarakaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Which planets shape your property luck'**
  String get prKarakaSubtitle;

  /// No description provided for @prPrimaryKaraka.
  ///
  /// In en, this message translates to:
  /// **'Primary Karaka'**
  String get prPrimaryKaraka;

  /// No description provided for @prDurableAsset.
  ///
  /// In en, this message translates to:
  /// **'Durable Asset Karaka'**
  String get prDurableAsset;

  /// No description provided for @prYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Property Yogas & Doshas'**
  String get prYogasTitle;

  /// No description provided for @prCurrentPhase.
  ///
  /// In en, this message translates to:
  /// **'Current Phase'**
  String get prCurrentPhase;

  /// No description provided for @prBoosters.
  ///
  /// In en, this message translates to:
  /// **'Boosters'**
  String get prBoosters;

  /// No description provided for @prDrains.
  ///
  /// In en, this message translates to:
  /// **'Drains'**
  String get prDrains;

  /// No description provided for @prVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified Across Charts'**
  String get prVerificationTitle;

  /// No description provided for @prD4Property.
  ///
  /// In en, this message translates to:
  /// **'D4 Property Chart'**
  String get prD4Property;

  /// No description provided for @prD16Vehicle.
  ///
  /// In en, this message translates to:
  /// **'D16 Vehicle Chart'**
  String get prD16Vehicle;

  /// No description provided for @prVehicleFit.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Fit'**
  String get prVehicleFit;

  /// No description provided for @prJourneyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ownership Journey & Timeline'**
  String get prJourneyTitle;

  /// No description provided for @prFirstHomeAge.
  ///
  /// In en, this message translates to:
  /// **'First Home Age'**
  String get prFirstHomeAge;

  /// No description provided for @prFirstHomeType.
  ///
  /// In en, this message translates to:
  /// **'First Home Type'**
  String get prFirstHomeType;

  /// No description provided for @prMultipleHomes.
  ///
  /// In en, this message translates to:
  /// **'Multiple Homes'**
  String get prMultipleHomes;

  /// No description provided for @prNewPropertySoon.
  ///
  /// In en, this message translates to:
  /// **'New Property Soon'**
  String get prNewPropertySoon;

  /// No description provided for @prFirstMajorWindow.
  ///
  /// In en, this message translates to:
  /// **'First Major Window'**
  String get prFirstMajorWindow;

  /// No description provided for @prBuyingWindow.
  ///
  /// In en, this message translates to:
  /// **'Buying Window'**
  String get prBuyingWindow;

  /// No description provided for @prConstructionWindow.
  ///
  /// In en, this message translates to:
  /// **'Construction Window'**
  String get prConstructionWindow;

  /// No description provided for @prNextOpportunity.
  ///
  /// In en, this message translates to:
  /// **'Next Opportunity'**
  String get prNextOpportunity;

  /// No description provided for @prLifetimePropertyCount.
  ///
  /// In en, this message translates to:
  /// **'Lifetime Property Count'**
  String get prLifetimePropertyCount;

  /// No description provided for @prInheritanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Inheritance & Family Property'**
  String get prInheritanceTitle;

  /// No description provided for @prMaternalInheritance.
  ///
  /// In en, this message translates to:
  /// **'Maternal Inheritance'**
  String get prMaternalInheritance;

  /// No description provided for @prPaternalInheritance.
  ///
  /// In en, this message translates to:
  /// **'Paternal Inheritance'**
  String get prPaternalInheritance;

  /// No description provided for @prAncestralProperty.
  ///
  /// In en, this message translates to:
  /// **'Ancestral Property'**
  String get prAncestralProperty;

  /// No description provided for @prFamilyDisputeRisk.
  ///
  /// In en, this message translates to:
  /// **'Family Dispute Risk'**
  String get prFamilyDisputeRisk;

  /// No description provided for @prInheritanceTiming.
  ///
  /// In en, this message translates to:
  /// **'Inheritance Timing'**
  String get prInheritanceTiming;

  /// No description provided for @prInheritanceType.
  ///
  /// In en, this message translates to:
  /// **'Inheritance Type'**
  String get prInheritanceType;

  /// No description provided for @prLandInvestTitle.
  ///
  /// In en, this message translates to:
  /// **'Land, Investment & Global Property'**
  String get prLandInvestTitle;

  /// No description provided for @prPropertyInvestor.
  ///
  /// In en, this message translates to:
  /// **'Property Investor Score'**
  String get prPropertyInvestor;

  /// No description provided for @prAppreciationLuck.
  ///
  /// In en, this message translates to:
  /// **'Appreciation Luck'**
  String get prAppreciationLuck;

  /// No description provided for @prInvestorMindset.
  ///
  /// In en, this message translates to:
  /// **'Investor Mindset'**
  String get prInvestorMindset;

  /// No description provided for @prLandType.
  ///
  /// In en, this message translates to:
  /// **'Land Type'**
  String get prLandType;

  /// No description provided for @prRentalCount.
  ///
  /// In en, this message translates to:
  /// **'Rental Property Count'**
  String get prRentalCount;

  /// No description provided for @prMultipleLand.
  ///
  /// In en, this message translates to:
  /// **'Multiple Land Parcels'**
  String get prMultipleLand;

  /// No description provided for @prFarmEstate.
  ///
  /// In en, this message translates to:
  /// **'Farm / Estate Chance'**
  String get prFarmEstate;

  /// No description provided for @prGlobalPropertyLabel.
  ///
  /// In en, this message translates to:
  /// **'Global Property'**
  String get prGlobalPropertyLabel;

  /// No description provided for @prForeignProperty.
  ///
  /// In en, this message translates to:
  /// **'Foreign Property'**
  String get prForeignProperty;

  /// No description provided for @prNriAffinity.
  ///
  /// In en, this message translates to:
  /// **'NRI Asset Affinity'**
  String get prNriAffinity;

  /// No description provided for @prVehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get prVehiclesTitle;

  /// No description provided for @prVehicleCount.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Count'**
  String get prVehicleCount;

  /// No description provided for @prVehicleFirstAge.
  ///
  /// In en, this message translates to:
  /// **'First Vehicle Age'**
  String get prVehicleFirstAge;

  /// No description provided for @prVehicleCategory.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Category'**
  String get prVehicleCategory;

  /// No description provided for @prVehicleQuality.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Quality'**
  String get prVehicleQuality;

  /// No description provided for @prLuxuryAffinity.
  ///
  /// In en, this message translates to:
  /// **'Luxury Affinity'**
  String get prLuxuryAffinity;

  /// No description provided for @prVehicleLossRisk.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Loss / Damage Risk'**
  String get prVehicleLossRisk;

  /// No description provided for @prLegalRiskTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal & Risk Watch'**
  String get prLegalRiskTitle;

  /// No description provided for @prBoundaryDisputes.
  ///
  /// In en, this message translates to:
  /// **'Boundary Disputes'**
  String get prBoundaryDisputes;

  /// No description provided for @prPartitionDisputes.
  ///
  /// In en, this message translates to:
  /// **'Partition Disputes'**
  String get prPartitionDisputes;

  /// No description provided for @prTitleIssues.
  ///
  /// In en, this message translates to:
  /// **'Title / Documentation Issues'**
  String get prTitleIssues;

  /// No description provided for @prTenantConflict.
  ///
  /// In en, this message translates to:
  /// **'Tenant-Landlord Conflict'**
  String get prTenantConflict;

  /// No description provided for @prForcedSale.
  ///
  /// In en, this message translates to:
  /// **'Forced Sale Risk'**
  String get prForcedSale;

  /// No description provided for @prPropertyDamage.
  ///
  /// In en, this message translates to:
  /// **'Property Damage Risk'**
  String get prPropertyDamage;

  /// No description provided for @prInsurancePriority.
  ///
  /// In en, this message translates to:
  /// **'Insurance Priority'**
  String get prInsurancePriority;

  /// No description provided for @prProtectionUrgency.
  ///
  /// In en, this message translates to:
  /// **'Protection Urgency'**
  String get prProtectionUrgency;

  /// No description provided for @prProtectiveFactors.
  ///
  /// In en, this message translates to:
  /// **'Protective Factors'**
  String get prProtectiveFactors;

  /// No description provided for @prChronicVulnerabilities.
  ///
  /// In en, this message translates to:
  /// **'Chronic Vulnerabilities'**
  String get prChronicVulnerabilities;

  /// No description provided for @prDueDiligenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Due Diligence Checklist'**
  String get prDueDiligenceTitle;

  /// No description provided for @prPreventiveMeasures.
  ///
  /// In en, this message translates to:
  /// **'Preventive Measures'**
  String get prPreventiveMeasures;

  /// No description provided for @prImprovementTitle.
  ///
  /// In en, this message translates to:
  /// **'Improvement Plan'**
  String get prImprovementTitle;

  /// No description provided for @prReliabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Reliability'**
  String get prReliabilityTitle;

  /// No description provided for @prLayerD1.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart (D1)'**
  String get prLayerD1;

  /// No description provided for @prLayerD4.
  ///
  /// In en, this message translates to:
  /// **'Property Chart (D4)'**
  String get prLayerD4;

  /// No description provided for @prLayerD16.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Chart (D16)'**
  String get prLayerD16;

  /// No description provided for @prLayerDasha.
  ///
  /// In en, this message translates to:
  /// **'Dasha Timing'**
  String get prLayerDasha;

  /// No description provided for @prLayerTransit.
  ///
  /// In en, this message translates to:
  /// **'Transits'**
  String get prLayerTransit;

  /// No description provided for @prTopicBuying.
  ///
  /// In en, this message translates to:
  /// **'Best time to buy?'**
  String get prTopicBuying;

  /// No description provided for @prTopicInherit.
  ///
  /// In en, this message translates to:
  /// **'Will I inherit property?'**
  String get prTopicInherit;

  /// No description provided for @prTopicVehicle.
  ///
  /// In en, this message translates to:
  /// **'When will I get a vehicle?'**
  String get prTopicVehicle;

  /// No description provided for @prTopicRental.
  ///
  /// In en, this message translates to:
  /// **'Rental income potential?'**
  String get prTopicRental;

  /// No description provided for @prTopicLand.
  ///
  /// In en, this message translates to:
  /// **'Land ownership chances?'**
  String get prTopicLand;

  /// No description provided for @prTopicLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal risks to watch?'**
  String get prTopicLegal;

  /// No description provided for @prTopicForeign.
  ///
  /// In en, this message translates to:
  /// **'Foreign property chances?'**
  String get prTopicForeign;

  /// No description provided for @prTopicTiming.
  ///
  /// In en, this message translates to:
  /// **'Best property timing windows?'**
  String get prTopicTiming;

  /// No description provided for @edTitle.
  ///
  /// In en, this message translates to:
  /// **'Education & Learning Analysis'**
  String get edTitle;

  /// No description provided for @edSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Education Report'**
  String get edSubtitle;

  /// No description provided for @edSnapshotHeader.
  ///
  /// In en, this message translates to:
  /// **'Your Education Snapshot'**
  String get edSnapshotHeader;

  /// No description provided for @edOverallStrength.
  ///
  /// In en, this message translates to:
  /// **'Overall Strength'**
  String get edOverallStrength;

  /// No description provided for @edAcademicSuccess.
  ///
  /// In en, this message translates to:
  /// **'Academic Success'**
  String get edAcademicSuccess;

  /// No description provided for @edLearningCapacity.
  ///
  /// In en, this message translates to:
  /// **'Learning Capacity'**
  String get edLearningCapacity;

  /// No description provided for @edIntellect.
  ///
  /// In en, this message translates to:
  /// **'Intellect'**
  String get edIntellect;

  /// No description provided for @edMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get edMemory;

  /// No description provided for @edStatusExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent Potential'**
  String get edStatusExcellent;

  /// No description provided for @edStatusStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong Potential'**
  String get edStatusStrong;

  /// No description provided for @edStatusModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate Potential'**
  String get edStatusModerate;

  /// No description provided for @edStatusDeveloping.
  ///
  /// In en, this message translates to:
  /// **'Developing Potential'**
  String get edStatusDeveloping;

  /// No description provided for @edStatusChallenging.
  ///
  /// In en, this message translates to:
  /// **'Challenging Phase'**
  String get edStatusChallenging;

  /// No description provided for @edChipSaraswati.
  ///
  /// In en, this message translates to:
  /// **'Saraswati Yoga'**
  String get edChipSaraswati;

  /// No description provided for @edChipGajaKesari.
  ///
  /// In en, this message translates to:
  /// **'Gaja Kesari Yoga'**
  String get edChipGajaKesari;

  /// No description provided for @edChipBudhaAditya.
  ///
  /// In en, this message translates to:
  /// **'Budha Aditya Yoga'**
  String get edChipBudhaAditya;

  /// No description provided for @edChipResearch.
  ///
  /// In en, this message translates to:
  /// **'Strong Research Ability'**
  String get edChipResearch;

  /// No description provided for @edChipScholarship.
  ///
  /// In en, this message translates to:
  /// **'Scholarship Potential'**
  String get edChipScholarship;

  /// No description provided for @edChipDoctorate.
  ///
  /// In en, this message translates to:
  /// **'Doctorate Potential'**
  String get edChipDoctorate;

  /// No description provided for @edChipForeign.
  ///
  /// In en, this message translates to:
  /// **'Foreign Education Support'**
  String get edChipForeign;

  /// No description provided for @edChipLifelong.
  ///
  /// In en, this message translates to:
  /// **'Lifelong Learner'**
  String get edChipLifelong;

  /// No description provided for @edLearningStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Learning Style'**
  String get edLearningStyleTitle;

  /// No description provided for @edSoulPlanet.
  ///
  /// In en, this message translates to:
  /// **'Soul Planet'**
  String get edSoulPlanet;

  /// No description provided for @edSoulHint.
  ///
  /// In en, this message translates to:
  /// **'Your deepest inner drive and life purpose'**
  String get edSoulHint;

  /// No description provided for @edSubjectPlanet.
  ///
  /// In en, this message translates to:
  /// **'Subject Planet'**
  String get edSubjectPlanet;

  /// No description provided for @edTechAtmakaraka.
  ///
  /// In en, this message translates to:
  /// **'Atmakaraka (technical)'**
  String get edTechAtmakaraka;

  /// No description provided for @edTechAmatyakaraka.
  ///
  /// In en, this message translates to:
  /// **'Amatyakaraka (technical)'**
  String get edTechAmatyakaraka;

  /// No description provided for @edSubjectKarakaStrength.
  ///
  /// In en, this message translates to:
  /// **'Subject Karaka Strength'**
  String get edSubjectKarakaStrength;

  /// No description provided for @edFoundationTitle.
  ///
  /// In en, this message translates to:
  /// **'Education Foundation'**
  String get edFoundationTitle;

  /// No description provided for @edHouse4.
  ///
  /// In en, this message translates to:
  /// **'Early Schooling'**
  String get edHouse4;

  /// No description provided for @edHouse5.
  ///
  /// In en, this message translates to:
  /// **'Intelligence'**
  String get edHouse5;

  /// No description provided for @edHouse9.
  ///
  /// In en, this message translates to:
  /// **'Higher Learning'**
  String get edHouse9;

  /// No description provided for @edPurvaPunya.
  ///
  /// In en, this message translates to:
  /// **'Past-Life Merit'**
  String get edPurvaPunya;

  /// No description provided for @edStudyPlanetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Study Planets'**
  String get edStudyPlanetsTitle;

  /// No description provided for @edYogasTitle.
  ///
  /// In en, this message translates to:
  /// **'Education Yogas in Your Chart'**
  String get edYogasTitle;

  /// No description provided for @edYogaBudhaAditya.
  ///
  /// In en, this message translates to:
  /// **'Budha Aditya'**
  String get edYogaBudhaAditya;

  /// No description provided for @edYogaGajaKesari.
  ///
  /// In en, this message translates to:
  /// **'Gaja Kesari'**
  String get edYogaGajaKesari;

  /// No description provided for @edYogaSaraswati.
  ///
  /// In en, this message translates to:
  /// **'Saraswati'**
  String get edYogaSaraswati;

  /// No description provided for @edYogaPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get edYogaPresent;

  /// No description provided for @edYogaAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get edYogaAbsent;

  /// No description provided for @edYogaNoneNote.
  ///
  /// In en, this message translates to:
  /// **'No classical education yogas — success comes from consistent effort and discipline.'**
  String get edYogaNoneNote;

  /// No description provided for @edVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Across Charts'**
  String get edVerificationTitle;

  /// No description provided for @edD24Learning.
  ///
  /// In en, this message translates to:
  /// **'D24 — Deep Learning Chart'**
  String get edD24Learning;

  /// No description provided for @edD4Formal.
  ///
  /// In en, this message translates to:
  /// **'D4 — Formal Education Chart'**
  String get edD4Formal;

  /// No description provided for @edD9Dharma.
  ///
  /// In en, this message translates to:
  /// **'D9 — Learning Dharma Chart'**
  String get edD9Dharma;

  /// No description provided for @edD60Karma.
  ///
  /// In en, this message translates to:
  /// **'D60 — Past-Life Learning Karma'**
  String get edD60Karma;

  /// No description provided for @edSubjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Best Subjects For You'**
  String get edSubjectsTitle;

  /// No description provided for @edSubjectsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ranked by chart affinity'**
  String get edSubjectsSubtitle;

  /// No description provided for @edLowAffinity.
  ///
  /// In en, this message translates to:
  /// **'Lower-Affinity Subjects'**
  String get edLowAffinity;

  /// No description provided for @edDegreesTitle.
  ///
  /// In en, this message translates to:
  /// **'Degree & Level Likelihood'**
  String get edDegreesTitle;

  /// No description provided for @edExpectedLevel.
  ///
  /// In en, this message translates to:
  /// **'Expected Level'**
  String get edExpectedLevel;

  /// No description provided for @edDegreeFormal.
  ///
  /// In en, this message translates to:
  /// **'Formal Degree'**
  String get edDegreeFormal;

  /// No description provided for @edDegreePostgrad.
  ///
  /// In en, this message translates to:
  /// **'Postgraduate'**
  String get edDegreePostgrad;

  /// No description provided for @edDegreeDoctorate.
  ///
  /// In en, this message translates to:
  /// **'Doctorate'**
  String get edDegreeDoctorate;

  /// No description provided for @edDegreeForeign.
  ///
  /// In en, this message translates to:
  /// **'Foreign Education'**
  String get edDegreeForeign;

  /// No description provided for @edTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Timeline'**
  String get edTimelineTitle;

  /// No description provided for @edEarlySchooling.
  ///
  /// In en, this message translates to:
  /// **'Early Schooling Window'**
  String get edEarlySchooling;

  /// No description provided for @edHigherEducation.
  ///
  /// In en, this message translates to:
  /// **'Higher Education Window'**
  String get edHigherEducation;

  /// No description provided for @edPostgradResearch.
  ///
  /// In en, this message translates to:
  /// **'Postgrad / Research Window'**
  String get edPostgradResearch;

  /// No description provided for @edPeakLearningAge.
  ///
  /// In en, this message translates to:
  /// **'Peak Learning Age'**
  String get edPeakLearningAge;

  /// No description provided for @edPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning Preferences & Support'**
  String get edPreferencesTitle;

  /// No description provided for @edPrefStudyMode.
  ///
  /// In en, this message translates to:
  /// **'Study Mode'**
  String get edPrefStudyMode;

  /// No description provided for @edPrefTiming.
  ///
  /// In en, this message translates to:
  /// **'Best Time'**
  String get edPrefTiming;

  /// No description provided for @edPrefEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get edPrefEnvironment;

  /// No description provided for @edPrefLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get edPrefLocation;

  /// No description provided for @edPrefForeign.
  ///
  /// In en, this message translates to:
  /// **'Foreign Study'**
  String get edPrefForeign;

  /// No description provided for @edGuruRelationship.
  ///
  /// In en, this message translates to:
  /// **'Teacher/Guru Bond'**
  String get edGuruRelationship;

  /// No description provided for @edMentorAvailability.
  ///
  /// In en, this message translates to:
  /// **'Mentor Availability'**
  String get edMentorAvailability;

  /// No description provided for @edPeerLearning.
  ///
  /// In en, this message translates to:
  /// **'Peer Learning'**
  String get edPeerLearning;

  /// No description provided for @edAuthorityDeference.
  ///
  /// In en, this message translates to:
  /// **'Respect for Authority'**
  String get edAuthorityDeference;

  /// No description provided for @edStrengthsTitle.
  ///
  /// In en, this message translates to:
  /// **'Strengths & Challenges'**
  String get edStrengthsTitle;

  /// No description provided for @edCognitiveGifts.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Gifts'**
  String get edCognitiveGifts;

  /// No description provided for @edNaturalAbilities.
  ///
  /// In en, this message translates to:
  /// **'Natural Learning Abilities'**
  String get edNaturalAbilities;

  /// No description provided for @edHiddenCapacities.
  ///
  /// In en, this message translates to:
  /// **'Hidden Capacities'**
  String get edHiddenCapacities;

  /// No description provided for @edConcentration.
  ///
  /// In en, this message translates to:
  /// **'Concentration Difficulty'**
  String get edConcentration;

  /// No description provided for @edBreakRisk.
  ///
  /// In en, this message translates to:
  /// **'Education Break Risk'**
  String get edBreakRisk;

  /// No description provided for @edDisciplineConsistency.
  ///
  /// In en, this message translates to:
  /// **'Discipline Consistency'**
  String get edDisciplineConsistency;

  /// No description provided for @edScholarshipLikelihood.
  ///
  /// In en, this message translates to:
  /// **'Scholarship Likelihood'**
  String get edScholarshipLikelihood;

  /// No description provided for @edCareerLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Education → Career Path'**
  String get edCareerLinkTitle;

  /// No description provided for @edDirectionRec.
  ///
  /// In en, this message translates to:
  /// **'Recommended Direction'**
  String get edDirectionRec;

  /// No description provided for @edIntegrationStrategy.
  ///
  /// In en, this message translates to:
  /// **'Integration Strategy'**
  String get edIntegrationStrategy;

  /// No description provided for @edCareerLinkage.
  ///
  /// In en, this message translates to:
  /// **'Career Linkage'**
  String get edCareerLinkage;

  /// No description provided for @edAlignedSubjects.
  ///
  /// In en, this message translates to:
  /// **'Career-Aligned Subjects'**
  String get edAlignedSubjects;

  /// No description provided for @edDegreeUtility.
  ///
  /// In en, this message translates to:
  /// **'Degree Utility for Career'**
  String get edDegreeUtility;

  /// No description provided for @edImprovementTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Improvement Plan'**
  String get edImprovementTitle;

  /// No description provided for @edReliabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Prediction Reliability'**
  String get edReliabilityTitle;

  /// No description provided for @edLayerD1.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart (D1)'**
  String get edLayerD1;

  /// No description provided for @edLayerD4.
  ///
  /// In en, this message translates to:
  /// **'Formal Education (D4)'**
  String get edLayerD4;

  /// No description provided for @edLayerD9.
  ///
  /// In en, this message translates to:
  /// **'Navamsa (D9)'**
  String get edLayerD9;

  /// No description provided for @edLayerD24.
  ///
  /// In en, this message translates to:
  /// **'Deep Learning (D24)'**
  String get edLayerD24;

  /// No description provided for @edLayerD60.
  ///
  /// In en, this message translates to:
  /// **'Past-Life Learning (D60)'**
  String get edLayerD60;

  /// No description provided for @edLayerAmk.
  ///
  /// In en, this message translates to:
  /// **'Subject Karaka'**
  String get edLayerAmk;

  /// No description provided for @edLayerMj.
  ///
  /// In en, this message translates to:
  /// **'Mercury-Jupiter'**
  String get edLayerMj;

  /// No description provided for @edLayerDasha.
  ///
  /// In en, this message translates to:
  /// **'Planetary Timing'**
  String get edLayerDasha;

  /// No description provided for @edTopicSubjects.
  ///
  /// In en, this message translates to:
  /// **'Best Subjects for Me'**
  String get edTopicSubjects;

  /// No description provided for @edTopicDegree.
  ///
  /// In en, this message translates to:
  /// **'Degree Chances'**
  String get edTopicDegree;

  /// No description provided for @edTopicAbroad.
  ///
  /// In en, this message translates to:
  /// **'Studying Abroad'**
  String get edTopicAbroad;

  /// No description provided for @edTopicExam.
  ///
  /// In en, this message translates to:
  /// **'Exam Performance'**
  String get edTopicExam;

  /// No description provided for @edTopicHabits.
  ///
  /// In en, this message translates to:
  /// **'Study Habits'**
  String get edTopicHabits;

  /// No description provided for @edTopicCareerLink.
  ///
  /// In en, this message translates to:
  /// **'Education-to-Career Link'**
  String get edTopicCareerLink;

  /// No description provided for @edTopicTiming.
  ///
  /// In en, this message translates to:
  /// **'Education Timing Windows'**
  String get edTopicTiming;

  /// No description provided for @edTopicScholarship.
  ///
  /// In en, this message translates to:
  /// **'Scholarship Chances'**
  String get edTopicScholarship;

  /// No description provided for @hwTitle.
  ///
  /// In en, this message translates to:
  /// **'Health & Wellness Analysis'**
  String get hwTitle;

  /// No description provided for @hwSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Health & Wellness Report'**
  String get hwSubtitle;

  /// No description provided for @hwSnapshotHeader.
  ///
  /// In en, this message translates to:
  /// **'Your Health Snapshot'**
  String get hwSnapshotHeader;

  /// No description provided for @hwOverallVitality.
  ///
  /// In en, this message translates to:
  /// **'Vitality'**
  String get hwOverallVitality;

  /// No description provided for @hwImmunity.
  ///
  /// In en, this message translates to:
  /// **'Immunity'**
  String get hwImmunity;

  /// No description provided for @hwRecovery.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get hwRecovery;

  /// No description provided for @hwMentalWellness.
  ///
  /// In en, this message translates to:
  /// **'Mental Wellness'**
  String get hwMentalWellness;

  /// No description provided for @hwStressTolerance.
  ///
  /// In en, this message translates to:
  /// **'Stress Tolerance'**
  String get hwStressTolerance;

  /// No description provided for @hwStatusThriving.
  ///
  /// In en, this message translates to:
  /// **'Thriving'**
  String get hwStatusThriving;

  /// No description provided for @hwStatusGood.
  ///
  /// In en, this message translates to:
  /// **'Good Vitality'**
  String get hwStatusGood;

  /// No description provided for @hwStatusBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get hwStatusBalanced;

  /// No description provided for @hwStatusNeedsCare.
  ///
  /// In en, this message translates to:
  /// **'Needs Care'**
  String get hwStatusNeedsCare;

  /// No description provided for @hwStatusNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs Attention'**
  String get hwStatusNeedsAttention;

  /// No description provided for @hwChipImmunity.
  ///
  /// In en, this message translates to:
  /// **'Strong Immunity'**
  String get hwChipImmunity;

  /// No description provided for @hwChipRecovery.
  ///
  /// In en, this message translates to:
  /// **'Fast Recovery'**
  String get hwChipRecovery;

  /// No description provided for @hwChipMentalBalance.
  ///
  /// In en, this message translates to:
  /// **'Balanced Mind'**
  String get hwChipMentalBalance;

  /// No description provided for @hwChipStressResilience.
  ///
  /// In en, this message translates to:
  /// **'Stress Resilient'**
  String get hwChipStressResilience;

  /// No description provided for @hwChipFertility.
  ///
  /// In en, this message translates to:
  /// **'Fertility Support'**
  String get hwChipFertility;

  /// No description provided for @hwChipWorkLife.
  ///
  /// In en, this message translates to:
  /// **'Good Work-Life Balance'**
  String get hwChipWorkLife;

  /// No description provided for @hwChipLowAddiction.
  ///
  /// In en, this message translates to:
  /// **'Low Addiction Risk'**
  String get hwChipLowAddiction;

  /// No description provided for @hwConstitutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Body Type'**
  String get hwConstitutionTitle;

  /// No description provided for @hwConstitutionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ayurvedic constitution from your chart'**
  String get hwConstitutionSubtitle;

  /// No description provided for @hwDominantDosha.
  ///
  /// In en, this message translates to:
  /// **'Dominant'**
  String get hwDominantDosha;

  /// No description provided for @hwSecondaryDosha.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get hwSecondaryDosha;

  /// No description provided for @hwPrimaryKaraka.
  ///
  /// In en, this message translates to:
  /// **'Main Health Indicator'**
  String get hwPrimaryKaraka;

  /// No description provided for @hwStrongestSystem.
  ///
  /// In en, this message translates to:
  /// **'Strongest System'**
  String get hwStrongestSystem;

  /// No description provided for @hwWeakestSystem.
  ///
  /// In en, this message translates to:
  /// **'System to Support'**
  String get hwWeakestSystem;

  /// No description provided for @hwBodyMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Body\'s Planetary Map'**
  String get hwBodyMapTitle;

  /// No description provided for @hwBodyMapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'9 planets, 9 body systems'**
  String get hwBodyMapSubtitle;

  /// No description provided for @hwYogaTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Patterns in Your Chart'**
  String get hwYogaTitle;

  /// No description provided for @hwYogaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Protective vs disease-pressure yogas'**
  String get hwYogaSubtitle;

  /// No description provided for @hwDiseasePressureLabel.
  ///
  /// In en, this message translates to:
  /// **'DISEASE PRESSURE'**
  String get hwDiseasePressureLabel;

  /// No description provided for @hwAreasTitle.
  ///
  /// In en, this message translates to:
  /// **'Body Areas to Watch'**
  String get hwAreasTitle;

  /// No description provided for @hwAreasSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vulnerability by body zone'**
  String get hwAreasSubtitle;

  /// No description provided for @hwProtectedAreas.
  ///
  /// In en, this message translates to:
  /// **'Well-Protected Areas'**
  String get hwProtectedAreas;

  /// No description provided for @hwCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Disease-Category Watch'**
  String get hwCategoriesTitle;

  /// No description provided for @hwCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Susceptibility across major health categories'**
  String get hwCategoriesSubtitle;

  /// No description provided for @hwLowRiskCategories.
  ///
  /// In en, this message translates to:
  /// **'Low-Risk Categories'**
  String get hwLowRiskCategories;

  /// No description provided for @hwMentalTitle.
  ///
  /// In en, this message translates to:
  /// **'Mental & Emotional Wellness'**
  String get hwMentalTitle;

  /// No description provided for @hwMentalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Emotional resilience and support needs'**
  String get hwMentalSubtitle;

  /// No description provided for @hwMentalVulnerability.
  ///
  /// In en, this message translates to:
  /// **'Emotional Sensitivity'**
  String get hwMentalVulnerability;

  /// No description provided for @hwEmotionalRegulation.
  ///
  /// In en, this message translates to:
  /// **'Emotional Regulation'**
  String get hwEmotionalRegulation;

  /// No description provided for @hwSupportRec.
  ///
  /// In en, this message translates to:
  /// **'Support Recommendation'**
  String get hwSupportRec;

  /// No description provided for @hwTendencies.
  ///
  /// In en, this message translates to:
  /// **'Mental Tendencies'**
  String get hwTendencies;

  /// No description provided for @hwTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Timeline'**
  String get hwTimelineTitle;

  /// No description provided for @hwTimelineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Peak years, caution years & recovery windows'**
  String get hwTimelineSubtitle;

  /// No description provided for @hwPeakYears.
  ///
  /// In en, this message translates to:
  /// **'Peak Wellness Years'**
  String get hwPeakYears;

  /// No description provided for @hwCautionYears.
  ///
  /// In en, this message translates to:
  /// **'Caution Years'**
  String get hwCautionYears;

  /// No description provided for @hwRecoveryWindow.
  ///
  /// In en, this message translates to:
  /// **'Recovery Window'**
  String get hwRecoveryWindow;

  /// No description provided for @hwCheckupYears.
  ///
  /// In en, this message translates to:
  /// **'Recommended Check-up Years'**
  String get hwCheckupYears;

  /// No description provided for @hwCurrentPhase.
  ///
  /// In en, this message translates to:
  /// **'Current Phase'**
  String get hwCurrentPhase;

  /// No description provided for @hwLifestyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Lifestyle Guide'**
  String get hwLifestyleTitle;

  /// No description provided for @hwLifestyleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What your chart says about daily habits'**
  String get hwLifestyleSubtitle;

  /// No description provided for @hwSleepDiscipline.
  ///
  /// In en, this message translates to:
  /// **'Sleep Discipline Impact'**
  String get hwSleepDiscipline;

  /// No description provided for @hwDietDiscipline.
  ///
  /// In en, this message translates to:
  /// **'Diet Discipline Impact'**
  String get hwDietDiscipline;

  /// No description provided for @hwExerciseNeed.
  ///
  /// In en, this message translates to:
  /// **'Exercise Need'**
  String get hwExerciseNeed;

  /// No description provided for @hwSunlightNeed.
  ///
  /// In en, this message translates to:
  /// **'Sunlight Need'**
  String get hwSunlightNeed;

  /// No description provided for @hwStressSusceptibility.
  ///
  /// In en, this message translates to:
  /// **'Stress Susceptibility'**
  String get hwStressSusceptibility;

  /// No description provided for @hwHydrationSensitivity.
  ///
  /// In en, this message translates to:
  /// **'Hydration Sensitivity'**
  String get hwHydrationSensitivity;

  /// No description provided for @hwSocialType.
  ///
  /// In en, this message translates to:
  /// **'Social Energy Type'**
  String get hwSocialType;

  /// No description provided for @hwHealingSpeed.
  ///
  /// In en, this message translates to:
  /// **'Healing Speed'**
  String get hwHealingSpeed;

  /// No description provided for @hwTreatmentResponse.
  ///
  /// In en, this message translates to:
  /// **'Treatment Response'**
  String get hwTreatmentResponse;

  /// No description provided for @hwAltHealing.
  ///
  /// In en, this message translates to:
  /// **'Alternative Healing Affinity'**
  String get hwAltHealing;

  /// No description provided for @hwSpecialTitle.
  ///
  /// In en, this message translates to:
  /// **'Life-Stage & Special Topics'**
  String get hwSpecialTitle;

  /// No description provided for @hwSpecialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fertility, childhood health, habits & burnout'**
  String get hwSpecialSubtitle;

  /// No description provided for @hwFertility.
  ///
  /// In en, this message translates to:
  /// **'Fertility Indicator'**
  String get hwFertility;

  /// No description provided for @hwHormonalBalance.
  ///
  /// In en, this message translates to:
  /// **'Hormonal Balance'**
  String get hwHormonalBalance;

  /// No description provided for @hwReproductiveStrength.
  ///
  /// In en, this message translates to:
  /// **'Reproductive System Strength'**
  String get hwReproductiveStrength;

  /// No description provided for @hwChildhoodVuln.
  ///
  /// In en, this message translates to:
  /// **'Childhood Health Vulnerability'**
  String get hwChildhoodVuln;

  /// No description provided for @hwChildhoodStatus.
  ///
  /// In en, this message translates to:
  /// **'Childhood Health'**
  String get hwChildhoodStatus;

  /// No description provided for @hwAddictionVuln.
  ///
  /// In en, this message translates to:
  /// **'Addiction Vulnerability'**
  String get hwAddictionVuln;

  /// No description provided for @hwAddictionRecovery.
  ///
  /// In en, this message translates to:
  /// **'Recovery Capacity'**
  String get hwAddictionRecovery;

  /// No description provided for @hwBurnoutVuln.
  ///
  /// In en, this message translates to:
  /// **'Burnout Vulnerability'**
  String get hwBurnoutVuln;

  /// No description provided for @hwWorkLifeBalance.
  ///
  /// In en, this message translates to:
  /// **'Work-Life Balance'**
  String get hwWorkLifeBalance;

  /// No description provided for @hwStressTriggers.
  ///
  /// In en, this message translates to:
  /// **'Stress Triggers'**
  String get hwStressTriggers;

  /// No description provided for @hwProtectiveFactors.
  ///
  /// In en, this message translates to:
  /// **'Protective Factors'**
  String get hwProtectiveFactors;

  /// No description provided for @hwChallengesTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenges to Watch'**
  String get hwChallengesTitle;

  /// No description provided for @hwChallengesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Where to focus preventive care'**
  String get hwChallengesSubtitle;

  /// No description provided for @hwMitigation.
  ///
  /// In en, this message translates to:
  /// **'How to Manage'**
  String get hwMitigation;

  /// No description provided for @hwChronicAreas.
  ///
  /// In en, this message translates to:
  /// **'Chronic Vulnerability Areas'**
  String get hwChronicAreas;

  /// No description provided for @hwPreventivePriorities.
  ///
  /// In en, this message translates to:
  /// **'Preventive Priorities'**
  String get hwPreventivePriorities;

  /// No description provided for @hwImprovementTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Wellness Plan'**
  String get hwImprovementTitle;

  /// No description provided for @hwImprovementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Practical steps + traditional remedies'**
  String get hwImprovementSubtitle;

  /// No description provided for @hwReliabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading Reliability'**
  String get hwReliabilityTitle;

  /// No description provided for @hwLayerD1.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart (D1)'**
  String get hwLayerD1;

  /// No description provided for @hwLayerD6.
  ///
  /// In en, this message translates to:
  /// **'Health Chart (D6)'**
  String get hwLayerD6;

  /// No description provided for @hwLayerD30.
  ///
  /// In en, this message translates to:
  /// **'Micro-Health Chart (D30)'**
  String get hwLayerD30;

  /// No description provided for @hwLayerDasha.
  ///
  /// In en, this message translates to:
  /// **'Planetary Timing'**
  String get hwLayerDasha;

  /// No description provided for @hwLayerTransit.
  ///
  /// In en, this message translates to:
  /// **'Current Transits'**
  String get hwLayerTransit;

  /// No description provided for @hwDisclaimerLabel.
  ///
  /// In en, this message translates to:
  /// **'Medical Disclaimer'**
  String get hwDisclaimerLabel;

  /// No description provided for @hwTopicImmunity.
  ///
  /// In en, this message translates to:
  /// **'Boost Immunity'**
  String get hwTopicImmunity;

  /// No description provided for @hwTopicSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep & Rest'**
  String get hwTopicSleep;

  /// No description provided for @hwTopicStress.
  ///
  /// In en, this message translates to:
  /// **'Manage Stress'**
  String get hwTopicStress;

  /// No description provided for @hwTopicFertility.
  ///
  /// In en, this message translates to:
  /// **'Fertility Timing'**
  String get hwTopicFertility;

  /// No description provided for @hwTopicDiet.
  ///
  /// In en, this message translates to:
  /// **'Diet & Nutrition'**
  String get hwTopicDiet;

  /// No description provided for @hwTopicTiming.
  ///
  /// In en, this message translates to:
  /// **'Health Timing Windows'**
  String get hwTopicTiming;

  /// No description provided for @hwTopicMental.
  ///
  /// In en, this message translates to:
  /// **'Mental Wellbeing'**
  String get hwTopicMental;

  /// No description provided for @hwTopicPrevention.
  ///
  /// In en, this message translates to:
  /// **'Preventive Care Plan'**
  String get hwTopicPrevention;

  /// No description provided for @lvSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Love Report'**
  String get lvSubtitle;

  /// No description provided for @lvTitle.
  ///
  /// In en, this message translates to:
  /// **'Love & Relationships'**
  String get lvTitle;

  /// No description provided for @lvLovePotential.
  ///
  /// In en, this message translates to:
  /// **'Love Potential'**
  String get lvLovePotential;

  /// No description provided for @lvEmotionalAvail.
  ///
  /// In en, this message translates to:
  /// **'Emotionally Open'**
  String get lvEmotionalAvail;

  /// No description provided for @lvAttraction.
  ///
  /// In en, this message translates to:
  /// **'Attraction'**
  String get lvAttraction;

  /// No description provided for @lvCommitment.
  ///
  /// In en, this message translates to:
  /// **'Commitment'**
  String get lvCommitment;

  /// No description provided for @lvCommunication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get lvCommunication;

  /// No description provided for @lvFidelity.
  ///
  /// In en, this message translates to:
  /// **'Loyalty'**
  String get lvFidelity;

  /// No description provided for @lvChipLoyal.
  ///
  /// In en, this message translates to:
  /// **'Loyal heart'**
  String get lvChipLoyal;

  /// No description provided for @lvChipOpenHeart.
  ///
  /// In en, this message translates to:
  /// **'Open-hearted'**
  String get lvChipOpenHeart;

  /// No description provided for @lvChipCommunicator.
  ///
  /// In en, this message translates to:
  /// **'Great communicator'**
  String get lvChipCommunicator;

  /// No description provided for @lvChipMature.
  ///
  /// In en, this message translates to:
  /// **'Handles conflict well'**
  String get lvChipMature;

  /// No description provided for @lvChipEmotionallyWise.
  ///
  /// In en, this message translates to:
  /// **'Emotionally wise'**
  String get lvChipEmotionallyWise;

  /// No description provided for @lvLoveStyle.
  ///
  /// In en, this message translates to:
  /// **'Your Love Style'**
  String get lvLoveStyle;

  /// No description provided for @lvAttractionStyle.
  ///
  /// In en, this message translates to:
  /// **'Attraction style'**
  String get lvAttractionStyle;

  /// No description provided for @lvLangGiven.
  ///
  /// In en, this message translates to:
  /// **'You Express Love By'**
  String get lvLangGiven;

  /// No description provided for @lvLangReceived.
  ///
  /// In en, this message translates to:
  /// **'You Feel Loved By'**
  String get lvLangReceived;

  /// No description provided for @lvLovePlanets.
  ///
  /// In en, this message translates to:
  /// **'Your Love Planets'**
  String get lvLovePlanets;

  /// No description provided for @lvLoveKaraka.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get lvLoveKaraka;

  /// No description provided for @lvEmotionKaraka.
  ///
  /// In en, this message translates to:
  /// **'Emotion'**
  String get lvEmotionKaraka;

  /// No description provided for @lvPassionKaraka.
  ///
  /// In en, this message translates to:
  /// **'Passion'**
  String get lvPassionKaraka;

  /// No description provided for @lvPathToLove.
  ///
  /// In en, this message translates to:
  /// **'Your Path to Love'**
  String get lvPathToLove;

  /// No description provided for @lvPathSub.
  ///
  /// In en, this message translates to:
  /// **'Love vs arranged'**
  String get lvPathSub;

  /// No description provided for @lvLoveMarriage.
  ///
  /// In en, this message translates to:
  /// **'Love Marriage'**
  String get lvLoveMarriage;

  /// No description provided for @lvArrangedMarriage.
  ///
  /// In en, this message translates to:
  /// **'Arranged Marriage'**
  String get lvArrangedMarriage;

  /// No description provided for @lvParentalAccept.
  ///
  /// In en, this message translates to:
  /// **'Parental Acceptance'**
  String get lvParentalAccept;

  /// No description provided for @lvInterCaste.
  ///
  /// In en, this message translates to:
  /// **'Inter-caste / Religion'**
  String get lvInterCaste;

  /// No description provided for @lvIdealPartner.
  ///
  /// In en, this message translates to:
  /// **'Your Ideal Partner'**
  String get lvIdealPartner;

  /// No description provided for @lvPersonality.
  ///
  /// In en, this message translates to:
  /// **'Personality'**
  String get lvPersonality;

  /// No description provided for @lvAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get lvAppearance;

  /// No description provided for @lvIdealTraits.
  ///
  /// In en, this message translates to:
  /// **'Ideal Traits'**
  String get lvIdealTraits;

  /// No description provided for @lvWhatMatters.
  ///
  /// In en, this message translates to:
  /// **'What Matters Most'**
  String get lvWhatMatters;

  /// No description provided for @lvDrawnTo.
  ///
  /// In en, this message translates to:
  /// **'Drawn to'**
  String get lvDrawnTo;

  /// No description provided for @lvDealbreakers.
  ///
  /// In en, this message translates to:
  /// **'Dealbreakers'**
  String get lvDealbreakers;

  /// No description provided for @lvYourAppeal.
  ///
  /// In en, this message translates to:
  /// **'Your appeal'**
  String get lvYourAppeal;

  /// No description provided for @lvLoveStory.
  ///
  /// In en, this message translates to:
  /// **'Your Love Story'**
  String get lvLoveStory;

  /// No description provided for @lvLoveStorySub.
  ///
  /// In en, this message translates to:
  /// **'Relationship patterns'**
  String get lvLoveStorySub;

  /// No description provided for @lvFirstLove.
  ///
  /// In en, this message translates to:
  /// **'First Love'**
  String get lvFirstLove;

  /// No description provided for @lvRelationCount.
  ///
  /// In en, this message translates to:
  /// **'Significant Bonds'**
  String get lvRelationCount;

  /// No description provided for @lvDuration.
  ///
  /// In en, this message translates to:
  /// **'Typical Duration'**
  String get lvDuration;

  /// No description provided for @lvDepth.
  ///
  /// In en, this message translates to:
  /// **'Emotional Depth'**
  String get lvDepth;

  /// No description provided for @lvDatingPattern.
  ///
  /// In en, this message translates to:
  /// **'Dating Pattern'**
  String get lvDatingPattern;

  /// No description provided for @lvCommitIntimacy.
  ///
  /// In en, this message translates to:
  /// **'Commitment & Intimacy'**
  String get lvCommitIntimacy;

  /// No description provided for @lvCommitReady.
  ///
  /// In en, this message translates to:
  /// **'Commitment Readiness'**
  String get lvCommitReady;

  /// No description provided for @lvIntimacyDrive.
  ///
  /// In en, this message translates to:
  /// **'Intimacy Drive'**
  String get lvIntimacyDrive;

  /// No description provided for @lvSensuality.
  ///
  /// In en, this message translates to:
  /// **'Sensuality'**
  String get lvSensuality;

  /// No description provided for @lvEmpathy.
  ///
  /// In en, this message translates to:
  /// **'Empathy'**
  String get lvEmpathy;

  /// No description provided for @lvCommitStyle.
  ///
  /// In en, this message translates to:
  /// **'Commitment Style'**
  String get lvCommitStyle;

  /// No description provided for @lvChemistry.
  ///
  /// In en, this message translates to:
  /// **'Chemistry Style'**
  String get lvChemistry;

  /// No description provided for @lvMakesCommit.
  ///
  /// In en, this message translates to:
  /// **'What Makes You Commit'**
  String get lvMakesCommit;

  /// No description provided for @lvMakesFlee.
  ///
  /// In en, this message translates to:
  /// **'What Pushes You Away'**
  String get lvMakesFlee;

  /// No description provided for @lvEmotional.
  ///
  /// In en, this message translates to:
  /// **'Emotional Intelligence'**
  String get lvEmotional;

  /// No description provided for @lvEmotionalIQ.
  ///
  /// In en, this message translates to:
  /// **'Emotional IQ'**
  String get lvEmotionalIQ;

  /// No description provided for @lvConflictStyle.
  ///
  /// In en, this message translates to:
  /// **'Conflict Style'**
  String get lvConflictStyle;

  /// No description provided for @lvTiming.
  ///
  /// In en, this message translates to:
  /// **'Love Timing'**
  String get lvTiming;

  /// No description provided for @lvNewLove12.
  ///
  /// In en, this message translates to:
  /// **'New love in 12 months'**
  String get lvNewLove12;

  /// No description provided for @lvEnergyNow.
  ///
  /// In en, this message translates to:
  /// **'Energy now'**
  String get lvEnergyNow;

  /// No description provided for @lvPhaseNow.
  ///
  /// In en, this message translates to:
  /// **'Phase now'**
  String get lvPhaseNow;

  /// No description provided for @lvPeakRomance.
  ///
  /// In en, this message translates to:
  /// **'Peak Romance Years'**
  String get lvPeakRomance;

  /// No description provided for @lvNewLoveWindow.
  ///
  /// In en, this message translates to:
  /// **'New Love Window'**
  String get lvNewLoveWindow;

  /// No description provided for @lvChallenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges to Watch'**
  String get lvChallenges;

  /// No description provided for @lvRiskHeartbreak.
  ///
  /// In en, this message translates to:
  /// **'Heartbreak Vulnerability'**
  String get lvRiskHeartbreak;

  /// No description provided for @lvRiskSabotage.
  ///
  /// In en, this message translates to:
  /// **'Self-sabotage'**
  String get lvRiskSabotage;

  /// No description provided for @lvRiskCommitFear.
  ///
  /// In en, this message translates to:
  /// **'Fear of Commitment'**
  String get lvRiskCommitFear;

  /// No description provided for @lvRiskRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat Patterns'**
  String get lvRiskRepeat;

  /// No description provided for @lvRiskWorkaholic.
  ///
  /// In en, this message translates to:
  /// **'Work Over Love'**
  String get lvRiskWorkaholic;

  /// No description provided for @lvRedFlags.
  ///
  /// In en, this message translates to:
  /// **'Red flags to watch'**
  String get lvRedFlags;

  /// No description provided for @lvHealing.
  ///
  /// In en, this message translates to:
  /// **'What to Heal'**
  String get lvHealing;

  /// No description provided for @lvFocusArea.
  ///
  /// In en, this message translates to:
  /// **'Focus Area'**
  String get lvFocusArea;

  /// No description provided for @lvHealDir.
  ///
  /// In en, this message translates to:
  /// **'Healing direction'**
  String get lvHealDir;

  /// No description provided for @lvImprovementPlan.
  ///
  /// In en, this message translates to:
  /// **'Improvement Plan'**
  String get lvImprovementPlan;

  /// No description provided for @lvReliability.
  ///
  /// In en, this message translates to:
  /// **'Prediction Reliability'**
  String get lvReliability;

  /// No description provided for @lvLayerBirth.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart (D1)'**
  String get lvLayerBirth;

  /// No description provided for @lvLayerNavamsa.
  ///
  /// In en, this message translates to:
  /// **'Navamsa (D9)'**
  String get lvLayerNavamsa;

  /// No description provided for @lvLayerSaptamsa.
  ///
  /// In en, this message translates to:
  /// **'Saptamsa (D7)'**
  String get lvLayerSaptamsa;

  /// No description provided for @lvLayerDasha.
  ///
  /// In en, this message translates to:
  /// **'Dasha Timing'**
  String get lvLayerDasha;

  /// No description provided for @lvLayerTransit.
  ///
  /// In en, this message translates to:
  /// **'Current Transits'**
  String get lvLayerTransit;

  /// No description provided for @lvTopicWhen.
  ///
  /// In en, this message translates to:
  /// **'When will I find love?'**
  String get lvTopicWhen;

  /// No description provided for @lvTopicSoulmate.
  ///
  /// In en, this message translates to:
  /// **'About my soulmate'**
  String get lvTopicSoulmate;

  /// No description provided for @lvTopicCurrent.
  ///
  /// In en, this message translates to:
  /// **'My current relationship'**
  String get lvTopicCurrent;

  /// No description provided for @lvTopicHeal.
  ///
  /// In en, this message translates to:
  /// **'Healing from the past'**
  String get lvTopicHeal;

  /// No description provided for @lvTopicCommit.
  ///
  /// In en, this message translates to:
  /// **'Commitment help'**
  String get lvTopicCommit;

  /// No description provided for @lvTopicLoveVsArranged.
  ///
  /// In en, this message translates to:
  /// **'Love vs arranged'**
  String get lvTopicLoveVsArranged;

  /// No description provided for @lvTopicHeartbreak.
  ///
  /// In en, this message translates to:
  /// **'Avoiding heartbreak'**
  String get lvTopicHeartbreak;

  /// No description provided for @lvTopicConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence in love'**
  String get lvTopicConfidence;

  /// No description provided for @mrSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Marriage Report'**
  String get mrSubtitle;

  /// No description provided for @mrTitle.
  ///
  /// In en, this message translates to:
  /// **'Marriage & Family'**
  String get mrTitle;

  /// No description provided for @mrMarriagePotential.
  ///
  /// In en, this message translates to:
  /// **'Marriage Potential'**
  String get mrMarriagePotential;

  /// No description provided for @mrHarmony.
  ///
  /// In en, this message translates to:
  /// **'Harmony'**
  String get mrHarmony;

  /// No description provided for @mrLongevity.
  ///
  /// In en, this message translates to:
  /// **'Longevity'**
  String get mrLongevity;

  /// No description provided for @mrSatisfaction.
  ///
  /// In en, this message translates to:
  /// **'Satisfaction'**
  String get mrSatisfaction;

  /// No description provided for @mrStability.
  ///
  /// In en, this message translates to:
  /// **'Home Stability'**
  String get mrStability;

  /// No description provided for @mrClarity.
  ///
  /// In en, this message translates to:
  /// **'Clarity'**
  String get mrClarity;

  /// No description provided for @mrChipHarmony.
  ///
  /// In en, this message translates to:
  /// **'Harmonious bond'**
  String get mrChipHarmony;

  /// No description provided for @mrChipNoMangal.
  ///
  /// In en, this message translates to:
  /// **'No Mangal dosh'**
  String get mrChipNoMangal;

  /// No description provided for @mrChipLongLasting.
  ///
  /// In en, this message translates to:
  /// **'Long-lasting'**
  String get mrChipLongLasting;

  /// No description provided for @mrChipHome.
  ///
  /// In en, this message translates to:
  /// **'Own home likely'**
  String get mrChipHome;

  /// No description provided for @mrChipInLaws.
  ///
  /// In en, this message translates to:
  /// **'Good in-laws'**
  String get mrChipInLaws;

  /// No description provided for @mrChipChildren.
  ///
  /// In en, this message translates to:
  /// **'Children blessed'**
  String get mrChipChildren;

  /// No description provided for @mrSpouse.
  ///
  /// In en, this message translates to:
  /// **'Your Future Spouse'**
  String get mrSpouse;

  /// No description provided for @mrSpouseSub.
  ///
  /// In en, this message translates to:
  /// **'What the chart suggests'**
  String get mrSpouseSub;

  /// No description provided for @mrSpouseTraits.
  ///
  /// In en, this message translates to:
  /// **'Likely Personality'**
  String get mrSpouseTraits;

  /// No description provided for @mrSpouseWork.
  ///
  /// In en, this message translates to:
  /// **'Likely Profession'**
  String get mrSpouseWork;

  /// No description provided for @mrAgeDiff.
  ///
  /// In en, this message translates to:
  /// **'Age Difference'**
  String get mrAgeDiff;

  /// No description provided for @mrCulture.
  ///
  /// In en, this message translates to:
  /// **'Cultural Match'**
  String get mrCulture;

  /// No description provided for @mrEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get mrEducation;

  /// No description provided for @mrFamilyBg.
  ///
  /// In en, this message translates to:
  /// **'Family Background'**
  String get mrFamilyBg;

  /// No description provided for @mrSoulPartnership.
  ///
  /// In en, this message translates to:
  /// **'Soul & Partnership'**
  String get mrSoulPartnership;

  /// No description provided for @mrSelfPlanet.
  ///
  /// In en, this message translates to:
  /// **'You in a Bond'**
  String get mrSelfPlanet;

  /// No description provided for @mrSpousePlanet.
  ///
  /// In en, this message translates to:
  /// **'Your Spouse Planet'**
  String get mrSpousePlanet;

  /// No description provided for @mrSoulAlignment.
  ///
  /// In en, this message translates to:
  /// **'Soul Alignment'**
  String get mrSoulAlignment;

  /// No description provided for @mrAlignStrong.
  ///
  /// In en, this message translates to:
  /// **'Your soul and your ideal partner are strongly aligned — a deeply fulfilling bond is well supported.'**
  String get mrAlignStrong;

  /// No description provided for @mrAlignModerate.
  ///
  /// In en, this message translates to:
  /// **'Your soul and your ideal partner are moderately aligned — a fulfilling bond grows with conscious effort.'**
  String get mrAlignModerate;

  /// No description provided for @mrAlignLow.
  ///
  /// In en, this message translates to:
  /// **'Your soul and partnership need conscious integration — choose a partner who truly matches your inner values.'**
  String get mrAlignLow;

  /// No description provided for @mrTechDarakaraka.
  ///
  /// In en, this message translates to:
  /// **'Spouse planet (Darakaraka)'**
  String get mrTechDarakaraka;

  /// No description provided for @mrUpapada.
  ///
  /// In en, this message translates to:
  /// **'Marriage point (Upapada)'**
  String get mrUpapada;

  /// No description provided for @mrUpapadaLord.
  ///
  /// In en, this message translates to:
  /// **'Upapada ruler'**
  String get mrUpapadaLord;

  /// No description provided for @mrFoundation.
  ///
  /// In en, this message translates to:
  /// **'Marriage Foundation'**
  String get mrFoundation;

  /// No description provided for @mrMarriageSign.
  ///
  /// In en, this message translates to:
  /// **'Marriage Sign'**
  String get mrMarriageSign;

  /// No description provided for @mrMarriageLord.
  ///
  /// In en, this message translates to:
  /// **'Marriage Ruler'**
  String get mrMarriageLord;

  /// No description provided for @mrHouseStrength.
  ///
  /// In en, this message translates to:
  /// **'House Strength'**
  String get mrHouseStrength;

  /// No description provided for @mrPartnerHint.
  ///
  /// In en, this message translates to:
  /// **'Partner hint from your chart'**
  String get mrPartnerHint;

  /// No description provided for @mrHarmonyHdr.
  ///
  /// In en, this message translates to:
  /// **'Compatibility Harmony'**
  String get mrHarmonyHdr;

  /// No description provided for @mrHarmonySub.
  ///
  /// In en, this message translates to:
  /// **'How you\'ll connect'**
  String get mrHarmonySub;

  /// No description provided for @mrEmotional.
  ///
  /// In en, this message translates to:
  /// **'Emotional'**
  String get mrEmotional;

  /// No description provided for @mrIntellectual.
  ///
  /// In en, this message translates to:
  /// **'Intellectual'**
  String get mrIntellectual;

  /// No description provided for @mrPhysical.
  ///
  /// In en, this message translates to:
  /// **'Physical Intimacy'**
  String get mrPhysical;

  /// No description provided for @mrFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get mrFinancial;

  /// No description provided for @mrCommunication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get mrCommunication;

  /// No description provided for @mrSharedValues.
  ///
  /// In en, this message translates to:
  /// **'Shared Values'**
  String get mrSharedValues;

  /// No description provided for @mrSpiritual.
  ///
  /// In en, this message translates to:
  /// **'Spiritual'**
  String get mrSpiritual;

  /// No description provided for @mrConflictRes.
  ///
  /// In en, this message translates to:
  /// **'Conflict Resolution'**
  String get mrConflictRes;

  /// No description provided for @mrTiming.
  ///
  /// In en, this message translates to:
  /// **'Marriage Timing'**
  String get mrTiming;

  /// No description provided for @mrFirstMarriageAge.
  ///
  /// In en, this message translates to:
  /// **'Likely Marriage Age'**
  String get mrFirstMarriageAge;

  /// No description provided for @mrDelayChance.
  ///
  /// In en, this message translates to:
  /// **'Delay chance'**
  String get mrDelayChance;

  /// No description provided for @mrMarriageWindow.
  ///
  /// In en, this message translates to:
  /// **'Marriage Window'**
  String get mrMarriageWindow;

  /// No description provided for @mrSecondaryWindow.
  ///
  /// In en, this message translates to:
  /// **'Alternate Window'**
  String get mrSecondaryWindow;

  /// No description provided for @mrCurrentReadiness.
  ///
  /// In en, this message translates to:
  /// **'Right Now'**
  String get mrCurrentReadiness;

  /// No description provided for @mrJourney.
  ///
  /// In en, this message translates to:
  /// **'Marriage Journey'**
  String get mrJourney;

  /// No description provided for @mrJourneySub.
  ///
  /// In en, this message translates to:
  /// **'How the bond evolves'**
  String get mrJourneySub;

  /// No description provided for @mrPhaseEarly.
  ///
  /// In en, this message translates to:
  /// **'Early Years'**
  String get mrPhaseEarly;

  /// No description provided for @mrPhaseMid.
  ///
  /// In en, this message translates to:
  /// **'Middle Years'**
  String get mrPhaseMid;

  /// No description provided for @mrPhaseMature.
  ///
  /// In en, this message translates to:
  /// **'Mature Years'**
  String get mrPhaseMature;

  /// No description provided for @mrPhaseLate.
  ///
  /// In en, this message translates to:
  /// **'Later Years'**
  String get mrPhaseLate;

  /// No description provided for @mrTip.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get mrTip;

  /// No description provided for @mrFamilyHome.
  ///
  /// In en, this message translates to:
  /// **'Family & Home'**
  String get mrFamilyHome;

  /// No description provided for @mrInLaws.
  ///
  /// In en, this message translates to:
  /// **'In-law Relations'**
  String get mrInLaws;

  /// No description provided for @mrFamilyHarmony.
  ///
  /// In en, this message translates to:
  /// **'Family Harmony'**
  String get mrFamilyHarmony;

  /// No description provided for @mrHomeOwnership.
  ///
  /// In en, this message translates to:
  /// **'Home Ownership'**
  String get mrHomeOwnership;

  /// No description provided for @mrDomesticPeace.
  ///
  /// In en, this message translates to:
  /// **'Domestic Peace'**
  String get mrDomesticPeace;

  /// No description provided for @mrFertility.
  ///
  /// In en, this message translates to:
  /// **'Fertility'**
  String get mrFertility;

  /// No description provided for @mrParenting.
  ///
  /// In en, this message translates to:
  /// **'Parenting Harmony'**
  String get mrParenting;

  /// No description provided for @mrChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get mrChildren;

  /// No description provided for @mrLikelyCount.
  ///
  /// In en, this message translates to:
  /// **'Likely count'**
  String get mrLikelyCount;

  /// No description provided for @mrVerification.
  ///
  /// In en, this message translates to:
  /// **'Cross-Chart Verification'**
  String get mrVerification;

  /// No description provided for @mrD9.
  ///
  /// In en, this message translates to:
  /// **'Marriage Chart (D9)'**
  String get mrD9;

  /// No description provided for @mrD10.
  ///
  /// In en, this message translates to:
  /// **'Career-Spouse Chart (D10)'**
  String get mrD10;

  /// No description provided for @mrD60.
  ///
  /// In en, this message translates to:
  /// **'Karma Chart (D60)'**
  String get mrD60;

  /// No description provided for @mrChallenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges to Watch'**
  String get mrChallenges;

  /// No description provided for @mrMangalPresent.
  ///
  /// In en, this message translates to:
  /// **'Mangal Dosh is present in the chart — review remedies and matching carefully.'**
  String get mrMangalPresent;

  /// No description provided for @mrMangalAbsent.
  ///
  /// In en, this message translates to:
  /// **'No Mangal Dosh detected — a supportive marriage indicator.'**
  String get mrMangalAbsent;

  /// No description provided for @mrRiskConflict.
  ///
  /// In en, this message translates to:
  /// **'Conflict'**
  String get mrRiskConflict;

  /// No description provided for @mrRiskSeparation.
  ///
  /// In en, this message translates to:
  /// **'Separation'**
  String get mrRiskSeparation;

  /// No description provided for @mrRiskDistance.
  ///
  /// In en, this message translates to:
  /// **'Emotional Distance'**
  String get mrRiskDistance;

  /// No description provided for @mrRiskInfidelity.
  ///
  /// In en, this message translates to:
  /// **'Infidelity'**
  String get mrRiskInfidelity;

  /// No description provided for @mrRiskFinance.
  ///
  /// In en, this message translates to:
  /// **'Money Disagreements'**
  String get mrRiskFinance;

  /// No description provided for @mrPartnerGuide.
  ///
  /// In en, this message translates to:
  /// **'Partner Guide'**
  String get mrPartnerGuide;

  /// No description provided for @mrPartnerGuideSub.
  ///
  /// In en, this message translates to:
  /// **'What to look for'**
  String get mrPartnerGuideSub;

  /// No description provided for @mrSeek.
  ///
  /// In en, this message translates to:
  /// **'Look for'**
  String get mrSeek;

  /// No description provided for @mrMatchingPriorities.
  ///
  /// In en, this message translates to:
  /// **'Matching Priorities'**
  String get mrMatchingPriorities;

  /// No description provided for @mrImprovementPlan.
  ///
  /// In en, this message translates to:
  /// **'Improvement Plan'**
  String get mrImprovementPlan;

  /// No description provided for @mrReliability.
  ///
  /// In en, this message translates to:
  /// **'Prediction Reliability'**
  String get mrReliability;

  /// No description provided for @mrLayerBirth.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart (D1)'**
  String get mrLayerBirth;

  /// No description provided for @mrLayerNavamsa.
  ///
  /// In en, this message translates to:
  /// **'Navamsa (D9)'**
  String get mrLayerNavamsa;

  /// No description provided for @mrLayerDashamsa.
  ///
  /// In en, this message translates to:
  /// **'Dashamsa (D10)'**
  String get mrLayerDashamsa;

  /// No description provided for @mrLayerShashtiamsa.
  ///
  /// In en, this message translates to:
  /// **'Karma (D60)'**
  String get mrLayerShashtiamsa;

  /// No description provided for @mrLayerDarakaraka.
  ///
  /// In en, this message translates to:
  /// **'Spouse Planet'**
  String get mrLayerDarakaraka;

  /// No description provided for @mrTopicWhen.
  ///
  /// In en, this message translates to:
  /// **'When will I marry?'**
  String get mrTopicWhen;

  /// No description provided for @mrTopicSpouse.
  ///
  /// In en, this message translates to:
  /// **'About my spouse'**
  String get mrTopicSpouse;

  /// No description provided for @mrTopicCompat.
  ///
  /// In en, this message translates to:
  /// **'Compatibility tips'**
  String get mrTopicCompat;

  /// No description provided for @mrTopicDelay.
  ///
  /// In en, this message translates to:
  /// **'Marriage delay'**
  String get mrTopicDelay;

  /// No description provided for @mrTopicMangal.
  ///
  /// In en, this message translates to:
  /// **'Mangal dosh'**
  String get mrTopicMangal;

  /// No description provided for @mrTopicChildren.
  ///
  /// In en, this message translates to:
  /// **'Children timing'**
  String get mrTopicChildren;

  /// No description provided for @mrTopicInLaws.
  ///
  /// In en, this message translates to:
  /// **'In-law relations'**
  String get mrTopicInLaws;

  /// No description provided for @mrTopicHarmony.
  ///
  /// In en, this message translates to:
  /// **'Building harmony'**
  String get mrTopicHarmony;

  /// No description provided for @wlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Wealth Report'**
  String get wlSubtitle;

  /// No description provided for @wlTitle.
  ///
  /// In en, this message translates to:
  /// **'Wealth & Finance'**
  String get wlTitle;

  /// No description provided for @wlWealthPotential.
  ///
  /// In en, this message translates to:
  /// **'Wealth Potential'**
  String get wlWealthPotential;

  /// No description provided for @wlAccumulation.
  ///
  /// In en, this message translates to:
  /// **'Accumulation'**
  String get wlAccumulation;

  /// No description provided for @wlIncomeFlow.
  ///
  /// In en, this message translates to:
  /// **'Income Flow'**
  String get wlIncomeFlow;

  /// No description provided for @wlRetention.
  ///
  /// In en, this message translates to:
  /// **'Retention'**
  String get wlRetention;

  /// No description provided for @wlSustainability.
  ///
  /// In en, this message translates to:
  /// **'Sustainability'**
  String get wlSustainability;

  /// No description provided for @wlSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings Discipline'**
  String get wlSavings;

  /// No description provided for @wlChipSaver.
  ///
  /// In en, this message translates to:
  /// **'Natural saver'**
  String get wlChipSaver;

  /// No description provided for @wlChipMultiIncome.
  ///
  /// In en, this message translates to:
  /// **'Multiple incomes'**
  String get wlChipMultiIncome;

  /// No description provided for @wlChipStrongYogas.
  ///
  /// In en, this message translates to:
  /// **'Wealth yogas'**
  String get wlChipStrongYogas;

  /// No description provided for @wlChipLowDebt.
  ///
  /// In en, this message translates to:
  /// **'Low debt'**
  String get wlChipLowDebt;

  /// No description provided for @wlChipInheritance.
  ///
  /// In en, this message translates to:
  /// **'Inheritance likely'**
  String get wlChipInheritance;

  /// No description provided for @wlChipInvestor.
  ///
  /// In en, this message translates to:
  /// **'Smart investor'**
  String get wlChipInvestor;

  /// No description provided for @wlWealthClass.
  ///
  /// In en, this message translates to:
  /// **'Wealth Class'**
  String get wlWealthClass;

  /// No description provided for @wlWealthType.
  ///
  /// In en, this message translates to:
  /// **'Main Wealth Type'**
  String get wlWealthType;

  /// No description provided for @wlPrimarySource.
  ///
  /// In en, this message translates to:
  /// **'Primary Income'**
  String get wlPrimarySource;

  /// No description provided for @wlPeakAge.
  ///
  /// In en, this message translates to:
  /// **'Peak Wealth Age'**
  String get wlPeakAge;

  /// No description provided for @wlBoosters.
  ///
  /// In en, this message translates to:
  /// **'What\'s Boosting Your Wealth'**
  String get wlBoosters;

  /// No description provided for @wlBoostersSub.
  ///
  /// In en, this message translates to:
  /// **'Powerful money combinations'**
  String get wlBoostersSub;

  /// No description provided for @wlWealthImpact.
  ///
  /// In en, this message translates to:
  /// **'boost'**
  String get wlWealthImpact;

  /// No description provided for @wlDrains.
  ///
  /// In en, this message translates to:
  /// **'Wealth Drains'**
  String get wlDrains;

  /// No description provided for @wlIncomeSources.
  ///
  /// In en, this message translates to:
  /// **'Income Sources'**
  String get wlIncomeSources;

  /// No description provided for @wlIncomeSourcesSub.
  ///
  /// In en, this message translates to:
  /// **'Where your money comes from'**
  String get wlIncomeSourcesSub;

  /// No description provided for @wlPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get wlPrimary;

  /// No description provided for @wlInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investment Plan'**
  String get wlInvestment;

  /// No description provided for @wlInvestmentSub.
  ///
  /// In en, this message translates to:
  /// **'Ideal asset mix'**
  String get wlInvestmentSub;

  /// No description provided for @wlRiskAppetite.
  ///
  /// In en, this message translates to:
  /// **'Risk Appetite'**
  String get wlRiskAppetite;

  /// No description provided for @wlInvestStyle.
  ///
  /// In en, this message translates to:
  /// **'Investing Style'**
  String get wlInvestStyle;

  /// No description provided for @wlDrivenBy.
  ///
  /// In en, this message translates to:
  /// **'Driven by'**
  String get wlDrivenBy;

  /// No description provided for @wlMoneyPersonality.
  ///
  /// In en, this message translates to:
  /// **'Money Personality'**
  String get wlMoneyPersonality;

  /// No description provided for @wlMoneyType.
  ///
  /// In en, this message translates to:
  /// **'Money Type'**
  String get wlMoneyType;

  /// No description provided for @wlSpending.
  ///
  /// In en, this message translates to:
  /// **'Spending'**
  String get wlSpending;

  /// No description provided for @wlSavingsDiscipline.
  ///
  /// In en, this message translates to:
  /// **'Savings Discipline'**
  String get wlSavingsDiscipline;

  /// No description provided for @wlCharity.
  ///
  /// In en, this message translates to:
  /// **'Charity Inclination'**
  String get wlCharity;

  /// No description provided for @wlLuxury.
  ///
  /// In en, this message translates to:
  /// **'Luxury Spending'**
  String get wlLuxury;

  /// No description provided for @wlWindfalls.
  ///
  /// In en, this message translates to:
  /// **'Windfalls & Chances'**
  String get wlWindfalls;

  /// No description provided for @wlWindfallsSub.
  ///
  /// In en, this message translates to:
  /// **'Luck-based money'**
  String get wlWindfallsSub;

  /// No description provided for @wlInheritanceChance.
  ///
  /// In en, this message translates to:
  /// **'Inheritance'**
  String get wlInheritanceChance;

  /// No description provided for @wlSuddenGains.
  ///
  /// In en, this message translates to:
  /// **'Sudden Gains'**
  String get wlSuddenGains;

  /// No description provided for @wlLottery.
  ///
  /// In en, this message translates to:
  /// **'Lottery / Speculation'**
  String get wlLottery;

  /// No description provided for @wlInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance Claims'**
  String get wlInsurance;

  /// No description provided for @wlWindfallSource.
  ///
  /// In en, this message translates to:
  /// **'Likely windfall source'**
  String get wlWindfallSource;

  /// No description provided for @wlMoneyPlanets.
  ///
  /// In en, this message translates to:
  /// **'Your Money Planets'**
  String get wlMoneyPlanets;

  /// No description provided for @wlPrimaryKaraka.
  ///
  /// In en, this message translates to:
  /// **'Primary Money Planet'**
  String get wlPrimaryKaraka;

  /// No description provided for @wlSecondaryKaraka.
  ///
  /// In en, this message translates to:
  /// **'Secondary Money Planet'**
  String get wlSecondaryKaraka;

  /// No description provided for @wlTimeline.
  ///
  /// In en, this message translates to:
  /// **'Wealth Timeline'**
  String get wlTimeline;

  /// No description provided for @wlPeakYears.
  ///
  /// In en, this message translates to:
  /// **'Peak Years'**
  String get wlPeakYears;

  /// No description provided for @wlGoodPeriod.
  ///
  /// In en, this message translates to:
  /// **'Prosperous Period'**
  String get wlGoodPeriod;

  /// No description provided for @wlSuddenGainWindow.
  ///
  /// In en, this message translates to:
  /// **'Sudden Gain Window'**
  String get wlSuddenGainWindow;

  /// No description provided for @wlToughPeriod.
  ///
  /// In en, this message translates to:
  /// **'Cautious Period'**
  String get wlToughPeriod;

  /// No description provided for @wlDebtRisks.
  ///
  /// In en, this message translates to:
  /// **'Debt & Money Risks'**
  String get wlDebtRisks;

  /// No description provided for @wlDebtChance.
  ///
  /// In en, this message translates to:
  /// **'Debt Likelihood'**
  String get wlDebtChance;

  /// No description provided for @wlLoanBurden.
  ///
  /// In en, this message translates to:
  /// **'Loan Burden'**
  String get wlLoanBurden;

  /// No description provided for @wlDrainSources.
  ///
  /// In en, this message translates to:
  /// **'Watch out for'**
  String get wlDrainSources;

  /// No description provided for @wlStrengthen.
  ///
  /// In en, this message translates to:
  /// **'What to Strengthen'**
  String get wlStrengthen;

  /// No description provided for @wlWeakestDriver.
  ///
  /// In en, this message translates to:
  /// **'Weakest Money Driver'**
  String get wlWeakestDriver;

  /// No description provided for @wlHowToFix.
  ///
  /// In en, this message translates to:
  /// **'How to strengthen'**
  String get wlHowToFix;

  /// No description provided for @wlImprovementPlan.
  ///
  /// In en, this message translates to:
  /// **'Improvement Plan'**
  String get wlImprovementPlan;

  /// No description provided for @wlReliability.
  ///
  /// In en, this message translates to:
  /// **'Prediction Reliability'**
  String get wlReliability;

  /// No description provided for @wlLayerBirth.
  ///
  /// In en, this message translates to:
  /// **'Wealth Houses (D1)'**
  String get wlLayerBirth;

  /// No description provided for @wlLayerHora.
  ///
  /// In en, this message translates to:
  /// **'Hora Chart (D2)'**
  String get wlLayerHora;

  /// No description provided for @wlLayerNavamsa.
  ///
  /// In en, this message translates to:
  /// **'Navamsa (D9)'**
  String get wlLayerNavamsa;

  /// No description provided for @wlLayerDasha.
  ///
  /// In en, this message translates to:
  /// **'Dasha Timing'**
  String get wlLayerDasha;

  /// No description provided for @wlLayerTransit.
  ///
  /// In en, this message translates to:
  /// **'Current Transits'**
  String get wlLayerTransit;

  /// No description provided for @wlTopicGrow.
  ///
  /// In en, this message translates to:
  /// **'How to grow wealth'**
  String get wlTopicGrow;

  /// No description provided for @wlTopicInvest.
  ///
  /// In en, this message translates to:
  /// **'Where to invest'**
  String get wlTopicInvest;

  /// No description provided for @wlTopicDebt.
  ///
  /// In en, this message translates to:
  /// **'Managing debt'**
  String get wlTopicDebt;

  /// No description provided for @wlTopicProperty.
  ///
  /// In en, this message translates to:
  /// **'Buying property'**
  String get wlTopicProperty;

  /// No description provided for @wlTopicRetire.
  ///
  /// In en, this message translates to:
  /// **'Retirement planning'**
  String get wlTopicRetire;

  /// No description provided for @wlTopicPassive.
  ///
  /// In en, this message translates to:
  /// **'Passive income'**
  String get wlTopicPassive;

  /// No description provided for @wlTopicWindfall.
  ///
  /// In en, this message translates to:
  /// **'Sudden gains'**
  String get wlTopicWindfall;

  /// No description provided for @wlTopicTiming.
  ///
  /// In en, this message translates to:
  /// **'Best money timing'**
  String get wlTopicTiming;

  /// No description provided for @bzSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Business Report'**
  String get bzSubtitle;

  /// No description provided for @bzTitle.
  ///
  /// In en, this message translates to:
  /// **'Business & Startup'**
  String get bzTitle;

  /// No description provided for @bzBusinessPotential.
  ///
  /// In en, this message translates to:
  /// **'Business Potential'**
  String get bzBusinessPotential;

  /// No description provided for @bzEntrepreneurship.
  ///
  /// In en, this message translates to:
  /// **'Entrepreneur'**
  String get bzEntrepreneurship;

  /// No description provided for @bzVenture.
  ///
  /// In en, this message translates to:
  /// **'Venture Success'**
  String get bzVenture;

  /// No description provided for @bzWealth.
  ///
  /// In en, this message translates to:
  /// **'Wealth via Business'**
  String get bzWealth;

  /// No description provided for @bzRiskAppetite.
  ///
  /// In en, this message translates to:
  /// **'Risk Appetite'**
  String get bzRiskAppetite;

  /// No description provided for @bzLongevity.
  ///
  /// In en, this message translates to:
  /// **'Longevity'**
  String get bzLongevity;

  /// No description provided for @bzChipWealthMagnet.
  ///
  /// In en, this message translates to:
  /// **'Wealth magnet'**
  String get bzChipWealthMagnet;

  /// No description provided for @bzChipMoneyYoga.
  ///
  /// In en, this message translates to:
  /// **'Money yoga'**
  String get bzChipMoneyYoga;

  /// No description provided for @bzChipLeadership.
  ///
  /// In en, this message translates to:
  /// **'Leadership'**
  String get bzChipLeadership;

  /// No description provided for @bzChipPartnerFit.
  ///
  /// In en, this message translates to:
  /// **'Great partner fit'**
  String get bzChipPartnerFit;

  /// No description provided for @bzChipGains.
  ///
  /// In en, this message translates to:
  /// **'Strong gains'**
  String get bzChipGains;

  /// No description provided for @bzChipInvestor.
  ///
  /// In en, this message translates to:
  /// **'Investor appeal'**
  String get bzChipInvestor;

  /// No description provided for @bzChipFounder.
  ///
  /// In en, this message translates to:
  /// **'Founder mindset'**
  String get bzChipFounder;

  /// No description provided for @bzWhatsWorking.
  ///
  /// In en, this message translates to:
  /// **'What\'s Working For You'**
  String get bzWhatsWorking;

  /// No description provided for @bzWhatsWorkingSub.
  ///
  /// In en, this message translates to:
  /// **'Your business gifts'**
  String get bzWhatsWorkingSub;

  /// No description provided for @bzClassicYogas.
  ///
  /// In en, this message translates to:
  /// **'Classic wealth combinations'**
  String get bzClassicYogas;

  /// No description provided for @bzFounderType.
  ///
  /// In en, this message translates to:
  /// **'Your Founder Type'**
  String get bzFounderType;

  /// No description provided for @bzSoulBusiness.
  ///
  /// In en, this message translates to:
  /// **'Soul & Business Purpose'**
  String get bzSoulBusiness;

  /// No description provided for @bzSoulPlanet.
  ///
  /// In en, this message translates to:
  /// **'Your Soul Driver'**
  String get bzSoulPlanet;

  /// No description provided for @bzBusinessPlanet.
  ///
  /// In en, this message translates to:
  /// **'Your Business Mind'**
  String get bzBusinessPlanet;

  /// No description provided for @bzDirectionStrength.
  ///
  /// In en, this message translates to:
  /// **'Direction Clarity'**
  String get bzDirectionStrength;

  /// No description provided for @bzAlignStrong.
  ///
  /// In en, this message translates to:
  /// **'Your soul purpose and business direction are strongly aligned — building a venture feels natural and fulfilling.'**
  String get bzAlignStrong;

  /// No description provided for @bzAlignModerate.
  ///
  /// In en, this message translates to:
  /// **'Your soul purpose and business direction are moderately aligned — a venture works best when it reflects your deeper values.'**
  String get bzAlignModerate;

  /// No description provided for @bzAlignLow.
  ///
  /// In en, this message translates to:
  /// **'Your soul purpose and business direction need conscious alignment — choose a venture that genuinely matches who you are.'**
  String get bzAlignLow;

  /// No description provided for @bzTechAtmakaraka.
  ///
  /// In en, this message translates to:
  /// **'Soul planet (Atmakaraka)'**
  String get bzTechAtmakaraka;

  /// No description provided for @bzTechAmatyakaraka.
  ///
  /// In en, this message translates to:
  /// **'Business planet (Amatyakaraka)'**
  String get bzTechAmatyakaraka;

  /// No description provided for @bzTechDarakaraka.
  ///
  /// In en, this message translates to:
  /// **'Partner planet (Darakaraka)'**
  String get bzTechDarakaraka;

  /// No description provided for @bzFoundation.
  ///
  /// In en, this message translates to:
  /// **'Business Foundation'**
  String get bzFoundation;

  /// No description provided for @bzCareerHouse.
  ///
  /// In en, this message translates to:
  /// **'Career House'**
  String get bzCareerHouse;

  /// No description provided for @bzGainsHouse.
  ///
  /// In en, this message translates to:
  /// **'Gains House'**
  String get bzGainsHouse;

  /// No description provided for @bzLord.
  ///
  /// In en, this message translates to:
  /// **'Ruler'**
  String get bzLord;

  /// No description provided for @bzGainsPotential.
  ///
  /// In en, this message translates to:
  /// **'Gains Potential'**
  String get bzGainsPotential;

  /// No description provided for @bzNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network Power'**
  String get bzNetwork;

  /// No description provided for @bzRecovery.
  ///
  /// In en, this message translates to:
  /// **'Recovery Strength'**
  String get bzRecovery;

  /// No description provided for @bzVerification.
  ///
  /// In en, this message translates to:
  /// **'Cross-Chart Verification'**
  String get bzVerification;

  /// No description provided for @bzD10.
  ///
  /// In en, this message translates to:
  /// **'Career Chart (D10)'**
  String get bzD10;

  /// No description provided for @bzD11.
  ///
  /// In en, this message translates to:
  /// **'Gains Chart (D11)'**
  String get bzD11;

  /// No description provided for @bzD9.
  ///
  /// In en, this message translates to:
  /// **'Purpose Chart (D9)'**
  String get bzD9;

  /// No description provided for @bzD60.
  ///
  /// In en, this message translates to:
  /// **'Karma Chart (D60)'**
  String get bzD60;

  /// No description provided for @bzFounderSkills.
  ///
  /// In en, this message translates to:
  /// **'Founder Skills'**
  String get bzFounderSkills;

  /// No description provided for @bzSkillStrategy.
  ///
  /// In en, this message translates to:
  /// **'Strategic Thinking'**
  String get bzSkillStrategy;

  /// No description provided for @bzSkillExecution.
  ///
  /// In en, this message translates to:
  /// **'Execution'**
  String get bzSkillExecution;

  /// No description provided for @bzSkillPeople.
  ///
  /// In en, this message translates to:
  /// **'People Management'**
  String get bzSkillPeople;

  /// No description provided for @bzSkillSales.
  ///
  /// In en, this message translates to:
  /// **'Sales & Persuasion'**
  String get bzSkillSales;

  /// No description provided for @bzSkillFinance.
  ///
  /// In en, this message translates to:
  /// **'Financial Acumen'**
  String get bzSkillFinance;

  /// No description provided for @bzSkillOps.
  ///
  /// In en, this message translates to:
  /// **'Operational Discipline'**
  String get bzSkillOps;

  /// No description provided for @bzTopSkill.
  ///
  /// In en, this message translates to:
  /// **'Top Skill'**
  String get bzTopSkill;

  /// No description provided for @bzDomains.
  ///
  /// In en, this message translates to:
  /// **'Best Business Fields'**
  String get bzDomains;

  /// No description provided for @bzDomainsSub.
  ///
  /// In en, this message translates to:
  /// **'Ranked by natural fit'**
  String get bzDomainsSub;

  /// No description provided for @bzFit.
  ///
  /// In en, this message translates to:
  /// **'FIT'**
  String get bzFit;

  /// No description provided for @bzBusinessStyleHdr.
  ///
  /// In en, this message translates to:
  /// **'Business Style'**
  String get bzBusinessStyleHdr;

  /// No description provided for @bzStyleService.
  ///
  /// In en, this message translates to:
  /// **'Product vs Service'**
  String get bzStyleService;

  /// No description provided for @bzStyleMarket.
  ///
  /// In en, this message translates to:
  /// **'Market Focus'**
  String get bzStyleMarket;

  /// No description provided for @bzStyleTech.
  ///
  /// In en, this message translates to:
  /// **'Tech Approach'**
  String get bzStyleTech;

  /// No description provided for @bzStyleLeadership.
  ///
  /// In en, this message translates to:
  /// **'Leadership Style'**
  String get bzStyleLeadership;

  /// No description provided for @bzStylePartnership.
  ///
  /// In en, this message translates to:
  /// **'Solo or Partnership'**
  String get bzStylePartnership;

  /// No description provided for @bzWhereBuild.
  ///
  /// In en, this message translates to:
  /// **'Reach'**
  String get bzWhereBuild;

  /// No description provided for @bzExpansion.
  ///
  /// In en, this message translates to:
  /// **'Expansion'**
  String get bzExpansion;

  /// No description provided for @bzSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get bzSetup;

  /// No description provided for @bzPartnership.
  ///
  /// In en, this message translates to:
  /// **'Partnership & Team'**
  String get bzPartnership;

  /// No description provided for @bzIdealCofounder.
  ///
  /// In en, this message translates to:
  /// **'Ideal Co-founder'**
  String get bzIdealCofounder;

  /// No description provided for @bzPartnerViability.
  ///
  /// In en, this message translates to:
  /// **'Partnership Fit'**
  String get bzPartnerViability;

  /// No description provided for @bzTeamBuilding.
  ///
  /// In en, this message translates to:
  /// **'Team Building'**
  String get bzTeamBuilding;

  /// No description provided for @bzCofounderFit.
  ///
  /// In en, this message translates to:
  /// **'Co-founder Fit'**
  String get bzCofounderFit;

  /// No description provided for @bzAdvisorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Advisor Network'**
  String get bzAdvisorNetwork;

  /// No description provided for @bzFunding.
  ///
  /// In en, this message translates to:
  /// **'Funding & Money'**
  String get bzFunding;

  /// No description provided for @bzRecommendedPath.
  ///
  /// In en, this message translates to:
  /// **'Recommended Funding Path'**
  String get bzRecommendedPath;

  /// No description provided for @bzInvestorAttract.
  ///
  /// In en, this message translates to:
  /// **'Investor Appeal'**
  String get bzInvestorAttract;

  /// No description provided for @bzFamilyBacking.
  ///
  /// In en, this message translates to:
  /// **'Family Support'**
  String get bzFamilyBacking;

  /// No description provided for @bzHybridViability.
  ///
  /// In en, this message translates to:
  /// **'Job + Business Mix'**
  String get bzHybridViability;

  /// No description provided for @bzFallback.
  ///
  /// In en, this message translates to:
  /// **'Job as Backup'**
  String get bzFallback;

  /// No description provided for @bzDebtStyle.
  ///
  /// In en, this message translates to:
  /// **'Debt Style'**
  String get bzDebtStyle;

  /// No description provided for @bzTimeline.
  ///
  /// In en, this message translates to:
  /// **'Business Timeline'**
  String get bzTimeline;

  /// No description provided for @bzCurrentPhase.
  ///
  /// In en, this message translates to:
  /// **'Right Now'**
  String get bzCurrentPhase;

  /// No description provided for @bzLaunchWindow.
  ///
  /// In en, this message translates to:
  /// **'Launch Window'**
  String get bzLaunchWindow;

  /// No description provided for @bzScaleWindow.
  ///
  /// In en, this message translates to:
  /// **'Growth Window'**
  String get bzScaleWindow;

  /// No description provided for @bzPeakAge.
  ///
  /// In en, this message translates to:
  /// **'Peak Years'**
  String get bzPeakAge;

  /// No description provided for @bzChallenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges to Watch'**
  String get bzChallenges;

  /// No description provided for @bzRiskFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial Loss'**
  String get bzRiskFinancial;

  /// No description provided for @bzRiskBurnout.
  ///
  /// In en, this message translates to:
  /// **'Burnout'**
  String get bzRiskBurnout;

  /// No description provided for @bzRiskTeam.
  ///
  /// In en, this message translates to:
  /// **'Team Conflict'**
  String get bzRiskTeam;

  /// No description provided for @bzRiskLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal / Regulatory'**
  String get bzRiskLegal;

  /// No description provided for @bzFinancialExp.
  ///
  /// In en, this message translates to:
  /// **'Risk of money loss from over-investment or poor cash-flow timing during a venture.'**
  String get bzFinancialExp;

  /// No description provided for @bzFinancialFix.
  ///
  /// In en, this message translates to:
  /// **'Keep a cash reserve, start lean, and validate demand before scaling spend.'**
  String get bzFinancialFix;

  /// No description provided for @bzBurnoutExp.
  ///
  /// In en, this message translates to:
  /// **'Pushing too hard for too long can drain your energy and focus.'**
  String get bzBurnoutExp;

  /// No description provided for @bzBurnoutFix.
  ///
  /// In en, this message translates to:
  /// **'Protect rest, delegate early, and pace big pushes around supportive periods.'**
  String get bzBurnoutFix;

  /// No description provided for @bzTeamExp.
  ///
  /// In en, this message translates to:
  /// **'Friction with co-founders or staff can slow the business down.'**
  String get bzTeamExp;

  /// No description provided for @bzTeamFix.
  ///
  /// In en, this message translates to:
  /// **'Set clear roles and expectations in writing, and communicate often.'**
  String get bzTeamFix;

  /// No description provided for @bzLegalExp.
  ///
  /// In en, this message translates to:
  /// **'Compliance, contracts or regulatory issues could create obstacles.'**
  String get bzLegalExp;

  /// No description provided for @bzLegalFix.
  ///
  /// In en, this message translates to:
  /// **'Get contracts reviewed, keep paperwork clean, and consult professionals early.'**
  String get bzLegalFix;

  /// No description provided for @bzImprovementPlan.
  ///
  /// In en, this message translates to:
  /// **'Improvement Plan'**
  String get bzImprovementPlan;

  /// No description provided for @bzBestDirection.
  ///
  /// In en, this message translates to:
  /// **'Best Direction'**
  String get bzBestDirection;

  /// No description provided for @bzStrategy.
  ///
  /// In en, this message translates to:
  /// **'Build Strategy'**
  String get bzStrategy;

  /// No description provided for @bzTopFields.
  ///
  /// In en, this message translates to:
  /// **'Top Fields'**
  String get bzTopFields;

  /// No description provided for @bzEmploymentPath.
  ///
  /// In en, this message translates to:
  /// **'Job vs Business'**
  String get bzEmploymentPath;

  /// No description provided for @bzRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Growth Roadmap'**
  String get bzRoadmap;

  /// No description provided for @bzRoadmapSub.
  ///
  /// In en, this message translates to:
  /// **'Your venture plan'**
  String get bzRoadmapSub;

  /// No description provided for @bzReliability.
  ///
  /// In en, this message translates to:
  /// **'Prediction Reliability'**
  String get bzReliability;

  /// No description provided for @bzLayerBirth.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart (D1)'**
  String get bzLayerBirth;

  /// No description provided for @bzLayerNavamsa.
  ///
  /// In en, this message translates to:
  /// **'Navamsa (D9)'**
  String get bzLayerNavamsa;

  /// No description provided for @bzLayerDashamsa.
  ///
  /// In en, this message translates to:
  /// **'Career (D10)'**
  String get bzLayerDashamsa;

  /// No description provided for @bzLayerLabhamsa.
  ///
  /// In en, this message translates to:
  /// **'Gains (D11)'**
  String get bzLayerLabhamsa;

  /// No description provided for @bzLayerShashtiamsa.
  ///
  /// In en, this message translates to:
  /// **'Karma (D60)'**
  String get bzLayerShashtiamsa;

  /// No description provided for @bzTopicStart.
  ///
  /// In en, this message translates to:
  /// **'Should I start now?'**
  String get bzTopicStart;

  /// No description provided for @bzTopicIdea.
  ///
  /// In en, this message translates to:
  /// **'Best business idea'**
  String get bzTopicIdea;

  /// No description provided for @bzTopicPartner.
  ///
  /// In en, this message translates to:
  /// **'Finding a co-founder'**
  String get bzTopicPartner;

  /// No description provided for @bzTopicFunding.
  ///
  /// In en, this message translates to:
  /// **'How to fund it'**
  String get bzTopicFunding;

  /// No description provided for @bzTopicScale.
  ///
  /// In en, this message translates to:
  /// **'When to scale'**
  String get bzTopicScale;

  /// No description provided for @bzTopicRisk.
  ///
  /// In en, this message translates to:
  /// **'Managing risks'**
  String get bzTopicRisk;

  /// No description provided for @bzTopicJob.
  ///
  /// In en, this message translates to:
  /// **'Job vs business'**
  String get bzTopicJob;

  /// No description provided for @bzTopicTiming.
  ///
  /// In en, this message translates to:
  /// **'Best timing'**
  String get bzTopicTiming;

  /// No description provided for @crTitle.
  ///
  /// In en, this message translates to:
  /// **'Career & Job Analysis'**
  String get crTitle;

  /// No description provided for @crSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Vedic Career Report'**
  String get crSubtitle;

  /// No description provided for @crCrumbHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get crCrumbHome;

  /// No description provided for @crCrumbReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get crCrumbReports;

  /// No description provided for @crCareerPotential.
  ///
  /// In en, this message translates to:
  /// **'Career Potential'**
  String get crCareerPotential;

  /// No description provided for @crStatusStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong Potential'**
  String get crStatusStrong;

  /// No description provided for @crStatusGood.
  ///
  /// In en, this message translates to:
  /// **'Good Potential'**
  String get crStatusGood;

  /// No description provided for @crStatusModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate Potential'**
  String get crStatusModerate;

  /// No description provided for @crStatusDeveloping.
  ///
  /// In en, this message translates to:
  /// **'Developing Potential'**
  String get crStatusDeveloping;

  /// No description provided for @crStatusChallenging.
  ///
  /// In en, this message translates to:
  /// **'Challenging Phase'**
  String get crStatusChallenging;

  /// No description provided for @crOverallCareer.
  ///
  /// In en, this message translates to:
  /// **'Overall Career'**
  String get crOverallCareer;

  /// No description provided for @crStability.
  ///
  /// In en, this message translates to:
  /// **'Career Stability'**
  String get crStability;

  /// No description provided for @crGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth Potential'**
  String get crGrowth;

  /// No description provided for @crRecognition.
  ///
  /// In en, this message translates to:
  /// **'Recognition'**
  String get crRecognition;

  /// No description provided for @crSatisfaction.
  ///
  /// In en, this message translates to:
  /// **'Satisfaction'**
  String get crSatisfaction;

  /// No description provided for @crChipLeadership.
  ///
  /// In en, this message translates to:
  /// **'Leadership'**
  String get crChipLeadership;

  /// No description provided for @crChipCreativity.
  ///
  /// In en, this message translates to:
  /// **'Creativity'**
  String get crChipCreativity;

  /// No description provided for @crChipBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get crChipBusiness;

  /// No description provided for @crChipStableIncome.
  ///
  /// In en, this message translates to:
  /// **'Stable Income'**
  String get crChipStableIncome;

  /// No description provided for @crChipLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get crChipLearning;

  /// No description provided for @crChipGrowth.
  ///
  /// In en, this message translates to:
  /// **'Long-Term Growth'**
  String get crChipGrowth;

  /// No description provided for @crChipTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical Skill'**
  String get crChipTechnical;

  /// No description provided for @crChipRecognition.
  ///
  /// In en, this message translates to:
  /// **'Recognition'**
  String get crChipRecognition;

  /// No description provided for @crTopInsights.
  ///
  /// In en, this message translates to:
  /// **'Top Insights'**
  String get crTopInsights;

  /// No description provided for @crWhatDefines.
  ///
  /// In en, this message translates to:
  /// **'What defines your career?'**
  String get crWhatDefines;

  /// No description provided for @crSoulCareer.
  ///
  /// In en, this message translates to:
  /// **'Soul & Career Purpose'**
  String get crSoulCareer;

  /// No description provided for @crSoulPlanet.
  ///
  /// In en, this message translates to:
  /// **'Soul Purpose Planet'**
  String get crSoulPlanet;

  /// No description provided for @crCareerPlanet.
  ///
  /// In en, this message translates to:
  /// **'Career Planet'**
  String get crCareerPlanet;

  /// No description provided for @crMeaning.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get crMeaning;

  /// No description provided for @crAlignment.
  ///
  /// In en, this message translates to:
  /// **'Soul ↔ Career Alignment'**
  String get crAlignment;

  /// No description provided for @crAlignStrong.
  ///
  /// In en, this message translates to:
  /// **'Your natural interests and career path are strongly aligned.'**
  String get crAlignStrong;

  /// No description provided for @crAlignModerate.
  ///
  /// In en, this message translates to:
  /// **'Your natural interests and career path are moderately aligned.'**
  String get crAlignModerate;

  /// No description provided for @crAlignLow.
  ///
  /// In en, this message translates to:
  /// **'Your natural interests and career path need conscious alignment.'**
  String get crAlignLow;

  /// No description provided for @crTechAtmakaraka.
  ///
  /// In en, this message translates to:
  /// **'Atmakaraka (Soul indicator)'**
  String get crTechAtmakaraka;

  /// No description provided for @crTechAmatyakaraka.
  ///
  /// In en, this message translates to:
  /// **'Amatyakaraka (Career indicator)'**
  String get crTechAmatyakaraka;

  /// No description provided for @crDegrees.
  ///
  /// In en, this message translates to:
  /// **'Degrees'**
  String get crDegrees;

  /// No description provided for @crDignity.
  ///
  /// In en, this message translates to:
  /// **'Dignity'**
  String get crDignity;

  /// No description provided for @crFoundation.
  ///
  /// In en, this message translates to:
  /// **'Career Foundation'**
  String get crFoundation;

  /// No description provided for @crCareerSign.
  ///
  /// In en, this message translates to:
  /// **'Career Sign'**
  String get crCareerSign;

  /// No description provided for @crCareerLord.
  ///
  /// In en, this message translates to:
  /// **'Career Lord'**
  String get crCareerLord;

  /// No description provided for @crLordPosition.
  ///
  /// In en, this message translates to:
  /// **'Lord Position'**
  String get crLordPosition;

  /// No description provided for @crCareerStrength.
  ///
  /// In en, this message translates to:
  /// **'Career Strength'**
  String get crCareerStrength;

  /// No description provided for @crProfStyle.
  ///
  /// In en, this message translates to:
  /// **'Professional Style'**
  String get crProfStyle;

  /// No description provided for @crBestFields.
  ///
  /// In en, this message translates to:
  /// **'Best Fields'**
  String get crBestFields;

  /// No description provided for @crTechnicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Technical Details'**
  String get crTechnicalDetails;

  /// No description provided for @crHouseLabel.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get crHouseLabel;

  /// No description provided for @crVerification.
  ///
  /// In en, this message translates to:
  /// **'Career Verification Across Charts'**
  String get crVerification;

  /// No description provided for @crD10Career.
  ///
  /// In en, this message translates to:
  /// **'D10 · Career'**
  String get crD10Career;

  /// No description provided for @crD9Purpose.
  ///
  /// In en, this message translates to:
  /// **'D9 · Purpose'**
  String get crD9Purpose;

  /// No description provided for @crD60Karma.
  ///
  /// In en, this message translates to:
  /// **'D60 · Karma'**
  String get crD60Karma;

  /// No description provided for @crStatusNeedsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get crStatusNeedsImprovement;

  /// No description provided for @crStatusWellAligned.
  ///
  /// In en, this message translates to:
  /// **'Well Aligned'**
  String get crStatusWellAligned;

  /// No description provided for @crStatusStrongSupport.
  ///
  /// In en, this message translates to:
  /// **'Strong Support'**
  String get crStatusStrongSupport;

  /// No description provided for @crStatusModerateSupport.
  ///
  /// In en, this message translates to:
  /// **'Moderate Support'**
  String get crStatusModerateSupport;

  /// No description provided for @crChartDetails.
  ///
  /// In en, this message translates to:
  /// **'Technical chart details'**
  String get crChartDetails;

  /// No description provided for @crPersonality.
  ///
  /// In en, this message translates to:
  /// **'Your Career Personality'**
  String get crPersonality;

  /// No description provided for @crGrowthAreas.
  ///
  /// In en, this message translates to:
  /// **'Growth Areas'**
  String get crGrowthAreas;

  /// No description provided for @crBestRoles.
  ///
  /// In en, this message translates to:
  /// **'Best Roles'**
  String get crBestRoles;

  /// No description provided for @crBestIndustries.
  ///
  /// In en, this message translates to:
  /// **'Best Industries'**
  String get crBestIndustries;

  /// No description provided for @crEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Career Environment'**
  String get crEnvironment;

  /// No description provided for @crWorkStyle.
  ///
  /// In en, this message translates to:
  /// **'Best Work Style'**
  String get crWorkStyle;

  /// No description provided for @crEmployment.
  ///
  /// In en, this message translates to:
  /// **'Employment'**
  String get crEmployment;

  /// No description provided for @crBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get crBusiness;

  /// No description provided for @crFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance / Consulting'**
  String get crFreelance;

  /// No description provided for @crPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Mixed Portfolio'**
  String get crPortfolio;

  /// No description provided for @crLeadership.
  ///
  /// In en, this message translates to:
  /// **'Leadership'**
  String get crLeadership;

  /// No description provided for @crFit.
  ///
  /// In en, this message translates to:
  /// **'Fit'**
  String get crFit;

  /// No description provided for @crBestFit.
  ///
  /// In en, this message translates to:
  /// **'Best Fit'**
  String get crBestFit;

  /// No description provided for @crTimeline.
  ///
  /// In en, this message translates to:
  /// **'Career Timeline'**
  String get crTimeline;

  /// No description provided for @crPastPeak.
  ///
  /// In en, this message translates to:
  /// **'Past Peak'**
  String get crPastPeak;

  /// No description provided for @crPresentPhase.
  ///
  /// In en, this message translates to:
  /// **'Present Phase'**
  String get crPresentPhase;

  /// No description provided for @crUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Opportunity'**
  String get crUpcoming;

  /// No description provided for @crFutureExpansion.
  ///
  /// In en, this message translates to:
  /// **'Future Expansion'**
  String get crFutureExpansion;

  /// No description provided for @crRiskPeriod.
  ///
  /// In en, this message translates to:
  /// **'Risk Period'**
  String get crRiskPeriod;

  /// No description provided for @crViewDasha.
  ///
  /// In en, this message translates to:
  /// **'Planetary period (technical)'**
  String get crViewDasha;

  /// No description provided for @crChallenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges to Watch'**
  String get crChallenges;

  /// No description provided for @crRiskBurnout.
  ///
  /// In en, this message translates to:
  /// **'Burnout'**
  String get crRiskBurnout;

  /// No description provided for @crRiskRecognition.
  ///
  /// In en, this message translates to:
  /// **'Recognition Delay'**
  String get crRiskRecognition;

  /// No description provided for @crRiskConflict.
  ///
  /// In en, this message translates to:
  /// **'Workplace Conflict'**
  String get crRiskConflict;

  /// No description provided for @crRiskFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial Instability'**
  String get crRiskFinancial;

  /// No description provided for @crRiskOverqual.
  ///
  /// In en, this message translates to:
  /// **'Under-utilization'**
  String get crRiskOverqual;

  /// No description provided for @crPrevention.
  ///
  /// In en, this message translates to:
  /// **'Prevention'**
  String get crPrevention;

  /// No description provided for @crBurnoutExp.
  ///
  /// In en, this message translates to:
  /// **'Long, demanding phases can drain your energy over time.'**
  String get crBurnoutExp;

  /// No description provided for @crBurnoutFix.
  ///
  /// In en, this message translates to:
  /// **'Protect rest, set boundaries, and pace big pushes.'**
  String get crBurnoutFix;

  /// No description provided for @crRecognitionExp.
  ///
  /// In en, this message translates to:
  /// **'Rewards and recognition may arrive slower than your effort.'**
  String get crRecognitionExp;

  /// No description provided for @crRecognitionFix.
  ///
  /// In en, this message translates to:
  /// **'Document wins and make your contributions visible to seniors.'**
  String get crRecognitionFix;

  /// No description provided for @crConflictExp.
  ///
  /// In en, this message translates to:
  /// **'Friction with colleagues or authority can surface at times.'**
  String get crConflictExp;

  /// No description provided for @crConflictFix.
  ///
  /// In en, this message translates to:
  /// **'Communicate calmly and pick your battles wisely.'**
  String get crConflictFix;

  /// No description provided for @crFinancialExp.
  ///
  /// In en, this message translates to:
  /// **'Income may feel uneven during certain phases.'**
  String get crFinancialExp;

  /// No description provided for @crFinancialFix.
  ///
  /// In en, this message translates to:
  /// **'Keep a buffer and avoid over-committing financially.'**
  String get crFinancialFix;

  /// No description provided for @crOverqualExp.
  ///
  /// In en, this message translates to:
  /// **'You may sometimes feel under-used or under-challenged.'**
  String get crOverqualExp;

  /// No description provided for @crOverqualFix.
  ///
  /// In en, this message translates to:
  /// **'Seek stretch roles and keep learning to stay engaged.'**
  String get crOverqualFix;

  /// No description provided for @crImprovementPlan.
  ///
  /// In en, this message translates to:
  /// **'Career Improvement Plan'**
  String get crImprovementPlan;

  /// No description provided for @crCatPlanetary.
  ///
  /// In en, this message translates to:
  /// **'Planetary & Spiritual'**
  String get crCatPlanetary;

  /// No description provided for @crCatPractical.
  ///
  /// In en, this message translates to:
  /// **'Practical Steps'**
  String get crCatPractical;

  /// No description provided for @crTraditionalExplain.
  ///
  /// In en, this message translates to:
  /// **'Traditional astrology explanation'**
  String get crTraditionalExplain;

  /// No description provided for @crActionPlan.
  ///
  /// In en, this message translates to:
  /// **'30-Day Career Action Plan'**
  String get crActionPlan;

  /// No description provided for @crWeek1.
  ///
  /// In en, this message translates to:
  /// **'Week 1 · Profile Optimization'**
  String get crWeek1;

  /// No description provided for @crWeek2.
  ///
  /// In en, this message translates to:
  /// **'Week 2 · Skill Building'**
  String get crWeek2;

  /// No description provided for @crWeek3.
  ///
  /// In en, this message translates to:
  /// **'Week 3 · Networking'**
  String get crWeek3;

  /// No description provided for @crWeek4.
  ///
  /// In en, this message translates to:
  /// **'Week 4 · Career Visibility'**
  String get crWeek4;

  /// No description provided for @crWeek1Tip.
  ///
  /// In en, this message translates to:
  /// **'Refresh your resume and LinkedIn around your strongest career theme.'**
  String get crWeek1Tip;

  /// No description provided for @crWeek2Tip.
  ///
  /// In en, this message translates to:
  /// **'Pick one high-value skill in your best field and practise it daily.'**
  String get crWeek2Tip;

  /// No description provided for @crWeek3Tip.
  ///
  /// In en, this message translates to:
  /// **'Reconnect with mentors and reach out to two new industry contacts.'**
  String get crWeek3Tip;

  /// No description provided for @crWeek4Tip.
  ///
  /// In en, this message translates to:
  /// **'Share your work publicly and volunteer for a visible project.'**
  String get crWeek4Tip;

  /// No description provided for @crPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get crPriority;

  /// No description provided for @crTimeRequired.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get crTimeRequired;

  /// No description provided for @crExpectedBenefit.
  ///
  /// In en, this message translates to:
  /// **'Benefit'**
  String get crExpectedBenefit;

  /// No description provided for @crPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get crPriorityHigh;

  /// No description provided for @crPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get crPriorityMedium;

  /// No description provided for @crRoadmap.
  ///
  /// In en, this message translates to:
  /// **'AI Career Roadmap'**
  String get crRoadmap;

  /// No description provided for @crNext12.
  ///
  /// In en, this message translates to:
  /// **'Next 12 Months'**
  String get crNext12;

  /// No description provided for @crBestFocus.
  ///
  /// In en, this message translates to:
  /// **'Best Focus'**
  String get crBestFocus;

  /// No description provided for @crSkillsLearn.
  ///
  /// In en, this message translates to:
  /// **'Skills to Learn'**
  String get crSkillsLearn;

  /// No description provided for @crIndustriesTarget.
  ///
  /// In en, this message translates to:
  /// **'Industries to Target'**
  String get crIndustriesTarget;

  /// No description provided for @crExpectedOutcome.
  ///
  /// In en, this message translates to:
  /// **'Expected Outcome'**
  String get crExpectedOutcome;

  /// No description provided for @crReliability.
  ///
  /// In en, this message translates to:
  /// **'Prediction Reliability'**
  String get crReliability;

  /// No description provided for @crReliabilityHigh.
  ///
  /// In en, this message translates to:
  /// **'High Reliability'**
  String get crReliabilityHigh;

  /// No description provided for @crReliabilityGood.
  ///
  /// In en, this message translates to:
  /// **'Good Reliability'**
  String get crReliabilityGood;

  /// No description provided for @crReliabilityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate Reliability'**
  String get crReliabilityModerate;

  /// No description provided for @crReliabilityExplain.
  ///
  /// In en, this message translates to:
  /// **'This report combines your birth chart, divisional charts and Jaimini indicators. The score reflects how strongly these chart layers agree.'**
  String get crReliabilityExplain;

  /// No description provided for @crChartLayers.
  ///
  /// In en, this message translates to:
  /// **'Chart layers & weights'**
  String get crChartLayers;

  /// No description provided for @crBirthChart.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart (D1)'**
  String get crBirthChart;

  /// No description provided for @crNavamsa.
  ///
  /// In en, this message translates to:
  /// **'Navamsa (D9)'**
  String get crNavamsa;

  /// No description provided for @crDashamsa.
  ///
  /// In en, this message translates to:
  /// **'Dashamsa (D10)'**
  String get crDashamsa;

  /// No description provided for @crShashtiamsa.
  ///
  /// In en, this message translates to:
  /// **'Shashtiamsa (D60)'**
  String get crShashtiamsa;

  /// No description provided for @crDiscussAi.
  ///
  /// In en, this message translates to:
  /// **'Discuss with AI'**
  String get crDiscussAi;

  /// No description provided for @crAskAbout.
  ///
  /// In en, this message translates to:
  /// **'Ask About'**
  String get crAskAbout;

  /// No description provided for @crTopicChange.
  ///
  /// In en, this message translates to:
  /// **'Career Change'**
  String get crTopicChange;

  /// No description provided for @crTopicGovt.
  ///
  /// In en, this message translates to:
  /// **'Government Job'**
  String get crTopicGovt;

  /// No description provided for @crTopicBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get crTopicBusiness;

  /// No description provided for @crTopicPromotion.
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get crTopicPromotion;

  /// No description provided for @crTopicMarriage.
  ///
  /// In en, this message translates to:
  /// **'Marriage vs Career'**
  String get crTopicMarriage;

  /// No description provided for @crTopicAbroad.
  ///
  /// In en, this message translates to:
  /// **'Abroad'**
  String get crTopicAbroad;

  /// No description provided for @crTopicIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get crTopicIncome;

  /// No description provided for @crTopicPurpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get crTopicPurpose;

  /// No description provided for @crTopicResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get crTopicResume;

  /// No description provided for @crTopicCopied.
  ///
  /// In en, this message translates to:
  /// **'Question copied — paste it into your AI chat.'**
  String get crTopicCopied;

  /// No description provided for @crAlignExplainKaraka.
  ///
  /// In en, this message translates to:
  /// **'{soul} guides your inner calling, while {career} shapes your outer profession.'**
  String crAlignExplainKaraka(Object soul, Object career);

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
