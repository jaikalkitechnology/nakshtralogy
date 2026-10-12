// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get awChooseLanguage => 'Wählen Sie Ihre Sprache';

  @override
  String get awGoogleFailed =>
      'Google-Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get awCompleteProfileTitle => 'Vervollständigen Sie Ihr Profil';

  @override
  String awWelcomeName(String name) {
    return 'Willkommen, $name!';
  }

  @override
  String get awCompleteProfileSubtitle =>
      'Ein paar Angaben, um Nakshatralogy für Sie zu personalisieren.';

  @override
  String get awRegionLabel => 'Region';

  @override
  String get awRegionIndia => 'Indien';

  @override
  String get awRegionInternational => 'International';

  @override
  String get awPreferredLanguage => 'Bevorzugte Sprache';

  @override
  String get awFinishSetup => 'Einrichtung abschließen';

  @override
  String get awChatFileWebUnsupported =>
      'Das Teilen von Dateien ist im Web noch nicht verfügbar. Bitte verwenden Sie die mobile App.';

  @override
  String get awVideoUnsupported =>
      'Videoanrufe werden in diesem Browser nicht unterstützt. Bitte verwenden Sie unsere mobile App oder einen unterstützten Desktop-Browser.';

  @override
  String get awClose => 'Schließen';

  @override
  String get pwPremiumTitle => 'Premium-Bericht';

  @override
  String get pwLockedSubtitle =>
      'Schalte die vollständige Analyse für dieses Chart frei';

  @override
  String pwUnlockFull(Object name) {
    return '$name vollständig freischalten';
  }

  @override
  String pwUnlockPrice(Object price) {
    return 'Freischalten · $price';
  }

  @override
  String get pwOneTime =>
      'Einmalige Freischaltung — für immer dein für dieses Chart';

  @override
  String get pwWhatYouGet => 'Das erhältst du';

  @override
  String get pwYourBalance => 'Dein Wallet-Guthaben';

  @override
  String get pwInsufficient => 'Unzureichendes Guthaben';

  @override
  String get pwRechargeToUnlock => 'Aufladen zum Freischalten';

  @override
  String get pwRechargeAmount => 'Aufladebetrag (₹)';

  @override
  String get pwAddMoney => 'Geld hinzufügen';

  @override
  String get pwRechargeDone => 'Wallet aufgeladen';

  @override
  String get pwRechargeFailed =>
      'Aufladung fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get pwUnlockFailed =>
      'Freischalten nicht möglich. Bitte versuche es erneut.';

  @override
  String get pwUnlockedNow => 'Freigeschaltet! Dein Bericht wird geladen…';

  @override
  String get pwProcessing => 'Wird verarbeitet…';

  @override
  String get pwPrimaryNoDelete =>
      'Dein Primäres Kundli kann nicht gelöscht werden — es ist für immer kostenlos.';

  @override
  String get pwPrimaryNoEdit =>
      'Dein Primäres Kundli kann nicht bearbeitet werden.';

  @override
  String get pwLoadingAccess => 'Zugriff wird geprüft…';

  @override
  String get pwMaybeLater => 'Vielleicht später';

  @override
  String get updatePhoto => 'Foto aktualisieren';

  @override
  String get takePhoto => 'Kamera';

  @override
  String get chooseFromGallery => 'Galerie';

  @override
  String get removePhoto => 'Foto entfernen';

  @override
  String get photoUpdated => 'Foto aktualisiert';

  @override
  String get photoUploadFailed =>
      'Foto konnte nicht hochgeladen werden. Bitte versuche es erneut.';

  @override
  String get tapToChangePhoto => 'Tippen, um Foto zu ändern';

  @override
  String get klSubtitle =>
      'KI-gestützter vedischer Bericht zur Karma-Verbindung aus früheren Leben';

  @override
  String get klTitle => 'Karma-Verbindung aus früherem Leben';

  @override
  String get klSnapshotHeader => 'Übersicht der karmischen Verbindung';

  @override
  String get klGaugePairwise => 'Durchschn. paarweise Verbindung';

  @override
  String get klGaugeCohesion => 'Gruppenkohäsion';

  @override
  String get klGaugeRahuKetu => 'Rahu-Ketu-Resonanz';

  @override
  String get klGaugeAtmakaraka => 'Seelen-Resonanz';

  @override
  String get klGaugeD60 => 'D60-Resonanz';

  @override
  String get klChipSoulResonance => 'Starke Resonanz der Seelensignatur';

  @override
  String get klChipD60Resonance => 'Starke D60-Resonanz früherer Leben';

  @override
  String get klChipCohesiveGroup => 'Zusammenhängende Gruppe';

  @override
  String get klChipNoDebts => 'Keine karmischen Schulden erkannt';

  @override
  String get klProfilesTitle => 'Chart-Profile';

  @override
  String get klKetuAt => 'Ketu bei';

  @override
  String get klRahuAt => 'Rahu bei';

  @override
  String get klFoundationTitle => 'Karmisches Fundament je Chart';

  @override
  String get klFoundationSubtitle =>
      'Die Meisterschaft aus früheren Leben und die aktuelle Lebensrichtung jeder Seele';

  @override
  String get klKetuMastery => 'Ketu-Meisterschaft';

  @override
  String get klRahuGrowth => 'Rahu-Wachstum';

  @override
  String get klNinthHousePunya => 'Punya des 9. Hauses';

  @override
  String get klD60Depth => 'D60 karmische Tiefe';

  @override
  String get klAtmakarakaAgenda => 'Seelenagenda';

  @override
  String get klSaturnKarma => 'Saturn-Karma';

  @override
  String get klPairwiseTitle => 'Paarweise karmische Verbindungen';

  @override
  String get klActiveFactors => 'Aktive Verbindungsfaktoren';

  @override
  String get klGroupPatternTitle => 'Karmisches Gruppenmuster';

  @override
  String get klSharedSetting => 'Gemeinsamer Schauplatz früherer Leben';

  @override
  String get klCohesionScore => 'Karmische Kohäsion';

  @override
  String get klPastGoalsTitle => 'Ziele aus früheren Leben';

  @override
  String get klLearningTitle => 'Lernen im aktuellen Leben';

  @override
  String get klTeachingMap => 'Karte gegenseitigen Lernens';

  @override
  String get klDebtsTitle => 'Karmische Schulden & Auflösungen';

  @override
  String get klNoDebtsDetected =>
      'Keine karmischen Schulden in dieser Gruppe erkannt';

  @override
  String get klTimingTitle => 'Moola-Dasha karmisches Timing';

  @override
  String get klAuditTitle => 'Detaillierte Auditing-Tabelle';

  @override
  String klAuditSubtitle(Object count) {
    return '$count karmische Parameter untersucht';
  }

  @override
  String get klTopicLinkage => 'Unsere allgemeine karmische Verbindung';

  @override
  String get klTopicPairwise => 'Die karmische Bindung eines bestimmten Paares';

  @override
  String get klTopicDebts => 'Zu lösende karmische Schulden';

  @override
  String get klTopicLessons => 'Was wir hier lernen sollen';

  @override
  String get klTopicTiming => 'Bestes Timing für unsere Gruppe';

  @override
  String get klTopicGroup => 'Unsere gemeinsame Geschichte aus früheren Leben';

  @override
  String get lcSubtitle =>
      'KI-gestützter vedischer Liebeskompatibilitätsbericht';

  @override
  String get lcTitle => 'Liebeskompatibilität';

  @override
  String get lcSnapshotHeader => 'Übersicht der Liebeskompatibilität';

  @override
  String get lcGaugeAttraction => 'Anziehung';

  @override
  String get lcGaugeEmotional => 'Emotionale Harmonie';

  @override
  String get lcGaugeMental => 'Geistige Verbundenheit';

  @override
  String get lcGaugePassion => 'Leidenschaft';

  @override
  String get lcGaugeLongterm => 'Langzeit-Harmonie';

  @override
  String get lcChipStrongMental => 'Starke geistige Verbindung';

  @override
  String get lcChipStrongLongterm => 'Starkes Langzeitpotenzial';

  @override
  String get lcChipStrongPassion => 'Starke körperliche Chemie';

  @override
  String get lcChipLowFriction => 'Insgesamt geringe Reibung';

  @override
  String get lcChipKarmicPull => 'Starke karmische Anziehung';

  @override
  String get lcPartnersTitle => 'Partner-Übersicht';

  @override
  String get lcVenusSuffix => 'Venus-Zeichen';

  @override
  String get lcAttractionTitle => 'Anziehung & Chemie';

  @override
  String get lcAttractionScore => 'Anziehungs-Score';

  @override
  String get lcActiveContacts => 'Aktive Venus-Kontakte';

  @override
  String get lcEmotionalTitle => 'Emotionale Harmonie';

  @override
  String get lcEmotionalScore => 'Score der emotionalen Harmonie';

  @override
  String get lcNakshatraCompat => 'Nakshatra-Kompatibilität';

  @override
  String get lcYoniKoota => 'Yoni Koota';

  @override
  String get lcGanaKoota => 'Gana Koota';

  @override
  String get lcTaraKoota => 'Tara Koota';

  @override
  String get lcBhakootAxis => 'Bhakoot-Achse';

  @override
  String get lcMentalTitle => 'Geistige Verbundenheit';

  @override
  String get lcMentalScore => 'Score der geistigen Verbundenheit';

  @override
  String get lcPassionTitle => 'Leidenschaft & Körperliches';

  @override
  String get lcPassionScore => 'Leidenschafts-Score';

  @override
  String get lcLongtermTitle => 'Langzeit-Harmonie';

  @override
  String get lcLongtermScore => 'Score der Langzeit-Harmonie';

  @override
  String get lcCommitmentPotential => 'Bindungspotenzial';

  @override
  String get lc7thHouseSynastry => 'Synastrie des 7. Hauses';

  @override
  String get lcJupiterBlessing => 'Jupiter-Segen';

  @override
  String get lcD9Resonance => 'D9-Navamsa-Resonanz';

  @override
  String get lcSaturnLongevity => 'Saturn-Beständigkeit';

  @override
  String get lcKarmicTitle => 'Karmische Liebesbindung';

  @override
  String get lcKarmicScore => 'Score der karmischen Bindung';

  @override
  String get lcKetuContacts => 'Ketu-Kontakte';

  @override
  String get lcRahuContacts => 'Rahu-Kontakte';

  @override
  String get lcChallengesTitle => 'Herausforderungen & Reibungspunkte';

  @override
  String get lcNoChallenges =>
      'In keinem der beiden Charts wurden nennenswerte Reibungspunkte festgestellt';

  @override
  String get lcTotalPenalty => 'Gesamter Herausforderungs-Abzug';

  @override
  String get lcTimingTitle => 'Liebes-Timing — Moola Dasha';

  @override
  String get lcDynamicsTitle => 'Beziehungsdynamik';

  @override
  String get lcPowerBalance => 'Machtbalance';

  @override
  String get lcGiverReceiver => 'Emotionaler Geber/Nehmer';

  @override
  String get lcGrowthDynamic => 'Wachstumsdynamik';

  @override
  String get lcAreasToNurture => 'Zu pflegende Bereiche';

  @override
  String get lcTopicTiming => 'Bestes Timing für unsere Beziehung';

  @override
  String get lcTopicChallenges => 'Zu bewältigende Herausforderungen';

  @override
  String get lcTopicKarmic => 'Unsere karmische Verbindung';

  @override
  String get lcTopicRemedies => 'Empfohlene Heilmittel';

  @override
  String get lcTopicLongterm => 'Unser Langzeitpotenzial';

  @override
  String get lcTopicDynamics => 'Unsere Beziehungsdynamik';

  @override
  String get cpSubtitle =>
      'KI-gestützter vedischer Bericht zur Kinderwahrscheinlichkeit';

  @override
  String get cpTitle => 'Kinderwahrscheinlichkeit';

  @override
  String get cpSnapshotHeader =>
      'Übersicht der Nachkommenschaftswahrscheinlichkeit';

  @override
  String get cpGauge5thHouse => '5. Haus';

  @override
  String get cpGaugeJupiter => 'Jupiter/Putrakaraka';

  @override
  String get cpGaugeD7 => 'D7 Saptamsa';

  @override
  String get cpGaugeSphuta => 'Beeja-Kshetra';

  @override
  String get cpGaugeTiming => 'Dasha-Timing';

  @override
  String get cpChipStrongPutrakaraka => 'Starker Putrakaraka (Jupiter)';

  @override
  String get cpChipLowDoshaPenalty => 'Geringer Dosha-Abzug';

  @override
  String get cpChipFavorableTiming => 'Günstiges Dasha-Timing';

  @override
  String get cpChipNoDoshas => 'Keine Nachkommenschafts-Doshas festgestellt';

  @override
  String get cpPartnersTitle => 'Partner-Übersicht';

  @override
  String get cpLagnaSuffix => 'Lagna';

  @override
  String get cpMoonSuffix => 'Mondzeichen';

  @override
  String get cpNumberTitle => 'Anzahl der Kinder & Geschlechtertendenz';

  @override
  String get cpProbableNumber => 'Wahrscheinliche Anzahl';

  @override
  String get cpFirstChildTendency => 'Tendenz des ersten Kindes';

  @override
  String get cpSpacing => 'Hinweis zum Abstand';

  @override
  String get cpTimingTitle => 'Timing — Moola Dasha';

  @override
  String get cpCombinedTiming => 'Kombiniertes Timing';

  @override
  String get cpNextWindow => 'Nächstes günstiges Zeitfenster';

  @override
  String get cp5thHouseTitle => 'Analyse des 5. Hauses';

  @override
  String get cp5thHouseSubtitle =>
      'Das Haus der Kinder (Putra Bhava), je Person';

  @override
  String get cpJupiterTitle => 'Jupiter — Putrakaraka-Analyse';

  @override
  String get cpJupiterSubtitle =>
      'Der natürliche Signifikator für Kinder, je Person';

  @override
  String get cpD7Title => 'D7-Saptamsa-Analyse';

  @override
  String get cpD7Subtitle => 'Das Divisionschart speziell für Kinder';

  @override
  String get cpD7Strength => 'D7-Stärke';

  @override
  String get cpSphutaTitle => 'Beeja- & Kshetra-Sphuta';

  @override
  String get cpBeejaSphuta => 'Beeja Sphuta (Samen)';

  @override
  String get cpKshetraSphuta => 'Kshetra Sphuta (Feld)';

  @override
  String get cpDoshaTitle => 'Dosha-Analyse';

  @override
  String get cpNoDoshasDetected =>
      'Keine nachkommenschaftsrelevanten Doshas in einem der beiden Charts festgestellt';

  @override
  String get cpRemediesTitle => 'Empfohlene Heilmittel';

  @override
  String get cpAddresses => 'Behandelt';

  @override
  String get cpTopicTiming => 'Bestes Timing für die Empfängnis';

  @override
  String get cpTopicNumber => 'Wie viele Kinder wir haben könnten';

  @override
  String get cpTopicDosha => 'Zu behandelnde Doshas';

  @override
  String get cpTopicRemedies => 'Empfohlene Heilmittel';

  @override
  String get cpTopicFifthHouse => 'Die Stärke unseres 5. Hauses';

  @override
  String get cpTopicJupiter => 'Jupiters Rolle dabei';

  @override
  String get riSubtitle =>
      'KI-gestützter vedischer Bericht zur Beziehungsanalyse';

  @override
  String get riTitle => 'Beziehungsanalyse';

  @override
  String get riSnapshotHeader => 'Gruppenübersicht';

  @override
  String get riGaugeCohesion => 'Gruppenkohäsion';

  @override
  String get riGaugeTrust => 'Vertrauensklima';

  @override
  String get riGaugeProductivity => 'Produktivität';

  @override
  String get riGaugeCreativity => 'Kreativität';

  @override
  String get riChipNoAlerts => 'Keine kritischen Warnungen';

  @override
  String get riChipStrongCohesion => 'Starke Gruppenkohäsion';

  @override
  String get riChipHighTrust => 'Hohes Vertrauensklima';

  @override
  String get riChipNoHiddenEnemy => 'Kein Hinweis auf einen verborgenen Feind';

  @override
  String get riChipHealthyGroup => 'Insgesamt gesunde Gruppe';

  @override
  String get riProfilesTitle => 'Chart-Profile';

  @override
  String riProfilesSubtitle(Object count) {
    return '$count Personen in dieser Gruppe';
  }

  @override
  String get riLagnaSuffix => 'Lagna';

  @override
  String get riIntegrity => 'Integrität';

  @override
  String get riWarmth => 'Wärme';

  @override
  String get riTrustworthiness => 'Vertrauenswürdigkeit';

  @override
  String get riAssertiveness => 'Durchsetzungsvermögen';

  @override
  String get riGroupDynamicsTitle => 'Übersicht der Gruppendynamik';

  @override
  String get riMostSupportive => 'Am unterstützendsten';

  @override
  String get riMostChallenged => 'Am herausforderndsten';

  @override
  String get riHiddenEnemyAlert => 'Hinweis auf verborgenen Feind erkannt';

  @override
  String get riBestWorstTitle => 'Beste & herausforderndste Paare';

  @override
  String get riBestPair => 'STÄRKSTE BINDUNG';

  @override
  String get riWorstPair => 'BENÖTIGT AUFMERKSAMKEIT';

  @override
  String get riAlliances => 'Wahrscheinliche Allianzen';

  @override
  String get riConflicts => 'Wahrscheinliche Reibungspunkte';

  @override
  String get riPairwiseTitle => 'Paarweise Analyse';

  @override
  String riPairwiseSubtitle(Object count) {
    return '$count Paare analysiert';
  }

  @override
  String get riDynamic => 'Dynamik';

  @override
  String get riKarmicLink => 'Karmische Verbindung';

  @override
  String get riMutualTrust => 'Gegenseitiges Vertrauen';

  @override
  String get riBetrayalRisk => 'Verratsrisiko';

  @override
  String get riPowerDistribution => 'Machtverteilung';

  @override
  String get riPowerHealth => 'Gesundheit der Machtbalance';

  @override
  String get riCriticalPatternsTitle => 'Kritische Muster';

  @override
  String get riGroupRecsTitle => 'Gruppenempfehlungen';

  @override
  String get riSharedPractices => 'Gemeinsame Praktiken';

  @override
  String get riCommStyle => 'Empfohlener Kommunikationsstil';

  @override
  String get riGrowthFocus => 'Empfohlener Wachstumsfokus';

  @override
  String get riIndividualTitle => 'Individuelle Anleitung';

  @override
  String get riBestAllies => 'Beste Verbündete';

  @override
  String get riHandleWithCare => 'Mit Vorsicht behandeln';

  @override
  String get riCoreThemeTitle => 'Zentrales Gruppenthema';

  @override
  String get riLayerPairwise => 'Vollständigkeit der Paaranalyse';

  @override
  String get riLayerD1 => 'Geburtschart (D1)';

  @override
  String get riLayerD9 => 'Navamsa (D9)';

  @override
  String get riLayerD10 => 'Dashamsa (D10)';

  @override
  String get riLayerD30 => 'Trimshamsa (D30)';

  @override
  String get riLayerJaimini => 'Jaimini-Signal';

  @override
  String get riLayerBehavior => 'Verhaltensklarheit';

  @override
  String get riLayerCoherence => 'Gruppenkohärenz';

  @override
  String get riTopicDynamics => 'Unsere Gruppendynamik';

  @override
  String get riTopicPairwise => 'Die Kompatibilität eines bestimmten Paares';

  @override
  String get riTopicAlerts => 'Etwaige kritische Warnungen';

  @override
  String get riTopicGrowth => 'Wie wir gemeinsam wachsen können';

  @override
  String get riTopicRecs => 'Empfohlene Praktiken';

  @override
  String get riTopicTheme => 'Unser zentrales Gruppenthema';

  @override
  String get kmSubtitle => 'KI-gestützter vedischer Kundli-Milan-Bericht';

  @override
  String get kmTitle => 'Kundli Milan';

  @override
  String get kmSnapshotHeader => 'Übersicht der Kompatibilität';

  @override
  String kmAshtakootScore(Object score) {
    return 'Ashtakoot: $score/36';
  }

  @override
  String get kmGaugeAshtakoot => 'Ashtakoot %';

  @override
  String get kmGaugeD9 => 'D9 Ehe-Karma';

  @override
  String get kmGaugeMangal => 'Mangal-Balance';

  @override
  String get kmGaugePapa => 'Karmische Balance';

  @override
  String get kmGaugeAk => 'Seelen-Resonanz';

  @override
  String get kmChipNoNadi => 'Kein Nadi Dosh';

  @override
  String get kmChipNoBhakoot => 'Kein Bhakoot Dosh';

  @override
  String get kmChipMangalCancelled => 'Mangal Dosh aufgehoben';

  @override
  String get kmChipPapaBalanced => 'Ausgewogene karmische Last';

  @override
  String get kmChipStrongChemistry => 'Starke körperliche Chemie';

  @override
  String get kmChipStrongD9 => 'Starkes D9-Ehe-Karma';

  @override
  String get kmChipLongevity => 'Starke Übereinstimmung der Langlebigkeit';

  @override
  String get kmAshtakootTitle => 'Ashtakoot Guna Milan';

  @override
  String get kmAshtakootSubtitle => 'Das klassische 8-Punkte-System, von 36';

  @override
  String get kmNadiSeverity => 'Nadi-Schweregrad';

  @override
  String get kmBhakootSeverity => 'Bhakoot-Schweregrad';

  @override
  String get kmGanaSignature => 'Gana-Signatur';

  @override
  String get kmMangalTitle => 'Mangal-Dosha-Prüfung';

  @override
  String get kmD9Title => 'D9 Navamsa — Ehe-Karma';

  @override
  String get kmD9Subtitle =>
      'Das Ehe-Chart auf Seelenebene, klassisch als am wichtigsten betrachtet';

  @override
  String get kmD9Score => 'D9-Kompatibilität';

  @override
  String get kmLagnaRelation => 'Lagna-Beziehung';

  @override
  String get km7thLordRelation => 'Beziehung des 7. Herrn';

  @override
  String get kmKarakasTitle => 'Karakas für Seele & Ehepartner';

  @override
  String get kmAtmakaraka => 'Seelenplanet';

  @override
  String get kmAkCompatibility => 'Resonanz der Seelensignatur';

  @override
  String get kmUlCompatibility => 'Ausrichtung des Ehepartner-Karaka';

  @override
  String get kmUlSigns => 'Upapada-Herren';

  @override
  String get kmChemistryTitle => 'Venus-Mars-Chemie';

  @override
  String get kmPhysicalChemistry => 'Körperliche Chemie';

  @override
  String get kmEmotionalWarmth => 'Emotionale Wärme';

  @override
  String get kmAestheticAlignment => 'Ästhetische Ausrichtung';

  @override
  String get kmElementalSynthesis => 'Elementare Synthese';

  @override
  String get kmHouseCrossTitle => 'Kreuzanalyse des 7. & 8. Hauses';

  @override
  String get km78Compatibility => 'Kompatibilität des 7.-8. Hauses';

  @override
  String get km8thHouseSignature => 'Gemeinsame Langlebigkeits-Signatur';

  @override
  String get kmLongevityAlignment => 'Ausrichtung der Langlebigkeit';

  @override
  String get km7thLordFriendship => 'Freundschaft des 7. Herrn';

  @override
  String get kmDomainsTitle => 'Kompatibilität nach Bereichen';

  @override
  String get kmConflictEngagement => 'Konfliktstil';

  @override
  String get kmDashaTitle => 'Dasha- & Transit-Synchronisation';

  @override
  String get kmDashaSync => 'Dasha-Synchronisation';

  @override
  String get kmTransitAlignment => 'Transit-Ausrichtung';

  @override
  String get kmTimingTitle => 'Heiratszeitpunkt';

  @override
  String get kmMarriageWindow => 'Heiratsfenster';

  @override
  String get kmEngagementWindow => 'Verlobungsfenster';

  @override
  String get kmRecommendedRange => 'Empfohlener Zeitrahmen';

  @override
  String get kmMuhurtaNotes => 'Muhurta-Hinweise';

  @override
  String get kmRisksTitle => 'Zu behandelnde Risiken';

  @override
  String get kmConflictRisk => 'Konfliktrisiko';

  @override
  String get kmCommunicationRisk => 'Kommunikationsrisiko';

  @override
  String get kmFinanceRisk => 'Risiko finanzieller Konflikte';

  @override
  String get kmFamilyDynamicsRisk => 'Risiko der Familiendynamik';

  @override
  String get kmMentalHealthRisk => 'Risiko der mentalen Gesundheitsausrichtung';

  @override
  String get kmStrengthsTitle => 'Top-Kompatibilitätsstärken';

  @override
  String get kmSharedGrowth => 'Gemeinsames Wachstumspotenzial';

  @override
  String get kmSharedCreative => 'Gemeinsames kreatives Potenzial';

  @override
  String get kmJourneyTitle => 'Beziehungsreise & Wachstum';

  @override
  String get kmCurrentPhase => 'Aktuelle Phase';

  @override
  String get kmEarlyArc => 'Frühe Ehe';

  @override
  String get kmMiddleArc => 'Mittlere Ehe';

  @override
  String get kmMatureArc => 'Reife Ehe';

  @override
  String get kmElderArc => 'Spätere Jahre';

  @override
  String get kmPeakPhase => 'Höhepunkt der Partnerschaft';

  @override
  String get kmGrowthAreas => 'Wachstumsbereiche';

  @override
  String get kmCommProtocols => 'Kommunikationsprotokolle';

  @override
  String get kmSharedPractices => 'Gemeinsame Praktiken';

  @override
  String get kmImprovementTitle => 'Kernthema & Verbesserungsplan';

  @override
  String get kmVerdictTitle => 'Abschließendes Urteil';

  @override
  String get kmRealizationPotential => 'Verwirklichungspotenzial der Beziehung';

  @override
  String get kmLayerAshtakoot => 'Ashtakoot';

  @override
  String get kmLayerD9 => 'D9 Navamsa';

  @override
  String get kmLayerMangalPapa => 'Mangal & Papasamya';

  @override
  String get kmLayerVenusMars => 'Venus-Mars';

  @override
  String get kmLayerDashaSync => 'Dasha-Synchronisation';

  @override
  String get kmLayerH7H8 => 'Kreuzanalyse 7.-8. Haus';

  @override
  String get kmLayerAkResonance => 'Atmakaraka-Resonanz';

  @override
  String get kmLayerDomains => 'Bereichs-Dimensionen';

  @override
  String get kmTopicAshtakoot => 'Unser Ashtakoot-Score';

  @override
  String get kmTopicMangal => 'Bedenken zu Mangal Dosha';

  @override
  String get kmTopicD9 => 'Unser Ehe-Karma (D9)';

  @override
  String get kmTopicTiming => 'Bestes Heiratstiming';

  @override
  String get kmTopicRisks => 'Risiken, auf die man sich vorbereiten sollte';

  @override
  String get kmTopicGrowth => 'Wie wir gemeinsam wachsen können';

  @override
  String get kmTopicRemedies => 'Empfohlene Heilmittel';

  @override
  String get kmTopicVerdict => 'Sollten wir mit der Heirat fortfahren';

  @override
  String get pkSubtitle =>
      'KI-gestützter vedischer Bericht zu früherem Leben & Karma';

  @override
  String get pkTitle => 'Früheres Leben & Karma';

  @override
  String get pkSnapshotHeader => 'Übersicht früherer Leben';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return 'Dein Chart zeigt eine Signatur früherer Leben vom Typ „$theme“, die sich derzeit $relation in dieses Leben einbringt. Empfohlener Weg: $strategy.';
  }

  @override
  String get pkGaugeSignature => 'Signaturstärke';

  @override
  String get pkGaugeMasteryPreserved => 'Erhaltene Meisterschaft';

  @override
  String get pkGaugeClearingProgress => 'Karma-Auflösung';

  @override
  String get pkGaugeMaturity => 'Reife des früheren Lebens';

  @override
  String get pkGaugeMemoryAccess => 'Erinnerungszugang';

  @override
  String get pkChipGoodProgress => 'Guter Fortschritt bei der Karma-Auflösung';

  @override
  String get pkChipLowDebt => 'Geringe karmische Schuld';

  @override
  String get pkChipMatureSoul => 'Reife Seelensignatur';

  @override
  String get pkChipGiftedPast => 'Chart trägt ein Geschenk aus früherem Leben';

  @override
  String get pkChipAccomplished => 'Erfolgreiches früheres Leben';

  @override
  String get pkChipMasteryPreserved => 'Starke Meisterschaft weitergetragen';

  @override
  String get pkKetuTitle => 'Ketu — Deine frühere Meisterschaft';

  @override
  String get pkKetuSubtitle =>
      'Fähigkeiten, die deine Seele bereits gemeistert hat';

  @override
  String get pkMasteryStrength => 'Meisterschaftsstärke';

  @override
  String get pkSkillsCarried => 'Weitergetragene Fähigkeiten';

  @override
  String get pkInstincts => 'Instinktive Fähigkeiten';

  @override
  String get pkKetuDignity => 'Ketu-Würde';

  @override
  String get pkRahuTitle => 'Rahu — Die Wachstumskante deiner Seele';

  @override
  String get pkRahuSubtitle => 'Was deine Seele hier vollenden soll';

  @override
  String get pkUnmetDesires => 'Unerfüllte Wünsche';

  @override
  String get pkProfileTitle => 'Dein Profil aus früherem Leben';

  @override
  String get pkProfession => 'Wahrscheinlicher Beruf';

  @override
  String get pkSocialStanding => 'Sozialer Stand';

  @override
  String get pkRegion => 'Wahrscheinliche Region';

  @override
  String get pkCulturalArchetype => 'Kulturelles Archetyp';

  @override
  String get pkAccomplishment => 'Grad der Errungenschaft';

  @override
  String get pkAuthority => 'Autoritätsgrad';

  @override
  String get pkFamilyRole => 'Familienrolle';

  @override
  String get pkSecondaryProfession => 'Zweitberuf';

  @override
  String get pkClimateAffinity => 'Klimaaffinität';

  @override
  String get pkForeignResidence => 'Karma des Auslandsaufenthalts';

  @override
  String get pkRelationshipsTitle => 'Weitergetragene frühere Beziehungen';

  @override
  String get pkSpouseConnection => 'Wiederverbindung mit dem Ehepartner';

  @override
  String get pkChildrenConnection => 'Wiederverbindung mit Kindern';

  @override
  String get pkCarriedRelationTypes => 'Beziehungsmuster';

  @override
  String get pkPartnerArchetype => 'Partner-Archetyp aus früherem Leben';

  @override
  String get pkDarakaraka => 'Ehepartner-Karaka';

  @override
  String get pkParentsKarma => 'Karma-Muster der Eltern';

  @override
  String get pkSiblingKarma => 'Karma-Muster der Geschwister';

  @override
  String get pkSpiritualTitle => 'Dein spirituelles Leben damals';

  @override
  String get pkSpiritualLevel => 'Spirituelles Niveau';

  @override
  String get pkPracticeSignature => 'Praxisstil';

  @override
  String get pkMeditativeCapacity => 'Meditative Fähigkeit';

  @override
  String get pkDevotionalPractice => 'Hingebungsvolle Praxis';

  @override
  String get pkYogicAttainment => 'Yogische Errungenschaft';

  @override
  String get pkMokshaProximity => 'Nähe zur Moksha';

  @override
  String get pkKarmicDebtsTitle => 'Karmische Schulden & Wohlstand damals';

  @override
  String get pkTotalKarmicDebt => 'Gesamte karmische Schuld';

  @override
  String get pkPrimaryDebtType => 'Primäre Schuldart';

  @override
  String get pkRelationshipDebt => 'Beziehungsschuld';

  @override
  String get pkFinancialDebt => 'Finanzielle Schuld';

  @override
  String get pkServiceDebt => 'Dienstschuld';

  @override
  String get pkDharmicDebt => 'Dharmische Schuld';

  @override
  String get pkPitruKarma => 'Pitru-Karma';

  @override
  String get pkMatruKarma => 'Matru-Karma';

  @override
  String get pkWealthLevel => 'Wohlstandsniveau damals';

  @override
  String get pkWealthKarmaCarried => 'Weitergetragenes Wohlstands-Karma';

  @override
  String get pkResourcePattern => 'Ressourcenmanagement';

  @override
  String get pkGainSource => 'Gewinnquelle';

  @override
  String get pkEchoesTitle => 'Nachklänge in diesem Leben';

  @override
  String get pkOnRelationships => 'Auf Beziehungen';

  @override
  String get pkOnCareer => 'Auf die Karriere';

  @override
  String get pkOnHealth => 'Auf die Gesundheit';

  @override
  String get pkOnSpirituality => 'Auf die Spiritualität';

  @override
  String get pkDominantArea => 'Stärkste Weitergabe';

  @override
  String get pkAttractions => 'Natürliche Anziehungen';

  @override
  String get pkAversions => 'Natürliche Abneigungen';

  @override
  String get pkUnexplainedFears => 'Unerklärliche Ängste';

  @override
  String get pkMagneticPulls => 'Magnetische Anziehungen';

  @override
  String get pkResolutionTitle => 'Karmische Auflösung & Vollendung';

  @override
  String get pkPrimaryPathway => 'Primärer Weg';

  @override
  String get pkSecondaryPathway => 'Sekundärer Weg';

  @override
  String get pkClearingProgress => 'Fortschritt der Auflösung';

  @override
  String get pkRemainingWork => 'Verbleibende Arbeit';

  @override
  String get pkSettlementTimeline => 'Zeitrahmen der Begleichung';

  @override
  String get pkAccelerationPractices =>
      'Praktiken, die die Auflösung beschleunigen';

  @override
  String get pkPriorityAreas => 'Prioritätsbereiche';

  @override
  String get pkVerificationTitle => 'Über die Charts bestätigt (D60)';

  @override
  String get pkD60Label => 'D60-Ära des früheren Lebens';

  @override
  String get pkD60Ketu => 'D60-Ketu-Platzierung';

  @override
  String get pkD60Standing => 'Gesamtstatus';

  @override
  String get pkMemoryTitle => 'Erinnerung & Intuition';

  @override
  String get pkMemoryAccess => 'Erinnerungszugang';

  @override
  String get pkRegressionFit => 'Eignung für Rückführungstherapie';

  @override
  String get pkDreamVisits => 'Traumbesuche';

  @override
  String get pkDejaVuFrequency => 'Déjà-vu-Häufigkeit';

  @override
  String get pkSpontaneousRemembrance => 'Spontane Erinnerung';

  @override
  String get pkRemembrancePractices => 'Erinnerungspraktiken';

  @override
  String get pkTimelineTitle => 'Aktivierungs-Zeitplan';

  @override
  String get pkGiftsActivation =>
      'Aktivierung der Geschenke aus früherem Leben';

  @override
  String get pkSurfaceWindow => 'Auftauchfenster';

  @override
  String get pkRisksTitle => 'Risiken & chronische Muster';

  @override
  String get pkTraumaResidue => 'Trauma-Rückstände';

  @override
  String get pkSpiritualBypass => 'Risiko spirituellen Umgehens';

  @override
  String get pkMajorRisks => 'Hauptrisiken';

  @override
  String get pkChronicImprints => 'Chronische Prägungen';

  @override
  String get pkKarmicLoops => 'Karmische Schleifen';

  @override
  String get pkImprovementTitle => 'Verbesserungsplan';

  @override
  String get pkRoadmapTitle => 'Dein Fahrplan aus früherem Leben';

  @override
  String get pkMaturity => 'Reife des früheren Lebens';

  @override
  String get pkLayerD1 => 'Geburtschart (D1)';

  @override
  String get pkLayerD9 => 'Navamsa (D9)';

  @override
  String get pkLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get pkLayerKetuDepth => 'Ketu-Tiefe';

  @override
  String get pkLayerAtmakaraka => 'Seelenplanet (Atmakaraka)';

  @override
  String get pkTopicMastery => 'Meine Meisterschaft aus früherem Leben';

  @override
  String get pkTopicUnfinished => 'Mein unvollendetes Karma';

  @override
  String get pkTopicRelationships => 'Meine Beziehungen aus früherem Leben';

  @override
  String get pkTopicDebts => 'Meine karmischen Schulden';

  @override
  String get pkTopicResolution => 'Wie ich mein Karma auflösen kann';

  @override
  String get pkTopicMemory => 'Zugang zur Erinnerung an frühere Leben';

  @override
  String get pkTopicTiming => 'Beste Zeitfenster';

  @override
  String get pkTopicProfile => 'Wer ich in meinem früheren Leben war';

  @override
  String get chSubtitle => 'KI-gestützter vedischer Charakteranalyse-Bericht';

  @override
  String get chTitle => 'Charakteranalyse';

  @override
  String get chSnapshotHeader => 'Charakterübersicht';

  @override
  String get chGaugeIntegrity => 'Integrität';

  @override
  String get chGaugeResilience => 'Resilienz';

  @override
  String get chGaugeSelfAwareness => 'Selbstwahrnehmung';

  @override
  String get chGaugeStability => 'Emotionale Stabilität';

  @override
  String get chGaugeMoralFabric => 'Moralisches Gefüge';

  @override
  String get chChipRajaYoga => 'Raja Yoga vorhanden';

  @override
  String get chChipHighIntegrity => 'Hohe Integrität';

  @override
  String get chChipResilient => 'Widerstandsfähige Natur';

  @override
  String get chChipDharmic => 'Starke Dharma-Ausrichtung';

  @override
  String get chChipEmpathetic => 'Von Natur aus einfühlsam';

  @override
  String get chChipLoyal => 'Tief loyal';

  @override
  String get chChipGiftedCharacter => 'Chart trägt eine Charaktergabe';

  @override
  String get chSoulTitle => 'Deine Seelensignatur';

  @override
  String get chSoulIntegration => 'Integration von Seele & Charakter';

  @override
  String get chAmatyakarakaTheme => 'Unterstützende Charakterstimme';

  @override
  String get chAtmakarakaDignity => 'Würde des Seelenplaneten';

  @override
  String get chAtmakarakaHouse => 'Hausplatzierung';

  @override
  String get chSurfaceTitle => 'Oberflächenpersönlichkeit & Konstitution';

  @override
  String get chLagnaSign => 'Aszendentenzeichen';

  @override
  String get chConstitution => 'Konstitution';

  @override
  String get chSurfaceSignature => 'Wie du wirkst';

  @override
  String get chPhysicalConstitution => 'Körperliche Konstitution';

  @override
  String get chLagnaLord => 'Aszendentenherr';

  @override
  String get chLagnaOccupants => 'Planeten im Aszendenten';

  @override
  String get chMindEmotionsTitle => 'Geist, Emotionen & Ego';

  @override
  String get chEmotionalNature => 'Deine emotionale Natur';

  @override
  String get chMentalStability => 'Mentale Stabilität';

  @override
  String get chSelfConfidence => 'Gesundes Selbstvertrauen';

  @override
  String get chEgoNature => 'Dein Ego & Selbstbild';

  @override
  String get chAuthorityRelationship => 'Verhältnis zur Autorität';

  @override
  String get chPrideTendency => 'Stolz-Tendenz';

  @override
  String get chMoodPatterns => 'Stimmungsmuster';

  @override
  String get chKemadrumaPresent =>
      'Kemadruma Yoga vorhanden — zusätzliche emotionale Selbstfürsorge ist von Vorteil.';

  @override
  String get chFatherImprint => 'Qualität der Vaterprägung';

  @override
  String get chCommunicationTitle => 'Kommunikations- & Intellektstil';

  @override
  String get chIntellectStyle => 'Intellektstil';

  @override
  String get chCommStyle => 'Kommunikationsstil';

  @override
  String get chDecisionStyle => 'Entscheidungsstil';

  @override
  String get chDiscrimination => 'Unterscheidungsvermögen';

  @override
  String get chPersonaTitle => 'Öffentliche Persona vs. wahres Selbst';

  @override
  String get chAuthenticityGap => 'Authentizitätslücke';

  @override
  String get chGunaTitle => 'Guna- & Dosha-Profil';

  @override
  String get chGunaSubtitle =>
      'Deine innere Natur und Konstitution im klassischen vedischen Stil';

  @override
  String get chSattva => 'Sattva';

  @override
  String get chRajas => 'Rajas';

  @override
  String get chTamas => 'Tamas';

  @override
  String get chDominantGuna => 'Dominantes Guna';

  @override
  String get chPitta => 'Pitta';

  @override
  String get chKapha => 'Kapha';

  @override
  String get chVata => 'Vata';

  @override
  String get chDominantDosha => 'Dominantes Dosha';

  @override
  String get chRahuRestlessness => 'Rahu-Rastlosigkeit';

  @override
  String get chKetuDetachment => 'Ketu-Loslösung';

  @override
  String get chYogasTitle => 'Charakter-Yogas';

  @override
  String get chRajaYogaStrength => 'Raja-Yoga-Stärke';

  @override
  String get chGiftYogas => 'Geschenk-Yogas';

  @override
  String get chTestYogas => 'Prüfungs-Yogas';

  @override
  String get chStrengthsTitle => 'Stärken & Talente';

  @override
  String get chSignatureVirtues => 'Charakteristische Tugenden';

  @override
  String get chNaturalTalents => 'Natürliche Talente';

  @override
  String get chSoftSkills => 'Soft Skills';

  @override
  String get chHiddenStrengths => 'Zu entwickelnde verborgene Stärken';

  @override
  String get chShadowTitle => 'Schatten- & Wachstumsbereiche';

  @override
  String get chShadowSubtitle =>
      'Sanftes Bewusstsein für Muster, an denen es sich zu arbeiten lohnt';

  @override
  String get chShadowPatterns => 'Schattenmuster';

  @override
  String get chBlindSpots => 'Blinde Flecken';

  @override
  String get chEmotionalWounds => 'Emotionale Wunden';

  @override
  String get chShadowWorkPriorities => 'Prioritäten der Schattenarbeit';

  @override
  String get chMoralTests => 'Moralische Prüfungen';

  @override
  String get chRelationshipsTitle => 'Beziehungen & sozialer Stil';

  @override
  String get chWarmth => 'Zwischenmenschliche Wärme';

  @override
  String get chEmpathy => 'Empathiefähigkeit';

  @override
  String get chLoyalty => 'Loyalitätsfähigkeit';

  @override
  String get chBoundaries => 'Grenzen setzen';

  @override
  String get chSocialConfidence => 'Soziales Selbstvertrauen';

  @override
  String get chTrustGiving => 'Grundlegende Vertrauensbereitschaft';

  @override
  String get chConflictStyle => 'Konfliktstil';

  @override
  String get chEthicsTitle => 'Ethik & moralischer Kompass';

  @override
  String get chDharmaOrientation => 'Dharma-Ausrichtung';

  @override
  String get chTruthfulness => 'Wahrhaftigkeit';

  @override
  String get chCompassion => 'Mitgefühl';

  @override
  String get chGenerosity => 'Großzügigkeit';

  @override
  String get chEthicalConsistency => 'Ethische Konsistenz';

  @override
  String get chIntegrityPressure => 'Integrität unter Druck';

  @override
  String get chJusticeFairness => 'Gerechtigkeit & Fairness';

  @override
  String get chMoralTrajectory => 'Moralische Entwicklung';

  @override
  String get chEiTitle => 'Emotionale Intelligenz';

  @override
  String get chEiSelfAwareness => 'Selbstwahrnehmung';

  @override
  String get chEiSelfRegulation => 'Selbstregulation';

  @override
  String get chEiEmpathy => 'Empathie';

  @override
  String get chEiSocialSkills => 'Soziale Fähigkeiten';

  @override
  String get chMotivation => 'Innere Motivation';

  @override
  String get chVulnerabilityComfort => 'Wohlbefinden mit Verletzlichkeit';

  @override
  String get chEmotionalExpression => 'Komfort beim emotionalen Ausdruck';

  @override
  String get chEmotionalReceptivity => 'Emotionale Empfänglichkeit';

  @override
  String get chVerificationTitle =>
      'Über die Charts bestätigt (D9/D12/D30/D60)';

  @override
  String get chD9Label => 'D9 Dharma-Charakter';

  @override
  String get chD12Label => 'D12 Ahnenerbe';

  @override
  String get chD30Label => 'D30 Schattenprofil';

  @override
  String get chD60Label => 'D60 Charakter aus früherem Leben';

  @override
  String get chD30Standing => 'Schattenstatus';

  @override
  String get chMaternalInheritance => 'Mütterliches Erbe';

  @override
  String get chAncestralKarmaWeight => 'Gewicht des Ahnenkarmas';

  @override
  String get chTimelineTitle => 'Charakter-Zeitlinie';

  @override
  String get chFormationWindow => 'Formationsfenster';

  @override
  String get chMaturationWindow => 'Reifungsfenster';

  @override
  String get chLegacyWindow => 'Vermächtnisfenster';

  @override
  String get chPeakMaturationAge => 'Alter der Reifespitze';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return 'Alter $ageRange';
  }

  @override
  String get chImprovementTitle => 'Verbesserungsplan';

  @override
  String get chRoadmapTitle => 'Dein Charakter-Fahrplan';

  @override
  String get chAuthenticExpression => 'Authentischer Selbstausdruck';

  @override
  String get chRealizationPotential =>
      'Verwirklichungspotenzial des Charakters';

  @override
  String get chLayerAtmakaraka => 'Seelenplanet (Atmakaraka)';

  @override
  String get chLayerD1 => 'Geburtschart (D1)';

  @override
  String get chLayerD9 => 'Navamsa (D9)';

  @override
  String get chLayerD30 => 'Trimshamsa (D30)';

  @override
  String get chLayerLagnaMoon => 'Aszendent & Mond';

  @override
  String get chLayerArudha => 'Arudha Lagna';

  @override
  String get chTopicStrengths => 'Meine Charakterstärken';

  @override
  String get chTopicShadow => 'Meine Schattenmuster';

  @override
  String get chTopicSoul => 'Meine Seelensignatur';

  @override
  String get chTopicRelationships => 'Mein Beziehungsstil';

  @override
  String get chTopicEthics => 'Meine Ethik & Werte';

  @override
  String get chTopicGuna => 'Mein Guna- & Dosha-Profil';

  @override
  String get chTopicGrowth => 'Wie ich meinen Charakter weiterentwickeln kann';

  @override
  String get chTopicTiming => 'Bestes Timing für Charakterarbeit';

  @override
  String get lpSubtitle =>
      'KI-gestützter vedischer Bericht zu Lebensweg & Glück';

  @override
  String get lpTitle => 'Lebensweg & Glück';

  @override
  String get lpSnapshotHeader => 'Übersicht des Lebenswegs';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return 'Du bist ein $archetype mit einem primären Zweck im Bereich $domain. Unsere Analyse zeigt ein Gesamt-Erfüllungspotenzial von $probability%.';
  }

  @override
  String get lpGaugeDharma => 'Dharma-Klarheit';

  @override
  String get lpGaugeFortune => 'Glücks-Basiswert';

  @override
  String get lpGaugeCoherence => 'Kohärenz des Lebenswegs';

  @override
  String get lpGaugeFulfillment => 'Erfüllung';

  @override
  String get lpGaugeMomentum => 'Karmisches Momentum';

  @override
  String get lpChipRareGift => 'Seltenes Schicksalsgeschenk';

  @override
  String get lpChipFreeWillStrong => 'Starker freier Wille';

  @override
  String get lpChipGraceSupported => 'Von Gnade unterstützt';

  @override
  String get lpChipLightKarma => 'Geringe karmische Last';

  @override
  String get lpChipRecognitionPotential => 'Anerkennungspotenzial';

  @override
  String get lpChipSpiritualPath => 'Starker spiritueller Zug';

  @override
  String get lpChipBlessed => 'Chart trägt Segnungen';

  @override
  String get lpSoulPathTitle => 'Dein Seelenweg';

  @override
  String get lpSoulPlanet => 'Seelenplanet';

  @override
  String get lpCareerPlanet => 'Zweckplanet';

  @override
  String get lpSoulClarity => 'Klarheit des Lebenszwecks';

  @override
  String get lpLifeChapter => 'Aktuelles Lebenskapitel';

  @override
  String get lpPrimaryDomain => 'Primärer Zweckbereich';

  @override
  String get lpKarakaTitle => 'Deine Dharma-Planeten';

  @override
  String get lpKarakaSubtitle =>
      'Wie stark jeder Planet deinen Lebenszweck unterstützt';

  @override
  String get lpVerificationTitle => 'Über die Charts bestätigt (D9 / D60)';

  @override
  String get lpD9Label => 'D9 Seelenausrichtung';

  @override
  String lpD9Explain(Object stage) {
    return 'Deine Stufe der Seelenentwicklung ist im Navamsa-Chart „$stage“.';
  }

  @override
  String get lpD9JupiterDignity => 'Jupiter-Würde';

  @override
  String get lpD9DharmaMultiplier => 'Dharma-Multiplikator';

  @override
  String get lpD60Label => 'D60-Signatur des früheren Lebens';

  @override
  String get lpKarmaType => 'Karma-Typ aus früherem Leben';

  @override
  String get lpKetuMastery => 'Ketu-Meisterschaft aus früherem Leben';

  @override
  String get lpRahuGrowthDir => 'Rahu-Wachstumsrichtung';

  @override
  String get lpYogasTitle => 'Glücks-Yogas & Glücksblockaden';

  @override
  String get lpFortuneBoost => 'Glücksverstärkung';

  @override
  String get lpLuckDrain => 'Glücksverlust';

  @override
  String get lpFortuneBoosters => 'Glücksverstärker';

  @override
  String get lpLuckBlocks => 'Glücksblockaden';

  @override
  String get lpPurposeTitle => 'Zweckbereiche & Ruhm';

  @override
  String get lpDomainLeadership => 'Führung';

  @override
  String get lpDomainWisdom => 'Weisheit & Lehre';

  @override
  String get lpDomainService => 'Dienst';

  @override
  String get lpDomainHealing => 'Heilung';

  @override
  String get lpDomainCreative => 'Kreativer Ausdruck';

  @override
  String get lpPrimaryDomainBadge => 'Primär';

  @override
  String get lpFameRecognition => 'Ruhm & Anerkennung';

  @override
  String get lpSocialInfluence => 'Sozialer Einfluss';

  @override
  String get lpRecognitionDomain => 'Anerkennungsbereich';

  @override
  String get lpPublicImage => 'Öffentliches Image';

  @override
  String get lpHistoricalImpact => 'Potenzial für historischen Einfluss';

  @override
  String get lpTimelineTitle => 'Glücks- & Lebenszeitlinie';

  @override
  String get lpCurrentPhase => 'Aktuelle Glücksphase';

  @override
  String get lpJupiterReturn => 'Jupiter-Rückkehr';

  @override
  String get lpSaturnReturn => 'Saturn-Rückkehr';

  @override
  String get lpSadeSati => 'Sade Sati';

  @override
  String get lpGoldenWindow => 'Goldenes Fenster';

  @override
  String get lpTransformationWindow => 'Transformationsfenster';

  @override
  String get lpPeakYears => 'Jahre des Glückshöhepunkts';

  @override
  String get lpChallengingYears => 'Herausfordernde Jahre';

  @override
  String get lpMilestonesTitle => 'Wichtige Meilensteine & Wendepunkte';

  @override
  String get lpFirstTurningPoint => 'Erster großer Wendepunkt';

  @override
  String get lpMidlifeTransform => 'Transformation in der Lebensmitte';

  @override
  String get lpLateLifeFulfillment => 'Erfüllung im späten Leben';

  @override
  String lpDharmicMilestone(Object age) {
    return 'Dharmischer Meilenstein (Alter $age)';
  }

  @override
  String lpAgeLabel(Object age) {
    return 'Alter $age';
  }

  @override
  String get lpDestinyTitle => 'Schicksal vs. freier Wille';

  @override
  String get lpDestinyStat => 'Schicksalsgewicht';

  @override
  String get lpFreeWillStat => 'Hebelwirkung des freien Willens';

  @override
  String get lpFateStrength => 'Stärke der Schicksalssignatur';

  @override
  String get lpSelfCreation => 'Fähigkeit zur Selbsterschaffung';

  @override
  String get lpEffortGrace => 'Anstrengung vs. Gnade';

  @override
  String get lpKarmicTitle => 'Karmische Lektionen';

  @override
  String get lpRahuGrowthLabel => 'Rahu — Wachstumsherausforderung';

  @override
  String get lpKetuSurrenderLabel => 'Ketu — Thema der Hingabe';

  @override
  String get lpSaturnLessonLabel => 'Saturn — Disziplinlektion';

  @override
  String get lpTestDifficulty => 'Schwierigkeit der Lebensprüfung';

  @override
  String get lpLessonsInProgress => 'Laufende Lektionen';

  @override
  String get lpSoulContract => 'Bereiche des Seelenvertrags';

  @override
  String get lpSoulExperience => 'Was deine Seele erfahren wollte';

  @override
  String get lpSoulMastery => 'Was deine Seele meistern wollte';

  @override
  String get lpSpiritualTitle => 'Spiritueller Weg';

  @override
  String get lpSpiritualInclination => 'Spirituelle Neigung';

  @override
  String get lpMeditationReceptivity => 'Empfänglichkeit für Meditation';

  @override
  String get lpTeacherKarma => 'Lehrer/Guru-Karma';

  @override
  String get lpPilgrimageBenefit => 'Nutzen der Pilgerreise';

  @override
  String get lpSelfRealization => 'Selbstverwirklichungspotenzial';

  @override
  String get lpDivineConnection => 'Göttliche Verbindung';

  @override
  String get lpTraditionAffinity => 'Affinität zur Tradition';

  @override
  String get lpIntuitionStrength => 'Intuitionsstärke';

  @override
  String get lpMantraEfficacy => 'Wirksamkeit von Gebet/Mantra';

  @override
  String get lpInnerGuidance => 'Vertrauen in innere Führung';

  @override
  String get lpPropheticDreams => 'Empfänglichkeit für prophetische Träume';

  @override
  String get lpDifficultyTitle => 'Lebensschwierigkeiten & Herausforderungen';

  @override
  String get lpEarlyLife => 'Frühes Leben';

  @override
  String get lpMidlife => 'Lebensmitte';

  @override
  String get lpLateLife => 'Spätes Leben';

  @override
  String get lpStruggleToSuccess => 'Karma vom Kampf zum Erfolg';

  @override
  String get lpUnlivedLifeRisk => 'Risiko des ungelebten Lebens';

  @override
  String get lpChallenges => 'Lebensherausforderungen';

  @override
  String get lpFortuneDrains => 'Chronische Glücksverluste';

  @override
  String get lpRegretAreas => 'Bereiche mit Bedauerns-Risiko';

  @override
  String get lpRedFlags => 'Warnsignale zur Richtung';

  @override
  String get lpBlessingsTitle => 'Segnungen & zentrales Lebensthema';

  @override
  String get lpKarmicRoot => 'Karmische Wurzel';

  @override
  String get lpBlessingsList => 'Deine Segnungen';

  @override
  String get lpFulfillmentPriorities => 'Erfüllungsprioritäten';

  @override
  String get lpImprovementTitle => 'Verbesserungsplan';

  @override
  String get lpDharmaPriorities => 'Dharma-Prioritäten';

  @override
  String get lpRoadmapTitle => 'Dein Schicksals-Fahrplan';

  @override
  String get lpStrategy => 'Strategie';

  @override
  String get lpFulfillmentPotential => 'Erfüllungspotenzial';

  @override
  String get lpNext12Focus => 'Fokus für die nächsten 12 Monate';

  @override
  String get lpLayerD1 => 'Geburtschart (D1)';

  @override
  String get lpLayerD9 => 'Navamsa (D9)';

  @override
  String get lpLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get lpLayerDasha => 'Dasha-Timing';

  @override
  String get lpLayerTransit => 'Aktuelle Transite';

  @override
  String get lpTopicPurpose => 'Mein Lebenszweck';

  @override
  String get lpTopicFortune => 'Meine Glücks-Yogas';

  @override
  String get lpTopicKarma => 'Meine karmischen Lektionen';

  @override
  String get lpTopicMilestones => 'Bevorstehende Meilensteine';

  @override
  String get lpTopicDestiny => 'Schicksal vs. freier Wille';

  @override
  String get lpTopicSpiritual => 'Mein spiritueller Weg';

  @override
  String get lpTopicChallenges => 'Meine Lebensherausforderungen';

  @override
  String get lpTopicTiming => 'Beste Zeitfenster';

  @override
  String get dbSubtitle =>
      'KI-gestützter vedischer Bericht zu Schulden & Erholung';

  @override
  String get dbTitle => 'Schulden & Erholung';

  @override
  String get dbSnapshotHeader => 'Übersicht zur Schuldenerholung';

  @override
  String dbHeroSummary(
    Object phase,
    Object personality,
    Object probability,
    Object years,
  ) {
    return 'Du befindest dich derzeit in einer „$phase“-Phase mit einem $personality Ansatz zum Thema Geld. Unsere Analyse zeigt eine $probability%ige Chance, innerhalb von etwa $years Jahren schuldenfrei zu werden.';
  }

  @override
  String get dbGaugeCapacity => 'Erholungskapazität';

  @override
  String get dbGaugeProbability => 'Erholungschance';

  @override
  String get dbGaugeFreedomNow => 'Schuldenfreiheit jetzt';

  @override
  String get dbGaugeDti => 'Einkommensgesundheit';

  @override
  String get dbGaugeResilience => 'Resilienz';

  @override
  String get dbChipCleanKarma => 'Sauberes Schulden-Karma';

  @override
  String get dbChipStrongRecovery => 'Starke Erholungskapazität';

  @override
  String get dbChipHealthyDti =>
      'Gesundes Verhältnis von Schulden zu Einkommen';

  @override
  String get dbChipResilient => 'Hohe psychologische Resilienz';

  @override
  String get dbChipCycleBreakable => 'Schuldenzyklus ist durchbrechbar';

  @override
  String get dbChipLowReindebt => 'Geringes Risiko erneuter Verschuldung';

  @override
  String get dbChipGoodNegotiator => 'Gute Verhandlungschancen';

  @override
  String get dbProfileTitle => 'Dein Schuldenprofil';

  @override
  String get dbPhaseLabel => 'Aktuelle Phase';

  @override
  String get dbPrimaryCategoryLabel => 'Hauptkategorie';

  @override
  String get dbKarakaLabel => 'Schulden-Karaka';

  @override
  String get dbProtectorLabel => 'Gläubigerschutz';

  @override
  String get dbSecondaryCategories => 'Nebenkategorien';

  @override
  String get dbUnsecuredRatio => 'Anteil unbesicherter Schulden';

  @override
  String get dbKarakaTitle => 'Deine Schulden-Planeten';

  @override
  String get dbKarakaSubtitle =>
      'Wie stark jeder Planet deine Schuldenerholung unterstützt';

  @override
  String get dbVerificationTitle => 'Über die Charts bestätigt (D6)';

  @override
  String get dbD6Label => 'D6 Schulden- & Feinde-Chart';

  @override
  String get dbD6LordDignity => 'Stärke des 6. Herrn';

  @override
  String get dbD6Severity => 'Schweregrad des Schulden-Karmas';

  @override
  String get dbD6Multiplier => 'D6-Schulden-Multiplikator';

  @override
  String get dbYogasTitle => 'Schulden-Yogas & Schutzfaktoren';

  @override
  String get dbPressureNow => 'Aktueller Schuldendruck';

  @override
  String get dbRecoveryBoost => 'Erholungsschub';

  @override
  String get dbClearingLabel => 'Schulden-Tilgungs-Yogas';

  @override
  String get dbCreatingLabel => 'Schulden-erzeugende Yogas';

  @override
  String get dbCategoriesTitle => 'Zu beobachtende Schuldenkategorien';

  @override
  String get dbCategoriesSubtitle =>
      'Welche Schuldenarten die meiste Aufmerksamkeit benötigen';

  @override
  String get dbTimelineTitle => 'Zeitplan bis zur Schuldenfreiheit';

  @override
  String get dbFreeWindowLabel => 'SCHULDENFREIES FENSTER';

  @override
  String get dbClearanceEstimate => 'Geschätzte vollständige Tilgung';

  @override
  String get dbPeakYears => 'Jahre der Schuldenspitze';

  @override
  String get dbClearanceYears => 'Tilgungsjahre';

  @override
  String get dbBorrowTitle => 'Leitfaden für kluges Kreditverhalten';

  @override
  String get dbLoanSuitability => 'Krediteignung';

  @override
  String get dbBestLoanType => 'Beste Kreditart';

  @override
  String get dbLeverageCeiling => 'Verschuldungsobergrenze';

  @override
  String get dbNegotiationSuccess => 'Verhandlungserfolg';

  @override
  String get dbCreditorAggression => 'Risiko von Gläubigerdruck';

  @override
  String get dbLegalEscalation => 'Risiko rechtlicher Eskalation';

  @override
  String get dbNegotiationApproach => 'Empfohlener Ansatz';

  @override
  String get dbAvoidLoanTypes => 'Zu vermeidende Kreditarten';

  @override
  String get dbRiskTitle => 'Risiko- & Anfälligkeitsübersicht';

  @override
  String get dbRiskDefault => 'Zahlungsausfallrisiko';

  @override
  String get dbRiskDefaultExp =>
      'Die Wahrscheinlichkeit, eine geplante Rückzahlung so stark zu verpassen, dass sie beim Kreditgeber einen Zahlungsausfall auslöst.';

  @override
  String get dbRiskDefaultFix =>
      'Automatisiere Mindestzahlungen und halte einen 1-Monats-Puffer, damit ein einzelner ausgefallener Einkommenszyklus keine Kettenreaktion auslöst.';

  @override
  String get dbRiskBankruptcy => 'Insolvenzrisiko';

  @override
  String get dbRiskBankruptcyExp =>
      'Die Wahrscheinlichkeit, dass die Schuldenlast über das hinauswächst, was Einkommen und Vermögen realistisch decken können.';

  @override
  String get dbRiskBankruptcyFix =>
      'Lass eine professionelle Schuldenprüfung durchführen, bevor du einen neuen Kredit oder eine Kreditlinie aufnimmst.';

  @override
  String get dbRiskAssetSeizure => 'Risiko der Vermögenspfändung';

  @override
  String get dbRiskAssetSeizureExp =>
      'Die Wahrscheinlichkeit, dass ein Ausfall bei einem besicherten Kredit dazu führt, dass der Kreditgeber Sicherheiten oder Eigentum einzieht.';

  @override
  String get dbRiskAssetSeizureFix =>
      'Priorisiere zuerst Zahlungen für besicherte Kredite und refinanziere frühzeitig, wenn eine Zahlungslücke wahrscheinlich erscheint.';

  @override
  String get dbRiskChronic => 'Risiko chronischer Neuverschuldung';

  @override
  String get dbRiskChronicExp =>
      'Die Tendenz, selbst nach Tilgung der aktuellen Last wieder in Schulden zu geraten.';

  @override
  String get dbRiskChronicFix =>
      'Baue einen eigenen Notfallfonds auf, bevor du nach der Tilgung die Lebenshaltungsausgaben erhöhst.';

  @override
  String get dbReindebtTrigger => 'Auslöser für Neuverschuldung';

  @override
  String get dbCycleBreakFeasibility => 'Machbarkeit des Zyklusdurchbruchs';

  @override
  String get dbMajorRisks => 'Hauptrisiken';

  @override
  String get dbHiddenSignals => 'Verborgene Schuldensignale';

  @override
  String get dbCrisisTitle => 'Krisenvorsorge';

  @override
  String get dbCrisisSubtitle =>
      'Wie man Probleme frühzeitig erkennt und ruhig reagiert';

  @override
  String get dbWarningSigns => 'Frühwarnzeichen';

  @override
  String get dbMitigationActions => 'Was dagegen zu tun ist';

  @override
  String get dbFamilyTitle => 'Familien- & Ahnenschulden';

  @override
  String get dbInheritedDebtProb => 'Wahrscheinlichkeit ererbter Schulden';

  @override
  String get dbFamilyDrag => 'Familiäre Schuldenlast';

  @override
  String get dbInheritedSource => 'Wahrscheinliche Quelle';

  @override
  String get dbCoreBlockerLabel => 'KERNBLOCKADE';

  @override
  String get dbPsychologyTitle => 'Deine Geldpsychologie';

  @override
  String get dbResilience => 'Resilienz';

  @override
  String get dbDiscipline => 'Disziplin unter Druck';

  @override
  String get dbSocialSupport => 'Soziale Unterstützung';

  @override
  String get dbDepressionRisk => 'Anfälligkeit für finanziellen Stress';

  @override
  String get dbStressTolerance => 'Stresstoleranz';

  @override
  String get dbRootCause => 'Verhaltensbedingte Grundursache';

  @override
  String get dbImprovementTitle => 'Verbesserungsplan';

  @override
  String get dbRoadmapTitle => 'Dein Fahrplan zur Schuldenfreiheit';

  @override
  String get dbRecoveryProbability => 'Erholungswahrscheinlichkeit';

  @override
  String get dbClearanceTimeline => 'Tilgungszeitplan';

  @override
  String get dbYears => 'Jahre';

  @override
  String get dbDtiHealth => 'Gesundheit des Schulden-Einkommens-Verhältnisses';

  @override
  String get dbDtiCategory => 'DTI-Kategorie';

  @override
  String get dbBreakEvenMonths => 'Monate bis zum Break-even';

  @override
  String get dbIncomeAcceleration => 'Benötigtes Einkommenswachstum';

  @override
  String get dbLayerD1 => 'Geburtschart (D1)';

  @override
  String get dbLayerD6 => 'Schulden & Feinde (D6)';

  @override
  String get dbLayerD9 => 'Navamsa (D9)';

  @override
  String get dbLayerDasha => 'Dasha-Timing';

  @override
  String get dbLayerTransit => 'Aktuelle Transite';

  @override
  String get dbTopicRecovery => 'Mein Erholungszeitplan';

  @override
  String get dbTopicNegotiate => 'Verhandeln mit Gläubigern';

  @override
  String get dbTopicBorrowing => 'Ist es jetzt sicher, Kredite aufzunehmen';

  @override
  String get dbTopicCrisis => 'Vorbereitung auf eine Krise';

  @override
  String get dbTopicAncestral => 'Ahnen-Schulden-Karma';

  @override
  String get dbTopicTimeline => 'Beste Jahre zur Schuldentilgung';

  @override
  String get dbTopicPsychology => 'Meine Geldpsychologie';

  @override
  String get dbTopicCategories => 'Welche Schulden priorisiert werden sollten';

  @override
  String get mnSubtitle => 'KI-gestützter vedischer Wellness-Bericht';

  @override
  String get mnTitle => 'Mentale Gesundheit & Stress';

  @override
  String get mnSnapshotHeader => 'Wellness-Übersicht';

  @override
  String get mnResilience => 'Resilienz';

  @override
  String get mnStability => 'Stabilität';

  @override
  String get mnEmotionalBalance => 'Emotionale Balance';

  @override
  String get mnInnerCalm => 'Innere Ruhe';

  @override
  String get mnSelfAwareness => 'Selbstwahrnehmung';

  @override
  String get mnStatusThriving => 'Aufblühend';

  @override
  String get mnStatusSteady => 'Stabil & Ausgeglichen';

  @override
  String get mnStatusBuildingStrength => 'Im Aufbau von Stärke';

  @override
  String get mnStatusNeedsGentleCare => 'Benötigt sanfte Fürsorge';

  @override
  String get mnStatusReachOut => 'Zeit, Unterstützung zu suchen';

  @override
  String get mnChipStable => 'Emotional stabil';

  @override
  String get mnChipSupported => 'Gut unterstützt';

  @override
  String get mnChipSelfAware => 'Sehr selbstbewusst';

  @override
  String get mnChipResilient => 'Erholt sich gut';

  @override
  String get mnChipSecureAttachment => 'Sichere Bindung';

  @override
  String get mnChipHealingReady => 'Bereit zu heilen';

  @override
  String get mnChipMindBodyBalance => 'Geist-Körper-Balance';

  @override
  String get mnSupportBannerTitle => 'Ein sanfter Hinweis';

  @override
  String get mnSupportBannerBody =>
      'Dein Chart deutet darauf hin, dass dies ein guter Zeitpunkt sein könnte, um zusätzliche Unterstützung in Anspruch zu nehmen — einen vertrauten Freund, ein Familienmitglied oder eine Fachperson. Um Hilfe zu bitten ist ein Zeichen von Stärke, nicht von Schwäche.';

  @override
  String get mnProfileTitle => 'Dein emotionales Profil';

  @override
  String get mnStressDriver => 'Stressauslöser';

  @override
  String get mnStabilityAnchor => 'Stabilitätsanker';

  @override
  String get mnSoulLevelKarma => 'Muster auf Seelenebene';

  @override
  String get mnSubtleSignature => 'Feine emotionale Signatur';

  @override
  String get mnKarakaTitle => 'Dein Geist & die Planeten';

  @override
  String get mnKarakaSubtitle => 'Welche Planeten deine innere Welt formen';

  @override
  String get mnYogasTitle => 'Stärken & Wachstumsbereiche';

  @override
  String get mnCurrentPhase => 'Aktuelle Phase';

  @override
  String get mnCurrentStressLevel => 'Aktuelles Stressniveau';

  @override
  String get mnRecentStrain => 'Kürzliche emotionale Belastung';

  @override
  String get mnStrengths => 'Stärken';

  @override
  String get mnGrowthAreas => 'Wachstumsbereiche';

  @override
  String get mnSadeSatiStatus => 'Sade-Sati-Status';

  @override
  String get mnVerificationTitle => 'Über die Charts bestätigt';

  @override
  String get mnD9Confirmation => 'D9-Bestätigung';

  @override
  String get mnD30Confirmation => 'D30-Bestätigung';

  @override
  String get mnMoodPatternsTitle => 'Stimmungs- & Angstmuster';

  @override
  String get mnMoodPatternsSubtitle => 'Sanftes Bewusstsein, keine Diagnose';

  @override
  String get mnAnxietyPatterns => 'Angstmuster';

  @override
  String get mnMoodPatterns => 'Muster gedrückter Stimmung';

  @override
  String get mnPrimaryPattern => 'Primäres Muster';

  @override
  String get mnRumination => 'Neigung zum Grübeln';

  @override
  String get mnHypervigilance => 'Übermäßige Wachsamkeit';

  @override
  String get mnHopelessnessVuln => 'Empfindlichkeit für gedrückte Stimmung';

  @override
  String get mnEnergyDepletion => 'Neigung zur Energieerschöpfung';

  @override
  String get mnMotivationBaseline => 'Motivations-Basiswert';

  @override
  String get mnRegulationTitle => 'Emotionale Regulation & Bewältigung';

  @override
  String get mnEmotionalRegulation => 'Emotionale Regulation';

  @override
  String get mnSelfSoothing => 'Fähigkeit zur Selbstberuhigung';

  @override
  String get mnExpressionStyle => 'Ausdrucksstil';

  @override
  String get mnRecoveryTime => 'Erholungszeit';

  @override
  String get mnTriggerIntensity => 'Trigger-Intensität';

  @override
  String get mnHealthyCoping => 'Gesunde Bewältigungsgewohnheiten';

  @override
  String get mnWatchFor => 'Sanft im Blick behalten';

  @override
  String get mnSleepTitle => 'Schlaf & Erholung';

  @override
  String get mnSleepQuality => 'Schlafqualität';

  @override
  String get mnSleepAsRegulator => 'Schlaf als emotionaler Regulator';

  @override
  String get mnInsomniaTendency => 'Neigung zu unruhigen Nächten';

  @override
  String get mnNightmareTendency => 'Neigung zu lebhaften Träumen';

  @override
  String get mnSleepHygienePriority => 'Priorität der Schlafhygiene';

  @override
  String get mnBurnoutTitle => 'Burnout & Energie';

  @override
  String get mnBurnoutVulnerability => 'Burnout-Anfälligkeit';

  @override
  String get mnBurnoutRecovery => 'Burnout-Erholungskapazität';

  @override
  String get mnBurnoutStage => 'Aktuelles Burnout-Stadium';

  @override
  String get mnSelfDrivingTendency => 'Neigung zur Selbstantreibung';

  @override
  String get mnBurnoutTriggers => 'Burnout-Auslöser';

  @override
  String get mnConnectionTitle => 'Verbindung & Unterstützung';

  @override
  String get mnSocialSupport => 'Qualität der sozialen Unterstützung';

  @override
  String get mnLonelinessVuln => 'Empfindlichkeit für Einsamkeit';

  @override
  String get mnSolitudeNeed => 'Bedürfnis nach Alleinsein';

  @override
  String get mnSocialComfort => 'Soziales Wohlbefinden';

  @override
  String get mnTraumaSensitivity => 'Trauma-Empfindlichkeit';

  @override
  String get mnHealingReadiness => 'Bereitschaft zur Heilung';

  @override
  String get mnProcessingStyle => 'Verarbeitungsstil';

  @override
  String get mnMindBodyIntegration => 'Geist-Körper-Integration';

  @override
  String get mnPtsdVuln => 'Empfindlichkeit der Trauma-Reaktion';

  @override
  String get mnSelfAwarenessTitle => 'Selbstwahrnehmung & Wachstum';

  @override
  String get mnSelfAwarenessScore => 'Selbstwahrnehmung';

  @override
  String get mnEmotionalVocabulary => 'Emotionaler Wortschatz';

  @override
  String get mnTherapyReadiness => 'Bereitschaft für Therapie';

  @override
  String get mnJournalingBenefit => 'Nutzen des Tagebuchschreibens';

  @override
  String get mnInnerDialogue => 'Qualität des inneren Dialogs';

  @override
  String get mnAwarenessOfPatterns => 'Bewusstsein für Muster';

  @override
  String get mnEscapePatternVuln => 'Empfindlichkeit für Fluchtmuster';

  @override
  String get mnEscapeChannels => 'Sanft im Blick behalten';

  @override
  String get mnHealthyAlternatives => 'Gesunde Alternativen';

  @override
  String get mnTherapyFitTitle => 'Passung von Therapie & Unterstützung';

  @override
  String get mnCrisisSupportRec => 'Unterstützungsempfehlung';

  @override
  String get mnSupportNetwork => 'Aktiviere dein Unterstützungsnetzwerk';

  @override
  String get mnSelfAdvocacy => 'Bereitschaft zur Selbstvertretung';

  @override
  String get mnMedicationReceptivity => 'Offenheit gegenüber Medikamenten';

  @override
  String get mnTimelineTitle => 'Wellness-Zeitlinie';

  @override
  String get mnPeakWellnessYears => 'Jahre des Wellness-Höhepunkts';

  @override
  String get mnExtraCareYears => 'Jahre für zusätzliche Selbstfürsorge';

  @override
  String get mnTransformationWindows => 'Fenster positiver Transformation';

  @override
  String get mnTherapyWindow => 'Empfohlenes Therapiefenster';

  @override
  String get mnPracticesTitle => 'Tägliche Wellness-Praktiken';

  @override
  String get mnMorningPractices => 'Morgenpraktiken';

  @override
  String get mnEveningPractices => 'Abendpraktiken';

  @override
  String get mnBreathwork => 'Atemarbeit';

  @override
  String get mnMovement => 'Bewegung';

  @override
  String get mnNutrition => 'Ernährung';

  @override
  String get mnNatureExposure => 'Bedürfnis nach Naturaufenthalt';

  @override
  String get mnDigitalDetox => 'Bedürfnis nach digitaler Entgiftung';

  @override
  String get mnImprovementTitle => 'Verbesserungsplan';

  @override
  String get mnReliabilityTitle => 'Zuverlässigkeit';

  @override
  String get mnLayerD1 => 'Geburtschart (D1)';

  @override
  String get mnLayerD9 => 'Seelenchart (D9)';

  @override
  String get mnLayerD30 => 'D30-Chart';

  @override
  String get mnLayerDasha => 'Dasha-Timing';

  @override
  String get mnLayerTransit => 'Transite';

  @override
  String get mnTopicResilience => 'Wie emotional widerstandsfähig bin ich?';

  @override
  String get mnTopicCoping => 'Was sind meine besten Bewältigungsstrategien?';

  @override
  String get mnTopicSleep => 'Wie kann ich meinen Schlaf verbessern?';

  @override
  String get mnTopicBurnout => 'Bin ich burnoutgefährdet?';

  @override
  String get mnTopicTherapy => 'Welcher Therapiestil passt zu mir?';

  @override
  String get mnTopicPractices =>
      'Welche täglichen Praktiken helfen mir am meisten?';

  @override
  String get mnTopicTiming => 'Wann sind meine besten Wellness-Jahre?';

  @override
  String get mnTopicSupport =>
      'Wie baue ich ein starkes Unterstützungsnetzwerk auf?';

  @override
  String get lgSubtitle => 'KI-gestützter vedischer Rechtsbericht';

  @override
  String get lgTitle => 'Recht & Streitigkeiten';

  @override
  String get lgSnapshotHeader => 'Rechtliche Übersicht';

  @override
  String get lgResilience => 'Rechtliche Resilienz';

  @override
  String get lgResolutionCapacity => 'Lösungskapazität';

  @override
  String get lgVictoryPotential => 'Siegpotenzial';

  @override
  String get lgLegalSafety => 'Rechtliche Sicherheit';

  @override
  String get lgNegotiationSkill => 'Verhandlungsgeschick';

  @override
  String get lgStatusExcellent => 'Ausgezeichnet';

  @override
  String get lgStatusStrong => 'Stark';

  @override
  String get lgStatusModerate => 'Mäßig';

  @override
  String get lgStatusDeveloping => 'In Entwicklung';

  @override
  String get lgStatusChallenging => 'Herausfordernd';

  @override
  String get lgChipResolver => 'Geschickter Vermittler';

  @override
  String get lgChipWinner => 'Starke Fallgewinne';

  @override
  String get lgChipNegotiator => 'Geborener Verhandler';

  @override
  String get lgChipDocumented => 'Gut dokumentiert';

  @override
  String get lgChipLowRisk => 'Geringes rechtliches Risiko';

  @override
  String get lgChipMoralAuthority => 'Moralische Autorität';

  @override
  String get lgChipLegalAptitude => 'Rechtliche Begabung';

  @override
  String get lgProfileTitle => 'Dein rechtliches Profil & Karma';

  @override
  String get lgPrimaryDriver => 'Primärer Antrieb';

  @override
  String get lgDharmaAnchor => 'Dharma-Anker';

  @override
  String get lgAggressionMarker => 'Aggressionsmarker';

  @override
  String get lgDocumentationKaraka => 'Qualität der Dokumentation';

  @override
  String get lgKarakaTitle => 'Deine Rechts-Planeten';

  @override
  String get lgKarakaSubtitle =>
      'Welche Planeten dein rechtliches Schicksal formen';

  @override
  String get lgYogasTitle => 'Rechts-Yogas & Schutzfaktoren';

  @override
  String get lgCurrentPhase => 'Aktuelle Phase';

  @override
  String get lgProtections => 'Schutzfaktoren';

  @override
  String get lgDisputePressures => 'Streitdruck';

  @override
  String get lgVerificationTitle => 'Über die Charts bestätigt';

  @override
  String get lgD6Litigation => 'D6-Rechtsstreit-Chart';

  @override
  String get lgD9Dharma => 'D9-Dharma-Chart';

  @override
  String get lgMoralAuthority => 'Moralische Autorität';

  @override
  String get lgVictoryTitle => 'Sieganalyse';

  @override
  String get lgAsPlaintiff => 'Als Kläger';

  @override
  String get lgAsDefendant => 'Als Beklagter';

  @override
  String get lgSettlementPreference => 'Präferenz für Vergleich';

  @override
  String get lgDisputeCategoriesTitle => 'Zu beobachtende Streitkategorien';

  @override
  String get lgLowRiskCategories => 'Kategorien mit geringem Risiko';

  @override
  String get lgConflictStyleTitle => 'Konfliktstil & Feinde';

  @override
  String get lgConfrontationComfort => 'Wohlbefinden bei Konfrontation';

  @override
  String get lgArgumentPersuasiveness => 'Überzeugungskraft der Argumente';

  @override
  String get lgEmotionalRegulation => 'Emotionale Regulation';

  @override
  String get lgGrudgeHolding => 'Neigung, Groll zu hegen';

  @override
  String get lgEnemyAnalysisLabel => 'Feindanalyse';

  @override
  String get lgVisibleEnemies => 'Sichtbare Feinde';

  @override
  String get lgHiddenEnemies => 'Verborgene Feinde';

  @override
  String get lgWorkplaceEnemies => 'Feinde am Arbeitsplatz';

  @override
  String get lgFamilyEnemies => 'Feinde in der Familie';

  @override
  String get lgLegalEnemies => 'Rechtliche Gegner';

  @override
  String get lgEnemyDefeatCapacity => 'Fähigkeit, Feinde zu besiegen';

  @override
  String get lgCriminalFinancialTitle =>
      'Übersicht krimineller & finanzieller Risiken';

  @override
  String get lgCriminalRisk => 'Risiko krimineller Verwicklung';

  @override
  String get lgVictimOfCrime =>
      'Wahrscheinlichkeit, Opfer eines Verbrechens zu werden';

  @override
  String get lgFalseAccusation => 'Risiko falscher Anschuldigung';

  @override
  String get lgImprisonmentRisk => 'Inhaftierungsrisiko';

  @override
  String get lgTaxDisputeRisk => 'Risiko von Steuerstreitigkeiten';

  @override
  String get lgFinancialFraudRisk => 'Risiko von Finanzbetrug';

  @override
  String get lgBusinessLitigationRisk => 'Risiko von Geschäftsstreitigkeiten';

  @override
  String get lgBankruptcyRisk => 'Insolvenzrisiko';

  @override
  String get lgAuditVulnerability => 'Anfälligkeit für Prüfungen';

  @override
  String get lgProtectionPriority => 'Schutzpriorität';

  @override
  String get lgContractsTitle => 'Verträge & Verhandlung';

  @override
  String get lgContractClarity => 'Vertragsklarheit';

  @override
  String get lgDocumentationDiscipline => 'Disziplin bei der Dokumentation';

  @override
  String get lgFinePrintAwareness => 'Bewusstsein für Kleingedrucktes';

  @override
  String get lgSignatureCaution => 'Vorsicht bei Unterschriften';

  @override
  String get lgMediationReceptivity => 'Offenheit für Mediation';

  @override
  String get lgNegotiationSkillFull => 'Verhandlungsgeschick';

  @override
  String get lgCompromiseWillingness => 'Kompromissbereitschaft';

  @override
  String get lgFaceSavingNeeds => 'Bedürfnis, das Gesicht zu wahren';

  @override
  String get lgMediatorHireRecommendation =>
      'Empfehlung zur Beauftragung eines Mediators';

  @override
  String get lgTypicalContractIssues => 'Typische Vertragsprobleme';

  @override
  String get lgCareerFitTitle => 'Passung für juristische Karriere';

  @override
  String get lgProfessionAffinity => 'Berufsaffinität';

  @override
  String get lgRoleFit => 'Beste Rollenpassung';

  @override
  String get lgLawStudentSuccess => 'Erfolg als Jurastudent';

  @override
  String get lgBarExamSuccess => 'Erfolg beim Anwaltsexamen';

  @override
  String get lgTimelineTitle => 'Rechtliche Zeitlinie';

  @override
  String get lgNewMatterChance =>
      'Wahrscheinlichkeit neuer Fälle (nächste 12 Monate)';

  @override
  String get lgOngoingCaseOutcome => 'Ausgang laufender Fälle';

  @override
  String get lgRecommendedAction => 'Empfohlene Maßnahme';

  @override
  String get lgPeakDisputeYears => 'Jahre mit Streit-Höhepunkt';

  @override
  String get lgClarityYears => 'Jahre rechtlicher Klarheit';

  @override
  String get lgAvoidancePeriods => 'Kritische Vermeidungszeiträume';

  @override
  String get lgFavorableWindows => 'Günstige Lösungsfenster';

  @override
  String get lgRisksTitle => 'Risiken & Anfälligkeiten';

  @override
  String get lgChronicVulnerabilities => 'Chronische Anfälligkeiten';

  @override
  String get lgAvoidDashaPeriods => 'Zu beachtende Dasha-Perioden';

  @override
  String get lgPreventivePriorities => 'Präventive Prioritäten';

  @override
  String get lgRedFlags => 'Warnsignal-Situationen';

  @override
  String get lgImprovementTitle => 'Verbesserungsplan';

  @override
  String get lgReliabilityTitle => 'Zuverlässigkeit';

  @override
  String get lgLayerD1 => 'Geburtschart (D1)';

  @override
  String get lgLayerD6 => 'Rechtsstreit-Chart (D6)';

  @override
  String get lgLayerD9 => 'Dharma-Chart (D9)';

  @override
  String get lgLayerDasha => 'Dasha-Timing';

  @override
  String get lgLayerTransit => 'Transite';

  @override
  String get lgTopicWinChance => 'Wie stehen meine Gewinnchancen?';

  @override
  String get lgTopicStrategy => 'Beste rechtliche Strategie für mich?';

  @override
  String get lgTopicContract => 'Zu beachtende Vertragsrisiken?';

  @override
  String get lgTopicTiming => 'Bestes Timing zur Streitbeilegung?';

  @override
  String get lgTopicSettlement => 'Sollte ich vergleichen oder kämpfen?';

  @override
  String get lgTopicEnemies => 'Wer sind meine verborgenen Feinde?';

  @override
  String get lgTopicProtection => 'Wie kann ich mich rechtlich schützen?';

  @override
  String get lgTopicCareer => 'Bin ich für eine juristische Karriere geeignet?';

  @override
  String get prSubtitle => 'KI-gestützter vedischer Bericht zu Immobilien';

  @override
  String get prTitle => 'Immobilien & Vermögen';

  @override
  String get prSnapshotHeader => 'Immobilienübersicht';

  @override
  String get prAcquisitionCapacity => 'Erwerbskapazität';

  @override
  String get prHomeOwnership => 'Wohneigentum';

  @override
  String get prWealthPotential => 'Vermögenspotenzial';

  @override
  String get prRentalIncome => 'Mieteinnahmen';

  @override
  String get prLandOwnership => 'Grundbesitz';

  @override
  String get prStatusExcellent => 'Ausgezeichnet';

  @override
  String get prStatusStrong => 'Stark';

  @override
  String get prStatusModerate => 'Mäßig';

  @override
  String get prStatusDeveloping => 'In Entwicklung';

  @override
  String get prStatusChallenging => 'Herausfordernd';

  @override
  String get prChipHomeOwner => 'Hausbesitzer';

  @override
  String get prChipWealthBuilder => 'Vermögensaufbauer';

  @override
  String get prChipLandOwner => 'Grundbesitzer';

  @override
  String get prChipInvestor => 'Immobilieninvestor';

  @override
  String get prChipInheritance => 'Erbschaft wahrscheinlich';

  @override
  String get prChipVehicle => 'Fahrzeugbesitzer';

  @override
  String get prChipGlobalAsset => 'Affinität zu globalem Vermögen';

  @override
  String get prProfileTitle => 'Dein Immobilienstil';

  @override
  String get prHomeAesthetics => 'Ästhetik des Zuhauses';

  @override
  String get prHomeSanctuary => 'Zuhause als Zufluchtsort';

  @override
  String get prComfortInvestment => 'Komfort-Investition';

  @override
  String get prVastuPriority => 'Vastu-Priorität';

  @override
  String get prNaturalElements => 'Natürliche Elemente';

  @override
  String get prNextActionLabel => 'Nächste Maßnahme';

  @override
  String get prKarakaTitle => 'Deine Immobilien-Planeten';

  @override
  String get prKarakaSubtitle => 'Welche Planeten dein Immobilienglück formen';

  @override
  String get prPrimaryKaraka => 'Primärer Karaka';

  @override
  String get prDurableAsset => 'Karaka für dauerhafte Vermögenswerte';

  @override
  String get prYogasTitle => 'Immobilien-Yogas & Doshas';

  @override
  String get prCurrentPhase => 'Aktuelle Phase';

  @override
  String get prBoosters => 'Verstärker';

  @override
  String get prDrains => 'Verluste';

  @override
  String get prVerificationTitle => 'Über die Charts bestätigt';

  @override
  String get prD4Property => 'D4-Immobilien-Chart';

  @override
  String get prD16Vehicle => 'D16-Fahrzeug-Chart';

  @override
  String get prVehicleFit => 'Fahrzeugpassung';

  @override
  String get prJourneyTitle => 'Eigentümerreise & Zeitplan';

  @override
  String get prFirstHomeAge => 'Alter beim ersten Eigenheim';

  @override
  String get prFirstHomeType => 'Art des ersten Eigenheims';

  @override
  String get prMultipleHomes => 'Mehrere Wohnungen';

  @override
  String get prNewPropertySoon => 'Neue Immobilie in Kürze';

  @override
  String get prFirstMajorWindow => 'Erstes großes Zeitfenster';

  @override
  String get prBuyingWindow => 'Kauffenster';

  @override
  String get prConstructionWindow => 'Baufenster';

  @override
  String get prNextOpportunity => 'Nächste Gelegenheit';

  @override
  String get prLifetimePropertyCount => 'Anzahl der Immobilien im Leben';

  @override
  String get prInheritanceTitle => 'Erbschaft & Familienbesitz';

  @override
  String get prMaternalInheritance => 'Mütterliches Erbe';

  @override
  String get prPaternalInheritance => 'Väterliches Erbe';

  @override
  String get prAncestralProperty => 'Ererbter Familienbesitz';

  @override
  String get prFamilyDisputeRisk => 'Risiko von Familienstreitigkeiten';

  @override
  String get prInheritanceTiming => 'Zeitpunkt der Erbschaft';

  @override
  String get prInheritanceType => 'Art der Erbschaft';

  @override
  String get prLandInvestTitle =>
      'Land, Investition & globaler Immobilienbesitz';

  @override
  String get prPropertyInvestor => 'Immobilieninvestor-Score';

  @override
  String get prAppreciationLuck => 'Wertsteigerungsglück';

  @override
  String get prInvestorMindset => 'Investoren-Mentalität';

  @override
  String get prLandType => 'Landart';

  @override
  String get prRentalCount => 'Anzahl der Mietobjekte';

  @override
  String get prMultipleLand => 'Mehrere Grundstücke';

  @override
  String get prFarmEstate => 'Chance auf Bauernhof/Anwesen';

  @override
  String get prGlobalPropertyLabel => 'Globaler Immobilienbesitz';

  @override
  String get prForeignProperty => 'Auslandsimmobilie';

  @override
  String get prNriAffinity => 'NRI-Vermögensaffinität';

  @override
  String get prVehiclesTitle => 'Fahrzeuge';

  @override
  String get prVehicleCount => 'Anzahl der Fahrzeuge';

  @override
  String get prVehicleFirstAge => 'Alter beim ersten Fahrzeug';

  @override
  String get prVehicleCategory => 'Fahrzeugkategorie';

  @override
  String get prVehicleQuality => 'Fahrzeugqualität';

  @override
  String get prLuxuryAffinity => 'Affinität zu Luxus';

  @override
  String get prVehicleLossRisk => 'Risiko von Fahrzeugverlust/-schaden';

  @override
  String get prLegalRiskTitle => 'Übersicht rechtlicher Risiken';

  @override
  String get prBoundaryDisputes => 'Grenzstreitigkeiten';

  @override
  String get prPartitionDisputes => 'Teilungsstreitigkeiten';

  @override
  String get prTitleIssues => 'Eigentums-/Dokumentationsprobleme';

  @override
  String get prTenantConflict => 'Konflikt zwischen Mieter und Vermieter';

  @override
  String get prForcedSale => 'Risiko eines Zwangsverkaufs';

  @override
  String get prPropertyDamage => 'Risiko von Immobilienschäden';

  @override
  String get prInsurancePriority => 'Versicherungspriorität';

  @override
  String get prProtectionUrgency => 'Dringlichkeit des Schutzes';

  @override
  String get prProtectiveFactors => 'Schutzfaktoren';

  @override
  String get prChronicVulnerabilities => 'Chronische Anfälligkeiten';

  @override
  String get prDueDiligenceTitle => 'Checkliste zur Sorgfaltsprüfung';

  @override
  String get prPreventiveMeasures => 'Präventive Maßnahmen';

  @override
  String get prImprovementTitle => 'Verbesserungsplan';

  @override
  String get prReliabilityTitle => 'Zuverlässigkeit';

  @override
  String get prLayerD1 => 'Geburtschart (D1)';

  @override
  String get prLayerD4 => 'Immobilien-Chart (D4)';

  @override
  String get prLayerD16 => 'Fahrzeug-Chart (D16)';

  @override
  String get prLayerDasha => 'Dasha-Timing';

  @override
  String get prLayerTransit => 'Transite';

  @override
  String get prTopicBuying => 'Bester Zeitpunkt zum Kaufen?';

  @override
  String get prTopicInherit => 'Werde ich eine Immobilie erben?';

  @override
  String get prTopicVehicle => 'Wann bekomme ich ein Fahrzeug?';

  @override
  String get prTopicRental => 'Potenzial für Mieteinnahmen?';

  @override
  String get prTopicLand => 'Chancen auf Grundbesitz?';

  @override
  String get prTopicLegal => 'Zu beachtende rechtliche Risiken?';

  @override
  String get prTopicForeign => 'Chancen auf Auslandsimmobilien?';

  @override
  String get prTopicTiming => 'Beste Zeitfenster für Immobilien?';

  @override
  String get edTitle => 'Bildungs- & Lernanalyse';

  @override
  String get edSubtitle => 'KI-gestützter vedischer Bildungsbericht';

  @override
  String get edSnapshotHeader => 'Deine Bildungsübersicht';

  @override
  String get edOverallStrength => 'Gesamtstärke';

  @override
  String get edAcademicSuccess => 'Akademischer Erfolg';

  @override
  String get edLearningCapacity => 'Lernfähigkeit';

  @override
  String get edIntellect => 'Intellekt';

  @override
  String get edMemory => 'Gedächtnis';

  @override
  String get edStatusExcellent => 'Ausgezeichnetes Potenzial';

  @override
  String get edStatusStrong => 'Starkes Potenzial';

  @override
  String get edStatusModerate => 'Mäßiges Potenzial';

  @override
  String get edStatusDeveloping => 'Entwicklungspotenzial';

  @override
  String get edStatusChallenging => 'Herausfordernde Phase';

  @override
  String get edChipSaraswati => 'Saraswati Yoga';

  @override
  String get edChipGajaKesari => 'Gaja Kesari Yoga';

  @override
  String get edChipBudhaAditya => 'Budha Aditya Yoga';

  @override
  String get edChipResearch => 'Starke Forschungsfähigkeit';

  @override
  String get edChipScholarship => 'Stipendienpotenzial';

  @override
  String get edChipDoctorate => 'Promotionspotenzial';

  @override
  String get edChipForeign => 'Unterstützung für Auslandsbildung';

  @override
  String get edChipLifelong => 'Lebenslanger Lerner';

  @override
  String get edLearningStyleTitle => 'Dein Lernstil';

  @override
  String get edSoulPlanet => 'Seelenplanet';

  @override
  String get edSoulHint => 'Dein tiefster innerer Antrieb und Lebenszweck';

  @override
  String get edSubjectPlanet => 'Fach-Planet';

  @override
  String get edTechAtmakaraka => 'Atmakaraka (technisch)';

  @override
  String get edTechAmatyakaraka => 'Amatyakaraka (technisch)';

  @override
  String get edSubjectKarakaStrength => 'Stärke des Fach-Karaka';

  @override
  String get edFoundationTitle => 'Bildungsfundament';

  @override
  String get edHouse4 => 'Frühe Schulzeit';

  @override
  String get edHouse5 => 'Intelligenz';

  @override
  String get edHouse9 => 'Höhere Bildung';

  @override
  String get edPurvaPunya => 'Verdienst aus früherem Leben';

  @override
  String get edStudyPlanetsTitle => 'Deine Studien-Planeten';

  @override
  String get edYogasTitle => 'Bildungs-Yogas in deinem Chart';

  @override
  String get edYogaBudhaAditya => 'Budha Aditya';

  @override
  String get edYogaGajaKesari => 'Gaja Kesari';

  @override
  String get edYogaSaraswati => 'Saraswati';

  @override
  String get edYogaPresent => 'Vorhanden';

  @override
  String get edYogaAbsent => 'Nicht vorhanden';

  @override
  String get edYogaNoneNote =>
      'Keine klassischen Bildungs-Yogas — Erfolg entsteht durch konsequenten Einsatz und Disziplin.';

  @override
  String get edVerificationTitle => 'Bestätigung über die Charts';

  @override
  String get edD24Learning => 'D24 — Chart für vertieftes Lernen';

  @override
  String get edD4Formal => 'D4 — Chart für formale Bildung';

  @override
  String get edD9Dharma => 'D9 — Lern-Dharma-Chart';

  @override
  String get edD60Karma => 'D60 — Lernkarma aus früherem Leben';

  @override
  String get edSubjectsTitle => 'Beste Fächer für dich';

  @override
  String get edSubjectsSubtitle => 'Nach Chart-Affinität geordnet';

  @override
  String get edLowAffinity => 'Fächer mit geringerer Affinität';

  @override
  String get edDegreesTitle => 'Wahrscheinlichkeit von Abschluss & Niveau';

  @override
  String get edExpectedLevel => 'Erwartetes Niveau';

  @override
  String get edDegreeFormal => 'Formaler Abschluss';

  @override
  String get edDegreePostgrad => 'Postgraduiert';

  @override
  String get edDegreeDoctorate => 'Promotion';

  @override
  String get edDegreeForeign => 'Auslandsbildung';

  @override
  String get edTimelineTitle => 'Studien-Zeitplan';

  @override
  String get edEarlySchooling => 'Fenster für frühe Schulzeit';

  @override
  String get edHigherEducation => 'Fenster für höhere Bildung';

  @override
  String get edPostgradResearch =>
      'Fenster für Postgraduierten-/Forschungsstudium';

  @override
  String get edPeakLearningAge => 'Alter des Lernhöhepunkts';

  @override
  String get edPreferencesTitle => 'Lernpräferenzen & Unterstützung';

  @override
  String get edPrefStudyMode => 'Lernmodus';

  @override
  String get edPrefTiming => 'Beste Zeit';

  @override
  String get edPrefEnvironment => 'Umgebung';

  @override
  String get edPrefLocation => 'Standort';

  @override
  String get edPrefForeign => 'Auslandsstudium';

  @override
  String get edGuruRelationship => 'Beziehung zu Lehrer/Guru';

  @override
  String get edMentorAvailability => 'Verfügbarkeit eines Mentors';

  @override
  String get edPeerLearning => 'Lernen unter Gleichaltrigen';

  @override
  String get edAuthorityDeference => 'Respekt vor Autorität';

  @override
  String get edStrengthsTitle => 'Stärken & Herausforderungen';

  @override
  String get edCognitiveGifts => 'Kognitive Begabungen';

  @override
  String get edNaturalAbilities => 'Natürliche Lernfähigkeiten';

  @override
  String get edHiddenCapacities => 'Verborgene Fähigkeiten';

  @override
  String get edConcentration => 'Konzentrationsschwierigkeit';

  @override
  String get edBreakRisk => 'Risiko einer Bildungsunterbrechung';

  @override
  String get edDisciplineConsistency => 'Beständigkeit der Disziplin';

  @override
  String get edScholarshipLikelihood => 'Wahrscheinlichkeit eines Stipendiums';

  @override
  String get edCareerLinkTitle => 'Bildung → Karriereweg';

  @override
  String get edDirectionRec => 'Empfohlene Richtung';

  @override
  String get edIntegrationStrategy => 'Integrationsstrategie';

  @override
  String get edCareerLinkage => 'Karriereverknüpfung';

  @override
  String get edAlignedSubjects => 'Karriererelevante Fächer';

  @override
  String get edDegreeUtility => 'Nutzen des Abschlusses für die Karriere';

  @override
  String get edImprovementTitle => 'Dein Verbesserungsplan';

  @override
  String get edReliabilityTitle => 'Zuverlässigkeit der Vorhersage';

  @override
  String get edLayerD1 => 'Geburtschart (D1)';

  @override
  String get edLayerD4 => 'Formale Bildung (D4)';

  @override
  String get edLayerD9 => 'Navamsa (D9)';

  @override
  String get edLayerD24 => 'Vertieftes Lernen (D24)';

  @override
  String get edLayerD60 => 'Lernen aus früherem Leben (D60)';

  @override
  String get edLayerAmk => 'Fach-Karaka';

  @override
  String get edLayerMj => 'Merkur-Jupiter';

  @override
  String get edLayerDasha => 'Planetarisches Timing';

  @override
  String get edTopicSubjects => 'Beste Fächer für mich';

  @override
  String get edTopicDegree => 'Chancen auf einen Abschluss';

  @override
  String get edTopicAbroad => 'Auslandsstudium';

  @override
  String get edTopicExam => 'Prüfungsleistung';

  @override
  String get edTopicHabits => 'Lerngewohnheiten';

  @override
  String get edTopicCareerLink => 'Verbindung von Bildung und Karriere';

  @override
  String get edTopicTiming => 'Zeitfenster für Bildung';

  @override
  String get edTopicScholarship => 'Chancen auf ein Stipendium';

  @override
  String get hwTitle => 'Gesundheits- & Wellness-Analyse';

  @override
  String get hwSubtitle =>
      'KI-gestützter vedischer Gesundheits- & Wellness-Bericht';

  @override
  String get hwSnapshotHeader => 'Deine Gesundheitsübersicht';

  @override
  String get hwOverallVitality => 'Vitalität';

  @override
  String get hwImmunity => 'Immunität';

  @override
  String get hwRecovery => 'Erholung';

  @override
  String get hwMentalWellness => 'Mentales Wohlbefinden';

  @override
  String get hwStressTolerance => 'Stresstoleranz';

  @override
  String get hwStatusThriving => 'Aufblühend';

  @override
  String get hwStatusGood => 'Gute Vitalität';

  @override
  String get hwStatusBalanced => 'Ausgeglichen';

  @override
  String get hwStatusNeedsCare => 'Benötigt Fürsorge';

  @override
  String get hwStatusNeedsAttention => 'Benötigt Aufmerksamkeit';

  @override
  String get hwChipImmunity => 'Starke Immunität';

  @override
  String get hwChipRecovery => 'Schnelle Erholung';

  @override
  String get hwChipMentalBalance => 'Ausgeglichener Geist';

  @override
  String get hwChipStressResilience => 'Stressresistent';

  @override
  String get hwChipFertility => 'Unterstützung der Fruchtbarkeit';

  @override
  String get hwChipWorkLife => 'Gute Work-Life-Balance';

  @override
  String get hwChipLowAddiction => 'Geringes Suchtrisiko';

  @override
  String get hwConstitutionTitle => 'Dein Körpertyp';

  @override
  String get hwConstitutionSubtitle =>
      'Ayurvedische Konstitution aus deinem Chart';

  @override
  String get hwDominantDosha => 'Dominant';

  @override
  String get hwSecondaryDosha => 'Sekundär';

  @override
  String get hwPrimaryKaraka => 'Wichtigster Gesundheitsindikator';

  @override
  String get hwStrongestSystem => 'Stärkstes System';

  @override
  String get hwWeakestSystem => 'Zu unterstützendes System';

  @override
  String get hwBodyMapTitle => 'Die planetarische Karte deines Körpers';

  @override
  String get hwBodyMapSubtitle => '9 Planeten, 9 Körpersysteme';

  @override
  String get hwYogaTitle => 'Gesundheitsmuster in deinem Chart';

  @override
  String get hwYogaSubtitle => 'Schützende vs. krankheitsfördernde Yogas';

  @override
  String get hwDiseasePressureLabel => 'KRANKHEITSDRUCK';

  @override
  String get hwAreasTitle => 'Zu beobachtende Körperbereiche';

  @override
  String get hwAreasSubtitle => 'Anfälligkeit nach Körperzone';

  @override
  String get hwProtectedAreas => 'Gut geschützte Bereiche';

  @override
  String get hwCategoriesTitle => 'Übersicht der Krankheitskategorien';

  @override
  String get hwCategoriesSubtitle =>
      'Anfälligkeit in wichtigen Gesundheitskategorien';

  @override
  String get hwLowRiskCategories => 'Kategorien mit geringem Risiko';

  @override
  String get hwMentalTitle => 'Mentales & emotionales Wohlbefinden';

  @override
  String get hwMentalSubtitle =>
      'Emotionale Resilienz und Unterstützungsbedarf';

  @override
  String get hwMentalVulnerability => 'Emotionale Empfindlichkeit';

  @override
  String get hwEmotionalRegulation => 'Emotionale Regulation';

  @override
  String get hwSupportRec => 'Unterstützungsempfehlung';

  @override
  String get hwTendencies => 'Mentale Tendenzen';

  @override
  String get hwTimelineTitle => 'Gesundheits-Zeitlinie';

  @override
  String get hwTimelineSubtitle =>
      'Höhepunktjahre, Vorsichtsjahre & Erholungsfenster';

  @override
  String get hwPeakYears => 'Jahre des Wellness-Höhepunkts';

  @override
  String get hwCautionYears => 'Vorsichtsjahre';

  @override
  String get hwRecoveryWindow => 'Erholungsfenster';

  @override
  String get hwCheckupYears => 'Empfohlene Jahre für Vorsorgeuntersuchungen';

  @override
  String get hwCurrentPhase => 'Aktuelle Phase';

  @override
  String get hwLifestyleTitle => 'Dein Lebensstil-Leitfaden';

  @override
  String get hwLifestyleSubtitle =>
      'Was dein Chart über tägliche Gewohnheiten sagt';

  @override
  String get hwSleepDiscipline => 'Einfluss der Schlafdisziplin';

  @override
  String get hwDietDiscipline => 'Einfluss der Ernährungsdisziplin';

  @override
  String get hwExerciseNeed => 'Bewegungsbedarf';

  @override
  String get hwSunlightNeed => 'Sonnenlichtbedarf';

  @override
  String get hwStressSusceptibility => 'Stressanfälligkeit';

  @override
  String get hwHydrationSensitivity => 'Empfindlichkeit für Flüssigkeitszufuhr';

  @override
  String get hwSocialType => 'Sozialer Energietyp';

  @override
  String get hwHealingSpeed => 'Heilungsgeschwindigkeit';

  @override
  String get hwTreatmentResponse => 'Ansprechen auf Behandlung';

  @override
  String get hwAltHealing => 'Affinität zu alternativer Heilung';

  @override
  String get hwSpecialTitle => 'Lebensphasen & besondere Themen';

  @override
  String get hwSpecialSubtitle =>
      'Fruchtbarkeit, Kindergesundheit, Gewohnheiten & Burnout';

  @override
  String get hwFertility => 'Fruchtbarkeitsindikator';

  @override
  String get hwHormonalBalance => 'Hormonelle Balance';

  @override
  String get hwReproductiveStrength => 'Stärke des Fortpflanzungssystems';

  @override
  String get hwChildhoodVuln => 'Anfälligkeit der Kindergesundheit';

  @override
  String get hwChildhoodStatus => 'Kindergesundheit';

  @override
  String get hwAddictionVuln => 'Suchtanfälligkeit';

  @override
  String get hwAddictionRecovery => 'Erholungskapazität';

  @override
  String get hwBurnoutVuln => 'Burnout-Anfälligkeit';

  @override
  String get hwWorkLifeBalance => 'Work-Life-Balance';

  @override
  String get hwStressTriggers => 'Stressauslöser';

  @override
  String get hwProtectiveFactors => 'Schutzfaktoren';

  @override
  String get hwChallengesTitle => 'Zu beobachtende Herausforderungen';

  @override
  String get hwChallengesSubtitle =>
      'Worauf sich die Vorsorge konzentrieren sollte';

  @override
  String get hwMitigation => 'Wie man damit umgeht';

  @override
  String get hwChronicAreas => 'Bereiche chronischer Anfälligkeit';

  @override
  String get hwPreventivePriorities => 'Präventive Prioritäten';

  @override
  String get hwImprovementTitle => 'Dein Wellness-Plan';

  @override
  String get hwImprovementSubtitle =>
      'Praktische Schritte + traditionelle Heilmittel';

  @override
  String get hwReliabilityTitle => 'Zuverlässigkeit der Deutung';

  @override
  String get hwLayerD1 => 'Geburtschart (D1)';

  @override
  String get hwLayerD6 => 'Gesundheits-Chart (D6)';

  @override
  String get hwLayerD30 => 'Mikro-Gesundheits-Chart (D30)';

  @override
  String get hwLayerDasha => 'Planetarisches Timing';

  @override
  String get hwLayerTransit => 'Aktuelle Transite';

  @override
  String get hwDisclaimerLabel => 'Medizinischer Haftungsausschluss';

  @override
  String get hwTopicImmunity => 'Immunität stärken';

  @override
  String get hwTopicSleep => 'Schlaf & Erholung';

  @override
  String get hwTopicStress => 'Stress bewältigen';

  @override
  String get hwTopicFertility => 'Timing der Fruchtbarkeit';

  @override
  String get hwTopicDiet => 'Ernährung';

  @override
  String get hwTopicTiming => 'Zeitfenster für Gesundheit';

  @override
  String get hwTopicMental => 'Mentales Wohlbefinden';

  @override
  String get hwTopicPrevention => 'Präventionsplan';

  @override
  String get lvSubtitle => 'KI-gestützter vedischer Liebesbericht';

  @override
  String get lvTitle => 'Liebe & Beziehungen';

  @override
  String get lvLovePotential => 'Liebespotenzial';

  @override
  String get lvEmotionalAvail => 'Emotional offen';

  @override
  String get lvAttraction => 'Anziehung';

  @override
  String get lvCommitment => 'Bindung';

  @override
  String get lvCommunication => 'Kommunikation';

  @override
  String get lvFidelity => 'Loyalität';

  @override
  String get lvChipLoyal => 'Treues Herz';

  @override
  String get lvChipOpenHeart => 'Offenherzig';

  @override
  String get lvChipCommunicator => 'Großartiger Kommunikator';

  @override
  String get lvChipMature => 'Geht gut mit Konflikten um';

  @override
  String get lvChipEmotionallyWise => 'Emotional weise';

  @override
  String get lvLoveStyle => 'Dein Liebesstil';

  @override
  String get lvAttractionStyle => 'Anziehungsstil';

  @override
  String get lvLangGiven => 'So drückst du Liebe aus';

  @override
  String get lvLangReceived => 'So fühlst du dich geliebt';

  @override
  String get lvLovePlanets => 'Deine Liebes-Planeten';

  @override
  String get lvLoveKaraka => 'Liebe';

  @override
  String get lvEmotionKaraka => 'Emotion';

  @override
  String get lvPassionKaraka => 'Leidenschaft';

  @override
  String get lvPathToLove => 'Dein Weg zur Liebe';

  @override
  String get lvPathSub => 'Liebesheirat vs. arrangierte Ehe';

  @override
  String get lvLoveMarriage => 'Liebesheirat';

  @override
  String get lvArrangedMarriage => 'Arrangierte Ehe';

  @override
  String get lvParentalAccept => 'Elterliche Akzeptanz';

  @override
  String get lvInterCaste => 'Interkastentum / Interreligiös';

  @override
  String get lvIdealPartner => 'Dein idealer Partner';

  @override
  String get lvPersonality => 'Persönlichkeit';

  @override
  String get lvAppearance => 'Erscheinungsbild';

  @override
  String get lvIdealTraits => 'Ideale Eigenschaften';

  @override
  String get lvWhatMatters => 'Was am wichtigsten ist';

  @override
  String get lvDrawnTo => 'Fühlt sich hingezogen zu';

  @override
  String get lvDealbreakers => 'Ausschlusskriterien';

  @override
  String get lvYourAppeal => 'Deine Anziehungskraft';

  @override
  String get lvLoveStory => 'Deine Liebesgeschichte';

  @override
  String get lvLoveStorySub => 'Beziehungsmuster';

  @override
  String get lvFirstLove => 'Erste Liebe';

  @override
  String get lvRelationCount => 'Bedeutsame Bindungen';

  @override
  String get lvDuration => 'Typische Dauer';

  @override
  String get lvDepth => 'Emotionale Tiefe';

  @override
  String get lvDatingPattern => 'Dating-Muster';

  @override
  String get lvCommitIntimacy => 'Bindung & Intimität';

  @override
  String get lvCommitReady => 'Bindungsbereitschaft';

  @override
  String get lvIntimacyDrive => 'Intimitätsbedürfnis';

  @override
  String get lvSensuality => 'Sinnlichkeit';

  @override
  String get lvEmpathy => 'Empathie';

  @override
  String get lvCommitStyle => 'Bindungsstil';

  @override
  String get lvChemistry => 'Chemie-Stil';

  @override
  String get lvMakesCommit => 'Was dich bindet';

  @override
  String get lvMakesFlee => 'Was dich abschreckt';

  @override
  String get lvEmotional => 'Emotionale Intelligenz';

  @override
  String get lvEmotionalIQ => 'Emotionaler IQ';

  @override
  String get lvConflictStyle => 'Konfliktstil';

  @override
  String get lvTiming => 'Liebes-Timing';

  @override
  String get lvNewLove12 => 'Neue Liebe in 12 Monaten';

  @override
  String get lvEnergyNow => 'Energie jetzt';

  @override
  String get lvPhaseNow => 'Aktuelle Phase';

  @override
  String get lvPeakRomance => 'Jahre der romantischen Hochphase';

  @override
  String get lvNewLoveWindow => 'Fenster für neue Liebe';

  @override
  String get lvChallenges => 'Zu beobachtende Herausforderungen';

  @override
  String get lvRiskHeartbreak => 'Anfälligkeit für Herzschmerz';

  @override
  String get lvRiskSabotage => 'Selbstsabotage';

  @override
  String get lvRiskCommitFear => 'Bindungsangst';

  @override
  String get lvRiskRepeat => 'Wiederkehrende Muster';

  @override
  String get lvRiskWorkaholic => 'Arbeit über die Liebe stellen';

  @override
  String get lvRedFlags => 'Zu beobachtende Warnsignale';

  @override
  String get lvHealing => 'Was geheilt werden sollte';

  @override
  String get lvFocusArea => 'Fokusbereich';

  @override
  String get lvHealDir => 'Heilungsrichtung';

  @override
  String get lvImprovementPlan => 'Verbesserungsplan';

  @override
  String get lvReliability => 'Zuverlässigkeit der Vorhersage';

  @override
  String get lvLayerBirth => 'Geburtschart (D1)';

  @override
  String get lvLayerNavamsa => 'Navamsa (D9)';

  @override
  String get lvLayerSaptamsa => 'Saptamsa (D7)';

  @override
  String get lvLayerDasha => 'Dasha-Timing';

  @override
  String get lvLayerTransit => 'Aktuelle Transite';

  @override
  String get lvTopicWhen => 'Wann werde ich die Liebe finden?';

  @override
  String get lvTopicSoulmate => 'Über meinen Seelenverwandten';

  @override
  String get lvTopicCurrent => 'Meine aktuelle Beziehung';

  @override
  String get lvTopicHeal => 'Heilung von der Vergangenheit';

  @override
  String get lvTopicCommit => 'Hilfe bei der Bindung';

  @override
  String get lvTopicLoveVsArranged => 'Liebesheirat vs. arrangierte Ehe';

  @override
  String get lvTopicHeartbreak => 'Herzschmerz vermeiden';

  @override
  String get lvTopicConfidence => 'Selbstvertrauen in der Liebe';

  @override
  String get mrSubtitle => 'KI-gestützter vedischer Ehebericht';

  @override
  String get mrTitle => 'Ehe & Familie';

  @override
  String get mrMarriagePotential => 'Ehepotenzial';

  @override
  String get mrHarmony => 'Harmonie';

  @override
  String get mrLongevity => 'Beständigkeit';

  @override
  String get mrSatisfaction => 'Zufriedenheit';

  @override
  String get mrStability => 'Häusliche Stabilität';

  @override
  String get mrClarity => 'Klarheit';

  @override
  String get mrChipHarmony => 'Harmonische Bindung';

  @override
  String get mrChipNoMangal => 'Kein Mangal Dosh';

  @override
  String get mrChipLongLasting => 'Von Dauer';

  @override
  String get mrChipHome => 'Eigenes Zuhause wahrscheinlich';

  @override
  String get mrChipInLaws => 'Gute Schwiegerfamilie';

  @override
  String get mrChipChildren => 'Mit Kindern gesegnet';

  @override
  String get mrSpouse => 'Dein zukünftiger Ehepartner';

  @override
  String get mrSpouseSub => 'Was das Chart nahelegt';

  @override
  String get mrSpouseTraits => 'Wahrscheinliche Persönlichkeit';

  @override
  String get mrSpouseWork => 'Wahrscheinlicher Beruf';

  @override
  String get mrAgeDiff => 'Altersunterschied';

  @override
  String get mrCulture => 'Kulturelle Übereinstimmung';

  @override
  String get mrEducation => 'Bildung';

  @override
  String get mrFamilyBg => 'Familiärer Hintergrund';

  @override
  String get mrSoulPartnership => 'Seele & Partnerschaft';

  @override
  String get mrSelfPlanet => 'Du in einer Bindung';

  @override
  String get mrSpousePlanet => 'Dein Ehepartner-Planet';

  @override
  String get mrSoulAlignment => 'Seelenausrichtung';

  @override
  String get mrAlignStrong =>
      'Deine Seele und dein idealer Partner sind stark aufeinander abgestimmt — eine zutiefst erfüllende Bindung wird gut unterstützt.';

  @override
  String get mrAlignModerate =>
      'Deine Seele und dein idealer Partner sind mäßig aufeinander abgestimmt — eine erfüllende Bindung wächst durch bewussten Einsatz.';

  @override
  String get mrAlignLow =>
      'Deine Seele und die Partnerschaft benötigen bewusste Integration — wähle einen Partner, der wirklich zu deinen inneren Werten passt.';

  @override
  String get mrTechDarakaraka => 'Ehepartner-Planet (Darakaraka)';

  @override
  String get mrUpapada => 'Ehepunkt (Upapada)';

  @override
  String get mrUpapadaLord => 'Upapada-Herrscher';

  @override
  String get mrFoundation => 'Ehefundament';

  @override
  String get mrMarriageSign => 'Ehezeichen';

  @override
  String get mrMarriageLord => 'Ehe-Herrscher';

  @override
  String get mrHouseStrength => 'Hausstärke';

  @override
  String get mrPartnerHint => 'Partnerhinweis aus deinem Chart';

  @override
  String get mrHarmonyHdr => 'Kompatibilitätsharmonie';

  @override
  String get mrHarmonySub => 'Wie ihr euch verbinden werdet';

  @override
  String get mrEmotional => 'Emotional';

  @override
  String get mrIntellectual => 'Intellektuell';

  @override
  String get mrPhysical => 'Körperliche Intimität';

  @override
  String get mrFinancial => 'Finanziell';

  @override
  String get mrCommunication => 'Kommunikation';

  @override
  String get mrSharedValues => 'Gemeinsame Werte';

  @override
  String get mrSpiritual => 'Spirituell';

  @override
  String get mrConflictRes => 'Konfliktlösung';

  @override
  String get mrTiming => 'Heirats-Timing';

  @override
  String get mrFirstMarriageAge => 'Wahrscheinliches Heiratsalter';

  @override
  String get mrDelayChance => 'Wahrscheinlichkeit einer Verzögerung';

  @override
  String get mrMarriageWindow => 'Heiratsfenster';

  @override
  String get mrSecondaryWindow => 'Alternatives Fenster';

  @override
  String get mrCurrentReadiness => 'Gerade jetzt';

  @override
  String get mrJourney => 'Eheliche Reise';

  @override
  String get mrJourneySub => 'Wie sich die Bindung entwickelt';

  @override
  String get mrPhaseEarly => 'Frühe Jahre';

  @override
  String get mrPhaseMid => 'Mittlere Jahre';

  @override
  String get mrPhaseMature => 'Reife Jahre';

  @override
  String get mrPhaseLate => 'Spätere Jahre';

  @override
  String get mrTip => 'Tipp';

  @override
  String get mrFamilyHome => 'Familie & Zuhause';

  @override
  String get mrInLaws => 'Beziehung zur Schwiegerfamilie';

  @override
  String get mrFamilyHarmony => 'Familienharmonie';

  @override
  String get mrHomeOwnership => 'Wohneigentum';

  @override
  String get mrDomesticPeace => 'Häuslicher Frieden';

  @override
  String get mrFertility => 'Fruchtbarkeit';

  @override
  String get mrParenting => 'Elternschaftsharmonie';

  @override
  String get mrChildren => 'Kinder';

  @override
  String get mrLikelyCount => 'Wahrscheinliche Anzahl';

  @override
  String get mrVerification => 'Chartübergreifende Bestätigung';

  @override
  String get mrD9 => 'Ehe-Chart (D9)';

  @override
  String get mrD10 => 'Karriere-Ehepartner-Chart (D10)';

  @override
  String get mrD60 => 'Karma-Chart (D60)';

  @override
  String get mrChallenges => 'Zu beobachtende Herausforderungen';

  @override
  String get mrMangalPresent =>
      'Mangal Dosh ist im Chart vorhanden — Heilmittel und Partnerabgleich sorgfältig prüfen.';

  @override
  String get mrMangalAbsent =>
      'Kein Mangal Dosh festgestellt — ein unterstützender Ehe-Indikator.';

  @override
  String get mrRiskConflict => 'Konflikt';

  @override
  String get mrRiskSeparation => 'Trennung';

  @override
  String get mrRiskDistance => 'Emotionale Distanz';

  @override
  String get mrRiskInfidelity => 'Untreue';

  @override
  String get mrRiskFinance => 'Geldstreitigkeiten';

  @override
  String get mrPartnerGuide => 'Partner-Leitfaden';

  @override
  String get mrPartnerGuideSub => 'Worauf zu achten ist';

  @override
  String get mrSeek => 'Achte auf';

  @override
  String get mrMatchingPriorities => 'Prioritäten bei der Partnerwahl';

  @override
  String get mrImprovementPlan => 'Verbesserungsplan';

  @override
  String get mrReliability => 'Zuverlässigkeit der Vorhersage';

  @override
  String get mrLayerBirth => 'Geburtschart (D1)';

  @override
  String get mrLayerNavamsa => 'Navamsa (D9)';

  @override
  String get mrLayerDashamsa => 'Dashamsa (D10)';

  @override
  String get mrLayerShashtiamsa => 'Karma (D60)';

  @override
  String get mrLayerDarakaraka => 'Ehepartner-Planet';

  @override
  String get mrTopicWhen => 'Wann werde ich heiraten?';

  @override
  String get mrTopicSpouse => 'Über meinen Ehepartner';

  @override
  String get mrTopicCompat => 'Kompatibilitätstipps';

  @override
  String get mrTopicDelay => 'Eheverzögerung';

  @override
  String get mrTopicMangal => 'Mangal Dosh';

  @override
  String get mrTopicChildren => 'Timing für Kinder';

  @override
  String get mrTopicInLaws => 'Beziehung zur Schwiegerfamilie';

  @override
  String get mrTopicHarmony => 'Harmonie aufbauen';

  @override
  String get wlSubtitle => 'KI-gestützter vedischer Vermögensbericht';

  @override
  String get wlTitle => 'Vermögen & Finanzen';

  @override
  String get wlWealthPotential => 'Vermögenspotenzial';

  @override
  String get wlAccumulation => 'Ansammlung';

  @override
  String get wlIncomeFlow => 'Einkommensfluss';

  @override
  String get wlRetention => 'Erhalt';

  @override
  String get wlSustainability => 'Nachhaltigkeit';

  @override
  String get wlSavings => 'Spardisziplin';

  @override
  String get wlChipSaver => 'Natürlicher Sparer';

  @override
  String get wlChipMultiIncome => 'Mehrere Einkommensquellen';

  @override
  String get wlChipStrongYogas => 'Vermögens-Yogas';

  @override
  String get wlChipLowDebt => 'Geringe Schulden';

  @override
  String get wlChipInheritance => 'Erbschaft wahrscheinlich';

  @override
  String get wlChipInvestor => 'Kluger Investor';

  @override
  String get wlWealthClass => 'Vermögensklasse';

  @override
  String get wlWealthType => 'Hauptvermögensart';

  @override
  String get wlPrimarySource => 'Primäres Einkommen';

  @override
  String get wlPeakAge => 'Alter des Vermögenshöhepunkts';

  @override
  String get wlBoosters => 'Was dein Vermögen fördert';

  @override
  String get wlBoostersSub => 'Starke Geldkombinationen';

  @override
  String get wlWealthImpact => 'Schub';

  @override
  String get wlDrains => 'Vermögensverluste';

  @override
  String get wlIncomeSources => 'Einkommensquellen';

  @override
  String get wlIncomeSourcesSub => 'Woher dein Geld kommt';

  @override
  String get wlPrimary => 'Primär';

  @override
  String get wlInvestment => 'Investitionsplan';

  @override
  String get wlInvestmentSub => 'Ideale Vermögensmischung';

  @override
  String get wlRiskAppetite => 'Risikobereitschaft';

  @override
  String get wlInvestStyle => 'Anlagestil';

  @override
  String get wlDrivenBy => 'Angetrieben von';

  @override
  String get wlMoneyPersonality => 'Geldpersönlichkeit';

  @override
  String get wlMoneyType => 'Geldtyp';

  @override
  String get wlSpending => 'Ausgabeverhalten';

  @override
  String get wlSavingsDiscipline => 'Spardisziplin';

  @override
  String get wlCharity => 'Neigung zur Wohltätigkeit';

  @override
  String get wlLuxury => 'Luxusausgaben';

  @override
  String get wlWindfalls => 'Glücksfälle & Chancen';

  @override
  String get wlWindfallsSub => 'Glücksbasiertes Geld';

  @override
  String get wlInheritanceChance => 'Erbschaft';

  @override
  String get wlSuddenGains => 'Plötzliche Gewinne';

  @override
  String get wlLottery => 'Lotterie / Spekulation';

  @override
  String get wlInsurance => 'Versicherungsansprüche';

  @override
  String get wlWindfallSource => 'Wahrscheinliche Glücksfallquelle';

  @override
  String get wlMoneyPlanets => 'Deine Geld-Planeten';

  @override
  String get wlPrimaryKaraka => 'Primärer Geldplanet';

  @override
  String get wlSecondaryKaraka => 'Sekundärer Geldplanet';

  @override
  String get wlTimeline => 'Vermögens-Zeitlinie';

  @override
  String get wlPeakYears => 'Höhepunktjahre';

  @override
  String get wlGoodPeriod => 'Wohlstandsphase';

  @override
  String get wlSuddenGainWindow => 'Fenster plötzlicher Gewinne';

  @override
  String get wlToughPeriod => 'Vorsichtsphase';

  @override
  String get wlDebtRisks => 'Schulden- & Geldrisiken';

  @override
  String get wlDebtChance => 'Wahrscheinlichkeit von Schulden';

  @override
  String get wlLoanBurden => 'Kreditlast';

  @override
  String get wlDrainSources => 'Achte auf';

  @override
  String get wlStrengthen => 'Was zu stärken ist';

  @override
  String get wlWeakestDriver => 'Schwächster Geldtreiber';

  @override
  String get wlHowToFix => 'Wie man es stärkt';

  @override
  String get wlImprovementPlan => 'Verbesserungsplan';

  @override
  String get wlReliability => 'Zuverlässigkeit der Vorhersage';

  @override
  String get wlLayerBirth => 'Vermögenshäuser (D1)';

  @override
  String get wlLayerHora => 'Hora-Chart (D2)';

  @override
  String get wlLayerNavamsa => 'Navamsa (D9)';

  @override
  String get wlLayerDasha => 'Dasha-Timing';

  @override
  String get wlLayerTransit => 'Aktuelle Transite';

  @override
  String get wlTopicGrow => 'Wie man Vermögen aufbaut';

  @override
  String get wlTopicInvest => 'Wo man investieren sollte';

  @override
  String get wlTopicDebt => 'Schuldenmanagement';

  @override
  String get wlTopicProperty => 'Immobilienkauf';

  @override
  String get wlTopicRetire => 'Ruhestandsplanung';

  @override
  String get wlTopicPassive => 'Passives Einkommen';

  @override
  String get wlTopicWindfall => 'Plötzliche Gewinne';

  @override
  String get wlTopicTiming => 'Bestes Geld-Timing';

  @override
  String get bzSubtitle => 'KI-gestützter vedischer Geschäftsbericht';

  @override
  String get bzTitle => 'Geschäft & Startup';

  @override
  String get bzBusinessPotential => 'Geschäftspotenzial';

  @override
  String get bzEntrepreneurship => 'Unternehmergeist';

  @override
  String get bzVenture => 'Unternehmenserfolg';

  @override
  String get bzWealth => 'Vermögen durch Geschäft';

  @override
  String get bzRiskAppetite => 'Risikobereitschaft';

  @override
  String get bzLongevity => 'Beständigkeit';

  @override
  String get bzChipWealthMagnet => 'Vermögensmagnet';

  @override
  String get bzChipMoneyYoga => 'Geld-Yoga';

  @override
  String get bzChipLeadership => 'Führungsstärke';

  @override
  String get bzChipPartnerFit => 'Großartige Partnerpassung';

  @override
  String get bzChipGains => 'Starke Gewinne';

  @override
  String get bzChipInvestor => 'Attraktiv für Investoren';

  @override
  String get bzChipFounder => 'Gründer-Mentalität';

  @override
  String get bzWhatsWorking => 'Was für dich funktioniert';

  @override
  String get bzWhatsWorkingSub => 'Deine geschäftlichen Begabungen';

  @override
  String get bzClassicYogas => 'Klassische Vermögenskombinationen';

  @override
  String get bzFounderType => 'Dein Gründertyp';

  @override
  String get bzSoulBusiness => 'Seele & Geschäftszweck';

  @override
  String get bzSoulPlanet => 'Dein Seelenantrieb';

  @override
  String get bzBusinessPlanet => 'Dein Geschäftssinn';

  @override
  String get bzDirectionStrength => 'Klarheit der Richtung';

  @override
  String get bzAlignStrong =>
      'Dein Seelenzweck und deine geschäftliche Ausrichtung sind stark aufeinander abgestimmt — ein Unternehmen aufzubauen fühlt sich natürlich und erfüllend an.';

  @override
  String get bzAlignModerate =>
      'Dein Seelenzweck und deine geschäftliche Ausrichtung sind mäßig aufeinander abgestimmt — ein Unternehmen funktioniert am besten, wenn es deine tieferen Werte widerspiegelt.';

  @override
  String get bzAlignLow =>
      'Dein Seelenzweck und deine geschäftliche Ausrichtung benötigen bewusste Abstimmung — wähle ein Unternehmen, das wirklich zu dir passt.';

  @override
  String get bzTechAtmakaraka => 'Seelenplanet (Atmakaraka)';

  @override
  String get bzTechAmatyakaraka => 'Geschäftsplanet (Amatyakaraka)';

  @override
  String get bzTechDarakaraka => 'Partnerplanet (Darakaraka)';

  @override
  String get bzFoundation => 'Geschäftsfundament';

  @override
  String get bzCareerHouse => 'Karrierehaus';

  @override
  String get bzGainsHouse => 'Gewinnhaus';

  @override
  String get bzLord => 'Herrscher';

  @override
  String get bzGainsPotential => 'Gewinnpotenzial';

  @override
  String get bzNetwork => 'Netzwerkstärke';

  @override
  String get bzRecovery => 'Erholungsstärke';

  @override
  String get bzVerification => 'Chartübergreifende Bestätigung';

  @override
  String get bzD10 => 'Karriere-Chart (D10)';

  @override
  String get bzD11 => 'Gewinn-Chart (D11)';

  @override
  String get bzD9 => 'Zweck-Chart (D9)';

  @override
  String get bzD60 => 'Karma-Chart (D60)';

  @override
  String get bzFounderSkills => 'Gründerfähigkeiten';

  @override
  String get bzSkillStrategy => 'Strategisches Denken';

  @override
  String get bzSkillExecution => 'Umsetzung';

  @override
  String get bzSkillPeople => 'Personalführung';

  @override
  String get bzSkillSales => 'Vertrieb & Überzeugungskraft';

  @override
  String get bzSkillFinance => 'Finanzgespür';

  @override
  String get bzSkillOps => 'Operative Disziplin';

  @override
  String get bzTopSkill => 'Top-Fähigkeit';

  @override
  String get bzDomains => 'Beste Geschäftsfelder';

  @override
  String get bzDomainsSub => 'Nach natürlicher Eignung geordnet';

  @override
  String get bzFit => 'PASSUNG';

  @override
  String get bzBusinessStyleHdr => 'Geschäftsstil';

  @override
  String get bzStyleService => 'Produkt vs. Dienstleistung';

  @override
  String get bzStyleMarket => 'Marktfokus';

  @override
  String get bzStyleTech => 'Tech-Ansatz';

  @override
  String get bzStyleLeadership => 'Führungsstil';

  @override
  String get bzStylePartnership => 'Alleine oder mit Partnerschaft';

  @override
  String get bzWhereBuild => 'Reichweite';

  @override
  String get bzExpansion => 'Expansion';

  @override
  String get bzSetup => 'Aufbau';

  @override
  String get bzPartnership => 'Partnerschaft & Team';

  @override
  String get bzIdealCofounder => 'Idealer Mitgründer';

  @override
  String get bzPartnerViability => 'Partnerschaftspassung';

  @override
  String get bzTeamBuilding => 'Teamaufbau';

  @override
  String get bzCofounderFit => 'Mitgründer-Passung';

  @override
  String get bzAdvisorNetwork => 'Berater-Netzwerk';

  @override
  String get bzFunding => 'Finanzierung & Geld';

  @override
  String get bzRecommendedPath => 'Empfohlener Finanzierungsweg';

  @override
  String get bzInvestorAttract => 'Attraktivität für Investoren';

  @override
  String get bzFamilyBacking => 'Familiäre Unterstützung';

  @override
  String get bzHybridViability => 'Mischung aus Job & Geschäft';

  @override
  String get bzFallback => 'Job als Absicherung';

  @override
  String get bzDebtStyle => 'Schuldenstil';

  @override
  String get bzTimeline => 'Geschäfts-Zeitlinie';

  @override
  String get bzCurrentPhase => 'Gerade jetzt';

  @override
  String get bzLaunchWindow => 'Startfenster';

  @override
  String get bzScaleWindow => 'Wachstumsfenster';

  @override
  String get bzPeakAge => 'Höhepunktjahre';

  @override
  String get bzChallenges => 'Zu beobachtende Herausforderungen';

  @override
  String get bzRiskFinancial => 'Finanzieller Verlust';

  @override
  String get bzRiskBurnout => 'Burnout';

  @override
  String get bzRiskTeam => 'Teamkonflikt';

  @override
  String get bzRiskLegal => 'Rechtliches / Regulatorisches';

  @override
  String get bzFinancialExp =>
      'Risiko von Geldverlust durch Überinvestition oder schlechtes Timing des Cashflows während eines Unternehmens.';

  @override
  String get bzFinancialFix =>
      'Halte eine Barreserve, starte schlank und validiere die Nachfrage, bevor du die Ausgaben skalierst.';

  @override
  String get bzBurnoutExp =>
      'Zu langes zu starkes Vorantreiben kann deine Energie und Konzentration erschöpfen.';

  @override
  String get bzBurnoutFix =>
      'Schütze deine Erholung, delegiere frühzeitig und plane große Vorstöße um unterstützende Phasen herum.';

  @override
  String get bzTeamExp =>
      'Reibung mit Mitgründern oder Mitarbeitern kann das Geschäft verlangsamen.';

  @override
  String get bzTeamFix =>
      'Lege klare Rollen und Erwartungen schriftlich fest und kommuniziere häufig.';

  @override
  String get bzLegalExp =>
      'Compliance-, Vertrags- oder regulatorische Probleme könnten Hindernisse schaffen.';

  @override
  String get bzLegalFix =>
      'Lass Verträge prüfen, halte die Unterlagen sauber und konsultiere frühzeitig Fachleute.';

  @override
  String get bzImprovementPlan => 'Verbesserungsplan';

  @override
  String get bzBestDirection => 'Beste Richtung';

  @override
  String get bzStrategy => 'Aufbaustrategie';

  @override
  String get bzTopFields => 'Top-Felder';

  @override
  String get bzEmploymentPath => 'Job vs. Geschäft';

  @override
  String get bzRoadmap => 'Wachstums-Fahrplan';

  @override
  String get bzRoadmapSub => 'Dein Unternehmensplan';

  @override
  String get bzReliability => 'Zuverlässigkeit der Vorhersage';

  @override
  String get bzLayerBirth => 'Geburtschart (D1)';

  @override
  String get bzLayerNavamsa => 'Navamsa (D9)';

  @override
  String get bzLayerDashamsa => 'Karriere (D10)';

  @override
  String get bzLayerLabhamsa => 'Gewinne (D11)';

  @override
  String get bzLayerShashtiamsa => 'Karma (D60)';

  @override
  String get bzTopicStart => 'Sollte ich jetzt anfangen?';

  @override
  String get bzTopicIdea => 'Beste Geschäftsidee';

  @override
  String get bzTopicPartner => 'Einen Mitgründer finden';

  @override
  String get bzTopicFunding => 'Wie finanziere ich es';

  @override
  String get bzTopicScale => 'Wann skalieren';

  @override
  String get bzTopicRisk => 'Risikomanagement';

  @override
  String get bzTopicJob => 'Job vs. Geschäft';

  @override
  String get bzTopicTiming => 'Bestes Timing';

  @override
  String get crTitle => 'Karriere- & Berufsanalyse';

  @override
  String get crSubtitle => 'KI-gestützter vedischer Karrierebericht';

  @override
  String get crCrumbHome => 'Startseite';

  @override
  String get crCrumbReports => 'Berichte';

  @override
  String get crCareerPotential => 'Karrierepotenzial';

  @override
  String get crStatusStrong => 'Starkes Potenzial';

  @override
  String get crStatusGood => 'Gutes Potenzial';

  @override
  String get crStatusModerate => 'Mäßiges Potenzial';

  @override
  String get crStatusDeveloping => 'Entwicklungspotenzial';

  @override
  String get crStatusChallenging => 'Herausfordernde Phase';

  @override
  String get crOverallCareer => 'Karriere insgesamt';

  @override
  String get crStability => 'Karrierestabilität';

  @override
  String get crGrowth => 'Wachstumspotenzial';

  @override
  String get crRecognition => 'Anerkennung';

  @override
  String get crSatisfaction => 'Zufriedenheit';

  @override
  String get crChipLeadership => 'Führung';

  @override
  String get crChipCreativity => 'Kreativität';

  @override
  String get crChipBusiness => 'Geschäft';

  @override
  String get crChipStableIncome => 'Stabiles Einkommen';

  @override
  String get crChipLearning => 'Lernen';

  @override
  String get crChipGrowth => 'Langfristiges Wachstum';

  @override
  String get crChipTechnical => 'Technische Fähigkeit';

  @override
  String get crChipRecognition => 'Anerkennung';

  @override
  String get crTopInsights => 'Wichtigste Erkenntnisse';

  @override
  String get crWhatDefines => 'Was definiert deine Karriere?';

  @override
  String get crSoulCareer => 'Seele & Karrierezweck';

  @override
  String get crSoulPlanet => 'Planet des Lebenszwecks';

  @override
  String get crCareerPlanet => 'Karriereplanet';

  @override
  String get crMeaning => 'Bedeutung';

  @override
  String get crAlignment => 'Ausrichtung Seele ↔ Karriere';

  @override
  String get crAlignStrong =>
      'Deine natürlichen Interessen und dein Karriereweg sind stark aufeinander abgestimmt.';

  @override
  String get crAlignModerate =>
      'Deine natürlichen Interessen und dein Karriereweg sind mäßig aufeinander abgestimmt.';

  @override
  String get crAlignLow =>
      'Deine natürlichen Interessen und dein Karriereweg benötigen bewusste Abstimmung.';

  @override
  String get crTechAtmakaraka => 'Atmakaraka (Seelenindikator)';

  @override
  String get crTechAmatyakaraka => 'Amatyakaraka (Karriereindikator)';

  @override
  String get crDegrees => 'Grade';

  @override
  String get crDignity => 'Würde';

  @override
  String get crFoundation => 'Karrierefundament';

  @override
  String get crCareerSign => 'Karrierezeichen';

  @override
  String get crCareerLord => 'Karriereherrscher';

  @override
  String get crLordPosition => 'Position des Herrschers';

  @override
  String get crCareerStrength => 'Karrierestärke';

  @override
  String get crProfStyle => 'Beruflicher Stil';

  @override
  String get crBestFields => 'Beste Felder';

  @override
  String get crTechnicalDetails => 'Technische Details';

  @override
  String get crHouseLabel => 'Haus';

  @override
  String get crVerification => 'Karrierebestätigung über die Charts';

  @override
  String get crD10Career => 'D10 · Karriere';

  @override
  String get crD9Purpose => 'D9 · Zweck';

  @override
  String get crD60Karma => 'D60 · Karma';

  @override
  String get crStatusNeedsImprovement => 'Benötigt Verbesserung';

  @override
  String get crStatusWellAligned => 'Gut ausgerichtet';

  @override
  String get crStatusStrongSupport => 'Starke Unterstützung';

  @override
  String get crStatusModerateSupport => 'Mäßige Unterstützung';

  @override
  String get crChartDetails => 'Technische Chart-Details';

  @override
  String get crPersonality => 'Deine Karriere-Persönlichkeit';

  @override
  String get crGrowthAreas => 'Wachstumsbereiche';

  @override
  String get crBestRoles => 'Beste Rollen';

  @override
  String get crBestIndustries => 'Beste Branchen';

  @override
  String get crEnvironment => 'Karriereumfeld';

  @override
  String get crWorkStyle => 'Bester Arbeitsstil';

  @override
  String get crEmployment => 'Anstellung';

  @override
  String get crBusiness => 'Geschäft';

  @override
  String get crFreelance => 'Freiberuflich / Beratung';

  @override
  String get crPortfolio => 'Gemischtes Portfolio';

  @override
  String get crLeadership => 'Führung';

  @override
  String get crFit => 'Passung';

  @override
  String get crBestFit => 'Beste Passung';

  @override
  String get crTimeline => 'Karriere-Zeitlinie';

  @override
  String get crPastPeak => 'Vergangener Höhepunkt';

  @override
  String get crPresentPhase => 'Aktuelle Phase';

  @override
  String get crUpcoming => 'Bevorstehende Gelegenheit';

  @override
  String get crFutureExpansion => 'Zukünftige Expansion';

  @override
  String get crRiskPeriod => 'Risikoperiode';

  @override
  String get crViewDasha => 'Planetarische Periode (technisch)';

  @override
  String get crChallenges => 'Zu beobachtende Herausforderungen';

  @override
  String get crRiskBurnout => 'Burnout';

  @override
  String get crRiskRecognition => 'Verzögerte Anerkennung';

  @override
  String get crRiskConflict => 'Konflikt am Arbeitsplatz';

  @override
  String get crRiskFinancial => 'Finanzielle Instabilität';

  @override
  String get crRiskOverqual => 'Unterforderung';

  @override
  String get crPrevention => 'Prävention';

  @override
  String get crBurnoutExp =>
      'Lange, anspruchsvolle Phasen können deine Energie mit der Zeit erschöpfen.';

  @override
  String get crBurnoutFix =>
      'Schütze deine Erholung, setze Grenzen und plane große Vorstöße mit Bedacht.';

  @override
  String get crRecognitionExp =>
      'Belohnungen und Anerkennung kommen möglicherweise langsamer als dein Einsatz.';

  @override
  String get crRecognitionFix =>
      'Dokumentiere Erfolge und mache deine Beiträge für Vorgesetzte sichtbar.';

  @override
  String get crConflictExp =>
      'Reibung mit Kollegen oder Autoritäten kann gelegentlich auftreten.';

  @override
  String get crConflictFix =>
      'Kommuniziere ruhig und wähle deine Kämpfe mit Bedacht.';

  @override
  String get crFinancialExp =>
      'Das Einkommen kann sich in bestimmten Phasen ungleichmäßig anfühlen.';

  @override
  String get crFinancialFix =>
      'Halte einen Puffer und vermeide finanzielle Überverpflichtungen.';

  @override
  String get crOverqualExp =>
      'Du fühlst dich manchmal möglicherweise unterfordert oder wenig gefordert.';

  @override
  String get crOverqualFix =>
      'Suche nach anspruchsvollen Rollen und lerne weiter, um engagiert zu bleiben.';

  @override
  String get crImprovementPlan => 'Karriere-Verbesserungsplan';

  @override
  String get crCatPlanetary => 'Planetarisch & Spirituell';

  @override
  String get crCatPractical => 'Praktische Schritte';

  @override
  String get crTraditionalExplain => 'Traditionelle astrologische Erklärung';

  @override
  String get crActionPlan => '30-Tage-Karriere-Aktionsplan';

  @override
  String get crWeek1 => 'Woche 1 · Profiloptimierung';

  @override
  String get crWeek2 => 'Woche 2 · Kompetenzaufbau';

  @override
  String get crWeek3 => 'Woche 3 · Networking';

  @override
  String get crWeek4 => 'Woche 4 · Karrieresichtbarkeit';

  @override
  String get crWeek1Tip =>
      'Aktualisiere deinen Lebenslauf und dein LinkedIn-Profil rund um dein stärkstes Karrierethema.';

  @override
  String get crWeek2Tip =>
      'Wähle eine wertvolle Fähigkeit in deinem besten Feld und übe sie täglich.';

  @override
  String get crWeek3Tip =>
      'Nimm Kontakt zu Mentoren wieder auf und sprich zwei neue Branchenkontakte an.';

  @override
  String get crWeek4Tip =>
      'Teile deine Arbeit öffentlich und melde dich freiwillig für ein sichtbares Projekt.';

  @override
  String get crPriority => 'Priorität';

  @override
  String get crTimeRequired => 'Zeit';

  @override
  String get crExpectedBenefit => 'Nutzen';

  @override
  String get crPriorityHigh => 'Hoch';

  @override
  String get crPriorityMedium => 'Mittel';

  @override
  String get crRoadmap => 'KI-Karriere-Fahrplan';

  @override
  String get crNext12 => 'Nächste 12 Monate';

  @override
  String get crBestFocus => 'Bester Fokus';

  @override
  String get crSkillsLearn => 'Zu erlernende Fähigkeiten';

  @override
  String get crIndustriesTarget => 'Anzustrebende Branchen';

  @override
  String get crExpectedOutcome => 'Erwartetes Ergebnis';

  @override
  String get crReliability => 'Zuverlässigkeit der Vorhersage';

  @override
  String get crReliabilityHigh => 'Hohe Zuverlässigkeit';

  @override
  String get crReliabilityGood => 'Gute Zuverlässigkeit';

  @override
  String get crReliabilityModerate => 'Mäßige Zuverlässigkeit';

  @override
  String get crReliabilityExplain =>
      'Dieser Bericht kombiniert dein Geburtschart, Divisionscharts und Jaimini-Indikatoren. Der Score spiegelt wider, wie stark diese Chart-Ebenen übereinstimmen.';

  @override
  String get crChartLayers => 'Chart-Ebenen & Gewichtungen';

  @override
  String get crBirthChart => 'Geburtschart (D1)';

  @override
  String get crNavamsa => 'Navamsa (D9)';

  @override
  String get crDashamsa => 'Dashamsa (D10)';

  @override
  String get crShashtiamsa => 'Shashtiamsa (D60)';

  @override
  String get crDiscussAi => 'Mit KI besprechen';

  @override
  String get crAskAbout => 'Fragen zu';

  @override
  String get crTopicChange => 'Karrierewechsel';

  @override
  String get crTopicGovt => 'Regierungsjob';

  @override
  String get crTopicBusiness => 'Geschäft';

  @override
  String get crTopicPromotion => 'Beförderung';

  @override
  String get crTopicMarriage => 'Ehe vs. Karriere';

  @override
  String get crTopicAbroad => 'Ausland';

  @override
  String get crTopicIncome => 'Einkommen';

  @override
  String get crTopicPurpose => 'Zweck';

  @override
  String get crTopicResume => 'Lebenslauf';

  @override
  String get crTopicCopied => 'Frage kopiert — füge sie in deinen KI-Chat ein.';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return '$soul leitet deine innere Berufung, während $career deinen äußeren Beruf formt.';
  }

  @override
  String get rzTodayOutlook => 'Heutiger Tierkreis-Ausblick';

  @override
  String get rzPlanetaryEnergy => 'Heutige planetarische Energie';

  @override
  String get rzBestSign => 'Bestes Zeichen';

  @override
  String get rzChallengingSign => 'Am herausforderndsten';

  @override
  String get rzDominantPlanet => 'Dominanter Planet';

  @override
  String get rzOverallMood => 'Allgemeine Stimmung';

  @override
  String get rzMoodBright => 'Hell & Aktiv';

  @override
  String get rzMoodCalm => 'Ruhig & Stetig';

  @override
  String get rzMoodMixed => 'Gemischte Energie';

  @override
  String get rzMoodTense => 'Angespannt & Vorsichtig';

  @override
  String get rzTodayEnergy => 'Heutige Energie';

  @override
  String get rzCaution => 'Vorsicht';

  @override
  String get rzWeak => 'Schwach';

  @override
  String get rzAllSigns => 'Alle Tierkreiszeichen';

  @override
  String get rzAiSummary => 'KI-Zusammenfassung';

  @override
  String get rzPlanetaryInfluence => 'Heutiger planetarischer Einfluss';

  @override
  String get rzStrongInfluences => 'Starke Einflüsse';

  @override
  String get rzShowTechnical => 'Technische Details anzeigen';

  @override
  String get rzOpportunities => 'Heutige Chancen';

  @override
  String get rzAvoidTitle => 'Dinge, die heute zu vermeiden sind';

  @override
  String get rzTechnicalReason => 'Technischer Grund';

  @override
  String get rzAvoidDecisions => 'Wichtige Entscheidungen überstürzen';

  @override
  String get rzAvoidArguments => 'Hitzige Streitigkeiten';

  @override
  String get rzAvoidInvestments => 'Große Investitionen';

  @override
  String get rzAvoidOverthink => 'Über kleine Probleme zu viel nachdenken';

  @override
  String get rzAvoidOverspend => 'Unnötige Ausgaben';

  @override
  String get rzAvoidStress => 'Stress und Überarbeitung';

  @override
  String get rzPlanetaryChart => 'Heutiges planetarisches Chart';

  @override
  String get rzWhatChartMeans => 'Was dieses Chart bedeutet';

  @override
  String get rzChartExplain =>
      'Dieser Diamant zeigt, wo sich jeder Planet heute am Himmel befindet, zugeordnet zu deinem Zeichen. Planeten in unterstützenden Häusern heben den Tag; solche in schwierigen Häusern verlangen Achtsamkeit.';

  @override
  String get rzDoNetworking => 'Networking & Kontakte knüpfen';

  @override
  String get rzDoLearning => 'Etwas Neues lernen';

  @override
  String get rzDoMeditation => 'Meditation & Ruhe';

  @override
  String get rzDoFamily => 'Zeit mit der Familie';

  @override
  String get rzDoCreative => 'Kreative Arbeit';

  @override
  String get rzDoRest => 'Erholung & Selbstfürsorge';

  @override
  String get rzAiRecommendations => 'Heutige KI-Empfehlungen';

  @override
  String get rzTechnical => 'Technische Astrologie';

  @override
  String get rzTransitScore => 'Transit-Score';

  @override
  String get rzVedha => 'Vedha (Hindernisse)';

  @override
  String get rzGocharDetails => 'Gochar-Details';

  @override
  String get rzAdvancedOnly => 'Für fortgeschrittene Nutzer';

  @override
  String get rzTomorrow => 'Vorschau auf morgen';

  @override
  String get rzTomorrowEnergy => 'Morgige Energie';

  @override
  String get rzImproving => 'Verbessernd';

  @override
  String get rzWeaker => 'Etwas schwächer';

  @override
  String get rzSteady => 'Stetig';

  @override
  String get rzTomorrowUpLine =>
      'Die Energie wird voraussichtlich morgen steigen — plane wichtige Aufgaben im Voraus.';

  @override
  String get rzTomorrowDownLine =>
      'Die Energie könnte morgen etwas nachlassen — halte den Tag leicht und ruhig.';

  @override
  String get rzTomorrowFlatLine =>
      'Die Energie bleibt morgen stetig — ein ruhiger, ausgeglichener Tag steht bevor.';

  @override
  String get rzWeeklyTrend => 'Wöchentlicher Trend';

  @override
  String get rzMonthlyTrend => 'Monatlicher Trend';

  @override
  String get rzBestDayWeek => 'Bester Tag';

  @override
  String get rzHardestDay => 'Schwierigster Tag';

  @override
  String get rzLuckyToday => 'Heute Glück';

  @override
  String get rzKarakaSun => 'Selbstvertrauen & Vitalität';

  @override
  String get rzKarakaMoon => 'Emotionen & innerer Frieden';

  @override
  String get rzKarakaMars => 'Energie & Antrieb';

  @override
  String get rzKarakaMercury => 'Kommunikation & Lernen';

  @override
  String get rzKarakaJupiter => 'Weisheit & Wachstum';

  @override
  String get rzKarakaVenus => 'Beziehungen & Komfort';

  @override
  String get rzKarakaSaturn => 'Disziplin & Geduld';

  @override
  String get rzKarakaRahu => 'Ehrgeiz & Veränderung';

  @override
  String get rzKarakaKetu => 'Spiritualität & Loslassen';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '$dom bestimmt den Ton des Tages, während $chal um Geduld und Achtsamkeit bittet.';
  }

  @override
  String rzInsightGood(Object karaka) {
    return 'Guter Tag für $karaka.';
  }

  @override
  String rzInsightHard(Object karaka) {
    return 'Geh es heute langsam an bei $karaka.';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return '$karaka wird heute gut unterstützt.';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return '$karaka könnte heute auf Verzögerungen stoßen.';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return 'Heute unterstützt $strong, während $weak Geduld und Achtsamkeit braucht.';
  }

  @override
  String get fdEnergyScore => 'Heutiger Energie-Score';

  @override
  String get fdStatusAverage => 'Durchschnittlich';

  @override
  String get fdStatusMixed => 'Gemischt';

  @override
  String get fdStatusChallenging => 'Herausfordernd';

  @override
  String get fdTheme => 'Heutiges Thema';

  @override
  String get fdExplainToday => 'Heute erklären';

  @override
  String get fdTodaysFocus => 'Heutiger Fokus';

  @override
  String get fdTopRecommendation => 'Top-Empfehlung';

  @override
  String get fdTopCaution => 'Wichtigste Vorsicht';

  @override
  String get fdReadingTime => 'Lesezeit';

  @override
  String get fdSeconds30 => '30 Sek.';

  @override
  String get fdCareer => 'Karriere';

  @override
  String get fdMoney => 'Geld';

  @override
  String get fdLove => 'Liebe';

  @override
  String get fdHealth => 'Gesundheit';

  @override
  String get fdTravel => 'Reisen';

  @override
  String get fdFamily => 'Familie';

  @override
  String get fdBestToDo => 'Beste Dinge, die man heute tun sollte';

  @override
  String get fdAvoidToday => 'Heute vermeiden';

  @override
  String get fdConfidenceLabel => 'Vertrauen';

  @override
  String get fdBestTime => 'Beste Zeit';

  @override
  String get fdRecommended => 'Empfohlen';

  @override
  String get fdReason => 'Grund';

  @override
  String get fdRisk => 'Risiko';

  @override
  String get fdRecommendation => 'Empfehlung';

  @override
  String get fdNoActions =>
      'Heute nichts Größeres zu forcieren — halte eine ruhige, stetige Routine.';

  @override
  String get fdNoCautions =>
      'Heute keine größeren Warnhinweise — mit normaler Achtsamkeit fortfahren.';

  @override
  String get fdHighlights => 'Heutige Höhepunkte';

  @override
  String get fdProbVeryHigh => 'Sehr hoch';

  @override
  String get fdProbHigh => 'Hoch';

  @override
  String get fdProbElevated => 'Erhöht';

  @override
  String get fdProbCaution => 'Vorsicht';

  @override
  String get fdWhatToDo => 'Was zu tun ist';

  @override
  String get fdLifeAreas => 'Lebensbereiche';

  @override
  String get fdTapDetails => 'Für Details tippen';

  @override
  String get fdArea1 => 'Selbst & Gesundheit';

  @override
  String get fdArea2 => 'Vermögen & Familie';

  @override
  String get fdArea3 => 'Kommunikation';

  @override
  String get fdArea4 => 'Zuhause & Komfort';

  @override
  String get fdArea5 => 'Kreativität & Romantik';

  @override
  String get fdArea6 => 'Arbeit & Pflichten';

  @override
  String get fdArea7 => 'Beziehungen';

  @override
  String get fdArea8 => 'Veränderung & Tiefe';

  @override
  String get fdArea9 => 'Glück & Reisen';

  @override
  String get fdArea10 => 'Karriere & Status';

  @override
  String get fdArea11 => 'Gewinne & Netzwerk';

  @override
  String get fdArea12 => 'Erholung & Spiritualität';

  @override
  String get fdTodaysMeaning => 'Heutige Bedeutung';

  @override
  String get fdGoodFor => 'Gut für';

  @override
  String get fdAvoid => 'Vermeiden';

  @override
  String get fdPlanetSupport => 'Planetenunterstützung';

  @override
  String get fdWhyPrediction => 'Warum diese Vorhersage?';

  @override
  String get fdAdvancedDetails => 'Erweiterte Details';

  @override
  String get fdAiRecommendation => 'KI-Empfehlung';

  @override
  String get fdOverallStatus => 'Gesamtstatus';

  @override
  String get fdNoPlanetTransit =>
      'Heute durchläuft kein wichtiger Planet diesen Bereich.';

  @override
  String get fdFinancialOutlook => 'Finanzieller Ausblick';

  @override
  String get fdIncomeProbability => 'Einkommenswahrscheinlichkeit';

  @override
  String get fdExpenseProbability => 'Ausgabenwahrscheinlichkeit';

  @override
  String get fdNetBalance => 'Finanzielles Nettosaldo';

  @override
  String get fdAvoidSpending => 'Ausgaben vermeiden';

  @override
  String get fdRelationshipOutlook => 'Beziehungsausblick';

  @override
  String get fdOverallScore => 'Gesamt-Score';

  @override
  String get fdPartner => 'Partner';

  @override
  String get fdRomance => 'Romantik';

  @override
  String get fdWorkplace => 'Arbeitsplatz';

  @override
  String get fdPublicImage => 'Öffentliches Image';

  @override
  String get fdBestActivity => 'Beste Aktivität';

  @override
  String get fdWeakArea => 'Schwacher Bereich';

  @override
  String get fdBiggestOpportunity => 'Größte Chance';

  @override
  String get fdBiggestRisk => 'Größtes Risiko';

  @override
  String get fdProbability => 'Wahrscheinlichkeit';

  @override
  String get fdProtection => 'Schutzratschlag';

  @override
  String get fdDescription => 'Beschreibung';

  @override
  String get fdBestTimeToday => 'Beste Zeit heute';

  @override
  String get fdAvoidDuring => 'Zu vermeiden während';

  @override
  String get fdPredictionConfidence => 'Vorhersagesicherheit';

  @override
  String get fdConfBasis => 'Die heutige Vorhersage kombiniert';

  @override
  String get fdConfNatal => 'Geburtschart';

  @override
  String get fdConfTransit => 'Aktueller Transit';

  @override
  String get fdConfDasha => 'Planetarische Perioden';

  @override
  String get fdConfStrength => 'Planetenstärke';

  @override
  String get fdConfHouse => 'Hausaktivierung';

  @override
  String get fdAskAi => 'KI fragen';

  @override
  String get fdAskAiSub =>
      'Tippe auf eine Frage, um die heutige Antwort zu erhalten';

  @override
  String get fdQ1 => 'Warum ist die Karriere heute langsam?';

  @override
  String get fdQ2 => 'Was ist die beste Zeit heute?';

  @override
  String get fdQ3 => 'Ist heute gut für Geldangelegenheiten?';

  @override
  String get fdQ4 => 'Ist heute gut zum Reisen?';

  @override
  String get fdQ5 => 'Was sollte ich heute vermeiden?';

  @override
  String get fdMoreSuggestions => 'Weitere Vorschläge';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return 'Heute eignet sich am besten für $top. $weak kann sich langsam anfühlen, vermeide dort größere Entscheidungen. Finanziell sieht der Tag $fin aus.';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return 'Deine Energie sammelt sich heute um $top — konzentriere dich darauf und gehe anderswo behutsam vor.';
  }

  @override
  String get gochToday => 'Heute';

  @override
  String get gochOverallScore => 'Gesamter Transit-Score';

  @override
  String get gochNeutral => 'Neutral';

  @override
  String get gochChallenging => 'Herausfordernd';

  @override
  String get gochTopPositive => 'Top-Positiv';

  @override
  String get gochTopChallenges => 'Top-Herausforderungen';

  @override
  String get gochFilterAll => 'Alle';

  @override
  String get gochFavorability => 'Günstigkeit';

  @override
  String get gochAlerts => 'Transit-Warnungen';

  @override
  String get gochAlertCritical => 'Kritisch';

  @override
  String get gochAlertWarning => 'Vorsicht';

  @override
  String get gochAlertOpportunity => 'Gelegenheit';

  @override
  String get gochAiFocus => 'Heutiger KI-Fokus';

  @override
  String get gochLifeScores => 'Lebensbereich-Scores';

  @override
  String get gochWhy => 'Warum?';

  @override
  String get gochCurrentTransits => 'Aktive Transite';

  @override
  String get gochDailyPlan => 'Dein Tagesplan';

  @override
  String get gochMorning => 'Morgen';

  @override
  String get gochAfternoon => 'Nachmittag';

  @override
  String get gochEvening => 'Abend';

  @override
  String get gochNight => 'Nacht';

  @override
  String get gochSmartReco => 'Intelligente Empfehlungen';

  @override
  String get gochExplain => 'Heutigen Transit erklären';

  @override
  String get gochDo => 'Tun';

  @override
  String get gochDont => 'Vermeiden';

  @override
  String get gochDoWork => 'Wichtige Arbeit angehen';

  @override
  String get gochDoMeditate => 'Meditieren und reflektieren';

  @override
  String get gochDoStart => 'Neue Pläne starten';

  @override
  String get gochDoFinish => 'Ausstehende Aufgaben erledigen';

  @override
  String get gochDontArgue => 'Streitigkeiten vermeiden';

  @override
  String get gochDontImpulsive => 'Impulsive Entscheidungen vermeiden';

  @override
  String get gochDontOverspend => 'Übermäßige Ausgaben vermeiden';

  @override
  String gochThemeGrowth(Object area) {
    return 'Ein Tag des Wachstums im Bereich $area — nutze ihn.';
  }

  @override
  String gochThemeChallenge(Object area) {
    return 'Bleib heute geduldig mit $area — geh es ruhig an.';
  }

  @override
  String gochPosLine(Object area) {
    return '$area wird gerade jetzt gut unterstützt.';
  }

  @override
  String gochChalLine(Object area) {
    return '$area braucht heute besondere Aufmerksamkeit.';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return 'Setze deine Energie heute für $a1 ein und geh behutsam mit $a2 um.';
  }

  @override
  String get divBeginner => 'Anfänger';

  @override
  String get divSearchHint => 'Suche: Karriere, Ehe, Bildung…';

  @override
  String get divSummaryTitle => 'Zusammenfassung der Divisionscharts';

  @override
  String get divTotalCharts => 'Charts insgesamt';

  @override
  String get divMostImportant => 'Am wichtigsten';

  @override
  String get divRecommendedForYou => 'Für dich empfohlen';

  @override
  String get divCatEssential => 'Wesentliche Charts';

  @override
  String get divCatPersonal => 'Persönliches Leben';

  @override
  String get divCatKnowledge => 'Wissens-Charts';

  @override
  String get divCatAdvanced => 'Erweiterte Charts';

  @override
  String get divGoalProperty => 'Immobilien';

  @override
  String get divGoalKarma => 'Karma';

  @override
  String get divBadgeHighlyRec => 'Sehr empfohlen';

  @override
  String get divBadgeRec => 'Empfohlen';

  @override
  String get divBadgeUseful => 'Nützlich';

  @override
  String get divBadgeOptional => 'Optional';

  @override
  String get divBadgeAdvOnly => 'Nur für Fortgeschrittene';

  @override
  String get divRecommendBest => 'Beste Charts empfehlen';

  @override
  String get divNoMatch => 'Keine Charts entsprechen deiner Suche';

  @override
  String get divLifeAreas => 'Lebensbereiche';

  @override
  String divAiUse(Object purpose) {
    return 'Nutze dieses Chart, um $purpose zu analysieren.';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return 'Deine Charts $c1 und $c2 sind besonders wichtig — beginne dort für die abgedeckten Bereiche und erkunde dann bei Bedarf den Rest.';
  }

  @override
  String divRecReasonHouse(Object house) {
    return 'Dein $house. Haus verdient einen genaueren Blick — dieses Chart zeigt es vertieft.';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '$planet ist ein wichtiger, aber geprüfter Planet — dieses Chart zeigt seinen tieferen Zustand.';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return 'Du befindest dich in der Mahadasha von $planet, daher ist dieses Chart gerade jetzt besonders zeitgemäß.';
  }

  @override
  String divRecSummary(Object c1) {
    return 'Basierend auf deinem Chart sollte $c1 deine höchste Priorität sein. Die folgenden Charts sind danach geordnet, wie relevant sie gerade für dich sind.';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return 'Öffne dieses Chart, wenn du $purpose studieren möchtest.';
  }

  @override
  String get yogaHelpful => 'Hilfreich';

  @override
  String get yogaInactive => 'Inaktiv';

  @override
  String get yogaTabMoney => 'Geld';

  @override
  String get yogaTabRare => 'Selten';

  @override
  String get yogaSummaryTitle => 'Yoga-Zusammenfassung';

  @override
  String get yogaActiveYogas => 'Aktive Yogas';

  @override
  String get yogaTotalYogas => 'Yogas insgesamt';

  @override
  String get yogaMostPowerful => 'Am stärksten';

  @override
  String get yogaFortuneRating => 'Gesamtglück';

  @override
  String get yogaBenefits => 'Vorteile';

  @override
  String get yogaSupportingPlanets => 'Unterstützende Planeten';

  @override
  String get yogaRanking => 'Top 5 stärkste Yogas';

  @override
  String get yogaExplain => 'Meine Yogas erklären';

  @override
  String get yogaExplainSubtitle => 'Wie deine Yogas dich unterstützen';

  @override
  String get yogaNoneActive => 'Noch keine aktiven Yogas';

  @override
  String get yogaNoneInCategory => 'Keine Yogas in dieser Kategorie';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return 'Dein Chart trägt $count aktive Yogas — unterstützende planetarische Kombinationen. Kombinationen mit $planets erzeugen besonders hilfreiche Einflüsse für Wachstum und Erfolg.';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '$name unterstützt $areas, und seine Vorteile wachsen, wenn seine Planeten in Dasha oder Transit aktiv sind.';
  }

  @override
  String get yogaAiGeneric =>
      'Dieses Yoga ist eine unterstützende Kombination in deinem Chart, die die zugehörigen Lebensbereiche stärkt.';

  @override
  String get yogaExplainReassure =>
      'Yogas sind die Lichtblicke deines Charts — hilfreiche planetarische Kombinationen, die zu deinen Gunsten wirken. Die stärkeren bringen dauerhafte Vorteile, besonders während der Perioden der Planeten, die sie bilden.';

  @override
  String get doshSevere => 'Schwerwiegend';

  @override
  String get doshVeryMild => 'Sehr mild';

  @override
  String get doshLow => 'Gering';

  @override
  String get doshHigh => 'Hoch';

  @override
  String get doshCritical => 'Kritisch';

  @override
  String get doshSummaryTitle => 'Dosha-Zusammenfassung';

  @override
  String get doshActiveDoshas => 'Aktive Doshas';

  @override
  String get doshTotalChecked => 'Insgesamt geprüft';

  @override
  String get doshOverallSeverity => 'Gesamtschweregrad';

  @override
  String get doshNoneActive => 'Keine aktiven Doshas — ein sauberes Chart!';

  @override
  String get doshCategory => 'Kategorie';

  @override
  String get doshConfidence => 'Konfidenz';

  @override
  String get doshWhyFormed => 'Warum dies entstand';

  @override
  String get doshAffectedAreas => 'Betroffene Bereiche';

  @override
  String get doshTimeline => 'Zeitlinie';

  @override
  String get doshDefinition => 'Definition';

  @override
  String get doshFormationRule => 'Bildungsregel';

  @override
  String get doshSupportingPlanets => 'Zugehöriger Planet';

  @override
  String get doshCancellation => 'Aufhebungs-Yogas';

  @override
  String get doshNoCancellation => 'Keine gefunden';

  @override
  String get doshAreaChildren => 'Kinder';

  @override
  String get doshAreaMind => 'Geist';

  @override
  String get remMantra => 'Mantra';

  @override
  String get remGemstone => 'Edelstein';

  @override
  String get remDonation => 'Spende';

  @override
  String get remTemple => 'Tempel';

  @override
  String get remFasting => 'Fasten';

  @override
  String get remLifestyle => 'Lebensstil';

  @override
  String get remLifestyleGeneric =>
      'Übe Dankbarkeit, Disziplin und Wohltätigkeit im Zusammenhang mit diesem Planeten und pflege gutes Verhalten.';

  @override
  String get doshExplain => 'Meine Doshas erklären';

  @override
  String get doshExplainSubtitle =>
      'Ein ruhiger, praktischer Blick auf deine Doshas';

  @override
  String get doshExplainReassure =>
      'Doshas sind häufig — fast jedes Chart hat einige. Sie beschreiben Tendenzen, kein festes Schicksal. Bewusstsein, gutes Verhalten und einfache Heilmittel verringern ihre praktische Wirkung, es besteht also kein Grund zur Sorge.';

  @override
  String get doshAiGeneric =>
      'Dieses Dosha beschreibt eine Tendenz in deinem Chart. Seine praktische Wirkung ist meist mild und kann mit Bewusstsein und einfachen Heilmitteln ausgeglichen werden.';

  @override
  String doshHeroSummary(Object active, Object total) {
    return 'Dein Chart zeigt $active aktive Doshas von $total geprüften. Die meisten sind mild und nur wenige benötigen Aufmerksamkeit. Mit Verständnis und einfachen Heilmitteln kann ihre praktische Wirkung gemildert werden.';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return 'Dieses Dosha beeinflusst hauptsächlich $areas. Während der Perioden von $planet kann sich seine Wirkung stärker anfühlen, und Heilmittel helfen, es auszugleichen.';
  }

  @override
  String doshTimelineLine(Object planet) {
    return 'Seine Wirkung ist am stärksten während der Mahadasha und Antardasha von $planet spürbar, sowie wenn $planet im Transit aktiv ist.';
  }

  @override
  String get sbLegendary => 'Legendär';

  @override
  String get sbSthana => 'Sthana Bala';

  @override
  String get sbDig => 'Dig Bala';

  @override
  String get sbKala => 'Kala Bala';

  @override
  String get sbChesta => 'Chesta Bala';

  @override
  String get sbNaisargika => 'Naisargika Bala';

  @override
  String get sbDrik => 'Drik Bala';

  @override
  String get sbSummary => 'Zusammenfassung der planetarischen Stärke';

  @override
  String get sbAverageStrength => 'Durchschnittliche Stärke';

  @override
  String get sbHighestRupa => 'Höchste Rupa';

  @override
  String get sbRupa => 'Rupa';

  @override
  String get sbRanking => 'Planeten-Rangliste';

  @override
  String get sbRequired => 'Erforderlich';

  @override
  String get sbExcess => 'Überschuss';

  @override
  String get sbDeficit => 'Defizit';

  @override
  String get sbTotalShadbala => 'Gesamt-Shadbala';

  @override
  String get sbExplain => 'Meine planetarische Stärke erklären';

  @override
  String get sbExplainSubtitle =>
      'Eine einfache Zusammenfassung der Stärke deiner Planeten';

  @override
  String get sbInfoTitle => 'Shadbala verstehen';

  @override
  String get sbQWhatIs => 'Was ist Shadbala?';

  @override
  String get sbQRupas => 'Was sind Rupas?';

  @override
  String get sbQHowCalc => 'Wie wird die Stärke berechnet?';

  @override
  String get sbQHowUse => 'Wie man dies nutzt';

  @override
  String get sbWhyStrong => 'Warum stark';

  @override
  String get sbWhyWeak => 'Warum schwach';

  @override
  String get sbDuringMahadasha => 'Während der Mahadasha';

  @override
  String get sbEffects => 'Auswirkungen';

  @override
  String get sbLifeAreas => 'Lebensbereiche';

  @override
  String get sbPlanetDetails => 'Planetendetails';

  @override
  String get sbBodyWhatIs =>
      'Shadbala („sechsfache Stärke“) misst, wie viel Kraft jeder Planet hat, um seine Ergebnisse zu liefern, indem sechs unabhängige Stärkequellen addiert werden.';

  @override
  String get sbBodyRupas =>
      'Die Stärke wird in Rupas gemessen (1 Rupa = 60 Virupas). Jeder Planet benötigt eine Mindest-Rupa-Stärke, um als stark zu gelten; mehr Rupas bedeuten, dass er seine Ergebnisse vollständiger liefert.';

  @override
  String get sbBodyHowCalc =>
      'Sechs Balas werden addiert: Sthana (positionell), Dig (richtungsbezogen), Kala (zeitlich), Chesta (bewegungsbezogen), Naisargika (natürlich) und Drik (aspektbezogen). Die Summe wird mit dem erforderlichen Mindestwert des Planeten verglichen, um einen Prozentsatz zu erhalten.';

  @override
  String get sbBodyHowUse =>
      'Ein Planet über 100% liefert seine Bedeutungen problemlos; unter 100% braucht er Unterstützung. Bevorzuge deine stärksten Planeten für wichtige Angelegenheiten und gib den schwächsten Heilmittel und Geduld.';

  @override
  String get sbRemedyStrong =>
      'Gut unterstützt — kein besonderes Heilmittel nötig; du kannst die Perioden dieses Planeten mit Zuversicht nutzen.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '$strongP ist dein stärkster Planet und bietet hervorragende Unterstützung für $strongTrait. $weakP ist der schwächste und profitiert am meisten von Heilmitteln.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '$planet hat $category Shadbala, sodass seine $karakatva entsprechend unterstützt werden.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return 'Am stärksten durch $bala ($rupa Rupas).';
  }

  @override
  String sbWeakLine(Object bala) {
    return 'Am schwächsten in $bala, was die Gesamtsumme senkt.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return 'Während der Mahadasha von $planet treten seine $karak in den Vordergrund.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'Mit starkem Shadbala werden $karak natürlich unterstützt.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'Mit mäßigem Shadbala benötigen $karak möglicherweise bewussten Einsatz.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return 'Stärke $planet durch sein Mantra, seinen Edelstein oder Wohltätigkeit und handle geduldig während seiner Perioden.';
  }

  @override
  String get bhOverview => 'Überblick';

  @override
  String get bhDetailed => 'Detailliert';

  @override
  String get bhavaHouses => 'Häuser';

  @override
  String get bhStrengthOverview => 'Überblick der Hausstärke';

  @override
  String get bhOverallAverage => 'Gesamtdurchschnitt der Häuser';

  @override
  String get bhStrongestHouse => 'Stärkstes Haus';

  @override
  String get bhWeakestHouse => 'Schwächstes Haus';

  @override
  String get bhBestArea => 'Bester Lebensbereich';

  @override
  String get bhNeedsAttention => 'Benötigt Aufmerksamkeit';

  @override
  String get bhSavContribution => 'SAV-Beitrag';

  @override
  String get bhLordCondition => 'Zustand des Hausherrn';

  @override
  String get bhBenefic => 'Wohltätiger Einfluss';

  @override
  String get bhMalefic => 'Schädlicher Einfluss';

  @override
  String get bhStrengthReasons => 'Warum dieser Score';

  @override
  String get bhGoodEffects => 'Positive Auswirkungen';

  @override
  String get bhChallenges => 'Herausforderungen';

  @override
  String get bhRemedies => 'Heilmittel';

  @override
  String get bhRanking => 'Haus-Rangliste';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'Meine Häuser erklären';

  @override
  String get bhExplainSubtitle =>
      'Eine einfache Zusammenfassung deiner 12 Häuser';

  @override
  String bhHeroSummary(
    Object s1,
    Object s2,
    Object strongArea,
    Object weakArea,
  ) {
    return 'Deine stärksten Häuser sind $s1 und $s2. $strongArea ist von Natur aus stark, während $weakArea mehr Einsatz benötigt.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'Sein Herr $lord ist als $relation platziert.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'Dieses Haus trägt $sav wohltätige Punkte (SAV); seine Bewohner und Aspekte formen den Rest des Scores.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'Wenn stark, unterstützt es $meaning.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'Wenn schwach, benötigt $meaning möglicherweise zusätzlichen Einsatz und Achtsamkeit.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'Stärke seinen Herrn $lord und ehre die Angelegenheiten dieses Hauses, um es zu heben.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'Dein $house ist $strengthWord. Es regiert $meaning.';
  }

  @override
  String get kunNavamsa => 'Navamsa (D9)';

  @override
  String get kunD10 => 'Dasamsa (D10)';

  @override
  String get kunPlacement => 'Planetenplatzierung';

  @override
  String get kunHousesTitle => 'Hausdetails';

  @override
  String get kunPlanet => 'Planet';

  @override
  String get kunNakshatra => 'Nakshatra';

  @override
  String get kunPada => 'Pada';

  @override
  String get kunLord => 'Herr';

  @override
  String get kunExplain => 'Mein Chart erklären';

  @override
  String get kunExplainSubtitle =>
      'Eine einfache Zusammenfassung deines Charts';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return 'Das $ordinal. Haus regiert $meaning.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return '$planets hier platziert formen seine Ergebnisse.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'Dein Aszendent ist $asc und formt deine Sichtweise sowie den ersten Eindruck, den andere von dir haben.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'Dein Geist und deine Emotionen folgen dem Mond in $moon.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '$planet ist dein stärkster Planet — ein natürlicher Bereich der Leichtigkeit und Unterstützung.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '$planet ist dein am meisten geprüfter Planet — Geduld und Einsatz zahlen sich hier aus.';
  }

  @override
  String get plNature => 'Natur';

  @override
  String get plElement => 'Element';

  @override
  String get plGender => 'Geschlecht';

  @override
  String get plKarakatva => 'Karakatva';

  @override
  String get plLordship => 'Herrschaft';

  @override
  String get plStrength => 'Stärke';

  @override
  String get plAspectsGiven => 'Gegebene Aspekte';

  @override
  String get plAspectsReceived => 'Empfangene Aspekte';

  @override
  String get plConjunction => 'Konjunktion';

  @override
  String get plHouseMeaning => 'Hausbedeutung';

  @override
  String get plNakshatraMeaning => 'Nakshatra-Bedeutung';

  @override
  String get plAiInterpretation => 'KI-Interpretation';

  @override
  String get plSearchHint => 'Beliebigen Planeten suchen';

  @override
  String get plNoResults => 'Keine Planeten gefunden';

  @override
  String get plBenefic => 'Wohltätig';

  @override
  String get plMalefic => 'Schädlich';

  @override
  String get plMale => 'Männlich';

  @override
  String get plFemale => 'Weiblich';

  @override
  String get plNeutralGender => 'Neutral';

  @override
  String get plOwnSign => 'Eigenes Zeichen';

  @override
  String get plFriend => 'Freundzeichen';

  @override
  String get plEnemy => 'Feindzeichen';

  @override
  String get plNeutral => 'Neutral';

  @override
  String get sumEther => 'Äther';

  @override
  String plLordOfHouses(Object houses) {
    return 'Herr des/der Hauses/Häuser $houses';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return 'Regiert von $nakLord, bringt $trait.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '$planet steht in $sign, im $house. Haus.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'Seine Kernbedeutungen — $karak — werden hier gut unterstützt.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'Seine Kernbedeutungen — $karak — benötigen hier möglicherweise bewussten Einsatz.';
  }

  @override
  String plAiExalted(Object planet) {
    return '$planet ist exaltiert und liefert seine besten Ergebnisse.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '$planet ist geschwächt (debilitiert) und benötigt Unterstützung, um seine Ergebnisse zu liefern.';
  }

  @override
  String plAiCombust(Object planet) {
    return '$planet ist kombust, daher wirkt er unter dem Glanz der Sonne weniger offen.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '$planet ist Vargottama — eine starke Platzierung, die sich im Navamsa wiederholt.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '$planet ist rückläufig und wendet seine Energie nach innen, wodurch sie sich verstärkt.';
  }

  @override
  String get plHouse1 => 'Selbst, Körper, Persönlichkeit und Vitalität';

  @override
  String get plHouse2 => 'Vermögen, Familie, Sprache und Nahrung';

  @override
  String get plHouse3 => 'Mut, Geschwister, Kommunikation und kurze Reisen';

  @override
  String get plHouse4 =>
      'Zuhause, Mutter, Komfort, Immobilien und inneren Frieden';

  @override
  String get plHouse5 =>
      'Kinder, Kreativität, Intelligenz, Romantik und frühere Verdienste';

  @override
  String get plHouse6 =>
      'Gesundheit, Feinde, Schulden, Dienst und tägliche Arbeit';

  @override
  String get plHouse7 => 'Ehe, Partnerschaften und Geschäftsbeziehungen';

  @override
  String get plHouse8 =>
      'Langlebigkeit, Transformation, Geheimnisse und Erbschaft';

  @override
  String get plHouse9 => 'Glück, Dharma, höhere Bildung, Guru und Vater';

  @override
  String get plHouse10 => 'Karriere, Status, Autorität und öffentliches Karma';

  @override
  String get plHouse11 =>
      'Gewinne, Einkommen, Freunde, Netzwerk und erfüllte Wünsche';

  @override
  String get plHouse12 =>
      'Verlust, Ausgaben, ferne Länder, Spiritualität und Befreiung';

  @override
  String get sumVeryStrong => 'Sehr stark';

  @override
  String get sumStrong => 'Stark';

  @override
  String get sumAverage => 'Durchschnittlich';

  @override
  String get sumWeak => 'Schwach';

  @override
  String get sumNeedsAttention => 'Benötigt Aufmerksamkeit';

  @override
  String get sumFire => 'Feuer';

  @override
  String get sumEarth => 'Erde';

  @override
  String get sumAir => 'Luft';

  @override
  String get sumWater => 'Wasser';

  @override
  String get sumMovable => 'Beweglich';

  @override
  String get sumFixed => 'Fest';

  @override
  String get sumDual => 'Doppelt';

  @override
  String get sumDirEast => 'Osten';

  @override
  String get sumDirWest => 'Westen';

  @override
  String get sumDirNorth => 'Norden';

  @override
  String get sumDirSouth => 'Süden';

  @override
  String get sumDirNE => 'Nordosten';

  @override
  String get sumDirNW => 'Nordwesten';

  @override
  String get sumDirSE => 'Südosten';

  @override
  String get sumDirSW => 'Südwesten';

  @override
  String get sumSnapshotTitle => 'Deine astrologische Übersicht';

  @override
  String get sumMahadasha => 'Mahadasha';

  @override
  String get sumAntardasha => 'Antardasha';

  @override
  String get sumNakshatra => 'Janma Nakshatra';

  @override
  String get sumElement => 'Element';

  @override
  String get sumModality => 'Modalität';

  @override
  String get sumLuckyDirection => 'Glücksrichtung';

  @override
  String get sumHighlights => 'Wichtige Höhepunkte';

  @override
  String get sumStrongPlanet => 'Stärkster Planet';

  @override
  String get sumWeakPlanet => 'Schwächster Planet';

  @override
  String get sumYogas => 'Yogas';

  @override
  String get sumDoshas => 'Doshas';

  @override
  String get sumRetrograde => 'Rückläufig';

  @override
  String get sumCombust => 'Kombust';

  @override
  String get sumExalted => 'Exaltiert';

  @override
  String get sumDebilitated => 'Geschwächt';

  @override
  String get sumVargottama => 'Vargottama';

  @override
  String get sumQuickInsights => 'Schnelle Einblicke';

  @override
  String get sumSpirituality => 'Spiritualität';

  @override
  String get sumTimezone => 'Zeitzone';

  @override
  String get sumAyanamsa => 'Ayanamsa';

  @override
  String get sumCalendarType => 'Kalender';

  @override
  String get sumCopied => 'In die Zwischenablage kopiert';

  @override
  String get sumNatureFire =>
      'Du hast eine mutige, energiegeladene und wegbereitende Natur, die von vorne führt.';

  @override
  String get sumNatureEarth =>
      'Du hast eine praktische, bodenständige und disziplinierte Natur, die dauerhafte Ergebnisse schafft.';

  @override
  String get sumNatureAir =>
      'Du hast eine neugierige, kommunikative und intellektuelle Natur, die von neuen Ideen lebt.';

  @override
  String get sumNatureWater =>
      'Du hast eine intuitive, emotionale und einfühlsame Natur mit tiefer innerer Sensibilität.';

  @override
  String get sumGradePhraseExcellent =>
      'Stark unterstützt — günstige Ergebnisse sind bei stetigem Einsatz wahrscheinlich.';

  @override
  String get sumGradePhraseGood =>
      'Gut unterstützt — im Allgemeinen positiv mit etwas Sorgfalt.';

  @override
  String get sumGradePhraseAverage =>
      'Gemischte Unterstützung — Ergebnisse hängen von Einsatz und Timing ab.';

  @override
  String get sumGradePhraseWeak =>
      'Benötigt Aufmerksamkeit — Geduld und Heilmittel helfen hier.';

  @override
  String get kDefCombust =>
      'Ein Planet, der zu nahe an der Sonne steht, sodass seine Energie „verbrannt“ und geschwächt wird.';

  @override
  String get kDefRetrograde =>
      'Ein Planet, der sich scheinbar rückwärts bewegt; seine Wirkungen wenden sich nach innen und verstärken sich.';

  @override
  String get kDefNakshatra =>
      'Eines der 27 Mondhäuser, durch die Mond und Planeten wandern.';

  @override
  String get kDefVargottama =>
      'Ein Planet im selben Zeichen sowohl im Geburtschart (D1) als auch im Navamsa (D9) — ein Zeichen von Stärke.';

  @override
  String get kDefOwnSign =>
      'Ein Planet, der in einem Zeichen steht, das er regiert, wo er sich zu Hause fühlt und stetige Ergebnisse liefert.';

  @override
  String get kDefExalted =>
      'Ein Planet in seinem Zeichen höchster Stärke, das seine besten Ergebnisse liefert.';

  @override
  String get kDefDebilitated =>
      'Ein Planet in seinem schwächsten Zeichen, in dem er Schwierigkeiten hat, Ergebnisse zu liefern.';

  @override
  String get kDefMooltrikona =>
      'Ein besonderer Teil des eigenen Zeichens eines Planeten, in dem er besonders mächtig ist.';

  @override
  String get kDefAscendant =>
      'Das Zeichen, das bei der Geburt am östlichen Horizont aufsteigt — das Lagna, das Fundament des Charts.';

  @override
  String get kDefMahadasha =>
      'Die große planetarische Periode, die einen langen Lebensabschnitt prägt.';

  @override
  String get kDefAntardasha =>
      'Eine Unterperiode innerhalb einer Mahadasha, die deren Ergebnisse feinabstimmt.';

  @override
  String get kDefPada =>
      'Eines der vier Viertel eines Nakshatras, das ein Planet einnimmt.';

  @override
  String get aspGivesAspectTo => 'Gibt Aspekt an';

  @override
  String get aspReceivesAspectFrom => 'Empfängt Aspekt von';

  @override
  String get aspInfluences => 'Beeinflusst';

  @override
  String get aspNoInfluence => 'Kein Einfluss';

  @override
  String get aspNoAspect => 'Kein Aspekt';

  @override
  String get aspPresent => 'Vorhanden';

  @override
  String get aspAbsent => 'Nicht vorhanden';

  @override
  String get aspNotPresent => 'Nicht vorhanden';

  @override
  String get aspSpecialAspect => 'Besonderer Aspekt';

  @override
  String get aspAspectWord => 'Aspekt';

  @override
  String get aspTotalGiven => 'Gegebene Aspekte';

  @override
  String get aspTotalReceived => 'Empfangene Aspekte';

  @override
  String get aspStrongestInfluence => 'Stärkster Einfluss';

  @override
  String get aspMedium => 'Mittel';

  @override
  String get aspAspectPresent => 'Aspekt vorhanden';

  @override
  String get aspReason => 'Grund';

  @override
  String get aspBoth => 'Beide';

  @override
  String get aspTargetHouse => 'Zielhaus';

  @override
  String get aspTargetSign => 'Zielzeichen';

  @override
  String get aspLagnaReceives => 'Lagna empfängt Aspekt von';

  @override
  String get aspNoAspectFrom => 'Kein Aspekt von';

  @override
  String get aspPlanetToPlanet => 'Planet zu Planet';

  @override
  String get aspSignToSign => 'Zeichen zu Zeichen';

  @override
  String get aspCombinedAspect => 'Kombinierter Aspekt';

  @override
  String get aspGrahaAspect => 'Graha-Aspekt';

  @override
  String get aspRashiAspect => 'Rashi-Aspekt';

  @override
  String get aspInfoTitle => 'Aspekte verstehen (Drishti)';

  @override
  String get aspQGraha => 'Was ist Graha Drishti?';

  @override
  String get aspQRashi => 'Was ist Rashi Drishti?';

  @override
  String get aspQDiff => 'Unterschied zwischen beiden';

  @override
  String get aspQPredict => 'Wie Aspekte die Vorhersage beeinflussen';

  @override
  String get aspGrahaBody =>
      'Graha Drishti ist der Aspekt, den ein Planet von seiner Position aus wirft. Jeder Planet aspektiert vollständig das 7. Haus/den 7. Planeten von sich aus (ein direkter Einfluss von Angesicht zu Angesicht). Zusätzlich aspektiert Mars das 4. und 8., Jupiter das 5. und 9., und Saturn das 3. und 10. Rahu und Ketu erhalten meist das 5., 7. und 9. Der Aspekt eines Planeten färbt den Planeten oder das Haus, auf das er fällt, mit seiner eigenen Natur.';

  @override
  String get aspRashiBody =>
      'Rashi Drishti ist ein Zeichen-zu-Zeichen-Aspekt aus der Jaimini-Astrologie, unabhängig davon, welche Planeten dort stehen. Bewegliche Zeichen aspektieren feste Zeichen (außer dem benachbarten), feste Zeichen aspektieren bewegliche Zeichen (außer dem benachbarten), und Doppelzeichen aspektieren die anderen Doppelzeichen. Es wird hauptsächlich in der Jaimini-Vorhersage und zur Beurteilung von Beziehungen zwischen Häusern verwendet.';

  @override
  String get aspDiffBody =>
      'Graha Drishti wird von einem Planeten geworfen und hängt davon ab, wo dieser Planet steht. Rashi Drishti gehört zum Zeichen selbst und gilt für alles, was darin platziert ist. Graha Drishti ist gerichtet (Planet A sieht Planet B), während Rashi Drishti meist gegenseitig zwischen den Zeichen ist. Wenn beide auf dasselbe Ziel zeigen, ist der Einfluss besonders stark.';

  @override
  String get aspPredictBody =>
      'Ein Aspekt zeigt, wo ein Planet seinen Einfluss über sein eigenes Haus hinaus ausdehnt. Ein wohltätiger Aspekt (Jupiter, Venus, gut platzierter Mond/Merkur) unterstützt und schützt das Ziel; ein schädlicher Aspekt (Saturn, Mars, Sonne, Rahu, Ketu) kann Druck ausüben, verzögern oder herausfordern. Zu lesen, welche Planeten ein Haus oder einen Planeten aspektieren, erklärt, warum Ergebnisse so erscheinen, wie sie es tun.';

  @override
  String get aspTraitSun => 'Autorität, Führung und Vitalität';

  @override
  String get aspTraitMoon => 'emotionale Tiefe, Komfort und Intuition';

  @override
  String get aspTraitMars => 'Energie, Mut und Antrieb';

  @override
  String get aspTraitMercury =>
      'Kommunikation, Intellekt und Anpassungsfähigkeit';

  @override
  String get aspTraitJupiter => 'Weisheit, Wachstum und Glück';

  @override
  String get aspTraitVenus => 'Liebe, Harmonie und Annehmlichkeiten';

  @override
  String get aspTraitSaturn =>
      'Disziplin, Verantwortung und geduldiger, manchmal verzögerter Erfolg';

  @override
  String get aspTraitRahu =>
      'Ehrgeiz, Intensität und unkonventionelle Wendungen';

  @override
  String get aspTraitKetu =>
      'Loslösung, Spiritualität und plötzliche Veränderung';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '$planet beeinflusst $targets. Dies kann $trait in die Bereiche bringen, die diese Planeten repräsentieren.';
  }

  @override
  String aspAiNone(Object planet) {
    return '$planet wirft hier keinen besonderen Aspekt auf einen anderen Planeten; sein Einfluss wirkt hauptsächlich durch sein eigenes Zeichen und Haus.';
  }

  @override
  String get avSummaryTitle => 'Ashtakavarga-Zusammenfassung';

  @override
  String get avOverallScore => 'Gesamter SAV-Score';

  @override
  String get avOverallRating => 'Gesamtbewertung';

  @override
  String get avStrongestSigns => 'Stärkste Zeichen';

  @override
  String get avWeakestSigns => 'Schwächste Zeichen';

  @override
  String get avScore => 'Score';

  @override
  String get avMeaning => 'Bedeutung';

  @override
  String get avGrid => 'Raster';

  @override
  String get avList => 'Liste';

  @override
  String get avOverallScoreShort => 'Gesamt-Score';

  @override
  String get avNatalSignScore => 'Score des Geburtszeichens';

  @override
  String get avBestSigns => 'Beste Zeichen';

  @override
  String get avWeakSigns => 'Schwache Zeichen';

  @override
  String get avAiInterpretation => 'KI-Interpretation';

  @override
  String get avVeryGood => 'Sehr gut';

  @override
  String get avVeryWeak => 'Sehr schwach';

  @override
  String get avTotalSav => 'Gesamt-SAV';

  @override
  String get avPlanetContributions => 'Planetenbeiträge';

  @override
  String get avFinance => 'Finanzen';

  @override
  String get avOverallStrength => 'Gesamtstärke';

  @override
  String get avWhatDoesThisMean => 'Was bedeutet das?';

  @override
  String get avSimple => 'Einfach';

  @override
  String get avAdvanced => 'Erweitert';

  @override
  String get avInfoTitle => 'Ashtakavarga verstehen';

  @override
  String get avStrong => 'Stark';

  @override
  String get avModerate => 'Mäßig';

  @override
  String get avQWhatIsAv => 'Was ist Ashtakavarga?';

  @override
  String get avQWhatIsSav => 'Was ist SAV?';

  @override
  String get avQWhatIsBav => 'Was ist BAV?';

  @override
  String get avQHowToRead => 'Wie man diese Scores liest';

  @override
  String get avQSavVsBav => 'SAV vs. BAV';

  @override
  String get avABody =>
      'Ashtakavarga ist ein punktebasiertes Stärkesystem in der vedischen Astrologie. Jeder Planet vergibt wohltätige Punkte (Bindus, auch Rekhas genannt) an die zwölf Zeichen basierend auf seiner Position. Mehr Punkte in einem Zeichen bedeuten, dass dieser Lebensbereich während damit verbundener planetarischer Perioden und Transite reibungslosere Unterstützung erhält.';

  @override
  String get avSavBody =>
      'SAV (Sarva Ashtakavarga) addiert die Punkte aller sieben Planeten für jedes Zeichen. Es liefert einen einzigen Stärke-Score pro Zeichen, sodass du schnell sehen kannst, welche Zeichen — und die Häuser, in die sie fallen — in deinem Chart am besten unterstützt werden.';

  @override
  String get avBavBody =>
      'BAV (Bhinna Ashtakavarga) zeigt die Punkte eines einzelnen Planeten über die zwölf Zeichen hinweg. Es zeigt dir, welche Zeichen ein bestimmter Planet am meisten unterstützt, was wichtig ist, wenn die Dasha oder der Transit dieses Planeten aktiv ist.';

  @override
  String get avHowToReadBody =>
      'Höhere Zahlen sind besser. Für SAV erzielt ein durchschnittliches Zeichen etwa 28 Punkte — über 30 ist stark und unter 25 benötigt Achtsamkeit. Für BAV reicht jedes Zeichen von 0 bis 8, wobei 4 der Durchschnitt ist. Bevorzuge deine stärksten Zeichen für wichtige Handlungen und bleibe geduldig und diszipliniert bei deinen schwächsten.';

  @override
  String get avSavVsBavBody =>
      'SAV ist die kombinierte Gesamtsumme aller Planeten und zeigt die Gesamtstärke eines Zeichens. BAV ist der Beitrag eines einzelnen Planeten und zeigt, welcher Planet dieses Zeichen unterstützt. Nutze SAV für das große Ganze und BAV, um zu verstehen, welcher Planet die Stärke eines Zeichens antreibt.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'Dein Chart ist am stärksten in $s1, $s2 und $s3. Diese Zeichen bieten bessere Unterstützung während planetarischer Perioden und Transite. $weak hat derzeit die geringste Unterstützung, daher helfen Geduld und Disziplin bei damit verbundenen Angelegenheiten.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '$planet wirkt am stärksten durch $s1 und $s2. Von $planet regierte Angelegenheiten tendieren dazu, sich zu verbessern, wenn diese Zeichen aktiviert werden.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'Deine stärksten Zeichen sind $s1 und $s2 — bevorzuge wichtige Anfänge, wenn Planeten sie durchqueren.';
  }

  @override
  String avInsightWeak(Object s1) {
    return '$s1 hat die geringste Unterstützung — gehe vorsichtig vor und vermeide Überengagement in seinen Angelegenheiten.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '$planet trägt die meisten Punkte, daher werden seine Bedeutungen in deinem Leben gut unterstützt.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '$planet trägt die wenigsten Punkte und profitiert am meisten von Heilmitteln und bewusstem Einsatz.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'Zeichen, die über deinem Durchschnitt von $avg Punkten liegen, liefern tendenziell reibungslosere, zuverlässigere Ergebnisse.';
  }

  @override
  String get fcKey => 'Schlüssel';

  @override
  String get fcActions => 'Maßnahmen';

  @override
  String get fcCautions => 'Vorsichtshinweise';

  @override
  String get fc12House => '12 Häuser';

  @override
  String get fcProbabilities => 'Wahrscheinlichkeiten';

  @override
  String get fcHousesCaps => 'HÄUSER';

  @override
  String get fcCritical => 'Kritisch';

  @override
  String get fcFlags => 'Kennzeichen';

  @override
  String get fcAnalysis => 'Analyse';

  @override
  String get fcConfidence => 'Konfidenz';

  @override
  String get fcQualityCaps => 'QUALITÄT';

  @override
  String get fcIncomeVs => 'Einkommen vs.';

  @override
  String get fcExpense => 'Ausgabe';

  @override
  String get fcFinance => 'FINANZEN';

  @override
  String get fcNetBalance => 'Nettosaldo';

  @override
  String get fcSignature => 'Signatur';

  @override
  String get fcBestTimeForIncome => 'Beste Zeit für Einkommen';

  @override
  String get fcExpenseCaution => 'Vorsicht bei Ausgaben';

  @override
  String get fcIncomeCaps => 'EINKOMMEN';

  @override
  String get fcExpenseCaps => 'AUSGABEN';

  @override
  String get fcRelationships => 'Beziehungen';

  @override
  String get fcAreasCaps => 'BEREICHE';

  @override
  String get fcBestForMeetings => 'Am besten für Treffen';

  @override
  String get fcOpportunitiesVs => 'Chancen vs.';

  @override
  String get fcRisks => 'Risiken';

  @override
  String get fcOutlook => 'AUSBLICK';

  @override
  String get fcAction => 'Maßnahme';

  @override
  String get fcProtect => 'Schützen';

  @override
  String get fcOpportunityCaps => 'CHANCE';

  @override
  String get fcRiskCaps => 'RISIKO';

  @override
  String get fcTopOpportunities => 'TOP-CHANCEN';

  @override
  String get fcTopRisks => 'TOP-RISIKEN';

  @override
  String get fcTiming => 'Timing';

  @override
  String get fcWindows => 'Zeitfenster';

  @override
  String get fcSlotsCaps => 'ZEITFENSTER';

  @override
  String get fcBestWindows => 'BESTE ZEITFENSTER';

  @override
  String get fcWorstWindows => 'SCHLECHTESTE ZEITFENSTER';

  @override
  String get fcAvoid => 'Vermeiden';

  @override
  String get fcHouse => 'Haus';

  @override
  String get fcFailed => 'Fehlgeschlagen';

  @override
  String get lifeCareer => 'Karriere';

  @override
  String get lifeHealth => 'Gesundheit';

  @override
  String get lifeWealth => 'Vermögen';

  @override
  String get lifeFamily => 'Familie';

  @override
  String get lifeMind => 'Geist';

  @override
  String get lifeEgo => 'Ego';

  @override
  String get lifeAggression => 'Aggression';

  @override
  String get lifeConflict => 'Konflikt';

  @override
  String get rashiElement => 'Element';

  @override
  String get rashiQuality => 'Qualität';

  @override
  String get rashiLuckyColor => 'Glücksfarbe';

  @override
  String get rashiLuckyDay => 'Glückstag';

  @override
  String get rashiLuckyNumber => 'Glückszahl';

  @override
  String get rashiGemstone => 'Edelstein';

  @override
  String get rashiBody => 'Körper';

  @override
  String get gocharTodaysTransitChart => 'Heutiges Transit-Chart';

  @override
  String get gocharTransit => 'Transit';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get thisMonth => 'Dieser Monat';

  @override
  String get best => 'Beste';

  @override
  String get worst => 'Schlechteste';

  @override
  String get avg => 'Durchschn.';

  @override
  String get favorableLoveWindowsLabel => 'Günstige Liebesfenster';

  @override
  String get lordLabel => 'Herr';

  @override
  String get lordPlacementLabel => 'Platzierung des Herrn';

  @override
  String get lordDignityLabel => 'Würde des Herrn';

  @override
  String get categoriesSuffix => 'Kategorien';

  @override
  String get coreBlockerLabel => 'KERNBLOCKADE';

  @override
  String get coreGiftLabel => '✦ KERNGESCHENK';

  @override
  String get coreThemeLabel => '● KERNTHEMA';

  @override
  String dominantLabel(Object value) {
    return 'Dominant: $value';
  }

  @override
  String get karakasSuffix => 'Karakas';

  @override
  String get protectiveLabel => 'SCHÜTZEND';

  @override
  String secondaryLabel(Object value) {
    return ' · Sekundär: $value';
  }

  @override
  String get tagCore => 'KERN';

  @override
  String get debtScoresHeader => '📉 SCHULDEN-SCORES';

  @override
  String get debtCurrentLoadStat => 'AKTUELLE\nSCHULDENLAST';

  @override
  String get debtRecoveryCapacityStat => 'ERHOLUNGS-\nKAPAZITÄT';

  @override
  String get debtIntensityStat => 'INTENSITÄT';

  @override
  String get debtDefaultRiskStat => 'AUSFALLRISIKO';

  @override
  String get debtProfileTitle => 'Schuldenprofil';

  @override
  String get debtKarmaLabel => 'KARMA';

  @override
  String get debtPersonalityLabel => 'PERSÖNLICHKEIT';

  @override
  String get debtPhaseLabel => 'PHASE';

  @override
  String get debtPrimaryCategoryLabel => 'HAUPTKATEGORIE';

  @override
  String get debtWord => 'Schulden';

  @override
  String get debtYogasTitle => 'Schulden-Yogas';

  @override
  String get debtCreatingLabel => 'SCHULDEN-ERZEUGEND';

  @override
  String get debtClearingLabel => 'SCHULDEN-TILGEND';

  @override
  String get yearlyDebtTitle => 'Jährliche Schulden';

  @override
  String get debtRepaymentTitle => 'Rückzahlung';

  @override
  String get debtDangerPeriodsTitle => 'Gefahrenperioden';

  @override
  String get debtDefaultPctStat => 'AUSFALL %';

  @override
  String get debtBankruptcyPctStat => 'INSOLVENZ %';

  @override
  String get debtChronicPctStat => 'CHRONISCH %';

  @override
  String get debtResilienceStat => 'RESILIENZ';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'Erholung: $pct% · Zeitplan: $years Jahre';
  }

  @override
  String get debtFreeWindowLabel => '🎯 SCHULDENFREIES FENSTER';

  @override
  String debtFreeYear(Object year) {
    return 'Jahr $year';
  }

  @override
  String get legalScoresHeader => '⚖️ RECHTS-SCORES';

  @override
  String get legalVulnerabilityStat => 'RECHTLICHE\nANFÄLLIGKEIT';

  @override
  String get legalVictoryPotentialStat => 'SIEG-\nPOTENZIAL';

  @override
  String get legalConflictStat => 'KONFLIKT';

  @override
  String get legalResolutionStat => 'LÖSUNG';

  @override
  String get legalProfileTitle => 'Rechtsprofil';

  @override
  String get legalKarmaTypeLabel => 'KARMA-TYP';

  @override
  String get legalConflictStyleLabel => 'KONFLIKTSTIL';

  @override
  String get legalStrategyLabel => 'STRATEGIE';

  @override
  String get legalCaseDurationLabel => 'FALLDAUER';

  @override
  String get legalCurrentStatusLabel => 'AKTUELLER STATUS';

  @override
  String get legalWord => 'Rechtlich';

  @override
  String get legalYogasTitle => 'Rechts-Yogas';

  @override
  String get legalDisputePressureLabel => 'STREITDRUCK';

  @override
  String get legalProtectionLabel => 'RECHTSSCHUTZ';

  @override
  String get legalStressTrendTitle => 'Rechtlicher Stress';

  @override
  String get legalVisibleEnemiesStat => 'SICHTBARE FEINDE';

  @override
  String get legalHiddenEnemiesStat => 'VERBORGENE FEINDE';

  @override
  String get legalCriminalRiskStat => 'KRIMINALITÄTSRISIKO';

  @override
  String get legalFalseAccusationStat => 'FALSCHE ANSCHULDIGUNG';

  @override
  String get legalContractKarmaTitle => 'Vertrags-Karma';

  @override
  String get legalDocumentationLabel => 'DOKUMENTATION';

  @override
  String get legalFinePrintAwareLabel => 'KLEINGEDRUCKTES BEWUSST';

  @override
  String get legalNegotiationSkillLabel => 'VERHANDLUNGSGESCHICK';

  @override
  String get legalSignatureCautionLabel => 'VORSICHT BEI UNTERSCHRIFT';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'Resilienz: $pct/100';
  }

  @override
  String get legalVictoryWord => 'Sieg';

  @override
  String get legalAnalysisSuffix => 'Analyse';

  @override
  String get legalAsPlaintiff => 'ALS KLÄGER';

  @override
  String get legalAsDefendant => 'ALS BEKLAGTER';

  @override
  String get legalWinProbability => 'GEWINNWAHRSCHEINLICHKEIT';

  @override
  String get legalDisputeWord => 'Streit';

  @override
  String get lifepathScoresHeader => '🌟 LEBENSWEG-SCORES';

  @override
  String get lifepathDharmaClarityStat => 'DHARMA-\nKLARHEIT';

  @override
  String get lifepathFortuneBaselineStat => 'GLÜCKS-\nBASISWERT';

  @override
  String get lifepathCoherenceStat => 'LEBENSWEG-\nKOHÄRENZ';

  @override
  String get lifepathKarmaStat => 'KARMA';

  @override
  String get lifepathSpiritualStat => 'SPIRITUELL';

  @override
  String get lifepathFameStat => 'RUHM';

  @override
  String get lifepathSoulContractTitle => 'Seelenvertrag';

  @override
  String get lifepathAtmakarakaLabel => 'ATMAKARAKA';

  @override
  String get lifepathAkFocusLabel => 'AK-FOKUS';

  @override
  String get lifepathSoulPurposeLabel => 'SEELENZWECK';

  @override
  String get lifepathLifeChapterLabel => 'LEBENSKAPITEL';

  @override
  String get lifepathPrimaryDomainLabel => 'PRIMÄRER BEREICH';

  @override
  String get lifepathLeadershipStat => 'FÜHRUNG';

  @override
  String get lifepathWisdomTeachStat => 'WEISHEIT/LEHRE';

  @override
  String get lifepathServiceStat => 'DIENST';

  @override
  String get lifepathHealingStat => 'HEILUNG';

  @override
  String get lifepathFortuneYogasTitle => 'Glücks-Yogas';

  @override
  String get lifepathLuckBlocksLabel => 'GLÜCKSBLOCKADEN';

  @override
  String get lifepathFortuneBoostersLabel => 'GLÜCKSVERSTÄRKER';

  @override
  String get lifepathFortuneTrendTitle => 'Glückstrend';

  @override
  String get lifepathGoldenWindowsTitle => 'Goldene Fenster ★';

  @override
  String get lifepathTransformationTitle => 'Transformation';

  @override
  String get lifepathMilestonesTitle => 'Lebensmeilensteine';

  @override
  String get lifepathKarmicLessonsTitle => 'Karmische Lektionen';

  @override
  String get lifepathRahuGrowthLabel => 'RAHU-WACHSTUM';

  @override
  String get lifepathKetuSurrenderLabel => 'KETU-HINGABE';

  @override
  String get lifepathSaturnLessonLabel => 'SATURN-LEKTION';

  @override
  String get lifepathLifeDifficultyLabel => 'LEBENSSCHWIERIGKEIT';

  @override
  String get lifepathSoulExperienceTitle => '★ SEELE WOLLTE ERFAHREN';

  @override
  String get lifepathBlessingsTitle => '● SEGNUNGEN';

  @override
  String get lifepathLifeWord => 'Leben';

  @override
  String get lifepathArchetypeSuffix => 'Archetyp';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'Erfüllung: $pct%';
  }

  @override
  String get lifepathDestinyVsWord => 'Schicksal vs.';

  @override
  String get lifepathFreeWillSuffix => 'Freier Wille';

  @override
  String get lifepathDestinyStat => 'SCHICKSAL';

  @override
  String get lifepathFreeWillStat => 'FREIER WILLE';

  @override
  String get pastlifeScoresHeader => '🔮 SCORES FRÜHERES LEBEN';

  @override
  String get pastlifeSignatureStrengthStat => 'SIGNATUR-\nSTÄRKE';

  @override
  String get pastlifeCarryForwardStat => 'WEITER-\nGETRAGEN';

  @override
  String get pastlifeMasteryPreservedStat => 'ERHALTENE\nMEISTERSCHAFT';

  @override
  String get pastlifeUnfinishedStat => 'UNVOLLENDET';

  @override
  String get pastlifeKarmicDebtStat => 'KARMISCHE SCHULD';

  @override
  String get pastlifeProfileTitle => 'Profil des früheren Lebens';

  @override
  String get pastlifeThemeLabel => 'THEMA';

  @override
  String get pastlifeProfessionLabel => 'BERUF';

  @override
  String get pastlifeSocialStandingLabel => 'SOZIALER STAND';

  @override
  String get pastlifeRegionLabel => 'REGION';

  @override
  String get pastlifeSpiritualLevelLabel => 'SPIRITUELLES NIVEAU';

  @override
  String get pastlifeGenderLabel => 'GESCHLECHT';

  @override
  String get pastlifeWealthLevelLabel => 'WOHLSTANDSNIVEAU';

  @override
  String get pastlifeFamilyRoleLabel => 'FAMILIENROLLE';

  @override
  String get pastlifeSkillsCarriedTitle => '★ WEITERGETRAGENE FÄHIGKEITEN';

  @override
  String get pastlifeNaturalAttractionsTitle => '● NATÜRLICHE ANZIEHUNGEN';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ UNERKLÄRLICHE ÄNGSTE';

  @override
  String get pastlifeMagneticPullsTitle => '→ MAGNETISCHE ANZIEHUNGEN';

  @override
  String get pastlifeRelationshipStat => 'BEZIEHUNG';

  @override
  String get pastlifeFinancialStat => 'FINANZIELL';

  @override
  String get pastlifeServiceStat => 'DIENST';

  @override
  String get pastlifeDharmicStat => 'DHARMISCH';

  @override
  String get pastlifeOnRelationsStat => 'AUF BEZIEHUNGEN';

  @override
  String get pastlifeOnCareerStat => 'AUF KARRIERE';

  @override
  String get pastlifeOnHealthStat => 'AUF GESUNDHEIT';

  @override
  String get pastlifeOnSpiritualStat => 'AUF SPIRITUALITÄT';

  @override
  String get pastlifeKarmicResolutionTitle => 'Karmische Auflösung';

  @override
  String get pastlifePrimaryPathLabel => 'PRIMÄRER WEG';

  @override
  String get pastlifeSecondaryPathLabel => 'SEKUNDÄRER WEG';

  @override
  String get pastlifeClearingProgressLabel => 'AUFLÖSUNGSFORTSCHRITT';

  @override
  String get pastlifeRemainingWorkLabel => 'VERBLEIBENDE ARBEIT';

  @override
  String get pastlifeDebtTimelineLabel => 'SCHULDEN-ZEITPLAN';

  @override
  String get pastlifeMemoryAccessStat => 'ERINNERUNGSZUGANG';

  @override
  String get pastlifeDreamVisitsStat => 'TRAUMBESUCHE';

  @override
  String get pastlifeDejaVuStat => 'DEJA VU';

  @override
  String get pastlifeRegressionFitStat => 'REGRESSIONSEIGNUNG';

  @override
  String get pastlifeActivationTitle => 'Aktivierung des früheren Lebens';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'Reife: $maturity · Status: $status';
  }

  @override
  String get pastlifeKetuWord => 'Ketu';

  @override
  String get pastlifePastMasterySuffix => 'Frühere Meisterschaft';

  @override
  String get pastlifeKetuMasteredLabel => 'KETU · WAS DU GEMEISTERT HAST';

  @override
  String get pastlifeRahuWord => 'Rahu';

  @override
  String get pastlifeFutureGrowthSuffix => 'Zukünftiges Wachstum';

  @override
  String get pastlifeRahuPullsLabel => 'RAHU · WAS DICH VORWÄRTS ZIEHT';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ Schatten: $shadow';
  }

  @override
  String get mentalScoresHeader => '🧠 MENTALE SCORES';

  @override
  String get mentalStabilityStat => 'MENTALE\nSTABILITÄT';

  @override
  String get mentalEmotionalBaselineStat => 'EMOTIONALER\nBASISWERT';

  @override
  String get mentalResilienceStat => 'RESILIENZ';

  @override
  String get mentalAnxietyStat => 'ANGST';

  @override
  String get mentalDepressionStat => 'DEPRESSION';

  @override
  String get mentalRegulationStat => 'REGULATION';

  @override
  String get mentalProfileTitle => 'Mentales Profil';

  @override
  String get mentalConstitutionLabel => 'KONSTITUTION';

  @override
  String get mentalStressDriverLabel => 'STRESSAUSLÖSER';

  @override
  String get mentalStabilityAnchorLabel => 'STABILITÄTSANKER';

  @override
  String get mentalStressResponseLabel => 'STRESSREAKTION';

  @override
  String get mentalAttachmentStyleLabel => 'BINDUNGSSTIL';

  @override
  String get mentalBurnoutStageLabel => 'BURNOUT-STADIUM';

  @override
  String get mentalWord => 'Mental';

  @override
  String get mentalYogasTitle => 'Mentale Yogas';

  @override
  String get mentalStressPressureLabel => 'STRESSDRUCK';

  @override
  String get mentalWellnessTrendTitle => 'Wellness-Trend';

  @override
  String get mentalHealthyCopingTitle => '✓ GESUNDE BEWÄLTIGUNG';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ UNGESUNDE RISIKEN';

  @override
  String get mentalRecommendedAlternativesTitle => '✦ EMPFOHLENE ALTERNATIVEN';

  @override
  String get mentalSleepQualityStat => 'SCHLAFQUALITÄT';

  @override
  String get mentalSocialSupportStat => 'SOZIALE UNTERSTÜTZUNG';

  @override
  String get mentalBurnoutVulnStat => 'BURNOUT-ANFÄLLIGKEIT';

  @override
  String get mentalSelfAwarenessStat => 'SELBSTWAHRNEHMUNG';

  @override
  String get mentalAnxietyWord => 'Angst';

  @override
  String get mentalTypesSuffix => 'Typen';

  @override
  String get mentalTherapyWord => 'Therapie';

  @override
  String get mentalModalityFitSuffix => 'Modalitätspassung';

  @override
  String get characterScoresHeader => '🔍 CHARAKTER-SCORES';

  @override
  String get characterStrengthStat => 'CHARAKTER-\nSTÄRKE';

  @override
  String get characterIntegrityStat => 'INTEGRITÄT';

  @override
  String get characterResilienceStat => 'RESILIENZ';

  @override
  String get characterAwarenessStat => 'BEWUSSTSEIN';

  @override
  String get characterStabilityStat => 'STABILITÄT';

  @override
  String get characterEthicsStat => 'ETHIK';

  @override
  String get characterSurfacePersonalityTitle => 'Oberflächenpersönlichkeit';

  @override
  String get characterLagnaLabel => 'LAGNA';

  @override
  String get characterConstitutionLabel => 'KONSTITUTION';

  @override
  String get characterNakshatraLabel => 'NAKSHATRA';

  @override
  String get characterDeityLabel => 'GOTTHEIT';

  @override
  String get characterMoonManasTitle => 'Mond-Manas';

  @override
  String get characterSignLabel => 'ZEICHEN';

  @override
  String get characterHouseLabel => 'HAUS';

  @override
  String get characterWarmthStat => 'WÄRME';

  @override
  String get characterEmpathyStat => 'EMPATHIE';

  @override
  String get characterLoyaltyStat => 'LOYALITÄT';

  @override
  String get characterBoundariesStat => 'GRENZEN';

  @override
  String get characterDharmaStat => 'DHARMA';

  @override
  String get characterTruthStat => 'WAHRHEIT';

  @override
  String get characterCompassionStat => 'MITGEFÜHL';

  @override
  String get characterGenerosityStat => 'GROSSZÜGIGKEIT';

  @override
  String get characterSignatureVirtuesTitle => '★ CHARAKTERISTISCHE TUGENDEN';

  @override
  String get characterNaturalTalentsTitle => '● NATÜRLICHE TALENTE';

  @override
  String get characterShadowPatternsTitle => '⚠ SCHATTENMUSTER';

  @override
  String get characterYogasTitle => 'Charakter-Yogas';

  @override
  String get characterTestsLabel => 'PRÜFUNGEN';

  @override
  String get characterGiftsLabel => 'GESCHENKE';

  @override
  String get characterSelfAwareEiStat => 'SELBSTBEWUSSTE EI';

  @override
  String get characterSelfRegulateStat => 'SELBSTREGULATION';

  @override
  String get characterEmpathyEiStat => 'EMPATHIE EI';

  @override
  String get characterSocialSkillsStat => 'SOZIALE FÄHIGKEITEN';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'Verwirklichung: $pct%';
  }

  @override
  String get characterAtmakarakaWord => 'Atmakaraka';

  @override
  String get characterSoulSignatureSuffix => 'Seelensignatur';

  @override
  String get characterAtmakarakaLabel => 'ATMAKARAKA';

  @override
  String get characterGunaWord => 'Guna';

  @override
  String get characterProfileSuffix => 'Profil';

  @override
  String get characterSattvaLabel => 'Sattva';

  @override
  String get characterRajasLabel => 'Rajas';

  @override
  String get characterTamasLabel => 'Tamas';

  @override
  String get healthScoresHeader => '🏥 GESUNDHEITS-SCORES';

  @override
  String get healthVitalityStat => 'VITALITÄT';

  @override
  String get healthImmunityStat => 'IMMUNITÄT';

  @override
  String get healthRecoveryStat => 'ERHOLUNG';

  @override
  String get healthMentalStat => 'MENTAL';

  @override
  String get healthStressTolStat => 'STRESSTOLERANZ';

  @override
  String get healthYogasTitle => 'Gesundheits-Yogas';

  @override
  String get healthDiseasePressureLabel => 'KRANKHEITSDRUCK';

  @override
  String get healthTrendTitle => 'Gesundheitstrend';

  @override
  String get healthRecoveryWindowsTitle => 'Erholungsfenster';

  @override
  String get healthCautionPeriodsTitle => 'Vorsichtsperioden';

  @override
  String get healthFertilityStat => 'FRUCHTBARKEIT';

  @override
  String get healthBurnoutRiskStat => 'BURNOUT-RISIKO';

  @override
  String get healthAddictionVulnStat => 'SUCHTANFÄLLIGKEIT';

  @override
  String get healthWorkLifeBalStat => 'WORK-LIFE-BALANCE';

  @override
  String get healthAyurvedicWord => 'Ayurvedisch';

  @override
  String get healthConstitutionSuffix => 'Konstitution';

  @override
  String get healthBodyWord => 'Körper';

  @override
  String get healthSystemMapSuffix => 'Systemkarte';

  @override
  String get healthBodyZoneWord => 'Körperzone';

  @override
  String get healthVulnerabilitySuffix => 'Anfälligkeit';

  @override
  String get healthDiseaseWord => 'Krankheit';

  @override
  String get healthSusceptibilitySuffix => 'Anfälligkeit';

  @override
  String get healthLifestyleFactorsTitle => 'Lebensstilfaktoren';

  @override
  String get healthSleepDisciplineLabel => 'SCHLAFDISZIPLIN';

  @override
  String get healthDietDisciplineLabel => 'ERNÄHRUNGSDISZIPLIN';

  @override
  String get healthExerciseNeedLabel => 'BEWEGUNGSBEDARF';

  @override
  String get healthSunlightNeedLabel => 'SONNENLICHTBEDARF';

  @override
  String get healthSocialTypeLabel => 'SOZIALER TYP';

  @override
  String get healthHealingSpeedLabel => 'HEILUNGSGESCHWINDIGKEIT';

  @override
  String get wealthScoresHeader => '💰 VERMÖGENS-SCORES';

  @override
  String get wealthStrengthStat => 'VERMÖGENS-\nSTÄRKE';

  @override
  String get wealthAccumulationStat => 'ANSAMM-\nLUNG';

  @override
  String get wealthIncomeFlowStat => 'EINKOMMENS-\nFLUSS';

  @override
  String get wealthSustainStat => 'NACHHALTIGKEIT';

  @override
  String get wealthMultiStreamStat => 'MEHRERE QUELLEN';

  @override
  String get wealthRetentionStat => 'ERHALT';

  @override
  String get wealthWord => 'Vermögen';

  @override
  String get wealthYogasTitle => 'Vermögens-Yogas';

  @override
  String get wealthDrainsLabel => 'VERLUSTE';

  @override
  String get wealthBoostersLabel => 'VERSTÄRKER';

  @override
  String get wealthYearlyTrendTitle => 'Jährlicher Trend';

  @override
  String get wealthGrowthTitle => 'Vermögenswachstum';

  @override
  String get wealthCashPressureTitle => 'Liquiditätsdruck';

  @override
  String get wealthMoneyPersonalityTitle => 'Geldpersönlichkeit';

  @override
  String get wealthTypeLabel => 'VERMÖGENSART';

  @override
  String get wealthRiskAppetiteLabel => 'RISIKOBEREITSCHAFT';

  @override
  String get wealthInvestmentStyleLabel => 'ANLAGESTIL';

  @override
  String get wealthMoneyPersonalityLabel => 'GELDPERSÖNLICHKEIT';

  @override
  String get wealthSpendingLabel => 'AUSGABEN';

  @override
  String get wealthDebtProbStat => 'SCHULDEN-WAHRSCH. %';

  @override
  String get wealthInheritanceStat => 'ERBSCHAFT %';

  @override
  String get wealthSuddenGainsStat => 'PLÖTZLICHE GEWINNE %';

  @override
  String get wealthSpouseBoostStat => 'EHEPARTNER-SCHUB %';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'Erfolgswahrscheinlichkeit: $pct%';
  }

  @override
  String get wealthLifetimeClassLabel => 'LEBENSLANGE VERMÖGENSKLASSE';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'Primär: $value';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'Höhepunkt: $value';
  }

  @override
  String get wealthIncomeWord => 'Einkommen';

  @override
  String get wealthSourcesSuffix => 'Quellen';

  @override
  String get wealthInvestmentWord => 'Investition';

  @override
  String get wealthMixSuffix => 'Mischung';

  @override
  String wealthDrivenByLabel(Object planet) {
    return 'Angetrieben von $planet';
  }

  @override
  String get marriageScoresHeader => '💒 EHE-SCORES';

  @override
  String get marriageOverallStat => 'GESAMT-\nEHE';

  @override
  String get marriageHarmonyStat => 'EHELICHE\nHARMONIE';

  @override
  String get marriageDomesticStabilityStat => 'HÄUSLICHE\nSTABILITÄT';

  @override
  String get marriageLongevityStat => 'BESTÄNDIGKEIT';

  @override
  String get marriageSatisfactionStat => 'ZUFRIEDENHEIT';

  @override
  String get marriageClarityStat => 'KLARHEIT';

  @override
  String get marriageWindowsTitle => 'Ehefenster';

  @override
  String get marriagePhasesTitle => 'Ehephasen';

  @override
  String get marriageInLawRelationsStat => 'SCHWIEGERFAMILIE';

  @override
  String get marriageFamilyHarmonyStat => 'FAMILIENHARMONIE';

  @override
  String get marriageFertilityStat => 'FRUCHTBARKEIT';

  @override
  String get marriageHomeOwnershipStat => 'WOHNEIGENTUM';

  @override
  String get marriageDivorceRiskStat => 'SCHEIDUNGSRISIKO';

  @override
  String get marriageInfidelityStat => 'UNTREUE';

  @override
  String get marriageConflictStat => 'KONFLIKT';

  @override
  String get marriageDistanceStat => 'DISTANZ';

  @override
  String get marriageSeekInPartnerTitle => '★ IM PARTNER SUCHEN';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ IM PARTNER VERMEIDEN';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'Verwirklichung: $pct%';
  }

  @override
  String get marriageDarakarakaWord => 'Darakaraka';

  @override
  String get marriageSpouseKarakaSuffix => 'Ehepartner-Karaka';

  @override
  String get marriageDarakarakaDkLabel => 'DARAKARAKA (DK)';

  @override
  String get marriage7thWord => '7.';

  @override
  String get marriageSignLabel => 'ZEICHEN';

  @override
  String get marriageLordInLabel => 'HERR IN';

  @override
  String get marriageStrengthLabel => 'STÄRKE';

  @override
  String get marriageSpouseWord => 'Ehepartner';

  @override
  String get marriageProfileSuffix => 'Profil';

  @override
  String get marriageSpouseTraitsTitle => '★ EIGENSCHAFTEN DES EHEPARTNERS';

  @override
  String get marriageLikelyProfessionsTitle => '● WAHRSCHEINLICHE BERUFE';

  @override
  String get marriageHarmonyWord => 'Harmonie';

  @override
  String get marriageRadarSuffix => 'Radar';

  @override
  String get marriagePhysicalLabel => 'Körperlich';

  @override
  String get marriageSharedValuesLabel => 'Gemeinsame Werte';

  @override
  String get marriageConflictResolutionLabel => 'Konfliktlösung';

  @override
  String get marriageMangalDoshLabel => '⚠ MANGAL DOSH';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'Schweregrad: $value';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'Aufhebung: $value';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'Navamsa';

  @override
  String get multiChartTitleChild => 'Kind';

  @override
  String get multiChartTitleLove => 'Liebe';

  @override
  String get multiChartTitleKarma => 'Karma';

  @override
  String get multiChartTitleDefault => 'Mehrfach-Chart';

  @override
  String get multiChartSuffixProbability => 'Wahrscheinlichkeit';

  @override
  String get multiChartSuffixCompatibility => 'Kompatibilität';

  @override
  String get multiChartSuffixLinkage => 'Verbindung';

  @override
  String get multiChartSuffixReport => 'Bericht';

  @override
  String get multiChartParticipantsLabel => 'TEILNEHMER';

  @override
  String get multiChartAnalysisWord => 'Analyse';

  @override
  String get multiChartConfidenceSuffix => 'Konfidenz';

  @override
  String get multiChartQualityBadge => 'QUALITÄT';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'Analysiere diesen vedischen Astrologiebericht und gib detaillierte Einblicke:\n\n$formatted';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'Hier ist ein vedischer Astrologie-Spezialbericht. Bitte analysiere ihn gründlich und gib umsetzbare Einblicke:\n\n$formatted';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'Überprüfe diese vedische Astrologieanalyse und erkläre die wichtigsten Erkenntnisse in einfacher Sprache:\n\n$formatted';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return 'Für $label kopiert!';
  }

  @override
  String get childProbTitle1 => 'Kind';

  @override
  String get childProbTitle2 => 'Wahrscheinlichkeit';

  @override
  String get childNumberOfChildrenHeader1 => 'Anzahl der';

  @override
  String get childNumberOfChildrenHeader2 => 'Kinder';

  @override
  String get childTimingHeader1 => 'Timing';

  @override
  String get childTimingHeader2 => 'Moola Dasha';

  @override
  String get child5thHouseHeader1 => '5. Haus';

  @override
  String get analysisWord => 'Analyse';

  @override
  String get jupiterWord => 'Jupiter';

  @override
  String get childD7Header1 => 'D7 Saptamsa';

  @override
  String get childBeejaHeader1 => 'Beeja & Kshetra';

  @override
  String get childBeejaHeader2 => 'Sphuta';

  @override
  String get childDoshaHeader1 => 'Dosha';

  @override
  String get childVedicHeader1 => 'Vedische';

  @override
  String get childVedicHeader2 => 'Heilmittel';

  @override
  String get progenyProbabilityLabel => 'NACHKOMMENSCHAFTSWAHRSCHEINLICHKEIT';

  @override
  String get favorableWindowsLabel => 'GÜNSTIGE ZEITFENSTER';

  @override
  String get partnerOneLabel => 'Partner 1';

  @override
  String get partnerTwoLabel => 'Partner 2';

  @override
  String get moonSignLabel => 'Mondzeichen';

  @override
  String get lordInDusthana => 'Herr im Dusthana';

  @override
  String get lordStrengthLabel => 'Stärke des Herrn';

  @override
  String get houseStrengthLabel => 'Hausstärke';

  @override
  String get dignityLabel => 'Würde';

  @override
  String get directBadge => 'Direkt';

  @override
  String get notCombustBadge => 'Nicht kombust';

  @override
  String get in5thHouseBadge => 'Im 5. Haus';

  @override
  String get aspects5thBadge => 'Aspektiert 5.';

  @override
  String get no5thConnectionBadge => 'Keine Verbindung zum 5.';

  @override
  String jupiterInSignHeading(String sign) {
    return 'Jupiter in $sign';
  }

  @override
  String get d7LagnaLabel => 'D7 Lagna';

  @override
  String get d7FifthSignLabel => 'D7 5. Zeichen';

  @override
  String get d7FifthLordLabel => 'D7 5. Herr';

  @override
  String get jupiterInD7Label => 'Jupiter in D7';

  @override
  String get jupiterDignityLabel => 'Jupiter-Würde';

  @override
  String get d7StrengthLabel => 'D7-Stärke';

  @override
  String get yesWord => 'Ja';

  @override
  String get noWord => 'Nein';

  @override
  String get beejaSphutaTitle => 'BEEJA SPHUTA';

  @override
  String get kshetraSphutaTitle => 'KSHETRA SPHUTA';

  @override
  String get degreeLabel => 'Grad';

  @override
  String get signLordLabel => 'Zeichenherr';

  @override
  String get presentInLabel => 'Vorhanden in';

  @override
  String get netPenaltyLabel => 'Netto-Abzug';

  @override
  String get remedyGemstone => 'Edelstein-Heilmittel';

  @override
  String get remedyMantra => 'Mantra-Heilmittel';

  @override
  String get remedyRitual => 'Ritual-Heilmittel';

  @override
  String get remedyLifestyle => 'Lebensstil-Heilmittel';

  @override
  String get remedyCharitable => 'Wohltätige Heilmittel';

  @override
  String copiedForName(String name) {
    return 'Für $name kopiert!';
  }

  @override
  String get mahadashaLabel => 'Mahadasha';

  @override
  String get mdPeriodLabel => 'MD-Periode';

  @override
  String get antardashaLabel => 'Antardasha';

  @override
  String get adPeriodLabel => 'AD-Periode';

  @override
  String get pratyantardashaLabel => 'Pratyantardasha';

  @override
  String get favorabilityLabel => 'Günstigkeit';

  @override
  String factorPrefix(String factor) {
    return 'Faktor: $factor';
  }

  @override
  String appliesToLabel(String value) {
    return 'Gilt für: $value';
  }

  @override
  String get qualityTag => 'QUALITÄT';

  @override
  String get reliabilityVeryHigh => 'Sehr hohe Zuverlässigkeit';

  @override
  String get reliabilityGuidanceLevel => 'Deutung auf Orientierungsebene';

  @override
  String get karmaLinkTitle1 => 'Karma-';

  @override
  String get karmaLinkTitle2 => 'Verbindung';

  @override
  String get karmaFoundationHeader1 => 'Karmisches';

  @override
  String get karmaFoundationHeader2 => 'Fundament';

  @override
  String get karmaPairwiseHeader1 => 'Paarweise';

  @override
  String get karmaPairwiseHeader2 => 'Verbindungen';

  @override
  String get karmaGroupHeader1 => 'Gruppen-';

  @override
  String get karmaGroupHeader2 => 'Muster';

  @override
  String get karmaPastLifeHeader1 => 'Frühere Leben';

  @override
  String get karmaPastLifeHeader2 => 'Ziele';

  @override
  String get karmaCurrentLifeHeader1 => 'Aktuelles Leben';

  @override
  String get karmaCurrentLifeHeader2 => 'Lernen';

  @override
  String get karmaDebtsHeader2 => 'Schulden';

  @override
  String get karmaMoolaDashaHeader1 => 'Moola Dasha';

  @override
  String get karmaMoolaDashaHeader2 => 'Timing';

  @override
  String get karmaDeepAuditHeader1 => 'Detaillierte Auditing-';

  @override
  String get karmaDeepAuditHeader2 => 'Tabelle';

  @override
  String get karmaHeroLabel => 'KARMA-VERBINDUNG AUS FRÜHEREM LEBEN';

  @override
  String get karmaKetuMastery => 'KETU-MEISTERSCHAFT';

  @override
  String get nakshatraLabel => 'Nakshatra';

  @override
  String get deityLabel => 'Gottheit';

  @override
  String get masteryScoreLabel => 'Meisterschafts-Score';

  @override
  String get karmaRahuGrowth => 'RAHU-WACHSTUM';

  @override
  String get growthScoreLabel => 'Wachstums-Score';

  @override
  String get karmaAtmakaraka => 'ATMAKARAKA';

  @override
  String get karmaSaturnKarma => 'SATURN-KARMA';

  @override
  String get karma12thHouse => '12. HAUS';

  @override
  String get karma9thHousePunya => '9. HAUS PUNYA';

  @override
  String get bhavaScoreLabel => 'Bhava-Score';

  @override
  String get karmaD60Signature => 'D60-SIGNATUR';

  @override
  String get depthScoreLabel => 'Tiefen-Score';

  @override
  String get linkageStrengthLabel => 'Verbindungsstärke';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'VERBINDUNGSFAKTOREN ($count aktiv)';
  }

  @override
  String get factorColumnLabel => 'Faktor';

  @override
  String get weightColumnLabel => 'Gewicht';

  @override
  String get meaningColumnLabel => 'Bedeutung';

  @override
  String get statusColumnLabel => 'Status';

  @override
  String get karmaPastLifeConnection => 'VERBINDUNG AUS FRÜHEREM LEBEN';

  @override
  String get karmaCurrentLifeDynamic => 'DYNAMIK IM AKTUELLEN LEBEN';

  @override
  String get karmaWhatTheyTeach => 'WAS SIE SICH GEGENSEITIG LEHREN';

  @override
  String get karmaGroupThemeHeader => 'KARMISCHES GRUPPENTHEMA';

  @override
  String get karmaSharedSettingHeader =>
      'GEMEINSAMER SCHAUPLATZ FRÜHERER LEBEN';

  @override
  String get karmaCollectiveKetuHeader => 'KOLLEKTIVES KETU-MUSTER';

  @override
  String get karmaCollectiveRahuHeader => 'KOLLEKTIVES RAHU-MUSTER';

  @override
  String get housesPrefixLabel => 'Häuser: ';

  @override
  String get signsPrefixLabel => 'Zeichen: ';

  @override
  String get karmicCohesionLabel => 'Karmische Kohäsion';

  @override
  String get karmaGroupSoulContractHeader => 'SEELENVERTRAG DER GRUPPE';

  @override
  String get goalLabel => 'Ziel';

  @override
  String get karmaSharedGoalHeader => 'GEMEINSAMES ZIEL AUS FRÜHEREM LEBEN';

  @override
  String get howToGrowHeader => 'WIE MAN WÄCHST';

  @override
  String moolaDashaPrefix(String value) {
    return 'Moola Dasha: $value';
  }

  @override
  String get karmaSharedLessonHeader => 'GEMEINSAME GRUPPENLEKTION';

  @override
  String get karmaMutualTeachingHeader => 'KARTE GEGENSEITIGEN LEHRENS';

  @override
  String get karmaTeachingDynamicsPlaceholder =>
      'Lehrdynamiken entstehen, wenn sich karmische Verbindungen vertiefen.';

  @override
  String get typeFieldLabel => 'Typ';

  @override
  String get basisFieldLabel => 'Basis';

  @override
  String get resolutionPathHeader => 'LÖSUNGSWEG';

  @override
  String dashaTimingPrefix(String value) {
    return 'Dasha-Timing: $value';
  }

  @override
  String get mutualDebtsHeader => 'GEGENSEITIGE SCHULDEN';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'Daten';

  @override
  String get groupKarmicWindowHeader => 'KARMISCHES GRUPPENFENSTER';

  @override
  String parametersAuditedHeading(int count) {
    return '$count PARAMETER GEPRÜFT';
  }

  @override
  String get valuePrefixLabel => 'Wert: ';

  @override
  String weightPrefix(String value) {
    return 'G: $value';
  }

  @override
  String get loveCompatTitle1 => 'Liebes-';

  @override
  String get loveCompatTitle2 => 'Kompatibilität';

  @override
  String get loveAttractionHeader1 => 'Anziehung &';

  @override
  String get loveAttractionHeader2 => 'Chemie';

  @override
  String get loveEmotionalHeader1 => 'Emotionale';

  @override
  String get loveEmotionalHeader2 => 'Harmonie';

  @override
  String get loveMentalHeader1 => 'Geistige';

  @override
  String get loveMentalHeader2 => 'Verbundenheit';

  @override
  String get lovePassionHeader1 => 'Leidenschaft &';

  @override
  String get lovePassionHeader2 => 'Körperliches';

  @override
  String get loveLongtermHeader1 => 'Langzeit';

  @override
  String get loveKarmicHeader1 => 'Karmische Liebes-';

  @override
  String get loveKarmicHeader2 => 'Bindung';

  @override
  String get loveChallengesHeader1 => 'Herausforderungen &';

  @override
  String get loveChallengesHeader2 => 'Reibung';

  @override
  String get loveTimingHeader1 => 'Liebes-Timing';

  @override
  String get loveRelationshipHeader1 => 'Beziehungs-';

  @override
  String get loveRelationshipHeader2 => 'Dynamik';

  @override
  String get loveRemediesHeader1 => 'Heilmittel &';

  @override
  String get loveRemediesHeader2 => 'Anleitung';

  @override
  String get loveCompatHeroLabel => 'LIEBESKOMPATIBILITÄT';

  @override
  String get loveChipAttraction => 'Anziehung';

  @override
  String get loveChipPassion => 'Leidenschaft';

  @override
  String get loveChipChallenge => 'Herausforderung';

  @override
  String get venusSignLabel => 'Venus-Zeichen';

  @override
  String get attractionScoreLabel => 'Anziehungs-Score';

  @override
  String get activeContactsLabel => 'Aktive Kontakte';

  @override
  String get magneticPullLabel => 'Magnetische Anziehung';

  @override
  String get initialAttractionLabel => 'Erste Anziehung';

  @override
  String get emotionalScoreLabel => 'Emotionaler Score';

  @override
  String get elementMatchLabel => 'Elementübereinstimmung';

  @override
  String get harmonyLabel => 'Harmonie';

  @override
  String get kootaYoni => 'YONI';

  @override
  String get kootaGana => 'GANA';

  @override
  String get kootaTara => 'TARA';

  @override
  String get doshaPresentBadge => 'Dosha vorhanden';

  @override
  String get noDoshaBadge => 'Kein Dosha';

  @override
  String get axisLabel => 'Achse';

  @override
  String get mentalScoreLabel => 'Geistiger Score';

  @override
  String get mercuryDynamicsLabel => 'MERKUR-DYNAMIK';

  @override
  String get communicationStyleLabel =>
      'ÜBEREINSTIMMUNG DES KOMMUNIKATIONSSTILS';

  @override
  String get intellectualConnectionLabel => 'INTELLEKTUELLE VERBINDUNG';

  @override
  String get passionScoreLabel => 'Leidenschafts-Score';

  @override
  String get marsVenusLabel => 'MARS-VENUS-ZUSAMMENSPIEL';

  @override
  String get physicalChemistryLabel => 'KÖRPERLICHE CHEMIE';

  @override
  String get yoniCompatLabel => 'YONI-KOMPATIBILITÄT';

  @override
  String get longtermScoreLabel => 'Langzeit-Score';

  @override
  String get seventhHouseSynastryLabel => 'SYNASTRIE DES 7. HAUSES';

  @override
  String get commitmentPotentialLabel => 'BINDUNGSPOTENZIAL';

  @override
  String get jupiterBlessingLabel => 'JUPITER-SEGEN';

  @override
  String get d9NavamsaResonanceLabel => 'D9-NAVAMSA-RESONANZ';

  @override
  String get saturnLongevityLabel => 'SATURN-BESTÄNDIGKEIT';

  @override
  String get karmicScoreLabel => 'Karmischer Score';

  @override
  String get darakarakaLinkLabel => 'DARAKARAKA-VERBINDUNG';

  @override
  String get sourceLabel => 'Quelle';

  @override
  String get emotionalGiverReceiverLabel => 'EMOTIONALER GEBER / NEHMER';

  @override
  String get powerBalanceLabel => 'MACHTBALANCE';

  @override
  String get growthDynamicLabel => 'WACHSTUMSDYNAMIK';

  @override
  String get addressesLabel => 'Behandelt';

  @override
  String get loveScoresLabel => 'LIEBES-SCORES';

  @override
  String get loveCapacityLabel => 'LIEBES-\nFÄHIGKEIT';

  @override
  String get emotionalAvailabilityLabel => 'EMOTIONALE\nOFFENHEIT';

  @override
  String get romanticAttractionLabel => 'ROMANTISCHE\nANZIEHUNG';

  @override
  String get commitmentWord => 'BINDUNG';

  @override
  String get intimacyWord => 'INTIMITÄT';

  @override
  String get fidelityWord => 'TREUE';

  @override
  String get loveProfileTitle => 'Liebesprofil';

  @override
  String get loveStyleLabel => 'LIEBESSTIL';

  @override
  String get attractionStyleLabel => 'ANZIEHUNGSSTIL';

  @override
  String get lovePathLabel => 'LIEBESWEG';

  @override
  String get currentPhaseLabel => 'AKTUELLE PHASE';

  @override
  String get commitmentStyleLabel => 'BINDUNGSSTIL';

  @override
  String get loveWord => 'Liebe';

  @override
  String get karakasWord => 'Karakas';

  @override
  String get attractedToLabel => 'HINGEZOGEN ZU';

  @override
  String get whatPartnerSeesLabel => 'WAS DER PARTNER SIEHT';

  @override
  String get romancePatternTitle => 'Romantik-Muster';

  @override
  String get firstLoveAgeLabel => 'ALTER DER ERSTEN LIEBE';

  @override
  String get relationshipCountLabel => 'ANZAHL DER BEZIEHUNGEN';

  @override
  String get avgDurationLabel => 'DURCHSCHN. DAUER';

  @override
  String get breakupTriggerLabel => 'TRENNUNGSAUSLÖSER';

  @override
  String get heartbreakRecoveryLabel => 'ERHOLUNG VOM HERZSCHMERZ';

  @override
  String get loveTrendTitle => 'Liebestrend';

  @override
  String get newLoveWindowsTitle => 'Fenster für neue Liebe';

  @override
  String get loveBlocksTitle => 'Liebesblockaden';

  @override
  String get activeBlocksLabel => 'AKTIVE BLOCKADEN';

  @override
  String get loveMarriagePctLabel => 'LIEBESHEIRAT %';

  @override
  String get heartbreakVulnLabel => 'HERZSCHMERZ-ANFÄLLIGKEIT';

  @override
  String get selfSabotageLabel => 'SELBSTSABOTAGE';

  @override
  String get emotionalIqLabel => 'EMOTIONALER IQ';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'Erfüllung: $pct%';
  }

  @override
  String get languagesWord => 'Sprachen';

  @override
  String get givesLabel => 'GIBT';

  @override
  String get receivesLabel => 'EMPFÄNGT';

  @override
  String get idealWord => 'Ideal';

  @override
  String get partnerWord => 'Partner';

  @override
  String get seekTheseTraitsLabel => 'DIESE EIGENSCHAFTEN SUCHEN';

  @override
  String get dealbreakersLabel => 'AUSSCHLUSSKRITERIEN';

  @override
  String get propertyScoresLabel => 'IMMOBILIEN-SCORES';

  @override
  String get acquisitionCapacityLabel => 'ERWERBS-\nKAPAZITÄT';

  @override
  String get homeOwnershipPctLabel => 'WOHN-\nEIGENTUM %';

  @override
  String get reWealthPotentialLabel => 'IMMOBILIEN-\nVERMÖGENSPOTENZIAL';

  @override
  String get rentalWord => 'MIETE';

  @override
  String get vehiclesWord => 'FAHRZEUGE';

  @override
  String get landPctLabel => 'LAND %';

  @override
  String get propertyProfileTitle => 'Immobilienprofil';

  @override
  String get karmaTypeLabel => 'KARMA-TYP';

  @override
  String get environmentLabel => 'UMGEBUNG';

  @override
  String get styleLabel => 'STIL';

  @override
  String get sizeLabel => 'GRÖSSE';

  @override
  String get locationLabel => 'STANDORT';

  @override
  String get actionNext12mLabel => 'MASSNAHME NÄCHSTE 12 MONATE';

  @override
  String get propertyWord => 'Immobilie';

  @override
  String get propertyYogasTitle => 'Immobilien-Yogas';

  @override
  String get drainsLabel => 'VERLUSTE';

  @override
  String get boostersLabel => 'VERSTÄRKER';

  @override
  String get propertyTrendTitle => 'Immobilientrend';

  @override
  String get buyingWindowsTitle => 'Kauffenster';

  @override
  String get constructionWindowsTitle => 'Baufenster';

  @override
  String get maternalInherPctLabel => 'MÜTTERLICHES ERBE %';

  @override
  String get paternalInherPctLabel => 'VÄTERLICHES ERBE %';

  @override
  String get multiHomePctLabel => 'MEHRERE WOHNUNGEN %';

  @override
  String get investmentPctLabel => 'INVESTITION %';

  @override
  String get vehicleProfileTitle => 'Fahrzeugprofil';

  @override
  String get countLabel => 'ANZAHL';

  @override
  String get firstAgeLabel => 'ERSTES ALTER';

  @override
  String get categoryLabel => 'KATEGORIE';

  @override
  String get luxuryLabel => 'LUXUS';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'Anzahl im Leben: $count · Erfüllung: $pct%';
  }

  @override
  String get pressureWord => 'DRUCK';

  @override
  String get protectionWord => 'SCHUTZ';

  @override
  String get astrologicalWord => 'Astrologisch';

  @override
  String get keyRisksHeader1 => 'Wichtigste';

  @override
  String get keyRisksHeader2 => 'Risiken';

  @override
  String get reportCopiedShort => 'Bericht kopiert!';

  @override
  String get keyScoresLabel => 'WICHTIGSTE SCORES';

  @override
  String allScoresCountLabel(int count) {
    return 'Alle Scores ($count)';
  }

  @override
  String get windowsWord => 'Zeitfenster';

  @override
  String get genericFailedMsg => 'Fehlgeschlagen';

  @override
  String get unknownWord => 'Unbekannt';

  @override
  String selectKarmaChartsLabel(int max) {
    return '2-$max Charts auswählen';
  }

  @override
  String selectChartsLabelCount(int max) {
    return '$max Charts auswählen';
  }

  @override
  String runningAnalysisLabel(String label) {
    return '$label-Analyse wird ausgeführt...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'Wähle 2 bis $max Charts, um karmische Verbindungen zu analysieren';
  }

  @override
  String get pickMaleFemaleHint =>
      'Wähle ein männliches und ein weibliches Chart';

  @override
  String get personOneLabel => 'Person 1';

  @override
  String get personTwoLabel => 'Person 2';

  @override
  String get analysisFailedMsg => 'Analyse fehlgeschlagen';

  @override
  String analyzeChartsCountLabel(int count) {
    return '$count Charts analysieren';
  }

  @override
  String get contextGeneralLabel => 'Allgemein';

  @override
  String get contextLoveLabel => 'Liebe';

  @override
  String get contextBusinessLabel => 'Geschäft';

  @override
  String get contextFamilyLabel => 'Familie';

  @override
  String get contextTeamLabel => 'Team';

  @override
  String get contextFriendshipLabel => 'Freundschaft';

  @override
  String get relationshipIntelTitle => 'Beziehungsanalyse';

  @override
  String analyzingChartsCountLabel(int count) {
    return '$count Charts werden analysiert...';
  }

  @override
  String get relationshipContextLabel => 'Beziehungskontext';

  @override
  String get kundliMilanReportTitle => 'Kundli-Milan-Bericht';

  @override
  String get runningMilanAnalysisLabel => 'Milan-Analyse wird ausgeführt...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '$count/2 ausgewählt';
  }

  @override
  String get runMilanAnalysisBtn => 'Milan-Analyse ausführen';

  @override
  String get noChartsCreateFirst =>
      'Keine Charts. Erstelle zuerst ein Geburtschart.';

  @override
  String get selectBirthChartAnalyze => 'Wähle ein Geburtschart zur Analyse';

  @override
  String get doshAnalysis => 'Dosha-Analyse';

  @override
  String doshActiveCount(Object active, Object total) {
    return '$active aktiv / $total geprüft';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '$active aktiv / $total Yogas geprüft';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'AKTIVE YOGAS ($count)';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'Inaktive Yogas ausblenden ($count)';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'Inaktive Yogas anzeigen ($count)';
  }

  @override
  String get loadFailed => 'Fehlgeschlagen';

  @override
  String dashaDrillMd(Object planet) {
    return '$planet MD → Antardashas';
  }

  @override
  String dashaDrillAd(Object planet) {
    return '$planet AD → Pratyantardashas';
  }

  @override
  String dashaDrillPd(Object planet) {
    return '$planet PD → Sookshmadashas';
  }

  @override
  String dashaDrillSub(Object planet) {
    return '$planet Unterperioden';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return 'Geburtsherr: $lord • Rest: $balance Jahre';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'Lagna: $lagna • Rest: $balance Jahre';
  }

  @override
  String dashaYearsValue(Object years) {
    return '$years Jahre';
  }

  @override
  String get dashaCurrentPeriod => 'Aktuelle Dasha-Periode';

  @override
  String dashaAsOf(Object date) {
    return 'Stand: $date';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'Aktive Yogas in der aktuellen Periode ($count)';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'Aktive Doshas in der aktuellen Periode ($count)';
  }

  @override
  String get dashaNoYogasTriggered => 'Keine Yogas ausgelöst';

  @override
  String get dashaNoDoshasTriggered => 'Keine Doshas ausgelöst';

  @override
  String get divD1Name => 'Rasi (D-1)';

  @override
  String get divD1Desc => 'Physische Existenz, alle Angelegenheiten';

  @override
  String get divD2Name => 'Hora (D-2)';

  @override
  String get divD2Desc => 'Vermögen, Geld';

  @override
  String get divD3Name => 'Drekkana (D-3)';

  @override
  String get divD3Desc => 'Geschwister, Mut';

  @override
  String get divD4Name => 'Chaturthamsa (D-4)';

  @override
  String get divD4Desc => 'Immobilien, Wohnsitz, Glück';

  @override
  String get divD5Name => 'Panchamsa (D-5)';

  @override
  String get divD5Desc => 'Ruhm, Autorität, Macht';

  @override
  String get divD6Name => 'Shashthamsa (D-6)';

  @override
  String get divD6Desc => 'Gesundheitliche Probleme';

  @override
  String get divD7Name => 'Saptamsa (D-7)';

  @override
  String get divD7Desc => 'Kinder, Enkelkinder';

  @override
  String get divD8Name => 'Ashtamsa (D-8)';

  @override
  String get divD8Desc => 'Plötzliche Schwierigkeiten, Rechtsstreit';

  @override
  String get divD9Name => 'Navamsha (D-9)';

  @override
  String get divD9Desc => 'Ehe, Ehepartner, Dharma';

  @override
  String get divD10Name => 'Dasamsha (D-10)';

  @override
  String get divD10Desc => 'Karriere, Beruf';

  @override
  String get divD11Name => 'Rudramsha (D-11)';

  @override
  String get divD11Desc => 'Tod, Zerstörung';

  @override
  String get divD12Name => 'Dwadasamsha (D-12)';

  @override
  String get divD12Desc => 'Eltern, Blutsverwandte';

  @override
  String get divD16Name => 'Shodasamsha (D-16)';

  @override
  String get divD16Desc => 'Fahrzeuge, Komfort, Vergnügen';

  @override
  String get divD20Name => 'Vimsamsha (D-20)';

  @override
  String get divD20Desc => 'Spirituelle Angelegenheiten, religiös';

  @override
  String get divD24Name => 'Chaturvimsamsha (D-24)';

  @override
  String get divD24Desc => 'Lernen, Wissen, Bildung';

  @override
  String get divD27Name => 'Nakshatramsha (D-27)';

  @override
  String get divD27Desc => 'Stärken, Schwächen, Natur';

  @override
  String get divD30Name => 'Trimsamsha (D-30)';

  @override
  String get divD30Desc => 'Übel, Unterbewusstsein, Strafe';

  @override
  String get divD40Name => 'Khavedamsha (D-40)';

  @override
  String get divD40Desc => 'Günstig/ungünstig (mütterlich)';

  @override
  String get divD45Name => 'Akshavedamsha (D-45)';

  @override
  String get divD45Desc => 'Alle Angelegenheiten (väterlich)';

  @override
  String get divD60Name => 'Shashtyamsha (D-60)';

  @override
  String get divD60Desc => 'Karma aus früherem Leben — AM WICHTIGSTEN';

  @override
  String get lifeAreaCareer => 'Karriere';

  @override
  String get lifeAreaWealth => 'Vermögen';

  @override
  String get lifeAreaMarriage => 'Ehe';

  @override
  String get lifeAreaHealth => 'Gesundheit';

  @override
  String get lifeAreaSpirituality => 'Spiritualität';

  @override
  String lifeAreaGrade(Object grade) {
    return 'Note: $grade';
  }

  @override
  String get lifeAreaFactorsLabel => 'Faktoren:';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return 'Nak: $nakshatra ($pada)';
  }

  @override
  String planetNakLord(Object lord) {
    return 'NL: $lord';
  }

  @override
  String planetLongitude(Object value) {
    return 'Länge: $value°';
  }

  @override
  String get chakraOverallHealth => 'Gesamtgesundheit';

  @override
  String get careerWord => 'Karriere';

  @override
  String get failedToLoad => 'Laden fehlgeschlagen';

  @override
  String get kundliAscendantLagna => 'Aszendent (Lagna)';

  @override
  String get kundliMoonSignRashi => 'Mondzeichen (Rashi)';

  @override
  String get kundliSunSign => 'Sonnenzeichen';

  @override
  String kundliEngineLabel(Object engine) {
    return 'Engine: $engine';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return 'Grad: $degree°  •  Nakshatra: $nakshatra ($pada)';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'Nakshatra-Herr: $lord  •  Würde: $dignity';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return '$base-Chart — $sign';
  }

  @override
  String kundliBaseChart(Object base) {
    return '$base-Chart';
  }

  @override
  String get careerSummary => 'Karrierezusammenfassung';

  @override
  String get phase => 'Phase';

  @override
  String get confidenceLabel => 'Konfidenz';

  @override
  String get careerScores => 'Karriere-Scores';

  @override
  String get stabilityLabel => 'Stabilität';

  @override
  String get growthLabel => 'Wachstum';

  @override
  String get gradeExcellent => 'Ausgezeichnet';

  @override
  String get gradeGood => 'Gut';

  @override
  String get gradeAverage => 'Durchschnittlich';

  @override
  String get gradeBelowAvg => 'Unterdurchschnittlich';

  @override
  String get gradeWeak => 'Schwach';

  @override
  String get careerTypeDomain => 'Karriere & Bereich';

  @override
  String get careerTimeline => 'Karriere-Zeitlinie';

  @override
  String dashaLabel(Object dasha) {
    return 'Dasha: $dasha';
  }

  @override
  String get improvementSuggestions => 'Verbesserungsvorschläge';

  @override
  String get chartDetails => 'Chart-Details';

  @override
  String get keyHousesCareer => 'Wichtige Häuser (Karriere)';

  @override
  String get keyCareerPlanets => 'Wichtige Karriere-Planeten';

  @override
  String get empty => 'Leer';

  @override
  String get guna => 'Guna';

  @override
  String get dasha => 'Dasha';

  @override
  String get satwik => 'Satwik';

  @override
  String get rajasik => 'Rajasik';

  @override
  String get tamasik => 'Tamasik';

  @override
  String get charGroupCorePersonality => 'Kernpersönlichkeit';

  @override
  String get charGroupTrustHonesty => 'Vertrauen & Ehrlichkeit';

  @override
  String get charGroupLoyaltyCommitment => 'Loyalität & Bindung';

  @override
  String get charGroupStrategicPrivacy => 'Strategie & Privatsphäre';

  @override
  String get charGroupFinancial => 'Finanziell';

  @override
  String get charGroupAngerConflict => 'Ärger & Konflikt';

  @override
  String get charGroupMoralDharmic => 'Moralisch & Dharmisch';

  @override
  String get charGroupIntellectCommunication => 'Intellekt & Kommunikation';

  @override
  String get charGroupEmotionalProfile => 'Emotionales Profil';

  @override
  String get charGroupMentalHealth => 'Mentale Gesundheit';

  @override
  String get charGroupRomantic => 'Romantisch';

  @override
  String get charGroupMarriageFamily => 'Ehe & Familie';

  @override
  String get charGroupOverallLife => 'Leben insgesamt';

  @override
  String get grahaDrishti => 'Graha Drishti (Planetenaspekte)';

  @override
  String get grahaDrishtiSubtitle => 'Wer aspektiert wen (%)';

  @override
  String get lagnaAspectsReceived => 'Von der Lagna empfangene Aspekte';

  @override
  String get rashiDrishti => 'Rashi Drishti (Zeichenaspekte)';

  @override
  String get shadbalaRupas => 'Rupas';

  @override
  String get bhavaHouse1 => 'Selbst / Körper';

  @override
  String get bhavaHouse2 => 'Vermögen / Familie';

  @override
  String get bhavaHouse3 => 'Geschwister / Mut';

  @override
  String get bhavaHouse4 => 'Zuhause / Mutter';

  @override
  String get bhavaHouse5 => 'Kinder / Intellekt';

  @override
  String get bhavaHouse6 => 'Feinde / Gesundheit';

  @override
  String get bhavaHouse7 => 'Ehe / Partner';

  @override
  String get bhavaHouse8 => 'Langlebigkeit';

  @override
  String get bhavaHouse9 => 'Glück / Guru';

  @override
  String get bhavaHouse10 => 'Karriere / Vater';

  @override
  String get bhavaHouse11 => 'Gewinne / Freunde';

  @override
  String get bhavaHouse12 => 'Verlust / Moksha';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '$sign • Herr: $lord';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: $value';
  }

  @override
  String get sarvaAshtakavarga => 'Sarva Ashtakavarga (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'Gesamt: $total Rekhas (Durchschnittszeichen = $avg)';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '$planet — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'Gesamt: $total Rekhas • Am Geburtszeichen: $score';
  }

  @override
  String get today => 'Heute';

  @override
  String gocharTransitScores(Object date) {
    return 'Gochar (Transit-Scores) — $date';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'Geburtsmond: $sign';
  }

  @override
  String get gocharBest => 'BESTE';

  @override
  String get gocharWorst => 'SCHLECHTESTE';

  @override
  String copiedOpening(Object ai) {
    return 'Kopiert! $ai wird geöffnet...';
  }

  @override
  String get openLink => 'ÖFFNEN ↗';

  @override
  String get discussReportWithAI => 'DIESEN BERICHT MIT KI BESPRECHEN';

  @override
  String get reliabilityHigh => 'Hohe Zuverlässigkeit';

  @override
  String get reliabilityModerate => 'Mäßige Zuverlässigkeit';

  @override
  String get reliabilityLow => 'Niedriger — nur zur Orientierung';

  @override
  String get reliabilityGoodEdu => 'Gute Zuverlässigkeit · D-24 bestätigt';

  @override
  String get relationshipWord => 'Beziehung';

  @override
  String get intelligenceWord => 'Analyse';

  @override
  String get relationshipIntelligence => 'BEZIEHUNGSANALYSE';

  @override
  String get typeLabel => 'TYP';

  @override
  String get trustLabel => 'VERTRAUEN';

  @override
  String get dhokaRisk => 'VERRATSRISIKO';

  @override
  String get powerLabel => 'Macht';

  @override
  String get integrity => 'Integrität';

  @override
  String get warmth => 'Wärme';

  @override
  String get trustWord => 'Vertrauen';

  @override
  String get assertLabel => 'Durchsetzung';

  @override
  String get character => 'Charakter';

  @override
  String get love => 'Liebe';

  @override
  String get businessWord => 'Geschäft';

  @override
  String get karmic => 'Karmisch';

  @override
  String get enmityRisk => 'Feindschaftsrisiko';

  @override
  String get hdrChartProfiles => 'Chart-Profile';

  @override
  String get hdrPairwiseAnalysis => 'Paarweise Analyse';

  @override
  String get hdrCriticalPatterns => 'Kritische Muster';

  @override
  String get hdrGroupRecommendations => 'Gruppenempfehlungen';

  @override
  String get sharedPractices => 'GEMEINSAME PRAKTIKEN';

  @override
  String get hdrIndividualGuidance => 'Individuelle Anleitung';

  @override
  String get growthAreas => 'WACHSTUMSBEREICHE';

  @override
  String get hdrCoreTheme => 'Kernthema';

  @override
  String get growthOriented => 'WACHSTUMSORIENTIERT';

  @override
  String get groupTheme => 'GRUPPENTHEMA';

  @override
  String get compatibility => 'KOMPATIBILITÄT';

  @override
  String get unifiedScoreLabel => 'EINHEITLICHER SCORE';

  @override
  String get ashtakoot => 'ASHTAKOOT';

  @override
  String get probability => 'WAHRSCHEINLICHKEIT';

  @override
  String get hdrAshtakootSummary => 'Ashtakoot-Zusammenfassung';

  @override
  String get hdrGunBreakdown => '8-Gun-Aufschlüsselung';

  @override
  String get hdrMangalDosh => 'Mangal Dosh';

  @override
  String get hdrD9CrossChart => 'D-9-Kreuzchart';

  @override
  String get d9Compatibility => 'D-9-KOMPATIBILITÄT';

  @override
  String get hdrDomainCompatibility => 'Bereichs-Kompatibilität';

  @override
  String get emotional => 'Emotional';

  @override
  String get intellectual => 'Intellektuell';

  @override
  String get spiritual => 'Spirituell';

  @override
  String get financial => 'Finanziell';

  @override
  String get domestic => 'Häuslich';

  @override
  String get communicationWord => 'Kommunikation';

  @override
  String get sharedDharma => 'Gemeinsames Dharma';

  @override
  String get familyCreation => 'Familiengründung';

  @override
  String get hdrMarriageTiming => 'Heirats-Timing';

  @override
  String get jointMarriageWindows => 'Gemeinsame Heiratsfenster';

  @override
  String get engagementWindows => 'Verlobungsfenster';

  @override
  String get recommendedLabel => 'Empfohlen';

  @override
  String get hdrKeyRisks => 'Wichtigste Risiken';

  @override
  String get hdrFinalVerdict => 'Abschließendes Urteil';

  @override
  String get marriageVerdict => 'EHE-URTEIL';

  @override
  String get educationWord => 'Bildung';

  @override
  String get learningSuffix => '& Lernen';

  @override
  String get coreEducationScores => 'KERN-BILDUNGS-SCORES';

  @override
  String get academicSuccess => 'AKADEMISCHER ERFOLG';

  @override
  String get learningCapacity => 'LERNFÄHIGKEIT';

  @override
  String get memory => 'GEDÄCHTNIS';

  @override
  String get intelligence => 'INTELLIGENZ';

  @override
  String get research => 'FORSCHUNG';

  @override
  String get hdrIntellectualProfile => 'Intellektuelles Profil';

  @override
  String get learningSignature => 'LERNSIGNATUR';

  @override
  String get hdrSubjectKaraka => 'Fach-Karaka';

  @override
  String get hdrHouseFoundations => 'Hausfundamente';

  @override
  String get hdrMercuryJupiter => 'Merkur & Jupiter';

  @override
  String get hdrEducationYogas => 'Bildungs-Yogas';

  @override
  String get hdrDivisionalValidation => 'Bestätigung durch Divisionscharts';

  @override
  String get standing => 'STATUS';

  @override
  String get hdrSubjectRanking => 'Fach-Rangliste';

  @override
  String get hdrDegreeLikelihood => 'Wahrscheinlichkeit des Abschlusses';

  @override
  String get hdrStudyPeriods => 'Studienperioden';

  @override
  String get earlySchooling => 'Frühe Schulzeit';

  @override
  String get higherEducation => 'Höhere Bildung';

  @override
  String get postgradResearch => 'Postgraduiert · Forschung';

  @override
  String get hdrLearningPreferences => 'Lernpräferenzen';

  @override
  String get hdrChallengesGifts => 'Herausforderungen & Begabungen';

  @override
  String get challenges => 'HERAUSFORDERUNGEN';

  @override
  String get cognitiveGifts => 'KOGNITIVE BEGABUNGEN';

  @override
  String get naturalAbilities => 'NATÜRLICHE FÄHIGKEITEN';

  @override
  String get hdrSaraswatiRemedies => 'Saraswati-Heilmittel';

  @override
  String get studentVerdict => 'SCHÜLER-URTEIL';

  @override
  String get educationCareerLinkage => 'BILDUNG → KARRIERE-VERKNÜPFUNG';

  @override
  String get startupSuffix => '& Startup';

  @override
  String get coreBusinessScores => 'KERN-GESCHÄFTS-SCORES';

  @override
  String get overallBusiness => 'GESCHÄFT INSGESAMT';

  @override
  String get ventureSuccess => 'UNTERNEHMENSERFOLG';

  @override
  String get eleventhHouse => '11. HAUS';

  @override
  String get gains => 'GEWINNE';

  @override
  String get investor => 'INVESTOR';

  @override
  String get hdrFounderArchetype => 'Gründer-Archetyp';

  @override
  String get hdrTenthEleventhHouses => '10. & 11. Haus';

  @override
  String get hdrBusinessYogas => 'Geschäfts-Yogas';

  @override
  String get hdrRecommendedDomains => 'Empfohlene Bereiche';

  @override
  String get hdrBusinessStyle => 'Geschäftsstil';

  @override
  String get hdrFounderSkills => 'Gründerfähigkeiten';

  @override
  String get hdrFundingProfile => 'Finanzierungsprofil';

  @override
  String get recommendedPath => 'EMPFOHLENER WEG';

  @override
  String get investorAttract => 'INVESTORENANZIEHUNG';

  @override
  String get familyBacking => 'FAMILIÄRE UNTERSTÜTZUNG';

  @override
  String get hybridViability => 'HYBRID-MACHBARKEIT';

  @override
  String get launchWindow => 'Startfenster';

  @override
  String get scaleWindow => 'Wachstumsfenster';

  @override
  String get hdrBusinessRisks => 'Geschäftsrisiken';

  @override
  String get recoveryCapacity => 'ERHOLUNGSKAPAZITÄT';

  @override
  String get hdrRemediesSolutions => 'Heilmittel & Lösungen';

  @override
  String get aiConnectionLost =>
      'Verbindung verloren. Bitte versuche es erneut.';

  @override
  String get aiSomethingWrong => 'Etwas ist schiefgelaufen';

  @override
  String get aiNoResponse => 'Keine Antwort';

  @override
  String get aiConnectionError =>
      'Verbindungsfehler. Bitte versuche es erneut.';

  @override
  String get aiAutoDetect => 'Automatisch erkennen';

  @override
  String aiAutoArrow(String lang) {
    return 'Automatisch → $lang';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'Sprache: $lang';
  }

  @override
  String get aiNoBirthCharts => 'Keine Geburtscharts gefunden';

  @override
  String get aiCreateChartFirst =>
      'Erstelle zuerst ein Geburtschart, um mit der KI zu chatten';

  @override
  String get aiSelectChartBegin =>
      'Wähle ein Geburtschart, um die Analyse zu beginnen';

  @override
  String aiAnalyzingName(String name) {
    return 'Analysiere: $name';
  }

  @override
  String get aiChange => 'Ändern';

  @override
  String get aiAnalyzingChart => 'Dein Chart wird analysiert...';

  @override
  String get aiAskStarsHint => 'Frag die Sterne alles...';

  @override
  String get aiSuggestedFollowups => 'Vorgeschlagene Folgefragen';

  @override
  String get aiThinking => 'Denkt nach...';

  @override
  String get aiThanks => 'Danke!';

  @override
  String get aiFeedbackNoted => 'Feedback vermerkt';

  @override
  String get svcAll => 'Alle';

  @override
  String get svcNoServices => 'Keine Dienste verfügbar';

  @override
  String get svcFree => 'KOSTENLOS';

  @override
  String get astroFailedStartCall => 'Anruf konnte nicht gestartet werden';

  @override
  String get astroFailedStartChat => 'Chat konnte nicht gestartet werden';

  @override
  String astroErrorDetail(String error) {
    return 'Fehler: $error';
  }

  @override
  String get astroExperience => 'Erfahrung';

  @override
  String get astroSessions => 'Sitzungen';

  @override
  String get astroMinutes => 'Minuten';

  @override
  String get astroAbout => 'Über';

  @override
  String get astroLanguages => 'Sprachen';

  @override
  String get astroRateCard => 'Preistabelle';

  @override
  String get astroVoice => 'Stimme';

  @override
  String astroReviews(int count) {
    return 'Bewertungen ($count)';
  }

  @override
  String get astroNoReviews => 'Noch keine Bewertungen';

  @override
  String get astroAnonymous => 'Anonym';

  @override
  String get forgotPasswordSubtitle =>
      'Gib deine E-Mail-Adresse ein und wir senden dir\neinen Link zum Zurücksetzen deines Passworts.';

  @override
  String get emailHint => 'deine@email.com';

  @override
  String get resendLink => 'Link erneut senden';

  @override
  String get appName => 'Nakshatralogy';

  @override
  String get cosmicJourneyAwaits => 'Deine kosmische Reise wartet';

  @override
  String get home => 'Startseite';

  @override
  String get astrologers => 'Astrologen';

  @override
  String get services => 'Dienste';

  @override
  String get wallet => 'Wallet';

  @override
  String get profile => 'Profil';

  @override
  String get live => 'Live';

  @override
  String get kundli => 'Kundli';

  @override
  String get chat => 'Chat';

  @override
  String get call => 'Anruf';

  @override
  String get video => 'Video';

  @override
  String get signIn => 'Anmelden';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get phone => 'Telefon';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get sendResetLink => 'Reset-Link senden';

  @override
  String get backToSignIn => 'Zurück zur Anmeldung';

  @override
  String get dontHaveAccount => 'Du hast noch kein Konto?';

  @override
  String get alreadyHaveAccount => 'Du hast bereits ein Konto?';

  @override
  String get continueGoogle => 'Mit Google fortfahren';

  @override
  String get required => 'Erforderlich';

  @override
  String get minSixChars => 'Mind. 6 Zeichen';

  @override
  String get passwordsMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get validEmailRequired => 'Gültige E-Mail-Adresse erforderlich';

  @override
  String get loginFailed => 'Anmeldung fehlgeschlagen';

  @override
  String get signupFailed => 'Registrierung fehlgeschlagen';

  @override
  String get welcomeBack => 'Willkommen zurück';

  @override
  String get todaysHoroscope => 'HEUTIGES HOROSKOP';

  @override
  String get todaysRashi => 'Heutiges Rashi';

  @override
  String get tapDetails => 'Für Details tippen';

  @override
  String get allServices => 'Alle Dienste';

  @override
  String get seeAll => 'ALLE ANZEIGEN';

  @override
  String get topAstrologers => 'Top-Astrologen';

  @override
  String get onlineExperts => 'Online-Experten bereit für Beratung';

  @override
  String get searchAstrologers => 'Astrologen suchen...';

  @override
  String get noAstrologersFound => 'Keine Astrologen gefunden';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get busy => 'Beschäftigt';

  @override
  String get perMin => '/Min';

  @override
  String get noCharts => 'Noch keine Geburtscharts';

  @override
  String get createFirst => 'Erstelle dein erstes Janam Kundli';

  @override
  String get createChart => 'Chart erstellen';

  @override
  String get newBirthChart => 'Neues Geburtschart';

  @override
  String get clientName => 'Name des Klienten';

  @override
  String get gender => 'Geschlecht';

  @override
  String get male => 'Männlich';

  @override
  String get female => 'Weiblich';

  @override
  String get other => 'Andere';

  @override
  String get dateOfBirth => 'Geburtsdatum';

  @override
  String get timeOfBirth => 'Geburtszeit';

  @override
  String get birthPlace => 'Geburtsort';

  @override
  String get birthPlaceHint => 'Stadtname zur Suche eingeben...';

  @override
  String get generateKundli => 'Kundli erstellen';

  @override
  String get birthChartCreated => 'Geburtschart erstellt!';

  @override
  String get deleteChart => 'Chart löschen?';

  @override
  String get cannotUndo => 'Dies kann nicht rückgängig gemacht werden.';

  @override
  String get primary => 'PRIMÄR';

  @override
  String get viewKundli => 'Kundli ansehen';

  @override
  String get completeBirthChart => 'Vollständiges Geburtschart';

  @override
  String get birthDetails => 'Geburtsdetails';

  @override
  String get name => 'Name';

  @override
  String get dob => 'Geburtsdatum';

  @override
  String get tob => 'Geburtszeit';

  @override
  String get place => 'Ort';

  @override
  String get summary => 'Zusammenfassung';

  @override
  String get planets => 'Planeten';

  @override
  String get divisions => 'Divisionscharts';

  @override
  String get vimshottari => 'Vimshottari';

  @override
  String get moola => 'Moola';

  @override
  String get gochar => 'Gochar';

  @override
  String get dosh => 'Dosh';

  @override
  String get yoga => 'Yoga';

  @override
  String get shadbala => 'Shadbala';

  @override
  String get ashtakavarga => 'Ashtakavarga';

  @override
  String get aspects => 'Aspekte';

  @override
  String get lifeAreas => 'Lebensbereiche';

  @override
  String get bhava => 'Bhava';

  @override
  String get chakras => 'Chakras';

  @override
  String get dashaActive => 'Aktive Dasha';

  @override
  String get lagna => 'Lagna';

  @override
  String get moon => 'Mond';

  @override
  String get sun => 'Sonne';

  @override
  String get premiumSection => 'Premium-Bereich';

  @override
  String get unlockReading =>
      'Schalte diese Deutung frei, um die detaillierte Analyse zu sehen.';

  @override
  String get unlock => 'Freischalten';

  @override
  String get retrograde => 'Rückläufig';

  @override
  String get combust => 'Kombust';

  @override
  String get vargottama => 'Vargottama';

  @override
  String get exalted => 'Exaltiert';

  @override
  String get debilitated => 'Geschwächt';

  @override
  String get addBalance => 'Guthaben hinzufügen';

  @override
  String get amount => 'Betrag';

  @override
  String get walletBalance => 'Wallet-Guthaben';

  @override
  String get recharge => 'Aufladen';

  @override
  String get bonus => 'Bonus';

  @override
  String get serviceLabel => 'Dienst';

  @override
  String get refund => 'Rückerstattung';

  @override
  String get noTransactions => 'Keine Transaktionen';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get savedAstrologers => 'Gespeicherte Astrologen';

  @override
  String get noSavedAstrologers => 'Noch keine gespeicherten Astrologen';

  @override
  String get myOrders => 'Meine Bestellungen';

  @override
  String get communicationHistory => 'Kommunikationsverlauf';

  @override
  String get chatHistory => 'Chat-Verlauf';

  @override
  String get callHistory => 'Anrufverlauf';

  @override
  String get logout => 'Abmelden';

  @override
  String get chatMessages => 'Chat-Nachrichten';

  @override
  String get typeMessage => 'Nachricht eingeben...';

  @override
  String get sessionEnded => 'Sitzung beendet';

  @override
  String get endChat => 'Chat beenden?';

  @override
  String get endChatConfirm =>
      'Bist du sicher, dass du diese Chat-Sitzung beenden möchtest?';

  @override
  String get sendPhoto => 'Foto senden';

  @override
  String get sendPDF => 'PDF senden';

  @override
  String get upload => 'Hochladen';

  @override
  String get fileNotFound => 'Datei nicht gefunden';

  @override
  String get voiceCall => 'Sprachanruf';

  @override
  String get videoCall => 'Videoanruf';

  @override
  String get ringing => 'Klingelt...';

  @override
  String get connected => 'VERBUNDEN';

  @override
  String get endCall => 'Anruf beenden';

  @override
  String get mute => 'Stummschalten';

  @override
  String get unmute => 'Stummschaltung aufheben';

  @override
  String get speaker => 'Lautsprecher';

  @override
  String get camera => 'Kamera';

  @override
  String get flip => 'Umschalten';

  @override
  String get liveStreams => 'Live-Streams';

  @override
  String get noLiveStreams => 'Derzeit keine Live-Streams';

  @override
  String get astrologerUnavailable =>
      'Astrologe nicht verfügbar. Stream wird beendet.';

  @override
  String get streamEnded => 'Stream beendet';

  @override
  String get superChat => 'Super-Chat';

  @override
  String get sendGift => 'Geschenk senden';

  @override
  String get goBack => 'Zurück';

  @override
  String get appPermissions => 'App-Berechtigungen';

  @override
  String get grantPermissions => 'Berechtigungen erteilen';

  @override
  String get skipForNow => 'Vorerst überspringen';

  @override
  String get microphone => 'Mikrofon';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get storage => 'Speicher';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get send => 'Senden';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get noData => 'Keine Daten verfügbar';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolg';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get language => 'Sprache';

  @override
  String get english => 'Englisch';

  @override
  String get myDetails => 'Meine Daten';

  @override
  String get myKundlis => 'Meine Kundlis';

  @override
  String get walletRecharge => 'Wallet & Aufladen';

  @override
  String get consultationHistory => 'Beratungsverlauf';

  @override
  String get helpSupport => 'Hilfe & Support';

  @override
  String get biometricLogin => 'Biometrische Anmeldung';

  @override
  String get pastVoiceConsultations => 'Frühere Sprachberatungen';

  @override
  String get pastTextConversations => 'Frühere Textgespräche';

  @override
  String get comingSoon => 'Demnächst verfügbar';

  @override
  String get totalCredit => 'Gesamtguthaben';

  @override
  String get totalDebit => 'Gesamtbelastung';

  @override
  String get statement => 'Kontoauszug';

  @override
  String get allTypes => 'Alle Arten';

  @override
  String get prev => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get allInsights => 'Alle Einblicke';

  @override
  String get yourCompleteReading => 'DEINE VOLLSTÄNDIGE DEUTUNG';

  @override
  String get expertEngines => 'Experten-Engines';

  @override
  String get eachInsightConsultation =>
      'Jeder Einblick ist eine vollständige Beratung';

  @override
  String get engines => 'ENGINES';

  @override
  String get dataPoints => 'DATENPUNKTE';

  @override
  String get singleChart => 'EINZELN';

  @override
  String get careerPurpose => 'KARRIERE & ZWECK';

  @override
  String get wealthAssets => 'VERMÖGEN & BESITZ';

  @override
  String get loveRelationships => 'LIEBE & BEZIEHUNGEN';

  @override
  String get healthWellness => 'GESUNDHEIT & WOHLBEFINDEN';

  @override
  String get soulKarma => 'SEELE & KARMA';

  @override
  String get specialistReports => 'Spezialberichte';

  @override
  String get searchByNameSpeciality => 'Suche nach Name, Spezialgebiet...';

  @override
  String get sortedByRating => 'Nach Bewertung sortiert';

  @override
  String get initiatingChat => 'Chat wird gestartet...';

  @override
  String get startingCall => 'Anruf wird gestartet...';

  @override
  String get yrs => 'Jahre';

  @override
  String get chatWithAISpecialist => 'Mit KI-Spezialist chatten';

  @override
  String get tapToStart => 'Zum Starten tippen';

  @override
  String get astrologer => 'Astrologe';

  @override
  String get reports => 'Berichte';

  @override
  String get milan => 'Milan';

  @override
  String get forecast => 'Prognose';

  @override
  String get rashi => 'Rashi';

  @override
  String get jupiterFavorsBold => 'Jupiter begünstigt mutige Schritte';

  @override
  String get careerIlluminated =>
      'Dein Karrierebereich ist erleuchtet — vertraue deinen Instinkten.';

  @override
  String get todaysForecast => 'Heutige Prognose';

  @override
  String get engCareer => 'Karriere & Beruf';

  @override
  String get engBusiness => 'Geschäft & Startup';

  @override
  String get engEducation => 'Bildung & Lernen';

  @override
  String get engLifePath => 'Lebensweg & Glück';

  @override
  String get engWealth => 'Vermögen & Finanzen';

  @override
  String get engDebt => 'Schulden & Erholung';

  @override
  String get engProperty => 'Immobilien & Vermögen';

  @override
  String get engLegal => 'Recht & Streitigkeiten';

  @override
  String get engLove => 'Liebe & Romantik';

  @override
  String get engMarriage => 'Ehe & Familie';

  @override
  String get engKundliMilan => 'Kundli Milan';

  @override
  String get engRelationship => 'Beziehungsanalyse';

  @override
  String get engLoveCompat => 'Liebeskompatibilität';

  @override
  String get engChildProb => 'Kinderwahrscheinlichkeit';

  @override
  String get engHealth => 'Gesundheit & Wellness';

  @override
  String get engMental => 'Mentale Gesundheit & Stress';

  @override
  String get engCharacter => 'Charakteranalyse';

  @override
  String get engPastLife => 'Früheres Leben & Karma';

  @override
  String get engKarmaLink => 'Karma-Verbindung';

  @override
  String get noChatSessions => 'Noch keine Chat-Sitzungen';

  @override
  String get chatAppearHere =>
      'Deine Gespräche mit Astrologen werden hier angezeigt.';

  @override
  String get noCallsYet => 'Noch keine Anrufe';

  @override
  String get callAppearHere =>
      'Dein Anrufverlauf mit Astrologen wird hier angezeigt.';

  @override
  String get chatWith => 'Chatten mit';

  @override
  String get msgs => 'Nachrichten';

  @override
  String get voiceCallLabel => 'Sprachanruf';

  @override
  String get videoCallLabel => 'Videoanruf';

  @override
  String get pullToRefresh => 'Zum Aktualisieren nach unten ziehen';

  @override
  String get sessionExpired => 'Sitzung abgelaufen';

  @override
  String get connectionFailed => 'Verbindung fehlgeschlagen';

  @override
  String get callActive => 'Anruf aktiv';

  @override
  String get lessThanOneMin => 'Weniger als 1 Minute verbleibend';

  @override
  String get noMessages => 'Keine Nachrichten in dieser Sitzung';

  @override
  String get gocharForAllSigns => 'Heutiger Gochar für alle 12 Zeichen';

  @override
  String get selectChart => 'Wähle ein Chart zur Analyse';

  @override
  String get selectTwoCharts => 'Wähle zwei Charts';

  @override
  String get analyzing => 'Analysiere...';

  @override
  String get browseAstrologers => 'Astrologen durchsuchen';

  @override
  String get probableNumber => 'WAHRSCHEINLICHE ANZAHL';

  @override
  String get genderTendency => 'GESCHLECHTERTENDENZ';

  @override
  String get son => 'SOHN';

  @override
  String get daughter => 'TOCHTER';

  @override
  String get occupants => 'BEWOHNER';

  @override
  String get beneficAspects => 'WOHLTÄTIGE ASPEKTE';

  @override
  String get maleficAspects => 'SCHÄDLICHE ASPEKTE';

  @override
  String get nextFavorableWindow => 'NÄCHSTES GÜNSTIGES ZEITFENSTER';

  @override
  String get totalDoshaPenalty => 'GESAMTER DOSHA-ABZUG';

  @override
  String get cancellationFactors => 'AUFHEBUNGSFAKTOREN';

  @override
  String get combinedFertility => 'KOMBINIERTER FRUCHTBARKEITSHINWEIS';

  @override
  String get planetPositions => 'PLANETENPOSITIONEN';

  @override
  String get bestWindows => 'BESTE ZEITFENSTER';

  @override
  String get worstWindows => 'SCHLECHTESTE ZEITFENSTER';

  @override
  String get scoreComponents => 'SCORE-KOMPONENTEN';

  @override
  String get topOpportunities => 'TOP-CHANCEN';

  @override
  String get topRisks => 'TOP-RISIKEN';

  @override
  String get remedies => 'HEILMITTEL';

  @override
  String get keyInsights => 'WICHTIGSTE ERKENNTNISSE';

  @override
  String get overallVerdict => 'GESAMTURTEIL';

  @override
  String get venusContacts => 'VENUS-KREUZKONTAKTE';

  @override
  String get contact => 'Kontakt';

  @override
  String get effect => 'Wirkung';

  @override
  String get moonSignCompat => 'MONDZEICHEN-KOMPATIBILITÄT';

  @override
  String get hisMoon => 'SEIN MOND';

  @override
  String get herMoon => 'IHR MOND';

  @override
  String get nakshatraCompat => 'NAKSHATRA-KOMPATIBILITÄT';

  @override
  String get ketuContacts => 'KETU-KONTAKTE';

  @override
  String get rahuContacts => 'RAHU-KONTAKTE';

  @override
  String get pastLifeIndication => 'HINWEIS AUF FRÜHERES LEBEN';

  @override
  String get totalChallengePenalty => 'GESAMTER HERAUSFORDERUNGS-ABZUG';

  @override
  String get manifestation => 'MANIFESTATION';

  @override
  String get cancellation => 'AUFHEBUNG';

  @override
  String get navigation => 'NAVIGATION';

  @override
  String get potentialStrengths => 'POTENZIELLE STÄRKEN';

  @override
  String get areasToNurture => 'ZU PFLEGENDE BEREICHE';

  @override
  String get relationshipGuidance => 'BEZIEHUNGSANLEITUNG';

  @override
  String get detailedSummary => 'DETAILLIERTE ZUSAMMENFASSUNG';

  @override
  String get discussWithAI => 'MIT KI BESPRECHEN';

  @override
  String get planet => 'Planet';

  @override
  String get sign => 'Zeichen';

  @override
  String get house => 'Haus';

  @override
  String get strength => 'Stärke';

  @override
  String get copy => 'KOPIEREN';

  @override
  String get confidence => 'KONFIDENZ';

  @override
  String get d7Saptamsa => 'D7 SAPTAMSA';

  @override
  String get numberExplanation => 'ERKLÄRUNG DER ANZAHL';

  @override
  String get genderExplanation => 'GESCHLECHTSERKLÄRUNG';

  @override
  String get inFifth => 'Im 5.?';

  @override
  String get primaryArchetype => 'PRIMÄRER ARCHETYP';

  @override
  String get mitigation => 'MINDERUNG';

  @override
  String get soulCareerAlign => 'Ausrichtung Seele ↔ Karriere';

  @override
  String get favorablePeriods => 'Günstige Perioden';

  @override
  String get challengingPeriods => 'Herausfordernde Perioden';

  @override
  String get keyHouses => 'Wichtige Häuser';

  @override
  String get keyPlanets => 'Wichtige Planeten';

  @override
  String get characterOverview => 'Charakterübersicht';

  @override
  String get noYogasActive => 'Derzeit sind in diesem Chart keine Yogas aktiv.';

  @override
  String get basedOnPlanetStrengths =>
      'Basierend auf planetarischen Stärken & Hausplatzierungen';

  @override
  String get basedOnTransits =>
      'Basierend auf aktuellen planetarischen Transiten';

  @override
  String get currentPlanetPositions =>
      'Aktuelle Planetenpositionen mit deinem Zeichen als 1. Haus';

  @override
  String get favorablePeriodAdvice =>
      'Günstige Periode — konzentriere dich auf Karrierewachstum und Beziehungen.';

  @override
  String get noClassicalYogas =>
      'Ohne klassische Lern-Yogas entsteht Erfolg durch konsequenten Einsatz.';

  @override
  String get walletDeduction => 'Der Betrag wird von deinem Wallet abgezogen';

  @override
  String get bhakootAxis => 'BHAKOOT-ACHSE';

  @override
  String get basis => 'BASIS';

  @override
  String get selectChartsForMilan => 'Wähle 2 Charts für die Milan-Analyse';

  @override
  String get selectMultiCharts => 'Wähle 2–5 Charts';

  @override
  String get running => 'LAUFEND';

  @override
  String get past => 'vergangen';

  @override
  String get topActiveDoshas => 'TOP AKTIVE DOSHAS';

  @override
  String get allDoshas => 'ALLE DOSHAS';

  @override
  String get activeYogas => 'Aktive Yogas';

  @override
  String get activeDoshas => 'Aktive Doshas';

  @override
  String get yogaAnalysis => 'Yoga-Analyse';

  @override
  String get factors => 'Faktoren';

  @override
  String get dominantPlanet => 'Dominanter Planet';

  @override
  String get startSession => 'Sitzung starten';

  @override
  String get notesSaved => 'Notizen gespeichert';

  @override
  String get unlocked => 'Freigeschaltet! Viel Freude mit deiner Deutung.';

  @override
  String get todaysGochar => 'Heutiger Gochar';

  @override
  String get todaysTransitChart => 'Heutiges Transit-Chart';

  @override
  String get lifeAreaPredictions => 'Vorhersagen zu Lebensbereichen';

  @override
  String get strengths => 'Stärken';

  @override
  String get weaknesses => 'Schwächen';

  @override
  String get ruledBy => 'Regiert von';

  @override
  String get kundliMilan => 'Kundli Milan';

  @override
  String get startKundliMilan => 'Kundli Milan starten';

  @override
  String get recommendations => 'Empfehlungen';

  @override
  String get cancellations => 'Aufhebungen';

  @override
  String get dashaSync => 'Dasha-Synchronisation';

  @override
  String get transitMarriageWindows => 'Transit-Heiratsfenster';

  @override
  String get overlappingWindows => 'Überlappende Heiratsfenster';

  @override
  String get overallStrength => 'GESAMTSTÄRKE';

  @override
  String get stability => 'STABILITÄT';

  @override
  String get growth => 'WACHSTUM';

  @override
  String get clarity => 'KLARHEIT';

  @override
  String get recognition => 'ANERKENNUNG';

  @override
  String get satisfaction => 'ZUFRIEDENHEIT';

  @override
  String get verdict => 'URTEIL';

  @override
  String get topRoles => 'TOP-ROLLEN';

  @override
  String get areasForGrowth => 'WACHSTUMSBEREICHE';

  @override
  String get bestIndustries => 'BESTE BRANCHEN';

  @override
  String get employment => 'Anstellung';

  @override
  String get entrepreneurship => 'Unternehmertum';

  @override
  String get freelance => 'Freiberuflich';

  @override
  String get portfolio => 'Portfolio';

  @override
  String get burnoutRisk => 'Burnout-Risiko';

  @override
  String get careerStagnation => 'Karrierestillstand';

  @override
  String get workplaceConflict => 'Konflikt am Arbeitsplatz';

  @override
  String get positioning => 'POSITIONIERUNG';

  @override
  String get skillDevelopment => 'KOMPETENZENTWICKLUNG';

  @override
  String get network => 'NETZWERK';

  @override
  String get visibility => 'SICHTBARKEIT';

  @override
  String get lagnaLord => 'Lagna-Herr';

  @override
  String get tenthLord => '10. Herr';

  @override
  String get lord => 'HERR';

  @override
  String get lordPlacedIn => 'HERR PLATZIERT IN';

  @override
  String get lordDignity => 'WÜRDE DES HERRN';

  @override
  String get d9Dignity => 'D9-WÜRDE';

  @override
  String get careerAnalysis => 'Karriereanalyse';

  @override
  String get launchWindows => 'Startfenster';

  @override
  String get peakWindows => 'Höhepunktfenster';

  @override
  String get promotionWindows => 'Beförderungsfenster';

  @override
  String get riskWindows => 'Risikofenster';

  @override
  String get timingWindows => 'Timing-Fenster';

  @override
  String get careerRisks => 'Karriererisiken';

  @override
  String get astrologicalRemedies => 'Astrologische Heilmittel';

  @override
  String get practicalSolutions => 'Praktische Lösungen';

  @override
  String get analysisConfidence => 'Analysekonfidenz';

  @override
  String get careerArchetype => 'Karriere-Archetyp';

  @override
  String get workStructure => 'Arbeitsstruktur';

  @override
  String get teamLeadership => 'Teamführung';

  @override
  String get idealEnvironment => 'Ideale Umgebung';

  @override
  String get idealOrgSize => 'Ideale Organisationsgröße';

  @override
  String get fitScore => 'PASSUNGS-SCORE';

  @override
  String get recommended => 'EMPFOHLEN';

  @override
  String get divisionalValidation => 'Bestätigung durch Divisionscharts';

  @override
  String get houseAnalysis => 'Hausanalyse';

  @override
  String get jaiminiKarakas => 'Jaimini-Karakas';

  @override
  String get copyFullReport => 'Vollständige Berichtsdaten kopieren';

  @override
  String get reportCopied => 'Berichtsdaten kopiert!';

  @override
  String get biometricNotAvailable =>
      'Biometrie ist auf diesem Gerät nicht verfügbar';

  @override
  String biometricErrorMsg(Object error) {
    return 'Biometrie-Fehler: $error';
  }

  @override
  String get biometricVerifyReason =>
      'Bestätigen, um die biometrische Anmeldung zu aktivieren';

  @override
  String get dobFormatLabel => 'Geburtsdatum (DD/MM/YYYY)';

  @override
  String get tobFormatLabel => 'Geburtszeit (HH:MM)';

  @override
  String get phoneLabel => 'Telefon';

  @override
  String get activeBadge => 'AKTIV';

  @override
  String get chartCategoryLabel => 'Kategorie';

  @override
  String get freePrimaryDescription =>
      'Kostenlos Primär — wird für das tägliche Horoskop & kostenlose Einzelchart-Dienste verwendet';

  @override
  String get searchChartsHint => 'Nach Name oder Geburtsdatum suchen...';

  @override
  String unlockPriceLabel(Object price) {
    return 'Für $price freischalten';
  }

  @override
  String unlockAiSpecialistIntl(Object price) {
    return 'Schalte diesen KI-Spezialisten für $price (einmalig) frei, sicher über den App Store gekauft.';
  }

  @override
  String unlockAiSpecialistWallet(Object price) {
    return 'Schalte diesen KI-Spezialisten für $price (einmalig) frei. Der Betrag wird von deinem Wallet abgezogen.';
  }

  @override
  String get specialistNotAvailablePurchase =>
      'Dieser Spezialist ist noch nicht zum Kauf verfügbar.';

  @override
  String get couldNotCompletePurchase =>
      'Der Kauf konnte nicht abgeschlossen werden. Bitte versuche es erneut.';

  @override
  String get couldNotUnlockWalletBalance =>
      'Freischalten nicht möglich (Wallet-Guthaben prüfen)';

  @override
  String get freeBadge => 'KOSTENLOS';

  @override
  String activeSessionInProgress(Object kind) {
    return 'Du hast eine aktive $kind in Bearbeitung';
  }

  @override
  String get returnLabel => 'Zurückkehren';

  @override
  String get enableNotificationsForAlerts =>
      'Benachrichtigungen aktivieren, um Beratungs- & Angebotshinweise zu erhalten';

  @override
  String get enableLabel => 'Aktivieren';

  @override
  String get notificationsEnabled => 'Benachrichtigungen aktiviert';

  @override
  String get couldNotEnableNotifications =>
      'Konnte nicht aktiviert werden — erlaube Benachrichtigungen in deinem Browser';

  @override
  String get amountInrLabel => 'Betrag (₹)';

  @override
  String get noteOptionalLabel => 'Notiz (optional)';

  @override
  String get txnDate => 'DATUM';

  @override
  String get txnDescription => 'BESCHREIBUNG';

  @override
  String get txnType => 'TYP';

  @override
  String get txnAmount => 'BETRAG';

  @override
  String get txnBalance => 'KONTOSTAND';

  @override
  String get credit => 'Gutschrift';

  @override
  String get debit => 'Abbuchung';

  @override
  String get razorpayStripeNote =>
      '💳 In der Produktion wird dies zu Razorpay/Stripe weitergeleitet.';

  @override
  String get downloadPdf => 'PDF herunterladen';

  @override
  String get chatWithAiCta => 'Mit KI chatten';

  @override
  String get pdfServiceUnavailable =>
      'Der PDF-Dienst ist vorübergehend nicht verfügbar. Bitte versuche es später erneut.';

  @override
  String get pleaseUnlockFirst => 'Bitte schalte dies zuerst frei.';

  @override
  String get couldNotGeneratePdf =>
      'Die PDF konnte nicht erstellt werden. Bitte versuche es erneut.';

  @override
  String get statConsults => 'BERATUNGEN';

  @override
  String get statCharts => 'CHARTS';

  @override
  String get statWallet => 'WALLET';

  @override
  String get firstChartPrimaryInfo =>
      'Dein erstes Chart ist dein kostenloses Primär-Chart. Zusätzliche Charts schalten Dienste einzeln frei.';

  @override
  String get tryDifferentFilter => 'Versuche einen anderen Filter';

  @override
  String get defaultChartName => 'Chart';

  @override
  String get balAbbr => 'Saldo';

  @override
  String get aiTimePassTitle => 'Chat-Zeit wählen';

  @override
  String get aiTimePassHint =>
      'Bezahlung aus deinem Wallet. Die Zeit startet jetzt — ein weiterer Kauf wird zur Restzeit addiert.';

  @override
  String aiTimePlanMinutes(Object minutes) {
    return '$minutes Min.';
  }

  @override
  String aiTimePassPay(Object price) {
    return '$price bezahlen';
  }

  @override
  String aiTimeLeft(Object minutes) {
    return 'Noch $minutes Min.';
  }
}
