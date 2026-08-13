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

  /// Astrologer app name shown as the window/app title
  ///
  /// In en, this message translates to:
  /// **'Hindustani Jyotish — Astrologer'**
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

  /// No description provided for @commonSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonSettings;

  /// No description provided for @commonSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get commonSignOut;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get navRequests;

  /// No description provided for @navEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get navEarnings;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @authApplyTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply as Astrologer'**
  String get authApplyTitle;

  /// No description provided for @authApplySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Single dashboard for all your consultations & earnings.'**
  String get authApplySubtitle;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @dashWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get dashWelcomeBack;

  /// No description provided for @dashReviews.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String dashReviews(Object count);

  /// No description provided for @dashOnline.
  ///
  /// In en, this message translates to:
  /// **'You\'re Online'**
  String get dashOnline;

  /// No description provided for @dashOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re Offline'**
  String get dashOffline;

  /// No description provided for @dashOnlineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receiving consultation requests'**
  String get dashOnlineSubtitle;

  /// No description provided for @dashOfflineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Toggle to start receiving requests'**
  String get dashOfflineSubtitle;

  /// No description provided for @dashGoLive.
  ///
  /// In en, this message translates to:
  /// **'Go Live'**
  String get dashGoLive;

  /// No description provided for @dashRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get dashRequests;

  /// No description provided for @dashSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get dashSettings;

  /// No description provided for @dashSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Charges, bio, languages & photo'**
  String get dashSettingsSubtitle;

  /// No description provided for @statTodayEarnings.
  ///
  /// In en, this message translates to:
  /// **'Today\'s earnings'**
  String get statTodayEarnings;

  /// No description provided for @statBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get statBalance;

  /// No description provided for @statTodayConsults.
  ///
  /// In en, this message translates to:
  /// **'Today consults'**
  String get statTodayConsults;

  /// No description provided for @statTotalConsults.
  ///
  /// In en, this message translates to:
  /// **'Total consults'**
  String get statTotalConsults;

  /// No description provided for @statRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get statRating;

  /// No description provided for @statFollowers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get statFollowers;

  /// No description provided for @reqTitle.
  ///
  /// In en, this message translates to:
  /// **'Incoming Requests'**
  String get reqTitle;

  /// No description provided for @reqEmpty.
  ///
  /// In en, this message translates to:
  /// **'No pending requests.\nPull down to refresh.'**
  String get reqEmpty;

  /// No description provided for @reqRequestLabel.
  ///
  /// In en, this message translates to:
  /// **'{kind} request'**
  String reqRequestLabel(String kind);

  /// No description provided for @reqDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get reqDecline;

  /// No description provided for @reqAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get reqAccept;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileAstrologer.
  ///
  /// In en, this message translates to:
  /// **'Astrologer'**
  String get profileAstrologer;

  /// No description provided for @profileSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get profileSkills;

  /// No description provided for @profileLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get profileLanguages;

  /// No description provided for @profileExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get profileExperience;

  /// No description provided for @profileRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get profileRating;

  /// No description provided for @profileChatRate.
  ///
  /// In en, this message translates to:
  /// **'Chat rate'**
  String get profileChatRate;

  /// No description provided for @profileCallRate.
  ///
  /// In en, this message translates to:
  /// **'Call rate'**
  String get profileCallRate;

  /// No description provided for @profileVideoRate.
  ///
  /// In en, this message translates to:
  /// **'Video rate'**
  String get profileVideoRate;

  /// No description provided for @profileYears.
  ///
  /// In en, this message translates to:
  /// **'{years} yrs'**
  String profileYears(Object years);

  /// No description provided for @profileEditCharges.
  ///
  /// In en, this message translates to:
  /// **'Edit profile & charges'**
  String get profileEditCharges;

  /// No description provided for @setTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setTitle;

  /// No description provided for @setChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap the camera to change your photo'**
  String get setChangePhoto;

  /// No description provided for @setCharges.
  ///
  /// In en, this message translates to:
  /// **'Charges'**
  String get setCharges;

  /// No description provided for @setChatRate.
  ///
  /// In en, this message translates to:
  /// **'Chat rate'**
  String get setChatRate;

  /// No description provided for @setCallRate.
  ///
  /// In en, this message translates to:
  /// **'Call rate'**
  String get setCallRate;

  /// No description provided for @setVideoRate.
  ///
  /// In en, this message translates to:
  /// **'Video rate'**
  String get setVideoRate;

  /// No description provided for @setPerMessage.
  ///
  /// In en, this message translates to:
  /// **'₹ / message'**
  String get setPerMessage;

  /// No description provided for @setPerMinute.
  ///
  /// In en, this message translates to:
  /// **'₹ / minute'**
  String get setPerMinute;

  /// No description provided for @setSuperChatRate.
  ///
  /// In en, this message translates to:
  /// **'Super Chat price'**
  String get setSuperChatRate;

  /// No description provided for @setPerSuperChat.
  ///
  /// In en, this message translates to:
  /// **'₹ / super chat'**
  String get setPerSuperChat;

  /// No description provided for @setSuperChatInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Super Chat price (greater than ₹0).'**
  String get setSuperChatInvalid;

  /// No description provided for @setSuperChatMax.
  ///
  /// In en, this message translates to:
  /// **'The Super Chat price must not exceed ₹10000.'**
  String get setSuperChatMax;

  /// No description provided for @setAboutYou.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get setAboutYou;

  /// No description provided for @setDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get setDisplayName;

  /// No description provided for @setBio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get setBio;

  /// No description provided for @setBioHint.
  ///
  /// In en, this message translates to:
  /// **'Tell seekers about your practice…'**
  String get setBioHint;

  /// No description provided for @setSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get setSkills;

  /// No description provided for @setSkillsHint.
  ///
  /// In en, this message translates to:
  /// **'Vedic, Tarot, Numerology'**
  String get setSkillsHint;

  /// No description provided for @setLanguagesField.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get setLanguagesField;

  /// No description provided for @setLanguagesHint.
  ///
  /// In en, this message translates to:
  /// **'Hindi, English'**
  String get setLanguagesHint;

  /// No description provided for @setCommaSeparated.
  ///
  /// In en, this message translates to:
  /// **'Comma-separated'**
  String get setCommaSeparated;

  /// No description provided for @setKycDocsTitle.
  ///
  /// In en, this message translates to:
  /// **'KYC documents'**
  String get setKycDocsTitle;

  /// No description provided for @setKycDocsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The identity documents you submitted for verification.'**
  String get setKycDocsSubtitle;

  /// No description provided for @setKycDocsLocked.
  ///
  /// In en, this message translates to:
  /// **'Documents are locked after approval. Contact support to update them.'**
  String get setKycDocsLocked;

  /// No description provided for @setKycResubmit.
  ///
  /// In en, this message translates to:
  /// **'Update KYC documents'**
  String get setKycResubmit;

  /// No description provided for @setKycUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update KYC / payout details'**
  String get setKycUpdateButton;

  /// No description provided for @setKycUpdateNote.
  ///
  /// In en, this message translates to:
  /// **'Changes will apply after admin approval.'**
  String get setKycUpdateNote;

  /// No description provided for @setKycNotUploaded.
  ///
  /// In en, this message translates to:
  /// **'Not uploaded'**
  String get setKycNotUploaded;

  /// No description provided for @setKycLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load KYC documents.'**
  String get setKycLoadFailed;

  /// No description provided for @setDocPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get setDocPhoto;

  /// No description provided for @setDocPan.
  ///
  /// In en, this message translates to:
  /// **'PAN card'**
  String get setDocPan;

  /// No description provided for @setDocAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar front'**
  String get setDocAadhaar;

  /// No description provided for @setDocAadhaarBack.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar back'**
  String get setDocAadhaarBack;

  /// No description provided for @setDocBankProof.
  ///
  /// In en, this message translates to:
  /// **'Bank proof'**
  String get setDocBankProof;

  /// No description provided for @setDocCertificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get setDocCertificate;

  /// No description provided for @setPayoutMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payout method'**
  String get setPayoutMethodLabel;

  /// No description provided for @setPayoutUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get setPayoutUpi;

  /// No description provided for @setPayoutBank.
  ///
  /// In en, this message translates to:
  /// **'Bank account'**
  String get setPayoutBank;

  /// No description provided for @setSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get setSaveChanges;

  /// No description provided for @setSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get setSaving;

  /// No description provided for @setProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get setProfileUpdated;

  /// No description provided for @setPhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Photo updated'**
  String get setPhotoUpdated;

  /// No description provided for @setChangesPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Changes submitted for admin approval — they\'ll go live once approved.'**
  String get setChangesPendingApproval;

  /// No description provided for @setPendingEditBanner.
  ///
  /// In en, this message translates to:
  /// **'Your profile changes are awaiting admin approval.'**
  String get setPendingEditBanner;

  /// No description provided for @setPendingEditRejected.
  ///
  /// In en, this message translates to:
  /// **'Your recent profile changes were rejected.'**
  String get setPendingEditRejected;

  /// No description provided for @setPendingEditFields.
  ///
  /// In en, this message translates to:
  /// **'Changed fields: {fields}'**
  String setPendingEditFields(String fields);

  /// No description provided for @setFieldMobile.
  ///
  /// In en, this message translates to:
  /// **'Contact number'**
  String get setFieldMobile;

  /// No description provided for @setFieldCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Country code'**
  String get setFieldCountryCode;

  /// No description provided for @setFieldKyc.
  ///
  /// In en, this message translates to:
  /// **'KYC / payout details'**
  String get setFieldKyc;

  /// No description provided for @appLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get appLanguageSection;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language / भाषा'**
  String get appLanguage;

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
