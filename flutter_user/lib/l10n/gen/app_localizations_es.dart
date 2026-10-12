// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get awChooseLanguage => 'Elige tu idioma';

  @override
  String get awGoogleFailed =>
      'Error al iniciar sesión con Google. Inténtalo de nuevo.';

  @override
  String get awCompleteProfileTitle => 'Completa tu perfil';

  @override
  String awWelcomeName(String name) {
    return '¡Bienvenido, $name!';
  }

  @override
  String get awCompleteProfileSubtitle =>
      'Unos pocos datos para personalizar Nakshatralogy para ti.';

  @override
  String get awRegionLabel => 'Región';

  @override
  String get awRegionIndia => 'India';

  @override
  String get awRegionInternational => 'Internacional';

  @override
  String get awPreferredLanguage => 'Idioma preferido';

  @override
  String get awFinishSetup => 'Finalizar configuración';

  @override
  String get awChatFileWebUnsupported =>
      'Compartir archivos aún no está disponible en la web. Usa la aplicación móvil.';

  @override
  String get awVideoUnsupported =>
      'Las videollamadas no son compatibles con este navegador. Usa nuestra aplicación móvil o un navegador de escritorio compatible.';

  @override
  String get awClose => 'Cerrar';

  @override
  String get pwPremiumTitle => 'Informe Premium';

  @override
  String get pwLockedSubtitle =>
      'Desbloquea el análisis completo de esta carta';

  @override
  String pwUnlockFull(Object name) {
    return 'Desbloquear $name completo';
  }

  @override
  String pwUnlockPrice(Object price) {
    return 'Desbloquear · $price';
  }

  @override
  String get pwOneTime => 'Desbloqueo único — tuyo para siempre en esta carta';

  @override
  String get pwWhatYouGet => 'Qué obtienes';

  @override
  String get pwYourBalance => 'Saldo de tu billetera';

  @override
  String get pwInsufficient => 'Saldo insuficiente';

  @override
  String get pwRechargeToUnlock => 'Recarga para desbloquear';

  @override
  String get pwRechargeAmount => 'Monto de recarga (₹)';

  @override
  String get pwAddMoney => 'Agregar dinero';

  @override
  String get pwRechargeDone => 'Billetera recargada';

  @override
  String get pwRechargeFailed => 'La recarga falló. Inténtalo de nuevo.';

  @override
  String get pwUnlockFailed => 'No se pudo desbloquear. Inténtalo de nuevo.';

  @override
  String get pwUnlockedNow => '¡Desbloqueado! Cargando tu informe…';

  @override
  String get pwProcessing => 'Procesando…';

  @override
  String get pwPrimaryNoDelete =>
      'Tu Kundli Principal no se puede eliminar — es gratis para siempre.';

  @override
  String get pwPrimaryNoEdit => 'Tu Kundli Principal no se puede editar.';

  @override
  String get pwLoadingAccess => 'Verificando acceso…';

  @override
  String get pwMaybeLater => 'Quizás más tarde';

  @override
  String get updatePhoto => 'Actualizar Foto';

  @override
  String get takePhoto => 'Cámara';

  @override
  String get chooseFromGallery => 'Galería';

  @override
  String get removePhoto => 'Eliminar Foto';

  @override
  String get photoUpdated => 'Foto actualizada';

  @override
  String get photoUploadFailed =>
      'No se pudo subir la foto. Inténtalo de nuevo.';

  @override
  String get tapToChangePhoto => 'Toca para cambiar la foto';

  @override
  String get klSubtitle =>
      'Informe Védico de Vinculación Kármica de Vidas Pasadas con IA';

  @override
  String get klTitle => 'Vinculación Kármica de Vidas Pasadas';

  @override
  String get klSnapshotHeader => 'Resumen de Vinculación Kármica';

  @override
  String get klGaugePairwise => 'Vinculación Promedio entre Pares';

  @override
  String get klGaugeCohesion => 'Cohesión Grupal';

  @override
  String get klGaugeRahuKetu => 'Resonancia Rahu-Ketu';

  @override
  String get klGaugeAtmakaraka => 'Resonancia del Alma';

  @override
  String get klGaugeD60 => 'Resonancia D60';

  @override
  String get klChipSoulResonance => 'Fuerte resonancia de la firma del alma';

  @override
  String get klChipD60Resonance => 'Fuerte resonancia D60 de vidas pasadas';

  @override
  String get klChipCohesiveGroup => 'Grupo cohesivo';

  @override
  String get klChipNoDebts => 'No se detectaron deudas kármicas';

  @override
  String get klProfilesTitle => 'Perfiles de Cartas';

  @override
  String get klKetuAt => 'Ketu en';

  @override
  String get klRahuAt => 'Rahu en';

  @override
  String get klFoundationTitle => 'Fundamento Kármico por Carta';

  @override
  String get klFoundationSubtitle =>
      'El dominio de vidas pasadas y la dirección de vida actual de cada alma';

  @override
  String get klKetuMastery => 'Dominio de Ketu';

  @override
  String get klRahuGrowth => 'Crecimiento de Rahu';

  @override
  String get klNinthHousePunya => 'Punya de la Casa 9';

  @override
  String get klD60Depth => 'Profundidad Kármica D60';

  @override
  String get klAtmakarakaAgenda => 'Agenda del alma';

  @override
  String get klSaturnKarma => 'Karma de Saturno';

  @override
  String get klPairwiseTitle => 'Vinculaciones Kármicas entre Pares';

  @override
  String get klActiveFactors => 'Factores de vinculación activos';

  @override
  String get klGroupPatternTitle => 'Patrón Kármico Grupal';

  @override
  String get klSharedSetting => 'Escenario Compartido de Vida Pasada';

  @override
  String get klCohesionScore => 'Cohesión Kármica';

  @override
  String get klPastGoalsTitle => 'Objetivos de Vidas Pasadas';

  @override
  String get klLearningTitle => 'Aprendizaje de la Vida Actual';

  @override
  String get klTeachingMap => 'Mapa de Enseñanza Mutua';

  @override
  String get klDebtsTitle => 'Deudas Kármicas y Resoluciones';

  @override
  String get klNoDebtsDetected =>
      'No se detectaron deudas kármicas en este grupo';

  @override
  String get klTimingTitle => 'Timing Kármico de Moola Dasha';

  @override
  String get klAuditTitle => 'Tabla de Auditoría Profunda';

  @override
  String klAuditSubtitle(Object count) {
    return '$count parámetros kármicos examinados';
  }

  @override
  String get klTopicLinkage => 'Nuestra vinculación kármica general';

  @override
  String get klTopicPairwise => 'El vínculo kármico de una pareja específica';

  @override
  String get klTopicDebts => 'Deudas kármicas por resolver';

  @override
  String get klTopicLessons => 'Lo que vinimos a aprender';

  @override
  String get klTopicTiming => 'El mejor momento para nuestro grupo';

  @override
  String get klTopicGroup => 'Nuestra historia compartida de vida pasada';

  @override
  String get lcSubtitle => 'Informe Védico de Compatibilidad Amorosa con IA';

  @override
  String get lcTitle => 'Compatibilidad Amorosa';

  @override
  String get lcSnapshotHeader => 'Resumen de Compatibilidad Amorosa';

  @override
  String get lcGaugeAttraction => 'Atracción';

  @override
  String get lcGaugeEmotional => 'Armonía Emocional';

  @override
  String get lcGaugeMental => 'Sintonía Mental';

  @override
  String get lcGaugePassion => 'Pasión';

  @override
  String get lcGaugeLongterm => 'Armonía a Largo Plazo';

  @override
  String get lcChipStrongMental => 'Fuerte conexión mental';

  @override
  String get lcChipStrongLongterm => 'Fuerte potencial a largo plazo';

  @override
  String get lcChipStrongPassion => 'Fuerte química física';

  @override
  String get lcChipLowFriction => 'Poca fricción en general';

  @override
  String get lcChipKarmicPull => 'Fuerte atracción kármica';

  @override
  String get lcPartnersTitle => 'Resumen de la Pareja';

  @override
  String get lcVenusSuffix => 'Signo de Venus';

  @override
  String get lcAttractionTitle => 'Atracción y Química';

  @override
  String get lcAttractionScore => 'Puntaje de Atracción';

  @override
  String get lcActiveContacts => 'Contactos Activos de Venus';

  @override
  String get lcEmotionalTitle => 'Armonía Emocional';

  @override
  String get lcEmotionalScore => 'Puntaje de Armonía Emocional';

  @override
  String get lcNakshatraCompat => 'Compatibilidad de Nakshatra';

  @override
  String get lcYoniKoota => 'Yoni Koota';

  @override
  String get lcGanaKoota => 'Gana Koota';

  @override
  String get lcTaraKoota => 'Tara Koota';

  @override
  String get lcBhakootAxis => 'Eje Bhakoot';

  @override
  String get lcMentalTitle => 'Sintonía Mental';

  @override
  String get lcMentalScore => 'Puntaje de Sintonía Mental';

  @override
  String get lcPassionTitle => 'Pasión y Físico';

  @override
  String get lcPassionScore => 'Puntaje de Pasión';

  @override
  String get lcLongtermTitle => 'Armonía a Largo Plazo';

  @override
  String get lcLongtermScore => 'Puntaje de Armonía a Largo Plazo';

  @override
  String get lcCommitmentPotential => 'Potencial de Compromiso';

  @override
  String get lc7thHouseSynastry => 'Sinastría de la Casa 7';

  @override
  String get lcJupiterBlessing => 'Bendición de Júpiter';

  @override
  String get lcD9Resonance => 'Resonancia D9 Navamsa';

  @override
  String get lcSaturnLongevity => 'Longevidad de Saturno';

  @override
  String get lcKarmicTitle => 'Vínculo Amoroso Kármico';

  @override
  String get lcKarmicScore => 'Puntaje de Vínculo Kármico';

  @override
  String get lcKetuContacts => 'Contactos de Ketu';

  @override
  String get lcRahuContacts => 'Contactos de Rahu';

  @override
  String get lcChallengesTitle => 'Desafíos y Fricción';

  @override
  String get lcNoChallenges =>
      'No se detectaron puntos de fricción significativos en ninguna de las cartas';

  @override
  String get lcTotalPenalty => 'Penalización Total por Desafíos';

  @override
  String get lcTimingTitle => 'Timing Amoroso — Moola Dasha';

  @override
  String get lcDynamicsTitle => 'Dinámica de la Relación';

  @override
  String get lcPowerBalance => 'Equilibrio de Poder';

  @override
  String get lcGiverReceiver => 'Dador/Receptor Emocional';

  @override
  String get lcGrowthDynamic => 'Dinámica de Crecimiento';

  @override
  String get lcAreasToNurture => 'Áreas a Cultivar';

  @override
  String get lcTopicTiming => 'El mejor momento para nuestra relación';

  @override
  String get lcTopicChallenges => 'Desafíos a superar';

  @override
  String get lcTopicKarmic => 'Nuestra conexión kármica';

  @override
  String get lcTopicRemedies => 'Remedios recomendados';

  @override
  String get lcTopicLongterm => 'Nuestro potencial a largo plazo';

  @override
  String get lcTopicDynamics => 'La dinámica de nuestra relación';

  @override
  String get cpSubtitle => 'Informe Védico de Probabilidad de Hijos con IA';

  @override
  String get cpTitle => 'Probabilidad de Hijos';

  @override
  String get cpSnapshotHeader => 'Resumen de Probabilidad de Descendencia';

  @override
  String get cpGauge5thHouse => 'Casa 5';

  @override
  String get cpGaugeJupiter => 'Júpiter/Putrakaraka';

  @override
  String get cpGaugeD7 => 'D7 Saptamsa';

  @override
  String get cpGaugeSphuta => 'Beeja-Kshetra';

  @override
  String get cpGaugeTiming => 'Timing de Dasha';

  @override
  String get cpChipStrongPutrakaraka => 'Putrakaraka fuerte (Júpiter)';

  @override
  String get cpChipLowDoshaPenalty => 'Baja penalización por dosha';

  @override
  String get cpChipFavorableTiming => 'Timing de dasha favorable';

  @override
  String get cpChipNoDoshas => 'No se detectaron doshas de descendencia';

  @override
  String get cpPartnersTitle => 'Resumen de la Pareja';

  @override
  String get cpLagnaSuffix => 'Lagna';

  @override
  String get cpMoonSuffix => 'Signo lunar';

  @override
  String get cpNumberTitle => 'Número de Hijos y Tendencia de Género';

  @override
  String get cpProbableNumber => 'Número Probable';

  @override
  String get cpFirstChildTendency => 'Tendencia del Primer Hijo';

  @override
  String get cpSpacing => 'Nota de Espaciamiento';

  @override
  String get cpTimingTitle => 'Timing — Moola Dasha';

  @override
  String get cpCombinedTiming => 'Timing Combinado';

  @override
  String get cpNextWindow => 'Próxima Ventana Favorable';

  @override
  String get cp5thHouseTitle => 'Análisis de la Casa 5';

  @override
  String get cp5thHouseSubtitle =>
      'La casa de los hijos (Putra Bhava), por persona';

  @override
  String get cpJupiterTitle => 'Júpiter — Análisis del Putrakaraka';

  @override
  String get cpJupiterSubtitle =>
      'El significador natural de los hijos, por persona';

  @override
  String get cpD7Title => 'Análisis D7 Saptamsa';

  @override
  String get cpD7Subtitle => 'La carta divisional específica para los hijos';

  @override
  String get cpD7Strength => 'Fuerza del D7';

  @override
  String get cpSphutaTitle => 'Beeja y Kshetra Sphuta';

  @override
  String get cpBeejaSphuta => 'Beeja Sphuta (Semilla)';

  @override
  String get cpKshetraSphuta => 'Kshetra Sphuta (Campo)';

  @override
  String get cpDoshaTitle => 'Análisis de Dosha';

  @override
  String get cpNoDoshasDetected =>
      'No se detectaron doshas relevantes para la descendencia en ninguna de las cartas';

  @override
  String get cpRemediesTitle => 'Remedios Recomendados';

  @override
  String get cpAddresses => 'Aborda';

  @override
  String get cpTopicTiming => 'El mejor momento para la concepción';

  @override
  String get cpTopicNumber => 'Cuántos hijos podríamos tener';

  @override
  String get cpTopicDosha => 'Doshas a tratar';

  @override
  String get cpTopicRemedies => 'Remedios recomendados';

  @override
  String get cpTopicFifthHouse => 'La fuerza de nuestra casa 5';

  @override
  String get cpTopicJupiter => 'El papel de Júpiter en esto';

  @override
  String get riSubtitle =>
      'Informe Védico de Inteligencia de Relaciones con IA';

  @override
  String get riTitle => 'Inteligencia de Relaciones';

  @override
  String get riSnapshotHeader => 'Resumen del Grupo';

  @override
  String get riGaugeCohesion => 'Cohesión Grupal';

  @override
  String get riGaugeTrust => 'Clima de Confianza';

  @override
  String get riGaugeProductivity => 'Productividad';

  @override
  String get riGaugeCreativity => 'Creatividad';

  @override
  String get riChipNoAlerts => 'Sin alertas críticas';

  @override
  String get riChipStrongCohesion => 'Fuerte cohesión grupal';

  @override
  String get riChipHighTrust => 'Alto clima de confianza';

  @override
  String get riChipNoHiddenEnemy => 'Sin señal de enemigo oculto';

  @override
  String get riChipHealthyGroup => 'Grupo saludable en general';

  @override
  String get riProfilesTitle => 'Perfiles de Cartas';

  @override
  String riProfilesSubtitle(Object count) {
    return '$count personas en este grupo';
  }

  @override
  String get riLagnaSuffix => 'Lagna';

  @override
  String get riIntegrity => 'Integridad';

  @override
  String get riWarmth => 'Calidez';

  @override
  String get riTrustworthiness => 'Confiabilidad';

  @override
  String get riAssertiveness => 'Asertividad';

  @override
  String get riGroupDynamicsTitle => 'Resumen de la Dinámica Grupal';

  @override
  String get riMostSupportive => 'Más Solidario';

  @override
  String get riMostChallenged => 'Más Desafiado';

  @override
  String get riHiddenEnemyAlert => 'Señal de Enemigo Oculto Detectada';

  @override
  String get riBestWorstTitle => 'Pares Mejores y Más Desafiantes';

  @override
  String get riBestPair => 'VÍNCULO MÁS FUERTE';

  @override
  String get riWorstPair => 'NECESITA ATENCIÓN';

  @override
  String get riAlliances => 'Alianzas Probables';

  @override
  String get riConflicts => 'Puntos de Fricción Probables';

  @override
  String get riPairwiseTitle => 'Análisis por Pares';

  @override
  String riPairwiseSubtitle(Object count) {
    return '$count pares analizados';
  }

  @override
  String get riDynamic => 'Dinámica';

  @override
  String get riKarmicLink => 'Vínculo kármico';

  @override
  String get riMutualTrust => 'Confianza mutua';

  @override
  String get riBetrayalRisk => 'Riesgo de traición';

  @override
  String get riPowerDistribution => 'Distribución de poder';

  @override
  String get riPowerHealth => 'Salud del equilibrio de poder';

  @override
  String get riCriticalPatternsTitle => 'Patrones Críticos';

  @override
  String get riGroupRecsTitle => 'Recomendaciones para el Grupo';

  @override
  String get riSharedPractices => 'Prácticas Compartidas';

  @override
  String get riCommStyle => 'Estilo de Comunicación Recomendado';

  @override
  String get riGrowthFocus => 'Enfoque de Crecimiento Recomendado';

  @override
  String get riIndividualTitle => 'Guía Individual';

  @override
  String get riBestAllies => 'Mejores Aliados';

  @override
  String get riHandleWithCare => 'Manejar con Cuidado';

  @override
  String get riCoreThemeTitle => 'Tema Central del Grupo';

  @override
  String get riLayerPairwise => 'Completitud por Pares';

  @override
  String get riLayerD1 => 'Carta Natal (D1)';

  @override
  String get riLayerD9 => 'Navamsa (D9)';

  @override
  String get riLayerD10 => 'Dashamsa (D10)';

  @override
  String get riLayerD30 => 'Trimshamsa (D30)';

  @override
  String get riLayerJaimini => 'Señal Jaimini';

  @override
  String get riLayerBehavior => 'Claridad de Comportamiento';

  @override
  String get riLayerCoherence => 'Coherencia Grupal';

  @override
  String get riTopicDynamics => 'La dinámica de nuestro grupo';

  @override
  String get riTopicPairwise => 'La compatibilidad de una pareja específica';

  @override
  String get riTopicAlerts => 'Alertas críticas';

  @override
  String get riTopicGrowth => 'Cómo podemos crecer juntos';

  @override
  String get riTopicRecs => 'Prácticas recomendadas';

  @override
  String get riTopicTheme => 'El tema central de nuestro grupo';

  @override
  String get kmSubtitle => 'Informe Védico de Kundli Milan con IA';

  @override
  String get kmTitle => 'Kundli Milan';

  @override
  String get kmSnapshotHeader => 'Resumen de Compatibilidad';

  @override
  String kmAshtakootScore(Object score) {
    return 'Ashtakoot: $score/36';
  }

  @override
  String get kmGaugeAshtakoot => 'Ashtakoot %';

  @override
  String get kmGaugeD9 => 'Karma Matrimonial D9';

  @override
  String get kmGaugeMangal => 'Balance de Mangal';

  @override
  String get kmGaugePapa => 'Balance Kármico';

  @override
  String get kmGaugeAk => 'Resonancia del Alma';

  @override
  String get kmChipNoNadi => 'Sin Nadi Dosh';

  @override
  String get kmChipNoBhakoot => 'Sin Bhakoot Dosh';

  @override
  String get kmChipMangalCancelled => 'Mangal Dosh cancelado';

  @override
  String get kmChipPapaBalanced => 'Carga kármica equilibrada';

  @override
  String get kmChipStrongChemistry => 'Fuerte química física';

  @override
  String get kmChipStrongD9 => 'Fuerte karma matrimonial D9';

  @override
  String get kmChipLongevity => 'Fuerte alineación de longevidad';

  @override
  String get kmAshtakootTitle => 'Ashtakoot Guna Milan';

  @override
  String get kmAshtakootSubtitle =>
      'El sistema clásico de compatibilidad de 8 puntos, sobre 36';

  @override
  String get kmNadiSeverity => 'Severidad de Nadi';

  @override
  String get kmBhakootSeverity => 'Severidad de Bhakoot';

  @override
  String get kmGanaSignature => 'Firma de Gana';

  @override
  String get kmMangalTitle => 'Verificación de Mangal Dosha';

  @override
  String get kmD9Title => 'D9 Navamsa — Karma Matrimonial';

  @override
  String get kmD9Subtitle =>
      'La carta matrimonial a nivel del alma, considerada la más importante clásicamente';

  @override
  String get kmD9Score => 'Compatibilidad D9';

  @override
  String get kmLagnaRelation => 'Relación de Lagna';

  @override
  String get km7thLordRelation => 'Relación del señor de la casa 7';

  @override
  String get kmKarakasTitle => 'Karakas del Alma y del Cónyuge';

  @override
  String get kmAtmakaraka => 'Planeta del Alma';

  @override
  String get kmAkCompatibility => 'Resonancia de la Firma del Alma';

  @override
  String get kmUlCompatibility => 'Alineación del Karaka del Cónyuge';

  @override
  String get kmUlSigns => 'Señores de Upapada';

  @override
  String get kmChemistryTitle => 'Química Venus-Marte';

  @override
  String get kmPhysicalChemistry => 'Química Física';

  @override
  String get kmEmotionalWarmth => 'Calidez Emocional';

  @override
  String get kmAestheticAlignment => 'Alineación Estética';

  @override
  String get kmElementalSynthesis => 'Síntesis Elemental';

  @override
  String get kmHouseCrossTitle => 'Análisis Cruzado de las Casas 7 y 8';

  @override
  String get km78Compatibility => 'Compatibilidad de las Casas 7-8';

  @override
  String get km8thHouseSignature => 'Firma de Longevidad Conjunta';

  @override
  String get kmLongevityAlignment => 'Alineación de Longevidad';

  @override
  String get km7thLordFriendship => 'Amistad del señor de la casa 7';

  @override
  String get kmDomainsTitle => 'Compatibilidad por Dominio';

  @override
  String get kmConflictEngagement => 'Estilo de Conflicto';

  @override
  String get kmDashaTitle => 'Sincronía de Dasha y Tránsito';

  @override
  String get kmDashaSync => 'Sincronía de Dasha';

  @override
  String get kmTransitAlignment => 'Alineación de Tránsito';

  @override
  String get kmTimingTitle => 'Timing del Matrimonio';

  @override
  String get kmMarriageWindow => 'Ventana de Matrimonio';

  @override
  String get kmEngagementWindow => 'Ventana de Compromiso';

  @override
  String get kmRecommendedRange => 'Plazo Recomendado';

  @override
  String get kmMuhurtaNotes => 'Notas de Muhurta';

  @override
  String get kmRisksTitle => 'Riesgos a Considerar';

  @override
  String get kmConflictRisk => 'Riesgo de Conflicto';

  @override
  String get kmCommunicationRisk => 'Riesgo de Comunicación';

  @override
  String get kmFinanceRisk => 'Riesgo de Conflicto Financiero';

  @override
  String get kmFamilyDynamicsRisk => 'Riesgo de Dinámica Familiar';

  @override
  String get kmMentalHealthRisk => 'Riesgo de Alineación de Salud Mental';

  @override
  String get kmStrengthsTitle => 'Principales Fortalezas de Compatibilidad';

  @override
  String get kmSharedGrowth => 'Potencial de Crecimiento Compartido';

  @override
  String get kmSharedCreative => 'Potencial Creativo Compartido';

  @override
  String get kmJourneyTitle => 'Recorrido y Crecimiento de la Relación';

  @override
  String get kmCurrentPhase => 'Fase actual';

  @override
  String get kmEarlyArc => 'Matrimonio Temprano';

  @override
  String get kmMiddleArc => 'Matrimonio Medio';

  @override
  String get kmMatureArc => 'Matrimonio Maduro';

  @override
  String get kmElderArc => 'Años Mayores';

  @override
  String get kmPeakPhase => 'Fase de Máxima Compañía';

  @override
  String get kmGrowthAreas => 'Áreas de Crecimiento';

  @override
  String get kmCommProtocols => 'Protocolos de Comunicación';

  @override
  String get kmSharedPractices => 'Prácticas Compartidas';

  @override
  String get kmImprovementTitle => 'Tema Central y Plan de Mejora';

  @override
  String get kmVerdictTitle => 'Veredicto Final';

  @override
  String get kmRealizationPotential =>
      'Potencial de Realización de la Relación';

  @override
  String get kmLayerAshtakoot => 'Ashtakoot';

  @override
  String get kmLayerD9 => 'D9 Navamsa';

  @override
  String get kmLayerMangalPapa => 'Mangal y Papasamya';

  @override
  String get kmLayerVenusMars => 'Venus-Marte';

  @override
  String get kmLayerDashaSync => 'Sincronía de Dasha';

  @override
  String get kmLayerH7H8 => 'Cruce de Casas 7-8';

  @override
  String get kmLayerAkResonance => 'Resonancia de Atmakaraka';

  @override
  String get kmLayerDomains => 'Dimensiones de Dominio';

  @override
  String get kmTopicAshtakoot => 'Nuestro puntaje de Ashtakoot';

  @override
  String get kmTopicMangal => 'Preocupaciones sobre Mangal Dosha';

  @override
  String get kmTopicD9 => 'Nuestro karma matrimonial (D9)';

  @override
  String get kmTopicTiming => 'El mejor momento para el matrimonio';

  @override
  String get kmTopicRisks => 'Riesgos para los que prepararse';

  @override
  String get kmTopicGrowth => 'Cómo podemos crecer juntos';

  @override
  String get kmTopicRemedies => 'Remedios recomendados';

  @override
  String get kmTopicVerdict => 'Si debemos proceder con el matrimonio';

  @override
  String get pkSubtitle => 'Informe Védico de Vida Pasada y Karma con IA';

  @override
  String get pkTitle => 'Vida Pasada y Karma';

  @override
  String get pkSnapshotHeader => 'Resumen de Vida Pasada';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return 'Tu carta muestra una firma de vida pasada \'$theme\', actualmente $relation en esta vida. Camino recomendado: $strategy.';
  }

  @override
  String get pkGaugeSignature => 'Fuerza de la Firma';

  @override
  String get pkGaugeMasteryPreserved => 'Dominio Preservado';

  @override
  String get pkGaugeClearingProgress => 'Limpieza Kármica';

  @override
  String get pkGaugeMaturity => 'Madurez de Vida Pasada';

  @override
  String get pkGaugeMemoryAccess => 'Acceso a la Memoria';

  @override
  String get pkChipGoodProgress => 'Buen progreso en limpieza kármica';

  @override
  String get pkChipLowDebt => 'Baja deuda kármica';

  @override
  String get pkChipMatureSoul => 'Firma de alma madura';

  @override
  String get pkChipGiftedPast => 'La carta lleva un don de vida pasada';

  @override
  String get pkChipAccomplished => 'Vida pasada realizada';

  @override
  String get pkChipMasteryPreserved => 'Fuerte dominio llevado hacia adelante';

  @override
  String get pkKetuTitle => 'Ketu — Tu Dominio Pasado';

  @override
  String get pkKetuSubtitle => 'Habilidades que tu alma ya dominó';

  @override
  String get pkMasteryStrength => 'Fuerza del Dominio';

  @override
  String get pkSkillsCarried => 'Habilidades Llevadas hacia Adelante';

  @override
  String get pkInstincts => 'Capacidades Instintivas';

  @override
  String get pkKetuDignity => 'Dignidad de Ketu';

  @override
  String get pkRahuTitle => 'Rahu — El Límite de Crecimiento de Tu Alma';

  @override
  String get pkRahuSubtitle => 'Lo que tu alma vino a terminar';

  @override
  String get pkUnmetDesires => 'Deseos No Cumplidos';

  @override
  String get pkProfileTitle => 'Tu Perfil de Vida Pasada';

  @override
  String get pkProfession => 'Profesión Probable';

  @override
  String get pkSocialStanding => 'Posición Social';

  @override
  String get pkRegion => 'Región Probable';

  @override
  String get pkCulturalArchetype => 'Arquetipo Cultural';

  @override
  String get pkAccomplishment => 'Nivel de Logro';

  @override
  String get pkAuthority => 'Nivel de Autoridad';

  @override
  String get pkFamilyRole => 'Rol familiar';

  @override
  String get pkSecondaryProfession => 'Profesión secundaria';

  @override
  String get pkClimateAffinity => 'Afinidad climática';

  @override
  String get pkForeignResidence => 'Karma de residencia en el extranjero';

  @override
  String get pkRelationshipsTitle =>
      'Relaciones Pasadas Llevadas hacia Adelante';

  @override
  String get pkSpouseConnection => 'Reconexión con el Cónyuge';

  @override
  String get pkChildrenConnection => 'Reconexión con los Hijos';

  @override
  String get pkCarriedRelationTypes => 'Patrones de Relación';

  @override
  String get pkPartnerArchetype => 'Arquetipo de Pareja de Vida Pasada';

  @override
  String get pkDarakaraka => 'Karaka del cónyuge';

  @override
  String get pkParentsKarma => 'Patrón kármico de los padres';

  @override
  String get pkSiblingKarma => 'Patrón kármico de los hermanos';

  @override
  String get pkSpiritualTitle => 'Tu Vida Espiritual Entonces';

  @override
  String get pkSpiritualLevel => 'Nivel Espiritual';

  @override
  String get pkPracticeSignature => 'Estilo de Práctica';

  @override
  String get pkMeditativeCapacity => 'Capacidad Meditativa';

  @override
  String get pkDevotionalPractice => 'Práctica Devocional';

  @override
  String get pkYogicAttainment => 'Logro Yóguico';

  @override
  String get pkMokshaProximity => 'Proximidad al Moksha';

  @override
  String get pkKarmicDebtsTitle => 'Deudas Kármicas y Riqueza Entonces';

  @override
  String get pkTotalKarmicDebt => 'Deuda Kármica Total';

  @override
  String get pkPrimaryDebtType => 'Tipo de Deuda Principal';

  @override
  String get pkRelationshipDebt => 'Deuda de Relación';

  @override
  String get pkFinancialDebt => 'Deuda Financiera';

  @override
  String get pkServiceDebt => 'Deuda de Servicio';

  @override
  String get pkDharmicDebt => 'Deuda Dhármica';

  @override
  String get pkPitruKarma => 'Karma de Pitru';

  @override
  String get pkMatruKarma => 'Karma de Matru';

  @override
  String get pkWealthLevel => 'Nivel de Riqueza Entonces';

  @override
  String get pkWealthKarmaCarried => 'Karma de Riqueza Llevado';

  @override
  String get pkResourcePattern => 'Gestión de recursos';

  @override
  String get pkGainSource => 'Fuente de ganancia';

  @override
  String get pkEchoesTitle => 'Ecos En Esta Vida';

  @override
  String get pkOnRelationships => 'En las Relaciones';

  @override
  String get pkOnCareer => 'En la Carrera';

  @override
  String get pkOnHealth => 'En la Salud';

  @override
  String get pkOnSpirituality => 'En la Espiritualidad';

  @override
  String get pkDominantArea => 'Mayor Continuidad';

  @override
  String get pkAttractions => 'Atracciones Naturales';

  @override
  String get pkAversions => 'Aversiones Naturales';

  @override
  String get pkUnexplainedFears => 'Miedos Inexplicables';

  @override
  String get pkMagneticPulls => 'Atracciones Magnéticas';

  @override
  String get pkResolutionTitle => 'Resolución y Culminación Kármica';

  @override
  String get pkPrimaryPathway => 'Camino Principal';

  @override
  String get pkSecondaryPathway => 'Camino Secundario';

  @override
  String get pkClearingProgress => 'Progreso de Limpieza';

  @override
  String get pkRemainingWork => 'Trabajo Restante';

  @override
  String get pkSettlementTimeline => 'Cronograma de Resolución';

  @override
  String get pkAccelerationPractices => 'Prácticas Que Aceleran la Resolución';

  @override
  String get pkPriorityAreas => 'Áreas Prioritarias';

  @override
  String get pkVerificationTitle => 'Verificado en las Cartas (D60)';

  @override
  String get pkD60Label => 'Era de Vida Pasada D60';

  @override
  String get pkD60Ketu => 'Posición de Ketu en D60';

  @override
  String get pkD60Standing => 'Posición general';

  @override
  String get pkMemoryTitle => 'Memoria e Intuición';

  @override
  String get pkMemoryAccess => 'Acceso a la Memoria';

  @override
  String get pkRegressionFit => 'Afinidad con la Terapia de Regresión';

  @override
  String get pkDreamVisits => 'Visitas en Sueños';

  @override
  String get pkDejaVuFrequency => 'Frecuencia de Déjà Vu';

  @override
  String get pkSpontaneousRemembrance => 'Recuerdo espontáneo';

  @override
  String get pkRemembrancePractices => 'Prácticas de Recuerdo';

  @override
  String get pkTimelineTitle => 'Cronología de Activación';

  @override
  String get pkGiftsActivation => 'Activación de Dones de Vida Pasada';

  @override
  String get pkSurfaceWindow => 'Ventana de Emersión';

  @override
  String get pkRisksTitle => 'Riesgos y Patrones Crónicos';

  @override
  String get pkTraumaResidue => 'Residuo de Trauma';

  @override
  String get pkSpiritualBypass => 'Riesgo de Bypass Espiritual';

  @override
  String get pkMajorRisks => 'Riesgos Principales';

  @override
  String get pkChronicImprints => 'Improntas Crónicas';

  @override
  String get pkKarmicLoops => 'Bucles Kármicos';

  @override
  String get pkImprovementTitle => 'Plan de Mejora';

  @override
  String get pkRoadmapTitle => 'Tu Hoja de Ruta de Vida Pasada';

  @override
  String get pkMaturity => 'Madurez de Vida Pasada';

  @override
  String get pkLayerD1 => 'Carta Natal (D1)';

  @override
  String get pkLayerD9 => 'Navamsa (D9)';

  @override
  String get pkLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get pkLayerKetuDepth => 'Profundidad de Ketu';

  @override
  String get pkLayerAtmakaraka => 'Planeta del Alma (Atmakaraka)';

  @override
  String get pkTopicMastery => 'Mi dominio de vida pasada';

  @override
  String get pkTopicUnfinished => 'Mi karma inconcluso';

  @override
  String get pkTopicRelationships => 'Mis relaciones de vida pasada';

  @override
  String get pkTopicDebts => 'Mis deudas kármicas';

  @override
  String get pkTopicResolution => 'Cómo resolver mi karma';

  @override
  String get pkTopicMemory => 'Acceso a la memoria de vida pasada';

  @override
  String get pkTopicTiming => 'Mejores ventanas de tiempo';

  @override
  String get pkTopicProfile => 'Quién fui en mi vida pasada';

  @override
  String get chSubtitle => 'Informe Védico de Análisis de Carácter con IA';

  @override
  String get chTitle => 'Análisis de Carácter';

  @override
  String get chSnapshotHeader => 'Resumen de Carácter';

  @override
  String get chGaugeIntegrity => 'Integridad';

  @override
  String get chGaugeResilience => 'Resiliencia';

  @override
  String get chGaugeSelfAwareness => 'Autoconciencia';

  @override
  String get chGaugeStability => 'Estabilidad Emocional';

  @override
  String get chGaugeMoralFabric => 'Tejido Moral';

  @override
  String get chChipRajaYoga => 'Raja Yoga presente';

  @override
  String get chChipHighIntegrity => 'Alta integridad';

  @override
  String get chChipResilient => 'Naturaleza resiliente';

  @override
  String get chChipDharmic => 'Fuerte orientación al dharma';

  @override
  String get chChipEmpathetic => 'Naturalmente empático';

  @override
  String get chChipLoyal => 'Profundamente leal';

  @override
  String get chChipGiftedCharacter => 'La carta lleva un don de carácter';

  @override
  String get chSoulTitle => 'Tu Firma del Alma';

  @override
  String get chSoulIntegration => 'Integración Alma-Carácter';

  @override
  String get chAmatyakarakaTheme => 'Voz de Carácter de Apoyo';

  @override
  String get chAtmakarakaDignity => 'Dignidad del planeta del alma';

  @override
  String get chAtmakarakaHouse => 'Ubicación en la casa';

  @override
  String get chSurfaceTitle => 'Personalidad Superficial y Constitución';

  @override
  String get chLagnaSign => 'Signo Ascendente';

  @override
  String get chConstitution => 'Constitución';

  @override
  String get chSurfaceSignature => 'Cómo te presentas';

  @override
  String get chPhysicalConstitution => 'Constitución Física';

  @override
  String get chLagnaLord => 'Señor del Ascendente';

  @override
  String get chLagnaOccupants => 'Planetas en el Ascendente';

  @override
  String get chMindEmotionsTitle => 'Mente, Emociones y Ego';

  @override
  String get chEmotionalNature => 'Tu Naturaleza Emocional';

  @override
  String get chMentalStability => 'Estabilidad Mental';

  @override
  String get chSelfConfidence => 'Autoconfianza Saludable';

  @override
  String get chEgoNature => 'Tu Ego y Autoconcepto';

  @override
  String get chAuthorityRelationship => 'Relación con la Autoridad';

  @override
  String get chPrideTendency => 'Tendencia al Orgullo';

  @override
  String get chMoodPatterns => 'Patrones de Estado de Ánimo';

  @override
  String get chKemadrumaPresent =>
      'Kemadruma Yoga presente — un autocuidado emocional extra es beneficioso.';

  @override
  String get chFatherImprint => 'Calidad de la impronta paterna';

  @override
  String get chCommunicationTitle => 'Estilo de Comunicación e Intelecto';

  @override
  String get chIntellectStyle => 'Estilo Intelectual';

  @override
  String get chCommStyle => 'Estilo de Comunicación';

  @override
  String get chDecisionStyle => 'Estilo de Toma de Decisiones';

  @override
  String get chDiscrimination => 'Capacidad de Discernimiento';

  @override
  String get chPersonaTitle => 'Persona Pública vs Yo Verdadero';

  @override
  String get chAuthenticityGap => 'Brecha de Autenticidad';

  @override
  String get chGunaTitle => 'Perfil de Guna y Dosha';

  @override
  String get chGunaSubtitle =>
      'Tu naturaleza interior y constitución, al estilo védico clásico';

  @override
  String get chSattva => 'Sattva';

  @override
  String get chRajas => 'Rajas';

  @override
  String get chTamas => 'Tamas';

  @override
  String get chDominantGuna => 'Guna Dominante';

  @override
  String get chPitta => 'Pitta';

  @override
  String get chKapha => 'Kapha';

  @override
  String get chVata => 'Vata';

  @override
  String get chDominantDosha => 'Dosha Dominante';

  @override
  String get chRahuRestlessness => 'Inquietud de Rahu';

  @override
  String get chKetuDetachment => 'Desapego de Ketu';

  @override
  String get chYogasTitle => 'Yogas de Carácter';

  @override
  String get chRajaYogaStrength => 'Fuerza del Raja Yoga';

  @override
  String get chGiftYogas => 'Yogas de Don';

  @override
  String get chTestYogas => 'Yogas de Prueba';

  @override
  String get chStrengthsTitle => 'Fortalezas y Talentos';

  @override
  String get chSignatureVirtues => 'Virtudes Distintivas';

  @override
  String get chNaturalTalents => 'Talentos Naturales';

  @override
  String get chSoftSkills => 'Habilidades Blandas';

  @override
  String get chHiddenStrengths => 'Fortalezas Ocultas por Desarrollar';

  @override
  String get chShadowTitle => 'Sombra y Áreas de Crecimiento';

  @override
  String get chShadowSubtitle =>
      'Conciencia suave de patrones que vale la pena trabajar';

  @override
  String get chShadowPatterns => 'Patrones de Sombra';

  @override
  String get chBlindSpots => 'Puntos Ciegos';

  @override
  String get chEmotionalWounds => 'Heridas Emocionales';

  @override
  String get chShadowWorkPriorities => 'Prioridades de Trabajo de Sombra';

  @override
  String get chMoralTests => 'Pruebas Morales';

  @override
  String get chRelationshipsTitle => 'Relaciones y Estilo Social';

  @override
  String get chWarmth => 'Calidez Interpersonal';

  @override
  String get chEmpathy => 'Capacidad de Empatía';

  @override
  String get chLoyalty => 'Capacidad de Lealtad';

  @override
  String get chBoundaries => 'Establecimiento de Límites';

  @override
  String get chSocialConfidence => 'Confianza Social';

  @override
  String get chTrustGiving => 'Nivel Base de Confianza Otorgada';

  @override
  String get chConflictStyle => 'Estilo de conflicto';

  @override
  String get chEthicsTitle => 'Ética y Brújula Moral';

  @override
  String get chDharmaOrientation => 'Orientación al Dharma';

  @override
  String get chTruthfulness => 'Veracidad';

  @override
  String get chCompassion => 'Compasión';

  @override
  String get chGenerosity => 'Generosidad';

  @override
  String get chEthicalConsistency => 'Consistencia Ética';

  @override
  String get chIntegrityPressure => 'Integridad Bajo Presión';

  @override
  String get chJusticeFairness => 'Justicia e Imparcialidad';

  @override
  String get chMoralTrajectory => 'Desarrollo moral';

  @override
  String get chEiTitle => 'Inteligencia Emocional';

  @override
  String get chEiSelfAwareness => 'Autoconciencia';

  @override
  String get chEiSelfRegulation => 'Autorregulación';

  @override
  String get chEiEmpathy => 'Empatía';

  @override
  String get chEiSocialSkills => 'Habilidades Sociales';

  @override
  String get chMotivation => 'Motivación Interna';

  @override
  String get chVulnerabilityComfort => 'Comodidad con la Vulnerabilidad';

  @override
  String get chEmotionalExpression => 'Comodidad de expresión emocional';

  @override
  String get chEmotionalReceptivity => 'Receptividad emocional';

  @override
  String get chVerificationTitle => 'Verificado en las Cartas (D9/D12/D30/D60)';

  @override
  String get chD9Label => 'D9 Dharma-Carácter';

  @override
  String get chD12Label => 'D12 Herencia Ancestral';

  @override
  String get chD30Label => 'D30 Perfil de Sombra';

  @override
  String get chD60Label => 'D60 Carácter de Vida Pasada';

  @override
  String get chD30Standing => 'Posición de la sombra';

  @override
  String get chMaternalInheritance => 'Herencia materna';

  @override
  String get chAncestralKarmaWeight => 'Peso del karma ancestral';

  @override
  String get chTimelineTitle => 'Cronología del Carácter';

  @override
  String get chFormationWindow => 'Ventana de Formación';

  @override
  String get chMaturationWindow => 'Ventana de Maduración';

  @override
  String get chLegacyWindow => 'Ventana de Legado';

  @override
  String get chPeakMaturationAge => 'Edad de máxima maduración';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return 'Edad $ageRange';
  }

  @override
  String get chImprovementTitle => 'Plan de Mejora';

  @override
  String get chRoadmapTitle => 'Tu Hoja de Ruta de Carácter';

  @override
  String get chAuthenticExpression => 'Autoexpresión Auténtica';

  @override
  String get chRealizationPotential => 'Potencial de Realización del Carácter';

  @override
  String get chLayerAtmakaraka => 'Planeta del Alma (Atmakaraka)';

  @override
  String get chLayerD1 => 'Carta Natal (D1)';

  @override
  String get chLayerD9 => 'Navamsa (D9)';

  @override
  String get chLayerD30 => 'Trimshamsa (D30)';

  @override
  String get chLayerLagnaMoon => 'Ascendente y Luna';

  @override
  String get chLayerArudha => 'Arudha Lagna';

  @override
  String get chTopicStrengths => 'Mis fortalezas de carácter';

  @override
  String get chTopicShadow => 'Mis patrones de sombra';

  @override
  String get chTopicSoul => 'Mi firma del alma';

  @override
  String get chTopicRelationships => 'Mi estilo de relación';

  @override
  String get chTopicEthics => 'Mi ética y valores';

  @override
  String get chTopicGuna => 'Mi perfil de guna y dosha';

  @override
  String get chTopicGrowth => 'Cómo hacer crecer mi carácter';

  @override
  String get chTopicTiming => 'Mejor momento para trabajar el carácter';

  @override
  String get lpSubtitle => 'Informe Védico de Camino de Vida y Fortuna con IA';

  @override
  String get lpTitle => 'Camino de Vida y Fortuna';

  @override
  String get lpSnapshotHeader => 'Resumen del Camino de Vida';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return 'Eres un $archetype con un propósito principal en $domain. Nuestro análisis muestra un potencial general de realización de vida del $probability%.';
  }

  @override
  String get lpGaugeDharma => 'Claridad del Dharma';

  @override
  String get lpGaugeFortune => 'Base de Fortuna';

  @override
  String get lpGaugeCoherence => 'Coherencia del Camino';

  @override
  String get lpGaugeFulfillment => 'Realización';

  @override
  String get lpGaugeMomentum => 'Impulso Kármico';

  @override
  String get lpChipRareGift => 'Don del destino poco común';

  @override
  String get lpChipFreeWillStrong => 'Fuerte libre albedrío';

  @override
  String get lpChipGraceSupported => 'Respaldado por la gracia';

  @override
  String get lpChipLightKarma => 'Carga kármica ligera';

  @override
  String get lpChipRecognitionPotential => 'Potencial de reconocimiento';

  @override
  String get lpChipSpiritualPath => 'Fuerte inclinación espiritual';

  @override
  String get lpChipBlessed => 'La carta lleva bendiciones';

  @override
  String get lpSoulPathTitle => 'Tu Camino del Alma';

  @override
  String get lpSoulPlanet => 'Planeta del Alma';

  @override
  String get lpCareerPlanet => 'Planeta del Propósito';

  @override
  String get lpSoulClarity => 'Claridad del Propósito';

  @override
  String get lpLifeChapter => 'Capítulo Actual de Vida';

  @override
  String get lpPrimaryDomain => 'Dominio de Propósito Principal';

  @override
  String get lpKarakaTitle => 'Tus Planetas del Dharma';

  @override
  String get lpKarakaSubtitle =>
      'Qué tan fuertemente apoya cada planeta tu propósito de vida';

  @override
  String get lpVerificationTitle => 'Verificado en las Cartas (D9 / D60)';

  @override
  String get lpD9Label => 'Alineación del Alma D9';

  @override
  String lpD9Explain(Object stage) {
    return 'Tu etapa de evolución del alma es \'$stage\' en la carta Navamsa.';
  }

  @override
  String get lpD9JupiterDignity => 'Dignidad de Júpiter';

  @override
  String get lpD9DharmaMultiplier => 'Multiplicador de dharma';

  @override
  String get lpD60Label => 'Firma de Vida Pasada D60';

  @override
  String get lpKarmaType => 'Tipo de karma de vida pasada';

  @override
  String get lpKetuMastery => 'Dominio de vida pasada de Ketu';

  @override
  String get lpRahuGrowthDir => 'Dirección de crecimiento de Rahu';

  @override
  String get lpYogasTitle => 'Yogas de Fortuna y Bloqueos de Suerte';

  @override
  String get lpFortuneBoost => 'Impulso de Fortuna';

  @override
  String get lpLuckDrain => 'Drenaje de Suerte';

  @override
  String get lpFortuneBoosters => 'Potenciadores de Fortuna';

  @override
  String get lpLuckBlocks => 'Bloqueos de Suerte';

  @override
  String get lpPurposeTitle => 'Dominios de Propósito y Fama';

  @override
  String get lpDomainLeadership => 'Liderazgo';

  @override
  String get lpDomainWisdom => 'Sabiduría y Enseñanza';

  @override
  String get lpDomainService => 'Servicio';

  @override
  String get lpDomainHealing => 'Sanación';

  @override
  String get lpDomainCreative => 'Expresión Creativa';

  @override
  String get lpPrimaryDomainBadge => 'Principal';

  @override
  String get lpFameRecognition => 'Fama y Reconocimiento';

  @override
  String get lpSocialInfluence => 'Influencia Social';

  @override
  String get lpRecognitionDomain => 'Campo de Reconocimiento';

  @override
  String get lpPublicImage => 'Imagen Pública';

  @override
  String get lpHistoricalImpact => 'Potencial de impacto histórico';

  @override
  String get lpTimelineTitle => 'Cronología de Fortuna y Vida';

  @override
  String get lpCurrentPhase => 'Fase de Fortuna Actual';

  @override
  String get lpJupiterReturn => 'Retorno de Júpiter';

  @override
  String get lpSaturnReturn => 'Retorno de Saturno';

  @override
  String get lpSadeSati => 'Sade Sati';

  @override
  String get lpGoldenWindow => 'Ventana Dorada';

  @override
  String get lpTransformationWindow => 'Ventana de Transformación';

  @override
  String get lpPeakYears => 'Años de Máxima Fortuna';

  @override
  String get lpChallengingYears => 'Años Desafiantes';

  @override
  String get lpMilestonesTitle => 'Hitos Importantes y Puntos de Inflexión';

  @override
  String get lpFirstTurningPoint => 'Primer Gran Punto de Inflexión';

  @override
  String get lpMidlifeTransform => 'Transformación de Mediana Edad';

  @override
  String get lpLateLifeFulfillment => 'Realización en la Vejez';

  @override
  String lpDharmicMilestone(Object age) {
    return 'Hito Dhármico (Edad $age)';
  }

  @override
  String lpAgeLabel(Object age) {
    return 'Edad $age';
  }

  @override
  String get lpDestinyTitle => 'Destino vs Libre Albedrío';

  @override
  String get lpDestinyStat => 'Peso del Destino';

  @override
  String get lpFreeWillStat => 'Influencia del Libre Albedrío';

  @override
  String get lpFateStrength => 'Fuerza de la Firma del Destino';

  @override
  String get lpSelfCreation => 'Capacidad de Autocreación';

  @override
  String get lpEffortGrace => 'Esfuerzo vs gracia';

  @override
  String get lpKarmicTitle => 'Lecciones Kármicas';

  @override
  String get lpRahuGrowthLabel => 'Rahu — Desafío de Crecimiento';

  @override
  String get lpKetuSurrenderLabel => 'Ketu — Tema de Entrega';

  @override
  String get lpSaturnLessonLabel => 'Saturno — Lección de Disciplina';

  @override
  String get lpTestDifficulty => 'Dificultad de las Pruebas de Vida';

  @override
  String get lpLessonsInProgress => 'Lecciones en Progreso';

  @override
  String get lpSoulContract => 'Áreas del Contrato del Alma';

  @override
  String get lpSoulExperience => 'Lo Que Tu Alma Vino a Experimentar';

  @override
  String get lpSoulMastery => 'Lo Que Tu Alma Vino a Dominar';

  @override
  String get lpSpiritualTitle => 'Camino Espiritual';

  @override
  String get lpSpiritualInclination => 'Inclinación Espiritual';

  @override
  String get lpMeditationReceptivity => 'Receptividad a la Meditación';

  @override
  String get lpTeacherKarma => 'Karma de Maestro/Gurú';

  @override
  String get lpPilgrimageBenefit => 'Beneficio de Peregrinación';

  @override
  String get lpSelfRealization => 'Potencial de Autorrealización';

  @override
  String get lpDivineConnection => 'Conexión Divina';

  @override
  String get lpTraditionAffinity => 'Afinidad con la tradición';

  @override
  String get lpIntuitionStrength => 'Fuerza de la intuición';

  @override
  String get lpMantraEfficacy => 'Eficacia de oración/mantra';

  @override
  String get lpInnerGuidance => 'Confianza en la guía interior';

  @override
  String get lpPropheticDreams => 'Sensibilidad a sueños proféticos';

  @override
  String get lpDifficultyTitle => 'Dificultad y Desafíos de Vida';

  @override
  String get lpEarlyLife => 'Vida Temprana';

  @override
  String get lpMidlife => 'Mediana Edad';

  @override
  String get lpLateLife => 'Vejez';

  @override
  String get lpStruggleToSuccess => 'Karma de Lucha hacia el Éxito';

  @override
  String get lpUnlivedLifeRisk => 'Riesgo de Vida No Vivida';

  @override
  String get lpChallenges => 'Desafíos de Vida';

  @override
  String get lpFortuneDrains => 'Drenajes Crónicos de Fortuna';

  @override
  String get lpRegretAreas => 'Áreas Vulnerables al Arrepentimiento';

  @override
  String get lpRedFlags => 'Señales de Alerta de Dirección';

  @override
  String get lpBlessingsTitle => 'Bendiciones y Tema Central de Vida';

  @override
  String get lpKarmicRoot => 'Raíz kármica';

  @override
  String get lpBlessingsList => 'Tus Bendiciones';

  @override
  String get lpFulfillmentPriorities => 'Prioridades de Realización';

  @override
  String get lpImprovementTitle => 'Plan de Mejora';

  @override
  String get lpDharmaPriorities => 'Prioridades del Dharma';

  @override
  String get lpRoadmapTitle => 'Tu Hoja de Ruta del Destino';

  @override
  String get lpStrategy => 'Estrategia';

  @override
  String get lpFulfillmentPotential => 'Potencial de Realización';

  @override
  String get lpNext12Focus => 'Enfoque para los Próximos 12 Meses';

  @override
  String get lpLayerD1 => 'Carta Natal (D1)';

  @override
  String get lpLayerD9 => 'Navamsa (D9)';

  @override
  String get lpLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get lpLayerDasha => 'Timing de Dasha';

  @override
  String get lpLayerTransit => 'Tránsitos Actuales';

  @override
  String get lpTopicPurpose => 'Mi propósito de vida';

  @override
  String get lpTopicFortune => 'Mis yogas de fortuna';

  @override
  String get lpTopicKarma => 'Mis lecciones kármicas';

  @override
  String get lpTopicMilestones => 'Próximos hitos';

  @override
  String get lpTopicDestiny => 'Destino vs libre albedrío';

  @override
  String get lpTopicSpiritual => 'Mi camino espiritual';

  @override
  String get lpTopicChallenges => 'Mis desafíos de vida';

  @override
  String get lpTopicTiming => 'Mejores ventanas de tiempo';

  @override
  String get dbSubtitle => 'Informe Védico de Deuda y Recuperación con IA';

  @override
  String get dbTitle => 'Deuda y Recuperación';

  @override
  String get dbSnapshotHeader => 'Resumen de Recuperación de Deuda';

  @override
  String dbHeroSummary(
    Object phase,
    Object personality,
    Object probability,
    Object years,
  ) {
    return 'Actualmente estás en una fase \'$phase\' con un enfoque $personality hacia el dinero. Nuestro análisis muestra una probabilidad del $probability% de quedar libre de deudas en aproximadamente $years años.';
  }

  @override
  String get dbGaugeCapacity => 'Capacidad de Recuperación';

  @override
  String get dbGaugeProbability => 'Probabilidad de Recuperación';

  @override
  String get dbGaugeFreedomNow => 'Libertad de Deuda Ahora';

  @override
  String get dbGaugeDti => 'Salud de Ingresos';

  @override
  String get dbGaugeResilience => 'Resiliencia';

  @override
  String get dbChipCleanKarma => 'Karma de deuda limpio';

  @override
  String get dbChipStrongRecovery => 'Fuerte capacidad de recuperación';

  @override
  String get dbChipHealthyDti => 'Relación deuda-ingreso saludable';

  @override
  String get dbChipResilient => 'Alta resiliencia psicológica';

  @override
  String get dbChipCycleBreakable => 'El ciclo de deuda es superable';

  @override
  String get dbChipLowReindebt => 'Bajo riesgo de reendeudamiento';

  @override
  String get dbChipGoodNegotiator => 'Buenas probabilidades de negociación';

  @override
  String get dbProfileTitle => 'Tu Perfil de Deuda';

  @override
  String get dbPhaseLabel => 'Fase actual';

  @override
  String get dbPrimaryCategoryLabel => 'Categoría principal';

  @override
  String get dbKarakaLabel => 'Karaka de la Deuda';

  @override
  String get dbProtectorLabel => 'Protección contra Acreedores';

  @override
  String get dbSecondaryCategories => 'Categorías secundarias';

  @override
  String get dbUnsecuredRatio => 'Proporción de deuda no garantizada';

  @override
  String get dbKarakaTitle => 'Tus Planetas de la Deuda';

  @override
  String get dbKarakaSubtitle =>
      'Qué tan fuertemente apoya cada planeta tu recuperación de deuda';

  @override
  String get dbVerificationTitle => 'Verificado en las Cartas (D6)';

  @override
  String get dbD6Label => 'Carta D6 de Deudas y Enemigos';

  @override
  String get dbD6LordDignity => 'Fuerza del señor de la casa 6';

  @override
  String get dbD6Severity => 'Severidad del karma de deuda';

  @override
  String get dbD6Multiplier => 'Multiplicador de deuda D6';

  @override
  String get dbYogasTitle => 'Yogas de Deuda y Protecciones';

  @override
  String get dbPressureNow => 'Presión de Deuda Actual';

  @override
  String get dbRecoveryBoost => 'Impulso de Recuperación';

  @override
  String get dbClearingLabel => 'Yogas de Liquidación de Deuda';

  @override
  String get dbCreatingLabel => 'Yogas de Generación de Deuda';

  @override
  String get dbCategoriesTitle => 'Vigilancia de Categorías de Deuda';

  @override
  String get dbCategoriesSubtitle =>
      'Qué tipos de deuda necesitan más atención';

  @override
  String get dbTimelineTitle => 'Cronología para Estar Libre de Deudas';

  @override
  String get dbFreeWindowLabel => 'VENTANA LIBRE DE DEUDA';

  @override
  String get dbClearanceEstimate => 'Estimación de liquidación total';

  @override
  String get dbPeakYears => 'Años Pico de Deuda';

  @override
  String get dbClearanceYears => 'Años de Liquidación';

  @override
  String get dbBorrowTitle => 'Guía de Préstamo Inteligente';

  @override
  String get dbLoanSuitability => 'Idoneidad del Préstamo';

  @override
  String get dbBestLoanType => 'Mejor Tipo de Préstamo';

  @override
  String get dbLeverageCeiling => 'Límite de Apalancamiento';

  @override
  String get dbNegotiationSuccess => 'Éxito de Negociación';

  @override
  String get dbCreditorAggression => 'Riesgo de Presión de Acreedores';

  @override
  String get dbLegalEscalation => 'Riesgo de Escalada Legal';

  @override
  String get dbNegotiationApproach => 'Enfoque recomendado';

  @override
  String get dbAvoidLoanTypes => 'Tipos de Préstamo a Evitar';

  @override
  String get dbRiskTitle => 'Vigilancia de Riesgo y Vulnerabilidad';

  @override
  String get dbRiskDefault => 'Riesgo de Incumplimiento';

  @override
  String get dbRiskDefaultExp =>
      'La probabilidad de retrasarse en un pago programado lo suficiente como para provocar un estado de incumplimiento con un prestamista.';

  @override
  String get dbRiskDefaultFix =>
      'Automatiza los pagos mínimos y mantén un colchón de 1 mes para que un solo ciclo de ingresos perdido no genere un efecto en cadena.';

  @override
  String get dbRiskBankruptcy => 'Riesgo de Bancarrota';

  @override
  String get dbRiskBankruptcyExp =>
      'La probabilidad de que la carga de deuda crezca más allá de lo que los ingresos y activos pueden cubrir realmente.';

  @override
  String get dbRiskBankruptcyFix =>
      'Obtén una revisión profesional de deuda antes de tomar cualquier préstamo o línea de crédito nueva.';

  @override
  String get dbRiskAssetSeizure => 'Riesgo de Embargo de Bienes';

  @override
  String get dbRiskAssetSeizureExp =>
      'La probabilidad de que un incumplimiento de préstamo garantizado lleve a que un prestamista recupere la garantía o propiedad.';

  @override
  String get dbRiskAssetSeizureFix =>
      'Prioriza primero los pagos de préstamos garantizados, y refinancia con anticipación si parece probable una brecha de pago.';

  @override
  String get dbRiskChronic => 'Riesgo de Reendeudamiento Crónico';

  @override
  String get dbRiskChronicExp =>
      'La tendencia a volver a caer en deuda incluso después de liquidar la carga actual.';

  @override
  String get dbRiskChronicFix =>
      'Construye un fondo de emergencia dedicado antes de aumentar el gasto de estilo de vida después de la liquidación.';

  @override
  String get dbReindebtTrigger => 'Detonante de Reendeudamiento';

  @override
  String get dbCycleBreakFeasibility => 'Viabilidad de Romper el Ciclo';

  @override
  String get dbMajorRisks => 'Riesgos Principales';

  @override
  String get dbHiddenSignals => 'Señales Ocultas de Deuda';

  @override
  String get dbCrisisTitle => 'Preparación para Crisis';

  @override
  String get dbCrisisSubtitle =>
      'Cómo detectar problemas temprano y responder con calma';

  @override
  String get dbWarningSigns => 'Señales de Alerta Temprana';

  @override
  String get dbMitigationActions => 'Qué Hacer al Respecto';

  @override
  String get dbFamilyTitle => 'Deuda Familiar y Ancestral';

  @override
  String get dbInheritedDebtProb => 'Probabilidad de Deuda Heredada';

  @override
  String get dbFamilyDrag => 'Lastre de Deuda Familiar';

  @override
  String get dbInheritedSource => 'Fuente probable';

  @override
  String get dbCoreBlockerLabel => 'BLOQUEO PRINCIPAL';

  @override
  String get dbPsychologyTitle => 'Tu Psicología del Dinero';

  @override
  String get dbResilience => 'Resiliencia';

  @override
  String get dbDiscipline => 'Disciplina Bajo Presión';

  @override
  String get dbSocialSupport => 'Apoyo Social';

  @override
  String get dbDepressionRisk => 'Vulnerabilidad al Estrés Financiero';

  @override
  String get dbStressTolerance => 'Tolerancia al estrés';

  @override
  String get dbRootCause => 'Causa Raíz Conductual';

  @override
  String get dbImprovementTitle => 'Plan de Mejora';

  @override
  String get dbRoadmapTitle => 'Tu Hoja de Ruta hacia la Libertad de Deuda';

  @override
  String get dbRecoveryProbability => 'Probabilidad de Recuperación';

  @override
  String get dbClearanceTimeline => 'Cronología de Liquidación';

  @override
  String get dbYears => 'años';

  @override
  String get dbDtiHealth => 'Salud de la Relación Deuda-Ingreso';

  @override
  String get dbDtiCategory => 'Categoría de DTI';

  @override
  String get dbBreakEvenMonths => 'Meses para el punto de equilibrio';

  @override
  String get dbIncomeAcceleration => 'Crecimiento de ingresos necesario';

  @override
  String get dbLayerD1 => 'Carta Natal (D1)';

  @override
  String get dbLayerD6 => 'Deudas y Enemigos (D6)';

  @override
  String get dbLayerD9 => 'Navamsa (D9)';

  @override
  String get dbLayerDasha => 'Timing de Dasha';

  @override
  String get dbLayerTransit => 'Tránsitos Actuales';

  @override
  String get dbTopicRecovery => 'Mi cronología de recuperación';

  @override
  String get dbTopicNegotiate => 'Negociar con acreedores';

  @override
  String get dbTopicBorrowing => 'Es seguro pedir prestado ahora';

  @override
  String get dbTopicCrisis => 'Prepararse para una crisis';

  @override
  String get dbTopicAncestral => 'Karma de deuda ancestral';

  @override
  String get dbTopicTimeline => 'Mejores años para liquidar la deuda';

  @override
  String get dbTopicPsychology => 'Mi psicología del dinero';

  @override
  String get dbTopicCategories => 'Qué deudas priorizar';

  @override
  String get mnSubtitle => 'Informe Védico de Bienestar con IA';

  @override
  String get mnTitle => 'Mente y Estrés';

  @override
  String get mnSnapshotHeader => 'Resumen de Bienestar';

  @override
  String get mnResilience => 'Resiliencia';

  @override
  String get mnStability => 'Estabilidad';

  @override
  String get mnEmotionalBalance => 'Equilibrio Emocional';

  @override
  String get mnInnerCalm => 'Calma Interior';

  @override
  String get mnSelfAwareness => 'Autoconciencia';

  @override
  String get mnStatusThriving => 'Floreciendo';

  @override
  String get mnStatusSteady => 'Firme y Estable';

  @override
  String get mnStatusBuildingStrength => 'Construyendo Fortaleza';

  @override
  String get mnStatusNeedsGentleCare => 'Necesita Cuidado Suave';

  @override
  String get mnStatusReachOut => 'Es Hora de Buscar Apoyo';

  @override
  String get mnChipStable => 'Emocionalmente Estable';

  @override
  String get mnChipSupported => 'Bien Apoyado';

  @override
  String get mnChipSelfAware => 'Altamente Autoconsciente';

  @override
  String get mnChipResilient => 'Se Recupera Bien';

  @override
  String get mnChipSecureAttachment => 'Apego Seguro';

  @override
  String get mnChipHealingReady => 'Listo para Sanar';

  @override
  String get mnChipMindBodyBalance => 'Equilibrio Mente-Cuerpo';

  @override
  String get mnSupportBannerTitle => 'Una Nota Amable';

  @override
  String get mnSupportBannerBody =>
      'Tu carta sugiere que este podría ser un buen momento para apoyarte en algo extra — un amigo de confianza, un familiar o un profesional. Buscar ayuda es una señal de fortaleza, no de debilidad.';

  @override
  String get mnProfileTitle => 'Tu Perfil Emocional';

  @override
  String get mnStressDriver => 'Motor del Estrés';

  @override
  String get mnStabilityAnchor => 'Ancla de Estabilidad';

  @override
  String get mnSoulLevelKarma => 'Patrón a Nivel del Alma';

  @override
  String get mnSubtleSignature => 'Firma Emocional Sutil';

  @override
  String get mnKarakaTitle => 'Tu Mente y los Planetas';

  @override
  String get mnKarakaSubtitle => 'Qué planetas dan forma a tu mundo interior';

  @override
  String get mnYogasTitle => 'Fortalezas y Áreas de Crecimiento';

  @override
  String get mnCurrentPhase => 'Fase Actual';

  @override
  String get mnCurrentStressLevel => 'Nivel de Estrés Actual';

  @override
  String get mnRecentStrain => 'Tensión Emocional Reciente';

  @override
  String get mnStrengths => 'Fortalezas';

  @override
  String get mnGrowthAreas => 'Áreas de Crecimiento';

  @override
  String get mnSadeSatiStatus => 'Estado de Sade Sati';

  @override
  String get mnVerificationTitle => 'Verificado en las Cartas';

  @override
  String get mnD9Confirmation => 'Confirmación D9';

  @override
  String get mnD30Confirmation => 'Confirmación D30';

  @override
  String get mnMoodPatternsTitle => 'Patrones de Ánimo y Ansiedad';

  @override
  String get mnMoodPatternsSubtitle => 'Conciencia suave, no un diagnóstico';

  @override
  String get mnAnxietyPatterns => 'Patrones de Ansiedad';

  @override
  String get mnMoodPatterns => 'Patrones de Ánimo Bajo';

  @override
  String get mnPrimaryPattern => 'Patrón Principal';

  @override
  String get mnRumination => 'Tendencia a Pensar en Exceso';

  @override
  String get mnHypervigilance => 'Hiperalerta';

  @override
  String get mnHopelessnessVuln => 'Sensibilidad al Ánimo Bajo';

  @override
  String get mnEnergyDepletion => 'Tendencia al Agotamiento de Energía';

  @override
  String get mnMotivationBaseline => 'Nivel Base de Motivación';

  @override
  String get mnRegulationTitle => 'Regulación Emocional y Afrontamiento';

  @override
  String get mnEmotionalRegulation => 'Regulación Emocional';

  @override
  String get mnSelfSoothing => 'Capacidad de Autocalma';

  @override
  String get mnExpressionStyle => 'Estilo de Expresión';

  @override
  String get mnRecoveryTime => 'Tiempo de Recuperación';

  @override
  String get mnTriggerIntensity => 'Intensidad de Detonantes';

  @override
  String get mnHealthyCoping => 'Hábitos Saludables de Afrontamiento';

  @override
  String get mnWatchFor => 'Presta Atención A';

  @override
  String get mnSleepTitle => 'Sueño y Descanso';

  @override
  String get mnSleepQuality => 'Calidad del Sueño';

  @override
  String get mnSleepAsRegulator => 'El Sueño como Regulador Emocional';

  @override
  String get mnInsomniaTendency => 'Tendencia a Noches Inquietas';

  @override
  String get mnNightmareTendency => 'Tendencia a Sueños Vívidos';

  @override
  String get mnSleepHygienePriority => 'Prioridad de Higiene del Sueño';

  @override
  String get mnBurnoutTitle => 'Agotamiento y Energía';

  @override
  String get mnBurnoutVulnerability => 'Sensibilidad al Agotamiento';

  @override
  String get mnBurnoutRecovery => 'Capacidad de Recuperación del Agotamiento';

  @override
  String get mnBurnoutStage => 'Etapa Actual de Agotamiento';

  @override
  String get mnSelfDrivingTendency => 'Tendencia a la Autoexigencia';

  @override
  String get mnBurnoutTriggers => 'Detonantes de Agotamiento';

  @override
  String get mnConnectionTitle => 'Conexión y Apoyo';

  @override
  String get mnSocialSupport => 'Calidad del Apoyo Social';

  @override
  String get mnLonelinessVuln => 'Sensibilidad a la Soledad';

  @override
  String get mnSolitudeNeed => 'Necesidad de Soledad';

  @override
  String get mnSocialComfort => 'Comodidad Social';

  @override
  String get mnTraumaSensitivity => 'Sensibilidad al Trauma';

  @override
  String get mnHealingReadiness => 'Disposición para Sanar';

  @override
  String get mnProcessingStyle => 'Estilo de Procesamiento';

  @override
  String get mnMindBodyIntegration => 'Integración Mente-Cuerpo';

  @override
  String get mnPtsdVuln => 'Sensibilidad a la Respuesta al Trauma';

  @override
  String get mnSelfAwarenessTitle => 'Autoconciencia y Crecimiento';

  @override
  String get mnSelfAwarenessScore => 'Autoconciencia';

  @override
  String get mnEmotionalVocabulary => 'Vocabulario Emocional';

  @override
  String get mnTherapyReadiness => 'Disposición para la Terapia';

  @override
  String get mnJournalingBenefit => 'Beneficio de Escribir un Diario';

  @override
  String get mnInnerDialogue => 'Calidad del Diálogo Interior';

  @override
  String get mnAwarenessOfPatterns => 'Conciencia de Patrones';

  @override
  String get mnEscapePatternVuln => 'Sensibilidad a Patrones de Evasión';

  @override
  String get mnEscapeChannels => 'Presta Atención A';

  @override
  String get mnHealthyAlternatives => 'Alternativas Saludables';

  @override
  String get mnTherapyFitTitle => 'Ajuste de Terapia y Apoyo';

  @override
  String get mnCrisisSupportRec => 'Recomendación de Apoyo';

  @override
  String get mnSupportNetwork => 'Activa Tu Red de Apoyo';

  @override
  String get mnSelfAdvocacy => 'Disposición para la Autodefensa';

  @override
  String get mnMedicationReceptivity => 'Receptividad a la Medicación';

  @override
  String get mnTimelineTitle => 'Cronología de Bienestar';

  @override
  String get mnPeakWellnessYears => 'Años de Máximo Bienestar';

  @override
  String get mnExtraCareYears => 'Años para Cuidado Personal Extra';

  @override
  String get mnTransformationWindows => 'Ventanas de Transformación Positiva';

  @override
  String get mnTherapyWindow => 'Ventana Recomendada para Terapia';

  @override
  String get mnPracticesTitle => 'Prácticas Diarias de Bienestar';

  @override
  String get mnMorningPractices => 'Prácticas Matutinas';

  @override
  String get mnEveningPractices => 'Prácticas Vespertinas';

  @override
  String get mnBreathwork => 'Trabajo de Respiración';

  @override
  String get mnMovement => 'Movimiento';

  @override
  String get mnNutrition => 'Nutrición';

  @override
  String get mnNatureExposure => 'Necesidad de Exposición a la Naturaleza';

  @override
  String get mnDigitalDetox => 'Necesidad de Desintoxicación Digital';

  @override
  String get mnImprovementTitle => 'Plan de Mejora';

  @override
  String get mnReliabilityTitle => 'Confiabilidad';

  @override
  String get mnLayerD1 => 'Carta Natal (D1)';

  @override
  String get mnLayerD9 => 'Carta del Alma (D9)';

  @override
  String get mnLayerD30 => 'Carta D30';

  @override
  String get mnLayerDasha => 'Timing de Dasha';

  @override
  String get mnLayerTransit => 'Tránsitos';

  @override
  String get mnTopicResilience => '¿Qué tan resiliente soy emocionalmente?';

  @override
  String get mnTopicCoping =>
      '¿Cuáles son mis mejores estrategias de afrontamiento?';

  @override
  String get mnTopicSleep => '¿Cómo puedo mejorar mi sueño?';

  @override
  String get mnTopicBurnout => '¿Estoy en riesgo de agotamiento?';

  @override
  String get mnTopicTherapy => '¿Qué estilo de terapia me conviene?';

  @override
  String get mnTopicPractices => '¿Qué prácticas diarias me ayudan más?';

  @override
  String get mnTopicTiming => '¿Cuáles son mis mejores años de bienestar?';

  @override
  String get mnTopicSupport => '¿Cómo construyo una red de apoyo sólida?';

  @override
  String get lgSubtitle => 'Informe Védico Legal con IA';

  @override
  String get lgTitle => 'Legal y Disputas';

  @override
  String get lgSnapshotHeader => 'Resumen Legal';

  @override
  String get lgResilience => 'Resiliencia Legal';

  @override
  String get lgResolutionCapacity => 'Capacidad de Resolución';

  @override
  String get lgVictoryPotential => 'Potencial de Victoria';

  @override
  String get lgLegalSafety => 'Seguridad Legal';

  @override
  String get lgNegotiationSkill => 'Habilidad de Negociación';

  @override
  String get lgStatusExcellent => 'Excelente';

  @override
  String get lgStatusStrong => 'Fuerte';

  @override
  String get lgStatusModerate => 'Moderado';

  @override
  String get lgStatusDeveloping => 'En Desarrollo';

  @override
  String get lgStatusChallenging => 'Desafiante';

  @override
  String get lgChipResolver => 'Resolutor Hábil';

  @override
  String get lgChipWinner => 'Casos Sólidos Ganadores';

  @override
  String get lgChipNegotiator => 'Negociador Natural';

  @override
  String get lgChipDocumented => 'Bien Documentado';

  @override
  String get lgChipLowRisk => 'Bajo Riesgo Legal';

  @override
  String get lgChipMoralAuthority => 'Autoridad Moral';

  @override
  String get lgChipLegalAptitude => 'Aptitud Legal';

  @override
  String get lgProfileTitle => 'Tu Perfil Legal y Karma';

  @override
  String get lgPrimaryDriver => 'Motor Principal';

  @override
  String get lgDharmaAnchor => 'Ancla del Dharma';

  @override
  String get lgAggressionMarker => 'Marcador de Agresión';

  @override
  String get lgDocumentationKaraka => 'Calidad de la Documentación';

  @override
  String get lgKarakaTitle => 'Tus Planetas Legales';

  @override
  String get lgKarakaSubtitle => 'Qué planetas dan forma a tu fortuna legal';

  @override
  String get lgYogasTitle => 'Yogas Legales y Protecciones';

  @override
  String get lgCurrentPhase => 'Fase Actual';

  @override
  String get lgProtections => 'Protecciones';

  @override
  String get lgDisputePressures => 'Presiones de Disputa';

  @override
  String get lgVerificationTitle => 'Verificado en las Cartas';

  @override
  String get lgD6Litigation => 'Carta D6 de Litigios';

  @override
  String get lgD9Dharma => 'Carta D9 del Dharma';

  @override
  String get lgMoralAuthority => 'Autoridad Moral';

  @override
  String get lgVictoryTitle => 'Análisis de Victoria';

  @override
  String get lgAsPlaintiff => 'Como Demandante';

  @override
  String get lgAsDefendant => 'Como Demandado';

  @override
  String get lgSettlementPreference => 'Preferencia de Acuerdo';

  @override
  String get lgDisputeCategoriesTitle => 'Vigilancia de Categorías de Disputa';

  @override
  String get lgLowRiskCategories => 'Categorías de Bajo Riesgo';

  @override
  String get lgConflictStyleTitle => 'Estilo de Conflicto y Enemigos';

  @override
  String get lgConfrontationComfort => 'Comodidad con la Confrontación';

  @override
  String get lgArgumentPersuasiveness => 'Persuasión Argumentativa';

  @override
  String get lgEmotionalRegulation => 'Regulación Emocional';

  @override
  String get lgGrudgeHolding => 'Tendencia a Guardar Rencor';

  @override
  String get lgEnemyAnalysisLabel => 'Análisis de Enemigos';

  @override
  String get lgVisibleEnemies => 'Enemigos Visibles';

  @override
  String get lgHiddenEnemies => 'Enemigos Ocultos';

  @override
  String get lgWorkplaceEnemies => 'Enemigos en el Trabajo';

  @override
  String get lgFamilyEnemies => 'Enemigos Familiares';

  @override
  String get lgLegalEnemies => 'Enemigos Legales';

  @override
  String get lgEnemyDefeatCapacity => 'Capacidad para Vencer Enemigos';

  @override
  String get lgCriminalFinancialTitle =>
      'Vigilancia de Riesgo Criminal y Financiero';

  @override
  String get lgCriminalRisk => 'Riesgo de Involucramiento Criminal';

  @override
  String get lgVictimOfCrime => 'Probabilidad de Ser Víctima de un Delito';

  @override
  String get lgFalseAccusation => 'Riesgo de Acusación Falsa';

  @override
  String get lgImprisonmentRisk => 'Riesgo de Encarcelamiento';

  @override
  String get lgTaxDisputeRisk => 'Riesgo de Disputa Fiscal';

  @override
  String get lgFinancialFraudRisk => 'Riesgo de Fraude Financiero';

  @override
  String get lgBusinessLitigationRisk => 'Riesgo de Litigio Comercial';

  @override
  String get lgBankruptcyRisk => 'Riesgo de Bancarrota';

  @override
  String get lgAuditVulnerability => 'Vulnerabilidad a Auditorías';

  @override
  String get lgProtectionPriority => 'Prioridad de Protección';

  @override
  String get lgContractsTitle => 'Contratos y Negociación';

  @override
  String get lgContractClarity => 'Claridad Contractual';

  @override
  String get lgDocumentationDiscipline => 'Disciplina de Documentación';

  @override
  String get lgFinePrintAwareness => 'Atención a la Letra Pequeña';

  @override
  String get lgSignatureCaution => 'Precaución al Firmar';

  @override
  String get lgMediationReceptivity => 'Receptividad a la Mediación';

  @override
  String get lgNegotiationSkillFull => 'Habilidad de Negociación';

  @override
  String get lgCompromiseWillingness => 'Disposición al Compromiso';

  @override
  String get lgFaceSavingNeeds => 'Necesidad de Guardar las Apariencias';

  @override
  String get lgMediatorHireRecommendation =>
      'Recomendación de Contratar Mediador';

  @override
  String get lgTypicalContractIssues => 'Problemas Contractuales Típicos';

  @override
  String get lgCareerFitTitle => 'Aptitud para Carrera Legal';

  @override
  String get lgProfessionAffinity => 'Afinidad Profesional';

  @override
  String get lgRoleFit => 'Mejor Rol';

  @override
  String get lgLawStudentSuccess => 'Éxito como Estudiante de Derecho';

  @override
  String get lgBarExamSuccess => 'Éxito en el Examen de Abogacía';

  @override
  String get lgTimelineTitle => 'Cronología Legal';

  @override
  String get lgNewMatterChance => 'Probabilidad de Nuevo Asunto (Próximos 12M)';

  @override
  String get lgOngoingCaseOutcome => 'Resultado del Caso en Curso';

  @override
  String get lgRecommendedAction => 'Acción Recomendada';

  @override
  String get lgPeakDisputeYears => 'Años Pico de Disputas';

  @override
  String get lgClarityYears => 'Años de Claridad Legal';

  @override
  String get lgAvoidancePeriods => 'Períodos Críticos a Evitar';

  @override
  String get lgFavorableWindows => 'Ventanas Favorables de Resolución';

  @override
  String get lgRisksTitle => 'Riesgos y Vulnerabilidades';

  @override
  String get lgChronicVulnerabilities => 'Vulnerabilidades Crónicas';

  @override
  String get lgAvoidDashaPeriods => 'Períodos de Dasha a Vigilar';

  @override
  String get lgPreventivePriorities => 'Prioridades Preventivas';

  @override
  String get lgRedFlags => 'Situaciones de Alerta';

  @override
  String get lgImprovementTitle => 'Plan de Mejora';

  @override
  String get lgReliabilityTitle => 'Confiabilidad';

  @override
  String get lgLayerD1 => 'Carta Natal (D1)';

  @override
  String get lgLayerD6 => 'Carta de Litigios (D6)';

  @override
  String get lgLayerD9 => 'Carta del Dharma (D9)';

  @override
  String get lgLayerDasha => 'Timing de Dasha';

  @override
  String get lgLayerTransit => 'Tránsitos';

  @override
  String get lgTopicWinChance => '¿Cuáles son mis probabilidades de ganar?';

  @override
  String get lgTopicStrategy => '¿Cuál es la mejor estrategia legal para mí?';

  @override
  String get lgTopicContract => '¿Qué riesgos contractuales debo vigilar?';

  @override
  String get lgTopicTiming =>
      '¿Cuál es el mejor momento para resolver disputas?';

  @override
  String get lgTopicSettlement => '¿Debo llegar a un acuerdo o pelear?';

  @override
  String get lgTopicEnemies => '¿Quiénes son mis enemigos ocultos?';

  @override
  String get lgTopicProtection => '¿Cómo protegerme legalmente?';

  @override
  String get lgTopicCareer => '¿Soy apto para una carrera legal?';

  @override
  String get prSubtitle => 'Informe Védico de Propiedades con IA';

  @override
  String get prTitle => 'Propiedades y Activos';

  @override
  String get prSnapshotHeader => 'Resumen de Propiedades';

  @override
  String get prAcquisitionCapacity => 'Capacidad de Adquisición';

  @override
  String get prHomeOwnership => 'Propiedad de Vivienda';

  @override
  String get prWealthPotential => 'Potencial de Riqueza';

  @override
  String get prRentalIncome => 'Ingreso por Alquiler';

  @override
  String get prLandOwnership => 'Propiedad de Tierras';

  @override
  String get prStatusExcellent => 'Excelente';

  @override
  String get prStatusStrong => 'Fuerte';

  @override
  String get prStatusModerate => 'Moderado';

  @override
  String get prStatusDeveloping => 'En Desarrollo';

  @override
  String get prStatusChallenging => 'Desafiante';

  @override
  String get prChipHomeOwner => 'Propietario de Vivienda';

  @override
  String get prChipWealthBuilder => 'Constructor de Riqueza';

  @override
  String get prChipLandOwner => 'Propietario de Tierras';

  @override
  String get prChipInvestor => 'Inversor Inmobiliario';

  @override
  String get prChipInheritance => 'Herencia Probable';

  @override
  String get prChipVehicle => 'Propietario de Vehículo';

  @override
  String get prChipGlobalAsset => 'Afinidad con Activos Globales';

  @override
  String get prProfileTitle => 'Tu Estilo de Propiedad';

  @override
  String get prHomeAesthetics => 'Estética del Hogar';

  @override
  String get prHomeSanctuary => 'El Hogar como Santuario';

  @override
  String get prComfortInvestment => 'Inversión en Confort';

  @override
  String get prVastuPriority => 'Prioridad de Vastu';

  @override
  String get prNaturalElements => 'Elementos Naturales';

  @override
  String get prNextActionLabel => 'Próxima Acción';

  @override
  String get prKarakaTitle => 'Tus Planetas de Propiedad';

  @override
  String get prKarakaSubtitle =>
      'Qué planetas dan forma a tu suerte en propiedades';

  @override
  String get prPrimaryKaraka => 'Karaka Principal';

  @override
  String get prDurableAsset => 'Karaka de Activos Duraderos';

  @override
  String get prYogasTitle => 'Yogas y Doshas de Propiedad';

  @override
  String get prCurrentPhase => 'Fase Actual';

  @override
  String get prBoosters => 'Potenciadores';

  @override
  String get prDrains => 'Drenajes';

  @override
  String get prVerificationTitle => 'Verificado en las Cartas';

  @override
  String get prD4Property => 'Carta D4 de Propiedades';

  @override
  String get prD16Vehicle => 'Carta D16 de Vehículos';

  @override
  String get prVehicleFit => 'Afinidad con Vehículos';

  @override
  String get prJourneyTitle => 'Trayectoria y Cronología de Propiedad';

  @override
  String get prFirstHomeAge => 'Edad de la Primera Vivienda';

  @override
  String get prFirstHomeType => 'Tipo de Primera Vivienda';

  @override
  String get prMultipleHomes => 'Múltiples Viviendas';

  @override
  String get prNewPropertySoon => 'Nueva Propiedad Pronto';

  @override
  String get prFirstMajorWindow => 'Primera Gran Ventana';

  @override
  String get prBuyingWindow => 'Ventana de Compra';

  @override
  String get prConstructionWindow => 'Ventana de Construcción';

  @override
  String get prNextOpportunity => 'Próxima Oportunidad';

  @override
  String get prLifetimePropertyCount => 'Cantidad de Propiedades en la Vida';

  @override
  String get prInheritanceTitle => 'Herencia y Propiedad Familiar';

  @override
  String get prMaternalInheritance => 'Herencia Materna';

  @override
  String get prPaternalInheritance => 'Herencia Paterna';

  @override
  String get prAncestralProperty => 'Propiedad Ancestral';

  @override
  String get prFamilyDisputeRisk => 'Riesgo de Disputa Familiar';

  @override
  String get prInheritanceTiming => 'Timing de la Herencia';

  @override
  String get prInheritanceType => 'Tipo de Herencia';

  @override
  String get prLandInvestTitle => 'Tierras, Inversión y Propiedad Global';

  @override
  String get prPropertyInvestor => 'Puntaje de Inversor Inmobiliario';

  @override
  String get prAppreciationLuck => 'Suerte de Apreciación';

  @override
  String get prInvestorMindset => 'Mentalidad Inversora';

  @override
  String get prLandType => 'Tipo de Terreno';

  @override
  String get prRentalCount => 'Cantidad de Propiedades en Alquiler';

  @override
  String get prMultipleLand => 'Múltiples Parcelas de Tierra';

  @override
  String get prFarmEstate => 'Probabilidad de Finca / Hacienda';

  @override
  String get prGlobalPropertyLabel => 'Propiedad Global';

  @override
  String get prForeignProperty => 'Propiedad en el Extranjero';

  @override
  String get prNriAffinity => 'Afinidad con Activos NRI';

  @override
  String get prVehiclesTitle => 'Vehículos';

  @override
  String get prVehicleCount => 'Cantidad de Vehículos';

  @override
  String get prVehicleFirstAge => 'Edad del Primer Vehículo';

  @override
  String get prVehicleCategory => 'Categoría del Vehículo';

  @override
  String get prVehicleQuality => 'Calidad del Vehículo';

  @override
  String get prLuxuryAffinity => 'Afinidad con el Lujo';

  @override
  String get prVehicleLossRisk => 'Riesgo de Pérdida / Daño de Vehículo';

  @override
  String get prLegalRiskTitle => 'Vigilancia Legal y de Riesgo';

  @override
  String get prBoundaryDisputes => 'Disputas de Linderos';

  @override
  String get prPartitionDisputes => 'Disputas de Partición';

  @override
  String get prTitleIssues => 'Problemas de Título / Documentación';

  @override
  String get prTenantConflict => 'Conflicto Inquilino-Propietario';

  @override
  String get prForcedSale => 'Riesgo de Venta Forzada';

  @override
  String get prPropertyDamage => 'Riesgo de Daño a la Propiedad';

  @override
  String get prInsurancePriority => 'Prioridad de Seguro';

  @override
  String get prProtectionUrgency => 'Urgencia de Protección';

  @override
  String get prProtectiveFactors => 'Factores Protectores';

  @override
  String get prChronicVulnerabilities => 'Vulnerabilidades Crónicas';

  @override
  String get prDueDiligenceTitle =>
      'Lista de Verificación de Debida Diligencia';

  @override
  String get prPreventiveMeasures => 'Medidas Preventivas';

  @override
  String get prImprovementTitle => 'Plan de Mejora';

  @override
  String get prReliabilityTitle => 'Confiabilidad';

  @override
  String get prLayerD1 => 'Carta Natal (D1)';

  @override
  String get prLayerD4 => 'Carta de Propiedades (D4)';

  @override
  String get prLayerD16 => 'Carta de Vehículos (D16)';

  @override
  String get prLayerDasha => 'Timing de Dasha';

  @override
  String get prLayerTransit => 'Tránsitos';

  @override
  String get prTopicBuying => '¿Cuál es el mejor momento para comprar?';

  @override
  String get prTopicInherit => '¿Heredaré alguna propiedad?';

  @override
  String get prTopicVehicle => '¿Cuándo obtendré un vehículo?';

  @override
  String get prTopicRental => '¿Cuál es el potencial de ingresos por alquiler?';

  @override
  String get prTopicLand => '¿Cuáles son mis probabilidades de poseer tierras?';

  @override
  String get prTopicLegal => '¿Qué riesgos legales debo vigilar?';

  @override
  String get prTopicForeign =>
      '¿Cuáles son mis probabilidades de propiedad en el extranjero?';

  @override
  String get prTopicTiming =>
      '¿Cuáles son las mejores ventanas de tiempo para propiedades?';

  @override
  String get edTitle => 'Análisis de Educación y Aprendizaje';

  @override
  String get edSubtitle => 'Informe Védico de Educación con IA';

  @override
  String get edSnapshotHeader => 'Tu Resumen de Educación';

  @override
  String get edOverallStrength => 'Fuerza General';

  @override
  String get edAcademicSuccess => 'Éxito Académico';

  @override
  String get edLearningCapacity => 'Capacidad de Aprendizaje';

  @override
  String get edIntellect => 'Intelecto';

  @override
  String get edMemory => 'Memoria';

  @override
  String get edStatusExcellent => 'Potencial Excelente';

  @override
  String get edStatusStrong => 'Potencial Fuerte';

  @override
  String get edStatusModerate => 'Potencial Moderado';

  @override
  String get edStatusDeveloping => 'Potencial en Desarrollo';

  @override
  String get edStatusChallenging => 'Fase Desafiante';

  @override
  String get edChipSaraswati => 'Yoga de Saraswati';

  @override
  String get edChipGajaKesari => 'Yoga Gaja Kesari';

  @override
  String get edChipBudhaAditya => 'Yoga Budha Aditya';

  @override
  String get edChipResearch => 'Fuerte Capacidad de Investigación';

  @override
  String get edChipScholarship => 'Potencial de Beca';

  @override
  String get edChipDoctorate => 'Potencial de Doctorado';

  @override
  String get edChipForeign => 'Apoyo para Educación en el Extranjero';

  @override
  String get edChipLifelong => 'Aprendiz de por Vida';

  @override
  String get edLearningStyleTitle => 'Tu Estilo de Aprendizaje';

  @override
  String get edSoulPlanet => 'Planeta del Alma';

  @override
  String get edSoulHint =>
      'Tu impulso interior más profundo y propósito de vida';

  @override
  String get edSubjectPlanet => 'Planeta de la Materia';

  @override
  String get edTechAtmakaraka => 'Atmakaraka (técnico)';

  @override
  String get edTechAmatyakaraka => 'Amatyakaraka (técnico)';

  @override
  String get edSubjectKarakaStrength => 'Fuerza del Karaka de la Materia';

  @override
  String get edFoundationTitle => 'Fundamento Educativo';

  @override
  String get edHouse4 => 'Educación Temprana';

  @override
  String get edHouse5 => 'Inteligencia';

  @override
  String get edHouse9 => 'Estudios Superiores';

  @override
  String get edPurvaPunya => 'Mérito de Vida Pasada';

  @override
  String get edStudyPlanetsTitle => 'Tus Planetas de Estudio';

  @override
  String get edYogasTitle => 'Yogas Educativos en Tu Carta';

  @override
  String get edYogaBudhaAditya => 'Budha Aditya';

  @override
  String get edYogaGajaKesari => 'Gaja Kesari';

  @override
  String get edYogaSaraswati => 'Saraswati';

  @override
  String get edYogaPresent => 'Presente';

  @override
  String get edYogaAbsent => 'Ausente';

  @override
  String get edYogaNoneNote =>
      'No hay yogas educativos clásicos — el éxito viene del esfuerzo constante y la disciplina.';

  @override
  String get edVerificationTitle => 'Verificación en las Cartas';

  @override
  String get edD24Learning => 'D24 — Carta de Aprendizaje Profundo';

  @override
  String get edD4Formal => 'D4 — Carta de Educación Formal';

  @override
  String get edD9Dharma => 'D9 — Carta del Dharma del Aprendizaje';

  @override
  String get edD60Karma => 'D60 — Karma de Aprendizaje de Vida Pasada';

  @override
  String get edSubjectsTitle => 'Mejores Materias Para Ti';

  @override
  String get edSubjectsSubtitle => 'Clasificadas por afinidad de la carta';

  @override
  String get edLowAffinity => 'Materias de Menor Afinidad';

  @override
  String get edDegreesTitle => 'Probabilidad de Título y Nivel';

  @override
  String get edExpectedLevel => 'Nivel Esperado';

  @override
  String get edDegreeFormal => 'Título Formal';

  @override
  String get edDegreePostgrad => 'Posgrado';

  @override
  String get edDegreeDoctorate => 'Doctorado';

  @override
  String get edDegreeForeign => 'Educación en el Extranjero';

  @override
  String get edTimelineTitle => 'Cronología de Estudios';

  @override
  String get edEarlySchooling => 'Ventana de Educación Temprana';

  @override
  String get edHigherEducation => 'Ventana de Educación Superior';

  @override
  String get edPostgradResearch => 'Ventana de Posgrado / Investigación';

  @override
  String get edPeakLearningAge => 'Edad Pico de Aprendizaje';

  @override
  String get edPreferencesTitle => 'Preferencias de Aprendizaje y Apoyo';

  @override
  String get edPrefStudyMode => 'Modo de Estudio';

  @override
  String get edPrefTiming => 'Mejor Momento';

  @override
  String get edPrefEnvironment => 'Ambiente';

  @override
  String get edPrefLocation => 'Ubicación';

  @override
  String get edPrefForeign => 'Estudios en el Extranjero';

  @override
  String get edGuruRelationship => 'Vínculo con Maestro/Gurú';

  @override
  String get edMentorAvailability => 'Disponibilidad de Mentor';

  @override
  String get edPeerLearning => 'Aprendizaje entre Pares';

  @override
  String get edAuthorityDeference => 'Respeto por la Autoridad';

  @override
  String get edStrengthsTitle => 'Fortalezas y Desafíos';

  @override
  String get edCognitiveGifts => 'Dones Cognitivos';

  @override
  String get edNaturalAbilities => 'Habilidades Naturales de Aprendizaje';

  @override
  String get edHiddenCapacities => 'Capacidades Ocultas';

  @override
  String get edConcentration => 'Dificultad de Concentración';

  @override
  String get edBreakRisk => 'Riesgo de Interrupción Educativa';

  @override
  String get edDisciplineConsistency => 'Consistencia Disciplinaria';

  @override
  String get edScholarshipLikelihood => 'Probabilidad de Beca';

  @override
  String get edCareerLinkTitle => 'Educación → Camino Profesional';

  @override
  String get edDirectionRec => 'Dirección Recomendada';

  @override
  String get edIntegrationStrategy => 'Estrategia de Integración';

  @override
  String get edCareerLinkage => 'Vínculo con la Carrera';

  @override
  String get edAlignedSubjects => 'Materias Alineadas con la Carrera';

  @override
  String get edDegreeUtility => 'Utilidad del Título para la Carrera';

  @override
  String get edImprovementTitle => 'Tu Plan de Mejora';

  @override
  String get edReliabilityTitle => 'Confiabilidad de la Predicción';

  @override
  String get edLayerD1 => 'Carta Natal (D1)';

  @override
  String get edLayerD4 => 'Educación Formal (D4)';

  @override
  String get edLayerD9 => 'Navamsa (D9)';

  @override
  String get edLayerD24 => 'Aprendizaje Profundo (D24)';

  @override
  String get edLayerD60 => 'Aprendizaje de Vida Pasada (D60)';

  @override
  String get edLayerAmk => 'Karaka de la Materia';

  @override
  String get edLayerMj => 'Mercurio-Júpiter';

  @override
  String get edLayerDasha => 'Timing Planetario';

  @override
  String get edTopicSubjects => 'Mejores Materias Para Mí';

  @override
  String get edTopicDegree => 'Probabilidades de Título';

  @override
  String get edTopicAbroad => 'Estudiar en el Extranjero';

  @override
  String get edTopicExam => 'Desempeño en Exámenes';

  @override
  String get edTopicHabits => 'Hábitos de Estudio';

  @override
  String get edTopicCareerLink => 'Vínculo Educación-Carrera';

  @override
  String get edTopicTiming => 'Ventanas de Timing Educativo';

  @override
  String get edTopicScholarship => 'Probabilidades de Beca';

  @override
  String get hwTitle => 'Análisis de Salud y Bienestar';

  @override
  String get hwSubtitle => 'Informe Védico de Salud y Bienestar con IA';

  @override
  String get hwSnapshotHeader => 'Tu Resumen de Salud';

  @override
  String get hwOverallVitality => 'Vitalidad';

  @override
  String get hwImmunity => 'Inmunidad';

  @override
  String get hwRecovery => 'Recuperación';

  @override
  String get hwMentalWellness => 'Bienestar Mental';

  @override
  String get hwStressTolerance => 'Tolerancia al Estrés';

  @override
  String get hwStatusThriving => 'Floreciente';

  @override
  String get hwStatusGood => 'Buena Vitalidad';

  @override
  String get hwStatusBalanced => 'Equilibrado';

  @override
  String get hwStatusNeedsCare => 'Necesita Cuidado';

  @override
  String get hwStatusNeedsAttention => 'Necesita Atención';

  @override
  String get hwChipImmunity => 'Inmunidad Fuerte';

  @override
  String get hwChipRecovery => 'Recuperación Rápida';

  @override
  String get hwChipMentalBalance => 'Mente Equilibrada';

  @override
  String get hwChipStressResilience => 'Resiliente al Estrés';

  @override
  String get hwChipFertility => 'Apoyo a la Fertilidad';

  @override
  String get hwChipWorkLife => 'Buen Equilibrio Vida-Trabajo';

  @override
  String get hwChipLowAddiction => 'Bajo Riesgo de Adicción';

  @override
  String get hwConstitutionTitle => 'Tu Tipo de Cuerpo';

  @override
  String get hwConstitutionSubtitle => 'Constitución ayurvédica según tu carta';

  @override
  String get hwDominantDosha => 'Dominante';

  @override
  String get hwSecondaryDosha => 'Secundario';

  @override
  String get hwPrimaryKaraka => 'Principal Indicador de Salud';

  @override
  String get hwStrongestSystem => 'Sistema Más Fuerte';

  @override
  String get hwWeakestSystem => 'Sistema a Fortalecer';

  @override
  String get hwBodyMapTitle => 'El Mapa Planetario de Tu Cuerpo';

  @override
  String get hwBodyMapSubtitle => '9 planetas, 9 sistemas corporales';

  @override
  String get hwYogaTitle => 'Patrones de Salud en Tu Carta';

  @override
  String get hwYogaSubtitle =>
      'Yogas protectores frente a presión de enfermedad';

  @override
  String get hwDiseasePressureLabel => 'PRESIÓN DE ENFERMEDAD';

  @override
  String get hwAreasTitle => 'Áreas del Cuerpo a Vigilar';

  @override
  String get hwAreasSubtitle => 'Vulnerabilidad por zona corporal';

  @override
  String get hwProtectedAreas => 'Áreas Bien Protegidas';

  @override
  String get hwCategoriesTitle => 'Vigilancia por Categoría de Enfermedad';

  @override
  String get hwCategoriesSubtitle =>
      'Susceptibilidad en las principales categorías de salud';

  @override
  String get hwLowRiskCategories => 'Categorías de Bajo Riesgo';

  @override
  String get hwMentalTitle => 'Bienestar Mental y Emocional';

  @override
  String get hwMentalSubtitle => 'Resiliencia emocional y necesidades de apoyo';

  @override
  String get hwMentalVulnerability => 'Sensibilidad Emocional';

  @override
  String get hwEmotionalRegulation => 'Regulación Emocional';

  @override
  String get hwSupportRec => 'Recomendación de Apoyo';

  @override
  String get hwTendencies => 'Tendencias Mentales';

  @override
  String get hwTimelineTitle => 'Cronología de Salud';

  @override
  String get hwTimelineSubtitle =>
      'Años pico, años de precaución y ventanas de recuperación';

  @override
  String get hwPeakYears => 'Años de Máximo Bienestar';

  @override
  String get hwCautionYears => 'Años de Precaución';

  @override
  String get hwRecoveryWindow => 'Ventana de Recuperación';

  @override
  String get hwCheckupYears => 'Años Recomendados para Chequeo';

  @override
  String get hwCurrentPhase => 'Fase Actual';

  @override
  String get hwLifestyleTitle => 'Tu Guía de Estilo de Vida';

  @override
  String get hwLifestyleSubtitle =>
      'Lo que tu carta dice sobre los hábitos diarios';

  @override
  String get hwSleepDiscipline => 'Impacto de la Disciplina de Sueño';

  @override
  String get hwDietDiscipline => 'Impacto de la Disciplina Alimentaria';

  @override
  String get hwExerciseNeed => 'Necesidad de Ejercicio';

  @override
  String get hwSunlightNeed => 'Necesidad de Luz Solar';

  @override
  String get hwStressSusceptibility => 'Susceptibilidad al Estrés';

  @override
  String get hwHydrationSensitivity => 'Sensibilidad a la Hidratación';

  @override
  String get hwSocialType => 'Tipo de Energía Social';

  @override
  String get hwHealingSpeed => 'Velocidad de Sanación';

  @override
  String get hwTreatmentResponse => 'Respuesta al Tratamiento';

  @override
  String get hwAltHealing => 'Afinidad con Sanación Alternativa';

  @override
  String get hwSpecialTitle => 'Etapas de Vida y Temas Especiales';

  @override
  String get hwSpecialSubtitle =>
      'Fertilidad, salud infantil, hábitos y agotamiento';

  @override
  String get hwFertility => 'Indicador de Fertilidad';

  @override
  String get hwHormonalBalance => 'Equilibrio Hormonal';

  @override
  String get hwReproductiveStrength => 'Fuerza del Sistema Reproductivo';

  @override
  String get hwChildhoodVuln => 'Vulnerabilidad de Salud Infantil';

  @override
  String get hwChildhoodStatus => 'Salud Infantil';

  @override
  String get hwAddictionVuln => 'Vulnerabilidad a la Adicción';

  @override
  String get hwAddictionRecovery => 'Capacidad de Recuperación';

  @override
  String get hwBurnoutVuln => 'Vulnerabilidad al Agotamiento';

  @override
  String get hwWorkLifeBalance => 'Equilibrio Vida-Trabajo';

  @override
  String get hwStressTriggers => 'Detonantes de Estrés';

  @override
  String get hwProtectiveFactors => 'Factores Protectores';

  @override
  String get hwChallengesTitle => 'Desafíos a Vigilar';

  @override
  String get hwChallengesSubtitle => 'Dónde enfocar el cuidado preventivo';

  @override
  String get hwMitigation => 'Cómo Manejarlo';

  @override
  String get hwChronicAreas => 'Áreas de Vulnerabilidad Crónica';

  @override
  String get hwPreventivePriorities => 'Prioridades Preventivas';

  @override
  String get hwImprovementTitle => 'Tu Plan de Bienestar';

  @override
  String get hwImprovementSubtitle =>
      'Pasos prácticos + remedios tradicionales';

  @override
  String get hwReliabilityTitle => 'Confiabilidad de la Lectura';

  @override
  String get hwLayerD1 => 'Carta Natal (D1)';

  @override
  String get hwLayerD6 => 'Carta de Salud (D6)';

  @override
  String get hwLayerD30 => 'Carta de Micro-Salud (D30)';

  @override
  String get hwLayerDasha => 'Timing Planetario';

  @override
  String get hwLayerTransit => 'Tránsitos Actuales';

  @override
  String get hwDisclaimerLabel => 'Aviso Médico';

  @override
  String get hwTopicImmunity => 'Fortalecer la Inmunidad';

  @override
  String get hwTopicSleep => 'Sueño y Descanso';

  @override
  String get hwTopicStress => 'Manejar el Estrés';

  @override
  String get hwTopicFertility => 'Timing de Fertilidad';

  @override
  String get hwTopicDiet => 'Dieta y Nutrición';

  @override
  String get hwTopicTiming => 'Ventanas de Timing de Salud';

  @override
  String get hwTopicMental => 'Bienestar Mental';

  @override
  String get hwTopicPrevention => 'Plan de Cuidado Preventivo';

  @override
  String get lvSubtitle => 'Informe Védico de Amor con IA';

  @override
  String get lvTitle => 'Amor y Relaciones';

  @override
  String get lvLovePotential => 'Potencial Amoroso';

  @override
  String get lvEmotionalAvail => 'Emocionalmente Abierto';

  @override
  String get lvAttraction => 'Atracción';

  @override
  String get lvCommitment => 'Compromiso';

  @override
  String get lvCommunication => 'Comunicación';

  @override
  String get lvFidelity => 'Lealtad';

  @override
  String get lvChipLoyal => 'Corazón leal';

  @override
  String get lvChipOpenHeart => 'De corazón abierto';

  @override
  String get lvChipCommunicator => 'Gran comunicador';

  @override
  String get lvChipMature => 'Maneja bien el conflicto';

  @override
  String get lvChipEmotionallyWise => 'Emocionalmente sabio';

  @override
  String get lvLoveStyle => 'Tu Estilo Amoroso';

  @override
  String get lvAttractionStyle => 'Estilo de atracción';

  @override
  String get lvLangGiven => 'Expresas Amor Mediante';

  @override
  String get lvLangReceived => 'Te Sientes Amado Mediante';

  @override
  String get lvLovePlanets => 'Tus Planetas del Amor';

  @override
  String get lvLoveKaraka => 'Amor';

  @override
  String get lvEmotionKaraka => 'Emoción';

  @override
  String get lvPassionKaraka => 'Pasión';

  @override
  String get lvPathToLove => 'Tu Camino hacia el Amor';

  @override
  String get lvPathSub => 'Amor vs matrimonio arreglado';

  @override
  String get lvLoveMarriage => 'Matrimonio por Amor';

  @override
  String get lvArrangedMarriage => 'Matrimonio Arreglado';

  @override
  String get lvParentalAccept => 'Aceptación de los Padres';

  @override
  String get lvInterCaste => 'Intercasta / Religión';

  @override
  String get lvIdealPartner => 'Tu Pareja Ideal';

  @override
  String get lvPersonality => 'Personalidad';

  @override
  String get lvAppearance => 'Apariencia';

  @override
  String get lvIdealTraits => 'Rasgos Ideales';

  @override
  String get lvWhatMatters => 'Lo Que Más Importa';

  @override
  String get lvDrawnTo => 'Atraído/a por';

  @override
  String get lvDealbreakers => 'Puntos de Ruptura';

  @override
  String get lvYourAppeal => 'Tu atractivo';

  @override
  String get lvLoveStory => 'Tu Historia de Amor';

  @override
  String get lvLoveStorySub => 'Patrones de relación';

  @override
  String get lvFirstLove => 'Primer Amor';

  @override
  String get lvRelationCount => 'Vínculos Significativos';

  @override
  String get lvDuration => 'Duración Típica';

  @override
  String get lvDepth => 'Profundidad Emocional';

  @override
  String get lvDatingPattern => 'Patrón de Citas';

  @override
  String get lvCommitIntimacy => 'Compromiso e Intimidad';

  @override
  String get lvCommitReady => 'Disposición al Compromiso';

  @override
  String get lvIntimacyDrive => 'Impulso de Intimidad';

  @override
  String get lvSensuality => 'Sensualidad';

  @override
  String get lvEmpathy => 'Empatía';

  @override
  String get lvCommitStyle => 'Estilo de Compromiso';

  @override
  String get lvChemistry => 'Estilo de Química';

  @override
  String get lvMakesCommit => 'Qué Te Hace Comprometerte';

  @override
  String get lvMakesFlee => 'Qué Te Aleja';

  @override
  String get lvEmotional => 'Inteligencia Emocional';

  @override
  String get lvEmotionalIQ => 'Coeficiente Emocional';

  @override
  String get lvConflictStyle => 'Estilo de Conflicto';

  @override
  String get lvTiming => 'Timing del Amor';

  @override
  String get lvNewLove12 => 'Nuevo amor en 12 meses';

  @override
  String get lvEnergyNow => 'Energía actual';

  @override
  String get lvPhaseNow => 'Fase actual';

  @override
  String get lvPeakRomance => 'Años Pico de Romance';

  @override
  String get lvNewLoveWindow => 'Ventana de Nuevo Amor';

  @override
  String get lvChallenges => 'Desafíos a Vigilar';

  @override
  String get lvRiskHeartbreak => 'Vulnerabilidad a Decepciones';

  @override
  String get lvRiskSabotage => 'Autosabotaje';

  @override
  String get lvRiskCommitFear => 'Miedo al Compromiso';

  @override
  String get lvRiskRepeat => 'Patrones Repetitivos';

  @override
  String get lvRiskWorkaholic => 'Trabajo por Encima del Amor';

  @override
  String get lvRedFlags => 'Señales de alerta a vigilar';

  @override
  String get lvHealing => 'Qué Sanar';

  @override
  String get lvFocusArea => 'Área de Enfoque';

  @override
  String get lvHealDir => 'Dirección de sanación';

  @override
  String get lvImprovementPlan => 'Plan de Mejora';

  @override
  String get lvReliability => 'Confiabilidad de la Predicción';

  @override
  String get lvLayerBirth => 'Carta Natal (D1)';

  @override
  String get lvLayerNavamsa => 'Navamsa (D9)';

  @override
  String get lvLayerSaptamsa => 'Saptamsa (D7)';

  @override
  String get lvLayerDasha => 'Timing de Dasha';

  @override
  String get lvLayerTransit => 'Tránsitos Actuales';

  @override
  String get lvTopicWhen => '¿Cuándo encontraré el amor?';

  @override
  String get lvTopicSoulmate => 'Sobre mi alma gemela';

  @override
  String get lvTopicCurrent => 'Mi relación actual';

  @override
  String get lvTopicHeal => 'Sanar del pasado';

  @override
  String get lvTopicCommit => 'Ayuda con el compromiso';

  @override
  String get lvTopicLoveVsArranged => 'Amor vs matrimonio arreglado';

  @override
  String get lvTopicHeartbreak => 'Evitar decepciones amorosas';

  @override
  String get lvTopicConfidence => 'Confianza en el amor';

  @override
  String get mrSubtitle => 'Informe Védico de Matrimonio con IA';

  @override
  String get mrTitle => 'Matrimonio y Familia';

  @override
  String get mrMarriagePotential => 'Potencial Matrimonial';

  @override
  String get mrHarmony => 'Armonía';

  @override
  String get mrLongevity => 'Longevidad';

  @override
  String get mrSatisfaction => 'Satisfacción';

  @override
  String get mrStability => 'Estabilidad del Hogar';

  @override
  String get mrClarity => 'Claridad';

  @override
  String get mrChipHarmony => 'Vínculo armonioso';

  @override
  String get mrChipNoMangal => 'Sin Mangal dosh';

  @override
  String get mrChipLongLasting => 'Duradero';

  @override
  String get mrChipHome => 'Probable vivienda propia';

  @override
  String get mrChipInLaws => 'Buenos suegros';

  @override
  String get mrChipChildren => 'Bendecido con hijos';

  @override
  String get mrSpouse => 'Tu Futuro Cónyuge';

  @override
  String get mrSpouseSub => 'Lo que sugiere la carta';

  @override
  String get mrSpouseTraits => 'Personalidad Probable';

  @override
  String get mrSpouseWork => 'Profesión Probable';

  @override
  String get mrAgeDiff => 'Diferencia de Edad';

  @override
  String get mrCulture => 'Compatibilidad Cultural';

  @override
  String get mrEducation => 'Educación';

  @override
  String get mrFamilyBg => 'Antecedentes Familiares';

  @override
  String get mrSoulPartnership => 'Alma y Pareja';

  @override
  String get mrSelfPlanet => 'Tú en un Vínculo';

  @override
  String get mrSpousePlanet => 'Tu Planeta del Cónyuge';

  @override
  String get mrSoulAlignment => 'Alineación del Alma';

  @override
  String get mrAlignStrong =>
      'Tu alma y tu pareja ideal están fuertemente alineadas — un vínculo profundamente satisfactorio tiene buen respaldo.';

  @override
  String get mrAlignModerate =>
      'Tu alma y tu pareja ideal están moderadamente alineadas — un vínculo satisfactorio crece con esfuerzo consciente.';

  @override
  String get mrAlignLow =>
      'Tu alma y tu vida en pareja necesitan una integración consciente — elige una pareja que realmente coincida con tus valores internos.';

  @override
  String get mrTechDarakaraka => 'Planeta del cónyuge (Darakaraka)';

  @override
  String get mrUpapada => 'Punto matrimonial (Upapada)';

  @override
  String get mrUpapadaLord => 'Señor de Upapada';

  @override
  String get mrFoundation => 'Fundamento del Matrimonio';

  @override
  String get mrMarriageSign => 'Signo del Matrimonio';

  @override
  String get mrMarriageLord => 'Señor del Matrimonio';

  @override
  String get mrHouseStrength => 'Fuerza de la Casa';

  @override
  String get mrPartnerHint => 'Pista sobre la pareja según tu carta';

  @override
  String get mrHarmonyHdr => 'Armonía de Compatibilidad';

  @override
  String get mrHarmonySub => 'Cómo se conectarán';

  @override
  String get mrEmotional => 'Emocional';

  @override
  String get mrIntellectual => 'Intelectual';

  @override
  String get mrPhysical => 'Intimidad Física';

  @override
  String get mrFinancial => 'Financiero';

  @override
  String get mrCommunication => 'Comunicación';

  @override
  String get mrSharedValues => 'Valores Compartidos';

  @override
  String get mrSpiritual => 'Espiritual';

  @override
  String get mrConflictRes => 'Resolución de Conflictos';

  @override
  String get mrTiming => 'Timing del Matrimonio';

  @override
  String get mrFirstMarriageAge => 'Edad Probable de Matrimonio';

  @override
  String get mrDelayChance => 'Probabilidad de retraso';

  @override
  String get mrMarriageWindow => 'Ventana de Matrimonio';

  @override
  String get mrSecondaryWindow => 'Ventana Alternativa';

  @override
  String get mrCurrentReadiness => 'En Este Momento';

  @override
  String get mrJourney => 'Recorrido Matrimonial';

  @override
  String get mrJourneySub => 'Cómo evoluciona el vínculo';

  @override
  String get mrPhaseEarly => 'Primeros Años';

  @override
  String get mrPhaseMid => 'Años Intermedios';

  @override
  String get mrPhaseMature => 'Años de Madurez';

  @override
  String get mrPhaseLate => 'Años Posteriores';

  @override
  String get mrTip => 'Consejo';

  @override
  String get mrFamilyHome => 'Familia y Hogar';

  @override
  String get mrInLaws => 'Relaciones con Suegros';

  @override
  String get mrFamilyHarmony => 'Armonía Familiar';

  @override
  String get mrHomeOwnership => 'Propiedad de Vivienda';

  @override
  String get mrDomesticPeace => 'Paz Doméstica';

  @override
  String get mrFertility => 'Fertilidad';

  @override
  String get mrParenting => 'Armonía en la Crianza';

  @override
  String get mrChildren => 'Hijos';

  @override
  String get mrLikelyCount => 'Cantidad probable';

  @override
  String get mrVerification => 'Verificación Cruzada de Cartas';

  @override
  String get mrD9 => 'Carta Matrimonial (D9)';

  @override
  String get mrD10 => 'Carta Carrera-Cónyuge (D10)';

  @override
  String get mrD60 => 'Carta del Karma (D60)';

  @override
  String get mrChallenges => 'Desafíos a Vigilar';

  @override
  String get mrMangalPresent =>
      'Mangal Dosh está presente en la carta — revisa remedios y compatibilidad cuidadosamente.';

  @override
  String get mrMangalAbsent =>
      'No se detectó Mangal Dosh — un indicador matrimonial favorable.';

  @override
  String get mrRiskConflict => 'Conflicto';

  @override
  String get mrRiskSeparation => 'Separación';

  @override
  String get mrRiskDistance => 'Distancia Emocional';

  @override
  String get mrRiskInfidelity => 'Infidelidad';

  @override
  String get mrRiskFinance => 'Desacuerdos de Dinero';

  @override
  String get mrPartnerGuide => 'Guía de Pareja';

  @override
  String get mrPartnerGuideSub => 'Qué buscar';

  @override
  String get mrSeek => 'Busca';

  @override
  String get mrMatchingPriorities => 'Prioridades de Compatibilidad';

  @override
  String get mrImprovementPlan => 'Plan de Mejora';

  @override
  String get mrReliability => 'Confiabilidad de la Predicción';

  @override
  String get mrLayerBirth => 'Carta Natal (D1)';

  @override
  String get mrLayerNavamsa => 'Navamsa (D9)';

  @override
  String get mrLayerDashamsa => 'Dashamsa (D10)';

  @override
  String get mrLayerShashtiamsa => 'Karma (D60)';

  @override
  String get mrLayerDarakaraka => 'Planeta del Cónyuge';

  @override
  String get mrTopicWhen => '¿Cuándo me casaré?';

  @override
  String get mrTopicSpouse => 'Sobre mi cónyuge';

  @override
  String get mrTopicCompat => 'Consejos de compatibilidad';

  @override
  String get mrTopicDelay => 'Retraso del matrimonio';

  @override
  String get mrTopicMangal => 'Mangal dosh';

  @override
  String get mrTopicChildren => 'Timing de los hijos';

  @override
  String get mrTopicInLaws => 'Relaciones con suegros';

  @override
  String get mrTopicHarmony => 'Construir armonía';

  @override
  String get wlSubtitle => 'Informe Védico de Riqueza con IA';

  @override
  String get wlTitle => 'Riqueza y Finanzas';

  @override
  String get wlWealthPotential => 'Potencial de Riqueza';

  @override
  String get wlAccumulation => 'Acumulación';

  @override
  String get wlIncomeFlow => 'Flujo de Ingresos';

  @override
  String get wlRetention => 'Retención';

  @override
  String get wlSustainability => 'Sostenibilidad';

  @override
  String get wlSavings => 'Disciplina de Ahorro';

  @override
  String get wlChipSaver => 'Ahorrador natural';

  @override
  String get wlChipMultiIncome => 'Múltiples ingresos';

  @override
  String get wlChipStrongYogas => 'Yogas de riqueza';

  @override
  String get wlChipLowDebt => 'Baja deuda';

  @override
  String get wlChipInheritance => 'Herencia probable';

  @override
  String get wlChipInvestor => 'Inversor inteligente';

  @override
  String get wlWealthClass => 'Clase de Riqueza';

  @override
  String get wlWealthType => 'Tipo Principal de Riqueza';

  @override
  String get wlPrimarySource => 'Ingreso Principal';

  @override
  String get wlPeakAge => 'Edad Pico de Riqueza';

  @override
  String get wlBoosters => 'Qué Está Impulsando Tu Riqueza';

  @override
  String get wlBoostersSub => 'Combinaciones poderosas de dinero';

  @override
  String get wlWealthImpact => 'impulso';

  @override
  String get wlDrains => 'Drenajes de Riqueza';

  @override
  String get wlIncomeSources => 'Fuentes de Ingresos';

  @override
  String get wlIncomeSourcesSub => 'De dónde proviene tu dinero';

  @override
  String get wlPrimary => 'Principal';

  @override
  String get wlInvestment => 'Plan de Inversión';

  @override
  String get wlInvestmentSub => 'Mezcla ideal de activos';

  @override
  String get wlRiskAppetite => 'Apetito de Riesgo';

  @override
  String get wlInvestStyle => 'Estilo de Inversión';

  @override
  String get wlDrivenBy => 'Impulsado por';

  @override
  String get wlMoneyPersonality => 'Personalidad Financiera';

  @override
  String get wlMoneyType => 'Tipo de Dinero';

  @override
  String get wlSpending => 'Gastos';

  @override
  String get wlSavingsDiscipline => 'Disciplina de Ahorro';

  @override
  String get wlCharity => 'Inclinación a la Caridad';

  @override
  String get wlLuxury => 'Gasto en Lujos';

  @override
  String get wlWindfalls => 'Ganancias Inesperadas y Oportunidades';

  @override
  String get wlWindfallsSub => 'Dinero basado en la suerte';

  @override
  String get wlInheritanceChance => 'Herencia';

  @override
  String get wlSuddenGains => 'Ganancias Repentinas';

  @override
  String get wlLottery => 'Lotería / Especulación';

  @override
  String get wlInsurance => 'Reclamos de Seguro';

  @override
  String get wlWindfallSource => 'Fuente probable de ganancia inesperada';

  @override
  String get wlMoneyPlanets => 'Tus Planetas del Dinero';

  @override
  String get wlPrimaryKaraka => 'Planeta Principal del Dinero';

  @override
  String get wlSecondaryKaraka => 'Planeta Secundario del Dinero';

  @override
  String get wlTimeline => 'Cronología de Riqueza';

  @override
  String get wlPeakYears => 'Años Pico';

  @override
  String get wlGoodPeriod => 'Período Próspero';

  @override
  String get wlSuddenGainWindow => 'Ventana de Ganancia Repentina';

  @override
  String get wlToughPeriod => 'Período de Cautela';

  @override
  String get wlDebtRisks => 'Riesgos de Deuda y Dinero';

  @override
  String get wlDebtChance => 'Probabilidad de Deuda';

  @override
  String get wlLoanBurden => 'Carga de Préstamos';

  @override
  String get wlDrainSources => 'Ten cuidado con';

  @override
  String get wlStrengthen => 'Qué Fortalecer';

  @override
  String get wlWeakestDriver => 'Motor de Dinero Más Débil';

  @override
  String get wlHowToFix => 'Cómo fortalecer';

  @override
  String get wlImprovementPlan => 'Plan de Mejora';

  @override
  String get wlReliability => 'Confiabilidad de la Predicción';

  @override
  String get wlLayerBirth => 'Casas de Riqueza (D1)';

  @override
  String get wlLayerHora => 'Carta Hora (D2)';

  @override
  String get wlLayerNavamsa => 'Navamsa (D9)';

  @override
  String get wlLayerDasha => 'Timing de Dasha';

  @override
  String get wlLayerTransit => 'Tránsitos Actuales';

  @override
  String get wlTopicGrow => 'Cómo hacer crecer la riqueza';

  @override
  String get wlTopicInvest => 'Dónde invertir';

  @override
  String get wlTopicDebt => 'Gestionar la deuda';

  @override
  String get wlTopicProperty => 'Comprar propiedades';

  @override
  String get wlTopicRetire => 'Planificación de jubilación';

  @override
  String get wlTopicPassive => 'Ingresos pasivos';

  @override
  String get wlTopicWindfall => 'Ganancias repentinas';

  @override
  String get wlTopicTiming => 'Mejor timing para el dinero';

  @override
  String get bzSubtitle => 'Informe Védico de Negocios con IA';

  @override
  String get bzTitle => 'Negocios y Emprendimiento';

  @override
  String get bzBusinessPotential => 'Potencial Empresarial';

  @override
  String get bzEntrepreneurship => 'Emprendedor';

  @override
  String get bzVenture => 'Éxito del Emprendimiento';

  @override
  String get bzWealth => 'Riqueza a través del Negocio';

  @override
  String get bzRiskAppetite => 'Apetito de Riesgo';

  @override
  String get bzLongevity => 'Longevidad';

  @override
  String get bzChipWealthMagnet => 'Imán de riqueza';

  @override
  String get bzChipMoneyYoga => 'Yoga de dinero';

  @override
  String get bzChipLeadership => 'Liderazgo';

  @override
  String get bzChipPartnerFit => 'Gran compatibilidad de socios';

  @override
  String get bzChipGains => 'Fuertes ganancias';

  @override
  String get bzChipInvestor => 'Atractivo para inversores';

  @override
  String get bzChipFounder => 'Mentalidad de fundador';

  @override
  String get bzWhatsWorking => 'Lo Que Está Funcionando Para Ti';

  @override
  String get bzWhatsWorkingSub => 'Tus dones empresariales';

  @override
  String get bzClassicYogas => 'Combinaciones clásicas de riqueza';

  @override
  String get bzFounderType => 'Tu Tipo de Fundador';

  @override
  String get bzSoulBusiness => 'Alma y Propósito Empresarial';

  @override
  String get bzSoulPlanet => 'Tu Motor del Alma';

  @override
  String get bzBusinessPlanet => 'Tu Mente Empresarial';

  @override
  String get bzDirectionStrength => 'Claridad de Dirección';

  @override
  String get bzAlignStrong =>
      'Tu propósito del alma y tu dirección empresarial están fuertemente alineados — construir un emprendimiento se siente natural y satisfactorio.';

  @override
  String get bzAlignModerate =>
      'Tu propósito del alma y tu dirección empresarial están moderadamente alineados — un emprendimiento funciona mejor cuando refleja tus valores más profundos.';

  @override
  String get bzAlignLow =>
      'Tu propósito del alma y tu dirección empresarial necesitan una alineación consciente — elige un emprendimiento que realmente coincida con quién eres.';

  @override
  String get bzTechAtmakaraka => 'Planeta del alma (Atmakaraka)';

  @override
  String get bzTechAmatyakaraka => 'Planeta empresarial (Amatyakaraka)';

  @override
  String get bzTechDarakaraka => 'Planeta del socio (Darakaraka)';

  @override
  String get bzFoundation => 'Fundamento Empresarial';

  @override
  String get bzCareerHouse => 'Casa de la Carrera';

  @override
  String get bzGainsHouse => 'Casa de las Ganancias';

  @override
  String get bzLord => 'Señor';

  @override
  String get bzGainsPotential => 'Potencial de Ganancias';

  @override
  String get bzNetwork => 'Poder de Red';

  @override
  String get bzRecovery => 'Fuerza de Recuperación';

  @override
  String get bzVerification => 'Verificación Cruzada de Cartas';

  @override
  String get bzD10 => 'Carta de Carrera (D10)';

  @override
  String get bzD11 => 'Carta de Ganancias (D11)';

  @override
  String get bzD9 => 'Carta de Propósito (D9)';

  @override
  String get bzD60 => 'Carta del Karma (D60)';

  @override
  String get bzFounderSkills => 'Habilidades de Fundador';

  @override
  String get bzSkillStrategy => 'Pensamiento Estratégico';

  @override
  String get bzSkillExecution => 'Ejecución';

  @override
  String get bzSkillPeople => 'Gestión de Personas';

  @override
  String get bzSkillSales => 'Ventas y Persuasión';

  @override
  String get bzSkillFinance => 'Perspicacia Financiera';

  @override
  String get bzSkillOps => 'Disciplina Operativa';

  @override
  String get bzTopSkill => 'Habilidad Principal';

  @override
  String get bzDomains => 'Mejores Áreas de Negocio';

  @override
  String get bzDomainsSub => 'Clasificadas por afinidad natural';

  @override
  String get bzFit => 'AFINIDAD';

  @override
  String get bzBusinessStyleHdr => 'Estilo Empresarial';

  @override
  String get bzStyleService => 'Producto vs Servicio';

  @override
  String get bzStyleMarket => 'Enfoque de Mercado';

  @override
  String get bzStyleTech => 'Enfoque Tecnológico';

  @override
  String get bzStyleLeadership => 'Estilo de Liderazgo';

  @override
  String get bzStylePartnership => 'Solo o en Sociedad';

  @override
  String get bzWhereBuild => 'Alcance';

  @override
  String get bzExpansion => 'Expansión';

  @override
  String get bzSetup => 'Configuración';

  @override
  String get bzPartnership => 'Sociedad y Equipo';

  @override
  String get bzIdealCofounder => 'Cofundador Ideal';

  @override
  String get bzPartnerViability => 'Viabilidad de Sociedad';

  @override
  String get bzTeamBuilding => 'Formación de Equipo';

  @override
  String get bzCofounderFit => 'Compatibilidad de Cofundador';

  @override
  String get bzAdvisorNetwork => 'Red de Asesores';

  @override
  String get bzFunding => 'Financiamiento y Dinero';

  @override
  String get bzRecommendedPath => 'Camino de Financiamiento Recomendado';

  @override
  String get bzInvestorAttract => 'Atractivo para Inversores';

  @override
  String get bzFamilyBacking => 'Apoyo Familiar';

  @override
  String get bzHybridViability => 'Combinación de Empleo + Negocio';

  @override
  String get bzFallback => 'Empleo como Respaldo';

  @override
  String get bzDebtStyle => 'Estilo de Deuda';

  @override
  String get bzTimeline => 'Cronología Empresarial';

  @override
  String get bzCurrentPhase => 'En Este Momento';

  @override
  String get bzLaunchWindow => 'Ventana de Lanzamiento';

  @override
  String get bzScaleWindow => 'Ventana de Crecimiento';

  @override
  String get bzPeakAge => 'Años Pico';

  @override
  String get bzChallenges => 'Desafíos a Vigilar';

  @override
  String get bzRiskFinancial => 'Pérdida Financiera';

  @override
  String get bzRiskBurnout => 'Agotamiento';

  @override
  String get bzRiskTeam => 'Conflicto de Equipo';

  @override
  String get bzRiskLegal => 'Legal / Regulatorio';

  @override
  String get bzFinancialExp =>
      'Riesgo de pérdida de dinero por sobreinversión o mal timing del flujo de caja durante un emprendimiento.';

  @override
  String get bzFinancialFix =>
      'Mantén una reserva de efectivo, comienza de forma austera y valida la demanda antes de escalar el gasto.';

  @override
  String get bzBurnoutExp =>
      'Presionar demasiado durante mucho tiempo puede agotar tu energía y enfoque.';

  @override
  String get bzBurnoutFix =>
      'Protege el descanso, delega temprano y organiza los grandes esfuerzos en torno a períodos favorables.';

  @override
  String get bzTeamExp =>
      'La fricción con cofundadores o el personal puede frenar el negocio.';

  @override
  String get bzTeamFix =>
      'Establece roles y expectativas claras por escrito, y comunícate con frecuencia.';

  @override
  String get bzLegalExp =>
      'Problemas de cumplimiento, contratos o regulación podrían crear obstáculos.';

  @override
  String get bzLegalFix =>
      'Haz revisar los contratos, mantén la documentación en orden y consulta a profesionales desde el principio.';

  @override
  String get bzImprovementPlan => 'Plan de Mejora';

  @override
  String get bzBestDirection => 'Mejor Dirección';

  @override
  String get bzStrategy => 'Estrategia de Construcción';

  @override
  String get bzTopFields => 'Principales Áreas';

  @override
  String get bzEmploymentPath => 'Empleo vs Negocio';

  @override
  String get bzRoadmap => 'Hoja de Ruta de Crecimiento';

  @override
  String get bzRoadmapSub => 'Tu plan de emprendimiento';

  @override
  String get bzReliability => 'Confiabilidad de la Predicción';

  @override
  String get bzLayerBirth => 'Carta Natal (D1)';

  @override
  String get bzLayerNavamsa => 'Navamsa (D9)';

  @override
  String get bzLayerDashamsa => 'Carrera (D10)';

  @override
  String get bzLayerLabhamsa => 'Ganancias (D11)';

  @override
  String get bzLayerShashtiamsa => 'Karma (D60)';

  @override
  String get bzTopicStart => '¿Debo empezar ahora?';

  @override
  String get bzTopicIdea => 'Mejor idea de negocio';

  @override
  String get bzTopicPartner => 'Encontrar un cofundador';

  @override
  String get bzTopicFunding => 'Cómo financiarlo';

  @override
  String get bzTopicScale => 'Cuándo escalar';

  @override
  String get bzTopicRisk => 'Gestionar riesgos';

  @override
  String get bzTopicJob => 'Empleo vs negocio';

  @override
  String get bzTopicTiming => 'Mejor timing';

  @override
  String get crTitle => 'Análisis de Carrera y Empleo';

  @override
  String get crSubtitle => 'Informe Védico de Carrera con IA';

  @override
  String get crCrumbHome => 'Inicio';

  @override
  String get crCrumbReports => 'Informes';

  @override
  String get crCareerPotential => 'Potencial Profesional';

  @override
  String get crStatusStrong => 'Potencial Fuerte';

  @override
  String get crStatusGood => 'Buen Potencial';

  @override
  String get crStatusModerate => 'Potencial Moderado';

  @override
  String get crStatusDeveloping => 'Potencial en Desarrollo';

  @override
  String get crStatusChallenging => 'Fase Desafiante';

  @override
  String get crOverallCareer => 'Carrera General';

  @override
  String get crStability => 'Estabilidad Profesional';

  @override
  String get crGrowth => 'Potencial de Crecimiento';

  @override
  String get crRecognition => 'Reconocimiento';

  @override
  String get crSatisfaction => 'Satisfacción';

  @override
  String get crChipLeadership => 'Liderazgo';

  @override
  String get crChipCreativity => 'Creatividad';

  @override
  String get crChipBusiness => 'Negocios';

  @override
  String get crChipStableIncome => 'Ingreso Estable';

  @override
  String get crChipLearning => 'Aprendizaje';

  @override
  String get crChipGrowth => 'Crecimiento a Largo Plazo';

  @override
  String get crChipTechnical => 'Habilidad Técnica';

  @override
  String get crChipRecognition => 'Reconocimiento';

  @override
  String get crTopInsights => 'Perspectivas Principales';

  @override
  String get crWhatDefines => '¿Qué define tu carrera?';

  @override
  String get crSoulCareer => 'Alma y Propósito Profesional';

  @override
  String get crSoulPlanet => 'Planeta del Propósito del Alma';

  @override
  String get crCareerPlanet => 'Planeta de la Carrera';

  @override
  String get crMeaning => 'Significado';

  @override
  String get crAlignment => 'Alineación Alma ↔ Carrera';

  @override
  String get crAlignStrong =>
      'Tus intereses naturales y tu camino profesional están fuertemente alineados.';

  @override
  String get crAlignModerate =>
      'Tus intereses naturales y tu camino profesional están moderadamente alineados.';

  @override
  String get crAlignLow =>
      'Tus intereses naturales y tu camino profesional necesitan una alineación consciente.';

  @override
  String get crTechAtmakaraka => 'Atmakaraka (indicador del alma)';

  @override
  String get crTechAmatyakaraka => 'Amatyakaraka (indicador profesional)';

  @override
  String get crDegrees => 'Grados';

  @override
  String get crDignity => 'Dignidad';

  @override
  String get crFoundation => 'Fundamento Profesional';

  @override
  String get crCareerSign => 'Signo Profesional';

  @override
  String get crCareerLord => 'Señor de la Carrera';

  @override
  String get crLordPosition => 'Posición del Señor';

  @override
  String get crCareerStrength => 'Fuerza Profesional';

  @override
  String get crProfStyle => 'Estilo Profesional';

  @override
  String get crBestFields => 'Mejores Áreas';

  @override
  String get crTechnicalDetails => 'Detalles Técnicos';

  @override
  String get crHouseLabel => 'Casa';

  @override
  String get crVerification => 'Verificación Profesional en las Cartas';

  @override
  String get crD10Career => 'D10 · Carrera';

  @override
  String get crD9Purpose => 'D9 · Propósito';

  @override
  String get crD60Karma => 'D60 · Karma';

  @override
  String get crStatusNeedsImprovement => 'Necesita Mejora';

  @override
  String get crStatusWellAligned => 'Bien Alineado';

  @override
  String get crStatusStrongSupport => 'Fuerte Apoyo';

  @override
  String get crStatusModerateSupport => 'Apoyo Moderado';

  @override
  String get crChartDetails => 'Detalles técnicos de la carta';

  @override
  String get crPersonality => 'Tu Personalidad Profesional';

  @override
  String get crGrowthAreas => 'Áreas de Crecimiento';

  @override
  String get crBestRoles => 'Mejores Roles';

  @override
  String get crBestIndustries => 'Mejores Industrias';

  @override
  String get crEnvironment => 'Ambiente Profesional';

  @override
  String get crWorkStyle => 'Mejor Estilo de Trabajo';

  @override
  String get crEmployment => 'Empleo';

  @override
  String get crBusiness => 'Negocio';

  @override
  String get crFreelance => 'Freelance / Consultoría';

  @override
  String get crPortfolio => 'Cartera Mixta';

  @override
  String get crLeadership => 'Liderazgo';

  @override
  String get crFit => 'Afinidad';

  @override
  String get crBestFit => 'Mejor Afinidad';

  @override
  String get crTimeline => 'Cronología Profesional';

  @override
  String get crPastPeak => 'Pico Pasado';

  @override
  String get crPresentPhase => 'Fase Actual';

  @override
  String get crUpcoming => 'Próxima Oportunidad';

  @override
  String get crFutureExpansion => 'Expansión Futura';

  @override
  String get crRiskPeriod => 'Período de Riesgo';

  @override
  String get crViewDasha => 'Período planetario (técnico)';

  @override
  String get crChallenges => 'Desafíos a Vigilar';

  @override
  String get crRiskBurnout => 'Agotamiento';

  @override
  String get crRiskRecognition => 'Retraso en el Reconocimiento';

  @override
  String get crRiskConflict => 'Conflicto Laboral';

  @override
  String get crRiskFinancial => 'Inestabilidad Financiera';

  @override
  String get crRiskOverqual => 'Subutilización';

  @override
  String get crPrevention => 'Prevención';

  @override
  String get crBurnoutExp =>
      'Las fases largas y demandantes pueden agotar tu energía con el tiempo.';

  @override
  String get crBurnoutFix =>
      'Protege el descanso, establece límites y organiza los grandes esfuerzos.';

  @override
  String get crRecognitionExp =>
      'Las recompensas y el reconocimiento pueden llegar más lento que tu esfuerzo.';

  @override
  String get crRecognitionFix =>
      'Documenta tus logros y haz visibles tus contribuciones ante tus superiores.';

  @override
  String get crConflictExp =>
      'La fricción con colegas o autoridades puede surgir en ocasiones.';

  @override
  String get crConflictFix =>
      'Comunícate con calma y elige tus batallas con sabiduría.';

  @override
  String get crFinancialExp =>
      'Los ingresos pueden sentirse irregulares durante ciertas fases.';

  @override
  String get crFinancialFix =>
      'Mantén un colchón financiero y evita comprometerte en exceso.';

  @override
  String get crOverqualExp =>
      'Es posible que a veces te sientas subutilizado o poco desafiado.';

  @override
  String get crOverqualFix =>
      'Busca roles que te reten y sigue aprendiendo para mantenerte comprometido.';

  @override
  String get crImprovementPlan => 'Plan de Mejora Profesional';

  @override
  String get crCatPlanetary => 'Planetario y Espiritual';

  @override
  String get crCatPractical => 'Pasos Prácticos';

  @override
  String get crTraditionalExplain => 'Explicación de astrología tradicional';

  @override
  String get crActionPlan => 'Plan de Acción Profesional de 30 Días';

  @override
  String get crWeek1 => 'Semana 1 · Optimización de Perfil';

  @override
  String get crWeek2 => 'Semana 2 · Desarrollo de Habilidades';

  @override
  String get crWeek3 => 'Semana 3 · Networking';

  @override
  String get crWeek4 => 'Semana 4 · Visibilidad Profesional';

  @override
  String get crWeek1Tip =>
      'Actualiza tu currículum y LinkedIn en torno a tu tema profesional más fuerte.';

  @override
  String get crWeek2Tip =>
      'Elige una habilidad de alto valor en tu mejor área y practícala diariamente.';

  @override
  String get crWeek3Tip =>
      'Reconéctate con mentores y contacta a dos nuevos contactos de la industria.';

  @override
  String get crWeek4Tip =>
      'Comparte tu trabajo públicamente y ofrécete como voluntario en un proyecto visible.';

  @override
  String get crPriority => 'Prioridad';

  @override
  String get crTimeRequired => 'Tiempo';

  @override
  String get crExpectedBenefit => 'Beneficio';

  @override
  String get crPriorityHigh => 'Alta';

  @override
  String get crPriorityMedium => 'Media';

  @override
  String get crRoadmap => 'Hoja de Ruta Profesional con IA';

  @override
  String get crNext12 => 'Próximos 12 Meses';

  @override
  String get crBestFocus => 'Mejor Enfoque';

  @override
  String get crSkillsLearn => 'Habilidades a Aprender';

  @override
  String get crIndustriesTarget => 'Industrias Objetivo';

  @override
  String get crExpectedOutcome => 'Resultado Esperado';

  @override
  String get crReliability => 'Confiabilidad de la Predicción';

  @override
  String get crReliabilityHigh => 'Alta Confiabilidad';

  @override
  String get crReliabilityGood => 'Buena Confiabilidad';

  @override
  String get crReliabilityModerate => 'Confiabilidad Moderada';

  @override
  String get crReliabilityExplain =>
      'Este informe combina tu carta natal, cartas divisionales e indicadores de Jaimini. El puntaje refleja qué tan fuertemente coinciden estas capas de la carta.';

  @override
  String get crChartLayers => 'Capas de la carta y ponderaciones';

  @override
  String get crBirthChart => 'Carta Natal (D1)';

  @override
  String get crNavamsa => 'Navamsa (D9)';

  @override
  String get crDashamsa => 'Dashamsa (D10)';

  @override
  String get crShashtiamsa => 'Shashtiamsa (D60)';

  @override
  String get crDiscussAi => 'Consultar con IA';

  @override
  String get crAskAbout => 'Preguntar Sobre';

  @override
  String get crTopicChange => 'Cambio de Carrera';

  @override
  String get crTopicGovt => 'Empleo Gubernamental';

  @override
  String get crTopicBusiness => 'Negocio';

  @override
  String get crTopicPromotion => 'Ascenso';

  @override
  String get crTopicMarriage => 'Matrimonio vs Carrera';

  @override
  String get crTopicAbroad => 'En el Extranjero';

  @override
  String get crTopicIncome => 'Ingresos';

  @override
  String get crTopicPurpose => 'Propósito';

  @override
  String get crTopicResume => 'Currículum';

  @override
  String get crTopicCopied => 'Pregunta copiada — pégala en tu chat de IA.';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return '$soul guía tu llamado interior, mientras que $career da forma a tu profesión exterior.';
  }

  @override
  String get rzTodayOutlook => 'Panorama Zodiacal de Hoy';

  @override
  String get rzPlanetaryEnergy => 'Energía Planetaria de Hoy';

  @override
  String get rzBestSign => 'Mejor Signo';

  @override
  String get rzChallengingSign => 'Más Desafiante';

  @override
  String get rzDominantPlanet => 'Planeta Dominante';

  @override
  String get rzOverallMood => 'Ánimo General';

  @override
  String get rzMoodBright => 'Brillante y Activo';

  @override
  String get rzMoodCalm => 'Tranquilo y Estable';

  @override
  String get rzMoodMixed => 'Energía Mixta';

  @override
  String get rzMoodTense => 'Tenso y Cauteloso';

  @override
  String get rzTodayEnergy => 'Energía de Hoy';

  @override
  String get rzCaution => 'Precaución';

  @override
  String get rzWeak => 'Débil';

  @override
  String get rzAllSigns => 'Todos los Signos Zodiacales';

  @override
  String get rzAiSummary => 'Resumen de IA';

  @override
  String get rzPlanetaryInfluence => 'Influencia Planetaria de Hoy';

  @override
  String get rzStrongInfluences => 'Influencias Fuertes';

  @override
  String get rzShowTechnical => 'Mostrar detalles técnicos';

  @override
  String get rzOpportunities => 'Oportunidades de Hoy';

  @override
  String get rzAvoidTitle => 'Cosas a Evitar Hoy';

  @override
  String get rzTechnicalReason => 'Razón técnica';

  @override
  String get rzAvoidDecisions => 'Apresurar decisiones importantes';

  @override
  String get rzAvoidArguments => 'Discusiones acaloradas';

  @override
  String get rzAvoidInvestments => 'Grandes inversiones';

  @override
  String get rzAvoidOverthink => 'Pensar demasiado en pequeños problemas';

  @override
  String get rzAvoidOverspend => 'Gastos innecesarios';

  @override
  String get rzAvoidStress => 'Estrés y exceso de trabajo';

  @override
  String get rzPlanetaryChart => 'Carta Planetaria de Hoy';

  @override
  String get rzWhatChartMeans => 'Qué significa esta carta';

  @override
  String get rzChartExplain =>
      'Este diamante muestra dónde se encuentra cada planeta en el cielo hoy, mapeado a tu signo. Los planetas en casas favorables elevan el día; los que están en casas difíciles piden cuidado.';

  @override
  String get rzDoNetworking => 'Networking y conexiones';

  @override
  String get rzDoLearning => 'Aprender algo nuevo';

  @override
  String get rzDoMeditation => 'Meditación y calma';

  @override
  String get rzDoFamily => 'Tiempo en familia';

  @override
  String get rzDoCreative => 'Trabajo creativo';

  @override
  String get rzDoRest => 'Descanso y autocuidado';

  @override
  String get rzAiRecommendations => 'Recomendaciones de IA de Hoy';

  @override
  String get rzTechnical => 'Astrología Técnica';

  @override
  String get rzTransitScore => 'Puntaje de Tránsito';

  @override
  String get rzVedha => 'Vedha (Obstrucciones)';

  @override
  String get rzGocharDetails => 'Detalles de Gochar';

  @override
  String get rzAdvancedOnly => 'Para usuarios avanzados';

  @override
  String get rzTomorrow => 'Vista Previa de Mañana';

  @override
  String get rzTomorrowEnergy => 'Energía de Mañana';

  @override
  String get rzImproving => 'Mejorando';

  @override
  String get rzWeaker => 'Ligeramente Más Débil';

  @override
  String get rzSteady => 'Estable';

  @override
  String get rzTomorrowUpLine =>
      'Se espera que la energía aumente mañana — planifica con anticipación las tareas importantes.';

  @override
  String get rzTomorrowDownLine =>
      'La energía puede bajar un poco mañana — mantén el día ligero y estable.';

  @override
  String get rzTomorrowFlatLine =>
      'La energía se mantiene estable mañana — un día tranquilo y equilibrado por delante.';

  @override
  String get rzWeeklyTrend => 'Tendencia Semanal';

  @override
  String get rzMonthlyTrend => 'Tendencia Mensual';

  @override
  String get rzBestDayWeek => 'Mejor Día';

  @override
  String get rzHardestDay => 'Día Más Difícil';

  @override
  String get rzLuckyToday => 'Suerte Hoy';

  @override
  String get rzKarakaSun => 'confianza y vitalidad';

  @override
  String get rzKarakaMoon => 'emociones y paz mental';

  @override
  String get rzKarakaMars => 'energía e impulso';

  @override
  String get rzKarakaMercury => 'comunicación y aprendizaje';

  @override
  String get rzKarakaJupiter => 'sabiduría y crecimiento';

  @override
  String get rzKarakaVenus => 'relaciones y comodidad';

  @override
  String get rzKarakaSaturn => 'disciplina y paciencia';

  @override
  String get rzKarakaRahu => 'ambición y cambio';

  @override
  String get rzKarakaKetu => 'espiritualidad y desapego';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '$dom marca el tono del día, mientras que $chal pide paciencia y cuidado.';
  }

  @override
  String rzInsightGood(Object karaka) {
    return 'Buen día para $karaka.';
  }

  @override
  String rzInsightHard(Object karaka) {
    return 'Tómalo con calma con $karaka hoy.';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return '$karaka está bien respaldado hoy.';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return '$karaka puede enfrentar retrasos hoy.';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return 'Hoy favorece $strong, mientras que $weak necesita paciencia y cuidado.';
  }

  @override
  String get fdEnergyScore => 'Puntaje de Energía de Hoy';

  @override
  String get fdStatusAverage => 'Promedio';

  @override
  String get fdStatusMixed => 'Mixto';

  @override
  String get fdStatusChallenging => 'Desafiante';

  @override
  String get fdTheme => 'Tema de Hoy';

  @override
  String get fdExplainToday => 'Explicar Hoy';

  @override
  String get fdTodaysFocus => 'Enfoque de Hoy';

  @override
  String get fdTopRecommendation => 'Recomendación Principal';

  @override
  String get fdTopCaution => 'Precaución Principal';

  @override
  String get fdReadingTime => 'Tiempo de lectura';

  @override
  String get fdSeconds30 => '30 seg';

  @override
  String get fdCareer => 'Carrera';

  @override
  String get fdMoney => 'Dinero';

  @override
  String get fdLove => 'Amor';

  @override
  String get fdHealth => 'Salud';

  @override
  String get fdTravel => 'Viajes';

  @override
  String get fdFamily => 'Familia';

  @override
  String get fdBestToDo => 'Mejores Cosas Para Hacer Hoy';

  @override
  String get fdAvoidToday => 'Evitar Hoy';

  @override
  String get fdConfidenceLabel => 'Confianza';

  @override
  String get fdBestTime => 'Mejor Momento';

  @override
  String get fdRecommended => 'Recomendado';

  @override
  String get fdReason => 'Razón';

  @override
  String get fdRisk => 'Riesgo';

  @override
  String get fdRecommendation => 'Recomendación';

  @override
  String get fdNoActions =>
      'Nada importante que impulsar hoy — mantén una rutina estable y tranquila.';

  @override
  String get fdNoCautions =>
      'Sin precauciones importantes hoy — procede con conciencia normal.';

  @override
  String get fdHighlights => 'Aspectos Destacados de Hoy';

  @override
  String get fdProbVeryHigh => 'Muy Alta';

  @override
  String get fdProbHigh => 'Alta';

  @override
  String get fdProbElevated => 'Elevada';

  @override
  String get fdProbCaution => 'Precaución';

  @override
  String get fdWhatToDo => 'Qué hacer';

  @override
  String get fdLifeAreas => 'Áreas de Vida';

  @override
  String get fdTapDetails => 'Toca para más detalles';

  @override
  String get fdArea1 => 'Yo y Salud';

  @override
  String get fdArea2 => 'Riqueza y Familia';

  @override
  String get fdArea3 => 'Comunicación';

  @override
  String get fdArea4 => 'Hogar y Comodidad';

  @override
  String get fdArea5 => 'Creatividad y Romance';

  @override
  String get fdArea6 => 'Trabajo y Deberes';

  @override
  String get fdArea7 => 'Relaciones';

  @override
  String get fdArea8 => 'Cambio y Profundidad';

  @override
  String get fdArea9 => 'Suerte y Viajes';

  @override
  String get fdArea10 => 'Carrera y Estatus';

  @override
  String get fdArea11 => 'Ganancias y Red de Contactos';

  @override
  String get fdArea12 => 'Descanso y Espiritualidad';

  @override
  String get fdTodaysMeaning => 'Significado de Hoy';

  @override
  String get fdGoodFor => 'Bueno Para';

  @override
  String get fdAvoid => 'Evitar';

  @override
  String get fdPlanetSupport => 'Apoyo Planetario';

  @override
  String get fdWhyPrediction => '¿Por qué esta predicción?';

  @override
  String get fdAdvancedDetails => 'Detalles Avanzados';

  @override
  String get fdAiRecommendation => 'Recomendación de IA';

  @override
  String get fdOverallStatus => 'Estado General';

  @override
  String get fdNoPlanetTransit =>
      'Ningún planeta importante está transitando esta área hoy.';

  @override
  String get fdFinancialOutlook => 'Panorama Financiero';

  @override
  String get fdIncomeProbability => 'Probabilidad de Ingresos';

  @override
  String get fdExpenseProbability => 'Probabilidad de Gastos';

  @override
  String get fdNetBalance => 'Balance Financiero Neto';

  @override
  String get fdAvoidSpending => 'Evitar Gastos';

  @override
  String get fdRelationshipOutlook => 'Panorama de Relaciones';

  @override
  String get fdOverallScore => 'Puntaje General';

  @override
  String get fdPartner => 'Pareja';

  @override
  String get fdRomance => 'Romance';

  @override
  String get fdWorkplace => 'Lugar de Trabajo';

  @override
  String get fdPublicImage => 'Imagen Pública';

  @override
  String get fdBestActivity => 'Mejor Actividad';

  @override
  String get fdWeakArea => 'Área Débil';

  @override
  String get fdBiggestOpportunity => 'Mayor Oportunidad';

  @override
  String get fdBiggestRisk => 'Mayor Riesgo';

  @override
  String get fdProbability => 'Probabilidad';

  @override
  String get fdProtection => 'Consejo de Protección';

  @override
  String get fdDescription => 'Descripción';

  @override
  String get fdBestTimeToday => 'Mejor Momento Hoy';

  @override
  String get fdAvoidDuring => 'Evitar Durante';

  @override
  String get fdPredictionConfidence => 'Confianza de la Predicción';

  @override
  String get fdConfBasis => 'La predicción de hoy combina';

  @override
  String get fdConfNatal => 'Carta Natal';

  @override
  String get fdConfTransit => 'Tránsito Actual';

  @override
  String get fdConfDasha => 'Períodos Planetarios';

  @override
  String get fdConfStrength => 'Fuerza del Planeta';

  @override
  String get fdConfHouse => 'Activación de Casa';

  @override
  String get fdAskAi => 'Preguntar a la IA';

  @override
  String get fdAskAiSub => 'Toca una pregunta para obtener la respuesta de hoy';

  @override
  String get fdQ1 => '¿Por qué la carrera va lenta hoy?';

  @override
  String get fdQ2 => '¿Cuál es el mejor momento hoy?';

  @override
  String get fdQ3 => '¿Es hoy un buen día para temas de dinero?';

  @override
  String get fdQ4 => '¿Es hoy un buen día para viajar?';

  @override
  String get fdQ5 => '¿Qué debo evitar hoy?';

  @override
  String get fdMoreSuggestions => 'Más Sugerencias';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return 'Hoy es más propicio para $top. $weak puede sentirse lento, así que evita decisiones importantes en esa área. Financieramente el día se ve $fin.';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return 'Tu energía hoy se concentra en torno a $top — apóyate en ella y ve con calma en lo demás.';
  }

  @override
  String get gochToday => 'Hoy';

  @override
  String get gochOverallScore => 'Puntaje General de Tránsito';

  @override
  String get gochNeutral => 'Neutral';

  @override
  String get gochChallenging => 'Desafiante';

  @override
  String get gochTopPositive => 'Lo Más Positivo';

  @override
  String get gochTopChallenges => 'Principales Desafíos';

  @override
  String get gochFilterAll => 'Todos';

  @override
  String get gochFavorability => 'Favorabilidad';

  @override
  String get gochAlerts => 'Alertas de Tránsito';

  @override
  String get gochAlertCritical => 'Crítico';

  @override
  String get gochAlertWarning => 'Precaución';

  @override
  String get gochAlertOpportunity => 'Oportunidad';

  @override
  String get gochAiFocus => 'Enfoque de IA Hoy';

  @override
  String get gochLifeScores => 'Puntajes por Área de Vida';

  @override
  String get gochWhy => '¿Por qué?';

  @override
  String get gochCurrentTransits => 'Tránsitos Activos';

  @override
  String get gochDailyPlan => 'Tu Plan Diario';

  @override
  String get gochMorning => 'Mañana';

  @override
  String get gochAfternoon => 'Tarde';

  @override
  String get gochEvening => 'Noche';

  @override
  String get gochNight => 'Madrugada';

  @override
  String get gochSmartReco => 'Recomendaciones Inteligentes';

  @override
  String get gochExplain => 'Explicar el Tránsito de Hoy';

  @override
  String get gochDo => 'Hacer';

  @override
  String get gochDont => 'Evitar';

  @override
  String get gochDoWork => 'Abordar trabajo importante';

  @override
  String get gochDoMeditate => 'Meditar y reflexionar';

  @override
  String get gochDoStart => 'Iniciar nuevos planes';

  @override
  String get gochDoFinish => 'Terminar tareas pendientes';

  @override
  String get gochDontArgue => 'Evitar discusiones';

  @override
  String get gochDontImpulsive => 'Evitar decisiones impulsivas';

  @override
  String get gochDontOverspend => 'Evitar gastos excesivos';

  @override
  String gochThemeGrowth(Object area) {
    return 'Un día de crecimiento en $area — apóyate en él.';
  }

  @override
  String gochThemeChallenge(Object area) {
    return 'Mantén la paciencia con $area hoy — ve con calma.';
  }

  @override
  String gochPosLine(Object area) {
    return '$area está bien respaldado en este momento.';
  }

  @override
  String gochChalLine(Object area) {
    return '$area necesita cuidado extra hoy.';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return 'Pon tu energía en $a1 hoy, y sé suave con $a2.';
  }

  @override
  String get divBeginner => 'Principiante';

  @override
  String get divSearchHint => 'Buscar: carrera, matrimonio, educación…';

  @override
  String get divSummaryTitle => 'Resumen de Cartas Divisionales';

  @override
  String get divTotalCharts => 'Total de Cartas';

  @override
  String get divMostImportant => 'Más Importante';

  @override
  String get divRecommendedForYou => 'Recomendado Para Ti';

  @override
  String get divCatEssential => 'Cartas Esenciales';

  @override
  String get divCatPersonal => 'Vida Personal';

  @override
  String get divCatKnowledge => 'Cartas de Conocimiento';

  @override
  String get divCatAdvanced => 'Cartas Avanzadas';

  @override
  String get divGoalProperty => 'Propiedad';

  @override
  String get divGoalKarma => 'Karma';

  @override
  String get divBadgeHighlyRec => 'Altamente Recomendado';

  @override
  String get divBadgeRec => 'Recomendado';

  @override
  String get divBadgeUseful => 'Útil';

  @override
  String get divBadgeOptional => 'Opcional';

  @override
  String get divBadgeAdvOnly => 'Solo Avanzado';

  @override
  String get divRecommendBest => 'Recomendar las Mejores Cartas';

  @override
  String get divNoMatch => 'Ninguna carta coincide con tu búsqueda';

  @override
  String get divLifeAreas => 'Áreas de Vida';

  @override
  String divAiUse(Object purpose) {
    return 'Usa esta carta para analizar $purpose.';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return 'Tus cartas $c1 y $c2 son especialmente importantes — empieza por ahí para las áreas que cubren, y luego explora el resto según lo necesites.';
  }

  @override
  String divRecReasonHouse(Object house) {
    return 'Tu casa $house necesita una mirada más cercana — esta carta la muestra en profundidad.';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '$planet es un planeta clave pero puesto a prueba — esta carta revela su condición más profunda.';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return 'Estás en la Mahadasha de $planet, por lo que esta carta es especialmente oportuna ahora.';
  }

  @override
  String divRecSummary(Object c1) {
    return 'Según tu carta, $c1 debería ser tu máxima prioridad. Las cartas a continuación están ordenadas por su relevancia para ti en este momento.';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return 'Abre esta carta cuando quieras estudiar $purpose.';
  }

  @override
  String get yogaHelpful => 'Útil';

  @override
  String get yogaInactive => 'Inactivo';

  @override
  String get yogaTabMoney => 'Dinero';

  @override
  String get yogaTabRare => 'Raro';

  @override
  String get yogaSummaryTitle => 'Resumen de Yogas';

  @override
  String get yogaActiveYogas => 'Yogas Activos';

  @override
  String get yogaTotalYogas => 'Total de Yogas';

  @override
  String get yogaMostPowerful => 'Más Poderoso';

  @override
  String get yogaFortuneRating => 'Fortuna General';

  @override
  String get yogaBenefits => 'Beneficios';

  @override
  String get yogaSupportingPlanets => 'Planetas de Apoyo';

  @override
  String get yogaRanking => 'Top 5 Yogas Más Fuertes';

  @override
  String get yogaExplain => 'Explicar Mis Yogas';

  @override
  String get yogaExplainSubtitle => 'Cómo tus yogas te apoyan';

  @override
  String get yogaNoneActive => 'Aún no hay yogas activos';

  @override
  String get yogaNoneInCategory => 'No hay yogas en esta categoría';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return 'Tu carta lleva $count yogas activos — combinaciones planetarias favorables. Las combinaciones que involucran a $planets crean influencias especialmente útiles para el crecimiento y el éxito.';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '$name apoya $areas, y sus beneficios crecen cuando sus planetas están activos en dasha o tránsito.';
  }

  @override
  String get yogaAiGeneric =>
      'Este yoga es una combinación favorable en tu carta que fortalece sus áreas de vida relacionadas.';

  @override
  String get yogaExplainReassure =>
      'Los yogas son los puntos brillantes de tu carta — combinaciones planetarias favorables que trabajan a tu favor. Los más fuertes brindan beneficios duraderos, especialmente durante los períodos de los planetas que los forman.';

  @override
  String get doshSevere => 'Severo';

  @override
  String get doshVeryMild => 'Muy Leve';

  @override
  String get doshLow => 'Bajo';

  @override
  String get doshHigh => 'Alto';

  @override
  String get doshCritical => 'Crítico';

  @override
  String get doshSummaryTitle => 'Resumen de Doshas';

  @override
  String get doshActiveDoshas => 'Doshas Activos';

  @override
  String get doshTotalChecked => 'Total Verificado';

  @override
  String get doshOverallSeverity => 'Severidad General';

  @override
  String get doshNoneActive => 'Sin doshas activos — ¡una carta limpia!';

  @override
  String get doshCategory => 'Categoría';

  @override
  String get doshConfidence => 'Confianza';

  @override
  String get doshWhyFormed => 'Por Qué Se Formó';

  @override
  String get doshAffectedAreas => 'Áreas Afectadas';

  @override
  String get doshTimeline => 'Cronología';

  @override
  String get doshDefinition => 'Definición';

  @override
  String get doshFormationRule => 'Regla de Formación';

  @override
  String get doshSupportingPlanets => 'Planeta Relacionado';

  @override
  String get doshCancellation => 'Yogas de Cancelación';

  @override
  String get doshNoCancellation => 'Ninguno encontrado';

  @override
  String get doshAreaChildren => 'Hijos';

  @override
  String get doshAreaMind => 'Mente';

  @override
  String get remMantra => 'Mantra';

  @override
  String get remGemstone => 'Piedra Preciosa';

  @override
  String get remDonation => 'Donación';

  @override
  String get remTemple => 'Templo';

  @override
  String get remFasting => 'Ayuno';

  @override
  String get remLifestyle => 'Estilo de Vida';

  @override
  String get remLifestyleGeneric =>
      'Practica gratitud, disciplina y caridad relacionadas con este planeta, y mantén una buena conducta.';

  @override
  String get doshExplain => 'Explicar Mis Doshas';

  @override
  String get doshExplainSubtitle =>
      'Una mirada tranquila y práctica a tus doshas';

  @override
  String get doshExplainReassure =>
      'Los doshas son comunes — casi todas las cartas tienen algunos. Describen tendencias, no un destino fijo. La conciencia, la buena conducta y remedios simples reducen su efecto práctico, así que no hay necesidad de preocuparse.';

  @override
  String get doshAiGeneric =>
      'Este dosha describe una tendencia en tu carta. Su efecto práctico suele ser leve y puede equilibrarse con conciencia y remedios simples.';

  @override
  String doshHeroSummary(Object active, Object total) {
    return 'Tu carta muestra $active doshas activos de $total verificados. La mayoría son leves y solo unos pocos necesitan atención. Con comprensión y remedios simples, su efecto práctico puede aliviarse.';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return 'Este dosha influye principalmente en $areas. Durante los períodos de $planet su efecto puede sentirse más fuerte, y los remedios ayudan a equilibrarlo.';
  }

  @override
  String doshTimelineLine(Object planet) {
    return 'Su efecto se siente más durante la Mahadasha y Antardasha de $planet, y cuando $planet está activo en tránsito.';
  }

  @override
  String get sbLegendary => 'Legendario';

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
  String get sbSummary => 'Resumen de Fuerza Planetaria';

  @override
  String get sbAverageStrength => 'Fuerza Promedio';

  @override
  String get sbHighestRupa => 'Rupa Más Alto';

  @override
  String get sbRupa => 'Rupa';

  @override
  String get sbRanking => 'Clasificación de Planetas';

  @override
  String get sbRequired => 'Requerido';

  @override
  String get sbExcess => 'Exceso';

  @override
  String get sbDeficit => 'Déficit';

  @override
  String get sbTotalShadbala => 'Shadbala Total';

  @override
  String get sbExplain => 'Explicar Mi Fuerza Planetaria';

  @override
  String get sbExplainSubtitle =>
      'Un resumen simple de la fuerza de tus planetas';

  @override
  String get sbInfoTitle => 'Entendiendo el Shadbala';

  @override
  String get sbQWhatIs => '¿Qué es el Shadbala?';

  @override
  String get sbQRupas => '¿Qué son los Rupas?';

  @override
  String get sbQHowCalc => '¿Cómo se calcula la fuerza?';

  @override
  String get sbQHowUse => 'Cómo usar esto';

  @override
  String get sbWhyStrong => 'Por Qué Fuerte';

  @override
  String get sbWhyWeak => 'Por Qué Débil';

  @override
  String get sbDuringMahadasha => 'Durante la Mahadasha';

  @override
  String get sbEffects => 'Efectos';

  @override
  String get sbLifeAreas => 'Áreas de Vida';

  @override
  String get sbPlanetDetails => 'Detalles del Planeta';

  @override
  String get sbBodyWhatIs =>
      'El Shadbala (\'fuerza séxtuple\') mide cuánto poder tiene cada planeta para entregar sus resultados, sumando seis fuentes independientes de fuerza.';

  @override
  String get sbBodyRupas =>
      'La fuerza se mide en Rupas (1 Rupa = 60 Virupas). Cada planeta necesita una fuerza mínima en Rupas para considerarse fuerte; más Rupas significa que entrega sus resultados más plenamente.';

  @override
  String get sbBodyHowCalc =>
      'Se suman seis balas: Sthana (posicional), Dig (direccional), Kala (temporal), Chesta (de movimiento), Naisargika (natural) y Drik (de aspecto). El total se compara con el mínimo requerido del planeta para obtener un porcentaje.';

  @override
  String get sbBodyHowUse =>
      'Un planeta por encima del 100% entrega sus significaciones con comodidad; por debajo del 100% necesita apoyo. Favorece tus planetas más fuertes para asuntos importantes, y da a los más débiles remedios y paciencia.';

  @override
  String get sbRemedyStrong =>
      'Bien respaldado — no se necesita un remedio especial; puedes usar los períodos de este planeta con confianza.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '$strongP es tu planeta más fuerte, brindando excelente apoyo para $strongTrait. $weakP es el más débil y se beneficia más de remedios.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '$planet tiene $category Shadbala, por lo que sus $karakatva se apoyan en consecuencia.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return 'Más fuerte a través de $bala ($rupa rupas).';
  }

  @override
  String sbWeakLine(Object bala) {
    return 'Más débil en $bala, lo que reduce el total.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return 'Durante la Mahadasha de $planet, sus $karak salen a relucir.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'Con un Shadbala fuerte, $karak se ven naturalmente apoyados.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'Con un Shadbala moderado, $karak pueden necesitar esfuerzo consciente.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return 'Fortalece a $planet a través de su mantra, piedra preciosa o caridad, y actúa con paciencia durante sus períodos.';
  }

  @override
  String get bhOverview => 'Resumen';

  @override
  String get bhDetailed => 'Detallado';

  @override
  String get bhavaHouses => 'Casas';

  @override
  String get bhStrengthOverview => 'Resumen de Fuerza de las Casas';

  @override
  String get bhOverallAverage => 'Promedio General de Casas';

  @override
  String get bhStrongestHouse => 'Casa Más Fuerte';

  @override
  String get bhWeakestHouse => 'Casa Más Débil';

  @override
  String get bhBestArea => 'Mejor Área de Vida';

  @override
  String get bhNeedsAttention => 'Necesita Atención';

  @override
  String get bhSavContribution => 'Contribución SAV';

  @override
  String get bhLordCondition => 'Condición del Señor de la Casa';

  @override
  String get bhBenefic => 'Influencia Benéfica';

  @override
  String get bhMalefic => 'Influencia Maléfica';

  @override
  String get bhStrengthReasons => 'Por Qué Este Puntaje';

  @override
  String get bhGoodEffects => 'Efectos Positivos';

  @override
  String get bhChallenges => 'Desafíos';

  @override
  String get bhRemedies => 'Remedios';

  @override
  String get bhRanking => 'Clasificación de Casas';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'Explicar Mis Casas';

  @override
  String get bhExplainSubtitle => 'Un resumen simple de tus 12 casas';

  @override
  String bhHeroSummary(
    Object s1,
    Object s2,
    Object strongArea,
    Object weakArea,
  ) {
    return 'Tus casas más fuertes son $s1 y $s2. $strongArea es naturalmente fuerte, mientras que $weakArea necesita más esfuerzo.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'Su señor $lord está ubicado como $relation.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'Esta casa lleva $sav puntos benéficos (SAV); sus ocupantes y aspectos dan forma al resto del puntaje.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'Cuando es fuerte, apoya $meaning.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'Cuando es débil, $meaning puede necesitar esfuerzo y cuidado extra.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'Fortalece a su señor $lord y honra los asuntos de esta casa para elevarla.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'Tu $house es $strengthWord. Rige $meaning.';
  }

  @override
  String get kunNavamsa => 'Navamsa (D9)';

  @override
  String get kunD10 => 'Dasamsa (D10)';

  @override
  String get kunPlacement => 'Ubicación Planetaria';

  @override
  String get kunHousesTitle => 'Detalles de las Casas';

  @override
  String get kunPlanet => 'Planeta';

  @override
  String get kunNakshatra => 'Nakshatra';

  @override
  String get kunPada => 'Pada';

  @override
  String get kunLord => 'Señor';

  @override
  String get kunExplain => 'Explicar Mi Carta';

  @override
  String get kunExplainSubtitle => 'Un resumen simple de tu carta';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return 'La casa $ordinal rige $meaning.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return '$planets ubicados aquí dan forma a sus resultados.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'Tu ascendente es $asc, dando forma a tu perspectiva y a cómo los demás te ven al principio.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'Tu mente y emociones siguen a la Luna en $moon.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '$planet es tu planeta más fuerte — un área natural de facilidad y apoyo.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '$planet es tu planeta más puesto a prueba — la paciencia y el esfuerzo dan fruto aquí.';
  }

  @override
  String get plNature => 'Naturaleza';

  @override
  String get plElement => 'Elemento';

  @override
  String get plGender => 'Género';

  @override
  String get plKarakatva => 'Karakatva';

  @override
  String get plLordship => 'Señorío';

  @override
  String get plStrength => 'Fuerza';

  @override
  String get plAspectsGiven => 'Aspectos Dados';

  @override
  String get plAspectsReceived => 'Aspectos Recibidos';

  @override
  String get plConjunction => 'Conjunción';

  @override
  String get plHouseMeaning => 'Significado de la Casa';

  @override
  String get plNakshatraMeaning => 'Significado del Nakshatra';

  @override
  String get plAiInterpretation => 'Interpretación de IA';

  @override
  String get plSearchHint => 'Buscar cualquier planeta';

  @override
  String get plNoResults => 'No se encontraron planetas';

  @override
  String get plBenefic => 'Benéfico';

  @override
  String get plMalefic => 'Maléfico';

  @override
  String get plMale => 'Masculino';

  @override
  String get plFemale => 'Femenino';

  @override
  String get plNeutralGender => 'Neutral';

  @override
  String get plOwnSign => 'Signo Propio';

  @override
  String get plFriend => 'Signo Amigo';

  @override
  String get plEnemy => 'Signo Enemigo';

  @override
  String get plNeutral => 'Neutral';

  @override
  String get sumEther => 'Éter';

  @override
  String plLordOfHouses(Object houses) {
    return 'Señor de la(s) casa(s) $houses';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return 'Regido por $nakLord, aportando $trait.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '$planet se encuentra en $sign, en la casa $house.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'Sus significaciones principales — $karak — están bien apoyadas aquí.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'Sus significaciones principales — $karak — pueden necesitar esfuerzo consciente aquí.';
  }

  @override
  String plAiExalted(Object planet) {
    return '$planet está exaltado, dando sus mejores resultados.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '$planet está debilitado y necesita apoyo para entregar sus resultados.';
  }

  @override
  String plAiCombust(Object planet) {
    return '$planet está combusto, por lo que actúa con menos apertura bajo el resplandor del Sol.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '$planet es vargottama — una ubicación fuerte que se repite en el navamsa.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '$planet está retrógrado, volviendo su energía hacia adentro e intensificándola.';
  }

  @override
  String get plHouse1 => 'el yo, el cuerpo, la personalidad y la vitalidad';

  @override
  String get plHouse2 => 'la riqueza, la familia, el habla y la comida';

  @override
  String get plHouse3 =>
      'el coraje, los hermanos, la comunicación y los viajes cortos';

  @override
  String get plHouse4 =>
      'el hogar, la madre, la comodidad, la propiedad y la paz interior';

  @override
  String get plHouse5 =>
      'los hijos, la creatividad, la inteligencia, el romance y los méritos pasados';

  @override
  String get plHouse6 =>
      'la salud, los enemigos, las deudas, el servicio y el trabajo diario';

  @override
  String get plHouse7 =>
      'el matrimonio, las asociaciones y las relaciones comerciales';

  @override
  String get plHouse8 =>
      'la longevidad, la transformación, los secretos y la herencia';

  @override
  String get plHouse9 =>
      'la fortuna, el dharma, los estudios superiores, el gurú y el padre';

  @override
  String get plHouse10 =>
      'la carrera, el estatus, la autoridad y el karma público';

  @override
  String get plHouse11 =>
      'las ganancias, los ingresos, los amigos, la red de contactos y los deseos cumplidos';

  @override
  String get plHouse12 =>
      'la pérdida, los gastos, las tierras extranjeras, la espiritualidad y la liberación';

  @override
  String get sumVeryStrong => 'Muy Fuerte';

  @override
  String get sumStrong => 'Fuerte';

  @override
  String get sumAverage => 'Promedio';

  @override
  String get sumWeak => 'Débil';

  @override
  String get sumNeedsAttention => 'Necesita Atención';

  @override
  String get sumFire => 'Fuego';

  @override
  String get sumEarth => 'Tierra';

  @override
  String get sumAir => 'Aire';

  @override
  String get sumWater => 'Agua';

  @override
  String get sumMovable => 'Móvil';

  @override
  String get sumFixed => 'Fijo';

  @override
  String get sumDual => 'Dual';

  @override
  String get sumDirEast => 'Este';

  @override
  String get sumDirWest => 'Oeste';

  @override
  String get sumDirNorth => 'Norte';

  @override
  String get sumDirSouth => 'Sur';

  @override
  String get sumDirNE => 'Noreste';

  @override
  String get sumDirNW => 'Noroeste';

  @override
  String get sumDirSE => 'Sureste';

  @override
  String get sumDirSW => 'Suroeste';

  @override
  String get sumSnapshotTitle => 'Tu Resumen Astrológico';

  @override
  String get sumMahadasha => 'Mahadasha';

  @override
  String get sumAntardasha => 'Antardasha';

  @override
  String get sumNakshatra => 'Janma Nakshatra';

  @override
  String get sumElement => 'Elemento';

  @override
  String get sumModality => 'Modalidad';

  @override
  String get sumLuckyDirection => 'Dirección de la Suerte';

  @override
  String get sumHighlights => 'Aspectos Destacados Importantes';

  @override
  String get sumStrongPlanet => 'Planeta Más Fuerte';

  @override
  String get sumWeakPlanet => 'Planeta Más Débil';

  @override
  String get sumYogas => 'Yogas';

  @override
  String get sumDoshas => 'Doshas';

  @override
  String get sumRetrograde => 'Retrógrado';

  @override
  String get sumCombust => 'Combusto';

  @override
  String get sumExalted => 'Exaltado';

  @override
  String get sumDebilitated => 'Debilitado';

  @override
  String get sumVargottama => 'Vargottama';

  @override
  String get sumQuickInsights => 'Perspectivas Rápidas';

  @override
  String get sumSpirituality => 'Espiritualidad';

  @override
  String get sumTimezone => 'Zona Horaria';

  @override
  String get sumAyanamsa => 'Ayanamsa';

  @override
  String get sumCalendarType => 'Calendario';

  @override
  String get sumCopied => 'Copiado al portapapeles';

  @override
  String get sumNatureFire =>
      'Tienes una naturaleza audaz, enérgica y pionera que lidera desde el frente.';

  @override
  String get sumNatureEarth =>
      'Tienes una naturaleza práctica, con los pies en la tierra y disciplinada que construye resultados duraderos.';

  @override
  String get sumNatureAir =>
      'Tienes una naturaleza curiosa, comunicativa e intelectual que prospera con ideas nuevas.';

  @override
  String get sumNatureWater =>
      'Tienes una naturaleza intuitiva, emocional y empática con una profunda sensibilidad interior.';

  @override
  String get sumGradePhraseExcellent =>
      'Fuertemente respaldado — resultados favorables son probables con esfuerzo constante.';

  @override
  String get sumGradePhraseGood =>
      'Bien respaldado — generalmente positivo con un poco de cuidado.';

  @override
  String get sumGradePhraseAverage =>
      'Apoyo mixto — los resultados dependen del esfuerzo y el timing.';

  @override
  String get sumGradePhraseWeak =>
      'Necesita atención — la paciencia y los remedios ayudan aquí.';

  @override
  String get kDefCombust =>
      'Un planeta demasiado cerca del Sol, por lo que su energía está \'quemada\' y debilitada.';

  @override
  String get kDefRetrograde =>
      'Un planeta que parece moverse hacia atrás; sus efectos se vuelven hacia adentro y se intensifican.';

  @override
  String get kDefNakshatra =>
      'Una de las 27 mansiones lunares por las que transitan la Luna y los planetas.';

  @override
  String get kDefVargottama =>
      'Un planeta en el mismo signo tanto en la carta natal (D1) como en el navamsa (D9) — una marca de fuerza.';

  @override
  String get kDefOwnSign =>
      'Un planeta ubicado en un signo que rige, donde se siente en casa y da resultados estables.';

  @override
  String get kDefExalted =>
      'Un planeta en su signo de mayor fuerza, dando sus mejores resultados.';

  @override
  String get kDefDebilitated =>
      'Un planeta en su signo más débil, donde le cuesta dar resultados.';

  @override
  String get kDefMooltrikona =>
      'Una porción especial del signo propio de un planeta donde es especialmente poderoso.';

  @override
  String get kDefAscendant =>
      'El signo que asciende en el horizonte este en el momento del nacimiento — el Lagna, el fundamento de la carta.';

  @override
  String get kDefMahadasha =>
      'El período planetario mayor que colorea un extenso tramo de la vida.';

  @override
  String get kDefAntardasha =>
      'Un subperíodo dentro de una Mahadasha que afina sus resultados.';

  @override
  String get kDefPada =>
      'Uno de los cuatro cuartos de un nakshatra que ocupa un planeta.';

  @override
  String get aspGivesAspectTo => 'Da Aspecto A';

  @override
  String get aspReceivesAspectFrom => 'Recibe Aspecto De';

  @override
  String get aspInfluences => 'Influencias';

  @override
  String get aspNoInfluence => 'Sin Influencia';

  @override
  String get aspNoAspect => 'Sin Aspecto';

  @override
  String get aspPresent => 'Presente';

  @override
  String get aspAbsent => 'Ausente';

  @override
  String get aspNotPresent => 'No Presente';

  @override
  String get aspSpecialAspect => 'Aspecto Especial';

  @override
  String get aspAspectWord => 'Aspecto';

  @override
  String get aspTotalGiven => 'Aspectos Dados';

  @override
  String get aspTotalReceived => 'Aspectos Recibidos';

  @override
  String get aspStrongestInfluence => 'Influencia Más Fuerte';

  @override
  String get aspMedium => 'Medio';

  @override
  String get aspAspectPresent => 'Aspecto Presente';

  @override
  String get aspReason => 'Razón';

  @override
  String get aspBoth => 'Ambos';

  @override
  String get aspTargetHouse => 'Casa Objetivo';

  @override
  String get aspTargetSign => 'Signo Objetivo';

  @override
  String get aspLagnaReceives => 'El Lagna Recibe Aspecto De';

  @override
  String get aspNoAspectFrom => 'Sin Aspecto De';

  @override
  String get aspPlanetToPlanet => 'Planeta a Planeta';

  @override
  String get aspSignToSign => 'Signo a Signo';

  @override
  String get aspCombinedAspect => 'Aspecto Combinado';

  @override
  String get aspGrahaAspect => 'Aspecto Graha';

  @override
  String get aspRashiAspect => 'Aspecto Rashi';

  @override
  String get aspInfoTitle => 'Entendiendo los Aspectos (Drishti)';

  @override
  String get aspQGraha => '¿Qué es Graha Drishti?';

  @override
  String get aspQRashi => '¿Qué es Rashi Drishti?';

  @override
  String get aspQDiff => 'Diferencia entre ambos';

  @override
  String get aspQPredict => 'Cómo afectan los aspectos a la predicción';

  @override
  String get aspGrahaBody =>
      'Graha Drishti es el aspecto que un planeta proyecta desde su posición. Todo planeta aspecta plenamente la casa/planeta número 7 desde sí mismo (una influencia directa, cara a cara). Además, Marte aspecta la 4ª y la 8ª, Júpiter la 5ª y la 9ª, y Saturno la 3ª y la 10ª. A Rahu y Ketu se les suele dar la 5ª, 7ª y 9ª. El aspecto de un planeta colorea al planeta o casa sobre el que cae con su propia naturaleza.';

  @override
  String get aspRashiBody =>
      'Rashi Drishti es un aspecto de signo a signo de la astrología Jaimini, independiente de qué planetas se encuentren allí. Los signos móviles aspectan a los signos fijos (excepto el adyacente), los signos fijos aspectan a los móviles (excepto el adyacente), y los signos duales aspectan a los otros signos duales. Se usa principalmente en la predicción Jaimini y para juzgar relaciones entre casas.';

  @override
  String get aspDiffBody =>
      'Graha Drishti es proyectado por un planeta y depende de dónde se encuentre ese planeta. Rashi Drishti pertenece al signo mismo y se aplica a lo que esté ubicado en él. Graha Drishti es direccional (el planeta A ve al planeta B), mientras que Rashi Drishti suele ser mutuo entre los signos. Cuando ambos apuntan al mismo objetivo, la influencia es especialmente fuerte.';

  @override
  String get aspPredictBody =>
      'Un aspecto muestra dónde extiende un planeta su influencia más allá de su propia casa. Un aspecto benéfico (Júpiter, Venus, Luna/Mercurio bien ubicados) apoya y protege el objetivo; un aspecto maléfico (Saturno, Marte, Sol, Rahu, Ketu) puede presionar, retrasar o desafiarlo. Leer qué planetas aspectan una casa o planeta explica por qué los resultados aparecen como lo hacen.';

  @override
  String get aspTraitSun => 'autoridad, liderazgo y vitalidad';

  @override
  String get aspTraitMoon => 'profundidad emocional, comodidad e intuición';

  @override
  String get aspTraitMars => 'energía, coraje e impulso';

  @override
  String get aspTraitMercury => 'comunicación, intelecto y adaptabilidad';

  @override
  String get aspTraitJupiter => 'sabiduría, crecimiento y buena fortuna';

  @override
  String get aspTraitVenus => 'amor, armonía y comodidades';

  @override
  String get aspTraitSaturn =>
      'disciplina, responsabilidad y éxito paciente, a veces retrasado';

  @override
  String get aspTraitRahu => 'ambición, intensidad y giros poco convencionales';

  @override
  String get aspTraitKetu => 'desapego, espiritualidad y cambio repentino';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '$planet está influyendo en $targets. Esto puede traer $trait a las áreas representadas por estos planetas.';
  }

  @override
  String aspAiNone(Object planet) {
    return '$planet no proyecta un aspecto especial sobre ningún otro planeta aquí; su influencia actúa principalmente a través de su propio signo y casa.';
  }

  @override
  String get avSummaryTitle => 'Resumen de Ashtakavarga';

  @override
  String get avOverallScore => 'Puntaje SAV General';

  @override
  String get avOverallRating => 'Calificación General';

  @override
  String get avStrongestSigns => 'Signos Más Fuertes';

  @override
  String get avWeakestSigns => 'Signos Más Débiles';

  @override
  String get avScore => 'Puntaje';

  @override
  String get avMeaning => 'Significado';

  @override
  String get avGrid => 'Cuadrícula';

  @override
  String get avList => 'Lista';

  @override
  String get avOverallScoreShort => 'Puntaje General';

  @override
  String get avNatalSignScore => 'Puntaje del Signo Natal';

  @override
  String get avBestSigns => 'Mejores Signos';

  @override
  String get avWeakSigns => 'Signos Débiles';

  @override
  String get avAiInterpretation => 'Interpretación de IA';

  @override
  String get avVeryGood => 'Muy Bueno';

  @override
  String get avVeryWeak => 'Muy Débil';

  @override
  String get avTotalSav => 'SAV Total';

  @override
  String get avPlanetContributions => 'Contribuciones Planetarias';

  @override
  String get avFinance => 'Finanzas';

  @override
  String get avOverallStrength => 'Fuerza General';

  @override
  String get avWhatDoesThisMean => '¿Qué significa esto?';

  @override
  String get avSimple => 'Simple';

  @override
  String get avAdvanced => 'Avanzado';

  @override
  String get avInfoTitle => 'Entendiendo el Ashtakavarga';

  @override
  String get avStrong => 'Fuerte';

  @override
  String get avModerate => 'Moderado';

  @override
  String get avQWhatIsAv => '¿Qué es el Ashtakavarga?';

  @override
  String get avQWhatIsSav => '¿Qué es el SAV?';

  @override
  String get avQWhatIsBav => '¿Qué es el BAV?';

  @override
  String get avQHowToRead => 'Cómo leer estos puntajes';

  @override
  String get avQSavVsBav => 'SAV vs BAV';

  @override
  String get avABody =>
      'El Ashtakavarga es un sistema de fuerza basado en puntos en la astrología védica. Cada planeta otorga puntos benéficos (bindus, también llamados rekhas) a los doce signos según su posición. Más puntos en un signo significa que esa área de vida recibe un apoyo más fluido durante los períodos planetarios y tránsitos relacionados.';

  @override
  String get avSavBody =>
      'El SAV (Sarva Ashtakavarga) suma los puntos de los siete planetas para cada signo. Da un único puntaje de fuerza por signo, para que puedas ver rápidamente qué signos — y las casas en las que caen — están mejor apoyados en tu carta.';

  @override
  String get avBavBody =>
      'El BAV (Bhinna Ashtakavarga) muestra los puntos de un solo planeta a lo largo de los doce signos. Te dice qué signos apoya más un planeta específico, lo cual importa cuando la dasha o tránsito de ese planeta está activo.';

  @override
  String get avHowToReadBody =>
      'Los números más altos son mejores. Para el SAV, un signo promedio puntúa alrededor de 28 puntos — por encima de 30 es fuerte y por debajo de 25 necesita cuidado. Para el BAV, cada signo va de 0 a 8, siendo 4 el promedio. Favorece tus signos más fuertes para acciones importantes, y mantén paciencia y disciplina con los más débiles.';

  @override
  String get avSavVsBavBody =>
      'El SAV es el total combinado de todos los planetas y muestra la fuerza general de un signo. El BAV es la contribución de un solo planeta y muestra qué planeta apoya ese signo. Usa el SAV para el panorama general, y el BAV para entender qué planeta impulsa la fuerza de un signo.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'Tu carta es más fuerte en $s1, $s2 y $s3. Estos signos brindan mejor apoyo durante períodos planetarios y tránsitos. $weak actualmente tiene el menor apoyo, así que la paciencia y la disciplina ayudan en asuntos relacionados con él.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '$planet se desempeña con más fuerza a través de $s1 y $s2. Los asuntos regidos por $planet tienden a mejorar cuando estos signos se activan.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'Tus signos más fuertes son $s1 y $s2 — favorece los comienzos importantes cuando los planetas transiten por ellos.';
  }

  @override
  String avInsightWeak(Object s1) {
    return '$s1 tiene el menor apoyo — avanza con cuidado y evita comprometerte en exceso en sus asuntos.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '$planet lleva la mayor cantidad de puntos, por lo que sus significaciones están bien apoyadas en tu vida.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '$planet lleva la menor cantidad de puntos y se beneficia más de remedios y esfuerzo consciente.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'Los signos que puntúan por encima de tu promedio de $avg puntos tienden a dar resultados más fluidos y confiables.';
  }

  @override
  String get fcKey => 'Clave';

  @override
  String get fcActions => 'Acciones';

  @override
  String get fcCautions => 'Precauciones';

  @override
  String get fc12House => '12 Casas';

  @override
  String get fcProbabilities => 'Probabilidades';

  @override
  String get fcHousesCaps => 'CASAS';

  @override
  String get fcCritical => 'Crítico';

  @override
  String get fcFlags => 'Alertas';

  @override
  String get fcAnalysis => 'Análisis';

  @override
  String get fcConfidence => 'Confianza';

  @override
  String get fcQualityCaps => 'CALIDAD';

  @override
  String get fcIncomeVs => 'Ingresos vs';

  @override
  String get fcExpense => 'Gastos';

  @override
  String get fcFinance => 'FINANZAS';

  @override
  String get fcNetBalance => 'Balance Neto';

  @override
  String get fcSignature => 'Firma';

  @override
  String get fcBestTimeForIncome => 'Mejor Momento para Ingresos';

  @override
  String get fcExpenseCaution => 'Precaución de Gastos';

  @override
  String get fcIncomeCaps => 'INGRESOS';

  @override
  String get fcExpenseCaps => 'GASTOS';

  @override
  String get fcRelationships => 'Relaciones';

  @override
  String get fcAreasCaps => 'ÁREAS';

  @override
  String get fcBestForMeetings => 'Mejor Para Reuniones';

  @override
  String get fcOpportunitiesVs => 'Oportunidades vs';

  @override
  String get fcRisks => 'Riesgos';

  @override
  String get fcOutlook => 'PANORAMA';

  @override
  String get fcAction => 'Acción';

  @override
  String get fcProtect => 'Proteger';

  @override
  String get fcOpportunityCaps => 'OPORTUNIDAD';

  @override
  String get fcRiskCaps => 'RIESGO';

  @override
  String get fcTopOpportunities => 'PRINCIPALES OPORTUNIDADES';

  @override
  String get fcTopRisks => 'PRINCIPALES RIESGOS';

  @override
  String get fcTiming => 'Timing';

  @override
  String get fcWindows => 'Ventanas';

  @override
  String get fcSlotsCaps => 'INTERVALOS';

  @override
  String get fcBestWindows => 'MEJORES VENTANAS';

  @override
  String get fcWorstWindows => 'PEORES VENTANAS';

  @override
  String get fcAvoid => 'Evitar';

  @override
  String get fcHouse => 'Casa';

  @override
  String get fcFailed => 'Fallido';

  @override
  String get lifeCareer => 'Carrera';

  @override
  String get lifeHealth => 'Salud';

  @override
  String get lifeWealth => 'Riqueza';

  @override
  String get lifeFamily => 'Familia';

  @override
  String get lifeMind => 'Mente';

  @override
  String get lifeEgo => 'Ego';

  @override
  String get lifeAggression => 'Agresión';

  @override
  String get lifeConflict => 'Conflicto';

  @override
  String get rashiElement => 'Elemento';

  @override
  String get rashiQuality => 'Cualidad';

  @override
  String get rashiLuckyColor => 'Color de la Suerte';

  @override
  String get rashiLuckyDay => 'Día de la Suerte';

  @override
  String get rashiLuckyNumber => 'Número de la Suerte';

  @override
  String get rashiGemstone => 'Piedra Preciosa';

  @override
  String get rashiBody => 'Cuerpo';

  @override
  String get gocharTodaysTransitChart => 'Carta de Tránsito de Hoy';

  @override
  String get gocharTransit => 'Tránsito';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get thisMonth => 'Este Mes';

  @override
  String get best => 'Mejor';

  @override
  String get worst => 'Peor';

  @override
  String get avg => 'prom';

  @override
  String get favorableLoveWindowsLabel => 'Ventanas Amorosas Favorables';

  @override
  String get lordLabel => 'Señor';

  @override
  String get lordPlacementLabel => 'Ubicación del Señor';

  @override
  String get lordDignityLabel => 'Dignidad del Señor';

  @override
  String get categoriesSuffix => 'Categorías';

  @override
  String get coreBlockerLabel => 'BLOQUEO PRINCIPAL';

  @override
  String get coreGiftLabel => '✦ DON PRINCIPAL';

  @override
  String get coreThemeLabel => '● TEMA PRINCIPAL';

  @override
  String dominantLabel(Object value) {
    return 'Dominante: $value';
  }

  @override
  String get karakasSuffix => 'Karakas';

  @override
  String get protectiveLabel => 'PROTECTOR';

  @override
  String secondaryLabel(Object value) {
    return ' · Secundario: $value';
  }

  @override
  String get tagCore => 'PRINCIPAL';

  @override
  String get debtScoresHeader => '📉 PUNTAJES DE DEUDA';

  @override
  String get debtCurrentLoadStat => 'CARGA DE\nDEUDA ACTUAL';

  @override
  String get debtRecoveryCapacityStat => 'CAPACIDAD DE\nRECUPERACIÓN';

  @override
  String get debtIntensityStat => 'INTENSIDAD';

  @override
  String get debtDefaultRiskStat => 'RIESGO DE INCUMPLIMIENTO';

  @override
  String get debtProfileTitle => 'Perfil de Deuda';

  @override
  String get debtKarmaLabel => 'KARMA';

  @override
  String get debtPersonalityLabel => 'PERSONALIDAD';

  @override
  String get debtPhaseLabel => 'FASE';

  @override
  String get debtPrimaryCategoryLabel => 'CATEGORÍA PRINCIPAL';

  @override
  String get debtWord => 'Deuda';

  @override
  String get debtYogasTitle => 'Yogas de Deuda';

  @override
  String get debtCreatingLabel => 'GENERADOR DE DEUDA';

  @override
  String get debtClearingLabel => 'LIQUIDADOR DE DEUDA';

  @override
  String get yearlyDebtTitle => 'Deuda Anual';

  @override
  String get debtRepaymentTitle => 'Reembolso';

  @override
  String get debtDangerPeriodsTitle => 'Períodos de Peligro';

  @override
  String get debtDefaultPctStat => '% DE INCUMPLIMIENTO';

  @override
  String get debtBankruptcyPctStat => '% DE BANCARROTA';

  @override
  String get debtChronicPctStat => '% CRÓNICO';

  @override
  String get debtResilienceStat => 'RESILIENCIA';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'Recuperación: $pct% · Cronología: $years años';
  }

  @override
  String get debtFreeWindowLabel => '🎯 VENTANA LIBRE DE DEUDA';

  @override
  String debtFreeYear(Object year) {
    return 'Año $year';
  }

  @override
  String get legalScoresHeader => '⚖️ PUNTAJES LEGALES';

  @override
  String get legalVulnerabilityStat => 'VULNERABILIDAD\nLEGAL';

  @override
  String get legalVictoryPotentialStat => 'POTENCIAL DE\nVICTORIA';

  @override
  String get legalConflictStat => 'CONFLICTO';

  @override
  String get legalResolutionStat => 'RESOLUCIÓN';

  @override
  String get legalProfileTitle => 'Perfil Legal';

  @override
  String get legalKarmaTypeLabel => 'TIPO DE KARMA';

  @override
  String get legalConflictStyleLabel => 'ESTILO DE CONFLICTO';

  @override
  String get legalStrategyLabel => 'ESTRATEGIA';

  @override
  String get legalCaseDurationLabel => 'DURACIÓN DEL CASO';

  @override
  String get legalCurrentStatusLabel => 'ESTADO ACTUAL';

  @override
  String get legalWord => 'Legal';

  @override
  String get legalYogasTitle => 'Yogas Legales';

  @override
  String get legalDisputePressureLabel => 'PRESIÓN DE DISPUTA';

  @override
  String get legalProtectionLabel => 'PROTECCIÓN LEGAL';

  @override
  String get legalStressTrendTitle => 'Estrés Legal';

  @override
  String get legalVisibleEnemiesStat => 'ENEMIGOS VISIBLES';

  @override
  String get legalHiddenEnemiesStat => 'ENEMIGOS OCULTOS';

  @override
  String get legalCriminalRiskStat => 'RIESGO CRIMINAL';

  @override
  String get legalFalseAccusationStat => 'ACUSACIÓN FALSA';

  @override
  String get legalContractKarmaTitle => 'Karma Contractual';

  @override
  String get legalDocumentationLabel => 'DOCUMENTACIÓN';

  @override
  String get legalFinePrintAwareLabel => 'ATENTO A LA LETRA PEQUEÑA';

  @override
  String get legalNegotiationSkillLabel => 'HABILIDAD DE NEGOCIACIÓN';

  @override
  String get legalSignatureCautionLabel => 'PRECAUCIÓN AL FIRMAR';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'Resiliencia: $pct/100';
  }

  @override
  String get legalVictoryWord => 'Victoria';

  @override
  String get legalAnalysisSuffix => 'Análisis';

  @override
  String get legalAsPlaintiff => 'COMO DEMANDANTE';

  @override
  String get legalAsDefendant => 'COMO DEMANDADO';

  @override
  String get legalWinProbability => 'PROBABILIDAD DE GANAR';

  @override
  String get legalDisputeWord => 'Disputa';

  @override
  String get lifepathScoresHeader => '🌟 PUNTAJES DE CAMINO DE VIDA';

  @override
  String get lifepathDharmaClarityStat => 'CLARIDAD DE\nDHARMA';

  @override
  String get lifepathFortuneBaselineStat => 'BASE DE\nFORTUNA';

  @override
  String get lifepathCoherenceStat => 'COHERENCIA DE\nCAMINO DE VIDA';

  @override
  String get lifepathKarmaStat => 'KARMA';

  @override
  String get lifepathSpiritualStat => 'ESPIRITUAL';

  @override
  String get lifepathFameStat => 'FAMA';

  @override
  String get lifepathSoulContractTitle => 'Contrato del Alma';

  @override
  String get lifepathAtmakarakaLabel => 'ATMAKARAKA';

  @override
  String get lifepathAkFocusLabel => 'ENFOQUE DE AK';

  @override
  String get lifepathSoulPurposeLabel => 'PROPÓSITO DEL ALMA';

  @override
  String get lifepathLifeChapterLabel => 'CAPÍTULO DE VIDA';

  @override
  String get lifepathPrimaryDomainLabel => 'DOMINIO PRINCIPAL';

  @override
  String get lifepathLeadershipStat => 'LIDERAZGO';

  @override
  String get lifepathWisdomTeachStat => 'SABIDURÍA/ENSEÑANZA';

  @override
  String get lifepathServiceStat => 'SERVICIO';

  @override
  String get lifepathHealingStat => 'SANACIÓN';

  @override
  String get lifepathFortuneYogasTitle => 'Yogas de Fortuna';

  @override
  String get lifepathLuckBlocksLabel => 'BLOQUEOS DE SUERTE';

  @override
  String get lifepathFortuneBoostersLabel => 'POTENCIADORES DE FORTUNA';

  @override
  String get lifepathFortuneTrendTitle => 'Tendencia de Fortuna';

  @override
  String get lifepathGoldenWindowsTitle => 'Ventanas Doradas ★';

  @override
  String get lifepathTransformationTitle => 'Transformación';

  @override
  String get lifepathMilestonesTitle => 'Hitos de Vida';

  @override
  String get lifepathKarmicLessonsTitle => 'Lecciones Kármicas';

  @override
  String get lifepathRahuGrowthLabel => 'CRECIMIENTO DE RAHU';

  @override
  String get lifepathKetuSurrenderLabel => 'ENTREGA DE KETU';

  @override
  String get lifepathSaturnLessonLabel => 'LECCIÓN DE SATURNO';

  @override
  String get lifepathLifeDifficultyLabel => 'DIFICULTAD DE VIDA';

  @override
  String get lifepathSoulExperienceTitle => '★ EL ALMA VINO A EXPERIMENTAR';

  @override
  String get lifepathBlessingsTitle => '● BENDICIONES';

  @override
  String get lifepathLifeWord => 'Vida';

  @override
  String get lifepathArchetypeSuffix => 'Arquetipo';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'Realización: $pct%';
  }

  @override
  String get lifepathDestinyVsWord => 'Destino vs';

  @override
  String get lifepathFreeWillSuffix => 'Libre Albedrío';

  @override
  String get lifepathDestinyStat => 'DESTINO';

  @override
  String get lifepathFreeWillStat => 'LIBRE ALBEDRÍO';

  @override
  String get pastlifeScoresHeader => '🔮 PUNTAJES DE VIDA PASADA';

  @override
  String get pastlifeSignatureStrengthStat => 'FUERZA DE\nLA FIRMA';

  @override
  String get pastlifeCarryForwardStat => 'CONTINUIDAD';

  @override
  String get pastlifeMasteryPreservedStat => 'DOMINIO\nPRESERVADO';

  @override
  String get pastlifeUnfinishedStat => 'INCONCLUSO';

  @override
  String get pastlifeKarmicDebtStat => 'DEUDA KÁRMICA';

  @override
  String get pastlifeProfileTitle => 'Perfil de Vida Pasada';

  @override
  String get pastlifeThemeLabel => 'TEMA';

  @override
  String get pastlifeProfessionLabel => 'PROFESIÓN';

  @override
  String get pastlifeSocialStandingLabel => 'POSICIÓN SOCIAL';

  @override
  String get pastlifeRegionLabel => 'REGIÓN';

  @override
  String get pastlifeSpiritualLevelLabel => 'NIVEL ESPIRITUAL';

  @override
  String get pastlifeGenderLabel => 'GÉNERO';

  @override
  String get pastlifeWealthLevelLabel => 'NIVEL DE RIQUEZA';

  @override
  String get pastlifeFamilyRoleLabel => 'ROL FAMILIAR';

  @override
  String get pastlifeSkillsCarriedTitle =>
      '★ HABILIDADES LLEVADAS HACIA ADELANTE';

  @override
  String get pastlifeNaturalAttractionsTitle => '● ATRACCIONES NATURALES';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ MIEDOS INEXPLICABLES';

  @override
  String get pastlifeMagneticPullsTitle => '→ ATRACCIONES MAGNÉTICAS';

  @override
  String get pastlifeRelationshipStat => 'RELACIÓN';

  @override
  String get pastlifeFinancialStat => 'FINANCIERO';

  @override
  String get pastlifeServiceStat => 'SERVICIO';

  @override
  String get pastlifeDharmicStat => 'DHÁRMICO';

  @override
  String get pastlifeOnRelationsStat => 'EN RELACIONES';

  @override
  String get pastlifeOnCareerStat => 'EN LA CARRERA';

  @override
  String get pastlifeOnHealthStat => 'EN LA SALUD';

  @override
  String get pastlifeOnSpiritualStat => 'EN LO ESPIRITUAL';

  @override
  String get pastlifeKarmicResolutionTitle => 'Resolución Kármica';

  @override
  String get pastlifePrimaryPathLabel => 'CAMINO PRINCIPAL';

  @override
  String get pastlifeSecondaryPathLabel => 'CAMINO SECUNDARIO';

  @override
  String get pastlifeClearingProgressLabel => 'PROGRESO DE LIMPIEZA';

  @override
  String get pastlifeRemainingWorkLabel => 'TRABAJO RESTANTE';

  @override
  String get pastlifeDebtTimelineLabel => 'CRONOLOGÍA DE DEUDA';

  @override
  String get pastlifeMemoryAccessStat => 'ACCESO A LA MEMORIA';

  @override
  String get pastlifeDreamVisitsStat => 'VISITAS EN SUEÑOS';

  @override
  String get pastlifeDejaVuStat => 'DÉJÀ VU';

  @override
  String get pastlifeRegressionFitStat => 'AFINIDAD DE REGRESIÓN';

  @override
  String get pastlifeActivationTitle => 'Activación de Vida Pasada';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'Madurez: $maturity · Estado: $status';
  }

  @override
  String get pastlifeKetuWord => 'Ketu';

  @override
  String get pastlifePastMasterySuffix => 'Dominio Pasado';

  @override
  String get pastlifeKetuMasteredLabel => 'KETU · LO QUE DOMINASTE';

  @override
  String get pastlifeRahuWord => 'Rahu';

  @override
  String get pastlifeFutureGrowthSuffix => 'Crecimiento Futuro';

  @override
  String get pastlifeRahuPullsLabel =>
      'RAHU · LO QUE TE IMPULSA HACIA ADELANTE';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ Sombra: $shadow';
  }

  @override
  String get mentalScoresHeader => '🧠 PUNTAJES MENTALES';

  @override
  String get mentalStabilityStat => 'ESTABILIDAD\nMENTAL';

  @override
  String get mentalEmotionalBaselineStat => 'BASE\nEMOCIONAL';

  @override
  String get mentalResilienceStat => 'RESILIENCIA';

  @override
  String get mentalAnxietyStat => 'ANSIEDAD';

  @override
  String get mentalDepressionStat => 'DEPRESIÓN';

  @override
  String get mentalRegulationStat => 'REGULACIÓN';

  @override
  String get mentalProfileTitle => 'Perfil Mental';

  @override
  String get mentalConstitutionLabel => 'CONSTITUCIÓN';

  @override
  String get mentalStressDriverLabel => 'MOTOR DEL ESTRÉS';

  @override
  String get mentalStabilityAnchorLabel => 'ANCLA DE ESTABILIDAD';

  @override
  String get mentalStressResponseLabel => 'RESPUESTA AL ESTRÉS';

  @override
  String get mentalAttachmentStyleLabel => 'ESTILO DE APEGO';

  @override
  String get mentalBurnoutStageLabel => 'ETAPA DE AGOTAMIENTO';

  @override
  String get mentalWord => 'Mental';

  @override
  String get mentalYogasTitle => 'Yogas Mentales';

  @override
  String get mentalStressPressureLabel => 'PRESIÓN DE ESTRÉS';

  @override
  String get mentalWellnessTrendTitle => 'Tendencia de Bienestar';

  @override
  String get mentalHealthyCopingTitle => '✓ AFRONTAMIENTO SALUDABLE';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ RIESGOS NO SALUDABLES';

  @override
  String get mentalRecommendedAlternativesTitle =>
      '✦ ALTERNATIVAS RECOMENDADAS';

  @override
  String get mentalSleepQualityStat => 'CALIDAD DEL SUEÑO';

  @override
  String get mentalSocialSupportStat => 'APOYO SOCIAL';

  @override
  String get mentalBurnoutVulnStat => 'VULN. AGOTAMIENTO';

  @override
  String get mentalSelfAwarenessStat => 'AUTOCONCIENCIA';

  @override
  String get mentalAnxietyWord => 'Ansiedad';

  @override
  String get mentalTypesSuffix => 'Tipos';

  @override
  String get mentalTherapyWord => 'Terapia';

  @override
  String get mentalModalityFitSuffix => 'Afinidad de Modalidad';

  @override
  String get characterScoresHeader => '🔍 PUNTAJES DE CARÁCTER';

  @override
  String get characterStrengthStat => 'FUERZA DE\nCARÁCTER';

  @override
  String get characterIntegrityStat => 'INTEGRIDAD';

  @override
  String get characterResilienceStat => 'RESILIENCIA';

  @override
  String get characterAwarenessStat => 'CONCIENCIA';

  @override
  String get characterStabilityStat => 'ESTABILIDAD';

  @override
  String get characterEthicsStat => 'ÉTICA';

  @override
  String get characterSurfacePersonalityTitle => 'Personalidad Superficial';

  @override
  String get characterLagnaLabel => 'LAGNA';

  @override
  String get characterConstitutionLabel => 'CONSTITUCIÓN';

  @override
  String get characterNakshatraLabel => 'NAKSHATRA';

  @override
  String get characterDeityLabel => 'DEIDAD';

  @override
  String get characterMoonManasTitle => 'Manas Lunar';

  @override
  String get characterSignLabel => 'SIGNO';

  @override
  String get characterHouseLabel => 'CASA';

  @override
  String get characterWarmthStat => 'CALIDEZ';

  @override
  String get characterEmpathyStat => 'EMPATÍA';

  @override
  String get characterLoyaltyStat => 'LEALTAD';

  @override
  String get characterBoundariesStat => 'LÍMITES';

  @override
  String get characterDharmaStat => 'DHARMA';

  @override
  String get characterTruthStat => 'VERDAD';

  @override
  String get characterCompassionStat => 'COMPASIÓN';

  @override
  String get characterGenerosityStat => 'GENEROSIDAD';

  @override
  String get characterSignatureVirtuesTitle => '★ VIRTUDES DISTINTIVAS';

  @override
  String get characterNaturalTalentsTitle => '● TALENTOS NATURALES';

  @override
  String get characterShadowPatternsTitle => '⚠ PATRONES DE SOMBRA';

  @override
  String get characterYogasTitle => 'Yogas de Carácter';

  @override
  String get characterTestsLabel => 'PRUEBAS';

  @override
  String get characterGiftsLabel => 'DONES';

  @override
  String get characterSelfAwareEiStat => 'IE AUTOCONSCIENTE';

  @override
  String get characterSelfRegulateStat => 'AUTORREGULACIÓN';

  @override
  String get characterEmpathyEiStat => 'IE EMPATÍA';

  @override
  String get characterSocialSkillsStat => 'HABILIDADES SOCIALES';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'Realización: $pct%';
  }

  @override
  String get characterAtmakarakaWord => 'Atmakaraka';

  @override
  String get characterSoulSignatureSuffix => 'Firma del Alma';

  @override
  String get characterAtmakarakaLabel => 'ATMAKARAKA';

  @override
  String get characterGunaWord => 'Guna';

  @override
  String get characterProfileSuffix => 'Perfil';

  @override
  String get characterSattvaLabel => 'Sattva';

  @override
  String get characterRajasLabel => 'Rajas';

  @override
  String get characterTamasLabel => 'Tamas';

  @override
  String get healthScoresHeader => '🏥 PUNTAJES DE SALUD';

  @override
  String get healthVitalityStat => 'VITALIDAD';

  @override
  String get healthImmunityStat => 'INMUNIDAD';

  @override
  String get healthRecoveryStat => 'RECUPERACIÓN';

  @override
  String get healthMentalStat => 'MENTAL';

  @override
  String get healthStressTolStat => 'TOL. ESTRÉS';

  @override
  String get healthYogasTitle => 'Yogas de Salud';

  @override
  String get healthDiseasePressureLabel => 'PRESIÓN DE ENFERMEDAD';

  @override
  String get healthTrendTitle => 'Tendencia de Salud';

  @override
  String get healthRecoveryWindowsTitle => 'Ventanas de Recuperación';

  @override
  String get healthCautionPeriodsTitle => 'Períodos de Precaución';

  @override
  String get healthFertilityStat => 'FERTILIDAD';

  @override
  String get healthBurnoutRiskStat => 'RIESGO DE AGOTAMIENTO';

  @override
  String get healthAddictionVulnStat => 'VULN. ADICCIÓN';

  @override
  String get healthWorkLifeBalStat => 'BAL. VIDA-TRABAJO';

  @override
  String get healthAyurvedicWord => 'Ayurvédica';

  @override
  String get healthConstitutionSuffix => 'Constitución';

  @override
  String get healthBodyWord => 'Cuerpo';

  @override
  String get healthSystemMapSuffix => 'Mapa de Sistemas';

  @override
  String get healthBodyZoneWord => 'Zona Corporal';

  @override
  String get healthVulnerabilitySuffix => 'Vulnerabilidad';

  @override
  String get healthDiseaseWord => 'Enfermedad';

  @override
  String get healthSusceptibilitySuffix => 'Susceptibilidad';

  @override
  String get healthLifestyleFactorsTitle => 'Factores de Estilo de Vida';

  @override
  String get healthSleepDisciplineLabel => 'DISCIPLINA DE SUEÑO';

  @override
  String get healthDietDisciplineLabel => 'DISCIPLINA ALIMENTARIA';

  @override
  String get healthExerciseNeedLabel => 'NECESIDAD DE EJERCICIO';

  @override
  String get healthSunlightNeedLabel => 'NECESIDAD DE LUZ SOLAR';

  @override
  String get healthSocialTypeLabel => 'TIPO SOCIAL';

  @override
  String get healthHealingSpeedLabel => 'VELOCIDAD DE SANACIÓN';

  @override
  String get wealthScoresHeader => '💰 PUNTAJES DE RIQUEZA';

  @override
  String get wealthStrengthStat => 'FUERZA DE\nRIQUEZA';

  @override
  String get wealthAccumulationStat => 'ACUMU-\nLACIÓN';

  @override
  String get wealthIncomeFlowStat => 'FLUJO DE\nINGRESOS';

  @override
  String get wealthSustainStat => 'SOSTENIBILIDAD';

  @override
  String get wealthMultiStreamStat => 'MULTI-FUENTE';

  @override
  String get wealthRetentionStat => 'RETENCIÓN';

  @override
  String get wealthWord => 'Riqueza';

  @override
  String get wealthYogasTitle => 'Yogas de Riqueza';

  @override
  String get wealthDrainsLabel => 'DRENAJES';

  @override
  String get wealthBoostersLabel => 'POTENCIADORES';

  @override
  String get wealthYearlyTrendTitle => 'Tendencia Anual';

  @override
  String get wealthGrowthTitle => 'Crecimiento de Riqueza';

  @override
  String get wealthCashPressureTitle => 'Presión de Efectivo';

  @override
  String get wealthMoneyPersonalityTitle => 'Personalidad Financiera';

  @override
  String get wealthTypeLabel => 'TIPO DE RIQUEZA';

  @override
  String get wealthRiskAppetiteLabel => 'APETITO DE RIESGO';

  @override
  String get wealthInvestmentStyleLabel => 'ESTILO DE INVERSIÓN';

  @override
  String get wealthMoneyPersonalityLabel => 'PERSONALIDAD FINANCIERA';

  @override
  String get wealthSpendingLabel => 'GASTOS';

  @override
  String get wealthDebtProbStat => '% PROB. DEUDA';

  @override
  String get wealthInheritanceStat => '% HERENCIA';

  @override
  String get wealthSuddenGainsStat => '% GANANCIAS REPENTINAS';

  @override
  String get wealthSpouseBoostStat => '% IMPULSO DEL CÓNYUGE';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'Probabilidad de éxito: $pct%';
  }

  @override
  String get wealthLifetimeClassLabel => 'CLASE DE RIQUEZA DE POR VIDA';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'Principal: $value';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'Pico: $value';
  }

  @override
  String get wealthIncomeWord => 'Ingresos';

  @override
  String get wealthSourcesSuffix => 'Fuentes';

  @override
  String get wealthInvestmentWord => 'Inversión';

  @override
  String get wealthMixSuffix => 'Mezcla';

  @override
  String wealthDrivenByLabel(Object planet) {
    return 'Impulsado por $planet';
  }

  @override
  String get marriageScoresHeader => '💒 PUNTAJES DE MATRIMONIO';

  @override
  String get marriageOverallStat => 'MATRIMONIO\nGENERAL';

  @override
  String get marriageHarmonyStat => 'ARMONÍA\nMARITAL';

  @override
  String get marriageDomesticStabilityStat => 'ESTABILIDAD\nDOMÉSTICA';

  @override
  String get marriageLongevityStat => 'LONGEVIDAD';

  @override
  String get marriageSatisfactionStat => 'SATISFACCIÓN';

  @override
  String get marriageClarityStat => 'CLARIDAD';

  @override
  String get marriageWindowsTitle => 'Ventanas Matrimoniales';

  @override
  String get marriagePhasesTitle => 'Fases Matrimoniales';

  @override
  String get marriageInLawRelationsStat => 'RELACIONES CON SUEGROS';

  @override
  String get marriageFamilyHarmonyStat => 'ARMONÍA FAMILIAR';

  @override
  String get marriageFertilityStat => 'FERTILIDAD';

  @override
  String get marriageHomeOwnershipStat => 'PROPIEDAD DE VIVIENDA';

  @override
  String get marriageDivorceRiskStat => 'RIESGO DE DIVORCIO';

  @override
  String get marriageInfidelityStat => 'INFIDELIDAD';

  @override
  String get marriageConflictStat => 'CONFLICTO';

  @override
  String get marriageDistanceStat => 'DISTANCIA';

  @override
  String get marriageSeekInPartnerTitle => '★ BUSCAR EN LA PAREJA';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ EVITAR EN LA PAREJA';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'Realización: $pct%';
  }

  @override
  String get marriageDarakarakaWord => 'Darakaraka';

  @override
  String get marriageSpouseKarakaSuffix => 'Karaka del Cónyuge';

  @override
  String get marriageDarakarakaDkLabel => 'DARAKARAKA (DK)';

  @override
  String get marriage7thWord => '7ª';

  @override
  String get marriageSignLabel => 'SIGNO';

  @override
  String get marriageLordInLabel => 'SEÑOR EN';

  @override
  String get marriageStrengthLabel => 'FUERZA';

  @override
  String get marriageSpouseWord => 'Cónyuge';

  @override
  String get marriageProfileSuffix => 'Perfil';

  @override
  String get marriageSpouseTraitsTitle => '★ RASGOS DEL CÓNYUGE';

  @override
  String get marriageLikelyProfessionsTitle => '● PROFESIONES PROBABLES';

  @override
  String get marriageHarmonyWord => 'Armonía';

  @override
  String get marriageRadarSuffix => 'Radar';

  @override
  String get marriagePhysicalLabel => 'Físico';

  @override
  String get marriageSharedValuesLabel => 'Valores Compartidos';

  @override
  String get marriageConflictResolutionLabel => 'Resolución de Conflictos';

  @override
  String get marriageMangalDoshLabel => '⚠ MANGAL DOSH';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'Severidad: $value';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'Cancelación: $value';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'Navamsa';

  @override
  String get multiChartTitleChild => 'Hijos';

  @override
  String get multiChartTitleLove => 'Amor';

  @override
  String get multiChartTitleKarma => 'Karma';

  @override
  String get multiChartTitleDefault => 'Multi-Carta';

  @override
  String get multiChartSuffixProbability => 'Probabilidad';

  @override
  String get multiChartSuffixCompatibility => 'Compatibilidad';

  @override
  String get multiChartSuffixLinkage => 'Vinculación';

  @override
  String get multiChartSuffixReport => 'Informe';

  @override
  String get multiChartParticipantsLabel => 'PARTICIPANTES';

  @override
  String get multiChartAnalysisWord => 'Análisis';

  @override
  String get multiChartConfidenceSuffix => 'Confianza';

  @override
  String get multiChartQualityBadge => 'CALIDAD';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'Analiza este informe de astrología védica y da información detallada:\n\n$formatted';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'Aquí tienes un informe especializado de astrología védica. Por favor analízalo a fondo y proporciona información práctica:\n\n$formatted';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'Revisa este análisis de astrología védica y explica los hallazgos clave en lenguaje sencillo:\n\n$formatted';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return '¡Copiado para $label!';
  }

  @override
  String get childProbTitle1 => 'Probabilidad';

  @override
  String get childProbTitle2 => 'de Hijos';

  @override
  String get childNumberOfChildrenHeader1 => 'Número de';

  @override
  String get childNumberOfChildrenHeader2 => 'Hijos';

  @override
  String get childTimingHeader1 => 'Timing';

  @override
  String get childTimingHeader2 => 'Moola Dasha';

  @override
  String get child5thHouseHeader1 => 'Casa 5';

  @override
  String get analysisWord => 'Análisis';

  @override
  String get jupiterWord => 'Júpiter';

  @override
  String get childD7Header1 => 'D7 Saptamsa';

  @override
  String get childBeejaHeader1 => 'Beeja y Kshetra';

  @override
  String get childBeejaHeader2 => 'Sphuta';

  @override
  String get childDoshaHeader1 => 'Dosha';

  @override
  String get childVedicHeader1 => 'Remedios';

  @override
  String get childVedicHeader2 => 'Védicos';

  @override
  String get progenyProbabilityLabel => 'PROBABILIDAD DE DESCENDENCIA';

  @override
  String get favorableWindowsLabel => 'VENTANAS FAVORABLES';

  @override
  String get partnerOneLabel => 'Pareja 1';

  @override
  String get partnerTwoLabel => 'Pareja 2';

  @override
  String get moonSignLabel => 'Signo Lunar';

  @override
  String get lordInDusthana => 'Señor en Dusthana';

  @override
  String get lordStrengthLabel => 'Fuerza del Señor';

  @override
  String get houseStrengthLabel => 'Fuerza de la Casa';

  @override
  String get dignityLabel => 'Dignidad';

  @override
  String get directBadge => 'Directo';

  @override
  String get notCombustBadge => 'No Combusto';

  @override
  String get in5thHouseBadge => 'En la Casa 5';

  @override
  String get aspects5thBadge => 'Aspecta la Casa 5';

  @override
  String get no5thConnectionBadge => 'Sin Conexión con la Casa 5';

  @override
  String jupiterInSignHeading(String sign) {
    return 'Júpiter en $sign';
  }

  @override
  String get d7LagnaLabel => 'Lagna D7';

  @override
  String get d7FifthSignLabel => 'Signo 5 en D7';

  @override
  String get d7FifthLordLabel => 'Señor de la Casa 5 en D7';

  @override
  String get jupiterInD7Label => 'Júpiter en D7';

  @override
  String get jupiterDignityLabel => 'Dignidad de Júpiter';

  @override
  String get d7StrengthLabel => 'Fuerza D7';

  @override
  String get yesWord => 'Sí';

  @override
  String get noWord => 'No';

  @override
  String get beejaSphutaTitle => 'BEEJA SPHUTA';

  @override
  String get kshetraSphutaTitle => 'KSHETRA SPHUTA';

  @override
  String get degreeLabel => 'Grado';

  @override
  String get signLordLabel => 'Señor del Signo';

  @override
  String get presentInLabel => 'Presente En';

  @override
  String get netPenaltyLabel => 'Penalización Neta';

  @override
  String get remedyGemstone => 'Remedios con Piedras Preciosas';

  @override
  String get remedyMantra => 'Remedios con Mantras';

  @override
  String get remedyRitual => 'Remedios Rituales';

  @override
  String get remedyLifestyle => 'Remedios de Estilo de Vida';

  @override
  String get remedyCharitable => 'Remedios de Caridad';

  @override
  String copiedForName(String name) {
    return '¡Copiado para $name!';
  }

  @override
  String get mahadashaLabel => 'Mahadasha';

  @override
  String get mdPeriodLabel => 'Período MD';

  @override
  String get antardashaLabel => 'Antardasha';

  @override
  String get adPeriodLabel => 'Período AD';

  @override
  String get pratyantardashaLabel => 'Pratyantardasha';

  @override
  String get favorabilityLabel => 'Favorabilidad';

  @override
  String factorPrefix(String factor) {
    return 'Factor: $factor';
  }

  @override
  String appliesToLabel(String value) {
    return 'Aplica a: $value';
  }

  @override
  String get qualityTag => 'CALIDAD';

  @override
  String get reliabilityVeryHigh => 'Confiabilidad Muy Alta';

  @override
  String get reliabilityGuidanceLevel => 'Lectura de nivel orientativo';

  @override
  String get karmaLinkTitle1 => 'Vinculación';

  @override
  String get karmaLinkTitle2 => 'Kármica';

  @override
  String get karmaFoundationHeader1 => 'Fundamento';

  @override
  String get karmaFoundationHeader2 => 'Kármico';

  @override
  String get karmaPairwiseHeader1 => 'Vinculaciones';

  @override
  String get karmaPairwiseHeader2 => 'entre Pares';

  @override
  String get karmaGroupHeader1 => 'Patrón';

  @override
  String get karmaGroupHeader2 => 'Grupal';

  @override
  String get karmaPastLifeHeader1 => 'Objetivos de';

  @override
  String get karmaPastLifeHeader2 => 'Vida Pasada';

  @override
  String get karmaCurrentLifeHeader1 => 'Vida Actual';

  @override
  String get karmaCurrentLifeHeader2 => 'Aprendizaje';

  @override
  String get karmaDebtsHeader2 => 'Deudas';

  @override
  String get karmaMoolaDashaHeader1 => 'Moola Dasha';

  @override
  String get karmaMoolaDashaHeader2 => 'Timing';

  @override
  String get karmaDeepAuditHeader1 => 'Tabla de';

  @override
  String get karmaDeepAuditHeader2 => 'Auditoría Profunda';

  @override
  String get karmaHeroLabel => 'VINCULACIÓN KÁRMICA DE VIDA PASADA';

  @override
  String get karmaKetuMastery => 'DOMINIO DE KETU';

  @override
  String get nakshatraLabel => 'Nakshatra';

  @override
  String get deityLabel => 'Deidad';

  @override
  String get masteryScoreLabel => 'Puntaje de Dominio';

  @override
  String get karmaRahuGrowth => 'CRECIMIENTO DE RAHU';

  @override
  String get growthScoreLabel => 'Puntaje de Crecimiento';

  @override
  String get karmaAtmakaraka => 'ATMAKARAKA';

  @override
  String get karmaSaturnKarma => 'KARMA DE SATURNO';

  @override
  String get karma12thHouse => 'CASA 12';

  @override
  String get karma9thHousePunya => 'PUNYA DE LA CASA 9';

  @override
  String get bhavaScoreLabel => 'Puntaje de Bhava';

  @override
  String get karmaD60Signature => 'FIRMA D60';

  @override
  String get depthScoreLabel => 'Puntaje de Profundidad';

  @override
  String get linkageStrengthLabel => 'Fuerza de Vinculación';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'FACTORES DE VINCULACIÓN ($count activos)';
  }

  @override
  String get factorColumnLabel => 'Factor';

  @override
  String get weightColumnLabel => 'Peso';

  @override
  String get meaningColumnLabel => 'Significado';

  @override
  String get statusColumnLabel => 'Estado';

  @override
  String get karmaPastLifeConnection => 'CONEXIÓN DE VIDA PASADA';

  @override
  String get karmaCurrentLifeDynamic => 'DINÁMICA DE VIDA ACTUAL';

  @override
  String get karmaWhatTheyTeach => 'QUÉ SE ENSEÑAN MUTUAMENTE';

  @override
  String get karmaGroupThemeHeader => 'TEMA KÁRMICO GRUPAL';

  @override
  String get karmaSharedSettingHeader => 'ESCENARIO COMPARTIDO DE VIDA PASADA';

  @override
  String get karmaCollectiveKetuHeader => 'PATRÓN COLECTIVO DE KETU';

  @override
  String get karmaCollectiveRahuHeader => 'PATRÓN COLECTIVO DE RAHU';

  @override
  String get housesPrefixLabel => 'Casas: ';

  @override
  String get signsPrefixLabel => 'Signos: ';

  @override
  String get karmicCohesionLabel => 'Cohesión Kármica';

  @override
  String get karmaGroupSoulContractHeader => 'CONTRATO DEL ALMA GRUPAL';

  @override
  String get goalLabel => 'Objetivo';

  @override
  String get karmaSharedGoalHeader => 'OBJETIVO COMPARTIDO DE VIDA PASADA';

  @override
  String get howToGrowHeader => 'CÓMO CRECER';

  @override
  String moolaDashaPrefix(String value) {
    return 'Moola Dasha: $value';
  }

  @override
  String get karmaSharedLessonHeader => 'LECCIÓN GRUPAL COMPARTIDA';

  @override
  String get karmaMutualTeachingHeader => 'MAPA DE ENSEÑANZA MUTUA';

  @override
  String get karmaTeachingDynamicsPlaceholder =>
      'Las dinámicas de enseñanza surgirán a medida que las conexiones kármicas se profundicen.';

  @override
  String get typeFieldLabel => 'Tipo';

  @override
  String get basisFieldLabel => 'Base';

  @override
  String get resolutionPathHeader => 'CAMINO DE RESOLUCIÓN';

  @override
  String dashaTimingPrefix(String value) {
    return 'Timing de Dasha: $value';
  }

  @override
  String get mutualDebtsHeader => 'DEUDAS MUTUAS';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'Fechas';

  @override
  String get groupKarmicWindowHeader => 'VENTANA KÁRMICA GRUPAL';

  @override
  String parametersAuditedHeading(int count) {
    return '$count PARÁMETROS AUDITADOS';
  }

  @override
  String get valuePrefixLabel => 'Valor: ';

  @override
  String weightPrefix(String value) {
    return 'P: $value';
  }

  @override
  String get loveCompatTitle1 => 'Compatibilidad';

  @override
  String get loveCompatTitle2 => 'Amorosa';

  @override
  String get loveAttractionHeader1 => 'Atracción y';

  @override
  String get loveAttractionHeader2 => 'Química';

  @override
  String get loveEmotionalHeader1 => 'Armonía';

  @override
  String get loveEmotionalHeader2 => 'Emocional';

  @override
  String get loveMentalHeader1 => 'Sintonía';

  @override
  String get loveMentalHeader2 => 'Mental';

  @override
  String get lovePassionHeader1 => 'Pasión y';

  @override
  String get lovePassionHeader2 => 'Físico';

  @override
  String get loveLongtermHeader1 => 'Largo Plazo';

  @override
  String get loveKarmicHeader1 => 'Vínculo Amoroso';

  @override
  String get loveKarmicHeader2 => 'Kármico';

  @override
  String get loveChallengesHeader1 => 'Desafíos y';

  @override
  String get loveChallengesHeader2 => 'Fricción';

  @override
  String get loveTimingHeader1 => 'Timing Amoroso';

  @override
  String get loveRelationshipHeader1 => 'Dinámica de';

  @override
  String get loveRelationshipHeader2 => 'la Relación';

  @override
  String get loveRemediesHeader1 => 'Remedios y';

  @override
  String get loveRemediesHeader2 => 'Orientación';

  @override
  String get loveCompatHeroLabel => 'COMPATIBILIDAD AMOROSA';

  @override
  String get loveChipAttraction => 'Atracción';

  @override
  String get loveChipPassion => 'Pasión';

  @override
  String get loveChipChallenge => 'Desafío';

  @override
  String get venusSignLabel => 'Signo de Venus';

  @override
  String get attractionScoreLabel => 'Puntaje de Atracción';

  @override
  String get activeContactsLabel => 'Contactos Activos';

  @override
  String get magneticPullLabel => 'Atracción Magnética';

  @override
  String get initialAttractionLabel => 'Atracción Inicial';

  @override
  String get emotionalScoreLabel => 'Puntaje Emocional';

  @override
  String get elementMatchLabel => 'Coincidencia de Elemento';

  @override
  String get harmonyLabel => 'Armonía';

  @override
  String get kootaYoni => 'YONI';

  @override
  String get kootaGana => 'GANA';

  @override
  String get kootaTara => 'TARA';

  @override
  String get doshaPresentBadge => 'Dosha Presente';

  @override
  String get noDoshaBadge => 'Sin Dosha';

  @override
  String get axisLabel => 'Eje';

  @override
  String get mentalScoreLabel => 'Puntaje Mental';

  @override
  String get mercuryDynamicsLabel => 'DINÁMICA DE MERCURIO';

  @override
  String get communicationStyleLabel =>
      'COINCIDENCIA DE ESTILO DE COMUNICACIÓN';

  @override
  String get intellectualConnectionLabel => 'CONEXIÓN INTELECTUAL';

  @override
  String get passionScoreLabel => 'Puntaje de Pasión';

  @override
  String get marsVenusLabel => 'INTERACCIÓN MARTE-VENUS';

  @override
  String get physicalChemistryLabel => 'QUÍMICA FÍSICA';

  @override
  String get yoniCompatLabel => 'COMPATIBILIDAD YONI';

  @override
  String get longtermScoreLabel => 'Puntaje de Largo Plazo';

  @override
  String get seventhHouseSynastryLabel => 'SINASTRÍA DE LA CASA 7';

  @override
  String get commitmentPotentialLabel => 'POTENCIAL DE COMPROMISO';

  @override
  String get jupiterBlessingLabel => 'BENDICIÓN DE JÚPITER';

  @override
  String get d9NavamsaResonanceLabel => 'RESONANCIA D9 NAVAMSA';

  @override
  String get saturnLongevityLabel => 'LONGEVIDAD DE SATURNO';

  @override
  String get karmicScoreLabel => 'Puntaje Kármico';

  @override
  String get darakarakaLinkLabel => 'VÍNCULO DARAKARAKA';

  @override
  String get sourceLabel => 'Fuente';

  @override
  String get emotionalGiverReceiverLabel => 'DADOR / RECEPTOR EMOCIONAL';

  @override
  String get powerBalanceLabel => 'EQUILIBRIO DE PODER';

  @override
  String get growthDynamicLabel => 'DINÁMICA DE CRECIMIENTO';

  @override
  String get addressesLabel => 'Aborda';

  @override
  String get loveScoresLabel => 'PUNTAJES DE AMOR';

  @override
  String get loveCapacityLabel => 'CAPACIDAD\nAMOROSA';

  @override
  String get emotionalAvailabilityLabel => 'DISPONIBILIDAD\nEMOCIONAL';

  @override
  String get romanticAttractionLabel => 'ATRACCIÓN\nROMÁNTICA';

  @override
  String get commitmentWord => 'COMPROMISO';

  @override
  String get intimacyWord => 'INTIMIDAD';

  @override
  String get fidelityWord => 'LEALTAD';

  @override
  String get loveProfileTitle => 'Perfil Amoroso';

  @override
  String get loveStyleLabel => 'ESTILO AMOROSO';

  @override
  String get attractionStyleLabel => 'ESTILO DE ATRACCIÓN';

  @override
  String get lovePathLabel => 'CAMINO AMOROSO';

  @override
  String get currentPhaseLabel => 'FASE ACTUAL';

  @override
  String get commitmentStyleLabel => 'ESTILO DE COMPROMISO';

  @override
  String get loveWord => 'Amor';

  @override
  String get karakasWord => 'Karakas';

  @override
  String get attractedToLabel => 'ATRAÍDO POR';

  @override
  String get whatPartnerSeesLabel => 'LO QUE LA PAREJA VE';

  @override
  String get romancePatternTitle => 'Patrón Romántico';

  @override
  String get firstLoveAgeLabel => 'EDAD DEL PRIMER AMOR';

  @override
  String get relationshipCountLabel => 'CANTIDAD DE RELACIONES';

  @override
  String get avgDurationLabel => 'DURACIÓN PROMEDIO';

  @override
  String get breakupTriggerLabel => 'DETONANTE DE RUPTURA';

  @override
  String get heartbreakRecoveryLabel => 'RECUPERACIÓN DE DECEPCIÓN';

  @override
  String get loveTrendTitle => 'Tendencia Amorosa';

  @override
  String get newLoveWindowsTitle => 'Ventanas de Nuevo Amor';

  @override
  String get loveBlocksTitle => 'Bloqueos Amorosos';

  @override
  String get activeBlocksLabel => 'BLOQUEOS ACTIVOS';

  @override
  String get loveMarriagePctLabel => '% MATRIMONIO POR AMOR';

  @override
  String get heartbreakVulnLabel => 'VULN. A DECEPCIONES';

  @override
  String get selfSabotageLabel => 'AUTOSABOTAJE';

  @override
  String get emotionalIqLabel => 'COEFICIENTE EMOCIONAL';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'Realización: $pct%';
  }

  @override
  String get languagesWord => 'Lenguajes';

  @override
  String get givesLabel => 'DA';

  @override
  String get receivesLabel => 'RECIBE';

  @override
  String get idealWord => 'Ideal';

  @override
  String get partnerWord => 'Pareja';

  @override
  String get seekTheseTraitsLabel => 'BUSCAR ESTOS RASGOS';

  @override
  String get dealbreakersLabel => 'PUNTOS DE RUPTURA';

  @override
  String get propertyScoresLabel => 'PUNTAJES DE PROPIEDAD';

  @override
  String get acquisitionCapacityLabel => 'CAPACIDAD DE\nADQUISICIÓN';

  @override
  String get homeOwnershipPctLabel => '% PROPIEDAD\nDE VIVIENDA';

  @override
  String get reWealthPotentialLabel => 'POTENCIAL DE\nRIQUEZA INMOB.';

  @override
  String get rentalWord => 'ALQUILER';

  @override
  String get vehiclesWord => 'VEHÍCULOS';

  @override
  String get landPctLabel => '% TIERRAS';

  @override
  String get propertyProfileTitle => 'Perfil de Propiedad';

  @override
  String get karmaTypeLabel => 'TIPO DE KARMA';

  @override
  String get environmentLabel => 'AMBIENTE';

  @override
  String get styleLabel => 'ESTILO';

  @override
  String get sizeLabel => 'TAMAÑO';

  @override
  String get locationLabel => 'UBICACIÓN';

  @override
  String get actionNext12mLabel => 'ACCIÓN PRÓXIMOS 12M';

  @override
  String get propertyWord => 'Propiedad';

  @override
  String get propertyYogasTitle => 'Yogas de Propiedad';

  @override
  String get drainsLabel => 'DRENAJES';

  @override
  String get boostersLabel => 'POTENCIADORES';

  @override
  String get propertyTrendTitle => 'Tendencia de Propiedad';

  @override
  String get buyingWindowsTitle => 'Ventanas de Compra';

  @override
  String get constructionWindowsTitle => 'Ventanas de Construcción';

  @override
  String get maternalInherPctLabel => '% HERENCIA MATERNA';

  @override
  String get paternalInherPctLabel => '% HERENCIA PATERNA';

  @override
  String get multiHomePctLabel => '% MÚLTIPLES VIVIENDAS';

  @override
  String get investmentPctLabel => '% INVERSIÓN';

  @override
  String get vehicleProfileTitle => 'Perfil de Vehículo';

  @override
  String get countLabel => 'CANTIDAD';

  @override
  String get firstAgeLabel => 'PRIMERA EDAD';

  @override
  String get categoryLabel => 'CATEGORÍA';

  @override
  String get luxuryLabel => 'LUJO';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'Cantidad de por vida: $count · Realización: $pct%';
  }

  @override
  String get pressureWord => 'PRESIÓN';

  @override
  String get protectionWord => 'PROTECCIÓN';

  @override
  String get astrologicalWord => 'Astrológico';

  @override
  String get keyRisksHeader1 => 'Riesgos';

  @override
  String get keyRisksHeader2 => 'Clave';

  @override
  String get reportCopiedShort => '¡Informe copiado!';

  @override
  String get keyScoresLabel => 'PUNTAJES CLAVE';

  @override
  String allScoresCountLabel(int count) {
    return 'Todos los Puntajes ($count)';
  }

  @override
  String get windowsWord => 'Ventanas';

  @override
  String get genericFailedMsg => 'Falló';

  @override
  String get unknownWord => 'Desconocido';

  @override
  String selectKarmaChartsLabel(int max) {
    return 'Selecciona 2-$max Cartas';
  }

  @override
  String selectChartsLabelCount(int max) {
    return 'Selecciona $max Cartas';
  }

  @override
  String runningAnalysisLabel(String label) {
    return 'Ejecutando análisis de $label...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'Elige de 2 a $max cartas para analizar vínculos kármicos';
  }

  @override
  String get pickMaleFemaleHint => 'Elige una carta masculina y una femenina';

  @override
  String get personOneLabel => 'Persona 1';

  @override
  String get personTwoLabel => 'Persona 2';

  @override
  String get analysisFailedMsg => 'El análisis falló';

  @override
  String analyzeChartsCountLabel(int count) {
    return 'Analizar $count Cartas';
  }

  @override
  String get contextGeneralLabel => 'General';

  @override
  String get contextLoveLabel => 'Amor';

  @override
  String get contextBusinessLabel => 'Negocios';

  @override
  String get contextFamilyLabel => 'Familia';

  @override
  String get contextTeamLabel => 'Equipo';

  @override
  String get contextFriendshipLabel => 'Amistad';

  @override
  String get relationshipIntelTitle => 'Inteligencia de Relaciones';

  @override
  String analyzingChartsCountLabel(int count) {
    return 'Analizando $count cartas...';
  }

  @override
  String get relationshipContextLabel => 'Contexto de la Relación';

  @override
  String get kundliMilanReportTitle => 'Informe de Kundli Milan';

  @override
  String get runningMilanAnalysisLabel => 'Ejecutando análisis de Milan...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '$count/2 seleccionados';
  }

  @override
  String get runMilanAnalysisBtn => 'Ejecutar Análisis de Milan';

  @override
  String get noChartsCreateFirst =>
      'No hay cartas. Crea primero una carta natal.';

  @override
  String get selectBirthChartAnalyze =>
      'Selecciona una carta natal para analizar';

  @override
  String get doshAnalysis => 'Análisis de Dosha';

  @override
  String doshActiveCount(Object active, Object total) {
    return '$active activos / $total verificados';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '$active activos / $total yogas verificados';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'YOGAS ACTIVOS ($count)';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'Ocultar yogas inactivos ($count)';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'Mostrar yogas inactivos ($count)';
  }

  @override
  String get loadFailed => 'Falló';

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
    return 'Subperíodos de $planet';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return 'Señor de Nacimiento: $lord • Balance: $balance años';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'Lagna: $lagna • Balance: $balance años';
  }

  @override
  String dashaYearsValue(Object years) {
    return '$years años';
  }

  @override
  String get dashaCurrentPeriod => 'Período de Dasha Actual';

  @override
  String dashaAsOf(Object date) {
    return 'Al: $date';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'Yogas Activos en el Período Actual ($count)';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'Doshas Activos en el Período Actual ($count)';
  }

  @override
  String get dashaNoYogasTriggered => 'No se activaron yogas';

  @override
  String get dashaNoDoshasTriggered => 'No se activaron doshas';

  @override
  String get divD1Name => 'Rasi (D-1)';

  @override
  String get divD1Desc => 'Existencia física, todos los asuntos';

  @override
  String get divD2Name => 'Hora (D-2)';

  @override
  String get divD2Desc => 'Riqueza, dinero';

  @override
  String get divD3Name => 'Drekkana (D-3)';

  @override
  String get divD3Desc => 'Hermanos, coraje';

  @override
  String get divD4Name => 'Chaturthamsa (D-4)';

  @override
  String get divD4Desc => 'Propiedad, residencia, fortuna';

  @override
  String get divD5Name => 'Panchamsa (D-5)';

  @override
  String get divD5Desc => 'Fama, autoridad, poder';

  @override
  String get divD6Name => 'Shashthamsa (D-6)';

  @override
  String get divD6Desc => 'Problemas de salud';

  @override
  String get divD7Name => 'Saptamsa (D-7)';

  @override
  String get divD7Desc => 'Hijos, nietos';

  @override
  String get divD8Name => 'Ashtamsa (D-8)';

  @override
  String get divD8Desc => 'Problemas repentinos, litigios';

  @override
  String get divD9Name => 'Navamsha (D-9)';

  @override
  String get divD9Desc => 'Matrimonio, cónyuge, dharma';

  @override
  String get divD10Name => 'Dasamsha (D-10)';

  @override
  String get divD10Desc => 'Carrera, profesión';

  @override
  String get divD11Name => 'Rudramsha (D-11)';

  @override
  String get divD11Desc => 'Muerte, destrucción';

  @override
  String get divD12Name => 'Dwadasamsha (D-12)';

  @override
  String get divD12Desc => 'Padres, parientes de sangre';

  @override
  String get divD16Name => 'Shodasamsha (D-16)';

  @override
  String get divD16Desc => 'Vehículos, comodidades, placeres';

  @override
  String get divD20Name => 'Vimsamsha (D-20)';

  @override
  String get divD20Desc => 'Asuntos espirituales, religiosos';

  @override
  String get divD24Name => 'Chaturvimsamsha (D-24)';

  @override
  String get divD24Desc => 'Aprendizaje, conocimiento, educación';

  @override
  String get divD27Name => 'Nakshatramsha (D-27)';

  @override
  String get divD27Desc => 'Fortalezas, debilidades, naturaleza';

  @override
  String get divD30Name => 'Trimsamsha (D-30)';

  @override
  String get divD30Desc => 'Males, subconsciente, castigo';

  @override
  String get divD40Name => 'Khavedamsha (D-40)';

  @override
  String get divD40Desc => 'Auspicioso/inauspicioso (materno)';

  @override
  String get divD45Name => 'Akshavedamsha (D-45)';

  @override
  String get divD45Desc => 'Todos los asuntos (paterno)';

  @override
  String get divD60Name => 'Shashtyamsha (D-60)';

  @override
  String get divD60Desc => 'Karma de vida pasada — MÁS IMPORTANTE';

  @override
  String get lifeAreaCareer => 'Carrera';

  @override
  String get lifeAreaWealth => 'Riqueza';

  @override
  String get lifeAreaMarriage => 'Matrimonio';

  @override
  String get lifeAreaHealth => 'Salud';

  @override
  String get lifeAreaSpirituality => 'Espiritualidad';

  @override
  String lifeAreaGrade(Object grade) {
    return 'Grado: $grade';
  }

  @override
  String get lifeAreaFactorsLabel => 'Factores:';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return 'Nak: $nakshatra ($pada)';
  }

  @override
  String planetNakLord(Object lord) {
    return 'SN: $lord';
  }

  @override
  String planetLongitude(Object value) {
    return 'Long: $value°';
  }

  @override
  String get chakraOverallHealth => 'Salud General';

  @override
  String get careerWord => 'Carrera';

  @override
  String get failedToLoad => 'Error al cargar';

  @override
  String get kundliAscendantLagna => 'Ascendente (Lagna)';

  @override
  String get kundliMoonSignRashi => 'Signo Lunar (Rashi)';

  @override
  String get kundliSunSign => 'Signo Solar';

  @override
  String kundliEngineLabel(Object engine) {
    return 'Motor: $engine';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return 'Grado: $degree°  •  Nakshatra: $nakshatra ($pada)';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'Señor del Nakshatra: $lord  •  Dignidad: $dignity';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return 'Carta $base — $sign';
  }

  @override
  String kundliBaseChart(Object base) {
    return 'Carta $base';
  }

  @override
  String get careerSummary => 'Resumen de Carrera';

  @override
  String get phase => 'Fase';

  @override
  String get confidenceLabel => 'Confianza';

  @override
  String get careerScores => 'Puntajes de Carrera';

  @override
  String get stabilityLabel => 'Estabilidad';

  @override
  String get growthLabel => 'Crecimiento';

  @override
  String get gradeExcellent => 'Excelente';

  @override
  String get gradeGood => 'Bueno';

  @override
  String get gradeAverage => 'Promedio';

  @override
  String get gradeBelowAvg => 'Debajo del Promedio';

  @override
  String get gradeWeak => 'Débil';

  @override
  String get careerTypeDomain => 'Carrera y Dominio';

  @override
  String get careerTimeline => 'Cronología de Carrera';

  @override
  String dashaLabel(Object dasha) {
    return 'Dasha: $dasha';
  }

  @override
  String get improvementSuggestions => 'Sugerencias de Mejora';

  @override
  String get chartDetails => 'Detalles de la Carta';

  @override
  String get keyHousesCareer => 'Casas Clave (Carrera)';

  @override
  String get keyCareerPlanets => 'Planetas Clave de la Carrera';

  @override
  String get empty => 'Vacío';

  @override
  String get guna => 'Guna';

  @override
  String get dasha => 'Dasha';

  @override
  String get satwik => 'Sátwico';

  @override
  String get rajasik => 'Rajásico';

  @override
  String get tamasik => 'Tamásico';

  @override
  String get charGroupCorePersonality => 'Personalidad Central';

  @override
  String get charGroupTrustHonesty => 'Confianza y Honestidad';

  @override
  String get charGroupLoyaltyCommitment => 'Lealtad y Compromiso';

  @override
  String get charGroupStrategicPrivacy => 'Estrategia y Privacidad';

  @override
  String get charGroupFinancial => 'Financiero';

  @override
  String get charGroupAngerConflict => 'Ira y Conflicto';

  @override
  String get charGroupMoralDharmic => 'Moral y Dhármico';

  @override
  String get charGroupIntellectCommunication => 'Intelecto y Comunicación';

  @override
  String get charGroupEmotionalProfile => 'Perfil Emocional';

  @override
  String get charGroupMentalHealth => 'Salud Mental';

  @override
  String get charGroupRomantic => 'Romántico';

  @override
  String get charGroupMarriageFamily => 'Matrimonio y Familia';

  @override
  String get charGroupOverallLife => 'Vida General';

  @override
  String get grahaDrishti => 'Graha Drishti (Aspectos Planetarios)';

  @override
  String get grahaDrishtiSubtitle => 'Quién aspecta a quién (%)';

  @override
  String get lagnaAspectsReceived => 'Aspectos Recibidos por el Lagna';

  @override
  String get rashiDrishti => 'Rashi Drishti (Aspectos de Signo)';

  @override
  String get shadbalaRupas => 'rupas';

  @override
  String get bhavaHouse1 => 'Yo / Cuerpo';

  @override
  String get bhavaHouse2 => 'Riqueza / Familia';

  @override
  String get bhavaHouse3 => 'Hermanos / Coraje';

  @override
  String get bhavaHouse4 => 'Hogar / Madre';

  @override
  String get bhavaHouse5 => 'Hijos / Intelecto';

  @override
  String get bhavaHouse6 => 'Enemigos / Salud';

  @override
  String get bhavaHouse7 => 'Matrimonio / Pareja';

  @override
  String get bhavaHouse8 => 'Longevidad';

  @override
  String get bhavaHouse9 => 'Fortuna / Gurú';

  @override
  String get bhavaHouse10 => 'Carrera / Padre';

  @override
  String get bhavaHouse11 => 'Ganancias / Amigos';

  @override
  String get bhavaHouse12 => 'Pérdida / Moksha';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '$sign • Señor: $lord';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: $value';
  }

  @override
  String get sarvaAshtakavarga => 'Sarva Ashtakavarga (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'Total: $total rekhas (signo promedio = $avg)';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '$planet — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'Total: $total rekhas • En el signo natal: $score';
  }

  @override
  String get today => 'Hoy';

  @override
  String gocharTransitScores(Object date) {
    return 'Gochar (Puntajes de Tránsito) — $date';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'Luna Natal: $sign';
  }

  @override
  String get gocharBest => 'MEJOR';

  @override
  String get gocharWorst => 'PEOR';

  @override
  String copiedOpening(Object ai) {
    return '¡Copiado! Abriendo $ai...';
  }

  @override
  String get openLink => 'ABRIR ↗';

  @override
  String get discussReportWithAI => 'DISCUTIR ESTE INFORME CON IA';

  @override
  String get reliabilityHigh => 'Alta confiabilidad';

  @override
  String get reliabilityModerate => 'Confiabilidad moderada';

  @override
  String get reliabilityLow => 'Baja — solo orientativo';

  @override
  String get reliabilityGoodEdu => 'Buena confiabilidad · verificado con D-24';

  @override
  String get relationshipWord => 'Relación';

  @override
  String get intelligenceWord => 'Inteligencia';

  @override
  String get relationshipIntelligence => 'INTELIGENCIA DE RELACIONES';

  @override
  String get typeLabel => 'TIPO';

  @override
  String get trustLabel => 'CONFIANZA';

  @override
  String get dhokaRisk => 'RIESGO DE TRAICIÓN';

  @override
  String get powerLabel => 'Poder';

  @override
  String get integrity => 'Integridad';

  @override
  String get warmth => 'Calidez';

  @override
  String get trustWord => 'Confianza';

  @override
  String get assertLabel => 'Asertividad';

  @override
  String get character => 'Carácter';

  @override
  String get love => 'Amor';

  @override
  String get businessWord => 'Negocios';

  @override
  String get karmic => 'Kármico';

  @override
  String get enmityRisk => 'Riesgo de Enemistad';

  @override
  String get hdrChartProfiles => 'Perfiles de Cartas';

  @override
  String get hdrPairwiseAnalysis => 'Análisis por Pares';

  @override
  String get hdrCriticalPatterns => 'Patrones Críticos';

  @override
  String get hdrGroupRecommendations => 'Recomendaciones para el Grupo';

  @override
  String get sharedPractices => 'PRÁCTICAS COMPARTIDAS';

  @override
  String get hdrIndividualGuidance => 'Guía Individual';

  @override
  String get growthAreas => 'ÁREAS DE CRECIMIENTO';

  @override
  String get hdrCoreTheme => 'Tema Central';

  @override
  String get growthOriented => 'ORIENTADO AL CRECIMIENTO';

  @override
  String get groupTheme => 'TEMA GRUPAL';

  @override
  String get compatibility => 'COMPATIBILIDAD';

  @override
  String get unifiedScoreLabel => 'PUNTAJE UNIFICADO';

  @override
  String get ashtakoot => 'ASHTAKOOT';

  @override
  String get probability => 'PROBABILIDAD';

  @override
  String get hdrAshtakootSummary => 'Resumen de Ashtakoot';

  @override
  String get hdrGunBreakdown => 'Desglose de los 8 Gunas';

  @override
  String get hdrMangalDosh => 'Mangal Dosh';

  @override
  String get hdrD9CrossChart => 'Cruce de Cartas D-9';

  @override
  String get d9Compatibility => 'COMPATIBILIDAD D-9';

  @override
  String get hdrDomainCompatibility => 'Compatibilidad por Dominio';

  @override
  String get emotional => 'Emocional';

  @override
  String get intellectual => 'Intelectual';

  @override
  String get spiritual => 'Espiritual';

  @override
  String get financial => 'Financiero';

  @override
  String get domestic => 'Doméstico';

  @override
  String get communicationWord => 'Comunicación';

  @override
  String get sharedDharma => 'Dharma Compartido';

  @override
  String get familyCreation => 'Formación de Familia';

  @override
  String get hdrMarriageTiming => 'Timing del Matrimonio';

  @override
  String get jointMarriageWindows => 'Ventanas Conjuntas de Matrimonio';

  @override
  String get engagementWindows => 'Ventanas de Compromiso';

  @override
  String get recommendedLabel => 'Recomendado';

  @override
  String get hdrKeyRisks => 'Riesgos Clave';

  @override
  String get hdrFinalVerdict => 'Veredicto Final';

  @override
  String get marriageVerdict => 'VEREDICTO MATRIMONIAL';

  @override
  String get educationWord => 'Educación';

  @override
  String get learningSuffix => 'y Aprendizaje';

  @override
  String get coreEducationScores => 'PUNTAJES EDUCATIVOS PRINCIPALES';

  @override
  String get academicSuccess => 'ÉXITO ACADÉMICO';

  @override
  String get learningCapacity => 'CAPACIDAD DE APRENDIZAJE';

  @override
  String get memory => 'MEMORIA';

  @override
  String get intelligence => 'INTELIGENCIA';

  @override
  String get research => 'INVESTIGACIÓN';

  @override
  String get hdrIntellectualProfile => 'Perfil Intelectual';

  @override
  String get learningSignature => 'FIRMA DE APRENDIZAJE';

  @override
  String get hdrSubjectKaraka => 'Karaka de la Materia';

  @override
  String get hdrHouseFoundations => 'Fundamentos de las Casas';

  @override
  String get hdrMercuryJupiter => 'Mercurio y Júpiter';

  @override
  String get hdrEducationYogas => 'Yogas Educativos';

  @override
  String get hdrDivisionalValidation => 'Validación Divisional';

  @override
  String get standing => 'POSICIÓN';

  @override
  String get hdrSubjectRanking => 'Clasificación de Materias';

  @override
  String get hdrDegreeLikelihood => 'Probabilidad de Título';

  @override
  String get hdrStudyPeriods => 'Períodos de Estudio';

  @override
  String get earlySchooling => 'Educación Temprana';

  @override
  String get higherEducation => 'Educación Superior';

  @override
  String get postgradResearch => 'Posgrado · Investigación';

  @override
  String get hdrLearningPreferences => 'Preferencias de Aprendizaje';

  @override
  String get hdrChallengesGifts => 'Desafíos y Dones';

  @override
  String get challenges => 'DESAFÍOS';

  @override
  String get cognitiveGifts => 'DONES COGNITIVOS';

  @override
  String get naturalAbilities => 'HABILIDADES NATURALES';

  @override
  String get hdrSaraswatiRemedies => 'Remedios de Saraswati';

  @override
  String get studentVerdict => 'VEREDICTO ESTUDIANTIL';

  @override
  String get educationCareerLinkage => 'VÍNCULO EDUCACIÓN → CARRERA';

  @override
  String get startupSuffix => 'y Emprendimiento';

  @override
  String get coreBusinessScores => 'PUNTAJES EMPRESARIALES PRINCIPALES';

  @override
  String get overallBusiness => 'NEGOCIO GENERAL';

  @override
  String get ventureSuccess => 'ÉXITO DEL EMPRENDIMIENTO';

  @override
  String get eleventhHouse => 'CASA 11';

  @override
  String get gains => 'GANANCIAS';

  @override
  String get investor => 'INVERSOR';

  @override
  String get hdrFounderArchetype => 'Arquetipo de Fundador';

  @override
  String get hdrTenthEleventhHouses => 'Casas 10 y 11';

  @override
  String get hdrBusinessYogas => 'Yogas Empresariales';

  @override
  String get hdrRecommendedDomains => 'Dominios Recomendados';

  @override
  String get hdrBusinessStyle => 'Estilo Empresarial';

  @override
  String get hdrFounderSkills => 'Habilidades de Fundador';

  @override
  String get hdrFundingProfile => 'Perfil de Financiamiento';

  @override
  String get recommendedPath => 'CAMINO RECOMENDADO';

  @override
  String get investorAttract => 'ATRACTIVO PARA INVERSORES';

  @override
  String get familyBacking => 'APOYO FAMILIAR';

  @override
  String get hybridViability => 'VIABILIDAD HÍBRIDA';

  @override
  String get launchWindow => 'Ventana de Lanzamiento';

  @override
  String get scaleWindow => 'Ventana de Escalamiento';

  @override
  String get hdrBusinessRisks => 'Riesgos Empresariales';

  @override
  String get recoveryCapacity => 'CAPACIDAD DE RECUPERACIÓN';

  @override
  String get hdrRemediesSolutions => 'Remedios y Soluciones';

  @override
  String get aiConnectionLost => 'Conexión perdida. Inténtalo de nuevo.';

  @override
  String get aiSomethingWrong => 'Algo salió mal';

  @override
  String get aiNoResponse => 'Sin respuesta';

  @override
  String get aiConnectionError => 'Error de conexión. Inténtalo de nuevo.';

  @override
  String get aiAutoDetect => 'Detección automática';

  @override
  String aiAutoArrow(String lang) {
    return 'Auto → $lang';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'Idioma: $lang';
  }

  @override
  String get aiNoBirthCharts => 'No se encontraron cartas natales';

  @override
  String get aiCreateChartFirst =>
      'Crea primero una carta natal para chatear con la IA';

  @override
  String get aiSelectChartBegin =>
      'Selecciona una carta natal para comenzar el análisis';

  @override
  String aiAnalyzingName(String name) {
    return 'Analizando: $name';
  }

  @override
  String get aiChange => 'Cambiar';

  @override
  String get aiAnalyzingChart => 'Analizando tu carta...';

  @override
  String get aiAskStarsHint => 'Pregúntale a las estrellas lo que quieras...';

  @override
  String get aiSuggestedFollowups => 'Preguntas de seguimiento sugeridas';

  @override
  String get aiThinking => 'Pensando...';

  @override
  String get aiThanks => '¡Gracias!';

  @override
  String get aiFeedbackNoted => 'Comentario registrado';

  @override
  String get svcAll => 'Todos';

  @override
  String get svcNoServices => 'No hay servicios disponibles';

  @override
  String get svcFree => 'GRATIS';

  @override
  String get astroFailedStartCall => 'No se pudo iniciar la llamada';

  @override
  String get astroFailedStartChat => 'No se pudo iniciar el chat';

  @override
  String astroErrorDetail(String error) {
    return 'Error: $error';
  }

  @override
  String get astroExperience => 'Experiencia';

  @override
  String get astroSessions => 'Sesiones';

  @override
  String get astroMinutes => 'Minutos';

  @override
  String get astroAbout => 'Acerca de';

  @override
  String get astroLanguages => 'Idiomas';

  @override
  String get astroRateCard => 'Tarifario';

  @override
  String get astroVoice => 'Voz';

  @override
  String astroReviews(int count) {
    return 'Reseñas ($count)';
  }

  @override
  String get astroNoReviews => 'Aún no hay reseñas';

  @override
  String get astroAnonymous => 'Anónimo';

  @override
  String get forgotPasswordSubtitle =>
      'Ingresa tu correo electrónico y te enviaremos\nun enlace para restablecer tu contraseña.';

  @override
  String get emailHint => 'tu@correo.com';

  @override
  String get resendLink => 'Reenviar Enlace';

  @override
  String get appName => 'Nakshatralogy';

  @override
  String get cosmicJourneyAwaits => 'Tu Viaje Cósmico Te Espera';

  @override
  String get home => 'Inicio';

  @override
  String get astrologers => 'Astrólogos';

  @override
  String get services => 'Servicios';

  @override
  String get wallet => 'Billetera';

  @override
  String get profile => 'Perfil';

  @override
  String get live => 'En Vivo';

  @override
  String get kundli => 'Kundli';

  @override
  String get chat => 'Chat';

  @override
  String get call => 'Llamada';

  @override
  String get video => 'Video';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get fullName => 'Nombre Completo';

  @override
  String get phone => 'Teléfono';

  @override
  String get forgotPassword => '¿Olvidaste tu Contraseña?';

  @override
  String get sendResetLink => 'Enviar Enlace de Restablecimiento';

  @override
  String get backToSignIn => 'Volver a Iniciar Sesión';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get continueGoogle => 'Continuar con Google';

  @override
  String get required => 'Obligatorio';

  @override
  String get minSixChars => 'Mínimo 6 caracteres';

  @override
  String get passwordsMismatch => 'Las contraseñas no coinciden';

  @override
  String get validEmailRequired => 'Se requiere un correo electrónico válido';

  @override
  String get loginFailed => 'Error al iniciar sesión';

  @override
  String get signupFailed => 'Error al registrarse';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get todaysHoroscope => 'HORÓSCOPO DE HOY';

  @override
  String get todaysRashi => 'Rashi de Hoy';

  @override
  String get tapDetails => 'Toca para más detalles';

  @override
  String get allServices => 'Todos los Servicios';

  @override
  String get seeAll => 'VER TODO';

  @override
  String get topAstrologers => 'Mejores Astrólogos';

  @override
  String get onlineExperts => 'Expertos en línea listos para consultar';

  @override
  String get searchAstrologers => 'Buscar astrólogos...';

  @override
  String get noAstrologersFound => 'No se encontraron astrólogos';

  @override
  String get online => 'En línea';

  @override
  String get offline => 'Fuera de línea';

  @override
  String get busy => 'Ocupado';

  @override
  String get perMin => '/min';

  @override
  String get noCharts => 'Aún no hay cartas natales';

  @override
  String get createFirst => 'Crea tu primer Janam Kundli';

  @override
  String get createChart => 'Crear Carta';

  @override
  String get newBirthChart => 'Nueva Carta Natal';

  @override
  String get clientName => 'Nombre del Cliente';

  @override
  String get gender => 'Género';

  @override
  String get male => 'Masculino';

  @override
  String get female => 'Femenino';

  @override
  String get other => 'Otro';

  @override
  String get dateOfBirth => 'Fecha de Nacimiento';

  @override
  String get timeOfBirth => 'Hora de Nacimiento';

  @override
  String get birthPlace => 'Lugar de Nacimiento';

  @override
  String get birthPlaceHint => 'Escribe el nombre de la ciudad para buscar...';

  @override
  String get generateKundli => 'Generar Kundli';

  @override
  String get birthChartCreated => '¡Carta natal creada!';

  @override
  String get deleteChart => '¿Eliminar Carta?';

  @override
  String get cannotUndo => 'Esto no se puede deshacer.';

  @override
  String get primary => 'PRINCIPAL';

  @override
  String get viewKundli => 'Ver Kundli';

  @override
  String get completeBirthChart => 'Carta Natal Completa';

  @override
  String get birthDetails => 'Detalles de Nacimiento';

  @override
  String get name => 'Nombre';

  @override
  String get dob => 'F. NAC.';

  @override
  String get tob => 'H. NAC.';

  @override
  String get place => 'Lugar';

  @override
  String get summary => 'Resumen';

  @override
  String get planets => 'Planetas';

  @override
  String get divisions => 'Divisiones';

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
  String get aspects => 'Aspectos';

  @override
  String get lifeAreas => 'Áreas de Vida';

  @override
  String get bhava => 'Bhava';

  @override
  String get chakras => 'Chakras';

  @override
  String get dashaActive => 'Dasha Activa';

  @override
  String get lagna => 'Lagna';

  @override
  String get moon => 'Luna';

  @override
  String get sun => 'Sol';

  @override
  String get premiumSection => 'Sección Premium';

  @override
  String get unlockReading =>
      'Desbloquea esta lectura para ver el análisis detallado.';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get retrograde => 'Retrógrado';

  @override
  String get combust => 'Combusto';

  @override
  String get vargottama => 'Vargottama';

  @override
  String get exalted => 'Exaltado';

  @override
  String get debilitated => 'Debilitado';

  @override
  String get addBalance => 'Agregar Saldo';

  @override
  String get amount => 'Monto';

  @override
  String get walletBalance => 'Saldo de la Billetera';

  @override
  String get recharge => 'Recargar';

  @override
  String get bonus => 'Bono';

  @override
  String get serviceLabel => 'Servicio';

  @override
  String get refund => 'Reembolso';

  @override
  String get noTransactions => 'Sin transacciones';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get savedAstrologers => 'Astrólogos Guardados';

  @override
  String get noSavedAstrologers => 'Aún no hay astrólogos guardados';

  @override
  String get myOrders => 'Mis Pedidos';

  @override
  String get communicationHistory => 'Historial de Comunicación';

  @override
  String get chatHistory => 'Historial de Chat';

  @override
  String get callHistory => 'Historial de Llamadas';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get chatMessages => 'Mensajes de Chat';

  @override
  String get typeMessage => 'Escribe un mensaje...';

  @override
  String get sessionEnded => 'Sesión Finalizada';

  @override
  String get endChat => '¿Finalizar Chat?';

  @override
  String get endChatConfirm =>
      '¿Estás seguro de que deseas finalizar esta sesión de chat?';

  @override
  String get sendPhoto => 'Enviar Foto';

  @override
  String get sendPDF => 'Enviar PDF';

  @override
  String get upload => 'Subir';

  @override
  String get fileNotFound => 'Archivo no encontrado';

  @override
  String get voiceCall => 'Llamada de Voz';

  @override
  String get videoCall => 'Videollamada';

  @override
  String get ringing => 'Llamando...';

  @override
  String get connected => 'CONECTADO';

  @override
  String get endCall => 'Finalizar Llamada';

  @override
  String get mute => 'Silenciar';

  @override
  String get unmute => 'Activar Sonido';

  @override
  String get speaker => 'Altavoz';

  @override
  String get camera => 'Cámara';

  @override
  String get flip => 'Voltear';

  @override
  String get liveStreams => 'Transmisiones en Vivo';

  @override
  String get noLiveStreams => 'No hay transmisiones en vivo en este momento';

  @override
  String get astrologerUnavailable =>
      'El astrólogo no está disponible. Finalizando transmisión.';

  @override
  String get streamEnded => 'Transmisión finalizada';

  @override
  String get superChat => 'Super Chat';

  @override
  String get sendGift => 'Enviar un Regalo';

  @override
  String get goBack => 'Regresar';

  @override
  String get appPermissions => 'Permisos de la App';

  @override
  String get grantPermissions => 'Otorgar Permisos';

  @override
  String get skipForNow => 'Omitir por ahora';

  @override
  String get microphone => 'Micrófono';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get storage => 'Almacenamiento';

  @override
  String get ok => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get retry => 'Reintentar';

  @override
  String get send => 'Enviar';

  @override
  String get refresh => 'Actualizar';

  @override
  String get loading => 'Cargando...';

  @override
  String get noData => 'No hay datos disponibles';

  @override
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get myDetails => 'Mis Datos';

  @override
  String get myKundlis => 'Mis Kundlis';

  @override
  String get walletRecharge => 'Billetera y Recarga';

  @override
  String get consultationHistory => 'Historial de Consultas';

  @override
  String get helpSupport => 'Ayuda y Soporte';

  @override
  String get biometricLogin => 'Inicio de Sesión Biométrico';

  @override
  String get pastVoiceConsultations => 'Consultas de voz anteriores';

  @override
  String get pastTextConversations => 'Conversaciones de texto anteriores';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get totalCredit => 'Crédito Total';

  @override
  String get totalDebit => 'Débito Total';

  @override
  String get statement => 'Estado de Cuenta';

  @override
  String get allTypes => 'Todos los tipos';

  @override
  String get prev => 'Anterior';

  @override
  String get next => 'Siguiente';

  @override
  String get allInsights => 'Todas las Perspectivas';

  @override
  String get yourCompleteReading => 'TU LECTURA COMPLETA';

  @override
  String get expertEngines => 'motores expertos';

  @override
  String get eachInsightConsultation =>
      'Cada perspectiva es una consulta completa';

  @override
  String get engines => 'MOTORES';

  @override
  String get dataPoints => 'PUNTOS DE DATOS';

  @override
  String get singleChart => 'ÚNICA';

  @override
  String get careerPurpose => 'CARRERA Y PROPÓSITO';

  @override
  String get wealthAssets => 'RIQUEZA Y ACTIVOS';

  @override
  String get loveRelationships => 'AMOR Y RELACIONES';

  @override
  String get healthWellness => 'SALUD Y BIENESTAR';

  @override
  String get soulKarma => 'ALMA Y KARMA';

  @override
  String get specialistReports => 'Informes Especializados';

  @override
  String get searchByNameSpeciality => 'Buscar por nombre, especialidad...';

  @override
  String get sortedByRating => 'Ordenado por calificación';

  @override
  String get initiatingChat => 'Iniciando chat...';

  @override
  String get startingCall => 'Iniciando llamada...';

  @override
  String get yrs => 'años';

  @override
  String get chatWithAISpecialist => 'Chatear con Especialista de IA';

  @override
  String get tapToStart => 'Toca para comenzar';

  @override
  String get astrologer => 'Astrólogo';

  @override
  String get reports => 'Informes';

  @override
  String get milan => 'Milan';

  @override
  String get forecast => 'Pronóstico';

  @override
  String get rashi => 'Rashi';

  @override
  String get jupiterFavorsBold => 'Júpiter favorece los movimientos audaces';

  @override
  String get careerIlluminated =>
      'Tu sector profesional está iluminado — confía en tus instintos.';

  @override
  String get todaysForecast => 'Pronóstico de Hoy';

  @override
  String get engCareer => 'Carrera y Empleo';

  @override
  String get engBusiness => 'Negocios y Emprendimiento';

  @override
  String get engEducation => 'Educación y Aprendizaje';

  @override
  String get engLifePath => 'Camino de Vida y Fortuna';

  @override
  String get engWealth => 'Riqueza y Finanzas';

  @override
  String get engDebt => 'Deuda y Recuperación';

  @override
  String get engProperty => 'Propiedades y Activos';

  @override
  String get engLegal => 'Legal y Disputas';

  @override
  String get engLove => 'Amor y Romance';

  @override
  String get engMarriage => 'Matrimonio y Familia';

  @override
  String get engKundliMilan => 'Kundli Milan';

  @override
  String get engRelationship => 'Inteligencia de Relaciones';

  @override
  String get engLoveCompat => 'Compatibilidad Amorosa';

  @override
  String get engChildProb => 'Probabilidad de Hijos';

  @override
  String get engHealth => 'Salud y Bienestar';

  @override
  String get engMental => 'Mente y Estrés';

  @override
  String get engCharacter => 'Análisis de Carácter';

  @override
  String get engPastLife => 'Vida Pasada y Karma';

  @override
  String get engKarmaLink => 'Vinculación Kármica';

  @override
  String get noChatSessions => 'Aún No Hay Sesiones de Chat';

  @override
  String get chatAppearHere =>
      'Tus conversaciones con astrólogos aparecerán aquí.';

  @override
  String get noCallsYet => 'Aún No Hay Llamadas';

  @override
  String get callAppearHere =>
      'Tu historial de llamadas con astrólogos aparecerá aquí.';

  @override
  String get chatWith => 'Chatear con';

  @override
  String get msgs => 'mensajes';

  @override
  String get voiceCallLabel => 'Llamada de voz';

  @override
  String get videoCallLabel => 'Videollamada';

  @override
  String get pullToRefresh => 'Desliza hacia abajo para actualizar';

  @override
  String get sessionExpired => 'Sesión expirada';

  @override
  String get connectionFailed => 'Conexión fallida';

  @override
  String get callActive => 'Llamada activa';

  @override
  String get lessThanOneMin => 'Queda menos de 1 minuto';

  @override
  String get noMessages => 'No hay mensajes en esta sesión';

  @override
  String get gocharForAllSigns => 'Gochar de hoy para los 12 signos';

  @override
  String get selectChart => 'Selecciona una carta para analizar';

  @override
  String get selectTwoCharts => 'Selecciona dos cartas';

  @override
  String get analyzing => 'Analizando...';

  @override
  String get browseAstrologers => 'Explorar Astrólogos';

  @override
  String get probableNumber => 'NÚMERO PROBABLE';

  @override
  String get genderTendency => 'TENDENCIA DE GÉNERO';

  @override
  String get son => 'HIJO';

  @override
  String get daughter => 'HIJA';

  @override
  String get occupants => 'OCUPANTES';

  @override
  String get beneficAspects => 'ASPECTOS BENÉFICOS';

  @override
  String get maleficAspects => 'ASPECTOS MALÉFICOS';

  @override
  String get nextFavorableWindow => 'PRÓXIMA VENTANA FAVORABLE';

  @override
  String get totalDoshaPenalty => 'PENALIZACIÓN TOTAL DE DOSHA';

  @override
  String get cancellationFactors => 'FACTORES DE CANCELACIÓN';

  @override
  String get combinedFertility => 'INDICACIÓN DE FERTILIDAD COMBINADA';

  @override
  String get planetPositions => 'POSICIONES PLANETARIAS';

  @override
  String get bestWindows => 'MEJORES VENTANAS';

  @override
  String get worstWindows => 'PEORES VENTANAS';

  @override
  String get scoreComponents => 'COMPONENTES DEL PUNTAJE';

  @override
  String get topOpportunities => 'PRINCIPALES OPORTUNIDADES';

  @override
  String get topRisks => 'PRINCIPALES RIESGOS';

  @override
  String get remedies => 'REMEDIOS';

  @override
  String get keyInsights => 'PERSPECTIVAS CLAVE';

  @override
  String get overallVerdict => 'VEREDICTO GENERAL';

  @override
  String get venusContacts => 'CONTACTOS CRUZADOS DE VENUS';

  @override
  String get contact => 'Contacto';

  @override
  String get effect => 'Efecto';

  @override
  String get moonSignCompat => 'COMPATIBILIDAD DE SIGNO LUNAR';

  @override
  String get hisMoon => 'SU LUNA (ÉL)';

  @override
  String get herMoon => 'SU LUNA (ELLA)';

  @override
  String get nakshatraCompat => 'COMPATIBILIDAD DE NAKSHATRA';

  @override
  String get ketuContacts => 'CONTACTOS DE KETU';

  @override
  String get rahuContacts => 'CONTACTOS DE RAHU';

  @override
  String get pastLifeIndication => 'INDICACIÓN DE VIDA PASADA';

  @override
  String get totalChallengePenalty => 'PENALIZACIÓN TOTAL POR DESAFÍOS';

  @override
  String get manifestation => 'MANIFESTACIÓN';

  @override
  String get cancellation => 'CANCELACIÓN';

  @override
  String get navigation => 'NAVEGACIÓN';

  @override
  String get potentialStrengths => 'FORTALEZAS POTENCIALES';

  @override
  String get areasToNurture => 'ÁREAS A CULTIVAR';

  @override
  String get relationshipGuidance => 'GUÍA DE RELACIÓN';

  @override
  String get detailedSummary => 'RESUMEN DETALLADO';

  @override
  String get discussWithAI => 'DISCUTIR CON IA';

  @override
  String get planet => 'Planeta';

  @override
  String get sign => 'Signo';

  @override
  String get house => 'Casa';

  @override
  String get strength => 'Fuerza';

  @override
  String get copy => 'COPIAR';

  @override
  String get confidence => 'CONFIANZA';

  @override
  String get d7Saptamsa => 'D7 SAPTAMSA';

  @override
  String get numberExplanation => 'EXPLICACIÓN DEL NÚMERO';

  @override
  String get genderExplanation => 'EXPLICACIÓN DEL GÉNERO';

  @override
  String get inFifth => '¿En la 5ª?';

  @override
  String get primaryArchetype => 'ARQUETIPO PRINCIPAL';

  @override
  String get mitigation => 'MITIGACIÓN';

  @override
  String get soulCareerAlign => 'Alineación Alma ↔ Carrera';

  @override
  String get favorablePeriods => 'Períodos Favorables';

  @override
  String get challengingPeriods => 'Períodos Desafiantes';

  @override
  String get keyHouses => 'Casas Clave';

  @override
  String get keyPlanets => 'Planetas Clave';

  @override
  String get characterOverview => 'Resumen de Carácter';

  @override
  String get noYogasActive => 'No hay yogas activos actualmente en esta carta.';

  @override
  String get basedOnPlanetStrengths =>
      'Basado en fuerzas planetarias y ubicaciones en casas';

  @override
  String get basedOnTransits => 'Basado en tránsitos planetarios actuales';

  @override
  String get currentPlanetPositions =>
      'Posiciones actuales de los planetas con tu signo como casa 1';

  @override
  String get favorablePeriodAdvice =>
      'Período favorable — enfócate en el crecimiento profesional y las relaciones.';

  @override
  String get noClassicalYogas =>
      'Sin yogas educativos clásicos, el éxito viene del esfuerzo constante.';

  @override
  String get walletDeduction => 'El monto se deducirá de tu billetera';

  @override
  String get bhakootAxis => 'EJE BHAKOOT';

  @override
  String get basis => 'BASE';

  @override
  String get selectChartsForMilan =>
      'Selecciona 2 Cartas para el Análisis de Milan';

  @override
  String get selectMultiCharts => 'Selecciona de 2 a 5 Cartas';

  @override
  String get running => 'EN CURSO';

  @override
  String get past => 'pasado';

  @override
  String get topActiveDoshas => 'PRINCIPALES DOSHAS ACTIVOS';

  @override
  String get allDoshas => 'TODOS LOS DOSHAS';

  @override
  String get activeYogas => 'Yogas Activos';

  @override
  String get activeDoshas => 'Doshas Activos';

  @override
  String get yogaAnalysis => 'Análisis de Yoga';

  @override
  String get factors => 'Factores';

  @override
  String get dominantPlanet => 'Planeta Dominante';

  @override
  String get startSession => 'Iniciar Sesión';

  @override
  String get notesSaved => 'Notas guardadas';

  @override
  String get unlocked => '¡Desbloqueado! Disfruta tu lectura.';

  @override
  String get todaysGochar => 'Gochar de Hoy';

  @override
  String get todaysTransitChart => 'Carta de Tránsito de Hoy';

  @override
  String get lifeAreaPredictions => 'Predicciones por Área de Vida';

  @override
  String get strengths => 'Fortalezas';

  @override
  String get weaknesses => 'Debilidades';

  @override
  String get ruledBy => 'Regido por';

  @override
  String get kundliMilan => 'Kundli Milan';

  @override
  String get startKundliMilan => 'Iniciar Kundli Milan';

  @override
  String get recommendations => 'Recomendaciones';

  @override
  String get cancellations => 'Cancelaciones';

  @override
  String get dashaSync => 'Sincronía de Dasha';

  @override
  String get transitMarriageWindows => 'Ventanas Matrimoniales de Tránsito';

  @override
  String get overlappingWindows => 'Ventanas Matrimoniales Superpuestas';

  @override
  String get overallStrength => 'FUERZA GENERAL';

  @override
  String get stability => 'ESTABILIDAD';

  @override
  String get growth => 'CRECIMIENTO';

  @override
  String get clarity => 'CLARIDAD';

  @override
  String get recognition => 'RECONOCIMIENTO';

  @override
  String get satisfaction => 'SATISFACCIÓN';

  @override
  String get verdict => 'VEREDICTO';

  @override
  String get topRoles => 'MEJORES ROLES';

  @override
  String get areasForGrowth => 'ÁREAS DE CRECIMIENTO';

  @override
  String get bestIndustries => 'MEJORES INDUSTRIAS';

  @override
  String get employment => 'Empleo';

  @override
  String get entrepreneurship => 'Emprendimiento';

  @override
  String get freelance => 'Freelance';

  @override
  String get portfolio => 'Cartera';

  @override
  String get burnoutRisk => 'Riesgo de Agotamiento';

  @override
  String get careerStagnation => 'Estancamiento Profesional';

  @override
  String get workplaceConflict => 'Conflicto Laboral';

  @override
  String get positioning => 'POSICIONAMIENTO';

  @override
  String get skillDevelopment => 'DESARROLLO DE HABILIDADES';

  @override
  String get network => 'RED DE CONTACTOS';

  @override
  String get visibility => 'VISIBILIDAD';

  @override
  String get lagnaLord => 'Señor del Lagna';

  @override
  String get tenthLord => 'Señor de la Casa 10';

  @override
  String get lord => 'SEÑOR';

  @override
  String get lordPlacedIn => 'SEÑOR UBICADO EN';

  @override
  String get lordDignity => 'DIGNIDAD DEL SEÑOR';

  @override
  String get d9Dignity => 'DIGNIDAD D9';

  @override
  String get careerAnalysis => 'Análisis de Carrera';

  @override
  String get launchWindows => 'Ventanas de Lanzamiento';

  @override
  String get peakWindows => 'Ventanas Pico';

  @override
  String get promotionWindows => 'Ventanas de Ascenso';

  @override
  String get riskWindows => 'Ventanas de Riesgo';

  @override
  String get timingWindows => 'Ventanas de Timing';

  @override
  String get careerRisks => 'Riesgos Profesionales';

  @override
  String get astrologicalRemedies => 'Remedios Astrológicos';

  @override
  String get practicalSolutions => 'Soluciones Prácticas';

  @override
  String get analysisConfidence => 'Confianza del Análisis';

  @override
  String get careerArchetype => 'Arquetipo Profesional';

  @override
  String get workStructure => 'Estructura de Trabajo';

  @override
  String get teamLeadership => 'Liderazgo de Equipo';

  @override
  String get idealEnvironment => 'Ambiente Ideal';

  @override
  String get idealOrgSize => 'Tamaño Ideal de Organización';

  @override
  String get fitScore => 'PUNTAJE DE AFINIDAD';

  @override
  String get recommended => 'RECOMENDADO';

  @override
  String get divisionalValidation => 'Validación Divisional';

  @override
  String get houseAnalysis => 'Análisis de Casas';

  @override
  String get jaiminiKarakas => 'Karakas de Jaimini';

  @override
  String get copyFullReport => 'Copiar los datos completos del informe';

  @override
  String get reportCopied => '¡Datos del informe copiados!';

  @override
  String get biometricNotAvailable =>
      'La biometría no está disponible en este dispositivo';

  @override
  String biometricErrorMsg(Object error) {
    return 'Error de biometría: $error';
  }

  @override
  String get biometricVerifyReason =>
      'Verifica para activar el inicio de sesión biométrico';

  @override
  String get dobFormatLabel => 'Fecha de nacimiento (DD/MM/YYYY)';

  @override
  String get tobFormatLabel => 'Hora de nacimiento (HH:MM)';

  @override
  String get phoneLabel => 'Teléfono';

  @override
  String get activeBadge => 'ACTIVO';

  @override
  String get chartCategoryLabel => 'Categoría';

  @override
  String get freePrimaryDescription =>
      'Principal Gratuito — se usa para el horóscopo diario y servicios de carta única gratuitos';

  @override
  String get searchChartsHint => 'Buscar por nombre o fecha de nacimiento...';

  @override
  String unlockPriceLabel(Object price) {
    return 'Desbloquear por $price';
  }

  @override
  String unlockAiSpecialistIntl(Object price) {
    return 'Desbloquea este especialista de IA por $price (una vez), comprado de forma segura a través de la tienda de aplicaciones.';
  }

  @override
  String unlockAiSpecialistWallet(Object price) {
    return 'Desbloquea este especialista de IA por $price (una vez). El monto se deducirá de tu billetera.';
  }

  @override
  String get specialistNotAvailablePurchase =>
      'Este especialista aún no está disponible para comprar.';

  @override
  String get couldNotCompletePurchase =>
      'No se pudo completar la compra. Inténtalo de nuevo.';

  @override
  String get couldNotUnlockWalletBalance =>
      'No se pudo desbloquear (verifica el saldo de tu billetera)';

  @override
  String get freeBadge => 'GRATIS';

  @override
  String activeSessionInProgress(Object kind) {
    return 'Tienes un(a) $kind activo en curso';
  }

  @override
  String get returnLabel => 'Volver';

  @override
  String get enableNotificationsForAlerts =>
      'Activa las notificaciones para recibir alertas de consultas y ofertas';

  @override
  String get enableLabel => 'Activar';

  @override
  String get notificationsEnabled => 'Notificaciones activadas';

  @override
  String get couldNotEnableNotifications =>
      'No se pudo activar — permite las notificaciones en tu navegador';

  @override
  String get amountInrLabel => 'Monto (₹)';

  @override
  String get noteOptionalLabel => 'Nota (opcional)';

  @override
  String get txnDate => 'FECHA';

  @override
  String get txnDescription => 'DESCRIPCIÓN';

  @override
  String get txnType => 'TIPO';

  @override
  String get txnAmount => 'MONTO';

  @override
  String get txnBalance => 'SALDO';

  @override
  String get credit => 'Crédito';

  @override
  String get debit => 'Débito';

  @override
  String get razorpayStripeNote =>
      '💳 En producción, esto redirigirá a Razorpay/Stripe.';

  @override
  String get downloadPdf => 'Descargar PDF';

  @override
  String get chatWithAiCta => 'Chatear con IA';

  @override
  String get pdfServiceUnavailable =>
      'El servicio de PDF no está disponible temporalmente. Inténtalo de nuevo más tarde.';

  @override
  String get pleaseUnlockFirst => 'Por favor, desbloquea esto primero.';

  @override
  String get couldNotGeneratePdf =>
      'No se pudo generar el PDF. Inténtalo de nuevo.';

  @override
  String get statConsults => 'CONSULTAS';

  @override
  String get statCharts => 'GRÁFICOS';

  @override
  String get statWallet => 'BILLETERA';

  @override
  String get firstChartPrimaryInfo =>
      'Tu primera carta es tu Principal gratuita. Las cartas adicionales desbloquean servicios individualmente.';

  @override
  String get tryDifferentFilter => 'Prueba un filtro diferente';

  @override
  String get defaultChartName => 'Carta';

  @override
  String get balAbbr => 'Saldo';

  @override
  String get aiTimePassTitle => 'Elige tu tiempo de chat';

  @override
  String get aiTimePassHint =>
      'Se paga desde tu billetera. El tiempo empieza ahora; si compras de nuevo, se suma al tiempo restante.';

  @override
  String aiTimePlanMinutes(Object minutes) {
    return '$minutes min';
  }

  @override
  String aiTimePassPay(Object price) {
    return 'Pagar $price';
  }

  @override
  String aiTimeLeft(Object minutes) {
    return 'Quedan $minutes min';
  }
}
