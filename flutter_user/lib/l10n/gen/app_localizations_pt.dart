// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get awChooseLanguage => 'Escolha seu idioma';

  @override
  String get awGoogleFailed => 'Falha ao entrar com o Google. Tente novamente.';

  @override
  String get awCompleteProfileTitle => 'Complete seu perfil';

  @override
  String awWelcomeName(String name) {
    return 'Bem-vindo, $name!';
  }

  @override
  String get awCompleteProfileSubtitle =>
      'Alguns detalhes para personalizar o Nakshatralogy para você.';

  @override
  String get awRegionLabel => 'Região';

  @override
  String get awRegionIndia => 'Índia';

  @override
  String get awRegionInternational => 'Internacional';

  @override
  String get awPreferredLanguage => 'Idioma preferido';

  @override
  String get awFinishSetup => 'Concluir configuração';

  @override
  String get awChatFileWebUnsupported =>
      'O compartilhamento de arquivos ainda não está disponível na web. Use o aplicativo móvel.';

  @override
  String get awVideoUnsupported =>
      'Chamadas de vídeo não são compatíveis com este navegador. Use nosso aplicativo móvel ou um navegador de desktop compatível.';

  @override
  String get awClose => 'Fechar';

  @override
  String get pwPremiumTitle => 'Relatório Premium';

  @override
  String get pwLockedSubtitle => 'Desbloqueie a análise completa deste mapa';

  @override
  String pwUnlockFull(Object name) {
    return 'Desbloquear $name completo';
  }

  @override
  String pwUnlockPrice(Object price) {
    return 'Desbloquear · $price';
  }

  @override
  String get pwOneTime => 'Desbloqueio único — seu para sempre neste mapa';

  @override
  String get pwWhatYouGet => 'O que você recebe';

  @override
  String get pwYourBalance => 'Seu saldo da carteira';

  @override
  String get pwInsufficient => 'Saldo insuficiente';

  @override
  String get pwRechargeToUnlock => 'Recarregue para desbloquear';

  @override
  String get pwRechargeAmount => 'Valor da recarga (₹)';

  @override
  String get pwAddMoney => 'Adicionar dinheiro';

  @override
  String get pwRechargeDone => 'Carteira recarregada';

  @override
  String get pwRechargeFailed => 'Falha na recarga. Tente novamente.';

  @override
  String get pwUnlockFailed => 'Não foi possível desbloquear. Tente novamente.';

  @override
  String get pwUnlockedNow => 'Desbloqueado! Carregando seu relatório…';

  @override
  String get pwProcessing => 'Processando…';

  @override
  String get pwPrimaryNoDelete =>
      'Seu Kundli Principal não pode ser excluído — ele é gratuito para sempre.';

  @override
  String get pwPrimaryNoEdit => 'Seu Kundli Principal não pode ser editado.';

  @override
  String get pwLoadingAccess => 'Verificando acesso…';

  @override
  String get pwMaybeLater => 'Talvez depois';

  @override
  String get updatePhoto => 'Atualizar Foto';

  @override
  String get takePhoto => 'Câmera';

  @override
  String get chooseFromGallery => 'Galeria';

  @override
  String get removePhoto => 'Remover Foto';

  @override
  String get photoUpdated => 'Foto atualizada';

  @override
  String get photoUploadFailed =>
      'Não foi possível enviar a foto. Tente novamente.';

  @override
  String get tapToChangePhoto => 'Toque para trocar a foto';

  @override
  String get klSubtitle =>
      'Relatório Védico de Ligação Cármica de Vidas Passadas com IA';

  @override
  String get klTitle => 'Ligação Cármica de Vidas Passadas';

  @override
  String get klSnapshotHeader => 'Resumo da Ligação Cármica';

  @override
  String get klGaugePairwise => 'Ligação Média entre Pares';

  @override
  String get klGaugeCohesion => 'Coesão do Grupo';

  @override
  String get klGaugeRahuKetu => 'Ressonância Rahu-Ketu';

  @override
  String get klGaugeAtmakaraka => 'Ressonância da Alma';

  @override
  String get klGaugeD60 => 'Ressonância D60';

  @override
  String get klChipSoulResonance => 'Forte ressonância da assinatura da alma';

  @override
  String get klChipD60Resonance => 'Forte ressonância de vidas passadas no D60';

  @override
  String get klChipCohesiveGroup => 'Grupo coeso';

  @override
  String get klChipNoDebts => 'Nenhuma dívida cármica detectada';

  @override
  String get klProfilesTitle => 'Perfis dos Mapas';

  @override
  String get klKetuAt => 'Ketu em';

  @override
  String get klRahuAt => 'Rahu em';

  @override
  String get klFoundationTitle => 'Fundação Cármica por Mapa';

  @override
  String get klFoundationSubtitle =>
      'A maestria de vidas passadas e a direção da vida atual de cada alma';

  @override
  String get klKetuMastery => 'Maestria de Ketu';

  @override
  String get klRahuGrowth => 'Crescimento de Rahu';

  @override
  String get klNinthHousePunya => 'Punya da Casa 9';

  @override
  String get klD60Depth => 'Profundidade Cármica D60';

  @override
  String get klAtmakarakaAgenda => 'Agenda da alma';

  @override
  String get klSaturnKarma => 'Carma de Saturno';

  @override
  String get klPairwiseTitle => 'Ligações Cármicas entre Pares';

  @override
  String get klActiveFactors => 'Fatores de ligação ativos';

  @override
  String get klGroupPatternTitle => 'Padrão Cármico do Grupo';

  @override
  String get klSharedSetting => 'Cenário Compartilhado de Vida Passada';

  @override
  String get klCohesionScore => 'Coesão Cármica';

  @override
  String get klPastGoalsTitle => 'Objetivos de Vidas Passadas';

  @override
  String get klLearningTitle => 'Aprendizado da Vida Atual';

  @override
  String get klTeachingMap => 'Mapa de Ensino Mútuo';

  @override
  String get klDebtsTitle => 'Dívidas Cármicas e Resoluções';

  @override
  String get klNoDebtsDetected =>
      'Nenhuma dívida cármica detectada neste grupo';

  @override
  String get klTimingTitle => 'Timing Cármico da Moola Dasha';

  @override
  String get klAuditTitle => 'Tabela de Auditoria Detalhada';

  @override
  String klAuditSubtitle(Object count) {
    return '$count parâmetros cármicos examinados';
  }

  @override
  String get klTopicLinkage => 'Nossa ligação cármica geral';

  @override
  String get klTopicPairwise => 'O vínculo cármico de um par específico';

  @override
  String get klTopicDebts => 'Dívidas cármicas a resolver';

  @override
  String get klTopicLessons => 'O que viemos aprender';

  @override
  String get klTopicTiming => 'Melhor momento para o nosso grupo';

  @override
  String get klTopicGroup => 'Nossa história compartilhada de vidas passadas';

  @override
  String get lcSubtitle => 'Relatório Védico de Compatibilidade Amorosa com IA';

  @override
  String get lcTitle => 'Compatibilidade Amorosa';

  @override
  String get lcSnapshotHeader => 'Resumo da Compatibilidade Amorosa';

  @override
  String get lcGaugeAttraction => 'Atração';

  @override
  String get lcGaugeEmotional => 'Harmonia Emocional';

  @override
  String get lcGaugeMental => 'Sintonia Mental';

  @override
  String get lcGaugePassion => 'Paixão';

  @override
  String get lcGaugeLongterm => 'Harmonia de Longo Prazo';

  @override
  String get lcChipStrongMental => 'Forte conexão mental';

  @override
  String get lcChipStrongLongterm => 'Forte potencial de longo prazo';

  @override
  String get lcChipStrongPassion => 'Forte química física';

  @override
  String get lcChipLowFriction => 'Baixo atrito no geral';

  @override
  String get lcChipKarmicPull => 'Forte atração cármica';

  @override
  String get lcPartnersTitle => 'Resumo dos Parceiros';

  @override
  String get lcVenusSuffix => 'Signo de Vênus';

  @override
  String get lcAttractionTitle => 'Atração e Química';

  @override
  String get lcAttractionScore => 'Pontuação de Atração';

  @override
  String get lcActiveContacts => 'Contatos Ativos de Vênus';

  @override
  String get lcEmotionalTitle => 'Harmonia Emocional';

  @override
  String get lcEmotionalScore => 'Pontuação de Harmonia Emocional';

  @override
  String get lcNakshatraCompat => 'Compatibilidade de Nakshatra';

  @override
  String get lcYoniKoota => 'Yoni Koota';

  @override
  String get lcGanaKoota => 'Gana Koota';

  @override
  String get lcTaraKoota => 'Tara Koota';

  @override
  String get lcBhakootAxis => 'Eixo Bhakoot';

  @override
  String get lcMentalTitle => 'Sintonia Mental';

  @override
  String get lcMentalScore => 'Pontuação de Sintonia Mental';

  @override
  String get lcPassionTitle => 'Paixão e Físico';

  @override
  String get lcPassionScore => 'Pontuação de Paixão';

  @override
  String get lcLongtermTitle => 'Harmonia de Longo Prazo';

  @override
  String get lcLongtermScore => 'Pontuação de Harmonia de Longo Prazo';

  @override
  String get lcCommitmentPotential => 'Potencial de Compromisso';

  @override
  String get lc7thHouseSynastry => 'Sinastria da Casa 7';

  @override
  String get lcJupiterBlessing => 'Bênção de Júpiter';

  @override
  String get lcD9Resonance => 'Ressonância D9 Navamsa';

  @override
  String get lcSaturnLongevity => 'Longevidade de Saturno';

  @override
  String get lcKarmicTitle => 'Vínculo Amoroso Cármico';

  @override
  String get lcKarmicScore => 'Pontuação do Vínculo Cármico';

  @override
  String get lcKetuContacts => 'Contatos de Ketu';

  @override
  String get lcRahuContacts => 'Contatos de Rahu';

  @override
  String get lcChallengesTitle => 'Desafios e Atritos';

  @override
  String get lcNoChallenges =>
      'Nenhum ponto de atrito significativo detectado em nenhum dos mapas';

  @override
  String get lcTotalPenalty => 'Penalidade Total de Desafios';

  @override
  String get lcTimingTitle => 'Timing Amoroso — Moola Dasha';

  @override
  String get lcDynamicsTitle => 'Dinâmica do Relacionamento';

  @override
  String get lcPowerBalance => 'Equilíbrio de Poder';

  @override
  String get lcGiverReceiver => 'Doador/Receptor Emocional';

  @override
  String get lcGrowthDynamic => 'Dinâmica de Crescimento';

  @override
  String get lcAreasToNurture => 'Áreas a Cultivar';

  @override
  String get lcTopicTiming => 'Melhor momento para nosso relacionamento';

  @override
  String get lcTopicChallenges => 'Desafios a enfrentar';

  @override
  String get lcTopicKarmic => 'Nossa conexão cármica';

  @override
  String get lcTopicRemedies => 'Remédios recomendados';

  @override
  String get lcTopicLongterm => 'Nosso potencial de longo prazo';

  @override
  String get lcTopicDynamics => 'A dinâmica do nosso relacionamento';

  @override
  String get cpSubtitle => 'Relatório Védico de Probabilidade de Filhos com IA';

  @override
  String get cpTitle => 'Probabilidade de Filhos';

  @override
  String get cpSnapshotHeader => 'Resumo da Probabilidade de Prole';

  @override
  String get cpGauge5thHouse => 'Casa 5';

  @override
  String get cpGaugeJupiter => 'Júpiter/Putrakaraka';

  @override
  String get cpGaugeD7 => 'D7 Saptamsa';

  @override
  String get cpGaugeSphuta => 'Beeja-Kshetra';

  @override
  String get cpGaugeTiming => 'Timing da Dasha';

  @override
  String get cpChipStrongPutrakaraka => 'Forte Putrakaraka (Júpiter)';

  @override
  String get cpChipLowDoshaPenalty => 'Baixa penalidade de dosha';

  @override
  String get cpChipFavorableTiming => 'Timing de dasha favorável';

  @override
  String get cpChipNoDoshas => 'Nenhum dosha de prole detectado';

  @override
  String get cpPartnersTitle => 'Resumo dos Parceiros';

  @override
  String get cpLagnaSuffix => 'Lagna';

  @override
  String get cpMoonSuffix => 'Signo lunar';

  @override
  String get cpNumberTitle => 'Número de Filhos e Tendência de Gênero';

  @override
  String get cpProbableNumber => 'Número Provável';

  @override
  String get cpFirstChildTendency => 'Tendência do Primeiro Filho';

  @override
  String get cpSpacing => 'Nota sobre Espaçamento';

  @override
  String get cpTimingTitle => 'Timing — Moola Dasha';

  @override
  String get cpCombinedTiming => 'Timing Combinado';

  @override
  String get cpNextWindow => 'Próxima Janela Favorável';

  @override
  String get cp5thHouseTitle => 'Análise da Casa 5';

  @override
  String get cp5thHouseSubtitle =>
      'A casa dos filhos (Putra Bhava), por pessoa';

  @override
  String get cpJupiterTitle => 'Júpiter — Análise do Putrakaraka';

  @override
  String get cpJupiterSubtitle =>
      'O significador natural dos filhos, por pessoa';

  @override
  String get cpD7Title => 'Análise do D7 Saptamsa';

  @override
  String get cpD7Subtitle => 'O mapa divisional específico para os filhos';

  @override
  String get cpD7Strength => 'Força do D7';

  @override
  String get cpSphutaTitle => 'Beeja e Kshetra Sphuta';

  @override
  String get cpBeejaSphuta => 'Beeja Sphuta (Semente)';

  @override
  String get cpKshetraSphuta => 'Kshetra Sphuta (Campo)';

  @override
  String get cpDoshaTitle => 'Análise de Dosha';

  @override
  String get cpNoDoshasDetected =>
      'Nenhum dosha relevante à prole detectado em nenhum dos mapas';

  @override
  String get cpRemediesTitle => 'Remédios Recomendados';

  @override
  String get cpAddresses => 'Aborda';

  @override
  String get cpTopicTiming => 'Melhor momento para conceber';

  @override
  String get cpTopicNumber => 'Quantos filhos podemos ter';

  @override
  String get cpTopicDosha => 'Doshas a serem tratados';

  @override
  String get cpTopicRemedies => 'Remédios recomendados';

  @override
  String get cpTopicFifthHouse => 'A força da nossa Casa 5';

  @override
  String get cpTopicJupiter => 'O papel de Júpiter nisso';

  @override
  String get riSubtitle =>
      'Relatório Védico de Inteligência de Relacionamento com IA';

  @override
  String get riTitle => 'Inteligência de Relacionamento';

  @override
  String get riSnapshotHeader => 'Resumo do Grupo';

  @override
  String get riGaugeCohesion => 'Coesão do Grupo';

  @override
  String get riGaugeTrust => 'Clima de Confiança';

  @override
  String get riGaugeProductivity => 'Produtividade';

  @override
  String get riGaugeCreativity => 'Criatividade';

  @override
  String get riChipNoAlerts => 'Nenhum alerta crítico';

  @override
  String get riChipStrongCohesion => 'Forte coesão do grupo';

  @override
  String get riChipHighTrust => 'Alto clima de confiança';

  @override
  String get riChipNoHiddenEnemy => 'Nenhum sinal de inimigo oculto';

  @override
  String get riChipHealthyGroup => 'Grupo saudável em geral';

  @override
  String get riProfilesTitle => 'Perfis dos Mapas';

  @override
  String riProfilesSubtitle(Object count) {
    return '$count pessoas neste grupo';
  }

  @override
  String get riLagnaSuffix => 'Lagna';

  @override
  String get riIntegrity => 'Integridade';

  @override
  String get riWarmth => 'Calor Humano';

  @override
  String get riTrustworthiness => 'Confiabilidade';

  @override
  String get riAssertiveness => 'Assertividade';

  @override
  String get riGroupDynamicsTitle => 'Visão Geral da Dinâmica do Grupo';

  @override
  String get riMostSupportive => 'Mais Solidário';

  @override
  String get riMostChallenged => 'Mais Desafiado';

  @override
  String get riHiddenEnemyAlert => 'Sinal de Inimigo Oculto Detectado';

  @override
  String get riBestWorstTitle => 'Pares Melhores e Mais Desafiadores';

  @override
  String get riBestPair => 'VÍNCULO MAIS FORTE';

  @override
  String get riWorstPair => 'PRECISA DE ATENÇÃO';

  @override
  String get riAlliances => 'Alianças Prováveis';

  @override
  String get riConflicts => 'Pontos de Atrito Prováveis';

  @override
  String get riPairwiseTitle => 'Análise entre Pares';

  @override
  String riPairwiseSubtitle(Object count) {
    return '$count pares analisados';
  }

  @override
  String get riDynamic => 'Dinâmica';

  @override
  String get riKarmicLink => 'Ligação cármica';

  @override
  String get riMutualTrust => 'Confiança mútua';

  @override
  String get riBetrayalRisk => 'Risco de traição';

  @override
  String get riPowerDistribution => 'Distribuição de poder';

  @override
  String get riPowerHealth => 'Saúde do equilíbrio de poder';

  @override
  String get riCriticalPatternsTitle => 'Padrões Críticos';

  @override
  String get riGroupRecsTitle => 'Recomendações para o Grupo';

  @override
  String get riSharedPractices => 'Práticas Compartilhadas';

  @override
  String get riCommStyle => 'Estilo de Comunicação Recomendado';

  @override
  String get riGrowthFocus => 'Foco de Crescimento Recomendado';

  @override
  String get riIndividualTitle => 'Orientação Individual';

  @override
  String get riBestAllies => 'Melhores Aliados';

  @override
  String get riHandleWithCare => 'Tratar com Cuidado';

  @override
  String get riCoreThemeTitle => 'Tema Central do Grupo';

  @override
  String get riLayerPairwise => 'Completude entre Pares';

  @override
  String get riLayerD1 => 'Mapa Natal (D1)';

  @override
  String get riLayerD9 => 'Navamsa (D9)';

  @override
  String get riLayerD10 => 'Dashamsa (D10)';

  @override
  String get riLayerD30 => 'Trimshamsa (D30)';

  @override
  String get riLayerJaimini => 'Sinal Jaimini';

  @override
  String get riLayerBehavior => 'Clareza Comportamental';

  @override
  String get riLayerCoherence => 'Coerência do Grupo';

  @override
  String get riTopicDynamics => 'A dinâmica do nosso grupo';

  @override
  String get riTopicPairwise => 'A compatibilidade de um par específico';

  @override
  String get riTopicAlerts => 'Alertas críticos';

  @override
  String get riTopicGrowth => 'Como podemos crescer juntos';

  @override
  String get riTopicRecs => 'Práticas recomendadas';

  @override
  String get riTopicTheme => 'O tema central do nosso grupo';

  @override
  String get kmSubtitle => 'Relatório Védico de Kundli Milan com IA';

  @override
  String get kmTitle => 'Kundli Milan';

  @override
  String get kmSnapshotHeader => 'Resumo da Compatibilidade';

  @override
  String kmAshtakootScore(Object score) {
    return 'Ashtakoot: $score/36';
  }

  @override
  String get kmGaugeAshtakoot => 'Ashtakoot %';

  @override
  String get kmGaugeD9 => 'Carma Matrimonial D9';

  @override
  String get kmGaugeMangal => 'Equilíbrio de Mangal';

  @override
  String get kmGaugePapa => 'Equilíbrio Cármico';

  @override
  String get kmGaugeAk => 'Ressonância da Alma';

  @override
  String get kmChipNoNadi => 'Sem Nadi Dosh';

  @override
  String get kmChipNoBhakoot => 'Sem Bhakoot Dosh';

  @override
  String get kmChipMangalCancelled => 'Mangal Dosh cancelado';

  @override
  String get kmChipPapaBalanced => 'Carga cármica equilibrada';

  @override
  String get kmChipStrongChemistry => 'Forte química física';

  @override
  String get kmChipStrongD9 => 'Forte carma matrimonial D9';

  @override
  String get kmChipLongevity => 'Forte alinhamento de longevidade';

  @override
  String get kmAshtakootTitle => 'Ashtakoot Guna Milan';

  @override
  String get kmAshtakootSubtitle =>
      'O sistema clássico de compatibilidade de 8 pontos, num total de 36';

  @override
  String get kmNadiSeverity => 'Severidade do Nadi';

  @override
  String get kmBhakootSeverity => 'Severidade do Bhakoot';

  @override
  String get kmGanaSignature => 'Assinatura Gana';

  @override
  String get kmMangalTitle => 'Verificação de Mangal Dosha';

  @override
  String get kmD9Title => 'D9 Navamsa — Carma Matrimonial';

  @override
  String get kmD9Subtitle =>
      'O mapa matrimonial no nível da alma, considerado o mais importante classicamente';

  @override
  String get kmD9Score => 'Compatibilidade D9';

  @override
  String get kmLagnaRelation => 'Relação entre Lagnas';

  @override
  String get km7thLordRelation => 'Relação entre senhores da Casa 7';

  @override
  String get kmKarakasTitle => 'Karakas da Alma e do Cônjuge';

  @override
  String get kmAtmakaraka => 'Planeta da Alma';

  @override
  String get kmAkCompatibility => 'Ressonância da Assinatura da Alma';

  @override
  String get kmUlCompatibility => 'Alinhamento do Karaka do Cônjuge';

  @override
  String get kmUlSigns => 'Senhores do Upapada';

  @override
  String get kmChemistryTitle => 'Química Vênus-Marte';

  @override
  String get kmPhysicalChemistry => 'Química Física';

  @override
  String get kmEmotionalWarmth => 'Calor Emocional';

  @override
  String get kmAestheticAlignment => 'Alinhamento Estético';

  @override
  String get kmElementalSynthesis => 'Síntese Elemental';

  @override
  String get kmHouseCrossTitle => 'Análise Cruzada das Casas 7 e 8';

  @override
  String get km78Compatibility => 'Compatibilidade das Casas 7-8';

  @override
  String get km8thHouseSignature => 'Assinatura Conjunta de Longevidade';

  @override
  String get kmLongevityAlignment => 'Alinhamento de Longevidade';

  @override
  String get km7thLordFriendship => 'Amizade entre senhores da Casa 7';

  @override
  String get kmDomainsTitle => 'Compatibilidade por Domínio';

  @override
  String get kmConflictEngagement => 'Estilo de Conflito';

  @override
  String get kmDashaTitle => 'Sincronia de Dasha e Trânsitos';

  @override
  String get kmDashaSync => 'Sincronia de Dasha';

  @override
  String get kmTransitAlignment => 'Alinhamento de Trânsitos';

  @override
  String get kmTimingTitle => 'Timing do Casamento';

  @override
  String get kmMarriageWindow => 'Janela do Casamento';

  @override
  String get kmEngagementWindow => 'Janela do Noivado';

  @override
  String get kmRecommendedRange => 'Período Recomendado';

  @override
  String get kmMuhurtaNotes => 'Notas de Muhurta';

  @override
  String get kmRisksTitle => 'Riscos a Tratar';

  @override
  String get kmConflictRisk => 'Risco de Conflito';

  @override
  String get kmCommunicationRisk => 'Risco de Comunicação';

  @override
  String get kmFinanceRisk => 'Risco de Conflito Financeiro';

  @override
  String get kmFamilyDynamicsRisk => 'Risco na Dinâmica Familiar';

  @override
  String get kmMentalHealthRisk => 'Risco de Alinhamento de Saúde Mental';

  @override
  String get kmStrengthsTitle => 'Principais Pontos Fortes de Compatibilidade';

  @override
  String get kmSharedGrowth => 'Potencial de Crescimento Compartilhado';

  @override
  String get kmSharedCreative => 'Potencial Criativo Compartilhado';

  @override
  String get kmJourneyTitle => 'Jornada e Crescimento do Relacionamento';

  @override
  String get kmCurrentPhase => 'Fase atual';

  @override
  String get kmEarlyArc => 'Início do Casamento';

  @override
  String get kmMiddleArc => 'Meio do Casamento';

  @override
  String get kmMatureArc => 'Casamento Maduro';

  @override
  String get kmElderArc => 'Anos de Maturidade';

  @override
  String get kmPeakPhase => 'Fase de Pico da Companhia';

  @override
  String get kmGrowthAreas => 'Áreas de Crescimento';

  @override
  String get kmCommProtocols => 'Protocolos de Comunicação';

  @override
  String get kmSharedPractices => 'Práticas Compartilhadas';

  @override
  String get kmImprovementTitle => 'Tema Central e Plano de Melhoria';

  @override
  String get kmVerdictTitle => 'Veredito Final';

  @override
  String get kmRealizationPotential =>
      'Potencial de Realização do Relacionamento';

  @override
  String get kmLayerAshtakoot => 'Ashtakoot';

  @override
  String get kmLayerD9 => 'D9 Navamsa';

  @override
  String get kmLayerMangalPapa => 'Mangal e Papasamya';

  @override
  String get kmLayerVenusMars => 'Vênus-Marte';

  @override
  String get kmLayerDashaSync => 'Sincronia de Dasha';

  @override
  String get kmLayerH7H8 => 'Cruzamento das Casas 7-8';

  @override
  String get kmLayerAkResonance => 'Ressonância do Atmakaraka';

  @override
  String get kmLayerDomains => 'Dimensões de Domínio';

  @override
  String get kmTopicAshtakoot => 'Nossa pontuação de Ashtakoot';

  @override
  String get kmTopicMangal => 'Preocupações com Mangal Dosha';

  @override
  String get kmTopicD9 => 'Nosso carma matrimonial (D9)';

  @override
  String get kmTopicTiming => 'Melhor timing para o casamento';

  @override
  String get kmTopicRisks => 'Riscos a se preparar';

  @override
  String get kmTopicGrowth => 'Como podemos crescer juntos';

  @override
  String get kmTopicRemedies => 'Remédios recomendados';

  @override
  String get kmTopicVerdict => 'Devemos seguir com o casamento';

  @override
  String get pkSubtitle => 'Relatório Védico de Vidas Passadas e Carma com IA';

  @override
  String get pkTitle => 'Vidas Passadas e Carma';

  @override
  String get pkSnapshotHeader => 'Resumo de Vidas Passadas';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return 'Seu mapa mostra uma assinatura de vida passada \'$theme\', atualmente $relation nesta vida. Caminho recomendado: $strategy.';
  }

  @override
  String get pkGaugeSignature => 'Força da Assinatura';

  @override
  String get pkGaugeMasteryPreserved => 'Maestria Preservada';

  @override
  String get pkGaugeClearingProgress => 'Limpeza Cármica';

  @override
  String get pkGaugeMaturity => 'Maturidade de Vida Passada';

  @override
  String get pkGaugeMemoryAccess => 'Acesso à Memória';

  @override
  String get pkChipGoodProgress => 'Bom progresso na limpeza cármica';

  @override
  String get pkChipLowDebt => 'Baixa dívida cármica';

  @override
  String get pkChipMatureSoul => 'Assinatura de alma madura';

  @override
  String get pkChipGiftedPast => 'O mapa carrega um dom de vida passada';

  @override
  String get pkChipAccomplished => 'Vida passada bem-sucedida';

  @override
  String get pkChipMasteryPreserved => 'Forte maestria transportada';

  @override
  String get pkKetuTitle => 'Ketu — Sua Maestria do Passado';

  @override
  String get pkKetuSubtitle => 'Habilidades que sua alma já dominou';

  @override
  String get pkMasteryStrength => 'Força da Maestria';

  @override
  String get pkSkillsCarried => 'Habilidades Transportadas';

  @override
  String get pkInstincts => 'Capacidades Instintivas';

  @override
  String get pkKetuDignity => 'Dignidade de Ketu';

  @override
  String get pkRahuTitle => 'Rahu — O Limite de Crescimento da Sua Alma';

  @override
  String get pkRahuSubtitle => 'O que sua alma veio concluir';

  @override
  String get pkUnmetDesires => 'Desejos Não Realizados';

  @override
  String get pkProfileTitle => 'Seu Perfil de Vida Passada';

  @override
  String get pkProfession => 'Profissão Provável';

  @override
  String get pkSocialStanding => 'Posição Social';

  @override
  String get pkRegion => 'Região Provável';

  @override
  String get pkCulturalArchetype => 'Arquétipo Cultural';

  @override
  String get pkAccomplishment => 'Nível de Realização';

  @override
  String get pkAuthority => 'Nível de Autoridade';

  @override
  String get pkFamilyRole => 'Papel na família';

  @override
  String get pkSecondaryProfession => 'Profissão secundária';

  @override
  String get pkClimateAffinity => 'Afinidade climática';

  @override
  String get pkForeignResidence => 'Carma de residência no exterior';

  @override
  String get pkRelationshipsTitle => 'Relacionamentos Passados Transportados';

  @override
  String get pkSpouseConnection => 'Reconexão com o Cônjuge';

  @override
  String get pkChildrenConnection => 'Reconexão com os Filhos';

  @override
  String get pkCarriedRelationTypes => 'Padrões de Relacionamento';

  @override
  String get pkPartnerArchetype => 'Arquétipo do Parceiro de Vida Passada';

  @override
  String get pkDarakaraka => 'Karaka do cônjuge';

  @override
  String get pkParentsKarma => 'Padrão de carma dos pais';

  @override
  String get pkSiblingKarma => 'Padrão de carma dos irmãos';

  @override
  String get pkSpiritualTitle => 'Sua Vida Espiritual Naquela Época';

  @override
  String get pkSpiritualLevel => 'Nível Espiritual';

  @override
  String get pkPracticeSignature => 'Estilo de Prática';

  @override
  String get pkMeditativeCapacity => 'Capacidade Meditativa';

  @override
  String get pkDevotionalPractice => 'Prática Devocional';

  @override
  String get pkYogicAttainment => 'Realização Iogue';

  @override
  String get pkMokshaProximity => 'Proximidade do Moksha';

  @override
  String get pkKarmicDebtsTitle => 'Dívidas Cármicas e Riqueza na Época';

  @override
  String get pkTotalKarmicDebt => 'Dívida Cármica Total';

  @override
  String get pkPrimaryDebtType => 'Tipo de Dívida Primária';

  @override
  String get pkRelationshipDebt => 'Dívida de Relacionamento';

  @override
  String get pkFinancialDebt => 'Dívida Financeira';

  @override
  String get pkServiceDebt => 'Dívida de Serviço';

  @override
  String get pkDharmicDebt => 'Dívida Dhármica';

  @override
  String get pkPitruKarma => 'Carma Pitru';

  @override
  String get pkMatruKarma => 'Carma Matru';

  @override
  String get pkWealthLevel => 'Nível de Riqueza na Época';

  @override
  String get pkWealthKarmaCarried => 'Carma de Riqueza Transportado';

  @override
  String get pkResourcePattern => 'Gestão de recursos';

  @override
  String get pkGainSource => 'Fonte de ganho';

  @override
  String get pkEchoesTitle => 'Ecos Nesta Vida';

  @override
  String get pkOnRelationships => 'Nos Relacionamentos';

  @override
  String get pkOnCareer => 'Na Carreira';

  @override
  String get pkOnHealth => 'Na Saúde';

  @override
  String get pkOnSpirituality => 'Na Espiritualidade';

  @override
  String get pkDominantArea => 'Herança Mais Forte';

  @override
  String get pkAttractions => 'Atrações Naturais';

  @override
  String get pkAversions => 'Aversões Naturais';

  @override
  String get pkUnexplainedFears => 'Medos Inexplicáveis';

  @override
  String get pkMagneticPulls => 'Atrações Magnéticas';

  @override
  String get pkResolutionTitle => 'Resolução e Conclusão Cármica';

  @override
  String get pkPrimaryPathway => 'Caminho Primário';

  @override
  String get pkSecondaryPathway => 'Caminho Secundário';

  @override
  String get pkClearingProgress => 'Progresso da Limpeza';

  @override
  String get pkRemainingWork => 'Trabalho Restante';

  @override
  String get pkSettlementTimeline => 'Cronograma de Resolução';

  @override
  String get pkAccelerationPractices => 'Práticas Que Aceleram a Resolução';

  @override
  String get pkPriorityAreas => 'Áreas Prioritárias';

  @override
  String get pkVerificationTitle => 'Verificado em Múltiplos Mapas (D60)';

  @override
  String get pkD60Label => 'Era de Vida Passada D60';

  @override
  String get pkD60Ketu => 'Posicionamento de Ketu no D60';

  @override
  String get pkD60Standing => 'Posição geral';

  @override
  String get pkMemoryTitle => 'Memória e Intuição';

  @override
  String get pkMemoryAccess => 'Acesso à Memória';

  @override
  String get pkRegressionFit => 'Aptidão para Terapia de Regressão';

  @override
  String get pkDreamVisits => 'Visitas em Sonhos';

  @override
  String get pkDejaVuFrequency => 'Frequência de Déjà Vu';

  @override
  String get pkSpontaneousRemembrance => 'Lembrança espontânea';

  @override
  String get pkRemembrancePractices => 'Práticas de Lembrança';

  @override
  String get pkTimelineTitle => 'Cronograma de Ativação';

  @override
  String get pkGiftsActivation => 'Ativação dos Dons de Vida Passada';

  @override
  String get pkSurfaceWindow => 'Janela de Emergência';

  @override
  String get pkRisksTitle => 'Riscos e Padrões Crônicos';

  @override
  String get pkTraumaResidue => 'Resíduo de Trauma';

  @override
  String get pkSpiritualBypass => 'Risco de Bypass Espiritual';

  @override
  String get pkMajorRisks => 'Principais Riscos';

  @override
  String get pkChronicImprints => 'Marcas Crônicas';

  @override
  String get pkKarmicLoops => 'Ciclos Cármicos';

  @override
  String get pkImprovementTitle => 'Plano de Melhoria';

  @override
  String get pkRoadmapTitle => 'Seu Roteiro de Vida Passada';

  @override
  String get pkMaturity => 'Maturidade de Vida Passada';

  @override
  String get pkLayerD1 => 'Mapa Natal (D1)';

  @override
  String get pkLayerD9 => 'Navamsa (D9)';

  @override
  String get pkLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get pkLayerKetuDepth => 'Profundidade de Ketu';

  @override
  String get pkLayerAtmakaraka => 'Planeta da Alma (Atmakaraka)';

  @override
  String get pkTopicMastery => 'Minha maestria de vida passada';

  @override
  String get pkTopicUnfinished => 'Meu carma inacabado';

  @override
  String get pkTopicRelationships => 'Meus relacionamentos de vida passada';

  @override
  String get pkTopicDebts => 'Minhas dívidas cármicas';

  @override
  String get pkTopicResolution => 'Como resolver meu carma';

  @override
  String get pkTopicMemory => 'Acesso à memória de vidas passadas';

  @override
  String get pkTopicTiming => 'Melhores janelas de timing';

  @override
  String get pkTopicProfile => 'Quem eu era na minha vida passada';

  @override
  String get chSubtitle => 'Relatório Védico de Análise de Caráter com IA';

  @override
  String get chTitle => 'Análise de Caráter';

  @override
  String get chSnapshotHeader => 'Resumo de Caráter';

  @override
  String get chGaugeIntegrity => 'Integridade';

  @override
  String get chGaugeResilience => 'Resiliência';

  @override
  String get chGaugeSelfAwareness => 'Autoconsciência';

  @override
  String get chGaugeStability => 'Estabilidade Emocional';

  @override
  String get chGaugeMoralFabric => 'Tecido Moral';

  @override
  String get chChipRajaYoga => 'Raja Yoga presente';

  @override
  String get chChipHighIntegrity => 'Alta integridade';

  @override
  String get chChipResilient => 'Natureza resiliente';

  @override
  String get chChipDharmic => 'Forte orientação dhármica';

  @override
  String get chChipEmpathetic => 'Naturalmente empático';

  @override
  String get chChipLoyal => 'Profundamente leal';

  @override
  String get chChipGiftedCharacter => 'O mapa carrega um dom de caráter';

  @override
  String get chSoulTitle => 'Sua Assinatura da Alma';

  @override
  String get chSoulIntegration => 'Integração Alma-Caráter';

  @override
  String get chAmatyakarakaTheme => 'Voz de Apoio ao Caráter';

  @override
  String get chAtmakarakaDignity => 'Dignidade do planeta da alma';

  @override
  String get chAtmakarakaHouse => 'Posicionamento na casa';

  @override
  String get chSurfaceTitle => 'Personalidade Aparente e Constituição';

  @override
  String get chLagnaSign => 'Signo Ascendente';

  @override
  String get chConstitution => 'Constituição';

  @override
  String get chSurfaceSignature => 'Como você é percebido';

  @override
  String get chPhysicalConstitution => 'Constituição Física';

  @override
  String get chLagnaLord => 'Senhor do Ascendente';

  @override
  String get chLagnaOccupants => 'Planetas no Ascendente';

  @override
  String get chMindEmotionsTitle => 'Mente, Emoções e Ego';

  @override
  String get chEmotionalNature => 'Sua Natureza Emocional';

  @override
  String get chMentalStability => 'Estabilidade Mental';

  @override
  String get chSelfConfidence => 'Autoconfiança Saudável';

  @override
  String get chEgoNature => 'Seu Ego e Autoconceito';

  @override
  String get chAuthorityRelationship => 'Relação com a Autoridade';

  @override
  String get chPrideTendency => 'Tendência ao Orgulho';

  @override
  String get chMoodPatterns => 'Padrões de Humor';

  @override
  String get chKemadrumaPresent =>
      'Kemadruma Yoga presente — autocuidado emocional extra é benéfico.';

  @override
  String get chFatherImprint => 'Qualidade da marca paterna';

  @override
  String get chCommunicationTitle => 'Estilo de Comunicação e Intelecto';

  @override
  String get chIntellectStyle => 'Estilo Intelectual';

  @override
  String get chCommStyle => 'Estilo de Comunicação';

  @override
  String get chDecisionStyle => 'Estilo de Tomada de Decisão';

  @override
  String get chDiscrimination => 'Capacidade de Discernimento';

  @override
  String get chPersonaTitle => 'Persona Pública vs Verdadeiro Eu';

  @override
  String get chAuthenticityGap => 'Lacuna de Autenticidade';

  @override
  String get chGunaTitle => 'Perfil de Guna e Dosha';

  @override
  String get chGunaSubtitle =>
      'Sua natureza interior e constituição, no estilo védico clássico';

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
  String get chRahuRestlessness => 'Inquietação de Rahu';

  @override
  String get chKetuDetachment => 'Desapego de Ketu';

  @override
  String get chYogasTitle => 'Yogas de Caráter';

  @override
  String get chRajaYogaStrength => 'Força do Raja Yoga';

  @override
  String get chGiftYogas => 'Yogas de Dom';

  @override
  String get chTestYogas => 'Yogas de Teste';

  @override
  String get chStrengthsTitle => 'Pontos Fortes e Talentos';

  @override
  String get chSignatureVirtues => 'Virtudes Características';

  @override
  String get chNaturalTalents => 'Talentos Naturais';

  @override
  String get chSoftSkills => 'Habilidades Interpessoais';

  @override
  String get chHiddenStrengths => 'Forças Ocultas a Desenvolver';

  @override
  String get chShadowTitle => 'Sombra e Áreas de Crescimento';

  @override
  String get chShadowSubtitle =>
      'Consciência gentil de padrões que valem a pena trabalhar';

  @override
  String get chShadowPatterns => 'Padrões de Sombra';

  @override
  String get chBlindSpots => 'Pontos Cegos';

  @override
  String get chEmotionalWounds => 'Feridas Emocionais';

  @override
  String get chShadowWorkPriorities => 'Prioridades de Trabalho de Sombra';

  @override
  String get chMoralTests => 'Testes Morais';

  @override
  String get chRelationshipsTitle => 'Relacionamentos e Estilo Social';

  @override
  String get chWarmth => 'Calor Interpessoal';

  @override
  String get chEmpathy => 'Capacidade de Empatia';

  @override
  String get chLoyalty => 'Capacidade de Lealdade';

  @override
  String get chBoundaries => 'Estabelecimento de Limites';

  @override
  String get chSocialConfidence => 'Confiança Social';

  @override
  String get chTrustGiving => 'Base de Confiança Concedida';

  @override
  String get chConflictStyle => 'Estilo de conflito';

  @override
  String get chEthicsTitle => 'Ética e Bússola Moral';

  @override
  String get chDharmaOrientation => 'Orientação de Dharma';

  @override
  String get chTruthfulness => 'Veracidade';

  @override
  String get chCompassion => 'Compaixão';

  @override
  String get chGenerosity => 'Generosidade';

  @override
  String get chEthicalConsistency => 'Consistência Ética';

  @override
  String get chIntegrityPressure => 'Integridade sob Pressão';

  @override
  String get chJusticeFairness => 'Justiça e Equidade';

  @override
  String get chMoralTrajectory => 'Desenvolvimento moral';

  @override
  String get chEiTitle => 'Inteligência Emocional';

  @override
  String get chEiSelfAwareness => 'Autoconsciência';

  @override
  String get chEiSelfRegulation => 'Autorregulação';

  @override
  String get chEiEmpathy => 'Empatia';

  @override
  String get chEiSocialSkills => 'Habilidades Sociais';

  @override
  String get chMotivation => 'Motivação Interna';

  @override
  String get chVulnerabilityComfort => 'Conforto com a Vulnerabilidade';

  @override
  String get chEmotionalExpression => 'Conforto de expressão emocional';

  @override
  String get chEmotionalReceptivity => 'Receptividade emocional';

  @override
  String get chVerificationTitle =>
      'Verificado em Múltiplos Mapas (D9/D12/D30/D60)';

  @override
  String get chD9Label => 'D9 Dharma-Caráter';

  @override
  String get chD12Label => 'D12 Herança Ancestral';

  @override
  String get chD30Label => 'D30 Perfil de Sombra';

  @override
  String get chD60Label => 'D60 Caráter de Vida Passada';

  @override
  String get chD30Standing => 'Posição da sombra';

  @override
  String get chMaternalInheritance => 'Herança materna';

  @override
  String get chAncestralKarmaWeight => 'Peso do carma ancestral';

  @override
  String get chTimelineTitle => 'Linha do Tempo do Caráter';

  @override
  String get chFormationWindow => 'Janela de Formação';

  @override
  String get chMaturationWindow => 'Janela de Maturação';

  @override
  String get chLegacyWindow => 'Janela de Legado';

  @override
  String get chPeakMaturationAge => 'Idade de maturação máxima';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return 'Idade $ageRange';
  }

  @override
  String get chImprovementTitle => 'Plano de Melhoria';

  @override
  String get chRoadmapTitle => 'Seu Roteiro de Caráter';

  @override
  String get chAuthenticExpression => 'Autoexpressão Autêntica';

  @override
  String get chRealizationPotential => 'Potencial de Realização do Caráter';

  @override
  String get chLayerAtmakaraka => 'Planeta da Alma (Atmakaraka)';

  @override
  String get chLayerD1 => 'Mapa Natal (D1)';

  @override
  String get chLayerD9 => 'Navamsa (D9)';

  @override
  String get chLayerD30 => 'Trimshamsa (D30)';

  @override
  String get chLayerLagnaMoon => 'Ascendente e Lua';

  @override
  String get chLayerArudha => 'Arudha Lagna';

  @override
  String get chTopicStrengths => 'Meus pontos fortes de caráter';

  @override
  String get chTopicShadow => 'Meus padrões de sombra';

  @override
  String get chTopicSoul => 'Minha assinatura da alma';

  @override
  String get chTopicRelationships => 'Meu estilo de relacionamento';

  @override
  String get chTopicEthics => 'Minha ética e valores';

  @override
  String get chTopicGuna => 'Meu perfil de guna e dosha';

  @override
  String get chTopicGrowth => 'Como desenvolver meu caráter';

  @override
  String get chTopicTiming => 'Melhor timing para trabalhar o caráter';

  @override
  String get lpSubtitle => 'Relatório Védico de Caminho de Vida e Sorte com IA';

  @override
  String get lpTitle => 'Caminho de Vida e Sorte';

  @override
  String get lpSnapshotHeader => 'Resumo do Caminho de Vida';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return 'Você é um $archetype com propósito principal em $domain. Nossa análise mostra um potencial geral de realização de vida de $probability%.';
  }

  @override
  String get lpGaugeDharma => 'Clareza de Dharma';

  @override
  String get lpGaugeFortune => 'Base de Fortuna';

  @override
  String get lpGaugeCoherence => 'Coerência do Caminho';

  @override
  String get lpGaugeFulfillment => 'Realização';

  @override
  String get lpGaugeMomentum => 'Momento Cármico';

  @override
  String get lpChipRareGift => 'Dom raro do destino';

  @override
  String get lpChipFreeWillStrong => 'Forte livre-arbítrio';

  @override
  String get lpChipGraceSupported => 'Apoiado pela graça';

  @override
  String get lpChipLightKarma => 'Carga cármica leve';

  @override
  String get lpChipRecognitionPotential => 'Potencial de reconhecimento';

  @override
  String get lpChipSpiritualPath => 'Forte inclinação espiritual';

  @override
  String get lpChipBlessed => 'O mapa carrega bênçãos';

  @override
  String get lpSoulPathTitle => 'Seu Caminho da Alma';

  @override
  String get lpSoulPlanet => 'Planeta da Alma';

  @override
  String get lpCareerPlanet => 'Planeta do Propósito';

  @override
  String get lpSoulClarity => 'Clareza do Propósito';

  @override
  String get lpLifeChapter => 'Capítulo Atual da Vida';

  @override
  String get lpPrimaryDomain => 'Domínio Principal do Propósito';

  @override
  String get lpKarakaTitle => 'Seus Planetas de Dharma';

  @override
  String get lpKarakaSubtitle =>
      'O quanto cada planeta apoia seu propósito de vida';

  @override
  String get lpVerificationTitle => 'Verificado em Múltiplos Mapas (D9 / D60)';

  @override
  String get lpD9Label => 'Alinhamento da Alma D9';

  @override
  String lpD9Explain(Object stage) {
    return 'Seu estágio de evolução da alma é \'$stage\' no mapa Navamsa.';
  }

  @override
  String get lpD9JupiterDignity => 'Dignidade de Júpiter';

  @override
  String get lpD9DharmaMultiplier => 'Multiplicador de dharma';

  @override
  String get lpD60Label => 'Assinatura de Vida Passada D60';

  @override
  String get lpKarmaType => 'Tipo de carma de vida passada';

  @override
  String get lpKetuMastery => 'Maestria de Ketu de vida passada';

  @override
  String get lpRahuGrowthDir => 'Direção de crescimento de Rahu';

  @override
  String get lpYogasTitle => 'Yogas de Fortuna e Bloqueios de Sorte';

  @override
  String get lpFortuneBoost => 'Impulso de Fortuna';

  @override
  String get lpLuckDrain => 'Drenagem de Sorte';

  @override
  String get lpFortuneBoosters => 'Impulsionadores de Fortuna';

  @override
  String get lpLuckBlocks => 'Bloqueios de Sorte';

  @override
  String get lpPurposeTitle => 'Domínios de Propósito e Fama';

  @override
  String get lpDomainLeadership => 'Liderança';

  @override
  String get lpDomainWisdom => 'Sabedoria e Ensino';

  @override
  String get lpDomainService => 'Serviço';

  @override
  String get lpDomainHealing => 'Cura';

  @override
  String get lpDomainCreative => 'Expressão Criativa';

  @override
  String get lpPrimaryDomainBadge => 'Principal';

  @override
  String get lpFameRecognition => 'Fama e Reconhecimento';

  @override
  String get lpSocialInfluence => 'Influência Social';

  @override
  String get lpRecognitionDomain => 'Campo de Reconhecimento';

  @override
  String get lpPublicImage => 'Imagem Pública';

  @override
  String get lpHistoricalImpact => 'Potencial de impacto histórico';

  @override
  String get lpTimelineTitle => 'Linha do Tempo de Fortuna e Vida';

  @override
  String get lpCurrentPhase => 'Fase Atual de Fortuna';

  @override
  String get lpJupiterReturn => 'Retorno de Júpiter';

  @override
  String get lpSaturnReturn => 'Retorno de Saturno';

  @override
  String get lpSadeSati => 'Sade Sati';

  @override
  String get lpGoldenWindow => 'Janela Dourada';

  @override
  String get lpTransformationWindow => 'Janela de Transformação';

  @override
  String get lpPeakYears => 'Anos de Pico de Fortuna';

  @override
  String get lpChallengingYears => 'Anos Desafiadores';

  @override
  String get lpMilestonesTitle => 'Principais Marcos e Pontos de Virada';

  @override
  String get lpFirstTurningPoint => 'Primeiro Grande Ponto de Virada';

  @override
  String get lpMidlifeTransform => 'Transformação da Meia-Idade';

  @override
  String get lpLateLifeFulfillment => 'Realização na Vida Tardia';

  @override
  String lpDharmicMilestone(Object age) {
    return 'Marco Dhármico (Idade $age)';
  }

  @override
  String lpAgeLabel(Object age) {
    return 'Idade $age';
  }

  @override
  String get lpDestinyTitle => 'Destino vs Livre-Arbítrio';

  @override
  String get lpDestinyStat => 'Peso do Destino';

  @override
  String get lpFreeWillStat => 'Alavancagem do Livre-Arbítrio';

  @override
  String get lpFateStrength => 'Força da Assinatura do Destino';

  @override
  String get lpSelfCreation => 'Capacidade de Autocriação';

  @override
  String get lpEffortGrace => 'Esforço vs graça';

  @override
  String get lpKarmicTitle => 'Lições Cármicas';

  @override
  String get lpRahuGrowthLabel => 'Rahu — Desafio de Crescimento';

  @override
  String get lpKetuSurrenderLabel => 'Ketu — Tema de Entrega';

  @override
  String get lpSaturnLessonLabel => 'Saturno — Lição de Disciplina';

  @override
  String get lpTestDifficulty => 'Dificuldade do Teste de Vida';

  @override
  String get lpLessonsInProgress => 'Lições em Andamento';

  @override
  String get lpSoulContract => 'Áreas de Contrato da Alma';

  @override
  String get lpSoulExperience => 'O Que Sua Alma Veio Experimentar';

  @override
  String get lpSoulMastery => 'O Que Sua Alma Veio Dominar';

  @override
  String get lpSpiritualTitle => 'Caminho Espiritual';

  @override
  String get lpSpiritualInclination => 'Inclinação Espiritual';

  @override
  String get lpMeditationReceptivity => 'Receptividade à Meditação';

  @override
  String get lpTeacherKarma => 'Carma de Professor/Guru';

  @override
  String get lpPilgrimageBenefit => 'Benefício de Peregrinação';

  @override
  String get lpSelfRealization => 'Potencial de Autorrealização';

  @override
  String get lpDivineConnection => 'Conexão Divina';

  @override
  String get lpTraditionAffinity => 'Afinidade com tradições';

  @override
  String get lpIntuitionStrength => 'Força da intuição';

  @override
  String get lpMantraEfficacy => 'Eficácia de oração/mantra';

  @override
  String get lpInnerGuidance => 'Confiança na orientação interior';

  @override
  String get lpPropheticDreams => 'Sensibilidade a sonhos proféticos';

  @override
  String get lpDifficultyTitle => 'Dificuldades e Desafios de Vida';

  @override
  String get lpEarlyLife => 'Início da Vida';

  @override
  String get lpMidlife => 'Meia-Idade';

  @override
  String get lpLateLife => 'Vida Tardia';

  @override
  String get lpStruggleToSuccess => 'Carma de Luta ao Sucesso';

  @override
  String get lpUnlivedLifeRisk => 'Risco de Vida Não Vivida';

  @override
  String get lpChallenges => 'Desafios de Vida';

  @override
  String get lpFortuneDrains => 'Drenos Crônicos de Fortuna';

  @override
  String get lpRegretAreas => 'Áreas Vulneráveis a Arrependimento';

  @override
  String get lpRedFlags => 'Sinais de Alerta de Direção';

  @override
  String get lpBlessingsTitle => 'Bênçãos e Tema Central de Vida';

  @override
  String get lpKarmicRoot => 'Raiz cármica';

  @override
  String get lpBlessingsList => 'Suas Bênçãos';

  @override
  String get lpFulfillmentPriorities => 'Prioridades de Realização';

  @override
  String get lpImprovementTitle => 'Plano de Melhoria';

  @override
  String get lpDharmaPriorities => 'Prioridades de Dharma';

  @override
  String get lpRoadmapTitle => 'Seu Roteiro do Destino';

  @override
  String get lpStrategy => 'Estratégia';

  @override
  String get lpFulfillmentPotential => 'Potencial de Realização';

  @override
  String get lpNext12Focus => 'Foco para os Próximos 12 Meses';

  @override
  String get lpLayerD1 => 'Mapa Natal (D1)';

  @override
  String get lpLayerD9 => 'Navamsa (D9)';

  @override
  String get lpLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get lpLayerDasha => 'Timing de Dasha';

  @override
  String get lpLayerTransit => 'Trânsitos Atuais';

  @override
  String get lpTopicPurpose => 'Meu propósito de vida';

  @override
  String get lpTopicFortune => 'Meus yogas de fortuna';

  @override
  String get lpTopicKarma => 'Minhas lições cármicas';

  @override
  String get lpTopicMilestones => 'Próximos marcos';

  @override
  String get lpTopicDestiny => 'Destino vs livre-arbítrio';

  @override
  String get lpTopicSpiritual => 'Meu caminho espiritual';

  @override
  String get lpTopicChallenges => 'Meus desafios de vida';

  @override
  String get lpTopicTiming => 'Melhores janelas de timing';

  @override
  String get dbSubtitle => 'Relatório Védico de Dívidas e Recuperação com IA';

  @override
  String get dbTitle => 'Dívidas e Recuperação';

  @override
  String get dbSnapshotHeader => 'Resumo de Recuperação de Dívidas';

  @override
  String dbHeroSummary(
    Object phase,
    Object personality,
    Object probability,
    Object years,
  ) {
    return 'Você está atualmente em uma fase \'$phase\' com uma abordagem $personality em relação ao dinheiro. Nossa análise mostra $probability% de chance de ficar livre de dívidas em cerca de $years anos.';
  }

  @override
  String get dbGaugeCapacity => 'Capacidade de Recuperação';

  @override
  String get dbGaugeProbability => 'Chance de Recuperação';

  @override
  String get dbGaugeFreedomNow => 'Liberdade de Dívidas Agora';

  @override
  String get dbGaugeDti => 'Saúde da Renda';

  @override
  String get dbGaugeResilience => 'Resiliência';

  @override
  String get dbChipCleanKarma => 'Carma de dívida limpo';

  @override
  String get dbChipStrongRecovery => 'Forte capacidade de recuperação';

  @override
  String get dbChipHealthyDti => 'Relação dívida-renda saudável';

  @override
  String get dbChipResilient => 'Alta resiliência psicológica';

  @override
  String get dbChipCycleBreakable => 'O ciclo de dívidas pode ser quebrado';

  @override
  String get dbChipLowReindebt => 'Baixo risco de reendividamento';

  @override
  String get dbChipGoodNegotiator => 'Boas chances de negociação';

  @override
  String get dbProfileTitle => 'Seu Perfil de Dívida';

  @override
  String get dbPhaseLabel => 'Fase atual';

  @override
  String get dbPrimaryCategoryLabel => 'Categoria principal';

  @override
  String get dbKarakaLabel => 'Karaka da Dívida';

  @override
  String get dbProtectorLabel => 'Proteção contra Credores';

  @override
  String get dbSecondaryCategories => 'Categorias secundárias';

  @override
  String get dbUnsecuredRatio => 'Proporção de dívida não garantida';

  @override
  String get dbKarakaTitle => 'Seus Planetas da Dívida';

  @override
  String get dbKarakaSubtitle =>
      'O quanto cada planeta apoia sua recuperação de dívidas';

  @override
  String get dbVerificationTitle => 'Verificado em Múltiplos Mapas (D6)';

  @override
  String get dbD6Label => 'Mapa D6 de Dívidas e Inimigos';

  @override
  String get dbD6LordDignity => 'Força do senhor da Casa 6';

  @override
  String get dbD6Severity => 'Severidade do carma de dívida';

  @override
  String get dbD6Multiplier => 'Multiplicador de dívida D6';

  @override
  String get dbYogasTitle => 'Yogas de Dívida e Proteções';

  @override
  String get dbPressureNow => 'Pressão de Dívida Agora';

  @override
  String get dbRecoveryBoost => 'Impulso de Recuperação';

  @override
  String get dbClearingLabel => 'Yogas de Quitação de Dívida';

  @override
  String get dbCreatingLabel => 'Yogas de Criação de Dívida';

  @override
  String get dbCategoriesTitle => 'Categorias de Dívida a Observar';

  @override
  String get dbCategoriesSubtitle =>
      'Quais tipos de dívida precisam de mais atenção';

  @override
  String get dbTimelineTitle => 'Cronograma de Liberdade de Dívidas';

  @override
  String get dbFreeWindowLabel => 'JANELA DE LIBERDADE DE DÍVIDAS';

  @override
  String get dbClearanceEstimate => 'Estimativa de quitação total';

  @override
  String get dbPeakYears => 'Anos de Pico de Dívida';

  @override
  String get dbClearanceYears => 'Anos de Quitação';

  @override
  String get dbBorrowTitle => 'Guia de Empréstimo Inteligente';

  @override
  String get dbLoanSuitability => 'Adequação do Empréstimo';

  @override
  String get dbBestLoanType => 'Melhor Tipo de Empréstimo';

  @override
  String get dbLeverageCeiling => 'Teto de Alavancagem';

  @override
  String get dbNegotiationSuccess => 'Sucesso na Negociação';

  @override
  String get dbCreditorAggression => 'Risco de Pressão de Credores';

  @override
  String get dbLegalEscalation => 'Risco de Escalada Legal';

  @override
  String get dbNegotiationApproach => 'Abordagem recomendada';

  @override
  String get dbAvoidLoanTypes => 'Tipos de Empréstimo a Evitar';

  @override
  String get dbRiskTitle => 'Observação de Riscos e Vulnerabilidades';

  @override
  String get dbRiskDefault => 'Risco de Inadimplência';

  @override
  String get dbRiskDefaultExp =>
      'A chance de deixar de pagar uma parcela programada de forma grave o suficiente para acionar o status de inadimplência com um credor.';

  @override
  String get dbRiskDefaultFix =>
      'Automatize os pagamentos mínimos e mantenha uma reserva de 1 mês para que um único ciclo de renda perdido não gere um efeito cascata.';

  @override
  String get dbRiskBankruptcy => 'Risco de Falência';

  @override
  String get dbRiskBankruptcyExp =>
      'A probabilidade de a dívida crescer além do que a renda e os ativos podem realisticamente cobrir.';

  @override
  String get dbRiskBankruptcyFix =>
      'Faça uma revisão profissional de dívidas antes de contrair qualquer novo empréstimo ou linha de crédito.';

  @override
  String get dbRiskAssetSeizure => 'Risco de Apreensão de Bens';

  @override
  String get dbRiskAssetSeizureExp =>
      'A chance de a inadimplência de um empréstimo garantido levar um credor a retomar a garantia ou o imóvel.';

  @override
  String get dbRiskAssetSeizureFix =>
      'Priorize os pagamentos de empréstimos garantidos primeiro e refinancie cedo se uma lacuna de pagamento parecer provável.';

  @override
  String get dbRiskChronic => 'Risco Crônico de Reendividamento';

  @override
  String get dbRiskChronicExp =>
      'A tendência de voltar a se endividar mesmo depois de quitar a dívida atual.';

  @override
  String get dbRiskChronicFix =>
      'Construa um fundo de emergência dedicado antes de aumentar os gastos com o estilo de vida após a quitação.';

  @override
  String get dbReindebtTrigger => 'Gatilho de Reendividamento';

  @override
  String get dbCycleBreakFeasibility => 'Viabilidade de Romper o Ciclo';

  @override
  String get dbMajorRisks => 'Principais Riscos';

  @override
  String get dbHiddenSignals => 'Sinais Ocultos de Dívida';

  @override
  String get dbCrisisTitle => 'Preparação para Crises';

  @override
  String get dbCrisisSubtitle =>
      'Como identificar problemas cedo e responder com calma';

  @override
  String get dbWarningSigns => 'Sinais de Alerta Precoce';

  @override
  String get dbMitigationActions => 'O Que Fazer a Respeito';

  @override
  String get dbFamilyTitle => 'Dívida Familiar e Ancestral';

  @override
  String get dbInheritedDebtProb => 'Chance de Dívida Herdada';

  @override
  String get dbFamilyDrag => 'Peso da Dívida Familiar';

  @override
  String get dbInheritedSource => 'Fonte provável';

  @override
  String get dbCoreBlockerLabel => 'BLOQUEIO CENTRAL';

  @override
  String get dbPsychologyTitle => 'Sua Psicologia Financeira';

  @override
  String get dbResilience => 'Resiliência';

  @override
  String get dbDiscipline => 'Disciplina sob Pressão';

  @override
  String get dbSocialSupport => 'Apoio Social';

  @override
  String get dbDepressionRisk => 'Vulnerabilidade ao Estresse Financeiro';

  @override
  String get dbStressTolerance => 'Tolerância ao estresse';

  @override
  String get dbRootCause => 'Causa Raiz Comportamental';

  @override
  String get dbImprovementTitle => 'Plano de Melhoria';

  @override
  String get dbRoadmapTitle => 'Seu Roteiro para Ficar Livre de Dívidas';

  @override
  String get dbRecoveryProbability => 'Probabilidade de Recuperação';

  @override
  String get dbClearanceTimeline => 'Cronograma de Quitação';

  @override
  String get dbYears => 'anos';

  @override
  String get dbDtiHealth => 'Saúde da Relação Dívida-Renda';

  @override
  String get dbDtiCategory => 'Categoria de DTI';

  @override
  String get dbBreakEvenMonths => 'Meses até o equilíbrio';

  @override
  String get dbIncomeAcceleration => 'Crescimento de renda necessário';

  @override
  String get dbLayerD1 => 'Mapa Natal (D1)';

  @override
  String get dbLayerD6 => 'Dívidas e Inimigos (D6)';

  @override
  String get dbLayerD9 => 'Navamsa (D9)';

  @override
  String get dbLayerDasha => 'Timing de Dasha';

  @override
  String get dbLayerTransit => 'Trânsitos Atuais';

  @override
  String get dbTopicRecovery => 'Meu cronograma de recuperação';

  @override
  String get dbTopicNegotiate => 'Negociar com credores';

  @override
  String get dbTopicBorrowing => 'É seguro pedir emprestado agora';

  @override
  String get dbTopicCrisis => 'Preparar-se para uma crise';

  @override
  String get dbTopicAncestral => 'Carma de dívida ancestral';

  @override
  String get dbTopicTimeline => 'Melhores anos para quitar dívidas';

  @override
  String get dbTopicPsychology => 'Minha psicologia financeira';

  @override
  String get dbTopicCategories => 'Quais dívidas priorizar';

  @override
  String get mnSubtitle => 'Relatório Védico de Bem-Estar com IA';

  @override
  String get mnTitle => 'Mental e Estresse';

  @override
  String get mnSnapshotHeader => 'Resumo de Bem-Estar';

  @override
  String get mnResilience => 'Resiliência';

  @override
  String get mnStability => 'Estabilidade';

  @override
  String get mnEmotionalBalance => 'Equilíbrio Emocional';

  @override
  String get mnInnerCalm => 'Calma Interior';

  @override
  String get mnSelfAwareness => 'Autoconsciência';

  @override
  String get mnStatusThriving => 'Em Plena Forma';

  @override
  String get mnStatusSteady => 'Estável e Equilibrado';

  @override
  String get mnStatusBuildingStrength => 'Construindo Força';

  @override
  String get mnStatusNeedsGentleCare => 'Precisa de Cuidado Suave';

  @override
  String get mnStatusReachOut => 'Hora de Buscar Apoio';

  @override
  String get mnChipStable => 'Emocionalmente Estável';

  @override
  String get mnChipSupported => 'Bem Apoiado';

  @override
  String get mnChipSelfAware => 'Altamente Autoconsciente';

  @override
  String get mnChipResilient => 'Se Recupera Bem';

  @override
  String get mnChipSecureAttachment => 'Apego Seguro';

  @override
  String get mnChipHealingReady => 'Pronto para Curar';

  @override
  String get mnChipMindBodyBalance => 'Equilíbrio Mente-Corpo';

  @override
  String get mnSupportBannerTitle => 'Uma Nota Gentil';

  @override
  String get mnSupportBannerBody =>
      'Seu mapa sugere que este pode ser um bom momento para contar com apoio extra — um amigo de confiança, familiar ou profissional. Pedir ajuda é um sinal de força, não de fraqueza.';

  @override
  String get mnProfileTitle => 'Seu Perfil Emocional';

  @override
  String get mnStressDriver => 'Fator de Estresse';

  @override
  String get mnStabilityAnchor => 'Âncora de Estabilidade';

  @override
  String get mnSoulLevelKarma => 'Padrão em Nível de Alma';

  @override
  String get mnSubtleSignature => 'Assinatura Emocional Sutil';

  @override
  String get mnKarakaTitle => 'Sua Mente e os Planetas';

  @override
  String get mnKarakaSubtitle => 'Quais planetas moldam seu mundo interior';

  @override
  String get mnYogasTitle => 'Pontos Fortes e Áreas de Crescimento';

  @override
  String get mnCurrentPhase => 'Fase Atual';

  @override
  String get mnCurrentStressLevel => 'Nível de Estresse Atual';

  @override
  String get mnRecentStrain => 'Tensão Emocional Recente';

  @override
  String get mnStrengths => 'Pontos Fortes';

  @override
  String get mnGrowthAreas => 'Áreas de Crescimento';

  @override
  String get mnSadeSatiStatus => 'Status do Sade Sati';

  @override
  String get mnVerificationTitle => 'Verificado em Múltiplos Mapas';

  @override
  String get mnD9Confirmation => 'Confirmação D9';

  @override
  String get mnD30Confirmation => 'Confirmação D30';

  @override
  String get mnMoodPatternsTitle => 'Padrões de Humor e Ansiedade';

  @override
  String get mnMoodPatternsSubtitle => 'Consciência gentil, não um diagnóstico';

  @override
  String get mnAnxietyPatterns => 'Padrões de Ansiedade';

  @override
  String get mnMoodPatterns => 'Padrões de Humor Baixo';

  @override
  String get mnPrimaryPattern => 'Padrão Primário';

  @override
  String get mnRumination => 'Tendência a Pensar Demais';

  @override
  String get mnHypervigilance => 'Hiperalerta';

  @override
  String get mnHopelessnessVuln => 'Sensibilidade ao Humor Baixo';

  @override
  String get mnEnergyDepletion => 'Tendência de Esgotamento de Energia';

  @override
  String get mnMotivationBaseline => 'Nível Base de Motivação';

  @override
  String get mnRegulationTitle => 'Regulação Emocional e Enfrentamento';

  @override
  String get mnEmotionalRegulation => 'Regulação Emocional';

  @override
  String get mnSelfSoothing => 'Capacidade de Autoacalmar-se';

  @override
  String get mnExpressionStyle => 'Estilo de Expressão';

  @override
  String get mnRecoveryTime => 'Tempo de Recuperação';

  @override
  String get mnTriggerIntensity => 'Intensidade dos Gatilhos';

  @override
  String get mnHealthyCoping => 'Hábitos Saudáveis de Enfrentamento';

  @override
  String get mnWatchFor => 'Observe com Atenção';

  @override
  String get mnSleepTitle => 'Sono e Descanso';

  @override
  String get mnSleepQuality => 'Qualidade do Sono';

  @override
  String get mnSleepAsRegulator => 'Sono como Regulador Emocional';

  @override
  String get mnInsomniaTendency => 'Tendência a Noites Agitadas';

  @override
  String get mnNightmareTendency => 'Tendência a Sonhos Vívidos';

  @override
  String get mnSleepHygienePriority => 'Prioridade de Higiene do Sono';

  @override
  String get mnBurnoutTitle => 'Esgotamento e Energia';

  @override
  String get mnBurnoutVulnerability => 'Sensibilidade ao Esgotamento';

  @override
  String get mnBurnoutRecovery => 'Capacidade de Recuperação do Esgotamento';

  @override
  String get mnBurnoutStage => 'Estágio Atual de Esgotamento';

  @override
  String get mnSelfDrivingTendency => 'Tendência à Autocobrança';

  @override
  String get mnBurnoutTriggers => 'Gatilhos de Esgotamento';

  @override
  String get mnConnectionTitle => 'Conexão e Apoio';

  @override
  String get mnSocialSupport => 'Qualidade do Apoio Social';

  @override
  String get mnLonelinessVuln => 'Sensibilidade à Solidão';

  @override
  String get mnSolitudeNeed => 'Necessidade de Solidão';

  @override
  String get mnSocialComfort => 'Conforto Social';

  @override
  String get mnTraumaSensitivity => 'Sensibilidade a Traumas';

  @override
  String get mnHealingReadiness => 'Prontidão para Cura';

  @override
  String get mnProcessingStyle => 'Estilo de Processamento';

  @override
  String get mnMindBodyIntegration => 'Integração Mente-Corpo';

  @override
  String get mnPtsdVuln => 'Sensibilidade à Resposta a Traumas';

  @override
  String get mnSelfAwarenessTitle => 'Autoconsciência e Crescimento';

  @override
  String get mnSelfAwarenessScore => 'Autoconsciência';

  @override
  String get mnEmotionalVocabulary => 'Vocabulário Emocional';

  @override
  String get mnTherapyReadiness => 'Prontidão para Terapia';

  @override
  String get mnJournalingBenefit => 'Benefício de Escrever um Diário';

  @override
  String get mnInnerDialogue => 'Qualidade do Diálogo Interior';

  @override
  String get mnAwarenessOfPatterns => 'Consciência de Padrões';

  @override
  String get mnEscapePatternVuln => 'Sensibilidade a Padrões de Fuga';

  @override
  String get mnEscapeChannels => 'Observe com Atenção';

  @override
  String get mnHealthyAlternatives => 'Alternativas Saudáveis';

  @override
  String get mnTherapyFitTitle => 'Compatibilidade com Terapia e Apoio';

  @override
  String get mnCrisisSupportRec => 'Recomendação de Apoio';

  @override
  String get mnSupportNetwork => 'Ative Sua Rede de Apoio';

  @override
  String get mnSelfAdvocacy => 'Prontidão para Autodefesa';

  @override
  String get mnMedicationReceptivity => 'Receptividade a Medicação';

  @override
  String get mnTimelineTitle => 'Linha do Tempo de Bem-Estar';

  @override
  String get mnPeakWellnessYears => 'Anos de Pico de Bem-Estar';

  @override
  String get mnExtraCareYears => 'Anos que Pedem Autocuidado Extra';

  @override
  String get mnTransformationWindows => 'Janelas de Transformação Positiva';

  @override
  String get mnTherapyWindow => 'Janela Recomendada para Terapia';

  @override
  String get mnPracticesTitle => 'Práticas Diárias de Bem-Estar';

  @override
  String get mnMorningPractices => 'Práticas Matinais';

  @override
  String get mnEveningPractices => 'Práticas Noturnas';

  @override
  String get mnBreathwork => 'Trabalho Respiratório';

  @override
  String get mnMovement => 'Movimento';

  @override
  String get mnNutrition => 'Nutrição';

  @override
  String get mnNatureExposure => 'Necessidade de Contato com a Natureza';

  @override
  String get mnDigitalDetox => 'Necessidade de Desintoxicação Digital';

  @override
  String get mnImprovementTitle => 'Plano de Melhoria';

  @override
  String get mnReliabilityTitle => 'Confiabilidade';

  @override
  String get mnLayerD1 => 'Mapa Natal (D1)';

  @override
  String get mnLayerD9 => 'Mapa da Alma (D9)';

  @override
  String get mnLayerD30 => 'Mapa D30';

  @override
  String get mnLayerDasha => 'Timing de Dasha';

  @override
  String get mnLayerTransit => 'Trânsitos';

  @override
  String get mnTopicResilience => 'Quão resiliente sou emocionalmente?';

  @override
  String get mnTopicCoping =>
      'Quais são minhas melhores estratégias de enfrentamento?';

  @override
  String get mnTopicSleep => 'Como posso melhorar meu sono?';

  @override
  String get mnTopicBurnout => 'Estou em risco de esgotamento?';

  @override
  String get mnTopicTherapy => 'Qual estilo de terapia combina comigo?';

  @override
  String get mnTopicPractices => 'Quais práticas diárias mais me ajudam?';

  @override
  String get mnTopicTiming => 'Quais são meus melhores anos de bem-estar?';

  @override
  String get mnTopicSupport => 'Como construo uma rede de apoio forte?';

  @override
  String get lgSubtitle => 'Relatório Védico Jurídico com IA';

  @override
  String get lgTitle => 'Questões Legais e Disputas';

  @override
  String get lgSnapshotHeader => 'Resumo Jurídico';

  @override
  String get lgResilience => 'Resiliência Jurídica';

  @override
  String get lgResolutionCapacity => 'Capacidade de Resolução';

  @override
  String get lgVictoryPotential => 'Potencial de Vitória';

  @override
  String get lgLegalSafety => 'Segurança Jurídica';

  @override
  String get lgNegotiationSkill => 'Habilidade de Negociação';

  @override
  String get lgStatusExcellent => 'Excelente';

  @override
  String get lgStatusStrong => 'Forte';

  @override
  String get lgStatusModerate => 'Moderado';

  @override
  String get lgStatusDeveloping => 'Em Desenvolvimento';

  @override
  String get lgStatusChallenging => 'Desafiador';

  @override
  String get lgChipResolver => 'Hábil Resolvedor';

  @override
  String get lgChipWinner => 'Vitórias em Casos Fortes';

  @override
  String get lgChipNegotiator => 'Negociador Natural';

  @override
  String get lgChipDocumented => 'Bem Documentado';

  @override
  String get lgChipLowRisk => 'Baixo Risco Jurídico';

  @override
  String get lgChipMoralAuthority => 'Autoridade Moral';

  @override
  String get lgChipLegalAptitude => 'Aptidão Jurídica';

  @override
  String get lgProfileTitle => 'Seu Perfil Jurídico e Carma';

  @override
  String get lgPrimaryDriver => 'Fator Principal';

  @override
  String get lgDharmaAnchor => 'Âncora de Dharma';

  @override
  String get lgAggressionMarker => 'Marcador de Agressividade';

  @override
  String get lgDocumentationKaraka => 'Qualidade da Documentação';

  @override
  String get lgKarakaTitle => 'Seus Planetas Jurídicos';

  @override
  String get lgKarakaSubtitle => 'Quais planetas moldam sua fortuna jurídica';

  @override
  String get lgYogasTitle => 'Yogas Jurídicos e Proteções';

  @override
  String get lgCurrentPhase => 'Fase Atual';

  @override
  String get lgProtections => 'Proteções';

  @override
  String get lgDisputePressures => 'Pressões de Disputa';

  @override
  String get lgVerificationTitle => 'Verificado em Múltiplos Mapas';

  @override
  String get lgD6Litigation => 'Mapa de Litígio D6';

  @override
  String get lgD9Dharma => 'Mapa de Dharma D9';

  @override
  String get lgMoralAuthority => 'Autoridade Moral';

  @override
  String get lgVictoryTitle => 'Análise de Vitória';

  @override
  String get lgAsPlaintiff => 'Como Autor';

  @override
  String get lgAsDefendant => 'Como Réu';

  @override
  String get lgSettlementPreference => 'Preferência por Acordo';

  @override
  String get lgDisputeCategoriesTitle => 'Categorias de Disputa a Observar';

  @override
  String get lgLowRiskCategories => 'Categorias de Baixo Risco';

  @override
  String get lgConflictStyleTitle => 'Estilo de Conflito e Inimizades';

  @override
  String get lgConfrontationComfort => 'Conforto com Confronto';

  @override
  String get lgArgumentPersuasiveness => 'Persuasão Argumentativa';

  @override
  String get lgEmotionalRegulation => 'Regulação Emocional';

  @override
  String get lgGrudgeHolding => 'Tendência a Guardar Rancor';

  @override
  String get lgEnemyAnalysisLabel => 'Análise de Inimigos';

  @override
  String get lgVisibleEnemies => 'Inimigos Visíveis';

  @override
  String get lgHiddenEnemies => 'Inimigos Ocultos';

  @override
  String get lgWorkplaceEnemies => 'Inimigos no Trabalho';

  @override
  String get lgFamilyEnemies => 'Inimigos na Família';

  @override
  String get lgLegalEnemies => 'Inimigos Jurídicos';

  @override
  String get lgEnemyDefeatCapacity => 'Capacidade de Derrotar Inimigos';

  @override
  String get lgCriminalFinancialTitle =>
      'Observação de Risco Criminal e Financeiro';

  @override
  String get lgCriminalRisk => 'Risco de Envolvimento Criminal';

  @override
  String get lgVictimOfCrime => 'Chance de Ser Vítima de Crime';

  @override
  String get lgFalseAccusation => 'Risco de Acusação Falsa';

  @override
  String get lgImprisonmentRisk => 'Risco de Prisão';

  @override
  String get lgTaxDisputeRisk => 'Risco de Disputa Fiscal';

  @override
  String get lgFinancialFraudRisk => 'Risco de Fraude Financeira';

  @override
  String get lgBusinessLitigationRisk => 'Risco de Litígio Empresarial';

  @override
  String get lgBankruptcyRisk => 'Risco de Falência';

  @override
  String get lgAuditVulnerability => 'Vulnerabilidade a Auditorias';

  @override
  String get lgProtectionPriority => 'Prioridade de Proteção';

  @override
  String get lgContractsTitle => 'Contratos e Negociação';

  @override
  String get lgContractClarity => 'Clareza Contratual';

  @override
  String get lgDocumentationDiscipline => 'Disciplina de Documentação';

  @override
  String get lgFinePrintAwareness => 'Atenção às Letras Miúdas';

  @override
  String get lgSignatureCaution => 'Cautela ao Assinar';

  @override
  String get lgMediationReceptivity => 'Receptividade à Mediação';

  @override
  String get lgNegotiationSkillFull => 'Habilidade de Negociação';

  @override
  String get lgCompromiseWillingness => 'Disposição para o Compromisso';

  @override
  String get lgFaceSavingNeeds => 'Necessidade de Preservar a Imagem';

  @override
  String get lgMediatorHireRecommendation =>
      'Recomendação de Contratar Mediador';

  @override
  String get lgTypicalContractIssues => 'Problemas Contratuais Típicos';

  @override
  String get lgCareerFitTitle => 'Compatibilidade com Carreira Jurídica';

  @override
  String get lgProfessionAffinity => 'Afinidade Profissional';

  @override
  String get lgRoleFit => 'Melhor Função';

  @override
  String get lgLawStudentSuccess => 'Sucesso como Estudante de Direito';

  @override
  String get lgBarExamSuccess => 'Sucesso no Exame da Ordem';

  @override
  String get lgTimelineTitle => 'Linha do Tempo Jurídica';

  @override
  String get lgNewMatterChance => 'Chance de Novo Caso (Próximos 12 Meses)';

  @override
  String get lgOngoingCaseOutcome => 'Resultado do Caso em Andamento';

  @override
  String get lgRecommendedAction => 'Ação Recomendada';

  @override
  String get lgPeakDisputeYears => 'Anos de Pico de Disputas';

  @override
  String get lgClarityYears => 'Anos de Clareza Jurídica';

  @override
  String get lgAvoidancePeriods => 'Períodos Críticos a Evitar';

  @override
  String get lgFavorableWindows => 'Janelas Favoráveis de Resolução';

  @override
  String get lgRisksTitle => 'Riscos e Vulnerabilidades';

  @override
  String get lgChronicVulnerabilities => 'Vulnerabilidades Crônicas';

  @override
  String get lgAvoidDashaPeriods => 'Períodos de Dasha a Observar';

  @override
  String get lgPreventivePriorities => 'Prioridades Preventivas';

  @override
  String get lgRedFlags => 'Situações de Alerta';

  @override
  String get lgImprovementTitle => 'Plano de Melhoria';

  @override
  String get lgReliabilityTitle => 'Confiabilidade';

  @override
  String get lgLayerD1 => 'Mapa Natal (D1)';

  @override
  String get lgLayerD6 => 'Mapa de Litígio (D6)';

  @override
  String get lgLayerD9 => 'Mapa de Dharma (D9)';

  @override
  String get lgLayerDasha => 'Timing de Dasha';

  @override
  String get lgLayerTransit => 'Trânsitos';

  @override
  String get lgTopicWinChance => 'Quais são minhas chances de vencer?';

  @override
  String get lgTopicStrategy => 'Melhor estratégia jurídica para mim?';

  @override
  String get lgTopicContract => 'Riscos contratuais a observar?';

  @override
  String get lgTopicTiming => 'Melhor timing para resolver disputas?';

  @override
  String get lgTopicSettlement => 'Devo fazer acordo ou lutar?';

  @override
  String get lgTopicEnemies => 'Quem são meus inimigos ocultos?';

  @override
  String get lgTopicProtection => 'Como me proteger juridicamente?';

  @override
  String get lgTopicCareer => 'Sou adequado para uma carreira jurídica?';

  @override
  String get prSubtitle => 'Relatório Védico de Propriedades com IA';

  @override
  String get prTitle => 'Propriedades e Bens';

  @override
  String get prSnapshotHeader => 'Resumo de Propriedades';

  @override
  String get prAcquisitionCapacity => 'Capacidade de Aquisição';

  @override
  String get prHomeOwnership => 'Posse de Imóvel';

  @override
  String get prWealthPotential => 'Potencial de Riqueza';

  @override
  String get prRentalIncome => 'Renda de Aluguel';

  @override
  String get prLandOwnership => 'Posse de Terras';

  @override
  String get prStatusExcellent => 'Excelente';

  @override
  String get prStatusStrong => 'Forte';

  @override
  String get prStatusModerate => 'Moderado';

  @override
  String get prStatusDeveloping => 'Em Desenvolvimento';

  @override
  String get prStatusChallenging => 'Desafiador';

  @override
  String get prChipHomeOwner => 'Proprietário de Imóvel';

  @override
  String get prChipWealthBuilder => 'Construtor de Riqueza';

  @override
  String get prChipLandOwner => 'Proprietário de Terras';

  @override
  String get prChipInvestor => 'Investidor Imobiliário';

  @override
  String get prChipInheritance => 'Herança Provável';

  @override
  String get prChipVehicle => 'Proprietário de Veículo';

  @override
  String get prChipGlobalAsset => 'Afinidade com Bens Globais';

  @override
  String get prProfileTitle => 'Seu Estilo de Propriedade';

  @override
  String get prHomeAesthetics => 'Estética do Lar';

  @override
  String get prHomeSanctuary => 'Lar como Santuário';

  @override
  String get prComfortInvestment => 'Investimento em Conforto';

  @override
  String get prVastuPriority => 'Prioridade de Vastu';

  @override
  String get prNaturalElements => 'Elementos Naturais';

  @override
  String get prNextActionLabel => 'Próxima Ação';

  @override
  String get prKarakaTitle => 'Seus Planetas de Propriedade';

  @override
  String get prKarakaSubtitle => 'Quais planetas moldam sua sorte imobiliária';

  @override
  String get prPrimaryKaraka => 'Karaka Primário';

  @override
  String get prDurableAsset => 'Karaka de Bens Duráveis';

  @override
  String get prYogasTitle => 'Yogas e Doshas de Propriedade';

  @override
  String get prCurrentPhase => 'Fase Atual';

  @override
  String get prBoosters => 'Impulsionadores';

  @override
  String get prDrains => 'Drenos';

  @override
  String get prVerificationTitle => 'Verificado em Múltiplos Mapas';

  @override
  String get prD4Property => 'Mapa de Propriedade D4';

  @override
  String get prD16Vehicle => 'Mapa de Veículo D16';

  @override
  String get prVehicleFit => 'Compatibilidade com Veículos';

  @override
  String get prJourneyTitle => 'Jornada e Cronograma de Posse';

  @override
  String get prFirstHomeAge => 'Idade do Primeiro Imóvel';

  @override
  String get prFirstHomeType => 'Tipo do Primeiro Imóvel';

  @override
  String get prMultipleHomes => 'Múltiplos Imóveis';

  @override
  String get prNewPropertySoon => 'Nova Propriedade em Breve';

  @override
  String get prFirstMajorWindow => 'Primeira Grande Janela';

  @override
  String get prBuyingWindow => 'Janela de Compra';

  @override
  String get prConstructionWindow => 'Janela de Construção';

  @override
  String get prNextOpportunity => 'Próxima Oportunidade';

  @override
  String get prLifetimePropertyCount => 'Número de Propriedades na Vida';

  @override
  String get prInheritanceTitle => 'Herança e Propriedade Familiar';

  @override
  String get prMaternalInheritance => 'Herança Materna';

  @override
  String get prPaternalInheritance => 'Herança Paterna';

  @override
  String get prAncestralProperty => 'Propriedade Ancestral';

  @override
  String get prFamilyDisputeRisk => 'Risco de Disputa Familiar';

  @override
  String get prInheritanceTiming => 'Timing da Herança';

  @override
  String get prInheritanceType => 'Tipo de Herança';

  @override
  String get prLandInvestTitle =>
      'Terras, Investimentos e Propriedades Globais';

  @override
  String get prPropertyInvestor => 'Pontuação de Investidor Imobiliário';

  @override
  String get prAppreciationLuck => 'Sorte de Valorização';

  @override
  String get prInvestorMindset => 'Mentalidade de Investidor';

  @override
  String get prLandType => 'Tipo de Terreno';

  @override
  String get prRentalCount => 'Número de Imóveis Alugados';

  @override
  String get prMultipleLand => 'Múltiplos Terrenos';

  @override
  String get prFarmEstate => 'Chance de Fazenda / Sítio';

  @override
  String get prGlobalPropertyLabel => 'Propriedade Global';

  @override
  String get prForeignProperty => 'Propriedade no Exterior';

  @override
  String get prNriAffinity => 'Afinidade com Bens no Exterior';

  @override
  String get prVehiclesTitle => 'Veículos';

  @override
  String get prVehicleCount => 'Número de Veículos';

  @override
  String get prVehicleFirstAge => 'Idade do Primeiro Veículo';

  @override
  String get prVehicleCategory => 'Categoria do Veículo';

  @override
  String get prVehicleQuality => 'Qualidade do Veículo';

  @override
  String get prLuxuryAffinity => 'Afinidade com o Luxo';

  @override
  String get prVehicleLossRisk => 'Risco de Perda / Dano do Veículo';

  @override
  String get prLegalRiskTitle => 'Observação de Riscos Jurídicos';

  @override
  String get prBoundaryDisputes => 'Disputas de Limites';

  @override
  String get prPartitionDisputes => 'Disputas de Partilha';

  @override
  String get prTitleIssues => 'Problemas de Título / Documentação';

  @override
  String get prTenantConflict => 'Conflito Inquilino-Proprietário';

  @override
  String get prForcedSale => 'Risco de Venda Forçada';

  @override
  String get prPropertyDamage => 'Risco de Dano à Propriedade';

  @override
  String get prInsurancePriority => 'Prioridade de Seguro';

  @override
  String get prProtectionUrgency => 'Urgência de Proteção';

  @override
  String get prProtectiveFactors => 'Fatores de Proteção';

  @override
  String get prChronicVulnerabilities => 'Vulnerabilidades Crônicas';

  @override
  String get prDueDiligenceTitle => 'Checklist de Due Diligence';

  @override
  String get prPreventiveMeasures => 'Medidas Preventivas';

  @override
  String get prImprovementTitle => 'Plano de Melhoria';

  @override
  String get prReliabilityTitle => 'Confiabilidade';

  @override
  String get prLayerD1 => 'Mapa Natal (D1)';

  @override
  String get prLayerD4 => 'Mapa de Propriedade (D4)';

  @override
  String get prLayerD16 => 'Mapa de Veículo (D16)';

  @override
  String get prLayerDasha => 'Timing de Dasha';

  @override
  String get prLayerTransit => 'Trânsitos';

  @override
  String get prTopicBuying => 'Melhor momento para comprar?';

  @override
  String get prTopicInherit => 'Vou herdar propriedades?';

  @override
  String get prTopicVehicle => 'Quando vou conseguir um veículo?';

  @override
  String get prTopicRental => 'Potencial de renda de aluguel?';

  @override
  String get prTopicLand => 'Chances de posse de terras?';

  @override
  String get prTopicLegal => 'Riscos jurídicos a observar?';

  @override
  String get prTopicForeign => 'Chances de propriedade no exterior?';

  @override
  String get prTopicTiming => 'Melhores janelas de timing para propriedades?';

  @override
  String get edTitle => 'Análise de Educação e Aprendizado';

  @override
  String get edSubtitle => 'Relatório Védico de Educação com IA';

  @override
  String get edSnapshotHeader => 'Resumo da Sua Educação';

  @override
  String get edOverallStrength => 'Força Geral';

  @override
  String get edAcademicSuccess => 'Sucesso Acadêmico';

  @override
  String get edLearningCapacity => 'Capacidade de Aprendizado';

  @override
  String get edIntellect => 'Intelecto';

  @override
  String get edMemory => 'Memória';

  @override
  String get edStatusExcellent => 'Potencial Excelente';

  @override
  String get edStatusStrong => 'Potencial Forte';

  @override
  String get edStatusModerate => 'Potencial Moderado';

  @override
  String get edStatusDeveloping => 'Potencial em Desenvolvimento';

  @override
  String get edStatusChallenging => 'Fase Desafiadora';

  @override
  String get edChipSaraswati => 'Saraswati Yoga';

  @override
  String get edChipGajaKesari => 'Gaja Kesari Yoga';

  @override
  String get edChipBudhaAditya => 'Budha Aditya Yoga';

  @override
  String get edChipResearch => 'Forte Capacidade de Pesquisa';

  @override
  String get edChipScholarship => 'Potencial para Bolsas de Estudo';

  @override
  String get edChipDoctorate => 'Potencial para Doutorado';

  @override
  String get edChipForeign => 'Apoio para Educação no Exterior';

  @override
  String get edChipLifelong => 'Aprendiz Vitalício';

  @override
  String get edLearningStyleTitle => 'Seu Estilo de Aprendizado';

  @override
  String get edSoulPlanet => 'Planeta da Alma';

  @override
  String get edSoulHint =>
      'Seu impulso interior mais profundo e propósito de vida';

  @override
  String get edSubjectPlanet => 'Planeta da Matéria';

  @override
  String get edTechAtmakaraka => 'Atmakaraka (técnico)';

  @override
  String get edTechAmatyakaraka => 'Amatyakaraka (técnico)';

  @override
  String get edSubjectKarakaStrength => 'Força do Karaka da Matéria';

  @override
  String get edFoundationTitle => 'Fundação Educacional';

  @override
  String get edHouse4 => 'Educação Inicial';

  @override
  String get edHouse5 => 'Inteligência';

  @override
  String get edHouse9 => 'Ensino Superior';

  @override
  String get edPurvaPunya => 'Mérito de Vida Passada';

  @override
  String get edStudyPlanetsTitle => 'Seus Planetas de Estudo';

  @override
  String get edYogasTitle => 'Yogas Educacionais em Seu Mapa';

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
      'Nenhum yoga educacional clássico — o sucesso vem do esforço e da disciplina consistentes.';

  @override
  String get edVerificationTitle => 'Verificação em Múltiplos Mapas';

  @override
  String get edD24Learning => 'D24 — Mapa de Aprendizado Profundo';

  @override
  String get edD4Formal => 'D4 — Mapa de Educação Formal';

  @override
  String get edD9Dharma => 'D9 — Mapa de Dharma do Aprendizado';

  @override
  String get edD60Karma => 'D60 — Carma de Aprendizado de Vida Passada';

  @override
  String get edSubjectsTitle => 'Melhores Matérias Para Você';

  @override
  String get edSubjectsSubtitle => 'Classificadas por afinidade com o mapa';

  @override
  String get edLowAffinity => 'Matérias de Menor Afinidade';

  @override
  String get edDegreesTitle => 'Probabilidade de Grau e Nível';

  @override
  String get edExpectedLevel => 'Nível Esperado';

  @override
  String get edDegreeFormal => 'Diploma Formal';

  @override
  String get edDegreePostgrad => 'Pós-Graduação';

  @override
  String get edDegreeDoctorate => 'Doutorado';

  @override
  String get edDegreeForeign => 'Educação no Exterior';

  @override
  String get edTimelineTitle => 'Cronograma de Estudos';

  @override
  String get edEarlySchooling => 'Janela de Educação Inicial';

  @override
  String get edHigherEducation => 'Janela de Ensino Superior';

  @override
  String get edPostgradResearch => 'Janela de Pós-Graduação / Pesquisa';

  @override
  String get edPeakLearningAge => 'Idade de Pico de Aprendizado';

  @override
  String get edPreferencesTitle => 'Preferências de Aprendizado e Apoio';

  @override
  String get edPrefStudyMode => 'Modo de Estudo';

  @override
  String get edPrefTiming => 'Melhor Horário';

  @override
  String get edPrefEnvironment => 'Ambiente';

  @override
  String get edPrefLocation => 'Localização';

  @override
  String get edPrefForeign => 'Estudo no Exterior';

  @override
  String get edGuruRelationship => 'Vínculo com Professor/Guru';

  @override
  String get edMentorAvailability => 'Disponibilidade de Mentor';

  @override
  String get edPeerLearning => 'Aprendizado entre Colegas';

  @override
  String get edAuthorityDeference => 'Respeito pela Autoridade';

  @override
  String get edStrengthsTitle => 'Pontos Fortes e Desafios';

  @override
  String get edCognitiveGifts => 'Dons Cognitivos';

  @override
  String get edNaturalAbilities => 'Habilidades Naturais de Aprendizado';

  @override
  String get edHiddenCapacities => 'Capacidades Ocultas';

  @override
  String get edConcentration => 'Dificuldade de Concentração';

  @override
  String get edBreakRisk => 'Risco de Interrupção Educacional';

  @override
  String get edDisciplineConsistency => 'Consistência Disciplinar';

  @override
  String get edScholarshipLikelihood => 'Probabilidade de Bolsa de Estudos';

  @override
  String get edCareerLinkTitle => 'Educação → Caminho Profissional';

  @override
  String get edDirectionRec => 'Direção Recomendada';

  @override
  String get edIntegrationStrategy => 'Estratégia de Integração';

  @override
  String get edCareerLinkage => 'Ligação com a Carreira';

  @override
  String get edAlignedSubjects => 'Matérias Alinhadas à Carreira';

  @override
  String get edDegreeUtility => 'Utilidade do Diploma para a Carreira';

  @override
  String get edImprovementTitle => 'Seu Plano de Melhoria';

  @override
  String get edReliabilityTitle => 'Confiabilidade da Previsão';

  @override
  String get edLayerD1 => 'Mapa Natal (D1)';

  @override
  String get edLayerD4 => 'Educação Formal (D4)';

  @override
  String get edLayerD9 => 'Navamsa (D9)';

  @override
  String get edLayerD24 => 'Aprendizado Profundo (D24)';

  @override
  String get edLayerD60 => 'Aprendizado de Vida Passada (D60)';

  @override
  String get edLayerAmk => 'Karaka da Matéria';

  @override
  String get edLayerMj => 'Mercúrio-Júpiter';

  @override
  String get edLayerDasha => 'Timing Planetário';

  @override
  String get edTopicSubjects => 'Melhores Matérias Para Mim';

  @override
  String get edTopicDegree => 'Chances de Obter Diploma';

  @override
  String get edTopicAbroad => 'Estudar no Exterior';

  @override
  String get edTopicExam => 'Desempenho em Provas';

  @override
  String get edTopicHabits => 'Hábitos de Estudo';

  @override
  String get edTopicCareerLink => 'Ligação entre Educação e Carreira';

  @override
  String get edTopicTiming => 'Janelas de Timing Educacional';

  @override
  String get edTopicScholarship => 'Chances de Bolsa de Estudos';

  @override
  String get hwTitle => 'Análise de Saúde e Bem-Estar';

  @override
  String get hwSubtitle => 'Relatório Védico de Saúde e Bem-Estar com IA';

  @override
  String get hwSnapshotHeader => 'Resumo da Sua Saúde';

  @override
  String get hwOverallVitality => 'Vitalidade';

  @override
  String get hwImmunity => 'Imunidade';

  @override
  String get hwRecovery => 'Recuperação';

  @override
  String get hwMentalWellness => 'Bem-Estar Mental';

  @override
  String get hwStressTolerance => 'Tolerância ao Estresse';

  @override
  String get hwStatusThriving => 'Em Plena Forma';

  @override
  String get hwStatusGood => 'Boa Vitalidade';

  @override
  String get hwStatusBalanced => 'Equilibrado';

  @override
  String get hwStatusNeedsCare => 'Precisa de Cuidado';

  @override
  String get hwStatusNeedsAttention => 'Precisa de Atenção';

  @override
  String get hwChipImmunity => 'Imunidade Forte';

  @override
  String get hwChipRecovery => 'Recuperação Rápida';

  @override
  String get hwChipMentalBalance => 'Mente Equilibrada';

  @override
  String get hwChipStressResilience => 'Resiliente ao Estresse';

  @override
  String get hwChipFertility => 'Apoio à Fertilidade';

  @override
  String get hwChipWorkLife => 'Bom Equilíbrio Trabalho-Vida';

  @override
  String get hwChipLowAddiction => 'Baixo Risco de Dependência';

  @override
  String get hwConstitutionTitle => 'Seu Tipo Corporal';

  @override
  String get hwConstitutionSubtitle =>
      'Constituição ayurvédica a partir do seu mapa';

  @override
  String get hwDominantDosha => 'Dominante';

  @override
  String get hwSecondaryDosha => 'Secundário';

  @override
  String get hwPrimaryKaraka => 'Principal Indicador de Saúde';

  @override
  String get hwStrongestSystem => 'Sistema Mais Forte';

  @override
  String get hwWeakestSystem => 'Sistema a Fortalecer';

  @override
  String get hwBodyMapTitle => 'O Mapa Planetário do Seu Corpo';

  @override
  String get hwBodyMapSubtitle => '9 planetas, 9 sistemas corporais';

  @override
  String get hwYogaTitle => 'Padrões de Saúde no Seu Mapa';

  @override
  String get hwYogaSubtitle => 'Yogas de proteção vs pressão de doença';

  @override
  String get hwDiseasePressureLabel => 'PRESSÃO DE DOENÇA';

  @override
  String get hwAreasTitle => 'Áreas do Corpo a Observar';

  @override
  String get hwAreasSubtitle => 'Vulnerabilidade por zona corporal';

  @override
  String get hwProtectedAreas => 'Áreas Bem Protegidas';

  @override
  String get hwCategoriesTitle => 'Observação de Categorias de Doença';

  @override
  String get hwCategoriesSubtitle =>
      'Suscetibilidade nas principais categorias de saúde';

  @override
  String get hwLowRiskCategories => 'Categorias de Baixo Risco';

  @override
  String get hwMentalTitle => 'Bem-Estar Mental e Emocional';

  @override
  String get hwMentalSubtitle =>
      'Resiliência emocional e necessidades de apoio';

  @override
  String get hwMentalVulnerability => 'Sensibilidade Emocional';

  @override
  String get hwEmotionalRegulation => 'Regulação Emocional';

  @override
  String get hwSupportRec => 'Recomendação de Apoio';

  @override
  String get hwTendencies => 'Tendências Mentais';

  @override
  String get hwTimelineTitle => 'Linha do Tempo da Saúde';

  @override
  String get hwTimelineSubtitle =>
      'Anos de pico, anos de cautela e janelas de recuperação';

  @override
  String get hwPeakYears => 'Anos de Pico de Bem-Estar';

  @override
  String get hwCautionYears => 'Anos de Cautela';

  @override
  String get hwRecoveryWindow => 'Janela de Recuperação';

  @override
  String get hwCheckupYears => 'Anos Recomendados para Check-up';

  @override
  String get hwCurrentPhase => 'Fase Atual';

  @override
  String get hwLifestyleTitle => 'Seu Guia de Estilo de Vida';

  @override
  String get hwLifestyleSubtitle => 'O que seu mapa diz sobre hábitos diários';

  @override
  String get hwSleepDiscipline => 'Impacto da Disciplina do Sono';

  @override
  String get hwDietDiscipline => 'Impacto da Disciplina Alimentar';

  @override
  String get hwExerciseNeed => 'Necessidade de Exercício';

  @override
  String get hwSunlightNeed => 'Necessidade de Luz Solar';

  @override
  String get hwStressSusceptibility => 'Suscetibilidade ao Estresse';

  @override
  String get hwHydrationSensitivity => 'Sensibilidade à Hidratação';

  @override
  String get hwSocialType => 'Tipo de Energia Social';

  @override
  String get hwHealingSpeed => 'Velocidade de Cura';

  @override
  String get hwTreatmentResponse => 'Resposta ao Tratamento';

  @override
  String get hwAltHealing => 'Afinidade com Cura Alternativa';

  @override
  String get hwSpecialTitle => 'Estágios de Vida e Tópicos Especiais';

  @override
  String get hwSpecialSubtitle =>
      'Fertilidade, saúde infantil, hábitos e esgotamento';

  @override
  String get hwFertility => 'Indicador de Fertilidade';

  @override
  String get hwHormonalBalance => 'Equilíbrio Hormonal';

  @override
  String get hwReproductiveStrength => 'Força do Sistema Reprodutivo';

  @override
  String get hwChildhoodVuln => 'Vulnerabilidade de Saúde na Infância';

  @override
  String get hwChildhoodStatus => 'Saúde na Infância';

  @override
  String get hwAddictionVuln => 'Vulnerabilidade à Dependência';

  @override
  String get hwAddictionRecovery => 'Capacidade de Recuperação';

  @override
  String get hwBurnoutVuln => 'Vulnerabilidade ao Esgotamento';

  @override
  String get hwWorkLifeBalance => 'Equilíbrio Trabalho-Vida';

  @override
  String get hwStressTriggers => 'Gatilhos de Estresse';

  @override
  String get hwProtectiveFactors => 'Fatores de Proteção';

  @override
  String get hwChallengesTitle => 'Desafios a Observar';

  @override
  String get hwChallengesSubtitle => 'Onde focar os cuidados preventivos';

  @override
  String get hwMitigation => 'Como Gerenciar';

  @override
  String get hwChronicAreas => 'Áreas de Vulnerabilidade Crônica';

  @override
  String get hwPreventivePriorities => 'Prioridades Preventivas';

  @override
  String get hwImprovementTitle => 'Seu Plano de Bem-Estar';

  @override
  String get hwImprovementSubtitle => 'Passos práticos + remédios tradicionais';

  @override
  String get hwReliabilityTitle => 'Confiabilidade da Leitura';

  @override
  String get hwLayerD1 => 'Mapa Natal (D1)';

  @override
  String get hwLayerD6 => 'Mapa de Saúde (D6)';

  @override
  String get hwLayerD30 => 'Mapa de Micro-Saúde (D30)';

  @override
  String get hwLayerDasha => 'Timing Planetário';

  @override
  String get hwLayerTransit => 'Trânsitos Atuais';

  @override
  String get hwDisclaimerLabel => 'Aviso Médico';

  @override
  String get hwTopicImmunity => 'Aumentar a Imunidade';

  @override
  String get hwTopicSleep => 'Sono e Descanso';

  @override
  String get hwTopicStress => 'Gerenciar o Estresse';

  @override
  String get hwTopicFertility => 'Timing de Fertilidade';

  @override
  String get hwTopicDiet => 'Dieta e Nutrição';

  @override
  String get hwTopicTiming => 'Janelas de Timing de Saúde';

  @override
  String get hwTopicMental => 'Bem-Estar Mental';

  @override
  String get hwTopicPrevention => 'Plano de Cuidados Preventivos';

  @override
  String get lvSubtitle => 'Relatório Védico de Amor com IA';

  @override
  String get lvTitle => 'Amor e Relacionamentos';

  @override
  String get lvLovePotential => 'Potencial Amoroso';

  @override
  String get lvEmotionalAvail => 'Emocionalmente Aberto';

  @override
  String get lvAttraction => 'Atração';

  @override
  String get lvCommitment => 'Compromisso';

  @override
  String get lvCommunication => 'Comunicação';

  @override
  String get lvFidelity => 'Lealdade';

  @override
  String get lvChipLoyal => 'Coração leal';

  @override
  String get lvChipOpenHeart => 'Coração aberto';

  @override
  String get lvChipCommunicator => 'Ótimo comunicador';

  @override
  String get lvChipMature => 'Lida bem com conflitos';

  @override
  String get lvChipEmotionallyWise => 'Emocionalmente sábio';

  @override
  String get lvLoveStyle => 'Seu Estilo Amoroso';

  @override
  String get lvAttractionStyle => 'Estilo de atração';

  @override
  String get lvLangGiven => 'Você Expressa Amor Por';

  @override
  String get lvLangReceived => 'Você Se Sente Amado Por';

  @override
  String get lvLovePlanets => 'Seus Planetas do Amor';

  @override
  String get lvLoveKaraka => 'Amor';

  @override
  String get lvEmotionKaraka => 'Emoção';

  @override
  String get lvPassionKaraka => 'Paixão';

  @override
  String get lvPathToLove => 'Seu Caminho para o Amor';

  @override
  String get lvPathSub => 'Amor vs arranjado';

  @override
  String get lvLoveMarriage => 'Casamento por Amor';

  @override
  String get lvArrangedMarriage => 'Casamento Arranjado';

  @override
  String get lvParentalAccept => 'Aceitação dos Pais';

  @override
  String get lvInterCaste => 'Inter-castas / Religião';

  @override
  String get lvIdealPartner => 'Seu Parceiro Ideal';

  @override
  String get lvPersonality => 'Personalidade';

  @override
  String get lvAppearance => 'Aparência';

  @override
  String get lvIdealTraits => 'Traços Ideais';

  @override
  String get lvWhatMatters => 'O Que Mais Importa';

  @override
  String get lvDrawnTo => 'Atraído por';

  @override
  String get lvDealbreakers => 'Fatores Decisivos Negativos';

  @override
  String get lvYourAppeal => 'Seu apelo';

  @override
  String get lvLoveStory => 'Sua História de Amor';

  @override
  String get lvLoveStorySub => 'Padrões de relacionamento';

  @override
  String get lvFirstLove => 'Primeiro Amor';

  @override
  String get lvRelationCount => 'Vínculos Significativos';

  @override
  String get lvDuration => 'Duração Típica';

  @override
  String get lvDepth => 'Profundidade Emocional';

  @override
  String get lvDatingPattern => 'Padrão de Namoro';

  @override
  String get lvCommitIntimacy => 'Compromisso e Intimidade';

  @override
  String get lvCommitReady => 'Prontidão para o Compromisso';

  @override
  String get lvIntimacyDrive => 'Impulso de Intimidade';

  @override
  String get lvSensuality => 'Sensualidade';

  @override
  String get lvEmpathy => 'Empatia';

  @override
  String get lvCommitStyle => 'Estilo de Compromisso';

  @override
  String get lvChemistry => 'Estilo de Química';

  @override
  String get lvMakesCommit => 'O Que Faz Você se Comprometer';

  @override
  String get lvMakesFlee => 'O Que Te Afasta';

  @override
  String get lvEmotional => 'Inteligência Emocional';

  @override
  String get lvEmotionalIQ => 'QI Emocional';

  @override
  String get lvConflictStyle => 'Estilo de Conflito';

  @override
  String get lvTiming => 'Timing do Amor';

  @override
  String get lvNewLove12 => 'Novo amor em 12 meses';

  @override
  String get lvEnergyNow => 'Energia agora';

  @override
  String get lvPhaseNow => 'Fase atual';

  @override
  String get lvPeakRomance => 'Anos de Pico Romântico';

  @override
  String get lvNewLoveWindow => 'Janela para Novo Amor';

  @override
  String get lvChallenges => 'Desafios a Observar';

  @override
  String get lvRiskHeartbreak => 'Vulnerabilidade ao Sofrimento Amoroso';

  @override
  String get lvRiskSabotage => 'Autossabotagem';

  @override
  String get lvRiskCommitFear => 'Medo de Compromisso';

  @override
  String get lvRiskRepeat => 'Padrões Repetidos';

  @override
  String get lvRiskWorkaholic => 'Trabalho Acima do Amor';

  @override
  String get lvRedFlags => 'Sinais de alerta a observar';

  @override
  String get lvHealing => 'O Que Curar';

  @override
  String get lvFocusArea => 'Área de Foco';

  @override
  String get lvHealDir => 'Direção da cura';

  @override
  String get lvImprovementPlan => 'Plano de Melhoria';

  @override
  String get lvReliability => 'Confiabilidade da Previsão';

  @override
  String get lvLayerBirth => 'Mapa Natal (D1)';

  @override
  String get lvLayerNavamsa => 'Navamsa (D9)';

  @override
  String get lvLayerSaptamsa => 'Saptamsa (D7)';

  @override
  String get lvLayerDasha => 'Timing de Dasha';

  @override
  String get lvLayerTransit => 'Trânsitos Atuais';

  @override
  String get lvTopicWhen => 'Quando encontrarei o amor?';

  @override
  String get lvTopicSoulmate => 'Sobre minha alma gêmea';

  @override
  String get lvTopicCurrent => 'Meu relacionamento atual';

  @override
  String get lvTopicHeal => 'Curando o passado';

  @override
  String get lvTopicCommit => 'Ajuda com compromisso';

  @override
  String get lvTopicLoveVsArranged => 'Amor vs arranjado';

  @override
  String get lvTopicHeartbreak => 'Evitando o sofrimento amoroso';

  @override
  String get lvTopicConfidence => 'Confiança no amor';

  @override
  String get mrSubtitle => 'Relatório Védico de Casamento com IA';

  @override
  String get mrTitle => 'Casamento e Família';

  @override
  String get mrMarriagePotential => 'Potencial de Casamento';

  @override
  String get mrHarmony => 'Harmonia';

  @override
  String get mrLongevity => 'Longevidade';

  @override
  String get mrSatisfaction => 'Satisfação';

  @override
  String get mrStability => 'Estabilidade do Lar';

  @override
  String get mrClarity => 'Clareza';

  @override
  String get mrChipHarmony => 'Vínculo harmonioso';

  @override
  String get mrChipNoMangal => 'Sem Mangal dosh';

  @override
  String get mrChipLongLasting => 'Duradouro';

  @override
  String get mrChipHome => 'Casa própria provável';

  @override
  String get mrChipInLaws => 'Boa relação com sogros';

  @override
  String get mrChipChildren => 'Abençoado com filhos';

  @override
  String get mrSpouse => 'Seu Futuro Cônjuge';

  @override
  String get mrSpouseSub => 'O que o mapa sugere';

  @override
  String get mrSpouseTraits => 'Personalidade Provável';

  @override
  String get mrSpouseWork => 'Profissão Provável';

  @override
  String get mrAgeDiff => 'Diferença de Idade';

  @override
  String get mrCulture => 'Compatibilidade Cultural';

  @override
  String get mrEducation => 'Educação';

  @override
  String get mrFamilyBg => 'Origem Familiar';

  @override
  String get mrSoulPartnership => 'Alma e Parceria';

  @override
  String get mrSelfPlanet => 'Você em um Vínculo';

  @override
  String get mrSpousePlanet => 'Planeta do Seu Cônjuge';

  @override
  String get mrSoulAlignment => 'Alinhamento da Alma';

  @override
  String get mrAlignStrong =>
      'Sua alma e seu parceiro ideal estão fortemente alinhados — um vínculo profundamente gratificante é bem apoiado.';

  @override
  String get mrAlignModerate =>
      'Sua alma e seu parceiro ideal estão moderadamente alinhados — um vínculo gratificante cresce com esforço consciente.';

  @override
  String get mrAlignLow =>
      'Sua alma e a parceria precisam de integração consciente — escolha um parceiro que realmente combine com seus valores internos.';

  @override
  String get mrTechDarakaraka => 'Planeta do cônjuge (Darakaraka)';

  @override
  String get mrUpapada => 'Ponto do casamento (Upapada)';

  @override
  String get mrUpapadaLord => 'Regente do Upapada';

  @override
  String get mrFoundation => 'Fundação do Casamento';

  @override
  String get mrMarriageSign => 'Signo do Casamento';

  @override
  String get mrMarriageLord => 'Regente do Casamento';

  @override
  String get mrHouseStrength => 'Força da Casa';

  @override
  String get mrPartnerHint => 'Indício do parceiro no seu mapa';

  @override
  String get mrHarmonyHdr => 'Harmonia de Compatibilidade';

  @override
  String get mrHarmonySub => 'Como vocês se conectarão';

  @override
  String get mrEmotional => 'Emocional';

  @override
  String get mrIntellectual => 'Intelectual';

  @override
  String get mrPhysical => 'Intimidade Física';

  @override
  String get mrFinancial => 'Financeiro';

  @override
  String get mrCommunication => 'Comunicação';

  @override
  String get mrSharedValues => 'Valores Compartilhados';

  @override
  String get mrSpiritual => 'Espiritual';

  @override
  String get mrConflictRes => 'Resolução de Conflitos';

  @override
  String get mrTiming => 'Timing do Casamento';

  @override
  String get mrFirstMarriageAge => 'Idade Provável do Casamento';

  @override
  String get mrDelayChance => 'Chance de atraso';

  @override
  String get mrMarriageWindow => 'Janela do Casamento';

  @override
  String get mrSecondaryWindow => 'Janela Alternativa';

  @override
  String get mrCurrentReadiness => 'Agora Mesmo';

  @override
  String get mrJourney => 'Jornada do Casamento';

  @override
  String get mrJourneySub => 'Como o vínculo evolui';

  @override
  String get mrPhaseEarly => 'Primeiros Anos';

  @override
  String get mrPhaseMid => 'Anos Intermediários';

  @override
  String get mrPhaseMature => 'Anos de Maturidade';

  @override
  String get mrPhaseLate => 'Últimos Anos';

  @override
  String get mrTip => 'Dica';

  @override
  String get mrFamilyHome => 'Família e Lar';

  @override
  String get mrInLaws => 'Relação com os Sogros';

  @override
  String get mrFamilyHarmony => 'Harmonia Familiar';

  @override
  String get mrHomeOwnership => 'Posse de Imóvel';

  @override
  String get mrDomesticPeace => 'Paz Doméstica';

  @override
  String get mrFertility => 'Fertilidade';

  @override
  String get mrParenting => 'Harmonia na Criação dos Filhos';

  @override
  String get mrChildren => 'Filhos';

  @override
  String get mrLikelyCount => 'Número provável';

  @override
  String get mrVerification => 'Verificação entre Mapas';

  @override
  String get mrD9 => 'Mapa do Casamento (D9)';

  @override
  String get mrD10 => 'Mapa Carreira-Cônjuge (D10)';

  @override
  String get mrD60 => 'Mapa do Carma (D60)';

  @override
  String get mrChallenges => 'Desafios a Observar';

  @override
  String get mrMangalPresent =>
      'Mangal Dosh está presente no mapa — revise com cuidado os remédios e a compatibilidade.';

  @override
  String get mrMangalAbsent =>
      'Nenhum Mangal Dosh detectado — um indicador favorável para o casamento.';

  @override
  String get mrRiskConflict => 'Conflito';

  @override
  String get mrRiskSeparation => 'Separação';

  @override
  String get mrRiskDistance => 'Distância Emocional';

  @override
  String get mrRiskInfidelity => 'Infidelidade';

  @override
  String get mrRiskFinance => 'Desentendimentos Financeiros';

  @override
  String get mrPartnerGuide => 'Guia do Parceiro';

  @override
  String get mrPartnerGuideSub => 'O que procurar';

  @override
  String get mrSeek => 'Procure por';

  @override
  String get mrMatchingPriorities => 'Prioridades de Compatibilidade';

  @override
  String get mrImprovementPlan => 'Plano de Melhoria';

  @override
  String get mrReliability => 'Confiabilidade da Previsão';

  @override
  String get mrLayerBirth => 'Mapa Natal (D1)';

  @override
  String get mrLayerNavamsa => 'Navamsa (D9)';

  @override
  String get mrLayerDashamsa => 'Dashamsa (D10)';

  @override
  String get mrLayerShashtiamsa => 'Carma (D60)';

  @override
  String get mrLayerDarakaraka => 'Planeta do Cônjuge';

  @override
  String get mrTopicWhen => 'Quando vou me casar?';

  @override
  String get mrTopicSpouse => 'Sobre meu cônjuge';

  @override
  String get mrTopicCompat => 'Dicas de compatibilidade';

  @override
  String get mrTopicDelay => 'Atraso no casamento';

  @override
  String get mrTopicMangal => 'Mangal dosh';

  @override
  String get mrTopicChildren => 'Timing dos filhos';

  @override
  String get mrTopicInLaws => 'Relação com os sogros';

  @override
  String get mrTopicHarmony => 'Construindo harmonia';

  @override
  String get wlSubtitle => 'Relatório Védico de Riqueza com IA';

  @override
  String get wlTitle => 'Riqueza e Finanças';

  @override
  String get wlWealthPotential => 'Potencial de Riqueza';

  @override
  String get wlAccumulation => 'Acumulação';

  @override
  String get wlIncomeFlow => 'Fluxo de Renda';

  @override
  String get wlRetention => 'Retenção';

  @override
  String get wlSustainability => 'Sustentabilidade';

  @override
  String get wlSavings => 'Disciplina de Poupança';

  @override
  String get wlChipSaver => 'Poupador natural';

  @override
  String get wlChipMultiIncome => 'Múltiplas fontes de renda';

  @override
  String get wlChipStrongYogas => 'Yogas de riqueza';

  @override
  String get wlChipLowDebt => 'Baixa dívida';

  @override
  String get wlChipInheritance => 'Herança provável';

  @override
  String get wlChipInvestor => 'Investidor inteligente';

  @override
  String get wlWealthClass => 'Classe de Riqueza';

  @override
  String get wlWealthType => 'Principal Tipo de Riqueza';

  @override
  String get wlPrimarySource => 'Renda Principal';

  @override
  String get wlPeakAge => 'Idade de Pico de Riqueza';

  @override
  String get wlBoosters => 'O Que Está Impulsionando Sua Riqueza';

  @override
  String get wlBoostersSub => 'Combinações poderosas de dinheiro';

  @override
  String get wlWealthImpact => 'impulso';

  @override
  String get wlDrains => 'Drenos de Riqueza';

  @override
  String get wlIncomeSources => 'Fontes de Renda';

  @override
  String get wlIncomeSourcesSub => 'De onde vem o seu dinheiro';

  @override
  String get wlPrimary => 'Principal';

  @override
  String get wlInvestment => 'Plano de Investimento';

  @override
  String get wlInvestmentSub => 'Mix ideal de ativos';

  @override
  String get wlRiskAppetite => 'Apetite ao Risco';

  @override
  String get wlInvestStyle => 'Estilo de Investimento';

  @override
  String get wlDrivenBy => 'Impulsionado por';

  @override
  String get wlMoneyPersonality => 'Personalidade Financeira';

  @override
  String get wlMoneyType => 'Tipo de Relação com o Dinheiro';

  @override
  String get wlSpending => 'Gastos';

  @override
  String get wlSavingsDiscipline => 'Disciplina de Poupança';

  @override
  String get wlCharity => 'Inclinação à Caridade';

  @override
  String get wlLuxury => 'Gastos com Luxo';

  @override
  String get wlWindfalls => 'Ganhos Inesperados e Chances';

  @override
  String get wlWindfallsSub => 'Dinheiro baseado em sorte';

  @override
  String get wlInheritanceChance => 'Herança';

  @override
  String get wlSuddenGains => 'Ganhos Repentinos';

  @override
  String get wlLottery => 'Loteria / Especulação';

  @override
  String get wlInsurance => 'Indenizações de Seguro';

  @override
  String get wlWindfallSource => 'Fonte provável de ganho inesperado';

  @override
  String get wlMoneyPlanets => 'Seus Planetas do Dinheiro';

  @override
  String get wlPrimaryKaraka => 'Planeta Financeiro Primário';

  @override
  String get wlSecondaryKaraka => 'Planeta Financeiro Secundário';

  @override
  String get wlTimeline => 'Linha do Tempo da Riqueza';

  @override
  String get wlPeakYears => 'Anos de Pico';

  @override
  String get wlGoodPeriod => 'Período Próspero';

  @override
  String get wlSuddenGainWindow => 'Janela de Ganho Repentino';

  @override
  String get wlToughPeriod => 'Período de Cautela';

  @override
  String get wlDebtRisks => 'Riscos de Dívida e Dinheiro';

  @override
  String get wlDebtChance => 'Probabilidade de Dívida';

  @override
  String get wlLoanBurden => 'Peso de Empréstimos';

  @override
  String get wlDrainSources => 'Fique atento a';

  @override
  String get wlStrengthen => 'O Que Fortalecer';

  @override
  String get wlWeakestDriver => 'Fator Financeiro Mais Fraco';

  @override
  String get wlHowToFix => 'Como fortalecer';

  @override
  String get wlImprovementPlan => 'Plano de Melhoria';

  @override
  String get wlReliability => 'Confiabilidade da Previsão';

  @override
  String get wlLayerBirth => 'Casas de Riqueza (D1)';

  @override
  String get wlLayerHora => 'Mapa Hora (D2)';

  @override
  String get wlLayerNavamsa => 'Navamsa (D9)';

  @override
  String get wlLayerDasha => 'Timing de Dasha';

  @override
  String get wlLayerTransit => 'Trânsitos Atuais';

  @override
  String get wlTopicGrow => 'Como aumentar a riqueza';

  @override
  String get wlTopicInvest => 'Onde investir';

  @override
  String get wlTopicDebt => 'Gerenciando dívidas';

  @override
  String get wlTopicProperty => 'Comprando propriedades';

  @override
  String get wlTopicRetire => 'Planejamento de aposentadoria';

  @override
  String get wlTopicPassive => 'Renda passiva';

  @override
  String get wlTopicWindfall => 'Ganhos repentinos';

  @override
  String get wlTopicTiming => 'Melhor timing financeiro';

  @override
  String get bzSubtitle => 'Relatório Védico de Negócios com IA';

  @override
  String get bzTitle => 'Negócios e Startups';

  @override
  String get bzBusinessPotential => 'Potencial de Negócios';

  @override
  String get bzEntrepreneurship => 'Empreendedor';

  @override
  String get bzVenture => 'Sucesso do Empreendimento';

  @override
  String get bzWealth => 'Riqueza via Negócios';

  @override
  String get bzRiskAppetite => 'Apetite ao Risco';

  @override
  String get bzLongevity => 'Longevidade';

  @override
  String get bzChipWealthMagnet => 'Ímã de riqueza';

  @override
  String get bzChipMoneyYoga => 'Yoga de dinheiro';

  @override
  String get bzChipLeadership => 'Liderança';

  @override
  String get bzChipPartnerFit => 'Ótima compatibilidade com sócios';

  @override
  String get bzChipGains => 'Fortes ganhos';

  @override
  String get bzChipInvestor => 'Atrai investidores';

  @override
  String get bzChipFounder => 'Mentalidade de fundador';

  @override
  String get bzWhatsWorking => 'O Que Está Funcionando Para Você';

  @override
  String get bzWhatsWorkingSub => 'Seus dons para os negócios';

  @override
  String get bzClassicYogas => 'Combinações clássicas de riqueza';

  @override
  String get bzFounderType => 'Seu Tipo de Fundador';

  @override
  String get bzSoulBusiness => 'Alma e Propósito Empresarial';

  @override
  String get bzSoulPlanet => 'Seu Impulsionador da Alma';

  @override
  String get bzBusinessPlanet => 'Sua Mente Empresarial';

  @override
  String get bzDirectionStrength => 'Clareza de Direção';

  @override
  String get bzAlignStrong =>
      'Seu propósito de alma e sua direção empresarial estão fortemente alinhados — construir um empreendimento parece natural e gratificante.';

  @override
  String get bzAlignModerate =>
      'Seu propósito de alma e sua direção empresarial estão moderadamente alinhados — um empreendimento funciona melhor quando reflete seus valores mais profundos.';

  @override
  String get bzAlignLow =>
      'Seu propósito de alma e sua direção empresarial precisam de alinhamento consciente — escolha um empreendimento que realmente combine com quem você é.';

  @override
  String get bzTechAtmakaraka => 'Planeta da alma (Atmakaraka)';

  @override
  String get bzTechAmatyakaraka => 'Planeta dos negócios (Amatyakaraka)';

  @override
  String get bzTechDarakaraka => 'Planeta do sócio (Darakaraka)';

  @override
  String get bzFoundation => 'Fundação Empresarial';

  @override
  String get bzCareerHouse => 'Casa da Carreira';

  @override
  String get bzGainsHouse => 'Casa dos Ganhos';

  @override
  String get bzLord => 'Regente';

  @override
  String get bzGainsPotential => 'Potencial de Ganhos';

  @override
  String get bzNetwork => 'Poder de Rede';

  @override
  String get bzRecovery => 'Força de Recuperação';

  @override
  String get bzVerification => 'Verificação entre Mapas';

  @override
  String get bzD10 => 'Mapa de Carreira (D10)';

  @override
  String get bzD11 => 'Mapa de Ganhos (D11)';

  @override
  String get bzD9 => 'Mapa de Propósito (D9)';

  @override
  String get bzD60 => 'Mapa do Carma (D60)';

  @override
  String get bzFounderSkills => 'Habilidades de Fundador';

  @override
  String get bzSkillStrategy => 'Pensamento Estratégico';

  @override
  String get bzSkillExecution => 'Execução';

  @override
  String get bzSkillPeople => 'Gestão de Pessoas';

  @override
  String get bzSkillSales => 'Vendas e Persuasão';

  @override
  String get bzSkillFinance => 'Perspicácia Financeira';

  @override
  String get bzSkillOps => 'Disciplina Operacional';

  @override
  String get bzTopSkill => 'Principal Habilidade';

  @override
  String get bzDomains => 'Melhores Áreas de Negócio';

  @override
  String get bzDomainsSub => 'Classificadas por afinidade natural';

  @override
  String get bzFit => 'COMPATIBILIDADE';

  @override
  String get bzBusinessStyleHdr => 'Estilo de Negócio';

  @override
  String get bzStyleService => 'Produto vs Serviço';

  @override
  String get bzStyleMarket => 'Foco de Mercado';

  @override
  String get bzStyleTech => 'Abordagem Tecnológica';

  @override
  String get bzStyleLeadership => 'Estilo de Liderança';

  @override
  String get bzStylePartnership => 'Solo ou Sociedade';

  @override
  String get bzWhereBuild => 'Alcance';

  @override
  String get bzExpansion => 'Expansão';

  @override
  String get bzSetup => 'Estrutura';

  @override
  String get bzPartnership => 'Sociedade e Equipe';

  @override
  String get bzIdealCofounder => 'Cofundador Ideal';

  @override
  String get bzPartnerViability => 'Compatibilidade de Sociedade';

  @override
  String get bzTeamBuilding => 'Formação de Equipe';

  @override
  String get bzCofounderFit => 'Compatibilidade com Cofundador';

  @override
  String get bzAdvisorNetwork => 'Rede de Conselheiros';

  @override
  String get bzFunding => 'Financiamento e Dinheiro';

  @override
  String get bzRecommendedPath => 'Caminho de Financiamento Recomendado';

  @override
  String get bzInvestorAttract => 'Atração de Investidores';

  @override
  String get bzFamilyBacking => 'Apoio Familiar';

  @override
  String get bzHybridViability => 'Mix de Emprego + Negócio';

  @override
  String get bzFallback => 'Emprego como Alternativa';

  @override
  String get bzDebtStyle => 'Estilo de Endividamento';

  @override
  String get bzTimeline => 'Linha do Tempo do Negócio';

  @override
  String get bzCurrentPhase => 'Agora Mesmo';

  @override
  String get bzLaunchWindow => 'Janela de Lançamento';

  @override
  String get bzScaleWindow => 'Janela de Crescimento';

  @override
  String get bzPeakAge => 'Anos de Pico';

  @override
  String get bzChallenges => 'Desafios a Observar';

  @override
  String get bzRiskFinancial => 'Perda Financeira';

  @override
  String get bzRiskBurnout => 'Esgotamento';

  @override
  String get bzRiskTeam => 'Conflito de Equipe';

  @override
  String get bzRiskLegal => 'Jurídico / Regulatório';

  @override
  String get bzFinancialExp =>
      'Risco de perda financeira por excesso de investimento ou má gestão do fluxo de caixa durante um empreendimento.';

  @override
  String get bzFinancialFix =>
      'Mantenha uma reserva de caixa, comece de forma enxuta e valide a demanda antes de aumentar os gastos.';

  @override
  String get bzBurnoutExp =>
      'Se esforçar demais por muito tempo pode drenar sua energia e foco.';

  @override
  String get bzBurnoutFix =>
      'Proteja o descanso, delegue cedo e ritme os grandes esforços em torno de períodos favoráveis.';

  @override
  String get bzTeamExp =>
      'Atritos com cofundadores ou equipe podem desacelerar o negócio.';

  @override
  String get bzTeamFix =>
      'Defina papéis e expectativas claras por escrito, e comunique-se com frequência.';

  @override
  String get bzLegalExp =>
      'Questões de conformidade, contratos ou regulamentação podem criar obstáculos.';

  @override
  String get bzLegalFix =>
      'Faça revisar os contratos, mantenha a documentação organizada e consulte profissionais desde cedo.';

  @override
  String get bzImprovementPlan => 'Plano de Melhoria';

  @override
  String get bzBestDirection => 'Melhor Direção';

  @override
  String get bzStrategy => 'Estratégia de Construção';

  @override
  String get bzTopFields => 'Principais Áreas';

  @override
  String get bzEmploymentPath => 'Emprego vs Negócio';

  @override
  String get bzRoadmap => 'Roteiro de Crescimento';

  @override
  String get bzRoadmapSub => 'Seu plano de empreendimento';

  @override
  String get bzReliability => 'Confiabilidade da Previsão';

  @override
  String get bzLayerBirth => 'Mapa Natal (D1)';

  @override
  String get bzLayerNavamsa => 'Navamsa (D9)';

  @override
  String get bzLayerDashamsa => 'Carreira (D10)';

  @override
  String get bzLayerLabhamsa => 'Ganhos (D11)';

  @override
  String get bzLayerShashtiamsa => 'Carma (D60)';

  @override
  String get bzTopicStart => 'Devo começar agora?';

  @override
  String get bzTopicIdea => 'Melhor ideia de negócio';

  @override
  String get bzTopicPartner => 'Encontrando um cofundador';

  @override
  String get bzTopicFunding => 'Como financiar';

  @override
  String get bzTopicScale => 'Quando expandir';

  @override
  String get bzTopicRisk => 'Gerenciando riscos';

  @override
  String get bzTopicJob => 'Emprego vs negócio';

  @override
  String get bzTopicTiming => 'Melhor timing';

  @override
  String get crTitle => 'Análise de Carreira e Emprego';

  @override
  String get crSubtitle => 'Relatório Védico de Carreira com IA';

  @override
  String get crCrumbHome => 'Início';

  @override
  String get crCrumbReports => 'Relatórios';

  @override
  String get crCareerPotential => 'Potencial de Carreira';

  @override
  String get crStatusStrong => 'Potencial Forte';

  @override
  String get crStatusGood => 'Bom Potencial';

  @override
  String get crStatusModerate => 'Potencial Moderado';

  @override
  String get crStatusDeveloping => 'Potencial em Desenvolvimento';

  @override
  String get crStatusChallenging => 'Fase Desafiadora';

  @override
  String get crOverallCareer => 'Carreira Geral';

  @override
  String get crStability => 'Estabilidade Profissional';

  @override
  String get crGrowth => 'Potencial de Crescimento';

  @override
  String get crRecognition => 'Reconhecimento';

  @override
  String get crSatisfaction => 'Satisfação';

  @override
  String get crChipLeadership => 'Liderança';

  @override
  String get crChipCreativity => 'Criatividade';

  @override
  String get crChipBusiness => 'Negócios';

  @override
  String get crChipStableIncome => 'Renda Estável';

  @override
  String get crChipLearning => 'Aprendizado';

  @override
  String get crChipGrowth => 'Crescimento de Longo Prazo';

  @override
  String get crChipTechnical => 'Habilidade Técnica';

  @override
  String get crChipRecognition => 'Reconhecimento';

  @override
  String get crTopInsights => 'Principais Insights';

  @override
  String get crWhatDefines => 'O que define sua carreira?';

  @override
  String get crSoulCareer => 'Alma e Propósito Profissional';

  @override
  String get crSoulPlanet => 'Planeta do Propósito da Alma';

  @override
  String get crCareerPlanet => 'Planeta da Carreira';

  @override
  String get crMeaning => 'Significado';

  @override
  String get crAlignment => 'Alinhamento Alma ↔ Carreira';

  @override
  String get crAlignStrong =>
      'Seus interesses naturais e seu caminho profissional estão fortemente alinhados.';

  @override
  String get crAlignModerate =>
      'Seus interesses naturais e seu caminho profissional estão moderadamente alinhados.';

  @override
  String get crAlignLow =>
      'Seus interesses naturais e seu caminho profissional precisam de alinhamento consciente.';

  @override
  String get crTechAtmakaraka => 'Atmakaraka (indicador da alma)';

  @override
  String get crTechAmatyakaraka => 'Amatyakaraka (indicador de carreira)';

  @override
  String get crDegrees => 'Graus';

  @override
  String get crDignity => 'Dignidade';

  @override
  String get crFoundation => 'Fundação da Carreira';

  @override
  String get crCareerSign => 'Signo da Carreira';

  @override
  String get crCareerLord => 'Senhor da Carreira';

  @override
  String get crLordPosition => 'Posição do Senhor';

  @override
  String get crCareerStrength => 'Força da Carreira';

  @override
  String get crProfStyle => 'Estilo Profissional';

  @override
  String get crBestFields => 'Melhores Áreas';

  @override
  String get crTechnicalDetails => 'Detalhes Técnicos';

  @override
  String get crHouseLabel => 'Casa';

  @override
  String get crVerification => 'Verificação de Carreira entre Mapas';

  @override
  String get crD10Career => 'D10 · Carreira';

  @override
  String get crD9Purpose => 'D9 · Propósito';

  @override
  String get crD60Karma => 'D60 · Carma';

  @override
  String get crStatusNeedsImprovement => 'Precisa Melhorar';

  @override
  String get crStatusWellAligned => 'Bem Alinhado';

  @override
  String get crStatusStrongSupport => 'Forte Apoio';

  @override
  String get crStatusModerateSupport => 'Apoio Moderado';

  @override
  String get crChartDetails => 'Detalhes técnicos do mapa';

  @override
  String get crPersonality => 'Sua Personalidade Profissional';

  @override
  String get crGrowthAreas => 'Áreas de Crescimento';

  @override
  String get crBestRoles => 'Melhores Funções';

  @override
  String get crBestIndustries => 'Melhores Setores';

  @override
  String get crEnvironment => 'Ambiente de Trabalho';

  @override
  String get crWorkStyle => 'Melhor Estilo de Trabalho';

  @override
  String get crEmployment => 'Emprego';

  @override
  String get crBusiness => 'Negócio Próprio';

  @override
  String get crFreelance => 'Freelancer / Consultoria';

  @override
  String get crPortfolio => 'Portfólio Misto';

  @override
  String get crLeadership => 'Liderança';

  @override
  String get crFit => 'Compatibilidade';

  @override
  String get crBestFit => 'Melhor Compatibilidade';

  @override
  String get crTimeline => 'Linha do Tempo da Carreira';

  @override
  String get crPastPeak => 'Pico Anterior';

  @override
  String get crPresentPhase => 'Fase Atual';

  @override
  String get crUpcoming => 'Próxima Oportunidade';

  @override
  String get crFutureExpansion => 'Expansão Futura';

  @override
  String get crRiskPeriod => 'Período de Risco';

  @override
  String get crViewDasha => 'Período planetário (técnico)';

  @override
  String get crChallenges => 'Desafios a Observar';

  @override
  String get crRiskBurnout => 'Esgotamento';

  @override
  String get crRiskRecognition => 'Atraso no Reconhecimento';

  @override
  String get crRiskConflict => 'Conflito no Trabalho';

  @override
  String get crRiskFinancial => 'Instabilidade Financeira';

  @override
  String get crRiskOverqual => 'Subutilização';

  @override
  String get crPrevention => 'Prevenção';

  @override
  String get crBurnoutExp =>
      'Fases longas e exigentes podem drenar sua energia com o tempo.';

  @override
  String get crBurnoutFix =>
      'Proteja o descanso, estabeleça limites e ritme os grandes esforços.';

  @override
  String get crRecognitionExp =>
      'Recompensas e reconhecimento podem chegar mais devagar do que seu esforço.';

  @override
  String get crRecognitionFix =>
      'Documente suas conquistas e torne suas contribuições visíveis para os superiores.';

  @override
  String get crConflictExp =>
      'Atritos com colegas ou superiores podem surgir em alguns momentos.';

  @override
  String get crConflictFix =>
      'Comunique-se com calma e escolha bem suas batalhas.';

  @override
  String get crFinancialExp =>
      'A renda pode parecer irregular em determinadas fases.';

  @override
  String get crFinancialFix =>
      'Mantenha uma reserva e evite se comprometer financeiramente em excesso.';

  @override
  String get crOverqualExp =>
      'Às vezes você pode se sentir subutilizado ou pouco desafiado.';

  @override
  String get crOverqualFix =>
      'Busque funções desafiadoras e continue aprendendo para se manter engajado.';

  @override
  String get crImprovementPlan => 'Plano de Melhoria de Carreira';

  @override
  String get crCatPlanetary => 'Planetário e Espiritual';

  @override
  String get crCatPractical => 'Passos Práticos';

  @override
  String get crTraditionalExplain => 'Explicação astrológica tradicional';

  @override
  String get crActionPlan => 'Plano de Ação de Carreira de 30 Dias';

  @override
  String get crWeek1 => 'Semana 1 · Otimização do Perfil';

  @override
  String get crWeek2 => 'Semana 2 · Desenvolvimento de Habilidades';

  @override
  String get crWeek3 => 'Semana 3 · Networking';

  @override
  String get crWeek4 => 'Semana 4 · Visibilidade Profissional';

  @override
  String get crWeek1Tip =>
      'Atualize seu currículo e LinkedIn em torno do seu tema profissional mais forte.';

  @override
  String get crWeek2Tip =>
      'Escolha uma habilidade de alto valor na sua melhor área e pratique-a diariamente.';

  @override
  String get crWeek3Tip =>
      'Reconecte-se com mentores e entre em contato com dois novos contatos do setor.';

  @override
  String get crWeek4Tip =>
      'Compartilhe seu trabalho publicamente e se voluntarie para um projeto visível.';

  @override
  String get crPriority => 'Prioridade';

  @override
  String get crTimeRequired => 'Tempo';

  @override
  String get crExpectedBenefit => 'Benefício';

  @override
  String get crPriorityHigh => 'Alta';

  @override
  String get crPriorityMedium => 'Média';

  @override
  String get crRoadmap => 'Roteiro de Carreira com IA';

  @override
  String get crNext12 => 'Próximos 12 Meses';

  @override
  String get crBestFocus => 'Melhor Foco';

  @override
  String get crSkillsLearn => 'Habilidades a Aprender';

  @override
  String get crIndustriesTarget => 'Setores a Almejar';

  @override
  String get crExpectedOutcome => 'Resultado Esperado';

  @override
  String get crReliability => 'Confiabilidade da Previsão';

  @override
  String get crReliabilityHigh => 'Alta Confiabilidade';

  @override
  String get crReliabilityGood => 'Boa Confiabilidade';

  @override
  String get crReliabilityModerate => 'Confiabilidade Moderada';

  @override
  String get crReliabilityExplain =>
      'Este relatório combina seu mapa natal, mapas divisionais e indicadores Jaimini. A pontuação reflete o quanto essas camadas do mapa concordam entre si.';

  @override
  String get crChartLayers => 'Camadas do mapa e pesos';

  @override
  String get crBirthChart => 'Mapa Natal (D1)';

  @override
  String get crNavamsa => 'Navamsa (D9)';

  @override
  String get crDashamsa => 'Dashamsa (D10)';

  @override
  String get crShashtiamsa => 'Shashtiamsa (D60)';

  @override
  String get crDiscussAi => 'Discutir com a IA';

  @override
  String get crAskAbout => 'Perguntar Sobre';

  @override
  String get crTopicChange => 'Mudança de Carreira';

  @override
  String get crTopicGovt => 'Emprego Público';

  @override
  String get crTopicBusiness => 'Negócios';

  @override
  String get crTopicPromotion => 'Promoção';

  @override
  String get crTopicMarriage => 'Casamento vs Carreira';

  @override
  String get crTopicAbroad => 'Exterior';

  @override
  String get crTopicIncome => 'Renda';

  @override
  String get crTopicPurpose => 'Propósito';

  @override
  String get crTopicResume => 'Currículo';

  @override
  String get crTopicCopied => 'Pergunta copiada — cole no seu chat com a IA.';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return '$soul guia seu chamado interior, enquanto $career molda sua profissão exterior.';
  }

  @override
  String get rzTodayOutlook => 'Panorama Zodiacal de Hoje';

  @override
  String get rzPlanetaryEnergy => 'Energia Planetária de Hoje';

  @override
  String get rzBestSign => 'Melhor Signo';

  @override
  String get rzChallengingSign => 'Mais Desafiador';

  @override
  String get rzDominantPlanet => 'Planeta Dominante';

  @override
  String get rzOverallMood => 'Clima Geral';

  @override
  String get rzMoodBright => 'Brilhante e Ativo';

  @override
  String get rzMoodCalm => 'Calmo e Estável';

  @override
  String get rzMoodMixed => 'Energia Mista';

  @override
  String get rzMoodTense => 'Tenso e Cauteloso';

  @override
  String get rzTodayEnergy => 'Energia de Hoje';

  @override
  String get rzCaution => 'Cautela';

  @override
  String get rzWeak => 'Fraco';

  @override
  String get rzAllSigns => 'Todos os Signos do Zodíaco';

  @override
  String get rzAiSummary => 'Resumo da IA';

  @override
  String get rzPlanetaryInfluence => 'Influência Planetária de Hoje';

  @override
  String get rzStrongInfluences => 'Influências Fortes';

  @override
  String get rzShowTechnical => 'Mostrar detalhes técnicos';

  @override
  String get rzOpportunities => 'Oportunidades de Hoje';

  @override
  String get rzAvoidTitle => 'Coisas a Evitar Hoje';

  @override
  String get rzTechnicalReason => 'Motivo técnico';

  @override
  String get rzAvoidDecisions => 'Apressar decisões importantes';

  @override
  String get rzAvoidArguments => 'Discussões acaloradas';

  @override
  String get rzAvoidInvestments => 'Grandes investimentos';

  @override
  String get rzAvoidOverthink => 'Pensar demais em pequenos problemas';

  @override
  String get rzAvoidOverspend => 'Gastos desnecessários';

  @override
  String get rzAvoidStress => 'Estresse e excesso de trabalho';

  @override
  String get rzPlanetaryChart => 'Mapa Planetário de Hoje';

  @override
  String get rzWhatChartMeans => 'O que este mapa significa';

  @override
  String get rzChartExplain =>
      'Este diamante mostra onde cada planeta está posicionado no céu hoje, mapeado para o seu signo. Planetas em casas favoráveis animam o dia; os que estão em casas difíceis pedem cuidado.';

  @override
  String get rzDoNetworking => 'Networking e conexões';

  @override
  String get rzDoLearning => 'Aprender algo novo';

  @override
  String get rzDoMeditation => 'Meditação e calma';

  @override
  String get rzDoFamily => 'Tempo em família';

  @override
  String get rzDoCreative => 'Trabalho criativo';

  @override
  String get rzDoRest => 'Descanso e autocuidado';

  @override
  String get rzAiRecommendations => 'Recomendações da IA para Hoje';

  @override
  String get rzTechnical => 'Astrologia Técnica';

  @override
  String get rzTransitScore => 'Pontuação de Trânsito';

  @override
  String get rzVedha => 'Vedha (Obstruções)';

  @override
  String get rzGocharDetails => 'Detalhes do Gochar';

  @override
  String get rzAdvancedOnly => 'Para usuários avançados';

  @override
  String get rzTomorrow => 'Prévia de Amanhã';

  @override
  String get rzTomorrowEnergy => 'Energia de Amanhã';

  @override
  String get rzImproving => 'Melhorando';

  @override
  String get rzWeaker => 'Ligeiramente Mais Fraca';

  @override
  String get rzSteady => 'Estável';

  @override
  String get rzTomorrowUpLine =>
      'Espera-se que a energia aumente amanhã — planeje com antecedência as tarefas importantes.';

  @override
  String get rzTomorrowDownLine =>
      'A energia pode cair um pouco amanhã — mantenha o dia leve e estável.';

  @override
  String get rzTomorrowFlatLine =>
      'A energia permanece estável amanhã — um dia calmo e equilibrado pela frente.';

  @override
  String get rzWeeklyTrend => 'Tendência Semanal';

  @override
  String get rzMonthlyTrend => 'Tendência Mensal';

  @override
  String get rzBestDayWeek => 'Melhor Dia';

  @override
  String get rzHardestDay => 'Dia Mais Difícil';

  @override
  String get rzLuckyToday => 'Sorte Hoje';

  @override
  String get rzKarakaSun => 'confiança e vitalidade';

  @override
  String get rzKarakaMoon => 'emoções e paz de espírito';

  @override
  String get rzKarakaMars => 'energia e ímpeto';

  @override
  String get rzKarakaMercury => 'comunicação e aprendizado';

  @override
  String get rzKarakaJupiter => 'sabedoria e crescimento';

  @override
  String get rzKarakaVenus => 'relacionamentos e conforto';

  @override
  String get rzKarakaSaturn => 'disciplina e paciência';

  @override
  String get rzKarakaRahu => 'ambição e mudança';

  @override
  String get rzKarakaKetu => 'espiritualidade e desapego';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '$dom define o tom do dia, enquanto $chal pede paciência e cuidado.';
  }

  @override
  String rzInsightGood(Object karaka) {
    return 'Bom dia para $karaka.';
  }

  @override
  String rzInsightHard(Object karaka) {
    return 'Vá com calma com $karaka hoje.';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return '$karaka está bem apoiado hoje.';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return '$karaka pode enfrentar atrasos hoje.';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return 'Hoje favorece $strong, enquanto $weak precisa de paciência e cuidado.';
  }

  @override
  String get fdEnergyScore => 'Pontuação de Energia de Hoje';

  @override
  String get fdStatusAverage => 'Média';

  @override
  String get fdStatusMixed => 'Mista';

  @override
  String get fdStatusChallenging => 'Desafiadora';

  @override
  String get fdTheme => 'Tema de Hoje';

  @override
  String get fdExplainToday => 'Explicar Hoje';

  @override
  String get fdTodaysFocus => 'Foco de Hoje';

  @override
  String get fdTopRecommendation => 'Principal Recomendação';

  @override
  String get fdTopCaution => 'Principal Cuidado';

  @override
  String get fdReadingTime => 'Tempo de leitura';

  @override
  String get fdSeconds30 => '30 seg';

  @override
  String get fdCareer => 'Carreira';

  @override
  String get fdMoney => 'Dinheiro';

  @override
  String get fdLove => 'Amor';

  @override
  String get fdHealth => 'Saúde';

  @override
  String get fdTravel => 'Viagem';

  @override
  String get fdFamily => 'Família';

  @override
  String get fdBestToDo => 'Melhores Coisas a Fazer Hoje';

  @override
  String get fdAvoidToday => 'Evitar Hoje';

  @override
  String get fdConfidenceLabel => 'Confiança';

  @override
  String get fdBestTime => 'Melhor Horário';

  @override
  String get fdRecommended => 'Recomendado';

  @override
  String get fdReason => 'Motivo';

  @override
  String get fdRisk => 'Risco';

  @override
  String get fdRecommendation => 'Recomendação';

  @override
  String get fdNoActions =>
      'Nada de grande impacto para hoje — mantenha uma rotina calma e estável.';

  @override
  String get fdNoCautions =>
      'Nenhuma precaução importante hoje — siga com a atenção normal.';

  @override
  String get fdHighlights => 'Destaques de Hoje';

  @override
  String get fdProbVeryHigh => 'Muito Alta';

  @override
  String get fdProbHigh => 'Alta';

  @override
  String get fdProbElevated => 'Elevada';

  @override
  String get fdProbCaution => 'Cautela';

  @override
  String get fdWhatToDo => 'O que fazer';

  @override
  String get fdLifeAreas => 'Áreas da Vida';

  @override
  String get fdTapDetails => 'Toque para detalhes';

  @override
  String get fdArea1 => 'Eu e Saúde';

  @override
  String get fdArea2 => 'Riqueza e Família';

  @override
  String get fdArea3 => 'Comunicação';

  @override
  String get fdArea4 => 'Lar e Conforto';

  @override
  String get fdArea5 => 'Criatividade e Romance';

  @override
  String get fdArea6 => 'Trabalho e Deveres';

  @override
  String get fdArea7 => 'Relacionamentos';

  @override
  String get fdArea8 => 'Mudança e Profundidade';

  @override
  String get fdArea9 => 'Sorte e Viagens';

  @override
  String get fdArea10 => 'Carreira e Status';

  @override
  String get fdArea11 => 'Ganhos e Rede de Contatos';

  @override
  String get fdArea12 => 'Descanso e Espiritualidade';

  @override
  String get fdTodaysMeaning => 'Significado de Hoje';

  @override
  String get fdGoodFor => 'Bom Para';

  @override
  String get fdAvoid => 'Evitar';

  @override
  String get fdPlanetSupport => 'Apoio Planetário';

  @override
  String get fdWhyPrediction => 'Por que essa previsão?';

  @override
  String get fdAdvancedDetails => 'Detalhes Avançados';

  @override
  String get fdAiRecommendation => 'Recomendação da IA';

  @override
  String get fdOverallStatus => 'Status Geral';

  @override
  String get fdNoPlanetTransit =>
      'Nenhum planeta importante está transitando por esta área hoje.';

  @override
  String get fdFinancialOutlook => 'Panorama Financeiro';

  @override
  String get fdIncomeProbability => 'Probabilidade de Receita';

  @override
  String get fdExpenseProbability => 'Probabilidade de Despesa';

  @override
  String get fdNetBalance => 'Saldo Financeiro Líquido';

  @override
  String get fdAvoidSpending => 'Evitar Gastos';

  @override
  String get fdRelationshipOutlook => 'Panorama de Relacionamento';

  @override
  String get fdOverallScore => 'Pontuação Geral';

  @override
  String get fdPartner => 'Parceiro(a)';

  @override
  String get fdRomance => 'Romance';

  @override
  String get fdWorkplace => 'Ambiente de Trabalho';

  @override
  String get fdPublicImage => 'Imagem Pública';

  @override
  String get fdBestActivity => 'Melhor Atividade';

  @override
  String get fdWeakArea => 'Área Fraca';

  @override
  String get fdBiggestOpportunity => 'Maior Oportunidade';

  @override
  String get fdBiggestRisk => 'Maior Risco';

  @override
  String get fdProbability => 'Probabilidade';

  @override
  String get fdProtection => 'Conselho de Proteção';

  @override
  String get fdDescription => 'Descrição';

  @override
  String get fdBestTimeToday => 'Melhor Horário Hoje';

  @override
  String get fdAvoidDuring => 'Evitar Durante';

  @override
  String get fdPredictionConfidence => 'Confiança da Previsão';

  @override
  String get fdConfBasis => 'A previsão de hoje combina';

  @override
  String get fdConfNatal => 'Mapa Natal';

  @override
  String get fdConfTransit => 'Trânsito Atual';

  @override
  String get fdConfDasha => 'Períodos Planetários';

  @override
  String get fdConfStrength => 'Força Planetária';

  @override
  String get fdConfHouse => 'Ativação de Casa';

  @override
  String get fdAskAi => 'Perguntar à IA';

  @override
  String get fdAskAiSub =>
      'Toque em uma pergunta para obter a resposta de hoje';

  @override
  String get fdQ1 => 'Por que a carreira está lenta hoje?';

  @override
  String get fdQ2 => 'Qual é o melhor horário hoje?';

  @override
  String get fdQ3 => 'Hoje é bom para questões financeiras?';

  @override
  String get fdQ4 => 'Hoje é bom para viagens?';

  @override
  String get fdQ5 => 'O que devo evitar hoje?';

  @override
  String get fdMoreSuggestions => 'Mais Sugestões';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return 'Hoje é mais indicado para $top. $weak pode parecer lento, então evite decisões importantes nessa área. Financeiramente, o dia parece $fin.';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return 'Sua energia hoje se concentra em $top — invista nisso e vá com calma no restante.';
  }

  @override
  String get gochToday => 'Hoje';

  @override
  String get gochOverallScore => 'Pontuação Geral de Trânsito';

  @override
  String get gochNeutral => 'Neutro';

  @override
  String get gochChallenging => 'Desafiador';

  @override
  String get gochTopPositive => 'Principais Pontos Positivos';

  @override
  String get gochTopChallenges => 'Principais Desafios';

  @override
  String get gochFilterAll => 'Todos';

  @override
  String get gochFavorability => 'Favorabilidade';

  @override
  String get gochAlerts => 'Alertas de Trânsito';

  @override
  String get gochAlertCritical => 'Crítico';

  @override
  String get gochAlertWarning => 'Cautela';

  @override
  String get gochAlertOpportunity => 'Oportunidade';

  @override
  String get gochAiFocus => 'Foco da IA para Hoje';

  @override
  String get gochLifeScores => 'Pontuações por Área da Vida';

  @override
  String get gochWhy => 'Por quê?';

  @override
  String get gochCurrentTransits => 'Trânsitos Ativos';

  @override
  String get gochDailyPlan => 'Seu Plano Diário';

  @override
  String get gochMorning => 'Manhã';

  @override
  String get gochAfternoon => 'Tarde';

  @override
  String get gochEvening => 'Fim de Tarde';

  @override
  String get gochNight => 'Noite';

  @override
  String get gochSmartReco => 'Recomendações Inteligentes';

  @override
  String get gochExplain => 'Explicar o Trânsito de Hoje';

  @override
  String get gochDo => 'Faça';

  @override
  String get gochDont => 'Evite';

  @override
  String get gochDoWork => 'Cuide de trabalhos importantes';

  @override
  String get gochDoMeditate => 'Medite e reflita';

  @override
  String get gochDoStart => 'Inicie novos planos';

  @override
  String get gochDoFinish => 'Termine tarefas pendentes';

  @override
  String get gochDontArgue => 'Evite discussões';

  @override
  String get gochDontImpulsive => 'Evite decisões impulsivas';

  @override
  String get gochDontOverspend => 'Evite gastos excessivos';

  @override
  String gochThemeGrowth(Object area) {
    return 'Um dia de crescimento em $area — invista nisso.';
  }

  @override
  String gochThemeChallenge(Object area) {
    return 'Tenha paciência com $area hoje — vá com calma.';
  }

  @override
  String gochPosLine(Object area) {
    return '$area está bem apoiada neste momento.';
  }

  @override
  String gochChalLine(Object area) {
    return '$area precisa de cuidado extra hoje.';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return 'Coloque sua energia em $a1 hoje e seja gentil com $a2.';
  }

  @override
  String get divBeginner => 'Iniciante';

  @override
  String get divSearchHint => 'Buscar: carreira, casamento, educação…';

  @override
  String get divSummaryTitle => 'Resumo dos Mapas Divisionais';

  @override
  String get divTotalCharts => 'Total de Mapas';

  @override
  String get divMostImportant => 'Mais Importante';

  @override
  String get divRecommendedForYou => 'Recomendado Para Você';

  @override
  String get divCatEssential => 'Mapas Essenciais';

  @override
  String get divCatPersonal => 'Vida Pessoal';

  @override
  String get divCatKnowledge => 'Mapas de Conhecimento';

  @override
  String get divCatAdvanced => 'Mapas Avançados';

  @override
  String get divGoalProperty => 'Propriedade';

  @override
  String get divGoalKarma => 'Carma';

  @override
  String get divBadgeHighlyRec => 'Altamente Recomendado';

  @override
  String get divBadgeRec => 'Recomendado';

  @override
  String get divBadgeUseful => 'Útil';

  @override
  String get divBadgeOptional => 'Opcional';

  @override
  String get divBadgeAdvOnly => 'Somente Avançado';

  @override
  String get divRecommendBest => 'Recomendar Melhores Mapas';

  @override
  String get divNoMatch => 'Nenhum mapa corresponde à sua busca';

  @override
  String get divLifeAreas => 'Áreas da Vida';

  @override
  String divAiUse(Object purpose) {
    return 'Use este mapa para analisar $purpose.';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return 'Seus mapas $c1 e $c2 são especialmente importantes — comece por eles para as áreas que cobrem, depois explore os demais conforme necessário.';
  }

  @override
  String divRecReasonHouse(Object house) {
    return 'Sua Casa $house precisa de um olhar mais atento — este mapa a mostra em profundidade.';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '$planet é um planeta-chave, mas testado — este mapa revela sua condição mais profunda.';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return 'Você está na Mahadasha de $planet, então este mapa é especialmente oportuno agora.';
  }

  @override
  String divRecSummary(Object c1) {
    return 'Com base no seu mapa, $c1 deve ser sua maior prioridade. Os mapas abaixo estão ordenados por relevância para você neste momento.';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return 'Abra este mapa quando quiser estudar $purpose.';
  }

  @override
  String get yogaHelpful => 'Útil';

  @override
  String get yogaInactive => 'Inativo';

  @override
  String get yogaTabMoney => 'Dinheiro';

  @override
  String get yogaTabRare => 'Raro';

  @override
  String get yogaSummaryTitle => 'Resumo de Yogas';

  @override
  String get yogaActiveYogas => 'Yogas Ativos';

  @override
  String get yogaTotalYogas => 'Total de Yogas';

  @override
  String get yogaMostPowerful => 'Mais Poderoso';

  @override
  String get yogaFortuneRating => 'Fortuna Geral';

  @override
  String get yogaBenefits => 'Benefícios';

  @override
  String get yogaSupportingPlanets => 'Planetas de Apoio';

  @override
  String get yogaRanking => 'Top 5 Yogas Mais Fortes';

  @override
  String get yogaExplain => 'Explicar Meus Yogas';

  @override
  String get yogaExplainSubtitle => 'Como seus yogas te apoiam';

  @override
  String get yogaNoneActive => 'Nenhum yoga ativo ainda';

  @override
  String get yogaNoneInCategory => 'Nenhum yoga nesta categoria';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return 'Seu mapa carrega $count yogas ativos — combinações planetárias favoráveis. Combinações envolvendo $planets criam influências especialmente úteis para crescimento e sucesso.';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '$name apoia $areas, e seus benefícios crescem quando seus planetas estão ativos em dasha ou trânsito.';
  }

  @override
  String get yogaAiGeneric =>
      'Este yoga é uma combinação favorável no seu mapa que fortalece suas áreas relacionadas da vida.';

  @override
  String get yogaExplainReassure =>
      'Yogas são os pontos brilhantes do seu mapa — combinações planetárias úteis trabalhando a seu favor. Os mais fortes trazem benefícios duradouros, especialmente durante os períodos dos planetas que os formam.';

  @override
  String get doshSevere => 'Severo';

  @override
  String get doshVeryMild => 'Muito Leve';

  @override
  String get doshLow => 'Baixo';

  @override
  String get doshHigh => 'Alto';

  @override
  String get doshCritical => 'Crítico';

  @override
  String get doshSummaryTitle => 'Resumo de Doshas';

  @override
  String get doshActiveDoshas => 'Doshas Ativos';

  @override
  String get doshTotalChecked => 'Total Verificado';

  @override
  String get doshOverallSeverity => 'Severidade Geral';

  @override
  String get doshNoneActive => 'Nenhum dosha ativo — um mapa limpo!';

  @override
  String get doshCategory => 'Categoria';

  @override
  String get doshConfidence => 'Confiança';

  @override
  String get doshWhyFormed => 'Por Que Isso Se Formou';

  @override
  String get doshAffectedAreas => 'Áreas Afetadas';

  @override
  String get doshTimeline => 'Linha do Tempo';

  @override
  String get doshDefinition => 'Definição';

  @override
  String get doshFormationRule => 'Regra de Formação';

  @override
  String get doshSupportingPlanets => 'Planeta Relacionado';

  @override
  String get doshCancellation => 'Yogas de Cancelamento';

  @override
  String get doshNoCancellation => 'Nenhum encontrado';

  @override
  String get doshAreaChildren => 'Filhos';

  @override
  String get doshAreaMind => 'Mente';

  @override
  String get remMantra => 'Mantra';

  @override
  String get remGemstone => 'Pedra Preciosa';

  @override
  String get remDonation => 'Doação';

  @override
  String get remTemple => 'Templo';

  @override
  String get remFasting => 'Jejum';

  @override
  String get remLifestyle => 'Estilo de Vida';

  @override
  String get remLifestyleGeneric =>
      'Pratique gratidão, disciplina e caridade conectadas a este planeta, e mantenha boa conduta.';

  @override
  String get doshExplain => 'Explicar Meus Doshas';

  @override
  String get doshExplainSubtitle =>
      'Um olhar calmo e prático sobre seus doshas';

  @override
  String get doshExplainReassure =>
      'Doshas são comuns — quase todo mapa tem algum. Eles descrevem tendências, não um destino fixo. Consciência, boa conduta e remédios simples reduzem seu efeito prático, então não há motivo para preocupação.';

  @override
  String get doshAiGeneric =>
      'Este dosha descreve uma tendência no seu mapa. Seu efeito prático costuma ser leve e pode ser equilibrado com consciência e remédios simples.';

  @override
  String doshHeroSummary(Object active, Object total) {
    return 'Seu mapa mostra $active doshas ativos de um total de $total verificados. A maioria é leve e apenas alguns precisam de atenção. Com compreensão e remédios simples, seu efeito prático pode ser suavizado.';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return 'Este dosha influencia principalmente $areas. Durante os períodos de $planet, seu efeito pode se intensificar, e remédios ajudam a equilibrá-lo.';
  }

  @override
  String doshTimelineLine(Object planet) {
    return 'Seu efeito é sentido mais fortemente durante a Mahadasha e a Antardasha de $planet, e quando $planet está ativo em trânsito.';
  }

  @override
  String get sbLegendary => 'Lendário';

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
  String get sbSummary => 'Resumo da Força Planetária';

  @override
  String get sbAverageStrength => 'Força Média';

  @override
  String get sbHighestRupa => 'Rupa Mais Alto';

  @override
  String get sbRupa => 'Rupa';

  @override
  String get sbRanking => 'Classificação dos Planetas';

  @override
  String get sbRequired => 'Necessário';

  @override
  String get sbExcess => 'Excesso';

  @override
  String get sbDeficit => 'Déficit';

  @override
  String get sbTotalShadbala => 'Shadbala Total';

  @override
  String get sbExplain => 'Explicar Minha Força Planetária';

  @override
  String get sbExplainSubtitle =>
      'Um resumo simples da força dos seus planetas';

  @override
  String get sbInfoTitle => 'Entendendo o Shadbala';

  @override
  String get sbQWhatIs => 'O que é Shadbala?';

  @override
  String get sbQRupas => 'O que são Rupas?';

  @override
  String get sbQHowCalc => 'Como a força é calculada?';

  @override
  String get sbQHowUse => 'Como usar isso';

  @override
  String get sbWhyStrong => 'Por Que é Forte';

  @override
  String get sbWhyWeak => 'Por Que é Fraco';

  @override
  String get sbDuringMahadasha => 'Durante a Mahadasha';

  @override
  String get sbEffects => 'Efeitos';

  @override
  String get sbLifeAreas => 'Áreas da Vida';

  @override
  String get sbPlanetDetails => 'Detalhes do Planeta';

  @override
  String get sbBodyWhatIs =>
      'Shadbala (\'força sêxtupla\') mede quanto poder cada planeta tem para entregar seus resultados, somando seis fontes independentes de força.';

  @override
  String get sbBodyRupas =>
      'A força é medida em Rupas (1 Rupa = 60 Virupas). Cada planeta precisa de uma força mínima em Rupas para ser considerado forte; mais Rupas significa que ele entrega seus resultados de forma mais plena.';

  @override
  String get sbBodyHowCalc =>
      'Seis balas são somados: Sthana (posicional), Dig (direcional), Kala (temporal), Chesta (de movimento), Naisargika (natural) e Drik (aspectual). O total é comparado com o mínimo exigido pelo planeta para obter uma porcentagem.';

  @override
  String get sbBodyHowUse =>
      'Um planeta acima de 100% entrega suas significações com folga; abaixo de 100% ele precisa de apoio. Favoreça seus planetas mais fortes para assuntos importantes, e dê aos mais fracos remédios e paciência.';

  @override
  String get sbRemedyStrong =>
      'Bem apoiado — nenhum remédio especial é necessário; você pode usar os períodos deste planeta com confiança.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '$strongP é seu planeta mais forte, oferecendo excelente apoio para $strongTrait. $weakP é o mais fraco e se beneficia mais de remédios.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '$planet tem Shadbala $category, então suas $karakatva são apoiadas de acordo.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return 'Mais forte através de $bala ($rupa rupas).';
  }

  @override
  String sbWeakLine(Object bala) {
    return 'Mais fraco em $bala, o que reduz o total.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return 'Durante a Mahadasha de $planet, suas $karak vêm à tona.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'Com Shadbala forte, $karak são naturalmente apoiadas.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'Com Shadbala modesto, $karak podem precisar de esforço consciente.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return 'Fortaleça $planet através de seu mantra, pedra preciosa ou caridade, e aja com paciência durante seus períodos.';
  }

  @override
  String get bhOverview => 'Visão Geral';

  @override
  String get bhDetailed => 'Detalhado';

  @override
  String get bhavaHouses => 'Casas';

  @override
  String get bhStrengthOverview => 'Visão Geral da Força das Casas';

  @override
  String get bhOverallAverage => 'Média Geral das Casas';

  @override
  String get bhStrongestHouse => 'Casa Mais Forte';

  @override
  String get bhWeakestHouse => 'Casa Mais Fraca';

  @override
  String get bhBestArea => 'Melhor Área da Vida';

  @override
  String get bhNeedsAttention => 'Precisa de Atenção';

  @override
  String get bhSavContribution => 'Contribuição SAV';

  @override
  String get bhLordCondition => 'Condição do Senhor da Casa';

  @override
  String get bhBenefic => 'Influência Benéfica';

  @override
  String get bhMalefic => 'Influência Maléfica';

  @override
  String get bhStrengthReasons => 'Por Que Essa Pontuação';

  @override
  String get bhGoodEffects => 'Efeitos Positivos';

  @override
  String get bhChallenges => 'Desafios';

  @override
  String get bhRemedies => 'Remédios';

  @override
  String get bhRanking => 'Classificação das Casas';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'Explicar Minhas Casas';

  @override
  String get bhExplainSubtitle => 'Um resumo simples das suas 12 casas';

  @override
  String bhHeroSummary(
    Object s1,
    Object s2,
    Object strongArea,
    Object weakArea,
  ) {
    return 'Suas casas mais fortes são $s1 e $s2. $strongArea é naturalmente forte, enquanto $weakArea precisa de mais esforço.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'Seu senhor $lord está posicionado como $relation.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'Esta casa carrega $sav pontos benéficos (SAV); seus ocupantes e aspectos moldam o restante da pontuação.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'Quando forte, ela apoia $meaning.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'Quando fraca, $meaning pode precisar de esforço e cuidado extras.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'Fortaleça seu senhor $lord e honre os assuntos desta casa para elevá-la.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'Sua $house é $strengthWord. Ela governa $meaning.';
  }

  @override
  String get kunNavamsa => 'Navamsa (D9)';

  @override
  String get kunD10 => 'Dasamsa (D10)';

  @override
  String get kunPlacement => 'Posicionamento Planetário';

  @override
  String get kunHousesTitle => 'Detalhes das Casas';

  @override
  String get kunPlanet => 'Planeta';

  @override
  String get kunNakshatra => 'Nakshatra';

  @override
  String get kunPada => 'Pada';

  @override
  String get kunLord => 'Senhor';

  @override
  String get kunExplain => 'Explicar Meu Mapa';

  @override
  String get kunExplainSubtitle => 'Um resumo simples do seu mapa';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return 'A $ordinal casa governa $meaning.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return '$planets posicionado(s) aqui moldam seus resultados.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'Seu ascendente é $asc, moldando sua perspectiva e como os outros o veem à primeira vista.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'Sua mente e emoções seguem a Lua em $moon.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '$planet é seu planeta mais forte — uma área natural de facilidade e apoio.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '$planet é seu planeta mais testado — paciência e esforço compensam aqui.';
  }

  @override
  String get plNature => 'Natureza';

  @override
  String get plElement => 'Elemento';

  @override
  String get plGender => 'Gênero';

  @override
  String get plKarakatva => 'Karakatva';

  @override
  String get plLordship => 'Regência';

  @override
  String get plStrength => 'Força';

  @override
  String get plAspectsGiven => 'Aspectos Enviados';

  @override
  String get plAspectsReceived => 'Aspectos Recebidos';

  @override
  String get plConjunction => 'Conjunção';

  @override
  String get plHouseMeaning => 'Significado da Casa';

  @override
  String get plNakshatraMeaning => 'Significado do Nakshatra';

  @override
  String get plAiInterpretation => 'Interpretação da IA';

  @override
  String get plSearchHint => 'Buscar qualquer planeta';

  @override
  String get plNoResults => 'Nenhum planeta encontrado';

  @override
  String get plBenefic => 'Benéfico';

  @override
  String get plMalefic => 'Maléfico';

  @override
  String get plMale => 'Masculino';

  @override
  String get plFemale => 'Feminino';

  @override
  String get plNeutralGender => 'Neutro';

  @override
  String get plOwnSign => 'Signo Próprio';

  @override
  String get plFriend => 'Signo Amigo';

  @override
  String get plEnemy => 'Signo Inimigo';

  @override
  String get plNeutral => 'Neutro';

  @override
  String get sumEther => 'Éter';

  @override
  String plLordOfHouses(Object houses) {
    return 'Senhor da(s) casa(s) $houses';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return 'Regido por $nakLord, trazendo $trait.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '$planet está em $sign, na Casa $house.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'Suas significações principais — $karak — são bem apoiadas aqui.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'Suas significações principais — $karak — podem precisar de esforço consciente aqui.';
  }

  @override
  String plAiExalted(Object planet) {
    return '$planet está exaltado, entregando seus melhores resultados.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '$planet está debilitado e precisa de apoio para entregar seus resultados.';
  }

  @override
  String plAiCombust(Object planet) {
    return '$planet está combusto, então atua de forma menos aberta sob o brilho do Sol.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '$planet é vargottama — um posicionamento forte repetido no navamsa.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '$planet está retrógrado, voltando sua energia para dentro e intensificando-a.';
  }

  @override
  String get plHouse1 => 'eu, corpo, personalidade e vitalidade';

  @override
  String get plHouse2 => 'riqueza, família, fala e alimentação';

  @override
  String get plHouse3 => 'coragem, irmãos, comunicação e viagens curtas';

  @override
  String get plHouse4 => 'lar, mãe, conforto, propriedade e paz interior';

  @override
  String get plHouse5 =>
      'filhos, criatividade, inteligência, romance e méritos passados';

  @override
  String get plHouse6 => 'saúde, inimigos, dívidas, serviço e trabalho diário';

  @override
  String get plHouse7 => 'casamento, parcerias e relações comerciais';

  @override
  String get plHouse8 => 'longevidade, transformação, segredos e herança';

  @override
  String get plHouse9 => 'fortuna, dharma, ensino superior, guru e pai';

  @override
  String get plHouse10 => 'carreira, status, autoridade e carma público';

  @override
  String get plHouse11 =>
      'ganhos, renda, amigos, rede de contatos e desejos realizados';

  @override
  String get plHouse12 =>
      'perda, despesas, terras estrangeiras, espiritualidade e libertação';

  @override
  String get sumVeryStrong => 'Muito Forte';

  @override
  String get sumStrong => 'Forte';

  @override
  String get sumAverage => 'Médio';

  @override
  String get sumWeak => 'Fraco';

  @override
  String get sumNeedsAttention => 'Precisa de Atenção';

  @override
  String get sumFire => 'Fogo';

  @override
  String get sumEarth => 'Terra';

  @override
  String get sumAir => 'Ar';

  @override
  String get sumWater => 'Água';

  @override
  String get sumMovable => 'Móvel';

  @override
  String get sumFixed => 'Fixo';

  @override
  String get sumDual => 'Dual';

  @override
  String get sumDirEast => 'Leste';

  @override
  String get sumDirWest => 'Oeste';

  @override
  String get sumDirNorth => 'Norte';

  @override
  String get sumDirSouth => 'Sul';

  @override
  String get sumDirNE => 'Nordeste';

  @override
  String get sumDirNW => 'Noroeste';

  @override
  String get sumDirSE => 'Sudeste';

  @override
  String get sumDirSW => 'Sudoeste';

  @override
  String get sumSnapshotTitle => 'Seu Resumo Astrológico';

  @override
  String get sumMahadasha => 'Mahadasha';

  @override
  String get sumAntardasha => 'Antardasha';

  @override
  String get sumNakshatra => 'Janma Nakshatra';

  @override
  String get sumElement => 'Elemento';

  @override
  String get sumModality => 'Modalidade';

  @override
  String get sumLuckyDirection => 'Direção da Sorte';

  @override
  String get sumHighlights => 'Destaques Importantes';

  @override
  String get sumStrongPlanet => 'Planeta Mais Forte';

  @override
  String get sumWeakPlanet => 'Planeta Mais Fraco';

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
  String get sumQuickInsights => 'Insights Rápidos';

  @override
  String get sumSpirituality => 'Espiritualidade';

  @override
  String get sumTimezone => 'Fuso Horário';

  @override
  String get sumAyanamsa => 'Ayanamsa';

  @override
  String get sumCalendarType => 'Calendário';

  @override
  String get sumCopied => 'Copiado para a área de transferência';

  @override
  String get sumNatureFire =>
      'Você tem uma natureza ousada, energética e pioneira que lidera à frente.';

  @override
  String get sumNatureEarth =>
      'Você tem uma natureza prática, aterrada e disciplinada que constrói resultados duradouros.';

  @override
  String get sumNatureAir =>
      'Você tem uma natureza curiosa, comunicativa e intelectual que prospera com novas ideias.';

  @override
  String get sumNatureWater =>
      'Você tem uma natureza intuitiva, emocional e empática, com profunda sensibilidade interior.';

  @override
  String get sumGradePhraseExcellent =>
      'Fortemente apoiado — resultados favoráveis são prováveis com esforço constante.';

  @override
  String get sumGradePhraseGood =>
      'Bem apoiado — geralmente positivo com um pouco de cuidado.';

  @override
  String get sumGradePhraseAverage =>
      'Apoio misto — os resultados dependem do esforço e do timing.';

  @override
  String get sumGradePhraseWeak =>
      'Precisa de atenção — paciência e remédios ajudam aqui.';

  @override
  String get kDefCombust =>
      'Um planeta muito próximo do Sol, de modo que sua energia fica \'queimada\' e enfraquecida.';

  @override
  String get kDefRetrograde =>
      'Um planeta que parece se mover para trás; seus efeitos se voltam para dentro e se intensificam.';

  @override
  String get kDefNakshatra =>
      'Uma das 27 mansões lunares pelas quais a Lua e os planetas transitam.';

  @override
  String get kDefVargottama =>
      'Um planeta no mesmo signo tanto no mapa natal (D1) quanto no navamsa (D9) — uma marca de força.';

  @override
  String get kDefOwnSign =>
      'Um planeta posicionado em um signo que ele governa, onde se sente em casa e gera resultados estáveis.';

  @override
  String get kDefExalted =>
      'Um planeta em seu signo de maior força, entregando seus melhores resultados.';

  @override
  String get kDefDebilitated =>
      'Um planeta em seu signo mais fraco, onde tem dificuldade para gerar resultados.';

  @override
  String get kDefMooltrikona =>
      'Uma porção especial do signo próprio de um planeta onde ele é especialmente poderoso.';

  @override
  String get kDefAscendant =>
      'O signo que se ergue no horizonte leste no momento do nascimento — a Lagna, a base do mapa.';

  @override
  String get kDefMahadasha =>
      'O período planetário principal que colore um longo período da vida.';

  @override
  String get kDefAntardasha =>
      'Um subperíodo dentro de uma Mahadasha que ajusta seus resultados.';

  @override
  String get kDefPada =>
      'Um dos quatro quartos de um nakshatra ocupado por um planeta.';

  @override
  String get aspGivesAspectTo => 'Dá Aspecto Para';

  @override
  String get aspReceivesAspectFrom => 'Recebe Aspecto De';

  @override
  String get aspInfluences => 'Influencia';

  @override
  String get aspNoInfluence => 'Sem Influência';

  @override
  String get aspNoAspect => 'Sem Aspecto';

  @override
  String get aspPresent => 'Presente';

  @override
  String get aspAbsent => 'Ausente';

  @override
  String get aspNotPresent => 'Não Presente';

  @override
  String get aspSpecialAspect => 'Aspecto Especial';

  @override
  String get aspAspectWord => 'Aspecto';

  @override
  String get aspTotalGiven => 'Aspectos Dados';

  @override
  String get aspTotalReceived => 'Aspectos Recebidos';

  @override
  String get aspStrongestInfluence => 'Influência Mais Forte';

  @override
  String get aspMedium => 'Médio';

  @override
  String get aspAspectPresent => 'Aspecto Presente';

  @override
  String get aspReason => 'Motivo';

  @override
  String get aspBoth => 'Ambos';

  @override
  String get aspTargetHouse => 'Casa Alvo';

  @override
  String get aspTargetSign => 'Signo Alvo';

  @override
  String get aspLagnaReceives => 'Lagna Recebe Aspecto De';

  @override
  String get aspNoAspectFrom => 'Sem Aspecto De';

  @override
  String get aspPlanetToPlanet => 'Planeta para Planeta';

  @override
  String get aspSignToSign => 'Signo para Signo';

  @override
  String get aspCombinedAspect => 'Aspecto Combinado';

  @override
  String get aspGrahaAspect => 'Aspecto Graha';

  @override
  String get aspRashiAspect => 'Aspecto Rashi';

  @override
  String get aspInfoTitle => 'Entendendo os Aspectos (Drishti)';

  @override
  String get aspQGraha => 'O que é Graha Drishti?';

  @override
  String get aspQRashi => 'O que é Rashi Drishti?';

  @override
  String get aspQDiff => 'Diferença entre os dois';

  @override
  String get aspQPredict => 'Como os aspectos afetam a previsão';

  @override
  String get aspGrahaBody =>
      'Graha Drishti é o aspecto que um planeta projeta a partir de sua posição. Todo planeta aspecta totalmente a 7ª casa/planeta a partir de si mesmo (uma influência direta, cara a cara). Além disso, Marte aspecta a 4ª e a 8ª, Júpiter a 5ª e a 9ª, e Saturno a 3ª e a 10ª. Rahu e Ketu geralmente recebem a 5ª, 7ª e 9ª. O aspecto de um planeta colore o planeta ou casa em que incide com sua própria natureza.';

  @override
  String get aspRashiBody =>
      'Rashi Drishti é um aspecto signo a signo da astrologia Jaimini, independente de quais planetas estão lá. Signos móveis aspectam signos fixos (exceto o adjacente), signos fixos aspectam signos móveis (exceto o adjacente), e signos duais aspectam os outros signos duais. É usado principalmente na previsão Jaimini e para avaliar relações entre casas.';

  @override
  String get aspDiffBody =>
      'Graha Drishti é lançado por um planeta e depende de onde esse planeta está. Rashi Drishti pertence ao próprio signo e se aplica a tudo que está posicionado nele. Graha Drishti é direcional (o planeta A vê o planeta B), enquanto Rashi Drishti costuma ser mútuo entre os signos. Quando ambos apontam para o mesmo alvo, a influência é especialmente forte.';

  @override
  String get aspPredictBody =>
      'Um aspecto mostra onde um planeta estende sua influência além de sua própria casa. Um aspecto benéfico (Júpiter, Vênus, Lua/Mercúrio bem posicionados) apoia e protege o alvo; um aspecto maléfico (Saturno, Marte, Sol, Rahu, Ketu) pode pressionar, atrasar ou desafiá-lo. Ler quais planetas aspectam uma casa ou planeta explica por que os resultados aparecem da forma como aparecem.';

  @override
  String get aspTraitSun => 'autoridade, liderança e vitalidade';

  @override
  String get aspTraitMoon => 'profundidade emocional, conforto e intuição';

  @override
  String get aspTraitMars => 'energia, coragem e ímpeto';

  @override
  String get aspTraitMercury => 'comunicação, intelecto e adaptabilidade';

  @override
  String get aspTraitJupiter => 'sabedoria, crescimento e boa fortuna';

  @override
  String get aspTraitVenus => 'amor, harmonia e conforto';

  @override
  String get aspTraitSaturn =>
      'disciplina, responsabilidade e sucesso paciente, às vezes tardio';

  @override
  String get aspTraitRahu =>
      'ambição, intensidade e reviravoltas não convencionais';

  @override
  String get aspTraitKetu => 'desapego, espiritualidade e mudança repentina';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '$planet está influenciando $targets. Isso pode trazer $trait para as áreas representadas por esses planetas.';
  }

  @override
  String aspAiNone(Object planet) {
    return '$planet não lança um aspecto especial sobre nenhum outro planeta aqui; sua influência atua principalmente através de seu próprio signo e casa.';
  }

  @override
  String get avSummaryTitle => 'Resumo do Ashtakavarga';

  @override
  String get avOverallScore => 'Pontuação Geral do SAV';

  @override
  String get avOverallRating => 'Avaliação Geral';

  @override
  String get avStrongestSigns => 'Signos Mais Fortes';

  @override
  String get avWeakestSigns => 'Signos Mais Fracos';

  @override
  String get avScore => 'Pontuação';

  @override
  String get avMeaning => 'Significado';

  @override
  String get avGrid => 'Grade';

  @override
  String get avList => 'Lista';

  @override
  String get avOverallScoreShort => 'Pontuação Geral';

  @override
  String get avNatalSignScore => 'Pontuação do Signo Natal';

  @override
  String get avBestSigns => 'Melhores Signos';

  @override
  String get avWeakSigns => 'Signos Fracos';

  @override
  String get avAiInterpretation => 'Interpretação da IA';

  @override
  String get avVeryGood => 'Muito Bom';

  @override
  String get avVeryWeak => 'Muito Fraco';

  @override
  String get avTotalSav => 'SAV Total';

  @override
  String get avPlanetContributions => 'Contribuições dos Planetas';

  @override
  String get avFinance => 'Finanças';

  @override
  String get avOverallStrength => 'Força Geral';

  @override
  String get avWhatDoesThisMean => 'O que isso significa?';

  @override
  String get avSimple => 'Simples';

  @override
  String get avAdvanced => 'Avançado';

  @override
  String get avInfoTitle => 'Entendendo o Ashtakavarga';

  @override
  String get avStrong => 'Forte';

  @override
  String get avModerate => 'Moderado';

  @override
  String get avQWhatIsAv => 'O que é Ashtakavarga?';

  @override
  String get avQWhatIsSav => 'O que é SAV?';

  @override
  String get avQWhatIsBav => 'O que é BAV?';

  @override
  String get avQHowToRead => 'Como ler essas pontuações';

  @override
  String get avQSavVsBav => 'SAV vs BAV';

  @override
  String get avABody =>
      'Ashtakavarga é um sistema de força baseado em pontos na astrologia védica. Cada planeta concede pontos benéficos (bindus, também chamados de rekhas) aos doze signos com base em sua posição. Mais pontos em um signo significam que essa área da vida recebe apoio mais tranquilo durante os períodos e trânsitos planetários relacionados.';

  @override
  String get avSavBody =>
      'O SAV (Sarva Ashtakavarga) soma os pontos dos sete planetas para cada signo. Ele fornece uma única pontuação de força por signo, para que você possa ver rapidamente quais signos — e as casas em que caem — são mais bem apoiados no seu mapa.';

  @override
  String get avBavBody =>
      'O BAV (Bhinna Ashtakavarga) mostra os pontos de um único planeta nos doze signos. Ele indica quais signos um planeta específico mais apoia, o que importa quando a dasha ou o trânsito desse planeta está ativo.';

  @override
  String get avHowToReadBody =>
      'Números mais altos são melhores. Para o SAV, um signo médio pontua cerca de 28 pontos — acima de 30 é forte e abaixo de 25 precisa de cuidado. Para o BAV, cada signo varia de 0 a 8, sendo 4 a média. Favoreça seus signos mais fortes para ações importantes, e mantenha paciência e disciplina com os mais fracos.';

  @override
  String get avSavVsBavBody =>
      'O SAV é o total combinado de todos os planetas e mostra a força geral de um signo. O BAV é a contribuição de um único planeta e mostra qual planeta apoia esse signo. Use o SAV para o panorama geral, e o BAV para entender qual planeta impulsiona a força de um signo.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'Seu mapa é mais forte em $s1, $s2 e $s3. Esses signos oferecem melhor apoio durante períodos e trânsitos planetários. $weak atualmente tem o menor apoio, então paciência e disciplina ajudam em assuntos relacionados a ele.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '$planet tem seu melhor desempenho através de $s1 e $s2. Assuntos governados por $planet tendem a melhorar quando esses signos são ativados.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'Seus signos mais fortes são $s1 e $s2 — favoreça começos importantes quando os planetas transitarem por eles.';
  }

  @override
  String avInsightWeak(Object s1) {
    return '$s1 tem o menor apoio — proceda com cuidado e evite comprometimentos excessivos em seus assuntos.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '$planet carrega o maior número de pontos, então suas significações são bem apoiadas em sua vida.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '$planet carrega o menor número de pontos e se beneficia mais de remédios e esforço consciente.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'Signos com pontuação acima da sua média de $avg pontos tendem a dar resultados mais tranquilos e confiáveis.';
  }

  @override
  String get fcKey => 'Chave';

  @override
  String get fcActions => 'Ações';

  @override
  String get fcCautions => 'Cuidados';

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
  String get fcAnalysis => 'Análise';

  @override
  String get fcConfidence => 'Confiança';

  @override
  String get fcQualityCaps => 'QUALIDADE';

  @override
  String get fcIncomeVs => 'Renda vs';

  @override
  String get fcExpense => 'Despesa';

  @override
  String get fcFinance => 'FINANÇAS';

  @override
  String get fcNetBalance => 'Saldo Líquido';

  @override
  String get fcSignature => 'Assinatura';

  @override
  String get fcBestTimeForIncome => 'Melhor Horário para Renda';

  @override
  String get fcExpenseCaution => 'Cautela com Despesas';

  @override
  String get fcIncomeCaps => 'RENDA';

  @override
  String get fcExpenseCaps => 'DESPESA';

  @override
  String get fcRelationships => 'Relacionamentos';

  @override
  String get fcAreasCaps => 'ÁREAS';

  @override
  String get fcBestForMeetings => 'Melhor Para Reuniões';

  @override
  String get fcOpportunitiesVs => 'Oportunidades vs';

  @override
  String get fcRisks => 'Riscos';

  @override
  String get fcOutlook => 'PANORAMA';

  @override
  String get fcAction => 'Ação';

  @override
  String get fcProtect => 'Proteger';

  @override
  String get fcOpportunityCaps => 'OPORTUNIDADE';

  @override
  String get fcRiskCaps => 'RISCO';

  @override
  String get fcTopOpportunities => 'PRINCIPAIS OPORTUNIDADES';

  @override
  String get fcTopRisks => 'PRINCIPAIS RISCOS';

  @override
  String get fcTiming => 'Timing';

  @override
  String get fcWindows => 'Janelas';

  @override
  String get fcSlotsCaps => 'HORÁRIOS';

  @override
  String get fcBestWindows => 'MELHORES JANELAS';

  @override
  String get fcWorstWindows => 'PIORES JANELAS';

  @override
  String get fcAvoid => 'Evitar';

  @override
  String get fcHouse => 'Casa';

  @override
  String get fcFailed => 'Falhou';

  @override
  String get lifeCareer => 'Carreira';

  @override
  String get lifeHealth => 'Saúde';

  @override
  String get lifeWealth => 'Riqueza';

  @override
  String get lifeFamily => 'Família';

  @override
  String get lifeMind => 'Mente';

  @override
  String get lifeEgo => 'Ego';

  @override
  String get lifeAggression => 'Agressividade';

  @override
  String get lifeConflict => 'Conflito';

  @override
  String get rashiElement => 'Elemento';

  @override
  String get rashiQuality => 'Qualidade';

  @override
  String get rashiLuckyColor => 'Cor da Sorte';

  @override
  String get rashiLuckyDay => 'Dia da Sorte';

  @override
  String get rashiLuckyNumber => 'Número da Sorte';

  @override
  String get rashiGemstone => 'Pedra Preciosa';

  @override
  String get rashiBody => 'Corpo';

  @override
  String get gocharTodaysTransitChart => 'Mapa de Trânsito de Hoje';

  @override
  String get gocharTransit => 'Trânsito';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get thisMonth => 'Este Mês';

  @override
  String get best => 'Melhor';

  @override
  String get worst => 'Pior';

  @override
  String get avg => 'média';

  @override
  String get favorableLoveWindowsLabel => 'Janelas Favoráveis para o Amor';

  @override
  String get lordLabel => 'Senhor';

  @override
  String get lordPlacementLabel => 'Posicionamento do Senhor';

  @override
  String get lordDignityLabel => 'Dignidade do Senhor';

  @override
  String get categoriesSuffix => 'Categorias';

  @override
  String get coreBlockerLabel => 'BLOQUEIO CENTRAL';

  @override
  String get coreGiftLabel => '✦ DOM CENTRAL';

  @override
  String get coreThemeLabel => '● TEMA CENTRAL';

  @override
  String dominantLabel(Object value) {
    return 'Dominante: $value';
  }

  @override
  String get karakasSuffix => 'Karakas';

  @override
  String get protectiveLabel => 'PROTETOR';

  @override
  String secondaryLabel(Object value) {
    return ' · Secundário: $value';
  }

  @override
  String get tagCore => 'CENTRAL';

  @override
  String get debtScoresHeader => '📉 PONTUAÇÕES DE DÍVIDA';

  @override
  String get debtCurrentLoadStat => 'CARGA DE\nDÍVIDA ATUAL';

  @override
  String get debtRecoveryCapacityStat => 'CAPACIDADE DE\nRECUPERAÇÃO';

  @override
  String get debtIntensityStat => 'INTENSIDADE';

  @override
  String get debtDefaultRiskStat => 'RISCO DE INADIMPLÊNCIA';

  @override
  String get debtProfileTitle => 'Perfil de Dívida';

  @override
  String get debtKarmaLabel => 'CARMA';

  @override
  String get debtPersonalityLabel => 'PERSONALIDADE';

  @override
  String get debtPhaseLabel => 'FASE';

  @override
  String get debtPrimaryCategoryLabel => 'CATEGORIA PRIMÁRIA';

  @override
  String get debtWord => 'Dívida';

  @override
  String get debtYogasTitle => 'Yogas de Dívida';

  @override
  String get debtCreatingLabel => 'CRIA DÍVIDA';

  @override
  String get debtClearingLabel => 'QUITA DÍVIDA';

  @override
  String get yearlyDebtTitle => 'Dívida Anual';

  @override
  String get debtRepaymentTitle => 'Pagamento';

  @override
  String get debtDangerPeriodsTitle => 'Períodos de Perigo';

  @override
  String get debtDefaultPctStat => '% INADIMPLÊNCIA';

  @override
  String get debtBankruptcyPctStat => '% FALÊNCIA';

  @override
  String get debtChronicPctStat => '% CRÔNICO';

  @override
  String get debtResilienceStat => 'RESILIÊNCIA';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'Recuperação: $pct% · Cronograma: $years anos';
  }

  @override
  String get debtFreeWindowLabel => '🎯 JANELA DE LIBERDADE DE DÍVIDAS';

  @override
  String debtFreeYear(Object year) {
    return 'Ano $year';
  }

  @override
  String get legalScoresHeader => '⚖️ PONTUAÇÕES JURÍDICAS';

  @override
  String get legalVulnerabilityStat => 'VULNERABILIDADE\nJURÍDICA';

  @override
  String get legalVictoryPotentialStat => 'POTENCIAL DE\nVITÓRIA';

  @override
  String get legalConflictStat => 'CONFLITO';

  @override
  String get legalResolutionStat => 'RESOLUÇÃO';

  @override
  String get legalProfileTitle => 'Perfil Jurídico';

  @override
  String get legalKarmaTypeLabel => 'TIPO DE CARMA';

  @override
  String get legalConflictStyleLabel => 'ESTILO DE CONFLITO';

  @override
  String get legalStrategyLabel => 'ESTRATÉGIA';

  @override
  String get legalCaseDurationLabel => 'DURAÇÃO DO CASO';

  @override
  String get legalCurrentStatusLabel => 'STATUS ATUAL';

  @override
  String get legalWord => 'Jurídico';

  @override
  String get legalYogasTitle => 'Yogas Jurídicos';

  @override
  String get legalDisputePressureLabel => 'PRESSÃO DE DISPUTA';

  @override
  String get legalProtectionLabel => 'PROTEÇÃO JURÍDICA';

  @override
  String get legalStressTrendTitle => 'Estresse Jurídico';

  @override
  String get legalVisibleEnemiesStat => 'INIMIGOS VISÍVEIS';

  @override
  String get legalHiddenEnemiesStat => 'INIMIGOS OCULTOS';

  @override
  String get legalCriminalRiskStat => 'RISCO CRIMINAL';

  @override
  String get legalFalseAccusationStat => 'ACUSAÇÃO FALSA';

  @override
  String get legalContractKarmaTitle => 'Carma Contratual';

  @override
  String get legalDocumentationLabel => 'DOCUMENTAÇÃO';

  @override
  String get legalFinePrintAwareLabel => 'ATENÇÃO ÀS LETRAS MIÚDAS';

  @override
  String get legalNegotiationSkillLabel => 'HABILIDADE DE NEGOCIAÇÃO';

  @override
  String get legalSignatureCautionLabel => 'CAUTELA AO ASSINAR';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'Resiliência: $pct/100';
  }

  @override
  String get legalVictoryWord => 'Vitória';

  @override
  String get legalAnalysisSuffix => 'Análise';

  @override
  String get legalAsPlaintiff => 'COMO AUTOR';

  @override
  String get legalAsDefendant => 'COMO RÉU';

  @override
  String get legalWinProbability => 'PROBABILIDADE DE VITÓRIA';

  @override
  String get legalDisputeWord => 'Disputa';

  @override
  String get lifepathScoresHeader => '🌟 PONTUAÇÕES DO CAMINHO DE VIDA';

  @override
  String get lifepathDharmaClarityStat => 'CLAREZA DE\nDHARMA';

  @override
  String get lifepathFortuneBaselineStat => 'BASE DE\nFORTUNA';

  @override
  String get lifepathCoherenceStat => 'COERÊNCIA DO\nCAMINHO DE VIDA';

  @override
  String get lifepathKarmaStat => 'CARMA';

  @override
  String get lifepathSpiritualStat => 'ESPIRITUAL';

  @override
  String get lifepathFameStat => 'FAMA';

  @override
  String get lifepathSoulContractTitle => 'Contrato da Alma';

  @override
  String get lifepathAtmakarakaLabel => 'ATMAKARAKA';

  @override
  String get lifepathAkFocusLabel => 'FOCO DO AK';

  @override
  String get lifepathSoulPurposeLabel => 'PROPÓSITO DA ALMA';

  @override
  String get lifepathLifeChapterLabel => 'CAPÍTULO DE VIDA';

  @override
  String get lifepathPrimaryDomainLabel => 'DOMÍNIO PRIMÁRIO';

  @override
  String get lifepathLeadershipStat => 'LIDERANÇA';

  @override
  String get lifepathWisdomTeachStat => 'SABEDORIA/ENSINO';

  @override
  String get lifepathServiceStat => 'SERVIÇO';

  @override
  String get lifepathHealingStat => 'CURA';

  @override
  String get lifepathFortuneYogasTitle => 'Yogas de Fortuna';

  @override
  String get lifepathLuckBlocksLabel => 'BLOQUEIOS DE SORTE';

  @override
  String get lifepathFortuneBoostersLabel => 'IMPULSIONADORES DE FORTUNA';

  @override
  String get lifepathFortuneTrendTitle => 'Tendência de Fortuna';

  @override
  String get lifepathGoldenWindowsTitle => 'Janelas Douradas ★';

  @override
  String get lifepathTransformationTitle => 'Transformação';

  @override
  String get lifepathMilestonesTitle => 'Marcos de Vida';

  @override
  String get lifepathKarmicLessonsTitle => 'Lições Cármicas';

  @override
  String get lifepathRahuGrowthLabel => 'CRESCIMENTO DE RAHU';

  @override
  String get lifepathKetuSurrenderLabel => 'ENTREGA DE KETU';

  @override
  String get lifepathSaturnLessonLabel => 'LIÇÃO DE SATURNO';

  @override
  String get lifepathLifeDifficultyLabel => 'DIFICULDADE DE VIDA';

  @override
  String get lifepathSoulExperienceTitle => '★ A ALMA VEIO EXPERIMENTAR';

  @override
  String get lifepathBlessingsTitle => '● BÊNÇÃOS';

  @override
  String get lifepathLifeWord => 'Vida';

  @override
  String get lifepathArchetypeSuffix => 'Arquétipo';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'Realização: $pct%';
  }

  @override
  String get lifepathDestinyVsWord => 'Destino vs';

  @override
  String get lifepathFreeWillSuffix => 'Livre-Arbítrio';

  @override
  String get lifepathDestinyStat => 'DESTINO';

  @override
  String get lifepathFreeWillStat => 'LIVRE-ARBÍTRIO';

  @override
  String get pastlifeScoresHeader => '🔮 PONTUAÇÕES DE VIDA PASSADA';

  @override
  String get pastlifeSignatureStrengthStat => 'FORÇA DA\nASSINATURA';

  @override
  String get pastlifeCarryForwardStat => 'TRANSPORTADO\nADIANTE';

  @override
  String get pastlifeMasteryPreservedStat => 'MAESTRIA\nPRESERVADA';

  @override
  String get pastlifeUnfinishedStat => 'INACABADO';

  @override
  String get pastlifeKarmicDebtStat => 'DÍVIDA CÁRMICA';

  @override
  String get pastlifeProfileTitle => 'Perfil de Vida Passada';

  @override
  String get pastlifeThemeLabel => 'TEMA';

  @override
  String get pastlifeProfessionLabel => 'PROFISSÃO';

  @override
  String get pastlifeSocialStandingLabel => 'POSIÇÃO SOCIAL';

  @override
  String get pastlifeRegionLabel => 'REGIÃO';

  @override
  String get pastlifeSpiritualLevelLabel => 'NÍVEL ESPIRITUAL';

  @override
  String get pastlifeGenderLabel => 'GÊNERO';

  @override
  String get pastlifeWealthLevelLabel => 'NÍVEL DE RIQUEZA';

  @override
  String get pastlifeFamilyRoleLabel => 'PAPEL NA FAMÍLIA';

  @override
  String get pastlifeSkillsCarriedTitle => '★ HABILIDADES TRANSPORTADAS';

  @override
  String get pastlifeNaturalAttractionsTitle => '● ATRAÇÕES NATURAIS';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ MEDOS INEXPLICÁVEIS';

  @override
  String get pastlifeMagneticPullsTitle => '→ ATRAÇÕES MAGNÉTICAS';

  @override
  String get pastlifeRelationshipStat => 'RELACIONAMENTO';

  @override
  String get pastlifeFinancialStat => 'FINANCEIRO';

  @override
  String get pastlifeServiceStat => 'SERVIÇO';

  @override
  String get pastlifeDharmicStat => 'DHÁRMICO';

  @override
  String get pastlifeOnRelationsStat => 'NOS RELACIONAMENTOS';

  @override
  String get pastlifeOnCareerStat => 'NA CARREIRA';

  @override
  String get pastlifeOnHealthStat => 'NA SAÚDE';

  @override
  String get pastlifeOnSpiritualStat => 'NA ESPIRITUALIDADE';

  @override
  String get pastlifeKarmicResolutionTitle => 'Resolução Cármica';

  @override
  String get pastlifePrimaryPathLabel => 'CAMINHO PRIMÁRIO';

  @override
  String get pastlifeSecondaryPathLabel => 'CAMINHO SECUNDÁRIO';

  @override
  String get pastlifeClearingProgressLabel => 'PROGRESSO DA LIMPEZA';

  @override
  String get pastlifeRemainingWorkLabel => 'TRABALHO RESTANTE';

  @override
  String get pastlifeDebtTimelineLabel => 'CRONOGRAMA DA DÍVIDA';

  @override
  String get pastlifeMemoryAccessStat => 'ACESSO À MEMÓRIA';

  @override
  String get pastlifeDreamVisitsStat => 'VISITAS EM SONHOS';

  @override
  String get pastlifeDejaVuStat => 'DÉJÀ VU';

  @override
  String get pastlifeRegressionFitStat => 'APTIDÃO PARA REGRESSÃO';

  @override
  String get pastlifeActivationTitle => 'Ativação de Vida Passada';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'Maturidade: $maturity · Status: $status';
  }

  @override
  String get pastlifeKetuWord => 'Ketu';

  @override
  String get pastlifePastMasterySuffix => 'Maestria Passada';

  @override
  String get pastlifeKetuMasteredLabel => 'KETU · O QUE VOCÊ DOMINOU';

  @override
  String get pastlifeRahuWord => 'Rahu';

  @override
  String get pastlifeFutureGrowthSuffix => 'Crescimento Futuro';

  @override
  String get pastlifeRahuPullsLabel => 'RAHU · O QUE TE PUXA ADIANTE';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ Sombra: $shadow';
  }

  @override
  String get mentalScoresHeader => '🧠 PONTUAÇÕES MENTAIS';

  @override
  String get mentalStabilityStat => 'ESTABILIDADE\nMENTAL';

  @override
  String get mentalEmotionalBaselineStat => 'BASE\nEMOCIONAL';

  @override
  String get mentalResilienceStat => 'RESILIÊNCIA';

  @override
  String get mentalAnxietyStat => 'ANSIEDADE';

  @override
  String get mentalDepressionStat => 'DEPRESSÃO';

  @override
  String get mentalRegulationStat => 'REGULAÇÃO';

  @override
  String get mentalProfileTitle => 'Perfil Mental';

  @override
  String get mentalConstitutionLabel => 'CONSTITUIÇÃO';

  @override
  String get mentalStressDriverLabel => 'FATOR DE ESTRESSE';

  @override
  String get mentalStabilityAnchorLabel => 'ÂNCORA DE ESTABILIDADE';

  @override
  String get mentalStressResponseLabel => 'RESPOSTA AO ESTRESSE';

  @override
  String get mentalAttachmentStyleLabel => 'ESTILO DE APEGO';

  @override
  String get mentalBurnoutStageLabel => 'ESTÁGIO DE ESGOTAMENTO';

  @override
  String get mentalWord => 'Mental';

  @override
  String get mentalYogasTitle => 'Yogas Mentais';

  @override
  String get mentalStressPressureLabel => 'PRESSÃO DE ESTRESSE';

  @override
  String get mentalWellnessTrendTitle => 'Tendência de Bem-Estar';

  @override
  String get mentalHealthyCopingTitle => '✓ ENFRENTAMENTO SAUDÁVEL';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ RISCOS NÃO SAUDÁVEIS';

  @override
  String get mentalRecommendedAlternativesTitle =>
      '✦ ALTERNATIVAS RECOMENDADAS';

  @override
  String get mentalSleepQualityStat => 'QUALIDADE DO SONO';

  @override
  String get mentalSocialSupportStat => 'APOIO SOCIAL';

  @override
  String get mentalBurnoutVulnStat => 'VULN. AO ESGOTAMENTO';

  @override
  String get mentalSelfAwarenessStat => 'AUTOCONSCIÊNCIA';

  @override
  String get mentalAnxietyWord => 'Ansiedade';

  @override
  String get mentalTypesSuffix => 'Tipos';

  @override
  String get mentalTherapyWord => 'Terapia';

  @override
  String get mentalModalityFitSuffix => 'Compatibilidade de Modalidade';

  @override
  String get characterScoresHeader => '🔍 PONTUAÇÕES DE CARÁTER';

  @override
  String get characterStrengthStat => 'FORÇA DE\nCARÁTER';

  @override
  String get characterIntegrityStat => 'INTEGRIDADE';

  @override
  String get characterResilienceStat => 'RESILIÊNCIA';

  @override
  String get characterAwarenessStat => 'CONSCIÊNCIA';

  @override
  String get characterStabilityStat => 'ESTABILIDADE';

  @override
  String get characterEthicsStat => 'ÉTICA';

  @override
  String get characterSurfacePersonalityTitle => 'Personalidade Aparente';

  @override
  String get characterLagnaLabel => 'LAGNA';

  @override
  String get characterConstitutionLabel => 'CONSTITUIÇÃO';

  @override
  String get characterNakshatraLabel => 'NAKSHATRA';

  @override
  String get characterDeityLabel => 'DIVINDADE';

  @override
  String get characterMoonManasTitle => 'Manas Lunar';

  @override
  String get characterSignLabel => 'SIGNO';

  @override
  String get characterHouseLabel => 'CASA';

  @override
  String get characterWarmthStat => 'CALOR HUMANO';

  @override
  String get characterEmpathyStat => 'EMPATIA';

  @override
  String get characterLoyaltyStat => 'LEALDADE';

  @override
  String get characterBoundariesStat => 'LIMITES';

  @override
  String get characterDharmaStat => 'DHARMA';

  @override
  String get characterTruthStat => 'VERDADE';

  @override
  String get characterCompassionStat => 'COMPAIXÃO';

  @override
  String get characterGenerosityStat => 'GENEROSIDADE';

  @override
  String get characterSignatureVirtuesTitle => '★ VIRTUDES CARACTERÍSTICAS';

  @override
  String get characterNaturalTalentsTitle => '● TALENTOS NATURAIS';

  @override
  String get characterShadowPatternsTitle => '⚠ PADRÕES DE SOMBRA';

  @override
  String get characterYogasTitle => 'Yogas de Caráter';

  @override
  String get characterTestsLabel => 'TESTES';

  @override
  String get characterGiftsLabel => 'DONS';

  @override
  String get characterSelfAwareEiStat => 'IE AUTOCONSCIENTE';

  @override
  String get characterSelfRegulateStat => 'AUTORREGULAÇÃO';

  @override
  String get characterEmpathyEiStat => 'IE EMPATIA';

  @override
  String get characterSocialSkillsStat => 'HABILIDADES SOCIAIS';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'Realização: $pct%';
  }

  @override
  String get characterAtmakarakaWord => 'Atmakaraka';

  @override
  String get characterSoulSignatureSuffix => 'Assinatura da Alma';

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
  String get healthScoresHeader => '🏥 PONTUAÇÕES DE SAÚDE';

  @override
  String get healthVitalityStat => 'VITALIDADE';

  @override
  String get healthImmunityStat => 'IMUNIDADE';

  @override
  String get healthRecoveryStat => 'RECUPERAÇÃO';

  @override
  String get healthMentalStat => 'MENTAL';

  @override
  String get healthStressTolStat => 'TOL. AO ESTRESSE';

  @override
  String get healthYogasTitle => 'Yogas de Saúde';

  @override
  String get healthDiseasePressureLabel => 'PRESSÃO DE DOENÇA';

  @override
  String get healthTrendTitle => 'Tendência de Saúde';

  @override
  String get healthRecoveryWindowsTitle => 'Janelas de Recuperação';

  @override
  String get healthCautionPeriodsTitle => 'Períodos de Cautela';

  @override
  String get healthFertilityStat => 'FERTILIDADE';

  @override
  String get healthBurnoutRiskStat => 'RISCO DE ESGOTAMENTO';

  @override
  String get healthAddictionVulnStat => 'VULN. À DEPENDÊNCIA';

  @override
  String get healthWorkLifeBalStat => 'EQUILÍBRIO TRABALHO-VIDA';

  @override
  String get healthAyurvedicWord => 'Ayurvédica';

  @override
  String get healthConstitutionSuffix => 'Constituição';

  @override
  String get healthBodyWord => 'Corpo';

  @override
  String get healthSystemMapSuffix => 'Mapa de Sistemas';

  @override
  String get healthBodyZoneWord => 'Zona Corporal';

  @override
  String get healthVulnerabilitySuffix => 'Vulnerabilidade';

  @override
  String get healthDiseaseWord => 'Doença';

  @override
  String get healthSusceptibilitySuffix => 'Suscetibilidade';

  @override
  String get healthLifestyleFactorsTitle => 'Fatores de Estilo de Vida';

  @override
  String get healthSleepDisciplineLabel => 'DISCIPLINA DO SONO';

  @override
  String get healthDietDisciplineLabel => 'DISCIPLINA ALIMENTAR';

  @override
  String get healthExerciseNeedLabel => 'NECESSIDADE DE EXERCÍCIO';

  @override
  String get healthSunlightNeedLabel => 'NECESSIDADE DE SOL';

  @override
  String get healthSocialTypeLabel => 'TIPO SOCIAL';

  @override
  String get healthHealingSpeedLabel => 'VELOCIDADE DE CURA';

  @override
  String get wealthScoresHeader => '💰 PONTUAÇÕES DE RIQUEZA';

  @override
  String get wealthStrengthStat => 'FORÇA DE\nRIQUEZA';

  @override
  String get wealthAccumulationStat => 'ACUMU-\nLAÇÃO';

  @override
  String get wealthIncomeFlowStat => 'FLUXO DE\nRENDA';

  @override
  String get wealthSustainStat => 'SUSTENTABILIDADE';

  @override
  String get wealthMultiStreamStat => 'MÚLTIPLAS FONTES';

  @override
  String get wealthRetentionStat => 'RETENÇÃO';

  @override
  String get wealthWord => 'Riqueza';

  @override
  String get wealthYogasTitle => 'Yogas de Riqueza';

  @override
  String get wealthDrainsLabel => 'DRENOS';

  @override
  String get wealthBoostersLabel => 'IMPULSIONADORES';

  @override
  String get wealthYearlyTrendTitle => 'Tendência Anual';

  @override
  String get wealthGrowthTitle => 'Crescimento de Riqueza';

  @override
  String get wealthCashPressureTitle => 'Pressão de Caixa';

  @override
  String get wealthMoneyPersonalityTitle => 'Personalidade Financeira';

  @override
  String get wealthTypeLabel => 'TIPO DE RIQUEZA';

  @override
  String get wealthRiskAppetiteLabel => 'APETITE AO RISCO';

  @override
  String get wealthInvestmentStyleLabel => 'ESTILO DE INVESTIMENTO';

  @override
  String get wealthMoneyPersonalityLabel => 'PERSONALIDADE FINANCEIRA';

  @override
  String get wealthSpendingLabel => 'GASTOS';

  @override
  String get wealthDebtProbStat => '% PROB. DE DÍVIDA';

  @override
  String get wealthInheritanceStat => '% HERANÇA';

  @override
  String get wealthSuddenGainsStat => '% GANHOS REPENTINOS';

  @override
  String get wealthSpouseBoostStat => '% IMPULSO DO CÔNJUGE';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'Probabilidade de sucesso: $pct%';
  }

  @override
  String get wealthLifetimeClassLabel => 'CLASSE DE RIQUEZA VITALÍCIA';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'Principal: $value';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'Pico: $value';
  }

  @override
  String get wealthIncomeWord => 'Renda';

  @override
  String get wealthSourcesSuffix => 'Fontes';

  @override
  String get wealthInvestmentWord => 'Investimento';

  @override
  String get wealthMixSuffix => 'Mix';

  @override
  String wealthDrivenByLabel(Object planet) {
    return 'Impulsionado por $planet';
  }

  @override
  String get marriageScoresHeader => '💒 PONTUAÇÕES DE CASAMENTO';

  @override
  String get marriageOverallStat => 'CASAMENTO\nGERAL';

  @override
  String get marriageHarmonyStat => 'HARMONIA\nCONJUGAL';

  @override
  String get marriageDomesticStabilityStat => 'ESTABILIDADE\nDOMÉSTICA';

  @override
  String get marriageLongevityStat => 'LONGEVIDADE';

  @override
  String get marriageSatisfactionStat => 'SATISFAÇÃO';

  @override
  String get marriageClarityStat => 'CLAREZA';

  @override
  String get marriageWindowsTitle => 'Janelas de Casamento';

  @override
  String get marriagePhasesTitle => 'Fases do Casamento';

  @override
  String get marriageInLawRelationsStat => 'RELAÇÃO COM SOGROS';

  @override
  String get marriageFamilyHarmonyStat => 'HARMONIA FAMILIAR';

  @override
  String get marriageFertilityStat => 'FERTILIDADE';

  @override
  String get marriageHomeOwnershipStat => 'POSSE DE IMÓVEL';

  @override
  String get marriageDivorceRiskStat => 'RISCO DE DIVÓRCIO';

  @override
  String get marriageInfidelityStat => 'INFIDELIDADE';

  @override
  String get marriageConflictStat => 'CONFLITO';

  @override
  String get marriageDistanceStat => 'DISTÂNCIA';

  @override
  String get marriageSeekInPartnerTitle => '★ PROCURE NO PARCEIRO';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ EVITE NO PARCEIRO';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'Realização: $pct%';
  }

  @override
  String get marriageDarakarakaWord => 'Darakaraka';

  @override
  String get marriageSpouseKarakaSuffix => 'Karaka do Cônjuge';

  @override
  String get marriageDarakarakaDkLabel => 'DARAKARAKA (DK)';

  @override
  String get marriage7thWord => '7ª';

  @override
  String get marriageSignLabel => 'SIGNO';

  @override
  String get marriageLordInLabel => 'SENHOR EM';

  @override
  String get marriageStrengthLabel => 'FORÇA';

  @override
  String get marriageSpouseWord => 'Cônjuge';

  @override
  String get marriageProfileSuffix => 'Perfil';

  @override
  String get marriageSpouseTraitsTitle => '★ TRAÇOS DO CÔNJUGE';

  @override
  String get marriageLikelyProfessionsTitle => '● PROFISSÕES PROVÁVEIS';

  @override
  String get marriageHarmonyWord => 'Harmonia';

  @override
  String get marriageRadarSuffix => 'Radar';

  @override
  String get marriagePhysicalLabel => 'Físico';

  @override
  String get marriageSharedValuesLabel => 'Valores Compartilhados';

  @override
  String get marriageConflictResolutionLabel => 'Resolução de Conflitos';

  @override
  String get marriageMangalDoshLabel => '⚠ MANGAL DOSH';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'Severidade: $value';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'Cancelamento: $value';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'Navamsa';

  @override
  String get multiChartTitleChild => 'Filho';

  @override
  String get multiChartTitleLove => 'Amor';

  @override
  String get multiChartTitleKarma => 'Carma';

  @override
  String get multiChartTitleDefault => 'Multi-Mapa';

  @override
  String get multiChartSuffixProbability => 'Probabilidade';

  @override
  String get multiChartSuffixCompatibility => 'Compatibilidade';

  @override
  String get multiChartSuffixLinkage => 'Ligação';

  @override
  String get multiChartSuffixReport => 'Relatório';

  @override
  String get multiChartParticipantsLabel => 'PARTICIPANTES';

  @override
  String get multiChartAnalysisWord => 'Análise';

  @override
  String get multiChartConfidenceSuffix => 'Confiança';

  @override
  String get multiChartQualityBadge => 'QUALIDADE';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'Analise este relatório de astrologia védica e forneça insights detalhados:\n\n$formatted';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'Aqui está um relatório especializado de astrologia védica. Por favor, analise-o minuciosamente e forneça insights acionáveis:\n\n$formatted';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'Revise esta análise de astrologia védica e explique as principais descobertas em linguagem simples:\n\n$formatted';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return 'Copiado para $label!';
  }

  @override
  String get childProbTitle1 => 'Probabilidade';

  @override
  String get childProbTitle2 => 'de Filhos';

  @override
  String get childNumberOfChildrenHeader1 => 'Número de';

  @override
  String get childNumberOfChildrenHeader2 => 'Filhos';

  @override
  String get childTimingHeader1 => 'Timing';

  @override
  String get childTimingHeader2 => 'Moola Dasha';

  @override
  String get child5thHouseHeader1 => 'Casa 5';

  @override
  String get analysisWord => 'Análise';

  @override
  String get jupiterWord => 'Júpiter';

  @override
  String get childD7Header1 => 'D7 Saptamsa';

  @override
  String get childBeejaHeader1 => 'Beeja e Kshetra';

  @override
  String get childBeejaHeader2 => 'Sphuta';

  @override
  String get childDoshaHeader1 => 'Dosha';

  @override
  String get childVedicHeader1 => 'Remédios';

  @override
  String get childVedicHeader2 => 'Védicos';

  @override
  String get progenyProbabilityLabel => 'PROBABILIDADE DE PROLE';

  @override
  String get favorableWindowsLabel => 'JANELAS FAVORÁVEIS';

  @override
  String get partnerOneLabel => 'Parceiro 1';

  @override
  String get partnerTwoLabel => 'Parceiro 2';

  @override
  String get moonSignLabel => 'Signo Lunar';

  @override
  String get lordInDusthana => 'Senhor em Dusthana';

  @override
  String get lordStrengthLabel => 'Força do Senhor';

  @override
  String get houseStrengthLabel => 'Força da Casa';

  @override
  String get dignityLabel => 'Dignidade';

  @override
  String get directBadge => 'Direto';

  @override
  String get notCombustBadge => 'Não Combusto';

  @override
  String get in5thHouseBadge => 'Na Casa 5';

  @override
  String get aspects5thBadge => 'Aspecta a Casa 5';

  @override
  String get no5thConnectionBadge => 'Sem Conexão com a Casa 5';

  @override
  String jupiterInSignHeading(String sign) {
    return 'Júpiter em $sign';
  }

  @override
  String get d7LagnaLabel => 'Lagna do D7';

  @override
  String get d7FifthSignLabel => 'Signo da Casa 5 no D7';

  @override
  String get d7FifthLordLabel => 'Senhor da Casa 5 no D7';

  @override
  String get jupiterInD7Label => 'Júpiter no D7';

  @override
  String get jupiterDignityLabel => 'Dignidade de Júpiter';

  @override
  String get d7StrengthLabel => 'Força do D7';

  @override
  String get yesWord => 'Sim';

  @override
  String get noWord => 'Não';

  @override
  String get beejaSphutaTitle => 'BEEJA SPHUTA';

  @override
  String get kshetraSphutaTitle => 'KSHETRA SPHUTA';

  @override
  String get degreeLabel => 'Grau';

  @override
  String get signLordLabel => 'Senhor do Signo';

  @override
  String get presentInLabel => 'Presente Em';

  @override
  String get netPenaltyLabel => 'Penalidade Líquida';

  @override
  String get remedyGemstone => 'Remédios com Pedras Preciosas';

  @override
  String get remedyMantra => 'Remédios com Mantras';

  @override
  String get remedyRitual => 'Remédios Rituais';

  @override
  String get remedyLifestyle => 'Remédios de Estilo de Vida';

  @override
  String get remedyCharitable => 'Remédios de Caridade';

  @override
  String copiedForName(String name) {
    return 'Copiado para $name!';
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
  String get favorabilityLabel => 'Favorabilidade';

  @override
  String factorPrefix(String factor) {
    return 'Fator: $factor';
  }

  @override
  String appliesToLabel(String value) {
    return 'Aplica-se a: $value';
  }

  @override
  String get qualityTag => 'QUALIDADE';

  @override
  String get reliabilityVeryHigh => 'Confiabilidade Muito Alta';

  @override
  String get reliabilityGuidanceLevel => 'Leitura de nível orientativo';

  @override
  String get karmaLinkTitle1 => 'Ligação';

  @override
  String get karmaLinkTitle2 => 'Cármica';

  @override
  String get karmaFoundationHeader1 => 'Fundação';

  @override
  String get karmaFoundationHeader2 => 'Cármica';

  @override
  String get karmaPairwiseHeader1 => 'Ligações';

  @override
  String get karmaPairwiseHeader2 => 'entre Pares';

  @override
  String get karmaGroupHeader1 => 'Padrão';

  @override
  String get karmaGroupHeader2 => 'de Grupo';

  @override
  String get karmaPastLifeHeader1 => 'Objetivos de';

  @override
  String get karmaPastLifeHeader2 => 'Vida Passada';

  @override
  String get karmaCurrentLifeHeader1 => 'Vida Atual';

  @override
  String get karmaCurrentLifeHeader2 => 'Aprendizado';

  @override
  String get karmaDebtsHeader2 => 'Dívidas';

  @override
  String get karmaMoolaDashaHeader1 => 'Timing da';

  @override
  String get karmaMoolaDashaHeader2 => 'Moola Dasha';

  @override
  String get karmaDeepAuditHeader1 => 'Tabela de';

  @override
  String get karmaDeepAuditHeader2 => 'Auditoria Detalhada';

  @override
  String get karmaHeroLabel => 'LIGAÇÃO CÁRMICA DE VIDA PASSADA';

  @override
  String get karmaKetuMastery => 'MAESTRIA DE KETU';

  @override
  String get nakshatraLabel => 'Nakshatra';

  @override
  String get deityLabel => 'Divindade';

  @override
  String get masteryScoreLabel => 'Pontuação de Maestria';

  @override
  String get karmaRahuGrowth => 'CRESCIMENTO DE RAHU';

  @override
  String get growthScoreLabel => 'Pontuação de Crescimento';

  @override
  String get karmaAtmakaraka => 'ATMAKARAKA';

  @override
  String get karmaSaturnKarma => 'CARMA DE SATURNO';

  @override
  String get karma12thHouse => 'CASA 12';

  @override
  String get karma9thHousePunya => 'PUNYA DA CASA 9';

  @override
  String get bhavaScoreLabel => 'Pontuação de Bhava';

  @override
  String get karmaD60Signature => 'ASSINATURA D60';

  @override
  String get depthScoreLabel => 'Pontuação de Profundidade';

  @override
  String get linkageStrengthLabel => 'Força da Ligação';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'FATORES DE LIGAÇÃO ($count ativos)';
  }

  @override
  String get factorColumnLabel => 'Fator';

  @override
  String get weightColumnLabel => 'Peso';

  @override
  String get meaningColumnLabel => 'Significado';

  @override
  String get statusColumnLabel => 'Status';

  @override
  String get karmaPastLifeConnection => 'CONEXÃO DE VIDA PASSADA';

  @override
  String get karmaCurrentLifeDynamic => 'DINÂMICA DA VIDA ATUAL';

  @override
  String get karmaWhatTheyTeach => 'O QUE ENSINAM UM AO OUTRO';

  @override
  String get karmaGroupThemeHeader => 'TEMA CÁRMICO DO GRUPO';

  @override
  String get karmaSharedSettingHeader =>
      'CENÁRIO COMPARTILHADO DE VIDA PASSADA';

  @override
  String get karmaCollectiveKetuHeader => 'PADRÃO COLETIVO DE KETU';

  @override
  String get karmaCollectiveRahuHeader => 'PADRÃO COLETIVO DE RAHU';

  @override
  String get housesPrefixLabel => 'Casas: ';

  @override
  String get signsPrefixLabel => 'Signos: ';

  @override
  String get karmicCohesionLabel => 'Coesão Cármica';

  @override
  String get karmaGroupSoulContractHeader => 'CONTRATO DE ALMA DO GRUPO';

  @override
  String get goalLabel => 'Objetivo';

  @override
  String get karmaSharedGoalHeader => 'OBJETIVO COMPARTILHADO DE VIDA PASSADA';

  @override
  String get howToGrowHeader => 'COMO CRESCER';

  @override
  String moolaDashaPrefix(String value) {
    return 'Moola Dasha: $value';
  }

  @override
  String get karmaSharedLessonHeader => 'LIÇÃO COMPARTILHADA DO GRUPO';

  @override
  String get karmaMutualTeachingHeader => 'MAPA DE ENSINO MÚTUO';

  @override
  String get karmaTeachingDynamicsPlaceholder =>
      'As dinâmicas de ensino surgirão à medida que as conexões cármicas se aprofundarem.';

  @override
  String get typeFieldLabel => 'Tipo';

  @override
  String get basisFieldLabel => 'Base';

  @override
  String get resolutionPathHeader => 'CAMINHO DE RESOLUÇÃO';

  @override
  String dashaTimingPrefix(String value) {
    return 'Timing de Dasha: $value';
  }

  @override
  String get mutualDebtsHeader => 'DÍVIDAS MÚTUAS';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'Datas';

  @override
  String get groupKarmicWindowHeader => 'JANELA CÁRMICA DO GRUPO';

  @override
  String parametersAuditedHeading(int count) {
    return '$count PARÂMETROS AUDITADOS';
  }

  @override
  String get valuePrefixLabel => 'Valor: ';

  @override
  String weightPrefix(String value) {
    return 'P: $value';
  }

  @override
  String get loveCompatTitle1 => 'Compatibilidade';

  @override
  String get loveCompatTitle2 => 'Amorosa';

  @override
  String get loveAttractionHeader1 => 'Atração e';

  @override
  String get loveAttractionHeader2 => 'Química';

  @override
  String get loveEmotionalHeader1 => 'Harmonia';

  @override
  String get loveEmotionalHeader2 => 'Emocional';

  @override
  String get loveMentalHeader1 => 'Sintonia';

  @override
  String get loveMentalHeader2 => 'Mental';

  @override
  String get lovePassionHeader1 => 'Paixão e';

  @override
  String get lovePassionHeader2 => 'Físico';

  @override
  String get loveLongtermHeader1 => 'Longo Prazo';

  @override
  String get loveKarmicHeader1 => 'Vínculo Amoroso';

  @override
  String get loveKarmicHeader2 => 'Cármico';

  @override
  String get loveChallengesHeader1 => 'Desafios e';

  @override
  String get loveChallengesHeader2 => 'Atritos';

  @override
  String get loveTimingHeader1 => 'Timing do Amor';

  @override
  String get loveRelationshipHeader1 => 'Dinâmica do';

  @override
  String get loveRelationshipHeader2 => 'Relacionamento';

  @override
  String get loveRemediesHeader1 => 'Remédios e';

  @override
  String get loveRemediesHeader2 => 'Orientação';

  @override
  String get loveCompatHeroLabel => 'COMPATIBILIDADE AMOROSA';

  @override
  String get loveChipAttraction => 'Atração';

  @override
  String get loveChipPassion => 'Paixão';

  @override
  String get loveChipChallenge => 'Desafio';

  @override
  String get venusSignLabel => 'Signo de Vênus';

  @override
  String get attractionScoreLabel => 'Pontuação de Atração';

  @override
  String get activeContactsLabel => 'Contatos Ativos';

  @override
  String get magneticPullLabel => 'Atração Magnética';

  @override
  String get initialAttractionLabel => 'Atração Inicial';

  @override
  String get emotionalScoreLabel => 'Pontuação Emocional';

  @override
  String get elementMatchLabel => 'Compatibilidade Elemental';

  @override
  String get harmonyLabel => 'Harmonia';

  @override
  String get kootaYoni => 'YONI';

  @override
  String get kootaGana => 'GANA';

  @override
  String get kootaTara => 'TARA';

  @override
  String get doshaPresentBadge => 'Dosha Presente';

  @override
  String get noDoshaBadge => 'Sem Dosha';

  @override
  String get axisLabel => 'Eixo';

  @override
  String get mentalScoreLabel => 'Pontuação Mental';

  @override
  String get mercuryDynamicsLabel => 'DINÂMICA DE MERCÚRIO';

  @override
  String get communicationStyleLabel =>
      'COMPATIBILIDADE DE ESTILO DE COMUNICAÇÃO';

  @override
  String get intellectualConnectionLabel => 'CONEXÃO INTELECTUAL';

  @override
  String get passionScoreLabel => 'Pontuação de Paixão';

  @override
  String get marsVenusLabel => 'INTERAÇÃO MARTE-VÊNUS';

  @override
  String get physicalChemistryLabel => 'QUÍMICA FÍSICA';

  @override
  String get yoniCompatLabel => 'COMPATIBILIDADE YONI';

  @override
  String get longtermScoreLabel => 'Pontuação de Longo Prazo';

  @override
  String get seventhHouseSynastryLabel => 'SINASTRIA DA CASA 7';

  @override
  String get commitmentPotentialLabel => 'POTENCIAL DE COMPROMISSO';

  @override
  String get jupiterBlessingLabel => 'BÊNÇÃO DE JÚPITER';

  @override
  String get d9NavamsaResonanceLabel => 'RESSONÂNCIA D9 NAVAMSA';

  @override
  String get saturnLongevityLabel => 'LONGEVIDADE DE SATURNO';

  @override
  String get karmicScoreLabel => 'Pontuação Cármica';

  @override
  String get darakarakaLinkLabel => 'LIGAÇÃO DARAKARAKA';

  @override
  String get sourceLabel => 'Fonte';

  @override
  String get emotionalGiverReceiverLabel => 'DOADOR / RECEPTOR EMOCIONAL';

  @override
  String get powerBalanceLabel => 'EQUILÍBRIO DE PODER';

  @override
  String get growthDynamicLabel => 'DINÂMICA DE CRESCIMENTO';

  @override
  String get addressesLabel => 'Aborda';

  @override
  String get loveScoresLabel => 'PONTUAÇÕES DE AMOR';

  @override
  String get loveCapacityLabel => 'CAPACIDADE\nDE AMOR';

  @override
  String get emotionalAvailabilityLabel => 'DISPONIBILIDADE\nEMOCIONAL';

  @override
  String get romanticAttractionLabel => 'ATRAÇÃO\nROMÂNTICA';

  @override
  String get commitmentWord => 'COMPROMISSO';

  @override
  String get intimacyWord => 'INTIMIDADE';

  @override
  String get fidelityWord => 'FIDELIDADE';

  @override
  String get loveProfileTitle => 'Perfil Amoroso';

  @override
  String get loveStyleLabel => 'ESTILO AMOROSO';

  @override
  String get attractionStyleLabel => 'ESTILO DE ATRAÇÃO';

  @override
  String get lovePathLabel => 'CAMINHO AMOROSO';

  @override
  String get currentPhaseLabel => 'FASE ATUAL';

  @override
  String get commitmentStyleLabel => 'ESTILO DE COMPROMISSO';

  @override
  String get loveWord => 'Amor';

  @override
  String get karakasWord => 'Karakas';

  @override
  String get attractedToLabel => 'ATRAÍDO POR';

  @override
  String get whatPartnerSeesLabel => 'O QUE O PARCEIRO VÊ';

  @override
  String get romancePatternTitle => 'Padrão Romântico';

  @override
  String get firstLoveAgeLabel => 'IDADE DO PRIMEIRO AMOR';

  @override
  String get relationshipCountLabel => 'NÚMERO DE RELACIONAMENTOS';

  @override
  String get avgDurationLabel => 'DURAÇÃO MÉDIA';

  @override
  String get breakupTriggerLabel => 'GATILHO DE ROMPIMENTO';

  @override
  String get heartbreakRecoveryLabel => 'RECUPERAÇÃO DE SOFRIMENTO AMOROSO';

  @override
  String get loveTrendTitle => 'Tendência Amorosa';

  @override
  String get newLoveWindowsTitle => 'Janelas para Novo Amor';

  @override
  String get loveBlocksTitle => 'Bloqueios Amorosos';

  @override
  String get activeBlocksLabel => 'BLOQUEIOS ATIVOS';

  @override
  String get loveMarriagePctLabel => '% CASAMENTO POR AMOR';

  @override
  String get heartbreakVulnLabel => 'VULN. AO SOFRIMENTO AMOROSO';

  @override
  String get selfSabotageLabel => 'AUTOSSABOTAGEM';

  @override
  String get emotionalIqLabel => 'QI EMOCIONAL';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'Realização: $pct%';
  }

  @override
  String get languagesWord => 'Linguagens';

  @override
  String get givesLabel => 'DÁ';

  @override
  String get receivesLabel => 'RECEBE';

  @override
  String get idealWord => 'Ideal';

  @override
  String get partnerWord => 'Parceiro';

  @override
  String get seekTheseTraitsLabel => 'PROCURE ESSES TRAÇOS';

  @override
  String get dealbreakersLabel => 'FATORES DECISIVOS NEGATIVOS';

  @override
  String get propertyScoresLabel => 'PONTUAÇÕES DE PROPRIEDADE';

  @override
  String get acquisitionCapacityLabel => 'CAPACIDADE DE\nAQUISIÇÃO';

  @override
  String get homeOwnershipPctLabel => '% POSSE\nDE IMÓVEL';

  @override
  String get reWealthPotentialLabel => 'POTENCIAL DE\nRIQUEZA IMOBILIÁRIA';

  @override
  String get rentalWord => 'ALUGUEL';

  @override
  String get vehiclesWord => 'VEÍCULOS';

  @override
  String get landPctLabel => '% TERRAS';

  @override
  String get propertyProfileTitle => 'Perfil de Propriedade';

  @override
  String get karmaTypeLabel => 'TIPO DE CARMA';

  @override
  String get environmentLabel => 'AMBIENTE';

  @override
  String get styleLabel => 'ESTILO';

  @override
  String get sizeLabel => 'TAMANHO';

  @override
  String get locationLabel => 'LOCALIZAÇÃO';

  @override
  String get actionNext12mLabel => 'AÇÃO NOS PRÓXIMOS 12 MESES';

  @override
  String get propertyWord => 'Propriedade';

  @override
  String get propertyYogasTitle => 'Yogas de Propriedade';

  @override
  String get drainsLabel => 'DRENOS';

  @override
  String get boostersLabel => 'IMPULSIONADORES';

  @override
  String get propertyTrendTitle => 'Tendência de Propriedade';

  @override
  String get buyingWindowsTitle => 'Janelas de Compra';

  @override
  String get constructionWindowsTitle => 'Janelas de Construção';

  @override
  String get maternalInherPctLabel => '% HERANÇA MATERNA';

  @override
  String get paternalInherPctLabel => '% HERANÇA PATERNA';

  @override
  String get multiHomePctLabel => '% MÚLTIPLOS IMÓVEIS';

  @override
  String get investmentPctLabel => '% INVESTIMENTO';

  @override
  String get vehicleProfileTitle => 'Perfil de Veículos';

  @override
  String get countLabel => 'QUANTIDADE';

  @override
  String get firstAgeLabel => 'PRIMEIRA IDADE';

  @override
  String get categoryLabel => 'CATEGORIA';

  @override
  String get luxuryLabel => 'LUXO';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'Total na vida: $count · Realização: $pct%';
  }

  @override
  String get pressureWord => 'PRESSÃO';

  @override
  String get protectionWord => 'PROTEÇÃO';

  @override
  String get astrologicalWord => 'Astrológico';

  @override
  String get keyRisksHeader1 => 'Principais';

  @override
  String get keyRisksHeader2 => 'Riscos';

  @override
  String get reportCopiedShort => 'Relatório copiado!';

  @override
  String get keyScoresLabel => 'PRINCIPAIS PONTUAÇÕES';

  @override
  String allScoresCountLabel(int count) {
    return 'Todas as Pontuações ($count)';
  }

  @override
  String get windowsWord => 'Janelas';

  @override
  String get genericFailedMsg => 'Falhou';

  @override
  String get unknownWord => 'Desconhecido';

  @override
  String selectKarmaChartsLabel(int max) {
    return 'Selecione de 2 a $max Mapas';
  }

  @override
  String selectChartsLabelCount(int max) {
    return 'Selecione $max Mapas';
  }

  @override
  String runningAnalysisLabel(String label) {
    return 'Executando análise de $label...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'Escolha de 2 a $max mapas para analisar ligações cármicas';
  }

  @override
  String get pickMaleFemaleHint => 'Escolha um mapa Masculino e um Feminino';

  @override
  String get personOneLabel => 'Pessoa 1';

  @override
  String get personTwoLabel => 'Pessoa 2';

  @override
  String get analysisFailedMsg => 'Falha na análise';

  @override
  String analyzeChartsCountLabel(int count) {
    return 'Analisar $count Mapas';
  }

  @override
  String get contextGeneralLabel => 'Geral';

  @override
  String get contextLoveLabel => 'Amor';

  @override
  String get contextBusinessLabel => 'Negócios';

  @override
  String get contextFamilyLabel => 'Família';

  @override
  String get contextTeamLabel => 'Equipe';

  @override
  String get contextFriendshipLabel => 'Amizade';

  @override
  String get relationshipIntelTitle => 'Inteligência de Relacionamento';

  @override
  String analyzingChartsCountLabel(int count) {
    return 'Analisando $count mapas...';
  }

  @override
  String get relationshipContextLabel => 'Contexto do Relacionamento';

  @override
  String get kundliMilanReportTitle => 'Relatório de Kundli Milan';

  @override
  String get runningMilanAnalysisLabel => 'Executando análise de Milan...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '$count/2 selecionados';
  }

  @override
  String get runMilanAnalysisBtn => 'Executar Análise de Milan';

  @override
  String get noChartsCreateFirst => 'Nenhum mapa. Crie um mapa natal primeiro.';

  @override
  String get selectBirthChartAnalyze => 'Selecione um mapa natal para analisar';

  @override
  String get doshAnalysis => 'Análise de Dosha';

  @override
  String doshActiveCount(Object active, Object total) {
    return '$active ativos / $total verificados';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '$active ativos / $total yogas verificados';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'YOGAS ATIVOS ($count)';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'Ocultar yogas inativos ($count)';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'Mostrar yogas inativos ($count)';
  }

  @override
  String get loadFailed => 'Falhou';

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
    return 'Senhor Natal: $lord • Saldo: $balance anos';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'Lagna: $lagna • Saldo: $balance anos';
  }

  @override
  String dashaYearsValue(Object years) {
    return '$years anos';
  }

  @override
  String get dashaCurrentPeriod => 'Período de Dasha Atual';

  @override
  String dashaAsOf(Object date) {
    return 'Em: $date';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'Yogas Ativos no Período Atual ($count)';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'Doshas Ativos no Período Atual ($count)';
  }

  @override
  String get dashaNoYogasTriggered => 'Nenhum yoga acionado';

  @override
  String get dashaNoDoshasTriggered => 'Nenhum dosha acionado';

  @override
  String get divD1Name => 'Rasi (D-1)';

  @override
  String get divD1Desc => 'Existência física, todos os assuntos';

  @override
  String get divD2Name => 'Hora (D-2)';

  @override
  String get divD2Desc => 'Riqueza, dinheiro';

  @override
  String get divD3Name => 'Drekkana (D-3)';

  @override
  String get divD3Desc => 'Irmãos, coragem';

  @override
  String get divD4Name => 'Chaturthamsa (D-4)';

  @override
  String get divD4Desc => 'Propriedade, residência, fortuna';

  @override
  String get divD5Name => 'Panchamsa (D-5)';

  @override
  String get divD5Desc => 'Fama, autoridade, poder';

  @override
  String get divD6Name => 'Shashthamsa (D-6)';

  @override
  String get divD6Desc => 'Problemas de saúde';

  @override
  String get divD7Name => 'Saptamsa (D-7)';

  @override
  String get divD7Desc => 'Filhos, netos';

  @override
  String get divD8Name => 'Ashtamsa (D-8)';

  @override
  String get divD8Desc => 'Problemas repentinos, litígios';

  @override
  String get divD9Name => 'Navamsha (D-9)';

  @override
  String get divD9Desc => 'Casamento, cônjuge, dharma';

  @override
  String get divD10Name => 'Dasamsha (D-10)';

  @override
  String get divD10Desc => 'Carreira, profissão';

  @override
  String get divD11Name => 'Rudramsha (D-11)';

  @override
  String get divD11Desc => 'Morte, destruição';

  @override
  String get divD12Name => 'Dwadasamsha (D-12)';

  @override
  String get divD12Desc => 'Pais, parentes consanguíneos';

  @override
  String get divD16Name => 'Shodasamsha (D-16)';

  @override
  String get divD16Desc => 'Veículos, confortos, prazeres';

  @override
  String get divD20Name => 'Vimsamsha (D-20)';

  @override
  String get divD20Desc => 'Assuntos espirituais, religiosos';

  @override
  String get divD24Name => 'Chaturvimsamsha (D-24)';

  @override
  String get divD24Desc => 'Aprendizado, conhecimento, educação';

  @override
  String get divD27Name => 'Nakshatramsha (D-27)';

  @override
  String get divD27Desc => 'Forças, fraquezas, natureza';

  @override
  String get divD30Name => 'Trimsamsha (D-30)';

  @override
  String get divD30Desc => 'Males, subconsciente, punição';

  @override
  String get divD40Name => 'Khavedamsha (D-40)';

  @override
  String get divD40Desc => 'Auspicioso/inauspicioso (materno)';

  @override
  String get divD45Name => 'Akshavedamsha (D-45)';

  @override
  String get divD45Desc => 'Todos os assuntos (paterno)';

  @override
  String get divD60Name => 'Shashtyamsha (D-60)';

  @override
  String get divD60Desc => 'Carma de vida passada — MAIS IMPORTANTE';

  @override
  String get lifeAreaCareer => 'Carreira';

  @override
  String get lifeAreaWealth => 'Riqueza';

  @override
  String get lifeAreaMarriage => 'Casamento';

  @override
  String get lifeAreaHealth => 'Saúde';

  @override
  String get lifeAreaSpirituality => 'Espiritualidade';

  @override
  String lifeAreaGrade(Object grade) {
    return 'Nota: $grade';
  }

  @override
  String get lifeAreaFactorsLabel => 'Fatores:';

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
  String get chakraOverallHealth => 'Saúde Geral';

  @override
  String get careerWord => 'Carreira';

  @override
  String get failedToLoad => 'Falha ao carregar';

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
    return 'Grau: $degree°  •  Nakshatra: $nakshatra ($pada)';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'Senhor do Nakshatra: $lord  •  Dignidade: $dignity';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return 'Mapa $base — $sign';
  }

  @override
  String kundliBaseChart(Object base) {
    return 'Mapa $base';
  }

  @override
  String get careerSummary => 'Resumo de Carreira';

  @override
  String get phase => 'Fase';

  @override
  String get confidenceLabel => 'Confiança';

  @override
  String get careerScores => 'Pontuações de Carreira';

  @override
  String get stabilityLabel => 'Estabilidade';

  @override
  String get growthLabel => 'Crescimento';

  @override
  String get gradeExcellent => 'Excelente';

  @override
  String get gradeGood => 'Bom';

  @override
  String get gradeAverage => 'Médio';

  @override
  String get gradeBelowAvg => 'Abaixo da Média';

  @override
  String get gradeWeak => 'Fraco';

  @override
  String get careerTypeDomain => 'Carreira e Domínio';

  @override
  String get careerTimeline => 'Linha do Tempo da Carreira';

  @override
  String dashaLabel(Object dasha) {
    return 'Dasha: $dasha';
  }

  @override
  String get improvementSuggestions => 'Sugestões de Melhoria';

  @override
  String get chartDetails => 'Detalhes do Mapa';

  @override
  String get keyHousesCareer => 'Casas Principais (Carreira)';

  @override
  String get keyCareerPlanets => 'Planetas Principais de Carreira';

  @override
  String get empty => 'Vazio';

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
  String get charGroupCorePersonality => 'Personalidade Central';

  @override
  String get charGroupTrustHonesty => 'Confiança e Honestidade';

  @override
  String get charGroupLoyaltyCommitment => 'Lealdade e Compromisso';

  @override
  String get charGroupStrategicPrivacy => 'Estratégia e Privacidade';

  @override
  String get charGroupFinancial => 'Financeiro';

  @override
  String get charGroupAngerConflict => 'Raiva e Conflito';

  @override
  String get charGroupMoralDharmic => 'Moral e Dhármico';

  @override
  String get charGroupIntellectCommunication => 'Intelecto e Comunicação';

  @override
  String get charGroupEmotionalProfile => 'Perfil Emocional';

  @override
  String get charGroupMentalHealth => 'Saúde Mental';

  @override
  String get charGroupRomantic => 'Romântico';

  @override
  String get charGroupMarriageFamily => 'Casamento e Família';

  @override
  String get charGroupOverallLife => 'Vida Geral';

  @override
  String get grahaDrishti => 'Graha Drishti (Aspectos Planetários)';

  @override
  String get grahaDrishtiSubtitle => 'Quem aspecta quem (%)';

  @override
  String get lagnaAspectsReceived => 'Aspectos Recebidos pela Lagna';

  @override
  String get rashiDrishti => 'Rashi Drishti (Aspectos de Signo)';

  @override
  String get shadbalaRupas => 'rupas';

  @override
  String get bhavaHouse1 => 'Eu / Corpo';

  @override
  String get bhavaHouse2 => 'Riqueza / Família';

  @override
  String get bhavaHouse3 => 'Irmãos / Coragem';

  @override
  String get bhavaHouse4 => 'Lar / Mãe';

  @override
  String get bhavaHouse5 => 'Filhos / Intelecto';

  @override
  String get bhavaHouse6 => 'Inimigos / Saúde';

  @override
  String get bhavaHouse7 => 'Casamento / Parceiro';

  @override
  String get bhavaHouse8 => 'Longevidade';

  @override
  String get bhavaHouse9 => 'Fortuna / Guru';

  @override
  String get bhavaHouse10 => 'Carreira / Pai';

  @override
  String get bhavaHouse11 => 'Ganhos / Amigos';

  @override
  String get bhavaHouse12 => 'Perda / Moksha';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '$sign • Senhor: $lord';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: $value';
  }

  @override
  String get sarvaAshtakavarga => 'Sarva Ashtakavarga (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'Total: $total rekhas (signo médio = $avg)';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '$planet — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'Total: $total rekhas • No signo natal: $score';
  }

  @override
  String get today => 'Hoje';

  @override
  String gocharTransitScores(Object date) {
    return 'Gochar (Pontuações de Trânsito) — $date';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'Lua Natal: $sign';
  }

  @override
  String get gocharBest => 'MELHOR';

  @override
  String get gocharWorst => 'PIOR';

  @override
  String copiedOpening(Object ai) {
    return 'Copiado! Abrindo $ai...';
  }

  @override
  String get openLink => 'ABRIR ↗';

  @override
  String get discussReportWithAI => 'DISCUTIR ESTE RELATÓRIO COM A IA';

  @override
  String get reliabilityHigh => 'Alta confiabilidade';

  @override
  String get reliabilityModerate => 'Confiabilidade moderada';

  @override
  String get reliabilityLow => 'Baixa — apenas orientativo';

  @override
  String get reliabilityGoodEdu => 'Boa confiabilidade · Verificado com D-24';

  @override
  String get relationshipWord => 'Relacionamento';

  @override
  String get intelligenceWord => 'Inteligência';

  @override
  String get relationshipIntelligence => 'INTELIGÊNCIA DE RELACIONAMENTO';

  @override
  String get typeLabel => 'TIPO';

  @override
  String get trustLabel => 'CONFIANÇA';

  @override
  String get dhokaRisk => 'RISCO DE TRAIÇÃO';

  @override
  String get powerLabel => 'Poder';

  @override
  String get integrity => 'Integridade';

  @override
  String get warmth => 'Calor Humano';

  @override
  String get trustWord => 'Confiança';

  @override
  String get assertLabel => 'Assertividade';

  @override
  String get character => 'Caráter';

  @override
  String get love => 'Amor';

  @override
  String get businessWord => 'Negócios';

  @override
  String get karmic => 'Cármico';

  @override
  String get enmityRisk => 'Risco de Inimizade';

  @override
  String get hdrChartProfiles => 'Perfis dos Mapas';

  @override
  String get hdrPairwiseAnalysis => 'Análise entre Pares';

  @override
  String get hdrCriticalPatterns => 'Padrões Críticos';

  @override
  String get hdrGroupRecommendations => 'Recomendações para o Grupo';

  @override
  String get sharedPractices => 'PRÁTICAS COMPARTILHADAS';

  @override
  String get hdrIndividualGuidance => 'Orientação Individual';

  @override
  String get growthAreas => 'ÁREAS DE CRESCIMENTO';

  @override
  String get hdrCoreTheme => 'Tema Central';

  @override
  String get growthOriented => 'ORIENTADO AO CRESCIMENTO';

  @override
  String get groupTheme => 'TEMA DO GRUPO';

  @override
  String get compatibility => 'COMPATIBILIDADE';

  @override
  String get unifiedScoreLabel => 'PONTUAÇÃO UNIFICADA';

  @override
  String get ashtakoot => 'ASHTAKOOT';

  @override
  String get probability => 'PROBABILIDADE';

  @override
  String get hdrAshtakootSummary => 'Resumo do Ashtakoot';

  @override
  String get hdrGunBreakdown => 'Detalhamento dos 8 Gunas';

  @override
  String get hdrMangalDosh => 'Mangal Dosh';

  @override
  String get hdrD9CrossChart => 'Cruzamento de Mapas D-9';

  @override
  String get d9Compatibility => 'COMPATIBILIDADE D-9';

  @override
  String get hdrDomainCompatibility => 'Compatibilidade por Domínio';

  @override
  String get emotional => 'Emocional';

  @override
  String get intellectual => 'Intelectual';

  @override
  String get spiritual => 'Espiritual';

  @override
  String get financial => 'Financeiro';

  @override
  String get domestic => 'Doméstico';

  @override
  String get communicationWord => 'Comunicação';

  @override
  String get sharedDharma => 'Dharma Compartilhado';

  @override
  String get familyCreation => 'Criação de Família';

  @override
  String get hdrMarriageTiming => 'Timing do Casamento';

  @override
  String get jointMarriageWindows => 'Janelas Conjuntas de Casamento';

  @override
  String get engagementWindows => 'Janelas de Noivado';

  @override
  String get recommendedLabel => 'Recomendado';

  @override
  String get hdrKeyRisks => 'Principais Riscos';

  @override
  String get hdrFinalVerdict => 'Veredito Final';

  @override
  String get marriageVerdict => 'VEREDITO DE CASAMENTO';

  @override
  String get educationWord => 'Educação';

  @override
  String get learningSuffix => 'e Aprendizado';

  @override
  String get coreEducationScores => 'PONTUAÇÕES PRINCIPAIS DE EDUCAÇÃO';

  @override
  String get academicSuccess => 'SUCESSO ACADÊMICO';

  @override
  String get learningCapacity => 'CAPACIDADE DE APRENDIZADO';

  @override
  String get memory => 'MEMÓRIA';

  @override
  String get intelligence => 'INTELIGÊNCIA';

  @override
  String get research => 'PESQUISA';

  @override
  String get hdrIntellectualProfile => 'Perfil Intelectual';

  @override
  String get learningSignature => 'ASSINATURA DE APRENDIZADO';

  @override
  String get hdrSubjectKaraka => 'Karaka da Matéria';

  @override
  String get hdrHouseFoundations => 'Fundações das Casas';

  @override
  String get hdrMercuryJupiter => 'Mercúrio e Júpiter';

  @override
  String get hdrEducationYogas => 'Yogas Educacionais';

  @override
  String get hdrDivisionalValidation => 'Validação Divisional';

  @override
  String get standing => 'POSIÇÃO';

  @override
  String get hdrSubjectRanking => 'Classificação de Matérias';

  @override
  String get hdrDegreeLikelihood => 'Probabilidade de Grau';

  @override
  String get hdrStudyPeriods => 'Períodos de Estudo';

  @override
  String get earlySchooling => 'Educação Inicial';

  @override
  String get higherEducation => 'Ensino Superior';

  @override
  String get postgradResearch => 'Pós-Graduação · Pesquisa';

  @override
  String get hdrLearningPreferences => 'Preferências de Aprendizado';

  @override
  String get hdrChallengesGifts => 'Desafios e Dons';

  @override
  String get challenges => 'DESAFIOS';

  @override
  String get cognitiveGifts => 'DONS COGNITIVOS';

  @override
  String get naturalAbilities => 'HABILIDADES NATURAIS';

  @override
  String get hdrSaraswatiRemedies => 'Remédios de Saraswati';

  @override
  String get studentVerdict => 'VEREDITO DO ESTUDANTE';

  @override
  String get educationCareerLinkage => 'LIGAÇÃO EDUCAÇÃO → CARREIRA';

  @override
  String get startupSuffix => 'e Startups';

  @override
  String get coreBusinessScores => 'PONTUAÇÕES PRINCIPAIS DE NEGÓCIOS';

  @override
  String get overallBusiness => 'NEGÓCIO GERAL';

  @override
  String get ventureSuccess => 'SUCESSO DO EMPREENDIMENTO';

  @override
  String get eleventhHouse => 'CASA 11';

  @override
  String get gains => 'GANHOS';

  @override
  String get investor => 'INVESTIDOR';

  @override
  String get hdrFounderArchetype => 'Arquétipo de Fundador';

  @override
  String get hdrTenthEleventhHouses => 'Casas 10 e 11';

  @override
  String get hdrBusinessYogas => 'Yogas de Negócios';

  @override
  String get hdrRecommendedDomains => 'Domínios Recomendados';

  @override
  String get hdrBusinessStyle => 'Estilo de Negócio';

  @override
  String get hdrFounderSkills => 'Habilidades de Fundador';

  @override
  String get hdrFundingProfile => 'Perfil de Financiamento';

  @override
  String get recommendedPath => 'CAMINHO RECOMENDADO';

  @override
  String get investorAttract => 'ATRAÇÃO DE INVESTIDORES';

  @override
  String get familyBacking => 'APOIO FAMILIAR';

  @override
  String get hybridViability => 'VIABILIDADE HÍBRIDA';

  @override
  String get launchWindow => 'Janela de Lançamento';

  @override
  String get scaleWindow => 'Janela de Expansão';

  @override
  String get hdrBusinessRisks => 'Riscos do Negócio';

  @override
  String get recoveryCapacity => 'CAPACIDADE DE RECUPERAÇÃO';

  @override
  String get hdrRemediesSolutions => 'Remédios e Soluções';

  @override
  String get aiConnectionLost => 'Conexão perdida. Tente novamente.';

  @override
  String get aiSomethingWrong => 'Algo deu errado';

  @override
  String get aiNoResponse => 'Sem resposta';

  @override
  String get aiConnectionError => 'Erro de conexão. Tente novamente.';

  @override
  String get aiAutoDetect => 'Detecção automática';

  @override
  String aiAutoArrow(String lang) {
    return 'Automático → $lang';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'Idioma: $lang';
  }

  @override
  String get aiNoBirthCharts => 'Nenhum mapa natal encontrado';

  @override
  String get aiCreateChartFirst =>
      'Crie um mapa natal primeiro para conversar com a IA';

  @override
  String get aiSelectChartBegin =>
      'Selecione um mapa natal para começar a análise';

  @override
  String aiAnalyzingName(String name) {
    return 'Analisando: $name';
  }

  @override
  String get aiChange => 'Trocar';

  @override
  String get aiAnalyzingChart => 'Analisando seu mapa...';

  @override
  String get aiAskStarsHint => 'Pergunte qualquer coisa às estrelas...';

  @override
  String get aiSuggestedFollowups => 'Perguntas sugeridas';

  @override
  String get aiThinking => 'Pensando...';

  @override
  String get aiThanks => 'Obrigado!';

  @override
  String get aiFeedbackNoted => 'Feedback registrado';

  @override
  String get svcAll => 'Todos';

  @override
  String get svcNoServices => 'Nenhum serviço disponível';

  @override
  String get svcFree => 'GRÁTIS';

  @override
  String get astroFailedStartCall => 'Falha ao iniciar a chamada';

  @override
  String get astroFailedStartChat => 'Falha ao iniciar o chat';

  @override
  String astroErrorDetail(String error) {
    return 'Erro: $error';
  }

  @override
  String get astroExperience => 'Experiência';

  @override
  String get astroSessions => 'Sessões';

  @override
  String get astroMinutes => 'Minutos';

  @override
  String get astroAbout => 'Sobre';

  @override
  String get astroLanguages => 'Idiomas';

  @override
  String get astroRateCard => 'Tabela de Preços';

  @override
  String get astroVoice => 'Voz';

  @override
  String astroReviews(int count) {
    return 'Avaliações ($count)';
  }

  @override
  String get astroNoReviews => 'Ainda sem avaliações';

  @override
  String get astroAnonymous => 'Anônimo';

  @override
  String get forgotPasswordSubtitle =>
      'Digite seu e-mail e enviaremos\num link para redefinir sua senha.';

  @override
  String get emailHint => 'seu@email.com';

  @override
  String get resendLink => 'Reenviar Link';

  @override
  String get appName => 'Nakshatralogy';

  @override
  String get cosmicJourneyAwaits => 'Sua Jornada Cósmica Está à Espera';

  @override
  String get home => 'Início';

  @override
  String get astrologers => 'Astrólogos';

  @override
  String get services => 'Serviços';

  @override
  String get wallet => 'Carteira';

  @override
  String get profile => 'Perfil';

  @override
  String get live => 'Ao Vivo';

  @override
  String get kundli => 'Kundli';

  @override
  String get chat => 'Chat';

  @override
  String get call => 'Ligação';

  @override
  String get video => 'Vídeo';

  @override
  String get signIn => 'Entrar';

  @override
  String get createAccount => 'Criar Conta';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get confirmPassword => 'Confirmar Senha';

  @override
  String get fullName => 'Nome Completo';

  @override
  String get phone => 'Telefone';

  @override
  String get forgotPassword => 'Esqueceu a Senha?';

  @override
  String get sendResetLink => 'Enviar Link de Redefinição';

  @override
  String get backToSignIn => 'Voltar para Entrar';

  @override
  String get dontHaveAccount => 'Não tem uma conta?';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta?';

  @override
  String get continueGoogle => 'Continuar com o Google';

  @override
  String get required => 'Obrigatório';

  @override
  String get minSixChars => 'Mínimo de 6 caracteres';

  @override
  String get passwordsMismatch => 'As senhas não coincidem';

  @override
  String get validEmailRequired => 'E-mail válido é obrigatório';

  @override
  String get loginFailed => 'Falha no login';

  @override
  String get signupFailed => 'Falha no cadastro';

  @override
  String get welcomeBack => 'Bem-vindo de volta';

  @override
  String get todaysHoroscope => 'HORÓSCOPO DE HOJE';

  @override
  String get todaysRashi => 'Rashi de Hoje';

  @override
  String get tapDetails => 'Toque para detalhes';

  @override
  String get allServices => 'Todos os Serviços';

  @override
  String get seeAll => 'VER TODOS';

  @override
  String get topAstrologers => 'Melhores Astrólogos';

  @override
  String get onlineExperts => 'Especialistas online prontos para consulta';

  @override
  String get searchAstrologers => 'Buscar astrólogos...';

  @override
  String get noAstrologersFound => 'Nenhum astrólogo encontrado';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get busy => 'Ocupado';

  @override
  String get perMin => '/min';

  @override
  String get noCharts => 'Ainda não há mapas natais';

  @override
  String get createFirst => 'Crie seu primeiro Janam Kundli';

  @override
  String get createChart => 'Criar Mapa';

  @override
  String get newBirthChart => 'Novo Mapa Natal';

  @override
  String get clientName => 'Nome do Cliente';

  @override
  String get gender => 'Gênero';

  @override
  String get male => 'Masculino';

  @override
  String get female => 'Feminino';

  @override
  String get other => 'Outro';

  @override
  String get dateOfBirth => 'Data de Nascimento';

  @override
  String get timeOfBirth => 'Hora de Nascimento';

  @override
  String get birthPlace => 'Local de Nascimento';

  @override
  String get birthPlaceHint => 'Digite o nome da cidade para buscar...';

  @override
  String get generateKundli => 'Gerar Kundli';

  @override
  String get birthChartCreated => 'Mapa natal criado!';

  @override
  String get deleteChart => 'Excluir Mapa?';

  @override
  String get cannotUndo => 'Isso não pode ser desfeito.';

  @override
  String get primary => 'PRINCIPAL';

  @override
  String get viewKundli => 'Ver Kundli';

  @override
  String get completeBirthChart => 'Mapa Natal Completo';

  @override
  String get birthDetails => 'Detalhes de Nascimento';

  @override
  String get name => 'Nome';

  @override
  String get dob => 'Data Nasc.';

  @override
  String get tob => 'Hora Nasc.';

  @override
  String get place => 'Local';

  @override
  String get summary => 'Resumo';

  @override
  String get planets => 'Planetas';

  @override
  String get divisions => 'Divisões';

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
  String get lifeAreas => 'Áreas da Vida';

  @override
  String get bhava => 'Bhava';

  @override
  String get chakras => 'Chakras';

  @override
  String get dashaActive => 'Dasha Ativa';

  @override
  String get lagna => 'Lagna';

  @override
  String get moon => 'Lua';

  @override
  String get sun => 'Sol';

  @override
  String get premiumSection => 'Seção Premium';

  @override
  String get unlockReading =>
      'Desbloqueie esta leitura para ver a análise detalhada.';

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
  String get addBalance => 'Adicionar Saldo';

  @override
  String get amount => 'Valor';

  @override
  String get walletBalance => 'Saldo da Carteira';

  @override
  String get recharge => 'Recarregar';

  @override
  String get bonus => 'Bônus';

  @override
  String get serviceLabel => 'Serviço';

  @override
  String get refund => 'Reembolso';

  @override
  String get noTransactions => 'Nenhuma transação';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get savedAstrologers => 'Astrólogos Salvos';

  @override
  String get noSavedAstrologers => 'Ainda não há astrólogos salvos';

  @override
  String get myOrders => 'Meus Pedidos';

  @override
  String get communicationHistory => 'Histórico de Comunicação';

  @override
  String get chatHistory => 'Histórico de Chat';

  @override
  String get callHistory => 'Histórico de Chamadas';

  @override
  String get logout => 'Sair';

  @override
  String get chatMessages => 'Mensagens do Chat';

  @override
  String get typeMessage => 'Digite uma mensagem...';

  @override
  String get sessionEnded => 'Sessão Encerrada';

  @override
  String get endChat => 'Encerrar Chat?';

  @override
  String get endChatConfirm =>
      'Tem certeza de que deseja encerrar esta sessão de chat?';

  @override
  String get sendPhoto => 'Enviar Foto';

  @override
  String get sendPDF => 'Enviar PDF';

  @override
  String get upload => 'Enviar';

  @override
  String get fileNotFound => 'Arquivo não encontrado';

  @override
  String get voiceCall => 'Chamada de Voz';

  @override
  String get videoCall => 'Chamada de Vídeo';

  @override
  String get ringing => 'Chamando...';

  @override
  String get connected => 'CONECTADO';

  @override
  String get endCall => 'Encerrar Chamada';

  @override
  String get mute => 'Silenciar';

  @override
  String get unmute => 'Ativar Som';

  @override
  String get speaker => 'Alto-falante';

  @override
  String get camera => 'Câmera';

  @override
  String get flip => 'Inverter';

  @override
  String get liveStreams => 'Transmissões ao Vivo';

  @override
  String get noLiveStreams => 'Nenhuma transmissão ao vivo no momento';

  @override
  String get astrologerUnavailable =>
      'Astrólogo indisponível. Encerrando transmissão.';

  @override
  String get streamEnded => 'Transmissão encerrada';

  @override
  String get superChat => 'Super Chat';

  @override
  String get sendGift => 'Enviar um Presente';

  @override
  String get goBack => 'Voltar';

  @override
  String get appPermissions => 'Permissões do Aplicativo';

  @override
  String get grantPermissions => 'Conceder Permissões';

  @override
  String get skipForNow => 'Pular por agora';

  @override
  String get microphone => 'Microfone';

  @override
  String get notifications => 'Notificações';

  @override
  String get storage => 'Armazenamento';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get retry => 'Tentar Novamente';

  @override
  String get send => 'Enviar';

  @override
  String get refresh => 'Atualizar';

  @override
  String get loading => 'Carregando...';

  @override
  String get noData => 'Nenhum dado disponível';

  @override
  String get error => 'Erro';

  @override
  String get success => 'Sucesso';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglês';

  @override
  String get myDetails => 'Meus Dados';

  @override
  String get myKundlis => 'Meus Kundlis';

  @override
  String get walletRecharge => 'Carteira e Recarga';

  @override
  String get consultationHistory => 'Histórico de Consultas';

  @override
  String get helpSupport => 'Ajuda e Suporte';

  @override
  String get biometricLogin => 'Login Biométrico';

  @override
  String get pastVoiceConsultations => 'Consultas de voz anteriores';

  @override
  String get pastTextConversations => 'Conversas de texto anteriores';

  @override
  String get comingSoon => 'Em breve';

  @override
  String get totalCredit => 'Crédito Total';

  @override
  String get totalDebit => 'Débito Total';

  @override
  String get statement => 'Extrato';

  @override
  String get allTypes => 'Todos os tipos';

  @override
  String get prev => 'Anterior';

  @override
  String get next => 'Próximo';

  @override
  String get allInsights => 'Todos os Insights';

  @override
  String get yourCompleteReading => 'SUA LEITURA COMPLETA';

  @override
  String get expertEngines => 'motores especialistas';

  @override
  String get eachInsightConsultation => 'Cada insight é uma consulta completa';

  @override
  String get engines => 'MOTORES';

  @override
  String get dataPoints => 'PONTOS DE DADOS';

  @override
  String get singleChart => 'ÚNICO';

  @override
  String get careerPurpose => 'CARREIRA E PROPÓSITO';

  @override
  String get wealthAssets => 'RIQUEZA E BENS';

  @override
  String get loveRelationships => 'AMOR E RELACIONAMENTOS';

  @override
  String get healthWellness => 'SAÚDE E BEM-ESTAR';

  @override
  String get soulKarma => 'ALMA E CARMA';

  @override
  String get specialistReports => 'Relatórios Especializados';

  @override
  String get searchByNameSpeciality => 'Buscar por nome, especialidade...';

  @override
  String get sortedByRating => 'Ordenado por avaliação';

  @override
  String get initiatingChat => 'Iniciando chat...';

  @override
  String get startingCall => 'Iniciando chamada...';

  @override
  String get yrs => 'anos';

  @override
  String get chatWithAISpecialist => 'Converse com o Especialista IA';

  @override
  String get tapToStart => 'Toque para começar';

  @override
  String get astrologer => 'Astrólogo';

  @override
  String get reports => 'Relatórios';

  @override
  String get milan => 'Milan';

  @override
  String get forecast => 'Previsão';

  @override
  String get rashi => 'Rashi';

  @override
  String get jupiterFavorsBold => 'Júpiter favorece movimentos ousados';

  @override
  String get careerIlluminated =>
      'Seu setor de carreira está iluminado — confie em seus instintos.';

  @override
  String get todaysForecast => 'Previsão de Hoje';

  @override
  String get engCareer => 'Carreira e Emprego';

  @override
  String get engBusiness => 'Negócios e Startups';

  @override
  String get engEducation => 'Educação e Aprendizado';

  @override
  String get engLifePath => 'Caminho de Vida e Sorte';

  @override
  String get engWealth => 'Riqueza e Finanças';

  @override
  String get engDebt => 'Dívidas e Recuperação';

  @override
  String get engProperty => 'Propriedades e Bens';

  @override
  String get engLegal => 'Questões Legais e Disputas';

  @override
  String get engLove => 'Amor e Romance';

  @override
  String get engMarriage => 'Casamento e Família';

  @override
  String get engKundliMilan => 'Kundli Milan';

  @override
  String get engRelationship => 'Inteligência de Relacionamento';

  @override
  String get engLoveCompat => 'Compatibilidade Amorosa';

  @override
  String get engChildProb => 'Probabilidade de Filhos';

  @override
  String get engHealth => 'Saúde e Bem-Estar';

  @override
  String get engMental => 'Mental e Estresse';

  @override
  String get engCharacter => 'Análise de Caráter';

  @override
  String get engPastLife => 'Vidas Passadas e Carma';

  @override
  String get engKarmaLink => 'Ligação Cármica';

  @override
  String get noChatSessions => 'Ainda Não Há Sessões de Chat';

  @override
  String get chatAppearHere => 'Suas conversas com astrólogos aparecerão aqui.';

  @override
  String get noCallsYet => 'Ainda Não Há Chamadas';

  @override
  String get callAppearHere =>
      'Seu histórico de chamadas com astrólogos aparecerá aqui.';

  @override
  String get chatWith => 'Conversar com';

  @override
  String get msgs => 'mensagens';

  @override
  String get voiceCallLabel => 'Chamada de voz';

  @override
  String get videoCallLabel => 'Chamada de vídeo';

  @override
  String get pullToRefresh => 'Puxe para baixo para atualizar';

  @override
  String get sessionExpired => 'Sessão expirada';

  @override
  String get connectionFailed => 'Falha na conexão';

  @override
  String get callActive => 'Chamada ativa';

  @override
  String get lessThanOneMin => 'Menos de 1 minuto restante';

  @override
  String get noMessages => 'Nenhuma mensagem nesta sessão';

  @override
  String get gocharForAllSigns => 'Gochar de hoje para todos os 12 signos';

  @override
  String get selectChart => 'Selecione um mapa para analisar';

  @override
  String get selectTwoCharts => 'Selecione dois mapas';

  @override
  String get analyzing => 'Analisando...';

  @override
  String get browseAstrologers => 'Explorar Astrólogos';

  @override
  String get probableNumber => 'NÚMERO PROVÁVEL';

  @override
  String get genderTendency => 'TENDÊNCIA DE GÊNERO';

  @override
  String get son => 'FILHO';

  @override
  String get daughter => 'FILHA';

  @override
  String get occupants => 'OCUPANTES';

  @override
  String get beneficAspects => 'ASPECTOS BENÉFICOS';

  @override
  String get maleficAspects => 'ASPECTOS MALÉFICOS';

  @override
  String get nextFavorableWindow => 'PRÓXIMA JANELA FAVORÁVEL';

  @override
  String get totalDoshaPenalty => 'PENALIDADE TOTAL DE DOSHA';

  @override
  String get cancellationFactors => 'FATORES DE CANCELAMENTO';

  @override
  String get combinedFertility => 'INDICAÇÃO DE FERTILIDADE COMBINADA';

  @override
  String get planetPositions => 'POSIÇÕES PLANETÁRIAS';

  @override
  String get bestWindows => 'MELHORES JANELAS';

  @override
  String get worstWindows => 'PIORES JANELAS';

  @override
  String get scoreComponents => 'COMPONENTES DA PONTUAÇÃO';

  @override
  String get topOpportunities => 'PRINCIPAIS OPORTUNIDADES';

  @override
  String get topRisks => 'PRINCIPAIS RISCOS';

  @override
  String get remedies => 'REMÉDIOS';

  @override
  String get keyInsights => 'PRINCIPAIS INSIGHTS';

  @override
  String get overallVerdict => 'VEREDITO GERAL';

  @override
  String get venusContacts => 'CONTATOS CRUZADOS DE VÊNUS';

  @override
  String get contact => 'Contato';

  @override
  String get effect => 'Efeito';

  @override
  String get moonSignCompat => 'COMPATIBILIDADE DE SIGNO LUNAR';

  @override
  String get hisMoon => 'LUA DELE';

  @override
  String get herMoon => 'LUA DELA';

  @override
  String get nakshatraCompat => 'COMPATIBILIDADE DE NAKSHATRA';

  @override
  String get ketuContacts => 'CONTATOS DE KETU';

  @override
  String get rahuContacts => 'CONTATOS DE RAHU';

  @override
  String get pastLifeIndication => 'INDICAÇÃO DE VIDA PASSADA';

  @override
  String get totalChallengePenalty => 'PENALIDADE TOTAL DE DESAFIOS';

  @override
  String get manifestation => 'MANIFESTAÇÃO';

  @override
  String get cancellation => 'CANCELAMENTO';

  @override
  String get navigation => 'NAVEGAÇÃO';

  @override
  String get potentialStrengths => 'POTENCIAIS PONTOS FORTES';

  @override
  String get areasToNurture => 'ÁREAS A CULTIVAR';

  @override
  String get relationshipGuidance => 'ORIENTAÇÃO DE RELACIONAMENTO';

  @override
  String get detailedSummary => 'RESUMO DETALHADO';

  @override
  String get discussWithAI => 'DISCUTIR COM A IA';

  @override
  String get planet => 'Planeta';

  @override
  String get sign => 'Signo';

  @override
  String get house => 'Casa';

  @override
  String get strength => 'Força';

  @override
  String get copy => 'COPIAR';

  @override
  String get confidence => 'CONFIANÇA';

  @override
  String get d7Saptamsa => 'D7 SAPTAMSA';

  @override
  String get numberExplanation => 'EXPLICAÇÃO DO NÚMERO';

  @override
  String get genderExplanation => 'EXPLICAÇÃO DO GÊNERO';

  @override
  String get inFifth => 'Na Casa 5?';

  @override
  String get primaryArchetype => 'ARQUÉTIPO PRIMÁRIO';

  @override
  String get mitigation => 'MITIGAÇÃO';

  @override
  String get soulCareerAlign => 'Alinhamento Alma ↔ Carreira';

  @override
  String get favorablePeriods => 'Períodos Favoráveis';

  @override
  String get challengingPeriods => 'Períodos Desafiadores';

  @override
  String get keyHouses => 'Casas Principais';

  @override
  String get keyPlanets => 'Planetas Principais';

  @override
  String get characterOverview => 'Visão Geral de Caráter';

  @override
  String get noYogasActive => 'Nenhum yoga ativo atualmente neste mapa.';

  @override
  String get basedOnPlanetStrengths =>
      'Com base nas forças planetárias e posicionamentos nas casas';

  @override
  String get basedOnTransits => 'Com base nos trânsitos planetários atuais';

  @override
  String get currentPlanetPositions =>
      'Posições planetárias atuais com seu signo como Casa 1';

  @override
  String get favorablePeriodAdvice =>
      'Período favorável — concentre-se no crescimento profissional e nos relacionamentos.';

  @override
  String get noClassicalYogas =>
      'Sem yogas educacionais clássicos, o sucesso vem do esforço constante.';

  @override
  String get walletDeduction => 'O valor será deduzido da sua carteira';

  @override
  String get bhakootAxis => 'EIXO BHAKOOT';

  @override
  String get basis => 'BASE';

  @override
  String get selectChartsForMilan =>
      'Selecione 2 Mapas para a Análise de Milan';

  @override
  String get selectMultiCharts => 'Selecione de 2 a 5 Mapas';

  @override
  String get running => 'EM ANDAMENTO';

  @override
  String get past => 'passado';

  @override
  String get topActiveDoshas => 'PRINCIPAIS DOSHAS ATIVOS';

  @override
  String get allDoshas => 'TODOS OS DOSHAS';

  @override
  String get activeYogas => 'Yogas Ativos';

  @override
  String get activeDoshas => 'Doshas Ativos';

  @override
  String get yogaAnalysis => 'Análise de Yoga';

  @override
  String get factors => 'Fatores';

  @override
  String get dominantPlanet => 'Planeta Dominante';

  @override
  String get startSession => 'Iniciar Sessão';

  @override
  String get notesSaved => 'Notas salvas';

  @override
  String get unlocked => 'Desbloqueado! Aproveite sua leitura.';

  @override
  String get todaysGochar => 'Gochar de Hoje';

  @override
  String get todaysTransitChart => 'Mapa de Trânsito de Hoje';

  @override
  String get lifeAreaPredictions => 'Previsões por Área da Vida';

  @override
  String get strengths => 'Pontos Fortes';

  @override
  String get weaknesses => 'Pontos Fracos';

  @override
  String get ruledBy => 'Regido por';

  @override
  String get kundliMilan => 'Kundli Milan';

  @override
  String get startKundliMilan => 'Iniciar Kundli Milan';

  @override
  String get recommendations => 'Recomendações';

  @override
  String get cancellations => 'Cancelamentos';

  @override
  String get dashaSync => 'Sincronia de Dasha';

  @override
  String get transitMarriageWindows => 'Janelas de Casamento por Trânsito';

  @override
  String get overlappingWindows => 'Janelas de Casamento Sobrepostas';

  @override
  String get overallStrength => 'FORÇA GERAL';

  @override
  String get stability => 'ESTABILIDADE';

  @override
  String get growth => 'CRESCIMENTO';

  @override
  String get clarity => 'CLAREZA';

  @override
  String get recognition => 'RECONHECIMENTO';

  @override
  String get satisfaction => 'SATISFAÇÃO';

  @override
  String get verdict => 'VEREDITO';

  @override
  String get topRoles => 'PRINCIPAIS FUNÇÕES';

  @override
  String get areasForGrowth => 'ÁREAS DE CRESCIMENTO';

  @override
  String get bestIndustries => 'MELHORES SETORES';

  @override
  String get employment => 'Emprego';

  @override
  String get entrepreneurship => 'Empreendedorismo';

  @override
  String get freelance => 'Freelancer';

  @override
  String get portfolio => 'Portfólio';

  @override
  String get burnoutRisk => 'Risco de Esgotamento';

  @override
  String get careerStagnation => 'Estagnação na Carreira';

  @override
  String get workplaceConflict => 'Conflito no Trabalho';

  @override
  String get positioning => 'POSICIONAMENTO';

  @override
  String get skillDevelopment => 'DESENVOLVIMENTO DE HABILIDADES';

  @override
  String get network => 'REDE DE CONTATOS';

  @override
  String get visibility => 'VISIBILIDADE';

  @override
  String get lagnaLord => 'Senhor da Lagna';

  @override
  String get tenthLord => 'Senhor da Casa 10';

  @override
  String get lord => 'SENHOR';

  @override
  String get lordPlacedIn => 'SENHOR POSICIONADO EM';

  @override
  String get lordDignity => 'DIGNIDADE DO SENHOR';

  @override
  String get d9Dignity => 'DIGNIDADE NO D9';

  @override
  String get careerAnalysis => 'Análise de Carreira';

  @override
  String get launchWindows => 'Janelas de Lançamento';

  @override
  String get peakWindows => 'Janelas de Pico';

  @override
  String get promotionWindows => 'Janelas de Promoção';

  @override
  String get riskWindows => 'Janelas de Risco';

  @override
  String get timingWindows => 'Janelas de Timing';

  @override
  String get careerRisks => 'Riscos de Carreira';

  @override
  String get astrologicalRemedies => 'Remédios Astrológicos';

  @override
  String get practicalSolutions => 'Soluções Práticas';

  @override
  String get analysisConfidence => 'Confiança da Análise';

  @override
  String get careerArchetype => 'Arquétipo de Carreira';

  @override
  String get workStructure => 'Estrutura de Trabalho';

  @override
  String get teamLeadership => 'Liderança de Equipe';

  @override
  String get idealEnvironment => 'Ambiente Ideal';

  @override
  String get idealOrgSize => 'Tamanho Ideal da Organização';

  @override
  String get fitScore => 'PONTUAÇÃO DE COMPATIBILIDADE';

  @override
  String get recommended => 'RECOMENDADO';

  @override
  String get divisionalValidation => 'Validação Divisional';

  @override
  String get houseAnalysis => 'Análise de Casas';

  @override
  String get jaiminiKarakas => 'Karakas de Jaimini';

  @override
  String get copyFullReport => 'Copiar dados completos do relatório';

  @override
  String get reportCopied => 'Dados do relatório copiados!';

  @override
  String get biometricNotAvailable =>
      'Biometria não disponível neste dispositivo';

  @override
  String biometricErrorMsg(Object error) {
    return 'Erro de biometria: $error';
  }

  @override
  String get biometricVerifyReason =>
      'Verifique para ativar o login biométrico';

  @override
  String get dobFormatLabel => 'Data de Nascimento (DD/MM/YYYY)';

  @override
  String get tobFormatLabel => 'Hora de Nascimento (HH:MM)';

  @override
  String get phoneLabel => 'Telefone';

  @override
  String get activeBadge => 'ATIVO';

  @override
  String get chartCategoryLabel => 'Categoria';

  @override
  String get freePrimaryDescription =>
      'Principal Gratuito — usado para o horóscopo diário e serviços de mapa único gratuitos';

  @override
  String get searchChartsHint => 'Pesquisar por nome ou data de nascimento...';

  @override
  String unlockPriceLabel(Object price) {
    return 'Desbloquear por $price';
  }

  @override
  String unlockAiSpecialistIntl(Object price) {
    return 'Desbloqueie este especialista de IA por $price (uma vez), comprado com segurança através da loja de aplicativos.';
  }

  @override
  String unlockAiSpecialistWallet(Object price) {
    return 'Desbloqueie este especialista de IA por $price (uma vez). O valor será deduzido da sua carteira.';
  }

  @override
  String get specialistNotAvailablePurchase =>
      'Este especialista ainda não está disponível para compra.';

  @override
  String get couldNotCompletePurchase =>
      'Não foi possível concluir a compra. Tente novamente.';

  @override
  String get couldNotUnlockWalletBalance =>
      'Não foi possível desbloquear (verifique o saldo da carteira)';

  @override
  String get freeBadge => 'GRÁTIS';

  @override
  String activeSessionInProgress(Object kind) {
    return 'Você tem um(a) $kind ativo em andamento';
  }

  @override
  String get returnLabel => 'Voltar';

  @override
  String get enableNotificationsForAlerts =>
      'Ative as notificações para receber alertas de consultas e ofertas';

  @override
  String get enableLabel => 'Ativar';

  @override
  String get notificationsEnabled => 'Notificações ativadas';

  @override
  String get couldNotEnableNotifications =>
      'Não foi possível ativar — permita notificações no seu navegador';

  @override
  String get amountInrLabel => 'Valor (₹)';

  @override
  String get noteOptionalLabel => 'Nota (opcional)';

  @override
  String get txnDate => 'DATA';

  @override
  String get txnDescription => 'DESCRIÇÃO';

  @override
  String get txnType => 'TIPO';

  @override
  String get txnAmount => 'VALOR';

  @override
  String get txnBalance => 'SALDO';

  @override
  String get credit => 'Crédito';

  @override
  String get debit => 'Débito';

  @override
  String get razorpayStripeNote =>
      '💳 Em produção, isso redirecionará para Razorpay/Stripe.';

  @override
  String get downloadPdf => 'Baixar PDF';

  @override
  String get chatWithAiCta => 'Conversar com a IA';

  @override
  String get pdfServiceUnavailable =>
      'O serviço de PDF está temporariamente indisponível. Tente novamente mais tarde.';

  @override
  String get pleaseUnlockFirst => 'Por favor, desbloqueie isto primeiro.';

  @override
  String get couldNotGeneratePdf =>
      'Não foi possível gerar o PDF. Tente novamente.';

  @override
  String get statConsults => 'CONSULTAS';

  @override
  String get statCharts => 'MAPAS';

  @override
  String get statWallet => 'CARTEIRA';

  @override
  String get firstChartPrimaryInfo =>
      'Seu primeiro mapa é o seu Principal gratuito. Mapas extras desbloqueiam serviços individualmente.';

  @override
  String get tryDifferentFilter => 'Tente um filtro diferente';

  @override
  String get defaultChartName => 'Mapa';

  @override
  String get balAbbr => 'Saldo';

  @override
  String get aiTimePassTitle => 'Escolha seu tempo de chat';

  @override
  String get aiTimePassHint => 'Pago pela sua carteira. O tempo começa agora; comprar de novo soma ao tempo restante.';

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
    return 'Faltam $minutes min';
  }
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get awChooseLanguage => 'Escolha seu idioma';

  @override
  String get awGoogleFailed => 'Falha ao entrar com o Google. Tente novamente.';

  @override
  String get awCompleteProfileTitle => 'Complete seu perfil';

  @override
  String awWelcomeName(String name) {
    return 'Bem-vindo, $name!';
  }

  @override
  String get awCompleteProfileSubtitle =>
      'Alguns detalhes para personalizar o Nakshatralogy para você.';

  @override
  String get awRegionLabel => 'Região';

  @override
  String get awRegionIndia => 'Índia';

  @override
  String get awRegionInternational => 'Internacional';

  @override
  String get awPreferredLanguage => 'Idioma preferido';

  @override
  String get awFinishSetup => 'Concluir configuração';

  @override
  String get awChatFileWebUnsupported =>
      'O compartilhamento de arquivos ainda não está disponível na web. Use o aplicativo móvel.';

  @override
  String get awVideoUnsupported =>
      'Chamadas de vídeo não são compatíveis com este navegador. Use nosso aplicativo móvel ou um navegador de desktop compatível.';

  @override
  String get awClose => 'Fechar';

  @override
  String get pwPremiumTitle => 'Relatório Premium';

  @override
  String get pwLockedSubtitle => 'Desbloqueie a análise completa deste mapa';

  @override
  String pwUnlockFull(Object name) {
    return 'Desbloquear $name completo';
  }

  @override
  String pwUnlockPrice(Object price) {
    return 'Desbloquear · $price';
  }

  @override
  String get pwOneTime => 'Desbloqueio único — seu para sempre neste mapa';

  @override
  String get pwWhatYouGet => 'O que você recebe';

  @override
  String get pwYourBalance => 'Seu saldo da carteira';

  @override
  String get pwInsufficient => 'Saldo insuficiente';

  @override
  String get pwRechargeToUnlock => 'Recarregue para desbloquear';

  @override
  String get pwRechargeAmount => 'Valor da recarga (₹)';

  @override
  String get pwAddMoney => 'Adicionar dinheiro';

  @override
  String get pwRechargeDone => 'Carteira recarregada';

  @override
  String get pwRechargeFailed => 'Falha na recarga. Tente novamente.';

  @override
  String get pwUnlockFailed => 'Não foi possível desbloquear. Tente novamente.';

  @override
  String get pwUnlockedNow => 'Desbloqueado! Carregando seu relatório…';

  @override
  String get pwProcessing => 'Processando…';

  @override
  String get pwPrimaryNoDelete =>
      'Seu Kundli Principal não pode ser excluído — ele é gratuito para sempre.';

  @override
  String get pwPrimaryNoEdit => 'Seu Kundli Principal não pode ser editado.';

  @override
  String get pwLoadingAccess => 'Verificando acesso…';

  @override
  String get pwMaybeLater => 'Talvez depois';

  @override
  String get updatePhoto => 'Atualizar Foto';

  @override
  String get takePhoto => 'Câmera';

  @override
  String get chooseFromGallery => 'Galeria';

  @override
  String get removePhoto => 'Remover Foto';

  @override
  String get photoUpdated => 'Foto atualizada';

  @override
  String get photoUploadFailed =>
      'Não foi possível enviar a foto. Tente novamente.';

  @override
  String get tapToChangePhoto => 'Toque para trocar a foto';

  @override
  String get klSubtitle =>
      'Relatório Védico de Ligação Cármica de Vidas Passadas com IA';

  @override
  String get klTitle => 'Ligação Cármica de Vidas Passadas';

  @override
  String get klSnapshotHeader => 'Resumo da Ligação Cármica';

  @override
  String get klGaugePairwise => 'Ligação Média entre Pares';

  @override
  String get klGaugeCohesion => 'Coesão do Grupo';

  @override
  String get klGaugeRahuKetu => 'Ressonância Rahu-Ketu';

  @override
  String get klGaugeAtmakaraka => 'Ressonância da Alma';

  @override
  String get klGaugeD60 => 'Ressonância D60';

  @override
  String get klChipSoulResonance => 'Forte ressonância da assinatura da alma';

  @override
  String get klChipD60Resonance => 'Forte ressonância de vidas passadas no D60';

  @override
  String get klChipCohesiveGroup => 'Grupo coeso';

  @override
  String get klChipNoDebts => 'Nenhuma dívida cármica detectada';

  @override
  String get klProfilesTitle => 'Perfis dos Mapas';

  @override
  String get klKetuAt => 'Ketu em';

  @override
  String get klRahuAt => 'Rahu em';

  @override
  String get klFoundationTitle => 'Fundação Cármica por Mapa';

  @override
  String get klFoundationSubtitle =>
      'A maestria de vidas passadas e a direção da vida atual de cada alma';

  @override
  String get klKetuMastery => 'Maestria de Ketu';

  @override
  String get klRahuGrowth => 'Crescimento de Rahu';

  @override
  String get klNinthHousePunya => 'Punya da Casa 9';

  @override
  String get klD60Depth => 'Profundidade Cármica D60';

  @override
  String get klAtmakarakaAgenda => 'Agenda da alma';

  @override
  String get klSaturnKarma => 'Carma de Saturno';

  @override
  String get klPairwiseTitle => 'Ligações Cármicas entre Pares';

  @override
  String get klActiveFactors => 'Fatores de ligação ativos';

  @override
  String get klGroupPatternTitle => 'Padrão Cármico do Grupo';

  @override
  String get klSharedSetting => 'Cenário Compartilhado de Vida Passada';

  @override
  String get klCohesionScore => 'Coesão Cármica';

  @override
  String get klPastGoalsTitle => 'Objetivos de Vidas Passadas';

  @override
  String get klLearningTitle => 'Aprendizado da Vida Atual';

  @override
  String get klTeachingMap => 'Mapa de Ensino Mútuo';

  @override
  String get klDebtsTitle => 'Dívidas Cármicas e Resoluções';

  @override
  String get klNoDebtsDetected =>
      'Nenhuma dívida cármica detectada neste grupo';

  @override
  String get klTimingTitle => 'Timing Cármico da Moola Dasha';

  @override
  String get klAuditTitle => 'Tabela de Auditoria Detalhada';

  @override
  String klAuditSubtitle(Object count) {
    return '$count parâmetros cármicos examinados';
  }

  @override
  String get klTopicLinkage => 'Nossa ligação cármica geral';

  @override
  String get klTopicPairwise => 'O vínculo cármico de um par específico';

  @override
  String get klTopicDebts => 'Dívidas cármicas a resolver';

  @override
  String get klTopicLessons => 'O que viemos aprender';

  @override
  String get klTopicTiming => 'Melhor momento para o nosso grupo';

  @override
  String get klTopicGroup => 'Nossa história compartilhada de vidas passadas';

  @override
  String get lcSubtitle => 'Relatório Védico de Compatibilidade Amorosa com IA';

  @override
  String get lcTitle => 'Compatibilidade Amorosa';

  @override
  String get lcSnapshotHeader => 'Resumo da Compatibilidade Amorosa';

  @override
  String get lcGaugeAttraction => 'Atração';

  @override
  String get lcGaugeEmotional => 'Harmonia Emocional';

  @override
  String get lcGaugeMental => 'Sintonia Mental';

  @override
  String get lcGaugePassion => 'Paixão';

  @override
  String get lcGaugeLongterm => 'Harmonia de Longo Prazo';

  @override
  String get lcChipStrongMental => 'Forte conexão mental';

  @override
  String get lcChipStrongLongterm => 'Forte potencial de longo prazo';

  @override
  String get lcChipStrongPassion => 'Forte química física';

  @override
  String get lcChipLowFriction => 'Baixo atrito no geral';

  @override
  String get lcChipKarmicPull => 'Forte atração cármica';

  @override
  String get lcPartnersTitle => 'Resumo dos Parceiros';

  @override
  String get lcVenusSuffix => 'Signo de Vênus';

  @override
  String get lcAttractionTitle => 'Atração e Química';

  @override
  String get lcAttractionScore => 'Pontuação de Atração';

  @override
  String get lcActiveContacts => 'Contatos Ativos de Vênus';

  @override
  String get lcEmotionalTitle => 'Harmonia Emocional';

  @override
  String get lcEmotionalScore => 'Pontuação de Harmonia Emocional';

  @override
  String get lcNakshatraCompat => 'Compatibilidade de Nakshatra';

  @override
  String get lcYoniKoota => 'Yoni Koota';

  @override
  String get lcGanaKoota => 'Gana Koota';

  @override
  String get lcTaraKoota => 'Tara Koota';

  @override
  String get lcBhakootAxis => 'Eixo Bhakoot';

  @override
  String get lcMentalTitle => 'Sintonia Mental';

  @override
  String get lcMentalScore => 'Pontuação de Sintonia Mental';

  @override
  String get lcPassionTitle => 'Paixão e Físico';

  @override
  String get lcPassionScore => 'Pontuação de Paixão';

  @override
  String get lcLongtermTitle => 'Harmonia de Longo Prazo';

  @override
  String get lcLongtermScore => 'Pontuação de Harmonia de Longo Prazo';

  @override
  String get lcCommitmentPotential => 'Potencial de Compromisso';

  @override
  String get lc7thHouseSynastry => 'Sinastria da Casa 7';

  @override
  String get lcJupiterBlessing => 'Bênção de Júpiter';

  @override
  String get lcD9Resonance => 'Ressonância D9 Navamsa';

  @override
  String get lcSaturnLongevity => 'Longevidade de Saturno';

  @override
  String get lcKarmicTitle => 'Vínculo Amoroso Cármico';

  @override
  String get lcKarmicScore => 'Pontuação do Vínculo Cármico';

  @override
  String get lcKetuContacts => 'Contatos de Ketu';

  @override
  String get lcRahuContacts => 'Contatos de Rahu';

  @override
  String get lcChallengesTitle => 'Desafios e Atritos';

  @override
  String get lcNoChallenges =>
      'Nenhum ponto de atrito significativo detectado em nenhum dos mapas';

  @override
  String get lcTotalPenalty => 'Penalidade Total de Desafios';

  @override
  String get lcTimingTitle => 'Timing Amoroso — Moola Dasha';

  @override
  String get lcDynamicsTitle => 'Dinâmica do Relacionamento';

  @override
  String get lcPowerBalance => 'Equilíbrio de Poder';

  @override
  String get lcGiverReceiver => 'Doador/Receptor Emocional';

  @override
  String get lcGrowthDynamic => 'Dinâmica de Crescimento';

  @override
  String get lcAreasToNurture => 'Áreas a Cultivar';

  @override
  String get lcTopicTiming => 'Melhor momento para nosso relacionamento';

  @override
  String get lcTopicChallenges => 'Desafios a enfrentar';

  @override
  String get lcTopicKarmic => 'Nossa conexão cármica';

  @override
  String get lcTopicRemedies => 'Remédios recomendados';

  @override
  String get lcTopicLongterm => 'Nosso potencial de longo prazo';

  @override
  String get lcTopicDynamics => 'A dinâmica do nosso relacionamento';

  @override
  String get cpSubtitle => 'Relatório Védico de Probabilidade de Filhos com IA';

  @override
  String get cpTitle => 'Probabilidade de Filhos';

  @override
  String get cpSnapshotHeader => 'Resumo da Probabilidade de Prole';

  @override
  String get cpGauge5thHouse => 'Casa 5';

  @override
  String get cpGaugeJupiter => 'Júpiter/Putrakaraka';

  @override
  String get cpGaugeD7 => 'D7 Saptamsa';

  @override
  String get cpGaugeSphuta => 'Beeja-Kshetra';

  @override
  String get cpGaugeTiming => 'Timing da Dasha';

  @override
  String get cpChipStrongPutrakaraka => 'Forte Putrakaraka (Júpiter)';

  @override
  String get cpChipLowDoshaPenalty => 'Baixa penalidade de dosha';

  @override
  String get cpChipFavorableTiming => 'Timing de dasha favorável';

  @override
  String get cpChipNoDoshas => 'Nenhum dosha de prole detectado';

  @override
  String get cpPartnersTitle => 'Resumo dos Parceiros';

  @override
  String get cpLagnaSuffix => 'Lagna';

  @override
  String get cpMoonSuffix => 'Signo lunar';

  @override
  String get cpNumberTitle => 'Número de Filhos e Tendência de Gênero';

  @override
  String get cpProbableNumber => 'Número Provável';

  @override
  String get cpFirstChildTendency => 'Tendência do Primeiro Filho';

  @override
  String get cpSpacing => 'Nota sobre Espaçamento';

  @override
  String get cpTimingTitle => 'Timing — Moola Dasha';

  @override
  String get cpCombinedTiming => 'Timing Combinado';

  @override
  String get cpNextWindow => 'Próxima Janela Favorável';

  @override
  String get cp5thHouseTitle => 'Análise da Casa 5';

  @override
  String get cp5thHouseSubtitle =>
      'A casa dos filhos (Putra Bhava), por pessoa';

  @override
  String get cpJupiterTitle => 'Júpiter — Análise do Putrakaraka';

  @override
  String get cpJupiterSubtitle =>
      'O significador natural dos filhos, por pessoa';

  @override
  String get cpD7Title => 'Análise do D7 Saptamsa';

  @override
  String get cpD7Subtitle => 'O mapa divisional específico para os filhos';

  @override
  String get cpD7Strength => 'Força do D7';

  @override
  String get cpSphutaTitle => 'Beeja e Kshetra Sphuta';

  @override
  String get cpBeejaSphuta => 'Beeja Sphuta (Semente)';

  @override
  String get cpKshetraSphuta => 'Kshetra Sphuta (Campo)';

  @override
  String get cpDoshaTitle => 'Análise de Dosha';

  @override
  String get cpNoDoshasDetected =>
      'Nenhum dosha relevante à prole detectado em nenhum dos mapas';

  @override
  String get cpRemediesTitle => 'Remédios Recomendados';

  @override
  String get cpAddresses => 'Aborda';

  @override
  String get cpTopicTiming => 'Melhor momento para conceber';

  @override
  String get cpTopicNumber => 'Quantos filhos podemos ter';

  @override
  String get cpTopicDosha => 'Doshas a serem tratados';

  @override
  String get cpTopicRemedies => 'Remédios recomendados';

  @override
  String get cpTopicFifthHouse => 'A força da nossa Casa 5';

  @override
  String get cpTopicJupiter => 'O papel de Júpiter nisso';

  @override
  String get riSubtitle =>
      'Relatório Védico de Inteligência de Relacionamento com IA';

  @override
  String get riTitle => 'Inteligência de Relacionamento';

  @override
  String get riSnapshotHeader => 'Resumo do Grupo';

  @override
  String get riGaugeCohesion => 'Coesão do Grupo';

  @override
  String get riGaugeTrust => 'Clima de Confiança';

  @override
  String get riGaugeProductivity => 'Produtividade';

  @override
  String get riGaugeCreativity => 'Criatividade';

  @override
  String get riChipNoAlerts => 'Nenhum alerta crítico';

  @override
  String get riChipStrongCohesion => 'Forte coesão do grupo';

  @override
  String get riChipHighTrust => 'Alto clima de confiança';

  @override
  String get riChipNoHiddenEnemy => 'Nenhum sinal de inimigo oculto';

  @override
  String get riChipHealthyGroup => 'Grupo saudável em geral';

  @override
  String get riProfilesTitle => 'Perfis dos Mapas';

  @override
  String riProfilesSubtitle(Object count) {
    return '$count pessoas neste grupo';
  }

  @override
  String get riLagnaSuffix => 'Lagna';

  @override
  String get riIntegrity => 'Integridade';

  @override
  String get riWarmth => 'Calor Humano';

  @override
  String get riTrustworthiness => 'Confiabilidade';

  @override
  String get riAssertiveness => 'Assertividade';

  @override
  String get riGroupDynamicsTitle => 'Visão Geral da Dinâmica do Grupo';

  @override
  String get riMostSupportive => 'Mais Solidário';

  @override
  String get riMostChallenged => 'Mais Desafiado';

  @override
  String get riHiddenEnemyAlert => 'Sinal de Inimigo Oculto Detectado';

  @override
  String get riBestWorstTitle => 'Pares Melhores e Mais Desafiadores';

  @override
  String get riBestPair => 'VÍNCULO MAIS FORTE';

  @override
  String get riWorstPair => 'PRECISA DE ATENÇÃO';

  @override
  String get riAlliances => 'Alianças Prováveis';

  @override
  String get riConflicts => 'Pontos de Atrito Prováveis';

  @override
  String get riPairwiseTitle => 'Análise entre Pares';

  @override
  String riPairwiseSubtitle(Object count) {
    return '$count pares analisados';
  }

  @override
  String get riDynamic => 'Dinâmica';

  @override
  String get riKarmicLink => 'Ligação cármica';

  @override
  String get riMutualTrust => 'Confiança mútua';

  @override
  String get riBetrayalRisk => 'Risco de traição';

  @override
  String get riPowerDistribution => 'Distribuição de poder';

  @override
  String get riPowerHealth => 'Saúde do equilíbrio de poder';

  @override
  String get riCriticalPatternsTitle => 'Padrões Críticos';

  @override
  String get riGroupRecsTitle => 'Recomendações para o Grupo';

  @override
  String get riSharedPractices => 'Práticas Compartilhadas';

  @override
  String get riCommStyle => 'Estilo de Comunicação Recomendado';

  @override
  String get riGrowthFocus => 'Foco de Crescimento Recomendado';

  @override
  String get riIndividualTitle => 'Orientação Individual';

  @override
  String get riBestAllies => 'Melhores Aliados';

  @override
  String get riHandleWithCare => 'Tratar com Cuidado';

  @override
  String get riCoreThemeTitle => 'Tema Central do Grupo';

  @override
  String get riLayerPairwise => 'Completude entre Pares';

  @override
  String get riLayerD1 => 'Mapa Natal (D1)';

  @override
  String get riLayerD9 => 'Navamsa (D9)';

  @override
  String get riLayerD10 => 'Dashamsa (D10)';

  @override
  String get riLayerD30 => 'Trimshamsa (D30)';

  @override
  String get riLayerJaimini => 'Sinal Jaimini';

  @override
  String get riLayerBehavior => 'Clareza Comportamental';

  @override
  String get riLayerCoherence => 'Coerência do Grupo';

  @override
  String get riTopicDynamics => 'A dinâmica do nosso grupo';

  @override
  String get riTopicPairwise => 'A compatibilidade de um par específico';

  @override
  String get riTopicAlerts => 'Alertas críticos';

  @override
  String get riTopicGrowth => 'Como podemos crescer juntos';

  @override
  String get riTopicRecs => 'Práticas recomendadas';

  @override
  String get riTopicTheme => 'O tema central do nosso grupo';

  @override
  String get kmSubtitle => 'Relatório Védico de Kundli Milan com IA';

  @override
  String get kmTitle => 'Kundli Milan';

  @override
  String get kmSnapshotHeader => 'Resumo da Compatibilidade';

  @override
  String kmAshtakootScore(Object score) {
    return 'Ashtakoot: $score/36';
  }

  @override
  String get kmGaugeAshtakoot => 'Ashtakoot %';

  @override
  String get kmGaugeD9 => 'Carma Matrimonial D9';

  @override
  String get kmGaugeMangal => 'Equilíbrio de Mangal';

  @override
  String get kmGaugePapa => 'Equilíbrio Cármico';

  @override
  String get kmGaugeAk => 'Ressonância da Alma';

  @override
  String get kmChipNoNadi => 'Sem Nadi Dosh';

  @override
  String get kmChipNoBhakoot => 'Sem Bhakoot Dosh';

  @override
  String get kmChipMangalCancelled => 'Mangal Dosh cancelado';

  @override
  String get kmChipPapaBalanced => 'Carga cármica equilibrada';

  @override
  String get kmChipStrongChemistry => 'Forte química física';

  @override
  String get kmChipStrongD9 => 'Forte carma matrimonial D9';

  @override
  String get kmChipLongevity => 'Forte alinhamento de longevidade';

  @override
  String get kmAshtakootTitle => 'Ashtakoot Guna Milan';

  @override
  String get kmAshtakootSubtitle =>
      'O sistema clássico de compatibilidade de 8 pontos, num total de 36';

  @override
  String get kmNadiSeverity => 'Severidade do Nadi';

  @override
  String get kmBhakootSeverity => 'Severidade do Bhakoot';

  @override
  String get kmGanaSignature => 'Assinatura Gana';

  @override
  String get kmMangalTitle => 'Verificação de Mangal Dosha';

  @override
  String get kmD9Title => 'D9 Navamsa — Carma Matrimonial';

  @override
  String get kmD9Subtitle =>
      'O mapa matrimonial no nível da alma, considerado o mais importante classicamente';

  @override
  String get kmD9Score => 'Compatibilidade D9';

  @override
  String get kmLagnaRelation => 'Relação entre Lagnas';

  @override
  String get km7thLordRelation => 'Relação entre senhores da Casa 7';

  @override
  String get kmKarakasTitle => 'Karakas da Alma e do Cônjuge';

  @override
  String get kmAtmakaraka => 'Planeta da Alma';

  @override
  String get kmAkCompatibility => 'Ressonância da Assinatura da Alma';

  @override
  String get kmUlCompatibility => 'Alinhamento do Karaka do Cônjuge';

  @override
  String get kmUlSigns => 'Senhores do Upapada';

  @override
  String get kmChemistryTitle => 'Química Vênus-Marte';

  @override
  String get kmPhysicalChemistry => 'Química Física';

  @override
  String get kmEmotionalWarmth => 'Calor Emocional';

  @override
  String get kmAestheticAlignment => 'Alinhamento Estético';

  @override
  String get kmElementalSynthesis => 'Síntese Elemental';

  @override
  String get kmHouseCrossTitle => 'Análise Cruzada das Casas 7 e 8';

  @override
  String get km78Compatibility => 'Compatibilidade das Casas 7-8';

  @override
  String get km8thHouseSignature => 'Assinatura Conjunta de Longevidade';

  @override
  String get kmLongevityAlignment => 'Alinhamento de Longevidade';

  @override
  String get km7thLordFriendship => 'Amizade entre senhores da Casa 7';

  @override
  String get kmDomainsTitle => 'Compatibilidade por Domínio';

  @override
  String get kmConflictEngagement => 'Estilo de Conflito';

  @override
  String get kmDashaTitle => 'Sincronia de Dasha e Trânsitos';

  @override
  String get kmDashaSync => 'Sincronia de Dasha';

  @override
  String get kmTransitAlignment => 'Alinhamento de Trânsitos';

  @override
  String get kmTimingTitle => 'Timing do Casamento';

  @override
  String get kmMarriageWindow => 'Janela do Casamento';

  @override
  String get kmEngagementWindow => 'Janela do Noivado';

  @override
  String get kmRecommendedRange => 'Período Recomendado';

  @override
  String get kmMuhurtaNotes => 'Notas de Muhurta';

  @override
  String get kmRisksTitle => 'Riscos a Tratar';

  @override
  String get kmConflictRisk => 'Risco de Conflito';

  @override
  String get kmCommunicationRisk => 'Risco de Comunicação';

  @override
  String get kmFinanceRisk => 'Risco de Conflito Financeiro';

  @override
  String get kmFamilyDynamicsRisk => 'Risco na Dinâmica Familiar';

  @override
  String get kmMentalHealthRisk => 'Risco de Alinhamento de Saúde Mental';

  @override
  String get kmStrengthsTitle => 'Principais Pontos Fortes de Compatibilidade';

  @override
  String get kmSharedGrowth => 'Potencial de Crescimento Compartilhado';

  @override
  String get kmSharedCreative => 'Potencial Criativo Compartilhado';

  @override
  String get kmJourneyTitle => 'Jornada e Crescimento do Relacionamento';

  @override
  String get kmCurrentPhase => 'Fase atual';

  @override
  String get kmEarlyArc => 'Início do Casamento';

  @override
  String get kmMiddleArc => 'Meio do Casamento';

  @override
  String get kmMatureArc => 'Casamento Maduro';

  @override
  String get kmElderArc => 'Anos de Maturidade';

  @override
  String get kmPeakPhase => 'Fase de Pico da Companhia';

  @override
  String get kmGrowthAreas => 'Áreas de Crescimento';

  @override
  String get kmCommProtocols => 'Protocolos de Comunicação';

  @override
  String get kmSharedPractices => 'Práticas Compartilhadas';

  @override
  String get kmImprovementTitle => 'Tema Central e Plano de Melhoria';

  @override
  String get kmVerdictTitle => 'Veredito Final';

  @override
  String get kmRealizationPotential =>
      'Potencial de Realização do Relacionamento';

  @override
  String get kmLayerAshtakoot => 'Ashtakoot';

  @override
  String get kmLayerD9 => 'D9 Navamsa';

  @override
  String get kmLayerMangalPapa => 'Mangal e Papasamya';

  @override
  String get kmLayerVenusMars => 'Vênus-Marte';

  @override
  String get kmLayerDashaSync => 'Sincronia de Dasha';

  @override
  String get kmLayerH7H8 => 'Cruzamento das Casas 7-8';

  @override
  String get kmLayerAkResonance => 'Ressonância do Atmakaraka';

  @override
  String get kmLayerDomains => 'Dimensões de Domínio';

  @override
  String get kmTopicAshtakoot => 'Nossa pontuação de Ashtakoot';

  @override
  String get kmTopicMangal => 'Preocupações com Mangal Dosha';

  @override
  String get kmTopicD9 => 'Nosso carma matrimonial (D9)';

  @override
  String get kmTopicTiming => 'Melhor timing para o casamento';

  @override
  String get kmTopicRisks => 'Riscos a se preparar';

  @override
  String get kmTopicGrowth => 'Como podemos crescer juntos';

  @override
  String get kmTopicRemedies => 'Remédios recomendados';

  @override
  String get kmTopicVerdict => 'Devemos seguir com o casamento';

  @override
  String get pkSubtitle => 'Relatório Védico de Vidas Passadas e Carma com IA';

  @override
  String get pkTitle => 'Vidas Passadas e Carma';

  @override
  String get pkSnapshotHeader => 'Resumo de Vidas Passadas';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return 'Seu mapa mostra uma assinatura de vida passada \'$theme\', atualmente $relation nesta vida. Caminho recomendado: $strategy.';
  }

  @override
  String get pkGaugeSignature => 'Força da Assinatura';

  @override
  String get pkGaugeMasteryPreserved => 'Maestria Preservada';

  @override
  String get pkGaugeClearingProgress => 'Limpeza Cármica';

  @override
  String get pkGaugeMaturity => 'Maturidade de Vida Passada';

  @override
  String get pkGaugeMemoryAccess => 'Acesso à Memória';

  @override
  String get pkChipGoodProgress => 'Bom progresso na limpeza cármica';

  @override
  String get pkChipLowDebt => 'Baixa dívida cármica';

  @override
  String get pkChipMatureSoul => 'Assinatura de alma madura';

  @override
  String get pkChipGiftedPast => 'O mapa carrega um dom de vida passada';

  @override
  String get pkChipAccomplished => 'Vida passada bem-sucedida';

  @override
  String get pkChipMasteryPreserved => 'Forte maestria transportada';

  @override
  String get pkKetuTitle => 'Ketu — Sua Maestria do Passado';

  @override
  String get pkKetuSubtitle => 'Habilidades que sua alma já dominou';

  @override
  String get pkMasteryStrength => 'Força da Maestria';

  @override
  String get pkSkillsCarried => 'Habilidades Transportadas';

  @override
  String get pkInstincts => 'Capacidades Instintivas';

  @override
  String get pkKetuDignity => 'Dignidade de Ketu';

  @override
  String get pkRahuTitle => 'Rahu — O Limite de Crescimento da Sua Alma';

  @override
  String get pkRahuSubtitle => 'O que sua alma veio concluir';

  @override
  String get pkUnmetDesires => 'Desejos Não Realizados';

  @override
  String get pkProfileTitle => 'Seu Perfil de Vida Passada';

  @override
  String get pkProfession => 'Profissão Provável';

  @override
  String get pkSocialStanding => 'Posição Social';

  @override
  String get pkRegion => 'Região Provável';

  @override
  String get pkCulturalArchetype => 'Arquétipo Cultural';

  @override
  String get pkAccomplishment => 'Nível de Realização';

  @override
  String get pkAuthority => 'Nível de Autoridade';

  @override
  String get pkFamilyRole => 'Papel na família';

  @override
  String get pkSecondaryProfession => 'Profissão secundária';

  @override
  String get pkClimateAffinity => 'Afinidade climática';

  @override
  String get pkForeignResidence => 'Carma de residência no exterior';

  @override
  String get pkRelationshipsTitle => 'Relacionamentos Passados Transportados';

  @override
  String get pkSpouseConnection => 'Reconexão com o Cônjuge';

  @override
  String get pkChildrenConnection => 'Reconexão com os Filhos';

  @override
  String get pkCarriedRelationTypes => 'Padrões de Relacionamento';

  @override
  String get pkPartnerArchetype => 'Arquétipo do Parceiro de Vida Passada';

  @override
  String get pkDarakaraka => 'Karaka do cônjuge';

  @override
  String get pkParentsKarma => 'Padrão de carma dos pais';

  @override
  String get pkSiblingKarma => 'Padrão de carma dos irmãos';

  @override
  String get pkSpiritualTitle => 'Sua Vida Espiritual Naquela Época';

  @override
  String get pkSpiritualLevel => 'Nível Espiritual';

  @override
  String get pkPracticeSignature => 'Estilo de Prática';

  @override
  String get pkMeditativeCapacity => 'Capacidade Meditativa';

  @override
  String get pkDevotionalPractice => 'Prática Devocional';

  @override
  String get pkYogicAttainment => 'Realização Iogue';

  @override
  String get pkMokshaProximity => 'Proximidade do Moksha';

  @override
  String get pkKarmicDebtsTitle => 'Dívidas Cármicas e Riqueza na Época';

  @override
  String get pkTotalKarmicDebt => 'Dívida Cármica Total';

  @override
  String get pkPrimaryDebtType => 'Tipo de Dívida Primária';

  @override
  String get pkRelationshipDebt => 'Dívida de Relacionamento';

  @override
  String get pkFinancialDebt => 'Dívida Financeira';

  @override
  String get pkServiceDebt => 'Dívida de Serviço';

  @override
  String get pkDharmicDebt => 'Dívida Dhármica';

  @override
  String get pkPitruKarma => 'Carma Pitru';

  @override
  String get pkMatruKarma => 'Carma Matru';

  @override
  String get pkWealthLevel => 'Nível de Riqueza na Época';

  @override
  String get pkWealthKarmaCarried => 'Carma de Riqueza Transportado';

  @override
  String get pkResourcePattern => 'Gestão de recursos';

  @override
  String get pkGainSource => 'Fonte de ganho';

  @override
  String get pkEchoesTitle => 'Ecos Nesta Vida';

  @override
  String get pkOnRelationships => 'Nos Relacionamentos';

  @override
  String get pkOnCareer => 'Na Carreira';

  @override
  String get pkOnHealth => 'Na Saúde';

  @override
  String get pkOnSpirituality => 'Na Espiritualidade';

  @override
  String get pkDominantArea => 'Herança Mais Forte';

  @override
  String get pkAttractions => 'Atrações Naturais';

  @override
  String get pkAversions => 'Aversões Naturais';

  @override
  String get pkUnexplainedFears => 'Medos Inexplicáveis';

  @override
  String get pkMagneticPulls => 'Atrações Magnéticas';

  @override
  String get pkResolutionTitle => 'Resolução e Conclusão Cármica';

  @override
  String get pkPrimaryPathway => 'Caminho Primário';

  @override
  String get pkSecondaryPathway => 'Caminho Secundário';

  @override
  String get pkClearingProgress => 'Progresso da Limpeza';

  @override
  String get pkRemainingWork => 'Trabalho Restante';

  @override
  String get pkSettlementTimeline => 'Cronograma de Resolução';

  @override
  String get pkAccelerationPractices => 'Práticas Que Aceleram a Resolução';

  @override
  String get pkPriorityAreas => 'Áreas Prioritárias';

  @override
  String get pkVerificationTitle => 'Verificado em Múltiplos Mapas (D60)';

  @override
  String get pkD60Label => 'Era de Vida Passada D60';

  @override
  String get pkD60Ketu => 'Posicionamento de Ketu no D60';

  @override
  String get pkD60Standing => 'Posição geral';

  @override
  String get pkMemoryTitle => 'Memória e Intuição';

  @override
  String get pkMemoryAccess => 'Acesso à Memória';

  @override
  String get pkRegressionFit => 'Aptidão para Terapia de Regressão';

  @override
  String get pkDreamVisits => 'Visitas em Sonhos';

  @override
  String get pkDejaVuFrequency => 'Frequência de Déjà Vu';

  @override
  String get pkSpontaneousRemembrance => 'Lembrança espontânea';

  @override
  String get pkRemembrancePractices => 'Práticas de Lembrança';

  @override
  String get pkTimelineTitle => 'Cronograma de Ativação';

  @override
  String get pkGiftsActivation => 'Ativação dos Dons de Vida Passada';

  @override
  String get pkSurfaceWindow => 'Janela de Emergência';

  @override
  String get pkRisksTitle => 'Riscos e Padrões Crônicos';

  @override
  String get pkTraumaResidue => 'Resíduo de Trauma';

  @override
  String get pkSpiritualBypass => 'Risco de Bypass Espiritual';

  @override
  String get pkMajorRisks => 'Principais Riscos';

  @override
  String get pkChronicImprints => 'Marcas Crônicas';

  @override
  String get pkKarmicLoops => 'Ciclos Cármicos';

  @override
  String get pkImprovementTitle => 'Plano de Melhoria';

  @override
  String get pkRoadmapTitle => 'Seu Roteiro de Vida Passada';

  @override
  String get pkMaturity => 'Maturidade de Vida Passada';

  @override
  String get pkLayerD1 => 'Mapa Natal (D1)';

  @override
  String get pkLayerD9 => 'Navamsa (D9)';

  @override
  String get pkLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get pkLayerKetuDepth => 'Profundidade de Ketu';

  @override
  String get pkLayerAtmakaraka => 'Planeta da Alma (Atmakaraka)';

  @override
  String get pkTopicMastery => 'Minha maestria de vida passada';

  @override
  String get pkTopicUnfinished => 'Meu carma inacabado';

  @override
  String get pkTopicRelationships => 'Meus relacionamentos de vida passada';

  @override
  String get pkTopicDebts => 'Minhas dívidas cármicas';

  @override
  String get pkTopicResolution => 'Como resolver meu carma';

  @override
  String get pkTopicMemory => 'Acesso à memória de vidas passadas';

  @override
  String get pkTopicTiming => 'Melhores janelas de timing';

  @override
  String get pkTopicProfile => 'Quem eu era na minha vida passada';

  @override
  String get chSubtitle => 'Relatório Védico de Análise de Caráter com IA';

  @override
  String get chTitle => 'Análise de Caráter';

  @override
  String get chSnapshotHeader => 'Resumo de Caráter';

  @override
  String get chGaugeIntegrity => 'Integridade';

  @override
  String get chGaugeResilience => 'Resiliência';

  @override
  String get chGaugeSelfAwareness => 'Autoconsciência';

  @override
  String get chGaugeStability => 'Estabilidade Emocional';

  @override
  String get chGaugeMoralFabric => 'Tecido Moral';

  @override
  String get chChipRajaYoga => 'Raja Yoga presente';

  @override
  String get chChipHighIntegrity => 'Alta integridade';

  @override
  String get chChipResilient => 'Natureza resiliente';

  @override
  String get chChipDharmic => 'Forte orientação dhármica';

  @override
  String get chChipEmpathetic => 'Naturalmente empático';

  @override
  String get chChipLoyal => 'Profundamente leal';

  @override
  String get chChipGiftedCharacter => 'O mapa carrega um dom de caráter';

  @override
  String get chSoulTitle => 'Sua Assinatura da Alma';

  @override
  String get chSoulIntegration => 'Integração Alma-Caráter';

  @override
  String get chAmatyakarakaTheme => 'Voz de Apoio ao Caráter';

  @override
  String get chAtmakarakaDignity => 'Dignidade do planeta da alma';

  @override
  String get chAtmakarakaHouse => 'Posicionamento na casa';

  @override
  String get chSurfaceTitle => 'Personalidade Aparente e Constituição';

  @override
  String get chLagnaSign => 'Signo Ascendente';

  @override
  String get chConstitution => 'Constituição';

  @override
  String get chSurfaceSignature => 'Como você é percebido';

  @override
  String get chPhysicalConstitution => 'Constituição Física';

  @override
  String get chLagnaLord => 'Senhor do Ascendente';

  @override
  String get chLagnaOccupants => 'Planetas no Ascendente';

  @override
  String get chMindEmotionsTitle => 'Mente, Emoções e Ego';

  @override
  String get chEmotionalNature => 'Sua Natureza Emocional';

  @override
  String get chMentalStability => 'Estabilidade Mental';

  @override
  String get chSelfConfidence => 'Autoconfiança Saudável';

  @override
  String get chEgoNature => 'Seu Ego e Autoconceito';

  @override
  String get chAuthorityRelationship => 'Relação com a Autoridade';

  @override
  String get chPrideTendency => 'Tendência ao Orgulho';

  @override
  String get chMoodPatterns => 'Padrões de Humor';

  @override
  String get chKemadrumaPresent =>
      'Kemadruma Yoga presente — autocuidado emocional extra é benéfico.';

  @override
  String get chFatherImprint => 'Qualidade da marca paterna';

  @override
  String get chCommunicationTitle => 'Estilo de Comunicação e Intelecto';

  @override
  String get chIntellectStyle => 'Estilo Intelectual';

  @override
  String get chCommStyle => 'Estilo de Comunicação';

  @override
  String get chDecisionStyle => 'Estilo de Tomada de Decisão';

  @override
  String get chDiscrimination => 'Capacidade de Discernimento';

  @override
  String get chPersonaTitle => 'Persona Pública vs Verdadeiro Eu';

  @override
  String get chAuthenticityGap => 'Lacuna de Autenticidade';

  @override
  String get chGunaTitle => 'Perfil de Guna e Dosha';

  @override
  String get chGunaSubtitle =>
      'Sua natureza interior e constituição, no estilo védico clássico';

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
  String get chRahuRestlessness => 'Inquietação de Rahu';

  @override
  String get chKetuDetachment => 'Desapego de Ketu';

  @override
  String get chYogasTitle => 'Yogas de Caráter';

  @override
  String get chRajaYogaStrength => 'Força do Raja Yoga';

  @override
  String get chGiftYogas => 'Yogas de Dom';

  @override
  String get chTestYogas => 'Yogas de Teste';

  @override
  String get chStrengthsTitle => 'Pontos Fortes e Talentos';

  @override
  String get chSignatureVirtues => 'Virtudes Características';

  @override
  String get chNaturalTalents => 'Talentos Naturais';

  @override
  String get chSoftSkills => 'Habilidades Interpessoais';

  @override
  String get chHiddenStrengths => 'Forças Ocultas a Desenvolver';

  @override
  String get chShadowTitle => 'Sombra e Áreas de Crescimento';

  @override
  String get chShadowSubtitle =>
      'Consciência gentil de padrões que valem a pena trabalhar';

  @override
  String get chShadowPatterns => 'Padrões de Sombra';

  @override
  String get chBlindSpots => 'Pontos Cegos';

  @override
  String get chEmotionalWounds => 'Feridas Emocionais';

  @override
  String get chShadowWorkPriorities => 'Prioridades de Trabalho de Sombra';

  @override
  String get chMoralTests => 'Testes Morais';

  @override
  String get chRelationshipsTitle => 'Relacionamentos e Estilo Social';

  @override
  String get chWarmth => 'Calor Interpessoal';

  @override
  String get chEmpathy => 'Capacidade de Empatia';

  @override
  String get chLoyalty => 'Capacidade de Lealdade';

  @override
  String get chBoundaries => 'Estabelecimento de Limites';

  @override
  String get chSocialConfidence => 'Confiança Social';

  @override
  String get chTrustGiving => 'Base de Confiança Concedida';

  @override
  String get chConflictStyle => 'Estilo de conflito';

  @override
  String get chEthicsTitle => 'Ética e Bússola Moral';

  @override
  String get chDharmaOrientation => 'Orientação de Dharma';

  @override
  String get chTruthfulness => 'Veracidade';

  @override
  String get chCompassion => 'Compaixão';

  @override
  String get chGenerosity => 'Generosidade';

  @override
  String get chEthicalConsistency => 'Consistência Ética';

  @override
  String get chIntegrityPressure => 'Integridade sob Pressão';

  @override
  String get chJusticeFairness => 'Justiça e Equidade';

  @override
  String get chMoralTrajectory => 'Desenvolvimento moral';

  @override
  String get chEiTitle => 'Inteligência Emocional';

  @override
  String get chEiSelfAwareness => 'Autoconsciência';

  @override
  String get chEiSelfRegulation => 'Autorregulação';

  @override
  String get chEiEmpathy => 'Empatia';

  @override
  String get chEiSocialSkills => 'Habilidades Sociais';

  @override
  String get chMotivation => 'Motivação Interna';

  @override
  String get chVulnerabilityComfort => 'Conforto com a Vulnerabilidade';

  @override
  String get chEmotionalExpression => 'Conforto de expressão emocional';

  @override
  String get chEmotionalReceptivity => 'Receptividade emocional';

  @override
  String get chVerificationTitle =>
      'Verificado em Múltiplos Mapas (D9/D12/D30/D60)';

  @override
  String get chD9Label => 'D9 Dharma-Caráter';

  @override
  String get chD12Label => 'D12 Herança Ancestral';

  @override
  String get chD30Label => 'D30 Perfil de Sombra';

  @override
  String get chD60Label => 'D60 Caráter de Vida Passada';

  @override
  String get chD30Standing => 'Posição da sombra';

  @override
  String get chMaternalInheritance => 'Herança materna';

  @override
  String get chAncestralKarmaWeight => 'Peso do carma ancestral';

  @override
  String get chTimelineTitle => 'Linha do Tempo do Caráter';

  @override
  String get chFormationWindow => 'Janela de Formação';

  @override
  String get chMaturationWindow => 'Janela de Maturação';

  @override
  String get chLegacyWindow => 'Janela de Legado';

  @override
  String get chPeakMaturationAge => 'Idade de maturação máxima';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return 'Idade $ageRange';
  }

  @override
  String get chImprovementTitle => 'Plano de Melhoria';

  @override
  String get chRoadmapTitle => 'Seu Roteiro de Caráter';

  @override
  String get chAuthenticExpression => 'Autoexpressão Autêntica';

  @override
  String get chRealizationPotential => 'Potencial de Realização do Caráter';

  @override
  String get chLayerAtmakaraka => 'Planeta da Alma (Atmakaraka)';

  @override
  String get chLayerD1 => 'Mapa Natal (D1)';

  @override
  String get chLayerD9 => 'Navamsa (D9)';

  @override
  String get chLayerD30 => 'Trimshamsa (D30)';

  @override
  String get chLayerLagnaMoon => 'Ascendente e Lua';

  @override
  String get chLayerArudha => 'Arudha Lagna';

  @override
  String get chTopicStrengths => 'Meus pontos fortes de caráter';

  @override
  String get chTopicShadow => 'Meus padrões de sombra';

  @override
  String get chTopicSoul => 'Minha assinatura da alma';

  @override
  String get chTopicRelationships => 'Meu estilo de relacionamento';

  @override
  String get chTopicEthics => 'Minha ética e valores';

  @override
  String get chTopicGuna => 'Meu perfil de guna e dosha';

  @override
  String get chTopicGrowth => 'Como desenvolver meu caráter';

  @override
  String get chTopicTiming => 'Melhor timing para trabalhar o caráter';

  @override
  String get lpSubtitle => 'Relatório Védico de Caminho de Vida e Sorte com IA';

  @override
  String get lpTitle => 'Caminho de Vida e Sorte';

  @override
  String get lpSnapshotHeader => 'Resumo do Caminho de Vida';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return 'Você é um $archetype com propósito principal em $domain. Nossa análise mostra um potencial geral de realização de vida de $probability%.';
  }

  @override
  String get lpGaugeDharma => 'Clareza de Dharma';

  @override
  String get lpGaugeFortune => 'Base de Fortuna';

  @override
  String get lpGaugeCoherence => 'Coerência do Caminho';

  @override
  String get lpGaugeFulfillment => 'Realização';

  @override
  String get lpGaugeMomentum => 'Momento Cármico';

  @override
  String get lpChipRareGift => 'Dom raro do destino';

  @override
  String get lpChipFreeWillStrong => 'Forte livre-arbítrio';

  @override
  String get lpChipGraceSupported => 'Apoiado pela graça';

  @override
  String get lpChipLightKarma => 'Carga cármica leve';

  @override
  String get lpChipRecognitionPotential => 'Potencial de reconhecimento';

  @override
  String get lpChipSpiritualPath => 'Forte inclinação espiritual';

  @override
  String get lpChipBlessed => 'O mapa carrega bênçãos';

  @override
  String get lpSoulPathTitle => 'Seu Caminho da Alma';

  @override
  String get lpSoulPlanet => 'Planeta da Alma';

  @override
  String get lpCareerPlanet => 'Planeta do Propósito';

  @override
  String get lpSoulClarity => 'Clareza do Propósito';

  @override
  String get lpLifeChapter => 'Capítulo Atual da Vida';

  @override
  String get lpPrimaryDomain => 'Domínio Principal do Propósito';

  @override
  String get lpKarakaTitle => 'Seus Planetas de Dharma';

  @override
  String get lpKarakaSubtitle =>
      'O quanto cada planeta apoia seu propósito de vida';

  @override
  String get lpVerificationTitle => 'Verificado em Múltiplos Mapas (D9 / D60)';

  @override
  String get lpD9Label => 'Alinhamento da Alma D9';

  @override
  String lpD9Explain(Object stage) {
    return 'Seu estágio de evolução da alma é \'$stage\' no mapa Navamsa.';
  }

  @override
  String get lpD9JupiterDignity => 'Dignidade de Júpiter';

  @override
  String get lpD9DharmaMultiplier => 'Multiplicador de dharma';

  @override
  String get lpD60Label => 'Assinatura de Vida Passada D60';

  @override
  String get lpKarmaType => 'Tipo de carma de vida passada';

  @override
  String get lpKetuMastery => 'Maestria de Ketu de vida passada';

  @override
  String get lpRahuGrowthDir => 'Direção de crescimento de Rahu';

  @override
  String get lpYogasTitle => 'Yogas de Fortuna e Bloqueios de Sorte';

  @override
  String get lpFortuneBoost => 'Impulso de Fortuna';

  @override
  String get lpLuckDrain => 'Drenagem de Sorte';

  @override
  String get lpFortuneBoosters => 'Impulsionadores de Fortuna';

  @override
  String get lpLuckBlocks => 'Bloqueios de Sorte';

  @override
  String get lpPurposeTitle => 'Domínios de Propósito e Fama';

  @override
  String get lpDomainLeadership => 'Liderança';

  @override
  String get lpDomainWisdom => 'Sabedoria e Ensino';

  @override
  String get lpDomainService => 'Serviço';

  @override
  String get lpDomainHealing => 'Cura';

  @override
  String get lpDomainCreative => 'Expressão Criativa';

  @override
  String get lpPrimaryDomainBadge => 'Principal';

  @override
  String get lpFameRecognition => 'Fama e Reconhecimento';

  @override
  String get lpSocialInfluence => 'Influência Social';

  @override
  String get lpRecognitionDomain => 'Campo de Reconhecimento';

  @override
  String get lpPublicImage => 'Imagem Pública';

  @override
  String get lpHistoricalImpact => 'Potencial de impacto histórico';

  @override
  String get lpTimelineTitle => 'Linha do Tempo de Fortuna e Vida';

  @override
  String get lpCurrentPhase => 'Fase Atual de Fortuna';

  @override
  String get lpJupiterReturn => 'Retorno de Júpiter';

  @override
  String get lpSaturnReturn => 'Retorno de Saturno';

  @override
  String get lpSadeSati => 'Sade Sati';

  @override
  String get lpGoldenWindow => 'Janela Dourada';

  @override
  String get lpTransformationWindow => 'Janela de Transformação';

  @override
  String get lpPeakYears => 'Anos de Pico de Fortuna';

  @override
  String get lpChallengingYears => 'Anos Desafiadores';

  @override
  String get lpMilestonesTitle => 'Principais Marcos e Pontos de Virada';

  @override
  String get lpFirstTurningPoint => 'Primeiro Grande Ponto de Virada';

  @override
  String get lpMidlifeTransform => 'Transformação da Meia-Idade';

  @override
  String get lpLateLifeFulfillment => 'Realização na Vida Tardia';

  @override
  String lpDharmicMilestone(Object age) {
    return 'Marco Dhármico (Idade $age)';
  }

  @override
  String lpAgeLabel(Object age) {
    return 'Idade $age';
  }

  @override
  String get lpDestinyTitle => 'Destino vs Livre-Arbítrio';

  @override
  String get lpDestinyStat => 'Peso do Destino';

  @override
  String get lpFreeWillStat => 'Alavancagem do Livre-Arbítrio';

  @override
  String get lpFateStrength => 'Força da Assinatura do Destino';

  @override
  String get lpSelfCreation => 'Capacidade de Autocriação';

  @override
  String get lpEffortGrace => 'Esforço vs graça';

  @override
  String get lpKarmicTitle => 'Lições Cármicas';

  @override
  String get lpRahuGrowthLabel => 'Rahu — Desafio de Crescimento';

  @override
  String get lpKetuSurrenderLabel => 'Ketu — Tema de Entrega';

  @override
  String get lpSaturnLessonLabel => 'Saturno — Lição de Disciplina';

  @override
  String get lpTestDifficulty => 'Dificuldade do Teste de Vida';

  @override
  String get lpLessonsInProgress => 'Lições em Andamento';

  @override
  String get lpSoulContract => 'Áreas de Contrato da Alma';

  @override
  String get lpSoulExperience => 'O Que Sua Alma Veio Experimentar';

  @override
  String get lpSoulMastery => 'O Que Sua Alma Veio Dominar';

  @override
  String get lpSpiritualTitle => 'Caminho Espiritual';

  @override
  String get lpSpiritualInclination => 'Inclinação Espiritual';

  @override
  String get lpMeditationReceptivity => 'Receptividade à Meditação';

  @override
  String get lpTeacherKarma => 'Carma de Professor/Guru';

  @override
  String get lpPilgrimageBenefit => 'Benefício de Peregrinação';

  @override
  String get lpSelfRealization => 'Potencial de Autorrealização';

  @override
  String get lpDivineConnection => 'Conexão Divina';

  @override
  String get lpTraditionAffinity => 'Afinidade com tradições';

  @override
  String get lpIntuitionStrength => 'Força da intuição';

  @override
  String get lpMantraEfficacy => 'Eficácia de oração/mantra';

  @override
  String get lpInnerGuidance => 'Confiança na orientação interior';

  @override
  String get lpPropheticDreams => 'Sensibilidade a sonhos proféticos';

  @override
  String get lpDifficultyTitle => 'Dificuldades e Desafios de Vida';

  @override
  String get lpEarlyLife => 'Início da Vida';

  @override
  String get lpMidlife => 'Meia-Idade';

  @override
  String get lpLateLife => 'Vida Tardia';

  @override
  String get lpStruggleToSuccess => 'Carma de Luta ao Sucesso';

  @override
  String get lpUnlivedLifeRisk => 'Risco de Vida Não Vivida';

  @override
  String get lpChallenges => 'Desafios de Vida';

  @override
  String get lpFortuneDrains => 'Drenos Crônicos de Fortuna';

  @override
  String get lpRegretAreas => 'Áreas Vulneráveis a Arrependimento';

  @override
  String get lpRedFlags => 'Sinais de Alerta de Direção';

  @override
  String get lpBlessingsTitle => 'Bênçãos e Tema Central de Vida';

  @override
  String get lpKarmicRoot => 'Raiz cármica';

  @override
  String get lpBlessingsList => 'Suas Bênçãos';

  @override
  String get lpFulfillmentPriorities => 'Prioridades de Realização';

  @override
  String get lpImprovementTitle => 'Plano de Melhoria';

  @override
  String get lpDharmaPriorities => 'Prioridades de Dharma';

  @override
  String get lpRoadmapTitle => 'Seu Roteiro do Destino';

  @override
  String get lpStrategy => 'Estratégia';

  @override
  String get lpFulfillmentPotential => 'Potencial de Realização';

  @override
  String get lpNext12Focus => 'Foco para os Próximos 12 Meses';

  @override
  String get lpLayerD1 => 'Mapa Natal (D1)';

  @override
  String get lpLayerD9 => 'Navamsa (D9)';

  @override
  String get lpLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get lpLayerDasha => 'Timing de Dasha';

  @override
  String get lpLayerTransit => 'Trânsitos Atuais';

  @override
  String get lpTopicPurpose => 'Meu propósito de vida';

  @override
  String get lpTopicFortune => 'Meus yogas de fortuna';

  @override
  String get lpTopicKarma => 'Minhas lições cármicas';

  @override
  String get lpTopicMilestones => 'Próximos marcos';

  @override
  String get lpTopicDestiny => 'Destino vs livre-arbítrio';

  @override
  String get lpTopicSpiritual => 'Meu caminho espiritual';

  @override
  String get lpTopicChallenges => 'Meus desafios de vida';

  @override
  String get lpTopicTiming => 'Melhores janelas de timing';

  @override
  String get dbSubtitle => 'Relatório Védico de Dívidas e Recuperação com IA';

  @override
  String get dbTitle => 'Dívidas e Recuperação';

  @override
  String get dbSnapshotHeader => 'Resumo de Recuperação de Dívidas';

  @override
  String dbHeroSummary(
    Object phase,
    Object personality,
    Object probability,
    Object years,
  ) {
    return 'Você está atualmente em uma fase \'$phase\' com uma abordagem $personality em relação ao dinheiro. Nossa análise mostra $probability% de chance de ficar livre de dívidas em cerca de $years anos.';
  }

  @override
  String get dbGaugeCapacity => 'Capacidade de Recuperação';

  @override
  String get dbGaugeProbability => 'Chance de Recuperação';

  @override
  String get dbGaugeFreedomNow => 'Liberdade de Dívidas Agora';

  @override
  String get dbGaugeDti => 'Saúde da Renda';

  @override
  String get dbGaugeResilience => 'Resiliência';

  @override
  String get dbChipCleanKarma => 'Carma de dívida limpo';

  @override
  String get dbChipStrongRecovery => 'Forte capacidade de recuperação';

  @override
  String get dbChipHealthyDti => 'Relação dívida-renda saudável';

  @override
  String get dbChipResilient => 'Alta resiliência psicológica';

  @override
  String get dbChipCycleBreakable => 'O ciclo de dívidas pode ser quebrado';

  @override
  String get dbChipLowReindebt => 'Baixo risco de reendividamento';

  @override
  String get dbChipGoodNegotiator => 'Boas chances de negociação';

  @override
  String get dbProfileTitle => 'Seu Perfil de Dívida';

  @override
  String get dbPhaseLabel => 'Fase atual';

  @override
  String get dbPrimaryCategoryLabel => 'Categoria principal';

  @override
  String get dbKarakaLabel => 'Karaka da Dívida';

  @override
  String get dbProtectorLabel => 'Proteção contra Credores';

  @override
  String get dbSecondaryCategories => 'Categorias secundárias';

  @override
  String get dbUnsecuredRatio => 'Proporção de dívida não garantida';

  @override
  String get dbKarakaTitle => 'Seus Planetas da Dívida';

  @override
  String get dbKarakaSubtitle =>
      'O quanto cada planeta apoia sua recuperação de dívidas';

  @override
  String get dbVerificationTitle => 'Verificado em Múltiplos Mapas (D6)';

  @override
  String get dbD6Label => 'Mapa D6 de Dívidas e Inimigos';

  @override
  String get dbD6LordDignity => 'Força do senhor da Casa 6';

  @override
  String get dbD6Severity => 'Severidade do carma de dívida';

  @override
  String get dbD6Multiplier => 'Multiplicador de dívida D6';

  @override
  String get dbYogasTitle => 'Yogas de Dívida e Proteções';

  @override
  String get dbPressureNow => 'Pressão de Dívida Agora';

  @override
  String get dbRecoveryBoost => 'Impulso de Recuperação';

  @override
  String get dbClearingLabel => 'Yogas de Quitação de Dívida';

  @override
  String get dbCreatingLabel => 'Yogas de Criação de Dívida';

  @override
  String get dbCategoriesTitle => 'Categorias de Dívida a Observar';

  @override
  String get dbCategoriesSubtitle =>
      'Quais tipos de dívida precisam de mais atenção';

  @override
  String get dbTimelineTitle => 'Cronograma de Liberdade de Dívidas';

  @override
  String get dbFreeWindowLabel => 'JANELA DE LIBERDADE DE DÍVIDAS';

  @override
  String get dbClearanceEstimate => 'Estimativa de quitação total';

  @override
  String get dbPeakYears => 'Anos de Pico de Dívida';

  @override
  String get dbClearanceYears => 'Anos de Quitação';

  @override
  String get dbBorrowTitle => 'Guia de Empréstimo Inteligente';

  @override
  String get dbLoanSuitability => 'Adequação do Empréstimo';

  @override
  String get dbBestLoanType => 'Melhor Tipo de Empréstimo';

  @override
  String get dbLeverageCeiling => 'Teto de Alavancagem';

  @override
  String get dbNegotiationSuccess => 'Sucesso na Negociação';

  @override
  String get dbCreditorAggression => 'Risco de Pressão de Credores';

  @override
  String get dbLegalEscalation => 'Risco de Escalada Legal';

  @override
  String get dbNegotiationApproach => 'Abordagem recomendada';

  @override
  String get dbAvoidLoanTypes => 'Tipos de Empréstimo a Evitar';

  @override
  String get dbRiskTitle => 'Observação de Riscos e Vulnerabilidades';

  @override
  String get dbRiskDefault => 'Risco de Inadimplência';

  @override
  String get dbRiskDefaultExp =>
      'A chance de deixar de pagar uma parcela programada de forma grave o suficiente para acionar o status de inadimplência com um credor.';

  @override
  String get dbRiskDefaultFix =>
      'Automatize os pagamentos mínimos e mantenha uma reserva de 1 mês para que um único ciclo de renda perdido não gere um efeito cascata.';

  @override
  String get dbRiskBankruptcy => 'Risco de Falência';

  @override
  String get dbRiskBankruptcyExp =>
      'A probabilidade de a dívida crescer além do que a renda e os ativos podem realisticamente cobrir.';

  @override
  String get dbRiskBankruptcyFix =>
      'Faça uma revisão profissional de dívidas antes de contrair qualquer novo empréstimo ou linha de crédito.';

  @override
  String get dbRiskAssetSeizure => 'Risco de Apreensão de Bens';

  @override
  String get dbRiskAssetSeizureExp =>
      'A chance de a inadimplência de um empréstimo garantido levar um credor a retomar a garantia ou o imóvel.';

  @override
  String get dbRiskAssetSeizureFix =>
      'Priorize os pagamentos de empréstimos garantidos primeiro e refinancie cedo se uma lacuna de pagamento parecer provável.';

  @override
  String get dbRiskChronic => 'Risco Crônico de Reendividamento';

  @override
  String get dbRiskChronicExp =>
      'A tendência de voltar a se endividar mesmo depois de quitar a dívida atual.';

  @override
  String get dbRiskChronicFix =>
      'Construa um fundo de emergência dedicado antes de aumentar os gastos com o estilo de vida após a quitação.';

  @override
  String get dbReindebtTrigger => 'Gatilho de Reendividamento';

  @override
  String get dbCycleBreakFeasibility => 'Viabilidade de Romper o Ciclo';

  @override
  String get dbMajorRisks => 'Principais Riscos';

  @override
  String get dbHiddenSignals => 'Sinais Ocultos de Dívida';

  @override
  String get dbCrisisTitle => 'Preparação para Crises';

  @override
  String get dbCrisisSubtitle =>
      'Como identificar problemas cedo e responder com calma';

  @override
  String get dbWarningSigns => 'Sinais de Alerta Precoce';

  @override
  String get dbMitigationActions => 'O Que Fazer a Respeito';

  @override
  String get dbFamilyTitle => 'Dívida Familiar e Ancestral';

  @override
  String get dbInheritedDebtProb => 'Chance de Dívida Herdada';

  @override
  String get dbFamilyDrag => 'Peso da Dívida Familiar';

  @override
  String get dbInheritedSource => 'Fonte provável';

  @override
  String get dbCoreBlockerLabel => 'BLOQUEIO CENTRAL';

  @override
  String get dbPsychologyTitle => 'Sua Psicologia Financeira';

  @override
  String get dbResilience => 'Resiliência';

  @override
  String get dbDiscipline => 'Disciplina sob Pressão';

  @override
  String get dbSocialSupport => 'Apoio Social';

  @override
  String get dbDepressionRisk => 'Vulnerabilidade ao Estresse Financeiro';

  @override
  String get dbStressTolerance => 'Tolerância ao estresse';

  @override
  String get dbRootCause => 'Causa Raiz Comportamental';

  @override
  String get dbImprovementTitle => 'Plano de Melhoria';

  @override
  String get dbRoadmapTitle => 'Seu Roteiro para Ficar Livre de Dívidas';

  @override
  String get dbRecoveryProbability => 'Probabilidade de Recuperação';

  @override
  String get dbClearanceTimeline => 'Cronograma de Quitação';

  @override
  String get dbYears => 'anos';

  @override
  String get dbDtiHealth => 'Saúde da Relação Dívida-Renda';

  @override
  String get dbDtiCategory => 'Categoria de DTI';

  @override
  String get dbBreakEvenMonths => 'Meses até o equilíbrio';

  @override
  String get dbIncomeAcceleration => 'Crescimento de renda necessário';

  @override
  String get dbLayerD1 => 'Mapa Natal (D1)';

  @override
  String get dbLayerD6 => 'Dívidas e Inimigos (D6)';

  @override
  String get dbLayerD9 => 'Navamsa (D9)';

  @override
  String get dbLayerDasha => 'Timing de Dasha';

  @override
  String get dbLayerTransit => 'Trânsitos Atuais';

  @override
  String get dbTopicRecovery => 'Meu cronograma de recuperação';

  @override
  String get dbTopicNegotiate => 'Negociar com credores';

  @override
  String get dbTopicBorrowing => 'É seguro pedir emprestado agora';

  @override
  String get dbTopicCrisis => 'Preparar-se para uma crise';

  @override
  String get dbTopicAncestral => 'Carma de dívida ancestral';

  @override
  String get dbTopicTimeline => 'Melhores anos para quitar dívidas';

  @override
  String get dbTopicPsychology => 'Minha psicologia financeira';

  @override
  String get dbTopicCategories => 'Quais dívidas priorizar';

  @override
  String get mnSubtitle => 'Relatório Védico de Bem-Estar com IA';

  @override
  String get mnTitle => 'Mental e Estresse';

  @override
  String get mnSnapshotHeader => 'Resumo de Bem-Estar';

  @override
  String get mnResilience => 'Resiliência';

  @override
  String get mnStability => 'Estabilidade';

  @override
  String get mnEmotionalBalance => 'Equilíbrio Emocional';

  @override
  String get mnInnerCalm => 'Calma Interior';

  @override
  String get mnSelfAwareness => 'Autoconsciência';

  @override
  String get mnStatusThriving => 'Em Plena Forma';

  @override
  String get mnStatusSteady => 'Estável e Equilibrado';

  @override
  String get mnStatusBuildingStrength => 'Construindo Força';

  @override
  String get mnStatusNeedsGentleCare => 'Precisa de Cuidado Suave';

  @override
  String get mnStatusReachOut => 'Hora de Buscar Apoio';

  @override
  String get mnChipStable => 'Emocionalmente Estável';

  @override
  String get mnChipSupported => 'Bem Apoiado';

  @override
  String get mnChipSelfAware => 'Altamente Autoconsciente';

  @override
  String get mnChipResilient => 'Se Recupera Bem';

  @override
  String get mnChipSecureAttachment => 'Apego Seguro';

  @override
  String get mnChipHealingReady => 'Pronto para Curar';

  @override
  String get mnChipMindBodyBalance => 'Equilíbrio Mente-Corpo';

  @override
  String get mnSupportBannerTitle => 'Uma Nota Gentil';

  @override
  String get mnSupportBannerBody =>
      'Seu mapa sugere que este pode ser um bom momento para contar com apoio extra — um amigo de confiança, familiar ou profissional. Pedir ajuda é um sinal de força, não de fraqueza.';

  @override
  String get mnProfileTitle => 'Seu Perfil Emocional';

  @override
  String get mnStressDriver => 'Fator de Estresse';

  @override
  String get mnStabilityAnchor => 'Âncora de Estabilidade';

  @override
  String get mnSoulLevelKarma => 'Padrão em Nível de Alma';

  @override
  String get mnSubtleSignature => 'Assinatura Emocional Sutil';

  @override
  String get mnKarakaTitle => 'Sua Mente e os Planetas';

  @override
  String get mnKarakaSubtitle => 'Quais planetas moldam seu mundo interior';

  @override
  String get mnYogasTitle => 'Pontos Fortes e Áreas de Crescimento';

  @override
  String get mnCurrentPhase => 'Fase Atual';

  @override
  String get mnCurrentStressLevel => 'Nível de Estresse Atual';

  @override
  String get mnRecentStrain => 'Tensão Emocional Recente';

  @override
  String get mnStrengths => 'Pontos Fortes';

  @override
  String get mnGrowthAreas => 'Áreas de Crescimento';

  @override
  String get mnSadeSatiStatus => 'Status do Sade Sati';

  @override
  String get mnVerificationTitle => 'Verificado em Múltiplos Mapas';

  @override
  String get mnD9Confirmation => 'Confirmação D9';

  @override
  String get mnD30Confirmation => 'Confirmação D30';

  @override
  String get mnMoodPatternsTitle => 'Padrões de Humor e Ansiedade';

  @override
  String get mnMoodPatternsSubtitle => 'Consciência gentil, não um diagnóstico';

  @override
  String get mnAnxietyPatterns => 'Padrões de Ansiedade';

  @override
  String get mnMoodPatterns => 'Padrões de Humor Baixo';

  @override
  String get mnPrimaryPattern => 'Padrão Primário';

  @override
  String get mnRumination => 'Tendência a Pensar Demais';

  @override
  String get mnHypervigilance => 'Hiperalerta';

  @override
  String get mnHopelessnessVuln => 'Sensibilidade ao Humor Baixo';

  @override
  String get mnEnergyDepletion => 'Tendência de Esgotamento de Energia';

  @override
  String get mnMotivationBaseline => 'Nível Base de Motivação';

  @override
  String get mnRegulationTitle => 'Regulação Emocional e Enfrentamento';

  @override
  String get mnEmotionalRegulation => 'Regulação Emocional';

  @override
  String get mnSelfSoothing => 'Capacidade de Autoacalmar-se';

  @override
  String get mnExpressionStyle => 'Estilo de Expressão';

  @override
  String get mnRecoveryTime => 'Tempo de Recuperação';

  @override
  String get mnTriggerIntensity => 'Intensidade dos Gatilhos';

  @override
  String get mnHealthyCoping => 'Hábitos Saudáveis de Enfrentamento';

  @override
  String get mnWatchFor => 'Observe com Atenção';

  @override
  String get mnSleepTitle => 'Sono e Descanso';

  @override
  String get mnSleepQuality => 'Qualidade do Sono';

  @override
  String get mnSleepAsRegulator => 'Sono como Regulador Emocional';

  @override
  String get mnInsomniaTendency => 'Tendência a Noites Agitadas';

  @override
  String get mnNightmareTendency => 'Tendência a Sonhos Vívidos';

  @override
  String get mnSleepHygienePriority => 'Prioridade de Higiene do Sono';

  @override
  String get mnBurnoutTitle => 'Esgotamento e Energia';

  @override
  String get mnBurnoutVulnerability => 'Sensibilidade ao Esgotamento';

  @override
  String get mnBurnoutRecovery => 'Capacidade de Recuperação do Esgotamento';

  @override
  String get mnBurnoutStage => 'Estágio Atual de Esgotamento';

  @override
  String get mnSelfDrivingTendency => 'Tendência à Autocobrança';

  @override
  String get mnBurnoutTriggers => 'Gatilhos de Esgotamento';

  @override
  String get mnConnectionTitle => 'Conexão e Apoio';

  @override
  String get mnSocialSupport => 'Qualidade do Apoio Social';

  @override
  String get mnLonelinessVuln => 'Sensibilidade à Solidão';

  @override
  String get mnSolitudeNeed => 'Necessidade de Solidão';

  @override
  String get mnSocialComfort => 'Conforto Social';

  @override
  String get mnTraumaSensitivity => 'Sensibilidade a Traumas';

  @override
  String get mnHealingReadiness => 'Prontidão para Cura';

  @override
  String get mnProcessingStyle => 'Estilo de Processamento';

  @override
  String get mnMindBodyIntegration => 'Integração Mente-Corpo';

  @override
  String get mnPtsdVuln => 'Sensibilidade à Resposta a Traumas';

  @override
  String get mnSelfAwarenessTitle => 'Autoconsciência e Crescimento';

  @override
  String get mnSelfAwarenessScore => 'Autoconsciência';

  @override
  String get mnEmotionalVocabulary => 'Vocabulário Emocional';

  @override
  String get mnTherapyReadiness => 'Prontidão para Terapia';

  @override
  String get mnJournalingBenefit => 'Benefício de Escrever um Diário';

  @override
  String get mnInnerDialogue => 'Qualidade do Diálogo Interior';

  @override
  String get mnAwarenessOfPatterns => 'Consciência de Padrões';

  @override
  String get mnEscapePatternVuln => 'Sensibilidade a Padrões de Fuga';

  @override
  String get mnEscapeChannels => 'Observe com Atenção';

  @override
  String get mnHealthyAlternatives => 'Alternativas Saudáveis';

  @override
  String get mnTherapyFitTitle => 'Compatibilidade com Terapia e Apoio';

  @override
  String get mnCrisisSupportRec => 'Recomendação de Apoio';

  @override
  String get mnSupportNetwork => 'Ative Sua Rede de Apoio';

  @override
  String get mnSelfAdvocacy => 'Prontidão para Autodefesa';

  @override
  String get mnMedicationReceptivity => 'Receptividade a Medicação';

  @override
  String get mnTimelineTitle => 'Linha do Tempo de Bem-Estar';

  @override
  String get mnPeakWellnessYears => 'Anos de Pico de Bem-Estar';

  @override
  String get mnExtraCareYears => 'Anos que Pedem Autocuidado Extra';

  @override
  String get mnTransformationWindows => 'Janelas de Transformação Positiva';

  @override
  String get mnTherapyWindow => 'Janela Recomendada para Terapia';

  @override
  String get mnPracticesTitle => 'Práticas Diárias de Bem-Estar';

  @override
  String get mnMorningPractices => 'Práticas Matinais';

  @override
  String get mnEveningPractices => 'Práticas Noturnas';

  @override
  String get mnBreathwork => 'Trabalho Respiratório';

  @override
  String get mnMovement => 'Movimento';

  @override
  String get mnNutrition => 'Nutrição';

  @override
  String get mnNatureExposure => 'Necessidade de Contato com a Natureza';

  @override
  String get mnDigitalDetox => 'Necessidade de Desintoxicação Digital';

  @override
  String get mnImprovementTitle => 'Plano de Melhoria';

  @override
  String get mnReliabilityTitle => 'Confiabilidade';

  @override
  String get mnLayerD1 => 'Mapa Natal (D1)';

  @override
  String get mnLayerD9 => 'Mapa da Alma (D9)';

  @override
  String get mnLayerD30 => 'Mapa D30';

  @override
  String get mnLayerDasha => 'Timing de Dasha';

  @override
  String get mnLayerTransit => 'Trânsitos';

  @override
  String get mnTopicResilience => 'Quão resiliente sou emocionalmente?';

  @override
  String get mnTopicCoping =>
      'Quais são minhas melhores estratégias de enfrentamento?';

  @override
  String get mnTopicSleep => 'Como posso melhorar meu sono?';

  @override
  String get mnTopicBurnout => 'Estou em risco de esgotamento?';

  @override
  String get mnTopicTherapy => 'Qual estilo de terapia combina comigo?';

  @override
  String get mnTopicPractices => 'Quais práticas diárias mais me ajudam?';

  @override
  String get mnTopicTiming => 'Quais são meus melhores anos de bem-estar?';

  @override
  String get mnTopicSupport => 'Como construo uma rede de apoio forte?';

  @override
  String get lgSubtitle => 'Relatório Védico Jurídico com IA';

  @override
  String get lgTitle => 'Questões Legais e Disputas';

  @override
  String get lgSnapshotHeader => 'Resumo Jurídico';

  @override
  String get lgResilience => 'Resiliência Jurídica';

  @override
  String get lgResolutionCapacity => 'Capacidade de Resolução';

  @override
  String get lgVictoryPotential => 'Potencial de Vitória';

  @override
  String get lgLegalSafety => 'Segurança Jurídica';

  @override
  String get lgNegotiationSkill => 'Habilidade de Negociação';

  @override
  String get lgStatusExcellent => 'Excelente';

  @override
  String get lgStatusStrong => 'Forte';

  @override
  String get lgStatusModerate => 'Moderado';

  @override
  String get lgStatusDeveloping => 'Em Desenvolvimento';

  @override
  String get lgStatusChallenging => 'Desafiador';

  @override
  String get lgChipResolver => 'Hábil Resolvedor';

  @override
  String get lgChipWinner => 'Vitórias em Casos Fortes';

  @override
  String get lgChipNegotiator => 'Negociador Natural';

  @override
  String get lgChipDocumented => 'Bem Documentado';

  @override
  String get lgChipLowRisk => 'Baixo Risco Jurídico';

  @override
  String get lgChipMoralAuthority => 'Autoridade Moral';

  @override
  String get lgChipLegalAptitude => 'Aptidão Jurídica';

  @override
  String get lgProfileTitle => 'Seu Perfil Jurídico e Carma';

  @override
  String get lgPrimaryDriver => 'Fator Principal';

  @override
  String get lgDharmaAnchor => 'Âncora de Dharma';

  @override
  String get lgAggressionMarker => 'Marcador de Agressividade';

  @override
  String get lgDocumentationKaraka => 'Qualidade da Documentação';

  @override
  String get lgKarakaTitle => 'Seus Planetas Jurídicos';

  @override
  String get lgKarakaSubtitle => 'Quais planetas moldam sua fortuna jurídica';

  @override
  String get lgYogasTitle => 'Yogas Jurídicos e Proteções';

  @override
  String get lgCurrentPhase => 'Fase Atual';

  @override
  String get lgProtections => 'Proteções';

  @override
  String get lgDisputePressures => 'Pressões de Disputa';

  @override
  String get lgVerificationTitle => 'Verificado em Múltiplos Mapas';

  @override
  String get lgD6Litigation => 'Mapa de Litígio D6';

  @override
  String get lgD9Dharma => 'Mapa de Dharma D9';

  @override
  String get lgMoralAuthority => 'Autoridade Moral';

  @override
  String get lgVictoryTitle => 'Análise de Vitória';

  @override
  String get lgAsPlaintiff => 'Como Autor';

  @override
  String get lgAsDefendant => 'Como Réu';

  @override
  String get lgSettlementPreference => 'Preferência por Acordo';

  @override
  String get lgDisputeCategoriesTitle => 'Categorias de Disputa a Observar';

  @override
  String get lgLowRiskCategories => 'Categorias de Baixo Risco';

  @override
  String get lgConflictStyleTitle => 'Estilo de Conflito e Inimizades';

  @override
  String get lgConfrontationComfort => 'Conforto com Confronto';

  @override
  String get lgArgumentPersuasiveness => 'Persuasão Argumentativa';

  @override
  String get lgEmotionalRegulation => 'Regulação Emocional';

  @override
  String get lgGrudgeHolding => 'Tendência a Guardar Rancor';

  @override
  String get lgEnemyAnalysisLabel => 'Análise de Inimigos';

  @override
  String get lgVisibleEnemies => 'Inimigos Visíveis';

  @override
  String get lgHiddenEnemies => 'Inimigos Ocultos';

  @override
  String get lgWorkplaceEnemies => 'Inimigos no Trabalho';

  @override
  String get lgFamilyEnemies => 'Inimigos na Família';

  @override
  String get lgLegalEnemies => 'Inimigos Jurídicos';

  @override
  String get lgEnemyDefeatCapacity => 'Capacidade de Derrotar Inimigos';

  @override
  String get lgCriminalFinancialTitle =>
      'Observação de Risco Criminal e Financeiro';

  @override
  String get lgCriminalRisk => 'Risco de Envolvimento Criminal';

  @override
  String get lgVictimOfCrime => 'Chance de Ser Vítima de Crime';

  @override
  String get lgFalseAccusation => 'Risco de Acusação Falsa';

  @override
  String get lgImprisonmentRisk => 'Risco de Prisão';

  @override
  String get lgTaxDisputeRisk => 'Risco de Disputa Fiscal';

  @override
  String get lgFinancialFraudRisk => 'Risco de Fraude Financeira';

  @override
  String get lgBusinessLitigationRisk => 'Risco de Litígio Empresarial';

  @override
  String get lgBankruptcyRisk => 'Risco de Falência';

  @override
  String get lgAuditVulnerability => 'Vulnerabilidade a Auditorias';

  @override
  String get lgProtectionPriority => 'Prioridade de Proteção';

  @override
  String get lgContractsTitle => 'Contratos e Negociação';

  @override
  String get lgContractClarity => 'Clareza Contratual';

  @override
  String get lgDocumentationDiscipline => 'Disciplina de Documentação';

  @override
  String get lgFinePrintAwareness => 'Atenção às Letras Miúdas';

  @override
  String get lgSignatureCaution => 'Cautela ao Assinar';

  @override
  String get lgMediationReceptivity => 'Receptividade à Mediação';

  @override
  String get lgNegotiationSkillFull => 'Habilidade de Negociação';

  @override
  String get lgCompromiseWillingness => 'Disposição para o Compromisso';

  @override
  String get lgFaceSavingNeeds => 'Necessidade de Preservar a Imagem';

  @override
  String get lgMediatorHireRecommendation =>
      'Recomendação de Contratar Mediador';

  @override
  String get lgTypicalContractIssues => 'Problemas Contratuais Típicos';

  @override
  String get lgCareerFitTitle => 'Compatibilidade com Carreira Jurídica';

  @override
  String get lgProfessionAffinity => 'Afinidade Profissional';

  @override
  String get lgRoleFit => 'Melhor Função';

  @override
  String get lgLawStudentSuccess => 'Sucesso como Estudante de Direito';

  @override
  String get lgBarExamSuccess => 'Sucesso no Exame da Ordem';

  @override
  String get lgTimelineTitle => 'Linha do Tempo Jurídica';

  @override
  String get lgNewMatterChance => 'Chance de Novo Caso (Próximos 12 Meses)';

  @override
  String get lgOngoingCaseOutcome => 'Resultado do Caso em Andamento';

  @override
  String get lgRecommendedAction => 'Ação Recomendada';

  @override
  String get lgPeakDisputeYears => 'Anos de Pico de Disputas';

  @override
  String get lgClarityYears => 'Anos de Clareza Jurídica';

  @override
  String get lgAvoidancePeriods => 'Períodos Críticos a Evitar';

  @override
  String get lgFavorableWindows => 'Janelas Favoráveis de Resolução';

  @override
  String get lgRisksTitle => 'Riscos e Vulnerabilidades';

  @override
  String get lgChronicVulnerabilities => 'Vulnerabilidades Crônicas';

  @override
  String get lgAvoidDashaPeriods => 'Períodos de Dasha a Observar';

  @override
  String get lgPreventivePriorities => 'Prioridades Preventivas';

  @override
  String get lgRedFlags => 'Situações de Alerta';

  @override
  String get lgImprovementTitle => 'Plano de Melhoria';

  @override
  String get lgReliabilityTitle => 'Confiabilidade';

  @override
  String get lgLayerD1 => 'Mapa Natal (D1)';

  @override
  String get lgLayerD6 => 'Mapa de Litígio (D6)';

  @override
  String get lgLayerD9 => 'Mapa de Dharma (D9)';

  @override
  String get lgLayerDasha => 'Timing de Dasha';

  @override
  String get lgLayerTransit => 'Trânsitos';

  @override
  String get lgTopicWinChance => 'Quais são minhas chances de vencer?';

  @override
  String get lgTopicStrategy => 'Melhor estratégia jurídica para mim?';

  @override
  String get lgTopicContract => 'Riscos contratuais a observar?';

  @override
  String get lgTopicTiming => 'Melhor timing para resolver disputas?';

  @override
  String get lgTopicSettlement => 'Devo fazer acordo ou lutar?';

  @override
  String get lgTopicEnemies => 'Quem são meus inimigos ocultos?';

  @override
  String get lgTopicProtection => 'Como me proteger juridicamente?';

  @override
  String get lgTopicCareer => 'Sou adequado para uma carreira jurídica?';

  @override
  String get prSubtitle => 'Relatório Védico de Propriedades com IA';

  @override
  String get prTitle => 'Propriedades e Bens';

  @override
  String get prSnapshotHeader => 'Resumo de Propriedades';

  @override
  String get prAcquisitionCapacity => 'Capacidade de Aquisição';

  @override
  String get prHomeOwnership => 'Posse de Imóvel';

  @override
  String get prWealthPotential => 'Potencial de Riqueza';

  @override
  String get prRentalIncome => 'Renda de Aluguel';

  @override
  String get prLandOwnership => 'Posse de Terras';

  @override
  String get prStatusExcellent => 'Excelente';

  @override
  String get prStatusStrong => 'Forte';

  @override
  String get prStatusModerate => 'Moderado';

  @override
  String get prStatusDeveloping => 'Em Desenvolvimento';

  @override
  String get prStatusChallenging => 'Desafiador';

  @override
  String get prChipHomeOwner => 'Proprietário de Imóvel';

  @override
  String get prChipWealthBuilder => 'Construtor de Riqueza';

  @override
  String get prChipLandOwner => 'Proprietário de Terras';

  @override
  String get prChipInvestor => 'Investidor Imobiliário';

  @override
  String get prChipInheritance => 'Herança Provável';

  @override
  String get prChipVehicle => 'Proprietário de Veículo';

  @override
  String get prChipGlobalAsset => 'Afinidade com Bens Globais';

  @override
  String get prProfileTitle => 'Seu Estilo de Propriedade';

  @override
  String get prHomeAesthetics => 'Estética do Lar';

  @override
  String get prHomeSanctuary => 'Lar como Santuário';

  @override
  String get prComfortInvestment => 'Investimento em Conforto';

  @override
  String get prVastuPriority => 'Prioridade de Vastu';

  @override
  String get prNaturalElements => 'Elementos Naturais';

  @override
  String get prNextActionLabel => 'Próxima Ação';

  @override
  String get prKarakaTitle => 'Seus Planetas de Propriedade';

  @override
  String get prKarakaSubtitle => 'Quais planetas moldam sua sorte imobiliária';

  @override
  String get prPrimaryKaraka => 'Karaka Primário';

  @override
  String get prDurableAsset => 'Karaka de Bens Duráveis';

  @override
  String get prYogasTitle => 'Yogas e Doshas de Propriedade';

  @override
  String get prCurrentPhase => 'Fase Atual';

  @override
  String get prBoosters => 'Impulsionadores';

  @override
  String get prDrains => 'Drenos';

  @override
  String get prVerificationTitle => 'Verificado em Múltiplos Mapas';

  @override
  String get prD4Property => 'Mapa de Propriedade D4';

  @override
  String get prD16Vehicle => 'Mapa de Veículo D16';

  @override
  String get prVehicleFit => 'Compatibilidade com Veículos';

  @override
  String get prJourneyTitle => 'Jornada e Cronograma de Posse';

  @override
  String get prFirstHomeAge => 'Idade do Primeiro Imóvel';

  @override
  String get prFirstHomeType => 'Tipo do Primeiro Imóvel';

  @override
  String get prMultipleHomes => 'Múltiplos Imóveis';

  @override
  String get prNewPropertySoon => 'Nova Propriedade em Breve';

  @override
  String get prFirstMajorWindow => 'Primeira Grande Janela';

  @override
  String get prBuyingWindow => 'Janela de Compra';

  @override
  String get prConstructionWindow => 'Janela de Construção';

  @override
  String get prNextOpportunity => 'Próxima Oportunidade';

  @override
  String get prLifetimePropertyCount => 'Número de Propriedades na Vida';

  @override
  String get prInheritanceTitle => 'Herança e Propriedade Familiar';

  @override
  String get prMaternalInheritance => 'Herança Materna';

  @override
  String get prPaternalInheritance => 'Herança Paterna';

  @override
  String get prAncestralProperty => 'Propriedade Ancestral';

  @override
  String get prFamilyDisputeRisk => 'Risco de Disputa Familiar';

  @override
  String get prInheritanceTiming => 'Timing da Herança';

  @override
  String get prInheritanceType => 'Tipo de Herança';

  @override
  String get prLandInvestTitle =>
      'Terras, Investimentos e Propriedades Globais';

  @override
  String get prPropertyInvestor => 'Pontuação de Investidor Imobiliário';

  @override
  String get prAppreciationLuck => 'Sorte de Valorização';

  @override
  String get prInvestorMindset => 'Mentalidade de Investidor';

  @override
  String get prLandType => 'Tipo de Terreno';

  @override
  String get prRentalCount => 'Número de Imóveis Alugados';

  @override
  String get prMultipleLand => 'Múltiplos Terrenos';

  @override
  String get prFarmEstate => 'Chance de Fazenda / Sítio';

  @override
  String get prGlobalPropertyLabel => 'Propriedade Global';

  @override
  String get prForeignProperty => 'Propriedade no Exterior';

  @override
  String get prNriAffinity => 'Afinidade com Bens no Exterior';

  @override
  String get prVehiclesTitle => 'Veículos';

  @override
  String get prVehicleCount => 'Número de Veículos';

  @override
  String get prVehicleFirstAge => 'Idade do Primeiro Veículo';

  @override
  String get prVehicleCategory => 'Categoria do Veículo';

  @override
  String get prVehicleQuality => 'Qualidade do Veículo';

  @override
  String get prLuxuryAffinity => 'Afinidade com o Luxo';

  @override
  String get prVehicleLossRisk => 'Risco de Perda / Dano do Veículo';

  @override
  String get prLegalRiskTitle => 'Observação de Riscos Jurídicos';

  @override
  String get prBoundaryDisputes => 'Disputas de Limites';

  @override
  String get prPartitionDisputes => 'Disputas de Partilha';

  @override
  String get prTitleIssues => 'Problemas de Título / Documentação';

  @override
  String get prTenantConflict => 'Conflito Inquilino-Proprietário';

  @override
  String get prForcedSale => 'Risco de Venda Forçada';

  @override
  String get prPropertyDamage => 'Risco de Dano à Propriedade';

  @override
  String get prInsurancePriority => 'Prioridade de Seguro';

  @override
  String get prProtectionUrgency => 'Urgência de Proteção';

  @override
  String get prProtectiveFactors => 'Fatores de Proteção';

  @override
  String get prChronicVulnerabilities => 'Vulnerabilidades Crônicas';

  @override
  String get prDueDiligenceTitle => 'Checklist de Due Diligence';

  @override
  String get prPreventiveMeasures => 'Medidas Preventivas';

  @override
  String get prImprovementTitle => 'Plano de Melhoria';

  @override
  String get prReliabilityTitle => 'Confiabilidade';

  @override
  String get prLayerD1 => 'Mapa Natal (D1)';

  @override
  String get prLayerD4 => 'Mapa de Propriedade (D4)';

  @override
  String get prLayerD16 => 'Mapa de Veículo (D16)';

  @override
  String get prLayerDasha => 'Timing de Dasha';

  @override
  String get prLayerTransit => 'Trânsitos';

  @override
  String get prTopicBuying => 'Melhor momento para comprar?';

  @override
  String get prTopicInherit => 'Vou herdar propriedades?';

  @override
  String get prTopicVehicle => 'Quando vou conseguir um veículo?';

  @override
  String get prTopicRental => 'Potencial de renda de aluguel?';

  @override
  String get prTopicLand => 'Chances de posse de terras?';

  @override
  String get prTopicLegal => 'Riscos jurídicos a observar?';

  @override
  String get prTopicForeign => 'Chances de propriedade no exterior?';

  @override
  String get prTopicTiming => 'Melhores janelas de timing para propriedades?';

  @override
  String get edTitle => 'Análise de Educação e Aprendizado';

  @override
  String get edSubtitle => 'Relatório Védico de Educação com IA';

  @override
  String get edSnapshotHeader => 'Resumo da Sua Educação';

  @override
  String get edOverallStrength => 'Força Geral';

  @override
  String get edAcademicSuccess => 'Sucesso Acadêmico';

  @override
  String get edLearningCapacity => 'Capacidade de Aprendizado';

  @override
  String get edIntellect => 'Intelecto';

  @override
  String get edMemory => 'Memória';

  @override
  String get edStatusExcellent => 'Potencial Excelente';

  @override
  String get edStatusStrong => 'Potencial Forte';

  @override
  String get edStatusModerate => 'Potencial Moderado';

  @override
  String get edStatusDeveloping => 'Potencial em Desenvolvimento';

  @override
  String get edStatusChallenging => 'Fase Desafiadora';

  @override
  String get edChipSaraswati => 'Saraswati Yoga';

  @override
  String get edChipGajaKesari => 'Gaja Kesari Yoga';

  @override
  String get edChipBudhaAditya => 'Budha Aditya Yoga';

  @override
  String get edChipResearch => 'Forte Capacidade de Pesquisa';

  @override
  String get edChipScholarship => 'Potencial para Bolsas de Estudo';

  @override
  String get edChipDoctorate => 'Potencial para Doutorado';

  @override
  String get edChipForeign => 'Apoio para Educação no Exterior';

  @override
  String get edChipLifelong => 'Aprendiz Vitalício';

  @override
  String get edLearningStyleTitle => 'Seu Estilo de Aprendizado';

  @override
  String get edSoulPlanet => 'Planeta da Alma';

  @override
  String get edSoulHint =>
      'Seu impulso interior mais profundo e propósito de vida';

  @override
  String get edSubjectPlanet => 'Planeta da Matéria';

  @override
  String get edTechAtmakaraka => 'Atmakaraka (técnico)';

  @override
  String get edTechAmatyakaraka => 'Amatyakaraka (técnico)';

  @override
  String get edSubjectKarakaStrength => 'Força do Karaka da Matéria';

  @override
  String get edFoundationTitle => 'Fundação Educacional';

  @override
  String get edHouse4 => 'Educação Inicial';

  @override
  String get edHouse5 => 'Inteligência';

  @override
  String get edHouse9 => 'Ensino Superior';

  @override
  String get edPurvaPunya => 'Mérito de Vida Passada';

  @override
  String get edStudyPlanetsTitle => 'Seus Planetas de Estudo';

  @override
  String get edYogasTitle => 'Yogas Educacionais em Seu Mapa';

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
      'Nenhum yoga educacional clássico — o sucesso vem do esforço e da disciplina consistentes.';

  @override
  String get edVerificationTitle => 'Verificação em Múltiplos Mapas';

  @override
  String get edD24Learning => 'D24 — Mapa de Aprendizado Profundo';

  @override
  String get edD4Formal => 'D4 — Mapa de Educação Formal';

  @override
  String get edD9Dharma => 'D9 — Mapa de Dharma do Aprendizado';

  @override
  String get edD60Karma => 'D60 — Carma de Aprendizado de Vida Passada';

  @override
  String get edSubjectsTitle => 'Melhores Matérias Para Você';

  @override
  String get edSubjectsSubtitle => 'Classificadas por afinidade com o mapa';

  @override
  String get edLowAffinity => 'Matérias de Menor Afinidade';

  @override
  String get edDegreesTitle => 'Probabilidade de Grau e Nível';

  @override
  String get edExpectedLevel => 'Nível Esperado';

  @override
  String get edDegreeFormal => 'Diploma Formal';

  @override
  String get edDegreePostgrad => 'Pós-Graduação';

  @override
  String get edDegreeDoctorate => 'Doutorado';

  @override
  String get edDegreeForeign => 'Educação no Exterior';

  @override
  String get edTimelineTitle => 'Cronograma de Estudos';

  @override
  String get edEarlySchooling => 'Janela de Educação Inicial';

  @override
  String get edHigherEducation => 'Janela de Ensino Superior';

  @override
  String get edPostgradResearch => 'Janela de Pós-Graduação / Pesquisa';

  @override
  String get edPeakLearningAge => 'Idade de Pico de Aprendizado';

  @override
  String get edPreferencesTitle => 'Preferências de Aprendizado e Apoio';

  @override
  String get edPrefStudyMode => 'Modo de Estudo';

  @override
  String get edPrefTiming => 'Melhor Horário';

  @override
  String get edPrefEnvironment => 'Ambiente';

  @override
  String get edPrefLocation => 'Localização';

  @override
  String get edPrefForeign => 'Estudo no Exterior';

  @override
  String get edGuruRelationship => 'Vínculo com Professor/Guru';

  @override
  String get edMentorAvailability => 'Disponibilidade de Mentor';

  @override
  String get edPeerLearning => 'Aprendizado entre Colegas';

  @override
  String get edAuthorityDeference => 'Respeito pela Autoridade';

  @override
  String get edStrengthsTitle => 'Pontos Fortes e Desafios';

  @override
  String get edCognitiveGifts => 'Dons Cognitivos';

  @override
  String get edNaturalAbilities => 'Habilidades Naturais de Aprendizado';

  @override
  String get edHiddenCapacities => 'Capacidades Ocultas';

  @override
  String get edConcentration => 'Dificuldade de Concentração';

  @override
  String get edBreakRisk => 'Risco de Interrupção Educacional';

  @override
  String get edDisciplineConsistency => 'Consistência Disciplinar';

  @override
  String get edScholarshipLikelihood => 'Probabilidade de Bolsa de Estudos';

  @override
  String get edCareerLinkTitle => 'Educação → Caminho Profissional';

  @override
  String get edDirectionRec => 'Direção Recomendada';

  @override
  String get edIntegrationStrategy => 'Estratégia de Integração';

  @override
  String get edCareerLinkage => 'Ligação com a Carreira';

  @override
  String get edAlignedSubjects => 'Matérias Alinhadas à Carreira';

  @override
  String get edDegreeUtility => 'Utilidade do Diploma para a Carreira';

  @override
  String get edImprovementTitle => 'Seu Plano de Melhoria';

  @override
  String get edReliabilityTitle => 'Confiabilidade da Previsão';

  @override
  String get edLayerD1 => 'Mapa Natal (D1)';

  @override
  String get edLayerD4 => 'Educação Formal (D4)';

  @override
  String get edLayerD9 => 'Navamsa (D9)';

  @override
  String get edLayerD24 => 'Aprendizado Profundo (D24)';

  @override
  String get edLayerD60 => 'Aprendizado de Vida Passada (D60)';

  @override
  String get edLayerAmk => 'Karaka da Matéria';

  @override
  String get edLayerMj => 'Mercúrio-Júpiter';

  @override
  String get edLayerDasha => 'Timing Planetário';

  @override
  String get edTopicSubjects => 'Melhores Matérias Para Mim';

  @override
  String get edTopicDegree => 'Chances de Obter Diploma';

  @override
  String get edTopicAbroad => 'Estudar no Exterior';

  @override
  String get edTopicExam => 'Desempenho em Provas';

  @override
  String get edTopicHabits => 'Hábitos de Estudo';

  @override
  String get edTopicCareerLink => 'Ligação entre Educação e Carreira';

  @override
  String get edTopicTiming => 'Janelas de Timing Educacional';

  @override
  String get edTopicScholarship => 'Chances de Bolsa de Estudos';

  @override
  String get hwTitle => 'Análise de Saúde e Bem-Estar';

  @override
  String get hwSubtitle => 'Relatório Védico de Saúde e Bem-Estar com IA';

  @override
  String get hwSnapshotHeader => 'Resumo da Sua Saúde';

  @override
  String get hwOverallVitality => 'Vitalidade';

  @override
  String get hwImmunity => 'Imunidade';

  @override
  String get hwRecovery => 'Recuperação';

  @override
  String get hwMentalWellness => 'Bem-Estar Mental';

  @override
  String get hwStressTolerance => 'Tolerância ao Estresse';

  @override
  String get hwStatusThriving => 'Em Plena Forma';

  @override
  String get hwStatusGood => 'Boa Vitalidade';

  @override
  String get hwStatusBalanced => 'Equilibrado';

  @override
  String get hwStatusNeedsCare => 'Precisa de Cuidado';

  @override
  String get hwStatusNeedsAttention => 'Precisa de Atenção';

  @override
  String get hwChipImmunity => 'Imunidade Forte';

  @override
  String get hwChipRecovery => 'Recuperação Rápida';

  @override
  String get hwChipMentalBalance => 'Mente Equilibrada';

  @override
  String get hwChipStressResilience => 'Resiliente ao Estresse';

  @override
  String get hwChipFertility => 'Apoio à Fertilidade';

  @override
  String get hwChipWorkLife => 'Bom Equilíbrio Trabalho-Vida';

  @override
  String get hwChipLowAddiction => 'Baixo Risco de Dependência';

  @override
  String get hwConstitutionTitle => 'Seu Tipo Corporal';

  @override
  String get hwConstitutionSubtitle =>
      'Constituição ayurvédica a partir do seu mapa';

  @override
  String get hwDominantDosha => 'Dominante';

  @override
  String get hwSecondaryDosha => 'Secundário';

  @override
  String get hwPrimaryKaraka => 'Principal Indicador de Saúde';

  @override
  String get hwStrongestSystem => 'Sistema Mais Forte';

  @override
  String get hwWeakestSystem => 'Sistema a Fortalecer';

  @override
  String get hwBodyMapTitle => 'O Mapa Planetário do Seu Corpo';

  @override
  String get hwBodyMapSubtitle => '9 planetas, 9 sistemas corporais';

  @override
  String get hwYogaTitle => 'Padrões de Saúde no Seu Mapa';

  @override
  String get hwYogaSubtitle => 'Yogas de proteção vs pressão de doença';

  @override
  String get hwDiseasePressureLabel => 'PRESSÃO DE DOENÇA';

  @override
  String get hwAreasTitle => 'Áreas do Corpo a Observar';

  @override
  String get hwAreasSubtitle => 'Vulnerabilidade por zona corporal';

  @override
  String get hwProtectedAreas => 'Áreas Bem Protegidas';

  @override
  String get hwCategoriesTitle => 'Observação de Categorias de Doença';

  @override
  String get hwCategoriesSubtitle =>
      'Suscetibilidade nas principais categorias de saúde';

  @override
  String get hwLowRiskCategories => 'Categorias de Baixo Risco';

  @override
  String get hwMentalTitle => 'Bem-Estar Mental e Emocional';

  @override
  String get hwMentalSubtitle =>
      'Resiliência emocional e necessidades de apoio';

  @override
  String get hwMentalVulnerability => 'Sensibilidade Emocional';

  @override
  String get hwEmotionalRegulation => 'Regulação Emocional';

  @override
  String get hwSupportRec => 'Recomendação de Apoio';

  @override
  String get hwTendencies => 'Tendências Mentais';

  @override
  String get hwTimelineTitle => 'Linha do Tempo da Saúde';

  @override
  String get hwTimelineSubtitle =>
      'Anos de pico, anos de cautela e janelas de recuperação';

  @override
  String get hwPeakYears => 'Anos de Pico de Bem-Estar';

  @override
  String get hwCautionYears => 'Anos de Cautela';

  @override
  String get hwRecoveryWindow => 'Janela de Recuperação';

  @override
  String get hwCheckupYears => 'Anos Recomendados para Check-up';

  @override
  String get hwCurrentPhase => 'Fase Atual';

  @override
  String get hwLifestyleTitle => 'Seu Guia de Estilo de Vida';

  @override
  String get hwLifestyleSubtitle => 'O que seu mapa diz sobre hábitos diários';

  @override
  String get hwSleepDiscipline => 'Impacto da Disciplina do Sono';

  @override
  String get hwDietDiscipline => 'Impacto da Disciplina Alimentar';

  @override
  String get hwExerciseNeed => 'Necessidade de Exercício';

  @override
  String get hwSunlightNeed => 'Necessidade de Luz Solar';

  @override
  String get hwStressSusceptibility => 'Suscetibilidade ao Estresse';

  @override
  String get hwHydrationSensitivity => 'Sensibilidade à Hidratação';

  @override
  String get hwSocialType => 'Tipo de Energia Social';

  @override
  String get hwHealingSpeed => 'Velocidade de Cura';

  @override
  String get hwTreatmentResponse => 'Resposta ao Tratamento';

  @override
  String get hwAltHealing => 'Afinidade com Cura Alternativa';

  @override
  String get hwSpecialTitle => 'Estágios de Vida e Tópicos Especiais';

  @override
  String get hwSpecialSubtitle =>
      'Fertilidade, saúde infantil, hábitos e esgotamento';

  @override
  String get hwFertility => 'Indicador de Fertilidade';

  @override
  String get hwHormonalBalance => 'Equilíbrio Hormonal';

  @override
  String get hwReproductiveStrength => 'Força do Sistema Reprodutivo';

  @override
  String get hwChildhoodVuln => 'Vulnerabilidade de Saúde na Infância';

  @override
  String get hwChildhoodStatus => 'Saúde na Infância';

  @override
  String get hwAddictionVuln => 'Vulnerabilidade à Dependência';

  @override
  String get hwAddictionRecovery => 'Capacidade de Recuperação';

  @override
  String get hwBurnoutVuln => 'Vulnerabilidade ao Esgotamento';

  @override
  String get hwWorkLifeBalance => 'Equilíbrio Trabalho-Vida';

  @override
  String get hwStressTriggers => 'Gatilhos de Estresse';

  @override
  String get hwProtectiveFactors => 'Fatores de Proteção';

  @override
  String get hwChallengesTitle => 'Desafios a Observar';

  @override
  String get hwChallengesSubtitle => 'Onde focar os cuidados preventivos';

  @override
  String get hwMitigation => 'Como Gerenciar';

  @override
  String get hwChronicAreas => 'Áreas de Vulnerabilidade Crônica';

  @override
  String get hwPreventivePriorities => 'Prioridades Preventivas';

  @override
  String get hwImprovementTitle => 'Seu Plano de Bem-Estar';

  @override
  String get hwImprovementSubtitle => 'Passos práticos + remédios tradicionais';

  @override
  String get hwReliabilityTitle => 'Confiabilidade da Leitura';

  @override
  String get hwLayerD1 => 'Mapa Natal (D1)';

  @override
  String get hwLayerD6 => 'Mapa de Saúde (D6)';

  @override
  String get hwLayerD30 => 'Mapa de Micro-Saúde (D30)';

  @override
  String get hwLayerDasha => 'Timing Planetário';

  @override
  String get hwLayerTransit => 'Trânsitos Atuais';

  @override
  String get hwDisclaimerLabel => 'Aviso Médico';

  @override
  String get hwTopicImmunity => 'Aumentar a Imunidade';

  @override
  String get hwTopicSleep => 'Sono e Descanso';

  @override
  String get hwTopicStress => 'Gerenciar o Estresse';

  @override
  String get hwTopicFertility => 'Timing de Fertilidade';

  @override
  String get hwTopicDiet => 'Dieta e Nutrição';

  @override
  String get hwTopicTiming => 'Janelas de Timing de Saúde';

  @override
  String get hwTopicMental => 'Bem-Estar Mental';

  @override
  String get hwTopicPrevention => 'Plano de Cuidados Preventivos';

  @override
  String get lvSubtitle => 'Relatório Védico de Amor com IA';

  @override
  String get lvTitle => 'Amor e Relacionamentos';

  @override
  String get lvLovePotential => 'Potencial Amoroso';

  @override
  String get lvEmotionalAvail => 'Emocionalmente Aberto';

  @override
  String get lvAttraction => 'Atração';

  @override
  String get lvCommitment => 'Compromisso';

  @override
  String get lvCommunication => 'Comunicação';

  @override
  String get lvFidelity => 'Lealdade';

  @override
  String get lvChipLoyal => 'Coração leal';

  @override
  String get lvChipOpenHeart => 'Coração aberto';

  @override
  String get lvChipCommunicator => 'Ótimo comunicador';

  @override
  String get lvChipMature => 'Lida bem com conflitos';

  @override
  String get lvChipEmotionallyWise => 'Emocionalmente sábio';

  @override
  String get lvLoveStyle => 'Seu Estilo Amoroso';

  @override
  String get lvAttractionStyle => 'Estilo de atração';

  @override
  String get lvLangGiven => 'Você Expressa Amor Por';

  @override
  String get lvLangReceived => 'Você Se Sente Amado Por';

  @override
  String get lvLovePlanets => 'Seus Planetas do Amor';

  @override
  String get lvLoveKaraka => 'Amor';

  @override
  String get lvEmotionKaraka => 'Emoção';

  @override
  String get lvPassionKaraka => 'Paixão';

  @override
  String get lvPathToLove => 'Seu Caminho para o Amor';

  @override
  String get lvPathSub => 'Amor vs arranjado';

  @override
  String get lvLoveMarriage => 'Casamento por Amor';

  @override
  String get lvArrangedMarriage => 'Casamento Arranjado';

  @override
  String get lvParentalAccept => 'Aceitação dos Pais';

  @override
  String get lvInterCaste => 'Inter-castas / Religião';

  @override
  String get lvIdealPartner => 'Seu Parceiro Ideal';

  @override
  String get lvPersonality => 'Personalidade';

  @override
  String get lvAppearance => 'Aparência';

  @override
  String get lvIdealTraits => 'Traços Ideais';

  @override
  String get lvWhatMatters => 'O Que Mais Importa';

  @override
  String get lvDrawnTo => 'Atraído por';

  @override
  String get lvDealbreakers => 'Fatores Decisivos Negativos';

  @override
  String get lvYourAppeal => 'Seu apelo';

  @override
  String get lvLoveStory => 'Sua História de Amor';

  @override
  String get lvLoveStorySub => 'Padrões de relacionamento';

  @override
  String get lvFirstLove => 'Primeiro Amor';

  @override
  String get lvRelationCount => 'Vínculos Significativos';

  @override
  String get lvDuration => 'Duração Típica';

  @override
  String get lvDepth => 'Profundidade Emocional';

  @override
  String get lvDatingPattern => 'Padrão de Namoro';

  @override
  String get lvCommitIntimacy => 'Compromisso e Intimidade';

  @override
  String get lvCommitReady => 'Prontidão para o Compromisso';

  @override
  String get lvIntimacyDrive => 'Impulso de Intimidade';

  @override
  String get lvSensuality => 'Sensualidade';

  @override
  String get lvEmpathy => 'Empatia';

  @override
  String get lvCommitStyle => 'Estilo de Compromisso';

  @override
  String get lvChemistry => 'Estilo de Química';

  @override
  String get lvMakesCommit => 'O Que Faz Você se Comprometer';

  @override
  String get lvMakesFlee => 'O Que Te Afasta';

  @override
  String get lvEmotional => 'Inteligência Emocional';

  @override
  String get lvEmotionalIQ => 'QI Emocional';

  @override
  String get lvConflictStyle => 'Estilo de Conflito';

  @override
  String get lvTiming => 'Timing do Amor';

  @override
  String get lvNewLove12 => 'Novo amor em 12 meses';

  @override
  String get lvEnergyNow => 'Energia agora';

  @override
  String get lvPhaseNow => 'Fase atual';

  @override
  String get lvPeakRomance => 'Anos de Pico Romântico';

  @override
  String get lvNewLoveWindow => 'Janela para Novo Amor';

  @override
  String get lvChallenges => 'Desafios a Observar';

  @override
  String get lvRiskHeartbreak => 'Vulnerabilidade ao Sofrimento Amoroso';

  @override
  String get lvRiskSabotage => 'Autossabotagem';

  @override
  String get lvRiskCommitFear => 'Medo de Compromisso';

  @override
  String get lvRiskRepeat => 'Padrões Repetidos';

  @override
  String get lvRiskWorkaholic => 'Trabalho Acima do Amor';

  @override
  String get lvRedFlags => 'Sinais de alerta a observar';

  @override
  String get lvHealing => 'O Que Curar';

  @override
  String get lvFocusArea => 'Área de Foco';

  @override
  String get lvHealDir => 'Direção da cura';

  @override
  String get lvImprovementPlan => 'Plano de Melhoria';

  @override
  String get lvReliability => 'Confiabilidade da Previsão';

  @override
  String get lvLayerBirth => 'Mapa Natal (D1)';

  @override
  String get lvLayerNavamsa => 'Navamsa (D9)';

  @override
  String get lvLayerSaptamsa => 'Saptamsa (D7)';

  @override
  String get lvLayerDasha => 'Timing de Dasha';

  @override
  String get lvLayerTransit => 'Trânsitos Atuais';

  @override
  String get lvTopicWhen => 'Quando encontrarei o amor?';

  @override
  String get lvTopicSoulmate => 'Sobre minha alma gêmea';

  @override
  String get lvTopicCurrent => 'Meu relacionamento atual';

  @override
  String get lvTopicHeal => 'Curando o passado';

  @override
  String get lvTopicCommit => 'Ajuda com compromisso';

  @override
  String get lvTopicLoveVsArranged => 'Amor vs arranjado';

  @override
  String get lvTopicHeartbreak => 'Evitando o sofrimento amoroso';

  @override
  String get lvTopicConfidence => 'Confiança no amor';

  @override
  String get mrSubtitle => 'Relatório Védico de Casamento com IA';

  @override
  String get mrTitle => 'Casamento e Família';

  @override
  String get mrMarriagePotential => 'Potencial de Casamento';

  @override
  String get mrHarmony => 'Harmonia';

  @override
  String get mrLongevity => 'Longevidade';

  @override
  String get mrSatisfaction => 'Satisfação';

  @override
  String get mrStability => 'Estabilidade do Lar';

  @override
  String get mrClarity => 'Clareza';

  @override
  String get mrChipHarmony => 'Vínculo harmonioso';

  @override
  String get mrChipNoMangal => 'Sem Mangal dosh';

  @override
  String get mrChipLongLasting => 'Duradouro';

  @override
  String get mrChipHome => 'Casa própria provável';

  @override
  String get mrChipInLaws => 'Boa relação com sogros';

  @override
  String get mrChipChildren => 'Abençoado com filhos';

  @override
  String get mrSpouse => 'Seu Futuro Cônjuge';

  @override
  String get mrSpouseSub => 'O que o mapa sugere';

  @override
  String get mrSpouseTraits => 'Personalidade Provável';

  @override
  String get mrSpouseWork => 'Profissão Provável';

  @override
  String get mrAgeDiff => 'Diferença de Idade';

  @override
  String get mrCulture => 'Compatibilidade Cultural';

  @override
  String get mrEducation => 'Educação';

  @override
  String get mrFamilyBg => 'Origem Familiar';

  @override
  String get mrSoulPartnership => 'Alma e Parceria';

  @override
  String get mrSelfPlanet => 'Você em um Vínculo';

  @override
  String get mrSpousePlanet => 'Planeta do Seu Cônjuge';

  @override
  String get mrSoulAlignment => 'Alinhamento da Alma';

  @override
  String get mrAlignStrong =>
      'Sua alma e seu parceiro ideal estão fortemente alinhados — um vínculo profundamente gratificante é bem apoiado.';

  @override
  String get mrAlignModerate =>
      'Sua alma e seu parceiro ideal estão moderadamente alinhados — um vínculo gratificante cresce com esforço consciente.';

  @override
  String get mrAlignLow =>
      'Sua alma e a parceria precisam de integração consciente — escolha um parceiro que realmente combine com seus valores internos.';

  @override
  String get mrTechDarakaraka => 'Planeta do cônjuge (Darakaraka)';

  @override
  String get mrUpapada => 'Ponto do casamento (Upapada)';

  @override
  String get mrUpapadaLord => 'Regente do Upapada';

  @override
  String get mrFoundation => 'Fundação do Casamento';

  @override
  String get mrMarriageSign => 'Signo do Casamento';

  @override
  String get mrMarriageLord => 'Regente do Casamento';

  @override
  String get mrHouseStrength => 'Força da Casa';

  @override
  String get mrPartnerHint => 'Indício do parceiro no seu mapa';

  @override
  String get mrHarmonyHdr => 'Harmonia de Compatibilidade';

  @override
  String get mrHarmonySub => 'Como vocês se conectarão';

  @override
  String get mrEmotional => 'Emocional';

  @override
  String get mrIntellectual => 'Intelectual';

  @override
  String get mrPhysical => 'Intimidade Física';

  @override
  String get mrFinancial => 'Financeiro';

  @override
  String get mrCommunication => 'Comunicação';

  @override
  String get mrSharedValues => 'Valores Compartilhados';

  @override
  String get mrSpiritual => 'Espiritual';

  @override
  String get mrConflictRes => 'Resolução de Conflitos';

  @override
  String get mrTiming => 'Timing do Casamento';

  @override
  String get mrFirstMarriageAge => 'Idade Provável do Casamento';

  @override
  String get mrDelayChance => 'Chance de atraso';

  @override
  String get mrMarriageWindow => 'Janela do Casamento';

  @override
  String get mrSecondaryWindow => 'Janela Alternativa';

  @override
  String get mrCurrentReadiness => 'Agora Mesmo';

  @override
  String get mrJourney => 'Jornada do Casamento';

  @override
  String get mrJourneySub => 'Como o vínculo evolui';

  @override
  String get mrPhaseEarly => 'Primeiros Anos';

  @override
  String get mrPhaseMid => 'Anos Intermediários';

  @override
  String get mrPhaseMature => 'Anos de Maturidade';

  @override
  String get mrPhaseLate => 'Últimos Anos';

  @override
  String get mrTip => 'Dica';

  @override
  String get mrFamilyHome => 'Família e Lar';

  @override
  String get mrInLaws => 'Relação com os Sogros';

  @override
  String get mrFamilyHarmony => 'Harmonia Familiar';

  @override
  String get mrHomeOwnership => 'Posse de Imóvel';

  @override
  String get mrDomesticPeace => 'Paz Doméstica';

  @override
  String get mrFertility => 'Fertilidade';

  @override
  String get mrParenting => 'Harmonia na Criação dos Filhos';

  @override
  String get mrChildren => 'Filhos';

  @override
  String get mrLikelyCount => 'Número provável';

  @override
  String get mrVerification => 'Verificação entre Mapas';

  @override
  String get mrD9 => 'Mapa do Casamento (D9)';

  @override
  String get mrD10 => 'Mapa Carreira-Cônjuge (D10)';

  @override
  String get mrD60 => 'Mapa do Carma (D60)';

  @override
  String get mrChallenges => 'Desafios a Observar';

  @override
  String get mrMangalPresent =>
      'Mangal Dosh está presente no mapa — revise com cuidado os remédios e a compatibilidade.';

  @override
  String get mrMangalAbsent =>
      'Nenhum Mangal Dosh detectado — um indicador favorável para o casamento.';

  @override
  String get mrRiskConflict => 'Conflito';

  @override
  String get mrRiskSeparation => 'Separação';

  @override
  String get mrRiskDistance => 'Distância Emocional';

  @override
  String get mrRiskInfidelity => 'Infidelidade';

  @override
  String get mrRiskFinance => 'Desentendimentos Financeiros';

  @override
  String get mrPartnerGuide => 'Guia do Parceiro';

  @override
  String get mrPartnerGuideSub => 'O que procurar';

  @override
  String get mrSeek => 'Procure por';

  @override
  String get mrMatchingPriorities => 'Prioridades de Compatibilidade';

  @override
  String get mrImprovementPlan => 'Plano de Melhoria';

  @override
  String get mrReliability => 'Confiabilidade da Previsão';

  @override
  String get mrLayerBirth => 'Mapa Natal (D1)';

  @override
  String get mrLayerNavamsa => 'Navamsa (D9)';

  @override
  String get mrLayerDashamsa => 'Dashamsa (D10)';

  @override
  String get mrLayerShashtiamsa => 'Carma (D60)';

  @override
  String get mrLayerDarakaraka => 'Planeta do Cônjuge';

  @override
  String get mrTopicWhen => 'Quando vou me casar?';

  @override
  String get mrTopicSpouse => 'Sobre meu cônjuge';

  @override
  String get mrTopicCompat => 'Dicas de compatibilidade';

  @override
  String get mrTopicDelay => 'Atraso no casamento';

  @override
  String get mrTopicMangal => 'Mangal dosh';

  @override
  String get mrTopicChildren => 'Timing dos filhos';

  @override
  String get mrTopicInLaws => 'Relação com os sogros';

  @override
  String get mrTopicHarmony => 'Construindo harmonia';

  @override
  String get wlSubtitle => 'Relatório Védico de Riqueza com IA';

  @override
  String get wlTitle => 'Riqueza e Finanças';

  @override
  String get wlWealthPotential => 'Potencial de Riqueza';

  @override
  String get wlAccumulation => 'Acumulação';

  @override
  String get wlIncomeFlow => 'Fluxo de Renda';

  @override
  String get wlRetention => 'Retenção';

  @override
  String get wlSustainability => 'Sustentabilidade';

  @override
  String get wlSavings => 'Disciplina de Poupança';

  @override
  String get wlChipSaver => 'Poupador natural';

  @override
  String get wlChipMultiIncome => 'Múltiplas fontes de renda';

  @override
  String get wlChipStrongYogas => 'Yogas de riqueza';

  @override
  String get wlChipLowDebt => 'Baixa dívida';

  @override
  String get wlChipInheritance => 'Herança provável';

  @override
  String get wlChipInvestor => 'Investidor inteligente';

  @override
  String get wlWealthClass => 'Classe de Riqueza';

  @override
  String get wlWealthType => 'Principal Tipo de Riqueza';

  @override
  String get wlPrimarySource => 'Renda Principal';

  @override
  String get wlPeakAge => 'Idade de Pico de Riqueza';

  @override
  String get wlBoosters => 'O Que Está Impulsionando Sua Riqueza';

  @override
  String get wlBoostersSub => 'Combinações poderosas de dinheiro';

  @override
  String get wlWealthImpact => 'impulso';

  @override
  String get wlDrains => 'Drenos de Riqueza';

  @override
  String get wlIncomeSources => 'Fontes de Renda';

  @override
  String get wlIncomeSourcesSub => 'De onde vem o seu dinheiro';

  @override
  String get wlPrimary => 'Principal';

  @override
  String get wlInvestment => 'Plano de Investimento';

  @override
  String get wlInvestmentSub => 'Mix ideal de ativos';

  @override
  String get wlRiskAppetite => 'Apetite ao Risco';

  @override
  String get wlInvestStyle => 'Estilo de Investimento';

  @override
  String get wlDrivenBy => 'Impulsionado por';

  @override
  String get wlMoneyPersonality => 'Personalidade Financeira';

  @override
  String get wlMoneyType => 'Tipo de Relação com o Dinheiro';

  @override
  String get wlSpending => 'Gastos';

  @override
  String get wlSavingsDiscipline => 'Disciplina de Poupança';

  @override
  String get wlCharity => 'Inclinação à Caridade';

  @override
  String get wlLuxury => 'Gastos com Luxo';

  @override
  String get wlWindfalls => 'Ganhos Inesperados e Chances';

  @override
  String get wlWindfallsSub => 'Dinheiro baseado em sorte';

  @override
  String get wlInheritanceChance => 'Herança';

  @override
  String get wlSuddenGains => 'Ganhos Repentinos';

  @override
  String get wlLottery => 'Loteria / Especulação';

  @override
  String get wlInsurance => 'Indenizações de Seguro';

  @override
  String get wlWindfallSource => 'Fonte provável de ganho inesperado';

  @override
  String get wlMoneyPlanets => 'Seus Planetas do Dinheiro';

  @override
  String get wlPrimaryKaraka => 'Planeta Financeiro Primário';

  @override
  String get wlSecondaryKaraka => 'Planeta Financeiro Secundário';

  @override
  String get wlTimeline => 'Linha do Tempo da Riqueza';

  @override
  String get wlPeakYears => 'Anos de Pico';

  @override
  String get wlGoodPeriod => 'Período Próspero';

  @override
  String get wlSuddenGainWindow => 'Janela de Ganho Repentino';

  @override
  String get wlToughPeriod => 'Período de Cautela';

  @override
  String get wlDebtRisks => 'Riscos de Dívida e Dinheiro';

  @override
  String get wlDebtChance => 'Probabilidade de Dívida';

  @override
  String get wlLoanBurden => 'Peso de Empréstimos';

  @override
  String get wlDrainSources => 'Fique atento a';

  @override
  String get wlStrengthen => 'O Que Fortalecer';

  @override
  String get wlWeakestDriver => 'Fator Financeiro Mais Fraco';

  @override
  String get wlHowToFix => 'Como fortalecer';

  @override
  String get wlImprovementPlan => 'Plano de Melhoria';

  @override
  String get wlReliability => 'Confiabilidade da Previsão';

  @override
  String get wlLayerBirth => 'Casas de Riqueza (D1)';

  @override
  String get wlLayerHora => 'Mapa Hora (D2)';

  @override
  String get wlLayerNavamsa => 'Navamsa (D9)';

  @override
  String get wlLayerDasha => 'Timing de Dasha';

  @override
  String get wlLayerTransit => 'Trânsitos Atuais';

  @override
  String get wlTopicGrow => 'Como aumentar a riqueza';

  @override
  String get wlTopicInvest => 'Onde investir';

  @override
  String get wlTopicDebt => 'Gerenciando dívidas';

  @override
  String get wlTopicProperty => 'Comprando propriedades';

  @override
  String get wlTopicRetire => 'Planejamento de aposentadoria';

  @override
  String get wlTopicPassive => 'Renda passiva';

  @override
  String get wlTopicWindfall => 'Ganhos repentinos';

  @override
  String get wlTopicTiming => 'Melhor timing financeiro';

  @override
  String get bzSubtitle => 'Relatório Védico de Negócios com IA';

  @override
  String get bzTitle => 'Negócios e Startups';

  @override
  String get bzBusinessPotential => 'Potencial de Negócios';

  @override
  String get bzEntrepreneurship => 'Empreendedor';

  @override
  String get bzVenture => 'Sucesso do Empreendimento';

  @override
  String get bzWealth => 'Riqueza via Negócios';

  @override
  String get bzRiskAppetite => 'Apetite ao Risco';

  @override
  String get bzLongevity => 'Longevidade';

  @override
  String get bzChipWealthMagnet => 'Ímã de riqueza';

  @override
  String get bzChipMoneyYoga => 'Yoga de dinheiro';

  @override
  String get bzChipLeadership => 'Liderança';

  @override
  String get bzChipPartnerFit => 'Ótima compatibilidade com sócios';

  @override
  String get bzChipGains => 'Fortes ganhos';

  @override
  String get bzChipInvestor => 'Atrai investidores';

  @override
  String get bzChipFounder => 'Mentalidade de fundador';

  @override
  String get bzWhatsWorking => 'O Que Está Funcionando Para Você';

  @override
  String get bzWhatsWorkingSub => 'Seus dons para os negócios';

  @override
  String get bzClassicYogas => 'Combinações clássicas de riqueza';

  @override
  String get bzFounderType => 'Seu Tipo de Fundador';

  @override
  String get bzSoulBusiness => 'Alma e Propósito Empresarial';

  @override
  String get bzSoulPlanet => 'Seu Impulsionador da Alma';

  @override
  String get bzBusinessPlanet => 'Sua Mente Empresarial';

  @override
  String get bzDirectionStrength => 'Clareza de Direção';

  @override
  String get bzAlignStrong =>
      'Seu propósito de alma e sua direção empresarial estão fortemente alinhados — construir um empreendimento parece natural e gratificante.';

  @override
  String get bzAlignModerate =>
      'Seu propósito de alma e sua direção empresarial estão moderadamente alinhados — um empreendimento funciona melhor quando reflete seus valores mais profundos.';

  @override
  String get bzAlignLow =>
      'Seu propósito de alma e sua direção empresarial precisam de alinhamento consciente — escolha um empreendimento que realmente combine com quem você é.';

  @override
  String get bzTechAtmakaraka => 'Planeta da alma (Atmakaraka)';

  @override
  String get bzTechAmatyakaraka => 'Planeta dos negócios (Amatyakaraka)';

  @override
  String get bzTechDarakaraka => 'Planeta do sócio (Darakaraka)';

  @override
  String get bzFoundation => 'Fundação Empresarial';

  @override
  String get bzCareerHouse => 'Casa da Carreira';

  @override
  String get bzGainsHouse => 'Casa dos Ganhos';

  @override
  String get bzLord => 'Regente';

  @override
  String get bzGainsPotential => 'Potencial de Ganhos';

  @override
  String get bzNetwork => 'Poder de Rede';

  @override
  String get bzRecovery => 'Força de Recuperação';

  @override
  String get bzVerification => 'Verificação entre Mapas';

  @override
  String get bzD10 => 'Mapa de Carreira (D10)';

  @override
  String get bzD11 => 'Mapa de Ganhos (D11)';

  @override
  String get bzD9 => 'Mapa de Propósito (D9)';

  @override
  String get bzD60 => 'Mapa do Carma (D60)';

  @override
  String get bzFounderSkills => 'Habilidades de Fundador';

  @override
  String get bzSkillStrategy => 'Pensamento Estratégico';

  @override
  String get bzSkillExecution => 'Execução';

  @override
  String get bzSkillPeople => 'Gestão de Pessoas';

  @override
  String get bzSkillSales => 'Vendas e Persuasão';

  @override
  String get bzSkillFinance => 'Perspicácia Financeira';

  @override
  String get bzSkillOps => 'Disciplina Operacional';

  @override
  String get bzTopSkill => 'Principal Habilidade';

  @override
  String get bzDomains => 'Melhores Áreas de Negócio';

  @override
  String get bzDomainsSub => 'Classificadas por afinidade natural';

  @override
  String get bzFit => 'COMPATIBILIDADE';

  @override
  String get bzBusinessStyleHdr => 'Estilo de Negócio';

  @override
  String get bzStyleService => 'Produto vs Serviço';

  @override
  String get bzStyleMarket => 'Foco de Mercado';

  @override
  String get bzStyleTech => 'Abordagem Tecnológica';

  @override
  String get bzStyleLeadership => 'Estilo de Liderança';

  @override
  String get bzStylePartnership => 'Solo ou Sociedade';

  @override
  String get bzWhereBuild => 'Alcance';

  @override
  String get bzExpansion => 'Expansão';

  @override
  String get bzSetup => 'Estrutura';

  @override
  String get bzPartnership => 'Sociedade e Equipe';

  @override
  String get bzIdealCofounder => 'Cofundador Ideal';

  @override
  String get bzPartnerViability => 'Compatibilidade de Sociedade';

  @override
  String get bzTeamBuilding => 'Formação de Equipe';

  @override
  String get bzCofounderFit => 'Compatibilidade com Cofundador';

  @override
  String get bzAdvisorNetwork => 'Rede de Conselheiros';

  @override
  String get bzFunding => 'Financiamento e Dinheiro';

  @override
  String get bzRecommendedPath => 'Caminho de Financiamento Recomendado';

  @override
  String get bzInvestorAttract => 'Atração de Investidores';

  @override
  String get bzFamilyBacking => 'Apoio Familiar';

  @override
  String get bzHybridViability => 'Mix de Emprego + Negócio';

  @override
  String get bzFallback => 'Emprego como Alternativa';

  @override
  String get bzDebtStyle => 'Estilo de Endividamento';

  @override
  String get bzTimeline => 'Linha do Tempo do Negócio';

  @override
  String get bzCurrentPhase => 'Agora Mesmo';

  @override
  String get bzLaunchWindow => 'Janela de Lançamento';

  @override
  String get bzScaleWindow => 'Janela de Crescimento';

  @override
  String get bzPeakAge => 'Anos de Pico';

  @override
  String get bzChallenges => 'Desafios a Observar';

  @override
  String get bzRiskFinancial => 'Perda Financeira';

  @override
  String get bzRiskBurnout => 'Esgotamento';

  @override
  String get bzRiskTeam => 'Conflito de Equipe';

  @override
  String get bzRiskLegal => 'Jurídico / Regulatório';

  @override
  String get bzFinancialExp =>
      'Risco de perda financeira por excesso de investimento ou má gestão do fluxo de caixa durante um empreendimento.';

  @override
  String get bzFinancialFix =>
      'Mantenha uma reserva de caixa, comece de forma enxuta e valide a demanda antes de aumentar os gastos.';

  @override
  String get bzBurnoutExp =>
      'Se esforçar demais por muito tempo pode drenar sua energia e foco.';

  @override
  String get bzBurnoutFix =>
      'Proteja o descanso, delegue cedo e ritme os grandes esforços em torno de períodos favoráveis.';

  @override
  String get bzTeamExp =>
      'Atritos com cofundadores ou equipe podem desacelerar o negócio.';

  @override
  String get bzTeamFix =>
      'Defina papéis e expectativas claras por escrito, e comunique-se com frequência.';

  @override
  String get bzLegalExp =>
      'Questões de conformidade, contratos ou regulamentação podem criar obstáculos.';

  @override
  String get bzLegalFix =>
      'Faça revisar os contratos, mantenha a documentação organizada e consulte profissionais desde cedo.';

  @override
  String get bzImprovementPlan => 'Plano de Melhoria';

  @override
  String get bzBestDirection => 'Melhor Direção';

  @override
  String get bzStrategy => 'Estratégia de Construção';

  @override
  String get bzTopFields => 'Principais Áreas';

  @override
  String get bzEmploymentPath => 'Emprego vs Negócio';

  @override
  String get bzRoadmap => 'Roteiro de Crescimento';

  @override
  String get bzRoadmapSub => 'Seu plano de empreendimento';

  @override
  String get bzReliability => 'Confiabilidade da Previsão';

  @override
  String get bzLayerBirth => 'Mapa Natal (D1)';

  @override
  String get bzLayerNavamsa => 'Navamsa (D9)';

  @override
  String get bzLayerDashamsa => 'Carreira (D10)';

  @override
  String get bzLayerLabhamsa => 'Ganhos (D11)';

  @override
  String get bzLayerShashtiamsa => 'Carma (D60)';

  @override
  String get bzTopicStart => 'Devo começar agora?';

  @override
  String get bzTopicIdea => 'Melhor ideia de negócio';

  @override
  String get bzTopicPartner => 'Encontrando um cofundador';

  @override
  String get bzTopicFunding => 'Como financiar';

  @override
  String get bzTopicScale => 'Quando expandir';

  @override
  String get bzTopicRisk => 'Gerenciando riscos';

  @override
  String get bzTopicJob => 'Emprego vs negócio';

  @override
  String get bzTopicTiming => 'Melhor timing';

  @override
  String get crTitle => 'Análise de Carreira e Emprego';

  @override
  String get crSubtitle => 'Relatório Védico de Carreira com IA';

  @override
  String get crCrumbHome => 'Início';

  @override
  String get crCrumbReports => 'Relatórios';

  @override
  String get crCareerPotential => 'Potencial de Carreira';

  @override
  String get crStatusStrong => 'Potencial Forte';

  @override
  String get crStatusGood => 'Bom Potencial';

  @override
  String get crStatusModerate => 'Potencial Moderado';

  @override
  String get crStatusDeveloping => 'Potencial em Desenvolvimento';

  @override
  String get crStatusChallenging => 'Fase Desafiadora';

  @override
  String get crOverallCareer => 'Carreira Geral';

  @override
  String get crStability => 'Estabilidade Profissional';

  @override
  String get crGrowth => 'Potencial de Crescimento';

  @override
  String get crRecognition => 'Reconhecimento';

  @override
  String get crSatisfaction => 'Satisfação';

  @override
  String get crChipLeadership => 'Liderança';

  @override
  String get crChipCreativity => 'Criatividade';

  @override
  String get crChipBusiness => 'Negócios';

  @override
  String get crChipStableIncome => 'Renda Estável';

  @override
  String get crChipLearning => 'Aprendizado';

  @override
  String get crChipGrowth => 'Crescimento de Longo Prazo';

  @override
  String get crChipTechnical => 'Habilidade Técnica';

  @override
  String get crChipRecognition => 'Reconhecimento';

  @override
  String get crTopInsights => 'Principais Insights';

  @override
  String get crWhatDefines => 'O que define sua carreira?';

  @override
  String get crSoulCareer => 'Alma e Propósito Profissional';

  @override
  String get crSoulPlanet => 'Planeta do Propósito da Alma';

  @override
  String get crCareerPlanet => 'Planeta da Carreira';

  @override
  String get crMeaning => 'Significado';

  @override
  String get crAlignment => 'Alinhamento Alma ↔ Carreira';

  @override
  String get crAlignStrong =>
      'Seus interesses naturais e seu caminho profissional estão fortemente alinhados.';

  @override
  String get crAlignModerate =>
      'Seus interesses naturais e seu caminho profissional estão moderadamente alinhados.';

  @override
  String get crAlignLow =>
      'Seus interesses naturais e seu caminho profissional precisam de alinhamento consciente.';

  @override
  String get crTechAtmakaraka => 'Atmakaraka (indicador da alma)';

  @override
  String get crTechAmatyakaraka => 'Amatyakaraka (indicador de carreira)';

  @override
  String get crDegrees => 'Graus';

  @override
  String get crDignity => 'Dignidade';

  @override
  String get crFoundation => 'Fundação da Carreira';

  @override
  String get crCareerSign => 'Signo da Carreira';

  @override
  String get crCareerLord => 'Senhor da Carreira';

  @override
  String get crLordPosition => 'Posição do Senhor';

  @override
  String get crCareerStrength => 'Força da Carreira';

  @override
  String get crProfStyle => 'Estilo Profissional';

  @override
  String get crBestFields => 'Melhores Áreas';

  @override
  String get crTechnicalDetails => 'Detalhes Técnicos';

  @override
  String get crHouseLabel => 'Casa';

  @override
  String get crVerification => 'Verificação de Carreira entre Mapas';

  @override
  String get crD10Career => 'D10 · Carreira';

  @override
  String get crD9Purpose => 'D9 · Propósito';

  @override
  String get crD60Karma => 'D60 · Carma';

  @override
  String get crStatusNeedsImprovement => 'Precisa Melhorar';

  @override
  String get crStatusWellAligned => 'Bem Alinhado';

  @override
  String get crStatusStrongSupport => 'Forte Apoio';

  @override
  String get crStatusModerateSupport => 'Apoio Moderado';

  @override
  String get crChartDetails => 'Detalhes técnicos do mapa';

  @override
  String get crPersonality => 'Sua Personalidade Profissional';

  @override
  String get crGrowthAreas => 'Áreas de Crescimento';

  @override
  String get crBestRoles => 'Melhores Funções';

  @override
  String get crBestIndustries => 'Melhores Setores';

  @override
  String get crEnvironment => 'Ambiente de Trabalho';

  @override
  String get crWorkStyle => 'Melhor Estilo de Trabalho';

  @override
  String get crEmployment => 'Emprego';

  @override
  String get crBusiness => 'Negócio Próprio';

  @override
  String get crFreelance => 'Freelancer / Consultoria';

  @override
  String get crPortfolio => 'Portfólio Misto';

  @override
  String get crLeadership => 'Liderança';

  @override
  String get crFit => 'Compatibilidade';

  @override
  String get crBestFit => 'Melhor Compatibilidade';

  @override
  String get crTimeline => 'Linha do Tempo da Carreira';

  @override
  String get crPastPeak => 'Pico Anterior';

  @override
  String get crPresentPhase => 'Fase Atual';

  @override
  String get crUpcoming => 'Próxima Oportunidade';

  @override
  String get crFutureExpansion => 'Expansão Futura';

  @override
  String get crRiskPeriod => 'Período de Risco';

  @override
  String get crViewDasha => 'Período planetário (técnico)';

  @override
  String get crChallenges => 'Desafios a Observar';

  @override
  String get crRiskBurnout => 'Esgotamento';

  @override
  String get crRiskRecognition => 'Atraso no Reconhecimento';

  @override
  String get crRiskConflict => 'Conflito no Trabalho';

  @override
  String get crRiskFinancial => 'Instabilidade Financeira';

  @override
  String get crRiskOverqual => 'Subutilização';

  @override
  String get crPrevention => 'Prevenção';

  @override
  String get crBurnoutExp =>
      'Fases longas e exigentes podem drenar sua energia com o tempo.';

  @override
  String get crBurnoutFix =>
      'Proteja o descanso, estabeleça limites e ritme os grandes esforços.';

  @override
  String get crRecognitionExp =>
      'Recompensas e reconhecimento podem chegar mais devagar do que seu esforço.';

  @override
  String get crRecognitionFix =>
      'Documente suas conquistas e torne suas contribuições visíveis para os superiores.';

  @override
  String get crConflictExp =>
      'Atritos com colegas ou superiores podem surgir em alguns momentos.';

  @override
  String get crConflictFix =>
      'Comunique-se com calma e escolha bem suas batalhas.';

  @override
  String get crFinancialExp =>
      'A renda pode parecer irregular em determinadas fases.';

  @override
  String get crFinancialFix =>
      'Mantenha uma reserva e evite se comprometer financeiramente em excesso.';

  @override
  String get crOverqualExp =>
      'Às vezes você pode se sentir subutilizado ou pouco desafiado.';

  @override
  String get crOverqualFix =>
      'Busque funções desafiadoras e continue aprendendo para se manter engajado.';

  @override
  String get crImprovementPlan => 'Plano de Melhoria de Carreira';

  @override
  String get crCatPlanetary => 'Planetário e Espiritual';

  @override
  String get crCatPractical => 'Passos Práticos';

  @override
  String get crTraditionalExplain => 'Explicação astrológica tradicional';

  @override
  String get crActionPlan => 'Plano de Ação de Carreira de 30 Dias';

  @override
  String get crWeek1 => 'Semana 1 · Otimização do Perfil';

  @override
  String get crWeek2 => 'Semana 2 · Desenvolvimento de Habilidades';

  @override
  String get crWeek3 => 'Semana 3 · Networking';

  @override
  String get crWeek4 => 'Semana 4 · Visibilidade Profissional';

  @override
  String get crWeek1Tip =>
      'Atualize seu currículo e LinkedIn em torno do seu tema profissional mais forte.';

  @override
  String get crWeek2Tip =>
      'Escolha uma habilidade de alto valor na sua melhor área e pratique-a diariamente.';

  @override
  String get crWeek3Tip =>
      'Reconecte-se com mentores e entre em contato com dois novos contatos do setor.';

  @override
  String get crWeek4Tip =>
      'Compartilhe seu trabalho publicamente e se voluntarie para um projeto visível.';

  @override
  String get crPriority => 'Prioridade';

  @override
  String get crTimeRequired => 'Tempo';

  @override
  String get crExpectedBenefit => 'Benefício';

  @override
  String get crPriorityHigh => 'Alta';

  @override
  String get crPriorityMedium => 'Média';

  @override
  String get crRoadmap => 'Roteiro de Carreira com IA';

  @override
  String get crNext12 => 'Próximos 12 Meses';

  @override
  String get crBestFocus => 'Melhor Foco';

  @override
  String get crSkillsLearn => 'Habilidades a Aprender';

  @override
  String get crIndustriesTarget => 'Setores a Almejar';

  @override
  String get crExpectedOutcome => 'Resultado Esperado';

  @override
  String get crReliability => 'Confiabilidade da Previsão';

  @override
  String get crReliabilityHigh => 'Alta Confiabilidade';

  @override
  String get crReliabilityGood => 'Boa Confiabilidade';

  @override
  String get crReliabilityModerate => 'Confiabilidade Moderada';

  @override
  String get crReliabilityExplain =>
      'Este relatório combina seu mapa natal, mapas divisionais e indicadores Jaimini. A pontuação reflete o quanto essas camadas do mapa concordam entre si.';

  @override
  String get crChartLayers => 'Camadas do mapa e pesos';

  @override
  String get crBirthChart => 'Mapa Natal (D1)';

  @override
  String get crNavamsa => 'Navamsa (D9)';

  @override
  String get crDashamsa => 'Dashamsa (D10)';

  @override
  String get crShashtiamsa => 'Shashtiamsa (D60)';

  @override
  String get crDiscussAi => 'Discutir com a IA';

  @override
  String get crAskAbout => 'Perguntar Sobre';

  @override
  String get crTopicChange => 'Mudança de Carreira';

  @override
  String get crTopicGovt => 'Emprego Público';

  @override
  String get crTopicBusiness => 'Negócios';

  @override
  String get crTopicPromotion => 'Promoção';

  @override
  String get crTopicMarriage => 'Casamento vs Carreira';

  @override
  String get crTopicAbroad => 'Exterior';

  @override
  String get crTopicIncome => 'Renda';

  @override
  String get crTopicPurpose => 'Propósito';

  @override
  String get crTopicResume => 'Currículo';

  @override
  String get crTopicCopied => 'Pergunta copiada — cole no seu chat com a IA.';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return '$soul guia seu chamado interior, enquanto $career molda sua profissão exterior.';
  }

  @override
  String get rzTodayOutlook => 'Panorama Zodiacal de Hoje';

  @override
  String get rzPlanetaryEnergy => 'Energia Planetária de Hoje';

  @override
  String get rzBestSign => 'Melhor Signo';

  @override
  String get rzChallengingSign => 'Mais Desafiador';

  @override
  String get rzDominantPlanet => 'Planeta Dominante';

  @override
  String get rzOverallMood => 'Clima Geral';

  @override
  String get rzMoodBright => 'Brilhante e Ativo';

  @override
  String get rzMoodCalm => 'Calmo e Estável';

  @override
  String get rzMoodMixed => 'Energia Mista';

  @override
  String get rzMoodTense => 'Tenso e Cauteloso';

  @override
  String get rzTodayEnergy => 'Energia de Hoje';

  @override
  String get rzCaution => 'Cautela';

  @override
  String get rzWeak => 'Fraco';

  @override
  String get rzAllSigns => 'Todos os Signos do Zodíaco';

  @override
  String get rzAiSummary => 'Resumo da IA';

  @override
  String get rzPlanetaryInfluence => 'Influência Planetária de Hoje';

  @override
  String get rzStrongInfluences => 'Influências Fortes';

  @override
  String get rzShowTechnical => 'Mostrar detalhes técnicos';

  @override
  String get rzOpportunities => 'Oportunidades de Hoje';

  @override
  String get rzAvoidTitle => 'Coisas a Evitar Hoje';

  @override
  String get rzTechnicalReason => 'Motivo técnico';

  @override
  String get rzAvoidDecisions => 'Apressar decisões importantes';

  @override
  String get rzAvoidArguments => 'Discussões acaloradas';

  @override
  String get rzAvoidInvestments => 'Grandes investimentos';

  @override
  String get rzAvoidOverthink => 'Pensar demais em pequenos problemas';

  @override
  String get rzAvoidOverspend => 'Gastos desnecessários';

  @override
  String get rzAvoidStress => 'Estresse e excesso de trabalho';

  @override
  String get rzPlanetaryChart => 'Mapa Planetário de Hoje';

  @override
  String get rzWhatChartMeans => 'O que este mapa significa';

  @override
  String get rzChartExplain =>
      'Este diamante mostra onde cada planeta está posicionado no céu hoje, mapeado para o seu signo. Planetas em casas favoráveis animam o dia; os que estão em casas difíceis pedem cuidado.';

  @override
  String get rzDoNetworking => 'Networking e conexões';

  @override
  String get rzDoLearning => 'Aprender algo novo';

  @override
  String get rzDoMeditation => 'Meditação e calma';

  @override
  String get rzDoFamily => 'Tempo em família';

  @override
  String get rzDoCreative => 'Trabalho criativo';

  @override
  String get rzDoRest => 'Descanso e autocuidado';

  @override
  String get rzAiRecommendations => 'Recomendações da IA para Hoje';

  @override
  String get rzTechnical => 'Astrologia Técnica';

  @override
  String get rzTransitScore => 'Pontuação de Trânsito';

  @override
  String get rzVedha => 'Vedha (Obstruções)';

  @override
  String get rzGocharDetails => 'Detalhes do Gochar';

  @override
  String get rzAdvancedOnly => 'Para usuários avançados';

  @override
  String get rzTomorrow => 'Prévia de Amanhã';

  @override
  String get rzTomorrowEnergy => 'Energia de Amanhã';

  @override
  String get rzImproving => 'Melhorando';

  @override
  String get rzWeaker => 'Ligeiramente Mais Fraca';

  @override
  String get rzSteady => 'Estável';

  @override
  String get rzTomorrowUpLine =>
      'Espera-se que a energia aumente amanhã — planeje com antecedência as tarefas importantes.';

  @override
  String get rzTomorrowDownLine =>
      'A energia pode cair um pouco amanhã — mantenha o dia leve e estável.';

  @override
  String get rzTomorrowFlatLine =>
      'A energia permanece estável amanhã — um dia calmo e equilibrado pela frente.';

  @override
  String get rzWeeklyTrend => 'Tendência Semanal';

  @override
  String get rzMonthlyTrend => 'Tendência Mensal';

  @override
  String get rzBestDayWeek => 'Melhor Dia';

  @override
  String get rzHardestDay => 'Dia Mais Difícil';

  @override
  String get rzLuckyToday => 'Sorte Hoje';

  @override
  String get rzKarakaSun => 'confiança e vitalidade';

  @override
  String get rzKarakaMoon => 'emoções e paz de espírito';

  @override
  String get rzKarakaMars => 'energia e ímpeto';

  @override
  String get rzKarakaMercury => 'comunicação e aprendizado';

  @override
  String get rzKarakaJupiter => 'sabedoria e crescimento';

  @override
  String get rzKarakaVenus => 'relacionamentos e conforto';

  @override
  String get rzKarakaSaturn => 'disciplina e paciência';

  @override
  String get rzKarakaRahu => 'ambição e mudança';

  @override
  String get rzKarakaKetu => 'espiritualidade e desapego';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '$dom define o tom do dia, enquanto $chal pede paciência e cuidado.';
  }

  @override
  String rzInsightGood(Object karaka) {
    return 'Bom dia para $karaka.';
  }

  @override
  String rzInsightHard(Object karaka) {
    return 'Vá com calma com $karaka hoje.';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return '$karaka está bem apoiado hoje.';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return '$karaka pode enfrentar atrasos hoje.';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return 'Hoje favorece $strong, enquanto $weak precisa de paciência e cuidado.';
  }

  @override
  String get fdEnergyScore => 'Pontuação de Energia de Hoje';

  @override
  String get fdStatusAverage => 'Média';

  @override
  String get fdStatusMixed => 'Mista';

  @override
  String get fdStatusChallenging => 'Desafiadora';

  @override
  String get fdTheme => 'Tema de Hoje';

  @override
  String get fdExplainToday => 'Explicar Hoje';

  @override
  String get fdTodaysFocus => 'Foco de Hoje';

  @override
  String get fdTopRecommendation => 'Principal Recomendação';

  @override
  String get fdTopCaution => 'Principal Cuidado';

  @override
  String get fdReadingTime => 'Tempo de leitura';

  @override
  String get fdSeconds30 => '30 seg';

  @override
  String get fdCareer => 'Carreira';

  @override
  String get fdMoney => 'Dinheiro';

  @override
  String get fdLove => 'Amor';

  @override
  String get fdHealth => 'Saúde';

  @override
  String get fdTravel => 'Viagem';

  @override
  String get fdFamily => 'Família';

  @override
  String get fdBestToDo => 'Melhores Coisas a Fazer Hoje';

  @override
  String get fdAvoidToday => 'Evitar Hoje';

  @override
  String get fdConfidenceLabel => 'Confiança';

  @override
  String get fdBestTime => 'Melhor Horário';

  @override
  String get fdRecommended => 'Recomendado';

  @override
  String get fdReason => 'Motivo';

  @override
  String get fdRisk => 'Risco';

  @override
  String get fdRecommendation => 'Recomendação';

  @override
  String get fdNoActions =>
      'Nada de grande impacto para hoje — mantenha uma rotina calma e estável.';

  @override
  String get fdNoCautions =>
      'Nenhuma precaução importante hoje — siga com a atenção normal.';

  @override
  String get fdHighlights => 'Destaques de Hoje';

  @override
  String get fdProbVeryHigh => 'Muito Alta';

  @override
  String get fdProbHigh => 'Alta';

  @override
  String get fdProbElevated => 'Elevada';

  @override
  String get fdProbCaution => 'Cautela';

  @override
  String get fdWhatToDo => 'O que fazer';

  @override
  String get fdLifeAreas => 'Áreas da Vida';

  @override
  String get fdTapDetails => 'Toque para detalhes';

  @override
  String get fdArea1 => 'Eu e Saúde';

  @override
  String get fdArea2 => 'Riqueza e Família';

  @override
  String get fdArea3 => 'Comunicação';

  @override
  String get fdArea4 => 'Lar e Conforto';

  @override
  String get fdArea5 => 'Criatividade e Romance';

  @override
  String get fdArea6 => 'Trabalho e Deveres';

  @override
  String get fdArea7 => 'Relacionamentos';

  @override
  String get fdArea8 => 'Mudança e Profundidade';

  @override
  String get fdArea9 => 'Sorte e Viagens';

  @override
  String get fdArea10 => 'Carreira e Status';

  @override
  String get fdArea11 => 'Ganhos e Rede de Contatos';

  @override
  String get fdArea12 => 'Descanso e Espiritualidade';

  @override
  String get fdTodaysMeaning => 'Significado de Hoje';

  @override
  String get fdGoodFor => 'Bom Para';

  @override
  String get fdAvoid => 'Evitar';

  @override
  String get fdPlanetSupport => 'Apoio Planetário';

  @override
  String get fdWhyPrediction => 'Por que essa previsão?';

  @override
  String get fdAdvancedDetails => 'Detalhes Avançados';

  @override
  String get fdAiRecommendation => 'Recomendação da IA';

  @override
  String get fdOverallStatus => 'Status Geral';

  @override
  String get fdNoPlanetTransit =>
      'Nenhum planeta importante está transitando por esta área hoje.';

  @override
  String get fdFinancialOutlook => 'Panorama Financeiro';

  @override
  String get fdIncomeProbability => 'Probabilidade de Receita';

  @override
  String get fdExpenseProbability => 'Probabilidade de Despesa';

  @override
  String get fdNetBalance => 'Saldo Financeiro Líquido';

  @override
  String get fdAvoidSpending => 'Evitar Gastos';

  @override
  String get fdRelationshipOutlook => 'Panorama de Relacionamento';

  @override
  String get fdOverallScore => 'Pontuação Geral';

  @override
  String get fdPartner => 'Parceiro(a)';

  @override
  String get fdRomance => 'Romance';

  @override
  String get fdWorkplace => 'Ambiente de Trabalho';

  @override
  String get fdPublicImage => 'Imagem Pública';

  @override
  String get fdBestActivity => 'Melhor Atividade';

  @override
  String get fdWeakArea => 'Área Fraca';

  @override
  String get fdBiggestOpportunity => 'Maior Oportunidade';

  @override
  String get fdBiggestRisk => 'Maior Risco';

  @override
  String get fdProbability => 'Probabilidade';

  @override
  String get fdProtection => 'Conselho de Proteção';

  @override
  String get fdDescription => 'Descrição';

  @override
  String get fdBestTimeToday => 'Melhor Horário Hoje';

  @override
  String get fdAvoidDuring => 'Evitar Durante';

  @override
  String get fdPredictionConfidence => 'Confiança da Previsão';

  @override
  String get fdConfBasis => 'A previsão de hoje combina';

  @override
  String get fdConfNatal => 'Mapa Natal';

  @override
  String get fdConfTransit => 'Trânsito Atual';

  @override
  String get fdConfDasha => 'Períodos Planetários';

  @override
  String get fdConfStrength => 'Força Planetária';

  @override
  String get fdConfHouse => 'Ativação de Casa';

  @override
  String get fdAskAi => 'Perguntar à IA';

  @override
  String get fdAskAiSub =>
      'Toque em uma pergunta para obter a resposta de hoje';

  @override
  String get fdQ1 => 'Por que a carreira está lenta hoje?';

  @override
  String get fdQ2 => 'Qual é o melhor horário hoje?';

  @override
  String get fdQ3 => 'Hoje é bom para questões financeiras?';

  @override
  String get fdQ4 => 'Hoje é bom para viagens?';

  @override
  String get fdQ5 => 'O que devo evitar hoje?';

  @override
  String get fdMoreSuggestions => 'Mais Sugestões';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return 'Hoje é mais indicado para $top. $weak pode parecer lento, então evite decisões importantes nessa área. Financeiramente, o dia parece $fin.';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return 'Sua energia hoje se concentra em $top — invista nisso e vá com calma no restante.';
  }

  @override
  String get gochToday => 'Hoje';

  @override
  String get gochOverallScore => 'Pontuação Geral de Trânsito';

  @override
  String get gochNeutral => 'Neutro';

  @override
  String get gochChallenging => 'Desafiador';

  @override
  String get gochTopPositive => 'Principais Pontos Positivos';

  @override
  String get gochTopChallenges => 'Principais Desafios';

  @override
  String get gochFilterAll => 'Todos';

  @override
  String get gochFavorability => 'Favorabilidade';

  @override
  String get gochAlerts => 'Alertas de Trânsito';

  @override
  String get gochAlertCritical => 'Crítico';

  @override
  String get gochAlertWarning => 'Cautela';

  @override
  String get gochAlertOpportunity => 'Oportunidade';

  @override
  String get gochAiFocus => 'Foco da IA para Hoje';

  @override
  String get gochLifeScores => 'Pontuações por Área da Vida';

  @override
  String get gochWhy => 'Por quê?';

  @override
  String get gochCurrentTransits => 'Trânsitos Ativos';

  @override
  String get gochDailyPlan => 'Seu Plano Diário';

  @override
  String get gochMorning => 'Manhã';

  @override
  String get gochAfternoon => 'Tarde';

  @override
  String get gochEvening => 'Fim de Tarde';

  @override
  String get gochNight => 'Noite';

  @override
  String get gochSmartReco => 'Recomendações Inteligentes';

  @override
  String get gochExplain => 'Explicar o Trânsito de Hoje';

  @override
  String get gochDo => 'Faça';

  @override
  String get gochDont => 'Evite';

  @override
  String get gochDoWork => 'Cuide de trabalhos importantes';

  @override
  String get gochDoMeditate => 'Medite e reflita';

  @override
  String get gochDoStart => 'Inicie novos planos';

  @override
  String get gochDoFinish => 'Termine tarefas pendentes';

  @override
  String get gochDontArgue => 'Evite discussões';

  @override
  String get gochDontImpulsive => 'Evite decisões impulsivas';

  @override
  String get gochDontOverspend => 'Evite gastos excessivos';

  @override
  String gochThemeGrowth(Object area) {
    return 'Um dia de crescimento em $area — invista nisso.';
  }

  @override
  String gochThemeChallenge(Object area) {
    return 'Tenha paciência com $area hoje — vá com calma.';
  }

  @override
  String gochPosLine(Object area) {
    return '$area está bem apoiada neste momento.';
  }

  @override
  String gochChalLine(Object area) {
    return '$area precisa de cuidado extra hoje.';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return 'Coloque sua energia em $a1 hoje e seja gentil com $a2.';
  }

  @override
  String get divBeginner => 'Iniciante';

  @override
  String get divSearchHint => 'Buscar: carreira, casamento, educação…';

  @override
  String get divSummaryTitle => 'Resumo dos Mapas Divisionais';

  @override
  String get divTotalCharts => 'Total de Mapas';

  @override
  String get divMostImportant => 'Mais Importante';

  @override
  String get divRecommendedForYou => 'Recomendado Para Você';

  @override
  String get divCatEssential => 'Mapas Essenciais';

  @override
  String get divCatPersonal => 'Vida Pessoal';

  @override
  String get divCatKnowledge => 'Mapas de Conhecimento';

  @override
  String get divCatAdvanced => 'Mapas Avançados';

  @override
  String get divGoalProperty => 'Propriedade';

  @override
  String get divGoalKarma => 'Carma';

  @override
  String get divBadgeHighlyRec => 'Altamente Recomendado';

  @override
  String get divBadgeRec => 'Recomendado';

  @override
  String get divBadgeUseful => 'Útil';

  @override
  String get divBadgeOptional => 'Opcional';

  @override
  String get divBadgeAdvOnly => 'Somente Avançado';

  @override
  String get divRecommendBest => 'Recomendar Melhores Mapas';

  @override
  String get divNoMatch => 'Nenhum mapa corresponde à sua busca';

  @override
  String get divLifeAreas => 'Áreas da Vida';

  @override
  String divAiUse(Object purpose) {
    return 'Use este mapa para analisar $purpose.';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return 'Seus mapas $c1 e $c2 são especialmente importantes — comece por eles para as áreas que cobrem, depois explore os demais conforme necessário.';
  }

  @override
  String divRecReasonHouse(Object house) {
    return 'Sua Casa $house precisa de um olhar mais atento — este mapa a mostra em profundidade.';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '$planet é um planeta-chave, mas testado — este mapa revela sua condição mais profunda.';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return 'Você está na Mahadasha de $planet, então este mapa é especialmente oportuno agora.';
  }

  @override
  String divRecSummary(Object c1) {
    return 'Com base no seu mapa, $c1 deve ser sua maior prioridade. Os mapas abaixo estão ordenados por relevância para você neste momento.';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return 'Abra este mapa quando quiser estudar $purpose.';
  }

  @override
  String get yogaHelpful => 'Útil';

  @override
  String get yogaInactive => 'Inativo';

  @override
  String get yogaTabMoney => 'Dinheiro';

  @override
  String get yogaTabRare => 'Raro';

  @override
  String get yogaSummaryTitle => 'Resumo de Yogas';

  @override
  String get yogaActiveYogas => 'Yogas Ativos';

  @override
  String get yogaTotalYogas => 'Total de Yogas';

  @override
  String get yogaMostPowerful => 'Mais Poderoso';

  @override
  String get yogaFortuneRating => 'Fortuna Geral';

  @override
  String get yogaBenefits => 'Benefícios';

  @override
  String get yogaSupportingPlanets => 'Planetas de Apoio';

  @override
  String get yogaRanking => 'Top 5 Yogas Mais Fortes';

  @override
  String get yogaExplain => 'Explicar Meus Yogas';

  @override
  String get yogaExplainSubtitle => 'Como seus yogas te apoiam';

  @override
  String get yogaNoneActive => 'Nenhum yoga ativo ainda';

  @override
  String get yogaNoneInCategory => 'Nenhum yoga nesta categoria';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return 'Seu mapa carrega $count yogas ativos — combinações planetárias favoráveis. Combinações envolvendo $planets criam influências especialmente úteis para crescimento e sucesso.';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '$name apoia $areas, e seus benefícios crescem quando seus planetas estão ativos em dasha ou trânsito.';
  }

  @override
  String get yogaAiGeneric =>
      'Este yoga é uma combinação favorável no seu mapa que fortalece suas áreas relacionadas da vida.';

  @override
  String get yogaExplainReassure =>
      'Yogas são os pontos brilhantes do seu mapa — combinações planetárias úteis trabalhando a seu favor. Os mais fortes trazem benefícios duradouros, especialmente durante os períodos dos planetas que os formam.';

  @override
  String get doshSevere => 'Severo';

  @override
  String get doshVeryMild => 'Muito Leve';

  @override
  String get doshLow => 'Baixo';

  @override
  String get doshHigh => 'Alto';

  @override
  String get doshCritical => 'Crítico';

  @override
  String get doshSummaryTitle => 'Resumo de Doshas';

  @override
  String get doshActiveDoshas => 'Doshas Ativos';

  @override
  String get doshTotalChecked => 'Total Verificado';

  @override
  String get doshOverallSeverity => 'Severidade Geral';

  @override
  String get doshNoneActive => 'Nenhum dosha ativo — um mapa limpo!';

  @override
  String get doshCategory => 'Categoria';

  @override
  String get doshConfidence => 'Confiança';

  @override
  String get doshWhyFormed => 'Por Que Isso Se Formou';

  @override
  String get doshAffectedAreas => 'Áreas Afetadas';

  @override
  String get doshTimeline => 'Linha do Tempo';

  @override
  String get doshDefinition => 'Definição';

  @override
  String get doshFormationRule => 'Regra de Formação';

  @override
  String get doshSupportingPlanets => 'Planeta Relacionado';

  @override
  String get doshCancellation => 'Yogas de Cancelamento';

  @override
  String get doshNoCancellation => 'Nenhum encontrado';

  @override
  String get doshAreaChildren => 'Filhos';

  @override
  String get doshAreaMind => 'Mente';

  @override
  String get remMantra => 'Mantra';

  @override
  String get remGemstone => 'Pedra Preciosa';

  @override
  String get remDonation => 'Doação';

  @override
  String get remTemple => 'Templo';

  @override
  String get remFasting => 'Jejum';

  @override
  String get remLifestyle => 'Estilo de Vida';

  @override
  String get remLifestyleGeneric =>
      'Pratique gratidão, disciplina e caridade conectadas a este planeta, e mantenha boa conduta.';

  @override
  String get doshExplain => 'Explicar Meus Doshas';

  @override
  String get doshExplainSubtitle =>
      'Um olhar calmo e prático sobre seus doshas';

  @override
  String get doshExplainReassure =>
      'Doshas são comuns — quase todo mapa tem algum. Eles descrevem tendências, não um destino fixo. Consciência, boa conduta e remédios simples reduzem seu efeito prático, então não há motivo para preocupação.';

  @override
  String get doshAiGeneric =>
      'Este dosha descreve uma tendência no seu mapa. Seu efeito prático costuma ser leve e pode ser equilibrado com consciência e remédios simples.';

  @override
  String doshHeroSummary(Object active, Object total) {
    return 'Seu mapa mostra $active doshas ativos de um total de $total verificados. A maioria é leve e apenas alguns precisam de atenção. Com compreensão e remédios simples, seu efeito prático pode ser suavizado.';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return 'Este dosha influencia principalmente $areas. Durante os períodos de $planet, seu efeito pode se intensificar, e remédios ajudam a equilibrá-lo.';
  }

  @override
  String doshTimelineLine(Object planet) {
    return 'Seu efeito é sentido mais fortemente durante a Mahadasha e a Antardasha de $planet, e quando $planet está ativo em trânsito.';
  }

  @override
  String get sbLegendary => 'Lendário';

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
  String get sbSummary => 'Resumo da Força Planetária';

  @override
  String get sbAverageStrength => 'Força Média';

  @override
  String get sbHighestRupa => 'Rupa Mais Alto';

  @override
  String get sbRupa => 'Rupa';

  @override
  String get sbRanking => 'Classificação dos Planetas';

  @override
  String get sbRequired => 'Necessário';

  @override
  String get sbExcess => 'Excesso';

  @override
  String get sbDeficit => 'Déficit';

  @override
  String get sbTotalShadbala => 'Shadbala Total';

  @override
  String get sbExplain => 'Explicar Minha Força Planetária';

  @override
  String get sbExplainSubtitle =>
      'Um resumo simples da força dos seus planetas';

  @override
  String get sbInfoTitle => 'Entendendo o Shadbala';

  @override
  String get sbQWhatIs => 'O que é Shadbala?';

  @override
  String get sbQRupas => 'O que são Rupas?';

  @override
  String get sbQHowCalc => 'Como a força é calculada?';

  @override
  String get sbQHowUse => 'Como usar isso';

  @override
  String get sbWhyStrong => 'Por Que é Forte';

  @override
  String get sbWhyWeak => 'Por Que é Fraco';

  @override
  String get sbDuringMahadasha => 'Durante a Mahadasha';

  @override
  String get sbEffects => 'Efeitos';

  @override
  String get sbLifeAreas => 'Áreas da Vida';

  @override
  String get sbPlanetDetails => 'Detalhes do Planeta';

  @override
  String get sbBodyWhatIs =>
      'Shadbala (\'força sêxtupla\') mede quanto poder cada planeta tem para entregar seus resultados, somando seis fontes independentes de força.';

  @override
  String get sbBodyRupas =>
      'A força é medida em Rupas (1 Rupa = 60 Virupas). Cada planeta precisa de uma força mínima em Rupas para ser considerado forte; mais Rupas significa que ele entrega seus resultados de forma mais plena.';

  @override
  String get sbBodyHowCalc =>
      'Seis balas são somados: Sthana (posicional), Dig (direcional), Kala (temporal), Chesta (de movimento), Naisargika (natural) e Drik (aspectual). O total é comparado com o mínimo exigido pelo planeta para obter uma porcentagem.';

  @override
  String get sbBodyHowUse =>
      'Um planeta acima de 100% entrega suas significações com folga; abaixo de 100% ele precisa de apoio. Favoreça seus planetas mais fortes para assuntos importantes, e dê aos mais fracos remédios e paciência.';

  @override
  String get sbRemedyStrong =>
      'Bem apoiado — nenhum remédio especial é necessário; você pode usar os períodos deste planeta com confiança.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '$strongP é seu planeta mais forte, oferecendo excelente apoio para $strongTrait. $weakP é o mais fraco e se beneficia mais de remédios.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '$planet tem Shadbala $category, então suas $karakatva são apoiadas de acordo.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return 'Mais forte através de $bala ($rupa rupas).';
  }

  @override
  String sbWeakLine(Object bala) {
    return 'Mais fraco em $bala, o que reduz o total.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return 'Durante a Mahadasha de $planet, suas $karak vêm à tona.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'Com Shadbala forte, $karak são naturalmente apoiadas.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'Com Shadbala modesto, $karak podem precisar de esforço consciente.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return 'Fortaleça $planet através de seu mantra, pedra preciosa ou caridade, e aja com paciência durante seus períodos.';
  }

  @override
  String get bhOverview => 'Visão Geral';

  @override
  String get bhDetailed => 'Detalhado';

  @override
  String get bhavaHouses => 'Casas';

  @override
  String get bhStrengthOverview => 'Visão Geral da Força das Casas';

  @override
  String get bhOverallAverage => 'Média Geral das Casas';

  @override
  String get bhStrongestHouse => 'Casa Mais Forte';

  @override
  String get bhWeakestHouse => 'Casa Mais Fraca';

  @override
  String get bhBestArea => 'Melhor Área da Vida';

  @override
  String get bhNeedsAttention => 'Precisa de Atenção';

  @override
  String get bhSavContribution => 'Contribuição SAV';

  @override
  String get bhLordCondition => 'Condição do Senhor da Casa';

  @override
  String get bhBenefic => 'Influência Benéfica';

  @override
  String get bhMalefic => 'Influência Maléfica';

  @override
  String get bhStrengthReasons => 'Por Que Essa Pontuação';

  @override
  String get bhGoodEffects => 'Efeitos Positivos';

  @override
  String get bhChallenges => 'Desafios';

  @override
  String get bhRemedies => 'Remédios';

  @override
  String get bhRanking => 'Classificação das Casas';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'Explicar Minhas Casas';

  @override
  String get bhExplainSubtitle => 'Um resumo simples das suas 12 casas';

  @override
  String bhHeroSummary(
    Object s1,
    Object s2,
    Object strongArea,
    Object weakArea,
  ) {
    return 'Suas casas mais fortes são $s1 e $s2. $strongArea é naturalmente forte, enquanto $weakArea precisa de mais esforço.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'Seu senhor $lord está posicionado como $relation.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'Esta casa carrega $sav pontos benéficos (SAV); seus ocupantes e aspectos moldam o restante da pontuação.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'Quando forte, ela apoia $meaning.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'Quando fraca, $meaning pode precisar de esforço e cuidado extras.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'Fortaleça seu senhor $lord e honre os assuntos desta casa para elevá-la.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'Sua $house é $strengthWord. Ela governa $meaning.';
  }

  @override
  String get kunNavamsa => 'Navamsa (D9)';

  @override
  String get kunD10 => 'Dasamsa (D10)';

  @override
  String get kunPlacement => 'Posicionamento Planetário';

  @override
  String get kunHousesTitle => 'Detalhes das Casas';

  @override
  String get kunPlanet => 'Planeta';

  @override
  String get kunNakshatra => 'Nakshatra';

  @override
  String get kunPada => 'Pada';

  @override
  String get kunLord => 'Senhor';

  @override
  String get kunExplain => 'Explicar Meu Mapa';

  @override
  String get kunExplainSubtitle => 'Um resumo simples do seu mapa';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return 'A $ordinal casa governa $meaning.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return '$planets posicionado(s) aqui moldam seus resultados.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'Seu ascendente é $asc, moldando sua perspectiva e como os outros o veem à primeira vista.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'Sua mente e emoções seguem a Lua em $moon.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '$planet é seu planeta mais forte — uma área natural de facilidade e apoio.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '$planet é seu planeta mais testado — paciência e esforço compensam aqui.';
  }

  @override
  String get plNature => 'Natureza';

  @override
  String get plElement => 'Elemento';

  @override
  String get plGender => 'Gênero';

  @override
  String get plKarakatva => 'Karakatva';

  @override
  String get plLordship => 'Regência';

  @override
  String get plStrength => 'Força';

  @override
  String get plAspectsGiven => 'Aspectos Enviados';

  @override
  String get plAspectsReceived => 'Aspectos Recebidos';

  @override
  String get plConjunction => 'Conjunção';

  @override
  String get plHouseMeaning => 'Significado da Casa';

  @override
  String get plNakshatraMeaning => 'Significado do Nakshatra';

  @override
  String get plAiInterpretation => 'Interpretação da IA';

  @override
  String get plSearchHint => 'Buscar qualquer planeta';

  @override
  String get plNoResults => 'Nenhum planeta encontrado';

  @override
  String get plBenefic => 'Benéfico';

  @override
  String get plMalefic => 'Maléfico';

  @override
  String get plMale => 'Masculino';

  @override
  String get plFemale => 'Feminino';

  @override
  String get plNeutralGender => 'Neutro';

  @override
  String get plOwnSign => 'Signo Próprio';

  @override
  String get plFriend => 'Signo Amigo';

  @override
  String get plEnemy => 'Signo Inimigo';

  @override
  String get plNeutral => 'Neutro';

  @override
  String get sumEther => 'Éter';

  @override
  String plLordOfHouses(Object houses) {
    return 'Senhor da(s) casa(s) $houses';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return 'Regido por $nakLord, trazendo $trait.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '$planet está em $sign, na Casa $house.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'Suas significações principais — $karak — são bem apoiadas aqui.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'Suas significações principais — $karak — podem precisar de esforço consciente aqui.';
  }

  @override
  String plAiExalted(Object planet) {
    return '$planet está exaltado, entregando seus melhores resultados.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '$planet está debilitado e precisa de apoio para entregar seus resultados.';
  }

  @override
  String plAiCombust(Object planet) {
    return '$planet está combusto, então atua de forma menos aberta sob o brilho do Sol.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '$planet é vargottama — um posicionamento forte repetido no navamsa.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '$planet está retrógrado, voltando sua energia para dentro e intensificando-a.';
  }

  @override
  String get plHouse1 => 'eu, corpo, personalidade e vitalidade';

  @override
  String get plHouse2 => 'riqueza, família, fala e alimentação';

  @override
  String get plHouse3 => 'coragem, irmãos, comunicação e viagens curtas';

  @override
  String get plHouse4 => 'lar, mãe, conforto, propriedade e paz interior';

  @override
  String get plHouse5 =>
      'filhos, criatividade, inteligência, romance e méritos passados';

  @override
  String get plHouse6 => 'saúde, inimigos, dívidas, serviço e trabalho diário';

  @override
  String get plHouse7 => 'casamento, parcerias e relações comerciais';

  @override
  String get plHouse8 => 'longevidade, transformação, segredos e herança';

  @override
  String get plHouse9 => 'fortuna, dharma, ensino superior, guru e pai';

  @override
  String get plHouse10 => 'carreira, status, autoridade e carma público';

  @override
  String get plHouse11 =>
      'ganhos, renda, amigos, rede de contatos e desejos realizados';

  @override
  String get plHouse12 =>
      'perda, despesas, terras estrangeiras, espiritualidade e libertação';

  @override
  String get sumVeryStrong => 'Muito Forte';

  @override
  String get sumStrong => 'Forte';

  @override
  String get sumAverage => 'Médio';

  @override
  String get sumWeak => 'Fraco';

  @override
  String get sumNeedsAttention => 'Precisa de Atenção';

  @override
  String get sumFire => 'Fogo';

  @override
  String get sumEarth => 'Terra';

  @override
  String get sumAir => 'Ar';

  @override
  String get sumWater => 'Água';

  @override
  String get sumMovable => 'Móvel';

  @override
  String get sumFixed => 'Fixo';

  @override
  String get sumDual => 'Dual';

  @override
  String get sumDirEast => 'Leste';

  @override
  String get sumDirWest => 'Oeste';

  @override
  String get sumDirNorth => 'Norte';

  @override
  String get sumDirSouth => 'Sul';

  @override
  String get sumDirNE => 'Nordeste';

  @override
  String get sumDirNW => 'Noroeste';

  @override
  String get sumDirSE => 'Sudeste';

  @override
  String get sumDirSW => 'Sudoeste';

  @override
  String get sumSnapshotTitle => 'Seu Resumo Astrológico';

  @override
  String get sumMahadasha => 'Mahadasha';

  @override
  String get sumAntardasha => 'Antardasha';

  @override
  String get sumNakshatra => 'Janma Nakshatra';

  @override
  String get sumElement => 'Elemento';

  @override
  String get sumModality => 'Modalidade';

  @override
  String get sumLuckyDirection => 'Direção da Sorte';

  @override
  String get sumHighlights => 'Destaques Importantes';

  @override
  String get sumStrongPlanet => 'Planeta Mais Forte';

  @override
  String get sumWeakPlanet => 'Planeta Mais Fraco';

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
  String get sumQuickInsights => 'Insights Rápidos';

  @override
  String get sumSpirituality => 'Espiritualidade';

  @override
  String get sumTimezone => 'Fuso Horário';

  @override
  String get sumAyanamsa => 'Ayanamsa';

  @override
  String get sumCalendarType => 'Calendário';

  @override
  String get sumCopied => 'Copiado para a área de transferência';

  @override
  String get sumNatureFire =>
      'Você tem uma natureza ousada, energética e pioneira que lidera à frente.';

  @override
  String get sumNatureEarth =>
      'Você tem uma natureza prática, aterrada e disciplinada que constrói resultados duradouros.';

  @override
  String get sumNatureAir =>
      'Você tem uma natureza curiosa, comunicativa e intelectual que prospera com novas ideias.';

  @override
  String get sumNatureWater =>
      'Você tem uma natureza intuitiva, emocional e empática, com profunda sensibilidade interior.';

  @override
  String get sumGradePhraseExcellent =>
      'Fortemente apoiado — resultados favoráveis são prováveis com esforço constante.';

  @override
  String get sumGradePhraseGood =>
      'Bem apoiado — geralmente positivo com um pouco de cuidado.';

  @override
  String get sumGradePhraseAverage =>
      'Apoio misto — os resultados dependem do esforço e do timing.';

  @override
  String get sumGradePhraseWeak =>
      'Precisa de atenção — paciência e remédios ajudam aqui.';

  @override
  String get kDefCombust =>
      'Um planeta muito próximo do Sol, de modo que sua energia fica \'queimada\' e enfraquecida.';

  @override
  String get kDefRetrograde =>
      'Um planeta que parece se mover para trás; seus efeitos se voltam para dentro e se intensificam.';

  @override
  String get kDefNakshatra =>
      'Uma das 27 mansões lunares pelas quais a Lua e os planetas transitam.';

  @override
  String get kDefVargottama =>
      'Um planeta no mesmo signo tanto no mapa natal (D1) quanto no navamsa (D9) — uma marca de força.';

  @override
  String get kDefOwnSign =>
      'Um planeta posicionado em um signo que ele governa, onde se sente em casa e gera resultados estáveis.';

  @override
  String get kDefExalted =>
      'Um planeta em seu signo de maior força, entregando seus melhores resultados.';

  @override
  String get kDefDebilitated =>
      'Um planeta em seu signo mais fraco, onde tem dificuldade para gerar resultados.';

  @override
  String get kDefMooltrikona =>
      'Uma porção especial do signo próprio de um planeta onde ele é especialmente poderoso.';

  @override
  String get kDefAscendant =>
      'O signo que se ergue no horizonte leste no momento do nascimento — a Lagna, a base do mapa.';

  @override
  String get kDefMahadasha =>
      'O período planetário principal que colore um longo período da vida.';

  @override
  String get kDefAntardasha =>
      'Um subperíodo dentro de uma Mahadasha que ajusta seus resultados.';

  @override
  String get kDefPada =>
      'Um dos quatro quartos de um nakshatra ocupado por um planeta.';

  @override
  String get aspGivesAspectTo => 'Dá Aspecto Para';

  @override
  String get aspReceivesAspectFrom => 'Recebe Aspecto De';

  @override
  String get aspInfluences => 'Influencia';

  @override
  String get aspNoInfluence => 'Sem Influência';

  @override
  String get aspNoAspect => 'Sem Aspecto';

  @override
  String get aspPresent => 'Presente';

  @override
  String get aspAbsent => 'Ausente';

  @override
  String get aspNotPresent => 'Não Presente';

  @override
  String get aspSpecialAspect => 'Aspecto Especial';

  @override
  String get aspAspectWord => 'Aspecto';

  @override
  String get aspTotalGiven => 'Aspectos Dados';

  @override
  String get aspTotalReceived => 'Aspectos Recebidos';

  @override
  String get aspStrongestInfluence => 'Influência Mais Forte';

  @override
  String get aspMedium => 'Médio';

  @override
  String get aspAspectPresent => 'Aspecto Presente';

  @override
  String get aspReason => 'Motivo';

  @override
  String get aspBoth => 'Ambos';

  @override
  String get aspTargetHouse => 'Casa Alvo';

  @override
  String get aspTargetSign => 'Signo Alvo';

  @override
  String get aspLagnaReceives => 'Lagna Recebe Aspecto De';

  @override
  String get aspNoAspectFrom => 'Sem Aspecto De';

  @override
  String get aspPlanetToPlanet => 'Planeta para Planeta';

  @override
  String get aspSignToSign => 'Signo para Signo';

  @override
  String get aspCombinedAspect => 'Aspecto Combinado';

  @override
  String get aspGrahaAspect => 'Aspecto Graha';

  @override
  String get aspRashiAspect => 'Aspecto Rashi';

  @override
  String get aspInfoTitle => 'Entendendo os Aspectos (Drishti)';

  @override
  String get aspQGraha => 'O que é Graha Drishti?';

  @override
  String get aspQRashi => 'O que é Rashi Drishti?';

  @override
  String get aspQDiff => 'Diferença entre os dois';

  @override
  String get aspQPredict => 'Como os aspectos afetam a previsão';

  @override
  String get aspGrahaBody =>
      'Graha Drishti é o aspecto que um planeta projeta a partir de sua posição. Todo planeta aspecta totalmente a 7ª casa/planeta a partir de si mesmo (uma influência direta, cara a cara). Além disso, Marte aspecta a 4ª e a 8ª, Júpiter a 5ª e a 9ª, e Saturno a 3ª e a 10ª. Rahu e Ketu geralmente recebem a 5ª, 7ª e 9ª. O aspecto de um planeta colore o planeta ou casa em que incide com sua própria natureza.';

  @override
  String get aspRashiBody =>
      'Rashi Drishti é um aspecto signo a signo da astrologia Jaimini, independente de quais planetas estão lá. Signos móveis aspectam signos fixos (exceto o adjacente), signos fixos aspectam signos móveis (exceto o adjacente), e signos duais aspectam os outros signos duais. É usado principalmente na previsão Jaimini e para avaliar relações entre casas.';

  @override
  String get aspDiffBody =>
      'Graha Drishti é lançado por um planeta e depende de onde esse planeta está. Rashi Drishti pertence ao próprio signo e se aplica a tudo que está posicionado nele. Graha Drishti é direcional (o planeta A vê o planeta B), enquanto Rashi Drishti costuma ser mútuo entre os signos. Quando ambos apontam para o mesmo alvo, a influência é especialmente forte.';

  @override
  String get aspPredictBody =>
      'Um aspecto mostra onde um planeta estende sua influência além de sua própria casa. Um aspecto benéfico (Júpiter, Vênus, Lua/Mercúrio bem posicionados) apoia e protege o alvo; um aspecto maléfico (Saturno, Marte, Sol, Rahu, Ketu) pode pressionar, atrasar ou desafiá-lo. Ler quais planetas aspectam uma casa ou planeta explica por que os resultados aparecem da forma como aparecem.';

  @override
  String get aspTraitSun => 'autoridade, liderança e vitalidade';

  @override
  String get aspTraitMoon => 'profundidade emocional, conforto e intuição';

  @override
  String get aspTraitMars => 'energia, coragem e ímpeto';

  @override
  String get aspTraitMercury => 'comunicação, intelecto e adaptabilidade';

  @override
  String get aspTraitJupiter => 'sabedoria, crescimento e boa fortuna';

  @override
  String get aspTraitVenus => 'amor, harmonia e conforto';

  @override
  String get aspTraitSaturn =>
      'disciplina, responsabilidade e sucesso paciente, às vezes tardio';

  @override
  String get aspTraitRahu =>
      'ambição, intensidade e reviravoltas não convencionais';

  @override
  String get aspTraitKetu => 'desapego, espiritualidade e mudança repentina';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '$planet está influenciando $targets. Isso pode trazer $trait para as áreas representadas por esses planetas.';
  }

  @override
  String aspAiNone(Object planet) {
    return '$planet não lança um aspecto especial sobre nenhum outro planeta aqui; sua influência atua principalmente através de seu próprio signo e casa.';
  }

  @override
  String get avSummaryTitle => 'Resumo do Ashtakavarga';

  @override
  String get avOverallScore => 'Pontuação Geral do SAV';

  @override
  String get avOverallRating => 'Avaliação Geral';

  @override
  String get avStrongestSigns => 'Signos Mais Fortes';

  @override
  String get avWeakestSigns => 'Signos Mais Fracos';

  @override
  String get avScore => 'Pontuação';

  @override
  String get avMeaning => 'Significado';

  @override
  String get avGrid => 'Grade';

  @override
  String get avList => 'Lista';

  @override
  String get avOverallScoreShort => 'Pontuação Geral';

  @override
  String get avNatalSignScore => 'Pontuação do Signo Natal';

  @override
  String get avBestSigns => 'Melhores Signos';

  @override
  String get avWeakSigns => 'Signos Fracos';

  @override
  String get avAiInterpretation => 'Interpretação da IA';

  @override
  String get avVeryGood => 'Muito Bom';

  @override
  String get avVeryWeak => 'Muito Fraco';

  @override
  String get avTotalSav => 'SAV Total';

  @override
  String get avPlanetContributions => 'Contribuições dos Planetas';

  @override
  String get avFinance => 'Finanças';

  @override
  String get avOverallStrength => 'Força Geral';

  @override
  String get avWhatDoesThisMean => 'O que isso significa?';

  @override
  String get avSimple => 'Simples';

  @override
  String get avAdvanced => 'Avançado';

  @override
  String get avInfoTitle => 'Entendendo o Ashtakavarga';

  @override
  String get avStrong => 'Forte';

  @override
  String get avModerate => 'Moderado';

  @override
  String get avQWhatIsAv => 'O que é Ashtakavarga?';

  @override
  String get avQWhatIsSav => 'O que é SAV?';

  @override
  String get avQWhatIsBav => 'O que é BAV?';

  @override
  String get avQHowToRead => 'Como ler essas pontuações';

  @override
  String get avQSavVsBav => 'SAV vs BAV';

  @override
  String get avABody =>
      'Ashtakavarga é um sistema de força baseado em pontos na astrologia védica. Cada planeta concede pontos benéficos (bindus, também chamados de rekhas) aos doze signos com base em sua posição. Mais pontos em um signo significam que essa área da vida recebe apoio mais tranquilo durante os períodos e trânsitos planetários relacionados.';

  @override
  String get avSavBody =>
      'O SAV (Sarva Ashtakavarga) soma os pontos dos sete planetas para cada signo. Ele fornece uma única pontuação de força por signo, para que você possa ver rapidamente quais signos — e as casas em que caem — são mais bem apoiados no seu mapa.';

  @override
  String get avBavBody =>
      'O BAV (Bhinna Ashtakavarga) mostra os pontos de um único planeta nos doze signos. Ele indica quais signos um planeta específico mais apoia, o que importa quando a dasha ou o trânsito desse planeta está ativo.';

  @override
  String get avHowToReadBody =>
      'Números mais altos são melhores. Para o SAV, um signo médio pontua cerca de 28 pontos — acima de 30 é forte e abaixo de 25 precisa de cuidado. Para o BAV, cada signo varia de 0 a 8, sendo 4 a média. Favoreça seus signos mais fortes para ações importantes, e mantenha paciência e disciplina com os mais fracos.';

  @override
  String get avSavVsBavBody =>
      'O SAV é o total combinado de todos os planetas e mostra a força geral de um signo. O BAV é a contribuição de um único planeta e mostra qual planeta apoia esse signo. Use o SAV para o panorama geral, e o BAV para entender qual planeta impulsiona a força de um signo.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'Seu mapa é mais forte em $s1, $s2 e $s3. Esses signos oferecem melhor apoio durante períodos e trânsitos planetários. $weak atualmente tem o menor apoio, então paciência e disciplina ajudam em assuntos relacionados a ele.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '$planet tem seu melhor desempenho através de $s1 e $s2. Assuntos governados por $planet tendem a melhorar quando esses signos são ativados.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'Seus signos mais fortes são $s1 e $s2 — favoreça começos importantes quando os planetas transitarem por eles.';
  }

  @override
  String avInsightWeak(Object s1) {
    return '$s1 tem o menor apoio — proceda com cuidado e evite comprometimentos excessivos em seus assuntos.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '$planet carrega o maior número de pontos, então suas significações são bem apoiadas em sua vida.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '$planet carrega o menor número de pontos e se beneficia mais de remédios e esforço consciente.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'Signos com pontuação acima da sua média de $avg pontos tendem a dar resultados mais tranquilos e confiáveis.';
  }

  @override
  String get fcKey => 'Chave';

  @override
  String get fcActions => 'Ações';

  @override
  String get fcCautions => 'Cuidados';

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
  String get fcAnalysis => 'Análise';

  @override
  String get fcConfidence => 'Confiança';

  @override
  String get fcQualityCaps => 'QUALIDADE';

  @override
  String get fcIncomeVs => 'Renda vs';

  @override
  String get fcExpense => 'Despesa';

  @override
  String get fcFinance => 'FINANÇAS';

  @override
  String get fcNetBalance => 'Saldo Líquido';

  @override
  String get fcSignature => 'Assinatura';

  @override
  String get fcBestTimeForIncome => 'Melhor Horário para Renda';

  @override
  String get fcExpenseCaution => 'Cautela com Despesas';

  @override
  String get fcIncomeCaps => 'RENDA';

  @override
  String get fcExpenseCaps => 'DESPESA';

  @override
  String get fcRelationships => 'Relacionamentos';

  @override
  String get fcAreasCaps => 'ÁREAS';

  @override
  String get fcBestForMeetings => 'Melhor Para Reuniões';

  @override
  String get fcOpportunitiesVs => 'Oportunidades vs';

  @override
  String get fcRisks => 'Riscos';

  @override
  String get fcOutlook => 'PANORAMA';

  @override
  String get fcAction => 'Ação';

  @override
  String get fcProtect => 'Proteger';

  @override
  String get fcOpportunityCaps => 'OPORTUNIDADE';

  @override
  String get fcRiskCaps => 'RISCO';

  @override
  String get fcTopOpportunities => 'PRINCIPAIS OPORTUNIDADES';

  @override
  String get fcTopRisks => 'PRINCIPAIS RISCOS';

  @override
  String get fcTiming => 'Timing';

  @override
  String get fcWindows => 'Janelas';

  @override
  String get fcSlotsCaps => 'HORÁRIOS';

  @override
  String get fcBestWindows => 'MELHORES JANELAS';

  @override
  String get fcWorstWindows => 'PIORES JANELAS';

  @override
  String get fcAvoid => 'Evitar';

  @override
  String get fcHouse => 'Casa';

  @override
  String get fcFailed => 'Falhou';

  @override
  String get lifeCareer => 'Carreira';

  @override
  String get lifeHealth => 'Saúde';

  @override
  String get lifeWealth => 'Riqueza';

  @override
  String get lifeFamily => 'Família';

  @override
  String get lifeMind => 'Mente';

  @override
  String get lifeEgo => 'Ego';

  @override
  String get lifeAggression => 'Agressividade';

  @override
  String get lifeConflict => 'Conflito';

  @override
  String get rashiElement => 'Elemento';

  @override
  String get rashiQuality => 'Qualidade';

  @override
  String get rashiLuckyColor => 'Cor da Sorte';

  @override
  String get rashiLuckyDay => 'Dia da Sorte';

  @override
  String get rashiLuckyNumber => 'Número da Sorte';

  @override
  String get rashiGemstone => 'Pedra Preciosa';

  @override
  String get rashiBody => 'Corpo';

  @override
  String get gocharTodaysTransitChart => 'Mapa de Trânsito de Hoje';

  @override
  String get gocharTransit => 'Trânsito';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get thisMonth => 'Este Mês';

  @override
  String get best => 'Melhor';

  @override
  String get worst => 'Pior';

  @override
  String get avg => 'média';

  @override
  String get favorableLoveWindowsLabel => 'Janelas Favoráveis para o Amor';

  @override
  String get lordLabel => 'Senhor';

  @override
  String get lordPlacementLabel => 'Posicionamento do Senhor';

  @override
  String get lordDignityLabel => 'Dignidade do Senhor';

  @override
  String get categoriesSuffix => 'Categorias';

  @override
  String get coreBlockerLabel => 'BLOQUEIO CENTRAL';

  @override
  String get coreGiftLabel => '✦ DOM CENTRAL';

  @override
  String get coreThemeLabel => '● TEMA CENTRAL';

  @override
  String dominantLabel(Object value) {
    return 'Dominante: $value';
  }

  @override
  String get karakasSuffix => 'Karakas';

  @override
  String get protectiveLabel => 'PROTETOR';

  @override
  String secondaryLabel(Object value) {
    return ' · Secundário: $value';
  }

  @override
  String get tagCore => 'CENTRAL';

  @override
  String get debtScoresHeader => '📉 PONTUAÇÕES DE DÍVIDA';

  @override
  String get debtCurrentLoadStat => 'CARGA DE\nDÍVIDA ATUAL';

  @override
  String get debtRecoveryCapacityStat => 'CAPACIDADE DE\nRECUPERAÇÃO';

  @override
  String get debtIntensityStat => 'INTENSIDADE';

  @override
  String get debtDefaultRiskStat => 'RISCO DE INADIMPLÊNCIA';

  @override
  String get debtProfileTitle => 'Perfil de Dívida';

  @override
  String get debtKarmaLabel => 'CARMA';

  @override
  String get debtPersonalityLabel => 'PERSONALIDADE';

  @override
  String get debtPhaseLabel => 'FASE';

  @override
  String get debtPrimaryCategoryLabel => 'CATEGORIA PRIMÁRIA';

  @override
  String get debtWord => 'Dívida';

  @override
  String get debtYogasTitle => 'Yogas de Dívida';

  @override
  String get debtCreatingLabel => 'CRIA DÍVIDA';

  @override
  String get debtClearingLabel => 'QUITA DÍVIDA';

  @override
  String get yearlyDebtTitle => 'Dívida Anual';

  @override
  String get debtRepaymentTitle => 'Pagamento';

  @override
  String get debtDangerPeriodsTitle => 'Períodos de Perigo';

  @override
  String get debtDefaultPctStat => '% INADIMPLÊNCIA';

  @override
  String get debtBankruptcyPctStat => '% FALÊNCIA';

  @override
  String get debtChronicPctStat => '% CRÔNICO';

  @override
  String get debtResilienceStat => 'RESILIÊNCIA';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'Recuperação: $pct% · Cronograma: $years anos';
  }

  @override
  String get debtFreeWindowLabel => '🎯 JANELA DE LIBERDADE DE DÍVIDAS';

  @override
  String debtFreeYear(Object year) {
    return 'Ano $year';
  }

  @override
  String get legalScoresHeader => '⚖️ PONTUAÇÕES JURÍDICAS';

  @override
  String get legalVulnerabilityStat => 'VULNERABILIDADE\nJURÍDICA';

  @override
  String get legalVictoryPotentialStat => 'POTENCIAL DE\nVITÓRIA';

  @override
  String get legalConflictStat => 'CONFLITO';

  @override
  String get legalResolutionStat => 'RESOLUÇÃO';

  @override
  String get legalProfileTitle => 'Perfil Jurídico';

  @override
  String get legalKarmaTypeLabel => 'TIPO DE CARMA';

  @override
  String get legalConflictStyleLabel => 'ESTILO DE CONFLITO';

  @override
  String get legalStrategyLabel => 'ESTRATÉGIA';

  @override
  String get legalCaseDurationLabel => 'DURAÇÃO DO CASO';

  @override
  String get legalCurrentStatusLabel => 'STATUS ATUAL';

  @override
  String get legalWord => 'Jurídico';

  @override
  String get legalYogasTitle => 'Yogas Jurídicos';

  @override
  String get legalDisputePressureLabel => 'PRESSÃO DE DISPUTA';

  @override
  String get legalProtectionLabel => 'PROTEÇÃO JURÍDICA';

  @override
  String get legalStressTrendTitle => 'Estresse Jurídico';

  @override
  String get legalVisibleEnemiesStat => 'INIMIGOS VISÍVEIS';

  @override
  String get legalHiddenEnemiesStat => 'INIMIGOS OCULTOS';

  @override
  String get legalCriminalRiskStat => 'RISCO CRIMINAL';

  @override
  String get legalFalseAccusationStat => 'ACUSAÇÃO FALSA';

  @override
  String get legalContractKarmaTitle => 'Carma Contratual';

  @override
  String get legalDocumentationLabel => 'DOCUMENTAÇÃO';

  @override
  String get legalFinePrintAwareLabel => 'ATENÇÃO ÀS LETRAS MIÚDAS';

  @override
  String get legalNegotiationSkillLabel => 'HABILIDADE DE NEGOCIAÇÃO';

  @override
  String get legalSignatureCautionLabel => 'CAUTELA AO ASSINAR';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'Resiliência: $pct/100';
  }

  @override
  String get legalVictoryWord => 'Vitória';

  @override
  String get legalAnalysisSuffix => 'Análise';

  @override
  String get legalAsPlaintiff => 'COMO AUTOR';

  @override
  String get legalAsDefendant => 'COMO RÉU';

  @override
  String get legalWinProbability => 'PROBABILIDADE DE VITÓRIA';

  @override
  String get legalDisputeWord => 'Disputa';

  @override
  String get lifepathScoresHeader => '🌟 PONTUAÇÕES DO CAMINHO DE VIDA';

  @override
  String get lifepathDharmaClarityStat => 'CLAREZA DE\nDHARMA';

  @override
  String get lifepathFortuneBaselineStat => 'BASE DE\nFORTUNA';

  @override
  String get lifepathCoherenceStat => 'COERÊNCIA DO\nCAMINHO DE VIDA';

  @override
  String get lifepathKarmaStat => 'CARMA';

  @override
  String get lifepathSpiritualStat => 'ESPIRITUAL';

  @override
  String get lifepathFameStat => 'FAMA';

  @override
  String get lifepathSoulContractTitle => 'Contrato da Alma';

  @override
  String get lifepathAtmakarakaLabel => 'ATMAKARAKA';

  @override
  String get lifepathAkFocusLabel => 'FOCO DO AK';

  @override
  String get lifepathSoulPurposeLabel => 'PROPÓSITO DA ALMA';

  @override
  String get lifepathLifeChapterLabel => 'CAPÍTULO DE VIDA';

  @override
  String get lifepathPrimaryDomainLabel => 'DOMÍNIO PRIMÁRIO';

  @override
  String get lifepathLeadershipStat => 'LIDERANÇA';

  @override
  String get lifepathWisdomTeachStat => 'SABEDORIA/ENSINO';

  @override
  String get lifepathServiceStat => 'SERVIÇO';

  @override
  String get lifepathHealingStat => 'CURA';

  @override
  String get lifepathFortuneYogasTitle => 'Yogas de Fortuna';

  @override
  String get lifepathLuckBlocksLabel => 'BLOQUEIOS DE SORTE';

  @override
  String get lifepathFortuneBoostersLabel => 'IMPULSIONADORES DE FORTUNA';

  @override
  String get lifepathFortuneTrendTitle => 'Tendência de Fortuna';

  @override
  String get lifepathGoldenWindowsTitle => 'Janelas Douradas ★';

  @override
  String get lifepathTransformationTitle => 'Transformação';

  @override
  String get lifepathMilestonesTitle => 'Marcos de Vida';

  @override
  String get lifepathKarmicLessonsTitle => 'Lições Cármicas';

  @override
  String get lifepathRahuGrowthLabel => 'CRESCIMENTO DE RAHU';

  @override
  String get lifepathKetuSurrenderLabel => 'ENTREGA DE KETU';

  @override
  String get lifepathSaturnLessonLabel => 'LIÇÃO DE SATURNO';

  @override
  String get lifepathLifeDifficultyLabel => 'DIFICULDADE DE VIDA';

  @override
  String get lifepathSoulExperienceTitle => '★ A ALMA VEIO EXPERIMENTAR';

  @override
  String get lifepathBlessingsTitle => '● BÊNÇÃOS';

  @override
  String get lifepathLifeWord => 'Vida';

  @override
  String get lifepathArchetypeSuffix => 'Arquétipo';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'Realização: $pct%';
  }

  @override
  String get lifepathDestinyVsWord => 'Destino vs';

  @override
  String get lifepathFreeWillSuffix => 'Livre-Arbítrio';

  @override
  String get lifepathDestinyStat => 'DESTINO';

  @override
  String get lifepathFreeWillStat => 'LIVRE-ARBÍTRIO';

  @override
  String get pastlifeScoresHeader => '🔮 PONTUAÇÕES DE VIDA PASSADA';

  @override
  String get pastlifeSignatureStrengthStat => 'FORÇA DA\nASSINATURA';

  @override
  String get pastlifeCarryForwardStat => 'TRANSPORTADO\nADIANTE';

  @override
  String get pastlifeMasteryPreservedStat => 'MAESTRIA\nPRESERVADA';

  @override
  String get pastlifeUnfinishedStat => 'INACABADO';

  @override
  String get pastlifeKarmicDebtStat => 'DÍVIDA CÁRMICA';

  @override
  String get pastlifeProfileTitle => 'Perfil de Vida Passada';

  @override
  String get pastlifeThemeLabel => 'TEMA';

  @override
  String get pastlifeProfessionLabel => 'PROFISSÃO';

  @override
  String get pastlifeSocialStandingLabel => 'POSIÇÃO SOCIAL';

  @override
  String get pastlifeRegionLabel => 'REGIÃO';

  @override
  String get pastlifeSpiritualLevelLabel => 'NÍVEL ESPIRITUAL';

  @override
  String get pastlifeGenderLabel => 'GÊNERO';

  @override
  String get pastlifeWealthLevelLabel => 'NÍVEL DE RIQUEZA';

  @override
  String get pastlifeFamilyRoleLabel => 'PAPEL NA FAMÍLIA';

  @override
  String get pastlifeSkillsCarriedTitle => '★ HABILIDADES TRANSPORTADAS';

  @override
  String get pastlifeNaturalAttractionsTitle => '● ATRAÇÕES NATURAIS';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ MEDOS INEXPLICÁVEIS';

  @override
  String get pastlifeMagneticPullsTitle => '→ ATRAÇÕES MAGNÉTICAS';

  @override
  String get pastlifeRelationshipStat => 'RELACIONAMENTO';

  @override
  String get pastlifeFinancialStat => 'FINANCEIRO';

  @override
  String get pastlifeServiceStat => 'SERVIÇO';

  @override
  String get pastlifeDharmicStat => 'DHÁRMICO';

  @override
  String get pastlifeOnRelationsStat => 'NOS RELACIONAMENTOS';

  @override
  String get pastlifeOnCareerStat => 'NA CARREIRA';

  @override
  String get pastlifeOnHealthStat => 'NA SAÚDE';

  @override
  String get pastlifeOnSpiritualStat => 'NA ESPIRITUALIDADE';

  @override
  String get pastlifeKarmicResolutionTitle => 'Resolução Cármica';

  @override
  String get pastlifePrimaryPathLabel => 'CAMINHO PRIMÁRIO';

  @override
  String get pastlifeSecondaryPathLabel => 'CAMINHO SECUNDÁRIO';

  @override
  String get pastlifeClearingProgressLabel => 'PROGRESSO DA LIMPEZA';

  @override
  String get pastlifeRemainingWorkLabel => 'TRABALHO RESTANTE';

  @override
  String get pastlifeDebtTimelineLabel => 'CRONOGRAMA DA DÍVIDA';

  @override
  String get pastlifeMemoryAccessStat => 'ACESSO À MEMÓRIA';

  @override
  String get pastlifeDreamVisitsStat => 'VISITAS EM SONHOS';

  @override
  String get pastlifeDejaVuStat => 'DÉJÀ VU';

  @override
  String get pastlifeRegressionFitStat => 'APTIDÃO PARA REGRESSÃO';

  @override
  String get pastlifeActivationTitle => 'Ativação de Vida Passada';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'Maturidade: $maturity · Status: $status';
  }

  @override
  String get pastlifeKetuWord => 'Ketu';

  @override
  String get pastlifePastMasterySuffix => 'Maestria Passada';

  @override
  String get pastlifeKetuMasteredLabel => 'KETU · O QUE VOCÊ DOMINOU';

  @override
  String get pastlifeRahuWord => 'Rahu';

  @override
  String get pastlifeFutureGrowthSuffix => 'Crescimento Futuro';

  @override
  String get pastlifeRahuPullsLabel => 'RAHU · O QUE TE PUXA ADIANTE';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ Sombra: $shadow';
  }

  @override
  String get mentalScoresHeader => '🧠 PONTUAÇÕES MENTAIS';

  @override
  String get mentalStabilityStat => 'ESTABILIDADE\nMENTAL';

  @override
  String get mentalEmotionalBaselineStat => 'BASE\nEMOCIONAL';

  @override
  String get mentalResilienceStat => 'RESILIÊNCIA';

  @override
  String get mentalAnxietyStat => 'ANSIEDADE';

  @override
  String get mentalDepressionStat => 'DEPRESSÃO';

  @override
  String get mentalRegulationStat => 'REGULAÇÃO';

  @override
  String get mentalProfileTitle => 'Perfil Mental';

  @override
  String get mentalConstitutionLabel => 'CONSTITUIÇÃO';

  @override
  String get mentalStressDriverLabel => 'FATOR DE ESTRESSE';

  @override
  String get mentalStabilityAnchorLabel => 'ÂNCORA DE ESTABILIDADE';

  @override
  String get mentalStressResponseLabel => 'RESPOSTA AO ESTRESSE';

  @override
  String get mentalAttachmentStyleLabel => 'ESTILO DE APEGO';

  @override
  String get mentalBurnoutStageLabel => 'ESTÁGIO DE ESGOTAMENTO';

  @override
  String get mentalWord => 'Mental';

  @override
  String get mentalYogasTitle => 'Yogas Mentais';

  @override
  String get mentalStressPressureLabel => 'PRESSÃO DE ESTRESSE';

  @override
  String get mentalWellnessTrendTitle => 'Tendência de Bem-Estar';

  @override
  String get mentalHealthyCopingTitle => '✓ ENFRENTAMENTO SAUDÁVEL';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ RISCOS NÃO SAUDÁVEIS';

  @override
  String get mentalRecommendedAlternativesTitle =>
      '✦ ALTERNATIVAS RECOMENDADAS';

  @override
  String get mentalSleepQualityStat => 'QUALIDADE DO SONO';

  @override
  String get mentalSocialSupportStat => 'APOIO SOCIAL';

  @override
  String get mentalBurnoutVulnStat => 'VULN. AO ESGOTAMENTO';

  @override
  String get mentalSelfAwarenessStat => 'AUTOCONSCIÊNCIA';

  @override
  String get mentalAnxietyWord => 'Ansiedade';

  @override
  String get mentalTypesSuffix => 'Tipos';

  @override
  String get mentalTherapyWord => 'Terapia';

  @override
  String get mentalModalityFitSuffix => 'Compatibilidade de Modalidade';

  @override
  String get characterScoresHeader => '🔍 PONTUAÇÕES DE CARÁTER';

  @override
  String get characterStrengthStat => 'FORÇA DE\nCARÁTER';

  @override
  String get characterIntegrityStat => 'INTEGRIDADE';

  @override
  String get characterResilienceStat => 'RESILIÊNCIA';

  @override
  String get characterAwarenessStat => 'CONSCIÊNCIA';

  @override
  String get characterStabilityStat => 'ESTABILIDADE';

  @override
  String get characterEthicsStat => 'ÉTICA';

  @override
  String get characterSurfacePersonalityTitle => 'Personalidade Aparente';

  @override
  String get characterLagnaLabel => 'LAGNA';

  @override
  String get characterConstitutionLabel => 'CONSTITUIÇÃO';

  @override
  String get characterNakshatraLabel => 'NAKSHATRA';

  @override
  String get characterDeityLabel => 'DIVINDADE';

  @override
  String get characterMoonManasTitle => 'Manas Lunar';

  @override
  String get characterSignLabel => 'SIGNO';

  @override
  String get characterHouseLabel => 'CASA';

  @override
  String get characterWarmthStat => 'CALOR HUMANO';

  @override
  String get characterEmpathyStat => 'EMPATIA';

  @override
  String get characterLoyaltyStat => 'LEALDADE';

  @override
  String get characterBoundariesStat => 'LIMITES';

  @override
  String get characterDharmaStat => 'DHARMA';

  @override
  String get characterTruthStat => 'VERDADE';

  @override
  String get characterCompassionStat => 'COMPAIXÃO';

  @override
  String get characterGenerosityStat => 'GENEROSIDADE';

  @override
  String get characterSignatureVirtuesTitle => '★ VIRTUDES CARACTERÍSTICAS';

  @override
  String get characterNaturalTalentsTitle => '● TALENTOS NATURAIS';

  @override
  String get characterShadowPatternsTitle => '⚠ PADRÕES DE SOMBRA';

  @override
  String get characterYogasTitle => 'Yogas de Caráter';

  @override
  String get characterTestsLabel => 'TESTES';

  @override
  String get characterGiftsLabel => 'DONS';

  @override
  String get characterSelfAwareEiStat => 'IE AUTOCONSCIENTE';

  @override
  String get characterSelfRegulateStat => 'AUTORREGULAÇÃO';

  @override
  String get characterEmpathyEiStat => 'IE EMPATIA';

  @override
  String get characterSocialSkillsStat => 'HABILIDADES SOCIAIS';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'Realização: $pct%';
  }

  @override
  String get characterAtmakarakaWord => 'Atmakaraka';

  @override
  String get characterSoulSignatureSuffix => 'Assinatura da Alma';

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
  String get healthScoresHeader => '🏥 PONTUAÇÕES DE SAÚDE';

  @override
  String get healthVitalityStat => 'VITALIDADE';

  @override
  String get healthImmunityStat => 'IMUNIDADE';

  @override
  String get healthRecoveryStat => 'RECUPERAÇÃO';

  @override
  String get healthMentalStat => 'MENTAL';

  @override
  String get healthStressTolStat => 'TOL. AO ESTRESSE';

  @override
  String get healthYogasTitle => 'Yogas de Saúde';

  @override
  String get healthDiseasePressureLabel => 'PRESSÃO DE DOENÇA';

  @override
  String get healthTrendTitle => 'Tendência de Saúde';

  @override
  String get healthRecoveryWindowsTitle => 'Janelas de Recuperação';

  @override
  String get healthCautionPeriodsTitle => 'Períodos de Cautela';

  @override
  String get healthFertilityStat => 'FERTILIDADE';

  @override
  String get healthBurnoutRiskStat => 'RISCO DE ESGOTAMENTO';

  @override
  String get healthAddictionVulnStat => 'VULN. À DEPENDÊNCIA';

  @override
  String get healthWorkLifeBalStat => 'EQUILÍBRIO TRABALHO-VIDA';

  @override
  String get healthAyurvedicWord => 'Ayurvédica';

  @override
  String get healthConstitutionSuffix => 'Constituição';

  @override
  String get healthBodyWord => 'Corpo';

  @override
  String get healthSystemMapSuffix => 'Mapa de Sistemas';

  @override
  String get healthBodyZoneWord => 'Zona Corporal';

  @override
  String get healthVulnerabilitySuffix => 'Vulnerabilidade';

  @override
  String get healthDiseaseWord => 'Doença';

  @override
  String get healthSusceptibilitySuffix => 'Suscetibilidade';

  @override
  String get healthLifestyleFactorsTitle => 'Fatores de Estilo de Vida';

  @override
  String get healthSleepDisciplineLabel => 'DISCIPLINA DO SONO';

  @override
  String get healthDietDisciplineLabel => 'DISCIPLINA ALIMENTAR';

  @override
  String get healthExerciseNeedLabel => 'NECESSIDADE DE EXERCÍCIO';

  @override
  String get healthSunlightNeedLabel => 'NECESSIDADE DE SOL';

  @override
  String get healthSocialTypeLabel => 'TIPO SOCIAL';

  @override
  String get healthHealingSpeedLabel => 'VELOCIDADE DE CURA';

  @override
  String get wealthScoresHeader => '💰 PONTUAÇÕES DE RIQUEZA';

  @override
  String get wealthStrengthStat => 'FORÇA DE\nRIQUEZA';

  @override
  String get wealthAccumulationStat => 'ACUMU-\nLAÇÃO';

  @override
  String get wealthIncomeFlowStat => 'FLUXO DE\nRENDA';

  @override
  String get wealthSustainStat => 'SUSTENTABILIDADE';

  @override
  String get wealthMultiStreamStat => 'MÚLTIPLAS FONTES';

  @override
  String get wealthRetentionStat => 'RETENÇÃO';

  @override
  String get wealthWord => 'Riqueza';

  @override
  String get wealthYogasTitle => 'Yogas de Riqueza';

  @override
  String get wealthDrainsLabel => 'DRENOS';

  @override
  String get wealthBoostersLabel => 'IMPULSIONADORES';

  @override
  String get wealthYearlyTrendTitle => 'Tendência Anual';

  @override
  String get wealthGrowthTitle => 'Crescimento de Riqueza';

  @override
  String get wealthCashPressureTitle => 'Pressão de Caixa';

  @override
  String get wealthMoneyPersonalityTitle => 'Personalidade Financeira';

  @override
  String get wealthTypeLabel => 'TIPO DE RIQUEZA';

  @override
  String get wealthRiskAppetiteLabel => 'APETITE AO RISCO';

  @override
  String get wealthInvestmentStyleLabel => 'ESTILO DE INVESTIMENTO';

  @override
  String get wealthMoneyPersonalityLabel => 'PERSONALIDADE FINANCEIRA';

  @override
  String get wealthSpendingLabel => 'GASTOS';

  @override
  String get wealthDebtProbStat => '% PROB. DE DÍVIDA';

  @override
  String get wealthInheritanceStat => '% HERANÇA';

  @override
  String get wealthSuddenGainsStat => '% GANHOS REPENTINOS';

  @override
  String get wealthSpouseBoostStat => '% IMPULSO DO CÔNJUGE';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'Probabilidade de sucesso: $pct%';
  }

  @override
  String get wealthLifetimeClassLabel => 'CLASSE DE RIQUEZA VITALÍCIA';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'Principal: $value';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'Pico: $value';
  }

  @override
  String get wealthIncomeWord => 'Renda';

  @override
  String get wealthSourcesSuffix => 'Fontes';

  @override
  String get wealthInvestmentWord => 'Investimento';

  @override
  String get wealthMixSuffix => 'Mix';

  @override
  String wealthDrivenByLabel(Object planet) {
    return 'Impulsionado por $planet';
  }

  @override
  String get marriageScoresHeader => '💒 PONTUAÇÕES DE CASAMENTO';

  @override
  String get marriageOverallStat => 'CASAMENTO\nGERAL';

  @override
  String get marriageHarmonyStat => 'HARMONIA\nCONJUGAL';

  @override
  String get marriageDomesticStabilityStat => 'ESTABILIDADE\nDOMÉSTICA';

  @override
  String get marriageLongevityStat => 'LONGEVIDADE';

  @override
  String get marriageSatisfactionStat => 'SATISFAÇÃO';

  @override
  String get marriageClarityStat => 'CLAREZA';

  @override
  String get marriageWindowsTitle => 'Janelas de Casamento';

  @override
  String get marriagePhasesTitle => 'Fases do Casamento';

  @override
  String get marriageInLawRelationsStat => 'RELAÇÃO COM SOGROS';

  @override
  String get marriageFamilyHarmonyStat => 'HARMONIA FAMILIAR';

  @override
  String get marriageFertilityStat => 'FERTILIDADE';

  @override
  String get marriageHomeOwnershipStat => 'POSSE DE IMÓVEL';

  @override
  String get marriageDivorceRiskStat => 'RISCO DE DIVÓRCIO';

  @override
  String get marriageInfidelityStat => 'INFIDELIDADE';

  @override
  String get marriageConflictStat => 'CONFLITO';

  @override
  String get marriageDistanceStat => 'DISTÂNCIA';

  @override
  String get marriageSeekInPartnerTitle => '★ PROCURE NO PARCEIRO';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ EVITE NO PARCEIRO';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'Realização: $pct%';
  }

  @override
  String get marriageDarakarakaWord => 'Darakaraka';

  @override
  String get marriageSpouseKarakaSuffix => 'Karaka do Cônjuge';

  @override
  String get marriageDarakarakaDkLabel => 'DARAKARAKA (DK)';

  @override
  String get marriage7thWord => '7ª';

  @override
  String get marriageSignLabel => 'SIGNO';

  @override
  String get marriageLordInLabel => 'SENHOR EM';

  @override
  String get marriageStrengthLabel => 'FORÇA';

  @override
  String get marriageSpouseWord => 'Cônjuge';

  @override
  String get marriageProfileSuffix => 'Perfil';

  @override
  String get marriageSpouseTraitsTitle => '★ TRAÇOS DO CÔNJUGE';

  @override
  String get marriageLikelyProfessionsTitle => '● PROFISSÕES PROVÁVEIS';

  @override
  String get marriageHarmonyWord => 'Harmonia';

  @override
  String get marriageRadarSuffix => 'Radar';

  @override
  String get marriagePhysicalLabel => 'Físico';

  @override
  String get marriageSharedValuesLabel => 'Valores Compartilhados';

  @override
  String get marriageConflictResolutionLabel => 'Resolução de Conflitos';

  @override
  String get marriageMangalDoshLabel => '⚠ MANGAL DOSH';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'Severidade: $value';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'Cancelamento: $value';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'Navamsa';

  @override
  String get multiChartTitleChild => 'Filho';

  @override
  String get multiChartTitleLove => 'Amor';

  @override
  String get multiChartTitleKarma => 'Carma';

  @override
  String get multiChartTitleDefault => 'Multi-Mapa';

  @override
  String get multiChartSuffixProbability => 'Probabilidade';

  @override
  String get multiChartSuffixCompatibility => 'Compatibilidade';

  @override
  String get multiChartSuffixLinkage => 'Ligação';

  @override
  String get multiChartSuffixReport => 'Relatório';

  @override
  String get multiChartParticipantsLabel => 'PARTICIPANTES';

  @override
  String get multiChartAnalysisWord => 'Análise';

  @override
  String get multiChartConfidenceSuffix => 'Confiança';

  @override
  String get multiChartQualityBadge => 'QUALIDADE';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'Analise este relatório de astrologia védica e forneça insights detalhados:\n\n$formatted';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'Aqui está um relatório especializado de astrologia védica. Por favor, analise-o minuciosamente e forneça insights acionáveis:\n\n$formatted';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'Revise esta análise de astrologia védica e explique as principais descobertas em linguagem simples:\n\n$formatted';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return 'Copiado para $label!';
  }

  @override
  String get childProbTitle1 => 'Probabilidade';

  @override
  String get childProbTitle2 => 'de Filhos';

  @override
  String get childNumberOfChildrenHeader1 => 'Número de';

  @override
  String get childNumberOfChildrenHeader2 => 'Filhos';

  @override
  String get childTimingHeader1 => 'Timing';

  @override
  String get childTimingHeader2 => 'Moola Dasha';

  @override
  String get child5thHouseHeader1 => 'Casa 5';

  @override
  String get analysisWord => 'Análise';

  @override
  String get jupiterWord => 'Júpiter';

  @override
  String get childD7Header1 => 'D7 Saptamsa';

  @override
  String get childBeejaHeader1 => 'Beeja e Kshetra';

  @override
  String get childBeejaHeader2 => 'Sphuta';

  @override
  String get childDoshaHeader1 => 'Dosha';

  @override
  String get childVedicHeader1 => 'Remédios';

  @override
  String get childVedicHeader2 => 'Védicos';

  @override
  String get progenyProbabilityLabel => 'PROBABILIDADE DE PROLE';

  @override
  String get favorableWindowsLabel => 'JANELAS FAVORÁVEIS';

  @override
  String get partnerOneLabel => 'Parceiro 1';

  @override
  String get partnerTwoLabel => 'Parceiro 2';

  @override
  String get moonSignLabel => 'Signo Lunar';

  @override
  String get lordInDusthana => 'Senhor em Dusthana';

  @override
  String get lordStrengthLabel => 'Força do Senhor';

  @override
  String get houseStrengthLabel => 'Força da Casa';

  @override
  String get dignityLabel => 'Dignidade';

  @override
  String get directBadge => 'Direto';

  @override
  String get notCombustBadge => 'Não Combusto';

  @override
  String get in5thHouseBadge => 'Na Casa 5';

  @override
  String get aspects5thBadge => 'Aspecta a Casa 5';

  @override
  String get no5thConnectionBadge => 'Sem Conexão com a Casa 5';

  @override
  String jupiterInSignHeading(String sign) {
    return 'Júpiter em $sign';
  }

  @override
  String get d7LagnaLabel => 'Lagna do D7';

  @override
  String get d7FifthSignLabel => 'Signo da Casa 5 no D7';

  @override
  String get d7FifthLordLabel => 'Senhor da Casa 5 no D7';

  @override
  String get jupiterInD7Label => 'Júpiter no D7';

  @override
  String get jupiterDignityLabel => 'Dignidade de Júpiter';

  @override
  String get d7StrengthLabel => 'Força do D7';

  @override
  String get yesWord => 'Sim';

  @override
  String get noWord => 'Não';

  @override
  String get beejaSphutaTitle => 'BEEJA SPHUTA';

  @override
  String get kshetraSphutaTitle => 'KSHETRA SPHUTA';

  @override
  String get degreeLabel => 'Grau';

  @override
  String get signLordLabel => 'Senhor do Signo';

  @override
  String get presentInLabel => 'Presente Em';

  @override
  String get netPenaltyLabel => 'Penalidade Líquida';

  @override
  String get remedyGemstone => 'Remédios com Pedras Preciosas';

  @override
  String get remedyMantra => 'Remédios com Mantras';

  @override
  String get remedyRitual => 'Remédios Rituais';

  @override
  String get remedyLifestyle => 'Remédios de Estilo de Vida';

  @override
  String get remedyCharitable => 'Remédios de Caridade';

  @override
  String copiedForName(String name) {
    return 'Copiado para $name!';
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
  String get favorabilityLabel => 'Favorabilidade';

  @override
  String factorPrefix(String factor) {
    return 'Fator: $factor';
  }

  @override
  String appliesToLabel(String value) {
    return 'Aplica-se a: $value';
  }

  @override
  String get qualityTag => 'QUALIDADE';

  @override
  String get reliabilityVeryHigh => 'Confiabilidade Muito Alta';

  @override
  String get reliabilityGuidanceLevel => 'Leitura de nível orientativo';

  @override
  String get karmaLinkTitle1 => 'Ligação';

  @override
  String get karmaLinkTitle2 => 'Cármica';

  @override
  String get karmaFoundationHeader1 => 'Fundação';

  @override
  String get karmaFoundationHeader2 => 'Cármica';

  @override
  String get karmaPairwiseHeader1 => 'Ligações';

  @override
  String get karmaPairwiseHeader2 => 'entre Pares';

  @override
  String get karmaGroupHeader1 => 'Padrão';

  @override
  String get karmaGroupHeader2 => 'de Grupo';

  @override
  String get karmaPastLifeHeader1 => 'Objetivos de';

  @override
  String get karmaPastLifeHeader2 => 'Vida Passada';

  @override
  String get karmaCurrentLifeHeader1 => 'Vida Atual';

  @override
  String get karmaCurrentLifeHeader2 => 'Aprendizado';

  @override
  String get karmaDebtsHeader2 => 'Dívidas';

  @override
  String get karmaMoolaDashaHeader1 => 'Timing da';

  @override
  String get karmaMoolaDashaHeader2 => 'Moola Dasha';

  @override
  String get karmaDeepAuditHeader1 => 'Tabela de';

  @override
  String get karmaDeepAuditHeader2 => 'Auditoria Detalhada';

  @override
  String get karmaHeroLabel => 'LIGAÇÃO CÁRMICA DE VIDA PASSADA';

  @override
  String get karmaKetuMastery => 'MAESTRIA DE KETU';

  @override
  String get nakshatraLabel => 'Nakshatra';

  @override
  String get deityLabel => 'Divindade';

  @override
  String get masteryScoreLabel => 'Pontuação de Maestria';

  @override
  String get karmaRahuGrowth => 'CRESCIMENTO DE RAHU';

  @override
  String get growthScoreLabel => 'Pontuação de Crescimento';

  @override
  String get karmaAtmakaraka => 'ATMAKARAKA';

  @override
  String get karmaSaturnKarma => 'CARMA DE SATURNO';

  @override
  String get karma12thHouse => 'CASA 12';

  @override
  String get karma9thHousePunya => 'PUNYA DA CASA 9';

  @override
  String get bhavaScoreLabel => 'Pontuação de Bhava';

  @override
  String get karmaD60Signature => 'ASSINATURA D60';

  @override
  String get depthScoreLabel => 'Pontuação de Profundidade';

  @override
  String get linkageStrengthLabel => 'Força da Ligação';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'FATORES DE LIGAÇÃO ($count ativos)';
  }

  @override
  String get factorColumnLabel => 'Fator';

  @override
  String get weightColumnLabel => 'Peso';

  @override
  String get meaningColumnLabel => 'Significado';

  @override
  String get statusColumnLabel => 'Status';

  @override
  String get karmaPastLifeConnection => 'CONEXÃO DE VIDA PASSADA';

  @override
  String get karmaCurrentLifeDynamic => 'DINÂMICA DA VIDA ATUAL';

  @override
  String get karmaWhatTheyTeach => 'O QUE ENSINAM UM AO OUTRO';

  @override
  String get karmaGroupThemeHeader => 'TEMA CÁRMICO DO GRUPO';

  @override
  String get karmaSharedSettingHeader =>
      'CENÁRIO COMPARTILHADO DE VIDA PASSADA';

  @override
  String get karmaCollectiveKetuHeader => 'PADRÃO COLETIVO DE KETU';

  @override
  String get karmaCollectiveRahuHeader => 'PADRÃO COLETIVO DE RAHU';

  @override
  String get housesPrefixLabel => 'Casas: ';

  @override
  String get signsPrefixLabel => 'Signos: ';

  @override
  String get karmicCohesionLabel => 'Coesão Cármica';

  @override
  String get karmaGroupSoulContractHeader => 'CONTRATO DE ALMA DO GRUPO';

  @override
  String get goalLabel => 'Objetivo';

  @override
  String get karmaSharedGoalHeader => 'OBJETIVO COMPARTILHADO DE VIDA PASSADA';

  @override
  String get howToGrowHeader => 'COMO CRESCER';

  @override
  String moolaDashaPrefix(String value) {
    return 'Moola Dasha: $value';
  }

  @override
  String get karmaSharedLessonHeader => 'LIÇÃO COMPARTILHADA DO GRUPO';

  @override
  String get karmaMutualTeachingHeader => 'MAPA DE ENSINO MÚTUO';

  @override
  String get karmaTeachingDynamicsPlaceholder =>
      'As dinâmicas de ensino surgirão à medida que as conexões cármicas se aprofundarem.';

  @override
  String get typeFieldLabel => 'Tipo';

  @override
  String get basisFieldLabel => 'Base';

  @override
  String get resolutionPathHeader => 'CAMINHO DE RESOLUÇÃO';

  @override
  String dashaTimingPrefix(String value) {
    return 'Timing de Dasha: $value';
  }

  @override
  String get mutualDebtsHeader => 'DÍVIDAS MÚTUAS';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'Datas';

  @override
  String get groupKarmicWindowHeader => 'JANELA CÁRMICA DO GRUPO';

  @override
  String parametersAuditedHeading(int count) {
    return '$count PARÂMETROS AUDITADOS';
  }

  @override
  String get valuePrefixLabel => 'Valor: ';

  @override
  String weightPrefix(String value) {
    return 'P: $value';
  }

  @override
  String get loveCompatTitle1 => 'Compatibilidade';

  @override
  String get loveCompatTitle2 => 'Amorosa';

  @override
  String get loveAttractionHeader1 => 'Atração e';

  @override
  String get loveAttractionHeader2 => 'Química';

  @override
  String get loveEmotionalHeader1 => 'Harmonia';

  @override
  String get loveEmotionalHeader2 => 'Emocional';

  @override
  String get loveMentalHeader1 => 'Sintonia';

  @override
  String get loveMentalHeader2 => 'Mental';

  @override
  String get lovePassionHeader1 => 'Paixão e';

  @override
  String get lovePassionHeader2 => 'Físico';

  @override
  String get loveLongtermHeader1 => 'Longo Prazo';

  @override
  String get loveKarmicHeader1 => 'Vínculo Amoroso';

  @override
  String get loveKarmicHeader2 => 'Cármico';

  @override
  String get loveChallengesHeader1 => 'Desafios e';

  @override
  String get loveChallengesHeader2 => 'Atritos';

  @override
  String get loveTimingHeader1 => 'Timing do Amor';

  @override
  String get loveRelationshipHeader1 => 'Dinâmica do';

  @override
  String get loveRelationshipHeader2 => 'Relacionamento';

  @override
  String get loveRemediesHeader1 => 'Remédios e';

  @override
  String get loveRemediesHeader2 => 'Orientação';

  @override
  String get loveCompatHeroLabel => 'COMPATIBILIDADE AMOROSA';

  @override
  String get loveChipAttraction => 'Atração';

  @override
  String get loveChipPassion => 'Paixão';

  @override
  String get loveChipChallenge => 'Desafio';

  @override
  String get venusSignLabel => 'Signo de Vênus';

  @override
  String get attractionScoreLabel => 'Pontuação de Atração';

  @override
  String get activeContactsLabel => 'Contatos Ativos';

  @override
  String get magneticPullLabel => 'Atração Magnética';

  @override
  String get initialAttractionLabel => 'Atração Inicial';

  @override
  String get emotionalScoreLabel => 'Pontuação Emocional';

  @override
  String get elementMatchLabel => 'Compatibilidade Elemental';

  @override
  String get harmonyLabel => 'Harmonia';

  @override
  String get kootaYoni => 'YONI';

  @override
  String get kootaGana => 'GANA';

  @override
  String get kootaTara => 'TARA';

  @override
  String get doshaPresentBadge => 'Dosha Presente';

  @override
  String get noDoshaBadge => 'Sem Dosha';

  @override
  String get axisLabel => 'Eixo';

  @override
  String get mentalScoreLabel => 'Pontuação Mental';

  @override
  String get mercuryDynamicsLabel => 'DINÂMICA DE MERCÚRIO';

  @override
  String get communicationStyleLabel =>
      'COMPATIBILIDADE DE ESTILO DE COMUNICAÇÃO';

  @override
  String get intellectualConnectionLabel => 'CONEXÃO INTELECTUAL';

  @override
  String get passionScoreLabel => 'Pontuação de Paixão';

  @override
  String get marsVenusLabel => 'INTERAÇÃO MARTE-VÊNUS';

  @override
  String get physicalChemistryLabel => 'QUÍMICA FÍSICA';

  @override
  String get yoniCompatLabel => 'COMPATIBILIDADE YONI';

  @override
  String get longtermScoreLabel => 'Pontuação de Longo Prazo';

  @override
  String get seventhHouseSynastryLabel => 'SINASTRIA DA CASA 7';

  @override
  String get commitmentPotentialLabel => 'POTENCIAL DE COMPROMISSO';

  @override
  String get jupiterBlessingLabel => 'BÊNÇÃO DE JÚPITER';

  @override
  String get d9NavamsaResonanceLabel => 'RESSONÂNCIA D9 NAVAMSA';

  @override
  String get saturnLongevityLabel => 'LONGEVIDADE DE SATURNO';

  @override
  String get karmicScoreLabel => 'Pontuação Cármica';

  @override
  String get darakarakaLinkLabel => 'LIGAÇÃO DARAKARAKA';

  @override
  String get sourceLabel => 'Fonte';

  @override
  String get emotionalGiverReceiverLabel => 'DOADOR / RECEPTOR EMOCIONAL';

  @override
  String get powerBalanceLabel => 'EQUILÍBRIO DE PODER';

  @override
  String get growthDynamicLabel => 'DINÂMICA DE CRESCIMENTO';

  @override
  String get addressesLabel => 'Aborda';

  @override
  String get loveScoresLabel => 'PONTUAÇÕES DE AMOR';

  @override
  String get loveCapacityLabel => 'CAPACIDADE\nDE AMOR';

  @override
  String get emotionalAvailabilityLabel => 'DISPONIBILIDADE\nEMOCIONAL';

  @override
  String get romanticAttractionLabel => 'ATRAÇÃO\nROMÂNTICA';

  @override
  String get commitmentWord => 'COMPROMISSO';

  @override
  String get intimacyWord => 'INTIMIDADE';

  @override
  String get fidelityWord => 'FIDELIDADE';

  @override
  String get loveProfileTitle => 'Perfil Amoroso';

  @override
  String get loveStyleLabel => 'ESTILO AMOROSO';

  @override
  String get attractionStyleLabel => 'ESTILO DE ATRAÇÃO';

  @override
  String get lovePathLabel => 'CAMINHO AMOROSO';

  @override
  String get currentPhaseLabel => 'FASE ATUAL';

  @override
  String get commitmentStyleLabel => 'ESTILO DE COMPROMISSO';

  @override
  String get loveWord => 'Amor';

  @override
  String get karakasWord => 'Karakas';

  @override
  String get attractedToLabel => 'ATRAÍDO POR';

  @override
  String get whatPartnerSeesLabel => 'O QUE O PARCEIRO VÊ';

  @override
  String get romancePatternTitle => 'Padrão Romântico';

  @override
  String get firstLoveAgeLabel => 'IDADE DO PRIMEIRO AMOR';

  @override
  String get relationshipCountLabel => 'NÚMERO DE RELACIONAMENTOS';

  @override
  String get avgDurationLabel => 'DURAÇÃO MÉDIA';

  @override
  String get breakupTriggerLabel => 'GATILHO DE ROMPIMENTO';

  @override
  String get heartbreakRecoveryLabel => 'RECUPERAÇÃO DE SOFRIMENTO AMOROSO';

  @override
  String get loveTrendTitle => 'Tendência Amorosa';

  @override
  String get newLoveWindowsTitle => 'Janelas para Novo Amor';

  @override
  String get loveBlocksTitle => 'Bloqueios Amorosos';

  @override
  String get activeBlocksLabel => 'BLOQUEIOS ATIVOS';

  @override
  String get loveMarriagePctLabel => '% CASAMENTO POR AMOR';

  @override
  String get heartbreakVulnLabel => 'VULN. AO SOFRIMENTO AMOROSO';

  @override
  String get selfSabotageLabel => 'AUTOSSABOTAGEM';

  @override
  String get emotionalIqLabel => 'QI EMOCIONAL';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'Realização: $pct%';
  }

  @override
  String get languagesWord => 'Linguagens';

  @override
  String get givesLabel => 'DÁ';

  @override
  String get receivesLabel => 'RECEBE';

  @override
  String get idealWord => 'Ideal';

  @override
  String get partnerWord => 'Parceiro';

  @override
  String get seekTheseTraitsLabel => 'PROCURE ESSES TRAÇOS';

  @override
  String get dealbreakersLabel => 'FATORES DECISIVOS NEGATIVOS';

  @override
  String get propertyScoresLabel => 'PONTUAÇÕES DE PROPRIEDADE';

  @override
  String get acquisitionCapacityLabel => 'CAPACIDADE DE\nAQUISIÇÃO';

  @override
  String get homeOwnershipPctLabel => '% POSSE\nDE IMÓVEL';

  @override
  String get reWealthPotentialLabel => 'POTENCIAL DE\nRIQUEZA IMOBILIÁRIA';

  @override
  String get rentalWord => 'ALUGUEL';

  @override
  String get vehiclesWord => 'VEÍCULOS';

  @override
  String get landPctLabel => '% TERRAS';

  @override
  String get propertyProfileTitle => 'Perfil de Propriedade';

  @override
  String get karmaTypeLabel => 'TIPO DE CARMA';

  @override
  String get environmentLabel => 'AMBIENTE';

  @override
  String get styleLabel => 'ESTILO';

  @override
  String get sizeLabel => 'TAMANHO';

  @override
  String get locationLabel => 'LOCALIZAÇÃO';

  @override
  String get actionNext12mLabel => 'AÇÃO NOS PRÓXIMOS 12 MESES';

  @override
  String get propertyWord => 'Propriedade';

  @override
  String get propertyYogasTitle => 'Yogas de Propriedade';

  @override
  String get drainsLabel => 'DRENOS';

  @override
  String get boostersLabel => 'IMPULSIONADORES';

  @override
  String get propertyTrendTitle => 'Tendência de Propriedade';

  @override
  String get buyingWindowsTitle => 'Janelas de Compra';

  @override
  String get constructionWindowsTitle => 'Janelas de Construção';

  @override
  String get maternalInherPctLabel => '% HERANÇA MATERNA';

  @override
  String get paternalInherPctLabel => '% HERANÇA PATERNA';

  @override
  String get multiHomePctLabel => '% MÚLTIPLOS IMÓVEIS';

  @override
  String get investmentPctLabel => '% INVESTIMENTO';

  @override
  String get vehicleProfileTitle => 'Perfil de Veículos';

  @override
  String get countLabel => 'QUANTIDADE';

  @override
  String get firstAgeLabel => 'PRIMEIRA IDADE';

  @override
  String get categoryLabel => 'CATEGORIA';

  @override
  String get luxuryLabel => 'LUXO';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'Total na vida: $count · Realização: $pct%';
  }

  @override
  String get pressureWord => 'PRESSÃO';

  @override
  String get protectionWord => 'PROTEÇÃO';

  @override
  String get astrologicalWord => 'Astrológico';

  @override
  String get keyRisksHeader1 => 'Principais';

  @override
  String get keyRisksHeader2 => 'Riscos';

  @override
  String get reportCopiedShort => 'Relatório copiado!';

  @override
  String get keyScoresLabel => 'PRINCIPAIS PONTUAÇÕES';

  @override
  String allScoresCountLabel(int count) {
    return 'Todas as Pontuações ($count)';
  }

  @override
  String get windowsWord => 'Janelas';

  @override
  String get genericFailedMsg => 'Falhou';

  @override
  String get unknownWord => 'Desconhecido';

  @override
  String selectKarmaChartsLabel(int max) {
    return 'Selecione de 2 a $max Mapas';
  }

  @override
  String selectChartsLabelCount(int max) {
    return 'Selecione $max Mapas';
  }

  @override
  String runningAnalysisLabel(String label) {
    return 'Executando análise de $label...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'Escolha de 2 a $max mapas para analisar ligações cármicas';
  }

  @override
  String get pickMaleFemaleHint => 'Escolha um mapa Masculino e um Feminino';

  @override
  String get personOneLabel => 'Pessoa 1';

  @override
  String get personTwoLabel => 'Pessoa 2';

  @override
  String get analysisFailedMsg => 'Falha na análise';

  @override
  String analyzeChartsCountLabel(int count) {
    return 'Analisar $count Mapas';
  }

  @override
  String get contextGeneralLabel => 'Geral';

  @override
  String get contextLoveLabel => 'Amor';

  @override
  String get contextBusinessLabel => 'Negócios';

  @override
  String get contextFamilyLabel => 'Família';

  @override
  String get contextTeamLabel => 'Equipe';

  @override
  String get contextFriendshipLabel => 'Amizade';

  @override
  String get relationshipIntelTitle => 'Inteligência de Relacionamento';

  @override
  String analyzingChartsCountLabel(int count) {
    return 'Analisando $count mapas...';
  }

  @override
  String get relationshipContextLabel => 'Contexto do Relacionamento';

  @override
  String get kundliMilanReportTitle => 'Relatório de Kundli Milan';

  @override
  String get runningMilanAnalysisLabel => 'Executando análise de Milan...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '$count/2 selecionados';
  }

  @override
  String get runMilanAnalysisBtn => 'Executar Análise de Milan';

  @override
  String get noChartsCreateFirst => 'Nenhum mapa. Crie um mapa natal primeiro.';

  @override
  String get selectBirthChartAnalyze => 'Selecione um mapa natal para analisar';

  @override
  String get doshAnalysis => 'Análise de Dosha';

  @override
  String doshActiveCount(Object active, Object total) {
    return '$active ativos / $total verificados';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '$active ativos / $total yogas verificados';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'YOGAS ATIVOS ($count)';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'Ocultar yogas inativos ($count)';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'Mostrar yogas inativos ($count)';
  }

  @override
  String get loadFailed => 'Falhou';

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
    return 'Senhor Natal: $lord • Saldo: $balance anos';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'Lagna: $lagna • Saldo: $balance anos';
  }

  @override
  String dashaYearsValue(Object years) {
    return '$years anos';
  }

  @override
  String get dashaCurrentPeriod => 'Período de Dasha Atual';

  @override
  String dashaAsOf(Object date) {
    return 'Em: $date';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'Yogas Ativos no Período Atual ($count)';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'Doshas Ativos no Período Atual ($count)';
  }

  @override
  String get dashaNoYogasTriggered => 'Nenhum yoga acionado';

  @override
  String get dashaNoDoshasTriggered => 'Nenhum dosha acionado';

  @override
  String get divD1Name => 'Rasi (D-1)';

  @override
  String get divD1Desc => 'Existência física, todos os assuntos';

  @override
  String get divD2Name => 'Hora (D-2)';

  @override
  String get divD2Desc => 'Riqueza, dinheiro';

  @override
  String get divD3Name => 'Drekkana (D-3)';

  @override
  String get divD3Desc => 'Irmãos, coragem';

  @override
  String get divD4Name => 'Chaturthamsa (D-4)';

  @override
  String get divD4Desc => 'Propriedade, residência, fortuna';

  @override
  String get divD5Name => 'Panchamsa (D-5)';

  @override
  String get divD5Desc => 'Fama, autoridade, poder';

  @override
  String get divD6Name => 'Shashthamsa (D-6)';

  @override
  String get divD6Desc => 'Problemas de saúde';

  @override
  String get divD7Name => 'Saptamsa (D-7)';

  @override
  String get divD7Desc => 'Filhos, netos';

  @override
  String get divD8Name => 'Ashtamsa (D-8)';

  @override
  String get divD8Desc => 'Problemas repentinos, litígios';

  @override
  String get divD9Name => 'Navamsha (D-9)';

  @override
  String get divD9Desc => 'Casamento, cônjuge, dharma';

  @override
  String get divD10Name => 'Dasamsha (D-10)';

  @override
  String get divD10Desc => 'Carreira, profissão';

  @override
  String get divD11Name => 'Rudramsha (D-11)';

  @override
  String get divD11Desc => 'Morte, destruição';

  @override
  String get divD12Name => 'Dwadasamsha (D-12)';

  @override
  String get divD12Desc => 'Pais, parentes consanguíneos';

  @override
  String get divD16Name => 'Shodasamsha (D-16)';

  @override
  String get divD16Desc => 'Veículos, confortos, prazeres';

  @override
  String get divD20Name => 'Vimsamsha (D-20)';

  @override
  String get divD20Desc => 'Assuntos espirituais, religiosos';

  @override
  String get divD24Name => 'Chaturvimsamsha (D-24)';

  @override
  String get divD24Desc => 'Aprendizado, conhecimento, educação';

  @override
  String get divD27Name => 'Nakshatramsha (D-27)';

  @override
  String get divD27Desc => 'Forças, fraquezas, natureza';

  @override
  String get divD30Name => 'Trimsamsha (D-30)';

  @override
  String get divD30Desc => 'Males, subconsciente, punição';

  @override
  String get divD40Name => 'Khavedamsha (D-40)';

  @override
  String get divD40Desc => 'Auspicioso/inauspicioso (materno)';

  @override
  String get divD45Name => 'Akshavedamsha (D-45)';

  @override
  String get divD45Desc => 'Todos os assuntos (paterno)';

  @override
  String get divD60Name => 'Shashtyamsha (D-60)';

  @override
  String get divD60Desc => 'Carma de vida passada — MAIS IMPORTANTE';

  @override
  String get lifeAreaCareer => 'Carreira';

  @override
  String get lifeAreaWealth => 'Riqueza';

  @override
  String get lifeAreaMarriage => 'Casamento';

  @override
  String get lifeAreaHealth => 'Saúde';

  @override
  String get lifeAreaSpirituality => 'Espiritualidade';

  @override
  String lifeAreaGrade(Object grade) {
    return 'Nota: $grade';
  }

  @override
  String get lifeAreaFactorsLabel => 'Fatores:';

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
  String get chakraOverallHealth => 'Saúde Geral';

  @override
  String get careerWord => 'Carreira';

  @override
  String get failedToLoad => 'Falha ao carregar';

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
    return 'Grau: $degree°  •  Nakshatra: $nakshatra ($pada)';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'Senhor do Nakshatra: $lord  •  Dignidade: $dignity';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return 'Mapa $base — $sign';
  }

  @override
  String kundliBaseChart(Object base) {
    return 'Mapa $base';
  }

  @override
  String get careerSummary => 'Resumo de Carreira';

  @override
  String get phase => 'Fase';

  @override
  String get confidenceLabel => 'Confiança';

  @override
  String get careerScores => 'Pontuações de Carreira';

  @override
  String get stabilityLabel => 'Estabilidade';

  @override
  String get growthLabel => 'Crescimento';

  @override
  String get gradeExcellent => 'Excelente';

  @override
  String get gradeGood => 'Bom';

  @override
  String get gradeAverage => 'Médio';

  @override
  String get gradeBelowAvg => 'Abaixo da Média';

  @override
  String get gradeWeak => 'Fraco';

  @override
  String get careerTypeDomain => 'Carreira e Domínio';

  @override
  String get careerTimeline => 'Linha do Tempo da Carreira';

  @override
  String dashaLabel(Object dasha) {
    return 'Dasha: $dasha';
  }

  @override
  String get improvementSuggestions => 'Sugestões de Melhoria';

  @override
  String get chartDetails => 'Detalhes do Mapa';

  @override
  String get keyHousesCareer => 'Casas Principais (Carreira)';

  @override
  String get keyCareerPlanets => 'Planetas Principais de Carreira';

  @override
  String get empty => 'Vazio';

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
  String get charGroupCorePersonality => 'Personalidade Central';

  @override
  String get charGroupTrustHonesty => 'Confiança e Honestidade';

  @override
  String get charGroupLoyaltyCommitment => 'Lealdade e Compromisso';

  @override
  String get charGroupStrategicPrivacy => 'Estratégia e Privacidade';

  @override
  String get charGroupFinancial => 'Financeiro';

  @override
  String get charGroupAngerConflict => 'Raiva e Conflito';

  @override
  String get charGroupMoralDharmic => 'Moral e Dhármico';

  @override
  String get charGroupIntellectCommunication => 'Intelecto e Comunicação';

  @override
  String get charGroupEmotionalProfile => 'Perfil Emocional';

  @override
  String get charGroupMentalHealth => 'Saúde Mental';

  @override
  String get charGroupRomantic => 'Romântico';

  @override
  String get charGroupMarriageFamily => 'Casamento e Família';

  @override
  String get charGroupOverallLife => 'Vida Geral';

  @override
  String get grahaDrishti => 'Graha Drishti (Aspectos Planetários)';

  @override
  String get grahaDrishtiSubtitle => 'Quem aspecta quem (%)';

  @override
  String get lagnaAspectsReceived => 'Aspectos Recebidos pela Lagna';

  @override
  String get rashiDrishti => 'Rashi Drishti (Aspectos de Signo)';

  @override
  String get shadbalaRupas => 'rupas';

  @override
  String get bhavaHouse1 => 'Eu / Corpo';

  @override
  String get bhavaHouse2 => 'Riqueza / Família';

  @override
  String get bhavaHouse3 => 'Irmãos / Coragem';

  @override
  String get bhavaHouse4 => 'Lar / Mãe';

  @override
  String get bhavaHouse5 => 'Filhos / Intelecto';

  @override
  String get bhavaHouse6 => 'Inimigos / Saúde';

  @override
  String get bhavaHouse7 => 'Casamento / Parceiro';

  @override
  String get bhavaHouse8 => 'Longevidade';

  @override
  String get bhavaHouse9 => 'Fortuna / Guru';

  @override
  String get bhavaHouse10 => 'Carreira / Pai';

  @override
  String get bhavaHouse11 => 'Ganhos / Amigos';

  @override
  String get bhavaHouse12 => 'Perda / Moksha';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '$sign • Senhor: $lord';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: $value';
  }

  @override
  String get sarvaAshtakavarga => 'Sarva Ashtakavarga (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'Total: $total rekhas (signo médio = $avg)';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '$planet — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'Total: $total rekhas • No signo natal: $score';
  }

  @override
  String get today => 'Hoje';

  @override
  String gocharTransitScores(Object date) {
    return 'Gochar (Pontuações de Trânsito) — $date';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'Lua Natal: $sign';
  }

  @override
  String get gocharBest => 'MELHOR';

  @override
  String get gocharWorst => 'PIOR';

  @override
  String copiedOpening(Object ai) {
    return 'Copiado! Abrindo $ai...';
  }

  @override
  String get openLink => 'ABRIR ↗';

  @override
  String get discussReportWithAI => 'DISCUTIR ESTE RELATÓRIO COM A IA';

  @override
  String get reliabilityHigh => 'Alta confiabilidade';

  @override
  String get reliabilityModerate => 'Confiabilidade moderada';

  @override
  String get reliabilityLow => 'Baixa — apenas orientativo';

  @override
  String get reliabilityGoodEdu => 'Boa confiabilidade · Verificado com D-24';

  @override
  String get relationshipWord => 'Relacionamento';

  @override
  String get intelligenceWord => 'Inteligência';

  @override
  String get relationshipIntelligence => 'INTELIGÊNCIA DE RELACIONAMENTO';

  @override
  String get typeLabel => 'TIPO';

  @override
  String get trustLabel => 'CONFIANÇA';

  @override
  String get dhokaRisk => 'RISCO DE TRAIÇÃO';

  @override
  String get powerLabel => 'Poder';

  @override
  String get integrity => 'Integridade';

  @override
  String get warmth => 'Calor Humano';

  @override
  String get trustWord => 'Confiança';

  @override
  String get assertLabel => 'Assertividade';

  @override
  String get character => 'Caráter';

  @override
  String get love => 'Amor';

  @override
  String get businessWord => 'Negócios';

  @override
  String get karmic => 'Cármico';

  @override
  String get enmityRisk => 'Risco de Inimizade';

  @override
  String get hdrChartProfiles => 'Perfis dos Mapas';

  @override
  String get hdrPairwiseAnalysis => 'Análise entre Pares';

  @override
  String get hdrCriticalPatterns => 'Padrões Críticos';

  @override
  String get hdrGroupRecommendations => 'Recomendações para o Grupo';

  @override
  String get sharedPractices => 'PRÁTICAS COMPARTILHADAS';

  @override
  String get hdrIndividualGuidance => 'Orientação Individual';

  @override
  String get growthAreas => 'ÁREAS DE CRESCIMENTO';

  @override
  String get hdrCoreTheme => 'Tema Central';

  @override
  String get growthOriented => 'ORIENTADO AO CRESCIMENTO';

  @override
  String get groupTheme => 'TEMA DO GRUPO';

  @override
  String get compatibility => 'COMPATIBILIDADE';

  @override
  String get unifiedScoreLabel => 'PONTUAÇÃO UNIFICADA';

  @override
  String get ashtakoot => 'ASHTAKOOT';

  @override
  String get probability => 'PROBABILIDADE';

  @override
  String get hdrAshtakootSummary => 'Resumo do Ashtakoot';

  @override
  String get hdrGunBreakdown => 'Detalhamento dos 8 Gunas';

  @override
  String get hdrMangalDosh => 'Mangal Dosh';

  @override
  String get hdrD9CrossChart => 'Cruzamento de Mapas D-9';

  @override
  String get d9Compatibility => 'COMPATIBILIDADE D-9';

  @override
  String get hdrDomainCompatibility => 'Compatibilidade por Domínio';

  @override
  String get emotional => 'Emocional';

  @override
  String get intellectual => 'Intelectual';

  @override
  String get spiritual => 'Espiritual';

  @override
  String get financial => 'Financeiro';

  @override
  String get domestic => 'Doméstico';

  @override
  String get communicationWord => 'Comunicação';

  @override
  String get sharedDharma => 'Dharma Compartilhado';

  @override
  String get familyCreation => 'Criação de Família';

  @override
  String get hdrMarriageTiming => 'Timing do Casamento';

  @override
  String get jointMarriageWindows => 'Janelas Conjuntas de Casamento';

  @override
  String get engagementWindows => 'Janelas de Noivado';

  @override
  String get recommendedLabel => 'Recomendado';

  @override
  String get hdrKeyRisks => 'Principais Riscos';

  @override
  String get hdrFinalVerdict => 'Veredito Final';

  @override
  String get marriageVerdict => 'VEREDITO DE CASAMENTO';

  @override
  String get educationWord => 'Educação';

  @override
  String get learningSuffix => 'e Aprendizado';

  @override
  String get coreEducationScores => 'PONTUAÇÕES PRINCIPAIS DE EDUCAÇÃO';

  @override
  String get academicSuccess => 'SUCESSO ACADÊMICO';

  @override
  String get learningCapacity => 'CAPACIDADE DE APRENDIZADO';

  @override
  String get memory => 'MEMÓRIA';

  @override
  String get intelligence => 'INTELIGÊNCIA';

  @override
  String get research => 'PESQUISA';

  @override
  String get hdrIntellectualProfile => 'Perfil Intelectual';

  @override
  String get learningSignature => 'ASSINATURA DE APRENDIZADO';

  @override
  String get hdrSubjectKaraka => 'Karaka da Matéria';

  @override
  String get hdrHouseFoundations => 'Fundações das Casas';

  @override
  String get hdrMercuryJupiter => 'Mercúrio e Júpiter';

  @override
  String get hdrEducationYogas => 'Yogas Educacionais';

  @override
  String get hdrDivisionalValidation => 'Validação Divisional';

  @override
  String get standing => 'POSIÇÃO';

  @override
  String get hdrSubjectRanking => 'Classificação de Matérias';

  @override
  String get hdrDegreeLikelihood => 'Probabilidade de Grau';

  @override
  String get hdrStudyPeriods => 'Períodos de Estudo';

  @override
  String get earlySchooling => 'Educação Inicial';

  @override
  String get higherEducation => 'Ensino Superior';

  @override
  String get postgradResearch => 'Pós-Graduação · Pesquisa';

  @override
  String get hdrLearningPreferences => 'Preferências de Aprendizado';

  @override
  String get hdrChallengesGifts => 'Desafios e Dons';

  @override
  String get challenges => 'DESAFIOS';

  @override
  String get cognitiveGifts => 'DONS COGNITIVOS';

  @override
  String get naturalAbilities => 'HABILIDADES NATURAIS';

  @override
  String get hdrSaraswatiRemedies => 'Remédios de Saraswati';

  @override
  String get studentVerdict => 'VEREDITO DO ESTUDANTE';

  @override
  String get educationCareerLinkage => 'LIGAÇÃO EDUCAÇÃO → CARREIRA';

  @override
  String get startupSuffix => 'e Startups';

  @override
  String get coreBusinessScores => 'PONTUAÇÕES PRINCIPAIS DE NEGÓCIOS';

  @override
  String get overallBusiness => 'NEGÓCIO GERAL';

  @override
  String get ventureSuccess => 'SUCESSO DO EMPREENDIMENTO';

  @override
  String get eleventhHouse => 'CASA 11';

  @override
  String get gains => 'GANHOS';

  @override
  String get investor => 'INVESTIDOR';

  @override
  String get hdrFounderArchetype => 'Arquétipo de Fundador';

  @override
  String get hdrTenthEleventhHouses => 'Casas 10 e 11';

  @override
  String get hdrBusinessYogas => 'Yogas de Negócios';

  @override
  String get hdrRecommendedDomains => 'Domínios Recomendados';

  @override
  String get hdrBusinessStyle => 'Estilo de Negócio';

  @override
  String get hdrFounderSkills => 'Habilidades de Fundador';

  @override
  String get hdrFundingProfile => 'Perfil de Financiamento';

  @override
  String get recommendedPath => 'CAMINHO RECOMENDADO';

  @override
  String get investorAttract => 'ATRAÇÃO DE INVESTIDORES';

  @override
  String get familyBacking => 'APOIO FAMILIAR';

  @override
  String get hybridViability => 'VIABILIDADE HÍBRIDA';

  @override
  String get launchWindow => 'Janela de Lançamento';

  @override
  String get scaleWindow => 'Janela de Expansão';

  @override
  String get hdrBusinessRisks => 'Riscos do Negócio';

  @override
  String get recoveryCapacity => 'CAPACIDADE DE RECUPERAÇÃO';

  @override
  String get hdrRemediesSolutions => 'Remédios e Soluções';

  @override
  String get aiConnectionLost => 'Conexão perdida. Tente novamente.';

  @override
  String get aiSomethingWrong => 'Algo deu errado';

  @override
  String get aiNoResponse => 'Sem resposta';

  @override
  String get aiConnectionError => 'Erro de conexão. Tente novamente.';

  @override
  String get aiAutoDetect => 'Detecção automática';

  @override
  String aiAutoArrow(String lang) {
    return 'Automático → $lang';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'Idioma: $lang';
  }

  @override
  String get aiNoBirthCharts => 'Nenhum mapa natal encontrado';

  @override
  String get aiCreateChartFirst =>
      'Crie um mapa natal primeiro para conversar com a IA';

  @override
  String get aiSelectChartBegin =>
      'Selecione um mapa natal para começar a análise';

  @override
  String aiAnalyzingName(String name) {
    return 'Analisando: $name';
  }

  @override
  String get aiChange => 'Trocar';

  @override
  String get aiAnalyzingChart => 'Analisando seu mapa...';

  @override
  String get aiAskStarsHint => 'Pergunte qualquer coisa às estrelas...';

  @override
  String get aiSuggestedFollowups => 'Perguntas sugeridas';

  @override
  String get aiThinking => 'Pensando...';

  @override
  String get aiThanks => 'Obrigado!';

  @override
  String get aiFeedbackNoted => 'Feedback registrado';

  @override
  String get svcAll => 'Todos';

  @override
  String get svcNoServices => 'Nenhum serviço disponível';

  @override
  String get svcFree => 'GRÁTIS';

  @override
  String get astroFailedStartCall => 'Falha ao iniciar a chamada';

  @override
  String get astroFailedStartChat => 'Falha ao iniciar o chat';

  @override
  String astroErrorDetail(String error) {
    return 'Erro: $error';
  }

  @override
  String get astroExperience => 'Experiência';

  @override
  String get astroSessions => 'Sessões';

  @override
  String get astroMinutes => 'Minutos';

  @override
  String get astroAbout => 'Sobre';

  @override
  String get astroLanguages => 'Idiomas';

  @override
  String get astroRateCard => 'Tabela de Preços';

  @override
  String get astroVoice => 'Voz';

  @override
  String astroReviews(int count) {
    return 'Avaliações ($count)';
  }

  @override
  String get astroNoReviews => 'Ainda sem avaliações';

  @override
  String get astroAnonymous => 'Anônimo';

  @override
  String get forgotPasswordSubtitle =>
      'Digite seu e-mail e enviaremos\num link para redefinir sua senha.';

  @override
  String get emailHint => 'seu@email.com';

  @override
  String get resendLink => 'Reenviar Link';

  @override
  String get appName => 'Nakshatralogy';

  @override
  String get cosmicJourneyAwaits => 'Sua Jornada Cósmica Está à Espera';

  @override
  String get home => 'Início';

  @override
  String get astrologers => 'Astrólogos';

  @override
  String get services => 'Serviços';

  @override
  String get wallet => 'Carteira';

  @override
  String get profile => 'Perfil';

  @override
  String get live => 'Ao Vivo';

  @override
  String get kundli => 'Kundli';

  @override
  String get chat => 'Chat';

  @override
  String get call => 'Ligação';

  @override
  String get video => 'Vídeo';

  @override
  String get signIn => 'Entrar';

  @override
  String get createAccount => 'Criar Conta';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get confirmPassword => 'Confirmar Senha';

  @override
  String get fullName => 'Nome Completo';

  @override
  String get phone => 'Telefone';

  @override
  String get forgotPassword => 'Esqueceu a Senha?';

  @override
  String get sendResetLink => 'Enviar Link de Redefinição';

  @override
  String get backToSignIn => 'Voltar para Entrar';

  @override
  String get dontHaveAccount => 'Não tem uma conta?';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta?';

  @override
  String get continueGoogle => 'Continuar com o Google';

  @override
  String get required => 'Obrigatório';

  @override
  String get minSixChars => 'Mínimo de 6 caracteres';

  @override
  String get passwordsMismatch => 'As senhas não coincidem';

  @override
  String get validEmailRequired => 'E-mail válido é obrigatório';

  @override
  String get loginFailed => 'Falha no login';

  @override
  String get signupFailed => 'Falha no cadastro';

  @override
  String get welcomeBack => 'Bem-vindo de volta';

  @override
  String get todaysHoroscope => 'HORÓSCOPO DE HOJE';

  @override
  String get todaysRashi => 'Rashi de Hoje';

  @override
  String get tapDetails => 'Toque para detalhes';

  @override
  String get allServices => 'Todos os Serviços';

  @override
  String get seeAll => 'VER TODOS';

  @override
  String get topAstrologers => 'Melhores Astrólogos';

  @override
  String get onlineExperts => 'Especialistas online prontos para consulta';

  @override
  String get searchAstrologers => 'Buscar astrólogos...';

  @override
  String get noAstrologersFound => 'Nenhum astrólogo encontrado';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get busy => 'Ocupado';

  @override
  String get perMin => '/min';

  @override
  String get noCharts => 'Ainda não há mapas natais';

  @override
  String get createFirst => 'Crie seu primeiro Janam Kundli';

  @override
  String get createChart => 'Criar Mapa';

  @override
  String get newBirthChart => 'Novo Mapa Natal';

  @override
  String get clientName => 'Nome do Cliente';

  @override
  String get gender => 'Gênero';

  @override
  String get male => 'Masculino';

  @override
  String get female => 'Feminino';

  @override
  String get other => 'Outro';

  @override
  String get dateOfBirth => 'Data de Nascimento';

  @override
  String get timeOfBirth => 'Hora de Nascimento';

  @override
  String get birthPlace => 'Local de Nascimento';

  @override
  String get birthPlaceHint => 'Digite o nome da cidade para buscar...';

  @override
  String get generateKundli => 'Gerar Kundli';

  @override
  String get birthChartCreated => 'Mapa natal criado!';

  @override
  String get deleteChart => 'Excluir Mapa?';

  @override
  String get cannotUndo => 'Isso não pode ser desfeito.';

  @override
  String get primary => 'PRINCIPAL';

  @override
  String get viewKundli => 'Ver Kundli';

  @override
  String get completeBirthChart => 'Mapa Natal Completo';

  @override
  String get birthDetails => 'Detalhes de Nascimento';

  @override
  String get name => 'Nome';

  @override
  String get dob => 'Data Nasc.';

  @override
  String get tob => 'Hora Nasc.';

  @override
  String get place => 'Local';

  @override
  String get summary => 'Resumo';

  @override
  String get planets => 'Planetas';

  @override
  String get divisions => 'Divisões';

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
  String get lifeAreas => 'Áreas da Vida';

  @override
  String get bhava => 'Bhava';

  @override
  String get chakras => 'Chakras';

  @override
  String get dashaActive => 'Dasha Ativa';

  @override
  String get lagna => 'Lagna';

  @override
  String get moon => 'Lua';

  @override
  String get sun => 'Sol';

  @override
  String get premiumSection => 'Seção Premium';

  @override
  String get unlockReading =>
      'Desbloqueie esta leitura para ver a análise detalhada.';

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
  String get addBalance => 'Adicionar Saldo';

  @override
  String get amount => 'Valor';

  @override
  String get walletBalance => 'Saldo da Carteira';

  @override
  String get recharge => 'Recarregar';

  @override
  String get bonus => 'Bônus';

  @override
  String get serviceLabel => 'Serviço';

  @override
  String get refund => 'Reembolso';

  @override
  String get noTransactions => 'Nenhuma transação';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get savedAstrologers => 'Astrólogos Salvos';

  @override
  String get noSavedAstrologers => 'Ainda não há astrólogos salvos';

  @override
  String get myOrders => 'Meus Pedidos';

  @override
  String get communicationHistory => 'Histórico de Comunicação';

  @override
  String get chatHistory => 'Histórico de Chat';

  @override
  String get callHistory => 'Histórico de Chamadas';

  @override
  String get logout => 'Sair';

  @override
  String get chatMessages => 'Mensagens do Chat';

  @override
  String get typeMessage => 'Digite uma mensagem...';

  @override
  String get sessionEnded => 'Sessão Encerrada';

  @override
  String get endChat => 'Encerrar Chat?';

  @override
  String get endChatConfirm =>
      'Tem certeza de que deseja encerrar esta sessão de chat?';

  @override
  String get sendPhoto => 'Enviar Foto';

  @override
  String get sendPDF => 'Enviar PDF';

  @override
  String get upload => 'Enviar';

  @override
  String get fileNotFound => 'Arquivo não encontrado';

  @override
  String get voiceCall => 'Chamada de Voz';

  @override
  String get videoCall => 'Chamada de Vídeo';

  @override
  String get ringing => 'Chamando...';

  @override
  String get connected => 'CONECTADO';

  @override
  String get endCall => 'Encerrar Chamada';

  @override
  String get mute => 'Silenciar';

  @override
  String get unmute => 'Ativar Som';

  @override
  String get speaker => 'Alto-falante';

  @override
  String get camera => 'Câmera';

  @override
  String get flip => 'Inverter';

  @override
  String get liveStreams => 'Transmissões ao Vivo';

  @override
  String get noLiveStreams => 'Nenhuma transmissão ao vivo no momento';

  @override
  String get astrologerUnavailable =>
      'Astrólogo indisponível. Encerrando transmissão.';

  @override
  String get streamEnded => 'Transmissão encerrada';

  @override
  String get superChat => 'Super Chat';

  @override
  String get sendGift => 'Enviar um Presente';

  @override
  String get goBack => 'Voltar';

  @override
  String get appPermissions => 'Permissões do Aplicativo';

  @override
  String get grantPermissions => 'Conceder Permissões';

  @override
  String get skipForNow => 'Pular por agora';

  @override
  String get microphone => 'Microfone';

  @override
  String get notifications => 'Notificações';

  @override
  String get storage => 'Armazenamento';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get retry => 'Tentar Novamente';

  @override
  String get send => 'Enviar';

  @override
  String get refresh => 'Atualizar';

  @override
  String get loading => 'Carregando...';

  @override
  String get noData => 'Nenhum dado disponível';

  @override
  String get error => 'Erro';

  @override
  String get success => 'Sucesso';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglês';

  @override
  String get myDetails => 'Meus Dados';

  @override
  String get myKundlis => 'Meus Kundlis';

  @override
  String get walletRecharge => 'Carteira e Recarga';

  @override
  String get consultationHistory => 'Histórico de Consultas';

  @override
  String get helpSupport => 'Ajuda e Suporte';

  @override
  String get biometricLogin => 'Login Biométrico';

  @override
  String get pastVoiceConsultations => 'Consultas de voz anteriores';

  @override
  String get pastTextConversations => 'Conversas de texto anteriores';

  @override
  String get comingSoon => 'Em breve';

  @override
  String get totalCredit => 'Crédito Total';

  @override
  String get totalDebit => 'Débito Total';

  @override
  String get statement => 'Extrato';

  @override
  String get allTypes => 'Todos os tipos';

  @override
  String get prev => 'Anterior';

  @override
  String get next => 'Próximo';

  @override
  String get allInsights => 'Todos os Insights';

  @override
  String get yourCompleteReading => 'SUA LEITURA COMPLETA';

  @override
  String get expertEngines => 'motores especialistas';

  @override
  String get eachInsightConsultation => 'Cada insight é uma consulta completa';

  @override
  String get engines => 'MOTORES';

  @override
  String get dataPoints => 'PONTOS DE DADOS';

  @override
  String get singleChart => 'ÚNICO';

  @override
  String get careerPurpose => 'CARREIRA E PROPÓSITO';

  @override
  String get wealthAssets => 'RIQUEZA E BENS';

  @override
  String get loveRelationships => 'AMOR E RELACIONAMENTOS';

  @override
  String get healthWellness => 'SAÚDE E BEM-ESTAR';

  @override
  String get soulKarma => 'ALMA E CARMA';

  @override
  String get specialistReports => 'Relatórios Especializados';

  @override
  String get searchByNameSpeciality => 'Buscar por nome, especialidade...';

  @override
  String get sortedByRating => 'Ordenado por avaliação';

  @override
  String get initiatingChat => 'Iniciando chat...';

  @override
  String get startingCall => 'Iniciando chamada...';

  @override
  String get yrs => 'anos';

  @override
  String get chatWithAISpecialist => 'Converse com o Especialista IA';

  @override
  String get tapToStart => 'Toque para começar';

  @override
  String get astrologer => 'Astrólogo';

  @override
  String get reports => 'Relatórios';

  @override
  String get milan => 'Milan';

  @override
  String get forecast => 'Previsão';

  @override
  String get rashi => 'Rashi';

  @override
  String get jupiterFavorsBold => 'Júpiter favorece movimentos ousados';

  @override
  String get careerIlluminated =>
      'Seu setor de carreira está iluminado — confie em seus instintos.';

  @override
  String get todaysForecast => 'Previsão de Hoje';

  @override
  String get engCareer => 'Carreira e Emprego';

  @override
  String get engBusiness => 'Negócios e Startups';

  @override
  String get engEducation => 'Educação e Aprendizado';

  @override
  String get engLifePath => 'Caminho de Vida e Sorte';

  @override
  String get engWealth => 'Riqueza e Finanças';

  @override
  String get engDebt => 'Dívidas e Recuperação';

  @override
  String get engProperty => 'Propriedades e Bens';

  @override
  String get engLegal => 'Questões Legais e Disputas';

  @override
  String get engLove => 'Amor e Romance';

  @override
  String get engMarriage => 'Casamento e Família';

  @override
  String get engKundliMilan => 'Kundli Milan';

  @override
  String get engRelationship => 'Inteligência de Relacionamento';

  @override
  String get engLoveCompat => 'Compatibilidade Amorosa';

  @override
  String get engChildProb => 'Probabilidade de Filhos';

  @override
  String get engHealth => 'Saúde e Bem-Estar';

  @override
  String get engMental => 'Mental e Estresse';

  @override
  String get engCharacter => 'Análise de Caráter';

  @override
  String get engPastLife => 'Vidas Passadas e Carma';

  @override
  String get engKarmaLink => 'Ligação Cármica';

  @override
  String get noChatSessions => 'Ainda Não Há Sessões de Chat';

  @override
  String get chatAppearHere => 'Suas conversas com astrólogos aparecerão aqui.';

  @override
  String get noCallsYet => 'Ainda Não Há Chamadas';

  @override
  String get callAppearHere =>
      'Seu histórico de chamadas com astrólogos aparecerá aqui.';

  @override
  String get chatWith => 'Conversar com';

  @override
  String get msgs => 'mensagens';

  @override
  String get voiceCallLabel => 'Chamada de voz';

  @override
  String get videoCallLabel => 'Chamada de vídeo';

  @override
  String get pullToRefresh => 'Puxe para baixo para atualizar';

  @override
  String get sessionExpired => 'Sessão expirada';

  @override
  String get connectionFailed => 'Falha na conexão';

  @override
  String get callActive => 'Chamada ativa';

  @override
  String get lessThanOneMin => 'Menos de 1 minuto restante';

  @override
  String get noMessages => 'Nenhuma mensagem nesta sessão';

  @override
  String get gocharForAllSigns => 'Gochar de hoje para todos os 12 signos';

  @override
  String get selectChart => 'Selecione um mapa para analisar';

  @override
  String get selectTwoCharts => 'Selecione dois mapas';

  @override
  String get analyzing => 'Analisando...';

  @override
  String get browseAstrologers => 'Explorar Astrólogos';

  @override
  String get probableNumber => 'NÚMERO PROVÁVEL';

  @override
  String get genderTendency => 'TENDÊNCIA DE GÊNERO';

  @override
  String get son => 'FILHO';

  @override
  String get daughter => 'FILHA';

  @override
  String get occupants => 'OCUPANTES';

  @override
  String get beneficAspects => 'ASPECTOS BENÉFICOS';

  @override
  String get maleficAspects => 'ASPECTOS MALÉFICOS';

  @override
  String get nextFavorableWindow => 'PRÓXIMA JANELA FAVORÁVEL';

  @override
  String get totalDoshaPenalty => 'PENALIDADE TOTAL DE DOSHA';

  @override
  String get cancellationFactors => 'FATORES DE CANCELAMENTO';

  @override
  String get combinedFertility => 'INDICAÇÃO DE FERTILIDADE COMBINADA';

  @override
  String get planetPositions => 'POSIÇÕES PLANETÁRIAS';

  @override
  String get bestWindows => 'MELHORES JANELAS';

  @override
  String get worstWindows => 'PIORES JANELAS';

  @override
  String get scoreComponents => 'COMPONENTES DA PONTUAÇÃO';

  @override
  String get topOpportunities => 'PRINCIPAIS OPORTUNIDADES';

  @override
  String get topRisks => 'PRINCIPAIS RISCOS';

  @override
  String get remedies => 'REMÉDIOS';

  @override
  String get keyInsights => 'PRINCIPAIS INSIGHTS';

  @override
  String get overallVerdict => 'VEREDITO GERAL';

  @override
  String get venusContacts => 'CONTATOS CRUZADOS DE VÊNUS';

  @override
  String get contact => 'Contato';

  @override
  String get effect => 'Efeito';

  @override
  String get moonSignCompat => 'COMPATIBILIDADE DE SIGNO LUNAR';

  @override
  String get hisMoon => 'LUA DELE';

  @override
  String get herMoon => 'LUA DELA';

  @override
  String get nakshatraCompat => 'COMPATIBILIDADE DE NAKSHATRA';

  @override
  String get ketuContacts => 'CONTATOS DE KETU';

  @override
  String get rahuContacts => 'CONTATOS DE RAHU';

  @override
  String get pastLifeIndication => 'INDICAÇÃO DE VIDA PASSADA';

  @override
  String get totalChallengePenalty => 'PENALIDADE TOTAL DE DESAFIOS';

  @override
  String get manifestation => 'MANIFESTAÇÃO';

  @override
  String get cancellation => 'CANCELAMENTO';

  @override
  String get navigation => 'NAVEGAÇÃO';

  @override
  String get potentialStrengths => 'POTENCIAIS PONTOS FORTES';

  @override
  String get areasToNurture => 'ÁREAS A CULTIVAR';

  @override
  String get relationshipGuidance => 'ORIENTAÇÃO DE RELACIONAMENTO';

  @override
  String get detailedSummary => 'RESUMO DETALHADO';

  @override
  String get discussWithAI => 'DISCUTIR COM A IA';

  @override
  String get planet => 'Planeta';

  @override
  String get sign => 'Signo';

  @override
  String get house => 'Casa';

  @override
  String get strength => 'Força';

  @override
  String get copy => 'COPIAR';

  @override
  String get confidence => 'CONFIANÇA';

  @override
  String get d7Saptamsa => 'D7 SAPTAMSA';

  @override
  String get numberExplanation => 'EXPLICAÇÃO DO NÚMERO';

  @override
  String get genderExplanation => 'EXPLICAÇÃO DO GÊNERO';

  @override
  String get inFifth => 'Na Casa 5?';

  @override
  String get primaryArchetype => 'ARQUÉTIPO PRIMÁRIO';

  @override
  String get mitigation => 'MITIGAÇÃO';

  @override
  String get soulCareerAlign => 'Alinhamento Alma ↔ Carreira';

  @override
  String get favorablePeriods => 'Períodos Favoráveis';

  @override
  String get challengingPeriods => 'Períodos Desafiadores';

  @override
  String get keyHouses => 'Casas Principais';

  @override
  String get keyPlanets => 'Planetas Principais';

  @override
  String get characterOverview => 'Visão Geral de Caráter';

  @override
  String get noYogasActive => 'Nenhum yoga ativo atualmente neste mapa.';

  @override
  String get basedOnPlanetStrengths =>
      'Com base nas forças planetárias e posicionamentos nas casas';

  @override
  String get basedOnTransits => 'Com base nos trânsitos planetários atuais';

  @override
  String get currentPlanetPositions =>
      'Posições planetárias atuais com seu signo como Casa 1';

  @override
  String get favorablePeriodAdvice =>
      'Período favorável — concentre-se no crescimento profissional e nos relacionamentos.';

  @override
  String get noClassicalYogas =>
      'Sem yogas educacionais clássicos, o sucesso vem do esforço constante.';

  @override
  String get walletDeduction => 'O valor será deduzido da sua carteira';

  @override
  String get bhakootAxis => 'EIXO BHAKOOT';

  @override
  String get basis => 'BASE';

  @override
  String get selectChartsForMilan =>
      'Selecione 2 Mapas para a Análise de Milan';

  @override
  String get selectMultiCharts => 'Selecione de 2 a 5 Mapas';

  @override
  String get running => 'EM ANDAMENTO';

  @override
  String get past => 'passado';

  @override
  String get topActiveDoshas => 'PRINCIPAIS DOSHAS ATIVOS';

  @override
  String get allDoshas => 'TODOS OS DOSHAS';

  @override
  String get activeYogas => 'Yogas Ativos';

  @override
  String get activeDoshas => 'Doshas Ativos';

  @override
  String get yogaAnalysis => 'Análise de Yoga';

  @override
  String get factors => 'Fatores';

  @override
  String get dominantPlanet => 'Planeta Dominante';

  @override
  String get startSession => 'Iniciar Sessão';

  @override
  String get notesSaved => 'Notas salvas';

  @override
  String get unlocked => 'Desbloqueado! Aproveite sua leitura.';

  @override
  String get todaysGochar => 'Gochar de Hoje';

  @override
  String get todaysTransitChart => 'Mapa de Trânsito de Hoje';

  @override
  String get lifeAreaPredictions => 'Previsões por Área da Vida';

  @override
  String get strengths => 'Pontos Fortes';

  @override
  String get weaknesses => 'Pontos Fracos';

  @override
  String get ruledBy => 'Regido por';

  @override
  String get kundliMilan => 'Kundli Milan';

  @override
  String get startKundliMilan => 'Iniciar Kundli Milan';

  @override
  String get recommendations => 'Recomendações';

  @override
  String get cancellations => 'Cancelamentos';

  @override
  String get dashaSync => 'Sincronia de Dasha';

  @override
  String get transitMarriageWindows => 'Janelas de Casamento por Trânsito';

  @override
  String get overlappingWindows => 'Janelas de Casamento Sobrepostas';

  @override
  String get overallStrength => 'FORÇA GERAL';

  @override
  String get stability => 'ESTABILIDADE';

  @override
  String get growth => 'CRESCIMENTO';

  @override
  String get clarity => 'CLAREZA';

  @override
  String get recognition => 'RECONHECIMENTO';

  @override
  String get satisfaction => 'SATISFAÇÃO';

  @override
  String get verdict => 'VEREDITO';

  @override
  String get topRoles => 'PRINCIPAIS FUNÇÕES';

  @override
  String get areasForGrowth => 'ÁREAS DE CRESCIMENTO';

  @override
  String get bestIndustries => 'MELHORES SETORES';

  @override
  String get employment => 'Emprego';

  @override
  String get entrepreneurship => 'Empreendedorismo';

  @override
  String get freelance => 'Freelancer';

  @override
  String get portfolio => 'Portfólio';

  @override
  String get burnoutRisk => 'Risco de Esgotamento';

  @override
  String get careerStagnation => 'Estagnação na Carreira';

  @override
  String get workplaceConflict => 'Conflito no Trabalho';

  @override
  String get positioning => 'POSICIONAMENTO';

  @override
  String get skillDevelopment => 'DESENVOLVIMENTO DE HABILIDADES';

  @override
  String get network => 'REDE DE CONTATOS';

  @override
  String get visibility => 'VISIBILIDADE';

  @override
  String get lagnaLord => 'Senhor da Lagna';

  @override
  String get tenthLord => 'Senhor da Casa 10';

  @override
  String get lord => 'SENHOR';

  @override
  String get lordPlacedIn => 'SENHOR POSICIONADO EM';

  @override
  String get lordDignity => 'DIGNIDADE DO SENHOR';

  @override
  String get d9Dignity => 'DIGNIDADE NO D9';

  @override
  String get careerAnalysis => 'Análise de Carreira';

  @override
  String get launchWindows => 'Janelas de Lançamento';

  @override
  String get peakWindows => 'Janelas de Pico';

  @override
  String get promotionWindows => 'Janelas de Promoção';

  @override
  String get riskWindows => 'Janelas de Risco';

  @override
  String get timingWindows => 'Janelas de Timing';

  @override
  String get careerRisks => 'Riscos de Carreira';

  @override
  String get astrologicalRemedies => 'Remédios Astrológicos';

  @override
  String get practicalSolutions => 'Soluções Práticas';

  @override
  String get analysisConfidence => 'Confiança da Análise';

  @override
  String get careerArchetype => 'Arquétipo de Carreira';

  @override
  String get workStructure => 'Estrutura de Trabalho';

  @override
  String get teamLeadership => 'Liderança de Equipe';

  @override
  String get idealEnvironment => 'Ambiente Ideal';

  @override
  String get idealOrgSize => 'Tamanho Ideal da Organização';

  @override
  String get fitScore => 'PONTUAÇÃO DE COMPATIBILIDADE';

  @override
  String get recommended => 'RECOMENDADO';

  @override
  String get divisionalValidation => 'Validação Divisional';

  @override
  String get houseAnalysis => 'Análise de Casas';

  @override
  String get jaiminiKarakas => 'Karakas de Jaimini';

  @override
  String get copyFullReport => 'Copiar dados completos do relatório';

  @override
  String get reportCopied => 'Dados do relatório copiados!';

  @override
  String get biometricNotAvailable =>
      'Biometria não disponível neste dispositivo';

  @override
  String biometricErrorMsg(Object error) {
    return 'Erro de biometria: $error';
  }

  @override
  String get biometricVerifyReason =>
      'Verifique para ativar o login biométrico';

  @override
  String get dobFormatLabel => 'Data de Nascimento (DD/MM/YYYY)';

  @override
  String get tobFormatLabel => 'Hora de Nascimento (HH:MM)';

  @override
  String get phoneLabel => 'Telefone';

  @override
  String get activeBadge => 'ATIVO';

  @override
  String get chartCategoryLabel => 'Categoria';

  @override
  String get freePrimaryDescription =>
      'Principal Gratuito — usado para o horóscopo diário e serviços de mapa único gratuitos';

  @override
  String get searchChartsHint => 'Pesquisar por nome ou data de nascimento...';

  @override
  String unlockPriceLabel(Object price) {
    return 'Desbloquear por $price';
  }

  @override
  String unlockAiSpecialistIntl(Object price) {
    return 'Desbloqueie este especialista de IA por $price (uma vez), comprado com segurança através da loja de aplicativos.';
  }

  @override
  String unlockAiSpecialistWallet(Object price) {
    return 'Desbloqueie este especialista de IA por $price (uma vez). O valor será deduzido da sua carteira.';
  }

  @override
  String get specialistNotAvailablePurchase =>
      'Este especialista ainda não está disponível para compra.';

  @override
  String get couldNotCompletePurchase =>
      'Não foi possível concluir a compra. Tente novamente.';

  @override
  String get couldNotUnlockWalletBalance =>
      'Não foi possível desbloquear (verifique o saldo da carteira)';

  @override
  String get freeBadge => 'GRÁTIS';

  @override
  String activeSessionInProgress(Object kind) {
    return 'Você tem um(a) $kind ativo em andamento';
  }

  @override
  String get returnLabel => 'Voltar';

  @override
  String get enableNotificationsForAlerts =>
      'Ative as notificações para receber alertas de consultas e ofertas';

  @override
  String get enableLabel => 'Ativar';

  @override
  String get notificationsEnabled => 'Notificações ativadas';

  @override
  String get couldNotEnableNotifications =>
      'Não foi possível ativar — permita notificações no seu navegador';

  @override
  String get amountInrLabel => 'Valor (₹)';

  @override
  String get noteOptionalLabel => 'Nota (opcional)';

  @override
  String get txnDate => 'DATA';

  @override
  String get txnDescription => 'DESCRIÇÃO';

  @override
  String get txnType => 'TIPO';

  @override
  String get txnAmount => 'VALOR';

  @override
  String get txnBalance => 'SALDO';

  @override
  String get credit => 'Crédito';

  @override
  String get debit => 'Débito';

  @override
  String get razorpayStripeNote =>
      '💳 Em produção, isso redirecionará para Razorpay/Stripe.';

  @override
  String get downloadPdf => 'Baixar PDF';

  @override
  String get chatWithAiCta => 'Conversar com a IA';

  @override
  String get pdfServiceUnavailable =>
      'O serviço de PDF está temporariamente indisponível. Tente novamente mais tarde.';

  @override
  String get pleaseUnlockFirst => 'Por favor, desbloqueie isto primeiro.';

  @override
  String get couldNotGeneratePdf =>
      'Não foi possível gerar o PDF. Tente novamente.';

  @override
  String get statConsults => 'CONSULTAS';

  @override
  String get statCharts => 'MAPAS';

  @override
  String get statWallet => 'CARTEIRA';

  @override
  String get firstChartPrimaryInfo =>
      'Seu primeiro mapa é o seu Principal gratuito. Mapas extras desbloqueiam serviços individualmente.';

  @override
  String get tryDifferentFilter => 'Tente um filtro diferente';

  @override
  String get defaultChartName => 'Mapa';

  @override
  String get balAbbr => 'Saldo';

  @override
  String get aiTimePassTitle => 'Escolha seu tempo de chat';

  @override
  String get aiTimePassHint => 'Pago pela sua carteira. O tempo começa agora; comprar de novo soma ao tempo restante.';

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
    return 'Faltam $minutes min';
  }
}
