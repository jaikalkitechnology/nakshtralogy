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
  /// **'EARNED'**
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
