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
  String get astrologerPanel;
  String get home;
  String get dashboard;
  String get charts;
  String get bookings;
  String get requests;
  String get chats;
  String get earnings;
  String get profile;
  String get live;
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
  String get todaysEarning;
  String get walletBalance;
  String get rating;
  String get totalSessions;
  String get consultations;
  String get response;
  String get online;
  String get offline;
  String get busy;
  String get goLive;
  String get streamTitle;
  String get description;
  String get start;
  String get rashiPredictions;
  String get todaysGochar;
  String get recentRequests;
  String get noRecentRequests;
  String get upcoming;
  String get viewAll;
  String get pending;
  String get accepted;
  String get completed;
  String get declined;
  String get clientCharts;
  String get newChart;
  String get noChartsCreated;
  String get newClientChart;
  String get clientBirthDetails;
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
  String get clientChartCreated;
  String get viewKundli;
  String get deleteChart;
  String get completeBirthChart;
  String get birthDetails;
  String get name;
  String get dob;
  String get tob;
  String get place;
  String get summary;
  String get planets;
  String get kundli;
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
  String get thisMonth;
  String get statement;
  String get all;
  String get credits;
  String get withdrawals;
  String get bonus;
  String get refunds;
  String get requestWithdrawal;
  String get withdraw;
  String get amount;
  String get upiId;
  String get bankTransfer;
  String get accountHolderName;
  String get accountNumber;
  String get ifscCode;
  String get submit;
  String get noTransactions;
  String get withdrawalHistory;
  String get typeGuidance;
  String get sessionEnded;
  String get endChat;
  String get endChatConfirm;
  String get activeNow;
  String get connecting;
  String get clientKundli;
  String get earned;
  String get connected;
  String get endCall;
  String get endStream;
  String get endStreamConfirm;
  String get goLiveBtn;
  String get viewers;
  String get peak;
  String get gifts;
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
  String get logout;
  String get selectLanguage;
  String get language;
  String get english;
  String get kycSubmit;
  String get kycPending;
  String get kycRejected;
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
