// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get pwPremiumTitle => 'プレミアムレポート';

  @override
  String get pwLockedSubtitle => 'このチャートの詳細分析をアンロック';

  @override
  String pwUnlockFull(Object name) {
    return '${name}を完全アンロック';
  }

  @override
  String pwUnlockPrice(Object price) {
    return 'アンロック・${price}';
  }

  @override
  String get pwOneTime => '一回限りのアンロック — このチャートは永久にご利用いただけます';

  @override
  String get pwWhatYouGet => '得られる内容';

  @override
  String get pwYourBalance => 'ウォレット残高';

  @override
  String get pwInsufficient => '残高不足';

  @override
  String get pwRechargeToUnlock => 'チャージしてアンロック';

  @override
  String get pwRechargeAmount => 'チャージ金額（₹）';

  @override
  String get pwAddMoney => '入金する';

  @override
  String get pwRechargeDone => 'ウォレットにチャージしました';

  @override
  String get pwRechargeFailed => 'チャージに失敗しました。もう一度お試しください。';

  @override
  String get pwUnlockFailed => 'アンロックできませんでした。もう一度お試しください。';

  @override
  String get pwUnlockedNow => 'アンロックしました！レポートを読み込み中…';

  @override
  String get pwProcessing => '処理中…';

  @override
  String get pwPrimaryNoDelete => 'メインのKundliは削除できません — 永久に無料でご利用いただけます。';

  @override
  String get pwPrimaryNoEdit => 'メインのKundliは編集できません。';

  @override
  String get pwLoadingAccess => 'アクセスを確認中…';

  @override
  String get pwMaybeLater => '後でする';

  @override
  String get updatePhoto => '写真を更新';

  @override
  String get takePhoto => 'カメラ';

  @override
  String get chooseFromGallery => 'ギャラリー';

  @override
  String get removePhoto => '写真を削除';

  @override
  String get photoUpdated => '写真を更新しました';

  @override
  String get photoUploadFailed => '写真をアップロードできませんでした。もう一度お試しください。';

  @override
  String get tapToChangePhoto => 'タップして写真を変更';

  @override
  String get klSubtitle => 'AIによるヴェーダ占星術 前世カルマ連関レポート';

  @override
  String get klTitle => '前世カルマ連関';

  @override
  String get klSnapshotHeader => 'カルマ連関スナップショット';

  @override
  String get klGaugePairwise => '平均ペア連関度';

  @override
  String get klGaugeCohesion => 'グループの結束度';

  @override
  String get klGaugeRahuKetu => 'ラーフ・ケートゥ共鳴';

  @override
  String get klGaugeAtmakaraka => '魂の共鳴';

  @override
  String get klGaugeD60 => 'D60共鳴';

  @override
  String get klChipSoulResonance => '強い魂のシグネチャー共鳴';

  @override
  String get klChipD60Resonance => '強いD60前世共鳴';

  @override
  String get klChipCohesiveGroup => '結束の強いグループ';

  @override
  String get klChipNoDebts => 'カルマの負債は検出されませんでした';

  @override
  String get klProfilesTitle => 'チャートプロフィール';

  @override
  String get klKetuAt => 'ケートゥの位置';

  @override
  String get klRahuAt => 'ラーフの位置';

  @override
  String get klFoundationTitle => 'チャート別カルマの基盤';

  @override
  String get klFoundationSubtitle => 'それぞれの魂の前世の熟達と現世の方向性';

  @override
  String get klKetuMastery => 'ケートゥの熟達';

  @override
  String get klRahuGrowth => 'ラーフの成長';

  @override
  String get klNinthHousePunya => '9ハウスのプニヤ（功徳）';

  @override
  String get klD60Depth => 'D60カルマの深度';

  @override
  String get klAtmakarakaAgenda => '魂の課題';

  @override
  String get klSaturnKarma => '土星のカルマ';

  @override
  String get klPairwiseTitle => 'ペア間のカルマ連関';

  @override
  String get klActiveFactors => '有効な連関要因';

  @override
  String get klGroupPatternTitle => 'グループのカルマパターン';

  @override
  String get klSharedSetting => '共有された前世の背景';

  @override
  String get klCohesionScore => 'カルマの結束度';

  @override
  String get klPastGoalsTitle => '前世の目標';

  @override
  String get klLearningTitle => '現世で学ぶこと';

  @override
  String get klTeachingMap => '相互学びのマップ';

  @override
  String get klDebtsTitle => 'カルマの負債と解消法';

  @override
  String get klNoDebtsDetected => 'このグループにカルマの負債は検出されませんでした';

  @override
  String get klTimingTitle => 'ムーラ・ダシャーによるカルマのタイミング';

  @override
  String get klAuditTitle => '詳細分析テーブル';

  @override
  String klAuditSubtitle(Object count) {
    return '${count}件のカルマパラメータを分析';
  }

  @override
  String get klTopicLinkage => '私たちの全体的なカルマ連関';

  @override
  String get klTopicPairwise => '特定のペアのカルマの絆';

  @override
  String get klTopicDebts => '解消すべきカルマの負債';

  @override
  String get klTopicLessons => '私たちがここで学ぶべきこと';

  @override
  String get klTopicTiming => '私たちのグループにとって最適なタイミング';

  @override
  String get klTopicGroup => '私たちの共有された前世の物語';

  @override
  String get lcSubtitle => 'AIによるヴェーダ占星術 恋愛相性レポート';

  @override
  String get lcTitle => '恋愛相性';

  @override
  String get lcSnapshotHeader => '恋愛相性スナップショット';

  @override
  String get lcGaugeAttraction => '魅力度';

  @override
  String get lcGaugeEmotional => '感情の調和';

  @override
  String get lcGaugeMental => '精神的な相性';

  @override
  String get lcGaugePassion => '情熱';

  @override
  String get lcGaugeLongterm => '長期的な調和';

  @override
  String get lcChipStrongMental => '強い精神的なつながり';

  @override
  String get lcChipStrongLongterm => '強い長期的な可能性';

  @override
  String get lcChipStrongPassion => '強い身体的な相性';

  @override
  String get lcChipLowFriction => '全体的に摩擦が少ない';

  @override
  String get lcChipKarmicPull => '強いカルマの引力';

  @override
  String get lcPartnersTitle => 'パートナースナップショット';

  @override
  String get lcVenusSuffix => '金星サイン';

  @override
  String get lcAttractionTitle => '魅力と相性';

  @override
  String get lcAttractionScore => '魅力度スコア';

  @override
  String get lcActiveContacts => '有効な金星コンタクト';

  @override
  String get lcEmotionalTitle => '感情の調和';

  @override
  String get lcEmotionalScore => '感情の調和スコア';

  @override
  String get lcNakshatraCompat => 'ナクシャトラ相性';

  @override
  String get lcYoniKoota => 'ヨニ・クータ';

  @override
  String get lcGanaKoota => 'ガナ・クータ';

  @override
  String get lcTaraKoota => 'ターラー・クータ';

  @override
  String get lcBhakootAxis => 'バクート軸';

  @override
  String get lcMentalTitle => '精神的な相性';

  @override
  String get lcMentalScore => '精神的相性スコア';

  @override
  String get lcPassionTitle => '情熱と身体的相性';

  @override
  String get lcPassionScore => '情熱スコア';

  @override
  String get lcLongtermTitle => '長期的な調和';

  @override
  String get lcLongtermScore => '長期的調和スコア';

  @override
  String get lcCommitmentPotential => 'コミットメントの可能性';

  @override
  String get lc7thHouseSynastry => '7ハウスのシナストリー';

  @override
  String get lcJupiterBlessing => '木星の祝福';

  @override
  String get lcD9Resonance => 'D9ナヴァムシャ共鳴';

  @override
  String get lcSaturnLongevity => '土星の持続性';

  @override
  String get lcKarmicTitle => 'カルマの恋愛の絆';

  @override
  String get lcKarmicScore => 'カルマの絆スコア';

  @override
  String get lcKetuContacts => 'ケートゥコンタクト';

  @override
  String get lcRahuContacts => 'ラーフコンタクト';

  @override
  String get lcChallengesTitle => '課題と摩擦';

  @override
  String get lcNoChallenges => 'どちらのチャートにも大きな摩擦点は検出されませんでした';

  @override
  String get lcTotalPenalty => '総課題ペナルティ';

  @override
  String get lcTimingTitle => '恋愛のタイミング — ムーラ・ダシャー';

  @override
  String get lcDynamicsTitle => '関係性のダイナミクス';

  @override
  String get lcPowerBalance => 'パワーバランス';

  @override
  String get lcGiverReceiver => '感情の与え手/受け手';

  @override
  String get lcGrowthDynamic => '成長のダイナミクス';

  @override
  String get lcAreasToNurture => '育むべき領域';

  @override
  String get lcTopicTiming => '私たちの関係にとって最適なタイミング';

  @override
  String get lcTopicChallenges => '乗り越えるべき課題';

  @override
  String get lcTopicKarmic => '私たちのカルマのつながり';

  @override
  String get lcTopicRemedies => 'おすすめのレメディ';

  @override
  String get lcTopicLongterm => '私たちの長期的な可能性';

  @override
  String get lcTopicDynamics => '私たちの関係のダイナミクス';

  @override
  String get cpSubtitle => 'AIによるヴェーダ占星術 子宝運レポート';

  @override
  String get cpTitle => '子宝運';

  @override
  String get cpSnapshotHeader => '子宝運スナップショット';

  @override
  String get cpGauge5thHouse => '5ハウス';

  @override
  String get cpGaugeJupiter => '木星／プトラカーラカ';

  @override
  String get cpGaugeD7 => 'D7サプタムシャ';

  @override
  String get cpGaugeSphuta => 'ビージャ・クシェートラ';

  @override
  String get cpGaugeTiming => 'ダシャーのタイミング';

  @override
  String get cpChipStrongPutrakaraka => '強いプトラカーラカ（木星）';

  @override
  String get cpChipLowDoshaPenalty => 'ドーシャのペナルティが低い';

  @override
  String get cpChipFavorableTiming => '好ましいダシャーのタイミング';

  @override
  String get cpChipNoDoshas => '子宝に関するドーシャは検出されませんでした';

  @override
  String get cpPartnersTitle => 'パートナースナップショット';

  @override
  String get cpLagnaSuffix => 'ラグナ';

  @override
  String get cpMoonSuffix => '月サイン';

  @override
  String get cpNumberTitle => '子供の数と性別の傾向';

  @override
  String get cpProbableNumber => '予想される人数';

  @override
  String get cpFirstChildTendency => '第一子の傾向';

  @override
  String get cpSpacing => '出産間隔についての注記';

  @override
  String get cpTimingTitle => 'タイミング — ムーラ・ダシャー';

  @override
  String get cpCombinedTiming => '総合タイミング';

  @override
  String get cpNextWindow => '次の好機';

  @override
  String get cp5thHouseTitle => '5ハウス分析';

  @override
  String get cp5thHouseSubtitle => '子供のハウス（プトラ・バーヴァ）— 各人ごと';

  @override
  String get cpJupiterTitle => '木星 — プトラカーラカ分析';

  @override
  String get cpJupiterSubtitle => '子供の自然な示唆星、各人ごと';

  @override
  String get cpD7Title => 'D7サプタムシャ分析';

  @override
  String get cpD7Subtitle => '子供のために特化した分割図';

  @override
  String get cpD7Strength => 'D7の強さ';

  @override
  String get cpSphutaTitle => 'ビージャ・スプタとクシェートラ・スプタ';

  @override
  String get cpBeejaSphuta => 'ビージャ・スプタ（種）';

  @override
  String get cpKshetraSphuta => 'クシェートラ・スプタ（畑）';

  @override
  String get cpDoshaTitle => 'ドーシャ分析';

  @override
  String get cpNoDoshasDetected => 'どちらのチャートにも子宝に関わるドーシャは検出されませんでした';

  @override
  String get cpRemediesTitle => 'おすすめのレメディ';

  @override
  String get cpAddresses => '対象';

  @override
  String get cpTopicTiming => '妊娠に最適なタイミング';

  @override
  String get cpTopicNumber => '予想される子供の人数';

  @override
  String get cpTopicDosha => '対処すべきドーシャ';

  @override
  String get cpTopicRemedies => 'おすすめのレメディ';

  @override
  String get cpTopicFifthHouse => '私たちの5ハウスの強さ';

  @override
  String get cpTopicJupiter => 'この件における木星の役割';

  @override
  String get riSubtitle => 'AIによるヴェーダ占星術 人間関係インテリジェンスレポート';

  @override
  String get riTitle => '人間関係インテリジェンス';

  @override
  String get riSnapshotHeader => 'グループスナップショット';

  @override
  String get riGaugeCohesion => 'グループの結束度';

  @override
  String get riGaugeTrust => '信頼度';

  @override
  String get riGaugeProductivity => '生産性';

  @override
  String get riGaugeCreativity => '創造性';

  @override
  String get riChipNoAlerts => '重大な警告なし';

  @override
  String get riChipStrongCohesion => '強いグループの結束';

  @override
  String get riChipHighTrust => '高い信頼度';

  @override
  String get riChipNoHiddenEnemy => '隠れた敵対の兆候なし';

  @override
  String get riChipHealthyGroup => '全体的に健全なグループ';

  @override
  String get riProfilesTitle => 'チャートプロフィール';

  @override
  String riProfilesSubtitle(Object count) {
    return 'このグループには${count}人います';
  }

  @override
  String get riLagnaSuffix => 'ラグナ';

  @override
  String get riIntegrity => '誠実さ';

  @override
  String get riWarmth => '温かさ';

  @override
  String get riTrustworthiness => '信頼性';

  @override
  String get riAssertiveness => '自己主張力';

  @override
  String get riGroupDynamicsTitle => 'グループダイナミクスの概要';

  @override
  String get riMostSupportive => '最もサポート的';

  @override
  String get riMostChallenged => '最も課題が多い';

  @override
  String get riHiddenEnemyAlert => '隠れた敵対の兆候を検出';

  @override
  String get riBestWorstTitle => '最良のペアと最も課題のあるペア';

  @override
  String get riBestPair => '最強の絆';

  @override
  String get riWorstPair => '要注意';

  @override
  String get riAlliances => '予想される協力関係';

  @override
  String get riConflicts => '予想される摩擦点';

  @override
  String get riPairwiseTitle => 'ペア分析';

  @override
  String riPairwiseSubtitle(Object count) {
    return '${count}組を分析';
  }

  @override
  String get riDynamic => 'ダイナミクス';

  @override
  String get riKarmicLink => 'カルマのつながり';

  @override
  String get riMutualTrust => '相互信頼';

  @override
  String get riBetrayalRisk => '裏切りのリスク';

  @override
  String get riPowerDistribution => '力関係の分布';

  @override
  String get riPowerHealth => 'パワーバランスの健全性';

  @override
  String get riCriticalPatternsTitle => '重要なパターン';

  @override
  String get riGroupRecsTitle => 'グループへの提案';

  @override
  String get riSharedPractices => '共有すべき習慣';

  @override
  String get riCommStyle => 'おすすめのコミュニケーションスタイル';

  @override
  String get riGrowthFocus => 'おすすめの成長フォーカス';

  @override
  String get riIndividualTitle => '個人へのアドバイス';

  @override
  String get riBestAllies => '最良の協力者';

  @override
  String get riHandleWithCare => '注意して接するべき相手';

  @override
  String get riCoreThemeTitle => 'グループの中心テーマ';

  @override
  String get riLayerPairwise => 'ペアの完全性';

  @override
  String get riLayerD1 => '出生図（D1）';

  @override
  String get riLayerD9 => 'ナヴァムシャ（D9）';

  @override
  String get riLayerD10 => 'ダシャムシャ（D10）';

  @override
  String get riLayerD30 => 'トリンシャムシャ（D30）';

  @override
  String get riLayerJaimini => 'ジャイミニ・シグナル';

  @override
  String get riLayerBehavior => '行動の明瞭さ';

  @override
  String get riLayerCoherence => 'グループの一貫性';

  @override
  String get riTopicDynamics => '私たちのグループダイナミクス';

  @override
  String get riTopicPairwise => '特定のペアの相性';

  @override
  String get riTopicAlerts => '重大な警告の有無';

  @override
  String get riTopicGrowth => '共に成長する方法';

  @override
  String get riTopicRecs => 'おすすめの習慣';

  @override
  String get riTopicTheme => '私たちの中心テーマ';

  @override
  String get kmSubtitle => 'AIによるヴェーダ占星術 クンダリー・ミラン（結婚相性）レポート';

  @override
  String get kmTitle => 'クンダリー・ミラン';

  @override
  String get kmSnapshotHeader => '相性スナップショット';

  @override
  String kmAshtakootScore(Object score) {
    return 'アシュタクート：${score}/36';
  }

  @override
  String get kmGaugeAshtakoot => 'アシュタクート％';

  @override
  String get kmGaugeD9 => 'D9結婚カルマ';

  @override
  String get kmGaugeMangal => 'マンガルバランス';

  @override
  String get kmGaugePapa => 'カルマバランス';

  @override
  String get kmGaugeAk => '魂の共鳴';

  @override
  String get kmChipNoNadi => 'ナディ・ドーシャなし';

  @override
  String get kmChipNoBhakoot => 'バクート・ドーシャなし';

  @override
  String get kmChipMangalCancelled => 'マンガル・ドーシャは相殺済み';

  @override
  String get kmChipPapaBalanced => 'バランスの取れたカルマの負荷';

  @override
  String get kmChipStrongChemistry => '強い身体的な相性';

  @override
  String get kmChipStrongD9 => '強いD9結婚カルマ';

  @override
  String get kmChipLongevity => '強い長寿の一致';

  @override
  String get kmAshtakootTitle => 'アシュタクート・グナ・ミラン';

  @override
  String get kmAshtakootSubtitle => '古典的な36点満点の8要素マッチングシステム';

  @override
  String get kmNadiSeverity => 'ナディの深刻度';

  @override
  String get kmBhakootSeverity => 'バクートの深刻度';

  @override
  String get kmGanaSignature => 'ガナの特性';

  @override
  String get kmMangalTitle => 'マンガル・ドーシャチェック';

  @override
  String get kmD9Title => 'D9ナヴァムシャ — 結婚カルマ';

  @override
  String get kmD9Subtitle => '古典的に最も重要とされる、魂レベルの結婚図';

  @override
  String get kmD9Score => 'D9相性';

  @override
  String get kmLagnaRelation => 'ラグナの関係性';

  @override
  String get km7thLordRelation => '7ハウス支配星の関係性';

  @override
  String get kmKarakasTitle => '魂と配偶者のカーラカ';

  @override
  String get kmAtmakaraka => '魂の惑星';

  @override
  String get kmAkCompatibility => '魂のシグネチャー共鳴';

  @override
  String get kmUlCompatibility => '配偶者カーラカの一致';

  @override
  String get kmUlSigns => 'ウパパダ支配星';

  @override
  String get kmChemistryTitle => '金星・火星の相性';

  @override
  String get kmPhysicalChemistry => '身体的な相性';

  @override
  String get kmEmotionalWarmth => '感情的な温かさ';

  @override
  String get kmAestheticAlignment => '美的感覚の一致';

  @override
  String get kmElementalSynthesis => 'エレメントの調和';

  @override
  String get kmHouseCrossTitle => '7ハウス・8ハウス クロス分析';

  @override
  String get km78Compatibility => '7ハウス・8ハウス相性';

  @override
  String get km8thHouseSignature => '共同の長寿サイン';

  @override
  String get kmLongevityAlignment => '長寿の一致';

  @override
  String get km7thLordFriendship => '7ハウス支配星の友好関係';

  @override
  String get kmDomainsTitle => '分野別相性';

  @override
  String get kmConflictEngagement => '対立への対処スタイル';

  @override
  String get kmDashaTitle => 'ダシャー・トランジットの同調';

  @override
  String get kmDashaSync => 'ダシャーの同調';

  @override
  String get kmTransitAlignment => 'トランジットの一致';

  @override
  String get kmTimingTitle => '結婚のタイミング';

  @override
  String get kmMarriageWindow => '結婚に適した時期';

  @override
  String get kmEngagementWindow => '婚約に適した時期';

  @override
  String get kmRecommendedRange => 'おすすめの期間';

  @override
  String get kmMuhurtaNotes => 'ムフルタ（吉日）についての注記';

  @override
  String get kmRisksTitle => '対処すべきリスク';

  @override
  String get kmConflictRisk => '対立のリスク';

  @override
  String get kmCommunicationRisk => 'コミュニケーションのリスク';

  @override
  String get kmFinanceRisk => '金銭面での対立リスク';

  @override
  String get kmFamilyDynamicsRisk => '家族関係のリスク';

  @override
  String get kmMentalHealthRisk => 'メンタルヘルスの一致リスク';

  @override
  String get kmStrengthsTitle => '主な相性の強み';

  @override
  String get kmSharedGrowth => '共有できる成長の可能性';

  @override
  String get kmSharedCreative => '共有できる創造的な可能性';

  @override
  String get kmJourneyTitle => '関係性の歩みと成長';

  @override
  String get kmCurrentPhase => '現在の段階';

  @override
  String get kmEarlyArc => '結婚初期';

  @override
  String get kmMiddleArc => '結婚中期';

  @override
  String get kmMatureArc => '結婚成熟期';

  @override
  String get kmElderArc => '晩年';

  @override
  String get kmPeakPhase => '最も充実した伴侶関係の時期';

  @override
  String get kmGrowthAreas => '成長すべき分野';

  @override
  String get kmCommProtocols => 'コミュニケーションの指針';

  @override
  String get kmSharedPractices => '共有すべき習慣';

  @override
  String get kmImprovementTitle => '中心テーマと改善プラン';

  @override
  String get kmVerdictTitle => '最終判定';

  @override
  String get kmRealizationPotential => '関係実現の可能性';

  @override
  String get kmLayerAshtakoot => 'アシュタクート';

  @override
  String get kmLayerD9 => 'D9ナヴァムシャ';

  @override
  String get kmLayerMangalPapa => 'マンガルとパーパサミヤ';

  @override
  String get kmLayerVenusMars => '金星・火星';

  @override
  String get kmLayerDashaSync => 'ダシャーの同調';

  @override
  String get kmLayerH7H8 => '7ハウス・8ハウス クロス';

  @override
  String get kmLayerAkResonance => 'アートマカーラカ共鳴';

  @override
  String get kmLayerDomains => '分野別次元';

  @override
  String get kmTopicAshtakoot => '私たちのアシュタクートスコア';

  @override
  String get kmTopicMangal => 'マンガル・ドーシャに関する懸念';

  @override
  String get kmTopicD9 => '私たちの結婚カルマ（D9）';

  @override
  String get kmTopicTiming => '結婚に最適なタイミング';

  @override
  String get kmTopicRisks => '備えるべきリスク';

  @override
  String get kmTopicGrowth => '共に成長する方法';

  @override
  String get kmTopicRemedies => 'おすすめのレメディ';

  @override
  String get kmTopicVerdict => '結婚を進めるべきか';

  @override
  String get pkSubtitle => 'AIによるヴェーダ占星術 前世とカルマのレポート';

  @override
  String get pkTitle => '前世とカルマ';

  @override
  String get pkSnapshotHeader => '前世スナップショット';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return 'あなたのチャートは「${theme}」という前世のシグネチャーを示しており、現在は${relation}という形で今世に影響しています。おすすめの道：${strategy}。';
  }

  @override
  String get pkGaugeSignature => 'シグネチャーの強さ';

  @override
  String get pkGaugeMasteryPreserved => '保持された熟達度';

  @override
  String get pkGaugeClearingProgress => 'カルマの浄化';

  @override
  String get pkGaugeMaturity => '前世の成熟度';

  @override
  String get pkGaugeMemoryAccess => '記憶へのアクセス';

  @override
  String get pkChipGoodProgress => '良好なカルマ浄化の進捗';

  @override
  String get pkChipLowDebt => 'カルマの負債が少ない';

  @override
  String get pkChipMatureSoul => '成熟した魂のシグネチャー';

  @override
  String get pkChipGiftedPast => 'チャートに前世からの才能が見られる';

  @override
  String get pkChipAccomplished => '充実した前世';

  @override
  String get pkChipMasteryPreserved => '強く受け継がれた熟達';

  @override
  String get pkKetuTitle => 'ケートゥ — あなたの前世の熟達';

  @override
  String get pkKetuSubtitle => 'あなたの魂がすでに習得したスキル';

  @override
  String get pkMasteryStrength => '熟達の強さ';

  @override
  String get pkSkillsCarried => '受け継がれたスキル';

  @override
  String get pkInstincts => '本能的な能力';

  @override
  String get pkKetuDignity => 'ケートゥの品位';

  @override
  String get pkRahuTitle => 'ラーフ — あなたの魂の成長課題';

  @override
  String get pkRahuSubtitle => 'あなたの魂がここで完成させるべきこと';

  @override
  String get pkUnmetDesires => '満たされていない願望';

  @override
  String get pkProfileTitle => 'あなたの前世プロフィール';

  @override
  String get pkProfession => '考えられる職業';

  @override
  String get pkSocialStanding => '社会的地位';

  @override
  String get pkRegion => '考えられる地域';

  @override
  String get pkCulturalArchetype => '文化的アーキタイプ';

  @override
  String get pkAccomplishment => '達成度のレベル';

  @override
  String get pkAuthority => '権威のレベル';

  @override
  String get pkFamilyRole => '家族内での役割';

  @override
  String get pkSecondaryProfession => '副次的な職業';

  @override
  String get pkClimateAffinity => '気候への親和性';

  @override
  String get pkForeignResidence => '海外居住のカルマ';

  @override
  String get pkRelationshipsTitle => '受け継がれた過去の関係';

  @override
  String get pkSpouseConnection => '配偶者との再会';

  @override
  String get pkChildrenConnection => '子供との再会';

  @override
  String get pkCarriedRelationTypes => '関係性のパターン';

  @override
  String get pkPartnerArchetype => '前世のパートナーのアーキタイプ';

  @override
  String get pkDarakaraka => '配偶者カーラカ';

  @override
  String get pkParentsKarma => '両親とのカルマパターン';

  @override
  String get pkSiblingKarma => '兄弟姉妹とのカルマパターン';

  @override
  String get pkSpiritualTitle => '前世でのあなたの精神生活';

  @override
  String get pkSpiritualLevel => '精神性のレベル';

  @override
  String get pkPracticeSignature => '実践スタイル';

  @override
  String get pkMeditativeCapacity => '瞑想力';

  @override
  String get pkDevotionalPractice => '献身的な実践';

  @override
  String get pkYogicAttainment => 'ヨーガの到達度';

  @override
  String get pkMokshaProximity => '解脱への近さ';

  @override
  String get pkKarmicDebtsTitle => 'カルマの負債と前世の富';

  @override
  String get pkTotalKarmicDebt => 'カルマの負債合計';

  @override
  String get pkPrimaryDebtType => '主な負債の種類';

  @override
  String get pkRelationshipDebt => '人間関係の負債';

  @override
  String get pkFinancialDebt => '金銭的な負債';

  @override
  String get pkServiceDebt => '奉仕の負債';

  @override
  String get pkDharmicDebt => 'ダルマの負債';

  @override
  String get pkPitruKarma => '父系（ピトゥル）のカルマ';

  @override
  String get pkMatruKarma => '母系（マートゥル）のカルマ';

  @override
  String get pkWealthLevel => '前世での富のレベル';

  @override
  String get pkWealthKarmaCarried => '受け継がれた富のカルマ';

  @override
  String get pkResourcePattern => '資源管理のパターン';

  @override
  String get pkGainSource => '利得の源';

  @override
  String get pkEchoesTitle => '今世への影響';

  @override
  String get pkOnRelationships => '人間関係への影響';

  @override
  String get pkOnCareer => 'キャリアへの影響';

  @override
  String get pkOnHealth => '健康への影響';

  @override
  String get pkOnSpirituality => '精神性への影響';

  @override
  String get pkDominantArea => '最も強く受け継がれた分野';

  @override
  String get pkAttractions => '自然な引かれ';

  @override
  String get pkAversions => '自然な嫌悪';

  @override
  String get pkUnexplainedFears => '説明のつかない恐れ';

  @override
  String get pkMagneticPulls => '引き寄せられるもの';

  @override
  String get pkResolutionTitle => 'カルマの解消と完成';

  @override
  String get pkPrimaryPathway => '主な道筋';

  @override
  String get pkSecondaryPathway => '副次的な道筋';

  @override
  String get pkClearingProgress => '浄化の進捗';

  @override
  String get pkRemainingWork => '残された課題';

  @override
  String get pkSettlementTimeline => '解消までの目安';

  @override
  String get pkAccelerationPractices => '解消を早める実践';

  @override
  String get pkPriorityAreas => '優先すべき分野';

  @override
  String get pkVerificationTitle => 'チャート間で確認された内容（D60）';

  @override
  String get pkD60Label => 'D60前世時代';

  @override
  String get pkD60Ketu => 'D60のケートゥの配置';

  @override
  String get pkD60Standing => '全体的な位置づけ';

  @override
  String get pkMemoryTitle => '記憶と直感';

  @override
  String get pkMemoryAccess => '記憶へのアクセス';

  @override
  String get pkRegressionFit => '退行療法への適性';

  @override
  String get pkDreamVisits => '夢での訪問';

  @override
  String get pkDejaVuFrequency => 'デジャヴュの頻度';

  @override
  String get pkSpontaneousRemembrance => '自然に蘇る記憶';

  @override
  String get pkRemembrancePractices => '記憶を呼び覚ます実践';

  @override
  String get pkTimelineTitle => '活性化のタイムライン';

  @override
  String get pkGiftsActivation => '前世の才能の活性化';

  @override
  String get pkSurfaceWindow => '表面化する時期';

  @override
  String get pkRisksTitle => 'リスクと慢性的なパターン';

  @override
  String get pkTraumaResidue => 'トラウマの残留';

  @override
  String get pkSpiritualBypass => 'スピリチュアル・バイパスのリスク';

  @override
  String get pkMajorRisks => '主なリスク';

  @override
  String get pkChronicImprints => '慢性的な刻印';

  @override
  String get pkKarmicLoops => 'カルマのループ';

  @override
  String get pkImprovementTitle => '改善プラン';

  @override
  String get pkRoadmapTitle => 'あなたの前世ロードマップ';

  @override
  String get pkMaturity => '前世の成熟度';

  @override
  String get pkLayerD1 => '出生図（D1）';

  @override
  String get pkLayerD9 => 'ナヴァムシャ（D9）';

  @override
  String get pkLayerD60 => 'シャシュティアムシャ（D60）';

  @override
  String get pkLayerKetuDepth => 'ケートゥの深度';

  @override
  String get pkLayerAtmakaraka => '魂の惑星（アートマカーラカ）';

  @override
  String get pkTopicMastery => '私の前世の熟達';

  @override
  String get pkTopicUnfinished => '私の未完了のカルマ';

  @override
  String get pkTopicRelationships => '私の前世の人間関係';

  @override
  String get pkTopicDebts => '私のカルマの負債';

  @override
  String get pkTopicResolution => 'カルマを解消する方法';

  @override
  String get pkTopicMemory => '前世の記憶へのアクセス';

  @override
  String get pkTopicTiming => '最適なタイミング';

  @override
  String get pkTopicProfile => '前世での私の姿';

  @override
  String get chSubtitle => 'AIによるヴェーダ占星術 性格分析レポート';

  @override
  String get chTitle => '性格分析';

  @override
  String get chSnapshotHeader => '性格スナップショット';

  @override
  String get chGaugeIntegrity => '誠実さ';

  @override
  String get chGaugeResilience => '回復力';

  @override
  String get chGaugeSelfAwareness => '自己認識';

  @override
  String get chGaugeStability => '感情の安定性';

  @override
  String get chGaugeMoralFabric => '道徳観';

  @override
  String get chChipRajaYoga => 'ラージャ・ヨーガあり';

  @override
  String get chChipHighIntegrity => '高い誠実さ';

  @override
  String get chChipResilient => '回復力のある性質';

  @override
  String get chChipDharmic => '強いダルマ志向';

  @override
  String get chChipEmpathetic => '生来の共感力';

  @override
  String get chChipLoyal => '深い忠誠心';

  @override
  String get chChipGiftedCharacter => 'チャートに性格上の才能が見られる';

  @override
  String get chSoulTitle => 'あなたの魂のシグネチャー';

  @override
  String get chSoulIntegration => '魂と性格の統合';

  @override
  String get chAmatyakarakaTheme => '副次的な性格の声';

  @override
  String get chAtmakarakaDignity => '魂の惑星の品位';

  @override
  String get chAtmakarakaHouse => 'ハウスの配置';

  @override
  String get chSurfaceTitle => '表面的な人格と体質';

  @override
  String get chLagnaSign => 'アセンダントサイン';

  @override
  String get chConstitution => '体質';

  @override
  String get chSurfaceSignature => '他人からの見え方';

  @override
  String get chPhysicalConstitution => '身体的体質';

  @override
  String get chLagnaLord => 'アセンダント支配星';

  @override
  String get chLagnaOccupants => 'アセンダントに位置する惑星';

  @override
  String get chMindEmotionsTitle => '心・感情・自我';

  @override
  String get chEmotionalNature => 'あなたの感情的な性質';

  @override
  String get chMentalStability => '精神的安定性';

  @override
  String get chSelfConfidence => '健全な自信';

  @override
  String get chEgoNature => 'あなたの自我と自己概念';

  @override
  String get chAuthorityRelationship => '権威との関係';

  @override
  String get chPrideTendency => 'プライドの傾向';

  @override
  String get chMoodPatterns => '気分のパターン';

  @override
  String get chKemadrumaPresent => 'ケーマドゥルマ・ヨーガあり — 感情面での自己ケアを心がけると良いでしょう。';

  @override
  String get chFatherImprint => '父親からの刻印の質';

  @override
  String get chCommunicationTitle => 'コミュニケーションと知性のスタイル';

  @override
  String get chIntellectStyle => '知性のスタイル';

  @override
  String get chCommStyle => 'コミュニケーションスタイル';

  @override
  String get chDecisionStyle => '意思決定のスタイル';

  @override
  String get chDiscrimination => '識別力';

  @override
  String get chPersonaTitle => '公的な人格と本当の自分';

  @override
  String get chAuthenticityGap => '本音とのギャップ';

  @override
  String get chGunaTitle => 'グナとドーシャのプロフィール';

  @override
  String get chGunaSubtitle => '古典的なヴェーダ流の、あなたの内なる性質と体質';

  @override
  String get chSattva => 'サットヴァ';

  @override
  String get chRajas => 'ラジャス';

  @override
  String get chTamas => 'タマス';

  @override
  String get chDominantGuna => '優勢なグナ';

  @override
  String get chPitta => 'ピッタ';

  @override
  String get chKapha => 'カパ';

  @override
  String get chVata => 'ヴァータ';

  @override
  String get chDominantDosha => '優勢なドーシャ';

  @override
  String get chRahuRestlessness => 'ラーフによる落ち着きのなさ';

  @override
  String get chKetuDetachment => 'ケートゥによる無執着';

  @override
  String get chYogasTitle => '性格に関わるヨーガ';

  @override
  String get chRajaYogaStrength => 'ラージャ・ヨーガの強さ';

  @override
  String get chGiftYogas => '才能のヨーガ';

  @override
  String get chTestYogas => '試練のヨーガ';

  @override
  String get chStrengthsTitle => '強みと才能';

  @override
  String get chSignatureVirtues => '特徴的な美徳';

  @override
  String get chNaturalTalents => '生まれ持った才能';

  @override
  String get chSoftSkills => 'ソフトスキル';

  @override
  String get chHiddenStrengths => '伸ばすべき隠れた強み';

  @override
  String get chShadowTitle => 'シャドウと成長すべき分野';

  @override
  String get chShadowSubtitle => '取り組む価値のあるパターンへの穏やかな気づき';

  @override
  String get chShadowPatterns => 'シャドウパターン';

  @override
  String get chBlindSpots => '盲点';

  @override
  String get chEmotionalWounds => '感情的な傷';

  @override
  String get chShadowWorkPriorities => '優先すべきシャドウワーク';

  @override
  String get chMoralTests => '道徳的な試練';

  @override
  String get chRelationshipsTitle => '人間関係と社交スタイル';

  @override
  String get chWarmth => '対人的な温かさ';

  @override
  String get chEmpathy => '共感力';

  @override
  String get chLoyalty => '忠誠心';

  @override
  String get chBoundaries => '境界線の設定';

  @override
  String get chSocialConfidence => '社交での自信';

  @override
  String get chTrustGiving => '信頼を与える基準';

  @override
  String get chConflictStyle => '対立への対処スタイル';

  @override
  String get chEthicsTitle => '倫理観と道徳的指針';

  @override
  String get chDharmaOrientation => 'ダルマ志向';

  @override
  String get chTruthfulness => '誠実さ';

  @override
  String get chCompassion => '思いやり';

  @override
  String get chGenerosity => '寛大さ';

  @override
  String get chEthicalConsistency => '倫理的な一貫性';

  @override
  String get chIntegrityPressure => 'プレッシャー下での誠実さ';

  @override
  String get chJusticeFairness => '正義と公正さ';

  @override
  String get chMoralTrajectory => '道徳的な発達';

  @override
  String get chEiTitle => '感情的知性（EQ）';

  @override
  String get chEiSelfAwareness => '自己認識';

  @override
  String get chEiSelfRegulation => '自己制御';

  @override
  String get chEiEmpathy => '共感力';

  @override
  String get chEiSocialSkills => '社会的スキル';

  @override
  String get chMotivation => '内発的動機';

  @override
  String get chVulnerabilityComfort => '弱さを見せる心地よさ';

  @override
  String get chEmotionalExpression => '感情表現の快適さ';

  @override
  String get chEmotionalReceptivity => '感情の受容性';

  @override
  String get chVerificationTitle => 'チャート間で確認された内容（D9/D12/D30/D60）';

  @override
  String get chD9Label => 'D9 ダルマと性格';

  @override
  String get chD12Label => 'D12 先祖からの継承';

  @override
  String get chD30Label => 'D30 シャドウプロフィール';

  @override
  String get chD60Label => 'D60 前世の性格';

  @override
  String get chD30Standing => 'シャドウの位置づけ';

  @override
  String get chMaternalInheritance => '母系からの継承';

  @override
  String get chAncestralKarmaWeight => '先祖のカルマの重み';

  @override
  String get chTimelineTitle => '性格のタイムライン';

  @override
  String get chFormationWindow => '形成期';

  @override
  String get chMaturationWindow => '成熟期';

  @override
  String get chLegacyWindow => '継承期';

  @override
  String get chPeakMaturationAge => '成熟のピーク年齢';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return '${ageRange}歳';
  }

  @override
  String get chImprovementTitle => '改善プラン';

  @override
  String get chRoadmapTitle => 'あなたの性格ロードマップ';

  @override
  String get chAuthenticExpression => '本来の自己表現';

  @override
  String get chRealizationPotential => '性格の実現可能性';

  @override
  String get chLayerAtmakaraka => '魂の惑星（アートマカーラカ）';

  @override
  String get chLayerD1 => '出生図（D1）';

  @override
  String get chLayerD9 => 'ナヴァムシャ（D9）';

  @override
  String get chLayerD30 => 'トリンシャムシャ（D30）';

  @override
  String get chLayerLagnaMoon => 'アセンダントと月';

  @override
  String get chLayerArudha => 'アルーダ・ラグナ';

  @override
  String get chTopicStrengths => '私の性格の強み';

  @override
  String get chTopicShadow => '私のシャドウパターン';

  @override
  String get chTopicSoul => '私の魂のシグネチャー';

  @override
  String get chTopicRelationships => '私の人間関係のスタイル';

  @override
  String get chTopicEthics => '私の倫理観と価値観';

  @override
  String get chTopicGuna => '私のグナとドーシャのプロフィール';

  @override
  String get chTopicGrowth => '性格を成長させる方法';

  @override
  String get chTopicTiming => '性格を磨くのに最適なタイミング';

  @override
  String get lpSubtitle => 'AIによるヴェーダ占星術 人生の道と運勢レポート';

  @override
  String get lpTitle => '人生の道と運勢';

  @override
  String get lpSnapshotHeader => '人生の道スナップショット';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return 'あなたは${domain}を主な目的とする${archetype}です。分析の結果、全体的な人生充足の可能性は${probability}％です。';
  }

  @override
  String get lpGaugeDharma => 'ダルマの明瞭さ';

  @override
  String get lpGaugeFortune => '幸運の基盤';

  @override
  String get lpGaugeCoherence => '道の一貫性';

  @override
  String get lpGaugeFulfillment => '充足度';

  @override
  String get lpGaugeMomentum => 'カルマの勢い';

  @override
  String get lpChipRareGift => '稀な運命の才能';

  @override
  String get lpChipFreeWillStrong => '強い自由意志';

  @override
  String get lpChipGraceSupported => '恩寵に支えられている';

  @override
  String get lpChipLightKarma => '軽いカルマの負荷';

  @override
  String get lpChipRecognitionPotential => '認知される可能性';

  @override
  String get lpChipSpiritualPath => '強い精神的な引力';

  @override
  String get lpChipBlessed => 'チャートに祝福が見られる';

  @override
  String get lpSoulPathTitle => 'あなたの魂の道';

  @override
  String get lpSoulPlanet => '魂の惑星';

  @override
  String get lpCareerPlanet => '目的の惑星';

  @override
  String get lpSoulClarity => '目的の明瞭さ';

  @override
  String get lpLifeChapter => '現在の人生の章';

  @override
  String get lpPrimaryDomain => '主な目的の分野';

  @override
  String get lpKarakaTitle => 'あなたのダルマの惑星';

  @override
  String get lpKarakaSubtitle => '各惑星があなたの人生の目的をどれだけ支えているか';

  @override
  String get lpVerificationTitle => 'チャート間で確認された内容（D9 / D60）';

  @override
  String get lpD9Label => 'D9 魂の一致';

  @override
  String lpD9Explain(Object stage) {
    return 'ナヴァムシャ図では、あなたの魂の進化段階は「${stage}」です。';
  }

  @override
  String get lpD9JupiterDignity => '木星の品位';

  @override
  String get lpD9DharmaMultiplier => 'ダルマ倍率';

  @override
  String get lpD60Label => 'D60 前世のシグネチャー';

  @override
  String get lpKarmaType => '前世カルマのタイプ';

  @override
  String get lpKetuMastery => 'ケートゥの前世の熟達';

  @override
  String get lpRahuGrowthDir => 'ラーフの成長の方向性';

  @override
  String get lpYogasTitle => '幸運のヨーガと運の妨げ';

  @override
  String get lpFortuneBoost => '幸運の後押し';

  @override
  String get lpLuckDrain => '運気の消耗';

  @override
  String get lpFortuneBoosters => '幸運を後押しする要素';

  @override
  String get lpLuckBlocks => '運を妨げる要素';

  @override
  String get lpPurposeTitle => '目的の分野と名声';

  @override
  String get lpDomainLeadership => 'リーダーシップ';

  @override
  String get lpDomainWisdom => '知恵と教育';

  @override
  String get lpDomainService => '奉仕';

  @override
  String get lpDomainHealing => '癒し';

  @override
  String get lpDomainCreative => '創造的表現';

  @override
  String get lpPrimaryDomainBadge => '主要';

  @override
  String get lpFameRecognition => '名声と評価';

  @override
  String get lpSocialInfluence => '社会的影響力';

  @override
  String get lpRecognitionDomain => '評価される分野';

  @override
  String get lpPublicImage => '公的イメージ';

  @override
  String get lpHistoricalImpact => '歴史的な影響力の可能性';

  @override
  String get lpTimelineTitle => '幸運と人生のタイムライン';

  @override
  String get lpCurrentPhase => '現在の幸運期';

  @override
  String get lpJupiterReturn => '木星回帰';

  @override
  String get lpSaturnReturn => '土星回帰';

  @override
  String get lpSadeSati => 'サデ・サティ';

  @override
  String get lpGoldenWindow => '黄金期';

  @override
  String get lpTransformationWindow => '変容期';

  @override
  String get lpPeakYears => '幸運のピーク期間';

  @override
  String get lpChallengingYears => '困難な時期';

  @override
  String get lpMilestonesTitle => '主な節目と転機';

  @override
  String get lpFirstTurningPoint => '最初の大きな転機';

  @override
  String get lpMidlifeTransform => '中年期の変容';

  @override
  String get lpLateLifeFulfillment => '晩年の充足';

  @override
  String lpDharmicMilestone(Object age) {
    return 'ダルマ的な節目（${age}歳）';
  }

  @override
  String lpAgeLabel(Object age) {
    return '${age}歳';
  }

  @override
  String get lpDestinyTitle => '運命と自由意志';

  @override
  String get lpDestinyStat => '運命の比重';

  @override
  String get lpFreeWillStat => '自由意志の影響力';

  @override
  String get lpFateStrength => '運命のシグネチャーの強さ';

  @override
  String get lpSelfCreation => '自己創造力';

  @override
  String get lpEffortGrace => '努力と恩寵';

  @override
  String get lpKarmicTitle => 'カルマの教訓';

  @override
  String get lpRahuGrowthLabel => 'ラーフ — 成長の課題';

  @override
  String get lpKetuSurrenderLabel => 'ケートゥ — 手放しのテーマ';

  @override
  String get lpSaturnLessonLabel => '土星 — 規律の教訓';

  @override
  String get lpTestDifficulty => '人生の試練の難易度';

  @override
  String get lpLessonsInProgress => '進行中の教訓';

  @override
  String get lpSoulContract => '魂の契約領域';

  @override
  String get lpSoulExperience => 'あなたの魂が経験しに来たこと';

  @override
  String get lpSoulMastery => 'あなたの魂が習得しに来たこと';

  @override
  String get lpSpiritualTitle => '精神的な道';

  @override
  String get lpSpiritualInclination => '精神的な傾向';

  @override
  String get lpMeditationReceptivity => '瞑想への受容性';

  @override
  String get lpTeacherKarma => '師（グル）とのカルマ';

  @override
  String get lpPilgrimageBenefit => '巡礼の効用';

  @override
  String get lpSelfRealization => '自己実現の可能性';

  @override
  String get lpDivineConnection => '神性とのつながり';

  @override
  String get lpTraditionAffinity => '伝統への親和性';

  @override
  String get lpIntuitionStrength => '直感の強さ';

  @override
  String get lpMantraEfficacy => '祈り・マントラの効果';

  @override
  String get lpInnerGuidance => '内なる導きへの信頼';

  @override
  String get lpPropheticDreams => '予知夢への感受性';

  @override
  String get lpDifficultyTitle => '人生の困難と課題';

  @override
  String get lpEarlyLife => '人生前半';

  @override
  String get lpMidlife => '中年期';

  @override
  String get lpLateLife => '晩年';

  @override
  String get lpStruggleToSuccess => '苦難から成功へのカルマ';

  @override
  String get lpUnlivedLifeRisk => '生きられない人生のリスク';

  @override
  String get lpChallenges => '人生の課題';

  @override
  String get lpFortuneDrains => '慢性的な運気の消耗';

  @override
  String get lpRegretAreas => '後悔しやすい領域';

  @override
  String get lpRedFlags => '方向性の警告サイン';

  @override
  String get lpBlessingsTitle => '祝福と人生の中心テーマ';

  @override
  String get lpKarmicRoot => 'カルマの根本原因';

  @override
  String get lpBlessingsList => 'あなたの祝福';

  @override
  String get lpFulfillmentPriorities => '充足のための優先事項';

  @override
  String get lpImprovementTitle => '改善プラン';

  @override
  String get lpDharmaPriorities => 'ダルマの優先事項';

  @override
  String get lpRoadmapTitle => 'あなたの運命ロードマップ';

  @override
  String get lpStrategy => '戦略';

  @override
  String get lpFulfillmentPotential => '充足の可能性';

  @override
  String get lpNext12Focus => '今後12ヶ月の重点';

  @override
  String get lpLayerD1 => '出生図（D1）';

  @override
  String get lpLayerD9 => 'ナヴァムシャ（D9）';

  @override
  String get lpLayerD60 => 'シャシュティアムシャ（D60）';

  @override
  String get lpLayerDasha => 'ダシャーのタイミング';

  @override
  String get lpLayerTransit => '現在のトランジット';

  @override
  String get lpTopicPurpose => '私の人生の目的';

  @override
  String get lpTopicFortune => '私の幸運のヨーガ';

  @override
  String get lpTopicKarma => '私のカルマの教訓';

  @override
  String get lpTopicMilestones => '今後の節目';

  @override
  String get lpTopicDestiny => '運命と自由意志';

  @override
  String get lpTopicSpiritual => '私の精神的な道';

  @override
  String get lpTopicChallenges => '私の人生の課題';

  @override
  String get lpTopicTiming => '最適なタイミング';

  @override
  String get dbSubtitle => 'AIによるヴェーダ占星術 負債と回復レポート';

  @override
  String get dbTitle => '負債と回復';

  @override
  String get dbSnapshotHeader => '負債回復スナップショット';

  @override
  String dbHeroSummary(Object phase, Object personality, Object probability, Object years) {
    return 'あなたは現在「${phase}」の段階にあり、お金に対しては${personality}なアプローチをとっています。分析によると、約${years}年以内に借金を完済できる可能性は${probability}％です。';
  }

  @override
  String get dbGaugeCapacity => '回復力';

  @override
  String get dbGaugeProbability => '回復の可能性';

  @override
  String get dbGaugeFreedomNow => '現時点での負債からの自由度';

  @override
  String get dbGaugeDti => '収入の健全性';

  @override
  String get dbGaugeResilience => 'レジリエンス';

  @override
  String get dbChipCleanKarma => 'クリーンな負債カルマ';

  @override
  String get dbChipStrongRecovery => '強い回復力';

  @override
  String get dbChipHealthyDti => '健全な負債対収入比率';

  @override
  String get dbChipResilient => '高い心理的レジリエンス';

  @override
  String get dbChipCycleBreakable => '負債サイクルは断ち切れる';

  @override
  String get dbChipLowReindebt => '再負債リスクが低い';

  @override
  String get dbChipGoodNegotiator => '交渉が有利になる可能性';

  @override
  String get dbProfileTitle => 'あなたの負債プロフィール';

  @override
  String get dbPhaseLabel => '現在の段階';

  @override
  String get dbPrimaryCategoryLabel => '主なカテゴリー';

  @override
  String get dbKarakaLabel => '負債カーラカ';

  @override
  String get dbProtectorLabel => '債権者からの保護';

  @override
  String get dbSecondaryCategories => '副次的なカテゴリー';

  @override
  String get dbUnsecuredRatio => '無担保負債の割合';

  @override
  String get dbKarakaTitle => 'あなたの負債に関わる惑星';

  @override
  String get dbKarakaSubtitle => '各惑星があなたの負債回復をどれだけ支えているか';

  @override
  String get dbVerificationTitle => 'チャート間で確認された内容（D6）';

  @override
  String get dbD6Label => 'D6 負債と敵のチャート';

  @override
  String get dbD6LordDignity => '6ハウス支配星の強さ';

  @override
  String get dbD6Severity => '負債カルマの深刻度';

  @override
  String get dbD6Multiplier => 'D6負債倍率';

  @override
  String get dbYogasTitle => '負債のヨーガと保護';

  @override
  String get dbPressureNow => '現在の負債プレッシャー';

  @override
  String get dbRecoveryBoost => '回復の後押し';

  @override
  String get dbClearingLabel => '負債解消のヨーガ';

  @override
  String get dbCreatingLabel => '負債発生のヨーガ';

  @override
  String get dbCategoriesTitle => '注意すべき負債カテゴリー';

  @override
  String get dbCategoriesSubtitle => 'どの種類の負債に最も注意が必要か';

  @override
  String get dbTimelineTitle => '完済までのタイムライン';

  @override
  String get dbFreeWindowLabel => '完済の好機';

  @override
  String get dbClearanceEstimate => '完全完済の見込み';

  @override
  String get dbPeakYears => '負債のピーク期間';

  @override
  String get dbClearanceYears => '完済までの年数';

  @override
  String get dbBorrowTitle => '賢い借入ガイド';

  @override
  String get dbLoanSuitability => '融資の適性';

  @override
  String get dbBestLoanType => '最適な融資タイプ';

  @override
  String get dbLeverageCeiling => 'レバレッジの上限';

  @override
  String get dbNegotiationSuccess => '交渉成功の可能性';

  @override
  String get dbCreditorAggression => '債権者からの圧力リスク';

  @override
  String get dbLegalEscalation => '法的措置に発展するリスク';

  @override
  String get dbNegotiationApproach => 'おすすめの交渉アプローチ';

  @override
  String get dbAvoidLoanTypes => '避けるべき融資タイプ';

  @override
  String get dbRiskTitle => 'リスクと脆弱性の注意点';

  @override
  String get dbRiskDefault => 'デフォルト（債務不履行）リスク';

  @override
  String get dbRiskDefaultExp => '予定された返済を大きく滞納し、貸し手からデフォルト扱いされる可能性です。';

  @override
  String get dbRiskDefaultFix => '最低返済額を自動化し、1ヶ月分の予備資金を確保することで、収入が一時的に途絶えても連鎖しないようにしましょう。';

  @override
  String get dbRiskBankruptcy => '破産リスク';

  @override
  String get dbRiskBankruptcyExp => '収入や資産で現実的にカバーできる範囲を超えて負債が膨らむ可能性です。';

  @override
  String get dbRiskBankruptcyFix => '新たな融資やクレジットラインを組む前に、専門家による負債の見直しを受けましょう。';

  @override
  String get dbRiskAssetSeizure => '資産差し押さえリスク';

  @override
  String get dbRiskAssetSeizureExp => '担保付き融資の返済不履行により、貸し手が担保や資産を回収する可能性です。';

  @override
  String get dbRiskAssetSeizureFix => '担保付き融資の返済を最優先にし、支払いに遅れが出そうな場合は早めに借り換えを検討しましょう。';

  @override
  String get dbRiskChronic => '慢性的な再負債リスク';

  @override
  String get dbRiskChronicExp => '現在の負債を完済した後も、再び借金を抱えてしまう傾向です。';

  @override
  String get dbRiskChronicFix => '完済後に生活費を増やす前に、専用の緊急資金を用意しましょう。';

  @override
  String get dbReindebtTrigger => '再負債のきっかけ';

  @override
  String get dbCycleBreakFeasibility => 'サイクルを断ち切れる可能性';

  @override
  String get dbMajorRisks => '主なリスク';

  @override
  String get dbHiddenSignals => '隠れた負債のサイン';

  @override
  String get dbCrisisTitle => '危機への備え';

  @override
  String get dbCrisisSubtitle => '早期に問題を察知し、冷静に対応する方法';

  @override
  String get dbWarningSigns => '早期の警告サイン';

  @override
  String get dbMitigationActions => '取るべき対策';

  @override
  String get dbFamilyTitle => '家族と先祖からの負債';

  @override
  String get dbInheritedDebtProb => '負債継承の可能性';

  @override
  String get dbFamilyDrag => '家族の負債による重荷';

  @override
  String get dbInheritedSource => '考えられる原因';

  @override
  String get dbCoreBlockerLabel => '根本的な障壁';

  @override
  String get dbPsychologyTitle => 'あなたのお金に対する心理';

  @override
  String get dbResilience => 'レジリエンス';

  @override
  String get dbDiscipline => 'プレッシャー下での規律';

  @override
  String get dbSocialSupport => '社会的サポート';

  @override
  String get dbDepressionRisk => '経済的ストレスへの脆弱性';

  @override
  String get dbStressTolerance => 'ストレス耐性';

  @override
  String get dbRootCause => '行動の根本原因';

  @override
  String get dbImprovementTitle => '改善プラン';

  @override
  String get dbRoadmapTitle => 'あなたの完済ロードマップ';

  @override
  String get dbRecoveryProbability => '回復の可能性';

  @override
  String get dbClearanceTimeline => '完済までのタイムライン';

  @override
  String get dbYears => '年';

  @override
  String get dbDtiHealth => '負債対収入比率の健全性';

  @override
  String get dbDtiCategory => 'DTI（負債対収入比率）カテゴリー';

  @override
  String get dbBreakEvenMonths => '収支均衡までの月数';

  @override
  String get dbIncomeAcceleration => '必要な収入の伸び';

  @override
  String get dbLayerD1 => '出生図（D1）';

  @override
  String get dbLayerD6 => '負債と敵（D6）';

  @override
  String get dbLayerD9 => 'ナヴァムシャ（D9）';

  @override
  String get dbLayerDasha => 'ダシャーのタイミング';

  @override
  String get dbLayerTransit => '現在のトランジット';

  @override
  String get dbTopicRecovery => '私の回復までのタイムライン';

  @override
  String get dbTopicNegotiate => '債権者との交渉';

  @override
  String get dbTopicBorrowing => '今借りても安全か';

  @override
  String get dbTopicCrisis => '危機への備え';

  @override
  String get dbTopicAncestral => '先祖からの負債カルマ';

  @override
  String get dbTopicTimeline => '負債を完済するのに最適な年';

  @override
  String get dbTopicPsychology => '私のお金に対する心理';

  @override
  String get dbTopicCategories => '優先すべき負債';

  @override
  String get mnSubtitle => 'AIによるヴェーダ占星術 ウェルネスレポート';

  @override
  String get mnTitle => 'メンタルとストレス';

  @override
  String get mnSnapshotHeader => 'ウェルネススナップショット';

  @override
  String get mnResilience => 'レジリエンス';

  @override
  String get mnStability => '安定性';

  @override
  String get mnEmotionalBalance => '感情バランス';

  @override
  String get mnInnerCalm => '内なる平穏';

  @override
  String get mnSelfAwareness => '自己認識';

  @override
  String get mnStatusThriving => '好調';

  @override
  String get mnStatusSteady => '安定的';

  @override
  String get mnStatusBuildingStrength => '力を蓄えている段階';

  @override
  String get mnStatusNeedsGentleCare => '優しいケアが必要';

  @override
  String get mnStatusReachOut => 'サポートを求める時期';

  @override
  String get mnChipStable => '感情的に安定';

  @override
  String get mnChipSupported => '十分なサポートあり';

  @override
  String get mnChipSelfAware => '自己認識が高い';

  @override
  String get mnChipResilient => '回復力が高い';

  @override
  String get mnChipSecureAttachment => '安定したアタッチメント';

  @override
  String get mnChipHealingReady => '癒しへの準備が整っている';

  @override
  String get mnChipMindBodyBalance => '心身のバランス';

  @override
  String get mnSupportBannerTitle => '優しいメモ';

  @override
  String get mnSupportBannerBody => 'あなたのチャートは、信頼できる友人や家族、専門家などのサポートに頼るのに良い時期であることを示しています。助けを求めることは弱さではなく、強さの証です。';

  @override
  String get mnProfileTitle => 'あなたの感情の設計図';

  @override
  String get mnStressDriver => 'ストレスの要因';

  @override
  String get mnStabilityAnchor => '安定の拠り所';

  @override
  String get mnSoulLevelKarma => '魂レベルのパターン';

  @override
  String get mnSubtleSignature => '繊細な感情のシグネチャー';

  @override
  String get mnKarakaTitle => 'あなたの心と惑星';

  @override
  String get mnKarakaSubtitle => 'どの惑星があなたの内面世界を形作っているか';

  @override
  String get mnYogasTitle => '強みと成長すべき分野';

  @override
  String get mnCurrentPhase => '現在の段階';

  @override
  String get mnCurrentStressLevel => '現在のストレスレベル';

  @override
  String get mnRecentStrain => '最近の感情的な負荷';

  @override
  String get mnStrengths => '強み';

  @override
  String get mnGrowthAreas => '成長すべき分野';

  @override
  String get mnSadeSatiStatus => 'サデ・サティの状態';

  @override
  String get mnVerificationTitle => 'チャート間で確認された内容';

  @override
  String get mnD9Confirmation => 'D9での確認';

  @override
  String get mnD30Confirmation => 'D30での確認';

  @override
  String get mnMoodPatternsTitle => '気分と不安のパターン';

  @override
  String get mnMoodPatternsSubtitle => '診断ではなく、優しい気づきのために';

  @override
  String get mnAnxietyPatterns => '不安のパターン';

  @override
  String get mnMoodPatterns => '気分の落ち込みパターン';

  @override
  String get mnPrimaryPattern => '主なパターン';

  @override
  String get mnRumination => '考えすぎる傾向';

  @override
  String get mnHypervigilance => '過剰な警戒心';

  @override
  String get mnHopelessnessVuln => '気分の落ち込みへの感受性';

  @override
  String get mnEnergyDepletion => 'エネルギー消耗の傾向';

  @override
  String get mnMotivationBaseline => '意欲の基準値';

  @override
  String get mnRegulationTitle => '感情の調整と対処法';

  @override
  String get mnEmotionalRegulation => '感情の調整力';

  @override
  String get mnSelfSoothing => '自己を落ち着かせる力';

  @override
  String get mnExpressionStyle => '感情表現のスタイル';

  @override
  String get mnRecoveryTime => '回復に要する時間';

  @override
  String get mnTriggerIntensity => 'トリガーの強さ';

  @override
  String get mnHealthyCoping => '健全な対処習慣';

  @override
  String get mnWatchFor => '優しく注意すべき点';

  @override
  String get mnSleepTitle => '睡眠と休息';

  @override
  String get mnSleepQuality => '睡眠の質';

  @override
  String get mnSleepAsRegulator => '感情調整としての睡眠';

  @override
  String get mnInsomniaTendency => '浅い眠りの傾向';

  @override
  String get mnNightmareTendency => '鮮明な夢を見る傾向';

  @override
  String get mnSleepHygienePriority => '睡眠衛生の優先度';

  @override
  String get mnBurnoutTitle => '燃え尽きとエネルギー';

  @override
  String get mnBurnoutVulnerability => '燃え尽きへの敏感さ';

  @override
  String get mnBurnoutRecovery => '燃え尽きからの回復力';

  @override
  String get mnBurnoutStage => '現在の燃え尽きの段階';

  @override
  String get mnSelfDrivingTendency => '自分を追い込む傾向';

  @override
  String get mnBurnoutTriggers => '燃え尽きのきっかけ';

  @override
  String get mnConnectionTitle => 'つながりとサポート';

  @override
  String get mnSocialSupport => '社会的サポートの質';

  @override
  String get mnLonelinessVuln => '孤独への敏感さ';

  @override
  String get mnSolitudeNeed => '一人の時間への欲求';

  @override
  String get mnSocialComfort => '社交における心地よさ';

  @override
  String get mnTraumaSensitivity => 'トラウマへの敏感さ';

  @override
  String get mnHealingReadiness => '癒しへの準備度';

  @override
  String get mnProcessingStyle => '感情処理のスタイル';

  @override
  String get mnMindBodyIntegration => '心と体の統合';

  @override
  String get mnPtsdVuln => 'トラウマ反応への敏感さ';

  @override
  String get mnSelfAwarenessTitle => '自己認識と成長';

  @override
  String get mnSelfAwarenessScore => '自己認識';

  @override
  String get mnEmotionalVocabulary => '感情の語彙力';

  @override
  String get mnTherapyReadiness => 'セラピーへの準備度';

  @override
  String get mnJournalingBenefit => 'ジャーナリングの効用';

  @override
  String get mnInnerDialogue => '内なる対話の質';

  @override
  String get mnAwarenessOfPatterns => 'パターンへの気づき';

  @override
  String get mnEscapePatternVuln => '逃避パターンへの敏感さ';

  @override
  String get mnEscapeChannels => '優しく注意すべき点';

  @override
  String get mnHealthyAlternatives => '健全な代替策';

  @override
  String get mnTherapyFitTitle => 'セラピー・サポートの適性';

  @override
  String get mnCrisisSupportRec => 'サポートに関する提案';

  @override
  String get mnSupportNetwork => 'サポートネットワークを活用しましょう';

  @override
  String get mnSelfAdvocacy => '自己主張への準備度';

  @override
  String get mnMedicationReceptivity => '服薬への受容性';

  @override
  String get mnTimelineTitle => 'ウェルネスのタイムライン';

  @override
  String get mnPeakWellnessYears => 'ウェルネスのピーク期間';

  @override
  String get mnExtraCareYears => '特に自己ケアが必要な年';

  @override
  String get mnTransformationWindows => '前向きな変容の好機';

  @override
  String get mnTherapyWindow => 'おすすめのセラピー時期';

  @override
  String get mnPracticesTitle => '日々のウェルネス習慣';

  @override
  String get mnMorningPractices => '朝の習慣';

  @override
  String get mnEveningPractices => '夜の習慣';

  @override
  String get mnBreathwork => '呼吸法';

  @override
  String get mnMovement => '運動';

  @override
  String get mnNutrition => '栄養';

  @override
  String get mnNatureExposure => '自然に触れる必要性';

  @override
  String get mnDigitalDetox => 'デジタルデトックスの必要性';

  @override
  String get mnImprovementTitle => '改善プラン';

  @override
  String get mnReliabilityTitle => '信頼性';

  @override
  String get mnLayerD1 => '出生図（D1）';

  @override
  String get mnLayerD9 => '魂のチャート（D9）';

  @override
  String get mnLayerD30 => 'D30チャート';

  @override
  String get mnLayerDasha => 'ダシャーのタイミング';

  @override
  String get mnLayerTransit => 'トランジット';

  @override
  String get mnTopicResilience => '私は感情的にどれくらい強いか？';

  @override
  String get mnTopicCoping => '私に最適な対処法は？';

  @override
  String get mnTopicSleep => '睡眠を改善するには？';

  @override
  String get mnTopicBurnout => '燃え尽きのリスクはあるか？';

  @override
  String get mnTopicTherapy => 'どのセラピースタイルが合うか？';

  @override
  String get mnTopicPractices => '日々どんな習慣が最も役立つか？';

  @override
  String get mnTopicTiming => 'ウェルネスのベストな時期は？';

  @override
  String get mnTopicSupport => '強いサポートネットワークを築くには？';

  @override
  String get lgSubtitle => 'AIによるヴェーダ占星術 法律レポート';

  @override
  String get lgTitle => '法律とトラブル';

  @override
  String get lgSnapshotHeader => '法律スナップショット';

  @override
  String get lgResilience => '法的な強靭さ';

  @override
  String get lgResolutionCapacity => '解決力';

  @override
  String get lgVictoryPotential => '勝訴の可能性';

  @override
  String get lgLegalSafety => '法的な安全性';

  @override
  String get lgNegotiationSkill => '交渉力';

  @override
  String get lgStatusExcellent => '優秀';

  @override
  String get lgStatusStrong => '強い';

  @override
  String get lgStatusModerate => '普通';

  @override
  String get lgStatusDeveloping => '発展途上';

  @override
  String get lgStatusChallenging => '課題あり';

  @override
  String get lgChipResolver => '解決に長けている';

  @override
  String get lgChipWinner => '強い勝訴の可能性';

  @override
  String get lgChipNegotiator => '生まれつきの交渉上手';

  @override
  String get lgChipDocumented => '文書管理が良好';

  @override
  String get lgChipLowRisk => '法的リスクが低い';

  @override
  String get lgChipMoralAuthority => '道徳的な権威';

  @override
  String get lgChipLegalAptitude => '法律への適性';

  @override
  String get lgProfileTitle => 'あなたの法律プロフィールとカルマ';

  @override
  String get lgPrimaryDriver => '主な原動力';

  @override
  String get lgDharmaAnchor => 'ダルマの拠り所';

  @override
  String get lgAggressionMarker => '攻撃性の指標';

  @override
  String get lgDocumentationKaraka => '文書管理の質';

  @override
  String get lgKarakaTitle => 'あなたの法律に関わる惑星';

  @override
  String get lgKarakaSubtitle => 'どの惑星があなたの法運を形作っているか';

  @override
  String get lgYogasTitle => '法律のヨーガと保護';

  @override
  String get lgCurrentPhase => '現在の段階';

  @override
  String get lgProtections => '保護要因';

  @override
  String get lgDisputePressures => '紛争のプレッシャー';

  @override
  String get lgVerificationTitle => 'チャート間で確認された内容';

  @override
  String get lgD6Litigation => 'D6訴訟チャート';

  @override
  String get lgD9Dharma => 'D9ダルマチャート';

  @override
  String get lgMoralAuthority => '道徳的な権威';

  @override
  String get lgVictoryTitle => '勝訴分析';

  @override
  String get lgAsPlaintiff => '原告として';

  @override
  String get lgAsDefendant => '被告として';

  @override
  String get lgSettlementPreference => '和解への傾向';

  @override
  String get lgDisputeCategoriesTitle => '注意すべき紛争カテゴリー';

  @override
  String get lgLowRiskCategories => '低リスクなカテゴリー';

  @override
  String get lgConflictStyleTitle => '対立のスタイルと敵対関係';

  @override
  String get lgConfrontationComfort => '対決への抵抗のなさ';

  @override
  String get lgArgumentPersuasiveness => '説得力';

  @override
  String get lgEmotionalRegulation => '感情の調整力';

  @override
  String get lgGrudgeHolding => '恨みを抱きやすい傾向';

  @override
  String get lgEnemyAnalysisLabel => '敵対関係の分析';

  @override
  String get lgVisibleEnemies => '表立った敵';

  @override
  String get lgHiddenEnemies => '隠れた敵';

  @override
  String get lgWorkplaceEnemies => '職場の敵対関係';

  @override
  String get lgFamilyEnemies => '家族間の敵対関係';

  @override
  String get lgLegalEnemies => '法律上の敵対者';

  @override
  String get lgEnemyDefeatCapacity => '敵に打ち勝つ力';

  @override
  String get lgCriminalFinancialTitle => '犯罪・金銭リスクの注意点';

  @override
  String get lgCriminalRisk => '犯罪関与のリスク';

  @override
  String get lgVictimOfCrime => '犯罪被害に遭う可能性';

  @override
  String get lgFalseAccusation => '冤罪リスク';

  @override
  String get lgImprisonmentRisk => '収監リスク';

  @override
  String get lgTaxDisputeRisk => '税務紛争リスク';

  @override
  String get lgFinancialFraudRisk => '金融詐欺リスク';

  @override
  String get lgBusinessLitigationRisk => '事業訴訟リスク';

  @override
  String get lgBankruptcyRisk => '破産リスク';

  @override
  String get lgAuditVulnerability => '税務調査への脆弱性';

  @override
  String get lgProtectionPriority => '優先すべき保護対策';

  @override
  String get lgContractsTitle => '契約と交渉';

  @override
  String get lgContractClarity => '契約の明瞭さ';

  @override
  String get lgDocumentationDiscipline => '文書管理の徹底度';

  @override
  String get lgFinePrintAwareness => '細部条項への注意力';

  @override
  String get lgSignatureCaution => '署名時の慎重さ';

  @override
  String get lgMediationReceptivity => '調停への受容性';

  @override
  String get lgNegotiationSkillFull => '交渉力';

  @override
  String get lgCompromiseWillingness => '妥協への意欲';

  @override
  String get lgFaceSavingNeeds => '面子を保つ必要性';

  @override
  String get lgMediatorHireRecommendation => '調停者を雇う提案';

  @override
  String get lgTypicalContractIssues => 'よくある契約上の問題';

  @override
  String get lgCareerFitTitle => '法律キャリアの適性';

  @override
  String get lgProfessionAffinity => '職業への親和性';

  @override
  String get lgRoleFit => '最適な役割';

  @override
  String get lgLawStudentSuccess => '法学生としての成功';

  @override
  String get lgBarExamSuccess => '司法試験の成功';

  @override
  String get lgTimelineTitle => '法律に関するタイムライン';

  @override
  String get lgNewMatterChance => '新たな案件発生の可能性（今後12ヶ月）';

  @override
  String get lgOngoingCaseOutcome => '進行中の案件の結果';

  @override
  String get lgRecommendedAction => 'おすすめの対応';

  @override
  String get lgPeakDisputeYears => '紛争が多くなる時期';

  @override
  String get lgClarityYears => '法的な見通しが明るい時期';

  @override
  String get lgAvoidancePeriods => '特に注意すべき時期';

  @override
  String get lgFavorableWindows => '解決に有利な時期';

  @override
  String get lgRisksTitle => 'リスクと脆弱性';

  @override
  String get lgChronicVulnerabilities => '慢性的な脆弱性';

  @override
  String get lgAvoidDashaPeriods => '注意すべきダシャー期間';

  @override
  String get lgPreventivePriorities => '優先すべき予防策';

  @override
  String get lgRedFlags => '警戒すべき状況';

  @override
  String get lgImprovementTitle => '改善プラン';

  @override
  String get lgReliabilityTitle => '信頼性';

  @override
  String get lgLayerD1 => '出生図（D1）';

  @override
  String get lgLayerD6 => '訴訟チャート（D6）';

  @override
  String get lgLayerD9 => 'ダルマチャート（D9）';

  @override
  String get lgLayerDasha => 'ダシャーのタイミング';

  @override
  String get lgLayerTransit => 'トランジット';

  @override
  String get lgTopicWinChance => '私の勝訴の可能性は？';

  @override
  String get lgTopicStrategy => '私に最適な法的戦略は？';

  @override
  String get lgTopicContract => '注意すべき契約リスクは？';

  @override
  String get lgTopicTiming => '紛争解決に最適なタイミングは？';

  @override
  String get lgTopicSettlement => '和解すべきか、争うべきか？';

  @override
  String get lgTopicEnemies => '私の隠れた敵は誰か？';

  @override
  String get lgTopicProtection => '法的に自分を守るには？';

  @override
  String get lgTopicCareer => '私は法律のキャリアに向いているか？';

  @override
  String get prSubtitle => 'AIによるヴェーダ占星術 不動産・資産レポート';

  @override
  String get prTitle => '不動産と資産';

  @override
  String get prSnapshotHeader => '不動産スナップショット';

  @override
  String get prAcquisitionCapacity => '取得力';

  @override
  String get prHomeOwnership => '持ち家の可能性';

  @override
  String get prWealthPotential => '資産形成の可能性';

  @override
  String get prRentalIncome => '家賃収入';

  @override
  String get prLandOwnership => '土地所有';

  @override
  String get prStatusExcellent => '優秀';

  @override
  String get prStatusStrong => '強い';

  @override
  String get prStatusModerate => '普通';

  @override
  String get prStatusDeveloping => '発展途上';

  @override
  String get prStatusChallenging => '課題あり';

  @override
  String get prChipHomeOwner => '持ち家あり';

  @override
  String get prChipWealthBuilder => '資産形成者';

  @override
  String get prChipLandOwner => '土地所有者';

  @override
  String get prChipInvestor => '不動産投資家';

  @override
  String get prChipInheritance => '相続の可能性あり';

  @override
  String get prChipVehicle => '車の所有者';

  @override
  String get prChipGlobalAsset => '海外資産への親和性';

  @override
  String get prProfileTitle => 'あなたの不動産スタイル';

  @override
  String get prHomeAesthetics => '住まいの美意識';

  @override
  String get prHomeSanctuary => '聖域としての住まい';

  @override
  String get prComfortInvestment => '快適さへの投資';

  @override
  String get prVastuPriority => 'ヴァーストゥの優先度';

  @override
  String get prNaturalElements => '自然要素';

  @override
  String get prNextActionLabel => '次のアクション';

  @override
  String get prKarakaTitle => 'あなたの不動産に関わる惑星';

  @override
  String get prKarakaSubtitle => 'どの惑星があなたの不動産運を形作っているか';

  @override
  String get prPrimaryKaraka => '主なカーラカ';

  @override
  String get prDurableAsset => '耐久資産カーラカ';

  @override
  String get prYogasTitle => '不動産のヨーガとドーシャ';

  @override
  String get prCurrentPhase => '現在の段階';

  @override
  String get prBoosters => '後押し要因';

  @override
  String get prDrains => '妨げ要因';

  @override
  String get prVerificationTitle => 'チャート間で確認された内容';

  @override
  String get prD4Property => 'D4不動産チャート';

  @override
  String get prD16Vehicle => 'D16乗物チャート';

  @override
  String get prVehicleFit => '乗物の適性';

  @override
  String get prJourneyTitle => '所有の歩みとタイムライン';

  @override
  String get prFirstHomeAge => '初めて家を持つ年齢';

  @override
  String get prFirstHomeType => '初めての住居タイプ';

  @override
  String get prMultipleHomes => '複数の住居';

  @override
  String get prNewPropertySoon => '近く新たな不動産を取得';

  @override
  String get prFirstMajorWindow => '最初の大きな好機';

  @override
  String get prBuyingWindow => '購入に適した時期';

  @override
  String get prConstructionWindow => '建築に適した時期';

  @override
  String get prNextOpportunity => '次の好機';

  @override
  String get prLifetimePropertyCount => '生涯の不動産所有数';

  @override
  String get prInheritanceTitle => '相続と家族の不動産';

  @override
  String get prMaternalInheritance => '母系からの相続';

  @override
  String get prPaternalInheritance => '父系からの相続';

  @override
  String get prAncestralProperty => '先祖代々の不動産';

  @override
  String get prFamilyDisputeRisk => '家族間の紛争リスク';

  @override
  String get prInheritanceTiming => '相続のタイミング';

  @override
  String get prInheritanceType => '相続の種類';

  @override
  String get prLandInvestTitle => '土地・投資・海外不動産';

  @override
  String get prPropertyInvestor => '不動産投資家スコア';

  @override
  String get prAppreciationLuck => '資産価値上昇運';

  @override
  String get prInvestorMindset => '投資家マインド';

  @override
  String get prLandType => '土地の種類';

  @override
  String get prRentalCount => '賃貸物件数';

  @override
  String get prMultipleLand => '複数の土地区画';

  @override
  String get prFarmEstate => '農園・不動産の可能性';

  @override
  String get prGlobalPropertyLabel => '海外不動産';

  @override
  String get prForeignProperty => '海外不動産';

  @override
  String get prNriAffinity => '在外資産への親和性';

  @override
  String get prVehiclesTitle => '乗物';

  @override
  String get prVehicleCount => '所有台数';

  @override
  String get prVehicleFirstAge => '初めて乗物を持つ年齢';

  @override
  String get prVehicleCategory => '乗物のカテゴリー';

  @override
  String get prVehicleQuality => '乗物の質';

  @override
  String get prLuxuryAffinity => '高級志向';

  @override
  String get prVehicleLossRisk => '乗物の損失・損傷リスク';

  @override
  String get prLegalRiskTitle => '法律とリスクの注意点';

  @override
  String get prBoundaryDisputes => '境界紛争';

  @override
  String get prPartitionDisputes => '分割相続の紛争';

  @override
  String get prTitleIssues => '権利書・書類の問題';

  @override
  String get prTenantConflict => '借主・貸主間の対立';

  @override
  String get prForcedSale => '強制売却のリスク';

  @override
  String get prPropertyDamage => '物件損傷のリスク';

  @override
  String get prInsurancePriority => '保険加入の優先度';

  @override
  String get prProtectionUrgency => '保護対策の緊急度';

  @override
  String get prProtectiveFactors => '保護要因';

  @override
  String get prChronicVulnerabilities => '慢性的な脆弱性';

  @override
  String get prDueDiligenceTitle => 'デューデリジェンス・チェックリスト';

  @override
  String get prPreventiveMeasures => '予防策';

  @override
  String get prImprovementTitle => '改善プラン';

  @override
  String get prReliabilityTitle => '信頼性';

  @override
  String get prLayerD1 => '出生図（D1）';

  @override
  String get prLayerD4 => '不動産チャート（D4）';

  @override
  String get prLayerD16 => '乗物チャート（D16）';

  @override
  String get prLayerDasha => 'ダシャーのタイミング';

  @override
  String get prLayerTransit => 'トランジット';

  @override
  String get prTopicBuying => '購入に最適な時期は？';

  @override
  String get prTopicInherit => '私は不動産を相続するか？';

  @override
  String get prTopicVehicle => 'いつ乗物を手に入れるか？';

  @override
  String get prTopicRental => '家賃収入の可能性は？';

  @override
  String get prTopicLand => '土地を所有する可能性は？';

  @override
  String get prTopicLegal => '注意すべき法的リスクは？';

  @override
  String get prTopicForeign => '海外不動産を持つ可能性は？';

  @override
  String get prTopicTiming => '不動産に最適なタイミングは？';

  @override
  String get edTitle => '教育と学習の分析';

  @override
  String get edSubtitle => 'AIによるヴェーダ占星術 教育レポート';

  @override
  String get edSnapshotHeader => 'あなたの教育スナップショット';

  @override
  String get edOverallStrength => '総合的な強さ';

  @override
  String get edAcademicSuccess => '学業での成功';

  @override
  String get edLearningCapacity => '学習能力';

  @override
  String get edIntellect => '知性';

  @override
  String get edMemory => '記憶力';

  @override
  String get edStatusExcellent => '優れた可能性';

  @override
  String get edStatusStrong => '強い可能性';

  @override
  String get edStatusModerate => '普通の可能性';

  @override
  String get edStatusDeveloping => '発展途上の可能性';

  @override
  String get edStatusChallenging => '困難な段階';

  @override
  String get edChipSaraswati => 'サラスヴァティ・ヨーガ';

  @override
  String get edChipGajaKesari => 'ガジャケサリ・ヨーガ';

  @override
  String get edChipBudhaAditya => 'ブダ・アディティヤ・ヨーガ';

  @override
  String get edChipResearch => '強い研究能力';

  @override
  String get edChipScholarship => '奨学金取得の可能性';

  @override
  String get edChipDoctorate => '博士号取得の可能性';

  @override
  String get edChipForeign => '海外留学のサポートあり';

  @override
  String get edChipLifelong => '生涯学習者';

  @override
  String get edLearningStyleTitle => 'あなたの学習スタイル';

  @override
  String get edSoulPlanet => '魂の惑星';

  @override
  String get edSoulHint => 'あなたの最も深い内なる原動力と人生の目的';

  @override
  String get edSubjectPlanet => '科目の惑星';

  @override
  String get edTechAtmakaraka => 'アートマカーラカ（技術的）';

  @override
  String get edTechAmatyakaraka => 'アマティヤカーラカ（技術的）';

  @override
  String get edSubjectKarakaStrength => '科目カーラカの強さ';

  @override
  String get edFoundationTitle => '教育の基盤';

  @override
  String get edHouse4 => '幼少期の学び';

  @override
  String get edHouse5 => '知性';

  @override
  String get edHouse9 => '高等教育';

  @override
  String get edPurvaPunya => '前世の功徳';

  @override
  String get edStudyPlanetsTitle => 'あなたの学習に関わる惑星';

  @override
  String get edYogasTitle => 'あなたのチャートにある教育ヨーガ';

  @override
  String get edYogaBudhaAditya => 'ブダ・アディティヤ';

  @override
  String get edYogaGajaKesari => 'ガジャケサリ';

  @override
  String get edYogaSaraswati => 'サラスヴァティ';

  @override
  String get edYogaPresent => 'あり';

  @override
  String get edYogaAbsent => 'なし';

  @override
  String get edYogaNoneNote => '古典的な教育ヨーガはありません — 成功は継続的な努力と規律によってもたらされます。';

  @override
  String get edVerificationTitle => 'チャート間での確認';

  @override
  String get edD24Learning => 'D24 — 深い学びのチャート';

  @override
  String get edD4Formal => 'D4 — 正規教育チャート';

  @override
  String get edD9Dharma => 'D9 — 学びのダルマチャート';

  @override
  String get edD60Karma => 'D60 — 前世の学びのカルマ';

  @override
  String get edSubjectsTitle => 'あなたに向いている科目';

  @override
  String get edSubjectsSubtitle => 'チャートとの親和性順';

  @override
  String get edLowAffinity => '親和性が低い科目';

  @override
  String get edDegreesTitle => '学位・レベルの可能性';

  @override
  String get edExpectedLevel => '予想されるレベル';

  @override
  String get edDegreeFormal => '正規学位';

  @override
  String get edDegreePostgrad => '大学院';

  @override
  String get edDegreeDoctorate => '博士号';

  @override
  String get edDegreeForeign => '海外教育';

  @override
  String get edTimelineTitle => '学習のタイムライン';

  @override
  String get edEarlySchooling => '幼少期の就学時期';

  @override
  String get edHigherEducation => '高等教育の時期';

  @override
  String get edPostgradResearch => '大学院・研究の時期';

  @override
  String get edPeakLearningAge => '学習のピーク年齢';

  @override
  String get edPreferencesTitle => '学習の好みとサポート';

  @override
  String get edPrefStudyMode => '学習方法';

  @override
  String get edPrefTiming => '最適な時間帯';

  @override
  String get edPrefEnvironment => '環境';

  @override
  String get edPrefLocation => '場所';

  @override
  String get edPrefForeign => '海外留学';

  @override
  String get edGuruRelationship => '師（グル）との絆';

  @override
  String get edMentorAvailability => 'メンターの有無';

  @override
  String get edPeerLearning => '仲間との学び';

  @override
  String get edAuthorityDeference => '権威への敬意';

  @override
  String get edStrengthsTitle => '強みと課題';

  @override
  String get edCognitiveGifts => '認知的な才能';

  @override
  String get edNaturalAbilities => '生まれ持った学習能力';

  @override
  String get edHiddenCapacities => '隠れた能力';

  @override
  String get edConcentration => '集中力に関する課題';

  @override
  String get edBreakRisk => '学業中断のリスク';

  @override
  String get edDisciplineConsistency => '規律の一貫性';

  @override
  String get edScholarshipLikelihood => '奨学金取得の可能性';

  @override
  String get edCareerLinkTitle => '教育 → キャリアパス';

  @override
  String get edDirectionRec => 'おすすめの方向性';

  @override
  String get edIntegrationStrategy => '統合戦略';

  @override
  String get edCareerLinkage => 'キャリアとのつながり';

  @override
  String get edAlignedSubjects => 'キャリアに合った科目';

  @override
  String get edDegreeUtility => '学位のキャリアへの活用度';

  @override
  String get edImprovementTitle => 'あなたの改善プラン';

  @override
  String get edReliabilityTitle => '予測の信頼性';

  @override
  String get edLayerD1 => '出生図（D1）';

  @override
  String get edLayerD4 => '正規教育（D4）';

  @override
  String get edLayerD9 => 'ナヴァムシャ（D9）';

  @override
  String get edLayerD24 => '深い学び（D24）';

  @override
  String get edLayerD60 => '前世の学び（D60）';

  @override
  String get edLayerAmk => '科目カーラカ';

  @override
  String get edLayerMj => '水星・木星';

  @override
  String get edLayerDasha => '惑星のタイミング';

  @override
  String get edTopicSubjects => '私に向いている科目';

  @override
  String get edTopicDegree => '学位取得の可能性';

  @override
  String get edTopicAbroad => '海外留学について';

  @override
  String get edTopicExam => '試験の成績';

  @override
  String get edTopicHabits => '学習習慣';

  @override
  String get edTopicCareerLink => '教育とキャリアのつながり';

  @override
  String get edTopicTiming => '教育に適した時期';

  @override
  String get edTopicScholarship => '奨学金取得の可能性';

  @override
  String get hwTitle => '健康とウェルネスの分析';

  @override
  String get hwSubtitle => 'AIによるヴェーダ占星術 健康・ウェルネスレポート';

  @override
  String get hwSnapshotHeader => 'あなたの健康スナップショット';

  @override
  String get hwOverallVitality => '生命力';

  @override
  String get hwImmunity => '免疫力';

  @override
  String get hwRecovery => '回復力';

  @override
  String get hwMentalWellness => '心の健康';

  @override
  String get hwStressTolerance => 'ストレス耐性';

  @override
  String get hwStatusThriving => '好調';

  @override
  String get hwStatusGood => '良好な生命力';

  @override
  String get hwStatusBalanced => 'バランスが取れている';

  @override
  String get hwStatusNeedsCare => 'ケアが必要';

  @override
  String get hwStatusNeedsAttention => '注意が必要';

  @override
  String get hwChipImmunity => '強い免疫力';

  @override
  String get hwChipRecovery => '素早い回復力';

  @override
  String get hwChipMentalBalance => 'バランスの取れた心';

  @override
  String get hwChipStressResilience => 'ストレスに強い';

  @override
  String get hwChipFertility => '妊娠力のサポート';

  @override
  String get hwChipWorkLife => '良好なワークライフバランス';

  @override
  String get hwChipLowAddiction => '依存症リスクが低い';

  @override
  String get hwConstitutionTitle => 'あなたの体質タイプ';

  @override
  String get hwConstitutionSubtitle => 'あなたのチャートから見るアーユルヴェーダ体質';

  @override
  String get hwDominantDosha => '優勢';

  @override
  String get hwSecondaryDosha => '副次的';

  @override
  String get hwPrimaryKaraka => '主な健康指標';

  @override
  String get hwStrongestSystem => '最も強い系統';

  @override
  String get hwWeakestSystem => 'サポートが必要な系統';

  @override
  String get hwBodyMapTitle => 'あなたの体の惑星マップ';

  @override
  String get hwBodyMapSubtitle => '9つの惑星、9つの身体系統';

  @override
  String get hwYogaTitle => 'あなたのチャートにある健康パターン';

  @override
  String get hwYogaSubtitle => '保護的なヨーガと疾病リスクのヨーガ';

  @override
  String get hwDiseasePressureLabel => '疾病リスク';

  @override
  String get hwAreasTitle => '注意すべき身体部位';

  @override
  String get hwAreasSubtitle => '部位別の脆弱性';

  @override
  String get hwProtectedAreas => 'しっかり守られている部位';

  @override
  String get hwCategoriesTitle => '疾病カテゴリーの注意点';

  @override
  String get hwCategoriesSubtitle => '主な健康カテゴリー別のかかりやすさ';

  @override
  String get hwLowRiskCategories => '低リスクなカテゴリー';

  @override
  String get hwMentalTitle => '心と感情の健康';

  @override
  String get hwMentalSubtitle => '感情的な回復力とサポートの必要性';

  @override
  String get hwMentalVulnerability => '感情的な敏感さ';

  @override
  String get hwEmotionalRegulation => '感情の調整力';

  @override
  String get hwSupportRec => 'サポートに関する提案';

  @override
  String get hwTendencies => '心の傾向';

  @override
  String get hwTimelineTitle => '健康のタイムライン';

  @override
  String get hwTimelineSubtitle => '好調な時期・注意すべき時期・回復期';

  @override
  String get hwPeakYears => 'ウェルネスのピーク期間';

  @override
  String get hwCautionYears => '注意すべき年';

  @override
  String get hwRecoveryWindow => '回復期';

  @override
  String get hwCheckupYears => '検診をおすすめする年';

  @override
  String get hwCurrentPhase => '現在の段階';

  @override
  String get hwLifestyleTitle => 'あなたの生活習慣ガイド';

  @override
  String get hwLifestyleSubtitle => 'あなたのチャートが示す日々の習慣';

  @override
  String get hwSleepDiscipline => '睡眠管理の影響';

  @override
  String get hwDietDiscipline => '食事管理の影響';

  @override
  String get hwExerciseNeed => '運動の必要性';

  @override
  String get hwSunlightNeed => '日光浴の必要性';

  @override
  String get hwStressSusceptibility => 'ストレスへの影響を受けやすさ';

  @override
  String get hwHydrationSensitivity => '水分補給への敏感さ';

  @override
  String get hwSocialType => '社交エネルギーのタイプ';

  @override
  String get hwHealingSpeed => '治癒の速さ';

  @override
  String get hwTreatmentResponse => '治療への反応';

  @override
  String get hwAltHealing => '代替療法への親和性';

  @override
  String get hwSpecialTitle => 'ライフステージと特別なトピック';

  @override
  String get hwSpecialSubtitle => '妊娠力、幼少期の健康、習慣、燃え尽き';

  @override
  String get hwFertility => '妊娠力の指標';

  @override
  String get hwHormonalBalance => 'ホルモンバランス';

  @override
  String get hwReproductiveStrength => '生殖器系の強さ';

  @override
  String get hwChildhoodVuln => '幼少期の健康の脆弱性';

  @override
  String get hwChildhoodStatus => '幼少期の健康';

  @override
  String get hwAddictionVuln => '依存症への脆弱性';

  @override
  String get hwAddictionRecovery => '回復力';

  @override
  String get hwBurnoutVuln => '燃え尽きへの脆弱性';

  @override
  String get hwWorkLifeBalance => 'ワークライフバランス';

  @override
  String get hwStressTriggers => 'ストレスのきっかけ';

  @override
  String get hwProtectiveFactors => '保護要因';

  @override
  String get hwChallengesTitle => '注意すべき課題';

  @override
  String get hwChallengesSubtitle => '予防ケアを重視すべき点';

  @override
  String get hwMitigation => '対処法';

  @override
  String get hwChronicAreas => '慢性的な脆弱部位';

  @override
  String get hwPreventivePriorities => '優先すべき予防策';

  @override
  String get hwImprovementTitle => 'あなたのウェルネスプラン';

  @override
  String get hwImprovementSubtitle => '実践的なステップと伝統的なレメディ';

  @override
  String get hwReliabilityTitle => '分析の信頼性';

  @override
  String get hwLayerD1 => '出生図（D1）';

  @override
  String get hwLayerD6 => '健康チャート（D6）';

  @override
  String get hwLayerD30 => '詳細健康チャート（D30）';

  @override
  String get hwLayerDasha => '惑星のタイミング';

  @override
  String get hwLayerTransit => '現在のトランジット';

  @override
  String get hwDisclaimerLabel => '医療に関する免責事項';

  @override
  String get hwTopicImmunity => '免疫力を高める';

  @override
  String get hwTopicSleep => '睡眠と休息';

  @override
  String get hwTopicStress => 'ストレスを管理する';

  @override
  String get hwTopicFertility => '妊娠に適した時期';

  @override
  String get hwTopicDiet => '食事と栄養';

  @override
  String get hwTopicTiming => '健康に関するタイミング';

  @override
  String get hwTopicMental => '心の健康';

  @override
  String get hwTopicPrevention => '予防ケアプラン';

  @override
  String get lvSubtitle => 'AIによるヴェーダ占星術 恋愛レポート';

  @override
  String get lvTitle => '恋愛と人間関係';

  @override
  String get lvLovePotential => '恋愛運';

  @override
  String get lvEmotionalAvail => '感情的な開放度';

  @override
  String get lvAttraction => '魅力度';

  @override
  String get lvCommitment => 'コミットメント';

  @override
  String get lvCommunication => 'コミュニケーション';

  @override
  String get lvFidelity => '誠実さ';

  @override
  String get lvChipLoyal => '誠実な心';

  @override
  String get lvChipOpenHeart => 'オープンな心';

  @override
  String get lvChipCommunicator => '優れたコミュニケーション力';

  @override
  String get lvChipMature => '対立への対処が上手';

  @override
  String get lvChipEmotionallyWise => '感情面で賢い';

  @override
  String get lvLoveStyle => 'あなたの恋愛スタイル';

  @override
  String get lvAttractionStyle => '魅力を感じるスタイル';

  @override
  String get lvLangGiven => 'あなたが愛を表現する方法';

  @override
  String get lvLangReceived => 'あなたが愛を感じる方法';

  @override
  String get lvLovePlanets => 'あなたの恋愛に関わる惑星';

  @override
  String get lvLoveKaraka => '恋愛';

  @override
  String get lvEmotionKaraka => '感情';

  @override
  String get lvPassionKaraka => '情熱';

  @override
  String get lvPathToLove => 'あなたの恋愛への道';

  @override
  String get lvPathSub => '恋愛結婚か、お見合い結婚か';

  @override
  String get lvLoveMarriage => '恋愛結婚';

  @override
  String get lvArrangedMarriage => 'お見合い結婚';

  @override
  String get lvParentalAccept => '親からの承認';

  @override
  String get lvInterCaste => '異なるカースト・宗教';

  @override
  String get lvIdealPartner => 'あなたの理想のパートナー';

  @override
  String get lvPersonality => '性格';

  @override
  String get lvAppearance => '外見';

  @override
  String get lvIdealTraits => '理想的な特性';

  @override
  String get lvWhatMatters => '最も大切なこと';

  @override
  String get lvDrawnTo => '惹かれるもの';

  @override
  String get lvDealbreakers => '許容できないこと';

  @override
  String get lvYourAppeal => 'あなたの魅力';

  @override
  String get lvLoveStory => 'あなたの恋愛物語';

  @override
  String get lvLoveStorySub => '関係性のパターン';

  @override
  String get lvFirstLove => '初恋';

  @override
  String get lvRelationCount => '重要な絆の数';

  @override
  String get lvDuration => '一般的な期間';

  @override
  String get lvDepth => '感情の深さ';

  @override
  String get lvDatingPattern => '交際のパターン';

  @override
  String get lvCommitIntimacy => 'コミットメントと親密さ';

  @override
  String get lvCommitReady => 'コミットメントへの準備度';

  @override
  String get lvIntimacyDrive => '親密さへの欲求';

  @override
  String get lvSensuality => '官能性';

  @override
  String get lvEmpathy => '共感力';

  @override
  String get lvCommitStyle => 'コミットメントのスタイル';

  @override
  String get lvChemistry => '相性のスタイル';

  @override
  String get lvMakesCommit => 'コミットメントを決意させるもの';

  @override
  String get lvMakesFlee => '遠ざけてしまう要因';

  @override
  String get lvEmotional => '感情的知性';

  @override
  String get lvEmotionalIQ => 'EQ（感情知能）';

  @override
  String get lvConflictStyle => '対立のスタイル';

  @override
  String get lvTiming => '恋愛のタイミング';

  @override
  String get lvNewLove12 => '12ヶ月以内の新しい恋';

  @override
  String get lvEnergyNow => '現在のエネルギー';

  @override
  String get lvPhaseNow => '現在の段階';

  @override
  String get lvPeakRomance => '恋愛運のピーク期間';

  @override
  String get lvNewLoveWindow => '新しい恋の好機';

  @override
  String get lvChallenges => '注意すべき課題';

  @override
  String get lvRiskHeartbreak => '失恋への脆弱性';

  @override
  String get lvRiskSabotage => '自己妨害';

  @override
  String get lvRiskCommitFear => 'コミットメントへの恐れ';

  @override
  String get lvRiskRepeat => '繰り返すパターン';

  @override
  String get lvRiskWorkaholic => '恋愛より仕事を優先';

  @override
  String get lvRedFlags => '注意すべき警告サイン';

  @override
  String get lvHealing => '癒すべきこと';

  @override
  String get lvFocusArea => '重点分野';

  @override
  String get lvHealDir => '癒しの方向性';

  @override
  String get lvImprovementPlan => '改善プラン';

  @override
  String get lvReliability => '予測の信頼性';

  @override
  String get lvLayerBirth => '出生図（D1）';

  @override
  String get lvLayerNavamsa => 'ナヴァムシャ（D9）';

  @override
  String get lvLayerSaptamsa => 'サプタムシャ（D7）';

  @override
  String get lvLayerDasha => 'ダシャーのタイミング';

  @override
  String get lvLayerTransit => '現在のトランジット';

  @override
  String get lvTopicWhen => 'いつ恋人が見つかるか？';

  @override
  String get lvTopicSoulmate => '私の運命の人について';

  @override
  String get lvTopicCurrent => '私の現在の関係';

  @override
  String get lvTopicHeal => '過去からの癒し';

  @override
  String get lvTopicCommit => 'コミットメントへのサポート';

  @override
  String get lvTopicLoveVsArranged => '恋愛結婚かお見合い結婚か';

  @override
  String get lvTopicHeartbreak => '失恋を避けるには';

  @override
  String get lvTopicConfidence => '恋愛における自信';

  @override
  String get mrSubtitle => 'AIによるヴェーダ占星術 結婚レポート';

  @override
  String get mrTitle => '結婚と家族';

  @override
  String get mrMarriagePotential => '結婚運';

  @override
  String get mrHarmony => '調和';

  @override
  String get mrLongevity => '持続性';

  @override
  String get mrSatisfaction => '満足度';

  @override
  String get mrStability => '家庭の安定性';

  @override
  String get mrClarity => '明瞭さ';

  @override
  String get mrChipHarmony => '調和の取れた絆';

  @override
  String get mrChipNoMangal => 'マンガル・ドーシャなし';

  @override
  String get mrChipLongLasting => '長く続く';

  @override
  String get mrChipHome => '持ち家の可能性あり';

  @override
  String get mrChipInLaws => '良好な義理の家族関係';

  @override
  String get mrChipChildren => '子宝に恵まれる';

  @override
  String get mrSpouse => 'あなたの将来の配偶者';

  @override
  String get mrSpouseSub => 'チャートが示唆すること';

  @override
  String get mrSpouseTraits => '考えられる性格';

  @override
  String get mrSpouseWork => '考えられる職業';

  @override
  String get mrAgeDiff => '年齢差';

  @override
  String get mrCulture => '文化的な一致';

  @override
  String get mrEducation => '学歴';

  @override
  String get mrFamilyBg => '家庭背景';

  @override
  String get mrSoulPartnership => '魂とパートナーシップ';

  @override
  String get mrSelfPlanet => '絆におけるあなた';

  @override
  String get mrSpousePlanet => 'あなたの配偶者惑星';

  @override
  String get mrSoulAlignment => '魂の一致';

  @override
  String get mrAlignStrong => 'あなたの魂と理想のパートナーは強く一致しています — 深く満たされる絆が期待できます。';

  @override
  String get mrAlignModerate => 'あなたの魂と理想のパートナーはほどほどに一致しています — 意識的な努力によって満たされる絆が育まれます。';

  @override
  String get mrAlignLow => 'あなたの魂とパートナーシップには意識的な統合が必要です — 内面の価値観に本当に合うパートナーを選びましょう。';

  @override
  String get mrTechDarakaraka => '配偶者惑星（ダーラカーラカ）';

  @override
  String get mrUpapada => '結婚のポイント（ウパパダ）';

  @override
  String get mrUpapadaLord => 'ウパパダ支配星';

  @override
  String get mrFoundation => '結婚の基盤';

  @override
  String get mrMarriageSign => '結婚のサイン';

  @override
  String get mrMarriageLord => '結婚の支配星';

  @override
  String get mrHouseStrength => 'ハウスの強さ';

  @override
  String get mrPartnerHint => 'チャートから読み取るパートナーのヒント';

  @override
  String get mrHarmonyHdr => '相性の調和';

  @override
  String get mrHarmonySub => 'どのようにつながるか';

  @override
  String get mrEmotional => '感情面';

  @override
  String get mrIntellectual => '知的な面';

  @override
  String get mrPhysical => '身体的な親密さ';

  @override
  String get mrFinancial => '金銭面';

  @override
  String get mrCommunication => 'コミュニケーション';

  @override
  String get mrSharedValues => '共有する価値観';

  @override
  String get mrSpiritual => '精神面';

  @override
  String get mrConflictRes => '対立の解消';

  @override
  String get mrTiming => '結婚のタイミング';

  @override
  String get mrFirstMarriageAge => '予想される結婚年齢';

  @override
  String get mrDelayChance => '遅れる可能性';

  @override
  String get mrMarriageWindow => '結婚に適した時期';

  @override
  String get mrSecondaryWindow => '代替の時期';

  @override
  String get mrCurrentReadiness => '現在の状況';

  @override
  String get mrJourney => '結婚生活の歩み';

  @override
  String get mrJourneySub => '絆がどのように発展するか';

  @override
  String get mrPhaseEarly => '初期';

  @override
  String get mrPhaseMid => '中期';

  @override
  String get mrPhaseMature => '成熟期';

  @override
  String get mrPhaseLate => '晩年';

  @override
  String get mrTip => 'アドバイス';

  @override
  String get mrFamilyHome => '家族と家庭';

  @override
  String get mrInLaws => '義理の家族との関係';

  @override
  String get mrFamilyHarmony => '家族の調和';

  @override
  String get mrHomeOwnership => '持ち家の可能性';

  @override
  String get mrDomesticPeace => '家庭の平穏';

  @override
  String get mrFertility => '妊娠力';

  @override
  String get mrParenting => '子育ての調和';

  @override
  String get mrChildren => '子供';

  @override
  String get mrLikelyCount => '予想される人数';

  @override
  String get mrVerification => 'チャート間の検証';

  @override
  String get mrD9 => '結婚チャート（D9）';

  @override
  String get mrD10 => 'キャリア・配偶者チャート（D10）';

  @override
  String get mrD60 => 'カルマチャート（D60）';

  @override
  String get mrChallenges => '注意すべき課題';

  @override
  String get mrMangalPresent => 'チャートにマンガル・ドーシャが見られます — レメディやマッチングを慎重に検討してください。';

  @override
  String get mrMangalAbsent => 'マンガル・ドーシャは検出されませんでした — 結婚に好ましい兆候です。';

  @override
  String get mrRiskConflict => '対立';

  @override
  String get mrRiskSeparation => '別離';

  @override
  String get mrRiskDistance => '感情的な距離';

  @override
  String get mrRiskInfidelity => '不貞';

  @override
  String get mrRiskFinance => '金銭面での意見の相違';

  @override
  String get mrPartnerGuide => 'パートナーガイド';

  @override
  String get mrPartnerGuideSub => '注目すべきポイント';

  @override
  String get mrSeek => '探すべき特性';

  @override
  String get mrMatchingPriorities => 'マッチングの優先事項';

  @override
  String get mrImprovementPlan => '改善プラン';

  @override
  String get mrReliability => '予測の信頼性';

  @override
  String get mrLayerBirth => '出生図（D1）';

  @override
  String get mrLayerNavamsa => 'ナヴァムシャ（D9）';

  @override
  String get mrLayerDashamsa => 'ダシャムシャ（D10）';

  @override
  String get mrLayerShashtiamsa => 'カルマ（D60）';

  @override
  String get mrLayerDarakaraka => '配偶者惑星';

  @override
  String get mrTopicWhen => 'いつ結婚するか？';

  @override
  String get mrTopicSpouse => '私の配偶者について';

  @override
  String get mrTopicCompat => '相性のヒント';

  @override
  String get mrTopicDelay => '結婚の遅れ';

  @override
  String get mrTopicMangal => 'マンガル・ドーシャ';

  @override
  String get mrTopicChildren => '子供を授かるタイミング';

  @override
  String get mrTopicInLaws => '義理の家族との関係';

  @override
  String get mrTopicHarmony => '調和を築く';

  @override
  String get wlSubtitle => 'AIによるヴェーダ占星術 金運レポート';

  @override
  String get wlTitle => '富と金融';

  @override
  String get wlWealthPotential => '金運';

  @override
  String get wlAccumulation => '資産の蓄積';

  @override
  String get wlIncomeFlow => '収入の流れ';

  @override
  String get wlRetention => '資産の保持';

  @override
  String get wlSustainability => '持続可能性';

  @override
  String get wlSavings => '貯蓄の規律';

  @override
  String get wlChipSaver => '生まれつきの貯蓄家';

  @override
  String get wlChipMultiIncome => '複数の収入源';

  @override
  String get wlChipStrongYogas => '金運のヨーガ';

  @override
  String get wlChipLowDebt => '負債が少ない';

  @override
  String get wlChipInheritance => '相続の可能性あり';

  @override
  String get wlChipInvestor => '賢い投資家';

  @override
  String get wlWealthClass => '資産クラス';

  @override
  String get wlWealthType => '主な富のタイプ';

  @override
  String get wlPrimarySource => '主な収入源';

  @override
  String get wlPeakAge => '資産形成のピーク年齢';

  @override
  String get wlBoosters => 'あなたの資産を後押しするもの';

  @override
  String get wlBoostersSub => '強力な金運の組み合わせ';

  @override
  String get wlWealthImpact => '後押し';

  @override
  String get wlDrains => '資産の消耗要因';

  @override
  String get wlIncomeSources => '収入源';

  @override
  String get wlIncomeSourcesSub => 'お金がどこから来るか';

  @override
  String get wlPrimary => '主要';

  @override
  String get wlInvestment => '投資プラン';

  @override
  String get wlInvestmentSub => '理想的な資産配分';

  @override
  String get wlRiskAppetite => 'リスク許容度';

  @override
  String get wlInvestStyle => '投資スタイル';

  @override
  String get wlDrivenBy => '動機となるもの';

  @override
  String get wlMoneyPersonality => 'お金に対する性格';

  @override
  String get wlMoneyType => 'お金のタイプ';

  @override
  String get wlSpending => '支出傾向';

  @override
  String get wlSavingsDiscipline => '貯蓄の規律';

  @override
  String get wlCharity => '慈善への意欲';

  @override
  String get wlLuxury => '贅沢への支出';

  @override
  String get wlWindfalls => '臨時収入とチャンス';

  @override
  String get wlWindfallsSub => '運によるお金';

  @override
  String get wlInheritanceChance => '相続';

  @override
  String get wlSuddenGains => '突然の利得';

  @override
  String get wlLottery => '宝くじ・投機';

  @override
  String get wlInsurance => '保険金の受取';

  @override
  String get wlWindfallSource => '考えられる臨時収入源';

  @override
  String get wlMoneyPlanets => 'あなたのお金に関わる惑星';

  @override
  String get wlPrimaryKaraka => '主なお金の惑星';

  @override
  String get wlSecondaryKaraka => '副次的なお金の惑星';

  @override
  String get wlTimeline => '金運のタイムライン';

  @override
  String get wlPeakYears => 'ピーク期間';

  @override
  String get wlGoodPeriod => '繁栄期';

  @override
  String get wlSuddenGainWindow => '突然の利得の好機';

  @override
  String get wlToughPeriod => '注意すべき時期';

  @override
  String get wlDebtRisks => '負債と金銭リスク';

  @override
  String get wlDebtChance => '負債を抱える可能性';

  @override
  String get wlLoanBurden => 'ローンの負担';

  @override
  String get wlDrainSources => '注意すべき点';

  @override
  String get wlStrengthen => '強化すべき点';

  @override
  String get wlWeakestDriver => '最も弱いお金の要因';

  @override
  String get wlHowToFix => '強化する方法';

  @override
  String get wlImprovementPlan => '改善プラン';

  @override
  String get wlReliability => '予測の信頼性';

  @override
  String get wlLayerBirth => '富のハウス（D1）';

  @override
  String get wlLayerHora => 'ホラチャート（D2）';

  @override
  String get wlLayerNavamsa => 'ナヴァムシャ（D9）';

  @override
  String get wlLayerDasha => 'ダシャーのタイミング';

  @override
  String get wlLayerTransit => '現在のトランジット';

  @override
  String get wlTopicGrow => '資産を増やす方法';

  @override
  String get wlTopicInvest => 'どこに投資すべきか';

  @override
  String get wlTopicDebt => '負債の管理';

  @override
  String get wlTopicProperty => '不動産の購入';

  @override
  String get wlTopicRetire => '退職後の計画';

  @override
  String get wlTopicPassive => '不労所得';

  @override
  String get wlTopicWindfall => '突然の利得';

  @override
  String get wlTopicTiming => 'お金に関する最適なタイミング';

  @override
  String get bzSubtitle => 'AIによるヴェーダ占星術 事業レポート';

  @override
  String get bzTitle => '事業とスタートアップ';

  @override
  String get bzBusinessPotential => '事業運';

  @override
  String get bzEntrepreneurship => '起業家精神';

  @override
  String get bzVenture => '事業の成功';

  @override
  String get bzWealth => '事業による資産形成';

  @override
  String get bzRiskAppetite => 'リスク許容度';

  @override
  String get bzLongevity => '持続性';

  @override
  String get bzChipWealthMagnet => '富を引き寄せる力';

  @override
  String get bzChipMoneyYoga => '金運のヨーガ';

  @override
  String get bzChipLeadership => 'リーダーシップ';

  @override
  String get bzChipPartnerFit => '優れたパートナー適性';

  @override
  String get bzChipGains => '強い利得';

  @override
  String get bzChipInvestor => '投資家からの魅力';

  @override
  String get bzChipFounder => '創業者マインド';

  @override
  String get bzWhatsWorking => 'あなたにとってうまくいっている点';

  @override
  String get bzWhatsWorkingSub => 'あなたの事業の才能';

  @override
  String get bzClassicYogas => '古典的な金運の組み合わせ';

  @override
  String get bzFounderType => 'あなたの創業者タイプ';

  @override
  String get bzSoulBusiness => '魂と事業の目的';

  @override
  String get bzSoulPlanet => 'あなたの魂の原動力';

  @override
  String get bzBusinessPlanet => 'あなたの事業マインド';

  @override
  String get bzDirectionStrength => '方向性の明瞭さ';

  @override
  String get bzAlignStrong => 'あなたの魂の目的と事業の方向性は強く一致しています — 事業を築くことが自然で満たされる形になるでしょう。';

  @override
  String get bzAlignModerate => 'あなたの魂の目的と事業の方向性はほどほどに一致しています — あなたの深い価値観を反映した事業が最も効果的です。';

  @override
  String get bzAlignLow => 'あなたの魂の目的と事業の方向性には意識的な一致が必要です — 本当に自分らしい事業を選びましょう。';

  @override
  String get bzTechAtmakaraka => '魂の惑星（アートマカーラカ）';

  @override
  String get bzTechAmatyakaraka => '事業惑星（アマティヤカーラカ）';

  @override
  String get bzTechDarakaraka => 'パートナー惑星（ダーラカーラカ）';

  @override
  String get bzFoundation => '事業の基盤';

  @override
  String get bzCareerHouse => 'キャリアハウス';

  @override
  String get bzGainsHouse => '利得ハウス';

  @override
  String get bzLord => '支配星';

  @override
  String get bzGainsPotential => '利得の可能性';

  @override
  String get bzNetwork => '人脈の力';

  @override
  String get bzRecovery => '回復力';

  @override
  String get bzVerification => 'チャート間の検証';

  @override
  String get bzD10 => 'キャリアチャート（D10）';

  @override
  String get bzD11 => '利得チャート（D11）';

  @override
  String get bzD9 => '目的チャート（D9）';

  @override
  String get bzD60 => 'カルマチャート（D60）';

  @override
  String get bzFounderSkills => '創業者のスキル';

  @override
  String get bzSkillStrategy => '戦略的思考';

  @override
  String get bzSkillExecution => '実行力';

  @override
  String get bzSkillPeople => '人材管理';

  @override
  String get bzSkillSales => '営業・交渉力';

  @override
  String get bzSkillFinance => '財務センス';

  @override
  String get bzSkillOps => '運営規律';

  @override
  String get bzTopSkill => '最も優れたスキル';

  @override
  String get bzDomains => '最適な事業分野';

  @override
  String get bzDomainsSub => '適性順にランク付け';

  @override
  String get bzFit => '適性';

  @override
  String get bzBusinessStyleHdr => '事業スタイル';

  @override
  String get bzStyleService => '製品か、サービスか';

  @override
  String get bzStyleMarket => '市場フォーカス';

  @override
  String get bzStyleTech => 'テクノロジーへのアプローチ';

  @override
  String get bzStyleLeadership => 'リーダーシップスタイル';

  @override
  String get bzStylePartnership => '単独か、共同経営か';

  @override
  String get bzWhereBuild => '展開範囲';

  @override
  String get bzExpansion => '拡大';

  @override
  String get bzSetup => '立ち上げ';

  @override
  String get bzPartnership => 'パートナーシップとチーム';

  @override
  String get bzIdealCofounder => '理想の共同創業者';

  @override
  String get bzPartnerViability => 'パートナーシップの適性';

  @override
  String get bzTeamBuilding => 'チーム作り';

  @override
  String get bzCofounderFit => '共同創業者との相性';

  @override
  String get bzAdvisorNetwork => 'アドバイザーネットワーク';

  @override
  String get bzFunding => '資金調達とお金';

  @override
  String get bzRecommendedPath => 'おすすめの資金調達方法';

  @override
  String get bzInvestorAttract => '投資家からの魅力';

  @override
  String get bzFamilyBacking => '家族からのサポート';

  @override
  String get bzHybridViability => '本業と副業の両立';

  @override
  String get bzFallback => '本業をバックアップに';

  @override
  String get bzDebtStyle => '負債への向き合い方';

  @override
  String get bzTimeline => '事業のタイムライン';

  @override
  String get bzCurrentPhase => '現在の状況';

  @override
  String get bzLaunchWindow => '起業に適した時期';

  @override
  String get bzScaleWindow => '成長に適した時期';

  @override
  String get bzPeakAge => 'ピーク期間';

  @override
  String get bzChallenges => '注意すべき課題';

  @override
  String get bzRiskFinancial => '金銭的損失';

  @override
  String get bzRiskBurnout => '燃え尽き';

  @override
  String get bzRiskTeam => 'チーム内の対立';

  @override
  String get bzRiskLegal => '法律・規制上の問題';

  @override
  String get bzFinancialExp => '過剰な投資や資金繰りの見誤りによって、事業で金銭的損失を被るリスクです。';

  @override
  String get bzFinancialFix => '現金の備えを維持し、まずは小さく始め、支出を拡大する前に需要を検証しましょう。';

  @override
  String get bzBurnoutExp => '長期間頑張りすぎることで、エネルギーと集中力が消耗する恐れがあります。';

  @override
  String get bzBurnoutFix => '休息を大切にし、早めに権限委譲を行い、追い込む時期は好機に合わせて調整しましょう。';

  @override
  String get bzTeamExp => '共同創業者やスタッフとの摩擦が事業の進行を遅らせる可能性があります。';

  @override
  String get bzTeamFix => '役割と期待値を書面で明確にし、頻繁にコミュニケーションを取りましょう。';

  @override
  String get bzLegalExp => 'コンプライアンス、契約、規制上の問題が障害となる可能性があります。';

  @override
  String get bzLegalFix => '契約書のレビューを受け、書類を整理しておき、早めに専門家に相談しましょう。';

  @override
  String get bzImprovementPlan => '改善プラン';

  @override
  String get bzBestDirection => '最適な方向性';

  @override
  String get bzStrategy => '構築戦略';

  @override
  String get bzTopFields => '上位の分野';

  @override
  String get bzEmploymentPath => '就職か、事業か';

  @override
  String get bzRoadmap => '成長ロードマップ';

  @override
  String get bzRoadmapSub => 'あなたの事業プラン';

  @override
  String get bzReliability => '予測の信頼性';

  @override
  String get bzLayerBirth => '出生図（D1）';

  @override
  String get bzLayerNavamsa => 'ナヴァムシャ（D9）';

  @override
  String get bzLayerDashamsa => 'キャリア（D10）';

  @override
  String get bzLayerLabhamsa => '利得（D11）';

  @override
  String get bzLayerShashtiamsa => 'カルマ（D60）';

  @override
  String get bzTopicStart => '今始めるべきか？';

  @override
  String get bzTopicIdea => '最適な事業アイデア';

  @override
  String get bzTopicPartner => '共同創業者を見つける';

  @override
  String get bzTopicFunding => '資金調達の方法';

  @override
  String get bzTopicScale => '拡大すべき時期';

  @override
  String get bzTopicRisk => 'リスク管理';

  @override
  String get bzTopicJob => '就職か事業か';

  @override
  String get bzTopicTiming => '最適なタイミング';

  @override
  String get crTitle => 'キャリアと仕事の分析';

  @override
  String get crSubtitle => 'AIによるヴェーダ占星術 キャリアレポート';

  @override
  String get crCrumbHome => 'ホーム';

  @override
  String get crCrumbReports => 'レポート';

  @override
  String get crCareerPotential => 'キャリア運';

  @override
  String get crStatusStrong => '強い可能性';

  @override
  String get crStatusGood => '良い可能性';

  @override
  String get crStatusModerate => '普通の可能性';

  @override
  String get crStatusDeveloping => '発展途上の可能性';

  @override
  String get crStatusChallenging => '困難な段階';

  @override
  String get crOverallCareer => '総合的なキャリア';

  @override
  String get crStability => 'キャリアの安定性';

  @override
  String get crGrowth => '成長の可能性';

  @override
  String get crRecognition => '評価';

  @override
  String get crSatisfaction => '満足度';

  @override
  String get crChipLeadership => 'リーダーシップ';

  @override
  String get crChipCreativity => '創造性';

  @override
  String get crChipBusiness => '事業';

  @override
  String get crChipStableIncome => '安定した収入';

  @override
  String get crChipLearning => '学び';

  @override
  String get crChipGrowth => '長期的な成長';

  @override
  String get crChipTechnical => '技術力';

  @override
  String get crChipRecognition => '評価';

  @override
  String get crTopInsights => '主な洞察';

  @override
  String get crWhatDefines => 'あなたのキャリアを特徴づけるもの';

  @override
  String get crSoulCareer => '魂とキャリアの目的';

  @override
  String get crSoulPlanet => '魂の目的を司る惑星';

  @override
  String get crCareerPlanet => 'キャリアの惑星';

  @override
  String get crMeaning => '意味';

  @override
  String get crAlignment => '魂とキャリアの一致';

  @override
  String get crAlignStrong => 'あなたの本来の興味とキャリアの方向性は強く一致しています。';

  @override
  String get crAlignModerate => 'あなたの本来の興味とキャリアの方向性はほどほどに一致しています。';

  @override
  String get crAlignLow => 'あなたの本来の興味とキャリアの方向性には意識的な調整が必要です。';

  @override
  String get crTechAtmakaraka => 'アートマカーラカ（魂の指標）';

  @override
  String get crTechAmatyakaraka => 'アマティヤカーラカ（キャリアの指標）';

  @override
  String get crDegrees => '度数';

  @override
  String get crDignity => '品位';

  @override
  String get crFoundation => 'キャリアの基盤';

  @override
  String get crCareerSign => 'キャリアサイン';

  @override
  String get crCareerLord => 'キャリア支配星';

  @override
  String get crLordPosition => '支配星の位置';

  @override
  String get crCareerStrength => 'キャリアの強さ';

  @override
  String get crProfStyle => '職業スタイル';

  @override
  String get crBestFields => '最適な分野';

  @override
  String get crTechnicalDetails => '技術的な詳細';

  @override
  String get crHouseLabel => 'ハウス';

  @override
  String get crVerification => 'チャート間でのキャリアの検証';

  @override
  String get crD10Career => 'D10・キャリア';

  @override
  String get crD9Purpose => 'D9・目的';

  @override
  String get crD60Karma => 'D60・カルマ';

  @override
  String get crStatusNeedsImprovement => '改善が必要';

  @override
  String get crStatusWellAligned => 'よく一致している';

  @override
  String get crStatusStrongSupport => '強いサポート';

  @override
  String get crStatusModerateSupport => 'ほどほどのサポート';

  @override
  String get crChartDetails => 'チャートの技術的な詳細';

  @override
  String get crPersonality => 'あなたのキャリア上の性格';

  @override
  String get crGrowthAreas => '成長すべき分野';

  @override
  String get crBestRoles => '最適な役割';

  @override
  String get crBestIndustries => '最適な業界';

  @override
  String get crEnvironment => 'キャリア環境';

  @override
  String get crWorkStyle => '最適な働き方';

  @override
  String get crEmployment => '雇用';

  @override
  String get crBusiness => '事業';

  @override
  String get crFreelance => 'フリーランス・コンサルティング';

  @override
  String get crPortfolio => '複合ポートフォリオ';

  @override
  String get crLeadership => 'リーダーシップ';

  @override
  String get crFit => '適性';

  @override
  String get crBestFit => '最適な適性';

  @override
  String get crTimeline => 'キャリアのタイムライン';

  @override
  String get crPastPeak => '過去のピーク';

  @override
  String get crPresentPhase => '現在の段階';

  @override
  String get crUpcoming => '今後の好機';

  @override
  String get crFutureExpansion => '将来の拡大';

  @override
  String get crRiskPeriod => 'リスクの時期';

  @override
  String get crViewDasha => '惑星期（技術的）';

  @override
  String get crChallenges => '注意すべき課題';

  @override
  String get crRiskBurnout => '燃え尽き';

  @override
  String get crRiskRecognition => '評価の遅れ';

  @override
  String get crRiskConflict => '職場での対立';

  @override
  String get crRiskFinancial => '経済的な不安定さ';

  @override
  String get crRiskOverqual => '力を発揮しきれない状況';

  @override
  String get crPrevention => '予防策';

  @override
  String get crBurnoutExp => '長期にわたる負荷の高い時期は、徐々にエネルギーを消耗させる可能性があります。';

  @override
  String get crBurnoutFix => '休息を大切にし、境界線を設け、大きな取り組みのペースを調整しましょう。';

  @override
  String get crRecognitionExp => '努力に対する評価や見返りが、想定より遅れて訪れることがあります。';

  @override
  String get crRecognitionFix => '成果を記録し、上司に自分の貢献を見えるようにしましょう。';

  @override
  String get crConflictExp => '同僚や上司との摩擦が時折表面化することがあります。';

  @override
  String get crConflictFix => '冷静にコミュニケーションを取り、戦うべき場面を見極めましょう。';

  @override
  String get crFinancialExp => '特定の時期には収入が不安定に感じられることがあります。';

  @override
  String get crFinancialFix => '予備資金を確保し、過度な金銭的コミットメントを避けましょう。';

  @override
  String get crOverqualExp => '力を十分に発揮できていないと感じることがあるかもしれません。';

  @override
  String get crOverqualFix => '挑戦的な役割を求め、学び続けることで意欲を保ちましょう。';

  @override
  String get crImprovementPlan => 'キャリア改善プラン';

  @override
  String get crCatPlanetary => '惑星と精神性の観点';

  @override
  String get crCatPractical => '実践的なステップ';

  @override
  String get crTraditionalExplain => '伝統的な占星術による説明';

  @override
  String get crActionPlan => '30日間キャリアアクションプラン';

  @override
  String get crWeek1 => '1週目・プロフィールの最適化';

  @override
  String get crWeek2 => '2週目・スキルの構築';

  @override
  String get crWeek3 => '3週目・ネットワーキング';

  @override
  String get crWeek4 => '4週目・キャリアの可視性';

  @override
  String get crWeek1Tip => '自分の最も強いキャリアテーマに沿って、履歴書とLinkedInを更新しましょう。';

  @override
  String get crWeek2Tip => '最適な分野で価値の高いスキルを1つ選び、毎日練習しましょう。';

  @override
  String get crWeek3Tip => 'メンターと再びつながり、業界の新しい人脈を2人つくりましょう。';

  @override
  String get crWeek4Tip => '自分の成果を公に発信し、目立つプロジェクトに志願しましょう。';

  @override
  String get crPriority => '優先度';

  @override
  String get crTimeRequired => '所要時間';

  @override
  String get crExpectedBenefit => '得られる効果';

  @override
  String get crPriorityHigh => '高';

  @override
  String get crPriorityMedium => '中';

  @override
  String get crRoadmap => 'AIキャリアロードマップ';

  @override
  String get crNext12 => '今後12ヶ月';

  @override
  String get crBestFocus => '最適な重点';

  @override
  String get crSkillsLearn => '習得すべきスキル';

  @override
  String get crIndustriesTarget => '狙うべき業界';

  @override
  String get crExpectedOutcome => '期待される成果';

  @override
  String get crReliability => '予測の信頼性';

  @override
  String get crReliabilityHigh => '高い信頼性';

  @override
  String get crReliabilityGood => '良好な信頼性';

  @override
  String get crReliabilityModerate => '中程度の信頼性';

  @override
  String get crReliabilityExplain => 'このレポートは出生図、分割図、ジャイミニ指標を組み合わせています。スコアはこれらのチャート層がどれだけ一致しているかを反映しています。';

  @override
  String get crChartLayers => 'チャート層と重み';

  @override
  String get crBirthChart => '出生図（D1）';

  @override
  String get crNavamsa => 'ナヴァムシャ（D9）';

  @override
  String get crDashamsa => 'ダシャムシャ（D10）';

  @override
  String get crShashtiamsa => 'シャシュティアムシャ（D60）';

  @override
  String get crDiscussAi => 'AIに相談する';

  @override
  String get crAskAbout => '質問する';

  @override
  String get crTopicChange => '転職';

  @override
  String get crTopicGovt => '公務員';

  @override
  String get crTopicBusiness => '事業';

  @override
  String get crTopicPromotion => '昇進';

  @override
  String get crTopicMarriage => '結婚とキャリア';

  @override
  String get crTopicAbroad => '海外';

  @override
  String get crTopicIncome => '収入';

  @override
  String get crTopicPurpose => '目的';

  @override
  String get crTopicResume => '履歴書';

  @override
  String get crTopicCopied => '質問をコピーしました — AIチャットに貼り付けてください。';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return '${soul}はあなたの内なる使命を導き、${career}はあなたの外的な職業を形作ります。';
  }

  @override
  String get rzTodayOutlook => '今日の星座運勢';

  @override
  String get rzPlanetaryEnergy => '今日の惑星エネルギー';

  @override
  String get rzBestSign => '最も良いサイン';

  @override
  String get rzChallengingSign => '最も難しいサイン';

  @override
  String get rzDominantPlanet => '優勢な惑星';

  @override
  String get rzOverallMood => '全体的な気分';

  @override
  String get rzMoodBright => '明るく活発';

  @override
  String get rzMoodCalm => '落ち着いて安定';

  @override
  String get rzMoodMixed => '混合したエネルギー';

  @override
  String get rzMoodTense => '緊張して慎重';

  @override
  String get rzTodayEnergy => '今日のエネルギー';

  @override
  String get rzCaution => '注意';

  @override
  String get rzWeak => '弱い';

  @override
  String get rzAllSigns => 'すべての星座';

  @override
  String get rzAiSummary => 'AIサマリー';

  @override
  String get rzPlanetaryInfluence => '今日の惑星の影響';

  @override
  String get rzStrongInfluences => '強い影響';

  @override
  String get rzShowTechnical => '技術的な詳細を表示';

  @override
  String get rzOpportunities => '今日のチャンス';

  @override
  String get rzAvoidTitle => '今日避けるべきこと';

  @override
  String get rzTechnicalReason => '技術的な理由';

  @override
  String get rzAvoidDecisions => '重要な決断を急ぐこと';

  @override
  String get rzAvoidArguments => '激しい口論';

  @override
  String get rzAvoidInvestments => '多額の投資';

  @override
  String get rzAvoidOverthink => '些細な問題を考えすぎること';

  @override
  String get rzAvoidOverspend => '不要な出費';

  @override
  String get rzAvoidStress => 'ストレスと働きすぎ';

  @override
  String get rzPlanetaryChart => '今日の惑星チャート';

  @override
  String get rzWhatChartMeans => 'このチャートが意味すること';

  @override
  String get rzChartExplain => 'このダイヤモンド図は、今日空にある各惑星の位置をあなたのサインに合わせて示しています。好ましいハウスにある惑星はその日を後押しし、厳しいハウスにある惑星は注意を促します。';

  @override
  String get rzDoNetworking => '人脈作りと交流';

  @override
  String get rzDoLearning => '新しいことを学ぶ';

  @override
  String get rzDoMeditation => '瞑想と落ち着き';

  @override
  String get rzDoFamily => '家族との時間';

  @override
  String get rzDoCreative => '創造的な作業';

  @override
  String get rzDoRest => '休息とセルフケア';

  @override
  String get rzAiRecommendations => '今日のAIからの提案';

  @override
  String get rzTechnical => '占星術の技術的な情報';

  @override
  String get rzTransitScore => 'トランジットスコア';

  @override
  String get rzVedha => 'ヴェダ（妨害）';

  @override
  String get rzGocharDetails => 'ゴチャール（トランジット）の詳細';

  @override
  String get rzAdvancedOnly => '上級者向け';

  @override
  String get rzTomorrow => '明日のプレビュー';

  @override
  String get rzTomorrowEnergy => '明日のエネルギー';

  @override
  String get rzImproving => '上昇傾向';

  @override
  String get rzWeaker => 'やや弱め';

  @override
  String get rzSteady => '安定';

  @override
  String get rzTomorrowUpLine => '明日はエネルギーが上昇する見込みです — 重要な作業の計画を立てておきましょう。';

  @override
  String get rzTomorrowDownLine => '明日は少しエネルギーが落ちるかもしれません — 一日を軽やかに、落ち着いて過ごしましょう。';

  @override
  String get rzTomorrowFlatLine => '明日もエネルギーは安定しています — 穏やかでバランスの取れた一日になりそうです。';

  @override
  String get rzWeeklyTrend => '週間トレンド';

  @override
  String get rzMonthlyTrend => '月間トレンド';

  @override
  String get rzBestDayWeek => '最も良い日';

  @override
  String get rzHardestDay => '最も厳しい日';

  @override
  String get rzLuckyToday => '今日のラッキー要素';

  @override
  String get rzKarakaSun => '自信と活力';

  @override
  String get rzKarakaMoon => '感情と心の平穏';

  @override
  String get rzKarakaMars => 'エネルギーと行動力';

  @override
  String get rzKarakaMercury => 'コミュニケーションと学び';

  @override
  String get rzKarakaJupiter => '知恵と成長';

  @override
  String get rzKarakaVenus => '人間関係と快適さ';

  @override
  String get rzKarakaSaturn => '規律と忍耐';

  @override
  String get rzKarakaRahu => '野心と変化';

  @override
  String get rzKarakaKetu => '精神性と手放し';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '${dom}が今日の基調を作り、${chal}は忍耐と注意を必要とします。';
  }

  @override
  String rzInsightGood(Object karaka) {
    return '${karaka}にとって良い日です。';
  }

  @override
  String rzInsightHard(Object karaka) {
    return '今日は${karaka}についてゆっくり進めましょう。';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return '今日は${karaka}が良くサポートされています。';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return '今日は${karaka}に遅れが生じるかもしれません。';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return '今日は${strong}が後押しされる一方、${weak}には忍耐と注意が必要です。';
  }

  @override
  String get fdEnergyScore => '今日のエネルギースコア';

  @override
  String get fdStatusAverage => '平均的';

  @override
  String get fdStatusMixed => '混合';

  @override
  String get fdStatusChallenging => '困難';

  @override
  String get fdTheme => '今日のテーマ';

  @override
  String get fdExplainToday => '今日を詳しく見る';

  @override
  String get fdTodaysFocus => '今日の重点';

  @override
  String get fdTopRecommendation => '主なおすすめ';

  @override
  String get fdTopCaution => '主な注意点';

  @override
  String get fdReadingTime => '読了時間';

  @override
  String get fdSeconds30 => '30秒';

  @override
  String get fdCareer => 'キャリア';

  @override
  String get fdMoney => 'お金';

  @override
  String get fdLove => '恋愛';

  @override
  String get fdHealth => '健康';

  @override
  String get fdTravel => '旅行';

  @override
  String get fdFamily => '家族';

  @override
  String get fdBestToDo => '今日やるべきこと';

  @override
  String get fdAvoidToday => '今日避けるべきこと';

  @override
  String get fdConfidenceLabel => '信頼度';

  @override
  String get fdBestTime => '最適な時間帯';

  @override
  String get fdRecommended => 'おすすめ';

  @override
  String get fdReason => '理由';

  @override
  String get fdRisk => 'リスク';

  @override
  String get fdRecommendation => 'おすすめ';

  @override
  String get fdNoActions => '今日は特に無理をする必要はありません — 落ち着いた安定したペースを保ちましょう。';

  @override
  String get fdNoCautions => '今日は特に大きな注意点はありません — 普段通りの意識で過ごしましょう。';

  @override
  String get fdHighlights => '今日のハイライト';

  @override
  String get fdProbVeryHigh => '非常に高い';

  @override
  String get fdProbHigh => '高い';

  @override
  String get fdProbElevated => 'やや高い';

  @override
  String get fdProbCaution => '注意';

  @override
  String get fdWhatToDo => 'やるべきこと';

  @override
  String get fdLifeAreas => '人生の分野';

  @override
  String get fdTapDetails => 'タップして詳細を見る';

  @override
  String get fdArea1 => '自己と健康';

  @override
  String get fdArea2 => '富と家族';

  @override
  String get fdArea3 => 'コミュニケーション';

  @override
  String get fdArea4 => '家庭と快適さ';

  @override
  String get fdArea5 => '創造性と恋愛';

  @override
  String get fdArea6 => '仕事と義務';

  @override
  String get fdArea7 => '人間関係';

  @override
  String get fdArea8 => '変化と深み';

  @override
  String get fdArea9 => '幸運と旅行';

  @override
  String get fdArea10 => 'キャリアと地位';

  @override
  String get fdArea11 => '利得と人脈';

  @override
  String get fdArea12 => '休息と精神性';

  @override
  String get fdTodaysMeaning => '今日の意味';

  @override
  String get fdGoodFor => '適していること';

  @override
  String get fdAvoid => '避けるべきこと';

  @override
  String get fdPlanetSupport => '惑星のサポート';

  @override
  String get fdWhyPrediction => 'なぜこの予測なのか？';

  @override
  String get fdAdvancedDetails => '詳細情報';

  @override
  String get fdAiRecommendation => 'AIからのおすすめ';

  @override
  String get fdOverallStatus => '全体的な状態';

  @override
  String get fdNoPlanetTransit => '今日この分野には主要な惑星のトランジットはありません。';

  @override
  String get fdFinancialOutlook => '金運の見通し';

  @override
  String get fdIncomeProbability => '収入の可能性';

  @override
  String get fdExpenseProbability => '支出の可能性';

  @override
  String get fdNetBalance => '純収支バランス';

  @override
  String get fdAvoidSpending => '支出を避ける';

  @override
  String get fdRelationshipOutlook => '人間関係の見通し';

  @override
  String get fdOverallScore => '総合スコア';

  @override
  String get fdPartner => 'パートナー';

  @override
  String get fdRomance => '恋愛';

  @override
  String get fdWorkplace => '職場';

  @override
  String get fdPublicImage => '対外的なイメージ';

  @override
  String get fdBestActivity => '最適な活動';

  @override
  String get fdWeakArea => '弱い分野';

  @override
  String get fdBiggestOpportunity => '最大のチャンス';

  @override
  String get fdBiggestRisk => '最大のリスク';

  @override
  String get fdProbability => '可能性';

  @override
  String get fdProtection => '保護に関するアドバイス';

  @override
  String get fdDescription => '説明';

  @override
  String get fdBestTimeToday => '今日の最適な時間帯';

  @override
  String get fdAvoidDuring => '避けるべき時間帯';

  @override
  String get fdPredictionConfidence => '予測の信頼度';

  @override
  String get fdConfBasis => '今日の予測は以下を組み合わせています';

  @override
  String get fdConfNatal => '出生図';

  @override
  String get fdConfTransit => '現在のトランジット';

  @override
  String get fdConfDasha => '惑星期';

  @override
  String get fdConfStrength => '惑星の強さ';

  @override
  String get fdConfHouse => 'ハウスの活性化';

  @override
  String get fdAskAi => 'AIに聞く';

  @override
  String get fdAskAiSub => '質問をタップして今日の答えを見る';

  @override
  String get fdQ1 => 'なぜ今日はキャリアが停滞しているのか？';

  @override
  String get fdQ2 => '今日の最適な時間帯は？';

  @override
  String get fdQ3 => '今日はお金の面で良い日か？';

  @override
  String get fdQ4 => '今日は旅行に適しているか？';

  @override
  String get fdQ5 => '今日避けるべきことは？';

  @override
  String get fdMoreSuggestions => '他の提案';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return '今日は${top}に最も適しています。${weak}は停滞気味なので、その分野での大きな決断は避けましょう。金銭面では今日は${fin}な見通しです。';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return '今日のエネルギーは${top}に集まっています — そこに力を注ぎ、他の分野は穏やかに過ごしましょう。';
  }

  @override
  String get gochToday => '今日';

  @override
  String get gochOverallScore => '総合トランジットスコア';

  @override
  String get gochNeutral => '中立';

  @override
  String get gochChallenging => '困難';

  @override
  String get gochTopPositive => '主なポジティブ要素';

  @override
  String get gochTopChallenges => '主な課題';

  @override
  String get gochFilterAll => 'すべて';

  @override
  String get gochFavorability => '好意度';

  @override
  String get gochAlerts => 'トランジットアラート';

  @override
  String get gochAlertCritical => '重大';

  @override
  String get gochAlertWarning => '注意';

  @override
  String get gochAlertOpportunity => 'チャンス';

  @override
  String get gochAiFocus => '今日のAIフォーカス';

  @override
  String get gochLifeScores => '人生分野別スコア';

  @override
  String get gochWhy => '理由は？';

  @override
  String get gochCurrentTransits => '現在のトランジット';

  @override
  String get gochDailyPlan => 'あなたの一日のプラン';

  @override
  String get gochMorning => '朝';

  @override
  String get gochAfternoon => '午後';

  @override
  String get gochEvening => '夕方';

  @override
  String get gochNight => '夜';

  @override
  String get gochSmartReco => '賢いおすすめ';

  @override
  String get gochExplain => '今日のトランジットを解説';

  @override
  String get gochDo => 'すべきこと';

  @override
  String get gochDont => '避けるべきこと';

  @override
  String get gochDoWork => '重要な仕事に取り組む';

  @override
  String get gochDoMeditate => '瞑想して内省する';

  @override
  String get gochDoStart => '新しい計画を始める';

  @override
  String get gochDoFinish => '保留中のタスクを終わらせる';

  @override
  String get gochDontArgue => '口論を避ける';

  @override
  String get gochDontImpulsive => '衝動的な決断を避ける';

  @override
  String get gochDontOverspend => '使いすぎを避ける';

  @override
  String gochThemeGrowth(Object area) {
    return '${area}が成長する一日です — 積極的に取り組みましょう。';
  }

  @override
  String gochThemeChallenge(Object area) {
    return '今日は${area}に対して忍耐強く、落ち着いて過ごしましょう。';
  }

  @override
  String gochPosLine(Object area) {
    return '現在${area}は良くサポートされています。';
  }

  @override
  String gochChalLine(Object area) {
    return '今日は${area}に特別な注意が必要です。';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return '今日は${a1}にエネルギーを注ぎ、${a2}には優しく接しましょう。';
  }

  @override
  String get divBeginner => '初級';

  @override
  String get divSearchHint => '検索：キャリア、結婚、教育…';

  @override
  String get divSummaryTitle => '分割図のサマリー';

  @override
  String get divTotalCharts => 'チャート総数';

  @override
  String get divMostImportant => '最も重要';

  @override
  String get divRecommendedForYou => 'あなたへのおすすめ';

  @override
  String get divCatEssential => '基本のチャート';

  @override
  String get divCatPersonal => '私生活';

  @override
  String get divCatKnowledge => '知識のチャート';

  @override
  String get divCatAdvanced => '上級チャート';

  @override
  String get divGoalProperty => '不動産';

  @override
  String get divGoalKarma => 'カルマ';

  @override
  String get divBadgeHighlyRec => '特におすすめ';

  @override
  String get divBadgeRec => 'おすすめ';

  @override
  String get divBadgeUseful => '役立つ';

  @override
  String get divBadgeOptional => '任意';

  @override
  String get divBadgeAdvOnly => '上級者向けのみ';

  @override
  String get divRecommendBest => '最適なチャートをおすすめ';

  @override
  String get divNoMatch => '検索に一致するチャートがありません';

  @override
  String get divLifeAreas => '人生の分野';

  @override
  String divAiUse(Object purpose) {
    return 'このチャートを使って${purpose}を分析しましょう。';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return 'あなたの${c1}と${c2}のチャートは特に重要です — まずこれらが扱う分野から始め、必要に応じて他も探索しましょう。';
  }

  @override
  String divRecReasonHouse(Object house) {
    return 'あなたの${house}ハウスは詳しく見る価値があります — このチャートはそれを深く示しています。';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '${planet}は重要でありながら試練を抱える惑星です — このチャートはその深い状態を明らかにします。';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return 'あなたは現在${planet}のマハダシャー期にあるため、このチャートが特に今の時期にふさわしいです。';
  }

  @override
  String divRecSummary(Object c1) {
    return 'あなたのチャートに基づくと、${c1}を最優先すべきです。以下のチャートは、今のあなたにとっての関連度順に並んでいます。';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return '${purpose}について調べたいときに、このチャートを開いてください。';
  }

  @override
  String get yogaHelpful => '有益';

  @override
  String get yogaInactive => '非活性';

  @override
  String get yogaTabMoney => 'お金';

  @override
  String get yogaTabRare => '稀少';

  @override
  String get yogaSummaryTitle => 'ヨーガのサマリー';

  @override
  String get yogaActiveYogas => '活性化しているヨーガ';

  @override
  String get yogaTotalYogas => 'ヨーガの総数';

  @override
  String get yogaMostPowerful => '最も強力';

  @override
  String get yogaFortuneRating => '総合的な幸運度';

  @override
  String get yogaBenefits => '恩恵';

  @override
  String get yogaSupportingPlanets => '関連する惑星';

  @override
  String get yogaRanking => '最も強い上位5つのヨーガ';

  @override
  String get yogaExplain => '私のヨーガを解説';

  @override
  String get yogaExplainSubtitle => 'あなたのヨーガがどのように役立つか';

  @override
  String get yogaNoneActive => '現在活性化しているヨーガはありません';

  @override
  String get yogaNoneInCategory => 'このカテゴリーにヨーガはありません';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return 'あなたのチャートには${count}個の活性化したヨーガ（有益な惑星の組み合わせ）があります。${planets}を含む組み合わせは、成長と成功に特に役立つ影響をもたらします。';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '${name}は${areas}をサポートし、その恩恵はダシャーやトランジットで関連惑星が活性化するときに大きくなります。';
  }

  @override
  String get yogaAiGeneric => 'このヨーガはあなたのチャートにおける有益な組み合わせで、関連する人生の分野を強化します。';

  @override
  String get yogaExplainReassure => 'ヨーガはあなたのチャートの明るい要素であり、あなたに味方する有益な惑星の組み合わせです。強いものほど持続的な恩恵をもたらし、特にそれを形成する惑星の期間中に効果を発揮します。';

  @override
  String get doshSevere => '深刻';

  @override
  String get doshVeryMild => '非常に軽微';

  @override
  String get doshLow => '低い';

  @override
  String get doshHigh => '高い';

  @override
  String get doshCritical => '危険';

  @override
  String get doshSummaryTitle => 'ドーシャのサマリー';

  @override
  String get doshActiveDoshas => '活性化しているドーシャ';

  @override
  String get doshTotalChecked => '確認した総数';

  @override
  String get doshOverallSeverity => '全体的な深刻度';

  @override
  String get doshNoneActive => '活性化しているドーシャはありません — クリーンなチャートです！';

  @override
  String get doshCategory => 'カテゴリー';

  @override
  String get doshConfidence => '確度';

  @override
  String get doshWhyFormed => '形成された理由';

  @override
  String get doshAffectedAreas => '影響を受ける分野';

  @override
  String get doshTimeline => 'タイムライン';

  @override
  String get doshDefinition => '定義';

  @override
  String get doshFormationRule => '形成ルール';

  @override
  String get doshSupportingPlanets => '関連惑星';

  @override
  String get doshCancellation => '相殺のヨーガ';

  @override
  String get doshNoCancellation => '見つかりませんでした';

  @override
  String get doshAreaChildren => '子供';

  @override
  String get doshAreaMind => '心';

  @override
  String get remMantra => 'マントラ';

  @override
  String get remGemstone => '宝石';

  @override
  String get remDonation => '寄付';

  @override
  String get remTemple => '寺院参拝';

  @override
  String get remFasting => '断食';

  @override
  String get remLifestyle => '生活習慣';

  @override
  String get remLifestyleGeneric => 'この惑星に関連する感謝の心、規律、慈善を実践し、良い行いを心がけましょう。';

  @override
  String get doshExplain => '私のドーシャを解説';

  @override
  String get doshExplainSubtitle => 'あなたのドーシャを落ち着いて実践的に見る';

  @override
  String get doshExplainReassure => 'ドーシャは一般的なもので、ほぼすべてのチャートに何らかの形で存在します。これらは固定された運命ではなく、傾向を表しています。気づき、良い行い、簡単なレメディによって実際の影響は軽減されるため、心配する必要はありません。';

  @override
  String get doshAiGeneric => 'このドーシャはあなたのチャートにおける傾向を表しています。実際の影響は通常軽微で、気づきと簡単なレメディでバランスを取ることができます。';

  @override
  String doshHeroSummary(Object active, Object total) {
    return 'あなたのチャートには、確認した${total}個のうち${active}個の活性化したドーシャが見られます。ほとんどは軽微で、注意が必要なものはわずかです。理解と簡単なレメディにより、その実際の影響を和らげることができます。';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return 'このドーシャは主に${areas}に影響します。${planet}の期間中はその影響が強まることがあり、レメディがバランスを取るのに役立ちます。';
  }

  @override
  String doshTimelineLine(Object planet) {
    return 'その影響は${planet}のマハダシャーとアンタルダシャーの期間、およびトランジットで${planet}が活性化しているときに最も強く感じられます。';
  }

  @override
  String get sbLegendary => '伝説的';

  @override
  String get sbSthana => 'スターナ・バラ';

  @override
  String get sbDig => 'ディグ・バラ';

  @override
  String get sbKala => 'カーラ・バラ';

  @override
  String get sbChesta => 'チェーシュタ・バラ';

  @override
  String get sbNaisargika => 'ナイサルギカ・バラ';

  @override
  String get sbDrik => 'ドリク・バラ';

  @override
  String get sbSummary => '惑星の強さのサマリー';

  @override
  String get sbAverageStrength => '平均的な強さ';

  @override
  String get sbHighestRupa => '最高ルーパ';

  @override
  String get sbRupa => 'ルーパ';

  @override
  String get sbRanking => '惑星のランキング';

  @override
  String get sbRequired => '必要値';

  @override
  String get sbExcess => '超過';

  @override
  String get sbDeficit => '不足';

  @override
  String get sbTotalShadbala => 'シャドバラ総合値';

  @override
  String get sbExplain => '私の惑星の強さを解説';

  @override
  String get sbExplainSubtitle => 'あなたの惑星の強さの簡単なまとめ';

  @override
  String get sbInfoTitle => 'シャドバラを理解する';

  @override
  String get sbQWhatIs => 'シャドバラとは？';

  @override
  String get sbQRupas => 'ルーパとは？';

  @override
  String get sbQHowCalc => '強さはどのように計算されるか？';

  @override
  String get sbQHowUse => 'これをどう活用するか';

  @override
  String get sbWhyStrong => '強い理由';

  @override
  String get sbWhyWeak => '弱い理由';

  @override
  String get sbDuringMahadasha => 'マハダシャー期間中';

  @override
  String get sbEffects => '影響';

  @override
  String get sbLifeAreas => '人生の分野';

  @override
  String get sbPlanetDetails => '惑星の詳細';

  @override
  String get sbBodyWhatIs => 'シャドバラ（「6つの強さ」）は、6つの独立した強さの源を合算することで、各惑星がその効果をもたらす力をどれだけ持っているかを測定します。';

  @override
  String get sbBodyRupas => '強さはルーパ（1ルーパ＝60ヴィルーパ）で測定されます。各惑星は強いとみなされるために最低限のルーパ値が必要で、ルーパが多いほどその効果をより十分に発揮します。';

  @override
  String get sbBodyHowCalc => 'スターナ（位置的）、ディグ（方角的）、カーラ（時間的）、チェーシュタ（運動的）、ナイサルギカ（自然的）、ドリク（アスペクト的）の6つのバラを合算します。合計をその惑星の必要最低値と比較してパーセンテージを算出します。';

  @override
  String get sbBodyHowUse => '100%を超える惑星はその意味するものを十分に発揮し、100%未満の惑星はサポートが必要です。重要な事柄には最も強い惑星を活用し、最も弱い惑星にはレメディと忍耐を与えましょう。';

  @override
  String get sbRemedyStrong => '十分にサポートされています — 特別なレメディは不要で、この惑星の期間を自信を持って活用できます。';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '${strongP}はあなたの最も強い惑星で、${strongTrait}を大きくサポートしています。${weakP}は最も弱く、レメディが最も効果的です。';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '${planet}のシャドバラは${category}であり、その${karakatva}はそれに応じてサポートされています。';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return '${bala}（${rupa}ルーパ）を通じて最も強くなっています。';
  }

  @override
  String sbWeakLine(Object bala) {
    return '${bala}が最も弱く、合計値を下げています。';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return '${planet}のマハダシャー期間中は、その${karak}が前面に出てきます。';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'シャドバラが強いため、${karak}は自然にサポートされています。';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'シャドバラが控えめなため、${karak}には意識的な努力が必要かもしれません。';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return 'マントラ、宝石、慈善を通じて${planet}を強化し、その期間中は忍耐強く行動しましょう。';
  }

  @override
  String get bhOverview => '概要';

  @override
  String get bhDetailed => '詳細';

  @override
  String get bhavaHouses => 'ハウス';

  @override
  String get bhStrengthOverview => 'ハウスの強さの概要';

  @override
  String get bhOverallAverage => '全ハウス平均';

  @override
  String get bhStrongestHouse => '最も強いハウス';

  @override
  String get bhWeakestHouse => '最も弱いハウス';

  @override
  String get bhBestArea => '最も良い人生の分野';

  @override
  String get bhNeedsAttention => '注意が必要';

  @override
  String get bhSavContribution => 'SAV貢献度';

  @override
  String get bhLordCondition => 'ハウス支配星の状態';

  @override
  String get bhBenefic => '吉星の影響';

  @override
  String get bhMalefic => '凶星の影響';

  @override
  String get bhStrengthReasons => 'このスコアの理由';

  @override
  String get bhGoodEffects => '良い効果';

  @override
  String get bhChallenges => '課題';

  @override
  String get bhRemedies => 'レメディ';

  @override
  String get bhRanking => 'ハウスのランキング';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => '私のハウスを解説';

  @override
  String get bhExplainSubtitle => 'あなたの12ハウスの簡単なまとめ';

  @override
  String bhHeroSummary(Object s1, Object s2, Object strongArea, Object weakArea) {
    return 'あなたの最も強いハウスは${s1}と${s2}です。${strongArea}は自然に強く、${weakArea}にはより多くの努力が必要です。';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'その支配星${lord}は${relation}として配置されています。';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'このハウスには${sav}点の吉点（SAV）があり、在住惑星とアスペクトが残りのスコアを形作っています。';
  }

  @override
  String bhGoodLine(Object meaning) {
    return '強いとき、これは${meaning}をサポートします。';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return '弱いとき、${meaning}にはより多くの努力とケアが必要かもしれません。';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'その支配星${lord}を強化し、このハウスに関わる事柄を大切にすることで改善しましょう。';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'あなたの${house}は${strengthWord}です。これは${meaning}を司ります。';
  }

  @override
  String get kunNavamsa => 'ナヴァムシャ（D9）';

  @override
  String get kunD10 => 'ダシャムシャ（D10）';

  @override
  String get kunPlacement => '惑星の配置';

  @override
  String get kunHousesTitle => 'ハウスの詳細';

  @override
  String get kunPlanet => '惑星';

  @override
  String get kunNakshatra => 'ナクシャトラ';

  @override
  String get kunPada => 'パダ';

  @override
  String get kunLord => '支配星';

  @override
  String get kunExplain => '私のチャートを解説';

  @override
  String get kunExplainSubtitle => 'あなたのチャートの簡単なまとめ';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return '${ordinal}ハウスは${meaning}を司ります。';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return 'ここに配置された${planets}がその結果を形作ります。';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'あなたのアセンダントは${asc}で、あなたの物事の見方や他人からの第一印象を形作ります。';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'あなたの心と感情は${moon}にある月に従います。';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '${planet}はあなたの最も強い惑星です — 自然に楽で支えとなる分野です。';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '${planet}はあなたの最も試練の多い惑星です — ここでは忍耐と努力が報われます。';
  }

  @override
  String get plNature => '性質';

  @override
  String get plElement => '元素';

  @override
  String get plGender => '性';

  @override
  String get plKarakatva => 'カーラカトヴァ（示唆する事柄）';

  @override
  String get plLordship => '支配権';

  @override
  String get plStrength => '強さ';

  @override
  String get plAspectsGiven => '与えるアスペクト';

  @override
  String get plAspectsReceived => '受けるアスペクト';

  @override
  String get plConjunction => '合（コンジャンクション）';

  @override
  String get plHouseMeaning => 'ハウスの意味';

  @override
  String get plNakshatraMeaning => 'ナクシャトラの意味';

  @override
  String get plAiInterpretation => 'AIによる解釈';

  @override
  String get plSearchHint => '惑星を検索';

  @override
  String get plNoResults => '惑星が見つかりません';

  @override
  String get plBenefic => '吉星';

  @override
  String get plMalefic => '凶星';

  @override
  String get plMale => '男性';

  @override
  String get plFemale => '女性';

  @override
  String get plNeutralGender => '中性';

  @override
  String get plOwnSign => '自室（オウンサイン）';

  @override
  String get plFriend => '友好サイン';

  @override
  String get plEnemy => '敵対サイン';

  @override
  String get plNeutral => '中立';

  @override
  String get sumEther => 'エーテル（空）';

  @override
  String plLordOfHouses(Object houses) {
    return '${houses}ハウスの支配星';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return '${nakLord}に支配され、${trait}をもたらします。';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '${planet}は${sign}に位置し、${house}ハウスにあります。';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'その核心的な示唆事項である${karak}は、ここでよくサポートされています。';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'その核心的な示唆事項である${karak}には、ここで意識的な努力が必要かもしれません。';
  }

  @override
  String plAiExalted(Object planet) {
    return '${planet}は高揚しており、最高の結果をもたらします。';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '${planet}は減衰しており、結果を発揮するにはサポートが必要です。';
  }

  @override
  String plAiCombust(Object planet) {
    return '${planet}は combust（コンバスト）状態にあり、太陽の輝きの下でその働きが抑えられます。';
  }

  @override
  String plAiVargottama(Object planet) {
    return '${planet}はヴァルゴッタマ（同一サイン反復）で、強い配置がナヴァムシャでも繰り返されています。';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '${planet}は逆行しており、そのエネルギーを内側に向けて強めています。';
  }

  @override
  String get plHouse1 => '自己、身体、人格、活力';

  @override
  String get plHouse2 => '富、家族、言葉、食事';

  @override
  String get plHouse3 => '勇気、兄弟姉妹、コミュニケーション、近距離の旅';

  @override
  String get plHouse4 => '家庭、母親、快適さ、不動産、心の平穏';

  @override
  String get plHouse5 => '子供、創造性、知性、恋愛、過去の功徳';

  @override
  String get plHouse6 => '健康、敵、負債、奉仕、日々の仕事';

  @override
  String get plHouse7 => '結婚、パートナーシップ、事業関係';

  @override
  String get plHouse8 => '寿命、変容、秘密、相続';

  @override
  String get plHouse9 => '幸運、ダルマ、高等教育、師（グル）、父親';

  @override
  String get plHouse10 => 'キャリア、地位、権威、対外的なカルマ';

  @override
  String get plHouse11 => '利得、収入、友人、人脈、願望の成就';

  @override
  String get plHouse12 => '損失、支出、海外、精神性、解脱';

  @override
  String get sumVeryStrong => '非常に強い';

  @override
  String get sumStrong => '強い';

  @override
  String get sumAverage => '平均的';

  @override
  String get sumWeak => '弱い';

  @override
  String get sumNeedsAttention => '注意が必要';

  @override
  String get sumFire => '火';

  @override
  String get sumEarth => '地';

  @override
  String get sumAir => '風';

  @override
  String get sumWater => '水';

  @override
  String get sumMovable => '活動宮';

  @override
  String get sumFixed => '不動宮';

  @override
  String get sumDual => '柔軟宮';

  @override
  String get sumDirEast => '東';

  @override
  String get sumDirWest => '西';

  @override
  String get sumDirNorth => '北';

  @override
  String get sumDirSouth => '南';

  @override
  String get sumDirNE => '北東';

  @override
  String get sumDirNW => '北西';

  @override
  String get sumDirSE => '南東';

  @override
  String get sumDirSW => '南西';

  @override
  String get sumSnapshotTitle => 'あなたの占星術スナップショット';

  @override
  String get sumMahadasha => 'マハダシャー';

  @override
  String get sumAntardasha => 'アンタルダシャー';

  @override
  String get sumNakshatra => '生誕ナクシャトラ';

  @override
  String get sumElement => '元素';

  @override
  String get sumModality => '宮の性質';

  @override
  String get sumLuckyDirection => '幸運の方角';

  @override
  String get sumHighlights => '重要なハイライト';

  @override
  String get sumStrongPlanet => '最も強い惑星';

  @override
  String get sumWeakPlanet => '最も弱い惑星';

  @override
  String get sumYogas => 'ヨーガ';

  @override
  String get sumDoshas => 'ドーシャ';

  @override
  String get sumRetrograde => '逆行';

  @override
  String get sumCombust => 'コンバスト（燃焼）';

  @override
  String get sumExalted => '高揚';

  @override
  String get sumDebilitated => '減衰';

  @override
  String get sumVargottama => 'ヴァルゴッタマ';

  @override
  String get sumQuickInsights => '簡単な洞察';

  @override
  String get sumSpirituality => '精神性';

  @override
  String get sumTimezone => 'タイムゾーン';

  @override
  String get sumAyanamsa => 'アヤナムシャ';

  @override
  String get sumCalendarType => '暦';

  @override
  String get sumCopied => 'クリップボードにコピーしました';

  @override
  String get sumNatureFire => 'あなたは大胆で活力に満ち、先陣を切って進む開拓者的な性質を持っています。';

  @override
  String get sumNatureEarth => 'あなたは実践的で地に足のついた、規律ある性質を持ち、持続的な成果を築きます。';

  @override
  String get sumNatureAir => 'あなたは好奇心旺盛でコミュニケーション能力が高く、知的で、新しいアイデアを好む性質を持っています。';

  @override
  String get sumNatureWater => 'あなたは直感的で感情豊か、共感力に富み、深い内なる繊細さを持っています。';

  @override
  String get sumGradePhraseExcellent => '強くサポートされています — 着実な努力により好ましい結果が期待できます。';

  @override
  String get sumGradePhraseGood => '十分にサポートされています — 少しの配慮で概ね良好な結果が得られます。';

  @override
  String get sumGradePhraseAverage => '混在したサポート状況です — 結果は努力とタイミング次第です。';

  @override
  String get sumGradePhraseWeak => '注意が必要です — 忍耐とレメディがここで役立ちます。';

  @override
  String get kDefCombust => '太陽に近すぎる惑星で、そのエネルギーが「燃やされて」弱まっている状態です。';

  @override
  String get kDefRetrograde => '後退しているように見える惑星で、その影響は内向きになり強まります。';

  @override
  String get kDefNakshatra => '月や惑星が通過する27の月宿（ナクシャトラ）の一つです。';

  @override
  String get kDefVargottama => '出生図（D1）とナヴァムシャ（D9）の両方で同じサインにある惑星 — 強さの証です。';

  @override
  String get kDefOwnSign => '惑星が自らが支配するサインにあり、居心地よく安定した結果をもたらす状態です。';

  @override
  String get kDefExalted => '惑星が最も強い力を発揮するサインにあり、最高の結果をもたらす状態です。';

  @override
  String get kDefDebilitated => '惑星が最も弱いサインにあり、結果を出すのに苦労する状態です。';

  @override
  String get kDefMooltrikona => '惑星が自室の中でも特に強力な力を発揮する特別な区分です。';

  @override
  String get kDefAscendant => '生まれた瞬間に東の地平線に昇っていたサイン — ラグナ、チャートの基盤です。';

  @override
  String get kDefMahadasha => '人生の長い期間に色を与える主要な惑星期です。';

  @override
  String get kDefAntardasha => 'マハダシャーの中の副次期間で、その結果を細かく調整します。';

  @override
  String get kDefPada => '惑星が位置するナクシャトラの4つの区分の一つです。';

  @override
  String get aspGivesAspectTo => 'アスペクトを与える先';

  @override
  String get aspReceivesAspectFrom => 'アスペクトを受ける元';

  @override
  String get aspInfluences => '影響を与える';

  @override
  String get aspNoInfluence => '影響なし';

  @override
  String get aspNoAspect => 'アスペクトなし';

  @override
  String get aspPresent => 'あり';

  @override
  String get aspAbsent => 'なし';

  @override
  String get aspNotPresent => '存在しない';

  @override
  String get aspSpecialAspect => '特別アスペクト';

  @override
  String get aspAspectWord => 'アスペクト';

  @override
  String get aspTotalGiven => '与えるアスペクトの総数';

  @override
  String get aspTotalReceived => '受けるアスペクトの総数';

  @override
  String get aspStrongestInfluence => '最も強い影響';

  @override
  String get aspMedium => '中程度';

  @override
  String get aspAspectPresent => 'アスペクトあり';

  @override
  String get aspReason => '理由';

  @override
  String get aspBoth => '両方';

  @override
  String get aspTargetHouse => '対象ハウス';

  @override
  String get aspTargetSign => '対象サイン';

  @override
  String get aspLagnaReceives => 'ラグナがアスペクトを受ける元';

  @override
  String get aspNoAspectFrom => 'アスペクトを受けていない';

  @override
  String get aspPlanetToPlanet => '惑星から惑星へ';

  @override
  String get aspSignToSign => 'サインからサインへ';

  @override
  String get aspCombinedAspect => '複合アスペクト';

  @override
  String get aspGrahaAspect => 'グラハ・ドリシュティ（惑星アスペクト）';

  @override
  String get aspRashiAspect => 'ラーシ・ドリシュティ（サインアスペクト）';

  @override
  String get aspInfoTitle => 'アスペクト（ドリシュティ）を理解する';

  @override
  String get aspQGraha => 'グラハ・ドリシュティとは？';

  @override
  String get aspQRashi => 'ラーシ・ドリシュティとは？';

  @override
  String get aspQDiff => '両者の違い';

  @override
  String get aspQPredict => 'アスペクトが予測に与える影響';

  @override
  String get aspGrahaBody => 'グラハ・ドリシュティとは、惑星がその位置から投げかけるアスペクトです。すべての惑星は自身から数えて7ハウス目・7番目の惑星に完全なアスペクトを与えます（直接的で正面からの影響）。さらに、火星は4ハウス目と8ハウス目、木星は5ハウス目と9ハウス目、土星は3ハウス目と10ハウス目にもアスペクトを与えます。ラーフとケートゥは通常5・7・9ハウス目に与えるとされます。惑星のアスペクトは、その及ぶ惑星やハウスにその惑星自身の性質の色を与えます。';

  @override
  String get aspRashiBody => 'ラーシ・ドリシュティは、ジャイミニ占星術によるサイン同士のアスペクトで、そこにどの惑星があるかとは関係ありません。活動宮は不動宮に（隣接するものを除く）、不動宮は活動宮に（隣接するものを除く）、そして柔軟宮は他の柔軟宮にアスペクトを与えます。主にジャイミニ予測やハウス間の関係を判断するのに使われます。';

  @override
  String get aspDiffBody => 'グラハ・ドリシュティは惑星によって投げかけられ、その惑星がどこにあるかに依存します。ラーシ・ドリシュティはサインそのものに属し、そこに配置されているものすべてに適用されます。グラハ・ドリシュティは方向性があります（惑星Aが惑星Bを見る）が、ラーシ・ドリシュティは通常サイン同士で相互的です。両方が同じ対象を指すとき、その影響は特に強くなります。';

  @override
  String get aspPredictBody => 'アスペクトは、惑星が自身のハウスを超えてどこに影響を及ぼすかを示します。吉星のアスペクト（木星、金星、良く配置された月・水星）は対象をサポートし守りますが、凶星のアスペクト（土星、火星、太陽、ラーフ、ケートゥ）は圧力や遅延、試練をもたらすことがあります。どの惑星がハウスや惑星にアスペクトしているかを読むことで、結果がなぜそのように現れるのかが説明できます。';

  @override
  String get aspTraitSun => '権威、リーダーシップ、活力';

  @override
  String get aspTraitMoon => '感情の深み、快適さ、直感';

  @override
  String get aspTraitMars => 'エネルギー、勇気、行動力';

  @override
  String get aspTraitMercury => 'コミュニケーション、知性、適応力';

  @override
  String get aspTraitJupiter => '知恵、成長、幸運';

  @override
  String get aspTraitVenus => '愛、調和、快適さ';

  @override
  String get aspTraitSaturn => '規律、責任感、忍耐強く時に遅れて訪れる成功';

  @override
  String get aspTraitRahu => '野心、激しさ、型破りな展開';

  @override
  String get aspTraitKetu => '無執着、精神性、突然の変化';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '${planet}は${targets}に影響を与えています。これらの惑星が示す分野に${trait}をもたらすかもしれません。';
  }

  @override
  String aspAiNone(Object planet) {
    return '${planet}はここで他のどの惑星にも特別なアスペクトを与えていません。その影響は主に自身のサインとハウスを通じて働きます。';
  }

  @override
  String get avSummaryTitle => 'アシュタカヴァルガのサマリー';

  @override
  String get avOverallScore => '総合SAVスコア';

  @override
  String get avOverallRating => '総合評価';

  @override
  String get avStrongestSigns => '最も強いサイン';

  @override
  String get avWeakestSigns => '最も弱いサイン';

  @override
  String get avScore => 'スコア';

  @override
  String get avMeaning => '意味';

  @override
  String get avGrid => 'グリッド';

  @override
  String get avList => 'リスト';

  @override
  String get avOverallScoreShort => '総合スコア';

  @override
  String get avNatalSignScore => '出生サインスコア';

  @override
  String get avBestSigns => '最良のサイン';

  @override
  String get avWeakSigns => '弱いサイン';

  @override
  String get avAiInterpretation => 'AIによる解釈';

  @override
  String get avVeryGood => '非常に良い';

  @override
  String get avVeryWeak => '非常に弱い';

  @override
  String get avTotalSav => 'SAV合計';

  @override
  String get avPlanetContributions => '惑星ごとの貢献度';

  @override
  String get avFinance => '金融';

  @override
  String get avOverallStrength => '総合的な強さ';

  @override
  String get avWhatDoesThisMean => 'これはどういう意味？';

  @override
  String get avSimple => 'シンプル';

  @override
  String get avAdvanced => '詳細';

  @override
  String get avInfoTitle => 'アシュタカヴァルガを理解する';

  @override
  String get avStrong => '強い';

  @override
  String get avModerate => '普通';

  @override
  String get avQWhatIsAv => 'アシュタカヴァルガとは？';

  @override
  String get avQWhatIsSav => 'SAVとは？';

  @override
  String get avQWhatIsBav => 'BAVとは？';

  @override
  String get avQHowToRead => 'これらのスコアの読み方';

  @override
  String get avQSavVsBav => 'SAVとBAVの違い';

  @override
  String get avABody => 'アシュタカヴァルガは、ヴェーダ占星術におけるポイント制の強さのシステムです。各惑星はその位置に基づいて、12のサインに吉点（ビンドゥ、レーカとも呼ばれる）を付与します。あるサインのポイントが多いほど、関連する惑星期やトランジットの際にその分野がよりスムーズにサポートされます。';

  @override
  String get avSavBody => 'SAV（サルヴァ・アシュタカヴァルガ）は、7つの惑星すべてのポイントを各サインごとに合算したものです。サインごとに単一の強さスコアを示すため、あなたのチャートでどのサイン — そしてそれが属するハウス — が最もサポートされているかを一目で確認できます。';

  @override
  String get avBavBody => 'BAV（ビンナ・アシュタカヴァルガ）は、1つの惑星の12サインにわたるポイントを示します。特定の惑星がどのサインを最もサポートしているかを示し、その惑星のダシャーやトランジットが活性化しているときに重要になります。';

  @override
  String get avHowToReadBody => '数値が高いほど良好です。SAVでは、平均的なサインは約28ポイントで、30を超えると強く、25未満は注意が必要です。BAVでは各サインは0から8の範囲で、4が平均です。重要な行動には最も強いサインを活用し、最も弱いサインには忍耐と規律を持って臨みましょう。';

  @override
  String get avSavVsBavBody => 'SAVはすべての惑星の合計で、サインの総合的な強さを示します。BAVは単一の惑星の貢献度で、どの惑星がそのサインを支えているかを示します。全体像を見るにはSAVを、どの惑星がサインの強さを牽引しているかを理解するにはBAVを使いましょう。';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'あなたのチャートは${s1}、${s2}、${s3}で最も強くなっています。これらのサインは惑星期やトランジットの際により良いサポートを提供します。${weak}は現在最もサポートが少ないため、それに関わる事柄には忍耐と規律が役立ちます。';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '${planet}は${s1}と${s2}を通じて最も力を発揮します。${planet}が司る事柄は、これらのサインが活性化するときに改善する傾向があります。';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'あなたの最も強いサインは${s1}と${s2}です — 惑星がこれらを通過する際に重要な物事を始めるとよいでしょう。';
  }

  @override
  String avInsightWeak(Object s1) {
    return '${s1}は最もサポートが少ないです — その分野では慎重に進み、過度なコミットメントを避けましょう。';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '${planet}が最も多くのポイントを持っているため、その示唆する事柄はあなたの人生でよくサポートされています。';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '${planet}は最もポイントが少なく、レメディと意識的な努力が最も効果的です。';
  }

  @override
  String avInsightAverage(Object avg) {
    return '平均値である${avg}ポイントを上回るサインは、よりスムーズで安定した結果をもたらす傾向があります。';
  }

  @override
  String get fcKey => 'キー';

  @override
  String get fcActions => 'アクション';

  @override
  String get fcCautions => '注意点';

  @override
  String get fc12House => '12ハウス';

  @override
  String get fcProbabilities => '可能性';

  @override
  String get fcHousesCaps => 'ハウス';

  @override
  String get fcCritical => '重大';

  @override
  String get fcFlags => 'フラグ';

  @override
  String get fcAnalysis => '分析';

  @override
  String get fcConfidence => '信頼度';

  @override
  String get fcQualityCaps => '質';

  @override
  String get fcIncomeVs => '収入 対';

  @override
  String get fcExpense => '支出';

  @override
  String get fcFinance => '金融';

  @override
  String get fcNetBalance => '純収支';

  @override
  String get fcSignature => 'シグネチャー';

  @override
  String get fcBestTimeForIncome => '収入に最適な時期';

  @override
  String get fcExpenseCaution => '支出の注意点';

  @override
  String get fcIncomeCaps => '収入';

  @override
  String get fcExpenseCaps => '支出';

  @override
  String get fcRelationships => '人間関係';

  @override
  String get fcAreasCaps => '分野';

  @override
  String get fcBestForMeetings => '会議に最適';

  @override
  String get fcOpportunitiesVs => 'チャンス 対';

  @override
  String get fcRisks => 'リスク';

  @override
  String get fcOutlook => '見通し';

  @override
  String get fcAction => 'アクション';

  @override
  String get fcProtect => '保護';

  @override
  String get fcOpportunityCaps => 'チャンス';

  @override
  String get fcRiskCaps => 'リスク';

  @override
  String get fcTopOpportunities => '主なチャンス';

  @override
  String get fcTopRisks => '主なリスク';

  @override
  String get fcTiming => 'タイミング';

  @override
  String get fcWindows => '好機';

  @override
  String get fcSlotsCaps => '時間帯';

  @override
  String get fcBestWindows => '最良の好機';

  @override
  String get fcWorstWindows => '最悪の時期';

  @override
  String get fcAvoid => '避ける';

  @override
  String get fcHouse => 'ハウス';

  @override
  String get fcFailed => '失敗';

  @override
  String get lifeCareer => 'キャリア';

  @override
  String get lifeHealth => '健康';

  @override
  String get lifeWealth => '富';

  @override
  String get lifeFamily => '家族';

  @override
  String get lifeMind => '心';

  @override
  String get lifeEgo => '自我';

  @override
  String get lifeAggression => '攻撃性';

  @override
  String get lifeConflict => '対立';

  @override
  String get rashiElement => '元素';

  @override
  String get rashiQuality => '性質';

  @override
  String get rashiLuckyColor => 'ラッキーカラー';

  @override
  String get rashiLuckyDay => 'ラッキーデー';

  @override
  String get rashiLuckyNumber => 'ラッキーナンバー';

  @override
  String get rashiGemstone => '宝石';

  @override
  String get rashiBody => '身体';

  @override
  String get gocharTodaysTransitChart => '今日のトランジットチャート';

  @override
  String get gocharTransit => 'トランジット';

  @override
  String get thisWeek => '今週';

  @override
  String get thisMonth => '今月';

  @override
  String get best => '最良';

  @override
  String get worst => '最悪';

  @override
  String get avg => '平均';

  @override
  String get favorableLoveWindowsLabel => '恋愛に好ましい時期';

  @override
  String get lordLabel => '支配星';

  @override
  String get lordPlacementLabel => '支配星の配置';

  @override
  String get lordDignityLabel => '支配星の品位';

  @override
  String get categoriesSuffix => 'カテゴリー';

  @override
  String get coreBlockerLabel => '根本的な障壁';

  @override
  String get coreGiftLabel => '✦ 中核の才能';

  @override
  String get coreThemeLabel => '● 中核テーマ';

  @override
  String dominantLabel(Object value) {
    return '優勢：${value}';
  }

  @override
  String get karakasSuffix => 'カーラカ';

  @override
  String get protectiveLabel => '保護';

  @override
  String secondaryLabel(Object value) {
    return ' ・副次：${value}';
  }

  @override
  String get tagCore => '中核';

  @override
  String get debtScoresHeader => '📉 負債スコア';

  @override
  String get debtCurrentLoadStat => '現在の\n負債負荷';

  @override
  String get debtRecoveryCapacityStat => '回復\n能力';

  @override
  String get debtIntensityStat => '強度';

  @override
  String get debtDefaultRiskStat => 'デフォルトリスク';

  @override
  String get debtProfileTitle => '負債プロフィール';

  @override
  String get debtKarmaLabel => 'カルマ';

  @override
  String get debtPersonalityLabel => '性格';

  @override
  String get debtPhaseLabel => '段階';

  @override
  String get debtPrimaryCategoryLabel => '主なカテゴリー';

  @override
  String get debtWord => '負債';

  @override
  String get debtYogasTitle => '負債のヨーガ';

  @override
  String get debtCreatingLabel => '負債発生';

  @override
  String get debtClearingLabel => '負債解消';

  @override
  String get yearlyDebtTitle => '年間負債';

  @override
  String get debtRepaymentTitle => '返済';

  @override
  String get debtDangerPeriodsTitle => '危険な時期';

  @override
  String get debtDefaultPctStat => 'デフォルト率';

  @override
  String get debtBankruptcyPctStat => '破産率';

  @override
  String get debtChronicPctStat => '慢性化率';

  @override
  String get debtResilienceStat => 'レジリエンス';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return '回復：${pct}％・期間：${years}年';
  }

  @override
  String get debtFreeWindowLabel => '🎯 完済の好機';

  @override
  String debtFreeYear(Object year) {
    return '${year}年';
  }

  @override
  String get legalScoresHeader => '⚖️ 法律スコア';

  @override
  String get legalVulnerabilityStat => '法的\n脆弱性';

  @override
  String get legalVictoryPotentialStat => '勝訴の\n可能性';

  @override
  String get legalConflictStat => '対立';

  @override
  String get legalResolutionStat => '解決';

  @override
  String get legalProfileTitle => '法律プロフィール';

  @override
  String get legalKarmaTypeLabel => 'カルマのタイプ';

  @override
  String get legalConflictStyleLabel => '対立のスタイル';

  @override
  String get legalStrategyLabel => '戦略';

  @override
  String get legalCaseDurationLabel => '案件の期間';

  @override
  String get legalCurrentStatusLabel => '現在の状況';

  @override
  String get legalWord => '法律';

  @override
  String get legalYogasTitle => '法律のヨーガ';

  @override
  String get legalDisputePressureLabel => '紛争のプレッシャー';

  @override
  String get legalProtectionLabel => '法的保護';

  @override
  String get legalStressTrendTitle => '法律ストレス';

  @override
  String get legalVisibleEnemiesStat => '表立った敵';

  @override
  String get legalHiddenEnemiesStat => '隠れた敵';

  @override
  String get legalCriminalRiskStat => '犯罪リスク';

  @override
  String get legalFalseAccusationStat => '冤罪';

  @override
  String get legalContractKarmaTitle => '契約のカルマ';

  @override
  String get legalDocumentationLabel => '文書管理';

  @override
  String get legalFinePrintAwareLabel => '細部条項への注意';

  @override
  String get legalNegotiationSkillLabel => '交渉力';

  @override
  String get legalSignatureCautionLabel => '署名時の慎重さ';

  @override
  String legalResilienceSubtitle(Object pct) {
    return '強靭さ：${pct}/100';
  }

  @override
  String get legalVictoryWord => '勝訴';

  @override
  String get legalAnalysisSuffix => '分析';

  @override
  String get legalAsPlaintiff => '原告として';

  @override
  String get legalAsDefendant => '被告として';

  @override
  String get legalWinProbability => '勝訴の可能性';

  @override
  String get legalDisputeWord => '紛争';

  @override
  String get lifepathScoresHeader => '🌟 人生の道スコア';

  @override
  String get lifepathDharmaClarityStat => 'ダルマの\n明瞭さ';

  @override
  String get lifepathFortuneBaselineStat => '幸運の\n基盤';

  @override
  String get lifepathCoherenceStat => '人生の道の\n一貫性';

  @override
  String get lifepathKarmaStat => 'カルマ';

  @override
  String get lifepathSpiritualStat => '精神性';

  @override
  String get lifepathFameStat => '名声';

  @override
  String get lifepathSoulContractTitle => '魂の契約';

  @override
  String get lifepathAtmakarakaLabel => 'アートマカーラカ';

  @override
  String get lifepathAkFocusLabel => 'AKのフォーカス';

  @override
  String get lifepathSoulPurposeLabel => '魂の目的';

  @override
  String get lifepathLifeChapterLabel => '人生の章';

  @override
  String get lifepathPrimaryDomainLabel => '主な分野';

  @override
  String get lifepathLeadershipStat => 'リーダーシップ';

  @override
  String get lifepathWisdomTeachStat => '知恵／教育';

  @override
  String get lifepathServiceStat => '奉仕';

  @override
  String get lifepathHealingStat => '癒し';

  @override
  String get lifepathFortuneYogasTitle => '幸運のヨーガ';

  @override
  String get lifepathLuckBlocksLabel => '運の妨げ';

  @override
  String get lifepathFortuneBoostersLabel => '幸運の後押し';

  @override
  String get lifepathFortuneTrendTitle => '幸運のトレンド';

  @override
  String get lifepathGoldenWindowsTitle => '黄金期 ★';

  @override
  String get lifepathTransformationTitle => '変容';

  @override
  String get lifepathMilestonesTitle => '人生の節目';

  @override
  String get lifepathKarmicLessonsTitle => 'カルマの教訓';

  @override
  String get lifepathRahuGrowthLabel => 'ラーフの成長';

  @override
  String get lifepathKetuSurrenderLabel => 'ケートゥの手放し';

  @override
  String get lifepathSaturnLessonLabel => '土星の教訓';

  @override
  String get lifepathLifeDifficultyLabel => '人生の困難度';

  @override
  String get lifepathSoulExperienceTitle => '★ 魂が経験しに来たこと';

  @override
  String get lifepathBlessingsTitle => '● 祝福';

  @override
  String get lifepathLifeWord => '人生';

  @override
  String get lifepathArchetypeSuffix => 'アーキタイプ';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return '充足度：${pct}％';
  }

  @override
  String get lifepathDestinyVsWord => '運命 対';

  @override
  String get lifepathFreeWillSuffix => '自由意志';

  @override
  String get lifepathDestinyStat => '運命';

  @override
  String get lifepathFreeWillStat => '自由意志';

  @override
  String get pastlifeScoresHeader => '🔮 前世スコア';

  @override
  String get pastlifeSignatureStrengthStat => 'シグネチャーの\n強さ';

  @override
  String get pastlifeCarryForwardStat => '受け継ぎ';

  @override
  String get pastlifeMasteryPreservedStat => '保持された\n熟達度';

  @override
  String get pastlifeUnfinishedStat => '未完了';

  @override
  String get pastlifeKarmicDebtStat => 'カルマの負債';

  @override
  String get pastlifeProfileTitle => '前世プロフィール';

  @override
  String get pastlifeThemeLabel => 'テーマ';

  @override
  String get pastlifeProfessionLabel => '職業';

  @override
  String get pastlifeSocialStandingLabel => '社会的地位';

  @override
  String get pastlifeRegionLabel => '地域';

  @override
  String get pastlifeSpiritualLevelLabel => '精神性のレベル';

  @override
  String get pastlifeGenderLabel => '性別';

  @override
  String get pastlifeWealthLevelLabel => '富のレベル';

  @override
  String get pastlifeFamilyRoleLabel => '家族内での役割';

  @override
  String get pastlifeSkillsCarriedTitle => '★ 受け継がれたスキル';

  @override
  String get pastlifeNaturalAttractionsTitle => '● 自然な引かれ';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ 説明のつかない恐れ';

  @override
  String get pastlifeMagneticPullsTitle => '→ 引き寄せられるもの';

  @override
  String get pastlifeRelationshipStat => '人間関係';

  @override
  String get pastlifeFinancialStat => '金銭';

  @override
  String get pastlifeServiceStat => '奉仕';

  @override
  String get pastlifeDharmicStat => 'ダルマ';

  @override
  String get pastlifeOnRelationsStat => '人間関係への影響';

  @override
  String get pastlifeOnCareerStat => 'キャリアへの影響';

  @override
  String get pastlifeOnHealthStat => '健康への影響';

  @override
  String get pastlifeOnSpiritualStat => '精神性への影響';

  @override
  String get pastlifeKarmicResolutionTitle => 'カルマの解消';

  @override
  String get pastlifePrimaryPathLabel => '主な道筋';

  @override
  String get pastlifeSecondaryPathLabel => '副次的な道筋';

  @override
  String get pastlifeClearingProgressLabel => '浄化の進捗';

  @override
  String get pastlifeRemainingWorkLabel => '残された課題';

  @override
  String get pastlifeDebtTimelineLabel => '負債のタイムライン';

  @override
  String get pastlifeMemoryAccessStat => '記憶へのアクセス';

  @override
  String get pastlifeDreamVisitsStat => '夢での訪問';

  @override
  String get pastlifeDejaVuStat => 'デジャヴュ';

  @override
  String get pastlifeRegressionFitStat => '退行療法への適性';

  @override
  String get pastlifeActivationTitle => '前世の活性化';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return '成熟度：${maturity}・状態：${status}';
  }

  @override
  String get pastlifeKetuWord => 'ケートゥ';

  @override
  String get pastlifePastMasterySuffix => '前世の熟達';

  @override
  String get pastlifeKetuMasteredLabel => 'ケートゥ・あなたが習得したこと';

  @override
  String get pastlifeRahuWord => 'ラーフ';

  @override
  String get pastlifeFutureGrowthSuffix => '未来の成長';

  @override
  String get pastlifeRahuPullsLabel => 'ラーフ・あなたを前進させるもの';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ シャドウ：${shadow}';
  }

  @override
  String get mentalScoresHeader => '🧠 メンタルスコア';

  @override
  String get mentalStabilityStat => '精神的\n安定性';

  @override
  String get mentalEmotionalBaselineStat => '感情の\n基盤';

  @override
  String get mentalResilienceStat => 'レジリエンス';

  @override
  String get mentalAnxietyStat => '不安';

  @override
  String get mentalDepressionStat => '落ち込み';

  @override
  String get mentalRegulationStat => '調整力';

  @override
  String get mentalProfileTitle => 'メンタルプロフィール';

  @override
  String get mentalConstitutionLabel => '体質';

  @override
  String get mentalStressDriverLabel => 'ストレスの要因';

  @override
  String get mentalStabilityAnchorLabel => '安定の拠り所';

  @override
  String get mentalStressResponseLabel => 'ストレス反応';

  @override
  String get mentalAttachmentStyleLabel => 'アタッチメントスタイル';

  @override
  String get mentalBurnoutStageLabel => '燃え尽きの段階';

  @override
  String get mentalWord => 'メンタル';

  @override
  String get mentalYogasTitle => 'メンタルのヨーガ';

  @override
  String get mentalStressPressureLabel => 'ストレスのプレッシャー';

  @override
  String get mentalWellnessTrendTitle => 'ウェルネストレンド';

  @override
  String get mentalHealthyCopingTitle => '✓ 健全な対処法';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ 不健全なリスク';

  @override
  String get mentalRecommendedAlternativesTitle => '✦ おすすめの代替策';

  @override
  String get mentalSleepQualityStat => '睡眠の質';

  @override
  String get mentalSocialSupportStat => '社会的サポート';

  @override
  String get mentalBurnoutVulnStat => '燃え尽きへの脆弱性';

  @override
  String get mentalSelfAwarenessStat => '自己認識';

  @override
  String get mentalAnxietyWord => '不安';

  @override
  String get mentalTypesSuffix => 'タイプ';

  @override
  String get mentalTherapyWord => 'セラピー';

  @override
  String get mentalModalityFitSuffix => '手法の適性';

  @override
  String get characterScoresHeader => '🔍 性格スコア';

  @override
  String get characterStrengthStat => '性格の\n強さ';

  @override
  String get characterIntegrityStat => '誠実さ';

  @override
  String get characterResilienceStat => '回復力';

  @override
  String get characterAwarenessStat => '認識力';

  @override
  String get characterStabilityStat => '安定性';

  @override
  String get characterEthicsStat => '倫理観';

  @override
  String get characterSurfacePersonalityTitle => '表面的な人格';

  @override
  String get characterLagnaLabel => 'ラグナ';

  @override
  String get characterConstitutionLabel => '体質';

  @override
  String get characterNakshatraLabel => 'ナクシャトラ';

  @override
  String get characterDeityLabel => '守護神';

  @override
  String get characterMoonManasTitle => '月のマナス（心）';

  @override
  String get characterSignLabel => 'サイン';

  @override
  String get characterHouseLabel => 'ハウス';

  @override
  String get characterWarmthStat => '温かさ';

  @override
  String get characterEmpathyStat => '共感力';

  @override
  String get characterLoyaltyStat => '忠誠心';

  @override
  String get characterBoundariesStat => '境界線';

  @override
  String get characterDharmaStat => 'ダルマ';

  @override
  String get characterTruthStat => '誠実さ';

  @override
  String get characterCompassionStat => '思いやり';

  @override
  String get characterGenerosityStat => '寛大さ';

  @override
  String get characterSignatureVirtuesTitle => '★ 特徴的な美徳';

  @override
  String get characterNaturalTalentsTitle => '● 生まれ持った才能';

  @override
  String get characterShadowPatternsTitle => '⚠ シャドウパターン';

  @override
  String get characterYogasTitle => '性格のヨーガ';

  @override
  String get characterTestsLabel => '試練';

  @override
  String get characterGiftsLabel => '才能';

  @override
  String get characterSelfAwareEiStat => '自己認識（EQ）';

  @override
  String get characterSelfRegulateStat => '自己制御';

  @override
  String get characterEmpathyEiStat => '共感力（EQ）';

  @override
  String get characterSocialSkillsStat => '社会的スキル';

  @override
  String characterRealizationSubtitle(Object pct) {
    return '実現度：${pct}％';
  }

  @override
  String get characterAtmakarakaWord => 'アートマカーラカ';

  @override
  String get characterSoulSignatureSuffix => '魂のシグネチャー';

  @override
  String get characterAtmakarakaLabel => 'アートマカーラカ';

  @override
  String get characterGunaWord => 'グナ';

  @override
  String get characterProfileSuffix => 'プロフィール';

  @override
  String get characterSattvaLabel => 'サットヴァ';

  @override
  String get characterRajasLabel => 'ラジャス';

  @override
  String get characterTamasLabel => 'タマス';

  @override
  String get healthScoresHeader => '🏥 健康スコア';

  @override
  String get healthVitalityStat => '生命力';

  @override
  String get healthImmunityStat => '免疫力';

  @override
  String get healthRecoveryStat => '回復力';

  @override
  String get healthMentalStat => 'メンタル';

  @override
  String get healthStressTolStat => 'ストレス耐性';

  @override
  String get healthYogasTitle => '健康のヨーガ';

  @override
  String get healthDiseasePressureLabel => '疾病リスク';

  @override
  String get healthTrendTitle => '健康トレンド';

  @override
  String get healthRecoveryWindowsTitle => '回復期';

  @override
  String get healthCautionPeriodsTitle => '注意すべき時期';

  @override
  String get healthFertilityStat => '妊娠力';

  @override
  String get healthBurnoutRiskStat => '燃え尽きリスク';

  @override
  String get healthAddictionVulnStat => '依存症への脆弱性';

  @override
  String get healthWorkLifeBalStat => 'ワークライフバランス';

  @override
  String get healthAyurvedicWord => 'アーユルヴェーダ';

  @override
  String get healthConstitutionSuffix => '体質';

  @override
  String get healthBodyWord => '身体';

  @override
  String get healthSystemMapSuffix => '系統マップ';

  @override
  String get healthBodyZoneWord => '身体部位';

  @override
  String get healthVulnerabilitySuffix => '脆弱性';

  @override
  String get healthDiseaseWord => '疾病';

  @override
  String get healthSusceptibilitySuffix => 'かかりやすさ';

  @override
  String get healthLifestyleFactorsTitle => '生活習慣要因';

  @override
  String get healthSleepDisciplineLabel => '睡眠管理';

  @override
  String get healthDietDisciplineLabel => '食事管理';

  @override
  String get healthExerciseNeedLabel => '運動の必要性';

  @override
  String get healthSunlightNeedLabel => '日光浴の必要性';

  @override
  String get healthSocialTypeLabel => '社交タイプ';

  @override
  String get healthHealingSpeedLabel => '治癒の速さ';

  @override
  String get wealthScoresHeader => '💰 金運スコア';

  @override
  String get wealthStrengthStat => '金運の\n強さ';

  @override
  String get wealthAccumulationStat => '資産の\n蓄積';

  @override
  String get wealthIncomeFlowStat => '収入の\n流れ';

  @override
  String get wealthSustainStat => '持続性';

  @override
  String get wealthMultiStreamStat => '複数の収入源';

  @override
  String get wealthRetentionStat => '資産の保持';

  @override
  String get wealthWord => '富';

  @override
  String get wealthYogasTitle => '金運のヨーガ';

  @override
  String get wealthDrainsLabel => '消耗要因';

  @override
  String get wealthBoostersLabel => '後押し要因';

  @override
  String get wealthYearlyTrendTitle => '年間トレンド';

  @override
  String get wealthGrowthTitle => '資産の成長';

  @override
  String get wealthCashPressureTitle => '資金繰りの圧力';

  @override
  String get wealthMoneyPersonalityTitle => 'お金に対する性格';

  @override
  String get wealthTypeLabel => '富のタイプ';

  @override
  String get wealthRiskAppetiteLabel => 'リスク許容度';

  @override
  String get wealthInvestmentStyleLabel => '投資スタイル';

  @override
  String get wealthMoneyPersonalityLabel => 'お金に対する性格';

  @override
  String get wealthSpendingLabel => '支出傾向';

  @override
  String get wealthDebtProbStat => '負債の可能性％';

  @override
  String get wealthInheritanceStat => '相続％';

  @override
  String get wealthSuddenGainsStat => '突然の利得％';

  @override
  String get wealthSpouseBoostStat => '配偶者による後押し％';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return '成功の可能性：${pct}％';
  }

  @override
  String get wealthLifetimeClassLabel => '生涯の資産クラス';

  @override
  String wealthPrimaryLabel(Object value) {
    return '主要：${value}';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'ピーク：${value}';
  }

  @override
  String get wealthIncomeWord => '収入';

  @override
  String get wealthSourcesSuffix => '源';

  @override
  String get wealthInvestmentWord => '投資';

  @override
  String get wealthMixSuffix => '配分';

  @override
  String wealthDrivenByLabel(Object planet) {
    return '${planet}による牽引';
  }

  @override
  String get marriageScoresHeader => '💒 結婚スコア';

  @override
  String get marriageOverallStat => '総合的な\n結婚運';

  @override
  String get marriageHarmonyStat => '結婚生活の\n調和';

  @override
  String get marriageDomesticStabilityStat => '家庭の\n安定性';

  @override
  String get marriageLongevityStat => '持続性';

  @override
  String get marriageSatisfactionStat => '満足度';

  @override
  String get marriageClarityStat => '明瞭さ';

  @override
  String get marriageWindowsTitle => '結婚に適した時期';

  @override
  String get marriagePhasesTitle => '結婚生活の段階';

  @override
  String get marriageInLawRelationsStat => '義理の家族との関係';

  @override
  String get marriageFamilyHarmonyStat => '家族の調和';

  @override
  String get marriageFertilityStat => '妊娠力';

  @override
  String get marriageHomeOwnershipStat => '持ち家の可能性';

  @override
  String get marriageDivorceRiskStat => '離婚リスク';

  @override
  String get marriageInfidelityStat => '不貞';

  @override
  String get marriageConflictStat => '対立';

  @override
  String get marriageDistanceStat => '距離感';

  @override
  String get marriageSeekInPartnerTitle => '★ パートナーに求めるもの';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ パートナーで避けるべきもの';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return '実現度：${pct}％';
  }

  @override
  String get marriageDarakarakaWord => 'ダーラカーラカ';

  @override
  String get marriageSpouseKarakaSuffix => '配偶者カーラカ';

  @override
  String get marriageDarakarakaDkLabel => 'ダーラカーラカ（DK）';

  @override
  String get marriage7thWord => '7ハウス';

  @override
  String get marriageSignLabel => 'サイン';

  @override
  String get marriageLordInLabel => '支配星の位置';

  @override
  String get marriageStrengthLabel => '強さ';

  @override
  String get marriageSpouseWord => '配偶者';

  @override
  String get marriageProfileSuffix => 'プロフィール';

  @override
  String get marriageSpouseTraitsTitle => '★ 配偶者の特性';

  @override
  String get marriageLikelyProfessionsTitle => '● 考えられる職業';

  @override
  String get marriageHarmonyWord => '調和';

  @override
  String get marriageRadarSuffix => 'レーダー';

  @override
  String get marriagePhysicalLabel => '身体面';

  @override
  String get marriageSharedValuesLabel => '共有する価値観';

  @override
  String get marriageConflictResolutionLabel => '対立の解消';

  @override
  String get marriageMangalDoshLabel => '⚠ マンガル・ドーシャ';

  @override
  String marriageSeveritySubtitle(Object value) {
    return '深刻度：${value}';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return '相殺：${value}';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'ナヴァムシャ';

  @override
  String get multiChartTitleChild => '子宝';

  @override
  String get multiChartTitleLove => '恋愛';

  @override
  String get multiChartTitleKarma => 'カルマ';

  @override
  String get multiChartTitleDefault => '複数チャート';

  @override
  String get multiChartSuffixProbability => '確率';

  @override
  String get multiChartSuffixCompatibility => '相性';

  @override
  String get multiChartSuffixLinkage => '連関';

  @override
  String get multiChartSuffixReport => 'レポート';

  @override
  String get multiChartParticipantsLabel => '参加者';

  @override
  String get multiChartAnalysisWord => '分析';

  @override
  String get multiChartConfidenceSuffix => '信頼度';

  @override
  String get multiChartQualityBadge => '品質';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'このヴェーダ占星術のレポートを分析し、詳細な洞察を教えてください：\n\n${formatted}';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'こちらはヴェーダ占星術の専門レポートです。詳しく分析し、実践的な洞察を提供してください：\n\n${formatted}';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'このヴェーダ占星術の分析を確認し、主な結果をわかりやすい言葉で説明してください：\n\n${formatted}';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return '${label}用にコピーしました！';
  }

  @override
  String get childProbTitle1 => '子宝';

  @override
  String get childProbTitle2 => '確率';

  @override
  String get childNumberOfChildrenHeader1 => '子供の';

  @override
  String get childNumberOfChildrenHeader2 => '人数';

  @override
  String get childTimingHeader1 => 'タイミング';

  @override
  String get childTimingHeader2 => 'ムーラ・ダシャー';

  @override
  String get child5thHouseHeader1 => '5ハウス';

  @override
  String get analysisWord => '分析';

  @override
  String get jupiterWord => '木星';

  @override
  String get childD7Header1 => 'D7サプタムシャ';

  @override
  String get childBeejaHeader1 => 'ビージャ・クシェートラ';

  @override
  String get childBeejaHeader2 => 'スプタ';

  @override
  String get childDoshaHeader1 => 'ドーシャ';

  @override
  String get childVedicHeader1 => 'ヴェーダの';

  @override
  String get childVedicHeader2 => 'レメディ';

  @override
  String get progenyProbabilityLabel => '子宝の可能性';

  @override
  String get favorableWindowsLabel => '好ましい時期';

  @override
  String get partnerOneLabel => 'パートナー1';

  @override
  String get partnerTwoLabel => 'パートナー2';

  @override
  String get moonSignLabel => '月サイン';

  @override
  String get lordInDusthana => 'ドゥシュタナにある支配星';

  @override
  String get lordStrengthLabel => '支配星の強さ';

  @override
  String get houseStrengthLabel => 'ハウスの強さ';

  @override
  String get dignityLabel => '品位';

  @override
  String get directBadge => '順行';

  @override
  String get notCombustBadge => 'コンバストなし';

  @override
  String get in5thHouseBadge => '5ハウスにある';

  @override
  String get aspects5thBadge => '5ハウスにアスペクト';

  @override
  String get no5thConnectionBadge => '5ハウスとの関連なし';

  @override
  String jupiterInSignHeading(String sign) {
    return '${sign}にある木星';
  }

  @override
  String get d7LagnaLabel => 'D7ラグナ';

  @override
  String get d7FifthSignLabel => 'D7の5番目のサイン';

  @override
  String get d7FifthLordLabel => 'D7の5ハウス支配星';

  @override
  String get jupiterInD7Label => 'D7における木星';

  @override
  String get jupiterDignityLabel => '木星の品位';

  @override
  String get d7StrengthLabel => 'D7の強さ';

  @override
  String get yesWord => 'はい';

  @override
  String get noWord => 'いいえ';

  @override
  String get beejaSphutaTitle => 'ビージャ・スプタ';

  @override
  String get kshetraSphutaTitle => 'クシェートラ・スプタ';

  @override
  String get degreeLabel => '度数';

  @override
  String get signLordLabel => 'サイン支配星';

  @override
  String get presentInLabel => '位置';

  @override
  String get netPenaltyLabel => '正味のペナルティ';

  @override
  String get remedyGemstone => '宝石によるレメディ';

  @override
  String get remedyMantra => 'マントラによるレメディ';

  @override
  String get remedyRitual => '儀式によるレメディ';

  @override
  String get remedyLifestyle => '生活習慣によるレメディ';

  @override
  String get remedyCharitable => '慈善によるレメディ';

  @override
  String copiedForName(String name) {
    return '${name}用にコピーしました！';
  }

  @override
  String get mahadashaLabel => 'マハダシャー';

  @override
  String get mdPeriodLabel => 'MD期間';

  @override
  String get antardashaLabel => 'アンタルダシャー';

  @override
  String get adPeriodLabel => 'AD期間';

  @override
  String get pratyantardashaLabel => 'プラティヤンタルダシャー';

  @override
  String get favorabilityLabel => '好意度';

  @override
  String factorPrefix(String factor) {
    return '要因：${factor}';
  }

  @override
  String appliesToLabel(String value) {
    return '対象：${value}';
  }

  @override
  String get qualityTag => '品質';

  @override
  String get reliabilityVeryHigh => '非常に高い信頼性';

  @override
  String get reliabilityGuidanceLevel => '参考程度の分析';

  @override
  String get karmaLinkTitle1 => 'カルマ';

  @override
  String get karmaLinkTitle2 => '連関';

  @override
  String get karmaFoundationHeader1 => 'カルマの';

  @override
  String get karmaFoundationHeader2 => '基盤';

  @override
  String get karmaPairwiseHeader1 => 'ペア間の';

  @override
  String get karmaPairwiseHeader2 => '連関';

  @override
  String get karmaGroupHeader1 => 'グループ';

  @override
  String get karmaGroupHeader2 => 'パターン';

  @override
  String get karmaPastLifeHeader1 => '前世の';

  @override
  String get karmaPastLifeHeader2 => '目標';

  @override
  String get karmaCurrentLifeHeader1 => '現世の';

  @override
  String get karmaCurrentLifeHeader2 => '学び';

  @override
  String get karmaDebtsHeader2 => '負債';

  @override
  String get karmaMoolaDashaHeader1 => 'ムーラ・ダシャー';

  @override
  String get karmaMoolaDashaHeader2 => 'タイミング';

  @override
  String get karmaDeepAuditHeader1 => '詳細';

  @override
  String get karmaDeepAuditHeader2 => '分析テーブル';

  @override
  String get karmaHeroLabel => '前世カルマ連関';

  @override
  String get karmaKetuMastery => 'ケートゥの熟達';

  @override
  String get nakshatraLabel => 'ナクシャトラ';

  @override
  String get deityLabel => '守護神';

  @override
  String get masteryScoreLabel => '熟達スコア';

  @override
  String get karmaRahuGrowth => 'ラーフの成長';

  @override
  String get growthScoreLabel => '成長スコア';

  @override
  String get karmaAtmakaraka => 'アートマカーラカ';

  @override
  String get karmaSaturnKarma => '土星のカルマ';

  @override
  String get karma12thHouse => '12ハウス';

  @override
  String get karma9thHousePunya => '9ハウスのプニヤ（功徳）';

  @override
  String get bhavaScoreLabel => 'バーヴァスコア';

  @override
  String get karmaD60Signature => 'D60シグネチャー';

  @override
  String get depthScoreLabel => '深度スコア';

  @override
  String get linkageStrengthLabel => '連関の強さ';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return '連関要因（${count}件有効）';
  }

  @override
  String get factorColumnLabel => '要因';

  @override
  String get weightColumnLabel => '重み';

  @override
  String get meaningColumnLabel => '意味';

  @override
  String get statusColumnLabel => '状態';

  @override
  String get karmaPastLifeConnection => '前世でのつながり';

  @override
  String get karmaCurrentLifeDynamic => '現世でのダイナミクス';

  @override
  String get karmaWhatTheyTeach => '互いに教え合うこと';

  @override
  String get karmaGroupThemeHeader => 'グループのカルマテーマ';

  @override
  String get karmaSharedSettingHeader => '共有された前世の背景';

  @override
  String get karmaCollectiveKetuHeader => '集団のケートゥパターン';

  @override
  String get karmaCollectiveRahuHeader => '集団のラーフパターン';

  @override
  String get housesPrefixLabel => 'ハウス：';

  @override
  String get signsPrefixLabel => 'サイン：';

  @override
  String get karmicCohesionLabel => 'カルマの結束度';

  @override
  String get karmaGroupSoulContractHeader => 'グループの魂の契約';

  @override
  String get goalLabel => '目標';

  @override
  String get karmaSharedGoalHeader => '共有された前世の目標';

  @override
  String get howToGrowHeader => '成長する方法';

  @override
  String moolaDashaPrefix(String value) {
    return 'ムーラ・ダシャー：${value}';
  }

  @override
  String get karmaSharedLessonHeader => '共有されたグループの教訓';

  @override
  String get karmaMutualTeachingHeader => '相互学びのマップ';

  @override
  String get karmaTeachingDynamicsPlaceholder => 'カルマのつながりが深まるにつれて、学びのダイナミクスが明らかになります。';

  @override
  String get typeFieldLabel => '種類';

  @override
  String get basisFieldLabel => '根拠';

  @override
  String get resolutionPathHeader => '解消への道筋';

  @override
  String dashaTimingPrefix(String value) {
    return 'ダシャーのタイミング：${value}';
  }

  @override
  String get mutualDebtsHeader => '相互のカルマの負債';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => '日付';

  @override
  String get groupKarmicWindowHeader => 'グループのカルマの好機';

  @override
  String parametersAuditedHeading(int count) {
    return '${count}件のパラメータを分析';
  }

  @override
  String get valuePrefixLabel => '値：';

  @override
  String weightPrefix(String value) {
    return '重み：${value}';
  }

  @override
  String get loveCompatTitle1 => '恋愛';

  @override
  String get loveCompatTitle2 => '相性';

  @override
  String get loveAttractionHeader1 => '魅力と';

  @override
  String get loveAttractionHeader2 => '相性';

  @override
  String get loveEmotionalHeader1 => '感情の';

  @override
  String get loveEmotionalHeader2 => '調和';

  @override
  String get loveMentalHeader1 => '精神的な';

  @override
  String get loveMentalHeader2 => '相性';

  @override
  String get lovePassionHeader1 => '情熱と';

  @override
  String get lovePassionHeader2 => '身体的相性';

  @override
  String get loveLongtermHeader1 => '長期的な';

  @override
  String get loveKarmicHeader1 => 'カルマの';

  @override
  String get loveKarmicHeader2 => '恋愛の絆';

  @override
  String get loveChallengesHeader1 => '課題と';

  @override
  String get loveChallengesHeader2 => '摩擦';

  @override
  String get loveTimingHeader1 => '恋愛のタイミング';

  @override
  String get loveRelationshipHeader1 => '関係性の';

  @override
  String get loveRelationshipHeader2 => 'ダイナミクス';

  @override
  String get loveRemediesHeader1 => 'レメディと';

  @override
  String get loveRemediesHeader2 => 'アドバイス';

  @override
  String get loveCompatHeroLabel => '恋愛相性';

  @override
  String get loveChipAttraction => '魅力度';

  @override
  String get loveChipPassion => '情熱';

  @override
  String get loveChipChallenge => '課題';

  @override
  String get venusSignLabel => '金星サイン';

  @override
  String get attractionScoreLabel => '魅力度スコア';

  @override
  String get activeContactsLabel => '有効なコンタクト';

  @override
  String get magneticPullLabel => '引き寄せる力';

  @override
  String get initialAttractionLabel => '最初の魅力';

  @override
  String get emotionalScoreLabel => '感情スコア';

  @override
  String get elementMatchLabel => 'エレメントの一致';

  @override
  String get harmonyLabel => '調和';

  @override
  String get kootaYoni => 'ヨニ';

  @override
  String get kootaGana => 'ガナ';

  @override
  String get kootaTara => 'ターラー';

  @override
  String get doshaPresentBadge => 'ドーシャあり';

  @override
  String get noDoshaBadge => 'ドーシャなし';

  @override
  String get axisLabel => '軸';

  @override
  String get mentalScoreLabel => '精神的相性スコア';

  @override
  String get mercuryDynamicsLabel => '水星のダイナミクス';

  @override
  String get communicationStyleLabel => 'コミュニケーションスタイルの一致';

  @override
  String get intellectualConnectionLabel => '知的なつながり';

  @override
  String get passionScoreLabel => '情熱スコア';

  @override
  String get marsVenusLabel => '火星・金星の相互作用';

  @override
  String get physicalChemistryLabel => '身体的な相性';

  @override
  String get yoniCompatLabel => 'ヨニ相性';

  @override
  String get longtermScoreLabel => '長期的調和スコア';

  @override
  String get seventhHouseSynastryLabel => '7ハウスのシナストリー';

  @override
  String get commitmentPotentialLabel => 'コミットメントの可能性';

  @override
  String get jupiterBlessingLabel => '木星の祝福';

  @override
  String get d9NavamsaResonanceLabel => 'D9ナヴァムシャ共鳴';

  @override
  String get saturnLongevityLabel => '土星の持続性';

  @override
  String get karmicScoreLabel => 'カルマの絆スコア';

  @override
  String get darakarakaLinkLabel => 'ダーラカーラカのつながり';

  @override
  String get sourceLabel => '出典';

  @override
  String get emotionalGiverReceiverLabel => '感情の与え手／受け手';

  @override
  String get powerBalanceLabel => 'パワーバランス';

  @override
  String get growthDynamicLabel => '成長のダイナミクス';

  @override
  String get addressesLabel => '対象';

  @override
  String get loveScoresLabel => '恋愛スコア';

  @override
  String get loveCapacityLabel => '恋愛\n許容力';

  @override
  String get emotionalAvailabilityLabel => '感情的な\n開放度';

  @override
  String get romanticAttractionLabel => '恋愛の\n魅力度';

  @override
  String get commitmentWord => 'コミットメント';

  @override
  String get intimacyWord => '親密さ';

  @override
  String get fidelityWord => '誠実さ';

  @override
  String get loveProfileTitle => '恋愛プロフィール';

  @override
  String get loveStyleLabel => '恋愛スタイル';

  @override
  String get attractionStyleLabel => '魅力を感じるスタイル';

  @override
  String get lovePathLabel => '恋愛への道';

  @override
  String get currentPhaseLabel => '現在の段階';

  @override
  String get commitmentStyleLabel => 'コミットメントのスタイル';

  @override
  String get loveWord => '恋愛';

  @override
  String get karakasWord => 'カーラカ';

  @override
  String get attractedToLabel => '惹かれる相手';

  @override
  String get whatPartnerSeesLabel => 'パートナーから見えるあなた';

  @override
  String get romancePatternTitle => '恋愛のパターン';

  @override
  String get firstLoveAgeLabel => '初恋の年齢';

  @override
  String get relationshipCountLabel => '交際の回数';

  @override
  String get avgDurationLabel => '平均的な期間';

  @override
  String get breakupTriggerLabel => '破局のきっかけ';

  @override
  String get heartbreakRecoveryLabel => '失恋からの回復';

  @override
  String get loveTrendTitle => '恋愛のトレンド';

  @override
  String get newLoveWindowsTitle => '新しい恋の好機';

  @override
  String get loveBlocksTitle => '恋愛の妨げ';

  @override
  String get activeBlocksLabel => '現在有効な妨げ';

  @override
  String get loveMarriagePctLabel => '恋愛結婚の割合';

  @override
  String get heartbreakVulnLabel => '失恋への脆弱性';

  @override
  String get selfSabotageLabel => '自己妨害';

  @override
  String get emotionalIqLabel => 'EQ（感情知能）';

  @override
  String fulfillmentPctLabel(String pct) {
    return '充足度：${pct}％';
  }

  @override
  String get languagesWord => '愛の言語';

  @override
  String get givesLabel => '与える';

  @override
  String get receivesLabel => '受け取る';

  @override
  String get idealWord => '理想の';

  @override
  String get partnerWord => 'パートナー';

  @override
  String get seekTheseTraitsLabel => '求めるべき特性';

  @override
  String get dealbreakersLabel => '許容できないこと';

  @override
  String get propertyScoresLabel => '不動産スコア';

  @override
  String get acquisitionCapacityLabel => '取得力';

  @override
  String get homeOwnershipPctLabel => '持ち家の\n割合';

  @override
  String get reWealthPotentialLabel => '不動産による\n資産形成力';

  @override
  String get rentalWord => '賃貸';

  @override
  String get vehiclesWord => '乗物';

  @override
  String get landPctLabel => '土地の割合';

  @override
  String get propertyProfileTitle => '不動産プロフィール';

  @override
  String get karmaTypeLabel => 'カルマのタイプ';

  @override
  String get environmentLabel => '環境';

  @override
  String get styleLabel => 'スタイル';

  @override
  String get sizeLabel => '規模';

  @override
  String get locationLabel => '場所';

  @override
  String get actionNext12mLabel => '今後12ヶ月のアクション';

  @override
  String get propertyWord => '不動産';

  @override
  String get propertyYogasTitle => '不動産のヨーガ';

  @override
  String get drainsLabel => '消耗要因';

  @override
  String get boostersLabel => '後押し要因';

  @override
  String get propertyTrendTitle => '不動産のトレンド';

  @override
  String get buyingWindowsTitle => '購入に適した時期';

  @override
  String get constructionWindowsTitle => '建築に適した時期';

  @override
  String get maternalInherPctLabel => '母系からの相続割合';

  @override
  String get paternalInherPctLabel => '父系からの相続割合';

  @override
  String get multiHomePctLabel => '複数所有の割合';

  @override
  String get investmentPctLabel => '投資割合';

  @override
  String get vehicleProfileTitle => '乗物プロフィール';

  @override
  String get countLabel => '台数';

  @override
  String get firstAgeLabel => '最初の年齢';

  @override
  String get categoryLabel => 'カテゴリー';

  @override
  String get luxuryLabel => '高級志向';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return '生涯所有数：${count}・充足度：${pct}％';
  }

  @override
  String get pressureWord => 'プレッシャー';

  @override
  String get protectionWord => '保護';

  @override
  String get astrologicalWord => '占星術的';

  @override
  String get keyRisksHeader1 => '主な';

  @override
  String get keyRisksHeader2 => 'リスク';

  @override
  String get reportCopiedShort => 'レポートをコピーしました！';

  @override
  String get keyScoresLabel => '主なスコア';

  @override
  String allScoresCountLabel(int count) {
    return '全スコア（${count}）';
  }

  @override
  String get windowsWord => '好機';

  @override
  String get genericFailedMsg => '失敗しました';

  @override
  String get unknownWord => '不明';

  @override
  String selectKarmaChartsLabel(int max) {
    return '2～${max}件のチャートを選択';
  }

  @override
  String selectChartsLabelCount(int max) {
    return '${max}件のチャートを選択';
  }

  @override
  String runningAnalysisLabel(String label) {
    return '${label}分析を実行中...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'カルマのつながりを分析するために2～${max}件のチャートを選んでください';
  }

  @override
  String get pickMaleFemaleHint => '男性と女性のチャートを選んでください';

  @override
  String get personOneLabel => '人物1';

  @override
  String get personTwoLabel => '人物2';

  @override
  String get analysisFailedMsg => '分析に失敗しました';

  @override
  String analyzeChartsCountLabel(int count) {
    return '${count}件のチャートを分析';
  }

  @override
  String get contextGeneralLabel => '一般';

  @override
  String get contextLoveLabel => '恋愛';

  @override
  String get contextBusinessLabel => '事業';

  @override
  String get contextFamilyLabel => '家族';

  @override
  String get contextTeamLabel => 'チーム';

  @override
  String get contextFriendshipLabel => '友情';

  @override
  String get relationshipIntelTitle => '人間関係インテリジェンス';

  @override
  String analyzingChartsCountLabel(int count) {
    return '${count}件のチャートを分析中...';
  }

  @override
  String get relationshipContextLabel => '関係性のコンテキスト';

  @override
  String get kundliMilanReportTitle => 'クンダリー・ミランレポート';

  @override
  String get runningMilanAnalysisLabel => 'ミラン分析を実行中...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '${count}/2 選択済み';
  }

  @override
  String get runMilanAnalysisBtn => 'ミラン分析を実行';

  @override
  String get noChartsCreateFirst => 'チャートがありません。まず出生図を作成してください。';

  @override
  String get selectBirthChartAnalyze => '分析する出生図を選択してください';

  @override
  String get doshAnalysis => 'ドーシャ分析';

  @override
  String doshActiveCount(Object active, Object total) {
    return '確認した${total}個のうち${active}個が有効';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '確認した${total}個のヨーガのうち${active}個が有効';
  }

  @override
  String yogaActiveHeader(Object count) {
    return '有効なヨーガ（${count}）';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return '非活性のヨーガを隠す（${count}）';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return '非活性のヨーガを表示（${count}）';
  }

  @override
  String get loadFailed => '読み込みに失敗しました';

  @override
  String dashaDrillMd(Object planet) {
    return '${planet} MD → アンタルダシャー';
  }

  @override
  String dashaDrillAd(Object planet) {
    return '${planet} AD → プラティヤンタルダシャー';
  }

  @override
  String dashaDrillPd(Object planet) {
    return '${planet} PD → スークシュマダシャー';
  }

  @override
  String dashaDrillSub(Object planet) {
    return '${planet}のサブ期間';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return '出生支配星：${lord}・残り期間：${balance}年';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'ラグナ：${lagna}・残り期間：${balance}年';
  }

  @override
  String dashaYearsValue(Object years) {
    return '${years}年';
  }

  @override
  String get dashaCurrentPeriod => '現在のダシャー期間';

  @override
  String dashaAsOf(Object date) {
    return '基準日：${date}';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return '現在の期間で有効なヨーガ（${count}）';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return '現在の期間で有効なドーシャ（${count}）';
  }

  @override
  String get dashaNoYogasTriggered => '発動しているヨーガはありません';

  @override
  String get dashaNoDoshasTriggered => '発動しているドーシャはありません';

  @override
  String get divD1Name => 'ラーシ（D-1）';

  @override
  String get divD1Desc => '肉体的存在、すべての事柄';

  @override
  String get divD2Name => 'ホラ（D-2）';

  @override
  String get divD2Desc => '富、お金';

  @override
  String get divD3Name => 'ドレッカーナ（D-3）';

  @override
  String get divD3Desc => '兄弟姉妹、勇気';

  @override
  String get divD4Name => 'チャトゥルタムシャ（D-4）';

  @override
  String get divD4Desc => '不動産、住居、幸運';

  @override
  String get divD5Name => 'パンチャムシャ（D-5）';

  @override
  String get divD5Desc => '名声、権威、権力';

  @override
  String get divD6Name => 'シャシュタムシャ（D-6）';

  @override
  String get divD6Desc => '健康上のトラブル';

  @override
  String get divD7Name => 'サプタムシャ（D-7）';

  @override
  String get divD7Desc => '子供、孫';

  @override
  String get divD8Name => 'アシュタムシャ（D-8）';

  @override
  String get divD8Desc => '突然のトラブル、訴訟';

  @override
  String get divD9Name => 'ナヴァムシャ（D-9）';

  @override
  String get divD9Desc => '結婚、配偶者、ダルマ';

  @override
  String get divD10Name => 'ダシャムシャ（D-10）';

  @override
  String get divD10Desc => 'キャリア、職業';

  @override
  String get divD11Name => 'ルドラムシャ（D-11）';

  @override
  String get divD11Desc => '死、破壊';

  @override
  String get divD12Name => 'ドヴァーダシャムシャ（D-12）';

  @override
  String get divD12Desc => '両親、血縁者';

  @override
  String get divD16Name => 'ショーダシャムシャ（D-16）';

  @override
  String get divD16Desc => '乗物、快適さ、喜び';

  @override
  String get divD20Name => 'ヴィムシャムシャ（D-20）';

  @override
  String get divD20Desc => '精神的な事柄、宗教';

  @override
  String get divD24Name => 'チャトゥルヴィムシャムシャ（D-24）';

  @override
  String get divD24Desc => '学び、知識、教育';

  @override
  String get divD27Name => 'ナクシャトラムシャ（D-27）';

  @override
  String get divD27Desc => '強み、弱み、性質';

  @override
  String get divD30Name => 'トリンシャムシャ（D-30）';

  @override
  String get divD30Desc => '悪事、潜在意識、罰';

  @override
  String get divD40Name => 'カヴェーダムシャ（D-40）';

  @override
  String get divD40Desc => '吉凶（母方）';

  @override
  String get divD45Name => 'アクシャヴェーダムシャ（D-45）';

  @override
  String get divD45Desc => 'すべての事柄（父方）';

  @override
  String get divD60Name => 'シャシュティアムシャ（D-60）';

  @override
  String get divD60Desc => '前世のカルマ — 最も重要';

  @override
  String get lifeAreaCareer => 'キャリア';

  @override
  String get lifeAreaWealth => '富';

  @override
  String get lifeAreaMarriage => '結婚';

  @override
  String get lifeAreaHealth => '健康';

  @override
  String get lifeAreaSpirituality => '精神性';

  @override
  String lifeAreaGrade(Object grade) {
    return '評価：${grade}';
  }

  @override
  String get lifeAreaFactorsLabel => '要因：';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return 'ナクシャトラ：${nakshatra}（${pada}）';
  }

  @override
  String planetNakLord(Object lord) {
    return 'NL：${lord}';
  }

  @override
  String planetLongitude(Object value) {
    return '経度：${value}°';
  }

  @override
  String get chakraOverallHealth => '全体的な健康';

  @override
  String get careerWord => 'キャリア';

  @override
  String get failedToLoad => '読み込みに失敗しました';

  @override
  String get kundliAscendantLagna => 'アセンダント（ラグナ）';

  @override
  String get kundliMoonSignRashi => '月サイン（ラーシ）';

  @override
  String get kundliSunSign => '太陽サイン';

  @override
  String kundliEngineLabel(Object engine) {
    return 'エンジン：${engine}';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return '度数：${degree}°　・　ナクシャトラ：${nakshatra}（${pada}）';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'ナクシャトラ支配星：${lord}　・　品位：${dignity}';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return '${base}チャート — ${sign}';
  }

  @override
  String kundliBaseChart(Object base) {
    return '${base}チャート';
  }

  @override
  String get careerSummary => 'キャリアサマリー';

  @override
  String get phase => '段階';

  @override
  String get confidenceLabel => '信頼度';

  @override
  String get careerScores => 'キャリアスコア';

  @override
  String get stabilityLabel => '安定性';

  @override
  String get growthLabel => '成長';

  @override
  String get gradeExcellent => '優秀';

  @override
  String get gradeGood => '良好';

  @override
  String get gradeAverage => '平均';

  @override
  String get gradeBelowAvg => '平均以下';

  @override
  String get gradeWeak => '弱い';

  @override
  String get careerTypeDomain => 'キャリアと分野';

  @override
  String get careerTimeline => 'キャリアのタイムライン';

  @override
  String dashaLabel(Object dasha) {
    return 'ダシャー：${dasha}';
  }

  @override
  String get improvementSuggestions => '改善のための提案';

  @override
  String get chartDetails => 'チャートの詳細';

  @override
  String get keyHousesCareer => '重要なハウス（キャリア）';

  @override
  String get keyCareerPlanets => '重要なキャリア惑星';

  @override
  String get empty => 'なし';

  @override
  String get guna => 'グナ';

  @override
  String get dasha => 'ダシャー';

  @override
  String get satwik => 'サットヴィック';

  @override
  String get rajasik => 'ラージャシック';

  @override
  String get tamasik => 'タマシック';

  @override
  String get charGroupCorePersonality => '中核的な人格';

  @override
  String get charGroupTrustHonesty => '信頼と誠実さ';

  @override
  String get charGroupLoyaltyCommitment => '忠誠心とコミットメント';

  @override
  String get charGroupStrategicPrivacy => '戦略性とプライバシー';

  @override
  String get charGroupFinancial => '金銭面';

  @override
  String get charGroupAngerConflict => '怒りと対立';

  @override
  String get charGroupMoralDharmic => '道徳とダルマ';

  @override
  String get charGroupIntellectCommunication => '知性とコミュニケーション';

  @override
  String get charGroupEmotionalProfile => '感情プロフィール';

  @override
  String get charGroupMentalHealth => 'メンタルヘルス';

  @override
  String get charGroupRomantic => '恋愛';

  @override
  String get charGroupMarriageFamily => '結婚と家族';

  @override
  String get charGroupOverallLife => '人生全般';

  @override
  String get grahaDrishti => 'グラハ・ドリシュティ（惑星アスペクト）';

  @override
  String get grahaDrishtiSubtitle => '誰が誰にアスペクトを与えるか（％）';

  @override
  String get lagnaAspectsReceived => 'ラグナが受けるアスペクト';

  @override
  String get rashiDrishti => 'ラーシ・ドリシュティ（サインアスペクト）';

  @override
  String get shadbalaRupas => 'ルーパ';

  @override
  String get bhavaHouse1 => '自己／身体';

  @override
  String get bhavaHouse2 => '富／家族';

  @override
  String get bhavaHouse3 => '兄弟姉妹／勇気';

  @override
  String get bhavaHouse4 => '家庭／母親';

  @override
  String get bhavaHouse5 => '子供／知性';

  @override
  String get bhavaHouse6 => '敵／健康';

  @override
  String get bhavaHouse7 => '結婚／パートナー';

  @override
  String get bhavaHouse8 => '寿命';

  @override
  String get bhavaHouse9 => '幸運／師（グル）';

  @override
  String get bhavaHouse10 => 'キャリア／父親';

  @override
  String get bhavaHouse11 => '利得／友人';

  @override
  String get bhavaHouse12 => '損失／解脱';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '${sign}・支配星：${lord}';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV：${value}';
  }

  @override
  String get sarvaAshtakavarga => 'サルヴァ・アシュタカヴァルガ（SAV）';

  @override
  String savSubtitle(Object total, Object avg) {
    return '合計：${total}レーカ（平均サイン＝${avg}）';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '${planet} — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return '合計：${total}レーカ・出生サインでのスコア：${score}';
  }

  @override
  String get today => '今日';

  @override
  String gocharTransitScores(Object date) {
    return 'ゴチャール（トランジットスコア）— ${date}';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return '生来の月：${sign}';
  }

  @override
  String get gocharBest => '最良';

  @override
  String get gocharWorst => '最悪';

  @override
  String copiedOpening(Object ai) {
    return 'コピーしました！${ai}を開いています...';
  }

  @override
  String get openLink => '開く ↗';

  @override
  String get discussReportWithAI => 'このレポートをAIに相談する';

  @override
  String get reliabilityHigh => '高い信頼性';

  @override
  String get reliabilityModerate => '中程度の信頼性';

  @override
  String get reliabilityLow => '低め — 参考程度に';

  @override
  String get reliabilityGoodEdu => '良好な信頼性・D-24で検証済み';

  @override
  String get relationshipWord => '人間関係';

  @override
  String get intelligenceWord => 'インテリジェンス';

  @override
  String get relationshipIntelligence => '人間関係インテリジェンス';

  @override
  String get typeLabel => 'タイプ';

  @override
  String get trustLabel => '信頼';

  @override
  String get dhokaRisk => '裏切りリスク';

  @override
  String get powerLabel => '力関係';

  @override
  String get integrity => '誠実さ';

  @override
  String get warmth => '温かさ';

  @override
  String get trustWord => '信頼';

  @override
  String get assertLabel => '自己主張';

  @override
  String get character => '性格';

  @override
  String get love => '恋愛';

  @override
  String get businessWord => '事業';

  @override
  String get karmic => 'カルマ';

  @override
  String get enmityRisk => '敵対リスク';

  @override
  String get hdrChartProfiles => 'チャートプロフィール';

  @override
  String get hdrPairwiseAnalysis => 'ペア分析';

  @override
  String get hdrCriticalPatterns => '重要なパターン';

  @override
  String get hdrGroupRecommendations => 'グループへの提案';

  @override
  String get sharedPractices => '共有すべき習慣';

  @override
  String get hdrIndividualGuidance => '個人へのアドバイス';

  @override
  String get growthAreas => '成長すべき分野';

  @override
  String get hdrCoreTheme => '中心テーマ';

  @override
  String get growthOriented => '成長志向';

  @override
  String get groupTheme => 'グループテーマ';

  @override
  String get compatibility => '相性';

  @override
  String get unifiedScoreLabel => '統合スコア';

  @override
  String get ashtakoot => 'アシュタクート';

  @override
  String get probability => '確率';

  @override
  String get hdrAshtakootSummary => 'アシュタクートのサマリー';

  @override
  String get hdrGunBreakdown => '8グナの内訳';

  @override
  String get hdrMangalDosh => 'マンガル・ドーシャ';

  @override
  String get hdrD9CrossChart => 'D-9クロスチャート';

  @override
  String get d9Compatibility => 'D-9相性';

  @override
  String get hdrDomainCompatibility => '分野別相性';

  @override
  String get emotional => '感情面';

  @override
  String get intellectual => '知的な面';

  @override
  String get spiritual => '精神面';

  @override
  String get financial => '金銭面';

  @override
  String get domestic => '家庭面';

  @override
  String get communicationWord => 'コミュニケーション';

  @override
  String get sharedDharma => '共有するダルマ';

  @override
  String get familyCreation => '家族の形成';

  @override
  String get hdrMarriageTiming => '結婚のタイミング';

  @override
  String get jointMarriageWindows => '共通の結婚適齢期';

  @override
  String get engagementWindows => '婚約に適した時期';

  @override
  String get recommendedLabel => 'おすすめ';

  @override
  String get hdrKeyRisks => '主なリスク';

  @override
  String get hdrFinalVerdict => '最終判定';

  @override
  String get marriageVerdict => '結婚の判定';

  @override
  String get educationWord => '教育';

  @override
  String get learningSuffix => 'と学習';

  @override
  String get coreEducationScores => '主な教育スコア';

  @override
  String get academicSuccess => '学業での成功';

  @override
  String get learningCapacity => '学習能力';

  @override
  String get memory => '記憶力';

  @override
  String get intelligence => '知性';

  @override
  String get research => '研究';

  @override
  String get hdrIntellectualProfile => '知的プロフィール';

  @override
  String get learningSignature => '学習のシグネチャー';

  @override
  String get hdrSubjectKaraka => '科目カーラカ';

  @override
  String get hdrHouseFoundations => 'ハウスの基盤';

  @override
  String get hdrMercuryJupiter => '水星と木星';

  @override
  String get hdrEducationYogas => '教育のヨーガ';

  @override
  String get hdrDivisionalValidation => '分割図による検証';

  @override
  String get standing => '位置づけ';

  @override
  String get hdrSubjectRanking => '科目のランキング';

  @override
  String get hdrDegreeLikelihood => '学位取得の可能性';

  @override
  String get hdrStudyPeriods => '学習の時期';

  @override
  String get earlySchooling => '幼少期の就学';

  @override
  String get higherEducation => '高等教育';

  @override
  String get postgradResearch => '大学院・研究';

  @override
  String get hdrLearningPreferences => '学習の好み';

  @override
  String get hdrChallengesGifts => '課題と才能';

  @override
  String get challenges => '課題';

  @override
  String get cognitiveGifts => '認知的な才能';

  @override
  String get naturalAbilities => '生まれ持った能力';

  @override
  String get hdrSaraswatiRemedies => 'サラスヴァティのレメディ';

  @override
  String get studentVerdict => '学生としての判定';

  @override
  String get educationCareerLinkage => '教育 → キャリアのつながり';

  @override
  String get startupSuffix => 'とスタートアップ';

  @override
  String get coreBusinessScores => '主な事業スコア';

  @override
  String get overallBusiness => '総合的な事業運';

  @override
  String get ventureSuccess => '事業の成功';

  @override
  String get eleventhHouse => '11ハウス';

  @override
  String get gains => '利得';

  @override
  String get investor => '投資家';

  @override
  String get hdrFounderArchetype => '創業者アーキタイプ';

  @override
  String get hdrTenthEleventhHouses => '10ハウスと11ハウス';

  @override
  String get hdrBusinessYogas => '事業のヨーガ';

  @override
  String get hdrRecommendedDomains => 'おすすめの分野';

  @override
  String get hdrBusinessStyle => '事業スタイル';

  @override
  String get hdrFounderSkills => '創業者のスキル';

  @override
  String get hdrFundingProfile => '資金調達プロフィール';

  @override
  String get recommendedPath => 'おすすめの方法';

  @override
  String get investorAttract => '投資家からの魅力';

  @override
  String get familyBacking => '家族からのサポート';

  @override
  String get hybridViability => '両立の可能性';

  @override
  String get launchWindow => '起業に適した時期';

  @override
  String get scaleWindow => '拡大に適した時期';

  @override
  String get hdrBusinessRisks => '事業のリスク';

  @override
  String get recoveryCapacity => '回復力';

  @override
  String get hdrRemediesSolutions => 'レメディと解決策';

  @override
  String get aiConnectionLost => '接続が失われました。もう一度お試しください。';

  @override
  String get aiSomethingWrong => '問題が発生しました';

  @override
  String get aiNoResponse => '応答がありません';

  @override
  String get aiConnectionError => '接続エラーです。もう一度お試しください。';

  @override
  String get aiAutoDetect => '自動検出';

  @override
  String aiAutoArrow(String lang) {
    return '自動 → ${lang}';
  }

  @override
  String aiLanguageLabel(String lang) {
    return '言語：${lang}';
  }

  @override
  String get aiNoBirthCharts => '出生図が見つかりません';

  @override
  String get aiCreateChartFirst => 'AIとチャットするには、まず出生図を作成してください';

  @override
  String get aiSelectChartBegin => '分析を始めるには出生図を選択してください';

  @override
  String aiAnalyzingName(String name) {
    return '分析中：${name}';
  }

  @override
  String get aiChange => '変更';

  @override
  String get aiAnalyzingChart => 'あなたのチャートを分析中...';

  @override
  String get aiAskStarsHint => '星に何でも聞いてみましょう...';

  @override
  String get aiSuggestedFollowups => 'おすすめの質問';

  @override
  String get aiThinking => '考え中...';

  @override
  String get aiThanks => 'ありがとうございます！';

  @override
  String get aiFeedbackNoted => 'フィードバックを受け付けました';

  @override
  String get svcAll => 'すべて';

  @override
  String get svcNoServices => '利用可能なサービスがありません';

  @override
  String get svcFree => '無料';

  @override
  String get astroFailedStartCall => '通話を開始できませんでした';

  @override
  String get astroFailedStartChat => 'チャットを開始できませんでした';

  @override
  String astroErrorDetail(String error) {
    return 'エラー：${error}';
  }

  @override
  String get astroExperience => '経験';

  @override
  String get astroSessions => 'セッション数';

  @override
  String get astroMinutes => '分数';

  @override
  String get astroAbout => '紹介';

  @override
  String get astroLanguages => '対応言語';

  @override
  String get astroRateCard => '料金表';

  @override
  String get astroVoice => '音声';

  @override
  String astroReviews(int count) {
    return 'レビュー（${count}）';
  }

  @override
  String get astroNoReviews => 'まだレビューがありません';

  @override
  String get astroAnonymous => '匿名';

  @override
  String get forgotPasswordSubtitle => 'メールアドレスを入力してください。\nパスワード再設定用のリンクをお送りします。';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => 'リンクを再送信';

  @override
  String get appName => 'Nakshatralogy';

  @override
  String get cosmicJourneyAwaits => 'あなたの宇宙の旅が始まります';

  @override
  String get home => 'ホーム';

  @override
  String get astrologers => '占星術師';

  @override
  String get services => 'サービス';

  @override
  String get wallet => 'ウォレット';

  @override
  String get profile => 'プロフィール';

  @override
  String get live => 'ライブ';

  @override
  String get kundli => 'Kundli';

  @override
  String get chat => 'チャット';

  @override
  String get call => '通話';

  @override
  String get video => 'ビデオ';

  @override
  String get signIn => 'サインイン';

  @override
  String get createAccount => 'アカウントを作成';

  @override
  String get email => 'メールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String get confirmPassword => 'パスワードの確認';

  @override
  String get fullName => '氏名';

  @override
  String get phone => '電話番号（任意）';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get sendResetLink => '再設定リンクを送信';

  @override
  String get backToSignIn => 'サインインに戻る';

  @override
  String get dontHaveAccount => 'アカウントをお持ちでない方';

  @override
  String get alreadyHaveAccount => 'すでにアカウントをお持ちの方';

  @override
  String get continueGoogle => 'Googleで続ける';

  @override
  String get required => '必須';

  @override
  String get minSixChars => '6文字以上';

  @override
  String get passwordsMismatch => 'パスワードが一致しません';

  @override
  String get validEmailRequired => '有効なメールアドレスが必要です';

  @override
  String get loginFailed => 'ログインに失敗しました';

  @override
  String get signupFailed => '登録に失敗しました';

  @override
  String get welcomeBack => 'おかえりなさい';

  @override
  String get todaysHoroscope => '今日のホロスコープ';

  @override
  String get todaysRashi => '今日のラーシ';

  @override
  String get tapDetails => 'タップして詳細を見る';

  @override
  String get allServices => 'すべてのサービス';

  @override
  String get seeAll => 'すべて見る';

  @override
  String get topAstrologers => '人気の占星術師';

  @override
  String get onlineExperts => '相談可能なオンラインの専門家';

  @override
  String get searchAstrologers => '占星術師を検索...';

  @override
  String get noAstrologersFound => '占星術師が見つかりません';

  @override
  String get online => 'オンライン';

  @override
  String get offline => 'オフライン';

  @override
  String get busy => '取り込み中';

  @override
  String get perMin => '／分';

  @override
  String get noCharts => 'まだ出生図がありません';

  @override
  String get createFirst => '最初のジャンマ・クンダリーを作成しましょう';

  @override
  String get createChart => 'チャートを作成';

  @override
  String get newBirthChart => '新しい出生図';

  @override
  String get clientName => 'クライアント名';

  @override
  String get gender => '性別';

  @override
  String get male => '男性';

  @override
  String get female => '女性';

  @override
  String get other => 'その他';

  @override
  String get dateOfBirth => '生年月日';

  @override
  String get timeOfBirth => '出生時刻';

  @override
  String get birthPlace => '出生地';

  @override
  String get birthPlaceHint => '都市名を入力して検索...';

  @override
  String get generateKundli => 'Kundliを生成';

  @override
  String get birthChartCreated => '出生図を作成しました！';

  @override
  String get deleteChart => 'チャートを削除しますか？';

  @override
  String get cannotUndo => 'この操作は元に戻せません。';

  @override
  String get primary => 'メイン';

  @override
  String get viewKundli => 'Kundliを見る';

  @override
  String get completeBirthChart => '出生図の詳細';

  @override
  String get birthDetails => '出生の詳細';

  @override
  String get name => '名前';

  @override
  String get dob => '生年月日';

  @override
  String get tob => '出生時刻';

  @override
  String get place => '場所';

  @override
  String get summary => 'サマリー';

  @override
  String get planets => '惑星';

  @override
  String get divisions => '分割図';

  @override
  String get vimshottari => 'ヴィムショッタリー';

  @override
  String get moola => 'ムーラ';

  @override
  String get gochar => 'ゴチャール';

  @override
  String get dosh => 'ドーシャ';

  @override
  String get yoga => 'ヨーガ';

  @override
  String get shadbala => 'シャドバラ';

  @override
  String get ashtakavarga => 'アシュタカヴァルガ';

  @override
  String get aspects => 'アスペクト';

  @override
  String get lifeAreas => '人生の分野';

  @override
  String get bhava => 'バーヴァ';

  @override
  String get chakras => 'チャクラ';

  @override
  String get dashaActive => '現在のダシャー';

  @override
  String get lagna => 'ラグナ';

  @override
  String get moon => '月';

  @override
  String get sun => '太陽';

  @override
  String get premiumSection => 'プレミアムセクション';

  @override
  String get unlockReading => '詳細な分析を見るには、このリーディングをアンロックしてください。';

  @override
  String get unlock => 'アンロック';

  @override
  String get retrograde => '逆行';

  @override
  String get combust => 'コンバスト';

  @override
  String get vargottama => 'ヴァルゴッタマ';

  @override
  String get exalted => '高揚';

  @override
  String get debilitated => '減衰';

  @override
  String get addBalance => '残高を追加';

  @override
  String get amount => '金額';

  @override
  String get walletBalance => 'ウォレット残高';

  @override
  String get recharge => 'チャージ';

  @override
  String get bonus => 'ボーナス';

  @override
  String get serviceLabel => 'サービス';

  @override
  String get refund => '返金';

  @override
  String get noTransactions => '取引履歴がありません';

  @override
  String get editProfile => 'プロフィールを編集';

  @override
  String get savedAstrologers => '保存した占星術師';

  @override
  String get noSavedAstrologers => '保存した占星術師がまだいません';

  @override
  String get myOrders => '注文履歴';

  @override
  String get communicationHistory => 'コミュニケーション履歴';

  @override
  String get chatHistory => 'チャット履歴';

  @override
  String get callHistory => '通話履歴';

  @override
  String get logout => 'ログアウト';

  @override
  String get chatMessages => 'チャットメッセージ';

  @override
  String get typeMessage => 'メッセージを入力...';

  @override
  String get sessionEnded => 'セッション終了';

  @override
  String get endChat => 'チャットを終了しますか？';

  @override
  String get endChatConfirm => 'このチャットセッションを終了してもよろしいですか？';

  @override
  String get sendPhoto => '写真を送信';

  @override
  String get sendPDF => 'PDFを送信';

  @override
  String get upload => 'アップロード';

  @override
  String get fileNotFound => 'ファイルが見つかりません';

  @override
  String get voiceCall => '音声通話';

  @override
  String get videoCall => 'ビデオ通話';

  @override
  String get ringing => '呼び出し中...';

  @override
  String get connected => '接続済み';

  @override
  String get endCall => '通話を終了';

  @override
  String get mute => 'ミュート';

  @override
  String get unmute => 'ミュート解除';

  @override
  String get speaker => 'スピーカー';

  @override
  String get camera => 'カメラ';

  @override
  String get flip => '切り替え';

  @override
  String get liveStreams => 'ライブ配信';

  @override
  String get noLiveStreams => '現在ライブ配信はありません';

  @override
  String get astrologerUnavailable => '占星術師が利用できません。配信を終了します。';

  @override
  String get streamEnded => '配信が終了しました';

  @override
  String get superChat => 'スーパーチャット';

  @override
  String get sendGift => 'ギフトを送る';

  @override
  String get goBack => '戻る';

  @override
  String get appPermissions => 'アプリの権限';

  @override
  String get grantPermissions => '権限を許可';

  @override
  String get skipForNow => '今はスキップ';

  @override
  String get microphone => 'マイク';

  @override
  String get notifications => '通知';

  @override
  String get storage => 'ストレージ';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get edit => '編集';

  @override
  String get delete => '削除';

  @override
  String get retry => '再試行';

  @override
  String get send => '送信';

  @override
  String get refresh => '更新';

  @override
  String get loading => '読み込み中...';

  @override
  String get noData => 'データがありません';

  @override
  String get error => 'エラー';

  @override
  String get success => '成功';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get language => '言語';

  @override
  String get english => 'English';

  @override
  String get myDetails => 'マイ情報';

  @override
  String get myKundlis => 'マイKundli';

  @override
  String get walletRecharge => 'ウォレットとチャージ';

  @override
  String get consultationHistory => '相談履歴';

  @override
  String get helpSupport => 'ヘルプとサポート';

  @override
  String get biometricLogin => '生体認証ログイン';

  @override
  String get pastVoiceConsultations => '過去の音声相談';

  @override
  String get pastTextConversations => '過去のテキスト会話';

  @override
  String get comingSoon => '近日公開';

  @override
  String get totalCredit => '入金合計';

  @override
  String get totalDebit => '出金合計';

  @override
  String get statement => '明細';

  @override
  String get allTypes => 'すべての種類';

  @override
  String get prev => '前へ';

  @override
  String get next => '次へ';

  @override
  String get allInsights => 'すべてのインサイト';

  @override
  String get yourCompleteReading => 'あなたの完全なリーディング';

  @override
  String get expertEngines => '専門エンジン';

  @override
  String get eachInsightConsultation => '各インサイトは1回の完全な相談に相当します';

  @override
  String get engines => 'エンジン';

  @override
  String get dataPoints => 'データポイント';

  @override
  String get singleChart => '単一チャート';

  @override
  String get careerPurpose => 'キャリアと目的';

  @override
  String get wealthAssets => '富と資産';

  @override
  String get loveRelationships => '恋愛と人間関係';

  @override
  String get healthWellness => '健康とウェルネス';

  @override
  String get soulKarma => '魂とカルマ';

  @override
  String get specialistReports => '専門レポート';

  @override
  String get searchByNameSpeciality => '名前や専門分野で検索...';

  @override
  String get sortedByRating => '評価順に並び替え';

  @override
  String get initiatingChat => 'チャットを開始中...';

  @override
  String get startingCall => '通話を開始中...';

  @override
  String get yrs => '年';

  @override
  String get chatWithAISpecialist => 'AI専門家とチャット';

  @override
  String get tapToStart => 'タップして開始';

  @override
  String get astrologer => '占星術師';

  @override
  String get reports => 'レポート';

  @override
  String get milan => 'ミラン';

  @override
  String get forecast => '運勢予測';

  @override
  String get rashi => 'ラーシ';

  @override
  String get jupiterFavorsBold => '木星が大胆な行動を後押しします';

  @override
  String get careerIlluminated => 'あなたのキャリア分野が輝いています — 直感を信じましょう。';

  @override
  String get todaysForecast => '今日の運勢予測';

  @override
  String get engCareer => 'キャリアと仕事';

  @override
  String get engBusiness => '事業とスタートアップ';

  @override
  String get engEducation => '教育と学習';

  @override
  String get engLifePath => '人生の道と運勢';

  @override
  String get engWealth => '富と金融';

  @override
  String get engDebt => '負債と回復';

  @override
  String get engProperty => '不動産と資産';

  @override
  String get engLegal => '法律とトラブル';

  @override
  String get engLove => '恋愛とロマンス';

  @override
  String get engMarriage => '結婚と家族';

  @override
  String get engKundliMilan => 'クンダリー・ミラン';

  @override
  String get engRelationship => '人間関係インテリジェンス';

  @override
  String get engLoveCompat => '恋愛相性';

  @override
  String get engChildProb => '子宝運';

  @override
  String get engHealth => '健康とウェルネス';

  @override
  String get engMental => 'メンタルとストレス';

  @override
  String get engCharacter => '性格分析';

  @override
  String get engPastLife => '前世とカルマ';

  @override
  String get engKarmaLink => 'カルマ連関';

  @override
  String get noChatSessions => 'まだチャットセッションがありません';

  @override
  String get chatAppearHere => '占星術師とのやり取りがここに表示されます。';

  @override
  String get noCallsYet => 'まだ通話がありません';

  @override
  String get callAppearHere => '占星術師との通話履歴がここに表示されます。';

  @override
  String get chatWith => 'チャット相手';

  @override
  String get msgs => '件のメッセージ';

  @override
  String get voiceCallLabel => '音声通話';

  @override
  String get videoCallLabel => 'ビデオ通話';

  @override
  String get pullToRefresh => '下に引っ張って更新';

  @override
  String get sessionExpired => 'セッションの有効期限が切れました';

  @override
  String get connectionFailed => '接続に失敗しました';

  @override
  String get callActive => '通話中';

  @override
  String get lessThanOneMin => '残り1分未満';

  @override
  String get noMessages => 'このセッションにメッセージはありません';

  @override
  String get gocharForAllSigns => '全12サインの今日のゴチャール';

  @override
  String get selectChart => '分析するチャートを選択';

  @override
  String get selectTwoCharts => '2つのチャートを選択';

  @override
  String get analyzing => '分析中...';

  @override
  String get browseAstrologers => '占星術師を探す';

  @override
  String get probableNumber => '予想される人数';

  @override
  String get genderTendency => '性別の傾向';

  @override
  String get son => '息子';

  @override
  String get daughter => '娘';

  @override
  String get occupants => '在住惑星';

  @override
  String get beneficAspects => '吉星のアスペクト';

  @override
  String get maleficAspects => '凶星のアスペクト';

  @override
  String get nextFavorableWindow => '次の好機';

  @override
  String get totalDoshaPenalty => 'ドーシャによる総ペナルティ';

  @override
  String get cancellationFactors => '相殺要因';

  @override
  String get combinedFertility => '総合的な妊娠力の兆候';

  @override
  String get planetPositions => '惑星の位置';

  @override
  String get bestWindows => '最良の好機';

  @override
  String get worstWindows => '最悪の時期';

  @override
  String get scoreComponents => 'スコアの構成要素';

  @override
  String get topOpportunities => '主なチャンス';

  @override
  String get topRisks => '主なリスク';

  @override
  String get remedies => 'レメディ';

  @override
  String get keyInsights => '主な洞察';

  @override
  String get overallVerdict => '総合判定';

  @override
  String get venusContacts => '金星クロスコンタクト';

  @override
  String get contact => 'コンタクト';

  @override
  String get effect => '効果';

  @override
  String get moonSignCompat => '月サインの相性';

  @override
  String get hisMoon => '男性の月';

  @override
  String get herMoon => '女性の月';

  @override
  String get nakshatraCompat => 'ナクシャトラ相性';

  @override
  String get ketuContacts => 'ケートゥコンタクト';

  @override
  String get rahuContacts => 'ラーフコンタクト';

  @override
  String get pastLifeIndication => '前世の兆候';

  @override
  String get totalChallengePenalty => '課題による総ペナルティ';

  @override
  String get manifestation => '顕現';

  @override
  String get cancellation => '相殺';

  @override
  String get navigation => '対処法';

  @override
  String get potentialStrengths => '潜在的な強み';

  @override
  String get areasToNurture => '育むべき領域';

  @override
  String get relationshipGuidance => '関係性へのアドバイス';

  @override
  String get detailedSummary => '詳細サマリー';

  @override
  String get discussWithAI => 'AIに相談する';

  @override
  String get planet => '惑星';

  @override
  String get sign => 'サイン';

  @override
  String get house => 'ハウス';

  @override
  String get strength => '強さ';

  @override
  String get copy => 'コピー';

  @override
  String get confidence => '信頼度';

  @override
  String get d7Saptamsa => 'D7サプタムシャ';

  @override
  String get numberExplanation => '人数についての説明';

  @override
  String get genderExplanation => '性別についての説明';

  @override
  String get inFifth => '5ハウスにあるか？';

  @override
  String get primaryArchetype => '主なアーキタイプ';

  @override
  String get mitigation => '対処法';

  @override
  String get soulCareerAlign => '魂とキャリアの一致';

  @override
  String get favorablePeriods => '好ましい時期';

  @override
  String get challengingPeriods => '困難な時期';

  @override
  String get keyHouses => '重要なハウス';

  @override
  String get keyPlanets => '重要な惑星';

  @override
  String get characterOverview => '性格の概要';

  @override
  String get noYogasActive => '現在このチャートで活性化しているヨーガはありません。';

  @override
  String get basedOnPlanetStrengths => '惑星の強さとハウス配置に基づく';

  @override
  String get basedOnTransits => '現在の惑星トランジットに基づく';

  @override
  String get currentPlanetPositions => 'あなたのサインを1ハウスとした現在の惑星位置';

  @override
  String get favorablePeriodAdvice => '好機です — キャリアの成長と人間関係に注力しましょう。';

  @override
  String get noClassicalYogas => '古典的な学びのヨーガはありませんが、成功は継続的な努力によってもたらされます。';

  @override
  String get walletDeduction => '金額はウォレットから引き落とされます';

  @override
  String get bhakootAxis => 'バクート軸';

  @override
  String get basis => '根拠';

  @override
  String get selectChartsForMilan => 'ミラン分析のために2つのチャートを選択';

  @override
  String get selectMultiCharts => '2～5件のチャートを選択';

  @override
  String get running => '進行中';

  @override
  String get past => '過去';

  @override
  String get topActiveDoshas => '主な有効なドーシャ';

  @override
  String get allDoshas => 'すべてのドーシャ';

  @override
  String get activeYogas => '有効なヨーガ';

  @override
  String get activeDoshas => '有効なドーシャ';

  @override
  String get yogaAnalysis => 'ヨーガ分析';

  @override
  String get factors => '要因';

  @override
  String get dominantPlanet => '優勢な惑星';

  @override
  String get startSession => 'セッションを開始';

  @override
  String get notesSaved => 'メモを保存しました';

  @override
  String get unlocked => 'アンロックしました！お楽しみください。';

  @override
  String get todaysGochar => '今日のゴチャール';

  @override
  String get todaysTransitChart => '今日のトランジットチャート';

  @override
  String get lifeAreaPredictions => '人生分野別の予測';

  @override
  String get strengths => '強み';

  @override
  String get weaknesses => '弱み';

  @override
  String get ruledBy => '支配星';

  @override
  String get kundliMilan => 'クンダリー・ミラン';

  @override
  String get startKundliMilan => 'クンダリー・ミランを開始';

  @override
  String get recommendations => 'おすすめ';

  @override
  String get cancellations => '相殺';

  @override
  String get dashaSync => 'ダシャーの同調';

  @override
  String get transitMarriageWindows => 'トランジットによる結婚適齢期';

  @override
  String get overlappingWindows => '重なり合う結婚適齢期';

  @override
  String get overallStrength => '総合的な強さ';

  @override
  String get stability => '安定性';

  @override
  String get growth => '成長';

  @override
  String get clarity => '明瞭さ';

  @override
  String get recognition => '評価';

  @override
  String get satisfaction => '満足度';

  @override
  String get verdict => '判定';

  @override
  String get topRoles => '主な役割';

  @override
  String get areasForGrowth => '成長すべき分野';

  @override
  String get bestIndustries => '最適な業界';

  @override
  String get employment => '雇用';

  @override
  String get entrepreneurship => '起業';

  @override
  String get freelance => 'フリーランス';

  @override
  String get portfolio => '複合ポートフォリオ';

  @override
  String get burnoutRisk => '燃え尽きリスク';

  @override
  String get careerStagnation => 'キャリアの停滞';

  @override
  String get workplaceConflict => '職場での対立';

  @override
  String get positioning => 'ポジショニング';

  @override
  String get skillDevelopment => 'スキル開発';

  @override
  String get network => '人脈';

  @override
  String get visibility => '可視性';

  @override
  String get lagnaLord => 'ラグナ支配星';

  @override
  String get tenthLord => '10ハウス支配星';

  @override
  String get lord => '支配星';

  @override
  String get lordPlacedIn => '支配星の配置先';

  @override
  String get lordDignity => '支配星の品位';

  @override
  String get d9Dignity => 'D9における品位';

  @override
  String get careerAnalysis => 'キャリア分析';

  @override
  String get launchWindows => '始動に適した時期';

  @override
  String get peakWindows => 'ピーク期';

  @override
  String get promotionWindows => '昇進に適した時期';

  @override
  String get riskWindows => 'リスクのある時期';

  @override
  String get timingWindows => 'タイミングの好機';

  @override
  String get careerRisks => 'キャリアのリスク';

  @override
  String get astrologicalRemedies => '占星術的なレメディ';

  @override
  String get practicalSolutions => '実践的な解決策';

  @override
  String get analysisConfidence => '分析の信頼度';

  @override
  String get careerArchetype => 'キャリアのアーキタイプ';

  @override
  String get workStructure => '働き方の構造';

  @override
  String get teamLeadership => 'チームリーダーシップ';

  @override
  String get idealEnvironment => '理想的な環境';

  @override
  String get idealOrgSize => '理想的な組織規模';

  @override
  String get fitScore => '適性スコア';

  @override
  String get recommended => 'おすすめ';

  @override
  String get divisionalValidation => '分割図による検証';

  @override
  String get houseAnalysis => 'ハウス分析';

  @override
  String get jaiminiKarakas => 'ジャイミニ・カーラカ';

  @override
  String get copyFullReport => 'レポートデータ全体をコピー';

  @override
  String get reportCopied => 'レポートデータをコピーしました！';
}
