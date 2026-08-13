import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('hi'),
  ];

  /// Application name shown as the window/app title
  ///
  /// In en, this message translates to:
  /// **'Hindustani Jyotish'**
  String get appTitle;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get commonOnline;

  /// No description provided for @commonOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get commonOffline;

  /// No description provided for @commonErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get commonErrorGeneric;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navAstrologers.
  ///
  /// In en, this message translates to:
  /// **'Astrologers'**
  String get navAstrologers;

  /// No description provided for @navInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get navInsights;

  /// No description provided for @navWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get navWallet;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @authNamaste.
  ///
  /// In en, this message translates to:
  /// **'Namaste 🙏'**
  String get authNamaste;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Talk to verified Vedic astrologers in minutes.'**
  String get authWelcomeSubtitle;

  /// No description provided for @authContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get authContinue;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authGoogleHelper.
  ///
  /// In en, this message translates to:
  /// **'Sign in securely with your Google account'**
  String get authGoogleHelper;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Namaste 🙏'**
  String get homeGreeting;

  /// No description provided for @homeSeeker.
  ///
  /// In en, this message translates to:
  /// **'Seeker'**
  String get homeSeeker;

  /// No description provided for @homeCosmicInsights.
  ///
  /// In en, this message translates to:
  /// **'Cosmic Insights'**
  String get homeCosmicInsights;

  /// No description provided for @homeOnlineAstrologers.
  ///
  /// In en, this message translates to:
  /// **'Online Astrologers'**
  String get homeOnlineAstrologers;

  /// No description provided for @homeNoAstrologersOnline.
  ///
  /// In en, this message translates to:
  /// **'No astrologers online right now.'**
  String get homeNoAstrologersOnline;

  /// No description provided for @homePromoTitle.
  ///
  /// In en, this message translates to:
  /// **'First chat from ₹7/msg'**
  String get homePromoTitle;

  /// No description provided for @homePromoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Talk to verified Vedic astrologers now.'**
  String get homePromoSubtitle;

  /// No description provided for @homeLiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Astrologers live now'**
  String get homeLiveTitle;

  /// No description provided for @homeLiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join a stream, ask questions, send gifts.'**
  String get homeLiveSubtitle;

  /// No description provided for @homeFeaturedVideos.
  ///
  /// In en, this message translates to:
  /// **'Featured videos'**
  String get homeFeaturedVideos;

  /// No description provided for @toolDailyHoroscope.
  ///
  /// In en, this message translates to:
  /// **'Daily Horoscope'**
  String get toolDailyHoroscope;

  /// No description provided for @toolDetailedKundli.
  ///
  /// In en, this message translates to:
  /// **'Detailed Kundli'**
  String get toolDetailedKundli;

  /// No description provided for @toolLoveMatch.
  ///
  /// In en, this message translates to:
  /// **'Love Match'**
  String get toolLoveMatch;

  /// No description provided for @toolPlanetPosition.
  ///
  /// In en, this message translates to:
  /// **'Planet Position'**
  String get toolPlanetPosition;

  /// No description provided for @cardAstrologer.
  ///
  /// In en, this message translates to:
  /// **'Astrologer'**
  String get cardAstrologer;

  /// No description provided for @cardConsult.
  ///
  /// In en, this message translates to:
  /// **'Consult'**
  String get cardConsult;

  /// No description provided for @cardChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get cardChat;

  /// No description provided for @cardCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get cardCall;

  /// No description provided for @cardVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get cardVideo;

  /// No description provided for @cardYears.
  ///
  /// In en, this message translates to:
  /// **'{years} yrs'**
  String cardYears(Object years);

  /// No description provided for @cardYearsExp.
  ///
  /// In en, this message translates to:
  /// **'{years} yrs exp'**
  String cardYearsExp(Object years);

  /// No description provided for @cardRatePerMsg.
  ///
  /// In en, this message translates to:
  /// **'₹{rate}/msg'**
  String cardRatePerMsg(Object rate);

  /// No description provided for @cardRatePerMin.
  ///
  /// In en, this message translates to:
  /// **'₹{rate}/min'**
  String cardRatePerMin(Object rate);

  /// No description provided for @discoverySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search astrologers, skills…'**
  String get discoverySearchHint;

  /// No description provided for @discoveryOnlineNow.
  ///
  /// In en, this message translates to:
  /// **'Online now'**
  String get discoveryOnlineNow;

  /// No description provided for @discoveryLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get discoveryLanguage;

  /// No description provided for @discoverySkill.
  ///
  /// In en, this message translates to:
  /// **'Skill'**
  String get discoverySkill;

  /// No description provided for @discoverySort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get discoverySort;

  /// No description provided for @discoverySortTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get discoverySortTopRated;

  /// No description provided for @discoverySortPriceAsc.
  ///
  /// In en, this message translates to:
  /// **'Price: low to high'**
  String get discoverySortPriceAsc;

  /// No description provided for @discoverySortPriceDesc.
  ///
  /// In en, this message translates to:
  /// **'Price: high to low'**
  String get discoverySortPriceDesc;

  /// No description provided for @discoveryNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No astrologers match your filters.\nTry widening your search.'**
  String get discoveryNoMatch;

  /// No description provided for @discoveryReachedEnd.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the end'**
  String get discoveryReachedEnd;

  /// No description provided for @walletTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletTitle;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get walletBalance;

  /// No description provided for @walletQuickRecharge.
  ///
  /// In en, this message translates to:
  /// **'Quick recharge'**
  String get walletQuickRecharge;

  /// No description provided for @walletCustomAmount.
  ///
  /// In en, this message translates to:
  /// **'Custom amount'**
  String get walletCustomAmount;

  /// No description provided for @walletBiometricNote.
  ///
  /// In en, this message translates to:
  /// **'Recharges of ₹{amount} or more need biometric confirmation.'**
  String walletBiometricNote(Object amount);

  /// No description provided for @walletRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get walletRecentTransactions;

  /// No description provided for @walletNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet.'**
  String get walletNoTransactions;

  /// No description provided for @walletEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount in ₹.'**
  String get walletEnterValidAmount;

  /// No description provided for @walletBiometricRequired.
  ///
  /// In en, this message translates to:
  /// **'Biometric verification is required for this amount.'**
  String get walletBiometricRequired;

  /// No description provided for @walletRechargeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm your identity to recharge ₹{amount}'**
  String walletRechargeConfirm(Object amount);

  /// No description provided for @walletAddedToWallet.
  ///
  /// In en, this message translates to:
  /// **'₹{amount} added to your wallet.'**
  String walletAddedToWallet(Object amount);

  /// No description provided for @consultChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get consultChat;

  /// No description provided for @consultAudioCall.
  ///
  /// In en, this message translates to:
  /// **'Audio Call'**
  String get consultAudioCall;

  /// No description provided for @consultVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Video Call'**
  String get consultVideoCall;

  /// No description provided for @consultConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get consultConnected;

  /// No description provided for @consultWaitingForAstrologer.
  ///
  /// In en, this message translates to:
  /// **'Waiting for astrologer…'**
  String get consultWaitingForAstrologer;

  /// No description provided for @consultEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get consultEnded;

  /// Tooltip/screen-reader label on the chat composer's send button
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get consultSendMessage;

  /// Tooltip/screen-reader label on the consultation header's close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get consultCloseSession;

  /// No description provided for @consultReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get consultReady;

  /// No description provided for @consultStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get consultStart;

  /// No description provided for @consultTapStart.
  ///
  /// In en, this message translates to:
  /// **'Tap start to connect'**
  String get consultTapStart;

  /// No description provided for @consultConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get consultConnecting;

  /// No description provided for @consultSayNamaste.
  ///
  /// In en, this message translates to:
  /// **'Say Namaste to begin 🙏'**
  String get consultSayNamaste;

  /// No description provided for @consultConnectingAstrologer.
  ///
  /// In en, this message translates to:
  /// **'Connecting you to the astrologer…'**
  String get consultConnectingAstrologer;

  /// No description provided for @consultTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message…'**
  String get consultTypeMessage;

  /// No description provided for @consultWaitingAstrologer.
  ///
  /// In en, this message translates to:
  /// **'Waiting for astrologer…'**
  String get consultWaitingAstrologer;

  /// No description provided for @consultChatEnded.
  ///
  /// In en, this message translates to:
  /// **'This chat has ended.'**
  String get consultChatEnded;

  /// No description provided for @consultSessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Session ended'**
  String get consultSessionEnded;

  /// No description provided for @consultSessionEndedLowBalance.
  ///
  /// In en, this message translates to:
  /// **'Session ended (low balance)'**
  String get consultSessionEndedLowBalance;

  /// No description provided for @consultDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration: {seconds}s'**
  String consultDuration(Object seconds);

  /// No description provided for @consultCharged.
  ///
  /// In en, this message translates to:
  /// **'Charged: ₹{amount}'**
  String consultCharged(Object amount);

  /// No description provided for @consultSoFar.
  ///
  /// In en, this message translates to:
  /// **'so far'**
  String get consultSoFar;

  /// No description provided for @consultWaitingAstrologerJoin.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the astrologer to join…'**
  String get consultWaitingAstrologerJoin;

  /// No description provided for @consultEndCallConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'End this call?'**
  String get consultEndCallConfirmTitle;

  /// No description provided for @consultEndCallConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will end the live session for both of you and can\'t be undone.'**
  String get consultEndCallConfirmBody;

  /// No description provided for @commonEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get commonEnd;

  /// No description provided for @consultEndedInBackgroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Call ended'**
  String get consultEndedInBackgroundTitle;

  /// No description provided for @consultEndedInBackgroundBody.
  ///
  /// In en, this message translates to:
  /// **'This call ended while the app was in the background.'**
  String get consultEndedInBackgroundBody;

  /// No description provided for @consultReconnectingChat.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting chat…'**
  String get consultReconnectingChat;

  /// Call status shown while waiting for the astrologer's stream to come back after a network blip, before the grace window ends the call
  ///
  /// In en, this message translates to:
  /// **'Reconnecting…'**
  String get consultCallReconnecting;

  /// No description provided for @consultSessionEndedTimeUp.
  ///
  /// In en, this message translates to:
  /// **'Session ended (time limit reached)'**
  String get consultSessionEndedTimeUp;

  /// No description provided for @consultCallEndedBy.
  ///
  /// In en, this message translates to:
  /// **'Call ended by {name}'**
  String consultCallEndedBy(String name);

  /// No description provided for @consultTheAstrologer.
  ///
  /// In en, this message translates to:
  /// **'the astrologer'**
  String get consultTheAstrologer;

  /// Status under an outgoing chat bubble while its REST send is in flight
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get consultSending;

  /// Status under an outgoing chat bubble whose send failed; tapping it re-sends
  ///
  /// In en, this message translates to:
  /// **'Not sent · Tap to retry'**
  String get consultNotSentRetry;

  /// No description provided for @consultSpeakerOn.
  ///
  /// In en, this message translates to:
  /// **'Speaker on'**
  String get consultSpeakerOn;

  /// No description provided for @consultSpeakerOff.
  ///
  /// In en, this message translates to:
  /// **'Speaker off'**
  String get consultSpeakerOff;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileSeeker.
  ///
  /// In en, this message translates to:
  /// **'Seeker'**
  String get profileSeeker;

  /// No description provided for @profileAppLockTitle.
  ///
  /// In en, this message translates to:
  /// **'App lock (biometric)'**
  String get profileAppLockTitle;

  /// No description provided for @profileAppLockOn.
  ///
  /// In en, this message translates to:
  /// **'Require biometric unlock to open the app.'**
  String get profileAppLockOn;

  /// No description provided for @profileAppLockOff.
  ///
  /// In en, this message translates to:
  /// **'No biometric set up on this device.'**
  String get profileAppLockOff;

  /// No description provided for @profileChatCallHistory.
  ///
  /// In en, this message translates to:
  /// **'Chat & call history'**
  String get profileChatCallHistory;

  /// No description provided for @profilePaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get profilePaymentHistory;

  /// No description provided for @profileBecomeAstrologer.
  ///
  /// In en, this message translates to:
  /// **'Become an astrologer'**
  String get profileBecomeAstrologer;

  /// No description provided for @profileHelpline.
  ///
  /// In en, this message translates to:
  /// **'Helpline & support'**
  String get profileHelpline;

  /// No description provided for @helplineNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Helpline contact has not been added yet.'**
  String get helplineNotConfigured;

  /// No description provided for @helplineEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get helplineEmail;

  /// No description provided for @helplinePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get helplinePhone;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy has not been added yet.'**
  String get privacyPolicyNotConfigured;

  /// No description provided for @profileAboutTerms.
  ///
  /// In en, this message translates to:
  /// **'About · Terms · Privacy'**
  String get profileAboutTerms;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @profileFollowUs.
  ///
  /// In en, this message translates to:
  /// **'Follow us'**
  String get profileFollowUs;

  /// No description provided for @profileLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link — copied it instead.'**
  String get profileLinkCopied;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language / भाषा'**
  String get profileLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @profileTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileTheme;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeSystem;

  /// No description provided for @completeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get completeProfileTitle;

  /// No description provided for @completeProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your name and contact number — that\'s all we need to get started.'**
  String get completeProfileSubtitle;

  /// No description provided for @completeProfileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get completeProfileFullName;

  /// No description provided for @completeProfileContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact number'**
  String get completeProfileContactNumber;

  /// No description provided for @completeProfileSaveContinue.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get completeProfileSaveContinue;

  /// No description provided for @completeProfilePhotoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a profile photo (optional)'**
  String get completeProfilePhotoAdd;

  /// No description provided for @completeProfilePhotoChange.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get completeProfilePhotoChange;

  /// No description provided for @completeProfilePhotoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not upload the photo. Please try again.'**
  String get completeProfilePhotoUploadFailed;

  /// No description provided for @completeProfileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get completeProfileNameRequired;

  /// No description provided for @completeProfileMobileIndia.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number for +91.'**
  String get completeProfileMobileIndia;

  /// No description provided for @completeProfileMobileGeneric.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid contact number (4–15 digits).'**
  String get completeProfileMobileGeneric;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditProfile;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your photo, name and contact number.'**
  String get editProfileSubtitle;

  /// No description provided for @editProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get editProfileSaved;

  /// No description provided for @profileBirthDetails.
  ///
  /// In en, this message translates to:
  /// **'Birth details'**
  String get profileBirthDetails;

  /// No description provided for @birthDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your birth details power your Kundli & predictions.'**
  String get birthDetailsSubtitle;

  /// No description provided for @birthDob.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get birthDob;

  /// No description provided for @birthTimeOptional.
  ///
  /// In en, this message translates to:
  /// **'Time of birth (optional)'**
  String get birthTimeOptional;

  /// No description provided for @birthPlaceOptional.
  ///
  /// In en, this message translates to:
  /// **'Birth place (optional)'**
  String get birthPlaceOptional;

  /// No description provided for @birthSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get birthSelect;

  /// No description provided for @birthDobRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth.'**
  String get birthDobRequired;

  /// No description provided for @birthSaved.
  ///
  /// In en, this message translates to:
  /// **'Birth details saved.'**
  String get birthSaved;

  /// No description provided for @insightsNeedBirthDetails.
  ///
  /// In en, this message translates to:
  /// **'Add your birth details in Profile to unlock this insight.'**
  String get insightsNeedBirthDetails;

  /// No description provided for @insightsAddBirthDetails.
  ///
  /// In en, this message translates to:
  /// **'Add now'**
  String get insightsAddBirthDetails;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cosmic Insights'**
  String get insightsTitle;

  /// No description provided for @insightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalised Vedic reports, instantly.'**
  String get insightsSubtitle;

  /// No description provided for @insightDailyHoroscope.
  ///
  /// In en, this message translates to:
  /// **'Daily Horoscope'**
  String get insightDailyHoroscope;

  /// No description provided for @insightDetailedKundli.
  ///
  /// In en, this message translates to:
  /// **'Detailed Kundli'**
  String get insightDetailedKundli;

  /// No description provided for @insightPlanetPosition.
  ///
  /// In en, this message translates to:
  /// **'Planet Position'**
  String get insightPlanetPosition;

  /// No description provided for @insightLoveCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Love Compatibility'**
  String get insightLoveCompatibility;

  /// No description provided for @insightBirthdayNumber.
  ///
  /// In en, this message translates to:
  /// **'Birthday Number'**
  String get insightBirthdayNumber;

  /// No description provided for @insightDailyPrediction.
  ///
  /// In en, this message translates to:
  /// **'Daily Prediction'**
  String get insightDailyPrediction;

  /// No description provided for @insightsMyReports.
  ///
  /// In en, this message translates to:
  /// **'My Reports'**
  String get insightsMyReports;

  /// No description provided for @insightsMyReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your past reports and PDFs'**
  String get insightsMyReportsSubtitle;

  /// No description provided for @insightsChargedBalance.
  ///
  /// In en, this message translates to:
  /// **'Charged ₹{amount} · Balance ₹{balance}'**
  String insightsChargedBalance(Object amount, Object balance);

  /// No description provided for @insightDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get insightDownloadPdf;

  /// No description provided for @insightPdfOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the PDF.'**
  String get insightPdfOpenFailed;

  /// No description provided for @insightPreflightTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your details'**
  String get insightPreflightTitle;

  /// No description provided for @insightPreflightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'These details are needed to prepare your report and will be saved to your profile.'**
  String get insightPreflightSubtitle;

  /// No description provided for @insightGenerateTitle.
  ///
  /// In en, this message translates to:
  /// **'Birth details for this report'**
  String get insightGenerateTitle;

  /// No description provided for @insightGenerateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-filled from your profile. Edit any field to generate the report for someone else.'**
  String get insightGenerateSubtitle;

  /// No description provided for @insightGenerateCta.
  ///
  /// In en, this message translates to:
  /// **'Generate report'**
  String get insightGenerateCta;

  /// No description provided for @reportOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open this report.'**
  String get reportOpenFailed;

  /// No description provided for @insightSharePdf.
  ///
  /// In en, this message translates to:
  /// **'Share report'**
  String get insightSharePdf;

  /// No description provided for @reportSavedOffline.
  ///
  /// In en, this message translates to:
  /// **'Saved to this device — available offline.'**
  String get reportSavedOffline;

  /// No description provided for @insightPartnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Partner\'s details'**
  String get insightPartnerTitle;

  /// No description provided for @insightPartnerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your partner\'s birth details for the match.'**
  String get insightPartnerSubtitle;

  /// No description provided for @insightFieldName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get insightFieldName;

  /// No description provided for @insightFieldGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get insightFieldGender;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @insightFieldDob.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get insightFieldDob;

  /// No description provided for @insightFieldBirthTime.
  ///
  /// In en, this message translates to:
  /// **'Time of birth'**
  String get insightFieldBirthTime;

  /// No description provided for @insightFieldBirthPlace.
  ///
  /// In en, this message translates to:
  /// **'Birth place'**
  String get insightFieldBirthPlace;

  /// No description provided for @insightFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all the fields.'**
  String get insightFieldsRequired;

  /// No description provided for @kundliChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Lagna Chart (North Indian)'**
  String get kundliChartTitle;

  /// No description provided for @kundliRetroLegend.
  ///
  /// In en, this message translates to:
  /// **'(R) = retrograde (vakri)'**
  String get kundliRetroLegend;

  /// No description provided for @kundliLagnaLabel.
  ///
  /// In en, this message translates to:
  /// **'Lagna (Ascendant)'**
  String get kundliLagnaLabel;

  /// No description provided for @kundliPlanetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Planetary Positions'**
  String get kundliPlanetsTitle;

  /// No description provided for @kundliDashaTitle.
  ///
  /// In en, this message translates to:
  /// **'Vimshottari Mahadasha'**
  String get kundliDashaTitle;

  /// No description provided for @colPlanet.
  ///
  /// In en, this message translates to:
  /// **'Planet'**
  String get colPlanet;

  /// No description provided for @colSign.
  ///
  /// In en, this message translates to:
  /// **'Sign'**
  String get colSign;

  /// No description provided for @colDegree.
  ///
  /// In en, this message translates to:
  /// **'Degree'**
  String get colDegree;

  /// No description provided for @colNakshatra.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra'**
  String get colNakshatra;

  /// No description provided for @colPada.
  ///
  /// In en, this message translates to:
  /// **'Pada'**
  String get colPada;

  /// No description provided for @loveScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Compatibility Score'**
  String get loveScoreTitle;

  /// No description provided for @loveAshtakootTitle.
  ///
  /// In en, this message translates to:
  /// **'Ashtakoot (Gun Milan)'**
  String get loveAshtakootTitle;

  /// No description provided for @loveVerdictTitle.
  ///
  /// In en, this message translates to:
  /// **'Verdict'**
  String get loveVerdictTitle;

  /// No description provided for @loveStrengthsTitle.
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get loveStrengthsTitle;

  /// No description provided for @numberTraitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Traits'**
  String get numberTraitsTitle;

  /// No description provided for @numberLifePath.
  ///
  /// In en, this message translates to:
  /// **'Life Path Number'**
  String get numberLifePath;

  /// No description provided for @predictionActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Best actions today'**
  String get predictionActionsTitle;

  /// No description provided for @predictionCautionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Take care today'**
  String get predictionCautionsTitle;

  /// No description provided for @insightNoDetails.
  ///
  /// In en, this message translates to:
  /// **'Your report is ready — download the PDF for the full details.'**
  String get insightNoDetails;

  /// No description provided for @reportsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reports yet. Run an insight to generate your first report.'**
  String get reportsEmpty;

  /// No description provided for @reportsOpenPdf.
  ///
  /// In en, this message translates to:
  /// **'Open PDF'**
  String get reportsOpenPdf;

  /// Tooltip on the close button of the full-screen photo viewer
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get imageViewerClose;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
