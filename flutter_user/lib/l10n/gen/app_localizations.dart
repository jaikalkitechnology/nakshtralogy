import "dart:async";
import "package:flutter/foundation.dart";
import "package:flutter/widgets.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:intl/intl.dart" as intl;

import "app_localizations_bn.dart";
import "app_localizations_en.dart";
import "app_localizations_gu.dart";
import "app_localizations_hi.dart";
import "app_localizations_kn.dart";
import "app_localizations_ml.dart";
import "app_localizations_mr.dart";
import "app_localizations_pa.dart";
import "app_localizations_ta.dart";
import "app_localizations_te.dart";

abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());
  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale("bn"),
    Locale("en"),
    Locale("gu"),
    Locale("hi"),
    Locale("kn"),
    Locale("ml"),
    Locale("mr"),
    Locale("pa"),
    Locale("ta"),
    Locale("te"),
  ];

  String get appName;
  String get cosmicJourneyAwaits;
  String get home;
  String get astrologers;
  String get services;
  String get wallet;
  String get profile;
  String get live;
  String get kundli;
  String get chat;
  String get call;
  String get video;
  String get signIn;
  String get createAccount;
  String get email;
  String get password;
  String get confirmPassword;
  String get fullName;
  String get phone;
  String get forgotPassword;
  String get sendResetLink;
  String get backToSignIn;
  String get dontHaveAccount;
  String get alreadyHaveAccount;
  String get continueGoogle;
  String get required;
  String get minSixChars;
  String get passwordsMismatch;
  String get validEmailRequired;
  String get loginFailed;
  String get signupFailed;
  String get welcomeBack;
  String get todaysHoroscope;
  String get todaysRashi;
  String get tapDetails;
  String get allServices;
  String get seeAll;
  String get topAstrologers;
  String get onlineExperts;
  String get searchAstrologers;
  String get noAstrologersFound;
  String get online;
  String get offline;
  String get busy;
  String get perMin;
  String get noCharts;
  String get createFirst;
  String get createChart;
  String get newBirthChart;
  String get clientName;
  String get gender;
  String get male;
  String get female;
  String get other;
  String get dateOfBirth;
  String get timeOfBirth;
  String get birthPlace;
  String get birthPlaceHint;
  String get generateKundli;
  String get birthChartCreated;
  String get deleteChart;
  String get cannotUndo;
  String get primary;
  String get viewKundli;
  String get completeBirthChart;
  String get birthDetails;
  String get name;
  String get dob;
  String get tob;
  String get place;
  String get summary;
  String get planets;
  String get divisions;
  String get vimshottari;
  String get moola;
  String get gochar;
  String get dosh;
  String get yoga;
  String get shadbala;
  String get ashtakavarga;
  String get aspects;
  String get lifeAreas;
  String get bhava;
  String get chakras;
  String get dashaActive;
  String get lagna;
  String get moon;
  String get sun;
  String get premiumSection;
  String get unlockReading;
  String get unlock;
  String get retrograde;
  String get combust;
  String get vargottama;
  String get exalted;
  String get debilitated;
  String get addBalance;
  String get amount;
  String get walletBalance;
  String get recharge;
  String get bonus;
  String get serviceLabel;
  String get refund;
  String get noTransactions;
  String get editProfile;
  String get savedAstrologers;
  String get noSavedAstrologers;
  String get myOrders;
  String get communicationHistory;
  String get chatHistory;
  String get callHistory;
  String get logout;
  String get chatMessages;
  String get typeMessage;
  String get sessionEnded;
  String get endChat;
  String get endChatConfirm;
  String get sendPhoto;
  String get sendPDF;
  String get upload;
  String get fileNotFound;
  String get voiceCall;
  String get videoCall;
  String get ringing;
  String get connected;
  String get endCall;
  String get mute;
  String get unmute;
  String get speaker;
  String get camera;
  String get flip;
  String get liveStreams;
  String get noLiveStreams;
  String get astrologerUnavailable;
  String get streamEnded;
  String get superChat;
  String get sendGift;
  String get goBack;
  String get appPermissions;
  String get grantPermissions;
  String get skipForNow;
  String get microphone;
  String get notifications;
  String get storage;
  String get ok;
  String get cancel;
  String get save;
  String get edit;
  String get delete;
  String get retry;
  String get send;
  String get refresh;
  String get loading;
  String get noData;
  String get error;
  String get success;
  String get selectLanguage;
  String get language;
  String get english;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }
  @override
  bool isSupported(Locale locale) => <String>["bn", "en", "gu", "hi", "kn", "ml", "mr", "pa", "ta", "te"].contains(locale.languageCode);
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case "bn": return AppLocalizationsBn();
    case "en": return AppLocalizationsEn();
    case "gu": return AppLocalizationsGu();
    case "hi": return AppLocalizationsHi();
    case "kn": return AppLocalizationsKn();
    case "ml": return AppLocalizationsMl();
    case "mr": return AppLocalizationsMr();
    case "pa": return AppLocalizationsPa();
    case "ta": return AppLocalizationsTa();
    case "te": return AppLocalizationsTe();
  }
  throw FlutterError("AppLocalizations delegate received unsupported locale \"$locale\"");
}
