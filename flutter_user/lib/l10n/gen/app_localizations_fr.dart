// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get awChooseLanguage => 'Choisissez votre langue';

  @override
  String get awGoogleFailed =>
      'Échec de la connexion Google. Veuillez réessayer.';

  @override
  String get awCompleteProfileTitle => 'Complétez votre profil';

  @override
  String awWelcomeName(String name) {
    return 'Bienvenue, $name !';
  }

  @override
  String get awCompleteProfileSubtitle =>
      'Quelques détails pour personnaliser Nakshatralogy pour vous.';

  @override
  String get awRegionLabel => 'Région';

  @override
  String get awRegionIndia => 'Inde';

  @override
  String get awRegionInternational => 'International';

  @override
  String get awPreferredLanguage => 'Langue préférée';

  @override
  String get awFinishSetup => 'Terminer la configuration';

  @override
  String get awChatFileWebUnsupported =>
      'Le partage de fichiers n\'est pas encore disponible sur le web. Veuillez utiliser l\'application mobile.';

  @override
  String get awVideoUnsupported =>
      'Les appels vidéo ne sont pas pris en charge dans ce navigateur. Veuillez utiliser notre application mobile ou un navigateur de bureau compatible.';

  @override
  String get awClose => 'Fermer';

  @override
  String get pwPremiumTitle => 'Rapport Premium';

  @override
  String get pwLockedSubtitle => 'Débloquez l\'analyse complète de ce thème';

  @override
  String pwUnlockFull(Object name) {
    return 'Débloquer l\'intégralité de $name';
  }

  @override
  String pwUnlockPrice(Object price) {
    return 'Débloquer · $price';
  }

  @override
  String get pwOneTime =>
      'Déblocage unique — à vous pour toujours sur ce thème';

  @override
  String get pwWhatYouGet => 'Ce que vous obtenez';

  @override
  String get pwYourBalance => 'Solde de votre portefeuille';

  @override
  String get pwInsufficient => 'Solde insuffisant';

  @override
  String get pwRechargeToUnlock => 'Rechargez pour débloquer';

  @override
  String get pwRechargeAmount => 'Montant de recharge (₹)';

  @override
  String get pwAddMoney => 'Ajouter de l\'argent';

  @override
  String get pwRechargeDone => 'Portefeuille rechargé';

  @override
  String get pwRechargeFailed => 'Échec de la recharge. Veuillez réessayer.';

  @override
  String get pwUnlockFailed => 'Impossible de débloquer. Veuillez réessayer.';

  @override
  String get pwUnlockedNow => 'Débloqué ! Chargement de votre rapport…';

  @override
  String get pwProcessing => 'Traitement en cours…';

  @override
  String get pwPrimaryNoDelete =>
      'Votre Kundli principal ne peut pas être supprimé — il est gratuit à vie.';

  @override
  String get pwPrimaryNoEdit =>
      'Votre Kundli principal ne peut pas être modifié.';

  @override
  String get pwLoadingAccess => 'Vérification de l\'accès…';

  @override
  String get pwMaybeLater => 'Plus tard';

  @override
  String get updatePhoto => 'Mettre à jour la photo';

  @override
  String get takePhoto => 'Appareil photo';

  @override
  String get chooseFromGallery => 'Galerie';

  @override
  String get removePhoto => 'Supprimer la photo';

  @override
  String get photoUpdated => 'Photo mise à jour';

  @override
  String get photoUploadFailed =>
      'Impossible de télécharger la photo. Veuillez réessayer.';

  @override
  String get tapToChangePhoto => 'Appuyez pour changer la photo';

  @override
  String get klSubtitle =>
      'Rapport védique de liaison karmique des vies antérieures propulsé par l\'IA';

  @override
  String get klTitle => 'Liaison karmique des vies antérieures';

  @override
  String get klSnapshotHeader => 'Aperçu de la liaison karmique';

  @override
  String get klGaugePairwise => 'Liaison moyenne par paire';

  @override
  String get klGaugeCohesion => 'Cohésion du groupe';

  @override
  String get klGaugeRahuKetu => 'Résonance Rahu-Ketu';

  @override
  String get klGaugeAtmakaraka => 'Résonance de l\'âme';

  @override
  String get klGaugeD60 => 'Résonance D60';

  @override
  String get klChipSoulResonance => 'Forte résonance de la signature de l\'âme';

  @override
  String get klChipD60Resonance => 'Forte résonance D60 des vies antérieures';

  @override
  String get klChipCohesiveGroup => 'Groupe cohésif';

  @override
  String get klChipNoDebts => 'Aucune dette karmique détectée';

  @override
  String get klProfilesTitle => 'Profils des thèmes';

  @override
  String get klKetuAt => 'Ketu en';

  @override
  String get klRahuAt => 'Rahu en';

  @override
  String get klFoundationTitle => 'Fondation karmique par thème';

  @override
  String get klFoundationSubtitle =>
      'La maîtrise des vies antérieures et l\'orientation de la vie actuelle de chaque âme';

  @override
  String get klKetuMastery => 'Maîtrise de Ketu';

  @override
  String get klRahuGrowth => 'Croissance de Rahu';

  @override
  String get klNinthHousePunya => 'Punya de la 9ème maison';

  @override
  String get klD60Depth => 'Profondeur karmique D60';

  @override
  String get klAtmakarakaAgenda => 'Agenda de l\'âme';

  @override
  String get klSaturnKarma => 'Karma de Saturne';

  @override
  String get klPairwiseTitle => 'Liaisons karmiques par paire';

  @override
  String get klActiveFactors => 'Facteurs de liaison actifs';

  @override
  String get klGroupPatternTitle => 'Schéma karmique du groupe';

  @override
  String get klSharedSetting => 'Cadre partagé des vies antérieures';

  @override
  String get klCohesionScore => 'Cohésion karmique';

  @override
  String get klPastGoalsTitle => 'Objectifs des vies antérieures';

  @override
  String get klLearningTitle => 'Apprentissage de la vie actuelle';

  @override
  String get klTeachingMap => 'Carte d\'enseignement mutuel';

  @override
  String get klDebtsTitle => 'Dettes karmiques et résolutions';

  @override
  String get klNoDebtsDetected =>
      'Aucune dette karmique détectée dans ce groupe';

  @override
  String get klTimingTitle => 'Timing karmique de la Moola Dasha';

  @override
  String get klAuditTitle => 'Tableau d\'audit approfondi';

  @override
  String klAuditSubtitle(Object count) {
    return '$count paramètres karmiques examinés';
  }

  @override
  String get klTopicLinkage => 'Notre liaison karmique globale';

  @override
  String get klTopicPairwise => 'Le lien karmique d\'une paire spécifique';

  @override
  String get klTopicDebts => 'Dettes karmiques à résoudre';

  @override
  String get klTopicLessons => 'Ce que nous devons apprendre';

  @override
  String get klTopicTiming => 'Meilleur timing pour notre groupe';

  @override
  String get klTopicGroup => 'Notre histoire commune de vies antérieures';

  @override
  String get lcSubtitle =>
      'Rapport védique de compatibilité amoureuse propulsé par l\'IA';

  @override
  String get lcTitle => 'Compatibilité amoureuse';

  @override
  String get lcSnapshotHeader => 'Aperçu de la compatibilité amoureuse';

  @override
  String get lcGaugeAttraction => 'Attirance';

  @override
  String get lcGaugeEmotional => 'Harmonie émotionnelle';

  @override
  String get lcGaugeMental => 'Rapport mental';

  @override
  String get lcGaugePassion => 'Passion';

  @override
  String get lcGaugeLongterm => 'Harmonie à long terme';

  @override
  String get lcChipStrongMental => 'Forte connexion mentale';

  @override
  String get lcChipStrongLongterm => 'Fort potentiel à long terme';

  @override
  String get lcChipStrongPassion => 'Forte alchimie physique';

  @override
  String get lcChipLowFriction => 'Peu de friction globale';

  @override
  String get lcChipKarmicPull => 'Forte attraction karmique';

  @override
  String get lcPartnersTitle => 'Aperçu des partenaires';

  @override
  String get lcVenusSuffix => 'Signe de Vénus';

  @override
  String get lcAttractionTitle => 'Attirance et alchimie';

  @override
  String get lcAttractionScore => 'Score d\'attirance';

  @override
  String get lcActiveContacts => 'Contacts actifs de Vénus';

  @override
  String get lcEmotionalTitle => 'Harmonie émotionnelle';

  @override
  String get lcEmotionalScore => 'Score d\'harmonie émotionnelle';

  @override
  String get lcNakshatraCompat => 'Compatibilité des Nakshatras';

  @override
  String get lcYoniKoota => 'Yoni Koota';

  @override
  String get lcGanaKoota => 'Gana Koota';

  @override
  String get lcTaraKoota => 'Tara Koota';

  @override
  String get lcBhakootAxis => 'Axe Bhakoot';

  @override
  String get lcMentalTitle => 'Rapport mental';

  @override
  String get lcMentalScore => 'Score de rapport mental';

  @override
  String get lcPassionTitle => 'Passion et physique';

  @override
  String get lcPassionScore => 'Score de passion';

  @override
  String get lcLongtermTitle => 'Harmonie à long terme';

  @override
  String get lcLongtermScore => 'Score d\'harmonie à long terme';

  @override
  String get lcCommitmentPotential => 'Potentiel d\'engagement';

  @override
  String get lc7thHouseSynastry => 'Synastrie de la 7ème maison';

  @override
  String get lcJupiterBlessing => 'Bénédiction de Jupiter';

  @override
  String get lcD9Resonance => 'Résonance D9 Navamsa';

  @override
  String get lcSaturnLongevity => 'Longévité de Saturne';

  @override
  String get lcKarmicTitle => 'Lien amoureux karmique';

  @override
  String get lcKarmicScore => 'Score de lien karmique';

  @override
  String get lcKetuContacts => 'Contacts de Ketu';

  @override
  String get lcRahuContacts => 'Contacts de Rahu';

  @override
  String get lcChallengesTitle => 'Défis et frictions';

  @override
  String get lcNoChallenges =>
      'Aucun point de friction significatif détecté dans l\'un ou l\'autre thème';

  @override
  String get lcTotalPenalty => 'Pénalité totale de défi';

  @override
  String get lcTimingTitle => 'Timing amoureux — Moola Dasha';

  @override
  String get lcDynamicsTitle => 'Dynamique de la relation';

  @override
  String get lcPowerBalance => 'Équilibre du pouvoir';

  @override
  String get lcGiverReceiver => 'Donneur/receveur émotionnel';

  @override
  String get lcGrowthDynamic => 'Dynamique de croissance';

  @override
  String get lcAreasToNurture => 'Domaines à cultiver';

  @override
  String get lcTopicTiming => 'Meilleur timing pour notre relation';

  @override
  String get lcTopicChallenges => 'Défis à surmonter';

  @override
  String get lcTopicKarmic => 'Notre connexion karmique';

  @override
  String get lcTopicRemedies => 'Remèdes recommandés';

  @override
  String get lcTopicLongterm => 'Notre potentiel à long terme';

  @override
  String get lcTopicDynamics => 'La dynamique de notre relation';

  @override
  String get cpSubtitle =>
      'Rapport védique de probabilité d\'enfant propulsé par l\'IA';

  @override
  String get cpTitle => 'Probabilité d\'enfant';

  @override
  String get cpSnapshotHeader => 'Aperçu de la probabilité de progéniture';

  @override
  String get cpGauge5thHouse => '5ème maison';

  @override
  String get cpGaugeJupiter => 'Jupiter/Putrakaraka';

  @override
  String get cpGaugeD7 => 'D7 Saptamsa';

  @override
  String get cpGaugeSphuta => 'Beeja-Kshetra';

  @override
  String get cpGaugeTiming => 'Timing de la Dasha';

  @override
  String get cpChipStrongPutrakaraka => 'Putrakaraka fort (Jupiter)';

  @override
  String get cpChipLowDoshaPenalty => 'Faible pénalité de dosha';

  @override
  String get cpChipFavorableTiming => 'Timing de dasha favorable';

  @override
  String get cpChipNoDoshas => 'Aucun dosha de progéniture détecté';

  @override
  String get cpPartnersTitle => 'Aperçu des partenaires';

  @override
  String get cpLagnaSuffix => 'Lagna';

  @override
  String get cpMoonSuffix => 'Signe lunaire';

  @override
  String get cpNumberTitle => 'Nombre d\'enfants et tendance de genre';

  @override
  String get cpProbableNumber => 'Nombre probable';

  @override
  String get cpFirstChildTendency => 'Tendance pour le premier enfant';

  @override
  String get cpSpacing => 'Note sur l\'espacement';

  @override
  String get cpTimingTitle => 'Timing — Moola Dasha';

  @override
  String get cpCombinedTiming => 'Timing combiné';

  @override
  String get cpNextWindow => 'Prochaine fenêtre favorable';

  @override
  String get cp5thHouseTitle => 'Analyse de la 5ème maison';

  @override
  String get cp5thHouseSubtitle =>
      'La maison des enfants (Putra Bhava), par personne';

  @override
  String get cpJupiterTitle => 'Jupiter — Analyse du Putrakaraka';

  @override
  String get cpJupiterSubtitle =>
      'Le significateur naturel des enfants, par personne';

  @override
  String get cpD7Title => 'Analyse D7 Saptamsa';

  @override
  String get cpD7Subtitle => 'Le thème divisionnaire spécifique aux enfants';

  @override
  String get cpD7Strength => 'Force du D7';

  @override
  String get cpSphutaTitle => 'Beeja et Kshetra Sphuta';

  @override
  String get cpBeejaSphuta => 'Beeja Sphuta (Graine)';

  @override
  String get cpKshetraSphuta => 'Kshetra Sphuta (Champ)';

  @override
  String get cpDoshaTitle => 'Analyse des Doshas';

  @override
  String get cpNoDoshasDetected =>
      'Aucun dosha lié à la progéniture détecté dans l\'un ou l\'autre thème';

  @override
  String get cpRemediesTitle => 'Remèdes recommandés';

  @override
  String get cpAddresses => 'Concerne';

  @override
  String get cpTopicTiming => 'Meilleur moment pour concevoir';

  @override
  String get cpTopicNumber => 'Combien d\'enfants nous pourrions avoir';

  @override
  String get cpTopicDosha => 'Doshas éventuels à traiter';

  @override
  String get cpTopicRemedies => 'Remèdes recommandés';

  @override
  String get cpTopicFifthHouse => 'La force de notre 5ème maison';

  @override
  String get cpTopicJupiter => 'Le rôle de Jupiter dans ce domaine';

  @override
  String get riSubtitle =>
      'Rapport védique d\'intelligence relationnelle propulsé par l\'IA';

  @override
  String get riTitle => 'Intelligence relationnelle';

  @override
  String get riSnapshotHeader => 'Aperçu du groupe';

  @override
  String get riGaugeCohesion => 'Cohésion du groupe';

  @override
  String get riGaugeTrust => 'Climat de confiance';

  @override
  String get riGaugeProductivity => 'Productivité';

  @override
  String get riGaugeCreativity => 'Créativité';

  @override
  String get riChipNoAlerts => 'Aucune alerte critique';

  @override
  String get riChipStrongCohesion => 'Forte cohésion de groupe';

  @override
  String get riChipHighTrust => 'Climat de confiance élevé';

  @override
  String get riChipNoHiddenEnemy => 'Aucun signal d\'ennemi caché';

  @override
  String get riChipHealthyGroup => 'Groupe globalement sain';

  @override
  String get riProfilesTitle => 'Profils des thèmes';

  @override
  String riProfilesSubtitle(Object count) {
    return '$count personnes dans ce groupe';
  }

  @override
  String get riLagnaSuffix => 'Lagna';

  @override
  String get riIntegrity => 'Intégrité';

  @override
  String get riWarmth => 'Chaleur';

  @override
  String get riTrustworthiness => 'Fiabilité';

  @override
  String get riAssertiveness => 'Assurance';

  @override
  String get riGroupDynamicsTitle => 'Aperçu de la dynamique de groupe';

  @override
  String get riMostSupportive => 'Le plus solidaire';

  @override
  String get riMostChallenged => 'Le plus mis à l\'épreuve';

  @override
  String get riHiddenEnemyAlert => 'Signal d\'ennemi caché détecté';

  @override
  String get riBestWorstTitle =>
      'Meilleures paires et paires les plus difficiles';

  @override
  String get riBestPair => 'LIEN LE PLUS FORT';

  @override
  String get riWorstPair => 'NÉCESSITE DE L\'ATTENTION';

  @override
  String get riAlliances => 'Alliances probables';

  @override
  String get riConflicts => 'Points de friction probables';

  @override
  String get riPairwiseTitle => 'Analyse par paire';

  @override
  String riPairwiseSubtitle(Object count) {
    return '$count paires analysées';
  }

  @override
  String get riDynamic => 'Dynamique';

  @override
  String get riKarmicLink => 'Lien karmique';

  @override
  String get riMutualTrust => 'Confiance mutuelle';

  @override
  String get riBetrayalRisk => 'Risque de trahison';

  @override
  String get riPowerDistribution => 'Répartition du pouvoir';

  @override
  String get riPowerHealth => 'Santé de l\'équilibre du pouvoir';

  @override
  String get riCriticalPatternsTitle => 'Schémas critiques';

  @override
  String get riGroupRecsTitle => 'Recommandations pour le groupe';

  @override
  String get riSharedPractices => 'Pratiques partagées';

  @override
  String get riCommStyle => 'Style de communication recommandé';

  @override
  String get riGrowthFocus => 'Axe de croissance recommandé';

  @override
  String get riIndividualTitle => 'Conseils individuels';

  @override
  String get riBestAllies => 'Meilleurs alliés';

  @override
  String get riHandleWithCare => 'À traiter avec précaution';

  @override
  String get riCoreThemeTitle => 'Thème central du groupe';

  @override
  String get riLayerPairwise => 'Exhaustivité par paire';

  @override
  String get riLayerD1 => 'Thème de naissance (D1)';

  @override
  String get riLayerD9 => 'Navamsa (D9)';

  @override
  String get riLayerD10 => 'Dashamsa (D10)';

  @override
  String get riLayerD30 => 'Trimshamsa (D30)';

  @override
  String get riLayerJaimini => 'Signal Jaimini';

  @override
  String get riLayerBehavior => 'Clarté comportementale';

  @override
  String get riLayerCoherence => 'Cohérence du groupe';

  @override
  String get riTopicDynamics => 'La dynamique de notre groupe';

  @override
  String get riTopicPairwise => 'La compatibilité d\'une paire spécifique';

  @override
  String get riTopicAlerts => 'Alertes critiques éventuelles';

  @override
  String get riTopicGrowth => 'Comment nous pouvons grandir ensemble';

  @override
  String get riTopicRecs => 'Pratiques recommandées';

  @override
  String get riTopicTheme => 'Le thème central de notre groupe';

  @override
  String get kmSubtitle => 'Rapport védique de Kundli Milan propulsé par l\'IA';

  @override
  String get kmTitle => 'Kundli Milan';

  @override
  String get kmSnapshotHeader => 'Aperçu de la compatibilité';

  @override
  String kmAshtakootScore(Object score) {
    return 'Ashtakoot : $score/36';
  }

  @override
  String get kmGaugeAshtakoot => 'Ashtakoot %';

  @override
  String get kmGaugeD9 => 'Karma matrimonial D9';

  @override
  String get kmGaugeMangal => 'Équilibre Mangal';

  @override
  String get kmGaugePapa => 'Équilibre karmique';

  @override
  String get kmGaugeAk => 'Résonance de l\'âme';

  @override
  String get kmChipNoNadi => 'Aucun Nadi Dosh';

  @override
  String get kmChipNoBhakoot => 'Aucun Bhakoot Dosh';

  @override
  String get kmChipMangalCancelled => 'Mangal Dosh annulé';

  @override
  String get kmChipPapaBalanced => 'Charge karmique équilibrée';

  @override
  String get kmChipStrongChemistry => 'Forte alchimie physique';

  @override
  String get kmChipStrongD9 => 'Fort karma matrimonial D9';

  @override
  String get kmChipLongevity => 'Fort alignement de longévité';

  @override
  String get kmAshtakootTitle => 'Ashtakoot Guna Milan';

  @override
  String get kmAshtakootSubtitle =>
      'Le système classique de correspondance à 8 points, sur 36';

  @override
  String get kmNadiSeverity => 'Sévérité du Nadi';

  @override
  String get kmBhakootSeverity => 'Sévérité du Bhakoot';

  @override
  String get kmGanaSignature => 'Signature du Gana';

  @override
  String get kmMangalTitle => 'Vérification du Mangal Dosha';

  @override
  String get kmD9Title => 'D9 Navamsa — Karma matrimonial';

  @override
  String get kmD9Subtitle =>
      'Le thème matrimonial au niveau de l\'âme, considéré classiquement comme le plus important';

  @override
  String get kmD9Score => 'Compatibilité D9';

  @override
  String get kmLagnaRelation => 'Relation entre Lagnas';

  @override
  String get km7thLordRelation => 'Relation entre maîtres de la 7ème maison';

  @override
  String get kmKarakasTitle => 'Karakas de l\'âme et du conjoint';

  @override
  String get kmAtmakaraka => 'Planète de l\'âme';

  @override
  String get kmAkCompatibility => 'Résonance de la signature de l\'âme';

  @override
  String get kmUlCompatibility => 'Alignement du Karaka du conjoint';

  @override
  String get kmUlSigns => 'Maîtres de l\'Upapada';

  @override
  String get kmChemistryTitle => 'Alchimie Vénus-Mars';

  @override
  String get kmPhysicalChemistry => 'Alchimie physique';

  @override
  String get kmEmotionalWarmth => 'Chaleur émotionnelle';

  @override
  String get kmAestheticAlignment => 'Alignement esthétique';

  @override
  String get kmElementalSynthesis => 'Synthèse élémentaire';

  @override
  String get kmHouseCrossTitle => 'Analyse croisée des 7ème et 8ème maisons';

  @override
  String get km78Compatibility => 'Compatibilité des 7ème-8ème maisons';

  @override
  String get km8thHouseSignature => 'Signature de longévité conjointe';

  @override
  String get kmLongevityAlignment => 'Alignement de longévité';

  @override
  String get km7thLordFriendship => 'Amitié entre maîtres de la 7ème maison';

  @override
  String get kmDomainsTitle => 'Compatibilité domaine par domaine';

  @override
  String get kmConflictEngagement => 'Style de gestion des conflits';

  @override
  String get kmDashaTitle => 'Synchronisation Dasha et transits';

  @override
  String get kmDashaSync => 'Synchronisation des Dashas';

  @override
  String get kmTransitAlignment => 'Alignement des transits';

  @override
  String get kmTimingTitle => 'Timing du mariage';

  @override
  String get kmMarriageWindow => 'Fenêtre de mariage';

  @override
  String get kmEngagementWindow => 'Fenêtre de fiançailles';

  @override
  String get kmRecommendedRange => 'Période recommandée';

  @override
  String get kmMuhurtaNotes => 'Notes sur le Muhurta';

  @override
  String get kmRisksTitle => 'Risques à traiter';

  @override
  String get kmConflictRisk => 'Risque de conflit';

  @override
  String get kmCommunicationRisk => 'Risque de communication';

  @override
  String get kmFinanceRisk => 'Risque de conflit financier';

  @override
  String get kmFamilyDynamicsRisk => 'Risque lié à la dynamique familiale';

  @override
  String get kmMentalHealthRisk => 'Risque d\'alignement en santé mentale';

  @override
  String get kmStrengthsTitle => 'Principaux points forts de compatibilité';

  @override
  String get kmSharedGrowth => 'Potentiel de croissance partagé';

  @override
  String get kmSharedCreative => 'Potentiel créatif partagé';

  @override
  String get kmJourneyTitle => 'Parcours et croissance de la relation';

  @override
  String get kmCurrentPhase => 'Phase actuelle';

  @override
  String get kmEarlyArc => 'Début du mariage';

  @override
  String get kmMiddleArc => 'Milieu du mariage';

  @override
  String get kmMatureArc => 'Mariage mature';

  @override
  String get kmElderArc => 'Années avancées';

  @override
  String get kmPeakPhase => 'Phase de compagnonnage optimal';

  @override
  String get kmGrowthAreas => 'Domaines de croissance';

  @override
  String get kmCommProtocols => 'Protocoles de communication';

  @override
  String get kmSharedPractices => 'Pratiques partagées';

  @override
  String get kmImprovementTitle => 'Thème central et plan d\'amélioration';

  @override
  String get kmVerdictTitle => 'Verdict final';

  @override
  String get kmRealizationPotential =>
      'Potentiel de réalisation de la relation';

  @override
  String get kmLayerAshtakoot => 'Ashtakoot';

  @override
  String get kmLayerD9 => 'D9 Navamsa';

  @override
  String get kmLayerMangalPapa => 'Mangal et Papasamya';

  @override
  String get kmLayerVenusMars => 'Vénus-Mars';

  @override
  String get kmLayerDashaSync => 'Synchronisation des Dashas';

  @override
  String get kmLayerH7H8 => 'Croisement des 7ème-8ème maisons';

  @override
  String get kmLayerAkResonance => 'Résonance de l\'Atmakaraka';

  @override
  String get kmLayerDomains => 'Dimensions par domaine';

  @override
  String get kmTopicAshtakoot => 'Notre score Ashtakoot';

  @override
  String get kmTopicMangal => 'Préoccupations liées au Mangal Dosha';

  @override
  String get kmTopicD9 => 'Notre karma matrimonial (D9)';

  @override
  String get kmTopicTiming => 'Meilleur timing pour le mariage';

  @override
  String get kmTopicRisks => 'Risques à anticiper';

  @override
  String get kmTopicGrowth => 'Comment nous pouvons grandir ensemble';

  @override
  String get kmTopicRemedies => 'Remèdes recommandés';

  @override
  String get kmTopicVerdict => 'Devrions-nous nous marier';

  @override
  String get pkSubtitle =>
      'Rapport védique de vies antérieures et karma propulsé par l\'IA';

  @override
  String get pkTitle => 'Vies antérieures et karma';

  @override
  String get pkSnapshotHeader => 'Aperçu des vies antérieures';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return 'Votre thème révèle une signature de vie antérieure « $theme », actuellement $relation dans cette vie. Chemin recommandé : $strategy.';
  }

  @override
  String get pkGaugeSignature => 'Force de la signature';

  @override
  String get pkGaugeMasteryPreserved => 'Maîtrise préservée';

  @override
  String get pkGaugeClearingProgress => 'Purification karmique';

  @override
  String get pkGaugeMaturity => 'Maturité de la vie antérieure';

  @override
  String get pkGaugeMemoryAccess => 'Accès à la mémoire';

  @override
  String get pkChipGoodProgress =>
      'Bonne progression de la purification karmique';

  @override
  String get pkChipLowDebt => 'Faible dette karmique';

  @override
  String get pkChipMatureSoul => 'Signature d\'âme mature';

  @override
  String get pkChipGiftedPast => 'Le thème porte un don de vie antérieure';

  @override
  String get pkChipAccomplished => 'Vie antérieure accomplie';

  @override
  String get pkChipMasteryPreserved => 'Forte maîtrise transmise';

  @override
  String get pkKetuTitle => 'Ketu — Votre maîtrise passée';

  @override
  String get pkKetuSubtitle => 'Compétences déjà maîtrisées par votre âme';

  @override
  String get pkMasteryStrength => 'Force de la maîtrise';

  @override
  String get pkSkillsCarried => 'Compétences transmises';

  @override
  String get pkInstincts => 'Capacités instinctives';

  @override
  String get pkKetuDignity => 'Dignité de Ketu';

  @override
  String get pkRahuTitle => 'Rahu — La frontière de croissance de votre âme';

  @override
  String get pkRahuSubtitle => 'Ce que votre âme est venue achever';

  @override
  String get pkUnmetDesires => 'Désirs inassouvis';

  @override
  String get pkProfileTitle => 'Votre profil de vie antérieure';

  @override
  String get pkProfession => 'Profession probable';

  @override
  String get pkSocialStanding => 'Statut social';

  @override
  String get pkRegion => 'Région probable';

  @override
  String get pkCulturalArchetype => 'Archétype culturel';

  @override
  String get pkAccomplishment => 'Niveau d\'accomplissement';

  @override
  String get pkAuthority => 'Niveau d\'autorité';

  @override
  String get pkFamilyRole => 'Rôle familial';

  @override
  String get pkSecondaryProfession => 'Profession secondaire';

  @override
  String get pkClimateAffinity => 'Affinité climatique';

  @override
  String get pkForeignResidence => 'Karma de résidence à l\'étranger';

  @override
  String get pkRelationshipsTitle => 'Relations passées transmises';

  @override
  String get pkSpouseConnection => 'Reconnexion avec le conjoint';

  @override
  String get pkChildrenConnection => 'Reconnexion avec les enfants';

  @override
  String get pkCarriedRelationTypes => 'Schémas relationnels';

  @override
  String get pkPartnerArchetype => 'Archétype du partenaire de vie antérieure';

  @override
  String get pkDarakaraka => 'Karaka du conjoint';

  @override
  String get pkParentsKarma => 'Schéma karmique des parents';

  @override
  String get pkSiblingKarma => 'Schéma karmique de la fratrie';

  @override
  String get pkSpiritualTitle => 'Votre vie spirituelle d\'alors';

  @override
  String get pkSpiritualLevel => 'Niveau spirituel';

  @override
  String get pkPracticeSignature => 'Style de pratique';

  @override
  String get pkMeditativeCapacity => 'Capacité méditative';

  @override
  String get pkDevotionalPractice => 'Pratique dévotionnelle';

  @override
  String get pkYogicAttainment => 'Accomplissement yogique';

  @override
  String get pkMokshaProximity => 'Proximité du Moksha';

  @override
  String get pkKarmicDebtsTitle => 'Dettes karmiques et richesse d\'alors';

  @override
  String get pkTotalKarmicDebt => 'Dette karmique totale';

  @override
  String get pkPrimaryDebtType => 'Type de dette principal';

  @override
  String get pkRelationshipDebt => 'Dette relationnelle';

  @override
  String get pkFinancialDebt => 'Dette financière';

  @override
  String get pkServiceDebt => 'Dette de service';

  @override
  String get pkDharmicDebt => 'Dette dharmique';

  @override
  String get pkPitruKarma => 'Karma Pitru';

  @override
  String get pkMatruKarma => 'Karma Matru';

  @override
  String get pkWealthLevel => 'Niveau de richesse d\'alors';

  @override
  String get pkWealthKarmaCarried => 'Karma de richesse transmis';

  @override
  String get pkResourcePattern => 'Gestion des ressources';

  @override
  String get pkGainSource => 'Source de gain';

  @override
  String get pkEchoesTitle => 'Échos dans cette vie';

  @override
  String get pkOnRelationships => 'Sur les relations';

  @override
  String get pkOnCareer => 'Sur la carrière';

  @override
  String get pkOnHealth => 'Sur la santé';

  @override
  String get pkOnSpirituality => 'Sur la spiritualité';

  @override
  String get pkDominantArea => 'Transmission la plus forte';

  @override
  String get pkAttractions => 'Attirances naturelles';

  @override
  String get pkAversions => 'Aversions naturelles';

  @override
  String get pkUnexplainedFears => 'Peurs inexpliquées';

  @override
  String get pkMagneticPulls => 'Attractions magnétiques';

  @override
  String get pkResolutionTitle => 'Résolution et achèvement karmique';

  @override
  String get pkPrimaryPathway => 'Voie principale';

  @override
  String get pkSecondaryPathway => 'Voie secondaire';

  @override
  String get pkClearingProgress => 'Progression de la purification';

  @override
  String get pkRemainingWork => 'Travail restant';

  @override
  String get pkSettlementTimeline => 'Calendrier de résolution';

  @override
  String get pkAccelerationPractices =>
      'Pratiques qui accélèrent la résolution';

  @override
  String get pkPriorityAreas => 'Domaines prioritaires';

  @override
  String get pkVerificationTitle => 'Vérifié à travers les thèmes (D60)';

  @override
  String get pkD60Label => 'Ère de vie antérieure D60';

  @override
  String get pkD60Ketu => 'Position de Ketu en D60';

  @override
  String get pkD60Standing => 'Statut global';

  @override
  String get pkMemoryTitle => 'Mémoire et intuition';

  @override
  String get pkMemoryAccess => 'Accès à la mémoire';

  @override
  String get pkRegressionFit => 'Adéquation à la thérapie de régression';

  @override
  String get pkDreamVisits => 'Visitations en rêve';

  @override
  String get pkDejaVuFrequency => 'Fréquence de déjà-vu';

  @override
  String get pkSpontaneousRemembrance => 'Réminiscence spontanée';

  @override
  String get pkRemembrancePractices => 'Pratiques de réminiscence';

  @override
  String get pkTimelineTitle => 'Calendrier d\'activation';

  @override
  String get pkGiftsActivation => 'Activation des dons de vie antérieure';

  @override
  String get pkSurfaceWindow => 'Fenêtre d\'émergence';

  @override
  String get pkRisksTitle => 'Risques et schémas chroniques';

  @override
  String get pkTraumaResidue => 'Résidu de traumatisme';

  @override
  String get pkSpiritualBypass => 'Risque de contournement spirituel';

  @override
  String get pkMajorRisks => 'Risques majeurs';

  @override
  String get pkChronicImprints => 'Empreintes chroniques';

  @override
  String get pkKarmicLoops => 'Boucles karmiques';

  @override
  String get pkImprovementTitle => 'Plan d\'amélioration';

  @override
  String get pkRoadmapTitle => 'Votre feuille de route de vie antérieure';

  @override
  String get pkMaturity => 'Maturité de la vie antérieure';

  @override
  String get pkLayerD1 => 'Thème de naissance (D1)';

  @override
  String get pkLayerD9 => 'Navamsa (D9)';

  @override
  String get pkLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get pkLayerKetuDepth => 'Profondeur de Ketu';

  @override
  String get pkLayerAtmakaraka => 'Planète de l\'âme (Atmakaraka)';

  @override
  String get pkTopicMastery => 'Ma maîtrise de vie antérieure';

  @override
  String get pkTopicUnfinished => 'Mon karma inachevé';

  @override
  String get pkTopicRelationships => 'Mes relations de vie antérieure';

  @override
  String get pkTopicDebts => 'Mes dettes karmiques';

  @override
  String get pkTopicResolution => 'Comment résoudre mon karma';

  @override
  String get pkTopicMemory => 'Accès à la mémoire des vies antérieures';

  @override
  String get pkTopicTiming => 'Meilleures fenêtres de timing';

  @override
  String get pkTopicProfile => 'Qui j\'étais dans ma vie antérieure';

  @override
  String get chSubtitle =>
      'Rapport védique d\'analyse du caractère propulsé par l\'IA';

  @override
  String get chTitle => 'Analyse du caractère';

  @override
  String get chSnapshotHeader => 'Aperçu du caractère';

  @override
  String get chGaugeIntegrity => 'Intégrité';

  @override
  String get chGaugeResilience => 'Résilience';

  @override
  String get chGaugeSelfAwareness => 'Conscience de soi';

  @override
  String get chGaugeStability => 'Stabilité émotionnelle';

  @override
  String get chGaugeMoralFabric => 'Fibre morale';

  @override
  String get chChipRajaYoga => 'Raja Yoga présent';

  @override
  String get chChipHighIntegrity => 'Haute intégrité';

  @override
  String get chChipResilient => 'Nature résiliente';

  @override
  String get chChipDharmic => 'Forte orientation vers le dharma';

  @override
  String get chChipEmpathetic => 'Naturellement empathique';

  @override
  String get chChipLoyal => 'Profondément loyal';

  @override
  String get chChipGiftedCharacter => 'Le thème porte un don de caractère';

  @override
  String get chSoulTitle => 'Votre signature d\'âme';

  @override
  String get chSoulIntegration => 'Intégration âme-caractère';

  @override
  String get chAmatyakarakaTheme => 'Voix du personnage secondaire';

  @override
  String get chAtmakarakaDignity => 'Dignité de la planète de l\'âme';

  @override
  String get chAtmakarakaHouse => 'Position en maison';

  @override
  String get chSurfaceTitle => 'Personnalité de surface et constitution';

  @override
  String get chLagnaSign => 'Signe ascendant';

  @override
  String get chConstitution => 'Constitution';

  @override
  String get chSurfaceSignature => 'Comment vous êtes perçu';

  @override
  String get chPhysicalConstitution => 'Constitution physique';

  @override
  String get chLagnaLord => 'Maître de l\'ascendant';

  @override
  String get chLagnaOccupants => 'Planètes dans l\'ascendant';

  @override
  String get chMindEmotionsTitle => 'Esprit, émotions et ego';

  @override
  String get chEmotionalNature => 'Votre nature émotionnelle';

  @override
  String get chMentalStability => 'Stabilité mentale';

  @override
  String get chSelfConfidence => 'Confiance en soi saine';

  @override
  String get chEgoNature => 'Votre ego et concept de soi';

  @override
  String get chAuthorityRelationship => 'Relation à l\'autorité';

  @override
  String get chPrideTendency => 'Tendance à la fierté';

  @override
  String get chMoodPatterns => 'Schémas d\'humeur';

  @override
  String get chKemadrumaPresent =>
      'Kemadruma Yoga présent — un soin émotionnel supplémentaire est bénéfique.';

  @override
  String get chFatherImprint => 'Qualité de l\'empreinte paternelle';

  @override
  String get chCommunicationTitle => 'Style de communication et d\'intellect';

  @override
  String get chIntellectStyle => 'Style intellectuel';

  @override
  String get chCommStyle => 'Style de communication';

  @override
  String get chDecisionStyle => 'Style de prise de décision';

  @override
  String get chDiscrimination => 'Capacité de discernement';

  @override
  String get chPersonaTitle => 'Image publique vs véritable identité';

  @override
  String get chAuthenticityGap => 'Écart d\'authenticité';

  @override
  String get chGunaTitle => 'Profil Guna et Dosha';

  @override
  String get chGunaSubtitle =>
      'Votre nature intérieure et votre constitution, style védique classique';

  @override
  String get chSattva => 'Sattva';

  @override
  String get chRajas => 'Rajas';

  @override
  String get chTamas => 'Tamas';

  @override
  String get chDominantGuna => 'Guna dominant';

  @override
  String get chPitta => 'Pitta';

  @override
  String get chKapha => 'Kapha';

  @override
  String get chVata => 'Vata';

  @override
  String get chDominantDosha => 'Dosha dominant';

  @override
  String get chRahuRestlessness => 'Agitation de Rahu';

  @override
  String get chKetuDetachment => 'Détachement de Ketu';

  @override
  String get chYogasTitle => 'Yogas de caractère';

  @override
  String get chRajaYogaStrength => 'Force du Raja Yoga';

  @override
  String get chGiftYogas => 'Yogas de don';

  @override
  String get chTestYogas => 'Yogas d\'épreuve';

  @override
  String get chStrengthsTitle => 'Forces et talents';

  @override
  String get chSignatureVirtues => 'Vertus caractéristiques';

  @override
  String get chNaturalTalents => 'Talents naturels';

  @override
  String get chSoftSkills => 'Compétences relationnelles';

  @override
  String get chHiddenStrengths => 'Forces cachées à développer';

  @override
  String get chShadowTitle => 'Ombre et domaines de croissance';

  @override
  String get chShadowSubtitle =>
      'Une prise de conscience douce des schémas à travailler';

  @override
  String get chShadowPatterns => 'Schémas de l\'ombre';

  @override
  String get chBlindSpots => 'Angles morts';

  @override
  String get chEmotionalWounds => 'Blessures émotionnelles';

  @override
  String get chShadowWorkPriorities => 'Priorités de travail sur l\'ombre';

  @override
  String get chMoralTests => 'Épreuves morales';

  @override
  String get chRelationshipsTitle => 'Relations et style social';

  @override
  String get chWarmth => 'Chaleur interpersonnelle';

  @override
  String get chEmpathy => 'Capacité d\'empathie';

  @override
  String get chLoyalty => 'Capacité de loyauté';

  @override
  String get chBoundaries => 'Établissement de limites';

  @override
  String get chSocialConfidence => 'Confiance sociale';

  @override
  String get chTrustGiving => 'Propension de base à faire confiance';

  @override
  String get chConflictStyle => 'Style de gestion des conflits';

  @override
  String get chEthicsTitle => 'Éthique et boussole morale';

  @override
  String get chDharmaOrientation => 'Orientation vers le dharma';

  @override
  String get chTruthfulness => 'Sincérité';

  @override
  String get chCompassion => 'Compassion';

  @override
  String get chGenerosity => 'Générosité';

  @override
  String get chEthicalConsistency => 'Cohérence éthique';

  @override
  String get chIntegrityPressure => 'Intégrité sous pression';

  @override
  String get chJusticeFairness => 'Justice et équité';

  @override
  String get chMoralTrajectory => 'Développement moral';

  @override
  String get chEiTitle => 'Intelligence émotionnelle';

  @override
  String get chEiSelfAwareness => 'Conscience de soi';

  @override
  String get chEiSelfRegulation => 'Autorégulation';

  @override
  String get chEiEmpathy => 'Empathie';

  @override
  String get chEiSocialSkills => 'Compétences sociales';

  @override
  String get chMotivation => 'Motivation interne';

  @override
  String get chVulnerabilityComfort => 'Aisance avec la vulnérabilité';

  @override
  String get chEmotionalExpression => 'Aisance dans l\'expression émotionnelle';

  @override
  String get chEmotionalReceptivity => 'Réceptivité émotionnelle';

  @override
  String get chVerificationTitle =>
      'Vérifié à travers les thèmes (D9/D12/D30/D60)';

  @override
  String get chD9Label => 'D9 Dharma-Caractère';

  @override
  String get chD12Label => 'D12 Héritage ancestral';

  @override
  String get chD30Label => 'D30 Profil de l\'ombre';

  @override
  String get chD60Label => 'D60 Caractère de vie antérieure';

  @override
  String get chD30Standing => 'Statut de l\'ombre';

  @override
  String get chMaternalInheritance => 'Héritage maternel';

  @override
  String get chAncestralKarmaWeight => 'Poids du karma ancestral';

  @override
  String get chTimelineTitle => 'Chronologie du caractère';

  @override
  String get chFormationWindow => 'Fenêtre de formation';

  @override
  String get chMaturationWindow => 'Fenêtre de maturation';

  @override
  String get chLegacyWindow => 'Fenêtre d\'héritage';

  @override
  String get chPeakMaturationAge => 'Âge de maturation maximale';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return 'Âge $ageRange';
  }

  @override
  String get chImprovementTitle => 'Plan d\'amélioration';

  @override
  String get chRoadmapTitle => 'Votre feuille de route de caractère';

  @override
  String get chAuthenticExpression => 'Expression authentique de soi';

  @override
  String get chRealizationPotential => 'Potentiel de réalisation du caractère';

  @override
  String get chLayerAtmakaraka => 'Planète de l\'âme (Atmakaraka)';

  @override
  String get chLayerD1 => 'Thème de naissance (D1)';

  @override
  String get chLayerD9 => 'Navamsa (D9)';

  @override
  String get chLayerD30 => 'Trimshamsa (D30)';

  @override
  String get chLayerLagnaMoon => 'Ascendant et Lune';

  @override
  String get chLayerArudha => 'Arudha Lagna';

  @override
  String get chTopicStrengths => 'Mes forces de caractère';

  @override
  String get chTopicShadow => 'Mes schémas d\'ombre';

  @override
  String get chTopicSoul => 'Ma signature d\'âme';

  @override
  String get chTopicRelationships => 'Mon style relationnel';

  @override
  String get chTopicEthics => 'Mon éthique et mes valeurs';

  @override
  String get chTopicGuna => 'Mon profil guna et dosha';

  @override
  String get chTopicGrowth => 'Comment développer mon caractère';

  @override
  String get chTopicTiming =>
      'Meilleur timing pour travailler sur le caractère';

  @override
  String get lpSubtitle =>
      'Rapport védique de chemin de vie et chance propulsé par l\'IA';

  @override
  String get lpTitle => 'Chemin de vie et chance';

  @override
  String get lpSnapshotHeader => 'Aperçu du chemin de vie';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return 'Vous êtes un(e) $archetype avec un objectif principal dans $domain. Notre analyse montre un potentiel global d\'accomplissement de vie de $probability %.';
  }

  @override
  String get lpGaugeDharma => 'Clarté du dharma';

  @override
  String get lpGaugeFortune => 'Base de fortune';

  @override
  String get lpGaugeCoherence => 'Cohérence du chemin';

  @override
  String get lpGaugeFulfillment => 'Accomplissement';

  @override
  String get lpGaugeMomentum => 'Élan karmique';

  @override
  String get lpChipRareGift => 'Don de destinée rare';

  @override
  String get lpChipFreeWillStrong => 'Forte volonté libre';

  @override
  String get lpChipGraceSupported => 'Soutenu par la grâce';

  @override
  String get lpChipLightKarma => 'Charge karmique légère';

  @override
  String get lpChipRecognitionPotential => 'Potentiel de reconnaissance';

  @override
  String get lpChipSpiritualPath => 'Forte attirance spirituelle';

  @override
  String get lpChipBlessed => 'Le thème porte des bénédictions';

  @override
  String get lpSoulPathTitle => 'Votre chemin d\'âme';

  @override
  String get lpSoulPlanet => 'Planète de l\'âme';

  @override
  String get lpCareerPlanet => 'Planète de l\'objectif';

  @override
  String get lpSoulClarity => 'Clarté de l\'objectif';

  @override
  String get lpLifeChapter => 'Chapitre de vie actuel';

  @override
  String get lpPrimaryDomain => 'Domaine d\'objectif principal';

  @override
  String get lpKarakaTitle => 'Vos planètes du dharma';

  @override
  String get lpKarakaSubtitle =>
      'Dans quelle mesure chaque planète soutient votre objectif de vie';

  @override
  String get lpVerificationTitle => 'Vérifié à travers les thèmes (D9 / D60)';

  @override
  String get lpD9Label => 'Alignement de l\'âme D9';

  @override
  String lpD9Explain(Object stage) {
    return 'Votre stade d\'évolution de l\'âme est « $stage » dans le thème Navamsa.';
  }

  @override
  String get lpD9JupiterDignity => 'Dignité de Jupiter';

  @override
  String get lpD9DharmaMultiplier => 'Multiplicateur de dharma';

  @override
  String get lpD60Label => 'Signature de vie antérieure D60';

  @override
  String get lpKarmaType => 'Type de karma de vie antérieure';

  @override
  String get lpKetuMastery => 'Maîtrise de vie antérieure de Ketu';

  @override
  String get lpRahuGrowthDir => 'Direction de croissance de Rahu';

  @override
  String get lpYogasTitle => 'Yogas de fortune et blocages de chance';

  @override
  String get lpFortuneBoost => 'Élan de fortune';

  @override
  String get lpLuckDrain => 'Fuite de chance';

  @override
  String get lpFortuneBoosters => 'Amplificateurs de fortune';

  @override
  String get lpLuckBlocks => 'Blocages de chance';

  @override
  String get lpPurposeTitle => 'Domaines d\'objectif et renommée';

  @override
  String get lpDomainLeadership => 'Leadership';

  @override
  String get lpDomainWisdom => 'Sagesse et enseignement';

  @override
  String get lpDomainService => 'Service';

  @override
  String get lpDomainHealing => 'Guérison';

  @override
  String get lpDomainCreative => 'Expression créative';

  @override
  String get lpPrimaryDomainBadge => 'Principal';

  @override
  String get lpFameRecognition => 'Renommée et reconnaissance';

  @override
  String get lpSocialInfluence => 'Influence sociale';

  @override
  String get lpRecognitionDomain => 'Domaine de reconnaissance';

  @override
  String get lpPublicImage => 'Image publique';

  @override
  String get lpHistoricalImpact => 'Potentiel d\'impact historique';

  @override
  String get lpTimelineTitle => 'Chronologie de fortune et de vie';

  @override
  String get lpCurrentPhase => 'Phase de fortune actuelle';

  @override
  String get lpJupiterReturn => 'Retour de Jupiter';

  @override
  String get lpSaturnReturn => 'Retour de Saturne';

  @override
  String get lpSadeSati => 'Sade Sati';

  @override
  String get lpGoldenWindow => 'Fenêtre dorée';

  @override
  String get lpTransformationWindow => 'Fenêtre de transformation';

  @override
  String get lpPeakYears => 'Années de fortune maximale';

  @override
  String get lpChallengingYears => 'Années difficiles';

  @override
  String get lpMilestonesTitle => 'Jalons majeurs et tournants';

  @override
  String get lpFirstTurningPoint => 'Premier tournant majeur';

  @override
  String get lpMidlifeTransform => 'Transformation du milieu de vie';

  @override
  String get lpLateLifeFulfillment => 'Accomplissement de fin de vie';

  @override
  String lpDharmicMilestone(Object age) {
    return 'Jalon dharmique (âge $age)';
  }

  @override
  String lpAgeLabel(Object age) {
    return 'Âge $age';
  }

  @override
  String get lpDestinyTitle => 'Destin vs libre arbitre';

  @override
  String get lpDestinyStat => 'Poids du destin';

  @override
  String get lpFreeWillStat => 'Levier du libre arbitre';

  @override
  String get lpFateStrength => 'Force de la signature du destin';

  @override
  String get lpSelfCreation => 'Capacité d\'auto-création';

  @override
  String get lpEffortGrace => 'Effort vs grâce';

  @override
  String get lpKarmicTitle => 'Leçons karmiques';

  @override
  String get lpRahuGrowthLabel => 'Rahu — Défi de croissance';

  @override
  String get lpKetuSurrenderLabel => 'Ketu — Thème de lâcher-prise';

  @override
  String get lpSaturnLessonLabel => 'Saturne — Leçon de discipline';

  @override
  String get lpTestDifficulty => 'Difficulté des épreuves de vie';

  @override
  String get lpLessonsInProgress => 'Leçons en cours';

  @override
  String get lpSoulContract => 'Domaines du contrat d\'âme';

  @override
  String get lpSoulExperience => 'Ce que votre âme est venue vivre';

  @override
  String get lpSoulMastery => 'Ce que votre âme est venue maîtriser';

  @override
  String get lpSpiritualTitle => 'Chemin spirituel';

  @override
  String get lpSpiritualInclination => 'Inclination spirituelle';

  @override
  String get lpMeditationReceptivity => 'Réceptivité à la méditation';

  @override
  String get lpTeacherKarma => 'Karma d\'enseignant/gourou';

  @override
  String get lpPilgrimageBenefit => 'Bénéfice du pèlerinage';

  @override
  String get lpSelfRealization => 'Potentiel de réalisation de soi';

  @override
  String get lpDivineConnection => 'Connexion divine';

  @override
  String get lpTraditionAffinity => 'Affinité avec la tradition';

  @override
  String get lpIntuitionStrength => 'Force de l\'intuition';

  @override
  String get lpMantraEfficacy => 'Efficacité de la prière/du mantra';

  @override
  String get lpInnerGuidance => 'Confiance en la guidance intérieure';

  @override
  String get lpPropheticDreams => 'Sensibilité aux rêves prémonitoires';

  @override
  String get lpDifficultyTitle => 'Difficultés et défis de vie';

  @override
  String get lpEarlyLife => 'Début de vie';

  @override
  String get lpMidlife => 'Milieu de vie';

  @override
  String get lpLateLife => 'Fin de vie';

  @override
  String get lpStruggleToSuccess => 'Karma de lutte vers le succès';

  @override
  String get lpUnlivedLifeRisk => 'Risque de vie inaccomplie';

  @override
  String get lpChallenges => 'Défis de vie';

  @override
  String get lpFortuneDrains => 'Fuites chroniques de fortune';

  @override
  String get lpRegretAreas => 'Domaines vulnérables aux regrets';

  @override
  String get lpRedFlags => 'Signaux d\'alerte de direction';

  @override
  String get lpBlessingsTitle => 'Bénédictions et thème central de vie';

  @override
  String get lpKarmicRoot => 'Racine karmique';

  @override
  String get lpBlessingsList => 'Vos bénédictions';

  @override
  String get lpFulfillmentPriorities => 'Priorités d\'accomplissement';

  @override
  String get lpImprovementTitle => 'Plan d\'amélioration';

  @override
  String get lpDharmaPriorities => 'Priorités du dharma';

  @override
  String get lpRoadmapTitle => 'Votre feuille de route du destin';

  @override
  String get lpStrategy => 'Stratégie';

  @override
  String get lpFulfillmentPotential => 'Potentiel d\'accomplissement';

  @override
  String get lpNext12Focus => 'Focus des 12 prochains mois';

  @override
  String get lpLayerD1 => 'Thème de naissance (D1)';

  @override
  String get lpLayerD9 => 'Navamsa (D9)';

  @override
  String get lpLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get lpLayerDasha => 'Timing de la Dasha';

  @override
  String get lpLayerTransit => 'Transits actuels';

  @override
  String get lpTopicPurpose => 'Mon objectif de vie';

  @override
  String get lpTopicFortune => 'Mes yogas de fortune';

  @override
  String get lpTopicKarma => 'Mes leçons karmiques';

  @override
  String get lpTopicMilestones => 'Jalons à venir';

  @override
  String get lpTopicDestiny => 'Destin vs libre arbitre';

  @override
  String get lpTopicSpiritual => 'Mon chemin spirituel';

  @override
  String get lpTopicChallenges => 'Mes défis de vie';

  @override
  String get lpTopicTiming => 'Meilleures fenêtres de timing';

  @override
  String get dbSubtitle =>
      'Rapport védique de dette et redressement propulsé par l\'IA';

  @override
  String get dbTitle => 'Dette et redressement';

  @override
  String get dbSnapshotHeader => 'Aperçu du redressement de dette';

  @override
  String dbHeroSummary(
    Object phase,
    Object personality,
    Object probability,
    Object years,
  ) {
    return 'Vous êtes actuellement dans une phase « $phase » avec une approche $personality de l\'argent. Notre analyse montre une probabilité de $probability % de devenir libre de dettes dans environ $years ans.';
  }

  @override
  String get dbGaugeCapacity => 'Capacité de redressement';

  @override
  String get dbGaugeProbability => 'Chance de redressement';

  @override
  String get dbGaugeFreedomNow => 'Liberté de dette actuelle';

  @override
  String get dbGaugeDti => 'Santé des revenus';

  @override
  String get dbGaugeResilience => 'Résilience';

  @override
  String get dbChipCleanKarma => 'Karma de dette propre';

  @override
  String get dbChipStrongRecovery => 'Forte capacité de redressement';

  @override
  String get dbChipHealthyDti => 'Ratio dette/revenu sain';

  @override
  String get dbChipResilient => 'Haute résilience psychologique';

  @override
  String get dbChipCycleBreakable => 'Le cycle d\'endettement peut être brisé';

  @override
  String get dbChipLowReindebt => 'Faible risque de réendettement';

  @override
  String get dbChipGoodNegotiator => 'Bonnes chances de négociation';

  @override
  String get dbProfileTitle => 'Votre profil d\'endettement';

  @override
  String get dbPhaseLabel => 'Phase actuelle';

  @override
  String get dbPrimaryCategoryLabel => 'Catégorie principale';

  @override
  String get dbKarakaLabel => 'Karaka de la dette';

  @override
  String get dbProtectorLabel => 'Protection contre les créanciers';

  @override
  String get dbSecondaryCategories => 'Catégories secondaires';

  @override
  String get dbUnsecuredRatio => 'Ratio de dette non garantie';

  @override
  String get dbKarakaTitle => 'Vos planètes de dette';

  @override
  String get dbKarakaSubtitle =>
      'Dans quelle mesure chaque planète soutient votre redressement de dette';

  @override
  String get dbVerificationTitle => 'Vérifié à travers les thèmes (D6)';

  @override
  String get dbD6Label => 'Thème D6 des dettes et ennemis';

  @override
  String get dbD6LordDignity => 'Force du maître de la 6ème maison';

  @override
  String get dbD6Severity => 'Sévérité du karma de dette';

  @override
  String get dbD6Multiplier => 'Multiplicateur de dette D6';

  @override
  String get dbYogasTitle => 'Yogas de dette et protections';

  @override
  String get dbPressureNow => 'Pression de dette actuelle';

  @override
  String get dbRecoveryBoost => 'Élan de redressement';

  @override
  String get dbClearingLabel => 'Yogas d\'apurement de dette';

  @override
  String get dbCreatingLabel => 'Yogas créateurs de dette';

  @override
  String get dbCategoriesTitle => 'Surveillance des catégories de dette';

  @override
  String get dbCategoriesSubtitle =>
      'Quels types de dette nécessitent le plus d\'attention';

  @override
  String get dbTimelineTitle => 'Chronologie de libération de dette';

  @override
  String get dbFreeWindowLabel => 'FENÊTRE DE LIBÉRATION DE DETTE';

  @override
  String get dbClearanceEstimate => 'Estimation d\'apurement complet';

  @override
  String get dbPeakYears => 'Années de pic d\'endettement';

  @override
  String get dbClearanceYears => 'Années d\'apurement';

  @override
  String get dbBorrowTitle => 'Guide d\'emprunt intelligent';

  @override
  String get dbLoanSuitability => 'Adéquation au prêt';

  @override
  String get dbBestLoanType => 'Meilleur type de prêt';

  @override
  String get dbLeverageCeiling => 'Plafond de levier';

  @override
  String get dbNegotiationSuccess => 'Succès de négociation';

  @override
  String get dbCreditorAggression => 'Risque de pression des créanciers';

  @override
  String get dbLegalEscalation => 'Risque d\'escalade juridique';

  @override
  String get dbNegotiationApproach => 'Approche recommandée';

  @override
  String get dbAvoidLoanTypes => 'Types de prêts à éviter';

  @override
  String get dbRiskTitle => 'Surveillance des risques et vulnérabilités';

  @override
  String get dbRiskDefault => 'Risque de défaut';

  @override
  String get dbRiskDefaultExp =>
      'La probabilité de manquer un remboursement prévu au point de déclencher un statut de défaut auprès d\'un prêteur.';

  @override
  String get dbRiskDefaultFix =>
      'Automatisez les paiements minimums et gardez une réserve d\'un mois pour qu\'un seul cycle de revenu manqué n\'entraîne pas d\'effet domino.';

  @override
  String get dbRiskBankruptcy => 'Risque de faillite';

  @override
  String get dbRiskBankruptcyExp =>
      'La probabilité que la charge de dette dépasse ce que les revenus et les actifs peuvent raisonnablement couvrir.';

  @override
  String get dbRiskBankruptcyFix =>
      'Faites examiner votre dette par un professionnel avant de contracter un nouveau prêt ou une nouvelle ligne de crédit.';

  @override
  String get dbRiskAssetSeizure => 'Risque de saisie d\'actifs';

  @override
  String get dbRiskAssetSeizureExp =>
      'La probabilité qu\'un défaut sur un prêt garanti conduise un prêteur à saisir une garantie ou un bien.';

  @override
  String get dbRiskAssetSeizureFix =>
      'Priorisez d\'abord les paiements des prêts garantis, et refinancez tôt si un écart de paiement semble probable.';

  @override
  String get dbRiskChronic => 'Risque chronique de réendettement';

  @override
  String get dbRiskChronicExp =>
      'La tendance à retomber dans l\'endettement même après avoir apuré la charge actuelle.';

  @override
  String get dbRiskChronicFix =>
      'Constituez un fonds d\'urgence dédié avant d\'augmenter vos dépenses de style de vie après l\'apurement.';

  @override
  String get dbReindebtTrigger => 'Déclencheur de réendettement';

  @override
  String get dbCycleBreakFeasibility => 'Faisabilité de rupture du cycle';

  @override
  String get dbMajorRisks => 'Risques majeurs';

  @override
  String get dbHiddenSignals => 'Signaux cachés d\'endettement';

  @override
  String get dbCrisisTitle => 'Préparation aux crises';

  @override
  String get dbCrisisSubtitle =>
      'Comment repérer les problèmes tôt et réagir calmement';

  @override
  String get dbWarningSigns => 'Signes avant-coureurs';

  @override
  String get dbMitigationActions => 'Que faire à ce sujet';

  @override
  String get dbFamilyTitle => 'Dette familiale et ancestrale';

  @override
  String get dbInheritedDebtProb => 'Probabilité de dette héritée';

  @override
  String get dbFamilyDrag => 'Poids de la dette familiale';

  @override
  String get dbInheritedSource => 'Source probable';

  @override
  String get dbCoreBlockerLabel => 'BLOCAGE PRINCIPAL';

  @override
  String get dbPsychologyTitle => 'Votre psychologie de l\'argent';

  @override
  String get dbResilience => 'Résilience';

  @override
  String get dbDiscipline => 'Discipline sous pression';

  @override
  String get dbSocialSupport => 'Soutien social';

  @override
  String get dbDepressionRisk => 'Vulnérabilité au stress financier';

  @override
  String get dbStressTolerance => 'Tolérance au stress';

  @override
  String get dbRootCause => 'Cause comportementale profonde';

  @override
  String get dbImprovementTitle => 'Plan d\'amélioration';

  @override
  String get dbRoadmapTitle =>
      'Votre feuille de route vers la liberté de dette';

  @override
  String get dbRecoveryProbability => 'Probabilité de redressement';

  @override
  String get dbClearanceTimeline => 'Calendrier d\'apurement';

  @override
  String get dbYears => 'ans';

  @override
  String get dbDtiHealth => 'Santé du ratio dette/revenu';

  @override
  String get dbDtiCategory => 'Catégorie de ratio dette/revenu';

  @override
  String get dbBreakEvenMonths => 'Mois jusqu\'au seuil de rentabilité';

  @override
  String get dbIncomeAcceleration => 'Croissance de revenu nécessaire';

  @override
  String get dbLayerD1 => 'Thème de naissance (D1)';

  @override
  String get dbLayerD6 => 'Dettes et ennemis (D6)';

  @override
  String get dbLayerD9 => 'Navamsa (D9)';

  @override
  String get dbLayerDasha => 'Timing de la Dasha';

  @override
  String get dbLayerTransit => 'Transits actuels';

  @override
  String get dbTopicRecovery => 'Ma chronologie de redressement';

  @override
  String get dbTopicNegotiate => 'Négocier avec les créanciers';

  @override
  String get dbTopicBorrowing => 'Est-il prudent d\'emprunter maintenant';

  @override
  String get dbTopicCrisis => 'Se préparer à une crise';

  @override
  String get dbTopicAncestral => 'Karma de dette ancestrale';

  @override
  String get dbTopicTimeline => 'Meilleures années pour apurer la dette';

  @override
  String get dbTopicPsychology => 'Ma psychologie de l\'argent';

  @override
  String get dbTopicCategories => 'Quelles dettes prioriser';

  @override
  String get mnSubtitle => 'Rapport védique de bien-être propulsé par l\'IA';

  @override
  String get mnTitle => 'Mental et stress';

  @override
  String get mnSnapshotHeader => 'Aperçu du bien-être';

  @override
  String get mnResilience => 'Résilience';

  @override
  String get mnStability => 'Stabilité';

  @override
  String get mnEmotionalBalance => 'Équilibre émotionnel';

  @override
  String get mnInnerCalm => 'Calme intérieur';

  @override
  String get mnSelfAwareness => 'Conscience de soi';

  @override
  String get mnStatusThriving => 'Épanoui';

  @override
  String get mnStatusSteady => 'Stable et équilibré';

  @override
  String get mnStatusBuildingStrength => 'En construction de force';

  @override
  String get mnStatusNeedsGentleCare => 'A besoin d\'attention douce';

  @override
  String get mnStatusReachOut => 'Il est temps de demander du soutien';

  @override
  String get mnChipStable => 'Émotionnellement stable';

  @override
  String get mnChipSupported => 'Bien soutenu';

  @override
  String get mnChipSelfAware => 'Très conscient de soi';

  @override
  String get mnChipResilient => 'Rebondit bien';

  @override
  String get mnChipSecureAttachment => 'Attachement sécurisant';

  @override
  String get mnChipHealingReady => 'Prêt à guérir';

  @override
  String get mnChipMindBodyBalance => 'Équilibre corps-esprit';

  @override
  String get mnSupportBannerTitle => 'Une note bienveillante';

  @override
  String get mnSupportBannerBody =>
      'Votre thème suggère que c\'est peut-être le bon moment de vous appuyer sur un soutien supplémentaire — un ami de confiance, un membre de la famille ou un professionnel. Demander de l\'aide est un signe de force, pas de faiblesse.';

  @override
  String get mnProfileTitle => 'Votre plan émotionnel';

  @override
  String get mnStressDriver => 'Facteur de stress';

  @override
  String get mnStabilityAnchor => 'Ancre de stabilité';

  @override
  String get mnSoulLevelKarma => 'Schéma au niveau de l\'âme';

  @override
  String get mnSubtleSignature => 'Signature émotionnelle subtile';

  @override
  String get mnKarakaTitle => 'Votre esprit et les planètes';

  @override
  String get mnKarakaSubtitle =>
      'Quelles planètes façonnent votre monde intérieur';

  @override
  String get mnYogasTitle => 'Forces et domaines de croissance';

  @override
  String get mnCurrentPhase => 'Phase actuelle';

  @override
  String get mnCurrentStressLevel => 'Niveau de stress actuel';

  @override
  String get mnRecentStrain => 'Tension émotionnelle récente';

  @override
  String get mnStrengths => 'Forces';

  @override
  String get mnGrowthAreas => 'Domaines de croissance';

  @override
  String get mnSadeSatiStatus => 'Statut du Sade Sati';

  @override
  String get mnVerificationTitle => 'Vérifié à travers les thèmes';

  @override
  String get mnD9Confirmation => 'Confirmation D9';

  @override
  String get mnD30Confirmation => 'Confirmation D30';

  @override
  String get mnMoodPatternsTitle => 'Schémas d\'humeur et d\'anxiété';

  @override
  String get mnMoodPatternsSubtitle =>
      'Une prise de conscience douce, pas un diagnostic';

  @override
  String get mnAnxietyPatterns => 'Schémas d\'anxiété';

  @override
  String get mnMoodPatterns => 'Schémas de baisse de moral';

  @override
  String get mnPrimaryPattern => 'Schéma principal';

  @override
  String get mnRumination => 'Tendance à trop réfléchir';

  @override
  String get mnHypervigilance => 'Hyper-vigilance';

  @override
  String get mnHopelessnessVuln => 'Sensibilité à la baisse de moral';

  @override
  String get mnEnergyDepletion => 'Tendance à l\'épuisement énergétique';

  @override
  String get mnMotivationBaseline => 'Niveau de motivation de base';

  @override
  String get mnRegulationTitle => 'Régulation émotionnelle et gestion';

  @override
  String get mnEmotionalRegulation => 'Régulation émotionnelle';

  @override
  String get mnSelfSoothing => 'Capacité d\'auto-apaisement';

  @override
  String get mnExpressionStyle => 'Style d\'expression';

  @override
  String get mnRecoveryTime => 'Temps de récupération';

  @override
  String get mnTriggerIntensity => 'Intensité des déclencheurs';

  @override
  String get mnHealthyCoping => 'Habitudes d\'adaptation saines';

  @override
  String get mnWatchFor => 'À surveiller avec bienveillance';

  @override
  String get mnSleepTitle => 'Sommeil et repos';

  @override
  String get mnSleepQuality => 'Qualité du sommeil';

  @override
  String get mnSleepAsRegulator => 'Le sommeil comme régulateur émotionnel';

  @override
  String get mnInsomniaTendency => 'Tendance aux nuits agitées';

  @override
  String get mnNightmareTendency => 'Tendance aux rêves intenses';

  @override
  String get mnSleepHygienePriority => 'Priorité d\'hygiène du sommeil';

  @override
  String get mnBurnoutTitle => 'Épuisement professionnel et énergie';

  @override
  String get mnBurnoutVulnerability =>
      'Sensibilité à l\'épuisement professionnel';

  @override
  String get mnBurnoutRecovery => 'Capacité de récupération après épuisement';

  @override
  String get mnBurnoutStage => 'Stade actuel d\'épuisement';

  @override
  String get mnSelfDrivingTendency => 'Tendance à l\'auto-exigence';

  @override
  String get mnBurnoutTriggers => 'Déclencheurs d\'épuisement';

  @override
  String get mnConnectionTitle => 'Connexion et soutien';

  @override
  String get mnSocialSupport => 'Qualité du soutien social';

  @override
  String get mnLonelinessVuln => 'Sensibilité à la solitude';

  @override
  String get mnSolitudeNeed => 'Besoin de solitude';

  @override
  String get mnSocialComfort => 'Aisance sociale';

  @override
  String get mnTraumaSensitivity => 'Sensibilité au traumatisme';

  @override
  String get mnHealingReadiness => 'Disposition à guérir';

  @override
  String get mnProcessingStyle => 'Style de traitement';

  @override
  String get mnMindBodyIntegration => 'Intégration corps-esprit';

  @override
  String get mnPtsdVuln => 'Sensibilité à la réponse au traumatisme';

  @override
  String get mnSelfAwarenessTitle => 'Conscience de soi et croissance';

  @override
  String get mnSelfAwarenessScore => 'Conscience de soi';

  @override
  String get mnEmotionalVocabulary => 'Vocabulaire émotionnel';

  @override
  String get mnTherapyReadiness => 'Disposition à la thérapie';

  @override
  String get mnJournalingBenefit => 'Bénéfice de la tenue d\'un journal';

  @override
  String get mnInnerDialogue => 'Qualité du dialogue intérieur';

  @override
  String get mnAwarenessOfPatterns => 'Conscience des schémas';

  @override
  String get mnEscapePatternVuln => 'Sensibilité aux schémas d\'évasion';

  @override
  String get mnEscapeChannels => 'À surveiller avec bienveillance';

  @override
  String get mnHealthyAlternatives => 'Alternatives saines';

  @override
  String get mnTherapyFitTitle => 'Adéquation thérapie et soutien';

  @override
  String get mnCrisisSupportRec => 'Recommandation de soutien';

  @override
  String get mnSupportNetwork => 'Activez votre réseau de soutien';

  @override
  String get mnSelfAdvocacy => 'Disposition à l\'auto-défense';

  @override
  String get mnMedicationReceptivity => 'Réceptivité aux médicaments';

  @override
  String get mnTimelineTitle => 'Chronologie du bien-être';

  @override
  String get mnPeakWellnessYears => 'Années de bien-être optimal';

  @override
  String get mnExtraCareYears => 'Années nécessitant plus d\'auto-soin';

  @override
  String get mnTransformationWindows => 'Fenêtres de transformation positive';

  @override
  String get mnTherapyWindow => 'Fenêtre de thérapie recommandée';

  @override
  String get mnPracticesTitle => 'Pratiques quotidiennes de bien-être';

  @override
  String get mnMorningPractices => 'Pratiques matinales';

  @override
  String get mnEveningPractices => 'Pratiques du soir';

  @override
  String get mnBreathwork => 'Respiration';

  @override
  String get mnMovement => 'Mouvement';

  @override
  String get mnNutrition => 'Nutrition';

  @override
  String get mnNatureExposure => 'Besoin de contact avec la nature';

  @override
  String get mnDigitalDetox => 'Besoin de détox numérique';

  @override
  String get mnImprovementTitle => 'Plan d\'amélioration';

  @override
  String get mnReliabilityTitle => 'Fiabilité';

  @override
  String get mnLayerD1 => 'Thème de naissance (D1)';

  @override
  String get mnLayerD9 => 'Thème de l\'âme (D9)';

  @override
  String get mnLayerD30 => 'Thème D30';

  @override
  String get mnLayerDasha => 'Timing de la Dasha';

  @override
  String get mnLayerTransit => 'Transits';

  @override
  String get mnTopicResilience => 'Suis-je résilient émotionnellement ?';

  @override
  String get mnTopicCoping =>
      'Quelles sont mes meilleures stratégies d\'adaptation ?';

  @override
  String get mnTopicSleep => 'Comment puis-je améliorer mon sommeil ?';

  @override
  String get mnTopicBurnout => 'Suis-je à risque d\'épuisement professionnel ?';

  @override
  String get mnTopicTherapy => 'Quel style de thérapie me convient ?';

  @override
  String get mnTopicPractices =>
      'Quelles pratiques quotidiennes m\'aident le plus ?';

  @override
  String get mnTopicTiming =>
      'Quelles sont mes meilleures années de bien-être ?';

  @override
  String get mnTopicSupport =>
      'Comment construire un réseau de soutien solide ?';

  @override
  String get lgSubtitle => 'Rapport védique juridique propulsé par l\'IA';

  @override
  String get lgTitle => 'Juridique et litiges';

  @override
  String get lgSnapshotHeader => 'Aperçu juridique';

  @override
  String get lgResilience => 'Résilience juridique';

  @override
  String get lgResolutionCapacity => 'Capacité de résolution';

  @override
  String get lgVictoryPotential => 'Potentiel de victoire';

  @override
  String get lgLegalSafety => 'Sécurité juridique';

  @override
  String get lgNegotiationSkill => 'Compétence de négociation';

  @override
  String get lgStatusExcellent => 'Excellent';

  @override
  String get lgStatusStrong => 'Fort';

  @override
  String get lgStatusModerate => 'Modéré';

  @override
  String get lgStatusDeveloping => 'En développement';

  @override
  String get lgStatusChallenging => 'Difficile';

  @override
  String get lgChipResolver => 'Résolveur habile';

  @override
  String get lgChipWinner => 'Fortes chances de victoire';

  @override
  String get lgChipNegotiator => 'Négociateur naturel';

  @override
  String get lgChipDocumented => 'Bien documenté';

  @override
  String get lgChipLowRisk => 'Faible risque juridique';

  @override
  String get lgChipMoralAuthority => 'Autorité morale';

  @override
  String get lgChipLegalAptitude => 'Aptitude juridique';

  @override
  String get lgProfileTitle => 'Votre profil juridique et karma';

  @override
  String get lgPrimaryDriver => 'Moteur principal';

  @override
  String get lgDharmaAnchor => 'Ancre du dharma';

  @override
  String get lgAggressionMarker => 'Marqueur d\'agressivité';

  @override
  String get lgDocumentationKaraka => 'Qualité de la documentation';

  @override
  String get lgKarakaTitle => 'Vos planètes juridiques';

  @override
  String get lgKarakaSubtitle =>
      'Quelles planètes façonnent votre fortune juridique';

  @override
  String get lgYogasTitle => 'Yogas juridiques et protections';

  @override
  String get lgCurrentPhase => 'Phase actuelle';

  @override
  String get lgProtections => 'Protections';

  @override
  String get lgDisputePressures => 'Pressions liées aux litiges';

  @override
  String get lgVerificationTitle => 'Vérifié à travers les thèmes';

  @override
  String get lgD6Litigation => 'Thème de litige D6';

  @override
  String get lgD9Dharma => 'Thème du dharma D9';

  @override
  String get lgMoralAuthority => 'Autorité morale';

  @override
  String get lgVictoryTitle => 'Analyse de victoire';

  @override
  String get lgAsPlaintiff => 'En tant que plaignant';

  @override
  String get lgAsDefendant => 'En tant que défendeur';

  @override
  String get lgSettlementPreference =>
      'Préférence pour le règlement à l\'amiable';

  @override
  String get lgDisputeCategoriesTitle =>
      'Surveillance des catégories de litiges';

  @override
  String get lgLowRiskCategories => 'Catégories à faible risque';

  @override
  String get lgConflictStyleTitle => 'Style de conflit et ennemis';

  @override
  String get lgConfrontationComfort => 'Aisance face à la confrontation';

  @override
  String get lgArgumentPersuasiveness => 'Force de persuasion des arguments';

  @override
  String get lgEmotionalRegulation => 'Régulation émotionnelle';

  @override
  String get lgGrudgeHolding => 'Tendance à garder rancune';

  @override
  String get lgEnemyAnalysisLabel => 'Analyse des ennemis';

  @override
  String get lgVisibleEnemies => 'Ennemis visibles';

  @override
  String get lgHiddenEnemies => 'Ennemis cachés';

  @override
  String get lgWorkplaceEnemies => 'Ennemis au travail';

  @override
  String get lgFamilyEnemies => 'Ennemis familiaux';

  @override
  String get lgLegalEnemies => 'Ennemis juridiques';

  @override
  String get lgEnemyDefeatCapacity => 'Capacité à vaincre les ennemis';

  @override
  String get lgCriminalFinancialTitle =>
      'Surveillance des risques criminels et financiers';

  @override
  String get lgCriminalRisk => 'Risque d\'implication criminelle';

  @override
  String get lgVictimOfCrime => 'Probabilité d\'être victime d\'un crime';

  @override
  String get lgFalseAccusation => 'Risque de fausse accusation';

  @override
  String get lgImprisonmentRisk => 'Risque d\'emprisonnement';

  @override
  String get lgTaxDisputeRisk => 'Risque de litige fiscal';

  @override
  String get lgFinancialFraudRisk => 'Risque de fraude financière';

  @override
  String get lgBusinessLitigationRisk => 'Risque de litige commercial';

  @override
  String get lgBankruptcyRisk => 'Risque de faillite';

  @override
  String get lgAuditVulnerability => 'Vulnérabilité aux audits';

  @override
  String get lgProtectionPriority => 'Priorité de protection';

  @override
  String get lgContractsTitle => 'Contrats et négociation';

  @override
  String get lgContractClarity => 'Clarté contractuelle';

  @override
  String get lgDocumentationDiscipline => 'Rigueur documentaire';

  @override
  String get lgFinePrintAwareness =>
      'Attention aux clauses en petits caractères';

  @override
  String get lgSignatureCaution => 'Prudence à la signature';

  @override
  String get lgMediationReceptivity => 'Réceptivité à la médiation';

  @override
  String get lgNegotiationSkillFull => 'Compétence de négociation';

  @override
  String get lgCompromiseWillingness => 'Disposition au compromis';

  @override
  String get lgFaceSavingNeeds => 'Besoin de sauver la face';

  @override
  String get lgMediatorHireRecommendation =>
      'Recommandation d\'engager un médiateur';

  @override
  String get lgTypicalContractIssues => 'Problèmes contractuels typiques';

  @override
  String get lgCareerFitTitle => 'Adéquation à une carrière juridique';

  @override
  String get lgProfessionAffinity => 'Affinité professionnelle';

  @override
  String get lgRoleFit => 'Meilleur rôle adapté';

  @override
  String get lgLawStudentSuccess => 'Réussite en tant qu\'étudiant en droit';

  @override
  String get lgBarExamSuccess => 'Réussite à l\'examen du barreau';

  @override
  String get lgTimelineTitle => 'Chronologie juridique';

  @override
  String get lgNewMatterChance =>
      'Probabilité de nouvelle affaire (12 prochains mois)';

  @override
  String get lgOngoingCaseOutcome => 'Issue de l\'affaire en cours';

  @override
  String get lgRecommendedAction => 'Action recommandée';

  @override
  String get lgPeakDisputeYears => 'Années de pic de litiges';

  @override
  String get lgClarityYears => 'Années de clarté juridique';

  @override
  String get lgAvoidancePeriods => 'Périodes critiques à éviter';

  @override
  String get lgFavorableWindows => 'Fenêtres favorables à la résolution';

  @override
  String get lgRisksTitle => 'Risques et vulnérabilités';

  @override
  String get lgChronicVulnerabilities => 'Vulnérabilités chroniques';

  @override
  String get lgAvoidDashaPeriods => 'Périodes de Dasha à surveiller';

  @override
  String get lgPreventivePriorities => 'Priorités préventives';

  @override
  String get lgRedFlags => 'Situations à signaux d\'alerte';

  @override
  String get lgImprovementTitle => 'Plan d\'amélioration';

  @override
  String get lgReliabilityTitle => 'Fiabilité';

  @override
  String get lgLayerD1 => 'Thème de naissance (D1)';

  @override
  String get lgLayerD6 => 'Thème de litige (D6)';

  @override
  String get lgLayerD9 => 'Thème du dharma (D9)';

  @override
  String get lgLayerDasha => 'Timing de la Dasha';

  @override
  String get lgLayerTransit => 'Transits';

  @override
  String get lgTopicWinChance => 'Quelles sont mes chances de gagner ?';

  @override
  String get lgTopicStrategy =>
      'Quelle est la meilleure stratégie juridique pour moi ?';

  @override
  String get lgTopicContract => 'Quels risques contractuels surveiller ?';

  @override
  String get lgTopicTiming =>
      'Quel est le meilleur moment pour résoudre les litiges ?';

  @override
  String get lgTopicSettlement => 'Devrais-je transiger ou me battre ?';

  @override
  String get lgTopicEnemies => 'Qui sont mes ennemis cachés ?';

  @override
  String get lgTopicProtection => 'Comment me protéger juridiquement ?';

  @override
  String get lgTopicCareer => 'Suis-je fait pour une carrière juridique ?';

  @override
  String get prSubtitle => 'Rapport védique immobilier propulsé par l\'IA';

  @override
  String get prTitle => 'Immobilier et actifs';

  @override
  String get prSnapshotHeader => 'Aperçu immobilier';

  @override
  String get prAcquisitionCapacity => 'Capacité d\'acquisition';

  @override
  String get prHomeOwnership => 'Accession à la propriété';

  @override
  String get prWealthPotential => 'Potentiel de richesse';

  @override
  String get prRentalIncome => 'Revenu locatif';

  @override
  String get prLandOwnership => 'Propriété foncière';

  @override
  String get prStatusExcellent => 'Excellent';

  @override
  String get prStatusStrong => 'Fort';

  @override
  String get prStatusModerate => 'Modéré';

  @override
  String get prStatusDeveloping => 'En développement';

  @override
  String get prStatusChallenging => 'Difficile';

  @override
  String get prChipHomeOwner => 'Propriétaire immobilier';

  @override
  String get prChipWealthBuilder => 'Bâtisseur de richesse';

  @override
  String get prChipLandOwner => 'Propriétaire foncier';

  @override
  String get prChipInvestor => 'Investisseur immobilier';

  @override
  String get prChipInheritance => 'Héritage probable';

  @override
  String get prChipVehicle => 'Propriétaire de véhicule';

  @override
  String get prChipGlobalAsset => 'Affinité pour les actifs internationaux';

  @override
  String get prProfileTitle => 'Votre style immobilier';

  @override
  String get prHomeAesthetics => 'Esthétique du domicile';

  @override
  String get prHomeSanctuary => 'Le foyer comme sanctuaire';

  @override
  String get prComfortInvestment => 'Investissement dans le confort';

  @override
  String get prVastuPriority => 'Priorité au Vastu';

  @override
  String get prNaturalElements => 'Éléments naturels';

  @override
  String get prNextActionLabel => 'Prochaine action';

  @override
  String get prKarakaTitle => 'Vos planètes immobilières';

  @override
  String get prKarakaSubtitle =>
      'Quelles planètes façonnent votre chance immobilière';

  @override
  String get prPrimaryKaraka => 'Karaka principal';

  @override
  String get prDurableAsset => 'Karaka des actifs durables';

  @override
  String get prYogasTitle => 'Yogas et doshas immobiliers';

  @override
  String get prCurrentPhase => 'Phase actuelle';

  @override
  String get prBoosters => 'Amplificateurs';

  @override
  String get prDrains => 'Fuites';

  @override
  String get prVerificationTitle => 'Vérifié à travers les thèmes';

  @override
  String get prD4Property => 'Thème immobilier D4';

  @override
  String get prD16Vehicle => 'Thème des véhicules D16';

  @override
  String get prVehicleFit => 'Adéquation aux véhicules';

  @override
  String get prJourneyTitle => 'Parcours et chronologie de propriété';

  @override
  String get prFirstHomeAge => 'Âge du premier logement';

  @override
  String get prFirstHomeType => 'Type du premier logement';

  @override
  String get prMultipleHomes => 'Logements multiples';

  @override
  String get prNewPropertySoon => 'Nouvelle propriété prochainement';

  @override
  String get prFirstMajorWindow => 'Première grande fenêtre';

  @override
  String get prBuyingWindow => 'Fenêtre d\'achat';

  @override
  String get prConstructionWindow => 'Fenêtre de construction';

  @override
  String get prNextOpportunity => 'Prochaine opportunité';

  @override
  String get prLifetimePropertyCount => 'Nombre de propriétés sur la vie';

  @override
  String get prInheritanceTitle => 'Héritage et propriété familiale';

  @override
  String get prMaternalInheritance => 'Héritage maternel';

  @override
  String get prPaternalInheritance => 'Héritage paternel';

  @override
  String get prAncestralProperty => 'Propriété ancestrale';

  @override
  String get prFamilyDisputeRisk => 'Risque de litige familial';

  @override
  String get prInheritanceTiming => 'Timing de l\'héritage';

  @override
  String get prInheritanceType => 'Type d\'héritage';

  @override
  String get prLandInvestTitle =>
      'Terrain, investissement et propriété internationale';

  @override
  String get prPropertyInvestor => 'Score d\'investisseur immobilier';

  @override
  String get prAppreciationLuck => 'Chance de plus-value';

  @override
  String get prInvestorMindset => 'Mentalité d\'investisseur';

  @override
  String get prLandType => 'Type de terrain';

  @override
  String get prRentalCount => 'Nombre de biens locatifs';

  @override
  String get prMultipleLand => 'Parcelles de terrain multiples';

  @override
  String get prFarmEstate => 'Probabilité de ferme/domaine';

  @override
  String get prGlobalPropertyLabel => 'Propriété internationale';

  @override
  String get prForeignProperty => 'Propriété à l\'étranger';

  @override
  String get prNriAffinity => 'Affinité d\'actifs NRI (non-résident indien)';

  @override
  String get prVehiclesTitle => 'Véhicules';

  @override
  String get prVehicleCount => 'Nombre de véhicules';

  @override
  String get prVehicleFirstAge => 'Âge du premier véhicule';

  @override
  String get prVehicleCategory => 'Catégorie de véhicule';

  @override
  String get prVehicleQuality => 'Qualité du véhicule';

  @override
  String get prLuxuryAffinity => 'Affinité pour le luxe';

  @override
  String get prVehicleLossRisk => 'Risque de perte/dommage du véhicule';

  @override
  String get prLegalRiskTitle => 'Surveillance juridique et des risques';

  @override
  String get prBoundaryDisputes => 'Litiges de bornage';

  @override
  String get prPartitionDisputes => 'Litiges de partage';

  @override
  String get prTitleIssues => 'Problèmes de titre/documentation';

  @override
  String get prTenantConflict => 'Conflit locataire-propriétaire';

  @override
  String get prForcedSale => 'Risque de vente forcée';

  @override
  String get prPropertyDamage => 'Risque de dommage immobilier';

  @override
  String get prInsurancePriority => 'Priorité d\'assurance';

  @override
  String get prProtectionUrgency => 'Urgence de protection';

  @override
  String get prProtectiveFactors => 'Facteurs protecteurs';

  @override
  String get prChronicVulnerabilities => 'Vulnérabilités chroniques';

  @override
  String get prDueDiligenceTitle => 'Liste de vérification préalable';

  @override
  String get prPreventiveMeasures => 'Mesures préventives';

  @override
  String get prImprovementTitle => 'Plan d\'amélioration';

  @override
  String get prReliabilityTitle => 'Fiabilité';

  @override
  String get prLayerD1 => 'Thème de naissance (D1)';

  @override
  String get prLayerD4 => 'Thème immobilier (D4)';

  @override
  String get prLayerD16 => 'Thème des véhicules (D16)';

  @override
  String get prLayerDasha => 'Timing de la Dasha';

  @override
  String get prLayerTransit => 'Transits';

  @override
  String get prTopicBuying => 'Meilleur moment pour acheter ?';

  @override
  String get prTopicInherit => 'Vais-je hériter d\'un bien ?';

  @override
  String get prTopicVehicle => 'Quand vais-je acquérir un véhicule ?';

  @override
  String get prTopicRental => 'Potentiel de revenu locatif ?';

  @override
  String get prTopicLand => 'Chances de propriété foncière ?';

  @override
  String get prTopicLegal => 'Risques juridiques à surveiller ?';

  @override
  String get prTopicForeign => 'Chances de propriété à l\'étranger ?';

  @override
  String get prTopicTiming => 'Meilleures fenêtres de timing immobilier ?';

  @override
  String get edTitle => 'Analyse de l\'éducation et de l\'apprentissage';

  @override
  String get edSubtitle => 'Rapport védique de l\'éducation propulsé par l\'IA';

  @override
  String get edSnapshotHeader => 'Aperçu de votre éducation';

  @override
  String get edOverallStrength => 'Force globale';

  @override
  String get edAcademicSuccess => 'Réussite académique';

  @override
  String get edLearningCapacity => 'Capacité d\'apprentissage';

  @override
  String get edIntellect => 'Intellect';

  @override
  String get edMemory => 'Mémoire';

  @override
  String get edStatusExcellent => 'Potentiel excellent';

  @override
  String get edStatusStrong => 'Fort potentiel';

  @override
  String get edStatusModerate => 'Potentiel modéré';

  @override
  String get edStatusDeveloping => 'Potentiel en développement';

  @override
  String get edStatusChallenging => 'Phase difficile';

  @override
  String get edChipSaraswati => 'Saraswati Yoga';

  @override
  String get edChipGajaKesari => 'Gaja Kesari Yoga';

  @override
  String get edChipBudhaAditya => 'Budha Aditya Yoga';

  @override
  String get edChipResearch => 'Forte capacité de recherche';

  @override
  String get edChipScholarship => 'Potentiel de bourse d\'études';

  @override
  String get edChipDoctorate => 'Potentiel de doctorat';

  @override
  String get edChipForeign => 'Soutien à l\'éducation à l\'étranger';

  @override
  String get edChipLifelong => 'Apprenant à vie';

  @override
  String get edLearningStyleTitle => 'Votre style d\'apprentissage';

  @override
  String get edSoulPlanet => 'Planète de l\'âme';

  @override
  String get edSoulHint =>
      'Votre motivation intérieure la plus profonde et objectif de vie';

  @override
  String get edSubjectPlanet => 'Planète des matières';

  @override
  String get edTechAtmakaraka => 'Atmakaraka (technique)';

  @override
  String get edTechAmatyakaraka => 'Amatyakaraka (technique)';

  @override
  String get edSubjectKarakaStrength => 'Force du Karaka des matières';

  @override
  String get edFoundationTitle => 'Fondation éducative';

  @override
  String get edHouse4 => 'Scolarité précoce';

  @override
  String get edHouse5 => 'Intelligence';

  @override
  String get edHouse9 => 'Enseignement supérieur';

  @override
  String get edPurvaPunya => 'Mérite de vie antérieure';

  @override
  String get edStudyPlanetsTitle => 'Vos planètes d\'étude';

  @override
  String get edYogasTitle => 'Yogas éducatifs dans votre thème';

  @override
  String get edYogaBudhaAditya => 'Budha Aditya';

  @override
  String get edYogaGajaKesari => 'Gaja Kesari';

  @override
  String get edYogaSaraswati => 'Saraswati';

  @override
  String get edYogaPresent => 'Présent';

  @override
  String get edYogaAbsent => 'Absent';

  @override
  String get edYogaNoneNote =>
      'Aucun yoga éducatif classique — le succès viendra d\'un effort constant et de la discipline.';

  @override
  String get edVerificationTitle => 'Vérification à travers les thèmes';

  @override
  String get edD24Learning => 'D24 — Thème d\'apprentissage approfondi';

  @override
  String get edD4Formal => 'D4 — Thème de l\'éducation formelle';

  @override
  String get edD9Dharma => 'D9 — Thème du dharma d\'apprentissage';

  @override
  String get edD60Karma => 'D60 — Karma d\'apprentissage de vie antérieure';

  @override
  String get edSubjectsTitle => 'Meilleures matières pour vous';

  @override
  String get edSubjectsSubtitle => 'Classées par affinité du thème';

  @override
  String get edLowAffinity => 'Matières à moindre affinité';

  @override
  String get edDegreesTitle => 'Probabilité de diplôme et de niveau';

  @override
  String get edExpectedLevel => 'Niveau attendu';

  @override
  String get edDegreeFormal => 'Diplôme formel';

  @override
  String get edDegreePostgrad => 'Études supérieures';

  @override
  String get edDegreeDoctorate => 'Doctorat';

  @override
  String get edDegreeForeign => 'Éducation à l\'étranger';

  @override
  String get edTimelineTitle => 'Chronologie des études';

  @override
  String get edEarlySchooling => 'Fenêtre de scolarité précoce';

  @override
  String get edHigherEducation => 'Fenêtre d\'enseignement supérieur';

  @override
  String get edPostgradResearch => 'Fenêtre d\'études supérieures/recherche';

  @override
  String get edPeakLearningAge => 'Âge d\'apprentissage optimal';

  @override
  String get edPreferencesTitle => 'Préférences d\'apprentissage et soutien';

  @override
  String get edPrefStudyMode => 'Mode d\'étude';

  @override
  String get edPrefTiming => 'Meilleur moment';

  @override
  String get edPrefEnvironment => 'Environnement';

  @override
  String get edPrefLocation => 'Lieu';

  @override
  String get edPrefForeign => 'Étude à l\'étranger';

  @override
  String get edGuruRelationship => 'Lien avec l\'enseignant/gourou';

  @override
  String get edMentorAvailability => 'Disponibilité de mentor';

  @override
  String get edPeerLearning => 'Apprentissage entre pairs';

  @override
  String get edAuthorityDeference => 'Respect de l\'autorité';

  @override
  String get edStrengthsTitle => 'Forces et défis';

  @override
  String get edCognitiveGifts => 'Dons cognitifs';

  @override
  String get edNaturalAbilities => 'Capacités d\'apprentissage naturelles';

  @override
  String get edHiddenCapacities => 'Capacités cachées';

  @override
  String get edConcentration => 'Difficulté de concentration';

  @override
  String get edBreakRisk => 'Risque d\'interruption des études';

  @override
  String get edDisciplineConsistency => 'Constance dans la discipline';

  @override
  String get edScholarshipLikelihood => 'Probabilité de bourse d\'études';

  @override
  String get edCareerLinkTitle => 'Éducation → parcours professionnel';

  @override
  String get edDirectionRec => 'Direction recommandée';

  @override
  String get edIntegrationStrategy => 'Stratégie d\'intégration';

  @override
  String get edCareerLinkage => 'Lien avec la carrière';

  @override
  String get edAlignedSubjects => 'Matières alignées avec la carrière';

  @override
  String get edDegreeUtility => 'Utilité du diplôme pour la carrière';

  @override
  String get edImprovementTitle => 'Votre plan d\'amélioration';

  @override
  String get edReliabilityTitle => 'Fiabilité de la prédiction';

  @override
  String get edLayerD1 => 'Thème de naissance (D1)';

  @override
  String get edLayerD4 => 'Éducation formelle (D4)';

  @override
  String get edLayerD9 => 'Navamsa (D9)';

  @override
  String get edLayerD24 => 'Apprentissage approfondi (D24)';

  @override
  String get edLayerD60 => 'Apprentissage de vie antérieure (D60)';

  @override
  String get edLayerAmk => 'Karaka des matières';

  @override
  String get edLayerMj => 'Mercure-Jupiter';

  @override
  String get edLayerDasha => 'Timing planétaire';

  @override
  String get edTopicSubjects => 'Meilleures matières pour moi';

  @override
  String get edTopicDegree => 'Chances de diplôme';

  @override
  String get edTopicAbroad => 'Étudier à l\'étranger';

  @override
  String get edTopicExam => 'Performance aux examens';

  @override
  String get edTopicHabits => 'Habitudes d\'étude';

  @override
  String get edTopicCareerLink => 'Lien entre éducation et carrière';

  @override
  String get edTopicTiming => 'Fenêtres de timing éducatif';

  @override
  String get edTopicScholarship => 'Chances de bourse d\'études';

  @override
  String get hwTitle => 'Analyse de santé et bien-être';

  @override
  String get hwSubtitle =>
      'Rapport védique de santé et bien-être propulsé par l\'IA';

  @override
  String get hwSnapshotHeader => 'Aperçu de votre santé';

  @override
  String get hwOverallVitality => 'Vitalité';

  @override
  String get hwImmunity => 'Immunité';

  @override
  String get hwRecovery => 'Récupération';

  @override
  String get hwMentalWellness => 'Bien-être mental';

  @override
  String get hwStressTolerance => 'Tolérance au stress';

  @override
  String get hwStatusThriving => 'Épanoui';

  @override
  String get hwStatusGood => 'Bonne vitalité';

  @override
  String get hwStatusBalanced => 'Équilibré';

  @override
  String get hwStatusNeedsCare => 'Besoin de soin';

  @override
  String get hwStatusNeedsAttention => 'Besoin d\'attention';

  @override
  String get hwChipImmunity => 'Forte immunité';

  @override
  String get hwChipRecovery => 'Récupération rapide';

  @override
  String get hwChipMentalBalance => 'Esprit équilibré';

  @override
  String get hwChipStressResilience => 'Résilient au stress';

  @override
  String get hwChipFertility => 'Soutien à la fertilité';

  @override
  String get hwChipWorkLife => 'Bon équilibre vie professionnelle-personnelle';

  @override
  String get hwChipLowAddiction => 'Faible risque de dépendance';

  @override
  String get hwConstitutionTitle => 'Votre type corporel';

  @override
  String get hwConstitutionSubtitle =>
      'Constitution ayurvédique selon votre thème';

  @override
  String get hwDominantDosha => 'Dominant';

  @override
  String get hwSecondaryDosha => 'Secondaire';

  @override
  String get hwPrimaryKaraka => 'Principal indicateur de santé';

  @override
  String get hwStrongestSystem => 'Système le plus fort';

  @override
  String get hwWeakestSystem => 'Système à soutenir';

  @override
  String get hwBodyMapTitle => 'La carte planétaire de votre corps';

  @override
  String get hwBodyMapSubtitle => '9 planètes, 9 systèmes corporels';

  @override
  String get hwYogaTitle => 'Schémas de santé dans votre thème';

  @override
  String get hwYogaSubtitle =>
      'Yogas protecteurs vs yogas de pression pathologique';

  @override
  String get hwDiseasePressureLabel => 'PRESSION PATHOLOGIQUE';

  @override
  String get hwAreasTitle => 'Zones corporelles à surveiller';

  @override
  String get hwAreasSubtitle => 'Vulnérabilité par zone corporelle';

  @override
  String get hwProtectedAreas => 'Zones bien protégées';

  @override
  String get hwCategoriesTitle => 'Surveillance des catégories de maladies';

  @override
  String get hwCategoriesSubtitle =>
      'Susceptibilité selon les principales catégories de santé';

  @override
  String get hwLowRiskCategories => 'Catégories à faible risque';

  @override
  String get hwMentalTitle => 'Bien-être mental et émotionnel';

  @override
  String get hwMentalSubtitle =>
      'Résilience émotionnelle et besoins de soutien';

  @override
  String get hwMentalVulnerability => 'Sensibilité émotionnelle';

  @override
  String get hwEmotionalRegulation => 'Régulation émotionnelle';

  @override
  String get hwSupportRec => 'Recommandation de soutien';

  @override
  String get hwTendencies => 'Tendances mentales';

  @override
  String get hwTimelineTitle => 'Chronologie de santé';

  @override
  String get hwTimelineSubtitle =>
      'Années de pic, années de prudence et fenêtres de récupération';

  @override
  String get hwPeakYears => 'Années de bien-être optimal';

  @override
  String get hwCautionYears => 'Années de prudence';

  @override
  String get hwRecoveryWindow => 'Fenêtre de récupération';

  @override
  String get hwCheckupYears => 'Années recommandées pour un bilan de santé';

  @override
  String get hwCurrentPhase => 'Phase actuelle';

  @override
  String get hwLifestyleTitle => 'Votre guide de mode de vie';

  @override
  String get hwLifestyleSubtitle =>
      'Ce que votre thème dit sur vos habitudes quotidiennes';

  @override
  String get hwSleepDiscipline => 'Impact de la discipline du sommeil';

  @override
  String get hwDietDiscipline => 'Impact de la discipline alimentaire';

  @override
  String get hwExerciseNeed => 'Besoin d\'exercice';

  @override
  String get hwSunlightNeed => 'Besoin d\'exposition solaire';

  @override
  String get hwStressSusceptibility => 'Susceptibilité au stress';

  @override
  String get hwHydrationSensitivity => 'Sensibilité à l\'hydratation';

  @override
  String get hwSocialType => 'Type d\'énergie sociale';

  @override
  String get hwHealingSpeed => 'Vitesse de guérison';

  @override
  String get hwTreatmentResponse => 'Réponse au traitement';

  @override
  String get hwAltHealing => 'Affinité pour la guérison alternative';

  @override
  String get hwSpecialTitle => 'Étapes de vie et sujets particuliers';

  @override
  String get hwSpecialSubtitle =>
      'Fertilité, santé infantile, habitudes et épuisement professionnel';

  @override
  String get hwFertility => 'Indicateur de fertilité';

  @override
  String get hwHormonalBalance => 'Équilibre hormonal';

  @override
  String get hwReproductiveStrength => 'Force du système reproducteur';

  @override
  String get hwChildhoodVuln => 'Vulnérabilité de santé infantile';

  @override
  String get hwChildhoodStatus => 'Santé infantile';

  @override
  String get hwAddictionVuln => 'Vulnérabilité à la dépendance';

  @override
  String get hwAddictionRecovery => 'Capacité de rétablissement';

  @override
  String get hwBurnoutVuln => 'Vulnérabilité à l\'épuisement professionnel';

  @override
  String get hwWorkLifeBalance => 'Équilibre vie professionnelle-personnelle';

  @override
  String get hwStressTriggers => 'Déclencheurs de stress';

  @override
  String get hwProtectiveFactors => 'Facteurs protecteurs';

  @override
  String get hwChallengesTitle => 'Défis à surveiller';

  @override
  String get hwChallengesSubtitle => 'Où concentrer les soins préventifs';

  @override
  String get hwMitigation => 'Comment gérer';

  @override
  String get hwChronicAreas => 'Zones de vulnérabilité chronique';

  @override
  String get hwPreventivePriorities => 'Priorités préventives';

  @override
  String get hwImprovementTitle => 'Votre plan de bien-être';

  @override
  String get hwImprovementSubtitle =>
      'Étapes pratiques et remèdes traditionnels';

  @override
  String get hwReliabilityTitle => 'Fiabilité de la lecture';

  @override
  String get hwLayerD1 => 'Thème de naissance (D1)';

  @override
  String get hwLayerD6 => 'Thème de santé (D6)';

  @override
  String get hwLayerD30 => 'Thème de micro-santé (D30)';

  @override
  String get hwLayerDasha => 'Timing planétaire';

  @override
  String get hwLayerTransit => 'Transits actuels';

  @override
  String get hwDisclaimerLabel => 'Avertissement médical';

  @override
  String get hwTopicImmunity => 'Renforcer l\'immunité';

  @override
  String get hwTopicSleep => 'Sommeil et repos';

  @override
  String get hwTopicStress => 'Gérer le stress';

  @override
  String get hwTopicFertility => 'Timing de la fertilité';

  @override
  String get hwTopicDiet => 'Alimentation et nutrition';

  @override
  String get hwTopicTiming => 'Fenêtres de timing santé';

  @override
  String get hwTopicMental => 'Bien-être mental';

  @override
  String get hwTopicPrevention => 'Plan de soins préventifs';

  @override
  String get lvSubtitle => 'Rapport védique amoureux propulsé par l\'IA';

  @override
  String get lvTitle => 'Amour et relations';

  @override
  String get lvLovePotential => 'Potentiel amoureux';

  @override
  String get lvEmotionalAvail => 'Ouverture émotionnelle';

  @override
  String get lvAttraction => 'Attirance';

  @override
  String get lvCommitment => 'Engagement';

  @override
  String get lvCommunication => 'Communication';

  @override
  String get lvFidelity => 'Loyauté';

  @override
  String get lvChipLoyal => 'Cœur loyal';

  @override
  String get lvChipOpenHeart => 'Cœur ouvert';

  @override
  String get lvChipCommunicator => 'Excellent communicateur';

  @override
  String get lvChipMature => 'Gère bien les conflits';

  @override
  String get lvChipEmotionallyWise => 'Émotionnellement sage';

  @override
  String get lvLoveStyle => 'Votre style amoureux';

  @override
  String get lvAttractionStyle => 'Style d\'attirance';

  @override
  String get lvLangGiven => 'Vous exprimez l\'amour par';

  @override
  String get lvLangReceived => 'Vous vous sentez aimé par';

  @override
  String get lvLovePlanets => 'Vos planètes amoureuses';

  @override
  String get lvLoveKaraka => 'Amour';

  @override
  String get lvEmotionKaraka => 'Émotion';

  @override
  String get lvPassionKaraka => 'Passion';

  @override
  String get lvPathToLove => 'Votre chemin vers l\'amour';

  @override
  String get lvPathSub => 'Amour vs mariage arrangé';

  @override
  String get lvLoveMarriage => 'Mariage d\'amour';

  @override
  String get lvArrangedMarriage => 'Mariage arrangé';

  @override
  String get lvParentalAccept => 'Acceptation parentale';

  @override
  String get lvInterCaste => 'Inter-caste / religion';

  @override
  String get lvIdealPartner => 'Votre partenaire idéal';

  @override
  String get lvPersonality => 'Personnalité';

  @override
  String get lvAppearance => 'Apparence';

  @override
  String get lvIdealTraits => 'Traits idéaux';

  @override
  String get lvWhatMatters => 'Ce qui compte le plus';

  @override
  String get lvDrawnTo => 'Attiré par';

  @override
  String get lvDealbreakers => 'Éléments rédhibitoires';

  @override
  String get lvYourAppeal => 'Votre attrait';

  @override
  String get lvLoveStory => 'Votre histoire d\'amour';

  @override
  String get lvLoveStorySub => 'Schémas relationnels';

  @override
  String get lvFirstLove => 'Premier amour';

  @override
  String get lvRelationCount => 'Liens significatifs';

  @override
  String get lvDuration => 'Durée typique';

  @override
  String get lvDepth => 'Profondeur émotionnelle';

  @override
  String get lvDatingPattern => 'Schéma de fréquentation';

  @override
  String get lvCommitIntimacy => 'Engagement et intimité';

  @override
  String get lvCommitReady => 'Disposition à l\'engagement';

  @override
  String get lvIntimacyDrive => 'Besoin d\'intimité';

  @override
  String get lvSensuality => 'Sensualité';

  @override
  String get lvEmpathy => 'Empathie';

  @override
  String get lvCommitStyle => 'Style d\'engagement';

  @override
  String get lvChemistry => 'Style d\'alchimie';

  @override
  String get lvMakesCommit => 'Ce qui vous pousse à vous engager';

  @override
  String get lvMakesFlee => 'Ce qui vous fait fuir';

  @override
  String get lvEmotional => 'Intelligence émotionnelle';

  @override
  String get lvEmotionalIQ => 'QI émotionnel';

  @override
  String get lvConflictStyle => 'Style de conflit';

  @override
  String get lvTiming => 'Timing amoureux';

  @override
  String get lvNewLove12 => 'Nouvel amour dans 12 mois';

  @override
  String get lvEnergyNow => 'Énergie actuelle';

  @override
  String get lvPhaseNow => 'Phase actuelle';

  @override
  String get lvPeakRomance => 'Années romantiques optimales';

  @override
  String get lvNewLoveWindow => 'Fenêtre de nouvel amour';

  @override
  String get lvChallenges => 'Défis à surveiller';

  @override
  String get lvRiskHeartbreak => 'Vulnérabilité aux chagrins d\'amour';

  @override
  String get lvRiskSabotage => 'Auto-sabotage';

  @override
  String get lvRiskCommitFear => 'Peur de l\'engagement';

  @override
  String get lvRiskRepeat => 'Schémas répétitifs';

  @override
  String get lvRiskWorkaholic => 'Travail avant l\'amour';

  @override
  String get lvRedFlags => 'Signaux d\'alerte à surveiller';

  @override
  String get lvHealing => 'Ce qu\'il faut guérir';

  @override
  String get lvFocusArea => 'Domaine de focus';

  @override
  String get lvHealDir => 'Direction de guérison';

  @override
  String get lvImprovementPlan => 'Plan d\'amélioration';

  @override
  String get lvReliability => 'Fiabilité de la prédiction';

  @override
  String get lvLayerBirth => 'Thème de naissance (D1)';

  @override
  String get lvLayerNavamsa => 'Navamsa (D9)';

  @override
  String get lvLayerSaptamsa => 'Saptamsa (D7)';

  @override
  String get lvLayerDasha => 'Timing de la Dasha';

  @override
  String get lvLayerTransit => 'Transits actuels';

  @override
  String get lvTopicWhen => 'Quand trouverai-je l\'amour ?';

  @override
  String get lvTopicSoulmate => 'À propos de mon âme sœur';

  @override
  String get lvTopicCurrent => 'Ma relation actuelle';

  @override
  String get lvTopicHeal => 'Guérir du passé';

  @override
  String get lvTopicCommit => 'Aide à l\'engagement';

  @override
  String get lvTopicLoveVsArranged => 'Amour vs mariage arrangé';

  @override
  String get lvTopicHeartbreak => 'Éviter les chagrins d\'amour';

  @override
  String get lvTopicConfidence => 'Confiance en amour';

  @override
  String get mrSubtitle => 'Rapport védique de mariage propulsé par l\'IA';

  @override
  String get mrTitle => 'Mariage et famille';

  @override
  String get mrMarriagePotential => 'Potentiel de mariage';

  @override
  String get mrHarmony => 'Harmonie';

  @override
  String get mrLongevity => 'Longévité';

  @override
  String get mrSatisfaction => 'Satisfaction';

  @override
  String get mrStability => 'Stabilité familiale';

  @override
  String get mrClarity => 'Clarté';

  @override
  String get mrChipHarmony => 'Lien harmonieux';

  @override
  String get mrChipNoMangal => 'Aucun Mangal dosh';

  @override
  String get mrChipLongLasting => 'Durable';

  @override
  String get mrChipHome => 'Propriété probable';

  @override
  String get mrChipInLaws => 'Bonne belle-famille';

  @override
  String get mrChipChildren => 'Enfants bénis';

  @override
  String get mrSpouse => 'Votre futur conjoint';

  @override
  String get mrSpouseSub => 'Ce que le thème suggère';

  @override
  String get mrSpouseTraits => 'Personnalité probable';

  @override
  String get mrSpouseWork => 'Profession probable';

  @override
  String get mrAgeDiff => 'Différence d\'âge';

  @override
  String get mrCulture => 'Compatibilité culturelle';

  @override
  String get mrEducation => 'Éducation';

  @override
  String get mrFamilyBg => 'Origine familiale';

  @override
  String get mrSoulPartnership => 'Âme et partenariat';

  @override
  String get mrSelfPlanet => 'Vous dans une relation';

  @override
  String get mrSpousePlanet => 'Votre planète du conjoint';

  @override
  String get mrSoulAlignment => 'Alignement de l\'âme';

  @override
  String get mrAlignStrong =>
      'Votre âme et votre partenaire idéal sont fortement alignés — un lien profondément épanouissant est bien soutenu.';

  @override
  String get mrAlignModerate =>
      'Votre âme et votre partenaire idéal sont modérément alignés — un lien épanouissant se développe avec un effort conscient.';

  @override
  String get mrAlignLow =>
      'Votre âme et votre partenariat nécessitent une intégration consciente — choisissez un partenaire qui correspond véritablement à vos valeurs profondes.';

  @override
  String get mrTechDarakaraka => 'Planète du conjoint (Darakaraka)';

  @override
  String get mrUpapada => 'Point de mariage (Upapada)';

  @override
  String get mrUpapadaLord => 'Maître de l\'Upapada';

  @override
  String get mrFoundation => 'Fondation du mariage';

  @override
  String get mrMarriageSign => 'Signe du mariage';

  @override
  String get mrMarriageLord => 'Maître du mariage';

  @override
  String get mrHouseStrength => 'Force de la maison';

  @override
  String get mrPartnerHint => 'Indice sur le partenaire selon votre thème';

  @override
  String get mrHarmonyHdr => 'Harmonie de compatibilité';

  @override
  String get mrHarmonySub => 'Comment vous vous connecterez';

  @override
  String get mrEmotional => 'Émotionnel';

  @override
  String get mrIntellectual => 'Intellectuel';

  @override
  String get mrPhysical => 'Intimité physique';

  @override
  String get mrFinancial => 'Financier';

  @override
  String get mrCommunication => 'Communication';

  @override
  String get mrSharedValues => 'Valeurs partagées';

  @override
  String get mrSpiritual => 'Spirituel';

  @override
  String get mrConflictRes => 'Résolution des conflits';

  @override
  String get mrTiming => 'Timing du mariage';

  @override
  String get mrFirstMarriageAge => 'Âge de mariage probable';

  @override
  String get mrDelayChance => 'Probabilité de retard';

  @override
  String get mrMarriageWindow => 'Fenêtre de mariage';

  @override
  String get mrSecondaryWindow => 'Fenêtre alternative';

  @override
  String get mrCurrentReadiness => 'En ce moment';

  @override
  String get mrJourney => 'Parcours du mariage';

  @override
  String get mrJourneySub => 'Comment le lien évolue';

  @override
  String get mrPhaseEarly => 'Premières années';

  @override
  String get mrPhaseMid => 'Années intermédiaires';

  @override
  String get mrPhaseMature => 'Années matures';

  @override
  String get mrPhaseLate => 'Dernières années';

  @override
  String get mrTip => 'Conseil';

  @override
  String get mrFamilyHome => 'Famille et foyer';

  @override
  String get mrInLaws => 'Relations avec la belle-famille';

  @override
  String get mrFamilyHarmony => 'Harmonie familiale';

  @override
  String get mrHomeOwnership => 'Accession à la propriété';

  @override
  String get mrDomesticPeace => 'Paix domestique';

  @override
  String get mrFertility => 'Fertilité';

  @override
  String get mrParenting => 'Harmonie parentale';

  @override
  String get mrChildren => 'Enfants';

  @override
  String get mrLikelyCount => 'Nombre probable';

  @override
  String get mrVerification => 'Vérification croisée des thèmes';

  @override
  String get mrD9 => 'Thème du mariage (D9)';

  @override
  String get mrD10 => 'Thème carrière-conjoint (D10)';

  @override
  String get mrD60 => 'Thème du karma (D60)';

  @override
  String get mrChallenges => 'Défis à surveiller';

  @override
  String get mrMangalPresent =>
      'Le Mangal Dosh est présent dans le thème — examinez attentivement les remèdes et la compatibilité.';

  @override
  String get mrMangalAbsent =>
      'Aucun Mangal Dosh détecté — un indicateur favorable au mariage.';

  @override
  String get mrRiskConflict => 'Conflit';

  @override
  String get mrRiskSeparation => 'Séparation';

  @override
  String get mrRiskDistance => 'Distance émotionnelle';

  @override
  String get mrRiskInfidelity => 'Infidélité';

  @override
  String get mrRiskFinance => 'Désaccords financiers';

  @override
  String get mrPartnerGuide => 'Guide du partenaire';

  @override
  String get mrPartnerGuideSub => 'Ce qu\'il faut rechercher';

  @override
  String get mrSeek => 'Recherchez';

  @override
  String get mrMatchingPriorities => 'Priorités de compatibilité';

  @override
  String get mrImprovementPlan => 'Plan d\'amélioration';

  @override
  String get mrReliability => 'Fiabilité de la prédiction';

  @override
  String get mrLayerBirth => 'Thème de naissance (D1)';

  @override
  String get mrLayerNavamsa => 'Navamsa (D9)';

  @override
  String get mrLayerDashamsa => 'Dashamsa (D10)';

  @override
  String get mrLayerShashtiamsa => 'Karma (D60)';

  @override
  String get mrLayerDarakaraka => 'Planète du conjoint';

  @override
  String get mrTopicWhen => 'Quand vais-je me marier ?';

  @override
  String get mrTopicSpouse => 'À propos de mon conjoint';

  @override
  String get mrTopicCompat => 'Conseils de compatibilité';

  @override
  String get mrTopicDelay => 'Retard de mariage';

  @override
  String get mrTopicMangal => 'Mangal dosh';

  @override
  String get mrTopicChildren => 'Timing des enfants';

  @override
  String get mrTopicInLaws => 'Relations avec la belle-famille';

  @override
  String get mrTopicHarmony => 'Construire l\'harmonie';

  @override
  String get wlSubtitle => 'Rapport védique de richesse propulsé par l\'IA';

  @override
  String get wlTitle => 'Richesse et finance';

  @override
  String get wlWealthPotential => 'Potentiel de richesse';

  @override
  String get wlAccumulation => 'Accumulation';

  @override
  String get wlIncomeFlow => 'Flux de revenus';

  @override
  String get wlRetention => 'Rétention';

  @override
  String get wlSustainability => 'Durabilité';

  @override
  String get wlSavings => 'Discipline d\'épargne';

  @override
  String get wlChipSaver => 'Épargnant naturel';

  @override
  String get wlChipMultiIncome => 'Revenus multiples';

  @override
  String get wlChipStrongYogas => 'Yogas de richesse';

  @override
  String get wlChipLowDebt => 'Faible endettement';

  @override
  String get wlChipInheritance => 'Héritage probable';

  @override
  String get wlChipInvestor => 'Investisseur avisé';

  @override
  String get wlWealthClass => 'Classe de richesse';

  @override
  String get wlWealthType => 'Type de richesse principal';

  @override
  String get wlPrimarySource => 'Revenu principal';

  @override
  String get wlPeakAge => 'Âge de richesse maximale';

  @override
  String get wlBoosters => 'Ce qui stimule votre richesse';

  @override
  String get wlBoostersSub => 'Combinaisons financières puissantes';

  @override
  String get wlWealthImpact => 'élan';

  @override
  String get wlDrains => 'Fuites de richesse';

  @override
  String get wlIncomeSources => 'Sources de revenus';

  @override
  String get wlIncomeSourcesSub => 'D\'où vient votre argent';

  @override
  String get wlPrimary => 'Principal';

  @override
  String get wlInvestment => 'Plan d\'investissement';

  @override
  String get wlInvestmentSub => 'Répartition d\'actifs idéale';

  @override
  String get wlRiskAppetite => 'Appétit pour le risque';

  @override
  String get wlInvestStyle => 'Style d\'investissement';

  @override
  String get wlDrivenBy => 'Motivé par';

  @override
  String get wlMoneyPersonality => 'Personnalité financière';

  @override
  String get wlMoneyType => 'Type d\'argent';

  @override
  String get wlSpending => 'Dépenses';

  @override
  String get wlSavingsDiscipline => 'Discipline d\'épargne';

  @override
  String get wlCharity => 'Inclination caritative';

  @override
  String get wlLuxury => 'Dépenses de luxe';

  @override
  String get wlWindfalls => 'Gains inattendus et opportunités';

  @override
  String get wlWindfallsSub => 'Argent lié à la chance';

  @override
  String get wlInheritanceChance => 'Héritage';

  @override
  String get wlSuddenGains => 'Gains soudains';

  @override
  String get wlLottery => 'Loterie/spéculation';

  @override
  String get wlInsurance => 'Réclamations d\'assurance';

  @override
  String get wlWindfallSource => 'Source probable de gain inattendu';

  @override
  String get wlMoneyPlanets => 'Vos planètes financières';

  @override
  String get wlPrimaryKaraka => 'Planète financière principale';

  @override
  String get wlSecondaryKaraka => 'Planète financière secondaire';

  @override
  String get wlTimeline => 'Chronologie de richesse';

  @override
  String get wlPeakYears => 'Années de pic';

  @override
  String get wlGoodPeriod => 'Période prospère';

  @override
  String get wlSuddenGainWindow => 'Fenêtre de gain soudain';

  @override
  String get wlToughPeriod => 'Période de prudence';

  @override
  String get wlDebtRisks => 'Risques de dette et financiers';

  @override
  String get wlDebtChance => 'Probabilité d\'endettement';

  @override
  String get wlLoanBurden => 'Charge de prêt';

  @override
  String get wlDrainSources => 'À surveiller';

  @override
  String get wlStrengthen => 'Ce qu\'il faut renforcer';

  @override
  String get wlWeakestDriver => 'Facteur financier le plus faible';

  @override
  String get wlHowToFix => 'Comment renforcer';

  @override
  String get wlImprovementPlan => 'Plan d\'amélioration';

  @override
  String get wlReliability => 'Fiabilité de la prédiction';

  @override
  String get wlLayerBirth => 'Maisons de richesse (D1)';

  @override
  String get wlLayerHora => 'Thème Hora (D2)';

  @override
  String get wlLayerNavamsa => 'Navamsa (D9)';

  @override
  String get wlLayerDasha => 'Timing de la Dasha';

  @override
  String get wlLayerTransit => 'Transits actuels';

  @override
  String get wlTopicGrow => 'Comment faire croître sa richesse';

  @override
  String get wlTopicInvest => 'Où investir';

  @override
  String get wlTopicDebt => 'Gérer la dette';

  @override
  String get wlTopicProperty => 'Acheter un bien immobilier';

  @override
  String get wlTopicRetire => 'Planification de la retraite';

  @override
  String get wlTopicPassive => 'Revenu passif';

  @override
  String get wlTopicWindfall => 'Gains soudains';

  @override
  String get wlTopicTiming => 'Meilleur timing financier';

  @override
  String get bzSubtitle => 'Rapport védique d\'affaires propulsé par l\'IA';

  @override
  String get bzTitle => 'Entreprise et startup';

  @override
  String get bzBusinessPotential => 'Potentiel d\'entreprise';

  @override
  String get bzEntrepreneurship => 'Entrepreneur';

  @override
  String get bzVenture => 'Succès entrepreneurial';

  @override
  String get bzWealth => 'Richesse via l\'entreprise';

  @override
  String get bzRiskAppetite => 'Appétit pour le risque';

  @override
  String get bzLongevity => 'Longévité';

  @override
  String get bzChipWealthMagnet => 'Aimant à richesse';

  @override
  String get bzChipMoneyYoga => 'Yoga de l\'argent';

  @override
  String get bzChipLeadership => 'Leadership';

  @override
  String get bzChipPartnerFit => 'Excellente adéquation en partenariat';

  @override
  String get bzChipGains => 'Forts gains';

  @override
  String get bzChipInvestor => 'Attrait pour les investisseurs';

  @override
  String get bzChipFounder => 'Mentalité de fondateur';

  @override
  String get bzWhatsWorking => 'Ce qui joue en votre faveur';

  @override
  String get bzWhatsWorkingSub => 'Vos dons entrepreneuriaux';

  @override
  String get bzClassicYogas => 'Combinaisons classiques de richesse';

  @override
  String get bzFounderType => 'Votre type de fondateur';

  @override
  String get bzSoulBusiness => 'Âme et objectif d\'entreprise';

  @override
  String get bzSoulPlanet => 'Votre moteur de l\'âme';

  @override
  String get bzBusinessPlanet => 'Votre esprit d\'affaires';

  @override
  String get bzDirectionStrength => 'Clarté de direction';

  @override
  String get bzAlignStrong =>
      'Votre objectif d\'âme et votre direction commerciale sont fortement alignés — créer une entreprise semble naturel et épanouissant.';

  @override
  String get bzAlignModerate =>
      'Votre objectif d\'âme et votre direction commerciale sont modérément alignés — une entreprise fonctionne mieux lorsqu\'elle reflète vos valeurs profondes.';

  @override
  String get bzAlignLow =>
      'Votre objectif d\'âme et votre direction commerciale nécessitent un alignement conscient — choisissez une entreprise qui correspond véritablement à qui vous êtes.';

  @override
  String get bzTechAtmakaraka => 'Planète de l\'âme (Atmakaraka)';

  @override
  String get bzTechAmatyakaraka => 'Planète d\'affaires (Amatyakaraka)';

  @override
  String get bzTechDarakaraka => 'Planète du partenaire (Darakaraka)';

  @override
  String get bzFoundation => 'Fondation d\'entreprise';

  @override
  String get bzCareerHouse => 'Maison de carrière';

  @override
  String get bzGainsHouse => 'Maison des gains';

  @override
  String get bzLord => 'Maître';

  @override
  String get bzGainsPotential => 'Potentiel de gains';

  @override
  String get bzNetwork => 'Puissance du réseau';

  @override
  String get bzRecovery => 'Force de rétablissement';

  @override
  String get bzVerification => 'Vérification croisée des thèmes';

  @override
  String get bzD10 => 'Thème de carrière (D10)';

  @override
  String get bzD11 => 'Thème des gains (D11)';

  @override
  String get bzD9 => 'Thème de l\'objectif (D9)';

  @override
  String get bzD60 => 'Thème du karma (D60)';

  @override
  String get bzFounderSkills => 'Compétences de fondateur';

  @override
  String get bzSkillStrategy => 'Pensée stratégique';

  @override
  String get bzSkillExecution => 'Exécution';

  @override
  String get bzSkillPeople => 'Gestion des personnes';

  @override
  String get bzSkillSales => 'Vente et persuasion';

  @override
  String get bzSkillFinance => 'Sens financier';

  @override
  String get bzSkillOps => 'Discipline opérationnelle';

  @override
  String get bzTopSkill => 'Compétence principale';

  @override
  String get bzDomains => 'Meilleurs domaines d\'activité';

  @override
  String get bzDomainsSub => 'Classés par adéquation naturelle';

  @override
  String get bzFit => 'ADÉQUATION';

  @override
  String get bzBusinessStyleHdr => 'Style d\'entreprise';

  @override
  String get bzStyleService => 'Produit vs service';

  @override
  String get bzStyleMarket => 'Focus de marché';

  @override
  String get bzStyleTech => 'Approche technologique';

  @override
  String get bzStyleLeadership => 'Style de leadership';

  @override
  String get bzStylePartnership => 'Solo ou partenariat';

  @override
  String get bzWhereBuild => 'Portée';

  @override
  String get bzExpansion => 'Expansion';

  @override
  String get bzSetup => 'Configuration';

  @override
  String get bzPartnership => 'Partenariat et équipe';

  @override
  String get bzIdealCofounder => 'Co-fondateur idéal';

  @override
  String get bzPartnerViability => 'Adéquation du partenariat';

  @override
  String get bzTeamBuilding => 'Constitution d\'équipe';

  @override
  String get bzCofounderFit => 'Adéquation du co-fondateur';

  @override
  String get bzAdvisorNetwork => 'Réseau de conseillers';

  @override
  String get bzFunding => 'Financement et argent';

  @override
  String get bzRecommendedPath => 'Voie de financement recommandée';

  @override
  String get bzInvestorAttract => 'Attrait pour les investisseurs';

  @override
  String get bzFamilyBacking => 'Soutien familial';

  @override
  String get bzHybridViability => 'Combinaison emploi + entreprise';

  @override
  String get bzFallback => 'Emploi de secours';

  @override
  String get bzDebtStyle => 'Style d\'endettement';

  @override
  String get bzTimeline => 'Chronologie d\'entreprise';

  @override
  String get bzCurrentPhase => 'En ce moment';

  @override
  String get bzLaunchWindow => 'Fenêtre de lancement';

  @override
  String get bzScaleWindow => 'Fenêtre de croissance';

  @override
  String get bzPeakAge => 'Années de pic';

  @override
  String get bzChallenges => 'Défis à surveiller';

  @override
  String get bzRiskFinancial => 'Perte financière';

  @override
  String get bzRiskBurnout => 'Épuisement professionnel';

  @override
  String get bzRiskTeam => 'Conflit d\'équipe';

  @override
  String get bzRiskLegal => 'Juridique/réglementaire';

  @override
  String get bzFinancialExp =>
      'Risque de perte d\'argent dû à un surinvestissement ou à une mauvaise gestion des flux de trésorerie pendant l\'entreprise.';

  @override
  String get bzFinancialFix =>
      'Gardez une réserve de trésorerie, démarrez de façon allégée et validez la demande avant d\'augmenter les dépenses.';

  @override
  String get bzBurnoutExp =>
      'Pousser trop fort trop longtemps peut épuiser votre énergie et votre concentration.';

  @override
  String get bzBurnoutFix =>
      'Protégez votre repos, déléguez tôt et rythmez vos grands efforts autour des périodes favorables.';

  @override
  String get bzTeamExp =>
      'Les frictions avec les cofondateurs ou le personnel peuvent ralentir l\'entreprise.';

  @override
  String get bzTeamFix =>
      'Définissez des rôles et attentes clairs par écrit, et communiquez souvent.';

  @override
  String get bzLegalExp =>
      'Des problèmes de conformité, de contrats ou de réglementation pourraient créer des obstacles.';

  @override
  String get bzLegalFix =>
      'Faites examiner vos contrats, gardez vos documents en ordre et consultez des professionnels tôt.';

  @override
  String get bzImprovementPlan => 'Plan d\'amélioration';

  @override
  String get bzBestDirection => 'Meilleure direction';

  @override
  String get bzStrategy => 'Stratégie de développement';

  @override
  String get bzTopFields => 'Domaines principaux';

  @override
  String get bzEmploymentPath => 'Emploi vs entreprise';

  @override
  String get bzRoadmap => 'Feuille de route de croissance';

  @override
  String get bzRoadmapSub => 'Votre plan d\'entreprise';

  @override
  String get bzReliability => 'Fiabilité de la prédiction';

  @override
  String get bzLayerBirth => 'Thème de naissance (D1)';

  @override
  String get bzLayerNavamsa => 'Navamsa (D9)';

  @override
  String get bzLayerDashamsa => 'Carrière (D10)';

  @override
  String get bzLayerLabhamsa => 'Gains (D11)';

  @override
  String get bzLayerShashtiamsa => 'Karma (D60)';

  @override
  String get bzTopicStart => 'Devrais-je commencer maintenant ?';

  @override
  String get bzTopicIdea => 'Meilleure idée d\'entreprise';

  @override
  String get bzTopicPartner => 'Trouver un cofondateur';

  @override
  String get bzTopicFunding => 'Comment le financer';

  @override
  String get bzTopicScale => 'Quand se développer';

  @override
  String get bzTopicRisk => 'Gérer les risques';

  @override
  String get bzTopicJob => 'Emploi vs entreprise';

  @override
  String get bzTopicTiming => 'Meilleur timing';

  @override
  String get crTitle => 'Analyse de carrière et d\'emploi';

  @override
  String get crSubtitle => 'Rapport védique de carrière propulsé par l\'IA';

  @override
  String get crCrumbHome => 'Accueil';

  @override
  String get crCrumbReports => 'Rapports';

  @override
  String get crCareerPotential => 'Potentiel de carrière';

  @override
  String get crStatusStrong => 'Fort potentiel';

  @override
  String get crStatusGood => 'Bon potentiel';

  @override
  String get crStatusModerate => 'Potentiel modéré';

  @override
  String get crStatusDeveloping => 'Potentiel en développement';

  @override
  String get crStatusChallenging => 'Phase difficile';

  @override
  String get crOverallCareer => 'Carrière globale';

  @override
  String get crStability => 'Stabilité de carrière';

  @override
  String get crGrowth => 'Potentiel de croissance';

  @override
  String get crRecognition => 'Reconnaissance';

  @override
  String get crSatisfaction => 'Satisfaction';

  @override
  String get crChipLeadership => 'Leadership';

  @override
  String get crChipCreativity => 'Créativité';

  @override
  String get crChipBusiness => 'Entreprise';

  @override
  String get crChipStableIncome => 'Revenu stable';

  @override
  String get crChipLearning => 'Apprentissage';

  @override
  String get crChipGrowth => 'Croissance à long terme';

  @override
  String get crChipTechnical => 'Compétence technique';

  @override
  String get crChipRecognition => 'Reconnaissance';

  @override
  String get crTopInsights => 'Principaux aperçus';

  @override
  String get crWhatDefines => 'Qu\'est-ce qui définit votre carrière ?';

  @override
  String get crSoulCareer => 'Âme et objectif de carrière';

  @override
  String get crSoulPlanet => 'Planète de l\'objectif de l\'âme';

  @override
  String get crCareerPlanet => 'Planète de carrière';

  @override
  String get crMeaning => 'Signification';

  @override
  String get crAlignment => 'Alignement âme ↔ carrière';

  @override
  String get crAlignStrong =>
      'Vos intérêts naturels et votre parcours professionnel sont fortement alignés.';

  @override
  String get crAlignModerate =>
      'Vos intérêts naturels et votre parcours professionnel sont modérément alignés.';

  @override
  String get crAlignLow =>
      'Vos intérêts naturels et votre parcours professionnel nécessitent un alignement conscient.';

  @override
  String get crTechAtmakaraka => 'Atmakaraka (indicateur de l\'âme)';

  @override
  String get crTechAmatyakaraka => 'Amatyakaraka (indicateur de carrière)';

  @override
  String get crDegrees => 'Degrés';

  @override
  String get crDignity => 'Dignité';

  @override
  String get crFoundation => 'Fondation de carrière';

  @override
  String get crCareerSign => 'Signe de carrière';

  @override
  String get crCareerLord => 'Maître de carrière';

  @override
  String get crLordPosition => 'Position du maître';

  @override
  String get crCareerStrength => 'Force de carrière';

  @override
  String get crProfStyle => 'Style professionnel';

  @override
  String get crBestFields => 'Meilleurs domaines';

  @override
  String get crTechnicalDetails => 'Détails techniques';

  @override
  String get crHouseLabel => 'Maison';

  @override
  String get crVerification => 'Vérification de carrière à travers les thèmes';

  @override
  String get crD10Career => 'D10 · Carrière';

  @override
  String get crD9Purpose => 'D9 · Objectif';

  @override
  String get crD60Karma => 'D60 · Karma';

  @override
  String get crStatusNeedsImprovement => 'À améliorer';

  @override
  String get crStatusWellAligned => 'Bien aligné';

  @override
  String get crStatusStrongSupport => 'Fort soutien';

  @override
  String get crStatusModerateSupport => 'Soutien modéré';

  @override
  String get crChartDetails => 'Détails techniques du thème';

  @override
  String get crPersonality => 'Votre personnalité professionnelle';

  @override
  String get crGrowthAreas => 'Domaines de croissance';

  @override
  String get crBestRoles => 'Meilleurs rôles';

  @override
  String get crBestIndustries => 'Meilleurs secteurs';

  @override
  String get crEnvironment => 'Environnement de carrière';

  @override
  String get crWorkStyle => 'Meilleur style de travail';

  @override
  String get crEmployment => 'Emploi salarié';

  @override
  String get crBusiness => 'Entreprise';

  @override
  String get crFreelance => 'Freelance/consultant';

  @override
  String get crPortfolio => 'Portefeuille mixte';

  @override
  String get crLeadership => 'Leadership';

  @override
  String get crFit => 'Adéquation';

  @override
  String get crBestFit => 'Meilleure adéquation';

  @override
  String get crTimeline => 'Chronologie de carrière';

  @override
  String get crPastPeak => 'Pic passé';

  @override
  String get crPresentPhase => 'Phase actuelle';

  @override
  String get crUpcoming => 'Opportunité à venir';

  @override
  String get crFutureExpansion => 'Expansion future';

  @override
  String get crRiskPeriod => 'Période à risque';

  @override
  String get crViewDasha => 'Période planétaire (technique)';

  @override
  String get crChallenges => 'Défis à surveiller';

  @override
  String get crRiskBurnout => 'Épuisement professionnel';

  @override
  String get crRiskRecognition => 'Retard de reconnaissance';

  @override
  String get crRiskConflict => 'Conflit au travail';

  @override
  String get crRiskFinancial => 'Instabilité financière';

  @override
  String get crRiskOverqual => 'Sous-utilisation';

  @override
  String get crPrevention => 'Prévention';

  @override
  String get crBurnoutExp =>
      'Des phases longues et exigeantes peuvent épuiser votre énergie avec le temps.';

  @override
  String get crBurnoutFix =>
      'Protégez votre repos, fixez des limites et rythmez vos grands efforts.';

  @override
  String get crRecognitionExp =>
      'Les récompenses et la reconnaissance peuvent arriver plus lentement que vos efforts.';

  @override
  String get crRecognitionFix =>
      'Documentez vos réussites et rendez vos contributions visibles auprès de la hiérarchie.';

  @override
  String get crConflictExp =>
      'Des frictions avec des collègues ou l\'autorité peuvent survenir parfois.';

  @override
  String get crConflictFix =>
      'Communiquez calmement et choisissez vos combats avec sagesse.';

  @override
  String get crFinancialExp =>
      'Les revenus peuvent sembler irréguliers pendant certaines phases.';

  @override
  String get crFinancialFix =>
      'Gardez une réserve et évitez de trop vous engager financièrement.';

  @override
  String get crOverqualExp =>
      'Vous pouvez parfois vous sentir sous-utilisé ou pas assez stimulé.';

  @override
  String get crOverqualFix =>
      'Recherchez des rôles stimulants et continuez à apprendre pour rester engagé.';

  @override
  String get crImprovementPlan => 'Plan d\'amélioration de carrière';

  @override
  String get crCatPlanetary => 'Planétaire et spirituel';

  @override
  String get crCatPractical => 'Étapes pratiques';

  @override
  String get crTraditionalExplain =>
      'Explication de l\'astrologie traditionnelle';

  @override
  String get crActionPlan => 'Plan d\'action de carrière sur 30 jours';

  @override
  String get crWeek1 => 'Semaine 1 · Optimisation du profil';

  @override
  String get crWeek2 => 'Semaine 2 · Développement des compétences';

  @override
  String get crWeek3 => 'Semaine 3 · Réseautage';

  @override
  String get crWeek4 => 'Semaine 4 · Visibilité professionnelle';

  @override
  String get crWeek1Tip =>
      'Actualisez votre CV et votre LinkedIn autour de votre thème de carrière le plus fort.';

  @override
  String get crWeek2Tip =>
      'Choisissez une compétence à forte valeur dans votre meilleur domaine et pratiquez-la quotidiennement.';

  @override
  String get crWeek3Tip =>
      'Reprenez contact avec vos mentors et contactez deux nouveaux contacts du secteur.';

  @override
  String get crWeek4Tip =>
      'Partagez votre travail publiquement et portez-vous volontaire pour un projet visible.';

  @override
  String get crPriority => 'Priorité';

  @override
  String get crTimeRequired => 'Temps';

  @override
  String get crExpectedBenefit => 'Bénéfice';

  @override
  String get crPriorityHigh => 'Élevée';

  @override
  String get crPriorityMedium => 'Moyenne';

  @override
  String get crRoadmap => 'Feuille de route de carrière IA';

  @override
  String get crNext12 => 'Prochains 12 mois';

  @override
  String get crBestFocus => 'Meilleur focus';

  @override
  String get crSkillsLearn => 'Compétences à apprendre';

  @override
  String get crIndustriesTarget => 'Secteurs à cibler';

  @override
  String get crExpectedOutcome => 'Résultat attendu';

  @override
  String get crReliability => 'Fiabilité de la prédiction';

  @override
  String get crReliabilityHigh => 'Haute fiabilité';

  @override
  String get crReliabilityGood => 'Bonne fiabilité';

  @override
  String get crReliabilityModerate => 'Fiabilité modérée';

  @override
  String get crReliabilityExplain =>
      'Ce rapport combine votre thème de naissance, les thèmes divisionnaires et les indicateurs Jaimini. Le score reflète à quel point ces différentes couches du thème concordent.';

  @override
  String get crChartLayers => 'Couches du thème et pondérations';

  @override
  String get crBirthChart => 'Thème de naissance (D1)';

  @override
  String get crNavamsa => 'Navamsa (D9)';

  @override
  String get crDashamsa => 'Dashamsa (D10)';

  @override
  String get crShashtiamsa => 'Shashtiamsa (D60)';

  @override
  String get crDiscussAi => 'Discuter avec l\'IA';

  @override
  String get crAskAbout => 'Poser une question sur';

  @override
  String get crTopicChange => 'Changement de carrière';

  @override
  String get crTopicGovt => 'Emploi gouvernemental';

  @override
  String get crTopicBusiness => 'Entreprise';

  @override
  String get crTopicPromotion => 'Promotion';

  @override
  String get crTopicMarriage => 'Mariage vs carrière';

  @override
  String get crTopicAbroad => 'À l\'étranger';

  @override
  String get crTopicIncome => 'Revenu';

  @override
  String get crTopicPurpose => 'Objectif';

  @override
  String get crTopicResume => 'CV';

  @override
  String get crTopicCopied => 'Question copiée — collez-la dans votre chat IA.';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return '$soul guide votre appel intérieur, tandis que $career façonne votre profession extérieure.';
  }

  @override
  String get rzTodayOutlook => 'Perspectives du zodiaque du jour';

  @override
  String get rzPlanetaryEnergy => 'Énergie planétaire du jour';

  @override
  String get rzBestSign => 'Meilleur signe';

  @override
  String get rzChallengingSign => 'Le plus difficile';

  @override
  String get rzDominantPlanet => 'Planète dominante';

  @override
  String get rzOverallMood => 'Ambiance générale';

  @override
  String get rzMoodBright => 'Lumineux et actif';

  @override
  String get rzMoodCalm => 'Calme et stable';

  @override
  String get rzMoodMixed => 'Énergie mitigée';

  @override
  String get rzMoodTense => 'Tendu et prudent';

  @override
  String get rzTodayEnergy => 'Énergie du jour';

  @override
  String get rzCaution => 'Prudence';

  @override
  String get rzWeak => 'Faible';

  @override
  String get rzAllSigns => 'Tous les signes du zodiaque';

  @override
  String get rzAiSummary => 'Résumé IA';

  @override
  String get rzPlanetaryInfluence => 'Influence planétaire du jour';

  @override
  String get rzStrongInfluences => 'Fortes influences';

  @override
  String get rzShowTechnical => 'Afficher les détails techniques';

  @override
  String get rzOpportunities => 'Opportunités du jour';

  @override
  String get rzAvoidTitle => 'Choses à éviter aujourd\'hui';

  @override
  String get rzTechnicalReason => 'Raison technique';

  @override
  String get rzAvoidDecisions => 'Précipiter des décisions importantes';

  @override
  String get rzAvoidArguments => 'Disputes animées';

  @override
  String get rzAvoidInvestments => 'Investissements importants';

  @override
  String get rzAvoidOverthink => 'Trop réfléchir à de petits problèmes';

  @override
  String get rzAvoidOverspend => 'Dépenses inutiles';

  @override
  String get rzAvoidStress => 'Stress et surmenage';

  @override
  String get rzPlanetaryChart => 'Thème planétaire du jour';

  @override
  String get rzWhatChartMeans => 'Ce que signifie ce thème';

  @override
  String get rzChartExplain =>
      'Ce diamant montre où se trouve chaque planète dans le ciel aujourd\'hui, rapporté à votre signe. Les planètes dans des maisons favorables portent la journée ; celles dans des maisons difficiles demandent de la prudence.';

  @override
  String get rzDoNetworking => 'Réseautage et connexions';

  @override
  String get rzDoLearning => 'Apprendre quelque chose de nouveau';

  @override
  String get rzDoMeditation => 'Méditation et calme';

  @override
  String get rzDoFamily => 'Temps en famille';

  @override
  String get rzDoCreative => 'Travail créatif';

  @override
  String get rzDoRest => 'Repos et soin de soi';

  @override
  String get rzAiRecommendations => 'Recommandations IA du jour';

  @override
  String get rzTechnical => 'Astrologie technique';

  @override
  String get rzTransitScore => 'Score de transit';

  @override
  String get rzVedha => 'Vedha (obstructions)';

  @override
  String get rzGocharDetails => 'Détails du Gochar';

  @override
  String get rzAdvancedOnly => 'Pour utilisateurs avancés';

  @override
  String get rzTomorrow => 'Aperçu de demain';

  @override
  String get rzTomorrowEnergy => 'Énergie de demain';

  @override
  String get rzImproving => 'En amélioration';

  @override
  String get rzWeaker => 'Légèrement plus faible';

  @override
  String get rzSteady => 'Stable';

  @override
  String get rzTomorrowUpLine =>
      'L\'énergie devrait augmenter demain — planifiez à l\'avance vos tâches importantes.';

  @override
  String get rzTomorrowDownLine =>
      'L\'énergie pourrait légèrement baisser demain — gardez une journée légère et stable.';

  @override
  String get rzTomorrowFlatLine =>
      'L\'énergie reste stable demain — une journée calme et équilibrée s\'annonce.';

  @override
  String get rzWeeklyTrend => 'Tendance hebdomadaire';

  @override
  String get rzMonthlyTrend => 'Tendance mensuelle';

  @override
  String get rzBestDayWeek => 'Meilleur jour';

  @override
  String get rzHardestDay => 'Jour le plus difficile';

  @override
  String get rzLuckyToday => 'Chance du jour';

  @override
  String get rzKarakaSun => 'confiance et vitalité';

  @override
  String get rzKarakaMoon => 'émotions et tranquillité d\'esprit';

  @override
  String get rzKarakaMars => 'énergie et motivation';

  @override
  String get rzKarakaMercury => 'communication et apprentissage';

  @override
  String get rzKarakaJupiter => 'sagesse et croissance';

  @override
  String get rzKarakaVenus => 'relations et confort';

  @override
  String get rzKarakaSaturn => 'discipline et patience';

  @override
  String get rzKarakaRahu => 'ambition et changement';

  @override
  String get rzKarakaKetu => 'spiritualité et lâcher-prise';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '$dom donne le ton de la journée, tandis que $chal demande de la patience et de la prudence.';
  }

  @override
  String rzInsightGood(Object karaka) {
    return 'Bonne journée pour $karaka.';
  }

  @override
  String rzInsightHard(Object karaka) {
    return 'Prenez votre temps avec $karaka aujourd\'hui.';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return '$karaka est bien soutenu aujourd\'hui.';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return '$karaka pourrait connaître des retards aujourd\'hui.';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return 'Aujourd\'hui favorise $strong, tandis que $weak nécessite de la patience et de la prudence.';
  }

  @override
  String get fdEnergyScore => 'Score d\'énergie du jour';

  @override
  String get fdStatusAverage => 'Moyen';

  @override
  String get fdStatusMixed => 'Mitigé';

  @override
  String get fdStatusChallenging => 'Difficile';

  @override
  String get fdTheme => 'Thème du jour';

  @override
  String get fdExplainToday => 'Expliquer aujourd\'hui';

  @override
  String get fdTodaysFocus => 'Focus du jour';

  @override
  String get fdTopRecommendation => 'Principale recommandation';

  @override
  String get fdTopCaution => 'Principale précaution';

  @override
  String get fdReadingTime => 'Temps de lecture';

  @override
  String get fdSeconds30 => '30 s';

  @override
  String get fdCareer => 'Carrière';

  @override
  String get fdMoney => 'Argent';

  @override
  String get fdLove => 'Amour';

  @override
  String get fdHealth => 'Santé';

  @override
  String get fdTravel => 'Voyage';

  @override
  String get fdFamily => 'Famille';

  @override
  String get fdBestToDo => 'Meilleures choses à faire aujourd\'hui';

  @override
  String get fdAvoidToday => 'À éviter aujourd\'hui';

  @override
  String get fdConfidenceLabel => 'Confiance';

  @override
  String get fdBestTime => 'Meilleur moment';

  @override
  String get fdRecommended => 'Recommandé';

  @override
  String get fdReason => 'Raison';

  @override
  String get fdRisk => 'Risque';

  @override
  String get fdRecommendation => 'Recommandation';

  @override
  String get fdNoActions =>
      'Rien de majeur à entreprendre aujourd\'hui — gardez une routine stable et calme.';

  @override
  String get fdNoCautions =>
      'Aucune précaution majeure aujourd\'hui — procédez avec une vigilance normale.';

  @override
  String get fdHighlights => 'Points forts du jour';

  @override
  String get fdProbVeryHigh => 'Très élevée';

  @override
  String get fdProbHigh => 'Élevée';

  @override
  String get fdProbElevated => 'Accrue';

  @override
  String get fdProbCaution => 'Prudence';

  @override
  String get fdWhatToDo => 'Que faire';

  @override
  String get fdLifeAreas => 'Domaines de vie';

  @override
  String get fdTapDetails => 'Appuyez pour plus de détails';

  @override
  String get fdArea1 => 'Soi et santé';

  @override
  String get fdArea2 => 'Richesse et famille';

  @override
  String get fdArea3 => 'Communication';

  @override
  String get fdArea4 => 'Foyer et confort';

  @override
  String get fdArea5 => 'Créativité et romance';

  @override
  String get fdArea6 => 'Travail et devoirs';

  @override
  String get fdArea7 => 'Relations';

  @override
  String get fdArea8 => 'Changement et profondeur';

  @override
  String get fdArea9 => 'Chance et voyage';

  @override
  String get fdArea10 => 'Carrière et statut';

  @override
  String get fdArea11 => 'Gains et réseau';

  @override
  String get fdArea12 => 'Repos et spiritualité';

  @override
  String get fdTodaysMeaning => 'Signification du jour';

  @override
  String get fdGoodFor => 'Favorable pour';

  @override
  String get fdAvoid => 'Éviter';

  @override
  String get fdPlanetSupport => 'Soutien planétaire';

  @override
  String get fdWhyPrediction => 'Pourquoi cette prédiction ?';

  @override
  String get fdAdvancedDetails => 'Détails avancés';

  @override
  String get fdAiRecommendation => 'Recommandation de l\'IA';

  @override
  String get fdOverallStatus => 'Statut global';

  @override
  String get fdNoPlanetTransit =>
      'Aucune planète majeure ne transite dans ce domaine aujourd\'hui.';

  @override
  String get fdFinancialOutlook => 'Perspectives financières';

  @override
  String get fdIncomeProbability => 'Probabilité de revenu';

  @override
  String get fdExpenseProbability => 'Probabilité de dépense';

  @override
  String get fdNetBalance => 'Solde financier net';

  @override
  String get fdAvoidSpending => 'Éviter de dépenser';

  @override
  String get fdRelationshipOutlook => 'Perspectives relationnelles';

  @override
  String get fdOverallScore => 'Score global';

  @override
  String get fdPartner => 'Partenaire';

  @override
  String get fdRomance => 'Romance';

  @override
  String get fdWorkplace => 'Lieu de travail';

  @override
  String get fdPublicImage => 'Image publique';

  @override
  String get fdBestActivity => 'Meilleure activité';

  @override
  String get fdWeakArea => 'Domaine faible';

  @override
  String get fdBiggestOpportunity => 'Plus grande opportunité';

  @override
  String get fdBiggestRisk => 'Plus grand risque';

  @override
  String get fdProbability => 'Probabilité';

  @override
  String get fdProtection => 'Conseil de protection';

  @override
  String get fdDescription => 'Description';

  @override
  String get fdBestTimeToday => 'Meilleur moment aujourd\'hui';

  @override
  String get fdAvoidDuring => 'À éviter pendant';

  @override
  String get fdPredictionConfidence => 'Confiance de la prédiction';

  @override
  String get fdConfBasis => 'La prédiction du jour combine';

  @override
  String get fdConfNatal => 'Thème de naissance';

  @override
  String get fdConfTransit => 'Transit actuel';

  @override
  String get fdConfDasha => 'Périodes planétaires';

  @override
  String get fdConfStrength => 'Force planétaire';

  @override
  String get fdConfHouse => 'Activation de la maison';

  @override
  String get fdAskAi => 'Demander à l\'IA';

  @override
  String get fdAskAiSub =>
      'Appuyez sur une question pour obtenir la réponse du jour';

  @override
  String get fdQ1 => 'Pourquoi la carrière est-elle lente aujourd\'hui ?';

  @override
  String get fdQ2 => 'Quel est le meilleur moment aujourd\'hui ?';

  @override
  String get fdQ3 => 'Aujourd\'hui est-il bon pour les questions d\'argent ?';

  @override
  String get fdQ4 => 'Aujourd\'hui est-il bon pour voyager ?';

  @override
  String get fdQ5 => 'Que dois-je éviter aujourd\'hui ?';

  @override
  String get fdMoreSuggestions => 'Plus de suggestions';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return 'Aujourd\'hui est particulièrement propice à $top. $weak pourrait sembler ralenti, évitez donc les décisions importantes dans ce domaine. Sur le plan financier, la journée s\'annonce $fin.';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return 'Votre énergie du jour se concentre autour de $top — misez dessus et allez-y doucement ailleurs.';
  }

  @override
  String get gochToday => 'Aujourd\'hui';

  @override
  String get gochOverallScore => 'Score de transit global';

  @override
  String get gochNeutral => 'Neutre';

  @override
  String get gochChallenging => 'Difficile';

  @override
  String get gochTopPositive => 'Principal point positif';

  @override
  String get gochTopChallenges => 'Principaux défis';

  @override
  String get gochFilterAll => 'Tous';

  @override
  String get gochFavorability => 'Favorabilité';

  @override
  String get gochAlerts => 'Alertes de transit';

  @override
  String get gochAlertCritical => 'Critique';

  @override
  String get gochAlertWarning => 'Prudence';

  @override
  String get gochAlertOpportunity => 'Opportunité';

  @override
  String get gochAiFocus => 'Focus IA du jour';

  @override
  String get gochLifeScores => 'Scores des domaines de vie';

  @override
  String get gochWhy => 'Pourquoi ?';

  @override
  String get gochCurrentTransits => 'Transits actifs';

  @override
  String get gochDailyPlan => 'Votre plan quotidien';

  @override
  String get gochMorning => 'Matin';

  @override
  String get gochAfternoon => 'Après-midi';

  @override
  String get gochEvening => 'Soir';

  @override
  String get gochNight => 'Nuit';

  @override
  String get gochSmartReco => 'Recommandations intelligentes';

  @override
  String get gochExplain => 'Expliquer le transit du jour';

  @override
  String get gochDo => 'À faire';

  @override
  String get gochDont => 'À éviter';

  @override
  String get gochDoWork => 'S\'attaquer au travail important';

  @override
  String get gochDoMeditate => 'Méditer et réfléchir';

  @override
  String get gochDoStart => 'Démarrer de nouveaux projets';

  @override
  String get gochDoFinish => 'Terminer les tâches en attente';

  @override
  String get gochDontArgue => 'Éviter les disputes';

  @override
  String get gochDontImpulsive => 'Éviter les décisions impulsives';

  @override
  String get gochDontOverspend => 'Éviter les dépenses excessives';

  @override
  String gochThemeGrowth(Object area) {
    return 'Une journée de croissance dans $area — misez dessus.';
  }

  @override
  String gochThemeChallenge(Object area) {
    return 'Restez patient avec $area aujourd\'hui — avancez avec constance.';
  }

  @override
  String gochPosLine(Object area) {
    return '$area est bien soutenu en ce moment.';
  }

  @override
  String gochChalLine(Object area) {
    return '$area nécessite une attention particulière aujourd\'hui.';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return 'Investissez votre énergie dans $a1 aujourd\'hui, et soyez doux avec $a2.';
  }

  @override
  String get divBeginner => 'Débutant';

  @override
  String get divSearchHint => 'Rechercher : carrière, mariage, éducation…';

  @override
  String get divSummaryTitle => 'Résumé des thèmes divisionnaires';

  @override
  String get divTotalCharts => 'Total des thèmes';

  @override
  String get divMostImportant => 'Le plus important';

  @override
  String get divRecommendedForYou => 'Recommandé pour vous';

  @override
  String get divCatEssential => 'Thèmes essentiels';

  @override
  String get divCatPersonal => 'Vie personnelle';

  @override
  String get divCatKnowledge => 'Thèmes de connaissance';

  @override
  String get divCatAdvanced => 'Thèmes avancés';

  @override
  String get divGoalProperty => 'Immobilier';

  @override
  String get divGoalKarma => 'Karma';

  @override
  String get divBadgeHighlyRec => 'Fortement recommandé';

  @override
  String get divBadgeRec => 'Recommandé';

  @override
  String get divBadgeUseful => 'Utile';

  @override
  String get divBadgeOptional => 'Optionnel';

  @override
  String get divBadgeAdvOnly => 'Avancé uniquement';

  @override
  String get divRecommendBest => 'Recommander les meilleurs thèmes';

  @override
  String get divNoMatch => 'Aucun thème ne correspond à votre recherche';

  @override
  String get divLifeAreas => 'Domaines de vie';

  @override
  String divAiUse(Object purpose) {
    return 'Utilisez ce thème pour analyser $purpose.';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return 'Vos thèmes $c1 et $c2 sont particulièrement importants — commencez par eux pour les domaines qu\'ils couvrent, puis explorez le reste au besoin.';
  }

  @override
  String divRecReasonHouse(Object house) {
    return 'Votre $house maison mérite un examen plus approfondi — ce thème la montre en détail.';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '$planet est une planète clé mais éprouvée — ce thème révèle sa condition plus profonde.';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return 'Vous êtes dans la Mahadasha de $planet, ce thème est donc particulièrement pertinent en ce moment.';
  }

  @override
  String divRecSummary(Object c1) {
    return 'D\'après votre thème, $c1 devrait être votre priorité absolue. Les thèmes ci-dessous sont classés selon leur pertinence pour vous en ce moment.';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return 'Ouvrez ce thème lorsque vous souhaitez étudier $purpose.';
  }

  @override
  String get yogaHelpful => 'Utile';

  @override
  String get yogaInactive => 'Inactif';

  @override
  String get yogaTabMoney => 'Argent';

  @override
  String get yogaTabRare => 'Rare';

  @override
  String get yogaSummaryTitle => 'Résumé des yogas';

  @override
  String get yogaActiveYogas => 'Yogas actifs';

  @override
  String get yogaTotalYogas => 'Total des yogas';

  @override
  String get yogaMostPowerful => 'Le plus puissant';

  @override
  String get yogaFortuneRating => 'Fortune globale';

  @override
  String get yogaBenefits => 'Bénéfices';

  @override
  String get yogaSupportingPlanets => 'Planètes de soutien';

  @override
  String get yogaRanking => 'Top 5 des yogas les plus forts';

  @override
  String get yogaExplain => 'Expliquer mes yogas';

  @override
  String get yogaExplainSubtitle => 'Comment vos yogas vous soutiennent';

  @override
  String get yogaNoneActive => 'Aucun yoga actif pour l\'instant';

  @override
  String get yogaNoneInCategory => 'Aucun yoga dans cette catégorie';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return 'Votre thème comporte $count yogas actifs — des combinaisons planétaires favorables. Les combinaisons impliquant $planets créent des influences particulièrement bénéfiques pour la croissance et la réussite.';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '$name soutient $areas, et ses bénéfices grandissent lorsque ses planètes sont actives en dasha ou en transit.';
  }

  @override
  String get yogaAiGeneric =>
      'Ce yoga est une combinaison favorable dans votre thème qui renforce ses domaines de vie associés.';

  @override
  String get yogaExplainReassure =>
      'Les yogas sont les points forts de votre thème — des combinaisons planétaires favorables qui jouent en votre faveur. Les plus puissants procurent des bénéfices durables, en particulier durant les périodes des planètes qui les forment.';

  @override
  String get doshSevere => 'Sévère';

  @override
  String get doshVeryMild => 'Très léger';

  @override
  String get doshLow => 'Faible';

  @override
  String get doshHigh => 'Élevé';

  @override
  String get doshCritical => 'Critique';

  @override
  String get doshSummaryTitle => 'Résumé des doshas';

  @override
  String get doshActiveDoshas => 'Doshas actifs';

  @override
  String get doshTotalChecked => 'Total vérifié';

  @override
  String get doshOverallSeverity => 'Sévérité globale';

  @override
  String get doshNoneActive => 'Aucun dosha actif — un thème sain !';

  @override
  String get doshCategory => 'Catégorie';

  @override
  String get doshConfidence => 'Confiance';

  @override
  String get doshWhyFormed => 'Pourquoi il s\'est formé';

  @override
  String get doshAffectedAreas => 'Domaines affectés';

  @override
  String get doshTimeline => 'Chronologie';

  @override
  String get doshDefinition => 'Définition';

  @override
  String get doshFormationRule => 'Règle de formation';

  @override
  String get doshSupportingPlanets => 'Planète associée';

  @override
  String get doshCancellation => 'Yogas d\'annulation';

  @override
  String get doshNoCancellation => 'Aucun trouvé';

  @override
  String get doshAreaChildren => 'Enfants';

  @override
  String get doshAreaMind => 'Esprit';

  @override
  String get remMantra => 'Mantra';

  @override
  String get remGemstone => 'Pierre précieuse';

  @override
  String get remDonation => 'Don';

  @override
  String get remTemple => 'Temple';

  @override
  String get remFasting => 'Jeûne';

  @override
  String get remLifestyle => 'Mode de vie';

  @override
  String get remLifestyleGeneric =>
      'Pratiquez la gratitude, la discipline et la charité liées à cette planète, et gardez une bonne conduite.';

  @override
  String get doshExplain => 'Expliquer mes doshas';

  @override
  String get doshExplainSubtitle =>
      'Un regard calme et pratique sur vos doshas';

  @override
  String get doshExplainReassure =>
      'Les doshas sont courants — presque tous les thèmes en comportent. Ils décrivent des tendances, non un destin figé. La conscience, une bonne conduite et des remèdes simples réduisent leur effet pratique, il n\'y a donc pas lieu de s\'inquiéter.';

  @override
  String get doshAiGeneric =>
      'Ce dosha décrit une tendance dans votre thème. Son effet pratique est généralement léger et peut être équilibré par la conscience et des remèdes simples.';

  @override
  String doshHeroSummary(Object active, Object total) {
    return 'Votre thème présente $active doshas actifs sur $total vérifiés. La plupart sont légers et seuls quelques-uns nécessitent de l\'attention. Avec de la compréhension et des remèdes simples, leur effet pratique peut être atténué.';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return 'Ce dosha influence principalement $areas. Pendant les périodes de $planet, son effet peut sembler plus fort, et les remèdes aident à l\'équilibrer.';
  }

  @override
  String doshTimelineLine(Object planet) {
    return 'Son effet se fait le plus sentir pendant la Mahadasha et l\'Antardasha de $planet, et lorsque $planet est actif en transit.';
  }

  @override
  String get sbLegendary => 'Légendaire';

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
  String get sbSummary => 'Résumé de la force planétaire';

  @override
  String get sbAverageStrength => 'Force moyenne';

  @override
  String get sbHighestRupa => 'Rupa le plus élevé';

  @override
  String get sbRupa => 'Rupa';

  @override
  String get sbRanking => 'Classement des planètes';

  @override
  String get sbRequired => 'Requis';

  @override
  String get sbExcess => 'Excédent';

  @override
  String get sbDeficit => 'Déficit';

  @override
  String get sbTotalShadbala => 'Shadbala total';

  @override
  String get sbExplain => 'Expliquer la force de mes planètes';

  @override
  String get sbExplainSubtitle =>
      'Un résumé simple de la force de vos planètes';

  @override
  String get sbInfoTitle => 'Comprendre le Shadbala';

  @override
  String get sbQWhatIs => 'Qu\'est-ce que le Shadbala ?';

  @override
  String get sbQRupas => 'Que sont les Rupas ?';

  @override
  String get sbQHowCalc => 'Comment la force est-elle calculée ?';

  @override
  String get sbQHowUse => 'Comment l\'utiliser';

  @override
  String get sbWhyStrong => 'Pourquoi fort';

  @override
  String get sbWhyWeak => 'Pourquoi faible';

  @override
  String get sbDuringMahadasha => 'Pendant la Mahadasha';

  @override
  String get sbEffects => 'Effets';

  @override
  String get sbLifeAreas => 'Domaines de vie';

  @override
  String get sbPlanetDetails => 'Détails de la planète';

  @override
  String get sbBodyWhatIs =>
      'Le Shadbala (« force sextuple ») mesure la puissance dont dispose chaque planète pour produire ses résultats, en additionnant six sources de force indépendantes.';

  @override
  String get sbBodyRupas =>
      'La force est mesurée en Rupas (1 Rupa = 60 Virupas). Chaque planète a besoin d\'une force minimale en Rupas pour être considérée comme forte ; plus de Rupas signifie qu\'elle délivre ses résultats plus pleinement.';

  @override
  String get sbBodyHowCalc =>
      'Six balas sont additionnés : Sthana (positionnel), Dig (directionnel), Kala (temporel), Chesta (moteur), Naisargika (naturel) et Drik (aspectuel). Le total est comparé au minimum requis de la planète pour obtenir un pourcentage.';

  @override
  String get sbBodyHowUse =>
      'Une planète au-dessus de 100 % délivre confortablement ses significations ; en dessous de 100 %, elle a besoin de soutien. Privilégiez vos planètes les plus fortes pour les questions importantes, et accordez aux plus faibles des remèdes et de la patience.';

  @override
  String get sbRemedyStrong =>
      'Bien soutenue — aucun remède particulier n\'est nécessaire ; vous pouvez utiliser en toute confiance les périodes de cette planète.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '$strongP est votre planète la plus forte, offrant un excellent soutien pour $strongTrait. $weakP est la plus faible et bénéficie le plus de remèdes.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '$planet a un Shadbala $category, ses $karakatva sont donc soutenus en conséquence.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return 'Le plus fort grâce à $bala ($rupa rupas).';
  }

  @override
  String sbWeakLine(Object bala) {
    return 'Le plus faible en $bala, ce qui abaisse le total.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return 'Pendant la Mahadasha de $planet, ses $karak passent au premier plan.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'Avec un Shadbala fort, $karak sont naturellement soutenus.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'Avec un Shadbala modeste, $karak peuvent nécessiter un effort conscient.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return 'Renforcez $planet par son mantra, sa pierre précieuse ou la charité, et agissez patiemment durant ses périodes.';
  }

  @override
  String get bhOverview => 'Aperçu';

  @override
  String get bhDetailed => 'Détaillé';

  @override
  String get bhavaHouses => 'Maisons';

  @override
  String get bhStrengthOverview => 'Aperçu de la force des maisons';

  @override
  String get bhOverallAverage => 'Moyenne globale des maisons';

  @override
  String get bhStrongestHouse => 'Maison la plus forte';

  @override
  String get bhWeakestHouse => 'Maison la plus faible';

  @override
  String get bhBestArea => 'Meilleur domaine de vie';

  @override
  String get bhNeedsAttention => 'Nécessite de l\'attention';

  @override
  String get bhSavContribution => 'Contribution SAV';

  @override
  String get bhLordCondition => 'État du maître de maison';

  @override
  String get bhBenefic => 'Influence bénéfique';

  @override
  String get bhMalefic => 'Influence maléfique';

  @override
  String get bhStrengthReasons => 'Pourquoi ce score';

  @override
  String get bhGoodEffects => 'Effets positifs';

  @override
  String get bhChallenges => 'Défis';

  @override
  String get bhRemedies => 'Remèdes';

  @override
  String get bhRanking => 'Classement des maisons';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'Expliquer mes maisons';

  @override
  String get bhExplainSubtitle => 'Un résumé simple de vos 12 maisons';

  @override
  String bhHeroSummary(
    Object s1,
    Object s2,
    Object strongArea,
    Object weakArea,
  ) {
    return 'Vos maisons les plus fortes sont $s1 et $s2. $strongArea est naturellement fort, tandis que $weakArea nécessite plus d\'effort.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'Son maître $lord est placé en tant que $relation.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'Cette maison porte $sav points bénéfiques (SAV) ; ses occupants et ses aspects façonnent le reste du score.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'Lorsqu\'elle est forte, elle soutient $meaning.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'Lorsqu\'elle est faible, $meaning peut nécessiter un effort et une attention supplémentaires.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'Renforcez son maître $lord et honorez les affaires de cette maison pour la relever.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'Votre $house est $strengthWord. Elle gouverne $meaning.';
  }

  @override
  String get kunNavamsa => 'Navamsa (D9)';

  @override
  String get kunD10 => 'Dasamsa (D10)';

  @override
  String get kunPlacement => 'Position des planètes';

  @override
  String get kunHousesTitle => 'Détails des maisons';

  @override
  String get kunPlanet => 'Planète';

  @override
  String get kunNakshatra => 'Nakshatra';

  @override
  String get kunPada => 'Pada';

  @override
  String get kunLord => 'Maître';

  @override
  String get kunExplain => 'Expliquer mon thème';

  @override
  String get kunExplainSubtitle => 'Un résumé simple de votre thème';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return 'La $ordinal maison gouverne $meaning.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return '$planets placées ici façonnent ses résultats.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'Votre ascendant est $asc, façonnant votre perspective et la façon dont les autres vous perçoivent en premier.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'Votre esprit et vos émotions suivent la Lune en $moon.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '$planet est votre planète la plus forte — un domaine naturel d\'aisance et de soutien.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '$planet est votre planète la plus éprouvée — la patience et l\'effort portent leurs fruits ici.';
  }

  @override
  String get plNature => 'Nature';

  @override
  String get plElement => 'Élément';

  @override
  String get plGender => 'Genre';

  @override
  String get plKarakatva => 'Karakatva';

  @override
  String get plLordship => 'Seigneurie';

  @override
  String get plStrength => 'Force';

  @override
  String get plAspectsGiven => 'Aspects donnés';

  @override
  String get plAspectsReceived => 'Aspects reçus';

  @override
  String get plConjunction => 'Conjonction';

  @override
  String get plHouseMeaning => 'Signification de la maison';

  @override
  String get plNakshatraMeaning => 'Signification du Nakshatra';

  @override
  String get plAiInterpretation => 'Interprétation IA';

  @override
  String get plSearchHint => 'Rechercher une planète';

  @override
  String get plNoResults => 'Aucune planète trouvée';

  @override
  String get plBenefic => 'Bénéfique';

  @override
  String get plMalefic => 'Maléfique';

  @override
  String get plMale => 'Masculin';

  @override
  String get plFemale => 'Féminin';

  @override
  String get plNeutralGender => 'Neutre';

  @override
  String get plOwnSign => 'Signe propre';

  @override
  String get plFriend => 'Signe ami';

  @override
  String get plEnemy => 'Signe ennemi';

  @override
  String get plNeutral => 'Neutre';

  @override
  String get sumEther => 'Éther';

  @override
  String plLordOfHouses(Object houses) {
    return 'Maître de la/des maison(s) $houses';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return 'Régi par $nakLord, apportant $trait.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '$planet se trouve en $sign, dans la $house maison.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'Ses significations principales — $karak — sont bien soutenues ici.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'Ses significations principales — $karak — peuvent nécessiter un effort conscient ici.';
  }

  @override
  String plAiExalted(Object planet) {
    return '$planet est exalté, donnant ses meilleurs résultats.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '$planet est débilité et a besoin de soutien pour produire ses résultats.';
  }

  @override
  String plAiCombust(Object planet) {
    return '$planet est combuste, il agit donc moins ouvertement sous l\'éclat du Soleil.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '$planet est vargottama — une position forte répétée dans le navamsa.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '$planet est rétrograde, tournant son énergie vers l\'intérieur et l\'intensifiant.';
  }

  @override
  String get plHouse1 => 'le soi, le corps, la personnalité et la vitalité';

  @override
  String get plHouse2 => 'la richesse, la famille, la parole et la nourriture';

  @override
  String get plHouse3 =>
      'le courage, la fratrie, la communication et les courts voyages';

  @override
  String get plHouse4 =>
      'le foyer, la mère, le confort, la propriété et la paix intérieure';

  @override
  String get plHouse5 =>
      'les enfants, la créativité, l\'intelligence, la romance et les mérites passés';

  @override
  String get plHouse6 =>
      'la santé, les ennemis, les dettes, le service et le travail quotidien';

  @override
  String get plHouse7 =>
      'le mariage, les partenariats et les relations d\'affaires';

  @override
  String get plHouse8 =>
      'la longévité, la transformation, les secrets et l\'héritage';

  @override
  String get plHouse9 =>
      'la fortune, le dharma, l\'enseignement supérieur, le gourou et le père';

  @override
  String get plHouse10 =>
      'la carrière, le statut, l\'autorité et le karma public';

  @override
  String get plHouse11 =>
      'les gains, le revenu, les amis, le réseau et les désirs accomplis';

  @override
  String get plHouse12 =>
      'la perte, les dépenses, les terres étrangères, la spiritualité et la libération';

  @override
  String get sumVeryStrong => 'Très fort';

  @override
  String get sumStrong => 'Fort';

  @override
  String get sumAverage => 'Moyen';

  @override
  String get sumWeak => 'Faible';

  @override
  String get sumNeedsAttention => 'Nécessite de l\'attention';

  @override
  String get sumFire => 'Feu';

  @override
  String get sumEarth => 'Terre';

  @override
  String get sumAir => 'Air';

  @override
  String get sumWater => 'Eau';

  @override
  String get sumMovable => 'Mobile';

  @override
  String get sumFixed => 'Fixe';

  @override
  String get sumDual => 'Double';

  @override
  String get sumDirEast => 'Est';

  @override
  String get sumDirWest => 'Ouest';

  @override
  String get sumDirNorth => 'Nord';

  @override
  String get sumDirSouth => 'Sud';

  @override
  String get sumDirNE => 'Nord-Est';

  @override
  String get sumDirNW => 'Nord-Ouest';

  @override
  String get sumDirSE => 'Sud-Est';

  @override
  String get sumDirSW => 'Sud-Ouest';

  @override
  String get sumSnapshotTitle => 'Aperçu de votre astrologie';

  @override
  String get sumMahadasha => 'Mahadasha';

  @override
  String get sumAntardasha => 'Antardasha';

  @override
  String get sumNakshatra => 'Janma Nakshatra';

  @override
  String get sumElement => 'Élément';

  @override
  String get sumModality => 'Modalité';

  @override
  String get sumLuckyDirection => 'Direction porte-bonheur';

  @override
  String get sumHighlights => 'Points saillants importants';

  @override
  String get sumStrongPlanet => 'Planète la plus forte';

  @override
  String get sumWeakPlanet => 'Planète la plus faible';

  @override
  String get sumYogas => 'Yogas';

  @override
  String get sumDoshas => 'Doshas';

  @override
  String get sumRetrograde => 'Rétrograde';

  @override
  String get sumCombust => 'Combuste';

  @override
  String get sumExalted => 'Exalté';

  @override
  String get sumDebilitated => 'Débilité';

  @override
  String get sumVargottama => 'Vargottama';

  @override
  String get sumQuickInsights => 'Aperçus rapides';

  @override
  String get sumSpirituality => 'Spiritualité';

  @override
  String get sumTimezone => 'Fuseau horaire';

  @override
  String get sumAyanamsa => 'Ayanamsa';

  @override
  String get sumCalendarType => 'Calendrier';

  @override
  String get sumCopied => 'Copié dans le presse-papiers';

  @override
  String get sumNatureFire =>
      'Vous avez une nature audacieuse, énergique et pionnière qui mène de l\'avant.';

  @override
  String get sumNatureEarth =>
      'Vous avez une nature pratique, terre-à-terre et disciplinée qui construit des résultats durables.';

  @override
  String get sumNatureAir =>
      'Vous avez une nature curieuse, communicative et intellectuelle qui s\'épanouit avec de nouvelles idées.';

  @override
  String get sumNatureWater =>
      'Vous avez une nature intuitive, émotionnelle et empathique avec une profonde sensibilité intérieure.';

  @override
  String get sumGradePhraseExcellent =>
      'Fortement soutenu — des résultats favorables sont probables avec un effort constant.';

  @override
  String get sumGradePhraseGood =>
      'Bien soutenu — généralement positif avec un peu d\'attention.';

  @override
  String get sumGradePhraseAverage =>
      'Soutien mitigé — les résultats dépendent de l\'effort et du timing.';

  @override
  String get sumGradePhraseWeak =>
      'Nécessite de l\'attention — la patience et les remèdes aident ici.';

  @override
  String get kDefCombust =>
      'Une planète trop proche du Soleil, dont l\'énergie est ainsi « brûlée » et affaiblie.';

  @override
  String get kDefRetrograde =>
      'Une planète qui semble se déplacer à reculons ; ses effets se tournent vers l\'intérieur et s\'intensifient.';

  @override
  String get kDefNakshatra =>
      'L\'une des 27 demeures lunaires que traversent la Lune et les planètes.';

  @override
  String get kDefVargottama =>
      'Une planète dans le même signe à la fois dans le thème de naissance (D1) et le navamsa (D9) — un signe de force.';

  @override
  String get kDefOwnSign =>
      'Une planète située dans un signe qu\'elle gouverne, où elle se sent chez elle et donne des résultats stables.';

  @override
  String get kDefExalted =>
      'Une planète dans son signe de plus grande force, donnant ses meilleurs résultats.';

  @override
  String get kDefDebilitated =>
      'Une planète dans son signe le plus faible, où elle peine à donner des résultats.';

  @override
  String get kDefMooltrikona =>
      'Une portion spéciale du signe propre d\'une planète où elle est particulièrement puissante.';

  @override
  String get kDefAscendant =>
      'Le signe qui se lève à l\'horizon oriental au moment de la naissance — le Lagna, la fondation du thème.';

  @override
  String get kDefMahadasha =>
      'La grande période planétaire qui colore une longue portion de vie.';

  @override
  String get kDefAntardasha =>
      'Une sous-période au sein d\'une Mahadasha qui affine ses résultats.';

  @override
  String get kDefPada =>
      'L\'un des quatre quarts d\'un nakshatra qu\'occupe une planète.';

  @override
  String get aspGivesAspectTo => 'Donne un aspect à';

  @override
  String get aspReceivesAspectFrom => 'Reçoit un aspect de';

  @override
  String get aspInfluences => 'Influence';

  @override
  String get aspNoInfluence => 'Aucune influence';

  @override
  String get aspNoAspect => 'Aucun aspect';

  @override
  String get aspPresent => 'Présent';

  @override
  String get aspAbsent => 'Absent';

  @override
  String get aspNotPresent => 'Non présent';

  @override
  String get aspSpecialAspect => 'Aspect spécial';

  @override
  String get aspAspectWord => 'Aspect';

  @override
  String get aspTotalGiven => 'Aspects donnés';

  @override
  String get aspTotalReceived => 'Aspects reçus';

  @override
  String get aspStrongestInfluence => 'Influence la plus forte';

  @override
  String get aspMedium => 'Moyen';

  @override
  String get aspAspectPresent => 'Aspect présent';

  @override
  String get aspReason => 'Raison';

  @override
  String get aspBoth => 'Les deux';

  @override
  String get aspTargetHouse => 'Maison cible';

  @override
  String get aspTargetSign => 'Signe cible';

  @override
  String get aspLagnaReceives => 'Le Lagna reçoit un aspect de';

  @override
  String get aspNoAspectFrom => 'Aucun aspect de';

  @override
  String get aspPlanetToPlanet => 'Planète à planète';

  @override
  String get aspSignToSign => 'Signe à signe';

  @override
  String get aspCombinedAspect => 'Aspect combiné';

  @override
  String get aspGrahaAspect => 'Aspect Graha';

  @override
  String get aspRashiAspect => 'Aspect Rashi';

  @override
  String get aspInfoTitle => 'Comprendre les aspects (Drishti)';

  @override
  String get aspQGraha => 'Qu\'est-ce que le Graha Drishti ?';

  @override
  String get aspQRashi => 'Qu\'est-ce que le Rashi Drishti ?';

  @override
  String get aspQDiff => 'Différence entre les deux';

  @override
  String get aspQPredict => 'Comment les aspects influencent la prédiction';

  @override
  String get aspGrahaBody =>
      'Le Graha Drishti est l\'aspect qu\'une planète projette depuis sa position. Chaque planète aspecte pleinement la 7ème maison/planète depuis elle-même (une influence directe, face à face). De plus, Mars aspecte les 4ème et 8ème, Jupiter les 5ème et 9ème, et Saturne les 3ème et 10ème. Rahu et Ketu reçoivent généralement les 5ème, 7ème et 9ème. L\'aspect d\'une planète colore de sa propre nature la planète ou la maison sur laquelle il tombe.';

  @override
  String get aspRashiBody =>
      'Le Rashi Drishti est un aspect signe à signe issu de l\'astrologie Jaimini, indépendant des planètes qui s\'y trouvent. Les signes mobiles aspectent les signes fixes (sauf le signe adjacent), les signes fixes aspectent les signes mobiles (sauf le signe adjacent), et les signes doubles aspectent les autres signes doubles. Il est principalement utilisé dans la prédiction Jaimini et pour juger des relations entre les maisons.';

  @override
  String get aspDiffBody =>
      'Le Graha Drishti est projeté par une planète et dépend de la position de cette planète. Le Rashi Drishti appartient au signe lui-même et s\'applique à tout ce qui y est placé. Le Graha Drishti est directionnel (la planète A voit la planète B), tandis que le Rashi Drishti est généralement mutuel entre les signes. Lorsque les deux pointent vers la même cible, l\'influence est particulièrement forte.';

  @override
  String get aspPredictBody =>
      'Un aspect montre où une planète étend son influence au-delà de sa propre maison. Un aspect bénéfique (Jupiter, Vénus, Lune/Mercure bien placés) soutient et protège la cible ; un aspect maléfique (Saturne, Mars, Soleil, Rahu, Ketu) peut la mettre sous pression, la retarder ou la défier. Lire quelles planètes aspectent une maison ou une planète explique pourquoi les résultats se manifestent de cette façon.';

  @override
  String get aspTraitSun => 'l\'autorité, le leadership et la vitalité';

  @override
  String get aspTraitMoon =>
      'la profondeur émotionnelle, le confort et l\'intuition';

  @override
  String get aspTraitMars => 'l\'énergie, le courage et la détermination';

  @override
  String get aspTraitMercury =>
      'la communication, l\'intellect et l\'adaptabilité';

  @override
  String get aspTraitJupiter => 'la sagesse, la croissance et la bonne fortune';

  @override
  String get aspTraitVenus => 'l\'amour, l\'harmonie et le confort';

  @override
  String get aspTraitSaturn =>
      'la discipline, la responsabilité et un succès patient, parfois retardé';

  @override
  String get aspTraitRahu =>
      'l\'ambition, l\'intensité et des tournures non conventionnelles';

  @override
  String get aspTraitKetu =>
      'le détachement, la spiritualité et le changement soudain';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '$planet influence $targets. Cela peut apporter $trait aux domaines représentés par ces planètes.';
  }

  @override
  String aspAiNone(Object planet) {
    return '$planet ne projette pas d\'aspect spécial sur une autre planète ici ; son influence agit principalement à travers son propre signe et sa propre maison.';
  }

  @override
  String get avSummaryTitle => 'Résumé de l\'Ashtakavarga';

  @override
  String get avOverallScore => 'Score SAV global';

  @override
  String get avOverallRating => 'Évaluation globale';

  @override
  String get avStrongestSigns => 'Signes les plus forts';

  @override
  String get avWeakestSigns => 'Signes les plus faibles';

  @override
  String get avScore => 'Score';

  @override
  String get avMeaning => 'Signification';

  @override
  String get avGrid => 'Grille';

  @override
  String get avList => 'Liste';

  @override
  String get avOverallScoreShort => 'Score global';

  @override
  String get avNatalSignScore => 'Score du signe natal';

  @override
  String get avBestSigns => 'Meilleurs signes';

  @override
  String get avWeakSigns => 'Signes faibles';

  @override
  String get avAiInterpretation => 'Interprétation IA';

  @override
  String get avVeryGood => 'Très bon';

  @override
  String get avVeryWeak => 'Très faible';

  @override
  String get avTotalSav => 'SAV total';

  @override
  String get avPlanetContributions => 'Contributions des planètes';

  @override
  String get avFinance => 'Finance';

  @override
  String get avOverallStrength => 'Force globale';

  @override
  String get avWhatDoesThisMean => 'Qu\'est-ce que cela signifie ?';

  @override
  String get avSimple => 'Simple';

  @override
  String get avAdvanced => 'Avancé';

  @override
  String get avInfoTitle => 'Comprendre l\'Ashtakavarga';

  @override
  String get avStrong => 'Fort';

  @override
  String get avModerate => 'Modéré';

  @override
  String get avQWhatIsAv => 'Qu\'est-ce que l\'Ashtakavarga ?';

  @override
  String get avQWhatIsSav => 'Qu\'est-ce que le SAV ?';

  @override
  String get avQWhatIsBav => 'Qu\'est-ce que le BAV ?';

  @override
  String get avQHowToRead => 'Comment lire ces scores';

  @override
  String get avQSavVsBav => 'SAV vs BAV';

  @override
  String get avABody =>
      'L\'Ashtakavarga est un système de force basé sur des points en astrologie védique. Chaque planète attribue des points bénéfiques (bindus, aussi appelés rekhas) aux douze signes selon sa position. Plus de points dans un signe signifie que ce domaine de vie reçoit un soutien plus fluide pendant les périodes planétaires et transits associés.';

  @override
  String get avSavBody =>
      'Le SAV (Sarva Ashtakavarga) additionne les points des sept planètes pour chaque signe. Il donne un score de force unique par signe, ce qui permet de voir rapidement quels signes — et les maisons dans lesquelles ils tombent — sont le mieux soutenus dans votre thème.';

  @override
  String get avBavBody =>
      'Le BAV (Bhinna Ashtakavarga) montre les points d\'une seule planète à travers les douze signes. Il indique quels signes une planète spécifique soutient le plus, ce qui compte lorsque la dasha ou le transit de cette planète est actif.';

  @override
  String get avHowToReadBody =>
      'Des chiffres plus élevés sont meilleurs. Pour le SAV, un signe moyen obtient environ 28 points — au-dessus de 30 c\'est fort et en dessous de 25 cela nécessite de l\'attention. Pour le BAV, chaque signe va de 0 à 8, 4 étant la moyenne. Privilégiez vos signes les plus forts pour les actions importantes, et restez patient et discipliné avec les plus faibles.';

  @override
  String get avSavVsBavBody =>
      'Le SAV est le total combiné de toutes les planètes et montre la force globale d\'un signe. Le BAV est la contribution d\'une seule planète et montre quelle planète soutient ce signe. Utilisez le SAV pour la vue d\'ensemble, et le BAV pour comprendre quelle planète détermine la force d\'un signe.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'Votre thème est le plus fort en $s1, $s2 et $s3. Ces signes offrent un meilleur soutien pendant les périodes planétaires et les transits. $weak a actuellement le moins de soutien, la patience et la discipline aident donc dans les questions qui y sont liées.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '$planet performe le mieux à travers $s1 et $s2. Les affaires régies par $planet tendent à s\'améliorer lorsque ces signes sont activés.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'Vos signes les plus forts sont $s1 et $s2 — privilégiez les débuts importants lorsque des planètes y transitent.';
  }

  @override
  String avInsightWeak(Object s1) {
    return '$s1 a le moins de soutien — avancez prudemment et évitez de trop vous engager dans ses affaires.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '$planet porte le plus de points, ses significations sont donc bien soutenues dans votre vie.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '$planet porte le moins de points et bénéficie le plus de remèdes et d\'un effort conscient.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'Les signes dont le score dépasse votre moyenne de $avg points ont tendance à donner des résultats plus fluides et plus fiables.';
  }

  @override
  String get fcKey => 'Clé';

  @override
  String get fcActions => 'Actions';

  @override
  String get fcCautions => 'Précautions';

  @override
  String get fc12House => '12 maisons';

  @override
  String get fcProbabilities => 'Probabilités';

  @override
  String get fcHousesCaps => 'MAISONS';

  @override
  String get fcCritical => 'Critique';

  @override
  String get fcFlags => 'Signaux';

  @override
  String get fcAnalysis => 'Analyse';

  @override
  String get fcConfidence => 'Confiance';

  @override
  String get fcQualityCaps => 'QUALITÉ';

  @override
  String get fcIncomeVs => 'Revenu vs';

  @override
  String get fcExpense => 'Dépense';

  @override
  String get fcFinance => 'FINANCE';

  @override
  String get fcNetBalance => 'Solde net';

  @override
  String get fcSignature => 'Signature';

  @override
  String get fcBestTimeForIncome => 'Meilleur moment pour les revenus';

  @override
  String get fcExpenseCaution => 'Précaution de dépense';

  @override
  String get fcIncomeCaps => 'REVENU';

  @override
  String get fcExpenseCaps => 'DÉPENSE';

  @override
  String get fcRelationships => 'Relations';

  @override
  String get fcAreasCaps => 'DOMAINES';

  @override
  String get fcBestForMeetings => 'Idéal pour les rencontres';

  @override
  String get fcOpportunitiesVs => 'Opportunités vs';

  @override
  String get fcRisks => 'Risques';

  @override
  String get fcOutlook => 'PERSPECTIVES';

  @override
  String get fcAction => 'Action';

  @override
  String get fcProtect => 'Protéger';

  @override
  String get fcOpportunityCaps => 'OPPORTUNITÉ';

  @override
  String get fcRiskCaps => 'RISQUE';

  @override
  String get fcTopOpportunities => 'MEILLEURES OPPORTUNITÉS';

  @override
  String get fcTopRisks => 'PRINCIPAUX RISQUES';

  @override
  String get fcTiming => 'Timing';

  @override
  String get fcWindows => 'Fenêtres';

  @override
  String get fcSlotsCaps => 'CRÉNEAUX';

  @override
  String get fcBestWindows => 'MEILLEURES FENÊTRES';

  @override
  String get fcWorstWindows => 'PIRES FENÊTRES';

  @override
  String get fcAvoid => 'Éviter';

  @override
  String get fcHouse => 'Maison';

  @override
  String get fcFailed => 'Échoué';

  @override
  String get lifeCareer => 'Carrière';

  @override
  String get lifeHealth => 'Santé';

  @override
  String get lifeWealth => 'Richesse';

  @override
  String get lifeFamily => 'Famille';

  @override
  String get lifeMind => 'Esprit';

  @override
  String get lifeEgo => 'Ego';

  @override
  String get lifeAggression => 'Agressivité';

  @override
  String get lifeConflict => 'Conflit';

  @override
  String get rashiElement => 'Élément';

  @override
  String get rashiQuality => 'Qualité';

  @override
  String get rashiLuckyColor => 'Couleur porte-bonheur';

  @override
  String get rashiLuckyDay => 'Jour porte-bonheur';

  @override
  String get rashiLuckyNumber => 'Nombre porte-bonheur';

  @override
  String get rashiGemstone => 'Pierre précieuse';

  @override
  String get rashiBody => 'Corps';

  @override
  String get gocharTodaysTransitChart => 'Thème de transit du jour';

  @override
  String get gocharTransit => 'Transit';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get thisMonth => 'Ce mois-ci';

  @override
  String get best => 'Meilleur';

  @override
  String get worst => 'Pire';

  @override
  String get avg => 'moy';

  @override
  String get favorableLoveWindowsLabel => 'Fenêtres favorables à l\'amour';

  @override
  String get lordLabel => 'Maître';

  @override
  String get lordPlacementLabel => 'Position du maître';

  @override
  String get lordDignityLabel => 'Dignité du maître';

  @override
  String get categoriesSuffix => 'Catégories';

  @override
  String get coreBlockerLabel => 'BLOCAGE PRINCIPAL';

  @override
  String get coreGiftLabel => '✦ DON PRINCIPAL';

  @override
  String get coreThemeLabel => '● THÈME PRINCIPAL';

  @override
  String dominantLabel(Object value) {
    return 'Dominant : $value';
  }

  @override
  String get karakasSuffix => 'Karakas';

  @override
  String get protectiveLabel => 'PROTECTEUR';

  @override
  String secondaryLabel(Object value) {
    return ' · Secondaire : $value';
  }

  @override
  String get tagCore => 'PRINCIPAL';

  @override
  String get debtScoresHeader => '📉 SCORES DE DETTE';

  @override
  String get debtCurrentLoadStat => 'CHARGE DE\nDETTE ACTUELLE';

  @override
  String get debtRecoveryCapacityStat => 'CAPACITÉ DE\nREDRESSEMENT';

  @override
  String get debtIntensityStat => 'INTENSITÉ';

  @override
  String get debtDefaultRiskStat => 'RISQUE DE DÉFAUT';

  @override
  String get debtProfileTitle => 'Profil d\'endettement';

  @override
  String get debtKarmaLabel => 'KARMA';

  @override
  String get debtPersonalityLabel => 'PERSONNALITÉ';

  @override
  String get debtPhaseLabel => 'PHASE';

  @override
  String get debtPrimaryCategoryLabel => 'CATÉGORIE PRINCIPALE';

  @override
  String get debtWord => 'Dette';

  @override
  String get debtYogasTitle => 'Yogas de dette';

  @override
  String get debtCreatingLabel => 'CRÉATEUR DE DETTE';

  @override
  String get debtClearingLabel => 'APUREMENT DE DETTE';

  @override
  String get yearlyDebtTitle => 'Dette annuelle';

  @override
  String get debtRepaymentTitle => 'Remboursement';

  @override
  String get debtDangerPeriodsTitle => 'Périodes à risque';

  @override
  String get debtDefaultPctStat => '% DE DÉFAUT';

  @override
  String get debtBankruptcyPctStat => '% DE FAILLITE';

  @override
  String get debtChronicPctStat => '% CHRONIQUE';

  @override
  String get debtResilienceStat => 'RÉSILIENCE';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'Redressement : $pct% · Calendrier : $years ans';
  }

  @override
  String get debtFreeWindowLabel => '🎯 FENÊTRE DE LIBÉRATION DE DETTE';

  @override
  String debtFreeYear(Object year) {
    return 'Année $year';
  }

  @override
  String get legalScoresHeader => '⚖️ SCORES JURIDIQUES';

  @override
  String get legalVulnerabilityStat => 'VULNÉRABILITÉ\nJURIDIQUE';

  @override
  String get legalVictoryPotentialStat => 'POTENTIEL DE\nVICTOIRE';

  @override
  String get legalConflictStat => 'CONFLIT';

  @override
  String get legalResolutionStat => 'RÉSOLUTION';

  @override
  String get legalProfileTitle => 'Profil juridique';

  @override
  String get legalKarmaTypeLabel => 'TYPE DE KARMA';

  @override
  String get legalConflictStyleLabel => 'STYLE DE CONFLIT';

  @override
  String get legalStrategyLabel => 'STRATÉGIE';

  @override
  String get legalCaseDurationLabel => 'DURÉE DE L\'AFFAIRE';

  @override
  String get legalCurrentStatusLabel => 'STATUT ACTUEL';

  @override
  String get legalWord => 'Juridique';

  @override
  String get legalYogasTitle => 'Yogas juridiques';

  @override
  String get legalDisputePressureLabel => 'PRESSION DE LITIGE';

  @override
  String get legalProtectionLabel => 'PROTECTION JURIDIQUE';

  @override
  String get legalStressTrendTitle => 'Stress juridique';

  @override
  String get legalVisibleEnemiesStat => 'ENNEMIS VISIBLES';

  @override
  String get legalHiddenEnemiesStat => 'ENNEMIS CACHÉS';

  @override
  String get legalCriminalRiskStat => 'RISQUE CRIMINEL';

  @override
  String get legalFalseAccusationStat => 'FAUSSE ACCUSATION';

  @override
  String get legalContractKarmaTitle => 'Karma contractuel';

  @override
  String get legalDocumentationLabel => 'DOCUMENTATION';

  @override
  String get legalFinePrintAwareLabel => 'ATTENTION AUX PETITS CARACTÈRES';

  @override
  String get legalNegotiationSkillLabel => 'COMPÉTENCE DE NÉGOCIATION';

  @override
  String get legalSignatureCautionLabel => 'PRUDENCE À LA SIGNATURE';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'Résilience : $pct/100';
  }

  @override
  String get legalVictoryWord => 'Victoire';

  @override
  String get legalAnalysisSuffix => 'Analyse';

  @override
  String get legalAsPlaintiff => 'EN TANT QUE PLAIGNANT';

  @override
  String get legalAsDefendant => 'EN TANT QUE DÉFENDEUR';

  @override
  String get legalWinProbability => 'PROBABILITÉ DE VICTOIRE';

  @override
  String get legalDisputeWord => 'Litige';

  @override
  String get lifepathScoresHeader => '🌟 SCORES DE CHEMIN DE VIE';

  @override
  String get lifepathDharmaClarityStat => 'CLARTÉ DU\nDHARMA';

  @override
  String get lifepathFortuneBaselineStat => 'BASE DE\nFORTUNE';

  @override
  String get lifepathCoherenceStat => 'COHÉRENCE DU\nCHEMIN DE VIE';

  @override
  String get lifepathKarmaStat => 'KARMA';

  @override
  String get lifepathSpiritualStat => 'SPIRITUEL';

  @override
  String get lifepathFameStat => 'RENOMMÉE';

  @override
  String get lifepathSoulContractTitle => 'Contrat d\'âme';

  @override
  String get lifepathAtmakarakaLabel => 'ATMAKARAKA';

  @override
  String get lifepathAkFocusLabel => 'FOCUS AK';

  @override
  String get lifepathSoulPurposeLabel => 'OBJECTIF DE L\'ÂME';

  @override
  String get lifepathLifeChapterLabel => 'CHAPITRE DE VIE';

  @override
  String get lifepathPrimaryDomainLabel => 'DOMAINE PRINCIPAL';

  @override
  String get lifepathLeadershipStat => 'LEADERSHIP';

  @override
  String get lifepathWisdomTeachStat => 'SAGESSE/ENSEIGNEMENT';

  @override
  String get lifepathServiceStat => 'SERVICE';

  @override
  String get lifepathHealingStat => 'GUÉRISON';

  @override
  String get lifepathFortuneYogasTitle => 'Yogas de fortune';

  @override
  String get lifepathLuckBlocksLabel => 'BLOCAGES DE CHANCE';

  @override
  String get lifepathFortuneBoostersLabel => 'AMPLIFICATEURS DE FORTUNE';

  @override
  String get lifepathFortuneTrendTitle => 'Tendance de fortune';

  @override
  String get lifepathGoldenWindowsTitle => 'Fenêtres dorées ★';

  @override
  String get lifepathTransformationTitle => 'Transformation';

  @override
  String get lifepathMilestonesTitle => 'Jalons de vie';

  @override
  String get lifepathKarmicLessonsTitle => 'Leçons karmiques';

  @override
  String get lifepathRahuGrowthLabel => 'CROISSANCE DE RAHU';

  @override
  String get lifepathKetuSurrenderLabel => 'LÂCHER-PRISE DE KETU';

  @override
  String get lifepathSaturnLessonLabel => 'LEÇON DE SATURNE';

  @override
  String get lifepathLifeDifficultyLabel => 'DIFFICULTÉ DE VIE';

  @override
  String get lifepathSoulExperienceTitle => '★ CE QUE L\'ÂME EST VENUE VIVRE';

  @override
  String get lifepathBlessingsTitle => '● BÉNÉDICTIONS';

  @override
  String get lifepathLifeWord => 'Vie';

  @override
  String get lifepathArchetypeSuffix => 'Archétype';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'Accomplissement : $pct%';
  }

  @override
  String get lifepathDestinyVsWord => 'Destin vs';

  @override
  String get lifepathFreeWillSuffix => 'Libre arbitre';

  @override
  String get lifepathDestinyStat => 'DESTIN';

  @override
  String get lifepathFreeWillStat => 'LIBRE ARBITRE';

  @override
  String get pastlifeScoresHeader => '🔮 SCORES DE VIE ANTÉRIEURE';

  @override
  String get pastlifeSignatureStrengthStat => 'FORCE DE LA\nSIGNATURE';

  @override
  String get pastlifeCarryForwardStat => 'TRANSMISSION';

  @override
  String get pastlifeMasteryPreservedStat => 'MAÎTRISE\nPRÉSERVÉE';

  @override
  String get pastlifeUnfinishedStat => 'INACHEVÉ';

  @override
  String get pastlifeKarmicDebtStat => 'DETTE KARMIQUE';

  @override
  String get pastlifeProfileTitle => 'Profil de vie antérieure';

  @override
  String get pastlifeThemeLabel => 'THÈME';

  @override
  String get pastlifeProfessionLabel => 'PROFESSION';

  @override
  String get pastlifeSocialStandingLabel => 'STATUT SOCIAL';

  @override
  String get pastlifeRegionLabel => 'RÉGION';

  @override
  String get pastlifeSpiritualLevelLabel => 'NIVEAU SPIRITUEL';

  @override
  String get pastlifeGenderLabel => 'GENRE';

  @override
  String get pastlifeWealthLevelLabel => 'NIVEAU DE RICHESSE';

  @override
  String get pastlifeFamilyRoleLabel => 'RÔLE FAMILIAL';

  @override
  String get pastlifeSkillsCarriedTitle => '★ COMPÉTENCES TRANSMISES';

  @override
  String get pastlifeNaturalAttractionsTitle => '● ATTIRANCES NATURELLES';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ PEURS INEXPLIQUÉES';

  @override
  String get pastlifeMagneticPullsTitle => '→ ATTRACTIONS MAGNÉTIQUES';

  @override
  String get pastlifeRelationshipStat => 'RELATIONNEL';

  @override
  String get pastlifeFinancialStat => 'FINANCIER';

  @override
  String get pastlifeServiceStat => 'SERVICE';

  @override
  String get pastlifeDharmicStat => 'DHARMIQUE';

  @override
  String get pastlifeOnRelationsStat => 'SUR LES RELATIONS';

  @override
  String get pastlifeOnCareerStat => 'SUR LA CARRIÈRE';

  @override
  String get pastlifeOnHealthStat => 'SUR LA SANTÉ';

  @override
  String get pastlifeOnSpiritualStat => 'SUR LE SPIRITUEL';

  @override
  String get pastlifeKarmicResolutionTitle => 'Résolution karmique';

  @override
  String get pastlifePrimaryPathLabel => 'VOIE PRINCIPALE';

  @override
  String get pastlifeSecondaryPathLabel => 'VOIE SECONDAIRE';

  @override
  String get pastlifeClearingProgressLabel => 'PROGRESSION DE LA PURIFICATION';

  @override
  String get pastlifeRemainingWorkLabel => 'TRAVAIL RESTANT';

  @override
  String get pastlifeDebtTimelineLabel => 'CALENDRIER DE DETTE';

  @override
  String get pastlifeMemoryAccessStat => 'ACCÈS À LA MÉMOIRE';

  @override
  String get pastlifeDreamVisitsStat => 'VISITATIONS EN RÊVE';

  @override
  String get pastlifeDejaVuStat => 'DÉJÀ-VU';

  @override
  String get pastlifeRegressionFitStat => 'ADÉQUATION RÉGRESSION';

  @override
  String get pastlifeActivationTitle => 'Activation de la vie antérieure';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'Maturité : $maturity · Statut : $status';
  }

  @override
  String get pastlifeKetuWord => 'Ketu';

  @override
  String get pastlifePastMasterySuffix => 'Maîtrise passée';

  @override
  String get pastlifeKetuMasteredLabel => 'KETU · CE QUE VOUS AVEZ MAÎTRISÉ';

  @override
  String get pastlifeRahuWord => 'Rahu';

  @override
  String get pastlifeFutureGrowthSuffix => 'Croissance future';

  @override
  String get pastlifeRahuPullsLabel =>
      'RAHU · CE QUI VOUS ATTIRE VERS L\'AVANT';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ Ombre : $shadow';
  }

  @override
  String get mentalScoresHeader => '🧠 SCORES MENTAUX';

  @override
  String get mentalStabilityStat => 'STABILITÉ\nMENTALE';

  @override
  String get mentalEmotionalBaselineStat => 'BASE\nÉMOTIONNELLE';

  @override
  String get mentalResilienceStat => 'RÉSILIENCE';

  @override
  String get mentalAnxietyStat => 'ANXIÉTÉ';

  @override
  String get mentalDepressionStat => 'DÉPRESSION';

  @override
  String get mentalRegulationStat => 'RÉGULATION';

  @override
  String get mentalProfileTitle => 'Profil mental';

  @override
  String get mentalConstitutionLabel => 'CONSTITUTION';

  @override
  String get mentalStressDriverLabel => 'FACTEUR DE STRESS';

  @override
  String get mentalStabilityAnchorLabel => 'ANCRE DE STABILITÉ';

  @override
  String get mentalStressResponseLabel => 'RÉPONSE AU STRESS';

  @override
  String get mentalAttachmentStyleLabel => 'STYLE D\'ATTACHEMENT';

  @override
  String get mentalBurnoutStageLabel => 'STADE D\'ÉPUISEMENT';

  @override
  String get mentalWord => 'Mental';

  @override
  String get mentalYogasTitle => 'Yogas mentaux';

  @override
  String get mentalStressPressureLabel => 'PRESSION DE STRESS';

  @override
  String get mentalWellnessTrendTitle => 'Tendance de bien-être';

  @override
  String get mentalHealthyCopingTitle => '✓ ADAPTATION SAINE';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ RISQUES MALSAINS';

  @override
  String get mentalRecommendedAlternativesTitle =>
      '✦ ALTERNATIVES RECOMMANDÉES';

  @override
  String get mentalSleepQualityStat => 'QUALITÉ DU SOMMEIL';

  @override
  String get mentalSocialSupportStat => 'SOUTIEN SOCIAL';

  @override
  String get mentalBurnoutVulnStat => 'VULN. ÉPUISEMENT';

  @override
  String get mentalSelfAwarenessStat => 'CONSCIENCE DE SOI';

  @override
  String get mentalAnxietyWord => 'Anxiété';

  @override
  String get mentalTypesSuffix => 'Types';

  @override
  String get mentalTherapyWord => 'Thérapie';

  @override
  String get mentalModalityFitSuffix => 'Adéquation de modalité';

  @override
  String get characterScoresHeader => '🔍 SCORES DE CARACTÈRE';

  @override
  String get characterStrengthStat => 'FORCE DE\nCARACTÈRE';

  @override
  String get characterIntegrityStat => 'INTÉGRITÉ';

  @override
  String get characterResilienceStat => 'RÉSILIENCE';

  @override
  String get characterAwarenessStat => 'CONSCIENCE';

  @override
  String get characterStabilityStat => 'STABILITÉ';

  @override
  String get characterEthicsStat => 'ÉTHIQUE';

  @override
  String get characterSurfacePersonalityTitle => 'Personnalité de surface';

  @override
  String get characterLagnaLabel => 'LAGNA';

  @override
  String get characterConstitutionLabel => 'CONSTITUTION';

  @override
  String get characterNakshatraLabel => 'NAKSHATRA';

  @override
  String get characterDeityLabel => 'DIVINITÉ';

  @override
  String get characterMoonManasTitle => 'Manas lunaire';

  @override
  String get characterSignLabel => 'SIGNE';

  @override
  String get characterHouseLabel => 'MAISON';

  @override
  String get characterWarmthStat => 'CHALEUR';

  @override
  String get characterEmpathyStat => 'EMPATHIE';

  @override
  String get characterLoyaltyStat => 'LOYAUTÉ';

  @override
  String get characterBoundariesStat => 'LIMITES';

  @override
  String get characterDharmaStat => 'DHARMA';

  @override
  String get characterTruthStat => 'VÉRITÉ';

  @override
  String get characterCompassionStat => 'COMPASSION';

  @override
  String get characterGenerosityStat => 'GÉNÉROSITÉ';

  @override
  String get characterSignatureVirtuesTitle => '★ VERTUS CARACTÉRISTIQUES';

  @override
  String get characterNaturalTalentsTitle => '● TALENTS NATURELS';

  @override
  String get characterShadowPatternsTitle => '⚠ SCHÉMAS DE L\'OMBRE';

  @override
  String get characterYogasTitle => 'Yogas de caractère';

  @override
  String get characterTestsLabel => 'ÉPREUVES';

  @override
  String get characterGiftsLabel => 'DONS';

  @override
  String get characterSelfAwareEiStat => 'IE CONSCIENCE DE SOI';

  @override
  String get characterSelfRegulateStat => 'AUTORÉGULATION';

  @override
  String get characterEmpathyEiStat => 'IE EMPATHIE';

  @override
  String get characterSocialSkillsStat => 'COMPÉTENCES SOCIALES';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'Réalisation : $pct%';
  }

  @override
  String get characterAtmakarakaWord => 'Atmakaraka';

  @override
  String get characterSoulSignatureSuffix => 'Signature d\'âme';

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
  String get healthScoresHeader => '🏥 SCORES DE SANTÉ';

  @override
  String get healthVitalityStat => 'VITALITÉ';

  @override
  String get healthImmunityStat => 'IMMUNITÉ';

  @override
  String get healthRecoveryStat => 'RÉCUPÉRATION';

  @override
  String get healthMentalStat => 'MENTAL';

  @override
  String get healthStressTolStat => 'TOL. STRESS';

  @override
  String get healthYogasTitle => 'Yogas de santé';

  @override
  String get healthDiseasePressureLabel => 'PRESSION PATHOLOGIQUE';

  @override
  String get healthTrendTitle => 'Tendance de santé';

  @override
  String get healthRecoveryWindowsTitle => 'Fenêtres de récupération';

  @override
  String get healthCautionPeriodsTitle => 'Périodes de prudence';

  @override
  String get healthFertilityStat => 'FERTILITÉ';

  @override
  String get healthBurnoutRiskStat => 'RISQUE D\'ÉPUISEMENT';

  @override
  String get healthAddictionVulnStat => 'VULN. DÉPENDANCE';

  @override
  String get healthWorkLifeBalStat => 'ÉQUIL. VIE-TRAVAIL';

  @override
  String get healthAyurvedicWord => 'Ayurvédique';

  @override
  String get healthConstitutionSuffix => 'Constitution';

  @override
  String get healthBodyWord => 'Corps';

  @override
  String get healthSystemMapSuffix => 'Carte des systèmes';

  @override
  String get healthBodyZoneWord => 'Zone corporelle';

  @override
  String get healthVulnerabilitySuffix => 'Vulnérabilité';

  @override
  String get healthDiseaseWord => 'Maladie';

  @override
  String get healthSusceptibilitySuffix => 'Susceptibilité';

  @override
  String get healthLifestyleFactorsTitle => 'Facteurs de mode de vie';

  @override
  String get healthSleepDisciplineLabel => 'DISCIPLINE DE SOMMEIL';

  @override
  String get healthDietDisciplineLabel => 'DISCIPLINE ALIMENTAIRE';

  @override
  String get healthExerciseNeedLabel => 'BESOIN D\'EXERCICE';

  @override
  String get healthSunlightNeedLabel => 'BESOIN DE SOLEIL';

  @override
  String get healthSocialTypeLabel => 'TYPE SOCIAL';

  @override
  String get healthHealingSpeedLabel => 'VITESSE DE GUÉRISON';

  @override
  String get wealthScoresHeader => '💰 SCORES DE RICHESSE';

  @override
  String get wealthStrengthStat => 'FORCE DE\nRICHESSE';

  @override
  String get wealthAccumulationStat => 'ACCUMU-\nLATION';

  @override
  String get wealthIncomeFlowStat => 'FLUX DE\nREVENUS';

  @override
  String get wealthSustainStat => 'DURABILITÉ';

  @override
  String get wealthMultiStreamStat => 'MULTI-SOURCES';

  @override
  String get wealthRetentionStat => 'RÉTENTION';

  @override
  String get wealthWord => 'Richesse';

  @override
  String get wealthYogasTitle => 'Yogas de richesse';

  @override
  String get wealthDrainsLabel => 'FUITES';

  @override
  String get wealthBoostersLabel => 'AMPLIFICATEURS';

  @override
  String get wealthYearlyTrendTitle => 'Tendance annuelle';

  @override
  String get wealthGrowthTitle => 'Croissance de richesse';

  @override
  String get wealthCashPressureTitle => 'Pression de trésorerie';

  @override
  String get wealthMoneyPersonalityTitle => 'Personnalité financière';

  @override
  String get wealthTypeLabel => 'TYPE DE RICHESSE';

  @override
  String get wealthRiskAppetiteLabel => 'APPÉTIT POUR LE RISQUE';

  @override
  String get wealthInvestmentStyleLabel => 'STYLE D\'INVESTISSEMENT';

  @override
  String get wealthMoneyPersonalityLabel => 'PERSONNALITÉ FINANCIÈRE';

  @override
  String get wealthSpendingLabel => 'DÉPENSES';

  @override
  String get wealthDebtProbStat => '% PROB. DETTE';

  @override
  String get wealthInheritanceStat => '% HÉRITAGE';

  @override
  String get wealthSuddenGainsStat => '% GAINS SOUDAINS';

  @override
  String get wealthSpouseBoostStat => '% ÉLAN DU CONJOINT';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'Probabilité de succès : $pct%';
  }

  @override
  String get wealthLifetimeClassLabel => 'CLASSE DE RICHESSE À VIE';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'Principal : $value';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'Pic : $value';
  }

  @override
  String get wealthIncomeWord => 'Revenu';

  @override
  String get wealthSourcesSuffix => 'Sources';

  @override
  String get wealthInvestmentWord => 'Investissement';

  @override
  String get wealthMixSuffix => 'Répartition';

  @override
  String wealthDrivenByLabel(Object planet) {
    return 'Motivé par $planet';
  }

  @override
  String get marriageScoresHeader => '💒 SCORES DE MARIAGE';

  @override
  String get marriageOverallStat => 'MARIAGE\nGLOBAL';

  @override
  String get marriageHarmonyStat => 'HARMONIE\nCONJUGALE';

  @override
  String get marriageDomesticStabilityStat => 'STABILITÉ\nDOMESTIQUE';

  @override
  String get marriageLongevityStat => 'LONGÉVITÉ';

  @override
  String get marriageSatisfactionStat => 'SATISFACTION';

  @override
  String get marriageClarityStat => 'CLARTÉ';

  @override
  String get marriageWindowsTitle => 'Fenêtres de mariage';

  @override
  String get marriagePhasesTitle => 'Phases du mariage';

  @override
  String get marriageInLawRelationsStat => 'RELATIONS BELLE-FAMILLE';

  @override
  String get marriageFamilyHarmonyStat => 'HARMONIE FAMILIALE';

  @override
  String get marriageFertilityStat => 'FERTILITÉ';

  @override
  String get marriageHomeOwnershipStat => 'PROPRIÉTÉ IMMOBILIÈRE';

  @override
  String get marriageDivorceRiskStat => 'RISQUE DE DIVORCE';

  @override
  String get marriageInfidelityStat => 'INFIDÉLITÉ';

  @override
  String get marriageConflictStat => 'CONFLIT';

  @override
  String get marriageDistanceStat => 'DISTANCE';

  @override
  String get marriageSeekInPartnerTitle => '★ À RECHERCHER CHEZ LE PARTENAIRE';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ À ÉVITER CHEZ LE PARTENAIRE';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'Réalisation : $pct%';
  }

  @override
  String get marriageDarakarakaWord => 'Darakaraka';

  @override
  String get marriageSpouseKarakaSuffix => 'Karaka du conjoint';

  @override
  String get marriageDarakarakaDkLabel => 'DARAKARAKA (DK)';

  @override
  String get marriage7thWord => '7ème';

  @override
  String get marriageSignLabel => 'SIGNE';

  @override
  String get marriageLordInLabel => 'MAÎTRE EN';

  @override
  String get marriageStrengthLabel => 'FORCE';

  @override
  String get marriageSpouseWord => 'Conjoint';

  @override
  String get marriageProfileSuffix => 'Profil';

  @override
  String get marriageSpouseTraitsTitle => '★ TRAITS DU CONJOINT';

  @override
  String get marriageLikelyProfessionsTitle => '● PROFESSIONS PROBABLES';

  @override
  String get marriageHarmonyWord => 'Harmonie';

  @override
  String get marriageRadarSuffix => 'Radar';

  @override
  String get marriagePhysicalLabel => 'Physique';

  @override
  String get marriageSharedValuesLabel => 'Valeurs partagées';

  @override
  String get marriageConflictResolutionLabel => 'Résolution des conflits';

  @override
  String get marriageMangalDoshLabel => '⚠ MANGAL DOSH';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'Sévérité : $value';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'Annulation : $value';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'Navamsa';

  @override
  String get multiChartTitleChild => 'Enfant';

  @override
  String get multiChartTitleLove => 'Amour';

  @override
  String get multiChartTitleKarma => 'Karma';

  @override
  String get multiChartTitleDefault => 'Multi-thèmes';

  @override
  String get multiChartSuffixProbability => 'Probabilité';

  @override
  String get multiChartSuffixCompatibility => 'Compatibilité';

  @override
  String get multiChartSuffixLinkage => 'Liaison';

  @override
  String get multiChartSuffixReport => 'Rapport';

  @override
  String get multiChartParticipantsLabel => 'PARTICIPANTS';

  @override
  String get multiChartAnalysisWord => 'Analyse';

  @override
  String get multiChartConfidenceSuffix => 'Confiance';

  @override
  String get multiChartQualityBadge => 'QUALITÉ';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'Analysez ce rapport d\'astrologie védique et donnez des observations détaillées :\n\n$formatted';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'Voici un rapport spécialisé d\'astrologie védique. Veuillez l\'analyser en détail et fournir des observations concrètes :\n\n$formatted';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'Passez en revue cette analyse d\'astrologie védique et expliquez les principales conclusions en langage simple :\n\n$formatted';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return 'Copié pour $label !';
  }

  @override
  String get childProbTitle1 => 'Enfant';

  @override
  String get childProbTitle2 => 'Probabilité';

  @override
  String get childNumberOfChildrenHeader1 => 'Nombre de';

  @override
  String get childNumberOfChildrenHeader2 => 'Enfants';

  @override
  String get childTimingHeader1 => 'Timing';

  @override
  String get childTimingHeader2 => 'Moola Dasha';

  @override
  String get child5thHouseHeader1 => '5ème maison';

  @override
  String get analysisWord => 'Analyse';

  @override
  String get jupiterWord => 'Jupiter';

  @override
  String get childD7Header1 => 'D7 Saptamsa';

  @override
  String get childBeejaHeader1 => 'Beeja et Kshetra';

  @override
  String get childBeejaHeader2 => 'Sphuta';

  @override
  String get childDoshaHeader1 => 'Dosha';

  @override
  String get childVedicHeader1 => 'Védique';

  @override
  String get childVedicHeader2 => 'Remèdes';

  @override
  String get progenyProbabilityLabel => 'PROBABILITÉ DE PROGÉNITURE';

  @override
  String get favorableWindowsLabel => 'FENÊTRES FAVORABLES';

  @override
  String get partnerOneLabel => 'Partenaire 1';

  @override
  String get partnerTwoLabel => 'Partenaire 2';

  @override
  String get moonSignLabel => 'Signe lunaire';

  @override
  String get lordInDusthana => 'Maître en Dusthana';

  @override
  String get lordStrengthLabel => 'Force du maître';

  @override
  String get houseStrengthLabel => 'Force de la maison';

  @override
  String get dignityLabel => 'Dignité';

  @override
  String get directBadge => 'Direct';

  @override
  String get notCombustBadge => 'Non combuste';

  @override
  String get in5thHouseBadge => 'En 5ème maison';

  @override
  String get aspects5thBadge => 'Aspecte la 5ème';

  @override
  String get no5thConnectionBadge => 'Aucune connexion à la 5ème';

  @override
  String jupiterInSignHeading(String sign) {
    return 'Jupiter en $sign';
  }

  @override
  String get d7LagnaLabel => 'Lagna D7';

  @override
  String get d7FifthSignLabel => '5ème signe D7';

  @override
  String get d7FifthLordLabel => 'Maître de la 5ème D7';

  @override
  String get jupiterInD7Label => 'Jupiter en D7';

  @override
  String get jupiterDignityLabel => 'Dignité de Jupiter';

  @override
  String get d7StrengthLabel => 'Force du D7';

  @override
  String get yesWord => 'Oui';

  @override
  String get noWord => 'Non';

  @override
  String get beejaSphutaTitle => 'BEEJA SPHUTA';

  @override
  String get kshetraSphutaTitle => 'KSHETRA SPHUTA';

  @override
  String get degreeLabel => 'Degré';

  @override
  String get signLordLabel => 'Maître du signe';

  @override
  String get presentInLabel => 'Présent dans';

  @override
  String get netPenaltyLabel => 'Pénalité nette';

  @override
  String get remedyGemstone => 'Remèdes en pierres précieuses';

  @override
  String get remedyMantra => 'Remèdes par mantra';

  @override
  String get remedyRitual => 'Remèdes rituels';

  @override
  String get remedyLifestyle => 'Remèdes liés au mode de vie';

  @override
  String get remedyCharitable => 'Remèdes caritatifs';

  @override
  String copiedForName(String name) {
    return 'Copié pour $name !';
  }

  @override
  String get mahadashaLabel => 'Mahadasha';

  @override
  String get mdPeriodLabel => 'Période MD';

  @override
  String get antardashaLabel => 'Antardasha';

  @override
  String get adPeriodLabel => 'Période AD';

  @override
  String get pratyantardashaLabel => 'Pratyantardasha';

  @override
  String get favorabilityLabel => 'Favorabilité';

  @override
  String factorPrefix(String factor) {
    return 'Facteur : $factor';
  }

  @override
  String appliesToLabel(String value) {
    return 'S\'applique à : $value';
  }

  @override
  String get qualityTag => 'QUALITÉ';

  @override
  String get reliabilityVeryHigh => 'Fiabilité très élevée';

  @override
  String get reliabilityGuidanceLevel => 'Lecture de niveau indicatif';

  @override
  String get karmaLinkTitle1 => 'Liaison';

  @override
  String get karmaLinkTitle2 => 'Karmique';

  @override
  String get karmaFoundationHeader1 => 'Fondation';

  @override
  String get karmaFoundationHeader2 => 'Karmique';

  @override
  String get karmaPairwiseHeader1 => 'Liaisons';

  @override
  String get karmaPairwiseHeader2 => 'par Paire';

  @override
  String get karmaGroupHeader1 => 'Schéma';

  @override
  String get karmaGroupHeader2 => 'de Groupe';

  @override
  String get karmaPastLifeHeader1 => 'Objectifs';

  @override
  String get karmaPastLifeHeader2 => 'de Vies Antérieures';

  @override
  String get karmaCurrentLifeHeader1 => 'Apprentissage';

  @override
  String get karmaCurrentLifeHeader2 => 'de la Vie Actuelle';

  @override
  String get karmaDebtsHeader2 => 'Dettes';

  @override
  String get karmaMoolaDashaHeader1 => 'Moola Dasha';

  @override
  String get karmaMoolaDashaHeader2 => 'Timing';

  @override
  String get karmaDeepAuditHeader1 => 'Tableau';

  @override
  String get karmaDeepAuditHeader2 => 'd\'Audit Approfondi';

  @override
  String get karmaHeroLabel => 'LIAISON KARMIQUE DES VIES ANTÉRIEURES';

  @override
  String get karmaKetuMastery => 'MAÎTRISE DE KETU';

  @override
  String get nakshatraLabel => 'Nakshatra';

  @override
  String get deityLabel => 'Divinité';

  @override
  String get masteryScoreLabel => 'Score de maîtrise';

  @override
  String get karmaRahuGrowth => 'CROISSANCE DE RAHU';

  @override
  String get growthScoreLabel => 'Score de croissance';

  @override
  String get karmaAtmakaraka => 'ATMAKARAKA';

  @override
  String get karmaSaturnKarma => 'KARMA DE SATURNE';

  @override
  String get karma12thHouse => '12ÈME MAISON';

  @override
  String get karma9thHousePunya => 'PUNYA DE LA 9ÈME MAISON';

  @override
  String get bhavaScoreLabel => 'Score du Bhava';

  @override
  String get karmaD60Signature => 'SIGNATURE D60';

  @override
  String get depthScoreLabel => 'Score de profondeur';

  @override
  String get linkageStrengthLabel => 'Force de la liaison';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'FACTEURS DE LIAISON ($count actifs)';
  }

  @override
  String get factorColumnLabel => 'Facteur';

  @override
  String get weightColumnLabel => 'Poids';

  @override
  String get meaningColumnLabel => 'Signification';

  @override
  String get statusColumnLabel => 'Statut';

  @override
  String get karmaPastLifeConnection => 'CONNEXION DE VIE ANTÉRIEURE';

  @override
  String get karmaCurrentLifeDynamic => 'DYNAMIQUE DE LA VIE ACTUELLE';

  @override
  String get karmaWhatTheyTeach => 'CE QU\'ILS S\'ENSEIGNENT MUTUELLEMENT';

  @override
  String get karmaGroupThemeHeader => 'THÈME KARMIQUE DE GROUPE';

  @override
  String get karmaSharedSettingHeader => 'CADRE PARTAGÉ DE VIE ANTÉRIEURE';

  @override
  String get karmaCollectiveKetuHeader => 'SCHÉMA COLLECTIF DE KETU';

  @override
  String get karmaCollectiveRahuHeader => 'SCHÉMA COLLECTIF DE RAHU';

  @override
  String get housesPrefixLabel => 'Maisons : ';

  @override
  String get signsPrefixLabel => 'Signes : ';

  @override
  String get karmicCohesionLabel => 'Cohésion karmique';

  @override
  String get karmaGroupSoulContractHeader => 'CONTRAT D\'ÂME DE GROUPE';

  @override
  String get goalLabel => 'Objectif';

  @override
  String get karmaSharedGoalHeader => 'OBJECTIF PARTAGÉ DE VIE ANTÉRIEURE';

  @override
  String get howToGrowHeader => 'COMMENT GRANDIR';

  @override
  String moolaDashaPrefix(String value) {
    return 'Moola Dasha : $value';
  }

  @override
  String get karmaSharedLessonHeader => 'LEÇON PARTAGÉE DU GROUPE';

  @override
  String get karmaMutualTeachingHeader => 'CARTE D\'ENSEIGNEMENT MUTUEL';

  @override
  String get karmaTeachingDynamicsPlaceholder =>
      'Les dynamiques d\'enseignement émergeront à mesure que les connexions karmiques s\'approfondissent.';

  @override
  String get typeFieldLabel => 'Type';

  @override
  String get basisFieldLabel => 'Base';

  @override
  String get resolutionPathHeader => 'VOIE DE RÉSOLUTION';

  @override
  String dashaTimingPrefix(String value) {
    return 'Timing de la Dasha : $value';
  }

  @override
  String get mutualDebtsHeader => 'DETTES MUTUELLES';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'Dates';

  @override
  String get groupKarmicWindowHeader => 'FENÊTRE KARMIQUE DE GROUPE';

  @override
  String parametersAuditedHeading(int count) {
    return '$count PARAMÈTRES AUDITÉS';
  }

  @override
  String get valuePrefixLabel => 'Valeur : ';

  @override
  String weightPrefix(String value) {
    return 'P : $value';
  }

  @override
  String get loveCompatTitle1 => 'Compatibilité';

  @override
  String get loveCompatTitle2 => 'Amoureuse';

  @override
  String get loveAttractionHeader1 => 'Attirance et';

  @override
  String get loveAttractionHeader2 => 'Alchimie';

  @override
  String get loveEmotionalHeader1 => 'Harmonie';

  @override
  String get loveEmotionalHeader2 => 'Émotionnelle';

  @override
  String get loveMentalHeader1 => 'Rapport';

  @override
  String get loveMentalHeader2 => 'Mental';

  @override
  String get lovePassionHeader1 => 'Passion et';

  @override
  String get lovePassionHeader2 => 'Physique';

  @override
  String get loveLongtermHeader1 => 'Long terme';

  @override
  String get loveKarmicHeader1 => 'Lien amoureux';

  @override
  String get loveKarmicHeader2 => 'Karmique';

  @override
  String get loveChallengesHeader1 => 'Défis et';

  @override
  String get loveChallengesHeader2 => 'Frictions';

  @override
  String get loveTimingHeader1 => 'Timing amoureux';

  @override
  String get loveRelationshipHeader1 => 'Dynamique';

  @override
  String get loveRelationshipHeader2 => 'Relationnelle';

  @override
  String get loveRemediesHeader1 => 'Remèdes et';

  @override
  String get loveRemediesHeader2 => 'Conseils';

  @override
  String get loveCompatHeroLabel => 'COMPATIBILITÉ AMOUREUSE';

  @override
  String get loveChipAttraction => 'Attirance';

  @override
  String get loveChipPassion => 'Passion';

  @override
  String get loveChipChallenge => 'Défi';

  @override
  String get venusSignLabel => 'Signe de Vénus';

  @override
  String get attractionScoreLabel => 'Score d\'attirance';

  @override
  String get activeContactsLabel => 'Contacts actifs';

  @override
  String get magneticPullLabel => 'Attraction magnétique';

  @override
  String get initialAttractionLabel => 'Attirance initiale';

  @override
  String get emotionalScoreLabel => 'Score émotionnel';

  @override
  String get elementMatchLabel => 'Correspondance des éléments';

  @override
  String get harmonyLabel => 'Harmonie';

  @override
  String get kootaYoni => 'YONI';

  @override
  String get kootaGana => 'GANA';

  @override
  String get kootaTara => 'TARA';

  @override
  String get doshaPresentBadge => 'Dosha présent';

  @override
  String get noDoshaBadge => 'Aucun dosha';

  @override
  String get axisLabel => 'Axe';

  @override
  String get mentalScoreLabel => 'Score mental';

  @override
  String get mercuryDynamicsLabel => 'DYNAMIQUE DE MERCURE';

  @override
  String get communicationStyleLabel =>
      'CORRESPONDANCE DE STYLE DE COMMUNICATION';

  @override
  String get intellectualConnectionLabel => 'CONNEXION INTELLECTUELLE';

  @override
  String get passionScoreLabel => 'Score de passion';

  @override
  String get marsVenusLabel => 'INTERACTION MARS-VÉNUS';

  @override
  String get physicalChemistryLabel => 'ALCHIMIE PHYSIQUE';

  @override
  String get yoniCompatLabel => 'COMPATIBILITÉ YONI';

  @override
  String get longtermScoreLabel => 'Score à long terme';

  @override
  String get seventhHouseSynastryLabel => 'SYNASTRIE DE LA 7ÈME MAISON';

  @override
  String get commitmentPotentialLabel => 'POTENTIEL D\'ENGAGEMENT';

  @override
  String get jupiterBlessingLabel => 'BÉNÉDICTION DE JUPITER';

  @override
  String get d9NavamsaResonanceLabel => 'RÉSONANCE D9 NAVAMSA';

  @override
  String get saturnLongevityLabel => 'LONGÉVITÉ DE SATURNE';

  @override
  String get karmicScoreLabel => 'Score karmique';

  @override
  String get darakarakaLinkLabel => 'LIEN DARAKARAKA';

  @override
  String get sourceLabel => 'Source';

  @override
  String get emotionalGiverReceiverLabel => 'DONNEUR/RECEVEUR ÉMOTIONNEL';

  @override
  String get powerBalanceLabel => 'ÉQUILIBRE DU POUVOIR';

  @override
  String get growthDynamicLabel => 'DYNAMIQUE DE CROISSANCE';

  @override
  String get addressesLabel => 'Concerne';

  @override
  String get loveScoresLabel => 'SCORES AMOUREUX';

  @override
  String get loveCapacityLabel => 'CAPACITÉ\nAMOUREUSE';

  @override
  String get emotionalAvailabilityLabel => 'DISPONIBILITÉ\nÉMOTIONNELLE';

  @override
  String get romanticAttractionLabel => 'ATTIRANCE\nROMANTIQUE';

  @override
  String get commitmentWord => 'ENGAGEMENT';

  @override
  String get intimacyWord => 'INTIMITÉ';

  @override
  String get fidelityWord => 'FIDÉLITÉ';

  @override
  String get loveProfileTitle => 'Profil amoureux';

  @override
  String get loveStyleLabel => 'STYLE AMOUREUX';

  @override
  String get attractionStyleLabel => 'STYLE D\'ATTIRANCE';

  @override
  String get lovePathLabel => 'CHEMIN AMOUREUX';

  @override
  String get currentPhaseLabel => 'PHASE ACTUELLE';

  @override
  String get commitmentStyleLabel => 'STYLE D\'ENGAGEMENT';

  @override
  String get loveWord => 'Amour';

  @override
  String get karakasWord => 'Karakas';

  @override
  String get attractedToLabel => 'ATTIRÉ PAR';

  @override
  String get whatPartnerSeesLabel => 'CE QUE LE PARTENAIRE VOIT';

  @override
  String get romancePatternTitle => 'Schéma amoureux';

  @override
  String get firstLoveAgeLabel => 'ÂGE DU PREMIER AMOUR';

  @override
  String get relationshipCountLabel => 'NOMBRE DE RELATIONS';

  @override
  String get avgDurationLabel => 'DURÉE MOYENNE';

  @override
  String get breakupTriggerLabel => 'DÉCLENCHEUR DE RUPTURE';

  @override
  String get heartbreakRecoveryLabel => 'RÉTABLISSEMENT APRÈS CHAGRIN';

  @override
  String get loveTrendTitle => 'Tendance amoureuse';

  @override
  String get newLoveWindowsTitle => 'Fenêtres de nouvel amour';

  @override
  String get loveBlocksTitle => 'Blocages amoureux';

  @override
  String get activeBlocksLabel => 'BLOCAGES ACTIFS';

  @override
  String get loveMarriagePctLabel => '% MARIAGE D\'AMOUR';

  @override
  String get heartbreakVulnLabel => 'VULN. CHAGRIN D\'AMOUR';

  @override
  String get selfSabotageLabel => 'AUTO-SABOTAGE';

  @override
  String get emotionalIqLabel => 'QI ÉMOTIONNEL';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'Accomplissement : $pct%';
  }

  @override
  String get languagesWord => 'Langages';

  @override
  String get givesLabel => 'DONNE';

  @override
  String get receivesLabel => 'REÇOIT';

  @override
  String get idealWord => 'Idéal';

  @override
  String get partnerWord => 'Partenaire';

  @override
  String get seekTheseTraitsLabel => 'RECHERCHEZ CES TRAITS';

  @override
  String get dealbreakersLabel => 'ÉLÉMENTS RÉDHIBITOIRES';

  @override
  String get propertyScoresLabel => 'SCORES IMMOBILIERS';

  @override
  String get acquisitionCapacityLabel => 'CAPACITÉ\nD\'ACQUISITION';

  @override
  String get homeOwnershipPctLabel => '% ACCESSION À\nLA PROPRIÉTÉ';

  @override
  String get reWealthPotentialLabel => 'POTENTIEL DE\nRICHESSE IMMOBILIÈRE';

  @override
  String get rentalWord => 'LOCATIF';

  @override
  String get vehiclesWord => 'VÉHICULES';

  @override
  String get landPctLabel => '% TERRAIN';

  @override
  String get propertyProfileTitle => 'Profil immobilier';

  @override
  String get karmaTypeLabel => 'TYPE DE KARMA';

  @override
  String get environmentLabel => 'ENVIRONNEMENT';

  @override
  String get styleLabel => 'STYLE';

  @override
  String get sizeLabel => 'TAILLE';

  @override
  String get locationLabel => 'EMPLACEMENT';

  @override
  String get actionNext12mLabel => 'ACTION 12 PROCHAINS MOIS';

  @override
  String get propertyWord => 'Immobilier';

  @override
  String get propertyYogasTitle => 'Yogas immobiliers';

  @override
  String get drainsLabel => 'FUITES';

  @override
  String get boostersLabel => 'AMPLIFICATEURS';

  @override
  String get propertyTrendTitle => 'Tendance immobilière';

  @override
  String get buyingWindowsTitle => 'Fenêtres d\'achat';

  @override
  String get constructionWindowsTitle => 'Fenêtres de construction';

  @override
  String get maternalInherPctLabel => '% HÉRITAGE MATERNEL';

  @override
  String get paternalInherPctLabel => '% HÉRITAGE PATERNEL';

  @override
  String get multiHomePctLabel => '% LOGEMENTS MULTIPLES';

  @override
  String get investmentPctLabel => '% INVESTISSEMENT';

  @override
  String get vehicleProfileTitle => 'Profil véhicule';

  @override
  String get countLabel => 'NOMBRE';

  @override
  String get firstAgeLabel => 'PREMIER ÂGE';

  @override
  String get categoryLabel => 'CATÉGORIE';

  @override
  String get luxuryLabel => 'LUXE';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'Nombre à vie : $count · Accomplissement : $pct%';
  }

  @override
  String get pressureWord => 'PRESSION';

  @override
  String get protectionWord => 'PROTECTION';

  @override
  String get astrologicalWord => 'Astrologique';

  @override
  String get keyRisksHeader1 => 'Risques';

  @override
  String get keyRisksHeader2 => 'Clés';

  @override
  String get reportCopiedShort => 'Rapport copié !';

  @override
  String get keyScoresLabel => 'SCORES CLÉS';

  @override
  String allScoresCountLabel(int count) {
    return 'Tous les scores ($count)';
  }

  @override
  String get windowsWord => 'Fenêtres';

  @override
  String get genericFailedMsg => 'Échec';

  @override
  String get unknownWord => 'Inconnu';

  @override
  String selectKarmaChartsLabel(int max) {
    return 'Sélectionnez 2 à $max thèmes';
  }

  @override
  String selectChartsLabelCount(int max) {
    return 'Sélectionnez $max thèmes';
  }

  @override
  String runningAnalysisLabel(String label) {
    return 'Analyse $label en cours...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'Choisissez 2 à $max thèmes pour analyser les liens karmiques';
  }

  @override
  String get pickMaleFemaleHint =>
      'Choisissez un thème masculin et un thème féminin';

  @override
  String get personOneLabel => 'Personne 1';

  @override
  String get personTwoLabel => 'Personne 2';

  @override
  String get analysisFailedMsg => 'Échec de l\'analyse';

  @override
  String analyzeChartsCountLabel(int count) {
    return 'Analyser $count thèmes';
  }

  @override
  String get contextGeneralLabel => 'Général';

  @override
  String get contextLoveLabel => 'Amour';

  @override
  String get contextBusinessLabel => 'Entreprise';

  @override
  String get contextFamilyLabel => 'Famille';

  @override
  String get contextTeamLabel => 'Équipe';

  @override
  String get contextFriendshipLabel => 'Amitié';

  @override
  String get relationshipIntelTitle => 'Intelligence relationnelle';

  @override
  String analyzingChartsCountLabel(int count) {
    return 'Analyse de $count thèmes en cours...';
  }

  @override
  String get relationshipContextLabel => 'Contexte relationnel';

  @override
  String get kundliMilanReportTitle => 'Rapport Kundli Milan';

  @override
  String get runningMilanAnalysisLabel => 'Analyse Milan en cours...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '$count/2 sélectionné(s)';
  }

  @override
  String get runMilanAnalysisBtn => 'Lancer l\'analyse Milan';

  @override
  String get noChartsCreateFirst =>
      'Aucun thème. Créez d\'abord un thème de naissance.';

  @override
  String get selectBirthChartAnalyze =>
      'Sélectionnez un thème de naissance à analyser';

  @override
  String get doshAnalysis => 'Analyse des doshas';

  @override
  String doshActiveCount(Object active, Object total) {
    return '$active actifs / $total vérifiés';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '$active actifs / $total yogas vérifiés';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'YOGAS ACTIFS ($count)';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'Masquer les yogas inactifs ($count)';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'Afficher les yogas inactifs ($count)';
  }

  @override
  String get loadFailed => 'Échec';

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
    return 'Sous-périodes de $planet';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return 'Maître de naissance : $lord • Solde : $balance ans';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'Lagna : $lagna • Solde : $balance ans';
  }

  @override
  String dashaYearsValue(Object years) {
    return '$years ans';
  }

  @override
  String get dashaCurrentPeriod => 'Période de Dasha actuelle';

  @override
  String dashaAsOf(Object date) {
    return 'En date du : $date';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'Yogas actifs dans la période actuelle ($count)';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'Doshas actifs dans la période actuelle ($count)';
  }

  @override
  String get dashaNoYogasTriggered => 'Aucun yoga déclenché';

  @override
  String get dashaNoDoshasTriggered => 'Aucun dosha déclenché';

  @override
  String get divD1Name => 'Rasi (D-1)';

  @override
  String get divD1Desc => 'Existence physique, toutes les affaires';

  @override
  String get divD2Name => 'Hora (D-2)';

  @override
  String get divD2Desc => 'Richesse, argent';

  @override
  String get divD3Name => 'Drekkana (D-3)';

  @override
  String get divD3Desc => 'Fratrie, courage';

  @override
  String get divD4Name => 'Chaturthamsa (D-4)';

  @override
  String get divD4Desc => 'Propriété, résidence, fortune';

  @override
  String get divD5Name => 'Panchamsa (D-5)';

  @override
  String get divD5Desc => 'Renommée, autorité, pouvoir';

  @override
  String get divD6Name => 'Shashthamsa (D-6)';

  @override
  String get divD6Desc => 'Problèmes de santé';

  @override
  String get divD7Name => 'Saptamsa (D-7)';

  @override
  String get divD7Desc => 'Enfants, petits-enfants';

  @override
  String get divD8Name => 'Ashtamsa (D-8)';

  @override
  String get divD8Desc => 'Troubles soudains, litiges';

  @override
  String get divD9Name => 'Navamsha (D-9)';

  @override
  String get divD9Desc => 'Mariage, conjoint, dharma';

  @override
  String get divD10Name => 'Dasamsha (D-10)';

  @override
  String get divD10Desc => 'Carrière, profession';

  @override
  String get divD11Name => 'Rudramsha (D-11)';

  @override
  String get divD11Desc => 'Mort, destruction';

  @override
  String get divD12Name => 'Dwadasamsha (D-12)';

  @override
  String get divD12Desc => 'Parents, liens du sang';

  @override
  String get divD16Name => 'Shodasamsha (D-16)';

  @override
  String get divD16Desc => 'Véhicules, conforts, plaisirs';

  @override
  String get divD20Name => 'Vimsamsha (D-20)';

  @override
  String get divD20Desc => 'Questions spirituelles, religieuses';

  @override
  String get divD24Name => 'Chaturvimsamsha (D-24)';

  @override
  String get divD24Desc => 'Apprentissage, connaissance, éducation';

  @override
  String get divD27Name => 'Nakshatramsha (D-27)';

  @override
  String get divD27Desc => 'Forces, faiblesses, nature';

  @override
  String get divD30Name => 'Trimsamsha (D-30)';

  @override
  String get divD30Desc => 'Maux, subconscient, châtiment';

  @override
  String get divD40Name => 'Khavedamsha (D-40)';

  @override
  String get divD40Desc => 'Faste/néfaste (maternel)';

  @override
  String get divD45Name => 'Akshavedamsha (D-45)';

  @override
  String get divD45Desc => 'Toutes les affaires (paternel)';

  @override
  String get divD60Name => 'Shashtyamsha (D-60)';

  @override
  String get divD60Desc => 'Karma de vie antérieure — LE PLUS IMPORTANT';

  @override
  String get lifeAreaCareer => 'Carrière';

  @override
  String get lifeAreaWealth => 'Richesse';

  @override
  String get lifeAreaMarriage => 'Mariage';

  @override
  String get lifeAreaHealth => 'Santé';

  @override
  String get lifeAreaSpirituality => 'Spiritualité';

  @override
  String lifeAreaGrade(Object grade) {
    return 'Note : $grade';
  }

  @override
  String get lifeAreaFactorsLabel => 'Facteurs :';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return 'Nak : $nakshatra ($pada)';
  }

  @override
  String planetNakLord(Object lord) {
    return 'ML : $lord';
  }

  @override
  String planetLongitude(Object value) {
    return 'Long : $value°';
  }

  @override
  String get chakraOverallHealth => 'Santé globale';

  @override
  String get careerWord => 'Carrière';

  @override
  String get failedToLoad => 'Échec du chargement';

  @override
  String get kundliAscendantLagna => 'Ascendant (Lagna)';

  @override
  String get kundliMoonSignRashi => 'Signe lunaire (Rashi)';

  @override
  String get kundliSunSign => 'Signe solaire';

  @override
  String kundliEngineLabel(Object engine) {
    return 'Moteur : $engine';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return 'Degré : $degree°  •  Nakshatra : $nakshatra ($pada)';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'Maître du Nakshatra : $lord  •  Dignité : $dignity';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return 'Thème $base — $sign';
  }

  @override
  String kundliBaseChart(Object base) {
    return 'Thème $base';
  }

  @override
  String get careerSummary => 'Résumé de carrière';

  @override
  String get phase => 'Phase';

  @override
  String get confidenceLabel => 'Confiance';

  @override
  String get careerScores => 'Scores de carrière';

  @override
  String get stabilityLabel => 'Stabilité';

  @override
  String get growthLabel => 'Croissance';

  @override
  String get gradeExcellent => 'Excellent';

  @override
  String get gradeGood => 'Bon';

  @override
  String get gradeAverage => 'Moyen';

  @override
  String get gradeBelowAvg => 'Sous la moyenne';

  @override
  String get gradeWeak => 'Faible';

  @override
  String get careerTypeDomain => 'Carrière et domaine';

  @override
  String get careerTimeline => 'Chronologie de carrière';

  @override
  String dashaLabel(Object dasha) {
    return 'Dasha : $dasha';
  }

  @override
  String get improvementSuggestions => 'Suggestions d\'amélioration';

  @override
  String get chartDetails => 'Détails du thème';

  @override
  String get keyHousesCareer => 'Maisons clés (carrière)';

  @override
  String get keyCareerPlanets => 'Planètes clés de carrière';

  @override
  String get empty => 'Vide';

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
  String get charGroupCorePersonality => 'Personnalité fondamentale';

  @override
  String get charGroupTrustHonesty => 'Confiance et honnêteté';

  @override
  String get charGroupLoyaltyCommitment => 'Loyauté et engagement';

  @override
  String get charGroupStrategicPrivacy => 'Stratégie et vie privée';

  @override
  String get charGroupFinancial => 'Financier';

  @override
  String get charGroupAngerConflict => 'Colère et conflit';

  @override
  String get charGroupMoralDharmic => 'Moral et dharmique';

  @override
  String get charGroupIntellectCommunication => 'Intellect et communication';

  @override
  String get charGroupEmotionalProfile => 'Profil émotionnel';

  @override
  String get charGroupMentalHealth => 'Santé mentale';

  @override
  String get charGroupRomantic => 'Romantique';

  @override
  String get charGroupMarriageFamily => 'Mariage et famille';

  @override
  String get charGroupOverallLife => 'Vie globale';

  @override
  String get grahaDrishti => 'Graha Drishti (aspects planétaires)';

  @override
  String get grahaDrishtiSubtitle => 'Qui aspecte qui (%)';

  @override
  String get lagnaAspectsReceived => 'Aspects reçus par le Lagna';

  @override
  String get rashiDrishti => 'Rashi Drishti (aspects de signes)';

  @override
  String get shadbalaRupas => 'rupas';

  @override
  String get bhavaHouse1 => 'Soi / Corps';

  @override
  String get bhavaHouse2 => 'Richesse / Famille';

  @override
  String get bhavaHouse3 => 'Fratrie / Courage';

  @override
  String get bhavaHouse4 => 'Foyer / Mère';

  @override
  String get bhavaHouse5 => 'Enfants / Intellect';

  @override
  String get bhavaHouse6 => 'Ennemis / Santé';

  @override
  String get bhavaHouse7 => 'Mariage / Partenaire';

  @override
  String get bhavaHouse8 => 'Longévité';

  @override
  String get bhavaHouse9 => 'Fortune / Gourou';

  @override
  String get bhavaHouse10 => 'Carrière / Père';

  @override
  String get bhavaHouse11 => 'Gains / Amis';

  @override
  String get bhavaHouse12 => 'Perte / Moksha';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '$sign • Maître : $lord';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV : $value';
  }

  @override
  String get sarvaAshtakavarga => 'Sarva Ashtakavarga (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'Total : $total rekhas (signe moyen = $avg)';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '$planet — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'Total : $total rekhas • Au signe natal : $score';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String gocharTransitScores(Object date) {
    return 'Gochar (scores de transit) — $date';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'Lune natale : $sign';
  }

  @override
  String get gocharBest => 'MEILLEUR';

  @override
  String get gocharWorst => 'PIRE';

  @override
  String copiedOpening(Object ai) {
    return 'Copié ! Ouverture de $ai...';
  }

  @override
  String get openLink => 'OUVRIR ↗';

  @override
  String get discussReportWithAI => 'DISCUTER DE CE RAPPORT AVEC L\'IA';

  @override
  String get reliabilityHigh => 'Fiabilité élevée';

  @override
  String get reliabilityModerate => 'Fiabilité modérée';

  @override
  String get reliabilityLow => 'Plus faible — indicatif seulement';

  @override
  String get reliabilityGoodEdu => 'Bonne fiabilité · Vérifié par D-24';

  @override
  String get relationshipWord => 'Relation';

  @override
  String get intelligenceWord => 'Intelligence';

  @override
  String get relationshipIntelligence => 'INTELLIGENCE RELATIONNELLE';

  @override
  String get typeLabel => 'TYPE';

  @override
  String get trustLabel => 'CONFIANCE';

  @override
  String get dhokaRisk => 'RISQUE DE TRAHISON (DHOKA)';

  @override
  String get powerLabel => 'Pouvoir';

  @override
  String get integrity => 'Intégrité';

  @override
  String get warmth => 'Chaleur';

  @override
  String get trustWord => 'Confiance';

  @override
  String get assertLabel => 'Assurance';

  @override
  String get character => 'Caractère';

  @override
  String get love => 'Amour';

  @override
  String get businessWord => 'Entreprise';

  @override
  String get karmic => 'Karmique';

  @override
  String get enmityRisk => 'Risque d\'inimitié';

  @override
  String get hdrChartProfiles => 'Profils des thèmes';

  @override
  String get hdrPairwiseAnalysis => 'Analyse par paire';

  @override
  String get hdrCriticalPatterns => 'Schémas critiques';

  @override
  String get hdrGroupRecommendations => 'Recommandations pour le groupe';

  @override
  String get sharedPractices => 'PRATIQUES PARTAGÉES';

  @override
  String get hdrIndividualGuidance => 'Conseils individuels';

  @override
  String get growthAreas => 'DOMAINES DE CROISSANCE';

  @override
  String get hdrCoreTheme => 'Thème central';

  @override
  String get growthOriented => 'ORIENTÉ CROISSANCE';

  @override
  String get groupTheme => 'THÈME DE GROUPE';

  @override
  String get compatibility => 'COMPATIBILITÉ';

  @override
  String get unifiedScoreLabel => 'SCORE UNIFIÉ';

  @override
  String get ashtakoot => 'ASHTAKOOT';

  @override
  String get probability => 'PROBABILITÉ';

  @override
  String get hdrAshtakootSummary => 'Résumé Ashtakoot';

  @override
  String get hdrGunBreakdown => 'Répartition des 8 Guna';

  @override
  String get hdrMangalDosh => 'Mangal Dosh';

  @override
  String get hdrD9CrossChart => 'Thème croisé D-9';

  @override
  String get d9Compatibility => 'COMPATIBILITÉ D-9';

  @override
  String get hdrDomainCompatibility => 'Compatibilité par domaine';

  @override
  String get emotional => 'Émotionnel';

  @override
  String get intellectual => 'Intellectuel';

  @override
  String get spiritual => 'Spirituel';

  @override
  String get financial => 'Financier';

  @override
  String get domestic => 'Domestique';

  @override
  String get communicationWord => 'Communication';

  @override
  String get sharedDharma => 'Dharma partagé';

  @override
  String get familyCreation => 'Création de famille';

  @override
  String get hdrMarriageTiming => 'Timing du mariage';

  @override
  String get jointMarriageWindows => 'Fenêtres conjointes de mariage';

  @override
  String get engagementWindows => 'Fenêtres de fiançailles';

  @override
  String get recommendedLabel => 'Recommandé';

  @override
  String get hdrKeyRisks => 'Risques clés';

  @override
  String get hdrFinalVerdict => 'Verdict final';

  @override
  String get marriageVerdict => 'VERDICT DE MARIAGE';

  @override
  String get educationWord => 'Éducation';

  @override
  String get learningSuffix => 'et apprentissage';

  @override
  String get coreEducationScores => 'SCORES ÉDUCATIFS PRINCIPAUX';

  @override
  String get academicSuccess => 'RÉUSSITE ACADÉMIQUE';

  @override
  String get learningCapacity => 'CAPACITÉ D\'APPRENTISSAGE';

  @override
  String get memory => 'MÉMOIRE';

  @override
  String get intelligence => 'INTELLIGENCE';

  @override
  String get research => 'RECHERCHE';

  @override
  String get hdrIntellectualProfile => 'Profil intellectuel';

  @override
  String get learningSignature => 'SIGNATURE D\'APPRENTISSAGE';

  @override
  String get hdrSubjectKaraka => 'Karaka des matières';

  @override
  String get hdrHouseFoundations => 'Fondations des maisons';

  @override
  String get hdrMercuryJupiter => 'Mercure et Jupiter';

  @override
  String get hdrEducationYogas => 'Yogas éducatifs';

  @override
  String get hdrDivisionalValidation => 'Validation divisionnaire';

  @override
  String get standing => 'STATUT';

  @override
  String get hdrSubjectRanking => 'Classement des matières';

  @override
  String get hdrDegreeLikelihood => 'Probabilité de diplôme';

  @override
  String get hdrStudyPeriods => 'Périodes d\'étude';

  @override
  String get earlySchooling => 'Scolarité précoce';

  @override
  String get higherEducation => 'Enseignement supérieur';

  @override
  String get postgradResearch => 'Études supérieures · Recherche';

  @override
  String get hdrLearningPreferences => 'Préférences d\'apprentissage';

  @override
  String get hdrChallengesGifts => 'Défis et dons';

  @override
  String get challenges => 'DÉFIS';

  @override
  String get cognitiveGifts => 'DONS COGNITIFS';

  @override
  String get naturalAbilities => 'CAPACITÉS NATURELLES';

  @override
  String get hdrSaraswatiRemedies => 'Remèdes de Saraswati';

  @override
  String get studentVerdict => 'VERDICT ÉTUDIANT';

  @override
  String get educationCareerLinkage => 'LIEN ÉDUCATION → CARRIÈRE';

  @override
  String get startupSuffix => 'et startup';

  @override
  String get coreBusinessScores => 'SCORES D\'ENTREPRISE PRINCIPAUX';

  @override
  String get overallBusiness => 'ENTREPRISE GLOBALE';

  @override
  String get ventureSuccess => 'SUCCÈS ENTREPRENEURIAL';

  @override
  String get eleventhHouse => '11ÈME MAISON';

  @override
  String get gains => 'GAINS';

  @override
  String get investor => 'INVESTISSEUR';

  @override
  String get hdrFounderArchetype => 'Archétype de fondateur';

  @override
  String get hdrTenthEleventhHouses => '10ème et 11ème maisons';

  @override
  String get hdrBusinessYogas => 'Yogas d\'entreprise';

  @override
  String get hdrRecommendedDomains => 'Domaines recommandés';

  @override
  String get hdrBusinessStyle => 'Style d\'entreprise';

  @override
  String get hdrFounderSkills => 'Compétences de fondateur';

  @override
  String get hdrFundingProfile => 'Profil de financement';

  @override
  String get recommendedPath => 'VOIE RECOMMANDÉE';

  @override
  String get investorAttract => 'ATTRAIT INVESTISSEUR';

  @override
  String get familyBacking => 'SOUTIEN FAMILIAL';

  @override
  String get hybridViability => 'VIABILITÉ HYBRIDE';

  @override
  String get launchWindow => 'Fenêtre de lancement';

  @override
  String get scaleWindow => 'Fenêtre de croissance';

  @override
  String get hdrBusinessRisks => 'Risques d\'entreprise';

  @override
  String get recoveryCapacity => 'CAPACITÉ DE RÉTABLISSEMENT';

  @override
  String get hdrRemediesSolutions => 'Remèdes et solutions';

  @override
  String get aiConnectionLost => 'Connexion perdue. Veuillez réessayer.';

  @override
  String get aiSomethingWrong => 'Une erreur s\'est produite';

  @override
  String get aiNoResponse => 'Aucune réponse';

  @override
  String get aiConnectionError => 'Erreur de connexion. Veuillez réessayer.';

  @override
  String get aiAutoDetect => 'Détection automatique';

  @override
  String aiAutoArrow(String lang) {
    return 'Auto → $lang';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'Langue : $lang';
  }

  @override
  String get aiNoBirthCharts => 'Aucun thème de naissance trouvé';

  @override
  String get aiCreateChartFirst =>
      'Créez d\'abord un thème de naissance pour discuter avec l\'IA';

  @override
  String get aiSelectChartBegin =>
      'Sélectionnez un thème de naissance pour commencer l\'analyse';

  @override
  String aiAnalyzingName(String name) {
    return 'Analyse en cours : $name';
  }

  @override
  String get aiChange => 'Changer';

  @override
  String get aiAnalyzingChart => 'Analyse de votre thème en cours...';

  @override
  String get aiAskStarsHint =>
      'Posez n\'importe quelle question aux étoiles...';

  @override
  String get aiSuggestedFollowups => 'Suggestions de suivi';

  @override
  String get aiThinking => 'Réflexion en cours...';

  @override
  String get aiThanks => 'Merci !';

  @override
  String get aiFeedbackNoted => 'Retour pris en compte';

  @override
  String get svcAll => 'Tous';

  @override
  String get svcNoServices => 'Aucun service disponible';

  @override
  String get svcFree => 'GRATUIT';

  @override
  String get astroFailedStartCall => 'Échec du démarrage de l\'appel';

  @override
  String get astroFailedStartChat => 'Échec du démarrage du chat';

  @override
  String astroErrorDetail(String error) {
    return 'Erreur : $error';
  }

  @override
  String get astroExperience => 'Expérience';

  @override
  String get astroSessions => 'Sessions';

  @override
  String get astroMinutes => 'Minutes';

  @override
  String get astroAbout => 'À propos';

  @override
  String get astroLanguages => 'Langues';

  @override
  String get astroRateCard => 'Grille tarifaire';

  @override
  String get astroVoice => 'Voix';

  @override
  String astroReviews(int count) {
    return 'Avis ($count)';
  }

  @override
  String get astroNoReviews => 'Aucun avis pour l\'instant';

  @override
  String get astroAnonymous => 'Anonyme';

  @override
  String get forgotPasswordSubtitle =>
      'Entrez votre e-mail et nous vous enverrons\nun lien pour réinitialiser votre mot de passe.';

  @override
  String get emailHint => 'votre@email.com';

  @override
  String get resendLink => 'Renvoyer le lien';

  @override
  String get appName => 'Nakshatralogy';

  @override
  String get cosmicJourneyAwaits => 'Votre voyage cosmique vous attend';

  @override
  String get home => 'Accueil';

  @override
  String get astrologers => 'Astrologues';

  @override
  String get services => 'Services';

  @override
  String get wallet => 'Portefeuille';

  @override
  String get profile => 'Profil';

  @override
  String get live => 'En direct';

  @override
  String get kundli => 'Kundli';

  @override
  String get chat => 'Chat';

  @override
  String get call => 'Appel';

  @override
  String get video => 'Vidéo';

  @override
  String get signIn => 'Se connecter';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get fullName => 'Nom complet';

  @override
  String get phone => 'Téléphone (facultatif)';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get sendResetLink => 'Envoyer le lien de réinitialisation';

  @override
  String get backToSignIn => 'Retour à la connexion';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get continueGoogle => 'Continuer avec Google';

  @override
  String get required => 'Obligatoire';

  @override
  String get minSixChars => 'Minimum 6 caractères';

  @override
  String get passwordsMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get validEmailRequired => 'Une adresse e-mail valide est requise';

  @override
  String get loginFailed => 'Échec de la connexion';

  @override
  String get signupFailed => 'Échec de l\'inscription';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get todaysHoroscope => 'HOROSCOPE DU JOUR';

  @override
  String get todaysRashi => 'Rashi du jour';

  @override
  String get tapDetails => 'Appuyez pour plus de détails';

  @override
  String get allServices => 'Tous les services';

  @override
  String get seeAll => 'TOUT VOIR';

  @override
  String get topAstrologers => 'Meilleurs astrologues';

  @override
  String get onlineExperts => 'Experts en ligne prêts pour une consultation';

  @override
  String get searchAstrologers => 'Rechercher des astrologues...';

  @override
  String get noAstrologersFound => 'Aucun astrologue trouvé';

  @override
  String get online => 'En ligne';

  @override
  String get offline => 'Hors ligne';

  @override
  String get busy => 'Occupé';

  @override
  String get perMin => '/min';

  @override
  String get noCharts => 'Aucun thème de naissance pour l\'instant';

  @override
  String get createFirst => 'Créez votre premier Janam Kundli';

  @override
  String get createChart => 'Créer un thème';

  @override
  String get newBirthChart => 'Nouveau thème de naissance';

  @override
  String get clientName => 'Nom du client';

  @override
  String get gender => 'Genre';

  @override
  String get male => 'Masculin';

  @override
  String get female => 'Féminin';

  @override
  String get other => 'Autre';

  @override
  String get dateOfBirth => 'Date de naissance';

  @override
  String get timeOfBirth => 'Heure de naissance';

  @override
  String get birthPlace => 'Lieu de naissance';

  @override
  String get birthPlaceHint => 'Tapez le nom de la ville pour rechercher...';

  @override
  String get generateKundli => 'Générer le Kundli';

  @override
  String get birthChartCreated => 'Thème de naissance créé !';

  @override
  String get deleteChart => 'Supprimer le thème ?';

  @override
  String get cannotUndo => 'Cette action est irréversible.';

  @override
  String get primary => 'PRINCIPAL';

  @override
  String get viewKundli => 'Voir le Kundli';

  @override
  String get completeBirthChart => 'Thème de naissance complet';

  @override
  String get birthDetails => 'Détails de naissance';

  @override
  String get name => 'Nom';

  @override
  String get dob => 'Date de naissance';

  @override
  String get tob => 'Heure de naissance';

  @override
  String get place => 'Lieu';

  @override
  String get summary => 'Résumé';

  @override
  String get planets => 'Planètes';

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
  String get lifeAreas => 'Domaines de vie';

  @override
  String get bhava => 'Bhava';

  @override
  String get chakras => 'Chakras';

  @override
  String get dashaActive => 'Dasha active';

  @override
  String get lagna => 'Lagna';

  @override
  String get moon => 'Lune';

  @override
  String get sun => 'Soleil';

  @override
  String get premiumSection => 'Section Premium';

  @override
  String get unlockReading =>
      'Débloquez cette lecture pour voir l\'analyse détaillée.';

  @override
  String get unlock => 'Débloquer';

  @override
  String get retrograde => 'Rétrograde';

  @override
  String get combust => 'Combuste';

  @override
  String get vargottama => 'Vargottama';

  @override
  String get exalted => 'Exalté';

  @override
  String get debilitated => 'Débilité';

  @override
  String get addBalance => 'Ajouter du solde';

  @override
  String get amount => 'Montant';

  @override
  String get walletBalance => 'Solde du portefeuille';

  @override
  String get recharge => 'Recharger';

  @override
  String get bonus => 'Bonus';

  @override
  String get serviceLabel => 'Service';

  @override
  String get refund => 'Remboursement';

  @override
  String get noTransactions => 'Aucune transaction';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get savedAstrologers => 'Astrologues enregistrés';

  @override
  String get noSavedAstrologers =>
      'Aucun astrologue enregistré pour l\'instant';

  @override
  String get myOrders => 'Mes commandes';

  @override
  String get communicationHistory => 'Historique des communications';

  @override
  String get chatHistory => 'Historique des chats';

  @override
  String get callHistory => 'Historique des appels';

  @override
  String get logout => 'Déconnexion';

  @override
  String get chatMessages => 'Messages du chat';

  @override
  String get typeMessage => 'Écrivez un message...';

  @override
  String get sessionEnded => 'Session terminée';

  @override
  String get endChat => 'Terminer le chat ?';

  @override
  String get endChatConfirm =>
      'Êtes-vous sûr de vouloir terminer cette session de chat ?';

  @override
  String get sendPhoto => 'Envoyer une photo';

  @override
  String get sendPDF => 'Envoyer un PDF';

  @override
  String get upload => 'Téléverser';

  @override
  String get fileNotFound => 'Fichier introuvable';

  @override
  String get voiceCall => 'Appel vocal';

  @override
  String get videoCall => 'Appel vidéo';

  @override
  String get ringing => 'Sonnerie...';

  @override
  String get connected => 'CONNECTÉ';

  @override
  String get endCall => 'Terminer l\'appel';

  @override
  String get mute => 'Muet';

  @override
  String get unmute => 'Réactiver le son';

  @override
  String get speaker => 'Haut-parleur';

  @override
  String get camera => 'Caméra';

  @override
  String get flip => 'Retourner';

  @override
  String get liveStreams => 'Diffusions en direct';

  @override
  String get noLiveStreams => 'Aucune diffusion en direct pour le moment';

  @override
  String get astrologerUnavailable =>
      'Astrologue indisponible. Fin de la diffusion.';

  @override
  String get streamEnded => 'Diffusion terminée';

  @override
  String get superChat => 'Super Chat';

  @override
  String get sendGift => 'Envoyer un cadeau';

  @override
  String get goBack => 'Retour';

  @override
  String get appPermissions => 'Autorisations de l\'application';

  @override
  String get grantPermissions => 'Accorder les autorisations';

  @override
  String get skipForNow => 'Ignorer pour l\'instant';

  @override
  String get microphone => 'Microphone';

  @override
  String get notifications => 'Notifications';

  @override
  String get storage => 'Stockage';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get retry => 'Réessayer';

  @override
  String get send => 'Envoyer';

  @override
  String get refresh => 'Actualiser';

  @override
  String get loading => 'Chargement...';

  @override
  String get noData => 'Aucune donnée disponible';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get language => 'Langue';

  @override
  String get english => 'Anglais';

  @override
  String get myDetails => 'Mes informations';

  @override
  String get myKundlis => 'Mes Kundlis';

  @override
  String get walletRecharge => 'Portefeuille et recharge';

  @override
  String get consultationHistory => 'Historique des consultations';

  @override
  String get helpSupport => 'Aide et support';

  @override
  String get biometricLogin => 'Connexion biométrique';

  @override
  String get pastVoiceConsultations => 'Consultations vocales passées';

  @override
  String get pastTextConversations => 'Conversations texte passées';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get totalCredit => 'Total crédité';

  @override
  String get totalDebit => 'Total débité';

  @override
  String get statement => 'Relevé';

  @override
  String get allTypes => 'Tous les types';

  @override
  String get prev => 'Préc.';

  @override
  String get next => 'Suivant';

  @override
  String get allInsights => 'Tous les aperçus';

  @override
  String get yourCompleteReading => 'VOTRE LECTURE COMPLÈTE';

  @override
  String get expertEngines => 'moteurs experts';

  @override
  String get eachInsightConsultation =>
      'Chaque aperçu est une consultation complète';

  @override
  String get engines => 'MOTEURS';

  @override
  String get dataPoints => 'POINTS DE DONNÉES';

  @override
  String get singleChart => 'UNIQUE';

  @override
  String get careerPurpose => 'CARRIÈRE ET OBJECTIF';

  @override
  String get wealthAssets => 'RICHESSE ET ACTIFS';

  @override
  String get loveRelationships => 'AMOUR ET RELATIONS';

  @override
  String get healthWellness => 'SANTÉ ET BIEN-ÊTRE';

  @override
  String get soulKarma => 'ÂME ET KARMA';

  @override
  String get specialistReports => 'Rapports spécialisés';

  @override
  String get searchByNameSpeciality => 'Rechercher par nom, spécialité...';

  @override
  String get sortedByRating => 'Trié par note';

  @override
  String get initiatingChat => 'Démarrage du chat...';

  @override
  String get startingCall => 'Démarrage de l\'appel...';

  @override
  String get yrs => 'ans';

  @override
  String get chatWithAISpecialist => 'Discuter avec le spécialiste IA';

  @override
  String get tapToStart => 'Appuyez pour commencer';

  @override
  String get astrologer => 'Astrologue';

  @override
  String get reports => 'Rapports';

  @override
  String get milan => 'Milan';

  @override
  String get forecast => 'Prévisions';

  @override
  String get rashi => 'Rashi';

  @override
  String get jupiterFavorsBold => 'Jupiter favorise les actions audacieuses';

  @override
  String get careerIlluminated =>
      'Votre secteur professionnel est illuminé — faites confiance à votre instinct.';

  @override
  String get todaysForecast => 'Prévisions du jour';

  @override
  String get engCareer => 'Carrière et emploi';

  @override
  String get engBusiness => 'Entreprise et startup';

  @override
  String get engEducation => 'Éducation et apprentissage';

  @override
  String get engLifePath => 'Chemin de vie et chance';

  @override
  String get engWealth => 'Richesse et finance';

  @override
  String get engDebt => 'Dette et redressement';

  @override
  String get engProperty => 'Immobilier et actifs';

  @override
  String get engLegal => 'Juridique et litiges';

  @override
  String get engLove => 'Amour et romance';

  @override
  String get engMarriage => 'Mariage et famille';

  @override
  String get engKundliMilan => 'Kundli Milan';

  @override
  String get engRelationship => 'Intelligence relationnelle';

  @override
  String get engLoveCompat => 'Compatibilité amoureuse';

  @override
  String get engChildProb => 'Probabilité d\'enfant';

  @override
  String get engHealth => 'Santé et bien-être';

  @override
  String get engMental => 'Mental et stress';

  @override
  String get engCharacter => 'Analyse du caractère';

  @override
  String get engPastLife => 'Vies antérieures et karma';

  @override
  String get engKarmaLink => 'Liaison karmique';

  @override
  String get noChatSessions => 'Aucune session de chat pour l\'instant';

  @override
  String get chatAppearHere =>
      'Vos conversations avec les astrologues apparaîtront ici.';

  @override
  String get noCallsYet => 'Aucun appel pour l\'instant';

  @override
  String get callAppearHere =>
      'Votre historique d\'appels avec les astrologues apparaîtra ici.';

  @override
  String get chatWith => 'Discuter avec';

  @override
  String get msgs => 'messages';

  @override
  String get voiceCallLabel => 'Appel vocal';

  @override
  String get videoCallLabel => 'Appel vidéo';

  @override
  String get pullToRefresh => 'Tirez vers le bas pour actualiser';

  @override
  String get sessionExpired => 'Session expirée';

  @override
  String get connectionFailed => 'Échec de la connexion';

  @override
  String get callActive => 'Appel en cours';

  @override
  String get lessThanOneMin => 'Moins d\'une minute restante';

  @override
  String get noMessages => 'Aucun message dans cette session';

  @override
  String get gocharForAllSigns => 'Le gochar du jour pour les 12 signes';

  @override
  String get selectChart => 'Sélectionnez un thème à analyser';

  @override
  String get selectTwoCharts => 'Sélectionnez deux thèmes';

  @override
  String get analyzing => 'Analyse en cours...';

  @override
  String get browseAstrologers => 'Parcourir les astrologues';

  @override
  String get probableNumber => 'NOMBRE PROBABLE';

  @override
  String get genderTendency => 'TENDANCE DE GENRE';

  @override
  String get son => 'FILS';

  @override
  String get daughter => 'FILLE';

  @override
  String get occupants => 'OCCUPANTS';

  @override
  String get beneficAspects => 'ASPECTS BÉNÉFIQUES';

  @override
  String get maleficAspects => 'ASPECTS MALÉFIQUES';

  @override
  String get nextFavorableWindow => 'PROCHAINE FENÊTRE FAVORABLE';

  @override
  String get totalDoshaPenalty => 'PÉNALITÉ TOTALE DE DOSHA';

  @override
  String get cancellationFactors => 'FACTEURS D\'ANNULATION';

  @override
  String get combinedFertility => 'INDICATION DE FERTILITÉ COMBINÉE';

  @override
  String get planetPositions => 'POSITIONS DES PLANÈTES';

  @override
  String get bestWindows => 'MEILLEURES FENÊTRES';

  @override
  String get worstWindows => 'PIRES FENÊTRES';

  @override
  String get scoreComponents => 'COMPOSANTES DU SCORE';

  @override
  String get topOpportunities => 'MEILLEURES OPPORTUNITÉS';

  @override
  String get topRisks => 'PRINCIPAUX RISQUES';

  @override
  String get remedies => 'REMÈDES';

  @override
  String get keyInsights => 'APERÇUS CLÉS';

  @override
  String get overallVerdict => 'VERDICT GLOBAL';

  @override
  String get venusContacts => 'CONTACTS CROISÉS DE VÉNUS';

  @override
  String get contact => 'Contact';

  @override
  String get effect => 'Effet';

  @override
  String get moonSignCompat => 'COMPATIBILITÉ DU SIGNE LUNAIRE';

  @override
  String get hisMoon => 'SA LUNE (LUI)';

  @override
  String get herMoon => 'SA LUNE (ELLE)';

  @override
  String get nakshatraCompat => 'COMPATIBILITÉ DES NAKSHATRAS';

  @override
  String get ketuContacts => 'CONTACTS DE KETU';

  @override
  String get rahuContacts => 'CONTACTS DE RAHU';

  @override
  String get pastLifeIndication => 'INDICATION DE VIE ANTÉRIEURE';

  @override
  String get totalChallengePenalty => 'PÉNALITÉ TOTALE DE DÉFI';

  @override
  String get manifestation => 'MANIFESTATION';

  @override
  String get cancellation => 'ANNULATION';

  @override
  String get navigation => 'NAVIGATION';

  @override
  String get potentialStrengths => 'FORCES POTENTIELLES';

  @override
  String get areasToNurture => 'DOMAINES À CULTIVER';

  @override
  String get relationshipGuidance => 'CONSEILS RELATIONNELS';

  @override
  String get detailedSummary => 'RÉSUMÉ DÉTAILLÉ';

  @override
  String get discussWithAI => 'DISCUTER AVEC L\'IA';

  @override
  String get planet => 'Planète';

  @override
  String get sign => 'Signe';

  @override
  String get house => 'Maison';

  @override
  String get strength => 'Force';

  @override
  String get copy => 'COPIER';

  @override
  String get confidence => 'CONFIANCE';

  @override
  String get d7Saptamsa => 'D7 SAPTAMSA';

  @override
  String get numberExplanation => 'EXPLICATION DU NOMBRE';

  @override
  String get genderExplanation => 'EXPLICATION DU GENRE';

  @override
  String get inFifth => 'En 5ème ?';

  @override
  String get primaryArchetype => 'ARCHÉTYPE PRINCIPAL';

  @override
  String get mitigation => 'ATTÉNUATION';

  @override
  String get soulCareerAlign => 'Alignement âme ↔ carrière';

  @override
  String get favorablePeriods => 'Périodes favorables';

  @override
  String get challengingPeriods => 'Périodes difficiles';

  @override
  String get keyHouses => 'Maisons clés';

  @override
  String get keyPlanets => 'Planètes clés';

  @override
  String get characterOverview => 'Aperçu du caractère';

  @override
  String get noYogasActive => 'Aucun yoga actuellement actif dans ce thème.';

  @override
  String get basedOnPlanetStrengths =>
      'Basé sur les forces planétaires et les positions en maison';

  @override
  String get basedOnTransits => 'Basé sur les transits planétaires actuels';

  @override
  String get currentPlanetPositions =>
      'Positions actuelles des planètes avec votre signe comme 1ère maison';

  @override
  String get favorablePeriodAdvice =>
      'Période favorable — concentrez-vous sur la croissance de carrière et les relations.';

  @override
  String get noClassicalYogas =>
      'Sans yogas classiques d\'apprentissage, le succès vient d\'un effort constant.';

  @override
  String get walletDeduction => 'Le montant sera déduit de votre portefeuille';

  @override
  String get bhakootAxis => 'AXE BHAKOOT';

  @override
  String get basis => 'BASE';

  @override
  String get selectChartsForMilan =>
      'Sélectionnez 2 thèmes pour l\'analyse Milan';

  @override
  String get selectMultiCharts => 'Sélectionnez 2 à 5 thèmes';

  @override
  String get running => 'EN COURS';

  @override
  String get past => 'passé';

  @override
  String get topActiveDoshas => 'PRINCIPAUX DOSHAS ACTIFS';

  @override
  String get allDoshas => 'TOUS LES DOSHAS';

  @override
  String get activeYogas => 'Yogas actifs';

  @override
  String get activeDoshas => 'Doshas actifs';

  @override
  String get yogaAnalysis => 'Analyse des yogas';

  @override
  String get factors => 'Facteurs';

  @override
  String get dominantPlanet => 'Planète dominante';

  @override
  String get startSession => 'Démarrer la session';

  @override
  String get notesSaved => 'Notes enregistrées';

  @override
  String get unlocked => 'Débloqué ! Profitez de votre lecture.';

  @override
  String get todaysGochar => 'Gochar du jour';

  @override
  String get todaysTransitChart => 'Thème de transit du jour';

  @override
  String get lifeAreaPredictions => 'Prédictions par domaine de vie';

  @override
  String get strengths => 'Forces';

  @override
  String get weaknesses => 'Faiblesses';

  @override
  String get ruledBy => 'Régi par';

  @override
  String get kundliMilan => 'Kundli Milan';

  @override
  String get startKundliMilan => 'Démarrer le Kundli Milan';

  @override
  String get recommendations => 'Recommandations';

  @override
  String get cancellations => 'Annulations';

  @override
  String get dashaSync => 'Synchronisation des Dashas';

  @override
  String get transitMarriageWindows => 'Fenêtres de mariage par transit';

  @override
  String get overlappingWindows => 'Fenêtres de mariage superposées';

  @override
  String get overallStrength => 'FORCE GLOBALE';

  @override
  String get stability => 'STABILITÉ';

  @override
  String get growth => 'CROISSANCE';

  @override
  String get clarity => 'CLARTÉ';

  @override
  String get recognition => 'RECONNAISSANCE';

  @override
  String get satisfaction => 'SATISFACTION';

  @override
  String get verdict => 'VERDICT';

  @override
  String get topRoles => 'MEILLEURS RÔLES';

  @override
  String get areasForGrowth => 'DOMAINES DE CROISSANCE';

  @override
  String get bestIndustries => 'MEILLEURS SECTEURS';

  @override
  String get employment => 'Emploi salarié';

  @override
  String get entrepreneurship => 'Entrepreneuriat';

  @override
  String get freelance => 'Freelance';

  @override
  String get portfolio => 'Portefeuille';

  @override
  String get burnoutRisk => 'Risque d\'épuisement professionnel';

  @override
  String get careerStagnation => 'Stagnation de carrière';

  @override
  String get workplaceConflict => 'Conflit au travail';

  @override
  String get positioning => 'POSITIONNEMENT';

  @override
  String get skillDevelopment => 'DÉVELOPPEMENT DES COMPÉTENCES';

  @override
  String get network => 'RÉSEAU';

  @override
  String get visibility => 'VISIBILITÉ';

  @override
  String get lagnaLord => 'Maître du Lagna';

  @override
  String get tenthLord => 'Maître de la 10ème';

  @override
  String get lord => 'MAÎTRE';

  @override
  String get lordPlacedIn => 'MAÎTRE PLACÉ EN';

  @override
  String get lordDignity => 'DIGNITÉ DU MAÎTRE';

  @override
  String get d9Dignity => 'DIGNITÉ D9';

  @override
  String get careerAnalysis => 'Analyse de carrière';

  @override
  String get launchWindows => 'Fenêtres de lancement';

  @override
  String get peakWindows => 'Fenêtres de pic';

  @override
  String get promotionWindows => 'Fenêtres de promotion';

  @override
  String get riskWindows => 'Fenêtres à risque';

  @override
  String get timingWindows => 'Fenêtres de timing';

  @override
  String get careerRisks => 'Risques de carrière';

  @override
  String get astrologicalRemedies => 'Remèdes astrologiques';

  @override
  String get practicalSolutions => 'Solutions pratiques';

  @override
  String get analysisConfidence => 'Confiance de l\'analyse';

  @override
  String get careerArchetype => 'Archétype de carrière';

  @override
  String get workStructure => 'Structure de travail';

  @override
  String get teamLeadership => 'Leadership d\'équipe';

  @override
  String get idealEnvironment => 'Environnement idéal';

  @override
  String get idealOrgSize => 'Taille d\'organisation idéale';

  @override
  String get fitScore => 'SCORE D\'ADÉQUATION';

  @override
  String get recommended => 'RECOMMANDÉ';

  @override
  String get divisionalValidation => 'Validation divisionnaire';

  @override
  String get houseAnalysis => 'Analyse des maisons';

  @override
  String get jaiminiKarakas => 'Karakas Jaimini';

  @override
  String get copyFullReport => 'Copier toutes les données du rapport';

  @override
  String get reportCopied => 'Données du rapport copiées !';

  @override
  String get biometricNotAvailable =>
      'La biométrie n\'est pas disponible sur cet appareil';

  @override
  String biometricErrorMsg(Object error) {
    return 'Erreur biométrique : $error';
  }

  @override
  String get biometricVerifyReason =>
      'Vérifiez pour activer la connexion biométrique';

  @override
  String get dobFormatLabel => 'Date de naissance (DD/MM/YYYY)';

  @override
  String get tobFormatLabel => 'Heure de naissance (HH:MM)';

  @override
  String get phoneLabel => 'Téléphone';

  @override
  String get activeBadge => 'ACTIF';

  @override
  String get chartCategoryLabel => 'Catégorie';

  @override
  String get freePrimaryDescription =>
      'Principal gratuit — utilisé pour l\'horoscope quotidien et les services de carte unique gratuits';

  @override
  String get searchChartsHint => 'Rechercher par nom ou date de naissance...';

  @override
  String unlockPriceLabel(Object price) {
    return 'Débloquer pour $price';
  }

  @override
  String unlockAiSpecialistIntl(Object price) {
    return 'Débloquez cet expert IA pour $price (une fois), acheté en toute sécurité via l\'App Store.';
  }

  @override
  String unlockAiSpecialistWallet(Object price) {
    return 'Débloquez cet expert IA pour $price (une fois). Le montant sera déduit de votre portefeuille.';
  }

  @override
  String get specialistNotAvailablePurchase =>
      'Cet expert n\'est pas encore disponible à l\'achat.';

  @override
  String get couldNotCompletePurchase =>
      'Impossible de finaliser l\'achat. Veuillez réessayer.';

  @override
  String get couldNotUnlockWalletBalance =>
      'Impossible de débloquer (vérifiez le solde du portefeuille)';

  @override
  String get freeBadge => 'GRATUIT';

  @override
  String activeSessionInProgress(Object kind) {
    return 'Vous avez un(e) $kind actif en cours';
  }

  @override
  String get returnLabel => 'Retour';

  @override
  String get enableNotificationsForAlerts =>
      'Activez les notifications pour recevoir des alertes de consultation et d\'offres';

  @override
  String get enableLabel => 'Activer';

  @override
  String get notificationsEnabled => 'Notifications activées';

  @override
  String get couldNotEnableNotifications =>
      'Impossible d\'activer — autorisez les notifications dans votre navigateur';

  @override
  String get amountInrLabel => 'Montant (₹)';

  @override
  String get noteOptionalLabel => 'Note (facultatif)';

  @override
  String get txnDate => 'DATE';

  @override
  String get txnDescription => 'DESCRIPTION';

  @override
  String get txnType => 'TYPE';

  @override
  String get txnAmount => 'MONTANT';

  @override
  String get txnBalance => 'SOLDE';

  @override
  String get credit => 'Crédit';

  @override
  String get debit => 'Débit';

  @override
  String get razorpayStripeNote =>
      '💳 En production, cela redirigera vers Razorpay/Stripe.';

  @override
  String get downloadPdf => 'Télécharger le PDF';

  @override
  String get chatWithAiCta => 'Discuter avec l\'IA';

  @override
  String get pdfServiceUnavailable =>
      'Le service PDF est temporairement indisponible. Veuillez réessayer plus tard.';

  @override
  String get pleaseUnlockFirst => 'Veuillez d\'abord débloquer ceci.';

  @override
  String get couldNotGeneratePdf =>
      'Impossible de générer le PDF. Veuillez réessayer.';

  @override
  String get statConsults => 'CONSULTATIONS';

  @override
  String get statCharts => 'CARTES';

  @override
  String get statWallet => 'PORTEFEUILLE';

  @override
  String get firstChartPrimaryInfo =>
      'Votre première carte est votre carte Principale gratuite. Les cartes supplémentaires débloquent les services individuellement.';

  @override
  String get tryDifferentFilter => 'Essayez un autre filtre';

  @override
  String get defaultChartName => 'Carte';

  @override
  String get balAbbr => 'Solde';
}
