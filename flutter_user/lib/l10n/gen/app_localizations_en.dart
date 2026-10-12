// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get awChooseLanguage => 'Choose your language';

  @override
  String get awGoogleFailed => 'Google sign-in failed. Please try again.';

  @override
  String get awCompleteProfileTitle => 'Complete your profile';

  @override
  String awWelcomeName(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get awCompleteProfileSubtitle =>
      'A couple of details to personalize Nakshatralogy for you.';

  @override
  String get awRegionLabel => 'Region';

  @override
  String get awRegionIndia => 'India';

  @override
  String get awRegionInternational => 'International';

  @override
  String get awPreferredLanguage => 'Preferred language';

  @override
  String get awFinishSetup => 'Finish setup';

  @override
  String get awChatFileWebUnsupported =>
      'File sharing isn\'t available on web yet. Please use the mobile app.';

  @override
  String get awVideoUnsupported =>
      'Video calls aren\'t supported in this browser. Please use our mobile app or a supported desktop browser.';

  @override
  String get awClose => 'Close';

  @override
  String get pwPremiumTitle => 'Premium Report';

  @override
  String get pwLockedSubtitle => 'Unlock the full analysis for this chart';

  @override
  String pwUnlockFull(Object name) {
    return 'Unlock full $name';
  }

  @override
  String pwUnlockPrice(Object price) {
    return 'Unlock · $price';
  }

  @override
  String get pwOneTime => 'One-time unlock — yours forever on this chart';

  @override
  String get pwWhatYouGet => 'What you get';

  @override
  String get pwYourBalance => 'Your wallet balance';

  @override
  String get pwInsufficient => 'Insufficient balance';

  @override
  String get pwRechargeToUnlock => 'Recharge to unlock';

  @override
  String get pwRechargeAmount => 'Recharge amount (₹)';

  @override
  String get pwAddMoney => 'Add money';

  @override
  String get pwRechargeDone => 'Wallet recharged';

  @override
  String get pwRechargeFailed => 'Recharge failed. Please try again.';

  @override
  String get pwUnlockFailed => 'Couldn\'t unlock. Please try again.';

  @override
  String get pwUnlockedNow => 'Unlocked! Loading your report…';

  @override
  String get pwProcessing => 'Processing…';

  @override
  String get pwPrimaryNoDelete =>
      'Your Primary Kundli can\'t be deleted — it\'s free forever.';

  @override
  String get pwPrimaryNoEdit => 'Your Primary Kundli can\'t be edited.';

  @override
  String get pwLoadingAccess => 'Checking access…';

  @override
  String get pwMaybeLater => 'Maybe later';

  @override
  String get updatePhoto => 'Update Photo';

  @override
  String get takePhoto => 'Camera';

  @override
  String get chooseFromGallery => 'Gallery';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get photoUpdated => 'Photo updated';

  @override
  String get photoUploadFailed => 'Couldn\'t upload photo. Please try again.';

  @override
  String get tapToChangePhoto => 'Tap to change photo';

  @override
  String get klSubtitle => 'AI-powered Vedic Past-Life Karma Linkage Report';

  @override
  String get klTitle => 'Past-Life Karma Linkage';

  @override
  String get klSnapshotHeader => 'Karmic Linkage Snapshot';

  @override
  String get klGaugePairwise => 'Avg Pairwise Linkage';

  @override
  String get klGaugeCohesion => 'Group Cohesion';

  @override
  String get klGaugeRahuKetu => 'Rahu-Ketu Resonance';

  @override
  String get klGaugeAtmakaraka => 'Soul Resonance';

  @override
  String get klGaugeD60 => 'D60 Resonance';

  @override
  String get klChipSoulResonance => 'Strong soul-signature resonance';

  @override
  String get klChipD60Resonance => 'Strong D60 past-life resonance';

  @override
  String get klChipCohesiveGroup => 'Cohesive group';

  @override
  String get klChipNoDebts => 'No karmic debts detected';

  @override
  String get klProfilesTitle => 'Chart Profiles';

  @override
  String get klKetuAt => 'Ketu at';

  @override
  String get klRahuAt => 'Rahu at';

  @override
  String get klFoundationTitle => 'Per-Chart Karmic Foundation';

  @override
  String get klFoundationSubtitle =>
      'Each soul\'s past-life mastery and current-life direction';

  @override
  String get klKetuMastery => 'Ketu Mastery';

  @override
  String get klRahuGrowth => 'Rahu Growth';

  @override
  String get klNinthHousePunya => '9th House Punya';

  @override
  String get klD60Depth => 'D60 Karmic Depth';

  @override
  String get klAtmakarakaAgenda => 'Soul agenda';

  @override
  String get klSaturnKarma => 'Saturn karma';

  @override
  String get klPairwiseTitle => 'Pairwise Karmic Linkages';

  @override
  String get klActiveFactors => 'Active linkage factors';

  @override
  String get klGroupPatternTitle => 'Group Karmic Pattern';

  @override
  String get klSharedSetting => 'Shared Past-Life Setting';

  @override
  String get klCohesionScore => 'Karmic Cohesion';

  @override
  String get klPastGoalsTitle => 'Past-Life Goals';

  @override
  String get klLearningTitle => 'Current-Life Learning';

  @override
  String get klTeachingMap => 'Mutual Teaching Map';

  @override
  String get klDebtsTitle => 'Karmic Debts & Resolutions';

  @override
  String get klNoDebtsDetected => 'No karmic debts detected across this group';

  @override
  String get klTimingTitle => 'Moola Dasha Karmic Timing';

  @override
  String get klAuditTitle => 'Deep Audit Table';

  @override
  String klAuditSubtitle(Object count) {
    return '$count karmic parameters examined';
  }

  @override
  String get klTopicLinkage => 'Our overall karmic linkage';

  @override
  String get klTopicPairwise => 'A specific pair\'s karmic bond';

  @override
  String get klTopicDebts => 'Karmic debts to resolve';

  @override
  String get klTopicLessons => 'What we\'re here to learn';

  @override
  String get klTopicTiming => 'Best timing for our group';

  @override
  String get klTopicGroup => 'Our shared past-life story';

  @override
  String get lcSubtitle => 'AI-powered Vedic Love Compatibility Report';

  @override
  String get lcTitle => 'Love Compatibility';

  @override
  String get lcSnapshotHeader => 'Love Compatibility Snapshot';

  @override
  String get lcGaugeAttraction => 'Attraction';

  @override
  String get lcGaugeEmotional => 'Emotional Harmony';

  @override
  String get lcGaugeMental => 'Mental Rapport';

  @override
  String get lcGaugePassion => 'Passion';

  @override
  String get lcGaugeLongterm => 'Long-Term Harmony';

  @override
  String get lcChipStrongMental => 'Strong mental connection';

  @override
  String get lcChipStrongLongterm => 'Strong long-term potential';

  @override
  String get lcChipStrongPassion => 'Strong physical chemistry';

  @override
  String get lcChipLowFriction => 'Low friction overall';

  @override
  String get lcChipKarmicPull => 'Strong karmic pull';

  @override
  String get lcPartnersTitle => 'Partner Snapshot';

  @override
  String get lcVenusSuffix => 'Venus sign';

  @override
  String get lcAttractionTitle => 'Attraction & Chemistry';

  @override
  String get lcAttractionScore => 'Attraction Score';

  @override
  String get lcActiveContacts => 'Active Venus Contacts';

  @override
  String get lcEmotionalTitle => 'Emotional Harmony';

  @override
  String get lcEmotionalScore => 'Emotional Harmony Score';

  @override
  String get lcNakshatraCompat => 'Nakshatra Compatibility';

  @override
  String get lcYoniKoota => 'Yoni Koota';

  @override
  String get lcGanaKoota => 'Gana Koota';

  @override
  String get lcTaraKoota => 'Tara Koota';

  @override
  String get lcBhakootAxis => 'Bhakoot Axis';

  @override
  String get lcMentalTitle => 'Mental Rapport';

  @override
  String get lcMentalScore => 'Mental Rapport Score';

  @override
  String get lcPassionTitle => 'Passion & Physical';

  @override
  String get lcPassionScore => 'Passion Score';

  @override
  String get lcLongtermTitle => 'Long-Term Harmony';

  @override
  String get lcLongtermScore => 'Long-Term Harmony Score';

  @override
  String get lcCommitmentPotential => 'Commitment Potential';

  @override
  String get lc7thHouseSynastry => '7th House Synastry';

  @override
  String get lcJupiterBlessing => 'Jupiter Blessing';

  @override
  String get lcD9Resonance => 'D9 Navamsa Resonance';

  @override
  String get lcSaturnLongevity => 'Saturn Longevity';

  @override
  String get lcKarmicTitle => 'Karmic Love Bond';

  @override
  String get lcKarmicScore => 'Karmic Bond Score';

  @override
  String get lcKetuContacts => 'Ketu Contacts';

  @override
  String get lcRahuContacts => 'Rahu Contacts';

  @override
  String get lcChallengesTitle => 'Challenges & Friction';

  @override
  String get lcNoChallenges =>
      'No significant friction-points detected in either chart';

  @override
  String get lcTotalPenalty => 'Total Challenge Penalty';

  @override
  String get lcTimingTitle => 'Love Timing — Moola Dasha';

  @override
  String get lcDynamicsTitle => 'Relationship Dynamics';

  @override
  String get lcPowerBalance => 'Power Balance';

  @override
  String get lcGiverReceiver => 'Emotional Giver/Receiver';

  @override
  String get lcGrowthDynamic => 'Growth Dynamic';

  @override
  String get lcAreasToNurture => 'Areas To Nurture';

  @override
  String get lcTopicTiming => 'Best timing for our relationship';

  @override
  String get lcTopicChallenges => 'Challenges to navigate';

  @override
  String get lcTopicKarmic => 'Our karmic connection';

  @override
  String get lcTopicRemedies => 'Recommended remedies';

  @override
  String get lcTopicLongterm => 'Our long-term potential';

  @override
  String get lcTopicDynamics => 'Our relationship dynamics';

  @override
  String get cpSubtitle => 'AI-powered Vedic Child Probability Report';

  @override
  String get cpTitle => 'Child Probability';

  @override
  String get cpSnapshotHeader => 'Progeny Probability Snapshot';

  @override
  String get cpGauge5thHouse => '5th House';

  @override
  String get cpGaugeJupiter => 'Jupiter/Putrakaraka';

  @override
  String get cpGaugeD7 => 'D7 Saptamsa';

  @override
  String get cpGaugeSphuta => 'Beeja-Kshetra';

  @override
  String get cpGaugeTiming => 'Dasha Timing';

  @override
  String get cpChipStrongPutrakaraka => 'Strong Putrakaraka (Jupiter)';

  @override
  String get cpChipLowDoshaPenalty => 'Low dosha penalty';

  @override
  String get cpChipFavorableTiming => 'Favorable dasha timing';

  @override
  String get cpChipNoDoshas => 'No progeny-doshas detected';

  @override
  String get cpPartnersTitle => 'Partner Snapshot';

  @override
  String get cpLagnaSuffix => 'Lagna';

  @override
  String get cpMoonSuffix => 'Moon sign';

  @override
  String get cpNumberTitle => 'Number of Children & Gender Tendency';

  @override
  String get cpProbableNumber => 'Probable Number';

  @override
  String get cpFirstChildTendency => 'First Child Tendency';

  @override
  String get cpSpacing => 'Spacing Note';

  @override
  String get cpTimingTitle => 'Timing — Moola Dasha';

  @override
  String get cpCombinedTiming => 'Combined Timing';

  @override
  String get cpNextWindow => 'Next Favorable Window';

  @override
  String get cp5thHouseTitle => '5th House Analysis';

  @override
  String get cp5thHouseSubtitle =>
      'The house of children (Putra Bhava), per person';

  @override
  String get cpJupiterTitle => 'Jupiter — Putrakaraka Analysis';

  @override
  String get cpJupiterSubtitle =>
      'The natural significator of children, per person';

  @override
  String get cpD7Title => 'D7 Saptamsa Analysis';

  @override
  String get cpD7Subtitle => 'The divisional chart specifically for children';

  @override
  String get cpD7Strength => 'D7 Strength';

  @override
  String get cpSphutaTitle => 'Beeja & Kshetra Sphuta';

  @override
  String get cpBeejaSphuta => 'Beeja Sphuta (Seed)';

  @override
  String get cpKshetraSphuta => 'Kshetra Sphuta (Field)';

  @override
  String get cpDoshaTitle => 'Dosha Analysis';

  @override
  String get cpNoDoshasDetected =>
      'No progeny-relevant doshas detected in either chart';

  @override
  String get cpRemediesTitle => 'Recommended Remedies';

  @override
  String get cpAddresses => 'Addresses';

  @override
  String get cpTopicTiming => 'Best timing for conception';

  @override
  String get cpTopicNumber => 'How many children we may have';

  @override
  String get cpTopicDosha => 'Any doshas to address';

  @override
  String get cpTopicRemedies => 'Recommended remedies';

  @override
  String get cpTopicFifthHouse => 'Our 5th house strength';

  @override
  String get cpTopicJupiter => 'Jupiter\'s role in this';

  @override
  String get riSubtitle => 'AI-powered Vedic Relationship Intelligence Report';

  @override
  String get riTitle => 'Relationship Intel';

  @override
  String get riSnapshotHeader => 'Group Snapshot';

  @override
  String get riGaugeCohesion => 'Group Cohesion';

  @override
  String get riGaugeTrust => 'Trust Climate';

  @override
  String get riGaugeProductivity => 'Productivity';

  @override
  String get riGaugeCreativity => 'Creativity';

  @override
  String get riChipNoAlerts => 'No critical alerts';

  @override
  String get riChipStrongCohesion => 'Strong group cohesion';

  @override
  String get riChipHighTrust => 'High trust climate';

  @override
  String get riChipNoHiddenEnemy => 'No hidden-enemy signal';

  @override
  String get riChipHealthyGroup => 'Healthy group overall';

  @override
  String get riProfilesTitle => 'Chart Profiles';

  @override
  String riProfilesSubtitle(Object count) {
    return '$count people in this group';
  }

  @override
  String get riLagnaSuffix => 'Lagna';

  @override
  String get riIntegrity => 'Integrity';

  @override
  String get riWarmth => 'Warmth';

  @override
  String get riTrustworthiness => 'Trustworthiness';

  @override
  String get riAssertiveness => 'Assertiveness';

  @override
  String get riGroupDynamicsTitle => 'Group Dynamics Overview';

  @override
  String get riMostSupportive => 'Most Supportive';

  @override
  String get riMostChallenged => 'Most Challenged';

  @override
  String get riHiddenEnemyAlert => 'Hidden-Enemy Signal Detected';

  @override
  String get riBestWorstTitle => 'Best & Most Challenging Pairs';

  @override
  String get riBestPair => 'STRONGEST BOND';

  @override
  String get riWorstPair => 'NEEDS ATTENTION';

  @override
  String get riAlliances => 'Likely Alliances';

  @override
  String get riConflicts => 'Likely Friction Points';

  @override
  String get riPairwiseTitle => 'Pairwise Analysis';

  @override
  String riPairwiseSubtitle(Object count) {
    return '$count pairs analyzed';
  }

  @override
  String get riDynamic => 'Dynamic';

  @override
  String get riKarmicLink => 'Karmic link';

  @override
  String get riMutualTrust => 'Mutual trust';

  @override
  String get riBetrayalRisk => 'Betrayal risk';

  @override
  String get riPowerDistribution => 'Power distribution';

  @override
  String get riPowerHealth => 'Power-balance health';

  @override
  String get riCriticalPatternsTitle => 'Critical Patterns';

  @override
  String get riGroupRecsTitle => 'Group Recommendations';

  @override
  String get riSharedPractices => 'Shared Practices';

  @override
  String get riCommStyle => 'Recommended Communication Style';

  @override
  String get riGrowthFocus => 'Recommended Growth Focus';

  @override
  String get riIndividualTitle => 'Individual Guidance';

  @override
  String get riBestAllies => 'Best Allies';

  @override
  String get riHandleWithCare => 'Handle With Care';

  @override
  String get riCoreThemeTitle => 'Core Group Theme';

  @override
  String get riLayerPairwise => 'Pairwise Completeness';

  @override
  String get riLayerD1 => 'Birth Chart (D1)';

  @override
  String get riLayerD9 => 'Navamsa (D9)';

  @override
  String get riLayerD10 => 'Dashamsa (D10)';

  @override
  String get riLayerD30 => 'Trimshamsa (D30)';

  @override
  String get riLayerJaimini => 'Jaimini Signal';

  @override
  String get riLayerBehavior => 'Behavior Clarity';

  @override
  String get riLayerCoherence => 'Group Coherence';

  @override
  String get riTopicDynamics => 'Our group dynamics';

  @override
  String get riTopicPairwise => 'A specific pair\'s compatibility';

  @override
  String get riTopicAlerts => 'Any critical alerts';

  @override
  String get riTopicGrowth => 'How we can grow together';

  @override
  String get riTopicRecs => 'Recommended practices';

  @override
  String get riTopicTheme => 'Our core group theme';

  @override
  String get kmSubtitle => 'AI-powered Vedic Kundli Milan Report';

  @override
  String get kmTitle => 'Kundli Milan';

  @override
  String get kmSnapshotHeader => 'Compatibility Snapshot';

  @override
  String kmAshtakootScore(Object score) {
    return 'Ashtakoot: $score/36';
  }

  @override
  String get kmGaugeAshtakoot => 'Ashtakoot %';

  @override
  String get kmGaugeD9 => 'D9 Marriage Karma';

  @override
  String get kmGaugeMangal => 'Mangal Balance';

  @override
  String get kmGaugePapa => 'Karmic Balance';

  @override
  String get kmGaugeAk => 'Soul Resonance';

  @override
  String get kmChipNoNadi => 'No Nadi Dosh';

  @override
  String get kmChipNoBhakoot => 'No Bhakoot Dosh';

  @override
  String get kmChipMangalCancelled => 'Mangal Dosh cancelled';

  @override
  String get kmChipPapaBalanced => 'Balanced karmic load';

  @override
  String get kmChipStrongChemistry => 'Strong physical chemistry';

  @override
  String get kmChipStrongD9 => 'Strong D9 marriage karma';

  @override
  String get kmChipLongevity => 'Strong longevity alignment';

  @override
  String get kmAshtakootTitle => 'Ashtakoot Guna Milan';

  @override
  String get kmAshtakootSubtitle =>
      'The classical 8-point matching system, out of 36';

  @override
  String get kmNadiSeverity => 'Nadi severity';

  @override
  String get kmBhakootSeverity => 'Bhakoot severity';

  @override
  String get kmGanaSignature => 'Gana signature';

  @override
  String get kmMangalTitle => 'Mangal Dosha Check';

  @override
  String get kmD9Title => 'D9 Navamsa — Marriage Karma';

  @override
  String get kmD9Subtitle =>
      'The soul-level marriage chart, considered most important classically';

  @override
  String get kmD9Score => 'D9 Compatibility';

  @override
  String get kmLagnaRelation => 'Lagna relationship';

  @override
  String get km7thLordRelation => '7th lord relationship';

  @override
  String get kmKarakasTitle => 'Soul & Spouse Karakas';

  @override
  String get kmAtmakaraka => 'Soul Planet';

  @override
  String get kmAkCompatibility => 'Soul-Signature Resonance';

  @override
  String get kmUlCompatibility => 'Spouse-Karaka Alignment';

  @override
  String get kmUlSigns => 'Upapada lords';

  @override
  String get kmChemistryTitle => 'Venus-Mars Chemistry';

  @override
  String get kmPhysicalChemistry => 'Physical Chemistry';

  @override
  String get kmEmotionalWarmth => 'Emotional Warmth';

  @override
  String get kmAestheticAlignment => 'Aesthetic Alignment';

  @override
  String get kmElementalSynthesis => 'Elemental Synthesis';

  @override
  String get kmHouseCrossTitle => '7th & 8th House Cross-Analysis';

  @override
  String get km78Compatibility => '7th-8th House Compatibility';

  @override
  String get km8thHouseSignature => 'Joint Longevity Signature';

  @override
  String get kmLongevityAlignment => 'Longevity Alignment';

  @override
  String get km7thLordFriendship => '7th-lord friendship';

  @override
  String get kmDomainsTitle => 'Domain-by-Domain Compatibility';

  @override
  String get kmConflictEngagement => 'Conflict Style';

  @override
  String get kmDashaTitle => 'Dasha & Transit Sync';

  @override
  String get kmDashaSync => 'Dasha Sync';

  @override
  String get kmTransitAlignment => 'Transit Alignment';

  @override
  String get kmTimingTitle => 'Marriage Timing';

  @override
  String get kmMarriageWindow => 'Marriage Window';

  @override
  String get kmEngagementWindow => 'Engagement Window';

  @override
  String get kmRecommendedRange => 'Recommended Timeframe';

  @override
  String get kmMuhurtaNotes => 'Muhurta Notes';

  @override
  String get kmRisksTitle => 'Risks To Address';

  @override
  String get kmConflictRisk => 'Conflict Risk';

  @override
  String get kmCommunicationRisk => 'Communication Risk';

  @override
  String get kmFinanceRisk => 'Finance Conflict Risk';

  @override
  String get kmFamilyDynamicsRisk => 'Family Dynamics Risk';

  @override
  String get kmMentalHealthRisk => 'Mental-Health Alignment Risk';

  @override
  String get kmStrengthsTitle => 'Top Compatibility Strengths';

  @override
  String get kmSharedGrowth => 'Shared Growth Potential';

  @override
  String get kmSharedCreative => 'Shared Creative Potential';

  @override
  String get kmJourneyTitle => 'Relationship Journey & Growth';

  @override
  String get kmCurrentPhase => 'Current phase';

  @override
  String get kmEarlyArc => 'Early Marriage';

  @override
  String get kmMiddleArc => 'Middle Marriage';

  @override
  String get kmMatureArc => 'Mature Marriage';

  @override
  String get kmElderArc => 'Elder Years';

  @override
  String get kmPeakPhase => 'Peak Companionship Phase';

  @override
  String get kmGrowthAreas => 'Growth Areas';

  @override
  String get kmCommProtocols => 'Communication Protocols';

  @override
  String get kmSharedPractices => 'Shared Practices';

  @override
  String get kmImprovementTitle => 'Core Theme & Improvement Plan';

  @override
  String get kmVerdictTitle => 'Final Verdict';

  @override
  String get kmRealizationPotential => 'Relationship Realization Potential';

  @override
  String get kmLayerAshtakoot => 'Ashtakoot';

  @override
  String get kmLayerD9 => 'D9 Navamsa';

  @override
  String get kmLayerMangalPapa => 'Mangal & Papasamya';

  @override
  String get kmLayerVenusMars => 'Venus-Mars';

  @override
  String get kmLayerDashaSync => 'Dasha Sync';

  @override
  String get kmLayerH7H8 => '7th-8th House Cross';

  @override
  String get kmLayerAkResonance => 'Atmakaraka Resonance';

  @override
  String get kmLayerDomains => 'Domain Dimensions';

  @override
  String get kmTopicAshtakoot => 'Our Ashtakoot score';

  @override
  String get kmTopicMangal => 'Mangal Dosha concerns';

  @override
  String get kmTopicD9 => 'Our marriage karma (D9)';

  @override
  String get kmTopicTiming => 'Best marriage timing';

  @override
  String get kmTopicRisks => 'Risks to prepare for';

  @override
  String get kmTopicGrowth => 'How we can grow together';

  @override
  String get kmTopicRemedies => 'Recommended remedies';

  @override
  String get kmTopicVerdict => 'Should we proceed with marriage';

  @override
  String get pkSubtitle => 'AI-powered Vedic Past Life & Karma Report';

  @override
  String get pkTitle => 'Past Life & Karma';

  @override
  String get pkSnapshotHeader => 'Past-Life Snapshot';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return 'Your chart shows a \'$theme\' past-life signature, currently $relation into this life. Recommended path: $strategy.';
  }

  @override
  String get pkGaugeSignature => 'Signature Strength';

  @override
  String get pkGaugeMasteryPreserved => 'Mastery Preserved';

  @override
  String get pkGaugeClearingProgress => 'Karma Clearing';

  @override
  String get pkGaugeMaturity => 'Past-Life Maturity';

  @override
  String get pkGaugeMemoryAccess => 'Memory Access';

  @override
  String get pkChipGoodProgress => 'Good karma-clearing progress';

  @override
  String get pkChipLowDebt => 'Low karmic debt';

  @override
  String get pkChipMatureSoul => 'Mature soul signature';

  @override
  String get pkChipGiftedPast => 'Chart carries a past-life gift';

  @override
  String get pkChipAccomplished => 'Accomplished past life';

  @override
  String get pkChipMasteryPreserved => 'Strong mastery carried forward';

  @override
  String get pkKetuTitle => 'Ketu — Your Past Mastery';

  @override
  String get pkKetuSubtitle => 'Skills your soul already mastered';

  @override
  String get pkMasteryStrength => 'Mastery Strength';

  @override
  String get pkSkillsCarried => 'Skills Carried Forward';

  @override
  String get pkInstincts => 'Instinctual Capacities';

  @override
  String get pkKetuDignity => 'Ketu dignity';

  @override
  String get pkRahuTitle => 'Rahu — Your Soul\'s Growth Edge';

  @override
  String get pkRahuSubtitle => 'What your soul is here to finish';

  @override
  String get pkUnmetDesires => 'Unmet Desires';

  @override
  String get pkProfileTitle => 'Your Past-Life Profile';

  @override
  String get pkProfession => 'Likely Profession';

  @override
  String get pkSocialStanding => 'Social Standing';

  @override
  String get pkRegion => 'Likely Region';

  @override
  String get pkCulturalArchetype => 'Cultural Archetype';

  @override
  String get pkAccomplishment => 'Accomplishment Level';

  @override
  String get pkAuthority => 'Authority Level';

  @override
  String get pkFamilyRole => 'Family role';

  @override
  String get pkSecondaryProfession => 'Secondary profession';

  @override
  String get pkClimateAffinity => 'Climate affinity';

  @override
  String get pkForeignResidence => 'Foreign-residence karma';

  @override
  String get pkRelationshipsTitle => 'Past Relationships Carried Forward';

  @override
  String get pkSpouseConnection => 'Spouse Reconnection';

  @override
  String get pkChildrenConnection => 'Children Reconnection';

  @override
  String get pkCarriedRelationTypes => 'Relationship Patterns';

  @override
  String get pkPartnerArchetype => 'Past-Life Partner Archetype';

  @override
  String get pkDarakaraka => 'Spouse karaka';

  @override
  String get pkParentsKarma => 'Parents karma pattern';

  @override
  String get pkSiblingKarma => 'Sibling karma pattern';

  @override
  String get pkSpiritualTitle => 'Your Spiritual Life Then';

  @override
  String get pkSpiritualLevel => 'Spiritual Level';

  @override
  String get pkPracticeSignature => 'Practice Style';

  @override
  String get pkMeditativeCapacity => 'Meditative Capacity';

  @override
  String get pkDevotionalPractice => 'Devotional Practice';

  @override
  String get pkYogicAttainment => 'Yogic Attainment';

  @override
  String get pkMokshaProximity => 'Moksha Proximity';

  @override
  String get pkKarmicDebtsTitle => 'Karmic Debts & Wealth Then';

  @override
  String get pkTotalKarmicDebt => 'Total Karmic Debt';

  @override
  String get pkPrimaryDebtType => 'Primary Debt Type';

  @override
  String get pkRelationshipDebt => 'Relationship Debt';

  @override
  String get pkFinancialDebt => 'Financial Debt';

  @override
  String get pkServiceDebt => 'Service Debt';

  @override
  String get pkDharmicDebt => 'Dharmic Debt';

  @override
  String get pkPitruKarma => 'Pitru karma';

  @override
  String get pkMatruKarma => 'Matru karma';

  @override
  String get pkWealthLevel => 'Wealth Level Then';

  @override
  String get pkWealthKarmaCarried => 'Wealth Karma Carried';

  @override
  String get pkResourcePattern => 'Resource management';

  @override
  String get pkGainSource => 'Gain source';

  @override
  String get pkEchoesTitle => 'Echoes In This Life';

  @override
  String get pkOnRelationships => 'On Relationships';

  @override
  String get pkOnCareer => 'On Career';

  @override
  String get pkOnHealth => 'On Health';

  @override
  String get pkOnSpirituality => 'On Spirituality';

  @override
  String get pkDominantArea => 'Strongest Carryforward';

  @override
  String get pkAttractions => 'Natural Attractions';

  @override
  String get pkAversions => 'Natural Aversions';

  @override
  String get pkUnexplainedFears => 'Unexplained Fears';

  @override
  String get pkMagneticPulls => 'Magnetic Pulls';

  @override
  String get pkResolutionTitle => 'Karmic Resolution & Completion';

  @override
  String get pkPrimaryPathway => 'Primary Path';

  @override
  String get pkSecondaryPathway => 'Secondary Path';

  @override
  String get pkClearingProgress => 'Clearing Progress';

  @override
  String get pkRemainingWork => 'Remaining Work';

  @override
  String get pkSettlementTimeline => 'Settlement Timeline';

  @override
  String get pkAccelerationPractices => 'Practices That Speed Resolution';

  @override
  String get pkPriorityAreas => 'Priority Areas';

  @override
  String get pkVerificationTitle => 'Verified Across Charts (D60)';

  @override
  String get pkD60Label => 'D60 Past-Life Era';

  @override
  String get pkD60Ketu => 'D60 Ketu placement';

  @override
  String get pkD60Standing => 'Overall standing';

  @override
  String get pkMemoryTitle => 'Memory & Intuition';

  @override
  String get pkMemoryAccess => 'Memory Access';

  @override
  String get pkRegressionFit => 'Regression-Therapy Fit';

  @override
  String get pkDreamVisits => 'Dream Visitations';

  @override
  String get pkDejaVuFrequency => 'Deja Vu Frequency';

  @override
  String get pkSpontaneousRemembrance => 'Spontaneous remembrance';

  @override
  String get pkRemembrancePractices => 'Remembrance Practices';

  @override
  String get pkTimelineTitle => 'Activation Timeline';

  @override
  String get pkGiftsActivation => 'Past-Life Gifts Activation';

  @override
  String get pkSurfaceWindow => 'Surfacing Window';

  @override
  String get pkRisksTitle => 'Risks & Chronic Patterns';

  @override
  String get pkTraumaResidue => 'Trauma Residue';

  @override
  String get pkSpiritualBypass => 'Spiritual Bypass Risk';

  @override
  String get pkMajorRisks => 'Major Risks';

  @override
  String get pkChronicImprints => 'Chronic Imprints';

  @override
  String get pkKarmicLoops => 'Karmic Loops';

  @override
  String get pkImprovementTitle => 'Improvement Plan';

  @override
  String get pkRoadmapTitle => 'Your Past-Life Roadmap';

  @override
  String get pkMaturity => 'Past-Life Maturity';

  @override
  String get pkLayerD1 => 'Birth Chart (D1)';

  @override
  String get pkLayerD9 => 'Navamsa (D9)';

  @override
  String get pkLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get pkLayerKetuDepth => 'Ketu Depth';

  @override
  String get pkLayerAtmakaraka => 'Soul Planet (Atmakaraka)';

  @override
  String get pkTopicMastery => 'My past-life mastery';

  @override
  String get pkTopicUnfinished => 'My unfinished karma';

  @override
  String get pkTopicRelationships => 'My past-life relationships';

  @override
  String get pkTopicDebts => 'My karmic debts';

  @override
  String get pkTopicResolution => 'How to resolve my karma';

  @override
  String get pkTopicMemory => 'Past-life memory access';

  @override
  String get pkTopicTiming => 'Best timing windows';

  @override
  String get pkTopicProfile => 'Who I was in my past life';

  @override
  String get chSubtitle => 'AI-powered Vedic Character Analysis Report';

  @override
  String get chTitle => 'Character Analysis';

  @override
  String get chSnapshotHeader => 'Character Snapshot';

  @override
  String get chGaugeIntegrity => 'Integrity';

  @override
  String get chGaugeResilience => 'Resilience';

  @override
  String get chGaugeSelfAwareness => 'Self-Awareness';

  @override
  String get chGaugeStability => 'Emotional Stability';

  @override
  String get chGaugeMoralFabric => 'Moral Fabric';

  @override
  String get chChipRajaYoga => 'Raja Yoga present';

  @override
  String get chChipHighIntegrity => 'High integrity';

  @override
  String get chChipResilient => 'Resilient nature';

  @override
  String get chChipDharmic => 'Strong dharma orientation';

  @override
  String get chChipEmpathetic => 'Naturally empathetic';

  @override
  String get chChipLoyal => 'Deeply loyal';

  @override
  String get chChipGiftedCharacter => 'Chart carries a character gift';

  @override
  String get chSoulTitle => 'Your Soul Signature';

  @override
  String get chSoulIntegration => 'Soul-Character Integration';

  @override
  String get chAmatyakarakaTheme => 'Supporting Character Voice';

  @override
  String get chAtmakarakaDignity => 'Soul-planet dignity';

  @override
  String get chAtmakarakaHouse => 'House placement';

  @override
  String get chSurfaceTitle => 'Surface Personality & Constitution';

  @override
  String get chLagnaSign => 'Ascendant Sign';

  @override
  String get chConstitution => 'Constitution';

  @override
  String get chSurfaceSignature => 'How you come across';

  @override
  String get chPhysicalConstitution => 'Physical Constitution';

  @override
  String get chLagnaLord => 'Ascendant Lord';

  @override
  String get chLagnaOccupants => 'Planets in Ascendant';

  @override
  String get chMindEmotionsTitle => 'Mind, Emotions & Ego';

  @override
  String get chEmotionalNature => 'Your Emotional Nature';

  @override
  String get chMentalStability => 'Mental Stability';

  @override
  String get chSelfConfidence => 'Healthy Self-Confidence';

  @override
  String get chEgoNature => 'Your Ego & Self-Concept';

  @override
  String get chAuthorityRelationship => 'Relationship with Authority';

  @override
  String get chPrideTendency => 'Pride Tendency';

  @override
  String get chMoodPatterns => 'Mood Patterns';

  @override
  String get chKemadrumaPresent =>
      'Kemadruma Yoga present — extra emotional self-care is beneficial.';

  @override
  String get chFatherImprint => 'Father imprint quality';

  @override
  String get chCommunicationTitle => 'Communication & Intellect Style';

  @override
  String get chIntellectStyle => 'Intellect Style';

  @override
  String get chCommStyle => 'Communication Style';

  @override
  String get chDecisionStyle => 'Decision-Making Style';

  @override
  String get chDiscrimination => 'Discrimination Capacity';

  @override
  String get chPersonaTitle => 'Public Persona vs True Self';

  @override
  String get chAuthenticityGap => 'Authenticity Gap';

  @override
  String get chGunaTitle => 'Guna & Dosha Profile';

  @override
  String get chGunaSubtitle =>
      'Your inner nature and constitution, classical Vedic style';

  @override
  String get chSattva => 'Sattva';

  @override
  String get chRajas => 'Rajas';

  @override
  String get chTamas => 'Tamas';

  @override
  String get chDominantGuna => 'Dominant Guna';

  @override
  String get chPitta => 'Pitta';

  @override
  String get chKapha => 'Kapha';

  @override
  String get chVata => 'Vata';

  @override
  String get chDominantDosha => 'Dominant Dosha';

  @override
  String get chRahuRestlessness => 'Rahu restlessness';

  @override
  String get chKetuDetachment => 'Ketu detachment';

  @override
  String get chYogasTitle => 'Character Yogas';

  @override
  String get chRajaYogaStrength => 'Raja Yoga Strength';

  @override
  String get chGiftYogas => 'Gift Yogas';

  @override
  String get chTestYogas => 'Test Yogas';

  @override
  String get chStrengthsTitle => 'Strengths & Talents';

  @override
  String get chSignatureVirtues => 'Signature Virtues';

  @override
  String get chNaturalTalents => 'Natural Talents';

  @override
  String get chSoftSkills => 'Soft Skills';

  @override
  String get chHiddenStrengths => 'Hidden Strengths To Develop';

  @override
  String get chShadowTitle => 'Shadow & Growth Areas';

  @override
  String get chShadowSubtitle =>
      'Gentle awareness of patterns worth working on';

  @override
  String get chShadowPatterns => 'Shadow Patterns';

  @override
  String get chBlindSpots => 'Blind Spots';

  @override
  String get chEmotionalWounds => 'Emotional Wounds';

  @override
  String get chShadowWorkPriorities => 'Shadow-Work Priorities';

  @override
  String get chMoralTests => 'Moral Tests';

  @override
  String get chRelationshipsTitle => 'Relationships & Social Style';

  @override
  String get chWarmth => 'Interpersonal Warmth';

  @override
  String get chEmpathy => 'Empathy Capacity';

  @override
  String get chLoyalty => 'Loyalty Capacity';

  @override
  String get chBoundaries => 'Boundary Setting';

  @override
  String get chSocialConfidence => 'Social Confidence';

  @override
  String get chTrustGiving => 'Trust-Giving Baseline';

  @override
  String get chConflictStyle => 'Conflict style';

  @override
  String get chEthicsTitle => 'Ethics & Moral Compass';

  @override
  String get chDharmaOrientation => 'Dharma Orientation';

  @override
  String get chTruthfulness => 'Truthfulness';

  @override
  String get chCompassion => 'Compassion';

  @override
  String get chGenerosity => 'Generosity';

  @override
  String get chEthicalConsistency => 'Ethical Consistency';

  @override
  String get chIntegrityPressure => 'Integrity Under Pressure';

  @override
  String get chJusticeFairness => 'Justice & Fairness';

  @override
  String get chMoralTrajectory => 'Moral development';

  @override
  String get chEiTitle => 'Emotional Intelligence';

  @override
  String get chEiSelfAwareness => 'Self-Awareness';

  @override
  String get chEiSelfRegulation => 'Self-Regulation';

  @override
  String get chEiEmpathy => 'Empathy';

  @override
  String get chEiSocialSkills => 'Social Skills';

  @override
  String get chMotivation => 'Internal Motivation';

  @override
  String get chVulnerabilityComfort => 'Comfort With Vulnerability';

  @override
  String get chEmotionalExpression => 'Emotional expression comfort';

  @override
  String get chEmotionalReceptivity => 'Emotional receptivity';

  @override
  String get chVerificationTitle => 'Verified Across Charts (D9/D12/D30/D60)';

  @override
  String get chD9Label => 'D9 Dharma-Character';

  @override
  String get chD12Label => 'D12 Ancestral Inheritance';

  @override
  String get chD30Label => 'D30 Shadow Profile';

  @override
  String get chD60Label => 'D60 Past-Life Character';

  @override
  String get chD30Standing => 'Shadow standing';

  @override
  String get chMaternalInheritance => 'Maternal inheritance';

  @override
  String get chAncestralKarmaWeight => 'Ancestral karma weight';

  @override
  String get chTimelineTitle => 'Character Timeline';

  @override
  String get chFormationWindow => 'Formation Window';

  @override
  String get chMaturationWindow => 'Maturation Window';

  @override
  String get chLegacyWindow => 'Legacy Window';

  @override
  String get chPeakMaturationAge => 'Peak maturation age';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return 'Age $ageRange';
  }

  @override
  String get chImprovementTitle => 'Improvement Plan';

  @override
  String get chRoadmapTitle => 'Your Character Roadmap';

  @override
  String get chAuthenticExpression => 'Authentic Self-Expression';

  @override
  String get chRealizationPotential => 'Character Realization Potential';

  @override
  String get chLayerAtmakaraka => 'Soul Planet (Atmakaraka)';

  @override
  String get chLayerD1 => 'Birth Chart (D1)';

  @override
  String get chLayerD9 => 'Navamsa (D9)';

  @override
  String get chLayerD30 => 'Trimshamsa (D30)';

  @override
  String get chLayerLagnaMoon => 'Ascendant & Moon';

  @override
  String get chLayerArudha => 'Arudha Lagna';

  @override
  String get chTopicStrengths => 'My character strengths';

  @override
  String get chTopicShadow => 'My shadow patterns';

  @override
  String get chTopicSoul => 'My soul signature';

  @override
  String get chTopicRelationships => 'My relationship style';

  @override
  String get chTopicEthics => 'My ethics & values';

  @override
  String get chTopicGuna => 'My guna & dosha profile';

  @override
  String get chTopicGrowth => 'How to grow my character';

  @override
  String get chTopicTiming => 'Best timing for character work';

  @override
  String get lpSubtitle => 'AI-powered Vedic Life Path & Luck Report';

  @override
  String get lpTitle => 'Life Path & Luck';

  @override
  String get lpSnapshotHeader => 'Life Path Snapshot';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return 'You\'re a $archetype with a primary purpose in $domain. Our analysis shows a $probability% overall life-fulfillment potential.';
  }

  @override
  String get lpGaugeDharma => 'Dharma Clarity';

  @override
  String get lpGaugeFortune => 'Fortune Baseline';

  @override
  String get lpGaugeCoherence => 'Path Coherence';

  @override
  String get lpGaugeFulfillment => 'Fulfillment';

  @override
  String get lpGaugeMomentum => 'Karmic Momentum';

  @override
  String get lpChipRareGift => 'Rare destiny gift';

  @override
  String get lpChipFreeWillStrong => 'Strong free will';

  @override
  String get lpChipGraceSupported => 'Grace-supported';

  @override
  String get lpChipLightKarma => 'Light karmic load';

  @override
  String get lpChipRecognitionPotential => 'Recognition potential';

  @override
  String get lpChipSpiritualPath => 'Strong spiritual pull';

  @override
  String get lpChipBlessed => 'Chart carries blessings';

  @override
  String get lpSoulPathTitle => 'Your Soul Path';

  @override
  String get lpSoulPlanet => 'Soul Planet';

  @override
  String get lpCareerPlanet => 'Purpose Planet';

  @override
  String get lpSoulClarity => 'Purpose Clarity';

  @override
  String get lpLifeChapter => 'Current Life Chapter';

  @override
  String get lpPrimaryDomain => 'Primary Purpose Domain';

  @override
  String get lpKarakaTitle => 'Your Dharma Planets';

  @override
  String get lpKarakaSubtitle =>
      'How strongly each planet supports your life purpose';

  @override
  String get lpVerificationTitle => 'Verified Across Charts (D9 / D60)';

  @override
  String get lpD9Label => 'D9 Soul Alignment';

  @override
  String lpD9Explain(Object stage) {
    return 'Your soul-evolution stage is \'$stage\' in the Navamsa chart.';
  }

  @override
  String get lpD9JupiterDignity => 'Jupiter dignity';

  @override
  String get lpD9DharmaMultiplier => 'Dharma multiplier';

  @override
  String get lpD60Label => 'D60 Past-Life Signature';

  @override
  String get lpKarmaType => 'Past-life karma type';

  @override
  String get lpKetuMastery => 'Ketu past-life mastery';

  @override
  String get lpRahuGrowthDir => 'Rahu growth direction';

  @override
  String get lpYogasTitle => 'Fortune Yogas & Luck Blocks';

  @override
  String get lpFortuneBoost => 'Fortune Boost';

  @override
  String get lpLuckDrain => 'Luck Drain';

  @override
  String get lpFortuneBoosters => 'Fortune Boosters';

  @override
  String get lpLuckBlocks => 'Luck Blocks';

  @override
  String get lpPurposeTitle => 'Purpose Domains & Fame';

  @override
  String get lpDomainLeadership => 'Leadership';

  @override
  String get lpDomainWisdom => 'Wisdom & Teaching';

  @override
  String get lpDomainService => 'Service';

  @override
  String get lpDomainHealing => 'Healing';

  @override
  String get lpDomainCreative => 'Creative Expression';

  @override
  String get lpPrimaryDomainBadge => 'Primary';

  @override
  String get lpFameRecognition => 'Fame & Recognition';

  @override
  String get lpSocialInfluence => 'Social Influence';

  @override
  String get lpRecognitionDomain => 'Recognition Field';

  @override
  String get lpPublicImage => 'Public Image';

  @override
  String get lpHistoricalImpact => 'Historical impact potential';

  @override
  String get lpTimelineTitle => 'Fortune & Life Timeline';

  @override
  String get lpCurrentPhase => 'Current Fortune Phase';

  @override
  String get lpJupiterReturn => 'Jupiter Return';

  @override
  String get lpSaturnReturn => 'Saturn Return';

  @override
  String get lpSadeSati => 'Sade Sati';

  @override
  String get lpGoldenWindow => 'Golden Window';

  @override
  String get lpTransformationWindow => 'Transformation Window';

  @override
  String get lpPeakYears => 'Peak Fortune Years';

  @override
  String get lpChallengingYears => 'Challenging Years';

  @override
  String get lpMilestonesTitle => 'Major Milestones & Turning Points';

  @override
  String get lpFirstTurningPoint => 'First Major Turning Point';

  @override
  String get lpMidlifeTransform => 'Midlife Transformation';

  @override
  String get lpLateLifeFulfillment => 'Late-Life Fulfillment';

  @override
  String lpDharmicMilestone(Object age) {
    return 'Dharmic Milestone (Age $age)';
  }

  @override
  String lpAgeLabel(Object age) {
    return 'Age $age';
  }

  @override
  String get lpDestinyTitle => 'Destiny vs Free Will';

  @override
  String get lpDestinyStat => 'Destiny Weight';

  @override
  String get lpFreeWillStat => 'Free Will Leverage';

  @override
  String get lpFateStrength => 'Fate Signature Strength';

  @override
  String get lpSelfCreation => 'Self-Creation Capacity';

  @override
  String get lpEffortGrace => 'Effort vs grace';

  @override
  String get lpKarmicTitle => 'Karmic Lessons';

  @override
  String get lpRahuGrowthLabel => 'Rahu — Growth Challenge';

  @override
  String get lpKetuSurrenderLabel => 'Ketu — Surrender Theme';

  @override
  String get lpSaturnLessonLabel => 'Saturn — Discipline Lesson';

  @override
  String get lpTestDifficulty => 'Life Test Difficulty';

  @override
  String get lpLessonsInProgress => 'Lessons In Progress';

  @override
  String get lpSoulContract => 'Soul Contract Areas';

  @override
  String get lpSoulExperience => 'What Your Soul Came To Experience';

  @override
  String get lpSoulMastery => 'What Your Soul Came To Master';

  @override
  String get lpSpiritualTitle => 'Spiritual Path';

  @override
  String get lpSpiritualInclination => 'Spiritual Inclination';

  @override
  String get lpMeditationReceptivity => 'Meditation Receptivity';

  @override
  String get lpTeacherKarma => 'Teacher/Guru Karma';

  @override
  String get lpPilgrimageBenefit => 'Pilgrimage Benefit';

  @override
  String get lpSelfRealization => 'Self-Realization Potential';

  @override
  String get lpDivineConnection => 'Divine Connection';

  @override
  String get lpTraditionAffinity => 'Tradition affinity';

  @override
  String get lpIntuitionStrength => 'Intuition strength';

  @override
  String get lpMantraEfficacy => 'Prayer/mantra efficacy';

  @override
  String get lpInnerGuidance => 'Inner-guidance trust';

  @override
  String get lpPropheticDreams => 'Prophetic-dream sensitivity';

  @override
  String get lpDifficultyTitle => 'Life Difficulty & Challenges';

  @override
  String get lpEarlyLife => 'Early Life';

  @override
  String get lpMidlife => 'Midlife';

  @override
  String get lpLateLife => 'Late Life';

  @override
  String get lpStruggleToSuccess => 'Struggle-to-Success Karma';

  @override
  String get lpUnlivedLifeRisk => 'Unlived-Life Risk';

  @override
  String get lpChallenges => 'Life Challenges';

  @override
  String get lpFortuneDrains => 'Chronic Fortune Drains';

  @override
  String get lpRegretAreas => 'Regret-Vulnerability Areas';

  @override
  String get lpRedFlags => 'Direction Red Flags';

  @override
  String get lpBlessingsTitle => 'Blessings & Core Life Theme';

  @override
  String get lpKarmicRoot => 'Karmic root';

  @override
  String get lpBlessingsList => 'Your Blessings';

  @override
  String get lpFulfillmentPriorities => 'Fulfillment Priorities';

  @override
  String get lpImprovementTitle => 'Improvement Plan';

  @override
  String get lpDharmaPriorities => 'Dharma Priorities';

  @override
  String get lpRoadmapTitle => 'Your Destiny Roadmap';

  @override
  String get lpStrategy => 'Strategy';

  @override
  String get lpFulfillmentPotential => 'Fulfillment Potential';

  @override
  String get lpNext12Focus => 'Next 12-Month Focus';

  @override
  String get lpLayerD1 => 'Birth Chart (D1)';

  @override
  String get lpLayerD9 => 'Navamsa (D9)';

  @override
  String get lpLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get lpLayerDasha => 'Dasha Timing';

  @override
  String get lpLayerTransit => 'Current Transits';

  @override
  String get lpTopicPurpose => 'My life purpose';

  @override
  String get lpTopicFortune => 'My fortune yogas';

  @override
  String get lpTopicKarma => 'My karmic lessons';

  @override
  String get lpTopicMilestones => 'Upcoming milestones';

  @override
  String get lpTopicDestiny => 'Destiny vs free will';

  @override
  String get lpTopicSpiritual => 'My spiritual path';

  @override
  String get lpTopicChallenges => 'My life challenges';

  @override
  String get lpTopicTiming => 'Best timing windows';

  @override
  String get dbSubtitle => 'AI-powered Vedic Debt & Recovery Report';

  @override
  String get dbTitle => 'Debt & Recovery';

  @override
  String get dbSnapshotHeader => 'Debt Recovery Snapshot';

  @override
  String dbHeroSummary(
    Object phase,
    Object personality,
    Object probability,
    Object years,
  ) {
    return 'You\'re currently in a \'$phase\' phase with a $personality approach to money. Our analysis shows a $probability% chance of becoming debt-free within about $years years.';
  }

  @override
  String get dbGaugeCapacity => 'Recovery Capacity';

  @override
  String get dbGaugeProbability => 'Recovery Chance';

  @override
  String get dbGaugeFreedomNow => 'Debt Freedom Now';

  @override
  String get dbGaugeDti => 'Income Health';

  @override
  String get dbGaugeResilience => 'Resilience';

  @override
  String get dbChipCleanKarma => 'Clean debt karma';

  @override
  String get dbChipStrongRecovery => 'Strong recovery capacity';

  @override
  String get dbChipHealthyDti => 'Healthy debt-to-income';

  @override
  String get dbChipResilient => 'High psychological resilience';

  @override
  String get dbChipCycleBreakable => 'Debt cycle is breakable';

  @override
  String get dbChipLowReindebt => 'Low re-indebtedness risk';

  @override
  String get dbChipGoodNegotiator => 'Good negotiation odds';

  @override
  String get dbProfileTitle => 'Your Debt Profile';

  @override
  String get dbPhaseLabel => 'Current phase';

  @override
  String get dbPrimaryCategoryLabel => 'Main category';

  @override
  String get dbKarakaLabel => 'Debt Karaka';

  @override
  String get dbProtectorLabel => 'Creditor Protection';

  @override
  String get dbSecondaryCategories => 'Secondary categories';

  @override
  String get dbUnsecuredRatio => 'Unsecured-debt ratio';

  @override
  String get dbKarakaTitle => 'Your Debt Planets';

  @override
  String get dbKarakaSubtitle =>
      'How strongly each planet supports your debt recovery';

  @override
  String get dbVerificationTitle => 'Verified Across Charts (D6)';

  @override
  String get dbD6Label => 'D6 Debt & Enemies Chart';

  @override
  String get dbD6LordDignity => '6th lord strength';

  @override
  String get dbD6Severity => 'Debt karma severity';

  @override
  String get dbD6Multiplier => 'D6 debt multiplier';

  @override
  String get dbYogasTitle => 'Debt Yogas & Protections';

  @override
  String get dbPressureNow => 'Debt Pressure Now';

  @override
  String get dbRecoveryBoost => 'Recovery Boost';

  @override
  String get dbClearingLabel => 'Debt-Clearing Yogas';

  @override
  String get dbCreatingLabel => 'Debt-Creating Yogas';

  @override
  String get dbCategoriesTitle => 'Debt Categories Watch';

  @override
  String get dbCategoriesSubtitle =>
      'Which types of debt need the most attention';

  @override
  String get dbTimelineTitle => 'Debt-Free Timeline';

  @override
  String get dbFreeWindowLabel => 'DEBT-FREE WINDOW';

  @override
  String get dbClearanceEstimate => 'Full clearance estimate';

  @override
  String get dbPeakYears => 'Debt-Peak Years';

  @override
  String get dbClearanceYears => 'Clearance Years';

  @override
  String get dbBorrowTitle => 'Smart Borrowing Guide';

  @override
  String get dbLoanSuitability => 'Loan Suitability';

  @override
  String get dbBestLoanType => 'Best Loan Type';

  @override
  String get dbLeverageCeiling => 'Leverage Ceiling';

  @override
  String get dbNegotiationSuccess => 'Negotiation Success';

  @override
  String get dbCreditorAggression => 'Creditor Pressure Risk';

  @override
  String get dbLegalEscalation => 'Legal Escalation Risk';

  @override
  String get dbNegotiationApproach => 'Recommended approach';

  @override
  String get dbAvoidLoanTypes => 'Loan Types to Avoid';

  @override
  String get dbRiskTitle => 'Risk & Vulnerability Watch';

  @override
  String get dbRiskDefault => 'Default Risk';

  @override
  String get dbRiskDefaultExp =>
      'The chance of missing a scheduled repayment badly enough to trigger default status with a lender.';

  @override
  String get dbRiskDefaultFix =>
      'Automate minimum payments and keep a 1-month buffer so a single missed income cycle doesn\'t cascade.';

  @override
  String get dbRiskBankruptcy => 'Bankruptcy Risk';

  @override
  String get dbRiskBankruptcyExp =>
      'The probability that debt load grows beyond what income and assets can realistically cover.';

  @override
  String get dbRiskBankruptcyFix =>
      'Get a professional debt review before taking any new loan or credit line.';

  @override
  String get dbRiskAssetSeizure => 'Asset-Seizure Risk';

  @override
  String get dbRiskAssetSeizureExp =>
      'The chance a secured loan default could lead to a lender repossessing collateral or property.';

  @override
  String get dbRiskAssetSeizureFix =>
      'Prioritize secured-loan payments first, and refinance early if a payment gap looks likely.';

  @override
  String get dbRiskChronic => 'Chronic Re-Debt Risk';

  @override
  String get dbRiskChronicExp =>
      'The tendency to fall back into debt again even after clearing the current load.';

  @override
  String get dbRiskChronicFix =>
      'Build a dedicated emergency fund before increasing lifestyle spending after clearance.';

  @override
  String get dbReindebtTrigger => 'Re-Debt Trigger';

  @override
  String get dbCycleBreakFeasibility => 'Cycle-Break Feasibility';

  @override
  String get dbMajorRisks => 'Major Risks';

  @override
  String get dbHiddenSignals => 'Hidden Debt Signals';

  @override
  String get dbCrisisTitle => 'Crisis Preparedness';

  @override
  String get dbCrisisSubtitle => 'How to spot trouble early and respond calmly';

  @override
  String get dbWarningSigns => 'Early Warning Signs';

  @override
  String get dbMitigationActions => 'What To Do About It';

  @override
  String get dbFamilyTitle => 'Family & Ancestral Debt';

  @override
  String get dbInheritedDebtProb => 'Inherited-Debt Chance';

  @override
  String get dbFamilyDrag => 'Family Debt Drag';

  @override
  String get dbInheritedSource => 'Likely source';

  @override
  String get dbCoreBlockerLabel => 'CORE BLOCKER';

  @override
  String get dbPsychologyTitle => 'Your Money Psychology';

  @override
  String get dbResilience => 'Resilience';

  @override
  String get dbDiscipline => 'Discipline Under Pressure';

  @override
  String get dbSocialSupport => 'Social Support';

  @override
  String get dbDepressionRisk => 'Financial-Stress Vulnerability';

  @override
  String get dbStressTolerance => 'Stress tolerance';

  @override
  String get dbRootCause => 'Behavioral Root Cause';

  @override
  String get dbImprovementTitle => 'Improvement Plan';

  @override
  String get dbRoadmapTitle => 'Your Debt-Free Roadmap';

  @override
  String get dbRecoveryProbability => 'Recovery Probability';

  @override
  String get dbClearanceTimeline => 'Clearance Timeline';

  @override
  String get dbYears => 'years';

  @override
  String get dbDtiHealth => 'Debt-to-Income Health';

  @override
  String get dbDtiCategory => 'DTI Category';

  @override
  String get dbBreakEvenMonths => 'Months to break-even';

  @override
  String get dbIncomeAcceleration => 'Income growth needed';

  @override
  String get dbLayerD1 => 'Birth Chart (D1)';

  @override
  String get dbLayerD6 => 'Debt & Enemies (D6)';

  @override
  String get dbLayerD9 => 'Navamsa (D9)';

  @override
  String get dbLayerDasha => 'Dasha Timing';

  @override
  String get dbLayerTransit => 'Current Transits';

  @override
  String get dbTopicRecovery => 'My recovery timeline';

  @override
  String get dbTopicNegotiate => 'Negotiating with creditors';

  @override
  String get dbTopicBorrowing => 'Is it safe to borrow now';

  @override
  String get dbTopicCrisis => 'Preparing for a crisis';

  @override
  String get dbTopicAncestral => 'Ancestral debt karma';

  @override
  String get dbTopicTimeline => 'Best years to clear debt';

  @override
  String get dbTopicPsychology => 'My money psychology';

  @override
  String get dbTopicCategories => 'Which debts to prioritize';

  @override
  String get mnSubtitle => 'AI-powered Vedic Wellness Report';

  @override
  String get mnTitle => 'Mental & Stress';

  @override
  String get mnSnapshotHeader => 'Wellness Snapshot';

  @override
  String get mnResilience => 'Resilience';

  @override
  String get mnStability => 'Stability';

  @override
  String get mnEmotionalBalance => 'Emotional Balance';

  @override
  String get mnInnerCalm => 'Inner Calm';

  @override
  String get mnSelfAwareness => 'Self-Awareness';

  @override
  String get mnStatusThriving => 'Thriving';

  @override
  String get mnStatusSteady => 'Steady & Stable';

  @override
  String get mnStatusBuildingStrength => 'Building Strength';

  @override
  String get mnStatusNeedsGentleCare => 'Needs Gentle Care';

  @override
  String get mnStatusReachOut => 'Time to Reach Out for Support';

  @override
  String get mnChipStable => 'Emotionally Stable';

  @override
  String get mnChipSupported => 'Well Supported';

  @override
  String get mnChipSelfAware => 'Highly Self-Aware';

  @override
  String get mnChipResilient => 'Bounces Back Well';

  @override
  String get mnChipSecureAttachment => 'Secure Attachment';

  @override
  String get mnChipHealingReady => 'Ready to Heal';

  @override
  String get mnChipMindBodyBalance => 'Mind-Body Balance';

  @override
  String get mnSupportBannerTitle => 'A Gentle Note';

  @override
  String get mnSupportBannerBody =>
      'Your chart suggests this could be a good time to lean on extra support — a trusted friend, family member, or professional. Reaching out is a sign of strength, not weakness.';

  @override
  String get mnProfileTitle => 'Your Emotional Blueprint';

  @override
  String get mnStressDriver => 'Stress Driver';

  @override
  String get mnStabilityAnchor => 'Stability Anchor';

  @override
  String get mnSoulLevelKarma => 'Soul-Level Pattern';

  @override
  String get mnSubtleSignature => 'Subtle Emotional Signature';

  @override
  String get mnKarakaTitle => 'Your Mind & Planets';

  @override
  String get mnKarakaSubtitle => 'Which planets shape your inner world';

  @override
  String get mnYogasTitle => 'Strengths & Growth Areas';

  @override
  String get mnCurrentPhase => 'Current Phase';

  @override
  String get mnCurrentStressLevel => 'Current Stress Level';

  @override
  String get mnRecentStrain => 'Recent Emotional Strain';

  @override
  String get mnStrengths => 'Strengths';

  @override
  String get mnGrowthAreas => 'Growth Areas';

  @override
  String get mnSadeSatiStatus => 'Sade Sati Status';

  @override
  String get mnVerificationTitle => 'Verified Across Charts';

  @override
  String get mnD9Confirmation => 'D9 Confirmation';

  @override
  String get mnD30Confirmation => 'D30 Confirmation';

  @override
  String get mnMoodPatternsTitle => 'Mood & Anxiety Patterns';

  @override
  String get mnMoodPatternsSubtitle => 'Gentle awareness, not a diagnosis';

  @override
  String get mnAnxietyPatterns => 'Anxiety Patterns';

  @override
  String get mnMoodPatterns => 'Low-Mood Patterns';

  @override
  String get mnPrimaryPattern => 'Primary Pattern';

  @override
  String get mnRumination => 'Overthinking Tendency';

  @override
  String get mnHypervigilance => 'Hyper-Alertness';

  @override
  String get mnHopelessnessVuln => 'Low-Mood Sensitivity';

  @override
  String get mnEnergyDepletion => 'Energy Depletion Tendency';

  @override
  String get mnMotivationBaseline => 'Motivation Baseline';

  @override
  String get mnRegulationTitle => 'Emotional Regulation & Coping';

  @override
  String get mnEmotionalRegulation => 'Emotional Regulation';

  @override
  String get mnSelfSoothing => 'Self-Soothing Ability';

  @override
  String get mnExpressionStyle => 'Expression Style';

  @override
  String get mnRecoveryTime => 'Recovery Time';

  @override
  String get mnTriggerIntensity => 'Trigger Intensity';

  @override
  String get mnHealthyCoping => 'Healthy Coping Habits';

  @override
  String get mnWatchFor => 'Gently Watch For';

  @override
  String get mnSleepTitle => 'Sleep & Rest';

  @override
  String get mnSleepQuality => 'Sleep Quality';

  @override
  String get mnSleepAsRegulator => 'Sleep as Emotional Regulator';

  @override
  String get mnInsomniaTendency => 'Restless-Night Tendency';

  @override
  String get mnNightmareTendency => 'Vivid-Dream Tendency';

  @override
  String get mnSleepHygienePriority => 'Sleep Hygiene Priority';

  @override
  String get mnBurnoutTitle => 'Burnout & Energy';

  @override
  String get mnBurnoutVulnerability => 'Burnout Sensitivity';

  @override
  String get mnBurnoutRecovery => 'Burnout Recovery Capacity';

  @override
  String get mnBurnoutStage => 'Current Burnout Stage';

  @override
  String get mnSelfDrivingTendency => 'Self-Driving Tendency';

  @override
  String get mnBurnoutTriggers => 'Burnout Triggers';

  @override
  String get mnConnectionTitle => 'Connection & Support';

  @override
  String get mnSocialSupport => 'Social Support Quality';

  @override
  String get mnLonelinessVuln => 'Loneliness Sensitivity';

  @override
  String get mnSolitudeNeed => 'Need for Solitude';

  @override
  String get mnSocialComfort => 'Social Comfort';

  @override
  String get mnTraumaSensitivity => 'Trauma Sensitivity';

  @override
  String get mnHealingReadiness => 'Healing Readiness';

  @override
  String get mnProcessingStyle => 'Processing Style';

  @override
  String get mnMindBodyIntegration => 'Mind-Body Integration';

  @override
  String get mnPtsdVuln => 'Trauma-Response Sensitivity';

  @override
  String get mnSelfAwarenessTitle => 'Self-Awareness & Growth';

  @override
  String get mnSelfAwarenessScore => 'Self-Awareness';

  @override
  String get mnEmotionalVocabulary => 'Emotional Vocabulary';

  @override
  String get mnTherapyReadiness => 'Therapy Readiness';

  @override
  String get mnJournalingBenefit => 'Journaling Benefit';

  @override
  String get mnInnerDialogue => 'Inner Dialogue Quality';

  @override
  String get mnAwarenessOfPatterns => 'Awareness of Patterns';

  @override
  String get mnEscapePatternVuln => 'Escape-Pattern Sensitivity';

  @override
  String get mnEscapeChannels => 'Gently Watch For';

  @override
  String get mnHealthyAlternatives => 'Healthy Alternatives';

  @override
  String get mnTherapyFitTitle => 'Therapy & Support Fit';

  @override
  String get mnCrisisSupportRec => 'Support Recommendation';

  @override
  String get mnSupportNetwork => 'Activate Your Support Network';

  @override
  String get mnSelfAdvocacy => 'Self-Advocacy Readiness';

  @override
  String get mnMedicationReceptivity => 'Medication Receptivity';

  @override
  String get mnTimelineTitle => 'Wellness Timeline';

  @override
  String get mnPeakWellnessYears => 'Peak Wellness Years';

  @override
  String get mnExtraCareYears => 'Years for Extra Self-Care';

  @override
  String get mnTransformationWindows => 'Positive Transformation Windows';

  @override
  String get mnTherapyWindow => 'Recommended Therapy Window';

  @override
  String get mnPracticesTitle => 'Daily Wellness Practices';

  @override
  String get mnMorningPractices => 'Morning Practices';

  @override
  String get mnEveningPractices => 'Evening Practices';

  @override
  String get mnBreathwork => 'Breathwork';

  @override
  String get mnMovement => 'Movement';

  @override
  String get mnNutrition => 'Nutrition';

  @override
  String get mnNatureExposure => 'Nature Exposure Need';

  @override
  String get mnDigitalDetox => 'Digital Detox Need';

  @override
  String get mnImprovementTitle => 'Improvement Plan';

  @override
  String get mnReliabilityTitle => 'Reliability';

  @override
  String get mnLayerD1 => 'Birth Chart (D1)';

  @override
  String get mnLayerD9 => 'Soul Chart (D9)';

  @override
  String get mnLayerD30 => 'D30 Chart';

  @override
  String get mnLayerDasha => 'Dasha Timing';

  @override
  String get mnLayerTransit => 'Transits';

  @override
  String get mnTopicResilience => 'How resilient am I emotionally?';

  @override
  String get mnTopicCoping => 'What are my best coping strategies?';

  @override
  String get mnTopicSleep => 'How can I improve my sleep?';

  @override
  String get mnTopicBurnout => 'Am I at risk of burnout?';

  @override
  String get mnTopicTherapy => 'Which therapy style suits me?';

  @override
  String get mnTopicPractices => 'What daily practices help me most?';

  @override
  String get mnTopicTiming => 'When are my best wellness years?';

  @override
  String get mnTopicSupport => 'How do I build a strong support network?';

  @override
  String get lgSubtitle => 'AI-powered Vedic Legal Report';

  @override
  String get lgTitle => 'Legal & Disputes';

  @override
  String get lgSnapshotHeader => 'Legal Snapshot';

  @override
  String get lgResilience => 'Legal Resilience';

  @override
  String get lgResolutionCapacity => 'Resolution Capacity';

  @override
  String get lgVictoryPotential => 'Victory Potential';

  @override
  String get lgLegalSafety => 'Legal Safety';

  @override
  String get lgNegotiationSkill => 'Negotiation Skill';

  @override
  String get lgStatusExcellent => 'Excellent';

  @override
  String get lgStatusStrong => 'Strong';

  @override
  String get lgStatusModerate => 'Moderate';

  @override
  String get lgStatusDeveloping => 'Developing';

  @override
  String get lgStatusChallenging => 'Challenging';

  @override
  String get lgChipResolver => 'Skilled Resolver';

  @override
  String get lgChipWinner => 'Strong Case Wins';

  @override
  String get lgChipNegotiator => 'Natural Negotiator';

  @override
  String get lgChipDocumented => 'Well Documented';

  @override
  String get lgChipLowRisk => 'Low Legal Risk';

  @override
  String get lgChipMoralAuthority => 'Moral Authority';

  @override
  String get lgChipLegalAptitude => 'Legal Aptitude';

  @override
  String get lgProfileTitle => 'Your Legal Profile & Karma';

  @override
  String get lgPrimaryDriver => 'Primary Driver';

  @override
  String get lgDharmaAnchor => 'Dharma Anchor';

  @override
  String get lgAggressionMarker => 'Aggression Marker';

  @override
  String get lgDocumentationKaraka => 'Documentation Quality';

  @override
  String get lgKarakaTitle => 'Your Legal Planets';

  @override
  String get lgKarakaSubtitle => 'Which planets shape your legal fortune';

  @override
  String get lgYogasTitle => 'Legal Yogas & Protections';

  @override
  String get lgCurrentPhase => 'Current Phase';

  @override
  String get lgProtections => 'Protections';

  @override
  String get lgDisputePressures => 'Dispute Pressures';

  @override
  String get lgVerificationTitle => 'Verified Across Charts';

  @override
  String get lgD6Litigation => 'D6 Litigation Chart';

  @override
  String get lgD9Dharma => 'D9 Dharma Chart';

  @override
  String get lgMoralAuthority => 'Moral Authority';

  @override
  String get lgVictoryTitle => 'Victory Analysis';

  @override
  String get lgAsPlaintiff => 'As Plaintiff';

  @override
  String get lgAsDefendant => 'As Defendant';

  @override
  String get lgSettlementPreference => 'Settlement Preference';

  @override
  String get lgDisputeCategoriesTitle => 'Dispute Categories Watch';

  @override
  String get lgLowRiskCategories => 'Low-Risk Categories';

  @override
  String get lgConflictStyleTitle => 'Conflict Style & Enemies';

  @override
  String get lgConfrontationComfort => 'Confrontation Comfort';

  @override
  String get lgArgumentPersuasiveness => 'Argument Persuasiveness';

  @override
  String get lgEmotionalRegulation => 'Emotional Regulation';

  @override
  String get lgGrudgeHolding => 'Grudge-Holding Tendency';

  @override
  String get lgEnemyAnalysisLabel => 'Enemy Analysis';

  @override
  String get lgVisibleEnemies => 'Visible Enemies';

  @override
  String get lgHiddenEnemies => 'Hidden Enemies';

  @override
  String get lgWorkplaceEnemies => 'Workplace Enemies';

  @override
  String get lgFamilyEnemies => 'Family Enemies';

  @override
  String get lgLegalEnemies => 'Legal Enemies';

  @override
  String get lgEnemyDefeatCapacity => 'Enemy Defeat Capacity';

  @override
  String get lgCriminalFinancialTitle => 'Criminal & Financial Risk Watch';

  @override
  String get lgCriminalRisk => 'Criminal Involvement Risk';

  @override
  String get lgVictimOfCrime => 'Victim of Crime Chance';

  @override
  String get lgFalseAccusation => 'False Accusation Risk';

  @override
  String get lgImprisonmentRisk => 'Imprisonment Risk';

  @override
  String get lgTaxDisputeRisk => 'Tax Dispute Risk';

  @override
  String get lgFinancialFraudRisk => 'Financial Fraud Risk';

  @override
  String get lgBusinessLitigationRisk => 'Business Litigation Risk';

  @override
  String get lgBankruptcyRisk => 'Bankruptcy Risk';

  @override
  String get lgAuditVulnerability => 'Audit Vulnerability';

  @override
  String get lgProtectionPriority => 'Protection Priority';

  @override
  String get lgContractsTitle => 'Contracts & Negotiation';

  @override
  String get lgContractClarity => 'Contract Clarity';

  @override
  String get lgDocumentationDiscipline => 'Documentation Discipline';

  @override
  String get lgFinePrintAwareness => 'Fine-Print Awareness';

  @override
  String get lgSignatureCaution => 'Signature Caution';

  @override
  String get lgMediationReceptivity => 'Mediation Receptivity';

  @override
  String get lgNegotiationSkillFull => 'Negotiation Skill';

  @override
  String get lgCompromiseWillingness => 'Compromise Willingness';

  @override
  String get lgFaceSavingNeeds => 'Face-Saving Needs';

  @override
  String get lgMediatorHireRecommendation => 'Mediator Hire Recommendation';

  @override
  String get lgTypicalContractIssues => 'Typical Contract Issues';

  @override
  String get lgCareerFitTitle => 'Legal Career Fit';

  @override
  String get lgProfessionAffinity => 'Profession Affinity';

  @override
  String get lgRoleFit => 'Best Role Fit';

  @override
  String get lgLawStudentSuccess => 'Law Student Success';

  @override
  String get lgBarExamSuccess => 'Bar Exam Success';

  @override
  String get lgTimelineTitle => 'Legal Timeline';

  @override
  String get lgNewMatterChance => 'New Matter Chance (Next 12M)';

  @override
  String get lgOngoingCaseOutcome => 'Ongoing Case Outcome';

  @override
  String get lgRecommendedAction => 'Recommended Action';

  @override
  String get lgPeakDisputeYears => 'Peak Dispute Years';

  @override
  String get lgClarityYears => 'Legal Clarity Years';

  @override
  String get lgAvoidancePeriods => 'Critical Avoidance Periods';

  @override
  String get lgFavorableWindows => 'Favorable Resolution Windows';

  @override
  String get lgRisksTitle => 'Risks & Vulnerabilities';

  @override
  String get lgChronicVulnerabilities => 'Chronic Vulnerabilities';

  @override
  String get lgAvoidDashaPeriods => 'Dasha Periods to Watch';

  @override
  String get lgPreventivePriorities => 'Preventive Priorities';

  @override
  String get lgRedFlags => 'Red-Flag Situations';

  @override
  String get lgImprovementTitle => 'Improvement Plan';

  @override
  String get lgReliabilityTitle => 'Reliability';

  @override
  String get lgLayerD1 => 'Birth Chart (D1)';

  @override
  String get lgLayerD6 => 'Litigation Chart (D6)';

  @override
  String get lgLayerD9 => 'Dharma Chart (D9)';

  @override
  String get lgLayerDasha => 'Dasha Timing';

  @override
  String get lgLayerTransit => 'Transits';

  @override
  String get lgTopicWinChance => 'What are my winning chances?';

  @override
  String get lgTopicStrategy => 'Best legal strategy for me?';

  @override
  String get lgTopicContract => 'Contract risks to watch?';

  @override
  String get lgTopicTiming => 'Best timing to resolve disputes?';

  @override
  String get lgTopicSettlement => 'Should I settle or fight?';

  @override
  String get lgTopicEnemies => 'Who are my hidden enemies?';

  @override
  String get lgTopicProtection => 'How to protect myself legally?';

  @override
  String get lgTopicCareer => 'Am I suited for a legal career?';

  @override
  String get prSubtitle => 'AI-powered Vedic Property Report';

  @override
  String get prTitle => 'Property & Assets';

  @override
  String get prSnapshotHeader => 'Property Snapshot';

  @override
  String get prAcquisitionCapacity => 'Acquisition Capacity';

  @override
  String get prHomeOwnership => 'Home Ownership';

  @override
  String get prWealthPotential => 'Wealth Potential';

  @override
  String get prRentalIncome => 'Rental Income';

  @override
  String get prLandOwnership => 'Land Ownership';

  @override
  String get prStatusExcellent => 'Excellent';

  @override
  String get prStatusStrong => 'Strong';

  @override
  String get prStatusModerate => 'Moderate';

  @override
  String get prStatusDeveloping => 'Developing';

  @override
  String get prStatusChallenging => 'Challenging';

  @override
  String get prChipHomeOwner => 'Home Owner';

  @override
  String get prChipWealthBuilder => 'Wealth Builder';

  @override
  String get prChipLandOwner => 'Land Owner';

  @override
  String get prChipInvestor => 'Property Investor';

  @override
  String get prChipInheritance => 'Inheritance Likely';

  @override
  String get prChipVehicle => 'Vehicle Owner';

  @override
  String get prChipGlobalAsset => 'Global Asset Affinity';

  @override
  String get prProfileTitle => 'Your Property Style';

  @override
  String get prHomeAesthetics => 'Home Aesthetics';

  @override
  String get prHomeSanctuary => 'Home as Sanctuary';

  @override
  String get prComfortInvestment => 'Comfort Investment';

  @override
  String get prVastuPriority => 'Vastu Priority';

  @override
  String get prNaturalElements => 'Natural Elements';

  @override
  String get prNextActionLabel => 'Next Action';

  @override
  String get prKarakaTitle => 'Your Property Planets';

  @override
  String get prKarakaSubtitle => 'Which planets shape your property luck';

  @override
  String get prPrimaryKaraka => 'Primary Karaka';

  @override
  String get prDurableAsset => 'Durable Asset Karaka';

  @override
  String get prYogasTitle => 'Property Yogas & Doshas';

  @override
  String get prCurrentPhase => 'Current Phase';

  @override
  String get prBoosters => 'Boosters';

  @override
  String get prDrains => 'Drains';

  @override
  String get prVerificationTitle => 'Verified Across Charts';

  @override
  String get prD4Property => 'D4 Property Chart';

  @override
  String get prD16Vehicle => 'D16 Vehicle Chart';

  @override
  String get prVehicleFit => 'Vehicle Fit';

  @override
  String get prJourneyTitle => 'Ownership Journey & Timeline';

  @override
  String get prFirstHomeAge => 'First Home Age';

  @override
  String get prFirstHomeType => 'First Home Type';

  @override
  String get prMultipleHomes => 'Multiple Homes';

  @override
  String get prNewPropertySoon => 'New Property Soon';

  @override
  String get prFirstMajorWindow => 'First Major Window';

  @override
  String get prBuyingWindow => 'Buying Window';

  @override
  String get prConstructionWindow => 'Construction Window';

  @override
  String get prNextOpportunity => 'Next Opportunity';

  @override
  String get prLifetimePropertyCount => 'Lifetime Property Count';

  @override
  String get prInheritanceTitle => 'Inheritance & Family Property';

  @override
  String get prMaternalInheritance => 'Maternal Inheritance';

  @override
  String get prPaternalInheritance => 'Paternal Inheritance';

  @override
  String get prAncestralProperty => 'Ancestral Property';

  @override
  String get prFamilyDisputeRisk => 'Family Dispute Risk';

  @override
  String get prInheritanceTiming => 'Inheritance Timing';

  @override
  String get prInheritanceType => 'Inheritance Type';

  @override
  String get prLandInvestTitle => 'Land, Investment & Global Property';

  @override
  String get prPropertyInvestor => 'Property Investor Score';

  @override
  String get prAppreciationLuck => 'Appreciation Luck';

  @override
  String get prInvestorMindset => 'Investor Mindset';

  @override
  String get prLandType => 'Land Type';

  @override
  String get prRentalCount => 'Rental Property Count';

  @override
  String get prMultipleLand => 'Multiple Land Parcels';

  @override
  String get prFarmEstate => 'Farm / Estate Chance';

  @override
  String get prGlobalPropertyLabel => 'Global Property';

  @override
  String get prForeignProperty => 'Foreign Property';

  @override
  String get prNriAffinity => 'NRI Asset Affinity';

  @override
  String get prVehiclesTitle => 'Vehicles';

  @override
  String get prVehicleCount => 'Vehicle Count';

  @override
  String get prVehicleFirstAge => 'First Vehicle Age';

  @override
  String get prVehicleCategory => 'Vehicle Category';

  @override
  String get prVehicleQuality => 'Vehicle Quality';

  @override
  String get prLuxuryAffinity => 'Luxury Affinity';

  @override
  String get prVehicleLossRisk => 'Vehicle Loss / Damage Risk';

  @override
  String get prLegalRiskTitle => 'Legal & Risk Watch';

  @override
  String get prBoundaryDisputes => 'Boundary Disputes';

  @override
  String get prPartitionDisputes => 'Partition Disputes';

  @override
  String get prTitleIssues => 'Title / Documentation Issues';

  @override
  String get prTenantConflict => 'Tenant-Landlord Conflict';

  @override
  String get prForcedSale => 'Forced Sale Risk';

  @override
  String get prPropertyDamage => 'Property Damage Risk';

  @override
  String get prInsurancePriority => 'Insurance Priority';

  @override
  String get prProtectionUrgency => 'Protection Urgency';

  @override
  String get prProtectiveFactors => 'Protective Factors';

  @override
  String get prChronicVulnerabilities => 'Chronic Vulnerabilities';

  @override
  String get prDueDiligenceTitle => 'Due Diligence Checklist';

  @override
  String get prPreventiveMeasures => 'Preventive Measures';

  @override
  String get prImprovementTitle => 'Improvement Plan';

  @override
  String get prReliabilityTitle => 'Reliability';

  @override
  String get prLayerD1 => 'Birth Chart (D1)';

  @override
  String get prLayerD4 => 'Property Chart (D4)';

  @override
  String get prLayerD16 => 'Vehicle Chart (D16)';

  @override
  String get prLayerDasha => 'Dasha Timing';

  @override
  String get prLayerTransit => 'Transits';

  @override
  String get prTopicBuying => 'Best time to buy?';

  @override
  String get prTopicInherit => 'Will I inherit property?';

  @override
  String get prTopicVehicle => 'When will I get a vehicle?';

  @override
  String get prTopicRental => 'Rental income potential?';

  @override
  String get prTopicLand => 'Land ownership chances?';

  @override
  String get prTopicLegal => 'Legal risks to watch?';

  @override
  String get prTopicForeign => 'Foreign property chances?';

  @override
  String get prTopicTiming => 'Best property timing windows?';

  @override
  String get edTitle => 'Education & Learning Analysis';

  @override
  String get edSubtitle => 'AI-powered Vedic Education Report';

  @override
  String get edSnapshotHeader => 'Your Education Snapshot';

  @override
  String get edOverallStrength => 'Overall Strength';

  @override
  String get edAcademicSuccess => 'Academic Success';

  @override
  String get edLearningCapacity => 'Learning Capacity';

  @override
  String get edIntellect => 'Intellect';

  @override
  String get edMemory => 'Memory';

  @override
  String get edStatusExcellent => 'Excellent Potential';

  @override
  String get edStatusStrong => 'Strong Potential';

  @override
  String get edStatusModerate => 'Moderate Potential';

  @override
  String get edStatusDeveloping => 'Developing Potential';

  @override
  String get edStatusChallenging => 'Challenging Phase';

  @override
  String get edChipSaraswati => 'Saraswati Yoga';

  @override
  String get edChipGajaKesari => 'Gaja Kesari Yoga';

  @override
  String get edChipBudhaAditya => 'Budha Aditya Yoga';

  @override
  String get edChipResearch => 'Strong Research Ability';

  @override
  String get edChipScholarship => 'Scholarship Potential';

  @override
  String get edChipDoctorate => 'Doctorate Potential';

  @override
  String get edChipForeign => 'Foreign Education Support';

  @override
  String get edChipLifelong => 'Lifelong Learner';

  @override
  String get edLearningStyleTitle => 'Your Learning Style';

  @override
  String get edSoulPlanet => 'Soul Planet';

  @override
  String get edSoulHint => 'Your deepest inner drive and life purpose';

  @override
  String get edSubjectPlanet => 'Subject Planet';

  @override
  String get edTechAtmakaraka => 'Atmakaraka (technical)';

  @override
  String get edTechAmatyakaraka => 'Amatyakaraka (technical)';

  @override
  String get edSubjectKarakaStrength => 'Subject Karaka Strength';

  @override
  String get edFoundationTitle => 'Education Foundation';

  @override
  String get edHouse4 => 'Early Schooling';

  @override
  String get edHouse5 => 'Intelligence';

  @override
  String get edHouse9 => 'Higher Learning';

  @override
  String get edPurvaPunya => 'Past-Life Merit';

  @override
  String get edStudyPlanetsTitle => 'Your Study Planets';

  @override
  String get edYogasTitle => 'Education Yogas in Your Chart';

  @override
  String get edYogaBudhaAditya => 'Budha Aditya';

  @override
  String get edYogaGajaKesari => 'Gaja Kesari';

  @override
  String get edYogaSaraswati => 'Saraswati';

  @override
  String get edYogaPresent => 'Present';

  @override
  String get edYogaAbsent => 'Absent';

  @override
  String get edYogaNoneNote =>
      'No classical education yogas — success comes from consistent effort and discipline.';

  @override
  String get edVerificationTitle => 'Verification Across Charts';

  @override
  String get edD24Learning => 'D24 — Deep Learning Chart';

  @override
  String get edD4Formal => 'D4 — Formal Education Chart';

  @override
  String get edD9Dharma => 'D9 — Learning Dharma Chart';

  @override
  String get edD60Karma => 'D60 — Past-Life Learning Karma';

  @override
  String get edSubjectsTitle => 'Best Subjects For You';

  @override
  String get edSubjectsSubtitle => 'Ranked by chart affinity';

  @override
  String get edLowAffinity => 'Lower-Affinity Subjects';

  @override
  String get edDegreesTitle => 'Degree & Level Likelihood';

  @override
  String get edExpectedLevel => 'Expected Level';

  @override
  String get edDegreeFormal => 'Formal Degree';

  @override
  String get edDegreePostgrad => 'Postgraduate';

  @override
  String get edDegreeDoctorate => 'Doctorate';

  @override
  String get edDegreeForeign => 'Foreign Education';

  @override
  String get edTimelineTitle => 'Study Timeline';

  @override
  String get edEarlySchooling => 'Early Schooling Window';

  @override
  String get edHigherEducation => 'Higher Education Window';

  @override
  String get edPostgradResearch => 'Postgrad / Research Window';

  @override
  String get edPeakLearningAge => 'Peak Learning Age';

  @override
  String get edPreferencesTitle => 'Learning Preferences & Support';

  @override
  String get edPrefStudyMode => 'Study Mode';

  @override
  String get edPrefTiming => 'Best Time';

  @override
  String get edPrefEnvironment => 'Environment';

  @override
  String get edPrefLocation => 'Location';

  @override
  String get edPrefForeign => 'Foreign Study';

  @override
  String get edGuruRelationship => 'Teacher/Guru Bond';

  @override
  String get edMentorAvailability => 'Mentor Availability';

  @override
  String get edPeerLearning => 'Peer Learning';

  @override
  String get edAuthorityDeference => 'Respect for Authority';

  @override
  String get edStrengthsTitle => 'Strengths & Challenges';

  @override
  String get edCognitiveGifts => 'Cognitive Gifts';

  @override
  String get edNaturalAbilities => 'Natural Learning Abilities';

  @override
  String get edHiddenCapacities => 'Hidden Capacities';

  @override
  String get edConcentration => 'Concentration Difficulty';

  @override
  String get edBreakRisk => 'Education Break Risk';

  @override
  String get edDisciplineConsistency => 'Discipline Consistency';

  @override
  String get edScholarshipLikelihood => 'Scholarship Likelihood';

  @override
  String get edCareerLinkTitle => 'Education → Career Path';

  @override
  String get edDirectionRec => 'Recommended Direction';

  @override
  String get edIntegrationStrategy => 'Integration Strategy';

  @override
  String get edCareerLinkage => 'Career Linkage';

  @override
  String get edAlignedSubjects => 'Career-Aligned Subjects';

  @override
  String get edDegreeUtility => 'Degree Utility for Career';

  @override
  String get edImprovementTitle => 'Your Improvement Plan';

  @override
  String get edReliabilityTitle => 'Prediction Reliability';

  @override
  String get edLayerD1 => 'Birth Chart (D1)';

  @override
  String get edLayerD4 => 'Formal Education (D4)';

  @override
  String get edLayerD9 => 'Navamsa (D9)';

  @override
  String get edLayerD24 => 'Deep Learning (D24)';

  @override
  String get edLayerD60 => 'Past-Life Learning (D60)';

  @override
  String get edLayerAmk => 'Subject Karaka';

  @override
  String get edLayerMj => 'Mercury-Jupiter';

  @override
  String get edLayerDasha => 'Planetary Timing';

  @override
  String get edTopicSubjects => 'Best Subjects for Me';

  @override
  String get edTopicDegree => 'Degree Chances';

  @override
  String get edTopicAbroad => 'Studying Abroad';

  @override
  String get edTopicExam => 'Exam Performance';

  @override
  String get edTopicHabits => 'Study Habits';

  @override
  String get edTopicCareerLink => 'Education-to-Career Link';

  @override
  String get edTopicTiming => 'Education Timing Windows';

  @override
  String get edTopicScholarship => 'Scholarship Chances';

  @override
  String get hwTitle => 'Health & Wellness Analysis';

  @override
  String get hwSubtitle => 'AI-powered Vedic Health & Wellness Report';

  @override
  String get hwSnapshotHeader => 'Your Health Snapshot';

  @override
  String get hwOverallVitality => 'Vitality';

  @override
  String get hwImmunity => 'Immunity';

  @override
  String get hwRecovery => 'Recovery';

  @override
  String get hwMentalWellness => 'Mental Wellness';

  @override
  String get hwStressTolerance => 'Stress Tolerance';

  @override
  String get hwStatusThriving => 'Thriving';

  @override
  String get hwStatusGood => 'Good Vitality';

  @override
  String get hwStatusBalanced => 'Balanced';

  @override
  String get hwStatusNeedsCare => 'Needs Care';

  @override
  String get hwStatusNeedsAttention => 'Needs Attention';

  @override
  String get hwChipImmunity => 'Strong Immunity';

  @override
  String get hwChipRecovery => 'Fast Recovery';

  @override
  String get hwChipMentalBalance => 'Balanced Mind';

  @override
  String get hwChipStressResilience => 'Stress Resilient';

  @override
  String get hwChipFertility => 'Fertility Support';

  @override
  String get hwChipWorkLife => 'Good Work-Life Balance';

  @override
  String get hwChipLowAddiction => 'Low Addiction Risk';

  @override
  String get hwConstitutionTitle => 'Your Body Type';

  @override
  String get hwConstitutionSubtitle => 'Ayurvedic constitution from your chart';

  @override
  String get hwDominantDosha => 'Dominant';

  @override
  String get hwSecondaryDosha => 'Secondary';

  @override
  String get hwPrimaryKaraka => 'Main Health Indicator';

  @override
  String get hwStrongestSystem => 'Strongest System';

  @override
  String get hwWeakestSystem => 'System to Support';

  @override
  String get hwBodyMapTitle => 'Your Body\'s Planetary Map';

  @override
  String get hwBodyMapSubtitle => '9 planets, 9 body systems';

  @override
  String get hwYogaTitle => 'Health Patterns in Your Chart';

  @override
  String get hwYogaSubtitle => 'Protective vs disease-pressure yogas';

  @override
  String get hwDiseasePressureLabel => 'DISEASE PRESSURE';

  @override
  String get hwAreasTitle => 'Body Areas to Watch';

  @override
  String get hwAreasSubtitle => 'Vulnerability by body zone';

  @override
  String get hwProtectedAreas => 'Well-Protected Areas';

  @override
  String get hwCategoriesTitle => 'Disease-Category Watch';

  @override
  String get hwCategoriesSubtitle =>
      'Susceptibility across major health categories';

  @override
  String get hwLowRiskCategories => 'Low-Risk Categories';

  @override
  String get hwMentalTitle => 'Mental & Emotional Wellness';

  @override
  String get hwMentalSubtitle => 'Emotional resilience and support needs';

  @override
  String get hwMentalVulnerability => 'Emotional Sensitivity';

  @override
  String get hwEmotionalRegulation => 'Emotional Regulation';

  @override
  String get hwSupportRec => 'Support Recommendation';

  @override
  String get hwTendencies => 'Mental Tendencies';

  @override
  String get hwTimelineTitle => 'Health Timeline';

  @override
  String get hwTimelineSubtitle =>
      'Peak years, caution years & recovery windows';

  @override
  String get hwPeakYears => 'Peak Wellness Years';

  @override
  String get hwCautionYears => 'Caution Years';

  @override
  String get hwRecoveryWindow => 'Recovery Window';

  @override
  String get hwCheckupYears => 'Recommended Check-up Years';

  @override
  String get hwCurrentPhase => 'Current Phase';

  @override
  String get hwLifestyleTitle => 'Your Lifestyle Guide';

  @override
  String get hwLifestyleSubtitle => 'What your chart says about daily habits';

  @override
  String get hwSleepDiscipline => 'Sleep Discipline Impact';

  @override
  String get hwDietDiscipline => 'Diet Discipline Impact';

  @override
  String get hwExerciseNeed => 'Exercise Need';

  @override
  String get hwSunlightNeed => 'Sunlight Need';

  @override
  String get hwStressSusceptibility => 'Stress Susceptibility';

  @override
  String get hwHydrationSensitivity => 'Hydration Sensitivity';

  @override
  String get hwSocialType => 'Social Energy Type';

  @override
  String get hwHealingSpeed => 'Healing Speed';

  @override
  String get hwTreatmentResponse => 'Treatment Response';

  @override
  String get hwAltHealing => 'Alternative Healing Affinity';

  @override
  String get hwSpecialTitle => 'Life-Stage & Special Topics';

  @override
  String get hwSpecialSubtitle =>
      'Fertility, childhood health, habits & burnout';

  @override
  String get hwFertility => 'Fertility Indicator';

  @override
  String get hwHormonalBalance => 'Hormonal Balance';

  @override
  String get hwReproductiveStrength => 'Reproductive System Strength';

  @override
  String get hwChildhoodVuln => 'Childhood Health Vulnerability';

  @override
  String get hwChildhoodStatus => 'Childhood Health';

  @override
  String get hwAddictionVuln => 'Addiction Vulnerability';

  @override
  String get hwAddictionRecovery => 'Recovery Capacity';

  @override
  String get hwBurnoutVuln => 'Burnout Vulnerability';

  @override
  String get hwWorkLifeBalance => 'Work-Life Balance';

  @override
  String get hwStressTriggers => 'Stress Triggers';

  @override
  String get hwProtectiveFactors => 'Protective Factors';

  @override
  String get hwChallengesTitle => 'Challenges to Watch';

  @override
  String get hwChallengesSubtitle => 'Where to focus preventive care';

  @override
  String get hwMitigation => 'How to Manage';

  @override
  String get hwChronicAreas => 'Chronic Vulnerability Areas';

  @override
  String get hwPreventivePriorities => 'Preventive Priorities';

  @override
  String get hwImprovementTitle => 'Your Wellness Plan';

  @override
  String get hwImprovementSubtitle => 'Practical steps + traditional remedies';

  @override
  String get hwReliabilityTitle => 'Reading Reliability';

  @override
  String get hwLayerD1 => 'Birth Chart (D1)';

  @override
  String get hwLayerD6 => 'Health Chart (D6)';

  @override
  String get hwLayerD30 => 'Micro-Health Chart (D30)';

  @override
  String get hwLayerDasha => 'Planetary Timing';

  @override
  String get hwLayerTransit => 'Current Transits';

  @override
  String get hwDisclaimerLabel => 'Medical Disclaimer';

  @override
  String get hwTopicImmunity => 'Boost Immunity';

  @override
  String get hwTopicSleep => 'Sleep & Rest';

  @override
  String get hwTopicStress => 'Manage Stress';

  @override
  String get hwTopicFertility => 'Fertility Timing';

  @override
  String get hwTopicDiet => 'Diet & Nutrition';

  @override
  String get hwTopicTiming => 'Health Timing Windows';

  @override
  String get hwTopicMental => 'Mental Wellbeing';

  @override
  String get hwTopicPrevention => 'Preventive Care Plan';

  @override
  String get lvSubtitle => 'AI-powered Vedic Love Report';

  @override
  String get lvTitle => 'Love & Relationships';

  @override
  String get lvLovePotential => 'Love Potential';

  @override
  String get lvEmotionalAvail => 'Emotionally Open';

  @override
  String get lvAttraction => 'Attraction';

  @override
  String get lvCommitment => 'Commitment';

  @override
  String get lvCommunication => 'Communication';

  @override
  String get lvFidelity => 'Loyalty';

  @override
  String get lvChipLoyal => 'Loyal heart';

  @override
  String get lvChipOpenHeart => 'Open-hearted';

  @override
  String get lvChipCommunicator => 'Great communicator';

  @override
  String get lvChipMature => 'Handles conflict well';

  @override
  String get lvChipEmotionallyWise => 'Emotionally wise';

  @override
  String get lvLoveStyle => 'Your Love Style';

  @override
  String get lvAttractionStyle => 'Attraction style';

  @override
  String get lvLangGiven => 'You Express Love By';

  @override
  String get lvLangReceived => 'You Feel Loved By';

  @override
  String get lvLovePlanets => 'Your Love Planets';

  @override
  String get lvLoveKaraka => 'Love';

  @override
  String get lvEmotionKaraka => 'Emotion';

  @override
  String get lvPassionKaraka => 'Passion';

  @override
  String get lvPathToLove => 'Your Path to Love';

  @override
  String get lvPathSub => 'Love vs arranged';

  @override
  String get lvLoveMarriage => 'Love Marriage';

  @override
  String get lvArrangedMarriage => 'Arranged Marriage';

  @override
  String get lvParentalAccept => 'Parental Acceptance';

  @override
  String get lvInterCaste => 'Inter-caste / Religion';

  @override
  String get lvIdealPartner => 'Your Ideal Partner';

  @override
  String get lvPersonality => 'Personality';

  @override
  String get lvAppearance => 'Appearance';

  @override
  String get lvIdealTraits => 'Ideal Traits';

  @override
  String get lvWhatMatters => 'What Matters Most';

  @override
  String get lvDrawnTo => 'Drawn to';

  @override
  String get lvDealbreakers => 'Dealbreakers';

  @override
  String get lvYourAppeal => 'Your appeal';

  @override
  String get lvLoveStory => 'Your Love Story';

  @override
  String get lvLoveStorySub => 'Relationship patterns';

  @override
  String get lvFirstLove => 'First Love';

  @override
  String get lvRelationCount => 'Significant Bonds';

  @override
  String get lvDuration => 'Typical Duration';

  @override
  String get lvDepth => 'Emotional Depth';

  @override
  String get lvDatingPattern => 'Dating Pattern';

  @override
  String get lvCommitIntimacy => 'Commitment & Intimacy';

  @override
  String get lvCommitReady => 'Commitment Readiness';

  @override
  String get lvIntimacyDrive => 'Intimacy Drive';

  @override
  String get lvSensuality => 'Sensuality';

  @override
  String get lvEmpathy => 'Empathy';

  @override
  String get lvCommitStyle => 'Commitment Style';

  @override
  String get lvChemistry => 'Chemistry Style';

  @override
  String get lvMakesCommit => 'What Makes You Commit';

  @override
  String get lvMakesFlee => 'What Pushes You Away';

  @override
  String get lvEmotional => 'Emotional Intelligence';

  @override
  String get lvEmotionalIQ => 'Emotional IQ';

  @override
  String get lvConflictStyle => 'Conflict Style';

  @override
  String get lvTiming => 'Love Timing';

  @override
  String get lvNewLove12 => 'New love in 12 months';

  @override
  String get lvEnergyNow => 'Energy now';

  @override
  String get lvPhaseNow => 'Phase now';

  @override
  String get lvPeakRomance => 'Peak Romance Years';

  @override
  String get lvNewLoveWindow => 'New Love Window';

  @override
  String get lvChallenges => 'Challenges to Watch';

  @override
  String get lvRiskHeartbreak => 'Heartbreak Vulnerability';

  @override
  String get lvRiskSabotage => 'Self-sabotage';

  @override
  String get lvRiskCommitFear => 'Fear of Commitment';

  @override
  String get lvRiskRepeat => 'Repeat Patterns';

  @override
  String get lvRiskWorkaholic => 'Work Over Love';

  @override
  String get lvRedFlags => 'Red flags to watch';

  @override
  String get lvHealing => 'What to Heal';

  @override
  String get lvFocusArea => 'Focus Area';

  @override
  String get lvHealDir => 'Healing direction';

  @override
  String get lvImprovementPlan => 'Improvement Plan';

  @override
  String get lvReliability => 'Prediction Reliability';

  @override
  String get lvLayerBirth => 'Birth Chart (D1)';

  @override
  String get lvLayerNavamsa => 'Navamsa (D9)';

  @override
  String get lvLayerSaptamsa => 'Saptamsa (D7)';

  @override
  String get lvLayerDasha => 'Dasha Timing';

  @override
  String get lvLayerTransit => 'Current Transits';

  @override
  String get lvTopicWhen => 'When will I find love?';

  @override
  String get lvTopicSoulmate => 'About my soulmate';

  @override
  String get lvTopicCurrent => 'My current relationship';

  @override
  String get lvTopicHeal => 'Healing from the past';

  @override
  String get lvTopicCommit => 'Commitment help';

  @override
  String get lvTopicLoveVsArranged => 'Love vs arranged';

  @override
  String get lvTopicHeartbreak => 'Avoiding heartbreak';

  @override
  String get lvTopicConfidence => 'Confidence in love';

  @override
  String get mrSubtitle => 'AI-powered Vedic Marriage Report';

  @override
  String get mrTitle => 'Marriage & Family';

  @override
  String get mrMarriagePotential => 'Marriage Potential';

  @override
  String get mrHarmony => 'Harmony';

  @override
  String get mrLongevity => 'Longevity';

  @override
  String get mrSatisfaction => 'Satisfaction';

  @override
  String get mrStability => 'Home Stability';

  @override
  String get mrClarity => 'Clarity';

  @override
  String get mrChipHarmony => 'Harmonious bond';

  @override
  String get mrChipNoMangal => 'No Mangal dosh';

  @override
  String get mrChipLongLasting => 'Long-lasting';

  @override
  String get mrChipHome => 'Own home likely';

  @override
  String get mrChipInLaws => 'Good in-laws';

  @override
  String get mrChipChildren => 'Children blessed';

  @override
  String get mrSpouse => 'Your Future Spouse';

  @override
  String get mrSpouseSub => 'What the chart suggests';

  @override
  String get mrSpouseTraits => 'Likely Personality';

  @override
  String get mrSpouseWork => 'Likely Profession';

  @override
  String get mrAgeDiff => 'Age Difference';

  @override
  String get mrCulture => 'Cultural Match';

  @override
  String get mrEducation => 'Education';

  @override
  String get mrFamilyBg => 'Family Background';

  @override
  String get mrSoulPartnership => 'Soul & Partnership';

  @override
  String get mrSelfPlanet => 'You in a Bond';

  @override
  String get mrSpousePlanet => 'Your Spouse Planet';

  @override
  String get mrSoulAlignment => 'Soul Alignment';

  @override
  String get mrAlignStrong =>
      'Your soul and your ideal partner are strongly aligned — a deeply fulfilling bond is well supported.';

  @override
  String get mrAlignModerate =>
      'Your soul and your ideal partner are moderately aligned — a fulfilling bond grows with conscious effort.';

  @override
  String get mrAlignLow =>
      'Your soul and partnership need conscious integration — choose a partner who truly matches your inner values.';

  @override
  String get mrTechDarakaraka => 'Spouse planet (Darakaraka)';

  @override
  String get mrUpapada => 'Marriage point (Upapada)';

  @override
  String get mrUpapadaLord => 'Upapada ruler';

  @override
  String get mrFoundation => 'Marriage Foundation';

  @override
  String get mrMarriageSign => 'Marriage Sign';

  @override
  String get mrMarriageLord => 'Marriage Ruler';

  @override
  String get mrHouseStrength => 'House Strength';

  @override
  String get mrPartnerHint => 'Partner hint from your chart';

  @override
  String get mrHarmonyHdr => 'Compatibility Harmony';

  @override
  String get mrHarmonySub => 'How you\'ll connect';

  @override
  String get mrEmotional => 'Emotional';

  @override
  String get mrIntellectual => 'Intellectual';

  @override
  String get mrPhysical => 'Physical Intimacy';

  @override
  String get mrFinancial => 'Financial';

  @override
  String get mrCommunication => 'Communication';

  @override
  String get mrSharedValues => 'Shared Values';

  @override
  String get mrSpiritual => 'Spiritual';

  @override
  String get mrConflictRes => 'Conflict Resolution';

  @override
  String get mrTiming => 'Marriage Timing';

  @override
  String get mrFirstMarriageAge => 'Likely Marriage Age';

  @override
  String get mrDelayChance => 'Delay chance';

  @override
  String get mrMarriageWindow => 'Marriage Window';

  @override
  String get mrSecondaryWindow => 'Alternate Window';

  @override
  String get mrCurrentReadiness => 'Right Now';

  @override
  String get mrJourney => 'Marriage Journey';

  @override
  String get mrJourneySub => 'How the bond evolves';

  @override
  String get mrPhaseEarly => 'Early Years';

  @override
  String get mrPhaseMid => 'Middle Years';

  @override
  String get mrPhaseMature => 'Mature Years';

  @override
  String get mrPhaseLate => 'Later Years';

  @override
  String get mrTip => 'Tip';

  @override
  String get mrFamilyHome => 'Family & Home';

  @override
  String get mrInLaws => 'In-law Relations';

  @override
  String get mrFamilyHarmony => 'Family Harmony';

  @override
  String get mrHomeOwnership => 'Home Ownership';

  @override
  String get mrDomesticPeace => 'Domestic Peace';

  @override
  String get mrFertility => 'Fertility';

  @override
  String get mrParenting => 'Parenting Harmony';

  @override
  String get mrChildren => 'Children';

  @override
  String get mrLikelyCount => 'Likely count';

  @override
  String get mrVerification => 'Cross-Chart Verification';

  @override
  String get mrD9 => 'Marriage Chart (D9)';

  @override
  String get mrD10 => 'Career-Spouse Chart (D10)';

  @override
  String get mrD60 => 'Karma Chart (D60)';

  @override
  String get mrChallenges => 'Challenges to Watch';

  @override
  String get mrMangalPresent =>
      'Mangal Dosh is present in the chart — review remedies and matching carefully.';

  @override
  String get mrMangalAbsent =>
      'No Mangal Dosh detected — a supportive marriage indicator.';

  @override
  String get mrRiskConflict => 'Conflict';

  @override
  String get mrRiskSeparation => 'Separation';

  @override
  String get mrRiskDistance => 'Emotional Distance';

  @override
  String get mrRiskInfidelity => 'Infidelity';

  @override
  String get mrRiskFinance => 'Money Disagreements';

  @override
  String get mrPartnerGuide => 'Partner Guide';

  @override
  String get mrPartnerGuideSub => 'What to look for';

  @override
  String get mrSeek => 'Look for';

  @override
  String get mrMatchingPriorities => 'Matching Priorities';

  @override
  String get mrImprovementPlan => 'Improvement Plan';

  @override
  String get mrReliability => 'Prediction Reliability';

  @override
  String get mrLayerBirth => 'Birth Chart (D1)';

  @override
  String get mrLayerNavamsa => 'Navamsa (D9)';

  @override
  String get mrLayerDashamsa => 'Dashamsa (D10)';

  @override
  String get mrLayerShashtiamsa => 'Karma (D60)';

  @override
  String get mrLayerDarakaraka => 'Spouse Planet';

  @override
  String get mrTopicWhen => 'When will I marry?';

  @override
  String get mrTopicSpouse => 'About my spouse';

  @override
  String get mrTopicCompat => 'Compatibility tips';

  @override
  String get mrTopicDelay => 'Marriage delay';

  @override
  String get mrTopicMangal => 'Mangal dosh';

  @override
  String get mrTopicChildren => 'Children timing';

  @override
  String get mrTopicInLaws => 'In-law relations';

  @override
  String get mrTopicHarmony => 'Building harmony';

  @override
  String get wlSubtitle => 'AI-powered Vedic Wealth Report';

  @override
  String get wlTitle => 'Wealth & Finance';

  @override
  String get wlWealthPotential => 'Wealth Potential';

  @override
  String get wlAccumulation => 'Accumulation';

  @override
  String get wlIncomeFlow => 'Income Flow';

  @override
  String get wlRetention => 'Retention';

  @override
  String get wlSustainability => 'Sustainability';

  @override
  String get wlSavings => 'Savings Discipline';

  @override
  String get wlChipSaver => 'Natural saver';

  @override
  String get wlChipMultiIncome => 'Multiple incomes';

  @override
  String get wlChipStrongYogas => 'Wealth yogas';

  @override
  String get wlChipLowDebt => 'Low debt';

  @override
  String get wlChipInheritance => 'Inheritance likely';

  @override
  String get wlChipInvestor => 'Smart investor';

  @override
  String get wlWealthClass => 'Wealth Class';

  @override
  String get wlWealthType => 'Main Wealth Type';

  @override
  String get wlPrimarySource => 'Primary Income';

  @override
  String get wlPeakAge => 'Peak Wealth Age';

  @override
  String get wlBoosters => 'What\'s Boosting Your Wealth';

  @override
  String get wlBoostersSub => 'Powerful money combinations';

  @override
  String get wlWealthImpact => 'boost';

  @override
  String get wlDrains => 'Wealth Drains';

  @override
  String get wlIncomeSources => 'Income Sources';

  @override
  String get wlIncomeSourcesSub => 'Where your money comes from';

  @override
  String get wlPrimary => 'Primary';

  @override
  String get wlInvestment => 'Investment Plan';

  @override
  String get wlInvestmentSub => 'Ideal asset mix';

  @override
  String get wlRiskAppetite => 'Risk Appetite';

  @override
  String get wlInvestStyle => 'Investing Style';

  @override
  String get wlDrivenBy => 'Driven by';

  @override
  String get wlMoneyPersonality => 'Money Personality';

  @override
  String get wlMoneyType => 'Money Type';

  @override
  String get wlSpending => 'Spending';

  @override
  String get wlSavingsDiscipline => 'Savings Discipline';

  @override
  String get wlCharity => 'Charity Inclination';

  @override
  String get wlLuxury => 'Luxury Spending';

  @override
  String get wlWindfalls => 'Windfalls & Chances';

  @override
  String get wlWindfallsSub => 'Luck-based money';

  @override
  String get wlInheritanceChance => 'Inheritance';

  @override
  String get wlSuddenGains => 'Sudden Gains';

  @override
  String get wlLottery => 'Lottery / Speculation';

  @override
  String get wlInsurance => 'Insurance Claims';

  @override
  String get wlWindfallSource => 'Likely windfall source';

  @override
  String get wlMoneyPlanets => 'Your Money Planets';

  @override
  String get wlPrimaryKaraka => 'Primary Money Planet';

  @override
  String get wlSecondaryKaraka => 'Secondary Money Planet';

  @override
  String get wlTimeline => 'Wealth Timeline';

  @override
  String get wlPeakYears => 'Peak Years';

  @override
  String get wlGoodPeriod => 'Prosperous Period';

  @override
  String get wlSuddenGainWindow => 'Sudden Gain Window';

  @override
  String get wlToughPeriod => 'Cautious Period';

  @override
  String get wlDebtRisks => 'Debt & Money Risks';

  @override
  String get wlDebtChance => 'Debt Likelihood';

  @override
  String get wlLoanBurden => 'Loan Burden';

  @override
  String get wlDrainSources => 'Watch out for';

  @override
  String get wlStrengthen => 'What to Strengthen';

  @override
  String get wlWeakestDriver => 'Weakest Money Driver';

  @override
  String get wlHowToFix => 'How to strengthen';

  @override
  String get wlImprovementPlan => 'Improvement Plan';

  @override
  String get wlReliability => 'Prediction Reliability';

  @override
  String get wlLayerBirth => 'Wealth Houses (D1)';

  @override
  String get wlLayerHora => 'Hora Chart (D2)';

  @override
  String get wlLayerNavamsa => 'Navamsa (D9)';

  @override
  String get wlLayerDasha => 'Dasha Timing';

  @override
  String get wlLayerTransit => 'Current Transits';

  @override
  String get wlTopicGrow => 'How to grow wealth';

  @override
  String get wlTopicInvest => 'Where to invest';

  @override
  String get wlTopicDebt => 'Managing debt';

  @override
  String get wlTopicProperty => 'Buying property';

  @override
  String get wlTopicRetire => 'Retirement planning';

  @override
  String get wlTopicPassive => 'Passive income';

  @override
  String get wlTopicWindfall => 'Sudden gains';

  @override
  String get wlTopicTiming => 'Best money timing';

  @override
  String get bzSubtitle => 'AI-powered Vedic Business Report';

  @override
  String get bzTitle => 'Business & Startup';

  @override
  String get bzBusinessPotential => 'Business Potential';

  @override
  String get bzEntrepreneurship => 'Entrepreneur';

  @override
  String get bzVenture => 'Venture Success';

  @override
  String get bzWealth => 'Wealth via Business';

  @override
  String get bzRiskAppetite => 'Risk Appetite';

  @override
  String get bzLongevity => 'Longevity';

  @override
  String get bzChipWealthMagnet => 'Wealth magnet';

  @override
  String get bzChipMoneyYoga => 'Money yoga';

  @override
  String get bzChipLeadership => 'Leadership';

  @override
  String get bzChipPartnerFit => 'Great partner fit';

  @override
  String get bzChipGains => 'Strong gains';

  @override
  String get bzChipInvestor => 'Investor appeal';

  @override
  String get bzChipFounder => 'Founder mindset';

  @override
  String get bzWhatsWorking => 'What\'s Working For You';

  @override
  String get bzWhatsWorkingSub => 'Your business gifts';

  @override
  String get bzClassicYogas => 'Classic wealth combinations';

  @override
  String get bzFounderType => 'Your Founder Type';

  @override
  String get bzSoulBusiness => 'Soul & Business Purpose';

  @override
  String get bzSoulPlanet => 'Your Soul Driver';

  @override
  String get bzBusinessPlanet => 'Your Business Mind';

  @override
  String get bzDirectionStrength => 'Direction Clarity';

  @override
  String get bzAlignStrong =>
      'Your soul purpose and business direction are strongly aligned — building a venture feels natural and fulfilling.';

  @override
  String get bzAlignModerate =>
      'Your soul purpose and business direction are moderately aligned — a venture works best when it reflects your deeper values.';

  @override
  String get bzAlignLow =>
      'Your soul purpose and business direction need conscious alignment — choose a venture that genuinely matches who you are.';

  @override
  String get bzTechAtmakaraka => 'Soul planet (Atmakaraka)';

  @override
  String get bzTechAmatyakaraka => 'Business planet (Amatyakaraka)';

  @override
  String get bzTechDarakaraka => 'Partner planet (Darakaraka)';

  @override
  String get bzFoundation => 'Business Foundation';

  @override
  String get bzCareerHouse => 'Career House';

  @override
  String get bzGainsHouse => 'Gains House';

  @override
  String get bzLord => 'Ruler';

  @override
  String get bzGainsPotential => 'Gains Potential';

  @override
  String get bzNetwork => 'Network Power';

  @override
  String get bzRecovery => 'Recovery Strength';

  @override
  String get bzVerification => 'Cross-Chart Verification';

  @override
  String get bzD10 => 'Career Chart (D10)';

  @override
  String get bzD11 => 'Gains Chart (D11)';

  @override
  String get bzD9 => 'Purpose Chart (D9)';

  @override
  String get bzD60 => 'Karma Chart (D60)';

  @override
  String get bzFounderSkills => 'Founder Skills';

  @override
  String get bzSkillStrategy => 'Strategic Thinking';

  @override
  String get bzSkillExecution => 'Execution';

  @override
  String get bzSkillPeople => 'People Management';

  @override
  String get bzSkillSales => 'Sales & Persuasion';

  @override
  String get bzSkillFinance => 'Financial Acumen';

  @override
  String get bzSkillOps => 'Operational Discipline';

  @override
  String get bzTopSkill => 'Top Skill';

  @override
  String get bzDomains => 'Best Business Fields';

  @override
  String get bzDomainsSub => 'Ranked by natural fit';

  @override
  String get bzFit => 'FIT';

  @override
  String get bzBusinessStyleHdr => 'Business Style';

  @override
  String get bzStyleService => 'Product vs Service';

  @override
  String get bzStyleMarket => 'Market Focus';

  @override
  String get bzStyleTech => 'Tech Approach';

  @override
  String get bzStyleLeadership => 'Leadership Style';

  @override
  String get bzStylePartnership => 'Solo or Partnership';

  @override
  String get bzWhereBuild => 'Reach';

  @override
  String get bzExpansion => 'Expansion';

  @override
  String get bzSetup => 'Setup';

  @override
  String get bzPartnership => 'Partnership & Team';

  @override
  String get bzIdealCofounder => 'Ideal Co-founder';

  @override
  String get bzPartnerViability => 'Partnership Fit';

  @override
  String get bzTeamBuilding => 'Team Building';

  @override
  String get bzCofounderFit => 'Co-founder Fit';

  @override
  String get bzAdvisorNetwork => 'Advisor Network';

  @override
  String get bzFunding => 'Funding & Money';

  @override
  String get bzRecommendedPath => 'Recommended Funding Path';

  @override
  String get bzInvestorAttract => 'Investor Appeal';

  @override
  String get bzFamilyBacking => 'Family Support';

  @override
  String get bzHybridViability => 'Job + Business Mix';

  @override
  String get bzFallback => 'Job as Backup';

  @override
  String get bzDebtStyle => 'Debt Style';

  @override
  String get bzTimeline => 'Business Timeline';

  @override
  String get bzCurrentPhase => 'Right Now';

  @override
  String get bzLaunchWindow => 'Launch Window';

  @override
  String get bzScaleWindow => 'Growth Window';

  @override
  String get bzPeakAge => 'Peak Years';

  @override
  String get bzChallenges => 'Challenges to Watch';

  @override
  String get bzRiskFinancial => 'Financial Loss';

  @override
  String get bzRiskBurnout => 'Burnout';

  @override
  String get bzRiskTeam => 'Team Conflict';

  @override
  String get bzRiskLegal => 'Legal / Regulatory';

  @override
  String get bzFinancialExp =>
      'Risk of money loss from over-investment or poor cash-flow timing during a venture.';

  @override
  String get bzFinancialFix =>
      'Keep a cash reserve, start lean, and validate demand before scaling spend.';

  @override
  String get bzBurnoutExp =>
      'Pushing too hard for too long can drain your energy and focus.';

  @override
  String get bzBurnoutFix =>
      'Protect rest, delegate early, and pace big pushes around supportive periods.';

  @override
  String get bzTeamExp =>
      'Friction with co-founders or staff can slow the business down.';

  @override
  String get bzTeamFix =>
      'Set clear roles and expectations in writing, and communicate often.';

  @override
  String get bzLegalExp =>
      'Compliance, contracts or regulatory issues could create obstacles.';

  @override
  String get bzLegalFix =>
      'Get contracts reviewed, keep paperwork clean, and consult professionals early.';

  @override
  String get bzImprovementPlan => 'Improvement Plan';

  @override
  String get bzBestDirection => 'Best Direction';

  @override
  String get bzStrategy => 'Build Strategy';

  @override
  String get bzTopFields => 'Top Fields';

  @override
  String get bzEmploymentPath => 'Job vs Business';

  @override
  String get bzRoadmap => 'Growth Roadmap';

  @override
  String get bzRoadmapSub => 'Your venture plan';

  @override
  String get bzReliability => 'Prediction Reliability';

  @override
  String get bzLayerBirth => 'Birth Chart (D1)';

  @override
  String get bzLayerNavamsa => 'Navamsa (D9)';

  @override
  String get bzLayerDashamsa => 'Career (D10)';

  @override
  String get bzLayerLabhamsa => 'Gains (D11)';

  @override
  String get bzLayerShashtiamsa => 'Karma (D60)';

  @override
  String get bzTopicStart => 'Should I start now?';

  @override
  String get bzTopicIdea => 'Best business idea';

  @override
  String get bzTopicPartner => 'Finding a co-founder';

  @override
  String get bzTopicFunding => 'How to fund it';

  @override
  String get bzTopicScale => 'When to scale';

  @override
  String get bzTopicRisk => 'Managing risks';

  @override
  String get bzTopicJob => 'Job vs business';

  @override
  String get bzTopicTiming => 'Best timing';

  @override
  String get crTitle => 'Career & Job Analysis';

  @override
  String get crSubtitle => 'AI-powered Vedic Career Report';

  @override
  String get crCrumbHome => 'Home';

  @override
  String get crCrumbReports => 'Reports';

  @override
  String get crCareerPotential => 'Career Potential';

  @override
  String get crStatusStrong => 'Strong Potential';

  @override
  String get crStatusGood => 'Good Potential';

  @override
  String get crStatusModerate => 'Moderate Potential';

  @override
  String get crStatusDeveloping => 'Developing Potential';

  @override
  String get crStatusChallenging => 'Challenging Phase';

  @override
  String get crOverallCareer => 'Overall Career';

  @override
  String get crStability => 'Career Stability';

  @override
  String get crGrowth => 'Growth Potential';

  @override
  String get crRecognition => 'Recognition';

  @override
  String get crSatisfaction => 'Satisfaction';

  @override
  String get crChipLeadership => 'Leadership';

  @override
  String get crChipCreativity => 'Creativity';

  @override
  String get crChipBusiness => 'Business';

  @override
  String get crChipStableIncome => 'Stable Income';

  @override
  String get crChipLearning => 'Learning';

  @override
  String get crChipGrowth => 'Long-Term Growth';

  @override
  String get crChipTechnical => 'Technical Skill';

  @override
  String get crChipRecognition => 'Recognition';

  @override
  String get crTopInsights => 'Top Insights';

  @override
  String get crWhatDefines => 'What defines your career?';

  @override
  String get crSoulCareer => 'Soul & Career Purpose';

  @override
  String get crSoulPlanet => 'Soul Purpose Planet';

  @override
  String get crCareerPlanet => 'Career Planet';

  @override
  String get crMeaning => 'Meaning';

  @override
  String get crAlignment => 'Soul ↔ Career Alignment';

  @override
  String get crAlignStrong =>
      'Your natural interests and career path are strongly aligned.';

  @override
  String get crAlignModerate =>
      'Your natural interests and career path are moderately aligned.';

  @override
  String get crAlignLow =>
      'Your natural interests and career path need conscious alignment.';

  @override
  String get crTechAtmakaraka => 'Atmakaraka (Soul indicator)';

  @override
  String get crTechAmatyakaraka => 'Amatyakaraka (Career indicator)';

  @override
  String get crDegrees => 'Degrees';

  @override
  String get crDignity => 'Dignity';

  @override
  String get crFoundation => 'Career Foundation';

  @override
  String get crCareerSign => 'Career Sign';

  @override
  String get crCareerLord => 'Career Lord';

  @override
  String get crLordPosition => 'Lord Position';

  @override
  String get crCareerStrength => 'Career Strength';

  @override
  String get crProfStyle => 'Professional Style';

  @override
  String get crBestFields => 'Best Fields';

  @override
  String get crTechnicalDetails => 'Technical Details';

  @override
  String get crHouseLabel => 'House';

  @override
  String get crVerification => 'Career Verification Across Charts';

  @override
  String get crD10Career => 'D10 · Career';

  @override
  String get crD9Purpose => 'D9 · Purpose';

  @override
  String get crD60Karma => 'D60 · Karma';

  @override
  String get crStatusNeedsImprovement => 'Needs Improvement';

  @override
  String get crStatusWellAligned => 'Well Aligned';

  @override
  String get crStatusStrongSupport => 'Strong Support';

  @override
  String get crStatusModerateSupport => 'Moderate Support';

  @override
  String get crChartDetails => 'Technical chart details';

  @override
  String get crPersonality => 'Your Career Personality';

  @override
  String get crGrowthAreas => 'Growth Areas';

  @override
  String get crBestRoles => 'Best Roles';

  @override
  String get crBestIndustries => 'Best Industries';

  @override
  String get crEnvironment => 'Career Environment';

  @override
  String get crWorkStyle => 'Best Work Style';

  @override
  String get crEmployment => 'Employment';

  @override
  String get crBusiness => 'Business';

  @override
  String get crFreelance => 'Freelance / Consulting';

  @override
  String get crPortfolio => 'Mixed Portfolio';

  @override
  String get crLeadership => 'Leadership';

  @override
  String get crFit => 'Fit';

  @override
  String get crBestFit => 'Best Fit';

  @override
  String get crTimeline => 'Career Timeline';

  @override
  String get crPastPeak => 'Past Peak';

  @override
  String get crPresentPhase => 'Present Phase';

  @override
  String get crUpcoming => 'Upcoming Opportunity';

  @override
  String get crFutureExpansion => 'Future Expansion';

  @override
  String get crRiskPeriod => 'Risk Period';

  @override
  String get crViewDasha => 'Planetary period (technical)';

  @override
  String get crChallenges => 'Challenges to Watch';

  @override
  String get crRiskBurnout => 'Burnout';

  @override
  String get crRiskRecognition => 'Recognition Delay';

  @override
  String get crRiskConflict => 'Workplace Conflict';

  @override
  String get crRiskFinancial => 'Financial Instability';

  @override
  String get crRiskOverqual => 'Under-utilization';

  @override
  String get crPrevention => 'Prevention';

  @override
  String get crBurnoutExp =>
      'Long, demanding phases can drain your energy over time.';

  @override
  String get crBurnoutFix =>
      'Protect rest, set boundaries, and pace big pushes.';

  @override
  String get crRecognitionExp =>
      'Rewards and recognition may arrive slower than your effort.';

  @override
  String get crRecognitionFix =>
      'Document wins and make your contributions visible to seniors.';

  @override
  String get crConflictExp =>
      'Friction with colleagues or authority can surface at times.';

  @override
  String get crConflictFix =>
      'Communicate calmly and pick your battles wisely.';

  @override
  String get crFinancialExp => 'Income may feel uneven during certain phases.';

  @override
  String get crFinancialFix =>
      'Keep a buffer and avoid over-committing financially.';

  @override
  String get crOverqualExp =>
      'You may sometimes feel under-used or under-challenged.';

  @override
  String get crOverqualFix =>
      'Seek stretch roles and keep learning to stay engaged.';

  @override
  String get crImprovementPlan => 'Career Improvement Plan';

  @override
  String get crCatPlanetary => 'Planetary & Spiritual';

  @override
  String get crCatPractical => 'Practical Steps';

  @override
  String get crTraditionalExplain => 'Traditional astrology explanation';

  @override
  String get crActionPlan => '30-Day Career Action Plan';

  @override
  String get crWeek1 => 'Week 1 · Profile Optimization';

  @override
  String get crWeek2 => 'Week 2 · Skill Building';

  @override
  String get crWeek3 => 'Week 3 · Networking';

  @override
  String get crWeek4 => 'Week 4 · Career Visibility';

  @override
  String get crWeek1Tip =>
      'Refresh your resume and LinkedIn around your strongest career theme.';

  @override
  String get crWeek2Tip =>
      'Pick one high-value skill in your best field and practise it daily.';

  @override
  String get crWeek3Tip =>
      'Reconnect with mentors and reach out to two new industry contacts.';

  @override
  String get crWeek4Tip =>
      'Share your work publicly and volunteer for a visible project.';

  @override
  String get crPriority => 'Priority';

  @override
  String get crTimeRequired => 'Time';

  @override
  String get crExpectedBenefit => 'Benefit';

  @override
  String get crPriorityHigh => 'High';

  @override
  String get crPriorityMedium => 'Medium';

  @override
  String get crRoadmap => 'AI Career Roadmap';

  @override
  String get crNext12 => 'Next 12 Months';

  @override
  String get crBestFocus => 'Best Focus';

  @override
  String get crSkillsLearn => 'Skills to Learn';

  @override
  String get crIndustriesTarget => 'Industries to Target';

  @override
  String get crExpectedOutcome => 'Expected Outcome';

  @override
  String get crReliability => 'Prediction Reliability';

  @override
  String get crReliabilityHigh => 'High Reliability';

  @override
  String get crReliabilityGood => 'Good Reliability';

  @override
  String get crReliabilityModerate => 'Moderate Reliability';

  @override
  String get crReliabilityExplain =>
      'This report combines your birth chart, divisional charts and Jaimini indicators. The score reflects how strongly these chart layers agree.';

  @override
  String get crChartLayers => 'Chart layers & weights';

  @override
  String get crBirthChart => 'Birth Chart (D1)';

  @override
  String get crNavamsa => 'Navamsa (D9)';

  @override
  String get crDashamsa => 'Dashamsa (D10)';

  @override
  String get crShashtiamsa => 'Shashtiamsa (D60)';

  @override
  String get crDiscussAi => 'Discuss with AI';

  @override
  String get crAskAbout => 'Ask About';

  @override
  String get crTopicChange => 'Career Change';

  @override
  String get crTopicGovt => 'Government Job';

  @override
  String get crTopicBusiness => 'Business';

  @override
  String get crTopicPromotion => 'Promotion';

  @override
  String get crTopicMarriage => 'Marriage vs Career';

  @override
  String get crTopicAbroad => 'Abroad';

  @override
  String get crTopicIncome => 'Income';

  @override
  String get crTopicPurpose => 'Purpose';

  @override
  String get crTopicResume => 'Resume';

  @override
  String get crTopicCopied => 'Question copied — paste it into your AI chat.';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return '$soul guides your inner calling, while $career shapes your outer profession.';
  }

  @override
  String get rzTodayOutlook => 'Today\'s Zodiac Outlook';

  @override
  String get rzPlanetaryEnergy => 'Today\'s Planetary Energy';

  @override
  String get rzBestSign => 'Best Sign';

  @override
  String get rzChallengingSign => 'Most Challenging';

  @override
  String get rzDominantPlanet => 'Dominant Planet';

  @override
  String get rzOverallMood => 'Overall Mood';

  @override
  String get rzMoodBright => 'Bright & Active';

  @override
  String get rzMoodCalm => 'Calm & Steady';

  @override
  String get rzMoodMixed => 'Mixed Energy';

  @override
  String get rzMoodTense => 'Tense & Careful';

  @override
  String get rzTodayEnergy => 'Today\'s Energy';

  @override
  String get rzCaution => 'Caution';

  @override
  String get rzWeak => 'Weak';

  @override
  String get rzAllSigns => 'All Zodiac Signs';

  @override
  String get rzAiSummary => 'AI Summary';

  @override
  String get rzPlanetaryInfluence => 'Today\'s Planetary Influence';

  @override
  String get rzStrongInfluences => 'Strong Influences';

  @override
  String get rzShowTechnical => 'Show technical details';

  @override
  String get rzOpportunities => 'Today\'s Opportunities';

  @override
  String get rzAvoidTitle => 'Things To Avoid Today';

  @override
  String get rzTechnicalReason => 'Technical reason';

  @override
  String get rzAvoidDecisions => 'Rushing important decisions';

  @override
  String get rzAvoidArguments => 'Heated arguments';

  @override
  String get rzAvoidInvestments => 'Large investments';

  @override
  String get rzAvoidOverthink => 'Overthinking small issues';

  @override
  String get rzAvoidOverspend => 'Unnecessary spending';

  @override
  String get rzAvoidStress => 'Stress and overworking';

  @override
  String get rzPlanetaryChart => 'Today\'s Planetary Chart';

  @override
  String get rzWhatChartMeans => 'What this chart means';

  @override
  String get rzChartExplain =>
      'This diamond shows where each planet is sitting in the sky today, mapped to your sign. Planets in supportive houses lift the day; those in tough houses ask for care.';

  @override
  String get rzDoNetworking => 'Networking & connecting';

  @override
  String get rzDoLearning => 'Learning something new';

  @override
  String get rzDoMeditation => 'Meditation & calm';

  @override
  String get rzDoFamily => 'Family time';

  @override
  String get rzDoCreative => 'Creative work';

  @override
  String get rzDoRest => 'Rest & self-care';

  @override
  String get rzAiRecommendations => 'Today\'s AI Recommendations';

  @override
  String get rzTechnical => 'Technical Astrology';

  @override
  String get rzTransitScore => 'Transit Score';

  @override
  String get rzVedha => 'Vedha (Obstructions)';

  @override
  String get rzGocharDetails => 'Gochar Details';

  @override
  String get rzAdvancedOnly => 'For advanced users';

  @override
  String get rzTomorrow => 'Tomorrow Preview';

  @override
  String get rzTomorrowEnergy => 'Tomorrow\'s Energy';

  @override
  String get rzImproving => 'Improving';

  @override
  String get rzWeaker => 'Slightly Weaker';

  @override
  String get rzSteady => 'Steady';

  @override
  String get rzTomorrowUpLine =>
      'Energy is expected to rise tomorrow — plan ahead for important tasks.';

  @override
  String get rzTomorrowDownLine =>
      'Energy may dip a little tomorrow — keep the day light and steady.';

  @override
  String get rzTomorrowFlatLine =>
      'Energy stays steady tomorrow — a calm, balanced day ahead.';

  @override
  String get rzWeeklyTrend => 'Weekly Trend';

  @override
  String get rzMonthlyTrend => 'Monthly Trend';

  @override
  String get rzBestDayWeek => 'Best Day';

  @override
  String get rzHardestDay => 'Toughest Day';

  @override
  String get rzLuckyToday => 'Lucky Today';

  @override
  String get rzKarakaSun => 'confidence & vitality';

  @override
  String get rzKarakaMoon => 'emotions & peace of mind';

  @override
  String get rzKarakaMars => 'energy & drive';

  @override
  String get rzKarakaMercury => 'communication & learning';

  @override
  String get rzKarakaJupiter => 'wisdom & growth';

  @override
  String get rzKarakaVenus => 'relationships & comfort';

  @override
  String get rzKarakaSaturn => 'discipline & patience';

  @override
  String get rzKarakaRahu => 'ambition & change';

  @override
  String get rzKarakaKetu => 'spirituality & letting go';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '$dom sets the tone of the day, while $chal asks for patience and care.';
  }

  @override
  String rzInsightGood(Object karaka) {
    return 'Good day for $karaka.';
  }

  @override
  String rzInsightHard(Object karaka) {
    return 'Take it slow with $karaka today.';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return '$karaka is well supported today.';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return '$karaka may face delays today.';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return 'Today supports $strong, while $weak needs patience and care.';
  }

  @override
  String get fdEnergyScore => 'Today\'s Energy Score';

  @override
  String get fdStatusAverage => 'Average';

  @override
  String get fdStatusMixed => 'Mixed';

  @override
  String get fdStatusChallenging => 'Challenging';

  @override
  String get fdTheme => 'Today\'s Theme';

  @override
  String get fdExplainToday => 'Explain Today';

  @override
  String get fdTodaysFocus => 'Today\'s Focus';

  @override
  String get fdTopRecommendation => 'Top Recommendation';

  @override
  String get fdTopCaution => 'Top Caution';

  @override
  String get fdReadingTime => 'Reading time';

  @override
  String get fdSeconds30 => '30 sec';

  @override
  String get fdCareer => 'Career';

  @override
  String get fdMoney => 'Money';

  @override
  String get fdLove => 'Love';

  @override
  String get fdHealth => 'Health';

  @override
  String get fdTravel => 'Travel';

  @override
  String get fdFamily => 'Family';

  @override
  String get fdBestToDo => 'Best Things To Do Today';

  @override
  String get fdAvoidToday => 'Avoid Today';

  @override
  String get fdConfidenceLabel => 'Confidence';

  @override
  String get fdBestTime => 'Best Time';

  @override
  String get fdRecommended => 'Recommended';

  @override
  String get fdReason => 'Reason';

  @override
  String get fdRisk => 'Risk';

  @override
  String get fdRecommendation => 'Recommendation';

  @override
  String get fdNoActions =>
      'Nothing major to push today — keep a steady, calm routine.';

  @override
  String get fdNoCautions =>
      'No major cautions today — proceed with normal awareness.';

  @override
  String get fdHighlights => 'Today\'s Highlights';

  @override
  String get fdProbVeryHigh => 'Very High';

  @override
  String get fdProbHigh => 'High';

  @override
  String get fdProbElevated => 'Elevated';

  @override
  String get fdProbCaution => 'Caution';

  @override
  String get fdWhatToDo => 'What to do';

  @override
  String get fdLifeAreas => 'Life Areas';

  @override
  String get fdTapDetails => 'Tap for details';

  @override
  String get fdArea1 => 'Self & Health';

  @override
  String get fdArea2 => 'Wealth & Family';

  @override
  String get fdArea3 => 'Communication';

  @override
  String get fdArea4 => 'Home & Comfort';

  @override
  String get fdArea5 => 'Creativity & Romance';

  @override
  String get fdArea6 => 'Work & Duties';

  @override
  String get fdArea7 => 'Relationships';

  @override
  String get fdArea8 => 'Change & Depth';

  @override
  String get fdArea9 => 'Luck & Travel';

  @override
  String get fdArea10 => 'Career & Status';

  @override
  String get fdArea11 => 'Gains & Network';

  @override
  String get fdArea12 => 'Rest & Spirituality';

  @override
  String get fdTodaysMeaning => 'Today\'s Meaning';

  @override
  String get fdGoodFor => 'Good For';

  @override
  String get fdAvoid => 'Avoid';

  @override
  String get fdPlanetSupport => 'Planet Support';

  @override
  String get fdWhyPrediction => 'Why this prediction?';

  @override
  String get fdAdvancedDetails => 'Advanced Details';

  @override
  String get fdAiRecommendation => 'AI Recommendation';

  @override
  String get fdOverallStatus => 'Overall Status';

  @override
  String get fdNoPlanetTransit =>
      'No major planet is transiting this area today.';

  @override
  String get fdFinancialOutlook => 'Financial Outlook';

  @override
  String get fdIncomeProbability => 'Income Probability';

  @override
  String get fdExpenseProbability => 'Expense Probability';

  @override
  String get fdNetBalance => 'Net Financial Balance';

  @override
  String get fdAvoidSpending => 'Avoid Spending';

  @override
  String get fdRelationshipOutlook => 'Relationship Outlook';

  @override
  String get fdOverallScore => 'Overall Score';

  @override
  String get fdPartner => 'Partner';

  @override
  String get fdRomance => 'Romance';

  @override
  String get fdWorkplace => 'Workplace';

  @override
  String get fdPublicImage => 'Public Image';

  @override
  String get fdBestActivity => 'Best Activity';

  @override
  String get fdWeakArea => 'Weak Area';

  @override
  String get fdBiggestOpportunity => 'Biggest Opportunity';

  @override
  String get fdBiggestRisk => 'Biggest Risk';

  @override
  String get fdProbability => 'Probability';

  @override
  String get fdProtection => 'Protection Advice';

  @override
  String get fdDescription => 'Description';

  @override
  String get fdBestTimeToday => 'Best Time Today';

  @override
  String get fdAvoidDuring => 'Avoid During';

  @override
  String get fdPredictionConfidence => 'Prediction Confidence';

  @override
  String get fdConfBasis => 'Today\'s prediction combines';

  @override
  String get fdConfNatal => 'Birth Chart';

  @override
  String get fdConfTransit => 'Current Transit';

  @override
  String get fdConfDasha => 'Planetary Periods';

  @override
  String get fdConfStrength => 'Planet Strength';

  @override
  String get fdConfHouse => 'House Activation';

  @override
  String get fdAskAi => 'Ask AI';

  @override
  String get fdAskAiSub => 'Tap a question to get today\'s answer';

  @override
  String get fdQ1 => 'Why is career slow today?';

  @override
  String get fdQ2 => 'What is the best time today?';

  @override
  String get fdQ3 => 'Is today good for money matters?';

  @override
  String get fdQ4 => 'Is today good for travel?';

  @override
  String get fdQ5 => 'What should I avoid today?';

  @override
  String get fdMoreSuggestions => 'More Suggestions';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return 'Today is best suited for $top. $weak may feel slow, so avoid major decisions there. Financially the day looks $fin.';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return 'Your energy today gathers around $top — lean into it and go gently elsewhere.';
  }

  @override
  String get gochToday => 'Today';

  @override
  String get gochOverallScore => 'Overall Transit Score';

  @override
  String get gochNeutral => 'Neutral';

  @override
  String get gochChallenging => 'Challenging';

  @override
  String get gochTopPositive => 'Top Positive';

  @override
  String get gochTopChallenges => 'Top Challenges';

  @override
  String get gochFilterAll => 'All';

  @override
  String get gochFavorability => 'Favorability';

  @override
  String get gochAlerts => 'Transit Alerts';

  @override
  String get gochAlertCritical => 'Critical';

  @override
  String get gochAlertWarning => 'Caution';

  @override
  String get gochAlertOpportunity => 'Opportunity';

  @override
  String get gochAiFocus => 'AI Focus Today';

  @override
  String get gochLifeScores => 'Life Area Scores';

  @override
  String get gochWhy => 'Why?';

  @override
  String get gochCurrentTransits => 'Active Transits';

  @override
  String get gochDailyPlan => 'Your Daily Plan';

  @override
  String get gochMorning => 'Morning';

  @override
  String get gochAfternoon => 'Afternoon';

  @override
  String get gochEvening => 'Evening';

  @override
  String get gochNight => 'Night';

  @override
  String get gochSmartReco => 'Smart Recommendations';

  @override
  String get gochExplain => 'Explain Today\'s Transit';

  @override
  String get gochDo => 'Do';

  @override
  String get gochDont => 'Avoid';

  @override
  String get gochDoWork => 'Tackle important work';

  @override
  String get gochDoMeditate => 'Meditate and reflect';

  @override
  String get gochDoStart => 'Start new plans';

  @override
  String get gochDoFinish => 'Finish pending tasks';

  @override
  String get gochDontArgue => 'Avoid arguments';

  @override
  String get gochDontImpulsive => 'Avoid impulsive decisions';

  @override
  String get gochDontOverspend => 'Avoid overspending';

  @override
  String gochThemeGrowth(Object area) {
    return 'A day of growth in $area — lean into it.';
  }

  @override
  String gochThemeChallenge(Object area) {
    return 'Stay patient with $area today — go steady.';
  }

  @override
  String gochPosLine(Object area) {
    return '$area is well supported right now.';
  }

  @override
  String gochChalLine(Object area) {
    return '$area needs extra care today.';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return 'Put your energy into $a1 today, and be gentle with $a2.';
  }

  @override
  String get divBeginner => 'Beginner';

  @override
  String get divSearchHint => 'Search: career, marriage, education…';

  @override
  String get divSummaryTitle => 'Divisional Chart Summary';

  @override
  String get divTotalCharts => 'Total Charts';

  @override
  String get divMostImportant => 'Most Important';

  @override
  String get divRecommendedForYou => 'Recommended For You';

  @override
  String get divCatEssential => 'Essential Charts';

  @override
  String get divCatPersonal => 'Personal Life';

  @override
  String get divCatKnowledge => 'Knowledge Charts';

  @override
  String get divCatAdvanced => 'Advanced Charts';

  @override
  String get divGoalProperty => 'Property';

  @override
  String get divGoalKarma => 'Karma';

  @override
  String get divBadgeHighlyRec => 'Highly Recommended';

  @override
  String get divBadgeRec => 'Recommended';

  @override
  String get divBadgeUseful => 'Useful';

  @override
  String get divBadgeOptional => 'Optional';

  @override
  String get divBadgeAdvOnly => 'Advanced Only';

  @override
  String get divRecommendBest => 'Recommend Best Charts';

  @override
  String get divNoMatch => 'No charts match your search';

  @override
  String get divLifeAreas => 'Life Areas';

  @override
  String divAiUse(Object purpose) {
    return 'Use this chart to analyse $purpose.';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return 'Your $c1 and $c2 charts are especially important — start there for the areas they cover, then explore the rest as needed.';
  }

  @override
  String divRecReasonHouse(Object house) {
    return 'Your $house house needs a closer look — this chart shows it in depth.';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '$planet is a key but tested planet — this chart reveals its deeper condition.';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return 'You are in $planet\'s Mahadasha, so this chart is especially timely now.';
  }

  @override
  String divRecSummary(Object c1) {
    return 'Based on your chart, $c1 should be your highest priority. The charts below are ordered by how relevant they are for you right now.';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return 'Open this chart when you want to study $purpose.';
  }

  @override
  String get yogaHelpful => 'Helpful';

  @override
  String get yogaInactive => 'Inactive';

  @override
  String get yogaTabMoney => 'Money';

  @override
  String get yogaTabRare => 'Rare';

  @override
  String get yogaSummaryTitle => 'Yoga Summary';

  @override
  String get yogaActiveYogas => 'Active Yogas';

  @override
  String get yogaTotalYogas => 'Total Yogas';

  @override
  String get yogaMostPowerful => 'Most Powerful';

  @override
  String get yogaFortuneRating => 'Overall Fortune';

  @override
  String get yogaBenefits => 'Benefits';

  @override
  String get yogaSupportingPlanets => 'Supporting Planets';

  @override
  String get yogaRanking => 'Top 5 Strongest Yogas';

  @override
  String get yogaExplain => 'Explain My Yogas';

  @override
  String get yogaExplainSubtitle => 'How your yogas support you';

  @override
  String get yogaNoneActive => 'No active yogas yet';

  @override
  String get yogaNoneInCategory => 'No yogas in this category';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return 'Your chart carries $count active yogas — supportive planetary combinations. Combinations involving $planets create especially helpful influences for growth and success.';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '$name supports $areas, and its benefits grow when its planets are active in dasha or transit.';
  }

  @override
  String get yogaAiGeneric =>
      'This yoga is a supportive combination in your chart that strengthens its related areas of life.';

  @override
  String get yogaExplainReassure =>
      'Yogas are the bright spots of your chart — helpful planetary combinations working in your favour. The stronger ones deliver lasting benefits, especially during the periods of the planets that form them.';

  @override
  String get doshSevere => 'Severe';

  @override
  String get doshVeryMild => 'Very Mild';

  @override
  String get doshLow => 'Low';

  @override
  String get doshHigh => 'High';

  @override
  String get doshCritical => 'Critical';

  @override
  String get doshSummaryTitle => 'Dosha Summary';

  @override
  String get doshActiveDoshas => 'Active Doshas';

  @override
  String get doshTotalChecked => 'Total Checked';

  @override
  String get doshOverallSeverity => 'Overall Severity';

  @override
  String get doshNoneActive => 'No active doshas — a clean chart!';

  @override
  String get doshCategory => 'Category';

  @override
  String get doshConfidence => 'Confidence';

  @override
  String get doshWhyFormed => 'Why This Formed';

  @override
  String get doshAffectedAreas => 'Affected Areas';

  @override
  String get doshTimeline => 'Timeline';

  @override
  String get doshDefinition => 'Definition';

  @override
  String get doshFormationRule => 'Formation Rule';

  @override
  String get doshSupportingPlanets => 'Related Planet';

  @override
  String get doshCancellation => 'Cancellation Yogas';

  @override
  String get doshNoCancellation => 'None found';

  @override
  String get doshAreaChildren => 'Children';

  @override
  String get doshAreaMind => 'Mind';

  @override
  String get remMantra => 'Mantra';

  @override
  String get remGemstone => 'Gemstone';

  @override
  String get remDonation => 'Donation';

  @override
  String get remTemple => 'Temple';

  @override
  String get remFasting => 'Fasting';

  @override
  String get remLifestyle => 'Lifestyle';

  @override
  String get remLifestyleGeneric =>
      'Practise gratitude, discipline and charity connected to this planet, and keep good conduct.';

  @override
  String get doshExplain => 'Explain My Doshas';

  @override
  String get doshExplainSubtitle => 'A calm, practical look at your doshas';

  @override
  String get doshExplainReassure =>
      'Doshas are common — almost every chart has some. They describe tendencies, not fixed fate. Awareness, good conduct and simple remedies reduce their practical effect, so there is no need to worry.';

  @override
  String get doshAiGeneric =>
      'This dosha describes a tendency in your chart. Its practical effect is usually mild and can be balanced with awareness and simple remedies.';

  @override
  String doshHeroSummary(Object active, Object total) {
    return 'Your chart shows $active active doshas out of $total checked. Most are mild and only a few need attention. With understanding and simple remedies, their practical effect can be eased.';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return 'This dosha mainly influences $areas. During $planet periods its effect can feel stronger, and remedies help balance it.';
  }

  @override
  String doshTimelineLine(Object planet) {
    return 'Its effect is felt most during the Mahadasha and Antardasha of $planet, and when $planet is active in transit.';
  }

  @override
  String get sbLegendary => 'Legendary';

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
  String get sbSummary => 'Planetary Strength Summary';

  @override
  String get sbAverageStrength => 'Average Strength';

  @override
  String get sbHighestRupa => 'Highest Rupa';

  @override
  String get sbRupa => 'Rupa';

  @override
  String get sbRanking => 'Planet Ranking';

  @override
  String get sbRequired => 'Required';

  @override
  String get sbExcess => 'Excess';

  @override
  String get sbDeficit => 'Deficit';

  @override
  String get sbTotalShadbala => 'Total Shadbala';

  @override
  String get sbExplain => 'Explain My Planetary Strength';

  @override
  String get sbExplainSubtitle => 'A simple summary of your planets\' strength';

  @override
  String get sbInfoTitle => 'Understanding Shadbala';

  @override
  String get sbQWhatIs => 'What is Shadbala?';

  @override
  String get sbQRupas => 'What are Rupas?';

  @override
  String get sbQHowCalc => 'How is strength calculated?';

  @override
  String get sbQHowUse => 'How to use this';

  @override
  String get sbWhyStrong => 'Why Strong';

  @override
  String get sbWhyWeak => 'Why Weak';

  @override
  String get sbDuringMahadasha => 'During Mahadasha';

  @override
  String get sbEffects => 'Effects';

  @override
  String get sbLifeAreas => 'Life Areas';

  @override
  String get sbPlanetDetails => 'Planet Details';

  @override
  String get sbBodyWhatIs =>
      'Shadbala (\'six-fold strength\') measures how much power each planet has to deliver its results, by adding six independent sources of strength.';

  @override
  String get sbBodyRupas =>
      'Strength is measured in Rupas (1 Rupa = 60 Virupas). Each planet needs a minimum Rupa strength to count as strong; more Rupas means it delivers its results more fully.';

  @override
  String get sbBodyHowCalc =>
      'Six balas are added: Sthana (positional), Dig (directional), Kala (temporal), Chesta (motional), Naisargika (natural) and Drik (aspectual). The total is compared with the planet\'s required minimum to get a percentage.';

  @override
  String get sbBodyHowUse =>
      'A planet above 100% comfortably delivers its significations; below 100% it needs support. Favour your strongest planets for important matters, and give the weakest ones remedies and patience.';

  @override
  String get sbRemedyStrong =>
      'Well-supported — no special remedy needed; you can use this planet\'s periods confidently.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '$strongP is your strongest planet, giving excellent support for $strongTrait. $weakP is the weakest and benefits most from remedies.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '$planet has $category Shadbala, so its $karakatva are supported accordingly.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return 'Strongest through $bala ($rupa rupas).';
  }

  @override
  String sbWeakLine(Object bala) {
    return 'Weakest in $bala, which lowers the total.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return 'During $planet\'s Mahadasha, its $karak come to the fore.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'With strong Shadbala, $karak are naturally supported.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'With modest Shadbala, $karak may need conscious effort.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return 'Strengthen $planet through its mantra, gemstone or charity, and act patiently during its periods.';
  }

  @override
  String get bhOverview => 'Overview';

  @override
  String get bhDetailed => 'Detailed';

  @override
  String get bhavaHouses => 'Houses';

  @override
  String get bhStrengthOverview => 'House Strength Overview';

  @override
  String get bhOverallAverage => 'Overall House Average';

  @override
  String get bhStrongestHouse => 'Strongest House';

  @override
  String get bhWeakestHouse => 'Weakest House';

  @override
  String get bhBestArea => 'Best Life Area';

  @override
  String get bhNeedsAttention => 'Needs Attention';

  @override
  String get bhSavContribution => 'SAV Contribution';

  @override
  String get bhLordCondition => 'House Lord Condition';

  @override
  String get bhBenefic => 'Benefic Influence';

  @override
  String get bhMalefic => 'Malefic Influence';

  @override
  String get bhStrengthReasons => 'Why This Score';

  @override
  String get bhGoodEffects => 'Good Effects';

  @override
  String get bhChallenges => 'Challenges';

  @override
  String get bhRemedies => 'Remedies';

  @override
  String get bhRanking => 'House Ranking';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'Explain My Houses';

  @override
  String get bhExplainSubtitle => 'A simple summary of your 12 houses';

  @override
  String bhHeroSummary(
    Object s1,
    Object s2,
    Object strongArea,
    Object weakArea,
  ) {
    return 'Your strongest houses are $s1 and $s2. $strongArea is naturally strong, while $weakArea needs more effort.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'Its lord $lord is placed as $relation.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'This house carries $sav benefic points (SAV); its occupants and aspects shape the rest of the score.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'When strong, it supports $meaning.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'When weak, $meaning may need extra effort and care.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'Strengthen its lord $lord and honour this house\'s matters to lift it.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'Your $house is $strengthWord. It governs $meaning.';
  }

  @override
  String get kunNavamsa => 'Navamsa (D9)';

  @override
  String get kunD10 => 'Dasamsa (D10)';

  @override
  String get kunPlacement => 'Planet Placement';

  @override
  String get kunHousesTitle => 'House Details';

  @override
  String get kunPlanet => 'Planet';

  @override
  String get kunNakshatra => 'Nakshatra';

  @override
  String get kunPada => 'Pada';

  @override
  String get kunLord => 'Lord';

  @override
  String get kunExplain => 'Explain My Chart';

  @override
  String get kunExplainSubtitle => 'A simple summary of your chart';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return 'The $ordinal house governs $meaning.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return '$planets placed here shape its results.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'Your ascendant is $asc, shaping your outlook and how others first see you.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'Your mind and emotions follow the Moon in $moon.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '$planet is your strongest planet — a natural area of ease and support.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '$planet is your most tested planet — patience and effort pay off here.';
  }

  @override
  String get plNature => 'Nature';

  @override
  String get plElement => 'Element';

  @override
  String get plGender => 'Gender';

  @override
  String get plKarakatva => 'Karakatva';

  @override
  String get plLordship => 'Lordship';

  @override
  String get plStrength => 'Strength';

  @override
  String get plAspectsGiven => 'Aspects Given';

  @override
  String get plAspectsReceived => 'Aspects Received';

  @override
  String get plConjunction => 'Conjunction';

  @override
  String get plHouseMeaning => 'House Meaning';

  @override
  String get plNakshatraMeaning => 'Nakshatra Meaning';

  @override
  String get plAiInterpretation => 'AI Interpretation';

  @override
  String get plSearchHint => 'Search any planet';

  @override
  String get plNoResults => 'No planets found';

  @override
  String get plBenefic => 'Benefic';

  @override
  String get plMalefic => 'Malefic';

  @override
  String get plMale => 'Male';

  @override
  String get plFemale => 'Female';

  @override
  String get plNeutralGender => 'Neutral';

  @override
  String get plOwnSign => 'Own Sign';

  @override
  String get plFriend => 'Friend Sign';

  @override
  String get plEnemy => 'Enemy Sign';

  @override
  String get plNeutral => 'Neutral';

  @override
  String get sumEther => 'Ether';

  @override
  String plLordOfHouses(Object houses) {
    return 'Lord of house(s) $houses';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return 'Ruled by $nakLord, bringing $trait.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '$planet sits in $sign, in the $house house.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'Its core significations — $karak — are well supported here.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'Its core significations — $karak — may need conscious effort here.';
  }

  @override
  String plAiExalted(Object planet) {
    return '$planet is exalted, giving its very best results.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '$planet is debilitated and needs support to deliver its results.';
  }

  @override
  String plAiCombust(Object planet) {
    return '$planet is combust, so it works less openly under the Sun\'s glare.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '$planet is vargottama — a strong placement repeated in the navamsa.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '$planet is retrograde, turning its energy inward and intensifying it.';
  }

  @override
  String get plHouse1 => 'self, body, personality and vitality';

  @override
  String get plHouse2 => 'wealth, family, speech and food';

  @override
  String get plHouse3 => 'courage, siblings, communication and short travels';

  @override
  String get plHouse4 => 'home, mother, comfort, property and inner peace';

  @override
  String get plHouse5 =>
      'children, creativity, intelligence, romance and past merits';

  @override
  String get plHouse6 => 'health, enemies, debts, service and daily work';

  @override
  String get plHouse7 => 'marriage, partnerships and business relationships';

  @override
  String get plHouse8 => 'longevity, transformation, secrets and inheritance';

  @override
  String get plHouse9 => 'fortune, dharma, higher learning, guru and father';

  @override
  String get plHouse10 => 'career, status, authority and public karma';

  @override
  String get plHouse11 =>
      'gains, income, friends, network and fulfilled desires';

  @override
  String get plHouse12 =>
      'loss, expenses, foreign lands, spirituality and liberation';

  @override
  String get sumVeryStrong => 'Very Strong';

  @override
  String get sumStrong => 'Strong';

  @override
  String get sumAverage => 'Average';

  @override
  String get sumWeak => 'Weak';

  @override
  String get sumNeedsAttention => 'Needs Attention';

  @override
  String get sumFire => 'Fire';

  @override
  String get sumEarth => 'Earth';

  @override
  String get sumAir => 'Air';

  @override
  String get sumWater => 'Water';

  @override
  String get sumMovable => 'Movable';

  @override
  String get sumFixed => 'Fixed';

  @override
  String get sumDual => 'Dual';

  @override
  String get sumDirEast => 'East';

  @override
  String get sumDirWest => 'West';

  @override
  String get sumDirNorth => 'North';

  @override
  String get sumDirSouth => 'South';

  @override
  String get sumDirNE => 'North-East';

  @override
  String get sumDirNW => 'North-West';

  @override
  String get sumDirSE => 'South-East';

  @override
  String get sumDirSW => 'South-West';

  @override
  String get sumSnapshotTitle => 'Your Astrology Snapshot';

  @override
  String get sumMahadasha => 'Mahadasha';

  @override
  String get sumAntardasha => 'Antardasha';

  @override
  String get sumNakshatra => 'Janma Nakshatra';

  @override
  String get sumElement => 'Element';

  @override
  String get sumModality => 'Modality';

  @override
  String get sumLuckyDirection => 'Lucky Direction';

  @override
  String get sumHighlights => 'Important Highlights';

  @override
  String get sumStrongPlanet => 'Strongest Planet';

  @override
  String get sumWeakPlanet => 'Weakest Planet';

  @override
  String get sumYogas => 'Yogas';

  @override
  String get sumDoshas => 'Doshas';

  @override
  String get sumRetrograde => 'Retrograde';

  @override
  String get sumCombust => 'Combust';

  @override
  String get sumExalted => 'Exalted';

  @override
  String get sumDebilitated => 'Debilitated';

  @override
  String get sumVargottama => 'Vargottama';

  @override
  String get sumQuickInsights => 'Quick Insights';

  @override
  String get sumSpirituality => 'Spirituality';

  @override
  String get sumTimezone => 'Timezone';

  @override
  String get sumAyanamsa => 'Ayanamsa';

  @override
  String get sumCalendarType => 'Calendar';

  @override
  String get sumCopied => 'Copied to clipboard';

  @override
  String get sumNatureFire =>
      'You have a bold, energetic and pioneering nature that leads from the front.';

  @override
  String get sumNatureEarth =>
      'You have a practical, grounded and disciplined nature that builds lasting results.';

  @override
  String get sumNatureAir =>
      'You have a curious, communicative and intellectual nature that thrives on new ideas.';

  @override
  String get sumNatureWater =>
      'You have an intuitive, emotional and empathetic nature with deep inner sensitivity.';

  @override
  String get sumGradePhraseExcellent =>
      'Strongly supported — favourable results are likely with steady effort.';

  @override
  String get sumGradePhraseGood =>
      'Well supported — generally positive with a little care.';

  @override
  String get sumGradePhraseAverage =>
      'Mixed support — results depend on effort and timing.';

  @override
  String get sumGradePhraseWeak =>
      'Needs attention — patience and remedies help here.';

  @override
  String get kDefCombust =>
      'A planet too close to the Sun, so its energy is \'burnt\' and weakened.';

  @override
  String get kDefRetrograde =>
      'A planet that appears to move backwards; its effects turn inward and intensify.';

  @override
  String get kDefNakshatra =>
      'One of the 27 lunar mansions that the Moon and planets travel through.';

  @override
  String get kDefVargottama =>
      'A planet in the same sign in both the birth chart (D1) and the navamsa (D9) — a mark of strength.';

  @override
  String get kDefOwnSign =>
      'A planet sitting in a sign it rules, where it feels at home and gives steady results.';

  @override
  String get kDefExalted =>
      'A planet in its sign of highest strength, giving its very best results.';

  @override
  String get kDefDebilitated =>
      'A planet in its weakest sign, where it struggles to give results.';

  @override
  String get kDefMooltrikona =>
      'A special portion of a planet\'s own sign where it is especially powerful.';

  @override
  String get kDefAscendant =>
      'The sign rising on the eastern horizon at birth — the Lagna, the foundation of the chart.';

  @override
  String get kDefMahadasha =>
      'The major planetary period that colours a long span of life.';

  @override
  String get kDefAntardasha =>
      'A sub-period within a Mahadasha that fine-tunes its results.';

  @override
  String get kDefPada =>
      'One of the four quarters of a nakshatra that a planet occupies.';

  @override
  String get aspGivesAspectTo => 'Gives Aspect To';

  @override
  String get aspReceivesAspectFrom => 'Receives Aspect From';

  @override
  String get aspInfluences => 'Influences';

  @override
  String get aspNoInfluence => 'No Influence';

  @override
  String get aspNoAspect => 'No Aspect';

  @override
  String get aspPresent => 'Present';

  @override
  String get aspAbsent => 'Absent';

  @override
  String get aspNotPresent => 'Not Present';

  @override
  String get aspSpecialAspect => 'Special Aspect';

  @override
  String get aspAspectWord => 'Aspect';

  @override
  String get aspTotalGiven => 'Aspects Given';

  @override
  String get aspTotalReceived => 'Aspects Received';

  @override
  String get aspStrongestInfluence => 'Strongest Influence';

  @override
  String get aspMedium => 'Medium';

  @override
  String get aspAspectPresent => 'Aspect Present';

  @override
  String get aspReason => 'Reason';

  @override
  String get aspBoth => 'Both';

  @override
  String get aspTargetHouse => 'Target House';

  @override
  String get aspTargetSign => 'Target Sign';

  @override
  String get aspLagnaReceives => 'Lagna Receives Aspect From';

  @override
  String get aspNoAspectFrom => 'No Aspect From';

  @override
  String get aspPlanetToPlanet => 'Planet to Planet';

  @override
  String get aspSignToSign => 'Sign to Sign';

  @override
  String get aspCombinedAspect => 'Combined Aspect';

  @override
  String get aspGrahaAspect => 'Graha Aspect';

  @override
  String get aspRashiAspect => 'Rashi Aspect';

  @override
  String get aspInfoTitle => 'Understanding Aspects (Drishti)';

  @override
  String get aspQGraha => 'What is Graha Drishti?';

  @override
  String get aspQRashi => 'What is Rashi Drishti?';

  @override
  String get aspQDiff => 'Difference between the two';

  @override
  String get aspQPredict => 'How aspects affect prediction';

  @override
  String get aspGrahaBody =>
      'Graha Drishti is the aspect a planet casts from its position. Every planet fully aspects the 7th house/planet from itself (a direct, face-to-face influence). In addition, Mars aspects the 4th and 8th, Jupiter the 5th and 9th, and Saturn the 3rd and 10th. Rahu and Ketu are usually given the 5th, 7th and 9th. A planet\'s aspect colours the planet or house it falls on with its own nature.';

  @override
  String get aspRashiBody =>
      'Rashi Drishti is a sign-to-sign aspect from Jaimini astrology, independent of which planets sit there. Movable signs aspect fixed signs (except the adjacent one), fixed signs aspect movable signs (except the adjacent one), and dual signs aspect the other dual signs. It is used mainly in Jaimini prediction and for judging relationships between houses.';

  @override
  String get aspDiffBody =>
      'Graha Drishti is cast by a planet and depends on where that planet sits. Rashi Drishti belongs to the sign itself and applies to whatever is placed in it. Graha Drishti is directional (planet A sees planet B), while Rashi Drishti is usually mutual between the signs. When both point to the same target, the influence is especially strong.';

  @override
  String get aspPredictBody =>
      'An aspect shows where a planet extends its influence beyond its own house. A benefic aspect (Jupiter, Venus, well-placed Moon/Mercury) supports and protects the target; a malefic aspect (Saturn, Mars, Sun, Rahu, Ketu) can pressure, delay or challenge it. Reading which planets aspect a house or planet explains why results appear the way they do.';

  @override
  String get aspTraitSun => 'authority, leadership and vitality';

  @override
  String get aspTraitMoon => 'emotional depth, comfort and intuition';

  @override
  String get aspTraitMars => 'energy, courage and drive';

  @override
  String get aspTraitMercury => 'communication, intellect and adaptability';

  @override
  String get aspTraitJupiter => 'wisdom, growth and good fortune';

  @override
  String get aspTraitVenus => 'love, harmony and comforts';

  @override
  String get aspTraitSaturn =>
      'discipline, responsibility and patient, sometimes delayed, success';

  @override
  String get aspTraitRahu => 'ambition, intensity and unconventional turns';

  @override
  String get aspTraitKetu => 'detachment, spirituality and sudden change';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '$planet is influencing $targets. This may bring $trait to the areas represented by these planets.';
  }

  @override
  String aspAiNone(Object planet) {
    return '$planet does not cast a special aspect on any other planet here; its influence works mainly through its own sign and house.';
  }

  @override
  String get avSummaryTitle => 'Ashtakavarga Summary';

  @override
  String get avOverallScore => 'Overall SAV Score';

  @override
  String get avOverallRating => 'Overall Rating';

  @override
  String get avStrongestSigns => 'Strongest Signs';

  @override
  String get avWeakestSigns => 'Weakest Signs';

  @override
  String get avScore => 'Score';

  @override
  String get avMeaning => 'Meaning';

  @override
  String get avGrid => 'Grid';

  @override
  String get avList => 'List';

  @override
  String get avOverallScoreShort => 'Overall Score';

  @override
  String get avNatalSignScore => 'Natal Sign Score';

  @override
  String get avBestSigns => 'Best Signs';

  @override
  String get avWeakSigns => 'Weak Signs';

  @override
  String get avAiInterpretation => 'AI Interpretation';

  @override
  String get avVeryGood => 'Very Good';

  @override
  String get avVeryWeak => 'Very Weak';

  @override
  String get avTotalSav => 'Total SAV';

  @override
  String get avPlanetContributions => 'Planet Contributions';

  @override
  String get avFinance => 'Finance';

  @override
  String get avOverallStrength => 'Overall Strength';

  @override
  String get avWhatDoesThisMean => 'What does this mean?';

  @override
  String get avSimple => 'Simple';

  @override
  String get avAdvanced => 'Advanced';

  @override
  String get avInfoTitle => 'Understanding Ashtakavarga';

  @override
  String get avStrong => 'Strong';

  @override
  String get avModerate => 'Moderate';

  @override
  String get avQWhatIsAv => 'What is Ashtakavarga?';

  @override
  String get avQWhatIsSav => 'What is SAV?';

  @override
  String get avQWhatIsBav => 'What is BAV?';

  @override
  String get avQHowToRead => 'How to read these scores';

  @override
  String get avQSavVsBav => 'SAV vs BAV';

  @override
  String get avABody =>
      'Ashtakavarga is a points-based strength system in Vedic astrology. Each planet awards benefic points (bindus, also called rekhas) to the twelve signs based on its position. More points in a sign means that area of life gets smoother support during related planetary periods and transits.';

  @override
  String get avSavBody =>
      'SAV (Sarva Ashtakavarga) adds together the points from all seven planets for each sign. It gives a single strength score per sign, so you can quickly see which signs — and the houses they fall in — are best supported in your chart.';

  @override
  String get avBavBody =>
      'BAV (Bhinna Ashtakavarga) shows the points from a single planet across the twelve signs. It tells you which signs a specific planet supports most, which matters when that planet\'s dasha or transit is active.';

  @override
  String get avHowToReadBody =>
      'Higher numbers are better. For SAV, an average sign scores about 28 points — above 30 is strong and below 25 needs care. For BAV, each sign ranges from 0 to 8, with 4 being average. Favour your strongest signs for important actions, and stay patient and disciplined with your weakest ones.';

  @override
  String get avSavVsBavBody =>
      'SAV is the combined total of all planets and shows a sign\'s overall strength. BAV is a single planet\'s contribution and shows which planet supports that sign. Use SAV for the big picture, and BAV to understand which planet drives a sign\'s strength.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'Your chart is strongest in $s1, $s2 and $s3. These signs give better support during planetary periods and transits. $weak currently has the least support, so patience and discipline help in matters connected with it.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '$planet performs strongest through $s1 and $s2. Matters governed by $planet tend to improve when these signs are activated.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'Your strongest signs are $s1 and $s2 — favour important beginnings when planets transit them.';
  }

  @override
  String avInsightWeak(Object s1) {
    return '$s1 has the least support — move carefully and avoid over-commitment in its matters.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '$planet carries the most points, so its significations are well supported in your life.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '$planet carries the fewest points and benefits most from remedies and conscious effort.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'Signs scoring above your average of $avg points tend to give smoother, more reliable results.';
  }

  @override
  String get fcKey => 'Key';

  @override
  String get fcActions => 'Actions';

  @override
  String get fcCautions => 'Cautions';

  @override
  String get fc12House => '12 House';

  @override
  String get fcProbabilities => 'Probabilities';

  @override
  String get fcHousesCaps => 'HOUSES';

  @override
  String get fcCritical => 'Critical';

  @override
  String get fcFlags => 'Flags';

  @override
  String get fcAnalysis => 'Analysis';

  @override
  String get fcConfidence => 'Confidence';

  @override
  String get fcQualityCaps => 'QUALITY';

  @override
  String get fcIncomeVs => 'Income vs';

  @override
  String get fcExpense => 'Expense';

  @override
  String get fcFinance => 'FINANCE';

  @override
  String get fcNetBalance => 'Net Balance';

  @override
  String get fcSignature => 'Signature';

  @override
  String get fcBestTimeForIncome => 'Best Time for Income';

  @override
  String get fcExpenseCaution => 'Expense Caution';

  @override
  String get fcIncomeCaps => 'INCOME';

  @override
  String get fcExpenseCaps => 'EXPENSE';

  @override
  String get fcRelationships => 'Relationships';

  @override
  String get fcAreasCaps => 'AREAS';

  @override
  String get fcBestForMeetings => 'Best For Meetings';

  @override
  String get fcOpportunitiesVs => 'Opportunities vs';

  @override
  String get fcRisks => 'Risks';

  @override
  String get fcOutlook => 'OUTLOOK';

  @override
  String get fcAction => 'Action';

  @override
  String get fcProtect => 'Protect';

  @override
  String get fcOpportunityCaps => 'OPPORTUNITY';

  @override
  String get fcRiskCaps => 'RISK';

  @override
  String get fcTopOpportunities => 'TOP OPPORTUNITIES';

  @override
  String get fcTopRisks => 'TOP RISKS';

  @override
  String get fcTiming => 'Timing';

  @override
  String get fcWindows => 'Windows';

  @override
  String get fcSlotsCaps => 'SLOTS';

  @override
  String get fcBestWindows => 'BEST WINDOWS';

  @override
  String get fcWorstWindows => 'WORST WINDOWS';

  @override
  String get fcAvoid => 'Avoid';

  @override
  String get fcHouse => 'House';

  @override
  String get fcFailed => 'Failed';

  @override
  String get lifeCareer => 'Career';

  @override
  String get lifeHealth => 'Health';

  @override
  String get lifeWealth => 'Wealth';

  @override
  String get lifeFamily => 'Family';

  @override
  String get lifeMind => 'Mind';

  @override
  String get lifeEgo => 'Ego';

  @override
  String get lifeAggression => 'Aggression';

  @override
  String get lifeConflict => 'Conflict';

  @override
  String get rashiElement => 'Element';

  @override
  String get rashiQuality => 'Quality';

  @override
  String get rashiLuckyColor => 'Lucky Color';

  @override
  String get rashiLuckyDay => 'Lucky Day';

  @override
  String get rashiLuckyNumber => 'Lucky Number';

  @override
  String get rashiGemstone => 'Gemstone';

  @override
  String get rashiBody => 'Body';

  @override
  String get gocharTodaysTransitChart => 'Today\'s Transit Chart';

  @override
  String get gocharTransit => 'Transit';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get best => 'Best';

  @override
  String get worst => 'Worst';

  @override
  String get avg => 'avg';

  @override
  String get favorableLoveWindowsLabel => 'Favorable Love Windows';

  @override
  String get lordLabel => 'Lord';

  @override
  String get lordPlacementLabel => 'Lord Placement';

  @override
  String get lordDignityLabel => 'Lord Dignity';

  @override
  String get categoriesSuffix => 'Categories';

  @override
  String get coreBlockerLabel => 'CORE BLOCKER';

  @override
  String get coreGiftLabel => '✦ CORE GIFT';

  @override
  String get coreThemeLabel => '● CORE THEME';

  @override
  String dominantLabel(Object value) {
    return 'Dominant: $value';
  }

  @override
  String get karakasSuffix => 'Karakas';

  @override
  String get protectiveLabel => 'PROTECTIVE';

  @override
  String secondaryLabel(Object value) {
    return ' · Secondary: $value';
  }

  @override
  String get tagCore => 'CORE';

  @override
  String get debtScoresHeader => '📉 DEBT SCORES';

  @override
  String get debtCurrentLoadStat => 'CURRENT\nDEBT LOAD';

  @override
  String get debtRecoveryCapacityStat => 'RECOVERY\nCAPACITY';

  @override
  String get debtIntensityStat => 'INTENSITY';

  @override
  String get debtDefaultRiskStat => 'DEFAULT RISK';

  @override
  String get debtProfileTitle => 'Debt Profile';

  @override
  String get debtKarmaLabel => 'KARMA';

  @override
  String get debtPersonalityLabel => 'PERSONALITY';

  @override
  String get debtPhaseLabel => 'PHASE';

  @override
  String get debtPrimaryCategoryLabel => 'PRIMARY CATEGORY';

  @override
  String get debtWord => 'Debt';

  @override
  String get debtYogasTitle => 'Debt Yogas';

  @override
  String get debtCreatingLabel => 'DEBT-CREATING';

  @override
  String get debtClearingLabel => 'DEBT-CLEARING';

  @override
  String get yearlyDebtTitle => 'Yearly Debt';

  @override
  String get debtRepaymentTitle => 'Repayment';

  @override
  String get debtDangerPeriodsTitle => 'Danger Periods';

  @override
  String get debtDefaultPctStat => 'DEFAULT %';

  @override
  String get debtBankruptcyPctStat => 'BANKRUPTCY %';

  @override
  String get debtChronicPctStat => 'CHRONIC %';

  @override
  String get debtResilienceStat => 'RESILIENCE';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'Recovery: $pct% · Timeline: ${years}yrs';
  }

  @override
  String get debtFreeWindowLabel => '🎯 DEBT-FREE WINDOW';

  @override
  String debtFreeYear(Object year) {
    return 'Year $year';
  }

  @override
  String get legalScoresHeader => '⚖️ LEGAL SCORES';

  @override
  String get legalVulnerabilityStat => 'LEGAL\nVULNERABILITY';

  @override
  String get legalVictoryPotentialStat => 'VICTORY\nPOTENTIAL';

  @override
  String get legalConflictStat => 'CONFLICT';

  @override
  String get legalResolutionStat => 'RESOLUTION';

  @override
  String get legalProfileTitle => 'Legal Profile';

  @override
  String get legalKarmaTypeLabel => 'KARMA TYPE';

  @override
  String get legalConflictStyleLabel => 'CONFLICT STYLE';

  @override
  String get legalStrategyLabel => 'STRATEGY';

  @override
  String get legalCaseDurationLabel => 'CASE DURATION';

  @override
  String get legalCurrentStatusLabel => 'CURRENT STATUS';

  @override
  String get legalWord => 'Legal';

  @override
  String get legalYogasTitle => 'Legal Yogas';

  @override
  String get legalDisputePressureLabel => 'DISPUTE PRESSURE';

  @override
  String get legalProtectionLabel => 'LEGAL PROTECTION';

  @override
  String get legalStressTrendTitle => 'Legal Stress';

  @override
  String get legalVisibleEnemiesStat => 'VISIBLE ENEMIES';

  @override
  String get legalHiddenEnemiesStat => 'HIDDEN ENEMIES';

  @override
  String get legalCriminalRiskStat => 'CRIMINAL RISK';

  @override
  String get legalFalseAccusationStat => 'FALSE ACCUSATION';

  @override
  String get legalContractKarmaTitle => 'Contract Karma';

  @override
  String get legalDocumentationLabel => 'DOCUMENTATION';

  @override
  String get legalFinePrintAwareLabel => 'FINE PRINT AWARE';

  @override
  String get legalNegotiationSkillLabel => 'NEGOTIATION SKILL';

  @override
  String get legalSignatureCautionLabel => 'SIGNATURE CAUTION';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'Resilience: $pct/100';
  }

  @override
  String get legalVictoryWord => 'Victory';

  @override
  String get legalAnalysisSuffix => 'Analysis';

  @override
  String get legalAsPlaintiff => 'AS PLAINTIFF';

  @override
  String get legalAsDefendant => 'AS DEFENDANT';

  @override
  String get legalWinProbability => 'WIN PROBABILITY';

  @override
  String get legalDisputeWord => 'Dispute';

  @override
  String get lifepathScoresHeader => '🌟 LIFE PATH SCORES';

  @override
  String get lifepathDharmaClarityStat => 'DHARMA\nCLARITY';

  @override
  String get lifepathFortuneBaselineStat => 'FORTUNE\nBASELINE';

  @override
  String get lifepathCoherenceStat => 'LIFE PATH\nCOHERENCE';

  @override
  String get lifepathKarmaStat => 'KARMA';

  @override
  String get lifepathSpiritualStat => 'SPIRITUAL';

  @override
  String get lifepathFameStat => 'FAME';

  @override
  String get lifepathSoulContractTitle => 'Soul Contract';

  @override
  String get lifepathAtmakarakaLabel => 'ATMAKARAKA';

  @override
  String get lifepathAkFocusLabel => 'AK FOCUS';

  @override
  String get lifepathSoulPurposeLabel => 'SOUL PURPOSE';

  @override
  String get lifepathLifeChapterLabel => 'LIFE CHAPTER';

  @override
  String get lifepathPrimaryDomainLabel => 'PRIMARY DOMAIN';

  @override
  String get lifepathLeadershipStat => 'LEADERSHIP';

  @override
  String get lifepathWisdomTeachStat => 'WISDOM/TEACH';

  @override
  String get lifepathServiceStat => 'SERVICE';

  @override
  String get lifepathHealingStat => 'HEALING';

  @override
  String get lifepathFortuneYogasTitle => 'Fortune Yogas';

  @override
  String get lifepathLuckBlocksLabel => 'LUCK BLOCKS';

  @override
  String get lifepathFortuneBoostersLabel => 'FORTUNE BOOSTERS';

  @override
  String get lifepathFortuneTrendTitle => 'Fortune Trend';

  @override
  String get lifepathGoldenWindowsTitle => 'Golden Windows ★';

  @override
  String get lifepathTransformationTitle => 'Transformation';

  @override
  String get lifepathMilestonesTitle => 'Life Milestones';

  @override
  String get lifepathKarmicLessonsTitle => 'Karmic Lessons';

  @override
  String get lifepathRahuGrowthLabel => 'RAHU GROWTH';

  @override
  String get lifepathKetuSurrenderLabel => 'KETU SURRENDER';

  @override
  String get lifepathSaturnLessonLabel => 'SATURN LESSON';

  @override
  String get lifepathLifeDifficultyLabel => 'LIFE DIFFICULTY';

  @override
  String get lifepathSoulExperienceTitle => '★ SOUL CAME TO EXPERIENCE';

  @override
  String get lifepathBlessingsTitle => '● BLESSINGS';

  @override
  String get lifepathLifeWord => 'Life';

  @override
  String get lifepathArchetypeSuffix => 'Archetype';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'Fulfillment: $pct%';
  }

  @override
  String get lifepathDestinyVsWord => 'Destiny vs';

  @override
  String get lifepathFreeWillSuffix => 'Free Will';

  @override
  String get lifepathDestinyStat => 'DESTINY';

  @override
  String get lifepathFreeWillStat => 'FREE WILL';

  @override
  String get pastlifeScoresHeader => '🔮 PAST LIFE SCORES';

  @override
  String get pastlifeSignatureStrengthStat => 'SIGNATURE\nSTRENGTH';

  @override
  String get pastlifeCarryForwardStat => 'CARRY-\nFORWARD';

  @override
  String get pastlifeMasteryPreservedStat => 'MASTERY\nPRESERVED';

  @override
  String get pastlifeUnfinishedStat => 'UNFINISHED';

  @override
  String get pastlifeKarmicDebtStat => 'KARMIC DEBT';

  @override
  String get pastlifeProfileTitle => 'Past Life Profile';

  @override
  String get pastlifeThemeLabel => 'THEME';

  @override
  String get pastlifeProfessionLabel => 'PROFESSION';

  @override
  String get pastlifeSocialStandingLabel => 'SOCIAL STANDING';

  @override
  String get pastlifeRegionLabel => 'REGION';

  @override
  String get pastlifeSpiritualLevelLabel => 'SPIRITUAL LEVEL';

  @override
  String get pastlifeGenderLabel => 'GENDER';

  @override
  String get pastlifeWealthLevelLabel => 'WEALTH LEVEL';

  @override
  String get pastlifeFamilyRoleLabel => 'FAMILY ROLE';

  @override
  String get pastlifeSkillsCarriedTitle => '★ SKILLS CARRIED FORWARD';

  @override
  String get pastlifeNaturalAttractionsTitle => '● NATURAL ATTRACTIONS';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ UNEXPLAINED FEARS';

  @override
  String get pastlifeMagneticPullsTitle => '→ MAGNETIC PULLS';

  @override
  String get pastlifeRelationshipStat => 'RELATIONSHIP';

  @override
  String get pastlifeFinancialStat => 'FINANCIAL';

  @override
  String get pastlifeServiceStat => 'SERVICE';

  @override
  String get pastlifeDharmicStat => 'DHARMIC';

  @override
  String get pastlifeOnRelationsStat => 'ON RELATIONS';

  @override
  String get pastlifeOnCareerStat => 'ON CAREER';

  @override
  String get pastlifeOnHealthStat => 'ON HEALTH';

  @override
  String get pastlifeOnSpiritualStat => 'ON SPIRITUAL';

  @override
  String get pastlifeKarmicResolutionTitle => 'Karmic Resolution';

  @override
  String get pastlifePrimaryPathLabel => 'PRIMARY PATH';

  @override
  String get pastlifeSecondaryPathLabel => 'SECONDARY PATH';

  @override
  String get pastlifeClearingProgressLabel => 'CLEARING PROGRESS';

  @override
  String get pastlifeRemainingWorkLabel => 'REMAINING WORK';

  @override
  String get pastlifeDebtTimelineLabel => 'DEBT TIMELINE';

  @override
  String get pastlifeMemoryAccessStat => 'MEMORY ACCESS';

  @override
  String get pastlifeDreamVisitsStat => 'DREAM VISITS';

  @override
  String get pastlifeDejaVuStat => 'DEJA VU';

  @override
  String get pastlifeRegressionFitStat => 'REGRESSION FIT';

  @override
  String get pastlifeActivationTitle => 'Past Life Activation';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'Maturity: $maturity · Status: $status';
  }

  @override
  String get pastlifeKetuWord => 'Ketu';

  @override
  String get pastlifePastMasterySuffix => 'Past Mastery';

  @override
  String get pastlifeKetuMasteredLabel => 'KETU · WHAT YOU MASTERED';

  @override
  String get pastlifeRahuWord => 'Rahu';

  @override
  String get pastlifeFutureGrowthSuffix => 'Future Growth';

  @override
  String get pastlifeRahuPullsLabel => 'RAHU · WHAT PULLS YOU FORWARD';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ Shadow: $shadow';
  }

  @override
  String get mentalScoresHeader => '🧠 MENTAL SCORES';

  @override
  String get mentalStabilityStat => 'MENTAL\nSTABILITY';

  @override
  String get mentalEmotionalBaselineStat => 'EMOTIONAL\nBASELINE';

  @override
  String get mentalResilienceStat => 'RESILIENCE';

  @override
  String get mentalAnxietyStat => 'ANXIETY';

  @override
  String get mentalDepressionStat => 'DEPRESSION';

  @override
  String get mentalRegulationStat => 'REGULATION';

  @override
  String get mentalProfileTitle => 'Mental Profile';

  @override
  String get mentalConstitutionLabel => 'CONSTITUTION';

  @override
  String get mentalStressDriverLabel => 'STRESS DRIVER';

  @override
  String get mentalStabilityAnchorLabel => 'STABILITY ANCHOR';

  @override
  String get mentalStressResponseLabel => 'STRESS RESPONSE';

  @override
  String get mentalAttachmentStyleLabel => 'ATTACHMENT STYLE';

  @override
  String get mentalBurnoutStageLabel => 'BURNOUT STAGE';

  @override
  String get mentalWord => 'Mental';

  @override
  String get mentalYogasTitle => 'Mental Yogas';

  @override
  String get mentalStressPressureLabel => 'STRESS PRESSURE';

  @override
  String get mentalWellnessTrendTitle => 'Wellness Trend';

  @override
  String get mentalHealthyCopingTitle => '✓ HEALTHY COPING';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ UNHEALTHY RISKS';

  @override
  String get mentalRecommendedAlternativesTitle => '✦ RECOMMENDED ALTERNATIVES';

  @override
  String get mentalSleepQualityStat => 'SLEEP QUALITY';

  @override
  String get mentalSocialSupportStat => 'SOCIAL SUPPORT';

  @override
  String get mentalBurnoutVulnStat => 'BURNOUT VULN';

  @override
  String get mentalSelfAwarenessStat => 'SELF-AWARENESS';

  @override
  String get mentalAnxietyWord => 'Anxiety';

  @override
  String get mentalTypesSuffix => 'Types';

  @override
  String get mentalTherapyWord => 'Therapy';

  @override
  String get mentalModalityFitSuffix => 'Modality Fit';

  @override
  String get characterScoresHeader => '🔍 CHARACTER SCORES';

  @override
  String get characterStrengthStat => 'CHARACTER\nSTRENGTH';

  @override
  String get characterIntegrityStat => 'INTEGRITY';

  @override
  String get characterResilienceStat => 'RESILIENCE';

  @override
  String get characterAwarenessStat => 'AWARENESS';

  @override
  String get characterStabilityStat => 'STABILITY';

  @override
  String get characterEthicsStat => 'ETHICS';

  @override
  String get characterSurfacePersonalityTitle => 'Surface Personality';

  @override
  String get characterLagnaLabel => 'LAGNA';

  @override
  String get characterConstitutionLabel => 'CONSTITUTION';

  @override
  String get characterNakshatraLabel => 'NAKSHATRA';

  @override
  String get characterDeityLabel => 'DEITY';

  @override
  String get characterMoonManasTitle => 'Moon Manas';

  @override
  String get characterSignLabel => 'SIGN';

  @override
  String get characterHouseLabel => 'HOUSE';

  @override
  String get characterWarmthStat => 'WARMTH';

  @override
  String get characterEmpathyStat => 'EMPATHY';

  @override
  String get characterLoyaltyStat => 'LOYALTY';

  @override
  String get characterBoundariesStat => 'BOUNDARIES';

  @override
  String get characterDharmaStat => 'DHARMA';

  @override
  String get characterTruthStat => 'TRUTH';

  @override
  String get characterCompassionStat => 'COMPASSION';

  @override
  String get characterGenerosityStat => 'GENEROSITY';

  @override
  String get characterSignatureVirtuesTitle => '★ SIGNATURE VIRTUES';

  @override
  String get characterNaturalTalentsTitle => '● NATURAL TALENTS';

  @override
  String get characterShadowPatternsTitle => '⚠ SHADOW PATTERNS';

  @override
  String get characterYogasTitle => 'Character Yogas';

  @override
  String get characterTestsLabel => 'TESTS';

  @override
  String get characterGiftsLabel => 'GIFTS';

  @override
  String get characterSelfAwareEiStat => 'SELF-AWARE EI';

  @override
  String get characterSelfRegulateStat => 'SELF-REGULATE';

  @override
  String get characterEmpathyEiStat => 'EMPATHY EI';

  @override
  String get characterSocialSkillsStat => 'SOCIAL SKILLS';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'Realization: $pct%';
  }

  @override
  String get characterAtmakarakaWord => 'Atmakaraka';

  @override
  String get characterSoulSignatureSuffix => 'Soul Signature';

  @override
  String get characterAtmakarakaLabel => 'ATMAKARAKA';

  @override
  String get characterGunaWord => 'Guna';

  @override
  String get characterProfileSuffix => 'Profile';

  @override
  String get characterSattvaLabel => 'Sattva';

  @override
  String get characterRajasLabel => 'Rajas';

  @override
  String get characterTamasLabel => 'Tamas';

  @override
  String get healthScoresHeader => '🏥 HEALTH SCORES';

  @override
  String get healthVitalityStat => 'VITALITY';

  @override
  String get healthImmunityStat => 'IMMUNITY';

  @override
  String get healthRecoveryStat => 'RECOVERY';

  @override
  String get healthMentalStat => 'MENTAL';

  @override
  String get healthStressTolStat => 'STRESS TOL';

  @override
  String get healthYogasTitle => 'Health Yogas';

  @override
  String get healthDiseasePressureLabel => 'DISEASE PRESSURE';

  @override
  String get healthTrendTitle => 'Health Trend';

  @override
  String get healthRecoveryWindowsTitle => 'Recovery Windows';

  @override
  String get healthCautionPeriodsTitle => 'Caution Periods';

  @override
  String get healthFertilityStat => 'FERTILITY';

  @override
  String get healthBurnoutRiskStat => 'BURNOUT RISK';

  @override
  String get healthAddictionVulnStat => 'ADDICTION VULN';

  @override
  String get healthWorkLifeBalStat => 'WORK-LIFE BAL';

  @override
  String get healthAyurvedicWord => 'Ayurvedic';

  @override
  String get healthConstitutionSuffix => 'Constitution';

  @override
  String get healthBodyWord => 'Body';

  @override
  String get healthSystemMapSuffix => 'System Map';

  @override
  String get healthBodyZoneWord => 'Body Zone';

  @override
  String get healthVulnerabilitySuffix => 'Vulnerability';

  @override
  String get healthDiseaseWord => 'Disease';

  @override
  String get healthSusceptibilitySuffix => 'Susceptibility';

  @override
  String get healthLifestyleFactorsTitle => 'Lifestyle Factors';

  @override
  String get healthSleepDisciplineLabel => 'SLEEP DISCIPLINE';

  @override
  String get healthDietDisciplineLabel => 'DIET DISCIPLINE';

  @override
  String get healthExerciseNeedLabel => 'EXERCISE NEED';

  @override
  String get healthSunlightNeedLabel => 'SUNLIGHT NEED';

  @override
  String get healthSocialTypeLabel => 'SOCIAL TYPE';

  @override
  String get healthHealingSpeedLabel => 'HEALING SPEED';

  @override
  String get wealthScoresHeader => '💰 WEALTH SCORES';

  @override
  String get wealthStrengthStat => 'WEALTH\nSTRENGTH';

  @override
  String get wealthAccumulationStat => 'ACCUMU-\nLATION';

  @override
  String get wealthIncomeFlowStat => 'INCOME\nFLOW';

  @override
  String get wealthSustainStat => 'SUSTAIN';

  @override
  String get wealthMultiStreamStat => 'MULTI-STREAM';

  @override
  String get wealthRetentionStat => 'RETENTION';

  @override
  String get wealthWord => 'Wealth';

  @override
  String get wealthYogasTitle => 'Wealth Yogas';

  @override
  String get wealthDrainsLabel => 'DRAINS';

  @override
  String get wealthBoostersLabel => 'BOOSTERS';

  @override
  String get wealthYearlyTrendTitle => 'Yearly Trend';

  @override
  String get wealthGrowthTitle => 'Wealth Growth';

  @override
  String get wealthCashPressureTitle => 'Cash Pressure';

  @override
  String get wealthMoneyPersonalityTitle => 'Money Personality';

  @override
  String get wealthTypeLabel => 'WEALTH TYPE';

  @override
  String get wealthRiskAppetiteLabel => 'RISK APPETITE';

  @override
  String get wealthInvestmentStyleLabel => 'INVESTMENT STYLE';

  @override
  String get wealthMoneyPersonalityLabel => 'MONEY PERSONALITY';

  @override
  String get wealthSpendingLabel => 'SPENDING';

  @override
  String get wealthDebtProbStat => 'DEBT PROB %';

  @override
  String get wealthInheritanceStat => 'INHERITANCE %';

  @override
  String get wealthSuddenGainsStat => 'SUDDEN GAINS %';

  @override
  String get wealthSpouseBoostStat => 'SPOUSE BOOST %';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'Success probability: $pct%';
  }

  @override
  String get wealthLifetimeClassLabel => 'LIFETIME WEALTH CLASS';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'Primary: $value';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'Peak: $value';
  }

  @override
  String get wealthIncomeWord => 'Income';

  @override
  String get wealthSourcesSuffix => 'Sources';

  @override
  String get wealthInvestmentWord => 'Investment';

  @override
  String get wealthMixSuffix => 'Mix';

  @override
  String wealthDrivenByLabel(Object planet) {
    return 'Driven by $planet';
  }

  @override
  String get marriageScoresHeader => '💒 MARRIAGE SCORES';

  @override
  String get marriageOverallStat => 'OVERALL\nMARRIAGE';

  @override
  String get marriageHarmonyStat => 'MARITAL\nHARMONY';

  @override
  String get marriageDomesticStabilityStat => 'DOMESTIC\nSTABILITY';

  @override
  String get marriageLongevityStat => 'LONGEVITY';

  @override
  String get marriageSatisfactionStat => 'SATISFACTION';

  @override
  String get marriageClarityStat => 'CLARITY';

  @override
  String get marriageWindowsTitle => 'Marriage Windows';

  @override
  String get marriagePhasesTitle => 'Marriage Phases';

  @override
  String get marriageInLawRelationsStat => 'IN-LAW RELATIONS';

  @override
  String get marriageFamilyHarmonyStat => 'FAMILY HARMONY';

  @override
  String get marriageFertilityStat => 'FERTILITY';

  @override
  String get marriageHomeOwnershipStat => 'HOME OWNERSHIP';

  @override
  String get marriageDivorceRiskStat => 'DIVORCE RISK';

  @override
  String get marriageInfidelityStat => 'INFIDELITY';

  @override
  String get marriageConflictStat => 'CONFLICT';

  @override
  String get marriageDistanceStat => 'DISTANCE';

  @override
  String get marriageSeekInPartnerTitle => '★ SEEK IN PARTNER';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ AVOID IN PARTNER';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'Realization: $pct%';
  }

  @override
  String get marriageDarakarakaWord => 'Darakaraka';

  @override
  String get marriageSpouseKarakaSuffix => 'Spouse Karaka';

  @override
  String get marriageDarakarakaDkLabel => 'DARAKARAKA (DK)';

  @override
  String get marriage7thWord => '7th';

  @override
  String get marriageSignLabel => 'SIGN';

  @override
  String get marriageLordInLabel => 'LORD IN';

  @override
  String get marriageStrengthLabel => 'STRENGTH';

  @override
  String get marriageSpouseWord => 'Spouse';

  @override
  String get marriageProfileSuffix => 'Profile';

  @override
  String get marriageSpouseTraitsTitle => '★ SPOUSE TRAITS';

  @override
  String get marriageLikelyProfessionsTitle => '● LIKELY PROFESSIONS';

  @override
  String get marriageHarmonyWord => 'Harmony';

  @override
  String get marriageRadarSuffix => 'Radar';

  @override
  String get marriagePhysicalLabel => 'Physical';

  @override
  String get marriageSharedValuesLabel => 'Shared Values';

  @override
  String get marriageConflictResolutionLabel => 'Conflict Resolution';

  @override
  String get marriageMangalDoshLabel => '⚠ MANGAL DOSH';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'Severity: $value';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'Cancellation: $value';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'Navamsa';

  @override
  String get multiChartTitleChild => 'Child';

  @override
  String get multiChartTitleLove => 'Love';

  @override
  String get multiChartTitleKarma => 'Karma';

  @override
  String get multiChartTitleDefault => 'Multi-Chart';

  @override
  String get multiChartSuffixProbability => 'Probability';

  @override
  String get multiChartSuffixCompatibility => 'Compatibility';

  @override
  String get multiChartSuffixLinkage => 'Linkage';

  @override
  String get multiChartSuffixReport => 'Report';

  @override
  String get multiChartParticipantsLabel => 'PARTICIPANTS';

  @override
  String get multiChartAnalysisWord => 'Analysis';

  @override
  String get multiChartConfidenceSuffix => 'Confidence';

  @override
  String get multiChartQualityBadge => 'QUALITY';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'Analyze this Vedic astrology report and give detailed insights:\n\n$formatted';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'Here is a Vedic astrology specialist report. Please analyze it thoroughly and provide actionable insights:\n\n$formatted';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'Review this Vedic astrology analysis and explain the key findings in simple language:\n\n$formatted';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return 'Copied for $label!';
  }

  @override
  String get childProbTitle1 => 'Child';

  @override
  String get childProbTitle2 => 'Probability';

  @override
  String get childNumberOfChildrenHeader1 => 'Number of';

  @override
  String get childNumberOfChildrenHeader2 => 'Children';

  @override
  String get childTimingHeader1 => 'Timing';

  @override
  String get childTimingHeader2 => 'Moola Dasha';

  @override
  String get child5thHouseHeader1 => '5th House';

  @override
  String get analysisWord => 'Analysis';

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
  String get childVedicHeader1 => 'Vedic';

  @override
  String get childVedicHeader2 => 'Remedies';

  @override
  String get progenyProbabilityLabel => 'PROGENY PROBABILITY';

  @override
  String get favorableWindowsLabel => 'FAVORABLE WINDOWS';

  @override
  String get partnerOneLabel => 'Partner 1';

  @override
  String get partnerTwoLabel => 'Partner 2';

  @override
  String get moonSignLabel => 'Moon Sign';

  @override
  String get lordInDusthana => 'Lord in Dusthana';

  @override
  String get lordStrengthLabel => 'Lord Strength';

  @override
  String get houseStrengthLabel => 'House Strength';

  @override
  String get dignityLabel => 'Dignity';

  @override
  String get directBadge => 'Direct';

  @override
  String get notCombustBadge => 'Not Combust';

  @override
  String get in5thHouseBadge => 'In 5th House';

  @override
  String get aspects5thBadge => 'Aspects 5th';

  @override
  String get no5thConnectionBadge => 'No 5th Connection';

  @override
  String jupiterInSignHeading(String sign) {
    return 'Jupiter in $sign';
  }

  @override
  String get d7LagnaLabel => 'D7 Lagna';

  @override
  String get d7FifthSignLabel => 'D7 5th Sign';

  @override
  String get d7FifthLordLabel => 'D7 5th Lord';

  @override
  String get jupiterInD7Label => 'Jupiter in D7';

  @override
  String get jupiterDignityLabel => 'Jupiter Dignity';

  @override
  String get d7StrengthLabel => 'D7 Strength';

  @override
  String get yesWord => 'Yes';

  @override
  String get noWord => 'No';

  @override
  String get beejaSphutaTitle => 'BEEJA SPHUTA';

  @override
  String get kshetraSphutaTitle => 'KSHETRA SPHUTA';

  @override
  String get degreeLabel => 'Degree';

  @override
  String get signLordLabel => 'Sign Lord';

  @override
  String get presentInLabel => 'Present In';

  @override
  String get netPenaltyLabel => 'Net Penalty';

  @override
  String get remedyGemstone => 'Gemstone Remedies';

  @override
  String get remedyMantra => 'Mantra Remedies';

  @override
  String get remedyRitual => 'Ritual Remedies';

  @override
  String get remedyLifestyle => 'Lifestyle Remedies';

  @override
  String get remedyCharitable => 'Charitable Remedies';

  @override
  String copiedForName(String name) {
    return 'Copied for $name!';
  }

  @override
  String get mahadashaLabel => 'Mahadasha';

  @override
  String get mdPeriodLabel => 'MD Period';

  @override
  String get antardashaLabel => 'Antardasha';

  @override
  String get adPeriodLabel => 'AD Period';

  @override
  String get pratyantardashaLabel => 'Pratyantardasha';

  @override
  String get favorabilityLabel => 'Favorability';

  @override
  String factorPrefix(String factor) {
    return 'Factor: $factor';
  }

  @override
  String appliesToLabel(String value) {
    return 'Applies to: $value';
  }

  @override
  String get qualityTag => 'QUALITY';

  @override
  String get reliabilityVeryHigh => 'Very High reliability';

  @override
  String get reliabilityGuidanceLevel => 'Guidance-level reading';

  @override
  String get karmaLinkTitle1 => 'Karma';

  @override
  String get karmaLinkTitle2 => 'Linkage';

  @override
  String get karmaFoundationHeader1 => 'Karmic';

  @override
  String get karmaFoundationHeader2 => 'Foundation';

  @override
  String get karmaPairwiseHeader1 => 'Pairwise';

  @override
  String get karmaPairwiseHeader2 => 'Linkages';

  @override
  String get karmaGroupHeader1 => 'Group';

  @override
  String get karmaGroupHeader2 => 'Pattern';

  @override
  String get karmaPastLifeHeader1 => 'Past Life';

  @override
  String get karmaPastLifeHeader2 => 'Goals';

  @override
  String get karmaCurrentLifeHeader1 => 'Current Life';

  @override
  String get karmaCurrentLifeHeader2 => 'Learning';

  @override
  String get karmaDebtsHeader2 => 'Debts';

  @override
  String get karmaMoolaDashaHeader1 => 'Moola Dasha';

  @override
  String get karmaMoolaDashaHeader2 => 'Timing';

  @override
  String get karmaDeepAuditHeader1 => 'Deep Audit';

  @override
  String get karmaDeepAuditHeader2 => 'Table';

  @override
  String get karmaHeroLabel => 'PAST LIFE KARMA LINKAGE';

  @override
  String get karmaKetuMastery => 'KETU MASTERY';

  @override
  String get nakshatraLabel => 'Nakshatra';

  @override
  String get deityLabel => 'Deity';

  @override
  String get masteryScoreLabel => 'Mastery Score';

  @override
  String get karmaRahuGrowth => 'RAHU GROWTH';

  @override
  String get growthScoreLabel => 'Growth Score';

  @override
  String get karmaAtmakaraka => 'ATMAKARAKA';

  @override
  String get karmaSaturnKarma => 'SATURN KARMA';

  @override
  String get karma12thHouse => '12TH HOUSE';

  @override
  String get karma9thHousePunya => '9TH HOUSE PUNYA';

  @override
  String get bhavaScoreLabel => 'Bhava Score';

  @override
  String get karmaD60Signature => 'D60 SIGNATURE';

  @override
  String get depthScoreLabel => 'Depth Score';

  @override
  String get linkageStrengthLabel => 'Linkage Strength';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'LINKAGE FACTORS ($count active)';
  }

  @override
  String get factorColumnLabel => 'Factor';

  @override
  String get weightColumnLabel => 'Weight';

  @override
  String get meaningColumnLabel => 'Meaning';

  @override
  String get statusColumnLabel => 'Status';

  @override
  String get karmaPastLifeConnection => 'PAST LIFE CONNECTION';

  @override
  String get karmaCurrentLifeDynamic => 'CURRENT LIFE DYNAMIC';

  @override
  String get karmaWhatTheyTeach => 'WHAT THEY TEACH EACH OTHER';

  @override
  String get karmaGroupThemeHeader => 'GROUP KARMIC THEME';

  @override
  String get karmaSharedSettingHeader => 'SHARED PAST LIFE SETTING';

  @override
  String get karmaCollectiveKetuHeader => 'COLLECTIVE KETU PATTERN';

  @override
  String get karmaCollectiveRahuHeader => 'COLLECTIVE RAHU PATTERN';

  @override
  String get housesPrefixLabel => 'Houses: ';

  @override
  String get signsPrefixLabel => 'Signs: ';

  @override
  String get karmicCohesionLabel => 'Karmic Cohesion';

  @override
  String get karmaGroupSoulContractHeader => 'GROUP SOUL CONTRACT';

  @override
  String get goalLabel => 'Goal';

  @override
  String get karmaSharedGoalHeader => 'SHARED PAST LIFE GOAL';

  @override
  String get howToGrowHeader => 'HOW TO GROW';

  @override
  String moolaDashaPrefix(String value) {
    return 'Moola Dasha: $value';
  }

  @override
  String get karmaSharedLessonHeader => 'SHARED GROUP LESSON';

  @override
  String get karmaMutualTeachingHeader => 'MUTUAL TEACHING MAP';

  @override
  String get karmaTeachingDynamicsPlaceholder =>
      'Teaching dynamics will emerge as karmic connections deepen.';

  @override
  String get typeFieldLabel => 'Type';

  @override
  String get basisFieldLabel => 'Basis';

  @override
  String get resolutionPathHeader => 'RESOLUTION PATH';

  @override
  String dashaTimingPrefix(String value) {
    return 'Dasha Timing: $value';
  }

  @override
  String get mutualDebtsHeader => 'MUTUAL DEBTS';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'Dates';

  @override
  String get groupKarmicWindowHeader => 'GROUP KARMIC WINDOW';

  @override
  String parametersAuditedHeading(int count) {
    return '$count PARAMETERS AUDITED';
  }

  @override
  String get valuePrefixLabel => 'Value: ';

  @override
  String weightPrefix(String value) {
    return 'W: $value';
  }

  @override
  String get loveCompatTitle1 => 'Love';

  @override
  String get loveCompatTitle2 => 'Compatibility';

  @override
  String get loveAttractionHeader1 => 'Attraction &';

  @override
  String get loveAttractionHeader2 => 'Chemistry';

  @override
  String get loveEmotionalHeader1 => 'Emotional';

  @override
  String get loveEmotionalHeader2 => 'Harmony';

  @override
  String get loveMentalHeader1 => 'Mental';

  @override
  String get loveMentalHeader2 => 'Rapport';

  @override
  String get lovePassionHeader1 => 'Passion &';

  @override
  String get lovePassionHeader2 => 'Physical';

  @override
  String get loveLongtermHeader1 => 'Long-term';

  @override
  String get loveKarmicHeader1 => 'Karmic Love';

  @override
  String get loveKarmicHeader2 => 'Bond';

  @override
  String get loveChallengesHeader1 => 'Challenges &';

  @override
  String get loveChallengesHeader2 => 'Friction';

  @override
  String get loveTimingHeader1 => 'Love Timing';

  @override
  String get loveRelationshipHeader1 => 'Relationship';

  @override
  String get loveRelationshipHeader2 => 'Dynamics';

  @override
  String get loveRemediesHeader1 => 'Remedies &';

  @override
  String get loveRemediesHeader2 => 'Guidance';

  @override
  String get loveCompatHeroLabel => 'LOVE COMPATIBILITY';

  @override
  String get loveChipAttraction => 'Attraction';

  @override
  String get loveChipPassion => 'Passion';

  @override
  String get loveChipChallenge => 'Challenge';

  @override
  String get venusSignLabel => 'Venus Sign';

  @override
  String get attractionScoreLabel => 'Attraction Score';

  @override
  String get activeContactsLabel => 'Active Contacts';

  @override
  String get magneticPullLabel => 'Magnetic Pull';

  @override
  String get initialAttractionLabel => 'Initial Attraction';

  @override
  String get emotionalScoreLabel => 'Emotional Score';

  @override
  String get elementMatchLabel => 'Element Match';

  @override
  String get harmonyLabel => 'Harmony';

  @override
  String get kootaYoni => 'YONI';

  @override
  String get kootaGana => 'GANA';

  @override
  String get kootaTara => 'TARA';

  @override
  String get doshaPresentBadge => 'Dosha Present';

  @override
  String get noDoshaBadge => 'No Dosha';

  @override
  String get axisLabel => 'Axis';

  @override
  String get mentalScoreLabel => 'Mental Score';

  @override
  String get mercuryDynamicsLabel => 'MERCURY DYNAMICS';

  @override
  String get communicationStyleLabel => 'COMMUNICATION STYLE MATCH';

  @override
  String get intellectualConnectionLabel => 'INTELLECTUAL CONNECTION';

  @override
  String get passionScoreLabel => 'Passion Score';

  @override
  String get marsVenusLabel => 'MARS-VENUS INTERPLAY';

  @override
  String get physicalChemistryLabel => 'PHYSICAL CHEMISTRY';

  @override
  String get yoniCompatLabel => 'YONI COMPATIBILITY';

  @override
  String get longtermScoreLabel => 'Long-term Score';

  @override
  String get seventhHouseSynastryLabel => '7TH HOUSE SYNASTRY';

  @override
  String get commitmentPotentialLabel => 'COMMITMENT POTENTIAL';

  @override
  String get jupiterBlessingLabel => 'JUPITER BLESSING';

  @override
  String get d9NavamsaResonanceLabel => 'D9 NAVAMSA RESONANCE';

  @override
  String get saturnLongevityLabel => 'SATURN LONGEVITY';

  @override
  String get karmicScoreLabel => 'Karmic Score';

  @override
  String get darakarakaLinkLabel => 'DARAKARAKA LINK';

  @override
  String get sourceLabel => 'Source';

  @override
  String get emotionalGiverReceiverLabel => 'EMOTIONAL GIVER / RECEIVER';

  @override
  String get powerBalanceLabel => 'POWER BALANCE';

  @override
  String get growthDynamicLabel => 'GROWTH DYNAMIC';

  @override
  String get addressesLabel => 'Addresses';

  @override
  String get loveScoresLabel => 'LOVE SCORES';

  @override
  String get loveCapacityLabel => 'LOVE\nCAPACITY';

  @override
  String get emotionalAvailabilityLabel => 'EMOTIONAL\nAVAILABILITY';

  @override
  String get romanticAttractionLabel => 'ROMANTIC\nATTRACTION';

  @override
  String get commitmentWord => 'COMMITMENT';

  @override
  String get intimacyWord => 'INTIMACY';

  @override
  String get fidelityWord => 'FIDELITY';

  @override
  String get loveProfileTitle => 'Love Profile';

  @override
  String get loveStyleLabel => 'LOVE STYLE';

  @override
  String get attractionStyleLabel => 'ATTRACTION STYLE';

  @override
  String get lovePathLabel => 'LOVE PATH';

  @override
  String get currentPhaseLabel => 'CURRENT PHASE';

  @override
  String get commitmentStyleLabel => 'COMMITMENT STYLE';

  @override
  String get loveWord => 'Love';

  @override
  String get karakasWord => 'Karakas';

  @override
  String get attractedToLabel => 'ATTRACTED TO';

  @override
  String get whatPartnerSeesLabel => 'WHAT PARTNER SEES';

  @override
  String get romancePatternTitle => 'Romance Pattern';

  @override
  String get firstLoveAgeLabel => 'FIRST LOVE AGE';

  @override
  String get relationshipCountLabel => 'RELATIONSHIP COUNT';

  @override
  String get avgDurationLabel => 'AVG DURATION';

  @override
  String get breakupTriggerLabel => 'BREAKUP TRIGGER';

  @override
  String get heartbreakRecoveryLabel => 'HEARTBREAK RECOVERY';

  @override
  String get loveTrendTitle => 'Love Trend';

  @override
  String get newLoveWindowsTitle => 'New Love Windows';

  @override
  String get loveBlocksTitle => 'Love Blocks';

  @override
  String get activeBlocksLabel => 'ACTIVE BLOCKS';

  @override
  String get loveMarriagePctLabel => 'LOVE MARRIAGE %';

  @override
  String get heartbreakVulnLabel => 'HEARTBREAK VULN';

  @override
  String get selfSabotageLabel => 'SELF-SABOTAGE';

  @override
  String get emotionalIqLabel => 'EMOTIONAL IQ';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'Fulfillment: $pct%';
  }

  @override
  String get languagesWord => 'Languages';

  @override
  String get givesLabel => 'GIVES';

  @override
  String get receivesLabel => 'RECEIVES';

  @override
  String get idealWord => 'Ideal';

  @override
  String get partnerWord => 'Partner';

  @override
  String get seekTheseTraitsLabel => 'SEEK THESE TRAITS';

  @override
  String get dealbreakersLabel => 'DEALBREAKERS';

  @override
  String get propertyScoresLabel => 'PROPERTY SCORES';

  @override
  String get acquisitionCapacityLabel => 'ACQUISITION\nCAPACITY';

  @override
  String get homeOwnershipPctLabel => 'HOME\nOWNERSHIP %';

  @override
  String get reWealthPotentialLabel => 'RE WEALTH\nPOTENTIAL';

  @override
  String get rentalWord => 'RENTAL';

  @override
  String get vehiclesWord => 'VEHICLES';

  @override
  String get landPctLabel => 'LAND %';

  @override
  String get propertyProfileTitle => 'Property Profile';

  @override
  String get karmaTypeLabel => 'KARMA TYPE';

  @override
  String get environmentLabel => 'ENVIRONMENT';

  @override
  String get styleLabel => 'STYLE';

  @override
  String get sizeLabel => 'SIZE';

  @override
  String get locationLabel => 'LOCATION';

  @override
  String get actionNext12mLabel => 'ACTION NEXT 12M';

  @override
  String get propertyWord => 'Property';

  @override
  String get propertyYogasTitle => 'Property Yogas';

  @override
  String get drainsLabel => 'DRAINS';

  @override
  String get boostersLabel => 'BOOSTERS';

  @override
  String get propertyTrendTitle => 'Property Trend';

  @override
  String get buyingWindowsTitle => 'Buying Windows';

  @override
  String get constructionWindowsTitle => 'Construction Windows';

  @override
  String get maternalInherPctLabel => 'MATERNAL INHER %';

  @override
  String get paternalInherPctLabel => 'PATERNAL INHER %';

  @override
  String get multiHomePctLabel => 'MULTI-HOME %';

  @override
  String get investmentPctLabel => 'INVESTMENT %';

  @override
  String get vehicleProfileTitle => 'Vehicle Profile';

  @override
  String get countLabel => 'COUNT';

  @override
  String get firstAgeLabel => 'FIRST AGE';

  @override
  String get categoryLabel => 'CATEGORY';

  @override
  String get luxuryLabel => 'LUXURY';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'Lifetime count: $count · Fulfillment: $pct%';
  }

  @override
  String get pressureWord => 'PRESSURE';

  @override
  String get protectionWord => 'PROTECTION';

  @override
  String get astrologicalWord => 'Astrological';

  @override
  String get keyRisksHeader1 => 'Key';

  @override
  String get keyRisksHeader2 => 'Risks';

  @override
  String get reportCopiedShort => 'Report copied!';

  @override
  String get keyScoresLabel => 'KEY SCORES';

  @override
  String allScoresCountLabel(int count) {
    return 'All Scores ($count)';
  }

  @override
  String get windowsWord => 'Windows';

  @override
  String get genericFailedMsg => 'Failed';

  @override
  String get unknownWord => 'Unknown';

  @override
  String selectKarmaChartsLabel(int max) {
    return 'Select 2-$max Charts';
  }

  @override
  String selectChartsLabelCount(int max) {
    return 'Select $max Charts';
  }

  @override
  String runningAnalysisLabel(String label) {
    return 'Running $label analysis...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'Pick 2 to $max charts to analyze karmic links';
  }

  @override
  String get pickMaleFemaleHint => 'Pick a Male and Female chart';

  @override
  String get personOneLabel => 'Person 1';

  @override
  String get personTwoLabel => 'Person 2';

  @override
  String get analysisFailedMsg => 'Analysis failed';

  @override
  String analyzeChartsCountLabel(int count) {
    return 'Analyze $count Charts';
  }

  @override
  String get contextGeneralLabel => 'General';

  @override
  String get contextLoveLabel => 'Love';

  @override
  String get contextBusinessLabel => 'Business';

  @override
  String get contextFamilyLabel => 'Family';

  @override
  String get contextTeamLabel => 'Team';

  @override
  String get contextFriendshipLabel => 'Friendship';

  @override
  String get relationshipIntelTitle => 'Relationship Intelligence';

  @override
  String analyzingChartsCountLabel(int count) {
    return 'Analyzing $count charts...';
  }

  @override
  String get relationshipContextLabel => 'Relationship Context';

  @override
  String get kundliMilanReportTitle => 'Kundli Milan Report';

  @override
  String get runningMilanAnalysisLabel => 'Running Milan analysis...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '$count/2 selected';
  }

  @override
  String get runMilanAnalysisBtn => 'Run Milan Analysis';

  @override
  String get noChartsCreateFirst => 'No charts. Create a birth chart first.';

  @override
  String get selectBirthChartAnalyze => 'Select a birth chart to analyze';

  @override
  String get doshAnalysis => 'Dosha Analysis';

  @override
  String doshActiveCount(Object active, Object total) {
    return '$active active / $total checked';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '$active active / $total yogas checked';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'ACTIVE YOGAS ($count)';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'Hide inactive yogas ($count)';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'Show inactive yogas ($count)';
  }

  @override
  String get loadFailed => 'Failed';

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
    return '$planet Sub-periods';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return 'Birth Lord: $lord • Balance: $balance yrs';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'Lagna: $lagna • Balance: $balance yrs';
  }

  @override
  String dashaYearsValue(Object years) {
    return '$years years';
  }

  @override
  String get dashaCurrentPeriod => 'Current Dasha Period';

  @override
  String dashaAsOf(Object date) {
    return 'As of: $date';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'Active Yogas in Current Period ($count)';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'Active Doshas in Current Period ($count)';
  }

  @override
  String get dashaNoYogasTriggered => 'No yogas triggered';

  @override
  String get dashaNoDoshasTriggered => 'No doshas triggered';

  @override
  String get divD1Name => 'Rasi (D-1)';

  @override
  String get divD1Desc => 'Physical existence, all matters';

  @override
  String get divD2Name => 'Hora (D-2)';

  @override
  String get divD2Desc => 'Wealth, money';

  @override
  String get divD3Name => 'Drekkana (D-3)';

  @override
  String get divD3Desc => 'Siblings, courage';

  @override
  String get divD4Name => 'Chaturthamsa (D-4)';

  @override
  String get divD4Desc => 'Property, residence, fortune';

  @override
  String get divD5Name => 'Panchamsa (D-5)';

  @override
  String get divD5Desc => 'Fame, authority, power';

  @override
  String get divD6Name => 'Shashthamsa (D-6)';

  @override
  String get divD6Desc => 'Health troubles';

  @override
  String get divD7Name => 'Saptamsa (D-7)';

  @override
  String get divD7Desc => 'Children, grandchildren';

  @override
  String get divD8Name => 'Ashtamsa (D-8)';

  @override
  String get divD8Desc => 'Sudden troubles, litigation';

  @override
  String get divD9Name => 'Navamsha (D-9)';

  @override
  String get divD9Desc => 'Marriage, spouse, dharma';

  @override
  String get divD10Name => 'Dasamsha (D-10)';

  @override
  String get divD10Desc => 'Career, profession';

  @override
  String get divD11Name => 'Rudramsha (D-11)';

  @override
  String get divD11Desc => 'Death, destruction';

  @override
  String get divD12Name => 'Dwadasamsha (D-12)';

  @override
  String get divD12Desc => 'Parents, blood-relatives';

  @override
  String get divD16Name => 'Shodasamsha (D-16)';

  @override
  String get divD16Desc => 'Vehicles, comforts, pleasures';

  @override
  String get divD20Name => 'Vimsamsha (D-20)';

  @override
  String get divD20Desc => 'Spiritual matters, religious';

  @override
  String get divD24Name => 'Chaturvimsamsha (D-24)';

  @override
  String get divD24Desc => 'Learning, knowledge, education';

  @override
  String get divD27Name => 'Nakshatramsha (D-27)';

  @override
  String get divD27Desc => 'Strengths, weaknesses, nature';

  @override
  String get divD30Name => 'Trimsamsha (D-30)';

  @override
  String get divD30Desc => 'Evils, sub-conscious, punishment';

  @override
  String get divD40Name => 'Khavedamsha (D-40)';

  @override
  String get divD40Desc => 'Auspicious/inauspicious (maternal)';

  @override
  String get divD45Name => 'Akshavedamsha (D-45)';

  @override
  String get divD45Desc => 'All matters (paternal)';

  @override
  String get divD60Name => 'Shashtyamsha (D-60)';

  @override
  String get divD60Desc => 'Past-life karma — MOST IMPORTANT';

  @override
  String get lifeAreaCareer => 'Career';

  @override
  String get lifeAreaWealth => 'Wealth';

  @override
  String get lifeAreaMarriage => 'Marriage';

  @override
  String get lifeAreaHealth => 'Health';

  @override
  String get lifeAreaSpirituality => 'Spirituality';

  @override
  String lifeAreaGrade(Object grade) {
    return 'Grade: $grade';
  }

  @override
  String get lifeAreaFactorsLabel => 'Factors:';

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
    return 'Lon: $value°';
  }

  @override
  String get chakraOverallHealth => 'Overall Health';

  @override
  String get careerWord => 'Career';

  @override
  String get failedToLoad => 'Failed to load';

  @override
  String get kundliAscendantLagna => 'Ascendant (Lagna)';

  @override
  String get kundliMoonSignRashi => 'Moon Sign (Rashi)';

  @override
  String get kundliSunSign => 'Sun Sign';

  @override
  String kundliEngineLabel(Object engine) {
    return 'Engine: $engine';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return 'Degree: $degree°  •  Nakshatra: $nakshatra ($pada)';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'Nakshatra Lord: $lord  •  Dignity: $dignity';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return '$base Chart — $sign';
  }

  @override
  String kundliBaseChart(Object base) {
    return '$base Chart';
  }

  @override
  String get careerSummary => 'Career Summary';

  @override
  String get phase => 'Phase';

  @override
  String get confidenceLabel => 'Confidence';

  @override
  String get careerScores => 'Career Scores';

  @override
  String get stabilityLabel => 'Stability';

  @override
  String get growthLabel => 'Growth';

  @override
  String get gradeExcellent => 'Excellent';

  @override
  String get gradeGood => 'Good';

  @override
  String get gradeAverage => 'Average';

  @override
  String get gradeBelowAvg => 'Below Avg';

  @override
  String get gradeWeak => 'Weak';

  @override
  String get careerTypeDomain => 'Career & Domain';

  @override
  String get careerTimeline => 'Career Timeline';

  @override
  String dashaLabel(Object dasha) {
    return 'Dasha: $dasha';
  }

  @override
  String get improvementSuggestions => 'Improvement Suggestions';

  @override
  String get chartDetails => 'Chart Details';

  @override
  String get keyHousesCareer => 'Key Houses (Career)';

  @override
  String get keyCareerPlanets => 'Key Career Planets';

  @override
  String get empty => 'Empty';

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
  String get charGroupCorePersonality => 'Core Personality';

  @override
  String get charGroupTrustHonesty => 'Trust & Honesty';

  @override
  String get charGroupLoyaltyCommitment => 'Loyalty & Commitment';

  @override
  String get charGroupStrategicPrivacy => 'Strategic & Privacy';

  @override
  String get charGroupFinancial => 'Financial';

  @override
  String get charGroupAngerConflict => 'Anger & Conflict';

  @override
  String get charGroupMoralDharmic => 'Moral & Dharmic';

  @override
  String get charGroupIntellectCommunication => 'Intellect & Communication';

  @override
  String get charGroupEmotionalProfile => 'Emotional Profile';

  @override
  String get charGroupMentalHealth => 'Mental Health';

  @override
  String get charGroupRomantic => 'Romantic';

  @override
  String get charGroupMarriageFamily => 'Marriage & Family';

  @override
  String get charGroupOverallLife => 'Overall Life';

  @override
  String get grahaDrishti => 'Graha Drishti (Planet Aspects)';

  @override
  String get grahaDrishtiSubtitle => 'Who aspects whom (%)';

  @override
  String get lagnaAspectsReceived => 'Lagna Aspects Received';

  @override
  String get rashiDrishti => 'Rashi Drishti (Sign Aspects)';

  @override
  String get shadbalaRupas => 'rupas';

  @override
  String get bhavaHouse1 => 'Self / Body';

  @override
  String get bhavaHouse2 => 'Wealth / Family';

  @override
  String get bhavaHouse3 => 'Siblings / Courage';

  @override
  String get bhavaHouse4 => 'Home / Mother';

  @override
  String get bhavaHouse5 => 'Children / Intellect';

  @override
  String get bhavaHouse6 => 'Enemies / Health';

  @override
  String get bhavaHouse7 => 'Marriage / Partner';

  @override
  String get bhavaHouse8 => 'Longevity';

  @override
  String get bhavaHouse9 => 'Fortune / Guru';

  @override
  String get bhavaHouse10 => 'Career / Father';

  @override
  String get bhavaHouse11 => 'Gains / Friends';

  @override
  String get bhavaHouse12 => 'Loss / Moksha';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '$sign • Lord: $lord';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: $value';
  }

  @override
  String get sarvaAshtakavarga => 'Sarva Ashtakavarga (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'Total: $total rekhas (average sign = $avg)';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '$planet — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'Total: $total rekhas • At natal sign: $score';
  }

  @override
  String get today => 'Today';

  @override
  String gocharTransitScores(Object date) {
    return 'Gochar (Transit Scores) — $date';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'Native Moon: $sign';
  }

  @override
  String get gocharBest => 'BEST';

  @override
  String get gocharWorst => 'WORST';

  @override
  String copiedOpening(Object ai) {
    return 'Copied! Opening $ai...';
  }

  @override
  String get openLink => 'OPEN ↗';

  @override
  String get discussReportWithAI => 'DISCUSS THIS REPORT WITH AI';

  @override
  String get reliabilityHigh => 'High reliability';

  @override
  String get reliabilityModerate => 'Moderate reliability';

  @override
  String get reliabilityLow => 'Lower — guidance only';

  @override
  String get reliabilityGoodEdu => 'Good reliability · D-24 verified';

  @override
  String get relationshipWord => 'Relationship';

  @override
  String get intelligenceWord => 'Intelligence';

  @override
  String get relationshipIntelligence => 'RELATIONSHIP INTELLIGENCE';

  @override
  String get typeLabel => 'TYPE';

  @override
  String get trustLabel => 'TRUST';

  @override
  String get dhokaRisk => 'DHOKA RISK';

  @override
  String get powerLabel => 'Power';

  @override
  String get integrity => 'Integrity';

  @override
  String get warmth => 'Warmth';

  @override
  String get trustWord => 'Trust';

  @override
  String get assertLabel => 'Assert';

  @override
  String get character => 'Character';

  @override
  String get love => 'Love';

  @override
  String get businessWord => 'Business';

  @override
  String get karmic => 'Karmic';

  @override
  String get enmityRisk => 'Enmity Risk';

  @override
  String get hdrChartProfiles => 'Chart Profiles';

  @override
  String get hdrPairwiseAnalysis => 'Pairwise Analysis';

  @override
  String get hdrCriticalPatterns => 'Critical Patterns';

  @override
  String get hdrGroupRecommendations => 'Group Recommendations';

  @override
  String get sharedPractices => 'SHARED PRACTICES';

  @override
  String get hdrIndividualGuidance => 'Individual Guidance';

  @override
  String get growthAreas => 'GROWTH AREAS';

  @override
  String get hdrCoreTheme => 'Core Theme';

  @override
  String get growthOriented => 'GROWTH-ORIENTED';

  @override
  String get groupTheme => 'GROUP THEME';

  @override
  String get compatibility => 'COMPATIBILITY';

  @override
  String get unifiedScoreLabel => 'UNIFIED SCORE';

  @override
  String get ashtakoot => 'ASHTAKOOT';

  @override
  String get probability => 'PROBABILITY';

  @override
  String get hdrAshtakootSummary => 'Ashtakoot Summary';

  @override
  String get hdrGunBreakdown => '8 Gun Breakdown';

  @override
  String get hdrMangalDosh => 'Mangal Dosh';

  @override
  String get hdrD9CrossChart => 'D-9 Cross-Chart';

  @override
  String get d9Compatibility => 'D-9 COMPATIBILITY';

  @override
  String get hdrDomainCompatibility => 'Domain Compatibility';

  @override
  String get emotional => 'Emotional';

  @override
  String get intellectual => 'Intellectual';

  @override
  String get spiritual => 'Spiritual';

  @override
  String get financial => 'Financial';

  @override
  String get domestic => 'Domestic';

  @override
  String get communicationWord => 'Communication';

  @override
  String get sharedDharma => 'Shared Dharma';

  @override
  String get familyCreation => 'Family Creation';

  @override
  String get hdrMarriageTiming => 'Marriage Timing';

  @override
  String get jointMarriageWindows => 'Joint Marriage Windows';

  @override
  String get engagementWindows => 'Engagement Windows';

  @override
  String get recommendedLabel => 'Recommended';

  @override
  String get hdrKeyRisks => 'Key Risks';

  @override
  String get hdrFinalVerdict => 'Final Verdict';

  @override
  String get marriageVerdict => 'MARRIAGE VERDICT';

  @override
  String get educationWord => 'Education';

  @override
  String get learningSuffix => '& Learning';

  @override
  String get coreEducationScores => 'CORE EDUCATION SCORES';

  @override
  String get academicSuccess => 'ACADEMIC SUCCESS';

  @override
  String get learningCapacity => 'LEARNING CAPACITY';

  @override
  String get memory => 'MEMORY';

  @override
  String get intelligence => 'INTELLIGENCE';

  @override
  String get research => 'RESEARCH';

  @override
  String get hdrIntellectualProfile => 'Intellectual Profile';

  @override
  String get learningSignature => 'LEARNING SIGNATURE';

  @override
  String get hdrSubjectKaraka => 'Subject Karaka';

  @override
  String get hdrHouseFoundations => 'House Foundations';

  @override
  String get hdrMercuryJupiter => 'Mercury & Jupiter';

  @override
  String get hdrEducationYogas => 'Education Yogas';

  @override
  String get hdrDivisionalValidation => 'Divisional Validation';

  @override
  String get standing => 'STANDING';

  @override
  String get hdrSubjectRanking => 'Subject Ranking';

  @override
  String get hdrDegreeLikelihood => 'Degree Likelihood';

  @override
  String get hdrStudyPeriods => 'Study Periods';

  @override
  String get earlySchooling => 'Early Schooling';

  @override
  String get higherEducation => 'Higher Education';

  @override
  String get postgradResearch => 'Postgrad · Research';

  @override
  String get hdrLearningPreferences => 'Learning Preferences';

  @override
  String get hdrChallengesGifts => 'Challenges & Gifts';

  @override
  String get challenges => 'CHALLENGES';

  @override
  String get cognitiveGifts => 'COGNITIVE GIFTS';

  @override
  String get naturalAbilities => 'NATURAL ABILITIES';

  @override
  String get hdrSaraswatiRemedies => 'Saraswati Remedies';

  @override
  String get studentVerdict => 'STUDENT VERDICT';

  @override
  String get educationCareerLinkage => 'EDUCATION → CAREER LINKAGE';

  @override
  String get startupSuffix => '& Startup';

  @override
  String get coreBusinessScores => 'CORE BUSINESS SCORES';

  @override
  String get overallBusiness => 'OVERALL BUSINESS';

  @override
  String get ventureSuccess => 'VENTURE SUCCESS';

  @override
  String get eleventhHouse => '11TH HOUSE';

  @override
  String get gains => 'GAINS';

  @override
  String get investor => 'INVESTOR';

  @override
  String get hdrFounderArchetype => 'Founder Archetype';

  @override
  String get hdrTenthEleventhHouses => '10th & 11th Houses';

  @override
  String get hdrBusinessYogas => 'Business Yogas';

  @override
  String get hdrRecommendedDomains => 'Recommended Domains';

  @override
  String get hdrBusinessStyle => 'Business Style';

  @override
  String get hdrFounderSkills => 'Founder Skills';

  @override
  String get hdrFundingProfile => 'Funding Profile';

  @override
  String get recommendedPath => 'RECOMMENDED PATH';

  @override
  String get investorAttract => 'INVESTOR ATTRACT';

  @override
  String get familyBacking => 'FAMILY BACKING';

  @override
  String get hybridViability => 'HYBRID VIABILITY';

  @override
  String get launchWindow => 'Launch Window';

  @override
  String get scaleWindow => 'Scale Window';

  @override
  String get hdrBusinessRisks => 'Business Risks';

  @override
  String get recoveryCapacity => 'RECOVERY CAPACITY';

  @override
  String get hdrRemediesSolutions => 'Remedies & Solutions';

  @override
  String get aiConnectionLost => 'Connection lost. Please try again.';

  @override
  String get aiSomethingWrong => 'Something went wrong';

  @override
  String get aiNoResponse => 'No response';

  @override
  String get aiConnectionError => 'Connection error. Please try again.';

  @override
  String get aiAutoDetect => 'Auto-detect';

  @override
  String aiAutoArrow(String lang) {
    return 'Auto → $lang';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'Language: $lang';
  }

  @override
  String get aiNoBirthCharts => 'No birth charts found';

  @override
  String get aiCreateChartFirst => 'Create a birth chart first to chat with AI';

  @override
  String get aiSelectChartBegin => 'Select a birth chart to begin analysis';

  @override
  String aiAnalyzingName(String name) {
    return 'Analyzing: $name';
  }

  @override
  String get aiChange => 'Change';

  @override
  String get aiAnalyzingChart => 'Analyzing your chart...';

  @override
  String get aiAskStarsHint => 'Ask the stars anything...';

  @override
  String get aiSuggestedFollowups => 'Suggested follow-ups';

  @override
  String get aiThinking => 'Thinking...';

  @override
  String get aiThanks => 'Thanks!';

  @override
  String get aiFeedbackNoted => 'Feedback noted';

  @override
  String get svcAll => 'All';

  @override
  String get svcNoServices => 'No services available';

  @override
  String get svcFree => 'FREE';

  @override
  String get astroFailedStartCall => 'Failed to start call';

  @override
  String get astroFailedStartChat => 'Failed to start chat';

  @override
  String astroErrorDetail(String error) {
    return 'Error: $error';
  }

  @override
  String get astroExperience => 'Experience';

  @override
  String get astroSessions => 'Sessions';

  @override
  String get astroMinutes => 'Minutes';

  @override
  String get astroAbout => 'About';

  @override
  String get astroLanguages => 'Languages';

  @override
  String get astroRateCard => 'Rate Card';

  @override
  String get astroVoice => 'Voice';

  @override
  String astroReviews(int count) {
    return 'Reviews ($count)';
  }

  @override
  String get astroNoReviews => 'No reviews yet';

  @override
  String get astroAnonymous => 'Anonymous';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email and we\'ll send you\na link to reset your password.';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => 'Resend Link';

  @override
  String get appName => 'Nakshatralogy';

  @override
  String get cosmicJourneyAwaits => 'Your Cosmic Journey Awaits';

  @override
  String get home => 'Home';

  @override
  String get astrologers => 'Astrologers';

  @override
  String get services => 'Services';

  @override
  String get wallet => 'Wallet';

  @override
  String get profile => 'Profile';

  @override
  String get live => 'Live';

  @override
  String get kundli => 'Kundli';

  @override
  String get chat => 'Chat';

  @override
  String get call => 'Call';

  @override
  String get video => 'Video';

  @override
  String get signIn => 'Sign In';

  @override
  String get createAccount => 'Create Account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get phone => 'Phone';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get continueGoogle => 'Continue with Google';

  @override
  String get required => 'Required';

  @override
  String get minSixChars => 'Min 6 characters';

  @override
  String get passwordsMismatch => 'Passwords do not match';

  @override
  String get validEmailRequired => 'Valid email required';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get signupFailed => 'Signup failed';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get todaysHoroscope => 'TODAY\'S HOROSCOPE';

  @override
  String get todaysRashi => 'Today\'s Rashi';

  @override
  String get tapDetails => 'Tap for details';

  @override
  String get allServices => 'All Services';

  @override
  String get seeAll => 'SEE ALL';

  @override
  String get topAstrologers => 'Top Astrologers';

  @override
  String get onlineExperts => 'Online experts ready for consultation';

  @override
  String get searchAstrologers => 'Search astrologers...';

  @override
  String get noAstrologersFound => 'No astrologers found';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get busy => 'Busy';

  @override
  String get perMin => '/min';

  @override
  String get noCharts => 'No birth charts yet';

  @override
  String get createFirst => 'Create your first Janam Kundli';

  @override
  String get createChart => 'Create Chart';

  @override
  String get newBirthChart => 'New Birth Chart';

  @override
  String get clientName => 'Client Name';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get timeOfBirth => 'Time of Birth';

  @override
  String get birthPlace => 'Birth Place';

  @override
  String get birthPlaceHint => 'Type city name to search...';

  @override
  String get generateKundli => 'Generate Kundli';

  @override
  String get birthChartCreated => 'Birth chart created!';

  @override
  String get deleteChart => 'Delete Chart?';

  @override
  String get cannotUndo => 'This cannot be undone.';

  @override
  String get primary => 'PRIMARY';

  @override
  String get viewKundli => 'View Kundli';

  @override
  String get completeBirthChart => 'Complete Birth Chart';

  @override
  String get birthDetails => 'Birth Details';

  @override
  String get name => 'Name';

  @override
  String get dob => 'DOB';

  @override
  String get tob => 'TOB';

  @override
  String get place => 'Place';

  @override
  String get summary => 'Summary';

  @override
  String get planets => 'Planets';

  @override
  String get divisions => 'Divisions';

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
  String get aspects => 'Aspects';

  @override
  String get lifeAreas => 'Life Areas';

  @override
  String get bhava => 'Bhava';

  @override
  String get chakras => 'Chakras';

  @override
  String get dashaActive => 'Dasha Active';

  @override
  String get lagna => 'Lagna';

  @override
  String get moon => 'Moon';

  @override
  String get sun => 'Sun';

  @override
  String get premiumSection => 'Premium Section';

  @override
  String get unlockReading => 'Unlock this reading to view detailed analysis.';

  @override
  String get unlock => 'Unlock';

  @override
  String get retrograde => 'Retrograde';

  @override
  String get combust => 'Combust';

  @override
  String get vargottama => 'Vargottama';

  @override
  String get exalted => 'Exalted';

  @override
  String get debilitated => 'Debilitated';

  @override
  String get addBalance => 'Add Balance';

  @override
  String get amount => 'Amount';

  @override
  String get walletBalance => 'Wallet Balance';

  @override
  String get recharge => 'Recharge';

  @override
  String get bonus => 'Bonus';

  @override
  String get serviceLabel => 'Service';

  @override
  String get refund => 'Refund';

  @override
  String get noTransactions => 'No transactions';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get savedAstrologers => 'Saved Astrologers';

  @override
  String get noSavedAstrologers => 'No saved astrologers yet';

  @override
  String get myOrders => 'My Orders';

  @override
  String get communicationHistory => 'Communication History';

  @override
  String get chatHistory => 'Chat History';

  @override
  String get callHistory => 'Call History';

  @override
  String get logout => 'Logout';

  @override
  String get chatMessages => 'Chat Messages';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get sessionEnded => 'Session Ended';

  @override
  String get endChat => 'End Chat?';

  @override
  String get endChatConfirm =>
      'Are you sure you want to end this chat session?';

  @override
  String get sendPhoto => 'Send Photo';

  @override
  String get sendPDF => 'Send PDF';

  @override
  String get upload => 'Upload';

  @override
  String get fileNotFound => 'File not found';

  @override
  String get voiceCall => 'Voice Call';

  @override
  String get videoCall => 'Video Call';

  @override
  String get ringing => 'Ringing...';

  @override
  String get connected => 'CONNECTED';

  @override
  String get endCall => 'End Call';

  @override
  String get mute => 'Mute';

  @override
  String get unmute => 'Unmute';

  @override
  String get speaker => 'Speaker';

  @override
  String get camera => 'Camera';

  @override
  String get flip => 'Flip';

  @override
  String get liveStreams => 'Live Streams';

  @override
  String get noLiveStreams => 'No live streams right now';

  @override
  String get astrologerUnavailable =>
      'Astrologer not available. Ending stream.';

  @override
  String get streamEnded => 'Stream ended';

  @override
  String get superChat => 'Super Chat';

  @override
  String get sendGift => 'Send a Gift';

  @override
  String get goBack => 'Go Back';

  @override
  String get appPermissions => 'App Permissions';

  @override
  String get grantPermissions => 'Grant Permissions';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get microphone => 'Microphone';

  @override
  String get notifications => 'Notifications';

  @override
  String get storage => 'Storage';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Retry';

  @override
  String get send => 'Send';

  @override
  String get refresh => 'Refresh';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data available';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get myDetails => 'My Details';

  @override
  String get myKundlis => 'My Kundlis';

  @override
  String get walletRecharge => 'Wallet & Recharge';

  @override
  String get consultationHistory => 'Consultation History';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get biometricLogin => 'Biometric Login';

  @override
  String get pastVoiceConsultations => 'Past voice consultations';

  @override
  String get pastTextConversations => 'Past text conversations';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get totalCredit => 'Total Credit';

  @override
  String get totalDebit => 'Total Debit';

  @override
  String get statement => 'Statement';

  @override
  String get allTypes => 'All types';

  @override
  String get prev => 'Prev';

  @override
  String get next => 'Next';

  @override
  String get allInsights => 'All Insights';

  @override
  String get yourCompleteReading => 'YOUR COMPLETE READING';

  @override
  String get expertEngines => 'expert engines';

  @override
  String get eachInsightConsultation =>
      'Each insight is a complete consultation';

  @override
  String get engines => 'ENGINES';

  @override
  String get dataPoints => 'DATA POINTS';

  @override
  String get singleChart => 'SINGLE';

  @override
  String get careerPurpose => 'CAREER & PURPOSE';

  @override
  String get wealthAssets => 'WEALTH & ASSETS';

  @override
  String get loveRelationships => 'LOVE & RELATIONSHIPS';

  @override
  String get healthWellness => 'HEALTH & WELLNESS';

  @override
  String get soulKarma => 'SOUL & KARMA';

  @override
  String get specialistReports => 'Specialist Reports';

  @override
  String get searchByNameSpeciality => 'Search by name, speciality...';

  @override
  String get sortedByRating => 'Sorted by rating';

  @override
  String get initiatingChat => 'Initiating chat...';

  @override
  String get startingCall => 'Starting call...';

  @override
  String get yrs => 'yrs';

  @override
  String get chatWithAISpecialist => 'Chat with AI Specialist';

  @override
  String get tapToStart => 'Tap to start';

  @override
  String get astrologer => 'Astrologer';

  @override
  String get reports => 'Reports';

  @override
  String get milan => 'Milan';

  @override
  String get forecast => 'Forecast';

  @override
  String get rashi => 'Rashi';

  @override
  String get jupiterFavorsBold => 'Jupiter favors bold moves';

  @override
  String get careerIlluminated =>
      'Your career sector is illuminated — trust your instincts.';

  @override
  String get todaysForecast => 'Today\'s Forecast';

  @override
  String get engCareer => 'Career & Job';

  @override
  String get engBusiness => 'Business & Startup';

  @override
  String get engEducation => 'Education & Learning';

  @override
  String get engLifePath => 'Life Path & Luck';

  @override
  String get engWealth => 'Wealth & Finance';

  @override
  String get engDebt => 'Debt & Recovery';

  @override
  String get engProperty => 'Property & Assets';

  @override
  String get engLegal => 'Legal & Disputes';

  @override
  String get engLove => 'Love & Romance';

  @override
  String get engMarriage => 'Marriage & Family';

  @override
  String get engKundliMilan => 'Kundli Milan';

  @override
  String get engRelationship => 'Relationship Intel';

  @override
  String get engLoveCompat => 'Love Compatibility';

  @override
  String get engChildProb => 'Child Probability';

  @override
  String get engHealth => 'Health & Wellness';

  @override
  String get engMental => 'Mental & Stress';

  @override
  String get engCharacter => 'Character Analysis';

  @override
  String get engPastLife => 'Past Life & Karma';

  @override
  String get engKarmaLink => 'Karma Linkage';

  @override
  String get noChatSessions => 'No Chat Sessions Yet';

  @override
  String get chatAppearHere =>
      'Your conversations with astrologers will appear here.';

  @override
  String get noCallsYet => 'No Calls Yet';

  @override
  String get callAppearHere =>
      'Your call history with astrologers will appear here.';

  @override
  String get chatWith => 'Chat with';

  @override
  String get msgs => 'msgs';

  @override
  String get voiceCallLabel => 'Voice call';

  @override
  String get videoCallLabel => 'Video call';

  @override
  String get pullToRefresh => 'Pull down to refresh';

  @override
  String get sessionExpired => 'Session expired';

  @override
  String get connectionFailed => 'Connection failed';

  @override
  String get callActive => 'Call active';

  @override
  String get lessThanOneMin => 'Less than 1 minute remaining';

  @override
  String get noMessages => 'No messages in this session';

  @override
  String get gocharForAllSigns => 'Today\'s gochar for all 12 signs';

  @override
  String get selectChart => 'Select a chart to analyze';

  @override
  String get selectTwoCharts => 'Select two charts';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get browseAstrologers => 'Browse Astrologers';

  @override
  String get probableNumber => 'PROBABLE NUMBER';

  @override
  String get genderTendency => 'GENDER TENDENCY';

  @override
  String get son => 'SON';

  @override
  String get daughter => 'DAUGHTER';

  @override
  String get occupants => 'OCCUPANTS';

  @override
  String get beneficAspects => 'BENEFIC ASPECTS';

  @override
  String get maleficAspects => 'MALEFIC ASPECTS';

  @override
  String get nextFavorableWindow => 'NEXT FAVORABLE WINDOW';

  @override
  String get totalDoshaPenalty => 'TOTAL DOSHA PENALTY';

  @override
  String get cancellationFactors => 'CANCELLATION FACTORS';

  @override
  String get combinedFertility => 'COMBINED FERTILITY INDICATION';

  @override
  String get planetPositions => 'PLANET POSITIONS';

  @override
  String get bestWindows => 'BEST WINDOWS';

  @override
  String get worstWindows => 'WORST WINDOWS';

  @override
  String get scoreComponents => 'SCORE COMPONENTS';

  @override
  String get topOpportunities => 'TOP OPPORTUNITIES';

  @override
  String get topRisks => 'TOP RISKS';

  @override
  String get remedies => 'REMEDIES';

  @override
  String get keyInsights => 'KEY INSIGHTS';

  @override
  String get overallVerdict => 'OVERALL VERDICT';

  @override
  String get venusContacts => 'VENUS CROSS CONTACTS';

  @override
  String get contact => 'Contact';

  @override
  String get effect => 'Effect';

  @override
  String get moonSignCompat => 'MOON SIGN COMPATIBILITY';

  @override
  String get hisMoon => 'HIS MOON';

  @override
  String get herMoon => 'HER MOON';

  @override
  String get nakshatraCompat => 'NAKSHATRA COMPATIBILITY';

  @override
  String get ketuContacts => 'KETU CONTACTS';

  @override
  String get rahuContacts => 'RAHU CONTACTS';

  @override
  String get pastLifeIndication => 'PAST LIFE INDICATION';

  @override
  String get totalChallengePenalty => 'TOTAL CHALLENGE PENALTY';

  @override
  String get manifestation => 'MANIFESTATION';

  @override
  String get cancellation => 'CANCELLATION';

  @override
  String get navigation => 'NAVIGATION';

  @override
  String get potentialStrengths => 'POTENTIAL STRENGTHS';

  @override
  String get areasToNurture => 'AREAS TO NURTURE';

  @override
  String get relationshipGuidance => 'RELATIONSHIP GUIDANCE';

  @override
  String get detailedSummary => 'DETAILED SUMMARY';

  @override
  String get discussWithAI => 'DISCUSS WITH AI';

  @override
  String get planet => 'Planet';

  @override
  String get sign => 'Sign';

  @override
  String get house => 'House';

  @override
  String get strength => 'Strength';

  @override
  String get copy => 'COPY';

  @override
  String get confidence => 'CONFIDENCE';

  @override
  String get d7Saptamsa => 'D7 SAPTAMSA';

  @override
  String get numberExplanation => 'NUMBER EXPLANATION';

  @override
  String get genderExplanation => 'GENDER EXPLANATION';

  @override
  String get inFifth => 'In 5th?';

  @override
  String get primaryArchetype => 'PRIMARY ARCHETYPE';

  @override
  String get mitigation => 'MITIGATION';

  @override
  String get soulCareerAlign => 'Soul ↔ Career Alignment';

  @override
  String get favorablePeriods => 'Favorable Periods';

  @override
  String get challengingPeriods => 'Challenging Periods';

  @override
  String get keyHouses => 'Key Houses';

  @override
  String get keyPlanets => 'Key Planets';

  @override
  String get characterOverview => 'Character Overview';

  @override
  String get noYogasActive => 'No yogas currently active in this chart.';

  @override
  String get basedOnPlanetStrengths =>
      'Based on planetary strengths & house placements';

  @override
  String get basedOnTransits => 'Based on current planetary transits';

  @override
  String get currentPlanetPositions =>
      'Current planet positions with your sign as house 1';

  @override
  String get favorablePeriodAdvice =>
      'Favorable period — focus on career growth and relationships.';

  @override
  String get noClassicalYogas =>
      'Without classical learning yogas, success comes from consistent effort.';

  @override
  String get walletDeduction => 'Amount will be deducted from your wallet';

  @override
  String get bhakootAxis => 'BHAKOOT AXIS';

  @override
  String get basis => 'BASIS';

  @override
  String get selectChartsForMilan => 'Select 2 Charts for Milan Analysis';

  @override
  String get selectMultiCharts => 'Select 2–5 Charts';

  @override
  String get running => 'RUNNING';

  @override
  String get past => 'past';

  @override
  String get topActiveDoshas => 'TOP ACTIVE DOSHAS';

  @override
  String get allDoshas => 'ALL DOSHAS';

  @override
  String get activeYogas => 'Active Yogas';

  @override
  String get activeDoshas => 'Active Doshas';

  @override
  String get yogaAnalysis => 'Yoga Analysis';

  @override
  String get factors => 'Factors';

  @override
  String get dominantPlanet => 'Dominant Planet';

  @override
  String get startSession => 'Start Session';

  @override
  String get notesSaved => 'Notes saved';

  @override
  String get unlocked => 'Unlocked! Enjoy your reading.';

  @override
  String get todaysGochar => 'Today\'s Gochar';

  @override
  String get todaysTransitChart => 'Today\'s Transit Chart';

  @override
  String get lifeAreaPredictions => 'Life Area Predictions';

  @override
  String get strengths => 'Strengths';

  @override
  String get weaknesses => 'Weaknesses';

  @override
  String get ruledBy => 'Ruled by';

  @override
  String get kundliMilan => 'Kundli Milan';

  @override
  String get startKundliMilan => 'Start Kundli Milan';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get cancellations => 'Cancellations';

  @override
  String get dashaSync => 'Dasha Sync';

  @override
  String get transitMarriageWindows => 'Transit Marriage Windows';

  @override
  String get overlappingWindows => 'Overlapping Marriage Windows';

  @override
  String get overallStrength => 'OVERALL STRENGTH';

  @override
  String get stability => 'STABILITY';

  @override
  String get growth => 'GROWTH';

  @override
  String get clarity => 'CLARITY';

  @override
  String get recognition => 'RECOGNITION';

  @override
  String get satisfaction => 'SATISFACTION';

  @override
  String get verdict => 'VERDICT';

  @override
  String get topRoles => 'TOP ROLES';

  @override
  String get areasForGrowth => 'AREAS FOR GROWTH';

  @override
  String get bestIndustries => 'BEST INDUSTRIES';

  @override
  String get employment => 'Employment';

  @override
  String get entrepreneurship => 'Entrepreneurship';

  @override
  String get freelance => 'Freelance';

  @override
  String get portfolio => 'Portfolio';

  @override
  String get burnoutRisk => 'Burnout Risk';

  @override
  String get careerStagnation => 'Career Stagnation';

  @override
  String get workplaceConflict => 'Workplace Conflict';

  @override
  String get positioning => 'POSITIONING';

  @override
  String get skillDevelopment => 'SKILL DEVELOPMENT';

  @override
  String get network => 'NETWORK';

  @override
  String get visibility => 'VISIBILITY';

  @override
  String get lagnaLord => 'Lagna Lord';

  @override
  String get tenthLord => '10th Lord';

  @override
  String get lord => 'LORD';

  @override
  String get lordPlacedIn => 'LORD PLACED IN';

  @override
  String get lordDignity => 'LORD DIGNITY';

  @override
  String get d9Dignity => 'D9 DIGNITY';

  @override
  String get careerAnalysis => 'Career Analysis';

  @override
  String get launchWindows => 'Launch Windows';

  @override
  String get peakWindows => 'Peak Windows';

  @override
  String get promotionWindows => 'Promotion Windows';

  @override
  String get riskWindows => 'Risk Windows';

  @override
  String get timingWindows => 'Timing Windows';

  @override
  String get careerRisks => 'Career Risks';

  @override
  String get astrologicalRemedies => 'Astrological Remedies';

  @override
  String get practicalSolutions => 'Practical Solutions';

  @override
  String get analysisConfidence => 'Analysis Confidence';

  @override
  String get careerArchetype => 'Career Archetype';

  @override
  String get workStructure => 'Work Structure';

  @override
  String get teamLeadership => 'Team Leadership';

  @override
  String get idealEnvironment => 'Ideal Environment';

  @override
  String get idealOrgSize => 'Ideal Org Size';

  @override
  String get fitScore => 'FIT SCORE';

  @override
  String get recommended => 'RECOMMENDED';

  @override
  String get divisionalValidation => 'Divisional Validation';

  @override
  String get houseAnalysis => 'House Analysis';

  @override
  String get jaiminiKarakas => 'Jaimini Karakas';

  @override
  String get copyFullReport => 'Copy full report data';

  @override
  String get reportCopied => 'Report data copied!';

  @override
  String get biometricNotAvailable => 'Biometric not available on this device';

  @override
  String biometricErrorMsg(Object error) {
    return 'Biometric error: $error';
  }

  @override
  String get biometricVerifyReason => 'Verify to enable biometric login';

  @override
  String get dobFormatLabel => 'DOB (DD/MM/YYYY)';

  @override
  String get tobFormatLabel => 'TOB (HH:MM)';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get activeBadge => 'ACTIVE';

  @override
  String get chartCategoryLabel => 'Category';

  @override
  String get freePrimaryDescription =>
      'Free Primary — used for daily horoscope & free single-chart services';

  @override
  String get searchChartsHint => 'Search by name or birth date...';

  @override
  String unlockPriceLabel(Object price) {
    return 'Unlock $price';
  }

  @override
  String unlockAiSpecialistIntl(Object price) {
    return 'Unlock this AI specialist for $price (one time), purchased securely through the app store.';
  }

  @override
  String unlockAiSpecialistWallet(Object price) {
    return 'Unlock this AI specialist for $price (one time). The amount is deducted from your wallet.';
  }

  @override
  String get specialistNotAvailablePurchase =>
      'This specialist is not available for purchase yet.';

  @override
  String get couldNotCompletePurchase =>
      'Could not complete the purchase. Please try again.';

  @override
  String get couldNotUnlockWalletBalance =>
      'Could not unlock (check wallet balance)';

  @override
  String get freeBadge => 'FREE';

  @override
  String activeSessionInProgress(Object kind) {
    return 'You have an active $kind in progress';
  }

  @override
  String get returnLabel => 'Return';

  @override
  String get enableNotificationsForAlerts =>
      'Enable notifications to get consultation & offer alerts';

  @override
  String get enableLabel => 'Enable';

  @override
  String get notificationsEnabled => 'Notifications enabled';

  @override
  String get couldNotEnableNotifications =>
      'Could not enable — allow notifications in your browser';

  @override
  String get amountInrLabel => 'Amount (₹)';

  @override
  String get noteOptionalLabel => 'Note (optional)';

  @override
  String get txnDate => 'DATE';

  @override
  String get txnDescription => 'DESCRIPTION';

  @override
  String get txnType => 'TYPE';

  @override
  String get txnAmount => 'AMOUNT';

  @override
  String get txnBalance => 'BALANCE';

  @override
  String get credit => 'Credit';

  @override
  String get debit => 'Debit';

  @override
  String get razorpayStripeNote =>
      '💳 In production this will redirect to Razorpay/Stripe.';

  @override
  String get downloadPdf => 'Download PDF';

  @override
  String get chatWithAiCta => 'Chat with AI';

  @override
  String get pdfServiceUnavailable =>
      'PDF service is temporarily unavailable. Please try again later.';

  @override
  String get pleaseUnlockFirst => 'Please unlock this first.';

  @override
  String get couldNotGeneratePdf =>
      'Could not generate the PDF. Please try again.';

  @override
  String get statConsults => 'CONSULTS';

  @override
  String get statCharts => 'CHARTS';

  @override
  String get statWallet => 'WALLET';

  @override
  String get firstChartPrimaryInfo =>
      'Your first chart is your free Primary. Extra charts unlock services individually.';

  @override
  String get tryDifferentFilter => 'Try a different filter';

  @override
  String get defaultChartName => 'Chart';

  @override
  String get balAbbr => 'Bal';

  @override
  String get aiTimePassTitle => 'Choose your chat time';

  @override
  String get aiTimePassHint =>
      'Paid from your wallet. Time starts now — buying again adds to any time you have left.';

  @override
  String aiTimePlanMinutes(Object minutes) {
    return '$minutes min';
  }

  @override
  String aiTimePassPay(Object price) {
    return 'Pay $price';
  }

  @override
  String aiTimeLeft(Object minutes) {
    return '$minutes min left';
  }
}
