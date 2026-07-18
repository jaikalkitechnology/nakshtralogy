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
